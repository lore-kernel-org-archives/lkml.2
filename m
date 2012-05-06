Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab2EFC43 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 22:56:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:40548 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab2EFC41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 22:56:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="162473540"
Message-ID: <4FA5E82E.5010307@intel.com>
Date: Sun, 06 May 2012 10:55:42 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Nick Piggin <npiggin@gmail.com>, mgorman@suse.de
CC: Borislav Petkov <bp@amd64.org>, andi.kleen@intel.com,
        tim.c.chen@linux.intel.com, jeremy@goop.org, chrisw@sous-sol.org,
        akataria@vmware.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rostedt@goodmis.org, fweisbec@gmail.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        paul.gortmaker@windriver.com, dhowells@redhat.com,
        fenghua.yu@intel.com, yinghai@kernel.org, cpw@sgi.com, steiner@sgi.com,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com
Subject: Re: [PATCH 2/3] x86/flush_tlb: try flush_tlb_single one by one in
 flush_tlb_range
References: <1335603099-2624-1-git-send-email-alex.shi@intel.com> <1335603099-2624-3-git-send-email-alex.shi@intel.com> <20120430105440.GC9303@aftab.osrc.amd.com> <4FA0FD39.9060908@intel.com> <20120502093815.GB12914@aftab.osrc.amd.com> <4FA11CC7.5040302@intel.com> <CAPa8GCDhGfuYEemdsnUZwh=O6Nco1PH1JgiruvWw3400yz9S8w@mail.gmail.com>
In-Reply-To: <CAPa8GCDhGfuYEemdsnUZwh=O6Nco1PH1JgiruvWw3400yz9S8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>
>> I tested oltp reading and specjbb2005 with openjdk. They should not much
>> flush_tlb_range calling. So, no clear improvement.
>> Do you know benchmarks which cause enough flush_tlb_range?
> 
> x86 does not do such invlpg flushing for munmap either, as far as I
> can see?
> 
> It would be a little more work to make this happen, but it might show
> more benefit, provided glibc does not free too huge chunks at once,
> it should apply far more often.




I enabled invlpg for munmap and zap_page_range base on v2 of this patchset.
but still haven't find clear performance increase for benchmarks: 
specjbb2005/kbuild/hackbench/netperf-loop/oltp/fileio etc. with THP always.

Does anyone know some benchmark has much munmap?

---------

>From 7a4bbd1a5fdde396556fd40d9899e737d71f5a3c Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Sat, 5 May 2012 12:04:00 +0800
Subject: [PATCH 6/6] x86/tlb: optimizing munmap.
a rough patch of changing flush_tlb_mm(mm), to flush_tlb_mm(mm, start, end)

---
 arch/x86/include/asm/tlb.h      |    2 +-
 arch/x86/include/asm/tlbflush.h |    5 ++-
 arch/x86/mm/pgtable.c           |    2 +-
 arch/x86/mm/tlb.c               |   74 +++++++++++++++++---------------------
 fs/proc/task_mmu.c              |    2 +-
 include/asm-generic/tlb.h       |    4 +-
 include/asm-generic/tlbflush.h  |    3 +-
 kernel/fork.c                   |    2 +-
 mm/memory.c                     |   11 ++++--
 9 files changed, 51 insertions(+), 54 deletions(-)

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
index 51f8b1c..d1baeac 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -89,7 +89,8 @@ static inline void __flush_tlb_one(unsigned long addr)
 #define flush_tlb_all() __flush_tlb_all()
 #define local_flush_tlb() __flush_tlb()
 
-static inline void flush_tlb_mm(struct mm_struct *mm)
+static inline void flush_tlb_mm(struct mm_struct *mm,
+			unsigned long start, unsigned long end)
 {
 	if (mm == current->active_mm)
 		__flush_tlb();
@@ -128,7 +129,7 @@ static inline void reset_lazy_tlbstate(void)
 
 extern void flush_tlb_all(void);
 extern void flush_tlb_current_task(void);
-extern void flush_tlb_mm(struct mm_struct *);
+extern void flush_tlb_mm(struct mm_struct *, unsigned long, unsigned long);
 extern void flush_tlb_page(struct vm_area_struct *, unsigned long);
 extern void flush_tlb_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end);
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 8573b83..204221c 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -168,7 +168,7 @@ void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
 	 * section 8.1: in PAE mode we explicitly have to flush the
 	 * TLB via cr3 if the top-level pgd is changed...
 	 */
-	flush_tlb_mm(mm);
+	flush_tlb_mm(mm, 0, -1);
 }
 #else  /* !CONFIG_X86_PAE */
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 91896dc..5f9a327 100644
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
-		flush_tlb_others(mm_cpumask(mm), mm, TLB_FLUSH_ALL, 0UL);
-
-	preempt_enable();
-}
-
 static inline int has_large_page(struct mm_struct *mm,
 				 unsigned long start, unsigned long end)
 {
@@ -336,39 +320,27 @@ static inline int has_large_page(struct mm_struct *mm,
 	return 0;
 }
 
-void flush_tlb_range(struct vm_area_struct *vma,
-				   unsigned long start, unsigned long end)
+void __flush_tlb_range(struct mm_struct *mm, unsigned long start,
+				unsigned long end, unsigned long vmflag)
 {
-	struct mm_struct *mm;
-
-	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB
-				|| !tlb_flushall_factor) {
-flush_all:
-		flush_tlb_mm(vma->vm_mm);
-		return;
-	}
-
 	preempt_disable();
-	mm = vma->vm_mm;
 	if (current->active_mm == mm) {
 		if (current->mm) {
-			unsigned long addr, vmflag = vma->vm_flags;
-			unsigned act_entries, tlb_entries = 0;
-
-			if (vmflag & VM_EXEC)
-				tlb_entries = tlb_lli_4k[ENTRIES];
-			else
-				tlb_entries = tlb_lld_4k[ENTRIES];
-
-			act_entries = tlb_entries > mm->total_vm ?
-					mm->total_vm : tlb_entries;
-
-			if ((end - start)/PAGE_SIZE >
+			if ( start == 0 || (end - start)/PAGE_SIZE >
 					act_entries/tlb_flushall_factor)
 				local_flush_tlb();
 			else {
+				unsigned long addr;
+				unsigned long act_entries, tlb_entries = 0;
+
+				if (vmflag & VM_EXEC)
+					tlb_entries = tlb_lli_4k[ENTRIES];
+				else
+					tlb_entries = tlb_lld_4k[ENTRIES];
+				act_entries = min(mm->total_vm, tlb_entries);
+
 				if (has_large_page(mm, start, end)) {
-					preempt_enable();
+					local_flush_tlb();
 					goto flush_all;
 				}
 				for (addr = start; addr <= end;
@@ -386,11 +358,31 @@ flush_all:
 			leave_mm(smp_processor_id());
 		}
 	}
+
+flush_all:
 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
 		flush_tlb_others(mm_cpumask(mm), mm, TLB_FLUSH_ALL, 0UL);
 	preempt_enable();
 }
 
+void flush_tlb_mm(struct mm_struct *mm, unsigned long start, unsigned long end)
+{
+	__flush_tlb_range(mm, start, end, 0UL);
+}
+
+void flush_tlb_range(struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long vmflag = vma->vm_flags;
+
+	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB
+				|| !tlb_flushall_factor)
+		__flush_tlb_range(mm, 0UL, -1UL, 0);
+	else
+		__flush_tlb_range(mm, start, end, vmflag);
+}
+
 
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long start)
 {
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 2d60492..b2c9659 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -660,7 +660,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 			walk_page_range(vma->vm_start, vma->vm_end,
 					&clear_refs_walk);
 		}
-		flush_tlb_mm(mm);
+		flush_tlb_mm(mm, 0, -1);
 		up_read(&mm->mmap_sem);
 		mmput(mm);
 	}
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index f96a5b5..24e205d 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -112,7 +112,7 @@ static inline int tlb_fast_mode(struct mmu_gather *tlb)
 }
 
 void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, bool fullmm);
-void tlb_flush_mmu(struct mmu_gather *tlb);
+void tlb_flush_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end);
 void tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end);
 int __tlb_remove_page(struct mmu_gather *tlb, struct page *page);
 
@@ -123,7 +123,7 @@ int __tlb_remove_page(struct mmu_gather *tlb, struct page *page);
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
index b9372a0..0e895e8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -427,7 +427,7 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	retval = 0;
 out:
 	up_write(&mm->mmap_sem);
-	flush_tlb_mm(oldmm);
+	flush_tlb_mm(oldmm, 0, -1);
 	up_write(&oldmm->mmap_sem);
 	return retval;
 fail_nomem_anon_vma_fork:
diff --git a/mm/memory.c b/mm/memory.c
index 6105f47..c25c9ea 100644
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
@@ -396,6 +397,8 @@ void pmd_clear_bad(pmd_t *pmd)
  * Note: this doesn't free the actual pages themselves. That
  * has been handled earlier when unmapping all the memory regions.
  */
+// pte_free_tlb -> tlb_remove_page -> tlb_flush_mmu
+// that may cause too much tlb flushing. alex
 static void free_pte_range(struct mmu_gather *tlb, pmd_t *pmd,
 			   unsigned long addr)
 {
@@ -1204,7 +1207,7 @@ again:
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

