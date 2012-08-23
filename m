Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964840Ab2HWRTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:19:11 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:59472 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758767Ab2HWRTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:19:02 -0400
Message-Id: <20120823171854.792085547@de.ibm.com>
User-Agent: quilt/0.47-1
Date: Thu, 23 Aug 2012 19:17:38 +0200
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
        ak@linux.intel.com, hughd@google.com
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, gerald.schaefer@de.ibm.com
Subject: [RFC patch 5/7] thp, s390: thp pagetable pre-allocation for System z
References: <20120823171733.595087166@de.ibm.com>
Content-Disposition: inline; filename=linux-3.5-thp-s390-pgtable.patch
x-cbid: 12082317-0542-0000-0000-000002CF19D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of the architecture backend for thp on System z.
It provides the pagetable pre-allocation functions pgtable_deposit()
and pgtable_withdraw(). Unlike other archs, s390 has no struct page *
as pgtable_t, but rather a pointer to the page table. So instead of
saving the pagetable pre-allocation list info inside the struct page,
it is being saved within the pagetable itself.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---
 arch/s390/include/asm/pgtable.h |    6 ++++++
 arch/s390/mm/pgtable.c          |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1166,6 +1166,12 @@ static inline pmd_t *pmd_offset(pud_t *p
 #define pte_unmap(pte) do { } while (0)
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#define __HAVE_ARCH_PGTABLE_DEPOSIT
+extern void pgtable_deposit(struct mm_struct *mm, pgtable_t pgtable);
+
+#define __HAVE_ARCH_PGTABLE_WITHDRAW
+extern pgtable_t pgtable_withdraw(struct mm_struct *mm);
+
 static inline int pmd_trans_splitting(pmd_t pmd)
 {
 	return pmd_val(pmd) & _SEGMENT_ENTRY_SPLIT;
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -883,4 +883,42 @@ void pmdp_splitting_flush(struct vm_area
 		smp_call_function(pmdp_splitting_flush_sync, NULL, 1);
 	}
 }
+
+void pgtable_deposit(struct mm_struct *mm, pgtable_t pgtable)
+{
+	struct list_head *lh = (struct list_head *) pgtable;
+
+	assert_spin_locked(&mm->page_table_lock);
+
+	/* FIFO */
+	if (!mm->pmd_huge_pte)
+		INIT_LIST_HEAD(lh);
+	else
+		list_add(lh, (struct list_head *) mm->pmd_huge_pte);
+	mm->pmd_huge_pte = pgtable;
+}
+
+pgtable_t pgtable_withdraw(struct mm_struct *mm)
+{
+	struct list_head *lh;
+	pgtable_t pgtable;
+	pte_t *ptep;
+
+	assert_spin_locked(&mm->page_table_lock);
+
+	/* FIFO */
+	pgtable = mm->pmd_huge_pte;
+	lh = (struct list_head *) pgtable;
+	if (list_empty(lh))
+		mm->pmd_huge_pte = NULL;
+	else {
+		mm->pmd_huge_pte = (pgtable_t) lh->next;
+		list_del(lh);
+	}
+	ptep = (pte_t *) pgtable;
+	pte_val(*ptep) = _PAGE_TYPE_EMPTY;
+	ptep++;
+	pte_val(*ptep) = _PAGE_TYPE_EMPTY;
+	return pgtable;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */

