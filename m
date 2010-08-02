Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab0HBVlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 17:41:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36869 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab0HBVln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 17:41:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h1ooJF7TIxt9Cgzi4gqO+jpzAV7wbAT3j42nmUHum3MpQ87+LSVr0QiKhX2ViCMB/d
         wD2XpdKM8r0b7G/4LC+CTH7eYtLhSY0SfcMBUnmm/sTQWXSBEDwr8FmZ4wruhGf1BXJH
         C1D3ZTKyv4GpmB1y7tiBmYVtl7+cSSoMKMflI=
MIME-Version: 1.0
In-Reply-To: <20100802181449.GA3071@pema>
References: <AANLkTild_NZP5B33ITuaS67bvuREiukbQCtcguKEO4XG@mail.gmail.com>
	<20100802181449.GA3071@pema>
Date: Mon, 2 Aug 2010 22:41:40 +0100
Message-ID: <AANLkTikU6_Cuaqk2xaPWCjkToMgd1yO8Y_qZ9Kcbk9c-@mail.gmail.com>
Subject: Re: PC Beeps not working with HDA Intel module
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: =?ISO-8859-1?B?U2jpcmFi?= <Sebastien.Hinderer@ens-lyon.org>,
        Takashi Iwai <tiwai@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 August 2010 19:14, Shérab <Sebastien.Hinderer@ens-lyon.org> wrote:
> Dear Daniel,
>
> Many thanks for your helpful e-mail and sorry for the delay, it was hard
> to find the time for testing.
>
> Daniel J Blueman (2010/07/05 12:20 +0100):
>>
>> On Jun 26, 12:40 pm, Shérab <Sebastien.Hinderer@ens-lyon.org> wrote:
>> > Dear all,
>> >
>> > The problem is on a computer with an HDA Intel sound card, Intel G45
>> > DEVCTG chip and appears will all version s of the kernel.
>> >
>> > Running e.g.
>> > beep 440
>> > produces a beep whose audible frequency is very low, definitely not 440
>> > Hz.
>> >
>> > However, it is worth notiing that grub is able to produce a beep of the
>> > right frequency at boot time.
>> >
>> > Can this problem be fixed ?
>> >
>> > Should you need any additional bit of information or testing, please ask.
>>
>> I was finding the same with my Dell Studio 1557.
>
> Good to know one is not alone.
>
>> It may be worth using some printk calls [1] showing what frequency
>> value is sent to the codec,
>
> I applied your patch on top of
> 9fe6206f400646a2322096b56c59891d530e8d51
>
> When a console bell is produced, one gets:
> HDA beep: linear value 241
>
> And running the command
> beep 440
> produces the following output:
> HDA beep: linear value 248
>
> Aso, the printk you added saying "printk(KERN_ERR "HDA beep: standard
> value" never appears in the logs.
> Was this result predictable ?
> I thought that to each standard value one linear value would correspond,
> or something like that.

I looked into this further, and on my Dell Studio 15 (with similar IDT
codec), I get value 248 written with the linear calculation. The
datasheet [http://www.idt.com/products/getDoc.cfm?docID=18716251] has
conflicting information: page 28 tells us the HD Audio spec 'standard'
calculation is used (ie freq=48000/4*val), but page 165 tells the
linear calculation is used (ie freq=48000*(257-val)/1024).

A handy app on my phone tells me the frequency produced is 48.4Hz.
Well, 48000/4*248~=48, so it is clear Linux is using the wrong
calculation method.

Testing with value 27 (ie 48000/4*27~=440), we hear the expected tone:
$ sudo ./hda-verb /dev/snd/hwC0D0 0x1c SET_BEEP_CONTROL 27
(of course, your beep widget may not be 0x1c)

The problem is the assumption in patch_sigmatel.c:stac92xx_parse_auto_config():

	/* setup digital beep controls and input device */
#ifdef CONFIG_SND_HDA_INPUT_BEEP
	if (spec->digbeep_nid > 0) {
		hda_nid_t nid = spec->digbeep_nid;
		unsigned int caps;

		err = stac92xx_auto_create_beep_ctls(codec, nid);
		if (err < 0)
			return err;
		err = snd_hda_attach_beep_device(codec, nid);
		if (err < 0)
			return err;
		if (codec->beep) {
			/* IDT/STAC codecs have linear beep tone parameter */
			codec->beep->linear_tone = 1;
			/* if no beep switch is available, make its own one */
			caps = query_amp_caps(codec, nid, HDA_OUTPUT);
			if (!(caps & AC_AMPCAP_MUTE)) {
				err = stac92xx_beep_switch_ctl(codec);
				if (err < 0)
					return err;
			}
		}
	}
#endif

So, linear calculation is used for all SigmaTel/IDT codecs.

Takashi, is then (eg) a white-list the best way to select linear
calculation, as clearly IDT have reverted to the spec?

Thanks,
  Daniel
-- 
Daniel J Blueman
