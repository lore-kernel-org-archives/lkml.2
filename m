Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964874Ab2HWRTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:19:16 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:44086 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759092Ab2HWRTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:19:02 -0400
Message-Id: <20120823171854.473831303@de.ibm.com>
User-Agent: quilt/0.47-1
Date: Thu, 23 Aug 2012 19:17:35 +0200
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
        ak@linux.intel.com, hughd@google.com
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, gerald.schaefer@de.ibm.com
Subject: [RFC patch 2/7] thp: introduce pmdp_invalidate()
References: <20120823171733.595087166@de.ibm.com>
Content-Disposition: inline; filename=linux-3.5-thp-pmd-flush.patch
x-cbid: 12082317-3548-0000-0000-000002E73708
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On System z, a valid page table entry must not be changed while it is
attached to any CPU. So instead of pmd_mknotpresent() and set_pmd_at(),
an IDTE operation would be necessary there. This patch introduces the
pmdp_invalidate() function, to allow architecture-specific
implementations.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---
 include/asm-generic/pgtable.h |   11 +++++++++++
 mm/huge_memory.c              |    3 +--
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -93,6 +93,17 @@ static inline pmd_t pmdp_get_and_clear(s
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
+#ifndef __HAVE_ARCH_PMDP_INVALIDATE
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline void pmdp_invalidate(struct vm_area_struct *vma,
+				   unsigned long address, pmd_t *pmdp)
+{
+	set_pmd_at(vma->vm_mm, address, pmd, pmd_mknotpresent(*pmd));
+	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
 static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 					    unsigned long address, pte_t *ptep,
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1374,8 +1374,7 @@ static int __split_huge_page_map(struct
 		 * SMP TLB and finally we write the non-huge version
 		 * of the pmd entry with pmd_populate.
 		 */
-		set_pmd_at(mm, address, pmd, pmd_mknotpresent(*pmd));
-		flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
+		pmdp_invalidate(vma, address, pmd);
 		pmd_populate(mm, pmd, pgtable);
 		ret = 1;
 	}

