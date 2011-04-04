Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab1DDWY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:24:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46324 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab1DDWYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:24:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=DJoBWJ7kwZUHyE7gFcf6lMFZrqEmmVcdDE7BaAMqURQf/Ak1FwRxGNBeGfy9AIszG2
         oPN6oJ5V/xJ/+NO6Mqf2dDmQdTnLXj/qjis+GVFxLQ7uB3CtwDbyeIbaRgakkOmUi7YX
         OxF+LEkuc4vyebKtReFNSZH6voITGefsLlgzs=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/14] x86-32, NUMA: Move remapping for remap allocator into init_alloc_remap()
Date: Tue,  5 Apr 2011 00:23:56 +0200
Message-Id: <1301955840-7246-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301955840-7246-1-git-send-email-tj@kernel.org>
References: <1301955840-7246-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason to perform the actual remapping separately.
Collapse remap_numa_kva() into init_alloc_remap() and, while at it,
make it less verbose.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
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
-- 
1.7.1

