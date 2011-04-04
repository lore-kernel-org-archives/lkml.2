Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab1DDWZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:25:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47295 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab1DDWYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:24:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=k8qhqz+KAaPiauUHGsdg7tviK7CGjDgLv20M2oMCNSccfoHw/hTPpxrvIkZR6ubHvt
         8SWH9PVC0iAWTPx6DmtrA5pPpZCatjpyXXu+UpAavHn5nel+6NKqF+jBMbPVXx+GBSlT
         fEoua45OhuwyjJr7Q+pnNgdmY4IWwVx2mIkcA=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/14] x86-32, NUMA: Remove redundant node_remap_size[]
Date: Tue,  5 Apr 2011 00:23:59 +0200
Message-Id: <1301955840-7246-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301955840-7246-1-git-send-email-tj@kernel.org>
References: <1301955840-7246-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remap area size can be determined from node_remap_start_vaddr[] and
node_remap_end_vaddr[] making node_remap_size[] redundant.  Remove it.

While at it, make resume_map_numa_kva() use @nr_pages for number of
pages instead of @size.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/numa_32.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 960ea7b..f325e6f 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -104,7 +104,6 @@ extern unsigned long highend_pfn, highstart_pfn;
 
 #define LARGE_PAGE_BYTES (PTRS_PER_PTE * PAGE_SIZE)
 
-static unsigned long node_remap_size[MAX_NUMNODES];
 static void *node_remap_start_vaddr[MAX_NUMNODES];
 void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
 
@@ -214,15 +213,16 @@ void resume_map_numa_kva(pgd_t *pgd_base)
 	int node;
 
 	for_each_online_node(node) {
-		unsigned long start_va, start_pfn, size, pfn;
+		unsigned long start_va, start_pfn, nr_pages, pfn;
 
 		start_va = (unsigned long)node_remap_start_vaddr[node];
 		start_pfn = node_remap_start_pfn[node];
-		size = node_remap_size[node];
+		nr_pages = (node_remap_end_vaddr[node] -
+			    node_remap_start_vaddr[node]) >> PAGE_SHIFT;
 
 		printk(KERN_DEBUG "%s: node %d\n", __func__, node);
 
-		for (pfn = 0; pfn < size; pfn += PTRS_PER_PTE) {
+		for (pfn = 0; pfn < nr_pages; pfn += PTRS_PER_PTE) {
 			unsigned long vaddr = start_va + (pfn << PAGE_SHIFT);
 			pgd_t *pgd = pgd_base + pgd_index(vaddr);
 			pud_t *pud = pud_offset(pgd, vaddr);
@@ -294,8 +294,6 @@ static __init void init_alloc_remap(int nid)
 
 	/* initialize remap allocator parameters */
 	node_remap_start_pfn[nid] = node_pa >> PAGE_SHIFT;
-	node_remap_size[nid] = size >> PAGE_SHIFT;
-
 	node_remap_start_vaddr[nid] = remap_va;
 	node_remap_end_vaddr[nid] = remap_va + size;
 	node_remap_alloc_vaddr[nid] = remap_va;
-- 
1.7.1

