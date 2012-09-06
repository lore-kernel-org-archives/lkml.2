Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab2IFNMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:12:36 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:40909 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab2IFNLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:11:25 -0400
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: [PATCH 6/8] thp, s390: thp pagetable pre-allocation for s390
Date: Thu,  6 Sep 2012 15:10:41 +0200
Message-Id: <1346937043-28208-7-git-send-email-gerald.schaefer@de.ibm.com>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <1346937043-28208-1-git-send-email-gerald.schaefer@de.ibm.com>
References: <1346937043-28208-1-git-send-email-gerald.schaefer@de.ibm.com>
x-cbid: 12090613-6892-0000-0000-000002EB37BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of the architecture backend for thp on s390.
It provides the pagetable pre-allocation functions
pgtable_trans_huge_deposit() and pgtable_trans_huge_withdraw(). Unlike
other archs, s390 has no struct page * as pgtable_t, but rather a
pointer to the page table. So instead of saving the pagetable pre-
allocation list info inside the struct page, it is being saved within
the pagetable itself.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---
 arch/s390/include/asm/pgtable.h |  6 ++++++
 arch/s390/mm/pgtable.c          | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index c3f0775..2c8f00d 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1166,6 +1166,12 @@ static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
 #define pte_unmap(pte) do { } while (0)
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#define __HAVE_ARCH_PGTABLE_DEPOSIT
+extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pgtable_t pgtable);
+
+#define __HAVE_ARCH_PGTABLE_WITHDRAW
+extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm);
+
 static inline int pmd_trans_splitting(pmd_t pmd)
 {
 	return pmd_val(pmd) & _SEGMENT_ENTRY_SPLIT;
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 5a73522..091e06d 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -883,4 +883,42 @@ void pmdp_splitting_flush(struct vm_area_struct *vma, unsigned long address,
 		smp_call_function(pmdp_splitting_flush_sync, NULL, 1);
 	}
 }
+
+void pgtable_trans_huge_deposit(struct mm_struct *mm, pgtable_t pgtable)
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
+pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm)
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
-- 
1.7.11.5

