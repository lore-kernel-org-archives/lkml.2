Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab1DGCFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:05:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:50850 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756453Ab1DGCE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:04:59 -0400
Date: Thu, 7 Apr 2011 02:04:48 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
In-Reply-To: <1301955840-7246-4-git-send-email-tj@kernel.org>
References: <1301955840-7246-4-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86-32, numa: Remove redundant top-down alloc code from remap initialization
Message-ID: <tip-5b8443b25c0f323ec190d094e4b441957b02664e@git.kernel.org>
Git-Commit-ID: 5b8443b25c0f323ec190d094e4b441957b02664e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Apr 2011 02:04:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5b8443b25c0f323ec190d094e4b441957b02664e
Gitweb:     http://git.kernel.org/tip/5b8443b25c0f323ec190d094e4b441957b02664e
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 5 Apr 2011 00:23:49 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Apr 2011 17:56:57 -0700

x86-32, numa: Remove redundant top-down alloc code from remap initialization

memblock_find_in_range() now does top-down allocation by default, so
there's no reason for its callers to explicitly implement it by
gradually lowering the start address.

Remove redundant top-down allocation logic from init_meminit() and
calculate_numa_remap_pages().

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1301955840-7246-4-git-send-email-tj@kernel.org
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/numa_32.c |   43 ++++++++++++++-----------------------------
 1 files changed, 14 insertions(+), 29 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 50e8250..60701a5 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -270,8 +270,7 @@ static __init unsigned long calculate_numa_remap_pages(void)
 	unsigned long size, reserve_pages = 0;
 
 	for_each_online_node(nid) {
-		u64 node_kva_target;
-		u64 node_kva_final;
+		u64 node_kva;
 
 		/*
 		 * The acpi/srat node info can show hot-add memroy zones
@@ -295,19 +294,11 @@ static __init unsigned long calculate_numa_remap_pages(void)
 		/* now the roundup is correct, convert to PAGE_SIZE pages */
 		size = size * PTRS_PER_PTE;
 
-		node_kva_target = round_down(node_end_pfn[nid] - size,
-						 PTRS_PER_PTE);
-		node_kva_target <<= PAGE_SHIFT;
-		do {
-			node_kva_final = memblock_find_in_range(node_kva_target,
+		node_kva = memblock_find_in_range(node_start_pfn[nid] << PAGE_SHIFT,
 					((u64)node_end_pfn[nid])<<PAGE_SHIFT,
-						((u64)size)<<PAGE_SHIFT,
-						LARGE_PAGE_BYTES);
-			node_kva_target -= LARGE_PAGE_BYTES;
-		} while (node_kva_final == MEMBLOCK_ERROR &&
-			 (node_kva_target>>PAGE_SHIFT) > (node_start_pfn[nid]));
-
-		if (node_kva_final == MEMBLOCK_ERROR)
+					((u64)size)<<PAGE_SHIFT,
+					LARGE_PAGE_BYTES);
+		if (node_kva == MEMBLOCK_ERROR)
 			panic("Can not get kva ram\n");
 
 		node_remap_size[nid] = size;
@@ -315,7 +306,7 @@ static __init unsigned long calculate_numa_remap_pages(void)
 		reserve_pages += size;
 		printk(KERN_DEBUG "Reserving %ld pages of KVA for lmem_map of"
 				  " node %d at %llx\n",
-				size, nid, node_kva_final>>PAGE_SHIFT);
+				size, nid, node_kva >> PAGE_SHIFT);
 
 		/*
 		 *  prevent kva address below max_low_pfn want it on system
@@ -328,11 +319,11 @@ static __init unsigned long calculate_numa_remap_pages(void)
 		 *  to use it as free.
 		 *  So memblock_x86_reserve_range here, hope we don't run out of that array
 		 */
-		memblock_x86_reserve_range(node_kva_final,
-			      node_kva_final+(((u64)size)<<PAGE_SHIFT),
-			      "KVA RAM");
+		memblock_x86_reserve_range(node_kva,
+					   node_kva + (((u64)size)<<PAGE_SHIFT),
+					   "KVA RAM");
 
-		node_remap_start_pfn[nid] = node_kva_final>>PAGE_SHIFT;
+		node_remap_start_pfn[nid] = node_kva >> PAGE_SHIFT;
 	}
 	printk(KERN_INFO "Reserving total of %lx pages for numa KVA remap\n",
 			reserve_pages);
@@ -356,7 +347,6 @@ static void init_remap_allocator(int nid)
 void __init initmem_init(void)
 {
 	int nid;
-	long kva_target_pfn;
 
 	/*
 	 * When mapping a NUMA machine we allocate the node_mem_map arrays
@@ -371,15 +361,10 @@ void __init initmem_init(void)
 
 	kva_pages = roundup(calculate_numa_remap_pages(), PTRS_PER_PTE);
 
-	kva_target_pfn = round_down(max_low_pfn - kva_pages, PTRS_PER_PTE);
-	do {
-		kva_start_pfn = memblock_find_in_range(kva_target_pfn<<PAGE_SHIFT,
-					max_low_pfn<<PAGE_SHIFT,
-					kva_pages<<PAGE_SHIFT,
-					PTRS_PER_PTE<<PAGE_SHIFT) >> PAGE_SHIFT;
-		kva_target_pfn -= PTRS_PER_PTE;
-	} while (kva_start_pfn == MEMBLOCK_ERROR && kva_target_pfn > min_low_pfn);
-
+	kva_start_pfn = memblock_find_in_range(min_low_pfn << PAGE_SHIFT,
+				max_low_pfn << PAGE_SHIFT,
+				kva_pages << PAGE_SHIFT,
+				PTRS_PER_PTE << PAGE_SHIFT) >> PAGE_SHIFT;
 	if (kva_start_pfn == MEMBLOCK_ERROR)
 		panic("Can not get kva space\n");
 
