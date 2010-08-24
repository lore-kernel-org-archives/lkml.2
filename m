Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab0HXPRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:17:51 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:45340 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab0HXPRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:17:50 -0400
Date: Tue, 24 Aug 2010 17:17:46 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.36-rc2
Message-ID: <20100824171746.7a8f3f67@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Martin Schwidefsky (1):
      [S390] fix tlb flushing vs. concurrent /proc accesses

Sebastian Ott (1):
      [S390] s390: fix build error (sys_execve)

 arch/s390/include/asm/hugetlb.h     |    4 +++-
 arch/s390/include/asm/mmu.h         |    2 ++
 arch/s390/include/asm/mmu_context.h |    9 +++++++++
 arch/s390/include/asm/pgtable.h     |    6 ++++--
 arch/s390/include/asm/tlb.h         |    3 +--
 arch/s390/include/asm/tlbflush.h    |    6 +++++-
 arch/s390/kernel/entry.h            |    4 ++--
 arch/s390/kernel/smp.c              |    2 ++
 arch/s390/mm/init.c                 |    2 ++
 9 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/hugetlb.h b/arch/s390/include/asm/hugetlb.h
index 670a1d1..bb8343d 100644
--- a/arch/s390/include/asm/hugetlb.h
+++ b/arch/s390/include/asm/hugetlb.h
@@ -97,6 +97,7 @@ static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
 {
 	pte_t pte = huge_ptep_get(ptep);
 
+	mm->context.flush_mm = 1;
 	pmd_clear((pmd_t *) ptep);
 	return pte;
 }
@@ -167,7 +168,8 @@ static inline void huge_ptep_invalidate(struct mm_struct *mm,
 ({									\
 	pte_t __pte = huge_ptep_get(__ptep);				\
 	if (pte_write(__pte)) {						\
-		if (atomic_read(&(__mm)->mm_users) > 1 ||		\
+		(__mm)->context.flush_mm = 1;				\
+		if (atomic_read(&(__mm)->context.attach_count) > 1 ||	\
 		    (__mm) != current->active_mm)			\
 			huge_ptep_invalidate(__mm, __addr, __ptep);	\
 		set_huge_pte_at(__mm, __addr, __ptep,			\
diff --git a/arch/s390/include/asm/mmu.h b/arch/s390/include/asm/mmu.h
index 99e3409..78522cd 100644
--- a/arch/s390/include/asm/mmu.h
+++ b/arch/s390/include/asm/mmu.h
@@ -2,6 +2,8 @@
 #define __MMU_H
 
 typedef struct {
+	atomic_t attach_count;
+	unsigned int flush_mm;
 	spinlock_t list_lock;
 	struct list_head crst_list;
 	struct list_head pgtable_list;
diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index 976e273..a6f0e7c 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -11,11 +11,14 @@
 
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
+#include <asm/tlbflush.h>
 #include <asm-generic/mm_hooks.h>
 
 static inline int init_new_context(struct task_struct *tsk,
 				   struct mm_struct *mm)
 {
+	atomic_set(&mm->context.attach_count, 0);
+	mm->context.flush_mm = 0;
 	mm->context.asce_bits = _ASCE_TABLE_LENGTH | _ASCE_USER_BITS;
 #ifdef CONFIG_64BIT
 	mm->context.asce_bits |= _ASCE_TYPE_REGION3;
@@ -76,6 +79,12 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 {
 	cpumask_set_cpu(smp_processor_id(), mm_cpumask(next));
 	update_mm(next, tsk);
+	atomic_dec(&prev->context.attach_count);
+	WARN_ON(atomic_read(&prev->context.attach_count) < 0);
+	atomic_inc(&next->context.attach_count);
+	/* Check for TLBs not flushed yet */
+	if (next->context.flush_mm)
+		__tlb_flush_mm(next);
 }
 
 #define enter_lazy_tlb(mm,tsk)	do { } while (0)
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 89a504c..3157441 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -880,7 +880,8 @@ static inline void ptep_invalidate(struct mm_struct *mm,
 #define ptep_get_and_clear(__mm, __address, __ptep)			\
 ({									\
 	pte_t __pte = *(__ptep);					\
-	if (atomic_read(&(__mm)->mm_users) > 1 ||			\
+	(__mm)->context.flush_mm = 1;					\
+	if (atomic_read(&(__mm)->context.attach_count) > 1 ||		\
 	    (__mm) != current->active_mm)				\
 		ptep_invalidate(__mm, __address, __ptep);		\
 	else								\
@@ -923,7 +924,8 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 ({									\
 	pte_t __pte = *(__ptep);					\
 	if (pte_write(__pte)) {						\
-		if (atomic_read(&(__mm)->mm_users) > 1 ||		\
+		(__mm)->context.flush_mm = 1;				\
+		if (atomic_read(&(__mm)->context.attach_count) > 1 ||	\
 		    (__mm) != current->active_mm)			\
 			ptep_invalidate(__mm, __addr, __ptep);		\
 		set_pte_at(__mm, __addr, __ptep, pte_wrprotect(__pte));	\
diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
index 81150b0..fd1c00d 100644
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -50,8 +50,7 @@ static inline struct mmu_gather *tlb_gather_mmu(struct mm_struct *mm,
 	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
 
 	tlb->mm = mm;
-	tlb->fullmm = full_mm_flush || (num_online_cpus() == 1) ||
-		(atomic_read(&mm->mm_users) <= 1 && mm == current->active_mm);
+	tlb->fullmm = full_mm_flush;
 	tlb->nr_ptes = 0;
 	tlb->nr_pxds = TLB_NR_PTRS;
 	if (tlb->fullmm)
diff --git a/arch/s390/include/asm/tlbflush.h b/arch/s390/include/asm/tlbflush.h
index 304cffa..29d5d6d 100644
--- a/arch/s390/include/asm/tlbflush.h
+++ b/arch/s390/include/asm/tlbflush.h
@@ -94,8 +94,12 @@ static inline void __tlb_flush_mm(struct mm_struct * mm)
 
 static inline void __tlb_flush_mm_cond(struct mm_struct * mm)
 {
-	if (atomic_read(&mm->mm_users) <= 1 && mm == current->active_mm)
+	spin_lock(&mm->page_table_lock);
+	if (mm->context.flush_mm) {
 		__tlb_flush_mm(mm);
+		mm->context.flush_mm = 0;
+	}
+	spin_unlock(&mm->page_table_lock);
 }
 
 /*
diff --git a/arch/s390/kernel/entry.h b/arch/s390/kernel/entry.h
index 403fb43..ff579b6 100644
--- a/arch/s390/kernel/entry.h
+++ b/arch/s390/kernel/entry.h
@@ -42,8 +42,8 @@ long sys_clone(unsigned long newsp, unsigned long clone_flags,
 	       int __user *parent_tidptr, int __user *child_tidptr);
 long sys_vfork(void);
 void execve_tail(void);
-long sys_execve(const char __user *name, char __user * __user *argv,
-		char __user * __user *envp);
+long sys_execve(const char __user *name, const char __user *const __user *argv,
+		const char __user *const __user *envp);
 long sys_sigsuspend(int history0, int history1, old_sigset_t mask);
 long sys_sigaction(int sig, const struct old_sigaction __user *act,
 		   struct old_sigaction __user *oact);
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 541053e..8127ebd 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -583,6 +583,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	sf->gprs[9] = (unsigned long) sf;
 	cpu_lowcore->save_area[15] = (unsigned long) sf;
 	__ctl_store(cpu_lowcore->cregs_save_area, 0, 15);
+	atomic_inc(&init_mm.context.attach_count);
 	asm volatile(
 		"	stam	0,15,0(%0)"
 		: : "a" (&cpu_lowcore->access_regs_save_area) : "memory");
@@ -659,6 +660,7 @@ void __cpu_die(unsigned int cpu)
 	while (sigp_p(0, cpu, sigp_set_prefix) == sigp_busy)
 		udelay(10);
 	smp_free_lowcore(cpu);
+	atomic_dec(&init_mm.context.attach_count);
 	pr_info("Processor %d stopped\n", cpu);
 }
 
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index acc91c7..30eb6d0 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -74,6 +74,8 @@ void __init paging_init(void)
 	__ctl_load(S390_lowcore.kernel_asce, 13, 13);
 	__raw_local_irq_ssm(ssm_mask);
 
+	atomic_set(&init_mm.context.attach_count, 1);
+
 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
