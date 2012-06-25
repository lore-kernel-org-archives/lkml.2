Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab2FYGLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 02:11:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:27904 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab2FYGLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 02:11:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="162133213"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, alex.shi@intel.com, luto@mit.edu, yinghai@kernel.org,
        riel@redhat.com, avi@redhat.com, len.brown@intel.com, tj@kernel.org,
        akpm@linux-foundation.org, cl@gentwo.org, borislav.petkov@amd.com,
        ak@linux.intel.com, jbeulich@suse.com, eric.dumazet@gmail.com,
        akinobu.mita@gmail.com, vapier@gentoo.org, cpw@sgi.com,
        steiner@sgi.com, viro@zeniv.linux.org.uk,
        kamezawa.hiroyu@jp.fujitsu.com, rientjes@google.com,
        aarcange@redhat.com, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com
Subject: [PATCH v9 7/9] x86/tlb: enable tlb flush range support for x86
Date: Mon, 25 Jun 2012 14:08:25 +0800
Message-Id: <1340604507-11214-8-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340604507-11214-1-git-send-email-alex.shi@intel.com>
References: <1340604507-11214-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not every tlb_flush execution moment is really need to evacuate all
TLB entries, like in munmap, just few 'invlpg' is better for whole
process performance, since it leaves most of TLB entries for later
accessing.

This patch also rewrite flush_tlb_range for 2 purposes:
1, split it out to get flush_blt_mm_range function.
2, clean up to reduce line breaking, thanks for Borislav's input.

My macro benchmark 'mummap' http://lkml.org/lkml/2012/5/17/59
show that the random memory access on other CPU has 0~50% speed up
on a 2P * 4cores * HT NHM EP while do 'munmap'.

Thanks Yongjie's testing on this patch:
-------------
I used Linux 3.4-RC6 w/ and w/o his patches as Xen dom0 and guest
kernel.
After running two benchmarks in Xen HVM guest, I found his patches
brought about 1%~3% performance gain in 'kernel build' and 'netperf'
testing, though the performance gain was not very stable in 'kernel
build' testing.

Some detailed testing results are below.

Testing Environment:
	Hardware: Romley-EP platform
	Xen version: latest upstream
	Linux kernel: 3.4-RC6
	Guest vCPU number: 8
	NIC: Intel 82599 (10GB bandwidth)

In 'kernel build' testing in guest:
	Command line  |  performance gain
    make -j 4      |    3.81%
    make -j 8      |    0.37%
    make -j 16     |    -0.52%

In 'netperf' testing, we tested TCP_STREAM with default socket size
16384 byte as large packet and 64 byte as small packet.
I used several clients to add networking pressure, then 'netperf' server
automatically generated several threads to response them.
I also used large-size packet and small-size packet in the testing.
	Packet size  |  Thread number | performance gain
	16384 bytes  |      4       |   0.02%
	16384 bytes  |      8       |   2.21%
	16384 bytes  |      16      |   2.04%
	64 bytes     |      4       |   1.07%
	64 bytes     |      8       |   3.31%
	64 bytes     |      16      |   0.71%

Signed-off-by: Alex Shi <alex.shi@intel.com>
Tested-by: Ren, Yongjie <yongjie.ren@intel.com>
---
 arch/x86/include/asm/tlb.h      |    9 +++-
 arch/x86/include/asm/tlbflush.h |   17 +++++-
 arch/x86/mm/tlb.c               |  112 ++++++++++++++++-----------------------
 3 files changed, 68 insertions(+), 70 deletions(-)

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
index 33608d9..008043d 100644
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
@@ -122,12 +129,16 @@ static inline void reset_lazy_tlbstate(void)
 
 #define local_flush_tlb() __flush_tlb()
 
+#define flush_tlb_mm(mm)	flush_tlb_mm_range(mm, 0UL, TLB_FLUSH_ALL, 0UL)
+
+#define flush_tlb_range(vma, start, end)	\
+		flush_tlb_mm_range(vma->vm_mm, start, end, vma->vm_flags)
+
 extern void flush_tlb_all(void);
 extern void flush_tlb_current_task(void);
-extern void flush_tlb_mm(struct mm_struct *);
 extern void flush_tlb_page(struct vm_area_struct *, unsigned long);
-extern void flush_tlb_range(struct vm_area_struct *vma,
-				   unsigned long start, unsigned long end);
+extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
+				unsigned long end, unsigned long vmflag);
 
 #define flush_tlb()	flush_tlb_current_task()
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 5911f61..481737d 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -301,23 +301,10 @@ void flush_tlb_current_task(void)
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
+/*
+ * It can find out the THP large page, or
+ * HUGETLB page in tlb_flush when THP disabled
+ */
 static inline unsigned long has_large_page(struct mm_struct *mm,
 				 unsigned long start, unsigned long end)
 {
@@ -339,68 +326,61 @@ static inline unsigned long has_large_page(struct mm_struct *mm,
 	}
 	return 0;
 }
-#else
-static inline unsigned long has_large_page(struct mm_struct *mm,
-				 unsigned long start, unsigned long end)
-{
-	return 0;
-}
-#endif
-void flush_tlb_range(struct vm_area_struct *vma,
-				   unsigned long start, unsigned long end)
-{
-	struct mm_struct *mm;
 
-	if (vma->vm_flags & VM_HUGETLB || tlb_flushall_shift == -1) {
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
-
-			act_entries = tlb_entries > mm->total_vm ?
-					mm->total_vm : tlb_entries;
+	if (!current->mm) {
+		leave_mm(smp_processor_id());
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
-				for (addr = start; addr < end;
-						addr += PAGE_SIZE)
-					__flush_tlb_single(addr);
+	if (end == TLB_FLUSH_ALL || tlb_flushall_shift == -1
+					|| vmflag == VM_HUGETLB) {
+		local_flush_tlb();
+		goto flush_all;
+	}
 
-				if (cpumask_any_but(mm_cpumask(mm),
-					smp_processor_id()) < nr_cpu_ids)
-					flush_tlb_others(mm_cpumask(mm), mm,
-								start, end);
-				preempt_enable();
-				return;
-			}
-		} else {
-			leave_mm(smp_processor_id());
+	/* In modern CPU, last level tlb used for both data/ins */
+	if (vmflag & VM_EXEC)
+		tlb_entries = tlb_lli_4k[ENTRIES];
+	else
+		tlb_entries = tlb_lld_4k[ENTRIES];
+	/* Assume all of TLB entries was occupied by this task */
+	act_entries = mm->total_vm > tlb_entries ? tlb_entries : mm->total_vm;
+
+	/* tlb_flushall_shift is on balance point, details in commit log */
+	if ((end - start) >> PAGE_SHIFT > act_entries >> tlb_flushall_shift)
+		local_flush_tlb();
+	else {
+		if (has_large_page(mm, start, end)) {
+			local_flush_tlb();
+			goto flush_all;
 		}
+		/* flush range by one by one 'invlpg' */
+		for (addr = start; addr < end;	addr += PAGE_SIZE)
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
 
-
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long start)
 {
 	struct mm_struct *mm = vma->vm_mm;
-- 
1.7.5.4

