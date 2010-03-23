Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab0CWOfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:35:41 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:36587 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab0CWOfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:35:39 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [rfc 5/5] mincore: transparent huge page support
Date: Tue, 23 Mar 2010 15:35:02 +0100
Message-Id: <1269354902-18975-6-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <1269354902-18975-1-git-send-email-hannes@cmpxchg.org>
References: <1269354902-18975-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle transparent huge page pmd entries natively instead of splitting
them into subpages.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/mincore.c |   37 ++++++++++++++++++++++++++++++++++---
 1 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 28cab9d..d4cddc1 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -15,6 +15,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/hugetlb.h>
+#include <linux/rmap.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -144,6 +145,35 @@ static void mincore_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 	pte_unmap_unlock(ptep - 1, ptl);
 }
 
+static int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+			unsigned long addr, unsigned long end,
+			unsigned char *vec)
+{
+	int huge = 0;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	spin_lock(&vma->vm_mm->page_table_lock);
+	if (likely(pmd_trans_huge(*pmd))) {
+		huge = !pmd_trans_splitting(*pmd);
+		spin_unlock(&vma->vm_mm->page_table_lock);
+		/*
+		 * If we have an intact huge pmd entry, all pages in
+		 * the range are present in the mincore() sense of
+		 * things.
+		 *
+		 * But if the entry is currently being split into
+		 * normal page mappings, wait for it to finish and
+		 * signal the fallback to ptes.
+		 */
+		if (huge)
+			memset(vec, 1, (end - addr) >> PAGE_SHIFT);
+		else
+			wait_split_huge_page(vma->anon_vma, pmd);
+	} else
+		spin_unlock(&vma->vm_mm->page_table_lock);
+#endif
+	return huge;
+}
+
 static void mincore_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 			unsigned long addr, unsigned long end,
 			unsigned char *vec)
@@ -152,12 +182,13 @@ static void mincore_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 	pmd_t *pmd;
 
 	pmd = pmd_offset(pud, addr);
-	split_huge_page_vma(vma, pmd);
 	do {
 		next = pmd_addr_end(addr, end);
-		if (pmd_none_or_clear_bad(pmd))
+		/* XXX: pmd_none_or_clear_bad() triggers on _PAGE_PSE */
+		if (pmd_none(*pmd))
 			mincore_unmapped_range(vma, addr, next, vec);
-		else
+		else if (!pmd_trans_huge(*pmd) ||
+			 !mincore_huge_pmd(vma, pmd, addr, next, vec))
 			mincore_pte_range(vma, pmd, addr, next, vec);
 		vec += (next - addr) >> PAGE_SHIFT;
 	} while (pmd++, addr = next, addr != end);
-- 
1.7.0.2

