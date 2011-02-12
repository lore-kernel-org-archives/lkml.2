Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab1BLRPl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:15:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51602 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab1BLRLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:11:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=I4S+N2tM+1vK2BVeyAVKIf3Y6PwqDZajDFh9rVpK4lHjXlo50AnDoDlylZz1fnV7GY
         yxI32IERTHOYC8y3dcw9MutIfyzSGHGi/zdAktUiRVmvoJ9cJvcWh8d7aFSTxwx00Ds3
         gn8B0t4LXaD1pJfE9dTFjVznYoTza5PvQ49Lg=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/26] x86-64, NUMA: Introduce struct numa_meminfo
Date: Sat, 12 Feb 2011 18:10:55 +0100
Message-Id: <1297530663-26234-19-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297530663-26234-1-git-send-email-tj@kernel.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arrays for memblks and nodeids and their length lived in separate
variables making things unnecessarily cumbersome.  Introduce struct
numa_meminfo which contains all memory configuration info.  This patch
doesn't cause any behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa_64.c |  145 +++++++++++++++++++++++++------------------------
 1 files changed, 75 insertions(+), 70 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 1d79cd8..04ea17b 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -22,6 +22,17 @@
 #include <asm/acpi.h>
 #include <asm/amd_nb.h>
 
+struct numa_memblk {
+	u64			start;
+	u64			end;
+	int			nid;
+};
+
+struct numa_meminfo {
+	int			nr_blks;
+	struct numa_memblk	blk[NR_NODE_MEMBLKS];
+};
+
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
 
@@ -33,9 +44,7 @@ struct memnode memnode;
 static unsigned long __initdata nodemap_addr;
 static unsigned long __initdata nodemap_size;
 
-static int num_node_memblks __initdata;
-static struct bootnode node_memblk_range[NR_NODE_MEMBLKS] __initdata;
-static int memblk_nodeid[NR_NODE_MEMBLKS] __initdata;
+static struct numa_meminfo numa_meminfo __initdata;
 
 struct bootnode numa_nodes[MAX_NUMNODES] __initdata;
 
@@ -46,16 +55,15 @@ struct bootnode numa_nodes[MAX_NUMNODES] __initdata;
  * 0 if memnodmap[] too small (of shift too small)
  * -1 if node overlap or lost ram (shift too big)
  */
-static int __init populate_memnodemap(const struct bootnode *nodes,
-				      int numnodes, int shift, int *nodeids)
+static int __init populate_memnodemap(const struct numa_meminfo *mi, int shift)
 {
 	unsigned long addr, end;
 	int i, res = -1;
 
 	memset(memnodemap, 0xff, sizeof(s16)*memnodemapsize);
-	for (i = 0; i < numnodes; i++) {
-		addr = nodes[i].start;
-		end = nodes[i].end;
+	for (i = 0; i < mi->nr_blks; i++) {
+		addr = mi->blk[i].start;
+		end = mi->blk[i].end;
 		if (addr >= end)
 			continue;
 		if ((end >> shift) >= memnodemapsize)
@@ -63,7 +71,7 @@ static int __init populate_memnodemap(const struct bootnode *nodes,
 		do {
 			if (memnodemap[addr >> shift] != NUMA_NO_NODE)
 				return -1;
-			memnodemap[addr >> shift] = nodeids[i];
+			memnodemap[addr >> shift] = mi->blk[i].nid;
 			addr += (1UL << shift);
 		} while (addr < end);
 		res = 1;
@@ -101,16 +109,15 @@ static int __init allocate_cachealigned_memnodemap(void)
  * The LSB of all start and end addresses in the node map is the value of the
  * maximum possible shift.
  */
-static int __init extract_lsb_from_nodes(const struct bootnode *nodes,
-					 int numnodes)
+static int __init extract_lsb_from_nodes(const struct numa_meminfo *mi)
 {
 	int i, nodes_used = 0;
 	unsigned long start, end;
 	unsigned long bitfield = 0, memtop = 0;
 
-	for (i = 0; i < numnodes; i++) {
-		start = nodes[i].start;
-		end = nodes[i].end;
+	for (i = 0; i < mi->nr_blks; i++) {
+		start = mi->blk[i].start;
+		end = mi->blk[i].end;
 		if (start >= end)
 			continue;
 		bitfield |= start;
@@ -126,18 +133,17 @@ static int __init extract_lsb_from_nodes(const struct bootnode *nodes,
 	return i;
 }
 
-static int __init compute_hash_shift(struct bootnode *nodes, int numnodes,
-				     int *nodeids)
+static int __init compute_hash_shift(const struct numa_meminfo *mi)
 {
 	int shift;
 
-	shift = extract_lsb_from_nodes(nodes, numnodes);
+	shift = extract_lsb_from_nodes(mi);
 	if (allocate_cachealigned_memnodemap())
 		return -1;
 	printk(KERN_DEBUG "NUMA: Using %d for the hash shift.\n",
 		shift);
 
-	if (populate_memnodemap(nodes, numnodes, shift, nodeids) != 1) {
+	if (populate_memnodemap(mi, shift) != 1) {
 		printk(KERN_INFO "Your memory is not aligned you need to "
 		       "rebuild your kernel with a bigger NODEMAPSIZE "
 		       "shift=%d\n", shift);
@@ -185,21 +191,25 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 
 static __init int conflicting_memblks(unsigned long start, unsigned long end)
 {
+	struct numa_meminfo *mi = &numa_meminfo;
 	int i;
-	for (i = 0; i < num_node_memblks; i++) {
-		struct bootnode *nd = &node_memblk_range[i];
-		if (nd->start == nd->end)
+
+	for (i = 0; i < mi->nr_blks; i++) {
+		struct numa_memblk *blk = &mi->blk[i];
+
+		if (blk->start == blk->end)
 			continue;
-		if (nd->end > start && nd->start < end)
-			return memblk_nodeid[i];
-		if (nd->end == end && nd->start == start)
-			return memblk_nodeid[i];
+		if (blk->end > start && blk->start < end)
+			return blk->nid;
+		if (blk->end == end && blk->start == start)
+			return blk->nid;
 	}
 	return -1;
 }
 
 int __init numa_add_memblk(int nid, u64 start, u64 end)
 {
+	struct numa_meminfo *mi = &numa_meminfo;
 	int i;
 
 	i = conflicting_memblks(start, end);
@@ -213,10 +223,10 @@ int __init numa_add_memblk(int nid, u64 start, u64 end)
 		return -EINVAL;
 	}
 
-	node_memblk_range[num_node_memblks].start = start;
-	node_memblk_range[num_node_memblks].end = end;
-	memblk_nodeid[num_node_memblks] = nid;
-	num_node_memblks++;
+	mi->blk[mi->nr_blks].start = start;
+	mi->blk[mi->nr_blks].end = end;
+	mi->blk[mi->nr_blks].nid = nid;
+	mi->nr_blks++;
 	return 0;
 }
 
@@ -315,66 +325,59 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
 
 static int __init numa_register_memblks(void)
 {
+	struct numa_meminfo *mi = &numa_meminfo;
 	int i;
 
 	/*
 	 * Join together blocks on the same node, holes between
 	 * which don't overlap with memory on other nodes.
 	 */
-	for (i = 0; i < num_node_memblks; ++i) {
+	for (i = 0; i < mi->nr_blks; ++i) {
+		struct numa_memblk *bi = &mi->blk[i];
 		int j, k;
 
-		for (j = i + 1; j < num_node_memblks; ++j) {
+		for (j = i + 1; j < mi->nr_blks; ++j) {
+			struct numa_memblk *bj = &mi->blk[j];
 			unsigned long start, end;
 
-			if (memblk_nodeid[i] != memblk_nodeid[j])
+			if (bi->nid != bj->nid)
 				continue;
-			start = min(node_memblk_range[i].end,
-			            node_memblk_range[j].end);
-			end = max(node_memblk_range[i].start,
-			          node_memblk_range[j].start);
-			for (k = 0; k < num_node_memblks; ++k) {
-				if (memblk_nodeid[i] == memblk_nodeid[k])
+			start = min(bi->end, bj->end);
+			end = max(bi->start, bj->start);
+			for (k = 0; k < mi->nr_blks; ++k) {
+				struct numa_memblk *bk = &mi->blk[k];
+
+				if (bi->nid == bk->nid)
 					continue;
-				if (start < node_memblk_range[k].end &&
-				    end > node_memblk_range[k].start)
+				if (start < bk->end && end > bk->start)
 					break;
 			}
-			if (k < num_node_memblks)
+			if (k < mi->nr_blks)
 				continue;
-			start = min(node_memblk_range[i].start,
-			            node_memblk_range[j].start);
-			end = max(node_memblk_range[i].end,
-			          node_memblk_range[j].end);
+			start = min(bi->start, bj->start);
+			end = max(bi->end, bj->end);
 			printk(KERN_INFO "NUMA: Node %d [%Lx,%Lx) + [%Lx,%Lx) -> [%lx,%lx)\n",
-			       memblk_nodeid[i],
-			       node_memblk_range[i].start,
-			       node_memblk_range[i].end,
-			       node_memblk_range[j].start,
-			       node_memblk_range[j].end,
+			       bi->nid, bi->start, bi->end, bj->start, bj->end,
 			       start, end);
-			node_memblk_range[i].start = start;
-			node_memblk_range[i].end = end;
-			k = --num_node_memblks - j;
-			memmove(memblk_nodeid + j, memblk_nodeid + j+1,
-				k * sizeof(*memblk_nodeid));
-			memmove(node_memblk_range + j, node_memblk_range + j+1,
-				k * sizeof(*node_memblk_range));
+			bi->start = start;
+			bi->end = end;
+			k = --mi->nr_blks - j;
+			memmove(mi->blk + j, mi->blk + j + 1,
+				k * sizeof(mi->blk[0]));
 			--j;
 		}
 	}
 
-	memnode_shift = compute_hash_shift(node_memblk_range, num_node_memblks,
-					   memblk_nodeid);
+	memnode_shift = compute_hash_shift(mi);
 	if (memnode_shift < 0) {
 		printk(KERN_ERR "NUMA: No NUMA node hash function found. Contact maintainer\n");
 		return -EINVAL;
 	}
 
-	for (i = 0; i < num_node_memblks; i++)
-		memblock_x86_register_active_regions(memblk_nodeid[i],
-				node_memblk_range[i].start >> PAGE_SHIFT,
-				node_memblk_range[i].end >> PAGE_SHIFT);
+	for (i = 0; i < mi->nr_blks; i++)
+		memblock_x86_register_active_regions(mi->blk[i].nid,
+					mi->blk[i].start >> PAGE_SHIFT,
+					mi->blk[i].end >> PAGE_SHIFT);
 
 	/* for out of order entries */
 	sort_node_map();
@@ -699,7 +702,7 @@ static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
 static int __init numa_emulation(unsigned long start_pfn,
 			unsigned long last_pfn, int acpi, int amd)
 {
-	static int nodeid[NR_NODE_MEMBLKS] __initdata;
+	static struct numa_meminfo ei __initdata;
 	u64 addr = start_pfn << PAGE_SHIFT;
 	u64 max_addr = last_pfn << PAGE_SHIFT;
 	int num_nodes;
@@ -725,10 +728,14 @@ static int __init numa_emulation(unsigned long start_pfn,
 	if (num_nodes < 0)
 		return num_nodes;
 
-	for (i = 0; i < ARRAY_SIZE(nodeid); i++)
-		nodeid[i] = i;
+	ei.nr_blks = num_nodes;
+	for (i = 0; i < ei.nr_blks; i++) {
+		ei.blk[i].start = nodes[i].start;
+		ei.blk[i].end = nodes[i].end;
+		ei.blk[i].nid = i;
+	}
 
-	memnode_shift = compute_hash_shift(nodes, num_nodes, nodeid);
+	memnode_shift = compute_hash_shift(&ei);
 	if (memnode_shift < 0) {
 		memnode_shift = 0;
 		printk(KERN_ERR "No NUMA hash function found.  NUMA emulation "
@@ -794,9 +801,7 @@ void __init initmem_init(void)
 		nodes_clear(mem_nodes_parsed);
 		nodes_clear(node_possible_map);
 		nodes_clear(node_online_map);
-		num_node_memblks = 0;
-		memset(node_memblk_range, 0, sizeof(node_memblk_range));
-		memset(memblk_nodeid, 0, sizeof(memblk_nodeid));
+		memset(&numa_meminfo, 0, sizeof(numa_meminfo));
 		memset(numa_nodes, 0, sizeof(numa_nodes));
 		remove_all_active_ranges();
 
-- 
1.7.1

