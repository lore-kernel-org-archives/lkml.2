Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161046Ab2ERKVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:21:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42181 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762566Ab2ERKVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:21:45 -0400
Date: Fri, 18 May 2012 03:21:25 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-o0ih1vq2js8eswn0nmr6w49r@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        bharata.rao@gmail.com, aarcange@redhat.com, Lee.Schermerhorn@hp.com,
        danms@us.ibm.com, suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, suresh.b.siddha@intel.com, danms@us.ibm.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm/mpol: Re-implement check_*_range()
  using walk_page_range()
Git-Commit-ID: 8c41549ed1b3adefe17fa78a2cab81ed7060f0e5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:21:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c41549ed1b3adefe17fa78a2cab81ed7060f0e5
Gitweb:     http://git.kernel.org/tip/8c41549ed1b3adefe17fa78a2cab81ed7060f0e5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 30 Jan 2012 17:23:26 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 17 May 2012 14:06:12 +0200

mm/mpol: Re-implement check_*_range() using walk_page_range()

We have this very nice generic page-table walker, use it to save a few
lines and make it easier to later reuse various bits of this existing
machinery.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Fixes-by: Dan Smith <danms@us.ibm.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-o0ih1vq2js8eswn0nmr6w49r@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/mempolicy.c |  147 ++++++++++++++++++-------------------------------------
 1 files changed, 48 insertions(+), 99 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 1a51b7f..cdb3b9d 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -460,105 +460,45 @@ static const struct mempolicy_operations mpol_ops[MPOL_MAX] = {
 static void migrate_page_add(struct page *page, struct list_head *pagelist,
 				unsigned long flags);
 
-/* Scan through pages checking if pages follow certain conditions. */
-static int check_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long addr, unsigned long end,
-		const nodemask_t *nodes, unsigned long flags,
-		void *private)
-{
-	pte_t *orig_pte;
-	pte_t *pte;
-	spinlock_t *ptl;
-
-	orig_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	do {
-		struct page *page;
-		int nid;
-
-		if (!pte_present(*pte))
-			continue;
-		page = vm_normal_page(vma, addr, *pte);
-		if (!page)
-			continue;
-		/*
-		 * vm_normal_page() filters out zero pages, but there might
-		 * still be PageReserved pages to skip, perhaps in a VDSO.
-		 * And we cannot move PageKsm pages sensibly or safely yet.
-		 */
-		if (PageReserved(page) || PageKsm(page))
-			continue;
-		nid = page_to_nid(page);
-		if (node_isset(nid, *nodes) == !!(flags & MPOL_MF_INVERT))
-			continue;
-
-		if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
-			migrate_page_add(page, private, flags);
-		else
-			break;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
-	pte_unmap_unlock(orig_pte, ptl);
-	return addr != end;
-}
+struct mempol_walk_data {
+	struct vm_area_struct *vma;
+	const nodemask_t *nodes;
+	unsigned long flags;
+	void *private;
+};
 
-static inline int check_pmd_range(struct vm_area_struct *vma, pud_t *pud,
-		unsigned long addr, unsigned long end,
-		const nodemask_t *nodes, unsigned long flags,
-		void *private)
+static int check_pte_entry(pte_t *pte, unsigned long addr,
+			   unsigned long end, struct mm_walk *walk)
 {
-	pmd_t *pmd;
-	unsigned long next;
+	struct mempol_walk_data *data = walk->private;
+	struct page *page;
+	int nid;
 
-	pmd = pmd_offset(pud, addr);
-	do {
-		next = pmd_addr_end(addr, end);
-		split_huge_page_pmd(vma->vm_mm, pmd);
-		if (pmd_none_or_trans_huge_or_clear_bad(pmd))
-			continue;
-		if (check_pte_range(vma, pmd, addr, next, nodes,
-				    flags, private))
-			return -EIO;
-	} while (pmd++, addr = next, addr != end);
-	return 0;
-}
+	if (!pte_present(*pte))
+		return 0;
 
-static inline int check_pud_range(struct vm_area_struct *vma, pgd_t *pgd,
-		unsigned long addr, unsigned long end,
-		const nodemask_t *nodes, unsigned long flags,
-		void *private)
-{
-	pud_t *pud;
-	unsigned long next;
+	page = vm_normal_page(data->vma, addr, *pte);
+	if (!page)
+		return 0;
 
-	pud = pud_offset(pgd, addr);
-	do {
-		next = pud_addr_end(addr, end);
-		if (pud_none_or_clear_bad(pud))
-			continue;
-		if (check_pmd_range(vma, pud, addr, next, nodes,
-				    flags, private))
-			return -EIO;
-	} while (pud++, addr = next, addr != end);
-	return 0;
-}
+	/*
+	 * vm_normal_page() filters out zero pages, but there might
+	 * still be PageReserved pages to skip, perhaps in a VDSO.
+	 * And we cannot move PageKsm pages sensibly or safely yet.
+	 */
+	if (PageReserved(page) || PageKsm(page))
+		return 0;
 
-static inline int check_pgd_range(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long end,
-		const nodemask_t *nodes, unsigned long flags,
-		void *private)
-{
-	pgd_t *pgd;
-	unsigned long next;
+	nid = page_to_nid(page);
+	if (node_isset(nid, *data->nodes) == !!(data->flags & MPOL_MF_INVERT))
+		return 0;
 
-	pgd = pgd_offset(vma->vm_mm, addr);
-	do {
-		next = pgd_addr_end(addr, end);
-		if (pgd_none_or_clear_bad(pgd))
-			continue;
-		if (check_pud_range(vma, pgd, addr, next, nodes,
-				    flags, private))
-			return -EIO;
-	} while (pgd++, addr = next, addr != end);
-	return 0;
+	if (data->flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
+		migrate_page_add(page, data->private, data->flags);
+		return 0;
+	}
+
+	return -EIO;
 }
 
 /*
@@ -570,9 +510,18 @@ static struct vm_area_struct *
 check_range(struct mm_struct *mm, unsigned long start, unsigned long end,
 		const nodemask_t *nodes, unsigned long flags, void *private)
 {
-	int err;
 	struct vm_area_struct *first, *vma, *prev;
-
+	struct mempol_walk_data data = {
+		.nodes = nodes,
+		.flags = flags,
+		.private = private,
+	};
+	struct mm_walk walk = {
+		.pte_entry = check_pte_entry,
+		.mm = mm,
+		.private = &data,
+	};
+	int err;
 
 	first = find_vma(mm, start);
 	if (!first)
@@ -595,8 +544,8 @@ check_range(struct mm_struct *mm, unsigned long start, unsigned long end,
 				endvma = end;
 			if (vma->vm_start > start)
 				start = vma->vm_start;
-			err = check_pgd_range(vma, start, endvma, nodes,
-						flags, private);
+			data.vma = vma;
+			err = walk_page_range(start, endvma, &walk);
 			if (err) {
 				first = ERR_PTR(err);
 				break;
