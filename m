Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab1JRJAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:00:07 -0400
Received: from mail.danysek.cz ([91.103.163.139]:35032 "EHLO mail.danysek.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab1JRJAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:00:04 -0400
Message-ID: <4E9D4011.3020602@danysek.cz>
Date: Tue, 18 Oct 2011 11:00:01 +0200
From: Daniel Suchy <danny@danysek.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Icedove/5.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: ALSA: HDA: conexant support for Lenovo T520/W520
References: <4E9D2DCA.4010603@danysek.cz> <s5h1uua3e9b.wl%tiwai@suse.de>
In-Reply-To: <s5h1uua3e9b.wl%tiwai@suse.de>
OpenPGP: id=A2A35A82
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
thanks for information.

My output from alsa-info is available at
http://www.alsa-project.org/db/?f=94efb9fda4bcf6771ca4868c62b11994dc4dc776

Internal microphone works fine for me, but I don't have external one for
testing at this time. FYI, T520 also doesn't have external microphone
input, it's available only over docking station (Minidock 3). I'll
perform more tests in upcoming days (generally, I don't use audio inputs
too much), also with your patch.

There's another issue I observed related to audio outputs, but I'm not
sure about the reason. With docking station, audio isn't working over
audio output on the Minidock 3. Internal speakers are cutted off
properly, but there's no sound output on the connector. Audio output on
T520 directly works as expected, only output on minidock has this
problem. If you have any hints, let me know. This happens even with
autodetection enabled (this was my initial motivation for looking into
the driver source, and also CXT5066_THINKPAD quirk, which I tested
previously has this problem).

With regards,
Daniel

On 10/18/2011 10:17 AM, Takashi Iwai wrote:
> At Tue, 18 Oct 2011 09:42:02 +0200,
> Daniel Suchy wrote:
>>
>> This is patch for Conexant codec of Intel HDA driver, adding new quirk
>> for Lenovo Thinkpad T520 and W520. Conexant autodetection works fine for
>> T520 (similar subsystem ID is used also in W520 model) and detects more
>> mixer features compared to generic (fallback) Lenovo quirk with
>> hardcoded options in Conexant codec.
>>
>> Patch was activelly tested with Linux 3.0.4, 3.0.6 and 3.0.7 without any
>> problems.
>>
>> Signed-off-by: Daniel Suchy <danny@danysek.cz>
> 
> Thanks for the patch.  But this is no longer needed for 3.1 kernels
> since model=auto is selected as default now.  Though, it might be good
> to send this to stable kernel as an exceptional fix for 3.0.x series.
> In that case, give my ack:
> 	Reviewed-by: Takashi Iwai <tiwai@suse.de>
> 
> 
> BTW, we are checking whether the current ADC amp handling for the
> Conexant codecs is correct.  Could you give alsa-info.sh output, and
> check whether both the internal and the external mic recordings work
> properly?
> 
> Check alsa-info.sh output or /proc/asound/card0/codec#0 file.  If the
> node 0x14 contains both "Mic Capture Volume" and "Internal Mic Capture
> Volume" (or whatever multiple capture volume controls), try to change
> the mixer value and test whether it really reflects on the recording
> level correctly.
> 
> If not, try the patch below and test the recording level again.
> Give alsa-info.sh output anyway with the patch.
> 
> 
> thanks,
> 
> Takashi
> 
> ---
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] ALSA: hda - Fix ADC input-amp handling in Conexant auto-parser
> 
> It seems that Conexant chips handle only a single input-amp even when
> the audio-input widget has multiple sources.  This has been never clear,
> and I implemented in the current way based on the debug information I
> got at the early time -- the device reacts individual input-amp values
> for different sources.  But it doesn't look correct now.
> 
> This patch changes the auto-parser code to handle a single input-amp
> per audio-in widget.  After applying this, you'll see only a single
> "Capture" volume control instead of separate "Mic" or "Line" captures
> when the device is set up to use a single ADC.
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  sound/pci/hda/hda_proc.c       |    7 +++++--
>  sound/pci/hda/patch_conexant.c |   38 +++++++++++++++++++++++++++-----------
>  2 files changed, 32 insertions(+), 13 deletions(-)
> 
> diff --git a/sound/pci/hda/hda_proc.c b/sound/pci/hda/hda_proc.c
> index 2c981b5..9431369 100644
> --- a/sound/pci/hda/hda_proc.c
> +++ b/sound/pci/hda/hda_proc.c
> @@ -646,12 +646,15 @@ static void print_codec_info(struct snd_info_entry *entry,
>  							   HDA_MAX_CONNECTIONS);
>  
>  		if (wid_caps & AC_WCAP_IN_AMP) {
> +			int nums = conn_len;
>  			snd_iprintf(buffer, "  Amp-In caps: ");
>  			print_amp_caps(buffer, codec, nid, HDA_INPUT);
>  			snd_iprintf(buffer, "  Amp-In vals: ");
> +			if (wid_type == AC_WID_PIN ||
> +			    (wid_type == AC_WID_AUD_IN && codec->pin_amp_workaround))
> +				nums = 1;
>  			print_amp_vals(buffer, codec, nid, HDA_INPUT,
> -				       wid_caps & AC_WCAP_STEREO,
> -				       wid_type == AC_WID_PIN ? 1 : conn_len);
> +				       wid_caps & AC_WCAP_STEREO, nums);
>  		}
>  		if (wid_caps & AC_WCAP_OUT_AMP) {
>  			snd_iprintf(buffer, "  Amp-Out caps: ");
> diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
> index feef775..f2d4933 100644
> --- a/sound/pci/hda/patch_conexant.c
> +++ b/sound/pci/hda/patch_conexant.c
> @@ -4251,16 +4251,20 @@ static int cx_auto_build_input_controls(struct hda_codec *codec)
>  	struct conexant_spec *spec = codec->spec;
>  	struct hda_input_mux *imux = &spec->private_imux;
>  	const char *prev_label;
> -	int input_conn[HDA_MAX_NUM_INPUTS];
> -	int i, err, cidx;
> +	int i, j, err, cidx;
>  	int multi_connection;
>  
> +	if (!imux->num_items)
> +		return 0;
> +
>  	multi_connection = 0;
>  	for (i = 0; i < imux->num_items; i++) {
>  		cidx = get_input_connection(codec, spec->imux_info[i].adc,
>  					    spec->imux_info[i].pin);
> -		input_conn[i] = (spec->imux_info[i].adc << 8) | cidx;
> -		if (i > 0 && input_conn[i] != input_conn[0])
> +		if (cidx < 0)
> +			continue;
> +		if (i > 0 && !multi_connection &&
> +		    spec->imux_info[i].adc != spec->imux_info[0].adc)
>  			multi_connection = 1;
>  	}
>  
> @@ -4282,15 +4286,27 @@ static int cx_auto_build_input_controls(struct hda_codec *codec)
>  		if (err < 0)
>  			return err;
>  
> -		if (!multi_connection) {
> -			if (i > 0)
> +		if (multi_connection) {
> +			bool found = false;
> +			for (j = 0; j < i; j++) {
> +				if (spec->imux_info[j].adc == spec->imux_info[i].adc) {
> +					found = true;
> +					break;
> +				}
> +			}
> +			if (found)
>  				continue;
> -			err = cx_auto_add_capture_volume(codec, nid,
> -							 "Capture", "", cidx);
> -		} else {
> -			err = cx_auto_add_capture_volume(codec, nid,
> -							 label, " Capture", cidx);
> +			err = cx_auto_add_capture_volume(codec, nid, label,
> +							 " Capture", cidx);
> +			if (err < 0)
> +				return err;
>  		}
> +	}
> +
> +	if (!multi_connection) {
> +		err = cx_auto_add_volume_idx(codec, "Capture", "", 0,
> +					     spec->imux_info[0].adc,
> +					     HDA_INPUT, 0);
>  		if (err < 0)
>  			return err;
>  	}
