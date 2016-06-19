require 'minitest/autorun'
require 'dropbox'

class DropboxUsersTest < Minitest::Test
  def setup
    @client = Dropbox::Client.new(ENV['DROPBOX_SDK_ACCESS_TOKEN'])
  end

  def test_get_account
    id = @client.get_current_account.account_id
    account = @client.get_account(id)

    assert account.is_a?(Dropbox::BasicAccount)
    assert_equal id, account.account_id
  end

  def test_get_account_error
    assert_raises(Dropbox::APIError) do
      @client.get_account('invalid_id')
    end
  end

  def test_get_current_account
    account = @client.get_current_account

    assert account.is_a?(Dropbox::FullAccount)
    assert_match /^dbid:[a-z0-9_-]+$/i, account.account_id
    assert_equal 'Dylan Waits', account.display_name
    assert_equal true, account.email_verified
    assert_equal false, account.disabled
  end

end
