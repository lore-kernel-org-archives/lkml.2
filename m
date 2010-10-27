Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab0J0U4C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 16:56:02 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53719 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0J0Uz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 16:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YHBI42GBV6f5j5Y4Lg4HTG8uLFTvZwTa/bOzzvKgfp+TVW32QdgAgdX3fgU5b5Hc2s
         xjyD7potaMo0jlb3tl5GBa7vryKiAB+J4Hkn2MdcjvtyFnleGXq4ugnYV4lL1pcnvmiu
         vuwNZF4zZmrQObcgJxVkIdfcXqTAN95DfyAVY=
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@elte.hu
In-Reply-To: <4CC846D5.50106@kernel.org>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
	 <1288158182-1753-1-git-send-email-brgerst@gmail.com>
	 <1288159670.2652.181.camel@edumazet-laptop>
	 <1288173442.15336.1490.camel@twins>
	 <1288186405.2709.117.camel@edumazet-laptop>  <4CC82C2F.1020707@kernel.org>
	 <1288187870.2709.128.camel@edumazet-laptop>  <4CC83067.5000009@kernel.org>
	 <1288189461.2709.144.camel@edumazet-laptop>
	 <1288190387.2709.147.camel@edumazet-laptop>  <4CC83A85.3070608@kernel.org>
	 <1288192868.2709.152.camel@edumazet-laptop>  <4CC846D5.50106@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 22:55:51 +0200
Message-ID: <1288212951.2658.51.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 octobre 2010 à 17:35 +0200, Tejun Heo a écrit :

> Hmmm, okay.  Can you please print out early_cpu_to_node() output for
> each cpu from arch/x86/kernel/setup_percpu.c::setup_per_cpu_areas()?
> BTW, some clarifications.
> 
> * In the pcpu-alloc debug message, the n of [n] might not necessarily
>   match the NUMA node.
> 
> * I was confused before.  If CPU distance reported by
>   early_cpu_to_node() is greater than LOCAL_DISTANCE (ie. NUMA
>   configuration), cpus will always belong to different [n].  What gets
>   adjusted is the size of each unit.
> 
> * No matter what, here, the end result is correct.  As there's no low
>   memory on node 1, it doesn't matter how the groups are organized in
>   the first chunk as long as embedding is used.  And for other chunks,
>   pages for each cpu are allocated separatedly w/ cpu_to_node() anyway
>   so NUMA affinity will be correct, again, regardless of the group
>   organization.
> 
> Thanks.
> 

Hi Tejun

I changed the User/Kernel split from 3G/1G to 1G/3G so that I have
LOWMEM on both nodes. Still pcpu allocates all percpu from node0.

With following patch :

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 002b796..0611256 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -212,6 +212,7 @@ void __init setup_per_cpu_areas(void)
 		per_cpu(cpu_number, cpu) = cpu;
 		setup_percpu_segment(cpu);
 		setup_stack_canary_segment(cpu);
+		pr_err("cpu=%d early_cpu_to_node()=%d\n", cpu, early_cpu_to_node(cpu));
 		/*
 		 * Copy data used in early init routines from the
 		 * initial arrays to the per cpu data areas.  These


I get :

[    0.000000] Linux version 2.6.36-06800-g80ca147-dirty (root@svivoipvnx021) (gcc version 4.5.1 (GCC) ) #200 SMP Wed Oct 27 22:40:59 CEST 2010
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000df62f000 (usable)
[    0.000000]  BIOS-e820: 00000000df62f000 - 00000000df63c000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df63c000 - 00000000df63d000 (usable)
[    0.000000]  BIOS-e820: 00000000df63d000 - 00000000e4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000011ffff000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x11ffff max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [400f4f80] f4f80
[    0.000000] initial memory mapped : 0 - 01e00000
[    0.000000] init_memory_mapping: 0000000000000000-00000000b71fe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 00b7000000 page 2M
[    0.000000]  00b7000000 - 00b71fe000 page 4k
[    0.000000] kernel direct mapping tables up to b71fe000 @ 1df4000-1e00000
[    0.000000] RAMDISK: 37f75000 - 37ff0000
[    0.000000] ACPI: RSDP 000f4f00 00024 (v02 HP    )
[    0.000000] ACPI: XSDT df630080 000AC (v01 HP     ProLiant 00000002   �? 0000162E)
[    0.000000] ACPI: FACP df630180 000F4 (v03 HP     ProLiant 00000002   �? 0000162E)
[    0.000000] ACPI Warning: Invalid length for Pm1aControlBlock: 32, using default 16 (20101013/tbfadt-607)
[    0.000000] ACPI Warning: Invalid length for Pm2ControlBlock: 32, using default 8 (20101013/tbfadt-607)
[    0.000000] ACPI: DSDT df630280 01F88 (v01 HP         DSDT 00000001 INTL 20030228)
[    0.000000] ACPI: FACS df62f100 00040
[    0.000000] ACPI: SPCR df62f140 00050 (v01 HP     SPCRRBSU 00000001   �? 0000162E)
[    0.000000] ACPI: MCFG df62f1c0 0003C (v01 HP     ProLiant 00000001      00000000)
[    0.000000] ACPI: HPET df62f200 00038 (v01 HP     ProLiant 00000002   �? 0000162E)
[    0.000000] ACPI: FFFF df62f240 00064 (v02 HP     ProLiant 00000002   �? 0000162E)
[    0.000000] ACPI: SPMI df62f2c0 00040 (v05 HP     ProLiant 00000001   �? 0000162E)
[    0.000000] ACPI: ERST df62f300 001D0 (v01 HP     ProLiant 00000001   �? 0000162E)
[    0.000000] ACPI: APIC df62f500 0015E (v01 HP     ProLiant 00000002      00000000)
[    0.000000] ACPI: SRAT df62f680 00570 (v01 HP     Proliant 00000001   �? 0000162E)
[    0.000000] ACPI: FFFF df62fc00 00176 (v01 HP     ProLiant 00000001   �? 0000162E)
[    0.000000] ACPI: BERT df62fd80 00030 (v01 HP     ProLiant 00000001   �? 0000162E)
[    0.000000] ACPI: HEST df62fdc0 000BC (v01 HP     ProLiant 00000001   �? 0000162E)
[    0.000000] ACPI: DMAR df62fe80 00154 (v01 HP     ProLiant 00000001   �? 0000162E)
[    0.000000] ACPI: SSDT df632240 00125 (v03     HP  CRSPCI0 00000002   HP 00000001)
[    0.000000] ACPI: SSDT df632380 003BB (v01     HP      pcc 00000001 INTL 20090625)
[    0.000000] ACPI: SSDT df632740 00377 (v01     HP     pmab 00000001 INTL 20090625)
[    0.000000] ACPI: SSDT df632ac0 02B64 (v01  INTEL PPM RCM  00000001 INTL 20061109)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] CPU 00 in proximity domain 00
[    0.000000] CPU 01 in proximity domain 00
[    0.000000] CPU 02 in proximity domain 00
[    0.000000] CPU 03 in proximity domain 00
[    0.000000] CPU 04 in proximity domain 00
[    0.000000] CPU 05 in proximity domain 00
[    0.000000] CPU 06 in proximity domain 00
[    0.000000] CPU 07 in proximity domain 00
[    0.000000] CPU 10 in proximity domain 01
[    0.000000] CPU 11 in proximity domain 01
[    0.000000] CPU 12 in proximity domain 01
[    0.000000] CPU 13 in proximity domain 01
[    0.000000] CPU 14 in proximity domain 01
[    0.000000] CPU 15 in proximity domain 01
[    0.000000] CPU 16 in proximity domain 01
[    0.000000] CPU 17 in proximity domain 01
[    0.000000] Memory range 00000000 to 00080000 in proximity domain 00 enabled
[    0.000000] Memory range 00080000 to 000e0000 in proximity domain 01 enabled
[    0.000000] Memory range 00100000 to 00120000 in proximity domain 01 enabled
[    0.000000] pxm bitmap: 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
[    0.000000] Number of logical nodes in system = 2
[    0.000000] Number of memory chunks in system = 3
[    0.000000] chunk 0 nid 0 start_pfn 00000000 end_pfn 00080000
[    0.000000] chunk 1 nid 1 start_pfn 00080000 end_pfn 000e0000
[    0.000000] chunk 2 nid 1 start_pfn 00100000 end_pfn 00120000
[    0.000000] Node: 0, start_pfn: 0, end_pfn: 80000
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   0 4000 8000 c000 10000 14000 18000 1c000 20000 24000 28000 2c000 30000 34000 38000 3c000 40000 44000 48000 4c000 50000 54000 58000 5c000 60000 64000 68000 6c000 70000 74000 78000 7c000 
[    0.000000] Node: 1, start_pfn: 80000, end_pfn: 11ffff
[    0.000000]   Setting physnode_map array to node 1 for pfns:
[    0.000000]   80000 84000 88000 8c000 90000 94000 98000 9c000 a0000 a4000 a8000 ac000 b0000 b4000 b8000 bc000 c0000 c4000 c8000 cc000 d0000 d4000 d8000 dc000 e0000 e4000 e8000 ec000 f0000 f4000 f8000 fc000 100000 104000 108000 10c000 110000 114000 118000 11c000 
[    0.000000] node 0 pfn: [0 - 80000]
[    0.000000] Reserving 4608 pages of KVA for lmem_map of node 0 at 7ee00
[    0.000000] node 1 pfn: [80000 - 120000]
[    0.000000] Reserving 5632 pages of KVA for lmem_map of node 1 at 11e800
[    0.000000] Reserving total of 2800 pages for numa KVA remap
[    0.000000] kva_start_pfn ~ b4800 max_low_pfn ~ b71fe
[    0.000000] max_pfn = 11ffff
[    0.000000] 1678MB HIGHMEM available.
[    0.000000] 2929MB LOWMEM available.
[    0.000000] max_low_pfn = b71fe, highstart_pfn = b71fe
[    0.000000] Low memory ends at vaddr f71fe000
[    0.000000] node 0 will remap to vaddr f4800000 - f5a00000
[    0.000000] allocate_pgdat: node 0 NODE_DATA f4800000
[    0.000000] node 1 will remap to vaddr f5a00000 - f7000000
[    0.000000] allocate_pgdat: node 1 NODE_DATA f5a00000
[    0.000000] remap_numa_kva: node 0
[    0.000000] remap_numa_kva: f4800000 to pfn 0007ee00
[    0.000000] remap_numa_kva: f4a00000 to pfn 0007f000
[    0.000000] remap_numa_kva: f4c00000 to pfn 0007f200
[    0.000000] remap_numa_kva: f4e00000 to pfn 0007f400
[    0.000000] remap_numa_kva: f5000000 to pfn 0007f600
[    0.000000] remap_numa_kva: f5200000 to pfn 0007f800
[    0.000000] remap_numa_kva: f5400000 to pfn 0007fa00
[    0.000000] remap_numa_kva: f5600000 to pfn 0007fc00
[    0.000000] remap_numa_kva: f5800000 to pfn 0007fe00
[    0.000000] remap_numa_kva: node 1
[    0.000000] remap_numa_kva: f5a00000 to pfn 0011e800
[    0.000000] remap_numa_kva: f5c00000 to pfn 0011ea00
[    0.000000] remap_numa_kva: f5e00000 to pfn 0011ec00
[    0.000000] remap_numa_kva: f6000000 to pfn 0011ee00
[    0.000000] remap_numa_kva: f6200000 to pfn 0011f000
[    0.000000] remap_numa_kva: f6400000 to pfn 0011f200
[    0.000000] remap_numa_kva: f6600000 to pfn 0011f400
[    0.000000] remap_numa_kva: f6800000 to pfn 0011f600
[    0.000000] remap_numa_kva: f6a00000 to pfn 0011f800
[    0.000000] remap_numa_kva: f6c00000 to pfn 0011fa00
[    0.000000] remap_numa_kva: f6e00000 to pfn 0011fc00
[    0.000000] High memory starts at vaddr f71fe000
[    0.000000]   mapped low ram: 0 - b71fe000
[    0.000000]   low ram: 0 - b71fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000b71fe
[    0.000000]   HighMem  0x000b71fe -> 0x0011ffff
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00080000
[    0.000000]     1: 0x00080000 -> 0x000df62f
[    0.000000]     1: 0x000df63c -> 0x000df63d
[    0.000000]     1: 0x00100000 -> 0x0011ffff
[    0.000000] On node 0 totalpages: 524175
[    0.000000] free_area_init_node: node 0, pgdat f4800000, node_mem_map f4802200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 4064 pages used for memmap
[    0.000000]   Normal zone: 516128 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 521775
[    0.000000] free_area_init_node: node 1, pgdat f5a00000, node_mem_map f5a02000
[    0.000000]   Normal zone: 1764 pages used for memmap
[    0.000000]   Normal zone: 224026 pages, LIFO batch:31
[    0.000000]   HighMem zone: 3357 pages used for memmap
[    0.000000]   HighMem zone: 292628 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x24] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x34] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x22] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x32] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x26] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x36] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x21] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x31] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x35] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x33] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x27] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x37] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 0, version 32, address 0xfec80000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 16 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] Allocating PCI resources starting at e4000000 (gap: e4000000:1ac00000)
[    0.000000] converting mcount calls to 0f 1f 44 00 00
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:16 nr_node_ids:8
[    0.000000] PERCPU: Embedded 16 pages/cpu @bea00000 s41984 r0 d23552 u131072
[    0.000000] pcpu-alloc: s41984 r0 d23552 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] setup_percpu: cpu=0 early_cpu_to_node()=0
[    0.000000] setup_percpu: cpu=1 early_cpu_to_node()=0
[    0.000000] setup_percpu: cpu=2 early_cpu_to_node()=0
[    0.000000] setup_percpu: cpu=3 early_cpu_to_node()=0
[    0.000000] setup_percpu: cpu=4 early_cpu_to_node()=0
[    0.000000] setup_percpu: cpu=5 early_cpu_to_node()=0
[    0.000000] setup_percpu: cpu=6 early_cpu_to_node()=0
[    0.000000] setup_percpu: cpu=7 early_cpu_to_node()=0
[    0.000000] setup_percpu: cpu=8 early_cpu_to_node()=0
[    0.000000] setup_percpu: cpu=9 early_cpu_to_node()=0
[    0.000000] setup_percpu: cpu=10 early_cpu_to_node()=0
[    0.000000] setup_percpu: cpu=11 early_cpu_to_node()=0
[    0.000000] setup_percpu: cpu=12 early_cpu_to_node()=0
[    0.000000] setup_percpu: cpu=13 early_cpu_to_node()=0
[    0.000000] setup_percpu: cpu=14 early_cpu_to_node()=0
[    0.000000] setup_percpu: cpu=15 early_cpu_to_node()=0
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 1036733
[    0.000000] Policy zone: HighMem
[    0.000000] Kernel command line: root=/dev/cciss/c0d0p2 nofb sysrq_always_enabled=1 vga=6 hashdist=1
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Initializing HighMem for node 1 (000b71fe:0011ffff)
[    0.000000] Memory: 4093536k/4718588k available (2921k kernel code, 67736k reserved, 2068k data, 420k init, 1161412k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xff577000 - 0xfffff000   (10784 kB)
[    0.000000]     pkmap   : 0xff200000 - 0xff400000   (2048 kB)
[    0.000000]     vmalloc : 0xf79fe000 - 0xff1fe000   ( 120 MB)
[    0.000000]     lowmem  : 0x40000000 - 0xf71fe000   (2929 MB)
[    0.000000]       .init : 0x414e0000 - 0x41549000   ( 420 kB)
[    0.000000]       .data : 0x412da723 - 0x414df8f8   (2068 kB)
[    0.000000]       .text : 0x41000000 - 0x412da723   (2921 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304
[    0.000000] CPU 0 irqstacks, hard=bea00000 soft=bea02000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x60
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2533.451 MHz processor.
[    0.000007] Calibrating delay loop (skipped), value calculated using timer frequency.. 5066.90 BogoMIPS (lpj=10133804)
[    0.000227] pid_max: default: 32768 minimum: 301
[    0.000373] Security Framework initialized
[    0.000477] SELinux:  Initializing.
[    0.000587] SELinux:  Starting in permissive mode
[    0.000696] Dentry cache hash table entries: 524288 (order: 9, 2097152 bytes)
[    0.001478] Inode-cache hash table entries: 262144 (order: 8, 1048576 bytes)
[    0.001908] Mount-cache hash table entries: 512
[    0.002152] CPU: Physical Processor ID: 1
[    0.002253] CPU: Processor Core ID: 0
[    0.002355] mce: CPU supports 9 MCE banks
[    0.002465] CPU0: Thermal monitoring enabled (TM1)
[    0.002575] using mwait in idle threads.
[    0.002679] Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
[    0.002902] ... version:                3
[    0.003004] ... bit width:              48
[    0.003105] ... generic registers:      4
[    0.003207] ... value mask:             0000ffffffffffff
[    0.003316] ... max period:             000000007fffffff
[    0.003426] ... fixed-purpose events:   3
[    0.003527] ... event mask:             000000070000000f
[    0.003912] Freeing SMP alternatives: 16k freed
[    0.004008] ACPI: Core revision 20101013
[    0.008688] Overriding APIC driver with bigsmp
[    0.008793] Enabling APIC mode:  Physflat.  Using 2 I/O APICs
[    0.009176] Leaving ESR disabled.
[    0.009274] Mapping cpu 0 to node 1
[    0.009539] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.049316] CPU0: Intel(R) Xeon(R) CPU           E5540  @ 2.53GHz stepping 05
[    0.157369] CPU 1 irqstacks, hard=bea20000 soft=bea22000
[    0.157372] Booting Node   0, Processors  #1
[    0.167896] Initializing CPU#1
[    0.168480] Leaving ESR disabled.
[    0.168483] Mapping cpu 1 to node 0
[    0.264905] CPU 2 irqstacks, hard=bea40000 soft=bea42000
[    0.265275]  #2
[    0.276090] Initializing CPU#2
[    0.276332] Leaving ESR disabled.
[    0.276334] Mapping cpu 2 to node 1
[    0.372880] CPU 3 irqstacks, hard=bea60000 soft=bea62000
[    0.373254]  #3
[    0.384173] Initializing CPU#3
[    0.384310] Leaving ESR disabled.
[    0.384313] Mapping cpu 3 to node 0
[    0.480803] CPU 4 irqstacks, hard=bea80000 soft=bea82000
[    0.481171]  #4
[    0.491497] Initializing CPU#4
[    0.492227] Leaving ESR disabled.
[    0.492229] Mapping cpu 4 to node 1
[    0.588747] CPU 5 irqstacks, hard=beaa0000 soft=beaa2000
[    0.589119]  #5
[    0.599503] Initializing CPU#5
[    0.600176] Leaving ESR disabled.
[    0.600178] Mapping cpu 5 to node 0
[    0.696707] CPU 6 irqstacks, hard=beac0000 soft=beac2000
[    0.697076]  #6
[    0.707401] Initializing CPU#6
[    0.708132] Leaving ESR disabled.
[    0.708134] Mapping cpu 6 to node 1
[    0.804673] CPU 7 irqstacks, hard=beae0000 soft=beae2000
[    0.805046]  #7
[    0.815429] Initializing CPU#7
[    0.816102] Leaving ESR disabled.
[    0.816105] Mapping cpu 7 to node 0
[    0.912500] CPU 8 irqstacks, hard=beb00000 soft=beb02000
[    0.912867]  #8
[    0.923731] Initializing CPU#8
[    0.923925] Leaving ESR disabled.
[    0.923928] Mapping cpu 8 to node 1
[    1.020523] CPU 9 irqstacks, hard=beb20000 soft=beb22000
[    1.020894]  #9
[    1.031277] Initializing CPU#9
[    1.031950] Leaving ESR disabled.
[    1.031953] Mapping cpu 9 to node 0
[    1.128415] CPU 10 irqstacks, hard=beb40000 soft=beb42000
[    1.128622]  #10
[    1.138939] Initializing CPU#10
[    1.139670] Leaving ESR disabled.
[    1.139672] Mapping cpu 10 to node 1
[    1.236377] CPU 11 irqstacks, hard=beb60000 soft=beb62000
[    1.236751]  #11
[    1.247135] Initializing CPU#11
[    1.247808] Leaving ESR disabled.
[    1.247811] Mapping cpu 11 to node 0
[    1.344334] CPU 12 irqstacks, hard=beb80000 soft=beb82000
[    1.344704]  #12
[    1.355029] Initializing CPU#12
[    1.355761] Leaving ESR disabled.
[    1.355762] Mapping cpu 12 to node 1
[    1.452301] CPU 13 irqstacks, hard=beba0000 soft=beba2000
[    1.452674]  #13
[    1.463594] Initializing CPU#13
[    1.463731] Leaving ESR disabled.
[    1.463734] Mapping cpu 13 to node 0
[    1.560218] CPU 14 irqstacks, hard=bebc0000 soft=bebc2000
[    1.560425]  #14
[    1.570742] Initializing CPU#14
[    1.571474] Leaving ESR disabled.
[    1.571475] Mapping cpu 14 to node 1
[    1.668181] CPU 15 irqstacks, hard=bebe0000 soft=bebe2000
[    1.668555]  #15 Ok.
[    1.678985] Initializing CPU#15
[    1.679658] Leaving ESR disabled.
[    1.679661] Mapping cpu 15 to node 0
[    1.775946] Brought up 16 CPUs
[    1.776333] Total of 16 processors activated (81068.16 BogoMIPS).
[    1.783989] kworker/u:0 used greatest stack depth: 7100 bytes left
[    1.784370] NET: Registered protocol family 16
[    1.784868] ACPI: bus type pci registered
[    1.785054] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    1.785133] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
[    1.785193] PCI: Using MMCONFIG for extended config space
[    1.785251] PCI: Using configuration type 1 for base access
[    1.789673] bio: create slab <bio-0> at 0
[    1.790492] ACPI: EC: Look up EC in DSDT
[    1.790617] ACPI Error: Field [CDW3] at 96 exceeds Buffer [NULL] size 64 (bits) (20101013/dsopcode-597)
[    1.790867] ACPI Error: Method parse/execution failed [\_SB_._OSC] (Node f45a7e90), AE_AML_BUFFER_LIMIT (20101013/psparse-537)
[    1.796427] ACPI: Interpreter enabled
[    1.796527] ACPI: (supports S0 S5)
[    1.796698] ACPI: Using IOAPIC for interrupt routing
[    1.802633] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.802734] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-12])
[    1.802860] pci_root PNP0A03:00: host bridge window [mem 0xe7000000-0xfbffffff]
[    1.802940] pci_root PNP0A03:00: host bridge window [io  0x1000-0x4fff]
[    1.803001] pci_root PNP0A03:00: host bridge window [io  0x0000-0x03af]
[    1.803061] pci_root PNP0A03:00: host bridge window [io  0x03e0-0x0cf7]
[    1.803122] pci_root PNP0A03:00: host bridge window [io  0x0d00-0x0fff]
[    1.803182] pci_root PNP0A03:00: host bridge window [mem 0xfed00000-0xfed03fff]
[    1.803258] pci_root PNP0A03:00: host bridge window [mem 0xfed00000-0xfed44fff]
[    1.803423] pci_root PNP0A03:00: host bridge window [io  0x03b0-0x03bb]
[    1.803541] pci_root PNP0A03:00: host bridge window [io  0x03c0-0x03df]
[    1.803659] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.803872] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.803875] pci 0000:00:00.0: PME# disabled
[    1.803928] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.803931] pci 0000:00:01.0: PME# disabled
[    1.803983] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    1.803986] pci 0000:00:02.0: PME# disabled
[    1.804038] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.804041] pci 0000:00:03.0: PME# disabled
[    1.804094] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    1.804097] pci 0000:00:07.0: PME# disabled
[    1.804148] pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
[    1.804151] pci 0000:00:08.0: PME# disabled
[    1.804207] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    1.804210] pci 0000:00:09.0: PME# disabled
[    1.804263] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    1.804269] pci 0000:00:0a.0: PME# disabled
[    1.804965] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.804968] pci 0000:00:1c.0: PME# disabled
[    1.805058] pci 0000:00:1d.0: reg 20: [io  0x1000-0x101f]
[    1.805183] pci 0000:00:1d.1: reg 20: [io  0x1020-0x103f]
[    1.805309] pci 0000:00:1d.2: reg 20: [io  0x1040-0x105f]
[    1.805435] pci 0000:00:1d.3: reg 20: [io  0x1060-0x107f]
[    1.805503] pci 0000:00:1d.7: reg 10: [mem 0xf35f0000-0xf35f03ff]
[    1.805569] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.805573] pci 0000:00:1d.7: PME# disabled
[    1.805782] pci 0000:02:00.0: reg 10: [mem 0xfb000000-0xfb7fffff 64bit]
[    1.805793] pci 0000:02:00.0: reg 18: [mem 0xfa800000-0xfaffffff 64bit]
[    1.805811] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    1.805836] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    1.805839] pci 0000:02:00.0: PME# disabled
[    1.805872] pci 0000:02:00.1: reg 10: [mem 0xfa000000-0xfa7fffff 64bit]
[    1.805883] pci 0000:02:00.1: reg 18: [mem 0xf9800000-0xf9ffffff 64bit]
[    1.805901] pci 0000:02:00.1: reg 30: [mem 0x00000000-0x0000ffff pref]
[    1.805926] pci 0000:02:00.1: PME# supported from D0 D3hot D3cold
[    1.805929] pci 0000:02:00.1: PME# disabled
[    1.805940] pci 0000:00:01.0: PCI bridge to [bus 02-02]
[    1.806051] pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.806054] pci 0000:00:01.0:   bridge window [mem 0xf3800000-0xfb7fffff]
[    1.806059] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.806090] pci 0000:00:02.0: PCI bridge to [bus 0d-0d]
[    1.806201] pci 0000:00:02.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.806205] pci 0000:00:02.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.806209] pci 0000:00:02.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.806240] pci 0000:00:03.0: PCI bridge to [bus 03-05]
[    1.806350] pci 0000:00:03.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.806354] pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.806358] pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.806389] pci 0000:00:07.0: PCI bridge to [bus 06-08]
[    1.806500] pci 0000:00:07.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.806503] pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.806508] pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.806539] pci 0000:00:08.0: PCI bridge to [bus 11-11]
[    1.806650] pci 0000:00:08.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.806653] pci 0000:00:08.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.806658] pci 0000:00:08.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.806735] pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
[    1.806739] pci 0000:09:00.0: PME# disabled
[    1.806749] pci 0000:00:09.0: PCI bridge to [bus 09-0b]
[    1.806859] pci 0000:00:09.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.806863] pci 0000:00:09.0:   bridge window [mem 0xfba00000-0xfbafffff]
[    1.806867] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.806923] pci 0000:0a:04.0: reg 10: [mem 0xfbaf0000-0xfbafffff 64bit]
[    1.806935] pci 0000:0a:04.0: reg 18: [mem 0xfbae0000-0xfbaeffff 64bit]
[    1.806955] pci 0000:0a:04.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.806977] pci 0000:0a:04.0: PME# supported from D3hot D3cold
[    1.806980] pci 0000:0a:04.0: PME# disabled
[    1.807018] pci 0000:0a:04.1: reg 10: [mem 0xfbad0000-0xfbadffff 64bit]
[    1.807030] pci 0000:0a:04.1: reg 18: [mem 0xfbac0000-0xfbacffff 64bit]
[    1.807050] pci 0000:0a:04.1: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.807072] pci 0000:0a:04.1: PME# supported from D3hot D3cold
[    1.807075] pci 0000:0a:04.1: PME# disabled
[    1.807113] pci 0000:09:00.0: PCI bridge to [bus 0a-0a]
[    1.807226] pci 0000:09:00.0:   bridge window [io  0xfffff000-0x0000] (disabled)
[    1.807230] pci 0000:09:00.0:   bridge window [mem 0xfba00000-0xfbafffff]
[    1.807235] pci 0000:09:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.807270] pci 0000:00:0a.0: PCI bridge to [bus 12-12]
[    1.807381] pci 0000:00:0a.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.807385] pci 0000:00:0a.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.807389] pci 0000:00:0a.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.807459] pci 0000:0c:00.0: reg 10: [mem 0xfbc00000-0xfbffffff 64bit]
[    1.807476] pci 0000:0c:00.0: reg 18: [mem 0xfbbf0000-0xfbbf0fff 64bit]
[    1.807487] pci 0000:0c:00.0: reg 20: [io  0x4000-0x40ff]
[    1.807508] pci 0000:0c:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    1.807541] pci 0000:0c:00.0: supports D1
[    1.807543] pci 0000:0c:00.0: PME# supported from D0
[    1.807547] pci 0000:0c:00.0: PME# disabled
[    1.807564] pci 0000:00:1c.0: PCI bridge to [bus 0c-0c]
[    1.807675] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    1.807678] pci 0000:00:1c.0:   bridge window [mem 0xfbb00000-0xfbffffff]
[    1.807684] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.807732] pci 0000:01:03.0: reg 10: [mem 0xe8000000-0xefffffff pref]
[    1.807742] pci 0000:01:03.0: reg 14: [io  0x3000-0x30ff]
[    1.807752] pci 0000:01:03.0: reg 18: [mem 0xf37f0000-0xf37fffff]
[    1.807787] pci 0000:01:03.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.807806] pci 0000:01:03.0: supports D1 D2
[    1.807837] pci 0000:01:04.0: reg 10: [io  0x2800-0x28ff]
[    1.807847] pci 0000:01:04.0: reg 14: [mem 0xf37e0000-0xf37e01ff]
[    1.807906] pci 0000:01:04.0: PME# supported from D0 D3hot D3cold
[    1.807910] pci 0000:01:04.0: PME# disabled
[    1.807945] pci 0000:01:04.2: reg 10: [io  0x3400-0x34ff]
[    1.807956] pci 0000:01:04.2: reg 14: [mem 0xf37d0000-0xf37d07ff]
[    1.807967] pci 0000:01:04.2: reg 18: [mem 0xf37c0000-0xf37c3fff]
[    1.807978] pci 0000:01:04.2: reg 1c: [mem 0xf3700000-0xf377ffff]
[    1.808008] pci 0000:01:04.2: reg 30: [mem 0x00000000-0x0000ffff pref]
[    1.808028] pci 0000:01:04.2: PME# supported from D0 D3hot D3cold
[    1.808033] pci 0000:01:04.2: PME# disabled
[    1.808106] pci 0000:01:04.4: reg 20: [io  0x3800-0x381f]
[    1.808144] pci 0000:01:04.4: PME# supported from D0 D3hot D3cold
[    1.808148] pci 0000:01:04.4: PME# disabled
[    1.808181] pci 0000:01:04.6: reg 10: [mem 0xf36f0000-0xf36f00ff]
[    1.808247] pci 0000:01:04.6: PME# supported from D0 D3hot D3cold
[    1.808251] pci 0000:01:04.6: PME# disabled
[    1.808294] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
[    1.808416] pci 0000:00:1e.0:   bridge window [io  0x2000-0x3fff]
[    1.808419] pci 0000:00:1e.0:   bridge window [mem 0xf3600000-0xf37fffff]
[    1.808425] pci 0000:00:1e.0:   bridge window [mem 0xe8000000-0xefffffff 64bit pref]
[    1.808427] pci 0000:00:1e.0:   bridge window [mem 0xe7000000-0xfbffffff] (subtractive decode)
[    1.808429] pci 0000:00:1e.0:   bridge window [io  0x1000-0x4fff] (subtractive decode)
[    1.808432] pci 0000:00:1e.0:   bridge window [io  0x0000-0x03af] (subtractive decode)
[    1.808434] pci 0000:00:1e.0:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[    1.808436] pci 0000:00:1e.0:   bridge window [io  0x0d00-0x0fff] (subtractive decode)
[    1.808438] pci 0000:00:1e.0:   bridge window [mem 0xfed00000-0xfed03fff] (subtractive decode)
[    1.808440] pci 0000:00:1e.0:   bridge window [mem 0xfed00000-0xfed44fff] (subtractive decode)
[    1.808442] pci 0000:00:1e.0:   bridge window [io  0x03b0-0x03bb] (subtractive decode)
[    1.808444] pci 0000:00:1e.0:   bridge window [io  0x03c0-0x03df] (subtractive decode)
[    1.808447] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.808475] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.808627] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
[    1.808673] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IPT1._PRT]
[    1.808722] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT01._PRT]
[    1.808770] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT03._PRT]
[    1.808840] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT07._PRT]
[    1.808910] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT09._PRT]
[    1.813581] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *7 10 11)
[    1.813948] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 *10 11)
[    1.814312] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 *10 11)
[    1.814678] ACPI: PCI Interrupt Link [LNKD] (IRQs *5 7 10 11)
[    1.832181] ACPI: PCI Interrupt Link [LNKE] (IRQs *5 7 10 11)
[    1.832549] ACPI: PCI Interrupt Link [LNKF] (IRQs 5 7 *10 11)
[    1.832912] ACPI: PCI Interrupt Link [LNKG] (IRQs 5 7 *10 11)
[    1.833276] ACPI: PCI Interrupt Link [LNKH] (IRQs 5 *7 10 11)
[    1.833781] vgaarb: device added: PCI:0000:01:03.0,decodes=io+mem,owns=io+mem,locks=none
[    1.833956] vgaarb: loaded
[    1.834279] SCSI subsystem initialized
[    1.834497] libata version 3.00 loaded.
[    1.834587] usbcore: registered new interface driver usbfs
[    1.834768] usbcore: registered new interface driver hub
[    1.834924] usbcore: registered new device driver usb
[    1.835190] PCI: Using ACPI for IRQ routing
[    1.835298] PCI: pci_cache_line_size set to 64 bytes
[    1.835405] reserve RAM buffer: 000000000009f400 - 000000000009ffff 
[    1.835408] reserve RAM buffer: 00000000df62f000 - 00000000dfffffff 
[    1.835410] reserve RAM buffer: 00000000df63d000 - 00000000dfffffff 
[    1.835411] reserve RAM buffer: 000000011ffff000 - 000000011fffffff 
[    1.835591] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    1.867954] Switching to clocksource tsc
[    1.870005] pnp: PnP ACPI init
[    1.870117] ACPI: bus type pnp registered
[    1.870258] pnp 00:00: [bus 00-12]
[    1.870262] pnp 00:00: [mem 0xe7000000-0xfbffffff window]
[    1.870265] pnp 00:00: [io  0x1000-0x4fff window]
[    1.870269] pnp 00:00: [io  0x0000-0x03af window]
[    1.870272] pnp 00:00: [io  0x03e0-0x0cf7 window]
[    1.870274] pnp 00:00: [io  0x0d00-0x0fff window]
[    1.870277] pnp 00:00: [mem 0xfed00000-0xfed03fff window]
[    1.870280] pnp 00:00: [mem 0xfed00000-0xfed44fff window]
[    1.870283] pnp 00:00: [io  0x03b0-0x03bb window]
[    1.870286] pnp 00:00: [io  0x03c0-0x03df window]
[    1.870289] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.870397] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 PNP0a08 (active)
[    1.870670] pnp 00:01: [io  0x0070-0x0077]
[    1.870673] pnp 00:01: [io  0x0408-0x040f]
[    1.870675] pnp 00:01: [io  0x04d0-0x04d1]
[    1.870678] pnp 00:01: [io  0x0020-0x003f]
[    1.870680] pnp 00:01: [io  0x00a0-0x00bf]
[    1.870683] pnp 00:01: [io  0x0090-0x009f]
[    1.870685] pnp 00:01: [io  0x0050-0x0053]
[    1.870688] pnp 00:01: [io  0x0700-0x071f]
[    1.870690] pnp 00:01: [io  0x0880-0x08ff]
[    1.870693] pnp 00:01: [io  0x0900-0x097f]
[    1.870695] pnp 00:01: [io  0x0010-0x001f]
[    1.870697] pnp 00:01: [io  0x0c80-0x0c83]
[    1.870700] pnp 00:01: [io  0x0cd4-0x0cd7]
[    1.870703] pnp 00:01: [io  0x0f50-0x0f58]
[    1.870705] pnp 00:01: [io  0x00f0]
[    1.870708] pnp 00:01: [io  0x0ca0-0x0ca1]
[    1.870710] pnp 00:01: [io  0x0ca4-0x0ca5]
[    1.870713] pnp 00:01: [mem 0xe0000000-0xe3ffffff]
[    1.870716] pnp 00:01: [mem 0xfe000000-0xfebfffff]
[    1.870719] pnp 00:01: [mem 0xe7ffe000-0xe7ffffff]
[    1.870722] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    1.870725] pnp 00:01: [io  0x03f8-0x03ff]
[    1.870867] pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.870881] pnp 00:02: [io  0x0ca2-0x0ca3]
[    1.870951] pnp 00:02: Plug and Play ACPI device, IDs IPI0001 (active)
[    1.870985] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.871058] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.871072] pnp 00:04: [dma 7]
[    1.871074] pnp 00:04: [io  0x0000-0x000f]
[    1.871077] pnp 00:04: [io  0x0080-0x008f]
[    1.871080] pnp 00:04: [io  0x00c0-0x00df]
[    1.871148] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.871160] pnp 00:05: [io  0x0061]
[    1.871228] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.871241] pnp 00:06: [io  0x0060]
[    1.871244] pnp 00:06: [io  0x0064]
[    1.871253] pnp 00:06: [irq 1]
[    1.871321] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.871337] pnp 00:07: [irq 12]
[    1.871408] pnp 00:07: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
[    1.871422] pnp 00:08: [io  0x002e-0x002f]
[    1.871425] pnp 00:08: [io  0x0620-0x065f]
[    1.871428] pnp 00:08: [io  0x0680-0x069f]
[    1.871430] pnp 00:08: [io  0x0600-0x061f]
[    1.871433] pnp 00:08: [io  0x0660-0x067f]
[    1.871435] pnp 00:08: [io  0x0300-0x031f]
[    1.871504] pnp 00:08: Plug and Play ACPI device, IDs PNP0a06 (active)
[    1.871721] pnp 00:09: [irq 3]
[    1.871723] pnp 00:09: [io  0x02f8-0x02ff]
[    1.871943] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    1.872033] pnp 00:0a: [io  0x0070-0x0071]
[    1.872108] pnp 00:0a: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.872432] pnp: PnP ACPI: found 11 devices
[    1.872538] ACPI: ACPI bus type pnp unregistered
[    1.872654] system 00:01: [io  0x0408-0x040f] has been reserved
[    1.872771] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    1.872888] system 00:01: [io  0x0700-0x071f] has been reserved
[    1.873004] system 00:01: [io  0x0880-0x08ff] has been reserved
[    1.873120] system 00:01: [io  0x0900-0x097f] has been reserved
[    1.873236] system 00:01: [io  0x0c80-0x0c83] has been reserved
[    1.873352] system 00:01: [io  0x0cd4-0x0cd7] has been reserved
[    1.873468] system 00:01: [io  0x0f50-0x0f58] has been reserved
[    1.873584] system 00:01: [io  0x0ca0-0x0ca1] has been reserved
[    1.873700] system 00:01: [io  0x0ca4-0x0ca5] has been reserved
[    1.873817] system 00:01: [io  0x03f8-0x03ff] has been reserved
[    1.873935] system 00:01: [mem 0xe0000000-0xe3ffffff] has been reserved
[    1.874056] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[    1.874177] system 00:01: [mem 0xe7ffe000-0xe7ffffff] has been reserved
[    1.912733] pci 0000:00:01.0: BAR 9: assigned [mem 0xe7000000-0xe70fffff pref]
[    1.912902] pci 0000:00:09.0: BAR 9: assigned [mem 0xe7100000-0xe71fffff pref]
[    1.913070] pci 0000:00:1c.0: BAR 9: assigned [mem 0xe7200000-0xe72fffff pref]
[    1.913238] pci 0000:02:00.0: BAR 6: assigned [mem 0xe7000000-0xe700ffff pref]
[    1.913405] pci 0000:02:00.1: BAR 6: assigned [mem 0xe7010000-0xe701ffff pref]
[    1.913572] pci 0000:00:01.0: PCI bridge to [bus 02-02]
[    1.913684] pci 0000:00:01.0:   bridge window [io  disabled]
[    1.913801] pci 0000:00:01.0:   bridge window [mem 0xf3800000-0xfb7fffff]
[    1.913923] pci 0000:00:01.0:   bridge window [mem 0xe7000000-0xe70fffff pref]
[    1.914093] pci 0000:00:02.0: PCI bridge to [bus 0d-0d]
[    1.914205] pci 0000:00:02.0:   bridge window [io  disabled]
[    1.914322] pci 0000:00:02.0:   bridge window [mem disabled]
[    1.914436] pci 0000:00:02.0:   bridge window [mem pref disabled]
[    1.914556] pci 0000:00:03.0: PCI bridge to [bus 03-05]
[    1.914668] pci 0000:00:03.0:   bridge window [io  disabled]
[    1.914784] pci 0000:00:03.0:   bridge window [mem disabled]
[    1.914899] pci 0000:00:03.0:   bridge window [mem pref disabled]
[    1.915019] pci 0000:00:07.0: PCI bridge to [bus 06-08]
[    1.915131] pci 0000:00:07.0:   bridge window [io  disabled]
[    1.915247] pci 0000:00:07.0:   bridge window [mem disabled]
[    1.915363] pci 0000:00:07.0:   bridge window [mem pref disabled]
[    1.915484] pci 0000:00:08.0: PCI bridge to [bus 11-11]
[    1.915595] pci 0000:00:08.0:   bridge window [io  disabled]
[    1.915710] pci 0000:00:08.0:   bridge window [mem disabled]
[    1.915825] pci 0000:00:08.0:   bridge window [mem pref disabled]
[    1.915946] pci 0000:09:00.0: BAR 9: assigned [mem 0xe7100000-0xe71fffff pref]
[    1.916117] pci 0000:0a:04.0: BAR 6: assigned [mem 0xe7100000-0xe711ffff pref]
[    1.916283] pci 0000:0a:04.1: BAR 6: assigned [mem 0xe7120000-0xe713ffff pref]
[    1.916450] pci 0000:09:00.0: PCI bridge to [bus 0a-0a]
[    1.916562] pci 0000:09:00.0:   bridge window [io  disabled]
[    1.916678] pci 0000:09:00.0:   bridge window [mem 0xfba00000-0xfbafffff]
[    1.916801] pci 0000:09:00.0:   bridge window [mem 0xe7100000-0xe71fffff pref]
[    1.916970] pci 0000:00:09.0: PCI bridge to [bus 09-0b]
[    1.917082] pci 0000:00:09.0:   bridge window [io  disabled]
[    1.917199] pci 0000:00:09.0:   bridge window [mem 0xfba00000-0xfbafffff]
[    1.917322] pci 0000:00:09.0:   bridge window [mem 0xe7100000-0xe71fffff pref]
[    1.917491] pci 0000:00:0a.0: PCI bridge to [bus 12-12]
[    1.917602] pci 0000:00:0a.0:   bridge window [io  disabled]
[    1.917718] pci 0000:00:0a.0:   bridge window [mem disabled]
[    1.917832] pci 0000:00:0a.0:   bridge window [mem pref disabled]
[    1.917954] pci 0000:0c:00.0: BAR 6: assigned [mem 0xe7200000-0xe727ffff pref]
[    1.918120] pci 0000:00:1c.0: PCI bridge to [bus 0c-0c]
[    1.918233] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    1.918352] pci 0000:00:1c.0:   bridge window [mem 0xfbb00000-0xfbffffff]
[    1.918475] pci 0000:00:1c.0:   bridge window [mem 0xe7200000-0xe72fffff pref]
[    1.918648] pci 0000:01:03.0: BAR 6: assigned [mem 0xf3600000-0xf361ffff pref]
[    1.918815] pci 0000:01:04.2: BAR 6: assigned [mem 0xf3620000-0xf362ffff pref]
[    1.918981] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
[    1.919094] pci 0000:00:1e.0:   bridge window [io  0x2000-0x3fff]
[    1.919214] pci 0000:00:1e.0:   bridge window [mem 0xf3600000-0xf37fffff]
[    1.919337] pci 0000:00:1e.0:   bridge window [mem 0xe8000000-0xefffffff 64bit pref]
[    1.919518] pci 0000:00:01.0: setting latency timer to 64
[    1.919526] pci 0000:00:02.0: setting latency timer to 64
[    1.919535] pci 0000:00:03.0: setting latency timer to 64
[    1.919544] pci 0000:00:07.0: setting latency timer to 64
[    1.919552] pci 0000:00:08.0: setting latency timer to 64
[    1.919560] pci 0000:00:09.0: setting latency timer to 64
[    1.919570] pci 0000:09:00.0: setting latency timer to 64
[    1.919578] pci 0000:00:0a.0: setting latency timer to 64
[    1.919592] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.919714] pci 0000:00:1c.0: setting latency timer to 64
[    1.919722] pci 0000:00:1e.0: setting latency timer to 64
[    1.919726] pci_bus 0000:00: resource 4 [mem 0xe7000000-0xfbffffff]
[    1.919730] pci_bus 0000:00: resource 5 [io  0x1000-0x4fff]
[    1.919733] pci_bus 0000:00: resource 6 [io  0x0000-0x03af]
[    1.919736] pci_bus 0000:00: resource 7 [io  0x03e0-0x0cf7]
[    1.919739] pci_bus 0000:00: resource 8 [io  0x0d00-0x0fff]
[    1.919742] pci_bus 0000:00: resource 9 [mem 0xfed00000-0xfed03fff]
[    1.919746] pci_bus 0000:00: resource 10 [mem 0xfed00000-0xfed44fff]
[    1.919749] pci_bus 0000:00: resource 11 [io  0x03b0-0x03bb]
[    1.919752] pci_bus 0000:00: resource 12 [io  0x03c0-0x03df]
[    1.919755] pci_bus 0000:00: resource 13 [mem 0x000a0000-0x000bffff]
[    1.919759] pci_bus 0000:02: resource 1 [mem 0xf3800000-0xfb7fffff]
[    1.919762] pci_bus 0000:02: resource 2 [mem 0xe7000000-0xe70fffff pref]
[    1.919766] pci_bus 0000:09: resource 1 [mem 0xfba00000-0xfbafffff]
[    1.919769] pci_bus 0000:09: resource 2 [mem 0xe7100000-0xe71fffff pref]
[    1.919772] pci_bus 0000:0a: resource 1 [mem 0xfba00000-0xfbafffff]
[    1.919775] pci_bus 0000:0a: resource 2 [mem 0xe7100000-0xe71fffff pref]
[    1.919779] pci_bus 0000:0c: resource 0 [io  0x4000-0x4fff]
[    1.919782] pci_bus 0000:0c: resource 1 [mem 0xfbb00000-0xfbffffff]
[    1.919785] pci_bus 0000:0c: resource 2 [mem 0xe7200000-0xe72fffff pref]
[    1.919789] pci_bus 0000:01: resource 0 [io  0x2000-0x3fff]
[    1.919792] pci_bus 0000:01: resource 1 [mem 0xf3600000-0xf37fffff]
[    1.919795] pci_bus 0000:01: resource 2 [mem 0xe8000000-0xefffffff 64bit pref]
[    1.919799] pci_bus 0000:01: resource 4 [mem 0xe7000000-0xfbffffff]
[    1.919802] pci_bus 0000:01: resource 5 [io  0x1000-0x4fff]
[    1.919805] pci_bus 0000:01: resource 6 [io  0x0000-0x03af]
[    1.919808] pci_bus 0000:01: resource 7 [io  0x03e0-0x0cf7]
[    1.919811] pci_bus 0000:01: resource 8 [io  0x0d00-0x0fff]
[    1.919814] pci_bus 0000:01: resource 9 [mem 0xfed00000-0xfed03fff]
[    1.919817] pci_bus 0000:01: resource 10 [mem 0xfed00000-0xfed44fff]
[    1.919820] pci_bus 0000:01: resource 11 [io  0x03b0-0x03bb]
[    1.919823] pci_bus 0000:01: resource 12 [io  0x03c0-0x03df]
[    1.919826] pci_bus 0000:01: resource 13 [mem 0x000a0000-0x000bffff]
[    1.919913] NET: Registered protocol family 2
[    1.920142] IP route cache hash table entries: 131072 (order: 7, 524288 bytes)
[    1.920845] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
[    1.922565] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    1.922841] TCP: Hash tables configured (established 524288 bind 65536)
[    1.922961] TCP reno registered
[    1.923066] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    1.923204] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    1.923481] NET: Registered protocol family 1
[    1.936085] pci 0000:01:03.0: Boot video device
[    1.936724] PCI: CLS 64 bytes, default 64
[    1.936786] Trying to unpack rootfs image as initramfs...
[    1.952603] Freeing initrd memory: 492k freed
[    1.953202] udev used greatest stack depth: 7068 bytes left
[    1.955023] udev used greatest stack depth: 6904 bytes left
[    1.960152] audit: initializing netlink socket (disabled)
[    1.960228] type=2000 audit(1288219525.604:1): initialized
[    1.960337] udev used greatest stack depth: 6860 bytes left
[    1.998555] highmem bounce pool size: 64 pages
[    1.998617] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.998865] VFS: Disk quotas dquot_6.5.2
[    1.998962] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.999267] msgmni has been set to 5727
[    1.999368] SELinux:  Registering netfilter hooks
[    1.999637] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.999716] io scheduler noop registered
[    1.999774] io scheduler deadline registered
[    1.999864] io scheduler cfq registered (default)
[    2.000437] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.001177] ACPI: acpi_idle registered with cpuidle
[    2.001344] Monitor-Mwait will be used to enter C-1 state
[    2.001378] Monitor-Mwait will be used to enter C-3 state
[    2.001406] Monitor-Mwait will be used to enter C-3 state
[    2.009175] thermal LNXTHERM:00: registered as thermal_zone0
[    2.009238] ACPI: Thermal Zone [THM0] (8 C)
[    2.009712] Real Time Clock Driver v1.12b
[    2.009770] Linux agpgart interface v0.103
[    2.010662] [drm] Initialized drm 1.1.0 20060810
[    2.010722] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.284148] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.560020] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.581013] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.584619] brd: module loaded
[    2.584675] HP CISS Driver (v 3.6.26)
[    2.584851] cciss 0000:0c:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.584994] cciss 0000:0c:00.0: irq 64 for MSI/MSI-X
[    2.584998] cciss 0000:0c:00.0: irq 65 for MSI/MSI-X
[    2.585001] cciss 0000:0c:00.0: irq 66 for MSI/MSI-X
[    2.585005] cciss 0000:0c:00.0: irq 67 for MSI/MSI-X
[    2.599835] cciss 0000:0c:00.0: cciss0: <0x323a> at PCI 0000:0c:00.0 IRQ 64 using DAC
[    2.637524]  cciss/c0d0: p1 p2 p3 p4 < p5 p6 p7 >
[    2.638449] Uniform Multi-Platform E-IDE driver
[    2.656512] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    2.656604] Probing IDE interface ide0...
[    3.215571] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    3.215676] Probing IDE interface ide1...
[    3.775281] ide1 at 0x170-0x177,0x376 on irq 15
[    3.775458] ide-gd driver 1.18
[    3.775591] ide-cd driver 5.00
[    3.776080] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    3.777842] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.777906] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.778170] mice: PS/2 mouse device common for all mice
[    3.782955] cpuidle: using governor ladder
[    3.791748] cpuidle: using governor menu
[    3.792157] usbcore: registered new interface driver usbhid
[    3.792219] usbhid: USB HID core driver
[    3.792323] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.793005] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.793111] TCP cubic registered
[    3.793167] Initializing XFRM netlink socket
[    3.793228] NET: Registered protocol family 17
[    3.793290] Registering the dns_resolver key type
[    3.793453] Using IPI Shortcut mode
[    3.794786] Freeing unused kernel memory: 420k freed
[    3.795432] Write protecting the kernel text: 2924k
[    3.795873] Write protecting the kernel read-only data: 1564k
[    3.850624] EXT3-fs: barriers not enabled
[    3.861932] kjournald starting.  Commit interval 5 seconds
[    3.862003] EXT3-fs (cciss/c0d0p2): mounted filesystem with writeback data mode
[    4.127764] SELinux:  Disabled at runtime.
[    4.127844] SELinux:  Unregistering netfilter hooks
[    4.279034] type=1404 audit(1288219527.924:2): selinux=0 auid=4294967295 ses=4294967295
[    4.562099] hostname used greatest stack depth: 6724 bytes left
[    4.639764] awk used greatest stack depth: 6112 bytes left


