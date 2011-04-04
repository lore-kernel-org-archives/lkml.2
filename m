Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab1DDW00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:26:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47295 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab1DDWYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:24:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=I4/JA+N3NEYSgzDPBzxgDwhJXydZ3WJe2AJMaDJFtJDDG4hdZxLj/xf27n1yqICy5j
         o2ouPVh4DtowjH2vBrfdHOGvWNgFM5Qbcet0KJ6Elz0QFVSdkKulm6+u4h6yX7D4DATN
         zBAxI38RYwd7/ndFeKzEFXUViMFn7FHPFzuog=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/14] x86-32, NUMA: Remove redundant top-down alloc code from remap initialization
Date: Tue,  5 Apr 2011 00:23:49 +0200
Message-Id: <1301955840-7246-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301955840-7246-1-git-send-email-tj@kernel.org>
References: <1301955840-7246-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblock_find_in_range() now does top-down allocation by default, so
there's no reason for its callers to explicitly implement it by
gradually lowering the start address.

Remove redundant top-down allocation logic from init_meminit() and
calculate_numa_remap_pages().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
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
 
-- 
1.7.1

