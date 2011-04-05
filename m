Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1DEPwC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:52:02 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:43279
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754846Ab1DEPv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:51:57 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJ6S13-01-Q6G-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>
CC: <brgerst@gmail.com>, <tglx@linutronix.de>, <mingo@elte.hu>,
        <suresh.b.siddha@intel.com>, <eranian@google.com>,
        <robert.richter@amd.com>, <Andreas.Herrmann3@amd.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [RFC v3 4/8] x86, xsave: remove unused code
Date: Tue, 5 Apr 2011 17:50:52 +0200
Message-ID: <1302018656-586370-5-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <4D91FA76.1010908@zytor.com>
References: <4D91FA76.1010908@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches to rework the fpu/xsave handling and signal frame setup have
made a lot of code unused. This patch removes all this now useless stuff.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/i387.h  |  155 ++----------------------------
 arch/x86/include/asm/xsave.h |   51 ----------
 arch/x86/kernel/i387.c       |  221 ------------------------------------------
 arch/x86/kernel/traps.c      |   22 ----
 arch/x86/kernel/xsave.c      |  163 -------------------------------
 5 files changed, 7 insertions(+), 605 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 30930bf..97867ea 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -29,8 +29,6 @@
 # include <asm/sigcontext32.h>
 # include <asm/user32.h>
 #else
-# define save_i387_xstate_ia32		save_i387_xstate
-# define restore_i387_xstate_ia32	restore_i387_xstate
 # define _fpstate_ia32		_fpstate
 # define _xstate_ia32		_xstate
 # define sig_xstate_ia32_size   sig_xstate_size
@@ -108,75 +106,16 @@ static inline void sanitize_i387_state(struct task_struct *tsk)
 }
 
 #ifdef CONFIG_X86_64
-static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
+static inline void fxrstor(struct i387_fxsave_struct *fx)
 {
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
 	/* See comment in fxsave() below. */
 #ifdef CONFIG_AS_FXSAVEQ
-	asm volatile("1:  fxsaveq %[fx]\n\t"
-		     "2:\n"
-		     ".section .fixup,\"ax\"\n"
-		     "3:  movl $-1,%[err]\n"
-		     "    jmp  2b\n"
-		     ".previous\n"
-		     _ASM_EXTABLE(1b, 3b)
-		     : [err] "=r" (err), [fx] "=m" (*fx)
-		     : "0" (0));
+	asm volatile("fxrstorq %[fx]\n\t"
+		     : : [fx] "m" (*fx));
 #else
-	asm volatile("1:  rex64/fxsave (%[fx])\n\t"
-		     "2:\n"
-		     ".section .fixup,\"ax\"\n"
-		     "3:  movl $-1,%[err]\n"
-		     "    jmp  2b\n"
-		     ".previous\n"
-		     _ASM_EXTABLE(1b, 3b)
-		     : [err] "=r" (err), "=m" (*fx)
-		     : [fx] "R" (fx), "0" (0));
+	asm volatile("rex64/fxrstor (%[fx])\n\t"
+		     : : [fx] "R" (fx), "m" (*fx));
 #endif
-	if (unlikely(err) &&
-	    __clear_user(fx, sizeof(struct i387_fxsave_struct)))
-		err = -EFAULT;
-	/* No need to clear here because the caller clears USED_MATH */
-	return err;
 }
 
 static inline void fpu_fxsave(struct fpu *fpu)
@@ -209,7 +148,7 @@ static inline void fpu_fxsave(struct fpu *fpu)
 #else  /* CONFIG_X86_32 */
 
 /* perform fxrstor iff the processor has extended states, otherwise frstor */
-static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
+static inline void fxrstor(struct i387_fxsave_struct *fx)
 {
 	/*
 	 * The "nop" is needed to make the instructions the same
@@ -220,8 +159,6 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 		"fxrstor %1",
 		X86_FEATURE_FXSR,
 		"m" (*fx));
-
-	return 0;
 }
 
 static inline void fpu_fxsave(struct fpu *fpu)
@@ -246,7 +183,7 @@ static inline void fpu_fxsave(struct fpu *fpu)
  */
 static inline void fpu_restore(struct fpu *fpu)
 {
-	fxrstor_checking(&fpu->state->fxsave);
+	fxrstor(&fpu->state->fxsave);
 }
 
 static inline void fpu_save(struct fpu *fpu)
@@ -278,69 +215,6 @@ static inline void fpu_clean(struct fpu *fpu)
 		[addr] "m" (safe_address));
 }
 
-static inline void fpu_save_init(struct fpu *fpu)
-{
-	if (use_xsave()) {
-		struct xsave_struct *xstate = &fpu->state->xsave;
-
-		fpu_xsave(xstate, -1);
-
-		/*
-		 * xsave header may indicate the init state of the FP.
-		 */
-		if (!(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
-			return;
-	} else if (use_fxsr()) {
-		fpu_fxsave(fpu);
-	} else {
-		asm volatile("fsave %[fx]; fwait"
-			     : [fx] "=m" (fpu->state->fsave));
-		return;
-	}
-
-	if (unlikely(fpu->state->fxsave.swd & X87_FSW_ES))
-		asm volatile("fnclex");
-
-	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
-	   is pending.  Clear the x87 state here by setting it to fixed
-	   values. safe_address is a random variable that should be in L1 */
-	alternative_input(
-		ASM_NOP8 ASM_NOP2,
-		"emms\n\t"	  	/* clear stack tags */
-		"fildl %P[addr]",	/* set F?P to defined value */
-		X86_FEATURE_FXSAVE_LEAK,
-		[addr] "m" (safe_address));
-}
-
-static inline void __save_init_fpu(struct task_struct *tsk)
-{
-	fpu_save_init(&tsk->thread.fpu);
-	task_thread_info(tsk)->status &= ~TS_USEDFPU;
-}
-
-static inline int fpu_restore_checking(struct fpu *fpu)
-{
-	if (use_xsave())
-		return xrstor_checking(&fpu->state->xsave, -1);
-	else
-		return fxrstor_checking(&fpu->state->fxsave);
-}
-
-/*
- * Signal frame handlers...
- */
-extern int save_i387_xstate(void __user *buf);
-extern int restore_i387_xstate(void __user *buf);
-
-static inline void __unlazy_fpu(struct task_struct *tsk)
-{
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		__save_init_fpu(tsk);
-		stts();
-	} else
-		tsk->fpu_counter = 0;
-}
-
 static inline void __clear_fpu(struct task_struct *tsk)
 {
 	if (task_thread_info(tsk)->status & TS_USEDFPU) {
@@ -409,21 +283,6 @@ static inline void irq_ts_restore(int TS_state)
 /*
  * These disable preemption on their own and are safe
  */
-static inline void save_init_fpu(struct task_struct *tsk)
-{
-	preempt_disable();
-	__save_init_fpu(tsk);
-	stts();
-	preempt_enable();
-}
-
-static inline void unlazy_fpu(struct task_struct *tsk)
-{
-	preempt_disable();
-	__unlazy_fpu(tsk);
-	preempt_enable();
-}
-
 static inline void clear_fpu(struct task_struct *tsk)
 {
 	preempt_disable();
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 200c56d..742da4a 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -51,26 +51,6 @@ extern int check_for_xstate(struct i387_fxsave_struct __user *buf,
 			    unsigned int size,
 			    struct _fpx_sw_bytes *sw);
 
-static inline int xrstor_checking(struct xsave_struct *fx, u64 mask)
-{
-	int err;
-	u32 lmask = mask;
-	u32 hmask = mask >> 32;
-
-	asm volatile("1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
-		     "2:\n"
-		     ".section .fixup,\"ax\"\n"
-		     "3:  movl $-1,%[err]\n"
-		     "    jmp  2b\n"
-		     ".previous\n"
-		     _ASM_EXTABLE(1b, 3b)
-		     : [err] "=r" (err)
-		     : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask), "0" (0)
-		     : "memory");
-
-	return err;
-}
-
 static inline void xrstor_state(struct xsave_struct *fx, u64 mask)
 {
 	u32 lmask = mask;
@@ -81,37 +61,6 @@ static inline void xrstor_state(struct xsave_struct *fx, u64 mask)
 		     :   "memory");
 }
 
-static inline int xsave_checking(struct xsave_struct __user *buf)
-{
-	int err;
-
-	/*
-	 * Clear the xsave header first, so that reserved fields are
-	 * initialized to zero.
-	 */
-	err = __clear_user(&buf->xsave_hdr,
-			   sizeof(struct xsave_hdr_struct));
-	if (unlikely(err))
-		return -EFAULT;
-
-	asm volatile("1: .byte " REX_PREFIX "0x0f,0xae,0x27\n"
-		     "2:\n"
-		     ".section .fixup,\"ax\"\n"
-		     "3:  movl $-1,%[err]\n"
-		     "    jmp  2b\n"
-		     ".previous\n"
-		     _ASM_EXTABLE(1b,3b)
-		     : [err] "=r" (err)
-		     : "D" (buf), "a" (-1), "d" (-1), "0" (0)
-		     : "memory");
-
-	if (unlikely(err) && __clear_user(buf, xstate_size))
-		err = -EFAULT;
-
-	/* No need to clear here because the caller clears USED_MATH */
-	return err;
-}
-
 static inline void xsave_state(struct xsave_struct *fx, u64 mask)
 {
 	u32 lmask = mask;
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 69625a8..ca33c0b 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -490,227 +490,6 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 }
 
 /*
- * Signal frame handlers.
- */
-
-static inline int save_i387_fsave(struct _fpstate_ia32 __user *buf)
-{
-	struct task_struct *tsk = current;
-	struct i387_fsave_struct *fp = &tsk->thread.fpu.state->fsave;
-
-	fp->status = fp->swd;
-	if (__copy_to_user(buf, fp, sizeof(struct i387_fsave_struct)))
-		return -1;
-	return 1;
-}
-
-static int save_i387_fxsave(struct _fpstate_ia32 __user *buf)
-{
-	struct task_struct *tsk = current;
-	struct i387_fxsave_struct *fx = &tsk->thread.fpu.state->fxsave;
-	struct user_i387_ia32_struct env;
-	int err = 0;
-
-	convert_from_fxsr(&env, tsk);
-	if (__copy_to_user(buf, &env, sizeof(env)))
-		return -1;
-
-	err |= __put_user(fx->swd, &buf->status);
-	err |= __put_user(X86_FXSR_MAGIC, &buf->magic);
-	if (err)
-		return -1;
-
-	if (__copy_to_user(&buf->_fxsr_env[0], fx, xstate_size))
-		return -1;
-	return 1;
-}
-
-static int save_i387_xsave(void __user *buf)
-{
-	struct task_struct *tsk = current;
-	struct _fpstate_ia32 __user *fx = buf;
-	int err = 0;
-
-
-	sanitize_i387_state(tsk);
-
-	/*
-	 * For legacy compatible, we always set FP/SSE bits in the bit
-	 * vector while saving the state to the user context.
-	 * This will enable us capturing any changes(during sigreturn) to
-	 * the FP/SSE bits by the legacy applications which don't touch
-	 * xstate_bv in the xsave header.
-	 *
-	 * xsave aware applications can change the xstate_bv in the xsave
-	 * header as well as change any contents in the memory layout.
-	 * xrestore as part of sigreturn will capture all the changes.
-	 */
-	tsk->thread.fpu.state->xsave.xsave_hdr.xstate_bv |= XSTATE_FPSSE;
-
-	if (save_i387_fxsave(fx) < 0)
-		return -1;
-
-	err = __copy_to_user(&fx->sw_reserved, &fx_sw_reserved_ia32,
-			     sizeof(struct _fpx_sw_bytes));
-	err |= __put_user(FP_XSTATE_MAGIC2,
-			  (__u32 __user *) (buf + sig_xstate_ia32_size
-					    - FP_XSTATE_MAGIC2_SIZE));
-	if (err)
-		return -1;
-
-	return 1;
-}
-
-int save_i387_xstate_ia32(void __user *buf)
-{
-	struct _fpstate_ia32 __user *fp = (struct _fpstate_ia32 __user *) buf;
-	struct task_struct *tsk = current;
-
-	if (!used_math())
-		return 0;
-
-	if (!access_ok(VERIFY_WRITE, buf, sig_xstate_ia32_size))
-		return -EACCES;
-	/*
-	 * This will cause a "finit" to be triggered by the next
-	 * attempted FPU operation by the 'current' process.
-	 */
-	clear_used_math();
-
-	if (!HAVE_HWFP) {
-		return fpregs_soft_get(current, NULL,
-				       0, sizeof(struct user_i387_ia32_struct),
-				       NULL, fp) ? -1 : 1;
-	}
-
-	preempt_disable();
-	save_xstates(tsk);
-	preempt_enable();
-
-	if (cpu_has_xsave)
-		return save_i387_xsave(fp);
-	if (cpu_has_fxsr)
-		return save_i387_fxsave(fp);
-	else
-		return save_i387_fsave(fp);
-}
-
-static inline int restore_i387_fsave(struct _fpstate_ia32 __user *buf)
-{
-	struct task_struct *tsk = current;
-
-	return __copy_from_user(&tsk->thread.fpu.state->fsave, buf,
-				sizeof(struct i387_fsave_struct));
-}
-
-static int restore_i387_fxsave(struct _fpstate_ia32 __user *buf,
-			       unsigned int size)
-{
-	struct task_struct *tsk = current;
-	struct user_i387_ia32_struct env;
-	int err;
-
-	err = __copy_from_user(&tsk->thread.fpu.state->fxsave, &buf->_fxsr_env[0],
-			       size);
-	/* mxcsr reserved bits must be masked to zero for security reasons */
-	tsk->thread.fpu.state->fxsave.mxcsr &= mxcsr_feature_mask;
-	if (err || __copy_from_user(&env, buf, sizeof(env)))
-		return 1;
-	convert_to_fxsr(tsk, &env);
-
-	return 0;
-}
-
-static int restore_i387_xsave(void __user *buf)
-{
-	struct _fpx_sw_bytes fx_sw_user;
-	struct _fpstate_ia32 __user *fx_user =
-			((struct _fpstate_ia32 __user *) buf);
-	struct i387_fxsave_struct __user *fx =
-		(struct i387_fxsave_struct __user *) &fx_user->_fxsr_env[0];
-	struct xsave_hdr_struct *xsave_hdr =
-				&current->thread.fpu.state->xsave.xsave_hdr;
-	u64 mask;
-	int err;
-
-	if (check_for_xstate(fx, sig_xstate_ia32_size -
-			     offsetof(struct _fpstate_ia32, _fxsr_env),
-			     &fx_sw_user))
-		goto fx_only;
-
-	mask = fx_sw_user.xstate_bv;
-
-	err = restore_i387_fxsave(buf, fx_sw_user.xstate_size);
-
-	xsave_hdr->xstate_bv &= pcntxt_mask;
-	/*
-	 * These bits must be zero.
-	 */
-	xsave_hdr->reserved1[0] = xsave_hdr->reserved1[1] = 0;
-
-	/*
-	 * Init the state that is not present in the memory layout
-	 * and enabled by the OS.
-	 */
-	mask = ~(pcntxt_mask & ~mask);
-	xsave_hdr->xstate_bv &= mask;
-
-	return err;
-fx_only:
-	/*
-	 * Couldn't find the extended state information in the memory
-	 * layout. Restore the FP/SSE and init the other extended state
-	 * enabled by the OS.
-	 */
-	xsave_hdr->xstate_bv = XSTATE_FPSSE;
-	return restore_i387_fxsave(buf, sizeof(struct i387_fxsave_struct));
-}
-
-int restore_i387_xstate_ia32(void __user *buf)
-{
-	int err;
-	struct task_struct *tsk = current;
-	struct _fpstate_ia32 __user *fp = (struct _fpstate_ia32 __user *) buf;
-
-	if (HAVE_HWFP)
-		clear_fpu(tsk);
-
-	if (!buf) {
-		if (used_math()) {
-			clear_fpu(tsk);
-			clear_used_math();
-		}
-
-		return 0;
-	} else
-		if (!access_ok(VERIFY_READ, buf, sig_xstate_ia32_size))
-			return -EACCES;
-
-	if (!used_math()) {
-		err = init_fpu(tsk);
-		if (err)
-			return err;
-	}
-
-	if (HAVE_HWFP) {
-		if (cpu_has_xsave)
-			err = restore_i387_xsave(buf);
-		else if (cpu_has_fxsr)
-			err = restore_i387_fxsave(fp, sizeof(struct
-							   i387_fxsave_struct));
-		else
-			err = restore_i387_fsave(fp);
-	} else {
-		err = fpregs_soft_set(current, NULL,
-				      0, sizeof(struct user_i387_ia32_struct),
-				      NULL, fp) != 0;
-	}
-	set_used_math();
-
-	return err;
-}
-
-/*
  * FPU state for core dumps.
  * This is only used for a.out dumps now.
  * It is declared generically using elf_fpregset_t (which is
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 072c30e..872fc78 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -720,28 +720,6 @@ asmlinkage void __attribute__((weak)) smp_threshold_interrupt(void)
 }
 
 /*
- * __math_state_restore assumes that cr0.TS is already clear and the
- * fpu state is all ready for use.  Used during context switch.
- */
-void __math_state_restore(void)
-{
-	struct thread_info *thread = current_thread_info();
-	struct task_struct *tsk = thread->task;
-
-	/*
-	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
-	 */
-	if (unlikely(fpu_restore_checking(&tsk->thread.fpu))) {
-		stts();
-		force_sig(SIGSEGV, tsk);
-		return;
-	}
-
-	thread->status |= TS_USEDFPU;   /* So we fnsave on switch_to() */
-	tsk->fpu_counter++;
-}
-
-/*
  * 'math_state_restore()' saves the current math information in the
  * old math state array, and gets the new ones from the current task
  *
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 08b2fe8..9ecc791 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -249,169 +249,6 @@ int save_xstates_sigframe(void __user *buf, unsigned int size)
 	return 1;
 }
 
-#ifdef CONFIG_X86_64
-int save_i387_xstate(void __user *buf)
-{
-	struct task_struct *tsk = current;
-	int err = 0;
-
-	if (!access_ok(VERIFY_WRITE, buf, sig_xstate_size))
-		return -EACCES;
-
-	BUG_ON(sig_xstate_size < xstate_size);
-
-	if ((unsigned long)buf % 64)
-		printk("save_i387_xstate: bad fpstate %p\n", buf);
-
-	if (!used_math())
-		return 0;
-
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		if (use_xsave())
-			err = xsave_checking(buf);
-		else
-			err = fxsave_user(buf);
-
-		if (err)
-			return err;
-		task_thread_info(tsk)->status &= ~TS_USEDFPU;
-		stts();
-	} else {
-		sanitize_i387_state(tsk);
-		if (__copy_to_user(buf, &tsk->thread.fpu.state->fxsave,
-				   xstate_size))
-			return -1;
-	}
-
-	clear_used_math(); /* trigger finit */
-
-	if (use_xsave()) {
-		struct _fpstate __user *fx = buf;
-		struct _xstate __user *x = buf;
-		u64 xstate_bv;
-
-		err = __copy_to_user(&fx->sw_reserved, &fx_sw_reserved,
-				     sizeof(struct _fpx_sw_bytes));
-
-		err |= __put_user(FP_XSTATE_MAGIC2,
-				  (__u32 __user *) (buf + sig_xstate_size
-						    - FP_XSTATE_MAGIC2_SIZE));
-
-		/*
-		 * Read the xstate_bv which we copied (directly from the cpu or
-		 * from the state in task struct) to the user buffers and
-		 * set the FP/SSE bits.
-		 */
-		err |= __get_user(xstate_bv, &x->xstate_hdr.xstate_bv);
-
-		/*
-		 * For legacy compatible, we always set FP/SSE bits in the bit
-		 * vector while saving the state to the user context. This will
-		 * enable us capturing any changes(during sigreturn) to
-		 * the FP/SSE bits by the legacy applications which don't touch
-		 * xstate_bv in the xsave header.
-		 *
-		 * xsave aware apps can change the xstate_bv in the xsave
-		 * header as well as change any contents in the memory layout.
-		 * xrestore as part of sigreturn will capture all the changes.
-		 */
-		xstate_bv |= XSTATE_FPSSE;
-
-		err |= __put_user(xstate_bv, &x->xstate_hdr.xstate_bv);
-
-		if (err)
-			return err;
-	}
-
-	return 1;
-}
-
-/*
- * Restore the extended state if present. Otherwise, restore the FP/SSE
- * state.
- */
-static int restore_user_xstate(void __user *buf)
-{
-	struct _fpx_sw_bytes fx_sw_user;
-	u64 mask;
-	int err;
-
-	if (((unsigned long)buf % 64) ||
-	     check_for_xstate(buf, sig_xstate_size, &fx_sw_user))
-		goto fx_only;
-
-	mask = fx_sw_user.xstate_bv;
-
-	/*
-	 * restore the state passed by the user.
-	 */
-	err = xrstor_checking((__force struct xsave_struct *)buf, mask);
-	if (err)
-		return err;
-
-	/*
-	 * init the state skipped by the user.
-	 */
-	mask = pcntxt_mask & ~mask;
-	if (unlikely(mask))
-		xrstor_state(init_xstate_buf, mask);
-
-	return 0;
-
-fx_only:
-	/*
-	 * couldn't find the extended state information in the
-	 * memory layout. Restore just the FP/SSE and init all
-	 * the other extended state.
-	 */
-	xrstor_state(init_xstate_buf, pcntxt_mask & ~XSTATE_FPSSE);
-	return fxrstor_checking((__force struct i387_fxsave_struct *)buf);
-}
-
-/*
- * This restores directly out of user space. Exceptions are handled.
- */
-int restore_i387_xstate(void __user *buf)
-{
-	struct task_struct *tsk = current;
-	int err = 0;
-
-	if (!buf) {
-		if (used_math())
-			goto clear;
-		return 0;
-	} else
-		if (!access_ok(VERIFY_READ, buf, sig_xstate_size))
-			return -EACCES;
-
-	if (!used_math()) {
-		err = init_fpu(tsk);
-		if (err)
-			return err;
-	}
-
-	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
-		clts();
-		task_thread_info(current)->status |= TS_USEDFPU;
-	}
-	if (use_xsave())
-		err = restore_user_xstate(buf);
-	else
-		err = fxrstor_checking((__force struct i387_fxsave_struct *)
-				       buf);
-	if (unlikely(err)) {
-		/*
-		 * Encountered an error while doing the restore from the
-		 * user buffer, clear the fpu state.
-		 */
-clear:
-		clear_fpu(tsk);
-		clear_used_math();
-	}
-	return err;
-}
-#endif
-
 int restore_xstates_sigframe(void __user *buf, unsigned int size)
 {
 #if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
-- 
1.5.6.5


