Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab0GNBCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 21:02:10 -0400
Received: from mail.candelatech.com ([208.74.158.172]:58915 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab0GNBCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 21:02:08 -0400
X-Greylist: delayed 1550 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jul 2010 21:02:07 EDT
Message-ID: <4C3D067C.10507@candelatech.com>
Date: Tue, 13 Jul 2010 17:36:12 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
        jacob.jun.pan@intel.com
Subject: Regression:  2.6.34 boot fails on E5405 system, bisected:  de08e2c26
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're seeing boot failures on multiple machines, running FC8 and
F11.  I bisected on an FC8 32-bit system.  Newer hardware works,
but these older ones do not.

A console log of the hang is found later in this email.

Please let me know if you would like any additional information,
and I will be happy to test patches.

The same failure happens in 2.6.34.1, so the fix does not appear to
be in the stable tree yet.


[greearb@fs2 linux-2.6]$ git bisect good
a712ffbc199849364c46e9112b93b66de08e2c26 is first bad commit
commit a712ffbc199849364c46e9112b93b66de08e2c26
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Feb 4 10:59:27 2010 -0800

     x86/PCI: Moorestown PCI support

     The Moorestown platform only has a few devices that actually support
     PCI config cycles.  The rest of the devices use an in-RAM MCFG space
     for the purposes of device enumeration and initialization.

     There are a few uglies in the fake support, like BAR sizes that aren't
     a power of two, sizing detection, and writes to the real devices, but
     other than that it's pretty straightforward.

     Another way to think of this is not really as PCI at all, but just a
     table in RAM describing which devices are present, their capabilities
     and their offsets in MMIO space.  This could have been done with a
     special new firmware table on this platform, but given that we do have
     some real PCI devices too, simply describing things in an MCFG type
     space was pretty simple.

     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
     LKML-Reference: <43F901BD926A4E43B106BF17856F07559FB80D08@orsmsx508.amr.corp.intel.com>
     Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
     Signed-off-by: H. Peter Anvin <hpa@zytor.com>

:040000 040000 56d09488bc71d1ab844bc02363cc75f89426a7ef 9bf1a608677af8b32fa4dbae8ba8cf965f4fb4e8 M	arch
:040000 040000 a4cfa1da638f4870cb0c32f4a34a9acfb4157f02 4283c36b6f856e0bf99a9ef9d6db44d91bd44bb2 M	include



### Console log of failure ###

root (hd0,0)
  Filesystem type is ext2fs, partition type 0x83
kernel /ct2.6.33-rc8-compat.img ro root=/dev/VolGroup00/LogVol00 console=ttyS0,
  38400
    [Linux-bzImage, setup=0x3600, size=0x330d70]
initrd /initrd-ct2.6.33-rc8-compat.img
    [Linux-initrd @ 0x37cac000, 0x343add bytes]

Initializing cgroup subsys cpuset
Linux version 2.6.33-rc8-compat (greearb@fs2.candelatech.com) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #13 SMP Tue Jul 13 17:0
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009c000 (usable)
  BIOS-e820: 000000000009c000 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000cc000 - 00000000000d0000 (reserved)
  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 00000000cff50000 (usable)
  BIOS-e820: 00000000cff50000 - 00000000cff65000 (ACPI data)
  BIOS-e820: 00000000cff65000 - 00000000cff80000 (ACPI NVS)
  BIOS-e820: 00000000cff80000 - 00000000d0000000 (reserved)
  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
  BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
DMI present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
last_pfn = 0xcff50 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
total RAM covered: 8191M
Found optimal setting for mtrr clean up
  gran_size: 64K         chunk_size: 1M  num_reg: 7      lose cover RAM: 0G
found SMP MP-table at [c00f6200] f6200
init_memory_mapping: 0000000000000000-00000000373fe000
RAMDISK: 37cac000 - 37fefadd
Allocated new RAMDISK: 00ab4000 - 00df7add
Move RAMDISK from 0000000037cac000 - 0000000037fefadc to 00ab4000 - 00df7adc
ACPI: RSDP 000f61d0 00014 (v00 PTLTD )
ACPI: RSDT cff5ea41 00064 (v01 SMCI   SMCISLP2 06040000  LTP 00000000)
ACPI: FACP cff6448a 00074 (v01 INTEL  TUMWATER 06040000 PTL  00000003)
ACPI: DSDT cff60577 03F13 (v01  Intel BLAKFORD 06040000 MSFT 0100000E)
ACPI: FACS cff65fc0 00040
ACPI: APIC cff644fe 000C8 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
ACPI: MCFG cff645c6 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
ACPI: HPET cff64602 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
ACPI: BOOT cff6463a 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
ACPI: SPCR cff64662 00050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
ACPI: SLIC cff646b2 00176 (v01 SMCI   SMCISLP2 06040000  LTP 00000000)
ACPI: SSDT cff60318 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050228)
ACPI: SSDT cff60272 000A6 (v01  PmRef  Cpu7Tst 00003000 INTL 20050228)
ACPI: SSDT cff601cc 000A6 (v01  PmRef  Cpu6Tst 00003000 INTL 20050228)
ACPI: SSDT cff60126 000A6 (v01  PmRef  Cpu5Tst 00003000 INTL 20050228)
ACPI: SSDT cff60080 000A6 (v01  PmRef  Cpu4Tst 00003000 INTL 20050228)
ACPI: SSDT cff5ffda 000A6 (v01  PmRef  Cpu3Tst 00003000 INTL 20050228)
ACPI: SSDT cff5ff34 000A6 (v01  PmRef  Cpu2Tst 00003000 INTL 20050228)
ACPI: SSDT cff5fe8e 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050228)
ACPI: SSDT cff5eaa5 013E9 (v01  PmRef    CpuPm 00003000 INTL 20050228)
2443MB HIGHMEM available.
883MB LOWMEM available.
   mapped low ram: 0 - 373fe000
   low ram: 0 - 373fe000
   node 0 low ram: 00000000 - 373fe000
   node 0 bootmap 00017000 - 0001de80
(14 early reservations) ==> bootmem [0000000000 - 00373fe000]
   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
   #2 [0000400000 - 0000aaec40]    TEXT DATA BSS ==> [0000400000 - 0000aaec40]
   #3 [0000aaf000 - 0000ab3174]              BRK ==> [0000aaf000 - 0000ab3174]
   #4 [00000f6210 - 0000100000]    BIOS reserved ==> [00000f6210 - 0000100000]
   #5 [00000f6200 - 00000f6210]     MP-table mpf ==> [00000f6200 - 00000f6210]
   #6 [000009c000 - 000009e431]    BIOS reserved ==> [000009c000 - 000009e431]
   #7 [000009e695 - 00000f6200]    BIOS reserved ==> [000009e695 - 00000f6200]
   #8 [000009e431 - 000009e695]     MP-table mpc ==> [000009e431 - 000009e695]
   #9 [0000010000 - 0000011000]       TRAMPOLINE ==> [0000010000 - 0000011000]
   #10 [0000011000 - 0000015000]      ACPI WAKEUP ==> [0000011000 - 0000015000]
   #11 [0000015000 - 0000017000]          PGTABLE ==> [0000015000 - 0000017000]
   #12 [0000ab4000 - 0000df7add]      NEW RAMDISK ==> [0000ab4000 - 0000df7add]
   #13 [0000017000 - 000001e000]          BOOTMAP ==> [0000017000 - 000001e000]
Zone PFN ranges:
   DMA      0x00000010 -> 0x00001000
   Normal   0x00001000 -> 0x000373fe
   HighMem  0x000373fe -> 0x000cff50
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
     0: 0x00000010 -> 0x0000009c
     0: 0x00000100 -> 0x000cff50
Using APIC driver default
ACPI: PM-Timer IO Port: 0x1008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 32, address 0xfec80000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 8 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000cc000
PM: Registered nosave memory: 00000000000cc000 - 00000000000d0000
PM: Registered nosave memory: 00000000000d0000 - 00000000000e4000
PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
Allocating PCI resources starting at d0000000 (gap: d0000000:10000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 14 pages/cpu @c2c00000 s35352 r0 d21992 u524288
pcpu-alloc: s35352 r0 d21992 u524288 alloc=1*4194304
pcpu-alloc: [0] 0 1 2 3 4 5 6 7
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 845021
Kernel command line: ro root=/dev/VolGroup00/LogVol00 console=ttyS0, 38400
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
allocated 17035520 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
Initializing HighMem for node 0 (000373fe:000cff50)
Memory: 3350528k/3407168k available (3472k kernel code, 54872k reserved, 2165k data, 448k init, 2501960k highmem)
virtual kernel memory layout:
     fixmap  : 0xffd54000 - 0xfffff000   (2732 kB)
     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
       .init : 0xc0982000 - 0xc09f2000   ( 448 kB)
       .data : 0xc07642f3 - 0xc09819a8   (2165 kB)
       .text : 0xc0400000 - 0xc07642f3   (3472 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:1280
Console: colour VGA+ 80x25
console [ttyS0] enabled
Fast TSC calibration using PIT
Detected 2000.006 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4000.01 BogoMIPS (lpj=2000006)
Security Framework initialized
SELinux:  Initializing.
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
using mwait in idle threads.
Performance Events: Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
Checking 'hlt' instruction... OK.
ACPI: Core revision 20091214
Enabling APIC mode:  Flat.  Using 2 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz stepping 06
Booting Node   0, Processors  #1
Initializing CPU#1
  #2
Initializing CPU#2
  #3
Initializing CPU#3
  #4
Initializing CPU#4
  #5
Initializing CPU#5
  #6
Initializing CPU#6
  #7 Ok.
Initializing CPU#7
Brought up 8 CPUs
Total of 8 processors activated (32000.11 BogoMIPS).
devtmpfs: initialized
regulator: core version 0.5
Time:  0:13:15  Date: 07/14/10
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-0d] at [mem 0xe0000000-0xe0dfffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xe0dfffff] reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI Error (psargs-0359): [Z000] Namespace lookup failure, AE_NOT_FOUND
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_._OSC] (Node f6c34498), AE_NOT_FOUND
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them




[root@ice-si-dmz ~]# cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz
stepping	: 6
cpu MHz		: 2000.193
cache size	: 6144 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon 
pebs bts aperfmperf pni dtes64 monitor ds_cpl vmx tm2 ssse3 cx16 xtpr pdcm dca sse4_1 lahf_lm tpr_shadow vnmi flexpriority
bogomips	: 4000.38
clflush size	: 64
cache_alignment	: 64
address sizes	: 38 bits physical, 48 bits virtual
power management:
.. x8


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

