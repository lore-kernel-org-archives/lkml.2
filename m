Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab1DGCHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:07:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:50994 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234Ab1DGCHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:07:47 -0400
Date: Thu, 7 Apr 2011 02:07:41 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
In-Reply-To: <1301955840-7246-11-git-send-email-tj@kernel.org>
References: <1301955840-7246-11-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86-32, numa: Move remapping for remap allocator into init_alloc_remap()
Message-ID: <tip-2a286344f06d6341740b284494379373e87648f7@git.kernel.org>
Git-Commit-ID: 2a286344f06d6341740b284494379373e87648f7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Apr 2011 02:07:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a286344f06d6341740b284494379373e87648f7
Gitweb:     http://git.kernel.org/tip/2a286344f06d6341740b284494379373e87648f7
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 5 Apr 2011 00:23:56 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Apr 2011 17:57:33 -0700

x86-32, numa: Move remapping for remap allocator into init_alloc_remap()

There's no reason to perform the actual remapping separately.
Collapse remap_numa_kva() into init_alloc_remap() and, while at it,
make it less verbose.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1301955840-7246-11-git-send-email-tj@kernel.org
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/numa_32.c |   29 +++++++----------------------
 1 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 12bb34c..53ec13a 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -205,26 +205,6 @@ void *alloc_remap(int nid, unsigned long size)
 	return allocation;
 }
 
-static void __init remap_numa_kva(void)
-{
-	void *vaddr;
-	unsigned long pfn;
-	int node;
-
-	for_each_online_node(node) {
-		printk(KERN_DEBUG "remap_numa_kva: node %d\n", node);
-		for (pfn=0; pfn < node_remap_size[node]; pfn += PTRS_PER_PTE) {
-			vaddr = node_remap_start_vaddr[node]+(pfn<<PAGE_SHIFT);
-			printk(KERN_DEBUG "remap_numa_kva: %08lx to pfn %08lx\n",
-				(unsigned long)vaddr,
-				node_remap_start_pfn[node] + pfn);
-			set_pmd_pfn((ulong) vaddr, 
-				node_remap_start_pfn[node] + pfn, 
-				PAGE_KERNEL_LARGE);
-		}
-	}
-}
-
 #ifdef CONFIG_HIBERNATION
 /**
  * resume_map_numa_kva - add KVA mapping to the temporary page tables created
@@ -262,7 +242,7 @@ void resume_map_numa_kva(pgd_t *pgd_base)
 
 static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 {
-	unsigned long size;
+	unsigned long size, pfn;
 	u64 node_pa, remap_pa;
 	void *remap_va;
 
@@ -308,6 +288,12 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 	memblock_x86_reserve_range(remap_pa, remap_pa + size, "KVA PG");
 	remap_va = phys_to_virt(remap_pa);
 
+	/* perform actual remap */
+	for (pfn = 0; pfn < size >> PAGE_SHIFT; pfn += PTRS_PER_PTE)
+		set_pmd_pfn((unsigned long)remap_va + (pfn << PAGE_SHIFT),
+			    (node_pa >> PAGE_SHIFT) + pfn,
+			    PAGE_KERNEL_LARGE);
+
 	/* initialize remap allocator parameters */
 	node_remap_start_pfn[nid] = node_pa >> PAGE_SHIFT;
 	node_remap_size[nid] = size >> PAGE_SHIFT;
@@ -363,7 +349,6 @@ void __init initmem_init(void)
 			(ulong) pfn_to_kaddr(max_low_pfn));
 	for_each_online_node(nid)
 		allocate_pgdat(nid);
-	remap_numa_kva();
 
 	printk(KERN_DEBUG "High memory starts at vaddr %08lx\n",
 			(ulong) pfn_to_kaddr(highstart_pfn));
