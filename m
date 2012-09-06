Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2IFNMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:12:49 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:49043 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab2IFNLZ (ORCPT
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
Subject: [PATCH 5/8] thp, s390: thp splitting backend for s390
Date: Thu,  6 Sep 2012 15:10:40 +0200
Message-Id: <1346937043-28208-6-git-send-email-gerald.schaefer@de.ibm.com>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <1346937043-28208-1-git-send-email-gerald.schaefer@de.ibm.com>
References: <1346937043-28208-1-git-send-email-gerald.schaefer@de.ibm.com>
x-cbid: 12090613-1948-0000-0000-000002E0C143
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of the architecture backend for thp on s390.
It provides the functions related to thp splitting, including
serialization against gup. Unlike other archs, pmdp_splitting_flush()
cannot use a tlb flushing operation to serialize against gup on s390,
because that wouldn't be stopped by the disabled IRQs. So instead,
smp_call_function() is called with an empty function, which will have
the expected effect.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 13 +++++++++++++
 arch/s390/mm/gup.c              | 11 ++++++++++-
 arch/s390/mm/pgtable.c          | 18 ++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 6bd7d74..c3f0775 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -347,6 +347,8 @@ extern struct page *vmemmap;
 
 #define _SEGMENT_ENTRY_LARGE	0x400	/* STE-format control, large page   */
 #define _SEGMENT_ENTRY_CO	0x100	/* change-recording override   */
+#define _SEGMENT_ENTRY_SPLIT_BIT 0	/* THP splitting bit number */
+#define _SEGMENT_ENTRY_SPLIT	(1UL << _SEGMENT_ENTRY_SPLIT_BIT)
 
 /* Page status table bits for virtualization */
 #define RCP_ACC_BITS	0xf000000000000000UL
@@ -506,6 +508,10 @@ static inline int pmd_bad(pmd_t pmd)
 	return (pmd_val(pmd) & mask) != _SEGMENT_ENTRY;
 }
 
+#define __HAVE_ARCH_PMDP_SPLITTING_FLUSH
+extern void pmdp_splitting_flush(struct vm_area_struct *vma,
+				 unsigned long addr, pmd_t *pmdp);
+
 static inline int pte_none(pte_t pte)
 {
 	return (pte_val(pte) & _PAGE_INVALID) && !(pte_val(pte) & _PAGE_SWT);
@@ -1159,6 +1165,13 @@ static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
 #define pte_offset_map(pmd, address) pte_offset_kernel(pmd, address)
 #define pte_unmap(pte) do { } while (0)
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline int pmd_trans_splitting(pmd_t pmd)
+{
+	return pmd_val(pmd) & _SEGMENT_ENTRY_SPLIT;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
 /*
  * 31 bit swap entry format:
  * A page-table entry has some bits we have to treat in a special way.
diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 65cb06e..d34fd6e 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -115,7 +115,16 @@ static inline int gup_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
 		pmd = *pmdp;
 		barrier();
 		next = pmd_addr_end(addr, end);
-		if (pmd_none(pmd))
+		/*
+		 * The pmd_trans_splitting() check below explains why
+		 * pmdp_splitting_flush() has to serialize with
+		 * smp_call_function() against our disabled IRQs, to stop
+		 * this gup-fast code from running while we set the
+		 * splitting bit in the pmd. Returning zero will take
+		 * the slow path that will call wait_split_huge_page()
+		 * if the pmd is still in splitting state.
+		 */
+		if (pmd_none(pmd) || pmd_trans_splitting(pmd))
 			return 0;
 		if (unlikely(pmd_huge(pmd))) {
 			if (!gup_huge_pmd(pmdp, pmd, addr, next,
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 18df31d..5a73522 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -866,3 +866,21 @@ bool kernel_page_present(struct page *page)
 	return cc == 0;
 }
 #endif /* CONFIG_HIBERNATION && CONFIG_DEBUG_PAGEALLOC */
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static void pmdp_splitting_flush_sync(void *arg)
+{
+	/* Simply deliver the interrupt */
+}
+
+void pmdp_splitting_flush(struct vm_area_struct *vma, unsigned long address,
+			  pmd_t *pmdp)
+{
+	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+	if (!test_and_set_bit(_SEGMENT_ENTRY_SPLIT_BIT,
+			      (unsigned long *) pmdp)) {
+		/* need to serialize against gup-fast (IRQ disabled) */
+		smp_call_function(pmdp_splitting_flush_sync, NULL, 1);
+	}
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-- 
1.7.11.5

