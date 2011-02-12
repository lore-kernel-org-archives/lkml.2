Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab1BLRNF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:13:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44248 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1BLRLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:11:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=BnWDPtjULVO4qx52RbKevxUkCPP3v608PVLJuVXjAih1iQGY5uVUwMq9aLw/KoFe/t
         ueoKNUQf4guDPCg1ChmEZM2VzATNT3FFb+GRQO9oXsbsd6z+rDR66gx5EKsirIH+Hsms
         BpVNqjdWFsAdBx2Tri/QQXBZtKI8as1m2i0h0=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/26] x86-64, NUMA: Factor out memblk handling into numa_{add|register}_memblk()
Date: Sat, 12 Feb 2011 18:10:50 +0100
Message-Id: <1297530663-26234-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297530663-26234-1-git-send-email-tj@kernel.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out memblk handling from srat_64.c into two functions in
numa_64.c.  This patch doesn't introduce any behavior change.  The
next patch will make all init methods use these functions.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/acpi.h    |    1 -
 arch/x86/include/asm/numa_64.h |    5 ++-
 arch/x86/mm/numa_64.c          |  109 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/srat_64.c          |   96 +----------------------------------
 4 files changed, 116 insertions(+), 95 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 446a5b9..12bd1fd 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -187,7 +187,6 @@ struct bootnode;
 extern int acpi_numa;
 extern int x86_acpi_numa_init(void);
 extern int acpi_scan_nodes(void);
-#define NR_NODE_MEMBLKS (MAX_NUMNODES*2)
 
 #ifdef CONFIG_NUMA_EMU
 extern void acpi_fake_nodes(const struct bootnode *fake_nodes,
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index d3a4514..2b6a1c5 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -25,13 +25,16 @@ extern void setup_node_bootmem(int nodeid, unsigned long start,
  * result from BIOS bugs. So dont recognize nodes as standalone
  * NUMA entities that have less than this amount of RAM listed:
  */
-#define NODE_MIN_SIZE (4*1024*1024)
+#define NODE_MIN_SIZE		(4*1024*1024)
+#define NR_NODE_MEMBLKS		(MAX_NUMNODES*2)
 
 extern nodemask_t cpu_nodes_parsed __initdata;
 extern nodemask_t mem_nodes_parsed __initdata;
 extern struct bootnode numa_nodes[MAX_NUMNODES] __initdata;
 
 extern int __cpuinit numa_cpu_node(int cpu);
+extern int __init numa_add_memblk(int nodeid, u64 start, u64 end);
+extern int __init numa_register_memblks(void);
 
 #ifdef CONFIG_NUMA_EMU
 #define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 2d3ee2f..bbc42ca 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -33,6 +33,10 @@ struct memnode memnode;
 static unsigned long __initdata nodemap_addr;
 static unsigned long __initdata nodemap_size;
 
+static int num_node_memblks __initdata;
+static struct bootnode node_memblk_range[NR_NODE_MEMBLKS] __initdata;
+static int memblk_nodeid[NR_NODE_MEMBLKS] __initdata;
+
 struct bootnode numa_nodes[MAX_NUMNODES] __initdata;
 
 /*
@@ -184,6 +188,43 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 	return NULL;
 }
 
+static __init int conflicting_memblks(unsigned long start, unsigned long end)
+{
+	int i;
+	for (i = 0; i < num_node_memblks; i++) {
+		struct bootnode *nd = &node_memblk_range[i];
+		if (nd->start == nd->end)
+			continue;
+		if (nd->end > start && nd->start < end)
+			return memblk_nodeid[i];
+		if (nd->end == end && nd->start == start)
+			return memblk_nodeid[i];
+	}
+	return -1;
+}
+
+int __init numa_add_memblk(int nid, u64 start, u64 end)
+{
+	int i;
+
+	i = conflicting_memblks(start, end);
+	if (i == nid) {
+		printk(KERN_WARNING "NUMA: Warning: node %d (%Lx-%Lx) overlaps with itself (%Lx-%Lx)\n",
+		       nid, start, end, numa_nodes[i].start, numa_nodes[i].end);
+	} else if (i >= 0) {
+		printk(KERN_ERR "NUMA: node %d (%Lx-%Lx) overlaps with node %d (%Lx-%Lx)\n",
+		       nid, start, end, i,
+		       numa_nodes[i].start, numa_nodes[i].end);
+		return -EINVAL;
+	}
+
+	node_memblk_range[num_node_memblks].start = start;
+	node_memblk_range[num_node_memblks].end = end;
+	memblk_nodeid[num_node_memblks] = nid;
+	num_node_memblks++;
+	return 0;
+}
+
 static __init void cutoff_node(int i, unsigned long start, unsigned long end)
 {
 	struct bootnode *nd = &numa_nodes[i];
@@ -246,6 +287,71 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 	node_set_online(nodeid);
 }
 
+int __init numa_register_memblks(void)
+{
+	int i;
+
+	/*
+	 * Join together blocks on the same node, holes between
+	 * which don't overlap with memory on other nodes.
+	 */
+	for (i = 0; i < num_node_memblks; ++i) {
+		int j, k;
+
+		for (j = i + 1; j < num_node_memblks; ++j) {
+			unsigned long start, end;
+
+			if (memblk_nodeid[i] != memblk_nodeid[j])
+				continue;
+			start = min(node_memblk_range[i].end,
+			            node_memblk_range[j].end);
+			end = max(node_memblk_range[i].start,
+			          node_memblk_range[j].start);
+			for (k = 0; k < num_node_memblks; ++k) {
+				if (memblk_nodeid[i] == memblk_nodeid[k])
+					continue;
+				if (start < node_memblk_range[k].end &&
+				    end > node_memblk_range[k].start)
+					break;
+			}
+			if (k < num_node_memblks)
+				continue;
+			start = min(node_memblk_range[i].start,
+			            node_memblk_range[j].start);
+			end = max(node_memblk_range[i].end,
+			          node_memblk_range[j].end);
+			printk(KERN_INFO "NUMA: Node %d [%Lx,%Lx) + [%Lx,%Lx) -> [%lx,%lx)\n",
+			       memblk_nodeid[i],
+			       node_memblk_range[i].start,
+			       node_memblk_range[i].end,
+			       node_memblk_range[j].start,
+			       node_memblk_range[j].end,
+			       start, end);
+			node_memblk_range[i].start = start;
+			node_memblk_range[i].end = end;
+			k = --num_node_memblks - j;
+			memmove(memblk_nodeid + j, memblk_nodeid + j+1,
+				k * sizeof(*memblk_nodeid));
+			memmove(node_memblk_range + j, node_memblk_range + j+1,
+				k * sizeof(*node_memblk_range));
+			--j;
+		}
+	}
+
+	memnode_shift = compute_hash_shift(node_memblk_range, num_node_memblks,
+					   memblk_nodeid);
+	if (memnode_shift < 0) {
+		printk(KERN_ERR "NUMA: No NUMA node hash function found. Contact maintainer\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < num_node_memblks; i++)
+		memblock_x86_register_active_regions(memblk_nodeid[i],
+				node_memblk_range[i].start >> PAGE_SHIFT,
+				node_memblk_range[i].end >> PAGE_SHIFT);
+	return 0;
+}
+
 #ifdef CONFIG_NUMA_EMU
 /* Numa emulation */
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
@@ -651,6 +757,9 @@ void __init initmem_init(void)
 		nodes_clear(mem_nodes_parsed);
 		nodes_clear(node_possible_map);
 		nodes_clear(node_online_map);
+		num_node_memblks = 0;
+		memset(node_memblk_range, 0, sizeof(node_memblk_range));
+		memset(memblk_nodeid, 0, sizeof(memblk_nodeid));
 		memset(numa_nodes, 0, sizeof(numa_nodes));
 
 		if (numa_init[i]() < 0)
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index d84c983..b0f0616 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -30,30 +30,11 @@ static struct acpi_table_slit *acpi_slit;
 
 static struct bootnode nodes_add[MAX_NUMNODES];
 
-static int num_node_memblks __initdata;
-static struct bootnode node_memblk_range[NR_NODE_MEMBLKS] __initdata;
-static int memblk_nodeid[NR_NODE_MEMBLKS] __initdata;
-
 static __init int setup_node(int pxm)
 {
 	return acpi_map_pxm_to_node(pxm);
 }
 
-static __init int conflicting_memblks(unsigned long start, unsigned long end)
-{
-	int i;
-	for (i = 0; i < num_node_memblks; i++) {
-		struct bootnode *nd = &node_memblk_range[i];
-		if (nd->start == nd->end)
-			continue;
-		if (nd->end > start && nd->start < end)
-			return memblk_nodeid[i];
-		if (nd->end == end && nd->start == start)
-			return memblk_nodeid[i];
-	}
-	return -1;
-}
-
 static __init void bad_srat(void)
 {
 	int i;
@@ -233,7 +214,6 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	struct bootnode *nd;
 	unsigned long start, end;
 	int node, pxm;
-	int i;
 
 	if (srat_disabled())
 		return;
@@ -255,16 +235,8 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 		bad_srat();
 		return;
 	}
-	i = conflicting_memblks(start, end);
-	if (i == node) {
-		printk(KERN_WARNING
-		"SRAT: Warning: PXM %d (%lx-%lx) overlaps with itself (%Lx-%Lx)\n",
-		       pxm, start, end, numa_nodes[i].start, numa_nodes[i].end);
-	} else if (i >= 0) {
-		printk(KERN_ERR
-		       "SRAT: PXM %d (%lx-%lx) overlaps with PXM %d (%Lx-%Lx)\n",
-		       pxm, start, end, node_to_pxm(i),
-		       numa_nodes[i].start, numa_nodes[i].end);
+
+	if (numa_add_memblk(node, start, end) < 0) {
 		bad_srat();
 		return;
 	}
@@ -285,11 +257,6 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 		}
 	} else
 		update_nodes_add(node, start, end);
-
-	node_memblk_range[num_node_memblks].start = start;
-	node_memblk_range[num_node_memblks].end = end;
-	memblk_nodeid[num_node_memblks] = node;
-	num_node_memblks++;
 }
 
 /* Sanity check to catch more bad SRATs (they are amazingly common).
@@ -341,68 +308,11 @@ int __init acpi_scan_nodes(void)
 	if (acpi_numa <= 0)
 		return -1;
 
-	/*
-	 * Join together blocks on the same node, holes between
-	 * which don't overlap with memory on other nodes.
-	 */
-	for (i = 0; i < num_node_memblks; ++i) {
-		int j, k;
-
-		for (j = i + 1; j < num_node_memblks; ++j) {
-			unsigned long start, end;
-
-			if (memblk_nodeid[i] != memblk_nodeid[j])
-				continue;
-			start = min(node_memblk_range[i].end,
-			            node_memblk_range[j].end);
-			end = max(node_memblk_range[i].start,
-			          node_memblk_range[j].start);
-			for (k = 0; k < num_node_memblks; ++k) {
-				if (memblk_nodeid[i] == memblk_nodeid[k])
-					continue;
-				if (start < node_memblk_range[k].end &&
-				    end > node_memblk_range[k].start)
-					break;
-			}
-			if (k < num_node_memblks)
-				continue;
-			start = min(node_memblk_range[i].start,
-			            node_memblk_range[j].start);
-			end = max(node_memblk_range[i].end,
-			          node_memblk_range[j].end);
-			printk(KERN_INFO "SRAT: Node %d "
-			       "[%Lx,%Lx) + [%Lx,%Lx) -> [%lx,%lx)\n",
-			       memblk_nodeid[i],
-			       node_memblk_range[i].start,
-			       node_memblk_range[i].end,
-			       node_memblk_range[j].start,
-			       node_memblk_range[j].end,
-			       start, end);
-			node_memblk_range[i].start = start;
-			node_memblk_range[i].end = end;
-			k = --num_node_memblks - j;
-			memmove(memblk_nodeid + j, memblk_nodeid + j+1,
-				k * sizeof(*memblk_nodeid));
-			memmove(node_memblk_range + j, node_memblk_range + j+1,
-				k * sizeof(*node_memblk_range));
-			--j;
-		}
-	}
-
-	memnode_shift = compute_hash_shift(node_memblk_range, num_node_memblks,
-					   memblk_nodeid);
-	if (memnode_shift < 0) {
-		printk(KERN_ERR
-		     "SRAT: No NUMA node hash function found. Contact maintainer\n");
+	if (numa_register_memblks() < 0) {
 		bad_srat();
 		return -1;
 	}
 
-	for (i = 0; i < num_node_memblks; i++)
-		memblock_x86_register_active_regions(memblk_nodeid[i],
-				node_memblk_range[i].start >> PAGE_SHIFT,
-				node_memblk_range[i].end >> PAGE_SHIFT);
-
 	/* for out of order entries in SRAT */
 	sort_node_map();
 	if (!nodes_cover_memory(numa_nodes)) {
-- 
1.7.1

