Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab1ELN3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:29:32 -0400
Received: from psionic.psi5.com ([212.112.229.180]:59229 "EHLO
	psionic8.psi5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab1ELN31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:29:27 -0400
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 May 2011 09:29:26 EDT
Date: Thu, 12 May 2011 10:10:36 +0200
From: Simon Richter <Simon.Richter@hogyros.de>
To: linux-kernel@vger.kernel.org
Subject: Nobody Cared / Disabling IRQ with Intel E1000 card
Message-ID: <20110512081035.GA2206@salmiakki.hogyros.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I have a server with two Intel E1000 and one Areca RAID card:

[...]
01:00.0 RAID bus controller [0104]: Areca Technology Corp. ARC-1231 12-Port PCI-Express to SATA RAID Controller [17d3:1280]
06:00.0 Ethernet controller [0200]: Intel Corporation 82541PI Gigabit Ethernet Controller [8086:107c] (rev 05)
06:02.0 Ethernet controller [0200]: Intel Corporation 82541PI Gigabit Ethernet Controller [8086:107c] (rev 05)
[...]

One of the Ethernet cards ends up sharing an IRQ with the RAID card,
which I already find suboptimal (will send a separate mail for that),
however the main issue currently is that some IRQs from the Ethernet
card trigger this:

[  315.481763] irq 16: nobody cared (try booting with the "irqpoll" option)
[  315.481773] Pid: 0, comm: swapper Not tainted 2.6.38-2-amd64 #1
[  315.481778] Call Trace:
[  315.481781]  <IRQ>  [<ffffffff810923e9>] ? __report_bad_irq+0x30/0x80
[  315.481796]  [<ffffffff81092560>] ? note_interrupt+0x127/0x19f
[  315.481804]  [<ffffffff8100f502>] ? read_tsc+0x5/0x16
[  315.481809]  [<ffffffff81092ef7>] ? handle_fasteoi_irq+0xb4/0xdf
[  315.481815]  [<ffffffff8100be54>] ? handle_irq+0x17/0x1f
[  315.481820]  [<ffffffff8100b50e>] ? do_IRQ+0x45/0xaa
[  315.481827]  [<ffffffff81327213>] ? ret_from_intr+0x0/0x15
[  315.481830]  <EOI>  [<ffffffff811f32fc>] ?  acpi_hw_read_multiple+0x28/0x60
[  315.481841]  [<ffffffff8100f4d5>] ? sched_clock+0x5/0x8
[  315.481854]  [<ffffffffa026efc7>] ? acpi_idle_enter_bm+0x259/0x291 [processor]
[  315.481862]  [<ffffffffa026efc0>] ? acpi_idle_enter_bm+0x252/0x291 [processor]
[  315.481870]  [<ffffffff81259f27>] ? cpuidle_idle_call+0x11f/0x1cc
[  315.481875]  [<ffffffff81008d93>] ? cpu_idle+0xab/0xe1
[  315.481881]  [<ffffffff8169ed70>] ? start_kernel+0x3dc/0x3e7
[  315.481886]  [<ffffffff8169e3cd>] ? x86_64_start_kernel+0x107/0x114
[  315.481890] handlers:
[  315.481893] [<ffffffffa01b50b5>] (arcmsr_do_interrupt+0x0/0xe [arcmsr])
[  315.481905] [<ffffffffa01bcee5>] (e1000_intr+0x0/0x100 [e1000])
[  315.481915] Disabling IRQ #16

Afterwards, both RAID and network card are rather slow. The problem
seems to be in the Ethernet card, as, after some time:

[28536.149807] irq 18: nobody cared (try booting with the "irqpoll" option)
[28536.149812] Pid: 0, comm: swapper Not tainted 2.6.38-2-amd64 #1
[28536.149814] Call Trace:
[28536.149816]  <IRQ>  [<ffffffff810923e9>] ? __report_bad_irq+0x30/0x80
[28536.149824]  [<ffffffff81092560>] ? note_interrupt+0x127/0x19f
[28536.149828]  [<ffffffff81092ef7>] ? handle_fasteoi_irq+0xb4/0xdf
[28536.149832]  [<ffffffff8100be54>] ? handle_irq+0x17/0x1f
[28536.149834]  [<ffffffff8100b50e>] ? do_IRQ+0x45/0xaa
[28536.149838]  [<ffffffff81327213>] ? ret_from_intr+0x0/0x15
[28536.149842]  [<ffffffff8100f502>] ? read_tsc+0x5/0x16
[28536.149846]  [<ffffffff8104c7cd>] ? __do_softirq+0x55/0x1a0
[28536.149848]  [<ffffffff8100a85c>] ? call_softirq+0x1c/0x30
[28536.149851]  [<ffffffff8100be03>] ? do_softirq+0x3f/0x79
[28536.149854]  [<ffffffff8104c6dd>] ? irq_exit+0x36/0x7b
[28536.149856]  [<ffffffff8100b55d>] ? do_IRQ+0x94/0xaa
[28536.149859]  [<ffffffff81327213>] ? ret_from_intr+0x0/0x15
[28536.149861]  <EOI>  [<ffffffff811f32fc>] ?  acpi_hw_read_multiple+0x28/0x60
[28536.149867]  [<ffffffff8100f4d5>] ? sched_clock+0x5/0x8
[28536.149875]  [<ffffffffa026efc7>] ? acpi_idle_enter_bm+0x259/0x291 [processor]
[28536.149879]  [<ffffffffa026efc0>] ? acpi_idle_enter_bm+0x252/0x291 [processor]
[28536.149883]  [<ffffffff81259f27>] ? cpuidle_idle_call+0x11f/0x1cc
[28536.149886]  [<ffffffff81008d93>] ? cpu_idle+0xab/0xe1
[28536.149889]  [<ffffffff8169ed70>] ? start_kernel+0x3dc/0x3e7
[28536.149892]  [<ffffffff8169e3cd>] ? x86_64_start_kernel+0x107/0x114
[28536.149894] handlers:
[28536.149895] [<ffffffffa01bcee5>] (e1000_intr+0x0/0x100 [e1000])
[28536.149903] Disabling IRQ #18

/proc/interrupts has

 16:     302272          0          0          0   IO-APIC-fasteoi arcmsr, eth0
 18:    1700001          0          0          0   IO-APIC-fasteoi eth1

which I find curious, as all the IRQs seem to be handled by the first
core.

/proc/cmdline is

BOOT_IMAGE=/vmlinuz-2.6.38-2-amd64 root=/dev/mapper/kiwi-root ro irqpoll

that is, I have already set the "irqpoll" option.

A wild guess would be that the IRQ, which is level-triggered, is not
cleared fast enough and triggered again, but there is no work to be done
during the second run, so this is flagged as a spurious IRQ.

Is there anything I can do to get rid of this problem?

   Simon

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38-2-amd64 (Debian 2.6.38-5) (ben@decadent.org.uk) (gcc version 4.4.6 (Debian 4.4.6-3) ) #1 SMP Sun May 8 13:51:57 UTC 2011
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.38-2-amd64 root=/dev/mapper/kiwi-root ro irqpoll
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000df422000 (usable)
[    0.000000]  BIOS-e820: 00000000df422000 - 00000000df476000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df476000 - 00000000df5a9000 (reserved)
[    0.000000]  BIOS-e820: 00000000df5a9000 - 00000000df5ba000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df5ba000 - 00000000df5d1000 (reserved)
[    0.000000]  BIOS-e820: 00000000df5d1000 - 00000000df5d3000 (usable)
[    0.000000]  BIOS-e820: 00000000df5d3000 - 00000000df5d4000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df5d4000 - 00000000df5dc000 (reserved)
[    0.000000]  BIOS-e820: 00000000df5dc000 - 00000000df5e6000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df5e6000 - 00000000df642000 (reserved)
[    0.000000]  BIOS-e820: 00000000df642000 - 00000000df685000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df685000 - 00000000df800000 (usable)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000021f800000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: System manufacturer System Product Name/P8P67 LE, BIOS 1011 04/08/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x21f800 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C3FFF write-protect
[    0.000000]   C4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FE0000000 write-back
[    0.000000]   2 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   3 base 21F800000 mask FFF800000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000e0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdf800 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fce90] fce90
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000df800000
[    0.000000]  0000000000 - 00df800000 page 2M
[    0.000000] kernel direct mapping tables up to df800000 @ 1fffb000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000021f800000
[    0.000000]  0100000000 - 021f800000 page 2M
[    0.000000] kernel direct mapping tables up to 21f800000 @ df7f6000-df800000
[    0.000000] RAMDISK: 374ba000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f0420 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000df46d068 0004C (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000df474df8 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000df46d140 07CB7 (v02 ALASKA    A M I 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000df5ddf80 00040
[    0.000000] ACPI: APIC 00000000df474ef0 00072 (v03 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000df474f68 00102 (v01 AMICPU     PROC 00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 00000000df475070 0003C (v01 ALASKA    A M I 01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000df4750b0 00038 (v01 ALASKA    A M I 01072009 AMI. 00000004)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000021f800000
[    0.000000] Initmem setup node 0 0000000000000000-000000021f800000
[    0.000000]   NODE_DATA [000000021f7fb000 - 000000021f7fffff]
[    0.000000]  [ffffea0000000000-ffffea00077fffff] PMD -> [ffff880217600000-ffff88021e7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0021f800
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000df422
[    0.000000]     0: 0x000df5d1 -> 0x000df5d3
[    0.000000]     0: 0x000df685 -> 0x000df800
[    0.000000]     0: 0x00100000 -> 0x0021f800
[    0.000000] On node 0 totalpages: 2092333
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3920 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 896471 pages, LIFO batch:31
[    0.000000]   Normal zone: 16100 pages used for memmap
[    0.000000]   Normal zone: 1161500 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000df422000 - 00000000df476000
[    0.000000] PM: Registered nosave memory: 00000000df476000 - 00000000df5a9000
[    0.000000] PM: Registered nosave memory: 00000000df5a9000 - 00000000df5ba000
[    0.000000] PM: Registered nosave memory: 00000000df5ba000 - 00000000df5d1000
[    0.000000] PM: Registered nosave memory: 00000000df5d3000 - 00000000df5d4000
[    0.000000] PM: Registered nosave memory: 00000000df5d4000 - 00000000df5dc000
[    0.000000] PM: Registered nosave memory: 00000000df5dc000 - 00000000df5e6000
[    0.000000] PM: Registered nosave memory: 00000000df5e6000 - 00000000df642000
[    0.000000] PM: Registered nosave memory: 00000000df642000 - 00000000df685000
[    0.000000] PM: Registered nosave memory: 00000000df800000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at df800000 (gap: df800000:1f51c000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff8800df000000 s82752 r8192 d23744 u524288
[    0.000000] pcpu-alloc: s82752 r8192 d23744 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2061891
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.38-2-amd64 root=/dev/mapper/kiwi-root ro irqpoll
[    0.000000] Misrouted IRQ fixup and polling support enabled
[    0.000000] This may significantly impact system performance
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 8166028k/8904704k available (3260k kernel code, 535372k absent, 203304k reserved, 3425k data, 676k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 3110.078 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 6220.15 BogoMIPS (lpj=12440312)
[    0.000006] pid_max: default: 32768 minimum: 301
[    0.000022] Security Framework initialized
[    0.000025] SELinux:  Disabled at boot.
[    0.000518] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.001828] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.002369] Mount-cache hash table entries: 256
[    0.002450] Initializing cgroup subsys ns
[    0.002453] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.002456] Initializing cgroup subsys cpuacct
[    0.002460] Initializing cgroup subsys devices
[    0.002462] Initializing cgroup subsys freezer
[    0.002464] Initializing cgroup subsys net_cls
[    0.002466] Initializing cgroup subsys blkio
[    0.002487] CPU: Physical Processor ID: 0
[    0.002489] CPU: Processor Core ID: 0
[    0.002494] mce: CPU supports 7 MCE banks
[    0.002503] CPU0: Thermal monitoring enabled (TM1)
[    0.002509] using mwait in idle threads.
[    0.003302] ACPI: Core revision 20110112
[    0.013396] Setting APIC routing to flat
[    0.013723] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.053376] CPU0: Intel(R) Core(TM) i3-2100 CPU @ 3.10GHz stepping 07
[    0.160264] Performance Events: PEBS fmt1+, generic architected perfmon, Intel PMU driver.
[    0.160270] ... version:                3
[    0.160271] ... bit width:              48
[    0.160273] ... generic registers:      4
[    0.160275] ... value mask:             0000ffffffffffff
[    0.160277] ... max period:             000000007fffffff
[    0.160278] ... fixed-purpose events:   3
[    0.160280] ... event mask:             000000070000000f
[    0.160360] NMI watchdog enabled, takes one hw-pmu counter.
[    0.160410] Booting Node   0, Processors  #1
[    0.268239] NMI watchdog enabled, takes one hw-pmu counter.
[    0.268295]  #2
[    0.376177] NMI watchdog enabled, takes one hw-pmu counter.
[    0.376238]  #3 Ok.
[    0.484064] NMI watchdog enabled, takes one hw-pmu counter.
[    0.484090] Brought up 4 CPUs
[    0.484092] Total of 4 processors activated (24880.54 BogoMIPS).
[    0.485803] devtmpfs: initialized
[    0.488213] print_constraints: dummy: 
[    0.488238] NET: Registered protocol family 16
[    0.488295] ACPI: bus type pci registered
[    0.488349] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.488353] PCI: not using MMCONFIG
[    0.488355] PCI: Using configuration type 1 for base access
[    0.488681] bio: create slab <bio-0> at 0
[    0.489353] ACPI: EC: Look up EC in DSDT
[    0.489922] ACPI: Executed 1 blocks of module-level executable AML code
[    0.491789] ACPI Error: [RAMB] Namespace lookup failure, AE_NOT_FOUND (20110112/psargs-359)
[    0.491795] ACPI Exception: AE_NOT_FOUND, Could not execute arguments for [RAMW] (Region) (20110112/nsinit-349)
[    0.492013] ACPI: SSDT 00000000df5dcc18 0038C (v01    AMI      IST 00000001 MSFT 03000001)
[    0.492207] ACPI: Dynamic OEM Table Load:
[    0.492209] ACPI: SSDT           (null) 0038C (v01    AMI      IST 00000001 MSFT 03000001)
[    0.492236] ACPI: SSDT 00000000df5dde18 00084 (v01    AMI      CST 00000001 MSFT 03000001)
[    0.492382] ACPI: Dynamic OEM Table Load:
[    0.492384] ACPI: SSDT           (null) 00084 (v01    AMI      CST 00000001 MSFT 03000001)
[    0.492717] ACPI: Interpreter enabled
[    0.492720] ACPI: (supports S0 S1 S3 S4 S5)
[    0.492735] ACPI: Using IOAPIC for interrupt routing
[    0.492751] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.492805] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in ACPI motherboard resources
[    0.498016] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.501303] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.501393] ACPI: No dock devices found.
[    0.501395] HEST: Table not found.
[    0.501397] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.501536] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.501699] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.501701] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.501704] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.501707] pci_root PNP0A08:00: host bridge window [mem 0x000c8000-0x000dffff]
[    0.501709] pci_root PNP0A08:00: host bridge window [mem 0xfe000000-0xfeffffff]
[    0.501718] pci 0000:00:00.0: [8086:0100] type 0 class 0x000600
[    0.501743] pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
[    0.501761] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.501763] pci 0000:00:01.0: PME# disabled
[    0.501799] pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
[    0.501820] pci 0000:00:16.0: reg 10: [mem 0xfe708000-0xfe70800f 64bit]
[    0.501876] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.501879] pci 0000:00:16.0: PME# disabled
[    0.501907] pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
[    0.501926] pci 0000:00:1a.0: reg 10: [mem 0xfe707000-0xfe7073ff]
[    0.501993] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.501996] pci 0000:00:1a.0: PME# disabled
[    0.502016] pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
[    0.502029] pci 0000:00:1b.0: reg 10: [mem 0xfe700000-0xfe703fff 64bit]
[    0.502079] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.502081] pci 0000:00:1b.0: PME# disabled
[    0.502099] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
[    0.502157] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.502160] pci 0000:00:1c.0: PME# disabled
[    0.502180] pci 0000:00:1c.2: [8086:1c14] type 1 class 0x000604
[    0.502237] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.502240] pci 0000:00:1c.2: PME# disabled
[    0.502259] pci 0000:00:1c.3: [8086:1c16] type 1 class 0x000604
[    0.502317] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.502320] pci 0000:00:1c.3: PME# disabled
[    0.502339] pci 0000:00:1c.4: [8086:244e] type 1 class 0x000604
[    0.502396] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.502399] pci 0000:00:1c.4: PME# disabled
[    0.502418] pci 0000:00:1c.5: [8086:1c1a] type 1 class 0x000604
[    0.502475] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.502478] pci 0000:00:1c.5: PME# disabled
[    0.502498] pci 0000:00:1c.6: [8086:1c1c] type 1 class 0x000604
[    0.502555] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.502558] pci 0000:00:1c.6: PME# disabled
[    0.502577] pci 0000:00:1c.7: [8086:1c1e] type 1 class 0x000604
[    0.502634] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.502637] pci 0000:00:1c.7: PME# disabled
[    0.502661] pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
[    0.502680] pci 0000:00:1d.0: reg 10: [mem 0xfe706000-0xfe7063ff]
[    0.502747] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.502750] pci 0000:00:1d.0: PME# disabled
[    0.502771] pci 0000:00:1f.0: [8086:1c46] type 0 class 0x000601
[    0.502877] pci 0000:00:1f.2: [8086:1c02] type 0 class 0x000106
[    0.502893] pci 0000:00:1f.2: reg 10: [io  0xf070-0xf077]
[    0.502900] pci 0000:00:1f.2: reg 14: [io  0xf060-0xf063]
[    0.502907] pci 0000:00:1f.2: reg 18: [io  0xf050-0xf057]
[    0.502914] pci 0000:00:1f.2: reg 1c: [io  0xf040-0xf043]
[    0.502921] pci 0000:00:1f.2: reg 20: [io  0xf020-0xf03f]
[    0.502928] pci 0000:00:1f.2: reg 24: [mem 0xfe705000-0xfe7057ff]
[    0.502957] pci 0000:00:1f.2: PME# supported from D3hot
[    0.502960] pci 0000:00:1f.2: PME# disabled
[    0.502973] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
[    0.502987] pci 0000:00:1f.3: reg 10: [mem 0xfe704000-0xfe7040ff 64bit]
[    0.503005] pci 0000:00:1f.3: reg 20: [io  0xf000-0xf01f]
[    0.503051] pci 0000:01:00.0: [17d3:1280] type 0 class 0x000104
[    0.503060] pci 0000:01:00.0: reg 10: [mem 0xfe610000-0xfe611fff]
[    0.503093] pci 0000:01:00.0: reg 30: [mem 0xfe600000-0xfe60ffff pref]
[    0.503110] pci 0000:01:00.0: supports D1
[    0.508007] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.508013] pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.508017] pci 0000:00:01.0:   bridge window [mem 0xfe600000-0xfe6fffff]
[    0.508022] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.508075] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.508089] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.508092] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.508098] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.508138] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.508142] pci 0000:00:1c.2:   bridge window [io  0xf000-0x0000] (disabled)
[    0.508146] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.508151] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.508192] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.508196] pci 0000:00:1c.3:   bridge window [io  0xf000-0x0000] (disabled)
[    0.508199] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.508204] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.508259] pci 0000:05:00.0: [1b21:1080] type 1 class 0x000604
[    0.508361] pci 0000:00:1c.4: PCI bridge to [bus 05-06] (subtractive decode)
[    0.508366] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.508369] pci 0000:00:1c.4:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.508374] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.508376] pci 0000:00:1c.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.508377] pci 0000:00:1c.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.508379] pci 0000:00:1c.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.508380] pci 0000:00:1c.4:   bridge window [mem 0x000c8000-0x000dffff] (subtractive decode)
[    0.508382] pci 0000:00:1c.4:   bridge window [mem 0xfe000000-0xfeffffff] (subtractive decode)
[    0.508442] pci 0000:06:00.0: [8086:107c] type 0 class 0x000200
[    0.508477] pci 0000:06:00.0: reg 10: [mem 0xfe5a0000-0xfe5bffff]
[    0.508494] pci 0000:06:00.0: reg 14: [mem 0xfe580000-0xfe59ffff]
[    0.508510] pci 0000:06:00.0: reg 18: [io  0xe0c0-0xe0ff]
[    0.508574] pci 0000:06:00.0: reg 30: [mem 0xfe560000-0xfe57ffff pref]
[    0.508613] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.508619] pci 0000:06:00.0: PME# disabled
[    0.508657] pci 0000:06:02.0: [8086:107c] type 0 class 0x000200
[    0.508691] pci 0000:06:02.0: reg 10: [mem 0xfe540000-0xfe55ffff]
[    0.508708] pci 0000:06:02.0: reg 14: [mem 0xfe520000-0xfe53ffff]
[    0.508725] pci 0000:06:02.0: reg 18: [io  0xe080-0xe0bf]
[    0.508788] pci 0000:06:02.0: reg 30: [mem 0xfe500000-0xfe51ffff pref]
[    0.508827] pci 0000:06:02.0: PME# supported from D0 D3hot D3cold
[    0.508833] pci 0000:06:02.0: PME# disabled
[    0.508864] pci 0000:06:03.0: [1106:3044] type 0 class 0x000c00
[    0.508894] pci 0000:06:03.0: reg 10: [mem 0xfe5c0000-0xfe5c07ff]
[    0.508911] pci 0000:06:03.0: reg 14: [io  0xe000-0xe07f]
[    0.509021] pci 0000:06:03.0: supports D2
[    0.509022] pci 0000:06:03.0: PME# supported from D2 D3hot D3cold
[    0.509028] pci 0000:06:03.0: PME# disabled
[    0.509100] pci 0000:05:00.0: PCI bridge to [bus 06-06] (subtractive decode)
[    0.509111] pci 0000:05:00.0:   bridge window [io  0xe000-0xefff]
[    0.509116] pci 0000:05:00.0:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.509125] pci 0000:05:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.509126] pci 0000:05:00.0:   bridge window [io  0xe000-0xefff] (subtractive decode)
[    0.509128] pci 0000:05:00.0:   bridge window [mem 0xfe500000-0xfe5fffff] (subtractive decode)
[    0.509130] pci 0000:05:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.509131] pci 0000:05:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.509133] pci 0000:05:00.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.509134] pci 0000:05:00.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.509136] pci 0000:05:00.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.509137] pci 0000:05:00.0:   bridge window [mem 0x000c8000-0x000dffff] (subtractive decode)
[    0.509139] pci 0000:05:00.0:   bridge window [mem 0xfe000000-0xfeffffff] (subtractive decode)
[    0.509210] pci 0000:07:00.0: [10ec:8168] type 0 class 0x000200
[    0.509228] pci 0000:07:00.0: reg 10: [io  0xd000-0xd0ff]
[    0.509261] pci 0000:07:00.0: reg 18: [mem 0xfef04000-0xfef04fff 64bit pref]
[    0.509282] pci 0000:07:00.0: reg 20: [mem 0xfef00000-0xfef03fff 64bit pref]
[    0.509339] pci 0000:07:00.0: supports D1 D2
[    0.509340] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.509345] pci 0000:07:00.0: PME# disabled
[    0.516006] pci 0000:00:1c.5: PCI bridge to [bus 07-07]
[    0.516012] pci 0000:00:1c.5:   bridge window [io  0xd000-0xdfff]
[    0.516017] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.516025] pci 0000:00:1c.5:   bridge window [mem 0xfef00000-0xfeffffff 64bit pref]
[    0.516100] pci 0000:08:00.0: [1b4b:91a0] type 0 class 0x000101
[    0.516117] pci 0000:08:00.0: reg 10: [io  0xc090-0xc097]
[    0.516128] pci 0000:08:00.0: reg 14: [io  0xc080-0xc083]
[    0.516140] pci 0000:08:00.0: reg 18: [io  0xc070-0xc077]
[    0.516152] pci 0000:08:00.0: reg 1c: [io  0xc060-0xc063]
[    0.516164] pci 0000:08:00.0: reg 20: [io  0xc050-0xc05f]
[    0.516175] pci 0000:08:00.0: reg 24: [mem 0xfe415000-0xfe4157ff]
[    0.516187] pci 0000:08:00.0: reg 30: [mem 0xfe400000-0xfe40ffff pref]
[    0.516222] pci 0000:08:00.0: PME# supported from D3hot
[    0.516226] pci 0000:08:00.0: PME# disabled
[    0.516260] pci 0000:08:00.1: [1b4b:91a4] type 0 class 0x000101
[    0.516276] pci 0000:08:00.1: reg 10: [io  0xc040-0xc047]
[    0.516288] pci 0000:08:00.1: reg 14: [io  0xc030-0xc033]
[    0.516299] pci 0000:08:00.1: reg 18: [io  0xc020-0xc027]
[    0.516311] pci 0000:08:00.1: reg 1c: [io  0xc010-0xc013]
[    0.516323] pci 0000:08:00.1: reg 20: [io  0xc000-0xc00f]
[    0.516334] pci 0000:08:00.1: reg 24: [mem 0xfe414000-0xfe41400f]
[    0.516346] pci 0000:08:00.1: reg 30: [mem 0xfe410000-0xfe413fff pref]
[    0.516380] pci 0000:08:00.1: PME# supported from D3hot
[    0.516385] pci 0000:08:00.1: PME# disabled
[    0.523997] pci 0000:00:1c.6: PCI bridge to [bus 08-08]
[    0.524004] pci 0000:00:1c.6:   bridge window [io  0xc000-0xcfff]
[    0.524009] pci 0000:00:1c.6:   bridge window [mem 0xfe400000-0xfe4fffff]
[    0.524016] pci 0000:00:1c.6:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.524100] pci 0000:09:00.0: [1b21:1042] type 0 class 0x000c03
[    0.524127] pci 0000:09:00.0: reg 10: [mem 0xfe300000-0xfe307fff 64bit]
[    0.524248] pci 0000:09:00.0: PME# supported from D3hot D3cold
[    0.524252] pci 0000:09:00.0: PME# disabled
[    0.531991] pci 0000:00:1c.7: PCI bridge to [bus 09-09]
[    0.531997] pci 0000:00:1c.7:   bridge window [io  0xf000-0x0000] (disabled)
[    0.532002] pci 0000:00:1c.7:   bridge window [mem 0xfe300000-0xfe3fffff]
[    0.532010] pci 0000:00:1c.7:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.532052] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.532143] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.532165] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.532186] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.532206] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.532225] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.532246] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4.BR16._PRT]
[    0.532290] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
[    0.532310] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX6._PRT]
[    0.532329] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX7._PRT]
[    0.532412]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.532566]  pci0000:00: ACPI _OSC control (0x1c) granted
[    0.535371] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.535402] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.535431] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.535460] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.535489] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.535518] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.535547] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.535576] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.535641] vgaarb: loaded
[    0.535660] PCI: Using ACPI for IRQ routing
[    0.535663] PCI: pci_cache_line_size set to 64 bytes
[    0.535744] reserve RAM buffer: 000000000009e800 - 000000000009ffff 
[    0.535745] reserve RAM buffer: 00000000df422000 - 00000000dfffffff 
[    0.535748] reserve RAM buffer: 00000000df5d3000 - 00000000dfffffff 
[    0.535750] reserve RAM buffer: 00000000df800000 - 00000000dfffffff 
[    0.535752] reserve RAM buffer: 000000021f800000 - 000000021fffffff 
[    0.535816] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.535821] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.537836] Switching to clocksource hpet
[    0.538542] pnp: PnP ACPI init
[    0.538553] ACPI: bus type pnp registered
[    0.538642] pnp 00:00: [bus 00-ff]
[    0.538644] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.538645] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.538647] pnp 00:00: [io  0x0d00-0xffff window]
[    0.538648] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.538649] pnp 00:00: [mem 0x000c8000-0x000dffff window]
[    0.538651] pnp 00:00: [mem 0xfe000000-0xfeffffff window]
[    0.538652] pnp 00:00: [mem 0x00000000 window]
[    0.538682] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.538720] pnp 00:01: [mem 0xfed10000-0xfed19fff]
[    0.538721] pnp 00:01: [mem 0xe0000000-0xe3ffffff]
[    0.538722] pnp 00:01: [mem 0xfed90000-0xfed93fff]
[    0.538724] pnp 00:01: [mem 0xfed20000-0xfed3ffff]
[    0.538725] pnp 00:01: [mem 0xfee00000-0xfee0ffff]
[    0.538753] system 00:01: [mem 0xfed10000-0xfed19fff] has been reserved
[    0.538756] system 00:01: [mem 0xe0000000-0xe3ffffff] has been reserved
[    0.538758] system 00:01: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.538761] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.538763] system 00:01: [mem 0xfee00000-0xfee0ffff] has been reserved
[    0.538766] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.538809] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.538810] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.538812] pnp 00:02: [io  0x0290-0x029f]
[    0.538813] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.538840] system 00:02: [io  0x0290-0x029f] has been reserved
[    0.538843] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.538851] pnp 00:03: [dma 4]
[    0.538852] pnp 00:03: [io  0x0000-0x000f]
[    0.538853] pnp 00:03: [io  0x0081-0x0083]
[    0.538854] pnp 00:03: [io  0x0087]
[    0.538855] pnp 00:03: [io  0x0089-0x008b]
[    0.538856] pnp 00:03: [io  0x008f]
[    0.538857] pnp 00:03: [io  0x00c0-0x00df]
[    0.538872] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.538877] pnp 00:04: [io  0x0070-0x0071]
[    0.538883] pnp 00:04: [irq 8]
[    0.538899] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.538903] pnp 00:05: [io  0x0061]
[    0.538918] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.538928] pnp 00:06: [io  0x0010-0x001f]
[    0.538929] pnp 00:06: [io  0x0022-0x003f]
[    0.538930] pnp 00:06: [io  0x0044-0x005f]
[    0.538931] pnp 00:06: [io  0x0063]
[    0.538932] pnp 00:06: [io  0x0065]
[    0.538933] pnp 00:06: [io  0x0067-0x006f]
[    0.538934] pnp 00:06: [io  0x0072-0x007f]
[    0.538935] pnp 00:06: [io  0x0080]
[    0.538936] pnp 00:06: [io  0x0084-0x0086]
[    0.538937] pnp 00:06: [io  0x0088]
[    0.538938] pnp 00:06: [io  0x008c-0x008e]
[    0.538939] pnp 00:06: [io  0x0090-0x009f]
[    0.538940] pnp 00:06: [io  0x00a2-0x00bf]
[    0.538941] pnp 00:06: [io  0x00e0-0x00ef]
[    0.538942] pnp 00:06: [io  0x04d0-0x04d1]
[    0.538975] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.538978] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.538983] pnp 00:07: [io  0x00f0-0x00ff]
[    0.538987] pnp 00:07: [irq 13]
[    0.539002] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.539188] pnp 00:08: [io  0x03f8-0x03ff]
[    0.539192] pnp 00:08: [irq 4]
[    0.539193] pnp 00:08: [dma 0 disabled]
[    0.539226] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.539317] pnp 00:09: [io  0x0400-0x0453]
[    0.539318] pnp 00:09: [io  0x0458-0x047f]
[    0.539319] pnp 00:09: [io  0x0000-0xffffffffffffffff disabled]
[    0.539320] pnp 00:09: [io  0x0500-0x057f]
[    0.539322] pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
[    0.539323] pnp 00:09: [mem 0xfec00000-0xfecfffff]
[    0.539324] pnp 00:09: [mem 0xfed08000-0xfed08fff]
[    0.539325] pnp 00:09: [mem 0xff000000-0xffffffff]
[    0.539355] system 00:09: [io  0x0400-0x0453] has been reserved
[    0.539357] system 00:09: [io  0x0458-0x047f] has been reserved
[    0.539360] system 00:09: [io  0x0500-0x057f] has been reserved
[    0.539363] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.539365] system 00:09: [mem 0xfec00000-0xfecfffff] could not be reserved
[    0.539368] system 00:09: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.539371] system 00:09: [mem 0xff000000-0xffffffff] has been reserved
[    0.539373] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.539398] pnp 00:0a: [io  0x0454-0x0457]
[    0.539425] system 00:0a: [io  0x0454-0x0457] has been reserved
[    0.539428] system 00:0a: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.539493] pnp 00:0b: [mem 0xfed00000-0xfed003ff]
[    0.539517] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.539607] pnp: PnP ACPI: found 12 devices
[    0.539609] ACPI: ACPI bus type pnp unregistered
[    0.539978] Switched to NOHz mode on CPU #0
[    0.540018] Switched to NOHz mode on CPU #3
[    0.540026] Switched to NOHz mode on CPU #1
[    0.540047] Switched to NOHz mode on CPU #2
[    0.545294] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.545296] pci 0000:00:01.0:   bridge window [io  disabled]
[    0.545300] pci 0000:00:01.0:   bridge window [mem 0xfe600000-0xfe6fffff]
[    0.545302] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    0.545306] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.545308] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.545312] pci 0000:00:1c.0:   bridge window [mem disabled]
[    0.545316] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.545322] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.545324] pci 0000:00:1c.2:   bridge window [io  disabled]
[    0.545329] pci 0000:00:1c.2:   bridge window [mem disabled]
[    0.545332] pci 0000:00:1c.2:   bridge window [mem pref disabled]
[    0.545338] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.545340] pci 0000:00:1c.3:   bridge window [io  disabled]
[    0.545345] pci 0000:00:1c.3:   bridge window [mem disabled]
[    0.545349] pci 0000:00:1c.3:   bridge window [mem pref disabled]
[    0.545355] pci 0000:05:00.0: PCI bridge to [bus 06-06]
[    0.545359] pci 0000:05:00.0:   bridge window [io  0xe000-0xefff]
[    0.545367] pci 0000:05:00.0:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.545373] pci 0000:05:00.0:   bridge window [mem pref disabled]
[    0.545383] pci 0000:00:1c.4: PCI bridge to [bus 05-06]
[    0.545386] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.545391] pci 0000:00:1c.4:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.545395] pci 0000:00:1c.4:   bridge window [mem pref disabled]
[    0.545401] pci 0000:00:1c.5: PCI bridge to [bus 07-07]
[    0.545404] pci 0000:00:1c.5:   bridge window [io  0xd000-0xdfff]
[    0.545409] pci 0000:00:1c.5:   bridge window [mem disabled]
[    0.545413] pci 0000:00:1c.5:   bridge window [mem 0xfef00000-0xfeffffff 64bit pref]
[    0.545419] pci 0000:00:1c.6: PCI bridge to [bus 08-08]
[    0.545422] pci 0000:00:1c.6:   bridge window [io  0xc000-0xcfff]
[    0.545427] pci 0000:00:1c.6:   bridge window [mem 0xfe400000-0xfe4fffff]
[    0.545431] pci 0000:00:1c.6:   bridge window [mem pref disabled]
[    0.545437] pci 0000:00:1c.7: PCI bridge to [bus 09-09]
[    0.545439] pci 0000:00:1c.7:   bridge window [io  disabled]
[    0.545444] pci 0000:00:1c.7:   bridge window [mem 0xfe300000-0xfe3fffff]
[    0.545448] pci 0000:00:1c.7:   bridge window [mem pref disabled]
[    0.545462] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.545465] pci 0000:00:01.0: setting latency timer to 64
[    0.545471] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.545475] pci 0000:00:1c.0: setting latency timer to 64
[    0.545482] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.545486] pci 0000:00:1c.2: setting latency timer to 64
[    0.545492] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.545496] pci 0000:00:1c.3: setting latency timer to 64
[    0.545501] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.545505] pci 0000:00:1c.4: setting latency timer to 64
[    0.545510] pci 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.545516] pci 0000:05:00.0: setting latency timer to 64
[    0.545521] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.545526] pci 0000:00:1c.5: setting latency timer to 64
[    0.545530] pci 0000:00:1c.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.545534] pci 0000:00:1c.6: setting latency timer to 64
[    0.545539] pci 0000:00:1c.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.545543] pci 0000:00:1c.7: setting latency timer to 64
[    0.545545] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.545547] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.545548] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.545549] pci_bus 0000:00: resource 7 [mem 0x000c8000-0x000dffff]
[    0.545551] pci_bus 0000:00: resource 8 [mem 0xfe000000-0xfeffffff]
[    0.545552] pci_bus 0000:01: resource 1 [mem 0xfe600000-0xfe6fffff]
[    0.545554] pci_bus 0000:05: resource 0 [io  0xe000-0xefff]
[    0.545555] pci_bus 0000:05: resource 1 [mem 0xfe500000-0xfe5fffff]
[    0.545556] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    0.545557] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    0.545559] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    0.545560] pci_bus 0000:05: resource 7 [mem 0x000c8000-0x000dffff]
[    0.545561] pci_bus 0000:05: resource 8 [mem 0xfe000000-0xfeffffff]
[    0.545563] pci_bus 0000:06: resource 0 [io  0xe000-0xefff]
[    0.545564] pci_bus 0000:06: resource 1 [mem 0xfe500000-0xfe5fffff]
[    0.545565] pci_bus 0000:06: resource 4 [io  0xe000-0xefff]
[    0.545566] pci_bus 0000:06: resource 5 [mem 0xfe500000-0xfe5fffff]
[    0.545568] pci_bus 0000:06: resource 8 [io  0x0000-0x0cf7]
[    0.545569] pci_bus 0000:06: resource 9 [io  0x0d00-0xffff]
[    0.545570] pci_bus 0000:06: resource 10 [mem 0x000a0000-0x000bffff]
[    0.545571] pci_bus 0000:06: resource 11 [mem 0x000c8000-0x000dffff]
[    0.545573] pci_bus 0000:06: resource 12 [mem 0xfe000000-0xfeffffff]
[    0.545574] pci_bus 0000:07: resource 0 [io  0xd000-0xdfff]
[    0.545575] pci_bus 0000:07: resource 2 [mem 0xfef00000-0xfeffffff 64bit pref]
[    0.545577] pci_bus 0000:08: resource 0 [io  0xc000-0xcfff]
[    0.545578] pci_bus 0000:08: resource 1 [mem 0xfe400000-0xfe4fffff]
[    0.545580] pci_bus 0000:09: resource 1 [mem 0xfe300000-0xfe3fffff]
[    0.545596] NET: Registered protocol family 2
[    0.545748] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.546458] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.547445] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.547560] TCP: Hash tables configured (established 524288 bind 65536)
[    0.547563] TCP reno registered
[    0.547574] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.547600] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.547671] NET: Registered protocol family 1
[    0.801718] PCI: CLS 64 bytes, default 64
[    0.801750] Unpacking initramfs...
[    0.985869] Freeing initrd memory: 11480k freed
[    0.986914] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.986920] Placing 64MB software IO TLB between ffff8800db000000 - ffff8800df000000
[    0.986923] software IO TLB at phys 0xdb000000 - 0xdf000000
[    0.987232] audit: initializing netlink socket (disabled)
[    0.987240] type=2000 audit(1305157663.828:1): initialized
[    0.994261] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.995670] VFS: Disk quotas dquot_6.5.2
[    0.995704] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.995756] msgmni has been set to 15971
[    0.995859] alg: No test for stdrng (krng)
[    0.995888] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.995892] io scheduler noop registered
[    0.995894] io scheduler deadline registered
[    0.995915] io scheduler cfq registered (default)
[    0.995968] pcieport 0000:00:01.0: setting latency timer to 64
[    0.995987] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.996033] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.996069] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    0.996126] pcieport 0000:00:1c.2: setting latency timer to 64
[    0.996163] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    0.996220] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.996256] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    0.996314] pcieport 0000:00:1c.5: setting latency timer to 64
[    0.996350] pcieport 0000:00:1c.5: irq 44 for MSI/MSI-X
[    0.996408] pcieport 0000:00:1c.6: setting latency timer to 64
[    0.996444] pcieport 0000:00:1c.6: irq 45 for MSI/MSI-X
[    0.996501] pcieport 0000:00:1c.7: setting latency timer to 64
[    0.996537] pcieport 0000:00:1c.7: irq 46 for MSI/MSI-X
[    0.996608] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    0.996611] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.996614] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    0.996627] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.996631] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.996643] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
[    0.996648] pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
[    0.996661] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    0.996665] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    0.996678] pcieport 0000:00:1c.5: Signaling PME through PCIe PME interrupt
[    0.996680] pci 0000:07:00.0: Signaling PME through PCIe PME interrupt
[    0.996684] pcie_pme 0000:00:1c.5:pcie01: service driver pcie_pme loaded
[    0.996697] pcieport 0000:00:1c.6: Signaling PME through PCIe PME interrupt
[    0.996699] pci 0000:08:00.0: Signaling PME through PCIe PME interrupt
[    0.996701] pci 0000:08:00.1: Signaling PME through PCIe PME interrupt
[    0.996705] pcie_pme 0000:00:1c.6:pcie01: service driver pcie_pme loaded
[    0.996718] pcieport 0000:00:1c.7: Signaling PME through PCIe PME interrupt
[    0.996721] pci 0000:09:00.0: Signaling PME through PCIe PME interrupt
[    0.996725] pcie_pme 0000:00:1c.7:pcie01: service driver pcie_pme loaded
[    0.996784] ERST: Table is not found!
[    0.996817] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.017210] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.117050] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.117211] Linux agpgart interface v0.103
[    1.117330] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.119861] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.119866] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.119936] mousedev: PS/2 mouse device common for all mice
[    1.119965] rtc_cmos 00:04: RTC can wake from S4
[    1.120018] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.120043] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.120051] cpuidle: using governor ladder
[    1.120053] cpuidle: using governor menu
[    1.120168] TCP cubic registered
[    1.120237] NET: Registered protocol family 10
[    1.120520] Mobile IPv6
[    1.120523] NET: Registered protocol family 17
[    1.120526] Registering the dns_resolver key type
[    1.120588] PM: Hibernation image not present or could not be loaded.
[    1.120593] registered taskstats version 1
[    1.121144] rtc_cmos 00:04: setting system clock to 2011-05-11 23:47:44 UTC (1305157664)
[    1.121171] Initalizing network drop monitor service
[    1.121963] Freeing unused kernel memory: 676k freed
[    1.122019] Write protecting the kernel read-only data: 6144k
[    1.123664] Freeing unused kernel memory: 816k freed
[    1.125238] Freeing unused kernel memory: 776k freed
[    1.137760] udev[61]: starting version 164
[    1.155958] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.155979] r8169 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.156021] r8169 0000:07:00.0: setting latency timer to 64
[    1.156026] r8169 0000:07:00.0: (unregistered net_device): unknown MAC, using family default
[    1.156091] r8169 0000:07:00.0: irq 47 for MSI/MSI-X
[    1.156475] r8169 0000:07:00.0: eth0: RTL8168b/8111b at 0xffffc90000c78000, f4:6d:04:0e:be:12, XID 0c200000 IRQ 47
[    1.172274] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    1.172280] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    1.172307] e1000 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.180146] SCSI subsystem initialized
[    1.189888] libata version 3.00 loaded.
[    1.200857] usbcore: registered new interface driver usbfs
[    1.200879] usbcore: registered new interface driver hub
[    1.200905] usbcore: registered new device driver usb
[    1.211211] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.211242] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.211261] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.211265] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    1.211285] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.450238] arcmsr 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.450265] arcmsr 0000:01:00.0: setting latency timer to 64
[    1.457295] ehci_hcd 0000:00:1a.0: debug port 2
[    1.461171] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    1.461187] ehci_hcd 0000:00:1a.0: irq 23, io mem 0xfe707000
[    1.465177] Areca RAID Controller0: F/W V1.48 2009-12-31 & Model ARC-1231
[    1.473144] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.473178] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.473183] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.473188] usb usb1: Product: EHCI Host Controller
[    1.473192] usb usb1: Manufacturer: Linux 2.6.38-2-amd64 ehci_hcd
[    1.473196] usb usb1: SerialNumber: 0000:00:1a.0
[    1.473283] hub 1-0:1.0: USB hub found
[    1.473287] hub 1-0:1.0: 2 ports detected
[    1.473339] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.473352] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.473354] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    1.473360] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.481143] scsi0 : Areca SATA Host Adapter RAID Controller( RAID6 capable)
[    1.481144]  Driver Version 1.20.00.15 2010/08/05
[    1.481715] scsi 0:0:0:2: Direct-Access     Areca    BOOTLOADER       R001 PQ: 0 ANSI: 5
[    1.481894] scsi 0:0:0:3: Direct-Access     Areca    KIWI             R001 PQ: 0 ANSI: 5
[    1.482396] scsi 0:0:16:0: Processor         Areca    RAID controller  R001 PQ: 0 ANSI: 0
[    1.489048] sd 0:0:0:2: [sda] 194560 512-byte logical blocks: (99.6 MB/95.0 MiB)
[    1.489109] sd 0:0:0:3: [sdb] 11716795392 512-byte logical blocks: (5.99 TB/5.45 TiB)
[    1.489128] sd 0:0:0:2: [sda] Write Protect is off
[    1.489133] sd 0:0:0:2: [sda] Mode Sense: cb 00 00 08
[    1.489168] sd 0:0:0:2: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.489185] sd 0:0:0:3: [sdb] Write Protect is off
[    1.489189] sd 0:0:0:3: [sdb] Mode Sense: cb 00 00 08
[    1.489227] sd 0:0:0:3: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.489574]  sdb: unknown partition table
[    1.489741] sd 0:0:0:3: [sdb] Attached SCSI disk
[    1.490175] sd 0:0:0:2: Attached scsi generic sg0 type 0
[    1.490213] sd 0:0:0:3: Attached scsi generic sg1 type 0
[    1.490247] scsi 0:0:16:0: Attached scsi generic sg2 type 3
[    1.493162] ehci_hcd 0000:00:1d.0: debug port 2
[    1.497033] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    1.497039] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xfe706000
[    1.504291]  sda: sda1 sda2
[    1.504506] sd 0:0:0:2: [sda] Attached SCSI disk
[    1.509119] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.509157] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.509163] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.509168] usb usb2: Product: EHCI Host Controller
[    1.509172] usb usb2: Manufacturer: Linux 2.6.38-2-amd64 ehci_hcd
[    1.509176] usb usb2: SerialNumber: 0000:00:1d.0
[    1.509260] hub 2-0:1.0: USB hub found
[    1.509264] hub 2-0:1.0: 2 ports detected
[    1.509440] ahci 0000:00:1f.2: version 3.0
[    1.509459] ahci 0000:00:1f.2: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    1.509503] ahci 0000:00:1f.2: irq 48 for MSI/MSI-X
[    1.509513] ahci 0000:00:1f.2: forcing PORTS_IMPL to 0x3f
[    1.509571] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    1.509577] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
[    1.509584] ahci 0000:00:1f.2: setting latency timer to 64
[    1.510349] scsi1 : ahci
[    1.510427] scsi2 : ahci
[    1.510491] scsi3 : ahci
[    1.510566] scsi4 : ahci
[    1.510629] scsi5 : ahci
[    1.510692] scsi6 : ahci
[    1.510823] ata1: SATA max UDMA/133 abar m2048@0xfe705000 port 0xfe705100 irq 48
[    1.510827] ata2: SATA max UDMA/133 abar m2048@0xfe705000 port 0xfe705180 irq 48
[    1.510831] ata3: SATA max UDMA/133 abar m2048@0xfe705000 port 0xfe705200 irq 48
[    1.510834] ata4: SATA max UDMA/133 abar m2048@0xfe705000 port 0xfe705280 irq 48
[    1.510837] ata5: SATA max UDMA/133 abar m2048@0xfe705000 port 0xfe705300 irq 48
[    1.510841] ata6: SATA max UDMA/133 abar m2048@0xfe705000 port 0xfe705380 irq 48
[    1.631343] e1000 0000:06:00.0: eth1: (PCI:33MHz:32-bit) 00:1b:21:a2:28:3d
[    1.631348] e1000 0000:06:00.0: eth1: Intel(R) PRO/1000 Network Connection
[    1.631368] e1000 0000:06:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.784908] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    1.917145] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    1.917153] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.917421] hub 1-1:1.0: USB hub found
[    1.917518] hub 1-1:1.0: 6 ports detected
[    1.984753] Refined TSC clocksource calibration: 3110.148 MHz.
[    1.984757] Switching to clocksource tsc
[    2.028728] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    2.090985] e1000 0000:06:02.0: eth2: (PCI:33MHz:32-bit) 00:1b:21:a2:26:df
[    2.090989] e1000 0000:06:02.0: eth2: Intel(R) PRO/1000 Network Connection
[    2.091011] firewire_ohci 0000:06:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.152717] firewire_ohci: Added fw-ohci device 0000:06:03.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x11
[    2.160961] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    2.160969] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.161215] hub 2-1:1.0: USB hub found
[    2.161334] hub 2-1:1.0: 8 ports detected
[    2.536345] ata5: failed to resume link (SControl 0)
[    2.536358] ata5: SATA link down (SStatus 0 SControl 0)
[    2.536377] ata4: failed to resume link (SControl 0)
[    2.536388] ata4: SATA link down (SStatus 0 SControl 0)
[    2.540340] ata6: failed to resume link (SControl 0)
[    2.540352] ata6: SATA link down (SStatus 0 SControl 0)
[    2.540365] ata3: failed to resume link (SControl 0)
[    2.540376] ata3: SATA link down (SStatus 0 SControl 0)
[    2.548332] ata2: failed to resume link (SControl 0)
[    2.548346] ata2: SATA link down (SStatus 0 SControl 0)
[    2.548364] ata1: failed to resume link (SControl 0)
[    2.548374] ata1: SATA link down (SStatus 0 SControl 0)
[    2.572864] async_tx: api initialized (async)
[    2.573212] xor: automatically using best checksumming function: generic_sse
[    2.592291]    generic_sse: 13896.000 MB/sec
[    2.592295] xor: using function: generic_sse (13896.000 MB/sec)
[    2.652317] firewire_core: created device fw0: GUID 001fc600000edb4e, S400
[    2.660244] raid6: int64x1   3322 MB/s
[    2.728207] raid6: int64x2   3263 MB/s
[    2.796140] raid6: int64x4   2993 MB/s
[    2.864117] raid6: int64x8   2322 MB/s
[    2.932046] raid6: sse2x1    8330 MB/s
[    2.999993] raid6: sse2x2   10333 MB/s
[    3.067940] raid6: sse2x4   11853 MB/s
[    3.067942] raid6: using algorithm sse2x4 (11853 MB/s)
[    3.073983] md: raid6 personality registered for level 6
[    3.073986] md: raid5 personality registered for level 5
[    3.073988] md: raid4 personality registered for level 4
[    3.082325] device-mapper: uevent: version 1.0.3
[    3.082437] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
[    3.179864] EXT3-fs: barriers not enabled
[    3.193696] kjournald starting.  Commit interval 5 seconds
[    3.193711] EXT3-fs (dm-0): mounted filesystem with ordered data mode
[    4.153380] udev[330]: starting version 164
[    4.218629] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    4.218636] ACPI: Power Button [PWRB]
[    4.218670] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.218674] ACPI: Power Button [PWRF]
[    4.279359] udev[348]: renamed network interface eth0 to eth0-eth2
[    4.303393] udev[339]: renamed network interface eth1 to eth0
[    4.315310] udev[349]: renamed network interface eth2 to eth1
[    4.320000] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    4.343283] udev[348]: renamed network interface eth0-eth2 to eth2
[    4.388474] wmi: Mapper loaded
[    4.458968] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.527600] xhci_hcd 0000:09:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    4.527627] xhci_hcd 0000:09:00.0: setting latency timer to 64
[    4.527631] xhci_hcd 0000:09:00.0: xHCI Host Controller
[    4.527642] xhci_hcd 0000:09:00.0: new USB bus registered, assigned bus number 3
[    4.536179] ACPI: acpi_idle registered with cpuidle
[    4.537844] Monitor-Mwait will be used to enter C-2 state
[    4.537860] Monitor-Mwait will be used to enter C-3 state
[    4.555212] input: Eee PC WMI hotkeys as /devices/platform/eeepc-wmi/input/input3
[    4.557819] xhci_hcd 0000:09:00.0: irq 19, io mem 0xfe300000
[    4.557897] xhci_hcd 0000:09:00.0: irq 49 for MSI/MSI-X
[    4.557902] xhci_hcd 0000:09:00.0: irq 50 for MSI/MSI-X
[    4.557907] xhci_hcd 0000:09:00.0: irq 51 for MSI/MSI-X
[    4.557911] xhci_hcd 0000:09:00.0: irq 52 for MSI/MSI-X
[    4.557916] xhci_hcd 0000:09:00.0: irq 53 for MSI/MSI-X
[    4.563024] usb usb3: No SuperSpeed endpoint companion for config 1  interface 0 altsetting 0 ep 129: using minimum values
[    4.563034] usb usb3: New USB device found, idVendor=1d6b, idProduct=0003
[    4.563037] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.563039] usb usb3: Product: xHCI Host Controller
[    4.563041] usb usb3: Manufacturer: Linux 2.6.38-2-amd64 xhci_hcd
[    4.563043] usb usb3: SerialNumber: 0000:09:00.0
[    4.563109] xHCI xhci_add_endpoint called for root hub
[    4.563111] xHCI xhci_check_bandwidth called for root hub
[    4.563142] hub 3-0:1.0: USB hub found
[    4.563147] hub 3-0:1.0: 4 ports detected
[    4.677047] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    4.677095] HDA Intel 0000:00:1b.0: irq 54 for MSI/MSI-X
[    4.677114] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    4.728950] hda_codec: ALC892: BIOS auto-probing.
[    4.734152] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input4
[    4.986521] EXT3-fs (dm-0): using internal journal
[    5.071283] loop: module loaded
[    5.108639] coretemp coretemp.0: TjMax is 102 C.
[    5.108699] coretemp coretemp.1: TjMax is 102 C.
[    7.901010] EXT3-fs: barriers not enabled
[    7.901147] kjournald starting.  Commit interval 5 seconds
[    7.954655] EXT3-fs (sda2): using internal journal
[    7.954664] EXT3-fs (sda2): mounted filesystem with ordered data mode
[    7.955198] EXT3-fs: barriers not enabled
[    7.955344] kjournald starting.  Commit interval 5 seconds
[    7.955431] EXT3-fs (dm-3): using internal journal
[    7.955438] EXT3-fs (dm-3): mounted filesystem with ordered data mode
[    7.955740] EXT3-fs: barriers not enabled
[    7.955842] kjournald starting.  Commit interval 5 seconds
[    7.955904] EXT3-fs (dm-1): using internal journal
[    7.955910] EXT3-fs (dm-1): mounted filesystem with ordered data mode
[    7.956227] EXT3-fs: barriers not enabled
[    7.956280] kjournald starting.  Commit interval 5 seconds
[    7.956317] EXT3-fs (dm-2): using internal journal
[    7.956321] EXT3-fs (dm-2): mounted filesystem with ordered data mode
[    8.028601] EXT3-fs: barriers not enabled
[    8.028765] kjournald starting.  Commit interval 5 seconds
[    8.028966] EXT3-fs (dm-4): using internal journal
[    8.028970] EXT3-fs (dm-4): mounted filesystem with ordered data mode
[    8.124307] EXT3-fs: barriers not enabled
[    8.124434] kjournald starting.  Commit interval 5 seconds
[    8.125284] EXT3-fs (dm-5): using internal journal
[    8.125288] EXT3-fs (dm-5): mounted filesystem with ordered data mode
[    9.017723] ip_tables: (C) 2000-2006 Netfilter Core Team
[    9.171130] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    9.983305] e1000: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
[    9.983961] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    9.984324] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   20.715833] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   20.740491] e1000: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   20.741076] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   30.806574] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   30.806579] All bugs added by David S. Miller <davem@redhat.com>
[   30.806592] 8021q: adding VLAN 0 to HW filter on device eth0
[   30.806600] 8021q: adding VLAN 0 to HW filter on device eth1
[  100.966254] IPv6 over IPv4 tunneling driver
[  153.297472] tun: Universal TUN/TAP device driver, 1.6
[  153.297483] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[  153.544716] sshd (1698): /proc/1698/oom_adj is deprecated, please use /proc/1698/oom_score_adj instead.
[  167.757762] lp: driver loaded but no devices found
[  167.905053] ppdev: user-space parallel port driver
[  181.405617] PPP generic driver version 2.4.2
[  181.579300] NET: Registered protocol family 24
[  315.481763] irq 16: nobody cared (try booting with the "irqpoll" option)
[  315.481773] Pid: 0, comm: swapper Not tainted 2.6.38-2-amd64 #1
[  315.481778] Call Trace:
[  315.481781]  <IRQ>  [<ffffffff810923e9>] ? __report_bad_irq+0x30/0x80
[  315.481796]  [<ffffffff81092560>] ? note_interrupt+0x127/0x19f
[  315.481804]  [<ffffffff8100f502>] ? read_tsc+0x5/0x16
[  315.481809]  [<ffffffff81092ef7>] ? handle_fasteoi_irq+0xb4/0xdf
[  315.481815]  [<ffffffff8100be54>] ? handle_irq+0x17/0x1f
[  315.481820]  [<ffffffff8100b50e>] ? do_IRQ+0x45/0xaa
[  315.481827]  [<ffffffff81327213>] ? ret_from_intr+0x0/0x15
[  315.481830]  <EOI>  [<ffffffff811f32fc>] ? acpi_hw_read_multiple+0x28/0x60
[  315.481841]  [<ffffffff8100f4d5>] ? sched_clock+0x5/0x8
[  315.481854]  [<ffffffffa026efc7>] ? acpi_idle_enter_bm+0x259/0x291 [processor]
[  315.481862]  [<ffffffffa026efc0>] ? acpi_idle_enter_bm+0x252/0x291 [processor]
[  315.481870]  [<ffffffff81259f27>] ? cpuidle_idle_call+0x11f/0x1cc
[  315.481875]  [<ffffffff81008d93>] ? cpu_idle+0xab/0xe1
[  315.481881]  [<ffffffff8169ed70>] ? start_kernel+0x3dc/0x3e7
[  315.481886]  [<ffffffff8169e3cd>] ? x86_64_start_kernel+0x107/0x114
[  315.481890] handlers:
[  315.481893] [<ffffffffa01b50b5>] (arcmsr_do_interrupt+0x0/0xe [arcmsr])
[  315.481905] [<ffffffffa01bcee5>] (e1000_intr+0x0/0x100 [e1000])
[  315.481915] Disabling IRQ #16
[28536.149807] irq 18: nobody cared (try booting with the "irqpoll" option)
[28536.149812] Pid: 0, comm: swapper Not tainted 2.6.38-2-amd64 #1
[28536.149814] Call Trace:
[28536.149816]  <IRQ>  [<ffffffff810923e9>] ? __report_bad_irq+0x30/0x80
[28536.149824]  [<ffffffff81092560>] ? note_interrupt+0x127/0x19f
[28536.149828]  [<ffffffff81092ef7>] ? handle_fasteoi_irq+0xb4/0xdf
[28536.149832]  [<ffffffff8100be54>] ? handle_irq+0x17/0x1f
[28536.149834]  [<ffffffff8100b50e>] ? do_IRQ+0x45/0xaa
[28536.149838]  [<ffffffff81327213>] ? ret_from_intr+0x0/0x15
[28536.149842]  [<ffffffff8100f502>] ? read_tsc+0x5/0x16
[28536.149846]  [<ffffffff8104c7cd>] ? __do_softirq+0x55/0x1a0
[28536.149848]  [<ffffffff8100a85c>] ? call_softirq+0x1c/0x30
[28536.149851]  [<ffffffff8100be03>] ? do_softirq+0x3f/0x79
[28536.149854]  [<ffffffff8104c6dd>] ? irq_exit+0x36/0x7b
[28536.149856]  [<ffffffff8100b55d>] ? do_IRQ+0x94/0xaa
[28536.149859]  [<ffffffff81327213>] ? ret_from_intr+0x0/0x15
[28536.149861]  <EOI>  [<ffffffff811f32fc>] ? acpi_hw_read_multiple+0x28/0x60
[28536.149867]  [<ffffffff8100f4d5>] ? sched_clock+0x5/0x8
[28536.149875]  [<ffffffffa026efc7>] ? acpi_idle_enter_bm+0x259/0x291 [processor]
[28536.149879]  [<ffffffffa026efc0>] ? acpi_idle_enter_bm+0x252/0x291 [processor]
[28536.149883]  [<ffffffff81259f27>] ? cpuidle_idle_call+0x11f/0x1cc
[28536.149886]  [<ffffffff81008d93>] ? cpu_idle+0xab/0xe1
[28536.149889]  [<ffffffff8169ed70>] ? start_kernel+0x3dc/0x3e7
[28536.149892]  [<ffffffff8169e3cd>] ? x86_64_start_kernel+0x107/0x114
[28536.149894] handlers:
[28536.149895] [<ffffffffa01bcee5>] (e1000_intr+0x0/0x100 [e1000])
[28536.149903] Disabling IRQ #18

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=interrupts

           CPU0       CPU1       CPU2       CPU3       
  0:        141          0          0          0   IO-APIC-edge      timer
  1:          2          0          0          0   IO-APIC-edge      i8042
  8:          1          0          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          4          0          0          0   IO-APIC-edge      i8042
 16:     302272          0          0          0   IO-APIC-fasteoi   arcmsr, eth0
 18:    1700001          0          0          0   IO-APIC-fasteoi   eth1
 19:    1372141          0          0          0   IO-APIC-fasteoi   firewire_ohci
 23:         59          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1, ehci_hcd:usb2
 40:          0          0          0          0   PCI-MSI-edge      PCIe PME
 41:          0          0          0          0   PCI-MSI-edge      PCIe PME
 42:          0          0          0          0   PCI-MSI-edge      PCIe PME
 43:          0          0          0          0   PCI-MSI-edge      PCIe PME
 44:          0          0          0          0   PCI-MSI-edge      PCIe PME
 45:          0          0          0          0   PCI-MSI-edge      PCIe PME
 46:          0          0          0          0   PCI-MSI-edge      PCIe PME
 48:          0          0          0          0   PCI-MSI-edge      ahci
 49:          0          0          0          0   PCI-MSI-edge      xhci_hcd
 50:          0          0          0          0   PCI-MSI-edge      xhci_hcd
 51:          0          0          0          0   PCI-MSI-edge      xhci_hcd
 52:          0          0          0          0   PCI-MSI-edge      xhci_hcd
 53:          0          0          0          0   PCI-MSI-edge      xhci_hcd
 54:        317          0          0          0   PCI-MSI-edge      hda_intel
NMI:        198          8         44          4   Non-maskable interrupts
LOC:    1226394     233197     919289     100444   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:        198          8         44          4   Performance monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RES:       1902        335       1165        494   Rescheduling interrupts
CAL:        267        685        594        637   Function call interrupts
TLB:         83         74        241        302   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:        101        101        101        101   Machine check polls
ERR:          3
MIS:          0

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lspci

00:00.0 Host bridge [0600]: Intel Corporation Sandy Bridge DRAM Controller [8086:0100] (rev 09)
00:01.0 PCI bridge [0604]: Intel Corporation Sandy Bridge PCI Express Root Port [8086:0101] (rev 09)
00:16.0 Communication controller [0780]: Intel Corporation Cougar Point HECI Controller #1 [8086:1c3a] (rev 04)
00:1a.0 USB Controller [0c03]: Intel Corporation Cougar Point USB Enhanced Host Controller #2 [8086:1c2d] (rev 05)
00:1b.0 Audio device [0403]: Intel Corporation Cougar Point High Definition Audio Controller [8086:1c20] (rev 05)
00:1c.0 PCI bridge [0604]: Intel Corporation Cougar Point PCI Express Root Port 1 [8086:1c10] (rev b5)
00:1c.2 PCI bridge [0604]: Intel Corporation Cougar Point PCI Express Root Port 3 [8086:1c14] (rev b5)
00:1c.3 PCI bridge [0604]: Intel Corporation Cougar Point PCI Express Root Port 4 [8086:1c16] (rev b5)
00:1c.4 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev b5)
00:1c.5 PCI bridge [0604]: Intel Corporation Cougar Point PCI Express Root Port 6 [8086:1c1a] (rev b5)
00:1c.6 PCI bridge [0604]: Intel Corporation Cougar Point PCI Express Root Port 7 [8086:1c1c] (rev b5)
00:1c.7 PCI bridge [0604]: Intel Corporation Cougar Point PCI Express Root Port 8 [8086:1c1e] (rev b5)
00:1d.0 USB Controller [0c03]: Intel Corporation Cougar Point USB Enhanced Host Controller #1 [8086:1c26] (rev 05)
00:1f.0 ISA bridge [0601]: Intel Corporation Cougar Point LPC Controller [8086:1c46] (rev 05)
00:1f.2 SATA controller [0106]: Intel Corporation Cougar Point 6 port SATA AHCI Controller [8086:1c02] (rev 05)
00:1f.3 SMBus [0c05]: Intel Corporation Cougar Point SMBus Controller [8086:1c22] (rev 05)
01:00.0 RAID bus controller [0104]: Areca Technology Corp. ARC-1231 12-Port PCI-Express to SATA RAID Controller [17d3:1280]
05:00.0 PCI bridge [0604]: Device [1b21:1080] (rev 01)
06:00.0 Ethernet controller [0200]: Intel Corporation 82541PI Gigabit Ethernet Controller [8086:107c] (rev 05)
06:02.0 Ethernet controller [0200]: Intel Corporation 82541PI Gigabit Ethernet Controller [8086:107c] (rev 05)
06:03.0 FireWire (IEEE 1394) [0c00]: VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller [1106:3044] (rev c0)
07:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev 06)
08:00.0 IDE interface [0101]: Marvell Technology Group Ltd. Device [1b4b:91a0] (rev 12)
08:00.1 IDE interface [0101]: Marvell Technology Group Ltd. Device [1b4b:91a4] (rev 12)
09:00.0 USB Controller [0c03]: Device [1b21:1042]

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=cpuinfo

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i3-2100 CPU @ 3.10GHz
stepping	: 7
cpu MHz		: 1600.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt xsave avx lahf_lm arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 6220.15
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i3-2100 CPU @ 3.10GHz
stepping	: 7
cpu MHz		: 1600.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 2
apicid		: 2
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt xsave avx lahf_lm arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 6220.12
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i3-2100 CPU @ 3.10GHz
stepping	: 7
cpu MHz		: 1600.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt xsave avx lahf_lm arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 6220.12
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i3-2100 CPU @ 3.10GHz
stepping	: 7
cpu MHz		: 1600.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 2
apicid		: 3
initial apicid	: 3
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt xsave avx lahf_lm arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 6220.13
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


--gBBFr7Ir9EOA20Yy--
