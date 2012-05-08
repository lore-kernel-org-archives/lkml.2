Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab2EHNFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 09:05:51 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63739 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843Ab2EHNFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 09:05:49 -0400
Message-ID: <4FA91A27.3030801@openvz.org>
Date: Tue, 08 May 2012 17:05:43 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        David Henningsson <david.henningsson@canonical.com>
Subject: Re: [ALSA hda 3.4-rc] suspend2ram regression in snd_hda_intel
References: <4FA38371.9020205@openvz.org>	<4FA6370E.9000702@openvz.org> <s5hpqahvbmv.wl%tiwai@suse.de>	<4FA8C793.4010000@openvz.org> <s5h8vh3um79.wl%tiwai@suse.de> <s5h397bukft.wl%tiwai@suse.de>
In-Reply-To: <s5h397bukft.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Tue, 08 May 2012 10:11:06 +0200,
> Takashi Iwai wrote:
>>
>> At Tue, 08 May 2012 11:13:23 +0400,
>> Konstantin Khlebnikov wrote:
>>>
>>> Takashi Iwai wrote:
>>>> At Sun, 06 May 2012 12:32:14 +0400,
>>>> Konstantin Khlebnikov wrote:
>>>>>
>>>>> Konstantin Khlebnikov wrote:
>>>>>> Mainline commit 785f857d1cb0856b612b46a0545b74aa2596e44a
>>>>>> ("ALSA: hda - Set codec to D3 forcibly even if not used")
>>>>>> breaks sound for my notebook (thinkpad x220),
>>>>>> looks like codec cannot wake from power-save state after resume.
>>>>>> After reverting looks like all works fine.
>>>>>>
>>>>>> how to reproduce:
>>>>>> * unplug the power cord (to enable hda power safe mode)
>>>>>> * play something and stop
>>>>>> * wait until the background noise disappears (codec went into power-save mode)
>>>>>> * suspend
>>>>>> * resume
>>>>>> * play something again and hear the silence
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>>
>>>>> Bump
>>>>
>>>> It's a weekend, so don't expect quick responces from any normal person
>>>> :)
>>>
>>> Yeah, sorry. In this country a mess with holidays and weekends.
>>>
>>>>
>>>> Which 3.4-rc did you try?  There was a known problem with this codec
>>>> regarding the power-up sequence, but this should have been fixed in
>>>> the very recent version.
>>>
>>> Bug still in latest v3.4-rc6.
>>> This is serious degradation since v3.3, so I hope it will be fixed before release.
>>>
>>>>
>>>> If the latest Linus tree still shows the problem, try sound git tree
>>>> master or for-next branch.
>>>>      git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git
>>>
>>> I don't see there anything related to this problem. Bug is still there.
>>> It's 100% reproductible and disappears after reverting that commit.
>>> Looks like driver missed one power-up cycle after system-resume,
>>> after second power-save down/up cycle all work fine.
>>
>> OK.  Could you try to pass model=auto and see whether it changes
>> the behavior?  I've checked only the auto-parser mode recently.
>> It might be just the static quirk that got broken.
>>
>> Note that the mixer elements will be renamed by this, so make sure
>> that you adjust the mixer before testing S3.
>
> FWIW, the below is an ad hoc fix.  If this works for you, I'll queue
> it up for 3.4 kernel.

Of course it helps, but this isn't "fix" at all!
Right fix follows...

>
>
> thanks,
>
> Takashi
>
> ---
> From: Takashi Iwai<tiwai@suse.de>
> Subject: [PATCH] ALSA: hda - Fix S3 regression on Thinkpad X220
>
> The commit [785f857d: ALSA: hda - Set codec to D3 forcibly even if not
> used] caused an S3 regression on Lenovo Thinkpad X220.  The codec
> stays in D3 even after the resume by some reason.
>
> As a simple workaround, just avoid the new behavior by that commit,
> i.e. going to D3 forcibly, for these Conexant codec chips.
>
> Reported-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> Signed-off-by: Takashi Iwai<tiwai@suse.de>
> ---
>   sound/pci/hda/hda_codec.c      |    3 ++-
>   sound/pci/hda/hda_codec.h      |    1 +
>   sound/pci/hda/patch_conexant.c |    1 +
>   3 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
> index 7a8fcc4..f38c4a8 100644
> --- a/sound/pci/hda/hda_codec.c
> +++ b/sound/pci/hda/hda_codec.c
> @@ -5444,7 +5444,8 @@ int snd_hda_suspend(struct hda_bus *bus)
>   	list_for_each_entry(codec,&bus->codec_list, list) {
>   		if (hda_codec_is_power_on(codec))
>   			hda_call_codec_suspend(codec);
> -		else /* forcibly change the power to D3 even if not used */
> +		else if (!codec->no_force_to_d3)
> +			/* forcibly change the power to D3 even if not used */
>   			hda_set_power_state(codec,
>   					    codec->afg ? codec->afg : codec->mfg,
>   					    AC_PWRST_D3);
> diff --git a/sound/pci/hda/hda_codec.h b/sound/pci/hda/hda_codec.h
> index 56b4f74..2b3f646 100644
> --- a/sound/pci/hda/hda_codec.h
> +++ b/sound/pci/hda/hda_codec.h
> @@ -854,6 +854,7 @@ struct hda_codec {
>   	unsigned int single_adc_amp:1; /* adc in-amp takes no index
>   					* (e.g. CX20549 codec)
>   					*/
> +	unsigned int no_force_to_d3:1;	/* don't go to D3 forcibly at sleep */
>   	unsigned int no_sticky_stream:1; /* no sticky-PCM stream assignment */
>   	unsigned int pins_shutup:1;	/* pins are shut up */
>   	unsigned int no_trigger_sense:1; /* don't trigger at pin-sensing */
> diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
> index d906c5b..6b680c2 100644
> --- a/sound/pci/hda/patch_conexant.c
> +++ b/sound/pci/hda/patch_conexant.c
> @@ -3018,6 +3018,7 @@ static int patch_cxt5066(struct hda_codec *codec)
>   	if (!spec)
>   		return -ENOMEM;
>   	codec->spec = spec;
> +	codec->no_force_to_d3 = 1;
>
>   	codec->patch_ops = conexant_patch_ops;
>   	codec->patch_ops.init = conexant_init;

