Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1BGXT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 18:19:57 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:57742 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab1BGXTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 18:19:55 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 07/11] x86, 64bit, numa: Put pgtable to local node memory
Date: Mon,  7 Feb 2011 15:17:08 -0800
Message-Id: <1297120632-24933-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
References: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D507DB9.00D3,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce init_memory_mapping_high(), and use it with 64bit.

It will go with every memory segment above 4g to create page table to the
memory range itself.

before this patch all page tables was on one node.

with this patch, one RED-PEN is killed

debug out for 8 sockets system after patch
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: [0x00000000000000-0x0000007f74ffff]
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f750000 page 4k
[    0.000000] kernel direct mapping tables up to 7f750000 @ [0x7f74c000-0x7f74ffff]
[    0.000000] RAMDISK: 7bc84000 - 7f745000
....
[    0.000000] Adding active range (0, 0x10, 0x95) 0 entries of 3200 used
[    0.000000] Adding active range (0, 0x100, 0x7f750) 1 entries of 3200 used
[    0.000000] Adding active range (0, 0x100000, 0x1080000) 2 entries of 3200 used
[    0.000000] Adding active range (1, 0x1080000, 0x2080000) 3 entries of 3200 used
[    0.000000] Adding active range (2, 0x2080000, 0x3080000) 4 entries of 3200 used
[    0.000000] Adding active range (3, 0x3080000, 0x4080000) 5 entries of 3200 used
[    0.000000] Adding active range (4, 0x4080000, 0x5080000) 6 entries of 3200 used
[    0.000000] Adding active range (5, 0x5080000, 0x6080000) 7 entries of 3200 used
[    0.000000] Adding active range (6, 0x6080000, 0x7080000) 8 entries of 3200 used
[    0.000000] Adding active range (7, 0x7080000, 0x8080000) 9 entries of 3200 used
[    0.000000] init_memory_mapping: [0x00000100000000-0x0000107fffffff]
[    0.000000]  0100000000 - 1080000000 page 2M
[    0.000000] kernel direct mapping tables up to 1080000000 @ [0x107ffbd000-0x107fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x107ffc2000-0x107fffffff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00001080000000-0x0000207fffffff]
[    0.000000]  1080000000 - 2080000000 page 2M
[    0.000000] kernel direct mapping tables up to 2080000000 @ [0x207ff7d000-0x207fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x207ffc0000-0x207fffffff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00002080000000-0x0000307fffffff]
[    0.000000]  2080000000 - 3080000000 page 2M
[    0.000000] kernel direct mapping tables up to 3080000000 @ [0x307ff3d000-0x307fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x307ffc0000-0x307fffffff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00003080000000-0x0000407fffffff]
[    0.000000]  3080000000 - 4080000000 page 2M
[    0.000000] kernel direct mapping tables up to 4080000000 @ [0x407fefd000-0x407fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x407ffc0000-0x407fffffff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00004080000000-0x0000507fffffff]
[    0.000000]  4080000000 - 5080000000 page 2M
[    0.000000] kernel direct mapping tables up to 5080000000 @ [0x507febd000-0x507fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x507ffc0000-0x507fffffff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00005080000000-0x0000607fffffff]
[    0.000000]  5080000000 - 6080000000 page 2M
[    0.000000] kernel direct mapping tables up to 6080000000 @ [0x607fe7d000-0x607fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x607ffc0000-0x607fffffff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00006080000000-0x0000707fffffff]
[    0.000000]  6080000000 - 7080000000 page 2M
[    0.000000] kernel direct mapping tables up to 7080000000 @ [0x707fe3d000-0x707fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x707ffc0000-0x707fffffff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00007080000000-0x0000807fffffff]
[    0.000000]  7080000000 - 8080000000 page 2M
[    0.000000] kernel direct mapping tables up to 8080000000 @ [0x807fdfc000-0x807fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x807ffbf000-0x807fffffff]          PGTABLE
[    0.000000] Initmem setup node 0 [0000000000000000-000000107fffffff]
[    0.000000]   NODE_DATA [0x0000107ffbd000-0x0000107ffc1fff]
[    0.000000] Initmem setup node 1 [0000001080000000-000000207fffffff]
[    0.000000]   NODE_DATA [0x0000207ffbb000-0x0000207ffbffff]
[    0.000000] Initmem setup node 2 [0000002080000000-000000307fffffff]
[    0.000000]   NODE_DATA [0x0000307ffbb000-0x0000307ffbffff]
[    0.000000] Initmem setup node 3 [0000003080000000-000000407fffffff]
[    0.000000]   NODE_DATA [0x0000407ffbb000-0x0000407ffbffff]
[    0.000000] Initmem setup node 4 [0000004080000000-000000507fffffff]
[    0.000000]   NODE_DATA [0x0000507ffbb000-0x0000507ffbffff]
[    0.000000] Initmem setup node 5 [0000005080000000-000000607fffffff]
[    0.000000]   NODE_DATA [0x0000607ffbb000-0x0000607ffbffff]
[    0.000000] Initmem setup node 6 [0000006080000000-000000707fffffff]
[    0.000000]   NODE_DATA [0x0000707ffbb000-0x0000707ffbffff]
[    0.000000] Initmem setup node 7 [0000007080000000-000000807fffffff]
[    0.000000]   NODE_DATA [0x0000807ffba000-0x0000807ffbefff]

-v2: update it to recent numa-emulation change

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/page_types.h |    2 +
 arch/x86/kernel/setup.c           |    8 -----
 arch/x86/mm/amdtopology_64.c      |    8 +++--
 arch/x86/mm/init.c                |    8 +-----
 arch/x86/mm/init_64.c             |   54 +++++++++++++++++++++++++++++++++++++
 arch/x86/mm/numa_64.c             |    6 +++-
 arch/x86/mm/srat_64.c             |    2 +
 7 files changed, 68 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index cf271fd..65d81d5 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -53,6 +53,8 @@ static inline unsigned long get_max_mapped(void)
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
+void init_memory_mapping_high(void);
+
 extern void initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 				int acpi, int k8);
 extern void free_initmem(void);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 23a7a5f..645c5a2 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -941,14 +941,6 @@ void __init setup_arch(char **cmdline_p)
 	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
 	max_pfn_mapped = max_low_pfn_mapped;
 
-#ifdef CONFIG_X86_64
-	if (max_pfn > max_low_pfn) {
-		max_pfn_mapped = init_memory_mapping(1UL<<32,
-						     max_pfn<<PAGE_SHIFT);
-		/* can we preseve max_low_pfn ?*/
-		max_low_pfn = max_pfn;
-	}
-#endif
 	memblock.current_limit = get_max_mapped();
 
 	/*
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index f21962c..49b334c 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -278,12 +278,14 @@ int __init amd_scan_nodes(void)
 		apicid_base = boot_cpu_physical_apicid;
 	}
 
-	for_each_node_mask(i, node_possible_map) {
-		int j;
-
+	for_each_node_mask(i, node_possible_map)
 		memblock_x86_register_active_regions(i,
 				nodes[i].start >> PAGE_SHIFT,
 				nodes[i].end >> PAGE_SHIFT);
+	init_memory_mapping_high();
+	for_each_node_mask(i, node_possible_map) {
+		int j;
+
 		for (j = apicid_base; j < cores + apicid_base; j++)
 			apicid_to_node[(i << bits) + j] = i;
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index dbb63b8..a6b7a14 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -65,16 +65,10 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 #ifdef CONFIG_X86_32
 	/* for fixmap */
 	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
-#endif
 
-	/*
-	 * RED-PEN putting page tables only on node 0 could
-	 * cause a hotspot and fill up ZONE_DMA. The page tables
-	 * need roughly 0.5KB per GB.
-	 */
-#ifdef CONFIG_X86_32
 	good_end = max_pfn_mapped << PAGE_SHIFT;
 #endif
+
 	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
 	if (base == MEMBLOCK_ERROR)
 		panic("Cannot find space for the kernel page tables");
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 024847d..194f273 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -607,9 +607,63 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 				int acpi, int k8)
 {
 	memblock_x86_register_active_regions(0, start_pfn, end_pfn);
+	init_memory_mapping_high();
 }
 #endif
 
+struct mapping_work_data {
+	unsigned long start;
+	unsigned long end;
+	unsigned long pfn_mapped;
+};
+
+static int __init_refok
+mapping_work_fn(unsigned long start_pfn, unsigned long end_pfn, void *datax)
+{
+	struct mapping_work_data *data = datax;
+	unsigned long pfn_mapped;
+	unsigned long final_start, final_end;
+
+	final_start = max_t(unsigned long, start_pfn<<PAGE_SHIFT, data->start);
+	final_end = min_t(unsigned long, end_pfn<<PAGE_SHIFT, data->end);
+
+	if (final_end <= final_start)
+		return 0;
+
+	pfn_mapped = init_memory_mapping(final_start, final_end);
+
+	if (pfn_mapped > data->pfn_mapped)
+		data->pfn_mapped = pfn_mapped;
+
+	return 0;
+}
+
+static unsigned long __init_refok
+init_memory_mapping_active_regions(unsigned long start, unsigned long end)
+{
+	struct mapping_work_data data;
+
+	data.start = start;
+	data.end = end;
+	data.pfn_mapped = 0;
+
+	work_with_active_regions(MAX_NUMNODES, mapping_work_fn, &data);
+
+	return data.pfn_mapped;
+}
+
+void __init_refok init_memory_mapping_high(void)
+{
+	if (max_pfn > max_low_pfn) {
+		max_pfn_mapped = init_memory_mapping_active_regions(1UL<<32,
+							 max_pfn<<PAGE_SHIFT);
+		/* can we preserve max_low_pfn ? */
+		max_low_pfn = max_pfn;
+
+		memblock.current_limit = get_max_mapped();
+	}
+}
+
 void __init paging_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 0cdfeea..62cb634 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -598,11 +598,12 @@ static int __init numa_emulation(unsigned long start_pfn,
 	 * the e820 memory map.
 	 */
 	remove_all_active_ranges();
-	for_each_node_mask(i, node_possible_map) {
+	for_each_node_mask(i, node_possible_map)
 		memblock_x86_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
+	init_memory_mapping_high();
+	for_each_node_mask(i, node_possible_map)
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
-	}
 	setup_physnodes(addr, max_addr, acpi, amd);
 	fake_physnodes(acpi, amd, num_nodes);
 	numa_init_array();
@@ -658,6 +659,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 	for (i = 0; i < nr_cpu_ids; i++)
 		numa_set_node(i, 0);
 	memblock_x86_register_active_regions(0, start_pfn, last_pfn);
+	init_memory_mapping_high();
 	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
 }
 
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 603d285..4c03e13 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -444,6 +444,8 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 		return -1;
 	}
 
+	init_memory_mapping_high();
+
 	/* Account for nodes with cpus and no memory */
 	nodes_or(node_possible_map, nodes_parsed, cpu_nodes_parsed);
 
-- 
1.7.1

