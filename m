Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1DDW0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:26:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46324 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab1DDWYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:24:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=MCWD3wilGfV6Q2VjgxUTfr10J6rBxMSfanfQcWokfJzeQZZpCUKU0d6HatK5ch8zuo
         Yym4bR9pL9qIS+25LP3ofYqCq0qfTTE5cErd5FvoBAbKVMqegE26BVN7xN35W46ZLgs7
         wpyEDl8iMnSZY0DaHpVfeSB0VSlgUpHyLRcp4=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/14] x86-32, NUMA: Reorganize calculate_numa_remap_page()
Date: Tue,  5 Apr 2011 00:23:50 +0200
Message-Id: <1301955840-7246-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301955840-7246-1-git-send-email-tj@kernel.org>
References: <1301955840-7246-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
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
-- 
1.7.1

