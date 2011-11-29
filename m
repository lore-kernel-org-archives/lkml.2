Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab1K2MXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:23:39 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52376 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab1K2MWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:22:49 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [RFC PATCH 4/6] ARM: Remove __ARCH_WANT_INTERRUPTS_ON_CTXSW on ASID-capable CPUs
Date: Tue, 29 Nov 2011 12:22:30 +0000
Message-Id: <1322569352-23584-5-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1322569352-23584-1-git-send-email-catalin.marinas@arm.com>
References: <1322569352-23584-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 29 Nov 2011 12:22:39.0785 (UTC) FILETIME=[960D5990:01CCAE91]
X-MC-Unique: 111112912224602001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pATCNp43007590

Since the ASIDs must be unique to an mm across all the CPUs in a system,
the __new_context() function needs to broadcast a context reset event to
all the CPUs during ASID allocation if a roll-over occurred. Such IPIs
cannot be issued with interrupts disabled and ARM had to define
__ARCH_WANT_INTERRUPTS_ON_CTXSW.

This patch changes the check_context() function to
check_and_switch_context() called from switch_mm(). In case of
ASID-capable CPUs (ARMv6 onwards), if a new ASID is needed, it defers
the __new_context() and cpu_switch_mm() calls to the post-lock switch
hook where the interrupts are enabled. Setting the reserved TTBR0 was
also moved to check_and_switch_context() from cpu_v7_switch_mm().

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/include/asm/mmu_context.h |   81 ++++++++++++++++++++++++++++--------
 arch/arm/include/asm/system.h      |    2 +
 arch/arm/include/asm/thread_info.h |    1 +
 arch/arm/mm/context.c              |    4 +-
 arch/arm/mm/proc-v7.S              |    3 -
 5 files changed, 69 insertions(+), 22 deletions(-)

diff --git a/arch/arm/include/asm/mmu_context.h b/arch/arm/include/asm/mmu_context.h
index 71605d9..3e4b219 100644
--- a/arch/arm/include/asm/mmu_context.h
+++ b/arch/arm/include/asm/mmu_context.h
@@ -48,39 +48,75 @@ DECLARE_PER_CPU(struct mm_struct *, current_mm);
 
 void __init_new_context(struct task_struct *tsk, struct mm_struct *mm);
 void __new_context(struct mm_struct *mm);
+void cpu_set_reserved_ttbr0(void);
 
-static inline void check_context(struct mm_struct *mm)
+static inline void check_and_switch_context(struct mm_struct *mm,
+					    struct task_struct *tsk)
 {
+	if (unlikely(mm->context.kvm_seq != init_mm.context.kvm_seq))
+		__check_kvm_seq(mm);
+
 	/*
-	 * This code is executed with interrupts enabled. Therefore,
-	 * mm->context.id cannot be updated to the latest ASID version
-	 * on a different CPU (and condition below not triggered)
-	 * without first getting an IPI to reset the context. The
-	 * alternative is to take a read_lock on mm->context.id_lock
-	 * (after changing its type to rwlock_t).
+	 * Required during context switch to avoid speculative page table
+	 * walking with the wrong TTBR.
 	 */
-	if (unlikely((mm->context.id ^ cpu_last_asid) >> ASID_BITS))
-		__new_context(mm);
+	cpu_set_reserved_ttbr0();
 
-	if (unlikely(mm->context.kvm_seq != init_mm.context.kvm_seq))
-		__check_kvm_seq(mm);
+	/*
+	 * This code is executed with interrupts disabled. If mm->context.id
+	 * and cpu_last_asid are from the same generation (condition below
+	 * false), they cannot be updated on a different CPU without an IPI
+	 * being issued to reset the context. However, smp_call_function() on
+	 * a different CPU will need to wait for the current context switch to
+	 * complete and interrupts to be enabled before using the new
+	 * generation of ASIDs.
+	 */
+	if (unlikely((mm->context.id ^ cpu_last_asid) >> ASID_BITS))
+		/*
+		 * Defer the new ASID allocation until after the context
+		 * switch critical region since __new_context() cannot be
+		 * called with interrupts disabled.
+		 */
+		set_ti_thread_flag(task_thread_info(tsk), TIF_SWITCH_MM);
+	else
+		cpu_switch_mm(mm->pgd, mm);
 }
 
 #define init_new_context(tsk,mm)	(__init_new_context(tsk,mm),0)
 
-#else
+#define finish_arch_post_lock_switch \
+	finish_arch_post_lock_switch
+static inline void finish_arch_post_lock_switch(void)
+{
+	if (test_and_clear_thread_flag(TIF_SWITCH_MM)) {
+		struct mm_struct *mm = current->mm;
+		unsigned long flags;
+
+		__new_context(mm);
+
+		local_irq_save(flags);
+		cpu_switch_mm(mm->pgd, mm);
+		local_irq_restore(flags);
+	}
+}
+
+#else	/* !CONFIG_CPU_HAS_ASID */
 
-static inline void check_context(struct mm_struct *mm)
+static inline void check_and_switch_context(struct mm_struct *mm,
+					    struct task_struct *tsk)
 {
 #ifdef CONFIG_MMU
 	if (unlikely(mm->context.kvm_seq != init_mm.context.kvm_seq))
 		__check_kvm_seq(mm);
+	cpu_switch_mm(mm->pgd, mm);
 #endif
 }
 
 #define init_new_context(tsk,mm)	0
 
-#endif
+#define finish_arch_post_lock_switch()	do { } while (0)
+
+#endif	/* CONFIG_CPU_HAS_ASID */
 
 #define destroy_context(mm)		do { } while(0)
 
@@ -122,8 +158,7 @@ switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		struct mm_struct **crt_mm = &per_cpu(current_mm, cpu);
 		*crt_mm = next;
 #endif
-		check_context(next);
-		cpu_switch_mm(next->pgd, next);
+		check_and_switch_context(next, tsk);
 		if (cache_is_vivt())
 			cpumask_clear_cpu(cpu, mm_cpumask(prev));
 	}
@@ -131,7 +166,19 @@ switch_mm(struct mm_struct *prev, struct mm_struct *next,
 }
 
 #define deactivate_mm(tsk,mm)	do { } while (0)
-#define activate_mm(prev,next)	switch_mm(prev, next, NULL)
+
+static inline void activate_mm(struct mm_struct *prev, struct mm_struct *next)
+{
+#ifdef CONFIG_MMU
+	unsigned long flags;
+
+	local_irq_save(flags);
+	switch_mm(prev, next, current);
+	local_irq_restore(flags);
+
+	finish_arch_post_lock_switch();
+#endif
+}
 
 /*
  * We are inserting a "fake" vma for the user-accessible vector page so
diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
index 984014b..3daebde 100644
--- a/arch/arm/include/asm/system.h
+++ b/arch/arm/include/asm/system.h
@@ -222,7 +222,9 @@ static inline void set_copro_access(unsigned int val)
  * so enable interrupts over the context switch to avoid high
  * latency.
  */
+#ifndef CONFIG_CPU_HAS_ASID
 #define __ARCH_WANT_INTERRUPTS_ON_CTXSW
+#endif
 
 /*
  * switch_to(prev, next) should switch from task `prev' to `next'
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 7b5cc8d..119e4eb 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -145,6 +145,7 @@ extern void vfp_flush_hwstate(struct thread_info *);
 #define TIF_FREEZE		19
 #define TIF_RESTORE_SIGMASK	20
 #define TIF_SECCOMP		21
+#define TIF_SWITCH_MM		22	/* deferred switch_mm */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
diff --git a/arch/arm/mm/context.c b/arch/arm/mm/context.c
index 1d5014b..d80aef0 100644
--- a/arch/arm/mm/context.c
+++ b/arch/arm/mm/context.c
@@ -22,7 +22,7 @@ unsigned int cpu_last_asid = ASID_FIRST_VERSION;
 DEFINE_PER_CPU(struct mm_struct *, current_mm);
 #endif
 
-static void cpu_set_reserved_ttbr0(void)
+void cpu_set_reserved_ttbr0(void)
 {
 	u32 ttb;
 	/* Copy TTBR1 into TTBR0 */
@@ -43,7 +43,7 @@ void __init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 	raw_spin_lock_init(&mm->context.id_lock);
 }
 
-static void flush_context(void)
+void flush_context(void)
 {
 	cpu_set_reserved_ttbr0();
 	local_flush_tlb_all();
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 2faff3b..d5334d9 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -116,9 +116,6 @@ ENTRY(cpu_v7_switch_mm)
 #ifdef CONFIG_ARM_ERRATA_430973
 	mcr	p15, 0, r2, c7, c5, 6		@ flush BTAC/BTB
 #endif
-	mrc	p15, 0, r2, c2, c0, 1		@ load TTB 1
-	mcr	p15, 0, r2, c2, c0, 0		@ into TTB 0
-	isb
 #ifdef CONFIG_ARM_ERRATA_754322
 	dsb
 #endif

