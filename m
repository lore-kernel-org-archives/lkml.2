Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab1BLRPu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:15:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51602 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1BLRLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:11:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ZUs87Vl41QjFOczzZRkEUz8ghbJPw8bXJjEmIUQNVB9o/FH8C+4Mzr4lUypnxGLFod
         Px0uAf1h7Nb8By2g3NysXvk9JGYMIzRXFyqAxJQyewdMWXjPUEV2Y5v/yOLXfq+tqr7g
         zkMEFY+g0yBTcmYAu1r7l2PPZnTX8mbkxjubM=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/26] x86-64, NUMA: Unify the rest of memblk registration
Date: Sat, 12 Feb 2011 18:10:52 +0100
Message-Id: <1297530663-26234-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297530663-26234-1-git-send-email-tj@kernel.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the remaining memblk registration logic from acpi_scan_nodes() to
numa_register_memblks() and initmem_init().

This applies nodes_cover_memory() sanity check, memory node sorting
and node_online() checking, which were only applied to acpi, to all
init methods.

As all memblk registration is moved to common code, active range
clearing is moved to initmem_init() too and removed from bad_srat().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/amdtopology_64.c |    6 ---
 arch/x86/mm/numa_64.c        |   71 +++++++++++++++++++++++++++++++++++++++---
 arch/x86/mm/srat_64.c        |   59 ----------------------------------
 3 files changed, 66 insertions(+), 70 deletions(-)

diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index 48ec374..9c9f46a 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -262,11 +262,5 @@ void __init amd_fake_nodes(const struct bootnode *nodes, int nr_nodes)
 
 int __init amd_scan_nodes(void)
 {
-	int i;
-
-	for_each_node_mask(i, node_possible_map)
-		setup_node_bootmem(i, numa_nodes[i].start, numa_nodes[i].end);
-
-	numa_init_array();
 	return 0;
 }
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 2e2ca94..062649d 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -287,6 +287,37 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 	node_set_online(nodeid);
 }
 
+/*
+ * Sanity check to catch more bad NUMA configurations (they are amazingly
+ * common).  Make sure the nodes cover all memory.
+ */
+static int __init nodes_cover_memory(const struct bootnode *nodes)
+{
+	unsigned long numaram, e820ram;
+	int i;
+
+	numaram = 0;
+	for_each_node_mask(i, mem_nodes_parsed) {
+		unsigned long s = nodes[i].start >> PAGE_SHIFT;
+		unsigned long e = nodes[i].end >> PAGE_SHIFT;
+		numaram += e - s;
+		numaram -= __absent_pages_in_range(i, s, e);
+		if ((long)numaram < 0)
+			numaram = 0;
+	}
+
+	e820ram = max_pfn -
+		(memblock_x86_hole_size(0, max_pfn<<PAGE_SHIFT) >> PAGE_SHIFT);
+	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
+	if ((long)(e820ram - numaram) >= (1<<(20 - PAGE_SHIFT))) {
+		printk(KERN_ERR "NUMA: nodes only cover %luMB of your %luMB e820 RAM. Not used.\n",
+			(numaram << PAGE_SHIFT) >> 20,
+			(e820ram << PAGE_SHIFT) >> 20);
+		return 0;
+	}
+	return 1;
+}
+
 static int __init numa_register_memblks(void)
 {
 	int i;
@@ -349,6 +380,25 @@ static int __init numa_register_memblks(void)
 		memblock_x86_register_active_regions(memblk_nodeid[i],
 				node_memblk_range[i].start >> PAGE_SHIFT,
 				node_memblk_range[i].end >> PAGE_SHIFT);
+
+	/* for out of order entries */
+	sort_node_map();
+	if (!nodes_cover_memory(numa_nodes))
+		return -EINVAL;
+
+	/* Finally register nodes. */
+	for_each_node_mask(i, node_possible_map)
+		setup_node_bootmem(i, numa_nodes[i].start, numa_nodes[i].end);
+
+	/*
+	 * Try again in case setup_node_bootmem missed one due to missing
+	 * bootmem.
+	 */
+	for_each_node_mask(i, node_possible_map)
+		if (!node_online(i))
+			setup_node_bootmem(i, numa_nodes[i].start,
+					   numa_nodes[i].end);
+
 	return 0;
 }
 
@@ -713,15 +763,14 @@ static int dummy_numa_init(void)
 	node_set(0, cpu_nodes_parsed);
 	node_set(0, mem_nodes_parsed);
 	numa_add_memblk(0, 0, (u64)max_pfn << PAGE_SHIFT);
+	numa_nodes[0].start = 0;
+	numa_nodes[0].end = (u64)max_pfn << PAGE_SHIFT;
 
 	return 0;
 }
 
 static int dummy_scan_nodes(void)
 {
-	setup_node_bootmem(0, 0, max_pfn << PAGE_SHIFT);
-	numa_init_array();
-
 	return 0;
 }
 
@@ -757,6 +806,7 @@ void __init initmem_init(void)
 		memset(node_memblk_range, 0, sizeof(node_memblk_range));
 		memset(memblk_nodeid, 0, sizeof(memblk_nodeid));
 		memset(numa_nodes, 0, sizeof(numa_nodes));
+		remove_all_active_ranges();
 
 		if (numa_init[i]() < 0)
 			continue;
@@ -781,8 +831,19 @@ void __init initmem_init(void)
 		if (numa_register_memblks() < 0)
 			continue;
 
-		if (!scan_nodes[i]())
-			return;
+		if (scan_nodes[i]() < 0)
+			continue;
+
+		for (j = 0; j < nr_cpu_ids; j++) {
+			int nid = early_cpu_to_node(j);
+
+			if (nid == NUMA_NO_NODE)
+				continue;
+			if (!node_online(nid))
+				numa_clear_node(j);
+		}
+		numa_init_array();
+		return;
 	}
 	BUG();
 }
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 755d157..4a2c33b 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -44,7 +44,6 @@ static __init void bad_srat(void)
 		numa_nodes[i].start = numa_nodes[i].end = 0;
 		nodes_add[i].start = nodes_add[i].end = 0;
 	}
-	remove_all_active_ranges();
 }
 
 static __init inline int srat_disabled(void)
@@ -259,35 +258,6 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 		update_nodes_add(node, start, end);
 }
 
-/* Sanity check to catch more bad SRATs (they are amazingly common).
-   Make sure the PXMs cover all memory. */
-static int __init nodes_cover_memory(const struct bootnode *nodes)
-{
-	int i;
-	unsigned long pxmram, e820ram;
-
-	pxmram = 0;
-	for_each_node_mask(i, mem_nodes_parsed) {
-		unsigned long s = nodes[i].start >> PAGE_SHIFT;
-		unsigned long e = nodes[i].end >> PAGE_SHIFT;
-		pxmram += e - s;
-		pxmram -= __absent_pages_in_range(i, s, e);
-		if ((long)pxmram < 0)
-			pxmram = 0;
-	}
-
-	e820ram = max_pfn - (memblock_x86_hole_size(0, max_pfn<<PAGE_SHIFT)>>PAGE_SHIFT);
-	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
-	if ((long)(e820ram - pxmram) >= (1<<(20 - PAGE_SHIFT))) {
-		printk(KERN_ERR
-	"SRAT: PXMs only cover %luMB of your %luMB e820 RAM. Not used.\n",
-			(pxmram << PAGE_SHIFT) >> 20,
-			(e820ram << PAGE_SHIFT) >> 20);
-		return 0;
-	}
-	return 1;
-}
-
 void __init acpi_numa_arch_fixup(void) {}
 
 int __init x86_acpi_numa_init(void)
@@ -303,37 +273,8 @@ int __init x86_acpi_numa_init(void)
 /* Use the information discovered above to actually set up the nodes. */
 int __init acpi_scan_nodes(void)
 {
-	int i;
-
 	if (acpi_numa <= 0)
 		return -1;
-
-	/* for out of order entries in SRAT */
-	sort_node_map();
-	if (!nodes_cover_memory(numa_nodes)) {
-		bad_srat();
-		return -1;
-	}
-
-	/* Finally register nodes */
-	for_each_node_mask(i, node_possible_map)
-		setup_node_bootmem(i, numa_nodes[i].start, numa_nodes[i].end);
-	/* Try again in case setup_node_bootmem missed one due
-	   to missing bootmem */
-	for_each_node_mask(i, node_possible_map)
-		if (!node_online(i))
-			setup_node_bootmem(i, numa_nodes[i].start,
-					   numa_nodes[i].end);
-
-	for (i = 0; i < nr_cpu_ids; i++) {
-		int node = early_cpu_to_node(i);
-
-		if (node == NUMA_NO_NODE)
-			continue;
-		if (!node_online(node))
-			numa_clear_node(i);
-	}
-	numa_init_array();
 	return 0;
 }
 
-- 
1.7.1

