Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab0LQUeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:34:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab0LQUek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:34:40 -0500
Date: Fri, 17 Dec 2010 15:34:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
Message-ID: <20101217203405.GH14502@redhat.com>
References: <20101217170146.GC9568@redhat.com>
 <4D0BA45A.7020402@zytor.com>
 <20101217180242.GB12425@redhat.com>
 <4D0BAA24.3080801@kernel.org>
 <4D0BBC55.4010207@zytor.com>
 <4D0BBE00.3010602@kernel.org>
 <20101217195035.GE14502@redhat.com>
 <4D0BBF6B.4060105@kernel.org>
 <20101217200139.GF14502@redhat.com>
 <4D0BC2BF.5010400@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0BC2BF.5010400@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 12:06:23PM -0800, Yinghai Lu wrote:
> On 12/17/2010 12:01 PM, Vivek Goyal wrote:
> > On Fri, Dec 17, 2010 at 11:52:11AM -0800, Yinghai Lu wrote:
> >> On 12/17/2010 11:50 AM, Vivek Goyal wrote:
> >>> On Fri, Dec 17, 2010 at 11:46:08AM -0800, Yinghai Lu wrote:
> >>>> On 12/17/2010 11:39 AM, H. Peter Anvin wrote:
> >>>>> On 12/17/2010 10:21 AM, Yinghai Lu wrote:
> >>>>>>>>
> >>>>>>>> Do we have actual testing for how high the 64-bit kernel will load?
> >>>>>>>
> >>>>>>> I will do some experiments on my box today and let you know.
> >>>>>>
> >>>>>> if bzImage is used, it is 896M.
> >>>>>>
> >>>>>
> >>>>> Why?  896 MiB is a 32-bit kernel limitation which doesn't have anything
> >>>>> to do with the bzImage format.
> >>>>>
> >>>>> So unless there is something going on here, I suspect you're just plain
> >>>>> flat wrong.
> >>>>
> >>>> kexec-tools have some checking when it loads bzImage.
> >>>>
> >>>
> >>> Yinghai,
> >>>
> >>> I think x86_64 might have just inherited the settings of 32bit without
> >>> giving it too much of thought. At that point of time nobody bothered
> >>> to load the kernel from high addresses. So these might be artificial
> >>> limits.
> >>
> >> good point.  will check that.
> > 
> > Yinghai,
> > 
> > On x86_64, I am not seeing "Crash kernel" entry in /proc/iomem.
> > 
> > I see following in dmesg.
> > 
> > "[    0.000000] Reserving 128MB of memory at 64MB for crashkernel (System
> > RAM: 5120MB)"
> > 
> > Following is my /proc/iomem.
> > 
> > # cat /proc/iomem 
> > 00000100-0000ffff : reserved
> > 00010000-00096fff : System RAM
> > 00097000-0009ffff : reserved
> > 000c0000-000e7fff : pnp 00:0f
> > 000e8000-000fffff : reserved
> > 00100000-bffc283f : System RAM
> >   01000000-015d1378 : Kernel code
> >   015d1379-01aee00f : Kernel data
> >   01bc8000-024b4c4f : Kernel bss
> > bffc2840-bfffffff : reserved
> > 
> > So there is RAM available at the requested address still no entry for
> > "Crash Kernel". This is both with 2.6.36 as well as 37-rc6 kernel. I am 
> > wondering if insert_resource() is failing here?
> > 
> 
> also could be memblock_x86_reserve() fail ...
> 
> Please check attached debug patch...
> 

looks like memblock_x86_reserve() is fine. Following is dmesg output with
your debug patches applied.


[    0.000000]     memblock_x86_reserve_range: [0x01000000-0x024bcb77]    TEXT DATA BSS
[    0.000000]     memblock_x86_reserve_range: [0x7fafb000-0x7fff3fff]          RAMDISK
[    0.000000]     memblock_x86_reserve_range: [0x00097000-0x000fffff]  * BIOS reserved
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37-rc6+ (root@chilli.lab.bos.redhat.com) (gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) (GCC) ) #73 SMP Fri Dec 17 15:24:34 EST 2010
[    0.000000] Command line: ro root=/dev/mapper/vg_chilli-lv_root rd_LVM_LV=vg_chilli/lv_root rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us console=tty0, console=ttyS0,115200n8 selinux=0 crashkernel=128M@64M kexec_jump_back_entry=0x6148206465520a0f
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000100 - 0000000000097000 (usable)
[    0.000000]  BIOS-e820: 0000000000097000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffc2840 (usable)
[    0.000000]  BIOS-e820: 00000000bffc2840 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.5 present.
[    0.000000] DMI: 0A9Ch/HP xw6600 Workstation, BIOS 786F4 v00.32 09/18/2007
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x140000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-E7FFF write-protect
[    0.000000]   E8000-EFFFF write-back
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 2000000000 write-back
[    0.000000]   1 base 2000000000 mask 2000000000 write-back
[    0.000000]   2 base 0140000000 mask 3FE0000000 uncachable
[    0.000000]   3 base 00C0000000 mask 3FC0000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000140000000 - 0000000160000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbffc2 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fe700] fe700
[    0.000000]     memblock_x86_reserve_range: [0x000fe700-0x000fe70f]   * MP-table mpf
[    0.000000]     memblock_x86_reserve_range: [0x000efbd0-0x000efeb3]   * MP-table mpc
[    0.000000]     memblock_x86_reserve_range: [0x024bd000-0x024bd127]              BRK
[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0xfff49840
[    0.000000]  memory.cnt  = 0x3
[    0.000000]  memory[0x0]	[0x00000000010000-0x00000000096fff], 0x87000 bytes
[    0.000000]  memory[0x1]	[0x00000000100000-0x000000bffc283f], 0xbfec2840 bytes
[    0.000000]  memory[0x2]	[0x00000100000000-0x0000013fffffff], 0x40000000 bytes
[    0.000000]  reserved.cnt  = 0x6
[    0.000000]  reserved[0x0]	[0x00000000097000-0x000000000fffff], 0x69000 bytes
[    0.000000]  reserved[0x1]	[0x000000000efbd0-0x000000000efeb3], 0x2e4 bytes
[    0.000000]  reserved[0x2]	[0x000000000fe700-0x000000000fe70f], 0x10 bytes
[    0.000000]  reserved[0x3]	[0x00000001000000-0x000000024bcb77], 0x14bcb78 bytes
[    0.000000]  reserved[0x4]	[0x000000024bd000-0x000000024bd127], 0x128 bytes
[    0.000000]  reserved[0x5]	[0x0000007fafb000-0x0000007fff3fff], 0x4f9000 bytes
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000]     memblock_x86_reserve_range: [0x00095000-0x00096fff]       TRAMPOLINE
[    0.000000]     memblock_x86_reserve_range: [0x00091000-0x00094fff]      ACPI WAKEUP
[    0.000000] init_memory_mapping: 0000000000000000-00000000bffc2000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bffc2000 page 4k
[    0.000000] kernel direct mapping tables up to bffc2000 @ 1fffb000-20000000
[    0.000000]     memblock_x86_reserve_range: [0x1fffb000-0x1fffdfff]          PGTABLE
[    0.000000] init_memory_mapping: 0000000100000000-0000000140000000
[    0.000000]  0100000000 - 0140000000 page 2M
[    0.000000] kernel direct mapping tables up to 140000000 @ bffbc000-bffc2000
[    0.000000]     memblock_x86_reserve_range: [0xbffbc000-0xbffbcfff]          PGTABLE
[    0.000000] RAMDISK: 7fafb000 - 7fff4000
[    0.000000]     memblock_x86_reserve_range: [0x04000000-0x0bffffff]     CRASH KERNEL
[    0.000000] Reserving 128MB of memory at 64MB for crashkernel (System RAM: 5120MB)
[    0.000000] ACPI: RSDP 00000000000e9810 00024 (v02 HPQOEM)
[    0.000000] ACPI: XSDT 00000000bffc52ec 0006C (v01 HPQOEM SLIC-WKS 20070918      00000000)
[    0.000000] ACPI: FACP 00000000bffc5494 000F4 (v03 HPQOEM SEABURG  00000001      00000000)
[    0.000000] ACPI Error: 32/64X address mismatch in Gpe0Block: 0x0000F828/0x000000000001F030, using 32 (20101013/tbfadt-427)
[    0.000000] ACPI: DSDT 00000000bffc5a6e 02697 (v01 HPQOEM     DSDT 00000001 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000bffc5200 00040
[    0.000000] ACPI: SSDT 00000000bffc8105 06A92 (v01 HPQOEM  PROJECT 00000001 MSFT 0100000E)
[    0.000000] ACPI: APIC 00000000bffc5588 000C8 (v01 HPQOEM SEABURG  00000001      00000000)
[    0.000000] ACPI: ASF! 00000000bffc5650 0006A (v32 HPQOEM SEABURG  00000001      00000000)
[    0.000000] ACPI: MCFG 00000000bffc5852 0003C (v01 HPQOEM SEABURG  00000001      00000000)
[    0.000000] ACPI: SLIC 00000000bffc588e 00176 (v01 HPQOEM SLIC-WKS 00000001      00000000)
[    0.000000] ACPI: HPET 00000000bffc5a04 00038 (v01 HPQOEM SEABURG  00000001      00000000)
[    0.000000] ACPI: TCPA 00000000bffc5a3c 00032 (v01 HPQOEM SEABURG  00000001      00000000)
[    0.000000] ACPI: DMAR 00000000bffc56ba 00108 (v01 HPQOEM SEABURG  00000001      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000140000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000140000000
[    0.000000]     memblock_x86_reserve_range: [0x13fffb000-0x13fffffff]        NODE_DATA
[    0.000000]   NODE_DATA [000000013fffb000 - 000000013fffffff]
[    0.000000]     memblock_x86_reserve_range: [0xbffc1000-0xbffc1fff]   sparse section
[    0.000000]     memblock_x86_reserve_range: [0xbfbbc000-0xbffbbfff]       usemap_map
[    0.000000]     memblock_x86_reserve_range: [0xbffc0d00-0xbffc0fff]          usermap
[    0.000000]     memblock_x86_reserve_range: [0xbf7bc000-0xbfbbbfff]          map_map
[    0.000000]     memblock_x86_reserve_range: [0x13be00000-0x13fdfffff]      vmemmap buf
[    0.000000]     memblock_x86_reserve_range: [0x13fffa000-0x13fffafff]    vmemmap block
[    0.000000]     memblock_x86_reserve_range: [0x13fff9000-0x13fff9fff]    vmemmap block
[    0.000000]        memblock_x86_free_range: [0x13f600000-0x13fdfffff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff88013be00000-ffff88013f5fffff] on node 0
[    0.000000]        memblock_x86_free_range: [0xbf7bc000-0xbfbbbfff]
[    0.000000]        memblock_x86_free_range: [0xbfbbc000-0xbffbbfff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00140000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000097
[    0.000000]     0: 0x00000100 -> 0x000bffc2
[    0.000000]     0: 0x00100000 -> 0x00140000
[    0.000000] On node 0 totalpages: 1048393
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]     memblock_x86_reserve_range: [0xbffc0880-0xbffc0cff]            pgdat
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 767994 pages, LIFO batch:31
[    0.000000]     memblock_x86_reserve_range: [0xbff74000-0xbffbbfff]            pgdat
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 258560 pages, LIFO batch:31
[    0.000000]     memblock_x86_reserve_range: [0xbff62000-0xbff73fff]            pgdat
[    0.000000]     memblock_x86_reserve_range: [0xbffbf000-0xbffbffff]          pgtable
[    0.000000] ACPI: PM-Timer IO Port: 0xf808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec89000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec89000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000]     memblock_x86_reserve_range: [0xbffc0800-0xbffc0840]         hpet res
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000]     memblock_x86_reserve_range: [0xbffc0740-0xbffc07c5]       ioapic res
[    0.000000] nr_irqs_gsi: 64
[    0.000000]     memblock_x86_reserve_range: [0xbffc0540-0xbffc0737]   e820 resources
[    0.000000]     memblock_x86_reserve_range: [0xbffc04c0-0xbffc0527]     firmware map
[    0.000000]     memblock_x86_reserve_range: [0xbffc0440-0xbffc04a7]     firmware map
[    0.000000]     memblock_x86_reserve_range: [0xbffc03c0-0xbffc0427]     firmware map
[    0.000000]     memblock_x86_reserve_range: [0xbffc0340-0xbffc03a7]     firmware map
[    0.000000]     memblock_x86_reserve_range: [0xbffc02c0-0xbffc0327]     firmware map
[    0.000000]     memblock_x86_reserve_range: [0xbffc0240-0xbffc02a7]     firmware map
[    0.000000]     memblock_x86_reserve_range: [0xbffc01c0-0xbffc0227]     firmware map
[    0.000000]     memblock_x86_reserve_range: [0xbffc0140-0xbffc01a7]     firmware map
[    0.000000]     memblock_x86_reserve_range: [0xbffc0100-0xbffc011f]    nosave region
[    0.000000] PM: Registered nosave memory: 0000000000097000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
[    0.000000] PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
[    0.000000]     memblock_x86_reserve_range: [0xbffc00c0-0xbffc00df]    nosave region
[    0.000000] PM: Registered nosave memory: 00000000bffc2000 - 00000000bffc3000
[    0.000000] PM: Registered nosave memory: 00000000bffc3000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000]     memblock_x86_reserve_range: [0xbffbeec0-0xbffbefd2]  saved_command_l
[    0.000000]     memblock_x86_reserve_range: [0xbffbed80-0xbffbee92]  static_command_
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000]     memblock_x86_reserve_range: [0xbffbdd80-0xbffbed7f]  pcpu_alloc_info
[    0.000000]     memblock_x86_reserve_range: [0xbff61000-0xbff61fff]        pcpu area
[    0.000000]     memblock_x86_reserve_range: [0xbfc00000-0xbfdfffff]       pcpu_alloc
[    0.000000]        memblock_x86_free_range: [0xbfc1a000-0xbfc3ffff]
[    0.000000]        memblock_x86_free_range: [0xbfc5a000-0xbfc7ffff]
[    0.000000]        memblock_x86_free_range: [0xbfc9a000-0xbfcbffff]
[    0.000000]        memblock_x86_free_range: [0xbfcda000-0xbfcfffff]
[    0.000000]        memblock_x86_free_range: [0xbfd1a000-0xbfd3ffff]
[    0.000000]        memblock_x86_free_range: [0xbfd5a000-0xbfd7ffff]
[    0.000000]        memblock_x86_free_range: [0xbfd9a000-0xbfdbffff]
[    0.000000]        memblock_x86_free_range: [0xbfdda000-0xbfdfffff]
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff8800bfc00000 s77248 r8192 d21056 u262144
[    0.000000]     memblock_x86_reserve_range: [0xbffc0080-0xbffc0087]  pcpu group_offs
[    0.000000]     memblock_x86_reserve_range: [0xbffc0040-0xbffc0047]  pcpu group_size
[    0.000000]     memblock_x86_reserve_range: [0xbffc0000-0xbffc001f]    pcpu unit_map
[    0.000000]     memblock_x86_reserve_range: [0xbffbdd40-0xbffbdd7f]    pcpu unit_off
[    0.000000] pcpu-alloc: s77248 r8192 d21056 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000]     memblock_x86_reserve_range: [0xbffbdc00-0xbffbdd1f]        pcpu slot
[    0.000000]     memblock_x86_reserve_range: [0xbffbdb80-0xbffbdbc7]  pcpu chunk_stru
[    0.000000]     memblock_x86_reserve_range: [0xbffbdb00-0xbffbdb47]  pcpu chunk_stru
[    0.000000]        memblock_x86_free_range: [0xbffbdd80-0xbffbed7f]
[    0.000000]        memblock_x86_free_range: [0xbff61000-0xbff61fff]
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1030467
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: ro root=/dev/mapper/vg_chilli-lv_root rd_LVM_LV=vg_chilli/lv_root rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us console=tty0, console=ttyS0,115200n8 selinux=0 crashkernel=128M@64M kexec_jump_back_entry=0x6148206465520a0f
[    0.000000]     memblock_x86_reserve_range: [0xbff5a000-0xbff61fff]  large system ha
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000]     memblock_x86_reserve_range: [0xbbc00000-0xbfbfffff]   swiotlb buffer
[    0.000000]     memblock_x86_reserve_range: [0xbff3a000-0xbff59fff]     swiotlb list
[    0.000000]     memblock_x86_reserve_range: [0xbfefa000-0xbff39fff]  swiotlb orig_ad
[    0.000000]     memblock_x86_reserve_range: [0x00089000-0x00090fff]  swiotlb overflo
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Subtract (42 early reservations)
[    0.000000]   [0000089000-00000fffff]
[    0.000000]   [00000efbd0-00000efeb3]
[    0.000000]   [00000fe700-00000fe70f]
[    0.000000]   [0001000000-00024bcb77]
[    0.000000]   [00024bd000-00024bd127]
[    0.000000]   [0004000000-000bffffff]
[    0.000000]   [001fffb000-001fffdfff]
[    0.000000]   [007fafb000-007fff3fff]
[    0.000000]   [00bbc00000-00bfc19fff]
[    0.000000]   [00bfc40000-00bfc59fff]
[    0.000000]   [00bfc80000-00bfc99fff]
[    0.000000]   [00bfcc0000-00bfcd9fff]
[    0.000000]   [00bfd00000-00bfd19fff]
[    0.000000]   [00bfd40000-00bfd59fff]
[    0.000000]   [00bfd80000-00bfd99fff]
[    0.000000]   [00bfdc0000-00bfdd9fff]
[    0.000000]   [00bfefa000-00bffbcfff]
[    0.000000]   [00bffbdb00-00bffbdb47]
[    0.000000]   [00bffbdb80-00bffbdbc7]
[    0.000000]   [00bffbdc00-00bffbdd1f]
[    0.000000]   [00bffbdd40-00bffbdd7f]
[    0.000000]   [00bffbed80-00bffbee92]
[    0.000000]   [00bffbeec0-00bffbefd2]
[    0.000000]   [00bffbf000-00bffc001f]
[    0.000000]   [00bffc0040-00bffc0047]
[    0.000000]   [00bffc0080-00bffc0087]
[    0.000000]   [00bffc00c0-00bffc00df]
[    0.000000]   [00bffc0100-00bffc011f]
[    0.000000]   [00bffc0140-00bffc01a7]
[    0.000000]   [00bffc01c0-00bffc0227]
[    0.000000]   [00bffc0240-00bffc02a7]
[    0.000000]   [00bffc02c0-00bffc0327]
[    0.000000]   [00bffc0340-00bffc03a7]
[    0.000000]   [00bffc03c0-00bffc0427]
[    0.000000]   [00bffc0440-00bffc04a7]
[    0.000000]   [00bffc04c0-00bffc0527]
[    0.000000]   [00bffc0540-00bffc0737]
[    0.000000]   [00bffc0740-00bffc07c5]
[    0.000000]   [00bffc0800-00bffc0840]
[    0.000000]   [00bffc0880-00bffc1fff]
[    0.000000]   [013be00000-013f5fffff]
[    0.000000]   [013fff9000-013fffffff]
[    0.000000] (16 free memory ranges)
[    0.000000]        [0x00010000-0x00088fff]
[    0.000000]        [0x00100000-0x00ffffff]
[    0.000000]        [0x024be000-0x03ffffff]
[    0.000000]        [0x0c000000-0x1fffafff]
[    0.000000]        [0x1fffe000-0x7fafafff]
[    0.000000]        [0x7fff4000-0xbbbfffff]
[    0.000000]        [0xbfc1a000-0xbfc3ffff]
[    0.000000]        [0xbfc5a000-0xbfc7ffff]
[    0.000000]        [0xbfc9a000-0xbfcbffff]
[    0.000000]        [0xbfcda000-0xbfcfffff]
[    0.000000]        [0xbfd1a000-0xbfd3ffff]
[    0.000000]        [0xbfd5a000-0xbfd7ffff]
[    0.000000]        [0xbfd9a000-0xbfdbffff]
[    0.000000]        [0xbfdda000-0xbfef9fff]
[    0.000000]        [0x100000000-0x13bdfffff]
[    0.000000]        [0x13f600000-0x13fff8fff]
[    0.000000] Memory: 3911560k/5242880k available (6055k kernel code, 1049308k absent, 282012k reserved, 5155k data, 848k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:1152 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2333.230 MHz processor.
[    0.003018] Calibrating delay loop (skipped), value calculated using timer frequency.. 4666.46 BogoMIPS (lpj=2333230)
[    0.005004] pid_max: default: 32768 minimum: 301
[    0.006072] Security Framework initialized
[    0.007008] SELinux:  Disabled at boot.
[    0.008514] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.011226] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.013295] Mount-cache hash table entries: 256
[    0.014768] Initializing cgroup subsys memory
[    0.015049] Initializing cgroup subsys blkio
[    0.016092] CPU: Physical Processor ID: 0
[    0.017004] CPU: Processor Core ID: 0
[    0.018004] mce: CPU supports 6 MCE banks
[    0.019009] CPU0: Thermal LVT vector (0xfa) already installed
[    0.019014] using mwait in idle threads.
[    0.020004] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.024006] ... version:                2
[    0.025003] ... bit width:              40
[    0.026003] ... generic registers:      2
[    0.027003] ... value mask:             000000ffffffffff
[    0.028003] ... max period:             000000007fffffff
[    0.029003] ... fixed-purpose events:   3
[    0.030003] ... event mask:             0000000700000003
[    0.032006] ACPI: Core revision 20101013
[    0.045081] ftrace: allocating 27435 entries in 108 pages
[    0.048203] DMAR: Host address width 36
[    0.049005] DMAR: DRHD base: 0x000000fe710000 flags: 0x0
[    0.051024] IOMMU 0: reg_base_addr fe710000 ver 1:0 cap 900800c2f0462 ecap e01
[    0.052025] DMAR: DRHD base: 0x000000fe714000 flags: 0x0
[    0.053014] IOMMU 1: reg_base_addr fe714000 ver 1:0 cap 900800c2f0462 ecap e01
[    0.054005] DMAR: DRHD base: 0x000000fe719000 flags: 0x0
[    0.055014] IOMMU 2: reg_base_addr fe719000 ver 1:0 cap 900800c2f0462 ecap e01
[    0.056007] DMAR: DRHD base: 0x000000fe718000 flags: 0x1
[    0.057013] IOMMU 3: reg_base_addr fe718000 ver 1:0 cap 900800c2f0462 ecap e01
[    0.058005] DMAR: RMRR base: 0x000000bffd3000 end: 0x000000bffd3fff
[    0.059006] DMAR: RMRR base: 0x000000bffd4000 end: 0x000000bffd4fff
[    0.060007] DMAR: RMRR base: 0x000000bffd5000 end: 0x000000bffd5fff
[    0.061005] DMAR: RMRR base: 0x000000bffd6000 end: 0x000000bffd6fff
[    0.062004] DMAR: No ATSR found
[    0.064091] Setting APIC routing to flat
[    0.065442] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.076825] CPU0: Genuine Intel(R) CPU                  @ 2.33GHz stepping 04
[    0.079999] lockdep: fixing up alternatives.
[    0.081125] Booting Node   0, Processors  #1
[    0.003999] CPU1: Thermal LVT vector (0xfa) already installed
[    0.155221] lockdep: fixing up alternatives.
[    0.156032]  #2
[    0.003999] CPU2: Thermal LVT vector (0xfa) already installed
[    0.229205] lockdep: fixing up alternatives.
[    0.231034]  #3
[    0.003999] CPU3: Thermal LVT vector (0xfa) already installed
[    0.304015] Brought up 4 CPUs
[    0.305003] Total of 4 processors activated (18666.46 BogoMIPS).
[    0.307286] kworker/u:0 used greatest stack depth: 5160 bytes left
[    0.315195] Time: 15:30:01  Date: 12/17/10
[    0.316177] NET: Registered protocol family 16
[    0.318099] ACPI: bus type pci registered
[    0.320091] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.321006] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.381564] PCI: Using configuration type 1 for base access
[    0.404082] bio: create slab <bio-0> at 0
[    0.409653] ACPI: EC: Look up EC in DSDT
[    0.430047] ACPI: SSDT 00000000bffd07c1 008C4 (v01 HPQOEM  CPU_TM2 00000001 MSFT 0100000E)
[    0.433792] ACPI: Dynamic OEM Table Load:
[    0.436002] ACPI: SSDT           (null) 008C4 (v01 HPQOEM  CPU_TM2 00000001 MSFT 0100000E)
[    0.446779] ACPI: Interpreter enabled
[    0.447004] ACPI: (supports S0 S3 S4 S5)
[    0.449770] ACPI: Using IOAPIC for interrupt routing
[    0.464266] ACPI: No dock devices found.
[    0.465005] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.470267] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20101013/dsfield-143)
[    0.474006] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880137650c30), AE_ALREADY_EXISTS (20101013/psparse-537)
[    0.479002] ACPI: Marking method _OSC as Serialized because of AE_ALREADY_EXISTS error
[    0.481385] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.482392] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.482395] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff] (ignored)
[    0.482398] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfebfffff] (ignored)
[    0.482401] pci_root PNP0A08:00: host bridge window [mem 0xfed00000-0xfed003ff] (ignored)
[    0.482404] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff] (ignored)
[    0.482407] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.482410] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.482449] pci 0000:00:00.0: [8086:4003] type 0 class 0x000600
[    0.483087] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.483092] pci 0000:00:00.0: PME# disabled
[    0.483119] pci 0000:00:01.0: [8086:4021] type 1 class 0x000604
[    0.483183] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.483187] pci 0000:00:01.0: PME# disabled
[    0.483218] pci 0000:00:05.0: [8086:4025] type 1 class 0x000604
[    0.483281] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.483286] pci 0000:00:05.0: PME# disabled
[    0.483316] pci 0000:00:09.0: [8086:4029] type 1 class 0x000604
[    0.483388] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.483393] pci 0000:00:09.0: PME# disabled
[    0.483420] pci 0000:00:10.0: [8086:4030] type 0 class 0x000600
[    0.483474] pci 0000:00:10.1: [8086:4030] type 0 class 0x000600
[    0.483518] pci 0000:00:10.2: [8086:4030] type 0 class 0x000600
[    0.483561] pci 0000:00:10.3: [8086:4030] type 0 class 0x000600
[    0.483604] pci 0000:00:10.4: [8086:4030] type 0 class 0x000600
[    0.483652] pci 0000:00:11.0: [8086:4031] type 0 class 0x000600
[    0.483700] pci 0000:00:15.0: [8086:4035] type 0 class 0x000600
[    0.483743] pci 0000:00:15.1: [8086:4035] type 0 class 0x000600
[    0.483795] pci 0000:00:16.0: [8086:4036] type 0 class 0x000600
[    0.483839] pci 0000:00:16.1: [8086:4036] type 0 class 0x000600
[    0.483909] pci 0000:00:1b.0: [8086:269a] type 0 class 0x000403
[    0.483930] pci 0000:00:1b.0: reg 10: [mem 0xf3100000-0xf3103fff 64bit]
[    0.484015] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.484020] pci 0000:00:1b.0: PME# disabled
[    0.484058] pci 0000:00:1c.0: [8086:2690] type 1 class 0x000604
[    0.484138] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.484143] pci 0000:00:1c.0: PME# disabled
[    0.484178] pci 0000:00:1d.0: [8086:2688] type 0 class 0x000c03
[    0.484234] pci 0000:00:1d.0: reg 20: [io  0x2000-0x201f]
[    0.484274] pci 0000:00:1d.1: [8086:2689] type 0 class 0x000c03
[    0.484330] pci 0000:00:1d.1: reg 20: [io  0x2020-0x203f]
[    0.484381] pci 0000:00:1d.2: [8086:268a] type 0 class 0x000c03
[    0.484436] pci 0000:00:1d.2: reg 20: [io  0x2040-0x205f]
[    0.484487] pci 0000:00:1d.3: [8086:268b] type 0 class 0x000c03
[    0.484543] pci 0000:00:1d.3: reg 20: [io  0x2060-0x207f]
[    0.484596] pci 0000:00:1d.7: [8086:268c] type 0 class 0x000c03
[    0.484621] pci 0000:00:1d.7: reg 10: [mem 0xf3104000-0xf31043ff]
[    0.484716] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.484722] pci 0000:00:1d.7: PME# disabled
[    0.484745] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    0.484820] pci 0000:00:1f.0: [8086:2670] type 0 class 0x000601
[    0.484929] pci 0000:00:1f.1: [8086:269e] type 0 class 0x000101
[    0.484946] pci 0000:00:1f.1: reg 10: [io  0x20d0-0x20d7]
[    0.484958] pci 0000:00:1f.1: reg 14: [io  0x20f0-0x20f3]
[    0.484971] pci 0000:00:1f.1: reg 18: [io  0x20d8-0x20df]
[    0.484983] pci 0000:00:1f.1: reg 1c: [io  0x20f4-0x20f7]
[    0.484995] pci 0000:00:1f.1: reg 20: [io  0x20c0-0x20cf]
[    0.485051] pci 0000:00:1f.2: [8086:2682] type 0 class 0x000104
[    0.485073] pci 0000:00:1f.2: reg 10: [io  0x20e0-0x20e7]
[    0.485084] pci 0000:00:1f.2: reg 14: [io  0x20f8-0x20fb]
[    0.485096] pci 0000:00:1f.2: reg 18: [io  0x20e8-0x20ef]
[    0.485107] pci 0000:00:1f.2: reg 1c: [io  0x20fc-0x20ff]
[    0.485118] pci 0000:00:1f.2: reg 20: [io  0x2080-0x209f]
[    0.485129] pci 0000:00:1f.2: reg 24: [mem 0xf3104400-0xf31047ff]
[    0.485166] pci 0000:00:1f.2: PME# supported from D3hot
[    0.485171] pci 0000:00:1f.2: PME# disabled
[    0.485237] pci 0000:00:01.0: PCI bridge to [bus 80-80]
[    0.486008] pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.486013] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.486020] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.486084] pci 0000:60:00.0: [10de:040a] type 0 class 0x000300
[    0.486099] pci 0000:60:00.0: reg 10: [mem 0xf2000000-0xf2ffffff]
[    0.486116] pci 0000:60:00.0: reg 14: [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.486132] pci 0000:60:00.0: reg 1c: [mem 0xf0000000-0xf1ffffff 64bit]
[    0.486143] pci 0000:60:00.0: reg 24: [io  0x1000-0x107f]
[    0.486154] pci 0000:60:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.488055] pci 0000:00:05.0: PCI bridge to [bus 60-60]
[    0.489007] pci 0000:00:05.0:   bridge window [io  0x1000-0x1fff]
[    0.489011] pci 0000:00:05.0:   bridge window [mem 0xf0000000-0xf2ffffff]
[    0.489018] pci 0000:00:05.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.489349] pci 0000:10:00.0: [8086:3500] type 1 class 0x000604
[    0.492136] pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
[    0.492227] pci 0000:10:00.0: PME# disabled
[    0.493045] pci 0000:10:00.3: [8086:350c] type 1 class 0x000604
[    0.495410] pci 0000:10:00.3: PME# supported from D0 D3hot D3cold
[    0.495501] pci 0000:10:00.3: PME# disabled
[    0.496182] pci 0000:10:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.497192] pci 0000:00:09.0: PCI bridge to [bus 10-40]
[    0.498007] pci 0000:00:09.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.498012] pci 0000:00:09.0:   bridge window [mem 0xf3200000-0xf32fffff]
[    0.498019] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.499867] pci 0000:1e:00.0: [8086:3510] type 1 class 0x000604
[    0.502456] pci 0000:1e:00.0: PME# supported from D0 D3hot D3cold
[    0.502547] pci 0000:1e:00.0: PME# disabled
[    0.503182] pci 0000:1e:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.504279] pci 0000:1e:01.0: [8086:3514] type 1 class 0x000604
[    0.507410] pci 0000:1e:01.0: PME# supported from D0 D3hot D3cold
[    0.507501] pci 0000:1e:01.0: PME# disabled
[    0.508002] pci 0000:1e:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.510639] pci 0000:10:00.0: PCI bridge to [bus 1e-40]
[    0.511050] pci 0000:10:00.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.511141] pci 0000:10:00.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.511324] pci 0000:10:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.513182] pci 0000:1e:00.0: PCI bridge to [bus 20-20]
[    0.514050] pci 0000:1e:00.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.514141] pci 0000:1e:00.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.514324] pci 0000:1e:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.516730] pci 0000:1e:01.0: PCI bridge to [bus 40-40]
[    0.517050] pci 0000:1e:01.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.517141] pci 0000:1e:01.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.517328] pci 0000:1e:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.520913] pci 0000:10:00.3: PCI bridge to [bus 11-1d]
[    0.521050] pci 0000:10:00.3:   bridge window [io  0xf000-0x0000] (disabled)
[    0.521141] pci 0000:10:00.3:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.521324] pci 0000:10:00.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.522166] pci 0000:0e:00.0: [14e4:167b] type 0 class 0x000200
[    0.522195] pci 0000:0e:00.0: reg 10: [mem 0xf3000000-0xf300ffff 64bit]
[    0.522264] pci 0000:0e:00.0: reg 30: [mem 0xff6f0000-0xff6fffff pref]
[    0.522324] pci 0000:0e:00.0: PME# supported from D3hot D3cold
[    0.522330] pci 0000:0e:00.0: PME# disabled
[    0.524059] pci 0000:00:1c.0: PCI bridge to [bus 0e-0e]
[    0.525006] pci 0000:00:1c.0:   bridge window [io  0xe000-0xefff]
[    0.525011] pci 0000:00:1c.0:   bridge window [mem 0xf3000000-0xf30fffff]
[    0.525024] pci 0000:00:1c.0:   bridge window [mem 0x3fffe00000-0x3fffffffff 64bit pref]
[    0.525117] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
[    0.526006] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.526011] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.526019] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.526022] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.526025] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0x3fffffffff] (subtractive decode)
[    0.526055] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.527516] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH1._PRT]
[    0.527647] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH5._PRT]
[    0.527787] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH9.MUPP._PRT]
[    0.527976] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH9.MUPP.PTE1._PRT]
[    0.528128] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH9.MUPP.PTE2._PRT]
[    0.528267] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX1._PRT]
[    0.528405] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB_._PRT]
[    0.528856] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20101013/dsfield-143)
[    0.531004] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880137650c30), AE_ALREADY_EXISTS (20101013/psparse-537)
[    0.565147] ACPI: PCI Interrupt Link [LNKA] (IRQs *3 4 5 6 7 10 11 14 15), disabled.
[    0.571072] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 14 15), disabled.
[    0.576502] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 14 15), disabled.
[    0.580512] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 14 15), disabled.
[    0.585124] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.591124] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 14 15), disabled.
[    0.597007] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 14 15), disabled.
[    0.602511] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.608094] vgaarb: device added: PCI:0000:60:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.609012] vgaarb: loaded
[    0.610129] SCSI subsystem initialized
[    0.612049] libata version 3.00 loaded.
[    0.612057] usbcore: registered new interface driver usbfs
[    0.613035] usbcore: registered new interface driver hub
[    0.614045] usbcore: registered new device driver usb
[    0.616069] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.617012] PCI: Using ACPI for IRQ routing
[    0.618004] PCI: pci_cache_line_size set to 64 bytes
[    0.619046] reserve RAM buffer: 0000000000097000 - 000000000009ffff 
[    0.619050] reserve RAM buffer: 00000000bffc2840 - 00000000bfffffff 
[    0.620043] cfg80211: Calling CRDA to update world regulatory domain
[    0.622081] NetLabel: Initializing
[    0.623003] NetLabel:  domain hash size = 128
[    0.624002] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.625052] NetLabel:  unlabeled traffic allowed by default
[    0.626054] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.627007] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.629677] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.634067] Switching to clocksource tsc
[    0.642237] pnp: PnP ACPI init
[    0.645530] ACPI: bus type pnp registered
[    0.649967] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.649970] pnp 00:00: [mem 0xc0000000-0xdfffffff window]
[    0.649973] pnp 00:00: [mem 0xf0000000-0xfebfffff window]
[    0.649976] pnp 00:00: [mem 0xfed00000-0xfed003ff window]
[    0.649978] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.649981] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.649983] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.649986] pnp 00:00: [io  0x0d00-0xffff window]
[    0.649988] pnp 00:00: [bus 00-ff]
[    0.650230] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.650369] pnp 00:01: [mem 0xfec89000-0xfec890ff]
[    0.650554] pnp 00:01: Plug and Play ACPI device, IDs PNP0003 (active)
[    0.650614] pnp 00:02: [io  0x00f0-0x00ff]
[    0.650631] pnp 00:02: [irq 13]
[    0.650797] pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.650824] pnp 00:03: [io  0x0000-0x000f]
[    0.650826] pnp 00:03: [io  0x0080-0x008f]
[    0.650829] pnp 00:03: [io  0x00c0-0x00df]
[    0.650831] pnp 00:03: [dma 4]
[    0.651009] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.651026] pnp 00:04: [io  0x0070-0x0071]
[    0.651034] pnp 00:04: [irq 8]
[    0.651207] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.651227] pnp 00:05: [io  0x0061]
[    0.651408] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.651429] pnp 00:06: [irq 12]
[    0.651613] pnp 00:06: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
[    0.651629] pnp 00:07: [io  0x0060]
[    0.651632] pnp 00:07: [io  0x0064]
[    0.651639] pnp 00:07: [irq 1]
[    0.651819] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.652102] pnp 00:08: [irq 4]
[    0.652105] pnp 00:08: [io  0x03f8-0x03ff]
[    0.652332] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    0.652641] pnp 00:09: [irq 6]
[    0.652644] pnp 00:09: [dma 2]
[    0.652646] pnp 00:09: [io  0x03f0-0x03f5]
[    0.652649] pnp 00:09: [io  0x03f7]
[    0.652858] pnp 00:09: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.652952] pnp 00:0a: [mem 0xfec00000-0xfec00fff]
[    0.653130] pnp 00:0a: Plug and Play ACPI device, IDs PNP0003 (active)
[    0.653191] pnp 00:0b: [mem 0xfed00000-0xfed003ff]
[    0.653375] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.653418] pnp 00:0c: [io  0x0010-0x001f]
[    0.653420] pnp 00:0c: [io  0x0050-0x0053]
[    0.653422] pnp 00:0c: [io  0x0072-0x0077]
[    0.653425] pnp 00:0c: [io  0x0090-0x009f]
[    0.653427] pnp 00:0c: [io  0x04d0-0x04d1]
[    0.653691] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.653739] pnp 00:0d: [io  0x0400-0x041f]
[    0.653742] pnp 00:0d: [io  0x0420-0x043f]
[    0.653744] pnp 00:0d: [io  0x0440-0x045f]
[    0.653746] pnp 00:0d: [io  0x0460-0x047f]
[    0.653748] pnp 00:0d: [io  0x0480-0x048f]
[    0.653750] pnp 00:0d: [io  0x0490-0x049f]
[    0.653752] pnp 00:0d: [io  0xf800-0xf81f]
[    0.653754] pnp 00:0d: [io  0xf820-0xf83f]
[    0.653757] pnp 00:0d: [io  0xf840-0xf85f]
[    0.653759] pnp 00:0d: [io  0xf860-0xf87f]
[    0.653761] pnp 00:0d: [io  0xfa00-0xfa3f]
[    0.653763] pnp 00:0d: [io  0xfc00-0xfc7f]
[    0.653765] pnp 00:0d: [io  0xfc80-0xfcff]
[    0.653767] pnp 00:0d: [io  0xfe00-0xfe7f]
[    0.653769] pnp 00:0d: [io  0xfe80-0xfeff]
[    0.654025] pnp 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.654042] pnp 00:0e: [mem 0xfed1c000-0xfed1ffff]
[    0.654045] pnp 00:0e: [mem 0xffe00000-0xffffffff]
[    0.654047] pnp 00:0e: [mem 0xfee00000-0xfeefffff]
[    0.654050] pnp 00:0e: [mem 0xfe700000-0xfe7003ff]
[    0.654052] pnp 00:0e: [mem 0xfe600000-0xfe6fffff]
[    0.654054] pnp 00:0e: [mem 0xfe000000-0xfe01ffff]
[    0.654294] pnp 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.654652] pnp 00:0f: [mem 0x00000000-0x0009ffff]
[    0.654654] pnp 00:0f: [mem 0x000c0000-0x000e7fff]
[    0.654657] pnp 00:0f: [mem 0x000e8000-0x000effff]
[    0.654659] pnp 00:0f: [mem 0x000f0000-0x000fffff]
[    0.654661] pnp 00:0f: [mem 0x00100000-0xbfffffff]
[    0.654664] pnp 00:0f: [mem 0xfeda0000-0xfedbffff]
[    0.654925] pnp 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.655004] pnp 00:10: [mem 0xe0000000-0xefffffff]
[    0.655252] pnp 00:10: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.655275] pnp: PnP ACPI: found 17 devices
[    0.659651] ACPI: ACPI bus type pnp unregistered
[    0.664486] system 00:0c: [io  0x04d0-0x04d1] has been reserved
[    0.670603] system 00:0d: [io  0x0400-0x041f] has been reserved
[    0.676712] system 00:0d: [io  0x0420-0x043f] has been reserved
[    0.682809] system 00:0d: [io  0x0440-0x045f] has been reserved
[    0.688909] system 00:0d: [io  0x0460-0x047f] has been reserved
[    0.695008] system 00:0d: [io  0x0480-0x048f] has been reserved
[    0.701107] system 00:0d: [io  0x0490-0x049f] has been reserved
[    0.707205] system 00:0d: [io  0xf800-0xf81f] has been reserved
[    0.713315] system 00:0d: [io  0xf820-0xf83f] has been reserved
[    0.719422] system 00:0d: [io  0xf840-0xf85f] has been reserved
[    0.725519] system 00:0d: [io  0xf860-0xf87f] has been reserved
[    0.731626] system 00:0d: [io  0xfa00-0xfa3f] has been reserved
[    0.737733] system 00:0d: [io  0xfc00-0xfc7f] has been reserved
[    0.743831] system 00:0d: [io  0xfc80-0xfcff] has been reserved
[    0.749928] system 00:0d: [io  0xfe00-0xfe7f] has been reserved
[    0.756026] system 00:0d: [io  0xfe80-0xfeff] has been reserved
[    0.762131] system 00:0e: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.768923] system 00:0e: [mem 0xffe00000-0xffffffff] has been reserved
[    0.775725] system 00:0e: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.782517] system 00:0e: [mem 0xfe700000-0xfe7003ff] has been reserved
[    0.789316] system 00:0e: [mem 0xfe600000-0xfe6fffff] has been reserved
[    0.796108] system 00:0e: [mem 0xfe000000-0xfe01ffff] has been reserved
[    0.802908] system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.810047] system 00:0f: [mem 0x000c0000-0x000e7fff] has been reserved
[    0.816838] system 00:0f: [mem 0x000e8000-0x000effff] could not be reserved
[    0.823976] system 00:0f: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.831115] system 00:0f: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.838252] system 00:0f: [mem 0xfeda0000-0xfedbffff] has been reserved
[    0.845050] system 00:10: [mem 0xe0000000-0xefffffff] has been reserved
[    0.868138] pci 0000:0e:00.0: no compatible bridge window for [mem 0xff6f0000-0xff6fffff pref]
[    0.878178] pci 0000:00:01.0: PCI bridge to [bus 80-80]
[    0.883581] pci 0000:00:01.0:   bridge window [io  disabled]
[    0.889429] pci 0000:00:01.0:   bridge window [mem disabled]
[    0.895266] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    0.901554] pci 0000:60:00.0: BAR 6: can't assign mem pref (size 0x20000)
[    0.908527] pci 0000:00:05.0: PCI bridge to [bus 60-60]
[    0.913931] pci 0000:00:05.0:   bridge window [io  0x1000-0x1fff]
[    0.920203] pci 0000:00:05.0:   bridge window [mem 0xf0000000-0xf2ffffff]
[    0.927167] pci 0000:00:05.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.935244] pci 0000:1e:00.0: PCI bridge to [bus 20-20]
[    0.940648] pci 0000:1e:00.0:   bridge window [io  disabled]
[    0.946587] pci 0000:1e:00.0:   bridge window [mem disabled]
[    0.952479] pci 0000:1e:00.0:   bridge window [mem pref disabled]
[    0.958897] pci 0000:1e:01.0: PCI bridge to [bus 40-40]
[    0.964301] pci 0000:1e:01.0:   bridge window [io  disabled]
[    0.970231] pci 0000:1e:01.0:   bridge window [mem disabled]
[    0.976114] pci 0000:1e:01.0:   bridge window [mem pref disabled]
[    0.982523] pci 0000:10:00.0: PCI bridge to [bus 1e-40]
[    0.987935] pci 0000:10:00.0:   bridge window [io  disabled]
[    0.993874] pci 0000:10:00.0:   bridge window [mem disabled]
[    0.999757] pci 0000:10:00.0:   bridge window [mem pref disabled]
[    1.006175] pci 0000:10:00.3: PCI bridge to [bus 11-1d]
[    1.011605] pci 0000:10:00.3:   bridge window [io  disabled]
[    1.017548] pci 0000:10:00.3:   bridge window [mem disabled]
[    1.023438] pci 0000:10:00.3:   bridge window [mem pref disabled]
[    1.029854] pci 0000:00:09.0: PCI bridge to [bus 10-40]
[    1.035263] pci 0000:00:09.0:   bridge window [io  disabled]
[    1.041124] pci 0000:00:09.0:   bridge window [mem 0xf3200000-0xf32fffff]
[    1.048110] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    1.054404] pci 0000:0e:00.0: BAR 6: assigned [mem 0xf30f0000-0xf30fffff pref]
[    1.061967] pci 0000:00:1c.0: PCI bridge to [bus 0e-0e]
[    1.067384] pci 0000:00:1c.0:   bridge window [io  0xe000-0xefff]
[    1.073671] pci 0000:00:1c.0:   bridge window [mem 0xf3000000-0xf30fffff]
[    1.080648] pci 0000:00:1c.0:   bridge window [mem 0x3fffe00000-0x3fffffffff 64bit pref]
[    1.089098] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
[    1.094510] pci 0000:00:1e.0:   bridge window [io  disabled]
[    1.100360] pci 0000:00:1e.0:   bridge window [mem disabled]
[    1.106220] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.112534] pci 0000:00:01.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
[    1.119427] pci 0000:00:01.0: setting latency timer to 64
[    1.119442] pci 0000:00:05.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[    1.126329] pci 0000:00:05.0: setting latency timer to 64
[    1.126348] pci 0000:00:09.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
[    1.133235] pci 0000:00:09.0: setting latency timer to 64
[    1.133294] pci 0000:10:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
[    1.140235] pci 0000:10:00.0: setting latency timer to 64
[    1.140373] pci 0000:1e:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
[    1.147305] pci 0000:1e:00.0: setting latency timer to 64
[    1.147450] pci 0000:1e:01.0: PCI INT A -> GSI 46 (level, low) -> IRQ 46
[    1.154382] pci 0000:1e:01.0: setting latency timer to 64
[    1.154610] pci 0000:10:00.3: setting latency timer to 64
[    1.154668] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.161553] pci 0000:00:1c.0: setting latency timer to 64
[    1.161562] pci 0000:00:1e.0: setting latency timer to 64
[    1.161567] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    1.161569] pci_bus 0000:00: resource 1 [mem 0x00000000-0x3fffffffff]
[    1.161572] pci_bus 0000:60: resource 0 [io  0x1000-0x1fff]
[    1.161575] pci_bus 0000:60: resource 1 [mem 0xf0000000-0xf2ffffff]
[    1.161577] pci_bus 0000:60: resource 2 [mem 0xc0000000-0xdfffffff 64bit pref]
[    1.161580] pci_bus 0000:10: resource 1 [mem 0xf3200000-0xf32fffff]
[    1.161583] pci_bus 0000:0e: resource 0 [io  0xe000-0xefff]
[    1.161585] pci_bus 0000:0e: resource 1 [mem 0xf3000000-0xf30fffff]
[    1.161588] pci_bus 0000:0e: resource 2 [mem 0x3fffe00000-0x3fffffffff 64bit pref]
[    1.161591] pci_bus 0000:01: resource 4 [io  0x0000-0xffff]
[    1.161593] pci_bus 0000:01: resource 5 [mem 0x00000000-0x3fffffffff]
[    1.161670] NET: Registered protocol family 2
[    1.166493] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.175943] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.187380] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    1.199073] TCP: Hash tables configured (established 524288 bind 65536)
[    1.205905] TCP reno registered
[    1.209278] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    1.215901] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    1.223186] NET: Registered protocol family 1
[    1.228075] RPC: Registered udp transport module.
[    1.232992] RPC: Registered tcp transport module.
[    1.237883] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.244594] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    1.244596] pci 0000:00:1d.0: Performing full reset
[    1.244617] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    1.244619] pci 0000:00:1d.1: Performing full reset
[    1.244639] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    1.244642] pci 0000:00:1d.2: Performing full reset
[    1.244661] pci 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
[    1.244663] pci 0000:00:1d.3: Performing full reset
[    1.244748] pci 0000:00:1f.0: rerouting interrupts for [8086:2670]
[    1.251139] pci 0000:60:00.0: Boot video device
[    1.251327] PCI: CLS 64 bytes, default 64
[    1.251497] Trying to unpack rootfs image as initramfs...
[    1.370689] Freeing initrd memory: 5092k freed
[    1.377237] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.383871] Placing 64MB software IO TLB between ffff8800bbc00000 - ffff8800bfc00000
[    1.391947] software IO TLB at phys 0xbbc00000 - 0xbfc00000
[    1.403239] microcode: CPU0 sig=0x10674, pf=0x40, revision=0x404
[    1.409433] microcode: CPU1 sig=0x10674, pf=0x40, revision=0x404
[    1.415638] microcode: CPU2 sig=0x10674, pf=0x40, revision=0x404
[    1.421839] microcode: CPU3 sig=0x10674, pf=0x40, revision=0x404
[    1.428268] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.437383] Scanning for low memory corruption every 60 seconds
[    1.444253] audit: initializing netlink socket (disabled)
[    1.449879] type=2000 audit(1292599800.448:1): initialized
[    1.468622] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.490968] VFS: Disk quotas dquot_6.5.2
[    1.495322] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.505502] msgmni has been set to 7649
[    1.510853] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.518597] io scheduler noop registered
[    1.522702] io scheduler deadline registered
[    1.527339] io scheduler cfq registered (default)
[    1.532793] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20101013/dsfield-143)
[    1.542152] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880137650c30), AE_ALREADY_EXISTS (20101013/psparse-537)
[    1.555216] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20101013/dsfield-143)
[    1.564577] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880137650c30), AE_ALREADY_EXISTS (20101013/psparse-537)
[    1.577610] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20101013/dsfield-143)
[    1.586972] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880137650c30), AE_ALREADY_EXISTS (20101013/psparse-537)
[    1.600031] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20101013/dsfield-143)
[    1.609374] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880137650c30), AE_ALREADY_EXISTS (20101013/psparse-537)
[    1.622403] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20101013/dsfield-143)
[    1.631752] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880137650c30), AE_ALREADY_EXISTS (20101013/psparse-537)
[    1.644784] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20101013/dsfield-143)
[    1.654126] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880137650c30), AE_ALREADY_EXISTS (20101013/psparse-537)
[    1.667153] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20101013/dsfield-143)
[    1.676497] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880137650c30), AE_ALREADY_EXISTS (20101013/psparse-537)
[    1.689751] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.696493] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.705058] ACPI: Power Button [PBTN]
[    1.709100] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.716830] ACPI: Power Button [PWRF]
[    1.721148] ACPI: acpi_idle registered with cpuidle
[    1.725893] Non-volatile memory driver v1.3
[    1.730266] Linux agpgart interface v0.103
[    1.735020] [drm] Initialized drm 1.1.0 20060810
[    1.739820] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    1.747650] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.018173] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.110417] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.135238] brd: module loaded
[    2.141446] loop: module loaded
[    2.145607] ahci 0000:00:1f.2: version 3.0
[    2.145667] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.152793] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl RAID mode
[    2.161303] ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part 
[    2.167578] ahci 0000:00:1f.2: setting latency timer to 64
[    2.171540] scsi0 : ahci
[    2.174782] scsi1 : ahci
[    2.177894] scsi2 : ahci
[    2.180992] scsi3 : ahci
[    2.184096] scsi4 : ahci
[    2.187205] scsi5 : ahci
[    2.190281] ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 19
[    2.198790] ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 19
[    2.207296] ata3: SATA max UDMA/133 abar m1024@0xf3104400 port 0xf3104600 irq 19
[    2.215023] ata4: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 19
[    2.223528] ata5: SATA max UDMA/133 abar m1024@0xf3104400 port 0xf3104700 irq 19
[    2.231255] ata6: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 19
[    2.240465] ata_piix 0000:00:1f.1: version 2.13
[    2.240485] ata_piix 0000:00:1f.1: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.247880] ata_piix 0000:00:1f.1: setting latency timer to 64
[    2.249329] scsi6 : ata_piix
[    2.252767] scsi7 : ata_piix
[    2.256125] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x20c0 irq 14
[    2.263277] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x20c8 irq 15
[    2.270663] ata8: port disabled. ignoring.
[    2.271041] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    2.278273] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    2.284367] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    2.290645] e100: Copyright(c) 1999-2006 Intel Corporation
[    2.296496] tg3.c:v3.115 (October 14, 2010)
[    2.311036] tg3 0000:0e:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.317932] tg3 0000:0e:00.0: setting latency timer to 64
[    2.348504] tg3 0000:0e:00.0: eth0: Tigon3 [partno(BCM95755) rev a002] (PCI Express) MAC address 00:19:bb:ea:3c:7d
[    2.359181] tg3 0000:0e:00.0: eth0: attached PHY is 5755 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    2.368642] tg3 0000:0e:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    2.376889] tg3 0000:0e:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    2.384113] sky2: driver version 1.28
[    2.388392] console [netcon0] enabled
[    2.392237] netconsole: network logging started
[    2.397477] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.404184] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    2.404224] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.411554] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.411558] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.417184] drivers/usb/core/inode.c: creating file 'devices'
[    2.417242] drivers/usb/core/inode.c: creating file '001'
[    2.417591] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    2.434015] ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
[    2.434020] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    2.434091] ehci_hcd 0000:00:1d.7: debug port 1
[    2.438807] ehci_hcd 0000:00:1d.7: reset command 0010002 (park)=0 ithresh=1 period=1024 Reset HALT
[    2.442703] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    2.442706] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    2.442738] ehci_hcd 0000:00:1d.7: irq 16, io mem 0xf3104000
[    2.448589] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    2.452466] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    2.458026] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.464104] usb usb1: default language 0x0409
[    2.464120] usb usb1: udev 1, busnum 1, minor = 0
[    2.464122] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.471090] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.478642] usb usb1: Product: EHCI Host Controller
[    2.483700] usb usb1: Manufacturer: Linux 2.6.37-rc6+ ehci_hcd
[    2.489709] usb usb1: SerialNumber: 0000:00:1d.7
[    2.494826] usb usb1: usb_probe_device
[    2.494830] usb usb1: configuration #1 chosen from 1 choice
[    2.494943] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    2.495195] hub 1-0:1.0: usb_probe_interface
[    2.495198] hub 1-0:1.0: usb_probe_interface - got id
[    2.495200] hub 1-0:1.0: USB hub found
[    2.499166] hub 1-0:1.0: 8 ports detected
[    2.503358] hub 1-0:1.0: standalone hub
[    2.503360] hub 1-0:1.0: no power switching (usb 1.0)
[    2.503363] hub 1-0:1.0: individual port over-current protection
[    2.503365] hub 1-0:1.0: power on to power good time: 20ms
[    2.503446] hub 1-0:1.0: local power source is good
[    2.503449] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    2.503547] drivers/usb/core/inode.c: creating file '001'
[    2.503835] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.510195] ohci_hcd: block sizes: ed 80 td 96
[    2.510352] uhci_hcd: USB Universal Host Controller Interface driver
[    2.517132] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.524458] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.524461] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.529875] drivers/usb/core/inode.c: creating file '002'
[    2.530071] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.542017] uhci_hcd 0000:00:1d.0: detected 2 ports
[    2.545033] ata5: SATA link down (SStatus 0 SControl 300)
[    2.550024] ata3: SATA link down (SStatus 0 SControl 300)
[    2.558227] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    2.558230] uhci_hcd 0000:00:1d.0: Performing full reset
[    2.558244] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    2.558253] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00002000
[    2.564250] usb usb2: default language 0x0409
[    2.564265] usb usb2: udev 1, busnum 2, minor = 128
[    2.564268] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.571232] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.578786] usb usb2: Product: UHCI Host Controller
[    2.583843] usb usb2: Manufacturer: Linux 2.6.37-rc6+ uhci_hcd
[    2.589855] usb usb2: SerialNumber: 0000:00:1d.0
[    2.594858] usb usb2: usb_probe_device
[    2.594861] usb usb2: configuration #1 chosen from 1 choice
[    2.594873] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    2.595059] hub 2-0:1.0: usb_probe_interface
[    2.595061] hub 2-0:1.0: usb_probe_interface - got id
[    2.595063] hub 2-0:1.0: USB hub found
[    2.599018] hub 2-0:1.0: 2 ports detected
[    2.603366] hub 2-0:1.0: standalone hub
[    2.603369] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
[    2.603372] hub 2-0:1.0: no power switching (usb 1.0)
[    2.603374] hub 2-0:1.0: individual port over-current protection
[    2.603376] hub 2-0:1.0: power on to power good time: 2ms
[    2.603399] hub 2-0:1.0: local power source is good
[    2.603401] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    2.603452] drivers/usb/core/inode.c: creating file '001'
[    2.603550] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    2.603589] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.610908] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.610912] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.616324] drivers/usb/core/inode.c: creating file '003'
[    2.616513] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.629016] uhci_hcd 0000:00:1d.1: detected 2 ports
[    2.634077] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    2.634080] uhci_hcd 0000:00:1d.1: Performing full reset
[    2.634093] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    2.634101] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002020
[    2.640095] usb usb3: default language 0x0409
[    2.640116] usb usb3: udev 1, busnum 3, minor = 256
[    2.640118] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.647084] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.654638] usb usb3: Product: UHCI Host Controller
[    2.659696] usb usb3: Manufacturer: Linux 2.6.37-rc6+ uhci_hcd
[    2.665705] usb usb3: SerialNumber: 0000:00:1d.1
[    2.670707] usb usb3: usb_probe_device
[    2.670710] usb usb3: configuration #1 chosen from 1 choice
[    2.670723] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    2.670885] hub 3-0:1.0: usb_probe_interface
[    2.670887] hub 3-0:1.0: usb_probe_interface - got id
[    2.670890] hub 3-0:1.0: USB hub found
[    2.674829] hub 3-0:1.0: 2 ports detected
[    2.679023] hub 3-0:1.0: standalone hub
[    2.679025] hub 3-0:1.0: no power switching (usb 1.0)
[    2.679027] hub 3-0:1.0: individual port over-current protection
[    2.679029] hub 3-0:1.0: power on to power good time: 2ms
[    2.679041] hub 3-0:1.0: local power source is good
[    2.679044] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    2.679099] drivers/usb/core/inode.c: creating file '001'
[    2.679244] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    2.679295] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.686616] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.686620] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.692033] drivers/usb/core/inode.c: creating file '004'
[    2.692222] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.703038] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.704070] uhci_hcd 0000:00:1d.2: detected 2 ports
[    2.709133] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    2.709135] uhci_hcd 0000:00:1d.2: Performing full reset
[    2.709149] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    2.709175] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
[    2.715153] usb usb4: default language 0x0409
[    2.715169] usb usb4: udev 1, busnum 4, minor = 384
[    2.715171] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.722138] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.729692] usb usb4: Product: UHCI Host Controller
[    2.734750] usb usb4: Manufacturer: Linux 2.6.37-rc6+ uhci_hcd
[    2.740759] usb usb4: SerialNumber: 0000:00:1d.2
[    2.745763] usb usb4: usb_probe_device
[    2.745766] usb usb4: configuration #1 chosen from 1 choice
[    2.745779] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    2.745946] hub 4-0:1.0: usb_probe_interface
[    2.745948] hub 4-0:1.0: usb_probe_interface - got id
[    2.745950] hub 4-0:1.0: USB hub found
[    2.749891] hub 4-0:1.0: 2 ports detected
[    2.754085] hub 4-0:1.0: standalone hub
[    2.754087] hub 4-0:1.0: no power switching (usb 1.0)
[    2.754089] hub 4-0:1.0: individual port over-current protection
[    2.754092] hub 4-0:1.0: power on to power good time: 2ms
[    2.754104] hub 4-0:1.0: local power source is good
[    2.754107] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    2.754157] drivers/usb/core/inode.c: creating file '001'
[    2.754255] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    2.754300] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 22 (level, low) -> IRQ 22
[    2.761622] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.761626] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.767041] drivers/usb/core/inode.c: creating file '005'
[    2.767233] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    2.779039] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.779043] uhci_hcd 0000:00:1d.3: detected 2 ports
[    2.779049] uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
[    2.779052] uhci_hcd 0000:00:1d.3: Performing full reset
[    2.779068] uhci_hcd 0000:00:1d.3: supports USB remote wakeup
[    2.779098] uhci_hcd 0000:00:1d.3: irq 22, io base 0x00002060
[    2.779170] usb usb5: default language 0x0409
[    2.779185] usb usb5: udev 1, busnum 5, minor = 512
[    2.779187] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.779189] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.779191] usb usb5: Product: UHCI Host Controller
[    2.779193] usb usb5: Manufacturer: Linux 2.6.37-rc6+ uhci_hcd
[    2.779195] usb usb5: SerialNumber: 0000:00:1d.3
[    2.779375] usb usb5: usb_probe_device
[    2.779378] usb usb5: configuration #1 chosen from 1 choice
[    2.779390] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    2.779520] hub 5-0:1.0: usb_probe_interface
[    2.779522] hub 5-0:1.0: usb_probe_interface - got id
[    2.779524] hub 5-0:1.0: USB hub found
[    2.779533] hub 5-0:1.0: 2 ports detected
[    2.779535] hub 5-0:1.0: standalone hub
[    2.779536] hub 5-0:1.0: no power switching (usb 1.0)
[    2.779538] hub 5-0:1.0: individual port over-current protection
[    2.779540] hub 5-0:1.0: power on to power good time: 2ms
[    2.779552] hub 5-0:1.0: local power source is good
[    2.779554] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    2.779609] drivers/usb/core/inode.c: creating file '001'
[    2.779716] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.3
[    2.779938] usbcore: registered new interface driver usblp
[    2.779940] Initializing USB Mass Storage driver...
[    2.780091] usbcore: registered new interface driver usb-storage
[    2.780093] USB Mass Storage support registered.
[    2.780306] usbcore: registered new interface driver libusual
[    2.780532] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    2.783916] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.783948] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.784231] mice: PS/2 mouse device common for all mice
[    2.784815] rtc_cmos 00:04: RTC can wake from S4
[    2.889054] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.889074] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.895307] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    2.901619] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.909294] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[    2.918186] device-mapper: multipath: version 1.1.1 loaded
[    2.923869] device-mapper: multipath round-robin: version 1.0.0 loaded
[    2.930850] cpuidle: using governor ladder
[    2.935141] cpuidle: using governor menu
[    2.941835] usbcore: registered new interface driver usbhid
[    2.944042] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.944975] ata1.00: ATA-7: Hitachi HDS721680PLA380, P21OAB6A, max UDMA/100
[    2.944978] ata1.00: 156301488 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.966036] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.966062] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.981060] usbhid: USB HID core driver
[    2.981089] ata2.00: ATAPI: HL-DT-STDVD-ROM GDRH10N, D70D, max UDMA/100
[    2.981111] ata4.00: ATA-7: INTEL SSDSA2MH080G1GN, 045C8610, max UDMA/133
[    2.981114] ata4.00: 156301488 sectors, multi 1: LBA48 NCQ (depth 31)
[    2.981157] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.011880] ata4.00: configured for UDMA/133
[    3.015396] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    3.015517] HDA Intel 0000:00:1b.0: irq 64 for MSI/MSI-X
[    3.015581] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    3.023927] ata6.00: ATA-6: WDC WD400JD-75HKA1, 14.03G14, max UDMA/133
[    3.030685] ata6.00: 78125000 sectors, multi 0: LBA 
[    3.035864] ata1.00: configured for UDMA/100
[    3.040377] ata2.00: configured for UDMA/100
[    3.040879] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72168 P21O PQ: 0 ANSI: 5
[    3.041668] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    3.041781] sd 0:0:0:0: [sda] Write Protect is off
[    3.041784] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.041828] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.042935] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.056563]  sda: sda1 sda2
[    3.084591] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.084805] ata6.00: configured for UDMA/133
[    3.096087] hda_codec: ALC262: SKU not ready 0x411111f0
[    3.097652] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GDRH10N  D70D PQ: 0 ANSI: 5
[    3.114630] ALSA device list:
[    3.116248] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[    3.116252] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.116676] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.116900] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    3.117192] scsi 3:0:0:0: Direct-Access     ATA      INTEL SSDSA2MH08 045C PQ: 0 ANSI: 5
[    3.117694] sd 3:0:0:0: [sdb] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    3.117809] sd 3:0:0:0: [sdb] Write Protect is off
[    3.117812] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.117853] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    3.117859] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.118190] scsi 5:0:0:0: Direct-Access     ATA      WDC WD400JD-75HK 14.0 PQ: 0 ANSI: 5
[    3.118744] sd 5:0:0:0: [sdc] 78125000 512-byte logical blocks: (40.0 GB/37.2 GiB)
[    3.118853] sd 5:0:0:0: [sdc] Write Protect is off
[    3.118856] sd 5:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    3.118878] sd 5:0:0:0: Attached scsi generic sg3 type 0
[    3.118920] sd 5:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.118938]  sdb: unknown partition table
[    3.211591]   #0: HDA Intel at 0xf3100000 irq 64
[    3.211604]  sdc: sdc1
[    3.219062] Netfilter messages via NETLINK v0.30.
[    3.219298] sd 3:0:0:0: [sdb] Attached SCSI disk
[    3.219400] sd 5:0:0:0: [sdc] Attached SCSI disk
[    3.233587] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.240436] ctnetlink v0.93: registering with nfnetlink.
[    3.247476] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.253080] TCP cubic registered
[    3.256493] Initializing XFRM netlink socket
[    3.261580] NET: Registered protocol family 10
[    3.268948] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    3.274659] IPv6 over IPv4 tunneling driver
[    3.280781] NET: Registered protocol family 17
[    3.285498] Registering the dns_resolver key type
[    3.432993] PM: Hibernation image not present or could not be loaded.
[    3.433039] registered taskstats version 1
[    3.439822]   Magic number: 6:383:538
[    3.444438] Freeing unused kernel memory: 848k freed
[    3.449908] Write protecting the kernel read-only data: 10240k
[    3.456205] Freeing unused kernel memory: 68k freed
[    3.461599] Freeing unused kernel memory: 1244k freed
[    3.492135] dracut: dracut-004-32.el6
[    3.503543] dracut: rd_NO_LUKS: removing cryptoluks activation
[    3.517300] udev: starting version 147
[    3.521389] udevd (1029): /proc/1029/oom_adj is deprecated, please use /proc/1029/oom_score_adj instead.
[    3.584435] dracut: Starting plymouth daemon
[    3.641958] Floppy drive(s): fd0 is 1.44M
[    3.657248] scsi_id used greatest stack depth: 4992 bytes left
[    3.659801] FDC 0 is a post-1991 82077
[    3.687023] scsi_id used greatest stack depth: 4384 bytes left
[    3.704020] usb usb2: suspend_rh (auto-stop)
[    3.704043] usb usb3: suspend_rh (auto-stop)
[    3.845744] dracut: Scanning devices sda2  for LVM logical volumes vg_chilli/lv_root 
[    3.871644] dracut: inactive '/dev/vg_chilli/lv_root' [35.30 GiB] inherit
[    3.878703] dracut: inactive '/dev/vg_chilli/lv_home' [32.87 GiB] inherit
[    3.885751] dracut: inactive '/dev/vg_chilli/lv_swap' [5.88 GiB] inherit
[    3.928455] dracut: The link /dev/vg_chilli/lv_root should had been created by udev but it was not found. Falling back to direct link creation.
[    3.954020] usb usb4: suspend_rh (auto-stop)
[    3.954043] usb usb5: suspend_rh (auto-stop)
[    4.079559] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    4.149631] dracut: Mounted root filesystem /dev/mapper/vg_chilli-lv_root
[    4.279065] dracut: Switching root
[    5.465889] readahead: starting
[    6.806637] udev: starting version 147
[    7.340363] dmsetup used greatest stack depth: 4160 bytes left
[    8.773187] ip used greatest stack depth: 3856 bytes left
[   10.371992] EXT4-fs (dm-0): re-mounted. Opts: (null)
[   10.592772] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   10.629385] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[   10.645569] EXT4-fs (sdb): mounted filesystem with ordered data mode. Opts: (null)
[   10.999924] Adding 6160380k swap on /dev/mapper/vg_chilli-lv_swap.  Priority:-1 extents:1 across:6160380k 
[   12.582276] tg3 0000:0e:00.0: irq 65 for MSI/MSI-X
[   12.616686] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   12.622400] ip used greatest stack depth: 3744 bytes left
[   15.045136] tg3 0000:0e:00.0: eth0: Link is up at 1000 Mbps, full duplex
[   15.045313] tg3 0000:0e:00.0: eth0: Flow control is off for TX and off for RX
[   15.045313] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   21.765808] mount.nfs used greatest stack depth: 2848 bytes left
[   21.978145] netconsole: network logging stopped, interface sit0 unregistered
[   22.002090] netconsole: network logging stopped, interface lo unregistered
[   22.495909] mtrr: base(0xf1000000) is not aligned on a size(0xe00000) boundary
[   25.890053] eth0: no IPv6 routers present
