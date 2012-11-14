Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422850Ab2KNNJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 08:09:45 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:43345 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422805Ab2KNNJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 08:09:42 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1211022303510.2756@ionos>
References: <alpine.LFD.2.02.1211022303510.2756@ionos>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 14 Nov 2012 13:09:21 +0000
X-Google-Sender-Auth: ifj0R93H00rKT2ZAYQZqc9MIXJ8
Message-ID: <CACxGe6uau6HCa3jpSzw7uwNtufCNCPN=Pt3BuoFBuNE_D7WFAw@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.6.5-rt15
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,

I get a kernel bug when going from rt14 to rt15. It appears that
preempt_lazy on my ARM platform causes (or exposes) the following
backtrace on boot. I'm basing this on the only relevant change between
rt14 and rt15 is the typo fix that enables PREEMPT_LAZY. I also see
the problem on -rt16 and -rt17.

(full boot log also attached below)

The actual backtrace changes every time, but it is always related to
an rt_spin_lock() call.

This is on a TI AM3894 platform which is equivalent to a TI8160
without the DSP. The board support isn't mainlined, but there is
nothing particularly exotic about the changes. It is primarily device
drivers and device driver data. Cortex-A8 platform.

Any thoughts on how to debug this?

g.

[    1.944702] rtc-ds1307 2-0068: setting system clock to 2012-11-14
12:51:08 UTC (1352897468)
[    1.998931] devtmpfs: mounted
[    2.002410] Freeing init memory: 324K
in[    3.138275] ------------[ cut here ]------------
[    3.138305] kernel BUG at /home/grant/hacking/linux/kernel/sched/core.c:3817!
[    3.138305] Internal error: Oops - BUG: 0 [#1] PREEMPT ARM
[    3.138305] Modules linked in:
[    3.138305] CPU: 0    Not tainted  (3.6.5-rt15-deka-00032-ge65008b #10)
[    3.138336] PC is at preempt_schedule_irq+0x70/0x74
[    3.138336] LR is at svc_preempt+0x8/0x20
[    3.138336] pc : [<8054dbb0>]    lr : [<8054ec10>]    psr: 20000193
[    3.138336] sp : eebcbd68  ip : eebcbd80  fp : eebcbd7c
[    3.138336] r10: 00000037  r9 : eebca000  r8 : 8054ebf8
[    3.138366] r7 : eebcbdb4  r6 : ffffffff  r5 : a0000013  r4 : eebca000
[    3.138366] r3 : 00000001  r2 : 00000000  r1 : 00000000  r0 : eebcbd68
[    3.138366] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment user
[    3.138366] Control: 10c5387d  Table: eeb84019  DAC: 00000015
[    3.138366] Process loadkeys (pid: 113, stack limit = 0xeebca2e8)
[    3.138366] Stack: (0xeebcbd68 to 0xeebcc000)
[    3.138397] bd60:                   00000000 80089428 eebcbe24
eebcbd80 8054ec10 8054db4c
[    3.138397] bd80: 80843a9c eeac6280 00000000 00000001 eebca000
80843a9c eeac6280 000055e0
[    3.138397] bda0: 00000000 00000001 00000037 eebcbe24 00000001
eebcbdc8 8054e2b4 80089428
[    3.138397] bdc0: a0000013 ffffffff 8054dff0 80550bf0 8083454c
8083454c eebcbdf4 eebcbde8
[    3.138427] bde0: 8054e590 8054df80 eebcbe34 eebcbdf8 8011d0d4
00000000 8025199c 8028ab01
[    3.138427] be00: eebcbe24 eeba5200 eebca000 00004b47 000055e0
00000000 eebcbe34 eebcbe28
[    3.138427] be20: 8054e5c8 8054e258 eebcbe64 eebcbe38 80304218
8054e5bc 8004c404 030c375e
[    3.138427] be40: eebca000 00004b47 eeb92800 ef009000 00000000
7eb5dbac eebcbecc eebcbe68
[    3.138458] be60: 802fe490 8030409c 800714ac 800713c4 00000000
eebca000 00000000 00000000
[    3.138458] be80: eebcbeb4 8054db88 8085a47c 80834360 8080d070
8080c0f8 b9dccdff 00000000
[    3.138458] bea0: 80015408 eeb92800 00004b47 ee002cc0 7eb5dbac
eeb92800 eebca000 00000000
[    3.138458] bec0: eebcbf44 eebcbed0 802f432c 802fdf1c 80048d30
80550bf0 80840318 00000043
[    3.138488] bee0: eebcbf0c eebcbef0 80016158 eebca000 80000013
ffffffff eebcbf64 8054ebe0
[    3.138488] bf00: eebca000 8054db94 eebcbf2c eebcbf18 8054db94
80550bf0 00000000 801332d0
[    3.138488] bf20: ee002cc0 00002180 00004b47 00000005 00000000
00000000 eebcbf74 eebcbf48
[    3.138488] bf40: 80133024 802f41b0 00004b47 00000036 80015408
80252688 ee002cc0 7eb5dbac
[    3.138488] bf60: 00004b47 00000005 eebcbfa4 eebcbf78 80133338
80132fa0 ffffffff 00000000
[    3.138519] bf80: 80015408 00000037 00024a70 0000005e 00000036
80015408 00000000 eebcbfa8
[    3.138519] bfa0: 800151c0 801332c0 00000037 00024a70 00000005
00004b47 7eb5dbac 0000030c
[    3.138519] bfc0: 00000037 00024a70 0000005e 00000036 00000000
00000178 0000006e 7eb5dbac
[    3.138519] bfe0: 00024f74 7eb5db90 00009da3 76f519ec 20000010
00000005 00000000 00000000
[    3.138549] [<8054dbb0>] (preempt_schedule_irq+0x70/0x74) from
[<8054ec10>] (svc_preempt+0x8/0x20)
[    3.138580] [<8054ec10>] (svc_preempt+0x8/0x20) from [<80089428>]
(__try_to_take_rt_mutex+0x0/0x16c)
[    3.138580] [<80089428>] (__try_to_take_rt_mutex+0x0/0x16c) from
[<8054e5c8>] (rt_spin_lock+0x18/0x1c)
[    3.138610] [<8054e5c8>] (rt_spin_lock+0x18/0x1c) from [<80304218>]
(vt_do_kdsk_ioctl+0x188/0x3a8)
[    3.138610] [<80304218>] (vt_do_kdsk_ioctl+0x188/0x3a8) from
[<802fe490>] (vt_ioctl+0x580/0x1570)
[    3.138610] [<802fe490>] (vt_ioctl+0x580/0x1570) from [<802f432c>]
(tty_ioctl+0x188/0x93c)
[    3.138641] [<802f432c>] (tty_ioctl+0x188/0x93c) from [<80133024>]
(do_vfs_ioctl+0x90/0x320)
[    3.138641] [<80133024>] (do_vfs_ioctl+0x90/0x320) from
[<80133338>] (sys_ioctl+0x84/0x8c)
[    3.138641] [<80133338>] (sys_ioctl+0x84/0x8c) from [<800151c0>]
(ret_fast_syscall+0x0/0x30)
[    3.138671] Code: e594c000 e31c0008 1afffff2 e89da818 (e7f001f2)
[    3.500030] ---[ end trac


Uncompressing Linux... done, booting the kernel.
[    0.000000] Booting Linux on physical CPU 0
[    0.000000] Linux version 3.6.5-rt15-deka-00032-ge65008b
(grant@ponder) (gcc version 4.5.2 (Sourc
ery G++ Lite 2011.03-41) ) #10 PREEMPT RT Wed Nov 14 12:50:20 GMT 2012
[    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing
instruction cache
[    0.000000] Machine: pluto
[    0.000000] Truncating memory at 0xc0000000 to fit in 32-bit
physical address space
[    0.000000] bootconsole [earlycon0] enabled
[    0.000000] Truncating RAM at 80000000-fcffffff to -ef7fffff
(vmalloc region overlap).
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] On node 0 totalpages: 456704
[    0.000000] free_area_init_node: node 0, pgdat 80859744,
node_mem_map 8091a000
[    0.000000]   Normal zone: 3568 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 453136 pages, LIFO batch:31
[    0.000000] OMAP chip is TI8168 2.0
[    0.000000] TI816X ES2.0 (neon )
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 453136
[    0.000000] Kernel command line: console=ttyO2,115200n8 mem=2000M
earlyprintk ip=::::pluto-arm030
:eth0:none --no-log rootwait rw loglevel=8 root=/dev/sda1
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 8, 1048576 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Memory: 1784MB = 1784MB total
[    0.000000] Memory: 1801572k/1801572k available, 25244k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
[    0.000000]     lowmem  : 0x80000000 - 0xef800000   (1784 MB)
[    0.000000]     modules : 0x7f000000 - 0x80000000   (  16 MB)
[    0.000000]       .text : 0x80008000 - 0x807b070c   (7842 kB)
[    0.000000]       .init : 0x807b1000 - 0x8080277c   ( 326 kB)
[    0.000000]       .data : 0x80804000 - 0x80867fd8   ( 400 kB)
[    0.000000]        .bss : 0x80867ffc - 0x80919cb0   ( 712 kB)
[    0.000000] NR_IRQS:460
[    0.000000] IRQ: Found an INTC at 0xfa200000 (revision 5.0) with
128 interrupts
[    0.000000] Total of 128 interrupts on 1 active controller
[    0.000000] OMAP clockevent source: GPTIMER1 at 32768 Hz
[    0.000000] sched_clock: 32 bits at 32kHz, resolution 30517ns,
wraps every 131071999ms
[    0.000000] OMAP clocksource: GPTIMER2 at 32768 Hz
[    0.000000] Console: colour dummy device 80x30
[    0.267974] Calibrating delay loop... 654.95 BogoMIPS (lpj=3274752)
[    0.267974] pid_max: default: 32768 minimum: 301
[    0.268157] Security Framework initialized
[    0.268218] AppArmor: AppArmor initialized
[    0.268432] Mount-cache hash table entries: 512
[    0.269287] CPU: Testing write buffer coherency: ok
[    0.269287] ftrace: allocating 20665 entries in 61 pages
[    0.322692] hw perfevents: enabled with ARMv7 Cortex-A8 PMU driver,
5 counters available
[    0.366363] Setting up static identity map for 0x80554c70 - 0x80554cc8
[    0.376220] devtmpfs: initialized
[    0.381439] EVM: security.selinux
[    0.384918] EVM: security.capability
[    0.389739] dummy:
[    0.392242] NET: Registered protocol family 16
[    0.397338] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.404510] GPMC revision 6.0
[    0.407653] gpmc: irq-100 could not claim: err -22
[    0.413330] gpiochip_add: registered GPIOs 0 to 31 on device: gpio
[    0.419830] OMAP GPIO hardware version 0.1
[    0.424407] gpiochip_add: registered GPIOs 32 to 63 on device: gpio
[    0.431488] omap_mux_init: Add partition: #1: core, flags: 0
[    0.438171] _omap_mux_get_by_name: Could not find signal uart1_rx.uart1_rx
[    0.445465] _omap_mux_get_by_name: Could not find signal uart2_rx.uart2_rx
[    0.452789] _omap_mux_get_by_name: Could not find signal
uart3_rx_irrx.uart3_rx_irrx
[    0.464660]  omap_i2c.1: alias fck already exists
[    0.469818] _omap_mux_get_by_name: Could not find signal i2c2_scl.i2c2_scl
[    0.476959] _omap_mux_get_by_name: Could not find signal i2c2_sda.i2c2_sda
[    0.484130]  omap_i2c.2: alias fck already exists
[    0.489135] ********** Setting up spi devices
[    0.494354]  omap_hsmmc.0: alias fck already exists
[    0.499725] hw-breakpoint: debug architecture 0x4 unsupported.
[    0.505889]  omap2_mcspi.1: alias fck already exists
[    0.514099] Could not look up wd_timer-1 hwmod
[    0.524536] bio: create slab <bio-0> at 0
[    0.529876] SCSI subsystem initialized
[    0.533996] libata version 3.00 loaded.
[    0.538269] usbcore: registered new interface driver usbfs
[    0.544036] usbcore: registered new interface driver hub
[    0.549713] usbcore: registered new device driver usb
[    0.567535] omap_i2c omap_i2c.1: bus 1 rev2.4.0 at 100 kHz
[    0.587463] omap_i2c omap_i2c.2: bus 2 rev2.4.0 at 100 kHz
[    0.593872] omap-iommu omap-iommu.0: ducati registered
[    0.599365] omap-iommu omap-iommu.1: sys registered
[    0.604583] Advanced Linux Sound Architecture Driver Version 1.0.25.
[    0.611694] Bluetooth: Core ver 2.16
[    0.615478] NET: Registered protocol family 31
[    0.620147] Bluetooth: HCI device and connection manager initialized
[    0.626770] Bluetooth: HCI socket layer initialized
[    0.631835] Bluetooth: L2CAP socket layer initialized
[    0.637115] Bluetooth: SCO socket layer initialized
[    0.642547] Switching to clocksource gp_timer
[    0.665252] AppArmor: AppArmor Filesystem Enabled
[    0.679412] NET: Registered protocol family 2
[    0.684539] TCP established hash table entries: 262144 (order: 9,
2097152 bytes)
[    0.695587] TCP bind hash table entries: 65536 (order: 8, 1572864 bytes)
[    0.705139] TCP: Hash tables configured (established 262144 bind 65536)
[    0.712066] TCP: reno registered
[    0.715454] UDP hash table entries: 1024 (order: 4, 65536 bytes)
[    0.721801] UDP-Lite hash table entries: 1024 (order: 4, 65536 bytes)
[    0.728790] NET: Registered protocol family 1
[    0.733734] RPC: Registered named UNIX socket transport module.
[    0.739929] RPC: Registered udp transport module.
[    0.744842] RPC: Registered tcp transport module.
[    0.749755] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.756835] NetWinder Floating Point Emulator V0.97 (double precision)
[    0.764434] audit: initializing netlink socket (disabled)
[    0.770172] type=2000 audit(0.730:1): initialized
[    0.850372] VFS: Disk quotas dquot_6.5.2
[    0.854522] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.861907] NFS: Registering the id_resolver key type
[    0.867218] Key type id_resolver registered
[    0.871643] Key type id_legacy registered
[    0.875854] fuse init (API version 7.20)
[    0.880218] msgmni has been set to 3518
[    0.885467] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 252)
[    0.893188] io scheduler noop registered
[    0.897277] io scheduler deadline registered
[    0.901855] io scheduler cfq registered (default)
[    0.907562] omap_uart.0: ttyO0 at MMIO 0x48020000 (irq = 72) is a OMAP UART0
[    0.915252] omap_uart.1: ttyO1 at MMIO 0x48022000 (irq = 73) is a OMAP UART1
[    0.922943] omap_uart.2: ttyO2 at MMIO 0x48024000 (irq = 74) is a OMAP UART2
[    0.930358] console [ttyO2] enabled, bootconsole disabled
[    0.930358] console [ttyO2] enabled, bootconsole disabled
[    0.948272] brd: module loaded
[    0.954833] loop: module loaded
[    0.958557] ahci ti81xx-ahci.0: forcing PORTS_IMPL to 0x3
[    0.964263] ahci ti81xx-ahci.0: AHCI 0001.0100 32 slots 2 ports 3
Gbps 0x3 impl platform mode
[    0.973236] ahci ti81xx-ahci.0: flags: ncq sntf pm led clo only pmp
pio slum part ccc
[    0.982971] scsi0 : ahci_platform
[    0.986785] scsi1 : ahci_platform
[    0.990478] ata1: SATA max UDMA/133 mmio [mem
0x4a140000-0x4a150fff] port 0x100 irq 16
[    0.998779] ata2: SATA max UDMA/133 mmio [mem
0x4a140000-0x4a150fff] port 0x180 irq 16
[    1.007904] omap2_mcspi omap2_mcspi.1: registered master spi1
[    1.014312] spi spi1.1: setup: speed 24000000, sample leading edge,
clk normal
[    1.021942] spi spi1.1: setup mode 0, 8 bits/w, 45000000 Hz max --> 0
[    1.028991] omap2_mcspi omap2_mcspi.1: registered child spi1.1
[    1.035369] tun: Universal TUN/TAP device driver, 1.6
[    1.040710] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.097564] davinci_mdio davinci_mdio.0: davinci mdio revision 1.6
[    1.104064] davinci_mdio davinci_mdio.0: detected phy mask fffffffc
[    1.111968] libphy: davinci_mdio.0: probed
[    1.116271] davinci_mdio davinci_mdio.0: phy[0]: device
davinci_mdio-0:00, driver Micrel KSZ9021
Gigabit PHY
[    1.126647] davinci_mdio davinci_mdio.0: phy[1]: device
davinci_mdio-0:01, driver Micrel KSZ9021
Gigabit PHY
[    1.137298] usbcore: registered new interface driver usbtmc
[    1.143249] Initializing USB Mass Storage driver...
[    1.148498] usbcore: registered new interface driver usb-storage
[    1.154785] USB Mass Storage support registered.
[    1.159759] usbcore: registered new interface driver libusual
[    1.165771] musb-hdrc: version 6.0, ?dma?, otg (peripheral+host)
[    1.172149] musb-hdrc: ConfigData=0xde (UTMI-8, dyn FIFOs, bulk
combine, bulk split, HB-ISO Rx, H
B-ISO Tx, SoftConn)
[    1.183380] musb-hdrc: MHDRC RTL version 2.0
[    1.187927] musb-hdrc: setup fifo_mode 4
[    1.192047] musb-hdrc: 28/31 max ep, 16384/16384 memory
[    1.197692] musb-hdrc musb-hdrc.0: MUSB HDRC host driver
[    1.203491] musb-hdrc musb-hdrc.0: new USB bus registered, assigned
bus number 1
[    1.211242] musb-hdrc musb-hdrc.0: supports USB remote wakeup
[    1.217315] usb usb1: default language 0x0409
[    1.221923] usb usb1: udev 1, busnum 1, minor = 0
[    1.226867] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.233978] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.241546] usb usb1: Product: MUSB HDRC host driver
[    1.246765] usb usb1: Manufacturer: Linux
3.6.5-rt15-deka-00032-ge65008b musb-hcd
[    1.254577] usb usb1: SerialNumber: musb-hdrc.0
[    1.259735] usb usb1: usb_probe_device
[    1.263671] usb usb1: configuration #1 chosen from 1 choice
[    1.269531] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    1.275665] hub 1-0:1.0: usb_probe_interface
[    1.280212] hub 1-0:1.0: usb_probe_interface - got id
[    1.285522] hub 1-0:1.0: USB hub found
[    1.289459] hub 1-0:1.0: 1 port detected
[    1.293579] hub 1-0:1.0: standalone hub
[    1.297607] hub 1-0:1.0: individual port power switching
[    1.303161] hub 1-0:1.0: no over-current protection
[    1.308288] hub 1-0:1.0: Single TT
[    1.311859] hub 1-0:1.0: TT requires at most 8 FS bit times (666 ns)
[    1.318511] hub 1-0:1.0: power on to power good time: 10ms
[    1.324279] hub 1-0:1.0: local power source is good
[    1.329376] hub 1-0:1.0: enabling power on all ports
[    1.334838] musb-hdrc musb-hdrc.0: USB Host mode controller at
0x47401000 using PIO, IRQ 18
[    1.343688] musb-hdrc: ConfigData=0xde (UTMI-8, dyn FIFOs, bulk
combine, bulk split, HB-ISO Rx, H
B-ISO Tx, SoftConn)
[    1.354736] musb-hdrc: MHDRC RTL version 2.0
[    1.357543] ata2: SATA link down (SStatus 0 SControl 300)
[    1.364959] musb-hdrc: setup fifo_mode 4
[    1.369049] musb-hdrc: 28/31 max ep, 16384/16384 memory
[    1.374694] musb-hdrc musb-hdrc.1: MUSB HDRC host driver
[    1.380493] musb-hdrc musb-hdrc.1: new USB bus registered, assigned
bus number 2
[    1.388275] musb-hdrc musb-hdrc.1: supports USB remote wakeup
[    1.394378] usb usb2: default language 0x0409
[    1.398956] usb usb2: udev 1, busnum 2, minor = 128
[    1.404083] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.411193] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.418762] usb usb2: Product: MUSB HDRC host driver
[    1.423919] usb usb2: Manufacturer: Linux
3.6.5-rt15-deka-00032-ge65008b musb-hcd
[    1.427551] hub 1-0:1.0: state 7 ports 1 chg 0000 evt 0000
[    1.437530] usb usb2: SerialNumber: musb-hdrc.1
[    1.442687] usb usb2: usb_probe_device
[    1.446624] usb usb2: configuration #1 chosen from 1 choice
[    1.452484] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    1.458618] hub 2-0:1.0: usb_probe_interface
[    1.463104] hub 2-0:1.0: usb_probe_interface - got id
[    1.468383] hub 2-0:1.0: USB hub found
[    1.472351] hub 2-0:1.0: 1 port detected
[    1.476440] hub 2-0:1.0: standalone hub
[    1.480468] hub 2-0:1.0: individual port power switching
[    1.486022] hub 2-0:1.0: no over-current protection
[    1.491149] hub 2-0:1.0: Single TT
[    1.494720] hub 2-0:1.0: TT requires at most 8 FS bit times (666 ns)
[    1.501373] hub 2-0:1.0: power on to power good time: 10ms
[    1.507141] hub 2-0:1.0: local power source is good
[    1.512237] hub 2-0:1.0: enabling power on all ports
[    1.517730] musb-hdrc musb-hdrc.1: USB Host mode controller at
0x47401800 using PIO, IRQ 19
[    1.526824] mousedev: PS/2 mouse device common for all mice
[    1.536163] rtc-ds1307 2-0068: rtc core: registered ds3231 as rtc0
[    1.542785] i2c /dev entries driver
[    1.547088] softdog: Software Watchdog Timer: 0.08 initialized.
soft_noboot=0 soft_margin=60 sec
soft_panic=0 (nowayout=0)
[    1.557617] ata1: softreset failed (device not ready)
[    1.557617] ata1: applying PMP SRST workaround and retrying
[    1.569976] usbcore: registered new interface driver bcm203x
[    1.575988] usbcore: registered new interface driver btusb
[    1.607696] hub 2-0:1.0: state 7 ports 1 chg 0000 evt 0000
[    1.617889] Registered led device: D16:green:user
[    1.622955] Registered led device: D18:green:watchdog
[    1.629425] Registered led device: D15:green:health
[    1.639587] Registered led device: D17:green:mmc0
[    1.753479] pluto-audio pluto-audio:  wm8978-hifi <->
davinci-mcasp.2 mapping ok
[    1.517730] musb-hdrc musb-hdrc.1: USB Host mode controller at
0x47401800 using PIO, IRQ 19
[    1.526824] mousedev: PS/2 mouse device common for all mice
[    1.536163] rtc-ds1307 2-0068: rtc core: registered ds3231 as rtc0
[    1.542785] i2c /dev entries driver
[    1.547088] softdog: Software Watchdog Timer: 0.08 initialized.
soft_noboot=0 soft_margin=60 sec
soft_panic=0 (nowayout=0)
[    1.557617] ata1: softreset failed (device not ready)
[    1.557617] ata1: applying PMP SRST workaround and retrying
[    1.569976] usbcore: registered new interface driver bcm203x
[    1.575988] usbcore: registered new interface driver btusb
[    1.607696] hub 2-0:1.0: state 7 ports 1 chg 0000 evt 0000
[    1.617889] Registered led device: D16:green:user
[    1.622955] Registered led device: D18:green:watchdog
[    1.629425] Registered led device: D15:green:health
[    1.639587] Registered led device: D17:green:mmc0
[    1.753479] pluto-audio pluto-audio:  wm8978-hifi <->
davinci-mcasp.2 mapping ok
[    1.757690] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.757934] ata1.00: ATA-8: Emphase D3VHSD004G1P, 110520C, max UDMA/133
[    1.757934] ata1.00: 7835184 sectors, multi 16: LBA
[    1.758178] ata1.00: configured for UDMA/133
[    1.758605] scsi 0:0:0:0: Direct-Access     ATA      Emphase
D3VHSD00 1105 PQ: 0 ANSI: 5
[    1.759399] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.759887] sd 0:0:0:0: [sda] 7835184 512-byte logical blocks:
(4.01 GB/3.73 GiB)
[    1.760131] sd 0:0:0:0: [sda] Write Protect is off
[    1.760162] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.760284] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or F
UA
[    1.761810]  sda: sda1
[    1.762939] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.767150] mmc0: host does not support reading read-only switch.
assuming write-enable.
[    1.771423] mmc0: new high speed SD card at address e624
[    1.771667] blk_limits_max_hw_sectors: set to minimum 8
[    1.771697] blk_queue_max_segment_size: set to minimum 4096
[    1.777740] mmcblk0: mmc0:e624 SU02G 1.84 GiB
[    1.795471]  mmcblk0: p1 p2
[    1.874572] TCP: cubic registered
[    1.878082] NET: Registered protocol family 17
[    1.882904] Bluetooth: RFCOMM TTY layer initialized
[    1.888122] Bluetooth: RFCOMM socket layer initialized
[    1.893524] Bluetooth: RFCOMM ver 1.11
[    1.897430] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    1.903015] Bluetooth: BNEP filters: protocol multicast
[    1.908477] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    1.914794] Key type dns_resolver registered
[    1.919372] VFP support v0.3: implementor 41 architecture 3 part 30
variant c rev 3
[    1.927398] Power Management for TI81XX.
[    1.932067] registered taskstats version 1
[    1.937194] Key type encrypted registered
[    1.944702] rtc-ds1307 2-0068: setting system clock to 2012-11-14
12:51:08 UTC (1352897468)
[    1.998931] devtmpfs: mounted
[    2.002410] Freeing init memory: 324K
in[    3.138275] ------------[ cut here ]------------
[    3.138305] kernel BUG at /home/grant/hacking/linux/kernel/sched/core.c:3817!
[    3.138305] Internal error: Oops - BUG: 0 [#1] PREEMPT ARM
[    3.138305] Modules linked in:
[    3.138305] CPU: 0    Not tainted  (3.6.5-rt15-deka-00032-ge65008b #10)
[    3.138336] PC is at preempt_schedule_irq+0x70/0x74
[    3.138336] LR is at svc_preempt+0x8/0x20
[    3.138336] pc : [<8054dbb0>]    lr : [<8054ec10>]    psr: 20000193
[    3.138336] sp : eebcbd68  ip : eebcbd80  fp : eebcbd7c
[    3.138336] r10: 00000037  r9 : eebca000  r8 : 8054ebf8
[    3.138366] r7 : eebcbdb4  r6 : ffffffff  r5 : a0000013  r4 : eebca000
[    3.138366] r3 : 00000001  r2 : 00000000  r1 : 00000000  r0 : eebcbd68
[    3.138366] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment user
[    3.138366] Control: 10c5387d  Table: eeb84019  DAC: 00000015
[    3.138366] Process loadkeys (pid: 113, stack limit = 0xeebca2e8)
[    3.138366] Stack: (0xeebcbd68 to 0xeebcc000)
[    3.138397] bd60:                   00000000 80089428 eebcbe24
eebcbd80 8054ec10 8054db4c
[    3.138397] bd80: 80843a9c eeac6280 00000000 00000001 eebca000
80843a9c eeac6280 000055e0
[    3.138397] bda0: 00000000 00000001 00000037 eebcbe24 00000001
eebcbdc8 8054e2b4 80089428
[    3.138397] bdc0: a0000013 ffffffff 8054dff0 80550bf0 8083454c
8083454c eebcbdf4 eebcbde8
[    3.138427] bde0: 8054e590 8054df80 eebcbe34 eebcbdf8 8011d0d4
00000000 8025199c 8028ab01
[    3.138427] be00: eebcbe24 eeba5200 eebca000 00004b47 000055e0
00000000 eebcbe34 eebcbe28
[    3.138427] be20: 8054e5c8 8054e258 eebcbe64 eebcbe38 80304218
8054e5bc 8004c404 030c375e
[    3.138427] be40: eebca000 00004b47 eeb92800 ef009000 00000000
7eb5dbac eebcbecc eebcbe68
[    3.138458] be60: 802fe490 8030409c 800714ac 800713c4 00000000
eebca000 00000000 00000000
[    3.138458] be80: eebcbeb4 8054db88 8085a47c 80834360 8080d070
8080c0f8 b9dccdff 00000000
[    3.138458] bea0: 80015408 eeb92800 00004b47 ee002cc0 7eb5dbac
eeb92800 eebca000 00000000
[    3.138458] bec0: eebcbf44 eebcbed0 802f432c 802fdf1c 80048d30
80550bf0 80840318 00000043
[    3.138488] bee0: eebcbf0c eebcbef0 80016158 eebca000 80000013
ffffffff eebcbf64 8054ebe0
[    3.138488] bf00: eebca000 8054db94 eebcbf2c eebcbf18 8054db94
80550bf0 00000000 801332d0
[    3.138488] bf20: ee002cc0 00002180 00004b47 00000005 00000000
00000000 eebcbf74 eebcbf48
[    3.138488] bf40: 80133024 802f41b0 00004b47 00000036 80015408
80252688 ee002cc0 7eb5dbac
[    3.138488] bf60: 00004b47 00000005 eebcbfa4 eebcbf78 80133338
80132fa0 ffffffff 00000000
[    3.138519] bf80: 80015408 00000037 00024a70 0000005e 00000036
80015408 00000000 eebcbfa8
[    3.138519] bfa0: 800151c0 801332c0 00000037 00024a70 00000005
00004b47 7eb5dbac 0000030c
[    3.138519] bfc0: 00000037 00024a70 0000005e 00000036 00000000
00000178 0000006e 7eb5dbac
[    3.138519] bfe0: 00024f74 7eb5db90 00009da3 76f519ec 20000010
00000005 00000000 00000000
[    3.138549] [<8054dbb0>] (preempt_schedule_irq+0x70/0x74) from
[<8054ec10>] (svc_preempt+0x8/0x20)
[    3.138580] [<8054ec10>] (svc_preempt+0x8/0x20) from [<80089428>]
(__try_to_take_rt_mutex+0x0/0x16c)
[    3.138580] [<80089428>] (__try_to_take_rt_mutex+0x0/0x16c) from
[<8054e5c8>] (rt_spin_lock+0x18/0x1c)
[    3.138610] [<8054e5c8>] (rt_spin_lock+0x18/0x1c) from [<80304218>]
(vt_do_kdsk_ioctl+0x188/0x3a8)
[    3.138610] [<80304218>] (vt_do_kdsk_ioctl+0x188/0x3a8) from
[<802fe490>] (vt_ioctl+0x580/0x1570)
[    3.138610] [<802fe490>] (vt_ioctl+0x580/0x1570) from [<802f432c>]
(tty_ioctl+0x188/0x93c)
[    3.138641] [<802f432c>] (tty_ioctl+0x188/0x93c) from [<80133024>]
(do_vfs_ioctl+0x90/0x320)
[    3.138641] [<80133024>] (do_vfs_ioctl+0x90/0x320) from
[<80133338>] (sys_ioctl+0x84/0x8c)
[    3.138641] [<80133338>] (sys_ioctl+0x84/0x8c) from [<800151c0>]
(ret_fast_syscall+0x0/0x30)
[    3.138671] Code: e594c000 e31c0008 1afffff2 e89da818 (e7f001f2)
[    3.500030] ---[ end trac


On Fri, Nov 2, 2012 at 10:11 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Dear RT Folks,
>
> I'm pleased to announce the 3.6.5-rt15 brown paper bag release.
>
> Changes since 3.6.5-rt14:
>
>    * Fix typos and other stupidities^Wcrimes committed by an
>      overworked and tired RT maintainer (courtesy Paul Gortmaker)
>
> The embarrasing delta patch against 3.6.5-rt14 is appended below and
> can be found here:
>
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.5-rt14-rt15.patch.xz
>
> The RT patch against 3.6.5 can be found here:
>
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.5-rt15.patch.xz
>
> The split quilt queue is available at:
>
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.5-rt15.tar.xz
>
> Enjoy,
>
>         tglx
>
> ------------->
> Index: linux-stable/arch/x86/kernel/entry_32.S
> ===================================================================
> --- linux-stable.orig/arch/x86/kernel/entry_32.S
> +++ linux-stable/arch/x86/kernel/entry_32.S
> @@ -597,7 +597,7 @@ ENDPROC(system_call)
>         ALIGN
>         RING0_PTREGS_FRAME              # can't unwind into user space anyway
>  work_pending:
> -       testl $_TIF_NEED_RESCHED_MASK, %cx
> +       testl $_TIF_NEED_RESCHED_MASK, %ecx
>         jz work_notifysig
>  work_resched:
>         call schedule
> Index: linux-stable/kernel/Kconfig.preempt
> ===================================================================
> --- linux-stable.orig/kernel/Kconfig.preempt
> +++ linux-stable/kernel/Kconfig.preempt
> @@ -10,7 +10,7 @@ config HAVE_PREEMPT_LAZY
>         bool
>
>  config PREEMPT_LAZY
> -       def_bool y if HAVE_PREEMPT_LAZE && PREEMPT_RT_FULL
> +       def_bool y if HAVE_PREEMPT_LAZY && PREEMPT_RT_FULL
>
>  choice
>         prompt "Preemption Model"
> Index: linux-stable/kernel/sched/features.h
> ===================================================================
> --- linux-stable.orig/kernel/sched/features.h
> +++ linux-stable/kernel/sched/features.h
> @@ -76,4 +76,3 @@ SCHED_FEAT(PREEMPT_LAZY, true)
>  SCHED_FEAT(FORCE_SD_OVERLAP, false)
>  SCHED_FEAT(RT_RUNTIME_SHARE, true)
>  SCHED_FEAT(LB_MIN, false)
> -
> Index: linux-stable/localversion-rt
> ===================================================================
> --- linux-stable.orig/localversion-rt
> +++ linux-stable/localversion-rt
> @@ -1 +1 @@
> --rt14
> +-rt15
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
