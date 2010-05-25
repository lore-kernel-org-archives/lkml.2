Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036Ab0EYS6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:58:15 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:56101 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab0EYS6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:58:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=muM4QxRR2EE23yfp89Z6AWUxRH4ODdvFcvT+xi1YEl1frAhWVzw0lw/afKs1gNqa5c
         R13KQG4eFCOQAvzFYPNq1v30OhSi4jpUMUM3RfD27eNRcaT/9iHh9goGQWHqKKEm2gno
         LNL+XzPzdOfUzjMaiN7x7YkTBcAfIyyFwyHfQ=
Message-ID: <4BFC1DD4.1000200@gmail.com>
Date: Tue, 25 May 2010 11:58:28 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]alsa:patch_realtek.c iMac9,1 sound fixes.
References: <1274637300-6270-1-git-send-email-justinmattock@gmail.com> <s5h7hmr6dod.wl%tiwai@suse.de>
In-Reply-To: <s5h7hmr6dod.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2010 11:26 AM, Takashi Iwai wrote:
> At Sun, 23 May 2010 10:55:00 -0700,
> Justin P. Mattock wrote:
>    
>> What seemed to be a simple little task of getting the microphone
>> to work, ended up becoming a bigger task than I had set out.
>> (oh-well, good learning experience).
>>
>> Anyways below you will find an updated patch to the iMac9,1 machine
>> which fixes some issues that I found.(keep in mind this is still a work
>> in progress).
>>
>> First issue:
>> With the original patch, I've noticed by unmuting the mic
>> (and even having it muted), there is a distorted("Noise")
>> coming from the internal speakers, even when the headphones are plugged in.
>> What my finding's revealed is:
>>
>> 	/* Mic (rear) pin: input vref at 80% */
>> 	{0x18, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_VREF80},
>> 	{0x18, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
>>
>> > From the original patch. Looking at codec#0 0x18/0x1a is listed as:
>>
>> Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>>    Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
>>    Amp-In vals:  [0x00 0x00]
>>    Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>>    Amp-Out vals:  [0x00 0x00]
>>    Pincap 0x0000373c: IN OUT HP Detect
>>      Vref caps: HIZ 50 GRD 80 100
>>    Pin Default 0x90100141: [Fixed] Speaker at Int N/A
>>      Conn = Unknown, Color = Unknown
>>      DefAssociation = 0x4, Sequence = 0x1
>>      Misc = NO_PRESENCE
>>    Pin-ctls: 0x41: OUT VREF_50
>>    Unsolicited: tag=00, enabled=0
>>    Connection: 5
>>       0x0c* 0x0d 0x0e 0x0f 0x26
>>
>> seems this Node is listed as: [Fixed] Speaker while 0x15
>>
>> Node 0x15 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>>    Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
>>    Amp-In vals:  [0x00 0x00]
>>    Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>>    Amp-Out vals:  [0x80 0x80]
>>    Pincap 0x0000373c: IN OUT HP Detect
>>      Vref caps: HIZ 50 GRD 80 100
>>    Pin Default 0x018b3020: [Jack] Line In at Ext Rear
>>      Conn = Comb, Color = Blue
>>      DefAssociation = 0x2, Sequence = 0x0
>>    Pin-ctls: 0x01: VREF_50
>>    Unsolicited: tag=00, enabled=0
>>    Connection: 5
>>       0x0c 0x0d* 0x0e 0x0f 0x26
>>
>> is [Jack] Line In at Ext Rear.
>> (looking at the other apple products as examples
>> I came up with the fix below).
>>
>> Second issue:
>> alc885_mbp_4ch_modes
>> The original patch does a good job with the
>> HP pin automute function, but from what I noticed is I would have to manually
>> change the channel form 2 to 4 after plugging the headphones in.
>> And not to mention having odd moments to where I was jamming out
>> with the headphones on, then later realized I had sound blasting out
>> of the speakers as well. My findings revealed that changing
>> alc885_mbp_4ch_modes to alc885_mba21_ch_modes and setting
>> -	spec->autocfg.speaker_pins[0] = 0x15;
>> +	spec->autocfg.speaker_pins[0] = 0x18;
>> gets the automute function when the headphones plugged in working
>> flawlessly(and the no need to manually change the channel number
>> afterwards).
>>
>> Third issue:
>> alc885_imac91_mixer
>> There probably doesnt need to be anything changed with this
>> (esspecially if your one to like lots of sliders),but my findings
>> revealed that mac osx only has a master on the top right,
>> another switch on itunes, and then a slider for the mic.
>>
>> So the changes I did below try and mimic osx as much as possible
>> (only thing I had an issue with is just having one mute switch
>> on the master, instead of having two(still investigating)).
>>
>> fourth issue:
>> alc882_capture_source
>> I endeded up creating alc889A_imac91_capture_source()
>> only  because looking at alc882_capture_source I see
>> that the mic is set to 0x1 while this works, I also noticed
>> that adding 0x1 and 0x01 and testing that 0x1 somehow
>> stops working, and 0x01 works(so I figured 0x01 was more
>> of the alpha of the numbers(still need to figure out
>> where that valuse is)). In any case the microphone
>> does work with the original, and with the below patch, but both
>> still record not as clean(lots of "Noise", which I would like to
>> look into too).
>> Note: using alsamixer -Va reveals the capture switches.
>>
>> Overall the original patch is good, the below patch does
>> (hopefully)address some issues, if it's too much of a change
>> I can go back, and just adjust the verb pins on the original
>> and just call it that..(main thing over here is I don't have
>> the "Noise" coming out of the speakers(and music sounds good)...
>>
>> cheers..
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>      
> Looks good.  Now applied.
> Thanks.
>
>
> Takashi
>
>    

o.k...
>> ---
>>   sound/pci/hda/patch_realtek.c |   84 +++++++++++++++++++---------------------
>>   1 files changed, 40 insertions(+), 44 deletions(-)
>>
>> diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
>> index 886d8e4..d8adea3 100644
>> --- a/sound/pci/hda/patch_realtek.c
>> +++ b/sound/pci/hda/patch_realtek.c
>> @@ -6937,6 +6937,14 @@ static struct hda_input_mux alc889A_mb31_capture_source = {
>>   	},
>>   };
>>
>> +static struct hda_input_mux alc889A_imac91_capture_source = {
>> +	.num_items = 2,
>> +	.items = {
>> +		{ "Mic", 0x01 },
>> +		{ "Line", 0x2 }, /* Not sure! */
>> +	},
>> +};
>> +
>>   /*
>>    * 2ch mode
>>    */
>> @@ -7398,15 +7406,8 @@ static struct snd_kcontrol_new alc885_macmini3_mixer[] = {
>>   };
>>
>>   static struct snd_kcontrol_new alc885_imac91_mixer[] = {
>> -	HDA_CODEC_VOLUME("Line-Out Playback Volume", 0x0c, 0x00, HDA_OUTPUT),
>> -	HDA_BIND_MUTE   ("Line-Out Playback Switch", 0x0c, 0x02, HDA_INPUT),
>> -	HDA_CODEC_MUTE  ("Speaker Playback Switch", 0x14, 0x00, HDA_OUTPUT),
>> -	HDA_CODEC_VOLUME("Speaker Playback Volume", 0x0d, 0x00, HDA_OUTPUT),
>> -	HDA_CODEC_VOLUME("Line Playback Volume", 0x0b, 0x02, HDA_INPUT),
>> -	HDA_CODEC_MUTE  ("Line Playback Switch", 0x0b, 0x02, HDA_INPUT),
>> -	HDA_CODEC_VOLUME("Mic Playback Volume", 0x0b, 0x00, HDA_INPUT),
>> -	HDA_CODEC_MUTE  ("Mic Playback Switch", 0x0b, 0x00, HDA_INPUT),
>> -	HDA_CODEC_VOLUME("Mic Boost", 0x18, 0x00, HDA_INPUT),
>> +	HDA_CODEC_VOLUME("Speaker Playback Volume", 0x0c, 0x00, HDA_OUTPUT),
>> +	HDA_BIND_MUTE("Speaker Playback Switch", 0x0c, 0x02, HDA_INPUT),
>>   	{ } /* end */
>>   };
>>
>> @@ -7907,61 +7908,56 @@ static struct hda_verb alc885_mbp3_init_verbs[] = {
>>
>>   /* iMac 9,1 */
>>   static struct hda_verb alc885_imac91_init_verbs[] = {
>> -	/* Line-Out mixer: unmute input/output amp left and right (volume = 0) */
>> -	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_ZERO},
>> -	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)},
>> -	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(1)},
>> -	/* Rear mixer */
>> -	{0x0d, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_ZERO},
>> -	{0x0d, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)},
>> -	{0x0d, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(1)},
>> -	/* HP Pin: output 0 (0x0c) */
>> +	/* Internal Speaker Pin (0x0c) */
>> +	{0x18, AC_VERB_SET_PIN_WIDGET_CONTROL, (PIN_OUT | AC_PINCTL_VREF_50) },
>> +	{0x18, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE},
>> +	{0x18, AC_VERB_SET_CONNECT_SEL, 0x00},	
>> +	{0x1a, AC_VERB_SET_PIN_WIDGET_CONTROL, (PIN_OUT | AC_PINCTL_VREF_50) },
>> +	{0x1a, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE},
>> +	{0x1a, AC_VERB_SET_CONNECT_SEL, 0x00},
>> +	/* HP Pin: Rear */
>>   	{0x14, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_HP},
>>   	{0x14, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE},
>>   	{0x14, AC_VERB_SET_CONNECT_SEL, 0x00},
>> -	{0x14, AC_VERB_SET_UNSOLICITED_ENABLE, ALC880_HP_EVENT | AC_USRSP_EN},
>> -	/* Internal Speakers: output 0 (0x0d) */
>> -	{0x15, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT},
>> +	{0x14, AC_VERB_SET_UNSOLICITED_ENABLE, (ALC880_HP_EVENT | AC_USRSP_EN)},
>> +	/* Line in Rear */
>> +	{0x15, AC_VERB_SET_PIN_WIDGET_CONTROL, AC_PINCTL_VREF_50},
>>   	{0x15, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
>> -	{0x15, AC_VERB_SET_CONNECT_SEL, 0x00},
>> -	/* Mic (rear) pin: input vref at 80% */
>> -	{0x18, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_VREF80},
>> -	{0x18, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
>>   	/* Front Mic pin: input vref at 80% */
>>   	{0x19, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_VREF80},
>>   	{0x19, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
>> -	/* Line In pin: use output 1 when in LineOut mode */
>> -	{0x1a, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_IN},
>> -	{0x1a, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
>> -	{0x1a, AC_VERB_SET_CONNECT_SEL, 0x01},
>> -
>> -	/* FIXME: use matrix-type input source selection */
>> -	/* Mixer elements: 0x18, 19, 1a, 1b, 1c, 1d, 14, 15, 16, 17, 0b */
>> -	/* Input mixer1: unmute Mic, F-Mic, Line, CD inputs */
>> +	/* Rear mixer */
>> +	{0x0d, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_ZERO},
>> +	{0x0d, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)},
>> +	{0x0d, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(1)},
>> +	/* Line-Out mixer: unmute input/output amp left and right (volume = 0) */
>> +	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_ZERO},
>> +	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)},
>> +	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(1)},
>> +	/* 0x24 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In */
>>   	{0x24, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
>>   	{0x24, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(3)},
>>   	{0x24, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(2)},
>>   	{0x24, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(4)},
>> -	/* Input mixer2 */
>> +	/* 0x23 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In */
>>   	{0x23, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
>>   	{0x23, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(3)},
>>   	{0x23, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(2)},
>>   	{0x23, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(4)},
>> -	/* Input mixer3 */
>> +	/* 0x22 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In */
>>   	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
>>   	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(3)},
>>   	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(2)},
>>   	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(4)},
>> -	/* ADC1: mute amp left and right */
>> +	/* 0x07 [Audio Input] wcaps 0x10011b: Stereo Amp-In */
>>   	{0x07, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)},
>>   	{0x07, AC_VERB_SET_CONNECT_SEL, 0x00},
>> -	/* ADC2: mute amp left and right */
>> +	/* 0x08 [Audio Input] wcaps 0x10011b: Stereo Amp-In */
>>   	{0x08, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)},
>>   	{0x08, AC_VERB_SET_CONNECT_SEL, 0x00},
>> -	/* ADC3: mute amp left and right */
>> +	/* 0x09 [Audio Input] wcaps 0x10011b: Stereo Amp-In */
>>   	{0x09, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)},
>>   	{0x09, AC_VERB_SET_CONNECT_SEL, 0x00},
>> -
>>   	{ }
>>   };
>>
>> @@ -8030,7 +8026,7 @@ static void alc885_imac91_setup(struct hda_codec *codec)
>>   	struct alc_spec *spec = codec->spec;
>>
>>   	spec->autocfg.hp_pins[0] = 0x14;
>> -	spec->autocfg.speaker_pins[0] = 0x15;
>> +	spec->autocfg.speaker_pins[0] = 0x18;
>>   	spec->autocfg.speaker_pins[1] = 0x1a;
>>   }
>>
>> @@ -9539,14 +9535,14 @@ static struct alc_config_preset alc882_presets[] = {
>>   		.init_hook = alc885_imac24_init_hook,
>>   	},
>>   	[ALC885_IMAC91] = {
>> -		.mixers = { alc885_imac91_mixer, alc882_chmode_mixer },
>> +		.mixers = {alc885_imac91_mixer},
>>   		.init_verbs = { alc885_imac91_init_verbs,
>>   				alc880_gpio1_init_verbs },
>>   		.num_dacs = ARRAY_SIZE(alc882_dac_nids),
>>   		.dac_nids = alc882_dac_nids,
>> -		.channel_mode = alc885_mbp_4ch_modes,
>> -		.num_channel_mode = ARRAY_SIZE(alc885_mbp_4ch_modes),
>> -		.input_mux =&alc882_capture_source,
>> +		.channel_mode = alc885_mba21_ch_modes,
>> +		.num_channel_mode = ARRAY_SIZE(alc885_mba21_ch_modes),
>> +		.input_mux =&alc889A_imac91_capture_source,
>>   		.dig_out_nid = ALC882_DIGOUT_NID,
>>   		.dig_in_nid = ALC882_DIGIN_NID,
>>   		.unsol_event = alc_automute_amp_unsol_event,
>> -- 
>> 1.7.1.rc1.21.gf3bd6
>>
>>      
>    

