Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab1DGCFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:05:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:50890 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146Ab1DGCFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:05:21 -0400
Date: Thu, 7 Apr 2011 02:05:10 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
In-Reply-To: <1301955840-7246-5-git-send-email-tj@kernel.org>
References: <1301955840-7246-5-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86-32, numa: Reorganize calculate_numa_remap_page()
Message-ID: <tip-5510db9c1be111528ce46c57f0bec1c9dce258f4@git.kernel.org>
Git-Commit-ID: 5510db9c1be111528ce46c57f0bec1c9dce258f4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Apr 2011 02:05:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5510db9c1be111528ce46c57f0bec1c9dce258f4
Gitweb:     http://git.kernel.org/tip/5510db9c1be111528ce46c57f0bec1c9dce258f4
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 5 Apr 2011 00:23:50 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Apr 2011 17:57:01 -0700

x86-32, numa: Reorganize calculate_numa_remap_page()

Separate the outer node walking loop and per-node logic from
calculate_numa_remap_pages().  The outer loop is collapsed into
initmem_init() and the per-node logic is moved into a new function -
init_alloc_remap().

The new function name is confusing with the existing
init_remap_allocator() and the behavior is the function isn't very
clean either at this point, but this is to prepare for further
cleanups and it will become prettier.

This function doesn't introduce any behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1301955840-7246-5-git-send-email-tj@kernel.org
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/numa_32.c |  127 ++++++++++++++++++++++++-------------------------
 1 files changed, 63 insertions(+), 64 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 60701a5..5039e9b 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -264,70 +264,64 @@ void resume_map_numa_kva(pgd_t *pgd_base)
 }
 #endif
 
-static __init unsigned long calculate_numa_remap_pages(void)
+static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 {
-	int nid;
-	unsigned long size, reserve_pages = 0;
+	unsigned long size;
+	u64 node_kva;
 
-	for_each_online_node(nid) {
-		u64 node_kva;
-
-		/*
-		 * The acpi/srat node info can show hot-add memroy zones
-		 * where memory could be added but not currently present.
-		 */
-		printk(KERN_DEBUG "node %d pfn: [%lx - %lx]\n",
-			nid, node_start_pfn[nid], node_end_pfn[nid]);
-		if (node_start_pfn[nid] > max_pfn)
-			continue;
-		if (!node_end_pfn[nid])
-			continue;
-		if (node_end_pfn[nid] > max_pfn)
-			node_end_pfn[nid] = max_pfn;
-
-		/* ensure the remap includes space for the pgdat. */
-		size = node_remap_size[nid];
-		size += ALIGN(sizeof(pg_data_t), PAGE_SIZE);
-
-		/* convert size to large (pmd size) pages, rounding up */
-		size = (size + LARGE_PAGE_BYTES - 1) / LARGE_PAGE_BYTES;
-		/* now the roundup is correct, convert to PAGE_SIZE pages */
-		size = size * PTRS_PER_PTE;
-
-		node_kva = memblock_find_in_range(node_start_pfn[nid] << PAGE_SHIFT,
-					((u64)node_end_pfn[nid])<<PAGE_SHIFT,
-					((u64)size)<<PAGE_SHIFT,
-					LARGE_PAGE_BYTES);
-		if (node_kva == MEMBLOCK_ERROR)
-			panic("Can not get kva ram\n");
-
-		node_remap_size[nid] = size;
-		node_remap_offset[nid] = reserve_pages;
-		reserve_pages += size;
-		printk(KERN_DEBUG "Reserving %ld pages of KVA for lmem_map of"
-				  " node %d at %llx\n",
-				size, nid, node_kva >> PAGE_SHIFT);
-
-		/*
-		 *  prevent kva address below max_low_pfn want it on system
-		 *  with less memory later.
-		 *  layout will be: KVA address , KVA RAM
-		 *
-		 *  we are supposed to only record the one less then max_low_pfn
-		 *  but we could have some hole in high memory, and it will only
-		 *  check page_is_ram(pfn) && !page_is_reserved_early(pfn) to decide
-		 *  to use it as free.
-		 *  So memblock_x86_reserve_range here, hope we don't run out of that array
-		 */
-		memblock_x86_reserve_range(node_kva,
-					   node_kva + (((u64)size)<<PAGE_SHIFT),
-					   "KVA RAM");
-
-		node_remap_start_pfn[nid] = node_kva >> PAGE_SHIFT;
-	}
-	printk(KERN_INFO "Reserving total of %lx pages for numa KVA remap\n",
-			reserve_pages);
-	return reserve_pages;
+	/*
+	 * The acpi/srat node info can show hot-add memroy zones where
+	 * memory could be added but not currently present.
+	 */
+	printk(KERN_DEBUG "node %d pfn: [%lx - %lx]\n",
+	       nid, node_start_pfn[nid], node_end_pfn[nid]);
+	if (node_start_pfn[nid] > max_pfn)
+		return 0;
+	if (!node_end_pfn[nid])
+		return 0;
+	if (node_end_pfn[nid] > max_pfn)
+		node_end_pfn[nid] = max_pfn;
+
+	/* ensure the remap includes space for the pgdat. */
+	size = node_remap_size[nid];
+	size += ALIGN(sizeof(pg_data_t), PAGE_SIZE);
+
+	/* convert size to large (pmd size) pages, rounding up */
+	size = (size + LARGE_PAGE_BYTES - 1) / LARGE_PAGE_BYTES;
+	/* now the roundup is correct, convert to PAGE_SIZE pages */
+	size = size * PTRS_PER_PTE;
+
+	node_kva = memblock_find_in_range(node_start_pfn[nid] << PAGE_SHIFT,
+					  (u64)node_end_pfn[nid] << PAGE_SHIFT,
+					  (u64)size << PAGE_SHIFT,
+					  LARGE_PAGE_BYTES);
+	if (node_kva == MEMBLOCK_ERROR)
+		panic("Can not get kva ram\n");
+
+	node_remap_size[nid] = size;
+	node_remap_offset[nid] = offset;
+	printk(KERN_DEBUG "Reserving %ld pages of KVA for lmem_map of node %d at %llx\n",
+	       size, nid, node_kva >> PAGE_SHIFT);
+
+	/*
+	 *  prevent kva address below max_low_pfn want it on system
+	 *  with less memory later.
+	 *  layout will be: KVA address , KVA RAM
+	 *
+	 *  we are supposed to only record the one less then
+	 *  max_low_pfn but we could have some hole in high memory,
+	 *  and it will only check page_is_ram(pfn) &&
+	 *  !page_is_reserved_early(pfn) to decide to use it as free.
+	 *  So memblock_x86_reserve_range here, hope we don't run out
+	 *  of that array
+	 */
+	memblock_x86_reserve_range(node_kva,
+				   node_kva + ((u64)size << PAGE_SHIFT),
+				   "KVA RAM");
+
+	node_remap_start_pfn[nid] = node_kva >> PAGE_SHIFT;
+
+	return size;
 }
 
 static void init_remap_allocator(int nid)
@@ -346,6 +340,7 @@ static void init_remap_allocator(int nid)
 
 void __init initmem_init(void)
 {
+	unsigned long reserve_pages = 0;
 	int nid;
 
 	/*
@@ -359,7 +354,11 @@ void __init initmem_init(void)
 	get_memcfg_numa();
 	numa_init_array();
 
-	kva_pages = roundup(calculate_numa_remap_pages(), PTRS_PER_PTE);
+	for_each_online_node(nid)
+		reserve_pages += init_alloc_remap(nid, reserve_pages);
+	kva_pages = roundup(reserve_pages, PTRS_PER_PTE);
+	printk(KERN_INFO "Reserving total of %lx pages for numa KVA remap\n",
+			reserve_pages);
 
 	kva_start_pfn = memblock_find_in_range(min_low_pfn << PAGE_SHIFT,
 				max_low_pfn << PAGE_SHIFT,
