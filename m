Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab2HQAMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 20:12:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:32195 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab2HQAMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 20:12:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,781,1336374000"; 
   d="scan'208";a="203120073"
Date: Fri, 17 Aug 2012 08:11:56 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kulikov Vasiliy <segooon@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>, Willy Tarreau <w@1wt.eu>
Subject: Re: [panel] BUG: spinlock trylock failure on UP
Message-ID: <20120817001156.GA23009@localhost>
References: <20120713081942.GB19486@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120713081942.GB19486@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 04:19:42PM +0800, Fengguang Wu wrote:
> Hi,
> 
> Shall we use spin_lock_irqsave(&pprt_lock)?

Ping. It still happens in 3.6-rc1.. Shall I do a patch?

>         [    8.232324] BUG: spinlock trylock failure on UP on CPU#0, reboot/85
>         [    8.234138]  lock: c161c760, .magic: dead4ead, .owner: reboot/85, .owner_cpu: 0
>         [    8.236132] Pid: 85, comm: reboot Not tainted 3.4.0-rc7-00656-g82163ed #5
>         [    8.237965] Call Trace:
>         [    8.238648]  [<c13dfd20>] ? printk+0x18/0x1a
>         [    8.239827]  [<c122a5e0>] spin_dump+0x80/0xd0
>         [    8.241016]  [<c122a652>] spin_bug+0x22/0x30
>         [    8.242181]  [<c122a93b>] do_raw_spin_trylock+0x5b/0x70
>         [    8.243611]  [<c13e8bae>] _raw_spin_trylock+0xe/0x60
>         [    8.244975]  [<c1392230>] ? keypad_send_key.constprop.9+0xe0/0xe0
> ==>     [    8.246638]  [<c13922ea>] panel_scan_timer+0xba/0x570
>         [    8.248019]  [<c1392230>] ? keypad_send_key.constprop.9+0xe0/0xe0
>         [    8.249689]  [<c102f6f5>] run_timer_softirq+0x1e5/0x370
>         [    8.251191]  [<c102f645>] ? run_timer_softirq+0x135/0x370
>         [    8.252718]  [<c1392230>] ? keypad_send_key.constprop.9+0xe0/0xe0
>         [    8.254462]  [<c102a592>] __do_softirq+0xc2/0x1c0
>         [    8.255758]  [<c102a4d0>] ? local_bh_enable_ip+0x130/0x130
>         [    8.257228]  <IRQ>  [<c102a855>] ? irq_exit+0x65/0x70
>         [    8.258647]  [<c1013ff9>] ? smp_apic_timer_interrupt+0x49/0x80
>         [    8.260226]  [<c13e96c1>] ? apic_timer_interrupt+0x31/0x38
>         [    8.261737]  [<c12700e0>] ? drm_vm_open_locked+0x70/0xb0
>         [    8.263166]  [<c122489a>] ? delay_tsc+0x1a/0x30
>         [    8.264452]  [<c12248c9>] ? __delay+0x9/0x10
>         [    8.265621]  [<c12248ec>] ? __const_udelay+0x1c/0x20
> ==>     [    8.266967]  [<c139136c>] ? lcd_clear_fast_p8+0x9c/0xe0
>         [    8.268386]  [<c1391a66>] ? lcd_write+0x226/0x810
>         [    8.269653]  [<c1367900>] ? md_set_readonly+0xc0/0xc0
>         [    8.271013]  [<c122a9ed>] ? do_raw_spin_unlock+0x9d/0xe0
>         [    8.272470]  [<c1392a98>] ? panel_lcd_print+0x38/0x40
>         [    8.273837]  [<c1392ace>] ? panel_notify_sys+0x2e/0x60
>         [    8.275224]  [<c1046634>] ? notifier_call_chain+0x84/0xb0
>         [    8.276754]  [<c10469ce>] ? __blocking_notifier_call_chain+0x3e/0x60
>         [    8.278576]  [<c1046a0a>] ? blocking_notifier_call_chain+0x1a/0x20
>         [    8.280267]  [<c1036a14>] ? kernel_restart_prepare+0x14/0x40
>         [    8.281901]  [<c1036a8e>] ? kernel_restart+0xe/0x50
>         [    8.283216]  [<c1036ce9>] ? sys_reboot+0x149/0x1e0
>         [    8.284532]  [<c10b3fb3>] ? handle_pte_fault+0x93/0xd70
>         [    8.285956]  [<c1019e35>] ? do_page_fault+0x215/0x5e0
>         [    8.287330]  [<c101a113>] ? do_page_fault+0x4f3/0x5e0
>         [    8.288704]  [<c1045ac6>] ? up_read+0x16/0x30
>         [    8.289890]  [<c101a113>] ? do_page_fault+0x4f3/0x5e0
>         [    8.291252]  [<c10d4486>] ? iterate_supers+0x86/0xd0
>         [    8.292615]  [<c122a9ed>] ? do_raw_spin_unlock+0x9d/0xe0
>         [    8.294049]  [<c13e8dcd>] ? _raw_spin_unlock+0x1d/0x20
>         [    8.295449]  [<c10d44ab>] ? iterate_supers+0xab/0xd0
>         [    8.296795]  [<c10fb620>] ? __sync_filesystem+0xa0/0xa0
>         [    8.298199]  [<c13e9b03>] ? sysenter_do_call+0x12/0x37
>         [    8.306899] Restarting system.
>         [    8.307747] machine restart
> 
> Thanks,
> Fengguang

> [    0.000000] Linux version 3.4.0-rc7-00656-g82163ed (wfg@bee) (gcc version 4.7.0 (Debian 4.7.1-1) ) #5 Fri Jul 13 14:57:07 CST 2012
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   NSC Geode by NSC
> [    0.000000]   Cyrix CyrixInstead
> [    0.000000]   Centaur CentaurHauls
> [    0.000000]   UMC UMC UMC UMC
> [    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
> [    0.000000] CPU: Your system may be unstable.
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
> [    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000000fffd000 (usable)
> [    0.000000]  BIOS-e820: 000000000fffd000 - 0000000010000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> [    0.000000] last_pfn = 0xfffd max_arch_pfn = 0x100000
> [    0.000000] Scan SMP from c0000000 for 1024 bytes.
> [    0.000000] Scan SMP from c009fc00 for 1024 bytes.
> [    0.000000] Scan SMP from c00f0000 for 65536 bytes.
> [    0.000000] found SMP MP-table at [c00f8860] f8860
> [    0.000000]   mpc: f8870-f898c
> [    0.000000] initial memory mapped : 0 - 02000000
> [    0.000000] Base memory trampoline at [c009e000] 9e000 size 4096
> [    0.000000] init_memory_mapping: 0000000000000000-000000000fffd000
> [    0.000000]  0000000000 - 000fffd000 page 4k
> [    0.000000] kernel direct mapping tables up to fffd000 @ 1fbd000-2000000
> [    0.000000] log_buf_len: 8388608
> [    0.000000] early log buf free: 129088(98%)
> [    0.000000] RAMDISK: 0e73f000 - 0fff0000
> [    0.000000] 0MB HIGHMEM available.
> [    0.000000] 255MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 0fffd000
> [    0.000000]   low ram: 0 - 0fffd000
> [    0.000000] kvm-clock: Using msrs 12 and 11
> [    0.000000] kvm-clock: cpu 0, msr 0:15ca6a1, boot clock
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000010 -> 0x00001000
> [    0.000000]   Normal   0x00001000 -> 0x0000fffd
> [    0.000000]   HighMem  empty
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] Early memory PFN ranges
> [    0.000000]     0: 0x00000010 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x0000fffd
> [    0.000000] On node 0 totalpages: 65420
> [    0.000000] free_area_init_node: node 0, pgdat c16207c0, node_mem_map cdcff240
> [    0.000000]   DMA zone: 36 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3947 pages, LIFO batch:0
> [    0.000000]   Normal zone: 540 pages used for memmap
> [    0.000000]   Normal zone: 60897 pages, LIFO batch:15
> [    0.000000] Using APIC driver default
> [    0.000000] SFI: Simple Firmware Interface v0.81 http://simplefirmware.org
> [    0.000000] Intel MultiProcessor Specification v1.4
> [    0.000000]     Virtual Wire compatibility mode.
> [    0.000000]   mpc: f8870-f898c
> [    0.000000] MPTABLE: OEM ID: BOCHSCPU
> [    0.000000] MPTABLE: Product ID: 0.1         
> [    0.000000] MPTABLE: APIC at: 0xFEE00000
> [    0.000000] mapped APIC to         ffffb000 (        fee00000)
> [    0.000000] Processor #0 (Bootup-CPU)
> [    0.000000] Processor #1
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
> [    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
> [    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 01
> [    0.000000] Processors: 1
> [    0.000000] Allocating PCI resources starting at 10000000 (gap: 10000000:effbc000)
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
> [    0.000000] pcpu-alloc: [0] 0 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64844
> [    0.000000] Kernel command line: trinity=10m tree=media:v4l_for_linus auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-07-13-14-57-43-drm-media.v4l_for_linus-ec3ed85-82163ed-i386-randconfig-drm4-1-bens BOOT_IMAGE=kernel-tests/kernels/i386-randconfig-drm4/82163edcdfa4eb3d74516cc8e9f38dd3d039b67d/vmlinuz-3.4.0-rc7-00656-g82163ed
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Initializing HighMem for node 0 (00000000:00000000)
> [    0.000000] Memory: 213712k/262132k available (4009k kernel code, 47968k reserved, 2408k data, 316k init, 0k highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xfffe3000 - 0xfffff000   ( 112 kB)
> [    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
> [    0.000000]     vmalloc : 0xd07fd000 - 0xff7fe000   ( 752 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xcfffd000   ( 255 MB)
> [    0.000000]       .init : 0xc1645000 - 0xc1694000   ( 316 kB)
> [    0.000000]       .data : 0xc13ea79e - 0xc1644840   (2408 kB)
> [    0.000000]       .text : 0xc1000000 - 0xc13ea79e   (4009 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] NR_IRQS:16 nr_irqs:16 16
> [    0.000000] CPU 0 irqstacks, hard=cd802000 soft=cd804000
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 3551 kB
> [    0.000000]  per task-struct memory footprint: 1152 bytes
> [    0.000000] ODEBUG: 0 of 0 active objects replaced
> [    0.000000] Detected 2666.366 MHz processor.
> [    0.002999] Calibrating delay loop (skipped) preset value.. 5332.73 BogoMIPS (lpj=2666366)
> [    0.004007] pid_max: default: 4096 minimum: 301
> [    0.005059] Security Framework initialized
> [    0.007061] Mount-cache hash table entries: 512
> [    0.009302] mce: CPU supports 10 MCE banks
> [    0.010007] MCE: unknown CPU type - not enabling MCE support.
> [    0.012044] CPU: GenuineIntel Common KVM processor stepping 01
> [    0.018332] Performance Events: 
> [    0.020209] NMI watchdog: disabled (cpu0): hardware events not enabled
> [    0.022194] Getting VERSION: 50014
> [    0.023015] Getting VERSION: 50014
> [    0.024015] Getting ID: 0
> [    0.025011] Getting ID: f000000
> [    0.025899] Getting LVT0: 8700
> [    0.026011] Getting LVT1: 8400
> [    0.027143] enabled ExtINT on CPU#0
> [    0.028054] Using local APIC timer interrupts.
> [    0.028056] calibrating APIC timer ...
> [    0.029997] ... lapic delta = 6248958
> [    0.029997] ..... delta 6248958
> [    0.029997] ..... mult: 268431504
> [    0.029997] ..... calibration result: 999833
> [    0.029997] ..... CPU clock speed is 2666.0221 MHz.
> [    0.029997] ..... host bus clock speed is 999.0833 MHz.
> [    0.029997] ... verify APIC timer
> [    0.133601] ... jiffies delta = 100
> [    0.133993] ... jiffies result ok
> [    0.135929] EVM: security.capability
> [    0.138149] xor: automatically using best checksumming function: pIII_sse
> [    0.143989]    pIII_sse  :  7952.000 MB/sec
> [    0.144989] xor: using function: pIII_sse (7952.000 MB/sec)
> [    0.146024] atomic64 test passed for i586+ platform with CX8 and with SSE
> [    0.148246] dummy: 
> [    0.149112] NET: Registered protocol family 16
> [    0.151321] i2c-core: driver [dummy] registered
> [    0.156116] bio: create slab <bio-0> at 0
> [    0.173992] raid6: int32x1    980 MB/s
> [    0.192039] raid6: int32x2    804 MB/s
> [    0.210015] raid6: int32x4    722 MB/s
> [    0.228031] raid6: int32x8    855 MB/s
> [    0.245978] raid6: mmxx1     3371 MB/s
> [    0.263973] raid6: mmxx2     3867 MB/s
> [    0.281982] raid6: sse1x1    1632 MB/s
> [    0.299967] raid6: sse1x2    3519 MB/s
> [    0.317978] raid6: sse2x1    2644 MB/s
> [    0.335967] raid6: sse2x2    6437 MB/s
> [    0.336961] raid6: using algorithm sse2x2 (6437 MB/s)
> [    0.338024] i2c-core: driver [max7300] registered
> [    0.338967] i2c-core: driver [mcp230xx] registered
> [    0.341049] i2c-core: driver [isl6271a] registered
> [    0.341966] i2c-core: driver [lp3972] registered
> [    0.342966] i2c-core: driver [max1586] registered
> [    0.344966] i2c-core: driver [max8649] registered
> [    0.345971] i2c-core: driver [max8952] registered
> [    0.346975] i2c-core: driver [tps62360] registered
> [    0.348965] i2c-core: driver [tps65023] registered
> [    0.349986] i2c-core: driver [88PM860x] registered
> [    0.351018] i2c-core: driver [tc3589x] registered
> [    0.352965] i2c-core: driver [wm8350] registered
> [    0.353964] i2c-core: driver [tps6105x] registered
> [    0.354964] i2c-core: driver [twl] registered
> [    0.355964] i2c-core: driver [da903x] registered
> [    0.357964] i2c-core: driver [da9052] registered
> [    0.358964] i2c-core: driver [max8925] registered
> [    0.359963] i2c-core: driver [max8997] registered
> [    0.360963] i2c-core: driver [pcf50633] registered
> [    0.362964] i2c-core: driver [tps65090] using legacy suspend method
> [    0.364956] i2c-core: driver [tps65090] using legacy resume method
> [    0.365956] i2c-core: driver [tps65090] registered
> [    0.367962] i2c-core: driver [rc5t583] registered
> [    0.369356] SCSI subsystem initialized
> [    0.371037] libata version 3.00 loaded.
> [    0.372395] Advanced Linux Sound Architecture Driver Version 1.0.25.
> [    0.374617] Switching to clocksource kvm-clock
> [    0.376598] Warning: could not register annotated branches stats
> [    0.455401] FS-Cache: Loaded
> [    0.456301] CacheFiles: Loaded
> [    0.458367] NET: Registered protocol family 1
> [    0.463527] Trying to unpack rootfs image as initramfs...
> [    7.126084] debug: unmapping init memory ce73f000..cfff0000
> [    7.131999] platform rtc_cmos: registered platform RTC device (no PNP device found)
> [    7.134084] Machine check injector initialized
> [    7.135326] microcode: no support for this CPU vendor
> [    7.137719] The force parameter has not been set to 1 so the Iris poweroff handler will not be installed.
> [    7.140405] NatSemi SCx200 Driver
> [    7.144706] Initializing RT-Tester: OK
> [    7.146361] HugeTLB registered 4 MB page size, pre-allocated 0 pages
> [    7.150735] squashfs: version 4.0 (2009/01/31) Phillip Lougher
> [    7.152532] NTFS driver 2.1.30 [Flags: R/O].
> [    7.153703] QNX4 filesystem 0.2.3 registered.
> [    7.154892] msgmni has been set to 417
> [    7.168372] io scheduler noop registered
> [    7.169454] io scheduler deadline registered (default)
> [    7.170977] start plist test
> [    7.175537] end plist test
> [    7.177916] crc32: CRC_LE_BITS = 8, CRC_BE BITS = 8
> [    7.179242] crc32: self tests passed, processed 225944 bytes in 617169 nsec
> [    7.181679] crc32c: CRC_LE_BITS = 8
> [    7.182626] crc32c: self tests passed, processed 225944 bytes in 279590 nsec
> [    7.209420] xz_dec_test: module loaded
> [    7.210445] xz_dec_test: Create a device node with 'mknod xz_dec_test c 254 0' and write .xz files to it.
> [    7.213201] r3964: Philips r3964 Driver $Revision: 1.10 $
> [    7.214784] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    7.241566] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    7.243780] lp: driver loaded but no devices found
> [    7.245168] Real Time Clock Driver v1.12b
> [    7.246302] Non-volatile memory driver v1.3
> [    7.247425] toshiba: not a supported Toshiba laptop
> [    7.248736] scx200_gpio: no SCx200 gpio present
> [    7.249973] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
> [    7.251922] platform pc8736x_gpio.0: no device found
> [    7.253317] nsc_gpio initializing
> [    7.254216] ipmi message handler version 39.2
> [    7.255433] IPMI System Interface driver.
> [    7.256557] ipmi_si: Adding default-specified kcs state machine
> [    7.258271] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
> [    7.261095] ipmi_si: Interface detection failed
> [    7.262349] ipmi_si: Adding default-specified smic state machine
> [    7.263990] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
> [    7.266691] ipmi_si: Interface detection failed
> [    7.267917] ipmi_si: Adding default-specified bt state machine
> [    7.269572] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
> [    7.272297] ipmi_si: Interface detection failed
> [    7.273558] ipmi_si: Unable to find any System Interface(s)
> [    7.275050] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
> [    7.277122] IPMI poweroff: Unable to register powercycle sysctl
> [    7.278765] [drm] Initialized drm 1.1.0 20060810
> [    7.280725] parport0: PC-style at 0x378 [PCSPP(,...)]
> [    7.282429] parport0: irq 0 detected
> [    7.283560] lp0: using parport0 (polling).
> [    7.284705] lp0: console ready
> [    7.288893] brd: module loaded
> [    7.289848] i2c-core: driver [bmp085] registered
> [    7.291121] i2c-core: driver [bh1780] registered
> [    7.292389] i2c-core: driver [at24] registered
> [    7.293604] Uniform Multi-Platform E-IDE driver
> [    7.295425] ide-gd driver 1.18
> [    7.296467] st: Version 20101219, fixed bufsize 32768, s/g segs 256
> [    7.300032] parport0: cannot grant exclusive access for device ks0108
> [    7.301785] ks0108: ERROR: parport didn't register new device
> [    7.304523] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    7.305915] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    7.423594] mousedev: PS/2 mouse device common for all mice
> [    7.425899] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> [    7.428610] i2c-core: driver [bma150] registered
> [    7.429905] i2c-core: driver [gp2ap002a00f] registered
> [    7.431375] input: PC Speaker as /devices/platform/pcspkr/input/input1
> [    7.433137] wistron_btns: System unknown
> [    7.434221] i2c-core: driver [smbus_alert] registered
> [    7.435611] i2c-parport: adapter type unspecified
> [    7.436883] i2c-parport-light: adapter type unspecified
> [    7.438316] scx200_i2c: NatSemi SCx200 I2C Driver
> [    7.439599] scx200_i2c: no SCx200 gpio pins available
> [    7.441233] lirc_dev: IR Remote Control driver registered, major 252 
> [    7.443001] IR NEC protocol handler initialized
> [    7.444227] IR RC6 protocol handler initialized
> [    7.445480] IR JVC protocol handler initialized
> [    7.446699] IR Sony protocol handler initialized
> [    7.447939] IR SANYO protocol handler initialized
> [    7.449204] IR MCE Keyboard/mouse protocol handler initialized
> [    7.450814] Driver for 1-wire Dallas network protocol.
> [    7.452276] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
> [    7.454019] power_supply test_ac: power_supply_changed
> [    7.455501] power_supply test_ac: power_supply_changed_work
> [    7.457020] power_supply test_ac: power_supply_update_gen_leds 1
> [    7.458705] power_supply test_battery: power_supply_changed
> [    7.460205] power_supply test_battery: power_supply_changed_work
> [    7.461847] power_supply test_battery: power_supply_update_bat_leds 2
> [    7.463613] i2c-core: driver [ds2782-battery] registered
> [    7.465058] i2c-core: driver [bq27x00-battery] registered
> [    7.466576] md: raid0 personality registered for level 0
> [    7.468007] md: raid1 personality registered for level 1
> [    7.469487] md: raid10 personality registered for level 10
> [    7.471016] md: raid6 personality registered for level 6
> [    7.472451] md: raid5 personality registered for level 5
> [    7.473884] md: raid4 personality registered for level 4
> [    7.475342] md: faulty personality registered for level -5
> [    7.476872] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
> [    7.479886] device-mapper: multipath: version 1.3.0 loaded
> [    7.481435] device-mapper: multipath round-robin: version 1.0.0 loaded
> [    7.483182] device-mapper: multipath queue-length: version 0.1.0 loaded
> [    7.484978] device-mapper: multipath service-time: version 0.2.0 loaded
> [    7.487226] i2c-core: driver [lm3530-led] registered
> [    7.488616] i2c-core: driver [lp3944] registered
> [    7.489873] i2c-core: driver [lp5521] registered
> [    7.491139] i2c-core: driver [lp5523] registered
> [    7.492423] i2c-core: driver [leds-tca6507] registered
> [    7.493828] i2c-core: driver [leds-pca9633] registered
> [    7.495284] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> [    7.592114] Panel driver version 0.9.5 registered on parport0 (io=0x378).
> [    7.593979] i2c-core: driver [synaptics_rmi4_i2c] registered
> [    7.595930] ALSA mtpav.c:589 MTVAP port 0x378 is busy
> [    7.597371] snd_mtpav: probe of snd_mtpav failed with error -16
> [    7.599039] snd_mts64: probe of snd_mts64.0 failed with error -5
> [    7.600735] ALSA mpu401.c:110 specify port
> [    7.601861] snd_mpu401: probe of snd_mpu401.0 failed with error -22
> [    7.604086] Using IPI Shortcut mode
> [    7.607750] EVM: Error registering secfs
> [    7.609992] i2c-core: driver [wl1273-fm] registered
> [    7.611314] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [    7.613048] EDD information not available.
> [    7.614820] ALSA device list:
> [    7.615664]   No soundcards found.
> [    7.618015] debug: unmapping init memory c1645000..c1694000
> [    7.620129] Write protecting the kernel text: 4012k
> [    7.621742] Write protecting the kernel read-only data: 1868k
> libudev: udev_monitor_new_from_netlink_fd: error getting socket: Protocol not supported
> mountall:mountall.c:3801: Assertion failed in main: udev_monitor = udev_monitor_new_from_netlink (udev, "udev")
> General error mounting filesystems.
> A maintenance shell will now be started.
> CONTROL-D will terminate this shell and reboot the system.
> wfg: rebooting
> [    8.232324] BUG: spinlock trylock failure on UP on CPU#0, reboot/85
> [    8.234138]  lock: c161c760, .magic: dead4ead, .owner: reboot/85, .owner_cpu: 0
> [    8.236132] Pid: 85, comm: reboot Not tainted 3.4.0-rc7-00656-g82163ed #5
> [    8.237965] Call Trace:
> [    8.238648]  [<c13dfd20>] ? printk+0x18/0x1a
> [    8.239827]  [<c122a5e0>] spin_dump+0x80/0xd0
> [    8.241016]  [<c122a652>] spin_bug+0x22/0x30
> [    8.242181]  [<c122a93b>] do_raw_spin_trylock+0x5b/0x70
> [    8.243611]  [<c13e8bae>] _raw_spin_trylock+0xe/0x60
> [    8.244975]  [<c1392230>] ? keypad_send_key.constprop.9+0xe0/0xe0
> [    8.246638]  [<c13922ea>] panel_scan_timer+0xba/0x570
> [    8.248019]  [<c1392230>] ? keypad_send_key.constprop.9+0xe0/0xe0
> [    8.249689]  [<c102f6f5>] run_timer_softirq+0x1e5/0x370
> [    8.251191]  [<c102f645>] ? run_timer_softirq+0x135/0x370
> [    8.252718]  [<c1392230>] ? keypad_send_key.constprop.9+0xe0/0xe0
> [    8.254462]  [<c102a592>] __do_softirq+0xc2/0x1c0
> [    8.255758]  [<c102a4d0>] ? local_bh_enable_ip+0x130/0x130
> [    8.257228]  <IRQ>  [<c102a855>] ? irq_exit+0x65/0x70
> [    8.258647]  [<c1013ff9>] ? smp_apic_timer_interrupt+0x49/0x80
> [    8.260226]  [<c13e96c1>] ? apic_timer_interrupt+0x31/0x38
> [    8.261737]  [<c12700e0>] ? drm_vm_open_locked+0x70/0xb0
> [    8.263166]  [<c122489a>] ? delay_tsc+0x1a/0x30
> [    8.264452]  [<c12248c9>] ? __delay+0x9/0x10
> [    8.265621]  [<c12248ec>] ? __const_udelay+0x1c/0x20
> [    8.266967]  [<c139136c>] ? lcd_clear_fast_p8+0x9c/0xe0
> [    8.268386]  [<c1391a66>] ? lcd_write+0x226/0x810
> [    8.269653]  [<c1367900>] ? md_set_readonly+0xc0/0xc0
> [    8.271013]  [<c122a9ed>] ? do_raw_spin_unlock+0x9d/0xe0
> [    8.272470]  [<c1392a98>] ? panel_lcd_print+0x38/0x40
> [    8.273837]  [<c1392ace>] ? panel_notify_sys+0x2e/0x60
> [    8.275224]  [<c1046634>] ? notifier_call_chain+0x84/0xb0
> [    8.276754]  [<c10469ce>] ? __blocking_notifier_call_chain+0x3e/0x60
> [    8.278576]  [<c1046a0a>] ? blocking_notifier_call_chain+0x1a/0x20
> [    8.280267]  [<c1036a14>] ? kernel_restart_prepare+0x14/0x40
> [    8.281901]  [<c1036a8e>] ? kernel_restart+0xe/0x50
> [    8.283216]  [<c1036ce9>] ? sys_reboot+0x149/0x1e0
> [    8.284532]  [<c10b3fb3>] ? handle_pte_fault+0x93/0xd70
> [    8.285956]  [<c1019e35>] ? do_page_fault+0x215/0x5e0
> [    8.287330]  [<c101a113>] ? do_page_fault+0x4f3/0x5e0
> [    8.288704]  [<c1045ac6>] ? up_read+0x16/0x30
> [    8.289890]  [<c101a113>] ? do_page_fault+0x4f3/0x5e0
> [    8.291252]  [<c10d4486>] ? iterate_supers+0x86/0xd0
> [    8.292615]  [<c122a9ed>] ? do_raw_spin_unlock+0x9d/0xe0
> [    8.294049]  [<c13e8dcd>] ? _raw_spin_unlock+0x1d/0x20
> [    8.295449]  [<c10d44ab>] ? iterate_supers+0xab/0xd0
> [    8.296795]  [<c10fb620>] ? __sync_filesystem+0xa0/0xa0
> [    8.298199]  [<c13e9b03>] ? sysenter_do_call+0x12/0x37
> [    8.306899] Restarting system.
> [    8.307747] machine restart

> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/i386 3.4.0-rc7 Kernel Configuration
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> # CONFIG_X86_64 is not set
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf32-i386"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
> # CONFIG_NEED_DMA_MAP_STATE is not set
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_GENERIC_GPIO=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> # CONFIG_RWSEM_GENERIC_SPINLOCK is not set
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> # CONFIG_GENERIC_TIME_VSYSCALL is not set
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_DEFAULT_IDLE=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> # CONFIG_ZONE_DMA32 is not set
> # CONFIG_AUDIT_ARCH is not set
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
> CONFIG_KTIME_SCALAR=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_HAVE_IRQ_WORK=y
> CONFIG_IRQ_WORK=y
> 
> #
> # General setup
> #
> # CONFIG_EXPERIMENTAL is not set
> CONFIG_BROKEN_ON_SMP=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> # CONFIG_KERNEL_GZIP is not set
> # CONFIG_KERNEL_BZIP2 is not set
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> CONFIG_KERNEL_LZO=y
> CONFIG_DEFAULT_HOSTNAME="(none)"
> # CONFIG_SWAP is not set
> CONFIG_SYSVIPC=y
> # CONFIG_BSD_PROCESS_ACCT is not set
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
> CONFIG_IRQ_DOMAIN=y
> CONFIG_IRQ_DOMAIN_DEBUG=y
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> 
> #
> # RCU Subsystem
> #
> CONFIG_TINY_RCU=y
> # CONFIG_PREEMPT_RCU is not set
> # CONFIG_TREE_RCU_TRACE is not set
> CONFIG_IKCONFIG=y
> # CONFIG_IKCONFIG_PROC is not set
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> # CONFIG_CGROUPS is not set
> CONFIG_CHECKPOINT_RESTORE=y
> # CONFIG_NAMESPACES is not set
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_SYSFS_DEPRECATED is not set
> CONFIG_RELAY=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> # CONFIG_RD_BZIP2 is not set
> # CONFIG_RD_LZMA is not set
> # CONFIG_RD_XZ is not set
> # CONFIG_RD_LZO is not set
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_ANON_INODES=y
> CONFIG_EXPERT=y
> CONFIG_UID16=y
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> # CONFIG_HOTPLUG is not set
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> # CONFIG_BASE_FULL is not set
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> # CONFIG_SIGNALFD is not set
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> # CONFIG_SHMEM is not set
> # CONFIG_AIO is not set
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_PERF_COUNTERS is not set
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> # CONFIG_VM_EVENT_COUNTERS is not set
> CONFIG_COMPAT_BRK=y
> # CONFIG_SLAB is not set
> # CONFIG_SLUB is not set
> CONFIG_SLOB=y
> CONFIG_PROFILING=y
> CONFIG_TRACEPOINTS=y
> # CONFIG_OPROFILE is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> # CONFIG_JUMP_LABEL is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> 
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_GCOV_KERNEL is not set
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=1
> # CONFIG_MODULES is not set
> CONFIG_BLOCK=y
> # CONFIG_LBDAF is not set
> # CONFIG_BLK_DEV_BSG is not set
> # CONFIG_BLK_DEV_BSGLIB is not set
> # CONFIG_BLK_DEV_INTEGRITY is not set
> 
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> # CONFIG_ACORN_PARTITION is not set
> CONFIG_OSF_PARTITION=y
> CONFIG_AMIGA_PARTITION=y
> CONFIG_ATARI_PARTITION=y
> CONFIG_MAC_PARTITION=y
> CONFIG_MSDOS_PARTITION=y
> # CONFIG_BSD_DISKLABEL is not set
> # CONFIG_MINIX_SUBPARTITION is not set
> # CONFIG_SOLARIS_X86_PARTITION is not set
> CONFIG_UNIXWARE_DISKLABEL=y
> CONFIG_LDM_PARTITION=y
> CONFIG_LDM_DEBUG=y
> CONFIG_SGI_PARTITION=y
> # CONFIG_ULTRIX_PARTITION is not set
> # CONFIG_SUN_PARTITION is not set
> CONFIG_KARMA_PARTITION=y
> # CONFIG_EFI_PARTITION is not set
> # CONFIG_SYSV68_PARTITION is not set
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=y
> # CONFIG_IOSCHED_CFQ is not set
> CONFIG_DEFAULT_DEADLINE=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="deadline"
> # CONFIG_INLINE_SPIN_TRYLOCK is not set
> # CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK is not set
> # CONFIG_INLINE_SPIN_LOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQ is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> # CONFIG_INLINE_SPIN_UNLOCK_BH is not set
> # CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
> # CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_READ_TRYLOCK is not set
> # CONFIG_INLINE_READ_LOCK is not set
> # CONFIG_INLINE_READ_LOCK_BH is not set
> # CONFIG_INLINE_READ_LOCK_IRQ is not set
> # CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
> # CONFIG_INLINE_READ_UNLOCK is not set
> # CONFIG_INLINE_READ_UNLOCK_BH is not set
> # CONFIG_INLINE_READ_UNLOCK_IRQ is not set
> # CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_WRITE_TRYLOCK is not set
> # CONFIG_INLINE_WRITE_LOCK is not set
> # CONFIG_INLINE_WRITE_LOCK_BH is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQ is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
> # CONFIG_INLINE_WRITE_UNLOCK is not set
> # CONFIG_INLINE_WRITE_UNLOCK_BH is not set
> # CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
> # CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
> # CONFIG_MUTEX_SPIN_ON_OWNER is not set
> CONFIG_FREEZER=y
> 
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> # CONFIG_NO_HZ is not set
> # CONFIG_HIGH_RES_TIMERS is not set
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> # CONFIG_SMP is not set
> CONFIG_X86_MPPARSE=y
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
> CONFIG_X86_32_IRIS=y
> CONFIG_SCHED_OMIT_FRAME_POINTER=y
> CONFIG_PARAVIRT_GUEST=y
> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
> # CONFIG_XEN_PRIVILEGED_GUEST is not set
> CONFIG_KVM_CLOCK=y
> CONFIG_KVM_GUEST=y
> # CONFIG_LGUEST_GUEST is not set
> CONFIG_PARAVIRT=y
> CONFIG_PARAVIRT_CLOCK=y
> # CONFIG_PARAVIRT_DEBUG is not set
> CONFIG_NO_BOOTMEM=y
> CONFIG_MEMTEST=y
> # CONFIG_M386 is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> CONFIG_M686=y
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MPENTIUM4 is not set
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MELAN is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MATOM is not set
> # CONFIG_X86_GENERIC is not set
> CONFIG_X86_INTERNODE_CACHE_SHIFT=5
> CONFIG_X86_CMPXCHG=y
> CONFIG_X86_L1_CACHE_SHIFT=5
> CONFIG_X86_XADD=y
> CONFIG_X86_PPRO_FENCE=y
> CONFIG_X86_WP_WORKS_OK=y
> CONFIG_X86_INVLPG=y
> CONFIG_X86_BSWAP=y
> CONFIG_X86_POPAD_OK=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=5
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_PROCESSOR_SELECT=y
> # CONFIG_CPU_SUP_INTEL is not set
> CONFIG_CPU_SUP_CYRIX_32=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> # CONFIG_CPU_SUP_TRANSMETA_32 is not set
> CONFIG_CPU_SUP_UMC_32=y
> # CONFIG_HPET_TIMER is not set
> # CONFIG_DMI is not set
> # CONFIG_IOMMU_HELPER is not set
> CONFIG_NR_CPUS=1
> CONFIG_IRQ_TIME_ACCOUNTING=y
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=y
> # CONFIG_PREEMPT is not set
> CONFIG_X86_UP_APIC=y
> # CONFIG_X86_UP_IOAPIC is not set
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_MCE=y
> # CONFIG_X86_MCE_INTEL is not set
> # CONFIG_X86_MCE_AMD is not set
> CONFIG_X86_ANCIENT_MCE=y
> CONFIG_X86_MCE_INJECT=y
> CONFIG_VM86=y
> CONFIG_TOSHIBA=y
> # CONFIG_I8K is not set
> # CONFIG_X86_REBOOTFIXUPS is not set
> CONFIG_MICROCODE=y
> # CONFIG_MICROCODE_INTEL is not set
> CONFIG_MICROCODE_AMD=y
> CONFIG_MICROCODE_OLD_INTERFACE=y
> # CONFIG_X86_MSR is not set
> # CONFIG_X86_CPUID is not set
> # CONFIG_NOHIGHMEM is not set
> CONFIG_HIGHMEM4G=y
> # CONFIG_HIGHMEM64G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_HIGHMEM=y
> # CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
> # CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ILLEGAL_POINTER_VALUE=0
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=999999
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> # CONFIG_PHYS_ADDR_T_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
> CONFIG_MEMORY_FAILURE=y
> # CONFIG_HWPOISON_INJECT is not set
> CONFIG_TRANSPARENT_HUGEPAGE=y
> # CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
> CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
> CONFIG_NEED_PER_CPU_KM=y
> # CONFIG_CLEANCACHE is not set
> # CONFIG_HIGHPTE is not set
> CONFIG_X86_CHECK_BIOS_CORRUPTION=y
> # CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
> CONFIG_X86_RESERVE_LOW=64
> # CONFIG_MATH_EMULATION is not set
> # CONFIG_MTRR is not set
> CONFIG_ARCH_RANDOM=y
> # CONFIG_SECCOMP is not set
> CONFIG_CC_STACKPROTECTOR=y
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> CONFIG_HZ_1000=y
> CONFIG_HZ=1000
> # CONFIG_SCHED_HRTICK is not set
> CONFIG_KEXEC=y
> CONFIG_CRASH_DUMP=y
> CONFIG_PHYSICAL_START=0x1000000
> # CONFIG_RELOCATABLE is not set
> CONFIG_PHYSICAL_ALIGN=0x1000000
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> 
> #
> # Power management and ACPI options
> #
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_PM_SLEEP=y
> # CONFIG_PM_RUNTIME is not set
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> CONFIG_SFI=y
> # CONFIG_APM is not set
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_TABLE=y
> CONFIG_CPU_FREQ_STAT=y
> CONFIG_CPU_FREQ_STAT_DETAILS=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> # CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
> CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> CONFIG_CPU_FREQ_GOV_USERSPACE=y
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
> 
> #
> # x86 CPU frequency scaling drivers
> #
> CONFIG_X86_POWERNOW_K6=y
> CONFIG_X86_POWERNOW_K7=y
> # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
> # CONFIG_X86_SPEEDSTEP_ICH is not set
> # CONFIG_X86_P4_CLOCKMOD is not set
> CONFIG_X86_LONGRUN=y
> 
> #
> # shared options
> #
> # CONFIG_X86_SPEEDSTEP_LIB is not set
> # CONFIG_CPU_IDLE is not set
> 
> #
> # Bus options (PCI etc.)
> #
> # CONFIG_PCI is not set
> # CONFIG_ARCH_SUPPORTS_MSI is not set
> CONFIG_ISA_DMA_API=y
> # CONFIG_ISA is not set
> # CONFIG_MCA is not set
> CONFIG_SCx200=y
> # CONFIG_SCx200HR_TIMER is not set
> # CONFIG_OLPC is not set
> CONFIG_ALIX=y
> CONFIG_NET5501=y
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
> CONFIG_HAVE_AOUT=y
> # CONFIG_BINFMT_AOUT is not set
> CONFIG_BINFMT_MISC=y
> CONFIG_HAVE_ATOMIC_IOMAP=y
> CONFIG_HAVE_TEXT_POKE_SMP=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> # CONFIG_PACKET is not set
> CONFIG_UNIX=y
> # CONFIG_UNIX_DIAG is not set
> # CONFIG_NET_KEY is not set
> # CONFIG_INET is not set
> # CONFIG_NETWORK_SECMARK is not set
> # CONFIG_NETFILTER is not set
> # CONFIG_ATM is not set
> # CONFIG_BRIDGE is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_PHONET is not set
> # CONFIG_NET_SCHED is not set
> # CONFIG_DCB is not set
> # CONFIG_DNS_RESOLVER is not set
> # CONFIG_BATMAN_ADV is not set
> # CONFIG_OPENVSWITCH is not set
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
> CONFIG_WIRELESS=y
> # CONFIG_CFG80211 is not set
> # CONFIG_LIB80211 is not set
> 
> #
> # CFG80211 needs to be enabled for MAC80211
> #
> # CONFIG_WIMAX is not set
> # CONFIG_RFKILL is not set
> # CONFIG_RFKILL_REGULATOR is not set
> # CONFIG_NET_9P is not set
> # CONFIG_CAIF is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=y
> CONFIG_REGMAP_IRQ=y
> CONFIG_DMA_SHARED_BUFFER=y
> # CONFIG_CONNECTOR is not set
> # CONFIG_MTD is not set
> CONFIG_PARPORT=y
> CONFIG_PARPORT_PC=y
> # CONFIG_PARPORT_GSC is not set
> CONFIG_PARPORT_AX88796=y
> # CONFIG_PARPORT_1284 is not set
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_DEV_FD is not set
> # CONFIG_PARIDE is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> # CONFIG_BLK_DEV_LOOP is not set
> 
> #
> # DRBD disabled because PROC_FS, INET or CONNECTOR not selected
> #
> # CONFIG_BLK_DEV_NBD is not set
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=4096
> CONFIG_BLK_DEV_XIP=y
> CONFIG_CDROM_PKTCDVD=y
> CONFIG_CDROM_PKTCDVD_BUFFERS=8
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_BLK_DEV_HD is not set
> 
> #
> # Misc devices
> #
> # CONFIG_SENSORS_LIS3LV02D is not set
> CONFIG_AD525X_DPOT=y
> # CONFIG_AD525X_DPOT_I2C is not set
> # CONFIG_ENCLOSURE_SERVICES is not set
> # CONFIG_APDS9802ALS is not set
> # CONFIG_ISL29003 is not set
> # CONFIG_ISL29020 is not set
> # CONFIG_SENSORS_TSL2550 is not set
> CONFIG_SENSORS_BH1780=y
> # CONFIG_SENSORS_BH1770 is not set
> # CONFIG_SENSORS_APDS990X is not set
> # CONFIG_HMC6352 is not set
> # CONFIG_VMWARE_BALLOON is not set
> CONFIG_BMP085=y
> # CONFIG_USB_SWITCH_FSA9480 is not set
> # CONFIG_MAX8997_MUIC is not set
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=y
> # CONFIG_EEPROM_LEGACY is not set
> # CONFIG_EEPROM_93CX6 is not set
> 
> #
> # Texas Instruments shared transport line discipline
> #
> # CONFIG_TI_ST is not set
> # CONFIG_SENSORS_LIS3_I2C is not set
> 
> #
> # Altera FPGA firmware download module
> #
> # CONFIG_ALTERA_STAPL is not set
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=y
> 
> #
> # Please see Documentation/ide/ide.txt for help/info on IDE drives
> #
> CONFIG_IDE_XFER_MODE=y
> CONFIG_IDE_TIMINGS=y
> CONFIG_IDE_ATAPI=y
> CONFIG_BLK_DEV_IDE_SATA=y
> CONFIG_IDE_GD=y
> CONFIG_IDE_GD_ATA=y
> # CONFIG_IDE_GD_ATAPI is not set
> # CONFIG_BLK_DEV_IDECD is not set
> CONFIG_BLK_DEV_IDETAPE=y
> # CONFIG_IDE_TASK_IOCTL is not set
> # CONFIG_IDE_PROC_FS is not set
> 
> #
> # IDE chipset support/bugfixes
> #
> # CONFIG_IDE_GENERIC is not set
> # CONFIG_BLK_DEV_PLATFORM is not set
> CONFIG_BLK_DEV_CMD640=y
> # CONFIG_BLK_DEV_CMD640_ENHANCED is not set
> # CONFIG_BLK_DEV_IDEDMA is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> CONFIG_RAID_ATTRS=y
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> # CONFIG_SCSI_NETLINK is not set
> # CONFIG_SCSI_PROC_FS is not set
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> # CONFIG_BLK_DEV_SD is not set
> CONFIG_CHR_DEV_ST=y
> # CONFIG_CHR_DEV_OSST is not set
> CONFIG_BLK_DEV_SR=y
> # CONFIG_BLK_DEV_SR_VENDOR is not set
> # CONFIG_CHR_DEV_SG is not set
> # CONFIG_CHR_DEV_SCH is not set
> # CONFIG_SCSI_MULTI_LUN is not set
> CONFIG_SCSI_CONSTANTS=y
> CONFIG_SCSI_LOGGING=y
> # CONFIG_SCSI_SCAN_ASYNC is not set
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=y
> # CONFIG_SCSI_FC_ATTRS is not set
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> # CONFIG_SCSI_SAS_ATTRS is not set
> # CONFIG_SCSI_SAS_LIBSAS is not set
> # CONFIG_SCSI_SRP_ATTRS is not set
> # CONFIG_SCSI_LOWLEVEL is not set
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
> # CONFIG_SATA_AHCI_PLATFORM is not set
> CONFIG_ATA_SFF=y
> 
> #
> # SFF controllers with custom DMA interface
> #
> CONFIG_ATA_BMDMA=y
> 
> #
> # SATA SFF controllers with BMDMA
> #
> # CONFIG_SATA_MV is not set
> 
> #
> # PATA SFF controllers with BMDMA
> #
> 
> #
> # PIO-only SFF controllers
> #
> CONFIG_PATA_PLATFORM=y
> 
> #
> # Generic fallback / legacy drivers
> #
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=y
> CONFIG_MD_AUTODETECT=y
> # CONFIG_MD_LINEAR is not set
> CONFIG_MD_RAID0=y
> CONFIG_MD_RAID1=y
> CONFIG_MD_RAID10=y
> CONFIG_MD_RAID456=y
> # CONFIG_MD_MULTIPATH is not set
> CONFIG_MD_FAULTY=y
> CONFIG_BLK_DEV_DM=y
> # CONFIG_DM_DEBUG is not set
> # CONFIG_DM_CRYPT is not set
> # CONFIG_DM_SNAPSHOT is not set
> # CONFIG_DM_MIRROR is not set
> CONFIG_DM_RAID=y
> # CONFIG_DM_ZERO is not set
> CONFIG_DM_MULTIPATH=y
> CONFIG_DM_MULTIPATH_QL=y
> CONFIG_DM_MULTIPATH_ST=y
> # CONFIG_DM_UEVENT is not set
> CONFIG_TARGET_CORE=y
> CONFIG_TCM_IBLOCK=y
> CONFIG_TCM_FILEIO=y
> CONFIG_TCM_PSCSI=y
> # CONFIG_LOOPBACK_TARGET is not set
> # CONFIG_ISCSI_TARGET is not set
> CONFIG_MACINTOSH_DRIVERS=y
> # CONFIG_NETDEVICES is not set
> # CONFIG_ISDN is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=y
> CONFIG_INPUT_POLLDEV=y
> CONFIG_INPUT_SPARSEKMAP=y
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> CONFIG_INPUT_JOYDEV=y
> # CONFIG_INPUT_EVDEV is not set
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
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_GPIO is not set
> # CONFIG_KEYBOARD_GPIO_POLLED is not set
> # CONFIG_KEYBOARD_TCA6416 is not set
> # CONFIG_KEYBOARD_TCA8418 is not set
> # CONFIG_KEYBOARD_MATRIX is not set
> # CONFIG_KEYBOARD_LM8323 is not set
> # CONFIG_KEYBOARD_MAX7359 is not set
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_MPR121 is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_OPENCORES is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_OMAP4 is not set
> # CONFIG_KEYBOARD_TC3589X is not set
> # CONFIG_KEYBOARD_TWL4030 is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_INPUT_MOUSE is not set
> # CONFIG_INPUT_JOYSTICK is not set
> CONFIG_INPUT_TABLET=y
> # CONFIG_INPUT_TOUCHSCREEN is not set
> CONFIG_INPUT_MISC=y
> CONFIG_INPUT_88PM860X_ONKEY=y
> CONFIG_INPUT_AD714X=y
> # CONFIG_INPUT_AD714X_I2C is not set
> CONFIG_INPUT_BMA150=y
> CONFIG_INPUT_PCSPKR=y
> CONFIG_INPUT_MAX8925_ONKEY=y
> # CONFIG_INPUT_MMA8450 is not set
> # CONFIG_INPUT_MPU3050 is not set
> # CONFIG_INPUT_APANEL is not set
> CONFIG_INPUT_GP2A=y
> # CONFIG_INPUT_GPIO_TILT_POLLED is not set
> CONFIG_INPUT_WISTRON_BTNS=y
> # CONFIG_INPUT_KXTJ9 is not set
> # CONFIG_INPUT_TWL4030_PWRBUTTON is not set
> # CONFIG_INPUT_TWL4030_VIBRA is not set
> # CONFIG_INPUT_UINPUT is not set
> CONFIG_INPUT_PCF50633_PMU=y
> CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
> # CONFIG_INPUT_DA9052_ONKEY is not set
> # CONFIG_INPUT_ADXL34X is not set
> # CONFIG_INPUT_CMA3000 is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> # CONFIG_SERIO_CT82C710 is not set
> # CONFIG_SERIO_PARKBD is not set
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> # CONFIG_SERIO_ALTERA_PS2 is not set
> # CONFIG_SERIO_PS2MULT is not set
> CONFIG_GAMEPORT=y
> CONFIG_GAMEPORT_NS558=y
> # CONFIG_GAMEPORT_L4 is not set
> 
> #
> # Character devices
> #
> # CONFIG_VT is not set
> CONFIG_UNIX98_PTYS=y
> CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
> # CONFIG_LEGACY_PTYS is not set
> CONFIG_SERIAL_NONSTANDARD=y
> # CONFIG_N_HDLC is not set
> CONFIG_TRACE_ROUTER=y
> CONFIG_TRACE_SINK=y
> # CONFIG_DEVKMEM is not set
> CONFIG_STALDRV=y
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> # CONFIG_SERIAL_8250_EXTENDED is not set
> 
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_TIMBERDALE is not set
> CONFIG_SERIAL_ALTERA_JTAGUART=y
> # CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> CONFIG_SERIAL_XILINX_PS_UART=y
> # CONFIG_SERIAL_XILINX_PS_UART_CONSOLE is not set
> # CONFIG_TTY_PRINTK is not set
> CONFIG_PRINTER=y
> CONFIG_LP_CONSOLE=y
> # CONFIG_PPDEV is not set
> CONFIG_IPMI_HANDLER=y
> # CONFIG_IPMI_PANIC_EVENT is not set
> # CONFIG_IPMI_DEVICE_INTERFACE is not set
> CONFIG_IPMI_SI=y
> # CONFIG_IPMI_WATCHDOG is not set
> CONFIG_IPMI_POWEROFF=y
> CONFIG_HW_RANDOM=y
> CONFIG_HW_RANDOM_TIMERIOMEM=y
> CONFIG_HW_RANDOM_VIA=y
> CONFIG_NVRAM=y
> CONFIG_RTC=y
> CONFIG_R3964=y
> # CONFIG_MWAVE is not set
> CONFIG_SCx200_GPIO=y
> CONFIG_PC8736x_GPIO=y
> CONFIG_NSC_GPIO=y
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_HANGCHECK_TIMER is not set
> # CONFIG_TCG_TPM is not set
> # CONFIG_RAMOOPS is not set
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> # CONFIG_I2C_COMPAT is not set
> # CONFIG_I2C_CHARDEV is not set
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_SMBUS=y
> CONFIG_I2C_ALGOBIT=y
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> CONFIG_I2C_GPIO=y
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_PXA_PCI is not set
> CONFIG_I2C_SIMTEC=y
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_PARPORT=y
> CONFIG_I2C_PARPORT_LIGHT=y
> 
> #
> # Other I2C/SMBus bus drivers
> #
> CONFIG_SCx200_I2C=y
> CONFIG_SCx200_I2C_SCL=12
> CONFIG_SCx200_I2C_SDA=13
> CONFIG_I2C_DEBUG_CORE=y
> # CONFIG_I2C_DEBUG_ALGO is not set
> CONFIG_I2C_DEBUG_BUS=y
> # CONFIG_SPI is not set
> CONFIG_HSI=y
> CONFIG_HSI_BOARDINFO=y
> 
> #
> # HSI clients
> #
> # CONFIG_HSI_CHAR is not set
> 
> #
> # PPS support
> #
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
> CONFIG_GPIOLIB=y
> CONFIG_DEBUG_GPIO=y
> CONFIG_GPIO_MAX730X=y
> 
> #
> # Memory mapped GPIO drivers:
> #
> # CONFIG_GPIO_GENERIC_PLATFORM is not set
> CONFIG_GPIO_IT8761E=y
> 
> #
> # I2C GPIO expanders:
> #
> CONFIG_GPIO_MAX7300=y
> # CONFIG_GPIO_MAX732X is not set
> # CONFIG_GPIO_PCA953X is not set
> # CONFIG_GPIO_PCF857X is not set
> # CONFIG_GPIO_SX150X is not set
> # CONFIG_GPIO_TC3589X is not set
> CONFIG_GPIO_TWL4030=y
> # CONFIG_GPIO_WM8350 is not set
> # CONFIG_GPIO_ADP5588 is not set
> 
> #
> # PCI GPIO expanders:
> #
> 
> #
> # SPI GPIO expanders:
> #
> CONFIG_GPIO_MCP23S08=y
> 
> #
> # AC97 GPIO expanders:
> #
> 
> #
> # MODULbus GPIO expanders:
> #
> CONFIG_W1=y
> 
> #
> # 1-wire Bus Masters
> #
> CONFIG_W1_MASTER_DS1WM=y
> CONFIG_W1_MASTER_GPIO=y
> 
> #
> # 1-wire Slaves
> #
> # CONFIG_W1_SLAVE_THERM is not set
> # CONFIG_W1_SLAVE_SMEM is not set
> CONFIG_W1_SLAVE_DS2408=y
> CONFIG_W1_SLAVE_DS2423=y
> # CONFIG_W1_SLAVE_DS2431 is not set
> CONFIG_W1_SLAVE_DS2433=y
> CONFIG_W1_SLAVE_DS2433_CRC=y
> # CONFIG_W1_SLAVE_DS2760 is not set
> CONFIG_W1_SLAVE_DS2780=y
> # CONFIG_W1_SLAVE_DS2781 is not set
> CONFIG_W1_SLAVE_BQ27000=y
> CONFIG_POWER_SUPPLY=y
> CONFIG_POWER_SUPPLY_DEBUG=y
> CONFIG_PDA_POWER=y
> # CONFIG_MAX8925_POWER is not set
> # CONFIG_WM8350_POWER is not set
> CONFIG_TEST_POWER=y
> CONFIG_BATTERY_DS2780=y
> # CONFIG_BATTERY_DS2781 is not set
> CONFIG_BATTERY_DS2782=y
> # CONFIG_BATTERY_SBS is not set
> CONFIG_BATTERY_BQ27x00=y
> CONFIG_BATTERY_BQ27X00_I2C=y
> # CONFIG_BATTERY_BQ27X00_PLATFORM is not set
> CONFIG_BATTERY_DA9030=y
> # CONFIG_BATTERY_MAX17040 is not set
> # CONFIG_BATTERY_MAX17042 is not set
> # CONFIG_CHARGER_PCF50633 is not set
> # CONFIG_CHARGER_MAX8903 is not set
> # CONFIG_CHARGER_TWL4030 is not set
> # CONFIG_CHARGER_LP8727 is not set
> CONFIG_CHARGER_GPIO=y
> CONFIG_CHARGER_MAX8997=y
> # CONFIG_CHARGER_SMB347 is not set
> # CONFIG_HWMON is not set
> CONFIG_THERMAL=y
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
> CONFIG_MFD_CORE=y
> CONFIG_MFD_88PM860X=y
> CONFIG_MFD_SM501=y
> # CONFIG_MFD_SM501_GPIO is not set
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_HTC_I2CPLD is not set
> CONFIG_TPS6105X=y
> # CONFIG_TPS65010 is not set
> # CONFIG_TPS6507X is not set
> # CONFIG_MFD_TPS65217 is not set
> # CONFIG_MFD_TPS6586X is not set
> # CONFIG_MFD_TPS65910 is not set
> # CONFIG_MFD_TPS65912_I2C is not set
> CONFIG_TWL4030_CORE=y
> # CONFIG_TWL4030_MADC is not set
> # CONFIG_MFD_TWL4030_AUDIO is not set
> # CONFIG_TWL6030_PWM is not set
> # CONFIG_TWL6040_CORE is not set
> # CONFIG_MFD_STMPE is not set
> CONFIG_MFD_TC3589X=y
> # CONFIG_MFD_TMIO is not set
> CONFIG_PMIC_DA903X=y
> CONFIG_PMIC_DA9052=y
> CONFIG_MFD_DA9052_I2C=y
> # CONFIG_PMIC_ADP5520 is not set
> CONFIG_MFD_MAX8925=y
> CONFIG_MFD_MAX8997=y
> # CONFIG_MFD_MAX8998 is not set
> # CONFIG_MFD_S5M_CORE is not set
> # CONFIG_MFD_WM8400 is not set
> # CONFIG_MFD_WM831X_I2C is not set
> CONFIG_MFD_WM8350=y
> CONFIG_MFD_WM8350_I2C=y
> # CONFIG_MFD_WM8994 is not set
> CONFIG_MFD_PCF50633=y
> # CONFIG_PCF50633_ADC is not set
> CONFIG_PCF50633_GPIO=y
> CONFIG_ABX500_CORE=y
> # CONFIG_AB3100_CORE is not set
> # CONFIG_AB8500_CORE is not set
> CONFIG_MFD_WL1273_CORE=y
> CONFIG_MFD_TPS65090=y
> # CONFIG_MFD_AAT2870_CORE is not set
> CONFIG_MFD_RC5T583=y
> CONFIG_REGULATOR=y
> # CONFIG_REGULATOR_DEBUG is not set
> CONFIG_REGULATOR_DUMMY=y
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> # CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
> # CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
> CONFIG_REGULATOR_GPIO=y
> # CONFIG_REGULATOR_AD5398 is not set
> # CONFIG_REGULATOR_DA903X is not set
> CONFIG_REGULATOR_DA9052=y
> CONFIG_REGULATOR_ISL6271A=y
> CONFIG_REGULATOR_88PM8607=y
> CONFIG_REGULATOR_MAX1586=y
> CONFIG_REGULATOR_MAX8649=y
> # CONFIG_REGULATOR_MAX8660 is not set
> CONFIG_REGULATOR_MAX8925=y
> CONFIG_REGULATOR_MAX8952=y
> CONFIG_REGULATOR_MAX8997=y
> # CONFIG_REGULATOR_LP3971 is not set
> CONFIG_REGULATOR_LP3972=y
> CONFIG_REGULATOR_PCF50633=y
> # CONFIG_REGULATOR_TPS6105X is not set
> CONFIG_REGULATOR_TPS62360=y
> CONFIG_REGULATOR_TPS65023=y
> # CONFIG_REGULATOR_TPS6507X is not set
> # CONFIG_REGULATOR_TWL4030 is not set
> # CONFIG_REGULATOR_WM8350 is not set
> CONFIG_MEDIA_SUPPORT=y
> 
> #
> # Multimedia core support
> #
> # CONFIG_VIDEO_DEV is not set
> CONFIG_DVB_CORE=y
> CONFIG_VIDEO_MEDIA=y
> 
> #
> # Multimedia drivers
> #
> CONFIG_RC_CORE=y
> CONFIG_LIRC=y
> CONFIG_RC_MAP=y
> CONFIG_IR_NEC_DECODER=y
> # CONFIG_IR_RC5_DECODER is not set
> CONFIG_IR_RC6_DECODER=y
> CONFIG_IR_JVC_DECODER=y
> CONFIG_IR_SONY_DECODER=y
> # CONFIG_IR_RC5_SZ_DECODER is not set
> CONFIG_IR_SANYO_DECODER=y
> CONFIG_IR_MCE_KBD_DECODER=y
> # CONFIG_IR_LIRC_CODEC is not set
> # CONFIG_RC_LOOPBACK is not set
> CONFIG_IR_GPIO_CIR=y
> CONFIG_MEDIA_TUNER=y
> # CONFIG_MEDIA_TUNER_CUSTOMISE is not set
> CONFIG_MEDIA_TUNER_SIMPLE=y
> CONFIG_MEDIA_TUNER_TDA8290=y
> CONFIG_MEDIA_TUNER_TDA827X=y
> CONFIG_MEDIA_TUNER_TDA18271=y
> CONFIG_MEDIA_TUNER_TDA9887=y
> CONFIG_MEDIA_TUNER_TEA5767=y
> CONFIG_MEDIA_TUNER_MT20XX=y
> CONFIG_MEDIA_TUNER_XC2028=y
> CONFIG_MEDIA_TUNER_XC5000=y
> CONFIG_MEDIA_TUNER_XC4000=y
> CONFIG_MEDIA_TUNER_MC44S803=y
> CONFIG_DVB_MAX_ADAPTERS=8
> CONFIG_DVB_DYNAMIC_MINORS=y
> CONFIG_DVB_CAPTURE_DRIVERS=y
> # CONFIG_TTPCI_EEPROM is not set
> # CONFIG_SMS_SIANO_MDTV is not set
> # CONFIG_DVB_B2C2_FLEXCOP is not set
> 
> #
> # Supported DVB Frontends
> #
> # CONFIG_DVB_FE_CUSTOMISE is not set
> 
> #
> # Multistandard (satellite) frontends
> #
> 
> #
> # Multistandard (cable + terrestrial) frontends
> #
> 
> #
> # DVB-S (satellite) frontends
> #
> 
> #
> # DVB-T (terrestrial) frontends
> #
> 
> #
> # DVB-C (cable) frontends
> #
> 
> #
> # ATSC (North American/Korean Terrestrial/Cable DTV) frontends
> #
> 
> #
> # ISDB-T (terrestrial) frontends
> #
> 
> #
> # Digital terrestrial only tuners/PLL
> #
> 
> #
> # SEC control devices for DVB-S
> #
> 
> #
> # Tools to develop new frontends
> #
> # CONFIG_DVB_DUMMY_FE is not set
> 
> #
> # Graphics support
> #
> CONFIG_DRM=y
> # CONFIG_VGASTATE is not set
> # CONFIG_VIDEO_OUTPUT_CONTROL is not set
> # CONFIG_FB is not set
> CONFIG_EXYNOS_VIDEO=y
> # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
> CONFIG_SOUND=y
> CONFIG_SOUND_OSS_CORE=y
> # CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
> CONFIG_SND=y
> CONFIG_SND_TIMER=y
> CONFIG_SND_RAWMIDI=y
> CONFIG_SND_SEQUENCER=y
> # CONFIG_SND_SEQ_DUMMY is not set
> # CONFIG_SND_MIXER_OSS is not set
> # CONFIG_SND_PCM_OSS is not set
> # CONFIG_SND_SEQUENCER_OSS is not set
> # CONFIG_SND_RTCTIMER is not set
> # CONFIG_SND_DYNAMIC_MINORS is not set
> # CONFIG_SND_SUPPORT_OLD_API is not set
> CONFIG_SND_VERBOSE_PROCFS=y
> CONFIG_SND_VERBOSE_PRINTK=y
> # CONFIG_SND_DEBUG is not set
> CONFIG_SND_DMA_SGBUF=y
> CONFIG_SND_RAWMIDI_SEQ=y
> # CONFIG_SND_OPL3_LIB_SEQ is not set
> # CONFIG_SND_OPL4_LIB_SEQ is not set
> # CONFIG_SND_SBAWE_SEQ is not set
> # CONFIG_SND_EMU10K1_SEQ is not set
> CONFIG_SND_MPU401_UART=y
> CONFIG_SND_DRIVERS=y
> # CONFIG_SND_DUMMY is not set
> # CONFIG_SND_ALOOP is not set
> # CONFIG_SND_VIRMIDI is not set
> CONFIG_SND_MTPAV=y
> CONFIG_SND_MTS64=y
> # CONFIG_SND_SERIAL_U16550 is not set
> CONFIG_SND_MPU401=y
> # CONFIG_SND_PORTMAN2X4 is not set
> # CONFIG_SND_SOC is not set
> CONFIG_SOUND_PRIME=y
> # CONFIG_SOUND_OSS is not set
> CONFIG_HID_SUPPORT=y
> CONFIG_HID=y
> # CONFIG_HID_BATTERY_STRENGTH is not set
> # CONFIG_HIDRAW is not set
> # CONFIG_HID_PID is not set
> 
> #
> # Special HID drivers
> #
> # CONFIG_USB_ARCH_HAS_OHCI is not set
> # CONFIG_USB_ARCH_HAS_EHCI is not set
> # CONFIG_USB_ARCH_HAS_XHCI is not set
> CONFIG_USB_SUPPORT=y
> # CONFIG_USB_ARCH_HAS_HCD is not set
> # CONFIG_USB_OTG_WHITELIST is not set
> # CONFIG_USB_OTG_BLACKLIST_HUB is not set
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> # CONFIG_USB_GADGET is not set
> 
> #
> # OTG and related infrastructure
> #
> # CONFIG_MMC is not set
> CONFIG_MEMSTICK=y
> CONFIG_MEMSTICK_DEBUG=y
> 
> #
> # MemoryStick drivers
> #
> CONFIG_MEMSTICK_UNSAFE_RESUME=y
> CONFIG_MSPRO_BLOCK=y
> 
> #
> # MemoryStick Host Controller Drivers
> #
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> CONFIG_LEDS_88PM860X=y
> CONFIG_LEDS_LM3530=y
> # CONFIG_LEDS_NET48XX is not set
> # CONFIG_LEDS_WRAP is not set
> CONFIG_LEDS_GPIO=y
> CONFIG_LEDS_LP3944=y
> CONFIG_LEDS_LP5521=y
> CONFIG_LEDS_LP5523=y
> # CONFIG_LEDS_PCA955X is not set
> CONFIG_LEDS_PCA9633=y
> # CONFIG_LEDS_WM8350 is not set
> # CONFIG_LEDS_DA903X is not set
> # CONFIG_LEDS_REGULATOR is not set
> # CONFIG_LEDS_BD2802 is not set
> # CONFIG_LEDS_LT3593 is not set
> CONFIG_LEDS_TCA6507=y
> # CONFIG_LEDS_MAX8997 is not set
> CONFIG_LEDS_OT200=y
> CONFIG_LEDS_TRIGGERS=y
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGER_TIMER=y
> CONFIG_LEDS_TRIGGER_IDE_DISK=y
> CONFIG_LEDS_TRIGGER_HEARTBEAT=y
> # CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
> CONFIG_LEDS_TRIGGER_GPIO=y
> CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> CONFIG_ACCESSIBILITY=y
> # CONFIG_EDAC is not set
> # CONFIG_RTC_CLASS is not set
> # CONFIG_DMADEVICES is not set
> CONFIG_AUXDISPLAY=y
> CONFIG_KS0108=y
> CONFIG_KS0108_PORT=0x378
> CONFIG_KS0108_DELAY=2
> # CONFIG_UIO is not set
> 
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_BALLOON is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> CONFIG_STAGING=y
> # CONFIG_ECHO is not set
> CONFIG_PANEL=y
> CONFIG_PANEL_PARPORT=0
> CONFIG_PANEL_PROFILE=5
> CONFIG_PANEL_CHANGE_MESSAGE=y
> CONFIG_PANEL_BOOT_MESSAGE=""
> # CONFIG_IIO is not set
> # CONFIG_ZRAM is not set
> CONFIG_ZSMALLOC=y
> CONFIG_FT1000=y
> 
> #
> # Speakup console speech
> #
> # CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
> CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
> # CONFIG_STAGING_MEDIA is not set
> 
> #
> # Android
> #
> # CONFIG_ANDROID is not set
> # CONFIG_PHONE is not set
> # CONFIG_X86_PLATFORM_DEVICES is not set
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKSRC_I8253=y
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> # CONFIG_IOMMU_SUPPORT is not set
> 
> #
> # Remoteproc drivers (EXPERIMENTAL)
> #
> 
> #
> # Rpmsg drivers (EXPERIMENTAL)
> #
> # CONFIG_VIRT_DRIVERS is not set
> CONFIG_PM_DEVFREQ=y
> 
> #
> # DEVFREQ Governors
> #
> # CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
> # CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
> # CONFIG_DEVFREQ_GOV_POWERSAVE is not set
> # CONFIG_DEVFREQ_GOV_USERSPACE is not set
> 
> #
> # DEVFREQ Drivers
> #
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=y
> # CONFIG_EDD_OFF is not set
> # CONFIG_FIRMWARE_MEMMAP is not set
> # CONFIG_DELL_RBU is not set
> CONFIG_DCDBAS=y
> # CONFIG_ISCSI_IBFT_FIND is not set
> CONFIG_GOOGLE_FIRMWARE=y
> 
> #
> # Google Firmware Drivers
> #
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> # CONFIG_EXT2_FS_POSIX_ACL is not set
> # CONFIG_EXT2_FS_SECURITY is not set
> CONFIG_EXT2_FS_XIP=y
> # CONFIG_EXT3_FS is not set
> # CONFIG_EXT4_FS is not set
> CONFIG_FS_XIP=y
> CONFIG_FS_MBCACHE=y
> CONFIG_REISERFS_FS=y
> CONFIG_REISERFS_CHECK=y
> # CONFIG_REISERFS_PROC_INFO is not set
> CONFIG_REISERFS_FS_XATTR=y
> # CONFIG_REISERFS_FS_POSIX_ACL is not set
> # CONFIG_REISERFS_FS_SECURITY is not set
> # CONFIG_JFS_FS is not set
> # CONFIG_XFS_FS is not set
> # CONFIG_OCFS2_FS is not set
> # CONFIG_FS_POSIX_ACL is not set
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> # CONFIG_INOTIFY_USER is not set
> CONFIG_FANOTIFY=y
> # CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
> # CONFIG_QUOTA is not set
> # CONFIG_QUOTACTL is not set
> # CONFIG_AUTOFS4_FS is not set
> # CONFIG_FUSE_FS is not set
> 
> #
> # Caches
> #
> CONFIG_FSCACHE=y
> CONFIG_FSCACHE_STATS=y
> CONFIG_FSCACHE_HISTOGRAM=y
> CONFIG_FSCACHE_DEBUG=y
> # CONFIG_FSCACHE_OBJECT_LIST is not set
> CONFIG_CACHEFILES=y
> CONFIG_CACHEFILES_DEBUG=y
> CONFIG_CACHEFILES_HISTOGRAM=y
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=y
> # CONFIG_JOLIET is not set
> # CONFIG_ZISOFS is not set
> # CONFIG_UDF_FS is not set
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> CONFIG_MSDOS_FS=y
> # CONFIG_VFAT_FS is not set
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_NTFS_FS=y
> # CONFIG_NTFS_DEBUG is not set
> # CONFIG_NTFS_RW is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> # CONFIG_PROC_KCORE is not set
> # CONFIG_PROC_VMCORE is not set
> # CONFIG_PROC_SYSCTL is not set
> # CONFIG_PROC_PAGE_MONITOR is not set
> CONFIG_SYSFS=y
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=y
> CONFIG_MISC_FILESYSTEMS=y
> CONFIG_HFSPLUS_FS=y
> CONFIG_CRAMFS=y
> CONFIG_SQUASHFS=y
> CONFIG_SQUASHFS_XATTR=y
> CONFIG_SQUASHFS_ZLIB=y
> CONFIG_SQUASHFS_LZO=y
> CONFIG_SQUASHFS_XZ=y
> CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
> CONFIG_SQUASHFS_EMBEDDED=y
> CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
> # CONFIG_VXFS_FS is not set
> # CONFIG_MINIX_FS is not set
> CONFIG_OMFS_FS=y
> CONFIG_HPFS_FS=y
> CONFIG_QNX4FS_FS=y
> # CONFIG_QNX6FS_FS is not set
> # CONFIG_ROMFS_FS is not set
> CONFIG_PSTORE=y
> CONFIG_SYSV_FS=y
> CONFIG_UFS_FS=y
> # CONFIG_UFS_DEBUG is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=y
> CONFIG_NLS_CODEPAGE_737=y
> # CONFIG_NLS_CODEPAGE_775 is not set
> CONFIG_NLS_CODEPAGE_850=y
> # CONFIG_NLS_CODEPAGE_852 is not set
> CONFIG_NLS_CODEPAGE_855=y
> # CONFIG_NLS_CODEPAGE_857 is not set
> CONFIG_NLS_CODEPAGE_860=y
> CONFIG_NLS_CODEPAGE_861=y
> CONFIG_NLS_CODEPAGE_862=y
> CONFIG_NLS_CODEPAGE_863=y
> # CONFIG_NLS_CODEPAGE_864 is not set
> CONFIG_NLS_CODEPAGE_865=y
> CONFIG_NLS_CODEPAGE_866=y
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> # CONFIG_NLS_CODEPAGE_950 is not set
> CONFIG_NLS_CODEPAGE_932=y
> CONFIG_NLS_CODEPAGE_949=y
> CONFIG_NLS_CODEPAGE_874=y
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> # CONFIG_NLS_CODEPAGE_1251 is not set
> # CONFIG_NLS_ASCII is not set
> CONFIG_NLS_ISO8859_1=y
> CONFIG_NLS_ISO8859_2=y
> CONFIG_NLS_ISO8859_3=y
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> CONFIG_NLS_ISO8859_6=y
> # CONFIG_NLS_ISO8859_7 is not set
> CONFIG_NLS_ISO8859_9=y
> CONFIG_NLS_ISO8859_13=y
> CONFIG_NLS_ISO8859_14=y
> # CONFIG_NLS_ISO8859_15 is not set
> # CONFIG_NLS_KOI8_R is not set
> # CONFIG_NLS_KOI8_U is not set
> CONFIG_NLS_UTF8=y
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_PRINTK_TIME=y
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=1024
> CONFIG_MAGIC_SYSRQ=y
> # CONFIG_STRIP_ASM_SYMS is not set
> CONFIG_UNUSED_SYMBOLS=y
> CONFIG_DEBUG_FS=y
> CONFIG_HEADERS_CHECK=y
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_DEBUG_KERNEL=y
> CONFIG_DEBUG_SHIRQ=y
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_HARDLOCKUP_DETECTOR=y
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
> # CONFIG_DETECT_HUNG_TASK is not set
> CONFIG_SCHED_DEBUG=y
> CONFIG_SCHEDSTATS=y
> CONFIG_TIMER_STATS=y
> CONFIG_DEBUG_OBJECTS=y
> # CONFIG_DEBUG_OBJECTS_SELFTEST is not set
> # CONFIG_DEBUG_OBJECTS_FREE is not set
> # CONFIG_DEBUG_OBJECTS_TIMERS is not set
> CONFIG_DEBUG_OBJECTS_WORK=y
> CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_DEBUG_PI_LIST=y
> CONFIG_RT_MUTEX_TESTER=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> # CONFIG_PROVE_LOCKING is not set
> # CONFIG_SPARSE_RCU_POINTER is not set
> CONFIG_LOCKDEP=y
> # CONFIG_LOCK_STAT is not set
> CONFIG_DEBUG_LOCKDEP=y
> # CONFIG_DEBUG_ATOMIC_SLEEP is not set
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_KOBJECT is not set
> # CONFIG_DEBUG_HIGHMEM is not set
> # CONFIG_DEBUG_BUGVERBOSE is not set
> # CONFIG_DEBUG_INFO is not set
> CONFIG_DEBUG_VM=y
> CONFIG_DEBUG_VIRTUAL=y
> # CONFIG_DEBUG_WRITECOUNT is not set
> # CONFIG_DEBUG_MEMORY_INIT is not set
> # CONFIG_DEBUG_LIST is not set
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_DEBUG_SG is not set
> CONFIG_DEBUG_NOTIFIERS=y
> CONFIG_DEBUG_CREDENTIALS=y
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> # CONFIG_RCU_TRACE is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> CONFIG_DEBUG_BLOCK_EXT_DEVT=y
> CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
> # CONFIG_LKDTM is not set
> CONFIG_FAULT_INJECTION=y
> CONFIG_FAIL_PAGE_ALLOC=y
> CONFIG_FAIL_MAKE_REQUEST=y
> # CONFIG_FAIL_IO_TIMEOUT is not set
> CONFIG_FAULT_INJECTION_DEBUG_FS=y
> CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
> CONFIG_LATENCYTOP=y
> CONFIG_DEBUG_PAGEALLOC=y
> CONFIG_WANT_PAGE_DEBUG_FLAGS=y
> CONFIG_PAGE_GUARD=y
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACER_MAX_TRACE=y
> CONFIG_RING_BUFFER=y
> CONFIG_EVENT_TRACING=y
> CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
> CONFIG_CONTEXT_SWITCH_TRACER=y
> CONFIG_TRACING=y
> CONFIG_GENERIC_TRACER=y
> CONFIG_TRACING_SUPPORT=y
> CONFIG_FTRACE=y
> # CONFIG_FUNCTION_TRACER is not set
> # CONFIG_IRQSOFF_TRACER is not set
> CONFIG_SCHED_TRACER=y
> CONFIG_FTRACE_SYSCALLS=y
> CONFIG_TRACE_BRANCH_PROFILING=y
> # CONFIG_BRANCH_PROFILE_NONE is not set
> CONFIG_PROFILE_ANNOTATED_BRANCHES=y
> # CONFIG_PROFILE_ALL_BRANCHES is not set
> # CONFIG_BRANCH_TRACER is not set
> # CONFIG_STACK_TRACER is not set
> CONFIG_BLK_DEV_IO_TRACE=y
> # CONFIG_FTRACE_STARTUP_TEST is not set
> # CONFIG_RING_BUFFER_BENCHMARK is not set
> # CONFIG_BUILD_DOCSRC is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> # CONFIG_DMA_API_DEBUG is not set
> CONFIG_ATOMIC64_SELFTEST=y
> # CONFIG_ASYNC_RAID6_TEST is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> CONFIG_TEST_KSTRTOX=y
> CONFIG_STRICT_DEVMEM=y
> # CONFIG_X86_VERBOSE_BOOTUP is not set
> CONFIG_EARLY_PRINTK=y
> CONFIG_DEBUG_STACKOVERFLOW=y
> # CONFIG_X86_PTDUMP is not set
> CONFIG_DEBUG_RODATA=y
> CONFIG_DEBUG_RODATA_TEST=y
> # CONFIG_DOUBLEFAULT is not set
> CONFIG_IOMMU_STRESS=y
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> # CONFIG_IO_DELAY_0XED is not set
> CONFIG_IO_DELAY_UDELAY=y
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=2
> CONFIG_DEBUG_BOOT_PARAMS=y
> # CONFIG_CPA_DEBUG is not set
> # CONFIG_OPTIMIZE_INLINING is not set
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> CONFIG_ENCRYPTED_KEYS=y
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> CONFIG_SECURITY=y
> # CONFIG_SECURITYFS is not set
> CONFIG_SECURITY_NETWORK=y
> # CONFIG_SECURITY_PATH is not set
> # CONFIG_SECURITY_TOMOYO is not set
> # CONFIG_SECURITY_APPARMOR is not set
> # CONFIG_SECURITY_YAMA is not set
> CONFIG_INTEGRITY=y
> # CONFIG_INTEGRITY_SIGNATURE is not set
> # CONFIG_IMA is not set
> CONFIG_EVM=y
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
> CONFIG_CRYPTO_RNG=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP=y
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> # CONFIG_CRYPTO_USER is not set
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> CONFIG_CRYPTO_GF128MUL=y
> # CONFIG_CRYPTO_NULL is not set
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> # CONFIG_CRYPTO_AUTHENC is not set
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=y
> CONFIG_CRYPTO_GCM=y
> CONFIG_CRYPTO_SEQIV=y
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> CONFIG_CRYPTO_CTS=y
> # CONFIG_CRYPTO_ECB is not set
> CONFIG_CRYPTO_LRW=y
> # CONFIG_CRYPTO_PCBC is not set
> CONFIG_CRYPTO_XTS=y
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_HMAC=y
> 
> #
> # Digest
> #
> # CONFIG_CRYPTO_CRC32C is not set
> # CONFIG_CRYPTO_CRC32C_INTEL is not set
> CONFIG_CRYPTO_GHASH=y
> # CONFIG_CRYPTO_MD4 is not set
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_MICHAEL_MIC=y
> CONFIG_CRYPTO_RMD128=y
> # CONFIG_CRYPTO_RMD160 is not set
> # CONFIG_CRYPTO_RMD256 is not set
> CONFIG_CRYPTO_RMD320=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA256=y
> # CONFIG_CRYPTO_SHA512 is not set
> # CONFIG_CRYPTO_TGR192 is not set
> CONFIG_CRYPTO_WP512=y
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_586=y
> CONFIG_CRYPTO_AES_NI_INTEL=y
> CONFIG_CRYPTO_ANUBIS=y
> CONFIG_CRYPTO_ARC4=y
> # CONFIG_CRYPTO_BLOWFISH is not set
> CONFIG_CRYPTO_CAMELLIA=y
> CONFIG_CRYPTO_CAST5=y
> # CONFIG_CRYPTO_CAST6 is not set
> CONFIG_CRYPTO_DES=y
> # CONFIG_CRYPTO_FCRYPT is not set
> CONFIG_CRYPTO_KHAZAD=y
> # CONFIG_CRYPTO_SEED is not set
> CONFIG_CRYPTO_SERPENT=y
> # CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
> CONFIG_CRYPTO_TEA=y
> # CONFIG_CRYPTO_TWOFISH is not set
> # CONFIG_CRYPTO_TWOFISH_586 is not set
> 
> #
> # Compression
> #
> # CONFIG_CRYPTO_DEFLATE is not set
> CONFIG_CRYPTO_ZLIB=y
> # CONFIG_CRYPTO_LZO is not set
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=y
> # CONFIG_CRYPTO_USER_API_HASH is not set
> # CONFIG_CRYPTO_USER_API_SKCIPHER is not set
> CONFIG_CRYPTO_HW=y
> CONFIG_CRYPTO_DEV_PADLOCK=y
> CONFIG_CRYPTO_DEV_PADLOCK_AES=y
> CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
> CONFIG_HAVE_KVM=y
> # CONFIG_VIRTUALIZATION is not set
> CONFIG_BINARY_PRINTF=y
> 
> #
> # Library routines
> #
> CONFIG_RAID6_PQ=y
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> # CONFIG_CRC_CCITT is not set
> CONFIG_CRC16=y
> # CONFIG_CRC_T10DIF is not set
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> CONFIG_CRC32_SELFTEST=y
> # CONFIG_CRC32_SLICEBY8 is not set
> # CONFIG_CRC32_SLICEBY4 is not set
> CONFIG_CRC32_SARWATE=y
> # CONFIG_CRC32_BIT is not set
> CONFIG_CRC7=y
> # CONFIG_LIBCRC32C is not set
> CONFIG_CRC8=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> CONFIG_XZ_DEC_POWERPC=y
> CONFIG_XZ_DEC_IA64=y
> # CONFIG_XZ_DEC_ARM is not set
> CONFIG_XZ_DEC_ARMTHUMB=y
> # CONFIG_XZ_DEC_SPARC is not set
> CONFIG_XZ_DEC_BCJ=y
> CONFIG_XZ_DEC_TEST=y
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_CHECK_SIGNATURE=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> # CONFIG_AVERAGE is not set
> # CONFIG_CORDIC is not set

