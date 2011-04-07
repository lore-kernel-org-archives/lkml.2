Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab1DGCJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:09:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:51056 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756997Ab1DGCJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:09:00 -0400
Date: Thu, 7 Apr 2011 02:08:50 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
In-Reply-To: <1301955840-7246-14-git-send-email-tj@kernel.org>
References: <1301955840-7246-14-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86-32, numa: Remove redundant node_remap_size[]
Message-ID: <tip-198bd06bbfde2984027e91f64c55eb19a7034a27@git.kernel.org>
Git-Commit-ID: 198bd06bbfde2984027e91f64c55eb19a7034a27
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Apr 2011 02:08:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  198bd06bbfde2984027e91f64c55eb19a7034a27
Gitweb:     http://git.kernel.org/tip/198bd06bbfde2984027e91f64c55eb19a7034a27
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 5 Apr 2011 00:23:59 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Apr 2011 17:57:50 -0700

x86-32, numa: Remove redundant node_remap_size[]

Remap area size can be determined from node_remap_start_vaddr[] and
node_remap_end_vaddr[] making node_remap_size[] redundant.  Remove it.

While at it, make resume_map_numa_kva() use @nr_pages for number of
pages instead of @size.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1301955840-7246-14-git-send-email-tj@kernel.org
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
