Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215Ab1BPMZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:25:36 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36104 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab1BPMVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:21:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=UA77ZdEZlKtw4xmwb9klJ6EeAvZrdwKKNl2MqZY6NfEkZT9fM+TKDNQ8z066S8F1gw
         guDGycyu98K5uXUTKS9cl4GOI4VYCEJRY0f/uSzYCn3ud6U/8u1GgQC+TdzOxwi9VYGM
         nz5FSLbPSSBbghvSNwV4j9q4g/AtpSdy8BGDI=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 21/33] x86-64, NUMA: consolidate and improve memblk sanity checks
Date: Wed, 16 Feb 2011 13:20:55 +0100
Message-Id: <1297858867-25981-22-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblk sanity check was scattered around and incomplete.  Consolidate
and improve.

* Confliction detection and cutoff_node() logic are moved to
  numa_cleanup_meminfo().

* numa_cleanup_meminfo() clears the unused memblks before returning.

* Check and warn about invalid input parameters in numa_add_memblk().

* Check the maximum number of memblk isn't exceeded in
  numa_add_memblk().

* numa_cleanup_meminfo() is now called before numa_emulation() so that
  the emulation code also uses the cleaned up version.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa_64.c |   99 ++++++++++++++++++++++++-------------------------
 1 files changed, 49 insertions(+), 50 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 4fd3368..20aa1d3 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -189,37 +189,23 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 	return NULL;
 }
 
-static __init int conflicting_memblks(unsigned long start, unsigned long end)
+int __init numa_add_memblk(int nid, u64 start, u64 end)
 {
 	struct numa_meminfo *mi = &numa_meminfo;
-	int i;
 
-	for (i = 0; i < mi->nr_blks; i++) {
-		struct numa_memblk *blk = &mi->blk[i];
+	/* ignore zero length blks */
+	if (start == end)
+		return 0;
 
-		if (blk->start == blk->end)
-			continue;
-		if (blk->end > start && blk->start < end)
-			return blk->nid;
-		if (blk->end == end && blk->start == start)
-			return blk->nid;
+	/* whine about and ignore invalid blks */
+	if (start > end || nid < 0 || nid >= MAX_NUMNODES) {
+		pr_warning("NUMA: Warning: invalid memblk node %d (%Lx-%Lx)\n",
+			   nid, start, end);
+		return 0;
 	}
-	return -1;
-}
-
-int __init numa_add_memblk(int nid, u64 start, u64 end)
-{
-	struct numa_meminfo *mi = &numa_meminfo;
-	int i;
 
-	i = conflicting_memblks(start, end);
-	if (i == nid) {
-		printk(KERN_WARNING "NUMA: Warning: node %d (%Lx-%Lx) overlaps with itself (%Lx-%Lx)\n",
-		       nid, start, end, numa_nodes[i].start, numa_nodes[i].end);
-	} else if (i >= 0) {
-		printk(KERN_ERR "NUMA: node %d (%Lx-%Lx) overlaps with node %d (%Lx-%Lx)\n",
-		       nid, start, end, i,
-		       numa_nodes[i].start, numa_nodes[i].end);
+	if (mi->nr_blks >= NR_NODE_MEMBLKS) {
+		pr_err("NUMA: too many memblk ranges\n");
 		return -EINVAL;
 	}
 
@@ -237,22 +223,6 @@ static void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi)
 		(mi->nr_blks - idx) * sizeof(mi->blk[0]));
 }
 
-static __init void cutoff_node(int i, unsigned long start, unsigned long end)
-{
-	struct bootnode *nd = &numa_nodes[i];
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
 /* Initialize bootmem allocator for a node */
 void __init
 setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
@@ -301,24 +271,53 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 
 static int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 {
+	const u64 low = 0;
+	const u64 high = (u64)max_pfn << PAGE_SHIFT;
 	int i, j, k;
 
 	for (i = 0; i < mi->nr_blks; i++) {
 		struct numa_memblk *bi = &mi->blk[i];
 
+		/* make sure all blocks are inside the limits */
+		bi->start = max(bi->start, low);
+		bi->end = min(bi->end, high);
+
+		/* and there's no empty block */
+		if (bi->start == bi->end) {
+			numa_remove_memblk_from(i--, mi);
+			continue;
+		}
+
 		for (j = i + 1; j < mi->nr_blks; j++) {
 			struct numa_memblk *bj = &mi->blk[j];
 			unsigned long start, end;
 
 			/*
+			 * See whether there are overlapping blocks.  Whine
+			 * about but allow overlaps of the same nid.  They
+			 * will be merged below.
+			 */
+			if (bi->end > bj->start && bi->start < bj->end) {
+				if (bi->nid != bj->nid) {
+					pr_err("NUMA: node %d (%Lx-%Lx) overlaps with node %d (%Lx-%Lx)\n",
+					       bi->nid, bi->start, bi->end,
+					       bj->nid, bj->start, bj->end);
+					return -EINVAL;
+				}
+				pr_warning("NUMA: Warning: node %d (%Lx-%Lx) overlaps with itself (%Lx-%Lx)\n",
+					   bi->nid, bi->start, bi->end,
+					   bj->start, bj->end);
+			}
+
+			/*
 			 * Join together blocks on the same node, holes
 			 * between which don't overlap with memory on other
 			 * nodes.
 			 */
 			if (bi->nid != bj->nid)
 				continue;
-			start = min(bi->start, bj->start);
-			end = max(bi->end, bj->end);
+			start = max(min(bi->start, bj->start), low);
+			end = min(max(bi->end, bj->end), high);
 			for (k = 0; k < mi->nr_blks; k++) {
 				struct numa_memblk *bk = &mi->blk[k];
 
@@ -338,6 +337,11 @@ static int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 		}
 	}
 
+	for (i = mi->nr_blks; i < ARRAY_SIZE(mi->blk); i++) {
+		mi->blk[i].start = mi->blk[i].end = 0;
+		mi->blk[i].nid = NUMA_NO_NODE;
+	}
+
 	return 0;
 }
 
@@ -824,10 +828,8 @@ void __init initmem_init(void)
 		if (numa_init[i]() < 0)
 			continue;
 
-		/* clean up the node list */
-		for (j = 0; j < MAX_NUMNODES; j++)
-			cutoff_node(j, 0, max_pfn << PAGE_SHIFT);
-
+		if (numa_cleanup_meminfo(&numa_meminfo) < 0)
+			continue;
 #ifdef CONFIG_NUMA_EMU
 		setup_physnodes(0, max_pfn << PAGE_SHIFT);
 		if (cmdline && !numa_emulation(0, max_pfn, i == 0, i == 1))
@@ -836,9 +838,6 @@ void __init initmem_init(void)
 		nodes_clear(node_possible_map);
 		nodes_clear(node_online_map);
 #endif
-		if (numa_cleanup_meminfo(&numa_meminfo) < 0)
-			continue;
-
 		if (numa_register_memblks(&numa_meminfo) < 0)
 			continue;
 
-- 
1.7.1

