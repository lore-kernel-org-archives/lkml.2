Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab2LVNdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 08:33:46 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26641 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2LVNdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 08:33:40 -0500
Date: Sat, 22 Dec 2012 08:32:50 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/27] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
Message-ID: <20121222133250.GD2936@phenom.dumpdata.com>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
 <20121222024225.GG3468@phenom.dumpdata.com>
 <CAE9FiQV7EnG4Aj9R+8r1XrzjwbasXfJaN=4_RZp6m5yAeftrNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAE9FiQV7EnG4Aj9R+8r1XrzjwbasXfJaN=4_RZp6m5yAeftrNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2012 at 09:20:01PM -0800, Yinghai Lu wrote:
> On Fri, Dec 21, 2012 at 6:42 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > On Mon, Dec 17, 2012 at 11:15:32PM -0800, Yinghai Lu wrote:
> >> Now we have limit kdump reseved under 896M, because kexec has the limitation.
> >> and also bzImage need to stay under 4g.
> >>
> >> To make kexec/kdump could use range above 4g, we need to make bzImage and
> >> ramdisk could be loaded above 4g.
> >> During booting bzImage will be unpacked on same postion and stay high.
> >>
> >> The patches add fields in setup_header and boot_params to
> >> 1. get info about ramdisk position info above 4g from bootloader/kexec
> >> 2. get info about cmd_line_ptr info above 4g from bootloader/kexec
> >> 3. set xloadflags bit0 in header for bzImage and bootloader/kexec load
> >>    could check that to decide if it could to put bzImage high.
> >> 4. use sentinel to make sure ext_* fields in boot_params could be used.
> >>
> >> This patches is tested with kexec tools with local changes and they are sent
> >> to kexec list later.
> >>
> >> could be found at:
> >>
> >>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-boot
> 
> that points to -v8.
> 
> >
> > Did a light test and it looks to work under Xen - thought I had not tested
> > any various configuration of memory layouts.
> >
> > More worryingly it blew up under native under an Dell T105 AMD box with 4GB of memory.
> > I can't get it even to print anything on the serial log:
> 
> boot log with working kernel ?

Here it is - 64-bit followed by 32-bit
The git commit matches with this upstream:
941108b

commit d7dae536a95027bac799047abd7a5bddcc163ea0
Merge: 941108b 54e37b8
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Fri Dec 21 04:05:39 2012 -0500

    Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux
    
    * 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux: (164 commits)
      keys: use keyring_alloc() to create module signing keyring
      keys: fix unreachable code
      sendfile: allows bypassing of notifier events
      SGI-XP: handle non-fatal traps
      fat: fix incorrect function comment
      Documentation: ABI: remove testing/sysfs-devices-node
      proc: fix inconsistent lock state


PXELINUX 3.82 2009-06-09  Copyright (C) 1994-2009 H. Peter Anvin et al
Loading latest/vmlinuz.......................................................................
Loading latest/initramfs.cpio.gz....................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................ready.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.0upstream-11627-g941108b (konrad@build.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP Thu Dec 20 18:09:18 EST 2012
[    0.000000] Command line: initrd=latest/initramfs.cpio.gz zcache nofb debug selinux=0 console=ttyS0,115200 loglevel=10 apic=debug BOOT_IMAGE=latest/vmlinuz 
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000cc000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ffeffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007fff0000-0x000000007fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000080000000-0x00000000cfeeffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cfef0000-0x00000000cfef4fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cfef5000-0x00000000cff7efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cff80000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff80000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000012fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Dell Inc. PowerEdge T105 /0RR825, BIOS 1.3.2 08/20/2008
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x130000 max_arch_pfn = 0x400000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcfef0 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f7a70-0x000f7a7f] mapped at [ffff8800000f7a70]
[    0.000000]   mpc: 9e171-9e2a5
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0xcfeeffff]
[    0.000000]  [mem 0x00000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xcfdfffff] page 2M
[    0.000000]  [mem 0xcfe00000-0xcfeeffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xcfeeffff @ [mem 0x1fffd000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x12fffffff]
[    0.000000]  [mem 0x100000000-0x12fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x12fffffff @ [mem 0xcfeee000-0xcfeeffff]
[    0.000000] RAMDISK: [mem 0x7b1b3000-0x7ffcefff]
[    0.000000] ACPI: RSDP 00000000000f79b0 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 00000000cfef0753 0009C (v01 DELL   PE_SC3   06040000 DELL 00000000)
[    0.000000] ACPI: FACP 00000000cfef3c5f 000F4 (v03 DELL   PE_SC3   06040000 DELL 000F4240)
[    0.000000] ACPI: DSDT 00000000cfef07ef 033FC (v01 DELL   PE_SC3   06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000cfef5fc0 00040
[    0.000000] ACPI: TCPA 00000000cfef3d53 00032 (v01 Phoeni  x       06040000  TL  00000000)
[    0.000000] ACPI: SLIC 00000000cfef3d85 00024 (v01 DELL   PE_SC3   06040000 PTL  00000001)
[    0.000000] ACPI: SPCR 00000000cfef3da9 00050 (v01 DELL   PE_SC3   06040000 PTL  00000001)
[    0.000000] ACPI: EINJ 00000000cfef3df9 001B0 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: HEST 00000000cfef3fa9 000A8 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: BERT 00000000cfef4051 00030 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000cfef4081 000E1 (v01 wheaos  wheaosc 06040000 INTL 20050624)
[    0.000000] ACPI: ERST 00000000cfef4162 00270 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: SRAT 00000000cfef43d2 000E8 (v01 AMD    HAMMER   06040000 AMD  00000001)
[    0.000000] ACPI: SSDT 00000000cfef44ba 00A30 (v01 AMD    POWERNOW 06040000 AMD  00000001)
[    0.000000] ACPI: MCFG 00000000cfef4eea 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: HPET 00000000cfef4f26 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
[    0.000000] ACPI: APIC 00000000cfef4f5e 0007A (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000cfef4fd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f2000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00100000-0xcfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x12fffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0xcfffffff] -> [mem 0x00000000-0xcfffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xcfffffff] + [mem 0x100000000-0x12fffffff] -> [mem 0x00000000-0x12fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x12fffffff]
[    0.000000]   NODE_DATA [mem 0x12fffc000-0x12fffffff]
[    0.000000]  [ffffea0000000000-ffffea00043fffff] PMD -> [ffff88012b600000-ffff88012effffff] on node 0
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
[    0.000000]   DMA32 zone: 11589 pages used for memmap
[    0.000000]   DMA32 zone: 835995 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f2000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] Int: type 0, pol 1, trig 1, bus 00, IRQ 00, APIC ID 4, APIC INT 02
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 09, APIC ID 4, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 4, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 4, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 4, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 4, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 4, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 4, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 4, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 4, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 4, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 4, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 4, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 4, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 4, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f1000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000cc000
[    0.000000] PM: Registered nosave memory: 00000000000cc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000007fff0000 - 0000000080000000
[    0.000000] PM: Registered nosave memory: 00000000cfef0000 - 00000000cfef5000
[    0.000000] PM: Registered nosave memory: 00000000cfef5000 - 00000000cff7f000
[    0.000000] PM: Registered nosave memory: 00000000cff7f000 - 00000000cff80000
[    0.000000] PM: Registered nosave memory: 00000000cff80000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff80000
[    0.000000] PM: Registered nosave memory: 00000000fff80000 - 0000000100000000
[    0.000000] e820: [mem 0xd0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88012fc00000 s84480 r8192 d22016 u524288
[    0.000000] pcpu-alloc: s84480 r8192 d22016 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1033834
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: initrd=latest/initramfs.cpio.gz zcache nofb debug selinux=0 console=ttyS0,115200 loglevel=10 apic=debug BOOT_IMAGE=latest/vmlinuz 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ a1c0000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ c4000000
[    0.000000] PM: Registered nosave memory: 00000000c4000000 - 00000000c8000000
[    0.000000] Memory: 3908240k/4980736k available (6530k kernel code, 788044k absent, 284452k reserved, 4375k data, 756k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.001000] tsc: Fast TSC calibration using PIT
[    0.002000] tsc: Detected 2109.706 MHz processor
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4219.41 BogoMIPS (lpj=2109706)
[    0.010593] pid_max: default: 32768 minimum: 301
[    0.015234] Security Framework initialized
[    0.019321] SELinux:  Disabled at boot.
[    0.023444] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.032421] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.040272] Mount-cache hash table entries: 256
[    0.044991] Initializing cgroup subsys cpuacct
[    0.049423] Initializing cgroup subsys freezer
[    0.053883] tseg: 00cff80000
[    0.056757] CPU: Physical Processor ID: 0
[    0.060755] CPU: Processor Core ID: 0
[    0.064407] mce: CPU supports 6 MCE banks
[    0.068411] LVT offset 0 assigned for vector 0xf9
[    0.073104] process: using AMD E400 aware idle routine
[    0.078226] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
[    0.078226] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64
[    0.078226] tlb_flushall_shift: 4
[    0.092900] Freeing SMP alternatives: 24k freed
[    0.099466] ACPI: Core revision 20121018
[    0.108606] Getting VERSION: 80050010
[    0.112260] Getting VERSION: 80050010
[    0.115911] Getting ID: 0
[    0.118525] Getting ID: ff000000
[    0.121745] Getting LVT0: 10000
[    0.124879] Getting LVT1: 10000
[    0.128013] masked ExtINT on CPU#0
[    0.131556] ENABLING IO-APIC IRQs
[    0.134862] init IO_APIC IRQs
[    0.137822]  apic 4 pin 0 not connected
[    0.141652] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.149543] IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.157437] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.165324] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.173214] IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.181104] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.188993] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.196883] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.204772] IOAPIC[0]: Set routing entry (4-9 -> 0x39 -> IRQ 9 Mode:1 Active:1 Dest:1)
[    0.212663] IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.220727] IOAPIC[0]: Set routing entry (4-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.228791] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.236855] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.244919] IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.252983] IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.261045]  apic 4 pin 16 not connected
[    0.264947]  apic 4 pin 17 not connected
[    0.268864]  apic 4 pin 18 not connected
[    0.272774]  apic 4 pin 19 not connected
[    0.276676]  apic 4 pin 20 not connected
[    0.280591]  apic 4 pin 21 not connected
[    0.284501]  apic 4 pin 22 not connected
[    0.288402]  apic 4 pin 23 not connected
[    0.292453] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.308441] smpboot: CPU0: Quad-Core AMD Opteron(tm) Processor 1352 (fam: 10, model: 02, stepping: 03)
[    0.317768] Using local APIC timer interrupts.
[    0.317768] calibrating APIC timer ...
[    0.427176] ... lapic delta = 1255739
[    0.430821] ... PM-Timer delta = 357941
[    0.434635] ... PM-Timer result ok
[    0.438026] ..... delta 1255739
[    0.441146] ..... mult: 53933579
[    0.444366] ..... calibration result: 200918
[    0.448617] ..... CPU clock speed is 2109.0641 MHz.
[    0.453473] ..... host bus clock speed is 200.0918 MHz.
[    0.458682] Performance Events: AMD PMU driver.
[    0.463213] ... version:                0
[    0.467205] ... bit width:              48
[    0.471287] ... generic registers:      4
[    0.475278] ... value mask:             0000ffffffffffff
[    0.480573] ... max period:             00007fffffffffff
[    0.485865] ... fixed-purpose events:   0
[    0.489862] ... event mask:             000000000000000f
[    0.495372] MCE: In-kernel MCE decoding enabled.
[    0.500052] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.508161] smpboot: Booting Node   0, Processors  #1[    0.524047] masked ExtINT on CPU#1
 #2[    0.540997] masked ExtINT on CPU#2
 #3 OK
[    0.558365] masked ExtINT on CPU#3
[    0.563887] Brought up 4 CPUs
[    0.566845] smpboot: Total of 4 processors activated (16877.64 BogoMIPS)
[    0.580126] PM: Registering ACPI NVS region [mem 0xcfef5000-0xcff7efff] (565248 bytes)
[    0.588270] kworker/u:0 (31) used , date: 12/21/12
[    0.599326] NET: Registered protocol family 16
[    0.603976] kworker/u:0 (35) used greatest stack depth: 5592 bytes left
[    0.604362] node 0 link 0: io port [1000, 3fff]
[    0.604364] node 0 link 0: io port [4000, fffff]
[    0.604365] TOM: 00000000d0000000 aka 3328M
[    0.604368] node 0 link 0: mmio [d0000000, d04fffff]
[    0.604370] node 0 link 0: mmio [fed00000, fed0ffff]
[    0.604371] node 0 link 0: mmio [d8000000, dfffffff]
[    0.604373] node 0 link 0: mmio [fec00000, fec0ffff]
[    0.604375] node 0 link 0: mmio [e0000000, efffffff]
[    0.604376] node 0 link 0: mmio [a0000, bffff]
[    0.604378] node 0 link 0: mmio [f0000000, fe0bffff]
[    0.604379] TOM2: 0000000130000000 aka 4864M
[    0.604381] bus: [bus 00-ff] on node 0 link 0
[    0.604382] bus: 00 [io  0x0000-0xffff]
[    0.604383] bus: 00 [mem 0xd0000000-0xd7ffffff]
[    0.604384] bus: 00 [mem 0xfec10000-0xffffffff]
[    0.604385] bus: 00 [mem 0xd8000000-0xfebfffff]
[    0.604386] bus: 00 [mem 0xfec00000-0xfec0ffff]
[    0.604387] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.604387] bus: 00 [mem 0x130000000-0xfcffffffff]
[    0.697629] ACPI: bus type pci registered
[    0.701762] dca service started, version 1.12.1
[    0.706330] PCI: MMCONFIG for domain 0000 [bus 00-04] at [mem 0xe0000000-0xe04fffff] (base 0xe0000000)
[    0.715615] PCI: MMCONFIG at [mem 0xe0000000-0xe04fffff] reserved in E820
[    0.722724] PCI: Using configuration type 1 for base access
[    0.735965] bio: create slab <bio-0> at 0
[    0.740130] ACPI: Added _OSI(Module Device)
[    0.744300] ACPI: Added _OSI(Prregator Device)
[    0.759681] ACPI: EC: Look up EC in DSDT
[    0.768816] \_SB_:_OSC evaluation returned wrong type
[    0.773848] _OSC request data:1 17 
[    0.777798] ACPI: Interpreter enabled
[    0.781446] ACPI: (supports S0 S4 S5)
[    0.785152] ACPI: Using IOAPIC for interrupt routing
[    0.799709] ACPI: No dock devices found.
[    0.803666] [Firmware Warn]: HEST: Duplicated hardware error source ID: 9.
[   on failed, disabling PCIe ASPM
[    0.840238] pci_root PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.848575] pci_root PNP0A03:00: ignoring host bridge window [mem 0x000c0000-0x000dffff] (conflicts with reserved [mem 0x000cc000-0x000fffff])
[    0.861308] pci_root PNP0A03:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-04] only partially covers this bridge
[    0.872193] PCI host bridge to bus 0000:00
[    0.876277] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.881743] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.887900] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.894057] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.900905] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xfebfffff]
[    0.907753] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed8ffff]
[    0.914614] pci 0000:00:00.0: [10de:005e] type 00 class 0x058000
[    0.920667] pci 0000:00:01.0: [10de:0051] type 00 class 0x060100
[    0.926654] pci 0000:00:01.0: reg 10: [io  0x8c00-0x8fff]
[    0.932058] pci 0000:00:01.1: [10de:0052] type 00 class 0x0c0500
[    0.938047] pci 0000:00:01.1: reg 10: [io  0x2080-0x209f]
[    0.943434] pci 0000:00:01.1: reg 20: [io  0x2040-0x207f]
[    0.948815] pci 0000:00:01.1: reg 24: [io  0x2000-0x203f]
[    0.954207] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.960031] pci 0000:00:02.0: [10de:005a] type 00 class 0x0c0310
[    0.966021] pci 0000:00:02.0: reg 10: [mem 0xd0000000-0xd0000fff]
[    0.972114] pci 0000:00:02.0: supports D1 D2
[    0.976369] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.982966] pci 0000:00:02.1: [10de:005b] type 00 class 0x0c0320
[    0.988955] pci 0000:00:02.1: reg 10: [mem 0xd0001000-0xd00010ff]
[    0.995054] pci 0000:00:02.1: supports D1 D2
[    0.999308] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.005915] pci 0000:00:07.0: [10de:0054] type 00 class 0x010185
[    1.011905] pci 0000:00:07.0: reg 10: [io  0x20f0-0x20f7]
[    1.017286] pci 0000:00:07.0: reg 14: [io  0x20e0-0x20e3]
[    1.022666] pci 0000:00:07.0: reg 18: [io  0x20d0-0x20d7]
[    1.028047] pci 0000:00:07.0: reg 1c: [io  0x20c0-0x20c3]
[    1.033428] pci 0000:00:07.0: reg 20: [io  0x20b0-0x20bf]
[    1.038808] pci 0000:00:07.0: reg 24: [mem 0xd0002000-0xd0002fff]
[    1.044905] pci 0000:00:08.0: [10de:0055] type 00 class 0x010185
[    1.050894] pci 0000:00:08.0: reg 10: [io  0x2440-0x2447]
[    1.056276] pci 0000:00:08.0: reg 14: [io  0x2430-0x2433]
[    1.061657] pci 0000:00:08.0: reg 18: [io  0x2420-0x2427]
[    1.067037] pci 0000:00:08.0: reg 1c: [io  0x2410-0x2413]
[    1.072418] pci 0000:00:08.0: reg 20: [io  0x2400-0x240f]
[    1.077798] pci 0000:00:08.0: reg 24: [mem 0xd0003000-0xd0003fff]
[    1.083893] pci 0000:00:09.0: [10de:005c] type 01 class 0x060400
[    1.089895] pci 0000:00:0b.0: [10de:005d] type 01 class 0x060400
[    1.095906] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.102507] pci 0000:00:0c.0: [10de:005d] type 01 class 0x060400
[    1.108515] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.115115] pci 0000:00:0d.0: [10de:005d] type 01 class 0x060400
[    1.121123] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.127724] pci 0000:00:0e.0: [10de:005d] type 01 class 0x060400
[    1.133731] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.140336] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    1.146337] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    1.152335] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    1.158333] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    1.164334] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    1.170352] pci 0000:01:08.0: [1002:515e] type 00 class 0x030000
[    1.176345] pci 0000:01:08.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
[    1.182851] pci 0000:01:08.0: reg 14: [io  0x3000-0x30ff]
[    1.188235] pci 0000:01:08.0: reg 18: [mem 0xd0100000-0xd010ffff]
[    1.194325] pci 0000:01:08.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.200845] pci 0000:01:08.0: supports D1 D2
[    1.205119] pci 0000:00:09.0: PCI bridge to [bus 01]
[    1.210070] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    1.216141] pci 0000:00:09.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    1.222905] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdfffffff pref]
[    1.230134] pci 0000:02:00.0: [14e4:165a] type 00 class 0x020000
[    1.236132] pci 0000:02:00.0: reg 10: [mem 0xd0200000-0xd020ffff 64bit]
[    1.242804] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    1.250989] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    1.255939] pci 0000:00:0b.0:   bridge window [mem 0xd0200000-0xd02fffff]
[    1.262719] pci 0000:00:0c.0: PCI bridge to [bus 03]
[    1.267685] pci 0000:00:0d.0: PCI bridge to [bus 04]
[    1.272650] pci 0000:00:0e.0: PCI bridge to [bus 05]
[    1.277615] ACPI: Invalid Power Resource to register!
[    1.282655] ACPI: Invalid Power Resource to register!
[    1.287699] ACPI: Invalid Power Resource to register!
[    1.292744] ACPI: Invalid Power Resource to register!
[    1.297796] ACPI: Invalid Power Resource to register!
[    1.302828] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
[    1.309216] ACPI: Invalid Power Resource to register!
[    1.314253] ACPI: Invalid Power Resource to register!
[    1.319294] ACPI: Invalid Power Resource to register!
[    1.324327] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
[    1.330694] ACPI: Invalid Power Resource to register!
[    1.335727] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
[    1.342095] ACPI: Invalid Power Resource to register!
[    1.347128] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
[    1.353492] ACPI: Invalid Power Resource to register!
[    1.358525] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR3._PRT]
[    1.364883] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.395285] ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
[    1.401620] ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0
[    1.407941] ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0, disabled.
[    1.415226] ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0, disabled.
[    1.422500] ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
[    1.429767] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0
[    1.436065] ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
[    1.442359] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0, disabled.
[    1.449618] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[    1.456894] ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
[    1.464166] ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
[    1.471440] ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
[    1.478716] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
[    1.485040] ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0
[    1.491353] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    1.498712] vgaarb: device added: PCI:0000:01:08.0,decodes=io+mem,owns=io+mem,locks=none
[    1.506772] vgaarb: loaded
[    1.509468] vgaarb: bridge control possible 0000:01:08.0
[    1.514915] ACPI: bus type usb registered
[    1.518992] usbcore: registered new interface driver usbfs
[    1.524503] usbcore: registered new interface driver hub
[    1.529856] usbcore: registered new device driver usb
[    1.535032] pps_core: LinuxPPS API ver. 1 registered
[    1.539978] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.549109] PTP clock support registered
[    1.553126] PCI: Using ACPI for IRQ routing
[    1.557297] PCI: pci_cache_line_size set to 64 bytes
[    1.562275] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    1.568259] e820: reserve RAM buffer [mem 0x7fff0000-0x7fffffff]
[    1.574242] e820: reserve RAM buffer [mem 0xcfef0000-0xcfffffff]
[    1.580448] NetLabel: Initializing
[    1.583839] NetLabel:  domain hash size = 128
[    1.588179] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.593140] NetLabel:  unlabeled traffic allowed by default
[    1.598848] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    1.605874] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    1.610862] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    1.618860] Switching to clocksource hpet
[    1.625314] pnp: PnP ACPI init
[    1.628380] ACPI: bus type pnp registered
[    1.632670] system 00:00: [mem 0xffc00000-0xffffffff] could not be reserved
[    1.639612] system 00:00: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.646550] system 00:00: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.653489] system 00:00: [mem 0xfed00000-0xfed00fff] has been reserved
[    1.660083] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.666963] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    1.673556] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.681001] system 00:02: [io  0x8000-0x807f] has been reserved
[    1.686903] system 00:02: [io  0x8080-0x80ff] has been reserved
[    1.692803] system 00:02: [io  0x8400-0x847f] has been reserved
[    1.698703] system 00:02: [io  0x8480-0x84ff] has been reserved
[    1.704604] system 00:02: [io  0x8800-0x887f] has been reserved
[    1.710504] system 00:02: [io  0x8880-0x88ff] has been reserved
[    1.716405] system 00:02: [io  0x2040-0x207f] has been reserved
[    1.722306] system 00:02: [io  0x2000-0x203f] has been reserved
[    1.728206] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.735083] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
[    1.743116] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.749719] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    1.755620] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.762412] pnp 00:05: [dma 4]
[    1.765511] pnp 00:05: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.772079] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.778691] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.785211] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
[    1.793415] pnp 00:08: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.799999] system 00:09: [io  0x0c00-0x0c7f] has been reserved
[    1.805902] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.813073] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:15)
[    1.821154] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.828417] pnp: PnP ACPI: found 11 devices
[    1.832587] ACPI: ACPI bus type pnp unregistered
[    1.845929] pci 0000:01:08.0: BAR 6: assigned [mem 0xd0120000-0xd013ffff pref]
[    1.853129] pci 0000:00:09.0: PCI bridge to [bus 01]
[    1.858080] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    1.864155] pci 0000:00:09.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    1.870919] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdfffffff pref]
[    1.878119] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    1.883067] pci 0000:00:0b.0:   bridge window [mem 0xd0200000-0xd02fffff]
[    1.889833] pci 0000:00:0c.0: PCI bridge to [bus 03]
[    1.894786] pci 0000:00:0d.0: PCI bridge to [bus 04]
[    1.899736] pci 0000:00:0e.0: PCI bridge to [bus 05]
[    1.904693] pci 0000:00:09.0: setting latency timer to 64
[    1.910081] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.915634] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.921188] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.927435] pci_bus 0000:00: resource 7 [mem 0xd0000000-0xfebfffff]
[    1.933681] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed8ffff]
[    1.939928] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    1.945481] pci_bus 0000:01: resource 1 [mem 0xd0100000-0xd01fffff]
[    1.951728] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdfffffff pref]
[    1.958407] pci_bus 0000:02: resource 1 [mem 0xd0200000-0xd02fffff]
[    1.964715] NET: Registered protocol family 2
[    1.969290] TCP established hash table entries: 32768 (order: 7, 524288 bytes)
[    1.976733] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    1.983524] TCP: Hash tables configured (established 32768 bind 32768)
[    1.990081] TCP: reno registered
[    1.993308] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    1.999329] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    2.005852] NET: Registered protocol family 1
[    2.010305] RPC: Registered named UNIX socket transport module.
[    2.016205] RPC: Registered udp transport module.
[    2.020893] RPC: Registered tcp transport module.
[    2.025586] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.032355] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 23
[    2.038090] IOAPIC[0]: Set routing entry (4-23 -> 0x41 -> IRQ 23 Mode:1 Active:1 Dest:15)
[    2.096930] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
[    2.102676] IOAPIC[0]: Set routing entry (4-22 -> 0x51 -> I    2.116378] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.121877] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.127348] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    2.132906] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.138407] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.143878] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    2.149436] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.154937] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.160409] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    2.165967] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.171477] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.176948] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    2.182506] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.187987] pci 0000:01:08.0: Boot video device
[    2.192507] PCI: CLS 64 bytes, default 64
[    2.196614] Unpacking initramfs...
[    4.302752] Freeing initrd memory: 79984k freed
[    4.340261] PCI-DMA: Disabling AGP.
[    4.343863] PCI-DMA: aperture base @ c4000000 size 65536 KB
[    4.349417] PCI-DMA: I-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    4.364624] Simple Boot Flag at 0x62 set to 0x80
[    4.369384] Machine check injector initialized
[    4.373817] LVT offsedy in use for vector 0xf9 on another cpu
[    4.398268] [Firmware Bug]: cpu 0, IBS interrupt offset 0 not available (MSRC001103A=0x0000000000000100)
[    4.407712] Failed to setup IBS, -22
[    4.411851] microcode: CPU0: patch_level=0x01000065
[    4.416718] microcode: CPU1: patch_level=0x01000065
[    4.421582] microcode: CPU2: patch_level=0x01000065
[    4.426449] microcode: CPU3: patch_level=0x01000065
[    4.431359] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.440424] audit: initializing netlink socket (disabled)
[    4.445819] type=2000 audit(1356050506.982:1): initialized
[    4.468914] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.475786] VFS: Disk quotas dquot_6.5.2
[    4.479721] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.486347] NFS: Registering the id_resolver key type
[    4.491395] Key type id_resolver registered
[    4.495563] Key type id_legacy registered
[    4.499567] NTFS driver 2.1.30 [Flags: R/W].
[    4.503917] msgmni has been set to 7918
[    4.508133] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    4.515505] io scheduler noop registered
[    4.519414] io scheduler deadline registered
[    4.523686] io scheduler cfq registered (default)
[    4.528523] pcieport 0000:00:0b.0: irq 40 for MSI/MSI-X
[    4.533829] pcieport 0000:00:0c.0: irq 41 for MSI/MSI-X
[    4.539130] pcieport 0000:00:0d.0: irq 42 for MSI/MSI-X
[    4.544433] pcieport 0000:00:0e.0: irq 43 for MSI/MSI-X
[    4.549834] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.555675] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    4.563827] ACPI: Power Button [PWRB]
[    4.567571] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.574947] ACPI: Power Button [PWRF]
[    4.578767] ACPI: acpi_idle registered with cpuidle
[    4.589598] ERST: Can not request iomem region <0x        cff7f000-0x        cff80000> for ERST.
[    4.602615] GHES: HEST is not enabled!
[    4.606379] EINJ: Error INJection is initialized.
[    4.611068] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    4.640167] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.666945] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.673447] Non-volatile memory driver v1.3
[    4.677669] Linux agpgart interface v0.103
[    4.681946] [drm] Initialized drm 1.1.0 20060810
[    4.687724] loop: module loaded
[    4.691003] libphy: Fixed MDIO Bus: probed
[    4.695086] tun: Universal TUN/TAP device driver, 1.6
[    4.700121] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.706348] tg3.c:v3.128 (December 03, 2012)
[    4.710966] ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 19
[    4.716713] IOAPIC[0]: Set routing entry (4-19 -> 0xa1 -> IRQ 19 Mode:1 Active:1 Dest:15)
[    4.731719] tg3 0000:02:00.0 eth0: Tigon3 [partno(BCM95722) rev a200] (PCI Express) MAC address 00:1d:09:17:b5:46
[    4.7412:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    4.759895] tg3 0000:02:00.0 eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    4.766859] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.773366] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    4.779353] ehci-pci: EHCI PCI platform driver
[    4.783813] ehci-pci 0000:00:02.1: setting latency timer to 64
[    4.789630] ehci-pci 0000:00:02.1: EHCI Host Controller
[    4.794922] ehci-pci 0000:00:02.1: new USB bus registered, assigned bus number 1
[    4.802302] ehci-pci 0000:00:02.1: reset hcs_params 0x10148a dbg=1 cc=1 pcc=4 !ppc ports=10
[    4.810633] ehci-pci 0000:00:02.1: reset portroute 0 0 0 0 0 0 0 0 0 0 
[    4.817226] ehci-pci 0000:00:02.1: reset hcc_params a086 caching frame 256/512/1024 park
[    4.825306] ehci-pci 0000:00:02.1: park 0
[    4.829309] ehci-pci 0000:00:02.1: reset command 0080b32  park=3 ithresh=8 Async Periodic period=1024 Reset HALT
[    4.839450] ehci-pci 0000:00:02.1: debug port 1
[    4.843965] ehci-pci 0000:00:02.1: bogus port configuration: cc=1 x pcc=4 < ports=10
[    4.851683] ehci-pci 0000:00:02.1: cache line size of 64 is not supported
[    4.858448] ehci-pci 0000:00:02.1: supports USB remote wakeup
[    4.864194] ehci-pci 0000:00:02.1: irq 22, io mem 0xd0001000
[    4.869837] ehci-pci 0000:00:02.1: init command 0010005 (park)=0 ithresh=1 period=512 RUN
[    4.883401] ehci-pci 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    4.889156] usb usb1: default language 0x0409
[    4.89350Product: EHCI Host Controller
[    4.917019] usb usb1: Manufacturer: Linux 3.7.0upstream-11627-g941108b ehci_hcd
[    4.924295] usb usb1: SerialNumber: 0000:00:02.1
[    4.929002] usb usb1: usb_probe_device
[    4.932745] usb usb1: configuration #1 chosen from 1 choice
[    4.938306] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.944091] hub 1-0:1.0: usb_probe_interface
[    4.948355] hub 1-0:1.0: usb_probe_interface - got id
[    4.953392] hub 1-0:1.0: USB hub found
[    4.957131] hub 1-0:1.0: 10 ports detected
[    4.961213] hub 1-0:1.0: standalone hub
[    4.965038] hub 1-0:1.0: no power switching (usb 1.0)
[    4.970072] hub 1-0:1.0: individual port over-current protection
[    4.976058] hub 1-0:1.0: power on to power good time: 20ms
[    4.981526] hub 1-0:1.0: local power source is good
[    4.986423] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.993404] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.999571] ohci_hcd: block sizes: ed 80 td 96
[    5.004027] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    5.009844] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    5.015117] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    5.022501] ohci_hcd 0000:00:02.0: created debug files
[    5.027622] ohci_hcd 0000:00:02.0: supports USB remote wakeup
[    5.033358] ohci_hcd 0000:00:02.0: irq 23, io mem 0xd0000000
[    5.091251] ohci_hcd 0000:00:02.0: OHCI controller state
[    5.096546] ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers, rh state running
[    5.104780] ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=operational CBSR=3
[    5.112150] ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=0
[    5.117617] ohci_hcd 0000:00:02.0: intrstatus 0x00000004 SF
[    5.123176] ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
[    5.129855] ohci_hcd 0000:00:02.0: hcca frame #0029
[    5.134719] ohci_hcd 0000:00:02.0: roothub.a 0100020a POTPGT=1 NPS NDP=10(10)
[    5.141831] ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=0000 DR=0000
[    5.148422] ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
[    5.154323] ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
[    5.160996] ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
[    5.167678] ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
[    5.174361] ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
[    5.181043] ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00000100 PPS
[    5.187724] ohci_hcd 0000:00:02.0: roothub.portstatus [5] 0x00000100 PPS
[    5.194406] ohci_hcd 0000:00:02.0: roothub.portstatus [6] 0x00000100 PPS
[    5.201089] ohci_hcd 0000:00:02.0: roothub.portstatus [7] 0x00000100 PPS
[    5.207771] ohci_hcd 0000:00:02.0: roothub.portstatus [8] 0x00000100 PPS
[    5.214454] ohci_hcd 0000:00:02.0: roothub.portstatus [9] 0x00000100 PPS
[    5.221151] usb usb2: default language 0x0409
[    5.225499] usb usb2: udev 1, busnum 2, minor = 128
[    5.230359] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.237126] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.244316] usb usb2: Product: OHCI Host Controller
[    5.249193] usb usb2: Manufacturer: Linux 3.7.0upstream-11627-g941108b ohci_hcd
[    5.256479] usb usb2: SerialNumber: 0000:00:02.0
[    5.261188] usb usb2: usb_probe_device
[    5.264932] usb usb2: configuration #1 chosen from 1 choice
[    5.270491] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    5.276273] hub 1-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    5.276280] hub 2-0:1.0: usb_probe_interface
[    5.276281] hub 2-0:1.0: usb_probe_interface - got id
[    5.276283] hub 2-0:1.0: USB hub found
[    5.276288] hub 2-0:1.0: 10 ports detected
[    5.276289] hub 2-0:1.0: standalone hub
[    5.276291] hub 2-0:1.0: no power switching (usb 1.0)
[    5.276292] hub 2-0:1.0: global over-current protection
[    5.276293] hub 2-0:1.0: power on to power good time: 2ms
[    5.276297] hub 2-0:1.0: local power source is good
[    5.276298] hub 2-0:1.0: no over-current condition exists
[    5.276330] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    5.276368] ehci-pci 0000:00:02.1: HS companion for 0000:00:02.0
[    5.276469] uhci_hcd: USB Universal Host Controller Interface driver
[    5.347801] usbcore: registered new interface driver usblp
[    5.353450] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    5.376053] hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    5.411001] tsc: Refined TSC clocksource calibration: 2109.722 MHz
[    5.417164] Switching to clocksource tsc
[    5.611156] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.616221] mousedev: PS/2 mouse device common for all mice
[    5.7] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[    5.639646] cpuidle: using governor ladder
[    5.643744] cpuidle: using governor menu
[    5.647654] EFI Variables Facility v0.08 2004-May-17
[    5.652651] zram: num_devices not specified. Using default: 1
[    5.658377] zram: Creating 1 devices ...
[    5.662451] zcache: using lzo compressor
[    5.666497] zcache: cleancache enabled using kernel transcendent memory and compression buddies
[    5.675163] zcache: frontswap enabled using kernel transcendent memory and zsmalloc
[    5.682992] Netfilter messages via NETLINK v0.30.
[    5.687694] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.693875] ctnetlink v0.93: registering with nfnetlink.
[    5.699450] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.704813] TCP: cubic registered
[    5.708117] Initializing XFRM netlink socket
[    5.712415] NET: Registered protocol family 10
[    5.717042] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    5.722671] sit: IPv6 over IPv4 tunneling driver
[    5.727501] NET: Registered protocol family 17
[    5.731970] Key type dns_resolver registered
[    5.736630] 
[    5.736630] printing PIC contents
[    5.741407] ... PIC  IMR: ffff
[    5.744453] ... PIC  IRR: 0800
[    5.747504] ... PIC  ISR: 0000
[    5.750549] ... PIC ELCR: 0c00
[    5.753595] printing local APIC contents on CPU#0/0:
[    5.758536] ... APIC ID:      00000000 (0)
[    5.762612] ... APIC VERSION: 80050010
[    5.766342] ... APIC TASKPRI: 00000000 (00)
[    5.770504] ... APIC ARBPRI: 00000000 (00)
[    5.774580] ... APIC PROCPRI: 00000000
[    5.778310] ... APIC LDR: 01000000
[    5.781691] ... APIC DFR: ffffffff
[    5.785074] ... APIC SPIV: 000001ff
[    5.788541] ... APIC ISR field:
[    5.791669] 0000000000000000000000000000000000000000000000000000000000000000
[    5.798744] ... APIC TMR field:
[    5.801866] 0000000000000000000000000000000000000000000000000000000000000000
[    5.808942] ... APIC IRR field:
[    5.812064] 0000000000000000000000000000000000000000000000000000000000000000
[    5.819137] ... APIC ESR: 00000000
[    5.822523] ... APIC ICR: 000008fd
[    5.825903] ... APIC ICR2: 04000000
[    5.829373] ... APIC LVTT: 000000ef
[    5.832843] ... APIC LVTPC: 00000400
[    5.836401] ... APIC LVT0: 00010700
[    5.839867] ... APIC LVT1: 00000400
[    5.843340] ... APIC LVTERR: 000000fe
[    5.846981] ... APIC TMICT: 002287c5
[    5.850538] ... APIC TMCCT: 000caa0b
[    5.854098] ... APIC TDCR: 00000003
[    5.857568] ... APIC EFEAT: 00040007
[    5.861125] ... APIC ECTRL: 00000000
[    5.864681] ... APIC EILVT0: 000000f9
[    5.868323] ... APIC EILVT1: 00010000
[    5.871965] ... APIC EILVT2: 00010000
[    5.875605] ... APIC EILVT3: 00010000
[    5.879244] 
[    5.880730] number of MP IRQ sources: 15.
[    5.884726] number of IO-APIC #4 registers: 24.
[    5.889239] testing the IO APIC.......................
[    5.894359] IO APIC #4......
[    5.897230] .... register #00: 04000000
[    5.901050] .......    : physical APIC id: 04
[    5.905390] .......    : Delivery Type: 0
[    5.909383] .......    : LTS          : 0
[    5.913378] .... register #01: 00170011
[    5.917199] .......     : max redirection entries: 17
[    5.922231] .......     : PRQ implemented: 0
[    5.926485] .......     : IO APIC version: 11
[    5.930826] .... register #02: 04000000
[    5.934648] .......     : arbitration: 04
[    5.938643] .... IRQ redirection table:
[    5.942465]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    5.947931]  00 00  1    0    0   0   0    0    0    00
[    5.953155]  01 0F  0    0    0   0   0    1    1    31
[    5.958379]  02 0F  0    0    0   0   0    1    1    30
[    5.963609]  03 0F  0    0    0   0   0    1    1    33
[    5.968832]  04 0F  0    0    0   0   0    1    1    34
[    5.974054]  05 0F  0    0    0   0   0    1    1    35
[    5.979279]  06 0F  0    0    0   0   0    1    1    36
[    5.984501]  07 0F  1    0    0   0   0    1    1    37
[    5.989723]  08 0F  0    0    0   0   0    1    1    38
[    5.994944]  09 0F  0    1    0   1   0    1    1    39
[    6.000166]  0a 0F  0    0    0   0   0    1    1    3A
[    6.005390]  0b 0F  1    0    0   0   0    1    1    3B
[    6.010612]  0c 0F  1    0    0   0   0    1    1    3C
[    6.015836]  0d 0F  0    0    0   0   0    1    1    3D
[    6.021057]  0e 0F  0    0    0   0   0    1    1    3E
[    6.026279]  0f 0F  0    0    0   0   0    1    1    3F
[    6.031501]  10 00  1    0    0   0   0    0    0    00
[    6.036728]  11 00  1    0    0   0   0    0    0    00
[    6.041952]  12 00  1    0    0   0   0    0    0    00
[    6.047174]  13 0F  1    1    0   1   0    1    1    A1
[    6.052395]  14 00  1    0    0   0   0    0    0    00
[    6.057617]  15 00  1    0    0   0   0    0    0    00
[    6.062839]  16 0F  0    1    0   1   0    1    1    51
[    6.068063]  17 0F  0    1    0   1   0    1    1    41
[    6.073283] IRQ to pin mappings:
[    6.076497] IRQ0 -> 0:2
[    6.078955] IRQ1 -> 0:1
[    6.081414] IRQ3 -> 0:3
[    6.083878] IRQ4 -> 0:4
[    6.086341] IRQ5 -> 0:5
[    6.088807] IRQ6 -> 0:6
[    6.091270] IRQ7 -> 0:7
[    6.093736] IRQ8 -> 0:8
[    6.096199] IRQ9 -> 0:9
[    6.098670] IRQ10 -> 0:10
[    6.101307] IRQ11 -> 0:11
[    6.103940] IRQ12 -> 0:12
[    6.106579] IRQ13 -> 0:13
[    6.109215] IRQ14 -> 0:14
[    6.111854] IRQ15 -> 0:15
[    6.114493] IRQ19 -> 0:19
[    6.117124] IRQ22 -> 0:22
[    6.119763] IRQ23 -> 0:23
[    6.122401] .................................... done.
[    6.127683] PM: Hibernation image not present or could not be loaded.
[    6.134111] registered taskstats version 1
[    6.138753]   Magic number: 8:743:658
[    6.144120] Freeing unused kernel memory: 756k freed
[    6.149314] Write protecting the kernel read-only data: 10240k
[    6.160541] Freeing unused kernel memory: 1648k freed
[    6.166631] Freeing unused kernel memory: 140k freed
init started^G^G^G^G^G^G^G^G^G^G^G^G^G^Gmount: mount point /proc/bus/usb does not exist
mount: mount point /proc/xen do[    6.421826] core_filesystem (1192) used greatsys/kernel/config does not exist
^G^G^G^G^G^G^G^G^G^G^G^G^Gca[    6.437603] udevd (1227): /proc/1227/oom_adj is deprecated, please use /proc/1227/oom_score_adj instead.
t: /sys/hypervisor/type: No such file or directory
/usr/bin/load_xen_modules: line 3: [: ==: unary operator expected
^G^G^G^G[    6.474118] SCSI subsystem initialized
[    6.482848] ACPI: bus type scsi registered
[    6.487315] libata version 3.00 loa00:00:07.0: setting latency timer to 64
^G^G^G^G^G^G^G^G[    6.516854] [drm] radeon defaulting to kernel modesetting.
^G^G^G^G^G^G^G^G[    6.516855] [drm] radeon kernel modesetting enabled.
^G^G^G^G^G^G^G^G[    6.517197] ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 18
^G^G^G^G^G^G^G^G[    6.517204] IOAPIC[0]: Set routing entry (4-18 -> 0xc1 -> IRQ 18 Mode:1 Active:1 Dest:15)
[    6.518277] [drm] initializing kernel modesetting (RV100 0x1002:0x515E 0x1028:0x0225).
^G^G^G^G^G^G^G^G[    6.518297] [drm] register mmio base: 0xD0100000
^G^G^G^G^G^G^G^G[    6.518298] [drm] register mmio size: 65536
^G^G^G^G[    6.518397] radeon 0000:01:08.0: VRAM: 128M 0x00000000D8000000 - 0x00000000DFFFFFFF (32M used)
[    6.518400] radeon 0000:01:08.0: GTT: 512M 0x00000000B8000000 - 0x00000000D7FFFFFF
[    6.518405] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    6.518406] [drm] Driver supports precise vblank timestamp query.
[    6.518425] [drm] radeon: irq initialized.
udevd-work[1440][    6.601794] [drm] Detected VRAM RAM=128M, BAR=128M
: error opening [    6.607954] [drm] RAM width 16bits DDR
ATTR{/sys/device[    6.613154] [TTM] Zone  kernel: Available graphics memory: 2028372 kiB
s/system/cpu/cpu[    6.620933] [TTM] Initializing pool allocator
0/online} for wr[    6.626664] [TTM] Initializing DMA pool allocator
iting: No such f[    6.632753] [drm] radeon: 32M of VRAM memory ready
ile or directory[    6.632754] [drm] radeon: 512M of GTT memory ready.
[    6.632783] [drm] GART: num cpu pages 131072, num gpu pages 131072


[    6.655070] [drm] PCI GART of 512M enabled (table at 0x00000000CF880000).
[    6.661862] radeon 0000:01:08.0: WB disabled
[72090] radeon 0000:01:08.0: fence driver on ring 0 use gpu addr 0x00000000b8000000 and cpu addr 0xffff8800cf805000
^G^G^G^G^G^G^G[    6.683361] [drm] Loading R100 Microcode
^G^G^G^G^G^G^G^G[    6.688788] [drm] radeon: ring at 0x00000000B8001000
^G^G^G^G[    6.694784] [drm] ring test succeeded in 1 usecs
[    6.700157] scsi0 : sata_nv
[    6.703141] [drm] ib test succeeded in 0 usecs
Waiting for devi[    6.708025] scsi1 : sata_nv
ces [  OK  ]
[    6.712152] ata1: SATA max UDMA/133 cmd 0x20f0 ctl 0x20e0 bmdma 0x20b0 irq 21
[    6.720171] ata2: SATA max UDMA/133 cmd 0x20d0 ctl 0x20c0 bmdma 0x20b8 irq 21
[    6.727732] ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 20
[    6.733475] IOAPIC[0]: Set routing entry (4-20 -> 0xd1 -> IRQ 20 Mode:1 Active:1 Dest:15)
[    6.741673] sata_nv 0000:00:08.0: setting latency timer to 64
[    6.747542] [drm] Radeon Display Connectors
[    6.751714] [drm] Connector 0:
[    6.754759] [drm]   VGA-1
[    6.757371] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[    6.763359] [drm]   Encoders:
[    6.766317] [drm]     CRT1: INTERNAL_DAC1
[    6.788537] radeon 0000:01:08.0: No connectors reported connected with modes
[    6.795559] [drm] Cannot find any crtc or sizes - going 1024x768
[    6.808986] [drm] fb mappable at 0xD8040000
[    6.813165] [drm] vram apper at 0xD8000000
[    6.817245] [drm] size 786432G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[    6.840898] Console: switching to colour frame buffer device 128x48
[    6.854527] radeon 0000:01:08.0: fb0: radeondrmfb frame buffer device
[    6.860945] radeon 0000:01:08.0: registered panic notifier
[    6.866415] [drm] Initialized radeon 2.27.0 20080528 for 0000:01:08.0 on minor 0
[    6.873793] scsi2 : sata_nv
[    6.876867] scsi3 : sata_nv
[    6.879871] ata3: SATA max UDMA/133 cmd 0x2440 ctl 0x2430 bmdma 0x2400 irq 20
[    6.886983] ata4: SATA max UDMA/133 cmd 0x2420 ctl 0x2410 bmdma 0x2408 irq 20
[    6.894180] kvm: Nested Virtualization enabled
[    6.898618] kvm: Nested Paging enabled
[    7.180645] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.202055] ata1.00: ATA-7: WDC WD800AAJS-18TDA1, 01.00A04, max UDMA/133
[    7.208738] ata1.00: 156250000 sectors, multi 0:1.00: failed to get Identify Device Data, Emask 0x1
[    7.237024] ata1.00: configured for UDMA/133
^G^G^G^G^G^G^G^G[    7.241447] scsi 0:0:0:0: Direct-Access     ATA      WDC WD800AAJS-18 01.0 PQ: 0 ANSI: 5
^G^G^G^G^G^G^G^G[    7.251181] ACPI: Invalid Power Resource to register!
^G^G^G[    7.347515] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    7.356706] ata3.00: ATAPI: HL-DT-STDVD-ROM GDRH20N, 0D04, max UDMA/100
[    7.368679] ata3.00: configured for UDMA/100
[    7.559349] ata2: SATA link down (SStatus 0 SControl 300)
[    7.566244] scsi 2:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GD^G[    7.883098] ata4: SATA link down (SStatus 0 SControl 300)
[    7.892389] sd 0:0:0:0: [sda] 156250000 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    7.900198] sd 0:0:0:0: [sda] Write Protect is off
[    7.901813] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[    7.901816] cdrom: Uniform CD-ROM driver Revision: 3.20
[    7.902076] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    7.920940] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.926014] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.939407]  sda: sda1 sda2
[    7.942560] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.949796] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.955181] sr 2:0:0:0: Attached scsi generic sg1 type 5
Waiting for fb [  OK  ]
Waiting for network [  OK  ]
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth0:  [    8.164756] tg3 0000:02:00.0: irq 44 for MSI/MSI-X
[    8.202892] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    8.208836] ip (2480) used greatest stack depth: 3664 byteG^G^G
Determining IP information for s[    8.254687] IPv6: ADDRCONF(NETDEV_UP): switch: link is not ready
witch...[   11.372531] tg3 0000:02:00.0 eth0: Link is up at 1000 Mbps, full duplex
[   11.379124] tg3 0000:02:00.0 eth0: Flow control iGE): eth0: link becomes ready
[   11.392337] switch: port 1(eth0) entered forwarding state
[   11.397720] switch: port 1(eth0) entered forwarding state
^G^G^G^G^[   11.403174] IPv6: ADDRCONF(NETDEV_CHANGE): switch: link becomes ready
G^G^G^G^G^G^G^G^G^G^G^G^G done.
[  OK  ]
Waiting for init.custom [  OK  ]

Starting SSHd ...

    SSH started [2667]


Waiting for SSHd [  OK  ]
WARNING: ssh currently running [2667] ignoring start request
[   13.229516] Loading iSCSI transport class v2.0-870.
[   13.236884] iscsi: registered transport (tcp)
iscsistart: transport class version 2.0-870. iscsid version 2.0-872
Could not get list of targets from firmware.
Dec 21 00:41:an't open /dev/hvc0'
[0:0:0:0]    disk    ATA      WDC WD800AAJS-18 01.0  /dev/sda 
[2:0:0:0]    cd/dvd  HL-DT-ST DVD-ROM GDRH20N  0D04  /dev/sr0 
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a4)
00:01.0 ISA bridge: nVidia Corporation CK804 ISAUSB Controller: nVidia Corporation CK804 USB Controller (rev a4)
00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev f2)
00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Link Control
01:08.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5722 Gigabit Ethernet PCI Express
           CPU0       CPU1       CPU2       CPU3       
  0:        186          0          0          0   IO-APIC-edge      timer
  1:          1          0          2          0   IO-APIC-edge      i8042
  4:          0          0          9        205   IO-APIC-edge      serial
  7:          1          0          0          0   IO-APIC-edge    
  8:          0          0          7         12   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 18:          0          0          0          2   IO-APIC-fasteoi   radeon
 20:          0          0          1        104   IO-APIC-fasteoi   sata_nv
 21:          0          0          0          6   IO-APIC-fasteoi   sata_nv
 22:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
 23:          0          0          0          0   IO-APIC-fasteoi   ohci_hcd:usb2
 44:          1          0          1         63   PCI-MSI-edge      eth0
NMI:          0          0          0          0   Non-maskable interrupts
LOC:       3428       5032       2459       3357   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RTR:          0          0          0          0   APIC ICR read retries
RES:       3330       2274       2464       3292   Rescheduling interrupts
CAL:        237        225        252        217   Function call interrupts
TLB:        128        132        110        108   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          1          1          1          1   Machine check polls
ERR:          1
MIS:          0
00000000-0000ffff : reserved
00010000-0009d7ff : System RAM
0009d800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000c8fff : Video ROM
000c9000-000cadff : Adapter ROM
000cc000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-7ffeffff : System RAM
  01000000-01660947 : Kernel code
  01660948-01aa67ff : Kernel data
  01b6c000-01c6efff : Kernel bss
7fff0000-7fffffff : reserved
80000000-cfeeffff : System RAM
  c4000000-c7ffffff : GART
cfef0000-cfef4fff : ACPI Tables
cfef5000-cff7efff : ACPI Non-volatile Storage
cff7f000-cff7ffff : RAM buffer
cff80000-cf^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^Gffffff : reserved
d0000000-febfffff : PCI Bus 0000:00
  d0000000-d0000fff : 0000:00:02.0
    d0000000-d0000fff : ohci_hcd
  d0001000-d00010ff : 0000:00:02.1
    d0001000-d00010ff : ehci_hcd
  d0002000-d0002fff : 0000:00:07.0
    d0002000-d0002fff : sata_nv
  d0003000-d0003fff : 0000:00:08.0
    d0003000-d0003fff : sata_nv
  d0100000-d01fffff : PCI Bus 0000:01
    d0100000-d010ffff : 0000:01:08.0
    d0120000-d013ffff : 0000:01:08.0
  d0200000-d02fffff : PCI Bus 0000:02
    d0200000-d020ffff : 0000:02:00.0
      d0200000-d020ffff : tg3
  d8000000-dfffffff : PCI Bus 0000:01
    d8000000-dfffffff : 0000:01:08.0
  e0000000-efffffff : reserved
    e0000000-efffffff : pnp 00:01
      e0000000-e04fffff : PCI MMCONFIG 0000 [bus 00-04]
fec00000-fec0ffff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed00fff : pnp 00:00
  fed00000-fed003ff : HPET 0
fed40000-fed8ffff : PCI Bus 0000:00
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
fff80000-ffffffff : reserved
100000000-12fffffff : System RAM
MemTotal:        4056744 kB
MemFree:         3677064 kB
Buffers:               0 kB
Cached:           330376 kB
SwapCached:            0 kB
Active:            24400 kB
Inactive:         306016 kB
Active(anon):      17960 kB
Inactive(anon):   157932 kB
Active(file):       6440 kB
Inactive(file):   148084 kB
Unevictable:        4900 kB
Mlocked:            4900 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:          4720 kB
Mapped:             5192 kB
Shmem:            172352 kB
Slab:              23760 kB
SReclaimable:      12168 kB
SUnreclaim:        11592 kB
KernelStack:         616 kB
PageTables:          656 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     2028372 kB
Committed_AS:     181976 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       18228 kB
VmallocChunk:   34359719675 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       33728 kB
DirectMap2M:     2062336 kB
DirectMap1G:     2097152 kB
Waiting for init.late [  OK  ]
PING build.dumpdata.com (192.168.101.3) 56(84) bytes of data.

--- build.dumpdata.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 1ms
rtt min/avg/max/mdev = 0.365/0.365/0.365/0.000 ms
NFS done
libxl: error: libxl.c:56:libxl_ctx_init Is xenstore dae[   14.062956] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
mon running?
fa[   14.073738] device-mapper: multipath: version 1.5.0 loaded
iled to stat /var/run/xenstored.pid: No such file or directory
cannot init xl context
192.168.101.2:3260,1 iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb
192.168.101.2:3260,1 iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb
Logging in to [iface: default, target: iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb, portal: 192.168.101.2,3260]
Dec 21 00:41:58 tst001 iscsid: transport class version 2.0-870. iscsid version 2.0-872
Dec 21 00:41:58 tst001 iscsid: iSCSI da^G[   14.338261] scsi4 : iSCSI Initiator over TCP/IP
[   14.596010] scsi 4:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
[   14.604508] sd 4:0:0:0: Attached0
[   14.605855] sd 4:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   14.624576]  sdb: unknown partition table
[   14.628090] sd 4:0:0:0: [sdb] Attached SCSI disk
[   14.644984] ttyS0: 1 input overrun(s)
^GLogin to [iface: default, target: iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb, portal: 192.168.101.2,3260] successful.
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^GDec 21 00:41:59 tst001 iscsid: Connection1:0 to [target: iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb,G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G
PXELINUX 3.82 2009-06-09  Copyright (C) 1994-2009 H. Peter Anvin et al
Loading latest/vmlinuz.....................................................................
Loading latest/initramfs.cpio.gz..............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................ready.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.0upstream-11627-g941108b (konrad@build.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP Thu Dec 20 18:33:37 EST 2012
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000cc000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ffeffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007fff0000-0x000000007fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000080000000-0x00000000cfeeffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cfef0000-0x00000000cfef4fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cfef5000-0x00000000cff7efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cff80000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff80000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000012fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Dell Inc. PowerEdge T105 /0RR825, BIOS 1.3.2 08/20/2008
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x130000 max_arch_pfn = 0x1000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f7a70-0x000f7a7f] mapped at [c00f7a70]
[    0.000000]   mpc: 9e171-9e2a5
[    0.000000] initial memory mapped: [mem 0x00000000-0x01dfffff]
[    0.000000] Base memory trampoline at [c0099000] 99000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x37bfdfff]
[    0.000000]  [mem 0x00000000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x379fffff] page 2M
[    0.000000]  [mem 0x37a00000-0x37bfdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x37bfdfff @ [mem 0x01dfa000-0x01dfffff]
[    0.000000] RAMDISK: [mem 0x7b60f000-0x7ffcefff]
[    0.000000] Allocated new RAMDISK: [mem 0x3323e000-0x37bfde8e]
[    0.000000] Move RAMDISK from [mem 0x7b60f000-0x7ffcee8e] to [mem 0x3323e000-0x37bfde8e]
[    0.000000] ACPI: RSDP 000f79b0 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT cfef0753 0009C (v01 DELL   PE_SC3   06040000 DELL 00000000)
[    0.000000] ACPI: FACP cfef3c5f 000F4 (v03 DELL   PE_SC3   06040000 DELL 000F4240)
[    0.000000] ACPI: DSDT cfef07ef 033FC (v01 DELL   PE_SC3   06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS cfef5fc0 00040
[    0.000000] ACPI: TCPA cfef3d53 00032 (v01 Phoeni  x       06040000  TL  00000000)
[    0.000000] ACPI: SLIC cfef3d85 00024 (v01 DELL   PE_SC3   06040000 PTL  00000001)
[    0.000000] ACPI: SPCR cfef3da9 00050 (v01 DELL   PE_SC3   06040000 PTL  00000001)
[    0.000000] ACPI: EINJ cfef3df9 001B0 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: HEST cfef3fa9 000A8 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: BERT cfef4051 00030 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: SSDT cfef4081 000E1 (v01 wheaos  wheaosc 06040000 INTL 20050624)
[    0.000000] ACPI: ERST cfef4162 00270 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: SRAT cfef43d2 000E8 (v01 AMD    HAMMER   06040000 AMD  00000001)
[    0.000000] ACPI: SSDT cfef44ba 00A30 (v01 AMD    POWERNOW 06040000 AMD  00000001)
[    0.000000] ACPI: MCFG cfef4eea 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: HPET cfef4f26 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
[    0.000000] ACPI: APIC cfef4f5e 0007A (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT cfef4fd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff9000 (        fee00000)
[    0.000000] 3972MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x37bfdfff]
[    0.000000]   HighMem  [mem 0x37bfe000-0x2fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x7ffeffff]
[    0.000000]   node   0: [mem 0x80000000-0xcfeeffff]
[    0.000000]   node   0: [mem 0x00000000-0x2fffffff]
[    0.000000] On node 0 totalpages: 1048173
[    0.000000] free_area_init_node: node 0, pgdat c175d240, node_mem_map f0c3d200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3949 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 222502 pages, LIFO batch:31
[    0.000000]   HighMem zone: 7945 pages used for memmap
[    0.000000]   HighMem zone: 811993 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff9000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] Int: type 0, pol 1, trig 1, bus 00, IRQ 00, APIC ID 4, APIC INT 02
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 09, APIC ID 4, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 4, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 4, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 4, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 4, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 4, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 4, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 4, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 4, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 4, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 4, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 4, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 4, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 4, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000cc000
[    0.000000] PM: Registered nosave memory: 00000000000cc000 - 0000000000100000
[    0.000000] e820: [mem 0xd0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @f0bf3000 s34944 r0 d22400 u57344
[    0.000000] pcpu-alloc: s34944 r0 d22400 u57344 alloc=14*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1038444
[    0.000000] Kernel command line: initrd=latest/initramfs.cpio.gz zcache nofb debug selinux=0 console=ttyS0,115200 loglevel=10 apic=debug BOOT_IMAGE=latest/vmlinuz 
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00037bfe:00130000)
[    0.000000] Memory: 4068260k/4980736k available (5691k kernel code, 124432k reserved, 1900k data, 536k init, 3279752k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff14000 - 0xfffff000   ( 940 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc176b000 - 0xc17f1000   ( 536 kB)
[    0.000000]       .data : 0xc158eebd - 0xc176a180   (1900 kB)
[    0.000000]       .text : 0xc1000000 - 0xc158eebd   (5691 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:2304 nr_irqs:712 16
[    0.000000] CPU 0 irqstacks, hard=f0406000 soft=f0408000
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.001000] tsc: Fast TSC calibration using PIT
[    0.002000] tsc: Detected 2109.833 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 4219.66 BogoMIPS (lpj=2109833)
[    0.010592] pid_max: default: 32768 minimum: 301
[    0.015224] Security Framework initialized
[    0.019309] SELinux:  Disabled at boot.
[    0.023145] Mount-cache hash table entries: 512
[    0.027838] Initializing cgroup subsys cpuacct
[    0.032270] Initializing cgroup subsys freezer
[    0.036720] CPU: Physical Processor ID: 0
[    0.040718] CPU: Processor Core ID: 0
[    0.044374] mce: CPU supports 6 MCE banks
[    0.048376] LVT offset 0 assigned for vector 0xf9
[    0.053069] process: using AMD E400 aware idle routine
[    0.058196] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
[    0.058196] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64
[    0.058196] tlb_flushall_shift: 4
[    0.072881] Freeing SMP alternatives: 24k freed
[    0.079375] ACPI: Core revision 20121018
[    0.088153] Getting VERSION: 80050010
[    0.091807] Getting VERSION: 80050010
[    0.095460] Getting ID: 0
[    0.098073] Getting ID: f000000
[    0.101205] Getting LVT0: 10000
[    0.104333] Getting LVT1: 10000
[    0.107472] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.112857] masked ExtINT on CPU#0
[    0.116395] ENABLING IO-APIC IRQs
[    0.119700] init IO_APIC IRQs
[    0.122659]  apic 4 pin 0 not connected
[    0.126486] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.134379] IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.142271] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.150158] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.158049] IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.165939] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.173829] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.181720] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.189611] IOAPIC[0]: Set routing entry (4-9 -> 0x39 -> IRQ 9 Mode:1 Active:1 Dest:1)
[    0.197500] IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.205564] IOAPIC[0]: Set routing entry (4-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.213626] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.221690] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.229753] IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.237817] IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.245880]  apic 4 pin 16 not connected
[    0.249782]  apic 4 pin 17 not connected
[    0.253691]  apic 4 pin 18 not connected
[    0.257600]  apic 4 pin 19 not connected
[    0.261501]  apic 4 pin 20 not connected
[    0.265411]  apic 4 pin 21 not connected
[    0.269321]  apic 4 pin 22 not connected
[    0.273223]  apic 4 pin 23 not connected
[    0.277272] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.293261] smpboot: CPU0: Quad-Core AMD Opteron(tm) Processor 1352 (fam: 10, model: 02, stepping: 03)
[    0.302580] Using local APIC timer interrupts.
[    0.302580] calibrating APIC timer ...
[    0.412195] ... lapic delta = 1255730
[    0.415841] ... PM-Timer delta = 357939
[    0.419659] ... PM-Timer result ok
[  0627 MHz.
[    0.438484] ..... host bus clock speed is 200.0916 MHz.
[    0.443698] Performance Events: AMD PMU driver.
[    0.448229] ... version:                0
[    0.452227] ... bit width:              48
[    0.456310] ... generic registers:      4
[    0.460306] ... value mask:             0000ffffffffffff
[    0.465590] ... max period:             00007fffffffffff
[    0.470883] ... fixed-purpose events:   0
[    0.474878] ... event mask:             000000000000000f
[    0.480368] MCE: In-kernel MCE decoding enabled.
[    0.485030] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.493124] CPU 1 irqstacks, hard=f049e000 soft=f04a0000
[    0.498415] smpboot: Booting Node   0, Processors  #1[    0.513539] Initializing CPU#1
[    0.516595] masked ExtINT on CPU#1

[    0.522172] CPU 2 irqstacks, hard=f04ec000 soft=f04ee000
[    0.527651]  #2[    0.539478] Initializing CPU#2
[    0.542534] masked ExtINT on CPU#2

[    0.548174] CPU 3 irqstacks, hard=f051a000 soft=f[    0.565912] Initializing CPU#3
[    0.568962] masked ExtINT on CPU#3
[    0.574399] Brought up 4 CPUs
[    0.577358] smpbo1) used greatest stack depth: 7236 bytes left
[    0.595145] RTC time:  0:43:06, date: 12/21/12
[    0.606175] NET: Registered protocol family 16
[    0.611050] node 0 link 0: io port [1000, 3fff]
[    0.615572] node 0 link 0: io port [4000, fffff]
[    0.620174] TOM: 00000000d0000000 aka 3328M
[    0.624341] node 0 link 0: mmio [d0000000, d04fffff]
[    0.629301] node 0 link 0: mmio [fed00000, fed0ffff]
[    0.634255] node 0 link 0: mmio [d8000000, dfffffff]
[    0.639208] node 0 link 0: mmio [fec00000, fec0ffff]
[    0.644162] node 0 link 0: mmio [e0000000, efffffff]
[    0.649115] node 0 link 0: mmio [a0000, bffff]
[    0.653551] node 0 link 0: mmio [f0000000, fe0bffff]
[    0.658511] TOM2: 0000000130000000 aka 4864M
[    0.662767] bus: [bus 00-ff] on node 0 link 0
[    0.667106] bus: 00 [io  0x0000-0xffff]
[    0.670927] bus: 00 [mem 0xd0000000-0xd7ffffff]
[    0.675441] bus: 00 [mem 0xfec10000-0xffffffff]
[    0.679954] bus: 00 [mem 0xd8000000-0xfebfffff]
[    0.684468] bus: 00 [mem 0xfec00000-0xfec0ffff]
[    0.688980] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.693494] bus: 00 [mem 0x130000000-0xfcffffffff]
[    0.698376] ACPI: bus type pci registered
[    0.702506] dca service started, version 1.12.1
[    0.707071] PCI: MMCONFIG for domain 0000 [bus 00-04] at [mem 0xe0000000-0xe04fffff] (base 0xe0000000)
[    0.716347] PCI: MMCONFIG at [mem 0xe0000000-0xe04fffff] reserved in E820
[    0.723110] PCI: Using MMCONFIG for extended config space
[    0.728487] PCI: Using configuration type 1 for base access
[    0.734680] kworker/u:0 (59) used greatest stack depth: 7044 bytes left
[    0.747379] bio: create slab <bio-0> at 0
[    0.751557] ACPI: Added _OSI(Module Device)
[    0.755727] ACPI: Added _OSI(Processor Device)
[    0.760154] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.764840] ACPI: Added _OSI(Processor Aggregator Device)
[    0.771070] ACPI: EC: Look up EC in DSDT
[    0.779609] \_SB_:_OSC evaluation returned wrong type
[    0.784643] _OSC request data:1 17 
[    0.788563] ACPI: InterpretI: Using IOAPIC for interrupt routing
[    0.809717] ACPI: No dock devices found.
[    0.813671] [Firmware Warn]: HEST: Duplicated hardware error source ID: 9.
[   CPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.841914] pci_root PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.850234] pci_root PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.858557] pci_root PNP0A03:00: ignoring host bridge window [mem 0x000c0000-0x000dffff] (conflicts with reserved [mem 0x000cc000-0x000fffff])
[    0.871288] pci_root PNP0A03:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-04] only partially covers this bridge
[    0.882171] PCI host bridge to bus 0000:00
[    0.886255] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.891720] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.897876] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.904033] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.910883] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xfebfffff]
[    0.917733] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed8ffff]
[    0.924594] pci 0000:00:00.0: [10de:005e] type 00 class 0x058000
[    0.930646] pci 0000:00:01.0: [10de:0051] type 00 class 0x060100
[    0.936633] pci 0000:00:01.0: reg 10: [io  0x8c00-0x8fff]
[    0.942036] pci 0000:00:01.1: [10de:0052] type 00 class 0x0c0500
[    0.948026] pci 0000:00:01.1: reg 10: [io  0x2080-0x209f]
[    0.953408] pci 0000:00:01.1: reg 20: [io  0x2040-0x207f]
[    0.958788] pci 0000:00:01.1: reg 24: [io  0x2000-0x203f]
[    0.964179] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.970002] pci 0000:00:02.0: [10de:005a] type 00 class 0x0c0310
[    0.975992] pci 0000:00:02.0: reg 10: [mem 0xd0000000-0xd0000fff]
[    0.982087] pci 0000:00:02.0: supports D1 D2
[    0.986342] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.992941] pci 0000:00:02.1: [10de:005b] type 00 class 0x0c0320
[    0.998930] pci 0000:00:02.1: reg 10: [mem 0xd0001000-0xd00010ff]
[    1.005029] pci 0000:00:02.1: supports D1 D2
[    1.009283] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.015889] pci 0000:00:07.0: [10de:0054] type 00 class 0x010185
[    1.021879] pci 0000:00:07.0: reg 10: [io  0x20f0-0x20f7]
[    1.027254] pci 0000:00:07.0: reg 14: [io  0x20e0-0x20e3]
[    1.032634] pci 0000:00:07.0: reg 18: [io  0x20d0-0x20d7]
[    1.038014] pci 0000:00:07.0: reg 1c: [io  0x20c0-0x20c3]
[    1.043394] pci 0000:00:07.0: reg 20: [io  0x20b0-0x20bf]
[    1.048774] pci 0000:00:07.0: reg 24: [mem 0xd0002000-0xd0002fff]
[    1.054872] pci 0000:00:08.0: [10de:0055] type 00 class 0x010185
[    1.060862] pci 0000:00:08.0: reg 10: [io  0x2440-0x2447]
[    1.066244] pci 0000:00:08.0: reg 14: [io  0x2430-0x2433]
[    1.071625] pci 0000:00:08.0: reg 18: [io  0x2420-0x2427]
[    1.077006] pci 0000:00:08.0: reg 1c: [io  0x2410-0x2413]
[    1.082386] pci 0000:00:08.0: reg 20: [io  0x2400-0x240f]
[    1.087767] pci 0000:00:08.0: reg 24: [mem 0xd0003000-0xd0003fff]
[    1.093860] pci 0000:00:09.0: [10de:005c] type 01 class 0x060400
[    1.099862] pci 0000:00:0b.0: [10de:005d] type 01 class 0x060400
[    1.105873] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.112474] pci 0000:00:0c.0: [10de:005d] type 01 class 0x060400
[    1.118483] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.125084] pci 0000:00:0d.0: [10de:005d] type 01 class 0x060400
[    1.131092] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.137693] pci 0000:00:0e.0: [10de:005d] type 01 class 0x060400
[    1.143701] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.150306] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    1.156307] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    1.162305] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    1.168303] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    1.174304] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    1.180322] pci 0000:01:08.0: [1002:515e] type 00 class 0x030000
[    1.186316] pci 0000:01:08.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
[    1.192824] pci 0000:01:08.0: reg 14: [io  0x3000-0x30ff]
[    1.198208] pci 0000:01:08.0: reg 18: [mem 0xd0100000-0xd010ffff]
[    1.204298] pci 0000:01:08.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.210817] pci 0000:01:08.0: supports D1 D2
[    1.215092] pci 0000:00:09.0: PCI bridge to [bus 01]
[    1.220040] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    1.226118] pci 0000:00:09.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    1.232886] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdfffffff pref]
[    1.240115] pci 0000:02:00.0: [14e4:165a] type 00 class 0x020000
[    1.246112] pci 0000:02:00.0: reg 10: [mem 0xd0200000-0xd020ffff 64bit]
[    1.252784] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    1.260480] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    1.265432] pci 0000:00:0b.0:   bridge window [mem 0xd0200000-0xd02fffff]
[    1.272214] pci 0000:00:0c.0: PCI bridge to [bus 03]
[    1.277184] pci 0000:00:0d.0: PCI bridge to [bus 04]
[    1.282149] pci 0000:00:0e.0: PCI bridge to [bus 05]
[    1.287105] pci_bus 0000:00: on NUMA node 0
[    1.291282] ACPI: Invalid Power Resource to register!
[    1.296325] ACPI: Invalid Power Resource to register!
[    1.301365] ACPI: Invalid Power Resource to register!
[    1.306405] ACPI: Invalid Power Resource to register!
[    1.311456] ACPI: Invalid Power Resource to register!
[    1.316490] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
[    1.322865] ACPI: Invalid Power Resource to register!
[    1.327906] ACPI: Invalid Power Resource to register!
[    1.332947] ACPI: Invalid Power Resource to register!
[    1.337981] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
[    1.344347] ACPI: Invalid Power Resource to register!
[    1.349380] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
[    1.355744] ACPI: Invalid Power Resource to register!
[    1.360777] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
[    1.367141] ACPI: Invalid Power Resource to register!
[    1.372175] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR3._PRT]
[    1.378534] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.407317] ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
[    1.413658] ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17nterrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
[    1.441722] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0
[    1.448014] ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
[    1.454315] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0, disabled.
[    1.461569] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[    1.468835] ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
[    1.476096] ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
[    1.483354] ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
[    1.490627] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
[    1.496923] ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0
[    1.503231] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    1.510571] vgaarb: device added: PCI:0000:01:08.0,decodes=io+mem,owns=io+mem,locks=none
[    1.518631] vgaarb: loaded
[    1.521328] vgaarb: bridge control possible 0000:01:08.0
[    1.526769] ACPI: bus type usb registered
[    1.530846] usbcore: registered new interface driver usbfs
[    1.536354] usbcore: registered new interface driver hub
[    1.541729] usbcore: registered new device driver usb
[    1.546916] pps_core: LinuxPPS API ver. 1 registered
[    1.551863] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.560994] PTP clock support registered
[    1.565006] PCI: Using ACPI for IRQ routing
[    1.569180] PCI: pci_cache_line_size set to 64 bytes
[    1.574168] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    1.580154] e820: reserve RAM buffer [mem 0x7fff0000-0x7fffffff]
[    1.586137] e820: reserve RAM buffer [mem 0xcfef0000-0xcfffffff]
[    1.592343] NetLabel: Initializing
[    1.595733] NetLabel:  domain hash size = 128
[    1.600073] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.605030] NetLabel:  unlabeled traffic allowed by default
[    1.610775] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    1.617800] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    1.622794] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    1.630786] Switching to clocksource hpet
[    1.636821] pnp: PnP ACPI init
[    1.639879] ACPI: bus type pnp registered
[    1.644119] system 00:00: [mem 0xffc00000-0xffffffff] could not be reserved
[    1.651059] system 00:00: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.658001] system 00:00: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.664938] system 00:00: [mem 0xfed00000-0xfed00fff] has been reserved
[    1.671532] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.678421] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    1.685015] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.692426] system 00:02: [io  0x8000-0x807f] has been reserved
[    1.698327] system 00:02: [io  0x8080-0x80ff] has been reserved
[    1.704228] system 00:02: [io  0x8400-0x847f] has been reserved
[    1.710130] system 00:02: [io  0x8480-0x84ff] has been reserved
[    1.716030] system 00:02: [io  0x8800-0x887f] has been reserved
[    1.721931] system 00:02: [io  0x8880-0x88ff] has been reserved
[    1.727832] system 00:02: [io  0x2040-0x207f] has been reserved
[    1.733733] system 00:02: [io  0x2000-0x203f] has been reserved
[    1.739634] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.746506] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
[    1.754543] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.761145] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    1.767047] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.773834] pnp 00:05: [dma 4]
[    1.776932] pnp 00:05: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.783505] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.790110] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.796631] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
[    1.804833] pnp 00:08: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.811422] system 00:09: [io  0x0c00-0x0c7f] has been reserved
[    1.817324] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.824450] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:15)
[    1.832532] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.839759] pnp: PnP ACPI: found 11 devices
[    1.843930] ACPI: ACPI bus type pnp unregistered
[    1.886905] pci 0000:01:08.0: BAR 6: assigned [mem 0xd0120000-0xd013ffff pref]
[    1.894103] pci 0000:00:09.0: PCI bridge to [bus 01]
[    1.899054] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    1.905128] pci 0000:00:09.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    1.911895] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdfffffff pref]
[    1.919095] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    1.924044] pci 0000:00:0b.0:   bridge window [mem 0xd0200000-0xd02fffff]
[    1.930810] pci 0000:00:0c.0: PCI bridge to [bus 03]
[    1.935762] pci 0000:00:0d.0: PCI bridge to [bus 04]
[    1.940712] pci 0000:00:0e.0: PCI bridge to [bus 05]
[    1.945668] pci 0000:00:09.0: setting latency timer to 64
[    1.951055] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.956608] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.962163] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.968409] pci_bus 0000:00: resource 7 [mem 0xd0000000-0xfebfffff]
[    1.974656] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed8ffff]
[    1.980903] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    1.986458] pci_bus 0000:01: resource 1 [mem 0xd0100000-0xd01fffff]
[    1.992705] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdfffffff pref]
[    1.999384] pci_bus 0000:02: resource 1 [mem 0xd0200000-0xd02fffff]
[    2.005689] NET: Registered protocol family 2
[    2.010200] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    2.017259] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    2.023713] TCP: Hash tables configured (established 8192 bind 8192)
[    2.030070] TCP: reno registered
[    2.033290] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    2.039197] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    2.045591] NET: Registered protocol family 1
[    2.050070] RPC: Registered named UNIX socket transport module.
[    2.055977] RPC: Registered udp transport module.
[    2.060666] RPC: Registered tcp transport module.
[    2.065355] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.072105] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 23
[    2.077841] IOAPIC[0]: Set routing entry (4-23 -> 0x41 -> IRQ 23 Mode:1 Active:1 Dest:15)
[    2.136803] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
[    2.142548] IOAPIC[0]: Set routing entry (4-22 -> 0x51 -> I    2.156238] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.161741] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.167216] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    2.172778] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.178283] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.183758] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    2.189322] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.194830] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.200305] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    2.205868] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.211384] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.216858] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    2.222421] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.227902] pci 0000:01:08.0: Boot video device
[    2.232426] PCI: CLS 64 bytes, default 64
[    2.236532] Unpacking initramfs...
[    4.437404] Freeing initrd memory: 75520k freed
[    4.472802] Simple Boot Flag at 0x62 set to 0x80
[    4.477567] Machine check injector initialized
[    4.482002] LVT offset 1 assigned for vector 0x400
[    4.486792] Failed to setup IBS LVT offset, IBSCTL = 0xffffffff
[    4.492694] [Firmware Bug]: cpu 3, try to use APIC500 (LVT offset 0) for vector 0x10400, but the register is already in use for vector 0xf9 on another cpu
[    4.506469] [Firmware Bug]: cpu 3, IBS interrupt offset 0 not available (MSRC001103A=0x0000000000000100)
[    4.515916] Failed to setup IBS, -22
[    4.520088] microcode: CPU0: patch_level=0x01000065
[    4.524954] microcode: CPU1: patch_level=0x01000065
[    4.529824] microcode: CPU2: patch_level=0x01000065
[    4.534687] microcode: CPU3: patch_level=0x01000065
[    4.539612] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.548725] audit: initializing netlink socket (disabled)
[    4.554126] type=2000 audit(1356050589.012:1): initialized
[    4.576659] bounce pool size: 64 pages
[    4.580410] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.58719ntries: 1024 (order 0, 4096 bytes)
[    4.597839] NFS: Registering the id_resolver key type
[    4.602887] Key type id_resolver registered
[    4.607057] Key type id_legacy registered
[    4.611062] NTFS driver 2.1.30 [Flags: R/W].
[    4.615408] msgmni has been set to 1687
[    4.619648] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    4.627019] io scheduler noop registered
[    4.630930] io scheduler deadline registered
[    4.635201] io scheduler cfq registered (default)
[    4.640024] pcieport 0000:00:0b.0: irq 40 for MSI/MSI-X
[    4.645316] pcieport 0000:00:0c.0: irq 41 for MSI/MSI-X
[    4.650606] pcieport 0000:00:0d.0: irq 42 for MSI/MSI-X
[    4.655892] pcieport 0000:00:0e.0: irq 43 for MSI/MSI-X
[    4.661251] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.667049] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    4.675203] ACPI: Power Button [PWRB]
[    4.678945] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.686322] ACPI: Power Button [PWRF]
[    4.690142] ACPI: acpi_idle registered with cpuidle
[    4.700690] ERST: Can not request iomem region <0x        cff7f000-0x        cff80000> for ERST.
[    4.716458] GHES: HEST is not enabled!
[    4.720217] EINJ: Error INJection is initialized.
[    4.724910] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    4.753804] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.780588] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.787073] Non-volatile memory driver v1.3
[    4.791335] Lerface v0.103
[    4.796038] [drm] Initialized drm 1.1.0 20060810
[    4.801766] loop: module loaded
[    4.805047] libphy: Fixed MDIO Bus: probed
[    4.809131] tun: Universal TUN/TAP device driver, 1.6
[    4.814165] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.820393] tg3.c:v3.128 (December 03, 2012)
[    4.824946] ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 19
[    4.830684] IOAPIC[0]: Set routing entry (4-19 -> 0xa1 -> IRQ 19 Mode:1 Active:1 Dest:15)
[    4.845473] tg3 0000:02:00.0 eth0: Tigon3 [partno(BCM95722) rev a200] (PCI Express) MAC address 00:1d:09:17:b5:46
[    4.855873644] tg3 0000:02:00.0 eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    4.880600] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.887107] ehci_hcd: block sizes: qh 64 qtd 96 itd 160 sitd 96
[    4.893008] ehci-pci: EHCI PCI platform driver
[    4.897461] ehci-pci 0000:00:02.1: setting latency timer to 64
[    4.903275] ehci-pci 0000:00:02.1: EHCI Host Controller
[    4.908546] ehci-pci 0000:00:02.1: new USB bus registered, assigned bus number 1
[    4.915921] ehci-pci 0000:00:02.1: reset hcs_params 0x10148a dbg=1 cc=1 pcc=4 !ppc ports=10
[    4.924247] ehci-pci 0000:00:02.1: reset portroute 0 0 0 0 0 0 0 0 0 0 
[    4.930840] ehci-pci 0000:00:02.1: reset hcc_params a086 caching frame 256/512/1024 park
[    4.938913] ehci-pci 0000:00:02.1: park 0
[    4.942914] ehci-pci 0000:00:02.1: reset command 0080b32  park=3 ithresh=8 Async Periodic period=1024 Reset HALT
[    4.953054] ehci-pci 0000:00:02.1: debug port 1
[    4.957569] ehci-pci 0000:00:02.1: bogus port configuration: cc=1 x pcc=4 < ports=10
[    4.965289] ehci-pci 0000:00:02.1: cache line size of 64 is not supported
[    4.972053] ehci-pci 0000:00:02.1: supports USB remote wakeup
[    4.977797] ehci-pci 0000:00:02.1: irq 22, io mem 0xd0001000
[    4.983439] ehci-pci 0000:00:02.1: init command 0010005 (park)=0 ithresh=1 period=512 RUN
[    4.997243] ehci-pci 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    5.002995] usb usb1: default language 0x0409
[    5.00734nux 3.7.0upstream-11627-g941108b ehci_hcd
[    5.038141] usb usb1: SerialNumber: 0000:00:02.1
[    5.042843] usb usb1: usb_probe_device
[    5.046584] usb usb1: configuration #1 chosen from 1 choice
[    5.052143] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    5.057927] hub 1-0:1.0: usb_probe_interface
[    5.062188] hub 1-0:1.0: usb_probe_interface - got id
[    5.067225] hub 1-0:1.0: USB hub found
[    5.070965] hub 1-0:1.0: 10 ports detected
[    5.075049] hub 1-0:1.0: standalone hub
[    5.078873] hub 1-0:1.0: no power switching (usb 1.0)
[    5.083908] hub 1-0:1.0: individual port over-current protection
[    5.089894] hub 1-0:1.0: power on to power good time: 20ms
[    5.095365] hub 1-0:1.0: local power source is good
[    5.100261] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    5.107210] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.113370] ohci_hcd: block sizes: ed 64 td 64
[    5.117816] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    5.123629] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    5.128898] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    5.136278] ohci_hcd 0000:00:02.0: created debug files
[    5.141399] ohci_hcd 0000:00:02.0: supports USB remote wakeup
[    5.147142] ohci_hcd 0000:00:02.0: irq 23, io mem 0xd0000000
[    5.205097] ohci_hcd 0000:00:02.0: OHCI controller state
[    5.210394] ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support r:00:02.0: intrstatus 0x00000004 SF
[    5.237034] ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
[    5.243719] ohci_hcd 0000:00:02.0: hcca frame #0029
[    5.248582] ohci_hcd 0000:00:02.0: roothub.a 0100020a POTPGT=1 NPS NDP=10(10)
[    5.255695] ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=0000 DR=0000
[    5.262287] ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
[    5.268192] ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
[    5.274876] ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
[    5.281559] ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
[    5.288243] ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
[    5.294926] ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00000100 PPS
[    5.301609] ohci_hcd 0000:00:02.0: roothub.portstatus [5] 0x00000100 PPS
[    5.308294] ohci_hcd 0000:00:02.0: roothub.portstatus [6] 0x00000100 PPS
[    5.314980] ohci_hcd 0000:00:02.0: roothub.portstatus [7] 0x00000100 PPS
[    5.321662] ohci_hcd 0000:00:02.0: roothub.portstatus [8] 0x00000100 PPS
[    5.328345] ohci_hcd 0000:00:02.0: roothub.portstatus [9] 0x00000100 PPS
[    5.335033] usb usb2: default language 0x0409
[    5.339383] usb usb2: udev 1, busnum 2, minor = 128
[    5.344250] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.351019] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.358221] usb usb2: Product: OHCI Host Controller
[    5.363086] usb usb2: Manufacturer: Linux 3.7.0upstream-11627-g941108b ohci_hcd
[    5.370373] usb usb2: SerialNumber: 0000:00:02.0
[    5.375068] hub 1-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    5.375132] usb usb2: usb_probe_device
[    5.375134] usb usb2: configuration #1 chosen from 1 choice
[    5.375138] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    5.375194] hub 2-0:1.0: usb_probe_interface
[    5.375195] hub 2-0:1.0: usb_probe_interface - got id
[    5.375197] hub 2-0:1.0: USB hub found
[    5.375204] hub 2-0:1.0: 10 ports detected
[    5.375205] hub 2-0:1.0: standalone hub
[    5.375206] hub 2-0:1.0: no power switching (usb 1.0)
[    5.375207] hub 2-0:1.0: global over-current protection
[    5.375208] hub 2-0:1.0: power on to power good time: 2ms
[    5.375212] hub 2-0:1.0: local power source is good
[    5.375213] hub 2-0:1.0: no over-current condition exists
[    5.375245] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    5.375289] ehci-pci 0000:00:02.1: HS companion for 0000:00:02.0
[    5.375343] uhci_hcd: USB Universal Host Controller Interface driver
[    5.461570] usbcore: registered new interface driver usblp
[    5.467234] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    5.475730] hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    5.520848] tsc: Refined TSC clocksource calibration: 2109.722 MHz
[    5.527012] Switching to clocksource tsc
[    5.724995] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.730080] mousedev: PS/2 mouse device common for all mice
[    5.  5.753485] cpuidle: using governor ladder
[    5.757583] cpuidle: using governor menu
[    5.761491] EFI Variables Facility v0.08 2004-May-17
[    5.766487] zram: num_devices not specified. Using default: 1
[    5.772214] zram: Creating 1 devices ...
[    5.776294] zcache: using lzo compressor
[    5.780306] zcache: cleancache enabled using kernel transcendent memory and compression buddies
[    5.788971] zcache: frontswap enabled using kernel transcendent memory and zsmalloc
[    5.796805] Netfilter messages via NETLINK v0.30.
[    5.801508] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.807666] ctnetlink v0.93: registering with nfnetlink.
[    5.813249] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.818602] TCP: cubic registered
[    5.821904] Initializing XFRM netlink socket
[    5.826216] NET: Registered protocol family 10
[    5.830850] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    5.836469] sit: IPv6 over IPv4 tunneling driver
[    5.841292] NET: Registered protocol family 17
[    5.845761] Key type dns_resolver registered
[    5.850436] 
[    5.850436] printing PIC contents
[    5.855212] ... PIC  IMR: ffff
[    5.858258] ... PIC  IRR: 0800
[    5.861306] ... PIC  ISR: 0000
[    5.864351] ... PIC ELCR: 0c00
[    5.867400] printing local APIC contents on CPU#0/0:
[    5.872345] ... APIC ID:      00000000 (0)
[    5.876421] ... APIC VERSION: 80050010
[    5.880151] ... APIC TASKPRI: 00000000 (00)
[    5.884314] ... APIC ARBPRI: 00000000 (00)
[    5.888390] ... APIC PROCPRI: 00000000
[    5.892121] ... APIC LDR: 01000000
[    5.895504] ... APIC DFR: ffffffff
[    5.898888] ... APIC SPIV: 000001ff
[    5.902359] ... APIC ISR field:
[    5.905485] 0000000000000000000000000000000000000000000000000000000000000000
[    5.912560] ... APIC TMR field:
[    5.915686] 0000000000000000000000000000000000000000000000000000000000000000
[    5.922759] ... APIC IRR field:
[    5.925884] 0000000000000000000000000000000000000000000000000000000000000000
[    5.932960] ... APIC ESR: 00000000
[    5.936344] ... APIC ICR: 000008fd
[    5.939725] ... APIC ICR2: 08000000
[    5.943199] ... APIC LVTT: 000000ef
[    5.946665] ... APIC LVTPC: 00000400
[    5.950225] ... APIC LVT0: 00010700
[    5.953693] ... APIC LVT1: 00000400
[    5.957166] ... APIC LVTERR: 000000fe
[    5.960807] ... APIC TMICT: 0021c6bf
[    5.964366] ... APIC TMCCT: 000be686
[    5.967922] ... APIC TDCR: 00000003
[    5.971390] ... APIC EFEAT: 00040007
[    5.974949] ... APIC ECTRL: 00000000
[    5.978504] ... APIC EILVT0: 000000f9
[    5.982144] ... APIC EILVT1: 00010000
[    5.985785] ... APIC EILVT2: 00010000
[    5.989429] ... APIC EILVT3: 00010000
[    5.993075] 
[    5.994558] number of MP IRQ sources: 15.
[    5.998555] number of IO-APIC #4 registers: 24.
[    6.003068] testing the IO APIC.......................
[    6.008191] IO APIC #4......
[    6.011062] .... register #00: 04000000
[    6.014883] .......    : physical APIC id: 04
[    6.019224] .......    : Delivery Type: 0
[    6.023219] .......    : LTS          : 0
[    6.027214] .... register #01: 00170011
[    6.031035] .......     : max redirection entries: 17
[    6.036068] .......     : PRQ implemented: 0
[    6.040322] .......     : IO APIC version: 11
[    6.044663] .... register #02: 04000000
[    6.048485] .......     : arbitration: 04
[    6.052480] .... IRQ redirection table:
[    6.056302]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    6.061768]  00 00  1    0    0   0   0    0    0    00
[    6.066993]  01 0F  0    0    0   0   0    1    1    31
[    6.072217]  02 0F  0    0    0   0   0    1    1    30
[    6.077435]  03 0F  0    0    0   0   0    1    1    33
[    6.082660]  04 0F  0    0    0   0   0    1    1    34
[    6.087884]  05 0F  0    0    0   0   0    1    1    35
[    6.093110]  06 0F  0    0    0   0   0    1    1    36
[    6.098334]  07 0F  1    0    0   0   0    1    1    37
[    6.103557]  08 0F  0    0    0   0   0    1    1    38
[    6.108781]  09 0F  0    1    0   1   0    1    1    39
[    6.114004]  0a 0F  0    0    0   0   0    1    1    3A
[    6.119225]  0b 0F  1    0    0   0   0    1    1    3B
[    6.124447]  0c 0F  1    0    0   0   0    1    1    3C
[    6.129671]  0d 0F  0    0    0   0   0    1    1    3D
[    6.134894]  0e 0F  0    0    0   0   0    1    1    3E
[    6.140118]  0f 0F  0    0    0   0   0    1    1    3F
[    6.145341]  10 00  1    0    0   0   0    0    0    00
[    6.150569]  11 00  1    0    0   0   0    0    0    00
[    6.155792]  12 00  1    0    0   0   0    0    0    00
[    6.161017]  13 0F  1    1    0   1   0    1    1    A1
[    6.166239]  14 00  1    0    0   0   0    0    0    00
[    6.171462]  15 00  1    0    0   0   0    0    0    00
[    6.176686]  16 0F  0    1    0   1   0    1    1    51
[    6.181910]  17 0F  0    1    0   1   0    1    1    41
[    6.187131] IRQ to pin mappings:
[    6.190344] IRQ0 -> 0:2
[    6.192809] IRQ1 -> 0:1
[    6.195267] IRQ3 -> 0:3
[    6.197733] IRQ4 -> 0:4
[    6.200196] IRQ5 -> 0:5
[    6.202661] IRQ6 -> 0:6
[    6.205124] IRQ7 -> 0:7
[    6.207583] IRQ8 -> 0:8
[    6.210046] IRQ9 -> 0:9
[    6.212511] IRQ10 -> 0:10
[    6.215149] IRQ11 -> 0:11
[    6.217783] IRQ12 -> 0:12
[    6.220423] IRQ13 -> 0:13
[    6.223061] IRQ14 -> 0:14
[    6.225700] IRQ15 -> 0:15
[    6.228333] IRQ19 -> 0:19
[    6.230966] IRQ22 -> 0:22
[    6.233606] IRQ23 -> 0:23
[    6.236247] .................................... done.
[    6.241366] Using IPI No-Shortcut mode
[    6.245254] PM: Hibernation image not present or could not be loaded.
[    6.251684] registered taskstats version 1
[    6.256348]   Magic number: 8:296:709
[    6.260459] Freeing unused kernel memory: 536k freed
[    6.265691] Write protecting the kernel text: 5692k
[    6.270601] Write protecting the kernel read-only data: 1544k
[    6.276329] NX-protecting the kernel data: 2500k
init started: BusyBox v1.14.3 ([    6.284176] consoletype (1194) used greatest stack depth: 6864 bytes left
2012-12-20 18:37:31 EST)
Mounting directories  [  OK  ]
[    6.443774] mv (1208) used greatest stack depth: 6556 bytes left
mount: mount point /proc/bus/usb does not exist
mount: moufig does not exist
^G^G^G^G^G^G[    6.475107] udevd (1230): /proc/1230/oom_adj is deprecated, please use /proc/1230/oom_score_adj instead.
cat: /sys/hypervisor/type: No such file or directory
/usr/bin/load_xen_modules: line 3: [: ==: unary operator expected
^G^G^G^[    6.495147] modprobe (1316) used greatest stack depth: 6400 bytes left
G^G^G^G^G^G^G^G^G[    6.509545] SCSI subsystem initialized
[    6.524091] ACPI: bus type scsi registered
[    6.528236] [drm] radeon defaulting to kernel modesetting.
[    6.528461] ude6.551293] kvm: Nested Virtualization enabled
[    6.551583] ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 18
[    6.551595] IOAPIC[0]: Set routing entry (4-18 -> 0xb1 -> IRQ 18 Mode:1 Active:1 Dest:15)
[    6.563921] udevd (1256) used greatest stack depth: 6092 bytes left
[    6.565185] [drm] initializing kernel modesetting (RV100 0x1002:0x515E 0x1028:0x0225).
[    6.565207] [drm] register mmio base: 0xD0100000
: error opening [    6.565208] [drm] register mmio size: 65536
[    6.565321] radeon 0000:01:08.0: VRAM: 128M 0x00000000D8000000 - 0x00000000DFFFFFFF (32M used)
[    6.565324] radeon 0000:01:08.0: GTT: 512M 0x00000000B8000000 - 0x00000000D7FFFFFF
[    6.565330] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
ATTR{/sys/device[    6.565330] [drm] Driver supports precise vblank timestamp query.
[    6.565353] [drm] radeon: irq initialized.
s/system/cpu/cpu0/online} for wr[    6.629374] kvm: Nested Paging enabled
iting: No such f[    6.634983] libata version 3.00 loaded.
ile or directory[    6.642066] [drm] Detected VRAM RAM=128M, BAR=128M


^G^G^G^G^G^[    6.648108] [drm] RAM width 16bits DDR
G^G^G^G^G^G^G^G^[    6.653292] sata_nv 0000:00:07.0: version 3.5
[    6.653330] [TTM] Zone  kernel: Available graphics memory: 432294 kiB
[    6.653331] [TTM] Zone highmem: Available graphics memory: 2072170 kiB
G^G^G^G^G^G^G^G^[    6.653332] [TTM] Initializing pool allocator
[    6.653337] [TTM] Initializing DMA pool allocator
G^G^G^G^G^G^G^G^[    6.653366] [drm] radeon: 32M of VRAM memory ready
[    6.653367] [drm] radeon: 512M of GTT memory ready.
[    6.653385] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    6.682641] [drm] PCI GART of 512M enabled (table at 0x0000000036E80000).
[    6.682670] radeon 0000:01:08.0: WB disabled
[    6.682674] radeon 0000:01:08.0: fence driver on ring 0 use gpu addr 0x00000000b8000000 and cpu addr 0xf7440000
[    6.683676] [drm] Loading R100 Microcode
[    6.683994] [drm] radeon: ring at 0x00000000B8001000
G^G^G^G^G^G^G[    6.684017] [drm] ring test succeeded in 1 usecs
[    6.684180] [drm] ib test succeeded in 0 usecs
[    6.739816] ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
[    6.740942] [drm] Radeon Display Connectors
[    6.740943] [drm] Connector 0:
[    6.740944] [drm]   VGA-1
[    6.740946] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[    6.740947] [drm]   Encoders:
[    6.740947] [drm]     CRT1: INTERNAL_DAC1
Waiting for devi[    6.768261] IOAPIC[0]: Set routing entry (4-21 -> 0xc1 -> IRQ 21 Mode:1 Active:1 Dest:15)
ces [    6.768310] sata_nv 0000:00:07.0: setting latency timer to 64
[    6.768701] scsi0 : sata_nv
[[    6.777995] scsi1 : sata_nv
[    6.778174] ata1: SATA max UDMA/133 cmd 0x20f0 ctl 0x20e0 bmdma 0x20b0 irq 21
[    6.778175] ata2: SATA max UDMA/133 cmd 0x20d0 ctl 0x20c0 bmdma 0x20b8 irq 21
  OK  [    6.778505] ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 20
[    6.778512] IOAPIC[0]: Set routing entry (4-20 -> 0xd1 -> IRQ 20 Mode:1 Active:1 Dest:15)
[    6.778547] sata_nv 0000:00:08.0: setting latency timer to 64
][    6.778911] scsi2 : sata_nv
[    6.779104] scsi3 : sata_nv
[    6.779278] ata3: SATA max UDMA/133 cmd 0x2440 ctl 0x2430 bmdma 0x2400 irq 20
[    6.779279] ata4: SATA max UDMA/133 cmd 0x2420 ctl 0x2410 bmdma 0x2408 irq 20
[    6.782315] radeon 0000:01:08.0: No connectors reported connected with modes
[    6.782318] [drm] Cannot find any crtc or sizes - going 1024x768
[    6.792549] [drm] fb mappable at 0xD8040000

[    6.792550] [drm] vram apper at 0xD8000000
[    6.792551] [drm] size 786432
[    6.792551] [drm] fb depth is 8
[    6.792552] [drm]    pitch is 1024
[    6.792796] fbcon: radeondrmfb (fb0) is primary device
[    6.810969] ip (2424) used greatest stack depth: 5816 bytes left
[    6.894537] Console: switching to colour frame buffer device 128x48
[    6.908176] radeon 0000:01:08.0: fb0: radeondrmfb frame buffer device
[    6.908178] radeon 0000:01:08.0: registered panic notifier
[    6.908185] [drm] Initialized radeon 2.27.0 20080528 for 0000:01:08.0 on minor 0
[    7.231552] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.237750] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    7.246717] ata3.00: ATAPI: HL-DT-STDVD-ROM GDRH20N, 0D04, max UDMA/100
[    7.253710] ata1.00: ATA-7: WDC WD800AAJS-18TDA1, 01.00A04, max UDMA/133
[    7.258769] ata3.00: configured for UDMA/100
[    7.264639] ata1.00: 156250000 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    7.271417] ata1.00: failed to get Identify Device Data, Emask 0x1
[    7.281006] ata1.00: failed to get Identify Device Data, Emask 0x1
[    7.287167] ata1.00: configured for UDMA/133
[    7.291578] scsi 0:0:0:0: Direct-Access     ATA      WDC WD800AAJS-18 01.0 PQ: 0 ANSI: 5
[    7.300087] ACPI: Invalid Power Resource to register!
[    7.607238] ata2: SATA link down (SStatus 0 SControl 300)
[    7.614229] scsi 2:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GDG^G^G^G^G^G^G^G[    7.929991] ata4: SATA link down (SStatus 0 SControl 300)
[    7.935701] modprobe (1369) used greatest stack depth: 5796 bytes left
[    7.942216] modprobe (1377) used greatest stack depth: 5564 bytes left
[    7.948996] sd 0:0:0:0: [sda] 156250000 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    7.956760] sd 0:0:0:0: [sda] Write Protect is off
[    7.958305] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[    7.958307] cdrom: Uniform CD-ROM driver Revision: 3.20
[    7.958553] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    7.977494] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.982573] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.999372]  sda: sda1 sda2
[    8.002509] sd 0:0:0:0: [sda] Attached SCSI disk
[    8.009181] sd 0:0:0:0: Attached scsi ge^G^G^GWaiting for fb [  OK  ]
Waiting for network [  OK  ]
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth0:  [    8.282485] tg3 0000:02:00.0: irq 44 for MSI/MSI-X
[    8.330727] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    8.336646] ip (2630) used greatest stack depth: 5460 byte
^G^G^G^G^G^G^G^G^G^GBringing up interface switch:  
Determining IP information for s[    8.385903] IPv6: ADDRCONF(NETDEV_UP): switch: link is not ready
witch...[   11.057566] tg3 0000:02:00.0 eth0: Link is up at 1000 Mbps, full duplex
[   11.064158] tg3 0000:02:00.0 eth0: Flow control i TX and on for RX
[   11.071035] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   11.077315] switch: port 1(eth0) entered forwarding state
[   11.082698] switch: port 1(eth0) entered forwarding state
^G^G[   11.088137] IPv6: ADDRCONF(NETDEV_CHANGE): switch: link becomes ready
 done.
[  OK  ]
Waiting for init.custom [  OK  ]

Starting SSHd ...

    SSH started [2813]


Waiting for SSHd [  OK  ]
WARNING: ssh currently running [2813] ignoring start request
FATAL: Module dump_dma not found.
ERROR: Module dump_dma does not exist in /proc/modules
[   12.609475] Loading iSCSI transport class v2.0-870.
[   12.616706] iscsi: registered transport (tcp)
Could not read fw values.
Dec 21 00:43:18 tst001 syslogd 1.5.0: restart.
You might have to do kill -1 1 if you see 'can't open /dev/hvc0'
[0:0:0:0]    disk    ATA      WDC WD800AAJS-18 01.0  /dev/sda 
[2:0:0:0]    cd/dvd  HL-DT-ST DVD-ROM GDRH20N  0D04  /dev/sr0 
00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a4)
00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev f1)
00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a4)
00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev f2)
00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Link Control
01:08.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5722 Gigabit Ethernet PCI Express
           CPU0       CPU1       CPU2       CPU3       
  0:        179          0          0          0   IO-APIC-edge      timer
  1:          1          0          2          0   IO-APIC-edge      i8042
  4:          0          0          7        166   IO-APIC-edge      serial
  7:          1          0          0          0   IO-APIC-edge    
  8:          0          0          4          4   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 18:          0          0          0          2   IO-APIC-fasteoi   radeon
 20:          0          0          2        103   IO-APIC-fasteoi   sata_nv
 21:          0          0          0          6   IO-APIC-fasteoi   sata_nv
 22:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
 23:          0          0          0          0   IO-APIC-fasteoi   ohci_hcd:usb2
 44:          0          0          0         66   PCI-MSI-edge      eth0
NMI:          0          0          0          0   Non-maskable interrupts
LOC:       3509       3294       2795       4702   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RTR:          0          0          0          0   APIC ICR read retries
RES:       4729       2929       1867       2326   Rescheduling interrupts
CAL:        245        224        223        195   Function call interrupts
TLB:        237        206        193        225   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          1          1          1          1   Machine check polls
ERR:          1
MIS:          0
00000000-0000ffff : reserved
00010000-0009d7ff : System RAM
0009d800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
  000a0000-000bffff : Video RAM area
000c0000-000c8fff : Video ROM
000c9000-000cadff : Adapter ROM
000cc000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-7ffeffff : System RAM
  01000000-0158eebc : Kernel code
  0158eebd-0176a17f : Kernel data
  017f7000-018a0fff : Kernel bss
7fff0000-7fffffff : reserved
80000000-cfeeffff : System RAM
cfef0000-cfef4fff : ACPI Tables
cfef5000-cff7efff : ACPI Non-vola[   13.075809] mount.nfs (2904) used greatest stack depth: 5424 bytes left
tile Storage
cff7f000-cff7ffff : RAM buffer
cff80000-cfffffff : reserved
d0000000-febfffff : PCI Bus 0000:00
  d0000000-d0000fff : 0000:00:02.0
    d0000000-d0000fff : ohci_hcd
  d0001000-d00010ff : 0000:00:02.1
    d0001000-d00010ff : ehci_hcd
  d0002000-d0002fff : 0000:00:07.0
    d0002000-d0002fff : sata_nv
  d0003000-d0003fff : 0000:00:08.0
    d0003000-d0003fff : sata_nv
  d0100000-d01fffff : PCI Bus 0000:01
    d0100000-d010ffff : 0000:01:08.0
    d0120000-d013ffff : 0000:01:08.0
  d0200000-d02fffff : PCI Bus 0000:02
    d0200000-d020ffff : 0000:02:00.0
      d0200000-d020ffff : tg3
  d8000000-dfffffff : PCI Bus 0000:01
    d8000000-dfffffff : 0000:01:08.0
  e0000000-efffffff : reserved
    e0000000-efffffff : pnp 00:01
      e0000000-e04fffff : PCI MMCONFIG 0000 [bus 00-04]
fec00000-fec0ffff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed00fff : pnp 00:00
  fed00000-fed003ff : HPET 0
fed40000-fed8ffff : PCI Bus 0000:00
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
fff80000-ffffffff : reserved
100000000-12fffffff : System RAM
MemTotal:        4144340 kB
MemFree:         3866732 kB
Buffers:               0 kB
Cached:           245684 kB
SwapCached:            0 kB
Active:            18492 kB
Inactive:         228496 kB
Active(anon):      11716 kB
Inactive(anon):    94500 kB
Active(file):       6776 kB
Inactive(file):   133996 kB
Unevictable:        2664 kB
Mlocked:            2664 kB
HighTotal:       3279752 kB
HighFree:        3024832 kB
LowTotal:         864588 kB
LowFree:          841900 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:          3476 kB
Mapped:             3312 kB
Shmem:            103284 kB
Slab:              15792 kB
SReclaimable:       7324 kB
SUnreclaim:         8468 kB
KernelStack:         616 kB
PageTables:          460 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     2072168 kB
Committed_AS:     110752 kB
Vmalloc[   13.263814] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
Total:     12288[   13.273700] device-mapper: multipath: version 1.5.0 loaded
0 kB
VmallocUsed:        6792 kB
VmallocChunk:     114440 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        8184 kB
DirectMap2M:      905216 kB
Waiting for init.late [  OK  ]
PING build.dumpdata.com (192.168.101.3) 56(84) bytes of data.

--- build.dumpdata.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 1ms
rtt min/avg/max/mdev = 0.483/0.483/0.483/0.000 ms
NFS done
libxl: error: libxl.c:56:libxl_ctx_init Is xenstore daemon running?
failed to stat /var/run/xenstored.pid: No such file or directory
cannot init xl context
192.168.101.2:3260,1 iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb
Logging in to [iface: default, target: iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb, portal: 192.168.101.2,3260]
[   13.537353] scsi4 : iSCSI Initiator over TCP/IP
Dec 21 00:43:19 tst001 iscsid: transport class version 2.0-870. iscsid version 2.0-870
Dec 21 00:43:19 tst001 iscsid: iSCSI da^G[   13.793957] scsi 4:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
[   13.802486] sd 4:0:0:0: Attached:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   13.821241]  sdb: unknown partition table
[   13.824235] sd 4:0:0:0: [sdb] Attached SCSI disk
[   13.843001] ttyS0: 1 input overrun(s)
^GLogin to [iface: default, target: iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb, portal: 192.168.101.2,3260]: successful
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^GDec 21 00:43:20 tst001 iscsid: connection1:0 is operational now
