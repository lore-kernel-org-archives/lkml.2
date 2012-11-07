Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab2KGJvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:51:55 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:39275 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab2KGJsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:37 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 15/31] ARC: Process/scheduling/clock/Timers/Delay Management
Date: Wed,  7 Nov 2012 10:47:38 +0100
Message-Id: <1352281674-2186-16-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/arcregs.h   |   31 +++++
 arch/arc/include/asm/delay.h     |   68 +++++++++++
 arch/arc/include/asm/processor.h |    3 +
 arch/arc/include/asm/switch_to.h |   41 +++++++
 arch/arc/include/asm/timex.h     |   18 +++
 arch/arc/kernel/ctx_sw.c         |   91 +++++++++++++++
 arch/arc/kernel/ctx_sw_asm.S     |   58 +++++++++
 arch/arc/kernel/fpu.c            |   55 +++++++++
 arch/arc/kernel/process.c        |  201 ++++++++++++++++++++++++++++++++
 arch/arc/kernel/time.c           |  237 ++++++++++++++++++++++++++++++++++++++
 10 files changed, 803 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/delay.h
 create mode 100644 arch/arc/include/asm/switch_to.h
 create mode 100644 arch/arc/include/asm/timex.h
 create mode 100644 arch/arc/kernel/ctx_sw.c
 create mode 100644 arch/arc/kernel/ctx_sw_asm.S
 create mode 100644 arch/arc/kernel/fpu.c
 create mode 100644 arch/arc/kernel/time.c

diff --git a/arch/arc/include/asm/arcregs.h b/arch/arc/include/asm/arcregs.h
index 3fccb04..5131bb3 100644
--- a/arch/arc/include/asm/arcregs.h
+++ b/arch/arc/include/asm/arcregs.h
@@ -47,6 +47,28 @@
 #define AUX_ITRIGGER		0x40d
 #define AUX_IPULSE		0x415
 
+/* Timer related Aux registers */
+#define ARC_REG_TIMER0_LIMIT	0x23	/* timer 0 limit */
+#define ARC_REG_TIMER0_CTRL	0x22	/* timer 0 control */
+#define ARC_REG_TIMER0_CNT	0x21	/* timer 0 count */
+#define ARC_REG_TIMER1_LIMIT	0x102	/* timer 1 limit */
+#define ARC_REG_TIMER1_CTRL	0x101	/* timer 1 control */
+#define ARC_REG_TIMER1_CNT	0x100	/* timer 1 count */
+
+#define TIMER_CTRL_IE		(1 << 0) /* Interupt when Count reachs limit */
+#define TIMER_CTRL_NH		(1 << 1) /* Count only when CPU NOT halted */
+
+/*
+ * Floating Pt Registers
+ * Status regs are read-only (build-time) so need not be saved/restored
+ */
+#define ARC_AUX_FP_STAT         0x300
+#define ARC_AUX_DPFP_1L         0x301
+#define ARC_AUX_DPFP_1H         0x302
+#define ARC_AUX_DPFP_2L         0x303
+#define ARC_AUX_DPFP_2H         0x304
+#define ARC_AUX_DPFP_STAT       0x305
+
 #ifndef __ASSEMBLY__
 
 /*
@@ -110,6 +132,15 @@
 
 #endif
 
+#ifdef CONFIG_ARC_FPU_SAVE_RESTORE
+/* These DPFP regs need to be saved/restored across ctx-sw */
+struct arc_fpu {
+	struct {
+		unsigned int l, h;
+	} aux_dpfp[2];
+};
+#endif
+
 #endif /* __ASEMBLY__ */
 
 #endif /* __KERNEL__ */
diff --git a/arch/arc/include/asm/delay.h b/arch/arc/include/asm/delay.h
new file mode 100644
index 0000000..442ce5d
--- /dev/null
+++ b/arch/arc/include/asm/delay.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Delay routines using pre computed loops_per_jiffy value.
+ *
+ * vineetg: Feb 2012
+ *  -Rewrote in "C" to avoid dealing with availability of H/w MPY
+ *  -Also reduced the num of MPY operations from 3 to 2
+ *
+ * Amit Bhor: Codito Technologies 2004
+ */
+
+#ifndef __ASM_ARC_UDELAY_H
+#define __ASM_ARC_UDELAY_H
+
+#include <asm/param.h>		/* HZ */
+
+static inline void __delay(unsigned long loops)
+{
+	__asm__ __volatile__(
+	"1:	sub.f %0, %0, 1	\n"
+	"	jpnz 1b		\n"
+	: "+r"(loops)
+	:
+	: "cc");
+}
+
+extern void __bad_udelay(void);
+
+/*
+ * Normal Math for computing loops in "N" usecs
+ *  -we have precomputed @loops_per_jiffy
+ *  -1 sec has HZ jiffies
+ * loops per "N" usecs = ((loops_per_jiffy * HZ / 1000000) * N)
+ *
+ * Approximate Division by multiplication:
+ *  -Mathematically if we multiply and divide a number by same value the
+ *   result remains unchanged:  In this case, we use 2^32
+ *  -> (loops_per_N_usec * 2^32 ) / 2^32
+ *  -> (((loops_per_jiffy * HZ / 1000000) * N) * 2^32) / 2^32
+ *  -> (loops_per_jiffy * HZ * N * 4295) / 2^32
+ *
+ *  -Divide by 2^32 is very simply right shift by 32
+ *  -We simply need to ensure that the multiply per above eqn happens in
+ *   64-bit precision (if CPU doesn't support it - gcc can emaulate it)
+ */
+
+static inline void __udelay(unsigned long usecs)
+{
+	unsigned long loops;
+
+	/* (long long) cast ensures 64 bit MPY - real or emulated
+	 * HZ * 4295 is pre-evaluated by gcc - hence only 2 mpy ops
+	 */
+	loops = ((long long)(usecs * 4295 * HZ) *
+		 (long long)(loops_per_jiffy)) >> 32;
+
+	__delay(loops);
+}
+
+#define udelay(n) (__builtin_constant_p(n) ? ((n) > 20000 ? __bad_udelay() \
+				: __udelay(n)) : __udelay(n))
+
+#endif /* __ASM_ARC_UDELAY_H */
diff --git a/arch/arc/include/asm/processor.h b/arch/arc/include/asm/processor.h
index e2445bc..38ea5fb 100644
--- a/arch/arc/include/asm/processor.h
+++ b/arch/arc/include/asm/processor.h
@@ -29,6 +29,9 @@ struct thread_struct {
 	unsigned long callee_reg;	/* pointer to callee regs */
 	unsigned long fault_address;	/* dbls as brkpt holder as well */
 	unsigned long cause_code;	/* Exception Cause Code (ECR) */
+#ifdef CONFIG_ARC_FPU_SAVE_RESTORE
+	struct arc_fpu fpu;
+#endif
 };
 
 #define INIT_THREAD  {                          \
diff --git a/arch/arc/include/asm/switch_to.h b/arch/arc/include/asm/switch_to.h
new file mode 100644
index 0000000..1b171ab
--- /dev/null
+++ b/arch/arc/include/asm/switch_to.h
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_SWITCH_TO_H
+#define _ASM_ARC_SWITCH_TO_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/sched.h>
+
+#ifdef CONFIG_ARC_FPU_SAVE_RESTORE
+
+extern void fpu_save_restore(struct task_struct *p, struct task_struct *n);
+#define ARC_FPU_PREV(p, n)	fpu_save_restore(p, n)
+#define ARC_FPU_NEXT(t)
+
+#else
+
+#define ARC_FPU_PREV(p, n)
+#define ARC_FPU_NEXT(n)
+
+#endif /* !CONFIG_ARC_FPU_SAVE_RESTORE */
+
+struct task_struct *__switch_to(struct task_struct *p, struct task_struct *n);
+
+#define switch_to(prev, next, last)	\
+do {					\
+	ARC_FPU_PREV(prev, next);	\
+	last = __switch_to(prev, next);\
+	ARC_FPU_NEXT(next);		\
+	mb();				\
+} while (0)
+
+#endif
+
+#endif
diff --git a/arch/arc/include/asm/timex.h b/arch/arc/include/asm/timex.h
new file mode 100644
index 0000000..2c9bfb2
--- /dev/null
+++ b/arch/arc/include/asm/timex.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_TIMEX_H
+#define _ASM_ARC_TIMEX_H
+
+#define CLOCK_TICK_RATE	CONFIG_ARC_PLAT_CLK	/* Underlying HZ */
+
+#include <asm-generic/timex.h>
+
+/* XXX: get_cycles() to be implemented with RTSC insn */
+
+#endif /* _ASM_ARC_TIMEX_H */
diff --git a/arch/arc/kernel/ctx_sw.c b/arch/arc/kernel/ctx_sw.c
new file mode 100644
index 0000000..647e37a
--- /dev/null
+++ b/arch/arc/kernel/ctx_sw.c
@@ -0,0 +1,91 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Vineetg: Aug 2009
+ *  -"C" version of lowest level context switch asm macro called by schedular
+ *   gcc doesn't generate the dward CFI info for hand written asm, hence can't
+ *   backtrace out of it (e.g. tasks sleeping in kernel).
+ *   So we cheat a bit by writing almost similar code in inline-asm.
+ *  -This is a hacky way of doing things, but there is no other simple way.
+ *   I don't want/intend to extend unwinding code to understand raw asm
+ */
+
+#include <asm/asm-offsets.h>
+#include <linux/sched.h>
+
+struct task_struct *__sched
+__switch_to(struct task_struct *prev_task, struct task_struct *next_task)
+{
+	unsigned int tmp;
+	unsigned int prev = (unsigned int)prev_task;
+	unsigned int next = (unsigned int)next_task;
+	int num_words_to_skip = 1;
+
+	__asm__ __volatile__(
+		/* FP/BLINK save generated by gcc (standard function prologue */
+		"st.a    r13, [sp, -4]   \n\t"
+		"st.a    r14, [sp, -4]   \n\t"
+		"st.a    r15, [sp, -4]   \n\t"
+		"st.a    r16, [sp, -4]   \n\t"
+		"st.a    r17, [sp, -4]   \n\t"
+		"st.a    r18, [sp, -4]   \n\t"
+		"st.a    r19, [sp, -4]   \n\t"
+		"st.a    r20, [sp, -4]   \n\t"
+		"st.a    r21, [sp, -4]   \n\t"
+		"st.a    r22, [sp, -4]   \n\t"
+		"st.a    r23, [sp, -4]   \n\t"
+		"st.a    r24, [sp, -4]   \n\t"
+		"st.a    r25, [sp, -4]   \n\t"
+		"sub     sp, sp, %4      \n\t"	/* create gutter at top */
+
+		/* set ksp of outgoing task in tsk->thread.ksp */
+		"st.as   sp, [%3, %1]    \n\t"
+
+		"sync   \n\t"
+
+		/*
+		 * setup _current_task with incoming tsk.
+		 * optionally, set r25 to that as well
+		 * For SMP extra work to get to &_current_task[cpu]
+		 * (open coded SET_CURR_TASK_ON_CPU)
+		 */
+		"st  %2, [@_current_task]	\n\t"
+
+		/* get ksp of incoming task from tsk->thread.ksp */
+		"ld.as  sp, [%2, %1]   \n\t"
+
+		/* start loading it's CALLEE reg file */
+
+		"add    sp, sp, %4     \n\t"	/* skip gutter at top */
+
+		"ld.ab   r25, [sp, 4]   \n\t"
+		"ld.ab   r24, [sp, 4]   \n\t"
+		"ld.ab   r23, [sp, 4]   \n\t"
+		"ld.ab   r22, [sp, 4]   \n\t"
+		"ld.ab   r21, [sp, 4]   \n\t"
+		"ld.ab   r20, [sp, 4]   \n\t"
+		"ld.ab   r19, [sp, 4]   \n\t"
+		"ld.ab   r18, [sp, 4]   \n\t"
+		"ld.ab   r17, [sp, 4]   \n\t"
+		"ld.ab   r16, [sp, 4]   \n\t"
+		"ld.ab   r15, [sp, 4]   \n\t"
+		"ld.ab   r14, [sp, 4]   \n\t"
+		"ld.ab   r13, [sp, 4]   \n\t"
+
+		/* last (ret value) = prev : although for ARC it mov r0, r0 */
+		"mov     %0, %3        \n\t"
+
+		/* FP/BLINK restore generated by gcc (standard func epilogue */
+
+		: "=r"(tmp)
+		: "n"((TASK_THREAD + THREAD_KSP) / 4), "r"(next), "r"(prev),
+		  "n"(num_words_to_skip * 4)
+		: "blink"
+	);
+
+	return (struct task_struct *)tmp;
+}
diff --git a/arch/arc/kernel/ctx_sw_asm.S b/arch/arc/kernel/ctx_sw_asm.S
new file mode 100644
index 0000000..d897234
--- /dev/null
+++ b/arch/arc/kernel/ctx_sw_asm.S
@@ -0,0 +1,58 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Vineetg: Aug 2009
+ *  -Moved core context switch macro out of entry.S into this file.
+ *  -This is the more "natural" hand written assembler
+ */
+
+#include <asm/entry.h>       /* For the SAVE_* macros */
+#include <asm/asm-offsets.h>
+#include <asm/linkage.h>
+
+;################### Low Level Context Switch ##########################
+
+	.section .sched.text,"ax",@progbits
+	.align 4
+	.global __switch_to
+	.type   __switch_to, @function
+__switch_to:
+
+	/* Save regs on kernel mode stack of task */
+	st.a    blink, [sp, -4]
+	st.a    fp, [sp, -4]
+	SAVE_CALLEE_SAVED_KERNEL
+
+	/* Save the now KSP in task->thread.ksp */
+	st.as  sp, [r0, (TASK_THREAD + THREAD_KSP)/4]
+
+	/*
+	* Return last task in r0 (return reg)
+	* On ARC, Return reg = First Arg reg = r0.
+	* Since we already have last task in r0,
+	* don't need to do anything special to return it
+	*/
+
+	/* hardware memory barrier */
+	sync
+
+	/*
+	 * switch to new task, contained in r1
+	 * Temp reg r3 is required to get the ptr to store val
+	 */
+	SET_CURR_TASK_ON_CPU  r1, r3
+
+	/* reload SP with kernel mode stack pointer in task->thread.ksp */
+	ld.as  sp, [r1, (TASK_THREAD + THREAD_KSP)/4]
+
+	/* restore the registers */
+	RESTORE_CALLEE_SAVED_KERNEL
+	ld.ab   fp, [sp, 4]
+	ld.ab   blink, [sp, 4]
+	j       [blink]
+
+ARC_EXIT __switch_to
diff --git a/arch/arc/kernel/fpu.c b/arch/arc/kernel/fpu.c
new file mode 100644
index 0000000..f352e51
--- /dev/null
+++ b/arch/arc/kernel/fpu.c
@@ -0,0 +1,55 @@
+/*
+ * fpu.c - save/restore of Floating Point Unit Registers on task switch
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/sched.h>
+#include <asm/switch_to.h>
+
+/*
+ * To save/restore FPU regs, simplest scheme would use LR/SR insns.
+ * However since SR serializes the pipeline, an alternate "hack" can be used
+ * which uses the FPU Exchange insn (DEXCL) to r/w FPU regs.
+ *
+ * Store to 64bit dpfp1 reg from a pair of core regs:
+ *   dexcl1 0, r1, r0  ; where r1:r0 is the 64 bit val
+ *
+ * Read from dpfp1 into pair of core regs (w/o clobbering dpfp1)
+ *   mov_s    r3, 0
+ *   daddh11  r1, r3, r3   ; get "hi" into r1 (dpfp1 unchanged)
+ *   dexcl1   r0, r1, r3   ; get "low" into r0 (dpfp1 low clobbered)
+ *   dexcl1    0, r1, r0   ; restore dpfp1 to orig value
+ *
+ * However we can tweak the read, so that read-out of outgoing task's FPU regs
+ * and write of incoming task's regs happen in one shot. So all the work is
+ * done before context switch
+ */
+
+void fpu_save_restore(struct task_struct *prev, struct task_struct *next)
+{
+	unsigned int *saveto = &prev->thread.fpu.aux_dpfp[0].l;
+	unsigned int *readfrom = &next->thread.fpu.aux_dpfp[0].l;
+
+	const unsigned int zero = 0;
+
+	__asm__ __volatile__(
+		"daddh11  %0, %2, %2\n"
+		"dexcl1   %1, %3, %4\n"
+		: "=&r" (*(saveto + 1)), /* early clobber must here */
+		  "=&r" (*(saveto))
+		: "r" (zero), "r" (*(readfrom + 1)), "r" (*(readfrom))
+	);
+
+	__asm__ __volatile__(
+		"daddh22  %0, %2, %2\n"
+		"dexcl2   %1, %3, %4\n"
+		: "=&r"(*(saveto + 3)),	/* early clobber must here */
+		  "=&r"(*(saveto + 2))
+		: "r" (zero), "r" (*(readfrom + 3)), "r" (*(readfrom + 2))
+	);
+}
diff --git a/arch/arc/kernel/process.c b/arch/arc/kernel/process.c
index 21d1889..c116fa5 100644
--- a/arch/arc/kernel/process.c
+++ b/arch/arc/kernel/process.c
@@ -117,3 +117,204 @@ SYSCALL_DEFINE0(arc_gettls)
 {
 	return task_thread_info(current)->thr_ptr;
 }
+
+static inline void arch_idle(void)
+{
+	__asm__("sleep");
+}
+
+void cpu_idle(void)
+{
+	/* Since we SLEEP in idle loop, TIF_POLLING_NRFLAG can't be set */
+
+	/* endless idle loop with no priority at all */
+	while (1) {
+		tick_nohz_idle_enter();
+
+		while (!need_resched())
+			arch_idle();
+
+		tick_nohz_idle_exit();
+
+		preempt_enable_no_resched();
+		schedule();
+		preempt_disable();
+	}
+}
+
+void kernel_thread_helper(void)
+{
+	__asm__ __volatile__(
+		"mov   r0, r2	\n\t"
+		"mov   r1, r3	\n\t"
+		"j     [r1]	\n\t");
+}
+
+int kernel_thread(int (*fn) (void *), void *arg, unsigned long flags)
+{
+	struct pt_regs regs;
+
+	memset(&regs, 0, sizeof(regs));
+
+	regs.r2 = (unsigned long)arg;
+	regs.r3 = (unsigned long)fn;
+	regs.blink = (unsigned long)do_exit;
+	regs.ret = (unsigned long)kernel_thread_helper;
+	regs.status32 = read_aux_reg(0xa);
+
+	/* Ok, create the new process.. */
+	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, NULL,
+		       NULL);
+
+}
+EXPORT_SYMBOL(kernel_thread);
+
+asmlinkage void ret_from_fork(void);
+
+/* Layout of Child kernel mode stack as setup at the end of this function is
+ *
+ * |     ...        |
+ * |     ...        |
+ * |    unused      |
+ * |                |
+ * ------------------  <==== top of Stack (thread.ksp)
+ * |   UNUSED 1 word|
+ * ------------------
+ * |     r25        |
+ * ~                ~
+ * |    --to--      |   (CALLEE Regs of user mode)
+ * |     r13        |
+ * ------------------
+ * |     fp         |
+ * |    blink       |   @ret_from_fork
+ * ------------------
+ * |                |
+ * ~                ~
+ * ~                ~
+ * |                |
+ * ------------------
+ * |     r12        |
+ * ~                ~
+ * |    --to--      |   (scratch Regs of user mode)
+ * |     r0         |
+ * ------------------
+ * |   UNUSED 1 word|
+ * ------------------  <===== END of PAGE
+ */
+int copy_thread(unsigned long clone_flags,
+		unsigned long usp, unsigned long topstk,
+		struct task_struct *p, struct pt_regs *regs)
+{
+	struct pt_regs *c_regs;        /* child's pt_regs */
+	unsigned long *childksp;       /* to unwind out of __switch_to() */
+	struct callee_regs *c_callee;  /* child's callee regs */
+	struct callee_regs *parent_callee;  /* paren't callee */
+
+	/* Mark the specific anchors to begin with (see pic above) */
+	c_regs = task_pt_regs(p);
+	childksp = (unsigned long *)c_regs - 2;  /* 2 words for FP/BLINK */
+	c_callee = ((struct callee_regs *)childksp) - 1;
+
+	/*
+	 * At the end of this function, kernel SP is all set for
+	 * switch_to to start unwinding.
+	 * For kernel threads we don't have callee regs, but the stack
+	 * layout nevertheless needs to remain the same
+	 */
+	p->thread.ksp = (unsigned long)c_callee;	/* THREAD_KSP */
+
+	/* Copy parents pt regs on child's kernel mode stack */
+	*c_regs = *regs;
+
+	/* __switch_to expects FP(0), BLINK(return addr) at top of stack */
+	childksp[0] = 0;				/* for POP fp */
+	childksp[1] = (unsigned long)ret_from_fork;	/* for POP blink */
+
+	if (!(user_mode(regs))) {
+		c_regs->sp =
+		    (unsigned long)task_thread_info(p) + (THREAD_SIZE - 4);
+		return 0;
+	}
+
+	/*--------- User Task Only --------------*/
+
+	c_regs->sp = usp;
+	c_regs->r0 = 0;		/* fork returns 0 in child */
+
+	parent_callee = ((struct callee_regs *)regs) - 1;
+	*c_callee = *parent_callee;
+
+	if (unlikely(clone_flags & CLONE_SETTLS)) {
+		/*
+		 * set task's userland tls data ptr from 4th arg
+		 * clone C-lib call is difft from clone sys-call
+		 */
+		task_thread_info(p)->thr_ptr = regs->r3;
+	} else {
+		/* Normal fork case: set parent's TLS ptr in child */
+		task_thread_info(p)->thr_ptr =
+		task_thread_info(current)->thr_ptr;
+	}
+
+	return 0;
+}
+
+/*
+ * Some archs flush debug and FPU info here
+ */
+void flush_thread(void)
+{
+}
+
+/*
+ * Free any architecture-specific thread data structures, etc.
+ */
+void exit_thread(void)
+{
+}
+
+int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpu)
+{
+	return 0;
+}
+
+/*
+ * API: expected by schedular Code: If thread is sleeping where is that.
+ * What is this good for? it will be always the scheduler or ret_from_fork.
+ * So we hard code that anyways.
+ */
+unsigned long thread_saved_pc(struct task_struct *t)
+{
+	struct pt_regs *regs = task_pt_regs(t);
+	unsigned long blink = 0;
+
+	/*
+	 * If the thread being queried for in not itself calling this, then it
+	 * implies it is not executing, which in turn implies it is sleeping,
+	 * which in turn implies it got switched OUT by the schedular.
+	 * In that case, it's kernel mode blink can reliably retrieved as per
+	 * the picture above (right above pt_regs).
+	 */
+	if (t != current && t->state != TASK_RUNNING)
+		blink = *((unsigned int *)regs - 1);
+
+	return blink;
+}
+
+int elf_check_arch(const struct elf32_hdr *x)
+{
+	unsigned int eflags;
+
+	if (x->e_machine != EM_ARCOMPACT)
+		return 0;
+
+	eflags = x->e_flags;
+	if ((eflags & EF_ARC_OSABI_MSK) < EF_ARC_OSABI_V2) {
+		pr_err("ABI mismatch - you need newer toolchain\n");
+		force_sigsegv(SIGSEGV, current);
+		return 0;
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL(elf_check_arch);
diff --git a/arch/arc/kernel/time.c b/arch/arc/kernel/time.c
new file mode 100644
index 0000000..a0aa884
--- /dev/null
+++ b/arch/arc/kernel/time.c
@@ -0,0 +1,237 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * vineetg: Jan 1011
+ *  -sched_clock( ) no longer jiffies based. Uses the same clocksource
+ *   as gtod
+ *
+ * Rajeshwarr/Vineetg: Mar 2008
+ *  -Implemented CONFIG_GENERIC_TIME (rather deleted arch specific code)
+ *   for arch independent gettimeofday()
+ *  -Implemented CONFIG_GENERIC_CLOCKEVENTS as base for hrtimers
+ *
+ * Vineetg: Mar 2008: Forked off from time.c which now is time-jiff.c
+ */
+
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/time.h>
+#include <linux/init.h>
+#include <linux/timex.h>
+#include <linux/profile.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <asm/irq.h>
+#include <asm/arcregs.h>
+
+/* ARC700 has two 32bit independent prog Timers: TIMER0 and TIMER1
+ * Each can programmed to go from @count to @limit and optionally
+ * interrupt when that happens
+ *
+ * We've designated TIMER0 for events (clockevents)
+ * while TIMER1 for free running (clocksource)
+ */
+#define ARC_TIMER_MAX	0xFFFFFFFF
+
+/******************************************************************
+ * Hardware Interface routines to program the ARC TIMERs
+ ******************************************************************/
+
+/*
+ * Arm the timer to interrupt after @limit cycles
+ */
+static void arc_periodic_timer_setup(unsigned int limit)
+{
+	/* setup start and end markers */
+	write_aux_reg(ARC_REG_TIMER0_LIMIT, limit);
+	write_aux_reg(ARC_REG_TIMER0_CNT, 0);	/* start from 0 */
+
+	/* IE: Interrupt on count = limit,
+	 * NH: Count cycles only when CPU running (NOT Halted)
+	 */
+	write_aux_reg(ARC_REG_TIMER0_CTRL, TIMER_CTRL_IE | TIMER_CTRL_NH);
+}
+
+/*
+ * Acknowledge the interrupt & enable/disable the interrupt
+ */
+static void arc_periodic_timer_ack(unsigned int irq_reenable)
+{
+	/* 1. Ack the interrupt by writing to CTRL reg.
+	 *    Any write will cause intr to be ack, however it has to be one of
+	 *    writable bits (NH: Count when not halted)
+	 * 2. If required by caller, re-arm timer to Interrupt at the end of
+	 *    next cycle.
+	 *
+	 * Small optimisation:
+	 * Normal code would have been
+	 *  if (irq_reenable) CTRL_REG = (IE | NH); else CTRL_REG = NH;
+	 * However since IE is BIT0 we can fold the branch
+	 */
+	write_aux_reg(ARC_REG_TIMER0_CTRL, irq_reenable | TIMER_CTRL_NH);
+}
+
+/*
+ * Arm the timer to keep counting monotonically
+ */
+void __cpuinit arc_clock_counter_setup(void)
+{
+	unsigned int limit = ARC_TIMER_MAX;
+
+	/* although for free flowing case, limit would alway be max 32 bits
+	 * still we've kept the interface open, just in case ...
+	 */
+	write_aux_reg(ARC_REG_TIMER1_LIMIT, limit);
+	write_aux_reg(ARC_REG_TIMER1_CNT, 0);
+	write_aux_reg(ARC_REG_TIMER1_CTRL, TIMER_CTRL_NH);
+}
+
+/********** Clock Source Device *********/
+
+static cycle_t cycle_read_t1(struct clocksource *cs)
+{
+	return (cycle_t) read_aux_reg(ARC_REG_TIMER1_CNT);
+}
+
+static struct clocksource clocksource_t1 = {
+	.name = "ARC Timer1",
+	.rating = 300,
+	.read = cycle_read_t1,
+	.mask = CLOCKSOURCE_MASK(32),
+	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+void __cpuinit arc_clocksource_init(void)
+{
+	arc_clock_counter_setup();
+
+	/*
+	 * CLK upto 4.29 GHz can be safely represented in 32 bits because
+	 * Max 32 bit number is 4,294,967,295
+	 */
+	clocksource_register_hz(&clocksource_t1, CONFIG_ARC_PLAT_CLK);
+}
+
+/********** Clock Event Device *********/
+
+static int arc_clkevent_set_next_event(unsigned long delta,
+				    struct clock_event_device *dev)
+{
+	arc_periodic_timer_setup(delta);
+	return 0;
+}
+
+static void arc_clkevent_set_mode(enum clock_event_mode mode,
+			       struct clock_event_device *dev)
+{
+	pr_info("Device [%s] clockevent mode now [%d]\n", dev->name, mode);
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		arc_periodic_timer_setup(CONFIG_ARC_PLAT_CLK / HZ);
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		break;
+	default:
+		break;
+	}
+
+	return;
+}
+
+static DEFINE_PER_CPU(struct clock_event_device, arc_clockevent_device) = {
+	.name		= "ARC Timer0",
+	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
+	.mode		= CLOCK_EVT_MODE_UNUSED,
+	.rating		= 300,
+	.irq		= TIMER0_IRQ,	/* hardwired, no need for resources */
+	.set_next_event = arc_clkevent_set_next_event,
+	.set_mode	= arc_clkevent_set_mode,
+};
+
+irqreturn_t timer_irq_handler(int irq, void *dev_id)
+{
+	unsigned int cpu = smp_processor_id();
+	struct clock_event_device *evt = &per_cpu(arc_clockevent_device, cpu);
+
+	arc_periodic_timer_ack(evt->mode == CLOCK_EVT_MODE_PERIODIC);
+	evt->event_handler(evt);
+	return IRQ_HANDLED;
+}
+
+void __cpuinit arc_clockevent_init(void)
+{
+	int rc;
+	unsigned int cpu = smp_processor_id();
+	struct clock_event_device *evt = &per_cpu(arc_clockevent_device, cpu);
+
+	clockevents_calc_mult_shift(evt, CONFIG_ARC_PLAT_CLK, 5);
+
+	evt->max_delta_ns = clockevent_delta2ns(ARC_TIMER_MAX, evt);
+	evt->cpumask = cpumask_of(cpu);
+
+	clockevents_register_device(evt);
+
+	/*
+	 * Done only on Boot CPU as it would fail on others.
+	 * (Treated a re-registration for a !IRQF_SHARED irq)
+	 */
+	if (cpu == 0) {
+		rc = request_percpu_irq(TIMER0_IRQ, timer_irq_handler,
+					"Timer0 (clock-evt-dev)", evt);
+
+		if (rc)
+			panic("TIMER0 IRQ reg failed on BOOT cpu\n");
+	}
+
+	/* This is done on each CPU */
+	enable_percpu_irq(TIMER0_IRQ, 0);
+
+}
+
+void __init time_init(void)
+{
+	arc_clocksource_init();
+	arc_clockevent_init();
+}
+
+static int arc_finished_booting;
+
+/*
+ * Scheduler clock - returns current time in nanosec units.
+ * It's return value must NOT wrap around.
+ *
+ * Although the return value is nanosec units based, what's more important
+ * is whats the "source" of this value. The orig jiffies based computation
+ * was only as granular as jiffies itself (10ms on ARC).
+ * We need something that is more granular, so use the same mechanism as
+ * gettimeofday(), which uses ARC Timer T1 wrapped as a clocksource.
+ * Unfortunately the first call to sched_clock( ) is way before that subsys
+ * is initialiased, thus use the jiffies based value in the interim.
+ */
+unsigned long long sched_clock(void)
+{
+	if (!arc_finished_booting) {
+		return (unsigned long long)(jiffies - INITIAL_JIFFIES)
+		    * (NSEC_PER_SEC / HZ);
+	} else {
+		struct timespec ts;
+		getrawmonotonic(&ts);
+		return (unsigned long long)timespec_to_ns(&ts);
+	}
+}
+
+static int __init arc_clocksource_done_booting(void)
+{
+	arc_finished_booting = 1;
+	return 0;
+}
+
+fs_initcall(arc_clocksource_done_booting);
-- 
1.7.4.1

