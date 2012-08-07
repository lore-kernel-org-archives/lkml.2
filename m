Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030196Ab2HGDmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:42:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59866 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964825Ab2HGDi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:57 -0400
Message-Id: <20120807032800.801110625@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:27 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 32/70] s390/mm: downgrade page table after fork of a 31 bit process
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 0f6f281b731d20bfe75c13f85d33f3f05b440222 upstream.

The downgrade of the 4 level page table created by init_new_context is
currently done only in start_thread31. If a 31 bit process forks the
new mm uses a 4 level page table, including the task size of 2<<42
that goes along with it. This is incorrect as now a 31 bit process
can map memory beyond 2GB. Define arch_dup_mmap to do the downgrade
after fork.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/include/asm/mmu_context.h |   14 +++++++++++++-
 arch/s390/include/asm/processor.h   |    2 ++
 arch/s390/mm/mmap.c                 |   12 ++++++++++--
 arch/s390/mm/pgtable.c              |    5 -----
 4 files changed, 25 insertions(+), 8 deletions(-)

--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -12,7 +12,6 @@
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
-#include <asm-generic/mm_hooks.h>
 
 static inline int init_new_context(struct task_struct *tsk,
 				   struct mm_struct *mm)
@@ -92,4 +91,17 @@ static inline void activate_mm(struct mm
         switch_mm(prev, next, current);
 }
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+#ifdef CONFIG_64BIT
+	if (oldmm->context.asce_limit < mm->context.asce_limit)
+		crst_table_downgrade(mm, oldmm->context.asce_limit);
+#endif
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
+
 #endif /* __S390_MMU_CONTEXT_H */
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -130,7 +130,9 @@ struct stack_frame {
 	regs->psw.mask	= psw_user_bits | PSW_MASK_BA;			\
 	regs->psw.addr	= new_psw | PSW_ADDR_AMODE;			\
 	regs->gprs[15]	= new_stackp;					\
+	__tlb_flush_mm(current->mm);					\
 	crst_table_downgrade(current->mm, 1UL << 31);			\
+	update_mm(current->mm, current);				\
 } while (0)
 
 /* Forward declaration, a strange C thing */
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -106,9 +106,15 @@ EXPORT_SYMBOL_GPL(arch_pick_mmap_layout)
 
 int s390_mmap_check(unsigned long addr, unsigned long len)
 {
+	int rc;
+
 	if (!is_compat_task() &&
-	    len >= TASK_SIZE && TASK_SIZE < (1UL << 53))
-		return crst_table_upgrade(current->mm, 1UL << 53);
+	    len >= TASK_SIZE && TASK_SIZE < (1UL << 53)) {
+		rc = crst_table_upgrade(current->mm, 1UL << 53);
+		if (rc)
+			return rc;
+		update_mm(current->mm, current);
+	}
 	return 0;
 }
 
@@ -128,6 +134,7 @@ s390_get_unmapped_area(struct file *filp
 		rc = crst_table_upgrade(mm, 1UL << 53);
 		if (rc)
 			return (unsigned long) rc;
+		update_mm(mm, current);
 		area = arch_get_unmapped_area(filp, addr, len, pgoff, flags);
 	}
 	return area;
@@ -150,6 +157,7 @@ s390_get_unmapped_area_topdown(struct fi
 		rc = crst_table_upgrade(mm, 1UL << 53);
 		if (rc)
 			return (unsigned long) rc;
+		update_mm(mm, current);
 		area = arch_get_unmapped_area_topdown(filp, addr, len,
 						      pgoff, flags);
 	}
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -97,7 +97,6 @@ repeat:
 		crst_table_free(mm, table);
 	if (mm->context.asce_limit < limit)
 		goto repeat;
-	update_mm(mm, current);
 	return 0;
 }
 
@@ -105,9 +104,6 @@ void crst_table_downgrade(struct mm_stru
 {
 	pgd_t *pgd;
 
-	if (mm->context.asce_limit <= limit)
-		return;
-	__tlb_flush_mm(mm);
 	while (mm->context.asce_limit > limit) {
 		pgd = mm->pgd;
 		switch (pgd_val(*pgd) & _REGION_ENTRY_TYPE_MASK) {
@@ -130,7 +126,6 @@ void crst_table_downgrade(struct mm_stru
 		mm->task_size = mm->context.asce_limit;
 		crst_table_free(mm, (unsigned long *) pgd);
 	}
-	update_mm(mm, current);
 }
 #endif
 


