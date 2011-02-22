Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab1BVBxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 20:53:44 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38552 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab1BVBxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 20:53:43 -0500
Subject: [PATCH 1/5] pagewalk: only split huge pages when necessary
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, akpm@osdl.org,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 21 Feb 2011 17:53:39 -0800
References: <20110222015338.309727CA@kernel>
In-Reply-To: <20110222015338.309727CA@kernel>
Message-Id: <20110222015339.0C9A2212@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v2 - rework if() block, and remove  now redundant split_huge_page()

Right now, if a mm_walk has either ->pte_entry or ->pmd_entry
set, it will unconditionally split any transparent huge pages
it runs in to.  In practice, that means that anyone doing a

	cat /proc/$pid/smaps

will unconditionally break down every huge page in the process
and depend on khugepaged to re-collapse it later.  This is
fairly suboptimal.

This patch changes that behavior.  It teaches each ->pmd_entry
handler (there are five) that they must break down the THPs
themselves.  Also, the _generic_ code will never break down
a THP unless a ->pte_entry handler is actually set.

This means that the ->pmd_entry handlers can now choose to
deal with THPs without breaking them down.

Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/proc/task_mmu.c |    6 ++++++
 linux-2.6.git-dave/include/linux/mm.h |    3 +++
 linux-2.6.git-dave/mm/memcontrol.c    |    5 +++--
 linux-2.6.git-dave/mm/pagewalk.c      |   24 ++++++++++++++++++++----
 4 files changed, 32 insertions(+), 6 deletions(-)

diff -puN fs/proc/task_mmu.c~pagewalk-dont-always-split-thp fs/proc/task_mmu.c
--- linux-2.6.git/fs/proc/task_mmu.c~pagewalk-dont-always-split-thp	2011-02-14 09:59:42.438543522 -0800
+++ linux-2.6.git-dave/fs/proc/task_mmu.c	2011-02-14 09:59:42.458544115 -0800
@@ -343,6 +343,8 @@ static int smaps_pte_range(pmd_t *pmd, u
 	struct page *page;
 	int mapcount;
 
+	split_huge_page_pmd(walk->mm, pmd);
+
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		ptent = *pte;
@@ -467,6 +469,8 @@ static int clear_refs_pte_range(pmd_t *p
 	spinlock_t *ptl;
 	struct page *page;
 
+	split_huge_page_pmd(walk->mm, pmd);
+
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		ptent = *pte;
@@ -623,6 +627,8 @@ static int pagemap_pte_range(pmd_t *pmd,
 	pte_t *pte;
 	int err = 0;
 
+	split_huge_page_pmd(walk->mm, pmd);
+
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
 	for (; addr != end; addr += PAGE_SIZE) {
diff -puN include/linux/mm.h~pagewalk-dont-always-split-thp include/linux/mm.h
--- linux-2.6.git/include/linux/mm.h~pagewalk-dont-always-split-thp	2011-02-14 09:59:42.442543640 -0800
+++ linux-2.6.git-dave/include/linux/mm.h	2011-02-14 09:59:42.458544115 -0800
@@ -899,6 +899,9 @@ unsigned long unmap_vmas(struct mmu_gath
  * @pgd_entry: if set, called for each non-empty PGD (top-level) entry
  * @pud_entry: if set, called for each non-empty PUD (2nd-level) entry
  * @pmd_entry: if set, called for each non-empty PMD (3rd-level) entry
+ * 	       this handler is required to be able to handle
+ * 	       pmd_trans_huge() pmds.  They may simply choose to
+ * 	       split_huge_page() instead of handling it explicitly.
  * @pte_entry: if set, called for each non-empty PTE (4th-level) entry
  * @pte_hole: if set, called for each hole at all levels
  * @hugetlb_entry: if set, called for each hugetlb entry
diff -puN mm/memcontrol.c~pagewalk-dont-always-split-thp mm/memcontrol.c
--- linux-2.6.git/mm/memcontrol.c~pagewalk-dont-always-split-thp	2011-02-14 09:59:42.446543758 -0800
+++ linux-2.6.git-dave/mm/memcontrol.c	2011-02-14 09:59:42.462544233 -0800
@@ -4737,7 +4737,8 @@ static int mem_cgroup_count_precharge_pt
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	VM_BUG_ON(pmd_trans_huge(*pmd));
+	split_huge_page_pmd(walk->mm, pmd);
+
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE)
 		if (is_target_pte_for_mc(vma, addr, *pte, NULL))
@@ -4899,8 +4900,8 @@ static int mem_cgroup_move_charge_pte_ra
 	pte_t *pte;
 	spinlock_t *ptl;
 
+	split_huge_page_pmd(walk->mm, pmd);
 retry:
-	VM_BUG_ON(pmd_trans_huge(*pmd));
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; addr += PAGE_SIZE) {
 		pte_t ptent = *(pte++);
diff -puN mm/pagewalk.c~pagewalk-dont-always-split-thp mm/pagewalk.c
--- linux-2.6.git/mm/pagewalk.c~pagewalk-dont-always-split-thp	2011-02-14 09:59:42.450543877 -0800
+++ linux-2.6.git-dave/mm/pagewalk.c	2011-02-14 09:59:42.466544351 -0800
@@ -33,19 +33,35 @@ static int walk_pmd_range(pud_t *pud, un
 
 	pmd = pmd_offset(pud, addr);
 	do {
+	again:
 		next = pmd_addr_end(addr, end);
-		split_huge_page_pmd(walk->mm, pmd);
-		if (pmd_none_or_clear_bad(pmd)) {
+		if (pmd_none(*pmd)) {
 			if (walk->pte_hole)
 				err = walk->pte_hole(addr, next, walk);
 			if (err)
 				break;
 			continue;
 		}
+		/*
+		 * This implies that each ->pmd_entry() handler
+		 * needs to know about pmd_trans_huge() pmds
+		 */
 		if (walk->pmd_entry)
 			err = walk->pmd_entry(pmd, addr, next, walk);
-		if (!err && walk->pte_entry)
-			err = walk_pte_range(pmd, addr, next, walk);
+		if (err)
+			break;
+
+		/*
+		 * Check this here so we only break down trans_huge
+		 * pages when we _need_ to
+		 */
+		if (!walk->pte_entry)
+			continue;
+
+		split_huge_page_pmd(walk->mm, pmd);
+		if (pmd_none_or_clear_bad(pmd))
+			goto again;
+		err = walk_pte_range(pmd, addr, next, walk);
 		if (err)
 			break;
 	} while (pmd++, addr = next, addr != end);
_
