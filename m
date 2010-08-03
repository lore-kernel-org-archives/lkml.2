Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0HCNpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:45:04 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:4901 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455Ab0HCNo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:44:59 -0400
Date: Tue, 3 Aug 2010 10:44:09 -0300
From: Leandro Lucarella <luca@llucax.com.ar>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Kailang Yang <kailang@realtek.com>, Daniel T Chen <crimsun@ubuntu.com>,
        alsa-devel@alsa-project.org
Subject: Re: Regression 2.6.35: Intel N10/ICH 7 Family HDA (Realtek ALC662
 rev1) beep broken
Message-ID: <20100803134409.GA3508@llucax.com.ar>
References: <20100803040054.GX3508@llucax.com.ar>
 <s5h39uw6ymf.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5h39uw6ymf.wl%tiwai@suse.de>
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai, el  3 de agosto a las 07:42 me escribiste:
> At Tue, 3 Aug 2010 01:00:54 -0300,
> Leandro Lucarella wrote:
> > 
> > Hi. I've upgraded from kernel 2.6.34 to 2.6.35 and the beep through the
> > sound card stopped working. I found a very similar problem[1]
> > (commit[2]).
> > 
> > [1] http://lkml.org/lkml/2010/7/28/228
> > [2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=dc1eae256cfac03bf17bf3eb016e3a6423d3f9d5
> > 
> > I've tried to manually enabling the beep with the steps in the e-mail
> > thread I found:
> > 
> > # echo -n 1 > /sys/class/sound/hwC0D2/subsystem_id
> > # echo -n 1 > /sys/class/sound/hwC0D2/reconfig
> > 
> > But it didn't work (the beep still goes through the pcspkr).
> 
> So, you want to hook the beep over codec but it doesn't work, right.
> Do you get "Beep" mixer elements and the dedicated input device?

No, I don't think I have any of them (cat cat /proc/bus/input/devices at the
end).


> Please give alsa-info.sh output.

I didn't know where to find the script, Google gave me this:
http://git.alsa-project.org/?p=alsa-driver.git;a=blob_plain;f=utils/alsa-info.sh
So this is what I've use. I've shared the results at:
http://www.alsa-project.org/db/?f=6a051da2475c7246f40c493a310fecb0a1a289f5

> > I've tried to naively (I'm not a kernel hacker, so I was just guessing) add a
> > new entry with the quirks beep_white_list by copying the entry for ASUS like
> > this:
> > 
> > diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
> > index 596ea2f..ca3ed12 100644
> > --- a/sound/pci/hda/patch_realtek.c
> > +++ b/sound/pci/hda/patch_realtek.c
> > @@ -5183,6 +5183,7 @@ static void fillup_priv_adc_nids(struct hda_codec *codec, hda_nid_t *nid
> >  
> >  static struct snd_pci_quirk beep_white_list[] = {
> >         SND_PCI_QUIRK(0x1043, 0x829f, "ASUS", 1),
> > +       SND_PCI_QUIRK(0x8086, 0xd613, "INTEL", 1),
> >         {}
> >  };
> >  
> > But it didn't work either.
> 
> Hm, this should work.  At least, you should have beep mixer & co with
> this.

Well, my bad, I booted the wrong kernel when trying the patch. The patch
works correctly, so I'll be very glad if it hits Linus kernel soon :)

I could send you the patch but I don't know exactly what to put in the
commit message. The problem is the same as the one with the ASUS P5-V?

> > Then I noticed, if I'm understanding the source code
> > (sound/pci/hda/patch_realtek.c) and documentation
> > (Documentation/sound/alsa/HD-Audio-Models.txt) right, that my card is not
> > present in the models listing, but it worked fine in 2.6.34 (and previous)
> > kernel(s).
> 
> This is no problem.  The model entry is only for special cases.
> For normal machines, no quirks are needed.

OK, thanks for the help.

I hope the patch is committed into the main kernel soon.



# cat /proc/bus/input/devices
I: Bus=0011 Vendor=0001 Product=0001 Version=ab41
N: Name="AT Translated Set 2 keyboard"
P: Phys=isa0060/serio0/input0
S: Sysfs=/devices/platform/i8042/serio0/input/input0
U: Uniq=
H: Handlers=sysrq kbd event0 
B: EV=120013
B: KEY=402000000 3803078f800d001 feffffdfffefffff fffffffffffffffe
B: MSC=10
B: LED=7

I: Bus=0010 Vendor=001f Product=0001 Version=0100
N: Name="PC Speaker"
P: Phys=isa0061/input0
S: Sysfs=/devices/platform/pcspkr/input/input1
U: Uniq=
H: Handlers=kbd event1 
B: EV=40001
B: SND=6

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button"
P: Phys=PNP0C0C/button/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
U: Uniq=
H: Handlers=kbd event2 
B: EV=3
B: KEY=10000000000000 0

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button"
P: Phys=LNXPWRBN/button/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
U: Uniq=
H: Handlers=kbd event3 
B: EV=3
B: KEY=10000000000000 0

I: Bus=0003 Vendor=09da Product=022b Version=0110
N: Name="A4Tech Wireless Battery Free Optical Mouse"
P: Phys=usb-0000:00:1d.2-1/input0
S: Sysfs=/devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1:1.0/input/input4
U: Uniq=
H: Handlers=mouse0 event4 
B: EV=17
B: KEY=ff0000 0 0 0 0
B: REL=303
B: MSC=10

I: Bus=0019 Vendor=0000 Product=0006 Version=0000
N: Name="Video Bus"
P: Phys=LNXVIDEO/video/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
U: Uniq=
H: Handlers=kbd event5 
B: EV=3
B: KEY=3e000b00000000 0 0 0

-- 
Leandro Lucarella (AKA luca)                     http://llucax.com.ar/
----------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
----------------------------------------------------------------------
Demasiado lento para una estrella fugaz
Demasiado limpio para lo que vos acostumbras
Demasiado claro para tanta oscuridad
Demasiados sueños, poca realidad
