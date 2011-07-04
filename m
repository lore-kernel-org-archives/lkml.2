Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab1GDXfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 19:35:40 -0400
Received: from mail.solarflare.com ([216.237.3.220]:1109 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab1GDXfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 19:35:37 -0400
Subject: Re: [PATCH 0/5 v2] PCI: fix cardbus and sriov regressions
From: Ben Hutchings <bhutchings@solarflare.com>
To: Ram Pai <linuxram@us.ibm.com>
Cc: jbarnes@virtuousgeek.org, torvalds@linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, socketcan@hartkopp.net, bhelgaas@google.com,
        linux@dominikbrodowski.net
In-Reply-To: <20110702130417.GA4016@ram-laptop>
References: <1309477662-18680-1-git-send-email-linuxram@us.ibm.com>
	 <1309561669.2693.20.camel@bwh-desktop>  <20110702130417.GA4016@ram-laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Tue, 05 Jul 2011 00:35:32 +0100
Message-ID: <1309822532.2729.24.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jul 2011 23:35:35.0907 (UTC) FILETIME=[12F5A330:01CC3AA3]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18238.005
X-TM-AS-Result: No--16.041800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-02 at 06:04 -0700, Ram Pai wrote:
> On Sat, Jul 02, 2011 at 12:07:48AM +0100, Ben Hutchings wrote:
> > On Thu, 2011-06-30 at 16:47 -0700, Ram Pai wrote:
> > > The following patch-set fixes regressions caused by:
> > > 
> > > the commit "PCI: update bridge resources to get more big ranges when allocating space (again)"
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=da7822e5ad71ec9b745b412639f1e5e0ba795a20
> > > 
> > > patch 1/5: fix calculation of additional resource size for hotplug bridges
> > > patch 2/5: ability to resize assigned pci-resource
> > > patch 3/5: make SRIOV BARs resources optional
> > > patch 4/5: make cardbus bridge resources optional
> > > patch 5/5: code and terminology cleanup
> > > 
> > > The regression was caused on some platforms with limited i/o and memory
> > > resources, the optional resources were allocated ahead of required resources,
> > > thus starving the latter. The patchset ensures that all the required resources
> > > are satisfied before any optional resources are satisfied.
> > 
> > This certainly fixes the problem I originally reported: all the basic
> > BARs for devices with SR-IOV enabled are mapped.
> > 
> > When testing this, I noticed that a BAR which we fail to allocate space
> > for may be left configured with an address range that overlaps that of
> > other BARs.  However, that does not appear to be a regression.
> 
> overlaps the other SRIOV BARs of the same device?
> 
> Can you send me the dmesg output?

Here you go:

Linux version 3.0.0-rc5+ (bwh@bwh-desktop) (gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) ) #2 SMP Fri Jul 1 23:44:40 BST 2011
Command line: ro root=/dev/sda7
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 0000000000100000 - 00000000bfaa0000 (usable)
 BIOS-e820: 00000000bfaa0000 - 00000000bfab6000 (reserved)
 BIOS-e820: 00000000bfab6000 - 00000000bfad5c00 (ACPI data)
 BIOS-e820: 00000000bfad5c00 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f8000000 (reserved)
 BIOS-e820: 00000000fe000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000440000000 (usable)
NX (Execute Disable) protection: active
DMI 2.5 present.
DMI: Dell Inc. PowerEdge R905/0C557J, BIOS 3.0.2 09/29/2008
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x440000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-D7FFF write-protect
  D8000-EBFFF uncachable
  EC000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000000 mask FFFF80000000 write-back
  1 base 000080000000 mask FFFFC0000000 write-back
  2 base 000100000000 mask FFFF00000000 write-back
  3 base 000200000000 mask FFFE00000000 write-back
  4 base 000400000000 mask FFFFC0000000 write-back
  5 base 0000BFC00000 mask FFFFFFC00000 uncachable
  6 disabled
  7 disabled
TOM2: 0000000440000000 aka 17408M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000bfc00000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xbfaa0 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff880000099000] 99000 size 20480
Using GB pages for direct mapping
init_memory_mapping: 0000000000000000-00000000bfaa0000
 0000000000 - 0080000000 page 1G
 0080000000 - 00bfa00000 page 2M
 00bfa00000 - 00bfaa0000 page 4k
kernel direct mapping tables up to bfaa0000 @ bfa9d000-bfaa0000
init_memory_mapping: 0000000100000000-0000000440000000
 0100000000 - 0440000000 page 1G
kernel direct mapping tables up to 440000000 @ 43ffff000-440000000
ACPI: RSDP 00000000000f23e0 00024 (v02 DELL  )
ACPI: XSDT 00000000000f2460 00094 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: FACP 00000000bfaced50 000F4 (v03 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: DSDT 00000000bfab6000 05A35 (v01 DELL   PE_SC3   00000001 INTL 20050624)
ACPI: FACS 00000000bfad1400 00040
ACPI: APIC 00000000bface878 000E0 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: SPCR 00000000bface95c 00050 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: PPPP 00000000bface9b0 00038 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: MCFG 00000000bface9ec 0003C (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: WD__ 00000000bfacea2c 00134 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: SLIC 00000000bfaceb64 00024 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: ERST 00000000bfabbbb8 00210 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: HEST 00000000bfabbdc8 0027C (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: BERT 00000000bfabba38 00030 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: EINJ 00000000bfabba68 00150 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: SRAT 00000000000fc084 00220 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: SSDT 00000000bfad1800 02854 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: TCPA 00000000bfacece8 00064 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea000edfffff] PMD -> [ffff88042f600000-ffff88043d5fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00440000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x000000a0
    0: 0x00000100 -> 0x000bfaa0
    0: 0x00100000 -> 0x00440000
On node 0 totalpages: 4192816
  DMA zone: 56 pages used for memmap
  DMA zone: 7 pages reserved
  DMA zone: 3921 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 766680 pages, LIFO batch:31
  Normal zone: 46592 pages used for memmap
  Normal zone: 3361280 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x0c] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x08] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0d] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x09] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x02] enabled)
ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 8/0x2 ignored.
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0e] enabled)
ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 9/0xe ignored.
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] enabled)
ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 10/0xa ignored.
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x06] enabled)
ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 11/0x6 ignored.
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x03] enabled)
ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 12/0x3 ignored.
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0f] enabled)
ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 13/0xf ignored.
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0b] enabled)
ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 14/0xb ignored.
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x07] enabled)
ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 15/0x7 ignored.
ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-15
ACPI: IOAPIC (id[0x01] address[0xfec01000] gsi_base[32])
IOAPIC[1]: apic_id 1, version 17, address 0xfec01000, GSI 32-47
ACPI: IOAPIC (id[0x02] address[0xfec02000] gsi_base[64])
IOAPIC[2]: apic_id 2, version 17, address 0xfec02000, GSI 64-79
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
16 Processors exceeds NR_CPUS limit of 8
SMP: Allowing 8 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 96
PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
PM: Registered nosave memory: 00000000bfaa0000 - 00000000bfab6000
PM: Registered nosave memory: 00000000bfab6000 - 00000000bfad5000
PM: Registered nosave memory: 00000000bfad5000 - 00000000bfad6000
PM: Registered nosave memory: 00000000bfad6000 - 00000000c0000000
PM: Registered nosave memory: 00000000c0000000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000f8000000
PM: Registered nosave memory: 00000000f8000000 - 00000000fe000000
PM: Registered nosave memory: 00000000fe000000 - 0000000100000000
Allocating PCI resources starting at c0000000 (gap: c0000000:30000000)
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 24 pages/cpu @ffff88043fc00000 s67968 r8192 d22144 u262144
pcpu-alloc: s67968 r8192 d22144 u262144 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4131881
Kernel command line: ro root=/dev/sda7
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ f4000000 size 64 MB
Node 1: aperture @ f4000000 size 64 MB
Node 2: aperture @ f4000000 size 64 MB
Node 3: aperture @ f4000000 size 64 MB
Memory: 16442844k/17825792k available (3218k kernel code, 1054528k absent, 328420k reserved, 3344k data, 424k init)
Hierarchical RCU implementation.
	CONFIG_RCU_FANOUT set to non-default value of 32
NR_IRQS:512
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
Fast TSC calibration using PIT
Detected 1995.165 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3990.33 BogoMIPS (lpj=1995165)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
tseg: 00bfc00000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
using AMD E400 aware idle routine
ACPI: Core revision 20110413
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Quad-Core AMD Opteron(tm) Processor 8350 stepping 03
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
Booting Node   0, Processors  #1
smpboot cpu 1: start_ip = 99000
 #2
smpboot cpu 2: start_ip = 99000
 #3
smpboot cpu 3: start_ip = 99000
 #4
smpboot cpu 4: start_ip = 99000
 #5
smpboot cpu 5: start_ip = 99000
 #6
smpboot cpu 6: start_ip = 99000
 #7 Ok.
smpboot cpu 7: start_ip = 99000
Brought up 8 CPUs
Total of 8 processors activated (31917.29 BogoMIPS).
kworker/u:0 used greatest stack depth: 6448 bytes left
kworker/u:0 used greatest stack depth: 6064 bytes left
NET: Registered protocol family 16
node 0 link 1: io port [a000, ffffff]
node 3 link 2: io port [9000, 9fff]
TOM: 00000000c0000000 aka 3072M
Fam 10h mmconf [f0000000, f3ffffff]
node 0 link 1: mmio [d8000000, dfffffff]
node 0 link 1: mmio [e4000000, ef4fffff]
node 3 link 2: mmio [d5000000, d7ffffff]
node 0 link 1: mmio [f0000000, f1ffffff] ==> none
node 3 link 2: mmio [f2000000, f3ffffff] ==> none
node 0 link 1: mmio [a0000, bffff]
TOM2: 0000000440000000 aka 17408M
bus: [00, 1f] on node 0 link 1
bus: 00 index 0 [io  0xa000-0xffff]
bus: 00 index 1 [io  0x0000-0x8fff]
bus: 00 index 2 [mem 0xd8000000-0xe3ffffff]
bus: 00 index 3 [mem 0xe4000000-0xefffffff]
bus: 00 index 4 [mem 0x000a0000-0x000bffff]
bus: 00 index 5 [mem 0xc0000000-0xd4ffffff]
bus: 00 index 6 [mem 0xf4000000-0xffffffff]
bus: 00 index 7 [mem 0x440000000-0xfcffffffff]
bus: [20, 3f] on node 3 link 2
bus: 20 index 0 [io  0x9000-0x9fff]
bus: 20 index 1 [mem 0xd5000000-0xd7ffffff]
Extended Config Space enabled on 4 nodes
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI Error: [CDW1] Namespace lookup failure, AE_NOT_FOUND (20110413/psargs-359)
ACPI Error: Method parse/execution failed [\_SB_._OSC] (Node ffff88043d859a10), AE_NOT_FOUND (20110413/psparse-536)
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-1e])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0xa000-0xffff]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0x0fff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xf1ffffff]
pci_root PNP0A08:00: host bridge window [mem 0xe4000000-0xef4fffff]
pci_root PNP0A08:00: host bridge window [mem 0xd8000000-0xdfffffff]
pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
pci 0000:00:01.0: [1166:0031] type 0 class 0x000600
pci 0000:00:02.0: [1166:0406] type 1 class 0x000604
pci 0000:00:03.0: [1166:0406] type 1 class 0x000604
pci 0000:00:04.0: [1166:0420] type 1 class 0x000604
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:05.0: [1166:0422] type 1 class 0x000604
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:07.0: [1166:0408] type 0 class 0x000600
pci 0000:00:07.2: [1166:040a] type 0 class 0x000601
pci 0000:00:08.0: [1166:0140] type 1 class 0x000604
pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
pci 0000:00:08.0: PME# disabled
pci 0000:00:09.0: [1166:0142] type 1 class 0x000604
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:0a.0: [1166:0144] type 1 class 0x000604
pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0b.0: [1166:0142] type 1 class 0x000604
pci 0000:00:0b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: [1166:0144] type 1 class 0x000604
pci 0000:00:0c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: [1002:515e] type 0 class 0x000300
pci 0000:00:0d.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
pci 0000:00:0d.0: reg 14: [io  0xac00-0xacff]
pci 0000:00:0d.0: reg 18: [mem 0xef0f0000-0xef0fffff]
pci 0000:00:0d.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:00:0d.0: supports D1 D2
pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
pci 0000:00:19.0: [1022:1200] type 0 class 0x000600
pci 0000:00:19.1: [1022:1201] type 0 class 0x000600
pci 0000:00:19.2: [1022:1202] type 0 class 0x000600
pci 0000:00:19.3: [1022:1203] type 0 class 0x000600
pci 0000:00:19.4: [1022:1204] type 0 class 0x000600
pci 0000:00:1a.0: [1022:1200] type 0 class 0x000600
pci 0000:00:1a.1: [1022:1201] type 0 class 0x000600
pci 0000:00:1a.2: [1022:1202] type 0 class 0x000600
pci 0000:00:1a.3: [1022:1203] type 0 class 0x000600
pci 0000:00:1a.4: [1022:1204] type 0 class 0x000600
pci 0000:00:1b.0: [1022:1200] type 0 class 0x000600
pci 0000:00:1b.1: [1022:1201] type 0 class 0x000600
pci 0000:00:1b.2: [1022:1202] type 0 class 0x000600
pci 0000:00:1b.3: [1022:1203] type 0 class 0x000600
pci 0000:00:1b.4: [1022:1204] type 0 class 0x000600
pci 0000:01:0e.0: [1166:0411] type 0 class 0x000101
pci 0000:01:0e.0: reg 10: [io  0xfcb0-0xfcb7]
pci 0000:01:0e.0: reg 14: [io  0xfca0-0xfca3]
pci 0000:01:0e.0: reg 18: [io  0xfcb8-0xfcbf]
pci 0000:01:0e.0: reg 1c: [io  0xfca4-0xfca7]
pci 0000:01:0e.0: reg 20: [io  0xfce0-0xfcef]
pci 0000:01:0e.0: reg 24: [mem 0xef1f8000-0xef1fffff]
pci 0000:01:0e.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:01:0e.1: [1166:0411] type 0 class 0x000101
pci 0000:01:0e.1: reg 10: [io  0xfcc0-0xfcc7]
pci 0000:01:0e.1: reg 14: [io  0xfca8-0xfcab]
pci 0000:01:0e.1: reg 18: [io  0xfcc8-0xfccf]
pci 0000:01:0e.1: reg 1c: [io  0xfcac-0xfcaf]
pci 0000:01:0e.1: reg 20: [io  0xfcd0-0xfcdf]
pci 0000:00:02.0: PCI bridge to [bus 01-01]
pci 0000:00:02.0:   bridge window [io  0xf000-0xffff]
pci 0000:00:02.0:   bridge window [mem 0xef100000-0xef1fffff]
pci 0000:00:02.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:02:0c.0: [1166:0412] type 0 class 0x000c03
pci 0000:02:0c.0: reg 10: [mem 0xef2fa000-0xef2fafff]
pci 0000:02:0c.0: reg 14: [io  0xd800-0xd8ff]
pci 0000:02:0c.0: PME# supported from D0 D3hot
pci 0000:02:0c.0: PME# disabled
pci 0000:02:0c.1: [1166:0412] type 0 class 0x000c03
pci 0000:02:0c.1: reg 10: [mem 0xef2fb000-0xef2fbfff]
pci 0000:02:0c.1: reg 14: [io  0xdc00-0xdcff]
pci 0000:02:0c.1: PME# supported from D0 D3hot
pci 0000:02:0c.1: PME# disabled
pci 0000:02:0c.2: [1166:0414] type 0 class 0x000c03
pci 0000:02:0c.2: reg 10: [mem 0xef2fc000-0xef2fcfff]
pci 0000:02:0c.2: reg 14: [io  0xe000-0xe0ff]
pci 0000:02:0c.2: PME# supported from D0 D3hot
pci 0000:02:0c.2: PME# disabled
pci 0000:02:0d.0: [1166:0412] type 0 class 0x000c03
pci 0000:02:0d.0: reg 10: [mem 0xef2fd000-0xef2fdfff]
pci 0000:02:0d.0: reg 14: [io  0xe400-0xe4ff]
pci 0000:02:0d.0: PME# supported from D0 D3hot
pci 0000:02:0d.0: PME# disabled
pci 0000:02:0d.1: [1166:0412] type 0 class 0x000c03
pci 0000:02:0d.1: reg 10: [mem 0xef2fe000-0xef2fefff]
pci 0000:02:0d.1: reg 14: [io  0xe800-0xe8ff]
pci 0000:02:0d.1: PME# supported from D0 D3hot
pci 0000:02:0d.1: PME# disabled
pci 0000:02:0d.2: [1166:0414] type 0 class 0x000c03
pci 0000:02:0d.2: reg 10: [mem 0xef2ff000-0xef2fffff]
pci 0000:02:0d.2: reg 14: [io  0xec00-0xecff]
pci 0000:02:0d.2: PME# supported from D0 D3hot
pci 0000:02:0d.2: PME# disabled
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0:   bridge window [io  0xd000-0xefff]
pci 0000:00:03.0:   bridge window [mem 0xef200000-0xef2fffff]
pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:03:00.0: [1166:0103] type 1 class 0x000604
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:00:04.0: PCI bridge to [bus 03-04]
pci 0000:00:04.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:04.0:   bridge window [mem 0xe4000000-0xe5ffffff]
pci 0000:00:04.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:04:00.0: [14e4:164c] type 0 class 0x000200
pci 0000:04:00.0: reg 10: [mem 0xe4000000-0xe5ffffff 64bit]
pci 0000:04:00.0: PME# supported from D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:03:00.0: PCI bridge to [bus 04-04]
pci 0000:03:00.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:03:00.0:   bridge window [mem 0xe4000000-0xe5ffffff]
pci 0000:03:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:05:00.0: [1166:0103] type 1 class 0x000604
pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
pci 0000:05:00.0: PME# disabled
pci 0000:00:05.0: PCI bridge to [bus 05-06]
pci 0000:00:05.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:05.0:   bridge window [mem 0xe6000000-0xe7ffffff]
pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:06:00.0: [14e4:164c] type 0 class 0x000200
pci 0000:06:00.0: reg 10: [mem 0xe6000000-0xe7ffffff 64bit]
pci 0000:06:00.0: PME# supported from D3hot D3cold
pci 0000:06:00.0: PME# disabled
pci 0000:05:00.0: PCI bridge to [bus 06-06]
pci 0000:05:00.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:05:00.0:   bridge window [mem 0xe6000000-0xe7ffffff]
pci 0000:05:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:0c:00.0: [1924:0813] type 0 class 0x000200
pci 0000:0c:00.0: reg 10: [io  0xb800-0xb8ff]
pci 0000:0c:00.0: reg 18: [mem 0xed000000-0xedffffff 64bit]
pci 0000:0c:00.0: reg 20: [mem 0xecfe0000-0xecfeffff 64bit]
pci 0000:0c:00.0: reg 30: [mem 0xec000000-0xec01ffff pref]
pci 0000:0c:00.0: PME# supported from D0 D3hot
pci 0000:0c:00.0: PME# disabled
pci 0000:0c:00.0: reg 184: [mem 0x00000000-0x00001fff 64bit]
pci 0000:0c:00.0: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:0c:00.1: [1924:0813] type 0 class 0x000200
pci 0000:0c:00.1: reg 10: [io  0xbc00-0xbcff]
pci 0000:0c:00.1: reg 18: [mem 0xee000000-0xeeffffff 64bit]
pci 0000:0c:00.1: reg 20: [mem 0xecff0000-0xecffffff 64bit]
pci 0000:0c:00.1: reg 30: [mem 0xec000000-0xec01ffff pref]
pci 0000:0c:00.1: PME# supported from D0 D3hot
pci 0000:0c:00.1: PME# disabled
pci 0000:0c:00.1: reg 184: [mem 0x00000000-0x00001fff 64bit]
pci 0000:0c:00.1: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:00:08.0: PCI bridge to [bus 0c-0c]
pci 0000:00:08.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:08.0:   bridge window [mem 0xec000000-0xeeffffff]
pci 0000:00:08.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:07:00.0: [1166:0103] type 1 class 0x000604
pci 0000:07:00.0: PME# supported from D0 D3hot D3cold
pci 0000:07:00.0: PME# disabled
pci 0000:00:09.0: PCI bridge to [bus 07-08]
pci 0000:00:09.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:09.0:   bridge window [mem 0xe8000000-0xe9ffffff]
pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:08:00.0: [14e4:164c] type 0 class 0x000200
pci 0000:08:00.0: reg 10: [mem 0xe8000000-0xe9ffffff 64bit]
pci 0000:08:00.0: PME# supported from D3hot D3cold
pci 0000:08:00.0: PME# disabled
pci 0000:07:00.0: PCI bridge to [bus 08-08]
pci 0000:07:00.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:07:00.0:   bridge window [mem 0xe8000000-0xe9ffffff]
pci 0000:07:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:09:00.0: [1166:0103] type 1 class 0x000604
pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
pci 0000:09:00.0: PME# disabled
pci 0000:00:0a.0: PCI bridge to [bus 09-0a]
pci 0000:00:0a.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:0a.0:   bridge window [mem 0xea000000-0xebffffff]
pci 0000:00:0a.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:0a:00.0: [14e4:164c] type 0 class 0x000200
pci 0000:0a:00.0: reg 10: [mem 0xea000000-0xebffffff 64bit]
pci 0000:0a:00.0: PME# supported from D3hot D3cold
pci 0000:0a:00.0: PME# disabled
pci 0000:09:00.0: PCI bridge to [bus 0a-0a]
pci 0000:09:00.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:09:00.0:   bridge window [mem 0xea000000-0xebffffff]
pci 0000:09:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:0b:00.0: [1000:0058] type 0 class 0x000100
pci 0000:0b:00.0: reg 10: [io  0xcc00-0xccff]
pci 0000:0b:00.0: reg 14: [mem 0xef4ec000-0xef4effff 64bit]
pci 0000:0b:00.0: reg 1c: [mem 0xef4f0000-0xef4fffff 64bit]
pci 0000:0b:00.0: reg 30: [mem 0xef300000-0xef3fffff pref]
pci 0000:0b:00.0: supports D1 D2
pci 0000:00:0b.0: PCI bridge to [bus 0b-0b]
pci 0000:00:0b.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:0b.0:   bridge window [mem 0xef300000-0xef4fffff]
pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:0c.0: PCI bridge to [bus 0d-0d]
pci 0000:00:0c.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PXB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PXB1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.SBE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.SBE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB4._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC control (0x1d) granted
ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 20-3e])
pci_root PNP0A08:01: host bridge window [io  0x9000-0x9fff]
pci_root PNP0A08:01: host bridge window [mem 0xf2000000-0xf3ffffff]
pci_root PNP0A08:01: host bridge window [mem 0xd5000000-0xd7ffffff]
pci 0000:20:08.0: [1166:0140] type 1 class 0x000604
pci 0000:20:08.0: PME# supported from D0 D3hot D3cold
pci 0000:20:08.0: PME# disabled
pci 0000:20:09.0: [1166:0142] type 1 class 0x000604
pci 0000:20:09.0: PME# supported from D0 D3hot D3cold
pci 0000:20:09.0: PME# disabled
pci 0000:20:0a.0: [1166:0144] type 1 class 0x000604
pci 0000:20:0a.0: PME# supported from D0 D3hot D3cold
pci 0000:20:0a.0: PME# disabled
pci 0000:20:0b.0: [1166:0142] type 1 class 0x000604
pci 0000:20:0b.0: PME# supported from D0 D3hot D3cold
pci 0000:20:0b.0: PME# disabled
pci 0000:20:0c.0: [1166:0144] type 1 class 0x000604
pci 0000:20:0c.0: PME# supported from D0 D3hot D3cold
pci 0000:20:0c.0: PME# disabled
pci 0000:21:00.0: [1924:0803] type 0 class 0x000200
pci 0000:21:00.0: reg 10: [io  0x9800-0x98ff]
pci 0000:21:00.0: reg 18: [mem 0xd6000000-0xd6ffffff 64bit]
pci 0000:21:00.0: reg 20: [mem 0xd5fe0000-0xd5feffff 64bit]
pci 0000:21:00.0: reg 30: [mem 0xd5000000-0xd501ffff pref]
pci 0000:21:00.0: PME# supported from D0 D3hot
pci 0000:21:00.0: PME# disabled
pci 0000:21:00.0: reg 184: [mem 0x00000000-0x00001fff 64bit]
pci 0000:21:00.0: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:21:00.1: [1924:0803] type 0 class 0x000200
pci 0000:21:00.1: reg 10: [io  0x9c00-0x9cff]
pci 0000:21:00.1: reg 18: [mem 0xd7000000-0xd7ffffff 64bit]
pci 0000:21:00.1: reg 20: [mem 0xd5ff0000-0xd5ffffff 64bit]
pci 0000:21:00.1: reg 30: [mem 0xd5000000-0xd501ffff pref]
pci 0000:21:00.1: PME# supported from D0 D3hot
pci 0000:21:00.1: PME# disabled
pci 0000:21:00.1: reg 184: [mem 0x00000000-0x00001fff 64bit]
pci 0000:21:00.1: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:20:08.0: PCI bridge to [bus 21-21]
pci 0000:20:08.0:   bridge window [io  0x9000-0x9fff]
pci 0000:20:08.0:   bridge window [mem 0xd5000000-0xd7ffffff]
pci 0000:20:08.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:20:09.0: PCI bridge to [bus 22-22]
pci 0000:20:09.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:20:09.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:20:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:20:0a.0: PCI bridge to [bus 23-23]
pci 0000:20:0a.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:20:0a.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:20:0a.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:20:0b.0: PCI bridge to [bus 24-24]
pci 0000:20:0b.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:20:0b.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:20:0b.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:20:0c.0: PCI bridge to [bus 25-25]
pci 0000:20:0c.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:20:0c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:20:0c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci_bus 0000:20: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.EXB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.EXB1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.EXB2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.EXB3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.EXB4._PRT]
 pci0000:20: Requesting ACPI _OSC control (0x1d)
 pci0000:20: ACPI _OSC control (0x1d) granted
ACPI: PCI Interrupt Link [LK10] (IRQs 3 4 5 6 7 10 *11)
ACPI: PCI Interrupt Link [LK11] (IRQs 3 4 5 6 7 *10 11)
ACPI: PCI Interrupt Link [LK12] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK13] (IRQs 3 4 *5 6 7 10 11)
ACPI: PCI Interrupt Link [LK14] (IRQs 3 4 5 6 7 10 11) *15
ACPI: PCI Interrupt Link [LK15] (IRQs 3 4 5 *6 7 10 11)
ACPI: PCI Interrupt Link [LK16] (IRQs 3 4 *5 6 7 10 11)
ACPI: PCI Interrupt Link [LK17] (IRQs 3 4 5 6 7 10 11) *14
ACPI: PCI Interrupt Link [LK18] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK19] (IRQs 3 4 5 6 7 10 11) *14
ACPI: PCI Interrupt Link [LK1A] (IRQs 3 4 5 6 7 10 *11)
ACPI: PCI Interrupt Link [LK1B] (IRQs 3 4 *5 6 7 10 11)
ACPI: PCI Interrupt Link [LK1C] (IRQs 3 4 5 6 7 10 11) *14
ACPI: PCI Interrupt Link [LK1D] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK1E] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK1F] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK20] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK21] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK22] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK23] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK24] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK25] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK26] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK27] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK28] (IRQs 3 4 5 6 7 10 11) *15
ACPI: PCI Interrupt Link [LK29] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK2A] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK2B] (IRQs 3 4 5 6 7 10 11) *14
ACPI: PCI Interrupt Link [LK2C] (IRQs 3 4 5 6 7 *10 11)
ACPI: PCI Interrupt Link [LK2D] (IRQs 3 4 5 *6 7 10 11)
ACPI: PCI Interrupt Link [LK2E] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK2F] (IRQs 3 4 5 6 7 10 *11)
vgaarb: device added: PCI:0000:00:0d.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:0d.0
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 00000000bfaa0000 - 00000000bfffffff 
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-1e]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0xa000-0xffff window]
pnp 00:00: [io  0x0d00-0x0fff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x00000000 window]
pnp 00:00: [mem 0x00000000 window]
pnp 00:00: [mem 0x00000000 window]
pnp 00:00: [mem 0xf0000000-0xf1ffffff window]
pnp 00:00: [mem 0x00000000 window]
pnp 00:00: [mem 0x00000000 window]
pnp 00:00: [mem 0xe4000000-0xef4fffff window]
pnp 00:00: [mem 0xd8000000-0xdfffffff window]
pnp 00:00: [mem 0xfed40000-0xfed44fff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [io  0x0080-0x009f]
pnp 00:01: [io  0x0000-0x001f]
pnp 00:01: [io  0x00c0-0x00df]
pnp 00:01: [dma 4]
pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:02: [io  0x00f0-0x00ff]
pnp 00:02: [irq 13]
pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:03: [io  0x0061]
pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:04: [io  0x0070-0x007f]
pnp 00:04: [irq 8]
pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:05: [io  0x03f8-0x03ff]
pnp 00:05: [irq 4]
pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:06: [io  0x02f8-0x02ff]
pnp 00:06: [irq 3]
pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:07: [io  0x0800-0x081f]
pnp 00:07: [io  0x0880-0x08ff]
pnp 00:07: [io  0x0cd6-0x0cd7]
pnp 00:07: [io  0x00e0-0x00e3]
pnp 00:07: [io  0x00e4-0x00e7]
pnp 00:07: [io  0x040b]
pnp 00:07: [io  0x04d6]
pnp 00:07: [io  0x0850-0x085f]
pnp 00:07: [io  0x0820-0x083f]
pnp 00:07: [io  0x0860-0x0863]
pnp 00:07: [io  0x0864-0x0867]
pnp 00:07: [io  0x0c00-0x0ca7]
pnp 00:07: [io  0x0ca0-0x0ca7]
pnp 00:07: [io  0x0ca9-0x0cab]
pnp 00:07: [io  0x0cad-0x0caf]
pnp 00:07: [io  0x0060]
pnp 00:07: [io  0x0064]
pnp 00:07: [io  0x0900]
system 00:07: [io  0x0800-0x081f] has been reserved
system 00:07: [io  0x0880-0x08ff] has been reserved
system 00:07: [io  0x0cd6-0x0cd7] has been reserved
system 00:07: [io  0x040b] has been reserved
system 00:07: [io  0x04d6] has been reserved
system 00:07: [io  0x0850-0x085f] has been reserved
system 00:07: [io  0x0820-0x083f] has been reserved
system 00:07: [io  0x0860-0x0863] has been reserved
system 00:07: [io  0x0864-0x0867] has been reserved
system 00:07: [io  0x0c00-0x0ca7] has been reserved
system 00:07: [io  0x0ca0-0x0ca7] has been reserved
system 00:07: [io  0x0ca9-0x0cab] has been reserved
system 00:07: [io  0x0cad-0x0caf] has been reserved
system 00:07: [io  0x0900] has been reserved
system 00:07: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:08: [io  0x0ca8]
pnp 00:08: [io  0x0cac]
system 00:08: [io  0x0ca8] has been reserved
system 00:08: [io  0x0cac] has been reserved
system 00:08: Plug and Play ACPI device, IDs IPI0001 PNP0c01 (active)
pnp 00:09: [mem 0xf0000000-0xf1ffffff]
system 00:09: [mem 0xf0000000-0xf1ffffff] has been reserved
system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0a: [bus 20-3e]
pnp 00:0a: [mem 0x00000000 window]
pnp 00:0a: [io  0x9000-0x9fff window]
pnp 00:0a: [mem 0x00000000 window]
pnp 00:0a: [mem 0x00000000 window]
pnp 00:0a: [mem 0xf2000000-0xf3ffffff window]
pnp 00:0a: [mem 0x00000000 window]
pnp 00:0a: [mem 0xd5000000-0xd7ffffff window]
pnp 00:0a: [mem 0x00000000 window]
pnp 00:0a: [mem 0x00000000 window]
pnp 00:0a: [mem 0x00000000 window]
pnp 00:0a: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:0b: [mem 0xf2000000-0xf3ffffff]
system 00:0b: [mem 0xf2000000-0xf3ffffff] has been reserved
system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0c: [mem 0xef0ef000-0xef0ef007]
system 00:0c: [mem 0xef0ef000-0xef0ef007] has been reserved
system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
Switching to clocksource acpi_pm
pci 0000:0c:00.1: address space collision: [mem 0xec000000-0xec01ffff pref] conflicts with 0000:0c:00.0 [mem 0xec000000-0xec01ffff pref]
pci 0000:21:00.1: address space collision: [mem 0xd5000000-0xd501ffff pref] conflicts with 0000:21:00.0 [mem 0xd5000000-0xd501ffff pref]
PCI: max bus depth: 2 pci_try_num: 3
pci 0000:00:02.0: BAR 15: can't assign mem pref (size 0x100000)
pci 0000:00:08.0: BAR 15: can't assign mem pref (size 0x100000)
pci 0000:00:0d.0: BAR 6: assigned [mem 0xef000000-0xef01ffff pref]
pci 0000:01:0e.0: BAR 6: assigned [mem 0xef100000-0xef11ffff pref]
pci 0000:00:02.0: PCI bridge to [bus 01-01]
pci 0000:00:02.0:   bridge window [io  0xf000-0xffff]
pci 0000:00:02.0:   bridge window [mem 0xef100000-0xef1fffff]
pci 0000:00:02.0:   bridge window [mem pref disabled]
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0:   bridge window [io  0xd000-0xefff]
pci 0000:00:03.0:   bridge window [mem 0xef200000-0xef2fffff]
pci 0000:00:03.0:   bridge window [mem pref disabled]
pci 0000:03:00.0: PCI bridge to [bus 04-04]
pci 0000:03:00.0:   bridge window [io  disabled]
pci 0000:03:00.0:   bridge window [mem 0xe4000000-0xe5ffffff]
pci 0000:03:00.0:   bridge window [mem pref disabled]
pci 0000:00:04.0: PCI bridge to [bus 03-04]
pci 0000:00:04.0:   bridge window [io  disabled]
pci 0000:00:04.0:   bridge window [mem 0xe4000000-0xe5ffffff]
pci 0000:00:04.0:   bridge window [mem pref disabled]
pci 0000:05:00.0: PCI bridge to [bus 06-06]
pci 0000:05:00.0:   bridge window [io  disabled]
pci 0000:05:00.0:   bridge window [mem 0xe6000000-0xe7ffffff]
pci 0000:05:00.0:   bridge window [mem pref disabled]
pci 0000:00:05.0: PCI bridge to [bus 05-06]
pci 0000:00:05.0:   bridge window [io  disabled]
pci 0000:00:05.0:   bridge window [mem 0xe6000000-0xe7ffffff]
pci 0000:00:05.0:   bridge window [mem pref disabled]
pci 0000:0c:00.0: reg 184: [mem 0x00000000-0x00001fff 64bit]
pci 0000:0c:00.0: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:0c:00.0: reg 184: [mem 0x00000000-0x00001fff 64bit]
pci 0000:0c:00.0: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:0c:00.1: reg 184: [mem 0x00000000-0x00001fff 64bit]
pci 0000:0c:00.0: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:0c:00.0: reg 184: [mem 0x00000000-0x00001fff 64bit]
pci 0000:0c:00.1: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:0c:00.0: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:0c:00.0: reg 184: [mem 0x00000000-0x00001fff 64bit]
pci 0000:0c:00.1: BAR 6: assigned [mem 0xec020000-0xec03ffff pref]
pci 0000:0c:00.0: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:0c:00.0: BAR 9: assigned [mem 0xec040000-0xec82ffff 64bit]
pci 0000:0c:00.0: BAR 9: set to [mem 0xec040000-0xec82ffff 64bit] (PCI address [0xec040000-0xec82ffff])
pci 0000:0c:00.1: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:0c:00.1: BAR 9: can't assign mem (size 0x7f0000)
pci 0000:0c:00.0: reg 184: [mem 0x00000000-0x00001fff 64bit]
pci 0000:0c:00.0: BAR 7: assigned [mem 0xec830000-0xec92dfff 64bit]
pci 0000:0c:00.0: BAR 7: set to [mem 0xec830000-0xec92dfff 64bit] (PCI address [0xec830000-0xec92dfff])
pci 0000:0c:00.1: reg 184: [mem 0x00000000-0x00001fff 64bit]
pci 0000:0c:00.1: BAR 7: assigned [mem 0xec92e000-0xeca2bfff 64bit]
pci 0000:0c:00.1: BAR 7: set to [mem 0xec92e000-0xeca2bfff 64bit] (PCI address [0xec92e000-0xeca2bfff])
pci 0000:00:08.0: PCI bridge to [bus 0c-0c]
pci 0000:00:08.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:08.0:   bridge window [mem 0xec000000-0xeeffffff]
pci 0000:00:08.0:   bridge window [mem pref disabled]
pci 0000:07:00.0: PCI bridge to [bus 08-08]
pci 0000:07:00.0:   bridge window [io  disabled]
pci 0000:07:00.0:   bridge window [mem 0xe8000000-0xe9ffffff]
pci 0000:07:00.0:   bridge window [mem pref disabled]
pci 0000:00:09.0: PCI bridge to [bus 07-08]
pci 0000:00:09.0:   bridge window [io  disabled]
pci 0000:00:09.0:   bridge window [mem 0xe8000000-0xe9ffffff]
pci 0000:00:09.0:   bridge window [mem pref disabled]
pci 0000:09:00.0: PCI bridge to [bus 0a-0a]
pci 0000:09:00.0:   bridge window [io  disabled]
pci 0000:09:00.0:   bridge window [mem 0xea000000-0xebffffff]
pci 0000:09:00.0:   bridge window [mem pref disabled]
pci 0000:00:0a.0: PCI bridge to [bus 09-0a]
pci 0000:00:0a.0:   bridge window [io  disabled]
pci 0000:00:0a.0:   bridge window [mem 0xea000000-0xebffffff]
pci 0000:00:0a.0:   bridge window [mem pref disabled]
pci 0000:00:0b.0: PCI bridge to [bus 0b-0b]
pci 0000:00:0b.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:0b.0:   bridge window [mem 0xef300000-0xef4fffff]
pci 0000:00:0b.0:   bridge window [mem pref disabled]
pci 0000:00:0c.0: PCI bridge to [bus 0d-0d]
pci 0000:00:0c.0:   bridge window [io  disabled]
pci 0000:00:0c.0:   bridge window [mem disabled]
pci 0000:00:0c.0:   bridge window [mem pref disabled]
pci 0000:20:08.0: BAR 15: can't assign mem pref (size 0x100000)
pci 0000:21:00.0: reg 184: [mem 0x00000000-0x00001fff 64bit]
pci 0000:21:00.0: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:21:00.0: reg 184: [mem 0x00000000-0x00001fff 64bit]
pci 0000:21:00.0: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:21:00.1: reg 184: [mem 0x00000000-0x00001fff 64bit]
pci 0000:21:00.0: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:21:00.0: reg 184: [mem 0x00000000-0x00001fff 64bit]
pci 0000:21:00.1: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:21:00.0: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:21:00.0: reg 184: [mem 0x00000000-0x00001fff 64bit]
pci 0000:21:00.1: BAR 6: assigned [mem 0xd5020000-0xd503ffff pref]
pci 0000:21:00.0: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:21:00.0: BAR 9: assigned [mem 0xd5040000-0xd582ffff 64bit]
pci 0000:21:00.0: BAR 9: set to [mem 0xd5040000-0xd582ffff 64bit] (PCI address [0xd5040000-0xd582ffff])
pci 0000:21:00.1: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:21:00.1: BAR 9: can't assign mem (size 0x7f0000)
pci 0000:21:00.0: reg 184: [mem 0x00000000-0x00001fff 64bit]
pci 0000:21:00.0: BAR 7: assigned [mem 0xd5830000-0xd592dfff 64bit]
pci 0000:21:00.0: BAR 7: set to [mem 0xd5830000-0xd592dfff 64bit] (PCI address [0xd5830000-0xd592dfff])
pci 0000:21:00.1: reg 184: [mem 0x00000000-0x00001fff 64bit]
pci 0000:21:00.1: BAR 7: assigned [mem 0xd592e000-0xd5a2bfff 64bit]
pci 0000:21:00.1: BAR 7: set to [mem 0xd592e000-0xd5a2bfff 64bit] (PCI address [0xd592e000-0xd5a2bfff])
pci 0000:20:08.0: PCI bridge to [bus 21-21]
pci 0000:20:08.0:   bridge window [io  0x9000-0x9fff]
pci 0000:20:08.0:   bridge window [mem 0xd5000000-0xd7ffffff]
pci 0000:20:08.0:   bridge window [mem pref disabled]
pci 0000:20:09.0: PCI bridge to [bus 22-22]
pci 0000:20:09.0:   bridge window [io  disabled]
pci 0000:20:09.0:   bridge window [mem disabled]
pci 0000:20:09.0:   bridge window [mem pref disabled]
pci 0000:20:0a.0: PCI bridge to [bus 23-23]
pci 0000:20:0a.0:   bridge window [io  disabled]
pci 0000:20:0a.0:   bridge window [mem disabled]
pci 0000:20:0a.0:   bridge window [mem pref disabled]
pci 0000:20:0b.0: PCI bridge to [bus 24-24]
pci 0000:20:0b.0:   bridge window [io  disabled]
pci 0000:20:0b.0:   bridge window [mem disabled]
pci 0000:20:0b.0:   bridge window [mem pref disabled]
pci 0000:20:0c.0: PCI bridge to [bus 25-25]
pci 0000:20:0c.0:   bridge window [io  disabled]
pci 0000:20:0c.0:   bridge window [mem disabled]
pci 0000:20:0c.0:   bridge window [mem pref disabled]
PCI: No. 2 try to assign unassigned res
release child resource [mem 0xd5000000-0xd501ffff pref]
release child resource [mem 0xd5020000-0xd503ffff pref]
release child resource [mem 0xd5040000-0xd582ffff 64bit]
release child resource [mem 0xd5830000-0xd592dfff 64bit]
release child resource [mem 0xd592e000-0xd5a2bfff 64bit]
release child resource [mem 0xd5fe0000-0xd5feffff 64bit]
release child resource [mem 0xd5ff0000-0xd5ffffff 64bit]
release child resource [mem 0xd6000000-0xd6ffffff 64bit]
release child resource [mem 0xd7000000-0xd7ffffff 64bit]
pci 0000:20:08.0: resource 14 [mem 0xd5000000-0xd7ffffff] released
pci 0000:20:08.0: PCI bridge to [bus 21-21]
pci 0000:20:08.0:   bridge window [mem disabled]
release child resource [mem 0xec000000-0xec01ffff pref]
release child resource [mem 0xec020000-0xec03ffff pref]
release child resource [mem 0xec040000-0xec82ffff 64bit]
release child resource [mem 0xec830000-0xec92dfff 64bit]
release child resource [mem 0xec92e000-0xeca2bfff 64bit]
release child resource [mem 0xecfe0000-0xecfeffff 64bit]
release child resource [mem 0xecff0000-0xecffffff 64bit]
release child resource [mem 0xed000000-0xedffffff 64bit]
release child resource [mem 0xee000000-0xeeffffff 64bit]
pci 0000:00:08.0: resource 14 [mem 0xec000000-0xeeffffff] released
pci 0000:00:08.0: PCI bridge to [bus 0c-0c]
pci 0000:00:08.0:   bridge window [mem disabled]
pci 0000:00:08.0: BAR 14: assigned [mem 0xec000000-0xeeffffff]
pci 0000:00:08.0: BAR 15: can't assign mem pref (size 0x100000)
pci 0000:00:02.0: PCI bridge to [bus 01-01]
pci 0000:00:02.0:   bridge window [io  0xf000-0xffff]
pci 0000:00:02.0:   bridge window [mem 0xef100000-0xef1fffff]
pci 0000:00:02.0:   bridge window [mem pref disabled]
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0:   bridge window [io  0xd000-0xefff]
pci 0000:00:03.0:   bridge window [mem 0xef200000-0xef2fffff]
pci 0000:00:03.0:   bridge window [mem pref disabled]
pci 0000:03:00.0: PCI bridge to [bus 04-04]
pci 0000:03:00.0:   bridge window [io  disabled]
pci 0000:03:00.0:   bridge window [mem 0xe4000000-0xe5ffffff]
pci 0000:03:00.0:   bridge window [mem pref disabled]
pci 0000:00:04.0: PCI bridge to [bus 03-04]
pci 0000:00:04.0:   bridge window [io  disabled]
pci 0000:00:04.0:   bridge window [mem 0xe4000000-0xe5ffffff]
pci 0000:00:04.0:   bridge window [mem pref disabled]
pci 0000:05:00.0: PCI bridge to [bus 06-06]
pci 0000:05:00.0:   bridge window [io  disabled]
pci 0000:05:00.0:   bridge window [mem 0xe6000000-0xe7ffffff]
pci 0000:05:00.0:   bridge window [mem pref disabled]
pci 0000:00:05.0: PCI bridge to [bus 05-06]
pci 0000:00:05.0:   bridge window [io  disabled]
pci 0000:00:05.0:   bridge window [mem 0xe6000000-0xe7ffffff]
pci 0000:00:05.0:   bridge window [mem pref disabled]
pci 0000:0c:00.0: reg 184: [mem 0xec830000-0xec831fff 64bit]
pci 0000:0c:00.0: reg 18c: [mem 0xec040000-0xec04ffff 64bit]
pci 0000:0c:00.0: reg 184: [mem 0xec830000-0xec831fff 64bit]
pci 0000:0c:00.0: reg 18c: [mem 0xec040000-0xec04ffff 64bit]
pci 0000:0c:00.0: reg 184: [mem 0xec830000-0xec831fff 64bit]
pci 0000:0c:00.1: reg 184: [mem 0xec92e000-0xec92ffff 64bit]
pci 0000:0c:00.0: reg 18c: [mem 0xec040000-0xec04ffff 64bit]
pci 0000:0c:00.0: reg 184: [mem 0xec830000-0xec831fff 64bit]
pci 0000:0c:00.1: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:0c:00.0: reg 18c: [mem 0xec040000-0xec04ffff 64bit]
pci 0000:0c:00.0: reg 184: [mem 0xec830000-0xec831fff 64bit]
pci 0000:0c:00.0: BAR 2: assigned [mem 0xec000000-0xecffffff 64bit]
pci 0000:0c:00.0: BAR 2: set to [mem 0xec000000-0xecffffff 64bit] (PCI address [0xec000000-0xecffffff])
pci 0000:0c:00.1: BAR 2: assigned [mem 0xed000000-0xedffffff 64bit]
pci 0000:0c:00.1: BAR 2: set to [mem 0xed000000-0xedffffff 64bit] (PCI address [0xed000000-0xedffffff])
pci 0000:0c:00.0: BAR 6: assigned [mem 0xee000000-0xee01ffff pref]
pci 0000:0c:00.1: BAR 6: assigned [mem 0xee020000-0xee03ffff pref]
pci 0000:0c:00.0: BAR 4: assigned [mem 0xee040000-0xee04ffff 64bit]
pci 0000:0c:00.0: BAR 4: set to [mem 0xee040000-0xee04ffff 64bit] (PCI address [0xee040000-0xee04ffff])
pci 0000:0c:00.1: BAR 4: assigned [mem 0xee050000-0xee05ffff 64bit]
pci 0000:0c:00.1: BAR 4: set to [mem 0xee050000-0xee05ffff 64bit] (PCI address [0xee050000-0xee05ffff])
pci 0000:0c:00.1: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:0c:00.1: BAR 9: assigned [mem 0xee060000-0xee84ffff 64bit]
pci 0000:0c:00.1: BAR 9: set to [mem 0xee060000-0xee84ffff 64bit] (PCI address [0xee060000-0xee84ffff])
pci 0000:0c:00.1: reg 184: [mem 0xec92e000-0xec92ffff 64bit]
pci 0000:0c:00.1: BAR 7: assigned [mem 0xee850000-0xee94dfff 64bit]
pci 0000:0c:00.1: BAR 7: set to [mem 0xee850000-0xee94dfff 64bit] (PCI address [0xee850000-0xee94dfff])
pci 0000:0c:00.0: reg 18c: [mem 0xec040000-0xec04ffff 64bit]
pci 0000:0c:00.0: BAR 9: can't assign mem (size 0x7f0000)
pci 0000:0c:00.0: reg 184: [mem 0xec830000-0xec831fff 64bit]
pci 0000:0c:00.0: BAR 7: assigned [mem 0xee94e000-0xeea4bfff 64bit]
pci 0000:0c:00.0: BAR 7: set to [mem 0xee94e000-0xeea4bfff 64bit] (PCI address [0xee94e000-0xeea4bfff])
pci 0000:00:08.0: PCI bridge to [bus 0c-0c]
pci 0000:00:08.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:08.0:   bridge window [mem 0xec000000-0xeeffffff]
pci 0000:00:08.0:   bridge window [mem pref disabled]
pci 0000:07:00.0: PCI bridge to [bus 08-08]
pci 0000:07:00.0:   bridge window [io  disabled]
pci 0000:07:00.0:   bridge window [mem 0xe8000000-0xe9ffffff]
pci 0000:07:00.0:   bridge window [mem pref disabled]
pci 0000:00:09.0: PCI bridge to [bus 07-08]
pci 0000:00:09.0:   bridge window [io  disabled]
pci 0000:00:09.0:   bridge window [mem 0xe8000000-0xe9ffffff]
pci 0000:00:09.0:   bridge window [mem pref disabled]
pci 0000:09:00.0: PCI bridge to [bus 0a-0a]
pci 0000:09:00.0:   bridge window [io  disabled]
pci 0000:09:00.0:   bridge window [mem 0xea000000-0xebffffff]
pci 0000:09:00.0:   bridge window [mem pref disabled]
pci 0000:00:0a.0: PCI bridge to [bus 09-0a]
pci 0000:00:0a.0:   bridge window [io  disabled]
pci 0000:00:0a.0:   bridge window [mem 0xea000000-0xebffffff]
pci 0000:00:0a.0:   bridge window [mem pref disabled]
pci 0000:00:0b.0: PCI bridge to [bus 0b-0b]
pci 0000:00:0b.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:0b.0:   bridge window [mem 0xef300000-0xef4fffff]
pci 0000:00:0b.0:   bridge window [mem pref disabled]
pci 0000:00:0c.0: PCI bridge to [bus 0d-0d]
pci 0000:00:0c.0:   bridge window [io  disabled]
pci 0000:00:0c.0:   bridge window [mem disabled]
pci 0000:00:0c.0:   bridge window [mem pref disabled]
pci 0000:20:08.0: BAR 14: assigned [mem 0xd5000000-0xd7ffffff]
pci 0000:20:08.0: BAR 15: can't assign mem pref (size 0x100000)
pci 0000:21:00.0: reg 184: [mem 0xd5830000-0xd5831fff 64bit]
pci 0000:21:00.0: reg 18c: [mem 0xd5040000-0xd504ffff 64bit]
pci 0000:21:00.0: reg 184: [mem 0xd5830000-0xd5831fff 64bit]
pci 0000:21:00.0: reg 18c: [mem 0xd5040000-0xd504ffff 64bit]
pci 0000:21:00.0: reg 184: [mem 0xd5830000-0xd5831fff 64bit]
pci 0000:21:00.1: reg 184: [mem 0xd592e000-0xd592ffff 64bit]
pci 0000:21:00.0: reg 18c: [mem 0xd5040000-0xd504ffff 64bit]
pci 0000:21:00.0: reg 184: [mem 0xd5830000-0xd5831fff 64bit]
pci 0000:21:00.1: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:21:00.0: reg 18c: [mem 0xd5040000-0xd504ffff 64bit]
pci 0000:21:00.0: reg 184: [mem 0xd5830000-0xd5831fff 64bit]
pci 0000:21:00.0: BAR 2: assigned [mem 0xd5000000-0xd5ffffff 64bit]
pci 0000:21:00.0: BAR 2: set to [mem 0xd5000000-0xd5ffffff 64bit] (PCI address [0xd5000000-0xd5ffffff])
pci 0000:21:00.1: BAR 2: assigned [mem 0xd6000000-0xd6ffffff 64bit]
pci 0000:21:00.1: BAR 2: set to [mem 0xd6000000-0xd6ffffff 64bit] (PCI address [0xd6000000-0xd6ffffff])
pci 0000:21:00.0: BAR 6: assigned [mem 0xd7000000-0xd701ffff pref]
pci 0000:21:00.1: BAR 6: assigned [mem 0xd7020000-0xd703ffff pref]
pci 0000:21:00.0: BAR 4: assigned [mem 0xd7040000-0xd704ffff 64bit]
pci 0000:21:00.0: BAR 4: set to [mem 0xd7040000-0xd704ffff 64bit] (PCI address [0xd7040000-0xd704ffff])
pci 0000:21:00.1: BAR 4: assigned [mem 0xd7050000-0xd705ffff 64bit]
pci 0000:21:00.1: BAR 4: set to [mem 0xd7050000-0xd705ffff 64bit] (PCI address [0xd7050000-0xd705ffff])
pci 0000:21:00.1: reg 18c: [mem 0x00000000-0x0000ffff 64bit]
pci 0000:21:00.1: BAR 9: assigned [mem 0xd7060000-0xd784ffff 64bit]
pci 0000:21:00.1: BAR 9: set to [mem 0xd7060000-0xd784ffff 64bit] (PCI address [0xd7060000-0xd784ffff])
pci 0000:21:00.1: reg 184: [mem 0xd592e000-0xd592ffff 64bit]
pci 0000:21:00.1: BAR 7: assigned [mem 0xd7850000-0xd794dfff 64bit]
pci 0000:21:00.1: BAR 7: set to [mem 0xd7850000-0xd794dfff 64bit] (PCI address [0xd7850000-0xd794dfff])
pci 0000:21:00.0: reg 18c: [mem 0xd5040000-0xd504ffff 64bit]
pci 0000:21:00.0: BAR 9: can't assign mem (size 0x7f0000)
pci 0000:21:00.0: reg 184: [mem 0xd5830000-0xd5831fff 64bit]
pci 0000:21:00.0: BAR 7: assigned [mem 0xd794e000-0xd7a4bfff 64bit]
pci 0000:21:00.0: BAR 7: set to [mem 0xd794e000-0xd7a4bfff 64bit] (PCI address [0xd794e000-0xd7a4bfff])
pci 0000:20:08.0: PCI bridge to [bus 21-21]
pci 0000:20:08.0:   bridge window [io  0x9000-0x9fff]
pci 0000:20:08.0:   bridge window [mem 0xd5000000-0xd7ffffff]
pci 0000:20:08.0:   bridge window [mem pref disabled]
pci 0000:20:09.0: PCI bridge to [bus 22-22]
pci 0000:20:09.0:   bridge window [io  disabled]
pci 0000:20:09.0:   bridge window [mem disabled]
pci 0000:20:09.0:   bridge window [mem pref disabled]
pci 0000:20:0a.0: PCI bridge to [bus 23-23]
pci 0000:20:0a.0:   bridge window [io  disabled]
pci 0000:20:0a.0:   bridge window [mem disabled]
pci 0000:20:0a.0:   bridge window [mem pref disabled]
pci 0000:20:0b.0: PCI bridge to [bus 24-24]
pci 0000:20:0b.0:   bridge window [io  disabled]
pci 0000:20:0b.0:   bridge window [mem disabled]
pci 0000:20:0b.0:   bridge window [mem pref disabled]
pci 0000:20:0c.0: PCI bridge to [bus 25-25]
pci 0000:20:0c.0:   bridge window [io  disabled]
pci 0000:20:0c.0:   bridge window [mem disabled]
pci 0000:20:0c.0:   bridge window [mem pref disabled]
pci 0000:00:04.0: PCI INT A -> GSI 72 (level, low) -> IRQ 72
pci 0000:00:04.0: setting latency timer to 64
pci 0000:03:00.0: setting latency timer to 64
pci 0000:00:05.0: PCI INT A -> GSI 75 (level, low) -> IRQ 75
pci 0000:00:05.0: setting latency timer to 64
pci 0000:05:00.0: setting latency timer to 64
pci 0000:00:08.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
pci 0000:00:08.0: setting latency timer to 64
pci 0000:00:09.0: PCI INT A -> GSI 33 (level, low) -> IRQ 33
pci 0000:00:09.0: setting latency timer to 64
pci 0000:07:00.0: setting latency timer to 64
pci 0000:00:0a.0: PCI INT A -> GSI 37 (level, low) -> IRQ 37
pci 0000:00:0a.0: setting latency timer to 64
pci 0000:09:00.0: setting latency timer to 64
pci 0000:00:0b.0: PCI INT A -> GSI 35 (level, low) -> IRQ 35
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:00:0c.0: PCI INT A -> GSI 36 (level, low) -> IRQ 36
pci 0000:00:0c.0: setting latency timer to 64
pci 0000:20:08.0: PCI INT A -> GSI 38 (level, low) -> IRQ 38
pci 0000:20:08.0: setting latency timer to 64
pci 0000:20:09.0: PCI INT A -> GSI 39 (level, low) -> IRQ 39
pci 0000:20:09.0: setting latency timer to 64
pci 0000:20:0a.0: PCI INT A -> GSI 43 (level, low) -> IRQ 43
pci 0000:20:0a.0: setting latency timer to 64
pci 0000:20:0b.0: PCI INT A -> GSI 41 (level, low) -> IRQ 41
pci 0000:20:0b.0: setting latency timer to 64
pci 0000:20:0c.0: PCI INT A -> GSI 42 (level, low) -> IRQ 42
pci 0000:20:0c.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0xa000-0xffff]
pci_bus 0000:00: resource 6 [io  0x0d00-0x0fff]
pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 8 [mem 0xf0000000-0xf1ffffff]
pci_bus 0000:00: resource 9 [mem 0xe4000000-0xef4fffff]
pci_bus 0000:00: resource 10 [mem 0xd8000000-0xdfffffff]
pci_bus 0000:00: resource 11 [mem 0xfed40000-0xfed44fff]
pci_bus 0000:01: resource 0 [io  0xf000-0xffff]
pci_bus 0000:01: resource 1 [mem 0xef100000-0xef1fffff]
pci_bus 0000:02: resource 0 [io  0xd000-0xefff]
pci_bus 0000:02: resource 1 [mem 0xef200000-0xef2fffff]
pci_bus 0000:03: resource 1 [mem 0xe4000000-0xe5ffffff]
pci_bus 0000:04: resource 1 [mem 0xe4000000-0xe5ffffff]
pci_bus 0000:05: resource 1 [mem 0xe6000000-0xe7ffffff]
pci_bus 0000:06: resource 1 [mem 0xe6000000-0xe7ffffff]
pci_bus 0000:0c: resource 0 [io  0xb000-0xbfff]
pci_bus 0000:0c: resource 1 [mem 0xec000000-0xeeffffff]
pci_bus 0000:07: resource 1 [mem 0xe8000000-0xe9ffffff]
pci_bus 0000:08: resource 1 [mem 0xe8000000-0xe9ffffff]
pci_bus 0000:09: resource 1 [mem 0xea000000-0xebffffff]
pci_bus 0000:0a: resource 1 [mem 0xea000000-0xebffffff]
pci_bus 0000:0b: resource 0 [io  0xc000-0xcfff]
pci_bus 0000:0b: resource 1 [mem 0xef300000-0xef4fffff]
pci_bus 0000:20: resource 4 [io  0x9000-0x9fff]
pci_bus 0000:20: resource 5 [mem 0xf2000000-0xf3ffffff]
pci_bus 0000:20: resource 6 [mem 0xd5000000-0xd7ffffff]
pci_bus 0000:21: resource 0 [io  0x9000-0x9fff]
pci_bus 0000:21: resource 1 [mem 0xd5000000-0xd7ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 8192 (order: 6, 262144 bytes)
UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:0d.0: Boot video device
PCI: CLS 64 bytes, default 64
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ f4000000 size 65536 KB
init_memory_mapping: 00000000f4000000-00000000f8000000
 00f4000000 - 00f8000000 page 2M
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
microcode: no support for this CPU vendor
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 32243
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler cfq registered (default)
pcieport 0000:00:04.0: setting latency timer to 64
pcieport 0000:00:04.0: irq 96 for MSI/MSI-X
pcieport 0000:00:05.0: setting latency timer to 64
pcieport 0000:00:05.0: irq 97 for MSI/MSI-X
pcieport 0000:00:08.0: setting latency timer to 64
pcieport 0000:00:08.0: irq 98 for MSI/MSI-X
pcieport 0000:00:09.0: setting latency timer to 64
pcieport 0000:00:09.0: irq 99 for MSI/MSI-X
pcieport 0000:00:0a.0: setting latency timer to 64
pcieport 0000:00:0a.0: irq 100 for MSI/MSI-X
pcieport 0000:00:0b.0: setting latency timer to 64
pcieport 0000:00:0b.0: irq 101 for MSI/MSI-X
pcieport 0000:00:0c.0: setting latency timer to 64
pcieport 0000:00:0c.0: irq 102 for MSI/MSI-X
pcieport 0000:20:08.0: setting latency timer to 64
pcieport 0000:20:08.0: irq 103 for MSI/MSI-X
pcieport 0000:20:09.0: setting latency timer to 64
pcieport 0000:20:09.0: irq 104 for MSI/MSI-X
pcieport 0000:20:0a.0: setting latency timer to 64
pcieport 0000:20:0a.0: irq 105 for MSI/MSI-X
pcieport 0000:20:0b.0: setting latency timer to 64
pcieport 0000:20:0b.0: irq 106 for MSI/MSI-X
pcieport 0000:20:0c.0: setting latency timer to 64
pcieport 0000:20:0c.0: irq 107 for MSI/MSI-X
aer 0000:00:04.0:pcie02: service driver aer loaded
aer 0000:00:05.0:pcie02: service driver aer loaded
aer 0000:00:08.0:pcie02: service driver aer loaded
aer 0000:00:09.0:pcie02: service driver aer loaded
aer 0000:00:0a.0:pcie02: service driver aer loaded
aer 0000:00:0b.0:pcie02: service driver aer loaded
aer 0000:00:0c.0:pcie02: service driver aer loaded
aer 0000:20:08.0:pcie02: service driver aer loaded
aer 0000:20:09.0:pcie02: service driver aer loaded
aer 0000:20:0a.0:pcie02: service driver aer loaded
aer 0000:20:0b.0:pcie02: service driver aer loaded
aer 0000:20:0c.0:pcie02: service driver aer loaded
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
ACPI: acpi_idle registered with cpuidle
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Linux agpgart interface v0.103
Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using getrawmonotonic().
loop: module loaded
mpt2sas version 08.100.00.02 loaded
e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
e1000: Copyright (c) 1999-2006 Intel Corporation.
e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
bnx2: Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v2.1.6 (Mar 7, 2011)
bnx2 0000:04:00.0: PCI INT A -> GSI 72 (level, low) -> IRQ 72
bnx2 0000:04:00.0: eth0: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X 64-bit 133MHz found at mem e4000000, IRQ 72, node addr 00:22:19:1c:7d:8f
bnx2 0000:06:00.0: PCI INT A -> GSI 75 (level, low) -> IRQ 75
bnx2 0000:06:00.0: eth1: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X 64-bit 133MHz found at mem e6000000, IRQ 75, node addr 00:22:19:1c:7d:91
bnx2 0000:08:00.0: PCI INT A -> GSI 33 (level, low) -> IRQ 33
bnx2 0000:08:00.0: eth2: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X 64-bit 133MHz found at mem e8000000, IRQ 33, node addr 00:1e:4f:fd:42:d6
bnx2 0000:0a:00.0: PCI INT A -> GSI 37 (level, low) -> IRQ 37
bnx2 0000:0a:00.0: eth3: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X 64-bit 133MHz found at mem ea000000, IRQ 37, node addr 00:1e:4f:fd:42:d8
console [netcon0] enabled
netconsole: network logging started
Fusion MPT base driver 3.04.19
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SAS Host driver 3.04.19
mptsas 0000:0b:00.0: PCI INT A -> GSI 35 (level, low) -> IRQ 35
mptbase: ioc0: Initiating bringup
ioc0: LSISAS1068E B3: Capabilities={Initiator}
mptsas 0000:0b:00.0: setting latency timer to 64
Refined TSC clocksource calibration: 1994.999 MHz.
Switching to clocksource tsc
scsi0 : ioc0: LSISAS1068E B3, FwRev=00192f00h, Ports=1, MaxQ=266, IRQ=35
mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 0, phy 0, sas_addr 0x5000c5000bac4b09
scsi 0:0:0:0: Direct-Access     SEAGATE  ST373455SS       S528 PQ: 0 ANSI: 5
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:02:0c.2: PCI INT C -> GSI 76 (level, low) -> IRQ 76
ehci_hcd 0000:02:0c.2: EHCI Host Controller
ehci_hcd 0000:02:0c.2: new USB bus registered, assigned bus number 1
sd 0:0:0:0: [sda] 143374650 512-byte logical blocks: (73.4 GB/68.3 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: b3 00 10 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
ehci_hcd 0000:02:0c.2: irq 76, io mem 0xef2fc000
ehci_hcd 0000:02:0c.2: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ehci_hcd 0000:02:0d.2: PCI INT C -> GSI 77 (level, low) -> IRQ 77
ehci_hcd 0000:02:0d.2: EHCI Host Controller
ehci_hcd 0000:02:0d.2: new USB bus registered, assigned bus number 2
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
sd 0:0:0:0: [sda] Attached SCSI disk
ehci_hcd 0000:02:0d.2: irq 77, io mem 0xef2ff000
ehci_hcd 0000:02:0d.2: USB 2.0 started, EHCI 1.00
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:02:0c.0: PCI INT A -> GSI 76 (level, low) -> IRQ 76
ohci_hcd 0000:02:0c.0: OHCI Host Controller
ohci_hcd 0000:02:0c.0: new USB bus registered, assigned bus number 3
ohci_hcd 0000:02:0c.0: irq 76, io mem 0xef2fa000
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ohci_hcd 0000:02:0c.1: PCI INT B -> GSI 76 (level, low) -> IRQ 76
ohci_hcd 0000:02:0c.1: OHCI Host Controller
ohci_hcd 0000:02:0c.1: new USB bus registered, assigned bus number 4
ohci_hcd 0000:02:0c.1: irq 76, io mem 0xef2fb000
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ohci_hcd 0000:02:0d.0: PCI INT A -> GSI 77 (level, low) -> IRQ 77
ohci_hcd 0000:02:0d.0: OHCI Host Controller
ohci_hcd 0000:02:0d.0: new USB bus registered, assigned bus number 5
ohci_hcd 0000:02:0d.0: irq 77, io mem 0xef2fd000
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ohci_hcd 0000:02:0d.1: PCI INT B -> GSI 77 (level, low) -> IRQ 77
ohci_hcd 0000:02:0d.1: OHCI Host Controller
ohci_hcd 0000:02:0d.1: new USB bus registered, assigned bus number 6
ohci_hcd 0000:02:0d.1: irq 77, io mem 0xef2fe000
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
i8042: PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:04: RTC can wake from S4
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 242 bytes nvram
i2c /dev entries driver
cpuidle: using governor ladder
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP cubic registered
NET: Registered protocol family 17
802.1Q VLAN Support v1.8
rtc_cmos 00:04: setting system clock to 2011-07-01 23:53:37 UTC (1309564417)
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda7): mounted filesystem with writeback data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:7.
Freeing unused kernel memory: 424k freed
Write protecting the kernel read-only data: 6144k
Freeing unused kernel memory: 868k freed
Freeing unused kernel memory: 604k freed
usb 2-2: new high speed USB device number 2 using ehci_hcd
kworker/u:0 used greatest stack depth: 5088 bytes left
hub 2-2:1.0: USB hub found
hub 2-2:1.0: 2 ports detected
modprobe used greatest stack depth: 3864 bytes left
usb 2-2.1: new high speed USB device number 3 using ehci_hcd
mount used greatest stack depth: 3816 bytes left
hub 2-2.1:1.0: USB hub found
hub 2-2.1:1.0: 2 ports detected
usb 2-2.1.2: new low speed USB device number 4 using ehci_hcd
input: DELL DELL USB Keyboard as /devices/pci0000:00/0000:00:03.0/0000:02:0d.2/usb2/2-2/2-2.1/2-2.1.2/2-2.1.2:1.0/input/input1
generic-usb 0003:413C:2005.0001: input: USB HID v1.10 Keyboard [DELL DELL USB Keyboard] on usb-0000:02:0d.2-2.1.2/input0
udevd (954): /proc/954/oom_adj is deprecated, please use /proc/954/oom_score_adj instead.
Solarflare NET driver v3.1
sfc 0000:0c:00.0: (unregistered net_device): Solarflare Communications NIC detected
sfc 0000:0c:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
sfc 0000:0c:00.0: setting latency timer to 64
sfc 0000:0c:00.0: irq 108 for MSI/MSI-X
sfc 0000:0c:00.0: irq 109 for MSI/MSI-X
sfc 0000:0c:00.0: irq 110 for MSI/MSI-X
sfc 0000:0c:00.0: irq 111 for MSI/MSI-X
sfc 0000:0c:00.1: (unregistered net_device): Solarflare Communications NIC detected
sfc 0000:0c:00.1: PCI INT B -> GSI 32 (level, low) -> IRQ 32
sfc 0000:0c:00.1: setting latency timer to 64
sfc 0000:0c:00.1: irq 112 for MSI/MSI-X
sfc 0000:0c:00.1: irq 113 for MSI/MSI-X
sfc 0000:0c:00.1: irq 114 for MSI/MSI-X
sfc 0000:0c:00.1: irq 115 for MSI/MSI-X
sfc 0000:21:00.0: (unregistered net_device): Solarflare Communications NIC detected
sfc 0000:21:00.0: PCI INT A -> GSI 38 (level, low) -> IRQ 38
sfc 0000:21:00.0: setting latency timer to 64
sfc 0000:21:00.0: irq 116 for MSI/MSI-X
sfc 0000:21:00.0: irq 117 for MSI/MSI-X
sfc 0000:21:00.0: irq 118 for MSI/MSI-X
sfc 0000:21:00.0: irq 119 for MSI/MSI-X
sfc 0000:21:00.1: (unregistered net_device): Solarflare Communications NIC detected
sfc 0000:21:00.1: PCI INT B -> GSI 38 (level, low) -> IRQ 38
sfc 0000:21:00.1: setting latency timer to 64
sfc 0000:21:00.1: irq 120 for MSI/MSI-X
sfc 0000:21:00.1: irq 121 for MSI/MSI-X
sfc 0000:21:00.1: irq 122 for MSI/MSI-X
sfc 0000:21:00.1: irq 123 for MSI/MSI-X
EXT3-fs (sda7): using internal journal
EXT2-fs (sda1): warning: mounting ext3 filesystem as ext2
Adding 1959892k swap on /dev/sda5.  Priority:-1 extents:1 across:1959892k 
warning: process `kudzu' used the deprecated sysctl system call with 1.23.
bnx2 0000:04:00.0: irq 124 for MSI/MSI-X
bnx2 0000:04:00.0: eth0: using MSI
bnx2 0000:04:00.0: eth0: NIC Copper Link is Up, 1000 Mbps full duplex, receive & transmit flow control ON
warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)


-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

