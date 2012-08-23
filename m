Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152Ab2HWRVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:21:15 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:40787 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759107Ab2HWRTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:19:02 -0400
Message-Id: <20120823171854.686004941@de.ibm.com>
User-Agent: quilt/0.47-1
Date: Thu, 23 Aug 2012 19:17:37 +0200
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
        ak@linux.intel.com, hughd@google.com
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, gerald.schaefer@de.ibm.com
Subject: [RFC patch 4/7] thp, s390: thp splitting backend for System z
References: <20120823171733.595087166@de.ibm.com>
Content-Disposition: inline; filename=linux-3.5-thp-s390-split.patch
x-cbid: 12082317-8372-0000-0000-0000038AD43D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of the architecture backend for thp on System z.
It provides the functions related to thp splitting, including
serialization against gup. Unlike other archs, pmdp_splitting_flush()
cannot use a tlb flushing operation to serialize against gup on s390,
because that wouldn't be stopped by the disabled IRQs. So instead,
smp_call_function() is called with an empty function, which will have
the expected effect.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---
 arch/s390/include/asm/pgtable.h |   13 +++++++++++++
 arch/s390/mm/gup.c              |   11 ++++++++++-
 arch/s390/mm/pgtable.c          |   18 ++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

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
@@ -1159,6 +1165,13 @@ static inline pmd_t *pmd_offset(pud_t *p
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
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -115,7 +115,16 @@ static inline int gup_pmd_range(pud_t *p
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
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -866,3 +866,21 @@ bool kernel_page_present(struct page *pa
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

