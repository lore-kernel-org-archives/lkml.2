Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab2JGQyi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 12:54:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab2JGQy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 12:54:28 -0400
Date: Sun, 7 Oct 2012 18:55:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: dl8bcu@dl8bcu.de, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: Re: [regression] boot failure on alpha, bisected
Message-ID: <20121007165534.GA8024@redhat.com>
References: <20121006204736.GA1830@ds20.borg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121006204736.GA1830@ds20.borg.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thorsten,

On 10/06, Thorsten Kranzkowski wrote:
>
> Hello!
>
> After upgrading from v3.5-rc7 to current git my system oopses and locks up
> early in the boot sequence.
> Bisecting points at:
>
>  commit ac3d0da8f3290b3d394cdb7f50604424a7cd6092
>  Author: Oleg Nesterov <oleg@redhat.com>
>  Date:   Sun Aug 26 21:12:09 2012 +0200
>
>     task_work: Make task_work_add() lockless
>
> as the culprit.
> See below for dmesg and config.
>
> The first WARNING: is apparently also shown on a working kernel, I don't know when
> it appeared.

Yes, it looks irrelevant...

> The second one and the BUG: are new: The WARNING occurs during the very first moments of
> the init script, the BUG occurs only one moment later, during execution of the vgscan utility,
> which then segfaults.  After that the kernel locks up, it responds to sysrq though.
>
> The preceeding commit (15674868d6c5985466835c56dd89d39235f16302) boots fine, using
> the same setup/config/build patch.

Hmm. I know nothing about arch/alpha and I can't understand its entry.S.
But _it seems_ to me that do_notify_resume() is called with irqs disabled.
If this is true, then imho arch/alpha should be fixed.

Before this commit task_work_run() enabled irqs, but this was the "side
effect" of spin_lock_irq/spin_unlock_irq, we should not rely on this.

Add cc's.



> This is a dual alpha ev6 system, monolithic kernel.
>
>
> If you have any idea on how to solve this problem, please let me know!
>
> thanks,
> Thorsten
>
>
> Local build patch to prevent GPREL linker errors:
>
> diff --git a/arch/alpha/Makefile b/arch/alpha/Makefile
> index 4759fe7..2cc3cc5 100644
> --- a/arch/alpha/Makefile
> +++ b/arch/alpha/Makefile
> @@ -12,7 +12,7 @@ NM := $(NM) -B
>
>  LDFLAGS_vmlinux	:= -static -N #-relax
>  CHECKFLAGS	+= -D__alpha__ -m64
> -cflags-y	:= -pipe -mno-fp-regs -ffixed-8 -msmall-data
> +cflags-y	:= -pipe -mno-fp-regs -ffixed-8
>  cflags-y	+= $(call cc-option, -fno-jump-tables)
>
>  cpuflags-$(CONFIG_ALPHA_EV4)		:= -mcpu=ev4
>
>
> Linux version 3.6.0-rc4-00055-gac3d0da-dirty (th@ds20) (gcc version 4.8.0 20120313 (experimental) (GCC) ) #15 SMP Sat Oct 6 13:05:22 UTC 2012
> Booting on Tsunami variation Goldrush using machine vector DP264 from SRM
> Major Options: SMP LEGACY_START VERBOSE_MCHECK MAGIC_SYSRQ
> Command line: root=/dev/sda1 rw video=rivafb:1280x1024@85 parport=0x3bc,7 console=ttyS0 console=tty0
> memcluster 0, usage 1, start        0, end      256
> memcluster 1, usage 0, start      256, end   130985
> memcluster 2, usage 1, start   130985, end   131072
> memcluster 3, usage 0, start   131072, end   262142
> memcluster 4, usage 1, start   262142, end   262144
> freeing pages 256:384
> freeing pages 1581:130985
> freeing pages 131072:262142
> reserving pages 1581:1585
> 4096K Bcache detected; load hit latency 20 cycles, load miss latency 106 cycles
> Console graphics on hose 0
> SMP: 2 CPUs probed -- cpu_present_mask = 3
> PERCPU: Embedded 5 pages/cpu @fffffc0001e0c000 s9344 r8192 d23424 u40960
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260350
> Kernel command line: root=/dev/sda1 rw video=rivafb:1280x1024@85 parport=0x3bc,7 console=ttyS0 console=tty0
> PID hash table entries: 4096 (order: 2, 32768 bytes)
> Dentry cache hash table entries: 262144 (order: 8, 2097152 bytes)
> Inode-cache hash table entries: 131072 (order: 7, 1048576 bytes)
> Memory: 2065144k/2097136k available (6160k kernel code, 29248k reserved, 561k data, 296k init)
> Hierarchical RCU implementation.
> 	RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=2.
> NR_IRQS:64
> Using epoch = 2000
> Console: colour VGA+ 80x25
> console [tty0] enabled
> console [ttyS0] enabled
> Calibrating delay loop... 990.32 BogoMIPS (lpj=483328)
> pid_max: default: 32768 minimum: 301
> Mount-cache hash table entries: 512
> SMP starting up secondaries.
> Brought up 2 CPUs
> SMP: Total of 2 processors activated (1991.29 BogoMIPS).
> ------------[ cut here ]------------
> WARNING: at /usr/src/linux.git/kernel/softirq.c:138 __local_bh_enable+0x8c/0xbc()
> Modules linked in:
> fffffc0000b7fc80 fffffc0000b8e438 fffffc000032cdec fffffc0000bc00f8
>        0000000000000200 0000000000000000 0000000000000001 0000000000000000
>        fffffc000032d4d4 fffffc0000b77a00 fffffc0000c22f20 0000000000000000
>        fffffc0000352fb4 0000000000000000 fffffc000031a91c 0000000000000000
>        fffffc0000b80000 0000000000000000 fffffc0000315860 fffffc0000b7fdc0
>        0000000000000be0 0000000000000001 fffffc0001e06100 fffffc0001e0c550
> Trace:
> [<fffffc000032cdec>] __local_bh_enable+0x8c/0xbc
> [<fffffc000032d4d4>] irq_enter+0x58/0x78
> [<fffffc0000352fb4>] scheduler_ipi+0x50/0xec
> [<fffffc000031a91c>] handle_ipi+0xb8/0x248
> [<fffffc0000315860>] do_entInt+0x6c/0x240
> [<fffffc0000912ee0>] __schedule+0x4d4/0x5dc
> [<fffffc0000310d20>] ret_from_sys_call+0x0/0x10
> [<fffffc000035116c>] finish_task_switch+0x5c/0xcc
> [<fffffc000035a238>] update_sd_lb_stats+0x32c/0x59c
> [<fffffc0000312a44>] cpu_idle+0x40/0x4c
> [<fffffc000034fd1c>] test_bit+0x0/0x3c
> [<fffffc0000312a30>] cpu_idle+0x2c/0x4c
> [<fffffc00008fbab4>] rest_init+0xc0/0xd4
> [<fffffc000031001c>] _stext+0x1c/0x20
>
> ---[ end trace 01aeb58cf09b7687 ]---
> xor: automatically using best checksumming function:
>    alpha prefetch:  2064.384 MB/sec
> NET: Registered protocol family 16
> PCI host bridge to bus 0000:00
> pci_bus 0000:00: root bus resource [io  0x0000-0x1ffffff]
> pci_bus 0000:00: root bus resource [mem 0x00000000-0x3fffffff]
> pci_bus 0000:00: No busn resource found for root bus, will use [bus 00-ff]
> PCI host bridge to bus 0001:01
> pci_bus 0001:01: root bus resource [io  0x200000000-0x201ffffff] (bus address [0x0000-0x1ffffff])
> pci_bus 0001:01: root bus resource [mem 0x200000000-0x23fffffff] (bus address [0x00000000-0x3fffffff])
> pci_bus 0001:01: No busn resource found for root bus, will use [bus 01-ff]
> pci 0001:01:07.0: Primary bus is hard wired to 0
> pci 0000:00:07.0: BAR 1: assigned [mem 0x10000000-0x17ffffff pref]
> pci 0000:00:07.0: BAR 0: assigned [mem 0x09000000-0x09ffffff]
> pci 0000:00:05.2: BAR 4: assigned [mem 0x0a000000-0x0a00ffff]
> pci 0000:00:07.0: BAR 6: assigned [mem 0x0a010000-0x0a01ffff pref]
> pci 0000:00:09.0: BAR 5: assigned [mem 0x0a020000-0x0a023fff]
> pci 0000:00:09.0: BAR 6: assigned [mem 0x0a024000-0x0a027fff pref]
> pci 0000:00:05.3: BAR 0: assigned [mem 0x0a028000-0x0a028fff]
> pci 0000:00:08.0: BAR 0: assigned [mem 0x0a029000-0x0a029fff]
> pci 0000:00:08.1: BAR 0: assigned [mem 0x0a02a000-0x0a02afff]
> pci 0000:00:08.2: BAR 0: assigned [mem 0x0a02b000-0x0a02b0ff]
> pci 0000:00:05.1: BAR 4: assigned [io  0x8000-0x800f]
> pci 0000:00:09.0: BAR 4: assigned [io  0x8010-0x801f]
> pci 0000:00:09.0: BAR 0: assigned [io  0x8020-0x8027]
> pci 0000:00:09.0: BAR 2: assigned [io  0x8028-0x802f]
> pci 0000:00:09.0: BAR 1: assigned [io  0x8030-0x8033]
> pci 0000:00:09.0: BAR 3: assigned [io  0x8034-0x8037]
> pci 0001:01:07.0: BAR 8: assigned [mem 0x209000000-0x2090fffff]
> pci 0001:01:07.0: BAR 9: assigned [mem 0x209100000-0x2091fffff pref]
> pci 0001:01:08.0: BAR 1: assigned [mem 0x209200000-0x209203fff]
> pci 0001:01:07.0: BAR 7: assigned [io  0x200008000-0x200008fff]
> pci 0001:01:08.0: BAR 0: assigned [mem 0x209204000-0x2092047ff]
> pci 0001:01:09.0: BAR 0: assigned [io  0x200009000-0x20000903f]
> pci 0001:02:02.0: BAR 6: assigned [mem 0x209100000-0x20913ffff pref]
> pci 0001:02:00.0: BAR 6: assigned [mem 0x209140000-0x20914ffff pref]
> pci 0001:02:01.0: BAR 6: assigned [mem 0x209150000-0x20915ffff pref]
> pci 0001:02:00.0: BAR 2: assigned [mem 0x209000000-0x209000fff]
> pci 0001:02:01.0: BAR 2: assigned [mem 0x209001000-0x209001fff]
> pci 0001:02:00.0: BAR 0: assigned [io  0x200008000-0x2000080ff]
> pci 0001:02:00.0: BAR 1: assigned [mem 0x209002000-0x2090020ff]
> pci 0001:02:01.0: BAR 0: assigned [io  0x200008400-0x2000084ff]
> pci 0001:02:01.0: BAR 1: assigned [mem 0x209003000-0x2090030ff]
> pci 0001:02:02.0: BAR 0: assigned [io  0x200008800-0x20000887f]
> pci 0001:02:02.0: BAR 1: assigned [mem 0x209004000-0x20900407f]
> pci 0001:01:07.0: PCI bridge to [bus 02]
> pci 0001:01:07.0:   bridge window [io  0x200008000-0x200008fff]
> pci 0001:01:07.0:   bridge window [mem 0x209000000-0x2090fffff]
> pci 0001:01:07.0:   bridge window [mem 0x209100000-0x2091fffff pref]
> SMC37c669 Super I/O Controller found @ 0x00000000000003f0
> bio: create slab <bio-0> at 0
> raid6: int64x1    492 MB/s
> raid6: int64x2    632 MB/s
> raid6: int64x4    584 MB/s
> raid6: int64x8    220 MB/s
> raid6: using algorithm int64x2 (632 MB/s)
> raid6: using intx1 recovery algorithm
> vgaarb: device added: PCI:0000:00:07.0,decodes=io+mem,owns=io+mem,locks=none
> vgaarb: loaded
> vgaarb: bridge control possible 0000:00:07.0
> SCSI subsystem initialized
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> Linux video capture interface: v2.00
> Advanced Linux Sound Architecture Driver Version 1.0.25.
> NET: Registered protocol family 2
> TCP established hash table entries: 262144 (order: 9, 4194304 bytes)
> TCP bind hash table entries: 65536 (order: 7, 1048576 bytes)
> TCP: Hash tables configured (established 262144 bind 65536)
> TCP: reno registered
> UDP hash table entries: 1024 (order: 2, 32768 bytes)
> UDP-Lite hash table entries: 1024 (order: 2, 32768 bytes)
> NET: Registered protocol family 1
> RPC: Registered named UNIX socket transport module.
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> RPC: Registered tcp NFSv4.1 backchannel transport module.
> srm_env: version 0.0.6 loaded successfully
> NFS: Registering the id_resolver key type
> Key type id_resolver registered
> Key type id_legacy registered
> Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> NTFS driver 2.1.30 [Flags: R/W].
> msgmni has been set to 4033
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> io scheduler noop registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> nvidiafb: Device ID: 10de0110
> nvidiafb: EDID found from BUS1
> i2c i2c-1: unable to read EDID block.
> i2c i2c-1: unable to read EDID block.
> i2c i2c-1: unable to read EDID block.
> nvidiafb: Unable to detect which CRTCNumber...
> ...Defaulting to CRTCNumber 0
> nvidiafb: Using CRT on CRTC 0
> Console: switching to colour frame buffer device 144x54
> nvidiafb: PCI nVidia NV11 framebuffer (32MB @ 0x10000000)
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> ppdev: user-space parallel port driver
> parport0: PC-style at 0x3bc, irq 7 [PCSPP]
> Floppy drive(s): fd0 is 2.88Mbrd: module loaded
> loop: module loaded
>
> Loading iSCSI transport class v2.0-870.
> iscsi: registered transport (tcp)
> FDC 0 is a post-1991 82077
> sym0: <875> rev 0x4 at pci 0001:02:00.0 irq 47
> sym0: Symbios NVRAM, ID 7, Fast-20, SE, parity checking
> sym0: open drain IRQ line driver, using on-chip SRAM
> sym0: using LOAD/STORE-based firmware.
> sym0: SCSI BUS has been reset.
> scsi0 : sym-2.2.3
> sym1: <875> rev 0x4 at pci 0001:02:01.0 irq 46
> sym1: Symbios NVRAM, ID 7, Fast-20, SE, parity checking
> sym1: open drain IRQ line driver, using on-chip SRAM
> sym1: using LOAD/STORE-based firmware.
> sym1: SCSI BUS has been reset.
> scsi1 : sym-2.2.3
> scsi 1:0:0:0: Direct-Access     DEC      RZ2EA-LA (C) DEC N1H1 PQ: 0 ANSI: 2
> scsi target1:0:0: tagged command queuing enabled, command queue depth 16.
> scsi target1:0:0: Beginning Domain Validation
> scsi target1:0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 16)
> scsi target1:0:0: Domain Validation skipping write tests
> scsi target1:0:0: Ending Domain Validation
> scsi 1:0:1:0: Direct-Access     DEC      RZ2EA-LA (C) DEC N1H1 PQ: 0 ANSI: 2
> scsi target1:0:1: tagged command queuing enabled, command queue depth 16.
> scsi target1:0:1: Beginning Domain Validation
> scsi target1:0:1: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 16)
> scsi target1:0:1: Domain Validation skipping write tests
> scsi target1:0:1: Ending Domain Validation
> scsi 1:0:2:0: Direct-Access     IBM      IC35L036UCDY10-0 S23C PQ: 0 ANSI: 3
> scsi target1:0:2: tagged command queuing enabled, command queue depth 16.
> scsi target1:0:2: Beginning Domain Validation
> scsi target1:0:2: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 16)
> scsi target1:0:2: Domain Validation skipping write tests
> scsi target1:0:2: Ending Domain Validation
> scsi 1:0:3:0: Direct-Access     FUJITSU  MAF3364LC        5210 PQ: 0 ANSI: 2
> scsi target1:0:3: tagged command queuing enabled, command queue depth 16.
> scsi target1:0:3: Beginning Domain Validation
> scsi target1:0:3: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 16)
> scsi target1:0:3: Domain Validation skipping write tests
> scsi target1:0:3: Ending Domain Validation
> scsi 1:0:4:0: Direct-Access     FUJITSU  MAF3364LC        5210 PQ: 0 ANSI: 2
> scsi target1:0:4: tagged command queuing enabled, command queue depth 16.
> scsi target1:0:4: Beginning Domain Validation
> scsi target1:0:4: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 16)
> scsi target1:0:4: Domain Validation skipping write tests
> scsi target1:0:4: Ending Domain Validation
> scsi 1:0:5:0: Direct-Access     IBM      IC35L036UCDY10-0 S23C PQ: 0 ANSI: 3
> scsi target1:0:5: tagged command queuing enabled, command queue depth 16.
> scsi target1:0:5: Beginning Domain Validation
> scsi target1:0:5: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 16)
> scsi target1:0:5: Domain Validation skipping write tests
> scsi target1:0:5: Ending Domain Validation
> st: Version 20101219, fixed bufsize 32768, s/g segs 256
> sd 1:0:0:0: Attached scsi generic sg0 type 0
> sd 1:0:0:0: [sda] 35565080 512-byte logical blocks: (18.2 GB/16.9 GiB)
> sd 1:0:0:0: [sda] Write Protect is off
> sd 1:0:1:0: [sdb] 35565080 512-byte logical blocks: (18.2 GB/16.9 GiB)
> sd 1:0:3:0: [sdd] 71161520 512-byte logical blocks: (36.4 GB/33.9 GiB)
> sd 1:0:2:0: [sdc] 71687340 512-byte logical blocks: (36.7 GB/34.1 GiB)
> sd 1:0:1:0: [sdb] Write Protect is off
> sd 1:0:4:0: [sde] 71161520 512-byte logical blocks: (36.4 GB/33.9 GiB)
> sd 1:0:5:0: [sdf] 71687340 512-byte logical blocks: (36.7 GB/34.1 GiB)
> sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
> sd 1:0:2:0: [sdc] Write Protect is off
> sd 1:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
> sd 1:0:3:0: [sdd] Write Protect is off
> sd 1:0:5:0: [sdf] Write Protect is off
> sd 1:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> sd 1:0:5:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> sd 1:0:3:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
> sd 1:0:4:0: [sde] Write Protect is off
> sd 1:0:4:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
> sd 1:0:1:0: Attached scsi generic sg1 type 0
>  sdb: sdb3
>  sdd: unknown partition table
>  sdc: unknown partition table
>  sde: unknown partition table
>  sda: sda1 sda2
> sd 1:0:2:0: Attached scsi generic sg2 type 0
> sd 1:0:2:0: [sdc] Attached SCSI disk
> sd 1:0:3:0: [sdd] Attached SCSI disk
> sd 1:0:4:0: [sde] Attached SCSI disk
> sd 1:0:3:0: Attached scsi generic sg3 type 0
> sd 1:0:1:0: [sdb] Attached SCSI disk
>  sdf: unknown partition table
> sd 1:0:5:0: [sdf] Attached SCSI disk
> sd 1:0:4:0: Attached scsi generic sg4 type 0
> sd 1:0:5:0: Attached scsi generic sg5 type 0
> SCSI Media Changer driver v0.25
> PCI: Setting latency timer of device 0000:00:05.1 to 64
> sd 1:0:0:0: [sda] Attached SCSI disk
> scsi2 : pata_cypress
> scsi3 : pata_cypress
> ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0x8000 irq 14
> ata2: DUMMY
> pata_pdc2027x 0000:00:09.0: PLL input clock 16715 kHz
> scsi4 : pata_pdc2027x
> scsi5 : pata_pdc2027x
> ata3: PATA max UDMA/133 mmio m16384@0xa020000 cmd 0xa0217c0 irq 23
> ata4: PATA max UDMA/133 mmio m16384@0xa020000 cmd 0xa0215c0 irq 23
> Linux Tulip driver version 1.1.15 (Feb 27, 2007)
> tulip0: EEPROM default media type Autosense
> tulip0: Index #0 - Media MII (#11) described by a 21140 MII PHY (1) block
> tulip0:  MII transceiver #5 config 0000 status 784b advertising 01e1
> net eth0: Digital DS21140 Tulip rev 34 at MMIO 0x209004000, 00:06:2b:00:ad:d4, IRQ 45
> PPP generic driver version 2.4.2
> NET: Registered protocol family 24
> ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> ehci_hcd 0000:00:08.2: EHCI Host Controller
> ehci_hcd 0000:00:08.2: new USB bus registered, assigned bus number 1
> ehci_hcd 0000:00:08.2: irq 25, io mem 0x0a02b000
> ehci_hcd 0000:00:08.2: USB 2.0 started, EHCI 1.00
> usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb1: Product: EHCI Host Controller
> usb usb1: Manufacturer: Linux 3.6.0-rc4-00055-gac3d0da-dirty ehci_hcd
> usb usb1: SerialNumber: 0000:00:08.2
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 5 ports detected
> ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> ohci_hcd 0000:00:05.3: OHCI Host Controller
> ohci_hcd 0000:00:05.3: new USB bus registered, assigned bus number 2
> ohci_hcd 0000:00:05.3: irq 10, io mem 0x0a028000
> usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb2: Product: OHCI Host Controller
> usb usb2: Manufacturer: Linux 3.6.0-rc4-00055-gac3d0da-dirty ohci_hcd
> usb usb2: SerialNumber: 0000:00:05.3
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 2 ports detected
> ohci_hcd 0000:00:08.0: OHCI Host Controller
> ohci_hcd 0000:00:08.0: new USB bus registered, assigned bus number 3
> ohci_hcd 0000:00:08.0: irq 27, io mem 0x0a029000
> ata3.00: ATAPI: PLEXTOR DVDR   PX-716A, 1.04, max UDMA/66
> ata3.00: configured for UDMA/66
> usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb3: Product: OHCI Host Controller
> usb usb3: Manufacturer: Linux 3.6.0-rc4-00055-gac3d0da-dirty ohci_hcd
> usb usb3: SerialNumber: 0000:00:08.0
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 3 ports detected
> ohci_hcd 0000:00:08.1: OHCI Host Controller
> ohci_hcd 0000:00:08.1: new USB bus registered, assigned bus number 4
> ohci_hcd 0000:00:08.1: irq 26, io mem 0x0a02a000
> usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb4: Product: OHCI Host Controller
> usb usb4: Manufacturer: Linux 3.6.0-rc4-00055-gac3d0da-dirty ohci_hcd
> usb usb4: SerialNumber: 0000:00:08.1
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 2 ports detected
> usbcore: registered new interface driver uas
> Initializing USB Mass Storage driver...
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> usbcore: registered new interface driver usbserial
> usbcore: registered new interface driver usbserial_generic
> USB Serial support registered for generic
> usbserial: USB Serial Driver core
> usbcore: registered new interface driver ipaq
> USB Serial support registered for PocketPC PDA
> usbcore: registered new interface driver pl2303
> USB Serial support registered for pl2303
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mousedev: PS/2 mouse device common for all mice
> input: PC Speaker as /devices/platform/pcspkr/input/input0
> gspca_main: v2.14.0 registered
> usbcore: registered new interface driver vicam
> md: linear personality registered for level -1
> md: raid0 personality registered for level 0
> md: raid1 personality registered for level 1
> md: raid10 personality registered for level 10
> md: raid6 personality registered for level 6
> md: raid5 personality registered for level 5
> md: raid4 personality registered for level 4
> device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
> scsi 4:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-716A   1.04 PQ: 0 ANSI: 5
> hub 2-0:1.0: over-current condition
> input: AT Raw Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
> cdrom: Uniform CD-ROM driver Revision: 3.20
> sr 4:0:0:0: Attached scsi generic sg6 type 5
> IPv4 over IPv4 tunneling driver
> ip_tables: (C) 2000-2006 Netfilter Core Team
> TCP: cubic registered
> Initializing XFRM netlink socket
> NET: Registered protocol family 17
> NET: Registered protocol family 15
> 8021q: 802.1Q VLAN Support v1.8
> Key type dns_resolver registered
> console [netcon0] enabled
> netconsole: network logging started
> /usr/src/linux.git/drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
> ALSA device list:
>   #0: Ensoniq AudioPCI ENS1370 at 0x200009000, irq 39
> input: PS/2 Logitech Mouse as /devices/platform/i8042/serio1/input/input2
> md: Waiting for all devices to be available before autodetect
> md: If you don't use raid, use raid=noautodetect
> md: Autodetecting RAID arrays.
> md: Scanned 0 and added 0 devices.
> md: autorun ...
> md: ... autorun DONE.
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs (sda1): warning: maximal mount count reached, running e2fsck is recommended
> EXT3-fs (sda1): using internal journal
> EXT3-fs (sda1): recovery complete
> EXT3-fs (sda1): mounted filesystem with writeback data mode
> VFS: Mounted root (ext3 filesystem) on device 8:1.
> Freeing unused kernel memory: 296k freed
> ------------[ cut here ]------------
> WARNING: at /usr/src/linux.git/kernel/softirq.c:159 _local_bh_enable_ip.isra.9+0x4c/0xdc()
> Modules linked in:
> fffffc007f05bca8 fffffc0000b8e438 fffffc000032d3c4 fffffc0000bc00f8
>        fffffc007e0c5ce0 0000000000000000 fffffc007e813a58 fffffc007e33c3d0
>        fffffc0000913e30 fffffc007e0c5b80 fffffc00008c0460 fffffc007e0c5b80
>        fffffc00008059a4 fffffc007e808580 0000000000000008 fffffc007e8085b0
>        fffffc007e813a58 fffffc007f05be88 0000000000000000 fffffc007e33c3c0
>        fffffc0000805ca0 fffffc007e33c3c0 fffffc00003ba4c4 fffffc007e33c3d0
> Trace:
> [<fffffc000032d3c4>] _local_bh_enable_ip.isra.9+0x4c/0xdc
> [<fffffc0000913e30>] _raw_write_unlock_bh+0x24/0x38
> [<fffffc00008c0460>] unix_release_sock+0xb0/0x288
> [<fffffc00008059a4>] sock_release+0x28/0xd8
> [<fffffc0000805ca0>] sock_close+0x3c/0x54
> [<fffffc00003ba4c4>] __fput+0x140/0x278
> [<fffffc0000342d9c>] task_work_run+0x6c/0xb4
> [<fffffc0000316e1c>] do_notify_resume+0x68/0x88
> [<fffffc0000310e6c>] work_pending+0x6c/0x80
> [<fffffc0000310d04>] entSys+0xa4/0xc0
>
> ---[ end trace 01aeb58cf09b7689 ]---
> Kernel bug at /usr/src/linux.git/fs/buffer.c:1218
> CPU 0 vgscan(687): Kernel Bug 1
> pc = [<fffffc00003eb558>]  ra = [<fffffc00003ec5d4>]  ps = 0007    Tainted: G        W
> pc is at check_irqs_on+0x14/0x24
> ra is at __find_get_block+0x3c/0x3a0
> v0 = 0000000000000001  t0 = fffffc007e44ec00  t1 = fffffc007e453540
> t2 = fffffc007e453540  t3 = 0000000000000001  t4 = b038000000000000
> t5 = 00000000000f0000  t6 = 000000000000003f  t7 = fffffc007e268000
> a0 = fffffc007e804080  a1 = 000000000000000b  a2 = 0000000000000400
> a3 = 0000000000000000  a4 = 0000000000000000  a5 = 0000000000000000
> t8 = 0000000000000040  t9 = fffffc000043114c  t10= 0000000000000031
> t11= 00000000000007c0  pv = fffffc00003eb544  at = 0000000000000000
> gp = fffffc0000bf00f8  sp = fffffc007e26bae8
> Disabling lock debugging due to kernel taint
> Trace:
> [<fffffc00003ef428>] __getblk+0x40/0x338
> [<fffffc00003625ec>] do_timer+0x500/0x568
> [<fffffc00003622b8>] do_timer+0x1cc/0x568
> [<fffffc0000362624>] do_timer+0x538/0x568
> [<fffffc0000362710>] xtime_update+0x44/0x6c
> [<fffffc0000431194>] __ext3_get_inode_loc+0xe8/0x468
> [<fffffc000043293c>] ext3_reserve_inode_write+0x40/0xd8
> [<fffffc000043ad84>] ext3_orphan_del+0x9c/0x204
> [<fffffc0000435c38>] ext3_evict_inode+0x1bc/0x2a0
> [<fffffc0000430300>] start_transaction+0x3c/0x90
> [<fffffc0000435ba8>] ext3_evict_inode+0x12c/0x2a0
> [<fffffc00003d5fa8>] evict+0xf4/0x228
> [<fffffc00003d1be4>] dentry_kill+0x174/0x1c0
> [<fffffc00003d2318>] dput+0x148/0x170
> [<fffffc00003ba5a8>] __fput+0x224/0x278
> [<fffffc0000342d9c>] task_work_run+0x6c/0xb4
> [<fffffc0000316e1c>] do_notify_resume+0x68/0x88
> [<fffffc0000310e6c>] work_pending+0x6c/0x80
> [<fffffc0000310d04>] entSys+0xa4/0xc0
>
> Code: 6bfa8001  00000036  4400f000  4000f5a0  e4000004  00000081 <000004c2> 009f54ae
>
>
>
>
>
> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/alpha 3.6.0-rc7 Kernel Configuration
> #
> CONFIG_ALPHA=y
> CONFIG_64BIT=y
> CONFIG_MMU=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> # CONFIG_ARCH_HAS_ILOG2_U32 is not set
> # CONFIG_ARCH_HAS_ILOG2_U64 is not set
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_ZONE_DMA=y
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> CONFIG_NEED_DMA_MAP_STATE=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_HAVE_IRQ_WORK=y
>
> #
> # General setup
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_DEFAULT_HOSTNAME="(none)"
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> # CONFIG_POSIX_MQUEUE is not set
> CONFIG_BSD_PROCESS_ACCT=y
> CONFIG_BSD_PROCESS_ACCT_V3=y
> # CONFIG_FHANDLE is not set
> # CONFIG_TASKSTATS is not set
> # CONFIG_AUDIT is not set
> CONFIG_HAVE_GENERIC_HARDIRQS=y
>
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_AUTO_IRQ_AFFINITY=y
> CONFIG_GENERIC_CMOS_UPDATE=y
>
> #
> # RCU Subsystem
> #
> CONFIG_TREE_RCU=y
> # CONFIG_PREEMPT_RCU is not set
> CONFIG_RCU_FANOUT=64
> CONFIG_RCU_FANOUT_LEAF=16
> # CONFIG_RCU_FANOUT_EXACT is not set
> # CONFIG_TREE_RCU_TRACE is not set
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_LOG_BUF_SHIFT=16
> # CONFIG_CGROUPS is not set
> # CONFIG_CHECKPOINT_RESTORE is not set
> CONFIG_NAMESPACES=y
> # CONFIG_UTS_NS is not set
> # CONFIG_IPC_NS is not set
> # CONFIG_PID_NS is not set
> # CONFIG_NET_NS is not set
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_SYSFS_DEPRECATED is not set
> # CONFIG_RELAY is not set
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> CONFIG_RD_BZIP2=y
> CONFIG_RD_LZMA=y
> CONFIG_RD_XZ=y
> CONFIG_RD_LZO=y
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> # CONFIG_EXPERT is not set
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=y
> # CONFIG_KALLSYMS_ALL is not set
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=y
>
> #
> # Kernel Performance Events And Counters
> #
> # CONFIG_PERF_EVENTS is not set
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_PCI_QUIRKS=y
> CONFIG_COMPAT_BRK=y
> CONFIG_SLAB=y
> # CONFIG_SLUB is not set
> # CONFIG_PROFILING is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_HAVE_SYSCALL_WRAPPERS=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_USE_GENERIC_SMP_HELPERS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
>
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> # CONFIG_MODULE_FORCE_LOAD is not set
> # CONFIG_MODULE_UNLOAD is not set
> # CONFIG_MODVERSIONS is not set
> # CONFIG_MODULE_SRCVERSION_ALL is not set
> CONFIG_BLOCK=y
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLK_DEV_BSGLIB=y
> # CONFIG_BLK_DEV_INTEGRITY is not set
>
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> # CONFIG_ACORN_PARTITION is not set
> CONFIG_OSF_PARTITION=y
> # CONFIG_AMIGA_PARTITION is not set
> # CONFIG_ATARI_PARTITION is not set
> # CONFIG_MAC_PARTITION is not set
> CONFIG_MSDOS_PARTITION=y
> CONFIG_BSD_DISKLABEL=y
> # CONFIG_MINIX_SUBPARTITION is not set
> # CONFIG_SOLARIS_X86_PARTITION is not set
> # CONFIG_UNIXWARE_DISKLABEL is not set
> # CONFIG_LDM_PARTITION is not set
> # CONFIG_SGI_PARTITION is not set
> # CONFIG_ULTRIX_PARTITION is not set
> # CONFIG_SUN_PARTITION is not set
> # CONFIG_KARMA_PARTITION is not set
> # CONFIG_EFI_PARTITION is not set
> # CONFIG_SYSV68_PARTITION is not set
>
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> # CONFIG_DEFAULT_DEADLINE is not set
> CONFIG_DEFAULT_CFQ=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
> # CONFIG_INLINE_SPIN_TRYLOCK is not set
> # CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK is not set
> # CONFIG_INLINE_SPIN_LOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQ is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
> # CONFIG_INLINE_SPIN_UNLOCK_BH is not set
> CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
> # CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_READ_TRYLOCK is not set
> # CONFIG_INLINE_READ_LOCK is not set
> # CONFIG_INLINE_READ_LOCK_BH is not set
> # CONFIG_INLINE_READ_LOCK_IRQ is not set
> # CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
> CONFIG_INLINE_READ_UNLOCK=y
> # CONFIG_INLINE_READ_UNLOCK_BH is not set
> CONFIG_INLINE_READ_UNLOCK_IRQ=y
> # CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_WRITE_TRYLOCK is not set
> # CONFIG_INLINE_WRITE_LOCK is not set
> # CONFIG_INLINE_WRITE_LOCK_BH is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQ is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
> CONFIG_INLINE_WRITE_UNLOCK=y
> # CONFIG_INLINE_WRITE_UNLOCK_BH is not set
> CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
> # CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
> CONFIG_MUTEX_SPIN_ON_OWNER=y
> # CONFIG_FREEZER is not set
>
> #
> # System setup
> #
> # CONFIG_ALPHA_GENERIC is not set
> # CONFIG_ALPHA_ALCOR is not set
> # CONFIG_ALPHA_XL is not set
> # CONFIG_ALPHA_BOOK1 is not set
> # CONFIG_ALPHA_AVANTI_CH is not set
> # CONFIG_ALPHA_CABRIOLET is not set
> CONFIG_ALPHA_DP264=y
> # CONFIG_ALPHA_EB164 is not set
> # CONFIG_ALPHA_EB64P_CH is not set
> # CONFIG_ALPHA_EB66 is not set
> # CONFIG_ALPHA_EB66P is not set
> # CONFIG_ALPHA_EIGER is not set
> # CONFIG_ALPHA_JENSEN is not set
> # CONFIG_ALPHA_LX164 is not set
> # CONFIG_ALPHA_LYNX is not set
> # CONFIG_ALPHA_MARVEL is not set
> # CONFIG_ALPHA_MIATA is not set
> # CONFIG_ALPHA_MIKASA is not set
> # CONFIG_ALPHA_NAUTILUS is not set
> # CONFIG_ALPHA_NONAME_CH is not set
> # CONFIG_ALPHA_NORITAKE is not set
> # CONFIG_ALPHA_PC164 is not set
> # CONFIG_ALPHA_P2K is not set
> # CONFIG_ALPHA_RAWHIDE is not set
> # CONFIG_ALPHA_RUFFIAN is not set
> # CONFIG_ALPHA_RX164 is not set
> # CONFIG_ALPHA_SX164 is not set
> # CONFIG_ALPHA_SABLE is not set
> # CONFIG_ALPHA_SHARK is not set
> # CONFIG_ALPHA_TAKARA is not set
> # CONFIG_ALPHA_TITAN is not set
> # CONFIG_ALPHA_WILDFIRE is not set
> CONFIG_ISA=y
> CONFIG_ISA_DMA_API=y
> CONFIG_PCI=y
> CONFIG_PCI_DOMAINS=y
> CONFIG_PCI_SYSCALL=y
> CONFIG_IOMMU_HELPER=y
> CONFIG_ALPHA_EV6=y
> CONFIG_ALPHA_TSUNAMI=y
> # CONFIG_ALPHA_EV67 is not set
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_VGA_HOSE=y
> CONFIG_ALPHA_SRM=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_SMP=y
> CONFIG_HAVE_DEC_LOCK=y
> CONFIG_NR_CPUS=4
> # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> # CONFIG_COMPACTION is not set
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_CROSS_MEMORY_ATTACH=y
> # CONFIG_CLEANCACHE is not set
> # CONFIG_FRONTSWAP is not set
> CONFIG_VERBOSE_MCHECK=y
> CONFIG_VERBOSE_MCHECK_ON=1
> CONFIG_HZ=1024
> # CONFIG_ARCH_SUPPORTS_MSI is not set
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> # CONFIG_PCI_STUB is not set
> # CONFIG_PCI_IOV is not set
> # CONFIG_PCI_PRI is not set
> # CONFIG_PCI_PASID is not set
> # CONFIG_PCCARD is not set
> CONFIG_SRM_ENV=y
> CONFIG_BINFMT_ELF=y
> # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
> CONFIG_HAVE_AOUT=y
> CONFIG_BINFMT_AOUT=y
> CONFIG_OSF4_COMPAT=y
> CONFIG_BINFMT_EM86=y
> CONFIG_BINFMT_MISC=y
> CONFIG_NET=y
>
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_UNIX=y
> # CONFIG_UNIX_DIAG is not set
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=y
> CONFIG_XFRM_USER=y
> # CONFIG_XFRM_SUB_POLICY is not set
> # CONFIG_XFRM_MIGRATE is not set
> # CONFIG_XFRM_STATISTICS is not set
> CONFIG_XFRM_IPCOMP=y
> CONFIG_NET_KEY=y
> # CONFIG_NET_KEY_MIGRATE is not set
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> # CONFIG_IP_ADVANCED_ROUTER is not set
> CONFIG_IP_PNP=y
> # CONFIG_IP_PNP_DHCP is not set
> # CONFIG_IP_PNP_BOOTP is not set
> # CONFIG_IP_PNP_RARP is not set
> CONFIG_NET_IPIP=y
> # CONFIG_NET_IPGRE_DEMUX is not set
> # CONFIG_IP_MROUTE is not set
> # CONFIG_ARPD is not set
> # CONFIG_SYN_COOKIES is not set
> # CONFIG_NET_IPVTI is not set
> CONFIG_INET_AH=y
> CONFIG_INET_ESP=y
> CONFIG_INET_IPCOMP=y
> CONFIG_INET_XFRM_TUNNEL=y
> CONFIG_INET_TUNNEL=y
> CONFIG_INET_XFRM_MODE_TRANSPORT=y
> CONFIG_INET_XFRM_MODE_TUNNEL=y
> CONFIG_INET_XFRM_MODE_BEET=y
> # CONFIG_INET_LRO is not set
> CONFIG_INET_DIAG=y
> CONFIG_INET_TCP_DIAG=y
> # CONFIG_INET_UDP_DIAG is not set
> # CONFIG_TCP_CONG_ADVANCED is not set
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_DEFAULT_TCP_CONG="cubic"
> # CONFIG_TCP_MD5SIG is not set
> # CONFIG_IPV6 is not set
> # CONFIG_NETWORK_SECMARK is not set
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> CONFIG_NETFILTER_ADVANCED=y
>
> #
> # Core Netfilter Configuration
> #
> # CONFIG_NETFILTER_NETLINK_ACCT is not set
> # CONFIG_NETFILTER_NETLINK_QUEUE is not set
> # CONFIG_NETFILTER_NETLINK_LOG is not set
> CONFIG_NF_CONNTRACK=y
> # CONFIG_NF_CONNTRACK_MARK is not set
> CONFIG_NF_CONNTRACK_PROCFS=y
> # CONFIG_NF_CONNTRACK_EVENTS is not set
> # CONFIG_NF_CONNTRACK_TIMEOUT is not set
> # CONFIG_NF_CONNTRACK_TIMESTAMP is not set
> # CONFIG_NF_CT_PROTO_DCCP is not set
> # CONFIG_NF_CT_PROTO_SCTP is not set
> # CONFIG_NF_CT_PROTO_UDPLITE is not set
> # CONFIG_NF_CONNTRACK_AMANDA is not set
> CONFIG_NF_CONNTRACK_FTP=y
> # CONFIG_NF_CONNTRACK_H323 is not set
> # CONFIG_NF_CONNTRACK_IRC is not set
> # CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
> # CONFIG_NF_CONNTRACK_SNMP is not set
> # CONFIG_NF_CONNTRACK_PPTP is not set
> # CONFIG_NF_CONNTRACK_SANE is not set
> # CONFIG_NF_CONNTRACK_SIP is not set
> # CONFIG_NF_CONNTRACK_TFTP is not set
> # CONFIG_NF_CT_NETLINK is not set
> # CONFIG_NF_CT_NETLINK_TIMEOUT is not set
> CONFIG_NETFILTER_XTABLES=y
>
> #
> # Xtables combined modules
> #
> # CONFIG_NETFILTER_XT_MARK is not set
> # CONFIG_NETFILTER_XT_CONNMARK is not set
>
> #
> # Xtables targets
> #
> # CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
> # CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
> # CONFIG_NETFILTER_XT_TARGET_HMARK is not set
> # CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
> # CONFIG_NETFILTER_XT_TARGET_LOG is not set
> # CONFIG_NETFILTER_XT_TARGET_MARK is not set
> # CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
> # CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
> # CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
> # CONFIG_NETFILTER_XT_TARGET_TEE is not set
> # CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
>
> #
> # Xtables matches
> #
> # CONFIG_NETFILTER_XT_MATCH_ADDRTYPE is not set
> # CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
> # CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
> # CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
> # CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
> # CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
> # CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
> # CONFIG_NETFILTER_XT_MATCH_CPU is not set
> # CONFIG_NETFILTER_XT_MATCH_DCCP is not set
> # CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
> # CONFIG_NETFILTER_XT_MATCH_DSCP is not set
> # CONFIG_NETFILTER_XT_MATCH_ECN is not set
> # CONFIG_NETFILTER_XT_MATCH_ESP is not set
> # CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
> # CONFIG_NETFILTER_XT_MATCH_HELPER is not set
> # CONFIG_NETFILTER_XT_MATCH_HL is not set
> # CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
> # CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
> # CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
> # CONFIG_NETFILTER_XT_MATCH_MAC is not set
> # CONFIG_NETFILTER_XT_MATCH_MARK is not set
> # CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
> # CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
> # CONFIG_NETFILTER_XT_MATCH_OWNER is not set
> # CONFIG_NETFILTER_XT_MATCH_POLICY is not set
> # CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
> # CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
> # CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
> # CONFIG_NETFILTER_XT_MATCH_REALM is not set
> # CONFIG_NETFILTER_XT_MATCH_RECENT is not set
> # CONFIG_NETFILTER_XT_MATCH_SCTP is not set
> # CONFIG_NETFILTER_XT_MATCH_STATE is not set
> # CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
> # CONFIG_NETFILTER_XT_MATCH_STRING is not set
> # CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
> # CONFIG_NETFILTER_XT_MATCH_TIME is not set
> # CONFIG_NETFILTER_XT_MATCH_U32 is not set
> # CONFIG_IP_VS is not set
>
> #
> # IP: Netfilter Configuration
> #
> CONFIG_NF_DEFRAG_IPV4=y
> CONFIG_NF_CONNTRACK_IPV4=y
> CONFIG_NF_CONNTRACK_PROC_COMPAT=y
> # CONFIG_IP_NF_QUEUE is not set
> CONFIG_IP_NF_IPTABLES=y
> # CONFIG_IP_NF_MATCH_AH is not set
> # CONFIG_IP_NF_MATCH_ECN is not set
> # CONFIG_IP_NF_MATCH_RPFILTER is not set
> # CONFIG_IP_NF_MATCH_TTL is not set
> # CONFIG_IP_NF_FILTER is not set
> # CONFIG_IP_NF_TARGET_ULOG is not set
> # CONFIG_NF_NAT is not set
> # CONFIG_IP_NF_MANGLE is not set
> # CONFIG_IP_NF_RAW is not set
> # CONFIG_IP_NF_ARPTABLES is not set
> # CONFIG_IP_DCCP is not set
> # CONFIG_IP_SCTP is not set
> # CONFIG_RDS is not set
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> # CONFIG_L2TP is not set
> # CONFIG_BRIDGE is not set
> # CONFIG_NET_DSA is not set
> CONFIG_VLAN_8021Q=y
> # CONFIG_VLAN_8021Q_GVRP is not set
> # CONFIG_DECNET is not set
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_WAN_ROUTER is not set
> # CONFIG_PHONET is not set
> # CONFIG_IEEE802154 is not set
> # CONFIG_NET_SCHED is not set
> # CONFIG_DCB is not set
> CONFIG_DNS_RESOLVER=y
> # CONFIG_BATMAN_ADV is not set
> # CONFIG_OPENVSWITCH is not set
> CONFIG_RPS=y
> CONFIG_RFS_ACCEL=y
> CONFIG_XPS=y
> CONFIG_BQL=y
>
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> # CONFIG_AF_RXRPC is not set
> CONFIG_WIRELESS=y
> # CONFIG_CFG80211 is not set
> # CONFIG_LIB80211 is not set
>
> #
> # CFG80211 needs to be enabled for MAC80211
> #
> # CONFIG_WIMAX is not set
> # CONFIG_RFKILL is not set
> # CONFIG_NET_9P is not set
> # CONFIG_CAIF is not set
> # CONFIG_CEPH_LIB is not set
> # CONFIG_NFC is not set
>
> #
> # Device Drivers
> #
>
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> # CONFIG_DEVTMPFS is not set
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> # CONFIG_DMA_SHARED_BUFFER is not set
> # CONFIG_CONNECTOR is not set
> # CONFIG_MTD is not set
> CONFIG_PARPORT=y
> CONFIG_PARPORT_PC=y
> # CONFIG_PARPORT_SERIAL is not set
> CONFIG_PARPORT_PC_FIFO=y
> # CONFIG_PARPORT_PC_SUPERIO is not set
> # CONFIG_PARPORT_GSC is not set
> # CONFIG_PARPORT_AX88796 is not set
> CONFIG_PARPORT_1284=y
> CONFIG_PNP=y
> CONFIG_PNP_DEBUG_MESSAGES=y
>
> #
> # Protocols
> #
> # CONFIG_ISAPNP is not set
> # CONFIG_PNPACPI is not set
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_FD=y
> # CONFIG_BLK_DEV_XD is not set
> # CONFIG_PARIDE is not set
> # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
> CONFIG_BLK_DEV_CRYPTOLOOP=y
>
> #
> # DRBD disabled because PROC_FS, INET or CONNECTOR not selected
> #
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_NVME is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_UB is not set
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=4096
> # CONFIG_BLK_DEV_XIP is not set
> CONFIG_CDROM_PKTCDVD=y
> CONFIG_CDROM_PKTCDVD_BUFFERS=8
> # CONFIG_CDROM_PKTCDVD_WCACHE is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_BLK_DEV_HD is not set
> # CONFIG_BLK_DEV_RBD is not set
>
> #
> # Misc devices
> #
> # CONFIG_SENSORS_LIS3LV02D is not set
> # CONFIG_AD525X_DPOT is not set
> # CONFIG_PHANTOM is not set
> # CONFIG_INTEL_MID_PTI is not set
> # CONFIG_SGI_IOC4 is not set
> # CONFIG_TIFM_CORE is not set
> # CONFIG_ICS932S401 is not set
> CONFIG_ENCLOSURE_SERVICES=y
> # CONFIG_HP_ILO is not set
> # CONFIG_APDS9802ALS is not set
> # CONFIG_ISL29003 is not set
> # CONFIG_ISL29020 is not set
> # CONFIG_SENSORS_TSL2550 is not set
> # CONFIG_SENSORS_BH1780 is not set
> # CONFIG_SENSORS_BH1770 is not set
> # CONFIG_SENSORS_APDS990X is not set
> # CONFIG_HMC6352 is not set
> # CONFIG_DS1682 is not set
> # CONFIG_BMP085_I2C is not set
> # CONFIG_PCH_PHUB is not set
> # CONFIG_USB_SWITCH_FSA9480 is not set
> # CONFIG_C2PORT is not set
>
> #
> # EEPROM support
> #
> # CONFIG_EEPROM_AT24 is not set
> # CONFIG_EEPROM_LEGACY is not set
> # CONFIG_EEPROM_MAX6875 is not set
> # CONFIG_EEPROM_93CX6 is not set
> # CONFIG_CB710_CORE is not set
>
> #
> # Texas Instruments shared transport line discipline
> #
> # CONFIG_SENSORS_LIS3_I2C is not set
>
> #
> # Altera FPGA firmware download module
> #
> # CONFIG_ALTERA_STAPL is not set
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
>
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_TGT=y
> # CONFIG_SCSI_NETLINK is not set
> CONFIG_SCSI_PROC_FS=y
>
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> CONFIG_CHR_DEV_ST=y
> # CONFIG_CHR_DEV_OSST is not set
> CONFIG_BLK_DEV_SR=y
> CONFIG_BLK_DEV_SR_VENDOR=y
> CONFIG_CHR_DEV_SG=y
> CONFIG_CHR_DEV_SCH=y
> CONFIG_SCSI_ENCLOSURE=y
> CONFIG_SCSI_MULTI_LUN=y
> CONFIG_SCSI_CONSTANTS=y
> CONFIG_SCSI_LOGGING=y
> # CONFIG_SCSI_SCAN_ASYNC is not set
>
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=y
> # CONFIG_SCSI_FC_ATTRS is not set
> CONFIG_SCSI_ISCSI_ATTRS=y
> # CONFIG_SCSI_SAS_ATTRS is not set
> # CONFIG_SCSI_SAS_LIBSAS is not set
> # CONFIG_SCSI_SRP_ATTRS is not set
> CONFIG_SCSI_LOWLEVEL=y
> CONFIG_ISCSI_TCP=y
> # CONFIG_ISCSI_BOOT_SYSFS is not set
> # CONFIG_SCSI_CXGB3_ISCSI is not set
> # CONFIG_SCSI_CXGB4_ISCSI is not set
> # CONFIG_SCSI_BNX2_ISCSI is not set
> # CONFIG_SCSI_BNX2X_FCOE is not set
> # CONFIG_BE2ISCSI is not set
> # CONFIG_BLK_DEV_3W_XXXX_RAID is not set
> # CONFIG_SCSI_HPSA is not set
> # CONFIG_SCSI_3W_9XXX is not set
> # CONFIG_SCSI_3W_SAS is not set
> # CONFIG_SCSI_7000FASST is not set
> # CONFIG_SCSI_ACARD is not set
> # CONFIG_SCSI_AHA152X is not set
> # CONFIG_SCSI_AHA1542 is not set
> # CONFIG_SCSI_AACRAID is not set
> CONFIG_SCSI_AIC7XXX=y
> CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
> CONFIG_AIC7XXX_RESET_DELAY_MS=15000
> # CONFIG_AIC7XXX_DEBUG_ENABLE is not set
> CONFIG_AIC7XXX_DEBUG_MASK=0
> # CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
> # CONFIG_SCSI_AIC7XXX_OLD is not set
> # CONFIG_SCSI_AIC79XX is not set
> # CONFIG_SCSI_AIC94XX is not set
> # CONFIG_SCSI_MVSAS is not set
> # CONFIG_SCSI_MVUMI is not set
> # CONFIG_SCSI_DPT_I2O is not set
> # CONFIG_SCSI_ADVANSYS is not set
> # CONFIG_SCSI_IN2000 is not set
> # CONFIG_SCSI_ARCMSR is not set
> # CONFIG_MEGARAID_NEWGEN is not set
> # CONFIG_MEGARAID_LEGACY is not set
> # CONFIG_MEGARAID_SAS is not set
> # CONFIG_SCSI_MPT2SAS is not set
> # CONFIG_SCSI_UFSHCD is not set
> # CONFIG_SCSI_HPTIOP is not set
> # CONFIG_SCSI_BUSLOGIC is not set
> # CONFIG_LIBFC is not set
> # CONFIG_LIBFCOE is not set
> # CONFIG_FCOE is not set
> # CONFIG_SCSI_DMX3191D is not set
> # CONFIG_SCSI_DTC3280 is not set
> # CONFIG_SCSI_EATA is not set
> # CONFIG_SCSI_FUTURE_DOMAIN is not set
> # CONFIG_SCSI_GDTH is not set
> # CONFIG_SCSI_GENERIC_NCR5380 is not set
> # CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
> # CONFIG_SCSI_IPS is not set
> # CONFIG_SCSI_INITIO is not set
> # CONFIG_SCSI_INIA100 is not set
> # CONFIG_SCSI_PPA is not set
> # CONFIG_SCSI_IMM is not set
> # CONFIG_SCSI_NCR53C406A is not set
> # CONFIG_SCSI_STEX is not set
> CONFIG_SCSI_SYM53C8XX_2=y
> CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
> CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
> CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
> CONFIG_SCSI_SYM53C8XX_MMIO=y
> # CONFIG_SCSI_IPR is not set
> # CONFIG_SCSI_PAS16 is not set
> # CONFIG_SCSI_QLOGIC_FAS is not set
> CONFIG_SCSI_QLOGIC_1280=y
> # CONFIG_SCSI_QLA_FC is not set
> # CONFIG_SCSI_QLA_ISCSI is not set
> # CONFIG_SCSI_LPFC is not set
> # CONFIG_SCSI_SYM53C416 is not set
> # CONFIG_SCSI_DC395x is not set
> # CONFIG_SCSI_DC390T is not set
> # CONFIG_SCSI_T128 is not set
> # CONFIG_SCSI_U14_34F is not set
> # CONFIG_SCSI_DEBUG is not set
> # CONFIG_SCSI_PMCRAID is not set
> # CONFIG_SCSI_PM8001 is not set
> # CONFIG_SCSI_SRP is not set
> # CONFIG_SCSI_BFA_FC is not set
> # CONFIG_SCSI_DH is not set
> # CONFIG_SCSI_OSD_INITIATOR is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_VERBOSE_ERROR=y
> CONFIG_SATA_PMP=y
>
> #
> # Controllers with non-SFF native interface
> #
> # CONFIG_SATA_AHCI is not set
> # CONFIG_SATA_AHCI_PLATFORM is not set
> # CONFIG_SATA_INIC162X is not set
> # CONFIG_SATA_ACARD_AHCI is not set
> # CONFIG_SATA_SIL24 is not set
> CONFIG_ATA_SFF=y
>
> #
> # SFF controllers with custom DMA interface
> #
> # CONFIG_PDC_ADMA is not set
> # CONFIG_SATA_QSTOR is not set
> # CONFIG_SATA_SX4 is not set
> CONFIG_ATA_BMDMA=y
>
> #
> # SATA SFF controllers with BMDMA
> #
> # CONFIG_ATA_PIIX is not set
> # CONFIG_SATA_MV is not set
> # CONFIG_SATA_NV is not set
> CONFIG_SATA_PROMISE=y
> # CONFIG_SATA_SIL is not set
> # CONFIG_SATA_SIS is not set
> # CONFIG_SATA_SVW is not set
> # CONFIG_SATA_ULI is not set
> # CONFIG_SATA_VIA is not set
> # CONFIG_SATA_VITESSE is not set
>
> #
> # PATA SFF controllers with BMDMA
> #
> # CONFIG_PATA_ALI is not set
> # CONFIG_PATA_AMD is not set
> # CONFIG_PATA_ARTOP is not set
> # CONFIG_PATA_ATIIXP is not set
> # CONFIG_PATA_ATP867X is not set
> # CONFIG_PATA_CMD64X is not set
> # CONFIG_PATA_CS5520 is not set
> # CONFIG_PATA_CS5530 is not set
> # CONFIG_PATA_CS5536 is not set
> CONFIG_PATA_CYPRESS=y
> # CONFIG_PATA_EFAR is not set
> # CONFIG_PATA_HPT366 is not set
> # CONFIG_PATA_HPT37X is not set
> # CONFIG_PATA_HPT3X2N is not set
> # CONFIG_PATA_HPT3X3 is not set
> # CONFIG_PATA_IT8213 is not set
> # CONFIG_PATA_IT821X is not set
> # CONFIG_PATA_JMICRON is not set
> # CONFIG_PATA_MARVELL is not set
> # CONFIG_PATA_NETCELL is not set
> # CONFIG_PATA_NINJA32 is not set
> # CONFIG_PATA_NS87415 is not set
> # CONFIG_PATA_OLDPIIX is not set
> # CONFIG_PATA_OPTIDMA is not set
> CONFIG_PATA_PDC2027X=y
> # CONFIG_PATA_PDC_OLD is not set
> # CONFIG_PATA_RADISYS is not set
> # CONFIG_PATA_RDC is not set
> # CONFIG_PATA_SC1200 is not set
> # CONFIG_PATA_SCH is not set
> # CONFIG_PATA_SERVERWORKS is not set
> # CONFIG_PATA_SIL680 is not set
> # CONFIG_PATA_SIS is not set
> # CONFIG_PATA_TOSHIBA is not set
> # CONFIG_PATA_TRIFLEX is not set
> # CONFIG_PATA_VIA is not set
> # CONFIG_PATA_WINBOND is not set
>
> #
> # PIO-only SFF controllers
> #
> # CONFIG_PATA_CMD640_PCI is not set
> # CONFIG_PATA_MPIIX is not set
> # CONFIG_PATA_NS87410 is not set
> # CONFIG_PATA_OPTI is not set
> # CONFIG_PATA_QDI is not set
> # CONFIG_PATA_RZ1000 is not set
> # CONFIG_PATA_WINBOND_VLB is not set
>
> #
> # Generic fallback / legacy drivers
> #
> # CONFIG_ATA_GENERIC is not set
> # CONFIG_PATA_LEGACY is not set
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=y
> CONFIG_MD_AUTODETECT=y
> CONFIG_MD_LINEAR=y
> CONFIG_MD_RAID0=y
> CONFIG_MD_RAID1=y
> CONFIG_MD_RAID10=y
> CONFIG_MD_RAID456=y
> # CONFIG_MULTICORE_RAID456 is not set
> # CONFIG_MD_MULTIPATH is not set
> # CONFIG_MD_FAULTY is not set
> CONFIG_BLK_DEV_DM=y
> # CONFIG_DM_DEBUG is not set
> CONFIG_DM_CRYPT=y
> CONFIG_DM_SNAPSHOT=y
> # CONFIG_DM_THIN_PROVISIONING is not set
> CONFIG_DM_MIRROR=y
> # CONFIG_DM_RAID is not set
> # CONFIG_DM_LOG_USERSPACE is not set
> CONFIG_DM_ZERO=y
> # CONFIG_DM_MULTIPATH is not set
> # CONFIG_DM_DELAY is not set
> # CONFIG_DM_UEVENT is not set
> # CONFIG_DM_FLAKEY is not set
> # CONFIG_DM_VERITY is not set
> # CONFIG_TARGET_CORE is not set
> # CONFIG_FUSION is not set
>
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_FIREWIRE_NOSY is not set
> # CONFIG_I2O is not set
> CONFIG_NETDEVICES=y
> CONFIG_NET_CORE=y
> # CONFIG_BONDING is not set
> # CONFIG_DUMMY is not set
> # CONFIG_EQUALIZER is not set
> # CONFIG_NET_FC is not set
> CONFIG_MII=y
> # CONFIG_NET_TEAM is not set
> # CONFIG_MACVLAN is not set
> CONFIG_NETCONSOLE=y
> CONFIG_NETCONSOLE_DYNAMIC=y
> CONFIG_NETPOLL=y
> # CONFIG_NETPOLL_TRAP is not set
> CONFIG_NET_POLL_CONTROLLER=y
> # CONFIG_TUN is not set
> # CONFIG_VETH is not set
> # CONFIG_ARCNET is not set
>
> #
> # CAIF transport drivers
> #
> CONFIG_ETHERNET=y
> CONFIG_NET_VENDOR_3COM=y
> # CONFIG_EL1 is not set
> # CONFIG_EL3 is not set
> # CONFIG_3C515 is not set
> CONFIG_VORTEX=y
> # CONFIG_TYPHOON is not set
> CONFIG_NET_VENDOR_ADAPTEC=y
> # CONFIG_ADAPTEC_STARFIRE is not set
> CONFIG_NET_VENDOR_ALTEON=y
> # CONFIG_ACENIC is not set
> CONFIG_NET_VENDOR_AMD=y
> # CONFIG_AMD8111_ETH is not set
> # CONFIG_LANCE is not set
> # CONFIG_PCNET32 is not set
> # CONFIG_DEPCA is not set
> # CONFIG_NI65 is not set
> CONFIG_NET_VENDOR_ATHEROS=y
> # CONFIG_ATL2 is not set
> # CONFIG_ATL1 is not set
> # CONFIG_ATL1E is not set
> # CONFIG_ATL1C is not set
> CONFIG_NET_VENDOR_BROADCOM=y
> # CONFIG_B44 is not set
> # CONFIG_BNX2 is not set
> # CONFIG_CNIC is not set
> # CONFIG_TIGON3 is not set
> # CONFIG_BNX2X is not set
> CONFIG_NET_VENDOR_BROCADE=y
> # CONFIG_BNA is not set
> # CONFIG_NET_CALXEDA_XGMAC is not set
> CONFIG_NET_VENDOR_CHELSIO=y
> # CONFIG_CHELSIO_T1 is not set
> # CONFIG_CHELSIO_T3 is not set
> # CONFIG_CHELSIO_T4 is not set
> # CONFIG_CHELSIO_T4VF is not set
> CONFIG_NET_VENDOR_CIRRUS=y
> # CONFIG_CS89x0 is not set
> CONFIG_NET_VENDOR_CISCO=y
> # CONFIG_ENIC is not set
> # CONFIG_DNET is not set
> CONFIG_NET_VENDOR_DEC=y
> # CONFIG_EWRK3 is not set
> CONFIG_NET_TULIP=y
> # CONFIG_DE2104X is not set
> CONFIG_TULIP=y
> # CONFIG_TULIP_MWI is not set
> CONFIG_TULIP_MMIO=y
> # CONFIG_TULIP_NAPI is not set
> # CONFIG_DE4X5 is not set
> # CONFIG_WINBOND_840 is not set
> # CONFIG_DM9102 is not set
> # CONFIG_ULI526X is not set
> CONFIG_NET_VENDOR_DLINK=y
> # CONFIG_DE600 is not set
> # CONFIG_DE620 is not set
> # CONFIG_DL2K is not set
> # CONFIG_SUNDANCE is not set
> CONFIG_NET_VENDOR_EMULEX=y
> # CONFIG_BE2NET is not set
> CONFIG_NET_VENDOR_EXAR=y
> # CONFIG_S2IO is not set
> # CONFIG_VXGE is not set
> CONFIG_NET_VENDOR_FUJITSU=y
> # CONFIG_AT1700 is not set
> # CONFIG_ETH16I is not set
> CONFIG_NET_VENDOR_HP=y
> # CONFIG_HP100 is not set
> CONFIG_NET_VENDOR_INTEL=y
> # CONFIG_E100 is not set
> # CONFIG_E1000 is not set
> # CONFIG_E1000E is not set
> # CONFIG_IGB is not set
> # CONFIG_IGBVF is not set
> # CONFIG_IXGB is not set
> # CONFIG_IXGBE is not set
> CONFIG_NET_VENDOR_I825XX=y
> # CONFIG_ELPLUS is not set
> # CONFIG_EL16 is not set
> # CONFIG_APRICOT is not set
> # CONFIG_EEXPRESS is not set
> # CONFIG_EEXPRESS_PRO is not set
> # CONFIG_LP486E is not set
> # CONFIG_NI52 is not set
> # CONFIG_ZNET is not set
> # CONFIG_IP1000 is not set
> # CONFIG_JME is not set
> CONFIG_NET_VENDOR_MARVELL=y
> # CONFIG_SKGE is not set
> # CONFIG_SKY2 is not set
> CONFIG_NET_VENDOR_MELLANOX=y
> # CONFIG_MLX4_EN is not set
> # CONFIG_MLX4_CORE is not set
> CONFIG_NET_VENDOR_MICREL=y
> # CONFIG_KS8851_MLL is not set
> # CONFIG_KSZ884X_PCI is not set
> CONFIG_NET_VENDOR_MYRI=y
> # CONFIG_MYRI10GE is not set
> # CONFIG_FEALNX is not set
> CONFIG_NET_VENDOR_NATSEMI=y
> # CONFIG_NATSEMI is not set
> # CONFIG_NS83820 is not set
> CONFIG_NET_VENDOR_8390=y
> # CONFIG_EL2 is not set
> # CONFIG_AC3200 is not set
> # CONFIG_E2100 is not set
> # CONFIG_HPLAN_PLUS is not set
> # CONFIG_HPLAN is not set
> # CONFIG_NE2000 is not set
> # CONFIG_NE2K_PCI is not set
> # CONFIG_ULTRA is not set
> # CONFIG_WD80x3 is not set
> CONFIG_NET_VENDOR_NVIDIA=y
> # CONFIG_FORCEDETH is not set
> CONFIG_NET_VENDOR_OKI=y
> # CONFIG_PCH_GBE is not set
> # CONFIG_ETHOC is not set
> CONFIG_NET_PACKET_ENGINE=y
> # CONFIG_HAMACHI is not set
> # CONFIG_YELLOWFIN is not set
> CONFIG_NET_VENDOR_QLOGIC=y
> # CONFIG_QLA3XXX is not set
> # CONFIG_QLCNIC is not set
> # CONFIG_QLGE is not set
> # CONFIG_NETXEN_NIC is not set
> # CONFIG_NET_VENDOR_RACAL is not set
> CONFIG_NET_VENDOR_REALTEK=y
> # CONFIG_8139CP is not set
> # CONFIG_8139TOO is not set
> # CONFIG_R8169 is not set
> CONFIG_NET_VENDOR_RDC=y
> # CONFIG_R6040 is not set
> CONFIG_NET_VENDOR_SEEQ=y
> # CONFIG_SEEQ8005 is not set
> CONFIG_NET_VENDOR_SILAN=y
> # CONFIG_SC92031 is not set
> CONFIG_NET_VENDOR_SIS=y
> # CONFIG_SIS900 is not set
> # CONFIG_SIS190 is not set
> # CONFIG_SFC is not set
> CONFIG_NET_VENDOR_SMSC=y
> # CONFIG_SMC9194 is not set
> # CONFIG_EPIC100 is not set
> # CONFIG_SMSC9420 is not set
> CONFIG_NET_VENDOR_STMICRO=y
> # CONFIG_STMMAC_ETH is not set
> CONFIG_NET_VENDOR_SUN=y
> # CONFIG_HAPPYMEAL is not set
> # CONFIG_SUNGEM is not set
> # CONFIG_CASSINI is not set
> # CONFIG_NIU is not set
> CONFIG_NET_VENDOR_TEHUTI=y
> # CONFIG_TEHUTI is not set
> CONFIG_NET_VENDOR_TI=y
> # CONFIG_TLAN is not set
> CONFIG_NET_VENDOR_VIA=y
> # CONFIG_VIA_RHINE is not set
> # CONFIG_VIA_VELOCITY is not set
> CONFIG_NET_VENDOR_WIZNET=y
> # CONFIG_WIZNET_W5100 is not set
> # CONFIG_WIZNET_W5300 is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> # CONFIG_NET_SB1000 is not set
> # CONFIG_PHYLIB is not set
> # CONFIG_PLIP is not set
> CONFIG_PPP=y
> # CONFIG_PPP_BSDCOMP is not set
> # CONFIG_PPP_DEFLATE is not set
> # CONFIG_PPP_FILTER is not set
> # CONFIG_PPP_MPPE is not set
> # CONFIG_PPP_MULTILINK is not set
> CONFIG_PPPOE=y
> CONFIG_PPP_ASYNC=y
> # CONFIG_PPP_SYNC_TTY is not set
> # CONFIG_SLIP is not set
> CONFIG_SLHC=y
>
> #
> # USB Network Adapters
> #
> # CONFIG_USB_CATC is not set
> # CONFIG_USB_KAWETH is not set
> # CONFIG_USB_PEGASUS is not set
> # CONFIG_USB_RTL8150 is not set
> # CONFIG_USB_USBNET is not set
> # CONFIG_USB_IPHETH is not set
> CONFIG_WLAN=y
> # CONFIG_AIRO is not set
> # CONFIG_ATMEL is not set
> # CONFIG_PRISM54 is not set
> # CONFIG_USB_ZD1201 is not set
> # CONFIG_HOSTAP is not set
> # CONFIG_WL_TI is not set
>
> #
> # Enable WiMAX (Networking options) to see the WiMAX drivers
> #
> # CONFIG_WAN is not set
> # CONFIG_VMXNET3 is not set
> # CONFIG_ISDN is not set
>
> #
> # Input device support
> #
> CONFIG_INPUT=y
> # CONFIG_INPUT_FF_MEMLESS is not set
> # CONFIG_INPUT_POLLDEV is not set
> # CONFIG_INPUT_SPARSEKMAP is not set
> # CONFIG_INPUT_MATRIXKMAP is not set
>
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_INPUT_MOUSEDEV_PSAUX=y
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1280
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1024
> # CONFIG_INPUT_JOYDEV is not set
> CONFIG_INPUT_EVDEV=y
> # CONFIG_INPUT_EVBUG is not set
>
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> # CONFIG_KEYBOARD_ADP5588 is not set
> # CONFIG_KEYBOARD_ADP5589 is not set
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_QT1070 is not set
> # CONFIG_KEYBOARD_QT2160 is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_TCA6416 is not set
> # CONFIG_KEYBOARD_TCA8418 is not set
> # CONFIG_KEYBOARD_LM8333 is not set
> # CONFIG_KEYBOARD_MAX7359 is not set
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_MPR121 is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_OPENCORES is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_OMAP4 is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=y
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> # CONFIG_MOUSE_PS2_ELANTECH is not set
> # CONFIG_MOUSE_PS2_SENTELIC is not set
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> # CONFIG_MOUSE_SERIAL is not set
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_BCM5974 is not set
> # CONFIG_MOUSE_INPORT is not set
> # CONFIG_MOUSE_LOGIBM is not set
> # CONFIG_MOUSE_PC110PAD is not set
> # CONFIG_MOUSE_VSXXXAA is not set
> # CONFIG_MOUSE_SYNAPTICS_I2C is not set
> # CONFIG_MOUSE_SYNAPTICS_USB is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> CONFIG_INPUT_MISC=y
> # CONFIG_INPUT_AD714X is not set
> # CONFIG_INPUT_BMA150 is not set
> CONFIG_INPUT_PCSPKR=y
> # CONFIG_INPUT_MMA8450 is not set
> # CONFIG_INPUT_MPU3050 is not set
> # CONFIG_INPUT_ATI_REMOTE2 is not set
> # CONFIG_INPUT_KEYSPAN_REMOTE is not set
> # CONFIG_INPUT_KXTJ9 is not set
> # CONFIG_INPUT_POWERMATE is not set
> # CONFIG_INPUT_YEALINK is not set
> # CONFIG_INPUT_CM109 is not set
> # CONFIG_INPUT_UINPUT is not set
> # CONFIG_INPUT_PCF8574 is not set
> # CONFIG_INPUT_ADXL34X is not set
> # CONFIG_INPUT_CMA3000 is not set
>
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> # CONFIG_SERIO_PARKBD is not set
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> # CONFIG_SERIO_ALTERA_PS2 is not set
> # CONFIG_SERIO_PS2MULT is not set
> # CONFIG_GAMEPORT is not set
>
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> # CONFIG_VT_HW_CONSOLE_BINDING is not set
> CONFIG_UNIX98_PTYS=y
> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> # CONFIG_LEGACY_PTYS is not set
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
> # CONFIG_N_GSM is not set
> # CONFIG_TRACE_SINK is not set
> CONFIG_DEVKMEM=y
>
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> CONFIG_SERIAL_8250_MANY_PORTS=y
> # CONFIG_SERIAL_8250_FOURPORT is not set
> # CONFIG_SERIAL_8250_ACCENT is not set
> # CONFIG_SERIAL_8250_BOCA is not set
> # CONFIG_SERIAL_8250_EXAR_ST16C554 is not set
> # CONFIG_SERIAL_8250_HUB6 is not set
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> # CONFIG_SERIAL_8250_DETECT_IRQ is not set
> # CONFIG_SERIAL_8250_RSA is not set
>
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_MFD_HSU is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> # CONFIG_SERIAL_PCH_UART is not set
> # CONFIG_SERIAL_XILINX_PS_UART is not set
> # CONFIG_PRINTER is not set
> CONFIG_PPDEV=y
> # CONFIG_IPMI_HANDLER is not set
> CONFIG_HW_RANDOM=y
> # CONFIG_HW_RANDOM_TIMERIOMEM is not set
> # CONFIG_DTLK is not set
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> CONFIG_RAW_DRIVER=y
> CONFIG_MAX_RAW_DEVS=256
> # CONFIG_TCG_TPM is not set
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_COMPAT=y
> # CONFIG_I2C_CHARDEV is not set
> # CONFIG_I2C_MUX is not set
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_ALGOBIT=y
>
> #
> # I2C Hardware Bus support
> #
>
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> # CONFIG_I2C_AMD756 is not set
> # CONFIG_I2C_AMD8111 is not set
> # CONFIG_I2C_I801 is not set
> # CONFIG_I2C_ISCH is not set
> # CONFIG_I2C_PIIX4 is not set
> # CONFIG_I2C_NFORCE2 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> # CONFIG_I2C_VIA is not set
> # CONFIG_I2C_VIAPRO is not set
>
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> # CONFIG_I2C_DESIGNWARE_PCI is not set
> # CONFIG_I2C_EG20T is not set
> # CONFIG_I2C_INTEL_MID is not set
> # CONFIG_I2C_OCORES is not set
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_PXA_PCI is not set
> # CONFIG_I2C_SIMTEC is not set
> # CONFIG_I2C_XILINX is not set
>
> #
> # External I2C/SMBus adapter drivers
> #
> # CONFIG_I2C_DIOLAN_U2C is not set
> # CONFIG_I2C_PARPORT is not set
> # CONFIG_I2C_PARPORT_LIGHT is not set
> # CONFIG_I2C_TAOS_EVM is not set
> # CONFIG_I2C_TINY_USB is not set
>
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_PCA_ISA is not set
> # CONFIG_I2C_STUB is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_SPI is not set
> # CONFIG_HSI is not set
>
> #
> # PPS support
> #
> # CONFIG_PPS is not set
>
> #
> # PPS generators support
> #
>
> #
> # PTP clock support
> #
>
> #
> # Enable Device Drivers -> PPS to see the PTP clock options.
> #
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> # CONFIG_GPIOLIB is not set
> # CONFIG_W1 is not set
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> # CONFIG_TEST_POWER is not set
> # CONFIG_BATTERY_DS2780 is not set
> # CONFIG_BATTERY_DS2781 is not set
> # CONFIG_BATTERY_DS2782 is not set
> # CONFIG_BATTERY_SBS is not set
> # CONFIG_BATTERY_BQ27x00 is not set
> # CONFIG_BATTERY_MAX17040 is not set
> # CONFIG_BATTERY_MAX17042 is not set
> # CONFIG_CHARGER_MAX8903 is not set
> # CONFIG_CHARGER_LP8727 is not set
> # CONFIG_CHARGER_SMB347 is not set
> # CONFIG_POWER_AVS is not set
> # CONFIG_HWMON is not set
> # CONFIG_THERMAL is not set
> # CONFIG_WATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
>
> #
> # Sonics Silicon Backplane
> #
> # CONFIG_SSB is not set
> CONFIG_BCMA_POSSIBLE=y
>
> #
> # Broadcom specific AMBA
> #
> # CONFIG_BCMA is not set
>
> #
> # Multifunction device drivers
> #
> # CONFIG_MFD_CORE is not set
> # CONFIG_MFD_88PM860X is not set
> # CONFIG_MFD_88PM800 is not set
> # CONFIG_MFD_88PM805 is not set
> # CONFIG_MFD_SM501 is not set
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_MFD_LM3533 is not set
> # CONFIG_TPS6105X is not set
> # CONFIG_TPS6507X is not set
> # CONFIG_MFD_TPS65217 is not set
> # CONFIG_TWL4030_CORE is not set
> # CONFIG_TWL6040_CORE is not set
> # CONFIG_MFD_STMPE is not set
> # CONFIG_MFD_TC3589X is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_PMIC_DA903X is not set
> # CONFIG_MFD_DA9052_I2C is not set
> # CONFIG_PMIC_ADP5520 is not set
> # CONFIG_MFD_MAX77686 is not set
> # CONFIG_MFD_MAX77693 is not set
> # CONFIG_MFD_MAX8925 is not set
> # CONFIG_MFD_MAX8997 is not set
> # CONFIG_MFD_MAX8998 is not set
> # CONFIG_MFD_SEC_CORE is not set
> # CONFIG_MFD_ARIZONA_I2C is not set
> # CONFIG_MFD_WM8400 is not set
> # CONFIG_MFD_WM831X_I2C is not set
> # CONFIG_MFD_WM8350_I2C is not set
> # CONFIG_MFD_WM8994 is not set
> # CONFIG_MFD_PCF50633 is not set
> # CONFIG_MFD_MC13XXX_I2C is not set
> # CONFIG_ABX500_CORE is not set
> # CONFIG_LPC_SCH is not set
> # CONFIG_LPC_ICH is not set
> # CONFIG_MFD_RDC321X is not set
> # CONFIG_MFD_JANZ_CMODIO is not set
> # CONFIG_MFD_VX855 is not set
> # CONFIG_MFD_WL1273_CORE is not set
> # CONFIG_MFD_TPS65090 is not set
> # CONFIG_MFD_RC5T583 is not set
> # CONFIG_MFD_PALMAS is not set
> # CONFIG_REGULATOR is not set
> CONFIG_MEDIA_SUPPORT=y
>
> #
> # Multimedia core support
> #
> CONFIG_MEDIA_CAMERA_SUPPORT=y
> # CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
> # CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
> # CONFIG_MEDIA_RADIO_SUPPORT is not set
> # CONFIG_MEDIA_RC_SUPPORT is not set
> # CONFIG_MEDIA_CONTROLLER is not set
> CONFIG_VIDEO_DEV=y
> CONFIG_VIDEO_V4L2_COMMON=y
>
> #
> # Media drivers
> #
> CONFIG_VIDEO_V4L2=y
> CONFIG_VIDEO_CAPTURE_DRIVERS=y
> # CONFIG_VIDEO_ADV_DEBUG is not set
> # CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
> CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
>
> #
> # Audio decoders, processors and mixers
> #
>
> #
> # RDS decoders
> #
>
> #
> # Video decoders
> #
>
> #
> # Video and audio decoders
> #
>
> #
> # MPEG video encoders
> #
>
> #
> # Video encoders
> #
>
> #
> # Camera sensor devices
> #
>
> #
> # Flash devices
> #
>
> #
> # Video improvement chips
> #
>
> #
> # Miscelaneous helper chips
> #
> # CONFIG_VIDEO_VIVI is not set
> CONFIG_V4L_USB_DRIVERS=y
>
> #
> # Webcam devices
> #
> # CONFIG_USB_VIDEO_CLASS is not set
> CONFIG_USB_GSPCA=y
> # CONFIG_USB_M5602 is not set
> # CONFIG_USB_STV06XX is not set
> # CONFIG_USB_GL860 is not set
> # CONFIG_USB_GSPCA_BENQ is not set
> # CONFIG_USB_GSPCA_CONEX is not set
> # CONFIG_USB_GSPCA_CPIA1 is not set
> # CONFIG_USB_GSPCA_ETOMS is not set
> # CONFIG_USB_GSPCA_FINEPIX is not set
> # CONFIG_USB_GSPCA_JEILINJ is not set
> # CONFIG_USB_GSPCA_JL2005BCD is not set
> # CONFIG_USB_GSPCA_KINECT is not set
> # CONFIG_USB_GSPCA_KONICA is not set
> # CONFIG_USB_GSPCA_MARS is not set
> # CONFIG_USB_GSPCA_MR97310A is not set
> # CONFIG_USB_GSPCA_NW80X is not set
> # CONFIG_USB_GSPCA_OV519 is not set
> # CONFIG_USB_GSPCA_OV534 is not set
> # CONFIG_USB_GSPCA_OV534_9 is not set
> # CONFIG_USB_GSPCA_PAC207 is not set
> # CONFIG_USB_GSPCA_PAC7302 is not set
> # CONFIG_USB_GSPCA_PAC7311 is not set
> # CONFIG_USB_GSPCA_SE401 is not set
> # CONFIG_USB_GSPCA_SN9C2028 is not set
> # CONFIG_USB_GSPCA_SN9C20X is not set
> # CONFIG_USB_GSPCA_SONIXB is not set
> # CONFIG_USB_GSPCA_SONIXJ is not set
> # CONFIG_USB_GSPCA_SPCA500 is not set
> # CONFIG_USB_GSPCA_SPCA501 is not set
> # CONFIG_USB_GSPCA_SPCA505 is not set
> # CONFIG_USB_GSPCA_SPCA506 is not set
> # CONFIG_USB_GSPCA_SPCA508 is not set
> # CONFIG_USB_GSPCA_SPCA561 is not set
> # CONFIG_USB_GSPCA_SPCA1528 is not set
> # CONFIG_USB_GSPCA_SQ905 is not set
> # CONFIG_USB_GSPCA_SQ905C is not set
> # CONFIG_USB_GSPCA_SQ930X is not set
> # CONFIG_USB_GSPCA_STK014 is not set
> # CONFIG_USB_GSPCA_STV0680 is not set
> # CONFIG_USB_GSPCA_SUNPLUS is not set
> # CONFIG_USB_GSPCA_T613 is not set
> # CONFIG_USB_GSPCA_TOPRO is not set
> # CONFIG_USB_GSPCA_TV8532 is not set
> # CONFIG_USB_GSPCA_VC032X is not set
> CONFIG_USB_GSPCA_VICAM=y
> # CONFIG_USB_GSPCA_XIRLINK_CIT is not set
> # CONFIG_USB_GSPCA_ZC3XX is not set
> # CONFIG_USB_PWC is not set
> # CONFIG_VIDEO_CPIA2 is not set
> # CONFIG_USB_ZR364XX is not set
> # CONFIG_USB_STKWEBCAM is not set
> # CONFIG_USB_S2255 is not set
> # CONFIG_USB_SN9C102 is not set
>
> #
> # Webcam and/or TV USB devices
> #
> # CONFIG_VIDEO_EM28XX is not set
> # CONFIG_V4L_ISA_PARPORT_DRIVERS is not set
> # CONFIG_V4L_PLATFORM_DRIVERS is not set
> # CONFIG_V4L_MEM2MEM_DRIVERS is not set
>
> #
> # Graphics support
> #
> # CONFIG_AGP is not set
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_DRM is not set
> # CONFIG_STUB_POULSBO is not set
> CONFIG_VGASTATE=y
> CONFIG_VIDEO_OUTPUT_CONTROL=y
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> CONFIG_FB_DDC=y
> # CONFIG_FB_BOOT_VESA_SUPPORT is not set
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> # CONFIG_FB_SYS_FILLRECT is not set
> # CONFIG_FB_SYS_COPYAREA is not set
> # CONFIG_FB_SYS_IMAGEBLIT is not set
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> # CONFIG_FB_SYS_FOPS is not set
> # CONFIG_FB_WMT_GE_ROPS is not set
> # CONFIG_FB_SVGALIB is not set
> # CONFIG_FB_MACMODES is not set
> CONFIG_FB_BACKLIGHT=y
> CONFIG_FB_MODE_HELPERS=y
> # CONFIG_FB_TILEBLITTING is not set
>
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> # CONFIG_FB_PM2 is not set
> # CONFIG_FB_CYBER2000 is not set
> # CONFIG_FB_ASILIANT is not set
> # CONFIG_FB_IMSTT is not set
> # CONFIG_FB_TGA is not set
> # CONFIG_FB_S1D13XXX is not set
> CONFIG_FB_NVIDIA=y
> CONFIG_FB_NVIDIA_I2C=y
> # CONFIG_FB_NVIDIA_DEBUG is not set
> CONFIG_FB_NVIDIA_BACKLIGHT=y
> # CONFIG_FB_RIVA is not set
> # CONFIG_FB_I740 is not set
> # CONFIG_FB_MATROX is not set
> # CONFIG_FB_RADEON is not set
> # CONFIG_FB_ATY128 is not set
> # CONFIG_FB_ATY is not set
> # CONFIG_FB_S3 is not set
> # CONFIG_FB_SAVAGE is not set
> # CONFIG_FB_SIS is not set
> # CONFIG_FB_NEOMAGIC is not set
> # CONFIG_FB_KYRO is not set
> # CONFIG_FB_3DFX is not set
> # CONFIG_FB_VOODOO1 is not set
> # CONFIG_FB_VT8623 is not set
> # CONFIG_FB_TRIDENT is not set
> # CONFIG_FB_ARK is not set
> # CONFIG_FB_PM3 is not set
> # CONFIG_FB_CARMINE is not set
> # CONFIG_FB_SMSCUFX is not set
> # CONFIG_FB_UDL is not set
> # CONFIG_FB_VIRTUAL is not set
> # CONFIG_FB_METRONOME is not set
> # CONFIG_FB_MB862XX is not set
> # CONFIG_FB_BROADSHEET is not set
> # CONFIG_FB_AUO_K190X is not set
> # CONFIG_EXYNOS_VIDEO is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=y
> # CONFIG_LCD_PLATFORM is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> CONFIG_BACKLIGHT_GENERIC=y
> # CONFIG_BACKLIGHT_ADP8860 is not set
> # CONFIG_BACKLIGHT_ADP8870 is not set
> # CONFIG_BACKLIGHT_LP855X is not set
>
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> # CONFIG_VGACON_SOFT_SCROLLBACK is not set
> # CONFIG_MDA_CONSOLE is not set
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=y
> # CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
> # CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
> CONFIG_FONTS=y
> CONFIG_FONT_8x8=y
> CONFIG_FONT_8x16=y
> # CONFIG_FONT_6x11 is not set
> # CONFIG_FONT_7x14 is not set
> # CONFIG_FONT_PEARL_8x8 is not set
> # CONFIG_FONT_ACORN_8x8 is not set
> CONFIG_FONT_MINI_4x6=y
> # CONFIG_FONT_SUN8x16 is not set
> CONFIG_FONT_SUN12x22=y
> # CONFIG_FONT_10x18 is not set
> CONFIG_LOGO=y
> CONFIG_LOGO_LINUX_MONO=y
> CONFIG_LOGO_LINUX_VGA16=y
> CONFIG_LOGO_LINUX_CLUT224=y
> CONFIG_LOGO_DEC_CLUT224=y
> CONFIG_SOUND=y
> CONFIG_SOUND_OSS_CORE=y
> CONFIG_SOUND_OSS_CORE_PRECLAIM=y
> CONFIG_SND=y
> CONFIG_SND_TIMER=y
> CONFIG_SND_PCM=y
> CONFIG_SND_RAWMIDI=y
> # CONFIG_SND_SEQUENCER is not set
> CONFIG_SND_OSSEMUL=y
> CONFIG_SND_MIXER_OSS=y
> CONFIG_SND_PCM_OSS=y
> CONFIG_SND_PCM_OSS_PLUGINS=y
> # CONFIG_SND_DYNAMIC_MINORS is not set
> CONFIG_SND_SUPPORT_OLD_API=y
> CONFIG_SND_VERBOSE_PROCFS=y
> # CONFIG_SND_VERBOSE_PRINTK is not set
> # CONFIG_SND_DEBUG is not set
> # CONFIG_SND_RAWMIDI_SEQ is not set
> # CONFIG_SND_OPL3_LIB_SEQ is not set
> # CONFIG_SND_OPL4_LIB_SEQ is not set
> # CONFIG_SND_SBAWE_SEQ is not set
> # CONFIG_SND_EMU10K1_SEQ is not set
> CONFIG_SND_DRIVERS=y
> # CONFIG_SND_DUMMY is not set
> # CONFIG_SND_ALOOP is not set
> # CONFIG_SND_MTPAV is not set
> # CONFIG_SND_MTS64 is not set
> # CONFIG_SND_SERIAL_U16550 is not set
> # CONFIG_SND_MPU401 is not set
> # CONFIG_SND_PORTMAN2X4 is not set
> # CONFIG_SND_ISA is not set
> CONFIG_SND_PCI=y
> # CONFIG_SND_AD1889 is not set
> # CONFIG_SND_ALS300 is not set
> # CONFIG_SND_ALS4000 is not set
> # CONFIG_SND_ALI5451 is not set
> # CONFIG_SND_ATIIXP is not set
> # CONFIG_SND_ATIIXP_MODEM is not set
> # CONFIG_SND_AU8810 is not set
> # CONFIG_SND_AU8820 is not set
> # CONFIG_SND_AU8830 is not set
> # CONFIG_SND_AW2 is not set
> # CONFIG_SND_AZT3328 is not set
> # CONFIG_SND_BT87X is not set
> # CONFIG_SND_CA0106 is not set
> # CONFIG_SND_CMIPCI is not set
> # CONFIG_SND_OXYGEN is not set
> # CONFIG_SND_CS4281 is not set
> # CONFIG_SND_CS46XX is not set
> # CONFIG_SND_CS5530 is not set
> # CONFIG_SND_CS5535AUDIO is not set
> # CONFIG_SND_CTXFI is not set
> # CONFIG_SND_DARLA20 is not set
> # CONFIG_SND_GINA20 is not set
> # CONFIG_SND_LAYLA20 is not set
> # CONFIG_SND_DARLA24 is not set
> # CONFIG_SND_GINA24 is not set
> # CONFIG_SND_LAYLA24 is not set
> # CONFIG_SND_MONA is not set
> # CONFIG_SND_MIA is not set
> # CONFIG_SND_ECHO3G is not set
> # CONFIG_SND_INDIGO is not set
> # CONFIG_SND_INDIGOIO is not set
> # CONFIG_SND_INDIGODJ is not set
> # CONFIG_SND_INDIGOIOX is not set
> # CONFIG_SND_INDIGODJX is not set
> # CONFIG_SND_EMU10K1 is not set
> # CONFIG_SND_EMU10K1X is not set
> CONFIG_SND_ENS1370=y
> # CONFIG_SND_ENS1371 is not set
> # CONFIG_SND_ES1938 is not set
> # CONFIG_SND_ES1968 is not set
> # CONFIG_SND_FM801 is not set
> # CONFIG_SND_HDA_INTEL is not set
> # CONFIG_SND_HDSP is not set
> # CONFIG_SND_HDSPM is not set
> # CONFIG_SND_ICE1712 is not set
> # CONFIG_SND_ICE1724 is not set
> # CONFIG_SND_INTEL8X0 is not set
> # CONFIG_SND_INTEL8X0M is not set
> # CONFIG_SND_KORG1212 is not set
> # CONFIG_SND_LOLA is not set
> # CONFIG_SND_LX6464ES is not set
> # CONFIG_SND_MAESTRO3 is not set
> # CONFIG_SND_MIXART is not set
> # CONFIG_SND_NM256 is not set
> # CONFIG_SND_PCXHR is not set
> # CONFIG_SND_RIPTIDE is not set
> # CONFIG_SND_RME32 is not set
> # CONFIG_SND_RME96 is not set
> # CONFIG_SND_RME9652 is not set
> # CONFIG_SND_SONICVIBES is not set
> # CONFIG_SND_TRIDENT is not set
> # CONFIG_SND_VIA82XX is not set
> # CONFIG_SND_VIA82XX_MODEM is not set
> # CONFIG_SND_VIRTUOSO is not set
> # CONFIG_SND_VX222 is not set
> # CONFIG_SND_YMFPCI is not set
> CONFIG_SND_USB=y
> # CONFIG_SND_USB_AUDIO is not set
> # CONFIG_SND_USB_UA101 is not set
> # CONFIG_SND_USB_USX2Y is not set
> # CONFIG_SND_USB_CAIAQ is not set
> # CONFIG_SND_USB_6FIRE is not set
> # CONFIG_SND_SOC is not set
> # CONFIG_SOUND_PRIME is not set
>
> #
> # HID support
> #
> CONFIG_HID=y
> CONFIG_HID_BATTERY_STRENGTH=y
> CONFIG_HIDRAW=y
> # CONFIG_UHID is not set
> CONFIG_HID_GENERIC=y
>
> #
> # Special HID drivers
> #
>
> #
> # USB HID support
> #
> # CONFIG_USB_HID is not set
> # CONFIG_HID_PID is not set
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB_ARCH_HAS_XHCI=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_COMMON=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB=y
> CONFIG_USB_DEBUG=y
> CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
>
> #
> # Miscellaneous USB options
> #
> # CONFIG_USB_DYNAMIC_MINORS is not set
> CONFIG_USB_MON=y
> # CONFIG_USB_WUSB_CBAF is not set
>
> #
> # USB Host Controller Drivers
> #
> # CONFIG_USB_C67X00_HCD is not set
> # CONFIG_USB_XHCI_HCD is not set
> CONFIG_USB_EHCI_HCD=y
> # CONFIG_USB_EHCI_ROOT_HUB_TT is not set
> # CONFIG_USB_EHCI_TT_NEWSCHED is not set
> # CONFIG_USB_OXU210HP_HCD is not set
> # CONFIG_USB_ISP116X_HCD is not set
> # CONFIG_USB_ISP1760_HCD is not set
> # CONFIG_USB_ISP1362_HCD is not set
> CONFIG_USB_OHCI_HCD=y
> # CONFIG_USB_OHCI_HCD_PLATFORM is not set
> # CONFIG_USB_EHCI_HCD_PLATFORM is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> # CONFIG_USB_UHCI_HCD is not set
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
> # CONFIG_USB_CHIPIDEA is not set
>
> #
> # USB Device Class drivers
> #
> # CONFIG_USB_ACM is not set
> # CONFIG_USB_PRINTER is not set
> # CONFIG_USB_WDM is not set
> # CONFIG_USB_TMC is not set
>
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
>
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> CONFIG_USB_STORAGE=y
> # CONFIG_USB_STORAGE_DEBUG is not set
> # CONFIG_USB_STORAGE_REALTEK is not set
> # CONFIG_USB_STORAGE_DATAFAB is not set
> # CONFIG_USB_STORAGE_FREECOM is not set
> # CONFIG_USB_STORAGE_ISD200 is not set
> # CONFIG_USB_STORAGE_USBAT is not set
> # CONFIG_USB_STORAGE_SDDR09 is not set
> # CONFIG_USB_STORAGE_SDDR55 is not set
> # CONFIG_USB_STORAGE_JUMPSHOT is not set
> # CONFIG_USB_STORAGE_ALAUDA is not set
> # CONFIG_USB_STORAGE_ONETOUCH is not set
> # CONFIG_USB_STORAGE_KARMA is not set
> # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
> # CONFIG_USB_STORAGE_ENE_UB6250 is not set
> CONFIG_USB_UAS=y
> # CONFIG_USB_LIBUSUAL is not set
>
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> # CONFIG_USB_MICROTEK is not set
>
> #
> # USB port drivers
> #
> # CONFIG_USB_USS720 is not set
> CONFIG_USB_SERIAL=y
> CONFIG_USB_SERIAL_CONSOLE=y
> # CONFIG_USB_EZUSB is not set
> CONFIG_USB_SERIAL_GENERIC=y
> # CONFIG_USB_SERIAL_AIRCABLE is not set
> # CONFIG_USB_SERIAL_ARK3116 is not set
> # CONFIG_USB_SERIAL_BELKIN is not set
> # CONFIG_USB_SERIAL_CH341 is not set
> # CONFIG_USB_SERIAL_WHITEHEAT is not set
> # CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
> # CONFIG_USB_SERIAL_CP210X is not set
> # CONFIG_USB_SERIAL_CYPRESS_M8 is not set
> # CONFIG_USB_SERIAL_EMPEG is not set
> # CONFIG_USB_SERIAL_FTDI_SIO is not set
> # CONFIG_USB_SERIAL_FUNSOFT is not set
> # CONFIG_USB_SERIAL_VISOR is not set
> CONFIG_USB_SERIAL_IPAQ=y
> # CONFIG_USB_SERIAL_IR is not set
> # CONFIG_USB_SERIAL_EDGEPORT is not set
> # CONFIG_USB_SERIAL_EDGEPORT_TI is not set
> # CONFIG_USB_SERIAL_F81232 is not set
> # CONFIG_USB_SERIAL_GARMIN is not set
> # CONFIG_USB_SERIAL_IPW is not set
> # CONFIG_USB_SERIAL_IUU is not set
> # CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
> # CONFIG_USB_SERIAL_KEYSPAN is not set
> # CONFIG_USB_SERIAL_KLSI is not set
> # CONFIG_USB_SERIAL_KOBIL_SCT is not set
> # CONFIG_USB_SERIAL_MCT_U232 is not set
> # CONFIG_USB_SERIAL_METRO is not set
> # CONFIG_USB_SERIAL_MOS7720 is not set
> # CONFIG_USB_SERIAL_MOS7840 is not set
> # CONFIG_USB_SERIAL_MOTOROLA is not set
> # CONFIG_USB_SERIAL_NAVMAN is not set
> CONFIG_USB_SERIAL_PL2303=y
> # CONFIG_USB_SERIAL_OTI6858 is not set
> # CONFIG_USB_SERIAL_QCAUX is not set
> # CONFIG_USB_SERIAL_QUALCOMM is not set
> # CONFIG_USB_SERIAL_SPCP8X5 is not set
> # CONFIG_USB_SERIAL_HP4X is not set
> # CONFIG_USB_SERIAL_SAFE is not set
> # CONFIG_USB_SERIAL_SIEMENS_MPI is not set
> # CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
> # CONFIG_USB_SERIAL_SYMBOL is not set
> # CONFIG_USB_SERIAL_TI is not set
> # CONFIG_USB_SERIAL_CYBERJACK is not set
> # CONFIG_USB_SERIAL_XIRCOM is not set
> # CONFIG_USB_SERIAL_OPTION is not set
> # CONFIG_USB_SERIAL_OMNINET is not set
> # CONFIG_USB_SERIAL_OPTICON is not set
> # CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
> # CONFIG_USB_SERIAL_ZIO is not set
> # CONFIG_USB_SERIAL_SSU100 is not set
> # CONFIG_USB_SERIAL_QT2 is not set
> # CONFIG_USB_SERIAL_DEBUG is not set
>
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> # CONFIG_USB_EMI26 is not set
> # CONFIG_USB_ADUTUX is not set
> # CONFIG_USB_SEVSEG is not set
> # CONFIG_USB_RIO500 is not set
> # CONFIG_USB_LEGOTOWER is not set
> # CONFIG_USB_LCD is not set
> # CONFIG_USB_LED is not set
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> # CONFIG_USB_CYTHERM is not set
> # CONFIG_USB_IDMOUSE is not set
> # CONFIG_USB_FTDI_ELAN is not set
> # CONFIG_USB_APPLEDISPLAY is not set
> # CONFIG_USB_SISUSBVGA is not set
> # CONFIG_USB_LD is not set
> # CONFIG_USB_TRANCEVIBRATOR is not set
> # CONFIG_USB_IOWARRIOR is not set
> # CONFIG_USB_TEST is not set
> # CONFIG_USB_ISIGHTFW is not set
> # CONFIG_USB_YUREX is not set
>
> #
> # USB Physical Layer drivers
> #
> # CONFIG_USB_ISP1301 is not set
> # CONFIG_USB_GADGET is not set
>
> #
> # OTG and related infrastructure
> #
> # CONFIG_NOP_USB_XCEIV is not set
> # CONFIG_UWB is not set
> # CONFIG_MMC is not set
> # CONFIG_MEMSTICK is not set
> # CONFIG_NEW_LEDS is not set
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_INFINIBAND is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> # CONFIG_RTC_DEBUG is not set
>
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> # CONFIG_RTC_DRV_TEST is not set
>
> #
> # I2C RTC drivers
> #
> # CONFIG_RTC_DRV_DS1307 is not set
> # CONFIG_RTC_DRV_DS1374 is not set
> # CONFIG_RTC_DRV_DS1672 is not set
> # CONFIG_RTC_DRV_DS3232 is not set
> # CONFIG_RTC_DRV_MAX6900 is not set
> # CONFIG_RTC_DRV_RS5C372 is not set
> # CONFIG_RTC_DRV_ISL1208 is not set
> # CONFIG_RTC_DRV_ISL12022 is not set
> # CONFIG_RTC_DRV_X1205 is not set
> # CONFIG_RTC_DRV_PCF8563 is not set
> # CONFIG_RTC_DRV_PCF8583 is not set
> # CONFIG_RTC_DRV_M41T80 is not set
> # CONFIG_RTC_DRV_BQ32K is not set
> # CONFIG_RTC_DRV_S35390A is not set
> # CONFIG_RTC_DRV_FM3130 is not set
> # CONFIG_RTC_DRV_RX8581 is not set
> # CONFIG_RTC_DRV_RX8025 is not set
> # CONFIG_RTC_DRV_EM3027 is not set
> # CONFIG_RTC_DRV_RV3029C2 is not set
>
> #
> # SPI RTC drivers
> #
>
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=y
> # CONFIG_RTC_DRV_DS1286 is not set
> # CONFIG_RTC_DRV_DS1511 is not set
> # CONFIG_RTC_DRV_DS1553 is not set
> # CONFIG_RTC_DRV_DS1742 is not set
> # CONFIG_RTC_DRV_STK17TA8 is not set
> # CONFIG_RTC_DRV_M48T86 is not set
> # CONFIG_RTC_DRV_M48T35 is not set
> # CONFIG_RTC_DRV_M48T59 is not set
> # CONFIG_RTC_DRV_MSM6242 is not set
> # CONFIG_RTC_DRV_BQ4802 is not set
> # CONFIG_RTC_DRV_RP5C01 is not set
> # CONFIG_RTC_DRV_V3020 is not set
>
> #
> # on-CPU RTC drivers
> #
> # CONFIG_DMADEVICES is not set
> # CONFIG_AUXDISPLAY is not set
> # CONFIG_UIO is not set
>
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_PCI is not set
> # CONFIG_VIRTIO_BALLOON is not set
> # CONFIG_VIRTIO_MMIO is not set
>
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_STAGING is not set
>
> #
> # Hardware Spinlock drivers
> #
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> CONFIG_IOMMU_SUPPORT=y
>
> #
> # Remoteproc drivers (EXPERIMENTAL)
> #
>
> #
> # Rpmsg drivers (EXPERIMENTAL)
> #
> # CONFIG_VIRT_DRIVERS is not set
> # CONFIG_PM_DEVFREQ is not set
> # CONFIG_EXTCON is not set
> # CONFIG_MEMORY is not set
> # CONFIG_IIO is not set
> # CONFIG_VME_BUS is not set
> # CONFIG_PWM is not set
>
> #
> # File systems
> #
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> # CONFIG_EXT2_FS_SECURITY is not set
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=y
> # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
> CONFIG_EXT3_FS_XATTR=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> # CONFIG_EXT3_FS_SECURITY is not set
> # CONFIG_EXT4_FS is not set
> CONFIG_JBD=y
> CONFIG_FS_MBCACHE=y
> # CONFIG_REISERFS_FS is not set
> # CONFIG_JFS_FS is not set
> # CONFIG_XFS_FS is not set
> # CONFIG_GFS2_FS is not set
> # CONFIG_OCFS2_FS is not set
> # CONFIG_BTRFS_FS is not set
> # CONFIG_NILFS2_FS is not set
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY_USER=y
> # CONFIG_FANOTIFY is not set
> # CONFIG_QUOTA is not set
> # CONFIG_QUOTACTL is not set
> CONFIG_AUTOFS4_FS=y
> # CONFIG_FUSE_FS is not set
>
> #
> # Caches
> #
> # CONFIG_FSCACHE is not set
>
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=y
> CONFIG_JOLIET=y
> CONFIG_ZISOFS=y
> CONFIG_UDF_FS=y
> CONFIG_UDF_NLS=y
>
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> CONFIG_MSDOS_FS=y
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> CONFIG_NTFS_FS=y
> # CONFIG_NTFS_DEBUG is not set
> CONFIG_NTFS_RW=y
>
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> # CONFIG_TMPFS_POSIX_ACL is not set
> # CONFIG_TMPFS_XATTR is not set
> # CONFIG_HUGETLB_PAGE is not set
> CONFIG_CONFIGFS_FS=y
> CONFIG_MISC_FILESYSTEMS=y
> # CONFIG_ADFS_FS is not set
> # CONFIG_AFFS_FS is not set
> # CONFIG_ECRYPT_FS is not set
> # CONFIG_HFS_FS is not set
> # CONFIG_HFSPLUS_FS is not set
> # CONFIG_BEFS_FS is not set
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> # CONFIG_LOGFS is not set
> CONFIG_CRAMFS=y
> # CONFIG_SQUASHFS is not set
> # CONFIG_VXFS_FS is not set
> # CONFIG_MINIX_FS is not set
> # CONFIG_OMFS_FS is not set
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_QNX6FS_FS is not set
> # CONFIG_ROMFS_FS is not set
> # CONFIG_PSTORE is not set
> # CONFIG_SYSV_FS is not set
> CONFIG_UFS_FS=y
> # CONFIG_UFS_FS_WRITE is not set
> # CONFIG_UFS_DEBUG is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NFS_FS=y
> CONFIG_NFS_V2=y
> CONFIG_NFS_V3=y
> CONFIG_NFS_V3_ACL=y
> CONFIG_NFS_V4=y
> # CONFIG_NFS_SWAP is not set
> # CONFIG_NFS_V4_1 is not set
> CONFIG_ROOT_NFS=y
> # CONFIG_NFS_USE_LEGACY_DNS is not set
> CONFIG_NFS_USE_KERNEL_DNS=y
> CONFIG_NFSD=y
> CONFIG_NFSD_V2_ACL=y
> CONFIG_NFSD_V3=y
> CONFIG_NFSD_V3_ACL=y
> CONFIG_NFSD_V4=y
> # CONFIG_NFSD_FAULT_INJECTION is not set
> CONFIG_LOCKD=y
> CONFIG_LOCKD_V4=y
> CONFIG_NFS_ACL_SUPPORT=y
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=y
> CONFIG_SUNRPC_GSS=y
> # CONFIG_SUNRPC_DEBUG is not set
> # CONFIG_CEPH_FS is not set
> CONFIG_CIFS=y
> # CONFIG_CIFS_STATS is not set
> # CONFIG_CIFS_WEAK_PW_HASH is not set
> # CONFIG_CIFS_UPCALL is not set
> CONFIG_CIFS_XATTR=y
> CONFIG_CIFS_POSIX=y
> # CONFIG_CIFS_DEBUG2 is not set
> # CONFIG_CIFS_DFS_UPCALL is not set
> # CONFIG_CIFS_ACL is not set
> # CONFIG_NCP_FS is not set
> # CONFIG_CODA_FS is not set
> # CONFIG_AFS_FS is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-15"
> CONFIG_NLS_CODEPAGE_437=y
> # CONFIG_NLS_CODEPAGE_737 is not set
> # CONFIG_NLS_CODEPAGE_775 is not set
> CONFIG_NLS_CODEPAGE_850=y
> # CONFIG_NLS_CODEPAGE_852 is not set
> # CONFIG_NLS_CODEPAGE_855 is not set
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> # CONFIG_NLS_CODEPAGE_861 is not set
> # CONFIG_NLS_CODEPAGE_862 is not set
> # CONFIG_NLS_CODEPAGE_863 is not set
> # CONFIG_NLS_CODEPAGE_864 is not set
> # CONFIG_NLS_CODEPAGE_865 is not set
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> # CONFIG_NLS_CODEPAGE_950 is not set
> # CONFIG_NLS_CODEPAGE_932 is not set
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> # CONFIG_NLS_CODEPAGE_1251 is not set
> # CONFIG_NLS_ASCII is not set
> CONFIG_NLS_ISO8859_1=y
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> # CONFIG_NLS_ISO8859_6 is not set
> # CONFIG_NLS_ISO8859_7 is not set
> # CONFIG_NLS_ISO8859_9 is not set
> # CONFIG_NLS_ISO8859_13 is not set
> # CONFIG_NLS_ISO8859_14 is not set
> CONFIG_NLS_ISO8859_15=y
> # CONFIG_NLS_KOI8_R is not set
> # CONFIG_NLS_KOI8_U is not set
> # CONFIG_NLS_MAC_ROMAN is not set
> # CONFIG_NLS_MAC_CELTIC is not set
> # CONFIG_NLS_MAC_CENTEURO is not set
> # CONFIG_NLS_MAC_CROATIAN is not set
> # CONFIG_NLS_MAC_CYRILLIC is not set
> # CONFIG_NLS_MAC_GAELIC is not set
> # CONFIG_NLS_MAC_GREEK is not set
> # CONFIG_NLS_MAC_ICELAND is not set
> # CONFIG_NLS_MAC_INUIT is not set
> # CONFIG_NLS_MAC_ROMANIAN is not set
> # CONFIG_NLS_MAC_TURKISH is not set
> CONFIG_NLS_UTF8=y
> # CONFIG_DLM is not set
>
> #
> # Kernel hacking
> #
> # CONFIG_PRINTK_TIME is not set
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> CONFIG_ENABLE_WARN_DEPRECATED=y
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_FRAME_WARN=2048
> CONFIG_MAGIC_SYSRQ=y
> # CONFIG_STRIP_ASM_SYMS is not set
> # CONFIG_READABLE_ASM is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> # CONFIG_DEBUG_FS is not set
> # CONFIG_HEADERS_CHECK is not set
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_DEBUG_KERNEL=y
> # CONFIG_DEBUG_SHIRQ is not set
> # CONFIG_LOCKUP_DETECTOR is not set
> # CONFIG_HARDLOCKUP_DETECTOR is not set
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=0
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
> # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
> CONFIG_SCHED_DEBUG=y
> # CONFIG_SCHEDSTATS is not set
> # CONFIG_TIMER_STATS is not set
> # CONFIG_DEBUG_OBJECTS is not set
> # CONFIG_DEBUG_SLAB is not set
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> # CONFIG_DEBUG_SPINLOCK is not set
> # CONFIG_DEBUG_MUTEXES is not set
> # CONFIG_SPARSE_RCU_POINTER is not set
> # CONFIG_DEBUG_ATOMIC_SLEEP is not set
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_KOBJECT is not set
> # CONFIG_DEBUG_INFO is not set
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_WRITECOUNT is not set
> CONFIG_DEBUG_MEMORY_INIT=y
> # CONFIG_DEBUG_LIST is not set
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_DEBUG_CREDENTIALS is not set
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=60
> # CONFIG_RCU_CPU_STALL_INFO is not set
> # CONFIG_RCU_TRACE is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> # CONFIG_DEBUG_PER_CPU_MAPS is not set
> # CONFIG_NOTIFIER_ERROR_INJECTION is not set
> # CONFIG_FAULT_INJECTION is not set
> # CONFIG_DEBUG_PAGEALLOC is not set
> # CONFIG_ATOMIC64_SELFTEST is not set
> # CONFIG_ASYNC_RAID6_TEST is not set
> # CONFIG_SAMPLES is not set
> # CONFIG_TEST_KSTRTOX is not set
> CONFIG_EARLY_PRINTK=y
> CONFIG_ALPHA_LEGACY_START_ADDRESS=y
> CONFIG_MATHEMU=y
>
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_ENCRYPTED_KEYS is not set
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> # CONFIG_SECURITY is not set
> # CONFIG_SECURITYFS is not set
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_XOR_BLOCKS=y
> CONFIG_ASYNC_CORE=y
> CONFIG_ASYNC_MEMCPY=y
> CONFIG_ASYNC_XOR=y
> CONFIG_ASYNC_PQ=y
> CONFIG_ASYNC_RAID6_RECOV=y
> CONFIG_CRYPTO=y
>
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=y
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> # CONFIG_CRYPTO_USER is not set
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> # CONFIG_CRYPTO_GF128MUL is not set
> CONFIG_CRYPTO_NULL=y
> # CONFIG_CRYPTO_PCRYPT is not set
> CONFIG_CRYPTO_WORKQUEUE=y
> # CONFIG_CRYPTO_CRYPTD is not set
> CONFIG_CRYPTO_AUTHENC=y
> # CONFIG_CRYPTO_TEST is not set
>
> #
> # Authenticated Encryption with Associated Data
> #
> # CONFIG_CRYPTO_CCM is not set
> # CONFIG_CRYPTO_GCM is not set
> # CONFIG_CRYPTO_SEQIV is not set
>
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> # CONFIG_CRYPTO_CTR is not set
> # CONFIG_CRYPTO_CTS is not set
> CONFIG_CRYPTO_ECB=y
> # CONFIG_CRYPTO_LRW is not set
> CONFIG_CRYPTO_PCBC=y
> # CONFIG_CRYPTO_XTS is not set
>
> #
> # Hash modes
> #
> CONFIG_CRYPTO_HMAC=y
> # CONFIG_CRYPTO_XCBC is not set
> # CONFIG_CRYPTO_VMAC is not set
>
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> # CONFIG_CRYPTO_GHASH is not set
> CONFIG_CRYPTO_MD4=y
> CONFIG_CRYPTO_MD5=y
> # CONFIG_CRYPTO_MICHAEL_MIC is not set
> # CONFIG_CRYPTO_RMD128 is not set
> # CONFIG_CRYPTO_RMD160 is not set
> # CONFIG_CRYPTO_RMD256 is not set
> # CONFIG_CRYPTO_RMD320 is not set
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> # CONFIG_CRYPTO_TGR192 is not set
> # CONFIG_CRYPTO_WP512 is not set
>
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> # CONFIG_CRYPTO_ANUBIS is not set
> CONFIG_CRYPTO_ARC4=y
> # CONFIG_CRYPTO_BLOWFISH is not set
> # CONFIG_CRYPTO_CAMELLIA is not set
> # CONFIG_CRYPTO_CAST5 is not set
> # CONFIG_CRYPTO_CAST6 is not set
> CONFIG_CRYPTO_DES=y
> # CONFIG_CRYPTO_FCRYPT is not set
> # CONFIG_CRYPTO_KHAZAD is not set
> # CONFIG_CRYPTO_SALSA20 is not set
> # CONFIG_CRYPTO_SEED is not set
> # CONFIG_CRYPTO_SERPENT is not set
> # CONFIG_CRYPTO_TEA is not set
> # CONFIG_CRYPTO_TWOFISH is not set
>
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> # CONFIG_CRYPTO_ZLIB is not set
> # CONFIG_CRYPTO_LZO is not set
>
> #
> # Random Number Generation
> #
> # CONFIG_CRYPTO_ANSI_CPRNG is not set
> # CONFIG_CRYPTO_USER_API_HASH is not set
> # CONFIG_CRYPTO_USER_API_SKCIPHER is not set
> CONFIG_CRYPTO_HW=y
> # CONFIG_BINARY_PRINTF is not set
>
> #
> # Library routines
> #
> CONFIG_RAID6_PQ=y
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> # CONFIG_CRC32_SELFTEST is not set
> CONFIG_CRC32_SLICEBY8=y
> # CONFIG_CRC32_SLICEBY4 is not set
> # CONFIG_CRC32_SARWATE is not set
> # CONFIG_CRC32_BIT is not set
> # CONFIG_CRC7 is not set
> CONFIG_LIBCRC32C=y
> # CONFIG_CRC8 is not set
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> CONFIG_XZ_DEC_POWERPC=y
> CONFIG_XZ_DEC_IA64=y
> CONFIG_XZ_DEC_ARM=y
> CONFIG_XZ_DEC_ARMTHUMB=y
> CONFIG_XZ_DEC_SPARC=y
> CONFIG_XZ_DEC_BCJ=y
> # CONFIG_XZ_DEC_TEST is not set
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_DECOMPRESS_BZIP2=y
> CONFIG_DECOMPRESS_LZMA=y
> CONFIG_DECOMPRESS_XZ=y
> CONFIG_DECOMPRESS_LZO=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_CPU_RMAP=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> # CONFIG_AVERAGE is not set
> # CONFIG_CORDIC is not set
> # CONFIG_DDR is not set
>
>
> --
> | Thorsten Kranzkowski        Internet: dl8bcu@dl8bcu.de                      |
> | Mobile: ++49 170 1876134       Snail: Kiebitzstr. 14, 49324 Melle, Germany  |
> | Ampr: dl8bcu@db0lj.#rpl.deu.eu, dl8bcu@marvin.dl8bcu.ampr.org [44.130.8.19] |

