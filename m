Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab0KEAXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 20:23:03 -0400
Received: from atl.turmel.org ([74.117.157.138]:33000 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab0KEAW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 20:22:58 -0400
Message-ID: <4CD34E5A.1060006@turmel.org>
Date: Thu, 04 Nov 2010 20:22:50 -0400
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101023 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: nouveau@lists.freedesktop.org
CC: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Lockdep splat in nouveau, 2.6.37-rc1+
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------070505070207010601090009"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070505070207010601090009
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Complete dmesg attached, but the highlight is:

[ 6100.827158] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
[ 6100.827158] 2.6.37-rc1-00027-gff8b16d #1
[ 6100.827158] ------------------------------------------------------
[ 6100.827158] kwin_opengl_tes/8245 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[ 6100.827158]  (&(&dev_priv->ramin_lock)->rlock){+.+...}, at: [<ffffffff8161b9ff>] nouveau_gpuobj_del+0x6f/0x150
[ 6100.827158]
[ 6100.827158] and this task is already holding:
[ 6100.827158]  (&(&dev_priv->context_switch_lock)->rlock){-.....}, at: [<ffffffff816185c9>] nouveau_channel_free+0xf9/0x2c0
[ 6100.827158] which would create a new lock dependency:
[ 6100.827158]  (&(&dev_priv->context_switch_lock)->rlock){-.....} -> (&(&dev_priv->ramin_lock)->rlock){+.+...}

{snip /}

with a gpu lockup mixed in...

[ 6100.827158] [drm] nouveau 0000:01:00.0: GPU lockup - switching to software fbcon
[ 6100.827158] [<ffffffff81b689c3>] do_IRQ+0x73/0xf0
[ 6100.827158]   [<ffffffff81b682d3>] ret_from_intr+0x0/0xf
[ 6100.827158]   [<ffffffff81b62d48>] printk+0x41/0x43
[ 6100.827158]   [<ffffffff81618fd3>] nouveau_channel_alloc+0x703/0x7a0

{snip /}

The chipset is an NV50, so I've been putting up with occasional lockups anyways, but with v2.6.36-rc and above, they've become much more common (minutes vs. hours).  I can't tell for sure if they are the same kind of lockup.  I rebuilt my kernel with lockdep to try finding something useful.

One other note:  this gpu lockup leaves the cursor functional for a short time, during which I can use sysrq to blindly sync my drives and reboot.  If I wait, the cursor locks up too, and sysrq ceases to work.

I willing to take debug patches if anyone has any ideas.

Regards,

Phil Turmel

--------------070505070207010601090009
Content-Type: text/plain;
 name="nouveau-lockup-2.6.37-rc1+.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nouveau-lockup-2.6.37-rc1+.dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.37-rc1-00027-gff8b16d (root@scorpius) (gcc version 4.4.5 (Gentoo 4.4.5 p1.0, pie-0.4.5) ) #1 SMP PREEMPT Wed Nov 3 20:27:31 EDT 2010
[    0.000000] Command line: debug root=LABEL=Root   snd_hda_intel.model=toshia-s06 raid=noautodetect selinux=0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
[    0.000000]  BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 00000000000eee00 (reserved)
[    0.000000]  BIOS-e820: 00000000000eee00 - 00000000000ef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000000ef000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bff40000 (usable)
[    0.000000]  BIOS-e820: 00000000bff40000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec28000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00500 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffa00000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffd00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Portable PC/TECRA A9, BIOS Version 2.00 03/06/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-EFFFF write-back
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FEDA0000 mask FFFFE0000 write-back
[    0.000000]   1 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbff40 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bff40000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bff40000 page 4k
[    0.000000] kernel direct mapping tables up to bff40000 @ 1fffb000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ bff3a000-bff40000
[    0.000000] RAMDISK: 3787f000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f01e0 00014 (v00 TOSHIB)
[    0.000000] ACPI: RSDT 00000000bff40000 00054 (v01 TOSHIB A0056    20070816 TASM 04010000)
[    0.000000] ACPI: FACP 00000000bff40080 00084 (v02 TOSHIB A0056    20070816 TASM 04010000)
[    0.000000] ACPI: DSDT 00000000bff40104 0635F (v02 TOSHIB A0056    20080108 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000000eee00 00040
[    0.000000] ACPI: SSDT 00000000bff46463 00506 (v02 TOSHIB A0056    20061102 MSFT 03000000)
[    0.000000] ACPI: BOOT 00000000bff40058 00028 (v01 TOSHIB A0056    20070816 TASM 04010000)
[    0.000000] ACPI: APIC 00000000bff46dff 00068 (v01 TOSHIB A0056    20070816 TASM 04010000)
[    0.000000] ACPI: MCFG 00000000bff46e67 0003C (v01 TOSHIB A0056    20070816 TASM 04010000)
[    0.000000] ACPI: HPET 00000000bff46ed7 00038 (v01 TOSHIB A0056    20070816 TASM 04010000)
[    0.000000] ACPI: TCPA 00000000bff47085 00032 (v02 TOSHIB A0056    20070816 TASM 04010000)
[    0.000000] ACPI: SLIC 00000000bff46f0f 00176 (v01 TOSHIB A0056    20070816 TASM 04010000)
[    0.000000] ACPI: ASF! 00000000bff470b7 00075 (v16 TOSHIB A0056    20070816 TASM 04010000)
[    0.000000] ACPI: SSDT 00000000bff47bcb 005E1 (v02 TOSHIB A0056    20061220 MSFT 03000000)
[    0.000000] ACPI: SSDT 00000000bff4712c 00076 (v02 TOSHIB A0056    20051021 MSFT 03000000)
[    0.000000] ACPI: SSDT 00000000bff471a2 00A29 (v02 TOSHIB A0056    20061226 MSFT 03000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000013c000000
[    0.000000] Initmem setup node 0 0000000000000000-000000013c000000
[    0.000000]   NODE_DATA [000000013bffb000 - 000000013bffffff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880137e00000-ffff88013b5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009b
[    0.000000]     0: 0x00000100 -> 0x000bff40
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1031883
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3917 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 767864 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xd808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
[    0.000000] PM: Registered nosave memory: 00000000000e8000 - 00000000000ee000
[    0.000000] PM: Registered nosave memory: 00000000000ee000 - 00000000000ef000
[    0.000000] PM: Registered nosave memory: 00000000000ef000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bff40000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec28000
[    0.000000] PM: Registered nosave memory: 00000000fec28000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000fedc0000
[    0.000000] PM: Registered nosave memory: 00000000fedc0000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffa00000
[    0.000000] PM: Registered nosave memory: 00000000ffa00000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 00000000ffd00000
[    0.000000] PM: Registered nosave memory: 00000000ffd00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:3ec00000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff8800bfa00000 s1915392 r8192 d22016 u2097152
[    0.000000] pcpu-alloc: s1915392 r8192 d22016 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1014181
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: debug root=LABEL=Root   snd_hda_intel.model=toshia-s06 raid=noautodetect selinux=0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3958432k/5177344k available (11694k kernel code, 1049812k absent, 169100k reserved, 9043k data, 2832k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] ^IRCU debugfs-based tracing is enabled.
[    0.000000] ^IRCU lockdep checking is enabled.
[    0.000000] NR_IRQS:2304
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2194.700 MHz processor.
[    0.003348] Calibrating delay loop (skipped), value calculated using timer frequency.. 4391.29 BogoMIPS (lpj=7315666)
[    0.003593] pid_max: default: 32768 minimum: 301
[    0.004353] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.008618] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.010089] Mount-cache hash table entries: 256
[    0.011329] Initializing cgroup subsys cpuacct
[    0.011460] Initializing cgroup subsys net_cls
[    0.011672] CPU: Physical Processor ID: 0
[    0.011793] CPU: Processor Core ID: 0
[    0.011914] mce: CPU supports 6 MCE banks
[    0.012041] CPU0: Thermal monitoring handled by SMI
[    0.012168] using mwait in idle threads.
[    0.012288] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.012603] PEBS disabled due to CPU errata.
[    0.012735] ... version:                2
[    0.012856] ... bit width:              40
[    0.012976] ... generic registers:      2
[    0.013096] ... value mask:             000000ffffffffff
[    0.013219] ... max period:             000000007fffffff
[    0.013340] ... fixed-purpose events:   3
[    0.013461] ... event mask:             0000000700000003
[    0.013691] ACPI: Core revision 20101013
[    0.034193] ftrace: allocating 35565 entries in 140 pages
[    0.036872] Setting APIC routing to flat
[    0.037572] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.071709] CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
[    0.086713] lockdep: fixing up alternatives.
[    0.090166] Booting Node   0, Processors  #1 Ok.
[    0.006666] CPU1: Thermal monitoring handled by SMI
[    0.186744] Brought up 2 CPUs
[    0.186996] Total of 2 processors activated (8781.19 BogoMIPS).
[    0.187923] devtmpfs: initialized
[    0.190687] xor: automatically using best checksumming function: generic_sse
[    0.206674]    generic_sse:  7533.600 MB/sec
[    0.206795] xor: using function: generic_sse (7533.600 MB/sec)
[    0.206960] NET: Registered protocol family 16
[    0.207124] ACPI: bus type pci registered
[    0.207207] dca service started, version 1.12.1
[    0.207207] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.210009] PCI: not using MMCONFIG
[    0.210130] PCI: Using configuration type 1 for base access
[    0.243481] bio: create slab <bio-0> at 0
[    0.300045] raid6: int64x1   1703 MB/s
[    0.356682] raid6: int64x2   2166 MB/s
[    0.413348] raid6: int64x4   1658 MB/s
[    0.470008] raid6: int64x8   1474 MB/s
[    0.526681] raid6: sse2x1    3670 MB/s
[    0.583342] raid6: sse2x2    3874 MB/s
[    0.640011] raid6: sse2x4    6527 MB/s
[    0.640131] raid6: using algorithm sse2x4 (6527 MB/s)
[    0.650365] ACPI: EC: Look up EC in DSDT
[    0.661081] ACPI: Actual Package length (12) is larger than NumElements field (5), truncated
[    0.661324]
[    0.667158] ACPI Warning: Incorrect checksum in table [ASF!] - 0xE9, should be 0x94 (20101013/tbutils-314)
[    0.667845] ACPI: SSDT 00000000bff46b71 000F3 (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.670782] ACPI: Dynamic OEM Table Load:
[    0.671029] ACPI: SSDT           (null) 000F3 (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.671423] ACPI: SSDT 00000000bff46cda 0006C (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.674477] ACPI: Dynamic OEM Table Load:
[    0.674722] ACPI: SSDT           (null) 0006C (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.675381] ACPI: SSDT 00000000bff46c64 00076 (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.679220] ACPI: Dynamic OEM Table Load:
[    0.679467] ACPI: SSDT           (null) 00076 (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.680095] ACPI: SSDT 00000000bff46d46 00079 (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.682944] ACPI: Dynamic OEM Table Load:
[    0.683189] ACPI: SSDT           (null) 00079 (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.684322] ACPI: Interpreter enabled
[    0.684445] ACPI: (supports S0 S3 S4 S5)
[    0.684874] ACPI: Using IOAPIC for interrupt routing
[    0.685043] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.697071] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in ACPI motherboard resources
[    0.775396] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    0.775523] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.775873] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.776948] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.777074] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.777197] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.777375] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.777554] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xefffffff]
[    0.777730] pci_root PNP0A08:00: host bridge window [mem 0xf4000000-0xfebfffff]
[    0.777909] pci_root PNP0A08:00: host bridge window [mem 0xfec28000-0xfecfffff]
[    0.778087] pci_root PNP0A08:00: host bridge window [mem 0xfed00500-0xfed13fff]
[    0.778264] pci_root PNP0A08:00: host bridge window [mem 0xfed1a000-0xfed1bfff]
[    0.778441] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    0.778618] pci_root PNP0A08:00: host bridge window [mem 0xfed90000-0xfed9ffff]
[    0.778795] pci_root PNP0A08:00: host bridge window [mem 0xfedc0000-0xfedfffff]
[    0.778973] pci_root PNP0A08:00: host bridge window [mem 0xfee01000-0xff9fffff]
[    0.779150] pci_root PNP0A08:00: host bridge window [mem 0xffc00000-0xffcfffff]
[    0.779372] pci 0000:00:00.0: [8086:2a00] type 0 class 0x000600
[    0.779655] pci 0000:00:01.0: [8086:2a01] type 1 class 0x000604
[    0.780106] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.780233] pci 0000:00:01.0: PME# disabled
[    0.780399] pci 0000:00:03.0: [8086:2a04] type 0 class 0x000780
[    0.780560] pci 0000:00:03.0: reg 10: [mem 0xffcffff0-0xffcfffff 64bit]
[    0.780789] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.780915] pci 0000:00:03.0: PME# disabled
[    0.781185] pci 0000:00:19.0: [8086:1049] type 0 class 0x000200
[    0.781350] pci 0000:00:19.0: reg 10: [mem 0xffcc0000-0xffcdffff]
[    0.781493] pci 0000:00:19.0: reg 14: [mem 0xffcfe000-0xffcfefff]
[    0.781635] pci 0000:00:19.0: reg 18: [io  0xbfe0-0xbfff]
[    0.781885] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.782013] pci 0000:00:19.0: PME# disabled
[    0.782164] pci 0000:00:1a.0: [8086:2834] type 0 class 0x000c03
[    0.782388] pci 0000:00:1a.0: reg 20: [io  0xbf80-0xbf9f]
[    0.782582] pci 0000:00:1a.1: [8086:2835] type 0 class 0x000c03
[    0.782806] pci 0000:00:1a.1: reg 20: [io  0x0000-0x001f]
[    0.783031] pci 0000:00:1a.7: [8086:283a] type 0 class 0x000c03
[    0.783194] pci 0000:00:1a.7: reg 10: [mem 0xffcff800-0xffcffbff]
[    0.783685] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.783814] pci 0000:00:1a.7: PME# disabled
[    0.783985] pci 0000:00:1b.0: [8086:284b] type 0 class 0x000403
[    0.784145] pci 0000:00:1b.0: reg 10: [mem 0x00000000-0x00003fff 64bit]
[    0.784422] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.784551] pci 0000:00:1b.0: PME# disabled
[    0.784721] pci 0000:00:1c.0: [8086:283f] type 1 class 0x000604
[    0.784998] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.785126] pci 0000:00:1c.0: PME# disabled
[    0.785313] pci 0000:00:1c.1: [8086:2841] type 1 class 0x000604
[    0.785594] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.785722] pci 0000:00:1c.1: PME# disabled
[    0.785900] pci 0000:00:1c.2: [8086:2843] type 1 class 0x000604
[    0.786177] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.786306] pci 0000:00:1c.2: PME# disabled
[    0.786490] pci 0000:00:1d.0: [8086:2830] type 0 class 0x000c03
[    0.786773] pci 0000:00:1d.0: reg 20: [io  0x9fe0-0x9fff]
[    0.786968] pci 0000:00:1d.1: [8086:2831] type 0 class 0x000c03
[    0.787192] pci 0000:00:1d.1: reg 20: [io  0x9f80-0x9f9f]
[    0.787385] pci 0000:00:1d.2: [8086:2832] type 0 class 0x000c03
[    0.787609] pci 0000:00:1d.2: reg 20: [io  0x9f60-0x9f7f]
[    0.787830] pci 0000:00:1d.7: [8086:2836] type 0 class 0x000c03
[    0.787992] pci 0000:00:1d.7: reg 10: [mem 0xffcff400-0xffcff7ff]
[    0.788280] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.788409] pci 0000:00:1d.7: PME# disabled
[    0.788569] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.788846] pci 0000:00:1f.0: [8086:2811] type 0 class 0x000601
[    0.789152] pci 0000:00:1f.0: quirk: [io  0xd800-0xd87f] claimed by ICH6 ACPI/GPIO/TCO
[    0.789333] pci 0000:00:1f.0: quirk: [io  0xeec0-0xeeff] claimed by ICH6 GPIO
[    0.789462] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.789648] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 01e0 (mask 000f)
[    0.789891] pci 0000:00:1f.1: [8086:2850] type 0 class 0x000101
[    0.790032] pci 0000:00:1f.1: reg 10: [io  0x9f58-0x9f5f]
[    0.790173] pci 0000:00:1f.1: reg 14: [io  0x9f54-0x9f57]
[    0.790316] pci 0000:00:1f.1: reg 18: [io  0x9f48-0x9f4f]
[    0.790457] pci 0000:00:1f.1: reg 1c: [io  0x9f44-0x9f47]
[    0.790597] pci 0000:00:1f.1: reg 20: [io  0x9f30-0x9f3f]
[    0.790813] pci 0000:00:1f.2: [8086:2829] type 0 class 0x000106
[    0.790981] pci 0000:00:1f.2: reg 10: [io  0x9f28-0x9f2f]
[    0.791122] pci 0000:00:1f.2: reg 14: [io  0x9f24-0x9f27]
[    0.791262] pci 0000:00:1f.2: reg 18: [io  0x9f18-0x9f1f]
[    0.791403] pci 0000:00:1f.2: reg 1c: [io  0x9f14-0x9f17]
[    0.791543] pci 0000:00:1f.2: reg 20: [io  0x9ee0-0x9eff]
[    0.791685] pci 0000:00:1f.2: reg 24: [mem 0xffcfd800-0xffcfdfff]
[    0.791893] pci 0000:00:1f.2: PME# supported from D3hot
[    0.792021] pci 0000:00:1f.2: PME# disabled
[    0.792301] pci 0000:01:00.0: [10de:042a] type 0 class 0x000300
[    0.792453] pci 0000:01:00.0: reg 10: [mem 0xfd000000-0xfdffffff]
[    0.792610] pci 0000:01:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.792770] pci 0000:01:00.0: reg 1c: [mem 0xfa000000-0xfbffffff 64bit]
[    0.792916] pci 0000:01:00.0: reg 24: [io  0xcf00-0xcf7f]
[    0.793062] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.800043] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.800170] pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
[    0.800299] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfdffffff]
[    0.800432] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.800766] pci 0000:02:00.0: [8086:4229] type 0 class 0x000280
[    0.800947] pci 0000:02:00.0: reg 10: [mem 0xff9fe000-0xff9fffff 64bit]
[    0.801308] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.801440] pci 0000:02:00.0: PME# disabled
[    0.801668] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.801798] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.801936] pci 0000:00:1c.0:   bridge window [mem 0xff900000-0xff9fffff]
[    0.802072] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.802363] pci 0000:00:1c.1: PCI bridge to [bus 03-04]
[    0.802491] pci 0000:00:1c.1:   bridge window [io  0xa000-0xafff]
[    0.802621] pci 0000:00:1c.1:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.802757] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.803048] pci 0000:00:1c.2: PCI bridge to [bus 05-05]
[    0.803182] pci 0000:00:1c.2:   bridge window [io  0xf000-0x0000] (disabled)
[    0.803312] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.803365] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.803666] pci 0000:06:0b.0: [104c:8039] type 2 class 0x000607
[    0.803829] pci 0000:06:0b.0: reg 10: [mem 0x00000000-0x00000fff]
[    0.804002] pci 0000:06:0b.0: supports D1 D2
[    0.804125] pci 0000:06:0b.0: PME# supported from D0 D1 D2 D3hot
[    0.804295] pci 0000:06:0b.0: PME# disabled
[    0.804454] pci 0000:06:0b.1: [104c:803a] type 0 class 0x000c00
[    0.804619] pci 0000:06:0b.1: reg 10: [mem 0x00000000-0x000007ff]
[    0.804767] pci 0000:06:0b.1: reg 14: [mem 0x00000000-0x00003fff]
[    0.805048] pci 0000:06:0b.1: supports D1 D2
[    0.805169] pci 0000:06:0b.1: PME# supported from D0 D1 D2 D3hot
[    0.805301] pci 0000:06:0b.1: PME# disabled
[    0.805459] pci 0000:06:0b.2: [104c:803b] type 0 class 0x000180
[    0.805626] pci 0000:06:0b.2: reg 10: [mem 0x00000000-0x00000fff]
[    0.805921] pci 0000:06:0b.2: supports D1 D2
[    0.806043] pci 0000:06:0b.2: PME# supported from D0 D1 D2 D3hot
[    0.806181] pci 0000:06:0b.2: PME# disabled
[    0.806340] pci 0000:06:0b.3: [104c:803c] type 0 class 0x000805
[    0.806682] pci 0000:06:0b.3: reg 10: [mem 0x00000000-0x000000ff]
[    0.806977] pci 0000:06:0b.3: supports D1 D2
[    0.807098] pci 0000:06:0b.3: PME# supported from D0 D1 D2 D3hot
[    0.807230] pci 0000:06:0b.3: PME# disabled
[    0.807451] pci 0000:00:1e.0: PCI bridge to [bus 06-07] (subtractive decode)
[    0.807582] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.807712] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.807902] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.808081] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.808262] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.808441] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.808621] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.809921] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xefffffff] (subtractive decode)
[    0.810006] pci 0000:00:1e.0:   bridge window [mem 0xf4000000-0xfebfffff] (subtractive decode)
[    0.810187] pci 0000:00:1e.0:   bridge window [mem 0xfec28000-0xfecfffff] (subtractive decode)
[    0.810368] pci 0000:00:1e.0:   bridge window [mem 0xfed00500-0xfed13fff] (subtractive decode)
[    0.810549] pci 0000:00:1e.0:   bridge window [mem 0xfed1a000-0xfed1bfff] (subtractive decode)
[    0.810729] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.810910] pci 0000:00:1e.0:   bridge window [mem 0xfed90000-0xfed9ffff] (subtractive decode)
[    0.811090] pci 0000:00:1e.0:   bridge window [mem 0xfedc0000-0xfedfffff] (subtractive decode)
[    0.811270] pci 0000:00:1e.0:   bridge window [mem 0xfee01000-0xff9fffff] (subtractive decode)
[    0.811451] pci 0000:00:1e.0:   bridge window [mem 0xffc00000-0xffcfffff] (subtractive decode)
[    0.811720] pci_bus 0000:07: [bus 07-0a] partially hidden behind transparent bridge 0000:06 [bus 06-07]
[    0.811960] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.812402] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.812888] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MPEX._PRT]
[    0.813127] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXCB._PRT]
[    0.813431] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.813659] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.833576] ACPI: PCI Interrupt Link [LNKA] (IRQs *10)
[    0.834048] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *11)
[    0.834835] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *11)
[    0.835616] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *11)
[    0.836958] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *11)
[    0.837742] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *11)
[    0.838523] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *11)
[    0.839304] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11)
[    0.840169] HEST: Table is not found!
[    0.840395] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.840395] vgaarb: loaded
[    0.840534] SCSI subsystem initialized
[    0.840534] libata version 3.00 loaded.
[    0.840534] usbcore: registered new interface driver usbfs
[    0.840534] usbcore: registered new interface driver hub
[    0.843400] usbcore: registered new device driver usb
[    0.843541] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.843568] PCI: Using ACPI for IRQ routing
[    0.843691] PCI: pci_cache_line_size set to 64 bytes
[    0.844146] reserve RAM buffer: 000000000009bc00 - 000000000009ffff
[    0.844221] reserve RAM buffer: 00000000bff40000 - 00000000bfffffff
[    0.844482] NET: Registered protocol family 23
[    0.846859] Bluetooth: Core ver 2.15
[    0.847189] NET: Registered protocol family 31
[    0.847189] Bluetooth: HCI device and connection manager initialized
[    0.847189] Bluetooth: HCI socket layer initialized
[    0.847189] NET: Registered protocol family 8
[    0.847221] NET: Registered protocol family 20
[    0.847408] cfg80211: Calling CRDA to update world regulatory domain
[    0.847408] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.853453] Switching to clocksource tsc
[    0.907742] pnp: PnP ACPI init
[    0.907945] ACPI: bus type pnp registered
[    0.908924] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.909048] pnp 00:00: [mem 0x000e8000-0x000fffff]
[    0.909170] pnp 00:00: [mem 0x00100000-0xbff3ffff]
[    0.909293] pnp 00:00: [mem 0xbff40000-0xbff4ffff]
[    0.909414] pnp 00:00: [mem 0xbff50000-0xbfffffff]
[    0.909537] pnp 00:00: [mem 0xfec00000-0xfec27fff]
[    0.909674] pnp 00:00: [mem 0xfed00400-0xfed004ff]
[    0.909797] pnp 00:00: [mem 0xfed14000-0xfed19fff]
[    0.909919] pnp 00:00: [mem 0xfed1c000-0xfed1ffff]
[    0.910042] pnp 00:00: [mem 0xfed20000-0xfed3ffff]
[    0.910165] pnp 00:00: [mem 0xfed45000-0xfed8ffff]
[    0.910287] pnp 00:00: [mem 0xfeda0000-0xfedbffff]
[    0.910409] pnp 00:00: [mem 0xfee00000-0xfee00fff]
[    0.910533] pnp 00:00: [mem 0xffa00000-0xffbfffff]
[    0.910654] pnp 00:00: [mem 0xffd00000-0xffffffff]
[    0.910781] pnp 00:00: [mem 0x100000000-0x13bffffff]
[    0.911291] pnp 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.926659] pnp 00:01: [mem 0xf0000000-0xf3ffffff]
[    0.927056] pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.939634] pnp 00:02: [bus 00-ff]
[    0.939755] pnp 00:02: [io  0x0cf8-0x0cff]
[    0.939877] pnp 00:02: [io  0x0000-0x0cf7 window]
[    0.939999] pnp 00:02: [io  0x0d00-0xffff window]
[    0.940121] pnp 00:02: [mem 0x000a0000-0x000bffff window]
[    0.940245] pnp 00:02: [mem 0x000d0000-0x000dffff window]
[    0.940368] pnp 00:02: [mem 0xc0000000-0xefffffff window]
[    0.940491] pnp 00:02: [mem 0xf4000000-0xfebfffff window]
[    0.940615] pnp 00:02: [mem 0xfec28000-0xfecfffff window]
[    0.940738] pnp 00:02: [mem 0xfed00500-0xfed13fff window]
[    0.940862] pnp 00:02: [mem 0xfed1a000-0xfed1bfff window]
[    0.940985] pnp 00:02: [mem 0xfed40000-0xfed44fff window]
[    0.941109] pnp 00:02: [mem 0xfed90000-0xfed9ffff window]
[    0.941234] pnp 00:02: [mem 0xfedc0000-0xfedfffff window]
[    0.941356] pnp 00:02: [mem 0xfee01000-0xff9fffff window]
[    0.941480] pnp 00:02: [mem 0xffc00000-0xffcfffff window]
[    0.941915] pnp 00:02: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.942400] pnp 00:03: [io  0x0000-0x000f]
[    0.942523] pnp 00:03: [io  0x0081-0x0083]
[    0.942645] pnp 00:03: [io  0x0087]
[    0.942765] pnp 00:03: [io  0x0089-0x008b]
[    0.942887] pnp 00:03: [io  0x008f]
[    0.943019] pnp 00:03: [io  0x00c0-0x00df]
[    0.943140] pnp 00:03: [dma 4]
[    0.943460] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.943634] pnp 00:04: [io  0x0061]
[    0.943957] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.944107] pnp 00:05: [io  0x00f0-0x00ff]
[    0.944244] pnp 00:05: [irq 13]
[    0.944569] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.944747] pnp 00:06: [io  0x0060]
[    0.944868] pnp 00:06: [io  0x0064]
[    0.944997] pnp 00:06: [irq 1]
[    0.945319] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.945503] pnp 00:07: [irq 12]
[    0.945831] pnp 00:07: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.945983] pnp 00:08: [io  0x0070-0x0071]
[    0.946113] pnp 00:08: [irq 8]
[    0.946450] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.947001] pnp 00:09: [io  0x0080]
[    0.947123] pnp 00:09: [io  0x0084-0x0086]
[    0.947245] pnp 00:09: [io  0x0088]
[    0.947365] pnp 00:09: [io  0x008c-0x008e]
[    0.947487] pnp 00:09: [io  0x002e-0x002f]
[    0.947608] pnp 00:09: [io  0x0062]
[    0.947729] pnp 00:09: [io  0x0066]
[    0.947849] pnp 00:09: [io  0x01e0-0x01ef]
[    0.947975] pnp 00:09: [io  0x0480-0x048f]
[    0.948097] pnp 00:09: [io  0xe000-0xe07f]
[    0.948219] pnp 00:09: [io  0xe080-0xe0ff]
[    0.948341] pnp 00:09: [io  0xe400-0xe47f]
[    0.948462] pnp 00:09: [io  0xe480-0xe4ff]
[    0.948582] pnp 00:09: [io  0xe800-0xe87f]
[    0.948704] pnp 00:09: [io  0xe880-0xe8ff]
[    0.948825] pnp 00:09: [io  0xec00-0xec7f]
[    0.948946] pnp 00:09: [io  0xec80-0xecff]
[    0.949068] pnp 00:09: [io  0xd800-0xd87f]
[    0.949194] pnp 00:09: [io  0xd880-0xd89f]
[    0.949316] pnp 00:09: [io  0xeec0-0xeeff]
[    0.949437] pnp 00:09: [io  0x0690-0x06ff]
[    0.949558] pnp 00:09: [io  0x0010-0x001f]
[    0.949694] pnp 00:09: [io  0x0024-0x0025]
[    0.949815] pnp 00:09: [io  0x0028-0x0029]
[    0.949937] pnp 00:09: [io  0x002c-0x002d]
[    0.950057] pnp 00:09: [io  0x0030-0x0031]
[    0.950179] pnp 00:09: [io  0x0034-0x0035]
[    0.950299] pnp 00:09: [io  0x0038-0x0039]
[    0.950421] pnp 00:09: [io  0x003c-0x003d]
[    0.950543] pnp 00:09: [io  0x0050-0x0053]
[    0.950665] pnp 00:09: [io  0x0063]
[    0.950784] pnp 00:09: [io  0x0065]
[    0.950904] pnp 00:09: [io  0x0072-0x0077]
[    0.951026] pnp 00:09: [io  0x0090-0x009f]
[    0.951148] pnp 00:09: [io  0x00a4-0x00a5]
[    0.951269] pnp 00:09: [io  0x00a8-0x00a9]
[    0.951390] pnp 00:09: [io  0x00ac-0x00ad]
[    0.951512] pnp 00:09: [io  0x00b0-0x00b5]
[    0.951634] pnp 00:09: [io  0x00b8-0x00b9]
[    0.951755] pnp 00:09: [io  0x00bc-0x00bd]
[    0.951876] pnp 00:09: [io  0x04d0-0x04d1]
[    0.952030] pnp 00:09: disabling [io  0x0010-0x001f] because it overlaps 0000:00:1a.1 BAR 4 [io  0x0000-0x001f]
[    0.952536] pnp 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.966811] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.966935] pnp 00:0a: [io  0x004e-0x004f]
[    0.967061] pnp 00:0a: [io  0x0680-0x068f]
[    0.967395] pnp 00:0a: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.967613] pnp 00:0b: [mem 0xfed00000-0xfed003ff]
[    0.967948] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.980148] pnp 00:0c: [io  0x03f8-0x03ff]
[    0.980280] pnp 00:0c: [irq 4]
[    0.993545] pnp 00:0c: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.006546] pnp: PnP ACPI: found 13 devices
[    1.006685] ACPI: ACPI bus type pnp unregistered
[    1.006841] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.006968] system 00:00: [mem 0x000e8000-0x000fffff] could not be reserved
[    1.007095] system 00:00: [mem 0x00100000-0xbff3ffff] could not be reserved
[    1.008341] system 00:00: [mem 0xbff40000-0xbff4ffff] has been reserved
[    1.008467] system 00:00: [mem 0xbff50000-0xbfffffff] has been reserved
[    1.008591] system 00:00: [mem 0xfec00000-0xfec27fff] could not be reserved
[    1.008718] system 00:00: [mem 0xfed00400-0xfed004ff] has been reserved
[    1.008845] system 00:00: [mem 0xfed14000-0xfed19fff] has been reserved
[    1.008970] system 00:00: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.009096] system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.009221] system 00:00: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.009348] system 00:00: [mem 0xfeda0000-0xfedbffff] has been reserved
[    1.009474] system 00:00: [mem 0xfee00000-0xfee00fff] has been reserved
[    1.009598] system 00:00: [mem 0xffa00000-0xffbfffff] has been reserved
[    1.009722] system 00:00: [mem 0xffd00000-0xffffffff] has been reserved
[    1.009846] system 00:00: [mem 0x100000000-0x13bffffff] could not be reserved
[    1.009988] system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
[    1.010152] system 00:09: [io  0x01e0-0x01ef] has been reserved
[    1.010278] system 00:09: [io  0x0480-0x048f] has been reserved
[    1.010404] system 00:09: [io  0xe000-0xe07f] has been reserved
[    1.010529] system 00:09: [io  0xe080-0xe0ff] has been reserved
[    1.010653] system 00:09: [io  0xe400-0xe47f] has been reserved
[    1.010777] system 00:09: [io  0xe480-0xe4ff] has been reserved
[    1.010901] system 00:09: [io  0xe800-0xe87f] has been reserved
[    1.011025] system 00:09: [io  0xe880-0xe8ff] has been reserved
[    1.011149] system 00:09: [io  0xec00-0xec7f] has been reserved
[    1.011274] system 00:09: [io  0xec80-0xecff] has been reserved
[    1.011398] system 00:09: [io  0xd800-0xd87f] has been reserved
[    1.011524] system 00:09: [io  0xd880-0xd89f] has been reserved
[    1.011649] system 00:09: [io  0xeec0-0xeeff] has been reserved
[    1.011773] system 00:09: [io  0x0690-0x06ff] has been reserved
[    1.011898] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    1.029264] pci 0000:00:1e.0: BAR 15: assigned [mem 0xf4000000-0xf7ffffff pref]
[    1.029458] pci 0000:00:1e.0: BAR 14: assigned [mem 0xda000000-0xdfffffff]
[    1.029592] pci 0000:00:1c.1: BAR 15: assigned [mem 0xff700000-0xff8fffff 64bit pref]
[    1.029773] pci 0000:00:1b.0: BAR 0: assigned [mem 0xffcf8000-0xffcfbfff 64bit]
[    1.029963] pci 0000:00:1b.0: BAR 0: set to [mem 0xffcf8000-0xffcfbfff 64bit] (PCI address [0xffcf8000-0xffcfbfff])
[    1.030161] pci 0000:00:1e.0: BAR 13: assigned [io  0xf000-0xffff]
[    1.030288] pci 0000:00:1a.1: BAR 4: assigned [io  0xdce0-0xdcff]
[    1.030417] pci 0000:00:1a.1: BAR 4: set to [io  0xdce0-0xdcff] (PCI address [0xdce0-0xdcff])
[    1.030600] pci 0000:01:00.0: BAR 6: assigned [mem 0xfcfe0000-0xfcffffff pref]
[    1.030780] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.030904] pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
[    1.031034] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfdffffff]
[    1.031163] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    1.031349] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.031471] pci 0000:00:1c.0:   bridge window [io  disabled]
[    1.031602] pci 0000:00:1c.0:   bridge window [mem 0xff900000-0xff9fffff]
[    1.031731] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    1.031866] pci 0000:00:1c.1: PCI bridge to [bus 03-04]
[    1.031992] pci 0000:00:1c.1:   bridge window [io  0xa000-0xafff]
[    1.032123] pci 0000:00:1c.1:   bridge window [mem 0xf8000000-0xf9ffffff]
[    1.032259] pci 0000:00:1c.1:   bridge window [mem 0xff700000-0xff8fffff 64bit pref]
[    1.032448] pci 0000:00:1c.2: PCI bridge to [bus 05-05]
[    1.032570] pci 0000:00:1c.2:   bridge window [io  disabled]
[    1.032701] pci 0000:00:1c.2:   bridge window [mem disabled]
[    1.032830] pci 0000:00:1c.2:   bridge window [mem pref disabled]
[    1.032972] pci 0000:06:0b.0: BAR 15: assigned [mem 0xf4000000-0xf7ffffff pref]
[    1.033162] pci 0000:06:0b.0: BAR 16: assigned [mem 0xd4000000-0xd7ffffff]
[    1.033289] pci 0000:06:0b.1: BAR 1: assigned [mem 0xffcf4000-0xffcf7fff]
[    1.033436] pci 0000:06:0b.1: BAR 1: set to [mem 0xffcf4000-0xffcf7fff] (PCI address [0xffcf4000-0xffcf7fff])
[    1.033624] pci 0000:06:0b.0: BAR 0: assigned [mem 0xffcfc000-0xffcfcfff]
[    1.033757] pci 0000:06:0b.0: BAR 0: set to [mem 0xffcfc000-0xffcfcfff] (PCI address [0xffcfc000-0xffcfcfff])
[    1.033940] pci 0000:06:0b.2: BAR 0: assigned [mem 0xffcf3000-0xffcf3fff]
[    1.034071] pci 0000:06:0b.2: BAR 0: set to [mem 0xffcf3000-0xffcf3fff] (PCI address [0xffcf3000-0xffcf3fff])
[    1.034254] pci 0000:06:0b.1: BAR 0: assigned [mem 0xffcfd000-0xffcfd7ff]
[    1.034386] pci 0000:06:0b.1: BAR 0: set to [mem 0xffcfd000-0xffcfd7ff] (PCI address [0xffcfd000-0xffcfd7ff])
[    1.034570] pci 0000:06:0b.0: BAR 13: assigned [io  0xfc00-0xfcff]
[    1.034694] pci 0000:06:0b.0: BAR 14: assigned [io  0xf800-0xf8ff]
[    1.034818] pci 0000:06:0b.3: BAR 0: assigned [mem 0xffcffe00-0xffcffeff]
[    1.034950] pci 0000:06:0b.3: BAR 0: set to [mem 0xffcffe00-0xffcffeff] (PCI address [0xffcffe00-0xffcffeff])
[    1.035132] pci 0000:06:0b.0: CardBus bridge to [bus 07-0a]
[    1.035256] pci 0000:06:0b.0:   bridge window [io  0xfc00-0xfcff]
[    1.035386] pci 0000:06:0b.0:   bridge window [io  0xf800-0xf8ff]
[    1.035516] pci 0000:06:0b.0:   bridge window [mem 0xf4000000-0xf7ffffff pref]
[    1.035701] pci 0000:06:0b.0:   bridge window [mem 0xd4000000-0xd7ffffff]
[    1.035832] pci 0000:00:1e.0: PCI bridge to [bus 06-07]
[    1.035957] pci 0000:00:1e.0:   bridge window [io  0xf000-0xffff]
[    1.036089] pci 0000:00:1e.0:   bridge window [mem 0xda000000-0xdfffffff]
[    1.036219] pci 0000:00:1e.0:   bridge window [mem 0xf4000000-0xf7ffffff pref]
[    1.036438] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.036568] pci 0000:00:01.0: setting latency timer to 64
[    1.036733] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.036862] pci 0000:00:1c.0: setting latency timer to 64
[    1.037004] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.037132] pci 0000:00:1c.1: setting latency timer to 64
[    1.037278] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.037408] pci 0000:00:1c.2: setting latency timer to 64
[    1.037546] pci 0000:00:1e.0: setting latency timer to 64
[    1.037686] pci 0000:06:0b.0: enabling device (0000 -> 0003)
[    1.037820] pci 0000:06:0b.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.037956] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.038079] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.038202] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.038325] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    1.038449] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xefffffff]
[    1.038574] pci_bus 0000:00: resource 9 [mem 0xf4000000-0xfebfffff]
[    1.038697] pci_bus 0000:00: resource 10 [mem 0xfec28000-0xfecfffff]
[    1.038822] pci_bus 0000:00: resource 11 [mem 0xfed00500-0xfed13fff]
[    1.038947] pci_bus 0000:00: resource 12 [mem 0xfed1a000-0xfed1bfff]
[    1.039071] pci_bus 0000:00: resource 13 [mem 0xfed40000-0xfed44fff]
[    1.039196] pci_bus 0000:00: resource 14 [mem 0xfed90000-0xfed9ffff]
[    1.039320] pci_bus 0000:00: resource 15 [mem 0xfedc0000-0xfedfffff]
[    1.039446] pci_bus 0000:00: resource 16 [mem 0xfee01000-0xff9fffff]
[    1.039571] pci_bus 0000:00: resource 17 [mem 0xffc00000-0xffcfffff]
[    1.039695] pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
[    1.039819] pci_bus 0000:01: resource 1 [mem 0xfa000000-0xfdffffff]
[    1.039944] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff 64bit pref]
[    1.040137] pci_bus 0000:02: resource 1 [mem 0xff900000-0xff9fffff]
[    1.040260] pci_bus 0000:03: resource 0 [io  0xa000-0xafff]
[    1.040383] pci_bus 0000:03: resource 1 [mem 0xf8000000-0xf9ffffff]
[    1.040507] pci_bus 0000:03: resource 2 [mem 0xff700000-0xff8fffff 64bit pref]
[    1.040686] pci_bus 0000:06: resource 0 [io  0xf000-0xffff]
[    1.040810] pci_bus 0000:06: resource 1 [mem 0xda000000-0xdfffffff]
[    1.040935] pci_bus 0000:06: resource 2 [mem 0xf4000000-0xf7ffffff pref]
[    1.041060] pci_bus 0000:06: resource 4 [io  0x0000-0x0cf7]
[    1.041184] pci_bus 0000:06: resource 5 [io  0x0d00-0xffff]
[    1.041308] pci_bus 0000:06: resource 6 [mem 0x000a0000-0x000bffff]
[    1.041431] pci_bus 0000:06: resource 7 [mem 0x000d0000-0x000dffff]
[    1.041555] pci_bus 0000:06: resource 8 [mem 0xc0000000-0xefffffff]
[    1.041679] pci_bus 0000:06: resource 9 [mem 0xf4000000-0xfebfffff]
[    1.041803] pci_bus 0000:06: resource 10 [mem 0xfec28000-0xfecfffff]
[    1.041927] pci_bus 0000:06: resource 11 [mem 0xfed00500-0xfed13fff]
[    1.042052] pci_bus 0000:06: resource 12 [mem 0xfed1a000-0xfed1bfff]
[    1.042175] pci_bus 0000:06: resource 13 [mem 0xfed40000-0xfed44fff]
[    1.042299] pci_bus 0000:06: resource 14 [mem 0xfed90000-0xfed9ffff]
[    1.042423] pci_bus 0000:06: resource 15 [mem 0xfedc0000-0xfedfffff]
[    1.042547] pci_bus 0000:06: resource 16 [mem 0xfee01000-0xff9fffff]
[    1.042670] pci_bus 0000:06: resource 17 [mem 0xffc00000-0xffcfffff]
[    1.042795] pci_bus 0000:07: resource 0 [io  0xfc00-0xfcff]
[    1.042918] pci_bus 0000:07: resource 1 [io  0xf800-0xf8ff]
[    1.043042] pci_bus 0000:07: resource 2 [mem 0xf4000000-0xf7ffffff pref]
[    1.043168] pci_bus 0000:07: resource 3 [mem 0xd4000000-0xd7ffffff]
[    1.043433] NET: Registered protocol family 2
[    1.044001] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.046637] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.052160] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    1.057494] TCP: Hash tables configured (established 524288 bind 65536)
[    1.057690] TCP reno registered
[    1.057884] UDP hash table entries: 2048 (order: 6, 393216 bytes)
[    1.058399] UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
[    1.059111] NET: Registered protocol family 1
[    1.059771] RPC: Registered udp transport module.
[    1.059895] RPC: Registered tcp transport module.
[    1.060057] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.060511] pci 0000:01:00.0: Boot video device
[    1.060677] PCI: CLS 32 bytes, default 64
[    1.060987] Trying to unpack rootfs image as initramfs...
[    1.266956] Freeing initrd memory: 7620k freed
[    1.271276] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.271412] Placing 64MB software IO TLB between ffff8800bba00000 - ffff8800bfa00000
[    1.271592] software IO TLB at phys 0xbba00000 - 0xbfa00000
[    1.272937] Simple Boot Flag value 0xb read from CMOS RAM was invalid
[    1.273063] Simple Boot Flag at 0x7c set to 0x1
[    1.275387] Intel AES-NI instructions are not detected.
[    1.275512] Intel PCLMULQDQ-NI instructions are not detected.
[    1.276886] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.289410] VFS: Disk quotas dquot_6.5.2
[    1.289871] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.292800] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.294701] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.296322] fuse init (API version 7.15)
[    1.298674] JFS: nTxBlock = 8192, nTxLock = 65536
[    1.304266] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[    1.306619] SGI XFS Quota Management subsystem
[    1.307779] Btrfs loaded
[    1.307909] msgmni has been set to 7746
[    1.311906] async_tx: api initialized (async)
[    1.312336] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.312534] io scheduler noop registered
[    1.312657] io scheduler deadline registered (default)
[    1.313878] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.314399] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.314525] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.315662] acpiphp: Slot [1] registered
[    1.316352] acpiphp: Slot [1-1] registered
[    1.316890] pci-stub: invalid id string ""
[    1.317950] ACPI: AC Adapter [ADP1] (on-line)
[    1.318590] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    1.318870] ACPI: Lid Switch [LID]
[    1.319216] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    1.319449] ACPI: Power Button [PWRB]
[    1.320485] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.320670] ACPI: Power Button [PWRF]
[    1.323483] acpi device:24: registered as cooling_device0
[    1.324292] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:23/LNXVIDEO:00/input/input3
[    1.324481] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: no)
[    1.325332] ACPI: acpi_idle registered with cpuidle
[    1.325715] Marking TSC unstable due to TSC halts in idle
[    1.326248] Switching to clocksource hpet
[    1.332023] thermal LNXTHERM:00: registered as thermal_zone0
[    1.332149] ACPI: Thermal Zone [THRM] (62 C)
[    1.333127] ERST: Table is not found!
[    1.333249] GHES: HEST is not enabled!
[    1.334860] ACPI: Battery Slot [BAT1] (battery present)
[    1.334893] Linux agpgart interface v0.103
[    1.335249] [drm] Initialized drm 1.1.0 20060810
[    1.335820] nouveau 0000:01:00.0: power state changed by ACPI to D0
[    1.336138] nouveau 0000:01:00.0: power state changed by ACPI to D0
[    1.336275] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.336409] nouveau 0000:01:00.0: setting latency timer to 64
[    1.346193] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x086a00a2)
[    1.366730] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[    1.452526] [drm] nouveau 0000:01:00.0: ... appears to be valid
[    1.452652] [drm] nouveau 0000:01:00.0: BIT BIOS found
[    1.452775] [drm] nouveau 0000:01:00.0: Bios version 60.86.49.00
[    1.452899] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
[    1.453022] [drm] nouveau 0000:01:00.0: BIT table 'd' not found
[    1.453146] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[    1.453348] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 010003f3 00010035
[    1.453473] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 02811300 00000028
[    1.453599] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 02822312 00000030
[    1.453723] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 01833320 00000028
[    1.453848] [drm] nouveau 0000:01:00.0: Raw DCB entry 4: 0000000e 00000000
[    1.453978] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 14 2
[    1.454104] [drm] nouveau 0000:01:00.0:   0: 0x00000040: type 0x40 idx 0 tag 0xff
[    1.454283] [drm] nouveau 0000:01:00.0:   1: 0x00000100: type 0x00 idx 1 tag 0xff
[    1.454462] [drm] nouveau 0000:01:00.0:   2: 0x00001255: type 0x55 idx 2 tag 0x07
[    1.454640] [drm] nouveau 0000:01:00.0: unknown type, using 0x31
[    1.454762] [drm] nouveau 0000:01:00.0:   3: 0x00000351: type 0x51 idx 3 tag 0xff
[    1.454940] [drm] nouveau 0000:01:00.0: unknown type, using 0x00
[    1.455067] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xC377
[    1.493469] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xC6C3
[    1.526693] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xD304
[    1.526877] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xD3F6
[    1.533431] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xD5F0
[    1.533610] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xD655
[    1.556696] [drm] nouveau 0000:01:00.0: 0xD655: Condition still not met after 20ms, skipping following opcodes
[    1.556947] [drm] nouveau 0000:01:00.0: BIOS FP mode: 1680x1050 (119880kHz pixel clock)
[    1.576572] [drm] nouveau 0000:01:00.0: 3 available performance level(s)
[    1.576727] [drm] nouveau 0000:01:00.0: 0: memory 100MHz core 169MHz shader 338MHz voltage 1150mV fanspeed 100%
[    1.576911] [drm] nouveau 0000:01:00.0: 1: memory 200MHz core 275MHz shader 550MHz voltage 1150mV fanspeed 100%
[    1.577095] [drm] nouveau 0000:01:00.0: 2: memory 400MHz core 400MHz shader 800MHz voltage 1200mV fanspeed 100%
[    1.577291] [drm] nouveau 0000:01:00.0: c: memory 199MHz core 275MHz shader 550MHz voltage 1200mV
[    1.577703] [drm] nouveau 0000:01:00.0: Detected 256MiB VRAM
[    1.578063] [TTM] Zone  kernel: Available graphics memory: 1983026 kiB.
[    1.578191] [TTM] Initializing pool allocator.
[    1.628346] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[    2.259756] [drm] nouveau 0000:01:00.0: Allocating FIFO number 1
[    2.267354] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 1
[    2.375727] [drm] nouveau 0000:01:00.0: allocated 1680x1050 fb: 0x40270000, bo ffff880133c8e800
[    2.376310] fbcon: nouveaufb (fb0) is primary device
[    2.385974] Console: switching to colour frame buffer device 210x65
[    2.389800] fb0: nouveaufb frame buffer device
[    2.389808] drm: registered panic notifier
[    2.389845] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[    2.390019] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.411019] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.618965] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.642082] brd: module loaded
[    2.645498] loop: module loaded
[    2.646881] Loading iSCSI transport class v2.0-870.
[    2.648367] iscsi: registered transport (tcp)
[    2.648857] SCSI Media Changer driver v0.25
[    2.649118] ahci 0000:00:1f.2: version 3.0
[    2.649210] ahci 0000:00:1f.2: PCI INT C -> GSI 19 (level, low) -> IRQ 19
[    2.649377] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
[    2.649491] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x3 impl SATA mode
[    2.649505] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems
[    2.649523] ahci 0000:00:1f.2: setting latency timer to 64
[    2.655705] scsi0 : ahci
[    2.656301] scsi1 : ahci
[    2.656780] scsi2 : ahci
[    2.657532] ata1: SATA max UDMA/133 abar m2048@0xffcfd800 port 0xffcfd900 irq 40
[    2.657547] ata2: SATA max UDMA/133 abar m2048@0xffcfd800 port 0xffcfd980 irq 40
[    2.657558] ata3: DUMMY
[    2.657964] ata_piix 0000:00:1f.1: version 2.13
[    2.657992] ata_piix 0000:00:1f.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.658081] ata_piix 0000:00:1f.1: setting latency timer to 64
[    2.660172] scsi3 : ata_piix
[    2.660575] scsi4 : ata_piix
[    2.661442] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x9f30 irq 14
[    2.661455] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x9f38 irq 15
[    2.661713] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k6-NAPI
[    2.661725] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    2.661765] ata5: port disabled. ignoring.
[    2.661890] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
[    2.661900] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[    2.662375] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.663264] e1000e 0000:00:19.0: setting latency timer to 64
[    2.664555] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    2.820451] ata4.00: ATAPI: MATSHITADVD-RAM UJ-850S, 1.40, max UDMA/33
[    2.833621] ata4.00: configured for UDMA/33
[    2.976712] ata2: SATA link down (SStatus 0 SControl 300)
[    2.977131] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.978641] ata1.00: unexpected _GTF length (8)
[    2.979318] ata1.00: ATA-8: Hitachi HTS725050A9A364, PC4OC70E, max UDMA/133
[    2.979867] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.981563] ata1.00: unexpected _GTF length (8)
[    2.982226] ata1.00: configured for UDMA/133
[    2.983307] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS72505 PC4O PQ: 0 ANSI: 5
[    2.984732] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.985796] sd 0:0:0:0: [sda] Write Protect is off
[    2.985798] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.987018] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.987963] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.989015] scsi 3:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-850S  1.40 PQ: 0 ANSI: 5
[    2.994840] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.995171] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.996906] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    2.997600] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    3.010193] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:15:b7:10:1e:f4
[    3.010560] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.011491] e1000e 0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: ffffff-0ff
[    3.012519] CAN device driver interface
[    3.013320] sja1000 CAN netdevice driver
[    3.013377]  sda: sda1 sda2 sda3 sda4
[    3.015034] VMware vmxnet3 virtual NIC driver - version 1.0.14.0-k-NAPI
[    3.016029] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.016223] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.2.6 (Oct 12, 2010)
[    3.016433] tun: Universal TUN/TAP device driver, 1.6
[    3.016435] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.019552] console [netcon0] enabled
[    3.020477] netconsole: network logging started
[    3.021598] firewire_ohci 0000:06:0b.1: enabling device (0000 -> 0002)
[    3.022319] firewire_ohci 0000:06:0b.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    3.073632] firewire_ohci: Added fw-ohci device 0000:06:0b.1, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x2
[    3.075666] aoe: AoE v47 initialised.
[    3.076565] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.077079] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.077992] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    3.078926] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    3.080562] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    3.093444] ehci_hcd 0000:00:1a.7: debug port 1
[    3.097748] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    3.098218] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xffcff800
[    3.110038] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    3.111680] hub 1-0:1.0: USB hub found
[    3.112135] hub 1-0:1.0: 4 ports detected
[    3.113598] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.114077] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.115013] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.116230] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    3.130069] ehci_hcd 0000:00:1d.7: debug port 1
[    3.134400] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    3.134883] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xffcff400
[    3.146694] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.147768] hub 2-0:1.0: USB hub found
[    3.148203] hub 2-0:1.0: 6 ports detected
[    3.149567] uhci_hcd: USB Universal Host Controller Interface driver
[    3.150149] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.151041] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.151981] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    3.153159] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    3.166728] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000bf80
[    3.167789] hub 3-0:1.0: USB hub found
[    3.168214] hub 3-0:1.0: 2 ports detected
[    3.169469] uhci_hcd 0000:00:1a.1: enabling device (0000 -> 0001)
[    3.170084] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.171017] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    3.171932] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    3.173126] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    3.193426] uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000dce0
[    3.194461] hub 4-0:1.0: USB hub found
[    3.194875] hub 4-0:1.0: 2 ports detected
[    3.196129] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.196654] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.197556] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.198633] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    3.216730] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00009fe0
[    3.217729] hub 5-0:1.0: USB hub found
[    3.218102] hub 5-0:1.0: 2 ports detected
[    3.219255] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.219827] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.220704] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.221780] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    3.233439] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00009f80
[    3.234412] hub 6-0:1.0: USB hub found
[    3.234773] hub 6-0:1.0: 2 ports detected
[    3.235920] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.236472] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.237336] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.238396] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    3.253397] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00009f60
[    3.254338] hub 7-0:1.0: USB hub found
[    3.254675] hub 7-0:1.0: 2 ports detected
[    3.256185] usbcore: registered new interface driver wusb-cbaf
[    3.256798] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    3.262177] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.262592] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.263892] mice: PS/2 mouse device common for all mice
[    3.265565] rtc_cmos 00:08: RTC can wake from S4
[    3.276994] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    3.277165] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    3.277219] rtc0: alarms up to one year, 114 bytes nvram, hpet irqs
[    3.277339] i2c /dev entries driver
[    3.279075] lirc_dev: IR Remote Control driver registered, major 248
[    3.279098] IR RC5 (streamzap) protocol handler initialized
[    3.279101] IR LIRC bridge handler initialized
[    3.279103] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    3.279519] iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0xd860)
[    3.279838] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    3.279846] iTCO_vendor_support: vendor-support=0
[    3.279868] md: linear personality registered for level -1
[    3.279870] md: raid0 personality registered for level 0
[    3.279873] md: raid1 personality registered for level 1
[    3.279875] md: raid10 personality registered for level 10
[    3.279877] md: raid6 personality registered for level 6
[    3.279880] md: raid5 personality registered for level 5
[    3.279882] md: raid4 personality registered for level 4
[    3.280566] device-mapper: uevent: version 1.0.3
[    3.281074] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[    3.281090] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    3.281240] usbcore: registered new interface driver btusb
[    3.281242] EDAC MC: Ver: 2.1.0 Nov  3 2010
[    3.283894] cpuidle: using governor ladder
[    3.299251] cpuidle: using governor menu
[    3.299540] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    3.302645] usbcore: registered new interface driver usbhid
[    3.302948] usbhid: USB HID core driver
[    3.305416] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[    3.305758] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[    3.306557] HDA Intel 0000:00:1b.0: enabling device (0000 -> 0002)
[    3.307441] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    3.308374] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[    3.309190] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    3.339180] hda_codec: ALC262: SKU not ready 0x598301f0
[    3.339817] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input5
[    3.348458] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    3.350227] ALSA device list:
[    3.350603]   #0: HDA Intel at 0xffcf8000 irq 42
[    3.351713] oprofile: using NMI interrupt.
[    3.352402] Netfilter messages via NETLINK v0.30.
[    3.353239] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.355711] ctnetlink v0.93: registering with nfnetlink.
[    3.356114] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
[    3.356941] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
[    3.358379] xt_time: kernel timezone is -0000
[    3.362543] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.362984] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[    3.363850] arp_tables: (C) 2002 David S. Miller
[    3.364819] TCP bic registered
[    3.365598] TCP cubic registered
[    3.366487] TCP westwood registered
[    3.367479] TCP highspeed registered
[    3.368324] TCP hybla registered
[    3.369144] TCP htcp registered
[    3.370024] TCP vegas registered
[    3.370867] TCP veno registered
[    3.371717] TCP scalable registered
[    3.372561] TCP lp registered
[    3.373433] TCP yeah registered
[    3.374225] TCP illinois registered
[    3.375021] Initializing XFRM netlink socket
[    3.377064] NET: Registered protocol family 10
[    3.380814] lo: Disabled Privacy Extensions
[    3.385723] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    3.386311] IPv6 over IPv4 tunneling driver
[    3.389380] sit0: Disabled Privacy Extensions
[    3.394411] ip6tnl0: Disabled Privacy Extensions
[    3.396803] NET: Registered protocol family 17
[    3.397061] NET: Registered protocol family 15
[    3.398100] Bridge firewalling registered
[    3.398553] Ebtables v2.0 registered
[    3.399472] can: controller area network core (rev 20090105 abi 8)
[    3.400152] NET: Registered protocol family 29
[    3.400847] can: raw protocol (rev 20090105)
[    3.401635] can: broadcast manager protocol (rev 20090105 t)
[    3.407722] IrCOMM protocol (Dag Brattli)
[    3.414855] Bluetooth: L2CAP ver 2.15
[    3.415101] Bluetooth: L2CAP socket layer initialized
[    3.415854] Bluetooth: SCO (Voice Link) ver 0.6
[    3.416656] Bluetooth: SCO socket layer initialized
[    3.417515] Bluetooth: RFCOMM TTY layer initialized
[    3.418141] Bluetooth: RFCOMM socket layer initialized
[    3.418880] Bluetooth: RFCOMM ver 1.11
[    3.419632] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    3.420440] Bluetooth: BNEP filters: protocol multicast
[    3.421160] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    3.422296] lec:lane_module_init: lec.c: Nov  3 2010 20:24:47 initialized
[    3.422651] mpoa:atm_mpoa_init: mpc.c: Nov  3 2010 20:24:46 initialized
[    3.423448] L2TP core driver, V2.0
[    3.424178] L2TP IP encapsulation support (L2TPv3)
[    3.425205] L2TP netlink interface
[    3.425820] L2TP ethernet pseudowire support (L2TPv3)
[    3.426493] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    3.427288] All bugs added by David S. Miller <davem@redhat.com>
[    3.436419] sctp: Hash tables configured (established 52428 bind 52428)
[    3.439085] lib80211: common routines for IEEE802.11 drivers
[    3.439347] lib80211_crypt: registered algorithm 'NULL'
[    3.440168] Registering the dns_resolver key type
[    3.461446] registered taskstats version 1
[    3.462518] rtc_cmos 00:08: setting system clock to 2010-11-04 19:53:56 UTC (1288900436)
[    3.463440] Freeing unused kernel memory: 2832k freed
[    3.464819] Write protecting the kernel read-only data: 18432k
[    3.465702] Freeing unused kernel memory: 568k freed
[    3.467349] Freeing unused kernel memory: 1764k freed
[    3.565849] udev[1326]: starting version 163
[    3.574503] firewire_core: created device fw0: GUID 0000390000875f33, S400
[    3.736770] usb 6-1: new full speed USB device using uhci_hcd and address 2
[    4.018795] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input7
[    4.048611] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input8
[    4.186835] usb 7-1: new low speed USB device using uhci_hcd and address 2
[    4.188588] dracut: Scanning devices sda4  for LVM volume groups
[    4.212550] dracut: Reading all physical volumes. This may take a while...
[    4.212993] dracut: Found volume group "Group0" using metadata type lvm2
[    4.276721] dracut: The link /dev/Group0/Root should had been created by udev but it was not found. Falling back to direct link creation.
[    4.278117] dracut: 1 logical volume(s) in volume group "Group0" now active
[    4.391897] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.2/usb7/7-1/7-1:1.0/input/input9
[    4.396472] generic-usb 0003:046D:C51B.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.2-1/input0
[    4.415567] generic-usb 0003:046D:C51B.0002: hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.2-1/input1
[    4.521665] EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
[    4.522465] EXT4-fs (dm-0): write access will be enabled during recovery
[    6.315906] EXT4-fs (dm-0): orphan cleanup on readonly fs
[    6.316411] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 1311372
[    6.319486] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 1310935
[    6.320438] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 1310916
[    6.321310] EXT4-fs (dm-0): 3 orphan inodes deleted
[    6.322211] EXT4-fs (dm-0): recovery complete
[    6.649238] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    6.744517] dracut: Remounting /dev/disk/by-label/Root with -o acl,noatime,ro
[    6.783008] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: acl
[    6.797398] dracut: Mounted root filesystem /dev/mapper/Group0-Root
[    6.941651] dracut: Switching root
[   10.337676] udev[2039]: starting version 163
[   11.649878] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)
[   11.802169] yenta_cardbus 0000:06:0b.0: CardBus bridge found [1179:0001]
[   11.802205] yenta_cardbus 0000:06:0b.0: Enabling burst memory read transactions
[   11.802213] yenta_cardbus 0000:06:0b.0: Using CSCINT to route CSC interrupts to PCI
[   11.802216] yenta_cardbus 0000:06:0b.0: Routing CardBus interrupts to PCI
[   11.802225] yenta_cardbus 0000:06:0b.0: TI: mfunc 0x01aa1022, devctl 0x64
[   11.810155] Detected Toshiba ACPI Bluetooth device - installing RFKill handler
[   11.812177] toshiba_bluetooth: Re-enabling Toshiba Bluetooth
[   11.831649] input: Toshiba input device as /devices/virtual/input/input10
[   11.833052] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.19
[   11.833056] toshiba_acpi:     HCI method: \_SB_.VALZ.GHCI
[   11.849992] Registered led device: toshiba::illumination
[   11.970891] sdhci: Secure Digital Host Controller Interface driver
[   11.970895] sdhci: Copyright(c) Pierre Ossman
[   12.040737] yenta_cardbus 0000:06:0b.0: ISA IRQ mask 0x0cf8, PCI irq 20
[   12.040742] yenta_cardbus 0000:06:0b.0: Socket status: 30000410
[   12.040746] pci_bus 0000:06: Raising subordinate bus# of parent bus (#06) from #07 to #0a
[   12.040920] yenta_cardbus 0000:06:0b.0: pcmcia: parent PCI bridge window: [io  0xf000-0xffff]
[   12.040924] yenta_cardbus 0000:06:0b.0: pcmcia: parent PCI bridge window: [mem 0xda000000-0xdfffffff]
[   12.040927] pcmcia_socket pcmcia_socket0: cs: memory probe 0xda000000-0xdfffffff: clean.
[   12.040991] yenta_cardbus 0000:06:0b.0: pcmcia: parent PCI bridge window: [mem 0xf4000000-0xf7ffffff pref]
[   12.040993] pcmcia_socket pcmcia_socket0: cs: memory probe 0xf4000000-0xf7ffffff: excluding 0xf4000000-0xf7ffffff
[   12.041989] tifm_7xx1 0000:06:0b.2: enabling device (0000 -> 0002)
[   12.042001] tifm_7xx1 0000:06:0b.2: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[   12.042687] sdhci-pci 0000:06:0b.3: SDHCI controller found [104c:803c] (rev 0)
[   12.042715] sdhci-pci 0000:06:0b.3: enabling device (0000 -> 0002)
[   12.042724] sdhci-pci 0000:06:0b.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[   12.043087] Registered led device: mmc0::
[   12.043450] mmc0: SDHCI controller on PCI [0000:06:0b.3] using DMA
[   12.573417] usb 6-2: new full speed USB device using uhci_hcd and address 3
[   12.926860] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted into slot 0
[   12.926871] pcmcia_socket pcmcia_socket0: cs: memory probe 0xda000000-0xdfffffff:
[   12.927499] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   12.927502] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   12.927683] iwlagn 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   12.927700] iwlagn 0000:02:00.0: setting latency timer to 64
[   12.927753] iwlagn 0000:02:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
[   12.928750]  excluding 0xdac00000-0xdb1fffff 0xdbe00000-0xdc3fffff 0xddc00000-0xde1fffff 0xdee00000-0xdf3fffff
[   12.934523] pcmcia 0.0: pcmcia: registering new device pcmcia0.0 (IRQ: 20)
[   12.967950] iwlagn 0000:02:00.0: device EEPROM VER=0x36, CALIB=0x5
[   12.967969] iwlagn 0000:02:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
[   12.968150] iwlagn 0000:02:00.0: irq 43 for MSI/MSI-X
[   13.094111] iwlagn 0000:02:00.0: loaded firmware version 228.61.2.24
[   13.118705] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   17.475051] EXT4-fs (dm-0): re-mounted. Opts: acl
[   17.755840] REISERFS (device sda1): found reiserfs format "3.6" with standard journal
[   17.755878] REISERFS (device sda1): using ordered data mode
[   17.756274] REISERFS (device sda1): journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   17.757241] REISERFS (device sda1): checking transaction log (sda1)
[   17.781973] REISERFS (device sda1): Using r5 hash to sort names
[   18.289616] Adding 4192960k swap on /dev/sda3.  Priority:-1 extents:1 across:4192960k
[   28.643465] sshd (3102): /proc/3102/oom_adj is deprecated, please use /proc/3102/oom_score_adj instead.
[   36.186969] [drm] nouveau 0000:01:00.0: unknown parameter 15
[   36.188291] [drm] nouveau 0000:01:00.0: unknown parameter 15
[   36.188494] [drm] nouveau 0000:01:00.0: unknown parameter 16
[   36.802887] [drm] nouveau 0000:01:00.0: Allocating FIFO number 2
[   36.811290] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 2
[   37.544734] [drm] nouveau 0000:01:00.0: unknown parameter 15
[   37.608330] [drm] nouveau 0000:01:00.0: Allocating FIFO number 3
[   37.615859] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 3
[   40.760919] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   46.697236] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   46.750235] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   46.758208] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   51.316344] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   52.170583] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   52.223552] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   52.229272] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   52.640032] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   56.637335] wlan0: authenticate with 00:90:4b:3d:47:58 (try 1)
[   56.639266] wlan0: authenticated
[   56.639484] wlan0: associate with 00:90:4b:3d:47:58 (try 1)
[   56.641853] wlan0: RX AssocResp from 00:90:4b:3d:47:58 (capab=0x431 status=0 aid=1)
[   56.641859] wlan0: associated
[   56.682048] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   64.086827] netconsole: local port 6665
[   64.086832] netconsole: local IP 192.168.2.180
[   64.086835] netconsole: interface 'wlan0'
[   64.086837] netconsole: remote port 514
[   64.086839] netconsole: remote IP 192.168.2.40
[   64.086842] netconsole: remote ethernet address 00:19:d1:4d:7a:b3
[   64.087011] netconsole: wlan0 doesn't support polling, aborting.
[   66.830062] wlan0: no IPv6 routers present
[ 6099.984575] ata1.00: configured for UDMA/133
[ 6099.984601] ata1: EH complete
[ 6100.604420] [drm] nouveau 0000:01:00.0: unknown parameter 15
[ 6100.604464] [drm] nouveau 0000:01:00.0: Allocating FIFO number 4
[ 6100.611733] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 4
[ 6100.825545] [drm] nouveau 0000:01:00.0: nouveau_channel_free: freeing fifo 4
[ 6100.827158]
[ 6100.827158] ======================================================
[ 6100.827158] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
[ 6100.827158] 2.6.37-rc1-00027-gff8b16d #1
[ 6100.827158] ------------------------------------------------------
[ 6100.827158] kwin_opengl_tes/8245 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[ 6100.827158]  (&(&dev_priv->ramin_lock)->rlock){+.+...}, at: [<ffffffff8161b9ff>] nouveau_gpuobj_del+0x6f/0x150
[ 6100.827158]
[ 6100.827158] and this task is already holding:
[ 6100.827158]  (&(&dev_priv->context_switch_lock)->rlock){-.....}, at: [<ffffffff816185c9>] nouveau_channel_free+0xf9/0x2c0
[ 6100.827158] which would create a new lock dependency:
[ 6100.827158]  (&(&dev_priv->context_switch_lock)->rlock){-.....} -> (&(&dev_priv->ramin_lock)->rlock){+.+...}
[ 6100.827158]
[ 6100.827158] but this new dependency connects a HARDIRQ-irq-safe lock:
[ 6100.827158]  (&(&dev_priv->context_switch_lock)->rlock){-.....}
[ 6100.827158] ... which became HARDIRQ-irq-safe at:
[ 6100.827158]   [<ffffffff810d5ca9>] __lock_acquire+0xbf9/0x1bb0
[ 6100.827158]   [<ffffffff810d6cf5>] lock_acquire+0x95/0x220
[ 6100.827158]   [<ffffffff81b671a2>] _raw_spin_lock_irqsave+0x52/0x90
[ 6100.827158]   [<ffffffff8161f8da>] nouveau_irq_handler+0x7a/0xe80
[ 6100.827158]   [<ffffffff810faec1>] handle_IRQ_event+0x81/0x300
[ 6100.827158]   [<ffffffff810fdb56>] handle_fasteoi_irq+0x96/0x120
[ 6100.827158]   [<ffffffff81043a22>] handle_irq+0x22/0x30
[ 6100.827158]
[ 6100.827158] [drm] nouveau 0000:01:00.0: GPU lockup - switching to software fbcon
[ 6100.827158] [<ffffffff81b689c3>] do_IRQ+0x73/0xf0
[ 6100.827158]   [<ffffffff81b682d3>] ret_from_intr+0x0/0xf
[ 6100.827158]   [<ffffffff81b62d48>] printk+0x41/0x43
[ 6100.827158]   [<ffffffff81618fd3>] nouveau_channel_alloc+0x703/0x7a0
[ 6100.827158]   [<ffffffff81617886>] nouveau_card_init+0x12c6/0x1400
[ 6100.827158]   [<ffffffff81617e33>] nouveau_load+0x473/0x980
[ 6100.827158]   [<ffffffff815fd2fe>] drm_get_pci_dev+0x1ae/0x3e0
[ 6100.827158]   [<ffffffff81b495fe>] nouveau_pci_probe+0x15/0x17
[ 6100.827158]   [<ffffffff8154afef>] local_pci_probe+0x5f/0xd0
[ 6100.827158]   [<ffffffff8154c211>] pci_device_probe+0x101/0x120
[ 6100.827158]   [<ffffffff81691013>] driver_probe_device+0xa3/0x2c0
[ 6100.827158]   [<ffffffff816912cb>] __driver_attach+0x9b/0xa0
[ 6100.827158]   [<ffffffff8169049c>] bus_for_each_dev+0x6c/0xa0
[ 6100.827158]   [<ffffffff81690d9e>] driver_attach+0x1e/0x20
[ 6100.827158]   [<ffffffff8168fb58>] bus_add_driver+0x1d8/0x3a0
[ 6100.827158]   [<ffffffff81691618>] driver_register+0x78/0x140
[ 6100.827158]   [<ffffffff8154c4c6>] __pci_register_driver+0x66/0xe0
[ 6100.827158]   [<ffffffff815fd60a>] drm_pci_init+0xda/0xf0
[ 6100.827158]   [<ffffffff815f4698>] drm_init+0x58/0x70
[ 6100.827158]   [<ffffffff8264a6ce>] nouveau_init+0x48/0x4a
[ 6100.827158]   [<ffffffff810001e3>] do_one_initcall+0x43/0x180
[ 6100.827158]   [<ffffffff82616543>] kernel_init+0x161/0x1ea
[ 6100.827158]   [<ffffffff81041794>] kernel_thread_helper+0x4/0x10
[ 6100.827158]
[ 6100.827158] to a HARDIRQ-irq-unsafe lock:
[ 6100.827158]  (&(&dev_priv->ramin_lock)->rlock){+.+...}
[ 6100.827158] ... which became HARDIRQ-irq-unsafe at:
[ 6100.827158] ...  [<ffffffff810d5bb5>] __lock_acquire+0xb05/0x1bb0
[ 6100.827158]   [<ffffffff810d6cf5>] lock_acquire+0x95/0x220
[ 6100.827158]   [<ffffffff81b66ff0>] _raw_spin_lock+0x40/0x80
[ 6100.827158]   [<ffffffff8161bc9d>] nouveau_gpuobj_new+0x11d/0x620
[ 6100.827158]   [<ffffffff81664734>] nv50_instmem_init+0x164/0xa40
[ 6100.827158]   [<ffffffff816169ba>] nouveau_card_init+0x3fa/0x1400
[ 6100.827158]   [<ffffffff81617e33>] nouveau_load+0x473/0x980
[ 6100.827158]   [<ffffffff815fd2fe>] drm_get_pci_dev+0x1ae/0x3e0
[ 6100.827158]   [<ffffffff81b495fe>] nouveau_pci_probe+0x15/0x17
[ 6100.827158]   [<ffffffff8154afef>] local_pci_probe+0x5f/0xd0
[ 6100.827158]   [<ffffffff8154c211>] pci_device_probe+0x101/0x120
[ 6100.827158]   [<ffffffff81691013>] driver_probe_device+0xa3/0x2c0
[ 6100.827158]   [<ffffffff816912cb>] __driver_attach+0x9b/0xa0
[ 6100.827158]   [<ffffffff8169049c>] bus_for_each_dev+0x6c/0xa0
[ 6100.827158]   [<ffffffff81690d9e>] driver_attach+0x1e/0x20
[ 6100.827158]   [<ffffffff8168fb58>] bus_add_driver+0x1d8/0x3a0
[ 6100.827158]   [<ffffffff81691618>] driver_register+0x78/0x140
[ 6100.827158]   [<ffffffff8154c4c6>] __pci_register_driver+0x66/0xe0
[ 6100.827158]   [<ffffffff815fd60a>] drm_pci_init+0xda/0xf0
[ 6100.827158]   [<ffffffff815f4698>] drm_init+0x58/0x70
[ 6100.827158]   [<ffffffff8264a6ce>] nouveau_init+0x48/0x4a
[ 6100.827158]   [<ffffffff810001e3>] do_one_initcall+0x43/0x180
[ 6100.827158]   [<ffffffff82616543>] kernel_init+0x161/0x1ea
[ 6100.827158]   [<ffffffff81041794>] kernel_thread_helper+0x4/0x10
[ 6100.827158]
[ 6100.827158] other info that might help us debug this:
[ 6100.827158]
[ 6100.827158] 2 locks held by kwin_opengl_tes/8245:
[ 6100.827158]  #0:  (drm_global_mutex){+.+.+.}, at: [<ffffffff815f4c59>] drm_release+0x39/0x700
[ 6100.827158]  #1:  (&(&dev_priv->context_switch_lock)->rlock){-.....}, at: [<ffffffff816185c9>] nouveau_channel_free+0xf9/0x2c0
[ 6100.827158]
[ 6100.827158] the dependencies between HARDIRQ-irq-safe lock and the holding lock:
[ 6100.827158] -> (&(&dev_priv->context_switch_lock)->rlock){-.....} ops: 14 {
[ 6100.827158]    IN-HARDIRQ-W at:
[ 6100.827158]                                        [<ffffffff810d5ca9>] __lock_acquire+0xbf9/0x1bb0
[ 6100.827158]                                        [<ffffffff810d6cf5>] lock_acquire+0x95/0x220
[ 6100.827158]                                        [<ffffffff81b671a2>] _raw_spin_lock_irqsave+0x52/0x90
[ 6100.827158]                                        [<ffffffff8161f8da>] nouveau_irq_handler+0x7a/0xe80
[ 6100.827158]                                        [<ffffffff810faec1>] handle_IRQ_event+0x81/0x300
[ 6100.827158]                                        [<ffffffff810fdb56>] handle_fasteoi_irq+0x96/0x120
[ 6100.827158]                                        [<ffffffff81043a22>] handle_irq+0x22/0x30
[ 6100.827158]                                        [<ffffffff81b689c3>] do_IRQ+0x73/0xf0
[ 6100.827158]                                        [<ffffffff81b682d3>] ret_from_intr+0x0/0xf
[ 6100.827158]                                        [<ffffffff81b62d48>] printk+0x41/0x43
[ 6100.827158]                                        [<ffffffff81618fd3>] nouveau_channel_alloc+0x703/0x7a0
[ 6100.827158]                                        [<ffffffff81617886>] nouveau_card_init+0x12c6/0x1400
[ 6100.827158]                                        [<ffffffff81617e33>] nouveau_load+0x473/0x980
[ 6100.827158]                                        [<ffffffff815fd2fe>] drm_get_pci_dev+0x1ae/0x3e0
[ 6100.827158]                                        [<ffffffff81b495fe>] nouveau_pci_probe+0x15/0x17
[ 6100.827158]                                        [<ffffffff8154afef>] local_pci_probe+0x5f/0xd0
[ 6100.827158]                                        [<ffffffff8154c211>] pci_device_probe+0x101/0x120
[ 6100.827158]                                        [<ffffffff81691013>] driver_probe_device+0xa3/0x2c0
[ 6100.827158]                                        [<ffffffff816912cb>] __driver_attach+0x9b/0xa0
[ 6100.827158]                                        [<ffffffff8169049c>] bus_for_each_dev+0x6c/0xa0
[ 6100.827158]                                        [<ffffffff81690d9e>] driver_attach+0x1e/0x20
[ 6100.827158]                                        [<ffffffff8168fb58>] bus_add_driver+0x1d8/0x3a0
[ 6100.827158]                                        [<ffffffff81691618>] driver_register+0x78/0x140
[ 6100.827158]                                        [<ffffffff8154c4c6>] __pci_register_driver+0x66/0xe0
[ 6100.827158]                                        [<ffffffff815fd60a>] drm_pci_init+0xda/0xf0
[ 6100.827158]                                        [<ffffffff815f4698>] drm_init+0x58/0x70
[ 6100.827158]                                        [<ffffffff8264a6ce>] nouveau_init+0x48/0x4a
[ 6100.827158]                                        [<ffffffff810001e3>] do_one_initcall+0x43/0x180
[ 6100.827158]                                        [<ffffffff82616543>] kernel_init+0x161/0x1ea
[ 6100.827158]                                        [<ffffffff81041794>] kernel_thread_helper+0x4/0x10
[ 6100.827158]    INITIAL USE at:
[ 6100.827158]                                       [<ffffffff810d5592>] __lock_acquire+0x4e2/0x1bb0
[ 6100.827158]                                       [<ffffffff810d6cf5>] lock_acquire+0x95/0x220
[ 6100.827158]                                       [<ffffffff81b671a2>] _raw_spin_lock_irqsave+0x52/0x90
[ 6100.827158]                                       [<ffffffff8164a731>] nv50_fifo_create_context+0xc1/0x310
[ 6100.827158]                                       [<ffffffff81618c44>] nouveau_channel_alloc+0x374/0x7a0
[ 6100.827158]                                       [<ffffffff81617886>] nouveau_card_init+0x12c6/0x1400
[ 6100.827158]                                       [<ffffffff81617e33>] nouveau_load+0x473/0x980
[ 6100.827158]                                       [<ffffffff815fd2fe>] drm_get_pci_dev+0x1ae/0x3e0
[ 6100.827158]                                       [<ffffffff81b495fe>] nouveau_pci_probe+0x15/0x17
[ 6100.827158]                                       [<ffffffff8154afef>] local_pci_probe+0x5f/0xd0
[ 6100.827158]                                       [<ffffffff8154c211>] pci_device_probe+0x101/0x120
[ 6100.827158]                                       [<ffffffff81691013>] driver_probe_device+0xa3/0x2c0
[ 6100.827158]                                       [<ffffffff816912cb>] __driver_attach+0x9b/0xa0
[ 6100.827158]                                       [<ffffffff8169049c>] bus_for_each_dev+0x6c/0xa0
[ 6100.827158]                                       [<ffffffff81690d9e>] driver_attach+0x1e/0x20
[ 6100.827158]                                       [<ffffffff8168fb58>] bus_add_driver+0x1d8/0x3a0
[ 6100.827158]                                       [<ffffffff81691618>] driver_register+0x78/0x140
[ 6100.827158]                                       [<ffffffff8154c4c6>] __pci_register_driver+0x66/0xe0
[ 6100.827158]                                       [<ffffffff815fd60a>] drm_pci_init+0xda/0xf0
[ 6100.827158]                                       [<ffffffff815f4698>] drm_init+0x58/0x70
[ 6100.827158]                                       [<ffffffff8264a6ce>] nouveau_init+0x48/0x4a
[ 6100.827158]                                       [<ffffffff810001e3>] do_one_initcall+0x43/0x180
[ 6100.827158]                                       [<ffffffff82616543>] kernel_init+0x161/0x1ea
[ 6100.827158]                                       [<ffffffff81041794>] kernel_thread_helper+0x4/0x10
[ 6100.827158]  }
[ 6100.827158]  ... key      at: [<ffffffff830e4245>] __key.42599+0x0/0xb
[ 6100.827158]  ... acquired at:
[ 6100.827158]    [<ffffffff810d3bc0>] check_irq_usage+0x60/0xf0
[ 6100.827158]    [<ffffffff810d6121>] __lock_acquire+0x1071/0x1bb0
[ 6100.827158]    [<ffffffff810d6cf5>] lock_acquire+0x95/0x220
[ 6100.827158]    [<ffffffff81b66ff0>] _raw_spin_lock+0x40/0x80
[ 6100.827158]    [<ffffffff8161b9ff>] nouveau_gpuobj_del+0x6f/0x150
[ 6100.827158]    [<ffffffff8151c277>] kref_put+0x37/0x70
[ 6100.827158]    [<ffffffff8161b863>] nouveau_gpuobj_ref+0x43/0x60
[ 6100.827158]    [<ffffffff8165226a>] nv50_graph_destroy_context+0x9a/0xf0
[ 6100.827158]    [<ffffffff816185f8>] nouveau_channel_free+0x128/0x2c0
[ 6100.827158]    [<ffffffff8161886f>] nouveau_channel_cleanup+0x5f/0xc0
[ 6100.827158]    [<ffffffff816165be>] nouveau_preclose+0xe/0x10
[ 6100.827158]    [<ffffffff815f4c9b>] drm_release+0x7b/0x700
[ 6101.302253]    [<ffffffff811899ae>] fput+0xfe/0x260
[ 6101.302253]    [<ffffffff811859bd>] filp_close+0x5d/0x90
[ 6101.302253]    [<ffffffff8109ab38>] put_files_struct+0x198/0x310
[ 6101.302253]    [<ffffffff8109ad02>] exit_files+0x52/0x60
[ 6101.302253]    [<ffffffff8109cc0d>] do_exit+0x14d/0x940
[ 6101.302253]    [<ffffffff8109d45e>] do_group_exit+0x5e/0xd0
[ 6101.302253]    [<ffffffff8109d4e7>] sys_exit_group+0x17/0x20
[ 6101.302253]    [<ffffffff810409db>] system_call_fastpath+0x16/0x1b
[ 6101.302253]
[ 6101.302253]
[ 6101.302253] the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
[ 6101.302253] -> (&(&dev_priv->ramin_lock)->rlock){+.+...} ops: 20714 {
[ 6101.302253]    HARDIRQ-ON-W at:
[ 6101.302253]                                        [<ffffffff810d5bb5>] __lock_acquire+0xb05/0x1bb0
[ 6101.302253]                                        [<ffffffff810d6cf5>] lock_acquire+0x95/0x220
[ 6101.302253]                                        [<ffffffff81b66ff0>] _raw_spin_lock+0x40/0x80
[ 6101.302253]                                        [<ffffffff8161bc9d>] nouveau_gpuobj_new+0x11d/0x620
[ 6101.302253]                                        [<ffffffff81664734>] nv50_instmem_init+0x164/0xa40
[ 6101.302253]                                        [<ffffffff816169ba>] nouveau_card_init+0x3fa/0x1400
[ 6101.302253]                                        [<ffffffff81617e33>] nouveau_load+0x473/0x980
[ 6101.302253]                                        [<ffffffff815fd2fe>] drm_get_pci_dev+0x1ae/0x3e0
[ 6101.302253]                                        [<ffffffff81b495fe>] nouveau_pci_probe+0x15/0x17
[ 6101.302253]                                        [<ffffffff8154afef>] local_pci_probe+0x5f/0xd0
[ 6101.302253]                                        [<ffffffff8154c211>] pci_device_probe+0x101/0x120
[ 6101.302253]                                        [<ffffffff81691013>] driver_probe_device+0xa3/0x2c0
[ 6101.302253]                                        [<ffffffff816912cb>] __driver_attach+0x9b/0xa0
[ 6101.302253]                                        [<ffffffff8169049c>] bus_for_each_dev+0x6c/0xa0
[ 6101.302253]                                        [<ffffffff81690d9e>] driver_attach+0x1e/0x20
[ 6101.302253]                                        [<ffffffff8168fb58>] bus_add_driver+0x1d8/0x3a0
[ 6101.302253]                                        [<ffffffff81691618>] driver_register+0x78/0x140
[ 6101.302253]                                        [<ffffffff8154c4c6>] __pci_register_driver+0x66/0xe0
[ 6101.302253]                                        [<ffffffff815fd60a>] drm_pci_init+0xda/0xf0
[ 6101.302253]                                        [<ffffffff815f4698>] drm_init+0x58/0x70
[ 6101.302253]                                        [<ffffffff8264a6ce>] nouveau_init+0x48/0x4a
[ 6101.302253]                                        [<ffffffff810001e3>] do_one_initcall+0x43/0x180
[ 6101.302253]                                        [<ffffffff82616543>] kernel_init+0x161/0x1ea
[ 6101.302253]                                        [<ffffffff81041794>] kernel_thread_helper+0x4/0x10
[ 6101.302253]    SOFTIRQ-ON-W at:
[ 6101.302253]                                        [<ffffffff810d5be2>] __lock_acquire+0xb32/0x1bb0
[ 6101.302253]                                        [<ffffffff810d6cf5>] lock_acquire+0x95/0x220
[ 6101.302253]                                        [<ffffffff81b66ff0>] _raw_spin_lock+0x40/0x80
[ 6101.302253]                                        [<ffffffff8161bc9d>] nouveau_gpuobj_new+0x11d/0x620
[ 6101.302253]                                        [<ffffffff81664734>] nv50_instmem_init+0x164/0xa40
[ 6101.302253]                                        [<ffffffff816169ba>] nouveau_card_init+0x3fa/0x1400
[ 6101.302253]                                        [<ffffffff81617e33>] nouveau_load+0x473/0x980
[ 6101.302253]                                        [<ffffffff815fd2fe>] drm_get_pci_dev+0x1ae/0x3e0
[ 6101.302253]                                        [<ffffffff81b495fe>] nouveau_pci_probe+0x15/0x17
[ 6101.302253]                                        [<ffffffff8154afef>] local_pci_probe+0x5f/0xd0
[ 6101.302253]                                        [<ffffffff8154c211>] pci_device_probe+0x101/0x120
[ 6101.302253]                                        [<ffffffff81691013>] driver_probe_device+0xa3/0x2c0
[ 6101.302253]                                        [<ffffffff816912cb>] __driver_attach+0x9b/0xa0
[ 6101.302253]                                        [<ffffffff8169049c>] bus_for_each_dev+0x6c/0xa0
[ 6101.302253]                                        [<ffffffff81690d9e>] driver_attach+0x1e/0x20
[ 6101.302253]                                        [<ffffffff8168fb58>] bus_add_driver+0x1d8/0x3a0
[ 6101.302253]                                        [<ffffffff81691618>] driver_register+0x78/0x140
[ 6101.302253]                                        [<ffffffff8154c4c6>] __pci_register_driver+0x66/0xe0
[ 6101.302253]                                        [<ffffffff815fd60a>] drm_pci_init+0xda/0xf0
[ 6101.302253]                                        [<ffffffff815f4698>] drm_init+0x58/0x70
[ 6101.302253]                                        [<ffffffff8264a6ce>] nouveau_init+0x48/0x4a
[ 6101.302253]                                        [<ffffffff810001e3>] do_one_initcall+0x43/0x180
[ 6101.302253]                                        [<ffffffff82616543>] kernel_init+0x161/0x1ea
[ 6101.302253]                                        [<ffffffff81041794>] kernel_thread_helper+0x4/0x10
[ 6101.302253]    INITIAL USE at:
[ 6101.302253]                                       [<ffffffff810d5592>] __lock_acquire+0x4e2/0x1bb0
[ 6101.302253]                                       [<ffffffff810d6cf5>] lock_acquire+0x95/0x220
[ 6101.302253]                                       [<ffffffff81b66ff0>] _raw_spin_lock+0x40/0x80
[ 6101.302253]                                       [<ffffffff8161bc9d>] nouveau_gpuobj_new+0x11d/0x620
[ 6101.302253]                                       [<ffffffff81664734>] nv50_instmem_init+0x164/0xa40
[ 6101.302253]                                       [<ffffffff816169ba>] nouveau_card_init+0x3fa/0x1400
[ 6101.302253]                                       [<ffffffff81617e33>] nouveau_load+0x473/0x980
[ 6101.302253]                                       [<ffffffff815fd2fe>] drm_get_pci_dev+0x1ae/0x3e0
[ 6101.302253]                                       [<ffffffff81b495fe>] nouveau_pci_probe+0x15/0x17
[ 6101.302253]                                       [<ffffffff8154afef>] local_pci_probe+0x5f/0xd0
[ 6101.302253]                                       [<ffffffff8154c211>] pci_device_probe+0x101/0x120
[ 6101.302253]                                       [<ffffffff81691013>] driver_probe_device+0xa3/0x2c0
[ 6101.302253]                                       [<ffffffff816912cb>] __driver_attach+0x9b/0xa0
[ 6101.302253]                                       [<ffffffff8169049c>] bus_for_each_dev+0x6c/0xa0
[ 6101.302253]                                       [<ffffffff81690d9e>] driver_attach+0x1e/0x20
[ 6101.302253]                                       [<ffffffff8168fb58>] bus_add_driver+0x1d8/0x3a0
[ 6101.302253]                                       [<ffffffff81691618>] driver_register+0x78/0x140
[ 6101.302253]                                       [<ffffffff8154c4c6>] __pci_register_driver+0x66/0xe0
[ 6101.302253]                                       [<ffffffff815fd60a>] drm_pci_init+0xda/0xf0
[ 6101.302253]                                       [<ffffffff815f4698>] drm_init+0x58/0x70
[ 6101.302253]                                       [<ffffffff8264a6ce>] nouveau_init+0x48/0x4a
[ 6101.302253]                                       [<ffffffff810001e3>] do_one_initcall+0x43/0x180
[ 6101.302253]                                       [<ffffffff82616543>] kernel_init+0x161/0x1ea
[ 6101.302253]                                       [<ffffffff81041794>] kernel_thread_helper+0x4/0x10
[ 6101.302253]  }
[ 6101.302253]  ... key      at: [<ffffffff830e4255>] __key.41950+0x0/0xb
[ 6101.302253]  ... acquired at:
[ 6101.302253]    [<ffffffff810d3bc0>] check_irq_usage+0x60/0xf0
[ 6101.302253]    [<ffffffff810d6121>] __lock_acquire+0x1071/0x1bb0
[ 6101.302253]    [<ffffffff810d6cf5>] lock_acquire+0x95/0x220
[ 6101.302253]    [<ffffffff81b66ff0>] _raw_spin_lock+0x40/0x80
[ 6101.302253]    [<ffffffff8161b9ff>] nouveau_gpuobj_del+0x6f/0x150
[ 6101.302253]    [<ffffffff8151c277>] kref_put+0x37/0x70
[ 6101.302253]    [<ffffffff8161b863>] nouveau_gpuobj_ref+0x43/0x60
[ 6101.302253]    [<ffffffff8165226a>] nv50_graph_destroy_context+0x9a/0xf0
[ 6101.302253]    [<ffffffff816185f8>] nouveau_channel_free+0x128/0x2c0
[ 6101.302253]    [<ffffffff8161886f>] nouveau_channel_cleanup+0x5f/0xc0
[ 6101.302253]    [<ffffffff816165be>] nouveau_preclose+0xe/0x10
[ 6101.302253]    [<ffffffff815f4c9b>] drm_release+0x7b/0x700
[ 6101.302253]    [<ffffffff811899ae>] fput+0xfe/0x260
[ 6101.302253]    [<ffffffff811859bd>] filp_close+0x5d/0x90
[ 6101.302253]    [<ffffffff8109ab38>] put_files_struct+0x198/0x310
[ 6101.302253]    [<ffffffff8109ad02>] exit_files+0x52/0x60
[ 6101.302253]    [<ffffffff8109cc0d>] do_exit+0x14d/0x940
[ 6101.302253]    [<ffffffff8109d45e>] do_group_exit+0x5e/0xd0
[ 6101.302253]    [<ffffffff8109d4e7>] sys_exit_group+0x17/0x20
[ 6101.302253]    [<ffffffff810409db>] system_call_fastpath+0x16/0x1b
[ 6101.302253]
[ 6101.302253]
[ 6101.302253] stack backtrace:
[ 6101.302253] Pid: 8245, comm: kwin_opengl_tes Not tainted 2.6.37-rc1-00027-gff8b16d #1
[ 6101.302253] Call Trace:
[ 6101.302253]  [<ffffffff810d3ab8>] check_usage+0x4a8/0x550
[ 6101.302253]  [<ffffffff810d3bc0>] check_irq_usage+0x60/0xf0
[ 6101.302253]  [<ffffffff810d6121>] __lock_acquire+0x1071/0x1bb0
[ 6101.302253]  [<ffffffff810c57a5>] ? sched_clock_local+0x25/0x90
[ 6101.302253]  [<ffffffff810d6cf5>] lock_acquire+0x95/0x220
[ 6101.302253]  [<ffffffff8161b9ff>] ? nouveau_gpuobj_del+0x6f/0x150
[ 6101.302253]  [<ffffffff816160c3>] ? nouveau_wait_until+0x53/0xa0
[ 6101.302253]  [<ffffffff81b66ff0>] _raw_spin_lock+0x40/0x80
[ 6101.302253]  [<ffffffff8161b9ff>] ? nouveau_gpuobj_del+0x6f/0x150
[ 6101.302253]  [<ffffffff81663bf7>] ? nv84_instmem_flush+0x47/0x80
[ 6101.302253]  [<ffffffff8161b9ff>] nouveau_gpuobj_del+0x6f/0x150
[ 6101.302253]  [<ffffffff8161b990>] ? nouveau_gpuobj_del+0x0/0x150
[ 6101.302253]  [<ffffffff8151c277>] kref_put+0x37/0x70
[ 6101.302253]  [<ffffffff8161b863>] nouveau_gpuobj_ref+0x43/0x60
[ 6101.302253]  [<ffffffff8165226a>] nv50_graph_destroy_context+0x9a/0xf0
[ 6101.302253]  [<ffffffff816185f8>] nouveau_channel_free+0x128/0x2c0
[ 6101.302253]  [<ffffffff8161886f>] nouveau_channel_cleanup+0x5f/0xc0
[ 6101.302253]  [<ffffffff816165be>] nouveau_preclose+0xe/0x10
[ 6101.302253]  [<ffffffff815f4c9b>] drm_release+0x7b/0x700
[ 6101.302253]  [<ffffffff8119cda4>] ? d_free+0x74/0x80
[ 6101.302253]  [<ffffffff811899ae>] fput+0xfe/0x260
[ 6101.302253]  [<ffffffff811859bd>] filp_close+0x5d/0x90
[ 6101.302253]  [<ffffffff8109ab38>] put_files_struct+0x198/0x310
[ 6101.302253]  [<ffffffff8109a9d8>] ? put_files_struct+0x38/0x310
[ 6101.302253]  [<ffffffff8109ad02>] exit_files+0x52/0x60
[ 6101.302253]  [<ffffffff8109cc0d>] do_exit+0x14d/0x940
[ 6101.302253]  [<ffffffff81b6836d>] ? retint_swapgs+0xe/0x13
[ 6101.302253]  [<ffffffff8109d45e>] do_group_exit+0x5e/0xd0
[ 6101.302253]  [<ffffffff8109d4e7>] sys_exit_group+0x17/0x20
[ 6101.302253]  [<ffffffff810409db>] system_call_fastpath+0x16/0x1b
[ 6101.639187] EXT4-fs (dm-0): re-mounted. Opts: acl,commit=0
[ 6101.646541] [drm] nouveau 0000:01:00.0: unknown parameter 15
[ 6101.648902] [drm] nouveau 0000:01:00.0: Allocating FIFO number 4
[ 6101.658270] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 4
[ 6475.784710] [drm] nouveau 0000:01:00.0: PFIFO_CACHE_ERROR - Ch 2/1 Mthd 0x0064 Data 0x0000000c
[ 6494.546626] SysRq : Show Locks Held
[ 6494.549708] INFO: lockdep is turned off.

--------------070505070207010601090009
Content-Type: text/plain;
 name="config-2.6.37-rc1-00027-gff8b16d"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-2.6.37-rc1-00027-gff8b16d"

#
# Automatically generated make config: don't edit
# Linux/x86_64 2.6.37-rc1 Kernel Configuration
# Wed Nov  3 20:15:09 2010
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
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_LZO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
# CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED is not set
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
# CONFIG_AUTO_IRQ_AFFINITY is not set
# CONFIG_IRQ_PER_CPU is not set
# CONFIG_HARDIRQS_SW_RESEND is not set
# CONFIG_SPARSE_IRQ is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_NS is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_NAMESPACES is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
# CONFIG_UID16 is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_PERF_COUNTERS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_UV is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=7
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_AMD_IOMMU=y
# CONFIG_AMD_IOMMU_STATS is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=64
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
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
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND_NVS=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION="/dev/sda3"
CONFIG_PM_RUNTIME=y
CONFIG_PM_OPS=y
# CONFIG_PM_OPP is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_POWER_METER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
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
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
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
CONFIG_DMAR=y
CONFIG_DMAR_DEFAULT_ON=y
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_INTR_REMAP=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_IOV=y
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
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
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_HYBLA is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_H323=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
CONFIG_NF_CONNTRACK_PPTP=y
CONFIG_NF_CONNTRACK_SANE=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CONNTRACK_TFTP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NETFILTER_TPROXY=y
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y
CONFIG_NETFILTER_XT_CONNMARK=y

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
CONFIG_NETFILTER_XT_TARGET_CONNMARK=y
CONFIG_NETFILTER_XT_TARGET_CT=y
CONFIG_NETFILTER_XT_TARGET_DSCP=y
CONFIG_NETFILTER_XT_TARGET_HL=y
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=y
CONFIG_NETFILTER_XT_TARGET_LED=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_NOTRACK=y
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
CONFIG_NETFILTER_XT_TARGET_TEE=y
CONFIG_NETFILTER_XT_TARGET_TPROXY=y
CONFIG_NETFILTER_XT_TARGET_TRACE=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=y

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_CLUSTER=y
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_CPU=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
CONFIG_NETFILTER_XT_MATCH_HELPER=y
CONFIG_NETFILTER_XT_MATCH_HL=y
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
CONFIG_NETFILTER_XT_MATCH_OSF=y
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_RATEEST=y
CONFIG_NETFILTER_XT_MATCH_REALM=y
CONFIG_NETFILTER_XT_MATCH_RECENT=y
CONFIG_NETFILTER_XT_MATCH_SCTP=y
CONFIG_NETFILTER_XT_MATCH_SOCKET=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=y
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_ADDRTYPE=y
CONFIG_IP_NF_MATCH_AH=y
CONFIG_IP_NF_MATCH_ECN=y
CONFIG_IP_NF_MATCH_TTL=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
CONFIG_IP_NF_TARGET_NETMAP=y
CONFIG_IP_NF_TARGET_REDIRECT=y
CONFIG_NF_NAT_SNMP_BASIC=y
CONFIG_NF_NAT_PROTO_DCCP=y
CONFIG_NF_NAT_PROTO_GRE=y
CONFIG_NF_NAT_PROTO_UDPLITE=y
CONFIG_NF_NAT_PROTO_SCTP=y
CONFIG_NF_NAT_FTP=y
CONFIG_NF_NAT_IRC=y
CONFIG_NF_NAT_TFTP=y
CONFIG_NF_NAT_AMANDA=y
CONFIG_NF_NAT_PPTP=y
CONFIG_NF_NAT_H323=y
CONFIG_NF_NAT_SIP=y
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_CLUSTERIP=y
CONFIG_IP_NF_TARGET_ECN=y
CONFIG_IP_NF_TARGET_TTL=y
CONFIG_IP_NF_RAW=y
CONFIG_IP_NF_ARPTABLES=y
CONFIG_IP_NF_ARPFILTER=y
CONFIG_IP_NF_ARP_MANGLE=y

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=y
CONFIG_NF_CONNTRACK_IPV6=y
CONFIG_IP6_NF_QUEUE=y
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_AH=y
CONFIG_IP6_NF_MATCH_EUI64=y
CONFIG_IP6_NF_MATCH_FRAG=y
CONFIG_IP6_NF_MATCH_OPTS=y
CONFIG_IP6_NF_MATCH_HL=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
CONFIG_IP6_NF_MATCH_MH=y
CONFIG_IP6_NF_MATCH_RT=y
CONFIG_IP6_NF_TARGET_HL=y
CONFIG_IP6_NF_TARGET_LOG=y
CONFIG_IP6_NF_FILTER=y
CONFIG_IP6_NF_TARGET_REJECT=y
CONFIG_IP6_NF_MANGLE=y
CONFIG_IP6_NF_RAW=y
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
CONFIG_BRIDGE_EBT_802_3=y
CONFIG_BRIDGE_EBT_AMONG=y
CONFIG_BRIDGE_EBT_ARP=y
CONFIG_BRIDGE_EBT_IP=y
CONFIG_BRIDGE_EBT_IP6=y
CONFIG_BRIDGE_EBT_LIMIT=y
CONFIG_BRIDGE_EBT_MARK=y
CONFIG_BRIDGE_EBT_PKTTYPE=y
CONFIG_BRIDGE_EBT_STP=y
CONFIG_BRIDGE_EBT_VLAN=y
CONFIG_BRIDGE_EBT_ARPREPLY=y
CONFIG_BRIDGE_EBT_DNAT=y
CONFIG_BRIDGE_EBT_MARK_T=y
CONFIG_BRIDGE_EBT_REDIRECT=y
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
CONFIG_BRIDGE_EBT_ULOG=y
CONFIG_BRIDGE_EBT_NFLOG=y
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=y
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=y
CONFIG_L2TP_ETH=y
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
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
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=m
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_RPS=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=y
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_EMS_PCI=m
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PLX_PCI=m

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=m
CONFIG_CAN_ESD_USB2=m
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRNET=m
CONFIG_IRCOMM=y
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_MCS_FIR=m
CONFIG_BT=y
CONFIG_BT_L2CAP=y
CONFIG_BT_SCO=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
# CONFIG_BT_HCIBT3C is not set
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
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
CONFIG_CFG80211_DEBUGFS=y
CONFIG_CFG80211_INTERNAL_REGDB=y
CONFIG_CFG80211_WEXT=y
# CONFIG_WIRELESS_EXT_SYSFS is not set
CONFIG_LIB80211=y
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT="pid"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE="nouveau/nv50.ctxprog nouveau/nv50.ctxvals"
CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=4
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=y
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_DS1682=m
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085 is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_IWMC3200TOP=m
# CONFIG_IWMC3200TOP_DEBUG is not set
# CONFIG_IWMC3200TOP_DEBUGFS is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
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
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_PCMCIA_AHA152X is not set
CONFIG_PCMCIA_FDOMAIN=m
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
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
# CONFIG_SATA_NV is not set
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
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
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
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MULTICORE_RAID456=y
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=y
# CONFIG_FIREWIRE_NET is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
# CONFIG_EQUALIZER is not set
CONFIG_TUN=y
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_MII=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
# CONFIG_BCM63XX_PHY is not set
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=m
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
# CONFIG_NET_PCI is not set
# CONFIG_B44 is not set
# CONFIG_KS8842 is not set
# CONFIG_KS8851_MLL is not set
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
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
CONFIG_BNX2=y
CONFIG_CNIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_STMMAC_ETH is not set
# CONFIG_PCH_GBE is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
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
CONFIG_IWLWIFI=m

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
CONFIG_IWLAGN=m
CONFIG_IWL4965=y
CONFIG_IWL5000=y
CONFIG_IWL3945=m
CONFIG_IWM=m
# CONFIG_IWM_DEBUG is not set
# CONFIG_IWM_TRACING is not set
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RT2X00 is not set
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_ZD1211RW is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_USB=m
CONFIG_WIMAX_I2400M_SDIO=m
# CONFIG_WIMAX_IWMC3200_SDIO is not set
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SMSC75XX=m
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
# CONFIG_USB_NET_CX82310_ETH is not set
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_IPHETH=m
CONFIG_USB_SIERRA_NET=m
CONFIG_NET_PCMCIA=y
CONFIG_PCMCIA_3C589=m
CONFIG_PCMCIA_3C574=m
CONFIG_PCMCIA_FMVJ18X=m
CONFIG_PCMCIA_PCNET=m
CONFIG_PCMCIA_NMCLAN=m
CONFIG_PCMCIA_SMC91C92=m
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_PCMCIA_AXNET=m
# CONFIG_WAN is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOATM=m
# CONFIG_PPPOL2TP is not set
CONFIG_SLIP=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_VIRTIO_NET is not set
CONFIG_VMXNET3=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
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
CONFIG_MOUSE_PS2_ELANTECH=y
# CONFIG_MOUSE_PS2_SENTELIC is not set
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
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
CONFIG_JOYSTICK_SIDEWINDER=m
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
# CONFIG_JOYSTICK_XPAD_LEDS is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=m
CONFIG_TOUCHSCREEN_AD7879_I2C=m
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=m
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
# CONFIG_TOUCHSCREEN_QT602240 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC2007=m
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_PCSPKR is not set
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_WINBOND_CIR=m
CONFIG_INPUT_PCF50633_PMU=m
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=m
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_N_GSM is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
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
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
CONFIG_MWAVE=m
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=m
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m

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
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2782=m
# CONFIG_BATTERY_BQ20Z75 is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_MAX17040=m
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_PKGTEMP is not set
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_LIS3_I2C=m
CONFIG_SENSORS_APPLESMC=m

#
# ACPI drivers
#
CONFIG_SENSORS_ATK0110=m
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
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
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
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
CONFIG_MFD_SUPPORT=y
CONFIG_MFD_CORE=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_SM501=m
CONFIG_HTC_PASIC3=m
CONFIG_TPS6507X=m
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_TC35892=y
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_WM8400=m
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_AB3550_CORE=y
CONFIG_LPC_SCH=m
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_IR_CORE=y
CONFIG_VIDEO_IR=y
CONFIG_LIRC=y
CONFIG_RC_MAP=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_RC5_SZ_DECODER=y
CONFIG_IR_LIRC_CODEC=y
# CONFIG_IR_ENE is not set
CONFIG_IR_IMON=m
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_STREAMZAP is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_SAA6588=m
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_VPX3220=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_BT848_DVB=y
CONFIG_VIDEO_CPIA2=m
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_DC30=m
CONFIG_VIDEO_ZORAN_ZR36060=m
CONFIG_VIDEO_ZORAN_BUZ=m
CONFIG_VIDEO_ZORAN_DC10=m
CONFIG_VIDEO_ZORAN_LML33=m
CONFIG_VIDEO_ZORAN_LML33R10=m
CONFIG_VIDEO_ZORAN_AVS6EYES=m
CONFIG_VIDEO_MEYE=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_MXB=m
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX23885=m
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_FB_IVTV=m
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CX18_ALSA=m
CONFIG_VIDEO_SAA7164=m
CONFIG_VIDEO_CAFE_CCIC=m
# CONFIG_VIDEO_SR030PC30 is not set
CONFIG_SOC_CAMERA=m
# CONFIG_SOC_CAMERA_IMX074 is not set
CONFIG_SOC_CAMERA_MT9M001=m
CONFIG_SOC_CAMERA_MT9M111=m
CONFIG_SOC_CAMERA_MT9T031=m
CONFIG_SOC_CAMERA_MT9T112=m
CONFIG_SOC_CAMERA_MT9V022=m
CONFIG_SOC_CAMERA_RJ54N1=m
CONFIG_SOC_CAMERA_TW9910=m
CONFIG_SOC_CAMERA_PLATFORM=m
# CONFIG_SOC_CAMERA_OV6650 is not set
CONFIG_SOC_CAMERA_OV772X=m
CONFIG_SOC_CAMERA_OV9640=m
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
# CONFIG_USB_M5602 is not set
# CONFIG_USB_STV06XX is not set
CONFIG_USB_GL860=m
CONFIG_USB_GSPCA_BENQ=m
# CONFIG_USB_GSPCA_CONEX is not set
CONFIG_USB_GSPCA_CPIA1=m
# CONFIG_USB_GSPCA_ETOMS is not set
# CONFIG_USB_GSPCA_FINEPIX is not set
CONFIG_USB_GSPCA_JEILINJ=m
# CONFIG_USB_GSPCA_KONICA is not set
# CONFIG_USB_GSPCA_MARS is not set
# CONFIG_USB_GSPCA_MR97310A is not set
# CONFIG_USB_GSPCA_OV519 is not set
# CONFIG_USB_GSPCA_OV534 is not set
CONFIG_USB_GSPCA_OV534_9=m
# CONFIG_USB_GSPCA_PAC207 is not set
# CONFIG_USB_GSPCA_PAC7302 is not set
# CONFIG_USB_GSPCA_PAC7311 is not set
CONFIG_USB_GSPCA_SN9C2028=m
# CONFIG_USB_GSPCA_SN9C20X is not set
# CONFIG_USB_GSPCA_SONIXB is not set
# CONFIG_USB_GSPCA_SONIXJ is not set
# CONFIG_USB_GSPCA_SPCA500 is not set
# CONFIG_USB_GSPCA_SPCA501 is not set
# CONFIG_USB_GSPCA_SPCA505 is not set
# CONFIG_USB_GSPCA_SPCA506 is not set
# CONFIG_USB_GSPCA_SPCA508 is not set
# CONFIG_USB_GSPCA_SPCA561 is not set
# CONFIG_USB_GSPCA_SPCA1528 is not set
# CONFIG_USB_GSPCA_SQ905 is not set
# CONFIG_USB_GSPCA_SQ905C is not set
# CONFIG_USB_GSPCA_SQ930X is not set
# CONFIG_USB_GSPCA_STK014 is not set
# CONFIG_USB_GSPCA_STV0680 is not set
# CONFIG_USB_GSPCA_SUNPLUS is not set
# CONFIG_USB_GSPCA_T613 is not set
# CONFIG_USB_GSPCA_TV8532 is not set
# CONFIG_USB_GSPCA_VC032X is not set
# CONFIG_USB_GSPCA_XIRLINK_CIT is not set
# CONFIG_USB_GSPCA_ZC3XX is not set
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
CONFIG_VIDEO_TLG2300=m
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_ALSA=m
CONFIG_VIDEO_CX231XX_DVB=m
CONFIG_VIDEO_USBVISION=m
CONFIG_VIDEO_USBVIDEO=m
CONFIG_USB_VICAM=m
CONFIG_USB_IBMCAM=m
CONFIG_USB_KONICAWC=m
CONFIG_USB_ET61X251=m
CONFIG_USB_SE401=m
CONFIG_USB_SN9C102=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_GEMTEK_PCI=m
CONFIG_RADIO_MAXIRADIO=m
CONFIG_RADIO_MAESTRO=m
CONFIG_I2C_SI4713=m
CONFIG_RADIO_SI4713=m
CONFIG_USB_DSBR=m
# CONFIG_RADIO_SI470X is not set
CONFIG_USB_MR800=m
CONFIG_RADIO_TEA5764=m
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m
CONFIG_DVB_BUDGET_PATCH=m

#
# Supported USB Adapters
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
# CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_CINERGY_T2=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_DTV5100=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_USB_CE6230=m
CONFIG_DVB_USB_FRIIO=m
CONFIG_DVB_USB_EC168=m
CONFIG_DVB_USB_AZ6027=m
# CONFIG_DVB_USB_LME2510 is not set
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_SMS_SIANO_MDTV=m

#
# Siano module components
#
CONFIG_SMS_USB_DRV=m
CONFIG_SMS_SDIO_DRV=m

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_DEBUG is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=m

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=m

#
# Supported SDMC DM1105 Adapters
#
CONFIG_DVB_DM1105=m
# CONFIG_DVB_FIREDTV is not set

#
# Supported Earthsoft PT1 Adapters
#
# CONFIG_DVB_PT1 is not set

#
# Supported Mantis Adapters
#
# CONFIG_MANTIS_CORE is not set

#
# Supported nGene Adapters
#
# CONFIG_DVB_NGENE is not set

#
# Supported DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV6110x=m
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_S5H1411=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m
CONFIG_DVB_LNBP21=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DAB=y
CONFIG_USB_DABUSB=m

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_TTM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
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
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

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
# CONFIG_FB_VESA is not set
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
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_PROGEAR=m
CONFIG_BACKLIGHT_MBP_NVIDIA=m
CONFIG_BACKLIGHT_SAHARA=m
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_PCF50633 is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=128
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_FONT_6x11=y
CONFIG_FONT_7x14=y
CONFIG_FONT_PEARL_8x8=y
CONFIG_FONT_ACORN_8x8=y
CONFIG_FONT_MINI_4x6=y
CONFIG_FONT_SUN8x16=y
CONFIG_FONT_SUN12x22=y
CONFIG_FONT_10x18=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_VIRMIDI is not set
CONFIG_SND_MTPAV=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
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
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=5
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
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
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=m
CONFIG_SND_PDAUDIOCF=m
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
# CONFIG_HID_3M_PCT is not set
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX_FF is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_BELKIN=m
# CONFIG_HID_CANDO is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EGALAX is not set
CONFIG_HID_ELECOM=y
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWII_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MOSART is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_ROCCAT_KONE is not set
# CONFIG_HID_ROCCAT_PYRA is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_STANTUM is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
# CONFIG_USB_UAS is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
# CONFIG_USB_EZUSB is not set
# CONFIG_USB_SERIAL_GENERIC is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
CONFIG_USB_SERIAL_MOTOROLA=m
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
CONFIG_USB_SERIAL_QCAUX=m
# CONFIG_USB_SERIAL_QUALCOMM is not set
CONFIG_USB_SERIAL_SPCP8X5=m
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SAMBA is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=m
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_VIVOPAY_SERIAL=m
CONFIG_USB_SERIAL_ZIO=m
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_I1480U=m
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
# CONFIG_MMC_RICOH_MMC is not set
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SDRICOH_CS=m
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
# CONFIG_MMC_USHC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

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
# CONFIG_EDAC_DECODE_MCE is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_MCE=y
CONFIG_EDAC_E752X=y
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
CONFIG_EDAC_I5400=y
CONFIG_EDAC_I7CORE=y
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
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
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_S35390A=m
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=m
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=m
CONFIG_RTC_DRV_PCF50633=m

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=m
CONFIG_STAGING=y
# CONFIG_STAGING_EXCLUDE_BUILD is not set
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_VIDEO_GO7007 is not set
# CONFIG_VIDEO_CX25821 is not set
# CONFIG_VIDEO_TM6000 is not set
CONFIG_VIDEO_CPIA=m
CONFIG_VIDEO_CPIA_USB=m
CONFIG_VIDEO_STRADIS=m
# CONFIG_USB_IP_COMMON is not set
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
# CONFIG_BRCM80211 is not set
# CONFIG_RT2860 is not set
# CONFIG_RT2870 is not set
# CONFIG_COMEDI is not set
# CONFIG_ASUS_OLED is not set
# CONFIG_R8187SE is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTL8192E is not set
# CONFIG_R8712U is not set
# CONFIG_TRANZPORT is not set
# CONFIG_POHMELFS is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_LINE6_USB is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_NOUVEAU_DEBUG=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_USB_SERIAL_QUATECH_USB2 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_FB_UDL is not set
# CONFIG_HYPERV is not set
# CONFIG_VME_BUS is not set
# CONFIG_IIO is not set
# CONFIG_ZRAM is not set
# CONFIG_WLAGS49_H2 is not set
# CONFIG_WLAGS49_H25 is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_VIDEO_DT3155 is not set
# CONFIG_CRYSTALHD is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_ST_BT is not set
# CONFIG_FB_XGI is not set
# CONFIG_LIRC_STAGING is not set
# CONFIG_SMB_FS is not set
# CONFIG_EASYCAP is not set
# CONFIG_SOLO6X10 is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_MACH_NO_WESTBRIDGE=y
# CONFIG_ATH6K_LEGACY is not set
# CONFIG_USB_ENESTORAGE is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
CONFIG_ACERHDF=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_DELL_WMI is not set
CONFIG_FUJITSU_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_HP_WMI=m
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=m
CONFIG_COMPAL_LAPTOP=m
CONFIG_SONY_LAPTOP=m
# CONFIG_SONYPI_COMPAT is not set
# CONFIG_IDEAPAD_LAPTOP is not set
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=m
CONFIG_INTEL_MENLOW=m
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_EEEPC_WMI is not set
CONFIG_ACPI_WMI=m
# CONFIG_MSI_WMI is not set
CONFIG_ACPI_ASUS=m
# CONFIG_TOPSTAR_LAPTOP is not set
CONFIG_ACPI_TOSHIBA=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_NILFS2_FS=m
CONFIG_EXPORTFS=y
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
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
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
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

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
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_LOGFS=m
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_XATTR is not set
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFS_USE_NEW_IDMAPPER is not set
CONFIG_NFSD=y
CONFIG_NFSD_DEPRECATED=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
CONFIG_CEPH_FS=m
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf-8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=y
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_BKL=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
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
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE=y
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_DYNAMIC_FTRACE=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
# CONFIG_INTEL_TXT is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
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
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_FPU=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_CRYPTO_DEV_HIFN_795X=m
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_VHOST_NET=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_NLATTR=y

--------------070505070207010601090009--
