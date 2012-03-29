Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936639Ab2C3Wy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:54:57 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934941Ab2C3VF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:56 -0400
Message-Id: <201203302105.q2UL56Xh006298@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 15:50:08 -0400
Subject: [PATCH] arch/tile: fix up locking in pgtable.c slightly
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:06.0850 (UTC) FILETIME=[C8C16020:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should be holding the init_mm.page_table_lock in shatter_huge_page()
since we are modifying the kernel page tables.  Then, only if we are
walking the other root page tables to update them, do we want to take
the pgd_lock.

Add a comment about taking the pgd_lock that we always do it with
interrupts disabled and therefore are not at risk from the tlbflush
IPI deadlock as is seen on x86.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/pgtable.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
index 277645f..9c6985f 100644
--- a/arch/tile/mm/pgtable.c
+++ b/arch/tile/mm/pgtable.c
@@ -178,14 +178,10 @@ void shatter_huge_page(unsigned long addr)
 	if (!pmd_huge_page(*pmd))
 		return;
 
-	/*
-	 * Grab the pgd_lock, since we may need it to walk the pgd_list,
-	 * and since we need some kind of lock here to avoid races.
-	 */
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock_irqsave(&init_mm.page_table_lock, flags);
 	if (!pmd_huge_page(*pmd)) {
 		/* Lost the race to convert the huge page. */
-		spin_unlock_irqrestore(&pgd_lock, flags);
+		spin_unlock_irqrestore(&init_mm.page_table_lock, flags);
 		return;
 	}
 
@@ -195,6 +191,7 @@ void shatter_huge_page(unsigned long addr)
 
 #ifdef __PAGETABLE_PMD_FOLDED
 	/* Walk every pgd on the system and update the pmd there. */
+	spin_lock(&pgd_lock);
 	list_for_each(pos, &pgd_list) {
 		pmd_t *copy_pmd;
 		pgd = list_to_pgd(pos) + pgd_index(addr);
@@ -202,6 +199,7 @@ void shatter_huge_page(unsigned long addr)
 		copy_pmd = pmd_offset(pud, addr);
 		__set_pmd(copy_pmd, *pmd);
 	}
+	spin_unlock(&pgd_lock);
 #endif
 
 	/* Tell every cpu to notice the change. */
@@ -209,7 +207,7 @@ void shatter_huge_page(unsigned long addr)
 		     cpu_possible_mask, NULL, 0);
 
 	/* Hold the lock until the TLB flush is finished to avoid races. */
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock_irqrestore(&init_mm.page_table_lock, flags);
 }
 
 /*
@@ -218,9 +216,13 @@ void shatter_huge_page(unsigned long addr)
  * against pageattr.c; it is the unique case in which a valid change
  * of kernel pagetables can't be lazily synchronized by vmalloc faults.
  * vmalloc faults work because attached pagetables are never freed.
- * The locking scheme was chosen on the basis of manfred's
- * recommendations and having no core impact whatsoever.
- * -- wli
+ *
+ * The lock is always taken with interrupts disabled, unlike on x86
+ * and other platforms, because we need to take the lock in
+ * shatter_huge_page(), which may be called from an interrupt context.
+ * We are not at risk from the tlbflush IPI deadlock that was seen on
+ * x86, since we use the flush_remote() API to have the hypervisor do
+ * the TLB flushes regardless of irq disabling.
  */
 DEFINE_SPINLOCK(pgd_lock);
 LIST_HEAD(pgd_list);
-- 
1.6.5.2

