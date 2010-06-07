Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab0FGLVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 07:21:38 -0400
Received: from [18.85.46.34] ([18.85.46.34]:37753 "EHLO bombadil.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932212Ab0FGLUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 07:20:38 -0400
Message-Id: <20100607111408.320302531@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 07 Jun 2010 13:07:15 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 21/28] sparc64: Use RCU page table freeing.
References: <20100607110654.606530953@chello.nl>
Content-Disposition: inline; filename=davem-sparc64-Use_RCU_page_table_freeing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100408.180008.180206930.davem@davemloft.net>
---
 arch/sparc/include/asm/pgalloc_64.h |   49 ++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/sparc/include/asm/pgalloc_64.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/pgalloc_64.h
+++ linux-2.6/arch/sparc/include/asm/pgalloc_64.h
@@ -76,7 +76,52 @@ static inline void pte_free(struct mm_st
 
 #define check_pgt_cache()	do { } while (0)
 
-#define __pte_free_tlb(tlb, pte, addr)	pte_free((tlb)->mm, pte)
-#define __pmd_free_tlb(tlb, pmd, addr)	pmd_free((tlb)->mm, pmd)
+static inline void pgtable_free(void *table, bool is_page)
+{
+	if (is_page)
+		free_page((unsigned long)table);
+	else
+		kmem_cache_free(pgtable_cache, table);
+}
+
+#ifdef CONFIG_SMP
+#define HAVE_ARCH_RCU_TABLE_FREE
+
+struct mmu_gather;
+extern void tlb_remove_table(struct mmu_gather *, void *);
+
+static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, bool is_page)
+{
+	unsigned long pgf = (unsigned long)table;
+	if (is_page)
+		pgf |= 0x1UL;
+	tlb_remove_table(tlb, (void *)pgf);
+}
+
+static inline void __tlb_remove_table(void *_table)
+{
+	void *table = (void *)((unsigned long)_table & ~0x1UL);
+	bool is_page = false;
+
+	if ((unsigned long)_table & 0x1UL)
+		is_page = true;
+	pgtable_free(table, is_page);
+}
+#else /* CONFIG_SMP */
+static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, bool is_page)
+{
+	pgtable_free(table, is_page);
+}
+#endif /* !CONFIG_SMP */
+
+static inline void __pte_free_tlb(struct mmu_gather *tlb, struct page *ptepage,
+				  unsigned long address)
+{
+	pgtable_page_dtor(ptepage);
+	pgtable_free_tlb(tlb, page_address(ptepage), true);
+}
+
+#define __pmd_free_tlb(tlb, pmd, addr)		      \
+	pgtable_free_tlb(tlb, pmd, false)
 
 #endif /* _SPARC64_PGALLOC_H */


