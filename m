Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab2EaApA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 20:45:00 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62223 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab2EaAo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 20:44:56 -0400
Date: Wed, 30 May 2012 20:44:47 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: andrzej.p@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        arnd@arndb.de, tony.luck@intel.com, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Bug in BUG: Bad page state in process work_for_cpu  pfn:cf800
Message-ID: <20120531004446.GA401@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey,

About two-three days ago I started getting this on one of the AMD
machines I run nighly bootup test (full bootup log attached):
[Note: This is baremetal]

ehci_hcd 0000:00:02.1: reset hcc_params a086 caching frame 256/512/1024 park
BUG: Bad page state in process work_for_cpu  pfn:cf800
page:ffffea0002d64000 count:-1 mapcount:0 ing:          (null) index:0x0
page flags: 0x100000000000000()
Modules linked in:
Pid: 1207, comm: work_for_cpu Not tainted 3.4.0upstream-09208-gaf56e0a #1
Call Trace:
 [<ffffffff81103eb7>] ? dump_page+0x97/0xf0
 [<ffffffff811050bd>] bad_page+0xad/0x100
 [<ffffffff811067a2>] get_page_from_freelist+0x712/0x850
 [<ffffffff812916d8>] ? __const_udelay+0x28/0x30
 [<ffffffff81107a82>] __alloc_pages_nodemask+0x162/0x900
 [<ffffffff810a2975>] ? dequeue_task_fair+0xa5/0x330
 [<ffffffff810367e2>] ? __switch_to+0x152/0x440
 [<ffffffff8107ee37>] ? lock_timer_base+0x37/0x70
 [<ffffffff8103c7ff>] dma_generic_alloc_coherent+0x10f/0x170
 [<ffffffff81062e7e>] gart_alloc_coherent+0xee/0x120
 [<ffffffff81137542>] dma_pool_alloc+0x102/0x2e0
 [<ffffffff8109f240>] ? try_to_wake_up+0x310/0x310
 [<ffffffff813f3dc7>] ehci_qh_alloc+0x47/0xf0
 [<ffffffff813f81e7>] ehci_pci_setup+0x367/0xea0
 [<ffffffff81389213>] ? device_pm_init+0x43/0x80
 [<ffffffff813d3065>] ? usb_alloc_dev+0x2d5/0x330
 [<ffffffff81002030>] ? do_one_initcall+0x30/0x170
 [<ffffffff813db6a9>] usb_add_hcd+0x1e9/0x7a0
 [<ffffffff813ea0fa>] usb_hcd_pci_probe+0x1ba/0x3a0
 [<ffffffff81088890>] ? cwq_dec_nr_in_flight+0x90/0x90
 [<ffffffff812ad3f2>] local_pci_probe+0x12/0x20
 [<ffffffff810888a3>] do_work_for_cpu+0x13/0x30
 [<ffffffff810906e6>] kthread+0x96/0xa0
 [<ffffffff815b61e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81090650>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815b61e0>] ? gs_change+0x13/0x13
Disabling lock debugging due to kernel taint
BUG: Bad page state in process work_for_cpu  pfn:cf801

I haven't actually run a git bisection, but the last git commit
that does something in the gart code looks to be this one:

commit baa676fcf8d555269bd0a5a2496782beee55824d
Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Date:   Tue Mar 27 14:28:18 2012 +0200

    X86 & IA64: adapt for dma_map_ops changes

hence CC-ing on this e-email.
   
Was wondering if other people had seen something similar to this?

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="gart-crash.log"
Content-Transfer-Encoding: quoted-printable

Loading latest/vmlinuz.....................................................=
=2E...........
Loading latest/initramfs.cpio.gz...........................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E......................................
 ..................................................................ready.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3./initramfs.cpio.gz nofb debug selinux=3D0 co=
nsole=3DttyS0,115200 loglevel=3D10 apic=3Ddebug BOOT_IMAGE=3Dlatest/vmlinuz=
=20
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000cc000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ffeffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007fff0000-0x000000007fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000080000000-0x00000000cfeeffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cfef0000-0x00000000cfef4fff] ACPI =
data
[    0.000000] BIOS-e820: [mem 0x00000000cfef5000-0x00000000cff7efff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000cff80000-0x00000000cfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fff80000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000012fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Dell Inc. PowerEdge T105 /0RR825, BIOS 1.3.2 08/20/2008
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x130000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-protect
[    0.000000]   CC000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000130000000 aka 4864M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable =3D=3D> rese=
rved
[    0.000000] e820: last_pfn =3D 0xcfef0 max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f7a70-0x000f7a7f] mapped at =
[ffff8800000f7a70]
[    0.000000]   mpc: 9e171-9e2b5
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0xcfeeffff]
[    0.000000]  [mem 0x00000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xcfdfffff] page 2M
[    0.000000]  [mem 0xcfe00000-0xcfeeffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xcfeeffff @ [mem 0x1f9fd=
000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x12fffffff]
[    0.000000]  [mem 0x100000000-0x12fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x12fffffff @ [mem 0xcfd6=
e000-0xcfeeffff]
[    0.000000] RAMDISK: [mem 0x7bff1000-0x7ffcefff]
[    0.000000] ACPI: RSDP 00000000000f79b0 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 00000000cfef0753 0009C (v01 DELL   PE_SC3   06040=
000 DELL 00000000)
[    0.000000] ACPI: FACP 00000000cfef3c5f 000F4 (v03 DELL   PE_SC3   06040=
000 DELL 000F4240)
[    0.000000] ACPI: DSDT 00000000cfef07ef 033FC (v01 DELL   PE_SC3   06040=
000 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000cfef5fc0 00040
[    0.000000] ACPI: TCPA 00000000cfef3d53 00032 (v01 Phoeni  x       06040=
000  TL  00000000)
[    0.000000] ACPI: SLIC 00000000cfef3d85 00024 (v01 DELL   PE_SC3   06040=
000 PTL  00000001)
[    0.000000] ACPI: SPCR 00000000cfef3da9 00050 (v01 DELL   PE_SC3   06040=
000 PTL  00000001)
[    0.000000] ACPI: EINJ 00000000cfef3df9 001B0 (v01 PTL    WHEAPTL  06040=
000 PTL  00000001)
[    0.000000] ACPI: HEST 00000000cfef3fa9 000A8 (v01 PTL    WHEAPTL  06040=
000 PTL  00000001)
[    0.000000] ACPI: BERT 00000000cfef4051 00030 (v01 PTL    WHEAPTL  06040=
000 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000cfef4081 000E1 (v01 wheaos  wheaosc 06040=
000 INTL 20050624)
[    0.000000] ACPI: ERST 00000000cfef4162 00270 (v01 PTL    WHEAPTL  06040=
000 PTL  00000001)
[    0.000000] ACPI: SRAT 00000000cfef43d2 000E8 (v01 AMD    HAMMER   06040=
000 AMD  00000001)
[    0.000000] ACPI: SSDT 00000000cfef44ba 00A30 (v01 AMD    POWERNOW 06040=
000 AMD  00000001)
[    0.000000] ACPI: MCFG 00000000cfef4eea 0003C (v01 PTLTD    MCFG   06040=
000  LTP 00000000)
[    0.000000] ACPI: HPET 00000000cfef4f26 00038 (v01 PTLTD  HPETTBL  06040=
000  LTP 00000001)
[    0.000000] ACPI: APIC 00000000cfef4f5e 0007A (v01 PTLTD  ? APIC   06040=
000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000cfef4fd8 00028 (v01 PTLTD  $SBFTBL$ 06040=
000  LTP 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00100000-0xcfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x12fffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0=
xcfffffff] -> [mem 0x00000000-0xcfffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xcfffffff] + [mem 0x100000000-=
0x12fffffff] -> [mem 0x00000000-0x12fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x12fffffff]
[    0.000000]   NODE_DATA [mem 0x12fffc000-0x12fffffff]
[    0.000000]  [ffffea0000000000-ffffea00043fffff] PMD -> [ffff88012b60000=
0-ffff88012effffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x12fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x7ffeffff]
[    0.000000]   node   0: [mem 0x80000000-0xcfeeffff]
[    0.000000]   node   0: [mem 0x100000000-0x12fffffff]
[    0.000000] On node 0 totalpages: 1048173
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3919 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833304 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] Int: type 0, pol 1, trig 1, bus 00, IRQ 00, APIC ID 4, APIC =
INT 02
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 09, APIC ID 4, APIC =
INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 4, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 4, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 4, APIC =
INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 4, APIC =
INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 4, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 4, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 4, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 4, APIC =
INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 4, APIC =
INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 4, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 4, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 4, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 4, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000=
9e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
cc000
[    0.000000] PM: Registered nosave memory: 00000000000cc000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 000000007fff0000 - 00000000800=
00000
[    0.000000] PM: Registered nosave memory: 00000000cfef0000 - 00000000cfe=
f5000
[    0.000000] PM: Registered nosave memory: 00000000cfef5000 - 00000000cff=
7f000
[    0.000000] PM: Registered nosave memory: 00000000cff7f000 - 00000000cff=
80000
[    0.000000] PM: Registered nosave memory: 00000000cff80000 - 00000000d00=
00000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e00=
00000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f00=
00000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec=
00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec=
10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee=
00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee=
01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff=
80000
[    0.000000] PM: Registered nosave memory: 00000000fff80000 - 00000001000=
00000
[    0.000000] e820: [mem 0xd0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88012fc00000 s78464 r8192=
 d23936 u524288
[    0.000000] pcpu-alloc: s78464 r8192 d23936 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1031143
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: initrd=3Dlatest/initramfs.cpio.gz nofb =
debug selinux=3D0 console=3DttyS0,115200 loglevel=3D10 apic=3Ddebug BOOT_IM=
AGE=3Dlatest/vmlinuz=20
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 81c0000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ c4000000
[    0.000000] PM: Registered nosave memory: 00000000c4000000 - 00000000c80=
00000
[    0.000000] Memory: 3925372k/4980736k available (5861k kernel code, 7880=
44k absent, 267320k reserved, 2858k data, 704k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.001000] Fast TSC calibration using PIT
[    0.002000] Detected 2109.561 MHz processor.
[    0.000005] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4219.12 BogoMIPS (lpj=3D2109561)
[    0.010570] pid_max: default: 32768 minimum: 301
[    0.015216] Security Framework initialized
[    0.019301] SELinux:  Disabled at boot.
[    0.023426] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.032441] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.040284] Mount-cache hash table entries: 256
[    0.045008] Initializing cgroup subsys cpuacct
[    0.049438] Initializing cgroup subsys freezer
[    0.053898] tseg: 00cff80000
[    0.056771] CPU: Physical Processor ID: 0
[    0.060768] CPU: Processor Core ID: 0
[    0.064420] mce: CPU supports 6 MCE banks
[    0.068425] LVT offset 0 assigned for vector 0xf9
[    0.073119] using AMD E400 aware idle routine
[    0.079336] ACPI: Core revision 20120320
[    0.086329] Getting VERSION: 80050010
[    0.089982] Getting VERSION: 80050010
[    0.093634] Getting ID: 0
[    0.096246] Getting ID: ff000000
[    0.099465] Getting LVT0: 10000
[    0.102591] Getting LVT1: 10000
[    0.105729] masked ExtINT on CPU#0
[    0.109272] ENABLING IO-APIC IRQs
[    0.112577] init IO_APIC IRQs
[    0.115536]  apic 4 pin 0 not connected
[    0.119367] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.127259] IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.135153] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.143040] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.150927] IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5 Mode:0 Ac=
tive:0 Dest:1)
[    0.158817] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.166707] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.174598] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.182488] IOAPIC[0]: Set routing entry (4-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:1 Dest:1)
[    0.190378] IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10 Mode:0 =
Active:0 Dest:1)
[    0.198443] IOAPIC[0]: Set routing entry (4-11 -> 0x3b -> IRQ 11 Mode:0 =
Active:0 Dest:1)
[    0.206507] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.214571] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.222634] IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.230697] IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.238760]  apic 4 pin 16 not connected
[    0.242660]  apic 4 pin 17 not connected
[    0.246570]  apic 4 pin 18 not connected
[    0.250479]  apic 4 pin 19 not connected
[    0.254379]  apic 4 pin 20 not connected
[    0.258288]  apic 4 pin 21 not connected
[    0.262197]  apic 4 pin 22 not connected
[    0.266098]  apic 4 pin 23 not connected
[    0.270136] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.286123] CPU0: Quad-Core AMD Opteron(tm) Processor 1352 stepping 03
[    0.292628] Using local APIC timer interrupts.
[ [    0.401980] ... lapic delta =3D 1255740
[    0.405626] ... PM-Timer delta =3D 357941
[    0.409445] ... PM-Timer result ok
[    0.412832] ..... delta 1255740
[    0.415953] ..... mult: 53941821
[    0.419167] ..... calibration result: 200918
[    0.423419] ..... CPU clock speed is 2109.0642 MHz.
[    0.428269] ..... host bus clock speed is 200.0918 MHz.
[    0.433484] Performance Events: AMD PMU driver.
[    0.437997] ... version:                0
[    0.441991] ... bit width:              48
[    0.446073] ... generic registers:      4
[    0.450061] ... value mask:             0000ffffffffffff
[    0.455353] ... max period:             00007fffffffffff
[    0.460652] ... fixed-purpose events:   0
[    0.464640] ... event mask:             000000000000000f
[    0.470039] MCE: In-kernel MCE decoding enabled.
[    0.474652] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.491468] masked ExtINT on CPU#1
[    0.497001] Booting Node   0, Processors  #1
[    0.497001] NMI watchdog: enabled, ta[    0.517985] masked ExtINT on CPU=
#2
[    0.523514]  #2
[    0.523515] NMI watchdog: enabled, takes one hw-pmu counter.
[   Ok.
[    0.544087] masked ExtINT on CPU#3
[    0.549612] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.555269] Brought up 4 CPUs
[    0.558226] Total of 4 processors activated (16876.48 BogoMIPS).
[    0.566884] initlevel:0=3Dearly, 4 registered initcalls
[    0.572008] initlevel:1=3Dcore, 31 registered initcalls
[    0.577083] PM: Registering ACPI NVS region [mem 0xcfef5000-0xcff7efff] =
(565248 bytes)
[    0.585161] kworker/u:0 used greatest stack depth: 6016 bytes left
[    0.585185] RTC time: 23:34:43, date: 05/30/12
[    0.595790] NET: Registered protocol family 16
[    0.600228] initlevel:2=3Dpostcore, 13 registered initcalls
[    0.605805] kworker/u:0 used greatest stack depth: 5512 bytes left
[    0.606170] node 0 link 0: io port [1000, 4fff]
[    0.606172] node 0 link 0: io port [5000, fffff]
[    0.606173] TOM: 00000000d0000000 aka 3328M
[    0.606176] node 0 link 0: mmio [d0000000, d05fffff]
[    0.606178] node 0 link 0: mmio [fed00000, fed0ffff]
[    0.606179] node 0 link 0: mmio [d8000000, dfffffff]
[    0.606181] node 0 link 0: mmio [fec00000, fec0ffff]
[    0.606182] node 0 link 0: mmio [e0000000, efffffff]
[    0.606184] node 0 link 0: mmio [a0000, bffff]
[    0.606185] node 0 link 0: mmio [f0000000, fe0bffff]
[    0.606186] TOM2: 0000000130000000 aka 4864M
[    0.606188] bus: [00, ff] on node 0 link 0
[    0.606189] bus: 00 [io  0x0000-0xffff]
[    0.606190] bus: 00 [mem 0xd0000000-0xd7ffffff]
[    0.606191] bus: 00 [mem 0xfec10000-0xffffffff]
[    0.606192] bus: 00 [mem 0xd8000000-0xfebfffff]
[    0.606192] bus: 00 [mem 0xfec00000-0xfec0ffff]
[    0.606193] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.606194] bus: 00 [mem 0x130000000-0xfcffffffff]
[    0.698667] initlevel:3=3Darch, 13 registered initcalls
[    0.703795] ACPI: bus type pci registered
[    0.707926] dca service started, version 1.12.1
[    0.712506] PCI: MMCONFIG for domain 0000 [bus 00-04] at [mem 0xe0000000=
-0xe04fffff] (base 0xe0000000)
[    0.721779] PCI: MMCONFIG at [mem 0xe0000000-0xe04fffff] reserved in E820
[    0.729123] PCI: Using configuration type 1 for base access
[    0.734683] initlevel:4=3Dsubsys, 52 registered initcalls
[    0.747252] bio: create slab <bio-0> at 0
[    0.751499] ACPI: Added _OSI(Module Device)
[    0.755672] ACPI: Added _OSI(Processor Device)
[    0.760097] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.764783] ACPI: Added _OSI(Processor Aggregator Device)
[    0.771024] ACPI: EC: Look up EC in DSDT
[    0.775229] \_SB_:_OSC evaluation returned wrong type
[    0.780268] _OSC request data:1 7=20
[    0.786631] ACPI: Interpreter enabled
[    0.790296] ACPI: (supports S0 S4 S5)
[    0.793947] ACPI: Using IOAPIC for interrupt routing
[    0.806076] ACPI: No dock devices found.
[    0.809990] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnoc  0.832011] pci_root PNP0A03:00: host bridge window [io  0x0d00-0=
xffff]
[    0.838599] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff]
[    0.845879] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x00=
0dffff]
[    0.853164] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xfe=
bfffff]
[    0.860446] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfe=
d8ffff]
[    0.867729] pci_root PNP0A03:00: ignoring host bridge window [mem 0x000c=
0000-0x000dffff] (conflicts with reserved [mem 0x000cc000-0x000fffff])
[    0.880516] PCI host bridge to bus 0000:00
[    0.884600] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.890757] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.896913] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.903762] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xfebffff=
f]
[    0.910610] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed8fff=
f]
[    0.917470] pci 0000:00:00.0: [10de:005e] type 00 class 0x058000
[    0.923523] pci 0000:00:01.0: [10de:0051] type 00 class 0x060100
[    0.929511] pci 0000:00:01.0: reg 10: [io  0x8c00-0x8fff]
[    0.934912] pci 0000:00:01.1: [10de:0052] type 00 class 0x0c0500
[    0.940899] pci 0000:00:01.1: reg 10: [io  0x2080-0x209f]
[    0.946287] pci 0000:00:01.1: reg 20: [io  0x2040-0x207f]
[    0.951666] pci 0000:00:01.1: reg 24: [io  0x2000-0x203f]
[    0.957055] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.962879] pci 0000:00:02.0: [10de:005a] type 00 class 0x0c0310
[    0.968867] pci 0000:00:02.0: reg 10: [mem 0xd0000000-0xd0000fff]
[    0.974961] pci 0000:00:02.0: supports D1 D2
[    0.979216] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.985814] pci 0000:00:02.1: [10de:005b] type 00 class 0x0c0320
[    0.991803] pci 0000:00:02.1: reg 10: [mem 0xd0001000-0xd00010ff]
[    0.997901] pci 0000:00:02.1: supports D1 D2
[    1.002163] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.008769] pci 0000:00:07.0: [10de:0054] type 00 class 0x010185
[    1.014760] pci 0000:00:07.0: reg 10: [io  0x20f0-0x20f7]
[    1.020144] pci 0000:00:07.0: reg 14: [io  0x20e0-0x20e3]
[    1.025524] pci 0000:00:07.0: reg 18: [io  0x20d0-0x20d7]
[    1.030905] pci 0000:00:07.0: reg 1c: [io  0x20c0-0x20c3]
[    1.036284] pci 0000:00:07.0: reg 20: [io  0x20b0-0x20bf]
[    1.041665] pci 0000:00:07.0: reg 24: [mem 0xd0002000-0xd0002fff]
[    1.047760] pci 0000:00:08.0: [10de:0055] type 00 class 0x010185
[    1.053751] pci 0000:00:08.0: reg 10: [io  0x2440-0x2447]
[    1.059130] pci 0000:00:08.0: reg 14: [io  0x2430-0x2433]
[    1.064509] pci 0000:00:08.0: reg 18: [io  0x2420-0x2427]
[    1.069889] pci 0000:00:08.0: reg 1c: [io  0x2410-0x2413]
[    1.075269] pci 0000:00:08.0: reg 20: [io  0x2400-0x240f]
[    1.080650] pci 0000:00:08.0: reg 24: [mem 0xd0003000-0xd0003fff]
[    1.086743] pci 0000:00:09.0: [10de:005c] type 01 class 0x060400
[    1.092745] pci 0000:00:0b.0: [10de:005d] type 01 class 0x060400
[    1.098754] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.105355] pci 0000:00:0c.0: [10de:005d] type 01 class 0x060400
[    1.111365] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.117965] pci 0000:00:0d.0: [10de:005d] type 01 class 0x060400
[    1.123974] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.130573] pci 0000:00:0e.0: [10de:005d] type 01 class 0x060400
[    1.136581] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.143184] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    1.149186] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    1.155184] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    1.161182] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    1.167184] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    1.173204] pci 0000:01:07.0: [1077:6312] type 00 class 0x0c0400
[    1.179199] pci 0000:01:07.0: reg 10: [io  0x3000-0x30ff]
[    1.184582] pci 0000:01:07.0: reg 14: [mem 0xd0110000-0xd0110fff]
[    1.190674] pci 0000:01:07.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.197218] pci 0000:01:08.0: [1002:515e] type 00 class 0x030000
[    1.203212] pci 0000:01:08.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
[    1.209719] pci 0000:01:08.0: reg 14: [io  0x3400-0x34ff]
[    1.215103] pci 0000:01:08.0: reg 18: [mem 0xd0100000-0xd010ffff]
[    1.221192] pci 0000:01:08.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.227709] pci 0000:01:08.0: supports D1 D2
[    1.231977] pci 0000:00:09.0: PCI bridge to [bus 01-01]
[    1.237184] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    1.243254] pci 0000:00:09.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    1.250018] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdfffffff=
 pref]
[    1.257248] pci 0000:02:00.0: [14e4:165a] type 00 class 0x020000
[    1.263245] pci 0000:02:00.0: reg 10: [mem 0xd0200000-0xd020ffff 64bit]
[    1.269915] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    1.277049] pci 0000:00:0b.0: PCI bridge to [bus 02-02]
[    1.282258] pci 0000:00:0b.0:   bridge window [mem 0xd0200000-0xd02fffff]
[    1.289040] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    1.294265] pci 0000:00:0d.0: PCI bridge to [bus 04-04]
[    1.299501] pci 0000:05:00.0: [8086:105e] type 00 class 0x020000
[    1.305494] pci 0000:05:00.0: reg 10: [mem 0xd0320000-0xd033ffff]
[    1.311570] pci 0000:05:00.0: reg 14: [mem 0xd0300000-0xd031ffff]
[    1.317645] pci 0000:05:00.0: reg 18: [io  0x4000-0x401f]
[    1.323047] pci 0000:05:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.329579] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    1.335669] pci 0000:05:00.1: [8086:105e] type 00 class 0x020000
[    1.341661] pci 0000:05:00.1: reg 10: [mem 0xd0360000-0xd037ffff]
[    1.347736] pci 0000:05:00.1: reg 14: [mem 0xd0340000-0xd035ffff]
[    1.353811] pci 0000:05:00.1: reg 18: [io  0x4020-0x403f]
[    1.359213] pci 0000:05:00.1: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.365745] pci 0000:05:00.1: PME# supported from D0 D3hot D3cold
[    1.371829] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  Yo=
u can enable it with 'pcie_aspm=3Dforce'
[    1.381796] pci 0000:00:0e.0: PCI bridge to [bus 05-05]
[    1.387003] pci 0000:00:0e.0:   bridge window [io  0x4000-0x4fff]
[    1.393073] pci 0000:00:0e.0:   bridge window [mem 0xd0300000-0xd03fffff]
[    1.399842] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.405827] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
[    1.412211] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
[    1.418566] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
[    1.424923] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
[    1.431280] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR3._PRT]
[    1.437634]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.443272]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), return=
ed control mask: 0x1d
[    1.451761] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.473471] ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
[    1.479653] ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17    1.511494] ACP=
I: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
[    1.517657] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0, disab=
led.
[    1.524771] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disab=
led.
[    1.531892] ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disab=
led.
[    1.539013] ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disab=
led.
[    1.546130] ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disab=
led.
[    1.553258] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
[    1.559434] ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0
[    1.565618] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disab=
led.
[    1.572896] vgaarb: device added: PCI:0000:01:08.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.580958] vgaarb: loaded
[    1.583654] vgaarb: bridge control possible 0000:01:08.0
[    1.589101] ACPI: bus type usb registered
[    1.593191] usbcore: registered new interface driver usbfs
[    1.598695] usbcore: registered new interface driver hub
[    1.604047] usbcore: registered new device driver usb
[    1.609299] PCI: Using ACPI for IRQ routing
[    1.613469] PCI: pci_cache_line_size set to 64 bytes
[    1.618465] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    1.624450] e820: reserve RAM buffer [mem 0x7fff0000-0x7fffffff]
[    1.630434] e820: reserve RAM buffer [mem 0xcfef0000-0xcfffffff]
[    1.636630] NetLabel: Initializing
[    1.640020] NetLabel:  domain hash size =3D 128
[    1.644360] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    1.649315] NetLabel:  unlabeled traffic allowed by default
[    1.654940] initlevel:5=3Dfs, 26 registered initcalls
[    1.659843] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    1.666869] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    1.671814] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    1.681802] Switching to clocksource hpet
[    1.685917] pnp: PnP ACPI init
[    1.688978] ACPI: bus type pnp registered
[0fff]
[    1.712305] system 00:00: [mem 0xffc00000-0xffffffff] could not be reser=
ved
[    1.719243] system 00:00: [mem 0xfec00000-0xfec00fff] could not be reser=
ved
[    1.726180] system 00:00: [mem 0xfee00000-0xfeefffff] could not be reser=
ved
[    1.733117] system 00:00: [mem 0xfed00000-0xfed00fff] has been reserved
[    1.739709] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.746546] pnp 00:01: [bus 00-ff]
[    1.749942] pnp 00:01: [io  0x0cf8-0x0cff]
[    1.754024] pnp 00:01: [io  0x0000-0x0cf7 window]
[    1.758713] pnp 00:01: [io  0x0d00-0xffff window]
[    1.763401] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    1.768783] pnp 00:01: [mem 0x000c0000-0x000dffff window]
[    1.774164] pnp 00:01: [mem 0xd0000000-0xfebfffff window]
[    1.779544] pnp 00:01: [mem 0xfed40000-0xfed8ffff]
[    1.784410] pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.790941] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    1.795791] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    1.802384] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.809432] pnp 00:03: [io  0x8000-0x807f]
[    1.813515] pnp 00:03: [io  0x8080-0x80ff]
[    1.817599] pnp 00:03: [io  0x8400-0x847f]
[    1.821683] pnp 00:03: [io  0x8480-0x84ff]
[    1.825766] pnp 00:03: [io  0x8800-0x887f]
[    1.829848] pnp 00:03: [io  0x8880-0x88ff]
[    1.833931] pnp 00:03: [io  0x2040-0x207f]
[    1.838013] pnp 00:03: [io  0x2000-0x203f]
[    1.842095] pnp 00:03: [io  0x0060]
[    1.845572] pnp 00:03: [io  0x0064]
[    1.849150] system 00:03: [io  0x8000-0x807f] has been reserved
[    1.855051] system 00:03: [io  0x8080-0x80ff] has been reserved
[    1.860951] system 00:03: [io  0x8400-0x847f] has been reserved
[    1.866853] system 00:03: [io  0x8480-0x84ff] has been reserved
[    1.872754] system 00:03: [io  0x8800-0x887f] has been reserved
[    1.878654] system 00:03: [io  0x8880-0x88ff] has been reserved
[    1.884554] system 00:03: [io  0x2040-0x207f] has been reserved
[    1.890454] system 00:03: [io  0x2000-0x203f] has been reserved
[    1.896356] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.903175] pnp 00:04: [irq 0 disabled]
[    1.907007] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:15)
[    1.914986] pnp 00:04: [irq 8]
[    1.918030] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    1.922876] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.929391] pnp 00:05: [io  0x0010-0x001f]
[    1.933473] pnp 00:05: [io  0x0022-0x003f]
[    1.937556] pnp 00:05: [io  0x0044-0x005f]
[    1.941643] pnp 00:05: [io  0x0062-0x0063]
[    1.945727] pnp 00:05: [io  0x0065-0x006f]
[    1.949811] pnp 00:05: [io  0x0072-0x0073]
[    1.953893] pnp 00:05: [io  0x0074-0x007f]
[    1.957976] pnp 00:05: [io  0x0091-0x0093]
[    1.962058] pnp 00:05: [io  0x0097-0x009f]
[    1.966140] pnp 00:05: [io  0x00a2-0x00bf]
[    1.970225] pnp 00:05: [io  0x00e0-0x00ef]
[    1.974308] pnp 00:05: [io  0x04d0-0x04d1]
[    1.978482] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    1.984384] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.991163] pnp 00:06: [io  0x0000-0x0008]
[    1.995247] pnp 00:06: [io  0x000a-0x000f]
[    1.999330] pnp 00:06: [io  0x0081-0x0083]
[    2.003413] pnp 00:06: [io  0x0087]
[    2.006891] pnp 00:06: [io  0x0089-0x008b]
[    2.010974] pnp 00:06: [io  0x008f]
[    2.014451] pnp 00:06: [io  0x00c0-0x00d1]
[    2.018534] pnp 00:06: [io  0x00d4-0x00df]
[    2.022618] pnp 00:06: [dma 4]
[    2.025734] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.032247] pnp 00:07: [io  0x0061]
[    2.035789] pnp 00:07: Plug and Play ACPI device, IDs PNP0800 (active)
[    2.042327] pnp 00:08: [io  0x0070-0x0071]
[    2.046472] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.052985] pnp 00:09: [io  0x00f0-0x00f1]
[    2.057068] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:15)
[    2.065217] pnp 00:09: [irq 13]
[    2.068414] pnp 00:09: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.074928] pnp 00:0a: [io  0x0c00-0x0c7f]
[    2.079098] system 00:0a: [io  0x0c00-0x0c7f] has been reserved
[    2.084998] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.091967] pnp 00:0b: [io  0x03f8-0x03ff]
[    2.096051] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:15)
[    2.104027] pnp 00:0b: [irq 4]
[    2.107192] pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.114109] pnp: PnP ACPI: found 12 devices
[    2.118279] ACPI: ACPI bus type pnp unregistered
[    2.131844] pci 0000:00:0e.0: BAR 15: assigned [mem 0xd0400000-0xd04ffff=
f pref]
[    2.139130] pci 0000:01:07.0: BAR 6: assi0140000-0xd015ffff pref]
[    2.153523] pci 0000:00:09.0: PCI bridge to [bus 01-01]
[    2.158731] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    2.164804] pci 0000:00:09.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    2.171568] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdfffffff=
 pref]
[    2.178766] pci 0000:00:0b.0: PCI bridge to [bus 02-02]
[    2.183975] pci 0000:00:0b.0:   bridge window [mem 0xd0200000-0xd02fffff]
[    2.190740] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    2.195949] pci 0000:00:0d.0: PCI bridge to [bus 04-04]
[    2.201161] pci 0000:05:00.0: BAR 6: assigned [mem 0xd0400000-0xd041ffff=
 pref]
[    2.208357] pci 0000:05:00.1: BAR 6: assigned [mem 0xd0420000-0xd043ffff=
 pref]
[    2.215553] pci 0000:00:0e.0: PCI bridge to [bus 05-05]
[    2.220761] pci 0000:00:0e.0:   bridge window [io  0x4000-0x4fff]
[    2.226833] pci 0000:00:0e.0:   bridge window [mem 0xd0300000-0xd03fffff]
[    2.233592] pci 0000:00:0e.0:   bridge window [mem 0xd0400000-0xd04fffff=
 pref]
[    2.240795] pci 0000:00:09.0: setting latency timer to 64
[    2.246184] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.251736] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.257289] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.263534] pci_bus 0000:00: resource 7 [mem 0xd0000000-0xfebfffff]
[    2.269779] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed8ffff]
[    2.276025] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    2.281577] pci_bus 0000:01: resource 1 [mem 0xd0100000-0xd01fffff]
[    2.287820] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdfffffff pref]
[    2.294496] pci_bus 0000:02: resource 1 [mem 0xd0200000-0xd02fffff]
[    2.300740] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    2.306293] pci_bus 0000:05: resource 1 [mem 0xd0300000-0xd03fffff]
[    2.312531] pci_bus 0000:05: resource 2 [mem 0xd0400000-0xd04fffff pref]
[    2.319279] NET: Registered protocol family 2
[    2.323765] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    2.332247] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    2.343134] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.350234] TCP: Hash tables configured (established 524288 bind 65536)
[    2.356825] TCP: reno registered
[    2.360052] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    2.366072] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    2.372628] NET: Registered protocol family 1
[    2.377096] RPC: Registered named UNIX socket transport module.
[    2.383000] RPC: Registered udp transport module.
[    2.387689] RPC: Registered tcp transport module.
[    2.392378] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.399085] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 23
[    2.404836] IOAPIC[0]: Set routing entry (4-23 -> 0x29 -> IRQ 23 Mode:1 =
Active:1 Dest:15)
[    2.463603] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
[    2.469338] IOAPIC[0]: Set routing entry (4-22 -> 0x41 -> IRQ 22 Mode:1 =
Active:1 Dest:15)
[    2.477533] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.483026] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.488530] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.494005] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    2.499570] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.505069] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.510546] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    2.516110] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.521613] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.527087] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    2.532651] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.538157] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.543631] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    2.549195] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.554680] pci 0000:01:08.0: Boot video device
[    2.559209] PCI: CLS 64 bytes, default 64
[    2.563310] Trying to unpack rootfs image as initramfs...
[    4.179934] Freeing initrd memory: 65400k freed
[    4.211579] PCI-DMA: Disabling AGP.
[    4.215165] PCI-DMA: aperture base @ c4000000 size 65536 KB
[    4.220719] PCI-DMA: GP aperture
[    4.234971] initlevel:6=3Ddevice, 280 registered initcalls
[    4.240364] Simple Boot Flag at 0x62 set to 0x1
[    4.245389] Machine check injector initialized
[    4.249824] LVT offset 1 assigned for vector 0x400
[    4.254613] Failed to setup IBS LVT offset, IBSCTL =3D 0xffffffff
[    4.260511] [Firmware Bug]: cpu 1, try to use APIC500 (LVT offset 0) for=
 vector 0x10400, but the register is already in use for vector 0xf9 on anot=
her cpu
[    4.274280] [Firmware Bug]: cpu 1, IBS interrupt offset 0 not available =
(MSRC001103A=3D0x0000000000000100)
[    4.283723] Failed to setup IBS, -22
[    4.287819] microcode: CPU0: patch_level=3D0x01000065
[    4.292679] microcode: CPU1: patch_level=3D0x01000065
[    4.297548] microcode: CPU2: patch_level=3D0x01000065
[    4.302413] microcode: CPU3: patch_level=3D0x01000065
[    4.307315] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    4.316393] audit: initializing netlink socket (disabled)
[    4.321785] type=3D2000 audit(1338420884.837:1): initialized
[    4.342505] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.349090] VFS: Disk quotas dquot_6.5.2
[    4.353026] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.359557] NFS: Registering the id_resolver key type
[    4.364603] Key type id_resolver registered
[    4.368873] NTFS driver 2.1.30 [Flags: R/W].
[    4.373231] msgmni has been set to 7923
[    4.377408] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    4.384779] io scheduler noop registered
[    4.388689] io scheduler deadline registered
[    4.392965] io scheduler cfq registered (default)
[    4.397855] pcieport 0000:00:0b.0: irq 40 for MSI/MSI-X
[    4.403192] pcieport 0000:00:0c.0: irq 41 for MSI/MSI-X
[    4.408511] pcieport 0000:00:0d.0: irq 42 for MSI/MSI-X
[    4.413839] pcieport 0000:00:0e.0: irq 43 for MSI/MSI-X
[    4.419203] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.425013] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
C:00/input/input0
[    4.433164] ACPI: Power Button [PWRB]
[    4.436947] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input1
[    4.444319] ACPI: Power Button [PWRF]
[    4.448189] ACPI: acpi_idle registered with cpuidle
[    4.456973] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    4.485328] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.512051] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    4.539000] 00:0b: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    4.545013] Non-volatile memory driver v1.3
[    4.549183] Linux agpgart interface v0.103
[    4.553463] [drm] Initialized drm 1.1.0 20060810
[    4.560098] brd: module loaded
[    4.564219] loop: module loaded
[    4.567453] Fixed MDIO Bus: probed
[    4.570847] tun: Universal TUN/TAP device driver, 1.6
[    4.575881] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.582137] tg3.c:v3.123 (March 21, 2012)
[    4.586360] ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 19
[    4.592113] IOAPIC[0]: Set routing entry (4-19 -> 0x69 -> IRQ 19 Mode:1 =
Active:1 Dest:15)
[    4.606889] tg3 0000:02:00.0: eth0: Tigon3 [partno(BCM95722) rev a200] (=
PCI Express) MAC address 00:1d:09:17:b5:46
[    4.61u1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    4.635328] tg3 0000:02:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    4.642134] work_for_cpu used greatest stack depth: 5016 bytes left
[    4.642199] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Ne=
twork Driver - version 2.6.0-k
[    4.642200] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[    4.642464] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.642465] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    4.676224] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    4.682059] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    4.687343] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus =
number 1
[    4.694720] ehci_hcd 0000:00:02.1: reset hcs_params 0x10148a dbg=3D1 cc=
=3D1 pcc=3D4 !ppc ports=3D10
[    4.703052] ehci_hcd 0000:00:02.1: reset portroute 0 0 0 0 0 0 0 0 0 0=
=20
[    4.709644] ehci_hcd 0000:00:02.1: reset hcc_params a086 caching frame 2=
56/512/1024 park
[    4.817625] BUG: Bad page state in process work_for_cpu  pfn:cf800
[    4.823780] page:ffffea0002d64000 count:-1 mapcount:0 ing:          (nul=
l) index:0x0
[    4.831838] page flags: 0x100000000000000()
[    4.836004] Modules linked in:
[    4.839047] Pid: 1207, comm: work_for_cpu Not tainted 3.4.0upstream-0920=
8-gaf56e0a #1
[    4.846845] Call Trace:
[    4.849288]  [<ffffffff81103eb7>] ? dump_page+0x97/0xf0
[    4.854493]  [<ffffffff811050bd>] bad_page+0xad/0x100
[    4.859524]  [<ffffffff811067a2>] get_page_from_freelist+0x712/0x850
[    4.865852]  [<ffffffff812916d8>] ? __const_udelay+0x28/0x30
[    4.871488]  [<ffffffff81107a82>] __alloc_pages_nodemask+0x162/0x900
[    4.877816]  [<ffffffff810a2975>] ? dequeue_task_fair+0xa5/0x330
[    4.883799]  [<ffffffff810367e2>] ? __switch_to+0x152/0x440
[    4.889350]  [<ffffffff8107ee37>] ? lock_timer_base+0x37/0x70
[    4.895073]  [<ffffffff8103c7ff>] dma_generic_alloc_coherent+0x10f/0x170
[    4.901747]  [<ffffffff81062e7e>] gart_alloc_coherent+0xee/0x120
[    4.907729]  [<ffffffff81137542>] dma_pool_alloc+0x102/0x2e0
[    4.913364]  [<ffffffff8109f240>] ? try_to_wake_up+0x310/0x310
[    4.919174]  [<ffffffff813f3dc7>] ehci_qh_alloc+0x47/0xf0
[    4.924550]  [<ffffffff813f81e7>] ehci_pci_setup+0x367/0xea0
[    4.930186]  [<ffffffff81389213>] ? device_pm_init+0x43/0x80
[    4.935822]  [<ffffffff813d3065>] ? usb_alloc_dev+0x2d5/0x330
[    4.941545]  [<ffffffff81002030>] ? do_one_initcall+0x30/0x170
[    4.947353]  [<ffffffff813db6a9>] usb_add_hcd+0x1e9/0x7a0
[    4.952730]  [<ffffffff813ea0fa>] usb_hcd_pci_probe+0x1ba/0x3a0
[    4.958626]  [<ffffffff81088890>] ? cwq_dec_nr_in_flight+0x90/0x90
[    4.964781]  [<ffffffff812ad3f2>] local_pci_probe+0x12/0x20
[    4.970325]  [<ffffffff810888a3>] do_work_for_cpu+0x13/0x30
[    4.975884]  [<ffffffff810906e6>] kthread+0x96/0xa0
[    4.980743]  [<ffffffff815b61e4>] kernel_thread_helper+0x4/0x10
[    4.986643]  [<ffffffff81090650>] ? kthread_freezable_should_stop+0x70/0=
x70
[    4.993576]  [<ffffffff815b61e0>] ? gs_change+0x13/0x13
[    4.998778] Disabling lock debugging due to kernel taint
[    5.103388] BUG: Bad page state in process work_for_cpu  pfn:cf801
[    5.109541] page:ffffea0002d64038 count:-1 mapcount:0 mapping:          =
(null) index:0x0
[    5.117597] page flags: 0x100000000000000()
[    5.121757] Modules linked in:
[    5.124800] Pid: 1207, comm: work_for_cpu Tainted: G    B        3.4.0up=
stream-09208-gaf56e0a #1
[    5.133543] Call Trace:
[    5.135980]  [<ffffffff81103eb7>] ? dump_page+0x97/0xf0
[    5.141187]  [<ffffffff811050bd>] bad_page+0xad/0x100
[    5.146212]  [<ffffffff811067a2>] get_page_from_freelist+0x712/0x850
[    5.152552]  [<ffffffff81107a82>] __alloc_pages_nodemask+0x162/0x900
[    5.158875]  [<ffffffff810367e2>] ? __switch_to+0x152/0x440
[    5.164433]  [<ffffffff810a5e1d>] ? idle_balance+0x12d/0x180
[    5.170063]  [<ffffffff8107ee37>] ? lock_timer_base+0x37/0x70
[    5.175789]  [<ffffffff8103c7ff>] dma_generic_alloc_coherent+0x10f/0x170
[    5.182467]  [<ffffffff81062e7e>] gart_alloc_coherent+0xee/0x120
[    5.188443]  [<ffffffff81137542>] dma_pool_alloc+0x102/0x2e0
[    5.194082]  [<ffffffff8109f240>] ? try_to_wake_up+0x310/0x310
[    5.199893]  [<ffffffff813f3dc7>] ehci_qh_alloc+0x47/0xf0
[    5.205273]  [<ffffffff813f81e7>] ehci_pci_setup+0x367/0xea0
[    5.210912]  [<ffffffff81389213>] ? device_pm_init+0x43/0x80
[    5.216542]  [<ffffffff813d3065>] ? usb_alloc_dev+0x2d5/0x330
[    5.222268]  [<ffffffff81002030>] ? do_one_initcall+0x30/0x170
[    5.228080]  [<ffffffff813db6a9>] usb_add_hcd+0x1e9/0x7a0
[    5.233455]  [<ffffffff813ea0fa>] usb_hcd_pci_probe+0x1ba/0x3a0
[    5.239354]  [<ffffffff81088890>] ? cwq_dec_nr_in_flight+0x90/0x90
[    5.245512]  [<ffffffff812ad3f2>] local_pci_probe+0x12/0x20
[    5.246376] Refined TSC clocksource calibration: 2109.722 MHz.
[    5.246380] Switching to clocksource tsc
[    5.260765]  [<ffffffff810888a3>] do_work_for_cpu+0x13/0x30
[    5.266309]  [<ffffffff810906e6>] kthread+0x96/0xa0
[    5.271161]  [<ffffffff815b61e4>] kernel_thread_helper+0x4/0x10
[    5.277051]  [<ffffffff81090650>] ? kthread_freezable_should_stop+0x70/0=
x70
[    5.283979]  [<ffffffff815b61e0>] ? gs_change+0x13/0x13
[    5.388182] BUG: Bad page state in process work_for_cpu  pfn:cf802

--IJpNTDwzlM2Ie8A6--
