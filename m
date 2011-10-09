Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246Ab1JIA1V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 20:27:21 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61134 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1JIA1U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 20:27:20 -0400
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Transfer-Encoding: 8BIT
Message-Id: <35C27021-40FC-4127-BC82-9F86FA9D624A@gmail.com>
Content-Type: text/plain; charset=WINDOWS-1252; delsp=yes; format=flowed
To: linux-kernel@vger.kernel.org
From: Robert Kubrick <robertkubrick@gmail.com>
Subject: 2.6.32 / RH 6.1 scheduler bloated
Date: Sat, 8 Oct 2011 20:26:39 -0400
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simple ftrace wakeup test shows 10us latency during the idle-to-run
transition:

# tracer: wakeup
#
# wakeup latency trace v1.1.5 on 2.6.32-131.0.15.el6.x86_64
# --------------------------------------------------------------------
# latency: 10 us, #4/4, CPU#6 | (M:desktop VP:0, KP:0, SP:0 HP:0 #P:12)
#    -----------------
#    | task: -30 (uid:0 nice:0 policy:1 rt_prio:99)
#    -----------------
#
#                  _------=> CPU#
#                 / _-----=> irqs-off
#                | / _----=> need-resched
#                || / _---=> hardirq/softirq
#                ||| / _--=> preempt-depth
#                |||| /_--=> lock-depth
#                |||||/     delay
#  cmd     pid   |||||| time  |   caller
#     \   /      ||||||   \   |   /
    <idle>-0       6d.h..    0us :      0:120:R   + [006]    30:  0:R
watchdog/6
    <idle>-0       6d.h..    1us+: wake_up_process <-watchdog_timer_fn
    <idle>-0       6d....   10us : thread_return <-cpu_idle
    <idle>-0       6d....   10us :      0:120:R ==> [006]    30:  0:R
watchdog/6


I've cheched several processes, they all show the same approx delay.
Red Hat 6.1 is compiled with ftrace enabled by default, anybody can
run this test:

# mount -t debugfs nodev /sys/kernel/debug
# cd /sys/kernel/debug/tracing
# echo wakeup > current_tracer
# echo myprocpid > set_ftrace_pid
# echo 1 > tracing_enabled
...
# cat trace

dmesg output

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.32-131.0.15.el6.x86_64  
(mockbuild@x86-007.build.bos.redhat.com) (gcc version 4.4.4 20100726  
(Red Hat 4.4.4-13) (GCC) ) #1 SMP Tue May 10 15:42:40 EDT 2011
Command line: ro root=UUID=36ac9c4c-17fe-4e2e-9672-cc518013837a  
rd_NO_LUKS rd_NO_LVM rd_NO_MD rd_NO_DM LANG=en_US.UTF-8  
SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us elevator=cfq  
crashkernel=auto rhgb quiet
KERNEL supported cpus:
   Intel GenuineIntel
   AMD AuthenticAMD
   Centaur CentaurHauls
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 00000000e762f000 (usable)
  BIOS-e820: 00000000e762f000 - 00000000e763c000 (ACPI data)
  BIOS-e820: 00000000e763c000 - 00000000e763d000 (usable)
  BIOS-e820: 00000000e763d000 - 00000000ec000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fee10000 (reserved)
  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
  BIOS-e820: 0000000100000000 - 0000000c17fff000 (usable)
DMI 2.7 present.
SMBIOS version 2.7 @ 0xF4F40
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==>  
(reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0xc17fff max_arch_pfn = 0x400000000
MTRR default type: write-back
MTRR fixed ranges enabled:
   00000-9FFFF write-back
   A0000-BFFFF uncachable
   C0000-FFFFF write-protect
MTRR variable ranges enabled:
   0 base 00E8000000 mask FFF8000000 uncachable
   1 base 00F0000000 mask FFF0000000 uncachable
   2 disabled
   3 disabled
   4 disabled
   5 disabled
   6 disabled
   7 disabled
   8 disabled
   9 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xe763d max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
Using GB pages for direct mapping
init_memory_mapping: 0000000000000000-00000000e763d000
  0000000000 - 00c0000000 page 1G
  00c0000000 - 00e7600000 page 2M
  00e7600000 - 00e763d000 page 4k
kernel direct mapping tables up to e763d000 @ 8000-b000
init_memory_mapping: 0000000100000000-0000000c17fff000
  0100000000 - 0c00000000 page 1G
  0c00000000 - 0c17e00000 page 2M
  0c17e00000 - 0c17fff000 page 4k
kernel direct mapping tables up to c17fff000 @ a000-d000
RAMDISK: 371fe000 - 37fef350
ACPI: RSDP 00000000000f4f00 00024 (v02 HP    )
ACPI: XSDT 00000000e7630040 000AC (v01 HP     ProLiant 00000002   “?  
0000162E)
ACPI: FACP 00000000e7630140 000F4 (v03 HP     ProLiant 00000002   “?  
0000162E)
ACPI Warning: Invalid length for Pm1aControlBlock: 32, using default  
16 (20090903/tbfadt-607)
ACPI Warning: Invalid length for Pm2ControlBlock: 32, using default 8  
(20090903/tbfadt-607)
ACPI: DSDT 00000000e7630240 0204D (v01 HP         DSDT 00000001 INTL  
20030228)
ACPI: FACS 00000000e762f100 00040
ACPI: SPCR 00000000e762f140 00050 (v01 HP     SPCRRBSU 00000001   “?  
0000162E)
ACPI: MCFG 00000000e762f1c0 0003C (v01 HP     ProLiant 00000001       
00000000)
ACPI: HPET 00000000e762f200 00038 (v01 HP     ProLiant 00000002   “?  
0000162E)
ACPI: FFFF 00000000e762f240 00064 (v02 HP     ProLiant 00000002   “?  
0000162E)
ACPI: SPMI 00000000e762f2c0 00040 (v05 HP     ProLiant 00000001   “?  
0000162E)
ACPI: ERST 00000000e762f300 001D0 (v01 HP     ProLiant 00000001   “?  
0000162E)
ACPI: APIC 00000000e762f500 0015E (v01 HP     ProLiant 00000002       
00000000)
ACPI: SRAT 00000000e762f680 00570 (v01 HP     Proliant 00000001   “?  
0000162E)
ACPI: FFFF 00000000e762fc00 00176 (v01 HP     ProLiant 00000001   “?  
0000162E)
ACPI: BERT 00000000e762fd80 00030 (v01 HP     ProLiant 00000001   “?  
0000162E)
ACPI: HEST 00000000e762fdc0 000BC (v01 HP     ProLiant 00000001   “?  
0000162E)
ACPI: FFFF 00000000e762fe80 00194 (v01 HP     ProLiant 00000001   “?  
0000162E)
ACPI: SSDT 00000000e76322c0 00125 (v03     HP  CRSPCI0 00000002   HP  
00000001)
ACPI: SSDT 00000000e7632400 003BB (v01     HP      pcc 00000001 INTL  
20090625)
ACPI: SSDT 00000000e76327c0 00377 (v01     HP     pmab 00000001 INTL  
20090625)
ACPI: SSDT 00000000e7632b40 01A34 (v01  INTEL PPM RCM  00000001 INTL  
20061109)
ACPI: Local APIC address 0xfee00000
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 2 -> Node 0
SRAT: PXM 0 -> APIC 4 -> Node 0
SRAT: PXM 0 -> APIC 16 -> Node 0
SRAT: PXM 0 -> APIC 18 -> Node 0
SRAT: PXM 0 -> APIC 20 -> Node 0
SRAT: PXM 1 -> APIC 32 -> Node 1
SRAT: PXM 1 -> APIC 34 -> Node 1
SRAT: PXM 1 -> APIC 36 -> Node 1
SRAT: PXM 1 -> APIC 48 -> Node 1
SRAT: PXM 1 -> APIC 50 -> Node 1
SRAT: PXM 1 -> APIC 52 -> Node 1
SRAT: Node 0 PXM 0 0-e8000000
SRAT: Node 0 PXM 0 100000000-618000000
SRAT: Node 1 PXM 1 618000000-c18000000
NUMA: Allocated memnodemap from c000 - c340
NUMA: Using 27 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000618000000
   NODE_DATA [000000000000c340 - 000000000004033f]
   bootmap [0000000000100000 -  00000000001c2fff] pages c3
(9 early reservations) ==> bootmem [0000000000 - 0618000000]
   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 -  
0000001000]
   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 -  
0000008000]
   #2 [0001000000 - 0001f474e4]    TEXT DATA BSS ==> [0001000000 -  
0001f474e4]
   #3 [00371fe000 - 0037fef350]          RAMDISK ==> [00371fe000 -  
0037fef350]
   #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 -  
0000100000]
   #5 [0001f48000 - 0001f48184]              BRK ==> [0001f48000 -  
0001f48184]
   #6 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 -  
000000a000]
   #7 [000000a000 - 000000c000]          PGTABLE ==> [000000a000 -  
000000c000]
   #8 [000000c000 - 000000c340]       MEMNODEMAP ==> [000000c000 -  
000000c340]
Bootmem setup node 1 0000000618000000-0000000c17fff000
   NODE_DATA [0000000618000040 - 000000061803403f]
   bootmap [0000000618035000 -  00000006180f4fff] pages c0
(9 early reservations) ==> bootmem [0618000000 - 0c17fff000]
   #0 [0000000000 - 0000001000]   BIOS data page
   #1 [0000006000 - 0000008000]       TRAMPOLINE
   #2 [0001000000 - 0001f474e4]    TEXT DATA BSS
   #3 [00371fe000 - 0037fef350]          RAMDISK
   #4 [000009f000 - 0000100000]    BIOS reserved
   #5 [0001f48000 - 0001f48184]              BRK
   #6 [0000008000 - 000000a000]          PGTABLE
   #7 [000000a000 - 000000c000]          PGTABLE
   #8 [000000c000 - 000000c340]       MEMNODEMAP
found SMP MP-table at [ffff8800000f4f80] f4f80
Reserving 129MB of memory at 32MB for crashkernel (System RAM: 49535MB)
  [ffffea0000000000-ffffea000edfffff] PMD -> [ffff880028600000- 
ffff880036ffffff] on node 0
[ffffea0015540000-ffffea00155fffff] potential offnode page_structs
  [ffffea000ee00000-ffffea00155fffff] PMD -> [ffff880038000000- 
ffff88003e7fffff] on node 0
  [ffffea0015600000-ffffea002a5fffff] PMD -> [ffff880618200000- 
ffff88062d1fffff] on node 1
Zone PFN ranges:
   DMA      0x00000001 -> 0x00001000
   DMA32    0x00001000 -> 0x00100000
   Normal   0x00100000 -> 0x00c17fff
Movable zone start PFN for each node
early_node_map[5] active PFN ranges
     0: 0x00000001 -> 0x0000009f
     0: 0x00000100 -> 0x000e762f
     0: 0x000e763c -> 0x000e763d
     0: 0x00100000 -> 0x00618000
     1: 0x00618000 -> 0x00c17fff
On node 0 totalpages: 6288846
   DMA zone: 56 pages used for memmap
   DMA zone: 104 pages reserved
   DMA zone: 3838 pages, LIFO batch:0
   DMA32 zone: 14280 pages used for memmap
   DMA32 zone: 929384 pages, LIFO batch:31
   Normal zone: 73024 pages used for memmap
   Normal zone: 5268160 pages, LIFO batch:31
On node 1 totalpages: 6291455
   Normal zone: 86016 pages used for memmap
   Normal zone: 6205439 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x908
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] enabled)
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x14] lapic_id[0x24] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x14] enabled)
ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x34] enabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x12] lapic_id[0x22] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x32] enabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x16] lapic_id[0x26] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x16] disabled)
ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x36] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x06] disabled)
ACPI: LAPIC (acpi_id[0x11] lapic_id[0x21] disabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x11] disabled)
ACPI: LAPIC (acpi_id[0x19] lapic_id[0x31] disabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x01] disabled)
ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x15] disabled)
ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x35] disabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x05] disabled)
ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x13] disabled)
ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x33] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x03] disabled)
ACPI: LAPIC (acpi_id[0x17] lapic_id[0x27] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x17] disabled)
ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x37] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x07] disabled)
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x00] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 0, version 32, address 0xfec80000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 32 CPUs, 20 hotplug CPUs
nr_irqs_gsi: 48
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
PM: Registered nosave memory: 00000000e762f000 - 00000000e763c000
PM: Registered nosave memory: 00000000e763d000 - 00000000ec000000
PM: Registered nosave memory: 00000000ec000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fee10000
PM: Registered nosave memory: 00000000fee10000 - 00000000ff800000
PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
Allocating PCI resources starting at ec000000 (gap: ec000000:12c00000)
Booting paravirtualized kernel on bare hardware
NR_CPUS:4096 nr_cpumask_bits:32 nr_cpu_ids:32 nr_node_ids:2
PERCPU: Embedded 30 pages/cpu @ffff880028200000 s92504 r8192 d22184  
u131072
pcpu-alloc: s92504 r8192 d22184 u131072 alloc=1*2097152
pcpu-alloc: [0] 00 02 04 06 08 10 13 15 17 19 21 23 25 27 29 31
pcpu-alloc: [1] 01 03 05 07 09 11 12 14 16 18 20 22 24 26 28 30
Built 2 zonelists in Zone order, mobility grouping on.  Total pages:  
12406821
Policy zone: Normal
Kernel command line: ro root=UUID=36ac9c4c-17fe-4e2e-9672- 
cc518013837a rd_NO_LUKS rd_NO_LVM rd_NO_MD rd_NO_DM LANG=en_US.UTF-8  
SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us elevator=cfq  
crashkernel=129M@0M rhgb quiet
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
AMD-Vi disabled by default: pass amd_iommu=on to enable
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
software IO TLB at phys 0x20000000 - 0x24000000
Memory: 49398256k/50724860k available (5014k kernel code, 403656k  
absent, 922948k reserved, 6906k data, 1232k init)
Hierarchical RCU implementation.
NR_IRQS:33024 nr_irqs:1072
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
allocated 503316480 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory  
cgroups
hpet clockevent registered
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Fast TSC calibration using PIT
Detected 2933.422 MHz processor.
Calibrating delay loop (skipped), value calculated using timer  
frequency.. 5866.84 BogoMIPS (lpj=2933422)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
ACPI: Core revision 20090903
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 20700 entries in 82 pages
Setting APIC routing to physical flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           X5670  @ 2.93GHz stepping 02
Performance Events: PEBS fmt1+, Westmere events, Broken BIOS  
detected, complain to your hardware vendor.
[Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 38d is 330)
Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
NMI watchdog enabled, takes one hw-pmu counter.
Booting Node   0, Processors  #1 Ok.
Booting Node   1, Processors  #2 Ok.
Booting Node   0, Processors  #3 Ok.
Booting Node   1, Processors  #4 Ok.
Booting Node   0, Processors  #5 Ok.
Booting Node   1, Processors  #6 Ok.
Booting Node   0, Processors  #7 Ok.
Booting Node   1, Processors  #8 Ok.
Booting Node   0, Processors  #9 Ok.
Booting Node   1, Processors  #10 Ok.
Booting Node   0, Processors  #11
Brought up 12 CPUs
Total of 12 processors activated (70398.87 BogoMIPS).
sizeof(vma)=200 bytes
sizeof(page)=56 bytes
sizeof(inode)=592 bytes
sizeof(dentry)=192 bytes
sizeof(ext3inode)=800 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=232 bytes
sizeof(task_struct)=2616 bytes
devtmpfs: initialized
regulator: core version 0.5
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e8000000 segment 0 buses 0 - 63
PCI: MCFG area at e8000000 reserved in E820
PCI: Using MMCONFIG at e8000000 - ebffffff
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:00.0: PME# disabled
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: PME# disabled
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
pci 0000:00:08.0: PME# disabled
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x1000-0x101f]
pci 0000:00:1d.1: reg 20 io port: [0x1020-0x103f]
pci 0000:00:1d.2: reg 20 io port: [0x1040-0x105f]
pci 0000:00:1d.3: reg 20 io port: [0x1060-0x107f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xf9cf0000-0xf9cf03ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:02:00.0: reg 10 64bit mmio: [0xfacf0000-0xfacf3fff]
pci 0000:02:00.0: reg 18 64bit mmio: [0xfacc0000-0xfacdffff]
pci 0000:02:00.0: reg 20 64bit mmio: [0xfaca0000-0xfacbffff]
pci 0000:02:00.0: reg 30 32bit mmio pref: [0x000000-0x03ffff]
pci 0000:02:00.0: PME# supported from D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:02:00.0: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.1: reg 10 64bit mmio: [0xfac90000-0xfac93fff]
pci 0000:02:00.1: reg 18 64bit mmio: [0xfac60000-0xfac7ffff]
pci 0000:02:00.1: reg 20 64bit mmio: [0xfac40000-0xfac5ffff]
pci 0000:02:00.1: reg 30 32bit mmio pref: [0x000000-0x03ffff]
pci 0000:02:00.1: PME# supported from D3hot D3cold
pci 0000:02:00.1: PME# disabled
pci 0000:02:00.1: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.2: reg 10 64bit mmio: [0xfac30000-0xfac33fff]
pci 0000:02:00.2: reg 18 64bit mmio: [0xfac00000-0xfac1ffff]
pci 0000:02:00.2: reg 20 64bit mmio: [0xfabe0000-0xfabfffff]
pci 0000:02:00.2: reg 30 32bit mmio pref: [0x000000-0x03ffff]
pci 0000:02:00.2: PME# supported from D3hot D3cold
pci 0000:02:00.2: PME# disabled
pci 0000:02:00.2: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.3: reg 10 64bit mmio: [0xfabd0000-0xfabd3fff]
pci 0000:02:00.3: reg 18 64bit mmio: [0xfaba0000-0xfabbffff]
pci 0000:02:00.3: reg 20 64bit mmio: [0xfab80000-0xfab9ffff]
pci 0000:02:00.3: reg 30 32bit mmio pref: [0x000000-0x03ffff]
pci 0000:02:00.3: PME# supported from D3hot D3cold
pci 0000:02:00.3: PME# disabled
pci 0000:02:00.3: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:00:03.0: bridge 32bit mmio: [0xfaa00000-0xfacfffff]
pci 0000:06:00.0: reg 10 64bit mmio: [0xfb400000-0xfb4fffff]
pci 0000:06:00.0: reg 18 64bit mmio pref: [0xf5000000-0xf57fffff]
pci 0000:06:00.0: reg 30 32bit mmio pref: [0x000000-0x0fffff]
pci 0000:00:07.0: bridge 32bit mmio: [0xfad00000-0xfb4fffff]
pci 0000:00:07.0: bridge 64bit mmio pref: [0xf1800000-0xf57fffff]
pci 0000:09:00.0: reg 10 64bit mmio: [0xfbc00000-0xfbcfffff]
pci 0000:09:00.0: reg 18 64bit mmio pref: [0xf9000000-0xf97fffff]
pci 0000:09:00.0: reg 30 32bit mmio pref: [0x000000-0x0fffff]
pci 0000:00:09.0: bridge 32bit mmio: [0xfb500000-0xfbcfffff]
pci 0000:00:09.0: bridge 64bit mmio pref: [0xf5800000-0xf97fffff]
pci 0000:0c:00.0: reg 10 64bit mmio: [0xfbe00000-0xfbffffff]
pci 0000:0c:00.0: reg 18 64bit mmio: [0xfbdf0000-0xfbdf0fff]
pci 0000:0c:00.0: reg 20 io port: [0x3000-0x30ff]
pci 0000:0c:00.0: reg 30 32bit mmio pref: [0x000000-0x07ffff]
pci 0000:0c:00.0: supports D1
pci 0000:0c:00.0: PME# supported from D0
pci 0000:0c:00.0: PME# disabled
pci 0000:00:1c.0: bridge io port: [0x3000-0x3fff]
pci 0000:00:1c.0: bridge 32bit mmio: [0xfbd00000-0xfbffffff]
pci 0000:01:00.0: reg 10 io port: [0x2000-0x20ff]
pci 0000:01:00.0: reg 14 32bit mmio: [0xfa9f0000-0xfa9f01ff]
pci 0000:01:00.0: reg 18 io port: [0x2400-0x24ff]
pci 0000:01:00.1: reg 10 32bit mmio pref: [0xf0000000-0xf0ffffff]
pci 0000:01:00.1: reg 14 32bit mmio: [0xfa9e0000-0xfa9e3fff]
pci 0000:01:00.1: reg 18 32bit mmio: [0xfa000000-0xfa7fffff]
pci 0000:01:00.2: reg 10 io port: [0x2800-0x28ff]
pci 0000:01:00.2: reg 14 32bit mmio: [0xf9ff0000-0xf9ff00ff]
pci 0000:01:00.2: reg 18 32bit mmio: [0xf9e00000-0xf9efffff]
pci 0000:01:00.2: reg 1c 32bit mmio: [0xf9d80000-0xf9dfffff]
pci 0000:01:00.2: reg 20 32bit mmio: [0xf9d70000-0xf9d77fff]
pci 0000:01:00.2: reg 24 32bit mmio: [0xf9d60000-0xf9d67fff]
pci 0000:01:00.2: reg 30 32bit mmio pref: [0x000000-0x00ffff]
pci 0000:01:00.2: PME# supported from D0 D3hot D3cold
pci 0000:01:00.2: PME# disabled
pci 0000:01:00.4: reg 20 io port: [0x2c00-0x2c1f]
pci 0000:00:1c.4: bridge io port: [0x2000-0x2fff]
pci 0000:00:1c.4: bridge 32bit mmio: [0xf9d00000-0xfa9fffff]
pci 0000:00:1c.4: bridge 64bit mmio pref: [0xf0000000-0xf0ffffff]
pci 0000:00:1e.0: transparent bridge
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IPT1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IPT5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT07._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT09._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *7 10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs *5 7 10 11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 5 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 5 7 *10 11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 5 *7 10 11)
HEST: HEST table parsing is initialized.
vgaarb: device added: PCI:0000:01:00.1,decodes=io+mem,owns=io 
+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: old code would have set cacheline size to 32 bytes, but  
clflush_size = 64
PCI: pci_cache_line_size set to 64 bytes
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0x408-0x40f has been reserved
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0x700-0x71f has been reserved
system 00:01: ioport range 0x880-0x8ff has been reserved
system 00:01: ioport range 0x900-0x97f has been reserved
system 00:01: ioport range 0xcd4-0xcd7 has been reserved
system 00:01: ioport range 0xcd0-0xcd3 has been reserved
system 00:01: ioport range 0xf50-0xf58 has been reserved
system 00:01: ioport range 0xca0-0xca1 has been reserved
system 00:01: ioport range 0xca4-0xca5 has been reserved
system 00:01: ioport range 0x3f8-0x3ff has been reserved
system 00:01: iomem range 0xe8000000-0xebffffff has been reserved
system 00:01: iomem range 0xfe000000-0xfebfffff has been reserved
pci 0000:00:01.0: PCI bridge to [bus 03-05]
pci 0000:00:01.0: PCI bridge, secondary bus 0000:03
pci 0000:00:01.0:   bridge window [io  disabled]
pci 0000:00:01.0:   bridge window [mem disabled]
pci 0000:00:01.0:   bridge window [mem pref disabled]
pci 0000:00:02.0: PCI bridge to [bus 0d-0d]
pci 0000:00:02.0: PCI bridge, secondary bus 0000:0d
pci 0000:00:02.0:   bridge window [io  disabled]
pci 0000:00:02.0:   bridge window [mem disabled]
pci 0000:00:02.0:   bridge window [mem pref disabled]
pci 0000:02:00.0: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.0: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.1: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.0: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.0: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.2: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.0: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.1: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.0: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.3: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.0: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.1: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.2: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.0: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.0: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.1: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.1: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.2: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.2: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.3: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:02:00.3: reg 1a4 64bit mmio: [0xffffc000-0xffffffff]
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0: PCI bridge, secondary bus 0000:02
pci 0000:00:03.0:   bridge window [io  disabled]
pci 0000:00:03.0:   bridge window [0xfaa00000-0xfacfffff]
pci 0000:00:03.0:   bridge window [0xec000000-0xec0fffff]
pci 0000:00:04.0: PCI bridge to [bus 0e-0e]
pci 0000:00:04.0: PCI bridge, secondary bus 0000:0e
pci 0000:00:04.0:   bridge window [io  disabled]
pci 0000:00:04.0:   bridge window [mem disabled]
pci 0000:00:04.0:   bridge window [mem pref disabled]
pci 0000:00:05.0: PCI bridge to [bus 0f-0f]
pci 0000:00:05.0: PCI bridge, secondary bus 0000:0f
pci 0000:00:05.0:   bridge window [io  disabled]
pci 0000:00:05.0:   bridge window [mem disabled]
pci 0000:00:05.0:   bridge window [mem pref disabled]
pci 0000:00:06.0: PCI bridge to [bus 10-10]
pci 0000:00:06.0: PCI bridge, secondary bus 0000:10
pci 0000:00:06.0:   bridge window [io  disabled]
pci 0000:00:06.0:   bridge window [mem disabled]
pci 0000:00:06.0:   bridge window [mem pref disabled]
pci 0000:00:07.0: PCI bridge to [bus 06-08]
pci 0000:00:07.0: PCI bridge, secondary bus 0000:06
pci 0000:00:07.0:   bridge window [io  disabled]
pci 0000:00:07.0:   bridge window [0xfad00000-0xfb4fffff]
pci 0000:00:07.0:   bridge window [0xf1800000-0xf57fffff]
pci 0000:00:08.0: PCI bridge to [bus 11-11]
pci 0000:00:08.0: PCI bridge, secondary bus 0000:11
pci 0000:00:08.0:   bridge window [io  disabled]
pci 0000:00:08.0:   bridge window [mem disabled]
pci 0000:00:08.0:   bridge window [mem pref disabled]
pci 0000:00:09.0: PCI bridge to [bus 09-0b]
pci 0000:00:09.0: PCI bridge, secondary bus 0000:09
pci 0000:00:09.0:   bridge window [io  disabled]
pci 0000:00:09.0:   bridge window [0xfb500000-0xfbcfffff]
pci 0000:00:09.0:   bridge window [0xf5800000-0xf97fffff]
pci 0000:00:0a.0: PCI bridge to [bus 12-12]
pci 0000:00:0a.0: PCI bridge, secondary bus 0000:12
pci 0000:00:0a.0:   bridge window [io  disabled]
pci 0000:00:0a.0:   bridge window [mem disabled]
pci 0000:00:0a.0:   bridge window [mem pref disabled]
pci 0000:00:1c.0: PCI bridge to [bus 0c-0c]
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0c
pci 0000:00:1c.0:   bridge window [0x3000-0x3fff]
pci 0000:00:1c.0:   bridge window [0xfbd00000-0xfbffffff]
pci 0000:00:1c.0:   bridge window [0xec100000-0xec1fffff]
pci 0000:00:1c.4: PCI bridge to [bus 01-01]
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:01
pci 0000:00:1c.4:   bridge window [0x2000-0x2fff]
pci 0000:00:1c.4:   bridge window [0xf9d00000-0xfa9fffff]
pci 0000:00:1c.4:   bridge window [0xf0000000-0xf0ffffff]
pci 0000:00:1e.0: PCI bridge to [bus 13-13]
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:13
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem disabled]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
pci 0000:00:01.0: PCIe errors handled by OS.
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:02.0: PCIe errors handled by OS.
pci 0000:00:02.0: setting latency timer to 64
pci 0000:00:03.0: PCIe errors handled by OS.
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:04.0: PCIe errors handled by OS.
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:05.0: PCIe errors handled by OS.
pci 0000:00:05.0: setting latency timer to 64
pci 0000:00:06.0: PCIe errors handled by OS.
pci 0000:00:06.0: setting latency timer to 64
pci 0000:00:07.0: PCIe errors handled by OS.
pci 0000:00:07.0: setting latency timer to 64
pci 0000:00:08.0: PCIe errors handled by OS.
pci 0000:00:08.0: setting latency timer to 64
pci 0000:00:09.0: PCIe errors handled by OS.
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0a.0: PCIe errors handled by OS.
pci 0000:00:0a.0: setting latency timer to 64
pci 0000:00:1c.0: PCIe errors handled by OS.
   alloc irq_desc for 16 on node -1
   alloc kstat_irqs on node -1
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.4: PCIe errors handled by OS.
pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:02: resource 1 mem: [0xfaa00000-0xfacfffff]
pci_bus 0000:02: resource 2 pref mem [0xec000000-0xec0fffff]
pci_bus 0000:06: resource 1 mem: [0xfad00000-0xfb4fffff]
pci_bus 0000:06: resource 2 pref mem [0xf1800000-0xf57fffff]
pci_bus 0000:09: resource 1 mem: [0xfb500000-0xfbcfffff]
pci_bus 0000:09: resource 2 pref mem [0xf5800000-0xf97fffff]
pci_bus 0000:0c: resource 0 io:  [0x3000-0x3fff]
pci_bus 0000:0c: resource 1 mem: [0xfbd00000-0xfbffffff]
pci_bus 0000:0c: resource 2 pref mem [0xec100000-0xec1fffff]
pci_bus 0000:01: resource 0 io:  [0x2000-0x2fff]
pci_bus 0000:01: resource 1 mem: [0xf9d00000-0xfa9fffff]
pci_bus 0000:01: resource 2 pref mem [0xf0000000-0xf0ffffff]
pci_bus 0000:13: resource 3 io:  [0x00-0xffff]
pci_bus 0000:13: resource 4 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
pci 0000:01:00.1: Boot video device
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 14276k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1317812923.038:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 32768
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
ksign: Installing public key data
Loading keyring
- Added public key C9F0DFBFCE81A817
- User ID: Red Hat, Inc. (Kernel Module GPG key)
- Added public key D4A26C9CCD09BEDA
- User ID: Red Hat Enterprise Linux Driver Update Program  
<secalert@redhat.com>
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: PCIe errors handled by OS.
pcieport 0000:00:02.0: PCIe errors handled by OS.
pcieport 0000:00:03.0: PCIe errors handled by OS.
pcieport 0000:00:04.0: PCIe errors handled by OS.
pcieport 0000:00:05.0: PCIe errors handled by OS.
pcieport 0000:00:06.0: PCIe errors handled by OS.
pcieport 0000:00:07.0: PCIe errors handled by OS.
pcieport 0000:00:08.0: PCIe errors handled by OS.
pcieport 0000:00:09.0: PCIe errors handled by OS.
pcieport 0000:00:0a.0: PCIe errors handled by OS.
pcieport 0000:00:1c.0: PCIe errors handled by OS.
pcieport 0000:00:1c.4: PCIe errors handled by OS.
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
pci-stub: invalid id string ""
intel_idle: MWAIT substates: 0x1120
intel_idle: v0.4 model 0x2C
intel_idle: lapic_timer_reliable_states 0xffffffff
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
ACPI: acpi_idle yielding to intel_idle
processor LNXCPU:00: registered as cooling_device0
processor LNXCPU:02: registered as cooling_device1
processor LNXCPU:04: registered as cooling_device2
processor LNXCPU:08: registered as cooling_device3
processor LNXCPU:0a: registered as cooling_device4
processor LNXCPU:0c: registered as cooling_device5
processor LNXCPU:10: registered as cooling_device6
processor LNXCPU:12: registered as cooling_device7
processor LNXCPU:14: registered as cooling_device8
processor LNXCPU:18: registered as cooling_device9
processor LNXCPU:1a: registered as cooling_device10
processor LNXCPU:1c: registered as cooling_device11
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (8 C)
ERST: Can not request iomem region  
<0xffff880bfc01be60-0xffff1017f8037cc0> for ERST.
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
crash memory driver: version 1.1
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
loop: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input1
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
   alloc irq_desc for 20 on node -1
   alloc kstat_irqs on node -1
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xf9cf0000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.32-131.0.15.el6.x86_64 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.32-131.0.15.el6.x86_64 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
   alloc irq_desc for 23 on node -1
   alloc kstat_irqs on node -1
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 23, io base 0x00001020
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.32-131.0.15.el6.x86_64 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
   alloc irq_desc for 22 on node -1
   alloc kstat_irqs on node -1
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001040
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.32-131.0.15.el6.x86_64 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001060
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.32-131.0.15.el6.x86_64 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
   alloc irq_desc for 17 on node -1
   alloc kstat_irqs on node -1
uhci_hcd 0000:01:00.4: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:01:00.4: setting latency timer to 64
uhci_hcd 0000:01:00.4: UHCI Host Controller
uhci_hcd 0000:01:00.4: new USB bus registered, assigned bus number 6
uhci_hcd 0000:01:00.4: port count misdetected? forcing to 2 ports
uhci_hcd 0000:01:00.4: irq 17, io base 0x00002c00
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.32-131.0.15.el6.x86_64 uhci_hcd
usb usb6: SerialNumber: 0000:01:00.4
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:0a: RTC can wake from S4
rtc_cmos 00:0a: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
rtc_cmos 00:0a: setting system clock to 2011-10-05 11:08:44 UTC  
(1317812924)
Initalizing network drop monitor service
Freeing unused kernel memory: 1232k freed
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 1112k freed
Freeing unused kernel memory: 1796k freed
dracut: dracut-004-53.el6
dracut: rd_NO_LUKS: removing cryptoluks activation
dracut: rd_NO_LVM: removing LVM activation
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.20.6-ioctl (2011-02-02) initialised: dm- 
devel@redhat.com
udev: starting version 147
dracut: Starting plymouth daemon
dracut: rd_NO_DM: removing DM RAID activation
dracut: rd_NO_MD: removing MD RAID activation
HP HPSA Driver (v 2.0.2-3)
hpsa 0000:0c:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
hpsa 0000:0c:00.0: MSIX
   alloc irq_desc for 48 on node -1
   alloc kstat_irqs on node -1
hpsa 0000:0c:00.0: irq 48 for MSI/MSI-X
   alloc irq_desc for 49 on node -1
   alloc kstat_irqs on node -1
hpsa 0000:0c:00.0: irq 49 for MSI/MSI-X
   alloc irq_desc for 50 on node -1
   alloc kstat_irqs on node -1
hpsa 0000:0c:00.0: irq 50 for MSI/MSI-X
   alloc irq_desc for 51 on node -1
   alloc kstat_irqs on node -1
hpsa 0000:0c:00.0: irq 51 for MSI/MSI-X
hpsa 0000:0c:00.0: hpsa0: <0x323a> at IRQ 48 using DAC
scsi0 : hpsa
hpsa 0000:0c:00.0: RAID              device c0b0t0l0 added.
hpsa 0000:0c:00.0: Direct-Access     device c0b0t0l1 added.
scsi 0:0:0:0: RAID              HP       P410i            3.66 PQ: 0  
ANSI: 5
scsi 0:0:0:1: Direct-Access     HP       LOGICAL VOLUME   3.66 PQ: 0  
ANSI: 5
sd 0:0:0:1: [sda] 585871964 512-byte logical blocks: (299 GB/279 GiB)
sd 0:0:0:1: [sda] Write Protect is off
sd 0:0:0:1: [sda] Mode Sense: 6b 00 00 08
sd 0:0:0:1: [sda] Write cache: disabled, read cache: enabled, doesn't  
support DPO or FUA
  sda: sda1 sda2 sda3
sd 0:0:0:1: [sda] Attached SCSI disk
usb 6-1: new full speed USB device using uhci_hcd and address 2
usb 6-1: New USB device found, idVendor=03f0, idProduct=7029
usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 6-1: Product: Virtual Keyboard
usb 6-1: Manufacturer: HP
usb 6-1: configuration #1 chosen from 1 choice
input: HP  Virtual Keyboard  as /devices/pci0000:00/0000:00:1c. 
4/0000:01:00.4/usb6/6-1/6-1:1.0/input/input2
generic-usb 0003:03F0:7029.0001: input,hidraw0: USB HID v1.01  
Keyboard [HP  Virtual Keyboard ] on usb-0000:01:00.4-1/input0
input: HP  Virtual Keyboard  as /devices/pci0000:00/0000:00:1c. 
4/0000:01:00.4/usb6/6-1/6-1:1.1/input/input3
generic-usb 0003:03F0:7029.0002: input,hidraw1: USB HID v1.01 Mouse  
[HP  Virtual Keyboard ] on usb-0000:01:00.4-1/input1
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda3): mounted filesystem with ordered data mode
dracut: Mounted root filesystem /dev/sda3
dracut: Loading SELinux policy
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
type=1404 audit(1317812925.417:2): selinux=0 auid=4294967295  
ses=4294967295
dracut: /sbin/load_policy: Can't load policy: No such file or directory
dracut: Switching root
readahead: starting
udev: starting version 147
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
EDAC MC: Ver: 2.1.0 May 10 2011
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/ 
BIOS
microcode: CPU0 sig=0x206c2, pf=0x1, revision=0x13
platform microcode: firmware: requesting intel-ucode/06-2c-02
microcode: CPU1 sig=0x206c2, pf=0x1, revision=0x13
platform microcode: firmware: requesting intel-ucode/06-2c-02
microcode: CPU2 sig=0x206c2, pf=0x1, revision=0x13
platform microcode: firmware: requesting intel-ucode/06-2c-02

[snip] ...