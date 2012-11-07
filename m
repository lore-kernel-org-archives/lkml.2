Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab2KGJs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:48:56 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:52601 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab2KGJso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:44 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 19/31] ARC: MMU Context Management
Date: Wed,  7 Nov 2012 10:47:42 +0100
Message-Id: <1352281674-2186-20-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARC700 MMU provides for tagging TLB entries with a 8-bit ASID to avoid
having to flush the TLB every task switch.

It also allows for a quick way to invalidate all the TLB entries for
task useful for:
* COW sementics during fork()
* task exit()ing

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/arcregs.h     |    7 ++
 arch/arc/include/asm/mmu.h         |   23 ++++
 arch/arc/include/asm/mmu_context.h |  209 ++++++++++++++++++++++++++++++++++++
 arch/arc/mm/tlb.c                  |   23 ++++
 4 files changed, 262 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/mmu.h
 create mode 100644 arch/arc/include/asm/mmu_context.h
 create mode 100644 arch/arc/mm/tlb.c

diff --git a/arch/arc/include/asm/arcregs.h b/arch/arc/include/asm/arcregs.h
index c6e2805..c12eb9b 100644
--- a/arch/arc/include/asm/arcregs.h
+++ b/arch/arc/include/asm/arcregs.h
@@ -85,6 +85,13 @@
 #define DC_CTRL_INV_MODE_FLUSH  0x40
 #define DC_CTRL_FLUSH_STATUS    0x100
 
+/* MMU Management regs */
+#define ARC_REG_PID		0x409
+#define ARC_REG_SCRATCH_DATA0	0x418
+
+/* Bits in MMU PID register */
+#define MMU_ENABLE		(1 << 31)	/* Enable MMU for process */
+
 /*
  * Floating Pt Registers
  * Status regs are read-only (build-time) so need not be saved/restored
diff --git a/arch/arc/include/asm/mmu.h b/arch/arc/include/asm/mmu.h
new file mode 100644
index 0000000..56b0232
--- /dev/null
+++ b/arch/arc/include/asm/mmu.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_MMU_H
+#define _ASM_ARC_MMU_H
+
+#ifndef __ASSEMBLY__
+
+typedef struct {
+	unsigned long asid;	/* Pvt Addr-Space ID for mm */
+#ifdef CONFIG_ARC_TLB_DBG
+	struct task_struct *tsk;
+#endif
+} mm_context_t;
+
+#endif
+
+#endif
diff --git a/arch/arc/include/asm/mmu_context.h b/arch/arc/include/asm/mmu_context.h
new file mode 100644
index 0000000..d12f3de
--- /dev/null
+++ b/arch/arc/include/asm/mmu_context.h
@@ -0,0 +1,209 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * vineetg: May 2011
+ *  -Refactored get_new_mmu_context( ) to only handle live-mm.
+ *   retiring-mm handled in other hooks
+ *
+ * Vineetg: March 25th, 2008: Bug #92690
+ *  -Major rewrite of Core ASID allocation routine get_new_mmu_context
+ *
+ * Amit Bhor, Sameer Dhavale: Codito Technologies 2004
+ */
+
+#ifndef _ASM_ARC_MMU_CONTEXT_H
+#define _ASM_ARC_MMU_CONTEXT_H
+
+#include <asm/arcregs.h>
+#include <asm/tlb.h>
+
+#include <asm-generic/mm_hooks.h>
+
+/*		ARC700 ASID Management
+ *
+ * ARC MMU provides 8-bit ASID (0..255) to TAG TLB entries, allowing entries
+ * with same vaddr (different tasks) to co-exit. This provides for
+ * "Fast Context Switch" i.e. no TLB flush on ctxt-switch
+ *
+ * Linux assigns each task a unique ASID. A simple round-robin allocation
+ * of H/w ASID is done using software tracker @asid_cache.
+ * When it reaches max 255, the allocation cycle starts afresh by flushing
+ * the entire TLB and wrapping ASID back to zero.
+ *
+ * For book-keeping, Linux uses a couple of data-structures:
+ *  -mm_struct has an @asid field to keep a note of task's ASID (needed at the
+ *   time of say switch_mm( )
+ *  -An array of mm structs @asid_mm_map[] for asid->mm the reverse mapping,
+ *  given an ASID, finding the mm struct associated.
+ *
+ * The round-robin allocation algorithm allows for ASID stealing.
+ * If asid tracker is at "x-1", a new req will allocate "x", even if "x" was
+ * already assigned to another (switched-out) task. Obviously the prev owner
+ * is marked with an invalid ASID to make it request for a new ASID when it
+ * gets scheduled next time. However its TLB entries (with ASID "x") could
+ * exist, which must be cleared before the same ASID is used by the new owner.
+ * Flushing them would be plausible but costly solution. Instead we force a
+ * allocation policy quirk, which ensures that a stolen ASID won't have any
+ * TLB entries associates, alleviating the need to flush.
+ * The quirk essentially is not allowing ASID allocated in prev cycle
+ * to be used past a roll-over in the next cycle.
+ * When this happens (i.e. task ASID > asid tracker), task needs to refresh
+ * its ASID, aligning it to current value of tracker. If the task doesn't get
+ * scheduled past a roll-over, hence its ASID is not yet realigned with
+ * tracker, such ASID is anyways safely reusable because it is
+ * gauranteed that TLB entries with that ASID wont exist.
+ */
+
+#define FIRST_ASID  0
+#define MAX_ASID    255			/* 8 bit PID field in PID Aux reg */
+#define NO_ASID     (MAX_ASID + 1)	/* ASID Not alloc to mmu ctxt */
+#define NUM_ASID    ((MAX_ASID - FIRST_ASID) + 1)
+
+/* ASID to mm struct mapping */
+extern struct mm_struct *asid_mm_map[NUM_ASID + 1];
+
+extern int asid_cache;
+
+/*
+ * Assign a new ASID to task. If the task already has an ASID, it is
+ * relinquished.
+ */
+static inline void get_new_mmu_context(struct mm_struct *mm)
+{
+	struct mm_struct *prev_owner;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	/*
+	 * Relinquish the currently owned ASID (if any).
+	 * Doing unconditionally saves a cmp-n-branch; for already unused
+	 * ASID slot, the value was/remains NULL
+	 */
+	asid_mm_map[mm->context.asid] = (struct mm_struct *)NULL;
+
+	/* move to new ASID */
+	if (++asid_cache > MAX_ASID) {	/* ASID roll-over */
+		asid_cache = FIRST_ASID;
+		flush_tlb_all();
+	}
+
+	/*
+	 * Is next ASID already owned by some-one else (we are stealing it).
+	 * If so, let the orig owner be aware of this, so when it runs, it
+	 * asks for a brand new ASID. This would only happen for a long-lived
+	 * task with ASID from prev allocation cycle (before ASID roll-over).
+	 *
+	 * This might look wrong - if we are re-using some other task's ASID,
+	 * won't we use it's stale TLB entries too. Actually switch_mm( ) takes
+	 * care of such a case: it ensures that task with ASID from prev alloc
+	 * cycle, when scheduled will refresh it's ASID: see switch_mm( ) below
+	 * The stealing scenario described here will only happen if that task
+	 * didn't get a chance to refresh it's ASID - implying stale entries
+	 * won't exist.
+	 */
+	prev_owner = asid_mm_map[asid_cache];
+	if (prev_owner)
+		prev_owner->context.asid = NO_ASID;
+
+	/* Assign new ASID to tsk */
+	asid_mm_map[asid_cache] = mm;
+	mm->context.asid = asid_cache;
+
+#ifdef CONFIG_ARC_TLB_DBG
+	pr_info("ARC_TLB_DBG: NewMM=0x%x OldMM=0x%x task_struct=0x%x Task: %s,"
+	       " pid:%u, assigned asid:%lu\n",
+	       (unsigned int)mm, (unsigned int)prev_owner,
+	       (unsigned int)(mm->context.tsk), (mm->context.tsk)->comm,
+	       (mm->context.tsk)->pid, mm->context.asid);
+#endif
+
+	write_aux_reg(ARC_REG_PID, asid_cache | MMU_ENABLE);
+
+	local_irq_restore(flags);
+}
+
+/*
+ * Initialize the context related info for a new mm_struct
+ * instance.
+ */
+static inline int
+init_new_context(struct task_struct *tsk, struct mm_struct *mm)
+{
+	mm->context.asid = NO_ASID;
+#ifdef CONFIG_ARC_TLB_DBG
+	mm->context.tsk = tsk;
+#endif
+	return 0;
+}
+
+/* Prepare the MMU for task: setup PID reg with allocated ASID
+    If task doesn't have an ASID (never alloc or stolen, get a new ASID)
+*/
+static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
+			     struct task_struct *tsk)
+{
+	/* PGD cached in MMU reg to avoid 3 mem lookups: task->mm->pgd */
+	write_aux_reg(ARC_REG_SCRATCH_DATA0, next->pgd);
+
+	/*
+	 * Get a new ASID if task doesn't have a valid one. Possible when
+	 *  -task never had an ASID (fresh after fork)
+	 *  -it's ASID was stolen - past an ASID roll-over.
+	 *  -There's a third obscure scenario (if this task is running for the
+	 *   first time afer an ASID rollover), where despite having a valid
+	 *   ASID, we force a get for new ASID - see comments at top.
+	 *
+	 * Both the non-alloc scenario and first-use-after-rollover can be
+	 * detected using the single condition below:  NO_ASID = 256
+	 * while asid_cache is always a valid ASID value (0-255).
+	 */
+	if (next->context.asid > asid_cache) {
+		get_new_mmu_context(next);
+	} else {
+		/*
+		 * XXX: This will never happen given the chks above
+		 * BUG_ON(next->context.asid > MAX_ASID);
+		 */
+		write_aux_reg(ARC_REG_PID, next->context.asid | MMU_ENABLE);
+	}
+
+}
+
+static inline void destroy_context(struct mm_struct *mm)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	asid_mm_map[mm->context.asid] = NULL;
+	mm->context.asid = NO_ASID;
+
+	local_irq_restore(flags);
+}
+
+/* it seemed that deactivate_mm( ) is a reasonable place to do book-keeping
+ * for retiring-mm. However destroy_context( ) still needs to do that because
+ * between mm_release( ) = >deactive_mm( ) and
+ * mmput => .. => __mmdrop( ) => destroy_context( )
+ * there is a good chance that task gets sched-out/in, making it's ASID valid
+ * again (this teased me for a whole day).
+ */
+#define deactivate_mm(tsk, mm)   do { } while (0)
+
+static inline void activate_mm(struct mm_struct *prev, struct mm_struct *next)
+{
+	write_aux_reg(ARC_REG_SCRATCH_DATA0, next->pgd);
+
+	/* Unconditionally get a new ASID */
+	get_new_mmu_context(next);
+
+}
+
+#define enter_lazy_tlb(mm, tsk)
+
+#endif /* __ASM_ARC_MMU_CONTEXT_H */
diff --git a/arch/arc/mm/tlb.c b/arch/arc/mm/tlb.c
new file mode 100644
index 0000000..f1edae2
--- /dev/null
+++ b/arch/arc/mm/tlb.c
@@ -0,0 +1,23 @@
+/*
+ * TLB Management (flush/create/diagnostics) for ARC700
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <asm/arcregs.h>
+#include <asm/mmu_context.h>
+#include <asm/tlb.h>
+
+/* A copy of the ASID from the PID reg is kept in asid_cache */
+int asid_cache = FIRST_ASID;
+
+/* ASID to mm struct mapping. We have one extra entry corresponding to
+ * NO_ASID to save us a compare when clearing the mm entry for old asid
+ * see get_new_mmu_context (asm-arc/mmu_context.h)
+ */
+struct mm_struct *asid_mm_map[NUM_ASID + 1];
-- 
1.7.4.1

