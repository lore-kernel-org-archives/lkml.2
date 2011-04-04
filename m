Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab1DDWZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:25:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47295 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab1DDWYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=mh7rt8Mx4QKUpuO+aBItpao9pmpHUyw5L7S7LPcFg8++Pt1do/ECqDgsNc9GYJUiLy
         8J7TZX3RMN/p6HP3lc1EebFQncdW03Ixrzcche+f5ofzo9V+CrY0qjw589onJVNBYHmg
         2IA8HehTHHdfOUI96ddMUAAAF8JLxiQXH/YAs=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/14] x86-32, NUMA: Rename @node_kva to @node_pa in init_alloc_remap()
Date: Tue,  5 Apr 2011 00:23:51 +0200
Message-Id: <1301955840-7246-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301955840-7246-1-git-send-email-tj@kernel.org>
References: <1301955840-7246-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_alloc_remap() is about to do more and using _kva suffix for
physical address becomes confusing because the function will be
handling both physical and virtual addresses.  Rename @node_kva to
@node_pa.

This is trivial rename and doesn't cause any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/mm/numa_32.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 5039e9b..30933fe 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -267,7 +267,7 @@ void resume_map_numa_kva(pgd_t *pgd_base)
 static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 {
 	unsigned long size;
-	u64 node_kva;
+	u64 node_pa;
 
 	/*
 	 * The acpi/srat node info can show hot-add memroy zones where
@@ -291,17 +291,17 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 	/* now the roundup is correct, convert to PAGE_SIZE pages */
 	size = size * PTRS_PER_PTE;
 
-	node_kva = memblock_find_in_range(node_start_pfn[nid] << PAGE_SHIFT,
-					  (u64)node_end_pfn[nid] << PAGE_SHIFT,
-					  (u64)size << PAGE_SHIFT,
-					  LARGE_PAGE_BYTES);
-	if (node_kva == MEMBLOCK_ERROR)
+	node_pa = memblock_find_in_range(node_start_pfn[nid] << PAGE_SHIFT,
+					 (u64)node_end_pfn[nid] << PAGE_SHIFT,
+					 (u64)size << PAGE_SHIFT,
+					 LARGE_PAGE_BYTES);
+	if (node_pa == MEMBLOCK_ERROR)
 		panic("Can not get kva ram\n");
 
 	node_remap_size[nid] = size;
 	node_remap_offset[nid] = offset;
 	printk(KERN_DEBUG "Reserving %ld pages of KVA for lmem_map of node %d at %llx\n",
-	       size, nid, node_kva >> PAGE_SHIFT);
+	       size, nid, node_pa >> PAGE_SHIFT);
 
 	/*
 	 *  prevent kva address below max_low_pfn want it on system
@@ -315,11 +315,10 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 	 *  So memblock_x86_reserve_range here, hope we don't run out
 	 *  of that array
 	 */
-	memblock_x86_reserve_range(node_kva,
-				   node_kva + ((u64)size << PAGE_SHIFT),
+	memblock_x86_reserve_range(node_pa, node_pa + ((u64)size << PAGE_SHIFT),
 				   "KVA RAM");
 
-	node_remap_start_pfn[nid] = node_kva >> PAGE_SHIFT;
+	node_remap_start_pfn[nid] = node_pa >> PAGE_SHIFT;
 
 	return size;
 }
-- 
1.7.1

