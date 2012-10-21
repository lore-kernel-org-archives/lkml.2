Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab2JUMFj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 08:05:39 -0400
Received: from xvm-169-183.ghst.net ([95.142.169.183]:42932 "EHLO
	photon.sigxcpu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab2JUMFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 08:05:38 -0400
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Oct 2012 08:05:37 EDT
Date: Sun, 21 Oct 2012 13:56:25 +0200
From: Guido =?iso-8859-1?Q?G=FCnther?= <agx@sigxcpu.org>
To: linux-kernel@vger.kernel.org
Subject: Black screen with gma500_gfx on 3.6.2
Message-ID: <20121021115625.GA2535@bogon.sigxcpu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
when switching from psb_gfx (3.2) to 3.6.2 (or 3.7 as of
2474542f64432398f503373f53bdf620491bcfa8) I'm getting a black screen on
a Axiomtek SBC84826 board with a HP 2310ti attached via VGA.

When using CONFIG_STUB_POULSBO=y I do get a console but when I unbind
the driver and attach gma500_gfx like 

echo 0000\:02\:00.0 > /sys/bus/pci/devices/0000\:02\:00.0/driver/unbind
echo 0000\:02\:00.0 > /sys/bus/pci/drivers/gma500/bind 

the display stays black. dmesg has:

[  688.779860] gma500 0000:00:02.0: setting latency timer to 64
[  688.805968] acpi device:04: registered as cooling_device0
[  688.806976] acpi device:05: registered as cooling_device1
[  688.807140] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[  688.807553] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input13
[  688.809053] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[  688.809065] [drm] No driver support for vblank timestamp query.
[  689.950596] gma500 0000:00:02.0: Backlight lvds set brightness 7a127a12
[  689.950627] [drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 on minor 0

Besides the VGA the driver detects a LVDS as well although there's none
attached (the board does have a connector for it though):

# grep -l ^connected /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-*/status
/sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/status
/sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-VGA-1/status

It also states that both ports are disabled:

# cat   /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-*/enabled
disabled
disabled

I didn't find a way to enable any of these ports via sysfs and X.org's
modesetting driver fails either. Any pointers on howto debug this
further are greatly appreciated.
Cheers,
 -- Guido

P.S.: This is the cards lspci information:

00:02.0 VGA compatible controller: Intel Corporation System Controller Hub (SCH Poulsbo) Graphics Controller (rev 07) (prog-if 00 [VGA controller])
        Subsystem: Device 8100:8086
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fdf00000 (32-bit, non-prefetchable) [size=512K]
        Region 1: I/O ports at ff00 [size=8]
        Region 2: Memory at d0000000 (32-bit, non-prefetchable) [size=256M]
        Region 3: Memory at fdf80000 (32-bit, non-prefetchable) [size=256K]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [b0] Vendor Specific Information: Len=07 <?>
        Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Kernel driver in use: gma500

