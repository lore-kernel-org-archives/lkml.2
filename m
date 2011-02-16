Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab1BPMVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:21:42 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36104 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759102Ab1BPMVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:21:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=k4gep9I1Yw/Dxz0VR5ettqz/wg0Saq3t6Gz9zhAeLyXGt4n3nV3ZMMG1WpxTFKNTec
         YXLj4jLQL0Tj4f9iQ6Iqa/h132+pEhu7DahycAUaqvAOAmI6BeMIKEhX3NBw+NalClw/
         mWVSH7TRxtm/WeQvLLl/Do7Xyogl6FWnhiAYo=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/33] x86-64, NUMA: Use common numa_nodes[]
Date: Wed, 16 Feb 2011 13:20:45 +0100
Message-Id: <1297858867-25981-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI and amd are using separate nodes[] array.  Add numa_nodes[] and
use them in all NUMA init methods.  cutoff_node() cleanup is moved
from srat_64.c to numa_64.c and applied in initmem_init() regardless
of init methods.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/numa_64.h |    1 +
 arch/x86/mm/amdtopology_64.c   |   19 ++++++++---------
 arch/x86/mm/numa_64.c          |   24 ++++++++++++++++++++++
 arch/x86/mm/srat_64.c          |   43 ++++++++++-----------------------------
 4 files changed, 45 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index de45936..d3a4514 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -29,6 +29,7 @@ extern void setup_node_bootmem(int nodeid, unsigned long start,
 
 extern nodemask_t cpu_nodes_parsed __initdata;
 extern nodemask_t mem_nodes_parsed __initdata;
+extern struct bootnode numa_nodes[MAX_NUMNODES] __initdata;
 
 extern int __cpuinit numa_cpu_node(int cpu);
 
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index b6029a6..f049fa6 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -26,7 +26,6 @@
 #include <asm/apic.h>
 #include <asm/amd_nb.h>
 
-static struct bootnode __initdata nodes[8];
 static unsigned char __initdata nodeids[8];
 
 static __init int find_northbridge(void)
@@ -166,8 +165,8 @@ int __init amd_numa_init(void)
 		pr_info("Node %d MemBase %016lx Limit %016lx\n",
 			nodeid, base, limit);
 
-		nodes[nodeid].start = base;
-		nodes[nodeid].end = limit;
+		numa_nodes[nodeid].start = base;
+		numa_nodes[nodeid].end = limit;
 
 		prevbase = base;
 
@@ -210,8 +209,8 @@ void __init amd_get_nodes(struct bootnode *physnodes)
 	int i;
 
 	for_each_node_mask(i, mem_nodes_parsed) {
-		physnodes[i].start = nodes[i].start;
-		physnodes[i].end = nodes[i].end;
+		physnodes[i].start = numa_nodes[i].start;
+		physnodes[i].end = numa_nodes[i].end;
 	}
 }
 
@@ -221,7 +220,7 @@ static int __init find_node_by_addr(unsigned long addr)
 	int i;
 
 	for (i = 0; i < 8; i++)
-		if (addr >= nodes[i].start && addr < nodes[i].end) {
+		if (addr >= numa_nodes[i].start && addr < numa_nodes[i].end) {
 			ret = i;
 			break;
 		}
@@ -274,7 +273,7 @@ int __init amd_scan_nodes(void)
 {
 	int i;
 
-	memnode_shift = compute_hash_shift(nodes, 8, NULL);
+	memnode_shift = compute_hash_shift(numa_nodes, 8, NULL);
 	if (memnode_shift < 0) {
 		pr_err("No NUMA node hash function found. Contact maintainer\n");
 		return -1;
@@ -284,11 +283,11 @@ int __init amd_scan_nodes(void)
 	/* use the coreid bits from early_identify_cpu */
 	for_each_node_mask(i, node_possible_map)
 		memblock_x86_register_active_regions(i,
-				nodes[i].start >> PAGE_SHIFT,
-				nodes[i].end >> PAGE_SHIFT);
+				numa_nodes[i].start >> PAGE_SHIFT,
+				numa_nodes[i].end >> PAGE_SHIFT);
 	init_memory_mapping_high();
 	for_each_node_mask(i, node_possible_map)
-		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
+		setup_node_bootmem(i, numa_nodes[i].start, numa_nodes[i].end);
 
 	numa_init_array();
 	return 0;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 4404e1d..a6b899f 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -33,6 +33,8 @@ struct memnode memnode;
 static unsigned long __initdata nodemap_addr;
 static unsigned long __initdata nodemap_size;
 
+struct bootnode numa_nodes[MAX_NUMNODES] __initdata;
+
 /*
  * Given a shift value, try to populate memnodemap[]
  * Returns :
@@ -182,6 +184,22 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 	return NULL;
 }
 
+static __init void cutoff_node(int i, unsigned long start, unsigned long end)
+{
+	struct bootnode *nd = &numa_nodes[i];
+
+	if (nd->start < start) {
+		nd->start = start;
+		if (nd->end < nd->start)
+			nd->start = nd->end;
+	}
+	if (nd->end > end) {
+		nd->end = end;
+		if (nd->start > nd->end)
+			nd->start = nd->end;
+	}
+}
+
 /* Initialize bootmem allocator for a node */
 void __init
 setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
@@ -638,9 +656,15 @@ void __init initmem_init(void)
 		nodes_clear(mem_nodes_parsed);
 		nodes_clear(node_possible_map);
 		nodes_clear(node_online_map);
+		memset(numa_nodes, 0, sizeof(numa_nodes));
 
 		if (numa_init[i]() < 0)
 			continue;
+
+		/* clean up the node list */
+		for (j = 0; j < MAX_NUMNODES; j++)
+			cutoff_node(j, 0, max_pfn << PAGE_SHIFT);
+
 #ifdef CONFIG_NUMA_EMU
 		setup_physnodes(0, max_pfn << PAGE_SHIFT, i == 0, i == 1);
 		if (cmdline && !numa_emulation(0, max_pfn, i == 0, i == 1))
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 33e72ec..bfa4a6a 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -28,7 +28,6 @@ int acpi_numa __initdata;
 
 static struct acpi_table_slit *acpi_slit;
 
-static struct bootnode nodes[MAX_NUMNODES] __initdata;
 static struct bootnode nodes_add[MAX_NUMNODES];
 
 static int num_node_memblks __initdata;
@@ -55,29 +54,13 @@ static __init int conflicting_memblks(unsigned long start, unsigned long end)
 	return -1;
 }
 
-static __init void cutoff_node(int i, unsigned long start, unsigned long end)
-{
-	struct bootnode *nd = &nodes[i];
-
-	if (nd->start < start) {
-		nd->start = start;
-		if (nd->end < nd->start)
-			nd->start = nd->end;
-	}
-	if (nd->end > end) {
-		nd->end = end;
-		if (nd->start > nd->end)
-			nd->start = nd->end;
-	}
-}
-
 static __init void bad_srat(void)
 {
 	int i;
 	printk(KERN_ERR "SRAT: SRAT not used.\n");
 	acpi_numa = -1;
 	for (i = 0; i < MAX_NUMNODES; i++) {
-		nodes[i].start = nodes[i].end = 0;
+		numa_nodes[i].start = numa_nodes[i].end = 0;
 		nodes_add[i].start = nodes_add[i].end = 0;
 	}
 	remove_all_active_ranges();
@@ -276,12 +259,12 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	if (i == node) {
 		printk(KERN_WARNING
 		"SRAT: Warning: PXM %d (%lx-%lx) overlaps with itself (%Lx-%Lx)\n",
-			pxm, start, end, nodes[i].start, nodes[i].end);
+		       pxm, start, end, numa_nodes[i].start, numa_nodes[i].end);
 	} else if (i >= 0) {
 		printk(KERN_ERR
 		       "SRAT: PXM %d (%lx-%lx) overlaps with PXM %d (%Lx-%Lx)\n",
 		       pxm, start, end, node_to_pxm(i),
-			nodes[i].start, nodes[i].end);
+		       numa_nodes[i].start, numa_nodes[i].end);
 		bad_srat();
 		return;
 	}
@@ -290,7 +273,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	       start, end);
 
 	if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)) {
-		nd = &nodes[node];
+		nd = &numa_nodes[node];
 		if (!node_test_and_set(node, mem_nodes_parsed)) {
 			nd->start = start;
 			nd->end = end;
@@ -347,9 +330,8 @@ void __init acpi_get_nodes(struct bootnode *physnodes, unsigned long start,
 	int i;
 
 	for_each_node_mask(i, mem_nodes_parsed) {
-		cutoff_node(i, start, end);
-		physnodes[i].start = nodes[i].start;
-		physnodes[i].end = nodes[i].end;
+		physnodes[i].start = numa_nodes[i].start;
+		physnodes[i].end = numa_nodes[i].end;
 	}
 }
 #endif /* CONFIG_NUMA_EMU */
@@ -372,10 +354,6 @@ int __init acpi_scan_nodes(void)
 	if (acpi_numa <= 0)
 		return -1;
 
-	/* First clean up the node list */
-	for (i = 0; i < MAX_NUMNODES; i++)
-		cutoff_node(i, 0, max_pfn << PAGE_SHIFT);
-
 	/*
 	 * Join together blocks on the same node, holes between
 	 * which don't overlap with memory on other nodes.
@@ -440,7 +418,7 @@ int __init acpi_scan_nodes(void)
 
 	/* for out of order entries in SRAT */
 	sort_node_map();
-	if (!nodes_cover_memory(nodes)) {
+	if (!nodes_cover_memory(numa_nodes)) {
 		bad_srat();
 		return -1;
 	}
@@ -449,12 +427,13 @@ int __init acpi_scan_nodes(void)
 
 	/* Finally register nodes */
 	for_each_node_mask(i, node_possible_map)
-		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
+		setup_node_bootmem(i, numa_nodes[i].start, numa_nodes[i].end);
 	/* Try again in case setup_node_bootmem missed one due
 	   to missing bootmem */
 	for_each_node_mask(i, node_possible_map)
 		if (!node_online(i))
-			setup_node_bootmem(i, nodes[i].start, nodes[i].end);
+			setup_node_bootmem(i, numa_nodes[i].start,
+					   numa_nodes[i].end);
 
 	for (i = 0; i < nr_cpu_ids; i++) {
 		int node = early_cpu_to_node(i);
@@ -486,7 +465,7 @@ static int __init find_node_by_addr(unsigned long addr)
 		 * the sake of simplicity, we only use a real node's starting
 		 * address to determine which emulated node it appears on.
 		 */
-		if (addr >= nodes[i].start && addr < nodes[i].end) {
+		if (addr >= numa_nodes[i].start && addr < numa_nodes[i].end) {
 			ret = i;
 			break;
 		}
-- 
1.7.1

