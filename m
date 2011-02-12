Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab1BLRPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:15:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65372 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1BLRLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:11:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=iunzq1+Itzps9zKD4cKBpL1BNZ+v0sjcYxNSBjzzas02r89KWlkUf+PyAjYeRGp8Lt
         lKXTzJucYG5YT8aG5YWKIg0R1OeSLT5SkatE5owVNCZ9bmBKvcuMgDXk6iBsM/RMPotx
         c2BNUgZWIgACYksfMPPdDLKOGrXw7UmQ05mZk=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 23/26] x86-64, NUMA: kill numa_nodes[]
Date: Sat, 12 Feb 2011 18:11:00 +0100
Message-Id: <1297530663-26234-24-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297530663-26234-1-git-send-email-tj@kernel.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

numa_nodes[] doesn't carry any information which isn't present in
numa_meminfo.  Each entry is simply min/max range of all the memblks
for the node.  This is not only redundant but also inaccurate when
memblks for different nodes interleave - for example,
find_node_by_addr() can return the wrong nodeid.

Kill numa_nodes[] and always use numa_meminfo instead.

* nodes_cover_memory() is renamed to numa_meminfo_cover_memory() and
  now operations on numa_meminfo and returns bool.

* setup_node_bootmem() needs min/max range.  Compute the range on the
  fly.  setup_node_bootmem() invocation is restructured to use outer
  loop instead of hardcoding the double invocations.

* find_node_by_addr() now operates on numa_meminfo.

* setup_physnodes() builds physnodes[] from memblks.  This will go
  away when emulation code is updated to use struct numa_meminfo.

This patch also makes the following misc changes.

* Clearing of nodes_add[] clearing is converted to memset().

* numa_add_memblk() in amd_numa_init() is moved down a bit for
  consistency.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/numa_64.h |    1 -
 arch/x86/mm/amdtopology_64.c   |    6 +--
 arch/x86/mm/numa_64.c          |   82 +++++++++++++++++++++++----------------
 arch/x86/mm/srat_64.c          |   22 ++---------
 4 files changed, 53 insertions(+), 58 deletions(-)

diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 867d41b..da5c501 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -27,7 +27,6 @@ extern void setup_node_bootmem(int nodeid, unsigned long start,
 
 extern nodemask_t cpu_nodes_parsed __initdata;
 extern nodemask_t mem_nodes_parsed __initdata;
-extern struct bootnode numa_nodes[MAX_NUMNODES] __initdata;
 
 extern int __cpuinit numa_cpu_node(int cpu);
 extern int __init numa_add_memblk(int nodeid, u64 start, u64 end);
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index 8f7a5eb..0cb59e5 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -165,12 +165,8 @@ int __init amd_numa_init(void)
 		pr_info("Node %d MemBase %016lx Limit %016lx\n",
 			nodeid, base, limit);
 
-		numa_nodes[nodeid].start = base;
-		numa_nodes[nodeid].end = limit;
-		numa_add_memblk(nodeid, base, limit);
-
 		prevbase = base;
-
+		numa_add_memblk(nodeid, base, limit);
 		node_set(nodeid, mem_nodes_parsed);
 		node_set(nodeid, cpu_nodes_parsed);
 	}
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index ea3fb52..c0e45c7 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -46,8 +46,6 @@ static unsigned long __initdata nodemap_size;
 
 static struct numa_meminfo numa_meminfo __initdata;
 
-struct bootnode numa_nodes[MAX_NUMNODES] __initdata;
-
 /*
  * Given a shift value, try to populate memnodemap[]
  * Returns :
@@ -349,17 +347,17 @@ static int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
  * Sanity check to catch more bad NUMA configurations (they are amazingly
  * common).  Make sure the nodes cover all memory.
  */
-static int __init nodes_cover_memory(const struct bootnode *nodes)
+static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
 {
 	unsigned long numaram, e820ram;
 	int i;
 
 	numaram = 0;
-	for_each_node_mask(i, mem_nodes_parsed) {
-		unsigned long s = nodes[i].start >> PAGE_SHIFT;
-		unsigned long e = nodes[i].end >> PAGE_SHIFT;
+	for (i = 0; i < mi->nr_blks; i++) {
+		unsigned long s = mi->blk[i].start >> PAGE_SHIFT;
+		unsigned long e = mi->blk[i].end >> PAGE_SHIFT;
 		numaram += e - s;
-		numaram -= __absent_pages_in_range(i, s, e);
+		numaram -= __absent_pages_in_range(mi->blk[i].nid, s, e);
 		if ((long)numaram < 0)
 			numaram = 0;
 	}
@@ -371,14 +369,14 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
 		printk(KERN_ERR "NUMA: nodes only cover %luMB of your %luMB e820 RAM. Not used.\n",
 		       (numaram << PAGE_SHIFT) >> 20,
 		       (e820ram << PAGE_SHIFT) >> 20);
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static int __init numa_register_memblks(struct numa_meminfo *mi)
 {
-	int i;
+	int i, j, nid;
 
 	/* Account for nodes with cpus and no memory */
 	nodes_or(node_possible_map, mem_nodes_parsed, cpu_nodes_parsed);
@@ -398,21 +396,32 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 
 	/* for out of order entries */
 	sort_node_map();
-	if (!nodes_cover_memory(numa_nodes))
+	if (!numa_meminfo_cover_memory(mi))
 		return -EINVAL;
 
-	/* Finally register nodes. */
-	for_each_node_mask(i, node_possible_map)
-		setup_node_bootmem(i, numa_nodes[i].start, numa_nodes[i].end);
-
 	/*
-	 * Try again in case setup_node_bootmem missed one due to missing
-	 * bootmem.
+	 * Finally register nodes.  Do it twice in case setup_node_bootmem
+	 * missed one due to missing bootmem.
 	 */
-	for_each_node_mask(i, node_possible_map)
-		if (!node_online(i))
-			setup_node_bootmem(i, numa_nodes[i].start,
-					   numa_nodes[i].end);
+	for (i = 0; i < 2; i++) {
+		for_each_node_mask(nid, node_possible_map) {
+			u64 start = (u64)max_pfn << PAGE_SHIFT;
+			u64 end = 0;
+
+			if (node_online(nid))
+				continue;
+
+			for (j = 0; j < mi->nr_blks; j++) {
+				if (nid != mi->blk[j].nid)
+					continue;
+				start = min(mi->blk[j].start, start);
+				end = max(mi->blk[j].end, end);
+			}
+
+			if (start < end)
+				setup_node_bootmem(nid, start, end);
+		}
+	}
 
 	return 0;
 }
@@ -430,33 +439,41 @@ void __init numa_emu_cmdline(char *str)
 
 int __init find_node_by_addr(unsigned long addr)
 {
-	int ret = NUMA_NO_NODE;
+	const struct numa_meminfo *mi = &numa_meminfo;
 	int i;
 
-	for_each_node_mask(i, mem_nodes_parsed) {
+	for (i = 0; i < mi->nr_blks; i++) {
 		/*
 		 * Find the real node that this emulated node appears on.  For
 		 * the sake of simplicity, we only use a real node's starting
 		 * address to determine which emulated node it appears on.
 		 */
-		if (addr >= numa_nodes[i].start && addr < numa_nodes[i].end) {
-			ret = i;
-			break;
-		}
+		if (addr >= mi->blk[i].start && addr < mi->blk[i].end)
+			return mi->blk[i].nid;
 	}
-	return ret;
+	return NUMA_NO_NODE;
 }
 
 static int __init setup_physnodes(unsigned long start, unsigned long end)
 {
+	const struct numa_meminfo *mi = &numa_meminfo;
 	int ret = 0;
 	int i;
 
 	memset(physnodes, 0, sizeof(physnodes));
 
-	for_each_node_mask(i, mem_nodes_parsed) {
-		physnodes[i].start = numa_nodes[i].start;
-		physnodes[i].end = numa_nodes[i].end;
+	for (i = 0; i < mi->nr_blks; i++) {
+		int nid = mi->blk[i].nid;
+
+		if (physnodes[nid].start == physnodes[nid].end) {
+			physnodes[nid].start = mi->blk[i].start;
+			physnodes[nid].end = mi->blk[i].end;
+		} else {
+			physnodes[nid].start = min(physnodes[nid].start,
+						   mi->blk[i].start);
+			physnodes[nid].end = max(physnodes[nid].end,
+						 mi->blk[i].end);
+		}
 	}
 
 	/*
@@ -806,8 +823,6 @@ static int dummy_numa_init(void)
 	node_set(0, cpu_nodes_parsed);
 	node_set(0, mem_nodes_parsed);
 	numa_add_memblk(0, 0, (u64)max_pfn << PAGE_SHIFT);
-	numa_nodes[0].start = 0;
-	numa_nodes[0].end = (u64)max_pfn << PAGE_SHIFT;
 
 	return 0;
 }
@@ -838,7 +853,6 @@ void __init initmem_init(void)
 		nodes_clear(node_possible_map);
 		nodes_clear(node_online_map);
 		memset(&numa_meminfo, 0, sizeof(numa_meminfo));
-		memset(numa_nodes, 0, sizeof(numa_nodes));
 		remove_all_active_ranges();
 
 		if (numa_init[i]() < 0)
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 51d0733..e8b3b3c 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -37,13 +37,9 @@ static __init int setup_node(int pxm)
 
 static __init void bad_srat(void)
 {
-	int i;
 	printk(KERN_ERR "SRAT: SRAT not used.\n");
 	acpi_numa = -1;
-	for (i = 0; i < MAX_NUMNODES; i++) {
-		numa_nodes[i].start = numa_nodes[i].end = 0;
-		nodes_add[i].start = nodes_add[i].end = 0;
-	}
+	memset(nodes_add, 0, sizeof(nodes_add));
 }
 
 static __init inline int srat_disabled(void)
@@ -210,7 +206,6 @@ update_nodes_add(int node, unsigned long start, unsigned long end)
 void __init
 acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 {
-	struct bootnode *nd;
 	unsigned long start, end;
 	int node, pxm;
 
@@ -243,18 +238,9 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
 	       start, end);
 
-	if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)) {
-		nd = &numa_nodes[node];
-		if (!node_test_and_set(node, mem_nodes_parsed)) {
-			nd->start = start;
-			nd->end = end;
-		} else {
-			if (start < nd->start)
-				nd->start = start;
-			if (nd->end < end)
-				nd->end = end;
-		}
-	} else
+	if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE))
+		node_set(node, mem_nodes_parsed);
+	else
 		update_nodes_add(node, start, end);
 }
 
-- 
1.7.1

