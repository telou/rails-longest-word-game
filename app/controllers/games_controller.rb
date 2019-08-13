require 'open-uri'

class GamesController < ApplicationController
  def new
    # display a new random grid and a form
    # alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    alphabet = ('A'..'Z').to_a
    @letters = alphabet.sample(10)
  end

  def score
    # form will be submitted with a POST to the score, to generate a score
    @score = session[:score] || 0
    @letters = params[:collected_input].scan(/\w/)
    @word = params[:word].upcase
    if !dict_check(parse_page)
      @message = "Sorry, but #{@word} does not seem to be a valid English word..."
    elsif dict_check(parse_page) && !inc_word(@word, @letters)
      @message = "Sorry but #{@word} can't be built out of #{@letters}"
    elsif dict_check(parse_page) && inc_word(@word, @letters)
      @message = "Congratulations! #{@word} is a valid English word!"
      session[:score] += @word.length
    end
  end

  def parse_page
    page_text = open("https://wagon-dictionary.herokuapp.com/#{@word}").read
    parsed_page = JSON.parse(page_text)
    return parsed_page
  end

  def dict_check(parsed_page)
    parsed_page["found"] == true
  end

  def inc_word(attempt, letters)
    attemptarr = attempt.split(//)
    (attemptarr - letters).empty?
  end
end
