Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab0DVXQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 19:16:03 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:60136 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab0DVXP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 19:15:58 -0400
To: xorg-ati <xorg-driver-ati@lists.x.org>
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>,
       xorg@lists.freedesktop.org, alex.deucher@gmail.com
Subject: Re: [bisected] Radeon KMS bug(?) after Linux kernel 2.6.32 causes a crash of X server 1.8.0+ on termination
References: <87iq7pd68h.fsf@spindle.srvr.nix>
	<87pr1sfmyz.fsf@spindle.srvr.nix>
From: Nix <nix@esperi.org.uk>
Emacs: no job too big... no job.
Date: Fri, 23 Apr 2010 00:15:40 +0100
In-Reply-To: <87pr1sfmyz.fsf@spindle.srvr.nix> (nix@esperi.org.uk's message of "Wed, 21 Apr 2010 23:40:52 +0100")
Message-ID: <87iq7jdqoz.fsf_-_@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[sorry for sending this to both the kernel and X lists, but after
bisection I still have no real idea where this bug might be. I'd open a
bugzilla ticket if I had any confidence that I'd open it in the right
place...]

On 21 Apr 2010, nix@esperi.org.uk uttered the following:

> On 18 Apr 2010, nix@esperi.org.uk said:
>
>> So far, every time I've quit X 1.8.0 (1.8-stable tip of tree), it's
>> coredumped and left my console unusable until I restart. (I'm using the

(The console is not merely unusable: the DVI signal turns off, and the
keyboard appears dead. The network is happy and I can shut down remotely,
but I can't do a chvt or start X again -- or rather I can try and nothing
visible happens.)

>> tip of the xf86-video-ati tree, and KMS, both of which worked fine with
>> 1.7.5. Obviously I've recompiled all the drivers I'm usingt, or X
>> wouldn't work at all...)
>>
>> The backtrace differs depending on whether auditing is enabled or not.
>>
>> With auditing on, we are hit with a segfault here:
>>
>> #0  0x00007f7e06148985 in _xstat () from /lib/libc.so.6
>> #1  0x00007f7e061198d0 in __tzfile_read () from /lib/libc.so.6
>> #2  0x00007f7e06118c8a in tzset_internal () from /lib/libc.so.6
>> #3  0x00007f7e06118df9 in __tz_convert () from /lib/libc.so.6
>> #4  0x00007f7e06117439 in ctime () from /lib/libc.so.6
>> #5  0x00000000004533c8 in AuditPrefix ()
>> #6  0x0000000000453956 in VAuditF ()
>> #7  0x0000000000453add in AuditF ()
>> #8  0x000000000043e5c6 in CloseDownClient ()
>> #9  0x0000000000443af8 in Dispatch ()
>> #10 0x0000000000420dc5 in main ()
>>
>> With it off, I see this instead:
>>
>> Program received signal SIGTERM, Terminated.
>> 0x000000000042904c in FreeClientResources ()
>> (gdb) bt
>> #0  0x000000000042904c in FreeClientResources ()
>> #1  0x000000000043e4c2 in CloseDownClient ()
>> #2  0x0000000000443af8 in Dispatch ()
>> #3  0x0000000000420dc5 in main ()
>>
>> which might look like normal termination, except that
>> FreeClientResources() of course does not contain an exit(), and the
>> console is still unusable.
>>
>> I suspect a double-free() somewhere, and/or heap corruption.
>
> Nope. This bug only appears with KMS enabled; it does not appear in
> 2.6.32.10 (when termination happens normally, with only
>
> [   71.267834] Unpin not necessary for ffff88033d66dc00 !
>
> in the kernel log) but does appear with current tip; seen with 2.6.34rc3
> and later (i.e. as soon as I upgraded the X server).

I've bisected the kernel half of this.

This is introduced by a commit predating 2.6.32's release but integrated
in the 2.6.33 merge window:

commit ed160143c6967e89aee05b0685e73c4103bb3e38
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Dec 1 14:12:14 2009 -0500

    drm/radeon/kms: add tv standard property to tv connectors

    Lets user select tv-standard.  The property was there,
    just not hooked up.

    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

so I guess perhaps this is not a kernel bug, but merely a bug in the
TV_STD parts of xf86-video-ati --- but I didn't upgrade that, merely
recompiled it; xf86-video-ati master + xorg 1.7.5 + kernel 2.6.34-tip
works fine, as does xf86-video-ati master + xorg 1.8.0 + kernel 2.6.32.
It's only the combination xf86-video-ati master + xorg 1.8.0 + kernel
>2.6.32 that crashes on termination.

So maybe it *is* a kernel bug, or a latent bug in the driver causing
memory corruption inside the X server only when the kernel and X server
are new enough. (But this is starting to feel a bit unlikely to me.)


In a few days I'll bisect the X.org half of this, since 1.7.5 doesn't
crash on exit no matter which kernel I'm running. The last time I tried
to bisect the X server it was... painful. Let's see if it's any easier
nowadays...


My Xorg.log from 1.8.0 shows no sign of TV connectors, but the
dmesg log from 2.6.33 and later says I have them.


My dmesg log, in part (the DRI/KMS parts)

[    1.146782] [drm] Initialized drm 1.1.0 20060810
[    1.146931] [drm] radeon defaulting to kernel modesetting.
[    1.147072] [drm] radeon kernel modesetting enabled.
[    1.147243]   alloc irq_desc for 24 on node -1
[    1.147244]   alloc kstat_irqs on node -1
[    1.147251] radeon 0000:02:00.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
[    1.147397] radeon 0000:02:00.0: setting latency timer to 64
[    1.148242] [drm] initializing kernel modesetting (RV770 0x1002:0x9440).
[    1.148510] [drm] register mmio base: 0xFBBE0000
[    1.148653] [drm] register mmio size: 65536
[    1.148870] ATOM BIOS: Wekiva
[    1.149014] [drm] Clocks initialized !
[    1.149152] [drm] Internal thermal controller with fan control
[    1.149295] [drm] 5 Power State(s)
[    1.149433] [drm] State 0 Default (default)
[    1.149574] [drm] 	16 PCIE Lanes
[    1.149711] [drm] 	3 Clock Mode(s)
[    1.149848] [drm] 		0 engine/memory: 750000/900000
[    1.149988] [drm] 		1 engine/memory: 750000/900000
[    1.150128] [drm] 		2 engine/memory: 750000/900000
[    1.150268] [drm] State 1 Performance 
[    1.150405] [drm] 	16 PCIE Lanes
[    1.150543] [drm] 	3 Clock Mode(s)
[    1.150681] [drm] 		0 engine/memory: 500000/900000
[    1.150820] [drm] 		1 engine/memory: 500000/900000
[    1.150960] [drm] 		2 engine/memory: 750000/900000
[    1.151100] [drm] State 2 Default 
[    1.151237] [drm] 	16 PCIE Lanes
[    1.151374] [drm] 	3 Clock Mode(s)
[    1.151510] [drm] 		0 engine/memory: 750000/900000
[    1.151652] [drm] 		1 engine/memory: 750000/900000
[    1.151792] [drm] 		2 engine/memory: 750000/900000
[    1.151932] [drm] State 3 Default 
[    1.152069] [drm] 	16 PCIE Lanes
[    1.152206] [drm] 	3 Clock Mode(s)
[    1.152343] [drm] 		0 engine/memory: 500000/900000
[    1.152483] [drm] 		1 engine/memory: 500000/900000
[    1.152626] [drm] 		2 engine/memory: 750000/900000
[    1.152766] [drm] State 4 Default 
[    1.158873] [drm] 	16 PCIE Lanes
[    1.159010] [drm] 	3 Clock Mode(s)
[    1.159147] [drm] 		0 engine/memory: 200000/500000
[    1.159288] [drm] 		1 engine/memory: 200000/500000
[    1.159428] [drm] 		2 engine/memory: 200000/500000
[    1.159571] [drm] radeon: power management initialized
[    1.159720] radeon 0000:02:00.0: VRAM: 256M 0x00000000 - 0x0FFFFFFF (256M used)
[    1.159970] radeon 0000:02:00.0: GTT: 512M 0x10000000 - 0x2FFFFFFF
[    1.160125] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    1.160402] [drm] Detected VRAM RAM=256M, BAR=256M
[    1.160543] [drm] RAM width 256bits DDR
[    1.160704] [TTM] Zone  kernel: Available graphics memory: 6148110 kiB.
[    1.160848] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[    1.160999] [drm] radeon: 256M of VRAM memory ready
[    1.161139] [drm] radeon: 512M of GTT memory ready.
[    1.161305]   alloc irq_desc for 55 on node -1
[    1.161307]   alloc kstat_irqs on node -1
[    1.161314] radeon 0000:02:00.0: irq 55 for MSI/MSI-X
[    1.161318] [drm] radeon: using MSI.
[    1.161479] [drm] radeon: irq initialized.
[    1.161621] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    1.162133] [drm] Loading RV770 Microcode
[    1.162274] platform radeon_cp.0: firmware: using built-in firmware radeon/RV770_pfp.bin
[    1.162525] platform radeon_cp.0: firmware: using built-in firmware radeon/RV770_me.bin
[    1.162779] platform radeon_cp.0: firmware: using built-in firmware radeon/R700_rlc.bin
[    1.212511] [drm] ring test succeeded in 1 usecs
[    1.212711] [drm] radeon: ib pool ready.
[    1.212894] [drm] ib test succeeded in 0 usecs
[    1.213034] [drm] Enabling audio support
[    1.213257] [drm] Default TV standard: PAL
[    1.213397] [drm] Default TV standard: PAL
[    1.213556] [drm] Default TV standard: PAL
[    1.213724] [drm] Radeon Display Connectors
[    1.213863] [drm] Connector 0:
[    1.214000] [drm]   DVI-I
[    1.214135] [drm]   HPD2
[    1.214272] [drm]   DDC: 0x7e60 0x7e60 0x7e64 0x7e64 0x7e68 0x7e68 0x7e6c 0x7e6c
[    1.214522] [drm]   Encoders:
[    1.214659] [drm]     DFP1: INTERNAL_UNIPHY
[    1.214798] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    1.214938] [drm] Connector 1:
[    1.215074] [drm]   DIN
[    1.215209] [drm]   Encoders:
[    1.215346] [drm]     TV1: INTERNAL_KLDSCP_DAC2
[    1.215485] [drm] Connector 2:
[    1.215624] [drm]   DVI-I
[    1.215759] [drm]   HPD1
[    1.215896] [drm]   DDC: 0x7e20 0x7e20 0x7e24 0x7e24 0x7e28 0x7e28 0x7e2c 0x7e2c
[    1.216145] [drm]   Encoders:
[    1.216281] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    1.216420] [drm]     DFP2: INTERNAL_KLDSCP_LVTMA
[    1.349652] [drm] fb mappable at 0xD0141000
[    1.349792] [drm] vram apper at 0xD0000000
[    1.349930] [drm] size 7257600
[    1.350066] [drm] fb depth is 24
[    1.350203] [drm]    pitch is 6912
[    1.366634] Console: switching to colour frame buffer device 210x65
[    1.370800] fb0: radeondrmfb frame buffer device
[    1.370821] registered panic notifier
[    1.370840] [drm] Initialized radeon 2.3.0 20080528 for 0000:02:00.0 on minor 0

And my Xorg.log (with the huge list of supported chipsets chopped out):

[    47.637] _XSERVTransSocketOpenCOTSServer: Unable to open socket for inet6
[    47.638] _XSERVTransOpen: transport open failed for inet6/mutilate:0
[    47.638] _XSERVTransMakeAllCOTSServerListeners: failed to open listener for inet6
[    47.742] 
X.Org X Server 1.8.0
Release Date: 2010-04-02
[    47.742] X Protocol Version 11, Revision 0
[    47.742] Build Operating System: GNU/Linux Nix
[    47.742] Current Operating System: Linux mutilate 2.6.34-rc5-05115-ga2f8292-dirty #1 SMP PREEMPT Wed Apr 21 23:26:47 BST 2010 x86_64
[    47.742] Kernel command line: BOOT_IMAGE=Linux-testing ro resume=swap:/dev/sda2 netconsole=24183@192.168.16.20/eth0,24183@192.168.16.15/00:e0:81:c0:91:1a start_ro
[    47.742] Build Date: 17 April 2010  11:36:07PM
[    47.742]  
[    47.742] Current version of pixman: 0.19.1
[    47.742] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    47.742] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    47.742] (==) Log file: "/var/log/Xorg.0.0.log", Time: Fri Apr 23 00:00:52 2010
[    47.909] (==) Using config file: "/etc/X11/xorg.conf"
[    47.909] (==) Using system config directory "/usr/share/X11/xorg.conf.d"
[    47.990] (==) ServerLayout "MainServer"
[    47.998] (**) |-->Screen "Primary Screen" (0)
[    47.998] (**) |   |-->Monitor "Samsung SyncMaster 223BW"
[    47.998] (**) |   |-->Device "Radeon HD 4850"
[    47.998] (**) |-->Input Device "Mouse"
[    47.998] (**) |-->Input Device "Keyboard"
[    47.998] (**) Option "DontZap" "true"
[    47.998] (**) Option "AllowEmptyInput" "false"
[    47.998] (**) Option "AutoAddDevices" "false"
[    47.998] (**) Option "AutoEnableDevices" "false"
[    47.998] (**) Not automatically adding devices
[    47.998] (**) Not automatically enabling devices
[    48.061] (WW) The directory "/usr/share/fonts" does not exist.
[    48.061] 	Entry deleted from font path.
[    48.062] (WW) The directory "/usr/share/fonts/override" does not exist.
[    48.062] 	Entry deleted from font path.
[    48.074] (**) FontPath set to:
	/usr/local/share/fonts,
	/usr/lib/X11/fonts,
	/usr/lib/X11/fonts/100dpi,
	/usr/lib/X11/fonts/75dpi,
	/usr/lib/X11/fonts/freefont,
	/usr/lib/X11/fonts/jmk,
	/usr/lib/X11/fonts/local,
	/usr/lib/X11/fonts/mathematica,
	/usr/lib/X11/fonts/misc,
	/usr/lib/X11/fonts/mozilla,
	/usr/lib/X11/fonts/SillyNamesForAdobeFonts,
	/usr/lib/X11/fonts/TeX,
	/usr/lib/X11/fonts/TTF,
	/usr/lib/X11/fonts/Type1,
	/usr/lib/X11/fonts/cyrillic,
	/usr/lib/X11/fonts/OTF,
	/usr/lib/X11/fonts/misc/,
	/usr/lib/X11/fonts/TTF/,
	/usr/lib/X11/fonts/OTF/,
	/usr/lib/X11/fonts/Type1/,
	/usr/lib/X11/fonts/100dpi/,
	/usr/lib/X11/fonts/75dpi/
[    48.075] (==) ModulePath set to "/usr/lib/xorg/modules"
[    48.075] (II) Loader magic: 0x7b0740
[    48.075] (II) Module ABI versions:
[    48.075] 	X.Org ANSI C Emulation: 0.4
[    48.075] 	X.Org Video Driver: 7.0
[    48.075] 	X.Org XInput driver : 9.0
[    48.075] 	X.Org Server Extension : 3.0
[    48.110] (--) PCI:*(0:2:0:0) 1002:9440:174b:e850 ATI Technologies Inc RV770 [Radeon HD 4870] rev 0, Mem @ 0xd0000000/268435456, 0xfbbe0000/65536, I/O @ 0x0000b000/256, BIOS @ 0x????????/131072
[    48.110] (II) Open ACPI successful (/var/run/acpid.socket)
[    48.110] (II) "extmod" will be loaded. This was enabled by default and also specified in the config file.
[    48.110] (II) "dbe" will be loaded. This was enabled by default and also specified in the config file.
[    48.110] (II) "glx" will be loaded. This was enabled by default and also specified in the config file.
[    48.110] (II) "record" will be loaded by default.
[    48.110] (II) "dri" will be loaded. This was enabled by default and also specified in the config file.
[    48.110] (II) "dri2" will be loaded by default.
[    48.110] (II) LoadModule: "extmod"
[    49.802] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[    49.866] (II) Module extmod: vendor="X.Org Foundation"
[    49.866] 	compiled for 1.8.0, module version = 1.0.0
[    49.866] 	Module class: X.Org Server Extension
[    49.866] 	ABI class: X.Org Server Extension, version 3.0
[    49.866] (II) Loading extension MIT-SCREEN-SAVER
[    49.866] (II) Loading extension XFree86-VidModeExtension
[    49.866] (II) Loading extension XFree86-DGA
[    49.866] (II) Loading extension DPMS
[    49.866] (II) Loading extension XVideo
[    49.866] (II) Loading extension XVideo-MotionCompensation
[    49.866] (II) Loading extension X-Resource
[    49.866] (II) LoadModule: "glx"
[    49.866] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[    49.959] (II) Module glx: vendor="X.Org Foundation"
[    49.959] 	compiled for 1.8.0, module version = 1.0.0
[    49.959] 	ABI class: X.Org Server Extension, version 3.0
[    49.959] (==) AIGLX enabled
[    49.959] (II) Loading extension GLX
[    49.977] (II) LoadModule: "dri"
[    50.136] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[    50.303] (II) Module dri: vendor="X.Org Foundation"
[    50.303] 	compiled for 1.8.0, module version = 1.0.0
[    50.303] 	ABI class: X.Org Server Extension, version 3.0
[    50.303] (II) Loading extension XFree86-DRI
[    50.303] (II) LoadModule: "dbe"
[    50.303] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[    50.362] (II) Module dbe: vendor="X.Org Foundation"
[    50.362] 	compiled for 1.8.0, module version = 1.0.0
[    50.362] 	Module class: X.Org Server Extension
[    50.362] 	ABI class: X.Org Server Extension, version 3.0
[    50.362] (II) Loading extension DOUBLE-BUFFER
[    50.362] (II) LoadModule: "record"
[    50.362] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[    50.454] (II) Module record: vendor="X.Org Foundation"
[    50.454] 	compiled for 1.8.0, module version = 1.13.0
[    50.454] 	Module class: X.Org Server Extension
[    50.454] 	ABI class: X.Org Server Extension, version 3.0
[    50.454] (II) Loading extension RECORD
[    50.454] (II) LoadModule: "dri2"
[    50.455] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    50.514] (II) Module dri2: vendor="X.Org Foundation"
[    50.514] 	compiled for 1.8.0, module version = 1.2.0
[    50.514] 	ABI class: X.Org Server Extension, version 3.0
[    50.514] (II) Loading extension DRI2
[    50.514] (II) LoadModule: "radeon"
[    50.674] (II) Loading /usr/lib/xorg/modules/drivers/radeon_drv.so
[    50.827] (II) Module radeon: vendor="X.Org Foundation"
[    50.827] 	compiled for 1.8.0, module version = 6.13.99
[    50.827] 	Module class: X.Org Video Driver
[    50.827] 	ABI class: X.Org Video Driver, version 7.0
[    50.830] (II) LoadModule: "mouse"
[    50.830] (II) Loading /usr/lib/xorg/modules/input/mouse_drv.so
[    50.894] (II) Module mouse: vendor="X.Org Foundation"
[    50.894] 	compiled for 1.8.0, module version = 1.5.0
[    50.894] 	Module class: X.Org XInput Driver
[    50.894] 	ABI class: X.Org XInput driver, version 9.0
[    50.894] (II) LoadModule: "kbd"
[    50.894] (II) Loading /usr/lib/xorg/modules/input/kbd_drv.so
[    50.918] (II) Module kbd: vendor="X.Org Foundation"
[    50.918] 	compiled for 1.8.0, module version = 1.4.0
[    50.918] 	Module class: X.Org XInput Driver
[    50.918] 	ABI class: X.Org XInput driver, version 9.0
[    50.918] (II) RADEON: Driver for ATI Radeon chipsets:
[... snip enormous list ...]
[    50.922] (--) using VT number 7

[    50.929] (II) Primary Device is: PCI 02@00:00:0
[    50.929] (II) [KMS] Kernel modesetting enabled.
[    50.968] (++) RADEON(0): Depth 24, (--) framebuffer bpp 32
[    50.968] (II) RADEON(0): Pixel depth = 24 bits stored in 4 bytes (32 bpp pixmaps)
[    50.969] (==) RADEON(0): Default visual is TrueColor
[    50.969] (**) RADEON(0): Option "AccelDFS" "on"
[    50.969] (**) RADEON(0): Option "AccelMethod" "EXA"
[    50.969] (==) RADEON(0): RGB weight 888
[    50.969] (II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
[    50.969] (--) RADEON(0): Chipset: "ATI Radeon 4800 Series" (ChipID = 0x9440)
[    50.969] (II) RADEON(0): PCIE card detected
[    50.969] (WW) RADEON(0): Color tiling is not yet supported on R600/R700
[    50.969] (II) RADEON(0): KMS Color Tiling: disabled
[    50.969] drmOpenDevice: node name is /dev/dri/card0
[    50.969] drmOpenDevice: open result is 10, (OK)
[    50.969] drmOpenByBusid: Searching for BusID pci:0000:02:00.0
[    50.969] drmOpenDevice: node name is /dev/dri/card0
[    50.969] drmOpenDevice: open result is 10, (OK)
[    50.969] drmOpenByBusid: drmOpenMinor returns 10
[    50.969] drmOpenByBusid: drmGetBusid reports pci:0000:02:00.0
[    51.039] (II) RADEON(0): Output DVI-0 using monitor section Samsung SyncMaster 223BW
[    51.049] (II) RADEON(0): Output DIN has no monitor section
[    51.102] (II) RADEON(0): Output DVI-1 has no monitor section
[    51.116] (II) RADEON(0): EDID for output DVI-0
[    51.126] (II) RADEON(0): EDID for output DIN
[    51.179] (II) RADEON(0): EDID for output DVI-1
[    51.179] (II) RADEON(0): Manufacturer: SAM  Model: 30d  Serial#: 1296380466
[    51.179] (II) RADEON(0): Year: 2008  Week: 8
[    51.179] (II) RADEON(0): EDID Version: 1.3
[    51.179] (II) RADEON(0): Digital Display Input
[    51.179] (II) RADEON(0): Max Image Size [cm]: horiz.: 47  vert.: 30
[    51.179] (II) RADEON(0): Gamma: 2.20
[    51.179] (II) RADEON(0): DPMS capabilities: Off
[    51.179] (II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
[    51.179] (II) RADEON(0): First detailed timing is preferred mode
[    51.179] (II) RADEON(0): redX: 0.644 redY: 0.333   greenX: 0.286 greenY: 0.603
[    51.179] (II) RADEON(0): blueX: 0.152 blueY: 0.079   whiteX: 0.313 whiteY: 0.329
[    51.179] (II) RADEON(0): Supported established timings:
[    51.179] (II) RADEON(0): 720x400@70Hz
[    51.179] (II) RADEON(0): 640x480@60Hz
[    51.179] (II) RADEON(0): 640x480@67Hz
[    51.179] (II) RADEON(0): 640x480@72Hz
[    51.179] (II) RADEON(0): 640x480@75Hz
[    51.179] (II) RADEON(0): 800x600@56Hz
[    51.179] (II) RADEON(0): 800x600@60Hz
[    51.179] (II) RADEON(0): 800x600@72Hz
[    51.179] (II) RADEON(0): 800x600@75Hz
[    51.179] (II) RADEON(0): 832x624@75Hz
[    51.179] (II) RADEON(0): 1024x768@60Hz
[    51.179] (II) RADEON(0): 1024x768@70Hz
[    51.179] (II) RADEON(0): 1024x768@75Hz
[    51.179] (II) RADEON(0): 1280x1024@75Hz
[    51.179] (II) RADEON(0): 1152x864@75Hz
[    51.179] (II) RADEON(0): Manufacturer's mask: 0
[    51.179] (II) RADEON(0): Supported standard timings:
[    51.179] (II) RADEON(0): #0: hsize: 1680  vsize 1050  refresh: 60  vid: 179
[    51.179] (II) RADEON(0): #1: hsize: 1280  vsize 1024  refresh: 60  vid: 32897
[    51.179] (II) RADEON(0): #2: hsize: 1280  vsize 960  refresh: 60  vid: 16513
[    51.179] (II) RADEON(0): #3: hsize: 1152  vsize 864  refresh: 75  vid: 20337
[    51.195] (II) RADEON(0): Supported detailed timing:
[    51.195] (II) RADEON(0): clock: 119.0 MHz   Image Size:  474 x 296 mm
[    51.195] (II) RADEON(0): h_active: 1680  h_sync: 1728  h_sync_end 1760 h_blank_end 1840 h_border: 0
[    51.195] (II) RADEON(0): v_active: 1050  v_sync: 1053  v_sync_end 1059 v_blanking: 1080 v_border: 0
[    51.195] (II) RADEON(0): Ranges: V min: 56 V max: 75 Hz, H min: 30 H max: 81 kHz, PixClock max 140 MHz
[    51.195] (II) RADEON(0): Monitor name: SyncMaster
[    51.195] (II) RADEON(0): Serial No: HS3Q214739
[    51.195] (II) RADEON(0): EDID (in hex):
[    51.195] (II) RADEON(0): 	00ffffffffffff004c2d0d033232454d
[    51.195] (II) RADEON(0): 	08120103802f1e782ad515a455499a27
[    51.195] (II) RADEON(0): 	145054bfef80b30081808140714f0101
[    51.195] (II) RADEON(0): 	0101010101017c2e90a0601a1e403020
[    51.195] (II) RADEON(0): 	3600da281100001a000000fd00384b1e
[    51.195] (II) RADEON(0): 	510e000a202020202020000000fc0053
[    51.195] (II) RADEON(0): 	796e634d61737465720a2020000000ff
[    51.195] (II) RADEON(0): 	00485333513231343733390a202000cd
[    51.195] (II) RADEON(0): Not using mode "1680x1050" (bad mode clock/interlace/doublescan)
[    51.195] (II) RADEON(0): Printing probed modes for output DVI-1
[    51.195] (II) RADEON(0): Modeline "1680x1050"x59.9  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    51.195] (II) RADEON(0): Modeline "1280x1024"x75.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    51.195] (II) RADEON(0): Modeline "1280x1024"x60.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    51.195] (II) RADEON(0): Modeline "1280x960"x60.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    51.195] (II) RADEON(0): Modeline "1152x864"x75.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    51.195] (II) RADEON(0): Modeline "1024x768"x75.1   78.80  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.1 kHz)
[    51.195] (II) RADEON(0): Modeline "1024x768"x70.1   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    51.195] (II) RADEON(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    51.195] (II) RADEON(0): Modeline "832x624"x74.6   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    51.195] (II) RADEON(0): Modeline "800x600"x72.2   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    51.195] (II) RADEON(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    51.195] (II) RADEON(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    51.195] (II) RADEON(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    51.195] (II) RADEON(0): Modeline "640x480"x72.8   31.50  640 664 704 832  480 489 491 520 -hsync -vsync (37.9 kHz)
[    51.195] (II) RADEON(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    51.195] (II) RADEON(0): Modeline "640x480"x66.7   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    51.195] (II) RADEON(0): Modeline "640x480"x60.0   25.20  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    51.195] (II) RADEON(0): Modeline "720x400"x70.1   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    51.195] (II) RADEON(0): Output DVI-0 disconnected
[    51.195] (II) RADEON(0): Output DIN disconnected
[    51.195] (II) RADEON(0): Output DVI-1 connected
[    51.195] (II) RADEON(0): Using exact sizes for initial modes
[    51.195] (II) RADEON(0): Output DVI-1 using initial mode 1680x1050
[    51.195] (II) RADEON(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[    51.195] (II) RADEON(0): mem size init: gart size :1fdff000 vram size: s:10000000 visible:f8d4000
[    51.195] (II) RADEON(0): EXA: Driver will allow EXA pixmaps in VRAM
[    51.210] (==) RADEON(0): DPI set to (96, 96)
[    51.210] (II) Loading sub module "fb"
[    51.210] (II) LoadModule: "fb"
[    51.210] (II) Loading /usr/lib/xorg/modules/libfb.so
[    51.239] (II) Module fb: vendor="X.Org Foundation"
[    51.240] 	compiled for 1.8.0, module version = 1.0.0
[    51.240] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    51.240] (II) Loading sub module "ramdac"
[    51.240] (II) LoadModule: "ramdac"
[    51.240] (II) Module "ramdac" already built-in
[    51.240] (II) Loading sub module "exa"
[    51.240] (II) LoadModule: "exa"
[    51.240] (II) Loading /usr/lib/xorg/modules/libexa.so
[    51.290] (II) Module exa: vendor="X.Org Foundation"
[    51.290] 	compiled for 1.8.0, module version = 2.5.0
[    51.290] 	ABI class: X.Org Video Driver, version 7.0
[    51.290] (--) Depth 24 pixmap format is 32 bpp
[    51.290] (II) RADEON(0): [DRI2] Setup complete
[    51.290] (II) RADEON(0): [DRI2]   DRI driver: r600
[    51.290] (II) RADEON(0): Front buffer size: 7392K
[    51.290] (II) RADEON(0): VRAM usage limit set to 222667K
[    51.323] (==) RADEON(0): Backing store disabled
[    51.331] (II) RADEON(0): Direct rendering enabled
[    51.354] (II) RADEON(0): Setting EXA maxPitchBytes
[    51.354] (**) RADEON(0): Option "EXAOptimizeMigration" "on"
[    51.354] (II) EXA(0): Driver allocated offscreen pixmaps
[    51.354] (II) EXA(0): Driver registered support for the following operations:
[    51.354] (II)         Solid
[    51.354] (II)         Copy
[    51.354] (II)         Composite (RENDER acceleration)
[    51.354] (II)         UploadToScreen
[    51.354] (II)         DownloadFromScreen
[    51.354] (II) RADEON(0): Acceleration enabled
[    51.354] (==) RADEON(0): DPMS enabled
[    51.354] (==) RADEON(0): Silken mouse enabled
[    51.356] (II) RADEON(0): Set up textured video
[    51.382] (II) RADEON(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[    51.382] (--) RandR disabled
[    51.382] (II) Initializing built-in extension Generic Event Extension
[    51.382] (II) Initializing built-in extension SHAPE
[    51.382] (II) Initializing built-in extension MIT-SHM
[    51.382] (II) Initializing built-in extension XInputExtension
[    51.382] (II) Initializing built-in extension XTEST
[    51.382] (II) Initializing built-in extension BIG-REQUESTS
[    51.382] (II) Initializing built-in extension SYNC
[    51.382] (II) Initializing built-in extension XKEYBOARD
[    51.382] (II) Initializing built-in extension XC-MISC
[    51.382] (II) Initializing built-in extension XFIXES
[    51.382] (II) Initializing built-in extension RENDER
[    51.382] (II) Initializing built-in extension RANDR
[    51.382] (II) Initializing built-in extension COMPOSITE
[    51.382] (II) Initializing built-in extension DAMAGE
[    51.563] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    51.563] (II) AIGLX: enabled GLX_INTEL_swap_event
[    51.563] (II) AIGLX: enabled GLX_SGI_make_current_read
[    51.563] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[    51.563] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[    51.563] (II) AIGLX: Loaded and initialized /usr/lib/dri/r600_dri.so
[    51.563] (II) GLX: Initialized DRI2 GL provider for screen 0
[    51.563] (II) RADEON(0): Setting screen physical size to 444 x 277
[    52.982] (**) Option "Protocol" "Auto"
[    52.982] (**) Option "Device" "/dev/input/mice"
[    52.982] (II) Mouse: Setting mouse protocol to "ExplorerPS/2"
[    52.982] (**) Mouse: Device: "/dev/input/mice"
[    52.982] (**) Mouse: Protocol: "Auto"
[    52.982] (**) Option "SendCoreEvents" "true"
[    52.982] (**) Option "CorePointer"
[    52.982] (**) Mouse: always reports core events
[    52.982] (**) Option "Device" "/dev/input/mice"
[    53.017] (==) Mouse: Emulate3Buttons, Emulate3Timeout: 50
[    53.017] (**) Mouse: ZAxisMapping: buttons 4 and 5
[    53.017] (**) Mouse: Buttons: 9
[    53.017] (**) Mouse: Sensitivity: 1
[    53.017] (II) XINPUT: Adding extended input device "Mouse" (type: MOUSE)
[    53.017] (**) Mouse: (accel) keeping acceleration scheme 1
[    53.017] (**) Mouse: (accel) acceleration profile 0
[    53.017] (**) Mouse: (accel) acceleration factor: 2.000
[    53.017] (**) Mouse: (accel) acceleration threshold: 4
[    53.028] (II) Mouse: Setting mouse protocol to "ExplorerPS/2"
[    53.319] (II) Mouse: ps2EnableDataReporting: succeeded
[    53.319] (**) Option "CoreKeyboard"
[    53.319] (**) Keyboard: always reports core events
[    53.319] (**) Option "Protocol" "standard"
[    53.319] (**) Keyboard: Protocol: standard
[    53.319] (**) Option "XkbRules" "base"
[    53.319] (**) Keyboard: XkbRules: "base"
[    53.319] (**) Option "XkbModel" "pc105"
[    53.319] (**) Keyboard: XkbModel: "pc105"
[    53.319] (**) Option "XkbLayout" "gb"
[    53.319] (**) Keyboard: XkbLayout: "gb"
[    53.319] (**) Option "XkbOptions" "altwin:left_meta_win,altwin:super_rwin,altwin:hyper_prtsc"
[    53.319] (**) Keyboard: XkbOptions: "altwin:left_meta_win,altwin:super_rwin,altwin:hyper_prtsc"
[    53.319] (**) Option "CustomKeycodes" "off"
[    53.319] (**) Keyboard: CustomKeycodes disabled
[    53.319] (II) XINPUT: Adding extended input device "Keyboard" (type: KEYBOARD)
[    53.389] (II) config/udev: Adding input device Power Button (/dev/input/event1)
[    53.389] (II) AutoAddDevices is off - not adding device.
[    53.393] (II) config/udev: Adding input device Power Button (/dev/input/event0)
[    53.393] (II) AutoAddDevices is off - not adding device.
[    53.399] (II) config/udev: Adding input device Logitech USB Optical Mouse (/dev/input/event3)
[    53.399] (II) AutoAddDevices is off - not adding device.
[    53.399] (II) config/udev: Adding input device Logitech USB Optical Mouse (/dev/input/mouse0)
[    53.399] (II) AutoAddDevices is off - not adding device.
[    53.401] (II) config/udev: Adding input device AT Translated Set 2 keyboard (/dev/input/event2)
[    53.401] (II) AutoAddDevices is off - not adding device.
[    53.401] (II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/event4)
[    53.401] (II) AutoAddDevices is off - not adding device.
[    53.401] (II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/mouse1)
[    53.401] (II) AutoAddDevices is off - not adding device.
[    53.409] AUDIT: Fri Apr 23 00:00:57 2010: 1178: client 1 connected from local host ( uid=1000 gid=100 pid=1176 )
  Auth name: MIT-MAGIC-COOKIE-1 ID: 365
[    53.511] AUDIT: Fri Apr 23 00:00:58 2010: 1178: client 2 connected from local host ( uid=1000 gid=100 pid=1197 )
  Auth name: MIT-MAGIC-COOKIE-1 ID: 365
[    54.768] AUDIT: Fri Apr 23 00:00:59 2010: 1178: client 2 disconnected
[    54.771] AUDIT: Fri Apr 23 00:00:59 2010: 1178: client 2 connected from local host ( uid=1000 gid=100 pid=1202 )
  Auth name: MIT-MAGIC-COOKIE-1 ID: 365
[    54.800] AUDIT: Fri Apr 23 00:00:59 2010: 1178: client 2 disconnected
[    54.885] AUDIT: Fri Apr 23 00:00:59 2010: 1178: client 2 connected from local host ( uid=1000 gid=100 pid=1207 )
  Auth name: MIT-MAGIC-COOKIE-1 ID: 365
[    54.886] AUDIT: Fri Apr 23 00:00:59 2010: 1178: client 2 disconnected
[    54.956] AUDIT: Fri Apr 23 00:00:59 2010: 1178: client 2 connected from local host ( uid=1000 gid=100 pid=1208 )
  Auth name: MIT-MAGIC-COOKIE-1 ID: 365
[    55.077] AUDIT: Fri Apr 23 00:00:59 2010: 1178: client 2 disconnected
[    55.106] AUDIT: Fri Apr 23 00:00:59 2010: 1178: client 2 connected from local host ( uid=1000 gid=100 pid=1217 )
  Auth name: MIT-MAGIC-COOKIE-1 ID: 365
[    56.684] AUDIT: Fri Apr 23 00:01:01 2010: 1178: client 3 connected from local host ( uid=1000 gid=100 pid=1220 )
  Auth name: MIT-MAGIC-COOKIE-1 ID: 365
[    58.982] AUDIT: Fri Apr 23 00:01:03 2010: 1178: client 4 connected from local host ( uid=1000 gid=100 pid=1238 )
  Auth name: MIT-MAGIC-COOKIE-1 ID: 365
[    58.983] AUDIT: Fri Apr 23 00:01:03 2010: 1178: client 4 disconnected
[    59.033] AUDIT: Fri Apr 23 00:01:03 2010: 1178: client 4 connected from local host ( uid=1000 gid=100 pid=1226 )
  Auth name: MIT-MAGIC-COOKIE-1 ID: 365
[    59.045] AUDIT: Fri Apr 23 00:01:03 2010: 1178: client 5 connected from local host ( uid=1000 gid=100 pid=1240 )
  Auth name: MIT-MAGIC-COOKIE-1 ID: 365
[    59.046] AUDIT: Fri Apr 23 00:01:03 2010: 1178: client 5 disconnected
[    59.088] AUDIT: Fri Apr 23 00:01:03 2010: 1178: client 5 connected from local host ( uid=1000 gid=100 pid=1242 )
  Auth name: MIT-MAGIC-COOKIE-1 ID: 365
[    59.089] AUDIT: Fri Apr 23 00:01:03 2010: 1178: client 5 disconnected
[    59.090] AUDIT: Fri Apr 23 00:01:03 2010: 1178: client 5 connected from local host ( uid=1000 gid=100 pid=1243 )
  Auth name: MIT-MAGIC-COOKIE-1 ID: 365
[    59.091] AUDIT: Fri Apr 23 00:01:03 2010: 1178: client 5 disconnected
[    59.229] AUDIT: Fri Apr 23 00:01:03 2010: 1178: client 5 connected from local host ( uid=1000 gid=100 pid=1246 )
  Auth name: MIT-MAGIC-COOKIE-1 ID: 365
[    59.230] AUDIT: Fri Apr 23 00:01:03 2010: 1178: client 5 disconnected
[    59.752] AUDIT: Fri Apr 23 00:01:04 2010: 1178: client 5 connected from local host ( uid=1000 gid=100 pid=1245 )
  Auth name: MIT-MAGIC-COOKIE-1 ID: 365
[    59.850] AUDIT: Fri Apr 23 00:01:04 2010: 1178: client 6 connected from local host ( uid=1000 gid=100 pid=1247 )
  Auth name: MIT-MAGIC-COOKIE-1 ID: 365
[    59.947] (II) RADEON(0): EDID vendor "SAM", prod id 781
[    59.947] (II) RADEON(0): Using EDID range info for horizontal sync
[    59.947] (II) RADEON(0): Using EDID range info for vertical refresh
[    59.947] (II) RADEON(0): Printing DDC gathered Modelines:
[    59.947] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    59.947] (II) RADEON(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    59.947] (II) RADEON(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    59.947] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    59.947] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    59.947] (II) RADEON(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    59.947] (II) RADEON(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    59.947] (II) RADEON(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    59.947] (II) RADEON(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    59.947] (II) RADEON(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    59.947] (II) RADEON(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    59.947] (II) RADEON(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    59.947] (II) RADEON(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    59.947] (II) RADEON(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    59.947] (II) RADEON(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    59.947] (II) RADEON(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    59.947] (II) RADEON(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    59.947] (II) RADEON(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    60.024] (II) RADEON(0): EDID vendor "SAM", prod id 781
[    60.024] (II) RADEON(0): Using hsync ranges from config file
[    60.024] (II) RADEON(0): Using vrefresh ranges from config file
[    60.024] (II) RADEON(0): Printing DDC gathered Modelines:
[    60.024] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    60.024] (II) RADEON(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    60.024] (II) RADEON(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    60.024] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    60.024] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    60.024] (II) RADEON(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    60.024] (II) RADEON(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    60.024] (II) RADEON(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    60.024] (II) RADEON(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    60.024] (II) RADEON(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    60.024] (II) RADEON(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    60.024] (II) RADEON(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    60.024] (II) RADEON(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    60.024] (II) RADEON(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    60.024] (II) RADEON(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    60.024] (II) RADEON(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    60.024] (II) RADEON(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    60.024] (II) RADEON(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
