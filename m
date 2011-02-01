Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab1BAAeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 19:34:09 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39971 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497Ab1BAAeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 19:34:05 -0500
Subject: [RFC][PATCH 4/6] pass pte size argument in to smaps_pte_entry()
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 31 Jan 2011 16:34:02 -0800
References: <20110201003357.D6F0BE0D@kernel>
In-Reply-To: <20110201003357.D6F0BE0D@kernel>
Message-Id: <20110201003402.5FFC58F0@kernel>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds an argument to the new smaps_pte_entry()
function to let it account in things other than PAGE_SIZE
units.  I changed all of the PAGE_SIZE sites, even though
not all of them can be reached for transparent huge pages,
just so this will continue to work without changes as THPs
are improved.


---

 linux-2.6.git-dave/fs/proc/task_mmu.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/proc/task_mmu.c~give-smaps_pte_range-a-size-arg fs/proc/task_mmu.c
--- linux-2.6.git/fs/proc/task_mmu.c~give-smaps_pte_range-a-size-arg	2011-01-31 11:14:20.400194563 -0800
+++ linux-2.6.git-dave/fs/proc/task_mmu.c	2011-01-31 11:15:02.680162163 -0800
@@ -335,7 +335,7 @@ struct mem_size_stats {
 
 
 static void smaps_pte_entry(pte_t ptent, unsigned long addr,
-		struct mm_walk *walk)
+		unsigned long ptent_size, struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = mss->vma;
@@ -343,7 +343,7 @@ static void smaps_pte_entry(pte_t ptent,
 	int mapcount;
 
 	if (is_swap_pte(ptent)) {
-		mss->swap += PAGE_SIZE;
+		mss->swap += ptent_size;
 		return;
 	}
 
@@ -355,25 +355,25 @@ static void smaps_pte_entry(pte_t ptent,
 		return;
 
 	if (PageAnon(page))
-		mss->anonymous += PAGE_SIZE;
+		mss->anonymous += ptent_size;
 
-	mss->resident += PAGE_SIZE;
+	mss->resident += ptent_size;
 	/* Accumulate the size in pages that have been accessed. */
 	if (pte_young(ptent) || PageReferenced(page))
-		mss->referenced += PAGE_SIZE;
+		mss->referenced += ptent_size;
 	mapcount = page_mapcount(page);
 	if (mapcount >= 2) {
 		if (pte_dirty(ptent) || PageDirty(page))
-			mss->shared_dirty += PAGE_SIZE;
+			mss->shared_dirty += ptent_size;
 		else
-			mss->shared_clean += PAGE_SIZE;
-		mss->pss += (PAGE_SIZE << PSS_SHIFT) / mapcount;
+			mss->shared_clean += ptent_size;
+		mss->pss += (ptent_size << PSS_SHIFT) / mapcount;
 	} else {
 		if (pte_dirty(ptent) || PageDirty(page))
-			mss->private_dirty += PAGE_SIZE;
+			mss->private_dirty += ptent_size;
 		else
-			mss->private_clean += PAGE_SIZE;
-		mss->pss += (PAGE_SIZE << PSS_SHIFT);
+			mss->private_clean += ptent_size;
+		mss->pss += (ptent_size << PSS_SHIFT);
 	}
 }
 
@@ -389,7 +389,7 @@ static int smaps_pte_range(pmd_t *pmd, u
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE)
-		smaps_pte_entry(*pte, addr, walk);
+		smaps_pte_entry(*pte, addr, PAGE_SIZE, walk);
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
 	return 0;
_
