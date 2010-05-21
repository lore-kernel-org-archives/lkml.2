Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934426Ab0EUREi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:04:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49833 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934086Ab0EUREJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 13:04:09 -0400
Date: Fri, 21 May 2010 19:03:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, venki@google.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: Avoid side-effect of tickless idle on
 update_cpu_load
Message-ID: <20100521170320.GA2023@elte.hu>
References: <AANLkTilLtDWQsAUrIxJ6s04WTgmw9GuOODc5AOrYsaR5@mail.gmail.com>
 <tip-4afc7e60ab25b72611771e48ca97b4f0104f77c7@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-4afc7e60ab25b72611771e48ca97b4f0104f77c7@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 3.0
X-ELTE-SpamLevel: sss
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=3.0 required=5.9 tests=BAYES_50,FR_ALMOST_VIAG2 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
	2.0 FR_ALMOST_VIAG2        RAW: Almost looks like viagra.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Venkatesh Pallipadi <venki@google.com> wrote:

> Commit-ID:  4afc7e60ab25b72611771e48ca97b4f0104f77c7
> Gitweb:     http://git.kernel.org/tip/4afc7e60ab25b72611771e48ca97b4f0104f77c7
> Author:     Venkatesh Pallipadi <venki@google.com>
> AuthorDate: Mon, 17 May 2010 18:14:43 -0700
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 21 May 2010 11:37:17 +0200
> 
> sched: Avoid side-effect of tickless idle on update_cpu_load

ok, probably this patch is causing:

[   59.250427] 
[   59.250429] =================================
[   59.256299] [ INFO: inconsistent lock state ]
[   59.260014] 2.6.34-tip+ #6253
[   59.260014] ---------------------------------
[   59.260014] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
[   59.260014] swapper/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
[   59.260014]  (&rq->lock){?.-.-.}, at: [<ffffffff81038e23>] run_rebalance_domains+0xa1/0x131
[   59.260014] {IN-HARDIRQ-W} state was registered at:
[   59.260014]   [<ffffffff8106583a>] __lock_acquire+0x5e8/0x1384
[   59.260014]   [<ffffffff81066659>] lock_acquire+0x83/0x9d
[   59.260014]   [<ffffffff81bae24c>] _raw_spin_lock+0x3b/0x6e
[   59.260014]   [<ffffffff81037865>] scheduler_tick+0x3a/0x2b7
[   59.260014]   [<ffffffff810497c4>] update_process_times+0x4b/0x5b
[   59.260014]   [<ffffffff8105f467>] tick_periodic+0x63/0x6f
[   59.260014]   [<ffffffff8105f492>] tick_handle_periodic+0x1f/0x6d
[   59.260014]   [<ffffffff81005e2d>] timer_interrupt+0x19/0x20
[   59.260014]   [<ffffffff81084dc9>] handle_IRQ_event+0x20/0x9f
[   59.260014]   [<ffffffff81086c2e>] handle_level_irq+0x9a/0xf4
[   59.260014]   [<ffffffff81005729>] handle_irq+0x62/0x6d
[   59.260014]   [<ffffffff81004b08>] do_IRQ+0x5e/0xc4
[   59.260014]   [<ffffffff81baefd3>] ret_from_intr+0x0/0xf
[   59.260014]   [<ffffffff81085abb>] __setup_irq+0x21b/0x2c1
[   59.260014]   [<ffffffff81085d06>] setup_irq+0x1e/0x23
[   59.260014]   [<ffffffff8282735f>] setup_default_timer_irq+0x12/0x14
[   59.260014]   [<ffffffff82827378>] hpet_time_init+0x17/0x19
[   59.260014]   [<ffffffff82827346>] x86_late_time_init+0xa/0x11
[   59.260014]   [<ffffffff82824ce9>] start_kernel+0x338/0x3bf
[   59.260014]   [<ffffffff828242a3>] x86_64_start_reservations+0xb3/0xb7
[   59.260014]   [<ffffffff8282438b>] x86_64_start_kernel+0xe4/0xeb
[   59.260014] irq event stamp: 186338
[   59.260014] hardirqs last  enabled at (186338): [<ffffffff81baecf5>] _raw_spin_unlock_irq+0x2b/0x53
[   59.260014] hardirqs last disabled at (186337): [<ffffffff81bae317>] _raw_spin_lock_irq+0x14/0x74
[   59.260014] softirqs last  enabled at (186326): [<ffffffff810449fe>] __do_softirq+0x13a/0x150
[   59.260014] softirqs last disabled at (186331): [<ffffffff8100388c>] call_softirq+0x1c/0x28
[   59.260014] 
[   59.260014] other info that might help us debug this:
[   59.260014] no locks held by swapper/0.
[   59.260014] 
[   59.260014] stack backtrace:
[   59.260014] Pid: 0, comm: swapper Not tainted 2.6.34-tip+ #6253
[   59.260014] Call Trace:
[   59.260014]  <IRQ>  [<ffffffff8106318d>] print_usage_bug+0x187/0x198
[   59.260014]  [<ffffffff8100d920>] ? save_stack_trace+0x2a/0x47
[   59.260014]  [<ffffffff81063c67>] ? check_usage_backwards+0x0/0xa5
[   59.260014]  [<ffffffff810633cd>] mark_lock+0x22f/0x412
[   59.260014]  [<ffffffff810658b3>] __lock_acquire+0x661/0x1384
[   59.260014]  [<ffffffff81038631>] ? load_balance+0xda/0x64d
[   59.260014]  [<ffffffff8106275e>] ? put_lock_stats+0xe/0x27
[   59.260014]  [<ffffffff8106285d>] ? lock_release_holdtime+0xe6/0xeb
[   59.260014]  [<ffffffff81066659>] lock_acquire+0x83/0x9d
[   59.260014]  [<ffffffff81038e23>] ? run_rebalance_domains+0xa1/0x131
[   59.260014]  [<ffffffff81bae24c>] _raw_spin_lock+0x3b/0x6e
[   59.260014]  [<ffffffff81038e23>] ? run_rebalance_domains+0xa1/0x131
[   59.260014]  [<ffffffff81038e23>] run_rebalance_domains+0xa1/0x131
[   59.260014]  [<ffffffff81044979>] __do_softirq+0xb5/0x150
[   59.260014]  [<ffffffff8100388c>] call_softirq+0x1c/0x28
[   59.260014]  [<ffffffff81005690>] do_softirq+0x38/0x6f
[   59.260014]  [<ffffffff81044571>] irq_exit+0x45/0x90
[   59.260014]  [<ffffffff81017ec4>] smp_apic_timer_interrupt+0x87/0x95
[   59.260014]  [<ffffffff81003353>] apic_timer_interrupt+0x13/0x20
[   59.260014]  <EOI>  [<ffffffff81009f8c>] ? default_idle+0x29/0x43
[   59.260014]  [<ffffffff81009f8a>] ? default_idle+0x27/0x43
[   59.260014]  [<ffffffff81001c52>] cpu_idle+0x6c/0xbe
[   59.260014]  [<ffffffff81b411fb>] rest_init+0xff/0x106
[   59.260014]  [<ffffffff81b410fc>] ? rest_init+0x0/0x106
[   59.260014]  [<ffffffff82824d65>] start_kernel+0x3b4/0x3bf
[   59.260014]  [<ffffffff828242a3>] x86_64_start_reservations+0xb3/0xb7
[   59.260014]  [<ffffffff8282438b>] x86_64_start_kernel+0xe4/0xeb

Find the full bootlog below.

	Ingo


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.34-tip+ (mingo@sirius) (gcc version 4.4.4 20100514 (Red Hat 4.4.4-3) (GCC) ) #6253 SMP PREEMPT Fri May 21 20:46:17 CEST 2010
[    0.000000] Command line: root=/dev/sda6 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.3 present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FFC0000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f5680] f5680
[    0.000000] init_memory_mapping: 0000000000000000-000000003fff0000
[    0.000000]  0000000000 - 003fe00000 page 2M
[    0.000000]  003fe00000 - 003fff0000 page 4k
[    0.000000] kernel direct mapping tables up to 3fff0000 @ 12000-15000
[    0.000000] ACPI: RSDP 00000000000f76f0 00014 (v00 Nvidia)
[    0.000000] ACPI: RSDT 000000003fff3040 00034 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 000000003fff30c0 00074 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 000000003fff3180 06264 (v01 NVIDIA AWRDACPI 00001000 MSFT 0100000E)
[    0.000000] ACPI: FACS 000000003fff0000 00040
[    0.000000] ACPI: SRAT 000000003fff9500 000A0 (v01 AMD    HAMMER   00000001 AMD  00000001)
[    0.000000] ACPI: MCFG 000000003fff9600 0003C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC 000000003fff9440 0007C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] SRAT: Node 0 PXM 0 100000-40000000
[    0.000000] SRAT: Node 0 [0,a0000) + [100000,40000000) -> [0,40000000)
[    0.000000] NUMA: Using 63 for the hash shift.
[    0.000000] Initmem setup node 0 0000000000000000-000000003fff0000
[    0.000000]   NODE_DATA [00000000078bb180 - 00000000078e217f]
[    0.000000]  [ffffea0000000000-ffffea0000dfffff] PMD -> [ffff880008200000-ffff880008ffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fff0
[    0.000000] On node 0 totalpages: 262015
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3528 pages used for memmap
[    0.000000]   DMA32 zone: 254504 pages, LIFO batch:31
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
[    0.000000] early_res array is doubled to 64 at [130c0 - 138bf]
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 474 pages/cpu @ffff880007a00000 s1918808 r0 d22696 u2097152
[    0.000000] pcpu-alloc: s1918808 r0 d22696 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 258431
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda6 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
[    0.000000] debug: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Subtract (45 early reservations)
[    0.000000]   #1 [0001000000 - 00078ba2d8]   TEXT DATA BSS
[    0.000000]   #2 [00078bb000 - 00078bb149]             BRK
[    0.000000]   #3 [00000f5690 - 0000100000]   BIOS reserved
[    0.000000]   #4 [00000f5680 - 00000f5690]    MP-table mpf
[    0.000000]   #5 [000009f800 - 00000f1400]   BIOS reserved
[    0.000000]   #6 [00000f152c - 00000f5680]   BIOS reserved
[    0.000000]   #7 [00000f1400 - 00000f152c]    MP-table mpc
[    0.000000]   #8 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #9 [0000012000 - 0000013000]         PGTABLE
[    0.000000]   #10 [00078bb180 - 00078e2180]       NODE_DATA
[    0.000000]   #11 [00078e2180 - 00078e3180]         BOOTMEM
[    0.000000]   #12 [0000013000 - 00000130c0]         BOOTMEM
[    0.000000]   #13 [00080e4000 - 00080e5000]         BOOTMEM
[    0.000000]   #14 [00080e5000 - 00080e6000]         BOOTMEM
[    0.000000]   #15 [0008200000 - 0009000000]        MEMMAP 0
[    0.000000]   #16 [00078e3180 - 0007933180]         BOOTMEM
[    0.000000]   #17 [0007933180 - 0007983180]         BOOTMEM
[    0.000000]   #18 [0007984000 - 0007985000]         BOOTMEM
[    0.000000]   #19 [00078ba300 - 00078ba343]         BOOTMEM
[    0.000000]   #20 [00078ba380 - 00078ba578]         BOOTMEM
[    0.000000]   #21 [00078ba580 - 00078ba5e8]         BOOTMEM
[    0.000000]   #22 [00078ba600 - 00078ba668]         BOOTMEM
[    0.000000]   #23 [00078ba680 - 00078ba6e8]         BOOTMEM
[    0.000000]   #24 [00078ba700 - 00078ba768]         BOOTMEM
[    0.000000]   #25 [00078ba780 - 00078ba7e8]         BOOTMEM
[    0.000000]   #26 [00078ba800 - 00078ba868]         BOOTMEM
[    0.000000]   #27 [00078ba880 - 00078ba8e8]         BOOTMEM
[    0.000000]   #28 [00078ba900 - 00078ba968]         BOOTMEM
[    0.000000]   #29 [00078ba980 - 00078baa1a]         BOOTMEM
[    0.000000]   #30 [00078baa40 - 00078baada]         BOOTMEM
[    0.000000]   #31 [0007a00000 - 0007bda000]         BOOTMEM
[    0.000000]   #32 [0007c00000 - 0007dda000]         BOOTMEM
[    0.000000]   #33 [00078bab00 - 00078bab08]         BOOTMEM
[    0.000000]   #34 [00078bab40 - 00078bab48]         BOOTMEM
[    0.000000]   #35 [00078bab80 - 00078bab88]         BOOTMEM
[    0.000000]   #36 [00078babc0 - 00078babd0]         BOOTMEM
[    0.000000]   #37 [00078bac00 - 00078bad50]         BOOTMEM
[    0.000000]   #38 [00078bad80 - 00078bae00]         BOOTMEM
[    0.000000]   #39 [00078bae00 - 00078bb000]         BOOTMEM
[    0.000000]   #40 [0007983180 - 0007983380]         BOOTMEM
[    0.000000]   #41 [0007983380 - 0007983580]         BOOTMEM
[    0.000000]   #42 [0007983580 - 0007983780]         BOOTMEM
[    0.000000]   #43 [0007983780 - 0007983980]         BOOTMEM
[    0.000000]   #44 [0007985000 - 000798d000]         BOOTMEM
[    0.000000] Memory: 921824k/1048512k available (11974k kernel code, 452k absent, 126236k reserved, 10861k data, 2596k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled, bootconsole disabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
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
[    0.000000] ODEBUG: 7 of 7 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2010.231 MHz processor.
[    0.020021] Calibrating delay loop (skipped), value calculated using timer frequency.. 4020.46 BogoMIPS (lpj=20102310)
[    0.032927] Security Framework initialized
[    0.040020] TOMOYO Linux initialized
[    0.043839] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.050745] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.060347] Mount-cache hash table entries: 256
[    0.066005] Initializing cgroup subsys debug
[    0.070010] Initializing cgroup subsys cpuacct
[    0.074459] Initializing cgroup subsys freezer
[    0.080007] Initializing cgroup subsys net_cls
[    0.084577] tseg: 0000000000
[    0.087497] CPU: Physical Processor ID: 0
[    0.090005] CPU: Processor Core ID: 0
[    0.093665] mce: CPU supports 5 MCE banks
[    0.097683] numa_add_cpu cpu 0 node 0: mask now 0
[    0.100005] Performance Events: AMD PMU driver.
[    0.104555] ... version:                0
[    0.110005] ... bit width:              48
[    0.114089] ... generic registers:      4
[    0.120005] ... value mask:             0000ffffffffffff
[    0.125302] ... max period:             00007fffffffffff
[    0.130005] ... fixed-purpose events:   0
[    0.134003] ... event mask:             000000000000000f
[    0.140070] ACPI: Core revision 20100121
[    0.182554] Setting APIC routing to flat
[    0.187532] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.293592] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.310000] calling  register_trigger_all_cpu_backtrace+0x0/0x14 @ 1
[    0.310000] initcall register_trigger_all_cpu_backtrace+0x0/0x14 returned 0 after 0 usecs
[    0.310007] calling  migration_init+0x0/0x4b @ 1
[    0.314628] initcall migration_init+0x0/0x4b returned 0 after 0 usecs
[    0.320006] calling  spawn_ksoftirqd+0x0/0x4a @ 1
[    0.340052] initcall spawn_ksoftirqd+0x0/0x4a returned 0 after 9765 usecs
[    0.346832] calling  init_call_single_data+0x0/0xc6 @ 1
[    0.350012] initcall init_call_single_data+0x0/0xc6 returned 0 after 0 usecs
[    0.357051] calling  cpu_stop_init+0x0/0xde @ 1
[    0.360133] initcall cpu_stop_init+0x0/0xde returned 0 after 0 usecs
[    0.370007] calling  spawn_watchdog_task+0x0/0x67 @ 1
[    0.375115] NMI watchdog enabled, takes one hw-pmu counter.
[    0.390028] initcall spawn_watchdog_task+0x0/0x67 returned 0 after 19531 usecs
[    0.397241] calling  relay_init+0x0/0x14 @ 1
[    0.400010] initcall relay_init+0x0/0x14 returned 0 after 0 usecs
[    0.410134] lockdep: fixing up alternatives.
[    0.414560] Booting Node   0, Processors  #1 Ok.
[    0.030000] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.580229] NMI watchdog enabled, takes one hw-pmu counter.
[    0.600026] Brought up 2 CPUs
[    0.602996] Total of 2 processors activated (8041.17 BogoMIPS).
[    0.610205] device: 'platform': device_add
[    0.614394] bus: 'platform': registered
[    0.618234] Registering sysdev class 'cpu'
[    0.620040] Registering sysdev class 'memory'
[    0.624407] Registering sys device of class 'memory'
[    0.630012] Registering sys device 'memory0'
[    0.634318] Registering sys device of class 'memory'
[    0.640011] Registering sys device 'memory1'
[    0.644300] Registering sys device of class 'memory'
[    0.650011] Registering sys device 'memory2'
[    0.654302] Registering sys device of class 'memory'
[    0.659262] Registering sys device 'memory3'
[    0.660029] Registering sys device of class 'memory'
[    0.664992] Registering sys device 'memory4'
[    0.670028] Registering sys device of class 'memory'
[    0.674992] Registering sys device 'memory5'
[    0.680029] Registering sys device of class 'memory'
[    0.684992] Registering sys device 'memory6'
[    0.690029] Registering sys device of class 'memory'
[    0.694993] Registering sys device 'memory7'
[    0.702641] calling  init_mmap_min_addr+0x0/0x16 @ 1
[    0.707604] initcall init_mmap_min_addr+0x0/0x16 returned 0 after 0 usecs
[    0.710010] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.720013] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.730007] calling  net_ns_init+0x0/0xfb @ 1
[    0.735130] initcall net_ns_init+0x0/0xfb returned 0 after 0 usecs
[    0.740009] calling  cpufreq_tsc+0x0/0x28 @ 1
[    0.744361] initcall cpufreq_tsc+0x0/0x28 returned 0 after 0 usecs
[    0.750008] calling  pci_reboot_init+0x0/0x14 @ 1
[    0.754709] initcall pci_reboot_init+0x0/0x14 returned 0 after 0 usecs
[    0.760007] calling  init_lapic_sysfs+0x0/0x2d @ 1
[    0.764794] Registering sysdev class 'lapic'
[    0.770040] Registering sys device of class 'lapic'
[    0.774924] Registering sys device 'lapic0'
[    0.780022] initcall init_lapic_sysfs+0x0/0x2d returned 0 after 19531 usecs
[    0.786977] calling  init_smp_flush+0x0/0x3d @ 1
[    0.790010] initcall init_smp_flush+0x0/0x3d returned 0 after 0 usecs
[    0.796441] calling  sysctl_init+0x0/0x32 @ 1
[    0.800264] initcall sysctl_init+0x0/0x32 returned 0 after 0 usecs
[    0.810007] calling  ksysfs_init+0x0/0x94 @ 1
[    0.814401] initcall ksysfs_init+0x0/0x94 returned 0 after 0 usecs
[    0.820007] calling  async_init+0x0/0x4b @ 1
[    0.824339] initcall async_init+0x0/0x4b returned 0 after 0 usecs
[    0.830007] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.835517] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.840006] calling  pm_init+0x0/0x34 @ 1
[    0.844031] initcall pm_init+0x0/0x34 returned 0 after 0 usecs
[    0.850006] calling  init_hw_breakpoint+0x0/0x127 @ 1
[    0.855055] initcall init_hw_breakpoint+0x0/0x127 returned 0 after 0 usecs
[    0.860006] calling  init_zero_pfn+0x0/0x35 @ 1
[    0.870006] initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
[    0.876346] calling  filelock_init+0x0/0x2e @ 1
[    0.880007] initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
[    0.886356] calling  init_misc_binfmt+0x0/0x42 @ 1
[    0.890023] initcall init_misc_binfmt+0x0/0x42 returned 0 after 0 usecs
[    0.896625] calling  init_script_binfmt+0x0/0x14 @ 1
[    0.900007] initcall init_script_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.910005] calling  init_elf_binfmt+0x0/0x14 @ 1
[    0.914703] initcall init_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.920005] calling  init_compat_elf_binfmt+0x0/0x14 @ 1
[    0.925309] initcall init_compat_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.930006] calling  debugfs_init+0x0/0x5c @ 1
[    0.934451] initcall debugfs_init+0x0/0x5c returned 0 after 0 usecs
[    0.940006] calling  securityfs_init+0x0/0x53 @ 1
[    0.944712] initcall securityfs_init+0x0/0x53 returned 0 after 0 usecs
[    0.950006] calling  random32_init+0x0/0xf9 @ 1
[    0.960007] initcall random32_init+0x0/0xf9 returned 0 after 0 usecs
[    0.966348] calling  test_atomic64+0x0/0x256 @ 1
[    0.970006] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.976867] initcall test_atomic64+0x0/0x256 returned 0 after 0 usecs
[    0.980006] calling  cpufreq_core_init+0x0/0xbb @ 1
[    0.990014] initcall cpufreq_core_init+0x0/0xbb returned 0 after 0 usecs
[    0.996702] calling  cpuidle_init+0x0/0x40 @ 1
[    1.000018] initcall cpuidle_init+0x0/0x40 returned 0 after 0 usecs
[    1.006279] calling  sock_init+0x0/0x5e @ 1
[    1.010220] initcall sock_init+0x0/0x5e returned 0 after 0 usecs
[    1.016215] calling  net_inuse_init+0x0/0x26 @ 1
[    1.020019] initcall net_inuse_init+0x0/0x26 returned 0 after 0 usecs
[    1.026451] calling  netpoll_init+0x0/0x41 @ 1
[    1.030006] initcall netpoll_init+0x0/0x41 returned 0 after 0 usecs
[    1.036261] calling  netlink_proto_init+0x0/0x148 @ 1
[    1.040060] NET: Registered protocol family 16
[    1.044572] initcall netlink_proto_init+0x0/0x148 returned 0 after 0 usecs
[    1.050007] calling  bdi_class_init+0x0/0x4d @ 1
[    1.060006] device class 'bdi': registering
[    1.064328] initcall bdi_class_init+0x0/0x4d returned 0 after 0 usecs
[    1.070007] calling  kobject_uevent_init+0x0/0x54 @ 1
[    1.075070] initcall kobject_uevent_init+0x0/0x54 returned 0 after 0 usecs
[    1.080006] calling  gpiolib_sysfs_init+0x0/0xa2 @ 1
[    1.084962] device class 'gpio': registering
[    1.090056] initcall gpiolib_sysfs_init+0x0/0xa2 returned 0 after 9765 usecs
[    1.097091] calling  pcibus_class_init+0x0/0x19 @ 1
[    1.100005] device class 'pci_bus': registering
[    1.104554] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    1.110006] calling  pci_driver_init+0x0/0x12 @ 1
[    1.120057] bus: 'pci': registered
[    1.123454] initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
[    1.130006] calling  lcd_class_init+0x0/0x4d @ 1
[    1.134614] device class 'lcd': registering
[    1.138843] initcall lcd_class_init+0x0/0x4d returned 0 after 0 usecs
[    1.140006] calling  backlight_class_init+0x0/0x5d @ 1
[    1.150013] device class 'backlight': registering
[    1.154736] initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
[    1.160006] calling  video_output_class_init+0x0/0x19 @ 1
[    1.165394] device class 'video_output': registering
[    1.170032] initcall video_output_class_init+0x0/0x19 returned 0 after 9765 usecs
[    1.180007] calling  tty_class_init+0x0/0x38 @ 1
[    1.184624] device class 'tty': registering
[    1.188865] initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
[    1.190007] calling  vtconsole_class_init+0x0/0xc2 @ 1
[    1.200006] device class 'vtconsole': registering
[    1.204731] device: 'vtcon0': device_add
[    1.208738] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 9765 usecs
[    1.210006] calling  register_node_type+0x0/0x2d @ 1
[    1.220005] Registering sysdev class 'node'
[    1.224219] initcall register_node_type+0x0/0x2d returned 0 after 0 usecs
[    1.230008] calling  i2c_init+0x0/0x6a @ 1
[    1.234153] bus: 'i2c': registered
[    1.240015] bus: 'i2c': add driver dummy
[    1.243974] i2c-core: driver [dummy] registered
[    1.248514] initcall i2c_init+0x0/0x6a returned 0 after 9765 usecs
[    1.250007] calling  amd_postcore_init+0x0/0x96 @ 1
[    1.260010] node 0 link 0: io port [1000, fffff]
[    1.264623] TOM: 0000000040000000 aka 1024M
[    1.268806] node 0 link 0: mmio [e0000000, efffffff]
[    1.270198] node 0 link 0: mmio [feb00000, fec0ffff]
[    1.275178] node 0 link 0: mmio [a0000, bffff]
[    1.280197] node 0 link 0: mmio [40000000, fed3ffff]
[    1.285177] bus: [00, ff] on node 0 link 0
[    1.290005] bus: 00 index 0 [io  0x0000-0xffff]
[    1.294526] bus: 00 index 1 [mem 0x40000000-0xfcffffffff]
[    1.300005] bus: 00 index 2 [mem 0xfeb00000-0xfec0ffff]
[    1.305220] bus: 00 index 3 [mem 0x000a0000-0x000bffff]
[    1.310006] initcall amd_postcore_init+0x0/0x96 returned 0 after 48828 usecs
[    1.320006] calling  arch_kdebugfs_init+0x0/0x219 @ 1
[    1.325123] initcall arch_kdebugfs_init+0x0/0x219 returned 0 after 0 usecs
[    1.330007] calling  mtrr_if_init+0x0/0x61 @ 1
[    1.334459] initcall mtrr_if_init+0x0/0x61 returned 0 after 0 usecs
[    1.340006] calling  acpi_pci_init+0x0/0x57 @ 1
[    1.344539] ACPI: bus type pci registered
[    1.350006] initcall acpi_pci_init+0x0/0x57 returned 0 after 9765 usecs
[    1.356607] calling  dmi_id_init+0x0/0x2f2 @ 1
[    1.360005] device class 'dmi': registering
[    1.364211] device: 'id': device_add
[    1.370197] initcall dmi_id_init+0x0/0x2f2 returned 0 after 9765 usecs
[    1.376719] calling  dma_bus_init+0x0/0x3f @ 1
[    1.380006] device class 'dma': registering
[    1.384246] initcall dma_bus_init+0x0/0x3f returned 0 after 0 usecs
[    1.390007] calling  dma_channel_table_init+0x0/0x116 @ 1
[    1.395420] initcall dma_channel_table_init+0x0/0x116 returned 0 after 0 usecs
[    1.400006] calling  dca_init+0x0/0x20 @ 1
[    1.404094] dca service started, version 1.12.1
[    1.410006] device class 'dca': registering
[    1.414206] initcall dca_init+0x0/0x20 returned 0 after 9765 usecs
[    1.420006] calling  pci_arch_init+0x0/0x69 @ 1
[    1.424569] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.430006] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    1.499032] PCI: Using configuration type 1 for base access
[    1.500017] initcall pci_arch_init+0x0/0x69 returned 0 after 78125 usecs
[    1.510007] calling  topology_init+0x0/0xbe @ 1
[    1.514530] Registering sys device of class 'node'
[    1.520018] Registering sys device 'node0'
[    1.524247] Registering sys device of class 'cpu'
[    1.528951] Registering sys device 'cpu0'
[    1.530080] Registering sys device of class 'cpu'
[    1.534783] Registering sys device 'cpu1'
[    1.540040] initcall topology_init+0x0/0xbe returned 0 after 29296 usecs
[    1.546728] calling  mtrr_init_finialize+0x0/0x3d @ 1
[    1.550007] initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 usecs
[    1.560007] calling  param_sysfs_init+0x0/0x2e0 @ 1
[    1.624754] initcall param_sysfs_init+0x0/0x2e0 returned 0 after 58593 usecs
[    1.630009] calling  pm_sysrq_init+0x0/0x19 @ 1
[    1.634556] initcall pm_sysrq_init+0x0/0x19 returned 0 after 0 usecs
[    1.640007] calling  audit_watch_init+0x0/0x2f @ 1
[    1.644792] initcall audit_watch_init+0x0/0x2f returned 0 after 0 usecs
[    1.650006] calling  init_slow_work+0x0/0x70 @ 1
[    1.654663] initcall init_slow_work+0x0/0x70 returned 0 after 0 usecs
[    1.660006] calling  default_bdi_init+0x0/0xb9 @ 1
[    1.670114] device: 'default': device_add
[    1.674225] initcall default_bdi_init+0x0/0xb9 returned 0 after 0 usecs
[    1.680007] calling  init_bio+0x0/0xe1 @ 1
[    1.684120] bio: create slab <bio-0> at 0
[    1.688146] initcall init_bio+0x0/0xe1 returned 0 after 0 usecs
[    1.690006] calling  fsnotify_init+0x0/0x20 @ 1
[    1.694534] initcall fsnotify_init+0x0/0x20 returned 0 after 0 usecs
[    1.700006] calling  fsnotify_notification_init+0x0/0x68 @ 1
[    1.710008] initcall fsnotify_notification_init+0x0/0x68 returned 0 after 0 usecs
[    1.717483] calling  cryptomgr_init+0x0/0x12 @ 1
[    1.720006] initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
[    1.730006] calling  blk_settings_init+0x0/0x2a @ 1
[    1.734874] initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
[    1.740006] calling  blk_ioc_init+0x0/0x2a @ 1
[    1.744443] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    1.750006] calling  blk_softirq_init+0x0/0x8d @ 1
[    1.754792] initcall blk_softirq_init+0x0/0x8d returned 0 after 0 usecs
[    1.760006] calling  blk_iopoll_setup+0x0/0x8d @ 1
[    1.764790] initcall blk_iopoll_setup+0x0/0x8d returned 0 after 0 usecs
[    1.770006] calling  genhd_device_init+0x0/0x67 @ 1
[    1.780005] device class 'block': registering
[    1.784605] initcall genhd_device_init+0x0/0x67 returned 0 after 0 usecs
[    1.790007] calling  gpiolib_debugfs_init+0x0/0x24 @ 1
[    1.795160] initcall gpiolib_debugfs_init+0x0/0x24 returned 0 after 0 usecs
[    1.800006] calling  max7300_init+0x0/0x14 @ 1
[    1.804451] bus: 'i2c': add driver max7300
[    1.810099] i2c-core: driver [max7300] registered
[    1.814799] initcall max7300_init+0x0/0x14 returned 0 after 9765 usecs
[    1.820021] calling  max732x_init+0x0/0x14 @ 1
[    1.824450] bus: 'i2c': add driver max732x
[    1.830079] i2c-core: driver [max732x] registered
[    1.834783] initcall max732x_init+0x0/0x14 returned 0 after 9765 usecs
[    1.840009] calling  pca953x_init+0x0/0x14 @ 1
[    1.844450] bus: 'i2c': add driver pca953x
[    1.850091] i2c-core: driver [pca953x] registered
[    1.854792] initcall pca953x_init+0x0/0x14 returned 0 after 9765 usecs
[    1.860007] calling  wm831x_gpio_init+0x0/0x12 @ 1
[    1.864791] bus: 'platform': add driver wm831x-gpio
[    1.870072] initcall wm831x_gpio_init+0x0/0x12 returned 0 after 9765 usecs
[    1.876936] calling  wm8350_gpio_init+0x0/0x12 @ 1
[    1.880007] bus: 'platform': add driver wm8350-gpio
[    1.884947] initcall wm8350_gpio_init+0x0/0x12 returned 0 after 0 usecs
[    1.890007] calling  wm8994_gpio_init+0x0/0x12 @ 1
[    1.900006] bus: 'platform': add driver wm8994-gpio
[    1.904940] initcall wm8994_gpio_init+0x0/0x12 returned 0 after 0 usecs
[    1.910008] calling  pci_slot_init+0x0/0x46 @ 1
[    1.914547] initcall pci_slot_init+0x0/0x46 returned 0 after 0 usecs
[    1.920006] calling  fbmem_init+0x0/0x98 @ 1
[    1.924350] device class 'graphics': registering
[    1.930062] initcall fbmem_init+0x0/0x98 returned 0 after 9765 usecs
[    1.936408] calling  acpi_init+0x0/0x12f @ 1
[    1.960522] ACPI: EC: Look up EC in DSDT
[    2.023493] ACPI: Interpreter enabled
[    2.027155] ACPI: (supports S0 S5)
[    2.030615] ACPI: Using IOAPIC for interrupt routing
[    2.035773] bus: 'acpi': registered
[    2.039376] device: 'LNXSYSTM:00': device_add
[    2.040027] bus: 'acpi': add device LNXSYSTM:00
[    2.044842] device: 'LNXCPU:00': device_add
[    2.050016] bus: 'acpi': add device LNXCPU:00
[    2.054536] device: 'LNXCPU:01': device_add
[    2.060016] bus: 'acpi': add device LNXCPU:01
[    2.064671] device: 'LNXSYBUS:00': device_add
[    2.070020] bus: 'acpi': add device LNXSYBUS:00
[    2.075111] device: 'PNP0C0C:00': device_add
[    2.079385] bus: 'acpi': add device PNP0C0C:00
[    2.080793] device: 'PNP0A08:00': device_add
[    2.085072] bus: 'acpi': add device PNP0A08:00
[    2.090384] device: 'PNP0C02:00': device_add
[    2.094670] bus: 'acpi': add device PNP0C02:00
[    2.100705] device: 'device:00': device_add
[    2.104897] bus: 'acpi': add device device:00
[    2.110343] device: 'device:01': device_add
[    2.114535] bus: 'acpi': add device device:01
[    2.120338] device: 'device:02': device_add
[    2.124525] bus: 'acpi': add device device:02
[    2.130331] device: 'device:03': device_add
[    2.134516] bus: 'acpi': add device device:03
[    2.139190] device: 'device:04': device_add
[    2.140032] bus: 'acpi': add device device:04
[    2.144709] device: 'device:05': device_add
[    2.150017] bus: 'acpi': add device device:05
[    2.154702] device: 'device:06': device_add
[    2.160018] bus: 'acpi': add device device:06
[    2.164696] device: 'device:07': device_add
[    2.170017] bus: 'acpi': add device device:07
[    2.174695] device: 'device:08': device_add
[    2.178884] bus: 'acpi': add device device:08
[    2.180332] device: 'device:09': device_add
[    2.184519] bus: 'acpi': add device device:09
[    2.190339] device: 'device:0a': device_add
[    2.194526] bus: 'acpi': add device device:0a
[    2.200340] device: 'device:0b': device_add
[    2.204528] bus: 'acpi': add device device:0b
[    2.210418] device: 'device:0c': device_add
[    2.214604] bus: 'acpi': add device device:0c
[    2.219272] device: 'device:0d': device_add
[    2.220016] bus: 'acpi': add device device:0d
[    2.224692] device: 'device:0e': device_add
[    2.230017] bus: 'acpi': add device device:0e
[    2.234700] device: 'device:0f': device_add
[    2.240016] bus: 'acpi': add device device:0f
[    2.244685] device: 'device:10': device_add
[    2.250017] bus: 'acpi': add device device:10
[    2.254730] device: 'device:11': device_add
[    2.258917] bus: 'acpi': add device device:11
[    2.260409] device: 'device:12': device_add
[    2.264596] bus: 'acpi': add device device:12
[    2.270406] device: 'device:13': device_add
[    2.274595] bus: 'acpi': add device device:13
[    2.280411] device: 'device:14': device_add
[    2.284603] bus: 'acpi': add device device:14
[    2.290402] device: 'device:15': device_add
[    2.294588] bus: 'acpi': add device device:15
[    2.299266] device: 'device:16': device_add
[    2.300034] bus: 'acpi': add device device:16
[    2.304736] device: 'device:17': device_add
[    2.310018] bus: 'acpi': add device device:17
[    2.315089] device: 'device:18': device_add
[    2.320017] bus: 'acpi': add device device:18
[    2.332832] device: 'device:19': device_add
[    2.337026] bus: 'acpi': add device device:19
[    2.340429] device: 'device:1a': device_add
[    2.344624] bus: 'acpi': add device device:1a
[    2.350592] device: 'device:1b': device_add
[    2.354787] bus: 'acpi': add device device:1b
[    2.360085] device: 'device:1c': device_add
[    2.364274] bus: 'acpi': add device device:1c
[    2.369297] device: 'ATK0110:00': device_add
[    2.370024] bus: 'acpi': add device ATK0110:00
[    2.375749] device: 'PNP0C0F:00': device_add
[    2.380017] bus: 'acpi': add device PNP0C0F:00
[    2.385129] device: 'PNP0C0F:01': device_add
[    2.390017] bus: 'acpi': add device PNP0C0F:01
[    2.395218] device: 'PNP0C0F:02': device_add
[    2.400018] bus: 'acpi': add device PNP0C0F:02
[    2.405140] device: 'PNP0C0F:03': device_add
[    2.410017] bus: 'acpi': add device PNP0C0F:03
[    2.415140] device: 'PNP0C0F:04': device_add
[    2.420017] bus: 'acpi': add device PNP0C0F:04
[    2.425160] device: 'PNP0C0F:05': device_add
[    2.430018] bus: 'acpi': add device PNP0C0F:05
[    2.435139] device: 'PNP0C0F:06': device_add
[    2.440017] bus: 'acpi': add device PNP0C0F:06
[    2.445222] device: 'PNP0C0F:07': device_add
[    2.449515] bus: 'acpi': add device PNP0C0F:07
[    2.450703] device: 'PNP0C0F:08': device_add
[    2.454976] bus: 'acpi': add device PNP0C0F:08
[    2.460715] device: 'PNP0C0F:09': device_add
[    2.464995] bus: 'acpi': add device PNP0C0F:09
[    2.470723] device: 'PNP0C0F:0a': device_add
[    2.475003] bus: 'acpi': add device PNP0C0F:0a
[    2.480701] device: 'PNP0C0F:0b': device_add
[    2.484978] bus: 'acpi': add device PNP0C0F:0b
[    2.490791] device: 'PNP0C0F:0c': device_add
[    2.495074] bus: 'acpi': add device PNP0C0F:0c
[    2.500711] device: 'PNP0C0F:0d': device_add
[    2.504987] bus: 'acpi': add device PNP0C0F:0d
[    2.510706] device: 'PNP0C0F:0e': device_add
[    2.514986] bus: 'acpi': add device PNP0C0F:0e
[    2.520749] device: 'PNP0C0F:0f': device_add
[    2.525029] bus: 'acpi': add device PNP0C0F:0f
[    2.530623] device: 'PNP0C0F:10': device_add
[    2.534900] bus: 'acpi': add device PNP0C0F:10
[    2.540224] device: 'PNP0C0F:11': device_add
[    2.544502] bus: 'acpi': add device PNP0C0F:11
[    2.549713] device: 'PNP0C0F:12': device_add
[    2.550018] bus: 'acpi': add device PNP0C0F:12
[    2.555203] device: 'PNP0C0F:13': device_add
[    2.560018] bus: 'acpi': add device PNP0C0F:13
[    2.565314] device: 'PNP0C0F:14': device_add
[    2.570035] bus: 'acpi': add device PNP0C0F:14
[    2.575230] device: 'PNP0C0F:15': device_add
[    2.580018] bus: 'acpi': add device PNP0C0F:15
[    2.585214] device: 'PNP0C0F:16': device_add
[    2.590021] bus: 'acpi': add device PNP0C0F:16
[    2.595235] device: 'PNP0C0F:17': device_add
[    2.600018] bus: 'acpi': add device PNP0C0F:17
[    2.605201] device: 'PNP0C0F:18': device_add
[    2.610018] bus: 'acpi': add device PNP0C0F:18
[    2.615313] device: 'PNP0C0F:19': device_add
[    2.620019] bus: 'acpi': add device PNP0C0F:19
[    2.625227] device: 'PNP0C0F:1a': device_add
[    2.630019] bus: 'acpi': add device PNP0C0F:1a
[    2.635219] device: 'PNP0C0F:1b': device_add
[    2.639499] bus: 'acpi': add device PNP0C0F:1b
[    2.640787] device: 'PNP0C0F:1c': device_add
[    2.645066] bus: 'acpi': add device PNP0C0F:1c
[    2.650766] device: 'PNP0C0F:1d': device_add
[    2.655047] bus: 'acpi': add device PNP0C0F:1d
[    2.660887] device: 'PNP0C0F:1e': device_add
[    2.665169] bus: 'acpi': add device PNP0C0F:1e
[    2.670783] device: 'PNP0C0F:1f': device_add
[    2.675064] bus: 'acpi': add device PNP0C0F:1f
[    2.680372] device: 'PNP0C02:01': device_add
[    2.684650] bus: 'acpi': add device PNP0C02:01
[    2.690392] device: 'PNP0000:00': device_add
[    2.694666] bus: 'acpi': add device PNP0000:00
[    2.700322] device: 'PNP0200:00': device_add
[    2.704598] bus: 'acpi': add device PNP0200:00
[    2.709360] device: 'PNP0100:00': device_add
[    2.710018] bus: 'acpi': add device PNP0100:00
[    2.714790] device: 'PNP0B00:00': device_add
[    2.720018] bus: 'acpi': add device PNP0B00:00
[    2.724769] device: 'PNP0800:00': device_add
[    2.730019] bus: 'acpi': add device PNP0800:00
[    2.734820] device: 'PNP0C04:00': device_add
[    2.740019] bus: 'acpi': add device PNP0C04:00
[    2.745840] device: 'PNP0700:00': device_add
[    2.750019] bus: 'acpi': add device PNP0700:00
[    2.756178] device: 'PNP0501:00': device_add
[    2.760021] bus: 'acpi': add device PNP0501:00
[    2.767396] device: 'PNP0401:00': device_add
[    2.770020] bus: 'acpi': add device PNP0401:00
[    2.775181] device: 'PNP0F13:00': device_add
[    2.780019] bus: 'acpi': add device PNP0F13:00
[    2.785222] device: 'PNP0303:00': device_add
[    2.790020] bus: 'acpi': add device PNP0303:00
[    2.796017] device: 'PNPB006:00': device_add
[    2.800019] bus: 'acpi': add device PNPB006:00
[    2.806092] device: 'PNPB02F:00': device_add
[    2.810021] bus: 'acpi': add device PNPB02F:00
[    2.814818] device: 'PNP0C02:02': device_add
[    2.820019] bus: 'acpi': add device PNP0C02:02
[    2.824882] device: 'PNP0C01:00': device_add
[    2.830017] bus: 'acpi': add device PNP0C01:00
[    2.834678] device: 'LNXTHERM:00': device_add
[    2.840016] bus: 'acpi': add device LNXTHERM:00
[    2.844828] device: 'PNP0C0B:00': device_add
[    2.849106] bus: 'acpi': add device PNP0C0B:00
[    2.850191] device: 'LNXTHERM:01': device_add
[    2.854552] bus: 'acpi': add device LNXTHERM:01
[    2.861666] device: 'LNXPWRBN:00': device_add
[    2.866024] bus: 'acpi': add device LNXPWRBN:00
[    2.870137] bus: 'acpi': add driver ec
[    2.874051] bus: 'acpi': add driver power
[    2.880297] initcall acpi_init+0x0/0x12f returned 0 after 917968 usecs
[    2.886813] calling  dock_init+0x0/0xa5 @ 1
[    2.891447] ACPI: No dock devices found.
[    2.895365] initcall dock_init+0x0/0xa5 returned 0 after 0 usecs
[    2.900007] calling  acpi_pci_root_init+0x0/0x2d @ 1
[    2.904970] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    2.910007] bus: 'acpi': add driver pci_root
[    2.920023] bus: 'acpi': driver_probe_device: matched device PNP0A08:00 with driver pci_root
[    2.930006] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A08:00
[    2.938290] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    2.940128] device: 'pci0000:00': device_add
[    2.944445] device: '0000:00': device_add
[    2.950815] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    2.960008] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    2.967478] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    2.970007] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
[    2.980007] pci_root PNP0A08:00: host bridge window [mem 0x40000000-0xfebfffff] (ignored)
[    2.990008] pci_bus 0000:00: scanning bus
[    2.994062] pci 0000:00:00.0: found [10de:005e] class 000580 header type 00
[    3.000172] pci 0000:00:01.0: found [10de:0050] class 000601 header type 00
[    3.010110] pci 0000:00:01.1: found [10de:0052] class 000c05 header type 00
[    3.017085] pci 0000:00:01.1: reg 10: [io  0xdc00-0xdc1f]
[    3.020041] pci 0000:00:01.1: reg 20: [io  0x4c00-0x4c3f]
[    3.025442] pci 0000:00:01.1: reg 24: [io  0x4c40-0x4c7f]
[    3.030047] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    3.040011] pci 0000:00:01.1: PME# disabled
[    3.044240] pci 0000:00:02.0: found [10de:005a] class 000c03 header type 00
[    3.050029] pci 0000:00:02.0: reg 10: [mem 0xda102000-0xda102fff]
[    3.056192] pci 0000:00:02.0: supports D1 D2
[    3.060007] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.066616] pci 0000:00:02.0: PME# disabled
[    3.070046] pci 0000:00:02.1: found [10de:005b] class 000c03 header type 00
[    3.080034] pci 0000:00:02.1: reg 10: [mem 0xfeb00000-0xfeb000ff]
[    3.086216] pci 0000:00:02.1: supports D1 D2
[    3.090007] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    3.096616] pci 0000:00:02.1: PME# disabled
[    3.100066] pci 0000:00:04.0: found [10de:0059] class 000401 header type 00
[    3.107041] pci 0000:00:04.0: reg 10: [io  0xd400-0xd4ff]
[    3.110019] pci 0000:00:04.0: reg 14: [io  0xd800-0xd8ff]
[    3.115417] pci 0000:00:04.0: reg 18: [mem 0xda101000-0xda101fff]
[    3.120072] pci 0000:00:04.0: supports D1 D2
[    3.124372] pci 0000:00:06.0: found [10de:0053] class 000101 header type 00
[    3.130060] pci 0000:00:06.0: reg 20: [io  0xf000-0xf00f]
[    3.140088] pci 0000:00:09.0: found [10de:005c] class 000604 header type 01
[    3.147101] pci 0000:00:0a.0: found [10de:0057] class 000680 header type 00
[    3.150029] pci 0000:00:0a.0: reg 10: [mem 0xda100000-0xda100fff]
[    3.160015] pci 0000:00:0a.0: reg 14: [io  0xd000-0xd007]
[    3.165484] pci 0000:00:0a.0: supports D1 D2
[    3.170007] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.176618] pci 0000:00:0a.0: PME# disabled
[    3.180050] pci 0000:00:0b.0: found [10de:005d] class 000604 header type 01
[    3.190112] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.196719] pci 0000:00:0b.0: PME# disabled
[    3.200066] pci 0000:00:0c.0: found [10de:005d] class 000604 header type 01
[    3.207126] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.210011] pci 0000:00:0c.0: PME# disabled
[    3.214245] pci 0000:00:0d.0: found [10de:005d] class 000604 header type 01
[    3.220112] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.230011] pci 0000:00:0d.0: PME# disabled
[    3.234247] pci 0000:00:0e.0: found [10de:005d] class 000604 header type 01
[    3.240112] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.250011] pci 0000:00:0e.0: PME# disabled
[    3.254262] pci 0000:00:18.0: found [1022:1100] class 000600 header type 00
[    3.260122] pci 0000:00:18.1: found [1022:1101] class 000600 header type 00
[    3.267158] pci 0000:00:18.2: found [1022:1102] class 000600 header type 00
[    3.270098] pci 0000:00:18.3: found [1022:1103] class 000600 header type 00
[    3.280115] pci_bus 0000:00: fixups for bus
[    3.284293] PCI: peer root bus 00 res updated from pci conf
[    3.290021] pci 0000:00:09.0: scanning [bus 05-05] behind bridge, pass 0
[    3.296736] pci_bus 0000:05: scanning bus
[    3.300054] pci 0000:05:07.0: found [10ec:8139] class 000200 header type 00
[    3.310032] pci 0000:05:07.0: reg 10: [io  0xc000-0xc0ff]
[    3.315438] pci 0000:05:07.0: reg 14: [mem 0xda000000-0xda0000ff]
[    3.320090] pci 0000:05:07.0: supports D1 D2
[    3.324352] pci 0000:05:07.0: PME# supported from D1 D2 D3hot
[    3.330023] pci 0000:05:07.0: PME# disabled
[    3.334295] pci_bus 0000:05: fixups for bus
[    3.340007] pci 0000:00:09.0: PCI bridge to [bus 05-05] (subtractive decode)
[    3.347050] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    3.350011] pci 0000:00:09.0:   bridge window [mem 0xda000000-0xda0fffff]
[    3.360011] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    3.368180] pci 0000:00:09.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    3.370010] pci 0000:00:09.0:   bridge window [mem 0x40000000-0xfcffffffff] (subtractive decode)
[    3.380008] pci 0000:00:09.0:   bridge window [mem 0xfeb00000-0xfec0ffff] (subtractive decode)
[    3.390008] pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    3.400006] pci_bus 0000:05: bus scan returning with max=05
[    3.405580] pci 0000:00:0b.0: scanning [bus 04-04] behind bridge, pass 0
[    3.410104] pci_bus 0000:04: scanning bus
[    3.414113] pci_bus 0000:04: fixups for bus
[    3.420007] pci 0000:00:0b.0: PCI bridge to [bus 04-04]
[    3.425237] pci 0000:00:0b.0:   bridge window [io  0xf000-0x0000] (disabled)
[    3.430011] pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    3.440015] pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    3.450006] pci_bus 0000:04: bus scan returning with max=04
[    3.455579] pci 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 0
[    3.460104] pci_bus 0000:03: scanning bus
[    3.464114] pci_bus 0000:03: fixups for bus
[    3.470007] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    3.475234] pci 0000:00:0c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    3.480011] pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    3.490015] pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    3.500006] pci_bus 0000:03: bus scan returning with max=03
[    3.505579] pci 0000:00:0d.0: scanning [bus 02-02] behind bridge, pass 0
[    3.510143] pci_bus 0000:02: scanning bus
[    3.514155] pci_bus 0000:02: fixups for bus
[    3.520007] pci 0000:00:0d.0: PCI bridge to [bus 02-02]
[    3.525235] pci 0000:00:0d.0:   bridge window [io  0xf000-0x0000] (disabled)
[    3.530011] pci 0000:00:0d.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    3.540015] pci 0000:00:0d.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    3.548180] pci_bus 0000:02: bus scan returning with max=02
[    3.550012] pci 0000:00:0e.0: scanning [bus 01-01] behind bridge, pass 0
[    3.560103] pci_bus 0000:01: scanning bus
[    3.564142] pci 0000:01:00.0: found [1002:5b60] class 000300 header type 00
[    3.570024] pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
[    3.576554] pci 0000:01:00.0: reg 14: [io  0xb000-0xb0ff]
[    3.580016] pci 0000:01:00.0: reg 18: [mem 0xd9000000-0xd900ffff]
[    3.590045] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    3.596608] pci 0000:01:00.0: supports D1 D2
[    3.600056] pci 0000:01:00.1: found [1002:5b70] class 000380 header type 00
[    3.607024] pci 0000:01:00.1: reg 10: [mem 0xd9010000-0xd901ffff]
[    3.610107] pci 0000:01:00.1: supports D1 D2
[    3.614404] pci_bus 0000:01: fixups for bus
[    3.620007] pci 0000:00:0e.0: PCI bridge to [bus 01-01]
[    3.625237] pci 0000:00:0e.0:   bridge window [io  0xb000-0xbfff]
[    3.630012] pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
[    3.640015] pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    3.647747] pci_bus 0000:01: bus scan returning with max=01
[    3.650012] pci 0000:00:09.0: scanning [bus 05-05] behind bridge, pass 1
[    3.660015] pci 0000:00:0b.0: scanning [bus 04-04] behind bridge, pass 1
[    3.666717] pci 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 1
[    3.670015] pci 0000:00:0d.0: scanning [bus 02-02] behind bridge, pass 1
[    3.680015] pci 0000:00:0e.0: scanning [bus 01-01] behind bridge, pass 1
[    3.686714] pci_bus 0000:00: bus scan returning with max=05
[    3.690020] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    3.702496] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    3.710933] device: '0000:00:00.0': device_add
[    3.733910] bus: 'pci': add device 0000:00:00.0
[    3.738597] device: '0000:00:01.0': device_add
[    3.761719] bus: 'pci': add device 0000:00:01.0
[    3.766388] device: '0000:00:01.1': device_add
[    3.789358] bus: 'pci': add device 0000:00:01.1
[    3.790158] device: '0000:00:02.0': device_add
[    3.817004] bus: 'pci': add device 0000:00:02.0
[    3.820136] device: '0000:00:02.1': device_add
[    3.847022] bus: 'pci': add device 0000:00:02.1
[    3.850136] device: '0000:00:04.0': device_add
[    3.876456] bus: 'pci': add device 0000:00:04.0
[    3.880152] device: '0000:00:06.0': device_add
[    3.904380] bus: 'pci': add device 0000:00:06.0
[    3.909054] device: '0000:00:09.0': device_add
[    3.932168] bus: 'pci': add device 0000:00:09.0
[    3.936841] device: '0000:00:0a.0': device_add
[    3.959919] bus: 'pci': add device 0000:00:0a.0
[    3.960153] device: '0000:00:0b.0': device_add
[    3.987690] bus: 'pci': add device 0000:00:0b.0
[    3.990159] device: '0000:00:0c.0': device_add
[    4.015318] bus: 'pci': add device 0000:00:0c.0
[    4.019968] device: '0000:00:0d.0': device_add
[    4.045257] bus: 'pci': add device 0000:00:0d.0
[    4.049908] device: '0000:00:0e.0': device_add
[    4.075504] bus: 'pci': add device 0000:00:0e.0
[    4.080154] device: '0000:00:18.0': device_add
[    4.103348] bus: 'pci': add device 0000:00:18.0
[    4.108019] device: '0000:00:18.1': device_add
[    4.131050] bus: 'pci': add device 0000:00:18.1
[    4.135836] device: '0000:00:18.2': device_add
[    4.160610] bus: 'pci': add device 0000:00:18.2
[    4.165303] device: '0000:00:18.3': device_add
[    4.192030] bus: 'pci': add device 0000:00:18.3
[    4.196701] device: '0000:05:07.0': device_add
[    4.200029] bus: 'pci': add device 0000:05:07.0
[    4.204700] device: '0000:05': device_add
[    4.208786] device: '0000:04': device_add
[    4.210107] device: '0000:03': device_add
[    4.214184] device: '0000:02': device_add
[    4.220083] device: '0000:01:00.0': device_add
[    4.224546] bus: 'pci': add device 0000:01:00.0
[    4.230152] device: '0000:01:00.1': device_add
[    4.234615] bus: 'pci': add device 0000:01:00.1
[    4.240153] device: '0000:01': device_add
[    4.244236] driver: 'PNP0A08:00': driver_bound: bound to device 'pci_root'
[    4.250009] bus: 'acpi': really_probe: bound device PNP0A08:00 to driver pci_root
[    4.257643] initcall acpi_pci_root_init+0x0/0x2d returned 0 after 1318359 usecs
[    4.260008] calling  acpi_pci_link_init+0x0/0x43 @ 1
[    4.270009] bus: 'acpi': add driver pci_link
[    4.274327] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    4.280007] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    4.290596] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.300351] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    4.307219] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    4.310014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    4.320007] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    4.330509] ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    4.337938] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    4.340009] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    4.350014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    4.360006] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    4.370423] ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    4.377785] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    4.380009] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    4.390013] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    4.400007] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    4.408195] ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.414007] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    4.420008] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    4.430014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
[    4.440006] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
[    4.448193] ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.454007] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
[    4.460008] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
[    4.470014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:05 with driver pci_link
[    4.480006] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:05
[    4.488194] ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.494009] driver: 'PNP0C0F:05': driver_bound: bound to device 'pci_link'
[    4.500008] bus: 'acpi': really_probe: bound device PNP0C0F:05 to driver pci_link
[    4.510013] bus: 'acpi': driver_probe_device: matched device PNP0C0F:06 with driver pci_link
[    4.518439] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:06
[    4.520377] ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.534008] driver: 'PNP0C0F:06': driver_bound: bound to device 'pci_link'
[    4.540008] bus: 'acpi': really_probe: bound device PNP0C0F:06 to driver pci_link
[    4.550013] bus: 'acpi': driver_probe_device: matched device PNP0C0F:07 with driver pci_link
[    4.558442] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:07
[    4.560392] ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    4.572847] driver: 'PNP0C0F:07': driver_bound: bound to device 'pci_link'
[    4.580008] bus: 'acpi': really_probe: bound device PNP0C0F:07 to driver pci_link
[    4.587484] bus: 'acpi': driver_probe_device: matched device PNP0C0F:08 with driver pci_link
[    4.590006] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:08
[    4.600393] ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 9 10 11 12 14 15)
[    4.612847] driver: 'PNP0C0F:08': driver_bound: bound to device 'pci_link'
[    4.620008] bus: 'acpi': really_probe: bound device PNP0C0F:08 to driver pci_link
[    4.627483] bus: 'acpi': driver_probe_device: matched device PNP0C0F:09 with driver pci_link
[    4.630007] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:09
[    4.640379] ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.652777] driver: 'PNP0C0F:09': driver_bound: bound to device 'pci_link'
[    4.659644] bus: 'acpi': really_probe: bound device PNP0C0F:09 to driver pci_link
[    4.660014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:0a with driver pci_link
[    4.670008] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0a
[    4.680378] ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.692226] driver: 'PNP0C0F:0a': driver_bound: bound to device 'pci_link'
[    4.699089] bus: 'acpi': really_probe: bound device PNP0C0F:0a to driver pci_link
[    4.700014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:0b with driver pci_link
[    4.710006] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0b
[    4.720409] ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.731976] driver: 'PNP0C0F:0b': driver_bound: bound to device 'pci_link'
[    4.738837] bus: 'acpi': really_probe: bound device PNP0C0F:0b to driver pci_link
[    4.740014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:0c with driver pci_link
[    4.750006] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0c
[    4.760466] ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.771635] driver: 'PNP0C0F:0c': driver_bound: bound to device 'pci_link'
[    4.778500] bus: 'acpi': really_probe: bound device PNP0C0F:0c to driver pci_link
[    4.780014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:0d with driver pci_link
[    4.790007] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0d
[    4.800582] ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.811430] driver: 'PNP0C0F:0d': driver_bound: bound to device 'pci_link'
[    4.818292] bus: 'acpi': really_probe: bound device PNP0C0F:0d to driver pci_link
[    4.820014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:0e with driver pci_link
[    4.830007] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0e
[    4.840478] ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.850414] driver: 'PNP0C0F:0e': driver_bound: bound to device 'pci_link'
[    4.857280] bus: 'acpi': really_probe: bound device PNP0C0F:0e to driver pci_link
[    4.860014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:0f with driver pci_link
[    4.870007] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0f
[    4.880391] ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.890319] driver: 'PNP0C0F:0f': driver_bound: bound to device 'pci_link'
[    4.897185] bus: 'acpi': really_probe: bound device PNP0C0F:0f to driver pci_link
[    4.900014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:10 with driver pci_link
[    4.910006] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:10
[    4.920568] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[    4.927030] driver: 'PNP0C0F:10': driver_bound: bound to device 'pci_link'
[    4.930010] bus: 'acpi': really_probe: bound device PNP0C0F:10 to driver pci_link
[    4.940014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:11 with driver pci_link
[    4.950006] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:11
[    4.958384] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
[    4.960975] driver: 'PNP0C0F:11': driver_bound: bound to device 'pci_link'
[    4.970008] bus: 'acpi': really_probe: bound device PNP0C0F:11 to driver pci_link
[    4.977483] bus: 'acpi': driver_probe_device: matched device PNP0C0F:12 with driver pci_link
[    4.980007] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:12
[    4.990568] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
[    5.000975] driver: 'PNP0C0F:12': driver_bound: bound to device 'pci_link'
[    5.007841] bus: 'acpi': really_probe: bound device PNP0C0F:12 to driver pci_link
[    5.010014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:13 with driver pci_link
[    5.020007] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:13
[    5.030567] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    5.037023] driver: 'PNP0C0F:13': driver_bound: bound to device 'pci_link'
[    5.040009] bus: 'acpi': really_probe: bound device PNP0C0F:13 to driver pci_link
[    5.050014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:14 with driver pci_link
[    5.060006] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:14
[    5.070230] ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
[    5.076503] driver: 'PNP0C0F:14': driver_bound: bound to device 'pci_link'
[    5.080008] bus: 'acpi': really_probe: bound device PNP0C0F:14 to driver pci_link
[    5.090013] bus: 'acpi': driver_probe_device: matched device PNP0C0F:15 with driver pci_link
[    5.098441] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:15
[    5.100641] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
[    5.112779] driver: 'PNP0C0F:15': driver_bound: bound to device 'pci_link'
[    5.120008] bus: 'acpi': really_probe: bound device PNP0C0F:15 to driver pci_link
[    5.127485] bus: 'acpi': driver_probe_device: matched device PNP0C0F:16 with driver pci_link
[    5.130007] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:16
[    5.140798] ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
[    5.152779] driver: 'PNP0C0F:16': driver_bound: bound to device 'pci_link'
[    5.160009] bus: 'acpi': really_probe: bound device PNP0C0F:16 to driver pci_link
[    5.167484] bus: 'acpi': driver_probe_device: matched device PNP0C0F:17 with driver pci_link
[    5.170007] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:17
[    5.180829] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[    5.191810] driver: 'PNP0C0F:17': driver_bound: bound to device 'pci_link'
[    5.198673] bus: 'acpi': really_probe: bound device PNP0C0F:17 to driver pci_link
[    5.200014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:18 with driver pci_link
[    5.210007] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:18
[    5.220717] ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
[    5.227068] driver: 'PNP0C0F:18': driver_bound: bound to device 'pci_link'
[    5.230009] bus: 'acpi': really_probe: bound device PNP0C0F:18 to driver pci_link
[    5.240014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:19 with driver pci_link
[    5.250006] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:19
[    5.260746] ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
[    5.268096] driver: 'PNP0C0F:19': driver_bound: bound to device 'pci_link'
[    5.270009] bus: 'acpi': really_probe: bound device PNP0C0F:19 to driver pci_link
[    5.280014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:1a with driver pci_link
[    5.290006] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1a
[    5.298544] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
[    5.302832] driver: 'PNP0C0F:1a': driver_bound: bound to device 'pci_link'
[    5.310009] bus: 'acpi': really_probe: bound device PNP0C0F:1a to driver pci_link
[    5.320013] bus: 'acpi': driver_probe_device: matched device PNP0C0F:1b with driver pci_link
[    5.330016] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1b
[    5.338474] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
[    5.342776] driver: 'PNP0C0F:1b': driver_bound: bound to device 'pci_link'
[    5.350009] bus: 'acpi': really_probe: bound device PNP0C0F:1b to driver pci_link
[    5.360014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:1c with driver pci_link
[    5.368440] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1c
[    5.370628] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[    5.382815] driver: 'PNP0C0F:1c': driver_bound: bound to device 'pci_link'
[    5.390008] bus: 'acpi': really_probe: bound device PNP0C0F:1c to driver pci_link
[    5.397484] bus: 'acpi': driver_probe_device: matched device PNP0C0F:1d with driver pci_link
[    5.400007] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1d
[    5.410630] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
[    5.422815] driver: 'PNP0C0F:1d': driver_bound: bound to device 'pci_link'
[    5.429679] bus: 'acpi': really_probe: bound device PNP0C0F:1d to driver pci_link
[    5.430014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:1e with driver pci_link
[    5.440007] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1e
[    5.450631] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
[    5.461601] driver: 'PNP0C0F:1e': driver_bound: bound to device 'pci_link'
[    5.468467] bus: 'acpi': really_probe: bound device PNP0C0F:1e to driver pci_link
[    5.470014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:1f with driver pci_link
[    5.480006] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1f
[    5.490630] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    5.500123] driver: 'PNP0C0F:1f': driver_bound: bound to device 'pci_link'
[    5.506985] bus: 'acpi': really_probe: bound device PNP0C0F:1f to driver pci_link
[    5.510076] initcall acpi_pci_link_init+0x0/0x43 returned 0 after 1210937 usecs
[    5.520008] calling  pnp_init+0x0/0x12 @ 1
[    5.524161] bus: 'pnp': registered
[    5.527558] initcall pnp_init+0x0/0x12 returned 0 after 0 usecs
[    5.530008] calling  misc_init+0x0/0xb7 @ 1
[    5.534202] device class 'misc': registering
[    5.540050] initcall misc_init+0x0/0xb7 returned 0 after 9765 usecs
[    5.550008] calling  wm831x_i2c_init+0x0/0x33 @ 1
[    5.554708] bus: 'i2c': add driver wm831x
[    5.558782] i2c-core: driver [wm831x] registered
[    5.560011] initcall wm831x_i2c_init+0x0/0x33 returned 0 after 9765 usecs
[    5.570007] calling  wm8350_i2c_init+0x0/0x14 @ 1
[    5.574708] bus: 'i2c': add driver wm8350
[    5.578757] i2c-core: driver [wm8350] registered
[    5.580010] initcall wm8350_i2c_init+0x0/0x14 returned 0 after 9765 usecs
[    5.590007] calling  tps_init+0x0/0xb2 @ 1
[    5.594102] tps65010: version 2 May 2005
[    5.598025] bus: 'i2c': add driver tps65010
[    5.600048] i2c-core: driver [tps65010] registered
[    5.604928] bus: 'i2c': remove driver tps65010
[    5.610038] driver: 'tps65010': driver_release
[    5.614483] i2c-core: driver [tps65010] unregistered
[    5.640023] bus: 'i2c': add driver tps65010
[    5.644246] i2c-core: driver [tps65010] registered
[    5.649051] bus: 'i2c': remove driver tps65010
[    5.650035] driver: 'tps65010': driver_release
[    5.654476] i2c-core: driver [tps65010] unregistered
[    5.680019] bus: 'i2c': add driver tps65010
[    5.684241] i2c-core: driver [tps65010] registered
[    5.689045] bus: 'i2c': remove driver tps65010
[    5.690035] driver: 'tps65010': driver_release
[    5.694475] i2c-core: driver [tps65010] unregistered
[    5.700006] tps65010: no chip?
[    5.703063] initcall tps_init+0x0/0xb2 returned -19 after 107421 usecs
[    5.710009] calling  max8925_i2c_init+0x0/0x33 @ 1
[    5.714794] bus: 'i2c': add driver max8925
[    5.720046] i2c-core: driver [max8925] registered
[    5.724746] initcall max8925_i2c_init+0x0/0x33 returned 0 after 9765 usecs
[    5.730007] calling  pcf50633_init+0x0/0x14 @ 1
[    5.734535] bus: 'i2c': add driver pcf50633
[    5.740047] i2c-core: driver [pcf50633] registered
[    5.744833] initcall pcf50633_init+0x0/0x14 returned 0 after 9765 usecs
[    5.750007] calling  ab3100_i2c_init+0x0/0x14 @ 1
[    5.754707] bus: 'i2c': add driver ab3100
[    5.760048] i2c-core: driver [ab3100] registered
[    5.764667] initcall ab3100_i2c_init+0x0/0x14 returned 0 after 9765 usecs
[    5.770007] calling  init_scsi+0x0/0x81 @ 1
[    5.774588] device class 'scsi_host': registering
[    5.780178] bus: 'scsi': registered
[    5.783666] device class 'scsi_device': registering
[    5.790081] SCSI subsystem initialized
[    5.793825] initcall init_scsi+0x0/0x81 returned 0 after 19531 usecs
[    5.800008] calling  ata_init+0x0/0x374 @ 1
[    5.804267] libata version 3.00 loaded.
[    5.804267] initcall ata_init+0x0/0x374 returned 0 after 0 usecs
[    5.810008] calling  phy_init+0x0/0x2e @ 1
[    5.814104] device class 'mdio_bus': registering
[    5.820133] bus: 'mdio_bus': registered
[    5.823968] bus: 'mdio_bus': add driver Generic PHY
[    5.830048] initcall phy_init+0x0/0x2e returned 0 after 19531 usecs
[    5.836302] calling  init_pcmcia_cs+0x0/0x36 @ 1
[    5.840005] device class 'pcmcia_socket': registering
[    5.845070] initcall init_pcmcia_cs+0x0/0x36 returned 0 after 0 usecs
[    5.850006] calling  usb_init+0x0/0x173 @ 1
[    5.860042] bus: 'usb': registered
[    5.863453] bus: 'usb': add driver usbfs
[    5.867452] usbcore: registered new interface driver usbfs
[    5.870011] device class 'usb_device': registering
[    5.874880] bus: 'usb': add driver hub
[    5.880056] usbcore: registered new interface driver hub
[    5.887026] bus: 'usb': add driver usb
[    5.890056] usbcore: registered new device driver usb
[    5.895108] initcall usb_init+0x0/0x173 returned 0 after 39062 usecs
[    5.900008] calling  serio_init+0x0/0x86 @ 1
[    5.904332] bus: 'serio': registered
[    5.910066] initcall serio_init+0x0/0x86 returned 0 after 9765 usecs
[    5.916363] calling  gameport_init+0x0/0x86 @ 1
[    5.920074] bus: 'gameport': registered
[    5.925132] initcall gameport_init+0x0/0x86 returned 0 after 0 usecs
[    5.930008] calling  input_init+0x0/0x13d @ 1
[    5.934361] device class 'input': registering
[    5.940083] initcall input_init+0x0/0x13d returned 0 after 9765 usecs
[    5.946518] calling  rtc_init+0x0/0x71 @ 1
[    5.950008] device class 'rtc': registering
[    5.954223] initcall rtc_init+0x0/0x71 returned 0 after 0 usecs
[    5.960008] calling  pps_init+0x0/0xb1 @ 1
[    5.964100] device class 'pps': registering
[    5.968317] LinuxPPS API ver. 1 registered
[    5.970008] Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    5.980007] initcall pps_init+0x0/0xb1 returned 0 after 19531 usecs
[    5.986268] calling  power_supply_class_init+0x0/0x38 @ 1
[    5.990007] device class 'power_supply': registering
[    5.995044] initcall power_supply_class_init+0x0/0x38 returned 0 after 0 usecs
[    6.000007] calling  thermal_init+0x0/0x57 @ 1
[    6.010006] device class 'thermal': registering
[    6.014596] initcall thermal_init+0x0/0x57 returned 0 after 0 usecs
[    6.020008] calling  leds_init+0x0/0x48 @ 1
[    6.024187] device class 'leds': registering
[    6.028486] initcall leds_init+0x0/0x48 returned 0 after 0 usecs
[    6.030008] calling  init_soundcore+0x0/0x38 @ 1
[    6.040007] device class 'sound': registering
[    6.044391] initcall init_soundcore+0x0/0x38 returned 0 after 0 usecs
[    6.050008] calling  pci_subsys_init+0x0/0xcf @ 1
[    6.054707] PCI: Using ACPI for IRQ routing
[    6.058893] PCI: pci_cache_line_size set to 64 bytes
[    6.060050] pci 0000:00:01.1: BAR 0: reserving [io  0xdc00-0xdc1f flags 0x40101] (d=0, p=0)
[    6.070009] pci 0000:00:01.1: BAR 4: reserving [io  0x4c00-0x4c3f flags 0x40101] (d=0, p=0)
[    6.080008] pci 0000:00:01.1: BAR 5: reserving [io  0x4c40-0x4c7f flags 0x40101] (d=0, p=0)
[    6.088355] pci 0000:00:02.0: BAR 0: reserving [mem 0xda102000-0xda102fff flags 0x40200] (d=0, p=0)
[    6.090018] pci 0000:00:02.1: BAR 0: reserving [mem 0xfeb00000-0xfeb000ff flags 0x40200] (d=0, p=0)
[    6.100009] pci 0000:00:02.1: address space collision: [mem 0xfeb00000-0xfeb000ff] conflicts with PCI Bus #00 [mem 0xfeb00000-0xfec0ffff]
[    6.110017] pci 0000:00:04.0: BAR 0: reserving [io  0xd400-0xd4ff flags 0x40101] (d=0, p=0)
[    6.118356] pci 0000:00:04.0: BAR 1: reserving [io  0xd800-0xd8ff flags 0x40101] (d=0, p=0)
[    6.120008] pci 0000:00:04.0: BAR 2: reserving [mem 0xda101000-0xda101fff flags 0x40200] (d=0, p=0)
[    6.130018] pci 0000:00:06.0: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
[    6.140008] pci 0000:00:06.0: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
[    6.150008] pci 0000:00:06.0: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
[    6.160008] pci 0000:00:06.0: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
[    6.167565] pci 0000:00:06.0: BAR 4: reserving [io  0xf000-0xf00f flags 0x40101] (d=0, p=0)
[    6.170027] pci 0000:00:0a.0: BAR 0: reserving [mem 0xda100000-0xda100fff flags 0x40200] (d=0, p=0)
[    6.180009] pci 0000:00:0a.0: BAR 1: reserving [io  0xd000-0xd007 flags 0x40101] (d=0, p=0)
[    6.190090] pci 0000:05:07.0: BAR 0: reserving [io  0xc000-0xc0ff flags 0x40101] (d=0, p=0)
[    6.200008] pci 0000:05:07.0: BAR 1: reserving [mem 0xda000000-0xda0000ff flags 0x40200] (d=0, p=0)
[    6.210018] pci 0000:01:00.0: BAR 0: reserving [mem 0xd0000000-0xd7ffffff flags 0x42208] (d=0, p=0)
[    6.220008] pci 0000:01:00.0: BAR 1: reserving [io  0xb000-0xb0ff flags 0x40101] (d=0, p=0)
[    6.228346] pci 0000:01:00.0: BAR 2: reserving [mem 0xd9000000-0xd900ffff flags 0x40200] (d=0, p=0)
[    6.230190] pci 0000:01:00.1: BAR 0: reserving [mem 0xd9010000-0xd901ffff flags 0x40200] (d=1, p=1)
[    6.240016] Expanded resource reserved due to conflict with PCI Bus #00
[    6.250007] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    6.256188] reserve RAM buffer: 000000003fff0000 - 000000003fffffff initcall pci_subsys_init+0x0/0xcf returned 0 after 205078 usecs
[    6.270008] calling  proto_init+0x0/0x12 @ 1
[    6.274290] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    6.280008] calling  net_dev_init+0x0/0x1b6 @ 1
[    6.284607] device class 'net': registering
[    6.290090] device: 'lo': device_add
[    6.294071] initcall net_dev_init+0x0/0x1b6 returned 0 after 9765 usecs
[    6.300008] calling  neigh_init+0x0/0x71 @ 1
[    6.304276] initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
[    6.310007] calling  fib_rules_init+0x0/0xa6 @ 1
[    6.314626] initcall fib_rules_init+0x0/0xa6 returned 0 after 0 usecs
[    6.320007] calling  pktsched_init+0x0/0xdc @ 1
[    6.324559] initcall pktsched_init+0x0/0xdc returned 0 after 0 usecs
[    6.330018] calling  tc_filter_init+0x0/0x4c @ 1
[    6.334631] initcall tc_filter_init+0x0/0x4c returned 0 after 0 usecs
[    6.340007] calling  tc_action_init+0x0/0x4c @ 1
[    6.344622] initcall tc_action_init+0x0/0x4c returned 0 after 0 usecs
[    6.350007] calling  genl_init+0x0/0x8f @ 1
[    6.360091] initcall genl_init+0x0/0x8f returned 0 after 0 usecs
[    6.366087] calling  cipso_v4_init+0x0/0x8b @ 1
[    6.370035] initcall cipso_v4_init+0x0/0x8b returned 0 after 0 usecs
[    6.376379] calling  wanrouter_init+0x0/0x55 @ 1
[    6.380007] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
[    6.387333] initcall wanrouter_init+0x0/0x55 returned 0 after 0 usecs
[    6.390008] calling  irda_init+0x0/0x99 @ 1
[    6.394270] NET: Registered protocol family 23
[    6.400168] initcall irda_init+0x0/0x99 returned 0 after 9765 usecs
[    6.410008] calling  bt_init+0x0/0x5a @ 1
[    6.414014] Bluetooth: Core ver 2.15
[    6.417675] device class 'bluetooth': registering
[    6.420078] NET: Registered protocol family 31
[    6.424519] Bluetooth: HCI device and connection manager initialized
[    6.430031] Bluetooth: HCI socket layer initialized
[    6.434904] initcall bt_init+0x0/0x5a returned 0 after 19531 usecs
[    6.440007] calling  atm_init+0x0/0xd7 @ 1
[    6.444096] NET: Registered protocol family 8
[    6.450005] NET: Registered protocol family 20
[    6.454481] device class 'atm': registering
[    6.460034] initcall atm_init+0x0/0xd7 returned 0 after 19531 usecs
[    6.466296] calling  cfg80211_init+0x0/0xca @ 1
[    6.470007] device class 'ieee80211': registering
[    6.474902] Registering platform device 'regulatory.0'. Parent at platform
[    6.480007] device: 'regulatory.0': device_add
[    6.484463] bus: 'platform': add device regulatory.0
[    6.490092] cfg80211: Calling CRDA to update world regulatory domain
[    6.500738] initcall cfg80211_init+0x0/0xca returned 0 after 29296 usecs
[    6.506716] calling  wireless_nlevent_init+0x0/0x12 @ 1
[    6.510011] initcall wireless_nlevent_init+0x0/0x12 returned 0 after 0 usecs
[    6.517054] calling  ieee80211_init+0x0/0x3b @ 1
[    6.520037] initcall ieee80211_init+0x0/0x3b returned 0 after 0 usecs
[    6.530007] calling  netlbl_init+0x0/0x81 @ 1
[    6.534361] NetLabel: Initializing
[    6.537764] NetLabel:  domain hash size = 128
[    6.540005] NetLabel:  protocols = UNLABELED CIPSOv4
[    6.545123] NetLabel:  unlabeled traffic allowed by default
[    6.550007] initcall netlbl_init+0x0/0x81 returned 0 after 19531 usecs
[    6.560007] calling  rfkill_init+0x0/0x5f @ 1
[    6.564361] device class 'rfkill': registering
[    6.568930] device: 'rfkill': device_add
[    6.570170] initcall rfkill_init+0x0/0x5f returned 0 after 9765 usecs
[    6.576603] calling  wpan_phy_class_init+0x0/0x3c @ 1
[    6.580007] device class 'ieee802154': registering
[    6.584923] initcall wpan_phy_class_init+0x0/0x3c returned 0 after 0 usecs
[    6.590007] calling  sysctl_init+0x0/0x48 @ 1
[    6.600011] initcall sysctl_init+0x0/0x48 returned 0 after 0 usecs
[    6.606182] calling  print_ICs+0x0/0x56d @ 1
[    6.610008] initcall print_ICs+0x0/0x56d returned 0 after 0 usecs
[    6.616095] calling  hpet_late_init+0x0/0x109 @ 1
[    6.620008] initcall hpet_late_init+0x0/0x109 returned -19 after 0 usecs
[    6.626700] calling  init_k8_nbs+0x0/0x28 @ 1
[    6.630270] initcall init_k8_nbs+0x0/0x28 returned 0 after 0 usecs
[    6.636441] calling  clocksource_done_booting+0x0/0x5e @ 1
[    6.640014] initcall clocksource_done_booting+0x0/0x5e returned 0 after 0 usecs
[    6.650008] calling  init_pipe_fs+0x0/0x4c @ 1
[    6.654542] initcall init_pipe_fs+0x0/0x4c returned 0 after 0 usecs
[    6.660007] calling  anon_inode_init+0x0/0x135 @ 1
[    6.664881] initcall anon_inode_init+0x0/0x135 returned 0 after 0 usecs
[    6.670019] calling  fscache_init+0x0/0xaf @ 1
[    6.674467] Slow work thread pool: Starting up
[    6.680105] Slow work thread pool: Ready
[    6.683976] FS-Cache: Loaded
[    6.690009] initcall fscache_init+0x0/0xaf returned 0 after 19531 usecs
[    6.696615] calling  cachefiles_init+0x0/0xa4 @ 1
[    6.700038] device: 'cachefiles': device_add
[    6.704385] CacheFiles: Loaded
[    6.707439] initcall cachefiles_init+0x0/0xa4 returned 0 after 0 usecs
[    6.710007] calling  tomoyo_initerface_init+0x0/0x15b @ 1
[    6.720282] initcall tomoyo_initerface_init+0x0/0x15b returned 0 after 0 usecs
[    6.727492] calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
[    6.730008] initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 0 usecs
[    6.740009] calling  acpi_event_init+0x0/0x81 @ 1
[    6.744874] initcall acpi_event_init+0x0/0x81 returned 0 after 0 usecs
[    6.750007] calling  pnpacpi_init+0x0/0x8c @ 1
[    6.754447] pnp: PnP ACPI init
[    6.760022] device: 'pnp0': device_add
[    6.763786] ACPI: bus type pnp registered
[    6.768737] device: '00:00': device_add
[    6.770313] bus: 'pnp': add device 00:00
[    6.774646] device: '00:01': device_add
[    6.780060] bus: 'pnp': add device 00:01
[    6.791041] device: '00:02': device_add
[    6.795133] bus: 'pnp': add device 00:02
[    6.799206] device: '00:03': device_add
[    6.800252] bus: 'pnp': add device 00:03
[    6.804351] device: '00:04': device_add
[    6.810258] bus: 'pnp': add device 00:04
[    6.814357] device: '00:05': device_add
[    6.818451] bus: 'pnp': add device 00:05
[    6.820166] device: '00:06': device_add
[    6.824258] bus: 'pnp': add device 00:06
[    6.831305] device: '00:07': device_add
[    6.835404] bus: 'pnp': add device 00:07
[    6.841728] device: '00:08': device_add
[    6.845831] bus: 'pnp': add device 00:08
[    6.854229] device: '00:09': device_add
[    6.858352] bus: 'pnp': add device 00:09
[    6.860581] device: '00:0a': device_add
[    6.864691] bus: 'pnp': add device 00:0a
[    6.870379] device: '00:0b': device_add
[    6.874496] bus: 'pnp': add device 00:0b
[    6.881795] device: '00:0c': device_add
[    6.885908] bus: 'pnp': add device 00:0c
[    6.891670] device: '00:0d': device_add
[    6.895800] bus: 'pnp': add device 00:0d
[    6.900252] device: '00:0e': device_add
[    6.904380] bus: 'pnp': add device 00:0e
[    6.909659] device: '00:0f': device_add
[    6.910317] bus: 'pnp': add device 00:0f
[    6.914348] pnp: PnP ACPI: found 16 devices
[    6.920007] ACPI: ACPI bus type pnp unregistered
[    6.924625] initcall pnpacpi_init+0x0/0x8c returned 0 after 166015 usecs
[    6.930007] calling  pnp_system_init+0x0/0x12 @ 1
[    6.934711] bus: 'pnp': add driver system
[    6.940022] bus: 'pnp': driver_probe_device: matched device 00:01 with driver system
[    6.947749] bus: 'pnp': really_probe: probing driver system with device 00:01
[    6.950027] system 00:01: [io  0x4000-0x407f] has been reserved
[    6.960010] system 00:01: [io  0x4080-0x40ff] has been reserved
[    6.965926] system 00:01: [io  0x4400-0x447f] has been reserved
[    6.970009] system 00:01: [io  0x4480-0x44ff] has been reserved
[    6.980010] system 00:01: [io  0x4800-0x487f] has been reserved
[    6.985926] system 00:01: [io  0x4880-0x48ff] has been reserved
[    6.990006] driver: '00:01': driver_bound: bound to device 'system'
[    6.996261] bus: 'pnp': really_probe: bound device 00:01 to driver system
[    7.000013] bus: 'pnp': driver_probe_device: matched device 00:02 with driver system
[    7.010006] bus: 'pnp': really_probe: probing driver system with device 00:02
[    7.020025] system 00:02: [io  0x04d0-0x04d1] has been reserved
[    7.025942] system 00:02: [io  0x0800-0x0805] has been reserved
[    7.030010] system 00:02: [io  0x0290-0x0297] has been reserved
[    7.035921] driver: '00:02': driver_bound: bound to device 'system'
[    7.040007] bus: 'pnp': really_probe: bound device 00:02 to driver system
[    7.050025] bus: 'pnp': driver_probe_device: matched device 00:0e with driver system
[    7.057756] bus: 'pnp': really_probe: probing driver system with device 00:0e
[    7.060025] system 00:0e: [mem 0xe0000000-0xefffffff] has been reserved
[    7.070006] driver: '00:0e': driver_bound: bound to device 'system'
[    7.076267] bus: 'pnp': really_probe: bound device 00:0e to driver system
[    7.080012] bus: 'pnp': driver_probe_device: matched device 00:0f with driver system
[    7.090006] bus: 'pnp': really_probe: probing driver system with device 00:0f
[    7.100045] system 00:0f: [mem 0x000f0000-0x000f3fff] could not be reserved
[    7.107002] system 00:0f: [mem 0x000f4000-0x000f7fff] could not be reserved
[    7.110012] system 00:0f: [mem 0x000f8000-0x000fbfff] could not be reserved
[    7.120012] system 00:0f: [mem 0x000fc000-0x000fffff] could not be reserved
[    7.126966] system 00:0f: [mem 0x3fff0000-0x3fffffff] could not be reserved
[    7.130013] system 00:0f: [mem 0xffff0000-0xffffffff] has been reserved
[    7.140012] system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
[    7.146967] system 00:0f: [mem 0x00100000-0x3ffeffff] could not be reserved
[    7.150012] system 00:0f: [mem 0xfec00000-0xfec00fff] could not be reserved
[    7.160010] system 00:0f: [mem 0xfee00000-0xfeefffff] has been reserved
[    7.166618] system 00:0f: [mem 0xfefff000-0xfeffffff] has been reserved
[    7.170010] system 00:0f: [mem 0xfff80000-0xfff80fff] has been reserved
[    7.180010] system 00:0f: [mem 0xfff90000-0xfffbffff] has been reserved
[    7.186618] system 00:0f: [mem 0xfffed000-0xfffeffff] has been reserved
[    7.190006] driver: '00:0f': driver_bound: bound to device 'system'
[    7.200007] bus: 'pnp': really_probe: bound device 00:0f to driver system
[    7.206828] initcall pnp_system_init+0x0/0x12 returned 0 after 263671 usecs
[    7.210007] calling  chr_dev_init+0x0/0xd1 @ 1
[    7.220040] device class 'mem': registering
[    7.224254] device: 'mem': device_add
[    7.228022] device: 'null': device_add
[    7.230087] device: 'port': device_add
[    7.233913] device: 'zero': device_add
[    7.240070] device: 'full': device_add
[    7.243880] device: 'random': device_add
[    7.247880] device: 'urandom': device_add
[    7.250070] device: 'kmsg': device_add
[    7.253934] initcall chr_dev_init+0x0/0xd1 returned 0 after 29296 usecs
[    7.260008] calling  firmware_class_init+0x0/0x79 @ 1
[    7.265054] device class 'firmware': registering
[    7.270073] initcall firmware_class_init+0x0/0x79 returned 0 after 9765 usecs
[    7.277195] calling  init_pcmcia_bus+0x0/0x65 @ 1
[    7.280069] bus: 'pcmcia': registered
[    7.283753] initcall init_pcmcia_bus+0x0/0x65 returned 0 after 0 usecs
[    7.290008] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    7.300020] initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 usecs
[    7.307663] calling  cpufreq_gov_powersave_init+0x0/0x12 @ 1
[    7.310009] initcall cpufreq_gov_powersave_init+0x0/0x12 returned 0 after 0 usecs
[    7.320007] calling  init_acpi_pm_clocksource+0x0/0xf6 @ 1
[    7.331237] Switching to clocksource acpi_pm
[    7.335650] initcall init_acpi_pm_clocksource+0x0/0xf6 returned 0 after 9798 usecs
[    7.335666] Switched to NOHz mode on CPU #0
[    7.341796] Switched to NOHz mode on CPU #1
[    7.345979] calling  ssb_modinit+0x0/0x50 @ 1
[    7.350432] bus: 'ssb': registered
[    7.353852] bus: 'pci': add driver b43-pci-bridge
[    7.358654] initcall ssb_modinit+0x0/0x50 returned 0 after 8112 usecs
[    7.365117] calling  pcibios_assign_resources+0x0/0x74 @ 1
[    7.370815] pci 0000:00:02.1: BAR 0: assigned [mem 0x40000000-0x400000ff]
[    7.377595] pci 0000:00:02.1: BAR 0: set to [mem 0x40000000-0x400000ff] (PCI address [0x40000000-0x400000ff]
[    7.387431] pci 0000:00:09.0: PCI bridge to [bus 05-05]
[    7.392678] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    7.398770] pci 0000:00:09.0:   bridge window [mem 0xda000000-0xda0fffff]
[    7.405574] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    7.411687] pci 0000:00:0b.0: PCI bridge to [bus 04-04]
[    7.416903] pci 0000:00:0b.0:   bridge window [io  disabled]
[    7.422587] pci 0000:00:0b.0:   bridge window [mem disabled]
[    7.428242] pci 0000:00:0b.0:   bridge window [mem pref disabled]
[    7.434359] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    7.439574] pci 0000:00:0c.0:   bridge window [io  disabled]
[    7.445251] pci 0000:00:0c.0:   bridge window [mem disabled]
[    7.450927] pci 0000:00:0c.0:   bridge window [mem pref disabled]
[    7.457020] pci 0000:00:0d.0: PCI bridge to [bus 02-02]
[    7.462258] pci 0000:00:0d.0:   bridge window [io  disabled]
[    7.467914] pci 0000:00:0d.0:   bridge window [mem disabled]
[    7.473588] pci 0000:00:0d.0:   bridge window [mem pref disabled]
[    7.479688] pci 0000:01:00.0: BAR 6: assigned [mem 0xd8000000-0xd801ffff pref]
[    7.486924] pci 0000:00:0e.0: PCI bridge to [bus 01-01]
[    7.492163] pci 0000:00:0e.0:   bridge window [io  0xb000-0xbfff]
[    7.498255] pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
[    7.505060] pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    7.512836] pci 0000:00:09.0: setting latency timer to 64
[    7.518245] pci 0000:00:0b.0: setting latency timer to 64
[    7.523681] pci 0000:00:0c.0: setting latency timer to 64
[    7.529096] pci 0000:00:0d.0: setting latency timer to 64
[    7.534533] pci 0000:00:0e.0: setting latency timer to 64
[    7.539930] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    7.545521] pci_bus 0000:00: resource 5 [mem 0x40000000-0xfcffffffff]
[    7.551976] pci_bus 0000:00: resource 6 [mem 0xfeb00000-0xfec0ffff]
[    7.558232] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
[    7.564518] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    7.570099] pci_bus 0000:05: resource 1 [mem 0xda000000-0xda0fffff]
[    7.576354] pci_bus 0000:05: resource 4 [io  0x0000-0xffff]
[    7.581946] pci_bus 0000:05: resource 5 [mem 0x40000000-0xfcffffffff]
[    7.588374] pci_bus 0000:05: resource 6 [mem 0xfeb00000-0xfec0ffff]
[    7.594662] pci_bus 0000:05: resource 7 [mem 0x000a0000-0x000bffff]
[    7.600943] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
[    7.606506] pci_bus 0000:01: resource 1 [mem 0xd8000000-0xd9ffffff]
[    7.612792] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
[    7.620024] initcall pcibios_assign_resources+0x0/0x74 returned 0 after 243559 usecs
[    7.627758] calling  sysctl_core_init+0x0/0x38 @ 1
[    7.632676] initcall sysctl_core_init+0x0/0x38 returned 0 after 101 usecs
[    7.639458] calling  inet_init+0x0/0x1f2 @ 1
[    7.643766] NET: Registered protocol family 2
[    7.648643] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    7.657062] IPv4 FIB: Using LC-trie version 0.409
[    7.662874] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    7.672311] TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
[    7.685032] TCP: Hash tables configured (established 131072 bind 65536)
[    7.691716] TCP reno registered
[    7.695264] initcall inet_init+0x0/0x1f2 returned 0 after 50302 usecs
[    7.701725] calling  af_unix_init+0x0/0x55 @ 1
[    7.706170] NET: Registered protocol family 1
[    7.710580] initcall af_unix_init+0x0/0x55 returned 0 after 4305 usecs
[    7.717105] calling  populate_rootfs+0x0/0xd7 @ 1
[    7.722185] initcall populate_rootfs+0x0/0xd7 returned 0 after 345 usecs
[    7.728880] calling  pci_iommu_init+0x0/0x31 @ 1
[    7.733525] initcall pci_iommu_init+0x0/0x31 returned 0 after 1 usecs
[    7.739957] calling  calgary_fixup_tce_spaces+0x0/0xf9 @ 1
[    7.745466] initcall calgary_fixup_tce_spaces+0x0/0xf9 returned -19 after 1 usecs
[    7.752958] calling  i8259A_init_sysfs+0x0/0x22 @ 1
[    7.757829] Registering sysdev class 'i8259'
[    7.762221] Registering sys device of class 'i8259'
[    7.767100] Registering sys device 'i82590'
[    7.771314] initcall i8259A_init_sysfs+0x0/0x22 returned 0 after 13164 usecs
[    7.778350] calling  vsyscall_init+0x0/0x33 @ 1
[    7.782944] initcall vsyscall_init+0x0/0x33 returned 0 after 39 usecs
[    7.789374] calling  sbf_init+0x0/0xe9 @ 1
[    7.793496] initcall sbf_init+0x0/0xe9 returned 0 after 1 usecs
[    7.799410] calling  i8237A_init_sysfs+0x0/0x22 @ 1
[    7.804346] Registering sysdev class 'i8237'
[    7.808628] Registering sys device of class 'i8237'
[    7.813529] Registering sys device 'i82370'
[    7.817725] initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 13067 usecs
[    7.824790] calling  add_rtc_cmos+0x0/0xa9 @ 1
[    7.829233] initcall add_rtc_cmos+0x0/0xa9 returned 0 after 4 usecs
[    7.835522] calling  cache_sysfs_init+0x0/0x85 @ 1
[    7.840824] initcall cache_sysfs_init+0x0/0x85 returned 0 after 438 usecs
[    7.847607] calling  mcheck_init_device+0x0/0x12e @ 1
[    7.852685] Registering sysdev class 'machinecheck'
[    7.857577] Registering sys device of class 'machinecheck'
[    7.863086] Registering sys device 'machinecheck0'
[    7.868017] Registering sys device of class 'machinecheck'
[    7.873529] Registering sys device 'machinecheck1'
[    7.878426] device: 'mcelog': device_add
[    7.882521] initcall mcheck_init_device+0x0/0x12e returned 0 after 29137 usecs
[    7.889736] calling  threshold_init_device+0x0/0xad @ 1
[    7.894987] initcall threshold_init_device+0x0/0xad returned 0 after 2 usecs
[    7.902047] calling  inject_init+0x0/0x49 @ 1
[    7.906433] Machine check injector initialized
[    7.910905] initcall inject_init+0x0/0x49 returned 0 after 4389 usecs
[    7.917340] calling  thermal_throttle_init_device+0x0/0xa5 @ 1
[    7.923239] initcall thermal_throttle_init_device+0x0/0xa5 returned 0 after 1 usecs
[    7.930906] calling  ioapic_init_sysfs+0x0/0xb6 @ 1
[    7.935775] Registering sysdev class 'ioapic'
[    7.940175] Registering sys device of class 'ioapic'
[    7.945140] Registering sys device 'ioapic0'
[    7.949421] initcall ioapic_init_sysfs+0x0/0xb6 returned 0 after 13327 usecs
[    7.956491] calling  microcode_init+0x0/0x12a @ 1
[    7.961249] microcode: no support for this CPU vendor
[    7.966294] initcall microcode_init+0x0/0x12a returned -19 after 4928 usecs
[    7.973269] calling  audit_classes_init+0x0/0xaf @ 1
[    7.978240] initcall audit_classes_init+0x0/0xaf returned 0 after 13 usecs
[    7.985126] calling  pt_dump_init+0x0/0x2b @ 1
[    7.989587] initcall pt_dump_init+0x0/0x2b returned 0 after 21 usecs
[    7.995959] calling  crypto_fpu_module_init+0x0/0x12 @ 1
[    8.001363] initcall crypto_fpu_module_init+0x0/0x12 returned 0 after 37 usecs
[    8.008574] calling  aes_init+0x0/0x12 @ 1
[    8.012992] initcall aes_init+0x0/0x12 returned 0 after 279 usecs
[    8.013011] cryptomgr_test used greatest stack depth: 6512 bytes left
[    8.025532] calling  init+0x0/0x12 @ 1
[    8.029566] initcall init+0x0/0x12 returned 0 after 272 usecs
[    8.029570] cryptomgr_test used greatest stack depth: 6192 bytes left
[    8.041825] calling  init+0x0/0x12 @ 1
[    8.045710] initcall init+0x0/0x12 returned 0 after 126 usecs
[    8.051471] calling  aesni_init+0x0/0x142 @ 1
[    8.055828] Intel AES-NI instructions are not detected.
[    8.061074] initcall aesni_init+0x0/0x142 returned -19 after 5118 usecs
[    8.067683] calling  crc32c_intel_mod_init+0x0/0x20 @ 1
[    8.072930] initcall crc32c_intel_mod_init+0x0/0x20 returned -19 after 1 usecs
[    8.080164] calling  init_vdso_vars+0x0/0x20a @ 1
[    8.084882] initcall init_vdso_vars+0x0/0x20a returned 0 after 18 usecs
[    8.091509] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    8.096326] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 31 usecs
[    8.103042] calling  sysenter_setup+0x0/0x287 @ 1
[    8.107749] initcall sysenter_setup+0x0/0x287 returned 0 after 6 usecs
[    8.114294] calling  init_sched_debug_procfs+0x0/0x2c @ 1
[    8.119764] initcall init_sched_debug_procfs+0x0/0x2c returned 0 after 76 usecs
[    8.127086] calling  proc_schedstat_init+0x0/0x22 @ 1
[    8.132193] initcall proc_schedstat_init+0x0/0x22 returned 0 after 42 usecs
[    8.139149] calling  proc_execdomains_init+0x0/0x22 @ 1
[    8.144439] initcall proc_execdomains_init+0x0/0x22 returned 0 after 42 usecs
[    8.151589] calling  ioresources_init+0x0/0x3c @ 1
[    8.156467] initcall ioresources_init+0x0/0x3c returned 0 after 84 usecs
[    8.163184] calling  uid_cache_init+0x0/0x8a @ 1
[    8.167813] initcall uid_cache_init+0x0/0x8a returned 0 after 17 usecs
[    8.174355] calling  init_posix_timers+0x0/0x17a @ 1
[    8.179318] initcall init_posix_timers+0x0/0x17a returned 0 after 3 usecs
[    8.186116] calling  init_posix_cpu_timers+0x0/0xcc @ 1
[    8.191353] initcall init_posix_cpu_timers+0x0/0xcc returned 0 after 1 usecs
[    8.198394] calling  nsproxy_cache_init+0x0/0x2d @ 1
[    8.203384] initcall nsproxy_cache_init+0x0/0x2d returned 0 after 3 usecs
[    8.210184] calling  create_proc_profile+0x0/0x2a6 @ 1
[    8.215317] initcall create_proc_profile+0x0/0x2a6 returned 0 after 2 usecs
[    8.222291] calling  timekeeping_init_device+0x0/0x22 @ 1
[    8.227681] Registering sysdev class 'timekeeping'
[    8.232602] Registering sys device of class 'timekeeping'
[    8.238037] Registering sys device 'timekeeping0'
[    8.242830] initcall timekeeping_init_device+0x0/0x22 returned 0 after 14788 usecs
[    8.250405] calling  init_clocksource_sysfs+0x0/0x50 @ 1
[    8.255710] Registering sysdev class 'clocksource'
[    8.260596] Registering sys device of class 'clocksource'
[    8.266013] Registering sys device 'clocksource0'
[    8.270804] initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 14733 usecs
[    8.278277] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    8.283654] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 43 usecs
[    8.290888] calling  init_tstats_procfs+0x0/0x2c @ 1
[    8.295892] initcall init_tstats_procfs+0x0/0x2c returned 0 after 42 usecs
[    8.302778] calling  lockdep_proc_init+0x0/0x7c @ 1
[    8.307820] initcall lockdep_proc_init+0x0/0x7c returned 0 after 164 usecs
[    8.314704] calling  futex_init+0x0/0x7d @ 1
[    8.318977] initcall futex_init+0x0/0x7d returned 0 after 7 usecs
[    8.325089] calling  init_rttest+0x0/0x150 @ 1
[    8.329536] Registering sysdev class 'rttest'
[    8.334076] Registering sys device of class 'rttest'
[    8.339049] Registering sys device 'rttest0'
[    8.343512] Registering sys device of class 'rttest'
[    8.348478] Registering sys device 'rttest1'
[    8.352974] Registering sys device of class 'rttest'
[    8.357943] Registering sys device 'rttest2'
[    8.362433] Registering sys device of class 'rttest'
[    8.367426] Registering sys device 'rttest3'
[    8.371869] Registering sys device of class 'rttest'
[    8.376836] Registering sys device 'rttest4'
[    8.381325] Registering sys device of class 'rttest'
[    8.386292] Registering sys device 'rttest5'
[    8.390733] Registering sys device of class 'rttest'
[    8.395702] Registering sys device 'rttest6'
[    8.400152] Registering sys device of class 'rttest'
[    8.405125] Registering sys device 'rttest7'
[    8.409452] Initializing RT-Tester: OK
[    8.413225] initcall init_rttest+0x0/0x150 returned 0 after 81724 usecs
[    8.419832] calling  proc_dma_init+0x0/0x22 @ 1
[    8.424433] initcall proc_dma_init+0x0/0x22 returned 0 after 44 usecs
[    8.430885] calling  kallsyms_init+0x0/0x25 @ 1
[    8.435460] initcall kallsyms_init+0x0/0x25 returned 0 after 41 usecs
[    8.441917] calling  crash_save_vmcoreinfo_init+0x0/0x46d @ 1
[    8.447680] initcall crash_save_vmcoreinfo_init+0x0/0x46d returned 0 after 25 usecs
[    8.455350] calling  crash_notes_memory_init+0x0/0x37 @ 1
[    8.460768] initcall crash_notes_memory_init+0x0/0x37 returned 0 after 8 usecs
[    8.467984] calling  pid_namespaces_init+0x0/0x2d @ 1
[    8.473062] initcall pid_namespaces_init+0x0/0x2d returned 0 after 3 usecs
[    8.479926] calling  ikconfig_init+0x0/0x3a @ 1
[    8.484541] initcall ikconfig_init+0x0/0x3a returned 0 after 58 usecs
[    8.490998] calling  audit_init+0x0/0x153 @ 1
[    8.495356] audit: initializing netlink socket (disabled)
[    8.500844] type=2000 audit(1274507282.499:1): initialized
[    8.506331] initcall audit_init+0x0/0x153 returned 0 after 10716 usecs
[    8.512874] calling  audit_tree_init+0x0/0x49 @ 1
[    8.517582] initcall audit_tree_init+0x0/0x49 returned 0 after 4 usecs
[    8.524123] calling  hung_task_init+0x0/0x53 @ 1
[    8.528841] initcall hung_task_init+0x0/0x53 returned 0 after 92 usecs
[    8.535377] calling  rcu_torture_init+0x0/0x7ff @ 1
[    8.540293] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3
[    8.558764] initcall rcu_torture_init+0x0/0x7ff returned 0 after 18062 usecs
[    8.565864] calling  rcuclassic_trace_init+0x0/0xf8 @ 1
[    8.571214] initcall rcuclassic_trace_init+0x0/0xf8 returned 0 after 108 usecs
[    8.578423] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    8.583618] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 109 usecs
[    8.590670] calling  init_lstats_procfs+0x0/0x25 @ 1
[    8.595712] initcall init_lstats_procfs+0x0/0x25 returned 0 after 79 usecs
[    8.602596] calling  perf_event_sysfs_init+0x0/0x19 @ 1
[    8.607834] initcall perf_event_sysfs_init+0x0/0x19 returned 0 after 17 usecs
[    8.614981] calling  init_per_zone_wmark_min+0x0/0x67 @ 1
[    8.620447] initcall init_per_zone_wmark_min+0x0/0x67 returned 0 after 55 usecs
[    8.627745] calling  kswapd_init+0x0/0x7c @ 1
[    8.632993] initcall kswapd_init+0x0/0x7c returned 0 after 835 usecs
[    8.639343] calling  setup_vmstat+0x0/0xe6 @ 1
[    8.644105] initcall setup_vmstat+0x0/0xe6 returned 0 after 214 usecs
[    8.650560] calling  mm_sysfs_init+0x0/0x29 @ 1
[    8.655100] initcall mm_sysfs_init+0x0/0x29 returned 0 after 15 usecs
[    8.661559] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    8.666472] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 42 usecs
[    8.673278] calling  hugetlb_init+0x0/0x45b @ 1
[    8.677817] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    8.684351] initcall hugetlb_init+0x0/0x45b returned 0 after 6385 usecs
[    8.690974] calling  ksm_init+0x0/0x19c @ 1
[    8.695304] initcall ksm_init+0x0/0x19c returned 0 after 145 usecs
[    8.701494] calling  fasync_init+0x0/0x2a @ 1
[    8.705849] initcall fasync_init+0x0/0x2a returned 0 after 2 usecs
[    8.712040] calling  proc_filesystems_init+0x0/0x22 @ 1
[    8.717311] initcall proc_filesystems_init+0x0/0x22 returned 0 after 49 usecs
[    8.724465] calling  dnotify_init+0x0/0x80 @ 1
[    8.728961] initcall dnotify_init+0x0/0x80 returned 0 after 50 usecs
[    8.735339] calling  inotify_setup+0x0/0x12 @ 1
[    8.739864] initcall inotify_setup+0x0/0x12 returned 0 after 1 usecs
[    8.746299] calling  inotify_user_setup+0x0/0x70 @ 1
[    8.751283] initcall inotify_user_setup+0x0/0x70 returned 0 after 3 usecs
[    8.758059] calling  aio_setup+0x0/0xc9 @ 1
[    8.762518] initcall aio_setup+0x0/0xc9 returned 0 after 251 usecs
[    8.768687] calling  proc_locks_init+0x0/0x22 @ 1
[    8.773474] initcall proc_locks_init+0x0/0x22 returned 0 after 11 usecs
[    8.780107] calling  init_sys32_ioctl+0x0/0x28 @ 1
[    8.784993] initcall init_sys32_ioctl+0x0/0x28 returned 0 after 95 usecs
[    8.791707] calling  init_mbcache+0x0/0x14 @ 1
[    8.796148] initcall init_mbcache+0x0/0x14 returned 0 after 3 usecs
[    8.802427] calling  proc_cmdline_init+0x0/0x22 @ 1
[    8.807309] initcall proc_cmdline_init+0x0/0x22 returned 0 after 10 usecs
[    8.814110] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    8.818991] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 10 usecs
[    8.825794] calling  proc_devices_init+0x0/0x22 @ 1
[    8.830693] initcall proc_devices_init+0x0/0x22 returned 0 after 10 usecs
[    8.837475] calling  proc_interrupts_init+0x0/0x22 @ 1
[    8.842645] initcall proc_interrupts_init+0x0/0x22 returned 0 after 10 usecs
[    8.849684] calling  proc_loadavg_init+0x0/0x22 @ 1
[    8.854596] initcall proc_loadavg_init+0x0/0x22 returned 0 after 10 usecs
[    8.861397] calling  proc_meminfo_init+0x0/0x22 @ 1
[    8.866279] initcall proc_meminfo_init+0x0/0x22 returned 0 after 10 usecs
[    8.873080] calling  proc_stat_init+0x0/0x22 @ 1
[    8.877700] initcall proc_stat_init+0x0/0x22 returned 0 after 10 usecs
[    8.884243] calling  proc_uptime_init+0x0/0x22 @ 1
[    8.889037] initcall proc_uptime_init+0x0/0x22 returned 0 after 9 usecs
[    8.895666] calling  proc_version_init+0x0/0x22 @ 1
[    8.900566] initcall proc_version_init+0x0/0x22 returned 0 after 10 usecs
[    8.907346] calling  proc_softirqs_init+0x0/0x22 @ 1
[    8.912343] initcall proc_softirqs_init+0x0/0x22 returned 0 after 10 usecs
[    8.919209] calling  proc_kmsg_init+0x0/0x25 @ 1
[    8.923864] initcall proc_kmsg_init+0x0/0x25 returned 0 after 10 usecs
[    8.930403] calling  proc_page_init+0x0/0x42 @ 1
[    8.935032] initcall proc_page_init+0x0/0x42 returned 0 after 19 usecs
[    8.941574] calling  configfs_init+0x0/0xb3 @ 1
[    8.946132] initcall configfs_init+0x0/0xb3 returned 0 after 32 usecs
[    8.952590] calling  init_devpts_fs+0x0/0x4c @ 1
[    8.957353] initcall init_devpts_fs+0x0/0x4c returned 0 after 149 usecs
[    8.963988] calling  init_dlm+0x0/0x98 @ 1
[    8.968316] device: 'dlm-control': device_add
[    8.972768] device: 'dlm-monitor': device_add
[    8.977206] device: 'dlm_plock': device_add
[    8.981480] DLM (built May 21 2010 20:45:26) installed
[    8.986616] initcall init_dlm+0x0/0x98 returned 0 after 18097 usecs
[    8.992899] calling  init_reiserfs_fs+0x0/0x6b @ 1
[    8.997717] initcall init_reiserfs_fs+0x0/0x6b returned 0 after 26 usecs
[    9.004435] calling  init_ext3_fs+0x0/0x72 @ 1
[    9.008902] initcall init_ext3_fs+0x0/0x72 returned 0 after 22 usecs
[    9.015267] calling  init_ext2_fs+0x0/0x71 @ 1
[    9.019719] initcall init_ext2_fs+0x0/0x71 returned 0 after 13 usecs
[    9.026082] calling  init_ext4_fs+0x0/0xea @ 1
[    9.030619] initcall init_ext4_fs+0x0/0xea returned 0 after 76 usecs
[    9.036967] calling  journal_init+0x0/0xca @ 1
[    9.041479] initcall journal_init+0x0/0xca returned 0 after 41 usecs
[    9.047826] calling  journal_init+0x0/0xa0 @ 1
[    9.052368] initcall journal_init+0x0/0xa0 returned 0 after 73 usecs
[    9.058710] calling  init_ramfs_fs+0x0/0x12 @ 1
[    9.063270] initcall init_ramfs_fs+0x0/0x12 returned 0 after 3 usecs
[    9.069613] calling  init_hugetlbfs_fs+0x0/0x98 @ 1
[    9.074696] initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after 175 usecs
[    9.081588] calling  init_fat_fs+0x0/0x4f @ 1
[    9.085949] initcall init_fat_fs+0x0/0x4f returned 0 after 3 usecs
[    9.092141] calling  init_vfat_fs+0x0/0x12 @ 1
[    9.096582] initcall init_vfat_fs+0x0/0x12 returned 0 after 3 usecs
[    9.102862] calling  init_iso9660_fs+0x0/0x71 @ 1
[    9.107583] initcall init_iso9660_fs+0x0/0x71 returned 0 after 21 usecs
[    9.114217] calling  init_nls_cp437+0x0/0x12 @ 1
[    9.118851] initcall init_nls_cp437+0x0/0x12 returned 0 after 15 usecs
[    9.125396] calling  init_nls_cp850+0x0/0x12 @ 1
[    9.130029] initcall init_nls_cp850+0x0/0x12 returned 0 after 3 usecs
[    9.136460] calling  init_nls_cp852+0x0/0x12 @ 1
[    9.141103] initcall init_nls_cp852+0x0/0x12 returned 0 after 2 usecs
[    9.147535] calling  init_nls_cp857+0x0/0x12 @ 1
[    9.152171] initcall init_nls_cp857+0x0/0x12 returned 0 after 2 usecs
[    9.158603] calling  init_nls_cp860+0x0/0x12 @ 1
[    9.163248] initcall init_nls_cp860+0x0/0x12 returned 0 after 2 usecs
[    9.169681] calling  init_nls_cp861+0x0/0x12 @ 1
[    9.174323] initcall init_nls_cp861+0x0/0x12 returned 0 after 2 usecs
[    9.180776] calling  init_nls_cp862+0x0/0x12 @ 1
[    9.185390] initcall init_nls_cp862+0x0/0x12 returned 0 after 2 usecs
[    9.191843] calling  init_nls_cp863+0x0/0x12 @ 1
[    9.196458] initcall init_nls_cp863+0x0/0x12 returned 0 after 2 usecs
[    9.202910] calling  init_nls_cp864+0x0/0x12 @ 1
[    9.207525] initcall init_nls_cp864+0x0/0x12 returned 0 after 2 usecs
[    9.213979] calling  init_nls_cp866+0x0/0x12 @ 1
[    9.218591] initcall init_nls_cp866+0x0/0x12 returned 0 after 2 usecs
[    9.225047] calling  init_nls_cp869+0x0/0x12 @ 1
[    9.229659] initcall init_nls_cp869+0x0/0x12 returned 0 after 2 usecs
[    9.236114] calling  init_nls_cp874+0x0/0x12 @ 1
[    9.240748] initcall init_nls_cp874+0x0/0x12 returned 0 after 2 usecs
[    9.247178] calling  init_nls_cp936+0x0/0x12 @ 1
[    9.251823] initcall init_nls_cp936+0x0/0x12 returned 0 after 2 usecs
[    9.258255] calling  init_nls_cp949+0x0/0x12 @ 1
[    9.262898] initcall init_nls_cp949+0x0/0x12 returned 0 after 2 usecs
[    9.269331] calling  init_nls_cp1250+0x0/0x12 @ 1
[    9.274062] initcall init_nls_cp1250+0x0/0x12 returned 0 after 2 usecs
[    9.280601] calling  init_nls_cp1251+0x0/0x12 @ 1
[    9.285300] initcall init_nls_cp1251+0x0/0x12 returned 0 after 2 usecs
[    9.291840] calling  init_nls_ascii+0x0/0x12 @ 1
[    9.296454] initcall init_nls_ascii+0x0/0x12 returned 0 after 2 usecs
[    9.302910] calling  init_nls_iso8859_1+0x0/0x12 @ 1
[    9.307876] initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 2 usecs
[    9.314678] calling  init_nls_iso8859_3+0x0/0x12 @ 1
[    9.319639] initcall init_nls_iso8859_3+0x0/0x12 returned 0 after 2 usecs
[    9.326439] calling  init_nls_iso8859_5+0x0/0x12 @ 1
[    9.331431] initcall init_nls_iso8859_5+0x0/0x12 returned 0 after 2 usecs
[    9.338206] calling  init_nls_iso8859_9+0x0/0x12 @ 1
[    9.343196] initcall init_nls_iso8859_9+0x0/0x12 returned 0 after 2 usecs
[    9.349975] calling  init_nls_iso8859_13+0x0/0x12 @ 1
[    9.355051] initcall init_nls_iso8859_13+0x0/0x12 returned 0 after 2 usecs
[    9.361939] calling  init_nls_iso8859_15+0x0/0x12 @ 1
[    9.366985] initcall init_nls_iso8859_15+0x0/0x12 returned 0 after 2 usecs
[    9.373872] calling  init_nls_koi8_r+0x0/0x12 @ 1
[    9.378571] initcall init_nls_koi8_r+0x0/0x12 returned 0 after 2 usecs
[    9.385113] calling  init_nls_koi8_u+0x0/0x12 @ 1
[    9.389813] initcall init_nls_koi8_u+0x0/0x12 returned 0 after 2 usecs
[    9.396353] calling  init_nls_koi8_ru+0x0/0x48 @ 1
[    9.401160] initcall init_nls_koi8_ru+0x0/0x48 returned 0 after 3 usecs
[    9.407765] calling  init_nls_utf8+0x0/0x29 @ 1
[    9.412322] initcall init_nls_utf8+0x0/0x29 returned 0 after 3 usecs
[    9.418667] calling  init_autofs_fs+0x0/0x12 @ 1
[    9.423304] initcall init_autofs_fs+0x0/0x12 returned 0 after 3 usecs
[    9.429736] calling  init_udf_fs+0x0/0x63 @ 1
[    9.434120] initcall init_udf_fs+0x0/0x63 returned 0 after 4 usecs
[    9.440312] calling  init_xfs_fs+0x0/0xb8 @ 1
[    9.444661] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
[    9.455238] SGI XFS Quota Management subsystem
[    9.459775] initcall init_xfs_fs+0x0/0xb8 returned 0 after 14756 usecs
[    9.466324] calling  init_nilfs_fs+0x0/0x91 @ 1
[    9.470881] initcall init_nilfs_fs+0x0/0x91 returned 0 after 8 usecs
[    9.477229] calling  ipc_init+0x0/0x2f @ 1
[    9.481397] msgmni has been set to 1800
[    9.485350] initcall ipc_init+0x0/0x2f returned 0 after 3907 usecs
[    9.491543] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    9.496436] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 183 usecs
[    9.503155] calling  crypto_wq_init+0x0/0x32 @ 1
[    9.507978] initcall crypto_wq_init+0x0/0x32 returned 0 after 203 usecs
[    9.514601] calling  crypto_algapi_init+0x0/0xd @ 1
[    9.519547] initcall crypto_algapi_init+0x0/0xd returned 0 after 71 usecs
[    9.526344] calling  skcipher_module_init+0x0/0x36 @ 1
[    9.531498] initcall skcipher_module_init+0x0/0x36 returned 0 after 1 usecs
[    9.538452] calling  chainiv_module_init+0x0/0x12 @ 1
[    9.543533] initcall chainiv_module_init+0x0/0x12 returned 0 after 5 usecs
[    9.550436] calling  eseqiv_module_init+0x0/0x12 @ 1
[    9.555401] initcall eseqiv_module_init+0x0/0x12 returned 0 after 3 usecs
[    9.562202] calling  seqiv_module_init+0x0/0x12 @ 1
[    9.567076] initcall seqiv_module_init+0x0/0x12 returned 0 after 3 usecs
[    9.573790] calling  hmac_module_init+0x0/0x12 @ 1
[    9.578584] initcall hmac_module_init+0x0/0x12 returned 0 after 3 usecs
[    9.585212] calling  vmac_module_init+0x0/0x12 @ 1
[    9.590021] initcall vmac_module_init+0x0/0x12 returned 0 after 19 usecs
[    9.596717] calling  crypto_xcbc_module_init+0x0/0x12 @ 1
[    9.602143] initcall crypto_xcbc_module_init+0x0/0x12 returned 0 after 3 usecs
[    9.609354] calling  md5_mod_init+0x0/0x12 @ 1
[    9.614001] initcall md5_mod_init+0x0/0x12 returned 0 after 170 usecs
[    9.614005] cryptomgr_test used greatest stack depth: 6000 bytes left
[    9.626883] calling  rmd256_mod_init+0x0/0x12 @ 1
[    9.631783] initcall rmd256_mod_init+0x0/0x12 returned 0 after 174 usecs
[    9.638476] calling  rmd320_mod_init+0x0/0x12 @ 1
[    9.643373] initcall rmd320_mod_init+0x0/0x12 returned 0 after 160 usecs
[    9.650152] calling  sha1_generic_mod_init+0x0/0x12 @ 1
[    9.655532] initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 152 usecs
[    9.662782] calling  sha256_generic_mod_init+0x0/0x3f @ 1
[    9.668519] initcall sha256_generic_mod_init+0x0/0x3f returned 0 after 326 usecs
[    9.675928] calling  sha512_generic_mod_init+0x0/0x3f @ 1
[    9.681671] initcall sha512_generic_mod_init+0x0/0x3f returned 0 after 320 usecs
[    9.689054] calling  wp512_mod_init+0x0/0x64 @ 1
[    9.694259] initcall wp512_mod_init+0x0/0x64 returned 0 after 511 usecs
[    9.700970] calling  crypto_ecb_module_init+0x0/0x12 @ 1
[    9.706282] initcall crypto_ecb_module_init+0x0/0x12 returned 0 after 4 usecs
[    9.713425] calling  crypto_cbc_module_init+0x0/0x12 @ 1
[    9.718736] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 3 usecs
[    9.725878] calling  crypto_pcbc_module_init+0x0/0x12 @ 1
[    9.731293] initcall crypto_pcbc_module_init+0x0/0x12 returned 0 after 3 usecs
[    9.738506] calling  crypto_module_init+0x0/0x12 @ 1
[    9.743494] initcall crypto_module_init+0x0/0x12 returned 0 after 3 usecs
[    9.750295] calling  crypto_ctr_module_init+0x0/0x3e @ 1
[    9.755605] initcall crypto_ctr_module_init+0x0/0x3e returned 0 after 4 usecs
[    9.762747] calling  crypto_gcm_module_init+0x0/0xab @ 1
[    9.768064] initcall crypto_gcm_module_init+0x0/0xab returned 0 after 8 usecs
[    9.775211] calling  crypto_ccm_module_init+0x0/0x60 @ 1
[    9.780539] initcall crypto_ccm_module_init+0x0/0x60 returned 0 after 6 usecs
[    9.787664] calling  cryptd_init+0x0/0x109 @ 1
[    9.792139] initcall cryptd_init+0x0/0x109 returned 0 after 9 usecs
[    9.798394] calling  des_generic_mod_init+0x0/0x3f @ 1
[    9.803968] initcall des_generic_mod_init+0x0/0x3f returned 0 after 405 usecs
[    9.811168] calling  fcrypt_mod_init+0x0/0x12 @ 1
[    9.815978] alg: No test for fcrypt (fcrypt-generic)
[    9.821038] initcall fcrypt_mod_init+0x0/0x12 returned 0 after 5043 usecs
[    9.827819] calling  blowfish_mod_init+0x0/0x12 @ 1
[    9.833616] initcall blowfish_mod_init+0x0/0x12 returned 0 after 839 usecs
[    9.840510] calling  twofish_mod_init+0x0/0x12 @ 1
[    9.845554] initcall twofish_mod_init+0x0/0x12 returned 0 after 242 usecs
[    9.852437] calling  serpent_mod_init+0x0/0x3f @ 1
[    9.857654] initcall serpent_mod_init+0x0/0x3f returned 0 after 411 usecs
[    9.864474] calling  aes_init+0x0/0x12 @ 1
[    9.868814] initcall aes_init+0x0/0x12 returned 0 after 231 usecs
[    9.874919] calling  camellia_init+0x0/0x12 @ 1
[    9.879643] initcall camellia_init+0x0/0x12 returned 0 after 184 usecs
[    9.886254] calling  cast6_mod_init+0x0/0x12 @ 1
[    9.891073] initcall cast6_mod_init+0x0/0x12 returned 0 after 175 usecs
[    9.897682] calling  arc4_init+0x0/0x12 @ 1
[    9.902164] initcall arc4_init+0x0/0x12 returned 0 after 192 usecs
[    9.908342] calling  khazad_mod_init+0x0/0x12 @ 1
[    9.913266] initcall khazad_mod_init+0x0/0x12 returned 0 after 184 usecs
[    9.919956] calling  anubis_mod_init+0x0/0x12 @ 1
[    9.924945] initcall anubis_mod_init+0x0/0x12 returned 0 after 251 usecs
[    9.931727] calling  seed_init+0x0/0x12 @ 1
[    9.936088] initcall seed_init+0x0/0x12 returned 0 after 174 usecs
[    9.942303] calling  deflate_mod_init+0x0/0x12 @ 1
[    9.947875] initcall deflate_mod_init+0x0/0x12 returned 0 after 759 usecs
[    9.947880] cryptomgr_test used greatest stack depth: 5984 bytes left
[    9.961113] calling  zlib_mod_init+0x0/0x12 @ 1
[    9.966864] initcall zlib_mod_init+0x0/0x12 returned 0 after 1186 usecs
[    9.966869] cryptomgr_test used greatest stack depth: 5440 bytes left
[    9.979946] calling  michael_mic_init+0x0/0x12 @ 1
[    9.984951] initcall michael_mic_init+0x0/0x12 returned 0 after 192 usecs
[    9.991774] calling  crc32c_mod_init+0x0/0x12 @ 1
[    9.996678] initcall crc32c_mod_init+0x0/0x12 returned 0 after 190 usecs
[   10.003462] calling  lzo_mod_init+0x0/0x12 @ 1
[   10.008148] initcall lzo_mod_init+0x0/0x12 returned 0 after 237 usecs
[   10.014728] calling  krng_mod_init+0x0/0x12 @ 1
[   10.019368] alg: No test for stdrng (krng)
[   10.023582] initcall krng_mod_init+0x0/0x12 returned 0 after 4222 usecs
[   10.030207] calling  prng_mod_init+0x0/0x22 @ 1
[   10.049955] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[   10.055909] initcall prng_mod_init+0x0/0x22 returned 0 after 20675 usecs
[   10.062703] calling  ghash_mod_init+0x0/0x12 @ 1
[   10.067491] initcall ghash_mod_init+0x0/0x12 returned 0 after 162 usecs
[   10.074113] calling  proc_genhd_init+0x0/0x3c @ 1
[   10.078913] initcall proc_genhd_init+0x0/0x3c returned 0 after 100 usecs
[   10.085629] calling  bsg_init+0x0/0x12e @ 1
[   10.089811] device class 'bsg': registering
[   10.094089] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[   10.101492] initcall bsg_init+0x0/0x12e returned 0 after 11404 usecs
[   10.107843] calling  noop_init+0x0/0x14 @ 1
[   10.112068] io scheduler noop registered
[   10.115993] initcall noop_init+0x0/0x14 returned 0 after 3857 usecs
[   10.122272] calling  deadline_init+0x0/0x14 @ 1
[   10.126798] io scheduler deadline registered (default)
[   10.131955] initcall deadline_init+0x0/0x14 returned 0 after 5032 usecs
[   10.138556] calling  debug_objects_init_debugfs+0x0/0x64 @ 1
[   10.144280] initcall debug_objects_init_debugfs+0x0/0x64 returned 0 after 42 usecs
[   10.151861] calling  libcrc32c_mod_init+0x0/0x2c @ 1
[   10.156827] initcall libcrc32c_mod_init+0x0/0x2c returned 0 after 6 usecs
[   10.163629] calling  init_kmp+0x0/0x12 @ 1
[   10.167737] initcall init_kmp+0x0/0x12 returned 0 after 14 usecs
[   10.173752] calling  init_bm+0x0/0x12 @ 1
[   10.177761] initcall init_bm+0x0/0x12 returned 0 after 2 usecs
[   10.183606] calling  init_fsm+0x0/0x12 @ 1
[   10.187702] initcall init_fsm+0x0/0x12 returned 0 after 2 usecs
[   10.193633] calling  percpu_counter_startup+0x0/0x19 @ 1
[   10.198946] initcall percpu_counter_startup+0x0/0x19 returned 0 after 5 usecs
[   10.206087] calling  dynamic_debug_init+0x0/0x12c @ 1
[   10.212114] initcall dynamic_debug_init+0x0/0x12c returned 0 after 939 usecs
[   10.219156] calling  adp5588_gpio_init+0x0/0x14 @ 1
[   10.224060] bus: 'i2c': add driver adp5588-gpio
[   10.228641] i2c-core: driver [adp5588-gpio] registered
[   10.233800] initcall adp5588_gpio_init+0x0/0x14 returned 0 after 9513 usecs
[   10.240773] calling  cs5535_gpio_init+0x0/0x1e7 @ 1
[   10.245716] initcall cs5535_gpio_init+0x0/0x1e7 returned -19 after 67 usecs
[   10.252690] calling  pci_proc_init+0x0/0x6a @ 1
[   10.257575] initcall pci_proc_init+0x0/0x6a returned 0 after 350 usecs
[   10.264113] calling  ioapic_init+0x0/0x1b @ 1
[   10.268467] bus: 'pci': add driver ioapic
[   10.272592] initcall ioapic_init+0x0/0x1b returned 0 after 4024 usecs
[   10.279027] calling  pci_hotplug_init+0x0/0x4e @ 1
[   10.283838] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   10.289403] initcall pci_hotplug_init+0x0/0x4e returned 0 after 5437 usecs
[   10.296290] calling  cpcihp_generic_init+0x0/0x42a @ 1
[   10.301440] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
[   10.309168] cpcihp_generic: not configured, disabling.
[   10.314321] initcall cpcihp_generic_init+0x0/0x42a returned -22 after 12578 usecs
[   10.321806] initcall cpcihp_generic_init+0x0/0x42a returned with error code -22 
[   10.329191] calling  shpcd_init+0x0/0x62 @ 1
[   10.333495] bus: 'pci': add driver shpchp
[   10.337539] bus: 'pci': driver_probe_device: matched device 0000:00:0b.0 with driver shpchp
[   10.345900] bus: 'pci': really_probe: probing driver shpchp with device 0000:00:0b.0
[   10.353860] bus: 'pci': driver_probe_device: matched device 0000:00:0c.0 with driver shpchp
[   10.362225] bus: 'pci': really_probe: probing driver shpchp with device 0000:00:0c.0
[   10.370191] bus: 'pci': driver_probe_device: matched device 0000:00:0d.0 with driver shpchp
[   10.378529] bus: 'pci': really_probe: probing driver shpchp with device 0000:00:0d.0
[   10.386502] bus: 'pci': driver_probe_device: matched device 0000:00:0e.0 with driver shpchp
[   10.394911] bus: 'pci': really_probe: probing driver shpchp with device 0000:00:0e.0
[   10.402871] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   10.409568] initcall shpcd_init+0x0/0x62 returned 0 after 74294 usecs
[   10.416072] calling  acpiphp_init+0x0/0x5f @ 1
[   10.420531] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[   10.431503] initcall acpiphp_init+0x0/0x5f returned -19 after 10714 usecs
[   10.438279] calling  ibm_acpiphp_init+0x0/0x175 @ 1
[   10.463629] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[   10.470082] initcall ibm_acpiphp_init+0x0/0x175 returned -19 after 26272 usecs
[   10.477298] calling  pci_stub_init+0x0/0x139 @ 1
[   10.481938] bus: 'pci': add driver pci-stub
[   10.486206] pci-stub: invalid id string ""
[   10.490318] initcall pci_stub_init+0x0/0x139 returned 0 after 8185 usecs
[   10.497006] calling  platform_lcd_init+0x0/0x12 @ 1
[   10.501906] bus: 'platform': add driver platform-lcd
[   10.506905] initcall platform_lcd_init+0x0/0x12 returned 0 after 4886 usecs
[   10.513881] calling  progearbl_init+0x0/0x55 @ 1
[   10.518494] bus: 'platform': add driver progear-bl
[   10.523359] Registering platform device 'progear-bl'. Parent at platform
[   10.530071] device: 'progear-bl': device_add
[   10.534350] bus: 'platform': add device progear-bl
[   10.539220] bus: 'platform': driver_probe_device: matched device progear-bl with driver progear-bl
[   10.548191] bus: 'platform': really_probe: probing driver progear-bl with device progear-bl
[   10.556582] ALI M7101 PMU not found.
[   10.560188] initcall progearbl_init+0x0/0x55 returned 0 after 40713 usecs
[   10.566963] calling  cr_backlight_init+0x0/0x65 @ 1
[   10.571862] bus: 'platform': add driver cr_backlight
[   10.576862] Registering platform device 'cr_backlight'. Parent at platform
[   10.583753] device: 'cr_backlight': device_add
[   10.588201] bus: 'platform': add device cr_backlight
[   10.593238] bus: 'platform': driver_probe_device: matched device cr_backlight with driver cr_backlight
[   10.602549] bus: 'platform': really_probe: probing driver cr_backlight with device cr_backlight
[   10.611287] INTEL CARILLO RANCH LPC not found.
[   10.615739] Carillo Ranch Backlight Driver Initialized.
[   10.620977] initcall cr_backlight_init+0x0/0x65 returned 0 after 47963 usecs
[   10.628012] calling  max8925_backlight_init+0x0/0x12 @ 1
[   10.633345] bus: 'platform': add driver max8925-backlight
[   10.638780] initcall max8925_backlight_init+0x0/0x12 returned 0 after 5311 usecs
[   10.646186] calling  kb3886_init+0x0/0x3a @ 1
[   10.650560] initcall kb3886_init+0x0/0x3a returned -19 after 2 usecs
[   10.656907] calling  wm831x_backlight_init+0x0/0x12 @ 1
[   10.662156] bus: 'platform': add driver wm831x-backlight
[   10.667510] initcall wm831x_backlight_init+0x0/0x12 returned 0 after 5232 usecs
[   10.674832] calling  display_class_init+0x0/0x7e @ 1
[   10.679792] device class 'display': registering
[   10.684372] initcall display_class_init+0x0/0x7e returned 0 after 4469 usecs
[   10.691428] calling  arcfb_init+0x0/0x71 @ 1
[   10.695696] initcall arcfb_init+0x0/0x71 returned -6 after 1 usecs
[   10.701889] initcall arcfb_init+0x0/0x71 returned with error code -6 
[   10.708319] calling  cyber2000fb_init+0x0/0xd0 @ 1
[   10.713132] bus: 'pci': add driver CyberPro
[   10.717407] initcall cyber2000fb_init+0x0/0xd0 returned 0 after 4178 usecs
[   10.724294] calling  pm2fb_init+0x0/0x152 @ 1
[   10.728646] bus: 'pci': add driver pm2fb
[   10.732667] initcall pm2fb_init+0x0/0x152 returned 0 after 3924 usecs
[   10.739105] calling  pm3fb_init+0x0/0x10d @ 1
[   10.743483] bus: 'pci': add driver pm3fb
[   10.747482] initcall pm3fb_init+0x0/0x10d returned 0 after 3909 usecs
[   10.753932] calling  matroxfb_init+0x0/0x9a2 @ 1
[   10.758548] bus: 'pci': add driver matroxfb
[   10.762829] initcall matroxfb_init+0x0/0x9a2 returned 0 after 4177 usecs
[   10.769524] calling  i2c_matroxfb_init+0x0/0x2b @ 1
[   10.774425] initcall i2c_matroxfb_init+0x0/0x2b returned 0 after 1 usecs
[   10.781140] calling  rivafb_init+0x0/0x1d6 @ 1
[   10.785578] rivafb_setup START
[   10.788634] bus: 'pci': add driver rivafb
[   10.792949] initcall rivafb_init+0x0/0x1d6 returned 0 after 7193 usecs
[   10.799467] calling  atyfb_init+0x0/0x21f @ 1
[   10.803847] bus: 'pci': add driver atyfb
[   10.807865] initcall atyfb_init+0x0/0x21f returned 0 after 3927 usecs
[   10.814315] calling  aty128fb_init+0x0/0x140 @ 1
[   10.818929] bus: 'pci': add driver aty128fb
[   10.823214] initcall aty128fb_init+0x0/0x140 returned 0 after 4182 usecs
[   10.829906] calling  viafb_init+0x0/0x634 @ 1
[   10.834296] VIA Graphics Intergration Chipset framebuffer 2.4 initializing
[   10.841181] bus: 'pci': add driver viafb
[   10.845184] initcall viafb_init+0x0/0x634 returned 0 after 10635 usecs
[   10.851720] calling  savagefb_init+0x0/0x75 @ 1
[   10.856249] bus: 'pci': add driver savagefb
[   10.860557] initcall savagefb_init+0x0/0x75 returned 0 after 4204 usecs
[   10.867164] calling  gx1fb_init+0x0/0x12c @ 1
[   10.871546] bus: 'pci': add driver gx1fb
[   10.875550] initcall gx1fb_init+0x0/0x12c returned 0 after 3913 usecs
[   10.882001] calling  gxfb_init+0x0/0x82 @ 1
[   10.886184] bus: 'pci': add driver gxfb
[   10.890118] initcall gxfb_init+0x0/0x82 returned 0 after 3839 usecs
[   10.896379] calling  neofb_init+0x0/0x155 @ 1
[   10.900760] bus: 'pci': add driver neofb
[   10.904758] initcall neofb_init+0x0/0x155 returned 0 after 3908 usecs
[   10.911210] calling  tdfxfb_init+0x0/0x12d @ 1
[   10.915649] bus: 'pci': add driver tdfxfb
[   10.919739] initcall tdfxfb_init+0x0/0x12d returned 0 after 3997 usecs
[   10.926280] calling  vmlfb_init+0x0/0x96 @ 1
[   10.930562] vmlfb: initializing
[   10.933703] bus: 'pci': add driver vmlfb
[   10.937721] initcall vmlfb_init+0x0/0x96 returned 0 after 6995 usecs
[   10.944091] calling  s3fb_init+0x0/0x114 @ 1
[   10.948359] bus: 'pci': add driver s3fb
[   10.952293] initcall s3fb_init+0x0/0x114 returned 0 after 3839 usecs
[   10.958641] calling  arkfb_init+0x0/0x82 @ 1
[   10.962935] bus: 'pci': add driver arkfb
[   10.966933] initcall arkfb_init+0x0/0x82 returned 0 after 3907 usecs
[   10.973298] calling  hgafb_init+0x0/0x6b @ 1
[   10.977565] bus: 'platform': add driver hgafb
[   10.981984] Registering platform device 'hgafb.0'. Parent at platform
[   10.988420] device: 'hgafb.0': device_add
[   10.992463] bus: 'platform': add device hgafb.0
[   10.997092] bus: 'platform': driver_probe_device: matched device hgafb.0 with driver hgafb
[   11.005366] bus: 'platform': really_probe: probing driver hgafb with device hgafb.0
[   11.013072] hgafb: HGA card not detected.
[   11.017093] hgafb: probe of hgafb.0 failed with error -22
[   11.022517] initcall hgafb_init+0x0/0x6b returned 0 after 43894 usecs
[   11.028948] calling  sstfb_init+0x0/0x1c0 @ 1
[   11.033326] bus: 'pci': add driver sstfb
[   11.037357] initcall sstfb_init+0x0/0x1c0 returned 0 after 3940 usecs
[   11.043812] calling  metronomefb_init+0x0/0x12 @ 1
[   11.048597] bus: 'platform': add driver metronomefb
[   11.053568] initcall metronomefb_init+0x0/0x12 returned 0 after 4850 usecs
[   11.060451] calling  broadsheetfb_init+0x0/0x12 @ 1
[   11.065323] bus: 'platform': add driver broadsheetfb
[   11.070381] initcall broadsheetfb_init+0x0/0x12 returned 0 after 4935 usecs
[   11.077333] calling  s1d13xxxfb_init+0x0/0x2b @ 1
[   11.082061] bus: 'platform': add driver s1d13xxxfb
[   11.086928] initcall s1d13xxxfb_init+0x0/0x2b returned 0 after 4756 usecs
[   11.093732] calling  sm501fb_init+0x0/0x12 @ 1
[   11.098171] bus: 'platform': add driver sm501-fb
[   11.102897] initcall sm501fb_init+0x0/0x12 returned 0 after 4612 usecs
[   11.109418] calling  carminefb_init+0x0/0x39 @ 1
[   11.114057] bus: 'pci': add driver carminefb
[   11.118435] initcall carminefb_init+0x0/0x39 returned 0 after 4278 usecs
[   11.125149] calling  mb862xxfb_init+0x0/0x1b @ 1
[   11.129763] bus: 'pci': add driver mb862xxfb
[   11.134167] initcall mb862xxfb_init+0x0/0x1b returned 0 after 4298 usecs
[   11.140880] calling  acpi_reserve_resources+0x0/0xeb @ 1
[   11.146202] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 16 usecs
[   11.153437] calling  irqrouter_init_sysfs+0x0/0x38 @ 1
[   11.158568] Registering sysdev class 'irqrouter'
[   11.163259] Registering sys device of class 'irqrouter'
[   11.168489] Registering sys device 'irqrouter0'
[   11.173085] initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 14171 usecs
[   11.180401] calling  acpi_ac_init+0x0/0x45 @ 1
[   11.184946] bus: 'acpi': add driver ac
[   11.188872] initcall acpi_ac_init+0x0/0x45 returned 0 after 3939 usecs
[   11.195420] calling  acpi_button_init+0x0/0x56 @ 1
[   11.200264] bus: 'acpi': add driver button
[   11.204396] bus: 'acpi': driver_probe_device: matched device PNP0C0C:00 with driver button
[   11.212666] bus: 'acpi': really_probe: probing driver button with device PNP0C0C:00
[   11.220474] device: 'input0': device_add
[   11.224653] input: Power Button as /class/input/input0
[   11.229817] ACPI: Power Button [PWRB]
[   11.233512] driver: 'PNP0C0C:00': driver_bound: bound to device 'button'
[   11.240225] bus: 'acpi': really_probe: bound device PNP0C0C:00 to driver button
[   11.247626] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
[   11.255990] bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
[   11.263851] device: 'input1': device_add
[   11.267995] input: Power Button as /class/input/input1
[   11.273156] ACPI: Power Button [PWRF]
[   11.276835] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[   11.283637] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
[   11.291113] initcall acpi_button_init+0x0/0x56 returned 0 after 88759 usecs
[   11.298067] calling  acpi_video_init+0x0/0x17 @ 1
[   11.302839] bus: 'acpi': add driver video
[   11.307022] initcall acpi_video_init+0x0/0x17 returned 0 after 4129 usecs
[   11.313826] calling  acpi_container_init+0x0/0x4a @ 1
[   11.318871] bus: 'acpi': add driver container
[   11.346478] initcall acpi_container_init+0x0/0x4a returned 0 after 26958 usecs
[   11.353722] calling  acpi_memory_device_init+0x0/0x86 @ 1
[   11.359121] bus: 'acpi': add driver acpi_memhotplug
[   11.390629] initcall acpi_memory_device_init+0x0/0x86 returned 0 after 30763 usecs
[   11.398186] calling  acpi_battery_init+0x0/0x16 @ 1
[   11.403137] initcall acpi_battery_init+0x0/0x16 returned 0 after 49 usecs
[   11.403225] calling  1_acpi_battery_init_async+0x0/0x3c @ 105
[   11.403320] bus: 'acpi': add driver battery
[   11.403548] initcall 1_acpi_battery_init_async+0x0/0x3c returned 0 after 308 usecs
[   11.427404] calling  acpi_smb_hc_init+0x0/0x18 @ 1
[   11.432207] bus: 'acpi': add driver smbus_hc
[   11.436693] initcall acpi_smb_hc_init+0x0/0x18 returned 0 after 4385 usecs
[   11.443583] calling  acpi_sbs_init+0x0/0x4f @ 1
[   11.448113] bus: 'acpi': add driver sbs
[   11.452130] initcall acpi_sbs_init+0x0/0x4f returned 0 after 3923 usecs
[   11.458732] calling  rand_initialize+0x0/0x2c @ 1
[   11.463508] initcall rand_initialize+0x0/0x2c returned 0 after 48 usecs
[   11.470129] calling  tty_init+0x0/0xf5 @ 1
[   11.474236] device: 'tty': device_add
[   11.478024] device: 'console': device_add
[   11.482186] device: 'tty0': device_add
[   11.486029] device class 'vc': registering
[   11.490210] device: 'vcs': device_add
[   11.493953] device: 'vcsa': device_add
[   11.497778] device: 'vcs1': device_add
[   11.501608] device: 'vcsa1': device_add
[   11.505527] device: 'tty1': device_add
[   11.509377] device: 'tty2': device_add
[   11.513254] device: 'tty3': device_add
[   11.517096] device: 'tty4': device_add
[   11.520963] device: 'tty5': device_add
[   11.524831] device: 'tty6': device_add
[   11.528671] device: 'tty7': device_add
[   11.532540] device: 'tty8': device_add
[   11.536382] device: 'tty9': device_add
[   11.540262] device: 'tty10': device_add
[   11.544188] device: 'tty11': device_add
[   11.548120] device: 'tty12': device_add
[   11.552077] device: 'tty13': device_add
[   11.556026] device: 'tty14': device_add
[   11.559958] device: 'tty15': device_add
[   11.563914] device: 'tty16': device_add
[   11.567854] device: 'tty17': device_add
[   11.571816] device: 'tty18': device_add
[   11.575743] device: 'tty19': device_add
[   11.579679] device: 'tty20': device_add
[   11.583649] device: 'tty21': device_add
[   11.587574] device: 'tty22': device_add
[   11.591526] device: 'tty23': device_add
[   11.595455] device: 'tty24': device_add
[   11.599403] device: 'tty25': device_add
[   11.603356] device: 'tty26': device_add
[   11.607284] device: 'tty27': device_add
[   11.611239] device: 'tty28': device_add
[   11.615187] device: 'tty29': device_add
[   11.619119] device: 'tty30': device_add
[   11.623076] device: 'tty31': device_add
[   11.627021] device: 'tty32': device_add
[   11.630988] device: 'tty33': device_add
[   11.634912] device: 'tty34': device_add
[   11.638847] device: 'tty35': device_add
[   11.642819] device: 'tty36': device_add
[   11.646750] device: 'tty37': device_add
[   11.650709] device: 'tty38': device_add
[   11.654642] device: 'tty39': device_add
[   11.658588] device: 'tty40': device_add
[   11.662543] device: 'tty41': device_add
[   11.666471] device: 'tty42': device_add
[   11.670436] device: 'tty43': device_add
[   11.674382] device: 'tty44': device_add
[   11.678315] device: 'tty45': device_add
[   11.682269] device: 'tty46': device_add
[   11.686218] device: 'tty47': device_add
[   11.690189] device: 'tty48': device_add
[   11.694116] device: 'tty49': device_add
[   11.698051] device: 'tty50': device_add
[   11.702022] device: 'tty51': device_add
[   11.705954] device: 'tty52': device_add
[   11.709888] device: 'tty53': device_add
[   11.713845] device: 'tty54': device_add
[   11.717795] device: 'tty55': device_add
[   11.721745] device: 'tty56': device_add
[   11.725672] device: 'tty57': device_add
[   11.729607] device: 'tty58': device_add
[   11.733577] device: 'tty59': device_add
[   11.737513] device: 'tty60': device_add
[   11.741467] device: 'tty61': device_add
[   11.745413] device: 'tty62': device_add
[   11.749364] device: 'tty63': device_add
[   11.753501] initcall tty_init+0x0/0xf5 returned 0 after 272726 usecs
[   11.759851] calling  pty_init+0x0/0x336 @ 1
[   11.764150] device: 'ptmx': device_add
[   11.767967] initcall pty_init+0x0/0x336 returned 0 after 3818 usecs
[   11.774248] calling  sysrq_init+0x0/0x25 @ 1
[   11.778536] initcall sysrq_init+0x0/0x25 returned 0 after 20 usecs
[   11.784727] calling  nozomi_init+0x0/0x129 @ 1
[   11.789165] Initializing Nozomi driver 2.1d (build date: May 21 2010 20:45:00)
[   11.796413] bus: 'pci': add driver nozomi
[   11.800561] initcall nozomi_init+0x0/0x129 returned 0 after 11124 usecs
[   11.807172] calling  lp_init_module+0x0/0x259 @ 1
[   11.811911] device class 'printer': registering
[   11.816534] lp: driver loaded but no devices found
[   11.821347] initcall lp_init_module+0x0/0x259 returned 0 after 9227 usecs
[   11.828127] calling  applicom_init+0x0/0x4c8 @ 1
[   11.832778] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[   11.839927] ac.o: No PCI boards found.
[   11.843692] ac.o: For an ISA board you must supply memory and irq parameters.
[   11.850836] initcall applicom_init+0x0/0x4c8 returned -6 after 17632 usecs
[   11.857698] initcall applicom_init+0x0/0x4c8 returned with error code -6 
[   11.864504] calling  hpet_init+0x0/0x6a @ 1
[   11.868691] device: 'hpet': device_add
[   11.872604] bus: 'acpi': add driver hpet
[   11.876715] initcall hpet_init+0x0/0x6a returned 0 after 7842 usecs
[   11.882998] calling  nvram_init+0x0/0x82 @ 1
[   11.887271] device: 'nvram': device_add
[   11.891293] Non-volatile memory driver v1.3
[   11.895473] initcall nvram_init+0x0/0x82 returned 0 after 8014 usecs
[   11.901841] calling  i8k_init+0x0/0x371 @ 1
[   11.906024] initcall i8k_init+0x0/0x371 returned -19 after 3 usecs
[   11.912216] calling  pc8736x_gpio_init+0x0/0x40e @ 1
[   11.917217] Registering platform device 'pc8736x_gpio.0'. Parent at platform
[   11.924289] device: 'pc8736x_gpio.0': device_add
[   11.928910] bus: 'platform': add device pc8736x_gpio.0
[   11.934139] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[   11.941294] platform pc8736x_gpio.0: no device found
[   11.946349] bus: 'platform': remove device pc8736x_gpio.0
[   11.951806] initcall pc8736x_gpio_init+0x0/0x40e returned -19 after 33807 usecs
[   11.959109] calling  nsc_gpio_init+0x0/0x16 @ 1
[   11.963660] nsc_gpio initializing
[   11.966974] initcall nsc_gpio_init+0x0/0x16 returned 0 after 3237 usecs
[   11.973599] calling  tlclk_init+0x0/0x1d4 @ 1
[   11.977992] telclk_interrup = 0xf non-mcpbl0010 hw.
[   11.982913] initcall tlclk_init+0x0/0x1d4 returned -6 after 4840 usecs
[   11.989434] initcall tlclk_init+0x0/0x1d4 returned with error code -6 
[   11.995979] calling  mwave_init+0x0/0x1dd @ 1
[   12.000356] smapi::smapi_init, ERROR invalid usSmapiID
[   12.005485] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[   12.014800] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[   12.022028] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   12.028288] initcall mwave_init+0x0/0x1dd returned -5 after 27290 usecs
[   12.034916] initcall mwave_init+0x0/0x1dd returned with error code -5 
[   12.041452] calling  agp_init+0x0/0x26 @ 1
[   12.045545] Linux agpgart interface v0.103
[   12.049643] initcall agp_init+0x0/0x26 returned 0 after 4003 usecs
[   12.055839] calling  agp_amd64_mod_init+0x0/0xb @ 1
[   12.060730] bus: 'pci': add driver agpgart-amd64
[   12.065868] initcall agp_amd64_mod_init+0x0/0xb returned -19 after 5022 usecs
[   12.073017] calling  agp_intel_init+0x0/0x29 @ 1
[   12.077631] bus: 'pci': add driver agpgart-intel
[   12.082388] initcall agp_intel_init+0x0/0x29 returned 0 after 4642 usecs
[   12.089085] calling  agp_sis_init+0x0/0x29 @ 1
[   12.093551] bus: 'pci': add driver agpgart-sis
[   12.098110] initcall agp_sis_init+0x0/0x29 returned 0 after 4455 usecs
[   12.104652] calling  agp_via_init+0x0/0x29 @ 1
[   12.109092] bus: 'pci': add driver agpgart-via
[   12.113677] initcall agp_via_init+0x0/0x29 returned 0 after 4474 usecs
[   12.120217] calling  synclink_cs_init+0x0/0x15e @ 1
[   12.125088] SyncLink PC Card driver $Revision: 4.34 $
[   12.130157] bus: 'pcmcia': add driver synclink_cs
[   12.134968] device: 'ttySLP0': device_add
[   12.139086] device: 'ttySLP1': device_add
[   12.143216] device: 'ttySLP2': device_add
[   12.147341] device: 'ttySLP3': device_add
[   12.151501] SyncLink PC Card driver $Revision: 4.34 $, tty major#250
[   12.157849] initcall synclink_cs_init+0x0/0x15e returned 0 after 31991 usecs
[   12.164911] calling  cmm_init+0x0/0xd2 @ 1
[   12.169002] cm4000_cs.c v2.4.0gm6 - All bugs added by Harald Welte
[   12.175201] device class 'cardman_4000': registering
[   12.180256] bus: 'pcmcia': add driver cm4000_cs
[   12.184835] initcall cmm_init+0x0/0xd2 returned 0 after 15459 usecs
[   12.191120] calling  cm4040_init+0x0/0xd2 @ 1
[   12.195471] OMNIKEY CardMan 4040 v1.1.0gm5 - All bugs added by Harald Welte
[   12.202446] device class 'cardman_4040': registering
[   12.207445] bus: 'pcmcia': add driver cm4040_cs
[   12.212069] initcall cm4040_init+0x0/0xd2 returned 0 after 16204 usecs
[   12.218593] calling  ipmi_init_msghandler_mod+0x0/0xd @ 1
[   12.224012] bus: 'platform': add driver ipmi
[   12.228323] ipmi message handler version 39.2
[   12.232718] initcall ipmi_init_msghandler_mod+0x0/0xd returned 0 after 8501 usecs
[   12.240208] calling  init_ipmi_devintf+0x0/0x108 @ 1
[   12.245166] ipmi device interface
[   12.248481] device class 'ipmi': registering
[   12.252859] initcall init_ipmi_devintf+0x0/0x108 returned 0 after 7506 usecs
[   12.259896] calling  ipmi_wdog_init+0x0/0x12d @ 1
[   12.264628] IPMI Watchdog: driver initialized
[   12.268985] initcall ipmi_wdog_init+0x0/0x12d returned 0 after 4261 usecs
[   12.275786] calling  ipmi_poweroff_init+0x0/0x8d @ 1
[   12.280758] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[   12.288443] initcall ipmi_poweroff_init+0x0/0x8d returned 0 after 7509 usecs
[   12.295502] calling  hangcheck_init+0x0/0x89 @ 1
[   12.300130] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[   12.309069] Hangcheck: Using get_cycles().
[   12.313191] initcall hangcheck_init+0x0/0x89 returned 0 after 12754 usecs
[   12.319966] calling  init_tis+0x0/0x8e @ 1
[   12.324086] bus: 'pnp': add driver tpm_tis
[   12.328250] initcall init_tis+0x0/0x8e returned 0 after 4069 usecs
[   12.334476] calling  init_inf+0x0/0x12 @ 1
[   12.338570] bus: 'pnp': add driver tpm_inf_pnp
[   12.343097] initcall init_inf+0x0/0x12 returned 0 after 4417 usecs
[   12.349269] calling  intelfb_init+0x0/0x45f @ 1
[   12.353821] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
[   12.365379] intelfb: Version 0.9.6
[   12.368783] bus: 'pci': add driver intelfb
[   12.372991] initcall intelfb_init+0x0/0x45f returned 0 after 18718 usecs
[   12.379681] calling  serial8250_init+0x0/0x183 @ 1
[   12.384493] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   12.390809] Registering platform device 'serial8250'. Parent at platform
[   12.397501] device: 'serial8250': device_add
[   12.401803] bus: 'platform': add device serial8250
[   12.406787] async_waiting @ 1
[   12.409761] async_continuing @ 1 after 7 usec
[   12.559507] async_waiting @ 1
[   12.562523] async_continuing @ 1 after 3 usec
[   12.719580] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   12.725638] device: 'ttyS0': device_add
[   12.729704] device: 'ttyS1': device_add
[   12.733686] device: 'ttyS2': device_add
[   12.737770] device: 'ttyS3': device_add
[   12.741754] bus: 'platform': add driver serial8250
[   12.746559] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[   12.755529] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[   12.763907] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[   12.770964] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[   12.779040] initcall serial8250_init+0x0/0x183 returned 0 after 385300 usecs
[   12.786106] calling  serial8250_pci_init+0x0/0x1b @ 1
[   12.791180] bus: 'pci': add driver serial
[   12.795335] initcall serial8250_pci_init+0x0/0x1b returned 0 after 4062 usecs
[   12.802486] calling  init_serial_cs+0x0/0x12 @ 1
[   12.807130] bus: 'pcmcia': add driver serial_cs
[   12.811783] initcall init_serial_cs+0x0/0x12 returned 0 after 4564 usecs
[   12.818471] calling  jsm_init_module+0x0/0x45 @ 1
[   12.823311] bus: 'pci': add driver jsm
[   12.827153] initcall jsm_init_module+0x0/0x45 returned 0 after 3862 usecs
[   12.833974] calling  timbuart_init+0x0/0x12 @ 1
[   12.838504] bus: 'platform': add driver timb-uart
[   12.843278] initcall timbuart_init+0x0/0x12 returned 0 after 4658 usecs
[   12.849880] calling  parport_default_proc_register+0x0/0x1b @ 1
[   12.855891] initcall parport_default_proc_register+0x0/0x1b returned 0 after 67 usecs
[   12.863733] calling  parport_pc_init+0x0/0x1ab @ 1
[   12.868525] bus: 'platform': add driver parport_pc
[   12.873520] bus: 'pnp': add driver parport_pc
[   12.877902] bus: 'pnp': driver_probe_device: matched device 00:09 with driver parport_pc
[   12.886006] bus: 'pnp': really_probe: probing driver parport_pc with device 00:09
[   12.893518] parport_pc 00:09: reported by Plug and Play ACPI
[   12.899277] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
[   12.980448] device: 'lp0': device_add
[   12.984289] lp0: using parport0 (interrupt-driven).
[   12.989161] lp0: console ready
[   12.992247] driver: '00:09': driver_bound: bound to device 'parport_pc'
[   12.998854] bus: 'pnp': really_probe: bound device 00:09 to driver parport_pc
[   13.006059] Registering platform device 'parport_pc.956'. Parent at platform
[   13.013123] device: 'parport_pc.956': device_add
[   13.017751] bus: 'platform': add device parport_pc.956
[   13.022997] bus: 'platform': driver_probe_device: matched device parport_pc.956 with driver parport_pc
[   13.032317] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.956
[   13.041059] driver: 'parport_pc.956': driver_bound: bound to device 'parport_pc'
[   13.048444] bus: 'platform': really_probe: bound device parport_pc.956 to driver parport_pc
[   13.056887] bus: 'platform': remove device parport_pc.956
[   13.062362] Registering platform device 'parport_pc.888'. Parent at platform
[   13.069401] device: 'parport_pc.888': device_add
[   13.074051] bus: 'platform': add device parport_pc.888
[   13.079265] bus: 'platform': driver_probe_device: matched device parport_pc.888 with driver parport_pc
[   13.088584] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.888
[   13.097320] driver: 'parport_pc.888': driver_bound: bound to device 'parport_pc'
[   13.104729] bus: 'platform': really_probe: bound device parport_pc.888 to driver parport_pc
[   13.113142] bus: 'platform': remove device parport_pc.888
[   13.118595] Registering platform device 'parport_pc.632'. Parent at platform
[   13.125661] device: 'parport_pc.632': device_add
[   13.130313] bus: 'platform': add device parport_pc.632
[   13.135520] bus: 'platform': driver_probe_device: matched device parport_pc.632 with driver parport_pc
[   13.144840] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.632
[   13.153576] driver: 'parport_pc.632': driver_bound: bound to device 'parport_pc'
[   13.160986] bus: 'platform': really_probe: bound device parport_pc.632 to driver parport_pc
[   13.169404] bus: 'platform': remove device parport_pc.632
[   13.174887] bus: 'pci': add driver parport_pc
[   13.179336] initcall parport_pc_init+0x0/0x1ab returned 0 after 303524 usecs
[   13.186398] calling  parport_ax88796_init+0x0/0x12 @ 1
[   13.191554] bus: 'platform': add driver ax88796-pp
[   13.196411] initcall parport_ax88796_init+0x0/0x12 returned 0 after 4745 usecs
[   13.203646] calling  topology_sysfs_init+0x0/0x71 @ 1
[   13.208760] initcall topology_sysfs_init+0x0/0x71 returned 0 after 61 usecs
[   13.215734] calling  floppy_init+0x0/0xe5c @ 1
[   13.220374] bus: 'platform': add driver floppy
[   13.224973] Floppy drive(s): fd0 is 1.44M
[   13.254031] FDC 0 is a post-1991 82077
[   13.258882] Registering platform device 'floppy.0'. Parent at platform
[   13.265422] device: 'floppy.0': device_add
[   13.269535] bus: 'platform': add device floppy.0
[   13.274257] bus: 'platform': driver_probe_device: matched device floppy.0 with driver floppy
[   13.282701] bus: 'platform': really_probe: probing driver floppy with device floppy.0
[   13.290549] driver: 'floppy.0': driver_bound: bound to device 'floppy'
[   13.297068] bus: 'platform': really_probe: bound device floppy.0 to driver floppy
[   13.304584] device: 'fd0': device_add
[   13.308755] device: '2:0': device_add
[   13.312556] initcall floppy_init+0x0/0xe5c returned 0 after 90189 usecs
[   13.319159] calling  brd_init+0x0/0x176 @ 1
[   13.324046] device: 'ram0': device_add
[   13.328016] device: '1:0': device_add
[   13.331817] device: 'ram1': device_add
[   13.335791] device: '1:1': device_add
[   13.339548] device: 'ram2': device_add
[   13.343528] device: '1:2': device_add
[   13.347310] device: 'ram3': device_add
[   13.351323] device: '1:3': device_add
[   13.355118] device: 'ram4': device_add
[   13.359113] device: '1:4': device_add
[   13.362953] device: 'ram5': device_add
[   13.366938] device: '1:5': device_add
[   13.370753] device: 'ram6': device_add
[   13.374760] device: '1:6': device_add
[   13.378554] device: 'ram7': device_add
[   13.382571] device: '1:7': device_add
[   13.386377] device: 'ram8': device_add
[   13.390388] device: '1:8': device_add
[   13.394189] device: 'ram9': device_add
[   13.398188] device: '1:9': device_add
[   13.402026] device: 'ram10': device_add
[   13.406096] device: '1:10': device_add
[   13.409967] device: 'ram11': device_add
[   13.414091] device: '1:11': device_add
[   13.417976] device: 'ram12': device_add
[   13.422082] device: '1:12': device_add
[   13.425970] device: 'ram13': device_add
[   13.430092] device: '1:13': device_add
[   13.433969] device: 'ram14': device_add
[   13.438053] device: '1:14': device_add
[   13.441980] device: 'ram15': device_add
[   13.446057] device: '1:15': device_add
[   13.449932] brd: module loaded
[   13.453018] initcall brd_init+0x0/0x176 returned 0 after 126607 usecs
[   13.459450] calling  cpqarray_init+0x0/0x28f @ 1
[   13.464089] Compaq SMART2 Driver (v 2.6.0)
[   13.468183] bus: 'pci': add driver cpqarray
[   13.472596] bus: 'pci': remove driver cpqarray
[   13.477088] driver: 'cpqarray': driver_release
[   13.481558] initcall cpqarray_init+0x0/0x28f returned -19 after 17058 usecs
[   13.488508] calling  cciss_init+0x0/0x9e @ 1
[   13.492807] HP CISS Driver (v 3.6.20)
[   13.496548] bus: 'cciss': registered
[   13.500316] bus: 'pci': add driver cciss
[   13.504349] initcall cciss_init+0x0/0x9e returned 0 after 11271 usecs
[   13.510805] calling  DAC960_init_module+0x0/0x4e @ 1
[   13.515768] bus: 'pci': add driver DAC960
[   13.519873] device: 'dac960_gam': device_add
[   13.524259] initcall DAC960_init_module+0x0/0x4e returned 0 after 8288 usecs
[   13.531323] calling  mm_init+0x0/0x193 @ 1
[   13.535418] bus: 'pci': add driver umem
[   13.539376] MM: desc_per_page = 128
[   13.542891] initcall mm_init+0x0/0x193 returned 0 after 7296 usecs
[   13.549063] calling  nbd_init+0x0/0x310 @ 1
[   13.554429] nbd: registered device at major 43
[   13.558874] device: 'nbd0': device_add
[   13.562928] device: '43:0': device_add
[   13.566800] device: 'nbd1': device_add
[   13.570941] device: '43:1': device_add
[   13.574850] device: 'nbd2': device_add
[   13.578854] device: '43:2': device_add
[   13.582733] device: 'nbd3': device_add
[   13.586734] device: '43:3': device_add
[   13.590666] device: 'nbd4': device_add
[   13.594690] device: '43:4': device_add
[   13.598578] device: 'nbd5': device_add
[   13.602647] device: '43:5': device_add
[   13.606538] device: 'nbd6': device_add
[   13.610601] device: '43:6': device_add
[   13.614492] device: 'nbd7': device_add
[   13.618531] device: '43:7': device_add
[   13.622465] device: 'nbd8': device_add
[   13.626489] device: '43:8': device_add
[   13.630412] device: 'nbd9': device_add
[   13.634457] device: '43:9': device_add
[   13.638341] device: 'nbd10': device_add
[   13.642492] device: '43:10': device_add
[   13.646457] device: 'nbd11': device_add
[   13.650604] device: '43:11': device_add
[   13.654597] device: 'nbd12': device_add
[   13.658710] device: '43:12': device_add
[   13.662712] device: 'nbd13': device_add
[   13.666840] device: '43:13': device_add
[   13.670833] device: 'nbd14': device_add
[   13.674962] device: '43:14': device_add
[   13.678938] device: 'nbd15': device_add
[   13.683089] device: '43:15': device_add
[   13.687081] initcall nbd_init+0x0/0x310 returned 0 after 130665 usecs
[   13.693536] calling  carm_init+0x0/0x1b @ 1
[   13.697723] bus: 'pci': add driver sx8
[   13.701615] initcall carm_init+0x0/0x1b returned 0 after 3801 usecs
[   13.707873] calling  ub_init+0x0/0x8e @ 1
[   13.711915] bus: 'usb': add driver ub
[   13.715649] usbcore: registered new interface driver ub
[   13.720942] initcall ub_init+0x0/0x8e returned 0 after 8820 usecs
[   13.727026] calling  ibmasm_init+0x0/0x64 @ 1
[   13.731425] bus: 'pci': add driver ibmasm
[   13.735554] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[   13.742182] initcall ibmasm_init+0x0/0x64 returned 0 after 10513 usecs
[   13.748702] calling  lkdtm_module_init+0x0/0x1b8 @ 1
[   13.753726] lkdtm: No crash points registered, enable through debugfs
[   13.760182] initcall lkdtm_module_init+0x0/0x1b8 returned 0 after 6339 usecs
[   13.767223] calling  phantom_init+0x0/0x10b @ 1
[   13.771778] device class 'phantom': registering
[   13.776386] bus: 'pci': add driver phantom
[   13.780628] Phantom Linux Driver, version n0.9.8, init OK
[   13.786024] initcall phantom_init+0x0/0x10b returned 0 after 13916 usecs
[   13.792743] calling  enclosure_init+0x0/0x19 @ 1
[   13.797361] device class 'enclosure': registering
[   13.802117] initcall enclosure_init+0x0/0x19 returned 0 after 4640 usecs
[   13.808807] calling  ilo_init+0x0/0x95 @ 1
[   13.812929] device class 'iLO': registering
[   13.817145] bus: 'pci': add driver hpilo
[   13.821180] initcall ilo_init+0x0/0x95 returned 0 after 8057 usecs
[   13.827354] calling  isl29003_init+0x0/0x14 @ 1
[   13.831928] bus: 'i2c': add driver isl29003
[   13.836153] i2c-core: driver [isl29003] registered
[   13.840969] initcall isl29003_init+0x0/0x14 returned 0 after 8830 usecs
[   13.847572] calling  tsl2550_init+0x0/0x14 @ 1
[   13.852042] bus: 'i2c': add driver tsl2550
[   13.856182] i2c-core: driver [tsl2550] registered
[   13.860912] initcall tsl2550_init+0x0/0x14 returned 0 after 8662 usecs
[   13.867429] calling  c2port_init+0x0/0x52 @ 1
[   13.871810] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[   13.879024] device class 'c2port': registering
[   13.883526] initcall c2port_init+0x0/0x52 returned 0 after 11440 usecs
[   13.890069] calling  at24_init+0x0/0x37 @ 1
[   13.894248] bus: 'i2c': add driver at24
[   13.898145] i2c-core: driver [at24] registered
[   13.902615] initcall at24_init+0x0/0x37 returned 0 after 8169 usecs
[   13.908874] calling  eeprom_init+0x0/0x14 @ 1
[   13.913256] bus: 'i2c': add driver eeprom
[   13.917305] i2c-core: driver [eeprom] registered
[   13.921943] initcall eeprom_init+0x0/0x14 returned 0 after 8483 usecs
[   13.928373] calling  max6875_init+0x0/0x14 @ 1
[   13.932849] bus: 'i2c': add driver max6875
[   13.936979] i2c-core: driver [max6875] registered
[   13.941701] initcall max6875_init+0x0/0x14 returned 0 after 8645 usecs
[   13.948219] calling  cb710_init_module+0x0/0x1b @ 1
[   13.953124] bus: 'pci': add driver cb710
[   13.957135] initcall cb710_init_module+0x0/0x1b returned 0 after 3921 usecs
[   13.964111] calling  sm501_base_init+0x0/0x27 @ 1
[   13.968817] bus: 'platform': add driver sm501
[   13.973249] bus: 'pci': add driver sm501
[   13.977270] initcall sm501_base_init+0x0/0x27 returned 0 after 8256 usecs
[   13.984071] calling  pasic3_base_init+0x0/0x19 @ 1
[   13.988863] bus: 'platform': add driver pasic3
[   13.993387] bus: 'platform': remove driver pasic3
[   13.998118] driver: 'pasic3': driver_release
[   14.002415] initcall pasic3_base_init+0x0/0x19 returned -19 after 13231 usecs
[   14.009536] calling  htcpld_core_init+0x0/0x2b @ 1
[   14.014376] bus: 'i2c': add driver htcpld-chip
[   14.018866] i2c-core: driver [htcpld-chip] registered
[   14.023943] bus: 'platform': add driver i2c-htcpld
[   14.028776] bus: 'platform': remove driver i2c-htcpld
[   14.033879] driver: 'i2c-htcpld': driver_release
[   14.038500] initcall htcpld_core_init+0x0/0x2b returned -19 after 23561 usecs
[   14.045647] calling  wm8994_i2c_init+0x0/0x33 @ 1
[   14.050372] bus: 'i2c': add driver wm8994
[   14.054423] i2c-core: driver [wm8994] registered
[   14.059037] initcall wm8994_i2c_init+0x0/0x33 returned 0 after 8467 usecs
[   14.065841] calling  ab3100_otp_init+0x0/0x19 @ 1
[   14.070566] bus: 'platform': add driver ab3100-otp
[   14.075404] bus: 'platform': remove driver ab3100-otp
[   14.080499] driver: 'ab3100-otp': driver_release
[   14.085117] initcall ab3100_otp_init+0x0/0x19 returned -19 after 14213 usecs
[   14.092179] calling  adp5520_init+0x0/0x14 @ 1
[   14.096616] bus: 'i2c': add driver adp5520
[   14.100774] i2c-core: driver [adp5520] registered
[   14.105475] initcall adp5520_init+0x0/0x14 returned 0 after 8652 usecs
[   14.112018] calling  lpc_sch_init+0x0/0x1b @ 1
[   14.116464] bus: 'pci': add driver lpc_sch
[   14.120671] initcall lpc_sch_init+0x0/0x1b returned 0 after 4105 usecs
[   14.127189] calling  mac_hid_init+0x0/0x22 @ 1
[   14.131773] initcall mac_hid_init+0x0/0x22 returned 0 after 105 usecs
[   14.138204] calling  scsi_tgt_init+0x0/0x86 @ 1
[   14.143210] device: 'tgt': device_add
[   14.146972] initcall scsi_tgt_init+0x0/0x86 returned 0 after 4113 usecs
[   14.153604] calling  raid_init+0x0/0x12 @ 1
[   14.157785] device class 'raid_devices': registering
[   14.162809] initcall raid_init+0x0/0x12 returned 0 after 4902 usecs
[   14.169068] calling  spi_transport_init+0x0/0x79 @ 1
[   14.174062] device class 'spi_transport': registering
[   14.179267] device class 'spi_host': registering
[   14.183976] initcall spi_transport_init+0x0/0x79 returned 0 after 9684 usecs
[   14.191033] calling  fc_transport_init+0x0/0x8a @ 1
[   14.195909] device class 'fc_host': registering
[   14.200492] device class 'fc_vports': registering
[   14.205222] device class 'fc_remote_ports': registering
[   14.210494] device class 'fc_transport': registering
[   14.215486] initcall fc_transport_init+0x0/0x8a returned 0 after 19116 usecs
[   14.222554] calling  iscsi_transport_init+0x0/0x14f @ 1
[   14.227778] Loading iSCSI transport class v2.0-870.
[   14.232685] device class 'iscsi_transport': registering
[   14.237941] device class 'iscsi_endpoint': registering
[   14.243158] device class 'iscsi_host': registering
[   14.248007] device class 'iscsi_connection': registering
[   14.253370] device class 'iscsi_session': registering
[   14.258592] initcall iscsi_transport_init+0x0/0x14f returned 0 after 30084 usecs
[   14.265998] calling  sas_transport_init+0x0/0xcc @ 1
[   14.270972] device class 'sas_host': registering
[   14.275651] device class 'sas_phy': registering
[   14.280238] device class 'sas_port': registering
[   14.284919] device class 'sas_device': registering
[   14.289787] device class 'sas_end_device': registering
[   14.295006] device class 'sas_expander': registering
[   14.299992] initcall sas_transport_init+0x0/0xcc returned 0 after 28342 usecs
[   14.307142] calling  srp_transport_init+0x0/0x3c @ 1
[   14.312123] device class 'srp_host': registering
[   14.316759] device class 'srp_remote_ports': registering
[   14.322122] initcall srp_transport_init+0x0/0x3c returned 0 after 9763 usecs
[   14.329159] calling  ahc_linux_init+0x0/0x58 @ 1
[   14.333822] bus: 'pci': add driver aic7xxx
[   14.338016] initcall ahc_linux_init+0x0/0x58 returned 0 after 4106 usecs
[   14.344729] calling  init_st+0x0/0x1a3 @ 1
[   14.348819] st: Version 20081215, fixed bufsize 32768, s/g segs 256
[   14.355104] device class 'scsi_tape': registering
[   14.359842] bus: 'scsi': add driver st
[   14.363672] initcall init_st+0x0/0x1a3 returned 0 after 14500 usecs
[   14.369928] calling  init_sd+0x0/0x142 @ 1
[   14.374092] device class 'scsi_disk': registering
[   14.378882] bus: 'scsi': add driver sd
[   14.382733] initcall init_sd+0x0/0x142 returned 0 after 8476 usecs
[   14.388908] calling  init_sr+0x0/0x46 @ 1
[   14.392947] bus: 'scsi': add driver sr
[   14.396766] initcall init_sr+0x0/0x46 returned 0 after 3735 usecs
[   14.402873] calling  init_sg+0x0/0xc6 @ 1
[   14.406880] device class 'scsi_generic': registering
[   14.411977] initcall init_sg+0x0/0xc6 returned 0 after 4976 usecs
[   14.418064] calling  init_ch_module+0x0/0xb8 @ 1
[   14.422706] SCSI Media Changer driver v0.25 
[   14.426974] device class 'scsi_changer': registering
[   14.431999] bus: 'scsi': add driver ch
[   14.435788] initcall init_ch_module+0x0/0xb8 returned 0 after 12776 usecs
[   14.442594] calling  ses_init+0x0/0x3c @ 1
[   14.446687] bus: 'scsi': add driver ses
[   14.450610] initcall ses_init+0x0/0x3c returned 0 after 3829 usecs
[   14.456779] calling  osd_uld_init+0x0/0xc6 @ 1
[   14.461246] device class 'scsi_osd': registering
[   14.465895] bus: 'scsi': add driver osd
[   14.469762] osd: LOADED open-osd 0.2.0
[   14.473538] initcall osd_uld_init+0x0/0xc6 returned 0 after 12002 usecs
[   14.480163] calling  ahci_init+0x0/0x1b @ 1
[   14.484343] bus: 'pci': add driver ahci
[   14.488274] initcall ahci_init+0x0/0x1b returned 0 after 3843 usecs
[   14.494562] calling  k2_sata_init+0x0/0x1b @ 1
[   14.499007] bus: 'pci': add driver sata_svw
[   14.503294] initcall k2_sata_init+0x0/0x1b returned 0 after 4183 usecs
[   14.509809] calling  piix_init+0x0/0x29 @ 1
[   14.514019] bus: 'pci': add driver ata_piix
[   14.518288] initcall piix_init+0x0/0x29 returned 0 after 4173 usecs
[   14.524574] calling  pdc_ata_init+0x0/0x1b @ 1
[   14.529020] bus: 'pci': add driver sata_promise
[   14.533675] initcall pdc_ata_init+0x0/0x1b returned 0 after 4542 usecs
[   14.540216] calling  sil_init+0x0/0x1b @ 1
[   14.544309] bus: 'pci': add driver sata_sil
[   14.548683] initcall sil_init+0x0/0x1b returned 0 after 4276 usecs
[   14.554882] calling  sil24_init+0x0/0x1b @ 1
[   14.559155] bus: 'pci': add driver sata_sil24
[   14.563628] initcall sil24_init+0x0/0x1b returned 0 after 4365 usecs
[   14.569976] calling  svia_init+0x0/0x1b @ 1
[   14.574184] bus: 'pci': add driver sata_via
[   14.578450] initcall svia_init+0x0/0x1b returned 0 after 4169 usecs
[   14.584730] calling  vsc_sata_init+0x0/0x1b @ 1
[   14.589263] bus: 'pci': add driver sata_vsc
[   14.593567] initcall vsc_sata_init+0x0/0x1b returned 0 after 4200 usecs
[   14.600190] calling  sis_init+0x0/0x1b @ 1
[   14.604283] bus: 'pci': add driver sata_sis
[   14.608546] initcall sis_init+0x0/0x1b returned 0 after 4167 usecs
[   14.614743] calling  nv_init+0x0/0x1b @ 1
[   14.618757] bus: 'pci': add driver sata_nv
[   14.622956] initcall nv_init+0x0/0x1b returned 0 after 4098 usecs
[   14.629040] calling  mv_init+0x0/0x45 @ 1
[   14.633079] bus: 'pci': add driver sata_mv
[   14.637255] bus: 'platform': add driver sata_mv
[   14.641862] initcall mv_init+0x0/0x45 returned 0 after 8578 usecs
[   14.647951] calling  inic_init+0x0/0x1b @ 1
[   14.652160] bus: 'pci': add driver sata_inic162x
[   14.656867] initcall inic_init+0x0/0x1b returned 0 after 4601 usecs
[   14.663147] calling  adma_ata_init+0x0/0x1b @ 1
[   14.667679] bus: 'pci': add driver pdc_adma
[   14.671964] initcall adma_ata_init+0x0/0x1b returned 0 after 4181 usecs
[   14.678569] calling  ali_init+0x0/0x4d @ 1
[   14.682714] bus: 'pci': add driver pata_ali
[   14.686973] initcall ali_init+0x0/0x4d returned 0 after 4185 usecs
[   14.693169] calling  amd_init+0x0/0x1b @ 1
[   14.697267] bus: 'pci': add driver pata_amd
[   14.701496] bus: 'pci': driver_probe_device: matched device 0000:00:06.0 with driver pata_amd
[   14.710024] bus: 'pci': really_probe: probing driver pata_amd with device 0000:00:06.0
[   14.718074] pata_amd 0000:00:06.0: version 0.4.1
[   14.722860] pata_amd 0000:00:06.0: setting latency timer to 64
[   14.728888] scsi0 : pata_amd
[   14.731817] device: 'host0': device_add
[   14.735678] device: 'host0': device_add
[   14.739800] scsi1 : pata_amd
[   14.742702] device: 'host1': device_add
[   14.746558] device: 'host1': device_add
[   14.750549] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[   14.757496] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[   14.764621] driver: '0000:00:06.0': driver_bound: bound to device 'pata_amd'
[   14.764709] calling  2_async_port_probe+0x0/0xb6 @ 113
[   14.764970] calling  3_async_port_probe+0x0/0xb6 @ 114
[   14.764974] async_waiting @ 114
[   14.785139] bus: 'pci': really_probe: bound device 0000:00:06.0 to driver pata_amd
[   14.792797] initcall amd_init+0x0/0x1b returned 0 after 93286 usecs
[   14.799056] calling  artop_init+0x0/0x1b @ 1
[   14.803353] bus: 'pci': add driver pata_artop
[   14.807793] initcall artop_init+0x0/0x1b returned 0 after 4342 usecs
[   14.814166] calling  atiixp_init+0x0/0x1b @ 1
[   14.818525] bus: 'pci': add driver pata_atiixp
[   14.823139] initcall atiixp_init+0x0/0x1b returned 0 after 4504 usecs
[   14.829570] calling  cmd640_init+0x0/0x1b @ 1
[   14.833955] bus: 'pci': add driver pata_cmd640
[   14.838479] initcall cmd640_init+0x0/0x1b returned 0 after 4422 usecs
[   14.844932] calling  cmd64x_init+0x0/0x1b @ 1
[   14.849284] bus: 'pci': add driver pata_cmd64x
[   14.853832] initcall cmd64x_init+0x0/0x1b returned 0 after 4438 usecs
[   14.860337] calling  cy82c693_init+0x0/0x1b @ 1
[   14.864867] bus: 'pci': add driver pata_cypress
[   14.869478] initcall cy82c693_init+0x0/0x1b returned 0 after 4507 usecs
[   14.876117] calling  efar_init+0x0/0x1b @ 1
[   14.880321] bus: 'pci': add driver pata_efar
[   14.884698] initcall efar_init+0x0/0x1b returned 0 after 4278 usecs
[   14.890981] calling  hpt36x_init+0x0/0x1b @ 1
[   14.895338] bus: 'pci': add driver pata_hpt366
[   14.899863] initcall hpt36x_init+0x0/0x1b returned 0 after 4422 usecs
[   14.906372] calling  hpt37x_init+0x0/0x1b @ 1
[   14.910752] bus: 'pci': add driver pata_hpt37x
[   14.915277] initcall hpt37x_init+0x0/0x1b returned 0 after 4422 usecs
[   14.921739] calling  hpt3x2n_init+0x0/0x1b @ 1
[   14.926183] bus: 'pci': add driver pata_hpt3x2n
[   14.930820] initcall hpt3x2n_init+0x0/0x1b returned 0 after 4525 usecs
[   14.937342] calling  it821x_init+0x0/0x1b @ 1
[   14.941779] bus: 'pci': add driver pata_it821x
[   14.946335] initcall it821x_init+0x0/0x1b returned 0 after 4454 usecs
[   14.952790] calling  it8213_init+0x0/0x1b @ 1
[   14.957150] bus: 'pci': add driver pata_it8213
[   14.961697] initcall it8213_init+0x0/0x1b returned 0 after 4438 usecs
[   14.968126] calling  jmicron_init+0x0/0x1b @ 1
[   14.970732] ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
[   14.970735] ata1.00: 488397168 sectors, multi 1: LBA48 
[   14.970758] ata1: nv_mode_filter: 0x3f39f&0x3f3ff->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
[   14.992721] bus: 'pci': add driver pata_jmicron
[   14.997335] initcall jmicron_init+0x0/0x1b returned 0 after 4510 usecs
[   15.003882] calling  netcell_init+0x0/0x1b @ 1
[   15.008327] bus: 'pci': add driver pata_netcell
[   15.012970] initcall netcell_init+0x0/0x1b returned 0 after 4532 usecs
[   15.019486] calling  ninja32_init+0x0/0x1b @ 1
[   15.023956] bus: 'pci': add driver pata_ninja32
[   15.028572] initcall ninja32_init+0x0/0x1b returned 0 after 4512 usecs
[   15.035167] calling  ns87415_init+0x0/0x1b @ 1
[   15.039607] bus: 'pci': add driver pata_ns87415
[   15.040637] ata1.00: configured for UDMA/100
[   15.040672] async_waiting @ 113
[   15.040679] async_continuing @ 113 after 2 usec
[   15.041229] scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
[   15.041238] device: 'target0:0:0': device_add
[   15.041297] device: '0:0:0:0': device_add
[   15.041366] bus: 'scsi': add device 0:0:0:0
[   15.041462] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver st
[   15.041465] bus: 'scsi': really_probe: probing driver st with device 0:0:0:0
[   15.041540] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver sd
[   15.041543] bus: 'scsi': really_probe: probing driver sd with device 0:0:0:0
[   15.041754] device: '0:0:0:0': device_add
[   15.041985] driver: '0:0:0:0': driver_bound: bound to device 'sd'
[   15.041989] bus: 'scsi': really_probe: bound device 0:0:0:0 to driver sd
[   15.041999] device: '0:0:0:0': device_add
[   15.042237] device: 'sg0': device_add
[   15.042437] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   15.042607] device: '0:0:0:0': device_add
[   15.042779] initcall 2_async_port_probe+0x0/0xb6 returned 0 after 271545 usecs
[   15.042793] calling  4_sd_probe_async+0x0/0x1e3 @ 113
[   15.042935] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[   15.043201] sd 0:0:0:0: [sda] Write Protect is off
[   15.043204] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   15.043312] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.043323] device: 'sda': device_add
[   15.050034] async_continuing @ 114 after 278374 usec
[   15.187273] initcall ns87415_init+0x0/0x1b returned 0 after 144203 usecs
[   15.193987] calling  opti_init+0x0/0x1b @ 1
[   15.198174] bus: 'pci': add driver pata_opti
[   15.202581] initcall opti_init+0x0/0x1b returned 0 after 4301 usecs
[   15.208837] calling  optidma_init+0x0/0x1b @ 1
[   15.213308] bus: 'pci': add driver pata_optidma
[   15.217916] initcall optidma_init+0x0/0x1b returned 0 after 4504 usecs
[   15.220037] ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
[   15.220059] ata2: nv_mode_filter: 0x1f39f&0x73ff->0x739f, BIOS=0x7000 (0xc60000c0) ACPI=0x0
[   15.238846] calling  marvell_init+0x0/0x1b @ 1
[   15.240484] ata2.01: configured for UDMA/33
[   15.241269] async_waiting @ 114
[   15.241275] async_continuing @ 114 after 2 usec
[   15.241762] scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
[   15.241779] device: 'target1:0:1': device_add
[   15.241808] device: '1:0:1:0': device_add
[   15.241921] bus: 'scsi': add device 1:0:1:0
[   15.241982] bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver st
[   15.241985] bus: 'scsi': really_probe: probing driver st with device 1:0:1:0
[   15.242014] bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver sd
[   15.242017] bus: 'scsi': really_probe: probing driver sd with device 1:0:1:0
[   15.242043] bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver sr
[   15.242045] bus: 'scsi': really_probe: probing driver sr with device 1:0:1:0
[   15.246206] sr0: scsi3-mmc drive: 1x/48x writer cd/rw xa/form2 cdda tray
[   15.246210] Uniform CD-ROM driver Revision: 3.20
[   15.246430] device: 'sr0': device_add
[   15.246711] device: '11:0': device_add
[   15.246872] sr 1:0:1:0: Attached scsi CD-ROM sr0
[   15.246874] driver: '1:0:1:0': driver_bound: bound to device 'sr'
[   15.246878] bus: 'scsi': really_probe: bound device 1:0:1:0 to driver sr
[   15.246887] device: '1:0:1:0': device_add
[   15.246981] device: 'sg1': device_add
[   15.247153] sr 1:0:1:0: Attached scsi generic sg1 type 5
[   15.247234] device: '1:0:1:0': device_add
[   15.247339] initcall 3_async_port_probe+0x0/0xb6 returned 0 after 471060 usecs
[   15.380136] bus: 'pci': add driver pata_marvell
[   15.384754] initcall marvell_init+0x0/0x1b returned 0 after 4514 usecs
[   15.391295] calling  mpiix_init+0x0/0x1b @ 1
[   15.395567] bus: 'pci': add driver pata_mpiix
[   15.400031] initcall mpiix_init+0x0/0x1b returned 0 after 4356 usecs
[   15.406379] calling  oldpiix_init+0x0/0x1b @ 1
[   15.410849] bus: 'pci': add driver pata_oldpiix
[   15.415503] initcall oldpiix_init+0x0/0x1b returned 0 after 4549 usecs
[   15.422097] calling  pdc2027x_init+0x0/0x1b @ 1
[   15.426629] bus: 'pci': add driver pata_pdc2027x
[   15.431350] initcall pdc2027x_init+0x0/0x1b returned 0 after 4608 usecs
[   15.437953] calling  radisys_init+0x0/0x1b @ 1
[   15.442426] bus: 'pci': add driver pata_radisys
[   15.447035] initcall radisys_init+0x0/0x1b returned 0 after 4505 usecs
[   15.453575] calling  rdc_init+0x0/0x1b @ 1
[   15.457675] bus: 'pci': add driver pata_rdc
[   15.462015] initcall rdc_init+0x0/0x1b returned 0 after 4236 usecs
[   15.468181] calling  rz1000_init+0x0/0x1b @ 1
[   15.472565] bus: 'pci': add driver pata_rz1000
[   15.477124] initcall rz1000_init+0x0/0x1b returned 0 after 4456 usecs
[   15.483577] calling  sc1200_init+0x0/0x1b @ 1
[   15.487930] bus: 'pci': add driver sc1200
[   15.492042] initcall sc1200_init+0x0/0x1b returned 0 after 4013 usecs
[   15.498472] calling  sil680_init+0x0/0x1b @ 1
[   15.502907] bus: 'pci': add driver pata_sil680
[   15.507433] initcall sil680_init+0x0/0x1b returned 0 after 4424 usecs
[   15.513886] calling  ata_tosh_init+0x0/0x1b @ 1
[   15.518420] bus: 'pci': add driver pata_piccolo
[   15.523052] initcall ata_tosh_init+0x0/0x1b returned 0 after 4521 usecs
[   15.529655] calling  via_init+0x0/0x1b @ 1
[   15.533780] bus: 'pci': add driver pata_via
[   15.538047] initcall via_init+0x0/0x1b returned 0 after 4171 usecs
[   15.544297] calling  sl82c105_init+0x0/0x1b @ 1
[   15.548823] bus: 'pci': add driver pata_sl82c105
[   15.553566] initcall sl82c105_init+0x0/0x1b returned 0 after 4630 usecs
[   15.560194] calling  sis_init+0x0/0x1b @ 1
[   15.564294] bus: 'pci': add driver pata_sis
[   15.568558] initcall sis_init+0x0/0x1b returned 0 after 4168 usecs
[   15.574753] calling  triflex_init+0x0/0x1b @ 1
[   15.579200] bus: 'pci': add driver pata_triflex
[   15.583885] initcall triflex_init+0x0/0x1b returned 0 after 4573 usecs
[   15.590423] calling  sch_init+0x0/0x1b @ 1
[   15.594524] bus: 'pci': add driver pata_sch
[   15.598788] initcall sch_init+0x0/0x1b returned 0 after 4169 usecs
[   15.604991] calling  pata_platform_init+0x0/0x12 @ 1
[   15.609950] bus: 'platform': add driver pata_platform
[   15.615092] initcall pata_platform_init+0x0/0x12 returned 0 after 5019 usecs
[   15.622202] calling  marvell_init+0x0/0x5b @ 1
[   15.626640] bus: 'mdio_bus': add driver Marvell 88E1101
[   15.631924] bus: 'mdio_bus': add driver Marvell 88E1112
[   15.637181] bus: 'mdio_bus': add driver Marvell 88E1111
[   15.642462] bus: 'mdio_bus': add driver Marvell 88E1118
[   15.647721] bus: 'mdio_bus': add driver Marvell 88E1121R
[   15.653089] bus: 'mdio_bus': add driver Marvell 88E1145
[   15.658367] bus: 'mdio_bus': add driver Marvell 88E1240
[   15.663708] initcall marvell_init+0x0/0x5b returned 0 after 36196 usecs
[   15.670329] calling  davicom_init+0x0/0x5e @ 1
[   15.674768] bus: 'mdio_bus': add driver Davicom DM9161E
[   15.680053] bus: 'mdio_bus': add driver Davicom DM9161A
[   15.685307] bus: 'mdio_bus': add driver Davicom DM9131
[   15.690505] initcall davicom_init+0x0/0x5e returned 0 after 15364 usecs
[   15.697106] calling  cicada_init+0x0/0x3c @ 1
[   15.701542] bus: 'mdio_bus': add driver Cicada Cis8204
[   15.706728] bus: 'mdio_bus': add driver Cicada Cis8201
[   15.711937] initcall cicada_init+0x0/0x3c returned 0 after 10151 usecs
[   15.718453] calling  lxt_init+0x0/0x3c @ 1
[   15.722575] bus: 'mdio_bus': add driver LXT970
[   15.727056] bus: 'mdio_bus': add driver LXT971
[   15.731558] initcall lxt_init+0x0/0x3c returned 0 after 8772 usecs
[   15.737728] calling  smsc_init+0x0/0xa6 @ 1
[   15.741989] bus: 'mdio_bus': add driver SMSC LAN83C185
[   15.747164] bus: 'mdio_bus': add driver SMSC LAN8187
[   15.752184] bus: 'mdio_bus': add driver SMSC LAN8700
[   15.757204] bus: 'mdio_bus': add driver SMSC LAN911x Internal PHY
[   15.763356] bus: 'mdio_bus': add driver SMSC LAN8710/LAN8720
[   15.769049] initcall smsc_init+0x0/0xa6 returned 0 after 26430 usecs
[   15.775425] calling  vsc82xx_init+0x0/0x3c @ 1
[   15.779868] bus: 'mdio_bus': add driver Vitesse VSC8244
[   15.785204] bus: 'mdio_bus': add driver Vitesse VSC8221
[   15.790485] initcall vsc82xx_init+0x0/0x3c returned 0 after 10364 usecs
[   15.797086] calling  broadcom_init+0x0/0x143 @ 1
[   15.801729] bus: 'mdio_bus': add driver Broadcom BCM5411
[   15.807079] bus: 'mdio_bus': add driver Broadcom BCM5421
[   15.812477] bus: 'mdio_bus': add driver Broadcom BCM5461
[   15.817823] bus: 'mdio_bus': add driver Broadcom BCM5464
[   15.823244] bus: 'mdio_bus': add driver Broadcom BCM5481
[   15.828589] bus: 'mdio_bus': add driver Broadcom BCM5482
[   15.833956] bus: 'mdio_bus': add driver Broadcom BCM50610
[   15.839398] bus: 'mdio_bus': add driver Broadcom BCM50610M
[   15.844957] bus: 'mdio_bus': add driver Broadcom BCM57780
[   15.850414] bus: 'mdio_bus': add driver Broadcom BCMAC131
[   15.855848] initcall broadcom_init+0x0/0x143 returned 0 after 52853 usecs
[   15.862705] calling  ip175c_init+0x0/0x12 @ 1
[   15.867057] bus: 'mdio_bus': add driver ICPlus IP175C
[   15.872170] initcall ip175c_init+0x0/0x12 returned 0 after 4989 usecs
[   15.878598] calling  realtek_init+0x0/0x12 @ 1
[   15.883067] bus: 'mdio_bus': add driver RTL821x Gigabit Ethernet
[   15.889111] initcall realtek_init+0x0/0x12 returned 0 after 5906 usecs
[   15.895657] calling  fixed_mdio_bus_init+0x0/0xf7 @ 1
[   15.900774] Registering platform device 'Fixed MDIO bus.0'. Parent at platform
[   15.907987] device: 'Fixed MDIO bus.0': device_add
[   15.912833] bus: 'platform': add device Fixed MDIO bus.0
[   15.918222] device: '0': device_add
[   15.921854] Fixed MDIO Bus: probed
[   15.925256] initcall fixed_mdio_bus_init+0x0/0xf7 returned 0 after 23913 usecs
[   15.932492] calling  mdio_gpio_init+0x0/0x12 @ 1
[   15.937110] bus: 'platform': add driver mdio-gpio
[   15.941945] initcall mdio_gpio_init+0x0/0x12 returned 0 after 4717 usecs
[   15.948632] calling  ste10Xp_init+0x0/0x22 @ 1
[   15.953094] bus: 'mdio_bus': add driver STe100p
[   15.957665] bus: 'mdio_bus': add driver STe101p
[   15.962274] initcall ste10Xp_init+0x0/0x22 returned 0 after 8965 usecs
[   15.968793] calling  ksphy_init+0x0/0x5e @ 1
[   15.973087] bus: 'mdio_bus': add driver Micrel KS8001
[   15.978188] bus: 'mdio_bus': add driver Micrel VSC8201
[   15.983441] bus: 'mdio_bus': add driver Micrel KSZ9021 Gigabit PHY
[   15.989652] initcall ksphy_init+0x0/0x5e returned 0 after 16181 usecs
[   15.996114] calling  e1000_init_module+0x0/0x4c @ 1
[   16.001002] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[   16.006917] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[   16.012946] bus: 'pci': add driver e1000e
[   16.017046] initcall e1000_init_module+0x0/0x4c returned 0 after 15668 usecs
[   16.024159] calling  igb_init_module+0x0/0x58 @ 1
[   16.028855] Intel(R) Gigabit Ethernet Network Driver - version 2.1.0-k2
[   16.035485] Copyright (c) 2007-2009 Intel Corporation.
[   16.040636] bus: 'pci': add driver igb
[   16.044473] initcall igb_init_module+0x0/0x58 returned 0 after 15249 usecs
[   16.051365] calling  ixgbe_init_module+0x0/0x66 @ 1
[   16.056243] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 2.0.62-k2
[   16.064135] ixgbe: Copyright (c) 1999-2010 Intel Corporation.
[   16.069875] bus: 'pci': add driver ixgbe
[   16.073918] initcall ixgbe_init_module+0x0/0x66 returned 0 after 17255 usecs
[   16.080979] calling  ixgb_init_module+0x0/0x4c @ 1
[   16.085762] Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[   16.092391] Copyright (c) 1999-2008 Intel Corporation.
[   16.097522] bus: 'pci': add driver ixgb
[   16.101517] initcall ixgb_init_module+0x0/0x4c returned 0 after 15380 usecs
[   16.108467] calling  ipg_init_module+0x0/0x1b @ 1
[   16.113195] bus: 'pci': add driver Sundance Technology IPG Triple-Speed Ethernet
[   16.120688] initcall ipg_init_module+0x0/0x1b returned 0 after 7318 usecs
[   16.127464] calling  cxgb4_init_module+0x0/0x5b @ 1
[   16.132398] bus: 'pci': add driver cxgb4
[   16.136395] initcall cxgb4_init_module+0x0/0x5b returned 0 after 3937 usecs
[   16.143423] calling  vcan_init_module+0x0/0x37 @ 1
[   16.148204] vcan: Virtual CAN interface driver
[   16.152674] initcall vcan_init_module+0x0/0x37 returned 0 after 4360 usecs
[   16.159538] calling  can_dev_init+0x0/0x2f @ 1
[   16.164008] CAN device driver interface
[   16.167847] initcall can_dev_init+0x0/0x2f returned 0 after 3751 usecs
[   16.174388] calling  ems_usb_init+0x0/0x49 @ 1
[   16.178825] CPC-USB kernel driver loaded
[   16.182822] bus: 'usb': add driver ems_usb
[   16.186980] usbcore: registered new interface driver ems_usb
[   16.192662] initcall ems_usb_init+0x0/0x49 returned 0 after 13507 usecs
[   16.199269] calling  sja1000_init+0x0/0x1d @ 1
[   16.203735] sja1000 CAN netdevice driver
[   16.207652] initcall sja1000_init+0x0/0x1d returned 0 after 3826 usecs
[   16.214196] calling  bonding_init+0x0/0x860 @ 1
[   16.218718] bonding: Ethernet Channel Bonding Driver: v3.6.0 (September 26, 2009)
[   16.226268] bonding: Warning: either miimon or arp_interval and arp_ip_target module parameters must be specified, otherwise bonding will not detect link failures! see bonding.txt for details.
[   16.243938] device: 'bond0': device_add
[   16.249485] initcall bonding_init+0x0/0x860 returned 0 after 30043 usecs
[   16.250045] async/1 used greatest stack depth: 4128 bytes left
[   16.262161] calling  atl1_init_module+0x0/0x1b @ 1
[   16.266957] bus: 'pci': add driver atl1
[   16.270979] initcall atl1_init_module+0x0/0x1b returned 0 after 3929 usecs
[   16.277841] calling  atl2_init_module+0x0/0x4c @ 1
[   16.282656] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   16.288050] Copyright (c) 2007 Atheros Corporation.
[   16.292952] bus: 'pci': add driver atl2
[   16.296955] initcall atl2_init_module+0x0/0x4c returned 0 after 13964 usecs
[   16.303984] calling  atl1e_init_module+0x0/0x1b @ 1
[   16.308865] bus: 'pci': add driver ATL1E
[   16.312925] initcall atl1e_init_module+0x0/0x1b returned 0 after 3962 usecs
[   16.319875] calling  enic_init_module+0x0/0x37 @ 1
[   16.324689] enic: Cisco 10G Ethernet Driver, ver 1.1.0.241a
[   16.330291] bus: 'pci': add driver enic
[   16.334242] initcall enic_init_module+0x0/0x37 returned 0 after 9330 usecs
[   16.341191] calling  vmxnet3_init_module+0x0/0x37 @ 1
[   16.346240] VMware vmxnet3 virtual NIC driver - version 1.0.5.0-k-NAPI
[   16.352787] bus: 'pci': add driver vmxnet3
[   16.357002] initcall vmxnet3_init_module+0x0/0x37 returned 0 after 10506 usecs
[   16.364235] calling  plip_init+0x0/0x5d @ 1
[   16.368492] device: 'plip0': device_add
[   16.374149] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[   16.379632] plip0: Parallel port at 0x378, using IRQ 7.
[   16.384950] initcall plip_init+0x0/0x5d returned 0 after 16145 usecs
[   16.391319] calling  rr_init_module+0x0/0x1b @ 1
[   16.395944] bus: 'pci': add driver rrunner
[   16.400150] initcall rr_init_module+0x0/0x1b returned 0 after 4109 usecs
[   16.406845] calling  gem_init+0x0/0x1b @ 1
[   16.410969] bus: 'pci': add driver gem
[   16.414804] initcall gem_init+0x0/0x1b returned 0 after 3748 usecs
[   16.421060] calling  cas_init+0x0/0x3a @ 1
[   16.425156] bus: 'pci': add driver cassini
[   16.429379] initcall cas_init+0x0/0x3a returned 0 after 4128 usecs
[   16.435582] calling  vortex_init+0x0/0xac @ 1
[   16.439942] bus: 'pci': add driver 3c59x
[   16.443970] initcall vortex_init+0x0/0xac returned 0 after 3932 usecs
[   16.450426] calling  pcnet32_init_module+0x0/0x12b @ 1
[   16.455563] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[   16.462508] bus: 'pci': add driver pcnet32
[   16.466683] initcall pcnet32_init_module+0x0/0x12b returned 0 after 10856 usecs
[   16.474009] calling  e100_init_module+0x0/0x5d @ 1
[   16.478799] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   16.484913] e100: Copyright(c) 1999-2006 Intel Corporation
[   16.490416] bus: 'pci': add driver e100
[   16.494341] initcall e100_init_module+0x0/0x5d returned 0 after 15174 usecs
[   16.501378] calling  tlan_probe+0x0/0xe4 @ 1
[   16.505640] ThunderLAN driver v1.15a
[   16.509218] bus: 'pci': add driver tlan
[   16.513162] TLAN: 0 devices installed, PCI: 0  EISA: 0
[   16.518321] bus: 'pci': remove driver tlan
[   16.522468] driver: 'tlan': driver_release
[   16.526568] initcall tlan_probe+0x0/0xe4 returned -19 after 20435 usecs
[   16.533195] calling  epic_init+0x0/0x1b @ 1
[   16.537382] bus: 'pci': add driver epic100
[   16.541635] initcall epic_init+0x0/0x1b returned 0 after 4150 usecs
[   16.547899] calling  smsc9420_init_module+0x0/0x3d @ 1
[   16.553062] bus: 'pci': add driver smsc9420
[   16.557355] initcall smsc9420_init_module+0x0/0x3d returned 0 after 4196 usecs
[   16.564595] calling  sis900_init_module+0x0/0x1b @ 1
[   16.569561] bus: 'pci': add driver sis900
[   16.573675] initcall sis900_init_module+0x0/0x1b returned 0 after 4015 usecs
[   16.580792] calling  r6040_init+0x0/0x1b @ 1
[   16.585067] bus: 'pci': add driver r6040
[   16.589072] initcall r6040_init+0x0/0x1b returned 0 after 3915 usecs
[   16.595448] calling  yellowfin_init+0x0/0x1b @ 1
[   16.600077] bus: 'pci': add driver yellowfin
[   16.604432] initcall yellowfin_init+0x0/0x1b returned 0 after 4257 usecs
[   16.611153] calling  acenic_init+0x0/0x1b @ 1
[   16.615512] bus: 'pci': add driver acenic
[   16.619627] initcall acenic_init+0x0/0x1b returned 0 after 4022 usecs
[   16.626145] calling  natsemi_init_mod+0x0/0x1b @ 1
[   16.630950] bus: 'pci': add driver natsemi
[   16.635248] initcall natsemi_init_mod+0x0/0x1b returned 0 after 4201 usecs
[   16.642137] calling  fealnx_init+0x0/0x1b @ 1
[   16.646497] bus: 'pci': add driver fealnx
[   16.650623] initcall fealnx_init+0x0/0x1b returned 0 after 4027 usecs
[   16.657056] calling  tg3_init+0x0/0x1b @ 1
[   16.661237] bus: 'pci': add driver tg3
[   16.665079] initcall tg3_init+0x0/0x1b returned 0 after 3755 usecs
[   16.671284] calling  bnx2_init+0x0/0x1b @ 1
[   16.675470] bus: 'pci': add driver bnx2
[   16.679421] initcall bnx2_init+0x0/0x1b returned 0 after 3862 usecs
[   16.685704] calling  bnx2x_init+0x0/0x97 @ 1
[   16.689974] Broadcom NetXtreme II 5771x 10Gigabit Ethernet Driver bnx2x 1.52.1-7 (2010/02/28)
[   16.698645] bus: 'pci': add driver bnx2x
[   16.702770] initcall bnx2x_init+0x0/0x97 returned 0 after 12491 usecs
[   16.709205] calling  skge_init_module+0x0/0x59 @ 1
[   16.714051] bus: 'pci': add driver skge
[   16.717968] initcall skge_init_module+0x0/0x59 returned 0 after 3858 usecs
[   16.724861] calling  sky2_init_module+0x0/0x57 @ 1
[   16.729651] sky2: driver version 1.27
[   16.733359] bus: 'pci': add driver sky2
[   16.737281] initcall sky2_init_module+0x0/0x57 returned 0 after 7448 usecs
[   16.744224] calling  skfd_init+0x0/0x1b @ 1
[   16.748409] bus: 'pci': add driver skfddi
[   16.752550] initcall skfd_init+0x0/0x1b returned 0 after 4041 usecs
[   16.758804] calling  ks8842_init+0x0/0x12 @ 1
[   16.763187] bus: 'platform': add driver ks8842
[   16.767681] initcall ks8842_init+0x0/0x12 returned 0 after 4393 usecs
[   16.774138] calling  ks8851_init+0x0/0x12 @ 1
[   16.778490] bus: 'platform': add driver ks8851_mll
[   16.783403] initcall ks8851_init+0x0/0x12 returned 0 after 4794 usecs
[   16.789832] calling  rhine_init+0x0/0x63 @ 1
[   16.794130] bus: 'pci': add driver via-rhine
[   16.798481] initcall rhine_init+0x0/0x63 returned 0 after 4254 usecs
[   16.804854] calling  velocity_init_module+0x0/0x43 @ 1
[   16.809985] bus: 'pci': add driver via-velocity
[   16.814621] initcall velocity_init_module+0x0/0x43 returned 0 after 4524 usecs
[   16.821920] calling  sundance_init+0x0/0x1b @ 1
[   16.826454] bus: 'pci': add driver sundance
[   16.830764] initcall sundance_init+0x0/0x1b returned 0 after 4207 usecs
[   16.837368] calling  hamachi_init+0x0/0x1b @ 1
[   16.841840] bus: 'pci': add driver hamachi
[   16.846019] initcall hamachi_init+0x0/0x1b returned 0 after 4085 usecs
[   16.852564] calling  net_olddevs_init+0x0/0xae @ 1
[   16.857592] D-Link DE-620 pocket adapter io 0x378, which is busy.
[   16.863789] initcall net_olddevs_init+0x0/0xae returned 0 after 6287 usecs
[   16.870680] calling  init_nic+0x0/0x1b @ 1
[   16.874780] bus: 'pci': add driver forcedeth
[   16.879074] bus: 'pci': driver_probe_device: matched device 0000:00:0a.0 with driver forcedeth
[   16.887700] bus: 'pci': really_probe: probing driver forcedeth with device 0000:00:0a.0
[   16.895848] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[   16.896201]  sda:
[   16.906709] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
[   16.909213]  sda1 sda2 sda3 <
[   16.915487] forcedeth 0000:00:0a.0: PCI INT A -> Link[APCH] -> GSI 23 (level, low) -> IRQ 23
[   16.922465]  sda5
[   16.925895] forcedeth 0000:00:0a.0: setting latency timer to 64
[   16.930607]  sda6
[   16.933830] nv_probe: set workaround bit for reversed mac addr
[   16.944198]  sda7 sda8 sda9 sda10 >
[   16.987935] device: 'sda1': device_add
[   16.991881] device: 'sda2': device_add
[   16.995772] device: 'sda3': device_add
[   16.999664] device: 'sda5': device_add
[   17.003537] device: 'sda6': device_add
[   17.007359] device: 'sda7': device_add
[   17.011317] device: 'sda8': device_add
[   17.015143] device: 'sda9': device_add
[   17.018992] device: 'sda10': device_add
[   17.023837] device: '8:0': device_add
[   17.028182] sd 0:0:0:0: [sda] Attached SCSI disk
[   17.032918] initcall 4_sd_probe_async+0x0/0x1e3 returned 0 after 1943471 usecs
[   17.470230] device: 'eth0': device_add
[   17.475829] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
[   17.484197] forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
[   17.490585] driver: '0000:00:0a.0': driver_bound: bound to device 'forcedeth'
[   17.497709] bus: 'pci': really_probe: bound device 0000:00:0a.0 to driver forcedeth
[   17.505457] initcall init_nic+0x0/0x1b returned 0 after 615891 usecs
[   17.511818] calling  ql3xxx_init_module+0x0/0x1b @ 1
[   17.516787] bus: 'pci': add driver qla3xxx
[   17.520995] initcall ql3xxx_init_module+0x0/0x1b returned 0 after 4114 usecs
[   17.528032] calling  qlcnic_init_module+0x0/0x48 @ 1
[   17.533017] QLogic Converged Ethernet Driver v5.0.0
[   17.537895] bus: 'pci': add driver qlcnic
[   17.541997] initcall qlcnic_init_module+0x0/0x48 returned 0 after 8767 usecs
[   17.549031] calling  qlge_init_module+0x0/0x1b @ 1
[   17.553846] bus: 'pci': add driver qlge
[   17.557779] initcall qlge_init_module+0x0/0x1b returned 0 after 3845 usecs
[   17.564666] calling  ppp_init+0x0/0xe1 @ 1
[   17.568758] PPP generic driver version 2.4.2
[   17.573064] device class 'ppp': registering
[   17.577284] device: 'ppp': device_add
[   17.581090] initcall ppp_init+0x0/0xe1 returned 0 after 12036 usecs
[   17.587348] calling  ppp_async_init+0x0/0x36 @ 1
[   17.591989] initcall ppp_async_init+0x0/0x36 returned 0 after 3 usecs
[   17.598424] calling  ppp_sync_init+0x0/0x36 @ 1
[   17.602978] initcall ppp_sync_init+0x0/0x36 returned 0 after 2 usecs
[   17.609328] calling  deflate_init+0x0/0x3b @ 1
[   17.613811] PPP Deflate Compression module registered
[   17.618856] initcall deflate_init+0x0/0x3b returned 0 after 4949 usecs
[   17.625393] calling  bsdcomp_init+0x0/0x2f @ 1
[   17.629837] PPP BSD Compression module registered
[   17.634557] initcall bsdcomp_init+0x0/0x2f returned 0 after 4606 usecs
[   17.641090] calling  ppp_mppe_init+0x0/0xbe @ 1
[   17.645998] PPP MPPE Compression module registered
[   17.650811] initcall ppp_mppe_init+0x0/0xbe returned 0 after 5064 usecs
[   17.657420] calling  pppox_init+0x0/0x12 @ 1
[   17.661714] NET: Registered protocol family 24
[   17.666158] initcall pppox_init+0x0/0x12 returned 0 after 4343 usecs
[   17.672529] calling  pppol2tp_init+0x0/0x79 @ 1
[   17.677118] PPPoL2TP kernel driver, V1.0
[   17.681121] initcall pppol2tp_init+0x0/0x79 returned 0 after 3969 usecs
[   17.687726] calling  dummy_init_module+0x0/0xb7 @ 1
[   17.692708] device: 'dummy0': device_add
[   17.698511] initcall dummy_init_module+0x0/0xb7 returned 0 after 5747 usecs
[   17.705491] calling  ifb_init_module+0x0/0xb7 @ 1
[   17.710243] device: 'ifb0': device_add
[   17.715876] device: 'ifb1': device_add
[   17.721726] initcall ifb_init_module+0x0/0xb7 returned 0 after 11243 usecs
[   17.728590] calling  macvlan_init_module+0x0/0x53 @ 1
[   17.733673] initcall macvlan_init_module+0x0/0x53 returned 0 after 6 usecs
[   17.740567] calling  de600_init+0x0/0x382 @ 1
[   17.744930] DE600: port 0x378 busy
[   17.748338] initcall de600_init+0x0/0x382 returned -16 after 3339 usecs
[   17.754969] initcall de600_init+0x0/0x382 returned with error code -16 
[   17.761651] calling  dfx_init+0x0/0x1b @ 1
[   17.765759] bus: 'pci': add driver defxx
[   17.769780] initcall dfx_init+0x0/0x1b returned 0 after 3941 usecs
[   17.775976] calling  rtl8139_init_module+0x0/0x1b @ 1
[   17.781050] bus: 'pci': add driver 8139too
[   17.785188] bus: 'pci': driver_probe_device: matched device 0000:05:07.0 with driver 8139too
[   17.793638] bus: 'pci': really_probe: probing driver 8139too with device 0000:05:07.0
[   17.801671] 8139too: 8139too Fast Ethernet driver 0.9.28
[   17.807847] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
[   17.813727] 8139too 0000:05:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
[   17.822336] device: 'eth1': device_add
[   17.827981] 8139too 0000:05:07.0: eth1: RealTek RTL8139 at 0xc000, 00:c0:df:03:68:5d, IRQ 17
[   17.836458] driver: '0000:05:07.0': driver_bound: bound to device '8139too'
[   17.843437] bus: 'pci': really_probe: bound device 0000:05:07.0 to driver 8139too
[   17.850986] initcall rtl8139_init_module+0x0/0x1b returned 0 after 68298 usecs
[   17.858201] calling  atp_init_module+0x0/0x9a @ 1
[   17.862924] atp.c:v1.09=ac 2002/10/01 Donald Becker <becker@scyld.com>
[   17.869475] initcall atp_init_module+0x0/0x9a returned -19 after 6401 usecs
[   17.876445] calling  tun_init+0x0/0x93 @ 1
[   17.880558] tun: Universal TUN/TAP device driver, 1.6
[   17.885606] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   17.891802] device: 'tun': device_add
[   17.895539] initcall tun_init+0x0/0x93 returned 0 after 14631 usecs
[   17.901823] calling  veth_init+0x0/0x12 @ 1
[   17.906005] initcall veth_init+0x0/0x12 returned 0 after 3 usecs
[   17.912022] calling  rtl8169_init_module+0x0/0x1b @ 1
[   17.917077] bus: 'pci': add driver r8169
[   17.921111] initcall rtl8169_init_module+0x0/0x1b returned 0 after 3940 usecs
[   17.928237] calling  amd8111e_init+0x0/0x1b @ 1
[   17.932792] bus: 'pci': add driver amd8111e
[   17.937146] initcall amd8111e_init+0x0/0x1b returned 0 after 4255 usecs
[   17.943771] calling  mlx4_init+0x0/0xa2 @ 1
[   17.948076] bus: 'pci': add driver mlx4_core
[   17.952491] initcall mlx4_init+0x0/0xa2 returned 0 after 4428 usecs
[   17.958746] calling  ethoc_init+0x0/0x12 @ 1
[   17.963043] bus: 'platform': add driver ethoc
[   17.967447] initcall ethoc_init+0x0/0x12 returned 0 after 4305 usecs
[   17.973813] calling  ipddp_init_module+0x0/0xf7 @ 1
[   17.978695] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.umn.edu>
[   17.986351] device: 'ipddp0': device_add
[   17.992520] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <johns393@maroon.tc.umn.edu>
[   18.001319] initcall ipddp_init_module+0x0/0xf7 returned 0 after 22092 usecs
[   18.008354] calling  arcnet_init+0x0/0x5d @ 1
[   18.012734] arcnet loaded.
[   18.015440] initcall arcnet_init+0x0/0x5d returned 0 after 2643 usecs
[   18.021951] calling  arcnet_rfc1051_init+0x0/0x47 @ 1
[   18.026997] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
[   18.034498] initcall arcnet_rfc1051_init+0x0/0x47 returned 0 after 7320 usecs
[   18.041740] calling  arcnet_raw_init+0x0/0x5e @ 1
[   18.046436] arcnet: raw mode (`r') encapsulation support loaded.
[   18.052467] initcall arcnet_raw_init+0x0/0x5e returned 0 after 5883 usecs
[   18.059246] calling  com90io_init+0x0/0x492 @ 1
[   18.063859] arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
[   18.071085] E-mail me if you actually test this driver, please!
[   18.076994]  arc%d: No autoprobe for IO mapped cards; you must specify the base address!
[   18.085110] initcall com90io_init+0x0/0x492 returned -19 after 20761 usecs
[   18.091999] calling  arc_rimi_init+0x0/0x4b9 @ 1
[   18.096615] arcnet: RIM I (entirely mem-mapped) support
[   18.101902] E-mail me if you actually test the RIM I driver, please!
[   18.108247]  arc%d: Given: node 00h, shmem 0h, irq 0
[   18.113231]  arc%d: No autoprobe for RIM I; you must specify the shmem and irq!
[   18.120555] initcall arc_rimi_init+0x0/0x4b9 returned -5 after 23379 usecs
[   18.127418] initcall arc_rimi_init+0x0/0x4b9 returned with error code -5 
[   18.134225] calling  com20020pci_init+0x0/0x32 @ 1
[   18.139006] arcnet: COM20020 PCI support
[   18.143008] bus: 'pci': add driver com20020
[   18.147288] initcall com20020pci_init+0x0/0x32 returned 0 after 8085 usecs
[   18.154177] calling  init_tc574+0x0/0x12 @ 1
[   18.158450] bus: 'pcmcia': add driver 3c574_cs
[   18.162962] initcall init_tc574+0x0/0x12 returned 0 after 4404 usecs
[   18.169306] calling  init_nmclan_cs+0x0/0x12 @ 1
[   18.173949] bus: 'pcmcia': add driver nmclan_cs
[   18.178524] initcall init_nmclan_cs+0x0/0x12 returned 0 after 4473 usecs
[   18.185294] calling  init_pcnet_cs+0x0/0x12 @ 1
[   18.189862] bus: 'pcmcia': add driver pcnet_cs
[   18.194389] initcall init_pcnet_cs+0x0/0x12 returned 0 after 4456 usecs
[   18.201023] calling  init_smc91c92_cs+0x0/0x12 @ 1
[   18.205818] bus: 'pcmcia': add driver smc91c92_cs
[   18.210605] initcall init_smc91c92_cs+0x0/0x12 returned 0 after 4676 usecs
[   18.217465] calling  init_xirc2ps_cs+0x0/0x12 @ 1
[   18.222255] bus: 'pcmcia': add driver xirc2ps_cs
[   18.226919] initcall init_xirc2ps_cs+0x0/0x12 returned 0 after 4561 usecs
[   18.233721] calling  init_com20020_cs+0x0/0x12 @ 1
[   18.238514] bus: 'pcmcia': add driver com20020_cs
[   18.243285] initcall init_com20020_cs+0x0/0x12 returned 0 after 4656 usecs
[   18.250171] calling  catc_init+0x0/0x39 @ 1
[   18.254356] bus: 'usb': add driver catc
[   18.258241] usbcore: registered new interface driver catc
[   18.263725] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[   18.269642] initcall catc_init+0x0/0x39 returned 0 after 14929 usecs
[   18.276014] calling  kaweth_init+0x0/0x1b @ 1
[   18.280391] bus: 'usb': add driver kaweth
[   18.284503] usbcore: registered new interface driver kaweth
[   18.290091] initcall kaweth_init+0x0/0x1b returned 0 after 9471 usecs
[   18.296524] calling  pegasus_init+0x0/0x16b @ 1
[   18.301130] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[   18.308605] bus: 'usb': add driver pegasus
[   18.312773] usbcore: registered new interface driver pegasus
[   18.318428] initcall pegasus_init+0x0/0x16b returned 0 after 16895 usecs
[   18.325146] calling  usb_rtl8150_init+0x0/0x29 @ 1
[   18.329936] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
[   18.336840] bus: 'usb': add driver rtl8150
[   18.341054] usbcore: registered new interface driver rtl8150
[   18.346709] initcall usb_rtl8150_init+0x0/0x29 returned 0 after 16378 usecs
[   18.353685] calling  hso_init+0x0/0x1a7 @ 1
[   18.357860] hso: drivers/net/usb/hso.c: 1.2 Option Wireless
[   18.363466] bus: 'usb': add driver hso
[   18.367262] usbcore: registered new interface driver hso
[   18.372590] initcall hso_init+0x0/0x1a7 returned 0 after 14379 usecs
[   18.378936] calling  asix_init+0x0/0x1b @ 1
[   18.383196] bus: 'usb': add driver asix
[   18.387083] usbcore: registered new interface driver asix
[   18.392496] initcall asix_init+0x0/0x1b returned 0 after 9081 usecs
[   18.398757] calling  cdc_init+0x0/0x1b @ 1
[   18.402881] bus: 'usb': add driver cdc_ether
[   18.407210] usbcore: registered new interface driver cdc_ether
[   18.413065] initcall cdc_init+0x0/0x1b returned 0 after 9945 usecs
[   18.419237] calling  eem_init+0x0/0x1b @ 1
[   18.423411] bus: 'usb': add driver cdc_eem
[   18.427556] usbcore: registered new interface driver cdc_eem
[   18.433231] initcall eem_init+0x0/0x1b returned 0 after 9589 usecs
[   18.439405] calling  smsc75xx_init+0x0/0x1b @ 1
[   18.443959] bus: 'usb': add driver smsc75xx
[   18.448192] usbcore: registered new interface driver smsc75xx
[   18.453954] initcall smsc75xx_init+0x0/0x1b returned 0 after 9759 usecs
[   18.460633] calling  smsc95xx_init+0x0/0x1b @ 1
[   18.465156] bus: 'usb': add driver smsc95xx
[   18.469388] usbcore: registered new interface driver smsc95xx
[   18.475152] initcall smsc95xx_init+0x0/0x1b returned 0 after 9757 usecs
[   18.481781] calling  plusb_init+0x0/0x1b @ 1
[   18.486052] bus: 'usb': add driver plusb
[   18.490068] usbcore: registered new interface driver plusb
[   18.495552] initcall plusb_init+0x0/0x1b returned 0 after 9277 usecs
[   18.501974] calling  rndis_init+0x0/0x1b @ 1
[   18.506248] bus: 'usb': add driver rndis_host
[   18.510670] usbcore: registered new interface driver rndis_host
[   18.516585] initcall rndis_init+0x0/0x1b returned 0 after 10096 usecs
[   18.523047] calling  mcs7830_init+0x0/0x1b @ 1
[   18.527490] bus: 'usb': add driver MOSCHIP usb-ethernet driver
[   18.533386] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   18.540846] initcall mcs7830_init+0x0/0x1b returned 0 after 13039 usecs
[   18.547454] calling  usbnet_init+0x0/0x2b @ 1
[   18.551858] initcall usbnet_init+0x0/0x2b returned 0 after 11 usecs
[   18.558123] calling  usbpn_init+0x0/0x1b @ 1
[   18.562417] bus: 'usb': add driver cdc_phonet
[   18.566823] usbcore: registered new interface driver cdc_phonet
[   18.572758] initcall usbpn_init+0x0/0x1b returned 0 after 10098 usecs
[   18.579191] calling  ipheth_init+0x0/0x3b @ 1
[   18.583625] bus: 'usb': add driver ipheth
[   18.587719] usbcore: registered new interface driver ipheth
[   18.593308] initcall ipheth_init+0x0/0x3b returned 0 after 9456 usecs
[   18.599739] calling  sierra_net_init+0x0/0x1b @ 1
[   18.604468] bus: 'usb': add driver sierra_net
[   18.608870] usbcore: registered new interface driver sierra_net
[   18.614810] initcall sierra_net_init+0x0/0x1b returned 0 after 10099 usecs
[   18.621747] calling  airo_init_module+0x0/0xe7 @ 1
[   18.626547] airo(): Probing for PCI adapters
[   18.630843] bus: 'pci': add driver airo
[   18.634766] airo(): Finished probing for PCI adapters
[   18.639815] initcall airo_init_module+0x0/0xe7 returned 0 after 12973 usecs
[   18.646797] calling  atmel_cs_init+0x0/0x12 @ 1
[   18.651351] bus: 'pcmcia': add driver atmel_cs
[   18.655839] initcall atmel_cs_init+0x0/0x12 returned 0 after 4390 usecs
[   18.662518] calling  at76_mod_init+0x0/0x76 @ 1
[   18.667047] Atmel at76x USB Wireless LAN Driver 0.17 loading
[   18.672727] bus: 'usb': add driver at76c50x-usb
[   18.677308] usbcore: registered new interface driver at76c50x-usb
[   18.683485] initcall at76_mod_init+0x0/0x76 returned 0 after 16048 usecs
[   18.690199] calling  hostap_init+0x0/0x45 @ 1
[   18.694585] initcall hostap_init+0x0/0x45 returned 0 after 27 usecs
[   18.700920] calling  init_prism2_plx+0x0/0x1b @ 1
[   18.705627] bus: 'pci': add driver hostap_plx
[   18.710102] initcall init_prism2_plx+0x0/0x1b returned 0 after 4368 usecs
[   18.716879] calling  init_prism2_pci+0x0/0x1b @ 1
[   18.721611] bus: 'pci': add driver hostap_pci
[   18.726051] initcall init_prism2_pci+0x0/0x1b returned 0 after 4340 usecs
[   18.732858] calling  b43_init+0x0/0x4c @ 1
[   18.736957] bus: 'ssb': add driver b43
[   18.740822] Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]
[   18.747777] initcall b43_init+0x0/0x4c returned 0 after 10569 usecs
[   18.754064] calling  b43legacy_init+0x0/0x59 @ 1
[   18.758702] bus: 'ssb': add driver b43legacy
[   18.763035] Broadcom 43xx-legacy driver loaded [ Features: PLI, Firmware-ID: FW10 ]
[   18.770707] initcall b43legacy_init+0x0/0x59 returned 0 after 11747 usecs
[   18.777486] calling  usb_init+0x0/0x103 @ 1
[   18.781868] bus: 'usb': add driver zd1211rw
[   18.786121] usbcore: registered new interface driver zd1211rw
[   18.791893] initcall usb_init+0x0/0x103 returned 0 after 9905 usecs
[   18.798149] calling  init_ray_cs+0x0/0x11b @ 1
[   18.802615] bus: 'pcmcia': add driver ray_cs
[   18.806973] initcall init_ray_cs+0x0/0x11b returned 0 after 4261 usecs
[   18.813513] calling  wl3501_init_module+0x0/0x12 @ 1
[   18.818475] bus: 'pcmcia': add driver wl3501_cs
[   18.823067] initcall wl3501_init_module+0x0/0x12 returned 0 after 4481 usecs
[   18.830129] calling  rndis_wlan_init+0x0/0x1b @ 1
[   18.834829] bus: 'usb': add driver rndis_wlan
[   18.839284] usbcore: registered new interface driver rndis_wlan
[   18.845219] initcall rndis_wlan_init+0x0/0x1b returned 0 after 10143 usecs
[   18.852098] calling  zd1201_init+0x0/0x1b @ 1
[   18.856454] bus: 'usb': add driver zd1201
[   18.860523] usbcore: registered new interface driver zd1201
[   18.866088] initcall zd1201_init+0x0/0x1b returned 0 after 9409 usecs
[   18.872544] calling  lbs_init_module+0x0/0xcf @ 1
[   18.877271] initcall lbs_init_module+0x0/0xcf returned 0 after 26 usecs
[   18.883895] calling  if_usb_init_module+0x0/0xbc @ 1
[   18.888857] bus: 'usb': add driver usb8xxx
[   18.893021] usbcore: registered new interface driver usb8xxx
[   18.898676] initcall if_usb_init_module+0x0/0xbc returned 0 after 9589 usecs
[   18.905739] calling  if_cs_init+0x0/0xb9 @ 1
[   18.910027] bus: 'pcmcia': add driver libertas_cs
[   18.914771] initcall if_cs_init+0x0/0xb9 returned 0 after 4637 usecs
[   18.921138] calling  lbtf_init_module+0x0/0x44 @ 1
[   18.926155] initcall lbtf_init_module+0x0/0x44 returned 0 after 220 usecs
[   18.933005] calling  iwl_init+0x0/0x76 @ 1
[   18.937096] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[   18.944417] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   18.950102] bus: 'pci': add driver iwlagn
[   18.954221] initcall iwl_init+0x0/0x76 returned 0 after 16722 usecs
[   18.960507] calling  iwl3945_init+0x0/0x76 @ 1
[   18.964951] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:ds
[   18.974226] iwl3945: Copyright(c) 2003-2010 Intel Corporation
[   18.979974] bus: 'pci': add driver iwl3945
[   18.984172] initcall iwl3945_init+0x0/0x76 returned 0 after 18765 usecs
[   18.990802] calling  p54u_init+0x0/0x1b @ 1
[   18.994984] bus: 'usb': add driver p54usb
[   18.999037] usbcore: registered new interface driver p54usb
[   19.004631] initcall p54u_init+0x0/0x1b returned 0 after 9418 usecs
[   19.011036] calling  p54p_init+0x0/0x1b @ 1
[   19.015223] bus: 'pci': add driver p54pci
[   19.019310] initcall p54p_init+0x0/0x1b returned 0 after 3997 usecs
[   19.025594] calling  ar9170_init+0x0/0x1b @ 1
[   19.029946] bus: 'usb': add driver ar9170usb
[   19.034325] usbcore: registered new interface driver ar9170usb
[   19.040175] initcall ar9170_init+0x0/0x1b returned 0 after 9986 usecs
[   19.046607] calling  init_baycomserfdx+0x0/0x106 @ 1
[   19.051638] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   19.051640] baycom_ser_fdx: version 0.10 compiled 20:45:09 May 21 2010
[   19.064635] device: 'bcsf0': device_add
[   19.070674] device: 'bcsf1': device_add
[   19.076689] device: 'bcsf2': device_add
[   19.082960] device: 'bcsf3': device_add
[   19.089105] initcall init_baycomserfdx+0x0/0x106 returned 0 after 36591 usecs
[   19.096310] calling  hdlcdrv_init_driver+0x0/0x24 @ 1
[   19.101377] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[   19.107118] hdlcdrv: version 0.8 compiled 20:45:12 May 21 2010
[   19.112964] initcall hdlcdrv_init_driver+0x0/0x24 returned 0 after 11314 usecs
[   19.120199] calling  usb_irda_init+0x0/0x3a @ 1
[   19.124727] bus: 'usb': add driver irda-usb
[   19.128955] usbcore: registered new interface driver irda-usb
[   19.134800] USB IrDA support registered
[   19.138634] initcall usb_irda_init+0x0/0x3a returned 0 after 13583 usecs
[   19.145351] calling  nsc_ircc_init+0x0/0x203 @ 1
[   19.149964] bus: 'platform': add driver nsc-ircc
[   19.154653] bus: 'pnp': add driver nsc-ircc
[   19.158933] bus: 'platform': remove driver nsc-ircc
[   19.163861] driver: 'nsc-ircc': driver_release
[   19.168317] bus: 'pnp': remove driver nsc-ircc
[   19.172854] driver: 'nsc-ircc': driver_release
[   19.177299] initcall nsc_ircc_init+0x0/0x203 returned -19 after 26696 usecs
[   19.184273] calling  w83977af_init+0x0/0x4c6 @ 1
[   19.188938] initcall w83977af_init+0x0/0x4c6 returned -19 after 52 usecs
[   19.195657] calling  smsc_ircc_init+0x0/0x527 @ 1
[   19.200378] bus: 'platform': add driver smsc-ircc2
[   19.205446] bus: 'platform': remove driver smsc-ircc2
[   19.210588] driver: 'smsc-ircc2': driver_release
[   19.215208] initcall smsc_ircc_init+0x0/0x527 returned -19 after 14486 usecs
[   19.222270] calling  vlsi_mod_init+0x0/0x133 @ 1
[   19.226907] bus: 'pci': add driver vlsi_ir
[   19.231118] initcall vlsi_mod_init+0x0/0x133 returned 0 after 4135 usecs
[   19.237815] calling  via_ircc_init+0x0/0x21 @ 1
[   19.242372] bus: 'pci': add driver via-ircc
[   19.246634] initcall via_ircc_init+0x0/0x21 returned 0 after 4167 usecs
[   19.253307] calling  mcs_init+0x0/0x43 @ 1
[   19.257405] bus: 'usb': add driver mcs7780
[   19.261611] usbcore: registered new interface driver mcs7780
[   19.267267] initcall mcs_init+0x0/0x43 returned 0 after 9633 usecs
[   19.273463] calling  irtty_sir_init+0x0/0x3f @ 1
[   19.278076] initcall irtty_sir_init+0x0/0x3f returned 0 after 3 usecs
[   19.284529] calling  sir_wq_init+0x0/0x35 @ 1
[   19.289000] initcall sir_wq_init+0x0/0x35 returned 0 after 110 usecs
[   19.295366] calling  tekram_sir_init+0x0/0x2b @ 1
[   19.300121] initcall tekram_sir_init+0x0/0x2b returned 0 after 33 usecs
[   19.306724] calling  actisys_sir_init+0x0/0x43 @ 1
[   19.311539] initcall actisys_sir_init+0x0/0x43 returned 0 after 4 usecs
[   19.318146] calling  litelink_sir_init+0x0/0x12 @ 1
[   19.323049] initcall litelink_sir_init+0x0/0x12 returned 0 after 2 usecs
[   19.329742] calling  old_belkin_sir_init+0x0/0x12 @ 1
[   19.334829] initcall old_belkin_sir_init+0x0/0x12 returned 0 after 2 usecs
[   19.341710] calling  mcp2120_sir_init+0x0/0x12 @ 1
[   19.346500] initcall mcp2120_sir_init+0x0/0x12 returned 0 after 3 usecs
[   19.353125] calling  toim3232_sir_init+0x0/0x2b @ 1
[   19.358002] initcall toim3232_sir_init+0x0/0x2b returned 0 after 3 usecs
[   19.364713] calling  init_netconsole+0x0/0x211 @ 1
[   19.369542] console [netcon0] enabled
[   19.373223] netconsole: network logging started
[   19.377751] initcall init_netconsole+0x0/0x211 returned 0 after 8057 usecs
[   19.384637] calling  niu_init+0x0/0x3d @ 1
[   19.388738] bus: 'pci': add driver niu
[   19.392615] initcall niu_init+0x0/0x3d returned 0 after 3789 usecs
[   19.398790] calling  efx_init_module+0x0/0xd5 @ 1
[   19.403518] Solarflare NET driver v3.0
[   19.410205] bus: 'pci': add driver sfc
[   19.414136] initcall efx_init_module+0x0/0xd5 returned 0 after 10370 usecs
[   19.421023] calling  fusion_init+0x0/0x13b @ 1
[   19.425459] Fusion MPT base driver 3.04.14
[   19.429554] Copyright (c) 1999-2008 LSI Corporation
[   19.434481] initcall fusion_init+0x0/0x13b returned 0 after 8805 usecs
[   19.441016] calling  mptspi_init+0x0/0xe0 @ 1
[   19.445367] Fusion MPT SPI Host driver 3.04.14
[   19.449818] bus: 'pci': add driver mptspi
[   19.453933] initcall mptspi_init+0x0/0xe0 returned 0 after 8360 usecs
[   19.460387] calling  mptfc_init+0x0/0xf3 @ 1
[   19.464652] Fusion MPT FC Host driver 3.04.14
[   19.469024] bus: 'pci': add driver mptfc
[   19.473061] initcall mptfc_init+0x0/0xf3 returned 0 after 8207 usecs
[   19.479410] calling  fw_core_init+0x0/0x90 @ 1
[   19.483960] bus: 'firewire': registered
[   19.487852] initcall fw_core_init+0x0/0x90 returned 0 after 3886 usecs
[   19.494395] calling  fw_ohci_init+0x0/0x1b @ 1
[   19.498838] bus: 'pci': add driver firewire_ohci
[   19.503560] initcall fw_ohci_init+0x0/0x1b returned 0 after 4610 usecs
[   19.510098] calling  sbp2_init+0x0/0x45 @ 1
[   19.514389] bus: 'firewire': add driver sbp2
[   19.518703] initcall sbp2_init+0x0/0x45 returned 0 after 4318 usecs
[   19.524986] calling  fwnet_init+0x0/0x74 @ 1
[   19.529258] bus: 'firewire': add driver net
[   19.533497] initcall fwnet_init+0x0/0x74 returned 0 after 4140 usecs
[   19.539842] calling  uio_init+0x0/0x8 @ 1
[   19.543878] initcall uio_init+0x0/0x8 returned 0 after 1 usecs
[   19.549706] calling  hilscher_init_module+0x0/0x1b @ 1
[   19.554874] bus: 'pci': add driver hilscher
[   19.559203] initcall hilscher_init_module+0x0/0x1b returned 0 after 4238 usecs
[   19.566435] calling  uio_pdrv_genirq_init+0x0/0x12 @ 1
[   19.571586] bus: 'platform': add driver uio_pdrv_genirq
[   19.576857] initcall uio_pdrv_genirq_init+0x0/0x12 returned 0 after 5152 usecs
[   19.584089] calling  aectc_init+0x0/0x1b @ 1
[   19.588357] bus: 'pci': add driver aectc
[   19.592382] initcall aectc_init+0x0/0x1b returned 0 after 3930 usecs
[   19.598724] calling  sercos3_init_module+0x0/0x1b @ 1
[   19.603801] bus: 'pci': add driver sercos3
[   19.607975] initcall sercos3_init_module+0x0/0x1b returned 0 after 4080 usecs
[   19.615124] calling  init+0x0/0x29 @ 1
[   19.618869] Generic UIO driver for PCI 2.3 devices version: 0.01.0
[   19.625067] bus: 'pci': add driver uio_pci_generic
[   19.629939] initcall init+0x0/0x29 returned 0 after 10809 usecs
[   19.635873] calling  netx_init_module+0x0/0x1b @ 1
[   19.640678] bus: 'pci': add driver netx
[   19.644620] initcall netx_init_module+0x0/0x1b returned 0 after 3853 usecs
[   19.651509] calling  cdrom_init+0x0/0x6a @ 1
[   19.655774] initcall cdrom_init+0x0/0x6a returned 0 after 1 usecs
[   19.661880] calling  nonstatic_sysfs_init+0x0/0x12 @ 1
[   19.667019] initcall nonstatic_sysfs_init+0x0/0x12 returned 0 after 5 usecs
[   19.673997] calling  yenta_socket_init+0x0/0x1b @ 1
[   19.678871] bus: 'pci': add driver yenta_cardbus
[   19.683590] initcall yenta_socket_init+0x0/0x1b returned 0 after 4606 usecs
[   19.690566] calling  pd6729_module_init+0x0/0x1b @ 1
[   19.695529] bus: 'pci': add driver pd6729
[   19.699614] initcall pd6729_module_init+0x0/0x1b returned 0 after 3994 usecs
[   19.706681] calling  i82092aa_module_init+0x0/0x1b @ 1
[   19.711831] bus: 'pci': add driver i82092aa
[   19.716094] initcall i82092aa_module_init+0x0/0x1b returned 0 after 4168 usecs
[   19.723329] calling  aoe_init+0x0/0xac @ 1
[   19.727429] device class 'aoe': registering
[   19.731745] device: 'err': device_add
[   19.735601] device: 'discover': device_add
[   19.739793] device: 'interfaces': device_add
[   19.744185] device: 'revalidate': device_add
[   19.748583] device: 'flush': device_add
[   19.752537] aoe: AoE v47 initialised.
[   19.756386] initcall aoe_init+0x0/0xac returned 0 after 28284 usecs
[   19.762671] calling  uwb_subsys_init+0x0/0x51 @ 1
[   19.767388] device class 'uwb_rc': registering
[   19.771950] initcall uwb_subsys_init+0x0/0x51 returned 0 after 4464 usecs
[   19.778725] calling  wlp_subsys_init+0x0/0x8 @ 1
[   19.783368] initcall wlp_subsys_init+0x0/0x8 returned 0 after 1 usecs
[   19.789801] calling  hwarc_driver_init+0x0/0x1b @ 1
[   19.794711] bus: 'usb': add driver hwa-rc
[   19.798772] usbcore: registered new interface driver hwa-rc
[   19.804365] initcall hwarc_driver_init+0x0/0x1b returned 0 after 9431 usecs
[   19.811339] calling  i1480_dfu_driver_init+0x0/0x1b @ 1
[   19.816558] bus: 'usb': add driver i1480-dfu-usb
[   19.821238] usbcore: registered new interface driver i1480-dfu-usb
[   19.827409] initcall i1480_dfu_driver_init+0x0/0x1b returned 0 after 10598 usecs
[   19.834828] calling  i1480_est_init+0x0/0x81 @ 1
[   19.839459] initcall i1480_est_init+0x0/0x81 returned 0 after 10 usecs
[   19.845999] calling  i1480u_driver_init+0x0/0x1b @ 1
[   19.850976] bus: 'usb': add driver i1480u_wlp
[   19.855427] usbcore: registered new interface driver i1480u_wlp
[   19.861366] initcall i1480u_driver_init+0x0/0x1b returned 0 after 10147 usecs
[   19.868494] calling  gpio_vbus_init+0x0/0x19 @ 1
[   19.873139] bus: 'platform': add driver gpio-vbus
[   19.877892] bus: 'platform': remove driver gpio-vbus
[   19.882902] driver: 'gpio-vbus': driver_release
[   19.887429] initcall gpio_vbus_init+0x0/0x19 returned -19 after 13960 usecs
[   19.894409] calling  ehci_hcd_init+0x0/0xe7 @ 1
[   19.898935] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   19.905478] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[   19.911522] bus: 'pci': add driver ehci_hcd
[   19.915740] bus: 'pci': driver_probe_device: matched device 0000:00:02.1 with driver ehci_hcd
[   19.924276] bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:00:02.1
[   19.933640] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
[   19.939399] ehci_hcd 0000:00:02.1: PCI INT B -> Link[APCL] -> GSI 22 (level, low) -> IRQ 22
[   19.947804] ehci_hcd 0000:00:02.1: setting latency timer to 64
[   19.953655] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   19.959129] drivers/usb/core/inode.c: creating file 'devices'
[   19.964949] drivers/usb/core/inode.c: creating file '001'
[   19.970402] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[   19.977790] ehci_hcd 0000:00:02.1: reset hcs_params 0x10148a dbg=1 cc=1 pcc=4 !ppc ports=10
[   19.986165] ehci_hcd 0000:00:02.1: reset portroute 0 0 0 0 0 0 0 0 0 0 
[   19.992789] ehci_hcd 0000:00:02.1: reset hcc_params a086 caching frame 256/512/1024 park
[   20.000979] ehci_hcd 0000:00:02.1: park 0
[   20.004991] ehci_hcd 0000:00:02.1: debug port 1
[   20.009521] ehci_hcd 0000:00:02.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
[   20.018243] ehci_hcd 0000:00:02.1: bogus port configuration: cc=1 x pcc=4 < ports=10
[   20.025993] ehci_hcd 0000:00:02.1: supports USB remote wakeup
[   20.031829] ehci_hcd 0000:00:02.1: irq 22, io mem 0x40000000
[   20.037483] ehci_hcd 0000:00:02.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
[   20.046357] ehci_hcd 0000:00:02.1: init command 010009 (park)=0 ithresh=1 period=256 RUN
[   20.070048] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[   20.076018] usb usb1: default language 0x0409
[   20.080455] usb usb1: udev 1, busnum 1, minor = 0
[   20.085156] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   20.091966] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   20.099178] usb usb1: Product: EHCI Host Controller
[   20.104080] usb usb1: Manufacturer: Linux 2.6.34-tip+ ehci_hcd
[   20.109908] usb usb1: SerialNumber: 0000:00:02.1
[   20.114550] device: 'usb1': device_add
[   20.118557] bus: 'usb': add device usb1
[   20.122638] bus: 'usb': driver_probe_device: matched device usb1 with driver usb
[   20.130046] bus: 'usb': really_probe: probing driver usb with device usb1
[   20.136841] usb usb1: usb_probe_device
[   20.140610] usb usb1: configuration #1 chosen from 1 choice
[   20.146324] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   20.152086] device: '1-0:1.0': device_add
[   20.156191] bus: 'usb': add device 1-0:1.0
[   20.160410] bus: 'usb': driver_probe_device: matched device 1-0:1.0 with driver hub
[   20.168053] bus: 'usb': really_probe: probing driver hub with device 1-0:1.0
[   20.175136] hub 1-0:1.0: usb_probe_interface
[   20.179399] hub 1-0:1.0: usb_probe_interface - got id
[   20.184468] hub 1-0:1.0: USB hub found
[   20.188284] hub 1-0:1.0: 10 ports detected
[   20.192403] hub 1-0:1.0: standalone hub
[   20.196232] hub 1-0:1.0: no power switching (usb 1.0)
[   20.201302] hub 1-0:1.0: individual port over-current protection
[   20.207297] hub 1-0:1.0: power on to power good time: 20ms
[   20.212887] hub 1-0:1.0: local power source is good
[   20.217761] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   20.224803] driver: '1-0:1.0': driver_bound: bound to device 'hub'
[   20.230999] bus: 'usb': really_probe: bound device 1-0:1.0 to driver hub
[   20.237708] device: 'ep_81': device_add
[   20.241646] device: 'usbdev1.1': device_add
[   20.246026] drivers/usb/core/inode.c: creating file '001'
[   20.251483] driver: 'usb1': driver_bound: bound to device 'usb'
[   20.257394] bus: 'usb': really_probe: bound device usb1 to driver usb
[   20.263864] device: 'ep_00': device_add
[   20.267790] driver: '0000:00:02.1': driver_bound: bound to device 'ehci_hcd'
[   20.274847] bus: 'pci': really_probe: bound device 0000:00:02.1 to driver ehci_hcd
[   20.282488] initcall ehci_hcd_init+0x0/0xe7 returned 0 after 374559 usecs
[   20.289268] calling  oxu_module_init+0x0/0x12 @ 1
[   20.293998] bus: 'platform': add driver oxu210hp-hcd
[   20.299002] initcall oxu_module_init+0x0/0x12 returned 0 after 4891 usecs
[   20.305804] calling  isp1362_init+0x0/0x3e @ 1
[   20.310259] driver isp1362-hcd, 2005-04-04
[   20.314351] bus: 'platform': add driver isp1362-hcd
[   20.319286] initcall isp1362_init+0x0/0x3e returned 0 after 8820 usecs
[   20.320473] hub 1-0:1.0: state 7 ports 10 chg 0000 evt 0000
[   20.331397] calling  ohci_hcd_mod_init+0x0/0xd7 @ 1
[   20.336269] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   20.342464] ohci_hcd: block sizes: ed 80 td 96
[   20.346923] bus: 'pci': add driver ohci_hcd
[   20.351154] bus: 'pci': driver_probe_device: matched device 0000:00:02.0 with driver ohci_hcd
[   20.359666] bus: 'pci': really_probe: probing driver ohci_hcd with device 0000:00:02.0
[   20.369206] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21
[   20.375057] ohci_hcd 0000:00:02.0: PCI INT A -> Link[APCF] -> GSI 21 (level, low) -> IRQ 21
[   20.383459] ohci_hcd 0000:00:02.0: setting latency timer to 64
[   20.389286] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   20.394559] drivers/usb/core/inode.c: creating file '002'
[   20.399978] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[   20.407401] ohci_hcd 0000:00:02.0: USB HC TakeOver from BIOS/SMM
[   20.430180] ohci_hcd 0000:00:02.0: created debug files
[   20.435311] ohci_hcd 0000:00:02.0: supports USB remote wakeup
[   20.441388] ohci_hcd 0000:00:02.0: irq 21, io mem 0xda102000
[   20.502085] ohci_hcd 0000:00:02.0: OHCI controller state
[   20.507393] ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers
[   20.514117] ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=operational CBSR=3
[   20.521523] ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=0
[   20.526997] ohci_hcd 0000:00:02.0: intrstatus 0x00000004 SF
[   20.532591] ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
[   20.539288] ohci_hcd 0000:00:02.0: hcca frame #0028
[   20.544187] ohci_hcd 0000:00:02.0: roothub.a 0100020a POTPGT=1 NPS NDP=10(10)
[   20.551337] ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=0000 DR=0000
[   20.557945] ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
[   20.563888] ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
[   20.570604] ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
[   20.577300] ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
[   20.584020] ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
[   20.590736] ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00000100 PPS
[   20.597424] ohci_hcd 0000:00:02.0: roothub.portstatus [5] 0x00000100 PPS
[   20.604143] ohci_hcd 0000:00:02.0: roothub.portstatus [6] 0x00000100 PPS
[   20.610851] ohci_hcd 0000:00:02.0: roothub.portstatus [7] 0x00000100 PPS
[   20.617539] ohci_hcd 0000:00:02.0: roothub.portstatus [8] 0x00000100 PPS
[   20.624261] ohci_hcd 0000:00:02.0: roothub.portstatus [9] 0x00000100 PPS
[   20.631152] usb usb2: default language 0x0409
[   20.635604] usb usb2: udev 1, busnum 2, minor = 128
[   20.640503] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   20.647283] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   20.654522] usb usb2: Product: OHCI Host Controller
[   20.659391] usb usb2: Manufacturer: Linux 2.6.34-tip+ ohci_hcd
[   20.665244] usb usb2: SerialNumber: 0000:00:02.0
[   20.669866] device: 'usb2': device_add
[   20.673804] bus: 'usb': add device usb2
[   20.677776] bus: 'usb': driver_probe_device: matched device usb2 with driver usb
[   20.685187] bus: 'usb': really_probe: probing driver usb with device usb2
[   20.692004] usb usb2: usb_probe_device
[   20.695750] usb usb2: configuration #1 chosen from 1 choice
[   20.701368] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   20.707112] device: '2-0:1.0': device_add
[   20.711192] bus: 'usb': add device 2-0:1.0
[   20.715346] bus: 'usb': driver_probe_device: matched device 2-0:1.0 with driver hub
[   20.723018] bus: 'usb': really_probe: probing driver hub with device 2-0:1.0
[   20.730094] hub 2-0:1.0: usb_probe_interface
[   20.734359] hub 2-0:1.0: usb_probe_interface - got id
[   20.739407] hub 2-0:1.0: USB hub found
[   20.743206] hub 2-0:1.0: 10 ports detected
[   20.747301] hub 2-0:1.0: standalone hub
[   20.751157] hub 2-0:1.0: no power switching (usb 1.0)
[   20.756198] hub 2-0:1.0: global over-current protection
[   20.761437] hub 2-0:1.0: power on to power good time: 2ms
[   20.766855] hub 2-0:1.0: local power source is good
[   20.771750] hub 2-0:1.0: no over-current condition exists
[   20.777139] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   20.784156] driver: '2-0:1.0': driver_bound: bound to device 'hub'
[   20.790352] bus: 'usb': really_probe: bound device 2-0:1.0 to driver hub
[   20.797057] device: 'ep_81': device_add
[   20.801009] device: 'usbdev2.1': device_add
[   20.805265] drivers/usb/core/inode.c: creating file '001'
[   20.810708] driver: 'usb2': driver_bound: bound to device 'usb'
[   20.816627] bus: 'usb': really_probe: bound device usb2 to driver usb
[   20.823096] device: 'ep_00': device_add
[   20.827032] driver: '0000:00:02.0': driver_bound: bound to device 'ohci_hcd'
[   20.834096] bus: 'pci': really_probe: bound device 0000:00:02.0 to driver ohci_hcd
[   20.841835] bus: 'platform': add driver sm501-usb
[   20.846616] initcall ohci_hcd_mod_init+0x0/0xd7 returned 0 after 498383 usecs
[   20.853760] calling  uhci_hcd_init+0x0/0x101 @ 1
[   20.858374] uhci_hcd: USB Universal Host Controller Interface driver
[   20.864769] bus: 'pci': add driver uhci_hcd
[   20.869068] initcall uhci_hcd_init+0x0/0x101 returned 0 after 10442 usecs
[   20.875871] calling  xhci_hcd_init+0x0/0x2c @ 1
[   20.880213] hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
[   20.885978] bus: 'pci': add driver xhci_hcd
[   20.890292] initcall xhci_hcd_init+0x0/0x2c returned 0 after 4215 usecs
[   20.896895] calling  sl811h_init+0x0/0x3e @ 1
[   20.901274] sl811: driver sl811-hcd, 19 May 2005
[   20.905886] bus: 'platform': add driver sl811-hcd
[   20.910687] initcall sl811h_init+0x0/0x3e returned 0 after 9191 usecs
[   20.917115] calling  init_sl811_cs+0x0/0x12 @ 1
[   20.921668] bus: 'pcmcia': add driver sl811_cs
[   20.926216] initcall init_sl811_cs+0x0/0x12 returned 0 after 4446 usecs
[   20.932846] calling  r8a66597_init+0x0/0x3e @ 1
[   20.937370] r8a66597_hcd: driver r8a66597_hcd, 2009-05-26
[   20.942785] bus: 'platform': add driver r8a66597_hcd
[   20.947825] initcall r8a66597_init+0x0/0x3e returned 0 after 10208 usecs
[   20.954537] calling  hwahc_driver_init+0x0/0x1b @ 1
[   20.959414] bus: 'usb': add driver hwa-hc
[   20.963529] usbcore: registered new interface driver hwa-hc
[   20.969101] initcall hwahc_driver_init+0x0/0x1b returned 0 after 9463 usecs
[   20.976075] calling  wusbcore_init+0x0/0x73 @ 1
[   20.980755] initcall wusbcore_init+0x0/0x73 returned 0 after 130 usecs
[   20.987273] calling  acm_init+0x0/0xfc @ 1
[   20.991552] bus: 'usb': add driver cdc_acm
[   20.995722] usbcore: registered new interface driver cdc_acm
[   21.001397] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
[   21.009911] initcall acm_init+0x0/0xfc returned 0 after 18012 usecs
[   21.016197] calling  usblp_init+0x0/0x1b @ 1
[   21.020482] bus: 'usb': add driver usblp
[   21.024534] usbcore: registered new interface driver usblp
[   21.030109] initcall usblp_init+0x0/0x1b returned 0 after 9402 usecs
[   21.036457] calling  wdm_init+0x0/0x1b @ 1
[   21.040710] bus: 'usb': add driver cdc_wdm
[   21.044868] usbcore: registered new interface driver cdc_wdm
[   21.050549] initcall wdm_init+0x0/0x1b returned 0 after 9609 usecs
[   21.056720] calling  usbtmc_init+0x0/0x39 @ 1
[   21.061105] bus: 'usb': add driver usbtmc
[   21.065173] usbcore: registered new interface driver usbtmc
[   21.070830] initcall usbtmc_init+0x0/0x39 returned 0 after 9498 usecs
[   21.077259] calling  usb_stor_init+0x0/0x50 @ 1
[   21.081815] Initializing USB Mass Storage driver...
[   21.086691] bus: 'usb': add driver usb-storage
[   21.091225] usbcore: registered new interface driver usb-storage
[   21.097226] USB Mass Storage support registered.
[   21.101865] initcall usb_stor_init+0x0/0x50 returned 0 after 19578 usecs
[   21.108555] calling  usb_usual_init+0x0/0x3f @ 1
[   21.113283] bus: 'usb': add driver libusual
[   21.117617] usbcore: registered new interface driver libusual
[   21.123384] initcall usb_usual_init+0x0/0x3f returned 0 after 9885 usecs
[   21.130098] calling  alauda_init+0x0/0x1b @ 1
[   21.134457] bus: 'usb': add driver ums-alauda
[   21.138869] usbcore: registered new interface driver ums-alauda
[   21.144817] initcall alauda_init+0x0/0x1b returned 0 after 10114 usecs
[   21.151421] calling  datafab_init+0x0/0x1b @ 1
[   21.155863] bus: 'usb': add driver ums-datafab
[   21.160387] usbcore: registered new interface driver ums-datafab
[   21.166391] initcall datafab_init+0x0/0x1b returned 0 after 10283 usecs
[   21.173025] calling  freecom_init+0x0/0x1b @ 1
[   21.177470] bus: 'usb': add driver ums-freecom
[   21.181994] usbcore: registered new interface driver ums-freecom
[   21.187996] initcall freecom_init+0x0/0x1b returned 0 after 10282 usecs
[   21.194691] calling  jumpshot_init+0x0/0x1b @ 1
[   21.199223] bus: 'usb': add driver ums-jumpshot
[   21.203849] usbcore: registered new interface driver ums-jumpshot
[   21.209933] initcall jumpshot_init+0x0/0x1b returned 0 after 10461 usecs
[   21.216653] calling  karma_init+0x0/0x1b @ 1
[   21.220944] bus: 'usb': add driver ums-karma
[   21.225283] usbcore: registered new interface driver ums-karma
[   21.231203] initcall karma_init+0x0/0x1b returned 0 after 10019 usecs
[   21.237639] calling  onetouch_init+0x0/0x1b @ 1
[   21.242199] bus: 'usb': add driver ums-onetouch
[   21.246784] usbcore: registered new interface driver ums-onetouch
[   21.252899] initcall onetouch_init+0x0/0x1b returned 0 after 10449 usecs
[   21.259591] calling  sddr55_init+0x0/0x1b @ 1
[   21.263975] bus: 'usb': add driver ums-sddr55
[   21.268389] usbcore: registered new interface driver ums-sddr55
[   21.274395] initcall sddr55_init+0x0/0x1b returned 0 after 10176 usecs
[   21.280933] calling  usbat_init+0x0/0x1b @ 1
[   21.285205] bus: 'usb': add driver ums-usbat
[   21.289535] usbcore: registered new interface driver ums-usbat
[   21.295407] initcall usbat_init+0x0/0x1b returned 0 after 9960 usecs
[   21.301777] calling  usb_mdc800_init+0x0/0x28b @ 1
[   21.306593] bus: 'usb': add driver mdc800
[   21.310752] usbcore: registered new interface driver mdc800
[   21.316316] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[   21.323993] initcall usb_mdc800_init+0x0/0x28b returned 0 after 17012 usecs
[   21.330977] calling  microtek_drv_init+0x0/0x1b @ 1
[   21.335855] bus: 'usb': add driver microtekX6
[   21.340293] usbcore: registered new interface driver microtekX6
[   21.346210] initcall microtek_drv_init+0x0/0x1b returned 0 after 10114 usecs
[   21.353340] calling  adu_init+0x0/0xa4 @ 1
[   21.357433] drivers/usb/misc/adutux.c:  adu_init : enter
[   21.362767] bus: 'usb': add driver adutux
[   21.366836] usbcore: registered new interface driver adutux
[   21.372428] adutux adutux (see www.ontrak.net) v0.0.13
[   21.377563] adutux is an experimental driver. Use at your own risk
[   21.383764] drivers/usb/misc/adutux.c:  adu_init : leave, return value 0
[   21.390545] initcall adu_init+0x0/0xa4 returned 0 after 32331 usecs
[   21.396804] calling  appledisplay_init+0x0/0x59 @ 1
[   21.401838] bus: 'usb': add driver appledisplay
[   21.406478] usbcore: registered new interface driver appledisplay
[   21.412593] initcall appledisplay_init+0x0/0x59 returned 0 after 10630 usecs
[   21.419632] calling  usb_cytherm_init+0x0/0x4a @ 1
[   21.424444] bus: 'usb': add driver cytherm
[   21.428586] usbcore: registered new interface driver cytherm
[   21.434259] cytherm: v1.0:Cypress USB Thermometer driver
[   21.439569] initcall usb_cytherm_init+0x0/0x4a returned 0 after 14775 usecs
[   21.446540] calling  emi26_init+0x0/0x1b @ 1
[   21.450826] bus: 'usb': add driver emi26 - firmware loader
[   21.456355] usbcore: registered new interface driver emi26 - firmware loader
[   21.463418] initcall emi26_init+0x0/0x1b returned 0 after 12297 usecs
[   21.469846] calling  emi62_init+0x0/0x38 @ 1
[   21.474139] bus: 'usb': add driver emi62 - firmware loader
[   21.479666] usbcore: registered new interface driver emi62 - firmware loader
[   21.486731] initcall emi62_init+0x0/0x38 returned 0 after 12298 usecs
[   21.493182] calling  iowarrior_init+0x0/0x1b @ 1
[   21.497801] bus: 'usb': add driver iowarrior
[   21.502177] usbcore: registered new interface driver iowarrior
[   21.508009] initcall iowarrior_init+0x0/0x1b returned 0 after 9970 usecs
[   21.514726] calling  isight_firmware_init+0x0/0x1b @ 1
[   21.519858] bus: 'usb': add driver isight_firmware
[   21.524716] usbcore: registered new interface driver isight_firmware
[   21.531081] initcall isight_firmware_init+0x0/0x1b returned 0 after 10956 usecs
[   21.538374] calling  usb_lcd_init+0x0/0x3a @ 1
[   21.542840] bus: 'usb': add driver usblcd
[   21.546895] usbcore: registered new interface driver usblcd
[   21.552478] initcall usb_lcd_init+0x0/0x3a returned 0 after 9412 usecs
[   21.558994] calling  ld_usb_init+0x0/0x42 @ 1
[   21.563373] bus: 'usb': add driver ldusb
[   21.567341] usbcore: registered new interface driver ldusb
[   21.572844] initcall ld_usb_init+0x0/0x42 returned 0 after 9249 usecs
[   21.579274] calling  usb_led_init+0x0/0x3b @ 1
[   21.583739] bus: 'usb': add driver usbled
[   21.587796] usbcore: registered new interface driver usbled
[   21.593391] initcall usb_led_init+0x0/0x3b returned 0 after 9426 usecs
[   21.599909] calling  lego_usb_tower_init+0x0/0xa0 @ 1
[   21.604980] drivers/usb/misc/legousbtower.c: lego_usb_tower_init: enter
[   21.611602] bus: 'usb': add driver legousbtower
[   21.616205] usbcore: registered new interface driver legousbtower
[   21.622311] legousbtower: v0.96:LEGO USB Tower Driver
[   21.627357] drivers/usb/misc/legousbtower.c: lego_usb_tower_init: leave, return value 0
[   21.635374] initcall lego_usb_tower_init+0x0/0xa0 returned 0 after 29680 usecs
[   21.642600] calling  usbtest_init+0x0/0x3f @ 1
[   21.647044] bus: 'usb': add driver usbtest
[   21.651211] usbcore: registered new interface driver usbtest
[   21.656862] initcall usbtest_init+0x0/0x3f returned 0 after 9589 usecs
[   21.663401] calling  uss720_init+0x0/0x62 @ 1
[   21.667758] bus: 'usb': add driver uss720
[   21.671832] usbcore: registered new interface driver uss720
[   21.677399] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
[   21.686714] uss720: NOTE: this is a special purpose driver to allow nonstandard
[   21.694034] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
[   21.701264] uss720: If you just want to connect to a printer, use usblp instead
[   21.708566] initcall uss720_init+0x0/0x62 returned 0 after 39854 usecs
[   21.715106] calling  uea_init+0x0/0x2b @ 1
[   21.719201] [ueagle-atm] driver ueagle 1.4 loaded
[   21.723921] bus: 'usb': add driver ueagle-atm
[   21.728328] usbcore: registered new interface driver ueagle-atm
[   21.734263] initcall uea_init+0x0/0x2b returned 0 after 14704 usecs
[   21.740536] calling  usbatm_usb_init+0x0/0x65 @ 1
[   21.745235] drivers/usb/atm/usbatm.c: usbatm_usb_init: driver version 1.10
[   21.752125] initcall usbatm_usb_init+0x0/0x65 returned 0 after 6723 usecs
[   21.758902] calling  xusbatm_init+0x0/0x13a @ 1
[   21.763451] drivers/usb/atm/xusbatm.c: xusbatm_init
[   21.768322] xusbatm: malformed module parameters
[   21.772951] initcall xusbatm_init+0x0/0x13a returned -22 after 9276 usecs
[   21.779729] initcall xusbatm_init+0x0/0x13a returned with error code -22 
[   21.786531] calling  i8042_init+0x0/0x371 @ 1
[   21.790906] bus: 'pnp': add driver i8042 kbd
[   21.795200] bus: 'pnp': driver_probe_device: matched device 00:0b with driver i8042 kbd
[   21.803214] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:0b
[   21.810629] driver: '00:0b': driver_bound: bound to device 'i8042 kbd'
[   21.817151] bus: 'pnp': really_probe: bound device 00:0b to driver i8042 kbd
[   21.824279] bus: 'pnp': add driver i8042 aux
[   21.828574] bus: 'pnp': driver_probe_device: matched device 00:0a with driver i8042 aux
[   21.836600] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:0a
[   21.844013] driver: '00:0a': driver_bound: bound to device 'i8042 aux'
[   21.850551] bus: 'pnp': really_probe: bound device 00:0a to driver i8042 aux
[   21.857632] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[   21.865277] Registering platform device 'i8042'. Parent at platform
[   21.871552] device: 'i8042': device_add
[   21.875398] bus: 'platform': add device i8042
[   21.879844] bus: 'platform': add driver i8042
[   21.884241] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[   21.892339] bus: 'platform': really_probe: probing driver i8042 with device i8042
[   21.902916] serio: i8042 KBD port at 0x60,0x64 irq 1
[   21.907905] serio: i8042 AUX port at 0x60,0x64 irq 12
[   21.907935] device: 'serio0': device_add
[   21.908026] bus: 'serio': add device serio0
[   21.921121] driver: 'i8042': driver_bound: bound to device 'i8042'
[   21.921135] device: 'serio1': device_add
[   21.921173] bus: 'serio': add device serio1
[   21.935402] bus: 'platform': really_probe: bound device i8042 to driver i8042
[   21.942616] initcall i8042_init+0x0/0x371 returned 0 after 148154 usecs
[   21.949223] calling  parkbd_init+0x0/0x18c @ 1
[   21.953697] parport0: cannot grant exclusive access for device parkbd
[   21.960146] initcall parkbd_init+0x0/0x18c returned -19 after 6306 usecs
[   21.966836] calling  serport_init+0x0/0x34 @ 1
[   21.971301] initcall serport_init+0x0/0x34 returned 0 after 3 usecs
[   21.977556] calling  altera_ps2_init+0x0/0x12 @ 1
[   21.982281] bus: 'platform': add driver altera_ps2
[   21.987111] initcall altera_ps2_init+0x0/0x12 returned 0 after 4721 usecs
[   21.993915] calling  fm801_gp_init+0x0/0x1b @ 1
[   21.998456] bus: 'pci': add driver FM801_gameport
[   22.003271] initcall fm801_gp_init+0x0/0x1b returned 0 after 4708 usecs
[   22.009874] calling  l4_init+0x0/0x2d7 @ 1
[   22.014092] initcall l4_init+0x0/0x2d7 returned -19 after 15 usecs
[   22.020282] calling  mousedev_init+0x0/0x8e @ 1
[   22.024905] device: 'mice': device_add
[   22.028744] device: 'psaux': device_add
[   22.032689] mice: PS/2 mouse device common for all mice
[   22.037915] initcall mousedev_init+0x0/0x8e returned 0 after 12798 usecs
[   22.040036] ohci_hcd 0000:00:02.0: auto-stop root hub
[   22.049677] calling  joydev_init+0x0/0x12 @ 1
[   22.054055] initcall joydev_init+0x0/0x12 returned 0 after 4 usecs
[   22.060244] calling  evbug_init+0x0/0x12 @ 1
[   22.064519] evbug.c: Connected device: input0 (Power Button at PNP0C0C/button/input0)
[   22.072364] evbug.c: Connected device: input1 (Power Button at LNXPWRBN/button/input0)
[   22.080285] initcall evbug_init+0x0/0x12 returned 0 after 15399 usecs
[   22.086714] calling  adp5520_keys_init+0x0/0x12 @ 1
[   22.091620] bus: 'platform': add driver adp5520-keys
[   22.096642] initcall adp5520_keys_init+0x0/0x12 returned 0 after 4910 usecs
[   22.103615] calling  adp5588_init+0x0/0x14 @ 1
[   22.108055] bus: 'i2c': add driver adp5588_keys
[   22.112640] i2c-core: driver [adp5588_keys] registered
[   22.117781] initcall adp5588_init+0x0/0x14 returned 0 after 9499 usecs
[   22.124318] calling  atkbd_init+0x0/0x27 @ 1
[   22.128590] bus: 'serio': add driver atkbd
[   22.132761] initcall atkbd_init+0x0/0x27 returned 0 after 4073 usecs
[   22.132777] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[   22.132780] bus: 'serio': really_probe: probing driver atkbd with device serio0
[   22.154387] calling  gpio_keys_init+0x0/0x12 @ 1
[   22.159013] bus: 'platform': add driver gpio-keys
[   22.163788] initcall gpio_keys_init+0x0/0x12 returned 0 after 4659 usecs
[   22.170511] calling  lkkbd_init+0x0/0x1b @ 1
[   22.174793] bus: 'serio': add driver lkkbd
[   22.179002] initcall lkkbd_init+0x0/0x1b returned 0 after 4112 usecs
[   22.182348] device: 'input2': device_add
[   22.182636] input: AT Translated Set 2 keyboard as /class/input/input2
[   22.182692] evbug.c: Connected device: input2 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[   22.182699] driver: 'serio0': driver_bound: bound to device 'atkbd'
[   22.182704] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[   22.182718] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[   22.182721] bus: 'serio': really_probe: probing driver atkbd with device serio1
[   22.233423] calling  lm8323_init+0x0/0x14 @ 1
[   22.237779] bus: 'i2c': add driver lm8323
[   22.241848] i2c-core: driver [lm8323] registered
[   22.246466] initcall lm8323_init+0x0/0x14 returned 0 after 8484 usecs
[   22.252918] calling  max7359_init+0x0/0x14 @ 1
[   22.257357] bus: 'i2c': add driver max7359
[   22.261507] i2c-core: driver [max7359] registered
[   22.266208] initcall max7359_init+0x0/0x14 returned 0 after 8643 usecs
[   22.272747] calling  sunkbd_init+0x0/0x1b @ 1
[   22.277100] bus: 'serio': add driver sunkbd
[   22.281358] initcall sunkbd_init+0x0/0x1b returned 0 after 4154 usecs
[   22.287793] calling  xtkbd_init+0x0/0x1b @ 1
[   22.292085] bus: 'serio': add driver xtkbd
[   22.296248] initcall xtkbd_init+0x0/0x1b returned 0 after 4068 usecs
[   22.302615] calling  bcm5974_init+0x0/0x1b @ 1
[   22.307058] bus: 'usb': add driver bcm5974
[   22.311262] usbcore: registered new interface driver bcm5974
[   22.316915] initcall bcm5974_init+0x0/0x1b returned 0 after 9631 usecs
[   22.323456] calling  psmouse_init+0x0/0x7d @ 1
[   22.328037] bus: 'serio': add driver psmouse
[   22.332423] initcall psmouse_init+0x0/0x7d returned 0 after 4413 usecs
[   22.332437] bus: 'serio': driver_probe_device: matched device serio1 with driver psmouse
[   22.332441] bus: 'serio': really_probe: probing driver psmouse with device serio1
[   22.354515] calling  synaptics_i2c_init+0x0/0x14 @ 1
[   22.359481] bus: 'i2c': add driver synaptics_i2c
[   22.364166] i2c-core: driver [synaptics_i2c] registered
[   22.369387] initcall synaptics_i2c_init+0x0/0x14 returned 0 after 9676 usecs
[   22.376449] calling  vsxxxaa_init+0x0/0x1b @ 1
[   22.380913] bus: 'serio': add driver vsxxxaa
[   22.385265] initcall vsxxxaa_init+0x0/0x1b returned 0 after 4253 usecs
[   22.391807] calling  a3d_init+0x0/0x1b @ 1
[   22.395905] bus: 'gameport': add driver adc
[   22.400197] initcall a3d_init+0x0/0x1b returned 0 after 4188 usecs
[   22.406370] calling  adi_init+0x0/0x1b @ 1
[   22.410495] bus: 'gameport': add driver adi
[   22.414736] initcall adi_init+0x0/0x1b returned 0 after 4144 usecs
[   22.420936] calling  cobra_init+0x0/0x1b @ 1
[   22.425208] bus: 'gameport': add driver cobra
[   22.429623] initcall cobra_init+0x0/0x1b returned 0 after 4314 usecs
[   22.435999] calling  gc_init+0x0/0x697 @ 1
[   22.440118] initcall gc_init+0x0/0x697 returned -19 after 1 usecs
[   22.446203] calling  grip_init+0x0/0x1b @ 1
[   22.450413] bus: 'gameport': add driver grip_mp
[   22.455005] initcall grip_init+0x0/0x1b returned 0 after 4487 usecs
[   22.461288] calling  guillemot_init+0x0/0x1b @ 1
[   22.465906] bus: 'gameport': add driver guillemot
[   22.470708] initcall guillemot_init+0x0/0x1b returned 0 after 4685 usecs
[   22.477404] calling  joydump_init+0x0/0x1b @ 1
[   22.481875] bus: 'gameport': add driver joydump
[   22.486474] initcall joydump_init+0x0/0x1b returned 0 after 4493 usecs
[   22.493019] calling  magellan_init+0x0/0x1b @ 1
[   22.497548] bus: 'serio': add driver magellan
[   22.501986] initcall magellan_init+0x0/0x1b returned 0 after 4331 usecs
[   22.508595] calling  stinger_init+0x0/0x1b @ 1
[   22.513067] bus: 'serio': add driver stinger
[   22.517395] initcall stinger_init+0x0/0x1b returned 0 after 4229 usecs
[   22.523940] calling  tmdc_init+0x0/0x1b @ 1
[   22.528126] bus: 'gameport': add driver tmdc
[   22.532476] initcall tmdc_init+0x0/0x1b returned 0 after 4245 usecs
[   22.538739] calling  tgfx_init+0x0/0x42a @ 1
[   22.543037] initcall tgfx_init+0x0/0x42a returned -19 after 1 usecs
[   22.549295] calling  twidjoy_init+0x0/0x1b @ 1
[   22.553764] bus: 'serio': add driver twidjoy
[   22.558136] initcall twidjoy_init+0x0/0x1b returned 0 after 4272 usecs
[   22.564683] calling  warrior_init+0x0/0x1b @ 1
[   22.569128] bus: 'serio': add driver warrior
[   22.573478] initcall warrior_init+0x0/0x1b returned 0 after 4244 usecs
[   22.580024] calling  usb_xpad_init+0x0/0x38 @ 1
[   22.584561] bus: 'usb': add driver xpad
[   22.588467] usbcore: registered new interface driver xpad
[   22.593889] xpad: X-Box pad driver
[   22.597295] initcall usb_xpad_init+0x0/0x38 returned 0 after 12440 usecs
[   22.604013] calling  zhenhua_init+0x0/0x1b @ 1
[   22.608458] bus: 'serio': add driver zhenhua
[   22.612810] initcall zhenhua_init+0x0/0x1b returned 0 after 4247 usecs
[   22.619331] calling  usb_acecad_init+0x0/0x38 @ 1
[   22.624062] bus: 'usb': add driver usb_acecad
[   22.628515] usbcore: registered new interface driver usb_acecad
[   22.634451] acecad: v3.2:USB Acecad Flair tablet driver
[   22.639675] initcall usb_acecad_init+0x0/0x38 returned 0 after 15252 usecs
[   22.646567] calling  kbtab_init+0x0/0x38 @ 1
[   22.650858] bus: 'usb': add driver kbtab
[   22.654841] usbcore: registered new interface driver kbtab
[   22.660346] kbtab: v0.0.2:USB KB Gear JamStudio Tablet driver
[   22.666090] initcall kbtab_init+0x0/0x38 returned 0 after 14880 usecs
[   22.672548] calling  ab3100_rtc_init+0x0/0x19 @ 1
[   22.677249] bus: 'platform': add driver ab3100-rtc
[   22.682120] bus: 'platform': remove driver ab3100-rtc
[   22.687197] driver: 'ab3100-rtc': driver_release
[   22.691838] initcall ab3100_rtc_init+0x0/0x19 returned -19 after 14246 usecs
[   22.698875] calling  bq4802_init+0x0/0x12 @ 1
[   22.703257] bus: 'platform': add driver rtc-bq4802
[   22.708099] initcall bq4802_init+0x0/0x12 returned 0 after 4732 usecs
[   22.714560] calling  ds1286_init+0x0/0x12 @ 1
[   22.718916] bus: 'platform': add driver rtc-ds1286
[   22.723782] initcall ds1286_init+0x0/0x12 returned 0 after 4748 usecs
[   22.730235] calling  ds1374_init+0x0/0x14 @ 1
[   22.734594] bus: 'i2c': add driver rtc-ds1374
[   22.738993] i2c-core: driver [rtc-ds1374] registered
[   22.743985] initcall ds1374_init+0x0/0x14 returned 0 after 9168 usecs
[   22.750438] calling  ds1511_rtc_init+0x0/0x12 @ 1
[   22.755143] bus: 'platform': add driver ds1511
[   22.759654] initcall ds1511_rtc_init+0x0/0x12 returned 0 after 4409 usecs
[   22.766463] calling  ds1553_init+0x0/0x12 @ 1
[   22.770841] bus: 'platform': add driver rtc-ds1553
[   22.775712] initcall ds1553_init+0x0/0x12 returned 0 after 4761 usecs
[   22.782169] calling  ds1672_init+0x0/0x14 @ 1
[   22.786525] bus: 'i2c': add driver rtc-ds1672
[   22.791094] i2c-core: driver [rtc-ds1672] registered
[   22.796060] initcall ds1672_init+0x0/0x14 returned 0 after 9312 usecs
[   22.802516] calling  ds1742_init+0x0/0x12 @ 1
[   22.806875] bus: 'platform': add driver rtc-ds1742
[   22.811783] initcall ds1742_init+0x0/0x12 returned 0 after 4790 usecs
[   22.818216] calling  m48t35_init+0x0/0x12 @ 1
[   22.822600] bus: 'platform': add driver rtc-m48t35
[   22.827453] initcall m48t35_init+0x0/0x12 returned 0 after 4742 usecs
[   22.833909] calling  m48t59_rtc_init+0x0/0x12 @ 1
[   22.838612] bus: 'platform': add driver rtc-m48t59
[   22.843480] initcall m48t59_rtc_init+0x0/0x12 returned 0 after 4751 usecs
[   22.850280] calling  m48t86_rtc_init+0x0/0x12 @ 1
[   22.854985] bus: 'platform': add driver rtc-m48t86
[   22.859857] initcall m48t86_rtc_init+0x0/0x12 returned 0 after 4761 usecs
[   22.866668] calling  max6900_init+0x0/0x14 @ 1
[   22.871132] bus: 'i2c': add driver rtc-max6900
[   22.875617] i2c-core: driver [rtc-max6900] registered
[   22.880697] initcall max6900_init+0x0/0x14 returned 0 after 9340 usecs
[   22.887211] calling  max8925_rtc_init+0x0/0x12 @ 1
[   22.892028] bus: 'platform': add driver max8925-rtc
[   22.896959] initcall max8925_rtc_init+0x0/0x12 returned 0 after 4818 usecs
[   22.903849] calling  msm6242_rtc_init+0x0/0x19 @ 1
[   22.908640] bus: 'platform': add driver rtc-msm6242
[   22.913592] bus: 'platform': remove driver rtc-msm6242
[   22.918755] driver: 'rtc-msm6242': driver_release
[   22.923485] initcall msm6242_rtc_init+0x0/0x19 returned -19 after 14494 usecs
[   22.930629] calling  pcf8583_init+0x0/0x14 @ 1
[   22.935074] bus: 'i2c': add driver pcf8583
[   22.939212] i2c-core: driver [pcf8583] registered
[   22.943945] initcall pcf8583_init+0x0/0x14 returned 0 after 8659 usecs
[   22.950484] calling  rp5c01_rtc_init+0x0/0x19 @ 1
[   22.955189] bus: 'platform': add driver rtc-rp5c01
[   22.960056] bus: 'platform': remove driver rtc-rp5c01
[   22.965130] driver: 'rtc-rp5c01': driver_release
[   22.969748] initcall rp5c01_rtc_init+0x0/0x19 returned -19 after 14222 usecs
[   22.976816] calling  rs5c372_init+0x0/0x14 @ 1
[   22.981279] bus: 'i2c': add driver rtc-rs5c372
[   22.985764] i2c-core: driver [rtc-rs5c372] registered
[   22.990842] initcall rs5c372_init+0x0/0x14 returned 0 after 9339 usecs
[   22.997358] calling  rx8025_init+0x0/0x14 @ 1
[   23.001742] bus: 'i2c': add driver rtc-rx8025
[   23.006138] i2c-core: driver [rtc-rx8025] registered
[   23.011138] initcall rx8025_init+0x0/0x14 returned 0 after 9176 usecs
[   23.017570] calling  rx8581_init+0x0/0x14 @ 1
[   23.021952] bus: 'i2c': add driver rtc-rx8581
[   23.026379] i2c-core: driver [rtc-rx8581] registered
[   23.031369] initcall rx8581_init+0x0/0x14 returned 0 after 9195 usecs
[   23.037797] calling  stk17ta8_init+0x0/0x12 @ 1
[   23.042452] bus: 'platform': add driver stk17ta8
[   23.047123] initcall stk17ta8_init+0x0/0x12 returned 0 after 4565 usecs
[   23.053760] calling  test_init+0x0/0xb5 @ 1
[   23.057943] bus: 'platform': add driver rtc-test
[   23.062675] Registering platform device 'rtc-test.0'. Parent at platform
[   23.069372] device: 'rtc-test.0': device_add
[   23.073680] bus: 'platform': add device rtc-test.0
[   23.078581] bus: 'platform': driver_probe_device: matched device rtc-test.0 with driver rtc-test
[   23.087377] bus: 'platform': really_probe: probing driver rtc-test with device rtc-test.0
[   23.095756] device: 'rtc0': device_add
[   23.099725] test: dev (254:0)
[   23.102718] rtc-test rtc-test.0: rtc core: registered test as rtc0
[   23.108896] driver: 'rtc-test.0': driver_bound: bound to device 'rtc-test'
[   23.115786] bus: 'platform': really_probe: bound device rtc-test.0 to driver rtc-test
[   23.123635] Registering platform device 'rtc-test.1'. Parent at platform
[   23.130346] device: 'rtc-test.1': device_add
[   23.134627] bus: 'platform': add device rtc-test.1
[   23.139527] bus: 'platform': driver_probe_device: matched device rtc-test.1 with driver rtc-test
[   23.148329] bus: 'platform': really_probe: probing driver rtc-test with device rtc-test.1
[   23.156549] device: 'rtc1': device_add
[   23.160459] test: dev (254:1)
[   23.163423] rtc-test rtc-test.1: rtc core: registered test as rtc1
[   23.169603] driver: 'rtc-test.1': driver_bound: bound to device 'rtc-test'
[   23.176498] bus: 'platform': really_probe: bound device rtc-test.1 to driver rtc-test
[   23.184348] initcall test_init+0x0/0xb5 returned 0 after 123438 usecs
[   23.190806] calling  v3020_init+0x0/0x12 @ 1
[   23.195080] bus: 'platform': add driver v3020
[   23.199493] initcall v3020_init+0x0/0x12 returned 0 after 4315 usecs
[   23.205869] calling  wm831x_rtc_init+0x0/0x12 @ 1
[   23.210595] bus: 'platform': add driver wm831x-rtc
[   23.215440] initcall wm831x_rtc_init+0x0/0x12 returned 0 after 4735 usecs
[   23.222250] calling  x1205_init+0x0/0x14 @ 1
[   23.226521] bus: 'i2c': add driver rtc-x1205
[   23.230863] i2c-core: driver [rtc-x1205] registered
[   23.235744] initcall x1205_init+0x0/0x14 returned 0 after 9008 usecs
[   23.242113] calling  i2c_smbus_init+0x0/0x14 @ 1
[   23.246732] bus: 'i2c': add driver smbus_alert
[   23.251256] i2c-core: driver [smbus_alert] registered
[   23.256311] initcall i2c_smbus_init+0x0/0x14 returned 0 after 9355 usecs
[   23.263026] calling  i2c_dev_init+0x0/0xb6 @ 1
[   23.267468] i2c /dev entries driver
[   23.271021] device class 'i2c-dev': registering
[   23.275587] bus: 'i2c': add driver dev_driver
[   23.279980] i2c-core: driver [dev_driver] registered
[   23.284976] initcall i2c_dev_init+0x0/0xb6 returned 0 after 17091 usecs
[   23.291600] calling  i2c_ali1535_init+0x0/0x1b @ 1
[   23.296405] bus: 'pci': add driver ali1535_smbus
[   23.301156] initcall i2c_ali1535_init+0x0/0x1b returned 0 after 4648 usecs
[   23.308019] calling  amd756_init+0x0/0x1b @ 1
[   23.312406] bus: 'pci': add driver amd756_smbus
[   23.317030] initcall amd756_init+0x0/0x1b returned 0 after 4521 usecs
[   23.323486] calling  i2c_amd8111_init+0x0/0x1b @ 1
[   23.328278] bus: 'pci': add driver amd8111_smbus2
[   23.333114] initcall i2c_amd8111_init+0x0/0x1b returned 0 after 4720 usecs
[   23.339981] calling  i2c_i801_init+0x0/0x1b @ 1
[   23.344542] bus: 'pci': add driver i801_smbus
[   23.349005] initcall i2c_i801_init+0x0/0x1b returned 0 after 4362 usecs
[   23.355639] calling  i2c_sch_init+0x0/0x12 @ 1
[   23.360105] bus: 'platform': add driver isch_smbus
[   23.364950] initcall i2c_sch_init+0x0/0x12 returned 0 after 4736 usecs
[   23.371500] calling  i2c_sis5595_init+0x0/0x1b @ 1
[   23.376293] bus: 'pci': add driver sis5595_smbus
[   23.381027] initcall i2c_sis5595_init+0x0/0x1b returned 0 after 4621 usecs
[   23.387892] calling  i2c_sis630_init+0x0/0x1b @ 1
[   23.392624] bus: 'pci': add driver sis630_smbus
[   23.397249] initcall i2c_sis630_init+0x0/0x1b returned 0 after 4522 usecs
[   23.404053] calling  i2c_vt586b_init+0x0/0x1b @ 1
[   23.408758] bus: 'pci': add driver vt586b_smbus
[   23.413437] initcall i2c_vt586b_init+0x0/0x1b returned 0 after 4567 usecs
[   23.420242] calling  i2c_vt596_init+0x0/0x1b @ 1
[   23.424861] bus: 'pci': add driver vt596_smbus
[   23.429399] initcall i2c_vt596_init+0x0/0x1b returned 0 after 4437 usecs
[   23.436120] calling  i2c_gpio_init+0x0/0x31 @ 1
[   23.440671] bus: 'platform': add driver i2c-gpio
[   23.445344] initcall i2c_gpio_init+0x0/0x31 returned 0 after 4567 usecs
[   23.451979] calling  xiic_i2c_init+0x0/0x12 @ 1
[   23.456510] bus: 'platform': add driver xiic-i2c
[   23.461206] initcall xiic_i2c_init+0x0/0x12 returned 0 after 4582 usecs
[   23.467808] calling  i2c_parport_init+0x0/0x46 @ 1
[   23.472624] i2c-parport: adapter type unspecified
[   23.477328] initcall i2c_parport_init+0x0/0x46 returned -19 after 4595 usecs
[   23.484393] calling  i2c_parport_init+0x0/0x163 @ 1
[   23.489268] i2c-parport-light: adapter type unspecified
[   23.494520] initcall i2c_parport_init+0x0/0x163 returned -19 after 5122 usecs
[   23.501666] calling  usb_i2c_tiny_usb_init+0x0/0x1b @ 1
[   23.506895] bus: 'usb': add driver i2c-tiny-usb
[   23.511521] usbcore: registered new interface driver i2c-tiny-usb
[   23.517611] initcall usb_i2c_tiny_usb_init+0x0/0x1b returned 0 after 10470 usecs
[   23.525023] calling  saa7146_vv_init_module+0x0/0x8 @ 1
[   23.530269] initcall saa7146_vv_init_module+0x0/0x8 returned 0 after 1 usecs
[   23.537306] calling  ir_core_init+0x0/0x42 @ 1
[   23.541776] device class 'irrcv': registering
[   23.546182] initcall ir_core_init+0x0/0x42 returned 0 after 4305 usecs
[   23.552732] calling  videodev_init+0x0/0x89 @ 1
[   23.557260] Linux video capture interface: v2.00
[   23.561901] device class 'video4linux': registering
[   23.566904] initcall videodev_init+0x0/0x89 returned 0 after 9415 usecs
[   23.573540] calling  v4l2_i2c_drv_init+0x0/0x64 @ 1
[   23.578418] bus: 'i2c': add driver tuner
[   23.582441] i2c-core: driver [tuner] registered
[   23.586975] initcall v4l2_i2c_drv_init+0x0/0x64 returned 0 after 8357 usecs
[   23.593953] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   23.598827] bus: 'i2c': add driver tvaudio
[   23.603023] i2c-core: driver [tvaudio] registered
[   23.607731] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8695 usecs
[   23.614707] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   23.619585] bus: 'i2c': add driver tda7432
[   23.623779] i2c-core: driver [tda7432] registered
[   23.628487] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8693 usecs
[   23.635464] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   23.640361] bus: 'i2c': add driver tda9875
[   23.644534] i2c-core: driver [tda9875] registered
[   23.649241] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8678 usecs
[   23.656222] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   23.661118] bus: 'i2c': add driver saa6588
[   23.665291] i2c-core: driver [saa6588] registered
[   23.670025] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8698 usecs
[   23.676981] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   23.681885] bus: 'i2c': add driver saa5246a
[   23.686176] i2c-core: driver [saa5246a] registered
[   23.690998] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8899 usecs
[   23.697955] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   23.702859] bus: 'i2c': add driver saa5249
[   23.707030] i2c-core: driver [saa5249] registered
[   23.711763] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8695 usecs
[   23.718712] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   23.723615] bus: 'i2c': add driver tda9840
[   23.727786] i2c-core: driver [tda9840] registered
[   23.732520] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8696 usecs
[   23.739468] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   23.744371] bus: 'i2c': add driver tea6415c
[   23.748630] i2c-core: driver [tea6415c] registered
[   23.748670] device: 'input3': device_add
[   23.749048] input: ImPS/2 Generic Wheel Mouse as /class/input/input3
[   23.749104] device: 'mouse0': device_add
[   23.749290] evbug.c: Connected device: input3 (ImPS/2 Generic Wheel Mouse at isa0060/serio1/input0)
[   23.753233] driver: 'serio1': driver_bound: bound to device 'psmouse'
[   23.753239] bus: 'serio': really_probe: bound device serio1 to driver psmouse
[   23.790217] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 44771 usecs
[   23.797259] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   23.802163] bus: 'i2c': add driver saa7115
[   23.806337] i2c-core: driver [saa7115] registered
[   23.811066] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8694 usecs
[   23.818016] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   23.822920] bus: 'i2c': add driver saa717x
[   23.827056] i2c-core: driver [saa717x] registered
[   23.831789] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8662 usecs
[   23.838737] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   23.843641] bus: 'i2c': add driver saa7127
[   23.847778] i2c-core: driver [saa7127] registered
[   23.852510] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8661 usecs
[   23.859459] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   23.864363] bus: 'i2c': add driver saa7185
[   23.868501] i2c-core: driver [saa7185] registered
[   23.873233] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8662 usecs
[   23.880205] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   23.885083] bus: 'i2c': add driver saa7191
[   23.889221] i2c-core: driver [saa7191] registered
[   23.893955] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8660 usecs
[   23.900927] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   23.905805] bus: 'i2c': add driver adv7170
[   23.909956] i2c-core: driver [adv7170] registered
[   23.914686] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8669 usecs
[   23.921658] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   23.926536] bus: 'i2c': add driver adv7175
[   23.930710] i2c-core: driver [adv7175] registered
[   23.935413] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8669 usecs
[   23.942389] calling  adv7180_init+0x0/0x14 @ 1
[   23.946833] bus: 'i2c': add driver adv7180
[   23.950995] i2c-core: driver [adv7180] registered
[   23.955702] initcall adv7180_init+0x0/0x14 returned 0 after 8661 usecs
[   23.962245] calling  init_adv7343+0x0/0x14 @ 1
[   23.966690] bus: 'i2c': add driver adv7343
[   23.970851] i2c-core: driver [adv7343] registered
[   23.975558] initcall init_adv7343+0x0/0x14 returned 0 after 8660 usecs
[   23.982099] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   23.986977] bus: 'i2c': add driver bt819
[   23.990966] i2c-core: driver [bt819] registered
[   23.995501] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8323 usecs
[   24.002476] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   24.007354] bus: 'i2c': add driver bt856
[   24.011342] i2c-core: driver [bt856] registered
[   24.015874] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8321 usecs
[   24.022850] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   24.027729] bus: 'i2c': add driver ks0127
[   24.031818] i2c-core: driver [ks0127] registered
[   24.036433] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8500 usecs
[   24.043410] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   24.048286] bus: 'i2c': add driver tvp5150
[   24.052463] i2c-core: driver [tvp5150] registered
[   24.057162] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8669 usecs
[   24.064140] calling  tvp514x_init+0x0/0x14 @ 1
[   24.068584] bus: 'i2c': add driver tvp514x
[   24.072745] i2c-core: driver [tvp514x] registered
[   24.077451] initcall tvp514x_init+0x0/0x14 returned 0 after 8661 usecs
[   24.083994] calling  v4l2_i2c_drv_init+0x0/0x67 @ 1
[   24.088873] bus: 'i2c': add driver msp3400
[   24.093035] i2c-core: driver [msp3400] registered
[   24.097741] initcall v4l2_i2c_drv_init+0x0/0x67 returned 0 after 8661 usecs
[   24.104717] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   24.109594] bus: 'i2c': add driver cs5345
[   24.113671] i2c-core: driver [cs5345] registered
[   24.118290] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8492 usecs
[   24.125265] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   24.130165] bus: 'i2c': add driver cs53l32a
[   24.134390] i2c-core: driver [cs53l32a] registered
[   24.139183] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8814 usecs
[   24.146162] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   24.151060] bus: 'i2c': add driver m52790
[   24.155140] i2c-core: driver [m52790] registered
[   24.159757] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8500 usecs
[   24.166737] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   24.171635] bus: 'i2c': add driver tlv320aic23b
[   24.176207] i2c-core: driver [tlv320aic23b] registered
[   24.181371] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 9508 usecs
[   24.188321] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   24.193225] bus: 'i2c': add driver wm8775
[   24.197275] i2c-core: driver [wm8775] registered
[   24.201919] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8491 usecs
[   24.208869] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   24.213774] bus: 'i2c': add driver wm8739
[   24.217824] i2c-core: driver [wm8739] registered
[   24.222468] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8491 usecs
[   24.229417] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   24.234323] bus: 'i2c': add driver vp27smpx
[   24.238549] i2c-core: driver [vp27smpx] registered
[   24.243363] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8829 usecs
[   24.250335] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   24.255215] bus: 'i2c': add driver cx25840
[   24.259354] i2c-core: driver [cx25840] registered
[   24.264087] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8662 usecs
[   24.271059] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   24.275937] bus: 'i2c': add driver upd64031a
[   24.280302] i2c-core: driver [upd64031a] registered
[   24.285177] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 9024 usecs
[   24.292153] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   24.297031] bus: 'i2c': add driver upd64083
[   24.301280] i2c-core: driver [upd64083] registered
[   24.306073] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8831 usecs
[   24.313050] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   24.317928] bus: 'i2c': add driver ov7670
[   24.322001] i2c-core: driver [ov7670] registered
[   24.326622] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8491 usecs
[   24.333609] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   24.338485] bus: 'i2c': add driver mt9v011
[   24.342647] i2c-core: driver [mt9v011] registered
[   24.347353] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8660 usecs
[   24.354330] calling  mt9m111_mod_init+0x0/0x14 @ 1
[   24.359121] bus: 'i2c': add driver mt9m111
[   24.363284] i2c-core: driver [mt9m111] registered
[   24.367988] initcall mt9m111_mod_init+0x0/0x14 returned 0 after 8660 usecs
[   24.374879] calling  mt9t031_mod_init+0x0/0x14 @ 1
[   24.379670] bus: 'i2c': add driver mt9t031
[   24.383845] i2c-core: driver [mt9t031] registered
[   24.388547] initcall mt9t031_mod_init+0x0/0x14 returned 0 after 8670 usecs
[   24.395435] calling  mt9t112_module_init+0x0/0x14 @ 1
[   24.400508] bus: 'i2c': add driver mt9t112
[   24.404675] i2c-core: driver [mt9t112] registered
[   24.409378] initcall mt9t112_module_init+0x0/0x14 returned 0 after 8669 usecs
[   24.416544] calling  ov772x_module_init+0x0/0x14 @ 1
[   24.421524] bus: 'i2c': add driver ov772x
[   24.425575] i2c-core: driver [ov772x] registered
[   24.430219] initcall ov772x_module_init+0x0/0x14 returned 0 after 8492 usecs
[   24.437256] calling  ov9640_module_init+0x0/0x14 @ 1
[   24.442248] bus: 'i2c': add driver ov9640
[   24.446297] i2c-core: driver [ov9640] registered
[   24.450941] initcall ov9640_module_init+0x0/0x14 returned 0 after 8491 usecs
[   24.457978] calling  bttv_init_module+0x0/0xe8 @ 1
[   24.462794] bttv: driver version 0.9.18 loaded
[   24.467237] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   24.474135] bus: 'bttv-sub': registered
[   24.477975] bus: 'pci': add driver bttv
[   24.481944] initcall bttv_init_module+0x0/0xe8 returned 0 after 18700 usecs
[   24.488893] calling  cpia_init+0x0/0x6d @ 1
[   24.493103] V4L-Driver for Vision CPiA based cameras v1.2.3
[   24.498669] Since in-kernel colorspace conversion is not allowed, it is disabled by default now. Users should fix the applications in case they don't work without conversion reenabled by setting the 'colorspace_conv' module parameter to 1
[   24.519799] initcall cpia_init+0x0/0x6d returned 0 after 26069 usecs
[   24.526164] calling  cpia_init+0x0/0x168 @ 1
[   24.530455] Parallel port driver for Vision CPiA based cameras v1.2.3
[   24.536895] initcall cpia_init+0x0/0x168 returned 0 after 6293 usecs
[   24.543264] calling  usb_cpia_init+0x0/0x5a @ 1
[   24.547794] USB driver for Vision CPiA based cameras v1.2.3
[   24.553392] bus: 'usb': add driver cpia
[   24.557305] usbcore: registered new interface driver cpia
[   24.562724] initcall usb_cpia_init+0x0/0x5a returned 0 after 14576 usecs
[   24.569417] calling  v4l2_i2c_drv_init+0x0/0x6d @ 1
[   24.574322] bus: 'i2c': add driver saa6752hs
[   24.578633] i2c-core: driver [saa6752hs] registered
[   24.583535] initcall v4l2_i2c_drv_init+0x0/0x6d returned 0 after 8998 usecs
[   24.590505] calling  saa7134_init+0x0/0x4a @ 1
[   24.594941] saa7130/34: v4l2 driver version 0.2.15 loaded
[   24.600364] bus: 'pci': add driver saa7134
[   24.604570] initcall saa7134_init+0x0/0x4a returned 0 after 9401 usecs
[   24.611118] calling  empress_register+0x0/0x12 @ 1
[   24.615961] initcall empress_register+0x0/0x12 returned 0 after 52 usecs
[   24.622678] calling  em28xx_module_init+0x0/0x48 @ 1
[   24.627645] bus: 'usb': add driver em28xx
[   24.631739] usbcore: registered new interface driver em28xx
[   24.637302] em28xx driver loaded
[   24.640550] initcall em28xx_module_init+0x0/0x48 returned 0 after 12602 usecs
[   24.647677] calling  usbvision_init+0x0/0x104 @ 1
[   24.652408] bus: 'usb': add driver usbvision
[   24.656787] usbcore: registered new interface driver usbvision
[   24.662641] USBVision USB Video Device Driver for Linux : 0.9.10
[   24.668644] initcall usbvision_init+0x0/0x104 returned 0 after 15861 usecs
[   24.675537] calling  pvr_init+0x0/0xb2 @ 1
[   24.679765] device class 'pvrusb2': registering
[   24.684362] bus: 'usb': add driver pvrusb2
[   24.688517] usbcore: registered new interface driver pvrusb2
[   24.694191] pvrusb2: V4L in-tree version:Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner
[   24.702029] pvrusb2: Debug mask is 31 (0x1f)
[   24.706297] initcall pvr_init+0x0/0xb2 returned 0 after 26035 usecs
[   24.712576] calling  cpia2_init+0x0/0x16b @ 1
[   24.716927] cpia2: V4L-Driver for Vision CPiA2 based cameras v2.0.0
[   24.723211] bus: 'usb': add driver cpia2
[   24.727180] usbcore: registered new interface driver cpia2
[   24.732690] initcall cpia2_init+0x0/0x16b returned 0 after 15389 usecs
[   24.739207] calling  mxb_init_module+0x0/0x57 @ 1
[   24.743934] saa7146: register extension 'Multimedia eXtension Board'.
[   24.750403] bus: 'pci': add driver Multimedia eXtension Board
[   24.756247] initcall mxb_init_module+0x0/0x57 returned 0 after 12027 usecs
[   24.763139] calling  hexium_init_module+0x0/0x57 @ 1
[   24.768094] saa7146: register extension 'hexium HV-PCI6 Orion'.
[   24.774034] bus: 'pci': add driver hexium HV-PCI6 Orion
[   24.779421] initcall hexium_init_module+0x0/0x57 returned 0 after 11060 usecs
[   24.786573] calling  hexium_init_module+0x0/0x57 @ 1
[   24.791550] saa7146: register extension 'hexium gemini'.
[   24.796861] bus: 'pci': add driver hexium gemini
[   24.801578] initcall hexium_init_module+0x0/0x57 returned 0 after 9792 usecs
[   24.808619] calling  cafe_init+0x0/0x4b @ 1
[   24.812824] Marvell M88ALP01 'CAFE' Camera Controller version 2
[   24.818736] bus: 'pci': add driver cafe1000-ccic
[   24.823453] initcall cafe_init+0x0/0x4b returned 0 after 10377 usecs
[   24.829801] calling  usb_se401_init+0x0/0x57 @ 1
[   24.834454] SE401 usb camera driver version 0.24 registering
[   24.840126] bus: 'usb': add driver se401
[   24.844097] usbcore: registered new interface driver se401
[   24.849578] initcall usb_se401_init+0x0/0x57 returned 0 after 14775 usecs
[   24.856385] calling  zr364xx_init+0x0/0x3f @ 1
[   24.860841] bus: 'usb': add driver zr364xx
[   24.865019] usbcore: registered new interface driver zr364xx
[   24.870692] zr364xx: Zoran 364xx
[   24.873918] initcall zr364xx_init+0x0/0x3f returned 0 after 12774 usecs
[   24.880546] calling  et61x251_module_init+0x0/0xa2 @ 1
[   24.885677] et61x251: V4L2 driver for ET61X[12]51 PC Camera Controllers v1:1.09
[   24.893002] bus: 'usb': add driver et61x251
[   24.897229] usbcore: registered new interface driver et61x251
[   24.902995] initcall et61x251_module_init+0x0/0xa2 returned 0 after 16906 usecs
[   24.910316] calling  usb_pwc_init+0x0/0x2c4 @ 1
[   24.914841] pwc: Philips webcam module version 10.0.13 loaded.
[   24.920689] pwc: Supports Philips PCA645/646, PCVC675/680/690, PCVC720[40]/730/740/750 & PCVC830/840.
[   24.929891] pwc: Also supports the Askey VC010, various Logitech Quickcams, Samsung MPC-C10 and MPC-C30,
[   24.939389] pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina Eye and Visionite VCS-UC300 and VCS-UM100.
[   24.948791] bus: 'usb': add driver Philips webcam
[   24.953562] usbcore: registered new interface driver Philips webcam
[   24.959820] initcall usb_pwc_init+0x0/0x2c4 returned 0 after 43924 usecs
[   24.966539] calling  zc0301_module_init+0x0/0xa3 @ 1
[   24.971512] zc0301: V4L2 driver for ZC0301[P] Image Processor and Control Chip v1:1.10
[   24.979415] bus: 'usb': add driver zc0301
[   24.983498] usbcore: registered new interface driver zc0301
[   24.989065] initcall zc0301_module_init+0x0/0xa3 returned 0 after 17143 usecs
[   24.996213] calling  gspca_init+0x0/0x22 @ 1
[   25.000496] gspca: main v2.9.0 registered
[   25.004500] initcall gspca_init+0x0/0x22 returned 0 after 3912 usecs
[   25.010948] calling  sd_mod_init+0x0/0x38 @ 1
[   25.015299] bus: 'usb': add driver cpia1
[   25.019287] usbcore: registered new interface driver cpia1
[   25.024790] cpia1: registered
[   25.027753] initcall sd_mod_init+0x0/0x38 returned 0 after 12162 usecs
[   25.034300] calling  sd_mod_init+0x0/0x38 @ 1
[   25.038657] bus: 'usb': add driver finepix
[   25.042838] usbcore: registered new interface driver finepix
[   25.048488] finepix: registered
[   25.051651] initcall sd_mod_init+0x0/0x38 returned 0 after 12687 usecs
[   25.058170] calling  sd_mod_init+0x0/0x38 @ 1
[   25.062553] bus: 'usb': add driver mars
[   25.066439] usbcore: registered new interface driver mars
[   25.071848] mars: registered
[   25.074727] initcall sd_mod_init+0x0/0x38 returned 0 after 11892 usecs
[   25.081269] calling  sd_mod_init+0x0/0x38 @ 1
[   25.085622] bus: 'usb': add driver ov519
[   25.089595] usbcore: registered new interface driver ov519
[   25.095101] ov519: registered
[   25.098066] initcall sd_mod_init+0x0/0x38 returned 0 after 12153 usecs
[   25.104608] calling  sd_mod_init+0x0/0x38 @ 1
[   25.108963] bus: 'usb': add driver ov534
[   25.112955] usbcore: registered new interface driver ov534
[   25.118430] ov534: registered
[   25.121417] initcall sd_mod_init+0x0/0x38 returned 0 after 12160 usecs
[   25.127937] calling  sd_mod_init+0x0/0x38 @ 1
[   25.132325] bus: 'usb': add driver ov534_9
[   25.136495] usbcore: registered new interface driver ov534_9
[   25.142170] ov534_9: registered
[   25.145309] initcall sd_mod_init+0x0/0x38 returned 0 after 12683 usecs
[   25.151851] calling  sd_mod_init+0x0/0x38 @ 1
[   25.156204] bus: 'usb': add driver pac207
[   25.160283] usbcore: registered new interface driver pac207
[   25.165845] pac207: registered
[   25.168896] initcall sd_mod_init+0x0/0x38 returned 0 after 12399 usecs
[   25.175444] calling  sd_mod_init+0x0/0x38 @ 1
[   25.179796] bus: 'usb': add driver pac7302
[   25.183962] usbcore: registered new interface driver pac7302
[   25.189609] pac7302: registered
[   25.192770] initcall sd_mod_init+0x0/0x38 returned 0 after 12667 usecs
[   25.199292] calling  sd_mod_init+0x0/0x38 @ 1
[   25.203673] bus: 'usb': add driver sn9c2028
[   25.207907] usbcore: registered new interface driver sn9c2028
[   25.213671] sn9c2028: registered
[   25.216897] initcall sd_mod_init+0x0/0x38 returned 0 after 12917 usecs
[   25.223439] calling  sd_mod_init+0x0/0x2f @ 1
[   25.227792] bus: 'usb': add driver sn9c20x
[   25.232005] usbcore: registered new interface driver sn9c20x
[   25.237659] sn9c20x: registered
[   25.240819] initcall sd_mod_init+0x0/0x2f returned 0 after 12720 usecs
[   25.247339] calling  sd_mod_init+0x0/0x2f @ 1
[   25.251722] bus: 'usb': add driver sonixj
[   25.255784] usbcore: registered new interface driver sonixj
[   25.261374] sonixj: registered
[   25.264425] initcall sd_mod_init+0x0/0x2f returned 0 after 12409 usecs
[   25.270968] calling  sd_mod_init+0x0/0x38 @ 1
[   25.275321] bus: 'usb': add driver spca500
[   25.279464] usbcore: registered new interface driver spca500
[   25.285138] spca500: registered
[   25.288278] initcall sd_mod_init+0x0/0x38 returned 0 after 12654 usecs
[   25.294819] calling  sd_mod_init+0x0/0x38 @ 1
[   25.299172] bus: 'usb': add driver spca506
[   25.303338] usbcore: registered new interface driver spca506
[   25.308985] spca506: registered
[   25.312146] initcall sd_mod_init+0x0/0x38 returned 0 after 12668 usecs
[   25.318666] calling  sd_mod_init+0x0/0x38 @ 1
[   25.323049] bus: 'usb': add driver spca508
[   25.327198] usbcore: registered new interface driver spca508
[   25.332880] spca508: registered
[   25.336023] initcall sd_mod_init+0x0/0x38 returned 0 after 12673 usecs
[   25.342564] calling  sd_mod_init+0x0/0x38 @ 1
[   25.346916] bus: 'usb': add driver spca561
[   25.351102] usbcore: registered new interface driver spca561
[   25.356749] spca561: registered
[   25.359888] initcall sd_mod_init+0x0/0x38 returned 0 after 12672 usecs
[   25.366434] calling  sd_mod_init+0x0/0x38 @ 1
[   25.370812] bus: 'usb': add driver sq905
[   25.374785] usbcore: registered new interface driver sq905
[   25.380290] sq905: registered
[   25.383257] initcall sd_mod_init+0x0/0x38 returned 0 after 12156 usecs
[   25.389777] calling  sd_mod_init+0x0/0x38 @ 1
[   25.394160] bus: 'usb': add driver sq905c
[   25.398221] usbcore: registered new interface driver sq905c
[   25.403811] sq905c: registered
[   25.406865] initcall sd_mod_init+0x0/0x38 returned 0 after 12411 usecs
[   25.413407] calling  sd_mod_init+0x0/0x38 @ 1
[   25.417760] bus: 'usb': add driver stv0680
[   25.421926] usbcore: registered new interface driver stv0680
[   25.427573] stv0680: registered
[   25.430739] initcall sd_mod_init+0x0/0x38 returned 0 after 12673 usecs
[   25.437254] calling  sd_mod_init+0x0/0x38 @ 1
[   25.441637] bus: 'usb': add driver tv8532
[   25.445727] usbcore: registered new interface driver tv8532
[   25.451314] tv8532: registered
[   25.454367] initcall sd_mod_init+0x0/0x38 returned 0 after 12435 usecs
[   25.460910] calling  sd_mod_init+0x0/0x38 @ 1
[   25.465263] bus: 'usb': add driver vc032x
[   25.469320] usbcore: registered new interface driver vc032x
[   25.474913] vc032x: registered
[   25.477966] initcall sd_mod_init+0x0/0x38 returned 0 after 12406 usecs
[   25.484507] calling  sd_mod_init+0x0/0x38 @ 1
[   25.488862] bus: 'usb': add driver STV06xx
[   25.493027] usbcore: registered new interface driver STV06xx
[   25.498677] STV06xx: registered
[   25.501845] initcall sd_mod_init+0x0/0x38 returned 0 after 12676 usecs
[   25.508367] calling  sd_mod_init+0x0/0x5b @ 1
[   25.512744] gspca_gl860: driver startup - version 0.9d10
[   25.518050] bus: 'usb': add driver gspca_gl860
[   25.522566] usbcore: registered new interface driver gspca_gl860
[   25.528566] gspca_gl860: driver registered
[   25.532687] initcall sd_mod_init+0x0/0x5b returned 0 after 19474 usecs
[   25.539202] calling  hdpvr_init+0x0/0x3a @ 1
[   25.543497] bus: 'usb': add driver hdpvr
[   25.547513] usbcore: registered new interface driver hdpvr
[   25.553013] initcall hdpvr_init+0x0/0x3a returned 0 after 9294 usecs
[   25.559361] calling  ibmcam_init+0x0/0x85 @ 1
[   25.563754] bus: 'usb': add driver ibmcam
[   25.567814] usbcore: registered new interface driver ibmcam
[   25.573408] initcall ibmcam_init+0x0/0x85 returned 0 after 9439 usecs
[   25.579841] calling  ultracam_init+0x0/0x85 @ 1
[   25.584407] bus: 'usb': add driver ultracam
[   25.588638] usbcore: registered new interface driver ultracam
[   25.594406] initcall ultracam_init+0x0/0x85 returned 0 after 9775 usecs
[   25.601034] calling  konicawc_init+0x0/0x9b @ 1
[   25.605556] konicawc: v1.4:Konica Webcam driver
[   25.610116] bus: 'usb': add driver konicawc
[   25.614346] usbcore: registered new interface driver konicawc
[   25.620112] initcall konicawc_init+0x0/0x9b returned 0 after 14210 usecs
[   25.626806] calling  qcm_init+0x0/0x47 @ 1
[   25.630932] quickcam_messenger: v0.01:Logitech Quickcam Messenger USB
[   25.637372] bus: 'usb': add driver QCM
[   25.641222] usbcore: registered new interface driver QCM
[   25.646535] initcall qcm_init+0x0/0x47 returned 0 after 15239 usecs
[   25.652819] calling  usb_s2255_init+0x0/0x51 @ 1
[   25.657439] bus: 'usb': add driver s2255
[   25.661432] usbcore: registered new interface driver s2255
[   25.666910] initcall usb_s2255_init+0x0/0x51 returned 0 after 9251 usecs
[   25.673627] calling  module_start+0x0/0x9e @ 1
[   25.678062] ivtv: Start initialization, version 1.4.1
[   25.683138] bus: 'pci': add driver ivtv
[   25.687057] ivtv: End initialization
[   25.690650] initcall module_start+0x0/0x9e returned 0 after 12288 usecs
[   25.697258] calling  vivi_init+0x0/0x24a @ 1
[   25.701621] device: 'video0': device_add
[   25.705666] vivi-000: V4L2 device registered as video0
[   25.710826] Video Technology Magazine Virtual Video Capture Board ver 0.6.0 successfully loaded.
[   25.719601] initcall vivi_init+0x0/0x24a returned 0 after 17633 usecs
[   25.726060] calling  soc_camera_init+0x0/0x65 @ 1
[   25.730979] bus: 'soc-camera': registered
[   25.734985] bus: 'soc-camera': add driver camera
[   25.739680] bus: 'platform': add driver soc-camera-pdrv
[   25.745021] bus: 'platform': remove driver soc-camera-pdrv
[   25.750579] driver: 'soc-camera-pdrv': driver_release
[   25.755639] bus: 'soc-camera': remove driver camera
[   25.760594] driver: 'camera': driver_release
[   25.764862] bus: 'soc-camera': unregistering
[   25.769307] initcall soc_camera_init+0x0/0x65 returned -19 after 37626 usecs
[   25.776373] calling  soc_mbus_init+0x0/0x8 @ 1
[   25.780838] initcall soc_mbus_init+0x0/0x8 returned 0 after 1 usecs
[   25.787098] calling  ir_init+0x0/0x14 @ 1
[   25.791137] bus: 'i2c': add driver ir-kbd-i2c
[   25.795549] i2c-core: driver [ir-kbd-i2c] registered
[   25.800539] initcall ir_init+0x0/0x14 returned 0 after 9187 usecs
[   25.806625] calling  w1_init+0x0/0xa4 @ 1
[   25.810655] Driver for 1-wire Dallas network protocol.
[   25.815869] bus: 'w1': registered
[   25.819181] bus: 'w1': add driver w1_master_driver
[   25.824068] bus: 'w1': add driver w1_slave_driver
[   25.828841] initcall w1_init+0x0/0xa4 returned 0 after 17760 usecs
[   25.835057] calling  sensors_ds2482_init+0x0/0x14 @ 1
[   25.840125] bus: 'i2c': add driver ds2482
[   25.844222] i2c-core: driver [ds2482] registered
[   25.848842] initcall sensors_ds2482_init+0x0/0x14 returned 0 after 8519 usecs
[   25.855994] calling  w1_gpio_init+0x0/0x19 @ 1
[   25.860460] bus: 'platform': add driver w1-gpio
[   25.865087] bus: 'platform': remove driver w1-gpio
[   25.869930] driver: 'w1-gpio': driver_release
[   25.874313] initcall w1_gpio_init+0x0/0x19 returned -19 after 13530 usecs
[   25.881108] calling  w1_therm_init+0x0/0x32 @ 1
[   25.885682] initcall w1_therm_init+0x0/0x32 returned 0 after 47 usecs
[   25.892134] calling  w1_f23_init+0x0/0x12 @ 1
[   25.896496] initcall w1_f23_init+0x0/0x12 returned 0 after 3 usecs
[   25.902690] calling  w1_ds2760_init+0x0/0x2c @ 1
[   25.907299] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[   25.916101] initcall w1_ds2760_init+0x0/0x2c returned 0 after 8591 usecs
[   25.922813] calling  pda_power_init+0x0/0x12 @ 1
[   25.927427] bus: 'platform': add driver pda-power
[   25.932255] initcall pda_power_init+0x0/0x12 returned 0 after 4712 usecs
[   25.938948] calling  max8925_power_init+0x0/0x12 @ 1
[   25.943938] bus: 'platform': add driver max8925-power
[   25.949070] initcall max8925_power_init+0x0/0x12 returned 0 after 5015 usecs
[   25.956129] calling  ds2760_battery_init+0x0/0x12 @ 1
[   25.961191] bus: 'platform': add driver ds2760-battery
[   25.966401] initcall ds2760_battery_init+0x0/0x12 returned 0 after 5092 usecs
[   25.973550] calling  max17040_init+0x0/0x14 @ 1
[   25.978085] bus: 'i2c': add driver max17040
[   25.982360] i2c-core: driver [max17040] registered
[   25.987150] initcall max17040_init+0x0/0x14 returned 0 after 8855 usecs
[   25.993779] calling  pcf50633_mbc_init+0x0/0x12 @ 1
[   25.998658] bus: 'platform': add driver pcf50633-mbc
[   26.003724] initcall pcf50633_mbc_init+0x0/0x12 returned 0 after 4944 usecs
[   26.010696] calling  pcipcwd_init_module+0x0/0x35 @ 1
[   26.015759] bus: 'pci': add driver pcwd_pci
[   26.020159] initcall pcipcwd_init_module+0x0/0x35 returned 0 after 4303 usecs
[   26.027281] calling  wdtpci_init+0x0/0x1b @ 1
[   26.031673] bus: 'pci': add driver wdt_pci
[   26.035886] initcall wdtpci_init+0x0/0x1b returned 0 after 4121 usecs
[   26.042338] calling  usb_pcwd_init+0x0/0x4b @ 1
[   26.046869] bus: 'usb': add driver pcwd_usb
[   26.051166] usbcore: registered new interface driver pcwd_usb
[   26.056903] pcwd_usb: Berkshire USB-PC Watchdog driver v1.02
[   26.062586] initcall usb_pcwd_init+0x0/0x4b returned 0 after 15352 usecs
[   26.069280] calling  acq_init+0x0/0x5f @ 1
[   26.073399] WDT driver for Acquire single board computer initialising.
[   26.079917] bus: 'platform': add driver acquirewdt
[   26.084844] Registering platform device 'acquirewdt'. Parent at platform
[   26.091560] device: 'acquirewdt': device_add
[   26.095841] bus: 'platform': add device acquirewdt
[   26.100778] bus: 'platform': driver_probe_device: matched device acquirewdt with driver acquirewdt
[   26.109725] bus: 'platform': really_probe: probing driver acquirewdt with device acquirewdt
[   26.118150] acquirewdt: I/O address 0x0043 already in use
[   26.123574] acquirewdt: probe of acquirewdt failed with error -5
[   26.129581] initcall acq_init+0x0/0x5f returned 0 after 54868 usecs
[   26.135867] calling  alim7101_wdt_init+0x0/0x196 @ 1
[   26.140845] alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
[   26.146349] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   26.152459] initcall alim7101_wdt_init+0x0/0x196 returned -16 after 11340 usecs
[   26.159760] initcall alim7101_wdt_init+0x0/0x196 returned with error code -16 
[   26.166999] calling  ibmasr_init+0x0/0x263 @ 1
[   26.171459] initcall ibmasr_init+0x0/0x263 returned -19 after 1 usecs
[   26.177891] calling  wafwdt_init+0x0/0x16a @ 1
[   26.182358] WDT driver for Wafer 5823 single board computer initialising.
[   26.189160] device: 'watchdog': device_add
[   26.193357] Wafer 5823 WDT: initialized. timeout=60 sec (nowayout=0)
[   26.199707] initcall wafwdt_init+0x0/0x16a returned 0 after 16945 usecs
[   26.206340] calling  iTCO_wdt_init_module+0x0/0x67 @ 1
[   26.211494] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   26.217059] bus: 'platform': add driver iTCO_wdt
[   26.221750] Registering platform device 'iTCO_wdt'. Parent at platform
[   26.228272] device: 'iTCO_wdt': device_add
[   26.232407] bus: 'platform': add device iTCO_wdt
[   26.237118] bus: 'platform': driver_probe_device: matched device iTCO_wdt with driver iTCO_wdt
[   26.245737] bus: 'platform': really_probe: probing driver iTCO_wdt with device iTCO_wdt
[   26.253877] iTCO_wdt: No card detected
[   26.257644] initcall iTCO_wdt_init_module+0x0/0x67 returned 0 after 45068 usecs
[   26.264970] calling  it8712f_wdt_init+0x0/0x1f1 @ 1
[   26.269925] it8712f_wdt: Found IT8712F chip revision 7 - using DogFood address 0x201
[   26.277690] it8712f_wdt: disabling watchdog timer
[   26.282429] it8712f_wdt: cannot register miscdev on minor=130 (err=-16)
[   26.289038] initcall it8712f_wdt_init+0x0/0x1f1 returned -16 after 18740 usecs
[   26.296273] initcall it8712f_wdt_init+0x0/0x1f1 returned with error code -16 
[   26.303415] calling  it87_wdt_init+0x0/0x4c9 @ 1
[   26.308057] IT87 WDT: Unsupported Chip found, Chip 8712 Revision 07
[   26.314336] initcall it87_wdt_init+0x0/0x4c9 returned -19 after 6158 usecs
[   26.321224] calling  hpwdt_init+0x0/0x1b @ 1
[   26.325502] bus: 'pci': add driver hpwdt
[   26.329521] initcall hpwdt_init+0x0/0x1b returned 0 after 3938 usecs
[   26.335897] calling  sc1200wdt_init+0x0/0x16a @ 1
[   26.340613] sc1200wdt: build 20020303
[   26.344271] bus: 'pnp': add driver scl200wdt
[   26.348613] sc1200wdt: io parameter must be specified
[   26.353702] bus: 'pnp': remove driver scl200wdt
[   26.358257] driver: 'scl200wdt': driver_release
[   26.362814] initcall sc1200wdt_init+0x0/0x16a returned -22 after 21678 usecs
[   26.369853] initcall sc1200wdt_init+0x0/0x16a returned with error code -22 
[   26.376832] calling  sbc60xxwdt_init+0x0/0x185 @ 1
[   26.381637] sbc60xxwdt: I/O address 0x0443 already in use
[   26.387032] initcall sbc60xxwdt_init+0x0/0x185 returned -5 after 5276 usecs
[   26.394008] initcall sbc60xxwdt_init+0x0/0x185 returned with error code -5 
[   26.400977] calling  sbc8360_init+0x0/0x1a6 @ 1
[   26.405507] sbc8360: failed to register misc device
[   26.410403] initcall sbc8360_init+0x0/0x1a6 returned -16 after 4782 usecs
[   26.417180] initcall sbc8360_init+0x0/0x1a6 returned with error code -16 
[   26.423988] calling  cpu5wdt_init_module+0x0/0x147 @ 1
[   26.429125] cpu5wdt: sorry, was my fault
[   26.433076] cpu5wdt: misc_register failed
[   26.437085] initcall cpu5wdt_init_module+0x0/0x147 returned -16 after 7780 usecs
[   26.444492] initcall cpu5wdt_init_module+0x0/0x147 returned with error code -16 
[   26.451893] calling  sch311x_wdt_init+0x0/0x160 @ 1
[   26.456785] initcall sch311x_wdt_init+0x0/0x160 returned -19 after 19 usecs
[   26.463759] calling  wdt_init+0x0/0x1e1 @ 1
[   26.467937] WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O chip initialising.
[   26.475984] w83627hf/thf/hg WDT: Watchdog already running. Resetting timeout to 60 sec
[   26.483935] w83627hf/thf/hg WDT: cannot register miscdev on minor=130 (err=-16)
[   26.491253] initcall wdt_init+0x0/0x1e1 returned -16 after 22765 usecs
[   26.497774] initcall wdt_init+0x0/0x1e1 returned with error code -16 
[   26.504232] calling  w83877f_wdt_init+0x0/0x15d @ 1
[   26.509109] w83877f_wdt: I/O address 0x0443 already in use
[   26.514610] initcall w83877f_wdt_init+0x0/0x15d returned -5 after 5372 usecs
[   26.521669] initcall w83877f_wdt_init+0x0/0x15d returned with error code -5 
[   26.528706] calling  zf_init+0x0/0x164 @ 1
[   26.532830] machzwd: MachZ ZF-Logic Watchdog driver initializing.
[   26.538914] machzwd: no ZF-Logic found
[   26.542680] initcall zf_init+0x0/0x164 returned -19 after 9617 usecs
[   26.549021] calling  watchdog_init+0x0/0xb8 @ 1
[   26.553577] epx_c3: cannot register miscdev on minor=130 (err=-16)
[   26.559754] initcall watchdog_init+0x0/0xb8 returned -16 after 6039 usecs
[   26.566557] initcall watchdog_init+0x0/0xb8 returned with error code -16 
[   26.573358] calling  wm831x_wdt_init+0x0/0x12 @ 1
[   26.578060] bus: 'platform': add driver wm831x-watchdog
[   26.583366] initcall wm831x_wdt_init+0x0/0x12 returned 0 after 5179 usecs
[   26.590165] calling  wm8350_wdt_init+0x0/0x12 @ 1
[   26.594871] bus: 'platform': add driver wm8350-wdt
[   26.599708] initcall wm8350_wdt_init+0x0/0x12 returned 0 after 4728 usecs
[   26.606510] calling  watchdog_init+0x0/0xb6 @ 1
[   26.611054] SoftDog: cannot register miscdev on minor=130 (err=-16)
[   26.617317] initcall watchdog_init+0x0/0xb6 returned -16 after 6121 usecs
[   26.624121] initcall watchdog_init+0x0/0xb6 returned with error code -16 
[   26.630929] calling  bfusb_init+0x0/0x55 @ 1
[   26.635197] Bluetooth: BlueFRITZ! USB driver ver 1.2
[   26.640189] bus: 'usb': add driver bfusb
[   26.644167] usbcore: registered new interface driver bfusb
[   26.649649] initcall bfusb_init+0x0/0x55 returned 0 after 14116 usecs
[   26.656111] calling  init_btuart_cs+0x0/0x12 @ 1
[   26.660750] bus: 'pcmcia': add driver btuart_cs
[   26.665327] initcall init_btuart_cs+0x0/0x12 returned 0 after 4474 usecs
[   26.672040] calling  cpufreq_stats_init+0x0/0xd2 @ 1
[   26.677033] initcall cpufreq_stats_init+0x0/0xd2 returned 0 after 26 usecs
[   26.683921] calling  cpufreq_gov_userspace_init+0x0/0x12 @ 1
[   26.689576] initcall cpufreq_gov_userspace_init+0x0/0x12 returned 0 after 4 usecs
[   26.697068] calling  cpufreq_gov_dbs_init+0x0/0x67 @ 1
[   26.702491] initcall cpufreq_gov_dbs_init+0x0/0x67 returned 0 after 265 usecs
[   26.709614] calling  init_ladder+0x0/0x12 @ 1
[   26.714015] cpuidle: using governor ladder
[   26.718112] initcall init_ladder+0x0/0x12 returned 0 after 4023 usecs
[   26.724569] calling  init_menu+0x0/0x12 @ 1
[   26.728746] cpuidle: using governor menu
[   26.732697] initcall init_menu+0x0/0x12 returned 0 after 3855 usecs
[   26.738954] calling  i7300_idle_init+0x0/0x618 @ 1
[   26.743885] initcall i7300_idle_init+0x0/0x618 returned -19 after 116 usecs
[   26.750854] calling  bd2802_init+0x0/0x14 @ 1
[   26.755213] bus: 'i2c': add driver BD2802
[   26.759293] i2c-core: driver [BD2802] registered
[   26.763938] initcall bd2802_init+0x0/0x14 returned 0 after 8523 usecs
[   26.770388] calling  pca9532_init+0x0/0x14 @ 1
[   26.774828] bus: 'i2c': add driver pca9532
[   26.778963] i2c-core: driver [pca9532] registered
[   26.783690] initcall pca9532_init+0x0/0x14 returned 0 after 8651 usecs
[   26.790228] calling  gpio_led_init+0x0/0x8 @ 1
[   26.794667] initcall gpio_led_init+0x0/0x8 returned 0 after 1 usecs
[   26.800948] calling  lp3944_module_init+0x0/0x14 @ 1
[   26.805908] bus: 'i2c': add driver lp3944
[   26.809953] i2c-core: driver [lp3944] registered
[   26.814594] initcall lp3944_module_init+0x0/0x14 returned 0 after 8479 usecs
[   26.821654] calling  clevo_mail_led_init+0x0/0x94 @ 1
[   26.826700] initcall clevo_mail_led_init+0x0/0x94 returned -19 after 3 usecs
[   26.833776] calling  pca955x_leds_init+0x0/0x14 @ 1
[   26.838650] bus: 'i2c': add driver leds-pca955x
[   26.843240] i2c-core: driver [leds-pca955x] registered
[   26.848377] initcall pca955x_leds_init+0x0/0x14 returned 0 after 9499 usecs
[   26.855351] calling  wm831x_status_init+0x0/0x12 @ 1
[   26.860331] bus: 'platform': add driver wm831x-status
[   26.865433] initcall wm831x_status_init+0x0/0x12 returned 0 after 4989 usecs
[   26.872496] calling  wm8350_led_init+0x0/0x12 @ 1
[   26.877200] bus: 'platform': add driver wm8350-led
[   26.882150] initcall wm8350_led_init+0x0/0x12 returned 0 after 4831 usecs
[   26.888932] calling  adp5520_led_init+0x0/0x12 @ 1
[   26.893747] bus: 'platform': add driver adp5520-led
[   26.898673] initcall adp5520_led_init+0x0/0x12 returned 0 after 4815 usecs
[   26.905566] calling  heartbeat_trig_init+0x0/0x12 @ 1
[   26.910635] initcall heartbeat_trig_init+0x0/0x12 returned 0 after 5 usecs
[   26.917496] calling  bl_trig_init+0x0/0x12 @ 1
[   26.921968] initcall bl_trig_init+0x0/0x12 returned 0 after 3 usecs
[   26.928227] calling  defon_trig_init+0x0/0x12 @ 1
[   26.932962] initcall defon_trig_init+0x0/0x12 returned 0 after 3 usecs
[   26.939475] calling  ib_core_init+0x0/0x44 @ 1
[   26.943943] device class 'infiniband': registering
[   26.948801] initcall ib_core_init+0x0/0x44 returned 0 after 4745 usecs
[   26.955340] calling  ib_mad_init_module+0x0/0xcd @ 1
[   26.960327] initcall ib_mad_init_module+0x0/0xcd returned 0 after 4 usecs
[   26.967106] calling  ib_sa_init+0x0/0x67 @ 1
[   26.971529] initcall ib_sa_init+0x0/0x67 returned 0 after 125 usecs
[   26.977793] calling  ib_cm_init+0x0/0x183 @ 1
[   26.982342] device class 'infiniband_cm': registering
[   26.990044] initcall ib_cm_init+0x0/0x183 returned 0 after 7682 usecs
[   26.996478] calling  iw_cm_init+0x0/0x35 @ 1
[   27.000881] initcall iw_cm_init+0x0/0x35 returned 0 after 103 usecs
[   27.007137] calling  addr_init+0x0/0x47 @ 1
[   27.011476] initcall addr_init+0x0/0x47 returned 0 after 117 usecs
[   27.017650] calling  cma_init+0x0/0xe3 @ 1
[   27.021939] initcall cma_init+0x0/0xe3 returned 0 after 163 usecs
[   27.028026] calling  ib_uverbs_init+0x0/0xcb @ 1
[   27.032671] device class 'infiniband_verbs': registering
[   27.038019] initcall ib_uverbs_init+0x0/0xcb returned 0 after 5229 usecs
[   27.044834] calling  ib_ucm_init+0x0/0xa6 @ 1
[   27.049204] initcall ib_ucm_init+0x0/0xa6 returned 0 after 10 usecs
[   27.055487] calling  ucma_init+0x0/0x54 @ 1
[   27.059680] device: 'rdma_cm': device_add
[   27.063815] initcall ucma_init+0x0/0x54 returned 0 after 4044 usecs
[   27.070100] calling  infinipath_init+0x0/0xc5 @ 1
[   27.074933] bus: 'pci': add driver ib_ipath
[   27.079255] initcall infinipath_init+0x0/0xc5 returned 0 after 4350 usecs
[   27.086063] calling  c2_init_module+0x0/0x1b @ 1
[   27.090703] bus: 'pci': add driver c2
[   27.094548] initcall c2_init_module+0x0/0x1b returned 0 after 3759 usecs
[   27.101265] calling  mlx4_ib_init+0x0/0x12 @ 1
[   27.105768] initcall mlx4_ib_init+0x0/0x12 returned 0 after 57 usecs
[   27.112142] calling  nes_init_module+0x0/0x13a @ 1
[   27.117169] bus: 'pci': add driver iw_nes
[   27.121339] initcall nes_init_module+0x0/0x13a returned 0 after 4299 usecs
[   27.128204] calling  ipoib_init_module+0x0/0x115 @ 1
[   27.133332] initcall ipoib_init_module+0x0/0x115 returned 0 after 132 usecs
[   27.140307] calling  srp_init_module+0x0/0xf2 @ 1
[   27.145018] device class 'infiniband_srp': registering
[   27.150247] initcall srp_init_module+0x0/0xf2 returned 0 after 5107 usecs
[   27.157030] calling  iser_init+0x0/0x127 @ 1
[   27.161369] device: 'iser': device_add
[   27.165208] iscsi: registered transport (iser)
[   27.169650] initcall iser_init+0x0/0x127 returned 0 after 8134 usecs
[   27.176024] calling  dcdrbu_init+0x0/0x14a @ 1
[   27.180491] Registering platform device 'dell_rbu'. Parent at platform
[   27.187009] device: 'dell_rbu': device_add
[   27.191142] bus: 'platform': add device dell_rbu
[   27.195976] initcall dcdrbu_init+0x0/0x14a returned 0 after 15128 usecs
[   27.202604] calling  dcdbas_init+0x0/0x67 @ 1
[   27.206968] bus: 'platform': add driver dcdbas
[   27.211562] Registering platform device 'dcdbas'. Parent at platform
[   27.217906] device: 'dcdbas': device_add
[   27.221867] bus: 'platform': add device dcdbas
[   27.226493] bus: 'platform': driver_probe_device: matched device dcdbas with driver dcdbas
[   27.234767] bus: 'platform': really_probe: probing driver dcdbas with device dcdbas
[   27.242478] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   27.250062] driver: 'dcdbas': driver_bound: bound to device 'dcdbas'
[   27.256411] bus: 'platform': really_probe: bound device dcdbas to driver dcdbas
[   27.263745] initcall dcdbas_init+0x0/0x67 returned 0 after 55448 usecs
[   27.270283] calling  ibft_init+0x0/0x55d @ 1
[   27.274561] No iBFT detected.
[   27.277533] initcall ibft_init+0x0/0x55d returned 0 after 2911 usecs
[   27.283908] calling  ioat_init_module+0x0/0x80 @ 1
[   27.288698] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   27.294563] bus: 'pci': add driver ioatdma
[   27.298768] initcall ioat_init_module+0x0/0x80 returned 0 after 9832 usecs
[   27.305661] calling  oprofile_init+0x0/0x55 @ 1
[   27.310212] Registering sysdev class 'oprofile'
[   27.314765] Registering sys device of class 'oprofile'
[   27.319908] Registering sys device 'oprofile0'
[   27.324389] oprofile: using NMI interrupt.
[   27.328497] initcall oprofile_init+0x0/0x55 returned 0 after 17859 usecs
[   27.335226] calling  flow_cache_init+0x0/0x1d0 @ 1
[   27.340062] initcall flow_cache_init+0x0/0x1d0 returned 0 after 27 usecs
[   27.346754] calling  llc_init+0x0/0x20 @ 1
[   27.350881] initcall llc_init+0x0/0x20 returned 0 after 5 usecs
[   27.356791] calling  llc2_init+0x0/0xcc @ 1
[   27.361379] NET: Registered protocol family 26
[   27.365824] initcall llc2_init+0x0/0xcc returned 0 after 4715 usecs
[   27.372108] calling  snap_init+0x0/0x39 @ 1
[   27.376349] initcall snap_init+0x0/0x39 returned 0 after 55 usecs
[   27.382456] calling  blackhole_module_init+0x0/0x12 @ 1
[   27.387685] initcall blackhole_module_init+0x0/0x12 returned 0 after 3 usecs
[   27.394746] calling  police_init_module+0x0/0x12 @ 1
[   27.399729] initcall police_init_module+0x0/0x12 returned 0 after 18 usecs
[   27.406620] calling  gact_init_module+0x0/0x20 @ 1
[   27.411430] GACT probability on
[   27.414576] initcall gact_init_module+0x0/0x20 returned 0 after 3073 usecs
[   27.421464] calling  nat_init_module+0x0/0x12 @ 1
[   27.426164] initcall nat_init_module+0x0/0x12 returned 0 after 2 usecs
[   27.432706] calling  pedit_init_module+0x0/0x12 @ 1
[   27.437578] initcall pedit_init_module+0x0/0x12 returned 0 after 2 usecs
[   27.444293] calling  skbedit_init_module+0x0/0x12 @ 1
[   27.449340] initcall skbedit_init_module+0x0/0x12 returned 0 after 2 usecs
[   27.456228] calling  cbq_module_init+0x0/0x12 @ 1
[   27.460956] initcall cbq_module_init+0x0/0x12 returned 0 after 2 usecs
[   27.467473] calling  htb_module_init+0x0/0x12 @ 1
[   27.472204] initcall htb_module_init+0x0/0x12 returned 0 after 2 usecs
[   27.478722] calling  red_module_init+0x0/0x12 @ 1
[   27.483458] initcall red_module_init+0x0/0x12 returned 0 after 2 usecs
[   27.489971] calling  gred_module_init+0x0/0x12 @ 1
[   27.494792] initcall gred_module_init+0x0/0x12 returned 0 after 2 usecs
[   27.501417] calling  ingress_module_init+0x0/0x12 @ 1
[   27.506470] initcall ingress_module_init+0x0/0x12 returned 0 after 2 usecs
[   27.513360] calling  sfq_module_init+0x0/0x12 @ 1
[   27.518067] initcall sfq_module_init+0x0/0x12 returned 0 after 2 usecs
[   27.524607] calling  tbf_module_init+0x0/0x12 @ 1
[   27.529308] initcall tbf_module_init+0x0/0x12 returned 0 after 2 usecs
[   27.535849] calling  teql_init+0x0/0xd3 @ 1
[   27.540087] device: 'teql0': device_add
[   27.546957] initcall teql_init+0x0/0xd3 returned 0 after 6752 usecs
[   27.553248] calling  prio_module_init+0x0/0x12 @ 1
[   27.558039] initcall prio_module_init+0x0/0x12 returned 0 after 2 usecs
[   27.564666] calling  multiq_module_init+0x0/0x12 @ 1
[   27.569634] initcall multiq_module_init+0x0/0x12 returned 0 after 2 usecs
[   27.576435] calling  atm_init+0x0/0x12 @ 1
[   27.580547] initcall atm_init+0x0/0x12 returned 0 after 2 usecs
[   27.586459] calling  init_u32+0x0/0x2e @ 1
[   27.590574] u32 classifier
[   27.593282]     Actions configured 
[   27.596809] initcall init_u32+0x0/0x2e returned 0 after 6092 usecs
[   27.603009] calling  init_fw+0x0/0x12 @ 1
[   27.607022] initcall init_fw+0x0/0x12 returned 0 after 2 usecs
[   27.612872] calling  init_tcindex+0x0/0x12 @ 1
[   27.617319] initcall init_tcindex+0x0/0x12 returned 0 after 2 usecs
[   27.623602] calling  init_rsvp+0x0/0x12 @ 1
[   27.627789] initcall init_rsvp+0x0/0x12 returned 0 after 2 usecs
[   27.633811] calling  init_basic+0x0/0x12 @ 1
[   27.638085] initcall init_basic+0x0/0x12 returned 0 after 2 usecs
[   27.644191] calling  init_cgroup_cls+0x0/0x3f @ 1
[   27.648892] initcall init_cgroup_cls+0x0/0x3f returned 0 after 3 usecs
[   27.655432] calling  init_em_cmp+0x0/0x12 @ 1
[   27.659801] initcall init_em_cmp+0x0/0x12 returned 0 after 18 usecs
[   27.666085] calling  init_em_nbyte+0x0/0x12 @ 1
[   27.670638] initcall init_em_nbyte+0x0/0x12 returned 0 after 2 usecs
[   27.676984] calling  init_em_u32+0x0/0x12 @ 1
[   27.681368] initcall init_em_u32+0x0/0x12 returned 0 after 2 usecs
[   27.687541] calling  init_em_meta+0x0/0x12 @ 1
[   27.692012] initcall init_em_meta+0x0/0x12 returned 0 after 2 usecs
[   27.698270] calling  init_em_text+0x0/0x12 @ 1
[   27.702740] initcall init_em_text+0x0/0x12 returned 0 after 2 usecs
[   27.708999] calling  nfnetlink_init+0x0/0x27 @ 1
[   27.713640] Netfilter messages via NETLINK v0.30.
[   27.718385] initcall nfnetlink_init+0x0/0x27 returned 0 after 4636 usecs
[   27.725107] calling  nfnetlink_queue_init+0x0/0xa3 @ 1
[   27.730339] initcall nfnetlink_queue_init+0x0/0xa3 returned 0 after 72 usecs
[   27.737374] calling  nfnetlink_log_init+0x0/0xd7 @ 1
[   27.742444] initcall nfnetlink_log_init+0x0/0xd7 returned 0 after 75 usecs
[   27.749307] calling  nf_conntrack_standalone_init+0x0/0x12 @ 1
[   27.755166] nf_conntrack version 0.5.0 (7201 buckets, 28804 max)
[   27.761470] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   27.768850] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
[   27.776788] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   27.783557] initcall nf_conntrack_standalone_init+0x0/0x12 returned 0 after 27725 usecs
[   27.791573] calling  nf_conntrack_proto_dccp_init+0x0/0x62 @ 1
[   27.798001] initcall nf_conntrack_proto_dccp_init+0x0/0x62 returned 0 after 583 usecs
[   27.805848] calling  nf_conntrack_proto_udplite_init+0x0/0x40 @ 1
[   27.812116] initcall nf_conntrack_proto_udplite_init+0x0/0x40 returned 0 after 153 usecs
[   27.820215] calling  ctnetlink_init+0x0/0x76 @ 1
[   27.824833] ctnetlink v0.93: registering with nfnetlink.
[   27.830169] initcall ctnetlink_init+0x0/0x76 returned 0 after 5207 usecs
[   27.836860] calling  nf_conntrack_amanda_init+0x0/0xa8 @ 1
[   27.842409] initcall nf_conntrack_amanda_init+0x0/0xa8 returned 0 after 38 usecs
[   27.849790] calling  nf_conntrack_ftp_init+0x0/0x1dd @ 1
[   27.855136] initcall nf_conntrack_ftp_init+0x0/0x1dd returned 0 after 7 usecs
[   27.862283] calling  nf_conntrack_h323_init+0x0/0x101 @ 1
[   27.867693] initcall nf_conntrack_h323_init+0x0/0x101 returned 0 after 10 usecs
[   27.875016] calling  nf_conntrack_irc_init+0x0/0x16c @ 1
[   27.880354] initcall nf_conntrack_irc_init+0x0/0x16c returned 0 after 6 usecs
[   27.887481] calling  nf_conntrack_sane_init+0x0/0x1e7 @ 1
[   27.892913] initcall nf_conntrack_sane_init+0x0/0x1e7 returned 0 after 7 usecs
[   27.900149] calling  nf_conntrack_sip_init+0x0/0x20e @ 1
[   27.905467] initcall nf_conntrack_sip_init+0x0/0x20e returned 0 after 7 usecs
[   27.912622] calling  nf_conntrack_tftp_init+0x0/0x17b @ 1
[   27.918024] initcall nf_conntrack_tftp_init+0x0/0x17b returned 0 after 5 usecs
[   27.925266] calling  xt_init+0x0/0x178 @ 1
[   27.929377] initcall xt_init+0x0/0x178 returned 0 after 13 usecs
[   27.935396] calling  tcpudp_mt_init+0x0/0x17 @ 1
[   27.940057] initcall tcpudp_mt_init+0x0/0x17 returned 0 after 28 usecs
[   27.946572] calling  classify_tg_init+0x0/0x12 @ 1
[   27.951394] initcall classify_tg_init+0x0/0x12 returned 0 after 3 usecs
[   27.957996] calling  connmark_tg_init+0x0/0x12 @ 1
[   27.962815] initcall connmark_tg_init+0x0/0x12 returned 0 after 3 usecs
[   27.969417] calling  connsecmark_tg_init+0x0/0x12 @ 1
[   27.974497] initcall connsecmark_tg_init+0x0/0x12 returned 0 after 3 usecs
[   27.981382] calling  mark_tg_init+0x0/0x12 @ 1
[   27.985830] initcall mark_tg_init+0x0/0x12 returned 0 after 3 usecs
[   27.992113] calling  nflog_tg_init+0x0/0x12 @ 1
[   27.996648] initcall nflog_tg_init+0x0/0x12 returned 0 after 3 usecs
[   28.003018] calling  nfqueue_tg_init+0x0/0x17 @ 1
[   28.007724] initcall nfqueue_tg_init+0x0/0x17 returned 0 after 4 usecs
[   28.014266] calling  xt_rateest_tg_init+0x0/0x2b @ 1
[   28.019232] initcall xt_rateest_tg_init+0x0/0x2b returned 0 after 3 usecs
[   28.026036] calling  secmark_tg_init+0x0/0x12 @ 1
[   28.030762] initcall secmark_tg_init+0x0/0x12 returned 0 after 3 usecs
[   28.037280] calling  tcpmss_tg_init+0x0/0x17 @ 1
[   28.041944] initcall tcpmss_tg_init+0x0/0x17 returned 0 after 3 usecs
[   28.048372] calling  connlimit_mt_init+0x0/0x12 @ 1
[   28.053280] initcall connlimit_mt_init+0x0/0x12 returned 0 after 3 usecs
[   28.059970] calling  conntrack_mt_init+0x0/0x17 @ 1
[   28.064877] initcall conntrack_mt_init+0x0/0x17 returned 0 after 4 usecs
[   28.071587] calling  dccp_mt_init+0x0/0x57 @ 1
[   28.076039] initcall dccp_mt_init+0x0/0x57 returned 0 after 6 usecs
[   28.082326] calling  dscp_mt_init+0x0/0x17 @ 1
[   28.086777] initcall dscp_mt_init+0x0/0x17 returned 0 after 7 usecs
[   28.093063] calling  esp_mt_init+0x0/0x17 @ 1
[   28.097425] initcall esp_mt_init+0x0/0x17 returned 0 after 4 usecs
[   28.103619] calling  helper_mt_init+0x0/0x12 @ 1
[   28.108240] initcall helper_mt_init+0x0/0x12 returned 0 after 3 usecs
[   28.114695] calling  hl_mt_init+0x0/0x17 @ 1
[   28.118971] initcall hl_mt_init+0x0/0x17 returned 0 after 4 usecs
[   28.125079] calling  limit_mt_init+0x0/0x12 @ 1
[   28.129613] initcall limit_mt_init+0x0/0x12 returned 0 after 3 usecs
[   28.135981] calling  mac_mt_init+0x0/0x12 @ 1
[   28.140362] initcall mac_mt_init+0x0/0x12 returned 0 after 3 usecs
[   28.146533] calling  mark_mt_init+0x0/0x12 @ 1
[   28.151004] initcall mark_mt_init+0x0/0x12 returned 0 after 3 usecs
[   28.157261] calling  xt_osf_init+0x0/0x8d @ 1
[   28.161650] initcall xt_osf_init+0x0/0x8d returned 0 after 4 usecs
[   28.167817] calling  owner_mt_init+0x0/0x12 @ 1
[   28.172378] initcall owner_mt_init+0x0/0x12 returned 0 after 3 usecs
[   28.178722] calling  physdev_mt_init+0x0/0x12 @ 1
[   28.183454] initcall physdev_mt_init+0x0/0x12 returned 0 after 3 usecs
[   28.189969] calling  pkttype_mt_init+0x0/0x12 @ 1
[   28.194703] initcall pkttype_mt_init+0x0/0x12 returned 0 after 3 usecs
[   28.201241] calling  quota_mt_init+0x0/0x12 @ 1
[   28.205777] initcall quota_mt_init+0x0/0x12 returned 0 after 3 usecs
[   28.212145] calling  xt_rateest_mt_init+0x0/0x12 @ 1
[   28.217112] initcall xt_rateest_mt_init+0x0/0x12 returned 0 after 3 usecs
[   28.223914] calling  realm_mt_init+0x0/0x12 @ 1
[   28.228449] initcall realm_mt_init+0x0/0x12 returned 0 after 3 usecs
[   28.234818] calling  recent_mt_init+0x0/0x7c @ 1
[   28.239506] initcall recent_mt_init+0x0/0x7c returned 0 after 68 usecs
[   28.246049] calling  sctp_mt_init+0x0/0x17 @ 1
[   28.250519] initcall sctp_mt_init+0x0/0x17 returned 0 after 4 usecs
[   28.256774] calling  string_mt_init+0x0/0x17 @ 1
[   28.261424] initcall string_mt_init+0x0/0x17 returned 0 after 4 usecs
[   28.267859] calling  time_mt_init+0x0/0x4d @ 1
[   28.272328] xt_time: kernel timezone is -0000
[   28.276687] initcall time_mt_init+0x0/0x4d returned 0 after 4259 usecs
[   28.283229] calling  u32_mt_init+0x0/0x12 @ 1
[   28.287590] initcall u32_mt_init+0x0/0x12 returned 0 after 3 usecs
[   28.293787] calling  sysctl_ipv4_init+0x0/0x4e @ 1
[   28.303879] initcall sysctl_ipv4_init+0x0/0x4e returned 0 after 5177 usecs
[   28.310774] calling  ipip_init+0x0/0x60 @ 1
[   28.314956] IPv4 over IPv4 tunneling driver
[   28.319172] device: 'tunl0': device_add
[   28.326645] initcall ipip_init+0x0/0x60 returned 0 after 11410 usecs
[   28.333031] calling  ipgre_init+0x0/0xa3 @ 1
[   28.337298] GRE over IPv4 tunneling driver
[   28.341442] device: 'gre0': device_add
[   28.348679] initcall ipgre_init+0x0/0xa3 returned 0 after 11114 usecs
[   28.355140] calling  init_syncookies+0x0/0x19 @ 1
[   28.359893] initcall init_syncookies+0x0/0x19 returned 0 after 49 usecs
[   28.366526] calling  ah4_init+0x0/0x66 @ 1
[   28.370650] initcall ah4_init+0x0/0x66 returned 0 after 5 usecs
[   28.376567] calling  ipcomp4_init+0x0/0x66 @ 1
[   28.381041] initcall ipcomp4_init+0x0/0x66 returned 0 after 4 usecs
[   28.387295] calling  ipip_init+0x0/0x66 @ 1
[   28.391510] initcall ipip_init+0x0/0x66 returned 0 after 4 usecs
[   28.397506] calling  xfrm4_beet_init+0x0/0x17 @ 1
[   28.402237] initcall xfrm4_beet_init+0x0/0x17 returned 0 after 3 usecs
[   28.408755] calling  tunnel4_init+0x0/0x30 @ 1
[   28.413227] initcall tunnel4_init+0x0/0x30 returned 0 after 3 usecs
[   28.419485] calling  ipv4_netfilter_init+0x0/0x12 @ 1
[   28.424588] initcall ipv4_netfilter_init+0x0/0x12 returned 0 after 26 usecs
[   28.431562] calling  nf_conntrack_l3proto_ipv4_init+0x0/0x14b @ 1
[   28.440885] initcall nf_conntrack_l3proto_ipv4_init+0x0/0x14b returned 0 after 3152 usecs
[   28.449054] calling  nf_defrag_init+0x0/0x17 @ 1
[   28.453704] initcall nf_defrag_init+0x0/0x17 returned 0 after 3 usecs
[   28.460163] calling  arp_tables_init+0x0/0x92 @ 1
[   28.464903] arp_tables: (C) 2002 David S. Miller
[   28.469517] initcall arp_tables_init+0x0/0x92 returned 0 after 4545 usecs
[   28.476326] calling  arpt_mangle_init+0x0/0x12 @ 1
[   28.481141] initcall arpt_mangle_init+0x0/0x12 returned 0 after 3 usecs
[   28.487744] calling  ip_queue_init+0x0/0x13c @ 1
[   28.492554] initcall ip_queue_init+0x0/0x13c returned 0 after 162 usecs
[   28.499157] calling  inet_diag_init+0x0/0x6d @ 1
[   28.503826] initcall inet_diag_init+0x0/0x6d returned 0 after 21 usecs
[   28.510369] calling  tcp_diag_init+0x0/0x12 @ 1
[   28.514919] initcall tcp_diag_init+0x0/0x12 returned 0 after 19 usecs
[   28.521380] calling  bictcp_register+0x0/0x12 @ 1
[   28.526081] TCP bic registered
[   28.529137] initcall bictcp_register+0x0/0x12 returned 0 after 2986 usecs
[   28.535945] calling  cubictcp_register+0x0/0x5c @ 1
[   28.540842] TCP cubic registered
[   28.544074] initcall cubictcp_register+0x0/0x5c returned 0 after 3157 usecs
[   28.551051] calling  hstcp_register+0x0/0x12 @ 1
[   28.555668] TCP highspeed registered
[   28.559244] initcall hstcp_register+0x0/0x12 returned 0 after 3494 usecs
[   28.565966] calling  htcp_register+0x0/0x12 @ 1
[   28.570516] TCP htcp registered
[   28.573662] initcall htcp_register+0x0/0x12 returned 0 after 3073 usecs
[   28.580292] calling  tcp_scalable_register+0x0/0x12 @ 1
[   28.585515] TCP scalable registered
[   28.589006] initcall tcp_scalable_register+0x0/0x12 returned 0 after 3411 usecs
[   28.596335] calling  tcp_lp_register+0x0/0x12 @ 1
[   28.601059] TCP lp registered
[   28.604031] initcall tcp_lp_register+0x0/0x12 returned 0 after 2904 usecs
[   28.610835] calling  xfrm_user_init+0x0/0x4a @ 1
[   28.615452] Initializing XFRM netlink socket
[   28.619769] initcall xfrm_user_init+0x0/0x4a returned 0 after 4217 usecs
[   28.626487] calling  packet_init+0x0/0x47 @ 1
[   28.630868] NET: Registered protocol family 17
[   28.635335] initcall packet_init+0x0/0x47 returned 0 after 4368 usecs
[   28.641793] calling  br_init+0x0/0xcf @ 1
[   28.646274] Bridge firewalling registered
[   28.650330] initcall br_init+0x0/0xcf returned 0 after 4417 usecs
[   28.656417] calling  dsa_init_module+0x0/0x14 @ 1
[   28.661151] initcall dsa_init_module+0x0/0x14 returned 0 after 3 usecs
[   28.667667] calling  edsa_init_module+0x0/0x14 @ 1
[   28.672485] initcall edsa_init_module+0x0/0x14 returned 0 after 2 usecs
[   28.679088] calling  trailer_init_module+0x0/0x14 @ 1
[   28.684169] initcall trailer_init_module+0x0/0x14 returned 0 after 2 usecs
[   28.691053] calling  mv88e6060_init+0x0/0x14 @ 1
[   28.695691] initcall mv88e6060_init+0x0/0x14 returned 0 after 19 usecs
[   28.702235] calling  mv88e6123_61_65_init+0x0/0x14 @ 1
[   28.707374] initcall mv88e6123_61_65_init+0x0/0x14 returned 0 after 3 usecs
[   28.714351] calling  mv88e6131_init+0x0/0x14 @ 1
[   28.718972] initcall mv88e6131_init+0x0/0x14 returned 0 after 3 usecs
[   28.725427] calling  dsa_init_module+0x0/0x12 @ 1
[   28.730158] bus: 'platform': add driver dsa
[   28.734424] initcall dsa_init_module+0x0/0x12 returned 0 after 4174 usecs
[   28.741226] calling  atalk_init+0x0/0x8d @ 1
[   28.745499] NET: Registered protocol family 5
[   28.800408] initcall atalk_init+0x0/0x8d returned 0 after 53619 usecs
[   28.806837] calling  lapb_init+0x0/0x8 @ 1
[   28.810963] initcall lapb_init+0x0/0x8 returned 0 after 1 usecs
[   28.816875] calling  nr_proto_init+0x0/0x24a @ 1
[   28.821541] device: 'nr0': device_add
[   28.828637] device: 'nr1': device_add
[   28.835823] device: 'nr2': device_add
[   28.843009] device: 'nr3': device_add
[   28.850313] NET: Registered protocol family 6
[   28.855701] initcall nr_proto_init+0x0/0x24a returned 0 after 33384 usecs
[   28.862510] calling  rose_proto_init+0x0/0x28c @ 1
[   28.867322] device: 'rose0': device_add
[   28.874933] device: 'rose1': device_add
[   28.882600] device: 'rose2': device_add
[   28.890325] device: 'rose3': device_add
[   28.898077] device: 'rose4': device_add
[   28.905921] device: 'rose5': device_add
[   28.913846] device: 'rose6': device_add
[   28.921835] device: 'rose7': device_add
[   28.929868] device: 'rose8': device_add
[   28.938006] device: 'rose9': device_add
[   28.946196] NET: Registered protocol family 11
[   28.951741] initcall rose_proto_init+0x0/0x28c returned 0 after 82456 usecs
[   28.958696] calling  ax25_init+0x0/0xad @ 1
[   28.962908] NET: Registered protocol family 3
[   28.967322] initcall ax25_init+0x0/0xad returned 0 after 4314 usecs
[   28.973606] calling  can_init+0x0/0xe5 @ 1
[   28.977695] can: controller area network core (rev 20090105 abi 8)
[   28.983988] NET: Registered protocol family 29
[   28.988431] initcall can_init+0x0/0xe5 returned 0 after 10482 usecs
[   28.994711] calling  raw_module_init+0x0/0x3d @ 1
[   28.999414] can: raw protocol (rev 20090105)
[   29.003728] initcall raw_module_init+0x0/0x3d returned 0 after 4207 usecs
[   29.010528] calling  irnet_init+0x0/0x1b @ 1
[   29.014878] device: 'irnet': device_add
[   29.018871] initcall irnet_init+0x0/0x1b returned 0 after 3977 usecs
[   29.025246] calling  ircomm_init+0x0/0x9a @ 1
[   29.029647] IrCOMM protocol (Dag Brattli)
[   29.033679] initcall ircomm_init+0x0/0x9a returned 0 after 3976 usecs
[   29.040133] calling  ircomm_tty_init+0x0/0x130 @ 1
[   29.044971] device: 'ircomm0': device_add
[   29.049051] device: 'ircomm1': device_add
[   29.053211] device: 'ircomm2': device_add
[   29.057275] device: 'ircomm3': device_add
[   29.061372] device: 'ircomm4': device_add
[   29.065439] device: 'ircomm5': device_add
[   29.069545] device: 'ircomm6': device_add
[   29.073679] device: 'ircomm7': device_add
[   29.077780] device: 'ircomm8': device_add
[   29.081909] device: 'ircomm9': device_add
[   29.086049] device: 'ircomm10': device_add
[   29.090265] device: 'ircomm11': device_add
[   29.094456] device: 'ircomm12': device_add
[   29.098683] device: 'ircomm13': device_add
[   29.102898] device: 'ircomm14': device_add
[   29.107091] device: 'ircomm15': device_add
[   29.111308] device: 'ircomm16': device_add
[   29.115535] device: 'ircomm17': device_add
[   29.119722] device: 'ircomm18': device_add
[   29.123944] device: 'ircomm19': device_add
[   29.128136] device: 'ircomm20': device_add
[   29.132387] device: 'ircomm21': device_add
[   29.136577] device: 'ircomm22': device_add
[   29.140793] device: 'ircomm23': device_add
[   29.145022] device: 'ircomm24': device_add
[   29.149209] device: 'ircomm25': device_add
[   29.153429] device: 'ircomm26': device_add
[   29.157686] device: 'ircomm27': device_add
[   29.161921] device: 'ircomm28': device_add
[   29.166085] device: 'ircomm29': device_add
[   29.170270] device: 'ircomm30': device_add
[   29.174452] device: 'ircomm31': device_add
[   29.178618] initcall ircomm_tty_init+0x0/0x130 returned 0 after 130561 usecs
[   29.185685] calling  atm_clip_init+0x0/0xba @ 1
[   29.190349] initcall atm_clip_init+0x0/0xba returned 0 after 110 usecs
[   29.196869] calling  br2684_init+0x0/0x40 @ 1
[   29.201260] initcall br2684_init+0x0/0x40 returned 0 after 10 usecs
[   29.207520] calling  lane_module_init+0x0/0x6a @ 1
[   29.212343] lec:lane_module_init: lec.c: May 21 2010 20:45:07 initialized
[   29.219127] initcall lane_module_init+0x0/0x6a returned 0 after 6638 usecs
[   29.226017] calling  atm_mpoa_init+0x0/0x47 @ 1
[   29.230568] mpoa:atm_mpoa_init: mpc.c: May 21 2010 20:45:06 initialized
[   29.237180] initcall atm_mpoa_init+0x0/0x47 returned 0 after 6469 usecs
[   29.243811] calling  decnet_init+0x0/0x90 @ 1
[   29.248160] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[   29.257737] DECnet: Routing cache hash table of 512 buckets, 36Kbytes
[   29.264332] NET: Registered protocol family 12
[   29.270083] initcall decnet_init+0x0/0x90 returned 0 after 21402 usecs
[   29.276604] calling  phonet_init+0x0/0x7d @ 1
[   29.281052] NET: Registered protocol family 35
[   29.285627] initcall phonet_init+0x0/0x7d returned 0 after 4537 usecs
[   29.292087] calling  pep_register+0x0/0x17 @ 1
[   29.296536] initcall pep_register+0x0/0x17 returned 0 after 4 usecs
[   29.302822] calling  dccp_init+0x0/0x369 @ 1
[   29.311898] CCID: Activated CCID 2 (TCP-like)
[   29.316262] initcall dccp_init+0x0/0x369 returned 0 after 8958 usecs
[   29.322649] calling  dccp_v4_init+0x0/0x86 @ 1
[   29.327204] initcall dccp_v4_init+0x0/0x86 returned 0 after 111 usecs
[   29.333673] calling  dccp_diag_init+0x0/0x12 @ 1
[   29.338290] initcall dccp_diag_init+0x0/0x12 returned 0 after 4 usecs
[   29.344744] calling  sctp_init+0x0/0x7e3 @ 1
[   29.354496] SCTP: Hash tables configured (established 14563 bind 14563)
[   29.363661] initcall sctp_init+0x0/0x7e3 returned 0 after 14304 usecs
[   29.370122] calling  rds_init+0x0/0xb6 @ 1
[   29.374961] NET: Registered protocol family 21
[   29.379406] initcall rds_init+0x0/0xb6 returned 0 after 5063 usecs
[   29.385599] calling  rds_rdma_init+0x0/0xff @ 1
[   29.390404] rds_rdma_listen_init(): cm ffff88003e1a7b88 listening on port 18634
[   29.398317] Registered RDS/iwarp transport
[   29.403034] Registered RDS/infiniband transport
[   29.407562] initcall rds_rdma_init+0x0/0xff returned 0 after 17005 usecs
[   29.414277] calling  rds_tcp_init+0x0/0x90 @ 1
[   29.418716] Registered RDS/tcp transport
[   29.422880] initcall rds_tcp_init+0x0/0x90 returned 0 after 4063 usecs
[   29.429398] calling  lib80211_init+0x0/0x20 @ 1
[   29.433951] lib80211: common routines for IEEE802.11 drivers
[   29.439612] lib80211_crypt: registered algorithm 'NULL'
[   29.444854] initcall lib80211_init+0x0/0x20 returned 0 after 10646 usecs
[   29.451577] calling  lib80211_crypto_wep_init+0x0/0x12 @ 1
[   29.457057] lib80211_crypt: registered algorithm 'WEP'
[   29.462215] initcall lib80211_crypto_wep_init+0x0/0x12 returned 0 after 5034 usecs
[   29.469774] calling  lib80211_crypto_ccmp_init+0x0/0x12 @ 1
[   29.475370] lib80211_crypt: registered algorithm 'CCMP'
[   29.480612] initcall lib80211_crypto_ccmp_init+0x0/0x12 returned 0 after 5120 usecs
[   29.488253] calling  lib80211_crypto_tkip_init+0x0/0x12 @ 1
[   29.493849] lib80211_crypt: registered algorithm 'TKIP'
[   29.499072] initcall lib80211_crypto_tkip_init+0x0/0x12 returned 0 after 5105 usecs
[   29.506742] calling  tipc_init+0x0/0xb6 @ 1
[   29.510955] TIPC: Activated (version 1.6.4 compiled May 21 2010 20:45:44)
[   29.518752] NET: Registered protocol family 30
[   29.523230] TIPC: Started in single node mode
[   29.527590] initcall tipc_init+0x0/0xb6 returned 0 after 16261 usecs
[   29.533956] calling  dcbnl_init+0x0/0x32 @ 1
[   29.538224] initcall dcbnl_init+0x0/0x32 returned 0 after 2 usecs
[   29.544329] calling  af_ieee802154_init+0x0/0x79 @ 1
[   29.549292] NET: Registered protocol family 36
[   29.553761] initcall af_ieee802154_init+0x0/0x79 returned 0 after 4364 usecs
[   29.560823] calling  wimax_subsys_init+0x0/0x310 @ 1
[   29.565827] initcall wimax_subsys_init+0x0/0x310 returned 0 after 44 usecs
[   29.572717] calling  mcheck_debugfs_init+0x0/0x3c @ 1
[   29.577809] initcall mcheck_debugfs_init+0x0/0x3c returned 0 after 41 usecs
[   29.584787] calling  severities_debugfs_init+0x0/0x3c @ 1
[   29.590213] initcall severities_debugfs_init+0x0/0x3c returned 0 after 16 usecs
[   29.597506] calling  cpufreq_p4_init+0x0/0x5c @ 1
[   29.602237] initcall cpufreq_p4_init+0x0/0x5c returned -19 after 2 usecs
[   29.608929] calling  hpet_insert_resource+0x0/0x23 @ 1
[   29.614093] initcall hpet_insert_resource+0x0/0x23 returned 1 after 1 usecs
[   29.621071] initcall hpet_insert_resource+0x0/0x23 returned with error code 1 
[   29.628282] calling  update_mp_table+0x0/0x5e2 @ 1
[   29.633099] initcall update_mp_table+0x0/0x5e2 returned 0 after 2 usecs
[   29.639707] calling  lapic_insert_resource+0x0/0x3f @ 1
[   29.644959] initcall lapic_insert_resource+0x0/0x3f returned 0 after 5 usecs
[   29.652020] calling  io_apic_bug_finalize+0x0/0x1b @ 1
[   29.657156] initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 1 usecs
[   29.664131] calling  check_early_ioremap_leak+0x0/0x4b @ 1
[   29.669610] initcall check_early_ioremap_leak+0x0/0x4b returned 0 after 1 usecs
[   29.676931] calling  sched_init_debug+0x0/0x24 @ 1
[   29.681753] initcall sched_init_debug+0x0/0x24 returned 0 after 16 usecs
[   29.688449] calling  init_oops_id+0x0/0x31 @ 1
[   29.692926] initcall init_oops_id+0x0/0x31 returned 0 after 9 usecs
[   29.699186] calling  disable_boot_consoles+0x0/0x44 @ 1
[   29.704436] initcall disable_boot_consoles+0x0/0x44 returned 0 after 1 usecs
[   29.711496] calling  pm_qos_power_init+0x0/0xca @ 1
[   29.716376] device: 'cpu_dma_latency': device_add
[   29.721311] device: 'network_latency': device_add
[   29.726114] device: 'network_throughput': device_add
[   29.731316] initcall pm_qos_power_init+0x0/0xca returned 0 after 14594 usecs
[   29.738351] calling  taskstats_init+0x0/0x95 @ 1
[   29.743045] registered taskstats version 1
[   29.747142] initcall taskstats_init+0x0/0x95 returned 0 after 4055 usecs
[   29.753867] calling  fail_page_alloc_debugfs+0x0/0xe1 @ 1
[   29.759433] initcall fail_page_alloc_debugfs+0x0/0xe1 returned 0 after 170 usecs
[   29.766843] calling  fail_io_timeout_debugfs+0x0/0x19 @ 1
[   29.772376] initcall fail_io_timeout_debugfs+0x0/0x19 returned 0 after 112 usecs
[   29.779760] calling  random32_reseed+0x0/0xd8 @ 1
[   29.784513] initcall random32_reseed+0x0/0xd8 returned 0 after 21 usecs
[   29.791133] calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
[   29.797397] initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 7 usecs
[   29.805502] calling  pci_sysfs_init+0x0/0x51 @ 1
[   29.810865] initcall pci_sysfs_init+0x0/0x51 returned 0 after 715 usecs
[   29.817469] calling  seqgen_init+0x0/0xf @ 1
[   29.821823] initcall seqgen_init+0x0/0xf returned 0 after 55 usecs
[   29.827994] calling  scsi_complete_async_scans+0x0/0xf8 @ 1
[   29.833599] initcall scsi_complete_async_scans+0x0/0xf8 returned 0 after 2 usecs
[   29.841003] calling  rtc_hctosys+0x0/0x18d @ 1
[   29.845510] rtc-test rtc-test.0: setting system clock to 2010-05-22 05:48:23 UTC (1274507303)
[   29.854054] initcall rtc_hctosys+0x0/0x18d returned 0 after 8406 usecs
[   29.860592] calling  memmap_init+0x0/0x3b @ 1
[   29.865133] initcall memmap_init+0x0/0x3b returned 0 after 179 usecs
[   29.871503] calling  dmatest_init+0x0/0x14a @ 1
[   29.876058] initcall dmatest_init+0x0/0x14a returned 0 after 22 usecs
[   29.882521] calling  pci_mmcfg_late_insert_resources+0x0/0x66 @ 1
[   29.888615] initcall pci_mmcfg_late_insert_resources+0x0/0x66 returned 0 after 4 usecs
[   29.896548] calling  tcp_congestion_default+0x0/0x12 @ 1
[   29.901874] initcall tcp_congestion_default+0x0/0x12 returned 0 after 3 usecs
[   29.909000] calling  ip_auto_config+0x0/0xd03 @ 1
[   29.913819] initcall ip_auto_config+0x0/0xd03 returned 0 after 90 usecs
[   29.920445] calling  initialize_hashrnd+0x0/0x19 @ 1
[   29.925418] initcall initialize_hashrnd+0x0/0x19 returned 0 after 9 usecs
[   29.932973] async_waiting @ 1
[   29.936071] async_continuing @ 1 after 128 usec
[   29.956058] EXT3-fs (sda6): recovery required on readonly filesystem
[   29.962537] EXT3-fs (sda6): write access will be enabled during recovery
[   29.996075] kjournald starting.  Commit interval 5 seconds
[   29.996139] EXT3-fs (sda6): recovery complete
[   30.006387] EXT3-fs (sda6): mounted filesystem with ordered data mode
[   30.014547] VFS: Mounted root (ext3 filesystem) readonly on device 8:6.
[   30.021244] async_waiting @ 1
[   30.024300] async_continuing @ 1 after 3 usec
[   30.028840] Freeing unused kernel memory: 2596k freed
[   30.070001] Not activating Mandatory Access Control now since /sbin/tomoyo-init doesn't exist.
[   30.755723] mount used greatest stack depth: 3464 bytes left
[   39.023349] eth1: link down
[   46.251443] EXT3-fs (sda6): using internal journal
[   46.347675] kjournald starting.  Commit interval 5 seconds
[   46.353258] EXT3-fs (sda5): using internal journal
[   46.358134] EXT3-fs (sda5): mounted filesystem with ordered data mode
[   47.561897] rc.sysinit used greatest stack depth: 3224 bytes left
[   48.941669] warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
[   52.811457] device: 'vcs2': device_add
[   52.811599] device: 'vcsa2': device_add
[   52.820232] device: 'vcs4': device_add
[   52.820349] device: 'vcsa4': device_add
[   52.828947] device: 'vcs3': device_add
[   52.829068] device: 'vcsa3': device_add
[   52.839126] device: 'vcs5': device_add
[   52.839242] device: 'vcsa5': device_add
[   52.850397] device: 'vcs6': device_add
[   52.850554] device: 'vcsa6': device_add
[   59.250427] 
[   59.250429] =================================
[   59.256299] [ INFO: inconsistent lock state ]
[   59.260014] 2.6.34-tip+ #6253
[   59.260014] ---------------------------------
[   59.260014] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
[   59.260014] swapper/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
[   59.260014]  (&rq->lock){?.-.-.}, at: [<ffffffff81038e23>] run_rebalance_domains+0xa1/0x131
[   59.260014] {IN-HARDIRQ-W} state was registered at:
[   59.260014]   [<ffffffff8106583a>] __lock_acquire+0x5e8/0x1384
[   59.260014]   [<ffffffff81066659>] lock_acquire+0x83/0x9d
[   59.260014]   [<ffffffff81bae24c>] _raw_spin_lock+0x3b/0x6e
[   59.260014]   [<ffffffff81037865>] scheduler_tick+0x3a/0x2b7
[   59.260014]   [<ffffffff810497c4>] update_process_times+0x4b/0x5b
[   59.260014]   [<ffffffff8105f467>] tick_periodic+0x63/0x6f
[   59.260014]   [<ffffffff8105f492>] tick_handle_periodic+0x1f/0x6d
[   59.260014]   [<ffffffff81005e2d>] timer_interrupt+0x19/0x20
[   59.260014]   [<ffffffff81084dc9>] handle_IRQ_event+0x20/0x9f
[   59.260014]   [<ffffffff81086c2e>] handle_level_irq+0x9a/0xf4
[   59.260014]   [<ffffffff81005729>] handle_irq+0x62/0x6d
[   59.260014]   [<ffffffff81004b08>] do_IRQ+0x5e/0xc4
[   59.260014]   [<ffffffff81baefd3>] ret_from_intr+0x0/0xf
[   59.260014]   [<ffffffff81085abb>] __setup_irq+0x21b/0x2c1
[   59.260014]   [<ffffffff81085d06>] setup_irq+0x1e/0x23
[   59.260014]   [<ffffffff8282735f>] setup_default_timer_irq+0x12/0x14
[   59.260014]   [<ffffffff82827378>] hpet_time_init+0x17/0x19
[   59.260014]   [<ffffffff82827346>] x86_late_time_init+0xa/0x11
[   59.260014]   [<ffffffff82824ce9>] start_kernel+0x338/0x3bf
[   59.260014]   [<ffffffff828242a3>] x86_64_start_reservations+0xb3/0xb7
[   59.260014]   [<ffffffff8282438b>] x86_64_start_kernel+0xe4/0xeb
[   59.260014] irq event stamp: 186338
[   59.260014] hardirqs last  enabled at (186338): [<ffffffff81baecf5>] _raw_spin_unlock_irq+0x2b/0x53
[   59.260014] hardirqs last disabled at (186337): [<ffffffff81bae317>] _raw_spin_lock_irq+0x14/0x74
[   59.260014] softirqs last  enabled at (186326): [<ffffffff810449fe>] __do_softirq+0x13a/0x150
[   59.260014] softirqs last disabled at (186331): [<ffffffff8100388c>] call_softirq+0x1c/0x28
[   59.260014] 
[   59.260014] other info that might help us debug this:
[   59.260014] no locks held by swapper/0.
[   59.260014] 
[   59.260014] stack backtrace:
[   59.260014] Pid: 0, comm: swapper Not tainted 2.6.34-tip+ #6253
[   59.260014] Call Trace:
[   59.260014]  <IRQ>  [<ffffffff8106318d>] print_usage_bug+0x187/0x198
[   59.260014]  [<ffffffff8100d920>] ? save_stack_trace+0x2a/0x47
[   59.260014]  [<ffffffff81063c67>] ? check_usage_backwards+0x0/0xa5
[   59.260014]  [<ffffffff810633cd>] mark_lock+0x22f/0x412
[   59.260014]  [<ffffffff810658b3>] __lock_acquire+0x661/0x1384
[   59.260014]  [<ffffffff81038631>] ? load_balance+0xda/0x64d
[   59.260014]  [<ffffffff8106275e>] ? put_lock_stats+0xe/0x27
[   59.260014]  [<ffffffff8106285d>] ? lock_release_holdtime+0xe6/0xeb
[   59.260014]  [<ffffffff81066659>] lock_acquire+0x83/0x9d
[   59.260014]  [<ffffffff81038e23>] ? run_rebalance_domains+0xa1/0x131
[   59.260014]  [<ffffffff81bae24c>] _raw_spin_lock+0x3b/0x6e
[   59.260014]  [<ffffffff81038e23>] ? run_rebalance_domains+0xa1/0x131
[   59.260014]  [<ffffffff81038e23>] run_rebalance_domains+0xa1/0x131
[   59.260014]  [<ffffffff81044979>] __do_softirq+0xb5/0x150
[   59.260014]  [<ffffffff8100388c>] call_softirq+0x1c/0x28
[   59.260014]  [<ffffffff81005690>] do_softirq+0x38/0x6f
[   59.260014]  [<ffffffff81044571>] irq_exit+0x45/0x90
[   59.260014]  [<ffffffff81017ec4>] smp_apic_timer_interrupt+0x87/0x95
[   59.260014]  [<ffffffff81003353>] apic_timer_interrupt+0x13/0x20
[   59.260014]  <EOI>  [<ffffffff81009f8c>] ? default_idle+0x29/0x43
[   59.260014]  [<ffffffff81009f8a>] ? default_idle+0x27/0x43
[   59.260014]  [<ffffffff81001c52>] cpu_idle+0x6c/0xbe
[   59.260014]  [<ffffffff81b411fb>] rest_init+0xff/0x106
[   59.260014]  [<ffffffff81b410fc>] ? rest_init+0x0/0x106
[   59.260014]  [<ffffffff82824d65>] start_kernel+0x3b4/0x3bf
[   59.260014]  [<ffffffff828242a3>] x86_64_start_reservations+0xb3/0xb7
[   59.260014]  [<ffffffff8282438b>] x86_64_start_kernel+0xe4/0xeb

