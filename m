Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617Ab2EOI5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:57:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:43201 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758515Ab2EOI5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:57:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="166449759"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, riel@redhat.com, luto@mit.edu, alex.shi@intel.com,
        avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, tj@kernel.org, oleg@redhat.com,
        axboe@kernel.dk, jmorris@namei.org, a.p.zijlstra@chello.nl,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com
Subject: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
Date: Tue, 15 May 2012 16:55:37 +0800
Message-Id: <1337072138-8323-7-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337072138-8323-1-git-send-email-alex.shi@intel.com>
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not every flush_tlb_mm execution moment is really need to evacuate all
TLB entries, like in munmap, just few 'invlpg' is better for whole
process performance, since it leaves most of TLB entries for later
accessing.

This patch is changing flush_tlb_mm(mm) to flush_tlb_mm(mm, start, end)
in cases.

The performance balance points checking is left in __flush_tlb_range()

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/tlb.h      |    2 +-
 arch/x86/include/asm/tlbflush.h |    5 +-
 arch/x86/mm/pgtable.c           |    2 +-
 arch/x86/mm/tlb.c               |  114 +++++++++++++++++++-------------------
 fs/proc/task_mmu.c              |    2 +-
 include/asm-generic/tlb.h       |    5 +-
 include/asm-generic/tlbflush.h  |    3 +-
 kernel/fork.c                   |    2 +-
 mm/memory.c                     |    9 ++--
 9 files changed, 74 insertions(+), 70 deletions(-)

diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 829215f..505fdfe 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -4,7 +4,7 @@
 #define tlb_start_vma(tlb, vma) do { } while (0)
 #define tlb_end_vma(tlb, vma) do { } while (0)
 #define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
-#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
+#define tlb_flush(tlb, start, end) flush_tlb_mm((tlb)->mm, start, end)
 
 #include <asm-generic/tlb.h>
 
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index c39c94e..1d07cf1 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -85,7 +85,8 @@ static inline void __flush_tlb_one(unsigned long addr)
 #define flush_tlb_all() __flush_tlb_all()
 #define local_flush_tlb() __flush_tlb()
 
-static inline void flush_tlb_mm(struct mm_struct *mm)
+static inline void flush_tlb_mm(struct mm_struct *mm,
+			unsigned long start, unsigned long end)
 {
 	if (mm == current->active_mm)
 		__flush_tlb();
@@ -124,7 +125,7 @@ static inline void reset_lazy_tlbstate(void)
 
 extern void flush_tlb_all(void);
 extern void flush_tlb_current_task(void);
-extern void flush_tlb_mm(struct mm_struct *);
+extern void flush_tlb_mm(struct mm_struct *, unsigned long, unsigned long);
 extern void flush_tlb_page(struct vm_area_struct *, unsigned long);
 extern void flush_tlb_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end);
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 8573b83..5aea5b0 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -168,7 +168,7 @@ void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
 	 * section 8.1: in PAE mode we explicitly have to flush the
 	 * TLB via cr3 if the top-level pgd is changed...
 	 */
-	flush_tlb_mm(mm);
+	flush_tlb_mm(mm, 0UL, -1UL);
 }
 #else  /* !CONFIG_X86_PAE */
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 5bf4e85..b2e25e8 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -298,22 +298,6 @@ void flush_tlb_current_task(void)
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
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline int has_large_page(struct mm_struct *mm,
 				 unsigned long start, unsigned long end)
@@ -343,61 +327,77 @@ static inline int has_large_page(struct mm_struct *mm,
 	return 0;
 }
 #endif
-void flush_tlb_range(struct vm_area_struct *vma,
-				   unsigned long start, unsigned long end)
-{
-	struct mm_struct *mm;
 
-	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB
-			|| tlb_flushall_shift == (u16)TLB_FLUSH_ALL) {
-flush_all:
-		flush_tlb_mm(vma->vm_mm);
-		return;
-	}
+void __flush_tlb_range(struct mm_struct *mm, unsigned long start,
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
+	if (end == TLB_FLUSH_ALL ||
+			tlb_flushall_shift == (u16)TLB_FLUSH_ALL) {
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
 
+void flush_tlb_mm(struct mm_struct *mm, unsigned long start, unsigned long end)
+{
+	if (!cpu_has_invlpg)
+		__flush_tlb_range(mm, 0UL, TLB_FLUSH_ALL, 0UL);
+	else
+		__flush_tlb_range(mm, start, end, 0UL);
+}
+
+void flush_tlb_range(struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long vmflag = vma->vm_flags;
+
+	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB)
+		__flush_tlb_range(mm, 0UL, TLB_FLUSH_ALL, 0UL);
+	else
+		__flush_tlb_range(mm, start, end, vmflag);
+}
+
 
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long start)
 {
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 2d60492..5728c8f 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -660,7 +660,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 			walk_page_range(vma->vm_start, vma->vm_end,
 					&clear_refs_walk);
 		}
-		flush_tlb_mm(mm);
+		flush_tlb_mm(mm, 0UL, -1UL);
 		up_read(&mm->mmap_sem);
 		mmput(mm);
 	}
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 75e888b..3a24c97 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -112,7 +112,8 @@ static inline int tlb_fast_mode(struct mmu_gather *tlb)
 }
 
 void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, bool fullmm);
-void tlb_flush_mmu(struct mmu_gather *tlb);
+void tlb_flush_mmu(struct mmu_gather *tlb, unsigned long start,
+							unsigned long end);
 void tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start,
 							unsigned long end);
 int __tlb_remove_page(struct mmu_gather *tlb, struct page *page);
@@ -124,7 +125,7 @@ int __tlb_remove_page(struct mmu_gather *tlb, struct page *page);
 static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
 	if (!__tlb_remove_page(tlb, page))
-		tlb_flush_mmu(tlb);
+		tlb_flush_mmu(tlb, 0UL, -1UL);
 }
 
 /**
diff --git a/include/asm-generic/tlbflush.h b/include/asm-generic/tlbflush.h
index d6d0a88..db1d4bb 100644
--- a/include/asm-generic/tlbflush.h
+++ b/include/asm-generic/tlbflush.h
@@ -11,7 +11,8 @@
 
 #include <linux/bug.h>
 
-static inline void flush_tlb_mm(struct mm_struct *mm)
+static inline void flush_tlb_mm(struct mm_struct *mm,
+			unsigned long start, unsigned long end)
 {
 	BUG();
 }
diff --git a/kernel/fork.c b/kernel/fork.c
index b9372a0..a4f0c64 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -427,7 +427,7 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	retval = 0;
 out:
 	up_write(&mm->mmap_sem);
-	flush_tlb_mm(oldmm);
+	flush_tlb_mm(oldmm, 0UL, -1UL);
 	up_write(&oldmm->mmap_sem);
 	return retval;
 fail_nomem_anon_vma_fork:
diff --git a/mm/memory.c b/mm/memory.c
index 6105f47..05e2c2e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -218,14 +218,15 @@ void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, bool fullmm)
 #endif
 }
 
-void tlb_flush_mmu(struct mmu_gather *tlb)
+void tlb_flush_mmu(struct mmu_gather *tlb,
+			unsigned long start, unsigned long end)
 {
 	struct mmu_gather_batch *batch;
 
 	if (!tlb->need_flush)
 		return;
 	tlb->need_flush = 0;
-	tlb_flush(tlb);
+	tlb_flush(tlb, start, end);
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	tlb_table_flush(tlb);
 #endif
@@ -248,7 +249,7 @@ void tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long e
 {
 	struct mmu_gather_batch *batch, *next;
 
-	tlb_flush_mmu(tlb);
+	tlb_flush_mmu(tlb, start, end);
 
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
@@ -1204,7 +1205,7 @@ again:
 	 */
 	if (force_flush) {
 		force_flush = 0;
-		tlb_flush_mmu(tlb);
+		tlb_flush_mmu(tlb, addr, end);
 		if (addr != end)
 			goto again;
 	}
-- 
1.7.5.4

