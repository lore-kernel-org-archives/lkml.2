Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab1DDWYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:24:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46324 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab1DDWYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:24:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Pne4zNkqLdXbXejkxB57OaOxs9REdNktSTV9PaYV3m+n0vdAT5C3mAWEL4yit4PH5y
         u4i/cUvY1tx8Sp8zOPCyZUjBEOncp/pUVwmZzEJRPj3iNqYIfzvuYY9ISKmrgPNWwwJm
         e0iZHYX1pIdN852AL66rLPV3iIzvqQnGtR1RU=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/14] x86-32, NUMA: Remove now useless node_remap_offset[]
Date: Tue,  5 Apr 2011 00:23:58 +0200
Message-Id: <1301955840-7246-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301955840-7246-1-git-send-email-tj@kernel.org>
References: <1301955840-7246-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With lowmem address reservation moved into init_alloc_remap(),
node_remap_offset[] is no longer useful.  Remove it and related offset
handling code.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/numa_32.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 0184a9f..960ea7b 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -187,7 +187,6 @@ static void __init allocate_pgdat(int nid)
 static unsigned long node_remap_start_pfn[MAX_NUMNODES];
 static void *node_remap_end_vaddr[MAX_NUMNODES];
 static void *node_remap_alloc_vaddr[MAX_NUMNODES];
-static unsigned long node_remap_offset[MAX_NUMNODES];
 
 void *alloc_remap(int nid, unsigned long size)
 {
@@ -239,7 +238,7 @@ void resume_map_numa_kva(pgd_t *pgd_base)
 }
 #endif
 
-static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
+static __init void init_alloc_remap(int nid)
 {
 	unsigned long size, pfn;
 	u64 node_pa, remap_pa;
@@ -252,9 +251,9 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 	printk(KERN_DEBUG "node %d pfn: [%lx - %lx]\n",
 	       nid, node_start_pfn[nid], node_end_pfn[nid]);
 	if (node_start_pfn[nid] > max_pfn)
-		return 0;
+		return;
 	if (!node_end_pfn[nid])
-		return 0;
+		return;
 	if (node_end_pfn[nid] > max_pfn)
 		node_end_pfn[nid] = max_pfn;
 
@@ -271,7 +270,7 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 	if (node_pa == MEMBLOCK_ERROR) {
 		pr_warning("remap_alloc: failed to allocate %lu bytes for node %d\n",
 			   size, nid);
-		return 0;
+		return;
 	}
 	memblock_x86_reserve_range(node_pa, node_pa + size, "KVA RAM");
 
@@ -282,7 +281,7 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 		pr_warning("remap_alloc: failed to allocate %lu bytes remap area for node %d\n",
 			   size, nid);
 		memblock_x86_free_range(node_pa, node_pa + size);
-		return 0;
+		return;
 	}
 	memblock_x86_reserve_range(remap_pa, remap_pa + size, "KVA PG");
 	remap_va = phys_to_virt(remap_pa);
@@ -296,7 +295,6 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 	/* initialize remap allocator parameters */
 	node_remap_start_pfn[nid] = node_pa >> PAGE_SHIFT;
 	node_remap_size[nid] = size >> PAGE_SHIFT;
-	node_remap_offset[nid] = offset;
 
 	node_remap_start_vaddr[nid] = remap_va;
 	node_remap_end_vaddr[nid] = remap_va + size;
@@ -304,13 +302,10 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 
 	printk(KERN_DEBUG "remap_alloc: node %d [%08llx-%08llx) -> [%p-%p)\n",
 	       nid, node_pa, node_pa + size, remap_va, remap_va + size);
-
-	return size >> PAGE_SHIFT;
 }
 
 void __init initmem_init(void)
 {
-	unsigned long reserve_pages = 0;
 	int nid;
 
 	/*
@@ -325,7 +320,7 @@ void __init initmem_init(void)
 	numa_init_array();
 
 	for_each_online_node(nid)
-		reserve_pages += init_alloc_remap(nid, reserve_pages);
+		init_alloc_remap(nid);
 
 #ifdef CONFIG_HIGHMEM
 	highstart_pfn = highend_pfn = max_pfn;
-- 
1.7.1

