Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846Ab1EXVxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:53:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53763 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559Ab1EXVwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:52:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Caw+IJt0UMPWzblmUvF22z4BqTyO5hBGX3OQfLUfmDSpcEjGXFSUwXsoo9FxfVFRhH
         fMgnXdusgRSOOdORJss3K6hj4C9O+VrAWw8h6LFFQ93AiT1JM4WaJ+pym0/KZQX2Ufbe
         7aVSu7weH5MBN7BsKfaMTrZ+5llQXDnas4hRA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 2/6] hw_breakpoints: Migrate breakpoint conditional build under new config
Date: Tue, 24 May 2011 23:52:23 +0200
Message-Id: <1306273947-8410-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1306273947-8410-1-git-send-email-fweisbec@gmail.com>
References: <1306273947-8410-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Migrate conditional hw_breakpoint code compilation under
the new config to prepare for letting the user chose whether
or not to build this feature

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/arm/include/asm/hw_breakpoint.h     |    4 ++--
 arch/arm/include/asm/processor.h         |    2 +-
 arch/arm/kernel/Makefile                 |    2 +-
 arch/arm/kernel/entry-header.S           |    2 +-
 arch/arm/kernel/ptrace.c                 |    4 ++--
 arch/powerpc/include/asm/cputable.h      |    4 ++--
 arch/powerpc/include/asm/hw_breakpoint.h |    6 +++---
 arch/powerpc/include/asm/processor.h     |    4 ++--
 arch/powerpc/kernel/Makefile             |    2 +-
 arch/powerpc/kernel/process.c            |   18 +++++++++---------
 arch/powerpc/kernel/ptrace.c             |   13 +++++++------
 arch/powerpc/lib/Makefile                |    2 +-
 arch/sh/kernel/Makefile                  |    2 +-
 arch/sh/kernel/cpu/sh4a/Makefile         |    2 +-
 include/linux/hw_breakpoint.h            |    6 +++---
 include/linux/perf_event.h               |    4 ++--
 include/linux/ptrace.h                   |    6 +++---
 include/linux/sched.h                    |    2 +-
 kernel/events/Makefile                   |    2 +-
 kernel/events/core.c                     |    4 ++--
 kernel/ptrace.c                          |    4 ++--
 samples/Kconfig                          |    2 +-
 22 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/arch/arm/include/asm/hw_breakpoint.h b/arch/arm/include/asm/hw_breakpoint.h
index f389b27..fc6ba18 100644
--- a/arch/arm/include/asm/hw_breakpoint.h
+++ b/arch/arm/include/asm/hw_breakpoint.h
@@ -5,7 +5,7 @@
 
 struct task_struct;
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 
 struct arch_hw_breakpoint_ctrl {
 		u32 __reserved	: 9,
@@ -128,6 +128,6 @@ int hw_breakpoint_slots(int type);
 #else
 static inline void clear_ptrace_hw_breakpoint(struct task_struct *tsk) {}
 
-#endif	/* CONFIG_HAVE_HW_BREAKPOINT */
+#endif	/* CONFIG_HW_BREAKPOINT */
 #endif	/* __KERNEL__ */
 #endif	/* _ARM_HW_BREAKPOINT_H */
diff --git a/arch/arm/include/asm/processor.h b/arch/arm/include/asm/processor.h
index b2d9df5..b86d135 100644
--- a/arch/arm/include/asm/processor.h
+++ b/arch/arm/include/asm/processor.h
@@ -30,7 +30,7 @@
 #endif
 
 struct debug_info {
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 	struct perf_event	*hbp[ARM_MAX_HBP_SLOTS];
 #endif
 };
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 8d95446..e6c4b04 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -47,7 +47,7 @@ obj-$(CONFIG_HAVE_TCM)		+= tcm.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_SWP_EMULATE)	+= swp_emulate.o
 CFLAGS_swp_emulate.o		:= -Wa,-march=armv7-a
-obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= hw_breakpoint.o
+obj-$(CONFIG_HW_BREAKPOINT)	+= hw_breakpoint.o
 
 obj-$(CONFIG_CRUNCH)		+= crunch.o crunch-bits.o
 AFLAGS_crunch-bits.o		:= -Wa,-mcpu=ep9312
diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index 051166c..fbc7cc9 100644
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -171,7 +171,7 @@
 	@ we can access the debug registers safely.
 	@
 	.macro	debug_entry, fsr
-#if defined(CONFIG_HAVE_HW_BREAKPOINT) && defined(CONFIG_PREEMPT)
+#if defined(CONFIG_HW_BREAKPOINT) && defined(CONFIG_PREEMPT)
 	ldr	r4, =0x40f		@ mask out fsr.fs
 	and	r5, r4, \fsr
 	cmp	r5, #2			@ debug exception
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 8182f45..07be604 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -468,7 +468,7 @@ static int ptrace_setvfpregs(struct task_struct *tsk, void __user *data)
 }
 #endif
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 /*
  * Convert a virtual register number into an index for a thread_info
  * breakpoint array. Breakpoints are identified using positive numbers
@@ -765,7 +765,7 @@ long arch_ptrace(struct task_struct *child, long request,
 			break;
 #endif
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 		case PTRACE_GETHBPREGS:
 			if (ptrace_get_breakpoints(child) < 0)
 				return -ESRCH;
diff --git a/arch/powerpc/include/asm/cputable.h b/arch/powerpc/include/asm/cputable.h
index 1833d1a..36b5568 100644
--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -538,9 +538,9 @@ static inline int cpu_has_feature(unsigned long feature)
 		& feature);
 }
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 #define HBP_NUM 1
-#endif /* CONFIG_HAVE_HW_BREAKPOINT */
+#endif /* CONFIG_HW_BREAKPOINT */
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/powerpc/include/asm/hw_breakpoint.h b/arch/powerpc/include/asm/hw_breakpoint.h
index 1c33ec1..6ecd3b6 100644
--- a/arch/powerpc/include/asm/hw_breakpoint.h
+++ b/arch/powerpc/include/asm/hw_breakpoint.h
@@ -24,7 +24,7 @@
 #define _PPC_BOOK3S_64_HW_BREAKPOINT_H
 
 #ifdef	__KERNEL__
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 
 struct arch_hw_breakpoint {
 	bool		extraneous_interrupt;
@@ -65,10 +65,10 @@ static inline void hw_breakpoint_disable(void)
 }
 extern void thread_change_pc(struct task_struct *tsk, struct pt_regs *regs);
 
-#else	/* CONFIG_HAVE_HW_BREAKPOINT */
+#else	/* CONFIG_HW_BREAKPOINT */
 static inline void hw_breakpoint_disable(void) { }
 static inline void thread_change_pc(struct task_struct *tsk,
 					struct pt_regs *regs) { }
-#endif	/* CONFIG_HAVE_HW_BREAKPOINT */
+#endif	/* CONFIG_HW_BREAKPOINT */
 #endif	/* __KERNEL__ */
 #endif	/* _PPC_BOOK3S_64_HW_BREAKPOINT_H */
diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index de1967a..3fe688d 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -207,14 +207,14 @@ struct thread_struct {
 #ifdef CONFIG_PPC64
 	unsigned long	start_tb;	/* Start purr when proc switched in */
 	unsigned long	accum_tb;	/* Total accumilated purr for process */
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 	struct perf_event *ptrace_bps[HBP_NUM];
 	/*
 	 * Helps identify source of single-step exception and subsequent
 	 * hw-breakpoint enablement
 	 */
 	struct perf_event *last_hit_ubp;
-#endif /* CONFIG_HAVE_HW_BREAKPOINT */
+#endif /* CONFIG_HW_BREAKPOINT */
 #endif
 	unsigned long	dabr;		/* Data address breakpoint register */
 #ifdef CONFIG_ALTIVEC
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 3bb2a3e..5df8585 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -36,7 +36,7 @@ obj-y				:= cputable.o ptrace.o syscalls.o \
 obj-$(CONFIG_PPC64)		+= setup_64.o sys_ppc32.o \
 				   signal_64.o ptrace32.o \
 				   paca.o nvram_64.o firmware.o
-obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= hw_breakpoint.o
+obj-$(CONFIG_HW_BREAKPOINT)	+= hw_breakpoint.o
 obj-$(CONFIG_PPC_BOOK3S_64)	+= cpu_setup_ppc970.o cpu_setup_pa6t.o
 obj64-$(CONFIG_RELOCATABLE)	+= reloc_64.o
 obj-$(CONFIG_PPC_BOOK3E_64)	+= exceptions-64e.o idle_book3e.o
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index f74f355..3faf61a 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -353,7 +353,7 @@ static void switch_booke_debug_regs(struct thread_struct *new_thread)
 			prime_debug_regs(new_thread);
 }
 #else	/* !CONFIG_PPC_ADV_DEBUG_REGS */
-#ifndef CONFIG_HAVE_HW_BREAKPOINT
+#ifndef CONFIG_HW_BREAKPOINT
 static void set_debug_reg_defaults(struct thread_struct *thread)
 {
 	if (thread->dabr) {
@@ -361,7 +361,7 @@ static void set_debug_reg_defaults(struct thread_struct *thread)
 		set_dabr(0);
 	}
 }
-#endif /* !CONFIG_HAVE_HW_BREAKPOINT */
+#endif /* !CONFIG_HW_BREAKPOINT */
 #endif	/* CONFIG_PPC_ADV_DEBUG_REGS */
 
 int set_dabr(unsigned long dabr)
@@ -469,10 +469,10 @@ struct task_struct *__switch_to(struct task_struct *prev,
  * For PPC_BOOK3S_64, we use the hw-breakpoint interfaces that would
  * schedule DABR
  */
-#ifndef CONFIG_HAVE_HW_BREAKPOINT
+#ifndef CONFIG_HW_BREAKPOINT
 	if (unlikely(__get_cpu_var(current_dabr) != new->thread.dabr))
 		set_dabr(new->thread.dabr);
-#endif /* CONFIG_HAVE_HW_BREAKPOINT */
+#endif /* CONFIG_HW_BREAKPOINT */
 #endif
 
 
@@ -672,11 +672,11 @@ void flush_thread(void)
 {
 	discard_lazy_cpu_state();
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 	flush_ptrace_hw_breakpoint(current);
-#else /* CONFIG_HAVE_HW_BREAKPOINT */
+#else /* CONFIG_HW_BREAKPOINT */
 	set_debug_reg_defaults(&current->thread);
-#endif /* CONFIG_HAVE_HW_BREAKPOINT */
+#endif /* CONFIG_HW_BREAKPOINT */
 }
 
 void
@@ -694,9 +694,9 @@ void prepare_to_copy(struct task_struct *tsk)
 	flush_altivec_to_thread(current);
 	flush_vsx_to_thread(current);
 	flush_spe_to_thread(current);
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 	flush_ptrace_hw_breakpoint(tsk);
-#endif /* CONFIG_HAVE_HW_BREAKPOINT */
+#endif /* CONFIG_HW_BREAKPOINT */
 }
 
 /*
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index a6ae1cf..18c687e 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -877,7 +877,7 @@ void user_disable_single_step(struct task_struct *task)
 	clear_tsk_thread_flag(task, TIF_SINGLESTEP);
 }
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 void ptrace_triggered(struct perf_event *bp, int nmi,
 		      struct perf_sample_data *data, struct pt_regs *regs)
 {
@@ -893,17 +893,17 @@ void ptrace_triggered(struct perf_event *bp, int nmi,
 	attr.disabled = true;
 	modify_user_hw_breakpoint(bp, &attr);
 }
-#endif /* CONFIG_HAVE_HW_BREAKPOINT */
+#endif /* CONFIG_HW_BREAKPOINT */
 
 int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 			       unsigned long data)
 {
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 	int ret;
 	struct thread_struct *thread = &(task->thread);
 	struct perf_event *bp;
 	struct perf_event_attr attr;
-#endif /* CONFIG_HAVE_HW_BREAKPOINT */
+#endif /* CONFIG_HW_BREAKPOINT */
 
 	/* For ppc64 we support one DABR and no IABR's at the moment (ppc64).
 	 *  For embedded processors we support one DAC and no IAC's at the
@@ -932,7 +932,8 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 	/* Ensure breakpoint translation bit is set */
 	if (data && !(data & DABR_TRANSLATION))
 		return -EIO;
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+
+#ifdef CONFIG_HW_BREAKPOINT
 	if (ptrace_get_breakpoints(task) < 0)
 		return -ESRCH;
 
@@ -978,7 +979,7 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 
 	ptrace_put_breakpoints(task);
 
-#endif /* CONFIG_HAVE_HW_BREAKPOINT */
+#endif /* CONFIG_HW_BREAKPOINT */
 
 	/* Move contents to the DABR register */
 	task->thread.dabr = data;
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 166a6a0..515d044 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -19,7 +19,7 @@ obj-$(CONFIG_PPC64)	+= copypage_64.o copyuser_64.o \
 			   checksum_wrappers_64.o hweight_64.o
 obj-$(CONFIG_XMON)	+= sstep.o ldstfp.o
 obj-$(CONFIG_KPROBES)	+= sstep.o ldstfp.o
-obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= sstep.o ldstfp.o
+obj-$(CONFIG_HW_BREAKPOINT)	+= sstep.o ldstfp.o
 
 ifeq ($(CONFIG_PPC64),y)
 obj-$(CONFIG_SMP)	+= locks.o
diff --git a/arch/sh/kernel/Makefile b/arch/sh/kernel/Makefile
index 77f7ae1..9d5075c 100644
--- a/arch/sh/kernel/Makefile
+++ b/arch/sh/kernel/Makefile
@@ -45,7 +45,7 @@ obj-$(CONFIG_HIBERNATION)	+= swsusp.o
 obj-$(CONFIG_DWARF_UNWINDER)	+= dwarf.o
 obj-$(CONFIG_PERF_EVENTS)	+= perf_event.o perf_callchain.o
 
-obj-$(CONFIG_HAVE_HW_BREAKPOINT)		+= hw_breakpoint.o
+obj-$(CONFIG_HW_BREAKPOINT)		+= hw_breakpoint.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)	+= localtimer.o
 
 ccflags-y := -Werror
diff --git a/arch/sh/kernel/cpu/sh4a/Makefile b/arch/sh/kernel/cpu/sh4a/Makefile
index cc122b1..5bec639 100644
--- a/arch/sh/kernel/cpu/sh4a/Makefile
+++ b/arch/sh/kernel/cpu/sh4a/Makefile
@@ -46,4 +46,4 @@ obj-y					+= $(clock-y)
 obj-$(CONFIG_SMP)			+= $(smp-y)
 obj-$(CONFIG_GENERIC_GPIO)		+= $(pinmux-y)
 obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
-obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= ubc.o
+obj-$(CONFIG_HW_BREAKPOINT)	+= ubc.o
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index d1e55fe..9aad682 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -31,7 +31,7 @@ enum bp_type_idx {
 
 #include <linux/perf_event.h>
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 
 extern int __init init_hw_breakpoint(void);
 
@@ -108,7 +108,7 @@ static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
 	return &bp->hw.info;
 }
 
-#else /* !CONFIG_HAVE_HW_BREAKPOINT */
+#else /* !CONFIG_HW_BREAKPOINT */
 
 static inline int __init init_hw_breakpoint(void) { return 0; }
 
@@ -144,7 +144,7 @@ static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
 	return NULL;
 }
 
-#endif /* CONFIG_HAVE_HW_BREAKPOINT */
+#endif /* CONFIG_HW_BREAKPOINT */
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_HW_BREAKPOINT_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3412684..6a65fbf 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -491,7 +491,7 @@ struct perf_guest_info_callbacks {
 	unsigned long			(*get_guest_ip)(void);
 };
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 #include <asm/hw_breakpoint.h>
 #endif
 
@@ -556,7 +556,7 @@ struct hw_perf_event {
 		struct { /* software */
 			struct hrtimer	hrtimer;
 		};
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 		struct { /* breakpoint */
 			struct arch_hw_breakpoint	info;
 			struct list_head		bp_list;
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 9178d5c..9ff2641 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -190,7 +190,7 @@ static inline void ptrace_init_task(struct task_struct *child, bool ptrace)
 		__ptrace_link(child, current->parent);
 	}
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 	atomic_set(&child->ptrace_bp_refcnt, 1);
 #endif
 }
@@ -354,12 +354,12 @@ extern int task_current_syscall(struct task_struct *target, long *callno,
 				unsigned long args[6], unsigned int maxargs,
 				unsigned long *sp, unsigned long *pc);
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 extern int ptrace_get_breakpoints(struct task_struct *tsk);
 extern void ptrace_put_breakpoints(struct task_struct *tsk);
 #else
 static inline void ptrace_put_breakpoints(struct task_struct *tsk) { }
-#endif /* CONFIG_HAVE_HW_BREAKPOINT */
+#endif /* CONFIG_HW_BREAKPOINT */
 
 #endif /* __KERNEL */
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 781abd1..b575989 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1537,7 +1537,7 @@ struct task_struct {
 		unsigned long memsw_nr_pages; /* uncharged mem+swap usage */
 	} memcg_batch;
 #endif
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 	atomic_t ptrace_bp_refcnt;
 #endif
 };
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 1ce23d3..3659100 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -3,4 +3,4 @@ CFLAGS_REMOVE_core.o = -pg
 endif
 
 obj-y := core.o
-obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
+obj-$(CONFIG_HW_BREAKPOINT) += hw_breakpoint.o
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0fc34a3..9f19c33 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5616,7 +5616,7 @@ static void perf_event_free_filter(struct perf_event *event)
 
 #endif /* CONFIG_EVENT_TRACING */
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 void perf_bp_event(struct perf_event *bp, void *data)
 {
 	struct perf_sample_data sample;
@@ -6207,7 +6207,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 	if (task) {
 		event->attach_state = PERF_ATTACH_TASK;
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 		/*
 		 * hw_breakpoint is a bit difficult here..
 		 */
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index dc7ab65..4c2cff7 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -881,7 +881,7 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 }
 #endif	/* CONFIG_COMPAT */
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#ifdef CONFIG_HW_BREAKPOINT
 int ptrace_get_breakpoints(struct task_struct *tsk)
 {
 	if (atomic_inc_not_zero(&tsk->ptrace_bp_refcnt))
@@ -895,4 +895,4 @@ void ptrace_put_breakpoints(struct task_struct *tsk)
 	if (atomic_dec_and_test(&tsk->ptrace_bp_refcnt))
 		flush_ptrace_hw_breakpoint(tsk);
 }
-#endif /* CONFIG_HAVE_HW_BREAKPOINT */
+#endif /* CONFIG_HW_BREAKPOINT */
diff --git a/samples/Kconfig b/samples/Kconfig
index 41063e7..d1e41e9 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -40,7 +40,7 @@ config SAMPLE_KRETPROBES
 
 config SAMPLE_HW_BREAKPOINT
 	tristate "Build kernel hardware breakpoint examples -- loadable module only"
-	depends on HAVE_HW_BREAKPOINT && m
+	depends on HW_BREAKPOINT && m
 	help
 	  This builds kernel hardware breakpoint example modules.
 
-- 
1.7.3.2

