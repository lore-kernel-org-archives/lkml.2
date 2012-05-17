Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab2EQFqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 01:46:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:19232 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270Ab2EQFpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 01:45:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="141548882"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, riel@redhat.com, luto@mit.edu, alex.shi@intel.com,
        avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, a.p.zijlstra@chello.nl,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com
Subject: [PATCH v6 6/7] x86/tlb: enable tlb flush range support for generic mmu on x86
Date: Thu, 17 May 2012 13:42:54 +0800
Message-Id: <1337233375-840-7-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337233375-840-1-git-send-email-alex.shi@intel.com>
References: <1337233375-840-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not every tlb_flush execution moment is really need to evacuate all
TLB entries, like in munmap, just few 'invlpg' is better for whole
process performance, since it leaves most of TLB entries for later
accessing.

All of tlb interfaces in mm/memory.c are reused by all architectures
except few of them for generic mmu_gather were protected under
HAVE_GENERIC_MMU_GATHER. So, for x86, just re-implement 'tlb_flush'
is enough.

This patch also rewrite flush_tlb_range for 2 purposes:
1, split it out to get flush_blt_mm_range function.
2, clean up to reduce line breaking, thanks for Borislav's input.

Thanks for Peter Zijlstra time and time reminder for multiple
architecture code safe!

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/tlb.h      |    9 +++-
 arch/x86/include/asm/tlbflush.h |    9 +++
 arch/x86/mm/tlb.c               |  117 ++++++++++++++++++---------------------
 include/asm-generic/tlb.h       |    2 +
 mm/memory.c                     |    9 +++
 5 files changed, 81 insertions(+), 65 deletions(-)

diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 829215f..4fef207 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -4,7 +4,14 @@
 #define tlb_start_vma(tlb, vma) do { } while (0)
 #define tlb_end_vma(tlb, vma) do { } while (0)
 #define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
-#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
+
+#define tlb_flush(tlb)							\
+{									\
+	if (tlb->fullmm == 0)						\
+		flush_tlb_mm_range(tlb->mm, tlb->start, tlb->end, 0UL);	\
+	else								\
+		flush_tlb_mm_range(tlb->mm, 0UL, TLB_FLUSH_ALL, 0UL);	\
+}
 
 #include <asm-generic/tlb.h>
 
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index c39c94e..1562ed0 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -105,6 +105,13 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
 		__flush_tlb();
 }
 
+static inline void flush_tlb_mm_range(struct vm_area_struct *vma,
+	   unsigned long start, unsigned long end, unsigned long vmflag)
+{
+	if (mm == current->active_mm)
+		__flush_tlb();
+}
+
 static inline void native_flush_tlb_others(const struct cpumask *cpumask,
 					   struct mm_struct *mm,
 					   unsigned long start,
@@ -128,6 +135,8 @@ extern void flush_tlb_mm(struct mm_struct *);
 extern void flush_tlb_page(struct vm_area_struct *, unsigned long);
 extern void flush_tlb_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end);
+extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
+				unsigned long end, unsigned long vmflag);
 
 #define flush_tlb()	flush_tlb_current_task()
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index aef0621..87c68e0 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -298,23 +298,6 @@ void flush_tlb_current_task(void)
 	preempt_enable();
 }
 
-void flush_tlb_mm(struct mm_struct *mm)
-{
-	preempt_disable();
-
-	if (current->active_mm == mm) {
-		if (current->mm)
-			local_flush_tlb();
-		else
-			leave_mm(smp_processor_id());
-	}
-	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
-		flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);
-
-	preempt_enable();
-}
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline int has_large_page(struct mm_struct *mm,
 				 unsigned long start, unsigned long end)
 {
@@ -336,67 +319,73 @@ static inline int has_large_page(struct mm_struct *mm,
 	}
 	return 0;
 }
-#else
-static inline int has_large_page(struct mm_struct *mm,
-				 unsigned long start, unsigned long end)
-{
-	return 0;
-}
-#endif
-void flush_tlb_range(struct vm_area_struct *vma,
-				   unsigned long start, unsigned long end)
-{
-	struct mm_struct *mm;
 
-	if (vma->vm_flags & VM_HUGETLB || tlb_flushall_shift == -1 ) {
-flush_all:
-		flush_tlb_mm(vma->vm_mm);
-		return;
-	}
+void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
+				unsigned long end, unsigned long vmflag)
+{
+	unsigned long addr;
+	unsigned act_entries, tlb_entries = 0;
 
 	preempt_disable();
-	mm = vma->vm_mm;
-	if (current->active_mm == mm) {
-		if (current->mm) {
-			unsigned long addr, vmflag = vma->vm_flags;
-			unsigned act_entries, tlb_entries = 0;
+	if (current->active_mm != mm)
+		goto flush_all;
 
-			if (vmflag & VM_EXEC)
-				tlb_entries = tlb_lli_4k[ENTRIES];
-			else
-				tlb_entries = tlb_lld_4k[ENTRIES];
+	if (!current->mm) {
+		leave_mm(smp_processor_id());
+		goto flush_all;
+	}
 
-			act_entries = tlb_entries > mm->total_vm ?
-					mm->total_vm : tlb_entries;
+	if (end == TLB_FLUSH_ALL || tlb_flushall_shift == -1) {
+		local_flush_tlb();
+		goto flush_all;
+	}
 
-			if ((end - start) >> PAGE_SHIFT >
-					act_entries >> tlb_flushall_shift)
-				local_flush_tlb();
-			else {
-				if (has_large_page(mm, start, end)) {
-					preempt_enable();
-					goto flush_all;
-				}
-				for (addr = start; addr <= end;
-						addr += PAGE_SIZE)
-					__flush_tlb_single(addr);
+	if (vmflag & VM_EXEC)
+		tlb_entries = tlb_lli_4k[ENTRIES];
+	else
+		tlb_entries = tlb_lld_4k[ENTRIES];
+	act_entries = mm->total_vm > tlb_entries ? tlb_entries : mm->total_vm;
 
-				if (cpumask_any_but(mm_cpumask(mm),
-					smp_processor_id()) < nr_cpu_ids)
-					flush_tlb_others(mm_cpumask(mm), mm,
-								start, end);
-				preempt_enable();
-				return;
-			}
-		} else {
-			leave_mm(smp_processor_id());
+	if ((end - start) >> PAGE_SHIFT > act_entries >> tlb_flushall_shift)
+		local_flush_tlb();
+	else {
+		if (has_large_page(mm, start, end)) {
+			local_flush_tlb();
+			goto flush_all;
 		}
+		for (addr = start; addr <= end;	addr += PAGE_SIZE)
+			__flush_tlb_single(addr);
+
+		if (cpumask_any_but(mm_cpumask(mm),
+				smp_processor_id()) < nr_cpu_ids)
+			flush_tlb_others(mm_cpumask(mm), mm, start, end);
+		preempt_enable();
+		return;
 	}
+
+flush_all:
 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
 		flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);
 	preempt_enable();
 }
 
+void flush_tlb_mm(struct mm_struct *mm)
+{
+	flush_tlb_mm_range(mm, 0UL, TLB_FLUSH_ALL, 0UL);
+}
+
+void flush_tlb_range(struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long vmflag = vma->vm_flags;
+
+	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB)
+		flush_tlb_mm_range(mm, 0UL, TLB_FLUSH_ALL, 0UL);
+	else
+		flush_tlb_mm_range(mm, start, end, vmflag);
+}
+
 
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long start)
 {
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 75e888b..ed6642a 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -86,6 +86,8 @@ struct mmu_gather {
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	struct mmu_table_batch	*batch;
 #endif
+	unsigned long		start;
+	unsigned long		end;
 	unsigned int		need_flush : 1,	/* Did free PTEs */
 				fast_mode  : 1; /* No batching   */
 
diff --git a/mm/memory.c b/mm/memory.c
index 6105f47..a1078af 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -206,6 +206,8 @@ void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, bool fullmm)
 	tlb->mm = mm;
 
 	tlb->fullmm     = fullmm;
+	tlb->start	= -1UL;
+	tlb->end	= 0;
 	tlb->need_flush = 0;
 	tlb->fast_mode  = (num_possible_cpus() == 1);
 	tlb->local.next = NULL;
@@ -248,6 +250,8 @@ void tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long e
 {
 	struct mmu_gather_batch *batch, *next;
 
+	tlb->start = start;
+	tlb->end   = end;
 	tlb_flush_mmu(tlb);
 
 	/* keep the page table cache within bounds */
@@ -1204,6 +1208,11 @@ again:
 	 */
 	if (force_flush) {
 		force_flush = 0;
+
+#ifdef HAVE_GENERIC_MMU_GATHER
+		tlb->start = addr;
+		tlb->end = end;
+#endif
 		tlb_flush_mmu(tlb);
 		if (addr != end)
 			goto again;
-- 
1.7.5.4

