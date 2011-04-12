Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab1DLGbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 02:31:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52334 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab1DLGbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 02:31:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] x86-64, NUMA: reimplement cpu node map initialization for fake numa
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Brian Gerst <brgerst@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>
In-Reply-To: <20110412133842.6A37.A69D9226@jp.fujitsu.com>
References: <20110412040037.GK9673@mtj.dyndns.org> <20110412133842.6A37.A69D9226@jp.fujitsu.com>
Message-Id: <20110412153212.B514.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 12 Apr 2011 15:31:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Would something like the following work?
> > 
> > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> > index c2871d3..bad8a10 100644
> > --- a/arch/x86/kernel/smpboot.c
> > +++ b/arch/x86/kernel/smpboot.c
> > @@ -320,6 +320,18 @@ static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
> >  	cpumask_set_cpu(cpu2, cpu_core_mask(cpu1));
> >  	cpumask_set_cpu(cpu1, cpu_llc_shared_mask(cpu2));
> >  	cpumask_set_cpu(cpu2, cpu_llc_shared_mask(cpu1));
> > +
> > +	/*
> > +	 * It's assumed that sibling CPUs live on the same NUMA node, which
> > +	 * might not hold if NUMA configuration is broken or emulated.
> > +	 * Enforce it.
> > +	 */
> > +	if (early_cpu_to_node(cpu1) != early_cpu_to_node(cpu2)) {
> > +		pr_warning("CPU %d in node %d and CPU %d in node %d are siblings, forcing same node\n",
> > +			   cpu1, early_cpu_to_node(cpu1),
> > +			   cpu2, early_cpu_to_node(cpu2));
> > +		numa_set_node(cpu2, early_cpu_to_node(cpu1));
> > +	}
> >  }
> 
> ok, I'll test this. please wait half days.

Unfortunately, don't work.
full dmesg is below.

--------------------------------------------------------------------
 Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.39-rc1+ (kosaki@blackbird) (gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) ) #2 SMP Tue Apr 12 15:23:58 JST 2011
[    0.000000] Command line: ro root=/dev/mapper/vg_blackbird-lv_root rd_DM_UUID=ddf1_4c53492020202020808627c3000000004711471100000a28 rd_LVM_LV=vg_blackbird/lv_root rd_LVM_LV=vg_blackbird/lv_swap rd_NO_LUKS rd_NO_MD LANG=ja_JP.UTF-8 KEYTABLE=jp106 norhgb noquiet selinux=0  console=tty0 console=ttyS0,115200n8r numa=fake=4 memblock=debug sched_debug loglevel=8
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000096c00 (usable)
[    0.000000]  BIOS-e820: 0000000000096c00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000c8000 - 00000000000d0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fed0000 (usable)
[    0.000000]  BIOS-e820: 000000007fed0000 - 000000007fed8000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007fed8000 - 000000007fedb000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fedb000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000e4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000180000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: FUJITSU-SV      PRIMERGY                      /D2559-A1, BIOS 6.00 R1.02.2559.A1               12/07/2007
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x180000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 080000000 mask F80000000 uncachable
[    0.000000]   1 base 000000000 mask E00000000 write-back
[    0.000000]   2 base 07FF00000 mask FFFF00000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 2GB, range: 2GB, type UC
[    0.000000] reg 1, base: 0GB, range: 8GB, type WB
[    0.000000] reg 2, base: 2047MB, range: 1MB, type UC
[    0.000000] total RAM covered: 6143M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K  chunk_size: 2M  num_reg: 3      lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2047MB, range: 1MB, type UC
[    0.000000] reg 2, base: 4GB, range: 4GB, type WB
[    0.000000] e820 update range: 000000007ff00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x7fed0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f7a00] f7a00
[    0.000000]     memblock_x86_reserve_range: [0x000f7a00-0x000f7a0f]   * MP-table mpf
[    0.000000]     memblock_x86_reserve_range: [0x000970e1-0x0009724c]   * MP-table mpc
[    0.000000]     memblock_x86_reserve_range: [0x029bf000-0x029bf217]              BRK
[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0xffe56c00
[    0.000000]  memory.cnt  = 0x3
[    0.000000]  memory[0x0]     [0x00000000010000-0x00000000096bff], 0x86c00 bytes
[    0.000000]  memory[0x1]     [0x00000000100000-0x0000007fecffff], 0x7fdd0000 bytes
[    0.000000]  memory[0x2]     [0x00000100000000-0x0000017fffffff], 0x80000000 bytes
[    0.000000]  reserved.cnt  = 0x3
[    0.000000]  reserved[0x0]   [0x00000000096c00-0x000000000fffff], 0x69400 bytes
[    0.000000]  reserved[0x1]   [0x00000001000000-0x000000029bf217], 0x19bf218 bytes
[    0.000000]  reserved[0x2]   [0x00000037ae5000-0x00000037feffff], 0x50b000 bytes
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000]     memblock_x86_reserve_range: [0x00091000-0x00095fff]       TRAMPOLINE
[    0.000000] Base memory trampoline at [ffff880000091000] 91000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-000000007fed0000
[    0.000000]  0000000000 - 007fe00000 page 2M
[    0.000000]  007fe00000 - 007fed0000 page 4k
[    0.000000] kernel direct mapping tables up to 7fed0000 @ 7fecc000-7fed0000
[    0.000000]     memblock_x86_reserve_range: [0x7fecc000-0x7fecdfff]          PGTABLE
[    0.000000] init_memory_mapping: 0000000100000000-0000000180000000
[    0.000000]  0100000000 - 0180000000 page 2M
[    0.000000] kernel direct mapping tables up to 180000000 @ 17fff9000-180000000
[    0.000000]     memblock_x86_reserve_range: [0x17fff9000-0x17fffafff]          PGTABLE
[    0.000000] RAMDISK: 37ae5000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f79d0 00014 (v00 PTLTD )
[    0.000000] ACPI: RSDT 000000007fed30bc 00050 (v01 PTLTD    RSDT   00060000  LTP 00000000)
[    0.000000] ACPI: FACP 000000007fed7ba6 00074 (v01 FSC             00060000      000F4240)
[    0.000000] ACPI: DSDT 000000007fed310c 04A9A (v01 FSC    D2559    00060000 MSFT 03000001)
[    0.000000] ACPI: FACS 000000007fedafc0 00040
[    0.000000] ACPI: TCPA 000000007fed7c1a 00032 (v01 Phoeni  x       00060000  TL  00000000)
[    0.000000] ACPI: SSDT 000000007fed7c4c 0007A (v01 FSC    CST_CPU0 00060000  CSF 00000001)
[    0.000000] ACPI: SSDT 000000007fed7cc6 0007A (v01 FSC    CST_CPU1 00060000  CSF 00000001)
[    0.000000] ACPI: SSDT 000000007fed7d40 000B6 (v01 FSC    PST_CPU0 00060000  CSF 00000001)
[    0.000000] ACPI: SSDT 000000007fed7df6 000B6 (v01 FSC    PST_CPU1 00060000  CSF 00000001)
[    0.000000] ACPI: SPCR 000000007fed7eac 00050 (v01 PTLTD  $UCRTBL$ 00060000 PTL  00000001)
[    0.000000] ACPI: MCFG 000000007fed7efc 0003C (v01 PTLTD    MCFG   00060000  LTP 00000000)
[    0.000000] ACPI: HPET 000000007fed7f38 00038 (v01 PTLTD  HPETTBL  00060000  LTP 00000001)
[    0.000000] ACPI: APIC 000000007fed7f70 00068 (v01 PTLTD  ? APIC   00060000  LTP 00000000)
[    0.000000] ACPI: BOOT 000000007fed7fd8 00028 (v01 PTLTD  $SBFTBL$ 00060000  LTP 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000180000000
[    0.000000] Faking node 0 at 0000000000000000-0000000040000000 (1024MB)
[    0.000000] Faking node 1 at 0000000040000000-0000000100000000 (3072MB)
[    0.000000] Faking node 2 at 0000000100000000-0000000140000000 (1024MB)
[    0.000000] Faking node 3 at 0000000140000000-0000000180000000 (1024MB)
[    0.000000]     memblock_x86_reserve_range: [0x17ffff000-0x17ffff00f]        NUMA DIST
[    0.000000] NUMA: Initialized distance table, cnt=4
[    0.000000] NUMA: Using 30 for the hash shift.
[    0.000000] Initmem setup node 0 0000000000000000-0000000040000000
[    0.000000]     memblock_x86_reserve_range: [0x3ffd9000-0x3fffffff]        NODE_DATA
[    0.000000]   NODE_DATA [000000003ffd9000 - 000000003fffffff]
[    0.000000] Initmem setup node 1 0000000040000000-0000000100000000
[    0.000000]     memblock_x86_reserve_range: [0x7fea5000-0x7fecbfff]        NODE_DATA
[    0.000000]   NODE_DATA [000000007fea5000 - 000000007fecbfff]
[    0.000000] Initmem setup node 2 0000000100000000-0000000140000000
[    0.000000]     memblock_x86_reserve_range: [0x13ffd9000-0x13fffffff]        NODE_DATA
[    0.000000]   NODE_DATA [000000013ffd9000 - 000000013fffffff]
[    0.000000] Initmem setup node 3 0000000140000000-0000000180000000
[    0.000000]     memblock_x86_reserve_range: [0x17ffd2000-0x17fff8fff]        NODE_DATA
[    0.000000]   NODE_DATA [000000017ffd2000 - 000000017fff8fff]
[    0.000000]     memblock_x86_reserve_range: [0x3ffd8000-0x3ffd8fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17fbd2000-0x17ffd1fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x3ffd7f40-0x3ffd7fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x7fecff40-0x7fecffff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x13ffd8f40-0x13ffd8fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17fffff40-0x17fffffff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17f7d2000-0x17fbd1fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x3ee00000-0x3fdfffff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x3ffd6000-0x3ffd6fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x3ffd5000-0x3ffd5fff]          BOOTMEM
[    0.000000]        memblock_x86_free_range: [0x3fc00000-0x3fdfffff]
[    0.000000]     memblock_x86_reserve_range: [0x7ee00000-0x7fdfffff]          BOOTMEM
[    0.000000]  [ffffea0000000000-ffffea0000dfffff] PMD -> [ffff88003ee00000-ffff88003fbfffff] on node 0
[    0.000000]        memblock_x86_free_range: [0x7fc00000-0x7fdfffff]
[    0.000000]     memblock_x86_reserve_range: [0x13ee00000-0x13fdfffff]          BOOTMEM
[    0.000000]  [ffffea0000e00000-ffffea0001bfffff] PMD -> [ffff88007ee00000-ffff88007fbfffff] on node 1
[    0.000000]        memblock_x86_free_range: [0x13fc00000-0x13fdfffff]
[    0.000000]     memblock_x86_reserve_range: [0x17e600000-0x17f5fffff]          BOOTMEM
[    0.000000]  [ffffea0003800000-ffffea00045fffff] PMD -> [ffff88013ee00000-ffff88013fbfffff] on node 2
[    0.000000]        memblock_x86_free_range: [0x17f400000-0x17f5fffff]
[    0.000000]  [ffffea0004600000-ffffea00053fffff] PMD -> [ffff88017e600000-ffff88017f3fffff] on node 3
[    0.000000]        memblock_x86_free_range: [0x17f7d2000-0x17fbd1fff]
[    0.000000]        memblock_x86_free_range: [0x17fbd2000-0x17ffd1fff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00180000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000096
[    0.000000]     0: 0x00000100 -> 0x00040000
[    0.000000]     1: 0x00040000 -> 0x0007fed0
[    0.000000]     2: 0x00100000 -> 0x00140000
[    0.000000]     3: 0x00140000 -> 0x00180000
[    0.000000] On node 0 totalpages: 262022
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]     memblock_x86_reserve_range: [0x3ff7d000-0x3ffd4fff]          BOOTMEM
[    0.000000]   DMA32 zone: 3528 pages used for memmap
[    0.000000]   DMA32 zone: 254520 pages, LIFO batch:31
[    0.000000]     memblock_x86_reserve_range: [0x3ff25000-0x3ff7cfff]          BOOTMEM
[    0.000000] On node 1 totalpages: 261840
[    0.000000]   DMA32 zone: 3580 pages used for memmap
[    0.000000]   DMA32 zone: 258260 pages, LIFO batch:31
[    0.000000]     memblock_x86_reserve_range: [0x7fe4d000-0x7fea4fff]          BOOTMEM
[    0.000000] On node 2 totalpages: 262144
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 258560 pages, LIFO batch:31
[    0.000000]     memblock_x86_reserve_range: [0x13ff80f40-0x13ffd8f3f]          BOOTMEM
[    0.000000] On node 3 totalpages: 262144
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 258560 pages, LIFO batch:31
[    0.000000]     memblock_x86_reserve_range: [0x17ff7a000-0x17ffd1fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17fffe000-0x17fffefff]          BOOTMEM
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000]     memblock_x86_reserve_range: [0x17ffffec0-0x17fffff00]          BOOTMEM
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000]     memblock_x86_reserve_range: [0x17ffffe40-0x17ffffe82]          BOOTMEM
[    0.000000] nr_irqs_gsi: 40
[    0.000000]     memblock_x86_reserve_range: [0x17ffffb00-0x17ffffe0f]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ffffa80-0x17ffffae7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ffffa00-0x17ffffa67]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ffff980-0x17ffff9e7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ffff900-0x17ffff967]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ffff880-0x17ffff8e7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ffff800-0x17ffff867]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ffff780-0x17ffff7e7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ffff700-0x17ffff767]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ffff680-0x17ffff6e7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ffff600-0x17ffff667]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ffff580-0x17ffff5e7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ffff500-0x17ffff567]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ffff480-0x17ffff4e7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ffff440-0x17ffff45f]          BOOTMEM
[    0.000000] PM: Registered nosave memory: 0000000000096000 - 0000000000097000
[    0.000000] PM: Registered nosave memory: 0000000000097000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000c8000
[    0.000000] PM: Registered nosave memory: 00000000000c8000 - 00000000000d0000
[    0.000000] PM: Registered nosave memory: 00000000000d0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000]     memblock_x86_reserve_range: [0x17ffff400-0x17ffff41f]          BOOTMEM
[    0.000000] PM: Registered nosave memory: 000000007fed0000 - 000000007fed8000
[    0.000000] PM: Registered nosave memory: 000000007fed8000 - 000000007fedb000
[    0.000000] PM: Registered nosave memory: 000000007fedb000 - 0000000080000000
[    0.000000] PM: Registered nosave memory: 0000000080000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000e4000000
[    0.000000] PM: Registered nosave memory: 00000000e4000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffb00000
[    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000]     memblock_x86_reserve_range: [0x17ffff280-0x17ffff3cc]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ffff100-0x17ffff24c]          BOOTMEM
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:4
[    0.000000]     memblock_x86_reserve_range: [0x17fffd000-0x17fffdfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17fffc000-0x17fffcfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x3fc00000-0x3fdfffff]          BOOTMEM
[    0.000000]        memblock_x86_free_range: [0x3fddc000-0x3fdfffff]
[    0.000000]     memblock_x86_reserve_range: [0x7fc00000-0x7fdfffff]          BOOTMEM
[    0.000000]        memblock_x86_free_range: [0x7fddc000-0x7fdfffff]
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88003fc00000 s1920064 r8192 d21440 u2097152
[    0.000000]     memblock_x86_reserve_range: [0x17ffff0c0-0x17ffff0cf]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ffff080-0x17ffff08f]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ffff040-0x17ffff047]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17fffbfc0-0x17fffbfcf]          BOOTMEM
[    0.000000] pcpu-alloc: s1920064 r8192 d21440 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [1] 1
[    0.000000]     memblock_x86_reserve_range: [0x17fffbe40-0x17fffbf8f]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17fffbdc0-0x17fffbe3f]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17fffbd40-0x17fffbdbf]          BOOTMEM
[    0.000000]        memblock_x86_free_range: [0x17fffd000-0x17fffdfff]
[    0.000000]        memblock_x86_free_range: [0x17fffc000-0x17fffcfff]
[    0.000000]     memblock_x86_reserve_range: [0x17fffde00-0x17fffdfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17fffdc00-0x17fffddff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17fffda00-0x17fffdbff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17fffd800-0x17fffd9ff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17fffd600-0x17fffd7ff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17fffd400-0x17fffd5ff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17fffd200-0x17fffd3ff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17fffd000-0x17fffd1ff]          BOOTMEM
[    0.000000] Built 4 zonelists in Node order, mobility grouping on.  Total pages: 1033813
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: ro root=/dev/mapper/vg_blackbird-lv_root rd_DM_UUID=ddf1_4c53492020202020808627c3000000004711471100000a28 rd_LVM_LV=vg_blackbird/lv_root rd_LVM_LV=vg_blackbird/lv_swap rd_NO_LUKS rd_NO_MD LANG=ja_JP.UTF-8 KEYTABLE=jp106 norhgb noquiet selinux=0  console=tty0 console=ttyS0,115200n8r numa=fake=4 memblock=debug sched_debug loglevel=8
[    0.000000]     memblock_x86_reserve_range: [0x17ff72000-0x17ff79fff]          BOOTMEM
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000]     memblock_x86_reserve_range: [0x7ae00000-0x7edfffff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ff52000-0x17ff71fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x17ff12000-0x17ff51fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x7fe45000-0x7fe4cfff]          BOOTMEM
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (41 early reservations)
[    0.000000]   [0000091000-0000095fff]
[    0.000000]   [0000096c00-00000fffff]
[    0.000000]   [0001000000-00029bf217]
[    0.000000]   [0037ae5000-0037feffff]
[    0.000000]   [003ee00000-003fddbfff]
[    0.000000]   [003ff25000-003ffd6fff]
[    0.000000]   [003ffd7f40-003fffffff]
[    0.000000]   [007ae00000-007fddbfff]
[    0.000000]   [007fe45000-007fecdfff]
[    0.000000]   [007fecff40-007fecffff]
[    0.000000]   [013ee00000-013fbfffff]
[    0.000000]   [013ff80f40-013fffffff]
[    0.000000]   [017e600000-017f3fffff]
[    0.000000]   [017ff12000-017fffafff]
[    0.000000]   [017fffbd40-017fffbf8f]
[    0.000000]   [017fffbfc0-017fffbfcf]
[    0.000000]   [017fffd000-017ffff00f]
[    0.000000]   [017ffff040-017ffff047]
[    0.000000]   [017ffff080-017ffff08f]
[    0.000000]   [017ffff0c0-017ffff0cf]
[    0.000000]   [017ffff100-017ffff24c]
[    0.000000]   [017ffff280-017ffff3cc]
[    0.000000]   [017ffff400-017ffff41f]
[    0.000000]   [017ffff440-017ffff45f]
[    0.000000]   [017ffff480-017ffff4e7]
[    0.000000]   [017ffff500-017ffff567]
[    0.000000]   [017ffff580-017ffff5e7]
[    0.000000]   [017ffff600-017ffff667]
[    0.000000]   [017ffff680-017ffff6e7]
[    0.000000]   [017ffff700-017ffff767]
[    0.000000]   [017ffff780-017ffff7e7]
[    0.000000]   [017ffff800-017ffff867]
[    0.000000]   [017ffff880-017ffff8e7]
[    0.000000]   [017ffff900-017ffff967]
[    0.000000]   [017ffff980-017ffff9e7]
[    0.000000]   [017ffffa00-017ffffa67]
[    0.000000]   [017ffffa80-017ffffae7]
[    0.000000]   [017ffffb00-017ffffe0f]
[    0.000000]   [017ffffe40-017ffffe82]
[    0.000000]   [017ffffec0-017fffff00]
[    0.000000]   [017fffff40-017fffffff]
[    0.000000] Memory: 4031472k/6291456k available (5860k kernel code, 2098856k absent, 161128k reserved, 6563k data, 3476k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU debugfs-based tracing is enabled.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  RCU lockdep checking is enabled.
[    0.000000] NR_IRQS:262400 nr_irqs:512 16
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
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2992.551 MHz processor.
[    0.003004] Calibrating delay loop (skipped), value calculated using timer frequency.. 5985.10 BogoMIPS (lpj=2992551)
[    0.005005] pid_max: default: 32768 minimum: 301
[    0.010047] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.013270] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.014790] Mount-cache hash table entries: 256
[    0.017069] Initializing cgroup subsys debug
[    0.018007] Initializing cgroup subsys ns
[    0.019005] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.020005] Initializing cgroup subsys cpuacct
[    0.021013] Initializing cgroup subsys memory
[    0.023011] Initializing cgroup subsys devices
[    0.024008] Initializing cgroup subsys freezer
[    0.025006] Initializing cgroup subsys net_cls
[    0.026006] Initializing cgroup subsys blkio
[    0.027036] Initializing cgroup subsys perf_event
[    0.029169] CPU: Physical Processor ID: 0
[    0.030004] CPU: Processor Core ID: 0
[    0.031004] mce: CPU supports 6 MCE banks
[    0.032009] CPU0: Thermal monitoring enabled (TM2)
[    0.033006] using mwait in idle threads.
[    0.034004] numa_add_cpu cpu 0 node 0: mask now
[    0.036013] numa_add_cpu cpu 0 node 0: mask now 0
[    0.037003] numa_add_cpu cpu 0 node 0: mask now 0
[    0.038003] numa_add_cpu cpu 0 node 0: mask now 0
[    0.040444] ACPI: Core revision 20110316
[    0.059050] ftrace: allocating 20441 entries in 81 pages
[    0.061243] Setting APIC routing to flat
[    0.063427] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.074295] CPU0: Intel(R) Xeon(R) CPU            3085  @ 3.00GHz stepping 0b
[    0.077993] APIC calibration not consistent with PM-Timer: 217ms instead of 100ms
[    0.077993] APIC delta adjusted to PM-Timer: 2078121 (4530255)
[    0.078012] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.081996] PEBS disabled due to CPU errata.
[    0.082999] ... version:                2
[    0.083996] ... bit width:              40
[    0.084996] ... generic registers:      2
[    0.085996] ... value mask:             000000ffffffffff
[    0.086995] ... max period:             000000007fffffff
[    0.087995] ... fixed-purpose events:   3
[    0.088995] ... event mask:             0000000700000003
[    0.092224] NMI watchdog enabled, takes one hw-pmu counter.
[    0.095207] lockdep: fixing up alternatives.
[    0.096232] Booting Node   1, Processors  #1 Ok.
[    0.097996] smpboot cpu 1: start_ip = 91000
[    0.003999] numa_add_cpu cpu 1 node 1: mask now
[    0.003999] numa_add_cpu cpu 1 node 1: mask now 1
[    0.003999] numa_add_cpu cpu 1 node 1: mask now 1
[    0.003999] numa_add_cpu cpu 1 node 1: mask now 1
[    0.192119] NMI watchdog enabled, takes one hw-pmu counter.
[    0.193076] Brought up 2 CPUs
[    0.193984] Total of 2 processors activated (11970.06 BogoMIPS).
[    0.196303] CPU0 attaching sched-domain:
[    0.196986]  domain 0: span 0-1 level MC
[    0.198983]   groups: 0 1
[    0.200983]   domain 1: span 0-1 level NODE
[    0.202982]    groups:
[    0.204316] ERROR: domain->cpu_power not set
[    0.204982]
[    0.205981] ERROR: groups don't span domain->span
[    0.207982] CPU1 attaching sched-domain:
[    0.208983]  domain 0: span 0-1 level MC
[    0.210981]   groups: 1 0
[    0.213314]   domain 1: span 0-1 level NODE
[    0.214980]    groups: 1 (cpu_power = 2048)
[    0.218979] ERROR: domain->cpu_power not set
[    0.219979]
[    0.220979] ERROR: groups don't span domain->span
[    0.222122] divide error: 0000 [#1] SMP
[    0.222975] last sysfs file:
[    0.222975] CPU 0
[    0.222975] Modules linked in:
[    0.222975]
[    0.222975] Pid: 1, comm: swapper Not tainted 2.6.39-rc1+ #2 FUJITSU-SV      PRIMERGY                      /D2559-A1
[    0.222975] RIP: 0010:[<ffffffff81085e74>]  [<ffffffff81085e74>] find_busiest_group+0x464/0xeb0
[    0.222975] RSP: 0018:ffff88003c1357e0  EFLAGS: 00010046
[    0.222975] RAX: 0000000000000000 RBX: 00000000001d3e40 RCX: 0000000000000000
[    0.222975] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
[    0.222975] RBP: ffff88003c1359a0 R08: 0000000000000000 R09: 0000000000000000
[    0.222975] R10: 0000000000000400 R11: 0000000000000000 R12: 00000000001d3e40
[    0.222975] R13: 00000000ffffffff R14: ffff88003c111980 R15: 0000000000000001
[    0.222975] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[    0.222975] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.222975] CR2: 0000000000000000 CR3: 0000000001a03000 CR4: 00000000000006f0
[    0.222975] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.222975] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.222975] Process swapper (pid: 1, threadinfo ffff88003c134000, task ffff88003c130040)
[    0.222975] Stack:
[    0.222975]  0000000000000001 ffff88003c135930 ffff88003c135810 ffff88003fc00000
[    0.222975]  0000000000000000 00000000001d3e40 ffff88003c135a98 0100000000000002
[    0.222975]  ffff88003c135b6c 0000000000000000 ffff88003fc0eba0 000000003c130040
[    0.222975] Call Trace:
[    0.222975]  [<ffffffff810c2b3f>] ? local_clock+0x6f/0x80
[    0.222975]  [<ffffffff8108cb6d>] load_balance+0xbd/0x9d0
[    0.222975]  [<ffffffff810d0d8d>] ? trace_hardirqs_off+0xd/0x10
[    0.222975]  [<ffffffff810c2b3f>] ? local_clock+0x6f/0x80
[    0.222975]  [<ffffffff8107e972>] ? update_shares+0x162/0x1a0
[    0.222975]  [<ffffffff8107e98a>] ? update_shares+0x17a/0x1a0
[    0.222975]  [<ffffffff815a9037>] schedule+0xa77/0xb20
[    0.222975]  [<ffffffff810d5234>] ? __lock_acquire+0x584/0x1f20
[    0.222975]  [<ffffffff810c2b3f>] ? local_clock+0x6f/0x80
[    0.222975]  [<ffffffff815a9a05>] schedule_timeout+0x265/0x320
[    0.222975]  [<ffffffff810d0d8d>] ? trace_hardirqs_off+0xd/0x10
[    0.222975]  [<ffffffff810c2b3f>] ? local_clock+0x6f/0x80
[    0.222975]  [<ffffffff810d0dc5>] ? lock_release_holdtime+0x35/0x1a0
[    0.222975]  [<ffffffff815ac480>] ? _raw_spin_unlock_irq+0x30/0x40
[    0.222975]  [<ffffffff815ac480>] ? _raw_spin_unlock_irq+0x30/0x40
[    0.222975]  [<ffffffff815a94e0>] wait_for_common+0x130/0x190
[    0.222975]  [<ffffffff8108e120>] ? try_to_wake_up+0x510/0x510
[    0.222975]  [<ffffffff815a961d>] wait_for_completion+0x1d/0x20
[    0.222975]  [<ffffffff810bb55c>] kthread_create_on_node+0xac/0x150
[    0.222975]  [<ffffffff810b3e70>] ? process_scheduled_works+0x40/0x40
[    0.222975]  [<ffffffff815a93ff>] ? wait_for_common+0x4f/0x190
[    0.222975]  [<ffffffff810b6523>] __alloc_workqueue_key+0x1a3/0x590
[    0.222975]  [<ffffffff81e12643>] cpuset_init_smp+0x6b/0x7b
[    0.222975]  [<ffffffff81df8cf1>] kernel_init+0xc3/0x182
[    0.222975]  [<ffffffff815b6024>] kernel_thread_helper+0x4/0x10
[    0.222975]  [<ffffffff815acc54>] ? retint_restore_args+0x13/0x13
[    0.222975]  [<ffffffff81df8c2e>] ? start_kernel+0x3f6/0x3f6
[    0.222975]  [<ffffffff815b6020>] ? gs_change+0x13/0x13
[    0.222975] Code: 50 fe ff ff 41 89 50 08 0f 1f 80 00 00 00 00 48 8b 95 b0 fe ff ff 48 8b 7d 98 48 8b 4d a0 44 8b 42 08 48 89 f8 31 d2 48 c1 e0 0a
[    0.222975]  f7 f0 48 85 c9 48 89 c6 49 89 c1 48 89 45 90 74 1f 48 8b 45
[    0.222975] RIP  [<ffffffff81085e74>] find_busiest_group+0x464/0xeb0
[    0.222975]  RSP <ffff88003c1357e0>
[    0.222975] divide error: 0000 [#2]
[    0.222975] ---[ end trace 93d72a36b9146f22 ]---
[    0.222989] swapper used greatest stack depth: 3496 bytes left
[    0.222998] Kernel panic - not syncing: Attempted to kill init!
[    0.223000] Pid: 1, comm: swapper Tainted: G      D     2.6.39-rc1+ #2
[    0.223001] Call Trace:
[    0.223004]  [<ffffffff815a825c>] panic+0x91/0x1ab
[    0.223006]  [<ffffffff815ac4c0>] ? _raw_write_unlock_irq+0x30/0x40
[    0.223009]  [<ffffffff8109b4c0>] ? do_exit+0x7f0/0x950
[    0.223011]  [<ffffffff8109b575>] do_exit+0x8a5/0x950
[    0.223013]  [<ffffffff815adc80>] oops_end+0xb0/0xf0
[    0.223016]  [<ffffffff8104102b>] die+0x5b/0x90
[    0.223018]  [<ffffffff815ad364>] do_trap+0xc4/0x170
[    0.223020]  [<ffffffff8103de4f>] do_divide_error+0x8f/0xb0
[    0.223022]  [<ffffffff81085e74>] ? find_busiest_group+0x464/0xeb0
[    0.223025]  [<ffffffff812cd69d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[    0.223027]  [<ffffffff815acc84>] ? restore_args+0x30/0x30
[    0.223029]  [<ffffffff815b5e3b>] divide_error+0x1b/0x20
[    0.223031]  [<ffffffff81085e74>] ? find_busiest_group+0x464/0xeb0
[    0.223034]  [<ffffffff810c2b3f>] ? local_clock+0x6f/0x80
[    0.223036]  [<ffffffff8108cb6d>] load_balance+0xbd/0x9d0
[    0.223038]  [<ffffffff810d0d8d>] ? trace_hardirqs_off+0xd/0x10
[    0.223040]  [<ffffffff810c2b3f>] ? local_clock+0x6f/0x80
[    0.223042]  [<ffffffff8107e972>] ? update_shares+0x162/0x1a0
[    0.223045]  [<ffffffff8107e98a>] ? update_shares+0x17a/0x1a0
[    0.223047]  [<ffffffff815a9037>] schedule+0xa77/0xb20
[    0.223049]  [<ffffffff810d5234>] ? __lock_acquire+0x584/0x1f20
[    0.223051]  [<ffffffff810c2b3f>] ? local_clock+0x6f/0x80
[    0.223053]  [<ffffffff815a9a05>] schedule_timeout+0x265/0x320
[    0.223055]  [<ffffffff810d0d8d>] ? trace_hardirqs_off+0xd/0x10
[    0.223057]  [<ffffffff810c2b3f>] ? local_clock+0x6f/0x80
[    0.223059]  [<ffffffff810d0dc5>] ? lock_release_holdtime+0x35/0x1a0
[    0.223061]  [<ffffffff815ac480>] ? _raw_spin_unlock_irq+0x30/0x40
[    0.223063]  [<ffffffff815ac480>] ? _raw_spin_unlock_irq+0x30/0x40
[    0.223065]  [<ffffffff815a94e0>] wait_for_common+0x130/0x190
[    0.223067]  [<ffffffff8108e120>] ? try_to_wake_up+0x510/0x510
[    0.223069]  [<ffffffff815a961d>] wait_for_completion+0x1d/0x20
[    0.223071]  [<ffffffff810bb55c>] kthread_create_on_node+0xac/0x150
[    0.223074]  [<ffffffff810b3e70>] ? process_scheduled_works+0x40/0x40
[    0.223076]  [<ffffffff815a93ff>] ? wait_for_common+0x4f/0x190
[    0.223079]  [<ffffffff810b6523>] __alloc_workqueue_key+0x1a3/0x590
[    0.223081]  [<ffffffff81e12643>] cpuset_init_smp+0x6b/0x7b
[    0.223083]  [<ffffffff81df8cf1>] kernel_init+0xc3/0x182
[    0.223085]  [<ffffffff815b6024>] kernel_thread_helper+0x4/0x10
[    0.223087]  [<ffffffff815acc54>] ? retint_restore_args+0x13/0x13
[    0.223090]  [<ffffffff81df8c2e>] ? start_kernel+0x3f6/0x3f6
[    0.223092]  [<ffffffff815b6020>] ? gs_change+0x13/0x13
[    0.222975] SMP
[    0.222975] last sysfs file:
[    0.222975] CPU 1
[    0.222975] Modules linked in:
[    0.222975]
[    0.222975] Pid: 2, comm: kthreadd Tainted: G      D     2.6.39-rc1+ #2 FUJITSU-SV      PRIMERGY                      /D2559-A1
[    0.222975] RIP: 0010:[<ffffffff81085015>]  [<ffffffff81085015>] select_task_rq_fair+0x845/0xb70
[    0.222975] RSP: 0000:ffff88003c137bc0  EFLAGS: 00010046
[    0.222975] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[    0.222975] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000002
[    0.222975] RBP: ffff88003c137c70 R08: ffff88007ab109a0 R09: 0000000000000000
[    0.222975] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88007ab109a0
[    0.222975] R13: ffff88007ab10988 R14: 0000000000000000 R15: 0000000000000000
[    0.222975] FS:  0000000000000000(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[    0.222975] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.222975] CR2: 0000000000000000 CR3: 0000000001a03000 CR4: 00000000000006e0
[    0.222975] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.222975] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.222975] Process kthreadd (pid: 2, threadinfo ffff88003c136000, task ffff88003c138080)
[    0.222975] Stack:
[    0.222975]  ffffffff815ac4c0 000000007ab466e8 ffff880000000002 0000000000000000
[    0.222975]  00000000001d3e40 000000000000007d 0000000000000200 ffffffffffffffff
[    0.222975]  0000000000000000 0000000000000008 000000013c137c40 ffffffff00000001
[    0.222975] Call Trace:
[    0.222975]  [<ffffffff815ac4c0>] ? _raw_write_unlock_irq+0x30/0x40
[    0.222975]  [<ffffffff8108e571>] wake_up_new_task+0x41/0x1b0
[    0.222975]  [<ffffffff810b72f0>] ? __task_pid_nr_ns+0xc0/0x100
[    0.222975]  [<ffffffff810b7230>] ? cpumask_weight+0x20/0x20
[    0.222975]  [<ffffffff81095522>] do_fork+0xe2/0x3a0
[    0.222975]  [<ffffffff815ac480>] ? _raw_spin_unlock_irq+0x30/0x40
[    0.222975]  [<ffffffff815ac480>] ? _raw_spin_unlock_irq+0x30/0x40
[    0.222975]  [<ffffffff81044905>] ? native_sched_clock+0x15/0x70
[    0.222975]  [<ffffffff810c2b3f>] ? local_clock+0x6f/0x80
[    0.222975]  [<ffffffff81045776>] kernel_thread+0x76/0x80
[    0.222975]  [<ffffffff810bb260>] ? __init_kthread_worker+0x70/0x70
[    0.222975]  [<ffffffff815b6020>] ? gs_change+0x13/0x13
[    0.222975]  [<ffffffff810bb783>] kthreadd+0x133/0x170
[    0.222975]  [<ffffffff815b6024>] kernel_thread_helper+0x4/0x10
[    0.222975]  [<ffffffff815acc54>] ? retint_restore_args+0x13/0x13
[    0.222975]  [<ffffffff810bb650>] ? tsk_fork_get_node+0x30/0x30
[    0.222975]  [<ffffffff815b6020>] ? gs_change+0x13/0x13
[    0.222975] Code: ff 89 8d 60 ff ff ff e8 3a 26 ff ff 8b 8d 60 ff ff ff 8b 95 68 ff ff ff eb 94 0f 1f 40 00 41 8b 4d 08 48 89 d8 31 d2 48 c1 e0 0a
[    0.222975]  f7 f1 45 85 f6 75 43 48 3b 45 88 0f 83 d9 fe ff ff 48 8b 55
[    0.222975] RIP  [<ffffffff81085015>] select_task_rq_fair+0x845/0xb70
[    0.222975]  RSP <ffff88003c137bc0>
[    0.222975] ---[ end trace 93d72a36b9146f23 ]---



