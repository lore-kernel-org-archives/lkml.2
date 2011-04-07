Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab1DGCIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:08:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:51045 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757025Ab1DGCIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:08:40 -0400
Date: Thu, 7 Apr 2011 02:08:28 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
In-Reply-To: <1301955840-7246-13-git-send-email-tj@kernel.org>
References: <1301955840-7246-13-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86-32, numa: Remove now useless node_remap_offset[]
Message-ID: <tip-1d85b61baf0334dd6bb88261bec42b808204d694@git.kernel.org>
Git-Commit-ID: 1d85b61baf0334dd6bb88261bec42b808204d694
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Apr 2011 02:08:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d85b61baf0334dd6bb88261bec42b808204d694
Gitweb:     http://git.kernel.org/tip/1d85b61baf0334dd6bb88261bec42b808204d694
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 5 Apr 2011 00:23:58 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Apr 2011 17:57:44 -0700

x86-32, numa: Remove now useless node_remap_offset[]

With lowmem address reservation moved into init_alloc_remap(),
node_remap_offset[] is no longer useful.  Remove it and related offset
handling code.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1301955840-7246-13-git-send-email-tj@kernel.org
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
