Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab0F0UYD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 16:24:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61153 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab0F0UX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 16:23:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=Az6nvl1Huk/aUj5feWF9ELhz5ocqvAYxDFHRjZT4WTh+BT/3iU6uMiF8rOX2D9IiqD
         tSEKG/WvxcGUW9pDGsVVKqj6Qi7N4tWm+xzuFrlibnaqV6fawRF4ZDyel300iAuQV/jM
         cRnQ83kIOStkYRm+nshnqKyaScpx8ljvW8wJs=
Date: Sun, 27 Jun 2010 23:23:47 +0300
From: =?UTF-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>
To: linux-ide@vger.kernel.org
Cc: <linux-kernel@vger.kernel.org>
Subject: hald-addon-storage causing ata soft resets on CDROM drive?
Message-ID: <20100627232347.2f1dc4fd@debian>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Using 2.6.35-rc3 I noticed this in my dmesg (see end of email for full dmesg output)
[28144.351747] ata9: drained 65536 bytes to clear DRQ.
[28144.460834] ata9.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[28144.460838] sr 8:0:1:0: CDB: Prevent/Allow Medium Removal: 1e 00 00
00 00 00 [28144.460846] ata9.01: cmd
a0/00:00:00:00:00/00:00:00:00:00/b0 tag 0 [28144.460846]          res
7f/7f:7f:7f:7f:7f/00:00:00:00:00/7f Emask 0x3 (HSM violation)
[28144.460849] ata9.01: status: { DRDY DF DRQ ERR } [28144.460867]
ata9: soft resetting link
....
[32977.433092] ata9: EH complete

ata9 is one my CDROM drives:
[    0.589989] scsi9 : pata_jmicron
[    0.590574] ata9: PATA max UDMA/100 cmd 0xb000 ctl 0xb100 bmdma
0xb400 irq 19
....
[    0.753081] ata9.00: ATAPI: ASUS    CRW-5232AS, 1.01, max UDMA/33
[    0.753109] ata9.01: ATAPI: SAMSUNG CD-ROM  SH-152A, C503, max UDMA/33
[    0.760661] ata9.00: configured for UDMA/33
[    0.776533] ata9.01: configured for UDMA/33

I certainly haven't touched the CDROM drive today so this looked
suspicious. Apparently hald-addon-storage is causing this:
[32880.588540] INFO: task hald-addon-stor:6113 blocked for more than 120 seconds.
[32880.588543] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[32880.588546] hald-addon-st D 0000000000000002     0  6113   5949 0x00000080
[32880.588551]  ffff880122a21af8 0000000000000086 0000000000013d00 0000000000000000
[32880.588555]  ffff880122a21fd8 ffff880122b161c0 ffff880122a21fd8 ffff880122a20000
[32880.588559]  ffff880122a20000 ffff880122a21fd8 ffff880122a20000 ffff880122a21fd8
[32880.588563] Call Trace:
[32880.588570]  [<ffffffff812d2715>] scsi_block_when_processing_errors+0x91/0xc2
[32880.588575]  [<ffffffff810539c5>] ? autoremove_wake_function+0x0/0x34
[32880.588579]  [<ffffffff812303a7>] ? get_disk+0xd9/0xfd
[32880.588593]  [<ffffffffa0096301>] sr_open+0x11/0x1b [sr_mod]
[32880.588599]  [<ffffffffa0089086>] cdrom_open+0x4d/0x46b [cdrom]
[32880.588603]  [<ffffffff812bed32>] ? kobj_lookup+0x1c0/0x1fb
[32880.588607]  [<ffffffff8123b3dc>] ? kobject_get+0x1a/0x22
[32880.588616]  [<ffffffffa009649b>] sr_block_open+0x8b/0xa8 [sr_mod]
[32880.588619]  [<ffffffff812b956b>] ? get_device+0x14/0x1a
[32880.588623]  [<ffffffff8110c0a4>] __blkdev_get+0xda/0x391
[32880.588625]  [<ffffffff8110c366>] blkdev_get+0xb/0xd
[32880.588628]  [<ffffffff8110c40f>] blkdev_open+0xa7/0xe6
[32880.588630]  [<ffffffff8110c368>] ? blkdev_open+0x0/0xe6
[32880.588633]  [<ffffffff810e2f42>] __dentry_open+0x1ce/0x2fd
[32880.588635]  [<ffffffff810e3136>] nameidata_to_filp+0x3a/0x4b
[32880.588638]  [<ffffffff810eea66>] do_last+0x4e5/0x64b
[32880.588640]  [<ffffffff810f082b>] do_filp_open+0x202/0x641
[32880.588642]  [<ffffffff8123b2b3>] ? kobject_put+0x47/0x4b
[32880.588645]  [<ffffffff810f96c8>] ? alloc_fd+0x111/0x123
[32880.588647]  [<ffffffff810e2c8b>] do_sys_open+0x5e/0x10a
[32880.588649]  [<ffffffff810e2d60>] sys_open+0x1b/0x1d
[32880.588652]  [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b

Googling showed me some issues with dieing hard drives (not the case here), and some issues with CDROM drives,
but for old kernels (2.6.20 or so). So I thought to report this here.

Is there anything I should do next time I see this in my dmesg?

I don't have a way to reproduce this (other than waiting for it to happen again), apparently the system just finished running the hourly cronjob when this happened first time so it was mostly idle:
Jun 27 18:17:01 debian /USR/SBIN/CRON[27750]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Jun 27 18:19:45 debian kernel: [28144.351747] ata9: drained 65536 bytes to clear DRQ.
Jun 27 18:19:45 debian kernel: [28144.460834] ata9.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
...

And finished another cronjob when it happened again:
Jun 27 19:17:01 debian /USR/SBIN/CRON[29767]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Jun 27 19:25:01 debian /USR/SBIN/CRON[29868]: (root) CMD (command -v debian-sa1 > /dev/null && debian-sa1 1 1)
Jun 27 19:31:15 debian smartd[6274]: Device: /dev/sdc [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 114 to 115
Jun 27 19:31:51 debian kernel: [32470.355768] ata9: drained 65536 bytes to clear DRQ.
Jun 27 19:31:51 debian kernel: [32470.464499] ata9.01: exception Emask
0x0 SAct 0x0 SErr 0x0 action 0x6

Actually this happened 5 times already, I don't know exactly what triggered/triggers it (but looks like something to do with hal):
[28144.351747] ata9: drained 65536 bytes to clear DRQ.
[28200.351742] ata9: drained 65536 bytes to clear DRQ.
[28226.352017] ata9: drained 65536 bytes to clear DRQ.
[32470.355768] ata9: drained 65536 bytes to clear DRQ.
[32709.352741] ata9: drained 65536 bytes to clear DRQ.

My full dmesg is below:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-rc3-00001-ga5d1880 (edwin@debian) (gcc version 4.4.4 (Debian 4.4.4-5) ) #80 SMP PREEMPT Thu Jun 24 20:47:24 EEST 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-rc3-00001-ga5d1880 root=UUID=ed5c3d95-ed38-4262-b051-a8079f07ad8b ro quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfee0000 - 00000000cfee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfee3000 - 00000000cfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000e4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x400000000
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
[    0.000000]   3 base 100000000 mask FC0000000 write-back
[    0.000000]   4 base 130000000 mask FF0000000 uncachable
[    0.000000]   5 base 0CFF00000 mask FFFF00000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000cff00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcfee0 max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009d400 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000cfee0000 (usable)
[    0.000000]  modified: 00000000cfee0000 - 00000000cfee3000 (ACPI NVS)
[    0.000000]  modified: 00000000cfee3000 - 00000000cfef0000 (ACPI data)
[    0.000000]  modified: 00000000cfef0000 - 00000000cff00000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000e4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000cfee0000
[    0.000000]  0000000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cfee0000 page 4k
[    0.000000] kernel direct mapping tables up to cfee0000 @ 16000-1c000
[    0.000000] init_memory_mapping: 0000000100000000-0000000130000000
[    0.000000]  0100000000 - 0130000000 page 2M
[    0.000000] kernel direct mapping tables up to 130000000 @ 1a000-20000
[    0.000000] RAMDISK: 37b37000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f7050 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 00000000cfee3040 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 00000000cfee30c0 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 00000000cfee3180 04C26 (v01 GBT    GBTUACPI 00001000 MSFT 0100000C)
[    0.000000] ACPI: FACS 00000000cfee0000 00040
[    0.000000] ACPI: HPET 00000000cfee7f00 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 00000000cfee7f80 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: APIC 00000000cfee7e00 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: SSDT 00000000cfee88e0 003AB (v01  PmRef    CpuPm 00003000 INTL 20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00043fffff] PMD -> [ffff880006600000-ffff880009ffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000cfee0
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1048173
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3925 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833304 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
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
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [1b000 - 1b7ff]
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cfee0000 - 00000000cfee3000
[    0.000000] PM: Registered nosave memory: 00000000cfee3000 - 00000000cfef0000
[    0.000000] PM: Registered nosave memory: 00000000cfef0000 - 00000000cff00000
[    0.000000] PM: Registered nosave memory: 00000000cff00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000e4000000
[    0.000000] PM: Registered nosave memory: 00000000e4000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e4000000 (gap: e4000000:1ac00000)
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880005e00000 s84160 r8192 d22336 u524288
[    0.000000] pcpu-alloc: s84160 r8192 d22336 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1031149
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-rc3-00001-ga5d1880 root=UUID=ed5c3d95-ed38-4262-b051-a8079f07ad8b ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] early_res array is doubled to 128 at [23800 - 247ff]
[    0.000000] Subtract (57 early reservations)
[    0.000000]   #1 [0001000000 - 0005cd12a8]   TEXT DATA BSS
[    0.000000]   #2 [0037b37000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [000009d400 - 0000100000]   BIOS reserved
[    0.000000]   #4 [0005cd2000 - 0005cd20f6]             BRK
[    0.000000]   #5 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #6 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #7 [0000016000 - 000001a000]         PGTABLE
[    0.000000]   #8 [000001a000 - 000001b000]         PGTABLE
[    0.000000]   #9 [0005cd2100 - 0005cd3100]         BOOTMEM
[    0.000000]   #10 [0005cd12c0 - 0005cd15c0]         BOOTMEM
[    0.000000]   #11 [00064d4000 - 00064d5000]         BOOTMEM
[    0.000000]   #12 [00064d5000 - 00064d6000]         BOOTMEM
[    0.000000]   #13 [0006600000 - 000a000000]        MEMMAP 0
[    0.000000]   #14 [0005cd15c0 - 0005cd1740]         BOOTMEM
[    0.000000]   #15 [0005cd3100 - 0005ceb100]         BOOTMEM
[    0.000000]   #16 [0005ceb100 - 0005cf1100]         BOOTMEM
[    0.000000]   #17 [0005cf2000 - 0005cf3000]         BOOTMEM
[    0.000000]   #18 [0005cd1740 - 0005cd1781]         BOOTMEM
[    0.000000]   #19 [0005cd17c0 - 0005cd1803]         BOOTMEM
[    0.000000]   #20 [0005cd1840 - 0005cd1aa8]         BOOTMEM
[    0.000000]   #21 [0005cd1ac0 - 0005cd1b28]         BOOTMEM
[    0.000000]   #22 [0005cd1b40 - 0005cd1ba8]         BOOTMEM
[    0.000000]   #23 [0005cd1bc0 - 0005cd1c28]         BOOTMEM
[    0.000000]   #24 [0005cd1c40 - 0005cd1ca8]         BOOTMEM
[    0.000000]   #25 [0005cd1cc0 - 0005cd1d28]         BOOTMEM
[    0.000000]   #26 [0005cd1d40 - 0005cd1da8]         BOOTMEM
[    0.000000]   #27 [0005cd1dc0 - 0005cd1e28]         BOOTMEM
[    0.000000]   #28 [0005cd1e40 - 0005cd1ea8]         BOOTMEM
[    0.000000]   #29 [0005cd1ec0 - 0005cd1f28]         BOOTMEM
[    0.000000]   #30 [0005cd1f40 - 0005cd1fa8]         BOOTMEM
[    0.000000]   #31 [0005cd1fc0 - 0005cd1fe0]         BOOTMEM
[    0.000000]   #32 [0005cf1100 - 0005cf1120]         BOOTMEM
[    0.000000]   #33 [0005cf1140 - 0005cf11ab]         BOOTMEM
[    0.000000]   #34 [0005cf11c0 - 0005cf122b]         BOOTMEM
[    0.000000]   #35 [0005e00000 - 0005e1c000]         BOOTMEM
[    0.000000]   #36 [0005e80000 - 0005e9c000]         BOOTMEM
[    0.000000]   #37 [0005f00000 - 0005f1c000]         BOOTMEM
[    0.000000]   #38 [0005f80000 - 0005f9c000]         BOOTMEM
[    0.000000]   #39 [0005cf1240 - 0005cf1248]         BOOTMEM
[    0.000000]   #40 [0005cf1280 - 0005cf1288]         BOOTMEM
[    0.000000]   #41 [0005cf12c0 - 0005cf12d0]         BOOTMEM
[    0.000000]   #42 [0005cf1300 - 0005cf1320]         BOOTMEM
[    0.000000]   #43 [0005cf1340 - 0005cf1470]         BOOTMEM
[    0.000000]   #44 [0005cf1480 - 0005cf14d0]         BOOTMEM
[    0.000000]   #45 [0005cf1500 - 0005cf1550]         BOOTMEM
[    0.000000]   #46 [0005cf1580 - 0005cf1780]         BOOTMEM
[    0.000000]   #47 [0005cf1780 - 0005cf1980]         BOOTMEM
[    0.000000]   #48 [0005cf1980 - 0005cf1b80]         BOOTMEM
[    0.000000]   #49 [0005cf1b80 - 0005cf1d80]         BOOTMEM
[    0.000000]   #50 [0005cf3000 - 0005cfb000]         BOOTMEM
[    0.000000]   #51 [0005f9c000 - 000639c000]         BOOTMEM
[    0.000000]   #52 [000a000000 - 000a200000]         BOOTMEM
[    0.000000]   #53 [000a200000 - 000e200000]         BOOTMEM
[    0.000000]   #54 [0005cfb000 - 0005d1b000]         BOOTMEM
[    0.000000]   #55 [0005d1b000 - 0005d5b000]         BOOTMEM
[    0.000000]   #56 [000001b800 - 0000023800]         BOOTMEM
[    0.000000] Memory: 3977036k/4980736k available (3925k kernel code, 788044k absent, 215656k reserved, 3690k data, 500k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2833.025 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 5666.05 BogoMIPS (lpj=11332100)
[    0.004008] pid_max: default: 32768 minimum: 301
[    0.004025] Security Framework initialized
[    0.004033] Mount-cache hash table entries: 256
[    0.004135] Initializing cgroup subsys ns
[    0.004138] Initializing cgroup subsys cpuacct
[    0.004141] Initializing cgroup subsys devices
[    0.004161] CPU: Physical Processor ID: 0
[    0.004162] CPU: Processor Core ID: 0
[    0.004164] mce: CPU supports 6 MCE banks
[    0.004169] CPU0: Thermal monitoring enabled (TM2)
[    0.004171] using mwait in idle threads.
[    0.004173] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.004178] ... version:                2
[    0.004179] ... bit width:              40
[    0.004180] ... generic registers:      2
[    0.004181] ... value mask:             000000ffffffffff
[    0.004183] ... max period:             000000007fffffff
[    0.004184] ... fixed-purpose events:   3
[    0.004185] ... event mask:             0000000700000003
[    0.004211] ACPI: Core revision 20100428
[    0.012058] Setting APIC routing to flat
[    0.012456] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.052255] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q9550  @ 2.83GHz stepping 07
[    0.072017] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.364006] Brought up 4 CPUs
[    0.364009] Total of 4 processors activated (22663.97 BogoMIPS).
[    0.366073] devtmpfs: initialized
[    0.366073] NET: Registered protocol family 16
[    0.368025] ACPI: bus type pci registered
[    0.368035] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.368035] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
[    0.373062] PCI: Using configuration type 1 for base access
[    0.376042] bio: create slab <bio-0> at 0
[    0.376624] ACPI: EC: Look up EC in DSDT
[    0.383741] ACPI: SSDT 00000000cfee8000 0022A (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
[    0.383916] ACPI: Dynamic OEM Table Load:
[    0.383918] ACPI: SSDT (null) 0022A (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
[    0.384122] ACPI: SSDT 00000000cfee84c0 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20040311)
[    0.384287] ACPI: Dynamic OEM Table Load:
[    0.384289] ACPI: SSDT (null) 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20040311)
[    0.384474] ACPI: SSDT 00000000cfee8620 00152 (v01  PmRef  Cpu2Ist 00003000 INTL 20040311)
[    0.384639] ACPI: Dynamic OEM Table Load:
[    0.384641] ACPI: SSDT (null) 00152 (v01  PmRef  Cpu2Ist 00003000 INTL 20040311)
[    0.384826] ACPI: SSDT 00000000cfee8780 00152 (v01  PmRef  Cpu3Ist 00003000 INTL 20040311)
[    0.384991] ACPI: Dynamic OEM Table Load:
[    0.384993] ACPI: SSDT (null) 00152 (v01  PmRef  Cpu3Ist 00003000 INTL 20040311)
[    0.385029] ACPI: Interpreter enabled
[    0.385031] ACPI: (supports S0 S3 S4 S5)
[    0.385047] ACPI: Using IOAPIC for interrupt routing
[    0.392274] ACPI: No dock devices found.
[    0.392274] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.392274] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
[    0.392274] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.392274] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.392274] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.392274] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.392274] pci_root PNP0A03:00: host bridge window [mem 0xcff00000-0xfebfffff]
[    0.392274] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.392274] pci 0000:00:01.0: PME# disabled
[    0.392274] pci 0000:00:1a.0: reg 20: [io  0xe200-0xe21f]
[    0.392297] pci 0000:00:1a.1: reg 20: [io  0xe000-0xe01f]
[    0.392348] pci 0000:00:1a.2: reg 20: [io  0xe100-0xe11f]
[    0.392391] pci 0000:00:1a.7: reg 10: [mem 0xeb305000-0xeb3053ff]
[    0.392449] pci 0000:00:1b.0: reg 10: [mem 0xeb300000-0xeb303fff 64bit]
[    0.392481] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.392484] pci 0000:00:1b.0: PME# disabled
[    0.392534] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.392537] pci 0000:00:1c.0: PME# disabled
[    0.392589] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.392592] pci 0000:00:1c.2: PME# disabled
[    0.392643] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.392646] pci 0000:00:1c.3: PME# disabled
[    0.392697] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.392700] pci 0000:00:1c.4: PME# disabled
[    0.392751] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.392754] pci 0000:00:1c.5: PME# disabled
[    0.392795] pci 0000:00:1d.0: reg 20: [io  0xe300-0xe31f]
[    0.392846] pci 0000:00:1d.1: reg 20: [io  0xe400-0xe41f]
[    0.392898] pci 0000:00:1d.2: reg 20: [io  0xe500-0xe51f]
[    0.392941] pci 0000:00:1d.7: reg 10: [mem 0xeb304000-0xeb3043ff]
[    0.393102] pci 0000:00:1f.2: reg 10: [io  0xe600-0xe607]
[    0.393106] pci 0000:00:1f.2: reg 14: [io  0xe700-0xe703]
[    0.393111] pci 0000:00:1f.2: reg 18: [io  0xe800-0xe807]
[    0.393115] pci 0000:00:1f.2: reg 1c: [io  0xe900-0xe903]
[    0.393119] pci 0000:00:1f.2: reg 20: [io  0xea00-0xea1f]
[    0.393123] pci 0000:00:1f.2: reg 24: [mem 0xeb306000-0xeb3067ff]
[    0.393148] pci 0000:00:1f.2: PME# supported from D3hot
[    0.393150] pci 0000:00:1f.2: PME# disabled
[    0.393171] pci 0000:00:1f.3: reg 10: [mem 0xeb307000-0xeb3070ff 64bit]
[    0.393181] pci 0000:00:1f.3: reg 20: [io  0x0500-0x051f]
[    0.393229] pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.393236] pci 0000:01:00.0: reg 18: [mem 0xe5000000-0xe500ffff 64bit]
[    0.393240] pci 0000:01:00.0: reg 20: [io  0x9000-0x90ff]
[    0.393247] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.393261] pci 0000:01:00.0: supports D1 D2
[    0.393283] pci 0000:01:00.1: reg 10: [mem 0xe5010000-0xe5013fff 64bit]
[    0.393311] pci 0000:01:00.1: supports D1 D2
[    0.393322] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.393325] pci 0000:00:01.0:   bridge window [io  0x9000-0x9fff]
[    0.393327] pci 0000:00:01.0:   bridge window [mem 0xe4000000-0xe5ffffff]
[    0.393330] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.393361] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.393365] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.393368] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.393372] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.393439] pci 0000:03:00.0: reg 10: [mem 0xe7004000-0xe700407f 64bit]
[    0.393453] pci 0000:03:00.0: reg 18: [mem 0xe7000000-0xe7003fff 64bit]
[    0.393461] pci 0000:03:00.0: reg 20: [io  0xa000-0xa07f]
[    0.393475] pci 0000:03:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    0.393511] pci 0000:03:00.0: supports D1 D2
[    0.393529] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.393532] pci 0000:00:1c.2:   bridge window [io  0xa000-0xafff]
[    0.393535] pci 0000:00:1c.2:   bridge window [mem 0xe6000000-0xe7ffffff]
[    0.393539] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.393605] pci 0000:04:00.0: reg 10: [io  0xb000-0xb007]
[    0.393613] pci 0000:04:00.0: reg 14: [io  0xb100-0xb103]
[    0.393620] pci 0000:04:00.0: reg 18: [io  0xb200-0xb207]
[    0.393628] pci 0000:04:00.0: reg 1c: [io  0xb300-0xb303]
[    0.393636] pci 0000:04:00.0: reg 20: [io  0xb400-0xb40f]
[    0.393689] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.393692] pci 0000:00:1c.3:   bridge window [io  0xb000-0xbfff]
[    0.393695] pci 0000:00:1c.3:   bridge window [mem 0xe8000000-0xe8ffffff]
[    0.393700] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.396010] pci 0000:05:00.0: reg 10: [io  0xc000-0xc0ff]
[    0.396027] pci 0000:05:00.0: reg 18: [mem 0xeb010000-0xeb010fff 64bit pref]
[    0.396039] pci 0000:05:00.0: reg 20: [mem 0xeb000000-0xeb00ffff 64bit pref]
[    0.396045] pci 0000:05:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.396080] pci 0000:05:00.0: supports D1 D2
[    0.396082] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.396086] pci 0000:05:00.0: PME# disabled
[    0.396109] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
[    0.396117] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.396125] pci 0000:00:1c.4:   bridge window [mem 0xe9000000-0xe9ffffff]
[    0.396130] pci 0000:00:1c.4:   bridge window [mem 0xeb000000-0xeb0fffff 64bit pref]
[    0.396188] pci 0000:06:00.0: reg 10: [io  0xd000-0xd0ff]
[    0.396206] pci 0000:06:00.0: reg 18: [mem 0xeb110000-0xeb110fff 64bit pref]
[    0.396218] pci 0000:06:00.0: reg 20: [mem 0xeb100000-0xeb10ffff 64bit pref]
[    0.396225] pci 0000:06:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.396261] pci 0000:06:00.0: supports D1 D2
[    0.396262] pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.396266] pci 0000:06:00.0: PME# disabled
[    0.396289] pci 0000:00:1c.5: PCI bridge to [bus 06-06]
[    0.396292] pci 0000:00:1c.5:   bridge window [io  0xd000-0xdfff]
[    0.396295] pci 0000:00:1c.5:   bridge window [mem 0xea000000-0xeaffffff]
[    0.396299] pci 0000:00:1c.5:   bridge window [mem 0xeb100000-0xeb1fffff 64bit pref]
[    0.396342] pci 0000:07:07.0: reg 10: [mem 0xeb204000-0xeb2047ff]
[    0.396348] pci 0000:07:07.0: reg 14: [mem 0xeb200000-0xeb203fff]
[    0.396384] pci 0000:07:07.0: supports D1 D2
[    0.396385] pci 0000:07:07.0: PME# supported from D0 D1 D2 D3hot
[    0.396388] pci 0000:07:07.0: PME# disabled
[    0.396419] pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive decode)
[    0.396422] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.396425] pci 0000:00:1e.0:   bridge window [mem 0xeb200000-0xeb2fffff]
[    0.396429] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.396431] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.396433] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.396435] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.396437] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.396439] pci 0000:00:1e.0:   bridge window [mem 0xcff00000-0xfebfffff] (subtractive decode)
[    0.396461] pci_bus 0000:00: on NUMA node 0
[    0.396464] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.396573] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.396614] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.396653] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.396701] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.396740] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
[    0.396780] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.412104] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
[    0.412135] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.412207] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.412278] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 *15)
[    0.412348] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.412420] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
[    0.412490] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 9 10 11 12 *14 15)
[    0.412561] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.412601] HEST: Table is not found!
[    0.412601] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.412601] vgaarb: loaded
[    0.412601] SCSI subsystem initialized
[    0.412601] libata version 3.00 loaded.
[    0.412601] PCI: Using ACPI for IRQ routing
[    0.412601] PCI: pci_cache_line_size set to 64 bytes
[    0.412601] reserve RAM buffer: 000000000009d400 - 000000000009ffff 
[    0.412601] reserve RAM buffer: 00000000cfee0000 - 00000000cfffffff 
[    0.412601] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.412601] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.412601] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.424020] Switching to clocksource tsc
[    0.431967] pnp: PnP ACPI init
[    0.431982] ACPI: bus type pnp registered
[    0.434900] pnp: PnP ACPI: found 15 devices
[    0.434902] ACPI: ACPI bus type pnp unregistered
[    0.434912] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.434914] system 00:01: [io  0x0290-0x029f] has been reserved
[    0.434916] system 00:01: [io  0x0800-0x087f] has been reserved
[    0.434918] system 00:01: [io  0x0290-0x0294] has been reserved
[    0.434920] system 00:01: [io  0x0880-0x088f] has been reserved
[    0.434925] system 00:0b: [io  0x0400-0x04bf] has been reserved
[    0.434929] system 00:0c: [mem 0xe0000000-0xe3ffffff] has been reserved
[    0.434933] system 00:0d: [mem 0x000d2000-0x000d3fff] has been reserved
[    0.434935] system 00:0d: [mem 0x000f0000-0x000f7fff] could not be reserved
[    0.434937] system 00:0d: [mem 0x000f8000-0x000fbfff] could not be reserved
[    0.434939] system 00:0d: [mem 0x000fc000-0x000fffff] could not be reserved
[    0.434941] system 00:0d: [mem 0xcfee0000-0xcfefffff] could not be reserved
[    0.434943] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.434945] system 00:0d: [mem 0x00100000-0xcfedffff] could not be reserved
[    0.434947] system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.434950] system 00:0d: [mem 0xfed10000-0xfed1dfff] has been reserved
[    0.434952] system 00:0d: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.434954] system 00:0d: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.434956] system 00:0d: [mem 0xffb00000-0xffb7ffff] has been reserved
[    0.434958] system 00:0d: [mem 0xfff00000-0xffffffff] has been reserved
[    0.434960] system 00:0d: [mem 0x000e0000-0x000effff] has been reserved
[    0.440081] pci 0000:00:1c.0: BAR 14: assigned [mem 0xeb400000-0xeb5fffff]
[    0.440084] pci 0000:00:1c.0: BAR 15: assigned [mem 0xeb600000-0xeb7fffff 64bit pref]
[    0.440087] pci 0000:00:1c.2: BAR 15: assigned [mem 0xeb800000-0xeb9fffff pref]
[    0.440090] pci 0000:00:1c.3: BAR 15: assigned [mem 0xeba00000-0xebbfffff 64bit pref]
[    0.440092] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.440095] pci 0000:01:00.0: BAR 6: assigned [mem 0xe4000000-0xe401ffff pref]
[    0.440097] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.440099] pci 0000:00:01.0:   bridge window [io  0x9000-0x9fff]
[    0.440102] pci 0000:00:01.0:   bridge window [mem 0xe4000000-0xe5ffffff]
[    0.440104] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.440107] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.440110] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.440113] pci 0000:00:1c.0:   bridge window [mem 0xeb400000-0xeb5fffff]
[    0.440116] pci 0000:00:1c.0:   bridge window [mem 0xeb600000-0xeb7fffff 64bit pref]
[    0.440121] pci 0000:03:00.0: BAR 6: assigned [mem 0xeb800000-0xeb87ffff pref]
[    0.440123] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.440125] pci 0000:00:1c.2:   bridge window [io  0xa000-0xafff]
[    0.440129] pci 0000:00:1c.2:   bridge window [mem 0xe6000000-0xe7ffffff]
[    0.440132] pci 0000:00:1c.2:   bridge window [mem 0xeb800000-0xeb9fffff pref]
[    0.440137] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.440139] pci 0000:00:1c.3:   bridge window [io  0xb000-0xbfff]
[    0.440143] pci 0000:00:1c.3:   bridge window [mem 0xe8000000-0xe8ffffff]
[    0.440146] pci 0000:00:1c.3:   bridge window [mem 0xeba00000-0xebbfffff 64bit pref]
[    0.440151] pci 0000:05:00.0: BAR 6: assigned [mem 0xeb020000-0xeb02ffff pref]
[    0.440153] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
[    0.440155] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.440158] pci 0000:00:1c.4:   bridge window [mem 0xe9000000-0xe9ffffff]
[    0.440162] pci 0000:00:1c.4:   bridge window [mem 0xeb000000-0xeb0fffff 64bit pref]
[    0.440167] pci 0000:06:00.0: BAR 6: assigned [mem 0xeb120000-0xeb12ffff pref]
[    0.440168] pci 0000:00:1c.5: PCI bridge to [bus 06-06]
[    0.440171] pci 0000:00:1c.5:   bridge window [io  0xd000-0xdfff]
[    0.440174] pci 0000:00:1c.5:   bridge window [mem 0xea000000-0xeaffffff]
[    0.440177] pci 0000:00:1c.5:   bridge window [mem 0xeb100000-0xeb1fffff 64bit pref]
[    0.440182] pci 0000:00:1e.0: PCI bridge to [bus 07-07]
[    0.440183] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.440187] pci 0000:00:1e.0:   bridge window [mem 0xeb200000-0xeb2fffff]
[    0.440190] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.440200] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.440203] pci 0000:00:01.0: setting latency timer to 64
[    0.440210] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.440213] pci 0000:00:1c.0: setting latency timer to 64
[    0.440220] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.440223] pci 0000:00:1c.2: setting latency timer to 64
[    0.440230] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.440233] pci 0000:00:1c.3: setting latency timer to 64
[    0.440239] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.440242] pci 0000:00:1c.4: setting latency timer to 64
[    0.440249] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.440251] pci 0000:00:1c.5: setting latency timer to 64
[    0.440256] pci 0000:00:1e.0: setting latency timer to 64
[    0.440259] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.440261] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.440262] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.440264] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.440266] pci_bus 0000:00: resource 8 [mem 0xcff00000-0xfebfffff]
[    0.440267] pci_bus 0000:01: resource 0 [io  0x9000-0x9fff]
[    0.440269] pci_bus 0000:01: resource 1 [mem 0xe4000000-0xe5ffffff]
[    0.440271] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.440272] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.440274] pci_bus 0000:02: resource 1 [mem 0xeb400000-0xeb5fffff]
[    0.440276] pci_bus 0000:02: resource 2 [mem 0xeb600000-0xeb7fffff 64bit pref]
[    0.440277] pci_bus 0000:03: resource 0 [io  0xa000-0xafff]
[    0.440279] pci_bus 0000:03: resource 1 [mem 0xe6000000-0xe7ffffff]
[    0.440280] pci_bus 0000:03: resource 2 [mem 0xeb800000-0xeb9fffff pref]
[    0.440282] pci_bus 0000:04: resource 0 [io  0xb000-0xbfff]
[    0.440284] pci_bus 0000:04: resource 1 [mem 0xe8000000-0xe8ffffff]
[    0.440285] pci_bus 0000:04: resource 2 [mem 0xeba00000-0xebbfffff 64bit pref]
[    0.440287] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.440289] pci_bus 0000:05: resource 1 [mem 0xe9000000-0xe9ffffff]
[    0.440290] pci_bus 0000:05: resource 2 [mem 0xeb000000-0xeb0fffff 64bit pref]
[    0.440292] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    0.440294] pci_bus 0000:06: resource 1 [mem 0xea000000-0xeaffffff]
[    0.440295] pci_bus 0000:06: resource 2 [mem 0xeb100000-0xeb1fffff 64bit pref]
[    0.440297] pci_bus 0000:07: resource 1 [mem 0xeb200000-0xeb2fffff]
[    0.440299] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[    0.440300] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[    0.440302] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[    0.440303] pci_bus 0000:07: resource 7 [mem 0x000c0000-0x000dffff]
[    0.440305] pci_bus 0000:07: resource 8 [mem 0xcff00000-0xfebfffff]
[    0.440323] NET: Registered protocol family 2
[    0.440351] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.440610] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.441766] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.442051] TCP: Hash tables configured (established 262144 bind 65536)
[    0.442053] TCP reno registered
[    0.442056] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.442081] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.442169] NET: Registered protocol family 1
[    0.442327] pci 0000:01:00.0: Boot video device
[    0.442342] PCI: CLS 32 bytes, default 64
[    0.442380] Trying to unpack rootfs image as initramfs...
[    0.519245] Freeing initrd memory: 4836k freed
[    0.520366] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.520370] Placing 64MB software IO TLB between ffff88000a200000 - ffff88000e200000
[    0.520371] software IO TLB at phys 0xa200000 - 0xe200000
[    0.521887] Scanning for low memory corruption every 60 seconds
[    0.522198] audit: initializing netlink socket (disabled)
[    0.522208] type=2000 audit(1277623840.516:1): initialized
[    0.537117] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.540313] VFS: Disk quotas dquot_6.5.2
[    0.540392] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.541111] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[    0.542095] SGI XFS Quota Management subsystem
[    0.542101] msgmni has been set to 7777
[    0.542428] alg: No test for stdrng (krng)
[    0.542555] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.542558] io scheduler noop registered
[    0.542559] io scheduler deadline registered
[    0.542627] io scheduler cfq registered (default)
[    0.542736] pcieport 0000:00:01.0: setting latency timer to 64
[    0.542758] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.542882] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.542910] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    0.543095] pcieport 0000:00:1c.2: setting latency timer to 64
[    0.543123] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    0.543303] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.543331] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    0.543513] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.543541] pcieport 0000:00:1c.4: irq 44 for MSI/MSI-X
[    0.543723] pcieport 0000:00:1c.5: setting latency timer to 64
[    0.543750] pcieport 0000:00:1c.5: irq 45 for MSI/MSI-X
[    0.544237] intel_idle: MWAIT substates: 0x20
[    0.544238] intel_idle: does not run on family 6 model 23
[    0.544333] ERST: Table is not found!
[    0.548457] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.548586] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.549070] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.551327] brd: module loaded
[    0.551328] Uniform Multi-Platform E-IDE driver
[    0.551590] ahci 0000:00:1f.2: version 3.0
[    0.551600] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.551639] ahci 0000:00:1f.2: irq 46 for MSI/MSI-X
[    0.551671] ahci: SSS flag set, parallel bus scan disabled
[    0.551700] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.551702] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ccc ems 
[    0.551706] ahci 0000:00:1f.2: setting latency timer to 64
[    0.588091] scsi0 : ahci
[    0.588250] scsi1 : ahci
[    0.588393] scsi2 : ahci
[    0.588537] scsi3 : ahci
[    0.588679] scsi4 : ahci
[    0.588822] scsi5 : ahci
[    0.589013] ata1: SATA max UDMA/133 abar m2048@0xeb306000 port 0xeb306100 irq 46
[    0.589015] ata2: SATA max UDMA/133 abar m2048@0xeb306000 port 0xeb306180 irq 46
[    0.589017] ata3: SATA max UDMA/133 abar m2048@0xeb306000 port 0xeb306200 irq 46
[    0.589019] ata4: SATA max UDMA/133 abar m2048@0xeb306000 port 0xeb306280 irq 46
[    0.589021] ata5: SATA max UDMA/133 abar m2048@0xeb306000 port 0xeb306300 irq 46
[    0.589024] ata6: SATA max UDMA/133 abar m2048@0xeb306000 port 0xeb306380 irq 46
[    0.589106] sata_sil24 0000:03:00.0: version 1.1
[    0.589126] sata_sil24 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.589193] sata_sil24 0000:03:00.0: setting latency timer to 64
[    0.589321] scsi6 : sata_sil24
[    0.589465] scsi7 : sata_sil24
[    0.589574] ata7: SATA max UDMA/100 host m128@0xe7004000 port 0xe7000000 irq 18
[    0.589577] ata8: SATA max UDMA/100 host m128@0xe7004000 port 0xe7002000 irq 18
[    0.589757] pata_jmicron 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.589778] pata_jmicron 0000:04:00.0: setting latency timer to 64
[    0.589848] scsi8 : pata_jmicron
[    0.589989] scsi9 : pata_jmicron
[    0.590574] ata9: PATA max UDMA/100 cmd 0xb000 ctl 0xb100 bmdma 0xb400 irq 19
[    0.590577] ata10: PATA max UDMA/100 cmd 0xb200 ctl 0xb300 bmdma 0xb408 irq 19
[    0.590748] tun: Universal TUN/TAP device driver, 1.6
[    0.590749] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.590820] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.590832] r8169 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.590855] r8169 0000:05:00.0: setting latency timer to 64
[    0.590897] r8169 0000:05:00.0: irq 47 for MSI/MSI-X
[    0.591052] r8169 0000:05:00.0: eth0: RTL8168c/8111c at 0xffffc90000032000, 00:1f:d0:23:89:fc, XID 1c4000c0 IRQ 47
[    0.594301] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.594312] r8169 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.594335] r8169 0000:06:00.0: setting latency timer to 64
[    0.594378] r8169 0000:06:00.0: irq 48 for MSI/MSI-X
[    0.594524] r8169 0000:06:00.0: eth1: RTL8168c/8111c at 0xffffc90000036000, 00:1f:d0:23:89:fe, XID 1c4000c0 IRQ 48
[    0.597940] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.597946] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.598091] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.598273] mice: PS/2 mouse device common for all mice
[    0.598348] rtc_cmos 00:04: RTC can wake from S4
[    0.598415] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    0.598435] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    0.598481] md: linear personality registered for level -1
[    0.598487] md: raid0 personality registered for level 0
[    0.598488] md: raid1 personality registered for level 1
[    0.598490] md: raid10 personality registered for level 10
[    0.598491] md: multipath personality registered for level -4
[    0.598632] device-mapper: uevent: version 1.0.3
[    0.598736] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    0.598863] cpuidle: using governor ladder
[    0.598864] cpuidle: using governor menu
[    0.598957] TCP cubic registered
[    0.598959] NET: Registered protocol family 17
[    0.599147] registered taskstats version 1
[    0.599463] rtc_cmos 00:04: setting system clock to 2010-06-27 07:30:41 UTC (1277623841)
[    0.616433] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.753081] ata9.00: ATAPI: ASUS    CRW-5232AS, 1.01, max UDMA/33
[    0.753109] ata9.01: ATAPI: SAMSUNG CD-ROM  SH-152A, C503, max UDMA/33
[    0.760661] ata9.00: configured for UDMA/33
[    0.776533] ata9.01: configured for UDMA/33
[    1.072011] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.078907] ata1.00: HPA detected: current 1465147055, native 1465149168
[    1.078984] ata1.00: ATA-8: WDC WD7501AALS-00J7B0, 05.00K05, max UDMA/133
[    1.078987] ata1.00: 1465147055 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.080049] ata1.00: configured for UDMA/133
[    1.096120] scsi 0:0:0:0: Direct-Access     ATA      WDC WD7501AALS-0 05.0 PQ: 0 ANSI: 5
[    1.096514] sd 0:0:0:0: [sda] 1465147055 512-byte logical blocks: (750 GB/698 GiB)
[    1.096565] sd 0:0:0:0: [sda] Write Protect is off
[    1.096567] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.096588] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.096706]  sda: sda1 sda2 sda3
[    1.107492] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.984010] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.994957] ata2.00: ATA-8: WDC WD7501AALS-00J7B0, 05.00K05, max UDMA/133
[    1.994960] ata2.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.995998] ata2.00: configured for UDMA/133
[    2.012075] scsi 1:0:0:0: Direct-Access     ATA      WDC WD7501AALS-0 05.0 PQ: 0 ANSI: 5
[    2.012338] sd 1:0:0:0: [sdb] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    2.012384] sd 1:0:0:0: [sdb] Write Protect is off
[    2.012386] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.012404] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.012543]  sdb: sdb1 sdb2 sdb3
[    2.024798] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.668020] ata7: SATA link down (SStatus 0 SControl 0)
[    2.900014] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.909329] ata3.00: ATA-8: WDC WD7501AALS-00J7B0, 05.00K05, max UDMA/133
[    2.909333] ata3.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.910376] ata3.00: configured for UDMA/133
[    2.924103] scsi 2:0:0:0: Direct-Access     ATA      WDC WD7501AALS-0 05.0 PQ: 0 ANSI: 5
[    2.924346] sd 2:0:0:0: [sdc] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    2.924383] sd 2:0:0:0: [sdc] Write Protect is off
[    2.924385] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.924402] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.924523]  sdc: sdc1 sdc2 sdc3
[    2.935659] sd 2:0:0:0: [sdc] Attached SCSI disk
[    3.812013] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.820999] ata4.00: ATA-8: WDC WD7501AALS-00J7B0, 05.00K05, max UDMA/133
[    3.821002] ata4.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    3.822063] ata4.00: configured for UDMA/133
[    3.836083] scsi 3:0:0:0: Direct-Access     ATA      WDC WD7501AALS-0 05.0 PQ: 0 ANSI: 5
[    3.836295] sd 3:0:0:0: [sdd] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    3.836331] sd 3:0:0:0: [sdd] Write Protect is off
[    3.836333] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    3.836349] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.836461]  sdd: sdd1 sdd2 sdd3
[    3.852862] sd 3:0:0:0: [sdd] Attached SCSI disk
[    4.724010] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.733560] ata5.00: ATA-8: WDC WD7501AALS-00J7B0, 05.00K05, max UDMA/133
[    4.733563] ata5.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    4.734607] ata5.00: configured for UDMA/133
[    4.748074] scsi 4:0:0:0: Direct-Access     ATA      WDC WD7501AALS-0 05.0 PQ: 0 ANSI: 5
[    4.748292] sd 4:0:0:0: [sde] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    4.748329] sd 4:0:0:0: [sde] Write Protect is off
[    4.748331] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    4.748347] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.748460]  sde: sde1 sde2 sde3
[    4.765032] sd 4:0:0:0: [sde] Attached SCSI disk
[    5.636010] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.650269] ata6.00: ATA-8: WDC WD7501AALS-00J7B0, 05.00K05, max UDMA/133
[    5.650272] ata6.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    5.651307] ata6.00: configured for UDMA/133
[    5.664071] scsi 5:0:0:0: Direct-Access     ATA      WDC WD7501AALS-0 05.0 PQ: 0 ANSI: 5
[    5.664331] sd 5:0:0:0: [sdf] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    5.664369] sd 5:0:0:0: [sdf] Write Protect is off
[    5.664371] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    5.664388] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.664523]  sdf: sdf1 sdf2 sdf3
[    5.685434] sd 5:0:0:0: [sdf] Attached SCSI disk
[    7.864028] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 0)
[    7.866455] ata8.00: ATA-7: WDC WD740ADFD-00NLR1, 20.07P20, max UDMA/133
[    7.866458] ata8.00: 145226112 sectors, multi 16: LBA48 NCQ (not used)
[    7.869639] ata8.00: configured for UDMA/100
[    7.869712] scsi 7:0:0:0: Direct-Access     ATA      WDC WD740ADFD-00 20.0 PQ: 0 ANSI: 5
[    7.869962] sd 7:0:0:0: [sdg] 145226112 512-byte logical blocks: (74.3 GB/69.2 GiB)
[    7.870000] sd 7:0:0:0: [sdg] Write Protect is off
[    7.870002] sd 7:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    7.870021] sd 7:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.870118]  sdg:
[    7.870473] scsi 8:0:0:0: CD-ROM            ASUS     CRW-5232AS       1.01 PQ: 0 ANSI: 5
[    7.871134] scsi 8:0:1:0: CD-ROM            SAMSUNG  CD-ROM SH-152A   C503 PQ: 0 ANSI: 5
[    7.883148]  sdg1 < sdg5 sdg6 sdg7 > sdg2 sdg3 sdg4
[    7.901294] sd 7:0:0:0: [sdg] Attached SCSI disk
[    8.024083] Freeing unused kernel memory: 500k freed
[    8.024181] Write protecting the kernel read-only data: 6144k
[    8.024273] Freeing unused kernel memory: 152k freed
[    8.024330] Freeing unused kernel memory: 76k freed
[    8.100190] udev: starting version 157
[    8.148354] sr0: scsi3-mmc drive: 52x/52x writer cd/rw xa/form2 cdda tray
[    8.148358] Uniform CD-ROM driver Revision: 3.20
[    8.148449] sr 8:0:0:0: Attached scsi CD-ROM sr0
[    8.152450] sr1: scsi3-mmc drive: 1x/52x cd/rw xa/form2 cdda tray
[    8.152540] sr 8:0:1:0: Attached scsi CD-ROM sr1
[    8.158953] usbcore: registered new interface driver usbfs
[    8.158979] usbcore: registered new interface driver hub
[    8.160010] usbcore: registered new device driver usb
[    8.161859] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    8.161885] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    8.161912] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    8.161915] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    8.161935] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    8.171897] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    8.171906] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xeb305000
[    8.180501] Floppy drive(s): fd0 is 1.44M
[    8.185535] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    8.185560] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    8.185562] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.185565] usb usb1: Product: EHCI Host Controller
[    8.185567] usb usb1: Manufacturer: Linux 2.6.35-rc3-00001-ga5d1880 ehci_hcd
[    8.185569] usb usb1: SerialNumber: 0000:00:1a.7
[    8.185677] hub 1-0:1.0: USB hub found
[    8.185681] hub 1-0:1.0: 6 ports detected
[    8.185769] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    8.185811] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    8.185814] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    8.185820] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    8.189727] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    8.189756] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xeb304000
[    8.200626] FDC 0 is a post-1991 82077
[    8.205523] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    8.205539] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    8.205542] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.205544] usb usb2: Product: EHCI Host Controller
[    8.205546] usb usb2: Manufacturer: Linux 2.6.35-rc3-00001-ga5d1880 ehci_hcd
[    8.205548] usb usb2: SerialNumber: 0000:00:1d.7
[    8.205634] hub 2-0:1.0: USB hub found
[    8.205637] hub 2-0:1.0: 6 ports detected
[    8.206911] uhci_hcd: USB Universal Host Controller Interface driver
[    8.207016] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.207022] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    8.207025] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    8.207031] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    8.207058] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e200
[    8.207085] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    8.207087] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.207089] usb usb3: Product: UHCI Host Controller
[    8.207090] usb usb3: Manufacturer: Linux 2.6.35-rc3-00001-ga5d1880 uhci_hcd
[    8.207091] usb usb3: SerialNumber: 0000:00:1a.0
[    8.207153] hub 3-0:1.0: USB hub found
[    8.207156] hub 3-0:1.0: 2 ports detected
[    8.207215] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    8.207220] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    8.207222] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    8.207227] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    8.207253] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000e000
[    8.207287] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    8.207289] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.207293] usb usb4: Product: UHCI Host Controller
[    8.207294] usb usb4: Manufacturer: Linux 2.6.35-rc3-00001-ga5d1880 uhci_hcd
[    8.207296] usb usb4: SerialNumber: 0000:00:1a.1
[    8.207350] hub 4-0:1.0: USB hub found
[    8.207353] hub 4-0:1.0: 2 ports detected
[    8.207412] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    8.207416] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    8.207418] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    8.207424] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    8.207443] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000e100
[    8.207466] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    8.207467] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.207469] usb usb5: Product: UHCI Host Controller
[    8.207470] usb usb5: Manufacturer: Linux 2.6.35-rc3-00001-ga5d1880 uhci_hcd
[    8.207472] usb usb5: SerialNumber: 0000:00:1a.2
[    8.207526] hub 5-0:1.0: USB hub found
[    8.207529] hub 5-0:1.0: 2 ports detected
[    8.207590] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    8.207594] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    8.207597] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    8.207602] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    8.207621] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e300
[    8.207645] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    8.207646] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.207648] usb usb6: Product: UHCI Host Controller
[    8.207649] usb usb6: Manufacturer: Linux 2.6.35-rc3-00001-ga5d1880 uhci_hcd
[    8.207651] usb usb6: SerialNumber: 0000:00:1d.0
[    8.207705] hub 6-0:1.0: USB hub found
[    8.207708] hub 6-0:1.0: 2 ports detected
[    8.207764] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    8.207768] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    8.207770] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    8.207776] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    8.207795] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e400
[    8.207821] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    8.207823] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.207825] usb usb7: Product: UHCI Host Controller
[    8.207826] usb usb7: Manufacturer: Linux 2.6.35-rc3-00001-ga5d1880 uhci_hcd
[    8.207828] usb usb7: SerialNumber: 0000:00:1d.1
[    8.207882] hub 7-0:1.0: USB hub found
[    8.207885] hub 7-0:1.0: 2 ports detected
[    8.207940] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    8.207945] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    8.207947] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    8.207952] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    8.207970] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e500
[    8.207994] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    8.207996] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.207997] usb usb8: Product: UHCI Host Controller
[    8.207999] usb usb8: Manufacturer: Linux 2.6.35-rc3-00001-ga5d1880 uhci_hcd
[    8.208000] usb usb8: SerialNumber: 0000:00:1d.2
[    8.208066] hub 8-0:1.0: USB hub found
[    8.208069] hub 8-0:1.0: 2 ports detected
[    8.621217] md: md3 stopped.
[    8.622733] md: bind<sdc1>
[    8.622866] md: bind<sdb1>
[    8.622995] md: bind<sdf1>
[    8.623120] md: bind<sde1>
[    8.623259] md: bind<sdd1>
[    8.623381] md: bind<sda1>
[    8.624518] md/raid1:md3: active with 6 out of 6 mirrors
[    8.624536] md3: detected capacity change from 0 to 10001842176
[    8.671085] md: md4 stopped.
[    8.675564] md: bind<sdb3>
[    8.675686] md: bind<sde3>
[    8.675808] md: bind<sdd3>
[    8.675950] md: bind<sdf3>
[    8.676069] md: bind<sdc3>
[    8.676201] md: bind<sda3>
[    8.677275] md/raid10:md4: active with 6 out of 6 devices
[    8.677293] md4: detected capacity change from 0 to 2211448553472
[    8.680520] usb 5-1: new low speed USB device using uhci_hcd and address 2
[    8.858478] usb 5-1: New USB device found, idVendor=09da, idProduct=000a
[    8.858481] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.858484] usb 5-1: Product: PS/2+USB Mouse
[    8.858486] usb 5-1: Manufacturer: A4Tech
[    8.875126] usbcore: registered new interface driver usbhid
[    8.875128] usbhid: USB HID core driver
[   18.795794] PM: Starting manual resume from disk
[   18.841131] EXT4-fs (md3): mounted filesystem with ordered data mode. Opts: (null)
[   21.026414] udev: starting version 157
[   21.089956] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[   21.089960] ACPI: Power Button [PWRB]
[   21.090015] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[   21.090018] ACPI: Power Button [PWRF]
[   21.107163] ACPI: acpi_idle registered with cpuidle
[   21.107416] Marking TSC unstable due to TSC halts in idle
[   21.110224] Switching to clocksource hpet
[   21.111820] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   21.659582] input: A4Tech PS/2+USB Mouse as /devices/pci0000:00/0000:00:1a.2/usb5/5-1/5-1:1.0/input/input3
[   21.659634] a4tech 0003:09DA:000A.0001: input: USB HID v1.10 Mouse [A4Tech PS/2+USB Mouse] on usb-0000:00:1a.2-1/input0
[   22.226265] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   22.226322] HDA Intel 0000:00:1b.0: irq 49 for MSI/MSI-X
[   22.226345] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   22.301440] audit: name_count maxed, losing inode data: dev=00:05, inode=24539
[   22.301461] audit: name_count maxed, losing inode data: dev=00:05, inode=4
[   22.301465] audit: name_count maxed, losing inode data: dev=00:05, inode=4
[   22.301486] audit: name_count maxed, losing inode data: dev=00:05, inode=23455
[   22.301490] audit: name_count maxed, losing inode data: dev=00:05, inode=23455
[   22.301510] audit: name_count maxed, losing inode data: dev=00:05, inode=4
[   22.301514] audit: name_count maxed, losing inode data: dev=00:05, inode=4
[   22.301980] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   22.302034] HDA Intel 0000:01:00.1: irq 50 for MSI/MSI-X
[   22.302052] HDA Intel 0000:01:00.1: setting latency timer to 64
[   22.318662] audit: name_count maxed, losing inode data: dev=00:05, inode=23455
[   22.318667] audit: name_count maxed, losing inode data: dev=00:05, inode=23455
[   22.318694] audit: name_count maxed, losing inode data: dev=00:05, inode=23455
[   22.318698] audit: name_count maxed, losing inode data: dev=00:05, inode=23455
[   22.318717] audit: name_count maxed, losing inode data: dev=00:05, inode=4
[   22.318721] audit: name_count maxed, losing inode data: dev=00:05, inode=4
[   22.559262] Adding 2931856k swap on /dev/sda2.  Priority:1 extents:1 across:2931856k 
[   22.563707] Adding 2931856k swap on /dev/sdd2.  Priority:1 extents:1 across:2931856k 
[   22.567898] EXT4-fs (md3): warning: maximal mount count reached, running e2fsck is recommended
[   22.598595] EXT4-fs (md3): re-mounted. Opts: errors=remount-ro
[   22.704171] audit: name_count maxed, losing inode data: dev=00:05, inode=4
[   22.704205] audit: name_count maxed, losing inode data: dev=00:07, inode=8
[   22.704209] audit: name_count maxed, losing inode data: dev=00:07, inode=24888
[   22.704215] audit: name_count maxed, losing inode data: dev=00:05, inode=4
[   22.704218] audit: name_count maxed, losing inode data: dev=00:05, inode=4
[   22.704252] audit: name_count maxed, losing inode data: dev=00:07, inode=8
[   22.704255] audit: name_count maxed, losing inode data: dev=00:07, inode=24891
[   22.704265] audit: name_count maxed, losing inode data: dev=00:05, inode=4
[   22.704268] audit: name_count maxed, losing inode data: dev=00:05, inode=4
[   22.704303] audit: name_count maxed, losing inode data: dev=00:07, inode=8
[   22.704306] audit: name_count maxed, losing inode data: dev=00:07, inode=24894
[   22.704312] audit: name_count maxed, losing inode data: dev=00:05, inode=4
[   22.704315] audit: name_count maxed, losing inode data: dev=00:05, inode=4
[   22.704350] audit: name_count maxed, losing inode data: dev=00:07, inode=8
[   22.704353] audit: name_count maxed, losing inode data: dev=00:07, inode=24897
[   22.704359] audit: name_count maxed, losing inode data: dev=00:05, inode=4
[   22.704362] audit: name_count maxed, losing inode data: dev=00:05, inode=4
[   22.704399] audit: name_count maxed, losing inode data: dev=00:07, inode=8
[   22.704402] audit: name_count maxed, losing inode data: dev=00:07, inode=24900
[   22.704404] loop: module loaded
[   22.740779] it87: Found IT8718F chip at 0x290, revision 5
[   22.740808] it87: VID is disabled (pins used for GPIO)
[   22.740815] it87: in3 is VCC (+5V)
[   22.740818] it87: Beeping is supported
[   22.869871] [drm] Initialized drm 1.1.0 20060810
[   22.982298] [drm] radeon kernel modesetting enabled.
[   22.982345] radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   22.982350] radeon 0000:01:00.0: setting latency timer to 64
[   22.983371] audit: name_count maxed, losing inode data: dev=00:05, inode=25044
[   22.983374] audit: name_count maxed, losing inode data: dev=00:05, inode=25044
[   22.983381] audit: name_count maxed, losing inode data: dev=00:05, inode=25044
[   22.983409] audit: name_count maxed, losing inode data: dev=00:07, inode=25008
[   22.983418] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   22.983420] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   22.983423] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   22.983426] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   22.983429] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   22.983432] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   22.983434] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   22.983437] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   22.983444] audit: name_count maxed, losing inode data: dev=00:05, inode=25044
[   22.983448] audit: name_count maxed, losing inode data: dev=00:05, inode=25044
[   22.983501] [drm] initializing kernel modesetting (RV730 0x1002:0x9498).
[   22.984018] [drm] register mmio base: 0xE5000000
[   22.984020] [drm] register mmio size: 65536
[   22.984219] ATOM BIOS: 11x
[   22.984231] [drm] Clocks initialized !
[   22.984235] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   22.984238] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   22.984243] radeon 0000:01:00.0: VRAM: 1024M 0x00000000 - 0x3FFFFFFF (1024M used)
[   22.984245] radeon 0000:01:00.0: GTT: 512M 0x40000000 - 0x5FFFFFFF
[   22.984257] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[   22.984259] [drm] Detected VRAM RAM=1024M, BAR=256M
[   22.984260] [drm] RAM width 128bits DDR
[   22.984331] [TTM] Zone  kernel: Available graphics memory: 1991300 kiB.
[   22.984332] [TTM] Initializing pool allocator.
[   22.984345] [drm] radeon: 1024M of VRAM memory ready
[   22.984347] [drm] radeon: 512M of GTT memory ready.
[   22.984350] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   22.984353] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   22.984355] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   22.984358] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   22.984361] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   22.984363] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   22.984391] radeon 0000:01:00.0: irq 51 for MSI/MSI-X
[   22.984395] [drm] radeon: using MSI.
[   22.984420] [drm] radeon: irq initialized.
[   22.984422] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   22.985055] [drm] Loading RV730 Microcode
[   23.045202] [drm] ring test succeeded in 1 usecs
[   23.045276] [drm] radeon: ib pool ready.
[   23.045283] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   23.045286] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   23.045292] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   23.045295] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   23.045297] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   23.045301] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   23.045303] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   23.045310] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   23.045312] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   23.045315] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   23.045317] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   23.045320] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   23.045322] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   23.045325] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   23.045327] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   23.045330] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   23.045332] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   23.045335] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   23.045337] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   23.045340] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   23.045342] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   23.045345] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   23.045347] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   23.045350] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   23.045352] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   23.045355] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   23.045358] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   23.045360] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   23.045363] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   23.045365] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   23.045368] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   23.045370] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   23.045373] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   23.045375] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   23.045400] [drm] ib test succeeded in 0 usecs
[   23.045402] [drm] Enabling audio support
[   23.045470] [drm] Default TV standard: NTSC
[   23.045498] [drm] Default TV standard: NTSC
[   23.045530] [drm] Radeon Display Connectors
[   23.045536] [drm] Connector 0:
[   23.045537] [drm]   HDMI-A
[   23.045538] [drm]   HPD2
[   23.045540] [drm]   DDC: 0x7f10 0x7f10 0x7f14 0x7f14 0x7f18 0x7f18 0x7f1c 0x7f1c
[   23.045541] [drm]   Encoders:
[   23.045542] [drm]     DFP2: INTERNAL_UNIPHY1
[   23.045543] [drm] Connector 1:
[   23.045544] [drm]   VGA
[   23.045546] [drm]   DDC: 0x7e20 0x7e20 0x7e24 0x7e24 0x7e28 0x7e28 0x7e2c 0x7e2c
[   23.045547] [drm]   Encoders:
[   23.045548] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[   23.045549] [drm] Connector 2:
[   23.045550] [drm]   DVI-I
[   23.045551] [drm]   HPD1
[   23.045552] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[   23.045554] [drm]   Encoders:
[   23.045555] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[   23.045556] [drm]     DFP1: INTERNAL_UNIPHY
[   23.101523] [drm] Internal thermal controller with fan control
[   23.101539] audit: name_count maxed, losing inode data: dev=00:07, inode=25035
[   23.101545] audit: name_count maxed, losing inode data: dev=00:07, inode=25046
[   23.101547] [drm] radeon: power management initialized
[   23.576968] [drm] fb mappable at 0xD0141000
[   23.576970] [drm] vram apper at 0xD0000000
[   23.576971] [drm] size 7258112
[   23.576972] [drm] fb depth is 24
[   23.576973] [drm]    pitch is 6912
[   23.576997] audit: name_count maxed, losing inode data: dev=00:05, inode=4
[   23.577003] audit: name_count maxed, losing inode data: dev=00:05, inode=4
[   24.588000] Console: switching to colour frame buffer device 210x65
[   24.591962] fb0: radeondrmfb frame buffer device
[   24.591963] drm: registered panic notifier
[   24.591967] Slow work thread pool: Starting up
[   24.592062] Slow work thread pool: Ready
[   24.592066] [drm] Initialized radeon 2.5.0 20080528 for 0000:01:00.0 on minor 0
[   24.665517] NET: Registered protocol family 10
[   24.665742] lo: Disabled Privacy Extensions
[   24.699903] REISERFS (device dm-2): found reiserfs format "3.6" with standard journal
[   24.699918] REISERFS (device dm-2): using ordered data mode
[   24.717455] REISERFS (device dm-2): journal params: device dm-2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   24.717751] REISERFS (device dm-2): checking transaction log (dm-2)
[   24.803707] REISERFS (device dm-2): Using r5 hash to sort names
[   24.844003] Filesystem "dm-3": Disabling barriers, not supported with external log device
[   24.865278] XFS mounting filesystem dm-3
[   24.954766] Ending clean XFS mount for filesystem: dm-3
[   24.955323] Filesystem "dm-0": Disabling barriers, not supported with external log device
[   24.983985] XFS mounting filesystem dm-0
[   25.085500] Ending clean XFS mount for filesystem: dm-0
[   25.086064] Filesystem "dm-1": Disabling barriers, not supported with external log device
[   25.110512] XFS mounting filesystem dm-1
[   25.229666] Ending clean XFS mount for filesystem: dm-1
[   28.466739] r8169 0000:05:00.0: eth0: link up
[   28.466743] r8169 0000:05:00.0: eth0: link up
[   28.482923] fuse init (API version 7.14)
[   29.269621] audit: name_count maxed, losing inode data: dev=00:07, inode=26052
[   29.269627] audit: name_count maxed, losing inode data: dev=00:07, inode=26052
[   29.269630] audit: name_count maxed, losing inode data: dev=00:07, inode=26052
[   29.269634] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269637] audit: name_count maxed, losing inode data: dev=00:07, inode=26057
[   29.269640] audit: name_count maxed, losing inode data: dev=00:07, inode=26057
[   29.269651] audit: name_count maxed, losing inode data: dev=00:07, inode=26057
[   29.269653] audit: name_count maxed, losing inode data: dev=00:07, inode=26057
[   29.269657] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269660] audit: name_count maxed, losing inode data: dev=00:07, inode=26062
[   29.269663] audit: name_count maxed, losing inode data: dev=00:07, inode=26062
[   29.269674] audit: name_count maxed, losing inode data: dev=00:07, inode=26062
[   29.269680] audit: name_count maxed, losing inode data: dev=00:07, inode=26062
[   29.269683] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269686] audit: name_count maxed, losing inode data: dev=00:07, inode=26067
[   29.269688] audit: name_count maxed, losing inode data: dev=00:07, inode=26067
[   29.269694] audit: name_count maxed, losing inode data: dev=00:07, inode=26067
[   29.269696] audit: name_count maxed, losing inode data: dev=00:07, inode=26067
[   29.269699] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269702] audit: name_count maxed, losing inode data: dev=00:07, inode=26072
[   29.269706] audit: name_count maxed, losing inode data: dev=00:07, inode=26072
[   29.269712] audit: name_count maxed, losing inode data: dev=00:07, inode=26072
[   29.269714] audit: name_count maxed, losing inode data: dev=00:07, inode=26072
[   29.269717] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269719] audit: name_count maxed, losing inode data: dev=00:07, inode=26077
[   29.269722] audit: name_count maxed, losing inode data: dev=00:07, inode=26077
[   29.269727] audit: name_count maxed, losing inode data: dev=00:07, inode=26077
[   29.269730] audit: name_count maxed, losing inode data: dev=00:07, inode=26077
[   29.269733] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269735] audit: name_count maxed, losing inode data: dev=00:07, inode=26083
[   29.269738] audit: name_count maxed, losing inode data: dev=00:07, inode=26083
[   29.269745] audit: name_count maxed, losing inode data: dev=00:07, inode=26083
[   29.269747] audit: name_count maxed, losing inode data: dev=00:07, inode=26083
[   29.269750] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269752] audit: name_count maxed, losing inode data: dev=00:07, inode=26088
[   29.269755] audit: name_count maxed, losing inode data: dev=00:07, inode=26088
[   29.269764] audit: name_count maxed, losing inode data: dev=00:07, inode=26088
[   29.269766] audit: name_count maxed, losing inode data: dev=00:07, inode=26088
[   29.269774] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269776] audit: name_count maxed, losing inode data: dev=00:07, inode=26093
[   29.269779] audit: name_count maxed, losing inode data: dev=00:07, inode=26093
[   29.269785] audit: name_count maxed, losing inode data: dev=00:07, inode=26093
[   29.269791] audit: name_count maxed, losing inode data: dev=00:07, inode=26093
[   29.269794] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269797] audit: name_count maxed, losing inode data: dev=00:07, inode=26098
[   29.269799] audit: name_count maxed, losing inode data: dev=00:07, inode=26098
[   29.269804] audit: name_count maxed, losing inode data: dev=00:07, inode=26098
[   29.269807] audit: name_count maxed, losing inode data: dev=00:07, inode=26098
[   29.269810] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269812] audit: name_count maxed, losing inode data: dev=00:07, inode=26103
[   29.269815] audit: name_count maxed, losing inode data: dev=00:07, inode=26103
[   29.269821] audit: name_count maxed, losing inode data: dev=00:07, inode=26103
[   29.269823] audit: name_count maxed, losing inode data: dev=00:07, inode=26103
[   29.269826] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269828] audit: name_count maxed, losing inode data: dev=00:07, inode=26108
[   29.269831] audit: name_count maxed, losing inode data: dev=00:07, inode=26108
[   29.269838] audit: name_count maxed, losing inode data: dev=00:07, inode=26108
[   29.269840] audit: name_count maxed, losing inode data: dev=00:07, inode=26108
[   29.269843] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269845] audit: name_count maxed, losing inode data: dev=00:07, inode=26113
[   29.269847] audit: name_count maxed, losing inode data: dev=00:07, inode=26113
[   29.269853] audit: name_count maxed, losing inode data: dev=00:07, inode=26113
[   29.269857] audit: name_count maxed, losing inode data: dev=00:07, inode=26113
[   29.269859] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269862] audit: name_count maxed, losing inode data: dev=00:07, inode=26118
[   29.269868] audit: name_count maxed, losing inode data: dev=00:07, inode=26118
[   29.269876] audit: name_count maxed, losing inode data: dev=00:07, inode=26118
[   29.269878] audit: name_count maxed, losing inode data: dev=00:07, inode=26118
[   29.269881] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269883] audit: name_count maxed, losing inode data: dev=00:07, inode=26123
[   29.269886] audit: name_count maxed, losing inode data: dev=00:07, inode=26123
[   29.269892] audit: name_count maxed, losing inode data: dev=00:07, inode=26123
[   29.269894] audit: name_count maxed, losing inode data: dev=00:07, inode=26123
[   29.269897] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269900] audit: name_count maxed, losing inode data: dev=00:07, inode=26128
[   29.269902] audit: name_count maxed, losing inode data: dev=00:07, inode=26128
[   29.269907] audit: name_count maxed, losing inode data: dev=00:07, inode=26128
[   29.269910] audit: name_count maxed, losing inode data: dev=00:07, inode=26128
[   29.269913] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269915] audit: name_count maxed, losing inode data: dev=00:07, inode=26133
[   29.269918] audit: name_count maxed, losing inode data: dev=00:07, inode=26133
[   29.269923] audit: name_count maxed, losing inode data: dev=00:07, inode=26133
[   29.269926] audit: name_count maxed, losing inode data: dev=00:07, inode=26133
[   29.269930] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269932] audit: name_count maxed, losing inode data: dev=00:07, inode=26138
[   29.269935] audit: name_count maxed, losing inode data: dev=00:07, inode=26138
[   29.269940] audit: name_count maxed, losing inode data: dev=00:07, inode=26138
[   29.269942] audit: name_count maxed, losing inode data: dev=00:07, inode=26138
[   29.269945] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269947] audit: name_count maxed, losing inode data: dev=00:07, inode=26143
[   29.269950] audit: name_count maxed, losing inode data: dev=00:07, inode=26143
[   29.269956] audit: name_count maxed, losing inode data: dev=00:07, inode=26143
[   29.269962] audit: name_count maxed, losing inode data: dev=00:07, inode=26143
[   29.269965] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269967] audit: name_count maxed, losing inode data: dev=00:07, inode=26148
[   29.269970] audit: name_count maxed, losing inode data: dev=00:07, inode=26148
[   29.269975] audit: name_count maxed, losing inode data: dev=00:07, inode=26148
[   29.269977] audit: name_count maxed, losing inode data: dev=00:07, inode=26148
[   29.269980] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269982] audit: name_count maxed, losing inode data: dev=00:07, inode=26153
[   29.269985] audit: name_count maxed, losing inode data: dev=00:07, inode=26153
[   29.269990] audit: name_count maxed, losing inode data: dev=00:07, inode=26153
[   29.269992] audit: name_count maxed, losing inode data: dev=00:07, inode=26153
[   29.269995] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.269998] audit: name_count maxed, losing inode data: dev=00:07, inode=26158
[   29.270001] audit: name_count maxed, losing inode data: dev=00:07, inode=26158
[   29.270006] audit: name_count maxed, losing inode data: dev=00:07, inode=26158
[   29.270008] audit: name_count maxed, losing inode data: dev=00:07, inode=26158
[   29.270011] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.270013] audit: name_count maxed, losing inode data: dev=00:07, inode=26163
[   29.270016] audit: name_count maxed, losing inode data: dev=00:07, inode=26163
[   29.270021] audit: name_count maxed, losing inode data: dev=00:07, inode=26163
[   29.270024] audit: name_count maxed, losing inode data: dev=00:07, inode=26163
[   29.270026] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.270029] audit: name_count maxed, losing inode data: dev=00:07, inode=26168
[   29.270031] audit: name_count maxed, losing inode data: dev=00:07, inode=26168
[   29.270037] audit: name_count maxed, losing inode data: dev=00:07, inode=26168
[   29.270039] audit: name_count maxed, losing inode data: dev=00:07, inode=26168
[   29.270042] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.270049] audit: name_count maxed, losing inode data: dev=00:07, inode=26173
[   29.270051] audit: name_count maxed, losing inode data: dev=00:07, inode=26173
[   29.270058] audit: name_count maxed, losing inode data: dev=00:07, inode=26173
[   29.270060] audit: name_count maxed, losing inode data: dev=00:07, inode=26173
[   29.270063] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.270065] audit: name_count maxed, losing inode data: dev=00:07, inode=26178
[   29.270069] audit: name_count maxed, losing inode data: dev=00:07, inode=26178
[   29.270075] audit: name_count maxed, losing inode data: dev=00:07, inode=26178
[   29.270077] audit: name_count maxed, losing inode data: dev=00:07, inode=26178
[   29.270080] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.270082] audit: name_count maxed, losing inode data: dev=00:07, inode=26183
[   29.270085] audit: name_count maxed, losing inode data: dev=00:07, inode=26183
[   29.270092] audit: name_count maxed, losing inode data: dev=00:07, inode=26183
[   29.270095] audit: name_count maxed, losing inode data: dev=00:07, inode=26183
[   29.270097] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.270100] audit: name_count maxed, losing inode data: dev=00:07, inode=26188
[   29.270102] audit: name_count maxed, losing inode data: dev=00:07, inode=26188
[   29.270108] audit: name_count maxed, losing inode data: dev=00:07, inode=26188
[   29.270111] audit: name_count maxed, losing inode data: dev=00:07, inode=26188
[   29.270113] audit: name_count maxed, losing inode data: dev=00:07, inode=26044
[   29.270116] audit: name_count maxed, losing inode data: dev=00:07, inode=26193
[   29.270118] audit: name_count maxed, losing inode data: dev=00:07, inode=26193
[   29.270123] audit: name_count maxed, losing inode data: dev=00:07, inode=26193
[   29.270125] audit: name_count maxed, losing inode data: dev=00:07, inode=26193
[   29.270128] audit: name_count maxed, losing inode data: dev=00:07, inode=77
[   29.270130] audit: name_count maxed, losing inode data: dev=00:07, inode=26198
[   29.270133] audit: name_count maxed, losing inode data: dev=00:07, inode=26198
[   29.270142] audit: name_count maxed, losing inode data: dev=00:07, inode=26198
[   29.270145] audit: name_count maxed, losing inode data: dev=00:07, inode=26201
[   29.270147] audit: name_count maxed, losing inode data: dev=00:07, inode=26201
[   29.270153] audit: name_count maxed, losing inode data: dev=00:07, inode=26201
[   29.270155] audit: name_count maxed, losing inode data: dev=00:07, inode=26201
[   29.270158] audit: name_count maxed, losing inode data: dev=00:07, inode=26198
[   29.270160] audit: name_count maxed, losing inode data: dev=00:07, inode=26206
[   29.270163] audit: name_count maxed, losing inode data: dev=00:07, inode=26206
[   29.270165] audit: name_count maxed, losing inode data: dev=00:07, inode=26206
[   29.270167] audit: name_count maxed, losing inode data: dev=00:07, inode=26206
[   29.270170] audit: name_count maxed, losing inode data: dev=00:07, inode=26198
[   29.270172] audit: name_count maxed, losing inode data: dev=00:07, inode=26211
[   29.270175] audit: name_count maxed, losing inode data: dev=00:07, inode=26211
[   29.270177] audit: name_count maxed, losing inode data: dev=00:07, inode=26211
[   29.270179] audit: name_count maxed, losing inode data: dev=00:07, inode=26211
[   29.270182] audit: name_count maxed, losing inode data: dev=00:07, inode=26198
[   29.270184] audit: name_count maxed, losing inode data: dev=00:07, inode=26216
[   29.270186] audit: name_count maxed, losing inode data: dev=00:07, inode=26216
[   29.270194] audit: name_count maxed, losing inode data: dev=00:07, inode=26216
[   29.270196] audit: name_count maxed, losing inode data: dev=00:07, inode=26216
[   29.270199] audit: name_count maxed, losing inode data: dev=00:07, inode=26198
[   29.270202] audit: name_count maxed, losing inode data: dev=00:07, inode=26221
[   29.270205] audit: name_count maxed, losing inode data: dev=00:07, inode=26221
[   29.270209] audit: name_count maxed, losing inode data: dev=00:07, inode=26221
[   29.270211] audit: name_count maxed, losing inode data: dev=00:07, inode=26221
[   29.270214] audit: name_count maxed, losing inode data: dev=00:07, inode=26198
[   29.270217] audit: name_count maxed, losing inode data: dev=00:07, inode=26226
[   29.270223] audit: name_count maxed, losing inode data: dev=00:07, inode=26226
[   29.270227] audit: name_count maxed, losing inode data: dev=00:07, inode=26226
[   29.270230] audit: name_count maxed, losing inode data: dev=00:07, inode=26226
[   29.270233] audit: name_count maxed, losing inode data: dev=00:07, inode=26198
[   29.270235] audit: name_count maxed, losing inode data: dev=00:07, inode=26231
[   29.270237] audit: name_count maxed, losing inode data: dev=00:07, inode=26231
[   29.270240] audit: name_count maxed, losing inode data: dev=00:07, inode=26231
[   29.270242] audit: name_count maxed, losing inode data: dev=00:07, inode=26231
[   29.270245] audit: name_count maxed, losing inode data: dev=00:07, inode=26198
[   29.270247] audit: name_count maxed, losing inode data: dev=00:07, inode=26236
[   29.270249] audit: name_count maxed, losing inode data: dev=00:07, inode=26236
[   29.270254] audit: name_count maxed, losing inode data: dev=00:07, inode=26236
[   29.270256] audit: name_count maxed, losing inode data: dev=00:07, inode=26236
[   29.270259] audit: name_count maxed, losing inode data: dev=00:07, inode=26198
[   29.270261] audit: name_count maxed, losing inode data: dev=00:07, inode=26241
[   29.270265] audit: name_count maxed, losing inode data: dev=00:07, inode=26241
[   29.270270] audit: name_count maxed, losing inode data: dev=00:07, inode=26241
[   29.270273] audit: name_count maxed, losing inode data: dev=00:07, inode=26241
[   29.273066] microcode: CPU0 sig=0x10677, pf=0x10, revision=0x703
[   29.365226] microcode: CPU1 sig=0x10677, pf=0x10, revision=0x703
[   29.368463] microcode: CPU2 sig=0x10677, pf=0x10, revision=0x703
[   29.371743] microcode: CPU3 sig=0x10677, pf=0x10, revision=0x703
[   29.374825] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   29.374866] audit: name_count maxed, losing inode data: dev=00:07, inode=26305
[   29.374869] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374873] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374876] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374881] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374884] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374887] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374889] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374892] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374895] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374897] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374900] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374903] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374906] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374908] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374911] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374919] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374922] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374924] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374927] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374929] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374932] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374934] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374937] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.374940] audit: name_count maxed, losing inode data: dev=00:07, inode=26297
[   29.519986] microcode: CPU0 updated to revision 0x705, date = 2008-04-28
[   29.524502] microcode: CPU1 updated to revision 0x705, date = 2008-04-28
[   29.530582] microcode: CPU2 updated to revision 0x705, date = 2008-04-28
[   29.536204] microcode: CPU3 updated to revision 0x705, date = 2008-04-28
[   35.289407] r8169 0000:06:00.0: eth1: link down
[   35.289929] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   41.285117] ip_tables: (C) 2000-2006 Netfilter Core Team
[   41.495274] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   41.495402] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   41.495405] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
[   41.495407] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[ 7441.002414] python[2799]: segfault at 8 ip 000000312622783b sp 00007fff59e791d0 error 6 in libdbus-1.so.3.4.0[3126200000+3e000]
[11042.065206] You have old & broken userspace please consider updating mesa
[25110.641516] usb 5-2: new full speed USB device using uhci_hcd and address 3
[25110.810310] usb 5-2: New USB device found, idVendor=04e8, idProduct=326c
[25110.810314] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[25110.810316] usb 5-2: Product: Samsung ML-2010
[25110.810318] usb 5-2: Manufacturer: Samsung
[25110.810320] usb 5-2: SerialNumber: 3T21BKCL402412V.
[25111.147425] usblp0: USB Bidirectional printer dev 3 if 0 alt 0 proto 2 vid 0x04E8 pid 0x326C
[25111.147611] usbcore: registered new interface driver usblp
[25837.288035] usb 5-2: USB disconnect, address 3
[25837.288138] usblp0: removed
[28144.351747] ata9: drained 65536 bytes to clear DRQ.
[28144.460834] ata9.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[28144.460838] sr 8:0:1:0: CDB: Prevent/Allow Medium Removal: 1e 00 00 00 00 00
[28144.460846] ata9.01: cmd a0/00:00:00:00:00/00:00:00:00:00/b0 tag 0
[28144.460846]          res 7f/7f:7f:7f:7f:7f/00:00:00:00:00/7f Emask 0x3 (HSM violation)
[28144.460849] ata9.01: status: { DRDY DF DRQ ERR }
[28144.460867] ata9: soft resetting link
[28144.633647] ata9.00: configured for UDMA/33
[28144.648525] ata9.01: configured for UDMA/33
[28144.649438] ata9: EH complete
[28200.351742] ata9: drained 65536 bytes to clear DRQ.
[28200.460521] ata9.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[28200.460524] sr 8:0:1:0: CDB: Prevent/Allow Medium Removal: 1e 00 00 00 00 00
[28200.460537] ata9.01: cmd a0/00:00:00:00:00/00:00:00:00:00/b0 tag 0
[28200.460538]          res 7f/7f:7f:7f:7f:7f/00:00:00:00:00/7f Emask 0x3 (HSM violation)
[28200.460540] ata9.01: status: { DRDY DF DRQ ERR }
[28200.460559] ata9: soft resetting link
[28200.633645] ata9.00: configured for UDMA/33
[28200.648522] ata9.01: configured for UDMA/33
[28200.649401] ata9: EH complete
[28226.352017] ata9: drained 65536 bytes to clear DRQ.
[28226.460488] ata9.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[28226.460491] sr 8:0:1:0: CDB: Prevent/Allow Medium Removal: 1e 00 00 00 00 00
[28226.460499] ata9.01: cmd a0/00:00:00:00:00/00:00:00:00:00/b0 tag 0
[28226.460505]          res 7f/7f:7f:7f:7f:7f/00:00:00:00:00/7f Emask 0x3 (HSM violation)
[28226.460507] ata9.01: status: { DRDY DF DRQ ERR }
[28226.460526] ata9: soft resetting link
[28226.632650] ata9.00: configured for UDMA/33
[28226.648522] ata9.01: configured for UDMA/33
[28226.649430] ata9: EH complete
[32470.355768] ata9: drained 65536 bytes to clear DRQ.
[32470.464499] ata9.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[32470.464503] sr 8:0:1:0: CDB: Prevent/Allow Medium Removal: 1e 00 00 00 00 00
[32470.464511] ata9.01: cmd a0/00:00:00:00:00/00:00:00:00:00/b0 tag 0
[32470.464512]          res 7f/7f:7f:7f:7f:7f/00:00:00:00:00/7f Emask 0x3 (HSM violation)
[32470.464514] ata9.01: status: { DRDY DF DRQ ERR }
[32470.464531] ata9: soft resetting link
[32475.660013] ata9: link is slow to respond, please be patient (ready=0)
[32480.477009] ata9: SRST failed (errno=-16)
[32480.477019] ata9: soft resetting link
[32485.673017] ata9: link is slow to respond, please be patient (ready=0)
[32490.489029] ata9: SRST failed (errno=-16)
[32490.489040] ata9: soft resetting link
[32490.661662] ata9.00: configured for UDMA/33
[32490.676531] ata9.01: configured for UDMA/33
[32490.677451] ata9: EH complete
[32709.352741] ata9: drained 65536 bytes to clear DRQ.
[32709.463175] ata9.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[32709.463178] sr 8:0:1:0: CDB: Prevent/Allow Medium Removal: 1e 00 00 00 00 00
[32709.463186] ata9.01: cmd a0/00:00:00:00:00/00:00:00:00:00/b0 tag 0
[32709.463187]          res 7f/7f:7f:7f:7f:7f/00:00:00:00:00/7f Emask 0x3 (HSM violation)
[32709.463189] ata9.01: status: { DRDY DF DRQ ERR }
[32709.463206] ata9: soft resetting link
[32714.636048] ata9.01: qc timeout (cmd 0xa1)
[32714.636052] ata9.01: failed to IDENTIFY (I/O error, err_mask=0x4)
[32714.636054] ata9.01: revalidation failed (errno=-5)
[32719.685018] ata9: link is slow to respond, please be patient (ready=0)
[32724.672514] ata9: device not ready (errno=-16), forcing hardreset
[32724.672525] ata9: soft resetting link
[32729.833513] ata9: link is slow to respond, please be patient (ready=0)
[32734.720516] ata9: SRST failed (errno=-16)
[32734.720529] ata9: soft resetting link
[32739.888513] ata9: link is slow to respond, please be patient (ready=0)
[32744.773280] ata9: SRST failed (errno=-16)
[32744.773290] ata9: soft resetting link
[32749.932020] ata9: link is slow to respond, please be patient (ready=0)
[32758.297574] ata9.01: link status unknown, clearing UNKNOWN to NONE
[32768.309549] ata9.01: qc timeout (cmd 0xa1)
[32768.309553] ata9.01: failed to IDENTIFY (I/O error, err_mask=0x4)
[32768.309556] ata9.01: revalidation failed (errno=-5)
[32768.309577] ata9: soft resetting link
[32773.509015] ata9: link is slow to respond, please be patient (ready=0)
[32778.325015] ata9: SRST failed (errno=-16)
[32778.325025] ata9: soft resetting link
[32783.521016] ata9: link is slow to respond, please be patient (ready=0)
[32788.352015] ata9: SRST failed (errno=-16)
[32788.352026] ata9: soft resetting link
[32793.556018] ata9: link is slow to respond, please be patient (ready=0)
[32822.024565] ata9.01: link status unknown, clearing UNKNOWN to NONE
[32852.036046] ata9.01: qc timeout (cmd 0xa1)
[32852.036050] ata9.01: failed to IDENTIFY (I/O error, err_mask=0x4)
[32852.036053] ata9.01: revalidation failed (errno=-5)
[32852.036056] ata9.01: disabled
[32852.036061] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x40)
[32852.036064] ata9.00: revalidation failed (errno=-5)
[32852.036079] ata9: soft resetting link
[32857.244016] ata9: link is slow to respond, please be patient (ready=0)
[32862.068511] ata9: SRST failed (errno=-16)
[32862.068522] ata9: soft resetting link
[32867.228529] ata9: link is slow to respond, please be patient (ready=0)
[32872.104515] ata9: SRST failed (errno=-16)
[32872.104526] ata9: soft resetting link
[32877.309511] ata9: link is slow to respond, please be patient (ready=0)
[32880.588540] INFO: task hald-addon-stor:6113 blocked for more than 120 seconds.
[32880.588543] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[32880.588546] hald-addon-st D 0000000000000002     0  6113   5949 0x00000080
[32880.588551]  ffff880122a21af8 0000000000000086 0000000000013d00 0000000000000000
[32880.588555]  ffff880122a21fd8 ffff880122b161c0 ffff880122a21fd8 ffff880122a20000
[32880.588559]  ffff880122a20000 ffff880122a21fd8 ffff880122a20000 ffff880122a21fd8
[32880.588563] Call Trace:
[32880.588570]  [<ffffffff812d2715>] scsi_block_when_processing_errors+0x91/0xc2
[32880.588575]  [<ffffffff810539c5>] ? autoremove_wake_function+0x0/0x34
[32880.588579]  [<ffffffff812303a7>] ? get_disk+0xd9/0xfd
[32880.588593]  [<ffffffffa0096301>] sr_open+0x11/0x1b [sr_mod]
[32880.588599]  [<ffffffffa0089086>] cdrom_open+0x4d/0x46b [cdrom]
[32880.588603]  [<ffffffff812bed32>] ? kobj_lookup+0x1c0/0x1fb
[32880.588607]  [<ffffffff8123b3dc>] ? kobject_get+0x1a/0x22
[32880.588616]  [<ffffffffa009649b>] sr_block_open+0x8b/0xa8 [sr_mod]
[32880.588619]  [<ffffffff812b956b>] ? get_device+0x14/0x1a
[32880.588623]  [<ffffffff8110c0a4>] __blkdev_get+0xda/0x391
[32880.588625]  [<ffffffff8110c366>] blkdev_get+0xb/0xd
[32880.588628]  [<ffffffff8110c40f>] blkdev_open+0xa7/0xe6
[32880.588630]  [<ffffffff8110c368>] ? blkdev_open+0x0/0xe6
[32880.588633]  [<ffffffff810e2f42>] __dentry_open+0x1ce/0x2fd
[32880.588635]  [<ffffffff810e3136>] nameidata_to_filp+0x3a/0x4b
[32880.588638]  [<ffffffff810eea66>] do_last+0x4e5/0x64b
[32880.588640]  [<ffffffff810f082b>] do_filp_open+0x202/0x641
[32880.588642]  [<ffffffff8123b2b3>] ? kobject_put+0x47/0x4b
[32880.588645]  [<ffffffff810f96c8>] ? alloc_fd+0x111/0x123
[32880.588647]  [<ffffffff810e2c8b>] do_sys_open+0x5e/0x10a
[32880.588649]  [<ffffffff810e2d60>] sys_open+0x1b/0x1d
[32880.588652]  [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
[32880.588655] INFO: task hald-addon-stor:6122 blocked for more than 120 seconds.
[32880.588656] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[32880.588658] hald-addon-st D 0000000000000002     0  6122   5949 0x00000080
[32880.588660]  ffff880122abdaa8 0000000000000082 ffff880122abd9f8 ffffffff812f0b93
[32880.588663]  ffff880122abdfd8 ffff880122b130e0 ffff880122abdfd8 ffff880122abc000
[32880.588666]  ffff880122abc000 ffff880122abdfd8 ffff880122abc000 ffff880122abdfd8
[32880.588669] Call Trace:
[32880.588671]  [<ffffffff812f0b93>] ? ata_bmdma_qc_issue+0x41/0x152
[32880.588674]  [<ffffffff812e621e>] ? ata_scsi_translate+0x108/0x141
[32880.588676]  [<ffffffff812ce4dd>] ? scsi_done+0x0/0x72
[32880.588680]  [<ffffffff813cc0dd>] schedule_timeout+0x28/0x275
[32880.588683]  [<ffffffff81229cbd>] ? blk_peek_request+0x1c1/0x1d9
[32880.588685]  [<ffffffff8123b2b3>] ? kobject_put+0x47/0x4b
[32880.588687]  [<ffffffff813cb45e>] wait_for_common+0xc2/0x13c
[32880.588690]  [<ffffffff8103798d>] ? default_wake_function+0x0/0xf
[32880.588692]  [<ffffffff8122aa40>] ? __generic_unplug_device+0x2d/0x31
[32880.588695]  [<ffffffff813cb572>] wait_for_completion+0x18/0x1a
[32880.588697]  [<ffffffff8122ddd3>] blk_execute_rq+0x85/0x9e
[32880.588701]  [<ffffffffa009746d>] ? sr_do_ioctl+0x24b/0x261 [sr_mod]
[32880.588704]  [<ffffffff812d4b50>] scsi_execute+0xf1/0x143
[32880.588706]  [<ffffffff812d4c9f>] scsi_execute_req+0xfd/0x12f
[32880.588709]  [<ffffffff812cf72b>] T.641+0x3a/0x106
[32880.588711]  [<ffffffff810e3136>] ? nameidata_to_filp+0x3a/0x4b
[32880.588713]  [<ffffffff812cf83e>] scsi_set_medium_removal+0x47/0x6c
[32880.588717]  [<ffffffffa0097220>] sr_lock_door+0x1b/0x1d [sr_mod]
[32880.588721]  [<ffffffffa00875e6>] cdrom_release+0x17f/0x1dd [cdrom]
[32880.588723]  [<ffffffff8122f4c0>] ? __blkdev_driver_ioctl+0x90/0x9e
[32880.588726]  [<ffffffffa0096402>] sr_block_release+0x19/0x27 [sr_mod]
[32880.588729]  [<ffffffff8110be7e>] __blkdev_put+0x8b/0x166
[32880.588731]  [<ffffffff8110aefa>] ? block_ioctl+0x32/0x36
[32880.588734]  [<ffffffff8110bf64>] blkdev_put+0xb/0xd
[32880.588736]  [<ffffffff8110bf9f>] blkdev_close+0x39/0x3e
[32880.588738]  [<ffffffff810e5645>] fput+0x109/0x1c8
[32880.588740]  [<ffffffff810e2b41>] filp_close+0x63/0x6d
[32880.588742]  [<ffffffff810e2bf3>] sys_close+0xa8/0xe2
[32880.588745]  [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
[32907.121015] ata9: SRST failed (errno=-16)
[32907.121025] ata9: soft resetting link
[32912.153011] ata9: SRST failed (errno=-16)
[32912.153015] ata9: reset failed, giving up
[32912.153017] ata9.00: disabled
[32917.160013] ata9: link is slow to respond, please be patient (ready=0)
[32922.208016] ata9: device not ready (errno=-16), forcing hardreset
[32922.208025] ata9: soft resetting link
[32927.401025] ata9: link is slow to respond, please be patient (ready=0)
[32932.225025] ata9: SRST failed (errno=-16)
[32932.225035] ata9: soft resetting link
[32937.437017] ata9: link is slow to respond, please be patient (ready=0)
[32942.261018] ata9: SRST failed (errno=-16)
[32942.261028] ata9: soft resetting link
[32947.461016] ata9: link is slow to respond, please be patient (ready=0)
[32977.277018] ata9: SRST failed (errno=-16)
[32977.277029] ata9: soft resetting link
[32977.433092] ata9: EH complete
[38328.708572] [drm:radeon_dvi_detect] *ERROR* DVI-I-1: probed a monitor but no|invalid EDID
[38771.138173] XFS mounting filesystem sdg2
[38771.193454] Ending clean XFS mount for filesystem: sdg2
[38781.717662] XFS mounting filesystem sdg2
[38781.741483] Ending clean XFS mount for filesystem: sdg2
[38802.744737] XFS mounting filesystem sdg2
[38802.785366] Ending clean XFS mount for filesystem: sdg2
[38893.006372] XFS mounting filesystem sdg2
[38893.055537] Ending clean XFS mount for filesystem: sdg2
[38937.435516] XFS mounting filesystem sdg2
[38937.484595] Ending clean XFS mount for filesystem: sdg2

Best regards,
--Edwin
