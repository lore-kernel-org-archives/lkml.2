Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab1EYI32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:29:28 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:57116 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757Ab1EYI3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:29:18 -0400
Subject: Re: Mysterious CFQ crash and RCU
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Date: Wed, 25 May 2011 10:28:52 +0200
In-Reply-To: <4DDB7D36.60905@fusionio.com>
References: <20110519222404.GG12600@redhat.com>
		 <20110521210013.GJ2271@linux.vnet.ibm.com>
		 <20110523152141.GB4019@redhat.com>
		 <20110523153848.GC2310@linux.vnet.ibm.com>
	 <1306189249.15900.10.camel@t41.thuisdomein> <4DDB7D36.60905@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306312155.9059.8.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 11:41 +0200, Jens Axboe wrote:
> Paul, can we see a dmesg from your running system? Perhaps there's some
> dependency on a particular driver or device that makes this easier to
> reproduce.

Sure. What follows is (1K+ lines output of) the dmesg of a session in
which I managed to trigger this issue (three times) with my favorite
testing tool (ie, "mandb -c"). Feel free to prod me for the details of
my system that are not apparent from the flood of information in this
log.


Paul Bolle

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.39-0.local2.fc16.i686 ([...]@t41.thuisdomein) (gcc version 4.6.0 20110509 (Red Hat 4.6.0-7) (GCC) ) #1 SMP Sun May 22 18:11:44 CEST 2011
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ff60000 (usable)
[    0.000000]  BIOS-e820: 000000007ff60000 - 000000007ff77000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ff77000 - 000000007ff79000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007ff80000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] DMI present.
[    0.000000] DMI: IBM        /       , BIOS 1RETDIWW (3.14 ) 01/20/2005
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x7ff60 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DBFFF uncachable
[    0.000000]   DC000-DFFFF write-back
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07FF80000 mask FFFF80000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2096640KB, range: 512KB, type UC
[    0.000000] total RAM covered: 2047M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 1M 	num_reg: 2  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2096640KB, range: 512KB, type UC
[    0.000000] initial memory mapped : 0 - 01800000
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-0000000036ffe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0036c00000 page 2M
[    0.000000]  0036c00000 - 0036ffe000 page 4k
[    0.000000] kernel direct mapping tables up to 36ffe000 @ 17f9000-1800000
[    0.000000] RAMDISK: 371c8000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 361d6000 - 36ffd59e
[    0.000000] Move RAMDISK from 00000000371c8000 - 0000000037fef59d to 361d6000 - 36ffd59d
[    0.000000] ACPI: RSDP 000f6df0 00024 (v02 IBM   )
[    0.000000] ACPI: XSDT 7ff6a6cd 0004C (v01 IBM    TP-1R    00003140  LTP 00000000)
[    0.000000] ACPI: FACP 7ff6a800 000F4 (v03 IBM    TP-1R    00003140 IBM  00000001)
[    0.000000] ACPI Warning: 32/64X length mismatch in Gpe1Block: 0/32 (20110316/tbfadt-529)
[    0.000000] ACPI Warning: Optional field Gpe1Block has zero address or length: 0x000000000000102C/0x0 (20110316/tbfadt-560)
[    0.000000] ACPI: DSDT 7ff6a9e7 0C4D5 (v01 IBM    TP-1R    00003140 MSFT 0100000E)
[    0.000000] ACPI: FACS 7ff78000 00040
[    0.000000] ACPI: SSDT 7ff6a9b4 00033 (v01 IBM    TP-1R    00003140 MSFT 0100000E)
[    0.000000] ACPI: ECDT 7ff76ebc 00052 (v01 IBM    TP-1R    00003140 IBM  00000001)
[    0.000000] ACPI: TCPA 7ff76f0e 00032 (v01 IBM    TP-1R    00003140 PTL  00000001)
[    0.000000] ACPI: BOOT 7ff76fd8 00028 (v01 IBM    TP-1R    00003140  LTP 00000001)
[    0.000000] 1167MB HIGHMEM available.
[    0.000000] 879MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 36ffe000
[    0.000000]   low ram: 0 - 36ffe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00036ffe
[    0.000000]   HighMem  0x00036ffe -> 0x0007ff60
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007ff60
[    0.000000] On node 0 totalpages: 524015
[    0.000000] free_area_init_node: node 0, pgdat c0aefc40, node_mem_map f51d5200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1728 pages used for memmap
[    0.000000]   Normal zone: 219454 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2335 pages used for memmap
[    0.000000]   HighMem zone: 296515 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
[    0.000000] APIC: disable apic facility
[    0.000000] APIC: switched to apic NOOP
[    0.000000] nr_irqs_gsi: 16
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
[    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
[    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:7f800000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:1 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 332 pages/cpu @f4c00000 s1339200 r0 d20672 u4194304
[    0.000000] pcpu-alloc: s1339200 r0 d20672 u4194304 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 519920
[    0.000000] Kernel command line: ro root=UUID=283c5a40-0759-4b13-83df-deae686190d1 SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us-acentos radeon.agpmode=1
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 8385792 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (00036ffe:0007ff60)
[    0.000000] Memory: 2038648k/2096512k available (4230k kernel code, 57412k reserved, 2929k data, 1880k init, 1195400k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xff575000 - 0xfffff000   (10792 kB)
[    0.000000]     pkmap   : 0xff000000 - 0xff400000   (4096 kB)
[    0.000000]     vmalloc : 0xf77fe000 - 0xfeffe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf6ffe000   ( 879 MB)
[    0.000000]       .init : 0xc0afe000 - 0xc0cd4000   (1880 kB)
[    0.000000]       .data : 0xc082193a - 0xc0afddc0   (2929 kB)
[    0.000000]       .text : 0xc0400000 - 0xc082193a   (4230 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:2304
[    0.000000] CPU 0 irqstacks, hard=f40a0000 soft=f40a2000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 10 of 10 active objects replaced
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1694.254 MHz processor.
[    0.002005] Calibrating delay loop (skipped), value calculated using timer frequency.. 3388.50 BogoMIPS (lpj=1694254)
[    0.002242] pid_max: default: 32768 minimum: 301
[    0.003238] Security Framework initialized
[    0.003374] SELinux:  Initializing.
[    0.003655] SELinux:  Starting in permissive mode
[    0.004122] Mount-cache hash table entries: 512
[    0.007412] Initializing cgroup subsys ns
[    0.007544] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.007755] Initializing cgroup subsys cpuacct
[    0.007958] Initializing cgroup subsys memory
[    0.008144] Initializing cgroup subsys devices
[    0.008264] Initializing cgroup subsys freezer
[    0.008382] Initializing cgroup subsys net_cls
[    0.008499] Initializing cgroup subsys blkio
[    0.008656] Initializing cgroup subsys perf_event
[    0.009184] mce: CPU supports 5 MCE banks
[    0.009606] SMP alternatives: switching to UP code
[    0.013398] Freeing SMP alternatives: 12k freed
[    0.013527] ACPI: Core revision 20110316
[    0.080388] ACPI: setting ELCR to 0200 (from 0800)
[    0.081027] ftrace: allocating 23687 entries in 47 pages
[    0.083562] weird, boot CPU (#0) not listed by the BIOS.
[    0.083689] SMP motherboard not detected.
[    0.083803] Local APIC not detected. Using dummy APIC emulation.
[    0.083921] SMP disabled
[    0.084036] Performance Events: 
[    0.084065] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    0.084291] no hardware sampling interrupt available.
[    0.084408] p6 PMU driver.
[    0.084551] ... version:                0
[    0.084665] ... bit width:              32
[    0.084779] ... generic registers:      2
[    0.084894] ... value mask:             00000000ffffffff
[    0.085002] ... max period:             000000007fffffff
[    0.085118] ... fixed-purpose events:   0
[    0.085233] ... event mask:             0000000000000003
[    0.087267] NMI watchdog disabled (cpu0): not supported (no LAPIC?)
[    0.087560] Brought up 1 CPUs
[    0.087677] Total of 1 processors activated (3388.50 BogoMIPS).
[    0.089372] devtmpfs: initialized
[    0.091358] PM: Registering ACPI NVS region at 7ff77000 (8192 bytes)
[    0.093963] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.094097] Time: 14:40:00  Date: 05/24/11
[    0.095025] NET: Registered protocol family 16
[    0.097262] ACPI: bus type pci registered
[    0.098299] PCI: PCI BIOS revision 2.10 entry at 0xfd8d6, last bus=8
[    0.098419] PCI: Using configuration type 1 for base access
[    0.117281] bio: create slab <bio-0> at 0
[    0.138249] ACPI: EC: EC description table is found, configuring boot EC
[    0.269290] ACPI: Interpreter enabled
[    0.269412] ACPI: (supports S0 S3 S4 S5)
[    0.269845] ACPI: Using PIC for interrupt routing
[    0.299170] ACPI: Power Resource [PUBS] (on)
[    0.323053] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.335346] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.335466] HEST: Table not found.
[    0.335583] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.335907] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.336597] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.336602] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.336606] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.336611] pci_root PNP0A03:00: host bridge window [mem 0x000d4000-0x000d7fff] (ignored)
[    0.336615] pci_root PNP0A03:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
[    0.336620] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xfebfffff] (ignored)
[    0.336710] pci 0000:00:00.0: [8086:3340] type 0 class 0x000600
[    0.336729] pci 0000:00:00.0: reg 10: [mem 0xd0000000-0xdfffffff pref]
[    0.337033] pci 0000:00:01.0: [8086:3341] type 1 class 0x000604
[    0.337226] pci 0000:00:1d.0: [8086:24c2] type 0 class 0x000c03
[    0.337335] pci 0000:00:1d.0: reg 20: [io  0x1800-0x181f]
[    0.337428] pci 0000:00:1d.1: [8086:24c4] type 0 class 0x000c03
[    0.337536] pci 0000:00:1d.1: reg 20: [io  0x1820-0x183f]
[    0.337628] pci 0000:00:1d.2: [8086:24c7] type 0 class 0x000c03
[    0.337737] pci 0000:00:1d.2: reg 20: [io  0x1840-0x185f]
[    0.337857] pci 0000:00:1d.7: [8086:24cd] type 0 class 0x000c03
[    0.337904] pci 0000:00:1d.7: reg 10: [mem 0xc0000000-0xc00003ff]
[    0.338108] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.338118] pci 0000:00:1d.7: PME# disabled
[    0.338163] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.338277] pci 0000:00:1f.0: [8086:24cc] type 0 class 0x000601
[    0.338444] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH4 ACPI/GPIO/TCO
[    0.338659] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH4 GPIO
[    0.338818] pci 0000:00:1f.1: [8086:24ca] type 0 class 0x000101
[    0.338850] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.338873] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.338896] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.338919] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.338941] pci 0000:00:1f.1: reg 20: [io  0x1860-0x186f]
[    0.338982] pci 0000:00:1f.1: reg 24: [mem 0x00000000-0x000003ff]
[    0.339062] pci 0000:00:1f.3: [8086:24c3] type 0 class 0x000c05
[    0.339170] pci 0000:00:1f.3: reg 20: [io  0x1880-0x189f]
[    0.339272] pci 0000:00:1f.5: [8086:24c5] type 0 class 0x000401
[    0.339310] pci 0000:00:1f.5: reg 10: [io  0x1c00-0x1cff]
[    0.339331] pci 0000:00:1f.5: reg 14: [io  0x18c0-0x18ff]
[    0.339353] pci 0000:00:1f.5: reg 18: [mem 0xc0000c00-0xc0000dff]
[    0.339375] pci 0000:00:1f.5: reg 1c: [mem 0xc0000800-0xc00008ff]
[    0.339478] pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
[    0.339486] pci 0000:00:1f.5: PME# disabled
[    0.339531] pci 0000:00:1f.6: [8086:24c6] type 0 class 0x000703
[    0.339569] pci 0000:00:1f.6: reg 10: [io  0x2400-0x24ff]
[    0.339590] pci 0000:00:1f.6: reg 14: [io  0x2000-0x207f]
[    0.339728] pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
[    0.339737] pci 0000:00:1f.6: PME# disabled
[    0.339813] pci 0000:01:00.0: [1002:4c66] type 0 class 0x000300
[    0.339853] pci 0000:01:00.0: reg 10: [mem 0xe0000000-0xe7ffffff pref]
[    0.339874] pci 0000:01:00.0: reg 14: [io  0x3000-0x30ff]
[    0.339894] pci 0000:01:00.0: reg 18: [mem 0xc0100000-0xc010ffff]
[    0.339984] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.340044] pci 0000:01:00.0: supports D1 D2
[    0.340162] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.340285] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.340293] pci 0000:00:01.0:   bridge window [mem 0xc0100000-0xc01fffff]
[    0.340301] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xe7ffffff pref]
[    0.340419] pci 0000:02:00.0: [104c:ac46] type 2 class 0x000607
[    0.340459] pci 0000:02:00.0: reg 10: [mem 0xb0000000-0xb0000fff]
[    0.340511] pci 0000:02:00.0: supports D1 D2
[    0.340515] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.340594] pci 0000:02:00.0: PME# disabled
[    0.340641] pci 0000:02:00.1: [104c:ac46] type 2 class 0x000607
[    0.340682] pci 0000:02:00.1: reg 10: [mem 0xb1000000-0xb1000fff]
[    0.340733] pci 0000:02:00.1: supports D1 D2
[    0.340737] pci 0000:02:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.340747] pci 0000:02:00.1: PME# disabled
[    0.340815] pci 0000:02:01.0: [8086:101e] type 0 class 0x000200
[    0.340855] pci 0000:02:01.0: reg 10: [mem 0xc0220000-0xc023ffff]
[    0.340878] pci 0000:02:01.0: reg 14: [mem 0xc0200000-0xc020ffff]
[    0.340901] pci 0000:02:01.0: reg 18: [io  0x8000-0x803f]
[    0.340998] pci 0000:02:01.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.341050] pci 0000:02:01.0: PME# supported from D0 D3hot D3cold
[    0.341060] pci 0000:02:01.0: PME# disabled
[    0.341107] pci 0000:02:02.0: [168c:1014] type 0 class 0x000200
[    0.341147] pci 0000:02:02.0: reg 10: [mem 0xc0210000-0xc021ffff]
[    0.341426] pci 0000:00:1e.0: PCI bridge to [bus 02-08] (subtractive decode)
[    0.341553] pci 0000:00:1e.0:   bridge window [io  0x4000-0x8fff]
[    0.341563] pci 0000:00:1e.0:   bridge window [mem 0xc0200000-0xcfffffff]
[    0.341572] pci 0000:00:1e.0:   bridge window [mem 0xe8000000-0xefffffff pref]
[    0.341578] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.341583] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
[    0.341804] pci_bus 0000:00: on NUMA node 0
[    0.341818] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.342449] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.342720] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.379526] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.380779] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.382062] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.383308] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.384334] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.385487] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.386631] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.388038] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.389603] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.389998] vgaarb: loaded
[    0.391709] SCSI subsystem initialized
[    0.392252] libata version 3.00 loaded.
[    0.392798] usbcore: registered new interface driver usbfs
[    0.393057] usbcore: registered new interface driver hub
[    0.393351] usbcore: registered new device driver usb
[    0.394155] PCI: Using ACPI for IRQ routing
[    0.394525] PCI: pci_cache_line_size set to 64 bytes
[    0.394920] reserve RAM buffer: 000000000009f000 - 000000000009ffff 
[    0.394939] reserve RAM buffer: 000000007ff60000 - 000000007fffffff 
[    0.396249] NetLabel: Initializing
[    0.396365] NetLabel:  domain hash size = 128
[    0.396479] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.396796] NetLabel:  unlabeled traffic allowed by default
[    0.397086] Switching to clocksource pit
[    0.504412] pnp: PnP ACPI init
[    0.504707] ACPI: bus type pnp registered
[    0.510166] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.510171] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    0.510176] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    0.510181] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    0.510185] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    0.510190] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    0.510195] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    0.510199] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    0.510204] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    0.510209] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    0.510213] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    0.510218] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    0.510222] pnp 00:00: [mem 0x000ec000-0x000effff]
[    0.510227] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    0.510231] pnp 00:00: [mem 0x00100000-0x7fffffff]
[    0.510251] pnp 00:00: [mem 0xfec00000-0xffffffff]
[    0.510727] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.510860] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.510990] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.511119] system 00:00: [mem 0x000c8000-0x000cbfff] could not be reserved
[    0.511249] system 00:00: [mem 0x000cc000-0x000cffff] could not be reserved
[    0.511378] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
[    0.511508] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    0.511669] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.511799] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.511929] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.512058] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.512188] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.512317] system 00:00: [mem 0x00100000-0x7fffffff] could not be reserved
[    0.512447] system 00:00: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.512576] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.512743] pnp 00:01: [bus 00-ff]
[    0.512748] pnp 00:01: [io  0x0cf8-0x0cff]
[    0.512753] pnp 00:01: [io  0x0000-0x0cf7 window]
[    0.512758] pnp 00:01: [io  0x0d00-0xffff window]
[    0.512763] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    0.512768] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    0.512772] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    0.512777] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    0.512782] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    0.512787] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    0.512792] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    0.512797] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    0.512801] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    0.512806] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    0.512811] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    0.512816] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    0.512821] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    0.512826] pnp 00:01: [mem 0x80000000-0xfebfffff window]
[    0.513170] pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.513953] pnp 00:02: [io  0x0010-0x001f]
[    0.513958] pnp 00:02: [io  0x0090-0x009f]
[    0.513963] pnp 00:02: [io  0x0024-0x0025]
[    0.513967] pnp 00:02: [io  0x0028-0x0029]
[    0.513971] pnp 00:02: [io  0x002c-0x002d]
[    0.513976] pnp 00:02: [io  0x0030-0x0031]
[    0.513980] pnp 00:02: [io  0x0034-0x0035]
[    0.513984] pnp 00:02: [io  0x0038-0x0039]
[    0.513988] pnp 00:02: [io  0x003c-0x003d]
[    0.513993] pnp 00:02: [io  0x00a4-0x00a5]
[    0.513997] pnp 00:02: [io  0x00a8-0x00a9]
[    0.514001] pnp 00:02: [io  0x00ac-0x00ad]
[    0.514006] pnp 00:02: [io  0x00b0-0x00b5]
[    0.514010] pnp 00:02: [io  0x00b8-0x00b9]
[    0.514014] pnp 00:02: [io  0x00bc-0x00bd]
[    0.514018] pnp 00:02: [io  0x0050-0x0053]
[    0.514023] pnp 00:02: [io  0x0072-0x0077]
[    0.514039] pnp 00:02: [io  0x002e-0x002f]
[    0.514044] pnp 00:02: [io  0x1000-0x107f]
[    0.514048] pnp 00:02: [io  0x1180-0x11bf]
[    0.514052] pnp 00:02: [io  0x15e0-0x15ef]
[    0.514057] pnp 00:02: [io  0x1600-0x162f]
[    0.514061] pnp 00:02: [io  0x1632-0x167f]
[    0.514065] pnp 00:02: [io  0x004e-0x004f]
[    0.514069] pnp 00:02: [io  0x1630-0x1631]
[    0.514524] system 00:02: [io  0x1000-0x107f] has been reserved
[    0.514680] system 00:02: [io  0x1180-0x11bf] has been reserved
[    0.514802] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.514923] system 00:02: [io  0x1600-0x162f] has been reserved
[    0.515045] system 00:02: [io  0x1632-0x167f] has been reserved
[    0.515166] system 00:02: [io  0x1630-0x1631] has been reserved
[    0.515291] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.515427] pnp 00:03: [io  0x0000-0x000f]
[    0.515432] pnp 00:03: [io  0x0080-0x008f]
[    0.515436] pnp 00:03: [io  0x00c0-0x00df]
[    0.515441] pnp 00:03: [dma 4]
[    0.515691] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.515781] pnp 00:04: [io  0x0061]
[    0.516013] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.516091] pnp 00:05: [io  0x00f0]
[    0.516098] pnp 00:05: [irq 13]
[    0.516319] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.516396] pnp 00:06: [io  0x0070-0x0071]
[    0.516401] pnp 00:06: [irq 8]
[    0.516668] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.516745] pnp 00:07: [io  0x0060]
[    0.516750] pnp 00:07: [io  0x0064]
[    0.516754] pnp 00:07: [irq 1]
[    0.516979] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.517055] pnp 00:08: [irq 12]
[    0.517303] pnp 00:08: Plug and Play ACPI device, IDs IBM0057 PNP0f13 (active)
[    0.517555] pnp 00:09: [io  0x03f0-0x03f5]
[    0.517560] pnp 00:09: [io  0x03f7]
[    0.517565] pnp 00:09: [irq 6]
[    0.517569] pnp 00:09: [dma 2]
[    0.517878] pnp 00:09: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.518561] pnp 00:0a: [io  0x03f8-0x03ff]
[    0.518566] pnp 00:0a: [irq 4]
[    0.518989] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.519932] pnp 00:0b: [io  0x03bc-0x03be]
[    0.519938] pnp 00:0b: [irq 7]
[    0.520378] pnp 00:0b: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.521390] pnp 00:0c: [io  0x02f8-0x02ff]
[    0.521395] pnp 00:0c: [irq 3]
[    0.521399] pnp 00:0c: [dma 3]
[    0.521814] pnp 00:0c: Plug and Play ACPI device, IDs IBM0071 PNP0511 (active)
[    0.525763] pnp: PnP ACPI: found 13 devices
[    0.525883] ACPI: ACPI bus type pnp unregistered
[    0.577342] Switching to clocksource acpi_pm
[    0.577667] Switched to NOHz mode on CPU #0
[    0.577905] pci 0000:00:1f.1: BAR 5: assigned [mem 0x80000000-0x800003ff]
[    0.578077] pci 0000:00:1f.1: BAR 5: set to [mem 0x80000000-0x800003ff] (PCI address [0x80000000-0x800003ff])
[    0.578296] pci 0000:01:00.0: BAR 6: assigned [mem 0xc0120000-0xc013ffff pref]
[    0.578505] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.578625] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.578750] pci 0000:00:01.0:   bridge window [mem 0xc0100000-0xc01fffff]
[    0.578875] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xe7ffffff pref]
[    0.579131] pci 0000:02:00.0: BAR 15: assigned [mem 0xe8000000-0xebffffff pref]
[    0.579339] pci 0000:02:00.0: BAR 16: assigned [mem 0xc4000000-0xc7ffffff]
[    0.579461] pci 0000:02:00.1: BAR 15: assigned [mem 0xec000000-0xefffffff pref]
[    0.579669] pci 0000:02:00.1: BAR 16: assigned [mem 0xc8000000-0xcbffffff]
[    0.579792] pci 0000:02:01.0: BAR 6: assigned [mem 0xc0240000-0xc024ffff pref]
[    0.579999] pci 0000:02:00.0: BAR 13: assigned [io  0x4000-0x40ff]
[    0.580148] pci 0000:02:00.0: BAR 14: assigned [io  0x4400-0x44ff]
[    0.580269] pci 0000:02:00.1: BAR 13: assigned [io  0x4800-0x48ff]
[    0.580389] pci 0000:02:00.1: BAR 14: assigned [io  0x4c00-0x4cff]
[    0.580524] pci 0000:02:00.0: CardBus bridge to [bus 03-06]
[    0.580642] pci 0000:02:00.0:   bridge window [io  0x4000-0x40ff]
[    0.580766] pci 0000:02:00.0:   bridge window [io  0x4400-0x44ff]
[    0.580890] pci 0000:02:00.0:   bridge window [mem 0xe8000000-0xebffffff pref]
[    0.581130] pci 0000:02:00.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.581256] pci 0000:02:00.1: CardBus bridge to [bus 07-07]
[    0.581373] pci 0000:02:00.1:   bridge window [io  0x4800-0x48ff]
[    0.581497] pci 0000:02:00.1:   bridge window [io  0x4c00-0x4cff]
[    0.581621] pci 0000:02:00.1:   bridge window [mem 0xec000000-0xefffffff pref]
[    0.581832] pci 0000:02:00.1:   bridge window [mem 0xc8000000-0xcbffffff]
[    0.581957] pci 0000:00:1e.0: PCI bridge to [bus 02-08]
[    0.582106] pci 0000:00:1e.0:   bridge window [io  0x4000-0x8fff]
[    0.582233] pci 0000:00:1e.0:   bridge window [mem 0xc0200000-0xcfffffff]
[    0.582359] pci 0000:00:1e.0:   bridge window [mem 0xe8000000-0xefffffff pref]
[    0.582608] pci 0000:00:1e.0: setting latency timer to 64
[    0.584509] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    0.584630] PCI: setting IRQ 11 as level-triggered
[    0.584638] pci 0000:02:00.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
[    0.586586] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[    0.586707] pci 0000:02:00.1: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
[    0.586922] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.586927] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
[    0.586931] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    0.586935] pci_bus 0000:01: resource 1 [mem 0xc0100000-0xc01fffff]
[    0.586939] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xe7ffffff pref]
[    0.586944] pci_bus 0000:02: resource 0 [io  0x4000-0x8fff]
[    0.586948] pci_bus 0000:02: resource 1 [mem 0xc0200000-0xcfffffff]
[    0.586952] pci_bus 0000:02: resource 2 [mem 0xe8000000-0xefffffff pref]
[    0.586956] pci_bus 0000:02: resource 4 [io  0x0000-0xffff]
[    0.586960] pci_bus 0000:02: resource 5 [mem 0x00000000-0xffffffff]
[    0.586964] pci_bus 0000:03: resource 0 [io  0x4000-0x40ff]
[    0.586968] pci_bus 0000:03: resource 1 [io  0x4400-0x44ff]
[    0.586972] pci_bus 0000:03: resource 2 [mem 0xe8000000-0xebffffff pref]
[    0.586976] pci_bus 0000:03: resource 3 [mem 0xc4000000-0xc7ffffff]
[    0.586980] pci_bus 0000:07: resource 0 [io  0x4800-0x48ff]
[    0.586984] pci_bus 0000:07: resource 1 [io  0x4c00-0x4cff]
[    0.586988] pci_bus 0000:07: resource 2 [mem 0xec000000-0xefffffff pref]
[    0.586992] pci_bus 0000:07: resource 3 [mem 0xc8000000-0xcbffffff]
[    0.587389] NET: Registered protocol family 2
[    0.588259] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.590770] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.593214] TCP bind hash table entries: 65536 (order: 9, 2883584 bytes)
[    0.603717] TCP: Hash tables configured (established 131072 bind 65536)
[    0.603937] TCP reno registered
[    0.604134] UDP hash table entries: 512 (order: 3, 49152 bytes)
[    0.604429] UDP-Lite hash table entries: 512 (order: 3, 49152 bytes)
[    0.605629] NET: Registered protocol family 1
[    0.606087] pci 0000:01:00.0: Boot video device
[    0.606147] PCI: CLS 32 bytes, default 64
[    0.607273] Trying to unpack rootfs image as initramfs...
[    1.548160] Freeing initrd memory: 14496k freed
[    1.634058] DMA-API: preallocated 32768 debug entries
[    1.634185] DMA-API: debugging enabled by kernel config
[    1.634320] Simple Boot Flag at 0x35 set to 0x1
[    1.636370] IBM machine detected. Enabling interrupts during APM calls.
[    1.636498] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[    1.636617] apm: overridden by ACPI.
[    1.637805] audit: initializing netlink socket (disabled)
[    1.638089] type=2000 audit(1306248001.636:1): initialized
[    1.677402] highmem bounce pool size: 64 pages
[    1.677539] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.703700] VFS: Disk quotas dquot_6.5.2
[    1.704488] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.711362] msgmni has been set to 1675
[    1.712363] SELinux:  Registering netfilter hooks
[    1.714383] cryptomgr_test used greatest stack depth: 6840 bytes left
[    1.714925] cryptomgr_test used greatest stack depth: 6804 bytes left
[    1.715650] cryptomgr_test used greatest stack depth: 6788 bytes left
[    1.715923] alg: No test for stdrng (krng)
[    1.716140] NET: Registered protocol family 38
[    1.716668] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.717215] io scheduler noop registered
[    1.717331] io scheduler deadline registered
[    1.717906] io scheduler cfq registered (default)
[    1.718071] start plist test
[    1.720226] end plist test
[    1.720339] list_sort_test: start testing list_sort()
[    1.724905] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.725509] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.725629] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.727784] acpiphp: Slot [1] registered
[    1.730699] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    1.731632] ACPI: AC Adapter [AC] (on-line)
[    1.733148] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    1.733754] ACPI: Lid Switch [LID]
[    1.734216] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    1.734504] ACPI: Sleep Button [SLPB]
[    1.734971] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.735220] ACPI: Power Button [PWRF]
[    1.736834] ACPI: acpi_idle registered with cpuidle
[    1.738044] Marking TSC unstable due to TSC halts in idle
[    1.762581] thermal LNXTHERM:00: registered as thermal_zone0
[    1.762702] ACPI: Thermal Zone [THM0] (56 C)
[    1.762930] ERST: Table is not found!
[    1.763305] isapnp: Scanning for PnP cards...
[    2.122542] isapnp: No Plug & Play device found
[    2.124291] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.126835] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
[    2.127659] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    2.135185] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
[    2.137330] serial 0000:00:1f.6: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
[    2.137611] serial 0000:00:1f.6: PCI INT B disabled
[    2.144332] Non-volatile memory driver v1.3
[    2.144450] Linux agpgart interface v0.103
[    2.146339] agpgart-intel 0000:00:00.0: Intel 855PM Chipset
[    2.161965] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    2.164910] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.165214] ACPI: Battery Slot [BAT0] (battery present)
[    2.178304] brd: module loaded
[    2.184588] loop: module loaded
[    2.185886] ata_piix 0000:00:1f.1: version 2.13
[    2.185913] ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
[    2.187875] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    2.187998] ata_piix 0000:00:1f.1: PCI INT A -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
[    2.188478] ata_piix 0000:00:1f.1: setting latency timer to 64
[    2.191735] scsi0 : ata_piix
[    2.193217] scsi1 : ata_piix
[    2.199377] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1860 irq 14
[    2.199499] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1868 irq 15
[    2.200816] Fixed MDIO Bus: probed
[    2.201643] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.201843] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    2.201977] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    2.203890] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
[    2.204043] ehci_hcd 0000:00:1d.7: PCI INT D -> Link[LNKH] -> GSI 11 (level, low) -> IRQ 11
[    2.204494] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.204501] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.206411] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    2.206867] ehci_hcd 0000:00:1d.7: debug port 1
[    2.210883] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.210916] ehci_hcd 0000:00:1d.7: irq 11, io mem 0xc0000000
[    2.220071] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.220604] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.220725] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.223660] usb usb1: Product: EHCI Host Controller
[    2.223776] usb usb1: Manufacturer: Linux 2.6.39-0.local2.fc16.i686 ehci_hcd
[    2.223897] usb usb1: SerialNumber: 0000:00:1d.7
[    2.225759] hub 1-0:1.0: USB hub found
[    2.226053] hub 1-0:1.0: 6 ports detected
[    2.227342] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.227576] uhci_hcd: USB Universal Host Controller Interface driver
[    2.228078] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    2.228210] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    2.228343] uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
[    2.228578] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.228585] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.229130] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.229442] uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001800
[    2.229887] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.230039] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.230245] usb usb2: Product: UHCI Host Controller
[    2.230361] usb usb2: Manufacturer: Linux 2.6.39-0.local2.fc16.i686 uhci_hcd
[    2.230481] usb usb2: SerialNumber: 0000:00:1d.0
[    2.231392] hub 2-0:1.0: USB hub found
[    2.231559] hub 2-0:1.0: 2 ports detected
[    2.232285] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
[    2.232416] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
[    2.234364] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    2.234486] uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
[    2.234717] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.234724] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.235273] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.235550] uhci_hcd 0000:00:1d.1: irq 11, io base 0x00001820
[    2.235926] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.236078] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.236283] usb usb3: Product: UHCI Host Controller
[    2.236400] usb usb3: Manufacturer: Linux 2.6.39-0.local2.fc16.i686 uhci_hcd
[    2.236520] usb usb3: SerialNumber: 0000:00:1d.1
[    2.237436] hub 3-0:1.0: USB hub found
[    2.237595] hub 3-0:1.0: 2 ports detected
[    2.238285] uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
[    2.238516] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.238523] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.239089] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.239365] uhci_hcd 0000:00:1d.2: irq 11, io base 0x00001840
[    2.239780] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.239901] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.240138] usb usb4: Product: UHCI Host Controller
[    2.240255] usb usb4: Manufacturer: Linux 2.6.39-0.local2.fc16.i686 uhci_hcd
[    2.240375] usb usb4: SerialNumber: 0000:00:1d.2
[    2.241265] hub 4-0:1.0: USB hub found
[    2.241422] hub 4-0:1.0: 2 ports detected
[    2.242440] usbcore: registered new interface driver usbserial
[    2.242789] USB Serial support registered for generic
[    2.243060] usbcore: registered new interface driver usbserial_generic
[    2.243179] usbserial: USB Serial Driver core
[    2.243368] USB Serial support registered for GSM modem (1-port)
[    2.243629] usbcore: registered new interface driver option
[    2.243746] option: v0.7.2:USB Driver for GSM modems
[    2.244146] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.251592] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.251894] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.253224] mousedev: PS/2 mouse device common for all mice
[    2.255644] rtc_cmos 00:06: RTC can wake from S4
[    2.256781] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    2.257001] rtc0: alarms up to one month, y3k, 114 bytes nvram
[    2.258848] device-mapper: uevent: version 1.0.3
[    2.260516] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    2.261654] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    2.263404] cpuidle: using governor ladder
[    2.264705] cpuidle: using governor menu
[    2.268400] EFI Variables Facility v0.08 2004-May-17
[    2.270439] usbcore: registered new interface driver usbhid
[    2.270557] usbhid: USB HID core driver
[    2.273656] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.273882] TCP cubic registered
[    2.273996] Initializing XFRM netlink socket
[    2.274220] NET: Registered protocol family 17
[    2.274489] Registering the dns_resolver key type
[    2.274976] Using IPI No-Shortcut mode
[    2.275940] PM: Hibernation image not present or could not be loaded.
[    2.276083] registered taskstats version 1
[    2.277207] IMA: No TPM chip found, activating TPM-bypass!
[    2.279915]   Magic number: 11:414:688
[    2.280246] rtc_cmos 00:06: setting system clock to 2011-05-24 14:40:02 UTC (1306248002)
[    2.280634] Initializing network drop monitor service
[    2.354664] ata1.00: HPA detected: current 149285282, native 156301488
[    2.354790] ata1.00: ATA-7: Hitachi HTS541680J9AT00, SB2OA70H, max UDMA/100
[    2.354912] ata1.00: 149285282 sectors, multi 16: LBA48 
[    2.355443] ata2.01: NODEV after polling detection
[    2.358635] ata2.00: ATAPI: UJDA755zDVD/CDRW, 1.20, max UDMA/33
[    2.359392] ata1.00: configured for UDMA/100
[    2.361814] ata2.00: configured for UDMA/33
[    2.362198] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54168 SB2O PQ: 0 ANSI: 5
[    2.365717] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.367700] sd 0:0:0:0: [sda] 149285282 512-byte logical blocks: (76.4 GB/71.1 GiB)
[    2.368460] sd 0:0:0:0: [sda] Write Protect is off
[    2.368661] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.369005] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.370164] scsi 1:0:0:0: CD-ROM            MATSHITA UJDA755zDVD/CDRW 1.20 PQ: 0 ANSI: 5
[    2.373211] sda: detected capacity change from 0 to 76434064384
[    2.374182] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    2.374309] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.375776] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.376285] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.393254]  sda: sda1 sda2 sda3
[    2.395836] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.396278] Freeing unused kernel memory: 1880k freed
[    2.399481] Write protecting the kernel text: 4232k
[    2.400329] Write protecting the kernel read-only data: 2072k
[    2.410347] mknod used greatest stack depth: 6604 bytes left
[    2.552893] dracut: dracut-010-1.fc16
[    2.622619] udev[102]: starting version 167
[    2.939484] Synaptics Touchpad, model: 1, fw: 5.9, id: 0x2c6ab1, caps: 0x884793/0x0/0x0
[    2.939714] serio: Synaptics pass-through port at isa0060/serio1/input0
[    2.983922] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input4
[    3.083562] [drm] Initialized drm 1.1.0 20060810
[    3.147914] console_init used greatest stack depth: 6396 bytes left
[    3.221309] [drm] radeon defaulting to kernel modesetting.
[    3.221435] [drm] radeon kernel modesetting enabled.
[    3.222063] radeon 0000:01:00.0: power state changed by ACPI to D0
[    3.222200] radeon 0000:01:00.0: power state changed by ACPI to D0
[    3.222337] radeon 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
[    3.226654] [drm] initializing kernel modesetting (RV250 0x1002:0x4C66).
[    3.226822] [drm] register mmio base: 0xC0100000
[    3.226937] [drm] register mmio size: 65536
[    3.227633] [drm] AGP mode requested: 1
[    3.227754] agpgart-intel 0000:00:00.0: AGP 2.0 bridge
[    3.227925] agpgart-intel 0000:00:00.0: putting AGP V2 device into 1x mode
[    3.228249] radeon 0000:01:00.0: putting AGP V2 device into 1x mode
[    3.228458] radeon 0000:01:00.0: GTT: 256M 0xD0000000 - 0xDFFFFFFF
[    3.228586] radeon 0000:01:00.0: VRAM: 128M 0x00000000E0000000 - 0x00000000E7FFFFFF (32M used)
[    3.228960] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    3.229111] [drm] Driver supports precise vblank timestamp query.
[    3.229286] [drm] radeon: irq initialized.
[    3.229683] [drm] Detected VRAM RAM=128M, BAR=128M
[    3.229806] [drm] RAM width 64bits DDR
[    3.231188] [TTM] Zone  kernel: Available graphics memory: 429818 kiB.
[    3.231308] [TTM] Zone highmem: Available graphics memory: 1027518 kiB.
[    3.231428] [TTM] Initializing pool allocator.
[    3.232788] [drm] radeon: 32M of VRAM memory ready
[    3.232910] [drm] radeon: 256M of GTT memory ready.
[    3.237327] radeon 0000:01:00.0: WB disabled
[    3.239671] [drm] Loading R200 Microcode
[    3.258943] [drm] radeon: ring at 0x00000000D0001000
[    3.259248] [drm] ring test succeeded in 0 usecs
[    3.261058] [drm] radeon: ib pool ready.
[    3.264470] [drm] ib test succeeded in 0 usecs
[    3.274521] [drm] Panel ID String: SXGA+ Single (85MHz)    
[    3.274644] [drm] Panel Size 1400x1050
[    3.286937] [drm] radeon legacy LVDS backlight initialized
[    3.287280] [drm] No TV DAC info found in BIOS
[    3.287738] [drm] Radeon Display Connectors
[    3.287854] [drm] Connector 0:
[    3.287966] [drm]   VGA
[    3.288110] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[    3.288228] [drm]   Encoders:
[    3.288340] [drm]     CRT1: INTERNAL_DAC1
[    3.288455] [drm] Connector 1:
[    3.288567] [drm]   DVI-D
[    3.288679] [drm]   HPD1
[    3.288792] [drm]   DDC: 0x64 0x64 0x64 0x64 0x64 0x64 0x64 0x64
[    3.288909] [drm]   Encoders:
[    3.289049] [drm]     DFP1: INTERNAL_TMDS1
[    3.289163] [drm] Connector 2:
[    3.289276] [drm]   LVDS
[    3.289387] [drm]   Encoders:
[    3.289499] [drm]     LCD1: INTERNAL_LVDS
[    3.289614] [drm] Connector 3:
[    3.292469] [drm]   S-video
[    3.292581] [drm]   Encoders:
[    3.292694] [drm]     TV1: INTERNAL_DAC2
[    3.314790] [drm] radeon: power management initialized
[    3.355134] [drm] fb mappable at 0xE0040000
[    3.355250] [drm] vram apper at 0xE0000000
[    3.355365] [drm] size 1478656
[    3.355478] [drm] fb depth is 8
[    3.355590] [drm]    pitch is 1408
[    3.357288] fbcon: radeondrmfb (fb0) is primary device
[    3.404378] Console: switching to colour frame buffer device 175x65
[    3.414137] fb0: radeondrmfb frame buffer device
[    3.414188] drm: registered panic notifier
[    3.414396] [drm] Initialized radeon 2.9.0 20080528 for 0000:01:00.0 on minor 0
[    3.416817] modprobe used greatest stack depth: 5184 bytes left
[    3.453474] dracut: Starting plymouth daemon
[    4.029601] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:03/LNXVIDEO:00/input/input5
[    4.058647] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    4.354184] yenta_cardbus 0000:02:00.0: CardBus bridge found [1014:0552]
[    4.354301] yenta_cardbus 0000:02:00.0: Using INTVAL to route CSC interrupts to PCI
[    4.354387] yenta_cardbus 0000:02:00.0: Routing CardBus interrupts to PCI
[    4.354467] yenta_cardbus 0000:02:00.0: TI: mfunc 0x01d21b22, devctl 0x64
[    4.625794] yenta_cardbus 0000:02:00.0: ISA IRQ mask 0x04b8, PCI irq 11
[    4.625879] yenta_cardbus 0000:02:00.0: Socket status: 30000086
[    4.706450] yenta_cardbus 0000:02:00.0: pcmcia: parent PCI bridge window: [io  0x4000-0x8fff]
[    4.706554] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x4000-0x8fff: excluding 0x4000-0x40ff 0x4400-0x44ff 0x4800-0x48ff 0x4c00-0x4cff 0x8000-0x803f
[    4.966404] yenta_cardbus 0000:02:00.0: pcmcia: parent PCI bridge window: [mem 0xc0200000-0xcfffffff]
[    4.969975] pcmcia_socket pcmcia_socket0: cs: memory probe 0xc0200000-0xcfffffff: excluding 0xc0200000-0xc09fffff 0xc3a00000-0xcc1fffff 0xcfa00000-0xd01fffff
[    4.970561] yenta_cardbus 0000:02:00.0: pcmcia: parent PCI bridge window: [mem 0xe8000000-0xefffffff pref]
[    4.970667] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe8000000-0xefffffff: excluding 0xe8000000-0xefffffff
[    4.985854] yenta_cardbus 0000:02:00.1: CardBus bridge found [1014:0552]
[    4.985971] yenta_cardbus 0000:02:00.1: Using INTVAL to route CSC interrupts to PCI
[    4.986197] yenta_cardbus 0000:02:00.1: Routing CardBus interrupts to PCI
[    4.986278] yenta_cardbus 0000:02:00.1: TI: mfunc 0x01d21b22, devctl 0x64
[    5.220457] yenta_cardbus 0000:02:00.1: ISA IRQ mask 0x04b8, PCI irq 11
[    5.220538] yenta_cardbus 0000:02:00.1: Socket status: 30000086
[    5.220760] yenta_cardbus 0000:02:00.1: pcmcia: parent PCI bridge window: [io  0x4000-0x8fff]
[    5.220852] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x4000-0x8fff: excluding 0x4000-0x40ff 0x4400-0x44ff 0x4800-0x48ff 0x4c00-0x4cff 0x8000-0x803f
[    5.254214] yenta_cardbus 0000:02:00.1: pcmcia: parent PCI bridge window: [mem 0xc0200000-0xcfffffff]
[    5.254311] pcmcia_socket pcmcia_socket1: cs: memory probe 0xc0200000-0xcfffffff: excluding 0xc0200000-0xc09fffff 0xc3a00000-0xcc1fffff 0xcfa00000-0xd01fffff
[    5.254842] yenta_cardbus 0000:02:00.1: pcmcia: parent PCI bridge window: [mem 0xe8000000-0xefffffff pref]
[    5.254946] pcmcia_socket pcmcia_socket1: cs: memory probe 0xe8000000-0xefffffff: excluding 0xe8000000-0xefffffff
[    5.399475] dracut: Scanning devices sda2  for LVM volume groups 
[    5.533375] dracut: Reading all physical volumes. This may take a while...
[    5.533777] dracut: Found volume group "VolGroup00" using metadata type lvm2
[    5.710083] psmouse serio2: ID: 10 00 64
[    6.423185] dracut: 3 logical volume(s) in volume group "VolGroup00" now active
[    6.560615] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    6.657922] dracut: Checking filesystems
[    6.658189] dracut: fsck -T -t noopts=_netdev -A -a
[    6.880526] dracut: F10-PR-i686-Live: clean, 211137/524288 files, 1490030/2097152 blocks
[    6.881332] dracut: Remounting /dev/disk/by-uuid/283c5a40-0759-4b13-83df-deae686190d1 with -o ro,
[    6.908515] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    6.941847] dracut: Mounted root filesystem /dev/mapper/VolGroup00-rootlv
[    7.193870] dracut: Switching root
[    8.164938] type=1404 audit(1306248008.383:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    9.252385] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    9.493896] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input6
[   10.617489] SELinux: 2048 avtab hash slots, 218519 rules.
[   10.905161] SELinux: 2048 avtab hash slots, 218519 rules.
[   12.927104] SELinux:  9 users, 13 roles, 3619 types, 191 bools, 1 sens, 1024 cats
[   12.927113] SELinux:  81 classes, 218519 rules
[   12.961633] SELinux:  Completing initialization.
[   12.961641] SELinux:  Setting up existing superblocks.
[   12.962132] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[   12.962386] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[   12.962700] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[   12.962824] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   12.963372] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   12.963620] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[   12.966416] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[   12.966642] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[   12.983390] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[   12.983643] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[   12.983795] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[   12.984178] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[   12.984488] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   12.984708] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[   12.985159] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[   12.985406] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[   12.985491] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[   12.992042] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   12.992086] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   12.993947] SELinux: initialized (dev dm-0, type ext4), uses xattr
[   13.029291] type=1403 audit(1306248013.248:3): policy loaded auid=4294967295 ses=4294967295
[   13.788944] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   13.794161] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   14.386570] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   14.390167] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   14.393724] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   14.397495] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   14.401296] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   14.405062] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   14.408548] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   14.412102] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   14.415915] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   14.419457] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   14.500400] systemd[1]: systemd 26 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +SYSVINIT +LIBCRYPTSETUP; fedora)
[   14.782292] NET: Registered protocol family 10
[   14.808105] systemd[1]: Set hostname to <t41.thuisdomein>.
[   16.674360] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   16.751478] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   16.805558] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   16.944303] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   16.949482] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   17.747826] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   17.762901] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[   17.873511] EXT4-fs (dm-0): re-mounted. Opts: (null)
[   18.038362] udevd[368]: starting version 170
[   19.922864] intel_rng: FWH not detected
[   20.124069] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: excluding 0x170-0x177 0x1f0-0x1f7 0x2f8-0x2ff
[   20.151457] iTCO_vendor_support: vendor-support=0
[   20.178246]  0x370-0x377
[   20.243529] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: excluding 0x3f0-0x3ff 0x4d0-0x4d7
[   20.261958] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x100-0x3af: excluding 0x170-0x177 0x1f0-0x1f7 0x2f8-0x2ff 0x370-0x377
[   20.312882] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[   20.343618] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
[   20.393678] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x3e0-0x4ff: excluding 0x3f0-0x3ff 0x4d0-0x4d7
[   20.443462] iTCO_wdt: Found a ICH4-M TCO device (Version=1, TCOBASE=0x1060)
[   20.477644] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7:
[   20.489667] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[   20.497117] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   20.513526]  clean.
[   20.540609] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x820-0x8ff: clean.
[   20.611627] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   20.643883] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xd3fff 0xdc000-0xfffff
[   20.686738] parport_pc 00:0b: reported by Plug and Play ACPI
[   20.692598] pcmcia_socket pcmcia_socket1: cs: IO port probe 0xc00-0xcf7: clean.
[   20.777808] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff: clean.
[   20.803900] parport0: PC-style at 0x3bc, irq 7 [PCSPP,TRISTATE]
[   20.815943] e1000 0000:02:01.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
[   20.823595] pcmcia_socket pcmcia_socket1: cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xd3fff 0xdc000-0xfffff
[   20.852999] input: PC Speaker as /devices/platform/pcspkr/input/input7
[   20.858471] i801_smbus 0000:00:1f.3: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
[   20.882768] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
[   21.153644] pcmcia_socket pcmcia_socket1: cs: memory probe 0xa0000000-0xa0ffffff: clean.
[   21.215598] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
[   21.249960] pcmcia_socket pcmcia_socket1: cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
[   21.350644] pcmcia_socket pcmcia_socket1: cs: IO port probe 0xa00-0xaff:
[   21.356905] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   21.364432] thinkpad_acpi: http://ibm-acpi.sf.net/
[   21.368226] thinkpad_acpi: ThinkPad BIOS 1RETDIWW (3.14 ), EC 1RHT71WW-3.04
[   21.372058] thinkpad_acpi: IBM ThinkPad T41 , model        
[   21.375888] thinkpad_acpi: WARNING: Outdated ThinkPad BIOS/EC firmware
[   21.379744] thinkpad_acpi: WARNING: This firmware may be missing critical bug fixes and/or important features
[   21.399469]  clean.
[   21.415465] cfg80211: Calling CRDA to update world regulatory domain
[   21.653464] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[   22.161783] microcode: CPU0 sig=0x695, pf=0x20, revision=0x5
[   22.394510] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked
[   22.590201] Registered led device: tpacpi::thinklight
[   22.590530] Registered led device: tpacpi::power
[   22.590679] Registered led device: tpacpi::standby
[   22.640170] e1000 0000:02:01.0: eth0: (PCI:33MHz:32-bit) [...]
[   22.644695] e1000 0000:02:01.0: eth0: Intel(R) PRO/1000 Network Connection
[   22.990725] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[   23.033475] Intel ICH Modem 0000:00:1f.6: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
[   23.121539] Intel ICH Modem 0000:00:1f.6: setting latency timer to 64
[   23.160806] ath5k 0000:02:02.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
[   23.263177] ath5k 0000:02:02.0: registered as 'phy0'
[   23.300599] Intel ICH 0000:00:1f.5: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
[   23.309178] ppdev: user-space parallel port driver
[   23.335163] Intel ICH 0000:00:1f.5: setting latency timer to 64
[   23.651541] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input8
[   23.821270] ath: EEPROM regdomain: 0x61
[   23.821275] ath: EEPROM indicates we should expect a direct regpair map
[   23.821281] ath: Country alpha2 being used: 00
[   23.821283] ath: Regpair used: 0x61
[   23.997683] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   24.000371] ath5k 0000:02:02.0: wlan0: Features changed: 0x00004800 -> 0x00004000
[   24.012824] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   24.049336] Registered led device: ath5k-phy0::rx
[   24.052254] Registered led device: ath5k-phy0::tx
[   24.052331] ath5k phy0: Atheros AR5212 chip found (MAC: 0x56, PHY: 0x41)
[   24.057224] ath5k phy0: RF5111 5GHz radio found (0x17)
[   24.061868] ath5k phy0: RF2111 2GHz radio found (0x23)
[   24.358075] intel8x0_measure_ac97_clock: measured 50429 usecs (2430 samples)
[   24.363103] intel8x0: clocking to 48000
[   24.952191] cfg80211: World regulatory domain updated:
[   24.956926] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   24.961727] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   24.966528] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   24.971325] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   24.976096] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   24.980840] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   25.522625] Adding 2097148k swap on /dev/mapper/VolGroup00-swaplv.  Priority:0 extents:1 across:2097148k 
[   25.588427] cfg80211: Calling CRDA for country: NL
[   25.684123] cfg80211: Regulatory domain changed to country: NL
[   25.688822] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   25.693827] cfg80211:     (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   25.698598] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   25.703256] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   25.707808] cfg80211:     (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[   25.716708] microcode: CPU0 updated to revision 0x7, date = 2004-11-09
[   27.198250] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   27.251943] SELinux: initialized (dev sda1, type ext4), uses xattr
[   27.353636] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[   27.375528] SELinux: initialized (dev dm-1, type ext4), uses xattr
[   29.765238] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_t:s0 for /var: Permission denied
[   29.797718] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_t:s0 for /var: Permission denied
[   29.806493] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_t:s0 for /var: Permission denied
[   29.824003] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_run_t:s0 for /run: Permission denied
[   29.834244] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_run_t:s0 for /run: Permission denied
[   29.842133] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_run_t:s0 for /run: Permission denied
[   29.850136] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_t:s0 for /var: Permission denied
[   29.858158] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_t:s0 for /var: Permission denied
[   29.870159] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_t:s0 for /var: Permission denied
[   29.878589] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_t:s0 for /var: Permission denied
[   29.886355] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_t:s0 for /var: Permission denied
[   29.894170] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_t:s0 for /var: Permission denied
[   29.902325] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_t:s0 for /var: Permission denied
[   29.910164] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_t:s0 for /var: Permission denied
[   29.917133] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_t:s0 for /var: Permission denied
[   29.922680] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_t:s0 for /var: Permission denied
[   29.926326] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_t:s0 for /var: Permission denied
[   29.929878] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_run_t:s0 for /run: Permission denied
[   29.971472] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_t:s0 for /var: Permission denied
[   29.976732] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_t:s0 for /var: Permission denied
[   29.995363] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:var_run_t:s0 for /run: Permission denied
[   30.005896] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:tmp_t:s0 for /tmp: Permission denied
[   30.026122] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:tmp_t:s0 for /tmp: Permission denied
[   30.030485] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:tmp_t:s0 for /tmp: Permission denied
[   30.043108] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:tmp_t:s0 for /tmp: Permission denied
[   30.052164] systemd-tmpfiles[689]: Failed to set security context system_u:object_r:tmp_t:s0 for /tmp: Permission denied
[   30.479979] /usr/sbin/gpm[703]: *** info [daemon/startup.c(136)]:
[   30.494204] /usr/sbin/gpm[703]: Started gpm successfully. Entered daemon mode.
[   30.568271] avahi-daemon[697]: Found user 'avahi' (UID 497) and group 'avahi' (GID 494).
[   30.577982] avahi-daemon[697]: Successfully dropped root privileges.
[   30.585135] avahi-daemon[697]: avahi-daemon 0.6.30 starting up.
[   31.092713] abrtd[710]: Unrecognized variable 'Kerneloops' in '/etc/abrt/abrt.conf'
[   31.104699] abrtd[710]: Unrecognized variable 'EnabledPlugins' in '/etc/abrt/abrt.conf'
[   31.151115] abrtd[710]: Unrecognized variable 'Python' in '/etc/abrt/abrt.conf'
[   31.175620] abrtd[710]: Unrecognized variable 'Database' in '/etc/abrt/abrt.conf'
[   31.196120] abrtd[710]: Unrecognized variable 'CCpp' in '/etc/abrt/abrt.conf'
[   31.213133] abrtd[710]: Unrecognized variable '120' in '/etc/abrt/abrt.conf'
[   31.256126] abrtd[710]: Unrecognized variable 'OpenGPGPublicKeys' in '/etc/abrt/abrt.conf'
[   32.507682] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   32.569561] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   37.423178] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   37.475333] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   37.922380] Bluetooth: Core ver 2.16
[   37.929831] NET: Registered protocol family 31
[   37.932724] Bluetooth: HCI device and connection manager initialized
[   37.936139] Bluetooth: HCI socket layer initialized
[   37.938964] Bluetooth: L2CAP socket layer initialized
[   37.950769] Bluetooth: SCO socket layer initialized
[   38.067227] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   38.070042] Bluetooth: BNEP filters: protocol multicast
[   43.610662] wlan0: direct probe to [...] (try 1/3)
[   43.616220] wlan0: direct probe responded
[   43.616351] wlan0: authenticate with [...] (try 1)
[   43.617952] wlan0: authenticated
[   43.632115] wlan0: associate with [...] (try 1)
[   43.634128] wlan0: RX AssocResp from [...] (capab=0x411 status=0 aid=1)
[   43.634134] wlan0: associated
[   43.645331] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   46.543500] auditd (1042): /proc/1042/oom_adj is deprecated, please use /proc/1042/oom_score_adj instead.
[   47.643237] P-state transition latency capped at 20 uS
[   54.562091] wlan0: no IPv6 routers present
[  236.276757] cfg80211: Calling CRDA to update world regulatory domain
[  236.332681] cfg80211: World regulatory domain updated:
[  236.336002] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  236.339264] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  236.342505] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  236.345710] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  236.348870] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  236.352006] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  236.364384] cfg80211: Calling CRDA for country: NL
[  236.383648] cfg80211: Regulatory domain changed to country: NL
[  236.386816] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  236.390041] cfg80211:     (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  236.393316] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  236.396524] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  236.399652] cfg80211:     (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[  240.817188] wlan0: authenticate with [...] (try 1)
[  240.819068] wlan0: authenticated
[  240.821645] wlan0: associate with [...] (try 1)
[  240.823698] wlan0: RX ReassocResp from [...] (capab=0x411 status=0 aid=1)
[  240.823704] wlan0: associated
[  462.828090] BUG: unable to handle kernel paging request at 6b6b6b6b
[  462.829020] IP: [<c05ea6a4>] call_for_each_cic+0x29/0x44
[  462.829020] *pde = 00000000 
[  462.829020] Oops: 0000 [#1] SMP 
[  462.829020] last sysfs file: /sys/devices/platform/regulatory.0/uevent
[  462.829020] Modules linked in: cpufreq_ondemand acpi_cpufreq mperf bnep bluetooth ip6t_REJECT nf_conntrack_ipv6 nf_conntrack_netbios_ns nf_conntrack_broadcast nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state ip6table_filter nf_conntrack ip6_tables arc4 ppdev ath5k snd_intel8x0 snd_intel8x0m snd_ac97_codec ath ac97_bus snd_seq mac80211 snd_seq_device microcode snd_pcm thinkpad_acpi snd_timer joydev i2c_i801 pcspkr cfg80211 parport_pc snd_page_alloc snd e1000 soundcore iTCO_wdt parport rfkill iTCO_vendor_support uinput ipv6 yenta_socket video radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
[  462.829020] 
[  462.829020] Pid: 2983, comm: mandb Not tainted 2.6.39-0.local2.fc16.i686 #1 IBM        /       
[  462.829020] EIP: 0060:[<c05ea6a4>] EFLAGS: 00010202 CPU: 0
[  462.829020] EIP is at call_for_each_cic+0x29/0x44
[  462.829020] EAX: 00000001 EBX: 6b6b6b6b ECX: 00000246 EDX: c0aa8a98
[  462.829020] ESI: f6baab00 EDI: c05ea9ab EBP: eda59f18 ESP: eda59f0c
[  462.829020]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  462.829020] Process mandb (pid: 2983, ti=eda58000 task=f2e29530 task.ti=eda58000)
[  462.829020] Stack:
[  462.829020]  f6baab00 f2e29530 f2e29900 eda59f20 c05ea6d1 eda59f2c c05dfd0e f6baab00
[  462.829020]  eda59f40 c05dfd9e f2e29530 00000012 eda59f74 eda59f8c c044149f ef1825dc
[  462.829020]  ef182580 00000009 f2e29530 00000007 f2e29734 f2e29528 f2e29734 00000001
[  462.829020] Call Trace:
[  462.829020]  [<c05ea6d1>] cfq_free_io_context+0x12/0x14
[  462.829020]  [<c05dfd0e>] put_io_context+0x34/0x5c
[  462.829020]  [<c05dfd9e>] exit_io_context+0x68/0x6d
[  462.829020]  [<c044149f>] do_exit+0x63e/0x661
[  462.829020]  [<c04416d9>] do_group_exit+0x63/0x86
[  462.829020]  [<c0441714>] sys_exit_group+0x18/0x18
[  462.829020]  [<c082095f>] sysenter_do_call+0x12/0x38
[  462.829020] Code: 5d c3 55 89 e5 57 56 53 3e 8d 74 26 00 89 c6 89 d7 e8 f3 eb ff ff 8b 5e 4c e8 d5 9d e6 ff 85 c0 74 05 e8 b7 ff ff ff 85 db 74 11 <8b> 03 0f 18 00 90 8d 53 d8 89 f0 ff d7 8b 1b eb dd e8 02 ec ff 
[  462.829020] EIP: [<c05ea6a4>] call_for_each_cic+0x29/0x44 SS:ESP 0068:eda59f0c
[  462.829020] CR2: 000000006b6b6b6b
[  462.963259] ---[ end trace 3109e82224f9ab0c ]---
[  462.967829] Fixing recursive fault but reboot is needed!
[  501.079105] BUG: unable to handle kernel paging request at 6b6b6b6b
[  501.080022] IP: [<c05ea6a4>] call_for_each_cic+0x29/0x44
[  501.080022] *pde = 00000000 
[  501.080022] Oops: 0000 [#2] SMP 
[  501.080022] last sysfs file: /sys/devices/platform/regulatory.0/uevent
[  501.080022] Modules linked in: cpufreq_ondemand acpi_cpufreq mperf bnep bluetooth ip6t_REJECT nf_conntrack_ipv6 nf_conntrack_netbios_ns nf_conntrack_broadcast nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state ip6table_filter nf_conntrack ip6_tables arc4 ppdev ath5k snd_intel8x0 snd_intel8x0m snd_ac97_codec ath ac97_bus snd_seq mac80211 snd_seq_device microcode snd_pcm thinkpad_acpi snd_timer joydev i2c_i801 pcspkr cfg80211 parport_pc snd_page_alloc snd e1000 soundcore iTCO_wdt parport rfkill iTCO_vendor_support uinput ipv6 yenta_socket video radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
[  501.080022] 
[  501.080022] Pid: 9769, comm: mandb Tainted: G      D     2.6.39-0.local2.fc16.i686 #1 IBM        /       
[  501.080022] EIP: 0060:[<c05ea6a4>] EFLAGS: 00010202 CPU: 0
[  501.080022] EIP is at call_for_each_cic+0x29/0x44
[  501.080022] EAX: 00000000 EBX: 6b6b6b6b ECX: 00000286 EDX: 00031179
[  501.080022] ESI: f6baaf00 EDI: c05ea9ab EBP: ef31bf18 ESP: ef31bf0c
[  501.080022]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  501.080022] Process mandb (pid: 9769, ti=ef31a000 task=f65369f0 task.ti=ef31a000)
[  501.080022] Stack:
[  501.080022]  f6baaf00 f65369f0 f6536dc0 ef31bf20 c05ea6d1 ef31bf2c c05dfd0e f6baaf00
[  501.080022]  ef31bf40 c05dfd9e f65369f0 00000012 ef31bf74 ef31bf8c c044149f ef183bdc
[  501.080022]  ef183b80 00000009 f65369f0 00000007 f6536bf4 f65369e8 f6536bf4 00000001
[  501.080022] Call Trace:
[  501.080022]  [<c05ea6d1>] cfq_free_io_context+0x12/0x14
[  501.080022]  [<c05dfd0e>] put_io_context+0x34/0x5c
[  501.080022]  [<c05dfd9e>] exit_io_context+0x68/0x6d
[  501.080022]  [<c044149f>] do_exit+0x63e/0x661
[  501.080022]  [<c04feb69>] ? path_put+0x1a/0x1d
[  501.080022]  [<c04416d9>] do_group_exit+0x63/0x86
[  501.080022]  [<c0441714>] sys_exit_group+0x18/0x18
[  501.080022]  [<c082095f>] sysenter_do_call+0x12/0x38
[  501.080022] Code: 5d c3 55 89 e5 57 56 53 3e 8d 74 26 00 89 c6 89 d7 e8 f3 eb ff ff 8b 5e 4c e8 d5 9d e6 ff 85 c0 74 05 e8 b7 ff ff ff 85 db 74 11 <8b> 03 0f 18 00 90 8d 53 d8 89 f0 ff d7 8b 1b eb dd e8 02 ec ff 
[  501.080022] EIP: [<c05ea6a4>] call_for_each_cic+0x29/0x44 SS:ESP 0068:ef31bf0c
[  501.080022] CR2: 000000006b6b6b6b
[  501.287309] ---[ end trace 3109e82224f9ab0d ]---
[  501.293414] Fixing recursive fault but reboot is needed!
[  519.041105] BUG: unable to handle kernel paging request at 6b6b6b6b
[  519.042023] IP: [<c05ea6a4>] call_for_each_cic+0x29/0x44
[  519.042023] *pde = 00000000 
[  519.042023] Oops: 0000 [#3] SMP 
[  519.042023] last sysfs file: /sys/devices/platform/regulatory.0/uevent
[  519.042023] Modules linked in: cpufreq_ondemand acpi_cpufreq mperf bnep bluetooth ip6t_REJECT nf_conntrack_ipv6 nf_conntrack_netbios_ns nf_conntrack_broadcast nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state ip6table_filter nf_conntrack ip6_tables arc4 ppdev ath5k snd_intel8x0 snd_intel8x0m snd_ac97_codec ath ac97_bus snd_seq mac80211 snd_seq_device microcode snd_pcm thinkpad_acpi snd_timer joydev i2c_i801 pcspkr cfg80211 parport_pc snd_page_alloc snd e1000 soundcore iTCO_wdt parport rfkill iTCO_vendor_support uinput ipv6 yenta_socket video radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
[  519.042023] 
[  519.042023] Pid: 13689, comm: mandb Tainted: G      D     2.6.39-0.local2.fc16.i686 #1 IBM        /       
[  519.042023] EIP: 0060:[<c05ea6a4>] EFLAGS: 00010202 CPU: 0
[  519.042023] EIP is at call_for_each_cic+0x29/0x44
[  519.042023] EAX: 00000000 EBX: 6b6b6b6b ECX: 00000286 EDX: 000357a3
[  519.042023] ESI: edb1d080 EDI: c05ea9ab EBP: eda4bf18 ESP: eda4bf0c
[  519.042023]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  519.042023] Process mandb (pid: 13689, ti=eda4a000 task=ef5369f0 task.ti=eda4a000)
[  519.042023] Stack:
[  519.042023]  edb1d080 ef5369f0 ef536dc0 eda4bf20 c05ea6d1 eda4bf2c c05dfd0e edb1d080
[  519.042023]  eda4bf40 c05dfd9e ef5369f0 00000012 eda4bf74 eda4bf8c c044149f ef1825dc
[  519.042023]  ef182580 00000009 ef5369f0 00000007 ef536bf4 ef5369e8 ef536bf4 00000001
[  519.042023] Call Trace:
[  519.042023]  [<c05ea6d1>] cfq_free_io_context+0x12/0x14
[  519.042023]  [<c05dfd0e>] put_io_context+0x34/0x5c
[  519.042023]  [<c05dfd9e>] exit_io_context+0x68/0x6d
[  519.042023]  [<c044149f>] do_exit+0x63e/0x661
[  519.042023]  [<c04feb69>] ? path_put+0x1a/0x1d
[  519.042023]  [<c04416d9>] do_group_exit+0x63/0x86
[  519.042023]  [<c0441714>] sys_exit_group+0x18/0x18
[  519.042023]  [<c082095f>] sysenter_do_call+0x12/0x38
[  519.042023] Code: 5d c3 55 89 e5 57 56 53 3e 8d 74 26 00 89 c6 89 d7 e8 f3 eb ff ff 8b 5e 4c e8 d5 9d e6 ff 85 c0 74 05 e8 b7 ff ff ff 85 db 74 11 <8b> 03 0f 18 00 90 8d 53 d8 89 f0 ff d7 8b 1b eb dd e8 02 ec ff 
[  519.042023] EIP: [<c05ea6a4>] call_for_each_cic+0x29/0x44 SS:ESP 0068:eda4bf0c
[  519.042023] CR2: 000000006b6b6b6b
[  519.251453] ---[ end trace 3109e82224f9ab0e ]---
[  519.257648] Fixing recursive fault but reboot is needed!
[  648.160192] kworker/u:0 used greatest stack depth: 4708 bytes left


