Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab2CXBH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 21:07:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60403 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab2CXBHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 21:07:54 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 23 Mar 2012 18:07:33 -0700
Message-ID: <CALCETrXuwB3VNDY3DcNiUjMXkat29x_kmsXVHdXc8ww9DukO1A@mail.gmail.com>
Subject: Lost interrupts or very slow wake-from-idle on Cedar Trail Atom box
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a new Intel DN2800MT (i.e. Cedar Trail).  It seems to have a
problem with lost or delayed interrupts (I think).  The symptom is
that there is obvious lag on the network.  Pinging from a machine on
the same ethernet link does this:

64 bytes from 192.168.132.1: icmp_req=60 ttl=64 time=71.2 ms
64 bytes from 192.168.132.1: icmp_req=61 ttl=64 time=138 ms
64 bytes from 192.168.132.1: icmp_req=62 ttl=64 time=86.2 ms
64 bytes from 192.168.132.1: icmp_req=63 ttl=64 time=28.9 ms
64 bytes from 192.168.132.1: icmp_req=64 ttl=64 time=52.0 ms
64 bytes from 192.168.132.1: icmp_req=65 ttl=64 time=79.2 ms
64 bytes from 192.168.132.1: icmp_req=66 ttl=64 time=58.5 ms
64 bytes from 192.168.132.1: icmp_req=67 ttl=64 time=21.2 ms
64 bytes from 192.168.132.1: icmp_req=68 ttl=64 time=54.5 ms
64 bytes from 192.168.132.1: icmp_req=69 ttl=64 time=77.8 ms
64 bytes from 192.168.132.1: icmp_req=70 ttl=64 time=20.1 ms
64 bytes from 192.168.132.1: icmp_req=71 ttl=64 time=23.6 ms

The system is responsive from a keyboard, but it's laggy over ssh,
which makes me think it's an interrupt or failed wake-from-C2 issue.
This works around it:

(echo -ne '\x01\x00\x00\x00'; exec sleep 1000d) >/dev/cpu_dma_latency
</dev/null 2>/dev/null &

Fiddling with cpufreq seems to have no effect.

I have this problem on a range of kernels from 2.6.32 through 3.3.0
(the latter from Ubuntu's mainline PPA).  dmesg below.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.0-030300-generic (apw@gomeisa) (gcc
version 4.4.3 (Ubuntu 4.4.3-4ubuntu5.1) ) #201203182135 SMP Mon Mar 19
01:36:20 UTC 2012
[    0.000000] Command line: initrd=/initrd.img
root=UUID=5ccf7705-b0b8-4701-a455-e3c84cc3a2cf ro quiet
BOOT_IMAGE=/vmlinuz
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] Disabled fast string operations
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
[    0.000000]  BIOS-e820: 000000000008f000 - 0000000000090000 (reserved)
[    0.000000]  BIOS-e820: 0000000000090000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f485000 (usable)
[    0.000000]  BIOS-e820: 000000007f485000 - 000000007f4af000 (reserved)
[    0.000000]  BIOS-e820: 000000007f4af000 - 000000007f4ed000 (usable)
[    0.000000]  BIOS-e820: 000000007f4ed000 - 000000007f5af000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f5af000 - 000000007f5df000 (usable)
[    0.000000]  BIOS-e820: 000000007f5df000 - 000000007f5ef000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007f5ef000 - 000000007f5f0000 (usable)
[    0.000000]  BIOS-e820: 000000007f5f0000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000e4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.7 present.
[    0.000000] DMI:                  /DN2800MT, BIOS
MTCDT10N.86A.0146.2011.1130.1139 11/30/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7f5f0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F5F0000 mask FFFFF0000 uncachable
[    0.000000]   2 base 07F600000 mask FFFE00000 uncachable
[    0.000000]   3 base 07F800000 mask FFF800000 uncachable
[    0.000000]   4 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [ffff8800000fbe50] fbe50
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-000000007f5f0000
[    0.000000]  0000000000 - 007f400000 page 2M
[    0.000000]  007f400000 - 007f5f0000 page 4k
[    0.000000] kernel direct mapping tables up to 7f5f0000 @ 1fffc000-20000000
[    0.000000] RAMDISK: 7e8ef000 - 7f484000
[    0.000000] ACPI: RSDP 00000000000f2240 00024 (v02 INTEL )
[    0.000000] ACPI: XSDT 000000007f5ee120 00064 (v01 INTEL  DN2800MT
00000092      01000013)
[    0.000000] ACPI: FACP 000000007f5e6000 000F4 (v03 INTEL  DN2800MT
00000092 MSFT 0100000D)
[    0.000000] ACPI: DSDT 000000007f5e8000 05C67 (v02 INTEL  DN2800MT
00000092 MSFT 0100000D)
[    0.000000] ACPI: FACS 000000007f575000 00040
[    0.000000] ACPI: SSDT 000000007f5e7000 0043E (v01 INTEL  DN2800MT
00000092 MSFT 0100000D)
[    0.000000] ACPI: APIC 000000007f5e5000 00084 (v02 INTEL  DN2800MT
00000092 MSFT 0100000D)
[    0.000000] ACPI: MCFG 000000007f5e4000 0003C (v01 INTEL  DN2800MT
00000092 MSFT 0100000D)
[    0.000000] ACPI: HPET 000000007f5e3000 00038 (v01 INTEL  DN2800MT
00000092 MSFT 0100000D)
[    0.000000] ACPI: SSDT 000000007f5e1000 00655 (v01  PmRef    CpuPm
00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007f5e0000 00259 (v01  PmRef  Cpu0Tst
00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007f5df000 0020F (v01  PmRef    ApTst
00003000 INTL 20061109)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007f5f0000
[    0.000000] Initmem setup node 0 0000000000000000-000000007f5f0000
[    0.000000]   NODE_DATA [000000007f5da000 - 000000007f5defff]
[    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD ->
[ffff88007c000000-ffff88007dffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000008f
[    0.000000]     0: 0x00000090 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x0007f485
[    0.000000]     0: 0x0007f4af -> 0x0007f4ed
[    0.000000]     0: 0x0007f5af -> 0x0007f5df
[    0.000000]     0: 0x0007f5ef -> 0x0007f5f0
[    0.000000] On node 0 totalpages: 521345
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3912 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8088 pages used for memmap
[    0.000000]   DMA32 zone: 509276 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000008f000 - 0000000000090000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000007f485000 - 000000007f4af000
[    0.000000] PM: Registered nosave memory: 000000007f4ed000 - 000000007f5af000
[    0.000000] PM: Registered nosave memory: 000000007f5df000 - 000000007f5ef000
[    0.000000] Allocating PCI resources starting at 80000000 (gap:
80000000:60000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256
nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88007e600000 s82624
r8192 d23872 u524288
[    0.000000] pcpu-alloc: s82624 r8192 d23872 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.
Total pages: 513188
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: initrd=/initrd.img
root=UUID=5ccf7705-b0b8-4701-a455-e3c84cc3a2cf ro quiet
BOOT_IMAGE=/vmlinuz
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 2024516k/2086848k available (6579k kernel code,
1468k absent, 60864k reserved, 6549k data, 912k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:16640 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 8388608 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 1866.780 MHz processor.
[    0.000006] Calibrating delay loop (skipped), value calculated
using timer frequency.. 3733.56 BogoMIPS (lpj=7467120)
[    0.000017] pid_max: default: 32768 minimum: 301
[    0.000078] Security Framework initialized
[    0.000115] AppArmor: AppArmor initialized
[    0.000620] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.002431] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.003222] Mount-cache hash table entries: 256
[    0.003545] Initializing cgroup subsys cpuacct
[    0.003552] Initializing cgroup subsys memory
[    0.003571] Initializing cgroup subsys devices
[    0.003576] Initializing cgroup subsys freezer
[    0.003582] Initializing cgroup subsys blkio
[    0.003600] Initializing cgroup subsys perf_event
[    0.003661] Disabled fast string operations
[    0.003671] CPU: Physical Processor ID: 0
[    0.003675] CPU: Processor Core ID: 0
[    0.003680] mce: CPU supports 5 MCE banks
[    0.003694] CPU0: Thermal monitoring enabled (TM2)
[    0.003702] using mwait in idle threads.
[    0.006865] ACPI: Core revision 20120111
[    0.018927] ftrace: allocating 25267 entries in 99 pages
[    0.041757] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.081419] CPU0: Intel(R) Atom(TM) CPU N2800   @ 1.86GHz stepping 01
[    0.185572] Performance Events: PEBS fmt0+, generic architected
perfmon, Intel PMU driver.
[    0.185587] ... version:                3
[    0.185590] ... bit width:              40
[    0.185594] ... generic registers:      2
[    0.185598] ... value mask:             000000ffffffffff
[    0.185602] ... max period:             000000007fffffff
[    0.185606] ... fixed-purpose events:   3
[    0.185609] ... event mask:             0000000700000003
[    0.186012] NMI watchdog enabled, takes one hw-pmu counter.
[    0.186372] Booting Node   0, Processors  #1
[    0.186380] smpboot cpu 1: start_ip = 99000
[    0.197321] Disabled fast string operations
[    0.217472] NMI watchdog enabled, takes one hw-pmu counter.
[    0.217737]  #2
[    0.217742] smpboot cpu 2: start_ip = 99000
[    0.228677] Disabled fast string operations
[    0.248786] NMI watchdog enabled, takes one hw-pmu counter.
[    0.249007]  #3 Ok.
[    0.249012] smpboot cpu 3: start_ip = 99000
[    0.259947] Disabled fast string operations
[    0.280052] NMI watchdog enabled, takes one hw-pmu counter.
[    0.280118] Brought up 4 CPUs
[    0.280125] Total of 4 processors activated (14934.24 BogoMIPS).
[    0.281525] devtmpfs: initialized
[    0.288312] EVM: security.selinux
[    0.288317] EVM: security.SMACK64
[    0.288320] EVM: security.capability
[    0.288448] PM: Registering ACPI NVS region at 7f4ed000 (794624 bytes)
[    0.290796] print_constraints: dummy:
[    0.290852] RTC time:  0:57:23, date: 03/24/12
[    0.290946] NET: Registered protocol family 16
[    0.291231] ACPI FADT declares the system doesn't support PCIe
ASPM, so disable it
[    0.291238] ACPI: bus type pci registered
[    0.291384] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.291392] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
[    0.306784] PCI: Using configuration type 1 for base access
[    0.309267] bio: create slab <bio-0> at 0
[    0.309540] ACPI: Added _OSI(Module Device)
[    0.309546] ACPI: Added _OSI(Processor Device)
[    0.309551] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.309556] ACPI: Added _OSI(Processor Aggregator Device)
[    0.312772] ACPI: EC: Look up EC in DSDT
[    0.316193] ACPI: Executed 1 blocks of module-level executable AML code
[    0.320961] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.322091] ACPI: SSDT 000000007f4aec18 002A7 (v01  PmRef  Cpu0Ist
00003000 INTL 20061109)
[    0.322916] ACPI: Dynamic OEM Table Load:
[    0.322924] ACPI: SSDT           (null) 002A7 (v01  PmRef  Cpu0Ist
00003000 INTL 20061109)
[    0.323276] ACPI: SSDT 000000007f4ac718 006D5 (v01  PmRef  Cpu0Cst
00003001 INTL 20061109)
[    0.324080] ACPI: Dynamic OEM Table Load:
[    0.324087] ACPI: SSDT           (null) 006D5 (v01  PmRef  Cpu0Cst
00003001 INTL 20061109)
[    0.324868] ACPI: SSDT 000000007f4ade18 001CF (v01  PmRef    ApIst
00003000 INTL 20061109)
[    0.325752] ACPI: Dynamic OEM Table Load:
[    0.325760] ACPI: SSDT           (null) 001CF (v01  PmRef    ApIst
00003000 INTL 20061109)
[    0.326062] ACPI: SSDT 000000007f4aef18 0008D (v01  PmRef    ApCst
00003000 INTL 20061109)
[    0.326879] ACPI: Dynamic OEM Table Load:
[    0.326886] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst
00003000 INTL 20061109)
[    0.328431] ACPI: Interpreter enabled
[    0.328441] ACPI: (supports S0 S3 S4 S5)
[    0.328488] ACPI: Using IOAPIC for interrupt routing
[    0.342811] ACPI: No dock devices found.
[    0.342824] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.343349] \_SB_.PCI0:_OSC invalid UUID
[    0.343354] _OSC request data:1 8 1f
[    0.343366] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.343981] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.343988] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.343995] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff]
[    0.344001] pci_root PNP0A08:00: host bridge window [mem
0x000c0000-0x000dffff]
[    0.344008] pci_root PNP0A08:00: host bridge window [mem
0x000e0000-0x000effff]
[    0.344014] pci_root PNP0A08:00: host bridge window [mem
0x000f0000-0x000fffff]
[    0.344020] pci_root PNP0A08:00: host bridge window [mem
0x7f800000-0x7fffffff]
[    0.344026] pci_root PNP0A08:00: host bridge window [mem
0x80000000-0xfebfffff]
[    0.344032] pci_root PNP0A08:00: host bridge window [mem
0xfed40000-0xfed44fff]
[    0.344127] PCI host bridge to bus 0000:00
[    0.344133] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.344139] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.344145] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.344151] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.344157] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000effff]
[    0.344163] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff]
[    0.344169] pci_bus 0000:00: root bus resource [mem 0x7f800000-0x7fffffff]
[    0.344175] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.344180] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.344199] pci 0000:00:00.0: [8086:0bf2] type 0 class 0x000600
[    0.344264] pci 0000:00:02.0: [8086:0be2] type 0 class 0x000300
[    0.344284] pci 0000:00:02.0: reg 10: [mem 0x80500000-0x805fffff]
[    0.344295] pci 0000:00:02.0: reg 14: [io  0x30a0-0x30a7]
[    0.344410] pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
[    0.344515] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.344562] pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
[    0.344632] pci 0000:00:1d.0: reg 20: [io  0x3080-0x309f]
[    0.344693] pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
[    0.344756] pci 0000:00:1d.1: reg 20: [io  0x3060-0x307f]
[    0.344818] pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
[    0.344889] pci 0000:00:1d.2: reg 20: [io  0x3040-0x305f]
[    0.344946] pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
[    0.345008] pci 0000:00:1d.3: reg 20: [io  0x3020-0x303f]
[    0.345076] pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
[    0.345105] pci 0000:00:1d.7: reg 10: [mem 0x80600000-0x806003ff]
[    0.345225] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.345260] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.345363] pci 0000:00:1f.0: [8086:27bc] type 0 class 0x000601
[    0.345480] pci 0000:00:1f.0: [Firmware Bug]: TigerPoint LPC.BM_STS cleared
[    0.345545] pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
[    0.345613] pci 0000:00:1f.3: reg 20: [io  0x3000-0x301f]
[    0.345822] pci 0000:01:00.0: [8086:10d3] type 0 class 0x000200
[    0.345857] pci 0000:01:00.0: reg 10: [mem 0x80400000-0x8041ffff]
[    0.345886] pci 0000:01:00.0: reg 14: [mem 0x80000000-0x803fffff]
[    0.345915] pci 0000:01:00.0: reg 18: [io  0x2000-0x201f]
[    0.345941] pci 0000:01:00.0: reg 1c: [mem 0x80420000-0x80423fff]
[    0.346125] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.346213] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.346221] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.346230] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x804fffff]
[    0.346327] pci 0000:00:1e.0: PCI bridge to [bus 02-02] (subtractive decode)
[    0.346346] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.346353] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.346359] pci 0000:00:1e.0:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.346366] pci 0000:00:1e.0:   bridge window [mem
0x000c0000-0x000dffff] (subtractive decode)
[    0.346373] pci 0000:00:1e.0:   bridge window [mem
0x000e0000-0x000effff] (subtractive decode)
[    0.346380] pci 0000:00:1e.0:   bridge window [mem
0x000f0000-0x000fffff] (subtractive decode)
[    0.346386] pci 0000:00:1e.0:   bridge window [mem
0x7f800000-0x7fffffff] (subtractive decode)
[    0.346393] pci 0000:00:1e.0:   bridge window [mem
0x80000000-0xfebfffff] (subtractive decode)
[    0.346400] pci 0000:00:1e.0:   bridge window [mem
0xfed40000-0xfed44fff] (subtractive decode)
[    0.346423] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.346574] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.346710] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.346954] \_SB_.PCI0:_OSC invalid UUID
[    0.346958] _OSC request data:1 1f 1f
[    0.346970]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.347075] \_SB_.PCI0:_OSC invalid UUID
[    0.347079] _OSC request data:1 0 1d
[    0.347089]  pci0000:00: ACPI _OSC request failed (AE_ERROR),
returned control mask: 0x1d
[    0.347094] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.353458] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    0.353600] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12
14 15) *0, disabled.
[    0.353737] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    0.353873] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12
14 15) *10
[    0.354015] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[    0.354153] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12
14 15) *0, disabled.
[    0.354291] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[    0.354428] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *9
[    0.354737] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.354753] vgaarb: loaded
[    0.354757] vgaarb: bridge control possible 0000:00:02.0
[    0.355132] SCSI subsystem initialized
[    0.355284] libata version 3.00 loaded.
[    0.355400] usbcore: registered new interface driver usbfs
[    0.355430] usbcore: registered new interface driver hub
[    0.355529] usbcore: registered new device driver usb
[    0.355769] PCI: Using ACPI for IRQ routing
[    0.357944] PCI: pci_cache_line_size set to 64 bytes
[    0.358095] reserve RAM buffer: 000000000008f000 - 000000000008ffff
[    0.358102] reserve RAM buffer: 000000000009e800 - 000000000009ffff
[    0.358107] reserve RAM buffer: 000000007f485000 - 000000007fffffff
[    0.358114] reserve RAM buffer: 000000007f4ed000 - 000000007fffffff
[    0.358120] reserve RAM buffer: 000000007f5df000 - 000000007fffffff
[    0.358125] reserve RAM buffer: 000000007f5f0000 - 000000007fffffff
[    0.358351] NetLabel: Initializing
[    0.358356] NetLabel:  domain hash size = 128
[    0.358360] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.358384] NetLabel:  unlabeled traffic allowed by default
[    0.358528] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.358539] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.360563] Switching to clocksource hpet
[    0.379714] AppArmor: AppArmor Filesystem Enabled
[    0.379772] pnp: PnP ACPI init
[    0.379816] ACPI: bus type pnp registered
[    0.380208] pnp 00:00: [bus 00-ff]
[    0.380215] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.380221] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.380226] pnp 00:00: [io  0x0d00-0xffff window]
[    0.380232] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.380238] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.380244] pnp 00:00: [mem 0x000e0000-0x000effff window]
[    0.380250] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.380256] pnp 00:00: [mem 0x7f800000-0x7fffffff window]
[    0.380262] pnp 00:00: [mem 0x80000000-0xfebfffff window]
[    0.380267] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.380406] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08
PNP0a03 (active)
[    0.380454] pnp 00:01: [io  0x0000-0x001f]
[    0.380459] pnp 00:01: [io  0x0081-0x0091]
[    0.380464] pnp 00:01: [io  0x0093-0x009f]
[    0.380469] pnp 00:01: [io  0x00c0-0x00df]
[    0.380474] pnp 00:01: [dma 4]
[    0.380539] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.380602] pnp 00:02: [mem 0xff000000-0xffffffff]
[    0.380671] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.380861] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.380952] system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.380961] system 00:03: Plug and Play ACPI device, IDs PNP0103
PNP0c01 (active)
[    0.380993] pnp 00:04: [io  0x00f0]
[    0.381013] pnp 00:04: [irq 13]
[    0.381076] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.381113] pnp 00:05: [io  0x002e-0x002f]
[    0.381118] pnp 00:05: [io  0x004e-0x004f]
[    0.381123] pnp 00:05: [io  0x0061]
[    0.381128] pnp 00:05: [io  0x0063]
[    0.381132] pnp 00:05: [io  0x0065]
[    0.381137] pnp 00:05: [io  0x0067]
[    0.381141] pnp 00:05: [io  0x0070]
[    0.381146] pnp 00:05: [io  0x0080]
[    0.381150] pnp 00:05: [io  0x0092]
[    0.381155] pnp 00:05: [io  0x00b2-0x00b3]
[    0.381160] pnp 00:05: [io  0x0680-0x069f]
[    0.381165] pnp 00:05: [io  0x1000-0x100f]
[    0.381170] pnp 00:05: [io  0xffff]
[    0.381174] pnp 00:05: [io  0xffff]
[    0.381179] pnp 00:05: [io  0x0400-0x047f]
[    0.381184] pnp 00:05: [io  0x0500-0x057f]
[    0.381189] pnp 00:05: [io  0x0600-0x061f]
[    0.381282] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.381289] system 00:05: [io  0x1000-0x100f] has been reserved
[    0.381296] system 00:05: [io  0xffff] has been reserved
[    0.381302] system 00:05: [io  0xffff] has been reserved
[    0.381308] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.381315] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.381326] system 00:05: [io  0x0600-0x061f] has been reserved
[    0.381334] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.381409] pnp 00:06: [io  0x06a0-0x06af]
[    0.381415] pnp 00:06: [io  0x06b0-0x06ff]
[    0.381495] system 00:06: [io  0x06a0-0x06af] has been reserved
[    0.381502] system 00:06: [io  0x06b0-0x06ff] has been reserved
[    0.381510] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.381536] pnp 00:07: [io  0x0070-0x0077]
[    0.381548] pnp 00:07: [irq 8]
[    0.381612] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.382206] pnp 00:08: [io  0x02f8-0x02ff]
[    0.382219] pnp 00:08: [irq 3]
[    0.382383] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.382687] pnp 00:09: [io  0x03f8-0x03ff]
[    0.382699] pnp 00:09: [irq 4]
[    0.382862] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.383241] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    0.383248] pnp 00:0a: [mem 0x00000000-0x00003fff]
[    0.383254] pnp 00:0a: [mem 0x00000000-0x00000fff]
[    0.383259] pnp 00:0a: [mem 0x00000000-0x00000fff]
[    0.383265] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.383271] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
[    0.383402] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.383410] system 00:0a: [mem 0x00000000-0x00003fff] could not be reserved
[    0.383417] system 00:0a: [mem 0x00000000-0x00000fff] could not be reserved
[    0.383424] system 00:0a: [mem 0x00000000-0x00000fff] could not be reserved
[    0.383431] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.383439] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.383774] pnp: PnP ACPI: found 11 devices
[    0.383779] ACPI: ACPI bus type pnp unregistered
[    0.397331] PCI: max bus depth: 1 pci_try_num: 2
[    0.397382] pci 0000:00:1c.0: BAR 15: assigned [mem
0x80700000-0x808fffff 64bit pref]
[    0.397390] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.397397] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.397407] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x804fffff]
[    0.397416] pci 0000:00:1c.0:   bridge window [mem
0x80700000-0x808fffff 64bit pref]
[    0.397427] pci 0000:00:1e.0: PCI bridge to [bus 02-02]
[    0.397488] pci 0000:00:1e.0: setting latency timer to 64
[    0.397496] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.397502] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.397508] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.397514] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.397520] pci_bus 0000:00: resource 8 [mem 0x000e0000-0x000effff]
[    0.397526] pci_bus 0000:00: resource 9 [mem 0x000f0000-0x000fffff]
[    0.397532] pci_bus 0000:00: resource 10 [mem 0x7f800000-0x7fffffff]
[    0.397538] pci_bus 0000:00: resource 11 [mem 0x80000000-0xfebfffff]
[    0.397545] pci_bus 0000:00: resource 12 [mem 0xfed40000-0xfed44fff]
[    0.397551] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.397557] pci_bus 0000:01: resource 1 [mem 0x80000000-0x804fffff]
[    0.397563] pci_bus 0000:01: resource 2 [mem 0x80700000-0x808fffff
64bit pref]
[    0.397570] pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
[    0.397575] pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
[    0.397581] pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
[    0.397587] pci_bus 0000:02: resource 7 [mem 0x000c0000-0x000dffff]
[    0.397593] pci_bus 0000:02: resource 8 [mem 0x000e0000-0x000effff]
[    0.397599] pci_bus 0000:02: resource 9 [mem 0x000f0000-0x000fffff]
[    0.397605] pci_bus 0000:02: resource 10 [mem 0x7f800000-0x7fffffff]
[    0.397611] pci_bus 0000:02: resource 11 [mem 0x80000000-0xfebfffff]
[    0.397617] pci_bus 0000:02: resource 12 [mem 0xfed40000-0xfed44fff]
[    0.397697] NET: Registered protocol family 2
[    0.397924] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.399565] TCP established hash table entries: 262144 (order: 10,
4194304 bytes)
[    0.402792] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.403536] TCP: Hash tables configured (established 262144 bind 65536)
[    0.403542] TCP reno registered
[    0.403572] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.403612] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.403819] NET: Registered protocol family 1
[    0.403854] pci 0000:00:02.0: Boot video device
[    0.420707] PCI: CLS 64 bytes, default 64
[    0.420822] Trying to unpack rootfs image as initramfs...
[    0.933010] Freeing initrd memory: 11860k freed
[    0.943921] audit: initializing netlink socket (disabled)
[    0.943946] type=2000 audit(1332550643.780:1): initialized
[    0.984726] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.989640] VFS: Disk quotas dquot_6.5.2
[    0.989774] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.991051] fuse init (API version 7.18)
[    0.991304] msgmni has been set to 3977
[    0.992554] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    0.992654] io scheduler noop registered
[    0.992662] io scheduler deadline registered
[    0.992819] io scheduler cfq registered (default)
[    0.993074] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.993236] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.993283] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.993399] intel_idle: MWAIT substates: 0x3020220
[    0.993404] intel_idle: does not run on family 6 model 54
[    0.993591] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.993604] ACPI: Power Button [PWRB]
[    0.993705] input: Sleep Button as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.993714] ACPI: Sleep Button [SLPB]
[    0.993815] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.993823] ACPI: Power Button [PWRF]
[    0.998716] Monitor-Mwait will be used to enter C-1 state
[    0.998827] Monitor-Mwait will be used to enter C-2 state
[    0.998929] Monitor-Mwait will be used to enter C-3 state
[    0.999024] Monitor-Mwait will be used to enter C-3 state
[    0.999070] ACPI: acpi_idle registered with cpuidle
[    1.009043] GHES: HEST is not enabled!
[    1.009277] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.029853] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.050447] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.074023] 00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.094740] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.095398] Linux agpgart interface v0.103
[    1.099090] brd: module loaded
[    1.101055] loop: module loaded
[    1.102071] Fixed MDIO Bus: probed
[    1.102119] tun: Universal TUN/TAP device driver, 1.6
[    1.102123] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.102289] PPP generic driver version 2.4.2
[    1.102549] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.102621] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.102629] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.102732] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 1
[    1.102773] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    1.102791] ehci_hcd 0000:00:1d.7: debug port 1
[    1.106695] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.106732] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x80600000
[    1.115888] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.116255] hub 1-0:1.0: USB hub found
[    1.116266] hub 1-0:1.0: 8 ports detected
[    1.116442] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.116471] uhci_hcd: USB Universal Host Controller Interface driver
[    1.116522] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.116530] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.116666] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    1.116715] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00003080
[    1.117046] hub 2-0:1.0: USB hub found
[    1.117056] hub 2-0:1.0: 2 ports detected
[    1.117201] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.117209] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.117359] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 3
[    1.117429] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003060
[    1.117758] hub 3-0:1.0: USB hub found
[    1.117769] hub 3-0:1.0: 2 ports detected
[    1.117913] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.117920] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.118052] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 4
[    1.118110] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00003040
[    1.118449] hub 4-0:1.0: USB hub found
[    1.118460] hub 4-0:1.0: 2 ports detected
[    1.118602] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    1.118610] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.118734] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 5
[    1.118806] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00003020
[    1.119140] hub 5-0:1.0: USB hub found
[    1.119150] hub 5-0:1.0: 2 ports detected
[    1.119404] usbcore: registered new interface driver libusual
[    1.119498] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.122193] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.122208] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.122565] mousedev: PS/2 mouse device common for all mice
[    1.122947] rtc_cmos 00:07: RTC can wake from S4
[    1.123142] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    1.123184] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.123377] device-mapper: uevent: version 1.0.3
[    1.123573] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19)
initialised: dm-devel@redhat.com
[    1.123805] cpuidle: using governor ladder
[    1.124141] cpuidle: using governor menu
[    1.124146] EFI Variables Facility v0.08 2004-May-17
[    1.124700] TCP cubic registered
[    1.124971] NET: Registered protocol family 10
[    1.126244] NET: Registered protocol family 17
[    1.126291] Registering the dns_resolver key type
[    1.126687] PM: Hibernation image not present or could not be loaded.
[    1.126717] registered taskstats version 1
[    1.140706]   Magic number: 4:224:962
[    1.140814] memory memory13: hash matches
[    1.140892] rtc_cmos 00:07: setting system clock to 2012-03-24
00:57:24 UTC (1332550644)
[    1.143137] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.143144] EDD information not available.
[    1.147772] Freeing unused kernel memory: 912k freed
[    1.148306] Write protecting the kernel read-only data: 12288k
[    1.162561] Freeing unused kernel memory: 1592k freed
[    1.174229] Freeing unused kernel memory: 1220k freed
[    1.215642] udev: starting version 151
[    1.215832] udevd (107): /proc/107/oom_adj is deprecated, please
use /proc/107/oom_score_adj instead.
[    1.273330] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    1.273339] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    1.273403] e1000e 0000:01:00.0: Disabling ASPM L0s
[    1.273865] e1000e 0000:01:00.0: irq 41 for MSI/MSI-X
[    1.273889] e1000e 0000:01:00.0: irq 42 for MSI/MSI-X
[    1.273909] e1000e 0000:01:00.0: irq 43 for MSI/MSI-X
[    1.404215] e1000e 0000:01:00.0: eth0: (PCI Express:2.5GT/s:Width
x1) 00:22:4d:7b:39:21
[    1.404225] e1000e 0000:01:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    1.404247] e1000e 0000:01:00.0: eth0: MAC: 3, PHY: 8, PBA No: FFFFFF-0FF
[    1.487567] usb 1-8: new high-speed USB device number 3 using ehci_hcd
[    1.620347] hub 1-8:1.0: USB hub found
[    1.620543] hub 1-8:1.0: 4 ports detected
[    1.863216] usb 3-2: new low-speed USB device number 2 using uhci_hcd
[    1.939126] Refined TSC clocksource calibration: 1866.732 MHz.
[    1.939148] Switching to clocksource tsc
[    2.521576] input: Dell Dell USB Keyboard as
/devices/pci0000:00/0000:00:1d.1/usb3/3-2/3-2:1.0/input/input3
[    2.521860] generic-usb 0003:413C:2003.0001: input,hidraw0: USB HID
v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.1-2/input0
[    2.521904] usbcore: registered new interface driver usbhid
[    2.521909] usbhid: USB HID core driver
[    2.642559] usb 1-8.2: new high-speed USB device number 4 using ehci_hcd
[    2.979949] Initializing USB Mass Storage driver...
[    2.980357] scsi0 : usb-storage 1-8.2:1.0
[    2.980644] usbcore: registered new interface driver usb-storage
[    2.980653] USB Mass Storage support registered.
[    2.982648] usbcore: registered new interface driver uas
[    4.367010] scsi 0:0:0:0: Direct-Access     Corsair  Voyager
  1100 PQ: 0 ANSI: 0 CCS
[    4.369183] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.369555] sd 0:0:0:0: [sda] 31690752 512-byte logical blocks:
(16.2 GB/15.1 GiB)
[    4.370176] sd 0:0:0:0: [sda] Write Protect is off
[    4.370187] sd 0:0:0:0: [sda] Mode Sense: 43 00 00 00
[    4.370780] sd 0:0:0:0: [sda] No Caching mode page present
[    4.370800] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    4.374962] sd 0:0:0:0: [sda] No Caching mode page present
[    4.374998] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    4.375886]  sda: sda1
[    4.378671] sd 0:0:0:0: [sda] No Caching mode page present
[    4.378695] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    4.378713] sd 0:0:0:0: [sda] Attached SCSI removable disk
[    9.467071] EXT4-fs (sda1): mounted filesystem with ordered data
mode. Opts: (null)
[   12.366195] udev: starting version 151
[   12.408656] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[   12.480909] lp: driver loaded but no devices found
[   12.520465] w83627ehf: Found W83627DHG-P chip at 0x290
[   13.033346] type=1400 audit(1332550656.400:2): apparmor="STATUS"
operation="profile_load" name="/sbin/dhclient3" pid=466
comm="apparmor_parser"
[   13.033546] type=1400 audit(1332550656.400:3): apparmor="STATUS"
operation="profile_load"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=466
comm="apparmor_parser"
[   13.033702] type=1400 audit(1332550656.400:4): apparmor="STATUS"
operation="profile_load"
name="/usr/lib/connman/scripts/dhclient-script" pid=466
comm="apparmor_parser"
[   13.166824] type=1400 audit(1332550656.532:5): apparmor="STATUS"
operation="profile_replace" name="/sbin/dhclient3" pid=506
comm="apparmor_parser"
[   13.167048] type=1400 audit(1332550656.532:6): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=506
comm="apparmor_parser"
[   13.167207] type=1400 audit(1332550656.532:7): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/connman/scripts/dhclient-script" pid=506
comm="apparmor_parser"
[   13.198429] type=1400 audit(1332550656.564:8): apparmor="STATUS"
operation="profile_load" name="/usr/sbin/ntpd" pid=544
comm="apparmor_parser"
[   13.307634] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   13.383530] type=1400 audit(1332550656.752:9): apparmor="STATUS"
operation="profile_replace" name="/usr/sbin/ntpd" pid=550
comm="apparmor_parser"
[   13.389562] type=1400 audit(1332550656.756:10): apparmor="STATUS"
operation="profile_replace" name="/sbin/dhclient3" pid=541
comm="apparmor_parser"
[   13.389791] type=1400 audit(1332550656.756:11): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=541
comm="apparmor_parser"
[   14.151695] ip_tables: (C) 2000-2006 Netfilter Core Team
[   14.218467] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   14.563283] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   14.597018] NET: Registered protocol family 15
[   14.660135] 8021q: 802.1Q VLAN Support v1.8
[   14.660178] 8021q: adding VLAN 0 to HW filter on device eth0
[   14.698278] ADDRCONF(NETDEV_UP): eth0.3: link is not ready
[   15.516161] IPv6 over IPv4 tunneling driver
[   16.024704] ADDRCONF(NETDEV_UP): eth0.2: link is not ready
[   16.285261] device eth0 entered promiscuous mode
[   16.801754] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: None
[   16.802689] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   16.803664] ADDRCONF(NETDEV_CHANGE): eth0.2: link becomes ready
[   16.804654] ADDRCONF(NETDEV_CHANGE): eth0.3: link becomes ready
[   18.818209] GRE over IPv4 demultiplexor driver
[   18.821137] GRE over IPv4 tunneling driver
[   18.854013] ipv6: addrconf_gre_config(gre1)
[   19.017644] ADDRCONF(NETDEV_UP): tun0: link is not ready
[   38.453266] ADDRCONF(NETDEV_CHANGE): tun0: link becomes ready
[   49.713366] Initializing XFRM netlink socket
[   51.040832] padlock_sha: VIA PadLock Hash Engine not detected.
[   51.064463] Intel AES-NI instructions are not detected.
[   73.332618] [drm] Initialized drm 1.1.0 20060810
[   73.373395] [drm:i915_init] *ERROR* drm/i915 can't work without
intel_agp module!
