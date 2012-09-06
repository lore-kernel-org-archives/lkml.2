Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab2IFNNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:13:31 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:37655 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab2IFNLZ (ORCPT
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
Subject: [PATCH 3/8] thp: introduce pmdp_invalidate()
Date: Thu,  6 Sep 2012 15:10:38 +0200
Message-Id: <1346937043-28208-4-git-send-email-gerald.schaefer@de.ibm.com>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <1346937043-28208-1-git-send-email-gerald.schaefer@de.ibm.com>
References: <1346937043-28208-1-git-send-email-gerald.schaefer@de.ibm.com>
x-cbid: 12090613-4966-0000-0000-0000036D0569
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On s390, a valid page table entry must not be changed while it is
attached to any CPU. So instead of pmd_mknotpresent() and set_pmd_at(),
an IDTE operation would be necessary there. This patch introduces the
pmdp_invalidate() function, to allow architecture-specific
implementations.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---
 include/asm-generic/pgtable.h |  5 +++++
 mm/huge_memory.c              |  3 +--
 mm/pgtable-generic.c          | 11 +++++++++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 548a12e..e4821cf 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -170,6 +170,11 @@ extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pgtable_t pgtable);
 extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm);
 #endif
 
+#ifndef __HAVE_ARCH_PMDP_INVALIDATE
+extern void pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
+			    pmd_t *pmdp);
+#endif
+
 #ifndef __HAVE_ARCH_PTE_SAME
 static inline int pte_same(pte_t pte_a, pte_t pte_b)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5fce078..5617ee0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1374,8 +1374,7 @@ static int __split_huge_page_map(struct page *page,
 		 * SMP TLB and finally we write the non-huge version
 		 * of the pmd entry with pmd_populate.
 		 */
-		set_pmd_at(mm, address, pmd, pmd_mknotpresent(*pmd));
-		flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
+		pmdp_invalidate(vma, address, pmd);
 		pmd_populate(mm, pmd, pgtable);
 		ret = 1;
 	}
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 29867e0..e642627 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -159,3 +159,14 @@ pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm)
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
+
+#ifndef __HAVE_ARCH_PMDP_INVALIDATE
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+void pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
+		     pmd_t *pmdp)
+{
+	set_pmd_at(vma->vm_mm, address, pmdp, pmd_mknotpresent(*pmdp));
+	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif
-- 
1.7.11.5

