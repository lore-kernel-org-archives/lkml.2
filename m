Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab1L2GVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 01:21:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41611 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab1L2GVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 01:21:12 -0500
Date: Thu, 29 Dec 2011 00:21:05 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Petr Baudis <pasky@ucw.cz>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: hda-intel: azx_get_response timeout, switching to polling mode:
 last cmd=0x01db0000
Message-ID: <20111229062105.GB28780@elie.Belkin>
References: <20111229025953.15211.24880.reportbug@machine.or.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111229025953.15211.24880.reportbug@machine.or.cz>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Petr,

Petr Baudis wrote[1]:

> Version: 3.1.5-1
[...]
> this bug is twofold - I'm not sure which of the two problems is the real
> culprit of the issue I'm seeing, and if it's worth fixing both or just
> either one. It boils down to sometimes choppy playback and mainly
> applications getting stuck on some audio operations.
[...]
> This did not use to happen at least back around 2.6.32.
[...]
> I'd be willing to do some bisecting if people believe it would make
> sense.

I don't see any relevant newer fixes, but could you test the for-next
branch from [2] anyway?  Output from the alsa-info.sh script[3] would
also be useful.

Some snippets from the original report kept below, in case someone from
the alsa project has ideas.  (The unabridged report is at [1].)

Thanks and hope that helps,
Jonathan

[1] http://bugs.debian.org/653524
[2] git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git
[3] http://www.alsa-project.org/alsa-info.sh

> (i) hda-intel on my motherboard is sensitive to changing volume during
> playback. If I start playback (e.g. mplayer) and start changing volume
> levels in alsamixer wildly, in a few seconds the playback will stutter
> for a bit and
>
> 	hda-intel: azx_get_response timeout, switching to polling mode: last cmd=0x01db0000
>
> gets logged.
>
> (ii) After this happens, the playback will get slightly choppy, but that
> is barely ever noticeable. The real issue is that applications will
> get stuck on some audio operations - most notably, when mplayer stops
> playing a song, it will do SNDCTL_DSP_SYNC:
>
>	03:52:14.774972 ioctl(4, SNDCTL_DSP_SYNC, 0) = ? ERESTARTSYS (To be restarted)
>	03:52:16.813873 --- SIGINT (Interrupt) @ 0 (0) ---
>	03:52:16.814479 write(2, "\n", 1)       = 1
>	03:52:16.821637 write(2, "\nMPlayer interrupted by signal 2"..., 54) = 54
>	03:52:16.835238 rt_sigreturn(0x29)      = 16
>	03:52:16.835348 ioctl(4, SNDCTL_DSP_SYNC, 0) = ? ERESTARTSYS (To be restarted)
>	03:52:18.393655 --- SIGINT (Interrupt) @ 0 (0) ---
>	03:52:18.393782 write(2, "\n", 1)       = 1
>	03:52:18.400725 write(2, "\nMPlayer interrupted by signal 2"..., 54) = 54
>	03:52:18.415261 close(4294967295)       = -1 EBADF (Bad file descriptor)
>	03:52:18.416276 exit_group(1)           = ?
>
> When in the polling mode, *sometimes* the SNDCTL_DSP_SYNC will hang
> indefinitely. I suspect this also causes my Flash sound playback
> to break, but I do not have that confirmed 100%.
>
> Removing the snd-intel-hda module and re-modprobing it will fix the
> issue until next time the volume adjustment causes a switch to the
> polling mode.
>
> This did not use to happen at least back around 2.6.32. These kernel
> versions had different issue with this particular chipset and mapping
> DMA space above 4GiB boundary with >4GiB RAM installed, though. Not
> sure if this bug does not have something still to do with that (though
> similar symptoms disappeared for the network card).
>
> I'd be willing to do some bisecting if people believe it would make
> sense.
[...]
> [2174402.896629] snd_hda_intel 0000:01:00.1: PCI INT B disabled
> [2174402.924482] snd_hda_intel 0000:00:14.2: PCI INT A disabled
> [2174405.457990] snd_hda_intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [2174405.458166] snd_hda_intel 0000:00:14.2: irq 43 for MSI/MSI-X
> [2174405.852109] hda_codec: AD1988: BIOS auto-probing.
> [2174405.852420] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input10
> [2174405.877935] snd_hda_intel 0000:01:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [2174405.878113] snd_hda_intel 0000:01:00.1: irq 44 for MSI/MSI-X
> [2174405.878166] snd_hda_intel 0000:01:00.1: setting latency timer to 64
> [2174405.892565] HDMI status: Codec=0 Pin=3 Presence_Detect=0 ELD_Valid=0
> [2174405.893243] input: HDA ATI HDMI HDMI/DP as /devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card2/input11
> [2175405.280022] hda-intel: azx_get_response timeout, switching to polling mode: last cmd=0x01db0000
> <rmmod snd-intel-hda>
> [2175808.496464] snd_hda_intel 0000:01:00.1: PCI INT B disabled
> [2175808.528486] snd_hda_intel 0000:00:14.2: PCI INT A disabled
> <modprobe snd-intel-hda>
> [2175811.100597] snd_hda_intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [2175811.100774] snd_hda_intel 0000:00:14.2: irq 43 for MSI/MSI-X
> [2175811.496115] hda_codec: AD1988: BIOS auto-probing.
> [2175811.496406] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input12
> [2175811.513015] snd_hda_intel 0000:01:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [2175811.513199] snd_hda_intel 0000:01:00.1: irq 44 for MSI/MSI-X
> [2175811.513256] snd_hda_intel 0000:01:00.1: setting latency timer to 64
> [2175811.533844] HDMI status: Codec=0 Pin=3 Presence_Detect=0 ELD_Valid=0
> [2175811.534515] input: HDA ATI HDMI HDMI/DP as /devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card2/input13
> <twiddling volume controls in alsamixer>
> [2175932.840016] hda-intel: azx_get_response timeout, switching to polling mode: last cmd=0x01db0000
[...]
> bios_vendor: American Megatrends Inc.
> bios_version: 1009   
> board_vendor: ASUSTeK Computer INC.
> board_name: M2R32-MVP
> board_version: Rev 1.xx
[...]
> 00:14.2 Audio device [0403]: ATI Technologies Inc SBx00 Azalia (Intel HDA) [1002:4383]
> 	Subsystem: ATI Technologies Inc SBx00 Azalia (Intel HDA) [1002:4383]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64, Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 43
> 	Region 0: Memory at fbcf0000 (64-bit, non-prefetchable) [size=16K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: snd_hda_intel
