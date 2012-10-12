Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668Ab2JLPIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:08:19 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52736 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759059Ab2JLPIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:08:16 -0400
MIME-Version: 1.0
X-Originating-IP: [121.6.200.239]
In-Reply-To: <s5h8vbeeca1.wl%tiwai@suse.de>
References: <CAMVG2st1-3kz-KRrm-zXZOGw8=QnyYbB3n5e8Z36xAbmD4b5RQ@mail.gmail.com>
	<s5hvceli0ht.wl%tiwai@suse.de>
	<CAMVG2ss7hmJAEt-vEsNBmTVDWMYCPyPo0UC34DKDBnr7t5gn8g@mail.gmail.com>
	<s5htxu4ezc7.wl%tiwai@suse.de>
	<s5hr4p8ez6u.wl%tiwai@suse.de>
	<CAMVG2svG+SNY7B=SiCL9taRGhdZtGKZ6javtpRBPUdvB825BEg@mail.gmail.com>
	<s5hfw5ng5jw.wl%tiwai@suse.de>
	<CAMVG2subEHt6LYCBhj=Qwb=d1rsrZ3hMcYntRPDXWbtXGfp=jw@mail.gmail.com>
	<s5h8vbeeca1.wl%tiwai@suse.de>
Date: Fri, 12 Oct 2012 23:08:14 +0800
Message-ID: <CAMVG2svAzzj=AtFy7dbOvBCt_PLvG2Qw5+Z6Dc5U=UB5G41ZnA@mail.gmail.com>
Subject: Re: [3.6-rc7] switcheroo race with Intel HDA...
From: Daniel J Blueman <daniel@quora.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Dave Airlie <airlied@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 October 2012 20:34, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 9 Oct 2012 22:26:40 +0800,
> Daniel J Blueman wrote:
>> On 9 October 2012 21:04, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Tue, 9 Oct 2012 19:23:56 +0800,
>> > Daniel J Blueman wrote:
>> >> On 9 October 2012 18:07, Takashi Iwai <tiwai@suse.de> wrote:
>> >> > At Tue, 09 Oct 2012 12:04:08 +0200,
>> >> > Takashi Iwai wrote:
>> >> >> At Tue, 9 Oct 2012 00:34:09 +0800,
>> >> >> Daniel J Blueman wrote:
>> >> >> > On 8 October 2012 20:58, Takashi Iwai <tiwai@suse.de> wrote:
>> >> >> > > At Tue, 25 Sep 2012 13:20:05 +0800,
>> >> >> > > Daniel J Blueman wrote:
>> >> >> > >> On my Macbook with a discrete Nvidia GPU, there is a race between
>> >> >> > >> selecting the integrated GPU and putting the discrete GPU into D3 [1],
>> >> >> > >> reliably causing a kernel oops [2].
>> >> >> > >>
>> >> >> > >> Introducing a delay of ~1s between the calls prevents this. When the
>> >> >> > >> second 'OFF' write path executes, it looks like struct azx at
>> >> >> > >> card->private_data hasn't yet been allocated yet [3], so there is
>> >> >> > >> likely some locking missing.
>> >> >> > >
>> >> >> > > It's rather pci_get_drvdata() returning NULL (i.e. card is NULL, thus
>> >> >> > > card->private_data causes Oops).  Could you check the patch like below
>> >> >> > > and see whether you get a kernel warning (but no Oops) or the problem
>> >> >> > > gets fixed by shifting the assignment of pci drvdata?
>> >> >> > [...]
>> >> >> >
>> >> >> > Good patching. Calling pci_set_drvdata later prevents the oops in HDA,
>> >> >> > though we see unexpected 0x0 responses in the response ring buffer
>> >> >> > [1], which we don't see when there's a >~1.5s delay between IGD and
>> >> >> > OFF.
>> >> >>
>> >> >> If the previous patch fixed, it means that the switching occurred
>> >> >> during the device was being probed.  Maybe a better approach to
>> >> >> register the VGA switcheroo after the proper initialization.
>> >> >>
>> >> >> The patch below is a revised one.  Please give it a try.
>> >> >
>> >> > Also, it's not clear which card spews the spurious response.
>> >> > Apply the patch below in addition.
>> >> [...]
>> >>
>> >> hda-intel: 0000:01:00.1: spurious response 0x0:0x0, last cmd=0x1f0004
>> >> $ lspci -s :1:0.1
>> >> 01:00.1 Audio device: NVIDIA Corporation Device 0e1b (rev ff)
>> >>
>> >> It's the NVIDIA device which presumably hasn't completed it's
>> >> transition to D3 at the time the OFF is executed.
>> >
>> > OK, then could you try the patch below on the top of previous two
>> > patches?
>>
>> The first IGD switcheroo command fails to switch to the integrated GPU:
>>
>> # cat /sys/kernel/debug/vgaswitcheroo/switch
>> 0:DIS:+:Pwr:0000:01:00.0
>> 1:IGD: :Pwr:0000:00:02.0
>> 2:DIS-Audio: :Pwr:0000:01:00.1
>> # echo IGD >/sys/kernel/debug/vgaswitcheroo/switch
>> vga_switcheroo: client 1 refused switch
>>
>> I also instrumented snd_hda_lock_devices, but none of the failure
>> paths are being taken, which would leave inconsistent state, as the
>> return value isn't checked.
>
> Hm, right, the return value of snd_hda_lock_devices() isn't checked,
> but I don't understand how this results like above.
> Basically switching is protected by mutex in vga_switcheroo.c, so the
> whole operation in the client side should be serialized.
>
> In anyway, try the patch below cleanly, and see the spurious message
> error coming up at which timing.
[...]

The patch _does_ address the issue. A recent update to my Macbook
firmware misleadingly broke i915 switching, but since I can reproduce
the oops without the IGD switching completing with the stock kernel,
and consistently can't without [1], the patch is good.

Tested-by: Daniel J Blueman <daniel@quora.org>

Thanks Takashi!
  Daniel

--- [1]

snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
snd_hda_intel 0000:00:1b.0: irq 54 for MSI/MSI-X
XXX 0000:00:1b.0: azx_codec_create entered
vga_switcheroo: enabled
XXX 0000:00:1b.0: azx_codec_create done
input: HDA Intel PCH Headphone as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input9
snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0002)
hda_intel: Disabling MSI
hda-intel: 0000:01:00.1: Handle VGA-switcheroo audio client
XXX 0000:01:00.1: azx_codec_create entered
XXX 0000:01:00.1: azx_codec_create done
input: HDA NVidia HDMI/DP,pcm=8 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input12
input: HDA NVidia HDMI/DP,pcm=7 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input13
input: HDA NVidia HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input14
vga_switcheroo: client 1 refused switch
i915: switched off
-- 
Daniel J Blueman
