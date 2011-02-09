Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab1BITyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 14:54:51 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53005 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519Ab1BITyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 14:54:20 -0500
Subject: [PATCH 4/5] teach smaps_pte_range() about THP pmds
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 09 Feb 2011 11:54:11 -0800
References: <20110209195406.B9F23C9F@kernel>
In-Reply-To: <20110209195406.B9F23C9F@kernel>
Message-Id: <20110209195411.816D55A7@kernel>
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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
---

 linux-2.6.git-dave/fs/proc/task_mmu.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~teach-smaps_pte_range-about-thp-pmds fs/proc/task_mmu.c
--- linux-2.6.git/fs/proc/task_mmu.c~teach-smaps_pte_range-about-thp-pmds	2011-02-09 11:41:43.919557155 -0800
+++ linux-2.6.git-dave/fs/proc/task_mmu.c	2011-02-09 11:41:43.927557149 -0800
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
 
@@ -385,8 +387,16 @@ static int smaps_pte_range(pmd_t *pmd, u
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	split_huge_page_pmd(walk->mm, pmd);
-
+	if (pmd_trans_huge(*pmd)) {
+		if (pmd_trans_splitting(*pmd)) {
+			spin_unlock(&walk->mm->page_table_lock);
+			wait_split_huge_page(vma->anon_vma, pmd);
+			spin_lock(&walk->mm->page_table_lock);
+		} else {
+			smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_SIZE, walk);
+			return 0;
+		}
+	}
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE)
 		smaps_pte_entry(*pte, addr, PAGE_SIZE, walk);
_
