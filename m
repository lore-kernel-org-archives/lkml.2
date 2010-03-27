Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab0C0Je6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 05:34:58 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:47711 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab0C0Je4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 05:34:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VTwe8dR3BEwtaJKVW+/k59gfACP3R85e9bBTcG88efmoFD84FiePwnTbEASgYY7F29
         3M1UN2rl2fH8fkwg3kQmy2ZNjTVmPxTwrK+STpkl6pVd9GQaH17GIafe/S5apWhWvTM7
         3R5zthAt5MaGXihQ1esTpxECu1n34Ap82f5zU=
MIME-Version: 1.0
In-Reply-To: <s5hd3yq6anu.wl%tiwai@suse.de>
References: <64bb37e1003261025l14e2d82r64ba1e90d024bea6@mail.gmail.com>
	 <s5hfx3nm1lh.wl%tiwai@suse.de>
	 <64bb37e1003261059w3de67654m11ca17f1645f6c1@mail.gmail.com>
	 <s5hhbo26d68.wl%tiwai@suse.de>
	 <64bb37e1003261407y4d46c71cr3b39fc3058e0294a@mail.gmail.com>
	 <s5hd3yq6anu.wl%tiwai@suse.de>
Date: Sat, 27 Mar 2010 10:34:54 +0100
Message-ID: <64bb37e1003270234p3c7a10e2kd066d4459a60bb51@mail.gmail.com>
Subject: Re: Regressions: MSI vs HDA-Intel
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 10:22 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Fri, 26 Mar 2010 22:07:53 +0100,
> Torsten Kaiser wrote:
>>
>> On Fri, Mar 26, 2010 at 9:27 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Fri, 26 Mar 2010 18:59:17 +0100,
>> > Torsten Kaiser wrote:
>> >> Surprisingly this did not fix the delay. After all the trouble I had
>> >> with MSI on the other system, I was sure it was related to the fact,
>> >> that 2.6.33 tried to use MSI.
>> >> 2.6.33 with snd_hda_intel.enable_msi=0:
>> >> [    1.155712] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level,
>> >> low) -> IRQ 16
>> >> [    1.158852] input: AT Translated Set 2 keyboard as
>> >> /devices/platform/i8042/serio0/in
>> >> put/input2
>> >> [    1.232597] firewire_core: created device fw0: GUID 00dc10000129c48f, S400
>> >> [    1.252679] hda_codec: ALC888: BIOS auto-probing.
>> >> [    1.259206] HDA Intel 0000:01:05.2: PCI INT B -> GSI 19 (level,
>> >> low) -> IRQ 19
>> >> [    1.314745] input: GenPS/2 Genius Mouse as
>> >> /devices/platform/i8042/serio1/input/input3
>> >> [    4.322508] hda-intel: azx_get_response timeout, switching to
>> >> polling mode: last cmd=0x000f0000
>> >> [    5.332508] hda-intel: Codec #0 probe error; disabling it...
>> >> [    6.382508] hda_intel: azx_get_response timeout, switching to
>> >> single_cmd mode: last cmd=0x000f0000
>> >> [    6.420470] ALSA device list:
>> >> [    6.421545]   #0: HDA ATI SB at 0xfe7f4000 irq 16
>> >> [    6.422628]   #1: HDA ATI HDMI at 0xfe9e8000 irq 19
>> >>
>> >> ... if I had read these messages, instead of just copy&pasting them, I
>> >> could have noted, that the delay is from codec *0*, but MSI gets
>> >> enabled for codec *1*.
>> >> Info about the HDMI output:
>> >> 01:05.2 Audio device [0403]: ATI Technologies Inc Radeon X1200 Series
>> >> Audio Controller [1002:7919]
>> >>
>> >> But that is a clear bug in the alsa code: After codec 0 (the
>> >> integrated audio from the SB600) does not responds, it disables the
>> >> MSI support for codec 1 (part of the intregrated graphic chipset).
>> >> (I don't know if the HDMI audio support is working or not, as I do not
>> >> have an HDMI display I could attach there.)
>> >
>> > It's no bug.  The driver has only one flag to use MSI or not.
>> > So it disable MSI for both.  It's on the same board, after all,
>> > so better to take a safer option.
>>
>> It's a bug, because the failing codec 0 never used MSI at all. So
>> disabling it will not help.
>>
>> The first log (without the MSI disable option) showed:
>> codec 0 was using IRQ 16
>> codec 1 was using IRQ 19, but got switched to MSI-IRQ 27
>> then the 5 sec pause followed, because codec 0 failed.
>> switching off MSI for codec 1 seemed to work, because I only see
>> hda_intel on IRQ 16 and 19 in /proc/interrupts.
>> But the device list still showed "#1: HDA ATI HDMI at 0xfe9e8000 irq
>> 27" after the "No response from codec, disabling MSI" message!
>
> This is no driver behavior bug.  The point is that this string
> (chip->longname) was set at the time before disabling MSI.  The driver
> can switch back at any time, but the string remains as is.  One reason
> is that this field is exposed to the user-space as a sort of
> identifier, thus it's not always wise to change it dynamically during
> operation.  Yeah, it's confusing, but this is a trade-off.

Ah, ok. I understand this trade-off.

>> The second log showed the same sequence:
>> codec 0 using IRQ 16, codec 1 using 19, but this time without the switch to 27
>> the 5 sec pause and the failing of codec 0 still append, because the
>> ALC888 never used MSI.
>>
>> So I think there are two bugs:
>> One (the regression) that the ALC888 codec is no longer initialized
>> correctly, and so causing the delay during the boot.
>
> This seems irrelevant with the MSI.

What I wrote was bogus.
I confused the listing of #0 and #1 from the "ALSA device list" with
the message about "Codec #0"

After adding more debug output into hda_intel.c, I could see that the
initialisation of the SB600/ALC888 and the ATIHDMI "cards" are not
done in parallel (Like the messages from the input subsystem and the
firewire core that can be seen between the alsa messages), but serial.
So all the messages about the failing codec and MSI belong to
0000:01:05.2, the HDMI output.

But this is rather confusing: Alsa "card" #0, the SB600/ALC888, only
has one codec #3 and "card" #1 has a codec #0.

So the ALC888 (that never tries MSI) works perfect in 2.6.31 and 2.6.33.
The ATIHDMI has a regession that the initialisation in 2.6.33 needs ~6
seconds, while 2.6.31 only needed 0.08 seconds.
(Compared to the total time of 1.4 seconds that 2.6.31 needed until
"Freeing unused kernel memory" that is rather significant)

I can't say if the HDMI output in 2.6.31 worked, because I have no
devices that I could attach there to test this.

Torsten

>> And two that the fallback in azx_rirb_get_response() tries to disable
>> the never enabled MSI.
>
> And this is the designed behavior.  We've never trusted MSI from
> experiences.  So, prepared to go away from it at any moment :)
>
>
> Takashi
>
>> ... Umm. The code disagrees with my description of bug two: It already
>> does check for an per chip msi flag.
>>
>> I will try to add more debug to see what codec emits what errors, and
>> post again, with that information.
>>
>> Thanks, Torsten
>>
>
