Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540Ab1D2Pbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:31:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54924 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759432Ab1D2P3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:29:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=aHEKnXcOxJ2yYSmoTTldkDufVKRByvtnkm8BNUUKD2q8rvP9uWuMzZJwlXyjJpO+I+
         Tu1e15VPOlzftkveNOdWZHLk/p28EXaL5/062+r/0u5wKriM1rtzu8V4X9tdmS3+CkMM
         xidU9kkAStt5yPqgkj/J+Tt2wl9i7RMMNFl5Y=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/25] x86, NUMA: Remove long 64bit assumption from numa.c
Date: Fri, 29 Apr 2011 17:28:37 +0200
Message-Id: <1304090924-8197-19-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code moved from numa_64.c has assumption that long is 64bit in several
places.  This patch removes the assumption by using {s|u}64_t
explicity, using PFN_PHYS() for page number -> addr conversions and
adjusting printf formats.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/numa.c |   45 ++++++++++++++++++++++-----------------------
 1 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 22dc9ed..b2fca54 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -192,13 +192,12 @@ int __init numa_add_memblk(int nid, u64 start, u64 end)
 #endif
 
 /* Initialize bootmem allocator for a node */
-static void __init
-setup_node_bootmem(int nid, unsigned long start, unsigned long end)
+static void __init setup_node_bootmem(int nid, u64 start, u64 end)
 {
-	const u64 nd_low = (u64)MAX_DMA_PFN << PAGE_SHIFT;
-	const u64 nd_high = (u64)max_pfn_mapped << PAGE_SHIFT;
+	const u64 nd_low = PFN_PHYS(MAX_DMA_PFN);
+	const u64 nd_high = PFN_PHYS(max_pfn_mapped);
 	const size_t nd_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
-	unsigned long nd_pa;
+	u64 nd_pa;
 	int tnid;
 
 	/*
@@ -210,7 +209,7 @@ setup_node_bootmem(int nid, unsigned long start, unsigned long end)
 
 	start = roundup(start, ZONE_ALIGN);
 
-	printk(KERN_INFO "Initmem setup node %d %016lx-%016lx\n",
+	printk(KERN_INFO "Initmem setup node %d %016Lx-%016Lx\n",
 	       nid, start, end);
 
 	/*
@@ -223,13 +222,13 @@ setup_node_bootmem(int nid, unsigned long start, unsigned long end)
 		nd_pa = memblock_find_in_range(nd_low, nd_high,
 					       nd_size, SMP_CACHE_BYTES);
 	if (nd_pa == MEMBLOCK_ERROR) {
-		pr_err("Cannot find %lu bytes in node %d\n", nd_size, nid);
+		pr_err("Cannot find %zu bytes in node %d\n", nd_size, nid);
 		return;
 	}
 	memblock_x86_reserve_range(nd_pa, nd_pa + nd_size, "NODE_DATA");
 
 	/* report and initialize */
-	printk(KERN_INFO "  NODE_DATA [%016lx - %016lx]\n",
+	printk(KERN_INFO "  NODE_DATA [%016Lx - %016Lx]\n",
 	       nd_pa, nd_pa + nd_size - 1);
 	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
 	if (tnid != nid)
@@ -257,7 +256,7 @@ setup_node_bootmem(int nid, unsigned long start, unsigned long end)
 int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 {
 	const u64 low = 0;
-	const u64 high = (u64)max_pfn << PAGE_SHIFT;
+	const u64 high = PFN_PHYS(max_pfn);
 	int i, j, k;
 
 	for (i = 0; i < mi->nr_blks; i++) {
@@ -275,7 +274,7 @@ int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 
 		for (j = i + 1; j < mi->nr_blks; j++) {
 			struct numa_memblk *bj = &mi->blk[j];
-			unsigned long start, end;
+			u64 start, end;
 
 			/*
 			 * See whether there are overlapping blocks.  Whine
@@ -313,7 +312,7 @@ int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 			}
 			if (k < mi->nr_blks)
 				continue;
-			printk(KERN_INFO "NUMA: Node %d [%Lx,%Lx) + [%Lx,%Lx) -> [%lx,%lx)\n",
+			printk(KERN_INFO "NUMA: Node %d [%Lx,%Lx) + [%Lx,%Lx) -> [%Lx,%Lx)\n",
 			       bi->nid, bi->start, bi->end, bj->start, bj->end,
 			       start, end);
 			bi->start = start;
@@ -378,7 +377,7 @@ static int __init numa_alloc_distance(void)
 	cnt++;
 	size = cnt * cnt * sizeof(numa_distance[0]);
 
-	phys = memblock_find_in_range(0, (u64)max_pfn_mapped << PAGE_SHIFT,
+	phys = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
 				      size, PAGE_SIZE);
 	if (phys == MEMBLOCK_ERROR) {
 		pr_warning("NUMA: Warning: can't allocate distance table!\n");
@@ -456,24 +455,24 @@ EXPORT_SYMBOL(__node_distance);
  */
 static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
 {
-	unsigned long numaram, e820ram;
+	u64 numaram, e820ram;
 	int i;
 
 	numaram = 0;
 	for (i = 0; i < mi->nr_blks; i++) {
-		unsigned long s = mi->blk[i].start >> PAGE_SHIFT;
-		unsigned long e = mi->blk[i].end >> PAGE_SHIFT;
+		u64 s = mi->blk[i].start >> PAGE_SHIFT;
+		u64 e = mi->blk[i].end >> PAGE_SHIFT;
 		numaram += e - s;
 		numaram -= __absent_pages_in_range(mi->blk[i].nid, s, e);
-		if ((long)numaram < 0)
+		if ((s64)numaram < 0)
 			numaram = 0;
 	}
 
 	e820ram = max_pfn - (memblock_x86_hole_size(0,
-					max_pfn << PAGE_SHIFT) >> PAGE_SHIFT);
+					PFN_PHYS(max_pfn)) >> PAGE_SHIFT);
 	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
-	if ((long)(e820ram - numaram) >= (1 << (20 - PAGE_SHIFT))) {
-		printk(KERN_ERR "NUMA: nodes only cover %luMB of your %luMB e820 RAM. Not used.\n",
+	if ((s64)(e820ram - numaram) >= (1 << (20 - PAGE_SHIFT))) {
+		printk(KERN_ERR "NUMA: nodes only cover %LuMB of your %LuMB e820 RAM. Not used.\n",
 		       (numaram << PAGE_SHIFT) >> 20,
 		       (e820ram << PAGE_SHIFT) >> 20);
 		return false;
@@ -503,7 +502,7 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 
 	/* Finally register nodes. */
 	for_each_node_mask(nid, node_possible_map) {
-		u64 start = (u64)max_pfn << PAGE_SHIFT;
+		u64 start = PFN_PHYS(max_pfn);
 		u64 end = 0;
 
 		for (i = 0; i < mi->nr_blks; i++) {
@@ -595,11 +594,11 @@ static int __init dummy_numa_init(void)
 {
 	printk(KERN_INFO "%s\n",
 	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
-	printk(KERN_INFO "Faking a node at %016lx-%016lx\n",
-	       0LU, max_pfn << PAGE_SHIFT);
+	printk(KERN_INFO "Faking a node at %016Lx-%016Lx\n",
+	       0LLU, PFN_PHYS(max_pfn));
 
 	node_set(0, numa_nodes_parsed);
-	numa_add_memblk(0, 0, (u64)max_pfn << PAGE_SHIFT);
+	numa_add_memblk(0, 0, PFN_PHYS(max_pfn));
 
 	return 0;
 }
-- 
1.7.1

