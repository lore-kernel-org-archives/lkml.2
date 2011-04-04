Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab1DDWYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:24:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46324 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab1DDWYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:24:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=OSUd5IrmdiUB2fwtfqOQsrZleXZoyPtVEUsVcrPeSsjo582ebnePTiDZqSKarTPDlD
         vTZzg3vrRN8MSSSQjMSBefoP7GmYvlpIV7Ohhr3XvbLhvGnGzh+S4pyMru5tjIEqyOme
         KUJ9ZWT9K2ByuGElPgK7Xj6s6eChhsqm/dAMk=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/14] x86-32, NUMA: Make @size in init_aloc_remap() represent bytes
Date: Tue,  5 Apr 2011 00:23:52 +0200
Message-Id: <1301955840-7246-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301955840-7246-1-git-send-email-tj@kernel.org>
References: <1301955840-7246-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@size variable in init_alloc_remap() is confusing in that it starts as
number of bytes as its name implies and then becomes number of pages.
Make it consistently represent bytes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/numa_32.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 30933fe..99310d2 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -286,22 +286,19 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 	size = node_remap_size[nid];
 	size += ALIGN(sizeof(pg_data_t), PAGE_SIZE);
 
-	/* convert size to large (pmd size) pages, rounding up */
-	size = (size + LARGE_PAGE_BYTES - 1) / LARGE_PAGE_BYTES;
-	/* now the roundup is correct, convert to PAGE_SIZE pages */
-	size = size * PTRS_PER_PTE;
+	/* align to large page */
+	size = ALIGN(size, LARGE_PAGE_BYTES);
 
 	node_pa = memblock_find_in_range(node_start_pfn[nid] << PAGE_SHIFT,
 					 (u64)node_end_pfn[nid] << PAGE_SHIFT,
-					 (u64)size << PAGE_SHIFT,
-					 LARGE_PAGE_BYTES);
+					 size, LARGE_PAGE_BYTES);
 	if (node_pa == MEMBLOCK_ERROR)
 		panic("Can not get kva ram\n");
 
-	node_remap_size[nid] = size;
+	node_remap_size[nid] = size >> PAGE_SHIFT;
 	node_remap_offset[nid] = offset;
 	printk(KERN_DEBUG "Reserving %ld pages of KVA for lmem_map of node %d at %llx\n",
-	       size, nid, node_pa >> PAGE_SHIFT);
+	       size >> PAGE_SHIFT, nid, node_pa >> PAGE_SHIFT);
 
 	/*
 	 *  prevent kva address below max_low_pfn want it on system
@@ -315,12 +312,11 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 	 *  So memblock_x86_reserve_range here, hope we don't run out
 	 *  of that array
 	 */
-	memblock_x86_reserve_range(node_pa, node_pa + ((u64)size << PAGE_SHIFT),
-				   "KVA RAM");
+	memblock_x86_reserve_range(node_pa, node_pa + size, "KVA RAM");
 
 	node_remap_start_pfn[nid] = node_pa >> PAGE_SHIFT;
 
-	return size;
+	return size >> PAGE_SHIFT;
 }
 
 static void init_remap_allocator(int nid)
-- 
1.7.1

