Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab1KCVL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:11:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51316 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab1KCVLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:11:53 -0400
Date: Thu, 3 Nov 2011 22:10:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        David Daney <ddaney.cavm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clocksource: Avoid selecting mult values that might
 overflow when adjusted
Message-ID: <20111103211000.GA17895@elte.hu>
References: <1320264087-3413-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <1320264087-3413-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* John Stultz <john.stultz@linaro.org> wrote:

> For some frequqencies, the clocks_calc_mult_shift() function will
> unfortunately select mult values very close to 0xffffffff.  This
> has the potential to overflow when NTP adjusts the clock, adding
> to the mult value.
> 
> This patch adds a clocksource.maxadj value, which provides
> an approximation of an 11% adjustment(NTP limits adjustments to
> 500ppm and the tick adjustment is limited to 10%), which could
> be made to the clocksource.mult value. This is then used to both
> check that the current mult value won't overflow/underflow, as
> well as warning us if the timekeeping_adjust() code pushes over
> that 11% boundary.
> 
> CC: Yong Zhang <yong.zhang0@gmail.com>
> CC: David Daney <ddaney.cavm@gmail.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> Reported-by: Chen Jie <chenj@lemote.com>
> Reported-by: zhangfx <zhangfx@lemote.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  include/linux/clocksource.h |    3 +-
>  kernel/time/clocksource.c   |   53 ++++++++++++++++++++++++++++++++++--------
>  kernel/time/timekeeping.c   |    3 ++
>  3 files changed, 48 insertions(+), 11 deletions(-)

This patch (included in tip:timers/urgent) causes the following boot 
warning x86:

[    0.000000] Fast TSC calibration using PIT
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at kernel/time/timekeeping.c:855 do_timer+0x47f/0x4c0()
[    0.000000] Hardware name: System Product Name
[    0.000000] Adjusting more then 11%
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 3.1.0-tip+ #161792
[    0.000000] Call Trace:
[    0.000000]  <IRQ>  [<ffffffff81042d0a>] warn_slowpath_common+0x7a/0xb0
[    0.000000]  [<ffffffff81042de1>] warn_slowpath_fmt+0x41/0x50
[    0.000000]  [<ffffffff8106e78f>] do_timer+0x47f/0x4c0
[    0.000000]  [<ffffffff81073953>] tick_periodic+0x63/0x80
[    0.000000]  [<ffffffff810739f1>] tick_handle_periodic+0x21/0x70
[    0.000000]  [<ffffffff810046d8>] timer_interrupt+0x18/0x20
[    0.000000]  [<ffffffff8109ff9e>] handle_irq_event_percpu+0x5e/0x220
[    0.000000]  [<ffffffff810a019b>] handle_irq_event+0x3b/0x60
[    0.000000]  [<ffffffff810a295c>] handle_level_irq+0x6c/0xd0
[    0.000000]  [<ffffffff81003f34>] handle_irq+0x44/0xa0

Full bootlog and config attached.

i've excluded it from tip:master for now.

Thanks,

	Ingo

--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="boot.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-tip+ (mingo@earth5) (gcc version 4.6.1 20111003 (Red Hat 4.6.1-10) (GCC) ) #161792 SMP Thu Nov 3 20:48:40 CET 2011
[    0.000000] Command line: root=/dev/sda6 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=1 panic=1 3
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
[    0.000000] DMI: System manufacturer System Product Name/A8N-E, BIOS ASUS A8N-E ACPI BIOS Revision 1008 08/22/2005
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [ffff8800000f5680] f5680
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-000000003fff0000
[    0.000000]  0000000000 - 003fe00000 page 2M
[    0.000000]  003fe00000 - 003fff0000 page 4k
[    0.000000] kernel direct mapping tables up to 3fff0000 @ 1ffff000-20000000
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
[    0.000000] NUMA: Node 0 [0,a0000) + [100000,3fff0000) -> [0,3fff0000)
[    0.000000] Initmem setup node 0 0000000000000000-000000003fff0000
[    0.000000]   NODE_DATA [000000003ffeb000 - 000000003ffeffff]
[    0.000000]  [ffffea0000000000-ffffea0000ffffff] PMD -> [ffff88003e600000-ffff88003f5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fff0
[    0.000000] On node 0 totalpages: 262015
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3914 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 4032 pages used for memmap
[    0.000000]   DMA32 zone: 254000 pages, LIFO batch:31
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
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88003fc00000 s76096 r8192 d22208 u1048576
[    0.000000] pcpu-alloc: s76096 r8192 d22208 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 257914
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda6 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=1 panic=1 3
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 38000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Memory: 1016800k/1048512k available (7206k kernel code, 452k absent, 31260k reserved, 5688k data, 644k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled, bootconsole disabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at kernel/time/timekeeping.c:855 do_timer+0x47f/0x4c0()
[    0.000000] Hardware name: System Product Name
[    0.000000] Adjusting more then 11%
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 3.1.0-tip+ #161792
[    0.000000] Call Trace:
[    0.000000]  <IRQ>  [<ffffffff81042d0a>] warn_slowpath_common+0x7a/0xb0
[    0.000000]  [<ffffffff81042de1>] warn_slowpath_fmt+0x41/0x50
[    0.000000]  [<ffffffff8106e78f>] do_timer+0x47f/0x4c0
[    0.000000]  [<ffffffff81073953>] tick_periodic+0x63/0x80
[    0.000000]  [<ffffffff810739f1>] tick_handle_periodic+0x21/0x70
[    0.000000]  [<ffffffff810046d8>] timer_interrupt+0x18/0x20
[    0.000000]  [<ffffffff8109ff9e>] handle_irq_event_percpu+0x5e/0x220
[    0.000000]  [<ffffffff810a019b>] handle_irq_event+0x3b/0x60
[    0.000000]  [<ffffffff810a295c>] handle_level_irq+0x6c/0xd0
[    0.000000]  [<ffffffff81003f34>] handle_irq+0x44/0xa0
[    0.000000]  [<ffffffff81003bb5>] do_IRQ+0x55/0xd0
[    0.000000]  [<ffffffff816fd86b>] common_interrupt+0x6b/0x6b
[    0.000000]  <EOI>  [<ffffffff810092b8>] ? native_calibrate_tsc+0x108/0x530
[    0.000000]  [<ffffffff810a1b71>] ? setup_irq+0x41/0x90
[    0.000000]  [<ffffffff81cb2768>] tsc_init+0x21/0xf8
[    0.000000]  [<ffffffff81caf628>] x86_late_time_init+0xf/0x11
[    0.000000]  [<ffffffff81cacab1>] start_kernel+0x2a4/0x339
[    0.000000]  [<ffffffff81cac322>] x86_64_start_reservations+0x132/0x136
[    0.000000]  [<ffffffff81cac416>] x86_64_start_kernel+0xf0/0xf7
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] Detected 2010.205 MHz processor.
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.005999] Calibrating delay loop (skipped), value calculated using timer frequency.. 4020.41 BogoMIPS (lpj=2010205)
[    0.007001] pid_max: default: 32768 minimum: 301
[    0.008026] Security Framework initialized
[    0.009005] SELinux:  Disabled at boot.
[    0.010130] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.012384] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.013344] Mount-cache hash table entries: 256
[    0.014164] Initializing cgroup subsys cpuacct
[    0.015005] Initializing cgroup subsys freezer
[    0.016026] tseg: 0000000000
[    0.017012] CPU: Physical Processor ID: 0
[    0.018000] CPU: Processor Core ID: 0
[    0.019001] mce: CPU supports 5 MCE banks
[    0.020041] ACPI: Core revision 20110623
[    0.025420] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.036600] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.039997] calling  trace_init_flags_sys_exit+0x0/0x12 @ 1
[    0.040000] initcall trace_init_flags_sys_exit+0x0/0x12 returned 0 after 0 usecs
[    0.040999] calling  trace_init_flags_sys_enter+0x0/0x12 @ 1
[    0.041999] initcall trace_init_flags_sys_enter+0x0/0x12 returned 0 after 0 usecs
[    0.042999] calling  init_hw_perf_events+0x0/0x3ed @ 1
[    0.043997] Performance Events: AMD PMU driver.
[    0.045998] ... version:                0
[    0.046997] ... bit width:              48
[    0.047997] ... generic registers:      4
[    0.048997] ... value mask:             0000ffffffffffff
[    0.049997] ... max period:             00007fffffffffff
[    0.050997] ... fixed-purpose events:   0
[    0.051996] ... event mask:             000000000000000f
[    0.053006] initcall init_hw_perf_events+0x0/0x3ed returned 0 after 8788 usecs
[    0.053999] calling  migration_init+0x0/0x6d @ 1
[    0.054999] initcall migration_init+0x0/0x6d returned 0 after 0 usecs
[    0.055997] calling  spawn_ksoftirqd+0x0/0x51 @ 1
[    0.057019] initcall spawn_ksoftirqd+0x0/0x51 returned 0 after 0 usecs
[    0.057998] calling  init_workqueues+0x0/0x295 @ 1
[    0.059060] initcall init_workqueues+0x0/0x295 returned 0 after 0 usecs
[    0.059997] calling  cpu_stop_init+0x0/0xa6 @ 1
[    0.061017] initcall cpu_stop_init+0x0/0xa6 returned 0 after 0 usecs
[    0.061997] calling  rcu_scheduler_really_started+0x0/0x12 @ 1
[    0.062997] initcall rcu_scheduler_really_started+0x0/0x12 returned 0 after 0 usecs
[    0.063996] calling  relay_init+0x0/0x14 @ 1
[    0.064997] initcall relay_init+0x0/0x14 returned 0 after 0 usecs
[    0.065996] calling  tracer_alloc_buffers+0x0/0x161 @ 1
[    0.067075] initcall tracer_alloc_buffers+0x0/0x161 returned 0 after 0 usecs
[    0.067996] calling  init_trace_printk+0x0/0x12 @ 1
[    0.068997] initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
[    0.069996] calling  mce_amd_init+0x0/0x181 @ 1
[    0.070995] MCE: In-kernel MCE decoding enabled.
[    0.071996] initcall mce_amd_init+0x0/0x181 returned 0 after 976 usecs
[    0.073104] Booting Node   0, Processors  #1 Ok.
[    0.074789] smpboot cpu 1: start_ip = 9a000
[    0.146060] Brought up 2 CPUs
[    0.146988] Total of 2 processors activated (8040.31 BogoMIPS).
[    0.149259] calling  ipc_ns_init+0x0/0x14 @ 1
[    0.152991] initcall ipc_ns_init+0x0/0x14 returned 0 after 0 usecs
[    0.159987] calling  init_mmap_min_addr+0x0/0x27 @ 1
[    0.164986] initcall init_mmap_min_addr+0x0/0x27 returned 0 after 0 usecs
[    0.170985] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.177986] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.185985] calling  net_ns_init+0x0/0x10f @ 1
[    0.191398] initcall net_ns_init+0x0/0x10f returned 0 after 0 usecs
[    0.191985] calling  e820_mark_nvs_memory+0x0/0x3d @ 1
[    0.192981] PM: Registering ACPI NVS region at 3fff0000 (12288 bytes)
[    0.193983] initcall e820_mark_nvs_memory+0x0/0x3d returned 0 after 976 usecs
[    0.194981] calling  cpufreq_tsc+0x0/0x30 @ 1
[    0.195981] initcall cpufreq_tsc+0x0/0x30 returned 0 after 0 usecs
[    0.196981] calling  pci_reboot_init+0x0/0x14 @ 1
[    0.197982] initcall pci_reboot_init+0x0/0x14 returned 0 after 0 usecs
[    0.198981] calling  init_lapic_sysfs+0x0/0x20 @ 1
[    0.199981] initcall init_lapic_sysfs+0x0/0x20 returned 0 after 0 usecs
[    0.200981] calling  init_smp_flush+0x0/0x32 @ 1
[    0.201981] initcall init_smp_flush+0x0/0x32 returned 0 after 0 usecs
[    0.202982] calling  alloc_frozen_cpus+0x0/0x10 @ 1
[    0.203980] initcall alloc_frozen_cpus+0x0/0x10 returned 0 after 0 usecs
[    0.204980] calling  sysctl_init+0x0/0x32 @ 1
[    0.206023] initcall sysctl_init+0x0/0x32 returned 0 after 0 usecs
[    0.206979] calling  ksysfs_init+0x0/0x91 @ 1
[    0.207990] initcall ksysfs_init+0x0/0x91 returned 0 after 0 usecs
[    0.208979] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.209980] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.210979] calling  pm_init+0x0/0x3e @ 1
[    0.211983] initcall pm_init+0x0/0x3e returned 0 after 0 usecs
[    0.212978] calling  pm_disk_init+0x0/0x19 @ 1
[    0.213980] initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
[    0.214979] calling  swsusp_header_init+0x0/0x30 @ 1
[    0.215979] initcall swsusp_header_init+0x0/0x30 returned 0 after 0 usecs
[    0.216978] calling  init_zero_pfn+0x0/0x1f @ 1
[    0.217978] initcall init_zero_pfn+0x0/0x1f returned 0 after 0 usecs
[    0.218978] calling  fsnotify_init+0x0/0x26 @ 1
[    0.219980] initcall fsnotify_init+0x0/0x26 returned 0 after 0 usecs
[    0.220977] calling  filelock_init+0x0/0x2a @ 1
[    0.221980] initcall filelock_init+0x0/0x2a returned 0 after 0 usecs
[    0.222977] calling  init_misc_binfmt+0x0/0x41 @ 1
[    0.223980] initcall init_misc_binfmt+0x0/0x41 returned 0 after 0 usecs
[    0.224977] calling  init_script_binfmt+0x0/0x14 @ 1
[    0.225977] initcall init_script_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.226976] calling  init_elf_binfmt+0x0/0x14 @ 1
[    0.227976] initcall init_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.228976] calling  init_compat_elf_binfmt+0x0/0x14 @ 1
[    0.229976] initcall init_compat_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.230976] calling  debugfs_init+0x0/0x57 @ 1
[    0.231978] initcall debugfs_init+0x0/0x57 returned 0 after 0 usecs
[    0.232976] calling  random32_init+0x0/0xd6 @ 1
[    0.233976] initcall random32_init+0x0/0xd6 returned 0 after 0 usecs
[    0.234976] calling  early_resume_init+0x0/0x1d0 @ 1
[    0.235992] RTC time:  8:32:26, date: 11/04/11
[    0.236975] initcall early_resume_init+0x0/0x1d0 returned 0 after 976 usecs
[    0.237975] calling  cpufreq_core_init+0x0/0xa9 @ 1
[    0.238977] initcall cpufreq_core_init+0x0/0xa9 returned 0 after 0 usecs
[    0.239974] calling  cpuidle_init+0x0/0x3d @ 1
[    0.240976] initcall cpuidle_init+0x0/0x3d returned 0 after 0 usecs
[    0.241974] calling  sock_init+0x0/0x80 @ 1
[    0.243008] initcall sock_init+0x0/0x80 returned 0 after 0 usecs
[    0.243974] calling  net_inuse_init+0x0/0x26 @ 1
[    0.244976] initcall net_inuse_init+0x0/0x26 returned 0 after 0 usecs
[    0.245974] calling  netpoll_init+0x0/0x30 @ 1
[    0.246974] initcall netpoll_init+0x0/0x30 returned 0 after 0 usecs
[    0.247973] calling  netlink_proto_init+0x0/0x1ae @ 1
[    0.248978] NET: Registered protocol family 16
[    0.249982] initcall netlink_proto_init+0x0/0x1ae returned 0 after 976 usecs
[    0.250974] calling  bdi_class_init+0x0/0x49 @ 1
[    0.252002] kworker/u:0 used greatest stack depth: 6504 bytes left
[    0.252015] initcall bdi_class_init+0x0/0x49 returned 0 after 0 usecs
[    0.252015] calling  kobject_uevent_init+0x0/0x21 @ 1
[    0.252015] initcall kobject_uevent_init+0x0/0x21 returned 0 after 0 usecs
[    0.252015] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.281703] initcall pcibus_class_init+0x0/0x19 returned 0 after 28316 usecs
[    0.287971] calling  pci_driver_init+0x0/0x12 @ 1
[    0.293486] initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
[    0.299975] calling  backlight_class_init+0x0/0x5d @ 1
[    0.305201] initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
[    0.311966] calling  video_output_class_init+0x0/0x19 @ 1
[    0.317595] initcall video_output_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.323968] calling  tty_class_init+0x0/0x34 @ 1
[    0.329468] initcall tty_class_init+0x0/0x34 returned 0 after 0 usecs
[    0.334963] calling  vtconsole_class_init+0x0/0xe1 @ 1
[    0.341083] initcall vtconsole_class_init+0x0/0xe1 returned 0 after 0 usecs
[    0.347962] calling  wakeup_sources_debugfs_init+0x0/0x2b @ 1
[    0.352970] initcall wakeup_sources_debugfs_init+0x0/0x2b returned 0 after 0 usecs
[    0.360957] calling  register_node_type+0x0/0x12 @ 1
[    0.366414] initcall register_node_type+0x0/0x12 returned 0 after 0 usecs
[    0.372961] calling  i2c_init+0x0/0x6f @ 1
[    0.377335] initcall i2c_init+0x0/0x6f returned 0 after 0 usecs
[    0.382957] calling  amd_postcore_init+0x0/0x154 @ 1
[    0.387957] node 0 link 0: io port [1000, fffff]
[    0.391952] TOM: 0000000040000000 aka 1024M
[    0.396951] node 0 link 0: mmio [e0000000, efffffff]
[    0.401950] node 0 link 0: mmio [feb00000, fec0ffff]
[    0.406949] node 0 link 0: mmio [a0000, bffff]
[    0.411138] node 0 link 0: mmio [40000000, fed3ffff]
[    0.416135] bus: [00, ff] on node 0 link 0
[    0.419947] bus: 00 index 0 [io  0x0000-0xffff]
[    0.424946] bus: 00 index 1 [mem 0x40000000-0xfcffffffff]
[    0.429945] bus: 00 index 2 [mem 0xfeb00000-0xfec0ffff]
[    0.434944] bus: 00 index 3 [mem 0x000a0000-0x000bffff]
[    0.439945] initcall amd_postcore_init+0x0/0x154 returned 0 after 50773 usecs
[    0.447943] calling  arch_kdebugfs_init+0x0/0x201 @ 1
[    0.452951] initcall arch_kdebugfs_init+0x0/0x201 returned 0 after 0 usecs
[    0.459947] calling  configure_trampolines+0x0/0x26 @ 1
[    0.464944] initcall configure_trampolines+0x0/0x26 returned 0 after 0 usecs
[    0.471939] calling  mtrr_if_init+0x0/0x64 @ 1
[    0.475941] initcall mtrr_if_init+0x0/0x64 returned 0 after 0 usecs
[    0.482938] calling  ffh_cstate_init+0x0/0x2a @ 1
[    0.486937] initcall ffh_cstate_init+0x0/0x2a returned -1 after 0 usecs
[    0.493938] initcall ffh_cstate_init+0x0/0x2a returned with error code -1 
[    0.500935] calling  acpi_pci_init+0x0/0x61 @ 1
[    0.504934] ACPI: bus type pci registered
[    0.508935] initcall acpi_pci_init+0x0/0x61 returned 0 after 3905 usecs
[    0.515933] calling  dmi_id_init+0x0/0x318 @ 1
[    0.520724] initcall dmi_id_init+0x0/0x318 returned 0 after 0 usecs
[    0.526934] calling  pci_arch_init+0x0/0x66 @ 1
[    0.530941] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.539929] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.568732] PCI: Using configuration type 1 for base access
[    0.573948] initcall pci_arch_init+0x0/0x66 returned 0 after 41985 usecs
[    0.580924] calling  topology_init+0x0/0x96 @ 1
[    0.585641] initcall topology_init+0x0/0x96 returned 0 after 0 usecs
[    0.591924] calling  mtrr_init_finialize+0x0/0x36 @ 1
[    0.596921] initcall mtrr_init_finialize+0x0/0x36 returned 0 after 0 usecs
[    0.603920] calling  init_vdso+0x0/0x125 @ 1
[    0.607921] initcall init_vdso+0x0/0x125 returned 0 after 0 usecs
[    0.613918] calling  sysenter_setup+0x0/0x2c2 @ 1
[    0.618922] initcall sysenter_setup+0x0/0x2c2 returned 0 after 0 usecs
[    0.624917] calling  param_sysfs_init+0x0/0x18e @ 1
[    0.630944] kworker/u:0 used greatest stack depth: 5568 bytes left
[    0.648947] initcall param_sysfs_init+0x0/0x18e returned 0 after 18551 usecs
[    0.655938] calling  pm_sysrq_init+0x0/0x20 @ 1
[    0.659951] initcall pm_sysrq_init+0x0/0x20 returned 0 after 0 usecs
[    0.666951] calling  default_bdi_init+0x0/0xa5 @ 1
[    0.672048] initcall default_bdi_init+0x0/0xa5 returned 0 after 0 usecs
[    0.672917] calling  init_bio+0x0/0xf6 @ 1
[    0.673919] bio: create slab <bio-0> at 0
[    0.674912] initcall init_bio+0x0/0xf6 returned 0 after 976 usecs
[    0.675910] calling  fsnotify_notification_init+0x0/0x8b @ 1
[    0.676910] initcall fsnotify_notification_init+0x0/0x8b returned 0 after 0 usecs
[    0.677909] calling  cryptomgr_init+0x0/0x12 @ 1
[    0.678908] initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
[    0.679908] calling  blk_settings_init+0x0/0x2a @ 1
[    0.680908] initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
[    0.681907] calling  blk_ioc_init+0x0/0x2a @ 1
[    0.682908] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    0.683910] calling  blk_softirq_init+0x0/0x6d @ 1
[    0.684910] initcall blk_softirq_init+0x0/0x6d returned 0 after 0 usecs
[    0.685907] calling  blk_iopoll_setup+0x0/0x6d @ 1
[    0.686908] initcall blk_iopoll_setup+0x0/0x6d returned 0 after 0 usecs
[    0.687906] calling  genhd_device_init+0x0/0x84 @ 1
[    0.688950] initcall genhd_device_init+0x0/0x84 returned 0 after 0 usecs
[    0.695920] calling  pci_slot_init+0x0/0x50 @ 1
[    0.699908] initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
[    0.706904] calling  fbmem_init+0x0/0x98 @ 1
[    0.711184] initcall fbmem_init+0x0/0x98 returned 0 after 0 usecs
[    0.716904] calling  acpi_init+0x0/0x29b @ 1
[    0.720918] ACPI: Added _OSI(Module Device)
[    0.724902] ACPI: Added _OSI(Processor Device)
[    0.729899] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.734898] ACPI: Added _OSI(Processor Aggregator Device)
[    0.741507] ACPI: EC: Look up EC in DSDT
[    0.750072] ACPI: Interpreter enabled
[    0.752898] ACPI: (supports S0 S1 S3 S4 S5)
[    0.757898] ACPI: Using IOAPIC for interrupt routing
[    0.772019] initcall acpi_init+0x0/0x29b returned 0 after 49797 usecs
[    0.777929] calling  dock_init+0x0/0xa5 @ 1
[    0.783037] ACPI: No dock devices found.
[    0.786899] initcall dock_init+0x0/0xa5 returned 0 after 3905 usecs
[    0.792891] calling  acpi_pci_root_init+0x0/0x28 @ 1
[    0.797891] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.806962] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.814165] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.820890] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.828885] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.836883] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
[    0.844882] pci_root PNP0A08:00: host bridge window [mem 0x40000000-0xfebfffff] (ignored)
[    0.852893] pci 0000:00:00.0: [10de:005e] type 0 class 0x000580
[    0.858944] pci 0000:00:01.0: [10de:0050] type 0 class 0x000601
[    0.864897] HPET not enabled in BIOS. You might try hpet=force boot option
[    0.871886] pci 0000:00:01.1: [10de:0052] type 0 class 0x000c05
[    0.877882] pci 0000:00:01.1: reg 10: [io  0xdc00-0xdc1f]
[    0.882886] pci 0000:00:01.1: reg 20: [io  0x4c00-0x4c3f]
[    0.888878] pci 0000:00:01.1: reg 24: [io  0x4c40-0x4c7f]
[    0.893883] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.899879] pci 0000:00:01.1: PME# disabled
[    0.903886] pci 0000:00:02.0: [10de:005a] type 0 class 0x000c03
[    0.909879] pci 0000:00:02.0: reg 10: [mem 0xda102000-0xda102fff]
[    0.915891] pci 0000:00:02.0: supports D1 D2
[    0.920870] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.926870] pci 0000:00:02.0: PME# disabled
[    0.930878] pci 0000:00:02.1: [10de:005b] type 0 class 0x000c03
[    0.936876] pci 0000:00:02.1: reg 10: [mem 0xfeb00000-0xfeb000ff]
[    0.942891] pci 0000:00:02.1: supports D1 D2
[    0.947866] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.953866] pci 0000:00:02.1: PME# disabled
[    0.958879] pci 0000:00:04.0: [10de:0059] type 0 class 0x000401
[    0.963870] pci 0000:00:04.0: reg 10: [io  0xd400-0xd4ff]
[    0.969866] pci 0000:00:04.0: reg 14: [io  0xd800-0xd8ff]
[    0.974864] pci 0000:00:04.0: reg 18: [mem 0xda101000-0xda101fff]
[    0.980877] pci 0000:00:04.0: supports D1 D2
[    0.985869] pci 0000:00:06.0: [10de:0053] type 0 class 0x000101
[    0.991874] pci 0000:00:06.0: reg 20: [io  0xf000-0xf00f]
[    0.996881] pci 0000:00:09.0: [10de:005c] type 1 class 0x000604
[    1.002875] pci 0000:00:0a.0: [10de:0057] type 0 class 0x000680
[    1.008863] pci 0000:00:0a.0: reg 10: [mem 0xda100000-0xda100fff]
[    1.014858] pci 0000:00:0a.0: reg 14: [io  0xd000-0xd007]
[    1.019873] pci 0000:00:0a.0: supports D1 D2
[    1.024854] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.030854] pci 0000:00:0a.0: PME# disabled
[    1.034863] pci 0000:00:0b.0: [10de:005d] type 1 class 0x000604
[    1.040872] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.047851] pci 0000:00:0b.0: PME# disabled
[    1.051863] pci 0000:00:0c.0: [10de:005d] type 1 class 0x000604
[    1.057869] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.064849] pci 0000:00:0c.0: PME# disabled
[    1.068860] pci 0000:00:0d.0: [10de:005d] type 1 class 0x000604
[    1.074866] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.080846] pci 0000:00:0d.0: PME# disabled
[    1.085856] pci 0000:00:0e.0: [10de:005d] type 1 class 0x000604
[    1.091847] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.097843] pci 0000:00:0e.0: PME# disabled
[    1.101859] pci 0000:00:18.0: [1022:1100] type 0 class 0x000600
[    1.107858] pci 0000:00:18.1: [1022:1101] type 0 class 0x000600
[    1.113856] pci 0000:00:18.2: [1022:1102] type 0 class 0x000600
[    1.119853] pci 0000:00:18.3: [1022:1103] type 0 class 0x000600
[    1.125855] PCI: peer root bus 00 res updated from pci conf
[    1.131859] pci 0000:05:07.0: [10ec:8139] type 0 class 0x000200
[    1.137846] pci 0000:05:07.0: reg 10: [io  0xc000-0xc0ff]
[    1.142841] pci 0000:05:07.0: reg 14: [mem 0xda000000-0xda0000ff]
[    1.148868] pci 0000:05:07.0: supports D1 D2
[    1.152835] pci 0000:05:07.0: PME# supported from D1 D2 D3hot
[    1.158835] pci 0000:05:07.0: PME# disabled
[    1.162854] pci 0000:00:09.0: PCI bridge to [bus 05-05] (subtractive decode)
[    1.169833] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    1.175832] pci 0000:00:09.0:   bridge window [mem 0xda000000-0xda0fffff]
[    1.182831] pci 0000:00:09.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    1.190829] pci 0000:00:09.0:   bridge window [mem 0x40000000-0xfcffffffff] (subtractive decode)
[    1.199828] pci 0000:00:09.0:   bridge window [mem 0xfeb00000-0xfec0ffff] (subtractive decode)
[    1.208826] pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.216843] pci 0000:00:0b.0: PCI bridge to [bus 04-04]
[    1.221845] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    1.227844] pci 0000:00:0d.0: PCI bridge to [bus 02-02]
[    1.232851] pci 0000:01:00.0: [1002:5b60] type 0 class 0x000300
[    1.238828] pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
[    1.244825] pci 0000:01:00.0: reg 14: [io  0xb000-0xb0ff]
[    1.250824] pci 0000:01:00.0: reg 18: [mem 0xd9000000-0xd900ffff]
[    1.256835] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.262830] pci 0000:01:00.0: supports D1 D2
[    1.267833] pci 0000:01:00.1: [1002:5b70] type 0 class 0x000380
[    1.273822] pci 0000:01:00.1: reg 10: [mem 0xd9010000-0xd901ffff]
[    1.279851] pci 0000:01:00.1: supports D1 D2
[    1.283823] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.293819] pci 0000:00:0e.0: PCI bridge to [bus 01-01]
[    1.298814] pci 0000:00:0e.0:   bridge window [io  0xb000-0xbfff]
[    1.304813] pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
[    1.311812] pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    1.319818] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.325967] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    1.331971]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.337808]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    1.346804] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.383858] initcall acpi_pci_root_init+0x0/0x28 returned 0 after 572178 usecs
[    1.390811] calling  acpi_pci_link_init+0x0/0x3e @ 1
[    1.395863] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    1.404850] ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    1.412132] ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    1.419415] ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    1.428025] ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    1.436024] ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    1.444832] ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    1.453022] ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    1.460684] ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 9 10 11 12 14 15)
[    1.467832] ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    1.476016] ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    1.484825] ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    1.493014] ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    1.501823] ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    1.510023] ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    1.518017] ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    1.527034] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[    1.533027] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
[    1.539026] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
[    1.544406] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    1.550801] ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
[    1.557033] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
[    1.564029] ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
[    1.571027] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[    1.577837] ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
[    1.584026] ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
[    1.591025] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
[    1.598024] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
[    1.605834] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[    1.613028] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
[    1.620026] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
[    1.627026] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    1.634923] initcall acpi_pci_link_init+0x0/0x3e returned 0 after 233362 usecs
[    1.641762] calling  pnp_init+0x0/0x12 @ 1
[    1.646289] initcall pnp_init+0x0/0x12 returned 0 after 0 usecs
[    1.651762] calling  misc_init+0x0/0xb6 @ 1
[    1.656440] initcall misc_init+0x0/0xb6 returned 0 after 0 usecs
[    1.661760] calling  vga_arb_device_init+0x0/0xf2 @ 1
[    1.667549] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.674758] vgaarb: loaded
[    1.677754] vgaarb: bridge control possible 0000:01:00.0
[    1.682755] initcall vga_arb_device_init+0x0/0xf2 returned 0 after 15622 usecs
[    1.690754] calling  cn_init+0x0/0x9e @ 1
[    1.694771] initcall cn_init+0x0/0x9e returned 0 after 0 usecs
[    1.700754] calling  init_scsi+0x0/0x89 @ 1
[    1.705024] SCSI subsystem initialized
[    1.708755] initcall init_scsi+0x0/0x89 returned 0 after 3905 usecs
[    1.714750] calling  ata_init+0x0/0x452 @ 1
[    1.719351] libata version 3.00 loaded.
[    1.719754] initcall ata_init+0x0/0x452 returned 0 after 976 usecs
[    1.720749] calling  phy_init+0x0/0x2e @ 1
[    1.722766] initcall phy_init+0x0/0x2e returned 0 after 976 usecs
[    1.723760] calling  init_pcmcia_cs+0x0/0x36 @ 1
[    1.724769] initcall init_pcmcia_cs+0x0/0x36 returned 0 after 0 usecs
[    1.725751] calling  usb_init+0x0/0x170 @ 1
[    1.726792] usbcore: registered new interface driver usbfs
[    1.728773] usbcore: registered new interface driver hub
[    1.729772] usbcore: registered new device driver usb
[    1.734748] initcall usb_init+0x0/0x170 returned 0 after 7811 usecs
[    1.740745] calling  serio_init+0x0/0x2e @ 1
[    1.745789] initcall serio_init+0x0/0x2e returned 0 after 0 usecs
[    1.751749] calling  input_init+0x0/0x10a @ 1
[    1.756292] initcall input_init+0x0/0x10a returned 0 after 0 usecs
[    1.761744] calling  rtc_init+0x0/0x6a @ 1
[    1.766614] initcall rtc_init+0x0/0x6a returned 0 after 0 usecs
[    1.771746] calling  power_supply_class_init+0x0/0x40 @ 1
[    1.777976] initcall power_supply_class_init+0x0/0x40 returned 0 after 0 usecs
[    1.784743] calling  hwmon_init+0x0/0xee @ 1
[    1.789516] initcall hwmon_init+0x0/0xee returned 0 after 0 usecs
[    1.794742] calling  md_init+0x0/0x140 @ 1
[    1.799756] initcall md_init+0x0/0x140 returned 0 after 0 usecs
[    1.800737] calling  leds_init+0x0/0x44 @ 1
[    1.801760] initcall leds_init+0x0/0x44 returned 0 after 0 usecs
[    1.802737] calling  init_soundcore+0x0/0x95 @ 1
[    1.803757] initcall init_soundcore+0x0/0x95 returned 0 after 0 usecs
[    1.804738] calling  alsa_sound_init+0x0/0x95 @ 1
[    1.805746] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    1.806735] initcall alsa_sound_init+0x0/0x95 returned 0 after 976 usecs
[    1.807736] calling  pci_subsys_init+0x0/0x4a @ 1
[    1.808735] PCI: Using ACPI for IRQ routing
[    1.815969] PCI: pci_cache_line_size set to 64 bytes
[    1.816751] pci 0000:00:02.1: address space collision: [mem 0xfeb00000-0xfeb000ff] conflicts with PCI Bus #00 [mem 0xfeb00000-0xfec0ffff]
[    1.817782] Expanded resource reserved due to conflict with PCI Bus #00
[    1.818736] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    1.819733] reserve RAM buffer: 000000003fff0000 - 000000003fffffff 
[    1.820735] initcall pci_subsys_init+0x0/0x4a returned 0 after 11716 usecs
[    1.821733] calling  proto_init+0x0/0x12 @ 1
[    1.822737] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    1.823733] calling  net_dev_init+0x0/0x235 @ 1
[    1.824814] initcall net_dev_init+0x0/0x235 returned 0 after 0 usecs
[    1.825735] calling  neigh_init+0x0/0x80 @ 1
[    1.826733] initcall neigh_init+0x0/0x80 returned 0 after 0 usecs
[    1.827732] calling  fib_rules_init+0x0/0xac @ 1
[    1.828734] initcall fib_rules_init+0x0/0xac returned 0 after 0 usecs
[    1.829741] calling  pktsched_init+0x0/0xfc @ 1
[    1.830734] initcall pktsched_init+0x0/0xfc returned 0 after 0 usecs
[    1.831731] calling  tc_filter_init+0x0/0x55 @ 1
[    1.832731] initcall tc_filter_init+0x0/0x55 returned 0 after 0 usecs
[    1.833731] calling  tc_action_init+0x0/0x55 @ 1
[    1.834730] initcall tc_action_init+0x0/0x55 returned 0 after 0 usecs
[    1.835730] calling  genl_init+0x0/0x91 @ 1
[    1.836745] initcall genl_init+0x0/0x91 returned 0 after 0 usecs
[    1.837732] calling  cipso_v4_init+0x0/0x5d @ 1
[    1.838738] initcall cipso_v4_init+0x0/0x5d returned 0 after 0 usecs
[    1.839732] calling  cfg80211_init+0x0/0xc3 @ 1
[    1.840795] cfg80211: Calling CRDA to update world regulatory domain
[    1.840795] initcall cfg80211_init+0x0/0xc3 returned 0 after 0 usecs
[    1.840795] calling  wireless_nlevent_init+0x0/0x12 @ 1
[    1.840795] initcall wireless_nlevent_init+0x0/0x12 returned 0 after 0 usecs
[    1.840795] calling  ieee80211_init+0x0/0x3b @ 1
[    1.840868] initcall ieee80211_init+0x0/0x3b returned 0 after 0 usecs
[    1.840871] calling  netlbl_init+0x0/0x81 @ 1
[    1.840872] NetLabel: Initializing
[    1.840874] NetLabel:  domain hash size = 128
[    1.840875] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.840893] NetLabel:  unlabeled traffic allowed by default
[    1.840896] initcall netlbl_init+0x0/0x81 returned 0 after 0 usecs
[    1.840899] calling  rfkill_init+0x0/0x95 @ 1
[    1.840986] initcall rfkill_init+0x0/0x95 returned 0 after 0 usecs
[    1.840989] calling  sysctl_init+0x0/0x48 @ 1
[    1.840993] initcall sysctl_init+0x0/0x48 returned 0 after 0 usecs
[    1.840997] calling  hpet_late_init+0x0/0xfb @ 1
[    1.841001] initcall hpet_late_init+0x0/0xfb returned -19 after 0 usecs
[    1.841004] calling  init_amd_nbs+0x0/0xb6 @ 1
[    1.841048] initcall init_amd_nbs+0x0/0xb6 returned 0 after 0 usecs
[    1.841052] calling  clocksource_done_booting+0x0/0x5a @ 1
[    1.841056] initcall clocksource_done_booting+0x0/0x5a returned 0 after 0 usecs
[    1.841060] calling  rb_init_debugfs+0x0/0x2f @ 1
[    1.841071] initcall rb_init_debugfs+0x0/0x2f returned 0 after 0 usecs
[    1.841074] calling  tracer_init_debugfs+0x0/0x385 @ 1
[    1.841160] initcall tracer_init_debugfs+0x0/0x385 returned 0 after 0 usecs
[    1.841163] calling  init_trace_printk_function_export+0x0/0x2f @ 1
[    1.841168] initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 0 usecs
[    1.841172] calling  event_trace_init+0x0/0x2b6 @ 1
[    1.841172] initcall event_trace_init+0x0/0x2b6 returned 0 after 0 usecs
[    1.841172] calling  init_kprobe_trace+0x0/0x94 @ 1
[    1.841172] initcall init_kprobe_trace+0x0/0x94 returned 0 after 0 usecs
[    1.841172] calling  init_pipe_fs+0x0/0x4a @ 1
[    1.841172] initcall init_pipe_fs+0x0/0x4a returned 0 after 0 usecs
[    1.841172] calling  eventpoll_init+0x0/0xd7 @ 1
[    1.841172] initcall eventpoll_init+0x0/0xd7 returned 0 after 0 usecs
[    1.841172] calling  anon_inode_init+0x0/0x115 @ 1
[    1.841172] initcall anon_inode_init+0x0/0x115 returned 0 after 0 usecs
[    1.841172] calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
[    1.841172] initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 0 usecs
[    1.841172] calling  acpi_event_init+0x0/0x7d @ 1
[    1.841172] initcall acpi_event_init+0x0/0x7d returned 0 after 0 usecs
[    1.841172] calling  pnp_system_init+0x0/0x12 @ 1
[    1.841172] initcall pnp_system_init+0x0/0x12 returned 0 after 0 usecs
[    1.841172] calling  pnpacpi_init+0x0/0x8c @ 1
[    1.841172] pnp: PnP ACPI init
[    1.841172] ACPI: bus type pnp registered
[    1.841194] pnp 00:00: [bus 00-ff]
[    1.841197] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.841199] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.841202] pnp 00:00: [io  0x0d00-0xffff window]
[    1.841204] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.841207] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    1.841209] pnp 00:00: [mem 0x40000000-0xfebfffff window]
[    1.841322] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.841346] pnp 00:01: [io  0x4000-0x407f]
[    1.841349] pnp 00:01: [io  0x4080-0x40ff]
[    1.841351] pnp 00:01: [io  0x4400-0x447f]
[    1.841353] pnp 00:01: [io  0x4480-0x44ff]
[    1.841355] pnp 00:01: [io  0x4800-0x487f]
[    1.841357] pnp 00:01: [io  0x4880-0x48ff]
[    1.841450] system 00:01: [io  0x4000-0x407f] has been reserved
[    1.841453] system 00:01: [io  0x4080-0x40ff] has been reserved
[    1.841456] system 00:01: [io  0x4400-0x447f] has been reserved
[    1.841459] system 00:01: [io  0x4480-0x44ff] has been reserved
[    1.841462] system 00:01: [io  0x4800-0x487f] has been reserved
[    1.841464] system 00:01: [io  0x4880-0x48ff] has been reserved
[    1.841468] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.841468] pnp 00:02: [io  0x0010-0x001f]
[    1.841468] pnp 00:02: [io  0x0022-0x003f]
[    1.841468] pnp 00:02: [io  0x0044-0x005f]
[    1.841468] pnp 00:02: [io  0x0062-0x0063]
[    1.841468] pnp 00:02: [io  0x0065-0x006f]
[    1.841468] pnp 00:02: [io  0x0074-0x007f]
[    1.841468] pnp 00:02: [io  0x0091-0x0093]
[    1.841468] pnp 00:02: [io  0x00a2-0x00bf]
[    1.841468] pnp 00:02: [io  0x00e0-0x00ef]
[    1.841468] pnp 00:02: [io  0x04d0-0x04d1]
[    1.841468] pnp 00:02: [io  0x0800-0x0805]
[    1.841468] pnp 00:02: [io  0x0290-0x0297]
[    1.841468] system 00:02: [io  0x04d0-0x04d1] has been reserved
[    1.841468] system 00:02: [io  0x0800-0x0805] has been reserved
[    1.841468] system 00:02: [io  0x0290-0x0297] has been reserved
[    1.841468] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.841468] pnp 00:03: [dma 4]
[    1.841468] pnp 00:03: [io  0x0000-0x000f]
[    1.841468] pnp 00:03: [io  0x0080-0x0090]
[    1.841468] pnp 00:03: [io  0x0094-0x009f]
[    1.841468] pnp 00:03: [io  0x00c0-0x00df]
[    1.841468] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.841468] pnp 00:04: [io  0x0070-0x0073]
[    1.841468] pnp 00:04: [irq 8]
[    1.841468] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.841468] pnp 00:05: [io  0x0061]
[    1.841468] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.841468] pnp 00:06: [io  0x00f0-0x00ff]
[    1.841470] pnp 00:06: [irq 13]
[    1.841541] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.841541] pnp 00:07: [io  0x03f0-0x03f5]
[    1.841541] pnp 00:07: [io  0x03f7]
[    1.841541] pnp 00:07: [irq 6]
[    1.841541] pnp 00:07: [dma 2]
[    1.841541] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.841541] pnp 00:08: [io  0x03f8-0x03ff]
[    1.841541] pnp 00:08: [irq 4]
[    1.841541] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.841694] pnp 00:09: [io  0x0378-0x037f]
[    1.841696] pnp 00:09: [io  0x0778-0x077b]
[    1.841703] pnp 00:09: [irq 7]
[    1.841705] pnp 00:09: [dma 3]
[    1.841705] pnp 00:09: Plug and Play ACPI device, IDs PNP0401 (active)
[    1.841705] pnp 00:0a: [irq 12]
[    1.841705] pnp 00:0a: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.841705] pnp 00:0b: [io  0x0060]
[    1.841705] pnp 00:0b: [io  0x0064]
[    1.841705] pnp 00:0b: [irq 1]
[    1.841705] pnp 00:0b: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    1.841705] pnp 00:0c: [io  0x0330-0x0331]
[    1.841705] pnp 00:0c: [irq 10]
[    1.841705] pnp 00:0c: Plug and Play ACPI device, IDs PNPb006 (active)
[    1.841705] pnp 00:0d: [io  0x0201]
[    1.841705] pnp 00:0d: Plug and Play ACPI device, IDs PNPb02f (active)
[    1.841705] pnp 00:0e: [mem 0xe0000000-0xefffffff]
[    1.841705] system 00:0e: [mem 0xe0000000-0xefffffff] has been reserved
[    1.841705] system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.841705] pnp 00:0f: [mem 0x000f0000-0x000f3fff]
[    1.841705] pnp 00:0f: [mem 0x000f4000-0x000f7fff]
[    1.841705] pnp 00:0f: [mem 0x000f8000-0x000fbfff]
[    1.841705] pnp 00:0f: [mem 0x000fc000-0x000fffff]
[    1.841705] pnp 00:0f: [mem 0x3fff0000-0x3fffffff]
[    1.841705] pnp 00:0f: [mem 0xffff0000-0xffffffff]
[    1.841705] pnp 00:0f: [mem 0x00000000-0x0009ffff]
[    1.841705] pnp 00:0f: [mem 0x00100000-0x3ffeffff]
[    1.841705] pnp 00:0f: [mem 0xfec00000-0xfec00fff]
[    1.841705] pnp 00:0f: [mem 0xfee00000-0xfeefffff]
[    1.841705] pnp 00:0f: [mem 0xfefff000-0xfeffffff]
[    1.841705] pnp 00:0f: [mem 0xfff80000-0xfff80fff]
[    1.841705] pnp 00:0f: [mem 0xfff90000-0xfffbffff]
[    1.841705] pnp 00:0f: [mem 0xfffed000-0xfffeffff]
[    1.841705] system 00:0f: [mem 0x000f0000-0x000f3fff] could not be reserved
[    1.841705] system 00:0f: [mem 0x000f4000-0x000f7fff] could not be reserved
[    1.841705] system 00:0f: [mem 0x000f8000-0x000fbfff] could not be reserved
[    1.841705] system 00:0f: [mem 0x000fc000-0x000fffff] could not be reserved
[    1.841705] system 00:0f: [mem 0x3fff0000-0x3fffffff] could not be reserved
[    1.841705] system 00:0f: [mem 0xffff0000-0xffffffff] has been reserved
[    1.841705] system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.841705] system 00:0f: [mem 0x00100000-0x3ffeffff] could not be reserved
[    1.841705] system 00:0f: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.841705] system 00:0f: [mem 0xfee00000-0xfeefffff] has been reserved
[    1.841705] system 00:0f: [mem 0xfefff000-0xfeffffff] has been reserved
[    1.841705] system 00:0f: [mem 0xfff80000-0xfff80fff] has been reserved
[    1.841705] system 00:0f: [mem 0xfff90000-0xfffbffff] has been reserved
[    1.841705] system 00:0f: [mem 0xfffed000-0xfffeffff] has been reserved
[    1.841705] system 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.841705] pnp: PnP ACPI: found 16 devices
[    1.841705] ACPI: ACPI bus type pnp unregistered
[    1.841705] initcall pnpacpi_init+0x0/0x8c returned 0 after 0 usecs
[    1.841705] calling  chr_dev_init+0x0/0xc1 @ 1
[    1.841721] initcall chr_dev_init+0x0/0xc1 returned 0 after 0 usecs
[    1.841721] calling  firmware_class_init+0x0/0x19 @ 1
[    1.841721] initcall firmware_class_init+0x0/0x19 returned 0 after 0 usecs
[    1.841721] calling  init_pcmcia_bus+0x0/0x62 @ 1
[    1.841721] initcall init_pcmcia_bus+0x0/0x62 returned 0 after 0 usecs
[    1.841721] calling  thermal_init+0x0/0x74 @ 1
[    1.841721] initcall thermal_init+0x0/0x74 returned 0 after 0 usecs
[    1.841721] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    1.841721] initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 usecs
[    1.841721] calling  cpufreq_gov_userspace_init+0x0/0x12 @ 1
[    1.841721] initcall cpufreq_gov_userspace_init+0x0/0x12 returned 0 after 0 usecs
[    1.841721] calling  init_acpi_pm_clocksource+0x0/0xd9 @ 1
[    1.841721] Switching to clocksource acpi_pm
[    1.841721] initcall init_acpi_pm_clocksource+0x0/0xd9 returned 0 after 980 usecs
[    1.849231] calling  pcibios_assign_resources+0x0/0x76 @ 1
[    1.854770] PCI: max bus depth: 1 pci_try_num: 2
[    1.859427] pci 0000:00:02.1: BAR 0: assigned [mem 0x40000000-0x400000ff]
[    1.866216] pci 0000:00:02.1: BAR 0: set to [mem 0x40000000-0x400000ff] (PCI address [0x40000000-0x400000ff])
[    1.876128] pci 0000:00:09.0: PCI bridge to [bus 05-05]
[    1.881355] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    1.887446] pci 0000:00:09.0:   bridge window [mem 0xda000000-0xda0fffff]
[    1.894233] pci 0000:00:0b.0: PCI bridge to [bus 04-04]
[    1.899460] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    1.904685] pci 0000:00:0d.0: PCI bridge to [bus 02-02]
[    1.909917] pci 0000:01:00.0: BAR 6: assigned [mem 0xd8000000-0xd801ffff pref]
[    1.917193] pci 0000:00:0e.0: PCI bridge to [bus 01-01]
[    1.922468] pci 0000:00:0e.0:   bridge window [io  0xb000-0xbfff]
[    1.928603] pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
[    1.935433] pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    1.943222] pci 0000:00:09.0: setting latency timer to 64
[    1.948669] pci 0000:00:0b.0: setting latency timer to 64
[    1.954109] pci 0000:00:0c.0: setting latency timer to 64
[    1.959519] pci 0000:00:0d.0: setting latency timer to 64
[    1.964920] pci 0000:00:0e.0: setting latency timer to 64
[    1.970330] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    1.975906] pci_bus 0000:00: resource 5 [mem 0x40000000-0xfcffffffff]
[    1.982344] pci_bus 0000:00: resource 6 [mem 0xfeb00000-0xfec0ffff]
[    1.988611] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
[    1.994878] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    2.000449] pci_bus 0000:05: resource 1 [mem 0xda000000-0xda0fffff]
[    2.006716] pci_bus 0000:05: resource 4 [io  0x0000-0xffff]
[    2.012289] pci_bus 0000:05: resource 5 [mem 0x40000000-0xfcffffffff]
[    2.018728] pci_bus 0000:05: resource 6 [mem 0xfeb00000-0xfec0ffff]
[    2.024994] pci_bus 0000:05: resource 7 [mem 0x000a0000-0x000bffff]
[    2.031261] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
[    2.036831] pci_bus 0000:01: resource 1 [mem 0xd8000000-0xd9ffffff]
[    2.043099] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
[    2.050322] initcall pcibios_assign_resources+0x0/0x76 returned 0 after 191019 usecs
[    2.058066] calling  sysctl_core_init+0x0/0x38 @ 1
[    2.062887] initcall sysctl_core_init+0x0/0x38 returned 0 after 24 usecs
[    2.069601] calling  inet_init+0x0/0x27d @ 1
[    2.073908] NET: Registered protocol family 2
[    2.078353] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    2.086058] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    2.094805] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.102154] TCP: Hash tables configured (established 131072 bind 65536)
[    2.108768] TCP reno registered
[    2.111923] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    2.117864] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    2.124341] initcall inet_init+0x0/0x27d returned 0 after 49277 usecs
[    2.130786] calling  af_unix_init+0x0/0x52 @ 1
[    2.135237] NET: Registered protocol family 1
[    2.139609] initcall af_unix_init+0x0/0x52 returned 0 after 4268 usecs
[    2.146138] calling  init_sunrpc+0x0/0x70 @ 1
[    2.150646] RPC: Registered named UNIX socket transport module.
[    2.156576] RPC: Registered udp transport module.
[    2.161287] RPC: Registered tcp transport module.
[    2.165992] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.172437] initcall init_sunrpc+0x0/0x70 returned 0 after 21421 usecs
[    2.178968] calling  pci_apply_final_quirks+0x0/0x101 @ 1
[    2.248077] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.253574] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    2.259156] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.264646] pci 0000:00:0b.0: Linking AER extended capability
[    2.270424] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.275914] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    2.281499] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.286987] pci 0000:00:0c.0: Linking AER extended capability
[    2.292771] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.298267] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    2.303849] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.309340] pci 0000:00:0d.0: Linking AER extended capability
[    2.315125] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.320616] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    2.326201] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.331690] pci 0000:00:0e.0: Linking AER extended capability
[    2.337452] pci 0000:01:00.0: Boot video device
[    2.341988] PCI: CLS 32 bytes, default 64
[    2.346013] initcall pci_apply_final_quirks+0x0/0x101 returned 0 after 157845 usecs
[    2.353671] calling  populate_rootfs+0x0/0xd1 @ 1
[    2.358447] initcall populate_rootfs+0x0/0xd1 returned 0 after 59 usecs
[    2.365070] calling  pci_iommu_init+0x0/0x3e @ 1
[    2.370994] initcall pci_iommu_init+0x0/0x3e returned 0 after 1266 usecs
[    2.377700] calling  calgary_fixup_tce_spaces+0x0/0xf8 @ 1
[    2.383191] initcall calgary_fixup_tce_spaces+0x0/0xf8 returned -19 after 1 usecs
[    2.390678] calling  i8259A_init_ops+0x0/0x21 @ 1
[    2.395395] initcall i8259A_init_ops+0x0/0x21 returned 0 after 10 usecs
[    2.402022] calling  vsyscall_init+0x0/0x27 @ 1
[    2.406562] initcall vsyscall_init+0x0/0x27 returned 0 after 8 usecs
[    2.412915] calling  sbf_init+0x0/0xf2 @ 1
[    2.417025] initcall sbf_init+0x0/0xf2 returned 0 after 1 usecs
[    2.422949] calling  init_tsc_clocksource+0x0/0x5f @ 1
[    2.428094] initcall init_tsc_clocksource+0x0/0x5f returned 0 after 3 usecs
[    2.435056] calling  add_rtc_cmos+0x0/0x96 @ 1
[    2.439510] initcall add_rtc_cmos+0x0/0x96 returned 0 after 4 usecs
[    2.445779] calling  i8237A_init_ops+0x0/0x14 @ 1
[    2.450491] initcall i8237A_init_ops+0x0/0x14 returned 0 after 6 usecs
[    2.457032] calling  cache_sysfs_init+0x0/0x6b @ 1
[    2.462312] initcall cache_sysfs_init+0x0/0x6b returned 0 after 470 usecs
[    2.469109] calling  mcheck_init_device+0x0/0xfe @ 1
[    2.474330] initcall mcheck_init_device+0x0/0xfe returned 0 after 246 usecs
[    2.481311] calling  threshold_init_device+0x0/0x56 @ 1
[    2.486546] initcall threshold_init_device+0x0/0x56 returned 0 after 2 usecs
[    2.493593] calling  thermal_throttle_init_device+0x0/0x9c @ 1
[    2.499430] initcall thermal_throttle_init_device+0x0/0x9c returned 0 after 1 usecs
[    2.507088] calling  amd_ibs_init+0x0/0x287 @ 1
[    2.511624] initcall amd_ibs_init+0x0/0x287 returned -19 after 1 usecs
[    2.518154] calling  msr_init+0x0/0x127 @ 1
[    2.522532] initcall msr_init+0x0/0x127 returned 0 after 185 usecs
[    2.528725] calling  cpuid_init+0x0/0x127 @ 1
[    2.533277] initcall cpuid_init+0x0/0x127 returned 0 after 181 usecs
[    2.539643] calling  ioapic_init_ops+0x0/0x14 @ 1
[    2.544360] initcall ioapic_init_ops+0x0/0x14 returned 0 after 2 usecs
[    2.550897] calling  add_pcspkr+0x0/0x38 @ 1
[    2.555238] initcall add_pcspkr+0x0/0x38 returned 0 after 63 usecs
[    2.561422] calling  microcode_init+0x0/0x145 @ 1
[    2.566209] microcode: CPU0: family 15 not supported
[    2.571239] initcall microcode_init+0x0/0x145 returned -22 after 4981 usecs
[    2.578214] initcall microcode_init+0x0/0x145 returned with error code -22 
[    2.585176] calling  start_periodic_check_for_corruption+0x0/0x50 @ 1
[    2.591627] initcall start_periodic_check_for_corruption+0x0/0x50 returned 0 after 1 usecs
[    2.599890] calling  audit_classes_init+0x0/0xaf @ 1
[    2.604865] initcall audit_classes_init+0x0/0xaf returned 0 after 7 usecs
[    2.611653] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    2.616462] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 8 usecs
[    2.623082] calling  proc_schedstat_init+0x0/0x22 @ 1
[    2.628144] initcall proc_schedstat_init+0x0/0x22 returned 0 after 6 usecs
[    2.635018] calling  proc_execdomains_init+0x0/0x22 @ 1
[    2.640254] initcall proc_execdomains_init+0x0/0x22 returned 0 after 3 usecs
[    2.647307] calling  ioresources_init+0x0/0x3c @ 1
[    2.652111] initcall ioresources_init+0x0/0x3c returned 0 after 3 usecs
[    2.658728] calling  uid_cache_init+0x0/0x87 @ 1
[    2.663357] initcall uid_cache_init+0x0/0x87 returned 0 after 6 usecs
[    2.669794] calling  init_posix_timers+0x0/0x203 @ 1
[    2.674765] initcall init_posix_timers+0x0/0x203 returned 0 after 3 usecs
[    2.681555] calling  init_posix_cpu_timers+0x0/0xc2 @ 1
[    2.686785] initcall init_posix_cpu_timers+0x0/0xc2 returned 0 after 1 usecs
[    2.693837] calling  create_proc_profile+0x0/0x270 @ 1
[    2.698978] initcall create_proc_profile+0x0/0x270 returned 0 after 1 usecs
[    2.705945] calling  timekeeping_init_ops+0x0/0x14 @ 1
[    2.711086] initcall timekeeping_init_ops+0x0/0x14 returned 0 after 1 usecs
[    2.718051] calling  init_clocksource_sysfs+0x0/0x50 @ 1
[    2.723480] initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 112 usecs
[    2.730794] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    2.736117] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 3 usecs
[    2.743261] calling  alarmtimer_init+0x0/0x18a @ 1
[    2.748186] initcall alarmtimer_init+0x0/0x18a returned 0 after 124 usecs
[    2.754974] calling  init_tstats_procfs+0x0/0x2c @ 1
[    2.759950] initcall init_tstats_procfs+0x0/0x2c returned 0 after 3 usecs
[    2.766748] calling  futex_init+0x0/0x58 @ 1
[    2.771030] initcall futex_init+0x0/0x58 returned 0 after 6 usecs
[    2.777122] calling  proc_dma_init+0x0/0x22 @ 1
[    2.781661] initcall proc_dma_init+0x0/0x22 returned 0 after 3 usecs
[    2.788019] calling  proc_modules_init+0x0/0x22 @ 1
[    2.792911] initcall proc_modules_init+0x0/0x22 returned 0 after 3 usecs
[    2.799614] calling  kallsyms_init+0x0/0x25 @ 1
[    2.804151] initcall kallsyms_init+0x0/0x25 returned 0 after 3 usecs
[    2.810508] calling  snapshot_device_init+0x0/0x12 @ 1
[    2.815722] initcall snapshot_device_init+0x0/0x12 returned 0 after 70 usecs
[    2.822774] calling  crash_save_vmcoreinfo_init+0x0/0x46d @ 1
[    2.828553] initcall crash_save_vmcoreinfo_init+0x0/0x46d returned 0 after 24 usecs
[    2.836212] calling  crash_notes_memory_init+0x0/0x37 @ 1
[    2.841622] initcall crash_notes_memory_init+0x0/0x37 returned 0 after 6 usecs
[    2.848843] calling  user_namespaces_init+0x0/0x2d @ 1
[    2.854000] initcall user_namespaces_init+0x0/0x2d returned 0 after 9 usecs
[    2.860964] calling  pid_namespaces_init+0x0/0x2d @ 1
[    2.866025] initcall pid_namespaces_init+0x0/0x2d returned 0 after 6 usecs
[    2.872900] calling  audit_init+0x0/0x13e @ 1
[    2.877268] audit: initializing netlink socket (disabled)
[    2.882678] type=2000 audit(1320395547.881:1): initialized
[    2.888174] initcall audit_init+0x0/0x13e returned 0 after 10649 usecs
[    2.894703] calling  audit_watch_init+0x0/0x3a @ 1
[    2.899499] initcall audit_watch_init+0x0/0x3a returned 0 after 2 usecs
[    2.906118] calling  audit_tree_init+0x0/0x58 @ 1
[    2.910828] initcall audit_tree_init+0x0/0x58 returned 0 after 2 usecs
[    2.917358] calling  init_kprobes+0x0/0x14f @ 1
[    2.946325] initcall init_kprobes+0x0/0x14f returned 0 after 23860 usecs
[    2.953032] calling  irq_pm_init_ops+0x0/0x14 @ 1
[    2.957742] initcall irq_pm_init_ops+0x0/0x14 returned 0 after 2 usecs
[    2.964274] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    2.969354] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 18 usecs
[    2.976319] calling  init_tracepoints+0x0/0x20 @ 1
[    2.981126] initcall init_tracepoints+0x0/0x20 returned 0 after 1 usecs
[    2.987742] calling  init_events+0x0/0x60 @ 1
[    2.992116] initcall init_events+0x0/0x60 returned 0 after 3 usecs
[    2.998298] calling  init_blk_tracer+0x0/0x5c @ 1
[    3.003016] initcall init_blk_tracer+0x0/0x5c returned 0 after 2 usecs
[    3.009547] calling  perf_event_sysfs_init+0x0/0x93 @ 1
[    3.015146] initcall perf_event_sysfs_init+0x0/0x93 returned 0 after 360 usecs
[    3.022384] calling  init_per_zone_wmark_min+0x0/0x88 @ 1
[    3.031967] initcall init_per_zone_wmark_min+0x0/0x88 returned 0 after 4074 usecs
[    3.039458] calling  kswapd_init+0x0/0x75 @ 1
[    3.043899] initcall kswapd_init+0x0/0x75 returned 0 after 69 usecs
[    3.050174] calling  setup_vmstat+0x0/0xc7 @ 1
[    3.054635] initcall setup_vmstat+0x0/0xc7 returned 0 after 11 usecs
[    3.060991] calling  mm_sysfs_init+0x0/0x29 @ 1
[    3.065531] initcall mm_sysfs_init+0x0/0x29 returned 0 after 5 usecs
[    3.071885] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    3.076768] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 3 usecs
[    3.083474] calling  procswaps_init+0x0/0x22 @ 1
[    3.088095] initcall procswaps_init+0x0/0x22 returned 0 after 2 usecs
[    3.094538] calling  hugetlb_init+0x0/0x42c @ 1
[    3.099074] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.105448] initcall hugetlb_init+0x0/0x42c returned 0 after 6225 usecs
[    3.112065] calling  slab_proc_init+0x0/0x25 @ 1
[    3.116687] initcall slab_proc_init+0x0/0x25 returned 0 after 2 usecs
[    3.123130] calling  slab_sysfs_init+0x0/0x109 @ 1
[    3.133307] initcall slab_sysfs_init+0x0/0x109 returned 0 after 5252 usecs
[    3.140191] calling  fcntl_init+0x0/0x2a @ 1
[    3.144629] initcall fcntl_init+0x0/0x2a returned 0 after 107 usecs
[    3.150902] calling  proc_filesystems_init+0x0/0x22 @ 1
[    3.156155] initcall proc_filesystems_init+0x0/0x22 returned 0 after 7 usecs
[    3.163206] calling  fsnotify_mark_init+0x0/0x40 @ 1
[    3.168229] initcall fsnotify_mark_init+0x0/0x40 returned 0 after 46 usecs
[    3.175106] calling  dnotify_init+0x0/0x7b @ 1
[    3.179734] initcall dnotify_init+0x0/0x7b returned 0 after 176 usecs
[    3.186173] calling  inotify_user_setup+0x0/0x70 @ 1
[    3.191149] initcall inotify_user_setup+0x0/0x70 returned 0 after 9 usecs
[    3.197942] calling  aio_setup+0x0/0x78 @ 1
[    3.202144] initcall aio_setup+0x0/0x78 returned 0 after 13 usecs
[    3.208238] calling  proc_locks_init+0x0/0x22 @ 1
[    3.212953] initcall proc_locks_init+0x0/0x22 returned 0 after 9 usecs
[    3.219478] calling  init_sys32_ioctl+0x0/0x28 @ 1
[    3.224379] initcall init_sys32_ioctl+0x0/0x28 returned 0 after 105 usecs
[    3.231170] calling  init_mbcache+0x0/0x14 @ 1
[    3.235619] initcall init_mbcache+0x0/0x14 returned 0 after 1 usecs
[    3.241890] calling  dquot_init+0x0/0x11a @ 1
[    3.246248] VFS: Disk quotas dquot_6.5.2
[    3.250298] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.256751] initcall dquot_init+0x0/0x11a returned 0 after 10254 usecs
[    3.263282] calling  init_v2_quota_format+0x0/0x22 @ 1
[    3.268429] initcall init_v2_quota_format+0x0/0x22 returned 0 after 1 usecs
[    3.275396] calling  quota_init+0x0/0x26 @ 1
[    3.279678] initcall quota_init+0x0/0x26 returned 0 after 7 usecs
[    3.285768] calling  proc_cmdline_init+0x0/0x22 @ 1
[    3.290653] initcall proc_cmdline_init+0x0/0x22 returned 0 after 3 usecs
[    3.297361] calling  proc_consoles_init+0x0/0x22 @ 1
[    3.302334] initcall proc_consoles_init+0x0/0x22 returned 0 after 2 usecs
[    3.309125] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    3.314017] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 6 usecs
[    3.320721] calling  proc_devices_init+0x0/0x22 @ 1
[    3.325605] initcall proc_devices_init+0x0/0x22 returned 0 after 2 usecs
[    3.332311] calling  proc_interrupts_init+0x0/0x22 @ 1
[    3.337456] initcall proc_interrupts_init+0x0/0x22 returned 0 after 3 usecs
[    3.344419] calling  proc_loadavg_init+0x0/0x22 @ 1
[    3.349311] initcall proc_loadavg_init+0x0/0x22 returned 0 after 2 usecs
[    3.356014] calling  proc_meminfo_init+0x0/0x22 @ 1
[    3.360897] initcall proc_meminfo_init+0x0/0x22 returned 0 after 3 usecs
[    3.367600] calling  proc_stat_init+0x0/0x22 @ 1
[    3.372224] initcall proc_stat_init+0x0/0x22 returned 0 after 2 usecs
[    3.378667] calling  proc_uptime_init+0x0/0x22 @ 1
[    3.383464] initcall proc_uptime_init+0x0/0x22 returned 0 after 2 usecs
[    3.390082] calling  proc_version_init+0x0/0x22 @ 1
[    3.394964] initcall proc_version_init+0x0/0x22 returned 0 after 2 usecs
[    3.401669] calling  proc_softirqs_init+0x0/0x22 @ 1
[    3.406640] initcall proc_softirqs_init+0x0/0x22 returned 0 after 2 usecs
[    3.413429] calling  proc_kcore_init+0x0/0xa9 @ 1
[    3.418143] initcall proc_kcore_init+0x0/0xa9 returned 0 after 6 usecs
[    3.424671] calling  vmcore_init+0x0/0x51b @ 1
[    3.429119] initcall vmcore_init+0x0/0x51b returned 0 after 1 usecs
[    3.435391] calling  proc_kmsg_init+0x0/0x25 @ 1
[    3.440015] initcall proc_kmsg_init+0x0/0x25 returned 0 after 2 usecs
[    3.446459] calling  proc_page_init+0x0/0x42 @ 1
[    3.451084] initcall proc_page_init+0x0/0x42 returned 0 after 4 usecs
[    3.457524] calling  init_devpts_fs+0x0/0x49 @ 1
[    3.462167] initcall init_devpts_fs+0x0/0x49 returned 0 after 19 usecs
[    3.468698] calling  init_ext3_fs+0x0/0x76 @ 1
[    3.473329] initcall init_ext3_fs+0x0/0x76 returned 0 after 179 usecs
[    3.479777] calling  journal_init+0x0/0x9e @ 1
[    3.484608] initcall journal_init+0x0/0x9e returned 0 after 367 usecs
[    3.491054] calling  init_ramfs_fs+0x0/0x12 @ 1
[    3.495597] initcall init_ramfs_fs+0x0/0x12 returned 0 after 5 usecs
[    3.501950] calling  init_hugetlbfs_fs+0x0/0x95 @ 1
[    3.506950] initcall init_hugetlbfs_fs+0x0/0x95 returned 0 after 115 usecs
[    3.513825] calling  init_fat_fs+0x0/0x4d @ 1
[    3.518356] initcall init_fat_fs+0x0/0x4d returned 0 after 166 usecs
[    3.524719] calling  init_vfat_fs+0x0/0x12 @ 1
[    3.529168] initcall init_vfat_fs+0x0/0x12 returned 0 after 2 usecs
[    3.535441] calling  init_msdos_fs+0x0/0x12 @ 1
[    3.539974] initcall init_msdos_fs+0x0/0x12 returned 0 after 2 usecs
[    3.546331] calling  init_iso9660_fs+0x0/0x77 @ 1
[    3.551139] initcall init_iso9660_fs+0x0/0x77 returned 0 after 96 usecs
[    3.557762] calling  init_nfs_fs+0x0/0x138 @ 1
[    3.562498] initcall init_nfs_fs+0x0/0x138 returned 0 after 275 usecs
[    3.568945] calling  init_nlm+0x0/0x22 @ 1
[    3.573061] initcall init_nlm+0x0/0x22 returned 0 after 16 usecs
[    3.579067] calling  init_nls_cp437+0x0/0x12 @ 1
[    3.583689] initcall init_nls_cp437+0x0/0x12 returned 0 after 1 usecs
[    3.590133] calling  init_nls_ascii+0x0/0x12 @ 1
[    3.594756] initcall init_nls_ascii+0x0/0x12 returned 0 after 1 usecs
[    3.601200] calling  init_nls_iso8859_1+0x0/0x12 @ 1
[    3.606172] initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 1 usecs
[    3.612961] calling  init_nls_utf8+0x0/0x25 @ 1
[    3.617498] initcall init_nls_utf8+0x0/0x25 returned 0 after 1 usecs
[    3.623855] calling  init_autofs4_fs+0x0/0x23 @ 1
[    3.628649] initcall init_autofs4_fs+0x0/0x23 returned 0 after 83 usecs
[    3.635271] calling  ipc_init+0x0/0x23 @ 1
[    3.639383] msgmni has been set to 1985
[    3.643235] initcall ipc_init+0x0/0x23 returned 0 after 3768 usecs
[    3.649416] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    3.654153] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 20 usecs
[    3.660770] calling  init_mqueue_fs+0x0/0xb0 @ 1
[    3.665512] initcall init_mqueue_fs+0x0/0xb0 returned 0 after 109 usecs
[    3.672134] calling  key_proc_init+0x0/0x5e @ 1
[    3.676680] initcall key_proc_init+0x0/0x5e returned 0 after 5 usecs
[    3.683035] calling  selinux_nf_ip_init+0x0/0x69 @ 1
[    3.688028] initcall selinux_nf_ip_init+0x0/0x69 returned 0 after 1 usecs
[    3.694819] calling  init_sel_fs+0x0/0x9b @ 1
[    3.699183] initcall init_sel_fs+0x0/0x9b returned 0 after 1 usecs
[    3.705368] calling  selnl_init+0x0/0x4d @ 1
[    3.709652] initcall selnl_init+0x0/0x4d returned 0 after 9 usecs
[    3.715752] calling  sel_netif_init+0x0/0x73 @ 1
[    3.720381] initcall sel_netif_init+0x0/0x73 returned 0 after 1 usecs
[    3.726826] calling  sel_netnode_init+0x0/0x74 @ 1
[    3.731622] initcall sel_netnode_init+0x0/0x74 returned 0 after 1 usecs
[    3.738241] calling  sel_netport_init+0x0/0x74 @ 1
[    3.743044] initcall sel_netport_init+0x0/0x74 returned 0 after 1 usecs
[    3.749663] calling  aurule_init+0x0/0x37 @ 1
[    3.754030] initcall aurule_init+0x0/0x37 returned 0 after 1 usecs
[    3.760210] calling  crypto_wq_init+0x0/0x31 @ 1
[    3.764878] initcall crypto_wq_init+0x0/0x31 returned 0 after 44 usecs
[    3.771407] calling  crypto_algapi_init+0x0/0xd @ 1
[    3.776293] initcall crypto_algapi_init+0x0/0xd returned 0 after 5 usecs
[    3.782995] calling  skcipher_module_init+0x0/0x33 @ 1
[    3.788139] initcall skcipher_module_init+0x0/0x33 returned 0 after 1 usecs
[    3.795103] calling  chainiv_module_init+0x0/0x12 @ 1
[    3.800168] initcall chainiv_module_init+0x0/0x12 returned 0 after 3 usecs
[    3.807045] calling  eseqiv_module_init+0x0/0x12 @ 1
[    3.812013] initcall eseqiv_module_init+0x0/0x12 returned 0 after 1 usecs
[    3.818805] calling  hmac_module_init+0x0/0x12 @ 1
[    3.823601] initcall hmac_module_init+0x0/0x12 returned 0 after 2 usecs
[    3.830218] calling  md5_mod_init+0x0/0x12 @ 1
[    3.834734] initcall md5_mod_init+0x0/0x12 returned 0 after 64 usecs
[    3.841088] calling  sha1_generic_mod_init+0x0/0x12 @ 1
[    3.846382] initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 58 usecs
[    3.853529] calling  crypto_cbc_module_init+0x0/0x12 @ 1
[    3.858851] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 2 usecs
[    3.865987] calling  des_generic_mod_init+0x0/0x3c @ 1
[    3.871231] initcall des_generic_mod_init+0x0/0x3c returned 0 after 98 usecs
[    3.878284] calling  aes_init+0x0/0x12 @ 1
[    3.882441] initcall aes_init+0x0/0x12 returned 0 after 54 usecs
[    3.888455] calling  arc4_init+0x0/0x12 @ 1
[    3.892704] initcall arc4_init+0x0/0x12 returned 0 after 54 usecs
[    3.898801] calling  crypto_authenc_module_init+0x0/0x12 @ 1
[    3.904470] initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 2 usecs
[    3.911954] calling  crypto_authenc_esn_module_init+0x0/0x12 @ 1
[    3.917963] initcall crypto_authenc_esn_module_init+0x0/0x12 returned 0 after 1 usecs
[    3.925793] calling  krng_mod_init+0x0/0x12 @ 1
[    3.930382] initcall krng_mod_init+0x0/0x12 returned 0 after 52 usecs
[    3.936829] calling  proc_genhd_init+0x0/0x3c @ 1
[    3.941549] initcall proc_genhd_init+0x0/0x3c returned 0 after 4 usecs
[    3.948079] calling  bsg_init+0x0/0x12e @ 1
[    3.952437] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.959835] initcall bsg_init+0x0/0x12e returned 0 after 7383 usecs
[    3.966105] calling  noop_init+0x0/0x14 @ 1
[    3.970291] io scheduler noop registered
[    3.974227] initcall noop_init+0x0/0x14 returned 0 after 3842 usecs
[    3.980500] calling  deadline_init+0x0/0x14 @ 1
[    3.985033] io scheduler deadline registered
[    3.989316] initcall deadline_init+0x0/0x14 returned 0 after 4180 usecs
[    3.995936] calling  cfq_init+0x0/0x9e @ 1
[    4.000137] io scheduler cfq registered (default)
[    4.004854] initcall cfq_init+0x0/0x9e returned 0 after 4696 usecs
[    4.011041] calling  percpu_counter_startup+0x0/0x19 @ 1
[    4.016359] initcall percpu_counter_startup+0x0/0x19 returned 0 after 4 usecs
[    4.023497] calling  pci_proc_init+0x0/0x69 @ 1
[    4.028087] initcall pci_proc_init+0x0/0x69 returned 0 after 48 usecs
[    4.034529] calling  pcie_portdrv_init+0x0/0x77 @ 1
[    4.039545] pcieport 0000:00:0b.0: setting latency timer to 64
[    4.045411] pcieport 0000:00:0b.0: irq 40 for MSI/MSI-X
[    4.050779] pcieport 0000:00:0c.0: setting latency timer to 64
[    4.056635] pcieport 0000:00:0c.0: irq 41 for MSI/MSI-X
[    4.061990] pcieport 0000:00:0d.0: setting latency timer to 64
[    4.067840] pcieport 0000:00:0d.0: irq 42 for MSI/MSI-X
[    4.073199] pcieport 0000:00:0e.0: setting latency timer to 64
[    4.079062] pcieport 0000:00:0e.0: irq 43 for MSI/MSI-X
[    4.084452] initcall pcie_portdrv_init+0x0/0x77 returned 0 after 43977 usecs
[    4.091503] calling  aer_service_init+0x0/0x22 @ 1
[    4.096359] initcall aer_service_init+0x0/0x22 returned 0 after 62 usecs
[    4.103064] calling  ioapic_init+0x0/0x1b @ 1
[    4.107491] initcall ioapic_init+0x0/0x1b returned 0 after 59 usecs
[    4.113763] calling  pci_hotplug_init+0x0/0x1d @ 1
[    4.118557] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.124131] initcall pci_hotplug_init+0x0/0x1d returned 0 after 5442 usecs
[    4.131017] calling  fb_console_init+0x0/0x11e @ 1
[    4.135893] initcall fb_console_init+0x0/0x11e returned 0 after 76 usecs
[    4.142601] calling  genericbl_init+0x0/0x12 @ 1
[    4.147281] initcall genericbl_init+0x0/0x12 returned 0 after 60 usecs
[    4.153822] calling  efifb_init+0x0/0x1fb @ 1
[    4.158191] initcall efifb_init+0x0/0x1fb returned -19 after 9 usecs
[    4.164542] calling  acpi_reserve_resources+0x0/0xeb @ 1
[    4.169866] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 6 usecs
[    4.177000] calling  irqrouter_init_ops+0x0/0x26 @ 1
[    4.181977] initcall irqrouter_init_ops+0x0/0x26 returned 0 after 2 usecs
[    4.188769] calling  acpi_ac_init+0x0/0x26 @ 1
[    4.193313] initcall acpi_ac_init+0x0/0x26 returned 0 after 87 usecs
[    4.199672] calling  acpi_button_init+0x0/0x12 @ 1
[    4.204574] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    4.212756] ACPI: Power Button [PWRB]
[    4.216531] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.223933] ACPI: Power Button [PWRF]
[    4.227673] initcall acpi_button_init+0x0/0x12 returned 0 after 22655 usecs
[    4.234646] calling  acpi_fan_init+0x0/0x18 @ 1
[    4.239275] ACPI: Fan [FAN] (on)
[    4.242572] initcall acpi_fan_init+0x0/0x18 returned 0 after 3309 usecs
[    4.249197] calling  acpi_video_init+0x0/0x70 @ 1
[    4.253995] initcall acpi_video_init+0x0/0x70 returned 0 after 85 usecs
[    4.260623] calling  acpi_processor_init+0x0/0xcd @ 1
[    4.265676] ACPI: acpi_idle registered with cpuidle
[    4.270832] initcall acpi_processor_init+0x0/0xcd returned 0 after 5032 usecs
[    4.277971] calling  acpi_container_init+0x0/0x4a @ 1
[    4.285503] initcall acpi_container_init+0x0/0x4a returned 0 after 2415 usecs
[    4.292650] calling  acpi_thermal_init+0x0/0x42 @ 1
[    4.298019] thermal LNXTHERM:00: registered as thermal_zone0
[    4.303684] ACPI: Thermal Zone [THRM] (40 C)
[    4.308040] initcall acpi_thermal_init+0x0/0x42 returned 0 after 10257 usecs
[    4.315103] calling  acpi_battery_init+0x0/0x16 @ 1
[    4.319987] initcall acpi_battery_init+0x0/0x16 returned 0 after 3 usecs
[    4.319995] calling  1_acpi_battery_init_async+0x0/0x1b @ 5
[    4.332257] calling  pty_init+0x0/0x279 @ 1
[    4.332324] initcall 1_acpi_battery_init_async+0x0/0x1b returned 0 after 12033 usecs
[    4.344291] initcall pty_init+0x0/0x279 returned 0 after 106 usecs
[    4.350476] calling  sysrq_init+0x0/0x78 @ 1
[    4.354764] initcall sysrq_init+0x0/0x78 returned 0 after 9 usecs
[    4.360865] calling  serial8250_init+0x0/0x187 @ 1
[    4.365666] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.392443] async_waiting @ 1
[    4.395419] async_continuing @ 1 after 1 usec
[    4.521065] async_waiting @ 1
[    4.524039] async_continuing @ 1 after 1 usec
[    4.650103] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.713087] initcall serial8250_init+0x0/0x187 returned 0 after 339277 usecs
[    4.720140] calling  serial8250_pnp_init+0x0/0x12 @ 1
[    4.745734] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.767115] initcall serial8250_pnp_init+0x0/0x12 returned 0 after 40930 usecs
[    4.774342] calling  serial8250_pci_init+0x0/0x1b @ 1
[    4.779511] initcall serial8250_pci_init+0x0/0x1b returned 0 after 103 usecs
[    4.786562] calling  rand_initialize+0x0/0x30 @ 1
[    4.791298] initcall rand_initialize+0x0/0x30 returned 0 after 18 usecs
[    4.797913] calling  hpet_init+0x0/0x67 @ 1
[    4.802269] initcall hpet_init+0x0/0x67 returned 0 after 163 usecs
[    4.808459] calling  nvram_init+0x0/0x7f @ 1
[    4.812805] Non-volatile memory driver v1.3
[    4.817018] initcall nvram_init+0x0/0x7f returned 0 after 4182 usecs
[    4.823376] calling  mod_init+0x0/0x50 @ 1
[    4.827479] initcall mod_init+0x0/0x50 returned -19 after 1 usecs
[    4.833576] calling  agp_init+0x0/0x26 @ 1
[    4.837677] Linux agpgart interface v0.103
[    4.841776] initcall agp_init+0x0/0x26 returned 0 after 4002 usecs
[    4.847954] calling  agp_amd64_mod_init+0x0/0x22 @ 1
[    4.852926] initcall agp_amd64_mod_init+0x0/0x22 returned -19 after 2 usecs
[    4.859889] calling  agp_intel_init+0x0/0x29 @ 1
[    4.864584] initcall agp_intel_init+0x0/0x29 returned 0 after 72 usecs
[    4.871117] calling  drm_core_init+0x0/0x136 @ 1
[    4.875819] [drm] Initialized drm 1.1.0 20060810
[    4.880455] initcall drm_core_init+0x0/0x136 returned 0 after 4602 usecs
[    4.887154] calling  i915_init+0x0/0x8d @ 1
[    4.891341] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    4.898828] initcall i915_init+0x0/0x8d returned -19 after 7311 usecs
[    4.905266] calling  cn_proc_init+0x0/0x3a @ 1
[    4.909717] initcall cn_proc_init+0x0/0x3a returned 0 after 3 usecs
[    4.915991] calling  topology_sysfs_init+0x0/0x67 @ 1
[    4.921063] initcall topology_sysfs_init+0x0/0x67 returned 0 after 13 usecs
[    4.928027] calling  brd_init+0x0/0x1d0 @ 1
[    4.935075] brd: module loaded
[    4.938154] initcall brd_init+0x0/0x1d0 returned 0 after 5796 usecs
[    4.944426] calling  loop_init+0x0/0x131 @ 1
[    4.950301] loop: module loaded
[    4.953471] initcall loop_init+0x0/0x131 returned 0 after 4647 usecs
[    4.959825] calling  cpqarray_init+0x0/0x2a1 @ 1
[    4.964453] Compaq SMART2 Driver (v 2.6.0)
[    4.968702] initcall cpqarray_init+0x0/0x2a1 returned -19 after 4147 usecs
[    4.975601] calling  mac_hid_init+0x0/0x22 @ 1
[    4.980072] initcall mac_hid_init+0x0/0x22 returned 0 after 18 usecs
[    4.986473] calling  spi_transport_init+0x0/0x7b @ 1
[    4.991568] initcall spi_transport_init+0x0/0x7b returned 0 after 112 usecs
[    4.998531] calling  ahc_linux_init+0x0/0x63 @ 1
[    5.003243] initcall ahc_linux_init+0x0/0x63 returned 0 after 80 usecs
[    5.009787] calling  init_sd+0x0/0x112 @ 1
[    5.014068] initcall init_sd+0x0/0x112 returned 0 after 172 usecs
[    5.020168] calling  init_sr+0x0/0x46 @ 1
[    5.024246] initcall init_sr+0x0/0x46 returned 0 after 60 usecs
[    5.030180] calling  init_sg+0x0/0x12c @ 1
[    5.034364] initcall init_sg+0x0/0x12c returned 0 after 80 usecs
[    5.040379] calling  ahci_init+0x0/0x1b @ 1
[    5.044660] initcall ahci_init+0x0/0x1b returned 0 after 89 usecs
[    5.050761] calling  piix_init+0x0/0x29 @ 1
[    5.055047] initcall piix_init+0x0/0x29 returned 0 after 90 usecs
[    5.061153] calling  nv_init+0x0/0x1b @ 1
[    5.065241] initcall nv_init+0x0/0x1b returned 0 after 69 usecs
[    5.071170] calling  amd_init+0x0/0x1b @ 1
[    5.075332] pata_amd 0000:00:06.0: version 0.4.1
[    5.079992] pata_amd 0000:00:06.0: setting latency timer to 64
[    5.086552] scsi0 : pata_amd
[    5.089653] scsi1 : pata_amd
[    5.093322] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    5.100310] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    5.107283] work_for_cpu used greatest stack depth: 5240 bytes left
[    5.107289] calling  2_async_port_probe+0x0/0x70 @ 5
[    5.107301] calling  3_async_port_probe+0x0/0x70 @ 14
[    5.107306] async_waiting @ 14
[    5.126712] initcall amd_init+0x0/0x1b returned 0 after 50231 usecs
[    5.132986] calling  oldpiix_init+0x0/0x1b @ 1
[    5.137522] initcall oldpiix_init+0x0/0x1b returned 0 after 81 usecs
[    5.143880] calling  sch_init+0x0/0x1b @ 1
[    5.148063] initcall sch_init+0x0/0x1b returned 0 after 75 usecs
[    5.154074] calling  via_init+0x0/0x1b @ 1
[    5.158245] initcall via_init+0x0/0x1b returned 0 after 64 usecs
[    5.164257] calling  e1000_init_module+0x0/0x86 @ 1
[    5.169140] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    5.176185] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    5.182027] initcall e1000_init_module+0x0/0x86 returned 0 after 12582 usecs
[    5.189075] calling  e1000_init_module+0x0/0x3e @ 1
[    5.193952] e1000e: Intel(R) PRO/1000 Network Driver - 1.4.4-k
[    5.199784] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    5.205777] initcall e1000_init_module+0x0/0x3e returned 0 after 11545 usecs
[    5.212834] calling  vortex_init+0x0/0xb0 @ 1
[    5.217277] initcall vortex_init+0x0/0xb0 returned 0 after 73 usecs
[    5.223557] calling  e100_init_module+0x0/0x5d @ 1
[    5.228353] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    5.234444] e100: Copyright(c) 1999-2006 Intel Corporation
[    5.240023] initcall e100_init_module+0x0/0x5d returned 0 after 11395 usecs
[    5.246986] calling  tg3_init+0x0/0x1b @ 1
[    5.251163] initcall tg3_init+0x0/0x1b returned 0 after 73 usecs
[    5.257175] calling  skge_init_module+0x0/0x35 @ 1
[    5.262220] initcall skge_init_module+0x0/0x35 returned 0 after 240 usecs
[    5.268677] ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
[    5.268680] ata1.00: 488397168 sectors, multi 1: LBA48 
[    5.268688] ata1: nv_mode_filter: 0x3f39f&0x3f39f->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x3f01f (20:600:0x13)
[    5.277556] ata1.00: configured for UDMA/100
[    5.294913] calling  sky2_init_module+0x0/0x29 @ 1
[    5.294919] async_waiting @ 5
[    5.294925] async_continuing @ 5 after 2 usec
[    5.295051] scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
[    5.295262] calling  4_sd_probe_async+0x0/0x1c0 @ 748
[    5.295301] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    5.295354] sd 0:0:0:0: [sda] Write Protect is off
[    5.295357] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.295380] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.346483] sky2: driver version 1.29
[    5.347452] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.347531] initcall 2_async_port_probe+0x0/0x70 returned 0 after 234603 usecs
[    5.362674] async_continuing @ 14 after 249379 usec
[    5.367713] initcall sky2_init_module+0x0/0x29 returned 0 after 20730 usecs
[    5.374682] calling  net_olddevs_init+0x0/0x9e @ 1
[    5.379490] initcall net_olddevs_init+0x0/0x9e returned 0 after 5 usecs
[    5.386104] calling  init_nic+0x0/0x1b @ 1
[    5.390256] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[    5.397790] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
[    5.403556] forcedeth 0000:00:0a.0: PCI INT A -> Link[APCH] -> GSI 23 (level, low) -> IRQ 23
[    5.411990] forcedeth 0000:00:0a.0: setting latency timer to 64
[    5.434866]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
[    5.442248] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.446879] initcall 4_sd_probe_async+0x0/0x1c0 returned 0 after 148055 usecs
[    5.529242] ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
[    5.535253] ata2: nv_mode_filter: 0x1f39f&0x739f->0x739f, BIOS=0x7000 (0xc60000c0) ACPI=0x701f (600:60:0x1c)
[    5.551193] ata2.01: configured for UDMA/33
[    5.556066] async_waiting @ 14
[    5.559127] async_continuing @ 14 after 1 usec
[    5.563897] scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
[    5.574849] sr0: scsi3-mmc drive: 1x/48x writer cd/rw xa/form2 cdda tray
[    5.581554] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.587031] sr 1:0:1:0: Attached scsi CD-ROM sr0
[    5.591844] sr 1:0:1:0: Attached scsi generic sg1 type 5
[    5.597249] initcall 3_async_port_probe+0x0/0x70 returned 0 after 478456 usecs
[    5.939644] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 9, addr 00:13:d4:dc:41:12
[    5.948011] forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
[    5.954464] initcall init_nic+0x0/0x1b returned 0 after 551032 usecs
[    5.960829] calling  rtl8139_init_module+0x0/0x1b @ 1
[    5.965942] 8139too: 8139too Fast Ethernet driver 0.9.28
[    5.971393] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
[    5.977158] 8139too 0000:05:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
[    5.986120] 8139too 0000:05:07.0: eth1: RealTek RTL8139 at 0xc000, 00:c0:df:03:68:5d, IRQ 17
[    5.994637] initcall rtl8139_init_module+0x0/0x1b returned 0 after 28075 usecs
[    6.001861] calling  cdrom_init+0x0/0x16 @ 1
[    6.006134] initcall cdrom_init+0x0/0x16 returned 0 after 1 usecs
[    6.012232] calling  nonstatic_sysfs_init+0x0/0x12 @ 1
[    6.017376] initcall nonstatic_sysfs_init+0x0/0x12 returned 0 after 3 usecs
[    6.024340] calling  yenta_socket_init+0x0/0x1b @ 1
[    6.029297] initcall yenta_socket_init+0x0/0x1b returned 0 after 74 usecs
[    6.036089] calling  mon_init+0x0/0xff @ 1
[    6.040343] initcall mon_init+0x0/0xff returned 0 after 145 usecs
[    6.046445] calling  ehci_hcd_init+0x0/0xea @ 1
[    6.050982] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.057508] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    6.063703] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
[    6.069462] ehci_hcd 0000:00:02.1: PCI INT B -> Link[APCL] -> GSI 22 (level, low) -> IRQ 22
[    6.077829] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    6.083668] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    6.088925] drivers/usb/core/inode.c: creating file 'devices'
[    6.094677] drivers/usb/core/inode.c: creating file '001'
[    6.100180] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    6.107591] ehci_hcd 0000:00:02.1: reset hcs_params 0x10148a dbg=1 cc=1 pcc=4 !ppc ports=10
[    6.115947] ehci_hcd 0000:00:02.1: reset portroute 0 0 0 0 0 0 0 0 0 0 
[    6.122564] ehci_hcd 0000:00:02.1: reset hcc_params a086 caching frame 256/512/1024 park
[    6.130670] ehci_hcd 0000:00:02.1: park 0
[    6.134691] ehci_hcd 0000:00:02.1: debug port 1
[    6.139230] ehci_hcd 0000:00:02.1: reset command 0080b02  park=3 ithresh=8 period=1024 Reset HALT
[    6.148102] ehci_hcd 0000:00:02.1: bogus port configuration: cc=1 x pcc=4 < ports=10
[    6.155842] ehci_hcd 0000:00:02.1: cache line size of 32 is not supported
[    6.162636] ehci_hcd 0000:00:02.1: supports USB remote wakeup
[    6.168400] ehci_hcd 0000:00:02.1: irq 22, io mem 0x40000000
[    6.174062] ehci_hcd 0000:00:02.1: reset command 0080b02  park=3 ithresh=8 period=1024 Reset HALT
[    6.182935] ehci_hcd 0000:00:02.1: init command 0010005 (park)=0 ithresh=1 period=512 RUN
[    6.197020] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    6.202800] usb usb1: default language 0x0409
[    6.207171] usb usb1: udev 1, busnum 1, minor = 0
[    6.211879] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.218666] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.225884] usb usb1: Product: EHCI Host Controller
[    6.230763] usb usb1: Manufacturer: Linux 3.1.0-tip+ ehci_hcd
[    6.236510] usb usb1: SerialNumber: 0000:00:02.1
[    6.241236] usb usb1: usb_probe_device
[    6.244997] usb usb1: configuration #1 chosen from 1 choice
[    6.250587] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    6.256416] hub 1-0:1.0: usb_probe_interface
[    6.260693] hub 1-0:1.0: usb_probe_interface - got id
[    6.265754] hub 1-0:1.0: USB hub found
[    6.269520] hub 1-0:1.0: 10 ports detected
[    6.273624] hub 1-0:1.0: standalone hub
[    6.277469] hub 1-0:1.0: no power switching (usb 1.0)
[    6.282522] hub 1-0:1.0: individual port over-current protection
[    6.288528] hub 1-0:1.0: power on to power good time: 20ms
[    6.294016] hub 1-0:1.0: local power source is good
[    6.298902] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    6.305806] drivers/usb/core/inode.c: creating file '001'
[    6.311338] initcall ehci_hcd_init+0x0/0xea returned 0 after 254252 usecs
[    6.318129] calling  ohci_hcd_mod_init+0x0/0xb9 @ 1
[    6.323023] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.329208] ohci_hcd: block sizes: ed 80 td 96
[    6.333851] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21
[    6.339614] ohci_hcd 0000:00:02.0: PCI INT A -> Link[APCF] -> GSI 21 (level, low) -> IRQ 21
[    6.347978] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    6.353818] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    6.359056] drivers/usb/core/inode.c: creating file '002'
[    6.364548] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    6.371957] ohci_hcd 0000:00:02.0: enabled nVidia shutdown quirk
[    6.377982] ohci_hcd 0000:00:02.0: created debug files
[    6.383127] ohci_hcd 0000:00:02.0: supports USB remote wakeup
[    6.388894] ohci_hcd 0000:00:02.0: irq 21, io mem 0xda102000
[    6.405048] hub 1-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    6.447023] ohci_hcd 0000:00:02.0: OHCI controller state
[    6.452336] ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers
[    6.459035] ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=operational CBSR=3
[    6.466429] ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=0
[    6.471914] ohci_hcd 0000:00:02.0: intrstatus 0x00000004 SF
[    6.477487] ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
[    6.484188] ohci_hcd 0000:00:02.0: hcca frame #0028
[    6.489066] ohci_hcd 0000:00:02.0: roothub.a 0100020a POTPGT=1 NPS NDP=10(10)
[    6.496198] ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=0000 DR=0000
[    6.502812] ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
[    6.508731] ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
[    6.515439] ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
[    6.522138] ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
[    6.528838] ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
[    6.535537] ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00000100 PPS
[    6.542236] ohci_hcd 0000:00:02.0: roothub.portstatus [5] 0x00000100 PPS
[    6.548935] ohci_hcd 0000:00:02.0: roothub.portstatus [6] 0x00000100 PPS
[    6.555635] ohci_hcd 0000:00:02.0: roothub.portstatus [7] 0x00000100 PPS
[    6.562334] ohci_hcd 0000:00:02.0: roothub.portstatus [8] 0x00000100 PPS
[    6.569033] ohci_hcd 0000:00:02.0: roothub.portstatus [9] 0x00000100 PPS
[    6.575741] usb usb2: default language 0x0409
[    6.580106] usb usb2: udev 1, busnum 2, minor = 128
[    6.584987] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    6.591774] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.598993] usb usb2: Product: OHCI Host Controller
[    6.603871] usb usb2: Manufacturer: Linux 3.1.0-tip+ ohci_hcd
[    6.609618] usb usb2: SerialNumber: 0000:00:02.0
[    6.614342] usb usb2: usb_probe_device
[    6.618098] usb usb2: configuration #1 chosen from 1 choice
[    6.623681] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    6.629509] hub 2-0:1.0: usb_probe_interface
[    6.633784] hub 2-0:1.0: usb_probe_interface - got id
[    6.638842] hub 2-0:1.0: USB hub found
[    6.642600] hub 2-0:1.0: 10 ports detected
[    6.646708] hub 2-0:1.0: standalone hub
[    6.650550] hub 2-0:1.0: no power switching (usb 1.0)
[    6.655604] hub 2-0:1.0: global over-current protection
[    6.660829] hub 2-0:1.0: power on to power good time: 2ms
[    6.666232] hub 2-0:1.0: local power source is good
[    6.671119] hub 2-0:1.0: no over-current condition exists
[    6.676516] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    6.683407] drivers/usb/core/inode.c: creating file '001'
[    6.688833] ehci_hcd 0000:00:02.1: HS companion for 0000:00:02.0
[    6.694933] initcall ohci_hcd_mod_init+0x0/0xb9 returned 0 after 363192 usecs
[    6.702072] calling  uhci_hcd_init+0x0/0x115 @ 1
[    6.706696] uhci_hcd: USB Universal Host Controller Interface driver
[    6.713153] initcall uhci_hcd_init+0x0/0x115 returned 0 after 6303 usecs
[    6.719859] calling  usblp_init+0x0/0x1b @ 1
[    6.724198] usbcore: registered new interface driver usblp
[    6.729697] initcall usblp_init+0x0/0x1b returned 0 after 5434 usecs
[    6.736057] calling  usb_stor_init+0x0/0x4d @ 1
[    6.740588] Initializing USB Mass Storage driver...
[    6.745542] usbcore: registered new interface driver usb-storage
[    6.751555] USB Mass Storage support registered.
[    6.756181] initcall usb_stor_init+0x0/0x4d returned 0 after 15225 usecs
[    6.762878] calling  usb_usual_init+0x0/0x3b @ 1
[    6.767567] usbcore: registered new interface driver libusual
[    6.773322] initcall usb_usual_init+0x0/0x3b returned 0 after 5686 usecs
[    6.780026] calling  i8042_init+0x0/0x3c2 @ 1
[    6.784397] hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    6.790131] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    6.801436] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.806411] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.811595] initcall i8042_init+0x0/0x3c2 returned 0 after 26564 usecs
[    6.818135] calling  serport_init+0x0/0x31 @ 1
[    6.822591] initcall serport_init+0x0/0x31 returned 0 after 2 usecs
[    6.828861] calling  mousedev_init+0x0/0x5e @ 1
[    6.833481] mousedev: PS/2 mouse device common for all mice
[    6.839065] initcall mousedev_init+0x0/0x5e returned 0 after 5537 usecs
[    6.845681] calling  evdev_init+0x0/0x12 @ 1
[    6.850111] initcall evdev_init+0x0/0x12 returned 0 after 149 usecs
[    6.856379] calling  atkbd_init+0x0/0x27 @ 1
[    6.860731] initcall atkbd_init+0x0/0x27 returned 0 after 69 usecs
[    6.866925] calling  psmouse_init+0x0/0x79 @ 1
[    6.871528] initcall psmouse_init+0x0/0x79 returned 0 after 138 usecs
[    6.877975] calling  cmos_init+0x0/0x6a @ 1
[    6.882191] rtc_cmos 00:04: RTC can wake from S4
[    6.886963] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    6.893087] rtc0: alarms up to one year, y3k, 242 bytes nvram
[    6.893373] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    6.907499] initcall cmos_init+0x0/0x6a returned 0 after 24742 usecs
[    6.913859] calling  i2c_i801_init+0x0/0xa8 @ 1
[    6.918480] initcall i2c_i801_init+0x0/0xa8 returned 0 after 83 usecs
[    6.924926] calling  dm_init+0x0/0x45 @ 1
[    6.929171] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[    6.937617] initcall dm_init+0x0/0x45 returned 0 after 8470 usecs
[    6.943709] calling  dm_mirror_init+0x0/0x76 @ 1
[    6.948427] initcall dm_mirror_init+0x0/0x76 returned 0 after 94 usecs
[    6.954973] calling  dm_dirty_log_init+0x0/0x56 @ 1
[    6.959859] initcall dm_dirty_log_init+0x0/0x56 returned 0 after 2 usecs
[    6.966563] calling  dm_zero_init+0x0/0x2e @ 1
[    6.971020] initcall dm_zero_init+0x0/0x2e returned 0 after 2 usecs
[    6.977284] calling  cpufreq_gov_dbs_init+0x0/0x5e @ 1
[    6.982430] initcall cpufreq_gov_dbs_init+0x0/0x5e returned 0 after 4 usecs
[    6.989395] calling  init_ladder+0x0/0x12 @ 1
[    6.993760] cpuidle: using governor ladder
[    6.997861] initcall init_ladder+0x0/0x12 returned 0 after 4004 usecs
[    7.004306] calling  init_menu+0x0/0x12 @ 1
[    7.008492] cpuidle: using governor menu
[    7.012423] initcall init_menu+0x0/0x12 returned 0 after 3837 usecs
[    7.018694] calling  efivars_init+0x0/0xf3 @ 1
[    7.023140] EFI Variables Facility v0.08 2004-May-17
[    7.028106] initcall efivars_init+0x0/0xf3 returned 0 after 4848 usecs
[    7.034632] calling  hid_init+0x0/0x65 @ 1
[    7.038866] initcall hid_init+0x0/0x65 returned 0 after 129 usecs
[    7.044963] calling  a4_init+0x0/0x1b @ 1
[    7.049054] initcall a4_init+0x0/0x1b returned 0 after 75 usecs
[    7.054976] calling  apple_init+0x0/0x37 @ 1
[    7.059341] initcall apple_init+0x0/0x37 returned 0 after 83 usecs
[    7.065523] calling  belkin_init+0x0/0x1b @ 1
[    7.069958] initcall belkin_init+0x0/0x1b returned 0 after 61 usecs
[    7.076227] calling  ch_init+0x0/0x1b @ 1
[    7.080318] initcall ch_init+0x0/0x1b returned 0 after 66 usecs
[    7.086244] calling  ch_init+0x0/0x1b @ 1
[    7.090335] initcall ch_init+0x0/0x1b returned 0 after 62 usecs
[    7.096264] calling  cp_init+0x0/0x1b @ 1
[    7.100350] initcall cp_init+0x0/0x1b returned 0 after 62 usecs
[    7.106272] calling  ez_init+0x0/0x1b @ 1
[    7.110353] initcall ez_init+0x0/0x1b returned 0 after 62 usecs
[    7.116275] calling  gyration_init+0x0/0x1b @ 1
[    7.120886] initcall gyration_init+0x0/0x1b returned 0 after 62 usecs
[    7.127334] calling  ks_init+0x0/0x1b @ 1
[    7.131421] initcall ks_init+0x0/0x1b returned 0 after 61 usecs
[    7.137343] calling  kye_init+0x0/0x1b @ 1
[    7.141510] initcall kye_init+0x0/0x1b returned 0 after 61 usecs
[    7.147518] calling  lg_init+0x0/0x1b @ 1
[    7.151607] initcall lg_init+0x0/0x1b returned 0 after 62 usecs
[    7.157525] calling  ms_init+0x0/0x1b @ 1
[    7.161607] initcall ms_init+0x0/0x1b returned 0 after 60 usecs
[    7.167528] calling  mr_init+0x0/0x1b @ 1
[    7.171609] initcall mr_init+0x0/0x1b returned 0 after 62 usecs
[    7.177532] calling  ntrig_init+0x0/0x1b @ 1
[    7.181889] initcall ntrig_init+0x0/0x1b returned 0 after 71 usecs
[    7.188078] calling  pl_init+0x0/0x1b @ 1
[    7.192168] initcall pl_init+0x0/0x1b returned 0 after 62 usecs
[    7.198097] calling  pl_init+0x0/0x1b @ 1
[    7.202185] initcall pl_init+0x0/0x1b returned 0 after 61 usecs
[    7.208113] calling  samsung_init+0x0/0x1b @ 1
[    7.212628] initcall samsung_init+0x0/0x1b returned 0 after 62 usecs
[    7.218984] calling  sony_init+0x0/0x1b @ 1
[    7.223244] initcall sony_init+0x0/0x1b returned 0 after 61 usecs
[    7.229340] calling  sp_init+0x0/0x1b @ 1
[    7.233430] initcall sp_init+0x0/0x1b returned 0 after 62 usecs
[    7.239358] calling  ts_init+0x0/0x1b @ 1
[    7.243438] initcall ts_init+0x0/0x1b returned 0 after 63 usecs
[    7.249360] calling  hid_init+0x0/0x75 @ 1
[    7.253606] usbcore: registered new interface driver usbhid
[    7.259187] usbhid: USB HID core driver
[    7.263031] initcall hid_init+0x0/0x75 returned 0 after 9335 usecs
[    7.269214] calling  usb_mouse_init+0x0/0x35 @ 1
[    7.273899] usbcore: registered new interface driver usbmouse
[    7.279656] usbmouse: v1.6:USB HID Boot Protocol mouse driver
[    7.285405] initcall usb_mouse_init+0x0/0x35 returned 0 after 11299 usecs
[    7.292197] calling  eeepc_laptop_init+0x0/0x58 @ 1
[    7.297346] initcall eeepc_laptop_init+0x0/0x58 returned -19 after 261 usecs
[    7.304407] calling  alsa_hwdep_init+0x0/0x61 @ 1
[    7.309123] initcall alsa_hwdep_init+0x0/0x61 returned 0 after 6 usecs
[    7.315660] calling  alsa_timer_init+0x0/0x168 @ 1
[    7.320546] initcall alsa_timer_init+0x0/0x168 returned 0 after 81 usecs
[    7.327248] calling  snd_hrtimer_init+0x0/0xe2 @ 1
[    7.332054] initcall snd_hrtimer_init+0x0/0xe2 returned 0 after 6 usecs
[    7.338673] calling  alsa_pcm_init+0x0/0x69 @ 1
[    7.343214] initcall alsa_pcm_init+0x0/0x69 returned 0 after 4 usecs
[    7.349570] calling  snd_mem_init+0x0/0x2c @ 1
[    7.354024] initcall snd_mem_init+0x0/0x2c returned 0 after 6 usecs
[    7.360292] calling  alsa_mixer_oss_init+0x0/0x3b @ 1
[    7.365348] initcall alsa_mixer_oss_init+0x0/0x3b returned 0 after 2 usecs
[    7.372225] calling  alsa_pcm_oss_init+0x0/0x86 @ 1
[    7.377108] initcall alsa_pcm_oss_init+0x0/0x86 returned 0 after 2 usecs
[    7.383813] calling  alsa_seq_init+0x0/0x4c @ 1
[    7.388430] initcall alsa_seq_init+0x0/0x4c returned 0 after 80 usecs
[    7.394874] calling  alsa_seq_device_init+0x0/0x5b @ 1
[    7.400025] initcall alsa_seq_device_init+0x0/0x5b returned 0 after 3 usecs
[    7.406991] calling  alsa_seq_midi_event_init+0x0/0x8 @ 1
[    7.412398] initcall alsa_seq_midi_event_init+0x0/0x8 returned 0 after 1 usecs
[    7.419623] calling  alsa_seq_oss_init+0x0/0x161 @ 1
[    7.424869] initcall alsa_seq_oss_init+0x0/0x161 returned 0 after 270 usecs
[    7.431841] calling  alsa_seq_dummy_init+0x0/0xb5 @ 1
[    7.436905] initcall alsa_seq_dummy_init+0x0/0xb5 returned 0 after 8 usecs
[    7.443778] calling  patch_realtek_init+0x0/0x12 @ 1
[    7.448745] initcall patch_realtek_init+0x0/0x12 returned 0 after 1 usecs
[    7.455536] calling  patch_cmedia_init+0x0/0x12 @ 1
[    7.460419] initcall patch_cmedia_init+0x0/0x12 returned 0 after 1 usecs
[    7.467124] calling  patch_analog_init+0x0/0x12 @ 1
[    7.472023] initcall patch_analog_init+0x0/0x12 returned 0 after 2 usecs
[    7.478719] calling  patch_sigmatel_init+0x0/0x12 @ 1
[    7.483777] initcall patch_sigmatel_init+0x0/0x12 returned 0 after 1 usecs
[    7.490658] calling  patch_si3054_init+0x0/0x12 @ 1
[    7.495545] initcall patch_si3054_init+0x0/0x12 returned 0 after 1 usecs
[    7.502250] calling  patch_cirrus_init+0x0/0x12 @ 1
[    7.507133] initcall patch_cirrus_init+0x0/0x12 returned 0 after 1 usecs
[    7.513838] calling  patch_ca0110_init+0x0/0x12 @ 1
[    7.518721] initcall patch_ca0110_init+0x0/0x12 returned 0 after 1 usecs
[    7.525425] calling  patch_ca0132_init+0x0/0x12 @ 1
[    7.530307] initcall patch_ca0132_init+0x0/0x12 returned 0 after 1 usecs
[    7.537022] calling  patch_conexant_init+0x0/0x12 @ 1
[    7.542077] initcall patch_conexant_init+0x0/0x12 returned 0 after 1 usecs
[    7.548958] calling  patch_via_init+0x0/0x12 @ 1
[    7.553585] initcall patch_via_init+0x0/0x12 returned 0 after 1 usecs
[    7.560031] calling  patch_hdmi_init+0x0/0x12 @ 1
[    7.564739] initcall patch_hdmi_init+0x0/0x12 returned 0 after 1 usecs
[    7.571272] calling  alsa_card_azx_init+0x0/0x1b @ 1
[    7.576332] initcall alsa_card_azx_init+0x0/0x1b returned 0 after 91 usecs
[    7.583209] calling  alsa_sound_last_init+0x0/0x61 @ 1
[    7.588355] ALSA device list:
[    7.591325]   No soundcards found.
[    7.594736] initcall alsa_sound_last_init+0x0/0x61 returned 0 after 6230 usecs
[    7.601961] calling  flow_cache_init_global+0x0/0x130 @ 1
[    7.607504] initcall flow_cache_init_global+0x0/0x130 returned 0 after 137 usecs
[    7.614903] calling  llc_init+0x0/0x20 @ 1
[    7.619013] initcall llc_init+0x0/0x20 returned 0 after 1 usecs
[    7.624937] calling  snap_init+0x0/0x39 @ 1
[    7.629128] initcall snap_init+0x0/0x39 returned 0 after 3 usecs
[    7.635140] calling  rif_init+0x0/0x84 @ 1
[    7.639274] initcall rif_init+0x0/0x84 returned 0 after 25 usecs
[    7.645294] calling  blackhole_module_init+0x0/0x12 @ 1
[    7.650526] initcall blackhole_module_init+0x0/0x12 returned 0 after 2 usecs
[    7.657575] calling  nfnetlink_init+0x0/0x27 @ 1
[    7.662198] Netfilter messages via NETLINK v0.30.
[    7.666981] initcall nfnetlink_init+0x0/0x27 returned 0 after 4670 usecs
[    7.673690] calling  nfnetlink_log_init+0x0/0xd1 @ 1
[    7.678735] initcall nfnetlink_log_init+0x0/0xd1 returned 0 after 70 usecs
[    7.685624] calling  nf_conntrack_standalone_init+0x0/0x12 @ 1
[    7.691479] nf_conntrack version 0.5.0 (7943 buckets, 31772 max)
[    7.697839] initcall nf_conntrack_standalone_init+0x0/0x12 returned 0 after 6221 usecs
[    7.705760] ohci_hcd 0000:00:02.0: auto-stop root hub
[    7.710818] calling  ctnetlink_init+0x0/0x73 @ 1
[    7.715444] ctnetlink v0.93: registering with nfnetlink.
[    7.720776] initcall ctnetlink_init+0x0/0x73 returned 0 after 5205 usecs
[    7.727494] calling  nf_conntrack_ftp_init+0x0/0x191 @ 1
[    7.732833] initcall nf_conntrack_ftp_init+0x0/0x191 returned 0 after 18 usecs
[    7.740057] calling  nf_conntrack_irc_init+0x0/0x179 @ 1
[    7.745384] initcall nf_conntrack_irc_init+0x0/0x179 returned 0 after 4 usecs
[    7.752519] calling  nf_conntrack_sip_init+0x0/0x1ce @ 1
[    7.757836] initcall nf_conntrack_sip_init+0x0/0x1ce returned 0 after 3 usecs
[    7.764975] calling  xt_init+0x0/0x122 @ 1
[    7.769085] initcall xt_init+0x0/0x122 returned 0 after 3 usecs
[    7.775010] calling  tcpudp_mt_init+0x0/0x17 @ 1
[    7.779641] initcall tcpudp_mt_init+0x0/0x17 returned 0 after 2 usecs
[    7.786084] calling  connsecmark_tg_init+0x0/0x12 @ 1
[    7.791139] initcall connsecmark_tg_init+0x0/0x12 returned 0 after 1 usecs
[    7.798018] calling  nflog_tg_init+0x0/0x12 @ 1
[    7.802554] initcall nflog_tg_init+0x0/0x12 returned 0 after 1 usecs
[    7.808913] calling  secmark_tg_init+0x0/0x12 @ 1
[    7.813620] initcall secmark_tg_init+0x0/0x12 returned 0 after 1 usecs
[    7.813640] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input3
[    7.828581] calling  tcpmss_tg_init+0x0/0x17 @ 1
[    7.833213] initcall tcpmss_tg_init+0x0/0x17 returned 0 after 5 usecs
[    7.839654] calling  conntrack_mt_init+0x0/0x17 @ 1
[    7.844538] initcall conntrack_mt_init+0x0/0x17 returned 0 after 2 usecs
[    7.851240] calling  policy_mt_init+0x0/0x17 @ 1
[    7.855864] initcall policy_mt_init+0x0/0x17 returned 0 after 2 usecs
[    7.862308] calling  state_mt_init+0x0/0x12 @ 1
[    7.866844] initcall state_mt_init+0x0/0x12 returned 0 after 1 usecs
[    7.873201] calling  sysctl_ipv4_init+0x0/0x84 @ 1
[    7.878335] initcall sysctl_ipv4_init+0x0/0x84 returned 0 after 330 usecs
[    7.885127] calling  init_syncookies+0x0/0x19 @ 1
[    7.889855] initcall init_syncookies+0x0/0x19 returned 0 after 21 usecs
[    7.896472] calling  tunnel4_init+0x0/0x6d @ 1
[    7.900921] initcall tunnel4_init+0x0/0x6d returned 0 after 1 usecs
[    7.907193] calling  ipv4_netfilter_init+0x0/0x20 @ 1
[    7.912249] initcall ipv4_netfilter_init+0x0/0x20 returned 0 after 1 usecs
[    7.919126] calling  nf_conntrack_l3proto_ipv4_init+0x0/0x148 @ 1
[    7.925459] initcall nf_conntrack_l3proto_ipv4_init+0x0/0x148 returned 0 after 231 usecs
[    7.933549] calling  nf_nat_init+0x0/0x10e @ 1
[    7.938037] initcall nf_nat_init+0x0/0x10e returned 0 after 41 usecs
[    7.944390] calling  nf_defrag_init+0x0/0x17 @ 1
[    7.949013] initcall nf_defrag_init+0x0/0x17 returned 0 after 1 usecs
[    7.955456] calling  nf_nat_ftp_init+0x0/0x1f @ 1
[    7.960166] initcall nf_nat_ftp_init+0x0/0x1f returned 0 after 1 usecs
[    7.966696] calling  nf_nat_irc_init+0x0/0x1f @ 1
[    7.971407] initcall nf_nat_irc_init+0x0/0x1f returned 0 after 1 usecs
[    7.977938] calling  nf_nat_sip_init+0x0/0xa9 @ 1
[    7.982647] initcall nf_nat_sip_init+0x0/0xa9 returned 0 after 1 usecs
[    7.989180] calling  ip_tables_init+0x0/0xaa @ 1
[    7.993806] ip_tables: (C) 2000-2006 Netfilter Core Team
[    7.999120] initcall ip_tables_init+0x0/0xaa returned 0 after 5195 usecs
[    8.005820] calling  iptable_filter_init+0x0/0x6c @ 1
[    8.010889] initcall iptable_filter_init+0x0/0x6c returned 0 after 15 usecs
[    8.017848] calling  iptable_mangle_init+0x0/0x4e @ 1
[    8.022918] initcall iptable_mangle_init+0x0/0x4e returned 0 after 13 usecs
[    8.029879] calling  nf_nat_standalone_init+0x0/0x7d @ 1
[    8.035203] initcall nf_nat_standalone_init+0x0/0x7d returned 0 after 10 usecs
[    8.042428] calling  log_tg_init+0x0/0x29 @ 1
[    8.046790] initcall log_tg_init+0x0/0x29 returned 0 after 2 usecs
[    8.052975] calling  masquerade_tg_init+0x0/0x36 @ 1
[    8.057946] initcall masquerade_tg_init+0x0/0x36 returned 0 after 4 usecs
[    8.064733] calling  reject_tg_init+0x0/0x12 @ 1
[    8.069357] initcall reject_tg_init+0x0/0x12 returned 0 after 1 usecs
[    8.075801] calling  ulog_tg_init+0x0/0xc9 @ 1
[    8.080260] initcall ulog_tg_init+0x0/0xc9 returned 0 after 10 usecs
[    8.086619] calling  cubictcp_register+0x0/0x59 @ 1
[    8.091498] TCP cubic registered
[    8.094731] initcall cubictcp_register+0x0/0x59 returned 0 after 3157 usecs
[    8.101691] calling  xfrm_user_init+0x0/0x4a @ 1
[    8.106310] Initializing XFRM netlink socket
[    8.110585] initcall xfrm_user_init+0x0/0x4a returned 0 after 4173 usecs
[    8.117290] calling  inet6_init+0x0/0x2a2 @ 1
[    8.122045] NET: Registered protocol family 10
[    8.127743] initcall inet6_init+0x0/0x2a2 returned 0 after 5949 usecs
[    8.134207] calling  ah6_init+0x0/0x6d @ 1
[    8.138311] initcall ah6_init+0x0/0x6d returned 0 after 2 usecs
[    8.144234] calling  esp6_init+0x0/0x6d @ 1
[    8.148425] initcall esp6_init+0x0/0x6d returned 0 after 1 usecs
[    8.154435] calling  xfrm6_transport_init+0x0/0x17 @ 1
[    8.159578] initcall xfrm6_transport_init+0x0/0x17 returned 0 after 2 usecs
[    8.166544] calling  xfrm6_mode_tunnel_init+0x0/0x17 @ 1
[    8.171868] initcall xfrm6_mode_tunnel_init+0x0/0x17 returned 0 after 1 usecs
[    8.179014] calling  xfrm6_beet_init+0x0/0x17 @ 1
[    8.183724] initcall xfrm6_beet_init+0x0/0x17 returned 0 after 1 usecs
[    8.190255] calling  ip6_tables_init+0x0/0xaa @ 1
[    8.194969] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    8.200378] initcall ip6_tables_init+0x0/0xaa returned 0 after 5287 usecs
[    8.207164] calling  ip6table_filter_init+0x0/0x6c @ 1
[    8.212321] initcall ip6table_filter_init+0x0/0x6c returned 0 after 15 usecs
[    8.219369] calling  ip6table_mangle_init+0x0/0x4e @ 1
[    8.224533] initcall ip6table_mangle_init+0x0/0x4e returned 0 after 16 usecs
[    8.231589] calling  nf_conntrack_l3proto_ipv6_init+0x0/0xf9 @ 1
[    8.237622] initcall nf_conntrack_l3proto_ipv6_init+0x0/0xf9 returned 0 after 17 usecs
[    8.245541] calling  nf_defrag_init+0x0/0x51 @ 1
[    8.250189] initcall nf_defrag_init+0x0/0x51 returned 0 after 27 usecs
[    8.256719] calling  ipv6header_mt6_init+0x0/0x12 @ 1
[    8.261775] initcall ipv6header_mt6_init+0x0/0x12 returned 0 after 1 usecs
[    8.268654] calling  log_tg6_init+0x0/0x29 @ 1
[    8.273102] initcall log_tg6_init+0x0/0x29 returned 0 after 2 usecs
[    8.279373] calling  reject_tg6_init+0x0/0x12 @ 1
[    8.284082] initcall reject_tg6_init+0x0/0x12 returned 0 after 1 usecs
[    8.290614] calling  sit_init+0x0/0x5d @ 1
[    8.294715] IPv6 over IPv4 tunneling driver
[    8.299720] initcall sit_init+0x0/0x5d returned 0 after 4885 usecs
[    8.305909] calling  packet_init+0x0/0x44 @ 1
[    8.310275] NET: Registered protocol family 17
[    8.314732] initcall packet_init+0x0/0x44 returned 0 after 4352 usecs
[    8.321182] calling  init_rpcsec_gss+0x0/0x4a @ 1
[    8.325901] initcall init_rpcsec_gss+0x0/0x4a returned 0 after 10 usecs
[    8.332520] calling  init_dns_resolver+0x0/0xfe @ 1
[    8.337405] Registering the dns_resolver key type
[    8.342128] initcall init_dns_resolver+0x0/0xfe returned 0 after 4610 usecs
[    8.349092] calling  mcheck_debugfs_init+0x0/0x3b @ 1
[    8.354162] initcall mcheck_debugfs_init+0x0/0x3b returned 0 after 10 usecs
[    8.361127] calling  severities_debugfs_init+0x0/0x3b @ 1
[    8.366531] initcall severities_debugfs_init+0x0/0x3b returned 0 after 3 usecs
[    8.373754] calling  hpet_insert_resource+0x0/0x23 @ 1
[    8.378896] initcall hpet_insert_resource+0x0/0x23 returned 1 after 1 usecs
[    8.385861] initcall hpet_insert_resource+0x0/0x23 returned with error code 1 
[    8.393082] calling  update_mp_table+0x0/0x422 @ 1
[    8.397876] initcall update_mp_table+0x0/0x422 returned 0 after 1 usecs
[    8.404495] calling  lapic_insert_resource+0x0/0x3f @ 1
[    8.409727] initcall lapic_insert_resource+0x0/0x3f returned 0 after 4 usecs
[    8.416776] calling  io_apic_bug_finalize+0x0/0x1b @ 1
[    8.421918] initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 1 usecs
[    8.428882] calling  print_ICs+0x0/0x543 @ 1
[    8.433159] initcall print_ICs+0x0/0x543 returned 0 after 1 usecs
[    8.439257] calling  check_early_ioremap_leak+0x0/0x50 @ 1
[    8.444744] initcall check_early_ioremap_leak+0x0/0x50 returned 0 after 1 usecs
[    8.452058] calling  pat_memtype_list_init+0x0/0x32 @ 1
[    8.457288] initcall pat_memtype_list_init+0x0/0x32 returned 0 after 3 usecs
[    8.464338] calling  init_oops_id+0x0/0x40 @ 1
[    8.468787] initcall init_oops_id+0x0/0x40 returned 0 after 1 usecs
[    8.475059] calling  printk_late_init+0x0/0x56 @ 1
[    8.479856] initcall printk_late_init+0x0/0x56 returned 0 after 3 usecs
[    8.486473] calling  pm_qos_power_init+0x0/0xdc @ 1
[    8.491578] initcall pm_qos_power_init+0x0/0xdc returned 0 after 219 usecs
[    8.498463] calling  software_resume+0x0/0x210 @ 1
[    8.503262] PM: Hibernation image not present or could not be loaded.
[    8.509719] initcall software_resume+0x0/0x210 returned -2 after 6305 usecs
[    8.516685] initcall software_resume+0x0/0x210 returned with error code -2 
[    8.523646] calling  debugfs_kprobe_init+0x0/0x90 @ 1
[    8.528721] initcall debugfs_kprobe_init+0x0/0x90 returned 0 after 13 usecs
[    8.535684] calling  taskstats_init+0x0/0x95 @ 1
[    8.540319] registered taskstats version 1
[    8.544423] initcall taskstats_init+0x0/0x95 returned 0 after 4014 usecs
[    8.551126] calling  clear_boot_tracer+0x0/0x2d @ 1
[    8.556016] initcall clear_boot_tracer+0x0/0x2d returned 0 after 1 usecs
[    8.562723] calling  max_swapfiles_check+0x0/0x8 @ 1
[    8.567691] initcall max_swapfiles_check+0x0/0x8 returned 0 after 1 usecs
[    8.574483] calling  random32_reseed+0x0/0xa2 @ 1
[    8.579198] initcall random32_reseed+0x0/0xa2 returned 0 after 7 usecs
[    8.585732] calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
[    8.592013] initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 13 usecs
[    8.600187] calling  pci_sysfs_init+0x0/0x51 @ 1
[    8.605045] initcall pci_sysfs_init+0x0/0x51 returned 0 after 230 usecs
[    8.611664] calling  random_int_secret_init+0x0/0x19 @ 1
[    8.616994] initcall random_int_secret_init+0x0/0x19 returned 0 after 9 usecs
[    8.624136] calling  late_resume_init+0x0/0x1b0 @ 1
[    8.629021]   Magic number: 3:654:522
[    8.632770] initcall late_resume_init+0x0/0x1b0 returned 0 after 3659 usecs
[    8.639735] calling  scsi_complete_async_scans+0x0/0x140 @ 1
[    8.645396] initcall scsi_complete_async_scans+0x0/0x140 returned 0 after 1 usecs
[    8.652881] calling  init_netconsole+0x0/0x1ef @ 1
[    8.657680] console [netcon0] enabled
[    8.661347] netconsole: network logging started
[    8.665883] initcall init_netconsole+0x0/0x1ef returned 0 after 8014 usecs
[    8.672764] calling  acpi_cpufreq_init+0x0/0xa4 @ 1
[    8.677662] initcall acpi_cpufreq_init+0x0/0xa4 returned -5 after 18 usecs
[    8.684541] initcall acpi_cpufreq_init+0x0/0xa4 returned with error code -5 
[    8.691586] calling  memmap_init+0x0/0x35 @ 1
[    8.695978] initcall memmap_init+0x0/0x35 returned 0 after 30 usecs
[    8.702247] calling  pci_mmcfg_late_insert_resources+0x0/0x5b @ 1
[    8.708348] initcall pci_mmcfg_late_insert_resources+0x0/0x5b returned 0 after 2 usecs
[    8.716264] calling  net_secret_init+0x0/0x19 @ 1
[    8.720988] initcall net_secret_init+0x0/0x19 returned 0 after 10 usecs
[    8.727606] calling  tcp_congestion_default+0x0/0x12 @ 1
[    8.732932] initcall tcp_congestion_default+0x0/0x12 returned 0 after 2 usecs
[    8.740068] calling  ip_auto_config+0x0/0xe49 @ 1
[    8.744798] initcall ip_auto_config+0x0/0xe49 returned 0 after 16 usecs
[    8.751430] calling  initialize_hashrnd+0x0/0x19 @ 1
[    8.756405] initcall initialize_hashrnd+0x0/0x19 returned 0 after 4 usecs
[    8.763305] async_waiting @ 1
[    8.766291] async_continuing @ 1 after 2 usec
[    8.770680] md: Waiting for all devices to be available before autodetect
[    8.777475] md: If you don't use raid, use raid=noautodetect
[    8.783143] async_waiting @ 1
[    8.786116] async_continuing @ 1 after 1 usec
[    8.790754] md: Autodetecting RAID arrays.
[    8.794860] md: Scanned 0 and added 0 devices.
[    8.799313] md: autorun ...
[    8.802110] md: ... autorun DONE.
[    8.819408] EXT3-fs (sda6): recovery required on readonly filesystem
[    8.825766] EXT3-fs (sda6): write access will be enabled during recovery
[    8.848207] kjournald starting.  Commit interval 5 seconds
[    8.848248] EXT3-fs (sda6): recovery complete
[    8.858273] EXT3-fs (sda6): mounted filesystem with writeback data mode
[    8.864902] VFS: Mounted root (ext3 filesystem) readonly on device 8:6.
[    8.871524] async_waiting @ 1
[    8.874499] async_continuing @ 1 after 1 usec
[    8.880188] Freeing unused kernel memory: 644k freed
[    8.885488] Write protecting the kernel read-only data: 12288k
[    8.895234] Freeing unused kernel memory: 964k freed
[    8.907214] Freeing unused kernel memory: 1644k freed
[    9.321654] modprobe used greatest stack depth: 3520 bytes left
[   10.708451] udevd (1050): /proc/1050/oom_adj is deprecated, please use /proc/1050/oom_score_adj instead.
[   11.702516] 8139too 0000:05:07.0: eth1: link down
[   11.707478] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   20.741901] EXT3-fs (sda6): using internal journal
[   20.828996] kjournald starting.  Commit interval 5 seconds
[   20.829316] EXT3-fs (sda5): using internal journal
[   20.829322] EXT3-fs (sda5): mounted filesystem with writeback data mode
[   21.568268] Adding 3911820k swap on /dev/sda2.  Priority:-1 extents:1 across:3911820k 
[   22.402023] eth0: no IPv6 routers present
[   22.563405] warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
[   37.728078] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[   37.735139] ata1.00: failed command: READ DMA
[   37.739507] ata1.00: cmd c8/00:80:06:80:58/00:00:00:00:00/e5 tag 0 dma 65536 in
[   37.739508]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[   37.754204] ata1.00: status: { DRDY }
[   37.859029] ata1: soft resetting link
[   38.019572] ata1: nv_mode_filter: 0x3f39f&0x3f39f->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x3f01f (20:600:0x13)
[   38.038494] ata1.00: configured for UDMA/100
[   38.042778] ata1.00: device reported invalid CHS sector 0
[   38.048188] ata1: EH complete
[   48.736251] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[   48.743317] ata1.00: failed command: READ DMA
[   48.747687] ata1.00: cmd c8/00:80:06:80:58/00:00:00:00:00/e5 tag 0 dma 65536 in
[   48.747688]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[   48.762372] ata1.00: status: { DRDY }
[   48.766061] ata1: soft resetting link
[   48.926529] ata1: nv_mode_filter: 0x3f39f&0x3f39f->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x3f01f (20:600:0x13)
[   48.945454] ata1.00: configured for UDMA/100
[   48.949732] ata1.00: device reported invalid CHS sector 0
[   48.955140] ata1: EH complete
[   59.712073] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[   59.719165] ata1.00: failed command: READ DMA
[   59.723536] ata1.00: cmd c8/00:80:06:80:58/00:00:00:00:00/e5 tag 0 dma 65536 in
[   59.723537]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[   59.738231] ata1.00: status: { DRDY }
[   59.945022] ata1: soft resetting link
[   60.121561] ata1: nv_mode_filter: 0x3f39f&0x3f39f->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x3f01f (20:600:0x13)
[   60.140460] ata1.00: configured for UDMA/100
[   60.144739] ata1.00: device reported invalid CHS sector 0
[   60.150151] ata1: EH complete

--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.1.0 Kernel Configuration
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_FHANDLE is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y

#
# GCOV-based kernel profiling
#
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_INLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
CONFIG_INLINE_READ_UNLOCK=y
# CONFIG_INLINE_READ_UNLOCK_BH is not set
CONFIG_INLINE_READ_UNLOCK_IRQ=y
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
CONFIG_INLINE_WRITE_UNLOCK=y
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_KVMTOOL_TEST_ENABLE is not set
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=7
CONFIG_X86_CMPXCHG=y
CONFIG_CMPXCHG_LOCAL=y
CONFIG_CMPXCHG_DOUBLE=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=64
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CLEANCACHE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_IOV=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
CONFIG_NF_NAT_FTP=y
CONFIG_NF_NAT_IRC=y
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
CONFIG_NF_NAT_SIP=y
CONFIG_IP_NF_MANGLE=y

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=y
CONFIG_NF_CONNTRACK_IPV6=y
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
CONFIG_IP6_NF_TARGET_LOG=y
CONFIG_IP6_NF_FILTER=y
CONFIG_IP6_NF_TARGET_REJECT=y
CONFIG_IP6_NF_MANGLE=y
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_INGRESS is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_HAVE_BPF_JIT=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_CPQ_DA=y
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SCH=y
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_VIA=y
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
# CONFIG_MD_RAID1 is not set
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_DM_FLAKEY is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_MII=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
# CONFIG_TYPHOON is not set
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
# CONFIG_PCMCIA_XIRCOM is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_KSZ884X_PCI is not set
# CONFIG_B44 is not set
CONFIG_FORCEDETH=y
CONFIG_E100=y
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=y
CONFIG_E1000E=y
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
# CONFIG_SKGE_GENESIS is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_STMMAC_ETH is not set
# CONFIG_PCH_GBE is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
# CONFIG_ENIC is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGBEVF is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NIU is not set
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_BNA is not set
# CONFIG_SFC is not set
# CONFIG_BE2NET is not set
CONFIG_TR=y
# CONFIG_IBMOL is not set
# CONFIG_3C359 is not set
# CONFIG_TMS380TR is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_ATH_COMMON is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWLAGN is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_WL1251 is not set
# CONFIG_ZD1211RW is not set
# CONFIG_MWIFIEX is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_IPHETH is not set
CONFIG_NET_PCMCIA=y
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_FMVJ18X is not set
# CONFIG_PCMCIA_PCNET is not set
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_PCMCIA_AXNET is not set
# CONFIG_PCMCIA_IBMTR is not set
# CONFIG_WAN is not set

#
# CAIF transport drivers
#
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_VIA=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set
# CONFIG_I2C_EG20T is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ20Z75 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_CORE is not set
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set
CONFIG_MFD_SUPPORT=y
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_WMT_GE_ROPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
# CONFIG_SND_HDA_INPUT_JACK is not set
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_ENABLE_REALTEK_QUIRKS=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CA0132=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_UA101 is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_USB_6FIRE is not set
CONFIG_SND_PCMCIA=y
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWII_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=y
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_SUNPLUS=y
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
# CONFIG_EDAC_MCE_INJ is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=y
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_STATS=y
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
# CONFIG_IRQ_REMAP is not set
# CONFIG_VIRT_DRIVERS is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_SIGMA is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFS_USE_NEW_IDMAPPER is not set
# CONFIG_NFSD is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
# CONFIG_CEPH_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_BASE=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
# CONFIG_SECURITY_PATH is not set
# CONFIG_INTEL_TXT is not set
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_IMA is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_VHOST_NET is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_NLATTR=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set

--IS0zKkzwUGydFO0o--
