Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab0CTNpH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 09:45:07 -0400
Received: from lo.gmane.org ([80.91.229.12]:37589 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab0CTNpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 09:45:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Karl Vogel <karl.vogel@gmail.com>
Subject: i915 lockup / extreme delay
Date: Sat, 20 Mar 2010 14:41:41 +0100
Message-ID: <ho2jal$oqs$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: d54c31754.access.telenet.be
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been experiencing a very sluggish X server right after starting 
my laptop. The effect goes away after a few minutes, so it was rather 
hard to track down.

Recently after updating WINE to a newer release, I've been able to 
trigger the effect by running a certain game under wine on a remote 
computer and using VirtualGL to transport the GL display to my laptop. 
As I first thought the issue was somewhere with wine/virtualgl, I posted 
the question to the virtualgl mailing list. The thread is here:

http://thread.gmane.org/gmane.comp.video.opengl.virtualgl.user/170

But after some further investigation, it seems the issue is with the 
i915 driver.

The 'effect' is that only the mouse pointer works in the X server. The 
cpu usage on the laptop during the sluggishness is minimal. When I 
suspend the game with winedbg, the X server slowly becomes responsive again.

The output from latencytop seems to point to i915 being the culprit:

Cause                                                Maximum     Percentage
[i915_gem_sw_finish_ioctl]                        3880.2 msec         51.0 %
Throttling GPU while waiting for commands         1337.6 msec         12.1 %
[i915_gem_set_domain_ioctl]                       739.6 msec         10.3 %
mmaping memory                                    275.0 msec          0.9 %
Scheduler: waiting for cpu                        106.1 msec          3.8 %
Executing raw SCSI command                        105.4 msec          0.8 %
fsync() on a file (type 'F' for details)           84.5 msec          0.5 %
[i915_gem_do_execbuffer]                           19.7 msec          0.4 %
[i915_gem_pwrite_ioctl]                            19.7 msec          0.4 %


--
Cause                                                Maximum     Percentage
[i915_gem_sw_finish_ioctl]                        4181.0 msec         57.5 %
[i915_gem_set_domain_ioctl]                       3395.2 msec         35.0 %
Throttling GPU while waiting for commands         742.0 msec          2.7 %
[i915_gem_create_ioctl]                            19.7 msec          0.1 %
[i915_gem_busy_ioctl]                              19.7 msec          0.4 %
[i915_gem_pwrite_ioctl]                            19.6 msec          0.3 %
[i915_gem_madvise_ioctl]                           19.6 msec          1.4 %
[i915_gem_do_execbuffer]                           19.4 msec          0.1 %
[i915_do_wait_request]                              5.0 msec          0.2 %

--
Cause                                                Maximum     Percentage
[i915_gem_set_domain_ioctl]                       4609.5 msec         32.8 %
[i915_gem_sw_finish_ioctl]                        3316.7 msec         52.0 %
[i915_gem_create_ioctl]                           744.1 msec          3.0 %
synchronous write                                 345.9 msec          1.3 %
Executing a program                               109.7 msec          0.4 %
fsync() on a file (type 'F' for details)           87.6 msec          1.0 %
Page fault                                         86.1 msec          0.8 %
Writing a page to disk                             20.1 msec          0.4 %
[i915_gem_madvise_ioctl]                           19.7 msec          3.4 %



These were taken on a Fedora 12 kernel v2.6.32.9-70
I also tried to reproduce it with the latest kernel v2.6.34-rc2, but 
it's much worse with that one, since it causes the laptop to completely 
lockup when I start the game!

I've tried to enable some extra kernel debug options and also setup 
netconsole to see if there is anything reported before the lockup, but 
unfortunately there's no output.

--
Some hardware details:


00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series 
Chipset Integrated Graphics Controller (rev 07) (prog-if 00 [VGA 
controller])
	Subsystem: Dell Device 024f
	Flags: bus master, fast devsel, latency 0, IRQ 31
	Memory at f6c00000 (64-bit, non-prefetchable) [size=4M]
	Memory at e0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at ef98 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: <access denied>
	Kernel driver in use: i915
	Kernel modules: i915

00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset 
Integrated Graphics Controller (rev 07)
	Subsystem: Dell Device 024f
	Flags: bus master, fast devsel, latency 0
	Memory at f6b00000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: <access denied>


X.Org X Server 1.7.5.902 (1.7.6 RC 2)
Release Date: 2010-03-12
X Protocol Version 11, Revision 0

(--) PCI:*(0:0:2:0) 8086:2a42:1028:024f Intel Corporation Mobile 4 
Series Chipset Integrated Graphics Controller rev 7, Mem @ 
0xf6c00000/4194304, 0xe0000000/268435456, I/O @ 0x0000ef98/8, BIOS @ 
0x????????/131072
(--) PCI: (0:0:2:1) 8086:2a43:1028:024f Intel Corporation Mobile 4 
Series Chipset Integrated Graphics Controller rev 7, Mem @ 
0xf6b00000/1048576, BIOS @ 0x????????/65536

(II) LoadModule: "intel"
(II) Loading /usr/lib64/xorg/modules/drivers/intel_drv.so
(II) Module intel: vendor="X.Org Foundation"
         compiled for 1.7.0, module version = 2.9.1
         Module class: X.Org Video Driver
         ABI class: X.Org Video Driver, version 6.0
(II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
         i810-dc100, i810e, i815, i830M, 845G, 852GM/855GM, 865G, 915G,
         E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM, Pineview G,
         965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33, GM45,
         4 Series, G45/G43, Q45/Q43, G41, B43, Clarkdale, Arrandale
(II) Primary Device is: PCI 00@00:02:0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 9, (OK)
drmOpenByBusid: Searching for BusID pci:0000:00:02.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 9, (OK)
drmOpenByBusid: drmOpenMinor returns 9
drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
(**) intel(0): Depth 24, (--) framebuffer bpp 32
(==) intel(0): RGB weight 888
(==) intel(0): Default visual is TrueColor
(II) intel(0): Integrated Graphics Chipset: Intel(R) GM45
(--) intel(0): Chipset: "GM45"
(II) intel(0): Output LVDS1 has no monitor section
(II) intel(0): found backlight control interface 
/sys/class/backlight/acpi_video0
(II) intel(0): Output VGA1 has no monitor section
(II) intel(0): Output HDMI1 has no monitor section
(II) intel(0): Output DP1 has no monitor section
(II) intel(0): Output HDMI2 has no monitor section
(II) intel(0): Output DP2 has no monitor section
(II) intel(0): Output DP3 has no monitor section
(II) intel(0): Output TV1 has no monitor section
(II) intel(0): EDID for output LVDS1
(II) intel(0): Manufacturer: SEC  Model: 5443  Serial#: 0
(II) intel(0): Year: 2008  Week: 0
(II) intel(0): EDID Version: 1.3
(II) intel(0): Digital Display Input
(II) intel(0): Max Image Size [cm]: horiz.: 33  vert.: 21
(II) intel(0): Gamma: 2.20
(II) intel(0): No DPMS capabilities specified
(II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4
(II) intel(0): First detailed timing is preferred mode
(II) intel(0): redX: 0.580 redY: 0.340   greenX: 0.310 greenY: 0.550
(II) intel(0): blueX: 0.155 blueY: 0.155   whiteX: 0.313 whiteY: 0.329
(II) intel(0): Manufacturer's mask: 0
(II) intel(0): Supported detailed timing:
(II) intel(0): clock: 164.2 MHz   Image Size:  331 x 207 mm
(II) intel(0): h_active: 1920  h_sync: 2020  h_sync_end 2052 h_blank_end 
2216 h_border: 0
(II) intel(0): v_active: 1200  v_sync: 1202  v_sync_end 1208 v_blanking: 
1235 v_border: 0
(II) intel(0): Supported detailed timing:
(II) intel(0): clock: 109.5 MHz   Image Size:  331 x 207 mm
(II) intel(0): h_active: 1920  h_sync: 2020  h_sync_end 2052 h_blank_end 
2216 h_border: 0
(II) intel(0): v_active: 1200  v_sync: 1202  v_sync_end 1208 v_blanking: 
1235 v_border: 0
(II) intel(0):  RX392<80>154CT
(II) intel(0):





