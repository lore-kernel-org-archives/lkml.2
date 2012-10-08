Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab2JHDNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 23:13:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43638 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2JHDNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 23:13:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120926072916.GA2654@croesus.uplinklabs.net>
References: <20120926072916.GA2654@croesus.uplinklabs.net>
Date: Sun, 7 Oct 2012 20:13:47 -0700
Message-ID: <CACZd_tDu3aN3O+V59wkp2fCoN0Ly6MYXE_TPt27cXXOtdT-xog@mail.gmail.com>
Subject: Re: [BISECTED] snd-hda-intel audio distortion in Linus' current tree
From: Vincent Cheng <vincentc1208@gmail.com>
To: Seth Heasley <seth.heasley@intel.com>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, Steven Noonan <steven@uplinklabs.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cc: alsa-devel@alsa-project.org; also, please cc: me explicitly as
well, since I'm not subscribed to either list]

On Wed, Sep 26, 2012 at 12:29 AM, Steven Noonan <steven@uplinklabs.net> wrote:
> Started having audio problems when trying out the latest tree
> (v3.6-rc7-10-g56d27ad). When playing any kind of audio, there was
> significant distortion, mostly crackling noise. I'm using a Lenovo
> ThinkPad X230 (Panther Point).
>
> I did a git-bisect to locate the problem, and it seems this commit is to
> blame:
>
>         c20c5a841cbe47f5b7812b57bd25397497e5fbc0 is the first bad commit
>         commit c20c5a841cbe47f5b7812b57bd25397497e5fbc0
>         Author: Seth Heasley <seth.heasley@intel.com>
>         Date:   Thu Jun 14 14:23:53 2012 -0700
>
>                 ALSA: hda_intel: activate COMBO mode for Intel client chipsets
>
>                 This patch activates the COMBO position_fix for recent Intel client chipsets.
>                 COMBO mode is the recommended setting for Intel chipsets and eliminates HD
>                 audio warnings in dmesg.  This patch has been tested on Lynx Point, Panther
>                 Point, and Cougar Pont.
>
>                 Signed-off-by: Seth Heasley <seth.heasley@intel.com>
>                 Signed-off-by: Takashi Iwai <tiwai@suse.de>
>
> It's pretty clear-cut. If I revert this patch, my sound starts
> functioning normally again.
>
> Any thoughts on how to proceed here? Can someone revert this, or is
> there some testing that I can do?
>
> Here's a pretty-printed bisection log, if needed:
>
>  # good: [28a33cbc] Linux 3.5
>  # bad:  [b13bc8dd] Merge tag 'staging-3.6-rc1' of git://git.kernel.or
>  # good: [3c4cfade] Merge git://git.kernel.org/pub/scm/linux/kernel/gi
>  # bad:  [9fc37779] Merge tag 'usb-3.6-rc1' of git://git.kernel.org/pu
>  # bad:  [f14121ab] Merge tag 'dt-for-3.6' of git://sources.calxeda.co
>  # good: [d14b7a41] Merge branch 'for-linus' of git://git.kernel.org/p
>  # good: [15d47763] Merge branch 'for-3.5' into for-3.6
>  # bad:  [dbf7b591] Merge tag 'sound-3.6' of git://git.kernel.org/pub/
>  # bad:  [1c76684d] ALSA: hda - add Haswell HDMI codec id
>  # bad:  [8b8d654b] ALSA: hda - Move one-time init codes from generic_
>  # good: [80c8bfbe] ALSA: HDA: Create phantom jacks for fixed inputs a
>  # bad:  [ceaa86ba] ALSA: hda - Remove invalid init verbs for Nvidia 2
>  # bad:  [4b6ace9e] ALSA: hda - Add the support for VIA HDMI pin detec
>  # bad:  [c20c5a84] ALSA: hda_intel: activate COMBO mode for Intel cli
>
>
> - Steven
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

I can confirm that I've also hit this bug as well, and that it's still
present in stable 3.6.0. Strangely enough however, this only seems to
affect VLC for me; while playing audio through mplayer or any
gstreamer-based players (Rhythmbox, Totem, etc.), I don't encounter
any audio distortion. Possibly also related to [1]?

A workaround (other than reverting this commit) is to not use COMBO
mode, i.e. load snd-hda-intel with position_fix=2.

Please let me know if any more information is needed.

$ lspci -vvnn | grep -A8 Audio
00:1b.0 Audio device [0403]: Intel Corporation 7 Series/C210 Series
Chipset Family High Definition Audio Controller [8086:1e20] (rev 04)
	Subsystem: Toshiba America Info Systems Device [1179:fb30]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 46
	Region 0: Memory at f7310000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel

Machine: Toshiba Satellite P850
Distro: Debian wheezy/sid
ALSA 1.0.25; PulseAudio 2.0

Regards,
Vincent

[1] http://mailman.alsa-project.org/pipermail/alsa-devel/2012-September/055161.html
