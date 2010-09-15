Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab0IOMdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 08:33:03 -0400
Received: from mail.electro-mechanical.com ([216.184.71.30]:47872 "EHLO
	mail.electro-mechanical.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448Ab0IOMc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 08:32:59 -0400
X-Greylist: delayed 1745 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Sep 2010 08:32:58 EDT
Date: Wed, 15 Sep 2010 08:03:49 -0400
From: William Thompson <wt@electro-mechanical.com>
To: linux-kernel@vger.kernel.org
Subject: OOM help
Message-ID: <20100915120349.GH29041@electro-mechanical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please keep me in the CC.  I am not on the list.

I have a system with 8GB of memory.  I'm using vanilla kernel 2.6.31.3.  The
system is 64-bit capable machine running a 32-bit x86 kernel.  PAE is in
use.  I have an odd problem with this system going oom.  The first time
this happened, the system had been up for over 300 days.  I had 4gb of swap
space available.

The first time the oom was triggered was during a read access to a 1TB
reiserfs volume over NFS.  In this case I was sequentually accessing 5 large
files (about 3gb total size).  The system slowed to a crawl for some time
(less then an hour) and processes were terminated.  I terminated the read on
the client when I noticed that it had hung.  It recovered from this instance.
This volume is mounted at /archive.

Eventually the system hung and had to be rebooted.

Several more attempts at reading those same files over NFS caused the system
to do the same thing.  Accesses to other large files on the same volume
caused similar problems.

Later I was copying files to this same volume and the system hung.  X and
the mouse were unresponsive.  I was unable to terminate the process.  After 2
hours, I had to reset the system.

I did not start most of the programs that I normally have open nor did I
activate the swap space.

At this point, I copyied everything to another volume formatted with ext4. 
I then DD'd the new volume to the device that contained the reiserfs.  Since
the destination is has a larger capacity, I increased the size of the ext4
volume with resize2fs.  I performed the same copy routine and oom kicked in
again.  At this time I was able to kill the copy process.

After this copy, free shows this:
             total       used       free     shared    buffers     cached
Mem:       8312192    1274804    7037388          0      46728     722168
-/+ buffers/cache:     505908    7806284
Swap:            0          0          0

The volume in question is on a raid1 (md1) between 2 1TB WDC WD1001FALS drives.  I
am using LVM to manage the volumes.
I have 50 volumes in LVM on this system.  Only one of those is located on
md1 (The one I've had problems with).

Is there any additional information that I need to provide?

Here is /proc/mdstat:
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] 
md1 : active raid1 sdc[0] sdd[1]
      976762496 blocks [2/2] [UU]
      bitmap: 0/233 pages [0KB], 2048KB chunk

md2 : active raid1 sdb2[1] sda2[0]
      1464147968 blocks [2/2] [UU]
      bitmap: 1/175 pages [4KB], 4096KB chunk

md0 : active raid1 sdb1[1] sda1[0]
      987840 blocks [2/2] [UU]
      bitmap: 2/121 pages [8KB], 4KB chunk

unused devices: <none>

Here is my df -T:
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/md0      ext3      971640    747920    184208  81% /
tmpfs        tmpfs     4156096         0   4156096   0% /lib/init/rw
tmpfs        tmpfs     4156096         4   4156092   1% /dev/shm
/dev/mapper/potatolvm-usr
              ext3     5160576   2532848   2418016  52% /usr
/dev/mapper/potatolvm-var
              ext3     1032088    356012    623648  37% /var
/dev/mapper/potatolvm-varcache
              ext3     2064208     86584   1893740   5% /var/cache
/dev/mapper/potatolvm-src
          reiserfs     5242716   5221404     21312 100% /usr/src
/dev/mapper/potatolvm-home
          reiserfs    26213596   1614812  24598784   7% /home
/dev/mapper/potatolvm-vm
              ext3   102390136  44345016  52928204  46% /vm
/dev/mapper/potatolvm-av
              ext3    10472248   5363012   5109236  52% /av
/dev/mapper/potatolvm-storage
          reiserfs    10485436   3254772   7230664  32% /storage
/dev/mapper/potatolvm-cdserv
              ext3   209695160 204498936   5196224  98% /cdserv
/dev/mapper/potatolvm-share
              ext3    41772608  41116856    655752  99% /nw
/dev/mapper/potatolvm-pub
          reiserfs    18513348  10338140   8175208  56% /pub
/dev/mapper/potatolvm-backup
              ext3    37453792  27860380   9212916  76% /backup
/dev/mapper/potatolvm-debian
          reiserfs   262135996 195965088  66170908  75% /debian
/dev/mapper/potatolvm-archive
              ext4   971689256 465762496 457088672  51% /archive

Here is the dmesg output on boot:
[    0.000000] Linux version 2.6.31.3 (root@potato) (gcc version 4.3.2 (Debian 4.3.2-1) ) #1 SMP PREEMPT Fri Oct 9 11:36:26 EDT 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfeb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfeb0000 - 00000000cfee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfee3000 - 00000000cfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000e4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x230000 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CEFFF write-protect
[    0.000000]   CF000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   2 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   3 base 100000000 mask F00000000 write-back
[    0.000000]   4 base 200000000 mask FC0000000 write-back
[    0.000000]   5 base 230000000 mask FF0000000 uncachable
[    0.000000]   6 base 0CFF00000 mask FFFF00000 uncachable
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000cff00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] initial memory mapped : 0 - 00a00000
[    0.000000] init_memory_mapping: 0000000000000000-000000001f1fe000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 001f000000 page 2M
[    0.000000]  001f000000 - 001f1fe000 page 4k
[    0.000000] kernel direct mapping tables up to 1f1fe000 @ 7000-d000
[    0.000000] ACPI: RSDP 000f7800 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT cfee3040 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP cfee30c0 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT cfee3180 050F5 (v01 GBT    GBTUACPI 00001000 MSFT 0100000C)
[    0.000000] ACPI: FACS cfeb0000 00040
[    0.000000] ACPI: HPET cfee83c0 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG cfee8440 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: APIC cfee82c0 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: SSDT cfee8e20 003AB (v01  PmRef    CpuPm 00003000 INTL 20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 8462MB HIGHMEM available.
[    0.000000] 497MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1f1fe000
[    0.000000]   low ram: 0 - 1f1fe000
[    0.000000]   node 0 low ram: 00000000 - 1f1fe000
[    0.000000]   node 0 bootmap 00002000 - 00005e40
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 001f1fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000200000 - 000068a784]    TEXT DATA BSS ==> [0000200000 - 000068a784]
[    0.000000]   #4 [000009e800 - 0000100000]    BIOS reserved ==> [000009e800 - 0000100000]
[    0.000000]   #5 [000068b000 - 00006900f6]              BRK ==> [000068b000 - 00006900f6]
[    0.000000]   #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
[    0.000000]   #7 [0000002000 - 0000006000]          BOOTMAP ==> [0000002000 - 0000006000]
[    0.000000] found SMP MP-table at [c00f59d0] f59d0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001f1fe
[    0.000000]   HighMem  0x0001f1fe -> 0x00230000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000cfeb0
[    0.000000]     0: 0x00100000 -> 0x00230000
[    0.000000] On node 0 totalpages: 2096718
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3966 pages, LIFO batch:0
[    0.000000]   Normal zone: 964 pages used for memmap
[    0.000000]   Normal zone: 122426 pages, LIFO batch:31
[    0.000000]   HighMem zone: 16925 pages used for memmap
[    0.000000]   HighMem zone: 1952405 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at e4000000 (gap: e4000000:1ac00000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages at c540f000, static data 27204 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2078797
[    0.000000] Kernel command line: root=/dev/md0 raid=auto vmalloc=512M
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (0001f1fe:00230000)
[    0.000000] Memory: 8310920k/9175040k available (2631k kernel code, 74992k reserved, 1019k data, 316k init, 7877320k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff1f000 - 0xfffff000   ( 896 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0xdf9fe000 - 0xff9fe000   ( 512 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xdf1fe000   ( 497 MB)
[    0.000000]       .init : 0xc0591000 - 0xc05e0000   ( 316 kB)
[    0.000000]       .data : 0xc0491cfd - 0xc0590968   (1019 kB)
[    0.000000]       .text : 0xc0200000 - 0xc0491cfd   (2631 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible RCU implementation.
[    0.000000] NR_IRQS:512
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2499.630 MHz processor.
[    0.000719] Console: colour VGA+ 80x25
[    0.000722] console [tty0] enabled
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4999.26 BogoMIPS (lpj=9998520)
[    0.004000] Mount-cache hash table entries: 512
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] using mwait in idle threads.
[    0.004000] Performance Counters: Core2 events, Intel PMU driver.
[    0.004000] ... version:                 2
[    0.004000] ... bit width:               40
[    0.004000] ... generic counters:        2
[    0.004000] ... value mask:              000000ffffffffff
[    0.004000] ... max period:              000000007fffffff
[    0.004000] ... fixed-purpose counters:  3
[    0.004000] ... counter mask:            0000000700000003
[    0.004000] Checking 'hlt' instruction... OK.
[    0.016403] ACPI: Core revision 20090521
[    0.023772] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.063492] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
[    0.064000] Booting processor 1 APIC 0x3 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4999.39 BogoMIPS (lpj=9998788)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 3
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.149294] CPU1: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
[    0.149583] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.152063] Booting processor 2 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#2
[    0.004000] Calibrating delay using timer specific routine.. 4999.37 BogoMIPS (lpj=9998745)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.245246] CPU2: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
[    0.245544] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.248073] Booting processor 3 APIC 0x2 ip 0x6000
[    0.004000] Initializing CPU#3
[    0.004000] Calibrating delay using timer specific routine.. 4999.38 BogoMIPS (lpj=9998763)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 2
[    0.004000] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.341223] CPU3: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
[    0.341515] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.344017] Brought up 4 CPUs
[    0.344053] Total of 4 processors activated (19997.40 BogoMIPS).
[    0.344753] xor: automatically using best checksumming function: pIII_sse
[    0.364001]    pIII_sse  :  9255.000 MB/sec
[    0.364031] xor: using function: pIII_sse (9255.000 MB/sec)
[    0.364092] NET: Registered protocol family 16
[    0.364375] ACPI: bus type pci registered
[    0.364513] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 63
[    0.364546] PCI: MCFG area at e0000000 reserved in E820
[    0.364577] PCI: Using MMCONFIG for extended config space
[    0.364608] PCI: Using configuration type 1 for base access
[    0.368784] bio: create slab <bio-0> at 0
[    0.369279] ACPI: EC: Look up EC in DSDT
[    0.373674] ACPI: Interpreter enabled
[    0.373725] ACPI: (supports S0 S3 S4 S5)
[    0.373858] ACPI: Using IOAPIC for interrupt routing
[    0.378549] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.379161] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.379194] pci 0000:00:01.0: PME# disabled
[    0.379279] pci 0000:00:1a.0: reg 20 io port: [0xe000-0xe01f]
[    0.379335] pci 0000:00:1a.1: reg 20 io port: [0xe100-0xe11f]
[    0.379392] pci 0000:00:1a.2: reg 20 io port: [0xe200-0xe21f]
[    0.379440] pci 0000:00:1a.7: reg 10 32bit mmio: [0xe9305000-0xe93053ff]
[    0.379505] pci 0000:00:1b.0: reg 10 64bit mmio: [0xe9300000-0xe9303fff]
[    0.379538] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.379571] pci 0000:00:1b.0: PME# disabled
[    0.379646] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.379679] pci 0000:00:1c.0: PME# disabled
[    0.379757] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.379790] pci 0000:00:1c.3: PME# disabled
[    0.379866] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.379899] pci 0000:00:1c.4: PME# disabled
[    0.379974] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.380002] pci 0000:00:1c.5: PME# disabled
[    0.380075] pci 0000:00:1d.0: reg 20 io port: [0xe300-0xe31f]
[    0.380131] pci 0000:00:1d.1: reg 20 io port: [0xe400-0xe41f]
[    0.380189] pci 0000:00:1d.2: reg 20 io port: [0xe500-0xe51f]
[    0.380237] pci 0000:00:1d.7: reg 10 32bit mmio: [0xe9304000-0xe93043ff]
[    0.380368] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.380406] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.380439] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0800 (mask 000f)
[    0.380476] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 (mask 000f)
[    0.380514] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 000b)
[    0.380599] pci 0000:00:1f.2: reg 10 io port: [0xe600-0xe607]
[    0.380603] pci 0000:00:1f.2: reg 14 io port: [0xe700-0xe703]
[    0.380608] pci 0000:00:1f.2: reg 18 io port: [0xe800-0xe807]
[    0.380612] pci 0000:00:1f.2: reg 1c io port: [0xe900-0xe903]
[    0.380617] pci 0000:00:1f.2: reg 20 io port: [0xea00-0xea1f]
[    0.380621] pci 0000:00:1f.2: reg 24 32bit mmio: [0xe9306000-0xe93067ff]
[    0.380646] pci 0000:00:1f.2: PME# supported from D3hot
[    0.380679] pci 0000:00:1f.2: PME# disabled
[    0.380729] pci 0000:00:1f.3: reg 10 64bit mmio: [0xe9307000-0xe93070ff]
[    0.380740] pci 0000:00:1f.3: reg 20 io port: [0x500-0x51f]
[    0.380777] pci 0000:01:00.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]
[    0.380784] pci 0000:01:00.0: reg 18 64bit mmio: [0xe5000000-0xe500ffff]
[    0.380788] pci 0000:01:00.0: reg 20 io port: [0xa000-0xa0ff]
[    0.380795] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.380809] pci 0000:01:00.0: supports D1 D2
[    0.380834] pci 0000:01:00.1: reg 10 64bit mmio: [0xe5010000-0xe501ffff]
[    0.380859] pci 0000:01:00.1: supports D1 D2
[    0.380893] pci 0000:00:01.0: bridge io port: [0xa000-0xafff]
[    0.380896] pci 0000:00:01.0: bridge 32bit mmio: [0xe4000000-0xe5ffffff]
[    0.380899] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.380982] pci 0000:03:00.0: reg 10 io port: [0xb000-0xb007]
[    0.380990] pci 0000:03:00.0: reg 14 io port: [0xb100-0xb103]
[    0.380998] pci 0000:03:00.0: reg 18 io port: [0xb200-0xb207]
[    0.381006] pci 0000:03:00.0: reg 1c io port: [0xb300-0xb303]
[    0.381013] pci 0000:03:00.0: reg 20 io port: [0xb400-0xb40f]
[    0.381093] pci 0000:00:1c.3: bridge io port: [0xb000-0xbfff]
[    0.381096] pci 0000:00:1c.3: bridge 32bit mmio: [0xe6000000-0xe6ffffff]
[    0.381138] pci 0000:04:00.0: reg 10 io port: [0xc000-0xc0ff]
[    0.381155] pci 0000:04:00.0: reg 18 64bit mmio: [0xe9010000-0xe9010fff]
[    0.381168] pci 0000:04:00.0: reg 20 64bit mmio: [0xe9000000-0xe900ffff]
[    0.381175] pci 0000:04:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
[    0.381209] pci 0000:04:00.0: supports D1 D2
[    0.381210] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.381245] pci 0000:04:00.0: PME# disabled
[    0.381321] pci 0000:00:1c.4: bridge io port: [0xc000-0xcfff]
[    0.381324] pci 0000:00:1c.4: bridge 32bit mmio: [0xe7000000-0xe7ffffff]
[    0.381328] pci 0000:00:1c.4: bridge 64bit mmio pref: [0xe9000000-0xe90fffff]
[    0.381368] pci 0000:05:00.0: reg 10 io port: [0xd000-0xd0ff]
[    0.381385] pci 0000:05:00.0: reg 18 64bit mmio: [0xe9110000-0xe9110fff]
[    0.381397] pci 0000:05:00.0: reg 20 64bit mmio: [0xe9100000-0xe910ffff]
[    0.381404] pci 0000:05:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
[    0.381439] pci 0000:05:00.0: supports D1 D2
[    0.381440] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.381475] pci 0000:05:00.0: PME# disabled
[    0.381550] pci 0000:00:1c.5: bridge io port: [0xd000-0xdfff]
[    0.381553] pci 0000:00:1c.5: bridge 32bit mmio: [0xe8000000-0xe8ffffff]
[    0.381558] pci 0000:00:1c.5: bridge 64bit mmio pref: [0xe9100000-0xe91fffff]
[    0.381605] pci 0000:06:07.0: reg 10 32bit mmio: [0xe9204000-0xe92047ff]
[    0.381611] pci 0000:06:07.0: reg 14 32bit mmio: [0xe9200000-0xe9203fff]
[    0.381648] pci 0000:06:07.0: supports D1 D2
[    0.381649] pci 0000:06:07.0: PME# supported from D0 D1 D2 D3hot
[    0.381693] pci 0000:06:07.0: PME# disabled
[    0.381752] pci 0000:00:1e.0: transparent bridge
[    0.381786] pci 0000:00:1e.0: bridge 32bit mmio: [0xe9200000-0xe92fffff]
[    0.381808] pci_bus 0000:00: on NUMA node 0
[    0.381811] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.381960] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.382009] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.382061] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.382105] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
[    0.382148] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.395023] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.395423] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.395822] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.396276] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 *15)
[    0.396674] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.397117] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
[    0.397516] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
[    0.397935] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 9 10 11 12 *14 15)
[    0.398574] SCSI subsystem initialized
[    0.398753] libata version 3.00 loaded.
[    0.398871] usbcore: registered new interface driver usbfs
[    0.398950] usbcore: registered new interface driver hub
[    0.399053] usbcore: registered new device driver usb
[    0.464007] raid6: int32x1    995 MB/s
[    0.532041] raid6: int32x2    945 MB/s
[    0.600002] raid6: int32x4    818 MB/s
[    0.668079] raid6: int32x8    686 MB/s
[    0.736003] raid6: mmxx1     3151 MB/s
[    0.804006] raid6: mmxx2     3605 MB/s
[    0.872007] raid6: sse1x1    2203 MB/s
[    0.940006] raid6: sse1x2    2806 MB/s
[    1.008010] raid6: sse2x1    4135 MB/s
[    1.076012] raid6: sse2x2    4885 MB/s
[    1.076041] raid6: using algorithm sse2x2 (4885 MB/s)
[    1.076085] PCI: Using ACPI for IRQ routing
[    1.148009] pnp: PnP ACPI init
[    1.148046] ACPI: bus type pnp registered
[    1.150643] pnp: PnP ACPI: found 13 devices
[    1.150674] ACPI: ACPI bus type pnp unregistered
[    1.150710] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    1.150743] system 00:01: ioport range 0x290-0x29f has been reserved
[    1.150775] system 00:01: ioport range 0x800-0x805 has been reserved
[    1.150807] system 00:01: ioport range 0x290-0x294 has been reserved
[    1.150839] system 00:01: ioport range 0x880-0x88f has been reserved
[    1.150872] system 00:01: ioport range 0x4c0-0x4ff could not be reserved
[    1.150909] system 00:09: ioport range 0x400-0x4bf could not be reserved
[    1.150944] system 00:0a: iomem range 0xe0000000-0xe3ffffff has been reserved
[    1.150979] system 00:0b: iomem range 0xd2000-0xd3fff has been reserved
[    1.151011] system 00:0b: iomem range 0xf0000-0xf7fff could not be reserved
[    1.151044] system 00:0b: iomem range 0xf8000-0xfbfff could not be reserved
[    1.151077] system 00:0b: iomem range 0xfc000-0xfffff could not be reserved
[    1.151110] system 00:0b: iomem range 0xcfeb0000-0xcfefffff could not be reserved
[    1.151146] system 00:0b: iomem range 0x0-0x9ffff could not be reserved
[    1.151179] system 00:0b: iomem range 0x100000-0xcfeaffff could not be reserved
[    1.151215] system 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
[    1.151251] system 00:0b: iomem range 0xfed10000-0xfed1dfff has been reserved
[    1.151284] system 00:0b: iomem range 0xfed20000-0xfed8ffff has been reserved
[    1.151317] system 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
[    1.151350] system 00:0b: iomem range 0xffb00000-0xffb7ffff has been reserved
[    1.151383] system 00:0b: iomem range 0xfff00000-0xffffffff has been reserved
[    1.151416] system 00:0b: iomem range 0xe0000-0xeffff has been reserved
[    1.186614] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    1.186647] pci 0000:00:01.0:   IO window: 0xa000-0xafff
[    1.186679] pci 0000:00:01.0:   MEM window: 0xe4000000-0xe5ffffff
[    1.186712] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    1.186750] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    1.186781] pci 0000:00:1c.0:   IO window: disabled
[    1.186814] pci 0000:00:1c.0:   MEM window: disabled
[    1.186845] pci 0000:00:1c.0:   PREFETCH window: disabled
[    1.186878] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:03
[    1.186910] pci 0000:00:1c.3:   IO window: 0xb000-0xbfff
[    1.186943] pci 0000:00:1c.3:   MEM window: 0xe6000000-0xe6ffffff
[    1.186976] pci 0000:00:1c.3:   PREFETCH window: disabled
[    1.187009] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:04
[    1.187041] pci 0000:00:1c.4:   IO window: 0xc000-0xcfff
[    1.187074] pci 0000:00:1c.4:   MEM window: 0xe7000000-0xe7ffffff
[    1.187108] pci 0000:00:1c.4:   PREFETCH window: 0x000000e9000000-0x000000e90fffff
[    1.187147] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:05
[    1.187179] pci 0000:00:1c.5:   IO window: 0xd000-0xdfff
[    1.187212] pci 0000:00:1c.5:   MEM window: 0xe8000000-0xe8ffffff
[    1.187245] pci 0000:00:1c.5:   PREFETCH window: 0x000000e9100000-0x000000e91fffff
[    1.187284] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:06
[    1.187316] pci 0000:00:1e.0:   IO window: disabled
[    1.187348] pci 0000:00:1e.0:   MEM window: 0xe9200000-0xe92fffff
[    1.187381] pci 0000:00:1e.0:   PREFETCH window: disabled
[    1.187419] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.187453] pci 0000:00:01.0: setting latency timer to 64
[    1.187458] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.187491] pci 0000:00:1c.0: setting latency timer to 64
[    1.187497] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.187531] pci 0000:00:1c.3: setting latency timer to 64
[    1.187536] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.187570] pci 0000:00:1c.4: setting latency timer to 64
[    1.187575] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.187609] pci 0000:00:1c.5: setting latency timer to 64
[    1.187614] pci 0000:00:1e.0: setting latency timer to 64
[    1.187617] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    1.187619] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    1.187621] pci_bus 0000:01: resource 0 io:  [0xa000-0xafff]
[    1.187623] pci_bus 0000:01: resource 1 mem: [0xe4000000-0xe5ffffff]
[    1.187625] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    1.187627] pci_bus 0000:03: resource 0 io:  [0xb000-0xbfff]
[    1.187628] pci_bus 0000:03: resource 1 mem: [0xe6000000-0xe6ffffff]
[    1.187630] pci_bus 0000:04: resource 0 io:  [0xc000-0xcfff]
[    1.187632] pci_bus 0000:04: resource 1 mem: [0xe7000000-0xe7ffffff]
[    1.187634] pci_bus 0000:04: resource 2 pref mem [0xe9000000-0xe90fffff]
[    1.187636] pci_bus 0000:05: resource 0 io:  [0xd000-0xdfff]
[    1.187637] pci_bus 0000:05: resource 1 mem: [0xe8000000-0xe8ffffff]
[    1.187639] pci_bus 0000:05: resource 2 pref mem [0xe9100000-0xe91fffff]
[    1.187641] pci_bus 0000:06: resource 1 mem: [0xe9200000-0xe92fffff]
[    1.187643] pci_bus 0000:06: resource 3 io:  [0x00-0xffff]
[    1.187644] pci_bus 0000:06: resource 4 mem: [0x000000-0xffffffffffffffff]
[    1.187665] NET: Registered protocol family 2
[    1.187756] IP route cache hash table entries: 16384 (order: 4, 65536 bytes)
[    1.187968] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    1.188118] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    1.188252] TCP: Hash tables configured (established 65536 bind 65536)
[    1.188284] TCP reno registered
[    1.188350] NET: Registered protocol family 1
[    1.190204] highmem bounce pool size: 64 pages
[    1.190237] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.190310] msgmni has been set to 848
[    1.190372] async_tx: api initialized (sync-only)
[    1.190406] io scheduler noop registered
[    1.190437] io scheduler cfq registered (default)
[    1.190568] pci 0000:01:00.0: Boot video device
[    1.190688] pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
[    1.190692] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    1.190839] pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
[    1.190845] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.191042] pcieport-driver 0000:00:1c.3: irq 26 for MSI/MSI-X
[    1.191048] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    1.191245] pcieport-driver 0000:00:1c.4: irq 27 for MSI/MSI-X
[    1.191251] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    1.191450] pcieport-driver 0000:00:1c.5: irq 28 for MSI/MSI-X
[    1.191457] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    1.191897] input: Power Button as /class/input/input0
[    1.191929] ACPI: Power Button [PWRF]
[    1.192034] input: Power Button as /class/input/input1
[    1.192065] ACPI: Power Button [PWRB]
[    1.192546] ACPI: SSDT cfee8540 0022A (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
[    1.192735] Marking TSC unstable due to TSC halts in idle
[    1.192823] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    1.192969] processor LNXCPU:00: registered as cooling_device0
[    1.193002] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.193222] ACPI: SSDT cfee8a00 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20040311)
[    1.193457] ACPI: CPU1 (power states: C1[C1] C2[C2])
[    1.193596] processor LNXCPU:01: registered as cooling_device1
[    1.193630] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.193783] ACPI: SSDT cfee8b60 00152 (v01  PmRef  Cpu2Ist 00003000 INTL 20040311)
[    1.194170] ACPI: CPU2 (power states: C1[C1] C2[C2])
[    1.194323] processor LNXCPU:02: registered as cooling_device2
[    1.194356] ACPI: Processor [CPU2] (supports 8 throttling states)
[    1.194594] ACPI: SSDT cfee8cc0 00152 (v01  PmRef  Cpu3Ist 00003000 INTL 20040311)
[    1.194824] ACPI: CPU3 (power states: C1[C1] C2[C2])
[    1.194951] processor LNXCPU:03: registered as cooling_device3
[    1.194985] ACPI: Processor [CPU3] (supports 8 throttling states)
[    1.199495] Real Time Clock Driver v1.12b
[    1.199526] Linux agpgart interface v0.103
[    1.199719] ahci 0000:00:1f.2: version 3.0
[    1.199728] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.199786] ahci 0000:00:1f.2: irq 29 for MSI/MSI-X
[    1.199817] ahci: SSS flag set, parallel bus scan disabled
[    1.199874] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    1.199912] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems 
[    1.199950] ahci 0000:00:1f.2: setting latency timer to 64
[    1.244810] scsi0 : ahci
[    1.244938] scsi1 : ahci
[    1.245056] scsi2 : ahci
[    1.245172] scsi3 : ahci
[    1.245287] scsi4 : ahci
[    1.245404] scsi5 : ahci
[    1.245490] ata1: SATA max UDMA/133 abar m2048@0xe9306000 port 0xe9306100 irq 29
[    1.245527] ata2: SATA max UDMA/133 abar m2048@0xe9306000 port 0xe9306180 irq 29
[    1.246042] ata3: SATA max UDMA/133 abar m2048@0xe9306000 port 0xe9306200 irq 29
[    1.246078] ata4: SATA max UDMA/133 abar m2048@0xe9306000 port 0xe9306280 irq 29
[    1.246114] ata5: SATA max UDMA/133 abar m2048@0xe9306000 port 0xe9306300 irq 29
[    1.246151] ata6: SATA max UDMA/133 abar m2048@0xe9306000 port 0xe9306380 irq 29
[    1.246243] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.246287] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.246326] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.246329] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.246378] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.250297] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    1.250305] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe9305000
[    1.268781] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.268830] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.268865] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.268907] usb usb1: Product: EHCI Host Controller
[    1.268938] usb usb1: Manufacturer: Linux 2.6.31.3 ehci_hcd
[    1.268969] usb usb1: SerialNumber: 0000:00:1a.7
[    1.269072] usb usb1: configuration #1 chosen from 1 choice
[    1.269161] hub 1-0:1.0: USB hub found
[    1.269197] hub 1-0:1.0: 6 ports detected
[    1.269266] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.269305] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.269307] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.269341] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.273278] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.273287] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe9304000
[    1.288779] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.288830] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.288865] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.288917] usb usb2: Product: EHCI Host Controller
[    1.288948] usb usb2: Manufacturer: Linux 2.6.31.3 ehci_hcd
[    1.288979] usb usb2: SerialNumber: 0000:00:1d.7
[    1.289074] usb usb2: configuration #1 chosen from 1 choice
[    1.289158] hub 2-0:1.0: USB hub found
[    1.289194] hub 2-0:1.0: 6 ports detected
[    1.289295] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.289373] uhci_hcd: USB Universal Host Controller Interface driver
[    1.289417] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.289452] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.289454] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.289489] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.289547] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e000
[    1.289599] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.289632] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.289668] usb usb3: Product: UHCI Host Controller
[    1.289698] usb usb3: Manufacturer: Linux 2.6.31.3 uhci_hcd
[    1.289729] usb usb3: SerialNumber: 0000:00:1a.0
[    1.289822] usb usb3: configuration #1 chosen from 1 choice
[    1.289906] hub 3-0:1.0: USB hub found
[    1.289942] hub 3-0:1.0: 2 ports detected
[    1.290001] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.290036] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.290038] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.290072] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.290130] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000e100
[    1.290181] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.290213] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.290249] usb usb4: Product: UHCI Host Controller
[    1.290279] usb usb4: Manufacturer: Linux 2.6.31.3 uhci_hcd
[    1.290310] usb usb4: SerialNumber: 0000:00:1a.1
[    1.290403] usb usb4: configuration #1 chosen from 1 choice
[    1.290488] hub 4-0:1.0: USB hub found
[    1.290524] hub 4-0:1.0: 2 ports detected
[    1.290582] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.290617] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.290620] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.290654] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    1.290706] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000e200
[    1.290758] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.290790] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.290826] usb usb5: Product: UHCI Host Controller
[    1.290857] usb usb5: Manufacturer: Linux 2.6.31.3 uhci_hcd
[    1.290888] usb usb5: SerialNumber: 0000:00:1a.2
[    1.290981] usb usb5: configuration #1 chosen from 1 choice
[    1.291065] hub 5-0:1.0: USB hub found
[    1.291102] hub 5-0:1.0: 2 ports detected
[    1.291161] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.291196] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.291198] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.291232] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    1.291285] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e300
[    1.291336] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.291369] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.291404] usb usb6: Product: UHCI Host Controller
[    1.291435] usb usb6: Manufacturer: Linux 2.6.31.3 uhci_hcd
[    1.291466] usb usb6: SerialNumber: 0000:00:1d.0
[    1.291564] usb usb6: configuration #1 chosen from 1 choice
[    1.291646] hub 6-0:1.0: USB hub found
[    1.291681] hub 6-0:1.0: 2 ports detected
[    1.291740] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.291775] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.291777] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.291811] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    1.291869] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e400
[    1.291920] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.291952] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.291988] usb usb7: Product: UHCI Host Controller
[    1.292018] usb usb7: Manufacturer: Linux 2.6.31.3 uhci_hcd
[    1.292050] usb usb7: SerialNumber: 0000:00:1d.1
[    1.292147] usb usb7: configuration #1 chosen from 1 choice
[    1.292232] hub 7-0:1.0: USB hub found
[    1.292269] hub 7-0:1.0: 2 ports detected
[    1.292328] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.292364] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.292366] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.292400] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    1.292452] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e500
[    1.292503] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    1.292536] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.292571] usb usb8: Product: UHCI Host Controller
[    1.292602] usb usb8: Manufacturer: Linux 2.6.31.3 uhci_hcd
[    1.292633] usb usb8: SerialNumber: 0000:00:1d.2
[    1.292726] usb usb8: configuration #1 chosen from 1 choice
[    1.292830] hub 8-0:1.0: USB hub found
[    1.292866] hub 8-0:1.0: 2 ports detected
[    1.293146] PNP: No PS/2 controller found. Probing ports directly.
[    1.326056] Failed to disable AUX port, but continuing anyway... Is this a SiS?
[    1.326092] If AUX port is really absent please use the 'i8042.noaux' option.
[    1.576783] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.576902] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.576994] mice: PS/2 mouse device common for all mice
[    1.577169] md: raid0 personality registered for level 0
[    1.577205] md: raid1 personality registered for level 1
[    1.577236] md: raid6 personality registered for level 6
[    1.577266] md: raid5 personality registered for level 5
[    1.577297] md: raid4 personality registered for level 4
[    1.577411] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    1.577790] cpuidle: using governor ladder
[    1.577982] usbcore: registered new interface driver usbhid
[    1.578020] usbhid: v2.6:USB HID core driver
[    1.578251] TCP cubic registered
[    1.578282] Using IPI No-Shortcut mode
[    1.605371] ata1.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
[    1.605406] ata1.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.647246] ata1.00: configured for UDMA/133
[    1.648776] usb 1-2: new high speed USB device using ehci_hcd and address 3
[    1.660854] scsi 0:0:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
[    1.661147] sd 0:0:0:0: [sda] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    1.661210] sd 0:0:0:0: [sda] Write Protect is off
[    1.661241] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.661255] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.661367]  sda: sda1 sda2
[    1.683496] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.785143] usb 1-2: New USB device found, idVendor=0424, idProduct=2504
[    1.785178] usb 1-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.785294] usb 1-2: configuration #1 chosen from 1 choice
[    1.785436] hub 1-2:1.0: USB hub found
[    1.785514] hub 1-2:1.0: 4 ports detected
[    1.896776] usb 1-3: new high speed USB device using ehci_hcd and address 4
[    2.044634] usb 1-3: New USB device found, idVendor=0781, idProduct=8889
[    2.044670] usb 1-3: New USB device strings: Mfr=2, Product=3, SerialNumber=4
[    2.044705] usb 1-3: Product: ImageMate 8 in 1
[    2.044742] usb 1-3: Manufacturer: SanDisk 
[    2.044796] usb 1-3: SerialNumber: 0000093481
[    2.044914] usb 1-3: configuration #1 chosen from 1 choice
[    2.156767] usb 1-4: new high speed USB device using ehci_hcd and address 5
[    2.289142] usb 1-4: New USB device found, idVendor=0424, idProduct=2504
[    2.289177] usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.289278] usb 1-4: configuration #1 chosen from 1 choice
[    2.289439] hub 1-4:1.0: USB hub found
[    2.289513] hub 1-4:1.0: 4 ports detected
[    2.392769] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.400767] usb 2-2: new high speed USB device using ehci_hcd and address 2
[    2.421398] ata2.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
[    2.421432] ata2.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.463309] ata2.00: configured for UDMA/133
[    2.480825] scsi 1:0:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
[    2.481076] sd 1:0:0:0: [sdb] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    2.481149] sd 1:0:0:0: [sdb] Write Protect is off
[    2.481180] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.481193] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.481301]  sdb: sdb1 sdb2
[    2.496265] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.533488] usb 2-2: New USB device found, idVendor=0409, idProduct=0058
[    2.533523] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.533558] usb 2-2: Product: USB2.0 Hub Controller
[    2.533596] usb 2-2: Manufacturer: NEC Corporation
[    2.533715] usb 2-2: configuration #1 chosen from 1 choice
[    2.533910] hub 2-2:1.0: USB hub found
[    2.533998] hub 2-2:1.0: 4 ports detected
[    2.644763] usb 2-5: new high speed USB device using ehci_hcd and address 3
[    2.825113] usb 2-5: New USB device found, idVendor=059f, idProduct=0202
[    2.825149] usb 2-5: New USB device strings: Mfr=73, Product=79, SerialNumber=110
[    2.825187] usb 2-5: Product: LaCie StudioDrive USB2        
[    2.825226] usb 2-5: Manufacturer: LaCie
[    2.825255] usb 2-5: SerialNumber: 11100E00048614F3
[    2.825364] usb 2-5: configuration #2 chosen from 1 choice
[    3.120749] usb 3-1: new low speed USB device using uhci_hcd and address 2
[    3.204756] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.205504] ata3.00: ATA-8: WDC WD1001FALS-00J7B0, 05.00K05, max UDMA/133
[    3.205539] ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.207320] ata3.00: configured for UDMA/133
[    3.224811] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1001FALS-0 05.0 PQ: 0 ANSI: 5
[    3.225075] sd 2:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.225149] sd 2:0:0:0: [sdc] Write Protect is off
[    3.225180] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    3.225194] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.225300]  sdc: unknown partition table
[    3.251624] sd 2:0:0:0: [sdc] Attached SCSI disk
[    3.365591] usb 3-1: New USB device found, idVendor=049f, idProduct=007c
[    3.365626] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.365661] usb 3-1: Product: Compaq Wireless HID Receiver
[    3.365699] usb 3-1: Manufacturer: Chicony
[    3.365820] usb 3-1: configuration #1 chosen from 1 choice
[    3.399834] input: Chicony Compaq Wireless HID Receiver as /class/input/input2
[    3.399878] generic-usb 0003:049F:007C.0001: input: USB HID v1.10 Keyboard [Chicony Compaq Wireless HID Receiver] on usb-0000:00:1a.0-1/input0
[    3.487649] input: Chicony Compaq Wireless HID Receiver as /class/input/input3
[    3.487700] generic-usb 0003:049F:007C.0002: input: USB HID v1.10 Device [Chicony Compaq Wireless HID Receiver] on usb-0000:00:1a.0-1/input1
[    3.512806] input: Chicony Compaq Wireless HID Receiver as /class/input/input4
[    3.512905] generic-usb 0003:049F:007C.0003: input: USB HID v1.10 Mouse [Chicony Compaq Wireless HID Receiver] on usb-0000:00:1a.0-1/input2
[    3.752741] usb 8-2: new low speed USB device using uhci_hcd and address 2
[    3.931590] usb 8-2: New USB device found, idVendor=04b4, idProduct=0501
[    3.931626] usb 8-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.931660] usb 8-2: Product: Keyboard Converter
[    3.931698] usb 8-2: Manufacturer: Unitech America Inc.
[    3.931801] usb 8-2: configuration #1 chosen from 1 choice
[    3.956751] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.956823] input: Unitech America Inc. Keyboard Converter as /class/input/input5
[    3.956867] generic-usb 0003:04B4:0501.0004: input: USB HID v1.00 Keyboard [Unitech America Inc. Keyboard Converter] on usb-0000:00:1d.2-2/input0
[    3.957505] ata4.00: ATA-8: WDC WD1001FALS-00J7B0, 05.00K05, max UDMA/133
[    3.957541] ata4.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.958869] ata4.00: configured for UDMA/133
[    3.972792] scsi 3:0:0:0: Direct-Access     ATA      WDC WD1001FALS-0 05.0 PQ: 0 ANSI: 5
[    3.973065] sd 3:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.973139] sd 3:0:0:0: [sdd] Write Protect is off
[    3.973170] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    3.973184] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.973288]  sdd: unknown partition table
[    3.990215] sd 3:0:0:0: [sdd] Attached SCSI disk
[    4.028883] usb 1-2.4: new full speed USB device using ehci_hcd and address 6
[    4.128375] usb 1-2.4: New USB device found, idVendor=0a5c, idProduct=2101
[    4.128411] usb 1-2.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.128450] usb 1-2.4: Product: Bluetooth Com One Device
[    4.128488] usb 1-2.4: Manufacturer: Broadcom Corp
[    4.128609] usb 1-2.4: configuration #1 chosen from 1 choice
[    4.296736] ata5: SATA link down (SStatus 0 SControl 300)
[    4.632729] ata6: SATA link down (SStatus 0 SControl 300)
[    4.648738] md: Waiting for all devices to be available before autodetect
[    4.648773] md: If you don't use raid, use raid=noautodetect
[    4.648947] md: Autodetecting RAID arrays.
[    4.731378] md: Scanned 4 and added 4 devices.
[    4.731410] md: autorun ...
[    4.731440] md: considering sdb2 ...
[    4.731475] md:  adding sdb2 ...
[    4.731511] md: sdb1 has different UUID to sdb2
[    4.731543] md:  adding sda2 ...
[    4.731574] md: sda1 has different UUID to sdb2
[    4.731727] md: created md2
[    4.731756] md: bind<sda2>
[    4.731790] md: bind<sdb2>
[    4.731823] md: running: <sdb2><sda2>
[    4.732070] raid1: raid set md2 active with 2 out of 2 mirrors
[    4.741498] md2: bitmap initialized from disk: read 11/11 pages, set 3 bits
[    4.741531] created bitmap (175 pages) for device md2
[    4.748414] md2: detected capacity change from 0 to 1499287519232
[    4.748488] md: considering sdb1 ...
[    4.748537] md:  adding sdb1 ...
[    4.748568] md:  adding sda1 ...
[    4.748599] md: created md0
[    4.748628] md: bind<sda1>
[    4.748664] md: bind<sdb1>
[    4.748698] md: running: <sdb1><sda1>
[    4.748940] raid1: raid set md0 active with 2 out of 2 mirrors
[    4.756519] md0: bitmap initialized from disk: read 8/8 pages, set 21 bits
[    4.756562] created bitmap (121 pages) for device md0
[    4.784511] md0: detected capacity change from 0 to 1011548160
[    4.784581] md: ... autorun DONE.
[    4.784666]  md0: unknown partition table
[    4.785625] EXT3-fs: INFO: recovery required on readonly filesystem.
[    4.785660] EXT3-fs: write access will be enabled during recovery.
[    5.030237] EXT3-fs: recovery complete.
[    5.030295] kjournald starting.  Commit interval 5 seconds
[    5.031133] EXT3-fs: mounted filesystem with writeback data mode.
[    5.031177] VFS: Mounted root (ext3 filesystem) readonly on device 9:0.
[    5.031262] Freeing unused kernel memory: 316k freed
[    6.159029] EXT3 FS on md0, internal journal
[    6.461996] coretemp coretemp.0: Using relative temperature scale!
[    6.464418] coretemp coretemp.1: Using relative temperature scale!
[    6.465516] coretemp coretemp.2: Using relative temperature scale!
[    6.466146] coretemp coretemp.3: Using relative temperature scale!
[    6.502786] it87: Found IT8718F chip at 0x290, revision 5
[    6.502828] it87: in3 is VCC (+5V)
[    6.766526]  md2: unknown partition table
[    6.995897] md: md1 stopped.
[    7.033292] md: bind<sdd>
[    7.033466] md: bind<sdc>
[    7.068844] raid1: raid set md1 active with 2 out of 2 mirrors
[    7.080840] md1: bitmap initialized from disk: read 15/15 pages, set 0 bits
[    7.080876] created bitmap (233 pages) for device md1
[    7.101393] md1: detected capacity change from 0 to 1000204795904
[    7.101851]  md1: unknown partition table

Here is the dmesg when the oom kicked in:
[1557576.330762] Xorg invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
[1557576.330767] Pid: 6696, comm: Xorg Not tainted 2.6.31.3 #1
[1557576.330769] Call Trace:
[1557576.330775]  [<c02679ec>] ? oom_kill_process+0xac/0x250
[1557576.330777]  [<c0267e57>] ? badness+0x167/0x240
[1557576.330780]  [<c0268074>] ? __out_of_memory+0x144/0x170
[1557576.330782]  [<c02680f4>] ? out_of_memory+0x54/0xb0
[1557576.330785]  [<c026b211>] ? __alloc_pages_nodemask+0x541/0x560
[1557576.330788]  [<c026b284>] ? __get_free_pages+0x14/0x30
[1557576.330791]  [<c02a1b62>] ? __pollwait+0xa2/0xf0
[1557576.330794]  [<c0479ab4>] ? unix_poll+0x14/0xa0
[1557576.330797]  [<c040a00c>] ? sock_poll+0xc/0x10
[1557576.330799]  [<c02a12ab>] ? do_select+0x2bb/0x550
[1557576.330801]  [<c02a1ac0>] ? __pollwait+0x0/0xf0
[1557576.330804]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.330806]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.330808]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.330810]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.330812]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.330814]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.330816]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.330818]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.330821]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.330823]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.330825]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.330827]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.330829]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.330831]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.330833]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.330835]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.330837]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.330839]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.330841]  [<c02a1730>] ? core_sys_select+0x1f0/0x320
[1557576.330844]  [<c029f9f3>] ? do_vfs_ioctl+0x3e3/0x610
[1557576.330847]  [<c024354c>] ? hrtimer_try_to_cancel+0x3c/0x80
[1557576.330850]  [<c02481a4>] ? getnstimeofday+0x54/0x110
[1557576.330852]  [<c02a1a3f>] ? sys_select+0x2f/0xb0
[1557576.330855]  [<c0202f61>] ? syscall_call+0x7/0xb
[1557576.330857] Mem-Info:
[1557576.330858] DMA per-cpu:
[1557576.330860] CPU    0: hi:    0, btch:   1 usd:   0
[1557576.330861] CPU    1: hi:    0, btch:   1 usd:   0
[1557576.330863] CPU    2: hi:    0, btch:   1 usd:   0
[1557576.330864] CPU    3: hi:    0, btch:   1 usd:   0
[1557576.330865] Normal per-cpu:
[1557576.330867] CPU    0: hi:  186, btch:  31 usd: 104
[1557576.330868] CPU    1: hi:  186, btch:  31 usd: 167
[1557576.330870] CPU    2: hi:  186, btch:  31 usd: 171
[1557576.330871] CPU    3: hi:  186, btch:  31 usd: 173
[1557576.330873] HighMem per-cpu:
[1557576.330874] CPU    0: hi:  186, btch:  31 usd:  24
[1557576.330875] CPU    1: hi:  186, btch:  31 usd:   1
[1557576.330877] CPU    2: hi:  186, btch:  31 usd:  23
[1557576.330878] CPU    3: hi:  186, btch:  31 usd:  17
[1557576.330881] Active_anon:99096 active_file:75187 inactive_anon:14426
[1557576.330882]  inactive_file:1117251 unevictable:867 dirty:0 writeback:256 unstable:0
[1557576.330883]  free:673090 slab:89233 mapped:22358 pagetables:1487 bounce:0
[1557576.330886] DMA free:1984kB min:88kB low:108kB high:132kB active_anon:0kB inactive_anon:0kB active_file:140kB inactive_file:0kB unevictable:0kB present:15864kB pages_scanned:256 all_unreclaimable? yes
[1557576.330888] lowmem_reserve[]: 0 478 8104 8104
[1557576.330892] Normal free:2728kB min:2752kB low:3440kB high:4128kB active_anon:0kB inactive_anon:0kB active_file:23296kB inactive_file:22748kB unevictable:0kB present:489704kB pages_scanned:72700 all_unreclaimable? yes
[1557576.330895] lowmem_reserve[]: 0 0 61012 61012
[1557576.330899] HighMem free:2687648kB min:512kB low:11492kB high:22476kB active_anon:396384kB inactive_anon:57704kB active_file:277312kB inactive_file:4446256kB unevictable:3468kB present:7809620kB pages_scanned:0 all_unreclaimable? no
[1557576.330902] lowmem_reserve[]: 0 0 0 0
[1557576.330905] DMA: 14*4kB 15*8kB 14*16kB 11*32kB 6*64kB 5*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2032kB
[1557576.330912] Normal: 166*4kB 0*8kB 3*16kB 28*32kB 8*64kB 3*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2760kB
[1557576.330919] HighMem: 2*4kB 2*8kB 1*16kB 0*32kB 6*64kB 6*128kB 521*256kB 3334*512kB 636*1024kB 91*2048kB 2*4096kB = 2687400kB
[1557576.330927] 1193548 total pagecache pages
[1557576.330928] 0 pages in swap cache
[1557576.330930] Swap cache stats: add 0, delete 0, find 0/0
[1557576.330931] Free swap  = 0kB
[1557576.330932] Total swap = 0kB
[1557576.351721] 2162688 pages RAM
[1557576.351724] 2035202 pages HighMem
[1557576.351725] 86689 pages reserved
[1557576.351727] 1221151 pages shared
[1557576.351728] 241369 pages non-shared
[1557576.351730] Out of memory: kill process 23372 (slapd) score 4718 or a child
[1557576.351764] Killed process 23372 (slapd)
[1557576.354830] Xorg invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
[1557576.354833] Pid: 6696, comm: Xorg Not tainted 2.6.31.3 #1
[1557576.354835] Call Trace:
[1557576.354841]  [<c02679ec>] ? oom_kill_process+0xac/0x250
[1557576.354844]  [<c0267e57>] ? badness+0x167/0x240
[1557576.354846]  [<c0268074>] ? __out_of_memory+0x144/0x170
[1557576.354849]  [<c02680f4>] ? out_of_memory+0x54/0xb0
[1557576.354851]  [<c026b211>] ? __alloc_pages_nodemask+0x541/0x560
[1557576.354854]  [<c026b284>] ? __get_free_pages+0x14/0x30
[1557576.354857]  [<c02a1b62>] ? __pollwait+0xa2/0xf0
[1557576.354860]  [<c0479ab4>] ? unix_poll+0x14/0xa0
[1557576.354863]  [<c040a00c>] ? sock_poll+0xc/0x10
[1557576.354865]  [<c02a12ab>] ? do_select+0x2bb/0x550
[1557576.354868]  [<c02a1ac0>] ? __pollwait+0x0/0xf0
[1557576.354870]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.354872]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.354874]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.354876]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.354878]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.354880]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.354882]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.354884]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.354886]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.354888]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.354890]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.354892]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.354894]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.354896]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.354898]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.354900]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.354902]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.354904]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.354907]  [<c02a1730>] ? core_sys_select+0x1f0/0x320
[1557576.354910]  [<c029f9f3>] ? do_vfs_ioctl+0x3e3/0x610
[1557576.354913]  [<c024354c>] ? hrtimer_try_to_cancel+0x3c/0x80
[1557576.354915]  [<c02481a4>] ? getnstimeofday+0x54/0x110
[1557576.354918]  [<c02a1a3f>] ? sys_select+0x2f/0xb0
[1557576.354920]  [<c0202f61>] ? syscall_call+0x7/0xb
[1557576.354922] Mem-Info:
[1557576.354923] DMA per-cpu:
[1557576.354924] CPU    0: hi:    0, btch:   1 usd:   0
[1557576.354926] CPU    1: hi:    0, btch:   1 usd:   0
[1557576.354927] CPU    2: hi:    0, btch:   1 usd:   0
[1557576.354929] CPU    3: hi:    0, btch:   1 usd:   0
[1557576.354930] Normal per-cpu:
[1557576.354932] CPU    0: hi:  186, btch:  31 usd: 155
[1557576.354933] CPU    1: hi:  186, btch:  31 usd: 180
[1557576.354935] CPU    2: hi:  186, btch:  31 usd: 171
[1557576.354936] CPU    3: hi:  186, btch:  31 usd: 173
[1557576.354937] HighMem per-cpu:
[1557576.354938] CPU    0: hi:  186, btch:  31 usd: 169
[1557576.354940] CPU    1: hi:  186, btch:  31 usd:   1
[1557576.354941] CPU    2: hi:  186, btch:  31 usd:  23
[1557576.354943] CPU    3: hi:  186, btch:  31 usd:  17
[1557576.354945] Active_anon:99032 active_file:75187 inactive_anon:13850
[1557576.354946]  inactive_file:1117251 unevictable:867 dirty:0 writeback:64 unstable:0
[1557576.354947]  free:673524 slab:89233 mapped:21718 pagetables:1459 bounce:0
[1557576.354950] DMA free:1984kB min:88kB low:108kB high:132kB active_anon:0kB inactive_anon:0kB active_file:140kB inactive_file:0kB unevictable:0kB present:15864kB pages_scanned:256 all_unreclaimable? yes
[1557576.354953] lowmem_reserve[]: 0 478 8104 8104
[1557576.354957] Normal free:2728kB min:2752kB low:3440kB high:4128kB active_anon:0kB inactive_anon:0kB active_file:23296kB inactive_file:22748kB unevictable:0kB present:489704kB pages_scanned:72700 all_unreclaimable? yes
[1557576.354959] lowmem_reserve[]: 0 0 61012 61012
[1557576.354964] HighMem free:2689384kB min:512kB low:11492kB high:22476kB active_anon:396128kB inactive_anon:55400kB active_file:277312kB inactive_file:4446256kB unevictable:3468kB present:7809620kB pages_scanned:0 all_unreclaimable? no
[1557576.354966] lowmem_reserve[]: 0 0 0 0
[1557576.354969] DMA: 14*4kB 15*8kB 14*16kB 11*32kB 6*64kB 5*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2032kB
[1557576.354976] Normal: 166*4kB 0*8kB 3*16kB 28*32kB 8*64kB 3*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2760kB
[1557576.354984] HighMem: 163*4kB 34*8kB 21*16kB 8*32kB 8*64kB 6*128kB 522*256kB 3334*512kB 636*1024kB 91*2048kB 2*4096kB = 2689260kB
[1557576.354991] 1193548 total pagecache pages
[1557576.354992] 0 pages in swap cache
[1557576.354994] Swap cache stats: add 0, delete 0, find 0/0
[1557576.354995] Free swap  = 0kB
[1557576.354996] Total swap = 0kB
[1557576.375498] 2162688 pages RAM
[1557576.375500] 2035202 pages HighMem
[1557576.375502] 86689 pages reserved
[1557576.375503] 1220297 pages shared
[1557576.375504] 240990 pages non-shared
[1557576.375506] Out of memory: kill process 6857 (fvwm2) score 3630 or a child
[1557576.375539] Killed process 6861 (FvwmCommandS)
[1557576.378837] Xorg invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
[1557576.378841] Pid: 6696, comm: Xorg Not tainted 2.6.31.3 #1
[1557576.378842] Call Trace:
[1557576.378849]  [<c02679ec>] ? oom_kill_process+0xac/0x250
[1557576.378851]  [<c0267e57>] ? badness+0x167/0x240
[1557576.378854]  [<c0268074>] ? __out_of_memory+0x144/0x170
[1557576.378856]  [<c02680f4>] ? out_of_memory+0x54/0xb0
[1557576.378859]  [<c026b211>] ? __alloc_pages_nodemask+0x541/0x560
[1557576.378861]  [<c026b284>] ? __get_free_pages+0x14/0x30
[1557576.378864]  [<c02a1b62>] ? __pollwait+0xa2/0xf0
[1557576.378867]  [<c0479ab4>] ? unix_poll+0x14/0xa0
[1557576.378870]  [<c040a00c>] ? sock_poll+0xc/0x10
[1557576.378873]  [<c02a12ab>] ? do_select+0x2bb/0x550
[1557576.378875]  [<c02a1ac0>] ? __pollwait+0x0/0xf0
[1557576.378878]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.378880]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.378882]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.378884]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.378886]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.378888]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.378890]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.378892]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.378894]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.378896]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.378898]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.378900]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.378902]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.378904]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.378906]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.378908]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.378910]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.378912]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557576.378914]  [<c02a1730>] ? core_sys_select+0x1f0/0x320
[1557576.378917]  [<c029f9f3>] ? do_vfs_ioctl+0x3e3/0x610
[1557576.378920]  [<c024354c>] ? hrtimer_try_to_cancel+0x3c/0x80
[1557576.378923]  [<c02481a4>] ? getnstimeofday+0x54/0x110
[1557576.378925]  [<c02a1a3f>] ? sys_select+0x2f/0xb0
[1557576.378928]  [<c0202f61>] ? syscall_call+0x7/0xb
[1557576.378929] Mem-Info:
[1557576.378930] DMA per-cpu:
[1557576.378932] CPU    0: hi:    0, btch:   1 usd:   0
[1557576.378933] CPU    1: hi:    0, btch:   1 usd:   0
[1557576.378935] CPU    2: hi:    0, btch:   1 usd:   0
[1557576.378936] CPU    3: hi:    0, btch:   1 usd:   0
[1557576.378937] Normal per-cpu:
[1557576.378939] CPU    0: hi:  186, btch:  31 usd: 164
[1557576.378940] CPU    1: hi:  186, btch:  31 usd: 180
[1557576.378942] CPU    2: hi:  186, btch:  31 usd: 173
[1557576.378943] CPU    3: hi:  186, btch:  31 usd: 173
[1557576.378945] HighMem per-cpu:
[1557576.378946] CPU    0: hi:  186, btch:  31 usd: 164
[1557576.378947] CPU    1: hi:  186, btch:  31 usd:   1
[1557576.378949] CPU    2: hi:  186, btch:  31 usd:  23
[1557576.378950] CPU    3: hi:  186, btch:  31 usd:  17
[1557576.378953] Active_anon:99032 active_file:75187 inactive_anon:13850
[1557576.378954]  inactive_file:1117251 unevictable:867 dirty:0 writeback:64 unstable:0
[1557576.378955]  free:673586 slab:89233 mapped:21718 pagetables:1459 bounce:0
[1557576.378958] DMA free:1984kB min:88kB low:108kB high:132kB active_anon:0kB inactive_anon:0kB active_file:140kB inactive_file:0kB unevictable:0kB present:15864kB pages_scanned:256 all_unreclaimable? yes
[1557576.378960] lowmem_reserve[]: 0 478 8104 8104
[1557576.378964] Normal free:2728kB min:2752kB low:3440kB high:4128kB active_anon:0kB inactive_anon:0kB active_file:23296kB inactive_file:22748kB unevictable:0kB present:489704kB pages_scanned:72700 all_unreclaimable? yes
[1557576.378967] lowmem_reserve[]: 0 0 61012 61012
[1557576.378971] HighMem free:2689632kB min:512kB low:11492kB high:22476kB active_anon:396128kB inactive_anon:55400kB active_file:277312kB inactive_file:4446256kB unevictable:3468kB present:7809620kB pages_scanned:0 all_unreclaimable? no
[1557576.378974] lowmem_reserve[]: 0 0 0 0
[1557576.378977] DMA: 14*4kB 15*8kB 14*16kB 11*32kB 6*64kB 5*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2032kB
[1557576.378984] Normal: 166*4kB 0*8kB 3*16kB 28*32kB 8*64kB 3*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2760kB
[1557576.378991] HighMem: 163*4kB 33*8kB 21*16kB 8*32kB 8*64kB 8*128kB 522*256kB 3334*512kB 636*1024kB 91*2048kB 2*4096kB = 2689508kB
[1557576.378998] 1193548 total pagecache pages
[1557576.378999] 0 pages in swap cache
[1557576.379001] Swap cache stats: add 0, delete 0, find 0/0
[1557576.379002] Free swap  = 0kB
[1557576.379003] Total swap = 0kB
[1557576.399526] 2162688 pages RAM
[1557576.399528] 2035202 pages HighMem
[1557576.399529] 86689 pages reserved
[1557576.399530] 1220218 pages shared
[1557576.399531] 240925 pages non-shared
[1557576.399534] Out of memory: kill process 6857 (fvwm2) score 3627 or a child
[1557576.399567] Killed process 6869 (FvwmButtons)
[1557579.492687] Xorg invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
[1557579.492691] Pid: 6696, comm: Xorg Not tainted 2.6.31.3 #1
[1557579.492693] Call Trace:
[1557579.492699]  [<c02679ec>] ? oom_kill_process+0xac/0x250
[1557579.492702]  [<c0267e57>] ? badness+0x167/0x240
[1557579.492704]  [<c0268074>] ? __out_of_memory+0x144/0x170
[1557579.492707]  [<c02680f4>] ? out_of_memory+0x54/0xb0
[1557579.492709]  [<c026b211>] ? __alloc_pages_nodemask+0x541/0x560
[1557579.492712]  [<c026b284>] ? __get_free_pages+0x14/0x30
[1557579.492715]  [<c02a1b62>] ? __pollwait+0xa2/0xf0
[1557579.492718]  [<c0479ab4>] ? unix_poll+0x14/0xa0
[1557579.492721]  [<c040a00c>] ? sock_poll+0xc/0x10
[1557579.492723]  [<c02a12ab>] ? do_select+0x2bb/0x550
[1557579.492726]  [<c02a1ac0>] ? __pollwait+0x0/0xf0
[1557579.492728]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.492730]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.492732]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.492734]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.492736]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.492739]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.492741]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.492743]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.492745]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.492747]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.492749]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.492751]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.492753]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.492755]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.492757]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.492759]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.492761]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.492763]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.492765]  [<c02a1730>] ? core_sys_select+0x1f0/0x320
[1557579.492768]  [<c029f9f3>] ? do_vfs_ioctl+0x3e3/0x610
[1557579.492771]  [<c024354c>] ? hrtimer_try_to_cancel+0x3c/0x80
[1557579.492774]  [<c02481a4>] ? getnstimeofday+0x54/0x110
[1557579.492776]  [<c02a1a3f>] ? sys_select+0x2f/0xb0
[1557579.492779]  [<c0202f61>] ? syscall_call+0x7/0xb
[1557579.492780] Mem-Info:
[1557579.492782] DMA per-cpu:
[1557579.492783] CPU    0: hi:    0, btch:   1 usd:   0
[1557579.492785] CPU    1: hi:    0, btch:   1 usd:   0
[1557579.492786] CPU    2: hi:    0, btch:   1 usd:   0
[1557579.492788] CPU    3: hi:    0, btch:   1 usd:   0
[1557579.492789] Normal per-cpu:
[1557579.492791] CPU    0: hi:  186, btch:  31 usd: 159
[1557579.492792] CPU    1: hi:  186, btch:  31 usd: 163
[1557579.492794] CPU    2: hi:  186, btch:  31 usd: 144
[1557579.492795] CPU    3: hi:  186, btch:  31 usd: 170
[1557579.492797] HighMem per-cpu:
[1557579.492798] CPU    0: hi:  186, btch:  31 usd:   7
[1557579.492799] CPU    1: hi:  186, btch:  31 usd:  26
[1557579.492801] CPU    2: hi:  186, btch:  31 usd:  10
[1557579.492802] CPU    3: hi:  186, btch:  31 usd:  16
[1557579.492805] Active_anon:98495 active_file:75143 inactive_anon:13424
[1557579.492806]  inactive_file:1119403 unevictable:867 dirty:0 writeback:0 unstable:0
[1557579.492807]  free:672570 slab:89318 mapped:21602 pagetables:1431 bounce:0
[1557579.492810] DMA free:1984kB min:88kB low:108kB high:132kB active_anon:0kB inactive_anon:0kB active_file:148kB inactive_file:0kB unevictable:0kB present:15864kB pages_scanned:256 all_unreclaimable? yes
[1557579.492812] lowmem_reserve[]: 0 478 8104 8104
[1557579.492817] Normal free:2632kB min:2752kB low:3440kB high:4128kB active_anon:0kB inactive_anon:0kB active_file:23108kB inactive_file:22984kB unevictable:0kB present:489704kB pages_scanned:72570 all_unreclaimable? yes
[1557579.492819] lowmem_reserve[]: 0 0 61012 61012
[1557579.492824] HighMem free:2685664kB min:512kB low:11492kB high:22476kB active_anon:393980kB inactive_anon:53696kB active_file:277316kB inactive_file:4454628kB unevictable:3468kB present:7809620kB pages_scanned:0 all_unreclaimable? no
[1557579.492826] lowmem_reserve[]: 0 0 0 0
[1557579.492829] DMA: 14*4kB 15*8kB 14*16kB 11*32kB 6*64kB 5*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2032kB
[1557579.492836] Normal: 114*4kB 0*8kB 8*16kB 27*32kB 8*64kB 3*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2600kB
[1557579.492843] HighMem: 2*4kB 2*8kB 1*16kB 0*32kB 7*64kB 6*128kB 513*256kB 3334*512kB 636*1024kB 91*2048kB 2*4096kB = 2685416kB
[1557579.492851] 1195639 total pagecache pages
[1557579.492852] 0 pages in swap cache
[1557579.492854] Swap cache stats: add 0, delete 0, find 0/0
[1557579.492855] Free swap  = 0kB
[1557579.492856] Total swap = 0kB
[1557579.513470] 2162688 pages RAM
[1557579.513472] 2035202 pages HighMem
[1557579.513473] 86689 pages reserved
[1557579.513474] 1221324 pages shared
[1557579.513475] 240199 pages non-shared
[1557579.513478] Out of memory: kill process 6857 (fvwm2) score 3609 or a child
[1557579.513510] Killed process 6870 (xterm)
[1557579.514861] Xorg invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
[1557579.514870] Pid: 6696, comm: Xorg Not tainted 2.6.31.3 #1
[1557579.514872] Call Trace:
[1557579.514883]  [<c02679ec>] ? oom_kill_process+0xac/0x250
[1557579.514886]  [<c0267e57>] ? badness+0x167/0x240
[1557579.514888]  [<c0268074>] ? __out_of_memory+0x144/0x170
[1557579.514894]  [<c02680f4>] ? out_of_memory+0x54/0xb0
[1557579.514897]  [<c026b211>] ? __alloc_pages_nodemask+0x541/0x560
[1557579.514900]  [<c026b284>] ? __get_free_pages+0x14/0x30
[1557579.514902]  [<c02a1b62>] ? __pollwait+0xa2/0xf0
[1557579.514911]  [<c0479ab4>] ? unix_poll+0x14/0xa0
[1557579.514914]  [<c040a00c>] ? sock_poll+0xc/0x10
[1557579.514916]  [<c02a12ab>] ? do_select+0x2bb/0x550
[1557579.514921]  [<c02a1ac0>] ? __pollwait+0x0/0xf0
[1557579.514923]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.514926]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.514928]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.514930]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.514935]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.514938]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.514940]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.514942]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.514946]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.514948]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.514950]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.514952]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.514955]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.514957]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.514959]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.514961]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.514963]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.514965]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.514967]  [<c02a1730>] ? core_sys_select+0x1f0/0x320
[1557579.514970]  [<c029f9f3>] ? do_vfs_ioctl+0x3e3/0x610
[1557579.514973]  [<c024354c>] ? hrtimer_try_to_cancel+0x3c/0x80
[1557579.514976]  [<c02481a4>] ? getnstimeofday+0x54/0x110
[1557579.514978]  [<c02a1a3f>] ? sys_select+0x2f/0xb0
[1557579.514981]  [<c0202f61>] ? syscall_call+0x7/0xb
[1557579.514983] Mem-Info:
[1557579.514984] DMA per-cpu:
[1557579.514985] CPU    0: hi:    0, btch:   1 usd:   0
[1557579.514987] CPU    1: hi:    0, btch:   1 usd:   0
[1557579.514988] CPU    2: hi:    0, btch:   1 usd:   0
[1557579.514990] CPU    3: hi:    0, btch:   1 usd:   0
[1557579.514991] Normal per-cpu:
[1557579.514992] CPU    0: hi:  186, btch:  31 usd: 159
[1557579.514994] CPU    1: hi:  186, btch:  31 usd: 163
[1557579.514995] CPU    2: hi:  186, btch:  31 usd: 157
[1557579.514997] CPU    3: hi:  186, btch:  31 usd: 170
[1557579.514998] HighMem per-cpu:
[1557579.514999] CPU    0: hi:  186, btch:  31 usd:   7
[1557579.515001] CPU    1: hi:  186, btch:  31 usd:  12
[1557579.515002] CPU    2: hi:  186, btch:  31 usd: 157
[1557579.515004] CPU    3: hi:  186, btch:  31 usd:  14
[1557579.515006] Active_anon:97471 active_file:75143 inactive_anon:13232
[1557579.515007]  inactive_file:1119403 unevictable:867 dirty:0 writeback:0 unstable:0
[1557579.515008]  free:673562 slab:89318 mapped:21602 pagetables:1431 bounce:0
[1557579.515011] DMA free:1984kB min:88kB low:108kB high:132kB active_anon:0kB inactive_anon:0kB active_file:148kB inactive_file:0kB unevictable:0kB present:15864kB pages_scanned:256 all_unreclaimable? yes
[1557579.515014] lowmem_reserve[]: 0 478 8104 8104
[1557579.515018] Normal free:2632kB min:2752kB low:3440kB high:4128kB active_anon:0kB inactive_anon:0kB active_file:23108kB inactive_file:22984kB unevictable:0kB present:489704kB pages_scanned:72570 all_unreclaimable? yes
[1557579.515020] lowmem_reserve[]: 0 0 61012 61012
[1557579.515025] HighMem free:2689632kB min:512kB low:11492kB high:22476kB active_anon:389884kB inactive_anon:52928kB active_file:277316kB inactive_file:4454628kB unevictable:3468kB present:7809620kB pages_scanned:0 all_unreclaimable? no
[1557579.515027] lowmem_reserve[]: 0 0 0 0
[1557579.515030] DMA: 14*4kB 15*8kB 14*16kB 11*32kB 6*64kB 5*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2032kB
[1557579.515037] Normal: 114*4kB 0*8kB 8*16kB 27*32kB 8*64kB 3*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2600kB
[1557579.515044] HighMem: 270*4kB 75*8kB 27*16kB 63*32kB 9*64kB 6*128kB 513*256kB 3334*512kB 636*1024kB 91*2048kB 2*4096kB = 2689632kB
[1557579.515052] 1195639 total pagecache pages
[1557579.515053] 0 pages in swap cache
[1557579.515054] Swap cache stats: add 0, delete 0, find 0/0
[1557579.515055] Free swap  = 0kB
[1557579.515056] Total swap = 0kB
[1557579.535676] 2162688 pages RAM
[1557579.535679] 2035202 pages HighMem
[1557579.535680] 86689 pages reserved
[1557579.535681] 1220772 pages shared
[1557579.535682] 238999 pages non-shared
[1557579.535685] Out of memory: kill process 6857 (fvwm2) score 3596 or a child
[1557579.535717] Killed process 6875 (xterm)
[1557579.867308] Xorg invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
[1557579.867312] Pid: 6696, comm: Xorg Not tainted 2.6.31.3 #1
[1557579.867314] Call Trace:
[1557579.867321]  [<c02679ec>] ? oom_kill_process+0xac/0x250
[1557579.867323]  [<c0267e57>] ? badness+0x167/0x240
[1557579.867326]  [<c0268074>] ? __out_of_memory+0x144/0x170
[1557579.867328]  [<c02680f4>] ? out_of_memory+0x54/0xb0
[1557579.867331]  [<c026b211>] ? __alloc_pages_nodemask+0x541/0x560
[1557579.867334]  [<c026b284>] ? __get_free_pages+0x14/0x30
[1557579.867337]  [<c02a1b62>] ? __pollwait+0xa2/0xf0
[1557579.867340]  [<c0479ab4>] ? unix_poll+0x14/0xa0
[1557579.867344]  [<c040a00c>] ? sock_poll+0xc/0x10
[1557579.867346]  [<c02a12ab>] ? do_select+0x2bb/0x550
[1557579.867349]  [<c02a1ac0>] ? __pollwait+0x0/0xf0
[1557579.867351]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.867353]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.867355]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.867357]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.867360]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.867362]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.867364]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.867366]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.867368]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.867370]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.867372]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.867374]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.867376]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.867378]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.867380]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.867382]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.867384]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.867386]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.867388]  [<c02a1730>] ? core_sys_select+0x1f0/0x320
[1557579.867391]  [<c029f9f3>] ? do_vfs_ioctl+0x3e3/0x610
[1557579.867394]  [<c024354c>] ? hrtimer_try_to_cancel+0x3c/0x80
[1557579.867397]  [<c02481a4>] ? getnstimeofday+0x54/0x110
[1557579.867399]  [<c02a1a3f>] ? sys_select+0x2f/0xb0
[1557579.867401]  [<c0202f61>] ? syscall_call+0x7/0xb
[1557579.867403] Mem-Info:
[1557579.867404] DMA per-cpu:
[1557579.867406] CPU    0: hi:    0, btch:   1 usd:   0
[1557579.867408] CPU    1: hi:    0, btch:   1 usd:   0
[1557579.867409] CPU    2: hi:    0, btch:   1 usd:   0
[1557579.867411] CPU    3: hi:    0, btch:   1 usd:   0
[1557579.867412] Normal per-cpu:
[1557579.867414] CPU    0: hi:  186, btch:  31 usd: 159
[1557579.867415] CPU    1: hi:  186, btch:  31 usd: 163
[1557579.867417] CPU    2: hi:  186, btch:  31 usd: 169
[1557579.867418] CPU    3: hi:  186, btch:  31 usd: 170
[1557579.867419] HighMem per-cpu:
[1557579.867420] CPU    0: hi:  186, btch:  31 usd:   7
[1557579.867422] CPU    1: hi:  186, btch:  31 usd:  10
[1557579.867423] CPU    2: hi:  186, btch:  31 usd: 185
[1557579.867425] CPU    3: hi:  186, btch:  31 usd:  13
[1557579.867428] Active_anon:97471 active_file:75144 inactive_anon:13040
[1557579.867429]  inactive_file:1119462 unevictable:867 dirty:0 writeback:0 unstable:0
[1557579.867429]  free:673748 slab:89318 mapped:21602 pagetables:1431 bounce:0
[1557579.867436] DMA free:1984kB min:88kB low:108kB high:132kB active_anon:0kB inactive_anon:0kB active_file:148kB inactive_file:0kB unevictable:0kB present:15864kB pages_scanned:256 all_unreclaimable? yes
[1557579.867438] lowmem_reserve[]: 0 478 8104 8104
[1557579.867443] Normal free:2632kB min:2752kB low:3440kB high:4128kB active_anon:0kB inactive_anon:0kB active_file:23112kB inactive_file:22964kB unevictable:0kB present:489704kB pages_scanned:92454 all_unreclaimable? no
[1557579.867445] lowmem_reserve[]: 0 0 61012 61012
[1557579.867450] HighMem free:2690376kB min:512kB low:11492kB high:22476kB active_anon:389884kB inactive_anon:52160kB active_file:277316kB inactive_file:4454884kB unevictable:3468kB present:7809620kB pages_scanned:0 all_unreclaimable? no
[1557579.867452] lowmem_reserve[]: 0 0 0 0
[1557579.867455] DMA: 14*4kB 15*8kB 14*16kB 11*32kB 6*64kB 5*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2032kB
[1557579.867462] Normal: 114*4kB 2*8kB 8*16kB 27*32kB 8*64kB 3*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2616kB
[1557579.867470] HighMem: 290*4kB 84*8kB 34*16kB 68*32kB 14*64kB 6*128kB 513*256kB 3334*512kB 636*1024kB 91*2048kB 2*4096kB = 2690376kB
[1557579.867477] 1195639 total pagecache pages
[1557579.867478] 0 pages in swap cache
[1557579.867480] Swap cache stats: add 0, delete 0, find 0/0
[1557579.867481] Free swap  = 0kB
[1557579.867482] Total swap = 0kB
[1557579.888047] 2162688 pages RAM
[1557579.888049] 2035202 pages HighMem
[1557579.888050] 86689 pages reserved
[1557579.888051] 1220223 pages shared
[1557579.888052] 238774 pages non-shared
[1557579.888055] Out of memory: kill process 6857 (fvwm2) score 3583 or a child
[1557579.888087] Killed process 6877 (xterm)
[1557579.890837] Xorg invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
[1557579.890840] Pid: 6696, comm: Xorg Not tainted 2.6.31.3 #1
[1557579.890842] Call Trace:
[1557579.890848]  [<c02679ec>] ? oom_kill_process+0xac/0x250
[1557579.890851]  [<c0267e57>] ? badness+0x167/0x240
[1557579.890853]  [<c0268074>] ? __out_of_memory+0x144/0x170
[1557579.890856]  [<c02680f4>] ? out_of_memory+0x54/0xb0
[1557579.890858]  [<c026b211>] ? __alloc_pages_nodemask+0x541/0x560
[1557579.890861]  [<c026b284>] ? __get_free_pages+0x14/0x30
[1557579.890864]  [<c02a1b62>] ? __pollwait+0xa2/0xf0
[1557579.890867]  [<c0479ab4>] ? unix_poll+0x14/0xa0
[1557579.890870]  [<c040a00c>] ? sock_poll+0xc/0x10
[1557579.890873]  [<c02a12ab>] ? do_select+0x2bb/0x550
[1557579.890875]  [<c02a1ac0>] ? __pollwait+0x0/0xf0
[1557579.890877]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.890880]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.890882]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.890884]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.890886]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.890888]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.890890]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.890892]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.890894]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.890896]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.890898]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.890900]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.890902]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.890904]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.890906]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.890908]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.890910]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.890912]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.890914]  [<c02a1730>] ? core_sys_select+0x1f0/0x320
[1557579.890917]  [<c029f9f3>] ? do_vfs_ioctl+0x3e3/0x610
[1557579.890920]  [<c024354c>] ? hrtimer_try_to_cancel+0x3c/0x80
[1557579.890923]  [<c02481a4>] ? getnstimeofday+0x54/0x110
[1557579.890925]  [<c02a1a3f>] ? sys_select+0x2f/0xb0
[1557579.890928]  [<c0202f61>] ? syscall_call+0x7/0xb
[1557579.890929] Mem-Info:
[1557579.890930] DMA per-cpu:
[1557579.890932] CPU    0: hi:    0, btch:   1 usd:   0
[1557579.890933] CPU    1: hi:    0, btch:   1 usd:   0
[1557579.890935] CPU    2: hi:    0, btch:   1 usd:   0
[1557579.890936] CPU    3: hi:    0, btch:   1 usd:   0
[1557579.890938] Normal per-cpu:
[1557579.890939] CPU    0: hi:  186, btch:  31 usd: 159
[1557579.890941] CPU    1: hi:  186, btch:  31 usd: 163
[1557579.890942] CPU    2: hi:  186, btch:  31 usd: 169
[1557579.890943] CPU    3: hi:  186, btch:  31 usd: 181
[1557579.890945] HighMem per-cpu:
[1557579.890946] CPU    0: hi:  186, btch:  31 usd:   7
[1557579.890947] CPU    1: hi:  186, btch:  31 usd:  10
[1557579.890949] CPU    2: hi:  186, btch:  31 usd: 184
[1557579.890950] CPU    3: hi:  186, btch:  31 usd: 185
[1557579.890953] Active_anon:97471 active_file:75270 inactive_anon:12848
[1557579.890954]  inactive_file:1119328 unevictable:867 dirty:0 writeback:0 unstable:0
[1557579.890955]  free:673748 slab:89318 mapped:21602 pagetables:1431 bounce:0
[1557579.890958] DMA free:1984kB min:88kB low:108kB high:132kB active_anon:0kB inactive_anon:0kB active_file:148kB inactive_file:0kB unevictable:0kB present:15864kB pages_scanned:256 all_unreclaimable? yes
[1557579.890960] lowmem_reserve[]: 0 478 8104 8104
[1557579.890964] Normal free:2632kB min:2752kB low:3440kB high:4128kB active_anon:0kB inactive_anon:0kB active_file:23616kB inactive_file:22428kB unevictable:0kB present:489704kB pages_scanned:92878 all_unreclaimable? yes
[1557579.890967] lowmem_reserve[]: 0 0 61012 61012
[1557579.890972] HighMem free:2690376kB min:512kB low:11492kB high:22476kB active_anon:389884kB inactive_anon:51392kB active_file:277316kB inactive_file:4454884kB unevictable:3468kB present:7809620kB pages_scanned:0 all_unreclaimable? no
[1557579.890974] lowmem_reserve[]: 0 0 0 0
[1557579.890977] DMA: 14*4kB 15*8kB 14*16kB 11*32kB 6*64kB 5*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2032kB
[1557579.890984] Normal: 114*4kB 2*8kB 8*16kB 27*32kB 8*64kB 3*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2616kB
[1557579.890991] HighMem: 299*4kB 91*8kB 36*16kB 68*32kB 14*64kB 6*128kB 513*256kB 3334*512kB 636*1024kB 91*2048kB 2*4096kB = 2690500kB
[1557579.890999] 1195639 total pagecache pages
[1557579.891000] 0 pages in swap cache
[1557579.891001] Swap cache stats: add 0, delete 0, find 0/0
[1557579.891003] Free swap  = 0kB
[1557579.891004] Total swap = 0kB
[1557579.911591] 2162688 pages RAM
[1557579.911592] 2035202 pages HighMem
[1557579.911594] 86689 pages reserved
[1557579.911595] 1219686 pages shared
[1557579.911596] 238560 pages non-shared
[1557579.911598] Out of memory: kill process 6857 (fvwm2) score 3569 or a child
[1557579.911631] Killed process 6880 (xterm)
[1557579.918832] Xorg invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
[1557579.918835] Pid: 6696, comm: Xorg Not tainted 2.6.31.3 #1
[1557579.918836] Call Trace:
[1557579.918842]  [<c02679ec>] ? oom_kill_process+0xac/0x250
[1557579.918845]  [<c0267e57>] ? badness+0x167/0x240
[1557579.918847]  [<c0268074>] ? __out_of_memory+0x144/0x170
[1557579.918849]  [<c02680f4>] ? out_of_memory+0x54/0xb0
[1557579.918852]  [<c026b211>] ? __alloc_pages_nodemask+0x541/0x560
[1557579.918855]  [<c026b284>] ? __get_free_pages+0x14/0x30
[1557579.918858]  [<c02a1b62>] ? __pollwait+0xa2/0xf0
[1557579.918861]  [<c0479ab4>] ? unix_poll+0x14/0xa0
[1557579.918864]  [<c040a00c>] ? sock_poll+0xc/0x10
[1557579.918866]  [<c02a12ab>] ? do_select+0x2bb/0x550
[1557579.918869]  [<c02a1ac0>] ? __pollwait+0x0/0xf0
[1557579.918871]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.918873]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.918875]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.918877]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.918879]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.918881]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.918883]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.918885]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.918887]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.918889]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.918891]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.918893]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.918895]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.918897]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.918899]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.918901]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.918903]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.918905]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557579.918907]  [<c02a1730>] ? core_sys_select+0x1f0/0x320
[1557579.918910]  [<c029f9f3>] ? do_vfs_ioctl+0x3e3/0x610
[1557579.918913]  [<c024354c>] ? hrtimer_try_to_cancel+0x3c/0x80
[1557579.918915]  [<c02481a4>] ? getnstimeofday+0x54/0x110
[1557579.918918]  [<c02a1a3f>] ? sys_select+0x2f/0xb0
[1557579.918920]  [<c0202f61>] ? syscall_call+0x7/0xb
[1557579.918922] Mem-Info:
[1557579.918923] DMA per-cpu:
[1557579.918924] CPU    0: hi:    0, btch:   1 usd:   0
[1557579.918926] CPU    1: hi:    0, btch:   1 usd:   0
[1557579.918927] CPU    2: hi:    0, btch:   1 usd:   0
[1557579.918929] CPU    3: hi:    0, btch:   1 usd:   0
[1557579.918930] Normal per-cpu:
[1557579.918931] CPU    0: hi:  186, btch:  31 usd: 171
[1557579.918933] CPU    1: hi:  186, btch:  31 usd: 163
[1557579.918934] CPU    2: hi:  186, btch:  31 usd: 169
[1557579.918936] CPU    3: hi:  186, btch:  31 usd: 183
[1557579.918937] HighMem per-cpu:
[1557579.918938] CPU    0: hi:  186, btch:  31 usd: 167
[1557579.918940] CPU    1: hi:  186, btch:  31 usd:  10
[1557579.918941] CPU    2: hi:  186, btch:  31 usd: 183
[1557579.918943] CPU    3: hi:  186, btch:  31 usd: 185
[1557579.918945] Active_anon:97407 active_file:75270 inactive_anon:12656
[1557579.918946]  inactive_file:1119328 unevictable:867 dirty:0 writeback:0 unstable:0
[1557579.918947]  free:673810 slab:89318 mapped:21602 pagetables:1431 bounce:0
[1557579.918950] DMA free:1984kB min:88kB low:108kB high:132kB active_anon:0kB inactive_anon:0kB active_file:148kB inactive_file:0kB unevictable:0kB present:15864kB pages_scanned:256 all_unreclaimable? yes
[1557579.918953] lowmem_reserve[]: 0 478 8104 8104
[1557579.918957] Normal free:2632kB min:2752kB low:3440kB high:4128kB active_anon:0kB inactive_anon:0kB active_file:23616kB inactive_file:22428kB unevictable:0kB present:489704kB pages_scanned:92878 all_unreclaimable? yes
[1557579.918959] lowmem_reserve[]: 0 0 61012 61012
[1557579.918964] HighMem free:2690624kB min:512kB low:11492kB high:22476kB active_anon:389628kB inactive_anon:50624kB active_file:277316kB inactive_file:4454884kB unevictable:3468kB present:7809620kB pages_scanned:0 all_unreclaimable? no
[1557579.918966] lowmem_reserve[]: 0 0 0 0
[1557579.918969] DMA: 14*4kB 15*8kB 14*16kB 11*32kB 6*64kB 5*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2032kB
[1557579.918976] Normal: 114*4kB 2*8kB 8*16kB 27*32kB 8*64kB 3*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2616kB
[1557579.918983] HighMem: 340*4kB 103*8kB 41*16kB 69*32kB 14*64kB 6*128kB 513*256kB 3334*512kB 636*1024kB 91*2048kB 2*4096kB = 2690872kB
[1557579.918990] 1195639 total pagecache pages
[1557579.918992] 0 pages in swap cache
[1557579.918993] Swap cache stats: add 0, delete 0, find 0/0
[1557579.918994] Free swap  = 0kB
[1557579.918995] Total swap = 0kB
[1557579.939490] 2162688 pages RAM
[1557579.939492] 2035202 pages HighMem
[1557579.939493] 86689 pages reserved
[1557579.939494] 1219144 pages shared
[1557579.939495] 238293 pages non-shared
[1557579.939498] Out of memory: kill process 6857 (fvwm2) score 3556 or a child
[1557579.939530] Killed process 6882 (xterm)
[1557581.514296] Xorg invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
[1557581.514301] Pid: 6696, comm: Xorg Not tainted 2.6.31.3 #1
[1557581.514302] Call Trace:
[1557581.514310]  [<c02679ec>] ? oom_kill_process+0xac/0x250
[1557581.514313]  [<c0267e57>] ? badness+0x167/0x240
[1557581.514315]  [<c0268074>] ? __out_of_memory+0x144/0x170
[1557581.514318]  [<c02680f4>] ? out_of_memory+0x54/0xb0
[1557581.514320]  [<c026b211>] ? __alloc_pages_nodemask+0x541/0x560
[1557581.514323]  [<c026b284>] ? __get_free_pages+0x14/0x30
[1557581.514327]  [<c02a1b62>] ? __pollwait+0xa2/0xf0
[1557581.514330]  [<c0479ab4>] ? unix_poll+0x14/0xa0
[1557581.514333]  [<c040a00c>] ? sock_poll+0xc/0x10
[1557581.514335]  [<c02a12ab>] ? do_select+0x2bb/0x550
[1557581.514338]  [<c02a1ac0>] ? __pollwait+0x0/0xf0
[1557581.514340]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.514342]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.514344]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.514346]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.514348]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.514351]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.514353]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.514355]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.514357]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.514359]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.514361]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.514363]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.514365]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.514367]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.514369]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.514371]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.514373]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.514375]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.514377]  [<c02a1730>] ? core_sys_select+0x1f0/0x320
[1557581.514380]  [<c029f9f3>] ? do_vfs_ioctl+0x3e3/0x610
[1557581.514384]  [<c024354c>] ? hrtimer_try_to_cancel+0x3c/0x80
[1557581.514386]  [<c02481a4>] ? getnstimeofday+0x54/0x110
[1557581.514389]  [<c02a1a3f>] ? sys_select+0x2f/0xb0
[1557581.514391]  [<c0202f61>] ? syscall_call+0x7/0xb
[1557581.514393] Mem-Info:
[1557581.514395] DMA per-cpu:
[1557581.514396] CPU    0: hi:    0, btch:   1 usd:   0
[1557581.514398] CPU    1: hi:    0, btch:   1 usd:   0
[1557581.514399] CPU    2: hi:    0, btch:   1 usd:   0
[1557581.514401] CPU    3: hi:    0, btch:   1 usd:   0
[1557581.514402] Normal per-cpu:
[1557581.514404] CPU    0: hi:  186, btch:  31 usd:  29
[1557581.514405] CPU    1: hi:  186, btch:  31 usd:  36
[1557581.514407] CPU    2: hi:  186, btch:  31 usd:  90
[1557581.514408] CPU    3: hi:  186, btch:  31 usd: 101
[1557581.514409] HighMem per-cpu:
[1557581.514411] CPU    0: hi:  186, btch:  31 usd:  24
[1557581.514412] CPU    1: hi:  186, btch:  31 usd:  20
[1557581.514414] CPU    2: hi:  186, btch:  31 usd:  15
[1557581.514415] CPU    3: hi:  186, btch:  31 usd:   6
[1557581.514418] Active_anon:96045 active_file:75178 inactive_anon:12196
[1557581.514419]  inactive_file:1126261 unevictable:867 dirty:181 writeback:447 unstable:0
[1557581.514420]  free:669255 slab:89841 mapped:21540 pagetables:1369 bounce:0
[1557581.514423] DMA free:1984kB min:88kB low:108kB high:132kB active_anon:0kB inactive_anon:0kB active_file:148kB inactive_file:0kB unevictable:0kB present:15864kB pages_scanned:256 all_unreclaimable? yes
[1557581.514425] lowmem_reserve[]: 0 478 8104 8104
[1557581.514430] Normal free:2632kB min:2752kB low:3440kB high:4128kB active_anon:0kB inactive_anon:0kB active_file:23348kB inactive_file:22592kB unevictable:0kB present:489704kB pages_scanned:50678 all_unreclaimable? no
[1557581.514433] lowmem_reserve[]: 0 0 61012 61012
[1557581.514437] HighMem free:2672404kB min:512kB low:11492kB high:22476kB active_anon:384180kB inactive_anon:48784kB active_file:277328kB inactive_file:4482452kB unevictable:3468kB present:7809620kB pages_scanned:0 all_unreclaimable? no
[1557581.514440] lowmem_reserve[]: 0 0 0 0
[1557581.514443] DMA: 14*4kB 15*8kB 14*16kB 11*32kB 6*64kB 5*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2032kB
[1557581.514450] Normal: 80*4kB 14*8kB 14*16kB 27*32kB 8*64kB 3*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2672kB
[1557581.514457] HighMem: 1*4kB 1*8kB 1*16kB 0*32kB 6*64kB 5*128kB 462*256kB 3334*512kB 636*1024kB 91*2048kB 2*4096kB = 2672156kB
[1557581.514465] 1202593 total pagecache pages
[1557581.514466] 0 pages in swap cache
[1557581.514468] Swap cache stats: add 0, delete 0, find 0/0
[1557581.514469] Free swap  = 0kB
[1557581.514470] Total swap = 0kB
[1557581.536342] 2162688 pages RAM
[1557581.536344] 2035202 pages HighMem
[1557581.536345] 86689 pages reserved
[1557581.536347] 1223910 pages shared
[1557581.536348] 236955 pages non-shared
[1557581.536350] Out of memory: kill process 6857 (fvwm2) score 3543 or a child
[1557581.536381] Killed process 6884 (xterm)
[1557581.538829] Xorg invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
[1557581.538832] Pid: 6696, comm: Xorg Not tainted 2.6.31.3 #1
[1557581.538833] Call Trace:
[1557581.538840]  [<c02679ec>] ? oom_kill_process+0xac/0x250
[1557581.538842]  [<c0267e57>] ? badness+0x167/0x240
[1557581.538845]  [<c0268074>] ? __out_of_memory+0x144/0x170
[1557581.538847]  [<c02680f4>] ? out_of_memory+0x54/0xb0
[1557581.538849]  [<c026b211>] ? __alloc_pages_nodemask+0x541/0x560
[1557581.538852]  [<c026b284>] ? __get_free_pages+0x14/0x30
[1557581.538855]  [<c02a1b62>] ? __pollwait+0xa2/0xf0
[1557581.538859]  [<c0479ab4>] ? unix_poll+0x14/0xa0
[1557581.538862]  [<c040a00c>] ? sock_poll+0xc/0x10
[1557581.538865]  [<c02a12ab>] ? do_select+0x2bb/0x550
[1557581.538867]  [<c02a1ac0>] ? __pollwait+0x0/0xf0
[1557581.538869]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.538872]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.538879]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.538881]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.538883]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.538885]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.538887]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.538889]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.538892]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.538894]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.538896]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.538898]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.538900]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.538902]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.538904]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.538906]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.538908]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.538910]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.538912]  [<c02a1730>] ? core_sys_select+0x1f0/0x320
[1557581.538915]  [<c029f9f3>] ? do_vfs_ioctl+0x3e3/0x610
[1557581.538918]  [<c024354c>] ? hrtimer_try_to_cancel+0x3c/0x80
[1557581.538921]  [<c02481a4>] ? getnstimeofday+0x54/0x110
[1557581.538923]  [<c02a1a3f>] ? sys_select+0x2f/0xb0
[1557581.538926]  [<c0202f61>] ? syscall_call+0x7/0xb
[1557581.538927] Mem-Info:
[1557581.538928] DMA per-cpu:
[1557581.538930] CPU    0: hi:    0, btch:   1 usd:   0
[1557581.538931] CPU    1: hi:    0, btch:   1 usd:   0
[1557581.538933] CPU    2: hi:    0, btch:   1 usd:   0
[1557581.538934] CPU    3: hi:    0, btch:   1 usd:   0
[1557581.538935] Normal per-cpu:
[1557581.538937] CPU    0: hi:  186, btch:  31 usd:  43
[1557581.538938] CPU    1: hi:  186, btch:  31 usd:  37
[1557581.538940] CPU    2: hi:  186, btch:  31 usd:  92
[1557581.538941] CPU    3: hi:  186, btch:  31 usd: 118
[1557581.538942] HighMem per-cpu:
[1557581.538944] CPU    0: hi:  186, btch:  31 usd: 174
[1557581.538945] CPU    1: hi:  186, btch:  31 usd:  20
[1557581.538946] CPU    2: hi:  186, btch:  31 usd:  15
[1557581.538948] CPU    3: hi:  186, btch:  31 usd: 173
[1557581.538951] Active_anon:94829 active_file:75128 inactive_anon:11940
[1557581.538952]  inactive_file:1126371 unevictable:867 dirty:181 writeback:63 unstable:0
[1557581.538952]  free:670433 slab:89841 mapped:21540 pagetables:1369 bounce:0
[1557581.538956] DMA free:1984kB min:88kB low:108kB high:132kB active_anon:0kB inactive_anon:0kB active_file:148kB inactive_file:0kB unevictable:0kB present:15864kB pages_scanned:256 all_unreclaimable? yes
[1557581.538958] lowmem_reserve[]: 0 478 8104 8104
[1557581.538962] Normal free:2632kB min:2752kB low:3440kB high:4128kB active_anon:0kB inactive_anon:0kB active_file:23036kB inactive_file:23032kB unevictable:0kB present:489704kB pages_scanned:80169 all_unreclaimable? yes
[1557581.538965] lowmem_reserve[]: 0 0 61012 61012
[1557581.538969] HighMem free:2677116kB min:512kB low:11492kB high:22476kB active_anon:379316kB inactive_anon:47760kB active_file:277328kB inactive_file:4482452kB unevictable:3468kB present:7809620kB pages_scanned:0 all_unreclaimable? no
[1557581.538972] lowmem_reserve[]: 0 0 0 0
[1557581.538974] DMA: 14*4kB 15*8kB 14*16kB 11*32kB 6*64kB 5*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2032kB
[1557581.538982] Normal: 80*4kB 14*8kB 14*16kB 27*32kB 8*64kB 3*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2672kB
[1557581.538989] HighMem: 62*4kB 41*8kB 12*16kB 4*32kB 68*64kB 5*128kB 462*256kB 3334*512kB 636*1024kB 91*2048kB 2*4096kB = 2676992kB
[1557581.538996] 1202593 total pagecache pages
[1557581.538997] 0 pages in swap cache
[1557581.538999] Swap cache stats: add 0, delete 0, find 0/0
[1557581.539000] Free swap  = 0kB
[1557581.539001] Total swap = 0kB
[1557581.558685] 2162688 pages RAM
[1557581.558685] 2035202 pages HighMem
[1557581.558685] 86689 pages reserved
[1557581.558685] 1222510 pages shared
[1557581.558685] 235395 pages non-shared
[1557581.558685] Out of memory: kill process 6857 (fvwm2) score 3530 or a child
[1557581.558685] Killed process 6886 (xterm)
[1557581.559642] Xorg invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
[1557581.559645] Pid: 6696, comm: Xorg Not tainted 2.6.31.3 #1
[1557581.559647] Call Trace:
[1557581.559653]  [<c02679ec>] ? oom_kill_process+0xac/0x250
[1557581.559655]  [<c0267e57>] ? badness+0x167/0x240
[1557581.559658]  [<c0268074>] ? __out_of_memory+0x144/0x170
[1557581.559660]  [<c02680f4>] ? out_of_memory+0x54/0xb0
[1557581.559663]  [<c026b211>] ? __alloc_pages_nodemask+0x541/0x560
[1557581.559666]  [<c026b284>] ? __get_free_pages+0x14/0x30
[1557581.559668]  [<c02a1b62>] ? __pollwait+0xa2/0xf0
[1557581.559672]  [<c0479ab4>] ? unix_poll+0x14/0xa0
[1557581.559675]  [<c040a00c>] ? sock_poll+0xc/0x10
[1557581.559677]  [<c02a12ab>] ? do_select+0x2bb/0x550
[1557581.559680]  [<c02a1ac0>] ? __pollwait+0x0/0xf0
[1557581.559682]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.559684]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.559686]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.559688]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.559690]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.559692]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.559694]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.559696]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.559698]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.559700]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.559702]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.559704]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.559706]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.559708]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.559710]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.559712]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.559714]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.559716]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.559719]  [<c02a1730>] ? core_sys_select+0x1f0/0x320
[1557581.559722]  [<c029f9f3>] ? do_vfs_ioctl+0x3e3/0x610
[1557581.559724]  [<c024354c>] ? hrtimer_try_to_cancel+0x3c/0x80
[1557581.559727]  [<c02481a4>] ? getnstimeofday+0x54/0x110
[1557581.559729]  [<c02a1a3f>] ? sys_select+0x2f/0xb0
[1557581.559732]  [<c0202f61>] ? syscall_call+0x7/0xb
[1557581.559734] Mem-Info:
[1557581.559735] DMA per-cpu:
[1557581.559737] CPU    0: hi:    0, btch:   1 usd:   0
[1557581.559738] CPU    1: hi:    0, btch:   1 usd:   0
[1557581.559739] CPU    2: hi:    0, btch:   1 usd:   0
[1557581.559741] CPU    3: hi:    0, btch:   1 usd:   0
[1557581.559742] Normal per-cpu:
[1557581.559743] CPU    0: hi:  186, btch:  31 usd:  43
[1557581.559745] CPU    1: hi:  186, btch:  31 usd:  37
[1557581.559746] CPU    2: hi:  186, btch:  31 usd: 104
[1557581.559748] CPU    3: hi:  186, btch:  31 usd: 121
[1557581.559749] HighMem per-cpu:
[1557581.559750] CPU    0: hi:  186, btch:  31 usd: 174
[1557581.559752] CPU    1: hi:  186, btch:  31 usd:  20
[1557581.559753] CPU    2: hi:  186, btch:  31 usd: 184
[1557581.559754] CPU    3: hi:  186, btch:  31 usd: 173
[1557581.559757] Active_anon:94829 active_file:75128 inactive_anon:11748
[1557581.559758]  inactive_file:1126371 unevictable:867 dirty:181 writeback:63 unstable:0
[1557581.559759]  free:670433 slab:89841 mapped:21540 pagetables:1369 bounce:0
[1557581.559762] DMA free:1984kB min:88kB low:108kB high:132kB active_anon:0kB inactive_anon:0kB active_file:148kB inactive_file:0kB unevictable:0kB present:15864kB pages_scanned:256 all_unreclaimable? yes
[1557581.559764] lowmem_reserve[]: 0 478 8104 8104
[1557581.559769] Normal free:2632kB min:2752kB low:3440kB high:4128kB active_anon:0kB inactive_anon:0kB active_file:23036kB inactive_file:23032kB unevictable:0kB present:489704kB pages_scanned:80169 all_unreclaimable? yes
[1557581.559771] lowmem_reserve[]: 0 0 61012 61012
[1557581.559776] HighMem free:2677116kB min:512kB low:11492kB high:22476kB active_anon:379316kB inactive_anon:46992kB active_file:277328kB inactive_file:4482452kB unevictable:3468kB present:7809620kB pages_scanned:0 all_unreclaimable? no
[1557581.559778] lowmem_reserve[]: 0 0 0 0
[1557581.559781] DMA: 14*4kB 15*8kB 14*16kB 11*32kB 6*64kB 5*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2032kB
[1557581.559788] Normal: 80*4kB 14*8kB 14*16kB 27*32kB 8*64kB 3*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2672kB
[1557581.559795] HighMem: 73*4kB 45*8kB 13*16kB 5*32kB 68*64kB 5*128kB 462*256kB 3334*512kB 636*1024kB 91*2048kB 2*4096kB = 2677116kB
[1557581.559803] 1202593 total pagecache pages
[1557581.559804] 0 pages in swap cache
[1557581.559806] Swap cache stats: add 0, delete 0, find 0/0
[1557581.559807] Free swap  = 0kB
[1557581.559808] Total swap = 0kB
[1557581.580222] 2162688 pages RAM
[1557581.580224] 2035202 pages HighMem
[1557581.580226] 86689 pages reserved
[1557581.580227] 1221974 pages shared
[1557581.580228] 235180 pages non-shared
[1557581.580230] Out of memory: kill process 6857 (fvwm2) score 3517 or a child
[1557581.580262] Killed process 6888 (xterm)
[1557581.580714] Xorg invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
[1557581.580718] Pid: 6696, comm: Xorg Not tainted 2.6.31.3 #1
[1557581.580719] Call Trace:
[1557581.580727]  [<c02679ec>] ? oom_kill_process+0xac/0x250
[1557581.580730]  [<c0267e57>] ? badness+0x167/0x240
[1557581.580732]  [<c0268074>] ? __out_of_memory+0x144/0x170
[1557581.580735]  [<c02680f4>] ? out_of_memory+0x54/0xb0
[1557581.580737]  [<c026b211>] ? __alloc_pages_nodemask+0x541/0x560
[1557581.580740]  [<c026b284>] ? __get_free_pages+0x14/0x30
[1557581.580744]  [<c02a1b62>] ? __pollwait+0xa2/0xf0
[1557581.580747]  [<c0479ab4>] ? unix_poll+0x14/0xa0
[1557581.580750]  [<c040a00c>] ? sock_poll+0xc/0x10
[1557581.580752]  [<c02a12ab>] ? do_select+0x2bb/0x550
[1557581.580755]  [<c02a1ac0>] ? __pollwait+0x0/0xf0
[1557581.580757]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.580759]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.580761]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.580763]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.580766]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.580768]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.580770]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.580772]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.580774]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.580776]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.580778]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.580780]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.580782]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.580784]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.580786]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.580788]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.580790]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.580792]  [<c02a1bb0>] ? pollwake+0x0/0x80
[1557581.580794]  [<c02a1730>] ? core_sys_select+0x1f0/0x320
[1557581.580797]  [<c029f9f3>] ? do_vfs_ioctl+0x3e3/0x610
[1557581.580800]  [<c024354c>] ? hrtimer_try_to_cancel+0x3c/0x80
[1557581.580802]  [<c02481a4>] ? getnstimeofday+0x54/0x110
[1557581.580805]  [<c02a1a3f>] ? sys_select+0x2f/0xb0
[1557581.580808]  [<c0202f61>] ? syscall_call+0x7/0xb
[1557581.580809] Mem-Info:
[1557581.580810] DMA per-cpu:
[1557581.580812] CPU    0: hi:    0, btch:   1 usd:   0
[1557581.580813] CPU    1: hi:    0, btch:   1 usd:   0
[1557581.580815] CPU    2: hi:    0, btch:   1 usd:   0
[1557581.580816] CPU    3: hi:    0, btch:   1 usd:   0
[1557581.580818] Normal per-cpu:
[1557581.580819] CPU    0: hi:  186, btch:  31 usd:  53
[1557581.580821] CPU    1: hi:  186, btch:  31 usd:  50
[1557581.580822] CPU    2: hi:  186, btch:  31 usd: 106
[1557581.580824] CPU    3: hi:  186, btch:  31 usd: 121
[1557581.580825] HighMem per-cpu:
[1557581.580826] CPU    0: hi:  186, btch:  31 usd: 169
[1557581.580828] CPU    1: hi:  186, btch:  31 usd: 159
[1557581.580829] CPU    2: hi:  186, btch:  31 usd: 184
[1557581.580831] CPU    3: hi:  186, btch:  31 usd: 166
[1557581.580834] Active_anon:94573 active_file:75128 inactive_anon:11556
[1557581.580835]  inactive_file:1126371 unevictable:867 dirty:181 writeback:63 unstable:0
[1557581.580836]  free:670743 slab:89841 mapped:21540 pagetables:1369 bounce:0
[1557581.580839] DMA free:1984kB min:88kB low:108kB high:132kB active_anon:0kB inactive_anon:0kB active_file:148kB inactive_file:0kB unevictable:0kB present:15864kB pages_scanned:256 all_unreclaimable? yes
[1557581.580841] lowmem_reserve[]: 0 478 8104 8104
[1557581.580845] Normal free:2632kB min:2752kB low:3440kB high:4128kB active_anon:0kB inactive_anon:0kB active_file:23036kB inactive_file:23032kB unevictable:0kB present:489704kB pages_scanned:80169 all_unreclaimable? yes
[1557581.580848] lowmem_reserve[]: 0 0 61012 61012
[1557581.580852] HighMem free:2678356kB min:512kB low:11492kB high:22476kB active_anon:378292kB inactive_anon:46224kB active_file:277328kB inactive_file:4482452kB unevictable:3468kB present:7809620kB pages_scanned:0 all_unreclaimable? no
[1557581.580855] lowmem_reserve[]: 0 0 0 0
[1557581.580858] DMA: 14*4kB 15*8kB 14*16kB 11*32kB 6*64kB 5*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2032kB
[1557581.580865] Normal: 80*4kB 14*8kB 14*16kB 27*32kB 8*64kB 3*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2672kB
[1557581.580872] HighMem: 104*4kB 54*8kB 22*16kB 11*32kB 75*64kB 6*128kB 463*256kB 3334*512kB 636*1024kB 91*2048kB 2*4096kB = 2678480kB
[1557581.580879] 1202593 total pagecache pages
[1557581.580880] 0 pages in swap cache
[1557581.580882] Swap cache stats: add 0, delete 0, find 0/0
[1557581.580883] Free swap  = 0kB
[1557581.580884] Total swap = 0kB
[1557581.598681] 2162688 pages RAM
[1557581.598681] 2035202 pages HighMem
[1557581.598681] 86689 pages reserved
[1557581.598681] 1220851 pages shared
[1557581.598681] 234699 pages non-shared
[1557581.598681] Out of memory: kill process 6857 (fvwm2) score 3504 or a child
[1557581.598681] Killed process 6890 (xterm)
