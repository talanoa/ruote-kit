
require File.join(File.dirname(__FILE__), '/../spec_helper')


describe 'GET /_ruote/participants' do

  describe 'without any participant' do

    it_has_an_engine_with_no_participants

    it 'should give an empty list (HTML)' do
      get '/_ruote/participants'

      last_response.status.should be(200)
    end

    it 'should give an empty array (JSON)' do

      get '/_ruote/participants.json'

      last_response.status.should be(200)

      body = last_response.json_body
      body.should have_key('participants')

      body['participants'].should be_empty
    end
  end

  describe 'with participant' do

    it_has_an_engine

    it 'should give participant information back (HTML)' do

      get '/_ruote/participants'

      last_response.status.should be(200)
    end

    it 'should give participant information back (JSON)' do

      get '/_ruote/participants.json'

      last_response.status.should be(200)

      body = last_response.json_body

      body['participants'].should_not be_empty
    end
  end
end

describe 'PUT /_ruote/participants' do

  it_has_an_engine

  it 'should update the list (HTML)' do

    put(
      '/_ruote/participants',
      'regex_0' => '^alice$',
      'classname_0' => 'Ruote::StorageParticipant',
      'options_0' => '{}',
      'regex_1' => '^bravo$',
      'classname_1' => 'Ruote::StorageParticipant',
      'options_1' => '{}')

    last_response.should be_redirect
    last_response['Location'].should == '/_ruote/participants'

    RuoteKit.engine.participant_list.collect { |pe| pe.regex }.should == [
      '^alice$', '^bravo$'
    ]
  end

  it 'should update the list (JSON)' do

    list = {
      'participants' => [
        { 'regex' => '^alice$',
          'classname' => 'Ruote::StorageParticipant',
          'options' => {} },
        { 'regex' => '^bravo$',
          'classname' => 'Ruote::StorageParticipant',
          'options' => {} }
      ]
    }

    put(
      '/_ruote/participants.json',
      Rufus::Json.encode(list),
      { 'CONTENT_TYPE' => 'application/json' })

    last_response.status.should be(200)

    RuoteKit.engine.participant_list.collect { |pe| pe.regex }.should == [
      '^alice$', '^bravo$'
    ]
  end
end

