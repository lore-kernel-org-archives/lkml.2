Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab0EXOVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 10:21:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36291 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab0EXOVa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 10:21:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=K4fFL7NrgUVv9MI9VOPeDmmR5bMhHkT5nIV4NbPh7SDkqbKr79jWhvR7iRnRHoZE0p
         vbrSAX7ChusX0qyarkBqZ3yhiv82nAghoryfUAr+19IYpKd07rfqtSdlv7JkAwBufl+n
         imJzKwlFAeEgg1b3UOtRgL+3sdOCOuNnZhn/4=
Date: Mon, 24 May 2010 22:20:33 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, a.p.zijlstra@chello.nl
Subject: Re: [RESEND PATCH] ARM: fix 'unannotated irqs-on' lockdep warning
Message-ID: <20100524222033.12b25f2a@tom-lei>
In-Reply-To: <20100524101416.GA21117@n2100.arm.linux.org.uk>
References: <1274615328-27953-1-git-send-email-tom.leiming@gmail.com>
	<20100523123801.GC950@n2100.arm.linux.org.uk>
	<AANLkTikRp0EHxshKYq39p18ymoRNAtyHrNm3yq6A49-r@mail.gmail.com>
	<20100523141300.GD950@n2100.arm.linux.org.uk>
	<AANLkTinV9Na9zxYMIfTr893Ynnc0YOk2B6uPKEa9s4R1@mail.gmail.com>
	<20100523194746.GE950@n2100.arm.linux.org.uk>
	<20100524112355.18424622@tom-lei>
	<20100524071921.GA17528@n2100.arm.linux.org.uk>
	<20100524101416.GA21117@n2100.arm.linux.org.uk>
Organization: private
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 May 2010 11:14:16 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> Right, I see what the problem is now - it's all to do with threads
> created with kernel_thread() confusing lockdep.
> 
> I'm of the opinion that all your changes in entry*.S are the wrong
> way to fix this - not only does it add additional overhead where
> none is really necessary, it adds additional complexity.
> 
> So, here's a patch to solve the warning you quoted.

No, your patch does not fix the issue, I still can see the lockdep
warning after applying it against Linux 2.6.34-next-20100524.

Follows the dmesg info:

Texas Instruments X-Loader 1.4.4ss (Apr 13 2010 - 22:36:28)
Beagle Rev C4
Reading boot sector
Loading u-boot.bin from mmc


U-Boot 2010.03 (May 04 2010 - 08:48:31)

OMAP3530-GP ES3.1, CPU-OPP2, L3-165MHz, Max clock-720Mhz
OMAP3 Beagle board + LPDDR/NAND
I2C:   ready
DRAM:  256 MB
NAND:  256 MiB
In:    serial
Out:   serial
Err:   serial

Probing for expansion boards, if none are connected you'll see a harmless I2C error.

timed out in wait_for_pin: I2C_STAT=0
I2C read: I/O error
Unrecognized expansion board: 0
Beagle Rev C4
Die ID #16c00004000000000403730515017007
Hit any key to stop autoboot:  3  2  1  0 
OMAP3 beagleboard.org # prit ntenv
baudrate=115200
loadaddr=0x80200000
rdaddr=0x81600000
console=ttyS2,115200n8
optargs=
mmcargs=setenv bootargs console=${console} ${optargs} root=/dev/mmcblk0p2 rw rootfstype=ext3 rootwait
ramargs=setenv bootargs console=${console} ${optargs} root=/dev/ram0 rw ramdisk_size=32768 initrd=${rdaddr},32M
ubifsargs=setenv bootargs console=${console} ${optargs} root=ubi0:beagleroot ubi.mtd=4 rw rootfstype=ubifs
jffs2args=setenv bootargs console=${console} ${optargs} root=/dev/mtdblock4 rw rootfstype=jffs2
loadbootscript=fatload mmc 0 ${loadaddr} boot.scr
bootscript=echo Running bootscript from mmc ...; autoscr ${loadaddr}
loadramdisk=fatload mmc 0 ${rdaddr} ramdisk.gz
ramboot=echo Booting from ramdisk.gz ...; run ramargs; bootm ${loadaddr}
mmcboot=echo Booting from mmc ...; run mmcargs; bootm ${loadaddr}
nandboot=echo Booting from nand ...; run jffs2args; nand read ${loadaddr} 280000 400000; bootm ${loadaddr}
usbtty=cdc_acm
stdout=serial,usbtty
stdin=serial,usbtty
stderr=serial,usbtty
serial=16c00004000000000403730515017007
dieid#=16c00004000000000403730515017007
restore_c41=mmc init;fatload mmc 0 82000000 MLO;nand unlock;nandecc hw;nand erase 0 80000;nand write 82000000 0 20000;nand write 82000000 20000 20000;nand write 82000000 40000 20000;nand write 82000000 60000 20000
restore_c42=fatload mmc 0 0x80200000 u-boot.bin;nand unlock;nandecc sw;nand erase 80000 160000;nand write 0x80200000 80000 160000
mtdids=nand0=nand
bootcmd=mmc init;run loaduimage;run mmcboot
restore_fac=if mmc init; then if run loadbootscript; then run bootscript; else if run loaduimage; then if run loadramdisk;then run ramboot; else run mmcboot; fi; else run nandboot; fi; fi; else run nandboot; fi
loaduimage=fatload mmc 0 ${loadaddr} uImage
bootdelay=3
buddy=unknown
mpurate=720

Environment size: 1771/131068 bytes
OMAP3 beagleboard.org # setenv loaduimage 'fatload mmc 0 ${loadaddr} uImage-next'
OMAP3 beagleboard.org # run bootcmd
mmc1 is available
reading uImage-next

2707936 bytes read
Booting from mmc ...
## Booting kernel from Legacy Image at 80200000 ...
   Image Name:   Linux-2.6.34-next-20100524+
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    2707872 Bytes =  2.6 MB
   Load Address: 80008000
   Entry Point:  80008000
   Verifying Checksum ... OK
   Loading Kernel Image ... OK
OK

Starting kernel ...

Uncompressing Linux... done, booting the kernel.
[    0.000000] Linux version 2.6.34-next-20100524+ (tom@tom-lei) (gcc version 4.3.3 (Sourcery G++ Lite 2009q1-203) ) #56 PREEMPT Mon May 24 21:56:03 CST 2010
[    0.000000] CPU: ARMv7 Processor [411fc083] revision 3 (ARMv7), cr=10c53c7f
[    0.000000] CPU: VIPT nonaliasing data cache, VIPT nonaliasing instruction cache
[    0.000000] Machine: OMAP3 Beagle Board
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] OMAP3430/3530 ES3.1 (l2cache iva sgx neon isp )
[    0.000000] SRAM: Mapped pa 0x40200000 to va 0xfe400000 size: 0x100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 65024
[    0.000000] Kernel command line: console=ttyS2,115200n8 root=/dev/mmcblk0p2 rw rootfstype=ext3 rootwait
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Memory: 128MB 128MB = 256MB total
[    0.000000] Memory: 245020k/245020k available, 17124k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     DMA     : 0xffc00000 - 0xffe00000   (   2 MB)
[    0.000000]     vmalloc : 0xd0800000 - 0xf8000000   ( 632 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)
[    0.000000]     modules : 0xbf000000 - 0xc0000000   (  16 MB)
[    0.000000]       .init : 0xc0008000 - 0xc0039000   ( 196 kB)
[    0.000000]       .text : 0xc0039000 - 0xc050d000   (4944 kB)
[    0.000000]       .data : 0xc0564000 - 0xc0717ab0   (1743 kB)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:402
[    0.000000] Clocking rate (Crystal/Core/MPU): 26.0/332/500 MHz
[    0.000000] omap_hwmod: l3_hwmod: cannot be enabled (3)
[    0.000000] omap_hwmod: l4_core_hwmod: cannot be enabled (3)
[    0.000000] omap_hwmod: l4_per_hwmod: cannot be enabled (3)
[    0.000000] omap_hwmod: l4_wkup_hwmod: cannot be enabled (3)
[    0.000000] Reprogramming SDRC clock to 332000000 Hz
[    0.000000] GPMC revision 5.0
[    0.000000] IRQ: Found an INTC at 0xfa200000 (revision 4.0) with 96 interrupts
[    0.000000] Total of 96 interrupts on 1 active controller
[    0.000000] OMAP GPIO hardware version 2.5
[    0.000000] OMAP clockevent source: GPTIMER12 at 32768 Hz
[    0.000000] Console: colour dummy device 80x30
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3951 kB
[    0.000000]  per task-struct memory footprint: 2304 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] Calibrating delay loop... 497.82 BogoMIPS (lpj=1941504)
[    0.000000] Mount-cache hash table entries: 512
[    0.000000] CPU: Testing write buffer coherency: ok
[    0.000000] devtmpfs: initialized
[    0.000000] regulator: core version 0.5
[    0.000000] NET: Registered protocol family 16
[    0.000000] Found NAND on CS0
[    0.000000] Registering NAND on CS0
[    0.000000] Unable to get DVI reset GPIO
[    0.000000] hw perfevents: enabled with ARMv7 Cortex-A8 PMU driver, 5 counters available
[    0.000274] OMAP DMA hardware revision 4.0
[    0.415679] bio: create slab <bio-0> at 0
[    0.469024] SCSI subsystem initialized
[    0.482971] usbcore: registered new interface driver usbfs
[    0.490814] usbcore: registered new interface driver hub
[    0.495025] usbcore: registered new device driver usb
[    0.505828] i2c_omap i2c_omap.1: bus 1 rev3.12 at 2600 kHz
[    0.552673] twl4030: PIH (irq 7) chaining IRQs 368..375
[    0.553161] twl4030: power (irq 373) chaining IRQs 376..383
[    0.561676] twl4030: gpio (irq 368) chaining IRQs 384..401
[    0.588470] regulator: VUSB1V5: 1500 mV normal standby
[    0.602264] regulator: VUSB1V8: 1800 mV normal standby
[    0.615051] regulator: VUSB3V1: 3100 mV normal standby
[    0.644683] twl4030_usb twl4030_usb: Initialized TWL4030 USB module
[    0.662658] regulator: VMMC1: 1850 <--> 3150 mV at 3000 mV normal standby
[    0.675537] regulator: VDAC: 1800 mV normal standby
[    0.689483] regulator: VDVI: 1800 mV normal standby
[    0.706085] regulator: VSIM: 1800 <--> 3000 mV at 1800 mV normal standby
[    0.709747] i2c_omap i2c_omap.3: bus 3 rev3.12 at 100 kHz
[    0.736755] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.757629] Switching to clocksource 32k_counter
[    1.133636] musb_hdrc: version 6.0, musb-dma, otg (peripheral+host), debug=0
[    1.139038] musb_hdrc musb_hdrc: USB OTG mode controller at fa0ab000 using DMA, IRQ 92
[    1.147277] NET: Registered protocol family 2
[    1.150573] IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
[    1.159820] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    1.160766] TCP bind hash table entries: 8192 (order: 6, 327680 bytes)
[    1.169006] TCP: Hash tables configured (established 8192 bind 8192)
[    1.169189] TCP reno registered
[    1.169311] UDP hash table entries: 128 (order: 1, 12288 bytes)
[    1.170135] UDP-Lite hash table entries: 128 (order: 1, 12288 bytes)
[    1.175537] NET: Registered protocol family 1
[    1.183532] RPC: Registered udp transport module.
[    1.183563] RPC: Registered tcp transport module.
[    1.183624] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.196899] PMU: registered new PMU device of type 0
[    1.200012] NetWinder Floating Point Emulator V0.97 (double precision)
[    1.231811] VFS: Disk quotas dquot_6.5.2
[    1.232421] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.256347] JFFS2 version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
[    1.261993] msgmni has been set to 478
[    1.278167] alg: No test for stdrng (krng)
[    1.279144] io scheduler noop registered
[    1.279174] io scheduler deadline registered
[    1.280242] io scheduler cfq registered (default)
[    1.352478] OMAP DSS rev 2.0
[    1.353668] OMAP DISPC rev 3.0
[    1.354309] OMAP VENC rev 2
[    1.954925] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.023956] serial8250.0: ttyS0 at MMIO 0x4806a000 (irq = 72) is a ST16654
[    2.058380] serial8250.1: ttyS1 at MMIO 0x4806c000 (irq = 73) is a ST16654
[    2.093322] serial8250.2: ttyS2 at MMIO 0x49020000 (irq = 74) is a ST16654
[    3.225219] console [ttyS2] enabled
[    3.494750] brd: module loaded
[    3.627441] loop: module loaded
[    3.684173] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.692993] ehci-omap ehci-omap.0: OMAP-EHCI Host Controller
[    3.715576] ehci-omap ehci-omap.0: new USB bus registered, assigned bus number 1
[    3.726104] ehci-omap ehci-omap.0: irq 77, io mem 0x48064800
[    3.742553] ehci-omap ehci-omap.0: USB 2.0 started, EHCI 1.00
[    3.753845] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.760864] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.768249] usb usb1: Product: OMAP-EHCI Host Controller
[    3.773742] usb usb1: Manufacturer: Linux 2.6.34-next-20100524+ ehci_hcd
[    3.780517] usb usb1: SerialNumber: ehci-omap.0
[    3.811676] hub 1-0:1.0: USB hub found
[    3.817016] hub 1-0:1.0: 3 ports detected
[    3.870391] i2c /dev entries driver
[    3.901184] IR NEC protocol handler initialized
[    3.905792] IR RC5(x) protocol handler initialized
[    3.911102] IR RC6 protocol handler initialized
[    3.915832] IR JVC protocol handler initialized
[    3.920410] IR Sony protocol handler initialized
[    3.925659] Linux video capture interface: v2.00
[    3.939971] cpuidle: using governor ladder
[    3.944122] cpuidle: using governor menu
[    4.089355] No device for DAI omap-mcbsp-dai-0
[    4.094024] No device for DAI omap-mcbsp-dai-1
[    4.098541] No device for DAI omap-mcbsp-dai-2
[    4.103179] No device for DAI omap-mcbsp-dai-3
[    4.107666] No device for DAI omap-mcbsp-dai-4
[    4.112335] OMAP3 Beagle/Devkit8000 SoC init
[    4.133605] asoc: twl4030 <-> omap-mcbsp-dai-0 mapping ok
[    4.237731] ALSA device list:
[    4.240722]   #0: omap3beagle (twl4030)
[    4.246368] TCP cubic registered
[    4.249664] NET: Registered protocol family 17
[    4.256347] NET: Registered protocol family 15
[    4.263702] Power Management for TI OMAP3.
[    4.518066] VFP support v0.3: implementor 41 architecture 3 part 30 variant c rev 1
[    4.527282] mmc0: new SD card at address 0001
[    4.546081] mmcblk0: mmc0:0001 064MB 118 MiB 
[    4.559875]  mmcblk0:
[    4.569396]  p1 p2
[    4.609100] kmemleak: Kernel memory leak detector initialized
[    4.616729] omapfb omapfb: no driver for display
[    4.621643] omapfb omapfb: failed to setup omapfb
[    4.628204] kmemleak: Automatic memory scanning thread started
[    4.654388] regulator_init_complete: incomplete constraints, leaving VDVI on
[    4.662261] regulator_init_complete: incomplete constraints, leaving VDAC on
[    4.670959] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    4.715393] EXT3-fs: barriers not enabled
[    4.932281] EXT3-fs (mmcblk0p2): warning: mounting unchecked fs, running e2fsck is recommended
[    4.941253] kjournald starting.  Commit interval 5 seconds
[    4.956970] EXT3-fs (mmcblk0p2): using internal journal
[    4.962463] EXT3-fs (mmcblk0p2): recovery complete
[    4.978637] EXT3-fs (mmcblk0p2): mounted filesystem with writeback data mode
[    4.986999] VFS: Mounted root (ext3 filesystem) on device 179:2.
[    5.001312] devtmpfs: mounted
[    5.004943] Freeing init memory: 196K
[    5.093475] ------------[ cut here ]------------
[    5.098205] WARNING: at kernel/lockdep.c:3163 check_flags+0xcc/0x1dc()
[    5.104766] Modules linked in:
[    5.107910] [<c0040130>] (unwind_backtrace+0x0/0xf8) from [<c03d29cc>] (dump_stack+0x20/0x24)
[    5.116546] [<c03d29cc>] (dump_stack+0x20/0x24) from [<c006fce0>] (warn_slowpath_common+0x5c/0x74)
[    5.125579] [<c006fce0>] (warn_slowpath_common+0x5c/0x74) from [<c006fd24>] (warn_slowpath_null+0x2c/0x34)
[    5.135314] [<c006fd24>] (warn_slowpath_null+0x2c/0x34) from [<c009e840>] (check_flags+0xcc/0x1dc)
[    5.144378] [<c009e840>] (check_flags+0xcc/0x1dc) from [<c00a0b80>] (lockdep_trace_alloc+0x3c/0xfc)
[    5.153503] [<c00a0b80>] (lockdep_trace_alloc+0x3c/0xfc) from [<c0103d98>] (__kmalloc+0x6c/0x1fc)
[    5.162475] [<c0103d98>] (__kmalloc+0x6c/0x1fc) from [<c014a8d8>] (load_elf_binary+0x8cc/0x125c)
[    5.171356] [<c014a8d8>] (load_elf_binary+0x8cc/0x125c) from [<c010e03c>] (search_binary_handler+0x168/0x35c)
[    5.181365] [<c010e03c>] (search_binary_handler+0x168/0x35c) from [<c010f654>] (do_execve+0x224/0x320)
[    5.190765] [<c010f654>] (do_execve+0x224/0x320) from [<c003d7d4>] (kernel_execve+0x48/0x90)
[    5.199279] [<c003d7d4>] (kernel_execve+0x48/0x90) from [<c0039588>] (run_init_process+0x24/0x2c)
[    5.208251] [<c0039588>] (run_init_process+0x24/0x2c) from [<c003962c>] (init_post+0x9c/0xe4)
[    5.216857] [<c003962c>] (init_post+0x9c/0xe4) from [<c0008684>] (kernel_init+0x128/0x168)
[    5.225189] [<c0008684>] (kernel_init+0x128/0x168) from [<c003b10c>] (kernel_thread_exit+0x0/0x8)
[    5.234130] ---[ end trace b9d526d4d7022271 ]---
[    5.238800] possible reason: unannotated irqs-on.
[    5.243530] irq event stamp: 340905
[    5.247070] hardirqs last  enabled at (340904): [<c03d67b0>] _raw_spin_unlock_irqrestore+0x4c/0x78
[    5.256134] hardirqs last disabled at (340905): [<c0039b24>] __dabt_svc+0x64/0x80
[    5.263702] softirqs last  enabled at (340499): [<c0076da8>] __do_softirq+0x218/0x234
[    5.271606] softirqs last disabled at (340466): [<c0076e2c>] irq_exit+0x68/0xbc
init started: BusyBox v1.9.0 (2008-02-26 15:40:22 IST)
starting pid 429, tty '': '/etc/init.d/rcS'

    OMAP3EVM (v0.90) : System initialization...

    Kernel release : Linux 2.6.34-next-20100524+
    Kernel version : #56 PREEMPT Mon May 24 21:56:03 CST 2010

 Mounting /proc             : [SUCCESS]
 Mounting /sys              : [SUCCESS]
 Mounting /dev/pts          : [SUCCESS]
 Enabling hot-plug          : [SUCCESS]
 Populating /dev            : mkdir: cannot create directory '/dev/snd': File exists
[    6.570556] hub 1-0:1.0: __pm_runtime_suspend() from workqueue!
[    6.576568] hub 1-0:1.0: __pm_runtime_suspend() returns 0!
[    6.593933] usb usb1: __pm_runtime_suspend()!
[    6.598907] usb usb1: __pm_runtime_suspend() returns 0!
[SUCCESS]
 Mounting other filesystems : [SUCCESS]
 Starting syslogd           : Jan  1 00:00:10 OMAP3EVM syslog.info syslogd started: BusyBox v1.9.0
[SUCCESS]
 Starting telnetd           : 
[SUCCESS]

System initialization complete.

Please press Enter to activate this console. starting pid 452, tty '': '/bin/sh'

    Setting shell environment ...
    - Path
    - Aliases
    - Touchscreen

    Done!

[root@OMAP3EVM /]# 


