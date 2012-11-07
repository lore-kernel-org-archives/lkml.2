Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab2KGJ75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:59:57 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:52779 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab2KGJ72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:59:28 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 21/31] ARC: TLB flush Handling
Date: Wed,  7 Nov 2012 10:47:44 +0100
Message-Id: <1352281674-2186-22-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/tlb.h      |   17 ++
 arch/arc/include/asm/tlbflush.h |   28 ++++
 arch/arc/mm/tlb.c               |  311 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 356 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/tlbflush.h

diff --git a/arch/arc/include/asm/tlb.h b/arch/arc/include/asm/tlb.h
index b571e12..3eb2ce0 100644
--- a/arch/arc/include/asm/tlb.h
+++ b/arch/arc/include/asm/tlb.h
@@ -21,6 +21,23 @@
 
 #ifndef __ASSEMBLY__
 
+#define tlb_flush(tlb) local_flush_tlb_mm((tlb)->mm)
+
+/*
+ * This pair is called at time of munmap/exit to flush cache and TLB entries
+ * for mappings being torn down.
+ * 1) cache-flush part -implemented via tlb_start_vma( ) can be NOP (for now)
+ *    as we don't support aliasing configs in our VIPT D$.
+ * 2) tlb-flush part - implemted via tlb_end_vma( ) can be NOP as well-
+ *    albiet for difft reasons - its better handled by moving to new ASID
+ *
+ * Note, read http://lkml.org/lkml/2004/1/15/6
+ */
+#define tlb_start_vma(tlb, vma)
+#define tlb_end_vma(tlb, vma)
+
+#define __tlb_remove_tlb_entry(tlb, ptep, address)
+
 #include <linux/pagemap.h>
 #include <asm-generic/tlb.h>
 
diff --git a/arch/arc/include/asm/tlbflush.h b/arch/arc/include/asm/tlbflush.h
new file mode 100644
index 0000000..b2f9bc7
--- /dev/null
+++ b/arch/arc/include/asm/tlbflush.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARC_TLBFLUSH__
+#define __ASM_ARC_TLBFLUSH__
+
+#include <linux/mm.h>
+
+void local_flush_tlb_all(void);
+void local_flush_tlb_mm(struct mm_struct *mm);
+void local_flush_tlb_page(struct vm_area_struct *vma, unsigned long page);
+void local_flush_tlb_kernel_range(unsigned long start, unsigned long end);
+void local_flush_tlb_range(struct vm_area_struct *vma,
+			   unsigned long start, unsigned long end);
+
+/* XXX: Revisit for SMP */
+#define flush_tlb_range(vma, s, e)	local_flush_tlb_range(vma, s, e)
+#define flush_tlb_page(vma, page)	local_flush_tlb_page(vma, page)
+#define flush_tlb_kernel_range(s, e)	local_flush_tlb_kernel_range(s, e)
+#define flush_tlb_all()			local_flush_tlb_all()
+#define flush_tlb_mm(mm)		local_flush_tlb_mm(mm)
+
+#endif
diff --git a/arch/arc/mm/tlb.c b/arch/arc/mm/tlb.c
index 41afc84..c10111d 100644
--- a/arch/arc/mm/tlb.c
+++ b/arch/arc/mm/tlb.c
@@ -6,13 +6,97 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
+ *
+ * vineetg: Aug 2011
+ *  -Reintroduce duplicate PD fixup - some customer chips still have the issue
+ *
+ * vineetg: May 2011
+ *  -No need to flush_cache_page( ) for each call to update_mmu_cache()
+ *   some of the LMBench tests improved amazingly
+ *      = page-fault thrice as fast (75 usec to 28 usec)
+ *      = mmap twice as fast (9.6 msec to 4.6 msec),
+ *      = fork (5.3 msec to 3.7 msec)
+ *
+ * vineetg: April 2011 :
+ *  -MMU v3: PD{0,1} bits layout changed: They don't overlap anymore,
+ *      helps avoid a shift when preparing PD0 from PTE
+ *
+ * vineetg: April 2011 : Preparing for MMU V3
+ *  -MMU v2/v3 BCRs decoded differently
+ *  -Remove TLB_SIZE hardcoding as it's variable now: 256 or 512
+ *  -tlb_entry_erase( ) can be void
+ *  -local_flush_tlb_range( ):
+ *      = need not "ceil" @end
+ *      = walks MMU only if range spans < 32 entries, as opposed to 256
+ *
+ * Vineetg: Sept 10th 2008
+ *  -Changes related to MMU v2 (Rel 4.8)
+ *
+ * Vineetg: Aug 29th 2008
+ *  -In TLB Flush operations (Metal Fix MMU) there is a explict command to
+ *    flush Micro-TLBS. If TLB Index Reg is invalid prior to TLBIVUTLB cmd,
+ *    it fails. Thus need to load it with ANY valid value before invoking
+ *    TLBIVUTLB cmd
+ *
+ * Vineetg: Aug 21th 2008:
+ *  -Reduced the duration of IRQ lockouts in TLB Flush routines
+ *  -Multiple copies of TLB erase code seperated into a "single" function
+ *  -In TLB Flush routines, interrupt disabling moved UP to retrieve ASID
+ *       in interrupt-safe region.
+ *
+ * Vineetg: April 23rd Bug #93131
+ *    Problem: tlb_flush_kernel_range() doesnt do anything if the range to
+ *              flush is more than the size of TLB itself.
+ *
+ * Rahul Trivedi : Codito Technologies 2004
  */
 
 #include <linux/module.h>
 #include <asm/arcregs.h>
+#include <asm/setup.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
 
+/*			Need for ARC MMU v2
+ *
+ * ARC700 MMU-v1 had a Joint-TLB for Code and Data and is 2 way set-assoc.
+ * For a memcpy operation with 3 players (src/dst/code) such that all 3 pages
+ * map into same set, there would be contention for the 2 ways causing severe
+ * Thrashing.
+ *
+ * Although J-TLB is 2 way set assoc, ARC700 caches J-TLB into uTLBS which has
+ * much higher associativity. u-D-TLB is 8 ways, u-I-TLB is 4 ways.
+ * Given this, the thrasing problem should never happen because once the 3
+ * J-TLB entries are created (even though 3rd will knock out one of the prev
+ * two), the u-D-TLB and u-I-TLB will have what is required to accomplish memcpy
+ *
+ * Yet we still see the Thrashing because a J-TLB Write cause flush of u-TLBs.
+ * This is a simple design for keeping them in sync. So what do we do?
+ * The solution which James came up was pretty neat. It utilised the assoc
+ * of uTLBs by not invalidating always but only when absolutely necessary.
+ *
+ * - Existing TLB commands work as before
+ * - New command (TLBWriteNI) for TLB write without clearing uTLBs
+ * - New command (TLBIVUTLB) to invalidate uTLBs.
+ *
+ * The uTLBs need only be invalidated when pages are being removed from the
+ * OS page table. If a 'victim' TLB entry is being overwritten in the main TLB
+ * as a result of a miss, the removed entry is still allowed to exist in the
+ * uTLBs as it is still valid and present in the OS page table. This allows the
+ * full associativity of the uTLBs to hide the limited associativity of the main
+ * TLB.
+ *
+ * During a miss handler, the new "TLBWriteNI" command is used to load
+ * entries without clearing the uTLBs.
+ *
+ * When the OS page table is updated, TLB entries that may be associated with a
+ * removed page are removed (flushed) from the TLB using TLBWrite. In this
+ * circumstance, the uTLBs must also be cleared. This is done by using the
+ * existing TLBWrite command. An explicit IVUTLB is also required for those
+ * corner cases when TLBWrite was not executed at all because the corresp
+ * J-TLB entry got evicted/replaced.
+ */
+
 /* A copy of the ASID from the PID reg is kept in asid_cache */
 int asid_cache = FIRST_ASID;
 
@@ -22,6 +106,233 @@ int asid_cache = FIRST_ASID;
  */
 struct mm_struct *asid_mm_map[NUM_ASID + 1];
 
+/*
+ * Utility Routine to erase a J-TLB entry
+ * The procedure is to look it up in the MMU. If found, ERASE it by
+ *  issuing a TlbWrite CMD with PD0 = PD1 = 0
+ */
+
+static void __tlb_entry_erase(void)
+{
+	write_aux_reg(ARC_REG_TLBPD1, 0);
+	write_aux_reg(ARC_REG_TLBPD0, 0);
+	write_aux_reg(ARC_REG_TLBCOMMAND, TLBWrite);
+}
+
+static void tlb_entry_erase(unsigned int vaddr_n_asid)
+{
+	unsigned int idx;
+
+	/* Locate the TLB entry for this vaddr + ASID */
+	write_aux_reg(ARC_REG_TLBPD0, vaddr_n_asid);
+	write_aux_reg(ARC_REG_TLBCOMMAND, TLBProbe);
+	idx = read_aux_reg(ARC_REG_TLBINDEX);
+
+	/* No error means entry found, zero it out */
+	if (likely(!(idx & TLB_LKUP_ERR))) {
+		__tlb_entry_erase();
+	} else {		/* Some sort of Error */
+
+		/* Duplicate entry error */
+		if (idx & 0x1) {
+			/* TODO we need to handle this case too */
+			pr_emerg("unhandled Duplicate flush for %x\n",
+			       vaddr_n_asid);
+		}
+		/* else entry not found so nothing to do */
+	}
+}
+
+/****************************************************************************
+ * ARC700 MMU caches recently used J-TLB entries (RAM) as uTLBs (FLOPs)
+ *
+ * New IVUTLB cmd in MMU v2 explictly invalidates the uTLB
+ *
+ * utlb_invalidate ( )
+ *  -For v2 MMU calls Flush uTLB Cmd
+ *  -For v1 MMU does nothing (except for Metal Fix v1 MMU)
+ *      This is because in v1 TLBWrite itself invalidate uTLBs
+ ***************************************************************************/
+
+static void utlb_invalidate(void)
+{
+#if (CONFIG_ARC_MMU_VER >= 2)
+
+#if (CONFIG_ARC_MMU_VER < 3)
+	/* MMU v2 introduced the uTLB Flush command.
+	 * There was however an obscure hardware bug, where uTLB flush would
+	 * fail when a prior probe for J-TLB (both totally unrelated) would
+	 * return lkup err - because the entry didnt exist in MMU.
+	 * The Workround was to set Index reg with some valid value, prior to
+	 * flush. This was fixed in MMU v3 hence not needed any more
+	 */
+	unsigned int idx;
+
+	/* make sure INDEX Reg is valid */
+	idx = read_aux_reg(ARC_REG_TLBINDEX);
+
+	/* If not write some dummy val */
+	if (unlikely(idx & TLB_LKUP_ERR))
+		write_aux_reg(ARC_REG_TLBINDEX, 0xa);
+#endif
+
+	write_aux_reg(ARC_REG_TLBCOMMAND, TLBIVUTLB);
+#endif
+
+}
+
+/*
+ * Un-conditionally (without lookup) erase the entire MMU contents
+ */
+
+noinline void local_flush_tlb_all(void)
+{
+	unsigned long flags;
+	unsigned int entry;
+	struct cpuinfo_arc_mmu *mmu = &cpuinfo_arc700[smp_processor_id()].mmu;
+
+	local_irq_save(flags);
+
+	/* Load PD0 and PD1 with template for a Blank Entry */
+	write_aux_reg(ARC_REG_TLBPD1, 0);
+	write_aux_reg(ARC_REG_TLBPD0, 0);
+
+	for (entry = 0; entry < mmu->num_tlb; entry++) {
+		/* write this entry to the TLB */
+		write_aux_reg(ARC_REG_TLBINDEX, entry);
+		write_aux_reg(ARC_REG_TLBCOMMAND, TLBWrite);
+	}
+
+	utlb_invalidate();
+
+	local_irq_restore(flags);
+}
+
+/*
+ * Flush the entrie MM for userland. The fastest way is to move to Next ASID
+ */
+noinline void local_flush_tlb_mm(struct mm_struct *mm)
+{
+	/*
+	 * Small optimisation courtesy IA64
+	 * flush_mm called during fork,exit,munmap etc, multiple times as well.
+	 * Only for fork( ) do we need to move parent to a new MMU ctxt,
+	 * all other cases are NOPs, hence this check.
+	 */
+	if (atomic_read(&mm->mm_users) == 0)
+		return;
+
+	/*
+	 * Workaround for Android weirdism:
+	 * A binder VMA could end up in a task such that vma->mm != tsk->mm
+	 * old code would cause h/w - s/w ASID to get out of sync
+	 */
+	if (current->mm != mm)
+		destroy_context(mm);
+	else
+		get_new_mmu_context(mm);
+}
+
+/*
+ * Flush a Range of TLB entries for userland.
+ * @start is inclusive, while @end is exclusive
+ * Difference between this and Kernel Range Flush is
+ *  -Here the fastest way (if range is too large) is to move to next ASID
+ *      without doing any explicit Shootdown
+ *  -In case of kernel Flush, entry has to be shot down explictly
+ */
+void local_flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
+			   unsigned long end)
+{
+	unsigned long flags;
+	unsigned int asid;
+
+	/* If range @start to @end is more than 32 TLB entries deep,
+	 * its better to move to a new ASID rather than searching for
+	 * individual entries and then shooting them down
+	 *
+	 * The calc above is rough, doesn't account for unaligned parts,
+	 * since this is heuristics based anyways
+	 */
+	if (unlikely((end - start) >= PAGE_SIZE * 32)) {
+		local_flush_tlb_mm(vma->vm_mm);
+		return;
+	}
+
+	/*
+	 * @start moved to page start: this alone suffices for checking
+	 * loop end condition below, w/o need for aligning @end to end
+	 * e.g. 2000 to 4001 will anyhow loop twice
+	 */
+	start &= PAGE_MASK;
+
+	local_irq_save(flags);
+	asid = vma->vm_mm->context.asid;
+
+	if (asid != NO_ASID) {
+		while (start < end) {
+			tlb_entry_erase(start | (asid & 0xff));
+			start += PAGE_SIZE;
+		}
+	}
+
+	utlb_invalidate();
+
+	local_irq_restore(flags);
+}
+
+/* Flush the kernel TLB entries - vmalloc/modules (Global from MMU perspective)
+ *  @start, @end interpreted as kvaddr
+ * Interestingly, shared TLB entries can also be flushed using just
+ * @start,@end alone (interpreted as user vaddr), although technically SASID
+ * is also needed. However our smart TLbProbe lookup takes care of that.
+ */
+void local_flush_tlb_kernel_range(unsigned long start, unsigned long end)
+{
+	unsigned long flags;
+
+	/* exactly same as above, except for TLB entry not taking ASID */
+
+	if (unlikely((end - start) >= PAGE_SIZE * 32)) {
+		local_flush_tlb_all();
+		return;
+	}
+
+	start &= PAGE_MASK;
+
+	local_irq_save(flags);
+	while (start < end) {
+		tlb_entry_erase(start);
+		start += PAGE_SIZE;
+	}
+
+	utlb_invalidate();
+
+	local_irq_restore(flags);
+}
+
+/*
+ * Delete TLB entry in MMU for a given page (??? address)
+ * NOTE One TLB entry contains translation for single PAGE
+ */
+
+void local_flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
+{
+	unsigned long flags;
+
+	/* Note that it is critical that interrupts are DISABLED between
+	 * checking the ASID and using it flush the TLB entry
+	 */
+	local_irq_save(flags);
+
+	if (vma->vm_mm->context.asid != NO_ASID) {
+		tlb_entry_erase((page & PAGE_MASK) |
+				(vma->vm_mm->context.asid & 0xff));
+		utlb_invalidate();
+	}
+
+	local_irq_restore(flags);
+}
 
 /*
  * Routine to create a TLB entry
-- 
1.7.4.1

