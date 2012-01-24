Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab2AXO6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 09:58:46 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:47116 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab2AXO6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 09:58:45 -0500
Date: Tue, 24 Jan 2012 09:51:32 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tj@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] memblock: Fix alloc failure due to dumb
 underflow protection in memblock_find_in_range_node ()
Message-ID: <20120124145132.GA30828@phenom.dumpdata.com>
References: <20120113181412.GA11112@google.com>
 <tip-5d53cb27d849c899136c048ec84c940ac449494b@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-5d53cb27d849c899136c048ec84c940ac449494b@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4F1EC70E.013B,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 01:03:50AM -0800, tip-bot for Tejun Heo wrote:
> Commit-ID:  5d53cb27d849c899136c048ec84c940ac449494b
> Gitweb:     http://git.kernel.org/tip/5d53cb27d849c899136c048ec84c940ac449494b
> Author:     Tejun Heo <tj@kernel.org>
> AuthorDate: Fri, 13 Jan 2012 10:14:12 -0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 16 Jan 2012 08:38:06 +0100
> 
> memblock: Fix alloc failure due to dumb underflow protection in memblock_find_in_range_node()
> 
> 7bd0b0f0da ("memblock: Reimplement memblock allocation using
> reverse free area iterator") implemented a simple top-down
> allocator using a reverse memblock iterator.  To avoid underflow
> in the allocator loop, it simply raised the lower boundary to
> the requested size under the assumption that requested size
> would be far smaller than available memblocks.
> 
> This causes early page table allocation failure under certain
> configurations in Xen.  Fix it by checking for underflow directly
> instead of bumping up lower bound.

Well, it fixes my 4GB problem, but when I try to boot a 2GB (1GB of that
is for balloon usage) guest (i386 only) I get a new failure:

> more /mnt/lab/bootstrap-i386/test.xm 
extra="console=hvc0 debug earlyprintk=xen memblock=debug"
kernel="/mnt/lab/bootstrap-i386/vmlinuz"
ramdisk="/mnt/lab/bootstrap-i386/initramfs.cpio.gz"
memory=1024
maxmem=2048
vcpus=2
name="bootstrap-i386"
on_crash="preserve"
vif = [ 'mac=00:0F:4B:00:00:68, bridge=switch' ]
vfb = [ 'vnc=1, vnclisten=0.0.0.0,vncunused=1']
disk=['phy:/dev/vg_guests/bootstrap-i386,xvda,w']

So this is v3.3-rc1 + this patch by itself. Any thoughts of what else
might be amiss?

Using config file "/mnt/lab/bootstrap-i386/test.xm".
Started domain bootstrap-i386 (id=2)
(early) [    0.000000] Reserving virtual address space above 0xf5800000
(early) [    0.000000] Initializing cgroup subsys cpuset
(early) [    0.000000] Initializing cgroup subsys cpu
(early) [    0.000000] Linux version 3.3.0-rc1-00065-gc9d7799 (konrad@build.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP PREEMPT Tue Jan 24 04:34:24 EST 2012
(early) [    0.000000] ACPI in unprivileged domain disabled
(early) [    0.000000] Released 0 pages of unused memory
(early) [    0.000000] Set 0 page(s) to 1-1 mapping
(early) [    0.000000] BIOS-provided physical RAM map:
(early) [    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
(early) [    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
(early) [    0.000000]  Xen: 0000000000100000 - 0000000080800000 (usable)
(early) [    0.000000] bootconsole [xenboot0] enabled
(early) [    0.000000] NX (Execute Disable) protection: active
(early) [    0.000000] DMI not present or invalid.
(early) [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (early) (usable)(early)  ==> (early) (reserved)(early) 
(early) [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (early) (usable)(early) 
(early) [    0.000000] last_pfn = 0x80800 max_arch_pfn = 0x1000000
(early) [    0.000000] memblock_reserve: [0x0000000185a000-0x0000000186b000] setup_arch+0x67a/0xc9e
(early) [    0.000000] MEMBLOCK configuration:
(early) [    0.000000]  memory size = 0x80790000 reserved size = 0x59593000
(early) [    0.000000]  memory.cnt  = 0x2
(early) [    0.000000]  memory[0x0]	[0x00000000010000-0x0000000009ffff], 0x90000 bytes
(early) [    0.000000]  memory[0x1]	[0x00000000100000-0x000000807fffff], 0x80700000 bytes
(early) [    0.000000]  reserved.cnt  = 0x3
(early) [    0.000000]  reserved[0x0]	[0x00000001000000-0x0000000186afff], 0x86b000 bytes
(early) [    0.000000]  reserved[0x1]	[0x00000001ab4000-0x00000019fdbfff], 0x18528000 bytes
(early) [    0.000000]  reserved[0x2]	[0x00000040000000-0x000000807fffff], 0x40800000 bytes
(early) [    0.000000] initial memory mapped : 0 - 1abff000
(early) [    0.000000] memblock_reserve: [0x0000000009c000-0x000000000a0000] setup_trampolines+0x81/0xba
(early) [    0.000000] Base memory trampoline at [c009c000] 9c000 size 16384
(early) [    0.000000] init_memory_mapping: 0000000000000000-000000002d3fe000
(early) [    0.000000]  0000000000 - 002d3fe000 page 4k
(early) [    0.000000] kernel direct mapping tables up to 2d3fe000 @ 1aa92000-1abff000
(early) [    0.000000] memblock_reserve: [0x0000001aa92000-0x0000001ab26000] native_pagetable_reserve+0x22/0x28
(early) [    0.000000] xen: setting RW the range 1ab26000 - 1abff000
(early) [    0.000000]    memblock_free: [0x00000001ab4000-0x00000019e05000] setup_arch+0x7d5/0xc9e
(early) [    0.000000] initrd too large to handle, disabling initrd
(early) [    0.000000] 1332MB HIGHMEM available.
(early) [    0.000000] 723MB LOWMEM available.
(early) [    0.000000]   mapped low ram: 0 - 2d3fe000
(early) [    0.000000]   low ram: 0 - 2d3fe000
(early) [    0.000000] memblock_reserve: [0x0000002d3fd000-0x0000002d3fe000] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] Zone PFN ranges:
(early) [    0.000000]   DMA      (early) 0x00000010 -> 0x00001000
(early) [    0.000000]   Normal   (early) 0x00001000 -> 0x0002d3fe
(early) [    0.000000]   HighMem  (early) 0x0002d3fe -> 0x00080800
(early) [    0.000000] Movable zone start PFN for each node
(early) [    0.000000] Early memory PFN ranges
(early) [    0.000000]     0: 0x00000010 -> 0x000000a0
(early) [    0.000000]     0: 0x00000100 -> 0x00080800
(early) [    0.000000] On node 0 totalpages: 526224
(early) [    0.000000] memblock_reserve: [0x0000002c3ed000-0x0000002d3fd000] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] free_area_init_node: node 0, pgdat c170c540, node_mem_map ec3ed200
(early) [    0.000000]   DMA zone: 32 pages used for memmap
(early) [    0.000000]   DMA zone: 0 pages reserved
(early) [    0.000000]   DMA zone: 3952 pages, LIFO batch:0
(early) [    0.000000] memblock_reserve: [0x0000002c3ecfc0-0x0000002c3ecfc4] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] memblock_reserve: [0x0000002c3ecf00-0x0000002c3ecfc0] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000]   Normal zone: 1416 pages used for memmap
(early) [    0.000000]   Normal zone: 179830 pages, LIFO batch:31
(early) [    0.000000] memblock_reserve: [0x0000002c3ece40-0x0000002c3ecec8] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] memblock_reserve: [0x0000002c3e9e40-0x0000002c3ece40] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000]   HighMem zone: 2665 pages used for memmap
(early) [    0.000000]   HighMem zone: 338329 pages, LIFO batch:31
(early) [    0.000000] memblock_reserve: [0x0000002c3e9d40-0x0000002c3e9e3c] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] memblock_reserve: [0x0000002c3e3d40-0x0000002c3e9d40] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] Using APIC driver default
(early) [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
(early) [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
(early) [    0.000000] APIC: disable apic facility
(early) [    0.000000] APIC: switched to apic NOOP
(early) [    0.000000] nr_irqs_gsi: 16
(early) [    0.000000] memblock_reserve: [0x0000002c3e3c80-0x0000002c3e3d10] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] memblock_reserve: [0x0000002c3e3c40-0x0000002c3e3c80] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] memblock_reserve: [0x0000002c3e3c00-0x0000002c3e3c40] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] memblock_reserve: [0x0000002c3e3bc0-0x0000002c3e3c00] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] memblock_reserve: [0x0000002c3e3b80-0x0000002c3e3b90] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
(early) [    0.000000] Allocating PCI resources starting at 80800000 (gap: 80800000:7f800000)
(early) [    0.000000] Booting paravirtualized kernel on Xen
(early) [    0.000000] Xen version: 4.1-120124 (preserve-AD)
(early) [    0.000000] memblock_reserve: [0x0000002c3e3b40-0x0000002c3e3b72] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] memblock_reserve: [0x0000002c3e3b00-0x0000002c3e3b32] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
(early) [    0.000000] memblock_reserve: [0x0000002c3e2b00-0x0000002c3e3b00] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] memblock_reserve: [0x0000002c3e1b00-0x0000002c3e2b00] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] memblock_reserve: [0x0000002c3c5000-0x0000002c3e1000] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000]    memblock_free: [0x0000002c3d3000-0x0000002c3d3000] free_bootmem+0x2b/0x31
(early) [    0.000000]    memblock_free: [0x0000002c3e1000-0x0000002c3e1000] free_bootmem+0x2b/0x31
(early) [    0.000000] PERCPU: Embedded 14 pages/cpu @ec3c5000 s33600 r0 d23744 u57344
(early) [    0.000000] memblock_reserve: [0x0000002c3e1ac0-0x0000002c3e1ac4] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] memblock_reserve: [0x0000002c3e1a80-0x0000002c3e1a84] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] memblock_reserve: [0x0000002c3e1a40-0x0000002c3e1a48] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] memblock_reserve: [0x0000002c3e1a00-0x0000002c3e1a08] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] pcpu-alloc: s33600 r0 d23744 u57344 alloc=14*4096(early) 
(early) [    0.000000] pcpu-alloc: (early) [0] (early) 0 (early) [0] (early) 1 (early) 
(early) [    0.000000] memblock_reserve: [0x0000002c3e1980-0x0000002c3e19f8] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] memblock_reserve: [0x0000002c3e1940-0x0000002c3e196c] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000]    memblock_free: [0x0000002c3e2b00-0x0000002c3e3b00] free_bootmem+0x2b/0x31
(early) [    0.000000]    memblock_free: [0x0000002c3e1b00-0x0000002c3e2b00] free_bootmem+0x2b/0x31
(early) [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 522111
(early) [    0.000000] Kernel command line: console=hvc0 debug earlyprintk=xen memblock=debug
(early) [    0.000000] memblock_reserve: [0x0000002c3c1000-0x0000002c3c5000] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
(early) [    0.000000] memblock_reserve: [0x0000002c341000-0x0000002c3c1000] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
(early) [    0.000000] memblock_reserve: [0x0000002c301000-0x0000002c341000] __alloc_memory_core_early+0x8c/0xaa
(early) [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
(early) [    0.000000] Initializing CPU#0
(early) [    0.000000] Initializing HighMem for node 0 (0002d3fe:00080800)
(early) [    0.000000] Memory: 1019624k/2105344k available (5450k kernel code, 28504k reserved, 1812k data, 508k init, 307208k highmem)
(early) [    0.000000] virtual kernel memory layout:
(early) [    0.000000]     fixmap  : 0xf5715000 - 0xf57ff000   ( 936 kB)
(early) [    0.000000]     pkmap   : 0xf5400000 - 0xf5600000   (2048 kB)
(early) [    0.000000]     vmalloc : 0xedbfe000 - 0xf53fe000   ( 120 MB)
(early) [    0.000000]     lowmem  : 0xc0000000 - 0xed3fe000   ( 723 MB)
(early) [    0.000000]       .init : 0xc1718000 - 0xc1797000   ( 508 kB)
(early) [    0.000000]       .data : 0xc1552935 - 0xc1717a40   (1812 kB)
(early) [    0.000000]       .text : 0xc1000000 - 0xc1552935   (5450 kB)
(early) [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
(early) [    0.000000] Preemptible hierarchical RCU implementation.
(early) [    0.000000] NR_IRQS:2304 nr_irqs:288 16
(early) [    0.000000] CPU 0 irqstacks, hard=ebc10000 soft=ebc12000
(early) [    0.000000] Console: colour dummy device 80x25
(early) [    0.000000] console [tty0] enabled
[    0.000000] console [hvc0] enabled, bootconsole disabled
(early) [    0.000000] console [hvc0] enabled, bootconsole disabled
[    0.000000] Xen: using vcpuop timer interface
[    0.000000] installing Xen timer for CPU 0
[    0.000000] Detected 3292.620 MHz processor.
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 6585.24 BogoMIPS (lpj=3292620)
[    0.000999] pid_max: default: 32768 minimum: 301
[    0.000999] Security Framework initialized
[    0.000999] SELinux:  Initializing.
[    0.000999] SELinux:  Starting in permissive mode
[    0.000999] Mount-cache hash table entries: 512
[    0.001120] Initializing cgroup subsys cpuacct
[    0.001130] Initializing cgroup subsys freezer
[    0.001263] CPU: Physical Processor ID: 0
[    0.001272] CPU: Processor Core ID: 0
[    0.001280] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.001281] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.001519] SMP alternatives: switching to UP code
[    0.002138] cpu 0 spinlock event irq 17
[    0.002298] Performance Events: unsupported p6 CPU model 42 no PMU driver, software events only.
[    0.008072] NMI watchdog disabled (cpu0): hardware events not enabled
[    0.014031] CPU 1 irqstacks, hard=ebc8a000 soft=ebc8c000
[    0.014041] installing Xen timer for CPU 1
[    0.014116] cpu 1 spinlock event irq 23
[    0.014145] SMP alternatives: switching to SMP code
[    0.000999] Initializing CPU#1
[    0.000999] Disabled fast string operations
[    0.015199] NMI watchdog disabled (cpu1): hardware events not enabled
[    0.017015] Brought up 2 CPUs
[    0.019112] kworker/u:0 used greatest stack depth: 6968 bytes left
[    0.019157] Grant tables using version 2 layout.
[    0.019157] Grant table initialized
[    0.038273] RTC time: 165:165:165, date: 165/165/65
[    0.038580] NET: Registered protocol family 16
[    0.041681] PCI: setting up Xen PCI frontend stub
[    0.041691] PCI: pci_cache_line_size set to 64 bytes
[    0.043149] kworker/u:0 used greatest stack depth: 6928 bytes left
[    0.046216] kworker/u:0 used greatest stack depth: 6784 bytes left
[    0.067350] kworker/u:0 used greatest stack depth: 6620 bytes left
[    0.086154] bio: create slab <bio-0> at 0
[    0.087533] ACPI: Interpreter disabled.
[    0.087647] xen/balloon: Initialising balloon driver.
[    0.092191] xen-balloon: Initialising balloon driver.
[    0.093348] vgaarb: loaded
[    0.095177] usbcore: registered new interface driver usbfs
[    0.095274] usbcore: registered new interface driver hub
[    0.096014] usbcore: registered new device driver usb
[    0.097187] PCI: System does not support PCI
[    0.097187] PCI: System does not support PCI
[    0.098239] NetLabel: Initializing
[    0.098239] NetLabel:  domain hash size = 128
[    0.098239] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.098274] NetLabel:  unlabeled traffic allowed by default
[    0.099464] Switching to clocksource xen
[    0.130294] pnp: PnP ACPI: disabled
[    0.156747] PCI: max bus depth: 0 pci_try_num: 1
[    0.156899] NET: Registered protocol family 2
[    0.157124] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.157918] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.158302] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.158391] TCP: Hash tables configured (established 131072 bind 65536)
[    0.158402] TCP reno registered
[    0.158414] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.158429] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.158763] NET: Registered protocol family 1
[    0.159684] RPC: Registered named UNIX socket transport module.
[    0.159696] RPC: Registered udp transport module.
[    0.159704] RPC: Registered tcp transport module.
[    0.159712] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.159723] PCI: CLS 0 bytes, default 64
[    0.249509] DMA-API: preallocated 32768 debug entries
[    0.249524] DMA-API: debugging enabled by kernel config
[    0.250058] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.250596] Machine check injector initialized
[    0.252469] microcode: no support for this CPU vendor
[    0.254141] audit: initializing netlink socket (disabled)
[    0.254196] type=2000 audit(1327444216.488:1): initialized
[    0.267418] highmem bounce pool size: 64 pages
[    0.267441] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.291085] kworker/u:0 used greatest stack depth: 6588 bytes left
[    0.293529] VFS: Disk quotas dquot_6.5.2
[    0.294081] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.297116] NTFS driver 2.1.30 [Flags: R/W].
[    0.298412] msgmni has been set to 1391
[    0.299046] SELinux:  Registering netfilter hooks
[    0.301611] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.301625] io scheduler noop registered
[    0.301633] io scheduler deadline registered
[    0.301663] io scheduler cfq registered (default)
[    0.302462] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.400113] kworker/u:1 used greatest stack depth: 6496 bytes left
[    0.461905] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.484000] Non-volatile memory driver v1.3
[    0.484022] Linux agpgart interface v0.103
[    0.487010] [drm] Initialized drm 1.1.0 20060810
[    0.502366] brd: module loaded
[    0.510758] loop: module loaded
[    0.512577] Fixed MDIO Bus: probed
[    0.512587] tun: Universal TUN/TAP device driver, 1.6
[    0.512595] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.514744] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.514756] ehci_hcd: block sizes: qh 68 qtd 96 itd 160 sitd 96
[    0.515062] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.515073] ohci_hcd: block sizes: ed 64 td 64
[    0.515319] uhci_hcd: USB Universal Host Controller Interface driver
[    0.515892] usbcore: registered new interface driver usblp
[    0.516182] usbcore: registered new interface driver libusual
[    0.516986] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.517812] i8042: No controller found
[    0.518502] mousedev: PS/2 mouse device common for all mice
[    0.560132] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    0.560440] rtc_cmos: probe of rtc_cmos failed with error -38
[    0.561343] EFI Variables Facility v0.08 2004-May-17
[    0.562715] Netfilter messages via NETLINK v0.30.
[    0.562771] nf_conntrack version 0.5.0 (15931 buckets, 63724 max)
[    0.563857] ctnetlink v0.93: registering with nfnetlink.
[    0.565724] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.565930] TCP cubic registered
[    0.565938] Initializing XFRM netlink socket
[    0.567531] NET: Registered protocol family 10
[    0.570396] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    0.570615] IPv6 over IPv4 tunneling driver
[    0.573725] NET: Registered protocol family 17
[    0.573841] Registering the dns_resolver key type
[    0.573932] Using IPI No-Shortcut mode
[    0.574835] PM: Hibernation image not present or could not be loaded.
[    0.574914] registered taskstats version 1
[    0.575042] kmemleak: Kernel memory leak detector initialized
[    0.575065] kmemleak: Automatic memory scanning thread started
[    0.575189] XENBUS: Device with no driver: device/vkbd/0
[    0.575199] XENBUS: Device with no driver: device/vfb/0
[    0.575208] XENBUS: Device with no driver: device/vbd/51712
[    0.575216] XENBUS: Device with no driver: device/vif/0
[    0.575225] XENBUS: Device with no driver: device/console/0
[    0.575248]   Magic number: 1:252:3141
[    0.576109] Root-NFS: no NFS server address
[    0.576118] VFS: Unable to mount root fs via NFS, trying floppy.
[    0.576215] VFS: Cannot open root device "(null)" or unknown-block(2,0)
[    0.576224] Please append a correct "root=" boot option; here are the available partitions:
[    0.576244] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(2,0)
