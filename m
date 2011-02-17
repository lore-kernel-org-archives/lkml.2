Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab1BQROT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:14:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:36121 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099Ab1BQRLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:11:07 -0500
Message-Id: <20110217163235.658196547@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 17 Feb 2011 17:23:41 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: [PATCH 14/17] mm: Provide generic range tracking and flushing
References: <20110217162327.434629380@chello.nl>
Content-Disposition: inline; filename=mm-generic-tlb-range.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to convert ia64, arm and sh to generic tlb we need to provide
some extra infrastructure to track the range of the flushed page
tables.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/Kconfig              |    3 +++
 include/asm-generic/tlb.h |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

Index: linux-2.6/arch/Kconfig
===================================================================
--- linux-2.6.orig/arch/Kconfig
+++ linux-2.6/arch/Kconfig
@@ -181,4 +181,7 @@ config HAVE_ARCH_MUTEX_CPU_RELAX
 config HAVE_RCU_TABLE_FREE
 	bool
 
+config HAVE_MMU_GATHER_RANGE
+	bool
+
 source "kernel/gcov/Kconfig"
Index: linux-2.6/include/asm-generic/tlb.h
===================================================================
--- linux-2.6.orig/include/asm-generic/tlb.h
+++ linux-2.6/include/asm-generic/tlb.h
@@ -87,6 +87,10 @@ struct mmu_gather {
 				fast_mode  : 1; /* No batching   */
 	unsigned int		fullmm;		/* Flush full mm */
 
+#ifdef CONFIG_HAVE_MMU_GATHER_RANGE
+	unsigned long		start, end;
+#endif
+
 	struct mmu_gather_batch *active;
 	struct mmu_gather_batch	local;
 	struct page		*__pages[MMU_GATHER_BUNDLE];
@@ -228,6 +232,35 @@ static inline void tlb_remove_page(struc
 		tlb_flush_mmu(tlb);
 }
 
+#ifdef CONFIG_HAVE_MMU_GATHER_RANGE
+static inline void
+__tlb_remove_tlb_entry(struct mmu_gather *tlb, pte_t *ptep, unsigned long address)
+{
+	if (!tlb->fullmm) {
+		tlb->start = min(tlb->start, address);
+		address += PAGE_SIZE;
+		tlb->end = max(tlb->end, address);
+	}
+}
+
+static inline void
+tlb_start_vma(struct mmu_gather *tlb, struct vm_area_struct *vma)
+{
+	if (!tlb->fullmm) {
+		flush_cache_range(vma, vma->vm_start, vma->vm_end);
+		tlb->start = TASK_SIZE;
+		tlb->end = 0;
+	}
+}
+
+static inline void
+tlb_end_vma(struct mmu_gather *tlb, struct vm_area_struct *vma)
+{
+	if (!tlb->fullmm && tlb->end)
+		flush_tlb_range(vma, tlb->start, tlb->end);
+}
+#endif
+
 /**
  * tlb_remove_tlb_entry - remember a pte unmapping for later tlb invalidation.
  *
@@ -261,6 +294,8 @@ static inline void tlb_remove_page(struc
 		__pmd_free_tlb(tlb, pmdp, address);		\
 	} while (0)
 
+#ifndef tlb_migrate_finish
 #define tlb_migrate_finish(mm) do {} while (0)
+#endif
 
 #endif /* _ASM_GENERIC__TLB_H */


