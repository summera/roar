require 'test_helper'
require 'assertions'
require 'roar/representer/transport/faraday'

class FaradayHttpTransportTest < MiniTest::Spec
  describe 'FaradayHttpTransport' do
    let(:url) { "http://roar.example.com/method" }
    let(:body) { "booty" }
    let(:as) { "application/xml" }
    before do
      @transport = Roar::Representer::Transport::Faraday.new
    end

    it "#get_uri returns response" do
      @transport.get_uri(url, as).must_match_faraday_response :get, url, as
    end

    it "#post_uri returns response" do
      @transport.post_uri(url, body, as).must_match_faraday_response :post, url, as, body
    end

    it "#put_uri returns response" do
      @transport.put_uri(url, body, as).must_match_faraday_response :put, url, as, body
    end

    it "#delete_uri returns response" do
      @transport.delete_uri(url, as).must_match_faraday_response :delete, url, as
    end

    it "#patch_uri returns response" do
      @transport.patch_uri(url, body, as).must_match_faraday_response :patch, url, as, body
    end

    describe 'non-existent resource' do
      before do
        @not_found_url = 'http://roar.example.com/missing-resource'
      end

      it '#get_uri raises a ResourceNotFound error' do
        assert_raises(Faraday::Error::ResourceNotFound) do
          @transport.get_uri(@not_found_url, as).body
        end
      end

      it '#post_uri raises a ResourceNotFound error' do
        assert_raises(Faraday::Error::ResourceNotFound) do
          @transport.post_uri(@not_found_url, body, as).body
        end
      end

      it '#post_uri raises a ResourceNotFound error' do
        assert_raises(Faraday::Error::ResourceNotFound) do
          @transport.post_uri(@not_found_url, body, as).body
        end
      end

      it '#delete_uri raises a ResourceNotFound error' do
        assert_raises(Faraday::Error::ResourceNotFound) do
          @transport.delete_uri(@not_found_url, as).body
        end
      end
    end

    describe 'server errors (500 Internal Server Error)' do
      it '#get_uri raises a ClientError' do
        assert_raises(Faraday::Error::ClientError) do
          @transport.get_uri('http://roar.example.com/deliberate-error', as).body
        end
      end
    end

  end
end
