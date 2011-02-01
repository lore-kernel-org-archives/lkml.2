Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab1BAAe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 19:34:57 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39980 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756535Ab1BAAeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 19:34:07 -0500
Subject: [RFC][PATCH 5/6] teach smaps_pte_range() about THP pmds
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 31 Jan 2011 16:34:03 -0800
References: <20110201003357.D6F0BE0D@kernel>
In-Reply-To: <20110201003357.D6F0BE0D@kernel>
Message-Id: <20110201003403.736A24DF@kernel>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds code to explicitly detect  and handle
pmd_trans_huge() pmds.  It then passes HPAGE_SIZE units
in to the smap_pte_entry() function instead of PAGE_SIZE.

This means that using /proc/$pid/smaps now will no longer
cause THPs to be broken down in to small pages.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/proc/task_mmu.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN fs/proc/task_mmu.c~teach-smaps_pte_range-about-thp-pmds fs/proc/task_mmu.c
--- linux-2.6.git/fs/proc/task_mmu.c~teach-smaps_pte_range-about-thp-pmds	2011-01-31 15:10:55.387856566 -0800
+++ linux-2.6.git-dave/fs/proc/task_mmu.c	2011-01-31 15:25:12.231239775 -0800
@@ -1,5 +1,6 @@
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
+#include <linux/huge_mm.h>
 #include <linux/mount.h>
 #include <linux/seq_file.h>
 #include <linux/highmem.h>
@@ -385,6 +386,17 @@ static int smaps_pte_range(pmd_t *pmd, u
 	pte_t *pte;
 	spinlock_t *ptl;
 
+	if (pmd_trans_huge(*pmd)) {
+		if (pmd_trans_splitting(*pmd)) {
+			spin_unlock(&walk->mm->page_table_lock);
+			wait_split_huge_page(vma->anon_vma, pmd);
+			spin_lock(&walk->mm->page_table_lock);
+			goto normal_ptes;
+		}
+		smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_SIZE, walk);
+		return 0;
+	}
+normal_ptes:
 	split_huge_page_pmd(walk->mm, pmd);
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
diff -puN mm/vmscan.c~teach-smaps_pte_range-about-thp-pmds mm/vmscan.c
diff -puN include/trace/events/vmscan.h~teach-smaps_pte_range-about-thp-pmds include/trace/events/vmscan.h
diff -puN mm/pagewalk.c~teach-smaps_pte_range-about-thp-pmds mm/pagewalk.c
diff -puN mm/huge_memory.c~teach-smaps_pte_range-about-thp-pmds mm/huge_memory.c
diff -puN mm/memory.c~teach-smaps_pte_range-about-thp-pmds mm/memory.c
diff -puN include/linux/huge_mm.h~teach-smaps_pte_range-about-thp-pmds include/linux/huge_mm.h
diff -puN mm/internal.h~teach-smaps_pte_range-about-thp-pmds mm/internal.h
_
