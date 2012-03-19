Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032199Ab2CSQzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:55:06 -0400
Received: from mail-wg0-f66.google.com ([74.125.82.66]:56372 "EHLO
	mail-wg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031917Ab2CSQy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:54:58 -0400
Date: Mon, 19 Mar 2012 17:54:54 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/fpu changes for v3.4
Message-ID: <20120319165454.GA12831@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-fpu-for-linus

   HEAD: 1361b83a13d4d92e53fbb6c877528713e118b821 i387: Split up <asm/i387.h> into exported and internal interfaces

 Thanks,

	Ingo

------------------>
Linus Torvalds (2):
      i387: Uninline the generic FP helpers that we expose to kernel modules
      i387: Split up <asm/i387.h> into exported and internal interfaces


 arch/x86/ia32/ia32_signal.c         |    1 +
 arch/x86/include/asm/fpu-internal.h |  520 ++++++++++++++++++++++++++++++
 arch/x86/include/asm/i387.h         |  590 +----------------------------------
 arch/x86/kernel/cpu/common.c        |    3 +-
 arch/x86/kernel/i387.c              |   83 +++++-
 arch/x86/kernel/process.c           |    1 +
 arch/x86/kernel/process_32.c        |    1 +
 arch/x86/kernel/process_64.c        |    1 +
 arch/x86/kernel/ptrace.c            |    1 +
 arch/x86/kernel/signal.c            |    1 +
 arch/x86/kernel/traps.c             |    1 +
 arch/x86/kernel/xsave.c             |    1 +
 arch/x86/kvm/vmx.c                  |    2 +-
 arch/x86/kvm/x86.c                  |    1 +
 arch/x86/power/cpu.c                |    1 +
 15 files changed, 624 insertions(+), 584 deletions(-)
 create mode 100644 arch/x86/include/asm/fpu-internal.h

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 6557769..5563ba1 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -24,6 +24,7 @@
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/i387.h>
+#include <asm/fpu-internal.h>
 #include <asm/ptrace.h>
 #include <asm/ia32_unistd.h>
 #include <asm/user32.h>
diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
new file mode 100644
index 0000000..4fa8815
--- /dev/null
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -0,0 +1,520 @@
+/*
+ * Copyright (C) 1994 Linus Torvalds
+ *
+ * Pentium III FXSR, SSE support
+ * General FPU state handling cleanups
+ *	Gareth Hughes <gareth@valinux.com>, May 2000
+ * x86-64 work by Andi Kleen 2002
+ */
+
+#ifndef _FPU_INTERNAL_H
+#define _FPU_INTERNAL_H
+
+#include <linux/kernel_stat.h>
+#include <linux/regset.h>
+#include <linux/slab.h>
+#include <asm/asm.h>
+#include <asm/cpufeature.h>
+#include <asm/processor.h>
+#include <asm/sigcontext.h>
+#include <asm/user.h>
+#include <asm/uaccess.h>
+#include <asm/xsave.h>
+
+extern unsigned int sig_xstate_size;
+extern void fpu_init(void);
+
+DECLARE_PER_CPU(struct task_struct *, fpu_owner_task);
+
+extern user_regset_active_fn fpregs_active, xfpregs_active;
+extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get,
+				xstateregs_get;
+extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set,
+				 xstateregs_set;
+
+
+/*
+ * xstateregs_active == fpregs_active. Please refer to the comment
+ * at the definition of fpregs_active.
+ */
+#define xstateregs_active	fpregs_active
+
+extern struct _fpx_sw_bytes fx_sw_reserved;
+#ifdef CONFIG_IA32_EMULATION
+extern unsigned int sig_xstate_ia32_size;
+extern struct _fpx_sw_bytes fx_sw_reserved_ia32;
+struct _fpstate_ia32;
+struct _xstate_ia32;
+extern int save_i387_xstate_ia32(void __user *buf);
+extern int restore_i387_xstate_ia32(void __user *buf);
+#endif
+
+#ifdef CONFIG_MATH_EMULATION
+extern void finit_soft_fpu(struct i387_soft_struct *soft);
+#else
+static inline void finit_soft_fpu(struct i387_soft_struct *soft) {}
+#endif
+
+#define X87_FSW_ES (1 << 7)	/* Exception Summary */
+
+static __always_inline __pure bool use_xsaveopt(void)
+{
+	return static_cpu_has(X86_FEATURE_XSAVEOPT);
+}
+
+static __always_inline __pure bool use_xsave(void)
+{
+	return static_cpu_has(X86_FEATURE_XSAVE);
+}
+
+static __always_inline __pure bool use_fxsr(void)
+{
+        return static_cpu_has(X86_FEATURE_FXSR);
+}
+
+extern void __sanitize_i387_state(struct task_struct *);
+
+static inline void sanitize_i387_state(struct task_struct *tsk)
+{
+	if (!use_xsaveopt())
+		return;
+	__sanitize_i387_state(tsk);
+}
+
+#ifdef CONFIG_X86_64
+static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
+{
+	int err;
+
+	/* See comment in fxsave() below. */
+#ifdef CONFIG_AS_FXSAVEQ
+	asm volatile("1:  fxrstorq %[fx]\n\t"
+		     "2:\n"
+		     ".section .fixup,\"ax\"\n"
+		     "3:  movl $-1,%[err]\n"
+		     "    jmp  2b\n"
+		     ".previous\n"
+		     _ASM_EXTABLE(1b, 3b)
+		     : [err] "=r" (err)
+		     : [fx] "m" (*fx), "0" (0));
+#else
+	asm volatile("1:  rex64/fxrstor (%[fx])\n\t"
+		     "2:\n"
+		     ".section .fixup,\"ax\"\n"
+		     "3:  movl $-1,%[err]\n"
+		     "    jmp  2b\n"
+		     ".previous\n"
+		     _ASM_EXTABLE(1b, 3b)
+		     : [err] "=r" (err)
+		     : [fx] "R" (fx), "m" (*fx), "0" (0));
+#endif
+	return err;
+}
+
+static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
+{
+	int err;
+
+	/*
+	 * Clear the bytes not touched by the fxsave and reserved
+	 * for the SW usage.
+	 */
+	err = __clear_user(&fx->sw_reserved,
+			   sizeof(struct _fpx_sw_bytes));
+	if (unlikely(err))
+		return -EFAULT;
+
+	/* See comment in fxsave() below. */
+#ifdef CONFIG_AS_FXSAVEQ
+	asm volatile("1:  fxsaveq %[fx]\n\t"
+		     "2:\n"
+		     ".section .fixup,\"ax\"\n"
+		     "3:  movl $-1,%[err]\n"
+		     "    jmp  2b\n"
+		     ".previous\n"
+		     _ASM_EXTABLE(1b, 3b)
+		     : [err] "=r" (err), [fx] "=m" (*fx)
+		     : "0" (0));
+#else
+	asm volatile("1:  rex64/fxsave (%[fx])\n\t"
+		     "2:\n"
+		     ".section .fixup,\"ax\"\n"
+		     "3:  movl $-1,%[err]\n"
+		     "    jmp  2b\n"
+		     ".previous\n"
+		     _ASM_EXTABLE(1b, 3b)
+		     : [err] "=r" (err), "=m" (*fx)
+		     : [fx] "R" (fx), "0" (0));
+#endif
+	if (unlikely(err) &&
+	    __clear_user(fx, sizeof(struct i387_fxsave_struct)))
+		err = -EFAULT;
+	/* No need to clear here because the caller clears USED_MATH */
+	return err;
+}
+
+static inline void fpu_fxsave(struct fpu *fpu)
+{
+	/* Using "rex64; fxsave %0" is broken because, if the memory operand
+	   uses any extended registers for addressing, a second REX prefix
+	   will be generated (to the assembler, rex64 followed by semicolon
+	   is a separate instruction), and hence the 64-bitness is lost. */
+
+#ifdef CONFIG_AS_FXSAVEQ
+	/* Using "fxsaveq %0" would be the ideal choice, but is only supported
+	   starting with gas 2.16. */
+	__asm__ __volatile__("fxsaveq %0"
+			     : "=m" (fpu->state->fxsave));
+#else
+	/* Using, as a workaround, the properly prefixed form below isn't
+	   accepted by any binutils version so far released, complaining that
+	   the same type of prefix is used twice if an extended register is
+	   needed for addressing (fix submitted to mainline 2005-11-21).
+	asm volatile("rex64/fxsave %0"
+		     : "=m" (fpu->state->fxsave));
+	   This, however, we can work around by forcing the compiler to select
+	   an addressing mode that doesn't require extended registers. */
+	asm volatile("rex64/fxsave (%[fx])"
+		     : "=m" (fpu->state->fxsave)
+		     : [fx] "R" (&fpu->state->fxsave));
+#endif
+}
+
+#else  /* CONFIG_X86_32 */
+
+/* perform fxrstor iff the processor has extended states, otherwise frstor */
+static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
+{
+	/*
+	 * The "nop" is needed to make the instructions the same
+	 * length.
+	 */
+	alternative_input(
+		"nop ; frstor %1",
+		"fxrstor %1",
+		X86_FEATURE_FXSR,
+		"m" (*fx));
+
+	return 0;
+}
+
+static inline void fpu_fxsave(struct fpu *fpu)
+{
+	asm volatile("fxsave %[fx]"
+		     : [fx] "=m" (fpu->state->fxsave));
+}
+
+#endif	/* CONFIG_X86_64 */
+
+/*
+ * These must be called with preempt disabled. Returns
+ * 'true' if the FPU state is still intact.
+ */
+static inline int fpu_save_init(struct fpu *fpu)
+{
+	if (use_xsave()) {
+		fpu_xsave(fpu);
+
+		/*
+		 * xsave header may indicate the init state of the FP.
+		 */
+		if (!(fpu->state->xsave.xsave_hdr.xstate_bv & XSTATE_FP))
+			return 1;
+	} else if (use_fxsr()) {
+		fpu_fxsave(fpu);
+	} else {
+		asm volatile("fnsave %[fx]; fwait"
+			     : [fx] "=m" (fpu->state->fsave));
+		return 0;
+	}
+
+	/*
+	 * If exceptions are pending, we need to clear them so
+	 * that we don't randomly get exceptions later.
+	 *
+	 * FIXME! Is this perhaps only true for the old-style
+	 * irq13 case? Maybe we could leave the x87 state
+	 * intact otherwise?
+	 */
+	if (unlikely(fpu->state->fxsave.swd & X87_FSW_ES)) {
+		asm volatile("fnclex");
+		return 0;
+	}
+	return 1;
+}
+
+static inline int __save_init_fpu(struct task_struct *tsk)
+{
+	return fpu_save_init(&tsk->thread.fpu);
+}
+
+static inline int fpu_fxrstor_checking(struct fpu *fpu)
+{
+	return fxrstor_checking(&fpu->state->fxsave);
+}
+
+static inline int fpu_restore_checking(struct fpu *fpu)
+{
+	if (use_xsave())
+		return fpu_xrstor_checking(fpu);
+	else
+		return fpu_fxrstor_checking(fpu);
+}
+
+static inline int restore_fpu_checking(struct task_struct *tsk)
+{
+	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
+	   is pending.  Clear the x87 state here by setting it to fixed
+	   values. "m" is a random variable that should be in L1 */
+	alternative_input(
+		ASM_NOP8 ASM_NOP2,
+		"emms\n\t"		/* clear stack tags */
+		"fildl %P[addr]",	/* set F?P to defined value */
+		X86_FEATURE_FXSAVE_LEAK,
+		[addr] "m" (tsk->thread.fpu.has_fpu));
+
+	return fpu_restore_checking(&tsk->thread.fpu);
+}
+
+/*
+ * Software FPU state helpers. Careful: these need to
+ * be preemption protection *and* they need to be
+ * properly paired with the CR0.TS changes!
+ */
+static inline int __thread_has_fpu(struct task_struct *tsk)
+{
+	return tsk->thread.fpu.has_fpu;
+}
+
+/* Must be paired with an 'stts' after! */
+static inline void __thread_clear_has_fpu(struct task_struct *tsk)
+{
+	tsk->thread.fpu.has_fpu = 0;
+	percpu_write(fpu_owner_task, NULL);
+}
+
+/* Must be paired with a 'clts' before! */
+static inline void __thread_set_has_fpu(struct task_struct *tsk)
+{
+	tsk->thread.fpu.has_fpu = 1;
+	percpu_write(fpu_owner_task, tsk);
+}
+
+/*
+ * Encapsulate the CR0.TS handling together with the
+ * software flag.
+ *
+ * These generally need preemption protection to work,
+ * do try to avoid using these on their own.
+ */
+static inline void __thread_fpu_end(struct task_struct *tsk)
+{
+	__thread_clear_has_fpu(tsk);
+	stts();
+}
+
+static inline void __thread_fpu_begin(struct task_struct *tsk)
+{
+	clts();
+	__thread_set_has_fpu(tsk);
+}
+
+/*
+ * FPU state switching for scheduling.
+ *
+ * This is a two-stage process:
+ *
+ *  - switch_fpu_prepare() saves the old state and
+ *    sets the new state of the CR0.TS bit. This is
+ *    done within the context of the old process.
+ *
+ *  - switch_fpu_finish() restores the new state as
+ *    necessary.
+ */
+typedef struct { int preload; } fpu_switch_t;
+
+/*
+ * FIXME! We could do a totally lazy restore, but we need to
+ * add a per-cpu "this was the task that last touched the FPU
+ * on this CPU" variable, and the task needs to have a "I last
+ * touched the FPU on this CPU" and check them.
+ *
+ * We don't do that yet, so "fpu_lazy_restore()" always returns
+ * false, but some day..
+ */
+static inline int fpu_lazy_restore(struct task_struct *new, unsigned int cpu)
+{
+	return new == percpu_read_stable(fpu_owner_task) &&
+		cpu == new->thread.fpu.last_cpu;
+}
+
+static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct task_struct *new, int cpu)
+{
+	fpu_switch_t fpu;
+
+	fpu.preload = tsk_used_math(new) && new->fpu_counter > 5;
+	if (__thread_has_fpu(old)) {
+		if (!__save_init_fpu(old))
+			cpu = ~0;
+		old->thread.fpu.last_cpu = cpu;
+		old->thread.fpu.has_fpu = 0;	/* But leave fpu_owner_task! */
+
+		/* Don't change CR0.TS if we just switch! */
+		if (fpu.preload) {
+			new->fpu_counter++;
+			__thread_set_has_fpu(new);
+			prefetch(new->thread.fpu.state);
+		} else
+			stts();
+	} else {
+		old->fpu_counter = 0;
+		old->thread.fpu.last_cpu = ~0;
+		if (fpu.preload) {
+			new->fpu_counter++;
+			if (fpu_lazy_restore(new, cpu))
+				fpu.preload = 0;
+			else
+				prefetch(new->thread.fpu.state);
+			__thread_fpu_begin(new);
+		}
+	}
+	return fpu;
+}
+
+/*
+ * By the time this gets called, we've already cleared CR0.TS and
+ * given the process the FPU if we are going to preload the FPU
+ * state - all we need to do is to conditionally restore the register
+ * state itself.
+ */
+static inline void switch_fpu_finish(struct task_struct *new, fpu_switch_t fpu)
+{
+	if (fpu.preload) {
+		if (unlikely(restore_fpu_checking(new)))
+			__thread_fpu_end(new);
+	}
+}
+
+/*
+ * Signal frame handlers...
+ */
+extern int save_i387_xstate(void __user *buf);
+extern int restore_i387_xstate(void __user *buf);
+
+static inline void __clear_fpu(struct task_struct *tsk)
+{
+	if (__thread_has_fpu(tsk)) {
+		/* Ignore delayed exceptions from user space */
+		asm volatile("1: fwait\n"
+			     "2:\n"
+			     _ASM_EXTABLE(1b, 2b));
+		__thread_fpu_end(tsk);
+	}
+}
+
+/*
+ * The actual user_fpu_begin/end() functions
+ * need to be preemption-safe.
+ *
+ * NOTE! user_fpu_end() must be used only after you
+ * have saved the FP state, and user_fpu_begin() must
+ * be used only immediately before restoring it.
+ * These functions do not do any save/restore on
+ * their own.
+ */
+static inline void user_fpu_end(void)
+{
+	preempt_disable();
+	__thread_fpu_end(current);
+	preempt_enable();
+}
+
+static inline void user_fpu_begin(void)
+{
+	preempt_disable();
+	if (!user_has_fpu())
+		__thread_fpu_begin(current);
+	preempt_enable();
+}
+
+/*
+ * These disable preemption on their own and are safe
+ */
+static inline void save_init_fpu(struct task_struct *tsk)
+{
+	WARN_ON_ONCE(!__thread_has_fpu(tsk));
+	preempt_disable();
+	__save_init_fpu(tsk);
+	__thread_fpu_end(tsk);
+	preempt_enable();
+}
+
+static inline void clear_fpu(struct task_struct *tsk)
+{
+	preempt_disable();
+	__clear_fpu(tsk);
+	preempt_enable();
+}
+
+/*
+ * i387 state interaction
+ */
+static inline unsigned short get_fpu_cwd(struct task_struct *tsk)
+{
+	if (cpu_has_fxsr) {
+		return tsk->thread.fpu.state->fxsave.cwd;
+	} else {
+		return (unsigned short)tsk->thread.fpu.state->fsave.cwd;
+	}
+}
+
+static inline unsigned short get_fpu_swd(struct task_struct *tsk)
+{
+	if (cpu_has_fxsr) {
+		return tsk->thread.fpu.state->fxsave.swd;
+	} else {
+		return (unsigned short)tsk->thread.fpu.state->fsave.swd;
+	}
+}
+
+static inline unsigned short get_fpu_mxcsr(struct task_struct *tsk)
+{
+	if (cpu_has_xmm) {
+		return tsk->thread.fpu.state->fxsave.mxcsr;
+	} else {
+		return MXCSR_DEFAULT;
+	}
+}
+
+static bool fpu_allocated(struct fpu *fpu)
+{
+	return fpu->state != NULL;
+}
+
+static inline int fpu_alloc(struct fpu *fpu)
+{
+	if (fpu_allocated(fpu))
+		return 0;
+	fpu->state = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
+	if (!fpu->state)
+		return -ENOMEM;
+	WARN_ON((unsigned long)fpu->state & 15);
+	return 0;
+}
+
+static inline void fpu_free(struct fpu *fpu)
+{
+	if (fpu->state) {
+		kmem_cache_free(task_xstate_cachep, fpu->state);
+		fpu->state = NULL;
+	}
+}
+
+static inline void fpu_copy(struct fpu *dst, struct fpu *src)
+{
+	memcpy(dst->state, src->state, xstate_size);
+}
+
+extern void fpu_finit(struct fpu *fpu);
+
+#endif
diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 2479049..7ce0798 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -13,476 +13,19 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/sched.h>
-#include <linux/kernel_stat.h>
-#include <linux/regset.h>
 #include <linux/hardirq.h>
-#include <linux/slab.h>
-#include <asm/asm.h>
-#include <asm/cpufeature.h>
-#include <asm/processor.h>
-#include <asm/sigcontext.h>
-#include <asm/user.h>
-#include <asm/uaccess.h>
-#include <asm/xsave.h>
+#include <asm/system.h>
+
+struct pt_regs;
+struct user_i387_struct;
 
-extern unsigned int sig_xstate_size;
-extern void fpu_init(void);
-extern void mxcsr_feature_mask_init(void);
 extern int init_fpu(struct task_struct *child);
-extern void math_state_restore(void);
 extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
+extern void math_state_restore(void);
 
-DECLARE_PER_CPU(struct task_struct *, fpu_owner_task);
-
-extern user_regset_active_fn fpregs_active, xfpregs_active;
-extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get,
-				xstateregs_get;
-extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set,
-				 xstateregs_set;
-
-/*
- * xstateregs_active == fpregs_active. Please refer to the comment
- * at the definition of fpregs_active.
- */
-#define xstateregs_active	fpregs_active
-
-extern struct _fpx_sw_bytes fx_sw_reserved;
-#ifdef CONFIG_IA32_EMULATION
-extern unsigned int sig_xstate_ia32_size;
-extern struct _fpx_sw_bytes fx_sw_reserved_ia32;
-struct _fpstate_ia32;
-struct _xstate_ia32;
-extern int save_i387_xstate_ia32(void __user *buf);
-extern int restore_i387_xstate_ia32(void __user *buf);
-#endif
-
-#ifdef CONFIG_MATH_EMULATION
-extern void finit_soft_fpu(struct i387_soft_struct *soft);
-#else
-static inline void finit_soft_fpu(struct i387_soft_struct *soft) {}
-#endif
-
-#define X87_FSW_ES (1 << 7)	/* Exception Summary */
-
-static __always_inline __pure bool use_xsaveopt(void)
-{
-	return static_cpu_has(X86_FEATURE_XSAVEOPT);
-}
-
-static __always_inline __pure bool use_xsave(void)
-{
-	return static_cpu_has(X86_FEATURE_XSAVE);
-}
-
-static __always_inline __pure bool use_fxsr(void)
-{
-        return static_cpu_has(X86_FEATURE_FXSR);
-}
-
-extern void __sanitize_i387_state(struct task_struct *);
-
-static inline void sanitize_i387_state(struct task_struct *tsk)
-{
-	if (!use_xsaveopt())
-		return;
-	__sanitize_i387_state(tsk);
-}
-
-#ifdef CONFIG_X86_64
-static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
-{
-	int err;
-
-	/* See comment in fxsave() below. */
-#ifdef CONFIG_AS_FXSAVEQ
-	asm volatile("1:  fxrstorq %[fx]\n\t"
-		     "2:\n"
-		     ".section .fixup,\"ax\"\n"
-		     "3:  movl $-1,%[err]\n"
-		     "    jmp  2b\n"
-		     ".previous\n"
-		     _ASM_EXTABLE(1b, 3b)
-		     : [err] "=r" (err)
-		     : [fx] "m" (*fx), "0" (0));
-#else
-	asm volatile("1:  rex64/fxrstor (%[fx])\n\t"
-		     "2:\n"
-		     ".section .fixup,\"ax\"\n"
-		     "3:  movl $-1,%[err]\n"
-		     "    jmp  2b\n"
-		     ".previous\n"
-		     _ASM_EXTABLE(1b, 3b)
-		     : [err] "=r" (err)
-		     : [fx] "R" (fx), "m" (*fx), "0" (0));
-#endif
-	return err;
-}
-
-static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
-{
-	int err;
-
-	/*
-	 * Clear the bytes not touched by the fxsave and reserved
-	 * for the SW usage.
-	 */
-	err = __clear_user(&fx->sw_reserved,
-			   sizeof(struct _fpx_sw_bytes));
-	if (unlikely(err))
-		return -EFAULT;
-
-	/* See comment in fxsave() below. */
-#ifdef CONFIG_AS_FXSAVEQ
-	asm volatile("1:  fxsaveq %[fx]\n\t"
-		     "2:\n"
-		     ".section .fixup,\"ax\"\n"
-		     "3:  movl $-1,%[err]\n"
-		     "    jmp  2b\n"
-		     ".previous\n"
-		     _ASM_EXTABLE(1b, 3b)
-		     : [err] "=r" (err), [fx] "=m" (*fx)
-		     : "0" (0));
-#else
-	asm volatile("1:  rex64/fxsave (%[fx])\n\t"
-		     "2:\n"
-		     ".section .fixup,\"ax\"\n"
-		     "3:  movl $-1,%[err]\n"
-		     "    jmp  2b\n"
-		     ".previous\n"
-		     _ASM_EXTABLE(1b, 3b)
-		     : [err] "=r" (err), "=m" (*fx)
-		     : [fx] "R" (fx), "0" (0));
-#endif
-	if (unlikely(err) &&
-	    __clear_user(fx, sizeof(struct i387_fxsave_struct)))
-		err = -EFAULT;
-	/* No need to clear here because the caller clears USED_MATH */
-	return err;
-}
-
-static inline void fpu_fxsave(struct fpu *fpu)
-{
-	/* Using "rex64; fxsave %0" is broken because, if the memory operand
-	   uses any extended registers for addressing, a second REX prefix
-	   will be generated (to the assembler, rex64 followed by semicolon
-	   is a separate instruction), and hence the 64-bitness is lost. */
-
-#ifdef CONFIG_AS_FXSAVEQ
-	/* Using "fxsaveq %0" would be the ideal choice, but is only supported
-	   starting with gas 2.16. */
-	__asm__ __volatile__("fxsaveq %0"
-			     : "=m" (fpu->state->fxsave));
-#else
-	/* Using, as a workaround, the properly prefixed form below isn't
-	   accepted by any binutils version so far released, complaining that
-	   the same type of prefix is used twice if an extended register is
-	   needed for addressing (fix submitted to mainline 2005-11-21).
-	asm volatile("rex64/fxsave %0"
-		     : "=m" (fpu->state->fxsave));
-	   This, however, we can work around by forcing the compiler to select
-	   an addressing mode that doesn't require extended registers. */
-	asm volatile("rex64/fxsave (%[fx])"
-		     : "=m" (fpu->state->fxsave)
-		     : [fx] "R" (&fpu->state->fxsave));
-#endif
-}
-
-#else  /* CONFIG_X86_32 */
-
-/* perform fxrstor iff the processor has extended states, otherwise frstor */
-static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
-{
-	/*
-	 * The "nop" is needed to make the instructions the same
-	 * length.
-	 */
-	alternative_input(
-		"nop ; frstor %1",
-		"fxrstor %1",
-		X86_FEATURE_FXSR,
-		"m" (*fx));
-
-	return 0;
-}
-
-static inline void fpu_fxsave(struct fpu *fpu)
-{
-	asm volatile("fxsave %[fx]"
-		     : [fx] "=m" (fpu->state->fxsave));
-}
-
-#endif	/* CONFIG_X86_64 */
-
-/*
- * These must be called with preempt disabled. Returns
- * 'true' if the FPU state is still intact.
- */
-static inline int fpu_save_init(struct fpu *fpu)
-{
-	if (use_xsave()) {
-		fpu_xsave(fpu);
-
-		/*
-		 * xsave header may indicate the init state of the FP.
-		 */
-		if (!(fpu->state->xsave.xsave_hdr.xstate_bv & XSTATE_FP))
-			return 1;
-	} else if (use_fxsr()) {
-		fpu_fxsave(fpu);
-	} else {
-		asm volatile("fnsave %[fx]; fwait"
-			     : [fx] "=m" (fpu->state->fsave));
-		return 0;
-	}
-
-	/*
-	 * If exceptions are pending, we need to clear them so
-	 * that we don't randomly get exceptions later.
-	 *
-	 * FIXME! Is this perhaps only true for the old-style
-	 * irq13 case? Maybe we could leave the x87 state
-	 * intact otherwise?
-	 */
-	if (unlikely(fpu->state->fxsave.swd & X87_FSW_ES)) {
-		asm volatile("fnclex");
-		return 0;
-	}
-	return 1;
-}
-
-static inline int __save_init_fpu(struct task_struct *tsk)
-{
-	return fpu_save_init(&tsk->thread.fpu);
-}
-
-static inline int fpu_fxrstor_checking(struct fpu *fpu)
-{
-	return fxrstor_checking(&fpu->state->fxsave);
-}
-
-static inline int fpu_restore_checking(struct fpu *fpu)
-{
-	if (use_xsave())
-		return fpu_xrstor_checking(fpu);
-	else
-		return fpu_fxrstor_checking(fpu);
-}
-
-static inline int restore_fpu_checking(struct task_struct *tsk)
-{
-	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
-	   is pending.  Clear the x87 state here by setting it to fixed
-	   values. "m" is a random variable that should be in L1 */
-	alternative_input(
-		ASM_NOP8 ASM_NOP2,
-		"emms\n\t"	  	/* clear stack tags */
-		"fildl %P[addr]",	/* set F?P to defined value */
-		X86_FEATURE_FXSAVE_LEAK,
-		[addr] "m" (tsk->thread.fpu.has_fpu));
-
-	return fpu_restore_checking(&tsk->thread.fpu);
-}
-
-/*
- * Software FPU state helpers. Careful: these need to
- * be preemption protection *and* they need to be
- * properly paired with the CR0.TS changes!
- */
-static inline int __thread_has_fpu(struct task_struct *tsk)
-{
-	return tsk->thread.fpu.has_fpu;
-}
-
-/* Must be paired with an 'stts' after! */
-static inline void __thread_clear_has_fpu(struct task_struct *tsk)
-{
-	tsk->thread.fpu.has_fpu = 0;
-	percpu_write(fpu_owner_task, NULL);
-}
-
-/* Must be paired with a 'clts' before! */
-static inline void __thread_set_has_fpu(struct task_struct *tsk)
-{
-	tsk->thread.fpu.has_fpu = 1;
-	percpu_write(fpu_owner_task, tsk);
-}
-
-/*
- * Encapsulate the CR0.TS handling together with the
- * software flag.
- *
- * These generally need preemption protection to work,
- * do try to avoid using these on their own.
- */
-static inline void __thread_fpu_end(struct task_struct *tsk)
-{
-	__thread_clear_has_fpu(tsk);
-	stts();
-}
-
-static inline void __thread_fpu_begin(struct task_struct *tsk)
-{
-	clts();
-	__thread_set_has_fpu(tsk);
-}
-
-/*
- * FPU state switching for scheduling.
- *
- * This is a two-stage process:
- *
- *  - switch_fpu_prepare() saves the old state and
- *    sets the new state of the CR0.TS bit. This is
- *    done within the context of the old process.
- *
- *  - switch_fpu_finish() restores the new state as
- *    necessary.
- */
-typedef struct { int preload; } fpu_switch_t;
-
-/*
- * FIXME! We could do a totally lazy restore, but we need to
- * add a per-cpu "this was the task that last touched the FPU
- * on this CPU" variable, and the task needs to have a "I last
- * touched the FPU on this CPU" and check them.
- *
- * We don't do that yet, so "fpu_lazy_restore()" always returns
- * false, but some day..
- */
-static inline int fpu_lazy_restore(struct task_struct *new, unsigned int cpu)
-{
-	return new == percpu_read_stable(fpu_owner_task) &&
-		cpu == new->thread.fpu.last_cpu;
-}
-
-static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct task_struct *new, int cpu)
-{
-	fpu_switch_t fpu;
-
-	fpu.preload = tsk_used_math(new) && new->fpu_counter > 5;
-	if (__thread_has_fpu(old)) {
-		if (!__save_init_fpu(old))
-			cpu = ~0;
-		old->thread.fpu.last_cpu = cpu;
-		old->thread.fpu.has_fpu = 0;	/* But leave fpu_owner_task! */
-
-		/* Don't change CR0.TS if we just switch! */
-		if (fpu.preload) {
-			new->fpu_counter++;
-			__thread_set_has_fpu(new);
-			prefetch(new->thread.fpu.state);
-		} else
-			stts();
-	} else {
-		old->fpu_counter = 0;
-		old->thread.fpu.last_cpu = ~0;
-		if (fpu.preload) {
-			new->fpu_counter++;
-			if (fpu_lazy_restore(new, cpu))
-				fpu.preload = 0;
-			else
-				prefetch(new->thread.fpu.state);
-			__thread_fpu_begin(new);
-		}
-	}
-	return fpu;
-}
-
-/*
- * By the time this gets called, we've already cleared CR0.TS and
- * given the process the FPU if we are going to preload the FPU
- * state - all we need to do is to conditionally restore the register
- * state itself.
- */
-static inline void switch_fpu_finish(struct task_struct *new, fpu_switch_t fpu)
-{
-	if (fpu.preload) {
-		if (unlikely(restore_fpu_checking(new)))
-			__thread_fpu_end(new);
-	}
-}
-
-/*
- * Signal frame handlers...
- */
-extern int save_i387_xstate(void __user *buf);
-extern int restore_i387_xstate(void __user *buf);
-
-static inline void __clear_fpu(struct task_struct *tsk)
-{
-	if (__thread_has_fpu(tsk)) {
-		/* Ignore delayed exceptions from user space */
-		asm volatile("1: fwait\n"
-			     "2:\n"
-			     _ASM_EXTABLE(1b, 2b));
-		__thread_fpu_end(tsk);
-	}
-}
-
-/*
- * Were we in an interrupt that interrupted kernel mode?
- *
- * We can do a kernel_fpu_begin/end() pair *ONLY* if that
- * pair does nothing at all: the thread must not have fpu (so
- * that we don't try to save the FPU state), and TS must
- * be set (so that the clts/stts pair does nothing that is
- * visible in the interrupted kernel thread).
- */
-static inline bool interrupted_kernel_fpu_idle(void)
-{
-	return !__thread_has_fpu(current) &&
-		(read_cr0() & X86_CR0_TS);
-}
-
-/*
- * Were we in user mode (or vm86 mode) when we were
- * interrupted?
- *
- * Doing kernel_fpu_begin/end() is ok if we are running
- * in an interrupt context from user mode - we'll just
- * save the FPU state as required.
- */
-static inline bool interrupted_user_mode(void)
-{
-	struct pt_regs *regs = get_irq_regs();
-	return regs && user_mode_vm(regs);
-}
-
-/*
- * Can we use the FPU in kernel mode with the
- * whole "kernel_fpu_begin/end()" sequence?
- *
- * It's always ok in process context (ie "not interrupt")
- * but it is sometimes ok even from an irq.
- */
-static inline bool irq_fpu_usable(void)
-{
-	return !in_interrupt() ||
-		interrupted_user_mode() ||
-		interrupted_kernel_fpu_idle();
-}
-
-static inline void kernel_fpu_begin(void)
-{
-	struct task_struct *me = current;
-
-	WARN_ON_ONCE(!irq_fpu_usable());
-	preempt_disable();
-	if (__thread_has_fpu(me)) {
-		__save_init_fpu(me);
-		__thread_clear_has_fpu(me);
-		/* We do 'stts()' in kernel_fpu_end() */
-	} else {
-		percpu_write(fpu_owner_task, NULL);
-		clts();
-	}
-}
-
-static inline void kernel_fpu_end(void)
-{
-	stts();
-	preempt_enable();
-}
+extern bool irq_fpu_usable(void);
+extern void kernel_fpu_begin(void);
+extern void kernel_fpu_end(void);
 
 /*
  * Some instructions like VIA's padlock instructions generate a spurious
@@ -524,126 +67,13 @@ static inline void irq_ts_restore(int TS_state)
  * we can just assume we have FPU access - typically
  * to save the FP state - we'll just take a #NM
  * fault and get the FPU access back.
- *
- * The actual user_fpu_begin/end() functions
- * need to be preemption-safe, though.
- *
- * NOTE! user_fpu_end() must be used only after you
- * have saved the FP state, and user_fpu_begin() must
- * be used only immediately before restoring it.
- * These functions do not do any save/restore on
- * their own.
  */
 static inline int user_has_fpu(void)
 {
-	return __thread_has_fpu(current);
-}
-
-static inline void user_fpu_end(void)
-{
-	preempt_disable();
-	__thread_fpu_end(current);
-	preempt_enable();
-}
-
-static inline void user_fpu_begin(void)
-{
-	preempt_disable();
-	if (!user_has_fpu())
-		__thread_fpu_begin(current);
-	preempt_enable();
-}
-
-/*
- * These disable preemption on their own and are safe
- */
-static inline void save_init_fpu(struct task_struct *tsk)
-{
-	WARN_ON_ONCE(!__thread_has_fpu(tsk));
-	preempt_disable();
-	__save_init_fpu(tsk);
-	__thread_fpu_end(tsk);
-	preempt_enable();
-}
-
-static inline void unlazy_fpu(struct task_struct *tsk)
-{
-	preempt_disable();
-	if (__thread_has_fpu(tsk)) {
-		__save_init_fpu(tsk);
-		__thread_fpu_end(tsk);
-	} else
-		tsk->fpu_counter = 0;
-	preempt_enable();
-}
-
-static inline void clear_fpu(struct task_struct *tsk)
-{
-	preempt_disable();
-	__clear_fpu(tsk);
-	preempt_enable();
-}
-
-/*
- * i387 state interaction
- */
-static inline unsigned short get_fpu_cwd(struct task_struct *tsk)
-{
-	if (cpu_has_fxsr) {
-		return tsk->thread.fpu.state->fxsave.cwd;
-	} else {
-		return (unsigned short)tsk->thread.fpu.state->fsave.cwd;
-	}
-}
-
-static inline unsigned short get_fpu_swd(struct task_struct *tsk)
-{
-	if (cpu_has_fxsr) {
-		return tsk->thread.fpu.state->fxsave.swd;
-	} else {
-		return (unsigned short)tsk->thread.fpu.state->fsave.swd;
-	}
-}
-
-static inline unsigned short get_fpu_mxcsr(struct task_struct *tsk)
-{
-	if (cpu_has_xmm) {
-		return tsk->thread.fpu.state->fxsave.mxcsr;
-	} else {
-		return MXCSR_DEFAULT;
-	}
-}
-
-static bool fpu_allocated(struct fpu *fpu)
-{
-	return fpu->state != NULL;
-}
-
-static inline int fpu_alloc(struct fpu *fpu)
-{
-	if (fpu_allocated(fpu))
-		return 0;
-	fpu->state = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
-	if (!fpu->state)
-		return -ENOMEM;
-	WARN_ON((unsigned long)fpu->state & 15);
-	return 0;
-}
-
-static inline void fpu_free(struct fpu *fpu)
-{
-	if (fpu->state) {
-		kmem_cache_free(task_xstate_cachep, fpu->state);
-		fpu->state = NULL;
-	}
-}
-
-static inline void fpu_copy(struct fpu *dst, struct fpu *src)
-{
-	memcpy(dst->state, src->state, xstate_size);
+	return current->thread.fpu.has_fpu;
 }
 
-extern void fpu_finit(struct fpu *fpu);
+extern void unlazy_fpu(struct task_struct *tsk);
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c0f7d68..89620b1 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -28,6 +28,7 @@
 #include <asm/apic.h>
 #include <asm/desc.h>
 #include <asm/i387.h>
+#include <asm/fpu-internal.h>
 #include <asm/mtrr.h>
 #include <linux/numa.h>
 #include <asm/asm.h>
@@ -1045,7 +1046,6 @@ DEFINE_PER_CPU(char *, irq_stack_ptr) =
 DEFINE_PER_CPU(unsigned int, irq_count) = -1;
 
 DEFINE_PER_CPU(struct task_struct *, fpu_owner_task);
-EXPORT_PER_CPU_SYMBOL(fpu_owner_task);
 
 /*
  * Special IST stacks which the CPU switches to when it calls
@@ -1115,7 +1115,6 @@ void debug_stack_reset(void)
 DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
 EXPORT_PER_CPU_SYMBOL(current_task);
 DEFINE_PER_CPU(struct task_struct *, fpu_owner_task);
-EXPORT_PER_CPU_SYMBOL(fpu_owner_task);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 DEFINE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 739d859..7734bcb 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -16,6 +16,7 @@
 #include <asm/uaccess.h>
 #include <asm/ptrace.h>
 #include <asm/i387.h>
+#include <asm/fpu-internal.h>
 #include <asm/user.h>
 
 #ifdef CONFIG_X86_64
@@ -32,6 +33,86 @@
 # define user32_fxsr_struct	user_fxsr_struct
 #endif
 
+/*
+ * Were we in an interrupt that interrupted kernel mode?
+ *
+ * We can do a kernel_fpu_begin/end() pair *ONLY* if that
+ * pair does nothing at all: the thread must not have fpu (so
+ * that we don't try to save the FPU state), and TS must
+ * be set (so that the clts/stts pair does nothing that is
+ * visible in the interrupted kernel thread).
+ */
+static inline bool interrupted_kernel_fpu_idle(void)
+{
+	return !__thread_has_fpu(current) &&
+		(read_cr0() & X86_CR0_TS);
+}
+
+/*
+ * Were we in user mode (or vm86 mode) when we were
+ * interrupted?
+ *
+ * Doing kernel_fpu_begin/end() is ok if we are running
+ * in an interrupt context from user mode - we'll just
+ * save the FPU state as required.
+ */
+static inline bool interrupted_user_mode(void)
+{
+	struct pt_regs *regs = get_irq_regs();
+	return regs && user_mode_vm(regs);
+}
+
+/*
+ * Can we use the FPU in kernel mode with the
+ * whole "kernel_fpu_begin/end()" sequence?
+ *
+ * It's always ok in process context (ie "not interrupt")
+ * but it is sometimes ok even from an irq.
+ */
+bool irq_fpu_usable(void)
+{
+	return !in_interrupt() ||
+		interrupted_user_mode() ||
+		interrupted_kernel_fpu_idle();
+}
+EXPORT_SYMBOL(irq_fpu_usable);
+
+void kernel_fpu_begin(void)
+{
+	struct task_struct *me = current;
+
+	WARN_ON_ONCE(!irq_fpu_usable());
+	preempt_disable();
+	if (__thread_has_fpu(me)) {
+		__save_init_fpu(me);
+		__thread_clear_has_fpu(me);
+		/* We do 'stts()' in kernel_fpu_end() */
+	} else {
+		percpu_write(fpu_owner_task, NULL);
+		clts();
+	}
+}
+EXPORT_SYMBOL(kernel_fpu_begin);
+
+void kernel_fpu_end(void)
+{
+	stts();
+	preempt_enable();
+}
+EXPORT_SYMBOL(kernel_fpu_end);
+
+void unlazy_fpu(struct task_struct *tsk)
+{
+	preempt_disable();
+	if (__thread_has_fpu(tsk)) {
+		__save_init_fpu(tsk);
+		__thread_fpu_end(tsk);
+	} else
+		tsk->fpu_counter = 0;
+	preempt_enable();
+}
+EXPORT_SYMBOL(unlazy_fpu);
+
 #ifdef CONFIG_MATH_EMULATION
 # define HAVE_HWFP		(boot_cpu_data.hard_math)
 #else
@@ -44,7 +125,7 @@ EXPORT_SYMBOL_GPL(xstate_size);
 unsigned int sig_xstate_ia32_size = sizeof(struct _fpstate_ia32);
 static struct i387_fxsave_struct fx_scratch __cpuinitdata;
 
-void __cpuinit mxcsr_feature_mask_init(void)
+static void __cpuinit mxcsr_feature_mask_init(void)
 {
 	unsigned long mask = 0;
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 15763af..c38d84e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -21,6 +21,7 @@
 #include <asm/idle.h>
 #include <asm/uaccess.h>
 #include <asm/i387.h>
+#include <asm/fpu-internal.h>
 #include <asm/debugreg.h>
 
 struct kmem_cache *task_xstate_cachep;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index c08d1ff..ee32dee 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -45,6 +45,7 @@
 #include <asm/ldt.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
+#include <asm/fpu-internal.h>
 #include <asm/desc.h>
 #ifdef CONFIG_MATH_EMULATION
 #include <asm/math_emu.h>
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index cfa5c90..5bad3c7 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -43,6 +43,7 @@
 #include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
+#include <asm/fpu-internal.h>
 #include <asm/mmu_context.h>
 #include <asm/prctl.h>
 #include <asm/desc.h>
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 5026738..78f05e4 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -27,6 +27,7 @@
 #include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
+#include <asm/fpu-internal.h>
 #include <asm/debugreg.h>
 #include <asm/ldt.h>
 #include <asm/desc.h>
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 46a01bd..25edcfc 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -24,6 +24,7 @@
 #include <asm/processor.h>
 #include <asm/ucontext.h>
 #include <asm/i387.h>
+#include <asm/fpu-internal.h>
 #include <asm/vdso.h>
 #include <asm/mce.h>
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 4bbe04d..ec61d4c 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -54,6 +54,7 @@
 #include <asm/traps.h>
 #include <asm/desc.h>
 #include <asm/i387.h>
+#include <asm/fpu-internal.h>
 #include <asm/mce.h>
 
 #include <asm/mach_traps.h>
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 7110911..e62728e 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -6,6 +6,7 @@
 #include <linux/bootmem.h>
 #include <linux/compat.h>
 #include <asm/i387.h>
+#include <asm/fpu-internal.h>
 #ifdef CONFIG_IA32_EMULATION
 #include <asm/sigcontext32.h>
 #endif
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 3b4c8d8..246490f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1457,7 +1457,7 @@ static void __vmx_load_host_state(struct vcpu_vmx *vmx)
 #ifdef CONFIG_X86_64
 	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
 #endif
-	if (__thread_has_fpu(current))
+	if (user_has_fpu())
 		clts();
 	load_gdt(&__get_cpu_var(host_gdt));
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9cbfc06..b937b61 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -57,6 +57,7 @@
 #include <asm/mtrr.h>
 #include <asm/mce.h>
 #include <asm/i387.h>
+#include <asm/fpu-internal.h> /* Ugh! */
 #include <asm/xcr.h>
 #include <asm/pvclock.h>
 #include <asm/div64.h>
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index f10c0af..4889655 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -20,6 +20,7 @@
 #include <asm/xcr.h>
 #include <asm/suspend.h>
 #include <asm/debugreg.h>
+#include <asm/fpu-internal.h> /* pcntxt_mask */
 
 #ifdef CONFIG_X86_32
 static struct saved_context saved_context;
