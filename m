Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab3AGVdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 16:33:50 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:58382 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3AGVdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 16:33:49 -0500
Date: Mon, 7 Jan 2013 22:33:39 +0100 (CET)
From: Eldad Zack <eldad@fogrefinery.com>
X-X-Sender: eldad@xoschi
To: Alex Deucher <alexdeucher@gmail.com>
cc: Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: Regression: drm/radeon: brightness control hard system lockup
In-Reply-To: <CADnq5_O1GDuigxwR8eXu7f1Fsb8iqrggVwYBaiOJKOR-ighYag@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1301072206530.1617@xoschi>
References: <alpine.LNX.2.00.1301061336180.1397@xoschi> <CADnq5_O1GDuigxwR8eXu7f1Fsb8iqrggVwYBaiOJKOR-ighYag@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 7 Jan 2013, Alex Deucher wrote:
> On Sun, Jan 6, 2013 at 7:59 AM, Eldad Zack <eldad@fogrefinery.com> wrote:
> >
> > Hi Alex,
> >
> > Commit 0ecebb9e0d14e9948e0b1529883a776758117d6f "drm/radeon: switch to a
> > finer grained reset for evergreen" introduced a hard system lockup to my
> > setup. I found it after bisecting, and confirmed it by reverting it on
> > the latest mainline ( 5f243b9 ).
> >
> > This:
> >
> >    echo 7 > /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/backlight/acpi_video0/brightness
> >
> > Causes a hard lock-up hard, i.e. immediate freeze, without any logs.
> >
> > See lspci output and kernel .config below.
> > If there's any more info I can provide, please let me know.
> 
> Do you normally see GPU resets when changing the backlight?  Please
> attach your dmesg output when changing the backlight with the patch
> reverted.

I see nothing. Just to make sure, I cleared the buffer, cycled through 
0-7 a couple of hunderd times (until the flicker annoyed), but I see no
messages at all.
Is there any debug config I should turn on?

Turning ACPI debugging on gives me no messages neither when I use the 
cycle script.

But I did find out something interesting enough, only because I 
happen to have sound debugging on, if I have a PCM stream open to a
USB device, and then change the backlight level, it seems to drop to
microframes, but it's not otherwise noticeable. Looks like setting the
backlight still does something weird with my hardware/config.

Below is a grep -i radeon from my boot dmesg.

Cheers,
Eldad

[    0.301558] [drm] radeon defaulting to kernel modesetting.
[    0.301626] [drm] radeon kernel modesetting enabled.
[    0.301694] bus: 'pci': add driver radeon
[    0.301716] bus: 'pci': driver_probe_device: matched device 0000:01:00.0 with driver radeon
[    0.301718] bus: 'pci': really_probe: probing driver radeon with device 0000:01:00.0
[    0.302310] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
[    0.302390] radeon 0000:01:00.0: GTT: 512M 0x0000000040000000 - 0x000000005FFFFFFF
[    0.303021] [drm] radeon: 1024M of VRAM memory ready
[    0.303108] [drm] radeon: 512M of GTT memory ready.
[    0.303378] radeon 0000:01:00.0: irq 41 for MSI/MSI-X
[    0.303390] radeon 0000:01:00.0: radeon: using MSI.
[    0.303485] [drm] radeon: irq initialized.
[    0.304198] [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
[    0.304414] Registering platform device 'radeon_cp.0'. Parent at platform
[    0.304416] device: 'radeon_cp.0': device_add
[    0.304421] bus: 'platform': add device radeon_cp.0
[    0.304428] PM: Adding info for platform:radeon_cp.0
[    0.304497] platform radeon_cp.0: firmware: using built-in firmware radeon/TURKS_pfp.bin
[    0.304501] platform radeon_cp.0: firmware: using built-in firmware radeon/TURKS_me.bin
[    0.304503] platform radeon_cp.0: firmware: using built-in firmware radeon/BTC_rlc.bin
[    0.304506] platform radeon_cp.0: firmware: using built-in firmware radeon/TURKS_mc.bin
[    0.304517] bus: 'platform': remove device radeon_cp.0
[    0.304518] PM: Removing info for platform:radeon_cp.0
[    0.338906] radeon 0000:01:00.0: WB enabled
[    0.338970] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00 and cpu addr 0xffff880244a0fc00
[    0.339064] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000040000c0c and cpu addr 0xffff880244a0fc0c
[    0.356604] device: 'radeon_bl0': device_add
[    0.356616] PM: Adding info for No Bus:radeon_bl0
[    0.407974] [drm] radeon atom DIG backlight initialized
[    0.408039] [drm] Radeon Display Connectors
[    0.410135] [drm] radeon: power management initialized
[    0.822297] fbcon: radeondrmfb (fb0) is primary device
[    1.585493] radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
[    1.585546] radeon 0000:01:00.0: registered panic notifier
[    1.585601] [drm] Initialized radeon 2.28.0 20080528 for 0000:01:00.0 on minor 0
[    1.585658] driver: '0000:01:00.0': driver_bound: bound to device 'radeon'
[    1.585661] bus: 'pci': really_probe: bound device 0000:01:00.0 to driver radeon


