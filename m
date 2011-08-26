Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab1HZMoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:44:24 -0400
Received: from gold.linx.net ([195.66.232.40]:54324 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab1HZMoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:44:21 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Aug 2011 08:44:20 EDT
Message-ID: <4E579397.6010009@linx.net>
Date: Fri, 26 Aug 2011 13:37:43 +0100
From: Tony Vroon <tony@linx.net>
Organization: London Internet Exchange (LINX; AS5459)
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110822 Thunderbird/6.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        suresh.b.siddha@intel.com
Subject: MTRR setup failure on Fujitsu Lifebook S761
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On this Sandy Bridge-based machine, the following errors appear in dmesg:
mtrr: type mismatch for d0000000,10000000 old: write-back new:
write-combining
[drm] MTRR allocation failed.  Graphics performance may suffer.

This promise is kept. Graphics stall often, occasionally reporting:
[drm:i915_hangcheck_ring_idle] *ERROR* Hangcheck timer elapsed...
render ring idle [waiting on 84667, at 84667], missed IRQ?

A BIOS upgrade from 1.14 to 1.15 was successful, but failed to
alleviate the MTRR problems.
I believe the kernel is configured appropriately:
adrastea ~ # zgrep -i mtrr /proc/config.gz
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1

The contents of /proc/mtrr are:
reg00: base=0x0ffc00000 ( 4092MB), size=    4MB, count=1: write-protect
reg01: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg02: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
reg03: base=0x0c0000000 ( 3072MB), size=  512MB, count=1: write-back
reg04: base=0x0d0000000 ( 3328MB), size=  256MB, count=1: uncachable
reg05: base=0x0cc000000 ( 3264MB), size=   64MB, count=1: uncachable
reg06: base=0x0cb000000 ( 3248MB), size=   16MB, count=1: uncachable
reg07: base=0x0cac00000 ( 3244MB), size=    4MB, count=1: uncachable
reg08: base=0x100000000 ( 4096MB), size= 1024MB, count=1: write-back
reg09: base=0x130000000 ( 4864MB), size=  256MB, count=1: uncachable

I was able to make things a little bit better with the following script:
adrastea ~ # cat /usr/sbin/mtrr.sh
#!/bin/bash
echo "disable=3" >| /proc/mtrr
echo "disable=4" >| /proc/mtrr
echo "disable=5" >| /proc/mtrr
echo "disable=6" >| /proc/mtrr
echo "disable=7" >| /proc/mtrr
echo "disable=8" >| /proc/mtrr
echo "base=0xc0000000 size=0x10000000 type=write-back" >| /proc/mtrr
echo "base=0xd0000000 size=0x10000000 type=write-combining" >| /proc/mtrr
echo "base=0x100000000 size=0x40000000 type=write-back" >| /proc/mtrr

After the script, the MTRR situation looks as follows:
reg00: base=0x0ffc00000 ( 4092MB), size=    4MB, count=1: write-protect
reg01: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg02: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
reg03: base=0x0c0000000 ( 3072MB), size=  256MB, count=1: write-back
reg04: base=0x0d0000000 ( 3328MB), size=  256MB, count=1: write-combining
reg05: base=0x100000000 ( 4096MB), size= 1024MB, count=1: write-back
reg09: base=0x130000000 ( 4864MB), size=  256MB, count=1: uncachable

Full dmesg:
Initializing cgroup subsys cpu
Linux version 3.1.0-rc3-00161-g671ee7f (root@adrastea) (gcc version
4.5.3 (Gentoo 4.5.3-r1 p1.0, pie-0.4.5) ) #1 SMP PREEMPT Fri Aug 26
08:46:08 BST 2011
Command line: auto BOOT_IMAGE=3.1.0-rc3-00161 rw root=0
Disabled fast string operations
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
 BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000ca98f000 (usable)
 BIOS-e820: 00000000ca98f000 - 00000000cae9f000 (reserved)
 BIOS-e820: 00000000cae9f000 - 00000000caf9f000 (ACPI NVS)
 BIOS-e820: 00000000caf9f000 - 00000000cafff000 (ACPI data)
 BIOS-e820: 00000000cafff000 - 00000000cb000000 (usable)
 BIOS-e820: 00000000cb000000 - 00000000cfa00000 (reserved)
 BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed10000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffda0000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000012e600000 (usable)
NX (Execute Disable) protection: active
DMI 2.6 present.
DMI: FUJITSU LIFEBOOK S761/FJNB225, BIOS Version 1.15 07/05/2011
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==>
(reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x12e600 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0FFC00000 mask FFFC00000 write-protect
  1 base 000000000 mask F80000000 write-back
  2 base 080000000 mask FC0000000 write-back
  3 base 0C0000000 mask FE0000000 write-back
  4 base 0D0000000 mask FF0000000 uncachable
  5 base 0CC000000 mask FFC000000 uncachable
  6 base 0CB000000 mask FFF000000 uncachable
  7 base 100000000 mask FC0000000 write-back
  8 base 130000000 mask FF0000000 uncachable
  9 base 12F000000 mask FFF000000 uncachable
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xcb000 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff88000009b000] 9b000 size 8192
init_memory_mapping: 0000000000000000-00000000cb000000
 0000000000 - 00cb000000 page 2M
kernel direct mapping tables up to cb000000 @ ca98a000-ca98f000
init_memory_mapping: 0000000100000000-000000012e600000
 0100000000 - 012e600000 page 2M
kernel direct mapping tables up to 12e600000 @ 12e5fa000-12e600000
ACPI: RSDP 00000000000f00e0 00024 (v02 FUJ   )
ACPI: XSDT 00000000caffe120 0009C (v01 FUJ    PC       010F0000 FUJ
00000001)
ACPI: FACP 00000000cafef000 000F4 (v03 FUJ    PC       010F0000 FUJ
00000001)
ACPI: DSDT 00000000caff2000 08F68 (v02 FUJ    FJNB225  010F0000 INTL
20061109)
ACPI: FACS 00000000caf43000 00040
ACPI: SSDT 00000000caffd000 00429 (v01 FUJ    SataAhci 00000001 INTL
20061109)
ACPI: SSDT 00000000caffc000 002EE (v01 FUJ    BayAhci1 00000001 INTL
20061109)
ACPI: SSDT 00000000caffb000 000B6 (v02 FUJ    DockSsdt 00000001 INTL
20061109)
ACPI: HPET 00000000cafee000 00038 (v01 FUJ    PC       00000001 PTL
00000001)
ACPI: APIC 00000000cafed000 00098 (v01 FUJ    PC       00000001 PTL
00000001)
ACPI: MCFG 00000000cafec000 0003C (v01 FUJ    PC       00000001 PTL
00000001)
ACPI: ASF! 00000000caff1000 000A5 (v32 FUJ    PC       00000001 PTL
00000001)
ACPI: TCPA 00000000cafeb000 00032 (v02    PTL  CRESTLN 06040000
00005A52)
ACPI: SSDT 00000000cafea000 00804 (v01  PmRef  Cpu0Ist 00003000 INTL
20061109)
ACPI: SSDT 00000000cafe9000 009F5 (v01  PmRef    CpuPm 00003000 INTL
20061109)
ACPI: UEFI 00000000cafe8000 0003E (v01 FUJ    PC       00000001 PTL
00000001)
ACPI: UEFI 00000000cafe7000 00042 (v01 PTL      COMBUF 00000001 PTL
00000001)
ACPI: DMAR 00000000cafe6000 000E8 (v01 INTEL      SNB  00000001 INTL
00000001)
ACPI: UEFI 00000000cafe5000 00256 (v01 FUJ    PC       00000001 PTL
00000001)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea0004bfffff] PMD ->
[ffff880129c00000-ffff88012dbfffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x0012e600
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0: 0x00000010 -> 0x0000009d
    0: 0x00000100 -> 0x000ca98f
    0: 0x000cafff -> 0x000cb000
    0: 0x00100000 -> 0x0012e600
On node 0 totalpages: 1019677
  DMA zone: 64 pages used for memmap
  DMA zone: 2 pages reserved
  DMA zone: 3915 pages, LIFO batch:0
  DMA32 zone: 16320 pages used for memmap
  DMA32 zone: 809424 pages, LIFO batch:31
  Normal zone: 2968 pages used for memmap
  Normal zone: 186984 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
8 Processors exceeds NR_CPUS limit of 4
SMP: Allowing 4 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
Allocating PCI resources starting at cfa00000 (gap: cfa00000:28600000)
setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 22 pages/cpu @ffff88012e200000 s69568 r0 d20544 u524288
pcpu-alloc: s69568 r0 d20544 u524288 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3
Built 1 zonelists in Zone order, mobility grouping on.  Total pages:
1000323
Kernel command line: auto BOOT_IMAGE=3.1.0-rc3-00161 rw root=0
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
Checking aperture...
No AGP bridge found
Queued invalidation will be enabled to support x2apic and Intr-remapping.
Memory: 3930972k/4954112k available (4912k kernel code, 875404k
absent, 147736k reserved, 2744k data, 1388k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Preemptible hierarchical RCU implementation.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:384
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2691.220 MHz processor.
Calibrating delay loop (skipped), value calculated using timer
frequency.. 5382.44 BogoMIPS (lpj=2691220)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
Disabled fast string operations
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
mce: CPU supports 7 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
ACPI: Core revision 20110623
DMAR: Host address width 36
DMAR: DRHD base: 0x000000fed90000 flags: 0x0
IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
DMAR: DRHD base: 0x000000fed91000 flags: 0x1
IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
DMAR: RMRR base: 0x000000cadc7000 end: 0x000000cadddfff
DMAR: RMRR base: 0x000000cb800000 end: 0x000000cf9fffff
IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
HPET id 0 under DRHD base 0xfed91000
HPET id 0 under DRHD base 0xfed91000
HPET id 0 under DRHD base 0xfed91000
HPET id 0 under DRHD base 0xfed91000
HPET id 0 under DRHD base 0xfed91000
HPET id 0 under DRHD base 0xfed91000
HPET id 0 under DRHD base 0xfed91000
HPET id 0 under DRHD base 0xfed91000
Enabled Interrupt-remapping
Enabling x2apic
Enabled x2apic
Switched APIC routing to cluster x2apic.
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM) i7-2620M CPU @ 2.70GHz stepping 07
Performance Events: PEBS fmt1+, SandyBridge events, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
Booting Node   0, Processors  #1
smpboot cpu 1: start_ip = 9b000
Disabled fast string operations
 #2
smpboot cpu 2: start_ip = 9b000
Disabled fast string operations
 #3 Ok.
smpboot cpu 3: start_ip = 9b000
Disabled fast string operations
Brought up 4 CPUs
Total of 4 processors activated (21528.10 BogoMIPS).
devtmpfs: initialized
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
0xf8000000-0xfbffffff] (base 0xf8000000)
PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
ACPI: SSDT 00000000cae99698 00652 (v02 FUJ    VistSsdt 00000001 INTL
20061109)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00652 (v02 FUJ    VistSsdt 00000001 INTL
20061109)
ACPI: SSDT 00000000cadc0818 007A9 (v01  PmRef  Cpu0Cst 00003001 INTL
20061109)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 007A9 (v01  PmRef  Cpu0Cst 00003001 INTL
20061109)
ACPI: SSDT 00000000cadc1a98 00303 (v01  PmRef    ApIst 00003000 INTL
20061109)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL
20061109)
ACPI: SSDT 00000000cae9dc18 00119 (v01  PmRef    ApCst 00003000 INTL
20061109)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL
20061109)
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: ACPI Dock Station Driver: 2 docks/bays found
PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0xcfa00000-0xfeafffff]
pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
pci 0000:00:00.0: [8086:0104] type 0 class 0x000600
pci 0000:00:02.0: [8086:0126] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xe0000000-0xe03fffff 64bit]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:02.0: reg 20: [io  0x3000-0x303f]
pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
pci 0000:00:16.0: reg 10: [mem 0xe2725000-0xe272500f 64bit]
pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
pci 0000:00:16.0: PME# disabled
pci 0000:00:16.3: [8086:1c3d] type 0 class 0x000700
pci 0000:00:16.3: reg 10: [io  0x30b0-0x30b7]
pci 0000:00:16.3: reg 14: [mem 0xe272c000-0xe272cfff]
pci 0000:00:19.0: [8086:1502] type 0 class 0x000200
pci 0000:00:19.0: reg 10: [mem 0xe2700000-0xe271ffff]
pci 0000:00:19.0: reg 14: [mem 0xe272b000-0xe272bfff]
pci 0000:00:19.0: reg 18: [io  0x3080-0x309f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
pci 0000:00:1a.0: reg 10: [mem 0xe272a000-0xe272a3ff]
pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.0: PME# disabled
pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0xe2720000-0xe2723fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.2: [8086:1c14] type 1 class 0x000604
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.3: [8086:1c16] type 1 class 0x000604
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1c.4: [8086:1c18] type 1 class 0x000604
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.7: [8086:1c1e] type 1 class 0x000604
pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.7: PME# disabled
pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
pci 0000:00:1d.0: reg 10: [mem 0xe2729000-0xe27293ff]
pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: PME# disabled
pci 0000:00:1f.0: [8086:1c4f] type 0 class 0x000601
pci 0000:00:1f.2: [8086:1c03] type 0 class 0x000106
pci 0000:00:1f.2: reg 10: [io  0x30a8-0x30af]
pci 0000:00:1f.2: reg 14: [io  0x30bc-0x30bf]
pci 0000:00:1f.2: reg 18: [io  0x30a0-0x30a7]
pci 0000:00:1f.2: reg 1c: [io  0x30b8-0x30bb]
pci 0000:00:1f.2: reg 20: [io  0x3060-0x307f]
pci 0000:00:1f.2: reg 24: [mem 0xe2728000-0xe27287ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
pci 0000:00:1f.3: reg 10: [mem 0xe2724000-0xe27240ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
pci 0000:00:1c.0: PCI bridge to [bus 01-01]
pci 0000:02:00.0: [8086:0082] type 0 class 0x000280
pci 0000:02:00.0: reg 10: [mem 0xe2600000-0xe2601fff 64bit]
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:1c.2: PCI bridge to [bus 02-02]
pci 0000:00:1c.2:   bridge window [mem 0xe2600000-0xe26fffff]
pci 0000:03:00.0: [1033:0194] type 0 class 0x000c03
pci 0000:03:00.0: reg 10: [mem 0xe2500000-0xe2501fff 64bit]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:00:1c.3: PCI bridge to [bus 03-03]
pci 0000:00:1c.3:   bridge window [mem 0xe2500000-0xe25fffff]
pci 0000:00:1c.4: PCI bridge to [bus 04-0c]
pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.4:   bridge window [mem 0xe0500000-0xe24fffff]
pci 0000:0d:00.0: [1217:8221] type 0 class 0x000805
pci 0000:0d:00.0: reg 10: [mem 0xe0402000-0xe04021ff]
pci 0000:0d:00.0: supports D1 D2
pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:0d:00.0: PME# disabled
pci 0000:00:1c.7: PCI bridge to [bus 0d-0d]
pci 0000:00:1c.7:   bridge window [mem 0xe0400000-0xe04fffff]
pci 0000:00:1c.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:00:1c.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:00:1c.2: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:00:1c.2: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:02:00.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:02:00.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:00:1c.3: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:00:1c.3: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:03:00.0: Dev MPS 128 MPSS 128 MRRS 512
pci 0000:03:00.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:00:1c.4: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:00:1c.4: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:00:1c.7: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:00:1c.7: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:0d:00.0: Dev MPS 128 MPSS 128 MRRS 512
pci 0000:0d:00.0: Dev MPS 128 MPSS 128 MRRS 128
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control
mask: 0x1d
ACPI _OSC control for PCIe not granted, disabling ASPM
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 *7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Advanced Linux Sound Architecture Driver Version 1.0.24.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009d800 - 000000000009ffff
reserve RAM buffer: 00000000ca98f000 - 00000000cbffffff
reserve RAM buffer: 00000000cb000000 - 00000000cbffffff
reserve RAM buffer: 000000012e600000 - 000000012fffffff
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
cfg80211: Calling CRDA to update world regulatory domain
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
hpet0: 8 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-3e]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000c0000-0x000c3fff window]
pnp 00:00: [mem 0x000c4000-0x000c7fff window]
pnp 00:00: [mem 0x000c8000-0x000cbfff window]
pnp 00:00: [mem 0x000cc000-0x000cffff window]
pnp 00:00: [mem 0x000d0000-0x000d3fff window]
pnp 00:00: [mem 0x000d4000-0x000d7fff window]
pnp 00:00: [mem 0x000d8000-0x000dbfff window]
pnp 00:00: [mem 0x000dc000-0x000dffff window]
pnp 00:00: [mem 0x000e0000-0x000e3fff window]
pnp 00:00: [mem 0x000e4000-0x000e7fff window]
pnp 00:00: [mem 0x000e8000-0x000ebfff window]
pnp 00:00: [mem 0x000ec000-0x000effff window]
pnp 00:00: [mem 0x000f0000-0x000fffff window]
pnp 00:00: [mem 0xcfa00000-0xfeafffff window]
pnp 00:00: [mem 0xfed40000-0xfed44fff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
pnp 00:01: [mem 0xfed10000-0xfed17fff]
pnp 00:01: [mem 0xfed18000-0xfed18fff]
pnp 00:01: [mem 0xfed19000-0xfed19fff]
pnp 00:01: [mem 0xf8000000-0xfbffffff]
pnp 00:01: [mem 0xfed20000-0xfed3ffff]
pnp 00:01: [mem 0xfed90000-0xfed93fff]
pnp 00:01: [mem 0xfed40000-0xfed3ffff disabled]
pnp 00:01: [mem 0xfed45000-0xfed8ffff]
pnp 00:01: [mem 0xff000000-0xffffffff]
pnp 00:01: [mem 0xfee00000-0xfeefffff]
pnp 00:01: [mem 0xfef00000-0xfeffffff]
pnp 00:01: [mem 0xfed08000-0xfed08fff]
system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:01: [mem 0xfed10000-0xfed17fff] has been reserved
system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:01: [mem 0xfed90000-0xfed93fff] has been reserved
system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
system 00:01: [mem 0xff000000-0xffffffff] could not be reserved
system 00:01: [mem 0xfee00000-0xfeefffff] could not be reserved
system 00:01: [mem 0xfef00000-0xfeffffff] has been reserved
system 00:01: [mem 0xfed08000-0xfed08fff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #3
Switched to NOHz mode on CPU #2
Switched to NOHz mode on CPU #1
pnp 00:02: [io  0x0010-0x001f]
pnp 00:02: [io  0x0024-0x0025]
pnp 00:02: [io  0x0028-0x0029]
pnp 00:02: [io  0x002c-0x002d]
pnp 00:02: [io  0x002e-0x002f]
pnp 00:02: [io  0x0030-0x0031]
pnp 00:02: [io  0x0034-0x0035]
pnp 00:02: [io  0x0038-0x0039]
pnp 00:02: [io  0x003c-0x003d]
pnp 00:02: [io  0x004e-0x004f]
pnp 00:02: [io  0x0050-0x0053]
pnp 00:02: [io  0x0061]
pnp 00:02: [io  0x0063]
pnp 00:02: [io  0x0065]
pnp 00:02: [io  0x0067]
pnp 00:02: [io  0x0072-0x0077]
pnp 00:02: [io  0x0080]
pnp 00:02: [io  0x0090-0x009f]
pnp 00:02: [io  0x0092]
pnp 00:02: [io  0x00a4-0x00a5]
pnp 00:02: [io  0x00a8-0x00a9]
pnp 00:02: [io  0x00ac-0x00ad]
pnp 00:02: [io  0x00b0-0x00b1]
pnp 00:02: [io  0x00b2-0x00b3]
pnp 00:02: [io  0x00b4-0x00b5]
pnp 00:02: [io  0x00b8-0x00b9]
pnp 00:02: [io  0x00bc-0x00bd]
pnp 00:02: [io  0x0400-0x047f]
pnp 00:02: [io  0x0480-0x048f]
pnp 00:02: [io  0x04d0-0x04d1]
pnp 00:02: [io  0x0500-0x057f]
pnp 00:02: [io  0x1640-0x164f]
pnp 00:02: [io  0xf800-0xf87f]
pnp 00:02: [io  0xf880-0xf8ff]
pnp 00:02: [io  0xfc00-0xfc7f]
pnp 00:02: [io  0xfc80-0xfcff]
pnp 00:02: [io  0xfd00-0xfd7f]
pnp 00:02: [io  0x1000-0x1003]
pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
system 00:02: [io  0x0400-0x047f] has been reserved
system 00:02: [io  0x0480-0x048f] has been reserved
system 00:02: [io  0x04d0-0x04d1] has been reserved
system 00:02: [io  0x0500-0x057f] has been reserved
system 00:02: [io  0x1640-0x164f] has been reserved
system 00:02: [io  0xf800-0xf87f] has been reserved
system 00:02: [io  0xf880-0xf8ff] has been reserved
system 00:02: [io  0xfc00-0xfc7f] has been reserved
system 00:02: [io  0xfc80-0xfcff] has been reserved
system 00:02: [io  0xfd00-0xfd7f] has been reserved
system 00:02: [io  0x1000-0x1003] has been reserved
system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:03: [io  0x0000-0x001f]
pnp 00:03: [io  0x0081-0x0091]
pnp 00:03: [io  0x0093-0x009f]
pnp 00:03: [io  0x00c0-0x00df]
pnp 00:03: [dma 4]
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:04: [io  0x0060]
pnp 00:04: [io  0x0064]
pnp 00:04: [irq 1]
pnp 00:04: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:05: [io  0x00f0]
pnp 00:05: [irq 13]
pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:06: [irq 12]
pnp 00:06: Plug and Play ACPI device, IDs SYN1f02 PNP0f13 (active)
pnp 00:07: [io  0x0070-0x0077]
pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:08: [io  0x0061]
pnp 00:08: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:09: [irq 0 disabled]
pnp 00:09: [irq 8]
pnp 00:09: [mem 0xfed00000-0xfed003ff]
system 00:09: [mem 0xfed00000-0xfed003ff] has been reserved
system 00:09: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
pnp 00:0a: [io  0x03f8-0x03ff]
pnp 00:0a: [irq 4]
pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:0b: [io  0x0378-0x037f]
pnp 00:0b: [io  0x0778-0x077b]
pnp 00:0b: [irq 7]
pnp 00:0b: [dma 1]
pnp 00:0b: Plug and Play ACPI device, IDs PNP0401 (active)
pnp 00:0c: [mem 0xfed40000-0xfed44fff]
pnp 00:0c: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PCI: max bus depth: 1 pci_try_num: 2
pci 0000:00:1c.4: BAR 9: assigned [mem 0xcfa00000-0xcfbfffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 01-01]
pci 0000:00:1c.2: PCI bridge to [bus 02-02]
pci 0000:00:1c.2:   bridge window [mem 0xe2600000-0xe26fffff]
pci 0000:00:1c.3: PCI bridge to [bus 03-03]
pci 0000:00:1c.3:   bridge window [mem 0xe2500000-0xe25fffff]
pci 0000:00:1c.4: PCI bridge to [bus 04-0c]
pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.4:   bridge window [mem 0xe0500000-0xe24fffff]
pci 0000:00:1c.4:   bridge window [mem 0xcfa00000-0xcfbfffff 64bit pref]
pci 0000:00:1c.7: PCI bridge to [bus 0d-0d]
pci 0000:00:1c.7:   bridge window [mem 0xe0400000-0xe04fffff]
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1c.7: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.7: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0xcfa00000-0xfeafffff]
pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
pci_bus 0000:02: resource 1 [mem 0xe2600000-0xe26fffff]
pci_bus 0000:03: resource 1 [mem 0xe2500000-0xe25fffff]
pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:04: resource 1 [mem 0xe0500000-0xe24fffff]
pci_bus 0000:04: resource 2 [mem 0xcfa00000-0xcfbfffff 64bit pref]
pci_bus 0000:0d: resource 1 [mem 0xe0400000-0xe04fffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 64 bytes, default 64
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff8800c698a000 - ffff8800ca98a000
software IO TLB at phys 0xc698a000 - 0xca98a000
microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x17
microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x17
microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x17
microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x17
microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
audit: initializing netlink socket (disabled)
type=2000 audit(1314344977.636:1): initialized
NTFS driver 2.1.30 [Flags: R/O].
fuse init (API version 7.17)
msgmni has been set to 7677
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler cfq registered (default)
intel_idle: MWAIT substates: 0x21120
intel_idle: v0.4 model 0x2A
intel_idle: lapic_timer_reliable_states 0xffffffff
ACPI: AC Adapter [AC] (on-line)
input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID]
input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button [PWRB]
input: Sleep Button as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
ACPI: Power Button [PWRF]
ACPI: acpi_idle yielding to intel_idle
Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial 0000:00:16.3: PCI INT C -> GSI 19 (level, low) -> IRQ 19
0000:00:16.3: ttyS1 at I/O 0x30b0 (irq = 19) is a 16550A
lp: driver loaded but no devices found
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K
mappable
agpgart-intel 0000:00:00.0: detected 65536K stolen memory
ACPI: Battery Slot [CMB1] (battery present)
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
tpm_tis 00:0c: 1.2 TPM (device-id 0xB, rev-id 16)
ACPI: Battery Slot [CMB2] (battery present)
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
mtrr: type mismatch for d0000000,10000000 old: write-back new:
write-combining
[drm] MTRR allocation failed.  Graphics performance may suffer.
i915 0000:00:02.0: irq 42 for MSI/MSI-X
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
vgaarb: device changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
- ------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x8c/0xa0()
Hardware name: LIFEBOOK S761
sysfs: cannot create duplicate filename
'/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/intel_backlight'
Pid: 1, comm: swapper Not tainted 3.1.0-rc3-00161-g671ee7f #1
Call Trace:
 [<ffffffff8103d30a>] warn_slowpath_common+0x7b/0x93
 [<ffffffff8103d37a>] warn_slowpath_fmt+0x41/0x43
 [<ffffffff81101b54>] sysfs_add_one+0x8c/0xa0
 [<ffffffff81101bd9>] create_dir+0x71/0xa9
 [<ffffffff81101d0a>] sysfs_create_dir+0x8f/0xa6
 [<ffffffff811aaca3>] kobject_add_internal+0xdf/0x1f0
 [<ffffffff811aaec2>] kobject_add+0x91/0xa2
 [<ffffffff8128c396>] device_add+0xc9/0x563
 [<ffffffff810afe6b>] ? __kmalloc+0x35/0xb3
 [<ffffffff8128c849>] device_register+0x19/0x1d
 [<ffffffff811e0afe>] backlight_device_register+0x106/0x175
 [<ffffffff8127b04f>] intel_panel_setup_backlight+0x78/0xcd
 [<ffffffff81271335>] intel_modeset_init+0xd5a/0xe34
 [<ffffffff812572f8>] i915_driver_load+0x8c9/0xd97
 [<ffffffff8128c849>] ? device_register+0x19/0x1d
 [<ffffffff8124786e>] ? drm_get_minor+0x1fa/0x24c
 [<ffffffff81249b33>] drm_get_pci_dev+0x163/0x268
 [<ffffffff814c7882>] ? _raw_spin_unlock_irqrestore+0x20/0x2b
 [<ffffffff814b8e34>] i915_pci_probe+0x1b/0x1d
 [<ffffffff811c73ae>] local_pci_probe+0x3f/0x70
 [<ffffffff811c7cbc>] pci_device_probe+0x65/0x99
 [<ffffffff81102299>] ? sysfs_create_link+0xe/0x10
 [<ffffffff8128ed4b>] driver_probe_device+0xbc/0x156
 [<ffffffff8128ee3d>] __driver_attach+0x58/0x7b
 [<ffffffff8128ede5>] ? driver_probe_device+0x156/0x156
 [<ffffffff8128dd8f>] bus_for_each_dev+0x51/0x7f
 [<ffffffff8128ef54>] driver_attach+0x19/0x1b
 [<ffffffff8128e33f>] bus_add_driver+0xab/0x1f3
 [<ffffffff8128f49d>] driver_register+0x96/0x105
 [<ffffffff811c7a4d>] __pci_register_driver+0x51/0xbd
 [<ffffffff81249cbd>] drm_pci_init+0x85/0xea
 [<ffffffff817b0c08>] ? drm_core_init+0x112/0x112
 [<ffffffff817b0c93>] i915_init+0x8b/0x8d
 [<ffffffff8178db66>] do_one_initcall+0x7a/0x129
 [<ffffffff8178dcad>] kernel_init+0x98/0x118
 [<ffffffff81035d1e>] ? schedule_tail+0x2c/0x5b
 [<ffffffff814c9634>] kernel_thread_helper+0x4/0x10
 [<ffffffff8178dc15>] ? do_one_initcall+0x129/0x129
 [<ffffffff814c9630>] ? gs_change+0xb/0xb
- ---[ end trace 0f70f2608cc8dd54 ]---
kobject_add_internal failed for intel_backlight with -EEXIST, don't
try to register things with the same name in the same directory.
Pid: 1, comm: swapper Tainted: G        W   3.1.0-rc3-00161-g671ee7f #1
Call Trace:
 [<ffffffff811aad96>] kobject_add_internal+0x1d2/0x1f0
 [<ffffffff811aaec2>] kobject_add+0x91/0xa2
 [<ffffffff8128c396>] device_add+0xc9/0x563
 [<ffffffff810afe6b>] ? __kmalloc+0x35/0xb3
 [<ffffffff8128c849>] device_register+0x19/0x1d
 [<ffffffff811e0afe>] backlight_device_register+0x106/0x175
 [<ffffffff8127b04f>] intel_panel_setup_backlight+0x78/0xcd
 [<ffffffff81271335>] intel_modeset_init+0xd5a/0xe34
 [<ffffffff812572f8>] i915_driver_load+0x8c9/0xd97
 [<ffffffff8128c849>] ? device_register+0x19/0x1d
 [<ffffffff8124786e>] ? drm_get_minor+0x1fa/0x24c
 [<ffffffff81249b33>] drm_get_pci_dev+0x163/0x268
 [<ffffffff814c7882>] ? _raw_spin_unlock_irqrestore+0x20/0x2b
 [<ffffffff814b8e34>] i915_pci_probe+0x1b/0x1d
 [<ffffffff811c73ae>] local_pci_probe+0x3f/0x70
 [<ffffffff811c7cbc>] pci_device_probe+0x65/0x99
 [<ffffffff81102299>] ? sysfs_create_link+0xe/0x10
 [<ffffffff8128ed4b>] driver_probe_device+0xbc/0x156
 [<ffffffff8128ee3d>] __driver_attach+0x58/0x7b
 [<ffffffff8128ede5>] ? driver_probe_device+0x156/0x156
 [<ffffffff8128dd8f>] bus_for_each_dev+0x51/0x7f
 [<ffffffff8128ef54>] driver_attach+0x19/0x1b
 [<ffffffff8128e33f>] bus_add_driver+0xab/0x1f3
 [<ffffffff8128f49d>] driver_register+0x96/0x105
 [<ffffffff811c7a4d>] __pci_register_driver+0x51/0xbd
 [<ffffffff81249cbd>] drm_pci_init+0x85/0xea
 [<ffffffff817b0c08>] ? drm_core_init+0x112/0x112
 [<ffffffff817b0c93>] i915_init+0x8b/0x8d
 [<ffffffff8178db66>] do_one_initcall+0x7a/0x129
 [<ffffffff8178dcad>] kernel_init+0x98/0x118
 [<ffffffff81035d1e>] ? schedule_tail+0x2c/0x5b
 [<ffffffff814c9634>] kernel_thread_helper+0x4/0x10
 [<ffffffff8178dc15>] ? do_one_initcall+0x129/0x129
 [<ffffffff814c9630>] ? gs_change+0xb/0xb
[drm:intel_panel_setup_backlight] *ERROR* Failed to register
backlight: -17
Refined TSC clocksource calibration: 2691.257 MHz.
Switching to clocksource tsc
DRHD: handling fault status reg 2
INTR-REMAP: Request device [[00:02.0] fault index 19
INTR-REMAP:[fault reason 34] Present field in the IRTE entry is clear
fbcon: inteldrmfb (fb0) is primary device
Console: switching to colour frame buffer device 170x48
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
acpi device:04: registered as cooling_device4
input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
parport_pc 00:0b: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 1
[PCSPP,TRISTATE,COMPAT,ECP,DMA]
lp0: using parport0 (interrupt-driven).
loop: module loaded
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 20 (level, low) -> IRQ 20
ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3 impl
SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck pm led clo pio slum part
ems apst
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xe2728000 port 0xe2728100 irq 43
ata2: SATA max UDMA/133 abar m2048@0xe2728000 port 0xe2728180 irq 43
ata3: DUMMY
ata4: DUMMY
ata5: DUMMY
ata6: DUMMY
e1000e: Intel(R) PRO/1000 Network Driver - 1.4.4-k
e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1)
5c:9a:d8:e0:64:e9
e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
Copyright(c) 2003-2011 Intel Corporation
iwlagn 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwlagn 0000:02:00.0: setting latency timer to 64
iwlagn 0000:02:00.0: pci_resource_len = 0x00002000
iwlagn 0000:02:00.0: pci_resource_base = ffffc90000078000
iwlagn 0000:02:00.0: HW Revision ID = 0x34
iwlagn 0000:02:00.0: irq 45 for MSI/MSI-X
iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced-N 6205
AGN, REV=0xB0
iwlagn 0000:02:00.0: L1 Enabled; Disabling L0S
iwlagn 0000:02:00.0: device EEPROM VER=0x715, CALIB=0x6
iwlagn 0000:02:00.0: Device SKU: 0X1f0
iwlagn 0000:02:00.0: Valid Tx ant: 0X3, Valid Rx ant: 0X3
iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:02:00.0: loaded firmware version 17.168.5.3 build 42301
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.0: setting latency timer to 64
ehci_hcd 0000:00:1a.0: EHCI Host Controller
ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.0: debug port 2
ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.0: irq 23, io mem 0xe272a000
Registered led device: phy0-led
ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ehci_hcd 0000:00:1d.0: setting latency timer to 64
ehci_hcd 0000:00:1d.0: EHCI Host Controller
ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.0: debug port 2
ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.0: irq 22, io mem 0xe2729000
ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
xhci_hcd 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
xhci_hcd 0000:03:00.0: setting latency timer to 64
xhci_hcd 0000:03:00.0: xHCI Host Controller
xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 3
xhci_hcd 0000:03:00.0: irq 19, io mem 0xe2500000
xhci_hcd 0000:03:00.0: irq 46 for MSI/MSI-X
xhci_hcd 0000:03:00.0: irq 47 for MSI/MSI-X
xhci_hcd 0000:03:00.0: irq 48 for MSI/MSI-X
xhci_hcd 0000:03:00.0: irq 49 for MSI/MSI-X
xhci_hcd 0000:03:00.0: irq 50 for MSI/MSI-X
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
xhci_hcd 0000:03:00.0: xHCI Host Controller
xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 4
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usbcore: registered new interface driver uas
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver usbserial
usbserial: USB Serial Driver core
USB Serial support registered for FTDI USB Serial Device
usbcore: registered new interface driver ftdi_sio
ftdi_sio: v1.6.0:USB FTDI Serial Converters Driver
USB Serial support registered for pl2303
usbcore: registered new interface driver pl2303
pl2303: Prolific PL2303 USB to serial adaptor driver
USB Serial support registered for Qualcomm USB modem
usbcore: registered new interface driver qcserial
USB Serial support registered for Keyspan PDA
USB Serial support registered for Xircom / Entregra PGS -
(prerenumeration)
usbcore: registered new interface driver keyspan_pda
keyspan_pda: v1.1:USB Keyspan PDA Converter driver
i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64
irq 1,12
i8042: Detected active multiplexing controller, rev 1.1
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input5
rtc_cmos 00:07: RTC can wake from S4
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
Linux video capture interface: v2.00
usbcore: registered new interface driver uvcvideo
USB Video Class driver (1.1.1)
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=1)
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised:
dm-devel@redhat.com
Bluetooth: Broadcom Blutonium firmware driver ver 1.2
usbcore: registered new interface driver bcm203x
Bluetooth: Generic Bluetooth USB driver ver 0.6
usbcore: registered new interface driver btusb
cpuidle: using governor ladder
cpuidle: using governor menu
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
sdhci-pci 0000:0d:00.0: SDHCI controller found [1217:8221] (rev 5)
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata2: SATA link down (SStatus 0 SControl 300)
ata1.00: ATA-8: TOSHIBA THNSFC128GBSJ, CJFA0203, max UDMA/100
ata1.00: 250069680 sectors, multi 16: LBA48
sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
sdhci-pci 0000:0d:00.0: Invalid iomem size. You may experience problems.
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: configured for UDMA/100
sdhci-pci 0000:0d:00.0: setting latency timer to 64
scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA THNSFC12 CJFA PQ: 0
ANSI: 5
Registered led device: mmc0::
mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
mei 0000:00:16.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
mei 0000:00:16.0: setting latency timer to 64
input: Fujitsu FUJ02B1 as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:07/FUJ02B1:00/input/input6
sd 0:0:0:0: [sda] 250069680 512-byte logical blocks: (128 GB/119 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input7
fujitsu_laptop: ACPI: Fujitsu FUJ02B1 [FJEX] (on)
 sda: sda1 sda2 sda3
input: Fujitsu FUJ02E3 as
/devices/LNXSYSTM:00/device:00/FUJ02E3:00/input/input8
fujitsu_laptop: ACPI: Fujitsu FUJ02E3 [FEXT] (on)
fujitsu_laptop: BTNI: [0x10f0101]
fujitsu_laptop: driver 0.6.0 successfully loaded
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
snd_hda_intel 0000:00:1b.0: irq 51 for MSI/MSI-X
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
sd 0:0:0:0: [sda] Attached SCSI disk
usb 1-1: new high speed USB device number 2 using ehci_hcd
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 6 ports detected
usb 2-1: new high speed USB device number 2 using ehci_hcd
hda_codec: ALC269: SKU not ready 0x90970130
hda_codec: ALC269VB: BIOS auto-probing.
HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
input: HDA Intel PCH HDMI/DP as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input9
input: HDA Intel PCH Mic as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input10
input: HDA Intel PCH Headphone as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input11
usbcore: registered new interface driver snd-usb-audio
ALSA device list:
  #0: HDA Intel PCH at 0xe2720000 irq 51
TCP cubic registered
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
rtc_cmos 00:07: setting system clock to 2011-08-26 07:49:41 UTC
(1314344981)
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Freeing unused kernel memory: 1388k freed
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 8 ports detected
usb 1-1.1: new full speed USB device number 3 using ehci_hcd
input: PS/2 Generic Mouse as /devices/platform/i8042/serio3/input/input12
usb 1-1.6: new high speed USB device number 4 using ehci_hcd
hub 1-1.6:1.0: USB hub found
hub 1-1.6:1.0: 4 ports detected
usb 2-1.4: new full speed USB device number 3 using ehci_hcd
usb 2-1.6: new high speed USB device number 4 using ehci_hcd
qcserial 2-1.6:1.1: Qualcomm USB modem converter detected
usb 2-1.6: Qualcomm USB modem converter now attached to ttyUSB0
qcserial 2-1.6:1.2: Qualcomm USB modem converter detected
usb 2-1.6: Qualcomm USB modem converter now attached to ttyUSB1
qcserial 2-1.6:1.3: Qualcomm USB modem converter detected
usb 2-1.6: Qualcomm USB modem converter now attached to ttyUSB2
usb 1-1.6.1: new low speed USB device number 5 using ehci_hcd
input: Oneclick Technologies USB Intelliplug as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6.1/1-1.6.1:1.0/input/input13
generic-usb 0003:1B11:7091.0001: input,hidraw0: USB HID v1.11 Mouse
[Oneclick Technologies USB Intelliplug] on usb-0000:00:1a.0-1.6.1/input0
usb 1-1.6.4: new full speed USB device number 6 using ehci_hcd
Synaptics Touchpad, model: 1, fw: 7.4, id: 0x180b1, caps:
0xd04733/0xa42000/0xa0000
input: SynPS/2 Synaptics TouchPad as
/devices/platform/i8042/serio4/input/input14
hub 1-1.6.4:1.0: USB hub found
hub 1-1.6.4:1.0: 3 ports detected
usb 1-1.6.4.1: new full speed USB device number 7 using ehci_hcd
hub 1-1.6.4.1:1.0: USB hub found
hub 1-1.6.4.1:1.0: 4 ports detected
usb 1-1.6.4.2: new low speed USB device number 8 using ehci_hcd
input: Belkin Corporation Flip KVM as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6.4/1-1.6.4.2/1-1.6.4.2:1.0/input/input15
belkin 0003:050D:3201.0002: input,hiddev0,hidraw1: USB HID v1.10
Device [Belkin Corporation Flip KVM] on usb-0000:00:1a.0-1.6.4.2/input0
usb 1-1.6.4.3: new full speed USB device number 9 using ehci_hcd
input: Razer Razer Copperhead Laser Mouse as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6.4/1-1.6.4.3/1-1.6.4.3:1.0/input/input16
generic-usb 0003:1532:0101.0003: input,hidraw2: USB HID v1.00 Mouse
[Razer Razer Copperhead Laser Mouse] on usb-0000:00:1a.0-1.6.4.3/input0
input: Razer Razer Copperhead Laser Mouse as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6.4/1-1.6.4.3/1-1.6.4.3:1.1/input/input17
generic-usb 0003:1532:0101.0004: input,hidraw3: USB HID v0.01 Keyboard
[Razer Razer Copperhead Laser Mouse] on usb-0000:00:1a.0-1.6.4.3/input1
usb 1-1.6.4.1.1: new low speed USB device number 10 using ehci_hcd
input: Logitech Logitech Gaming Keyboard as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6.4/1-1.6.4.1/1-1.6.4.1.1/1-1.6.4.1.1:1.0/input/input18
generic-usb 0003:046D:C221.0005: input,hidraw4: USB HID v1.10 Keyboard
[Logitech Logitech Gaming Keyboard] on usb-0000:00:1a.0-1.6.4.1.1/input0
input: Logitech Logitech Gaming Keyboard as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6.4/1-1.6.4.1/1-1.6.4.1.1/1-1.6.4.1.1:1.1/input/input19
generic-usb 0003:046D:C221.0006: input,hiddev0,hidraw5: USB HID v1.10
Device [Logitech Logitech Gaming Keyboard] on
usb-0000:00:1a.0-1.6.4.1.1/input1
usb 1-1.6.4.1.4: new full speed USB device number 11 using ehci_hcd
input: G15 Keyboard G15 Keyboard as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6.4/1-1.6.4.1/1-1.6.4.1.4/1-1.6.4.1.4:1.0/input/input20
generic-usb 0003:046D:C222.0007: input,hiddev0,hidraw6: USB HID v1.11
Keypad [G15 Keyboard G15 Keyboard] on usb-0000:00:1a.0-1.6.4.1.4/input0
EXT4-fs (dm-0): couldn't mount as ext3 due to feature incompatibilities
EXT4-fs (dm-0): couldn't mount as ext2 due to feature incompatibilities
EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
udevd[1855]: starting version 171
EXT4-fs (dm-0): re-mounted. Opts: (null)

Regards,
- -- 
Tony Vroon
UNIX systems administrator
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk5Xk5YACgkQp5vW4rUFj5okrQCgmZ53CXApyLAzyk2Oek1H8bFr
+V4AnihbvRmkwJ75KHZ90xApFAAeg110
=qU2M
-----END PGP SIGNATURE-----
