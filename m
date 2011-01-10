Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab1AJRlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:41:19 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39743 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab1AJRlQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 12:41:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AUIEllIkhLtzmopm3OR2YHLq4HrpYN+dlZm0nG2Zi5BJi1Hm06n1nWKnWH093tOEfN
         4Hl3YK/JDavFYreSjerlVReEeHYzxgpMSs7i9YkyfFfyu/npx5pnmy+OMiId5cw/X42T
         9UwrHPve7uv+G/7mzT5LUbw2Cb/IiPP3JPkZ4=
MIME-Version: 1.0
In-Reply-To: <s5hhbdgdfu6.wl%tiwai@suse.de>
References: <AANLkTi=Fza-mJyAKtsryAUMMgPoXur4oQ6F2keBmxF6B@mail.gmail.com> <s5hhbdgdfu6.wl%tiwai@suse.de>
From: Nirbheek Chauhan <nirbheek.chauhan@gmail.com>
Date: Mon, 10 Jan 2011 23:10:54 +0530
Message-ID: <AANLkTiku+Cu0iNagjz00wn7d8A6YkioBGWYmO=ObdPZi@mail.gmail.com>
Subject: Re: [bisected] snd_hda_intel, 2.6.37: automuting on headphone connect
 broken; headphone connecter no longer shown in userspace
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, Kailang Yang <kailang@realtek.com>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        arun@accosted.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 7:24 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 5 Jan 2011 13:07:41 +0530,
> Nirbheek Chauhan wrote:
>> Upon upgrading to 2.6.37,
>> auto-muting-laptop-speakers-on-headphone-connect stopped working, and
>> the headphone connector completely disappeared from alsamixer as well
>> as the pulseaudio volume control panel. The headphone jack was still
>> transmitting sound, though.
>>
>> I bisected the problem, with 'good' being v2.6.36, and found the
>> commit below as the first bad commit. Reverting it on v2.6.37 fixes
>> the problem. I also tried the latest alsa-kernel master git tree,
>> which had the same problem.
>>
>> alsa-info when 'good':
>>
>> http://www.alsa-project.org/db/?f=a0b5c95f764a0b01746be46f989685996e1f9210
>>
>> alsa-info when 'bad':
>>
>> http://www.alsa-project.org/db/?f=30f30ca5461f03b98ab6c7c611cf24ea4526f537
>>
>> Note: both were taken without X running, before pulseaudio came up.
>>
>> ================
>> 03642c9a444079aa13f0864383a8f9ca04bfd198 is the first bad commit
>> commit 03642c9a444079aa13f0864383a8f9ca04bfd198
>> Author: Takashi Iwai <tiwai@suse.de>
>> Date:   Wed Sep 8 15:28:19 2010 +0200
>>
>>     ALSA: hda - Clear left-over hp_pins in snd_hda_parse_pin_def_config()
>>
[snip]
>
> It seems that the driver worked casually in the earlier versions :)
> Does the patch below fix your problem?
>
> Note that the "Headphone" control will still not appear even with this
> patch, but these two outputs are controlled by "Front" and "Surround"
> controls.  The lack of "Headphone" is no regression but simply it
> shouldn't have been there.
>

I tested it, and the patch below does exactly what you describe it's
supposed to do. Auto-muting and volume control is the way it used to
be -- somewhat weird, but not a regression from 2.6.36. As a humble
reporter, I agree that it's perfect for -stable.

Thank you!

> I'll work on 2.6.38 tree for better handling of multi headphone
> cases.
>

Results of the second patch are in a reply to the other email.

[snip]
> ===
> From b2d0576055bd1cafcd91a23cf85064815f1396cd Mon Sep 17 00:00:00 2001
> From: Takashi Iwai <tiwai@suse.de>
> Date: Mon, 10 Jan 2011 14:47:35 +0100
> Subject: [PATCH] ALSA: hda - Fix multi-headphone handling for Realtek codecs
>
> When multiple headphone pins are defined without line-out pins, the
> driver takes them as primary outputs.  But it forgot to set line_out_type
> to HP by assuming there is some rest of HP pins.  This results in some
> mis-handling of these pins for Realtek codec parser.  It takes as if
> these are pure line-out jacks.
>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Cc: <stable@kernel.org>
> ---
>  sound/pci/hda/hda_codec.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
> index 98b6d02..05e5ec8 100644
> --- a/sound/pci/hda/hda_codec.c
> +++ b/sound/pci/hda/hda_codec.c
> @@ -4571,6 +4571,9 @@ int snd_hda_parse_pin_def_config(struct hda_codec *codec,
>                }
>                memset(cfg->hp_pins + cfg->hp_outs, 0,
>                       sizeof(hda_nid_t) * (AUTO_CFG_MAX_OUTS - cfg->hp_outs));
> +               if (!cfg->hp_outs)
> +                       cfg->line_out_type = AUTO_PIN_HP_OUT;
> +
>        }
>
>        /* sort by sequence */
> --
> 1.7.3.4
>
>



-- 
~Nirbheek Chauhan

Gentoo GNOME+Mozilla Team
