Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1AFCMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 21:12:24 -0500
Received: from lo.gmane.org ([80.91.229.12]:37861 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab1AFCMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:12:21 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jongman Heo <jongman.heo@gmail.com>
Subject: Re: [announce] vfs-scale git tree update
Date: Thu, 6 Jan 2011 02:12:00 +0000 (UTC)
Message-ID: <loom.20110106T030535-794@post.gmane.org>
References: <20110105102534.GA6679@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 210.94.41.89 (Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; MS-RTC LM 8; .NET4.0C; .NET4.0E))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin <at> kernel.dk> writes:

> 
> Git tree is here:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
> 
> Branch is:
> 
>     vfs-scale-working
> 

I've observed issue with this vfs-scaling patch.

It makes the boot time of my Fedora14 on vmware much slower, while Ubuntu 
(native, not on vmware) has no problem.


d89026e3696ae23915a7c136f78331f8ac03b0f7 is the first bad commit


# git bisect log
git bisect start
# bad: [c88765adbf7f372704f59d83a55312da50c51e26] fs: scale mntget/mntput
git bisect bad c88765adbf7f372704f59d83a55312da50c51e26
# good: [3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5] Linux 2.6.37
git bisect good 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5
# good: [e4739b72fe130d80a5cdfbff22b97ee789d8c74a] fs: dcache reduce locking 
in d_alloc
git bisect good e4739b72fe130d80a5cdfbff22b97ee789d8c74a
# good: [d5d8cfe548795161cf2fa18f3a4be966948d5e42] fs: dcache remove d_mounted
git bisect good d5d8cfe548795161cf2fa18f3a4be966948d5e42
# bad: [2fe33148ace1731d56582311f0cece0f31d6a823] bit_spinlock: add required 
includes
git bisect bad 2fe33148ace1731d56582311f0cece0f31d6a823
# bad: [d89026e3696ae23915a7c136f78331f8ac03b0f7] fs: d_revalidate_rcu for rcu-
walk
git bisect bad d89026e3696ae23915a7c136f78331f8ac03b0f7
# good: [98731408020029c26092508e5725541d32d3ebbe] fs: cache optimise dentry 
and inode for rcu-walk
git bisect good 98731408020029c26092508e5725541d32d3ebbe


Attached dmesg for both cases. See microcode part for detail.

 dmesg_d89026e_bad
==============================================================
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37-vfs+ (root@hjongman) (gcc version 4.5.1 
20100924 (Red Hat 4.5.1-4) (GCC) ) #68 SMP Thu Jan 6 14:36:25 KST 2011
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 00000000000e4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fef0000 (usable)
[    0.000000]  BIOS-e820: 000000003fef0000 - 000000003feff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003feff000 - 000000003ff00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-
PAE kernel!
[    0.000000] DMI present.
[    0.000000] DMI: 440BX Desktop Reference Platform/VMware Virtual Platform, 
BIOS 6.00 12/31/2009
[    0.000000] Hypervisor detected: VMware
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) 
==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x40000 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-protect
[    0.000000]   CC000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FFC0000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
[    0.000000] found SMP MP-table at [c00f69b0] f69b0
[    0.000000] initial memory mapped : 0 - 01000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ ffb000-1000000
[    0.000000] RAMDISK: 37bd9000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 373e7000 - 377fd07b
[    0.000000] Move RAMDISK from 0000000037bd9000 - 0000000037fef07a to 
373e7000 - 377fd07a
[    0.000000] ACPI: RSDP 000f6940 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 3fef06c4 0004C (v01 INTEL  440BX    06040000 VMW  
01324272)
[    0.000000] ACPI: FACP 3fefee98 000F4 (v04 INTEL  440BX    06040000 PTL  
000F4240)
[    0.000000] ACPI: DSDT 3fef08a6 0E5F2 (v01 PTLTD  Custom   06040000 MSFT 
03000001)
[    0.000000] ACPI: FACS 3fefffc0 00040
[    0.000000] ACPI: BOOT 3fef087e 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 
00000001)
[    0.000000] ACPI: APIC 3fef0804 0007A (v01 PTLTD  ? APIC   06040000  LTP 
00000000)
[    0.000000] ACPI: MCFG 3fef07c8 0003C (v01 PTLTD  $PCITBL$ 06040000  LTP 
00000001)
[    0.000000] ACPI: SRAT 3fef0748 00080 (v02 VMWARE MEMPLUG  06040000 VMW  
00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 136MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x00040000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fef0
[    0.000000]     0: 0x0003ff00 -> 0x00040000
[    0.000000] On node 0 totalpages: 262015
[    0.000000] free_area_init_node: node 0, pgdat c09d9b80, node_mem_map 
f6be6200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 273 pages used for memmap
[    0.000000]   HighMem zone: 34529 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000ca000
[    0.000000] PM: Registered nosave memory: 00000000000ca000 - 
00000000000cc000
[    0.000000] PM: Registered nosave memory: 00000000000cc000 - 
00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 
00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 
00000000000e8000
[    0.000000] PM: Registered nosave memory: 00000000000e8000 - 
0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 
40000000:a0000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 
nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f6400000 s27520 r0 d21632 
u1048576
[    0.000000] pcpu-alloc: s27520 r0 d21632 u1048576 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 259966
[    0.000000] Kernel command line: ro root=UUID=52b8b36e-580a-4b9d-ac9f-
ee1b9b349fdf rd_NO_LUKS rd_NO_LVM rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 
SYSFONT=latarcyrheb-sun16 KEYTABLE=us rhgb quiet
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 5242560 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want 
memory cgroups
[    0.000000] Initializing HighMem for node 0 (000377fe:00040000)
[    0.000000] Memory: 1022280k/1048576k available (3818k kernel code, 25780k 
reserved, 2295k data, 440k init, 139208k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6d000 - 0xfffff000   (1608 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc09f9000 - 0xc0a67000   ( 440 kB)
[    0.000000]       .data : 0xc07ba886 - 0xc09f8708   (2295 kB)
[    0.000000]       .text : 0xc0400000 - 0xc07ba886   (3818 kB)
[    0.000000] Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, 
Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:512
[    0.000000] CPU 0 irqstacks, hard=f5808000 soft=f580a000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.003333] TSC freq read from hypervisor : 2394.219 MHz
[    0.003333] Detected 2394.219 MHz processor.
[    0.000009] Calibrating delay loop (skipped) preset value.. 4790.95 
BogoMIPS (lpj=7980730)
[    0.000013] pid_max: default: 32768 minimum: 301
[    0.000054] Security Framework initialized
[    0.000066] SELinux:  Initializing.
[    0.000082] SELinux:  Starting in permissive mode
[    0.000115] Mount-cache hash table entries: 512
[    0.000403] Initializing cgroup subsys debug
[    0.000407] Initializing cgroup subsys ns
[    0.000414] ns_cgroup deprecated: consider using the 'clone_children' flag 
without the ns_cgroup.
[    0.000416] Initializing cgroup subsys cpuacct
[    0.000422] Initializing cgroup subsys memory
[    0.000433] Initializing cgroup subsys devices
[    0.000438] Initializing cgroup subsys freezer
[    0.000440] Initializing cgroup subsys net_cls
[    0.000447] Initializing cgroup subsys blkio
[    0.000507] CPU: Physical Processor ID: 0
[    0.000509] CPU: Processor Core ID: 0
[    0.000527] mce: CPU supports 0 MCE banks
[    0.000556] Performance Events: Westmere events, Broken PMU hardware 
detected, software events only.
[    0.002146] ACPI: Core revision 20101013
[    0.021997] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.024034] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.058449] CPU0: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz stepping 
02
[    0.167246] NMI watchdog disabled for cpu0: unable to create perf event: -2
[    0.168353] CPU 1 irqstacks, hard=f58c2000 soft=f58c4000
[    0.168367] Booting Node   0, Processors  #1
[    0.180812] Initializing CPU#1
[    0.181368] mce: CPU supports 0 MCE banks
[    0.181542] NMI watchdog disabled for cpu1: unable to create perf event: -2
[    0.182022] CPU 2 irqstacks, hard=f58ce000 soft=f58d0000
[    0.182025]  #2
[    0.192765] Initializing CPU#2
[    0.193222] mce: CPU supports 0 MCE banks
[    0.193391] NMI watchdog disabled for cpu2: unable to create perf event: -2
[    0.193621] CPU 3 irqstacks, hard=f58f8000 soft=f58fa000
[    0.193624]  #3 Ok.
[    0.204293] Initializing CPU#3
[    0.204937] mce: CPU supports 0 MCE banks
[    0.205020] Skipped synchronization checks as TSC is reliable.
[    0.205067] NMI watchdog disabled for cpu3: unable to create perf event: -2
[    0.205148] Brought up 4 CPUs
[    0.205150] Total of 4 processors activated (19161.82 BogoMIPS).
[    0.227350] x86 PAT enabled: cpu 2, old 0x0, new 0x7010600070106
[    0.227433] x86 PAT enabled: cpu 3, old 0x0, new 0x7010600070106
[    0.234697] x86 PAT enabled: cpu 1, old 0x0, new 0x7010600070106
[    0.242766] devtmpfs: initialized
[    0.243853] regulator: core version 0.5
[    0.243896] regulator: dummy: 
[    0.243990] Time: 14:38:45  Date: 01/06/11
[    0.244046] NET: Registered protocol family 16
[    0.244256] ACPI: bus type pci registered
[    0.244540] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-
0xefffffff] (base 0xe0000000)
[    0.244544] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.244546] PCI: Using MMCONFIG for extended config space
[    0.244547] PCI: Using configuration type 1 for base access
[    0.246298] bio: create slab <bio-0> at 0
[    0.249772] ACPI: EC: Look up EC in DSDT
[    0.256794] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.290622] ACPI: Interpreter enabled
[    0.290633] ACPI: (supports S0 S1 S4 S5)
[    0.290663] ACPI: Using IOAPIC for interrupt routing
[    0.293003] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.293075] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.307872] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.339809] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.356505] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.358333] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.360445] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.381342] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.381449] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.391957] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.399419] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.409447] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.419375] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.431867] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.451912] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.469358] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.476921] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.476936] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.476948] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.476960] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.476971] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.476982] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.476994] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.477008] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.477025] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.477048] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.477059] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.477071] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.477082] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.477093] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.477105] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.516870] ACPI: No dock devices found.
[    0.516882] PCI: Using host bridge windows from ACPI; if necessary, 
use "pci=nocrs" and report a bug
[    0.519077] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.523054] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-
0x000bffff]
[    0.523061] pci_root PNP0A03:00: host bridge window [mem 0x000cc000-
0x000cffff]
[    0.523066] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-
0x000d3fff]
[    0.523071] pci_root PNP0A03:00: host bridge window [mem 0x000d4000-
0x000d7fff]
[    0.523075] pci_root PNP0A03:00: host bridge window [mem 0x000d8000-
0x000dbfff]
[    0.523080] pci_root PNP0A03:00: host bridge window [mem 0x000e4000-
0x000e7fff]
[    0.523086] pci_root PNP0A03:00: host bridge window [mem 0x40000000-
0xfebfffff]
[    0.523091] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.523095] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xfeff]
[    0.523279] pci 0000:00:00.0: [8086:7190] type 0 class 0x000600
[    0.524470] pci 0000:00:01.0: [8086:7191] type 1 class 0x000604
[    0.524968] pci 0000:00:07.0: [8086:7110] type 0 class 0x000601
[    0.525680] pci 0000:00:07.1: [8086:7111] type 0 class 0x000101
[    0.528871] pci 0000:00:07.1: reg 20: [io  0x10c0-0x10cf]
[    0.530307] pci 0000:00:07.3: [8086:7113] type 0 class 0x000680
[    0.530936] pci 0000:00:07.3: quirk: [io  0x1000-0x103f] claimed by PIIX4 
ACPI
[    0.530951] pci 0000:00:07.3: quirk: [io  0x1040-0x104f] claimed by PIIX4 
SMB
[    0.531145] pci 0000:00:07.7: [15ad:0740] type 0 class 0x000880
[    0.531880] pci 0000:00:07.7: reg 10: [io  0x1080-0x10bf]
[    0.535740] pci 0000:00:0f.0: [15ad:0405] type 0 class 0x000300
[    0.553294] pci 0000:00:0f.0: reg 10: [io  0x10d0-0x10df]
[    0.572087] pci 0000:00:0f.0: reg 14: [mem 0xd0000000-0xd7ffffff]
[    0.592483] pci 0000:00:0f.0: reg 18: [mem 0xd8000000-0xd87fffff]
[    0.661040] pci 0000:00:0f.0: reg 30: [mem 0x00000000-0x00007fff pref]
[    0.661355] pci 0000:00:10.0: [1000:0030] type 0 class 0x000100
[    0.663108] pci 0000:00:10.0: reg 10: [io  0x1400-0x14ff]
[    0.665461] pci 0000:00:10.0: reg 14: [mem 0xd8820000-0xd883ffff 64bit]
[    0.667915] pci 0000:00:10.0: reg 1c: [mem 0xd8800000-0xd881ffff 64bit]
[    0.671309] pci 0000:00:10.0: reg 30: [mem 0x00000000-0x00003fff pref]
[    0.671526] pci 0000:00:11.0: [15ad:0790] type 1 class 0x000604
[    0.672355] pci 0000:00:15.0: [15ad:07a0] type 1 class 0x000604
[    0.673081] pci 0000:00:15.0: PME# supported from D0 D3hot D3cold
[    0.673110] pci 0000:00:15.0: PME# disabled
[    0.673398] pci 0000:00:15.1: [15ad:07a0] type 1 class 0x000604
[    0.674106] pci 0000:00:15.1: PME# supported from D0 D3hot D3cold
[    0.674134] pci 0000:00:15.1: PME# disabled
[    0.674434] pci 0000:00:15.2: [15ad:07a0] type 1 class 0x000604
[    0.675111] pci 0000:00:15.2: PME# supported from D0 D3hot D3cold
[    0.675139] pci 0000:00:15.2: PME# disabled
[    0.675425] pci 0000:00:15.3: [15ad:07a0] type 1 class 0x000604
[    0.676102] pci 0000:00:15.3: PME# supported from D0 D3hot D3cold
[    0.676130] pci 0000:00:15.3: PME# disabled
[    0.676467] pci 0000:00:15.4: [15ad:07a0] type 1 class 0x000604
[    0.677147] pci 0000:00:15.4: PME# supported from D0 D3hot D3cold
[    0.677176] pci 0000:00:15.4: PME# disabled
[    0.677513] pci 0000:00:15.5: [15ad:07a0] type 1 class 0x000604
[    0.678203] pci 0000:00:15.5: PME# supported from D0 D3hot D3cold
[    0.678235] pci 0000:00:15.5: PME# disabled
[    0.678522] pci 0000:00:15.6: [15ad:07a0] type 1 class 0x000604
[    0.679206] pci 0000:00:15.6: PME# supported from D0 D3hot D3cold
[    0.679234] pci 0000:00:15.6: PME# disabled
[    0.679520] pci 0000:00:15.7: [15ad:07a0] type 1 class 0x000604
[    0.680197] pci 0000:00:15.7: PME# supported from D0 D3hot D3cold
[    0.680225] pci 0000:00:15.7: PME# disabled
[    0.680513] pci 0000:00:16.0: [15ad:07a0] type 1 class 0x000604
[    0.681198] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.681226] pci 0000:00:16.0: PME# disabled
[    0.681587] pci 0000:00:16.1: [15ad:07a0] type 1 class 0x000604
[    0.682264] pci 0000:00:16.1: PME# supported from D0 D3hot D3cold
[    0.682293] pci 0000:00:16.1: PME# disabled
[    0.682579] pci 0000:00:16.2: [15ad:07a0] type 1 class 0x000604
[    0.683255] pci 0000:00:16.2: PME# supported from D0 D3hot D3cold
[    0.683283] pci 0000:00:16.2: PME# disabled
[    0.683569] pci 0000:00:16.3: [15ad:07a0] type 1 class 0x000604
[    0.684281] pci 0000:00:16.3: PME# supported from D0 D3hot D3cold
[    0.684311] pci 0000:00:16.3: PME# disabled
[    0.684600] pci 0000:00:16.4: [15ad:07a0] type 1 class 0x000604
[    0.685280] pci 0000:00:16.4: PME# supported from D0 D3hot D3cold
[    0.685308] pci 0000:00:16.4: PME# disabled
[    0.685595] pci 0000:00:16.5: [15ad:07a0] type 1 class 0x000604
[    0.686274] pci 0000:00:16.5: PME# supported from D0 D3hot D3cold
[    0.686302] pci 0000:00:16.5: PME# disabled
[    0.686692] pci 0000:00:16.6: [15ad:07a0] type 1 class 0x000604
[    0.687377] pci 0000:00:16.6: PME# supported from D0 D3hot D3cold
[    0.687405] pci 0000:00:16.6: PME# disabled
[    0.687706] pci 0000:00:16.7: [15ad:07a0] type 1 class 0x000604
[    0.688384] pci 0000:00:16.7: PME# supported from D0 D3hot D3cold
[    0.688412] pci 0000:00:16.7: PME# disabled
[    0.688699] pci 0000:00:17.0: [15ad:07a0] type 1 class 0x000604
[    0.689403] pci 0000:00:17.0: PME# supported from D0 D3hot D3cold
[    0.689432] pci 0000:00:17.0: PME# disabled
[    0.689721] pci 0000:00:17.1: [15ad:07a0] type 1 class 0x000604
[    0.690401] pci 0000:00:17.1: PME# supported from D0 D3hot D3cold
[    0.690429] pci 0000:00:17.1: PME# disabled
[    0.690718] pci 0000:00:17.2: [15ad:07a0] type 1 class 0x000604
[    0.691451] pci 0000:00:17.2: PME# supported from D0 D3hot D3cold
[    0.691480] pci 0000:00:17.2: PME# disabled
[    0.691769] pci 0000:00:17.3: [15ad:07a0] type 1 class 0x000604
[    0.692445] pci 0000:00:17.3: PME# supported from D0 D3hot D3cold
[    0.692473] pci 0000:00:17.3: PME# disabled
[    0.692775] pci 0000:00:17.4: [15ad:07a0] type 1 class 0x000604
[    0.693452] pci 0000:00:17.4: PME# supported from D0 D3hot D3cold
[    0.693480] pci 0000:00:17.4: PME# disabled
[    0.693766] pci 0000:00:17.5: [15ad:07a0] type 1 class 0x000604
[    0.694464] pci 0000:00:17.5: PME# supported from D0 D3hot D3cold
[    0.694493] pci 0000:00:17.5: PME# disabled
[    0.694781] pci 0000:00:17.6: [15ad:07a0] type 1 class 0x000604
[    0.695460] pci 0000:00:17.6: PME# supported from D0 D3hot D3cold
[    0.695488] pci 0000:00:17.6: PME# disabled
[    0.695776] pci 0000:00:17.7: [15ad:07a0] type 1 class 0x000604
[    0.696952] pci 0000:00:17.7: PME# supported from D0 D3hot D3cold
[    0.696981] pci 0000:00:17.7: PME# disabled
[    0.697271] pci 0000:00:18.0: [15ad:07a0] type 1 class 0x000604
[    0.697964] pci 0000:00:18.0: PME# supported from D0 D3hot D3cold
[    0.697993] pci 0000:00:18.0: PME# disabled
[    0.698280] pci 0000:00:18.1: [15ad:07a0] type 1 class 0x000604
[    0.698979] pci 0000:00:18.1: PME# supported from D0 D3hot D3cold
[    0.699008] pci 0000:00:18.1: PME# disabled
[    0.699296] pci 0000:00:18.2: [15ad:07a0] type 1 class 0x000604
[    0.699974] pci 0000:00:18.2: PME# supported from D0 D3hot D3cold
[    0.700002] pci 0000:00:18.2: PME# disabled
[    0.700292] pci 0000:00:18.3: [15ad:07a0] type 1 class 0x000604
[    0.700979] pci 0000:00:18.3: PME# supported from D0 D3hot D3cold
[    0.701008] pci 0000:00:18.3: PME# disabled
[    0.701297] pci 0000:00:18.4: [15ad:07a0] type 1 class 0x000604
[    0.702013] pci 0000:00:18.4: PME# supported from D0 D3hot D3cold
[    0.702042] pci 0000:00:18.4: PME# disabled
[    0.702331] pci 0000:00:18.5: [15ad:07a0] type 1 class 0x000604
[    0.703008] pci 0000:00:18.5: PME# supported from D0 D3hot D3cold
[    0.703037] pci 0000:00:18.5: PME# disabled
[    0.703324] pci 0000:00:18.6: [15ad:07a0] type 1 class 0x000604
[    0.704029] pci 0000:00:18.6: PME# supported from D0 D3hot D3cold
[    0.704055] pci 0000:00:18.6: PME# disabled
[    0.704330] pci 0000:00:18.7: [15ad:07a0] type 1 class 0x000604
[    0.704951] pci 0000:00:18.7: PME# supported from D0 D3hot D3cold
[    0.704977] pci 0000:00:18.7: PME# disabled
[    0.705663] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.705689] pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.705715] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff] 
(disabled)
[    0.705741] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff 
pref] (disabled)
[    0.706027] pci 0000:02:00.0: [8086:7112] type 0 class 0x000c03
[    0.709360] pci 0000:02:00.0: reg 20: [io  0x20c0-0x20df]
[    0.711130] pci 0000:02:01.0: [1022:2000] type 0 class 0x000200
[    0.712062] pci 0000:02:01.0: reg 10: [io  0x2000-0x207f]
[    0.717038] pci 0000:02:01.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.717235] pci 0000:02:02.0: [1274:1371] type 0 class 0x000401
[    0.718033] pci 0000:02:02.0: reg 10: [io  0x2080-0x20bf]
[    0.723730] pci 0000:02:03.0: [15ad:0770] type 0 class 0x000c03
[    0.724650] pci 0000:02:03.0: reg 10: [mem 0xd8900000-0xd8900fff]
[    0.730489] pci 0000:00:11.0: PCI bridge to [bus 02-02] (subtractive decode)
[    0.730516] pci 0000:00:11.0:   bridge window [io  0x2000-0x3fff]
[    0.730542] pci 0000:00:11.0:   bridge window [mem 0xd8900000-0xd9cfffff]
[    0.730591] pci 0000:00:11.0:   bridge window [mem 0xdc400000-0xdc9fffff 
64bit pref]
[    0.730594] pci 0000:00:11.0:   bridge window [mem 0x000a0000-0x000bffff] 
(subtractive decode)
[    0.730596] pci 0000:00:11.0:   bridge window [mem 0x000cc000-0x000cffff] 
(subtractive decode)
[    0.730598] pci 0000:00:11.0:   bridge window [mem 0x000d0000-0x000d3fff] 
(subtractive decode)
[    0.730600] pci 0000:00:11.0:   bridge window [mem 0x000d4000-0x000d7fff] 
(subtractive decode)
[    0.730602] pci 0000:00:11.0:   bridge window [mem 0x000d8000-0x000dbfff] 
(subtractive decode)
[    0.730604] pci 0000:00:11.0:   bridge window [mem 0x000e4000-0x000e7fff] 
(subtractive decode)
[    0.730606] pci 0000:00:11.0:   bridge window [mem 0x40000000-0xfebfffff] 
(subtractive decode)
[    0.730608] pci 0000:00:11.0:   bridge window [io  0x0000-0x0cf7] 
(subtractive decode)
[    0.730611] pci 0000:00:11.0:   bridge window [io  0x0d00-0xfeff] 
(subtractive decode)
[    0.731188] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    0.731214] pci 0000:00:15.0:   bridge window [io  0x4000-0x4fff]
[    0.731240] pci 0000:00:15.0:   bridge window [mem 0xd9d00000-0xd9dfffff]
[    0.731361] pci 0000:00:15.0:   bridge window [mem 0xdca00000-0xdcafffff 
64bit pref]
[    0.731923] pci 0000:00:15.1: PCI bridge to [bus 04-04]
[    0.731950] pci 0000:00:15.1:   bridge window [io  0x8000-0x8fff]
[    0.731975] pci 0000:00:15.1:   bridge window [mem 0xda100000-0xda1fffff]
[    0.732024] pci 0000:00:15.1:   bridge window [mem 0xdce00000-0xdcefffff 
64bit pref]
[    0.732571] pci 0000:00:15.2: PCI bridge to [bus 05-05]
[    0.732597] pci 0000:00:15.2:   bridge window [io  0xc000-0xcfff]
[    0.732623] pci 0000:00:15.2:   bridge window [mem 0xda500000-0xda5fffff]
[    0.732672] pci 0000:00:15.2:   bridge window [mem 0xdd200000-0xdd2fffff 
64bit pref]
[    0.733220] pci 0000:00:15.3: PCI bridge to [bus 06-06]
[    0.733250] pci 0000:00:15.3:   bridge window [io  0xf000-0x0000] (disabled)
[    0.733276] pci 0000:00:15.3:   bridge window [mem 0xda900000-0xda9fffff]
[    0.733325] pci 0000:00:15.3:   bridge window [mem 0xdd600000-0xdd6fffff 
64bit pref]
[    0.733922] pci 0000:00:15.4: PCI bridge to [bus 07-07]
[    0.733948] pci 0000:00:15.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.733974] pci 0000:00:15.4:   bridge window [mem 0xdad00000-0xdadfffff]
[    0.734028] pci 0000:00:15.4:   bridge window [mem 0xdda00000-0xddafffff 
64bit pref]
[    0.734600] pci 0000:00:15.5: PCI bridge to [bus 08-08]
[    0.734626] pci 0000:00:15.5:   bridge window [io  0xf000-0x0000] (disabled)
[    0.734652] pci 0000:00:15.5:   bridge window [mem 0xdb100000-0xdb1fffff]
[    0.734700] pci 0000:00:15.5:   bridge window [mem 0xdde00000-0xddefffff 
64bit pref]
[    0.735247] pci 0000:00:15.6: PCI bridge to [bus 09-09]
[    0.735273] pci 0000:00:15.6:   bridge window [io  0xf000-0x0000] (disabled)
[    0.735300] pci 0000:00:15.6:   bridge window [mem 0xdb500000-0xdb5fffff]
[    0.735348] pci 0000:00:15.6:   bridge window [mem 0xde200000-0xde2fffff 
64bit pref]
[    0.735893] pci 0000:00:15.7: PCI bridge to [bus 0a-0a]
[    0.735920] pci 0000:00:15.7:   bridge window [io  0xf000-0x0000] (disabled)
[    0.735946] pci 0000:00:15.7:   bridge window [mem 0xdb900000-0xdb9fffff]
[    0.735994] pci 0000:00:15.7:   bridge window [mem 0xde600000-0xde6fffff 
64bit pref]
[    0.736649] pci 0000:00:16.0: PCI bridge to [bus 0b-0b]
[    0.736676] pci 0000:00:16.0:   bridge window [io  0x5000-0x5fff]
[    0.736702] pci 0000:00:16.0:   bridge window [mem 0xd9e00000-0xd9efffff]
[    0.736751] pci 0000:00:16.0:   bridge window [mem 0xdcb00000-0xdcbfffff 
64bit pref]
[    0.737306] pci 0000:00:16.1: PCI bridge to [bus 0c-0c]
[    0.737333] pci 0000:00:16.1:   bridge window [io  0x9000-0x9fff]
[    0.737358] pci 0000:00:16.1:   bridge window [mem 0xda200000-0xda2fffff]
[    0.737407] pci 0000:00:16.1:   bridge window [mem 0xdcf00000-0xdcffffff 
64bit pref]
[    0.737962] pci 0000:00:16.2: PCI bridge to [bus 0d-0d]
[    0.737988] pci 0000:00:16.2:   bridge window [io  0xd000-0xdfff]
[    0.738014] pci 0000:00:16.2:   bridge window [mem 0xda600000-0xda6fffff]
[    0.738063] pci 0000:00:16.2:   bridge window [mem 0xdd300000-0xdd3fffff 
64bit pref]
[    0.738608] pci 0000:00:16.3: PCI bridge to [bus 0e-0e]
[    0.738635] pci 0000:00:16.3:   bridge window [io  0xf000-0x0000] (disabled)
[    0.738660] pci 0000:00:16.3:   bridge window [mem 0xdaa00000-0xdaafffff]
[    0.738709] pci 0000:00:16.3:   bridge window [mem 0xdd700000-0xdd7fffff 
64bit pref]
[    0.739283] pci 0000:00:16.4: PCI bridge to [bus 0f-0f]
[    0.739309] pci 0000:00:16.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.739335] pci 0000:00:16.4:   bridge window [mem 0xdae00000-0xdaefffff]
[    0.739384] pci 0000:00:16.4:   bridge window [mem 0xddb00000-0xddbfffff 
64bit pref]
[    0.739929] pci 0000:00:16.5: PCI bridge to [bus 10-10]
[    0.739955] pci 0000:00:16.5:   bridge window [io  0xf000-0x0000] (disabled)
[    0.739980] pci 0000:00:16.5:   bridge window [mem 0xdb200000-0xdb2fffff]
[    0.740029] pci 0000:00:16.5:   bridge window [mem 0xddf00000-0xddffffff 
64bit pref]
[    0.740579] pci 0000:00:16.6: PCI bridge to [bus 11-11]
[    0.740605] pci 0000:00:16.6:   bridge window [io  0xf000-0x0000] (disabled)
[    0.740631] pci 0000:00:16.6:   bridge window [mem 0xdb600000-0xdb6fffff]
[    0.740679] pci 0000:00:16.6:   bridge window [mem 0xde300000-0xde3fffff 
64bit pref]
[    0.741235] pci 0000:00:16.7: PCI bridge to [bus 12-12]
[    0.741261] pci 0000:00:16.7:   bridge window [io  0xf000-0x0000] (disabled)
[    0.741345] pci 0000:00:16.7:   bridge window [mem 0xdba00000-0xdbafffff]
[    0.741399] pci 0000:00:16.7:   bridge window [mem 0xde700000-0xde7fffff 
64bit pref]
[    0.741977] pci 0000:00:17.0: PCI bridge to [bus 13-13]
[    0.742007] pci 0000:00:17.0:   bridge window [io  0x6000-0x6fff]
[    0.742032] pci 0000:00:17.0:   bridge window [mem 0xd9f00000-0xd9ffffff]
[    0.742081] pci 0000:00:17.0:   bridge window [mem 0xdcc00000-0xdccfffff 
64bit pref]
[    0.742628] pci 0000:00:17.1: PCI bridge to [bus 14-14]
[    0.742653] pci 0000:00:17.1:   bridge window [io  0xa000-0xafff]
[    0.742679] pci 0000:00:17.1:   bridge window [mem 0xda300000-0xda3fffff]
[    0.742728] pci 0000:00:17.1:   bridge window [mem 0xdd000000-0xdd0fffff 
64bit pref]
[    0.743272] pci 0000:00:17.2: PCI bridge to [bus 15-15]
[    0.743298] pci 0000:00:17.2:   bridge window [io  0xe000-0xefff]
[    0.743324] pci 0000:00:17.2:   bridge window [mem 0xda700000-0xda7fffff]
[    0.743373] pci 0000:00:17.2:   bridge window [mem 0xdd400000-0xdd4fffff 
64bit pref]
[    0.744267] pci 0000:00:17.3: PCI bridge to [bus 16-16]
[    0.744296] pci 0000:00:17.3:   bridge window [io  0xf000-0x0000] (disabled)
[    0.744325] pci 0000:00:17.3:   bridge window [mem 0xdab00000-0xdabfffff]
[    0.744378] pci 0000:00:17.3:   bridge window [mem 0xdd800000-0xdd8fffff 
64bit pref]
[    0.744992] pci 0000:00:17.4: PCI bridge to [bus 17-17]
[    0.745020] pci 0000:00:17.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.745049] pci 0000:00:17.4:   bridge window [mem 0xdaf00000-0xdaffffff]
[    0.745103] pci 0000:00:17.4:   bridge window [mem 0xddc00000-0xddcfffff 
64bit pref]
[    0.745690] pci 0000:00:17.5: PCI bridge to [bus 18-18]
[    0.745717] pci 0000:00:17.5:   bridge window [io  0xf000-0x0000] (disabled)
[    0.745742] pci 0000:00:17.5:   bridge window [mem 0xdb300000-0xdb3fffff]
[    0.745791] pci 0000:00:17.5:   bridge window [mem 0xde000000-0xde0fffff 
64bit pref]
[    0.746395] pci 0000:00:17.6: PCI bridge to [bus 19-19]
[    0.746426] pci 0000:00:17.6:   bridge window [io  0xf000-0x0000] (disabled)
[    0.746451] pci 0000:00:17.6:   bridge window [mem 0xdb700000-0xdb7fffff]
[    0.746500] pci 0000:00:17.6:   bridge window [mem 0xde400000-0xde4fffff 
64bit pref]
[    0.747049] pci 0000:00:17.7: PCI bridge to [bus 1a-1a]
[    0.747075] pci 0000:00:17.7:   bridge window [io  0xf000-0x0000] (disabled)
[    0.747101] pci 0000:00:17.7:   bridge window [mem 0xdbb00000-0xdbbfffff]
[    0.747150] pci 0000:00:17.7:   bridge window [mem 0xde800000-0xde8fffff 
64bit pref]
[    0.747711] pci 0000:00:18.0: PCI bridge to [bus 1b-1b]
[    0.747737] pci 0000:00:18.0:   bridge window [io  0x7000-0x7fff]
[    0.747763] pci 0000:00:18.0:   bridge window [mem 0xda000000-0xda0fffff]
[    0.747812] pci 0000:00:18.0:   bridge window [mem 0xdcd00000-0xdcdfffff 
64bit pref]
[    0.748361] pci 0000:00:18.1: PCI bridge to [bus 1c-1c]
[    0.748387] pci 0000:00:18.1:   bridge window [io  0xb000-0xbfff]
[    0.748413] pci 0000:00:18.1:   bridge window [mem 0xda400000-0xda4fffff]
[    0.748462] pci 0000:00:18.1:   bridge window [mem 0xdd100000-0xdd1fffff 
64bit pref]
[    0.749042] pci 0000:00:18.2: PCI bridge to [bus 1d-1d]
[    0.749068] pci 0000:00:18.2:   bridge window [io  0xf000-0xffff]
[    0.749094] pci 0000:00:18.2:   bridge window [mem 0xda800000-0xda8fffff]
[    0.749143] pci 0000:00:18.2:   bridge window [mem 0xdd500000-0xdd5fffff 
64bit pref]
[    0.749689] pci 0000:00:18.3: PCI bridge to [bus 1e-1e]
[    0.749715] pci 0000:00:18.3:   bridge window [io  0xf000-0x0000] (disabled)
[    0.749741] pci 0000:00:18.3:   bridge window [mem 0xdac00000-0xdacfffff]
[    0.749790] pci 0000:00:18.3:   bridge window [mem 0xdd900000-0xdd9fffff 
64bit pref]
[    0.750334] pci 0000:00:18.4: PCI bridge to [bus 1f-1f]
[    0.750360] pci 0000:00:18.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.750386] pci 0000:00:18.4:   bridge window [mem 0xdb000000-0xdb0fffff]
[    0.750436] pci 0000:00:18.4:   bridge window [mem 0xddd00000-0xdddfffff 
64bit pref]
[    0.750990] pci 0000:00:18.5: PCI bridge to [bus 20-20]
[    0.751016] pci 0000:00:18.5:   bridge window [io  0xf000-0x0000] (disabled)
[    0.751045] pci 0000:00:18.5:   bridge window [mem 0xdb400000-0xdb4fffff]
[    0.751094] pci 0000:00:18.5:   bridge window [mem 0xde100000-0xde1fffff 
64bit pref]
[    0.751712] pci 0000:00:18.6: PCI bridge to [bus 21-21]
[    0.751738] pci 0000:00:18.6:   bridge window [io  0xf000-0x0000] (disabled)
[    0.751764] pci 0000:00:18.6:   bridge window [mem 0xdb800000-0xdb8fffff]
[    0.751813] pci 0000:00:18.6:   bridge window [mem 0xde500000-0xde5fffff 
64bit pref]
[    0.752362] pci 0000:00:18.7: PCI bridge to [bus 22-22]
[    0.752388] pci 0000:00:18.7:   bridge window [io  0xf000-0x0000] (disabled)
[    0.752414] pci 0000:00:18.7:   bridge window [mem 0xdbc00000-0xdbcfffff]
[    0.752463] pci 0000:00:18.7:   bridge window [mem 0xde900000-0xde9fffff 
64bit pref]
[    0.754952] pci_bus 0000:00: on NUMA node 0
[    0.754962] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.855780] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11 14 15)
[    0.855901] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 14 15)
[    0.855999] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 14 15)
[    0.856185] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 14 15)
[    0.856340] vgaarb: device added: 
PCI:0000:00:0f.0,decodes=io+mem,owns=io+mem,locks=none
[    0.856356] vgaarb: loaded
[    0.856524] SCSI subsystem initialized
[    0.856688] libata version 3.00 loaded.
[    0.856763] usbcore: registered new interface driver usbfs
[    0.856784] usbcore: registered new interface driver hub
[    0.856917] usbcore: registered new device driver usb
[    0.857221] PCI: Using ACPI for IRQ routing
[    0.857225] PCI: pci_cache_line_size set to 64 bytes
[    0.857263] pci 0000:00:18.2: no compatible bridge window for [io  0xf000-
0xffff]
[    0.858450] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.858453] reserve RAM buffer: 000000003fef0000 - 000000003fffffff 
[    0.858553] NetLabel: Initializing
[    0.858554] NetLabel:  domain hash size = 128
[    0.858555] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.858567] NetLabel:  unlabeled traffic allowed by default
[    0.858615] Switching to clocksource tsc
[    0.911782] pnp: PnP ACPI init
[    0.911806] ACPI: bus type pnp registered
[    0.912717] pnp 00:00: [bus 00-ff]
[    0.912720] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.912722] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.912724] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.912726] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.912728] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.912730] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.912732] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.912739] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.912741] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.912743] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.912745] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.912747] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.912749] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.912751] pnp 00:00: [mem 0x40000000-0xfebfffff window]
[    0.912753] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.912755] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.912757] pnp 00:00: [io  0x0d00-0xfeff window]
[    0.912828] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 PNP0a08 
(active)
[    0.912918] pnp 00:01: [io  0x0010-0x001f]
[    0.912920] pnp 00:01: [io  0x0024-0x0025]
[    0.912922] pnp 00:01: [io  0x0028-0x0029]
[    0.912924] pnp 00:01: [io  0x002c-0x002d]
[    0.912925] pnp 00:01: [io  0x002e-0x002f]
[    0.912927] pnp 00:01: [io  0x0030-0x0031]
[    0.912928] pnp 00:01: [io  0x0034-0x0035]
[    0.912930] pnp 00:01: [io  0x0038-0x0039]
[    0.912932] pnp 00:01: [io  0x003c-0x003d]
[    0.912933] pnp 00:01: [io  0x0050-0x0053]
[    0.912935] pnp 00:01: [io  0x0072-0x0077]
[    0.912940] pnp 00:01: [io  0x0080]
[    0.912942] pnp 00:01: [io  0x0090-0x009f]
[    0.912943] pnp 00:01: [io  0x00a4-0x00a5]
[    0.912945] pnp 00:01: [io  0x00a8-0x00a9]
[    0.912946] pnp 00:01: [io  0x00ac-0x00ad]
[    0.912948] pnp 00:01: [io  0x00b0-0x00b5]
[    0.912949] pnp 00:01: [io  0x00b8-0x00b9]
[    0.912951] pnp 00:01: [io  0x00bc-0x00bd]
[    0.912953] pnp 00:01: [io  0x1000-0x103f]
[    0.912954] pnp 00:01: [io  0x1040-0x104f]
[    0.912956] pnp 00:01: [io  0x0cf0-0x0cf1]
[    0.913050] pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.913060] pnp 00:02: [io  0x0000-0x000f]
[    0.913061] pnp 00:02: [io  0x0081-0x008f]
[    0.913063] pnp 00:02: [io  0x00c0-0x00df]
[    0.913065] pnp 00:02: [dma 4]
[    0.913092] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.913101] pnp 00:03: [io  0x0020-0x0021]
[    0.913103] pnp 00:03: [io  0x00a0-0x00a1]
[    0.913104] pnp 00:03: [io  0x04d0-0x04d1]
[    0.913106] pnp 00:03: [irq 2 disabled]
[    0.913126] pnp 00:03: Plug and Play ACPI device, IDs PNP0001 (active)
[    0.913136] pnp 00:04: [io  0x0070-0x0071]
[    0.913153] pnp 00:04: [irq 8]
[    0.913174] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.913181] pnp 00:05: [io  0x0061]
[    0.913201] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.913209] pnp 00:06: [io  0x0060]
[    0.913210] pnp 00:06: [io  0x0064]
[    0.913218] pnp 00:06: [irq 1]
[    0.913244] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.913259] pnp 00:07: [irq 12]
[    0.913280] pnp 00:07: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.963669] pnp 00:08: [io  0x0378-0x037f]
[    0.963687] pnp 00:08: [irq 7]
[    0.976561] pnp 00:08: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.988309] pnp 00:09: [io  0x03f8-0x03ff]
[    0.988332] pnp 00:09: [irq 4]
[    0.991744] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.001553] pnp 00:0a: [io  0x02f8-0x02ff]
[    1.001572] pnp 00:0a: [irq 3]
[    1.004728] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.019884] pnp 00:0b: [io  0x03f0-0x03f5]
[    1.019888] pnp 00:0b: [io  0x03f7]
[    1.019905] pnp 00:0b: [irq 6]
[    1.019907] pnp 00:0b: [dma 2]
[    1.022520] pnp 00:0b: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.022752] pnp 00:0c: [mem 0xe0000000-0xefffffff]
[    1.022755] pnp 00:0c: [io  0x1060-0x107f]
[    1.022757] pnp 00:0c: [mem 0xdbe00000-0xdbffffff]
[    1.022828] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.228189] pnp: PnP ACPI: found 13 devices
[    1.228196] ACPI: ACPI bus type pnp unregistered
[    1.228255] system 00:01: [io  0x1000-0x103f] has been reserved
[    1.228262] system 00:01: [io  0x1040-0x104f] has been reserved
[    1.228268] system 00:01: [io  0x0cf0-0x0cf1] has been reserved
[    1.228285] system 00:0c: [io  0x1060-0x107f] has been reserved
[    1.228294] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    1.228300] system 00:0c: [mem 0xdbe00000-0xdbffffff] has been reserved
[    1.271149] pci 0000:00:0f.0: BAR 6: assigned [mem 0x40000000-0x40007fff 
pref]
[    1.271157] pci 0000:00:10.0: BAR 6: assigned [mem 0x40008000-0x4000bfff 
pref]
[    1.271164] pci 0000:00:15.3: BAR 13: can't assign io (size 0x1000)
[    1.271169] pci 0000:00:15.4: BAR 13: can't assign io (size 0x1000)
[    1.271174] pci 0000:00:15.5: BAR 13: can't assign io (size 0x1000)
[    1.271179] pci 0000:00:15.6: BAR 13: can't assign io (size 0x1000)
[    1.271183] pci 0000:00:15.7: BAR 13: can't assign io (size 0x1000)
[    1.271188] pci 0000:00:16.3: BAR 13: can't assign io (size 0x1000)
[    1.271193] pci 0000:00:16.4: BAR 13: can't assign io (size 0x1000)
[    1.271198] pci 0000:00:16.5: BAR 13: can't assign io (size 0x1000)
[    1.271203] pci 0000:00:16.6: BAR 13: can't assign io (size 0x1000)
[    1.271214] pci 0000:00:16.7: BAR 13: can't assign io (size 0x1000)
[    1.271219] pci 0000:00:17.3: BAR 13: can't assign io (size 0x1000)
[    1.271224] pci 0000:00:17.4: BAR 13: can't assign io (size 0x1000)
[    1.271229] pci 0000:00:17.5: BAR 13: can't assign io (size 0x1000)
[    1.271234] pci 0000:00:17.6: BAR 13: can't assign io (size 0x1000)
[    1.271239] pci 0000:00:17.7: BAR 13: can't assign io (size 0x1000)
[    1.271243] pci 0000:00:18.2: BAR 13: can't assign io (size 0x1000)
[    1.271248] pci 0000:00:18.3: BAR 13: can't assign io (size 0x1000)
[    1.271253] pci 0000:00:18.4: BAR 13: can't assign io (size 0x1000)
[    1.271254] pci 0000:00:18.5: BAR 13: can't assign io (size 0x1000)
[    1.271254] pci 0000:00:18.6: BAR 13: can't assign io (size 0x1000)
[    1.271254] pci 0000:00:18.7: BAR 13: can't assign io (size 0x1000)
[    1.271254] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.271254] pci 0000:00:01.0:   bridge window [io  disabled]
[    1.271350] pci 0000:00:01.0:   bridge window [mem disabled]
[    1.271383] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    1.271450] pci 0000:02:01.0: BAR 6: assigned [mem 0xdc400000-0xdc40ffff 
pref]
[    1.271454] pci 0000:00:11.0: PCI bridge to [bus 02-02]
[    1.271474] pci 0000:00:11.0:   bridge window [io  0x2000-0x3fff]
[    1.271531] pci 0000:00:11.0:   bridge window [mem 0xd8900000-0xd9cfffff]
[    1.271565] pci 0000:00:11.0:   bridge window [mem 0xdc400000-0xdc9fffff 
64bit pref]
[    1.271629] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    1.271648] pci 0000:00:15.0:   bridge window [io  0x4000-0x4fff]
[    1.271698] pci 0000:00:15.0:   bridge window [mem 0xd9d00000-0xd9dfffff]
[    1.271732] pci 0000:00:15.0:   bridge window [mem 0xdca00000-0xdcafffff 
64bit pref]
[    1.271862] pci 0000:00:15.1: PCI bridge to [bus 04-04]
[    1.271883] pci 0000:00:15.1:   bridge window [io  0x8000-0x8fff]
[    1.271932] pci 0000:00:15.1:   bridge window [mem 0xda100000-0xda1fffff]
[    1.271966] pci 0000:00:15.1:   bridge window [mem 0xdce00000-0xdcefffff 
64bit pref]
[    1.272067] pci 0000:00:15.2: PCI bridge to [bus 05-05]
[    1.272087] pci 0000:00:15.2:   bridge window [io  0xc000-0xcfff]
[    1.272136] pci 0000:00:15.2:   bridge window [mem 0xda500000-0xda5fffff]
[    1.272170] pci 0000:00:15.2:   bridge window [mem 0xdd200000-0xdd2fffff 
64bit pref]
[    1.272251] pci 0000:00:15.3: PCI bridge to [bus 06-06]
[    1.272254] pci 0000:00:15.3:   bridge window [io  disabled]
[    1.272304] pci 0000:00:15.3:   bridge window [mem 0xda900000-0xda9fffff]
[    1.272337] pci 0000:00:15.3:   bridge window [mem 0xdd600000-0xdd6fffff 
64bit pref]
[    1.272419] pci 0000:00:15.4: PCI bridge to [bus 07-07]
[    1.272422] pci 0000:00:15.4:   bridge window [io  disabled]
[    1.272471] pci 0000:00:15.4:   bridge window [mem 0xdad00000-0xdadfffff]
[    1.272505] pci 0000:00:15.4:   bridge window [mem 0xdda00000-0xddafffff 
64bit pref]
[    1.272602] pci 0000:00:15.5: PCI bridge to [bus 08-08]
[    1.272605] pci 0000:00:15.5:   bridge window [io  disabled]
[    1.272655] pci 0000:00:15.5:   bridge window [mem 0xdb100000-0xdb1fffff]
[    1.272688] pci 0000:00:15.5:   bridge window [mem 0xdde00000-0xddefffff 
64bit pref]
[    1.272769] pci 0000:00:15.6: PCI bridge to [bus 09-09]
[    1.272772] pci 0000:00:15.6:   bridge window [io  disabled]
[    1.272821] pci 0000:00:15.6:   bridge window [mem 0xdb500000-0xdb5fffff]
[    1.272855] pci 0000:00:15.6:   bridge window [mem 0xde200000-0xde2fffff 
64bit pref]
[    1.272936] pci 0000:00:15.7: PCI bridge to [bus 0a-0a]
[    1.272939] pci 0000:00:15.7:   bridge window [io  disabled]
[    1.272988] pci 0000:00:15.7:   bridge window [mem 0xdb900000-0xdb9fffff]
[    1.273034] pci 0000:00:15.7:   bridge window [mem 0xde600000-0xde6fffff 
64bit pref]
[    1.273115] pci 0000:00:16.0: PCI bridge to [bus 0b-0b]
[    1.273135] pci 0000:00:16.0:   bridge window [io  0x5000-0x5fff]
[    1.273187] pci 0000:00:16.0:   bridge window [mem 0xd9e00000-0xd9efffff]
[    1.273221] pci 0000:00:16.0:   bridge window [mem 0xdcb00000-0xdcbfffff 
64bit pref]
[    1.273302] pci 0000:00:16.1: PCI bridge to [bus 0c-0c]
[    1.273322] pci 0000:00:16.1:   bridge window [io  0x9000-0x9fff]
[    1.273371] pci 0000:00:16.1:   bridge window [mem 0xda200000-0xda2fffff]
[    1.273405] pci 0000:00:16.1:   bridge window [mem 0xdcf00000-0xdcffffff 
64bit pref]
[    1.273486] pci 0000:00:16.2: PCI bridge to [bus 0d-0d]
[    1.273525] pci 0000:00:16.2:   bridge window [io  0xd000-0xdfff]
[    1.273606] pci 0000:00:16.2:   bridge window [mem 0xda600000-0xda6fffff]
[    1.273645] pci 0000:00:16.2:   bridge window [mem 0xdd300000-0xdd3fffff 
64bit pref]
[    1.273742] pci 0000:00:16.3: PCI bridge to [bus 0e-0e]
[    1.273745] pci 0000:00:16.3:   bridge window [io  disabled]
[    1.273796] pci 0000:00:16.3:   bridge window [mem 0xdaa00000-0xdaafffff]
[    1.273830] pci 0000:00:16.3:   bridge window [mem 0xdd700000-0xdd7fffff 
64bit pref]
[    1.273912] pci 0000:00:16.4: PCI bridge to [bus 0f-0f]
[    1.273915] pci 0000:00:16.4:   bridge window [io  disabled]
[    1.273965] pci 0000:00:16.4:   bridge window [mem 0xdae00000-0xdaefffff]
[    1.274030] pci 0000:00:16.4:   bridge window [mem 0xddb00000-0xddbfffff 
64bit pref]
[    1.274111] pci 0000:00:16.5: PCI bridge to [bus 10-10]
[    1.274114] pci 0000:00:16.5:   bridge window [io  disabled]
[    1.274164] pci 0000:00:16.5:   bridge window [mem 0xdb200000-0xdb2fffff]
[    1.274197] pci 0000:00:16.5:   bridge window [mem 0xddf00000-0xddffffff 
64bit pref]
[    1.274278] pci 0000:00:16.6: PCI bridge to [bus 11-11]
[    1.274281] pci 0000:00:16.6:   bridge window [io  disabled]
[    1.274330] pci 0000:00:16.6:   bridge window [mem 0xdb600000-0xdb6fffff]
[    1.274364] pci 0000:00:16.6:   bridge window [mem 0xde300000-0xde3fffff 
64bit pref]
[    1.274444] pci 0000:00:16.7: PCI bridge to [bus 12-12]
[    1.274447] pci 0000:00:16.7:   bridge window [io  disabled]
[    1.274530] pci 0000:00:16.7:   bridge window [mem 0xdba00000-0xdbafffff]
[    1.274564] pci 0000:00:16.7:   bridge window [mem 0xde700000-0xde7fffff 
64bit pref]
[    1.274698] pci 0000:00:17.0: PCI bridge to [bus 13-13]
[    1.274719] pci 0000:00:17.0:   bridge window [io  0x6000-0x6fff]
[    1.274768] pci 0000:00:17.0:   bridge window [mem 0xd9f00000-0xd9ffffff]
[    1.274802] pci 0000:00:17.0:   bridge window [mem 0xdcc00000-0xdccfffff 
64bit pref]
[    1.274884] pci 0000:00:17.1: PCI bridge to [bus 14-14]
[    1.274903] pci 0000:00:17.1:   bridge window [io  0xa000-0xafff]
[    1.274952] pci 0000:00:17.1:   bridge window [mem 0xda300000-0xda3fffff]
[    1.275028] pci 0000:00:17.1:   bridge window [mem 0xdd000000-0xdd0fffff 
64bit pref]
[    1.275110] pci 0000:00:17.2: PCI bridge to [bus 15-15]
[    1.275130] pci 0000:00:17.2:   bridge window [io  0xe000-0xefff]
[    1.275179] pci 0000:00:17.2:   bridge window [mem 0xda700000-0xda7fffff]
[    1.275212] pci 0000:00:17.2:   bridge window [mem 0xdd400000-0xdd4fffff 
64bit pref]
[    1.275293] pci 0000:00:17.3: PCI bridge to [bus 16-16]
[    1.275296] pci 0000:00:17.3:   bridge window [io  disabled]
[    1.275345] pci 0000:00:17.3:   bridge window [mem 0xdab00000-0xdabfffff]
[    1.275379] pci 0000:00:17.3:   bridge window [mem 0xdd800000-0xdd8fffff 
64bit pref]
[    1.275497] pci 0000:00:17.4: PCI bridge to [bus 17-17]
[    1.275500] pci 0000:00:17.4:   bridge window [io  disabled]
[    1.275550] pci 0000:00:17.4:   bridge window [mem 0xdaf00000-0xdaffffff]
[    1.275584] pci 0000:00:17.4:   bridge window [mem 0xddc00000-0xddcfffff 
64bit pref]
[    1.275666] pci 0000:00:17.5: PCI bridge to [bus 18-18]
[    1.275669] pci 0000:00:17.5:   bridge window [io  disabled]
[    1.275718] pci 0000:00:17.5:   bridge window [mem 0xdb300000-0xdb3fffff]
[    1.275752] pci 0000:00:17.5:   bridge window [mem 0xde000000-0xde0fffff 
64bit pref]
[    1.275837] pci 0000:00:17.6: PCI bridge to [bus 19-19]
[    1.275840] pci 0000:00:17.6:   bridge window [io  disabled]
[    1.275889] pci 0000:00:17.6:   bridge window [mem 0xdb700000-0xdb7fffff]
[    1.275923] pci 0000:00:17.6:   bridge window [mem 0xde400000-0xde4fffff 
64bit pref]
[    1.276043] pci 0000:00:17.7: PCI bridge to [bus 1a-1a]
[    1.276046] pci 0000:00:17.7:   bridge window [io  disabled]
[    1.276095] pci 0000:00:17.7:   bridge window [mem 0xdbb00000-0xdbbfffff]
[    1.276129] pci 0000:00:17.7:   bridge window [mem 0xde800000-0xde8fffff 
64bit pref]
[    1.276210] pci 0000:00:18.0: PCI bridge to [bus 1b-1b]
[    1.276230] pci 0000:00:18.0:   bridge window [io  0x7000-0x7fff]
[    1.276279] pci 0000:00:18.0:   bridge window [mem 0xda000000-0xda0fffff]
[    1.276312] pci 0000:00:18.0:   bridge window [mem 0xdcd00000-0xdcdfffff 
64bit pref]
[    1.276393] pci 0000:00:18.1: PCI bridge to [bus 1c-1c]
[    1.276413] pci 0000:00:18.1:   bridge window [io  0xb000-0xbfff]
[    1.276527] pci 0000:00:18.1:   bridge window [mem 0xda400000-0xda4fffff]
[    1.276584] pci 0000:00:18.1:   bridge window [mem 0xdd100000-0xdd1fffff 
64bit pref]
[    1.276681] pci 0000:00:18.2: PCI bridge to [bus 1d-1d]
[    1.276684] pci 0000:00:18.2:   bridge window [io  disabled]
[    1.276734] pci 0000:00:18.2:   bridge window [mem 0xda800000-0xda8fffff]
[    1.276768] pci 0000:00:18.2:   bridge window [mem 0xdd500000-0xdd5fffff 
64bit pref]
[    1.276848] pci 0000:00:18.3: PCI bridge to [bus 1e-1e]
[    1.276851] pci 0000:00:18.3:   bridge window [io  disabled]
[    1.276901] pci 0000:00:18.3:   bridge window [mem 0xdac00000-0xdacfffff]
[    1.276935] pci 0000:00:18.3:   bridge window [mem 0xdd900000-0xdd9fffff 
64bit pref]
[    1.277022] pci 0000:00:18.4: PCI bridge to [bus 1f-1f]
[    1.277025] pci 0000:00:18.4:   bridge window [io  disabled]
[    1.277075] pci 0000:00:18.4:   bridge window [mem 0xdb000000-0xdb0fffff]
[    1.277108] pci 0000:00:18.4:   bridge window [mem 0xddd00000-0xdddfffff 
64bit pref]
[    1.277189] pci 0000:00:18.5: PCI bridge to [bus 20-20]
[    1.277192] pci 0000:00:18.5:   bridge window [io  disabled]
[    1.277242] pci 0000:00:18.5:   bridge window [mem 0xdb400000-0xdb4fffff]
[    1.277275] pci 0000:00:18.5:   bridge window [mem 0xde100000-0xde1fffff 
64bit pref]
[    1.277356] pci 0000:00:18.6: PCI bridge to [bus 21-21]
[    1.277359] pci 0000:00:18.6:   bridge window [io  disabled]
[    1.277408] pci 0000:00:18.6:   bridge window [mem 0xdb800000-0xdb8fffff]
[    1.277441] pci 0000:00:18.6:   bridge window [mem 0xde500000-0xde5fffff 
64bit pref]
[    1.277537] pci 0000:00:18.7: PCI bridge to [bus 22-22]
[    1.277540] pci 0000:00:18.7:   bridge window [io  disabled]
[    1.277589] pci 0000:00:18.7:   bridge window [mem 0xdbc00000-0xdbcfffff]
[    1.277623] pci 0000:00:18.7:   bridge window [mem 0xde900000-0xde9fffff 
64bit pref]
[    1.277757] pci 0000:00:01.0: setting latency timer to 64
[    1.277887] pci 0000:00:15.0: setting latency timer to 64
[    1.278031] pci 0000:00:15.1: setting latency timer to 64
[    1.278112] pci 0000:00:15.2: setting latency timer to 64
[    1.278192] pci 0000:00:15.3: setting latency timer to 64
[    1.278273] pci 0000:00:15.4: setting latency timer to 64
[    1.278353] pci 0000:00:15.5: setting latency timer to 64
[    1.278433] pci 0000:00:15.6: setting latency timer to 64
[    1.278532] pci 0000:00:15.7: setting latency timer to 64
[    1.278613] pci 0000:00:16.0: setting latency timer to 64
[    1.278694] pci 0000:00:16.1: setting latency timer to 64
[    1.278774] pci 0000:00:16.2: setting latency timer to 64
[    1.278855] pci 0000:00:16.3: setting latency timer to 64
[    1.278935] pci 0000:00:16.4: setting latency timer to 64
[    1.279019] pci 0000:00:16.5: setting latency timer to 64
[    1.279100] pci 0000:00:16.6: setting latency timer to 64
[    1.279181] pci 0000:00:16.7: setting latency timer to 64
[    1.279265] pci 0000:00:17.0: setting latency timer to 64
[    1.279345] pci 0000:00:17.1: setting latency timer to 64
[    1.279426] pci 0000:00:17.2: setting latency timer to 64
[    1.279523] pci 0000:00:17.3: setting latency timer to 64
[    1.279604] pci 0000:00:17.4: setting latency timer to 64
[    1.279685] pci 0000:00:17.5: setting latency timer to 64
[    1.279766] pci 0000:00:17.6: setting latency timer to 64
[    1.279846] pci 0000:00:17.7: setting latency timer to 64
[    1.279927] pci 0000:00:18.0: setting latency timer to 64
[    1.280018] pci 0000:00:18.1: setting latency timer to 64
[    1.280099] pci 0000:00:18.2: setting latency timer to 64
[    1.280179] pci 0000:00:18.3: setting latency timer to 64
[    1.280259] pci 0000:00:18.4: setting latency timer to 64
[    1.280340] pci 0000:00:18.5: setting latency timer to 64
[    1.280420] pci 0000:00:18.6: setting latency timer to 64
[    1.280503] pci 0000:00:18.7: setting latency timer to 64
[    1.280524] pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff]
[    1.280527] pci_bus 0000:00: resource 5 [mem 0x000cc000-0x000cffff]
[    1.280530] pci_bus 0000:00: resource 6 [mem 0x000d0000-0x000d3fff]
[    1.280533] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.280536] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.280540] pci_bus 0000:00: resource 9 [mem 0x000e4000-0x000e7fff]
[    1.280543] pci_bus 0000:00: resource 10 [mem 0x40000000-0xfebfffff]
[    1.280546] pci_bus 0000:00: resource 11 [io  0x0000-0x0cf7]
[    1.280549] pci_bus 0000:00: resource 12 [io  0x0d00-0xfeff]
[    1.280553] pci_bus 0000:02: resource 0 [io  0x2000-0x3fff]
[    1.280556] pci_bus 0000:02: resource 1 [mem 0xd8900000-0xd9cfffff]
[    1.280560] pci_bus 0000:02: resource 2 [mem 0xdc400000-0xdc9fffff 64bit 
pref]
[    1.280563] pci_bus 0000:02: resource 4 [mem 0x000a0000-0x000bffff]
[    1.280566] pci_bus 0000:02: resource 5 [mem 0x000cc000-0x000cffff]
[    1.280570] pci_bus 0000:02: resource 6 [mem 0x000d0000-0x000d3fff]
[    1.280573] pci_bus 0000:02: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.280576] pci_bus 0000:02: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.280579] pci_bus 0000:02: resource 9 [mem 0x000e4000-0x000e7fff]
[    1.280582] pci_bus 0000:02: resource 10 [mem 0x40000000-0xfebfffff]
[    1.280585] pci_bus 0000:02: resource 11 [io  0x0000-0x0cf7]
[    1.280589] pci_bus 0000:02: resource 12 [io  0x0d00-0xfeff]
[    1.280592] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
[    1.280595] pci_bus 0000:03: resource 1 [mem 0xd9d00000-0xd9dfffff]
[    1.280599] pci_bus 0000:03: resource 2 [mem 0xdca00000-0xdcafffff 64bit 
pref]
[    1.280602] pci_bus 0000:04: resource 0 [io  0x8000-0x8fff]
[    1.280605] pci_bus 0000:04: resource 1 [mem 0xda100000-0xda1fffff]
[    1.280609] pci_bus 0000:04: resource 2 [mem 0xdce00000-0xdcefffff 64bit 
pref]
[    1.280612] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    1.280615] pci_bus 0000:05: resource 1 [mem 0xda500000-0xda5fffff]
[    1.280619] pci_bus 0000:05: resource 2 [mem 0xdd200000-0xdd2fffff 64bit 
pref]
[    1.280622] pci_bus 0000:06: resource 1 [mem 0xda900000-0xda9fffff]
[    1.280625] pci_bus 0000:06: resource 2 [mem 0xdd600000-0xdd6fffff 64bit 
pref]
[    1.280629] pci_bus 0000:07: resource 1 [mem 0xdad00000-0xdadfffff]
[    1.280632] pci_bus 0000:07: resource 2 [mem 0xdda00000-0xddafffff 64bit 
pref]
[    1.280636] pci_bus 0000:08: resource 1 [mem 0xdb100000-0xdb1fffff]
[    1.280639] pci_bus 0000:08: resource 2 [mem 0xdde00000-0xddefffff 64bit 
pref]
[    1.280642] pci_bus 0000:09: resource 1 [mem 0xdb500000-0xdb5fffff]
[    1.280646] pci_bus 0000:09: resource 2 [mem 0xde200000-0xde2fffff 64bit 
pref]
[    1.280649] pci_bus 0000:0a: resource 1 [mem 0xdb900000-0xdb9fffff]
[    1.280652] pci_bus 0000:0a: resource 2 [mem 0xde600000-0xde6fffff 64bit 
pref]
[    1.280656] pci_bus 0000:0b: resource 0 [io  0x5000-0x5fff]
[    1.280662] pci_bus 0000:0b: resource 1 [mem 0xd9e00000-0xd9efffff]
[    1.280665] pci_bus 0000:0b: resource 2 [mem 0xdcb00000-0xdcbfffff 64bit 
pref]
[    1.280669] pci_bus 0000:0c: resource 0 [io  0x9000-0x9fff]
[    1.280672] pci_bus 0000:0c: resource 1 [mem 0xda200000-0xda2fffff]
[    1.280675] pci_bus 0000:0c: resource 2 [mem 0xdcf00000-0xdcffffff 64bit 
pref]
[    1.280679] pci_bus 0000:0d: resource 0 [io  0xd000-0xdfff]
[    1.280682] pci_bus 0000:0d: resource 1 [mem 0xda600000-0xda6fffff]
[    1.280685] pci_bus 0000:0d: resource 2 [mem 0xdd300000-0xdd3fffff 64bit 
pref]
[    1.280689] pci_bus 0000:0e: resource 1 [mem 0xdaa00000-0xdaafffff]
[    1.280692] pci_bus 0000:0e: resource 2 [mem 0xdd700000-0xdd7fffff 64bit 
pref]
[    1.280695] pci_bus 0000:0f: resource 1 [mem 0xdae00000-0xdaefffff]
[    1.280699] pci_bus 0000:0f: resource 2 [mem 0xddb00000-0xddbfffff 64bit 
pref]
[    1.280702] pci_bus 0000:10: resource 1 [mem 0xdb200000-0xdb2fffff]
[    1.280705] pci_bus 0000:10: resource 2 [mem 0xddf00000-0xddffffff 64bit 
pref]
[    1.280709] pci_bus 0000:11: resource 1 [mem 0xdb600000-0xdb6fffff]
[    1.280712] pci_bus 0000:11: resource 2 [mem 0xde300000-0xde3fffff 64bit 
pref]
[    1.280716] pci_bus 0000:12: resource 1 [mem 0xdba00000-0xdbafffff]
[    1.280719] pci_bus 0000:12: resource 2 [mem 0xde700000-0xde7fffff 64bit 
pref]
[    1.280722] pci_bus 0000:13: resource 0 [io  0x6000-0x6fff]
[    1.280725] pci_bus 0000:13: resource 1 [mem 0xd9f00000-0xd9ffffff]
[    1.280729] pci_bus 0000:13: resource 2 [mem 0xdcc00000-0xdccfffff 64bit 
pref]
[    1.280732] pci_bus 0000:14: resource 0 [io  0xa000-0xafff]
[    1.280735] pci_bus 0000:14: resource 1 [mem 0xda300000-0xda3fffff]
[    1.280739] pci_bus 0000:14: resource 2 [mem 0xdd000000-0xdd0fffff 64bit 
pref]
[    1.280742] pci_bus 0000:15: resource 0 [io  0xe000-0xefff]
[    1.280745] pci_bus 0000:15: resource 1 [mem 0xda700000-0xda7fffff]
[    1.280749] pci_bus 0000:15: resource 2 [mem 0xdd400000-0xdd4fffff 64bit 
pref]
[    1.280752] pci_bus 0000:16: resource 1 [mem 0xdab00000-0xdabfffff]
[    1.280755] pci_bus 0000:16: resource 2 [mem 0xdd800000-0xdd8fffff 64bit 
pref]
[    1.280759] pci_bus 0000:17: resource 1 [mem 0xdaf00000-0xdaffffff]
[    1.280762] pci_bus 0000:17: resource 2 [mem 0xddc00000-0xddcfffff 64bit 
pref]
[    1.280766] pci_bus 0000:18: resource 1 [mem 0xdb300000-0xdb3fffff]
[    1.280769] pci_bus 0000:18: resource 2 [mem 0xde000000-0xde0fffff 64bit 
pref]
[    1.280772] pci_bus 0000:19: resource 1 [mem 0xdb700000-0xdb7fffff]
[    1.280775] pci_bus 0000:19: resource 2 [mem 0xde400000-0xde4fffff 64bit 
pref]
[    1.280779] pci_bus 0000:1a: resource 1 [mem 0xdbb00000-0xdbbfffff]
[    1.280782] pci_bus 0000:1a: resource 2 [mem 0xde800000-0xde8fffff 64bit 
pref]
[    1.280786] pci_bus 0000:1b: resource 0 [io  0x7000-0x7fff]
[    1.280789] pci_bus 0000:1b: resource 1 [mem 0xda000000-0xda0fffff]
[    1.280792] pci_bus 0000:1b: resource 2 [mem 0xdcd00000-0xdcdfffff 64bit 
pref]
[    1.280796] pci_bus 0000:1c: resource 0 [io  0xb000-0xbfff]
[    1.280799] pci_bus 0000:1c: resource 1 [mem 0xda400000-0xda4fffff]
[    1.280802] pci_bus 0000:1c: resource 2 [mem 0xdd100000-0xdd1fffff 64bit 
pref]
[    1.280806] pci_bus 0000:1d: resource 1 [mem 0xda800000-0xda8fffff]
[    1.280809] pci_bus 0000:1d: resource 2 [mem 0xdd500000-0xdd5fffff 64bit 
pref]
[    1.280812] pci_bus 0000:1e: resource 1 [mem 0xdac00000-0xdacfffff]
[    1.280816] pci_bus 0000:1e: resource 2 [mem 0xdd900000-0xdd9fffff 64bit 
pref]
[    1.280819] pci_bus 0000:1f: resource 1 [mem 0xdb000000-0xdb0fffff]
[    1.280823] pci_bus 0000:1f: resource 2 [mem 0xddd00000-0xdddfffff 64bit 
pref]
[    1.280826] pci_bus 0000:20: resource 1 [mem 0xdb400000-0xdb4fffff]
[    1.280829] pci_bus 0000:20: resource 2 [mem 0xde100000-0xde1fffff 64bit 
pref]
[    1.280833] pci_bus 0000:21: resource 1 [mem 0xdb800000-0xdb8fffff]
[    1.280836] pci_bus 0000:21: resource 2 [mem 0xde500000-0xde5fffff 64bit 
pref]
[    1.280842] pci_bus 0000:22: resource 1 [mem 0xdbc00000-0xdbcfffff]
[    1.280845] pci_bus 0000:22: resource 2 [mem 0xde900000-0xde9fffff 64bit 
pref]
[    1.280906] NET: Registered protocol family 2
[    1.280959] IP route cache hash table entries: 32768 (order: 5, 131072 
bytes)
[    1.281062] TCP established hash table entries: 131072 (order: 8, 1048576 
bytes)
[    1.281579] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    1.285253] TCP: Hash tables configured (established 131072 bind 65536)
[    1.285258] TCP reno registered
[    1.285265] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    1.285284] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    1.285388] NET: Registered protocol family 1
[    1.285403] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.285542] pci 0000:00:0f.0: Boot video device
[    1.286799] PCI: CLS 32 bytes, default 64
[    1.286880] Trying to unpack rootfs image as initramfs...
[    1.341704] Freeing initrd memory: 4188k freed
[    1.341808] Simple Boot Flag at 0x36 set to 0x1
[    1.342241] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[    1.342245] apm: disabled - APM is not SMP safe.
[    1.342349] audit: initializing netlink socket (disabled)
[    1.342363] type=2000 audit(1294324725.066:1): initialized
[    1.358414] highmem bounce pool size: 64 pages
[    1.358421] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.359139] VFS: Disk quotas dquot_6.5.2
[    1.359191] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.359399] NTFS driver 2.1.29 [Flags: R/W].
[    1.359486] msgmni has been set to 1732
[    1.359559] SELinux:  Registering netfilter hooks
[    1.360530] alg: No test for stdrng (krng)
[    1.360647] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
253)
[    1.360652] io scheduler noop registered
[    1.360654] io scheduler deadline registered
[    1.360671] io scheduler cfq registered (default)
[    1.361106] pcieport 0000:00:15.0: ACPI _OSC control granted for 0x15
[    1.361106] pcieport 0000:00:15.0: setting latency timer to 64
[    1.361632] pcieport 0000:00:15.0: irq 40 for MSI/MSI-X
[    1.362478] pcieport 0000:00:15.1: ACPI _OSC control granted for 0x15
[    1.362624] pcieport 0000:00:15.1: setting latency timer to 64
[    1.363267] pcieport 0000:00:15.1: irq 41 for MSI/MSI-X
[    1.364133] pcieport 0000:00:15.2: ACPI _OSC control granted for 0x15
[    1.364269] pcieport 0000:00:15.2: setting latency timer to 64
[    1.364957] pcieport 0000:00:15.2: irq 42 for MSI/MSI-X
[    1.365840] pcieport 0000:00:15.3: ACPI _OSC control granted for 0x15
[    1.365977] pcieport 0000:00:15.3: setting latency timer to 64
[    1.366658] pcieport 0000:00:15.3: irq 43 for MSI/MSI-X
[    1.367491] pcieport 0000:00:15.4: ACPI _OSC control granted for 0x15
[    1.367635] pcieport 0000:00:15.4: setting latency timer to 64
[    1.368318] pcieport 0000:00:15.4: irq 44 for MSI/MSI-X
[    1.369173] pcieport 0000:00:15.5: ACPI _OSC control granted for 0x15
[    1.369311] pcieport 0000:00:15.5: setting latency timer to 64
[    1.369952] pcieport 0000:00:15.5: irq 45 for MSI/MSI-X
[    1.370819] pcieport 0000:00:15.6: ACPI _OSC control granted for 0x15
[    1.370955] pcieport 0000:00:15.6: setting latency timer to 64
[    1.371191] pcieport 0000:00:15.6: irq 46 for MSI/MSI-X
[    1.372036] pcieport 0000:00:15.7: ACPI _OSC control granted for 0x15
[    1.372174] pcieport 0000:00:15.7: setting latency timer to 64
[    1.372815] pcieport 0000:00:15.7: irq 47 for MSI/MSI-X
[    1.373686] pcieport 0000:00:16.0: ACPI _OSC control granted for 0x15
[    1.373822] pcieport 0000:00:16.0: setting latency timer to 64
[    1.374529] pcieport 0000:00:16.0: irq 48 for MSI/MSI-X
[    1.375395] pcieport 0000:00:16.1: ACPI _OSC control granted for 0x15
[    1.375542] pcieport 0000:00:16.1: setting latency timer to 64
[    1.376189] pcieport 0000:00:16.1: irq 49 for MSI/MSI-X
[    1.377054] pcieport 0000:00:16.2: ACPI _OSC control granted for 0x15
[    1.377191] pcieport 0000:00:16.2: setting latency timer to 64
[    1.377745] pcieport 0000:00:16.2: irq 50 for MSI/MSI-X
[    1.378423] pcieport 0000:00:16.3: ACPI _OSC control granted for 0x15
[    1.378549] pcieport 0000:00:16.3: setting latency timer to 64
[    1.379154] pcieport 0000:00:16.3: irq 51 for MSI/MSI-X
[    1.380049] pcieport 0000:00:16.4: ACPI _OSC control granted for 0x15
[    1.380198] pcieport 0000:00:16.4: setting latency timer to 64
[    1.380845] pcieport 0000:00:16.4: irq 52 for MSI/MSI-X
[    1.381683] pcieport 0000:00:16.5: ACPI _OSC control granted for 0x15
[    1.381820] pcieport 0000:00:16.5: setting latency timer to 64
[    1.382459] pcieport 0000:00:16.5: irq 53 for MSI/MSI-X
[    1.383332] pcieport 0000:00:16.6: ACPI _OSC control granted for 0x15
[    1.383468] pcieport 0000:00:16.6: setting latency timer to 64
[    1.384120] pcieport 0000:00:16.6: irq 54 for MSI/MSI-X
[    1.384894] pcieport 0000:00:16.7: ACPI _OSC control granted for 0x15
[    1.385030] pcieport 0000:00:16.7: setting latency timer to 64
[    1.385654] pcieport 0000:00:16.7: irq 55 for MSI/MSI-X
[    1.386468] pcieport 0000:00:17.0: ACPI _OSC control granted for 0x15
[    1.386592] pcieport 0000:00:17.0: setting latency timer to 64
[    1.387194] pcieport 0000:00:17.0: irq 56 for MSI/MSI-X
[    1.387882] pcieport 0000:00:17.1: ACPI _OSC control granted for 0x15
[    1.388011] pcieport 0000:00:17.1: setting latency timer to 64
[    1.388616] pcieport 0000:00:17.1: irq 57 for MSI/MSI-X
[    1.389498] pcieport 0000:00:17.2: ACPI _OSC control granted for 0x15
[    1.389636] pcieport 0000:00:17.2: setting latency timer to 64
[    1.390283] pcieport 0000:00:17.2: irq 58 for MSI/MSI-X
[    1.391172] pcieport 0000:00:17.3: ACPI _OSC control granted for 0x15
[    1.391383] pcieport 0000:00:17.3: setting latency timer to 64
[    1.391995] pcieport 0000:00:17.3: irq 59 for MSI/MSI-X
[    1.392839] pcieport 0000:00:17.4: ACPI _OSC control granted for 0x15
[    1.392964] pcieport 0000:00:17.4: setting latency timer to 64
[    1.393559] pcieport 0000:00:17.4: irq 60 for MSI/MSI-X
[    1.394385] pcieport 0000:00:17.5: ACPI _OSC control granted for 0x15
[    1.394405] pcieport 0000:00:17.5: setting latency timer to 64
[    1.395035] pcieport 0000:00:17.5: irq 61 for MSI/MSI-X
[    1.395821] pcieport 0000:00:17.6: ACPI _OSC control granted for 0x15
[    1.395966] pcieport 0000:00:17.6: setting latency timer to 64
[    1.396567] pcieport 0000:00:17.6: irq 62 for MSI/MSI-X
[    1.397383] pcieport 0000:00:17.7: ACPI _OSC control granted for 0x15
[    1.397512] pcieport 0000:00:17.7: setting latency timer to 64
[    1.398007] pcieport 0000:00:17.7: irq 63 for MSI/MSI-X
[    1.398840] pcieport 0000:00:18.0: ACPI _OSC control granted for 0x15
[    1.398965] pcieport 0000:00:18.0: setting latency timer to 64
[    1.399566] pcieport 0000:00:18.0: irq 64 for MSI/MSI-X
[    1.400474] pcieport 0000:00:18.1: ACPI _OSC control granted for 0x15
[    1.400599] pcieport 0000:00:18.1: setting latency timer to 64
[    1.401207] pcieport 0000:00:18.1: irq 65 for MSI/MSI-X
[    1.402044] pcieport 0000:00:18.2: ACPI _OSC control granted for 0x15
[    1.402172] pcieport 0000:00:18.2: setting latency timer to 64
[    1.402769] pcieport 0000:00:18.2: irq 66 for MSI/MSI-X
[    1.403590] pcieport 0000:00:18.3: ACPI _OSC control granted for 0x15
[    1.403726] pcieport 0000:00:18.3: setting latency timer to 64
[    1.404356] pcieport 0000:00:18.3: irq 67 for MSI/MSI-X
[    1.405301] pcieport 0000:00:18.4: ACPI _OSC control granted for 0x15
[    1.405438] pcieport 0000:00:18.4: setting latency timer to 64
[    1.406082] pcieport 0000:00:18.4: irq 68 for MSI/MSI-X
[    1.406936] pcieport 0000:00:18.5: ACPI _OSC control granted for 0x15
[    1.407081] pcieport 0000:00:18.5: setting latency timer to 64
[    1.407696] pcieport 0000:00:18.5: irq 69 for MSI/MSI-X
[    1.408235] pcieport 0000:00:18.6: ACPI _OSC control granted for 0x15
[    1.408360] pcieport 0000:00:18.6: setting latency timer to 64
[    1.408954] pcieport 0000:00:18.6: irq 70 for MSI/MSI-X
[    1.409773] pcieport 0000:00:18.7: ACPI _OSC control granted for 0x15
[    1.409898] pcieport 0000:00:18.7: setting latency timer to 64
[    1.410509] pcieport 0000:00:18.7: irq 71 for MSI/MSI-X
[    1.411239] pcieport 0000:00:15.0: Signaling PME through PCIe PME interrupt
[    1.411267] pcie_pme 0000:00:15.0:pcie01: service driver pcie_pme loaded
[    1.411423] pcieport 0000:00:15.1: Signaling PME through PCIe PME interrupt
[    1.411450] pcie_pme 0000:00:15.1:pcie01: service driver pcie_pme loaded
[    1.411622] pcieport 0000:00:15.2: Signaling PME through PCIe PME interrupt
[    1.411649] pcie_pme 0000:00:15.2:pcie01: service driver pcie_pme loaded
[    1.411803] pcieport 0000:00:15.3: Signaling PME through PCIe PME interrupt
[    1.411831] pcie_pme 0000:00:15.3:pcie01: service driver pcie_pme loaded
[    1.411985] pcieport 0000:00:15.4: Signaling PME through PCIe PME interrupt
[    1.412011] pcie_pme 0000:00:15.4:pcie01: service driver pcie_pme loaded
[    1.412193] pcieport 0000:00:15.5: Signaling PME through PCIe PME interrupt
[    1.412221] pcie_pme 0000:00:15.5:pcie01: service driver pcie_pme loaded
[    1.412375] pcieport 0000:00:15.6: Signaling PME through PCIe PME interrupt
[    1.412402] pcie_pme 0000:00:15.6:pcie01: service driver pcie_pme loaded
[    1.412575] pcieport 0000:00:15.7: Signaling PME through PCIe PME interrupt
[    1.412608] pcie_pme 0000:00:15.7:pcie01: service driver pcie_pme loaded
[    1.412761] pcieport 0000:00:16.0: Signaling PME through PCIe PME interrupt
[    1.412788] pcie_pme 0000:00:16.0:pcie01: service driver pcie_pme loaded
[    1.412947] pcieport 0000:00:16.1: Signaling PME through PCIe PME interrupt
[    1.412974] pcie_pme 0000:00:16.1:pcie01: service driver pcie_pme loaded
[    1.413155] pcieport 0000:00:16.2: Signaling PME through PCIe PME interrupt
[    1.413182] pcie_pme 0000:00:16.2:pcie01: service driver pcie_pme loaded
[    1.413336] pcieport 0000:00:16.3: Signaling PME through PCIe PME interrupt
[    1.413363] pcie_pme 0000:00:16.3:pcie01: service driver pcie_pme loaded
[    1.413516] pcieport 0000:00:16.4: Signaling PME through PCIe PME interrupt
[    1.413543] pcie_pme 0000:00:16.4:pcie01: service driver pcie_pme loaded
[    1.413714] pcieport 0000:00:16.5: Signaling PME through PCIe PME interrupt
[    1.413742] pcie_pme 0000:00:16.5:pcie01: service driver pcie_pme loaded
[    1.413895] pcieport 0000:00:16.6: Signaling PME through PCIe PME interrupt
[    1.413923] pcie_pme 0000:00:16.6:pcie01: service driver pcie_pme loaded
[    1.414100] pcieport 0000:00:16.7: Signaling PME through PCIe PME interrupt
[    1.414137] pcie_pme 0000:00:16.7:pcie01: service driver pcie_pme loaded
[    1.414324] pcieport 0000:00:17.0: Signaling PME through PCIe PME interrupt
[    1.414352] pcie_pme 0000:00:17.0:pcie01: service driver pcie_pme loaded
[    1.414671] pcieport 0000:00:17.1: Signaling PME through PCIe PME interrupt
[    1.414702] pcie_pme 0000:00:17.1:pcie01: service driver pcie_pme loaded
[    1.414868] pcieport 0000:00:17.2: Signaling PME through PCIe PME interrupt
[    1.414895] pcie_pme 0000:00:17.2:pcie01: service driver pcie_pme loaded
[    1.415074] pcieport 0000:00:17.3: Signaling PME through PCIe PME interrupt
[    1.415102] pcie_pme 0000:00:17.3:pcie01: service driver pcie_pme loaded
[    1.415256] pcieport 0000:00:17.4: Signaling PME through PCIe PME interrupt
[    1.415283] pcie_pme 0000:00:17.4:pcie01: service driver pcie_pme loaded
[    1.415438] pcieport 0000:00:17.5: Signaling PME through PCIe PME interrupt
[    1.415465] pcie_pme 0000:00:17.5:pcie01: service driver pcie_pme loaded
[    1.415629] pcieport 0000:00:17.6: Signaling PME through PCIe PME interrupt
[    1.415658] pcie_pme 0000:00:17.6:pcie01: service driver pcie_pme loaded
[    1.415812] pcieport 0000:00:17.7: Signaling PME through PCIe PME interrupt
[    1.415839] pcie_pme 0000:00:17.7:pcie01: service driver pcie_pme loaded
[    1.416009] pcieport 0000:00:18.0: Signaling PME through PCIe PME interrupt
[    1.416039] pcie_pme 0000:00:18.0:pcie01: service driver pcie_pme loaded
[    1.416199] pcieport 0000:00:18.1: Signaling PME through PCIe PME interrupt
[    1.416227] pcie_pme 0000:00:18.1:pcie01: service driver pcie_pme loaded
[    1.416380] pcieport 0000:00:18.2: Signaling PME through PCIe PME interrupt
[    1.416407] pcie_pme 0000:00:18.2:pcie01: service driver pcie_pme loaded
[    1.416571] pcieport 0000:00:18.3: Signaling PME through PCIe PME interrupt
[    1.416598] pcie_pme 0000:00:18.3:pcie01: service driver pcie_pme loaded
[    1.416752] pcieport 0000:00:18.4: Signaling PME through PCIe PME interrupt
[    1.416779] pcie_pme 0000:00:18.4:pcie01: service driver pcie_pme loaded
[    1.416933] pcieport 0000:00:18.5: Signaling PME through PCIe PME interrupt
[    1.416960] pcie_pme 0000:00:18.5:pcie01: service driver pcie_pme loaded
[    1.417139] pcieport 0000:00:18.6: Signaling PME through PCIe PME interrupt
[    1.417166] pcie_pme 0000:00:18.6:pcie01: service driver pcie_pme loaded
[    1.417320] pcieport 0000:00:18.7: Signaling PME through PCIe PME interrupt
[    1.417347] pcie_pme 0000:00:18.7:pcie01: service driver pcie_pme loaded
[    1.417371] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.417680] pciehp 0000:00:15.0:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.417755] pciehp 0000:00:15.0:pcie04: service driver pciehp loaded
[    1.417843] pciehp 0000:00:15.1:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.417943] pciehp 0000:00:15.1:pcie04: service driver pciehp loaded
[    1.418025] pciehp 0000:00:15.2:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.418139] pciehp 0000:00:15.2:pcie04: service driver pciehp loaded
[    1.418218] pciehp 0000:00:15.3:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.418321] pciehp 0000:00:15.3:pcie04: service driver pciehp loaded
[    1.418400] pciehp 0000:00:15.4:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.418497] pciehp 0000:00:15.4:pcie04: service driver pciehp loaded
[    1.418599] pciehp 0000:00:15.5:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.418702] pciehp 0000:00:15.5:pcie04: service driver pciehp loaded
[    1.418781] pciehp 0000:00:15.6:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.418878] pciehp 0000:00:15.6:pcie04: service driver pciehp loaded
[    1.418957] pciehp 0000:00:15.7:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.419072] pciehp 0000:00:15.7:pcie04: service driver pciehp loaded
[    1.419150] pciehp 0000:00:16.0:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.419249] pciehp 0000:00:16.0:pcie04: service driver pciehp loaded
[    1.419327] pciehp 0000:00:16.1:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.419425] pciehp 0000:00:16.1:pcie04: service driver pciehp loaded
[    1.419504] pciehp 0000:00:16.2:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.419642] pciehp 0000:00:16.2:pcie04: service driver pciehp loaded
[    1.419738] pciehp 0000:00:16.3:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.419862] pciehp 0000:00:16.3:pcie04: service driver pciehp loaded
[    1.419950] pciehp 0000:00:16.4:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.420117] pciehp 0000:00:16.4:pcie04: service driver pciehp loaded
[    1.420205] pciehp 0000:00:16.5:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.420313] pciehp 0000:00:16.5:pcie04: service driver pciehp loaded
[    1.420402] pciehp 0000:00:16.6:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.420509] pciehp 0000:00:16.6:pcie04: service driver pciehp loaded
[    1.420634] pciehp 0000:00:16.7:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.420743] pciehp 0000:00:16.7:pcie04: service driver pciehp loaded
[    1.420834] pciehp 0000:00:17.0:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.420943] pciehp 0000:00:17.0:pcie04: service driver pciehp loaded
[    1.421036] pciehp 0000:00:17.1:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.421148] pciehp 0000:00:17.1:pcie04: service driver pciehp loaded
[    1.421235] pciehp 0000:00:17.2:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.421343] pciehp 0000:00:17.2:pcie04: service driver pciehp loaded
[    1.421430] pciehp 0000:00:17.3:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.421540] pciehp 0000:00:17.3:pcie04: service driver pciehp loaded
[    1.421627] pciehp 0000:00:17.4:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.421735] pciehp 0000:00:17.4:pcie04: service driver pciehp loaded
[    1.421822] pciehp 0000:00:17.5:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.421930] pciehp 0000:00:17.5:pcie04: service driver pciehp loaded
[    1.422026] pciehp 0000:00:17.6:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.422140] pciehp 0000:00:17.6:pcie04: service driver pciehp loaded
[    1.422227] pciehp 0000:00:17.7:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.422335] pciehp 0000:00:17.7:pcie04: service driver pciehp loaded
[    1.422421] pciehp 0000:00:18.0:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.422541] pciehp 0000:00:18.0:pcie04: service driver pciehp loaded
[    1.422629] pciehp 0000:00:18.1:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.422737] pciehp 0000:00:18.1:pcie04: service driver pciehp loaded
[    1.422823] pciehp 0000:00:18.2:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.422930] pciehp 0000:00:18.2:pcie04: service driver pciehp loaded
[    1.423020] pciehp 0000:00:18.3:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.423128] pciehp 0000:00:18.3:pcie04: service driver pciehp loaded
[    1.423215] pciehp 0000:00:18.4:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.423323] pciehp 0000:00:18.4:pcie04: service driver pciehp loaded
[    1.423410] pciehp 0000:00:18.5:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.423519] pciehp 0000:00:18.5:pcie04: service driver pciehp loaded
[    1.423606] pciehp 0000:00:18.6:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.423714] pciehp 0000:00:18.6:pcie04: service driver pciehp loaded
[    1.423802] pciehp 0000:00:18.7:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.423915] pciehp 0000:00:18.7:pcie04: service driver pciehp loaded
[    1.423924] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.423927] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.424031] acpiphp: Slot [32] registered
[    1.424050] acpiphp: Slot [33] registered
[    1.424068] acpiphp: Slot [34] registered
[    1.424085] acpiphp: Slot [35] registered
[    1.424102] acpiphp: Slot [36] registered
[    1.424120] acpiphp: Slot [37] registered
[    1.424137] acpiphp: Slot [38] registered
[    1.424154] acpiphp: Slot [39] registered
[    1.424176] acpiphp: Slot [40] registered
[    1.424194] acpiphp: Slot [41] registered
[    1.424211] acpiphp: Slot [42] registered
[    1.424228] acpiphp: Slot [43] registered
[    1.424245] acpiphp: Slot [44] registered
[    1.424286] acpiphp: Slot [45] registered
[    1.424309] acpiphp: Slot [46] registered
[    1.424336] acpiphp: Slot [47] registered
[    1.424336] acpiphp: Slot [48] registered
[    1.424336] acpiphp: Slot [49] registered
[    1.424336] acpiphp: Slot [50] registered
[    1.424336] acpiphp: Slot [51] registered
[    1.424336] acpiphp: Slot [52] registered
[    1.424336] acpiphp: Slot [53] registered
[    1.424336] acpiphp: Slot [54] registered
[    1.424336] acpiphp: Slot [55] registered
[    1.424336] acpiphp: Slot [56] registered
[    1.424336] acpiphp: Slot [57] registered
[    1.424336] acpiphp: Slot [58] registered
[    1.424336] acpiphp: Slot [59] registered
[    1.424336] acpiphp: Slot [60] registered
[    1.424336] acpiphp: Slot [61] registered
[    1.424336] acpiphp: Slot [62] registered
[    1.424336] acpiphp: Slot [63] registered
[    1.424336] acpiphp_glue: Slot 160 already registered by another hotplug 
driver
[    1.424336] acpiphp_glue: Slot 192 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 224 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 256 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 161 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 162 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 163 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 164 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 165 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 166 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 167 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 193 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 194 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 195 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 196 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 197 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 198 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 199 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 225 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 226 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 227 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 228 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 229 already registered by another hotplug 
driver
[    1.424369] acpiphp_glue: Slot 230 already registered by another hotplug 
driver
[    1.424400] acpiphp_glue: Slot 231 already registered by another hotplug 
driver
[    1.424423] acpiphp_glue: Slot 257 already registered by another hotplug 
driver
[    1.424445] acpiphp_glue: Slot 258 already registered by another hotplug 
driver
[    1.424467] acpiphp_glue: Slot 259 already registered by another hotplug 
driver
[    1.424492] acpiphp_glue: Slot 260 already registered by another hotplug 
driver
[    1.424512] acpiphp_glue: Slot 261 already registered by another hotplug 
driver
[    1.424533] acpiphp_glue: Slot 262 already registered by another hotplug 
driver
[    1.424559] acpiphp_glue: Slot 263 already registered by another hotplug 
driver
[    1.424649] pci-stub: invalid id string ""
[    1.424970] ACPI: AC Adapter [ACAD] (on-line)
[    1.425215] input: Power Button 
as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.425220] ACPI: Power Button [PWRF]
[    1.425380] ACPI: acpi_idle registered with cpuidle
[    1.657510] isapnp: Scanning for PnP cards...
[    2.015400] isapnp: No Plug & Play device found
[    2.015618] Non-volatile memory driver v1.3
[    2.015622] Linux agpgart interface v0.103
[    2.015830] agpgart-intel 0000:00:00.0: Intel 440BX Chipset
[    2.017877] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x0
[    2.017962] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.296809] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.626591] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.808033] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.896378] 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.948654] brd: module loaded
[    2.948758] loop: module loaded
[    2.948810] ata_piix 0000:00:07.1: version 2.13
[    2.949601] scsi0 : ata_piix
[    2.949961] scsi1 : ata_piix
[    2.950013] ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x10c0 irq 14
[    2.950021] ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x10c8 irq 15
[    2.950116] Fixed MDIO Bus: probed
[    2.950223] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.950373] ehci_hcd 0000:02:03.0: PCI INT A -> GSI 17 (level, low) -> IRQ 
17
[    2.950536] ehci_hcd 0000:02:03.0: EHCI Host Controller
[    2.950641] ehci_hcd 0000:02:03.0: new USB bus registered, assigned bus 
number 1
[    2.972132] ehci_hcd 0000:02:03.0: cache line size of 32 is not supported
[    2.972161] ehci_hcd 0000:02:03.0: irq 17, io mem 0xd8900000
[    2.981923] ehci_hcd 0000:02:03.0: USB 2.0 started, EHCI 1.00
[    2.981990] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.981993] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    2.981995] usb usb1: Product: EHCI Host Controller
[    2.981998] usb usb1: Manufacturer: Linux 2.6.37-vfs+ ehci_hcd
[    2.982000] usb usb1: SerialNumber: 0000:02:03.0
[    2.982052] hub 1-0:1.0: USB hub found
[    2.982058] hub 1-0:1.0: 6 ports detected
[    2.982162] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.982180] uhci_hcd: USB Universal Host Controller Interface driver
[    2.982249] uhci_hcd 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 
18
[    2.982295] uhci_hcd 0000:02:00.0: UHCI Host Controller
[    2.982339] uhci_hcd 0000:02:00.0: new USB bus registered, assigned bus 
number 2
[    2.999392] uhci_hcd 0000:02:00.0: irq 18, io base 0x000020c0
[    2.999861] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.999869] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    2.999875] usb usb2: Product: UHCI Host Controller
[    2.999880] usb usb2: Manufacturer: Linux 2.6.37-vfs+ uhci_hcd
[    2.999885] usb usb2: SerialNumber: 0000:02:00.0
[    2.999976] hub 2-0:1.0: USB hub found
[    2.999989] hub 2-0:1.0: 2 ports detected
[    3.000488] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at 0x60,0x64 
irq 1,12
[    3.559960] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.559974] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.560143] mice: PS/2 mouse device common for all mice
[    3.560335] ata2.00: ATAPI: VMware Virtual IDE CDROM Drive, 00000001, max 
UDMA/33
[    3.561107] ata2.00: configured for UDMA/33
[    3.561819] scsi 1:0:0:0: CD-ROM            NECVMWar VMware IDE CDR10 1.00 
PQ: 0 ANSI: 5
[    3.563319] sr0: scsi3-mmc drive: 1x/1x xa/form2 cdda tray
[    3.563326] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.563509] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.563558] input: AT Translated Set 2 keyboard 
as /devices/platform/i8042/serio0/input/input1
[    3.563613] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    3.566519] psmouse serio1: ID: 10 00 64
[    3.569336] input: ImPS/2 Generic Wheel Mouse 
as /devices/platform/i8042/serio1/input/input2
[    3.584276] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    3.584364] rtc0: alarms up to one month, y3k, 114 bytes nvram
[    3.584471] device-mapper: uevent: version 1.0.3
[    3.584822] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-
devel@redhat.com
[    3.585125] cpuidle: using governor ladder
[    3.585128] cpuidle: using governor menu
[    3.585483] usbcore: registered new interface driver usbhid
[    3.585486] usbhid: USB HID core driver
[    3.585522] nf_conntrack version 0.5.0 (16038 buckets, 64152 max)
[    3.585614] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.585628] TCP cubic registered
[    3.585631] NET: Registered protocol family 17
[    3.585653] Registering the dns_resolver key type
[    3.585674] Using IPI No-Shortcut mode
[    3.585765] PM: Hibernation image not present or could not be loaded.
[    3.585777] registered taskstats version 1
[    3.585781] IMA: No TPM chip found, activating TPM-bypass!
[    3.591177]   Magic number: 11:483:636
[    3.611504] rtc_cmos 00:04: setting system clock to 2011-01-06 14:38:48 UTC 
(1294324728)
[    3.611571] Initalizing network drop monitor service
[    3.611656] Freeing unused kernel memory: 440k freed
[    3.611940] Write protecting the kernel text: 3820k
[    3.612161] Write protecting the kernel read-only data: 1876k
[    3.624201] dracut: dracut-006-5.fc14
[    3.629653] dracut: rd_NO_LUKS: removing cryptoluks activation
[    3.633255] udev[79]: starting version 161
[    3.701752] dracut: Starting plymouth daemon
[    3.760523] Fusion MPT base driver 3.04.17
[    3.760523] Copyright (c) 1999-2008 LSI Corporation
[    3.767177] Fusion MPT SPI Host driver 3.04.17
[    3.767244] mptspi 0000:00:10.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.767764] mptbase: ioc0: Initiating bringup
[    3.834184] ioc0: LSI53C1030 B0: Capabilities={Initiator}
[    3.972232] scsi2 : ioc0: LSI53C1030 B0, FwRev=01032920h, Ports=1, 
MaxQ=128, IRQ=17
[    4.064572] scsi 2:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  
PQ: 0 ANSI: 2
[    4.064592] scsi target2:0:0: Beginning Domain Validation
[    4.066141] scsi target2:0:0: Domain Validation skipping write tests
[    4.066148] scsi target2:0:0: Ending Domain Validation
[    4.066215] scsi target2:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 
127)
[    4.069109] sd 2:0:0:0: [sda] 188743680 512-byte logical blocks: (96.6 
GB/90.0 GiB)
[    4.069213] sd 2:0:0:0: [sda] Write Protect is off
[    4.069220] sd 2:0:0:0: [sda] Mode Sense: 5d 00 00 00
[    4.069401] sd 2:0:0:0: [sda] Cache data unavailable
[    4.069407] sd 2:0:0:0: [sda] Assuming drive cache: write through
[    4.070017] sd 2:0:0:0: [sda] Cache data unavailable
[    4.070018] sd 2:0:0:0: [sda] Assuming drive cache: write through
[    4.070342] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    4.090391]  sda: sda1 sda2 sda3 sda4 < sda5 >
[    4.091232] sd 2:0:0:0: [sda] Cache data unavailable
[    4.091238] sd 2:0:0:0: [sda] Assuming drive cache: write through
[    4.091243] sd 2:0:0:0: [sda] Attached SCSI disk
[    4.404148] EXT4-fs (sda3): mounted filesystem with ordered data mode. 
Opts: (null)
[    4.456755] dracut: Remounting /dev/disk/by-uuid/52b8b36e-580a-4b9d-ac9f-
ee1b9b349fdf with -o noatime,nobarrier,ro
[    4.461133] EXT4-fs (sda3): barriers disabled
[    4.462381] EXT4-fs (sda3): mounted filesystem with ordered data mode. 
Opts: nobarrier
[    4.480683] dracut: Mounted root filesystem /dev/sda3
[    4.609779] dracut: Loading SELinux policy
[    4.785783] SELinux:  Disabled at runtime.
[    4.785827] SELinux:  Unregistering netfilter hooks
[    4.915424] type=1404 audit(1294324729.803:2): selinux=0 auid=4294967295 
ses=4294967295
[    4.959926] dracut: /sbin/load_policy: Can't load policy: No such file or 
directory
[    5.205407] dracut: Switching root
[    6.294704] readahead: starting
[    7.301959] udev[375]: starting version 161
[    8.189961] microcode: CPU0 sig=0x20652, pf=0x1, revision=0x9
[    8.237817] microcode: CPU1 sig=0x20652, pf=0x1, revision=0x9
[    8.550606] ACPI: resource piix4_smbus [io  0x1040-0x1047] conflicts with 
ACPI region SMB_ [??? 0x00001040-0x0000104b flags 0x5f]
[    8.550613] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[    8.573013] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    8.573106] pcnet32 0000:02:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    8.573612] pcnet32: PCnet/PCI II 79C970A at 0x2000, 00:0c:29:9a:82:5b 
assigned IRQ 19
[    8.574542] pcnet32: eth0: registered as PCnet/PCI II 79C970A
[    8.575002] pcnet32: 1 cards_found
[    8.836263] ENS1371 0000:02:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   68.698795] microcode: CPU2 sig=0x20652, pf=0x1, revision=0x9
[  129.612632] microcode: CPU3 sig=0x20652, pf=0x1, revision=0x9
[  187.926867] EXT4-fs (sda3): re-mounted. Opts: nobarrier
[  188.023599] EXT4-fs (sda1): mounted filesystem with ordered data mode. 
Opts: (null)
[  188.061070] EXT4-fs (sda2): barriers disabled
[  188.062560] EXT4-fs (sda2): mounted filesystem with ordered data mode. 
Opts: nobarrier
[  188.799509] Adding 2537468k swap on /dev/sda5.  Priority:-1 extents:1 
across:2537468k 
[  189.281808] NET: Registered protocol family 10
[  189.282354] lo: Disabled Privacy Extensions
[  189.301074] ip6_tables: (C) 2000-2006 Netfilter Core Team
[  189.629612] auditd (842): /proc/842/oom_adj is deprecated, please 
use /proc/842/oom_score_adj instead.
[  190.408309] pcnet32 0000:02:01.0: eth0: link up
[  190.617711] microcode: Microcode Update Driver: v2.00 
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[  191.652835] RPC: Registered udp transport module.
[  191.652838] RPC: Registered tcp transport module.
[  191.652839] RPC: Registered tcp NFSv4.1 backchannel transport module.
[  193.622980] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[  193.683947] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery 
directory
[  193.716767] NFSD: starting 90-second grace period
[  194.738636] Bridge firewalling registered
[  195.414367] mtrr: base(0xd0000000) is not aligned on a size(0x1130000) 
boundary
[  195.674487] Ebtables v2.0 registered
[  195.956557] lo: Disabled Privacy Extensions
[  201.937896] eth0: no IPv6 routers present



dmesg_9873140_good
==========================================================
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37-vfs+ (root@hjongman) (gcc version 4.5.1 
20100924 (Red Hat 4.5.1-4) (GCC) ) #69 SMP Thu Jan 6 14:50:30 KST 2011
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 00000000000e4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fef0000 (usable)
[    0.000000]  BIOS-e820: 000000003fef0000 - 000000003feff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003feff000 - 000000003ff00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-
PAE kernel!
[    0.000000] DMI present.
[    0.000000] DMI: 440BX Desktop Reference Platform/VMware Virtual Platform, 
BIOS 6.00 12/31/2009
[    0.000000] Hypervisor detected: VMware
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) 
==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x40000 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-protect
[    0.000000]   CC000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FFC0000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
[    0.000000] found SMP MP-table at [c00f69b0] f69b0
[    0.000000] initial memory mapped : 0 - 01000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ ffb000-1000000
[    0.000000] RAMDISK: 37bda000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 373e8000 - 377fdf1d
[    0.000000] Move RAMDISK from 0000000037bda000 - 0000000037feff1c to 
373e8000 - 377fdf1c
[    0.000000] ACPI: RSDP 000f6940 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 3fef06c4 0004C (v01 INTEL  440BX    06040000 VMW  
01324272)
[    0.000000] ACPI: FACP 3fefee98 000F4 (v04 INTEL  440BX    06040000 PTL  
000F4240)
[    0.000000] ACPI: DSDT 3fef08a6 0E5F2 (v01 PTLTD  Custom   06040000 MSFT 
03000001)
[    0.000000] ACPI: FACS 3fefffc0 00040
[    0.000000] ACPI: BOOT 3fef087e 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 
00000001)
[    0.000000] ACPI: APIC 3fef0804 0007A (v01 PTLTD  ? APIC   06040000  LTP 
00000000)
[    0.000000] ACPI: MCFG 3fef07c8 0003C (v01 PTLTD  $PCITBL$ 06040000  LTP 
00000001)
[    0.000000] ACPI: SRAT 3fef0748 00080 (v02 VMWARE MEMPLUG  06040000 VMW  
00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 136MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x00040000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fef0
[    0.000000]     0: 0x0003ff00 -> 0x00040000
[    0.000000] On node 0 totalpages: 262015
[    0.000000] free_area_init_node: node 0, pgdat c09d9b80, node_mem_map 
f6be7200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 273 pages used for memmap
[    0.000000]   HighMem zone: 34529 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000ca000
[    0.000000] PM: Registered nosave memory: 00000000000ca000 - 
00000000000cc000
[    0.000000] PM: Registered nosave memory: 00000000000cc000 - 
00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 
00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 
00000000000e8000
[    0.000000] PM: Registered nosave memory: 00000000000e8000 - 
0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 
40000000:a0000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 
nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f6400000 s27520 r0 d21632 
u1048576
[    0.000000] pcpu-alloc: s27520 r0 d21632 u1048576 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 259966
[    0.000000] Kernel command line: ro root=UUID=52b8b36e-580a-4b9d-ac9f-
ee1b9b349fdf rd_NO_LUKS rd_NO_LVM rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 
SYSFONT=latarcyrheb-sun16 KEYTABLE=us rhgb quiet
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 5242560 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want 
memory cgroups
[    0.000000] Initializing HighMem for node 0 (000377fe:00040000)
[    0.000000] Memory: 1022284k/1048576k available (3817k kernel code, 25776k 
reserved, 2295k data, 440k init, 139208k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6d000 - 0xfffff000   (1608 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc09f9000 - 0xc0a67000   ( 440 kB)
[    0.000000]       .data : 0xc07ba7c6 - 0xc09f8708   (2295 kB)
[    0.000000]       .text : 0xc0400000 - 0xc07ba7c6   (3817 kB)
[    0.000000] Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, 
Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:512
[    0.000000] CPU 0 irqstacks, hard=f5808000 soft=f580a000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.003333] TSC freq read from hypervisor : 2394.219 MHz
[    0.003333] Detected 2394.219 MHz processor.
[    0.000005] Calibrating delay loop (skipped) preset value.. 4790.95 
BogoMIPS (lpj=7980730)
[    0.000009] pid_max: default: 32768 minimum: 301
[    0.000049] Security Framework initialized
[    0.000062] SELinux:  Initializing.
[    0.000074] SELinux:  Starting in permissive mode
[    0.000104] Mount-cache hash table entries: 512
[    0.000333] Initializing cgroup subsys debug
[    0.000336] Initializing cgroup subsys ns
[    0.000339] ns_cgroup deprecated: consider using the 'clone_children' flag 
without the ns_cgroup.
[    0.000341] Initializing cgroup subsys cpuacct
[    0.000346] Initializing cgroup subsys memory
[    0.000353] Initializing cgroup subsys devices
[    0.000355] Initializing cgroup subsys freezer
[    0.000357] Initializing cgroup subsys net_cls
[    0.000360] Initializing cgroup subsys blkio
[    0.000414] CPU: Physical Processor ID: 0
[    0.000416] CPU: Processor Core ID: 0
[    0.000429] mce: CPU supports 0 MCE banks
[    0.000453] Performance Events: Westmere events, Broken PMU hardware 
detected, software events only.
[    0.001698] ACPI: Core revision 20101013
[    0.037269] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.043268] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.083538] CPU0: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz stepping 
02
[    0.193138] NMI watchdog disabled for cpu0: unable to create perf event: -2
[    0.194229] CPU 1 irqstacks, hard=f58c2000 soft=f58c4000
[    0.194313] Booting Node   0, Processors  #1
[    0.205117] Initializing CPU#1
[    0.205703] mce: CPU supports 0 MCE banks
[    0.205830] NMI watchdog disabled for cpu1: unable to create perf event: -2
[    0.206086] CPU 2 irqstacks, hard=f58ce000 soft=f58d0000
[    0.206124]  #2
[    0.216699] Initializing CPU#2
[    0.217315] mce: CPU supports 0 MCE banks
[    0.217454] NMI watchdog disabled for cpu2: unable to create perf event: -2
[    0.218005] CPU 3 irqstacks, hard=f58f8000 soft=f58fa000
[    0.218047]  #3 Ok.
[    0.228647] Initializing CPU#3
[    0.229260] mce: CPU supports 0 MCE banks
[    0.229356] Skipped synchronization checks as TSC is reliable.
[    0.229390] NMI watchdog disabled for cpu3: unable to create perf event: -2
[    0.229475] Brought up 4 CPUs
[    0.229477] Total of 4 processors activated (19161.82 BogoMIPS).
[    0.235891] x86 PAT enabled: cpu 2, old 0x0, new 0x7010600070106
[    0.235960] x86 PAT enabled: cpu 3, old 0x0, new 0x7010600070106
[    0.243345] x86 PAT enabled: cpu 1, old 0x0, new 0x7010600070106
[    0.244191] devtmpfs: initialized
[    0.245282] regulator: core version 0.5
[    0.245323] regulator: dummy: 
[    0.245416] Time: 15:06:21  Date: 01/06/11
[    0.245470] NET: Registered protocol family 16
[    0.245669] ACPI: bus type pci registered
[    0.246020] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-
0xefffffff] (base 0xe0000000)
[    0.246023] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.246025] PCI: Using MMCONFIG for extended config space
[    0.246026] PCI: Using configuration type 1 for base access
[    0.247198] bio: create slab <bio-0> at 0
[    0.250271] ACPI: EC: Look up EC in DSDT
[    0.256675] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.288673] ACPI: Interpreter enabled
[    0.288681] ACPI: (supports S0 S1 S4 S5)
[    0.288697] ACPI: Using IOAPIC for interrupt routing
[    0.289763] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.289795] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.298524] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.325497] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.340327] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.344053] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.346082] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.368197] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.368298] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.378114] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.385566] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.408065] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.418030] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.428102] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.438171] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.448033] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.458015] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.458038] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.458060] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.458073] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.458084] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.458096] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.458107] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.458119] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.458131] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.458157] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.458169] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.458180] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.458192] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.458203] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.458215] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-
723)
[    0.496574] ACPI: No dock devices found.
[    0.496587] PCI: Using host bridge windows from ACPI; if necessary, 
use "pci=nocrs" and report a bug
[    0.499024] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.503233] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-
0x000bffff]
[    0.503238] pci_root PNP0A03:00: host bridge window [mem 0x000cc000-
0x000cffff]
[    0.503241] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-
0x000d3fff]
[    0.503243] pci_root PNP0A03:00: host bridge window [mem 0x000d4000-
0x000d7fff]
[    0.503246] pci_root PNP0A03:00: host bridge window [mem 0x000d8000-
0x000dbfff]
[    0.503250] pci_root PNP0A03:00: host bridge window [mem 0x000e4000-
0x000e7fff]
[    0.503253] pci_root PNP0A03:00: host bridge window [mem 0x40000000-
0xfebfffff]
[    0.503256] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.503258] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xfeff]
[    0.503417] pci 0000:00:00.0: [8086:7190] type 0 class 0x000600
[    0.504258] pci 0000:00:01.0: [8086:7191] type 1 class 0x000604
[    0.504867] pci 0000:00:07.0: [8086:7110] type 0 class 0x000601
[    0.505853] pci 0000:00:07.1: [8086:7111] type 0 class 0x000101
[    0.509035] pci 0000:00:07.1: reg 20: [io  0x10c0-0x10cf]
[    0.510429] pci 0000:00:07.3: [8086:7113] type 0 class 0x000680
[    0.511118] pci 0000:00:07.3: quirk: [io  0x1000-0x103f] claimed by PIIX4 
ACPI
[    0.511135] pci 0000:00:07.3: quirk: [io  0x1040-0x104f] claimed by PIIX4 
SMB
[    0.511354] pci 0000:00:07.7: [15ad:0740] type 0 class 0x000880
[    0.511997] pci 0000:00:07.7: reg 10: [io  0x1080-0x10bf]
[    0.516121] pci 0000:00:0f.0: [15ad:0405] type 0 class 0x000300
[    0.535078] pci 0000:00:0f.0: reg 10: [io  0x10d0-0x10df]
[    0.551527] pci 0000:00:0f.0: reg 14: [mem 0xd0000000-0xd7ffffff]
[    0.567723] pci 0000:00:0f.0: reg 18: [mem 0xd8000000-0xd87fffff]
[    0.635398] pci 0000:00:0f.0: reg 30: [mem 0x00000000-0x00007fff pref]
[    0.635709] pci 0000:00:10.0: [1000:0030] type 0 class 0x000100
[    0.637414] pci 0000:00:10.0: reg 10: [io  0x1400-0x14ff]
[    0.639726] pci 0000:00:10.0: reg 14: [mem 0xd8820000-0xd883ffff 64bit]
[    0.642123] pci 0000:00:10.0: reg 1c: [mem 0xd8800000-0xd881ffff 64bit]
[    0.645558] pci 0000:00:10.0: reg 30: [mem 0x00000000-0x00003fff pref]
[    0.645821] pci 0000:00:11.0: [15ad:0790] type 1 class 0x000604
[    0.646731] pci 0000:00:15.0: [15ad:07a0] type 1 class 0x000604
[    0.647459] pci 0000:00:15.0: PME# supported from D0 D3hot D3cold
[    0.647488] pci 0000:00:15.0: PME# disabled
[    0.647879] pci 0000:00:15.1: [15ad:07a0] type 1 class 0x000604
[    0.648618] pci 0000:00:15.1: PME# supported from D0 D3hot D3cold
[    0.648647] pci 0000:00:15.1: PME# disabled
[    0.648931] pci 0000:00:15.2: [15ad:07a0] type 1 class 0x000604
[    0.649603] pci 0000:00:15.2: PME# supported from D0 D3hot D3cold
[    0.649632] pci 0000:00:15.2: PME# disabled
[    0.649915] pci 0000:00:15.3: [15ad:07a0] type 1 class 0x000604
[    0.650652] pci 0000:00:15.3: PME# supported from D0 D3hot D3cold
[    0.650681] pci 0000:00:15.3: PME# disabled
[    0.650985] pci 0000:00:15.4: [15ad:07a0] type 1 class 0x000604
[    0.651648] pci 0000:00:15.4: PME# supported from D0 D3hot D3cold
[    0.651676] pci 0000:00:15.4: PME# disabled
[    0.651958] pci 0000:00:15.5: [15ad:07a0] type 1 class 0x000604
[    0.652640] pci 0000:00:15.5: PME# supported from D0 D3hot D3cold
[    0.652672] pci 0000:00:15.5: PME# disabled
[    0.652956] pci 0000:00:15.6: [15ad:07a0] type 1 class 0x000604
[    0.653627] pci 0000:00:15.6: PME# supported from D0 D3hot D3cold
[    0.653655] pci 0000:00:15.6: PME# disabled
[    0.653938] pci 0000:00:15.7: [15ad:07a0] type 1 class 0x000604
[    0.654602] pci 0000:00:15.7: PME# supported from D0 D3hot D3cold
[    0.654629] pci 0000:00:15.7: PME# disabled
[    0.654911] pci 0000:00:16.0: [15ad:07a0] type 1 class 0x000604
[    0.655601] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.655630] pci 0000:00:16.0: PME# disabled
[    0.655913] pci 0000:00:16.1: [15ad:07a0] type 1 class 0x000604
[    0.656580] pci 0000:00:16.1: PME# supported from D0 D3hot D3cold
[    0.656608] pci 0000:00:16.1: PME# disabled
[    0.656890] pci 0000:00:16.2: [15ad:07a0] type 1 class 0x000604
[    0.657599] pci 0000:00:16.2: PME# supported from D0 D3hot D3cold
[    0.657628] pci 0000:00:16.2: PME# disabled
[    0.657913] pci 0000:00:16.3: [15ad:07a0] type 1 class 0x000604
[    0.658581] pci 0000:00:16.3: PME# supported from D0 D3hot D3cold
[    0.658609] pci 0000:00:16.3: PME# disabled
[    0.658893] pci 0000:00:16.4: [15ad:07a0] type 1 class 0x000604
[    0.659560] pci 0000:00:16.4: PME# supported from D0 D3hot D3cold
[    0.659588] pci 0000:00:16.4: PME# disabled
[    0.659871] pci 0000:00:16.5: [15ad:07a0] type 1 class 0x000604
[    0.660676] pci 0000:00:16.5: PME# supported from D0 D3hot D3cold
[    0.660705] pci 0000:00:16.5: PME# disabled
[    0.660992] pci 0000:00:16.6: [15ad:07a0] type 1 class 0x000604
[    0.661712] pci 0000:00:16.6: PME# supported from D0 D3hot D3cold
[    0.661740] pci 0000:00:16.6: PME# disabled
[    0.662025] pci 0000:00:16.7: [15ad:07a0] type 1 class 0x000604
[    0.662718] pci 0000:00:16.7: PME# supported from D0 D3hot D3cold
[    0.662747] pci 0000:00:16.7: PME# disabled
[    0.663035] pci 0000:00:17.0: [15ad:07a0] type 1 class 0x000604
[    0.663713] pci 0000:00:17.0: PME# supported from D0 D3hot D3cold
[    0.663740] pci 0000:00:17.0: PME# disabled
[    0.664024] pci 0000:00:17.1: [15ad:07a0] type 1 class 0x000604
[    0.664689] pci 0000:00:17.1: PME# supported from D0 D3hot D3cold
[    0.664717] pci 0000:00:17.1: PME# disabled
[    0.665000] pci 0000:00:17.2: [15ad:07a0] type 1 class 0x000604
[    0.665767] pci 0000:00:17.2: PME# supported from D0 D3hot D3cold
[    0.665796] pci 0000:00:17.2: PME# disabled
[    0.666083] pci 0000:00:17.3: [15ad:07a0] type 1 class 0x000604
[    0.666753] pci 0000:00:17.3: PME# supported from D0 D3hot D3cold
[    0.666781] pci 0000:00:17.3: PME# disabled
[    0.667102] pci 0000:00:17.4: [15ad:07a0] type 1 class 0x000604
[    0.667864] pci 0000:00:17.4: PME# supported from D0 D3hot D3cold
[    0.667893] pci 0000:00:17.4: PME# disabled
[    0.668179] pci 0000:00:17.5: [15ad:07a0] type 1 class 0x000604
[    0.668844] pci 0000:00:17.5: PME# supported from D0 D3hot D3cold
[    0.668872] pci 0000:00:17.5: PME# disabled
[    0.669156] pci 0000:00:17.6: [15ad:07a0] type 1 class 0x000604
[    0.669824] pci 0000:00:17.6: PME# supported from D0 D3hot D3cold
[    0.669852] pci 0000:00:17.6: PME# disabled
[    0.670205] pci 0000:00:17.7: [15ad:07a0] type 1 class 0x000604
[    0.670885] pci 0000:00:17.7: PME# supported from D0 D3hot D3cold
[    0.670913] pci 0000:00:17.7: PME# disabled
[    0.671199] pci 0000:00:18.0: [15ad:07a0] type 1 class 0x000604
[    0.671869] pci 0000:00:18.0: PME# supported from D0 D3hot D3cold
[    0.671897] pci 0000:00:18.0: PME# disabled
[    0.672183] pci 0000:00:18.1: [15ad:07a0] type 1 class 0x000604
[    0.672869] pci 0000:00:18.1: PME# supported from D0 D3hot D3cold
[    0.672898] pci 0000:00:18.1: PME# disabled
[    0.673184] pci 0000:00:18.2: [15ad:07a0] type 1 class 0x000604
[    0.673859] pci 0000:00:18.2: PME# supported from D0 D3hot D3cold
[    0.673887] pci 0000:00:18.2: PME# disabled
[    0.674174] pci 0000:00:18.3: [15ad:07a0] type 1 class 0x000604
[    0.674838] pci 0000:00:18.3: PME# supported from D0 D3hot D3cold
[    0.674866] pci 0000:00:18.3: PME# disabled
[    0.675171] pci 0000:00:18.4: [15ad:07a0] type 1 class 0x000604
[    0.675836] pci 0000:00:18.4: PME# supported from D0 D3hot D3cold
[    0.675864] pci 0000:00:18.4: PME# disabled
[    0.676146] pci 0000:00:18.5: [15ad:07a0] type 1 class 0x000604
[    0.676812] pci 0000:00:18.5: PME# supported from D0 D3hot D3cold
[    0.676839] pci 0000:00:18.5: PME# disabled
[    0.677132] pci 0000:00:18.6: [15ad:07a0] type 1 class 0x000604
[    0.677921] pci 0000:00:18.6: PME# supported from D0 D3hot D3cold
[    0.677958] pci 0000:00:18.6: PME# disabled
[    0.678274] pci 0000:00:18.7: [15ad:07a0] type 1 class 0x000604
[    0.678939] pci 0000:00:18.7: PME# supported from D0 D3hot D3cold
[    0.678967] pci 0000:00:18.7: PME# disabled
[    0.679707] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.679736] pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.679764] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff] 
(disabled)
[    0.679792] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff 
pref] (disabled)
[    0.680171] pci 0000:02:00.0: [8086:7112] type 0 class 0x000c03
[    0.682942] pci 0000:02:00.0: reg 20: [io  0x20c0-0x20df]
[    0.684170] pci 0000:02:01.0: [1022:2000] type 0 class 0x000200
[    0.684751] pci 0000:02:01.0: reg 10: [io  0x2000-0x207f]
[    0.688207] pci 0000:02:01.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.688347] pci 0000:02:02.0: [1274:1371] type 0 class 0x000401
[    0.688999] pci 0000:02:02.0: reg 10: [io  0x2080-0x20bf]
[    0.693159] pci 0000:02:03.0: [15ad:0770] type 0 class 0x000c03
[    0.694155] pci 0000:02:03.0: reg 10: [mem 0xd8900000-0xd8900fff]
[    0.699462] pci 0000:00:11.0: PCI bridge to [bus 02-02] (subtractive decode)
[    0.699488] pci 0000:00:11.0:   bridge window [io  0x2000-0x3fff]
[    0.699514] pci 0000:00:11.0:   bridge window [mem 0xd8900000-0xd9cfffff]
[    0.699562] pci 0000:00:11.0:   bridge window [mem 0xdc400000-0xdc9fffff 
64bit pref]
[    0.699565] pci 0000:00:11.0:   bridge window [mem 0x000a0000-0x000bffff] 
(subtractive decode)
[    0.699567] pci 0000:00:11.0:   bridge window [mem 0x000cc000-0x000cffff] 
(subtractive decode)
[    0.699569] pci 0000:00:11.0:   bridge window [mem 0x000d0000-0x000d3fff] 
(subtractive decode)
[    0.699571] pci 0000:00:11.0:   bridge window [mem 0x000d4000-0x000d7fff] 
(subtractive decode)
[    0.699573] pci 0000:00:11.0:   bridge window [mem 0x000d8000-0x000dbfff] 
(subtractive decode)
[    0.699576] pci 0000:00:11.0:   bridge window [mem 0x000e4000-0x000e7fff] 
(subtractive decode)
[    0.699578] pci 0000:00:11.0:   bridge window [mem 0x40000000-0xfebfffff] 
(subtractive decode)
[    0.699580] pci 0000:00:11.0:   bridge window [io  0x0000-0x0cf7] 
(subtractive decode)
[    0.699582] pci 0000:00:11.0:   bridge window [io  0x0d00-0xfeff] 
(subtractive decode)
[    0.700188] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    0.700224] pci 0000:00:15.0:   bridge window [io  0x4000-0x4fff]
[    0.700250] pci 0000:00:15.0:   bridge window [mem 0xd9d00000-0xd9dfffff]
[    0.700327] pci 0000:00:15.0:   bridge window [mem 0xdca00000-0xdcafffff 
64bit pref]
[    0.700884] pci 0000:00:15.1: PCI bridge to [bus 04-04]
[    0.700910] pci 0000:00:15.1:   bridge window [io  0x8000-0x8fff]
[    0.700935] pci 0000:00:15.1:   bridge window [mem 0xda100000-0xda1fffff]
[    0.700983] pci 0000:00:15.1:   bridge window [mem 0xdce00000-0xdcefffff 
64bit pref]
[    0.701519] pci 0000:00:15.2: PCI bridge to [bus 05-05]
[    0.701544] pci 0000:00:15.2:   bridge window [io  0xc000-0xcfff]
[    0.701570] pci 0000:00:15.2:   bridge window [mem 0xda500000-0xda5fffff]
[    0.701617] pci 0000:00:15.2:   bridge window [mem 0xdd200000-0xdd2fffff 
64bit pref]
[    0.702155] pci 0000:00:15.3: PCI bridge to [bus 06-06]
[    0.702185] pci 0000:00:15.3:   bridge window [io  0xf000-0x0000] (disabled)
[    0.702210] pci 0000:00:15.3:   bridge window [mem 0xda900000-0xda9fffff]
[    0.702258] pci 0000:00:15.3:   bridge window [mem 0xdd600000-0xdd6fffff 
64bit pref]
[    0.702828] pci 0000:00:15.4: PCI bridge to [bus 07-07]
[    0.702854] pci 0000:00:15.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.702880] pci 0000:00:15.4:   bridge window [mem 0xdad00000-0xdadfffff]
[    0.702927] pci 0000:00:15.4:   bridge window [mem 0xdda00000-0xddafffff 
64bit pref]
[    0.703466] pci 0000:00:15.5: PCI bridge to [bus 08-08]
[    0.703491] pci 0000:00:15.5:   bridge window [io  0xf000-0x0000] (disabled)
[    0.703525] pci 0000:00:15.5:   bridge window [mem 0xdb100000-0xdb1fffff]
[    0.703574] pci 0000:00:15.5:   bridge window [mem 0xdde00000-0xddefffff 
64bit pref]
[    0.704112] pci 0000:00:15.6: PCI bridge to [bus 09-09]
[    0.704137] pci 0000:00:15.6:   bridge window [io  0xf000-0x0000] (disabled)
[    0.704163] pci 0000:00:15.6:   bridge window [mem 0xdb500000-0xdb5fffff]
[    0.704210] pci 0000:00:15.6:   bridge window [mem 0xde200000-0xde2fffff 
64bit pref]
[    0.704753] pci 0000:00:15.7: PCI bridge to [bus 0a-0a]
[    0.704779] pci 0000:00:15.7:   bridge window [io  0xf000-0x0000] (disabled)
[    0.704804] pci 0000:00:15.7:   bridge window [mem 0xdb900000-0xdb9fffff]
[    0.704852] pci 0000:00:15.7:   bridge window [mem 0xde600000-0xde6fffff 
64bit pref]
[    0.705540] pci 0000:00:16.0: PCI bridge to [bus 0b-0b]
[    0.705567] pci 0000:00:16.0:   bridge window [io  0x5000-0x5fff]
[    0.705592] pci 0000:00:16.0:   bridge window [mem 0xd9e00000-0xd9efffff]
[    0.705640] pci 0000:00:16.0:   bridge window [mem 0xdcb00000-0xdcbfffff 
64bit pref]
[    0.706182] pci 0000:00:16.1: PCI bridge to [bus 0c-0c]
[    0.706208] pci 0000:00:16.1:   bridge window [io  0x9000-0x9fff]
[    0.706233] pci 0000:00:16.1:   bridge window [mem 0xda200000-0xda2fffff]
[    0.706281] pci 0000:00:16.1:   bridge window [mem 0xdcf00000-0xdcffffff 
64bit pref]
[    0.706817] pci 0000:00:16.2: PCI bridge to [bus 0d-0d]
[    0.706842] pci 0000:00:16.2:   bridge window [io  0xd000-0xdfff]
[    0.706878] pci 0000:00:16.2:   bridge window [mem 0xda600000-0xda6fffff]
[    0.706926] pci 0000:00:16.2:   bridge window [mem 0xdd300000-0xdd3fffff 
64bit pref]
[    0.707500] pci 0000:00:16.3: PCI bridge to [bus 0e-0e]
[    0.707529] pci 0000:00:16.3:   bridge window [io  0xf000-0x0000] (disabled)
[    0.707557] pci 0000:00:16.3:   bridge window [mem 0xdaa00000-0xdaafffff]
[    0.707610] pci 0000:00:16.3:   bridge window [mem 0xdd700000-0xdd7fffff 
64bit pref]
[    0.708184] pci 0000:00:16.4: PCI bridge to [bus 0f-0f]
[    0.708209] pci 0000:00:16.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.708235] pci 0000:00:16.4:   bridge window [mem 0xdae00000-0xdaefffff]
[    0.708283] pci 0000:00:16.4:   bridge window [mem 0xddb00000-0xddbfffff 
64bit pref]
[    0.708827] pci 0000:00:16.5: PCI bridge to [bus 10-10]
[    0.708853] pci 0000:00:16.5:   bridge window [io  0xf000-0x0000] (disabled)
[    0.708879] pci 0000:00:16.5:   bridge window [mem 0xdb200000-0xdb2fffff]
[    0.708927] pci 0000:00:16.5:   bridge window [mem 0xddf00000-0xddffffff 
64bit pref]
[    0.709466] pci 0000:00:16.6: PCI bridge to [bus 11-11]
[    0.709492] pci 0000:00:16.6:   bridge window [io  0xf000-0x0000] (disabled)
[    0.709518] pci 0000:00:16.6:   bridge window [mem 0xdb600000-0xdb6fffff]
[    0.709566] pci 0000:00:16.6:   bridge window [mem 0xde300000-0xde3fffff 
64bit pref]
[    0.710144] pci 0000:00:16.7: PCI bridge to [bus 12-12]
[    0.710184] pci 0000:00:16.7:   bridge window [io  0xf000-0x0000] (disabled)
[    0.710215] pci 0000:00:16.7:   bridge window [mem 0xdba00000-0xdbafffff]
[    0.710267] pci 0000:00:16.7:   bridge window [mem 0xde700000-0xde7fffff 
64bit pref]
[    0.710902] pci 0000:00:17.0: PCI bridge to [bus 13-13]
[    0.710936] pci 0000:00:17.0:   bridge window [io  0x6000-0x6fff]
[    0.710964] pci 0000:00:17.0:   bridge window [mem 0xd9f00000-0xd9ffffff]
[    0.711017] pci 0000:00:17.0:   bridge window [mem 0xdcc00000-0xdccfffff 
64bit pref]
[    0.711621] pci 0000:00:17.1: PCI bridge to [bus 14-14]
[    0.711649] pci 0000:00:17.1:   bridge window [io  0xa000-0xafff]
[    0.711677] pci 0000:00:17.1:   bridge window [mem 0xda300000-0xda3fffff]
[    0.711730] pci 0000:00:17.1:   bridge window [mem 0xdd000000-0xdd0fffff 
64bit pref]
[    0.712320] pci 0000:00:17.2: PCI bridge to [bus 15-15]
[    0.712348] pci 0000:00:17.2:   bridge window [io  0xe000-0xefff]
[    0.712376] pci 0000:00:17.2:   bridge window [mem 0xda700000-0xda7fffff]
[    0.712429] pci 0000:00:17.2:   bridge window [mem 0xdd400000-0xdd4fffff 
64bit pref]
[    0.713037] pci 0000:00:17.3: PCI bridge to [bus 16-16]
[    0.713063] pci 0000:00:17.3:   bridge window [io  0xf000-0x0000] (disabled)
[    0.713088] pci 0000:00:17.3:   bridge window [mem 0xdab00000-0xdabfffff]
[    0.713136] pci 0000:00:17.3:   bridge window [mem 0xdd800000-0xdd8fffff 
64bit pref]
[    0.713683] pci 0000:00:17.4: PCI bridge to [bus 17-17]
[    0.713708] pci 0000:00:17.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.713734] pci 0000:00:17.4:   bridge window [mem 0xdaf00000-0xdaffffff]
[    0.713781] pci 0000:00:17.4:   bridge window [mem 0xddc00000-0xddcfffff 
64bit pref]
[    0.714344] pci 0000:00:17.5: PCI bridge to [bus 18-18]
[    0.714370] pci 0000:00:17.5:   bridge window [io  0xf000-0x0000] (disabled)
[    0.714395] pci 0000:00:17.5:   bridge window [mem 0xdb300000-0xdb3fffff]
[    0.714443] pci 0000:00:17.5:   bridge window [mem 0xde000000-0xde0fffff 
64bit pref]
[    0.714999] pci 0000:00:17.6: PCI bridge to [bus 19-19]
[    0.715027] pci 0000:00:17.6:   bridge window [io  0xf000-0x0000] (disabled)
[    0.715055] pci 0000:00:17.6:   bridge window [mem 0xdb700000-0xdb7fffff]
[    0.715110] pci 0000:00:17.6:   bridge window [mem 0xde400000-0xde4fffff 
64bit pref]
[    0.715647] pci 0000:00:17.7: PCI bridge to [bus 1a-1a]
[    0.715672] pci 0000:00:17.7:   bridge window [io  0xf000-0x0000] (disabled)
[    0.715698] pci 0000:00:17.7:   bridge window [mem 0xdbb00000-0xdbbfffff]
[    0.715746] pci 0000:00:17.7:   bridge window [mem 0xde800000-0xde8fffff 
64bit pref]
[    0.716288] pci 0000:00:18.0: PCI bridge to [bus 1b-1b]
[    0.716314] pci 0000:00:18.0:   bridge window [io  0x7000-0x7fff]
[    0.716339] pci 0000:00:18.0:   bridge window [mem 0xda000000-0xda0fffff]
[    0.716387] pci 0000:00:18.0:   bridge window [mem 0xdcd00000-0xdcdfffff 
64bit pref]
[    0.716932] pci 0000:00:18.1: PCI bridge to [bus 1c-1c]
[    0.716958] pci 0000:00:18.1:   bridge window [io  0xb000-0xbfff]
[    0.716983] pci 0000:00:18.1:   bridge window [mem 0xda400000-0xda4fffff]
[    0.717031] pci 0000:00:18.1:   bridge window [mem 0xdd100000-0xdd1fffff 
64bit pref]
[    0.717611] pci 0000:00:18.2: PCI bridge to [bus 1d-1d]
[    0.717637] pci 0000:00:18.2:   bridge window [io  0xf000-0xffff]
[    0.717662] pci 0000:00:18.2:   bridge window [mem 0xda800000-0xda8fffff]
[    0.717710] pci 0000:00:18.2:   bridge window [mem 0xdd500000-0xdd5fffff 
64bit pref]
[    0.718249] pci 0000:00:18.3: PCI bridge to [bus 1e-1e]
[    0.718275] pci 0000:00:18.3:   bridge window [io  0xf000-0x0000] (disabled)
[    0.718300] pci 0000:00:18.3:   bridge window [mem 0xdac00000-0xdacfffff]
[    0.718348] pci 0000:00:18.3:   bridge window [mem 0xdd900000-0xdd9fffff 
64bit pref]
[    0.718884] pci 0000:00:18.4: PCI bridge to [bus 1f-1f]
[    0.718909] pci 0000:00:18.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.718935] pci 0000:00:18.4:   bridge window [mem 0xdb000000-0xdb0fffff]
[    0.718982] pci 0000:00:18.4:   bridge window [mem 0xddd00000-0xdddfffff 
64bit pref]
[    0.719518] pci 0000:00:18.5: PCI bridge to [bus 20-20]
[    0.719543] pci 0000:00:18.5:   bridge window [io  0xf000-0x0000] (disabled)
[    0.719572] pci 0000:00:18.5:   bridge window [mem 0xdb400000-0xdb4fffff]
[    0.719620] pci 0000:00:18.5:   bridge window [mem 0xde100000-0xde1fffff 
64bit pref]
[    0.720215] pci 0000:00:18.6: PCI bridge to [bus 21-21]
[    0.720243] pci 0000:00:18.6:   bridge window [io  0xf000-0x0000] (disabled)
[    0.720271] pci 0000:00:18.6:   bridge window [mem 0xdb800000-0xdb8fffff]
[    0.720323] pci 0000:00:18.6:   bridge window [mem 0xde500000-0xde5fffff 
64bit pref]
[    0.720922] pci 0000:00:18.7: PCI bridge to [bus 22-22]
[    0.720948] pci 0000:00:18.7:   bridge window [io  0xf000-0x0000] (disabled)
[    0.720973] pci 0000:00:18.7:   bridge window [mem 0xdbc00000-0xdbcfffff]
[    0.721021] pci 0000:00:18.7:   bridge window [mem 0xde900000-0xde9fffff 
64bit pref]
[    0.723432] pci_bus 0000:00: on NUMA node 0
[    0.723442] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.823661] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11 14 15)
[    0.823781] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 14 15)
[    0.823876] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 14 15)
[    0.823989] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 14 15)
[    0.824127] vgaarb: device added: 
PCI:0000:00:0f.0,decodes=io+mem,owns=io+mem,locks=none
[    0.824142] vgaarb: loaded
[    0.824273] SCSI subsystem initialized
[    0.824437] libata version 3.00 loaded.
[    0.824507] usbcore: registered new interface driver usbfs
[    0.824531] usbcore: registered new interface driver hub
[    0.824676] usbcore: registered new device driver usb
[    0.825015] PCI: Using ACPI for IRQ routing
[    0.825018] PCI: pci_cache_line_size set to 64 bytes
[    0.825054] pci 0000:00:18.2: no compatible bridge window for [io  0xf000-
0xffff]
[    0.826214] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.826217] reserve RAM buffer: 000000003fef0000 - 000000003fffffff 
[    0.826314] NetLabel: Initializing
[    0.826316] NetLabel:  domain hash size = 128
[    0.826317] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.826329] NetLabel:  unlabeled traffic allowed by default
[    0.826350] Switching to clocksource tsc
[    0.854178] pnp: PnP ACPI init
[    0.854205] ACPI: bus type pnp registered
[    0.855231] pnp 00:00: [bus 00-ff]
[    0.855234] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.855236] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.855238] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.855239] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.855241] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.855243] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.855245] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.855246] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.855248] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.855250] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.855252] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.855253] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.855255] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.855257] pnp 00:00: [mem 0x40000000-0xfebfffff window]
[    0.855259] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.855261] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.855262] pnp 00:00: [io  0x0d00-0xfeff window]
[    0.855331] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 PNP0a08 
(active)
[    0.855413] pnp 00:01: [io  0x0010-0x001f]
[    0.855415] pnp 00:01: [io  0x0024-0x0025]
[    0.855417] pnp 00:01: [io  0x0028-0x0029]
[    0.855418] pnp 00:01: [io  0x002c-0x002d]
[    0.855420] pnp 00:01: [io  0x002e-0x002f]
[    0.855421] pnp 00:01: [io  0x0030-0x0031]
[    0.855423] pnp 00:01: [io  0x0034-0x0035]
[    0.855424] pnp 00:01: [io  0x0038-0x0039]
[    0.855425] pnp 00:01: [io  0x003c-0x003d]
[    0.855427] pnp 00:01: [io  0x0050-0x0053]
[    0.855428] pnp 00:01: [io  0x0072-0x0077]
[    0.855433] pnp 00:01: [io  0x0080]
[    0.855435] pnp 00:01: [io  0x0090-0x009f]
[    0.855436] pnp 00:01: [io  0x00a4-0x00a5]
[    0.855438] pnp 00:01: [io  0x00a8-0x00a9]
[    0.855439] pnp 00:01: [io  0x00ac-0x00ad]
[    0.855440] pnp 00:01: [io  0x00b0-0x00b5]
[    0.855442] pnp 00:01: [io  0x00b8-0x00b9]
[    0.855443] pnp 00:01: [io  0x00bc-0x00bd]
[    0.855445] pnp 00:01: [io  0x1000-0x103f]
[    0.855446] pnp 00:01: [io  0x1040-0x104f]
[    0.855448] pnp 00:01: [io  0x0cf0-0x0cf1]
[    0.855535] pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.855545] pnp 00:02: [io  0x0000-0x000f]
[    0.855546] pnp 00:02: [io  0x0081-0x008f]
[    0.855548] pnp 00:02: [io  0x00c0-0x00df]
[    0.855550] pnp 00:02: [dma 4]
[    0.855567] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.855575] pnp 00:03: [io  0x0020-0x0021]
[    0.855576] pnp 00:03: [io  0x00a0-0x00a1]
[    0.855578] pnp 00:03: [io  0x04d0-0x04d1]
[    0.855580] pnp 00:03: [irq 2 disabled]
[    0.855604] pnp 00:03: Plug and Play ACPI device, IDs PNP0001 (active)
[    0.855613] pnp 00:04: [io  0x0070-0x0071]
[    0.855630] pnp 00:04: [irq 8]
[    0.855649] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.855657] pnp 00:05: [io  0x0061]
[    0.855674] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.855681] pnp 00:06: [io  0x0060]
[    0.855683] pnp 00:06: [io  0x0064]
[    0.855690] pnp 00:06: [irq 1]
[    0.855714] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.855727] pnp 00:07: [irq 12]
[    0.855747] pnp 00:07: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.923838] pnp 00:08: [io  0x0378-0x037f]
[    0.923858] pnp 00:08: [irq 7]
[    0.937655] pnp 00:08: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.963130] pnp 00:09: [io  0x03f8-0x03ff]
[    0.963150] pnp 00:09: [irq 4]
[    0.966233] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.976098] pnp 00:0a: [io  0x02f8-0x02ff]
[    0.976115] pnp 00:0a: [irq 3]
[    0.979001] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.993392] pnp 00:0b: [io  0x03f0-0x03f5]
[    0.993396] pnp 00:0b: [io  0x03f7]
[    0.993412] pnp 00:0b: [irq 6]
[    0.993414] pnp 00:0b: [dma 2]
[    0.995985] pnp 00:0b: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.996217] pnp 00:0c: [mem 0xe0000000-0xefffffff]
[    0.996219] pnp 00:0c: [io  0x1060-0x107f]
[    0.996221] pnp 00:0c: [mem 0xdbe00000-0xdbffffff]
[    0.996292] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.201866] pnp: PnP ACPI: found 13 devices
[    1.201873] ACPI: ACPI bus type pnp unregistered
[    1.201910] system 00:01: [io  0x1000-0x103f] has been reserved
[    1.201916] system 00:01: [io  0x1040-0x104f] has been reserved
[    1.201922] system 00:01: [io  0x0cf0-0x0cf1] has been reserved
[    1.201939] system 00:0c: [io  0x1060-0x107f] has been reserved
[    1.201948] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    1.201955] system 00:0c: [mem 0xdbe00000-0xdbffffff] has been reserved
[    1.246437] pci 0000:00:0f.0: BAR 6: assigned [mem 0x40000000-0x40007fff 
pref]
[    1.246446] pci 0000:00:10.0: BAR 6: assigned [mem 0x40008000-0x4000bfff 
pref]
[    1.246454] pci 0000:00:15.3: BAR 13: can't assign io (size 0x1000)
[    1.246459] pci 0000:00:15.4: BAR 13: can't assign io (size 0x1000)
[    1.246464] pci 0000:00:15.5: BAR 13: can't assign io (size 0x1000)
[    1.246470] pci 0000:00:15.6: BAR 13: can't assign io (size 0x1000)
[    1.246475] pci 0000:00:15.7: BAR 13: can't assign io (size 0x1000)
[    1.246480] pci 0000:00:16.3: BAR 13: can't assign io (size 0x1000)
[    1.246485] pci 0000:00:16.4: BAR 13: can't assign io (size 0x1000)
[    1.246490] pci 0000:00:16.5: BAR 13: can't assign io (size 0x1000)
[    1.246495] pci 0000:00:16.6: BAR 13: can't assign io (size 0x1000)
[    1.246505] pci 0000:00:16.7: BAR 13: can't assign io (size 0x1000)
[    1.246511] pci 0000:00:17.3: BAR 13: can't assign io (size 0x1000)
[    1.246516] pci 0000:00:17.4: BAR 13: can't assign io (size 0x1000)
[    1.246521] pci 0000:00:17.5: BAR 13: can't assign io (size 0x1000)
[    1.246526] pci 0000:00:17.6: BAR 13: can't assign io (size 0x1000)
[    1.246531] pci 0000:00:17.7: BAR 13: can't assign io (size 0x1000)
[    1.246536] pci 0000:00:18.2: BAR 13: can't assign io (size 0x1000)
[    1.246541] pci 0000:00:18.3: BAR 13: can't assign io (size 0x1000)
[    1.246547] pci 0000:00:18.4: BAR 13: can't assign io (size 0x1000)
[    1.246552] pci 0000:00:18.5: BAR 13: can't assign io (size 0x1000)
[    1.246557] pci 0000:00:18.6: BAR 13: can't assign io (size 0x1000)
[    1.246562] pci 0000:00:18.7: BAR 13: can't assign io (size 0x1000)
[    1.246566] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.246569] pci 0000:00:01.0:   bridge window [io  disabled]
[    1.246666] pci 0000:00:01.0:   bridge window [mem disabled]
[    1.246702] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    1.246822] pci 0000:02:01.0: BAR 6: assigned [mem 0xdc400000-0xdc40ffff 
pref]
[    1.246826] pci 0000:00:11.0: PCI bridge to [bus 02-02]
[    1.246847] pci 0000:00:11.0:   bridge window [io  0x2000-0x3fff]
[    1.246963] pci 0000:00:11.0:   bridge window [mem 0xd8900000-0xd9cfffff]
[    1.246999] pci 0000:00:11.0:   bridge window [mem 0xdc400000-0xdc9fffff 
64bit pref]
[    1.247082] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    1.247102] pci 0000:00:15.0:   bridge window [io  0x4000-0x4fff]
[    1.247152] pci 0000:00:15.0:   bridge window [mem 0xd9d00000-0xd9dfffff]
[    1.247188] pci 0000:00:15.0:   bridge window [mem 0xdca00000-0xdcafffff 
64bit pref]
[    1.247373] pci 0000:00:15.1: PCI bridge to [bus 04-04]
[    1.247395] pci 0000:00:15.1:   bridge window [io  0x8000-0x8fff]
[    1.247445] pci 0000:00:15.1:   bridge window [mem 0xda100000-0xda1fffff]
[    1.247480] pci 0000:00:15.1:   bridge window [mem 0xdce00000-0xdcefffff 
64bit pref]
[    1.247568] pci 0000:00:15.2: PCI bridge to [bus 05-05]
[    1.247588] pci 0000:00:15.2:   bridge window [io  0xc000-0xcfff]
[    1.247639] pci 0000:00:15.2:   bridge window [mem 0xda500000-0xda5fffff]
[    1.247674] pci 0000:00:15.2:   bridge window [mem 0xdd200000-0xdd2fffff 
64bit pref]
[    1.247833] pci 0000:00:15.3: PCI bridge to [bus 06-06]
[    1.247837] pci 0000:00:15.3:   bridge window [io  disabled]
[    1.247895] pci 0000:00:15.3:   bridge window [mem 0xda900000-0xda9fffff]
[    1.247931] pci 0000:00:15.3:   bridge window [mem 0xdd600000-0xdd6fffff 
64bit pref]
[    1.248022] pci 0000:00:15.4: PCI bridge to [bus 07-07]
[    1.248025] pci 0000:00:15.4:   bridge window [io  disabled]
[    1.248076] pci 0000:00:15.4:   bridge window [mem 0xdad00000-0xdadfffff]
[    1.248112] pci 0000:00:15.4:   bridge window [mem 0xdda00000-0xddafffff 
64bit pref]
[    1.248196] pci 0000:00:15.5: PCI bridge to [bus 08-08]
[    1.248199] pci 0000:00:15.5:   bridge window [io  disabled]
[    1.248265] pci 0000:00:15.5:   bridge window [mem 0xdb100000-0xdb1fffff]
[    1.248300] pci 0000:00:15.5:   bridge window [mem 0xdde00000-0xddefffff 
64bit pref]
[    1.248385] pci 0000:00:15.6: PCI bridge to [bus 09-09]
[    1.248388] pci 0000:00:15.6:   bridge window [io  disabled]
[    1.248439] pci 0000:00:15.6:   bridge window [mem 0xdb500000-0xdb5fffff]
[    1.248474] pci 0000:00:15.6:   bridge window [mem 0xde200000-0xde2fffff 
64bit pref]
[    1.248558] pci 0000:00:15.7: PCI bridge to [bus 0a-0a]
[    1.248561] pci 0000:00:15.7:   bridge window [io  disabled]
[    1.248612] pci 0000:00:15.7:   bridge window [mem 0xdb900000-0xdb9fffff]
[    1.248646] pci 0000:00:15.7:   bridge window [mem 0xde600000-0xde6fffff 
64bit pref]
[    1.248763] pci 0000:00:16.0: PCI bridge to [bus 0b-0b]
[    1.248785] pci 0000:00:16.0:   bridge window [io  0x5000-0x5fff]
[    1.248879] pci 0000:00:16.0:   bridge window [mem 0xd9e00000-0xd9efffff]
[    1.248961] pci 0000:00:16.0:   bridge window [mem 0xdcb00000-0xdcbfffff 
64bit pref]
[    1.249053] pci 0000:00:16.1: PCI bridge to [bus 0c-0c]
[    1.249075] pci 0000:00:16.1:   bridge window [io  0x9000-0x9fff]
[    1.249125] pci 0000:00:16.1:   bridge window [mem 0xda200000-0xda2fffff]
[    1.249160] pci 0000:00:16.1:   bridge window [mem 0xdcf00000-0xdcffffff 
64bit pref]
[    1.249259] pci 0000:00:16.2: PCI bridge to [bus 0d-0d]
[    1.249280] pci 0000:00:16.2:   bridge window [io  0xd000-0xdfff]
[    1.249330] pci 0000:00:16.2:   bridge window [mem 0xda600000-0xda6fffff]
[    1.249365] pci 0000:00:16.2:   bridge window [mem 0xdd300000-0xdd3fffff 
64bit pref]
[    1.249449] pci 0000:00:16.3: PCI bridge to [bus 0e-0e]
[    1.249453] pci 0000:00:16.3:   bridge window [io  disabled]
[    1.249505] pci 0000:00:16.3:   bridge window [mem 0xdaa00000-0xdaafffff]
[    1.249540] pci 0000:00:16.3:   bridge window [mem 0xdd700000-0xdd7fffff 
64bit pref]
[    1.249625] pci 0000:00:16.4: PCI bridge to [bus 0f-0f]
[    1.249628] pci 0000:00:16.4:   bridge window [io  disabled]
[    1.249679] pci 0000:00:16.4:   bridge window [mem 0xdae00000-0xdaefffff]
[    1.249727] pci 0000:00:16.4:   bridge window [mem 0xddb00000-0xddbfffff 
64bit pref]
[    1.249813] pci 0000:00:16.5: PCI bridge to [bus 10-10]
[    1.249816] pci 0000:00:16.5:   bridge window [io  disabled]
[    1.249867] pci 0000:00:16.5:   bridge window [mem 0xdb200000-0xdb2fffff]
[    1.249902] pci 0000:00:16.5:   bridge window [mem 0xddf00000-0xddffffff 
64bit pref]
[    1.250036] pci 0000:00:16.6: PCI bridge to [bus 11-11]
[    1.250039] pci 0000:00:16.6:   bridge window [io  disabled]
[    1.250091] pci 0000:00:16.6:   bridge window [mem 0xdb600000-0xdb6fffff]
[    1.250126] pci 0000:00:16.6:   bridge window [mem 0xde300000-0xde3fffff 
64bit pref]
[    1.250223] pci 0000:00:16.7: PCI bridge to [bus 12-12]
[    1.250226] pci 0000:00:16.7:   bridge window [io  disabled]
[    1.250277] pci 0000:00:16.7:   bridge window [mem 0xdba00000-0xdbafffff]
[    1.250312] pci 0000:00:16.7:   bridge window [mem 0xde700000-0xde7fffff 
64bit pref]
[    1.250396] pci 0000:00:17.0: PCI bridge to [bus 13-13]
[    1.250417] pci 0000:00:17.0:   bridge window [io  0x6000-0x6fff]
[    1.250468] pci 0000:00:17.0:   bridge window [mem 0xd9f00000-0xd9ffffff]
[    1.250503] pci 0000:00:17.0:   bridge window [mem 0xdcc00000-0xdccfffff 
64bit pref]
[    1.250586] pci 0000:00:17.1: PCI bridge to [bus 14-14]
[    1.250607] pci 0000:00:17.1:   bridge window [io  0xa000-0xafff]
[    1.250657] pci 0000:00:17.1:   bridge window [mem 0xda300000-0xda3fffff]
[    1.250692] pci 0000:00:17.1:   bridge window [mem 0xdd000000-0xdd0fffff 
64bit pref]
[    1.250783] pci 0000:00:17.2: PCI bridge to [bus 15-15]
[    1.250804] pci 0000:00:17.2:   bridge window [io  0xe000-0xefff]
[    1.250854] pci 0000:00:17.2:   bridge window [mem 0xda700000-0xda7fffff]
[    1.250889] pci 0000:00:17.2:   bridge window [mem 0xdd400000-0xdd4fffff 
64bit pref]
[    1.250972] pci 0000:00:17.3: PCI bridge to [bus 16-16]
[    1.250976] pci 0000:00:17.3:   bridge window [io  disabled]
[    1.251026] pci 0000:00:17.3:   bridge window [mem 0xdab00000-0xdabfffff]
[    1.251061] pci 0000:00:17.3:   bridge window [mem 0xdd800000-0xdd8fffff 
64bit pref]
[    1.251145] pci 0000:00:17.4: PCI bridge to [bus 17-17]
[    1.251148] pci 0000:00:17.4:   bridge window [io  disabled]
[    1.251212] pci 0000:00:17.4:   bridge window [mem 0xdaf00000-0xdaffffff]
[    1.251248] pci 0000:00:17.4:   bridge window [mem 0xddc00000-0xddcfffff 
64bit pref]
[    1.251333] pci 0000:00:17.5: PCI bridge to [bus 18-18]
[    1.251336] pci 0000:00:17.5:   bridge window [io  disabled]
[    1.251387] pci 0000:00:17.5:   bridge window [mem 0xdb300000-0xdb3fffff]
[    1.251421] pci 0000:00:17.5:   bridge window [mem 0xde000000-0xde0fffff 
64bit pref]
[    1.251510] pci 0000:00:17.6: PCI bridge to [bus 19-19]
[    1.251513] pci 0000:00:17.6:   bridge window [io  disabled]
[    1.251564] pci 0000:00:17.6:   bridge window [mem 0xdb700000-0xdb7fffff]
[    1.251599] pci 0000:00:17.6:   bridge window [mem 0xde400000-0xde4fffff 
64bit pref]
[    1.251683] pci 0000:00:17.7: PCI bridge to [bus 1a-1a]
[    1.251686] pci 0000:00:17.7:   bridge window [io  disabled]
[    1.251749] pci 0000:00:17.7:   bridge window [mem 0xdbb00000-0xdbbfffff]
[    1.251784] pci 0000:00:17.7:   bridge window [mem 0xde800000-0xde8fffff 
64bit pref]
[    1.251869] pci 0000:00:18.0: PCI bridge to [bus 1b-1b]
[    1.251889] pci 0000:00:18.0:   bridge window [io  0x7000-0x7fff]
[    1.251940] pci 0000:00:18.0:   bridge window [mem 0xda000000-0xda0fffff]
[    1.251974] pci 0000:00:18.0:   bridge window [mem 0xdcd00000-0xdcdfffff 
64bit pref]
[    1.252059] pci 0000:00:18.1: PCI bridge to [bus 1c-1c]
[    1.252079] pci 0000:00:18.1:   bridge window [io  0xb000-0xbfff]
[    1.252130] pci 0000:00:18.1:   bridge window [mem 0xda400000-0xda4fffff]
[    1.252164] pci 0000:00:18.1:   bridge window [mem 0xdd100000-0xdd1fffff 
64bit pref]
[    1.252262] pci 0000:00:18.2: PCI bridge to [bus 1d-1d]
[    1.252265] pci 0000:00:18.2:   bridge window [io  disabled]
[    1.252316] pci 0000:00:18.2:   bridge window [mem 0xda800000-0xda8fffff]
[    1.252351] pci 0000:00:18.2:   bridge window [mem 0xdd500000-0xdd5fffff 
64bit pref]
[    1.252435] pci 0000:00:18.3: PCI bridge to [bus 1e-1e]
[    1.252438] pci 0000:00:18.3:   bridge window [io  disabled]
[    1.252489] pci 0000:00:18.3:   bridge window [mem 0xdac00000-0xdacfffff]
[    1.252524] pci 0000:00:18.3:   bridge window [mem 0xdd900000-0xdd9fffff 
64bit pref]
[    1.252607] pci 0000:00:18.4: PCI bridge to [bus 1f-1f]
[    1.252610] pci 0000:00:18.4:   bridge window [io  disabled]
[    1.252661] pci 0000:00:18.4:   bridge window [mem 0xdb000000-0xdb0fffff]
[    1.252696] pci 0000:00:18.4:   bridge window [mem 0xddd00000-0xdddfffff 
64bit pref]
[    1.252795] pci 0000:00:18.5: PCI bridge to [bus 20-20]
[    1.252798] pci 0000:00:18.5:   bridge window [io  disabled]
[    1.252849] pci 0000:00:18.5:   bridge window [mem 0xdb400000-0xdb4fffff]
[    1.252884] pci 0000:00:18.5:   bridge window [mem 0xde100000-0xde1fffff 
64bit pref]
[    1.252967] pci 0000:00:18.6: PCI bridge to [bus 21-21]
[    1.252971] pci 0000:00:18.6:   bridge window [io  disabled]
[    1.253022] pci 0000:00:18.6:   bridge window [mem 0xdb800000-0xdb8fffff]
[    1.253056] pci 0000:00:18.6:   bridge window [mem 0xde500000-0xde5fffff 
64bit pref]
[    1.253140] pci 0000:00:18.7: PCI bridge to [bus 22-22]
[    1.253143] pci 0000:00:18.7:   bridge window [io  disabled]
[    1.253194] pci 0000:00:18.7:   bridge window [mem 0xdbc00000-0xdbcfffff]
[    1.253255] pci 0000:00:18.7:   bridge window [mem 0xde900000-0xde9fffff 
64bit pref]
[    1.253445] pci 0000:00:01.0: setting latency timer to 64
[    1.253610] pci 0000:00:15.0: setting latency timer to 64
[    1.253721] pci 0000:00:15.1: setting latency timer to 64
[    1.253841] pci 0000:00:15.2: setting latency timer to 64
[    1.253925] pci 0000:00:15.3: setting latency timer to 64
[    1.254010] pci 0000:00:15.4: setting latency timer to 64
[    1.254093] pci 0000:00:15.5: setting latency timer to 64
[    1.254177] pci 0000:00:15.6: setting latency timer to 64
[    1.254267] pci 0000:00:15.7: setting latency timer to 64
[    1.254351] pci 0000:00:16.0: setting latency timer to 64
[    1.254435] pci 0000:00:16.1: setting latency timer to 64
[    1.254518] pci 0000:00:16.2: setting latency timer to 64
[    1.254603] pci 0000:00:16.3: setting latency timer to 64
[    1.254701] pci 0000:00:16.4: setting latency timer to 64
[    1.254785] pci 0000:00:16.5: setting latency timer to 64
[    1.254869] pci 0000:00:16.6: setting latency timer to 64
[    1.254953] pci 0000:00:16.7: setting latency timer to 64
[    1.255040] pci 0000:00:17.0: setting latency timer to 64
[    1.255124] pci 0000:00:17.1: setting latency timer to 64
[    1.255219] pci 0000:00:17.2: setting latency timer to 64
[    1.255303] pci 0000:00:17.3: setting latency timer to 64
[    1.255387] pci 0000:00:17.4: setting latency timer to 64
[    1.255471] pci 0000:00:17.5: setting latency timer to 64
[    1.255554] pci 0000:00:17.6: setting latency timer to 64
[    1.255638] pci 0000:00:17.7: setting latency timer to 64
[    1.255747] pci 0000:00:18.0: setting latency timer to 64
[    1.255831] pci 0000:00:18.1: setting latency timer to 64
[    1.255915] pci 0000:00:18.2: setting latency timer to 64
[    1.255999] pci 0000:00:18.3: setting latency timer to 64
[    1.256082] pci 0000:00:18.4: setting latency timer to 64
[    1.256166] pci 0000:00:18.5: setting latency timer to 64
[    1.256262] pci 0000:00:18.6: setting latency timer to 64
[    1.256346] pci 0000:00:18.7: setting latency timer to 64
[    1.256367] pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff]
[    1.256371] pci_bus 0000:00: resource 5 [mem 0x000cc000-0x000cffff]
[    1.256374] pci_bus 0000:00: resource 6 [mem 0x000d0000-0x000d3fff]
[    1.256377] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.256381] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.256384] pci_bus 0000:00: resource 9 [mem 0x000e4000-0x000e7fff]
[    1.256388] pci_bus 0000:00: resource 10 [mem 0x40000000-0xfebfffff]
[    1.256391] pci_bus 0000:00: resource 11 [io  0x0000-0x0cf7]
[    1.256395] pci_bus 0000:00: resource 12 [io  0x0d00-0xfeff]
[    1.256398] pci_bus 0000:02: resource 0 [io  0x2000-0x3fff]
[    1.256402] pci_bus 0000:02: resource 1 [mem 0xd8900000-0xd9cfffff]
[    1.256405] pci_bus 0000:02: resource 2 [mem 0xdc400000-0xdc9fffff 64bit 
pref]
[    1.256409] pci_bus 0000:02: resource 4 [mem 0x000a0000-0x000bffff]
[    1.256412] pci_bus 0000:02: resource 5 [mem 0x000cc000-0x000cffff]
[    1.256416] pci_bus 0000:02: resource 6 [mem 0x000d0000-0x000d3fff]
[    1.256419] pci_bus 0000:02: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.256422] pci_bus 0000:02: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.256426] pci_bus 0000:02: resource 9 [mem 0x000e4000-0x000e7fff]
[    1.256429] pci_bus 0000:02: resource 10 [mem 0x40000000-0xfebfffff]
[    1.256432] pci_bus 0000:02: resource 11 [io  0x0000-0x0cf7]
[    1.256436] pci_bus 0000:02: resource 12 [io  0x0d00-0xfeff]
[    1.256439] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
[    1.256443] pci_bus 0000:03: resource 1 [mem 0xd9d00000-0xd9dfffff]
[    1.256446] pci_bus 0000:03: resource 2 [mem 0xdca00000-0xdcafffff 64bit 
pref]
[    1.256450] pci_bus 0000:04: resource 0 [io  0x8000-0x8fff]
[    1.256453] pci_bus 0000:04: resource 1 [mem 0xda100000-0xda1fffff]
[    1.256457] pci_bus 0000:04: resource 2 [mem 0xdce00000-0xdcefffff 64bit 
pref]
[    1.256461] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    1.256464] pci_bus 0000:05: resource 1 [mem 0xda500000-0xda5fffff]
[    1.256467] pci_bus 0000:05: resource 2 [mem 0xdd200000-0xdd2fffff 64bit 
pref]
[    1.256471] pci_bus 0000:06: resource 1 [mem 0xda900000-0xda9fffff]
[    1.256475] pci_bus 0000:06: resource 2 [mem 0xdd600000-0xdd6fffff 64bit 
pref]
[    1.256478] pci_bus 0000:07: resource 1 [mem 0xdad00000-0xdadfffff]
[    1.256482] pci_bus 0000:07: resource 2 [mem 0xdda00000-0xddafffff 64bit 
pref]
[    1.256486] pci_bus 0000:08: resource 1 [mem 0xdb100000-0xdb1fffff]
[    1.256489] pci_bus 0000:08: resource 2 [mem 0xdde00000-0xddefffff 64bit 
pref]
[    1.256493] pci_bus 0000:09: resource 1 [mem 0xdb500000-0xdb5fffff]
[    1.256496] pci_bus 0000:09: resource 2 [mem 0xde200000-0xde2fffff 64bit 
pref]
[    1.256500] pci_bus 0000:0a: resource 1 [mem 0xdb900000-0xdb9fffff]
[    1.256504] pci_bus 0000:0a: resource 2 [mem 0xde600000-0xde6fffff 64bit 
pref]
[    1.256507] pci_bus 0000:0b: resource 0 [io  0x5000-0x5fff]
[    1.256514] pci_bus 0000:0b: resource 1 [mem 0xd9e00000-0xd9efffff]
[    1.256517] pci_bus 0000:0b: resource 2 [mem 0xdcb00000-0xdcbfffff 64bit 
pref]
[    1.256521] pci_bus 0000:0c: resource 0 [io  0x9000-0x9fff]
[    1.256524] pci_bus 0000:0c: resource 1 [mem 0xda200000-0xda2fffff]
[    1.256528] pci_bus 0000:0c: resource 2 [mem 0xdcf00000-0xdcffffff 64bit 
pref]
[    1.256532] pci_bus 0000:0d: resource 0 [io  0xd000-0xdfff]
[    1.256535] pci_bus 0000:0d: resource 1 [mem 0xda600000-0xda6fffff]
[    1.256538] pci_bus 0000:0d: resource 2 [mem 0xdd300000-0xdd3fffff 64bit 
pref]
[    1.256542] pci_bus 0000:0e: resource 1 [mem 0xdaa00000-0xdaafffff]
[    1.256546] pci_bus 0000:0e: resource 2 [mem 0xdd700000-0xdd7fffff 64bit 
pref]
[    1.256549] pci_bus 0000:0f: resource 1 [mem 0xdae00000-0xdaefffff]
[    1.256553] pci_bus 0000:0f: resource 2 [mem 0xddb00000-0xddbfffff 64bit 
pref]
[    1.256556] pci_bus 0000:10: resource 1 [mem 0xdb200000-0xdb2fffff]
[    1.256560] pci_bus 0000:10: resource 2 [mem 0xddf00000-0xddffffff 64bit 
pref]
[    1.256564] pci_bus 0000:11: resource 1 [mem 0xdb600000-0xdb6fffff]
[    1.256567] pci_bus 0000:11: resource 2 [mem 0xde300000-0xde3fffff 64bit 
pref]
[    1.256571] pci_bus 0000:12: resource 1 [mem 0xdba00000-0xdbafffff]
[    1.256574] pci_bus 0000:12: resource 2 [mem 0xde700000-0xde7fffff 64bit 
pref]
[    1.256578] pci_bus 0000:13: resource 0 [io  0x6000-0x6fff]
[    1.256581] pci_bus 0000:13: resource 1 [mem 0xd9f00000-0xd9ffffff]
[    1.256585] pci_bus 0000:13: resource 2 [mem 0xdcc00000-0xdccfffff 64bit 
pref]
[    1.256589] pci_bus 0000:14: resource 0 [io  0xa000-0xafff]
[    1.256591] pci_bus 0000:14: resource 1 [mem 0xda300000-0xda3fffff]
[    1.256591] pci_bus 0000:14: resource 2 [mem 0xdd000000-0xdd0fffff 64bit 
pref]
[    1.256591] pci_bus 0000:15: resource 0 [io  0xe000-0xefff]
[    1.256591] pci_bus 0000:15: resource 1 [mem 0xda700000-0xda7fffff]
[    1.256591] pci_bus 0000:15: resource 2 [mem 0xdd400000-0xdd4fffff 64bit 
pref]
[    1.256591] pci_bus 0000:16: resource 1 [mem 0xdab00000-0xdabfffff]
[    1.256591] pci_bus 0000:16: resource 2 [mem 0xdd800000-0xdd8fffff 64bit 
pref]
[    1.256591] pci_bus 0000:17: resource 1 [mem 0xdaf00000-0xdaffffff]
[    1.256591] pci_bus 0000:17: resource 2 [mem 0xddc00000-0xddcfffff 64bit 
pref]
[    1.256591] pci_bus 0000:18: resource 1 [mem 0xdb300000-0xdb3fffff]
[    1.256591] pci_bus 0000:18: resource 2 [mem 0xde000000-0xde0fffff 64bit 
pref]
[    1.256591] pci_bus 0000:19: resource 1 [mem 0xdb700000-0xdb7fffff]
[    1.256591] pci_bus 0000:19: resource 2 [mem 0xde400000-0xde4fffff 64bit 
pref]
[    1.256591] pci_bus 0000:1a: resource 1 [mem 0xdbb00000-0xdbbfffff]
[    1.256591] pci_bus 0000:1a: resource 2 [mem 0xde800000-0xde8fffff 64bit 
pref]
[    1.256591] pci_bus 0000:1b: resource 0 [io  0x7000-0x7fff]
[    1.256591] pci_bus 0000:1b: resource 1 [mem 0xda000000-0xda0fffff]
[    1.256591] pci_bus 0000:1b: resource 2 [mem 0xdcd00000-0xdcdfffff 64bit 
pref]
[    1.256591] pci_bus 0000:1c: resource 0 [io  0xb000-0xbfff]
[    1.256591] pci_bus 0000:1c: resource 1 [mem 0xda400000-0xda4fffff]
[    1.256591] pci_bus 0000:1c: resource 2 [mem 0xdd100000-0xdd1fffff 64bit 
pref]
[    1.256591] pci_bus 0000:1d: resource 1 [mem 0xda800000-0xda8fffff]
[    1.256591] pci_bus 0000:1d: resource 2 [mem 0xdd500000-0xdd5fffff 64bit 
pref]
[    1.256591] pci_bus 0000:1e: resource 1 [mem 0xdac00000-0xdacfffff]
[    1.256591] pci_bus 0000:1e: resource 2 [mem 0xdd900000-0xdd9fffff 64bit 
pref]
[    1.256607] pci_bus 0000:1f: resource 1 [mem 0xdb000000-0xdb0fffff]
[    1.256627] pci_bus 0000:1f: resource 2 [mem 0xddd00000-0xdddfffff 64bit 
pref]
[    1.256631] pci_bus 0000:20: resource 1 [mem 0xdb400000-0xdb4fffff]
[    1.256634] pci_bus 0000:20: resource 2 [mem 0xde100000-0xde1fffff 64bit 
pref]
[    1.256638] pci_bus 0000:21: resource 1 [mem 0xdb800000-0xdb8fffff]
[    1.256641] pci_bus 0000:21: resource 2 [mem 0xde500000-0xde5fffff 64bit 
pref]
[    1.256648] pci_bus 0000:22: resource 1 [mem 0xdbc00000-0xdbcfffff]
[    1.256651] pci_bus 0000:22: resource 2 [mem 0xde900000-0xde9fffff 64bit 
pref]
[    1.256797] NET: Registered protocol family 2
[    1.256846] IP route cache hash table entries: 32768 (order: 5, 131072 
bytes)
[    1.256950] TCP established hash table entries: 131072 (order: 8, 1048576 
bytes)
[    1.257158] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    1.261002] TCP: Hash tables configured (established 131072 bind 65536)
[    1.261007] TCP reno registered
[    1.261015] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    1.261035] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    1.261347] NET: Registered protocol family 1
[    1.261363] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.261511] pci 0000:00:0f.0: Boot video device
[    1.262728] PCI: CLS 32 bytes, default 64
[    1.262798] Trying to unpack rootfs image as initramfs...
[    1.337076] Freeing initrd memory: 4184k freed
[    1.337180] Simple Boot Flag at 0x36 set to 0x1
[    1.337857] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[    1.337860] apm: disabled - APM is not SMP safe.
[    1.337964] audit: initializing netlink socket (disabled)
[    1.337979] type=2000 audit(1294326381.106:1): initialized
[    1.357321] highmem bounce pool size: 64 pages
[    1.357328] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.357820] VFS: Disk quotas dquot_6.5.2
[    1.357869] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.357973] NTFS driver 2.1.29 [Flags: R/W].
[    1.358046] msgmni has been set to 1732
[    1.358119] SELinux:  Registering netfilter hooks
[    1.358824] alg: No test for stdrng (krng)
[    1.358881] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
253)
[    1.358885] io scheduler noop registered
[    1.358887] io scheduler deadline registered
[    1.358900] io scheduler cfq registered (default)
[    1.359379] pcieport 0000:00:15.0: ACPI _OSC control granted for 0x15
[    1.359546] pcieport 0000:00:15.0: setting latency timer to 64
[    1.360223] pcieport 0000:00:15.0: irq 40 for MSI/MSI-X
[    1.361121] pcieport 0000:00:15.1: ACPI _OSC control granted for 0x15
[    1.361276] pcieport 0000:00:15.1: setting latency timer to 64
[    1.361976] pcieport 0000:00:15.1: irq 41 for MSI/MSI-X
[    1.362826] pcieport 0000:00:15.2: ACPI _OSC control granted for 0x15
[    1.362989] pcieport 0000:00:15.2: setting latency timer to 64
[    1.363679] pcieport 0000:00:15.2: irq 42 for MSI/MSI-X
[    1.364547] pcieport 0000:00:15.3: ACPI _OSC control granted for 0x15
[    1.364683] pcieport 0000:00:15.3: setting latency timer to 64
[    1.365309] pcieport 0000:00:15.3: irq 43 for MSI/MSI-X
[    1.366225] pcieport 0000:00:15.4: ACPI _OSC control granted for 0x15
[    1.366399] pcieport 0000:00:15.4: setting latency timer to 64
[    1.367101] pcieport 0000:00:15.4: irq 44 for MSI/MSI-X
[    1.367971] pcieport 0000:00:15.5: ACPI _OSC control granted for 0x15
[    1.368106] pcieport 0000:00:15.5: setting latency timer to 64
[    1.368838] pcieport 0000:00:15.5: irq 45 for MSI/MSI-X
[    1.369993] pcieport 0000:00:15.6: ACPI _OSC control granted for 0x15
[    1.370164] pcieport 0000:00:15.6: setting latency timer to 64
[    1.370967] pcieport 0000:00:15.6: irq 46 for MSI/MSI-X
[    1.372095] pcieport 0000:00:15.7: ACPI _OSC control granted for 0x15
[    1.372375] pcieport 0000:00:15.7: setting latency timer to 64
[    1.373068] pcieport 0000:00:15.7: irq 47 for MSI/MSI-X
[    1.373995] pcieport 0000:00:16.0: ACPI _OSC control granted for 0x15
[    1.374149] pcieport 0000:00:16.0: setting latency timer to 64
[    1.374776] pcieport 0000:00:16.0: irq 48 for MSI/MSI-X
[    1.375640] pcieport 0000:00:16.1: ACPI _OSC control granted for 0x15
[    1.375834] pcieport 0000:00:16.1: setting latency timer to 64
[    1.376521] pcieport 0000:00:16.1: irq 49 for MSI/MSI-X
[    1.377501] pcieport 0000:00:16.2: ACPI _OSC control granted for 0x15
[    1.377635] pcieport 0000:00:16.2: setting latency timer to 64
[    1.378266] pcieport 0000:00:16.2: irq 50 for MSI/MSI-X
[    1.379121] pcieport 0000:00:16.3: ACPI _OSC control granted for 0x15
[    1.379255] pcieport 0000:00:16.3: setting latency timer to 64
[    1.379908] pcieport 0000:00:16.3: irq 51 for MSI/MSI-X
[    1.380774] pcieport 0000:00:16.4: ACPI _OSC control granted for 0x15
[    1.380908] pcieport 0000:00:16.4: setting latency timer to 64
[    1.381560] pcieport 0000:00:16.4: irq 52 for MSI/MSI-X
[    1.382408] pcieport 0000:00:16.5: ACPI _OSC control granted for 0x15
[    1.382585] pcieport 0000:00:16.5: setting latency timer to 64
[    1.383377] pcieport 0000:00:16.5: irq 53 for MSI/MSI-X
[    1.384528] pcieport 0000:00:16.6: ACPI _OSC control granted for 0x15
[    1.384702] pcieport 0000:00:16.6: setting latency timer to 64
[    1.385372] pcieport 0000:00:16.6: irq 54 for MSI/MSI-X
[    1.386496] pcieport 0000:00:16.7: ACPI _OSC control granted for 0x15
[    1.386666] pcieport 0000:00:16.7: setting latency timer to 64
[    1.387471] pcieport 0000:00:16.7: irq 55 for MSI/MSI-X
[    1.388534] pcieport 0000:00:17.0: ACPI _OSC control granted for 0x15
[    1.388668] pcieport 0000:00:17.0: setting latency timer to 64
[    1.389440] pcieport 0000:00:17.0: irq 56 for MSI/MSI-X
[    1.390584] pcieport 0000:00:17.1: ACPI _OSC control granted for 0x15
[    1.390769] pcieport 0000:00:17.1: setting latency timer to 64
[    1.391402] pcieport 0000:00:17.1: irq 57 for MSI/MSI-X
[    1.392247] pcieport 0000:00:17.2: ACPI _OSC control granted for 0x15
[    1.392381] pcieport 0000:00:17.2: setting latency timer to 64
[    1.393103] pcieport 0000:00:17.2: irq 58 for MSI/MSI-X
[    1.393960] pcieport 0000:00:17.3: ACPI _OSC control granted for 0x15
[    1.394094] pcieport 0000:00:17.3: setting latency timer to 64
[    1.394729] pcieport 0000:00:17.3: irq 59 for MSI/MSI-X
[    1.395554] pcieport 0000:00:17.4: ACPI _OSC control granted for 0x15
[    1.395688] pcieport 0000:00:17.4: setting latency timer to 64
[    1.396331] pcieport 0000:00:17.4: irq 60 for MSI/MSI-X
[    1.397397] pcieport 0000:00:17.5: ACPI _OSC control granted for 0x15
[    1.397568] pcieport 0000:00:17.5: setting latency timer to 64
[    1.398378] pcieport 0000:00:17.5: irq 61 for MSI/MSI-X
[    1.399293] pcieport 0000:00:17.6: ACPI _OSC control granted for 0x15
[    1.399427] pcieport 0000:00:17.6: setting latency timer to 64
[    1.400099] pcieport 0000:00:17.6: irq 62 for MSI/MSI-X
[    1.400955] pcieport 0000:00:17.7: ACPI _OSC control granted for 0x15
[    1.401089] pcieport 0000:00:17.7: setting latency timer to 64
[    1.401839] pcieport 0000:00:17.7: irq 63 for MSI/MSI-X
[    1.402852] pcieport 0000:00:18.0: ACPI _OSC control granted for 0x15
[    1.402986] pcieport 0000:00:18.0: setting latency timer to 64
[    1.403638] pcieport 0000:00:18.0: irq 64 for MSI/MSI-X
[    1.404470] pcieport 0000:00:18.1: ACPI _OSC control granted for 0x15
[    1.404621] pcieport 0000:00:18.1: setting latency timer to 64
[    1.405243] pcieport 0000:00:18.1: irq 65 for MSI/MSI-X
[    1.406096] pcieport 0000:00:18.2: ACPI _OSC control granted for 0x15
[    1.406230] pcieport 0000:00:18.2: setting latency timer to 64
[    1.406979] pcieport 0000:00:18.2: irq 66 for MSI/MSI-X
[    1.407935] pcieport 0000:00:18.3: ACPI _OSC control granted for 0x15
[    1.408092] pcieport 0000:00:18.3: setting latency timer to 64
[    1.408796] pcieport 0000:00:18.3: irq 67 for MSI/MSI-X
[    1.409935] pcieport 0000:00:18.4: ACPI _OSC control granted for 0x15
[    1.410126] pcieport 0000:00:18.4: setting latency timer to 64
[    1.410780] pcieport 0000:00:18.4: irq 68 for MSI/MSI-X
[    1.411635] pcieport 0000:00:18.5: ACPI _OSC control granted for 0x15
[    1.411768] pcieport 0000:00:18.5: setting latency timer to 64
[    1.412416] pcieport 0000:00:18.5: irq 69 for MSI/MSI-X
[    1.413297] pcieport 0000:00:18.6: ACPI _OSC control granted for 0x15
[    1.413442] pcieport 0000:00:18.6: setting latency timer to 64
[    1.414072] pcieport 0000:00:18.6: irq 70 for MSI/MSI-X
[    1.415128] pcieport 0000:00:18.7: ACPI _OSC control granted for 0x15
[    1.415304] pcieport 0000:00:18.7: setting latency timer to 64
[    1.416133] pcieport 0000:00:18.7: irq 71 for MSI/MSI-X
[    1.417140] pcieport 0000:00:15.0: Signaling PME through PCIe PME interrupt
[    1.417179] pcie_pme 0000:00:15.0:pcie01: service driver pcie_pme loaded
[    1.417399] pcieport 0000:00:15.1: Signaling PME through PCIe PME interrupt
[    1.417437] pcie_pme 0000:00:15.1:pcie01: service driver pcie_pme loaded
[    1.417657] pcieport 0000:00:15.2: Signaling PME through PCIe PME interrupt
[    1.417695] pcie_pme 0000:00:15.2:pcie01: service driver pcie_pme loaded
[    1.417882] pcieport 0000:00:15.3: Signaling PME through PCIe PME interrupt
[    1.417912] pcie_pme 0000:00:15.3:pcie01: service driver pcie_pme loaded
[    1.418090] pcieport 0000:00:15.4: Signaling PME through PCIe PME interrupt
[    1.418120] pcie_pme 0000:00:15.4:pcie01: service driver pcie_pme loaded
[    1.418311] pcieport 0000:00:15.5: Signaling PME through PCIe PME interrupt
[    1.418341] pcie_pme 0000:00:15.5:pcie01: service driver pcie_pme loaded
[    1.418515] pcieport 0000:00:15.6: Signaling PME through PCIe PME interrupt
[    1.418544] pcie_pme 0000:00:15.6:pcie01: service driver pcie_pme loaded
[    1.418712] pcieport 0000:00:15.7: Signaling PME through PCIe PME interrupt
[    1.418742] pcie_pme 0000:00:15.7:pcie01: service driver pcie_pme loaded
[    1.418923] pcieport 0000:00:16.0: Signaling PME through PCIe PME interrupt
[    1.418953] pcie_pme 0000:00:16.0:pcie01: service driver pcie_pme loaded
[    1.419120] pcieport 0000:00:16.1: Signaling PME through PCIe PME interrupt
[    1.419149] pcie_pme 0000:00:16.1:pcie01: service driver pcie_pme loaded
[    1.419338] pcieport 0000:00:16.2: Signaling PME through PCIe PME interrupt
[    1.419368] pcie_pme 0000:00:16.2:pcie01: service driver pcie_pme loaded
[    1.419538] pcieport 0000:00:16.3: Signaling PME through PCIe PME interrupt
[    1.419568] pcie_pme 0000:00:16.3:pcie01: service driver pcie_pme loaded
[    1.419780] pcieport 0000:00:16.4: Signaling PME through PCIe PME interrupt
[    1.419810] pcie_pme 0000:00:16.4:pcie01: service driver pcie_pme loaded
[    1.419978] pcieport 0000:00:16.5: Signaling PME through PCIe PME interrupt
[    1.420008] pcie_pme 0000:00:16.5:pcie01: service driver pcie_pme loaded
[    1.420175] pcieport 0000:00:16.6: Signaling PME through PCIe PME interrupt
[    1.420204] pcie_pme 0000:00:16.6:pcie01: service driver pcie_pme loaded
[    1.420393] pcieport 0000:00:16.7: Signaling PME through PCIe PME interrupt
[    1.420422] pcie_pme 0000:00:16.7:pcie01: service driver pcie_pme loaded
[    1.420590] pcieport 0000:00:17.0: Signaling PME through PCIe PME interrupt
[    1.420619] pcie_pme 0000:00:17.0:pcie01: service driver pcie_pme loaded
[    1.420797] pcieport 0000:00:17.1: Signaling PME through PCIe PME interrupt
[    1.420826] pcie_pme 0000:00:17.1:pcie01: service driver pcie_pme loaded
[    1.420994] pcieport 0000:00:17.2: Signaling PME through PCIe PME interrupt
[    1.421024] pcie_pme 0000:00:17.2:pcie01: service driver pcie_pme loaded
[    1.421190] pcieport 0000:00:17.3: Signaling PME through PCIe PME interrupt
[    1.421220] pcie_pme 0000:00:17.3:pcie01: service driver pcie_pme loaded
[    1.421397] pcieport 0000:00:17.4: Signaling PME through PCIe PME interrupt
[    1.421427] pcie_pme 0000:00:17.4:pcie01: service driver pcie_pme loaded
[    1.421595] pcieport 0000:00:17.5: Signaling PME through PCIe PME interrupt
[    1.421625] pcie_pme 0000:00:17.5:pcie01: service driver pcie_pme loaded
[    1.421804] pcieport 0000:00:17.6: Signaling PME through PCIe PME interrupt
[    1.421837] pcie_pme 0000:00:17.6:pcie01: service driver pcie_pme loaded
[    1.422005] pcieport 0000:00:17.7: Signaling PME through PCIe PME interrupt
[    1.422034] pcie_pme 0000:00:17.7:pcie01: service driver pcie_pme loaded
[    1.422201] pcieport 0000:00:18.0: Signaling PME through PCIe PME interrupt
[    1.422242] pcie_pme 0000:00:18.0:pcie01: service driver pcie_pme loaded
[    1.422413] pcieport 0000:00:18.1: Signaling PME through PCIe PME interrupt
[    1.422442] pcie_pme 0000:00:18.1:pcie01: service driver pcie_pme loaded
[    1.422610] pcieport 0000:00:18.2: Signaling PME through PCIe PME interrupt
[    1.422639] pcie_pme 0000:00:18.2:pcie01: service driver pcie_pme loaded
[    1.422829] pcieport 0000:00:18.3: Signaling PME through PCIe PME interrupt
[    1.422858] pcie_pme 0000:00:18.3:pcie01: service driver pcie_pme loaded
[    1.423063] pcieport 0000:00:18.4: Signaling PME through PCIe PME interrupt
[    1.423093] pcie_pme 0000:00:18.4:pcie01: service driver pcie_pme loaded
[    1.423268] pcieport 0000:00:18.5: Signaling PME through PCIe PME interrupt
[    1.423297] pcie_pme 0000:00:18.5:pcie01: service driver pcie_pme loaded
[    1.423465] pcieport 0000:00:18.6: Signaling PME through PCIe PME interrupt
[    1.423494] pcie_pme 0000:00:18.6:pcie01: service driver pcie_pme loaded
[    1.423661] pcieport 0000:00:18.7: Signaling PME through PCIe PME interrupt
[    1.423690] pcie_pme 0000:00:18.7:pcie01: service driver pcie_pme loaded
[    1.423720] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.424417] pciehp 0000:00:15.0:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.424527] pciehp 0000:00:15.0:pcie04: service driver pciehp loaded
[    1.424612] pciehp 0000:00:15.1:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.424717] pciehp 0000:00:15.1:pcie04: service driver pciehp loaded
[    1.424843] pciehp 0000:00:15.2:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.424980] pciehp 0000:00:15.2:pcie04: service driver pciehp loaded
[    1.425087] pciehp 0000:00:15.3:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.425233] pciehp 0000:00:15.3:pcie04: service driver pciehp loaded
[    1.425341] pciehp 0000:00:15.4:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.425476] pciehp 0000:00:15.4:pcie04: service driver pciehp loaded
[    1.425585] pciehp 0000:00:15.5:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.425735] pciehp 0000:00:15.5:pcie04: service driver pciehp loaded
[    1.425873] pciehp 0000:00:15.6:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.426012] pciehp 0000:00:15.6:pcie04: service driver pciehp loaded
[    1.426120] pciehp 0000:00:15.7:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.426281] pciehp 0000:00:15.7:pcie04: service driver pciehp loaded
[    1.426414] pciehp 0000:00:16.0:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.426526] pciehp 0000:00:16.0:pcie04: service driver pciehp loaded
[    1.426617] pciehp 0000:00:16.1:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.426724] pciehp 0000:00:16.1:pcie04: service driver pciehp loaded
[    1.426810] pciehp 0000:00:16.2:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.426916] pciehp 0000:00:16.2:pcie04: service driver pciehp loaded
[    1.427001] pciehp 0000:00:16.3:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.427112] pciehp 0000:00:16.3:pcie04: service driver pciehp loaded
[    1.427197] pciehp 0000:00:16.4:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.427321] pciehp 0000:00:16.4:pcie04: service driver pciehp loaded
[    1.427406] pciehp 0000:00:16.5:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.427512] pciehp 0000:00:16.5:pcie04: service driver pciehp loaded
[    1.427600] pciehp 0000:00:16.6:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.427705] pciehp 0000:00:16.6:pcie04: service driver pciehp loaded
[    1.427790] pciehp 0000:00:16.7:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.427895] pciehp 0000:00:16.7:pcie04: service driver pciehp loaded
[    1.427980] pciehp 0000:00:17.0:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.428084] pciehp 0000:00:17.0:pcie04: service driver pciehp loaded
[    1.428169] pciehp 0000:00:17.1:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.428286] pciehp 0000:00:17.1:pcie04: service driver pciehp loaded
[    1.428372] pciehp 0000:00:17.2:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.428477] pciehp 0000:00:17.2:pcie04: service driver pciehp loaded
[    1.428562] pciehp 0000:00:17.3:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.428667] pciehp 0000:00:17.3:pcie04: service driver pciehp loaded
[    1.428762] pciehp 0000:00:17.4:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.428867] pciehp 0000:00:17.4:pcie04: service driver pciehp loaded
[    1.428953] pciehp 0000:00:17.5:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.429058] pciehp 0000:00:17.5:pcie04: service driver pciehp loaded
[    1.429143] pciehp 0000:00:17.6:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.429264] pciehp 0000:00:17.6:pcie04: service driver pciehp loaded
[    1.429349] pciehp 0000:00:17.7:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.429455] pciehp 0000:00:17.7:pcie04: service driver pciehp loaded
[    1.429540] pciehp 0000:00:18.0:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.429668] pciehp 0000:00:18.0:pcie04: service driver pciehp loaded
[    1.429772] pciehp 0000:00:18.1:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.429878] pciehp 0000:00:18.1:pcie04: service driver pciehp loaded
[    1.429964] pciehp 0000:00:18.2:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.430069] pciehp 0000:00:18.2:pcie04: service driver pciehp loaded
[    1.430154] pciehp 0000:00:18.3:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.430268] pciehp 0000:00:18.3:pcie04: service driver pciehp loaded
[    1.430354] pciehp 0000:00:18.4:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.430459] pciehp 0000:00:18.4:pcie04: service driver pciehp loaded
[    1.430545] pciehp 0000:00:18.5:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.430655] pciehp 0000:00:18.5:pcie04: service driver pciehp loaded
[    1.430741] pciehp 0000:00:18.6:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.430846] pciehp 0000:00:18.6:pcie04: service driver pciehp loaded
[    1.430932] pciehp 0000:00:18.7:pcie04: HPC vendor_id 15ad device_id 7a0 
ss_vid 15ad ss_did 7a0
[    1.431043] pciehp 0000:00:18.7:pcie04: service driver pciehp loaded
[    1.431052] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.431055] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.431159] acpiphp: Slot [32] registered
[    1.431179] acpiphp: Slot [33] registered
[    1.431196] acpiphp: Slot [34] registered
[    1.431213] acpiphp: Slot [35] registered
[    1.431230] acpiphp: Slot [36] registered
[    1.431248] acpiphp: Slot [37] registered
[    1.431265] acpiphp: Slot [38] registered
[    1.431282] acpiphp: Slot [39] registered
[    1.431304] acpiphp: Slot [40] registered
[    1.431322] acpiphp: Slot [41] registered
[    1.431339] acpiphp: Slot [42] registered
[    1.431356] acpiphp: Slot [43] registered
[    1.431374] acpiphp: Slot [44] registered
[    1.431391] acpiphp: Slot [45] registered
[    1.431408] acpiphp: Slot [46] registered
[    1.431451] acpiphp: Slot [47] registered
[    1.431470] acpiphp: Slot [48] registered
[    1.431487] acpiphp: Slot [49] registered
[    1.431505] acpiphp: Slot [50] registered
[    1.431522] acpiphp: Slot [51] registered
[    1.431539] acpiphp: Slot [52] registered
[    1.431562] acpiphp: Slot [53] registered
[    1.431580] acpiphp: Slot [54] registered
[    1.431603] acpiphp: Slot [55] registered
[    1.431621] acpiphp: Slot [56] registered
[    1.431639] acpiphp: Slot [57] registered
[    1.431656] acpiphp: Slot [58] registered
[    1.431674] acpiphp: Slot [59] registered
[    1.431692] acpiphp: Slot [60] registered
[    1.431709] acpiphp: Slot [61] registered
[    1.431727] acpiphp: Slot [62] registered
[    1.431749] acpiphp: Slot [63] registered
[    1.431853] acpiphp_glue: Slot 160 already registered by another hotplug 
driver
[    1.431874] acpiphp_glue: Slot 192 already registered by another hotplug 
driver
[    1.431908] acpiphp_glue: Slot 224 already registered by another hotplug 
driver
[    1.431930] acpiphp_glue: Slot 256 already registered by another hotplug 
driver
[    1.431968] acpiphp_glue: Slot 161 already registered by another hotplug 
driver
[    1.431988] acpiphp_glue: Slot 162 already registered by another hotplug 
driver
[    1.432008] acpiphp_glue: Slot 163 already registered by another hotplug 
driver
[    1.432028] acpiphp_glue: Slot 164 already registered by another hotplug 
driver
[    1.432048] acpiphp_glue: Slot 165 already registered by another hotplug 
driver
[    1.432068] acpiphp_glue: Slot 166 already registered by another hotplug 
driver
[    1.432088] acpiphp_glue: Slot 167 already registered by another hotplug 
driver
[    1.432109] acpiphp_glue: Slot 193 already registered by another hotplug 
driver
[    1.432129] acpiphp_glue: Slot 194 already registered by another hotplug 
driver
[    1.432150] acpiphp_glue: Slot 195 already registered by another hotplug 
driver
[    1.432171] acpiphp_glue: Slot 196 already registered by another hotplug 
driver
[    1.432191] acpiphp_glue: Slot 197 already registered by another hotplug 
driver
[    1.432212] acpiphp_glue: Slot 198 already registered by another hotplug 
driver
[    1.432233] acpiphp_glue: Slot 199 already registered by another hotplug 
driver
[    1.432253] acpiphp_glue: Slot 225 already registered by another hotplug 
driver
[    1.432274] acpiphp_glue: Slot 226 already registered by another hotplug 
driver
[    1.432295] acpiphp_glue: Slot 227 already registered by another hotplug 
driver
[    1.432316] acpiphp_glue: Slot 228 already registered by another hotplug 
driver
[    1.432337] acpiphp_glue: Slot 229 already registered by another hotplug 
driver
[    1.432358] acpiphp_glue: Slot 230 already registered by another hotplug 
driver
[    1.432380] acpiphp_glue: Slot 231 already registered by another hotplug 
driver
[    1.432417] acpiphp_glue: Slot 257 already registered by another hotplug 
driver
[    1.432439] acpiphp_glue: Slot 258 already registered by another hotplug 
driver
[    1.432460] acpiphp_glue: Slot 259 already registered by another hotplug 
driver
[    1.432482] acpiphp_glue: Slot 260 already registered by another hotplug 
driver
[    1.432504] acpiphp_glue: Slot 261 already registered by another hotplug 
driver
[    1.432526] acpiphp_glue: Slot 262 already registered by another hotplug 
driver
[    1.432553] acpiphp_glue: Slot 263 already registered by another hotplug 
driver
[    1.432646] pci-stub: invalid id string ""
[    1.432953] ACPI: AC Adapter [ACAD] (on-line)
[    1.433069] input: Power Button 
as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.433075] ACPI: Power Button [PWRF]
[    1.433546] ACPI: acpi_idle registered with cpuidle
[    1.666177] isapnp: Scanning for PnP cards...
[    2.025388] isapnp: No Plug & Play device found
[    2.025606] Non-volatile memory driver v1.3
[    2.025609] Linux agpgart interface v0.103
[    2.025815] agpgart-intel 0000:00:00.0: Intel 440BX Chipset
[    2.028539] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x0
[    2.028643] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.312091] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.641585] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.822415] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.902595] 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.953928] brd: module loaded
[    2.954099] loop: module loaded
[    2.954141] ata_piix 0000:00:07.1: version 2.13
[    2.954710] scsi0 : ata_piix
[    2.954926] scsi1 : ata_piix
[    2.954969] ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x10c0 irq 14
[    2.954973] ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x10c8 irq 15
[    2.955069] Fixed MDIO Bus: probed
[    2.955138] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.955198] ehci_hcd 0000:02:03.0: PCI INT A -> GSI 17 (level, low) -> IRQ 
17
[    2.955303] ehci_hcd 0000:02:03.0: EHCI Host Controller
[    2.955378] ehci_hcd 0000:02:03.0: new USB bus registered, assigned bus 
number 1
[    2.980803] ehci_hcd 0000:02:03.0: cache line size of 32 is not supported
[    2.980846] ehci_hcd 0000:02:03.0: irq 17, io mem 0xd8900000
[    2.990633] ehci_hcd 0000:02:03.0: USB 2.0 started, EHCI 1.00
[    2.990718] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.990724] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    2.990729] usb usb1: Product: EHCI Host Controller
[    2.990732] usb usb1: Manufacturer: Linux 2.6.37-vfs+ ehci_hcd
[    2.990735] usb usb1: SerialNumber: 0000:02:03.0
[    2.990777] hub 1-0:1.0: USB hub found
[    2.990793] hub 1-0:1.0: 6 ports detected
[    2.990935] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.990963] uhci_hcd: USB Universal Host Controller Interface driver
[    2.991044] uhci_hcd 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 
18
[    2.991096] uhci_hcd 0000:02:00.0: UHCI Host Controller
[    2.991139] uhci_hcd 0000:02:00.0: new USB bus registered, assigned bus 
number 2
[    3.007641] uhci_hcd 0000:02:00.0: irq 18, io base 0x000020c0
[    3.007854] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    3.007859] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    3.007863] usb usb2: Product: UHCI Host Controller
[    3.007865] usb usb2: Manufacturer: Linux 2.6.37-vfs+ uhci_hcd
[    3.007868] usb usb2: SerialNumber: 0000:02:00.0
[    3.007910] hub 2-0:1.0: USB hub found
[    3.007917] hub 2-0:1.0: 2 ports detected
[    3.008214] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at 0x60,0x64 
irq 1,12
[    3.571797] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.571814] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.572012] mice: PS/2 mouse device common for all mice
[    3.572339] ata2.00: ATAPI: VMware Virtual IDE CDROM Drive, 00000001, max 
UDMA/33
[    3.573297] ata2.00: configured for UDMA/33
[    3.574365] scsi 1:0:0:0: CD-ROM            NECVMWar VMware IDE CDR10 1.00 
PQ: 0 ANSI: 5
[    3.575787] input: AT Translated Set 2 keyboard 
as /devices/platform/i8042/serio0/input/input1
[    3.576693] sr0: scsi3-mmc drive: 1x/1x xa/form2 cdda tray
[    3.576698] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.576878] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.576949] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    3.579273] psmouse serio1: ID: 10 00 64
[    3.581881] input: ImPS/2 Generic Wheel Mouse 
as /devices/platform/i8042/serio1/input/input2
[    3.599575] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    3.599612] rtc0: alarms up to one month, y3k, 114 bytes nvram
[    3.599704] device-mapper: uevent: version 1.0.3
[    3.600083] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-
devel@redhat.com
[    3.600301] cpuidle: using governor ladder
[    3.600304] cpuidle: using governor menu
[    3.600734] usbcore: registered new interface driver usbhid
[    3.600737] usbhid: USB HID core driver
[    3.600771] nf_conntrack version 0.5.0 (16038 buckets, 64152 max)
[    3.600863] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.600893] TCP cubic registered
[    3.600897] NET: Registered protocol family 17
[    3.600922] Registering the dns_resolver key type
[    3.600965] Using IPI No-Shortcut mode
[    3.601057] PM: Hibernation image not present or could not be loaded.
[    3.601088] registered taskstats version 1
[    3.601092] IMA: No TPM chip found, activating TPM-bypass!
[    3.608161]   Magic number: 11:74:133
[    3.608238] acpi device:08: hash matches
[    3.636266] rtc_cmos 00:04: setting system clock to 2011-01-06 15:06:24 UTC 
(1294326384)
[    3.636336] Initalizing network drop monitor service
[    3.636428] Freeing unused kernel memory: 440k freed
[    3.637119] Write protecting the kernel text: 3820k
[    3.637405] Write protecting the kernel read-only data: 1876k
[    3.648011] dracut: dracut-006-5.fc14
[    3.652978] dracut: rd_NO_LUKS: removing cryptoluks activation
[    3.656314] udev[79]: starting version 161
[    3.725749] dracut: Starting plymouth daemon
[    3.787432] Fusion MPT base driver 3.04.17
[    3.787453] Copyright (c) 1999-2008 LSI Corporation
[    3.796947] Fusion MPT SPI Host driver 3.04.17
[    3.797102] mptspi 0000:00:10.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.797781] mptbase: ioc0: Initiating bringup
[    3.876077] ioc0: LSI53C1030 B0: Capabilities={Initiator}
[    4.009850] scsi2 : ioc0: LSI53C1030 B0, FwRev=01032920h, Ports=1, 
MaxQ=128, IRQ=17
[    4.103506] scsi 2:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  
PQ: 0 ANSI: 2
[    4.103518] scsi target2:0:0: Beginning Domain Validation
[    4.105274] scsi target2:0:0: Domain Validation skipping write tests
[    4.105274] scsi target2:0:0: Ending Domain Validation
[    4.105274] scsi target2:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 
127)
[    4.105274] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    4.105274] sd 2:0:0:0: [sda] 188743680 512-byte logical blocks: (96.6 
GB/90.0 GiB)
[    4.105274] sd 2:0:0:0: [sda] Write Protect is off
[    4.105274] sd 2:0:0:0: [sda] Mode Sense: 5d 00 00 00
[    4.105274] sd 2:0:0:0: [sda] Cache data unavailable
[    4.105274] sd 2:0:0:0: [sda] Assuming drive cache: write through
[    4.105274] sd 2:0:0:0: [sda] Cache data unavailable
[    4.105274] sd 2:0:0:0: [sda] Assuming drive cache: write through
[    4.135557]  sda: sda1 sda2 sda3 sda4 < sda5 >
[    4.136195] sd 2:0:0:0: [sda] Cache data unavailable
[    4.136199] sd 2:0:0:0: [sda] Assuming drive cache: write through
[    4.136203] sd 2:0:0:0: [sda] Attached SCSI disk
[    4.545478] EXT4-fs (sda3): mounted filesystem with ordered data mode. 
Opts: (null)
[    4.599564] dracut: Remounting /dev/disk/by-uuid/52b8b36e-580a-4b9d-ac9f-
ee1b9b349fdf with -o noatime,nobarrier,ro
[    4.605261] EXT4-fs (sda3): barriers disabled
[    4.605653] EXT4-fs (sda3): mounted filesystem with ordered data mode. 
Opts: nobarrier
[    4.642106] dracut: Mounted root filesystem /dev/sda3
[    4.762036] dracut: Loading SELinux policy
[    5.144280] SELinux:  Disabled at runtime.
[    5.144355] SELinux:  Unregistering netfilter hooks
[    5.270198] type=1404 audit(1294326386.143:2): selinux=0 auid=4294967295 
ses=4294967295
[    5.321517] dracut: /sbin/load_policy: Can't load policy: No such file or 
directory
[    5.527724] dracut: Switching root
[    6.835682] readahead: starting
[    8.114042] udev[330]: starting version 161
[    8.752993] microcode: CPU0 sig=0x20652, pf=0x1, revision=0x9
[    8.982737] ACPI: resource piix4_smbus [io  0x1040-0x1047] conflicts with 
ACPI region SMB_ [??? 0x00001040-0x0000104b flags 0x5f]
[    8.982745] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[    9.017579] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    9.017884] pcnet32 0000:02:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    9.018736] pcnet32: PCnet/PCI II 79C970A at 0x2000, 00:0c:29:9a:82:5b 
assigned IRQ 19
[    9.020229] pcnet32: eth0: registered as PCnet/PCI II 79C970A
[    9.020715] pcnet32: 1 cards_found
[    9.151744] microcode: CPU1 sig=0x20652, pf=0x1, revision=0x9
[    9.153165] microcode: CPU2 sig=0x20652, pf=0x1, revision=0x9
[    9.154778] microcode: CPU3 sig=0x20652, pf=0x1, revision=0x9
[    9.155897] microcode: Microcode Update Driver: v2.00 
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    9.550777] ENS1371 0000:02:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   11.992809] EXT4-fs (sda3): re-mounted. Opts: nobarrier
[   12.243035] EXT4-fs (sda1): mounted filesystem with ordered data mode. 
Opts: (null)
[   12.265408] EXT4-fs (sda2): barriers disabled
[   12.292987] EXT4-fs (sda2): mounted filesystem with ordered data mode. 
Opts: nobarrier
[   13.326580] Adding 2537468k swap on /dev/sda5.  Priority:-1 extents:1 
across:2537468k 
[   14.584851] NET: Registered protocol family 10
[   14.585107] lo: Disabled Privacy Extensions
[   14.619124] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   15.533746] auditd (790): /proc/790/oom_adj is deprecated, please 
use /proc/790/oom_score_adj instead.
[   21.846634] RPC: Registered udp transport module.
[   21.846701] RPC: Registered tcp transport module.
[   21.846704] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   22.478416] pcnet32 0000:02:01.0: eth0: link up
[   26.912292] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   27.093841] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery 
directory
[   27.107366] NFSD: starting 90-second grace period
[   32.015772] Bridge firewalling registered
[   33.315777] Ebtables v2.0 registered
[   33.994115] eth0: no IPv6 routers present
[   34.415313] mtrr: base(0xd0000000) is not aligned on a size(0x1130000) 
boundary
[   36.262188] lo: Disabled Privacy Extensions


