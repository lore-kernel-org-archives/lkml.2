Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab1BVBxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 20:53:49 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40634 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab1BVBxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 20:53:46 -0500
Subject: [PATCH 4/5] teach smaps_pte_range() about THP pmds
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, akpm@osdl.org,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 21 Feb 2011 17:53:43 -0800
References: <20110222015338.309727CA@kernel>
In-Reply-To: <20110222015338.309727CA@kernel>
Message-Id: <20110222015343.41586948@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v2 - used mm->page_table_lock to fix up locking bug that
	Mel pointed out.  Also remove Acks since things
	got changed significantly.

This adds code to explicitly detect  and handle
pmd_trans_huge() pmds.  It then passes HPAGE_SIZE units
in to the smap_pte_entry() function instead of PAGE_SIZE.

This means that using /proc/$pid/smaps now will no longer
cause THPs to be broken down in to small pages.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/proc/task_mmu.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~teach-smaps_pte_range-about-thp-pmds fs/proc/task_mmu.c
--- linux-2.6.git/fs/proc/task_mmu.c~teach-smaps_pte_range-about-thp-pmds	2011-02-14 09:59:44.034590716 -0800
+++ linux-2.6.git-dave/fs/proc/task_mmu.c	2011-02-21 15:12:46.144181298 -0800
@@ -1,5 +1,6 @@
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
+#include <linux/huge_mm.h>
 #include <linux/mount.h>
 #include <linux/seq_file.h>
 #include <linux/highmem.h>
@@ -7,6 +8,7 @@
 #include <linux/slab.h>
 #include <linux/pagemap.h>
 #include <linux/mempolicy.h>
+#include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
 
@@ -385,8 +387,25 @@ static int smaps_pte_range(pmd_t *pmd, u
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	split_huge_page_pmd(walk->mm, pmd);
-
+	spin_lock(&walk->mm->page_table_lock);
+	if (pmd_trans_huge(*pmd)) {
+		if (pmd_trans_splitting(*pmd)) {
+			spin_unlock(&walk->mm->page_table_lock);
+			wait_split_huge_page(vma->anon_vma, pmd);
+		} else {
+			smaps_pte_entry(*(pte_t *)pmd, addr,
+					HPAGE_PMD_SIZE, walk);
+			spin_unlock(&walk->mm->page_table_lock);
+			return 0;
+		}
+	} else {
+		spin_unlock(&walk->mm->page_table_lock);
+	}
+	/*
+	 * The mmap_sem held all the way back in m_start() is what
+	 * keeps khugepaged out of here and from collapsing things
+	 * in here.
+	 */
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE)
 		smaps_pte_entry(*pte, addr, PAGE_SIZE, walk);
diff -puN mm/migrate.c~teach-smaps_pte_range-about-thp-pmds mm/migrate.c
diff -puN mm/mincore.c~teach-smaps_pte_range-about-thp-pmds mm/mincore.c
diff -puN include/linux/mm.h~teach-smaps_pte_range-about-thp-pmds include/linux/mm.h
diff -puN mm/mempolicy.c~teach-smaps_pte_range-about-thp-pmds mm/mempolicy.c
_
