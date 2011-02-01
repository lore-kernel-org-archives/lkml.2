Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab1BAAeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 19:34:13 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50223 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab1BAAeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 19:34:04 -0500
Subject: [RFC][PATCH 3/6] break out smaps_pte_entry() from smaps_pte_range()
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 31 Jan 2011 16:34:01 -0800
References: <20110201003357.D6F0BE0D@kernel>
In-Reply-To: <20110201003357.D6F0BE0D@kernel>
Message-Id: <20110201003401.95CFBFA6@kernel>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We will use smaps_pte_entry() in a moment to handle both small
and transparent large pages.  But, we must break it out of
smaps_pte_range() first.


---

 linux-2.6.git-dave/fs/proc/task_mmu.c |   85 ++++++++++++++++++----------------
 1 file changed, 46 insertions(+), 39 deletions(-)

diff -puN fs/proc/task_mmu.c~break-out-smaps_pte_entry fs/proc/task_mmu.c
--- linux-2.6.git/fs/proc/task_mmu.c~break-out-smaps_pte_entry	2011-01-27 11:03:06.761548697 -0800
+++ linux-2.6.git-dave/fs/proc/task_mmu.c	2011-01-27 11:03:06.773548685 -0800
@@ -333,56 +333,63 @@ struct mem_size_stats {
 	u64 pss;
 };
 
-static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
-			   struct mm_walk *walk)
+
+static void smaps_pte_entry(pte_t ptent, unsigned long addr,
+		struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = mss->vma;
-	pte_t *pte, ptent;
-	spinlock_t *ptl;
 	struct page *page;
 	int mapcount;
 
-	split_huge_page_pmd(walk->mm, pmd);
-
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	for (; addr != end; pte++, addr += PAGE_SIZE) {
-		ptent = *pte;
+	if (is_swap_pte(ptent)) {
+		mss->swap += PAGE_SIZE;
+		return;
+	}
 
-		if (is_swap_pte(ptent)) {
-			mss->swap += PAGE_SIZE;
-			continue;
-		}
+	if (!pte_present(ptent))
+		return;
 
-		if (!pte_present(ptent))
-			continue;
+	page = vm_normal_page(vma, addr, ptent);
+	if (!page)
+		return;
+
+	if (PageAnon(page))
+		mss->anonymous += PAGE_SIZE;
+
+	mss->resident += PAGE_SIZE;
+	/* Accumulate the size in pages that have been accessed. */
+	if (pte_young(ptent) || PageReferenced(page))
+		mss->referenced += PAGE_SIZE;
+	mapcount = page_mapcount(page);
+	if (mapcount >= 2) {
+		if (pte_dirty(ptent) || PageDirty(page))
+			mss->shared_dirty += PAGE_SIZE;
+		else
+			mss->shared_clean += PAGE_SIZE;
+		mss->pss += (PAGE_SIZE << PSS_SHIFT) / mapcount;
+	} else {
+		if (pte_dirty(ptent) || PageDirty(page))
+			mss->private_dirty += PAGE_SIZE;
+		else
+			mss->private_clean += PAGE_SIZE;
+		mss->pss += (PAGE_SIZE << PSS_SHIFT);
+	}
+}
 
-		page = vm_normal_page(vma, addr, ptent);
-		if (!page)
-			continue;
+static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+			   struct mm_walk *walk)
+{
+	struct mem_size_stats *mss = walk->private;
+	struct vm_area_struct *vma = mss->vma;
+	pte_t *pte;
+	spinlock_t *ptl;
 
-		if (PageAnon(page))
-			mss->anonymous += PAGE_SIZE;
+	split_huge_page_pmd(walk->mm, pmd);
 
-		mss->resident += PAGE_SIZE;
-		/* Accumulate the size in pages that have been accessed. */
-		if (pte_young(ptent) || PageReferenced(page))
-			mss->referenced += PAGE_SIZE;
-		mapcount = page_mapcount(page);
-		if (mapcount >= 2) {
-			if (pte_dirty(ptent) || PageDirty(page))
-				mss->shared_dirty += PAGE_SIZE;
-			else
-				mss->shared_clean += PAGE_SIZE;
-			mss->pss += (PAGE_SIZE << PSS_SHIFT) / mapcount;
-		} else {
-			if (pte_dirty(ptent) || PageDirty(page))
-				mss->private_dirty += PAGE_SIZE;
-			else
-				mss->private_clean += PAGE_SIZE;
-			mss->pss += (PAGE_SIZE << PSS_SHIFT);
-		}
-	}
+	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	for (; addr != end; pte++, addr += PAGE_SIZE)
+		smaps_pte_entry(*pte, addr, walk);
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
 	return 0;
diff -puN mm/huge_memory.c~break-out-smaps_pte_entry mm/huge_memory.c
_
