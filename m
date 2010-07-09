Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab0GIPxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:53:43 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:51764
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757184Ab0GIPxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:53:36 -0400
X-SpamScore: -24
X-BigFish: VPS-24(z6c9Rz1a09Mzz1202hzz15d4Rz32i2a8h34h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L5ARZG-02-J8Y-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Organization: AMD OSRC
To: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: HDD not suspending properly / dead on resume
Date: Fri, 9 Jul 2010 17:50:04 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.31-22-generic; KDE/4.4.2; x86_64; ; )
CC: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       <linux-pm@lists.osdl.org>, <stephan.diestelhorst@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary-00=_sU0NMi4E3Tv9U0k"
Message-ID: <201007091750.05020.stephan.diestelhorst@amd.com>
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_sU0NMi4E3Tv9U0k
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi,
  I have n issue with suepnd to RAM and I/O load on a disk. Symptoms
are that the disk does not respond to requests when woken up, producing
only I/O errors on all tested kernels (newest 2.6.35-rc4 (Ubuntu
mainline PPA build)):

[ 1719.580169] sd 0:0:0:0: [sda] Unhandled error code
[ 1719.580174] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1719.580178] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 0f 51 e7 88 00 00 b0 00
[ 1719.580186] end_request: I/O error, dev sda, sector 257025928
[ 1719.580798] Aborting journal on device dm-1-8.
[ 1719.580912] EXT4-fs error (device dm-1) in ext4_reserve_inode_write: Journal has aborted
[ 1719.580959] EXT4-fs (dm-1): Remounting filesystem read-only
[ 1719.581004] sd 0:0:0:0: [sda] Unhandled error code
[ 1719.581007] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1719.581010] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 0f 51 a1 88 00 00 08 00
[ 1719.581016] end_request: I/O error, dev sda, sector 257008008
[ 1719.581026] Buffer I/O error on device dm-1, logical block 2129920
[ 1719.581027] lost page write due to I/O error on dm-1
[ 1719.581149] 
[ 1719.581214] sd 0:0:0:0: [sda] Unhandled error code
[ 1719.581217] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1719.581220] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 0e 4d a1 88 00 00 08 00
[ 1719.581227] end_request: I/O error, dev sda, sector 239968648
[ 1719.581254] JBD2: I/O error detected when updating journal superblock for dm-1-8.
[ 1719.581268] journal commit I/O error

This can be triggered most reliably with multiple "direct" writes to
disk, I create the load with the attached script. If the issue is
triggered, suspend (through pm-suspend) takes very long.

IMHO the interesting log output during suspend is:
[ 1668.150125] Suspending console(s) (use no_console_suspend to debug)
[ 1668.150460] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 1668.174958] sd 0:0:0:0: [sda] Stopping disk
[ 1668.198045] ACPI handle has no context!
[ 1668.199302] ohci_hcd 0000:00:14.5: PCI INT C disabled
[ 1668.199468] ohci_hcd 0000:00:13.1: PCI INT A disabled
[ 1668.199477] ohci_hcd 0000:00:13.0: PCI INT A disabled
[ 1668.199520] ehci_hcd 0000:00:12.2: PCI INT B disabled
[ 1668.199525] ohci_hcd 0000:00:12.1: PCI INT A disabled
[ 1668.199562] ohci_hcd 0000:00:12.0: PCI INT A disabled
[ 1668.210138] ehci_hcd 0000:00:13.2: PCI INT B disabled
[ 1668.300295] HDA Intel 0000:00:14.2: PCI INT A disabled
[ 1668.300301] HDA Intel 0000:01:00.1: PCI INT B disabled
[ 1668.300349] ACPI handle has no context!
[ 1669.700139] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1674.700125] ata1.00: qc timeout (cmd 0xec)
[ 1674.700136] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[ 1674.700139] ata1.00: revalidation failed (errno=-5)
[ 1675.230136] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1685.230125] ata1.00: qc timeout (cmd 0xec)
[ 1685.230137] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[ 1685.230140] ata1.00: revalidation failed (errno=-5)
[ 1685.230144] ata1: limiting SATA link speed to 1.5 Gbps
[ 1685.760137] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 1715.760126] ata1.00: qc timeout (cmd 0xec)
[ 1715.760137] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[ 1715.760139] ata1.00: revalidation failed (errno=-5)
[ 1715.760142] ata1.00: disabled
[ 1715.810216] ahci 0000:00:11.0: PCI INT A disabled
[ 1715.830154] PM: suspend of devices complete after 47679.847 msecs

I've also attached the full dmesg, lspci -vv and smartctl -a
information.

Do you guys have any ideas here?

Many thanks,
  Stephan
-- 
Stephan Diestelhorst, AMD Operating System Research Center
stephan.diestelhorst@amd.com, Tel. +49 (0)351 448 356 719

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

--Boundary-00=_sU0NMi4E3Tv9U0k
Content-Type: text/plain; charset="utf-8"; name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-020635rc4-generic (root@zinc) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #020635rc4 SMP Mon Jul 5 09:08:26 UTC 2010
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.35-020635rc4-generic root=/dev/mapper/pool01-root ro console=ttyUSB0,9600n8 console=tty0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7ea0000 (usable)
[    0.000000]  BIOS-e820: 00000000c7ea0000 - 00000000c7ebc000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000c7ebc000 - 00000000c7ebe000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c7ebe000 - 00000000c8000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000138000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x138000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CEFFF write-protect
[    0.000000]   CF000-DEFFF uncachable
[    0.000000]   DF000-DFFFF write-back
[    0.000000]   E0000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF8000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000138000000 aka 4992M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c8000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xc7ea0 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009dc00 (usable)
[    0.000000]  modified: 000000000009dc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000d0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000c7ea0000 (usable)
[    0.000000]  modified: 00000000c7ea0000 - 00000000c7ebc000 (ACPI data)
[    0.000000]  modified: 00000000c7ebc000 - 00000000c7ebe000 (ACPI NVS)
[    0.000000]  modified: 00000000c7ebe000 - 00000000c8000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000138000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f8080] f8080
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000c7ea0000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00c7e00000 page 2M
[    0.000000]  00c7e00000 - 00c7ea0000 page 4k
[    0.000000] kernel direct mapping tables up to c7ea0000 @ 16000-19000
[    0.000000] init_memory_mapping: 0000000100000000-0000000138000000
[    0.000000]  0100000000 - 0138000000 page 2M
[    0.000000] kernel direct mapping tables up to 138000000 @ 18000-1a000
[    0.000000] RAMDISK: 37117000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f7ff0 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 00000000c7eb0005 0005C (v01 SECCSD LH43STAR 06040000  LTP 00000000)
[    0.000000] ACPI: FACP 00000000c7ebb898 000F4 (v03 SEC    MAGIC    06040000 ATI  000F4240)
[    0.000000] ACPI: DSDT 00000000c7eb0061 0B837 (v01    ATI    SB700 06040000 MSFT 03000001)
[    0.000000] ACPI: FACS 00000000c7ebdfc0 00040
[    0.000000] ACPI: TCPA 00000000c7ebba00 00032 (v02 AMD             06040000 PTEC 00000000)
[    0.000000] ACPI: SSDT 00000000c7ebba32 00386 (v01 AMD    POWERNOW 06040000 AMD  00000001)
[    0.000000] ACPI: SLIC 00000000c7ebbdb8 00176 (v01 SECCSD LH43STAR 06040000  LTP 00000000)
[    0.000000] ACPI: APIC 00000000c7ebbf2e 0005E (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: MCFG 00000000c7ebbf8c 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: HPET 00000000c7ebbfc8 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000138000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000138000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880100200000-ffff880103bfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00138000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000c7ea0
[    0.000000]     0: 0x00100000 -> 0x00138000
[    0.000000] On node 0 totalpages: 1048109
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3925 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 800472 pages, LIFO batch:31
[    0.000000]   Normal zone: 3136 pages used for memmap
[    0.000000]   Normal zone: 226240 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538301 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [19000 - 197ff]
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d0000
[    0.000000] PM: Registered nosave memory: 00000000000d0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000c7ea0000 - 00000000c7ebc000
[    0.000000] PM: Registered nosave memory: 00000000c7ebc000 - 00000000c7ebe000
[    0.000000] PM: Registered nosave memory: 00000000c7ebe000 - 00000000c8000000
[    0.000000] PM: Registered nosave memory: 00000000c8000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c8000000 (gap: c8000000:18000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001e00000 s91392 r8192 d23296 u1048576
[    0.000000] pcpu-alloc: s91392 r8192 d23296 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1030637
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.35-020635rc4-generic root=/dev/mapper/pool01-root ro console=ttyUSB0,9600n8 console=tty0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 20000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.000000] early_res array is doubled to 128 at [19800 - 1a7ff]
[    0.000000] Subtract (58 early reservations)
[    0.000000]   #1 [0001000000 - 0001d30a14]   TEXT DATA BSS
[    0.000000]   #2 [0037117000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001d31000 - 0001d311e4]             BRK
[    0.000000]   #4 [00000f8090 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f8080 - 00000f8090]    MP-table mpf
[    0.000000]   #6 [000009dc00 - 000009e171]   BIOS reserved
[    0.000000]   #7 [000009e2ed - 00000f8080]   BIOS reserved
[    0.000000]   #8 [000009e171 - 000009e2ed]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 0000018000]         PGTABLE
[    0.000000]   #12 [0000018000 - 0000019000]         PGTABLE
[    0.000000]   #13 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #14 [0001d31200 - 0001d32200]         BOOTMEM
[    0.000000]   #15 [0001d30a40 - 0001d30d40]         BOOTMEM
[    0.000000]   #16 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #17 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #18 [0100200000 - 0103c00000]        MEMMAP 0
[    0.000000]   #19 [0001d30d40 - 0001d30ec0]         BOOTMEM
[    0.000000]   #20 [0001d32200 - 0001d4a200]         BOOTMEM
[    0.000000]   #21 [0001d4a200 - 0001d50200]         BOOTMEM
[    0.000000]   #22 [0001d51000 - 0001d52000]         BOOTMEM
[    0.000000]   #23 [0001d30ec0 - 0001d30f01]         BOOTMEM
[    0.000000]   #24 [0001d30f40 - 0001d30f83]         BOOTMEM
[    0.000000]   #25 [0001d50200 - 0001d504d8]         BOOTMEM
[    0.000000]   #26 [0001d50500 - 0001d50568]         BOOTMEM
[    0.000000]   #27 [0001d50580 - 0001d505e8]         BOOTMEM
[    0.000000]   #28 [0001d50600 - 0001d50668]         BOOTMEM
[    0.000000]   #29 [0001d50680 - 0001d506e8]         BOOTMEM
[    0.000000]   #30 [0001d50700 - 0001d50768]         BOOTMEM
[    0.000000]   #31 [0001d50780 - 0001d507e8]         BOOTMEM
[    0.000000]   #32 [0001d50800 - 0001d50868]         BOOTMEM
[    0.000000]   #33 [0001d50880 - 0001d508e8]         BOOTMEM
[    0.000000]   #34 [0001d50900 - 0001d50968]         BOOTMEM
[    0.000000]   #35 [0001d50980 - 0001d509e8]         BOOTMEM
[    0.000000]   #36 [0001d50a00 - 0001d50a68]         BOOTMEM
[    0.000000]   #37 [0001d50a80 - 0001d50ae8]         BOOTMEM
[    0.000000]   #38 [0001d30fc0 - 0001d30fe0]         BOOTMEM
[    0.000000]   #39 [0001d50b00 - 0001d50b20]         BOOTMEM
[    0.000000]   #40 [0001d50b40 - 0001d50bb1]         BOOTMEM
[    0.000000]   #41 [0001d50bc0 - 0001d50c31]         BOOTMEM
[    0.000000]   #42 [0001e00000 - 0001e1e000]         BOOTMEM
[    0.000000]   #43 [0001f00000 - 0001f1e000]         BOOTMEM
[    0.000000]   #44 [0001d50c40 - 0001d50c48]         BOOTMEM
[    0.000000]   #45 [0001d50c80 - 0001d50c88]         BOOTMEM
[    0.000000]   #46 [0001d50cc0 - 0001d50cc8]         BOOTMEM
[    0.000000]   #47 [0001d50d00 - 0001d50d10]         BOOTMEM
[    0.000000]   #48 [0001d50d40 - 0001d50e80]         BOOTMEM
[    0.000000]   #49 [0001d50e80 - 0001d50ee0]         BOOTMEM
[    0.000000]   #50 [0001d50f00 - 0001d50f60]         BOOTMEM
[    0.000000]   #51 [0001d52000 - 0001d5a000]         BOOTMEM
[    0.000000]   #52 [0020000000 - 0024000000]         BOOTMEM
[    0.000000]   #53 [0001d50f80 - 0001d50fa0]         BOOTMEM
[    0.000000]   #54 [0001f1e000 - 0005f1e000]         BOOTMEM
[    0.000000]   #55 [0001d5a000 - 0001d7a000]         BOOTMEM
[    0.000000]   #56 [0001d7a000 - 0001dba000]         BOOTMEM
[    0.000000]   #57 [000001a800 - 0000022800]         BOOTMEM
[    0.000000] Memory: 3972372k/5111808k available (5637k kernel code, 919372k absent, 220064k reserved, 5486k data, 976k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:512
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2094.734 MHz processor.
[    0.030010] Calibrating delay loop (skipped), value calculated using timer frequency.. 4189.46 BogoMIPS (lpj=20947310)
[    0.030094] pid_max: default: 32768 minimum: 301
[    0.030156] Security Framework initialized
[    0.030201] SELinux:  Disabled at boot.
[    0.030698] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.041268] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.041990] Mount-cache hash table entries: 256
[    0.042159] Initializing cgroup subsys ns
[    0.042236] Initializing cgroup subsys cpuacct
[    0.042279] Initializing cgroup subsys memory
[    0.042327] Initializing cgroup subsys devices
[    0.042369] Initializing cgroup subsys freezer
[    0.042410] Initializing cgroup subsys net_cls
[    0.042474] tseg: 00c7f00000
[    0.042477] CPU: Physical Processor ID: 0
[    0.042518] CPU: Processor Core ID: 0
[    0.042559] mce: CPU supports 6 MCE banks
[    0.042608] using C1E aware idle routine
[    0.042649] Performance Events: AMD PMU driver.
[    0.042728] ... version:                0
[    0.042769] ... bit width:              48
[    0.042809] ... generic registers:      4
[    0.042850] ... value mask:             0000ffffffffffff
[    0.042891] ... max period:             00007fffffffffff
[    0.042932] ... fixed-purpose events:   0
[    0.042972] ... event mask:             000000000000000f
[    0.044836] ACPI: Core revision 20100428
[    0.060027] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.060081] ftrace: allocating 26474 entries in 104 pages
[    0.070088] Setting APIC routing to flat
[    0.070514] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.173493] CPU0: AMD Athlon(tm) II Dual-Core M320 stepping 02
[    0.180000] Booting Node   0, Processors  #1 Ok.
[    0.340007] Brought up 2 CPUs
[    0.340022] System has AMD C1E enabled
[    0.340041] Switch to broadcast mode on CPU1
[    0.340163] Total of 2 processors activate CPU0
[    0.340414] devtmpfs: initialized
[    0.340748] regulator: core version 0.5
[    0.340854] Time: 17:02:00  Date: 07/09/10
[    0.340935] NET: Registered protocol family 16
[    0.341120] node 0 link 0: io port [1000, ffff]
[    0.341123] TOM: 000i 0000:00:12.1: reg 10: [mem 0xf0405000-0xf0405fff]
[    0.355245] pci 0000:00:12.2: reg 10: [mem 0xf0409400-0xf04094ff]
[    0.355297] pci 0000:00:12.2: supports D1 D2
[    0.355299] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.355303] pci 0000:00:12.2: PME# disabled
[    0.355334] pci 0000:00:13.0: reg 10: [mem 0xf0406000-0xf0406fff]
[    0.355387] pci 0000:00:13.1: reg 10: [mem 0xf0407000-0xf0407fff]
[    0.355452] pci 0000:00:13.2: reg 10: [mem 0xf0409800-0xf04098ff]
[    0.355504] pci 0000:00:13.2: supports D1 D2
[    0.355506] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.355510] pci 0000:00:13.2: PME# disabled
[    0.355626] pci 0000:00:14.2: reg 10: [mem 0xf0400000-0xf0403fff 64bit]
[    0.355669] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.355673] pci 0000:00:14.2: PME# disabled
[    0.355775] pci 0000:00:14.5: reg 10: [mem 0xf0408000-0xf0408fff]
[    0.355968] pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.355977] pci 0000:01:00.0: reg 18: [mem 0xcfee0000-0xcfefffff 64bit]
[    0.355982] pci 0000:01:00.0: reg 20: [io  0x9000-0x90ff]
[    0.355991] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.356008] pci 0000:01:00.0: supports D1 D2
[    0.356039] pci 0000:01:00.1: reg 10: [mem 0xcfedc000-0xcfedffff 64bit]
[    0.356071] pci 0000:01:00.1: supports D1 D2
[    0.380035] pci 0000:00:02.0: PCI bridge to [bus 01-01]
[    0.380083] pci 0000:00:02.0:   bridge window [io  0x9000-0x9fff]
[    0.380087] pci 0000:00:02.0:   bridge window [mem 0xcfe00000-0xcfefffff]
[    0.380091] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.380152] pci 0000:02:00.0: reg 10: [mem 0xf0200000-0xf020ffff 64bit]
[    0.380203] pci 0000:02:00.0: supports D1
[    0.380206] pci 0000:02:00.0: PME# supported from D0 D1 D3hot
[    0.380210] pci 0000:02:00.0: PME# disabled
[    0.410034] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    0.410083] pci 0000:00:04.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.410087] pci 0000:00:04.0:   bridge window [mem 0xf0200000-0xf02fffff]
[    0.410091] pci 0000:00:04.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.410122] pci 0000:00:05.0: PCI bridge to [bus 03-03]
[    0.410165] pci 0000:00:05.0:   bridge window [io  0x0000-0x0000] (disabled)
[    0.410168] pci 0000:00:05.0:   bridge window [mem 0x00000000-0x000fffff] (disabled)
[    0.410172] pci 0000:00:05.0:   bridge window [mem 0x00000000-0x000fffff pref] (disabled)
[    0.410268] pci 0000:04:00.0: reg 10: [mem 0xf0300000-0xf0303fff 64bit]
[    0.410275] pci 0000:04:00.0: reg 18: [io  0xa000-0xa0ff]
[    0.410369] pci 0000:04:00.0: supports D1 D2
[    0.410372] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.410377] pci 0000:04:00.0: PME# disabled
[    0.440074] pci 0000:00:06.0: PCI bridge to [bus 04-04]
[    0.440157] pci 0000:00:06.0:   bridge window [io  0xa000-0xafff]
[    0.440160] pci 0000:00:06.0:   bridge window [mem 0xf0300000-0xf03fffff]
[    0.440164] pci 0000:00:06.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.440233] pci 0000:00:14.4: PCI bridge to [bus 05-05] (subtractive decode)
[    0.440278] pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.440283] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.440287] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.440290] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.440292] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000d1fff] (subtractive decode)
[    0.440295] pci 0000:00:14.4:   bridge window [mem 0x000d2000-0x000d3fff] (subtractive decode)
[    0.440297] pci 0000:00:14.4:   bridge window [mem 0x000d4000-0x000d5fff] (subtractive decode)
[    0.440299] pci 0000:00:14.4:   bridge window [mem 0x000d6000-0x000d7fff] (subtractive decode)
[    0.440302] pci 0000:00:14.4:   bridge window [mem 0x000d8000-0x000d9fff] (subtractive decode)
[    0.440304] pci 0000:00:14.4:   bridge window [mem 0x000da000-0x000dbfff] (subtractive decode)
[    0.440306] pci 0000:00:14.4:   bridge window [mem 0x000dc000-0x000ddfff] (subtractive decode)
[    0.440308] pci 0000:00:14.4:   bridge window [mem 0xc8000000-0xdfffffff] (subtractive decode)
[    0.440311] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xffffffff] (subtractive decode)
[    0.440313] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.440315] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.440339] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.440579] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB2_._PRT]
[    0.440664] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB4_._PRT]
[    0.440735] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB5_._PRT]
[    0.440804] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB6_._PRT]
[    0.440922] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.445363] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0, disabled.
[    0.445765] ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0, disabled.
[    0.446158] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0, disabled.
[    0.446550] ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0, disabled.
[    0.446943] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0, disabled.
[    0.447335] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0, disabled.
[    0.447727] ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0, disabled.
[    0.448119] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0, disabled.
[    0.448407] HEST: Table is not found!
[    0.448532] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.448612] vgaarb: loaded
[    0.448786] SCSI subsystem initialized
[    0.450045] libata version 3.00 loaded.
[    0.450047] usbcore: registered new interface driver usbfs
[    0.450131] usbcore: registered new interface driver hub
[    0.450181] usbcore: registered new device driver usb
[    0.450181] ACPI: WMI: Mapper loaded
[    0.450181] PCI: Using ACPI for IRQ routing
[    0.450205] PCI: pci_cache_line_size set to 64 bytes
[    0.450384] reserve RAM buffer: 000000000009dc00 - 000000000009ffff 
[    0.450387] reserve RAM buffer: 00000000c7ea0000 - 00000000c7ffffff 
[    0.450394] NetLabel: Initializing
[    0.450394] NetLabel:  domain hash size = 128
[    0.450394] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.450394] NetLabel:  unlabeled traffic allowed by default
[    0.450394] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.450559] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.452631] Switching to clocksource tsc
[    0.467732] pnp: PnP ACPI init
[    0.467827] ACPI: bus type pnp registered
[    0.471817] pnp: PnP ACPI: found 11 devices
[    0.471897] ACPI: ACPI bus type pnp unregistered
[    0.471955] system 00:01: [io  0x0f50-0x0f51] has been reserved
[    0.472000] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.472042] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.472091] system 00:08: [io  0x0220-0x022f] has been reserved
[    0.472132] system 00:08: [io  0x040b] has been reserved
[    0.472174] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.472215] system 00:08: [io  0x04d6] has been reserved
[    0.472257] system 00:08: [io  0x0530-0x0537] has been reserved
[    0.472299] system 00:08: [io  0x0c00-0x0c01] has been reserved
[    0.472340] system 00:08: [io  0x0c14] has been reserved
[    0.472382] system 00:08: [io  0x0c50-0x0c52] has been reserved
[    0.472424] system 00:08: [io  0x0c6c] has been reserved
[    0.472465] system 00:08: [io  0x0c6f] has been reserved
[    0.472507] system 00:08: [io  0x0cd0-0x0cd1] has been reserved
[    0.472548] system 00:08: [io  0x0cd2-0x0cd3] has been reserved
[    0.472589] system 00:08: [io  0x0cd4-0x0cd5] has been reserved
[    0.472631] system 00:08: [io  0x0cd6-0x0cd7] has been reserved
[    0.472673] system 00:08: [io  0x0cd8-0x0cdf] has been reserved
[    0.472715] system 00:08: [io  0x8000-0x805f] has been reserved
[    0.472757] system 00:08: [io  0x8100-0x81ff window] has been reserved
[    0.472799] system 00:08: [io  0x8200-0x82ff window] has been reserved
[    0.472841] system 00:08: [io  0x0f40-0x0f47] has been reserved
[    0.472883] system 00:08: [io  0x087f] has been reserved
[    0.472928] system 00:09: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.472971] system 00:09: [mem 0xffe00000-0xffffffff] could not be reserved
[    0.473013] system 00:09: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.478132] pci 0000:00:05.0: BAR 14: assigned [mem 0xc8000000-0xc81fffff]
[    0.478177] pci 0000:00:05.0: BAR 15: assigned [mem 0xc8200000-0xc83fffff 64bit pref]
[    0.478224] pci 0000:00:05.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.478268] pci 0000:01:00.0: BAR 6: assigned [mem 0xcfe00000-0xcfe1ffff pref]
[    0.478313] pci 0000:00:02.0: PCI bridge to [bus 01-01]
[    0.478354] pci 0000:00:02.0:   bridge window [io  0x9000-0x9fff]
[    0.478397] pci 0000:00:02.0:   bridge window [mem 0xcfe00000-0xcfefffff]
[    0.478440] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.478487] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    0.478528] pci 0000:00:04.0:   bridge window [io  disabled]
[    0.478570] pci 0000:00:04.0:   bridge window [mem 0xf0200000-0xf02fffff]
[    0.478612] pci 0000:00:04.0:   bridge window [mem pref disabled]
[    0.478655] pci 0000:00:05.0: PCI bridge to [bus 03-03]
[    0.478697] pci 0000:00:05.0:   bridge window [io  0x1000-0x1fff]
[    0.478740] pci 0000:00:05.0:   bridge window [mem 0xc8000000-0xc81fffff]
[    0.478782] pci 0000:00:05.0:   bridge window [mem 0xc8200000-0xc83fffff 64bit pref]
[    0.478829] pci 0000:00:06.0: PCI bridge to [bus 04-04]
[    0.478871] pci 0000:00:06.0:   bridge window [io  0xa000-0xafff]
[    0.479543] pci 0000:00:06.0:   bridge window [mem 0xf0300000-0xf03fffff]
[    0.479586] pci 0000:00:06.0:   bridge window [mem pref disabled]
[    0.479629] pci 0000:00:14.4: PCI bridge to [bus 05-05]
[    0.479670] pci 0000:00:14.4:   bridge window [io  disabled]
[    0.479714] pci 0000:00:14.4:   bridge window [mem disabled]
[    0.479757] pci 0000:00:14.4:   bridge window [mem pref disabled]
[    0.479810]   alloc irq_desc for 18 on node 0
[    0.479813]   alloc kstat_irqs on node 0
[    0.479820] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.479864] pci 0000:00:02.0: setting latency timer to 64
[    0.479869]   alloc irq_desc for 16 on node 0
[    0.479871]   alloc kstat_irqs on node 0
[    0.479874] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.479917] pci 0000:00:04.0: setting latency timer to 64
[    0.479922] pci 0000:00:05.0: enabling device (0000 -> 0003)
[    0.479964]   alloc irq_desc for 17 on node 0
[    0.479966]   alloc kstat_irqs on node 0
[    0.479969] pci 0000:00:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.480012] pci 0000:00:05.0: setting latency timer to 64
[    0.480018] pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.480060] pci 0000:00:06.0: setting latency timer to 64
[    0.480069] pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff]
[    0.480071] pci_bus 0000:00: resource 5 [mem 0x000d0000-0x000d1fff]
[    0.480074] pci_bus 0000:00: resource 6 [mem 0x000d2000-0x000d3fff]
[    0.480076] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d5fff]
[    0.480079] pci_bus 0000:00: resource 8 [mem 0x000d6000-0x000d7fff]
[    0.480081] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000d9fff]
[    0.480084] pci_bus 0000:00: resource 10 [mem 0x000da000-0x000dbfff]
[    0.480086] pci_bus 0000:00: resource 11 [mem 0x000dc000-0x000ddfff]
[    0.480089] pci_bus 0000:00: resource 12 [mem 0xc8000000-0xdfffffff]
[    0.480091] pci_bus 0000:00: resource 13 [mem 0xf0000000-0xffffffff]
[    0.480094] pci_bus 0000:00: resource 14 [io  0x0000-0x0cf7]
[    0.480096] pci_bus 0000:00: resource 15 [io  0x0d00-0xffff]
[    0.480099] pci_bus 0000:01: resource 0 [io  0x9000-0x9fff]
[    0.480101] pci_bus 0000:01: resource 1 [mem 0xcfe00000-0xcfefffff]
[    0.480104] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.480106] pci_bus 0000:02: resource 1 [mem 0xf0200000-0xf02fffff]
[    0.480109] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    0.480111] pci_bus 0000:03: resource 1 [mem 0xc8000000-0xc81fffff]
[    0.480114] pci_bus 0000:03: resource 2 [mem 0xc8200000-0xc83fffff 64bit pref]
[    0.480117] pci_bus 0000:04: resource 0 [io  0xa000-0xafff]
[    0.480119] pci_bus 0000:04: resource 1 [mem 0xf0300000-0xf03fffff]
[    0.480122] pci_bus 0000:05: resource 4 [mem 0x000a0000-0x000bffff]
[    0.480124] pci_bus 0000:05: resource 5 [mem 0x000d0000-0x000d1fff]
[    0.480126] pci_bus 0000:05: resource 6 [mem 0x000d2000-0x000d3fff]
[    0.480129] pci_bus 0000:05: resource 7 [mem 0x000d4000-0x000d5fff]
[    0.480131] pci_bus 0000:05: resource 8 [mem 0x000d6000-0x000d7fff]
[    0.480134] pci_bus 0000:05: resource 9 [mem 0x000d8000-0x000d9fff]
[    0.480136] pci_bus 0000:05: resource 10 [mem 0x000da000-0x000dbfff]
[    0.480139] pci_bus 0000:05: resource 11 [mem 0x000dc000-0x000ddfff]
[    0.480141] pci_bus 0000:05: resource 12 [mem 0xc8000000-0xdfffffff]
[    0.480144] pci_bus 0000:05: resource 13 [mem 0xf0000000-0xffffffff]
[    0.480146] pci_bus 0000:05: resource 14 [io  0x0000-0x0cf7]
[    0.480148] pci_bus 0000:05: resource 15 [io  0x0d00-0xffff]
[    0.480183] NET: Registered protocol family 2
[    0.480400] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.481649] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.484878] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.485330] TCP: Hash tables configured (established 524288 bind 65536)
[    0.485408] TCP reno registered
[    0.485462] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.485540] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.485724] NET: Registered protocol family 1
[    0.485964] pci 0000:01:00.0: Boot video device
[    0.485991] PCI: CLS 32 bytes, default 64
[    0.486046] Trying to unpack rootfs image as initramfs...
[    0.825588] Freeing initrd memory: 15204k freed
[    0.831516] PCI-DMA: Disabling AGP.
[    0.831665] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.831708] PCI-DMA: using GART IOMMU.
[    0.831749] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.835233] Scanning for low memory corruption every 60 seconds
[    0.835419] audit: initializing netlink socket (disabled)
[    0.835504] type=2000 audit(1278694919.820:1): initialized
[    0.850282] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.851726] VFS: Disk quotas dquot_6.5.2
[    0.851835] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.852510] fuse init (API version 7.14)
[    0.852699] msgmni has been set to 7917
[    0.853034] alg: No test for stdrng (krng)
[    0.853211] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.853282] io scheduler noop registered
[    0.853322] io scheduler deadline registered
[    0.853400] io scheduler cfq registered (default)
[    0.853656] pcieport 0000:00:02.0: setting latency timer to 64
[    0.853679]   alloc irq_desc for 40 on node 0
[    0.853681]   alloc kstat_irqs on node 0
[    0.853690] pcieport 0000:00:02.0: irq 40 for MSI/MSI-X
[    0.853817] pcieport 0000:00:04.0: setting latency timer to 64
[    0.853836]   alloc irq_desc for 41 on node 0
[    0.853838]   alloc kstat_irqs on node 0
[    0.853843] pcieport 0000:00:04.0: irq 41 for MSI/MSI-X
[    0.853944] pcieport 0000:00:05.0: setting latency timer to 64
[    0.853963]   alloc irq_desc for 42 on node 0
[    0.853965]   alloc kstat_irqs on node 0
[    0.853969] pcieport 0000:00:05.0: irq 42 for MSI/MSI-X
[    0.854080] pcieport 0000:00:06.0: setting latency timer to 64
[    0.854099]   alloc irq_desc for 43 on node 0
[    0.854101]   alloc kstat_irqs on node 0
[    0.854106] pcieport 0000:00:06.0: irq 43 for MSI/MSI-X
[    0.854223] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.854354] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.855160] ACPI: AC Adapter [ACAD] (on-line)
[    0.855310] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.855395] ACPI: Power Button [PWRB]
[    0.855485] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    0.855565] ACPI: Sleep Button [SLPB]
[    0.855636] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input2
[    0.856010] ACPI: Lid Switch [LID]
[    0.856158] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.856238] ACPI: Power Button [PWRF]
[    0.856474] ACPI: acpi_idle registered with cpuidle
[    0.856502] ACPI: processor limited to max C-state 1
[    0.861070] thermal LNXTHERM:01: registered as thermal_zone0
[    0.861157] ACPI: Thermal Zone [THZ0] (58 C)
[    0.861280] ERST: Table is not found!
[    0.861683] ACPI: Battery Slot [BATT] (battery absent)
[    0.862673] Linux agpgart interface v0.103
[    0.862754] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.863847] brd: module loaded
[    0.864312] loop: module loaded
[    0.864840] Fixed MDIO Bus: probed
[    0.864941] PPP generic driver version 2.4.2
[    0.865010] tun: Universal TUN/TAP device driver, 1.6
[    0.865051] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.865165] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.865378] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.865470] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.865578] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    0.865703] ehci_hcd 0000:00:12.2: debug port 1
[    0.865768] ehcicted
[    0.877823]   alloc irq_desc for 19 on node 0
[    0.877826]   alloc kstat_irqs on node 0
[    0.877834] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.877899] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    0.877978] ehcOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.212870] EDD information not available.
[    1.212981] Freeing unused kernel memory: 976k freed
[    1.213335] Write protecting the kernel read-only data: 10240k
[    1.213570] Freeing unused kernel memory: 488k freed
[    1.213887] Freeing unused kernel memory: 1532k freed
[    1.237253] udev: starting version 151
[    1.242434] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.276613] sky2: driver version 1.28
[    1.295243] sky2 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.295372] sky2 0000:04:00.0: setting latency timer to 64
[    1.295460] sky2 0000:04:00.0: Yukon-2 FE+ chip revision 0
[    1.295596]   alloc irq_desc for 44 on node 0
[    1.295598]   alloc kstat_irqs on node 0
[    1.295633] sky2 0000:04:00.0: irq 44 for MSI/MSI-X
[    1.300721] sky2 0000:04:00.0: eth0: addr 00:24:54:6e:90:bf
[    1.322602] usb 2-3: new high speed USB device using ehci_hcd and address 2
[    1.336712] ahci 0000:00:11.0: version 3.0
[    1.336766]   alloc irq_desc for 22 on node 0
[    1.336769]   alloc kstat_irqs on node 0
[    1.336778] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.336994] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0xb impl SATA mode
[    1.337041] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc sxs 
[    1.349002] [Firmware Bug]: ACPI: ACPI brightness control misses _BQC function
[    1.354812] scsi0 : ahci
[    1.358819] scsi1 : ahci
[    1.360103] scsi2 : ahci
[    1.360276] scsi3 : ahci
[    1.361694] ata1: SATA max UDMA/133 abar m1024@0xf0409000 port 0xf0409100 irq 22
[    1.361740] ata2: SATA max UDMA/133 abar m1024@0xf0409000 port 0xf0409180 irq 22
[    1.361756] acpi device:02: registered as cooling_device2
[    1.361824] ata3: DUMMY
[    1.361865] ata4: SATA max UDMA/133 abar m1024@0xf0409000 port 0xf0409280 irq 22
[    1.362019] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/input/input5
[    1.362126] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    1.710110] ata4: SATA link down (SStatus 0 SControl 300)
[    1.800099] usb 3-1: new full speed USB device using ohci_hcd and address 2
[    1.910118] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.910191] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.911662] ata2.00: ATAPI: TSSTcorp CDDVDW TS-L633C, SC00, max UDMA/100
[    1.911717] ata2.00: applying bridge limits
[    1.915164] ata2.00: configured for UDMA/100
[    1.916178] ata1.00: ATA-8: SAMSUNG HM321HI, 2AJ10001, max UDMA/133
[    1.916225] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.922081] ata1.00: configured for UDMA/133
[    1.942812] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HM321HI  2AJ1 PQ: 0 ANSI: 5
[    1.943045] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.943159] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    1.943274] sd 0:0:0:0: [sda] Write Protect is off
[    1.943359] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.943376] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.943548]  sda:
[    1.950051] scsi 1:0:0:0: CD-ROM            TSSTcorp CDDVDW TS-L633C  SC00 PQ: 0 ANSI: 5
[    1.955031] sr0: scsi3-mmc drive: 31x/62x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.955081] Uniform CD-ROM driver Revision: 3.20
[    1.955248] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.955305] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.969254]  sda1 sda2 sda3 sda4 < sda5 sda6 >
[    1.997592] sd 0:0:0:0: [sda] Attached SCSI disk
[   64.930341] Intel AES-NI instructions are not detected.
[   65.937815] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[   77.786154] udev: starting version 151
[   77.814768] Adding 3903484k swap on /dev/mapper/pool01-swap.  Priority:-1 extents:1 across:3903484k 
[   78.196198] EDAC MC: Ver: 2.1.0 Jul  5 2010
[   78.214506] ACPI: resource piix4_smbus [io  0x8040-0x8047] conflicts with ACPI region SMB0 [mem 0x00008040-0x0000804f 64bit window disabled]
[   78.214510] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   78.244077] EDAC amd64_edac:  Ver: 3.3.0 Jul  5 2010
[   78.245729] lp: driver loaded but no devices found
[   78.248326] EDAC amd64: This node reports that Memory ECC is currently disabled, set F3x44[22] (0000:00:18.3).
[   78.248342] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
[   78.248344]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
[   78.248345]  (Note that use of the override may cause unknown side effects.)
[   78.248383] amd64_edac: probe of 0000:00:18.2 failed with error -22
[   78.267420] usbcore: registered new interface driver usbserial
[   78.267435] USB Serial support registered for generic
[   78.267756] usbcore: registered new interface driver usbserial_generic
[   78.267759] usbserial: USB Serial Driver core
[   78.316182] USB Serial support registered for pl2303
[   78.316209] pl2303 3-1:1.0: pl2303 converter detected
[   78.335199] cfg80211: Calling CRDA to update world regulatory domain
[   78.338209] usb 3-1: pl2303 converter now attached to ttyUSB0
[   78.338229] usbcore: registered new interface driver pl2303
[   78.338232] pl2303: Prolific PL2303 USB to serial adaptor driver
[   78.417292] cfg80211: World regulatory domain updated:
[   78.417296]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   78.417300]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   78.417302]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   78.417305]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   78.417307]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   78.417309]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   78.634335] Linux video capture interface: v2.00
[   78.686693] uvcvideo: Found UVC 1.00 device USB 2.0 PC Camera (1210:25f4)
[   78.689737] input: USB 2.0 PC Camera as /devices/pci0000:00/0000:00:13.2/usb2/2-3/2-3:1.0/input/input6
[   78.689789] usbcore: registered new interface driver uvcvideo
[   78.689792] USB Video Class driver (v0.1.0)
[   78.991424] Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04731/0xa40000/0xa0000
[   79.032933] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input7
[   79.196967] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   79.242084] ath9k 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   79.242094] ath9k 0000:02:00.0: setting latency timer to 64
[   79.291883] ath: EEPROM regdomain: 0x65
[   79.291885] ath: EEPROM indicates we should expect a direct regpair map
[   79.291890] ath: Country alpha2 being used: 00
[   79.291891] ath: Regpair used: 0x65
[   79.372393] phy0: Selected rate control algorithm 'ath9k_rate_control'
[   79.372989] Registered led device: ath9k-phy0::radio
[   79.373003] Registered led device: ath9k-phy0::assoc
[   79.373018] Registered led device: ath9k-phy0::tx
[   79.373031] Registered led device: ath9k-phy0::rx
[   79.373039] phy0: Atheros AR9285 Rev:2 mem=0xffffc90001600000, irq=16
[   79.665780] hda_codec: ALC269: BIOS auto-probing.
[   79.669000] HDA Intel 0000:01:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   79.669073]   alloc irq_desc for 45 on node 0
[   79.669075]   alloc kstat_irqs on node 0
[   79.669087] HDA Intel 0000:01:00.1: irq 45 for MSI/MSI-X
[   79.669114] HDA Intel 0000:01:00.1: setting latency timer to 64
[   80.202897] EXT4-fs (dm-1): re-mounted. Opts: errors=remount-ro
[   80.706092] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: (null)
[   82.266351] ppdev: user-space parallel port driver
[   91.093692] Xorg:1151 freeing invalid memtype d0000000-e0000000
[  469.555940] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  469.683481] sky2 0000:04:00.0: eth0: enabling interface
[  469.686128] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  471.243013] sky2 0000:04:00.0: eth0: Link is up at 100 Mbps, full duplex, flow control rx
[  471.245517] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  481.722623] eth0: no IPv6 routers present
[ 1661.793497] modprobe:3342 freeing invalid memtype f0200000-f0210000
[ 1661.793554] ath9k 0000:02:00.0: PCI INT A disabled
[ 1661.793748] ath9k: Driver unloaded
[ 1666.546339] PM: Syncing filesystems ... done.
[ 1668.111070] PM: Preparing system for mem sleep
[ 1668.111077] Freezing user space processes ... (elapsed 0.01 seconds) done.
[ 1668.130103] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[ 1668.150108] PM: Entering mem sleep
[ 1668.150125] Suspending console(s) (use no_console_suspend to debug)
[ 1668.150460] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 1668.174958] sd 0:0:0:0: [sda] Stopping disk
[ 1668.198045] ACPI handle has no context!
[ 1668.199302] ohci_hcd 0000:00:14.5: PCI INT C disabled
[ 1668.199468] ohci_hcd 0000:00:13.1: PCI INT A disabled
[ 1668.199477] ohci_hcd 0000:00:13.0: PCI INT A disabled
[ 1668.199520] ehci_hcd 0000:00:12.2: PCI INT B disabled
[ 1668.199525] ohci_hcd 0000:00:12.1: PCI INT A disabled
[ 1668.199562] ohci_hcd 0000:00:12.0: PCI INT A disabled
[ 1668.210138] ehci_hcd 0000:00:13.2: PCI INT B disabled
[ 1668.300295] HDA Intel 0000:00:14.2: PCI INT A disabled
[ 1668.300301] HDA Intel 0000:01:00.1: PCI INT B disabled
[ 1668.300349] ACPI handle has no context!
[ 1669.700139] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1674.700125] ata1.00: qc timeout (cmd 0xec)
[ 1674.700136] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[ 1674.700139] ata1.00: revalidation failed (errno=-5)
[ 1675.230136] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1685.230125] ata1.00: qc timeout (cmd 0xec)
[ 1685.230137] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[ 1685.230140] ata1.00: revalidation failed (errno=-5)
[ 1685.230144] ata1: limiting SATA link speed to 1.5 Gbps
[ 1685.760137] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 1715.760126] ata1.00: qc timeout (cmd 0xec)
[ 1715.760137] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[ 1715.760139] ata1.00: revalidation failed (errno=-5)
[ 1715.760142] ata1.00: disabled
[ 1715.810216] ahci 0000:00:11.0: PCI INT A disabled
[ 1715.830154] PM: suspend of devices complete after 47679.847 msecs
[ 1715.830158] PM: suspend devices took 47.670 seconds
[ 1715.830159] ------------[ cut here ]------------
[ 1715.830166] WARNING: at /home/kernel-ppa/COD/linux/kernel/power/suspend_test.c:53 suspend_test_finish+0x89/0x90()
[ 1715.830168] Hardware name: R425/R525                  
[ 1715.830170] Component: suspend devices, time: 47670
[ 1715.830171] Modules linked in: binfmt_misc ppdev snd_hda_codec_atihdmi snd_hda_codec_realtek arc4 snd_hda_intel snd_hda_codec joydev snd_hwdep snd_pcm snd_seq_midi snd_rawmidi uvcvideo snd_seq_midi_event snd_seq videodev snd_timer v4l1_compat snd_seq_device v4l2_compat_ioctl32 pl2303 snd usbserial soundcore lp i2c_piix4 psmouse edac_core parport k10temp edac_mce_amd snd_page_alloc serio_raw sha256_generic cryptd aes_x86_64 aes_generic dm_crypt video output ahci libahci sky2 [last unloaded: led_class]
[ 1715.830199] Pid: 3251, comm: pm-suspend Not tainted 2.6.35-020635rc4-generic #020635rc4
[ 1715.830201] Call Trace:
[ 1715.830207]  [<ffffffff8109dc39>] ? suspend_test_finish+0x89/0x90
[ 1715.830211]  [<ffffffff81061390>] warn_slowpath_common+0x90/0xc0
[ 1715.830214]  [<ffffffff810614be>] warn_slowpath_fmt+0x6e/0x70
[ 1715.830218]  [<ffffffff813828ea>] ? dpm_suspend+0x15a/0x190
[ 1715.830221]  [<ffffffff8109dc39>] suspend_test_finish+0x89/0x90
[ 1715.830223]  [<ffffffff8109da11>] suspend_devices_and_enter+0xe1/0x100
[ 1715.830226]  [<ffffffff8109db11>] enter_state+0xe1/0xf0
[ 1715.830228]  [<ffffffff8109d064>] state_store+0xb4/0xf0
[ 1715.830232]  [<ffffffff812ac927>] kobj_attr_store+0x17/0x20
[ 1715.830237]  [<ffffffff811b91b2>] flush_write_buffer+0x62/0x90
[ 1715.830240]  [<ffffffff811b92f6>] sysfs_write_file+0x66/0xa0
[ 1715.830243]  [<ffffffff811511ac>] vfs_write+0xcc/0x1a0
[ 1715.830246]  [<ffffffff81151375>] sys_write+0x55/0x90
[ 1715.830250]  [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
[ 1715.830253] ---[ end trace 0295700764e4ce32 ]---
[ 1715.870199] PM: late suspend of devices complete after 39.939 msecs
[ 1715.870261] ACPI: Preparing to enter system sleep state S3
[ 1715.920383] PM: Saving platform NVS memory
[ 1715.920593] Disabling non-boot CPUs ...
[ 1715.960276] Broke affinity for irq 22
[ 1716.060123] CPU 1 is now offline
[ 1716.060127] SMP alternatives: switching to UP code
[ 1716.065073] Back to C!
[ 1716.065073] PM: Restoring platform NVS memory
[ 1716.065073] PCI-DMA: Resuming GART IOMMU
[ 1716.065073] PCI-DMA: Restoring GART aperture settings
[ 1716.065073] Enabling non-boot CPUs ...
[ 1716.065073] SMP alternatives: switching to SMP code
[ 1716.065073] Booting Node 0 Processor 1 APIC 0x1
[ 1716.260153] Switch to broadcast mode on CPU1
[ 1716.320392] CPU1 is up
[ 1716.320535] ACPI: Waking up from system sleep state S3
[ 1716.395258] pcieport 0000:00:02.0: restoring config space at offset 0x7 (was 0x20009191, writing 0x9191)
[ 1716.395264] pcieport 0000:00:02.0: restoring config space at offset 0x3 (was 0x10000, writing 0x10008)
[ 1716.395290] pcieport 0000:00:04.0: restoring config space at offset 0x7 (was 0x1f1, writing 0x200001f1)
[ 1716.395294] pcieport 0000:00:04.0: restoring config space at offset 0x3 (was 0x10000, writing 0x10008)
[ 1716.395319] pcieport 0000:00:05.0: restoring config space at offset 0x3 (was 0x10000, writing 0x10008)
[ 1716.395323] pcieport 0000:00:05.0: restoring config space at offset 0x1 (was 0x100400, writing 0x100407)
[ 1716.395347] pcieport 0000:00:06.0: restoring config space at offset 0x3 (was 0x10000, writing 0x10008)
[ 1716.412597] ehci_hcd 0000:00:12.2: BAR 0: set to [mem 0xf0409400-0xf04094ff] (PCI address [0xf0409400-0xf04094ff]
[ 1716.412630] ehci_hcd 0000:00:12.2: restoring config space at offset 0x1 (was 0x2b00000, writing 0x2b00013)
[ 1716.432597] ehci_hcd 0000:00:13.2: BAR 0: set to [mem 0xf0409800-0xf04098ff] (PCI address [0xf0409800-0xf04098ff]
[ 1716.432630] ehci_hcd 0000:00:13.2: restoring config space at offset 0x1 (was 0x2b00000, writing 0x2b00013)
[ 1716.432681] HDA Intel 0000:00:14.2: restoring config space at offset 0xf (was 0x10a, writing 0xa)
[ 1716.432701] HDA Intel 0000:00:14.2: restoring config space at offset 0x1 (was 0x4100006, writing 0x4100002)
[ 1716.432819] pci 0000:01:00.0: restoring config space at offset 0xf (was 0x1ff, writing 0x10b)
[ 1716.432833] pci 0000:01:00.0: restoring config space at offset 0x3 (was 0x800000, writing 0x800008)
[ 1716.432860] HDA Intel 0000:01:00.1: restoring config space at offset 0xf (was 0x2ff, writing 0x20b)
[ 1716.432873] HDA Intel 0000:01:00.1: restoring config space at offset 0x4 (was 0x4, writing 0xcfedc004)
[ 1716.432877] HDA Intel 0000:01:00.1: restoring config space at offset 0x3 (was 0x800000, writing 0x800008)
[ 1716.432882] HDA Intel 0000:01:00.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100003)
[ 1716.432913] pci 0000:02:00.0: restoring config space at offset 0xf (was 0x1ff, writing 0x10a)
[ 1716.432928] pci 0000:02:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xf0200004)
[ 1716.432932] pci 0000:02:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
[ 1716.432938] pci 0000:02:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100003)
[ 1716.433022] sky2 0000:04:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[ 1716.433039] sky2 0000:04:00.0: restoring config space at offset 0x6 (was 0x1, writing 0xa001)
[ 1716.433045] sky2 0000:04:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xf0300004)
[ 1716.433050] sky2 0000:04:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
[ 1716.433056] sky2 0000:04:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[ 1716.433123] PM: early resume of devices complete after 37.905 msecs
[ 1716.433540] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[ 1716.433615] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 1716.433634] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 1716.433763] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[ 1716.433789] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[ 1716.433815] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[ 1716.433830] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[ 1716.433882] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 1716.433897] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[ 1716.433924] HDA Intel 0000:01:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[ 1716.433931] HDA Intel 0000:01:00.1: setting latency timer to 64
[ 1716.434286] HDA Intel 0000:01:00.1: irq 45 for MSI/MSI-X
[ 1716.435304] sd 0:0:0:0: [sda] Starting disk
[ 1716.740101] usb 2-3: reset high speed USB device using ehci_hcd and address 2
[ 1716.780111] ata4: SATA link down (SStatus 0 SControl 300)
[ 1716.960086] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 1717.062612] usb 3-1: reset full speed USB device using ohci_hcd and address 2
[ 1717.131055] ata2.00: configured for UDMA/100
[ 1717.243292] usb 3-1: device firmware changed
[ 1717.682615] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 1717.702648] sd 0:0:0:0: [sda] START_STOP FAILED
[ 1717.702652] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1717.702684] legacy_resume(): scsi_bus_resume+0x0/0x70 returns 262144
[ 1717.702692] PM: Device 0:0:0:0 failed to resume async: error 262144
[ 1717.702705] sd 0:0:0:0: [sda] Unhandled error code
[ 1717.702707] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1717.702710] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 1b 1c ed d0 00 00 a8 00
[ 1717.702716] end_request: I/O error, dev sda, sector 454880720
[ 1717.702749] PM: resume of devices complete after 1269.558 msecs
[ 1717.702824] Aborting journal on device dm-3-8.
[ 1717.702913] sd 0:0:0:0: [sda] Unhandled error code
[ 1717.702914] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1717.702917] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 1b 1c c1 88 00 00 08 00
[ 1717.702922] end_request: I/O error, dev sda, sector 454869384
[ 1717.702928] PM: resume devices took 1.270 seconds
[ 1717.702930] Buffer I/O error on device dm-3, logical block 21004288
[ 1717.702932] lost page write due to I/O error on dm-3
[ 1717.702940] JBD2: I/O error detected when updating journal superblock for dm-3-8.
[ 1717.703381] PM: Finishing wakeup.
[ 1717.703383] Restarting tasks ... 
[ 1717.703487] usb 3-1: USB disconnect, address 2
[ 1717.703620] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
[ 1717.703634] pl2303 3-1:1.0: device disconnected
[ 1717.704683] EXT4-fs error (device dm-3): ext4_journal_start_sb: Detected aborted journal
[ 1717.704839] EXT4-fs (dm-3): Remounting filesystem read-only
[ 1717.710163] done.
[ 1717.710169] video LNXVIDEO:00: Restoring backlight state
[ 1717.880078] usb 3-1: new full speed USB device using ohci_hcd and address 3
[ 1718.013678] sky2 0000:04:00.0: eth0: Link is up at 100 Mbps, full duplex, flow control rx
[ 1718.083270] pl2303 3-1:1.0: pl2303 converter detected
[ 1718.105296] usb 3-1: pl2303 converter now attached to ttyUSB0
[ 1718.658965] sd 0:0:0:0: [sda] Unhandled error code
[ 1718.658969] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1718.658973] sd 0:0:0:0: [sda] CDB: Read(10): 28 00 0e 93 a7 f0 00 00 18 00
[ 1718.658981] end_request: I/O error, dev sda, sector 244557808
[ 1718.659093] sd 0:0:0:0: [sda] Unhandled error code
[ 1718.659095] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1718.659098] sd 0:0:0:0: [sda] CDB: Read(10): 28 00 0e 93 a7 f0 00 00 08 00
[ 1718.659104] end_request: I/O error, dev sda, sector 244557808
[ 1719.355255] sd 0:0:0:0: [sda] Unhandled error code
[ 1719.355260] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1719.355264] sd 0:0:0:0: [sda] CDB: Read(10): 28 00 0e ba dd 88 00 00 20 00
[ 1719.355271] end_request: I/O error, dev sda, sector 247127432
[ 1719.355383] sd 0:0:0:0: [sda] Unhandled error code
[ 1719.355385] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1719.355388] sd 0:0:0:0: [sda] CDB: Read(10): 28 00 0e ba dd 88 00 00 08 00
[ 1719.355394] end_request: I/O error, dev sda, sector 247127432
[ 1719.423422] cfg80211: Calling CRDA to update world regulatory domain
[ 1719.426916] cfg80211: World regulatory domain updated:
[ 1719.426920]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1719.426923]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1719.426926]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 1719.426928]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 1719.426930]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1719.426933]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1719.479185] ath9k 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 1719.479197] ath9k 0000:02:00.0: setting latency timer to 64
[ 1719.528947] ath: EEPROM regdomain: 0x65
[ 1719.528949] ath: EEPROM indicates we should expect a direct regpair map
[ 1719.528954] ath: Country alpha2 being used: 00
[ 1719.528956] ath: Regpair used: 0x65
[ 1719.539692] phy0: Selected rate control algorithm 'ath9k_rate_control'
[ 1719.541318] Registered led device: ath9k-phy0::radio
[ 1719.541603] Registered led device: ath9k-phy0::assoc
[ 1719.541767] Registered led device: ath9k-phy0::tx
[ 1719.541904] Registered led device: ath9k-phy0::rx
[ 1719.541912] phy0: Atheros AR9285 Rev:2 mem=0xffffc90001600000, irq=16
[ 1719.570081] sd 0:0:0:0: [sda] Unhandled error code
[ 1719.570086] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1719.570090] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 0f 17 cb 98 00 00 08 00
[ 1719.570098] end_request: I/O error, dev sda, sector 253217688
[ 1719.570151] Buffer I/O error on device dm-1, logical block 1656130
[ 1719.570192] lost page write due to I/O error on dm-1
[ 1719.570416] sd 0:0:0:0: [sda] Unhandled error code
[ 1719.570421] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1719.570425] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 0f 4c 25 a8 00 00 08 00
[ 1719.570432] end_request: I/O error, dev sda, sector 256648616
[ 1719.570518] Buffer I/O error on device dm-1, logical block 2084996
[ 1719.570560] lost page write due to I/O error on dm-1
[ 1719.570572] sd 0:0:0:0: [sda] Unhandled error code
[ 1719.570573] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1719.570576] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 0e 82 f4 10 00 00 08 00
[ 1719.570582] end_request: I/O error, dev sda, sector 243463184
[ 1719.570625] Buffer I/O error on device dm-1, logical block 436817
[ 1719.570667] lost page write due to I/O error on dm-1
[ 1719.571509] sd 0:0:0:0: [sda] Unhandled error code
[ 1719.571511] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1719.571514] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 0f 49 a5 18 00 00 08 00
[ 1719.571521] end_request: I/O error, dev sda, sector 256484632
[ 1719.571604] Buffer I/O error on device dm-1, logical block 2064498
[ 1719.571646] lost page write due to I/O error on dm-1
[ 1719.571658] sd 0:0:0:0: [sda] Unhandled error code
[ 1719.571659] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1719.571662] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 0f 4a 70 78 00 00 08 00
[ 1719.571668] end_request: I/O error, dev sda, sector 256536696
[ 1719.571713] Buffer I/O error on device dm-1, logical block 2071006
[ 1719.571755] lost page write due to I/O error on dm-1
[ 1719.571760] sd 0:0:0:0: [sda] Unhandled error code
[ 1719.571762] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1719.571764] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 0f 61 cc f0 00 00 08 00
[ 1719.571770] end_request: I/O error, dev sda, sector 258067696
[ 1719.571815] Buffer I/O error on device dm-1, logical block 2262381
[ 1719.571856] lost page write due to I/O error on dm-1
[ 1719.571864] sd 0:0:0:0: [sda] Unhandled error code
[ 1719.571866] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1719.571868] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 0e 57 0a f0 00 00 08 00
[ 1719.571874] end_request: I/O error, dev sda, sector 240585456
[ 1719.571918] Buffer I/O error on device dm-1, logical block 77101
[ 1719.571960] lost page write due to I/O error on dm-1
[ 1719.571964] JBD2: Detected IO errors while flushing file data on dm-1-8
[ 1719.580169] sd 0:0:0:0: [sda] Unhandled error code
[ 1719.580174] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1719.580178] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 0f 51 e7 88 00 00 b0 00
[ 1719.580186] end_request: I/O error, dev sda, sector 257025928
[ 1719.580798] Aborting journal on device dm-1-8.
[ 1719.580912] EXT4-fs error (device dm-1) in ext4_reserve_inode_write: Journal has aborted
[ 1719.580959] EXT4-fs (dm-1): Remounting filesystem read-only
[ 1719.581004] sd 0:0:0:0: [sda] Unhandled error code
[ 1719.581007] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1719.581010] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 0f 51 a1 88 00 00 08 00
[ 1719.581016] end_request: I/O error, dev sda, sector 257008008
[ 1719.581026] Buffer I/O error on device dm-1, logical block 2129920
[ 1719.581027] lost page write due to I/O error on dm-1
[ 1719.581149] 
[ 1719.581214] sd 0:0:0:0: [sda] Unhandled error code
[ 1719.581217] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1719.581220] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 0e 4d a1 88 00 00 08 00
[ 1719.581227] end_request: I/O error, dev sda, sector 239968648
[ 1719.581254] JBD2: I/O error detected when updating journal superblock for dm-1-8.
[ 1719.581268] journal commit I/O error
[ 1719.581391] Buffer I/O error on device dm-1, logical block 0
[ 1719.581433] lost page write due to I/O error on dm-1
[ 1719.647005] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1719.682598] sd 0:0:0:0: [sda] Unhandled error code
[ 1719.682603] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1719.682607] sd 0:0:0:0: [sda] CDB: Read(10): 28 00 0e b9 63 a8 00 00 40 00
[ 1719.682615] end_request: I/O error, dev sda, sector 247030696
[ 1719.682786] sd 0:0:0:0: [sda] Unhandled error code
[ 1719.682788] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 1719.682791] sd 0:0:0:0: [sda] CDB: Read(10): 28 00 0e b9 63 b8 00 00 08 00
[ 1719.682797] end_request: I/O error, dev sda, sector 247030712

--Boundary-00=_sU0NMi4E3Tv9U0k
Content-Type: text/plain; charset="UTF-8"; name="lspci-vv"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="lspci-vv"

00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge Alternate
	Subsystem: Samsung Electronics Co Ltd Device c553
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [c4] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=12 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn+ LSEn+ ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency 0: 1.6GHz
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [54] HyperTransport: UnitID Clumping
	Capabilities: [40] HyperTransport: Retry Mode
	Capabilities: [9c] HyperTransport: #1a
	Capabilities: [f8] HyperTransport: #1c

00:02.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (ext gfx port 0)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: cfe00000-cfefffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep+ BwNot+
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  2, PowerLimit 75.000000; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4151
	Capabilities: [b0] Subsystem: Samsung Electronics Co Ltd Device c553
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Vendor Specific Information <?>
	Capabilities: [110] Virtual Channel <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:04.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 0)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	Memory behind bridge: f0200000-f02fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep+ BwNot+
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  4, PowerLimit 25.000000; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4159
	Capabilities: [b0] Subsystem: Samsung Electronics Co Ltd Device c553
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Vendor Specific Information <?>
	Capabilities: [110] Virtual Channel <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:05.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 1)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: c8000000-c81fffff
	Prefetchable memory behind bridge: 00000000c8200000-00000000c83fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #247, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  5, PowerLimit 25.000000; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4161
	Capabilities: [b0] Subsystem: Samsung Electronics Co Ltd Device c553
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Vendor Specific Information <?>
	Capabilities: [110] Virtual Channel <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:06.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 2)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: f0300000-f03fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep+ BwNot+
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  6, PowerLimit 25.000000; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4169
	Capabilities: [b0] Subsystem: Samsung Electronics Co Ltd Device c553
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Vendor Specific Information <?>
	Capabilities: [110] Virtual Channel <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode] (prog-if 01)
	Subsystem: Samsung Electronics Co Ltd Device c553
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 22
	Region 0: I/O ports at 8420 [size=8]
	Region 1: I/O ports at 8414 [size=4]
	Region 2: I/O ports at 8418 [size=8]
	Region 3: I/O ports at 8410 [size=4]
	Region 4: I/O ports at 8400 [size=16]
	Region 5: Memory at f0409000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] SATA HBA <?>
	Kernel driver in use: ahci
	Kernel modules: ahci

00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller (prog-if 10)
	Subsystem: Samsung Electronics Co Ltd Device c553
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f0404000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller (prog-if 10)
	Subsystem: Samsung Electronics Co Ltd Device c553
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f0405000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller (prog-if 20)
	Subsystem: Samsung Electronics Co Ltd Device c553
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at f0409400 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd

00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller (prog-if 10)
	Subsystem: Samsung Electronics Co Ltd Device c553
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at f0406000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller (prog-if 10)
	Subsystem: Samsung Electronics Co Ltd Device c553
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at f0407000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller (prog-if 20)
	Subsystem: Samsung Electronics Co Ltd Device c553
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 19
	Region 0: Memory at f0409800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd

00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3c)
	Subsystem: Samsung Electronics Co Ltd Device c553
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel modules: i2c-piix4

00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
	Subsystem: Samsung Electronics Co Ltd Device c553
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin ? routed to IRQ 16
	Region 0: Memory at f0400000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
	Subsystem: Samsung Electronics Co Ltd Device c553
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (prog-if 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=64
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Controller (prog-if 10)
	Subsystem: Samsung Electronics Co Ltd Device c553
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at f0408000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:18.0 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] HyperTransport Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn+ LSEn+ ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency: 1.6GHz
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Kernel modules: amd64_edac_mod

00:18.3 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k10temp
	Kernel modules: k10temp

00:18.4 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Link Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

01:00.0 VGA compatible controller: ATI Technologies Inc Manhattan [Mobility Radeon HD 5000 Series]
	Subsystem: Samsung Electronics Co Ltd Device c553
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 2: Memory at cfee0000 (64-bit, non-prefetchable) [size=128K]
	Region 4: I/O ports at 9000 [size=256]
	[virtual] Expansion ROM at cfe00000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [100] Vendor Specific Information <?>
	Kernel modules: radeon

01:00.1 Audio device: ATI Technologies Inc Manhattan HDMI Audio [Mobility Radeon HD 5000 Series]
	Subsystem: Samsung Electronics Co Ltd Device c553
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 45
	Region 0: Memory at cfedc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0300c  Data: 4189
	Capabilities: [100] Vendor Specific Information <?>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

02:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
	Subsystem: Foxconn International, Inc. Device e025
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f0200000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [60] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Virtual Channel <?>
	Capabilities: [160] Device Serial Number 12-14-24-ff-ff-17-15-00
	Capabilities: [170] Power Budgeting <?>
	Kernel driver in use: ath9k
	Kernel modules: ath9k

04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8040 PCI-E Fast Ethernet Controller
	Subsystem: Samsung Electronics Co Ltd Device c553
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 44
	Region 0: Memory at f0300000 (64-bit, non-prefetchable) [size=16K]
	Region 2: I/O ports at a000 [size=256]
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0300c  Data: 4179
	Capabilities: [c0] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 unlimited
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [130] Device Serial Number 00-24-54-ff-ff-6e-90-bf
	Kernel driver in use: sky2
	Kernel modules: sky2


--Boundary-00=_sU0NMi4E3Tv9U0k
Content-Type: text/plain; charset="UTF-8"; name="smartctl-a"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="smartctl-a"

smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     SAMSUNG HM321HI
Serial Number:    S26VJ9FZ400577
Firmware Version: 2AJ10001
User Capacity:    320.072.933.376 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Not recognized. Minor revision code: 0x28
Local Time is:    Fri Jul  9 17:48:10 2010 CEST

==> WARNING: May need -F samsung or -F samsung2 enabled; see manual for details.

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00)	Offline data collection activity
					was never started.
					Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		 (4800) seconds.
Offline data collection
capabilities: 			 (0x5b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 (  80) minutes.
SCT capabilities: 	       (0x003f)	SCT Status supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   100   100   051    Pre-fail  Always       -       0
  2 Throughput_Performance  0x0026   252   252   000    Old_age   Always       -       0
  3 Spin_Up_Time            0x0023   094   071   025    Pre-fail  Always       -       2118
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       147
  5 Reallocated_Sector_Ct   0x0033   252   252   010    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x002e   252   252   051    Old_age   Always       -       0
  8 Seek_Time_Performance   0x0024   252   252   015    Old_age   Offline      -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       183
 10 Spin_Retry_Count        0x0032   252   252   051    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age   Always       -       12
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       148
191 G-Sense_Error_Rate      0x0022   100   100   000    Old_age   Always       -       333
192 Power-Off_Retract_Count 0x0022   252   252   000    Old_age   Always       -       0
194 Temperature_Celsius     0x0002   064   058   000    Old_age   Always       -       36 (Lifetime Min/Max 17/45)
195 Hardware_ECC_Recovered  0x003a   100   100   000    Old_age   Always       -       0
196 Reallocated_Event_Count 0x0032   252   252   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   252   252   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   252   252   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0036   100   100   000    Old_age   Always       -       3
200 Multi_Zone_Error_Rate   0x002a   100   100   000    Old_age   Always       -       8
223 Load_Retry_Count        0x0032   100   100   000    Old_age   Always       -       12
225 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       3995

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%       180         -

SMART Selective Self-Test Log Data Structure Revision Number (0) should be 1
SMART Selective self-test log data structure revision number 0
Warning: ATA Specification requires selective self-test log data structure revision number = 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Completed [00% left] (0-65535)
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.


--Boundary-00=_sU0NMi4E3Tv9U0k--
