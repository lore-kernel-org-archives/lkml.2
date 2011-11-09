Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1KIPrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 10:47:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab1KIPrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 10:47:24 -0500
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH 2/3] tile: remove irqsave pgd_lock locking
Date: Wed,  9 Nov 2011 16:47:18 +0100
Message-Id: <1320853639-18048-2-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1320853639-18048-1-git-send-email-mhocko@suse.cz>
References: <1320853639-18048-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a79e53d8: x86/mm: Fix pgd_lock deadlock dropped irqsave locking to fix a
deadlock. pgd_lock is not used from an irq context so we can drop
irqsave locking here as well.
The original patch was x86 only but the same applies here
because pgd_ctor (aka mm_alloc_pgd), pgd_dtor (aka mm_free_pgd),
shatter_huge_page (not used anywhere) and vmalloc_sync_all are not used
from an interrupt contexts.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/tile/mm/fault.c   |    5 ++---
 arch/tile/mm/pgtable.c |   19 +++++++------------
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index 25b7b90..8ea75a6 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -852,10 +852,9 @@ void vmalloc_sync_all(void)
 	BUILD_BUG_ON(PAGE_OFFSET & ~PGDIR_MASK);
 	for (address = start; address >= PAGE_OFFSET; address += PGDIR_SIZE) {
 		if (!test_bit(pgd_index(address), insync)) {
-			unsigned long flags;
 			struct list_head *pos;
 
-			spin_lock_irqsave(&pgd_lock, flags);
+			spin_lock(&pgd_lock);
 			list_for_each(pos, &pgd_list)
 				if (!vmalloc_sync_one(list_to_pgd(pos),
 								address)) {
@@ -863,7 +862,7 @@ void vmalloc_sync_all(void)
 					BUG_ON(pos != pgd_list.next);
 					break;
 				}
-			spin_unlock_irqrestore(&pgd_lock, flags);
+			spin_unlock(&pgd_lock);
 			if (pos != pgd_list.next)
 				set_bit(pgd_index(address), insync);
 		}
diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
index de7d8e2..445028c 100644
--- a/arch/tile/mm/pgtable.c
+++ b/arch/tile/mm/pgtable.c
@@ -161,7 +161,6 @@ void shatter_huge_page(unsigned long addr)
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
-	unsigned long flags = 0;  /* happy compiler */
 #ifdef __PAGETABLE_PMD_FOLDED
 	struct list_head *pos;
 #endif
@@ -182,10 +181,10 @@ void shatter_huge_page(unsigned long addr)
 	 * Grab the pgd_lock, since we may need it to walk the pgd_list,
 	 * and since we need some kind of lock here to avoid races.
 	 */
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	if (!pmd_huge_page(*pmd)) {
 		/* Lost the race to convert the huge page. */
-		spin_unlock_irqrestore(&pgd_lock, flags);
+		spin_unlock(&pgd_lock);
 		return;
 	}
 
@@ -209,7 +208,7 @@ void shatter_huge_page(unsigned long addr)
 		     cpu_possible_mask, NULL, 0);
 
 	/* Hold the lock until the TLB flush is finished to avoid races. */
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 /*
@@ -240,10 +239,8 @@ static inline void pgd_list_del(pgd_t *pgd)
 
 static void pgd_ctor(pgd_t *pgd)
 {
-	unsigned long flags;
-
 	memset(pgd, 0, KERNEL_PGD_INDEX_START*sizeof(pgd_t));
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 
 #ifndef __tilegx__
 	/*
@@ -259,16 +256,14 @@ static void pgd_ctor(pgd_t *pgd)
 	       KERNEL_PGD_PTRS * sizeof(pgd_t));
 
 	pgd_list_add(pgd);
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 static void pgd_dtor(pgd_t *pgd)
 {
-	unsigned long flags; /* can be called from interrupt context */
-
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	pgd_list_del(pgd);
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 pgd_t *pgd_alloc(struct mm_struct *mm)
-- 
1.7.7.1

