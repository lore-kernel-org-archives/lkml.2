Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254Ab2EPGsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:48:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:26050 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759140Ab2EPGsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:48:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="143766841"
Message-ID: <4FB34D49.1060809@intel.com>
Date: Wed, 16 May 2012 14:46:33 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Nick Piggin <npiggin@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        borislav.petkov@amd.com, yinghai@kernel.org, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk, jmorris@namei.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>  <1337072138-8323-7-git-send-email-alex.shi@intel.com>  <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>  <4FB2590C.1050303@intel.com> <1337092577.27694.45.camel@twins> <1337093840.27694.56.camel@twins>
In-Reply-To: <1337093840.27694.56.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 10:57 PM, Peter Zijlstra wrote:

> On Tue, 2012-05-15 at 16:36 +0200, Peter Zijlstra wrote:
>> On Tue, 2012-05-15 at 21:24 +0800, Alex Shi wrote:
>>
>>> Sorry. I don't understand what's the comments Peter's made days ago. I should ask for more details originally. 
>>>
>>> So, Peter, the correct change should like following, am I right?
>>>
>>> -#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
>>> +#define tlb_flush(tlb, start, end) __flush_tlb_range((tlb)->mm, start, end)
>>
>> No.. the correct change is to do range tracking like the other archs
>> that support flush_tlb_range() do.
>>
>> You do not modify the tlb interface.
>>
>> Again, see: http://marc.info/?l=linux-arch&m=129952026504268&w=2
> 
> Just to be _very_ clear, you do not modify:
> 
>  mm/memory.c                     |    9 ++--
>  kernel/fork.c                   |    2 +-   
>  fs/proc/task_mmu.c              |    2 +-
> 
> As it stands your patch breaks compilation on a whole bunch of
> architectures.
> 
> If you touch the TLB interface, you get to touch _ALL_ architectures.



Thanks for Nick and Peter's comments. I rewrite the patch according to
your opinions. Is this met your expectation? 

----
>From a01864af75d8c86668f4fa73d6ca18ebe5835b18 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Mon, 14 May 2012 09:17:03 +0800
Subject: [PATCH 6/7] x86/tlb: optimizing tlb_finish_mmu on x86

Not every tlb_flush execution moment is really need to evacuate all
TLB entries, like in munmap, just few 'invlpg' is better for whole
process performance, since it leaves most of TLB entries for later
accessing.

Thanks for Peter Zijlstra reminder, tlb interfaces in mm/memory.c
are for all architectures. So, I keep current interfaces, just
reimplement x86 specific 'tlb_flush' only. Some of ideas also are
picked up from Peter's old patch, thanks!

This patch also rewrite flush_tlb_range for 2 purposes:
1, split it out to get flush_blt_mm_range function.
2, clean up to reduce line breaking, thanks for Borislav's input.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/tlb.h      |    9 +++-
 arch/x86/include/asm/tlbflush.h |    2 +
 arch/x86/mm/tlb.c               |  120 +++++++++++++++++++++------------------
 include/asm-generic/tlb.h       |    2 +
 mm/memory.c                     |    6 ++
 5 files changed, 82 insertions(+), 57 deletions(-)

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
index c39c94e..0107f3c 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -128,6 +128,8 @@ extern void flush_tlb_mm(struct mm_struct *);
 extern void flush_tlb_page(struct vm_area_struct *, unsigned long);
 extern void flush_tlb_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end);
+extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
+				unsigned long end, unsigned long vmflag);
 
 #define flush_tlb()	flush_tlb_current_task()
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 5bf4e85..52f6a5a 100644
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
@@ -343,61 +327,85 @@ static inline int has_large_page(struct mm_struct *mm,
 	return 0;
 }
 #endif
-void flush_tlb_range(struct vm_area_struct *vma,
-				   unsigned long start, unsigned long end)
+
+void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
+				unsigned long end, unsigned long vmflag)
 {
-	struct mm_struct *mm;
+	unsigned long addr;
+	unsigned act_entries, tlb_entries = 0;
 
-	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB
-			|| tlb_flushall_shift == (u16)TLB_FLUSH_ALL) {
-flush_all:
-		flush_tlb_mm(vma->vm_mm);
-		return;
+	preempt_disable();
+	if (current->active_mm != mm)
+		goto flush_all;
+
+	if (!current->mm) {
+		leave_mm(smp_processor_id());
+		goto flush_all;
 	}
 
-	preempt_disable();
-	mm = vma->vm_mm;
-	if (current->active_mm == mm) {
-		if (current->mm) {
-			unsigned long addr, vmflag = vma->vm_flags;
-			unsigned act_entries, tlb_entries = 0;
+	if (end == TLB_FLUSH_ALL ||
+			tlb_flushall_shift == (u16)TLB_FLUSH_ALL) {
+		local_flush_tlb();
+		goto flush_all;
+	}
 
-			if (vmflag & VM_EXEC)
-				tlb_entries = tlb_lli_4k[ENTRIES];
-			else
-				tlb_entries = tlb_lld_4k[ENTRIES];
+	if (vmflag & VM_EXEC)
+		tlb_entries = tlb_lli_4k[ENTRIES];
+	else
+		tlb_entries = tlb_lld_4k[ENTRIES];
+	act_entries = mm->total_vm > tlb_entries ? tlb_entries : mm->total_vm;
 
-			act_entries = tlb_entries > mm->total_vm ?
-					mm->total_vm : tlb_entries;
+	if ((end - start) >> PAGE_SHIFT > act_entries >> tlb_flushall_shift)
+		local_flush_tlb();
+	else {
+		if (has_large_page(mm, start, end)) {
+			local_flush_tlb();
+			goto flush_all;
+		}
+		for (addr = start; addr <= end;	addr += PAGE_SIZE)
+			__flush_tlb_single(addr);
 
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
+		if (cpumask_any_but(mm_cpumask(mm),
+				smp_processor_id()) < nr_cpu_ids)
+			flush_tlb_others(mm_cpumask(mm), mm, start, end);
+		preempt_enable();
+		return;
+	}
 
-				if (cpumask_any_but(mm_cpumask(mm),
-					smp_processor_id()) < nr_cpu_ids)
-					flush_tlb_others(mm_cpumask(mm), mm,
-								start, end);
-				preempt_enable();
-				return;
-			}
-		} else {
+flush_all:
+	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);
+	preempt_enable();
+}
+
+void flush_tlb_mm(struct mm_struct *mm)
+{
+	preempt_disable();
+
+	if (current->active_mm == mm) {
+		if (current->mm)
+			local_flush_tlb();
+		else
 			leave_mm(smp_processor_id());
-		}
 	}
 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
 		flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);
+
 	preempt_enable();
 }
 
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
index 6105f47..b176172 100644
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
@@ -1204,6 +1208,8 @@ again:
 	 */
 	if (force_flush) {
 		force_flush = 0;
+		tlb->start = addr;
+		tlb->end = end;
 		tlb_flush_mmu(tlb);
 		if (addr != end)
 			goto again;
-- 
1.7.5.4


