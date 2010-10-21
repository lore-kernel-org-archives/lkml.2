Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab0JUNqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:46:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44045 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956Ab0JUNqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:46:09 -0400
Date: Thu, 21 Oct 2010 15:45:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/fpu for v2.6.37
Message-ID: <20101021134558.GA5859@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fpu-for-linus

 Thanks,

	Ingo

------------------>
Brian Gerst (12):
      x86: Use correct type for %cr4
      x86, fpu: Merge fpu_init()
      x86, fpu: Merge tolerant_fwait()
      x86, fpu: Merge __save_init_fpu()
      x86-64, fpu: Disable preemption when using TS_USEDFPU
      x86-64, fpu: Fix %cs value in convert_from_fxsr()
      x86-64, fpu: Simplify constraints for fxsave/fxtstor
      x86-32, fpu: Remove math_emulate stub
      x86, fpu: Remove unnecessary ifdefs from i387 code.
      x86, fpu: Remove PSHUFB_XMM5_* macros
      x86-32, fpu: Rewrite fpu_save_init()
      x86, fpu: Merge fpu_save_init()

Robert Richter (1):
      x86, xsave: Disable xsave in i387 emulation mode


 arch/x86/include/asm/i387.h      |  195 ++++++++++---------------------------
 arch/x86/include/asm/processor.h |    4 +-
 arch/x86/kernel/cpu/common.c     |    7 --
 arch/x86/kernel/i387.c           |   58 ++++++------
 arch/x86/kernel/process_64.c     |    2 +-
 arch/x86/kernel/traps.c          |   35 +------
 6 files changed, 90 insertions(+), 211 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index a73a8d5..70626ed 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -55,6 +55,12 @@ extern int save_i387_xstate_ia32(void __user *buf);
 extern int restore_i387_xstate_ia32(void __user *buf);
 #endif
 
+#ifdef CONFIG_MATH_EMULATION
+extern void finit_soft_fpu(struct i387_soft_struct *soft);
+#else
+static inline void finit_soft_fpu(struct i387_soft_struct *soft) {}
+#endif
+
 #define X87_FSW_ES (1 << 7)	/* Exception Summary */
 
 static __always_inline __pure bool use_xsaveopt(void)
@@ -67,6 +73,11 @@ static __always_inline __pure bool use_xsave(void)
 	return static_cpu_has(X86_FEATURE_XSAVE);
 }
 
+static __always_inline __pure bool use_fxsr(void)
+{
+        return static_cpu_has(X86_FEATURE_FXSR);
+}
+
 extern void __sanitize_i387_state(struct task_struct *);
 
 static inline void sanitize_i387_state(struct task_struct *tsk)
@@ -77,19 +88,11 @@ static inline void sanitize_i387_state(struct task_struct *tsk)
 }
 
 #ifdef CONFIG_X86_64
-
-/* Ignore delayed exceptions from user space */
-static inline void tolerant_fwait(void)
-{
-	asm volatile("1: fwait\n"
-		     "2:\n"
-		     _ASM_EXTABLE(1b, 2b));
-}
-
 static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 {
 	int err;
 
+	/* See comment in fxsave() below. */
 	asm volatile("1:  rex64/fxrstor (%[fx])\n\t"
 		     "2:\n"
 		     ".section .fixup,\"ax\"\n"
@@ -98,44 +101,10 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 		     ".previous\n"
 		     _ASM_EXTABLE(1b, 3b)
 		     : [err] "=r" (err)
-#if 0 /* See comment in fxsave() below. */
-		     : [fx] "r" (fx), "m" (*fx), "0" (0));
-#else
-		     : [fx] "cdaSDb" (fx), "m" (*fx), "0" (0));
-#endif
+		     : [fx] "R" (fx), "m" (*fx), "0" (0));
 	return err;
 }
 
-/* AMD CPUs don't save/restore FDP/FIP/FOP unless an exception
-   is pending. Clear the x87 state here by setting it to fixed
-   values. The kernel data segment can be sometimes 0 and sometimes
-   new user value. Both should be ok.
-   Use the PDA as safe address because it should be already in L1. */
-static inline void fpu_clear(struct fpu *fpu)
-{
-	struct xsave_struct *xstate = &fpu->state->xsave;
-	struct i387_fxsave_struct *fx = &fpu->state->fxsave;
-
-	/*
-	 * xsave header may indicate the init state of the FP.
-	 */
-	if (use_xsave() &&
-	    !(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
-		return;
-
-	if (unlikely(fx->swd & X87_FSW_ES))
-		asm volatile("fnclex");
-	alternative_input(ASM_NOP8 ASM_NOP2,
-			  "    emms\n"		/* clear stack tags */
-			  "    fildl %%gs:0",	/* load to clear state */
-			  X86_FEATURE_FXSAVE_LEAK);
-}
-
-static inline void clear_fpu_state(struct task_struct *tsk)
-{
-	fpu_clear(&tsk->thread.fpu);
-}
-
 static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 {
 	int err;
@@ -149,6 +118,7 @@ static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 	if (unlikely(err))
 		return -EFAULT;
 
+	/* See comment in fxsave() below. */
 	asm volatile("1:  rex64/fxsave (%[fx])\n\t"
 		     "2:\n"
 		     ".section .fixup,\"ax\"\n"
@@ -157,11 +127,7 @@ static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 		     ".previous\n"
 		     _ASM_EXTABLE(1b, 3b)
 		     : [err] "=r" (err), "=m" (*fx)
-#if 0 /* See comment in fxsave() below. */
-		     : [fx] "r" (fx), "0" (0));
-#else
-		     : [fx] "cdaSDb" (fx), "0" (0));
-#endif
+		     : [fx] "R" (fx), "0" (0));
 	if (unlikely(err) &&
 	    __clear_user(fx, sizeof(struct i387_fxsave_struct)))
 		err = -EFAULT;
@@ -174,57 +140,26 @@ static inline void fpu_fxsave(struct fpu *fpu)
 	/* Using "rex64; fxsave %0" is broken because, if the memory operand
 	   uses any extended registers for addressing, a second REX prefix
 	   will be generated (to the assembler, rex64 followed by semicolon
-	   is a separate instruction), and hence the 64-bitness is lost. */
-#if 0
-	/* Using "fxsaveq %0" would be the ideal choice, but is only supported
-	   starting with gas 2.16. */
-	__asm__ __volatile__("fxsaveq %0"
-			     : "=m" (fpu->state->fxsave));
-#elif 0
-	/* Using, as a workaround, the properly prefixed form below isn't
+	   is a separate instruction), and hence the 64-bitness is lost.
+	   Using "fxsaveq %0" would be the ideal choice, but is only supported
+	   starting with gas 2.16.
+	asm volatile("fxsaveq %0"
+		     : "=m" (fpu->state->fxsave));
+	   Using, as a workaround, the properly prefixed form below isn't
 	   accepted by any binutils version so far released, complaining that
 	   the same type of prefix is used twice if an extended register is
-	   needed for addressing (fix submitted to mainline 2005-11-21). */
-	__asm__ __volatile__("rex64/fxsave %0"
-			     : "=m" (fpu->state->fxsave));
-#else
-	/* This, however, we can work around by forcing the compiler to select
+	   needed for addressing (fix submitted to mainline 2005-11-21).
+	asm volatile("rex64/fxsave %0"
+		     : "=m" (fpu->state->fxsave));
+	   This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
-	__asm__ __volatile__("rex64/fxsave (%1)"
-			     : "=m" (fpu->state->fxsave)
-			     : "cdaSDb" (&fpu->state->fxsave));
-#endif
-}
-
-static inline void fpu_save_init(struct fpu *fpu)
-{
-	if (use_xsave())
-		fpu_xsave(fpu);
-	else
-		fpu_fxsave(fpu);
-
-	fpu_clear(fpu);
-}
-
-static inline void __save_init_fpu(struct task_struct *tsk)
-{
-	fpu_save_init(&tsk->thread.fpu);
-	task_thread_info(tsk)->status &= ~TS_USEDFPU;
+	asm volatile("rex64/fxsave (%[fx])"
+		     : "=m" (fpu->state->fxsave)
+		     : [fx] "R" (&fpu->state->fxsave));
 }
 
 #else  /* CONFIG_X86_32 */
 
-#ifdef CONFIG_MATH_EMULATION
-extern void finit_soft_fpu(struct i387_soft_struct *soft);
-#else
-static inline void finit_soft_fpu(struct i387_soft_struct *soft) {}
-#endif
-
-static inline void tolerant_fwait(void)
-{
-	asm volatile("fnclex ; fwait");
-}
-
 /* perform fxrstor iff the processor has extended states, otherwise frstor */
 static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 {
@@ -241,6 +176,14 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 	return 0;
 }
 
+static inline void fpu_fxsave(struct fpu *fpu)
+{
+	asm volatile("fxsave %[fx]"
+		     : [fx] "=m" (fpu->state->fxsave));
+}
+
+#endif	/* CONFIG_X86_64 */
+
 /* We need a safe address that is cheap to find and that is already
    in L1 during context switch. The best choices are unfortunately
    different for UP and SMP */
@@ -256,47 +199,33 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 static inline void fpu_save_init(struct fpu *fpu)
 {
 	if (use_xsave()) {
-		struct xsave_struct *xstate = &fpu->state->xsave;
-		struct i387_fxsave_struct *fx = &fpu->state->fxsave;
-
 		fpu_xsave(fpu);
 
 		/*
 		 * xsave header may indicate the init state of the FP.
 		 */
-		if (!(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
-			goto end;
-
-		if (unlikely(fx->swd & X87_FSW_ES))
-			asm volatile("fnclex");
-
-		/*
-		 * we can do a simple return here or be paranoid :)
-		 */
-		goto clear_state;
+		if (!(fpu->state->xsave.xsave_hdr.xstate_bv & XSTATE_FP))
+			return;
+	} else if (use_fxsr()) {
+		fpu_fxsave(fpu);
+	} else {
+		asm volatile("fsave %[fx]; fwait"
+			     : [fx] "=m" (fpu->state->fsave));
+		return;
 	}
 
-	/* Use more nops than strictly needed in case the compiler
-	   varies code */
-	alternative_input(
-		"fnsave %[fx] ;fwait;" GENERIC_NOP8 GENERIC_NOP4,
-		"fxsave %[fx]\n"
-		"bt $7,%[fsw] ; jnc 1f ; fnclex\n1:",
-		X86_FEATURE_FXSR,
-		[fx] "m" (fpu->state->fxsave),
-		[fsw] "m" (fpu->state->fxsave.swd) : "memory");
-clear_state:
+	if (unlikely(fpu->state->fxsave.swd & X87_FSW_ES))
+		asm volatile("fnclex");
+
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. safe_address is a random variable that should be in L1 */
 	alternative_input(
-		GENERIC_NOP8 GENERIC_NOP2,
+		ASM_NOP8 ASM_NOP2,
 		"emms\n\t"	  	/* clear stack tags */
-		"fildl %[addr]", 	/* set F?P to defined value */
+		"fildl %P[addr]",	/* set F?P to defined value */
 		X86_FEATURE_FXSAVE_LEAK,
 		[addr] "m" (safe_address));
-end:
-	;
 }
 
 static inline void __save_init_fpu(struct task_struct *tsk)
@@ -305,9 +234,6 @@ static inline void __save_init_fpu(struct task_struct *tsk)
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
-
-#endif	/* CONFIG_X86_64 */
-
 static inline int fpu_fxrstor_checking(struct fpu *fpu)
 {
 	return fxrstor_checking(&fpu->state->fxsave);
@@ -344,7 +270,10 @@ static inline void __unlazy_fpu(struct task_struct *tsk)
 static inline void __clear_fpu(struct task_struct *tsk)
 {
 	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		tolerant_fwait();
+		/* Ignore delayed exceptions from user space */
+		asm volatile("1: fwait\n"
+			     "2:\n"
+			     _ASM_EXTABLE(1b, 2b));
 		task_thread_info(tsk)->status &= ~TS_USEDFPU;
 		stts();
 	}
@@ -405,19 +334,6 @@ static inline void irq_ts_restore(int TS_state)
 		stts();
 }
 
-#ifdef CONFIG_X86_64
-
-static inline void save_init_fpu(struct task_struct *tsk)
-{
-	__save_init_fpu(tsk);
-	stts();
-}
-
-#define unlazy_fpu	__unlazy_fpu
-#define clear_fpu	__clear_fpu
-
-#else  /* CONFIG_X86_32 */
-
 /*
  * These disable preemption on their own and are safe
  */
@@ -443,8 +359,6 @@ static inline void clear_fpu(struct task_struct *tsk)
 	preempt_enable();
 }
 
-#endif	/* CONFIG_X86_64 */
-
 /*
  * i387 state interaction
  */
@@ -508,7 +422,4 @@ extern void fpu_finit(struct fpu *fpu);
 
 #endif /* __ASSEMBLY__ */
 
-#define PSHUFB_XMM5_XMM0 .byte 0x66, 0x0f, 0x38, 0x00, 0xc5
-#define PSHUFB_XMM5_XMM6 .byte 0x66, 0x0f, 0x38, 0x00, 0xf5
-
 #endif /* _ASM_X86_I387_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 325b7bd..396b80f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -602,7 +602,7 @@ extern unsigned long		mmu_cr4_features;
 
 static inline void set_in_cr4(unsigned long mask)
 {
-	unsigned cr4;
+	unsigned long cr4;
 
 	mmu_cr4_features |= mask;
 	cr4 = read_cr4();
@@ -612,7 +612,7 @@ static inline void set_in_cr4(unsigned long mask)
 
 static inline void clear_in_cr4(unsigned long mask)
 {
-	unsigned cr4;
+	unsigned long cr4;
 
 	mmu_cr4_features &= ~mask;
 	cr4 = read_cr4();
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 490dac6..f9e23e8 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1264,13 +1264,6 @@ void __cpuinit cpu_init(void)
 	clear_all_debug_regs();
 	dbg_restore_debug_regs();
 
-	/*
-	 * Force FPU initialization:
-	 */
-	current_thread_info()->status = 0;
-	clear_used_math();
-	mxcsr_feature_mask_init();
-
 	fpu_init();
 	xsave_init();
 }
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 1f11f5c..e795e36 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -67,19 +67,22 @@ static void __cpuinit init_thread_xstate(void)
 	 */
 
 	if (!HAVE_HWFP) {
+		/*
+		 * Disable xsave as we do not support it if i387
+		 * emulation is enabled.
+		 */
+		setup_clear_cpu_cap(X86_FEATURE_XSAVE);
+		setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
 		xstate_size = sizeof(struct i387_soft_struct);
 		return;
 	}
 
 	if (cpu_has_fxsr)
 		xstate_size = sizeof(struct i387_fxsave_struct);
-#ifdef CONFIG_X86_32
 	else
 		xstate_size = sizeof(struct i387_fsave_struct);
-#endif
 }
 
-#ifdef CONFIG_X86_64
 /*
  * Called at bootup to set up the initial FPU state that is later cloned
  * into all processes.
@@ -87,12 +90,21 @@ static void __cpuinit init_thread_xstate(void)
 
 void __cpuinit fpu_init(void)
 {
-	unsigned long oldcr0 = read_cr0();
-
-	set_in_cr4(X86_CR4_OSFXSR);
-	set_in_cr4(X86_CR4_OSXMMEXCPT);
+	unsigned long cr0;
+	unsigned long cr4_mask = 0;
 
-	write_cr0(oldcr0 & ~(X86_CR0_TS|X86_CR0_EM)); /* clear TS and EM */
+	if (cpu_has_fxsr)
+		cr4_mask |= X86_CR4_OSFXSR;
+	if (cpu_has_xmm)
+		cr4_mask |= X86_CR4_OSXMMEXCPT;
+	if (cr4_mask)
+		set_in_cr4(cr4_mask);
+
+	cr0 = read_cr0();
+	cr0 &= ~(X86_CR0_TS|X86_CR0_EM); /* clear TS and EM */
+	if (!HAVE_HWFP)
+		cr0 |= X86_CR0_EM;
+	write_cr0(cr0);
 
 	if (!smp_processor_id())
 		init_thread_xstate();
@@ -103,24 +115,12 @@ void __cpuinit fpu_init(void)
 	clear_used_math();
 }
 
-#else	/* CONFIG_X86_64 */
-
-void __cpuinit fpu_init(void)
-{
-	if (!smp_processor_id())
-		init_thread_xstate();
-}
-
-#endif	/* CONFIG_X86_32 */
-
 void fpu_finit(struct fpu *fpu)
 {
-#ifdef CONFIG_X86_32
 	if (!HAVE_HWFP) {
 		finit_soft_fpu(&fpu->state->soft);
 		return;
 	}
-#endif
 
 	if (cpu_has_fxsr) {
 		struct i387_fxsave_struct *fx = &fpu->state->fxsave;
@@ -385,19 +385,17 @@ convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 #ifdef CONFIG_X86_64
 	env->fip = fxsave->rip;
 	env->foo = fxsave->rdp;
+	/*
+	 * should be actually ds/cs at fpu exception time, but
+	 * that information is not available in 64bit mode.
+	 */
+	env->fcs = task_pt_regs(tsk)->cs;
 	if (tsk == current) {
-		/*
-		 * should be actually ds/cs at fpu exception time, but
-		 * that information is not available in 64bit mode.
-		 */
-		asm("mov %%ds, %[fos]" : [fos] "=r" (env->fos));
-		asm("mov %%cs, %[fcs]" : [fcs] "=r" (env->fcs));
+		savesegment(ds, env->fos);
 	} else {
-		struct pt_regs *regs = task_pt_regs(tsk);
-
-		env->fos = 0xffff0000 | tsk->thread.ds;
-		env->fcs = regs->cs;
+		env->fos = tsk->thread.ds;
 	}
+	env->fos |= 0xffff0000;
 #else
 	env->fip = fxsave->fip;
 	env->fcs = (u16) fxsave->fcs | ((u32) fxsave->fop << 16);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3d9ea53..b3d7a3a 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -424,7 +424,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	load_TLS(next, cpu);
 
 	/* Must be after DS reload */
-	unlazy_fpu(prev_p);
+	__unlazy_fpu(prev_p);
 
 	/* Make sure cpu is ready for new context */
 	if (preload_fpu)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 60788de..d439685 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -776,21 +776,10 @@ asmlinkage void math_state_restore(void)
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
-#ifndef CONFIG_MATH_EMULATION
-void math_emulate(struct math_emu_info *info)
-{
-	printk(KERN_EMERG
-		"math-emulation not enabled and no coprocessor found.\n");
-	printk(KERN_EMERG "killing %s.\n", current->comm);
-	force_sig(SIGFPE, current);
-	schedule();
-}
-#endif /* CONFIG_MATH_EMULATION */
-
 dotraplinkage void __kprobes
 do_device_not_available(struct pt_regs *regs, long error_code)
 {
-#ifdef CONFIG_X86_32
+#ifdef CONFIG_MATH_EMULATION
 	if (read_cr0() & X86_CR0_EM) {
 		struct math_emu_info info = { };
 
@@ -798,12 +787,12 @@ do_device_not_available(struct pt_regs *regs, long error_code)
 
 		info.regs = regs;
 		math_emulate(&info);
-	} else {
-		math_state_restore(); /* interrupts still off */
-		conditional_sti(regs);
+		return;
 	}
-#else
-	math_state_restore();
+#endif
+	math_state_restore(); /* interrupts still off */
+#ifdef CONFIG_X86_32
+	conditional_sti(regs);
 #endif
 }
 
@@ -881,18 +870,6 @@ void __init trap_init(void)
 #endif
 
 #ifdef CONFIG_X86_32
-	if (cpu_has_fxsr) {
-		printk(KERN_INFO "Enabling fast FPU save and restore... ");
-		set_in_cr4(X86_CR4_OSFXSR);
-		printk("done.\n");
-	}
-	if (cpu_has_xmm) {
-		printk(KERN_INFO
-			"Enabling unmasked SIMD FPU exception support... ");
-		set_in_cr4(X86_CR4_OSXMMEXCPT);
-		printk("done.\n");
-	}
-
 	set_system_trap_gate(SYSCALL_VECTOR, &system_call);
 	set_bit(SYSCALL_VECTOR, used_vectors);
 #endif
