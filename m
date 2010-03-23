Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab0CWOgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:36:47 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:36590 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883Ab0CWOfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:35:40 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [patch 4/5] mincore: do nested page table walks
Date: Tue, 23 Mar 2010 15:35:01 +0100
Message-Id: <1269354902-18975-5-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <1269354902-18975-1-git-send-email-hannes@cmpxchg.org>
References: <1269354902-18975-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do page table walks with the well-known nested loops we use in several
other places already.

This avoids doing full page table walks after every pte range and also
allows to handle unmapped areas bigger than one pte range in one go.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/mincore.c |   82 +++++++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 58 insertions(+), 24 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index eb50daa..28cab9d 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -144,6 +144,61 @@ static void mincore_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 	pte_unmap_unlock(ptep - 1, ptl);
 }
 
+static void mincore_pmd_range(struct vm_area_struct *vma, pud_t *pud,
+			unsigned long addr, unsigned long end,
+			unsigned char *vec)
+{
+	unsigned long next;
+	pmd_t *pmd;
+
+	pmd = pmd_offset(pud, addr);
+	split_huge_page_vma(vma, pmd);
+	do {
+		next = pmd_addr_end(addr, end);
+		if (pmd_none_or_clear_bad(pmd))
+			mincore_unmapped_range(vma, addr, next, vec);
+		else
+			mincore_pte_range(vma, pmd, addr, next, vec);
+		vec += (next - addr) >> PAGE_SHIFT;
+	} while (pmd++, addr = next, addr != end);
+}
+
+static void mincore_pud_range(struct vm_area_struct *vma, pgd_t *pgd,
+			unsigned long addr, unsigned long end,
+			unsigned char *vec)
+{
+	unsigned long next;
+	pud_t *pud;
+
+	pud = pud_offset(pgd, addr);
+	do {
+		next = pud_addr_end(addr, end);
+		if (pud_none_or_clear_bad(pud))
+			mincore_unmapped_range(vma, addr, next, vec);
+		else
+			mincore_pmd_range(vma, pud, addr, next, vec);
+		vec += (next - addr) >> PAGE_SHIFT;
+	} while (pud++, addr = next, addr != end);
+}
+
+static void mincore_page_range(struct vm_area_struct *vma,
+			unsigned long addr, unsigned long end,
+			unsigned char *vec)
+{
+	unsigned long next;
+	pgd_t *pgd;
+
+	pgd = pgd_offset(vma->vm_mm, addr);
+	do {
+		next = pgd_addr_end(addr, end);
+		if (pgd_none_or_clear_bad(pgd))
+			mincore_unmapped_range(vma, addr, next, vec);
+		else
+			mincore_pud_range(vma, pgd, addr, next, vec);
+		vec += (next - addr) >> PAGE_SHIFT;
+	} while (pgd++, addr = next, addr != end);
+}
+
 /*
  * Do a chunk of "sys_mincore()". We've already checked
  * all the arguments, we hold the mmap semaphore: we should
@@ -151,9 +206,6 @@ static void mincore_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
  */
 static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *vec)
 {
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
 	struct vm_area_struct *vma;
 	unsigned long end;
 
@@ -163,29 +215,11 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
 
 	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
 
-	if (is_vm_hugetlb_page(vma)) {
+	if (is_vm_hugetlb_page(vma))
 		mincore_hugetlb_page_range(vma, addr, end, vec);
-		return (end - addr) >> PAGE_SHIFT;
-	}
-
-	end = pmd_addr_end(addr, end);
-
-	pgd = pgd_offset(vma->vm_mm, addr);
-	if (pgd_none_or_clear_bad(pgd))
-		goto none_mapped;
-	pud = pud_offset(pgd, addr);
-	if (pud_none_or_clear_bad(pud))
-		goto none_mapped;
-	pmd = pmd_offset(pud, addr);
-	split_huge_page_vma(vma, pmd);
-	if (pmd_none_or_clear_bad(pmd))
-		goto none_mapped;
-
-	mincore_pte_range(vma, pmd, addr, end, vec);
-	return (end - addr) >> PAGE_SHIFT;
+	else
+		mincore_page_range(vma, addr, end, vec);
 
-none_mapped:
-	mincore_unmapped_range(vma, addr, end, vec);
 	return (end - addr) >> PAGE_SHIFT;
 }
 
-- 
1.7.0.2

