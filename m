Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab2BWSlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 13:41:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab2BWSls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 13:41:48 -0500
Date: Thu, 23 Feb 2012 13:41:44 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, bskeggs@redhat.com
Subject: Re: 3.3-rc4 slub debug / rcu slowness, traces.
Message-ID: <20120223184143.GD26722@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, bskeggs@redhat.com
References: <20120223181438.GC26722@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223181438.GC26722@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 01:14:39PM -0500, Dave Jones wrote:
 > I just dug out an laptop, updated it to the latest Fedora 15 updates, and
 > put the current git kernel as of 45196cee28a5bcfb6ddbe2bffa4270cbed66ae4b
 > onto it.  It took 20 minutes to boot. (Look at the timestamps in the dmesg below)
 > 
 > If I boot with slub_debug=- then it's reasonable again.
 > This laptop used to have no problems running with slub debug turned on
 > all the time, so something seems to have gotten a lot worse there.
 > 
 > Between 526s and 1126s, I got an emergency shell, but things weren't
 > very interactive.  I ran top, and saw modprobe running at 99% for minutes.
 > So it was making progress, albeit slowly.
 > 
 > Then I ran perf, and got a bunch of RCU spew.  Paul, does this look
 > like the stuff your patchset queued for 3.4 fixes ?
 > Could the RCU stuff explain why slub got so much slower ?
 > 
 > Once the machine finally boots, I can run X etc at a speed that
 > I would expect from this machine with debug turned on.
 
Ok, I think there's two problems here. The RCU traces is one thing,
but the slowdown seems to be because nouveau blocks for 917618632 usecs.
I can repeat the slowness by doing rmmod nouveau ; modprobe nouveau
after it's booted.

Ben take a look..

 > [   18.580565] [drm] Initialized drm 1.1.0 20060810
 > [   18.683938] console_init used greatest stack depth: 4584 bytes left
 > [   18.750468] i915 0000:00:02.0: power state changed by ACPI to D0
 > [   18.750593] i915 0000:00:02.0: power state changed by ACPI to D0
 > [   18.750693] i915 0000:00:02.0: setting latency timer to 64
 > [   18.794592] MXM: GUID detected in BIOS
 > [   18.804081] VGA switcheroo: detected DSM switching method \_SB_.PCI0.PEGP.DGPU handle
 > [   18.804186] VGA switcheroo: detected Optimus DSM method \_SB_.PCI0.PEGP.DGPU handle
 > [   18.804556] nouveau 0000:01:00.0: power state changed by ACPI to D0
 > [   18.804669] nouveau 0000:01:00.0: power state changed by ACPI to D0
 > [   18.804761] nouveau 0000:01:00.0: enabling device (0000 -> 0003)
 > [   18.907303] i915 0000:00:02.0: irq 45 for MSI/MSI-X
 > [   18.907593] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
 > [   18.907670] [drm] Driver supports precise vblank timestamp query.
 > [   18.910947] [drm:intel_dsm_pci_probe] *ERROR* failed to get supported _DSM functions
 > [   18.914810] [drm:intel_dsm_pci_probe] *ERROR* failed to get supported _DSM functions
 > [   18.915573] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
 > [   18.915732] vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
 > [   19.474432] fbcon: inteldrmfb (fb0) is primary device
 > [   19.478064] [drm] Changing LVDS panel from (+hsync, +vsync) to (-hsync, -vsync)
 > [   19.996513] Console: switching to colour frame buffer device 170x48
 > [   20.004965] fb0: inteldrmfb frame buffer device
 > [   20.004990] drm: registered panic notifier
 > [   20.076301] acpi device:01: registered as cooling_device2
 > [   20.085499] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input5
 > [   20.087187] ACPI: Video Device [OVGA] (multi-head: yes  rom: no  post: no)
 > [   20.099609] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:06/LNXVIDEO:01/input/input6
 > [   20.101171] ACPI: Video Device [DGPU] (multi-head: yes  rom: yes  post: no)
 > [   20.102645] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
 > [   20.111837] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x298280a2)
 > [   20.117866] modprobe used greatest stack depth: 2248 bytes left
 > [   20.128689] vga_switcheroo: enabled
 > [   20.128931] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
 > [   20.128983] [drm] nouveau 0000:01:00.0: ... BIOS signature not found
 > [   20.129056] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PROM
 > [   20.129112] [drm] nouveau 0000:01:00.0: ... BIOS signature not found
 > [   20.129148] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PCIROM
 > [   20.129188] [drm] nouveau 0000:01:00.0: ... BIOS signature not found
 > [   20.129224] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from ACPI

At this point, we're spinning in the kernel, until..

 > [ 1126.872549] [drm] nouveau 0000:01:00.0: BIT BIOS found
 > [ 1126.873191] [drm] nouveau 0000:01:00.0: Bios version 62.98.3c.00
 > [ 1126.873818] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
 > [ 1126.919197] [drm] nouveau 0000:01:00.0: MXM: no VBIOS data, nothing to do
 > [ 1126.919851] [drm] nouveau 0000:01:00.0: DCB version 4.0
 > [ 1126.920526] [drm] nouveau 0000:01:00.0: DCB outp 00: 010001f3 00010015
 > [ 1126.921221] [drm] nouveau 0000:01:00.0: DCB outp 01: 02011200 00000028
 > [ 1126.921896] [drm] nouveau 0000:01:00.0: DCB outp 02: 04022232 00000010
 > [ 1126.922594] [drm] nouveau 0000:01:00.0: DCB outp 03: 02033242 00020010
 > [ 1126.923299] [drm] nouveau 0000:01:00.0: DCB conn 00: 00000040
 > [ 1126.923991] [drm] nouveau 0000:01:00.0: DCB conn 01: 00000100
 > [ 1126.924708] [drm] nouveau 0000:01:00.0: DCB conn 02: 00000231
 > [ 1126.925420] [drm] nouveau 0000:01:00.0: DCB conn 03: 00002361
 > [ 1126.926143] [drm] nouveau 0000:01:00.0: Adaptor not initialised, running VBIOS init tables.
 > [ 1126.926861] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xD751
 > [ 1126.953354] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xDB03
 > [ 1126.961030] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xE2C9
 > [ 1126.961795] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xE3BB
 > [ 1126.963650] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xE5C7
 > [ 1126.964391] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xE62C
 > [ 1126.985382] [drm] nouveau 0000:01:00.0: BIOS FP mode: 1600x900 (99930kHz pixel clock)
 > [ 1126.987276] [drm] nouveau 0000:01:00.0: 4 available performance level(s)
 > [ 1126.988061] [drm] nouveau 0000:01:00.0: 0: core 169MHz shader 338MHz memory 100MHz timing 4 voltage 900mV fanspeed 100%
 > [ 1126.988853] [drm] nouveau 0000:01:00.0: 1: core 275MHz shader 550MHz memory 301MHz timing 1 voltage 900mV fanspeed 100%
 > [ 1126.989654] [drm] nouveau 0000:01:00.0: 2: core 500MHz shader 1000MHz memory 450MHz timing 2 voltage 1090mV fanspeed 100%
 > [ 1126.990468] [drm] nouveau 0000:01:00.0: 3: core 580MHz shader 1450MHz memory 702MHz timing 3 voltage 1170mV fanspeed 100%
 > [ 1126.991365] [drm] nouveau 0000:01:00.0: c: core 275MHz shader 550MHz memory 300MHz voltage 900mV
 > [ 1127.021916] [TTM] Zone  kernel: Available graphics memory: 1497074 kiB.
 > [ 1127.022779] [TTM] Initializing pool allocator.
 > [ 1127.024897] [TTM] Initializing DMA pool allocator.
 > [ 1127.027987] [drm] nouveau 0000:01:00.0: Detected 128MiB VRAM
 > [ 1127.030865] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
 > [ 1127.112578] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
 > [ 1127.113485] [drm] No driver support for vblank timestamp query.
 > [ 1127.114441] [drm] nouveau 0000:01:00.0: ACPI backlight interface available, not registering our own
 > [ 1127.441154] sony_laptop: brightness ignored, must be controlled by ACPI video driver
 > [ 1127.587167] [drm] nouveau 0000:01:00.0: allocated 1600x900 fb: 0x310000, bo ffff8800aeb93a18
 > [ 1127.595407] fb1: nouveaufb frame buffer device
 > [ 1127.596511] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 1

While this is happening, all other attempts to load modules end up blocking, and
the system eventually grinds to a near standstill until nouveau finishes.

This machine has switchable graphics. It's possible that I never noticed this before
because I had it switched onto Intel graphics when I used to use this laptop, so it
may have been there for a while.

I'm unclear on why disabling slub_debug makes the problem go away.
Perhaps wherever nouveau is spinning is just allocation heavy ?
I'll do some profiling.

	Dave
.
