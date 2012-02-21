Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab2BUVlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 16:41:09 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48986 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab2BUVlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 16:41:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.68.196.161 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
Date: Tue, 21 Feb 2012 13:41:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@i5.linux-foundation.org
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Josh Boyer <jwboyer@gmail.com>, Jongman Heo <jongman.heo@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] i387: split up <asm/i387.h> into exported and internal
 interfaces
In-Reply-To: <alpine.LFD.2.02.1202211339590.5354@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1202211340330.5354@i5.linux-foundation.org>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org> <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org> <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com> <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com> <4F42FE08.5020309@zytor.com>
 <CA+55aFxKLvHXRkx-x+zOkHJk__uTJc90Z0i+00W-hqDaQb_HCQ@mail.gmail.com> <4F43DB69.9060509@zytor.com> <CA+55aFxap0zAAJOCcz0f+DKBuG6VQa7kq1j2JD1S4ysgmb62aA@mail.gmail.com> <4F440945.1020904@zytor.com> <alpine.LFD.2.02.1202211338420.5354@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202211339590.5354@i5.linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Feb 2012 13:19:22 -0800
Subject: [PATCH 2/2] i387: split up <asm/i387.h> into exported and internal interfaces

While various modules include <asm/i387.h> to get access to things we
actually *intend* for them to use, most of that header file was really
pretty low-level internal stuff that we really don't want to expose to
others.

So split the header file into two: the small exported interfaces remain
in <asm/i387.h>, while the internal definitions that are only used by
core architecture code are now in <asm/fpu-internal.h>.

The guiding principle for this was to expose functions that we export to
modules, and leave them in <asm/i387.h>, while stuff that is used by
task switching or was marked GPL-only is in <asm/fpu-internal.h>.

The fpu-internal.h file could be further split up too, especially since
arch/x86/kvm/ uses some of the remaining stuff for its module.  But that
kvm usage should probably be abstracted out a bit, and at least now the
internal FPU accessor functions are much more contained.  Even if it
isn't perhaps as contained as it _could_ be.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

This took longer to generate than I expected, because I actually did
allmodconfig builds on both x86-32 and -64.  

Btw, I really don't like what arch/x86/kvm/ does with CR0.TS and the FP
state.  I'm not at all sure that's all kosher.  But I don't know the
code, so I just made sure that at no point did any of the semantics
change. 

				Linus

 arch/x86/ia32/ia32_signal.c         |    1 +
 arch/x86/include/asm/fpu-internal.h |  520 +++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/i387.h         |  512 +----------------------------------
 arch/x86/kernel/cpu/common.c        |    1 +
 arch/x86/kernel/i387.c              |    3 +-
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
 15 files changed, 540 insertions(+), 508 deletions(-)
 create mode 100644 arch/x86/include/asm/fpu-internal.h

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 65577698cab2..5563ba1cf513 100644
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
index 000000000000..1709fc78884b
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
+		"emms\n\t"	  	/* clear stack tags */
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
index 0c1031d354f2..7ce0798b1b26 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -13,411 +13,15 @@
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
-
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
+extern void math_state_restore(void);
 
 extern bool irq_fpu_usable(void);
 extern void kernel_fpu_begin(void);
@@ -463,118 +67,14 @@ static inline void irq_ts_restore(int TS_state)
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
+	return current->thread.fpu.has_fpu;
 }
 
 extern void unlazy_fpu(struct task_struct *tsk);
 
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
-}
-
-extern void fpu_finit(struct fpu *fpu);
-
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_I387_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cb71b01ab66e..89620b1725d4 100644
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
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 17b7549c4134..7734bcbb5a3a 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -16,6 +16,7 @@
 #include <asm/uaccess.h>
 #include <asm/ptrace.h>
 #include <asm/i387.h>
+#include <asm/fpu-internal.h>
 #include <asm/user.h>
 
 #ifdef CONFIG_X86_64
@@ -124,7 +125,7 @@ EXPORT_SYMBOL_GPL(xstate_size);
 unsigned int sig_xstate_ia32_size = sizeof(struct _fpstate_ia32);
 static struct i387_fxsave_struct fx_scratch __cpuinitdata;
 
-void __cpuinit mxcsr_feature_mask_init(void)
+static void __cpuinit mxcsr_feature_mask_init(void)
 {
 	unsigned long mask = 0;
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 15763af7bfe3..c38d84e01022 100644
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
index c08d1ff12b7c..ee32dee7a0a3 100644
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
index cfa5c90c01db..5bad3c71e48f 100644
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
index 50267386b766..78f05e438be5 100644
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
index 46a01bdc27e2..25edcfc9ba5b 100644
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
index 4bbe04d96744..ec61d4c1b93b 100644
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
index 711091114119..e62728e30b01 100644
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
index 3b4c8d8ad906..246490f643b6 100644
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
index 9cbfc0698118..b937b6179d80 100644
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
index f10c0afa1cb4..4889655ba784 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -20,6 +20,7 @@
 #include <asm/xcr.h>
 #include <asm/suspend.h>
 #include <asm/debugreg.h>
+#include <asm/fpu-internal.h> /* pcntxt_mask */
 
 #ifdef CONFIG_X86_32
 static struct saved_context saved_context;
-- 
1.7.9.188.g12766.dirty

