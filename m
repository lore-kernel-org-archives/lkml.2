Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab0EFIqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 04:46:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab0EFIqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 04:46:02 -0400
From: Avi Kivity <avi@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>, Dexuan Cui <dexuan.cui@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v3 2/2] x86: Introduce 'struct fpu' and related API
Date: Thu,  6 May 2010 11:45:46 +0300
Message-Id: <1273135546-29690-3-git-send-email-avi@redhat.com>
In-Reply-To: <1273135546-29690-1-git-send-email-avi@redhat.com>
References: <1273135546-29690-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently all fpu state access is through tsk->thread.xstate.  Since we wish
to generalize fpu access to non-task contexts, wrap the state in a new
'struct fpu' and convert existing access to use an fpu API.

Signal frame handlers are not converted to the API since they will remain
task context only things.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/i387.h      |  115 ++++++++++++++++++++++++++++----------
 arch/x86/include/asm/processor.h |    6 ++-
 arch/x86/include/asm/xsave.h     |    7 +-
 arch/x86/kernel/i387.c           |  102 +++++++++++++++++-----------------
 arch/x86/kernel/process.c        |   20 +++----
 arch/x86/kernel/process_32.c     |    2 +-
 arch/x86/kernel/process_64.c     |    2 +-
 arch/x86/kernel/xsave.c          |    2 +-
 arch/x86/math-emu/fpu_aux.c      |    6 +-
 9 files changed, 160 insertions(+), 102 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index a301a68..1a8cca3 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -16,6 +16,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/regset.h>
 #include <linux/hardirq.h>
+#include <linux/slab.h>
 #include <asm/asm.h>
 #include <asm/processor.h>
 #include <asm/sigcontext.h>
@@ -103,10 +104,10 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
    values. The kernel data segment can be sometimes 0 and sometimes
    new user value. Both should be ok.
    Use the PDA as safe address because it should be already in L1. */
-static inline void clear_fpu_state(struct task_struct *tsk)
+static inline void fpu_clear(struct fpu *fpu)
 {
-	struct xsave_struct *xstate = &tsk->thread.xstate->xsave;
-	struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
+	struct xsave_struct *xstate = &fpu->state->xsave;
+	struct i387_fxsave_struct *fx = &fpu->state->fxsave;
 
 	/*
 	 * xsave header may indicate the init state of the FP.
@@ -123,6 +124,11 @@ static inline void clear_fpu_state(struct task_struct *tsk)
 			  X86_FEATURE_FXSAVE_LEAK);
 }
 
+static inline void clear_fpu_state(struct task_struct *tsk)
+{
+	fpu_clear(&tsk->thread.fpu);
+}
+
 static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 {
 	int err;
@@ -147,7 +153,7 @@ static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 	return err;
 }
 
-static inline void fxsave(struct task_struct *tsk)
+static inline void fpu_fxsave(struct fpu *fpu)
 {
 	/* Using "rex64; fxsave %0" is broken because, if the memory operand
 	   uses any extended registers for addressing, a second REX prefix
@@ -157,42 +163,45 @@ static inline void fxsave(struct task_struct *tsk)
 	/* Using "fxsaveq %0" would be the ideal choice, but is only supported
 	   starting with gas 2.16. */
 	__asm__ __volatile__("fxsaveq %0"
-			     : "=m" (tsk->thread.xstate->fxsave));
+			     : "=m" (fpu->state->fxsave));
 #elif 0
 	/* Using, as a workaround, the properly prefixed form below isn't
 	   accepted by any binutils version so far released, complaining that
 	   the same type of prefix is used twice if an extended register is
 	   needed for addressing (fix submitted to mainline 2005-11-21). */
 	__asm__ __volatile__("rex64/fxsave %0"
-			     : "=m" (tsk->thread.xstate->fxsave));
+			     : "=m" (fpu->state->fxsave));
 #else
 	/* This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
 	__asm__ __volatile__("rex64/fxsave (%1)"
-			     : "=m" (tsk->thread.xstate->fxsave)
-			     : "cdaSDb" (&tsk->thread.xstate->fxsave));
+			     : "=m" (fpu->state->fxsave)
+			     : "cdaSDb" (&fpu->state->fxsave));
 #endif
 }
 
-static inline void __save_init_fpu(struct task_struct *tsk)
+static inline void fpu_save_init(struct fpu *fpu)
 {
 	if (use_xsave())
-		xsave(tsk);
+		fpu_xsave(fpu);
 	else
-		fxsave(tsk);
+		fpu_fxsave(fpu);
 
-	clear_fpu_state(tsk);
+	fpu_clear(fpu);
+}
+
+static inline void __save_init_fpu(struct task_struct *tsk)
+{
+	fpu_save_init(&tsk->thread.fpu);
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
 #else  /* CONFIG_X86_32 */
 
 #ifdef CONFIG_MATH_EMULATION
-extern void finit_task(struct task_struct *tsk);
+extern void finit_soft_fpu(struct i387_soft_struct *soft);
 #else
-static inline void finit_task(struct task_struct *tsk)
-{
-}
+static inline void finit_soft_fpu(struct i387_soft_struct *soft) {}
 #endif
 
 static inline void tolerant_fwait(void)
@@ -228,13 +237,13 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 /*
  * These must be called with preempt disabled
  */
-static inline void __save_init_fpu(struct task_struct *tsk)
+static inline void fpu_save_init(struct fpu *fpu)
 {
 	if (use_xsave()) {
-		struct xsave_struct *xstate = &tsk->thread.xstate->xsave;
-		struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
+		struct xsave_struct *xstate = &fpu->state->xsave;
+		struct i387_fxsave_struct *fx = &fpu->state->fxsave;
 
-		xsave(tsk);
+		fpu_xsave(fpu);
 
 		/*
 		 * xsave header may indicate the init state of the FP.
@@ -258,8 +267,8 @@ static inline void __save_init_fpu(struct task_struct *tsk)
 		"fxsave %[fx]\n"
 		"bt $7,%[fsw] ; jnc 1f ; fnclex\n1:",
 		X86_FEATURE_FXSR,
-		[fx] "m" (tsk->thread.xstate->fxsave),
-		[fsw] "m" (tsk->thread.xstate->fxsave.swd) : "memory");
+		[fx] "m" (fpu->state->fxsave),
+		[fsw] "m" (fpu->state->fxsave.swd) : "memory");
 clear_state:
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
@@ -271,17 +280,34 @@ clear_state:
 		X86_FEATURE_FXSAVE_LEAK,
 		[addr] "m" (safe_address));
 end:
+	;
+}
+
+static inline void __save_init_fpu(struct task_struct *tsk)
+{
+	fpu_save_init(&tsk->thread.fpu);
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
+
 #endif	/* CONFIG_X86_64 */
 
-static inline int restore_fpu_checking(struct task_struct *tsk)
+static inline int fpu_fxrstor_checking(struct fpu *fpu)
+{
+	return fxrstor_checking(&fpu->state->fxsave);
+}
+
+static inline int fpu_restore_checking(struct fpu *fpu)
 {
 	if (use_xsave())
-		return xrstor_checking(&tsk->thread.xstate->xsave);
+		return fpu_xrstor_checking(fpu);
 	else
-		return fxrstor_checking(&tsk->thread.xstate->fxsave);
+		return fpu_fxrstor_checking(fpu);
+}
+
+static inline int restore_fpu_checking(struct task_struct *tsk)
+{
+	return fpu_restore_checking(&tsk->thread.fpu);
 }
 
 /*
@@ -409,30 +435,59 @@ static inline void clear_fpu(struct task_struct *tsk)
 static inline unsigned short get_fpu_cwd(struct task_struct *tsk)
 {
 	if (cpu_has_fxsr) {
-		return tsk->thread.xstate->fxsave.cwd;
+		return tsk->thread.fpu.state->fxsave.cwd;
 	} else {
-		return (unsigned short)tsk->thread.xstate->fsave.cwd;
+		return (unsigned short)tsk->thread.fpu.state->fsave.cwd;
 	}
 }
 
 static inline unsigned short get_fpu_swd(struct task_struct *tsk)
 {
 	if (cpu_has_fxsr) {
-		return tsk->thread.xstate->fxsave.swd;
+		return tsk->thread.fpu.state->fxsave.swd;
 	} else {
-		return (unsigned short)tsk->thread.xstate->fsave.swd;
+		return (unsigned short)tsk->thread.fpu.state->fsave.swd;
 	}
 }
 
 static inline unsigned short get_fpu_mxcsr(struct task_struct *tsk)
 {
 	if (cpu_has_xmm) {
-		return tsk->thread.xstate->fxsave.mxcsr;
+		return tsk->thread.fpu.state->fxsave.mxcsr;
 	} else {
 		return MXCSR_DEFAULT;
 	}
 }
 
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
 #endif /* __ASSEMBLY__ */
 
 #define PSHUFB_XMM5_XMM0 .byte 0x66, 0x0f, 0x38, 0x00, 0xc5
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 32428b4..1e248a6 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -380,6 +380,10 @@ union thread_xstate {
 	struct xsave_struct		xsave;
 };
 
+struct fpu {
+	union thread_xstate *state;
+};
+
 #ifdef CONFIG_X86_64
 DECLARE_PER_CPU(struct orig_ist, orig_ist);
 
@@ -457,7 +461,7 @@ struct thread_struct {
 	unsigned long		trap_no;
 	unsigned long		error_code;
 	/* floating point and extended processor state */
-	union thread_xstate	*xstate;
+	struct fpu		fpu;
 #ifdef CONFIG_X86_32
 	/* Virtual 86 mode info */
 	struct vm86_struct __user *vm86_info;
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index ddc04cc..2c4390c 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -37,8 +37,9 @@ extern int check_for_xstate(struct i387_fxsave_struct __user *buf,
 			    void __user *fpstate,
 			    struct _fpx_sw_bytes *sw);
 
-static inline int xrstor_checking(struct xsave_struct *fx)
+static inline int fpu_xrstor_checking(struct fpu *fpu)
 {
+	struct xsave_struct *fx = &fpu->state->xsave;
 	int err;
 
 	asm volatile("1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
@@ -110,12 +111,12 @@ static inline void xrstor_state(struct xsave_struct *fx, u64 mask)
 		     :   "memory");
 }
 
-static inline void xsave(struct task_struct *tsk)
+static inline void fpu_xsave(struct fpu *fpu)
 {
 	/* This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
 	__asm__ __volatile__(".byte " REX_PREFIX "0x0f,0xae,0x27"
-			     : : "D" (&(tsk->thread.xstate->xsave)),
+			     : : "D" (&(fpu->state->xsave)),
 				 "a" (-1), "d"(-1) : "memory");
 }
 #endif
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 14ca1dc..86cef6b 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -107,57 +107,57 @@ void __cpuinit fpu_init(void)
 }
 #endif	/* CONFIG_X86_64 */
 
-/*
- * The _current_ task is using the FPU for the first time
- * so initialize it and set the mxcsr to its default
- * value at reset if we support XMM instructions and then
- * remeber the current task has used the FPU.
- */
-int init_fpu(struct task_struct *tsk)
+static void fpu_finit(struct fpu *fpu)
 {
-	if (tsk_used_math(tsk)) {
-		if (HAVE_HWFP && tsk == current)
-			unlazy_fpu(tsk);
-		return 0;
-	}
-
-	/*
-	 * Memory allocation at the first usage of the FPU and other state.
-	 */
-	if (!tsk->thread.xstate) {
-		tsk->thread.xstate = kmem_cache_alloc(task_xstate_cachep,
-						      GFP_KERNEL);
-		if (!tsk->thread.xstate)
-			return -ENOMEM;
-	}
-
 #ifdef CONFIG_X86_32
 	if (!HAVE_HWFP) {
-		memset(tsk->thread.xstate, 0, xstate_size);
-		finit_task(tsk);
-		set_stopped_child_used_math(tsk);
-		return 0;
+		finit_soft_fpu(&fpu->state->soft);
+		return;
 	}
 #endif
 
 	if (cpu_has_fxsr) {
-		struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
+		struct i387_fxsave_struct *fx = &fpu->state->fxsave;
 
 		memset(fx, 0, xstate_size);
 		fx->cwd = 0x37f;
 		if (cpu_has_xmm)
 			fx->mxcsr = MXCSR_DEFAULT;
 	} else {
-		struct i387_fsave_struct *fp = &tsk->thread.xstate->fsave;
+		struct i387_fsave_struct *fp = &fpu->state->fsave;
 		memset(fp, 0, xstate_size);
 		fp->cwd = 0xffff037fu;
 		fp->swd = 0xffff0000u;
 		fp->twd = 0xffffffffu;
 		fp->fos = 0xffff0000u;
 	}
+}
+
+/*
+ * The _current_ task is using the FPU for the first time
+ * so initialize it and set the mxcsr to its default
+ * value at reset if we support XMM instructions and then
+ * remeber the current task has used the FPU.
+ */
+int init_fpu(struct task_struct *tsk)
+{
+	int ret;
+
+	if (tsk_used_math(tsk)) {
+		if (HAVE_HWFP && tsk == current)
+			unlazy_fpu(tsk);
+		return 0;
+	}
+
 	/*
-	 * Only the device not available exception or ptrace can call init_fpu.
+	 * Memory allocation at the first usage of the FPU and other state.
 	 */
+	ret = fpu_alloc(&tsk->thread.fpu);
+	if (ret)
+		return ret;
+
+	fpu_finit(&tsk->thread.fpu);
+
 	set_stopped_child_used_math(tsk);
 	return 0;
 }
@@ -191,7 +191,7 @@ int xfpregs_get(struct task_struct *target, const struct user_regset *regset,
 		return ret;
 
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-				   &target->thread.xstate->fxsave, 0, -1);
+				   &target->thread.fpu.state->fxsave, 0, -1);
 }
 
 int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
@@ -208,19 +208,19 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 		return ret;
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 &target->thread.xstate->fxsave, 0, -1);
+				 &target->thread.fpu.state->fxsave, 0, -1);
 
 	/*
 	 * mxcsr reserved bits must be masked to zero for security reasons.
 	 */
-	target->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
+	target->thread.fpu.state->fxsave.mxcsr &= mxcsr_feature_mask;
 
 	/*
 	 * update the header bits in the xsave header, indicating the
 	 * presence of FP and SSE state.
 	 */
 	if (cpu_has_xsave)
-		target->thread.xstate->xsave.xsave_hdr.xstate_bv |= XSTATE_FPSSE;
+		target->thread.fpu.state->xsave.xsave_hdr.xstate_bv |= XSTATE_FPSSE;
 
 	return ret;
 }
@@ -243,14 +243,14 @@ int xstateregs_get(struct task_struct *target, const struct user_regset *regset,
 	 * memory layout in the thread struct, so that we can copy the entire
 	 * xstateregs to the user using one user_regset_copyout().
 	 */
-	memcpy(&target->thread.xstate->fxsave.sw_reserved,
+	memcpy(&target->thread.fpu.state->fxsave.sw_reserved,
 	       xstate_fx_sw_bytes, sizeof(xstate_fx_sw_bytes));
 
 	/*
 	 * Copy the xstate memory layout.
 	 */
 	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-				  &target->thread.xstate->xsave, 0, -1);
+				  &target->thread.fpu.state->xsave, 0, -1);
 	return ret;
 }
 
@@ -269,14 +269,14 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 		return ret;
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 &target->thread.xstate->xsave, 0, -1);
+				 &target->thread.fpu.state->xsave, 0, -1);
 
 	/*
 	 * mxcsr reserved bits must be masked to zero for security reasons.
 	 */
-	target->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
+	target->thread.fpu.state->fxsave.mxcsr &= mxcsr_feature_mask;
 
-	xsave_hdr = &target->thread.xstate->xsave.xsave_hdr;
+	xsave_hdr = &target->thread.fpu.state->xsave.xsave_hdr;
 
 	xsave_hdr->xstate_bv &= pcntxt_mask;
 	/*
@@ -362,7 +362,7 @@ static inline u32 twd_fxsr_to_i387(struct i387_fxsave_struct *fxsave)
 static void
 convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 {
-	struct i387_fxsave_struct *fxsave = &tsk->thread.xstate->fxsave;
+	struct i387_fxsave_struct *fxsave = &tsk->thread.fpu.state->fxsave;
 	struct _fpreg *to = (struct _fpreg *) &env->st_space[0];
 	struct _fpxreg *from = (struct _fpxreg *) &fxsave->st_space[0];
 	int i;
@@ -402,7 +402,7 @@ static void convert_to_fxsr(struct task_struct *tsk,
 			    const struct user_i387_ia32_struct *env)
 
 {
-	struct i387_fxsave_struct *fxsave = &tsk->thread.xstate->fxsave;
+	struct i387_fxsave_struct *fxsave = &tsk->thread.fpu.state->fxsave;
 	struct _fpreg *from = (struct _fpreg *) &env->st_space[0];
 	struct _fpxreg *to = (struct _fpxreg *) &fxsave->st_space[0];
 	int i;
@@ -442,7 +442,7 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
 
 	if (!cpu_has_fxsr) {
 		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-					   &target->thread.xstate->fsave, 0,
+					   &target->thread.fpu.state->fsave, 0,
 					   -1);
 	}
 
@@ -472,7 +472,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 
 	if (!cpu_has_fxsr) {
 		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-					  &target->thread.xstate->fsave, 0, -1);
+					  &target->thread.fpu.state->fsave, 0, -1);
 	}
 
 	if (pos > 0 || count < sizeof(env))
@@ -487,7 +487,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	 * presence of FP.
 	 */
 	if (cpu_has_xsave)
-		target->thread.xstate->xsave.xsave_hdr.xstate_bv |= XSTATE_FP;
+		target->thread.fpu.state->xsave.xsave_hdr.xstate_bv |= XSTATE_FP;
 	return ret;
 }
 
@@ -498,7 +498,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 static inline int save_i387_fsave(struct _fpstate_ia32 __user *buf)
 {
 	struct task_struct *tsk = current;
-	struct i387_fsave_struct *fp = &tsk->thread.xstate->fsave;
+	struct i387_fsave_struct *fp = &tsk->thread.fpu.state->fsave;
 
 	fp->status = fp->swd;
 	if (__copy_to_user(buf, fp, sizeof(struct i387_fsave_struct)))
@@ -509,7 +509,7 @@ static inline int save_i387_fsave(struct _fpstate_ia32 __user *buf)
 static int save_i387_fxsave(struct _fpstate_ia32 __user *buf)
 {
 	struct task_struct *tsk = current;
-	struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
+	struct i387_fxsave_struct *fx = &tsk->thread.fpu.state->fxsave;
 	struct user_i387_ia32_struct env;
 	int err = 0;
 
@@ -544,7 +544,7 @@ static int save_i387_xsave(void __user *buf)
 	 * header as well as change any contents in the memory layout.
 	 * xrestore as part of sigreturn will capture all the changes.
 	 */
-	tsk->thread.xstate->xsave.xsave_hdr.xstate_bv |= XSTATE_FPSSE;
+	tsk->thread.fpu.state->xsave.xsave_hdr.xstate_bv |= XSTATE_FPSSE;
 
 	if (save_i387_fxsave(fx) < 0)
 		return -1;
@@ -596,7 +596,7 @@ static inline int restore_i387_fsave(struct _fpstate_ia32 __user *buf)
 {
 	struct task_struct *tsk = current;
 
-	return __copy_from_user(&tsk->thread.xstate->fsave, buf,
+	return __copy_from_user(&tsk->thread.fpu.state->fsave, buf,
 				sizeof(struct i387_fsave_struct));
 }
 
@@ -607,10 +607,10 @@ static int restore_i387_fxsave(struct _fpstate_ia32 __user *buf,
 	struct user_i387_ia32_struct env;
 	int err;
 
-	err = __copy_from_user(&tsk->thread.xstate->fxsave, &buf->_fxsr_env[0],
+	err = __copy_from_user(&tsk->thread.fpu.state->fxsave, &buf->_fxsr_env[0],
 			       size);
 	/* mxcsr reserved bits must be masked to zero for security reasons */
-	tsk->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
+	tsk->thread.fpu.state->fxsave.mxcsr &= mxcsr_feature_mask;
 	if (err || __copy_from_user(&env, buf, sizeof(env)))
 		return 1;
 	convert_to_fxsr(tsk, &env);
@@ -626,7 +626,7 @@ static int restore_i387_xsave(void __user *buf)
 	struct i387_fxsave_struct __user *fx =
 		(struct i387_fxsave_struct __user *) &fx_user->_fxsr_env[0];
 	struct xsave_hdr_struct *xsave_hdr =
-				&current->thread.xstate->xsave.xsave_hdr;
+				&current->thread.fpu.state->xsave.xsave_hdr;
 	u64 mask;
 	int err;
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index eccdb57..8bcc21f 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -31,24 +31,22 @@ struct kmem_cache *task_xstate_cachep;
 
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
+	int ret;
+
 	*dst = *src;
-	if (src->thread.xstate) {
-		dst->thread.xstate = kmem_cache_alloc(task_xstate_cachep,
-						      GFP_KERNEL);
-		if (!dst->thread.xstate)
-			return -ENOMEM;
-		WARN_ON((unsigned long)dst->thread.xstate & 15);
-		memcpy(dst->thread.xstate, src->thread.xstate, xstate_size);
+	if (fpu_allocated(&src->thread.fpu)) {
+		memset(&dst->thread.fpu, 0, sizeof(dst->thread.fpu));
+		ret = fpu_alloc(&dst->thread.fpu);
+		if (ret)
+			return ret;
+		fpu_copy(&dst->thread.fpu, &src->thread.fpu);
 	}
 	return 0;
 }
 
 void free_thread_xstate(struct task_struct *tsk)
 {
-	if (tsk->thread.xstate) {
-		kmem_cache_free(task_xstate_cachep, tsk->thread.xstate);
-		tsk->thread.xstate = NULL;
-	}
+	fpu_free(&tsk->thread.fpu);
 }
 
 void free_thread_info(struct thread_info *ti)
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 75090c5..8d12878 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -309,7 +309,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	/* we're going to use this soon, after a few expensive things */
 	if (preload_fpu)
-		prefetch(next->xstate);
+		prefetch(next->fpu.state);
 
 	/*
 	 * Reload esp0.
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index cc4258f..758de3b 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -388,7 +388,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	/* we're going to use this soon, after a few expensive things */
 	if (preload_fpu)
-		prefetch(next->xstate);
+		prefetch(next->fpu.state);
 
 	/*
 	 * Reload esp0, LDT and the page table pointer:
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index c1b0a11..37e68fc 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -109,7 +109,7 @@ int save_i387_xstate(void __user *buf)
 		task_thread_info(tsk)->status &= ~TS_USEDFPU;
 		stts();
 	} else {
-		if (__copy_to_user(buf, &tsk->thread.xstate->fxsave,
+		if (__copy_to_user(buf, &tsk->thread.fpu.state->fxsave,
 				   xstate_size))
 			return -1;
 	}
diff --git a/arch/x86/math-emu/fpu_aux.c b/arch/x86/math-emu/fpu_aux.c
index aa09870..62797f9 100644
--- a/arch/x86/math-emu/fpu_aux.c
+++ b/arch/x86/math-emu/fpu_aux.c
@@ -30,10 +30,10 @@ static void fclex(void)
 }
 
 /* Needs to be externally visible */
-void finit_task(struct task_struct *tsk)
+void finit_soft_fpu(struct i387_soft_struct *soft)
 {
-	struct i387_soft_struct *soft = &tsk->thread.xstate->soft;
 	struct address *oaddr, *iaddr;
+	memset(soft, 0, sizeof(*soft));
 	soft->cwd = 0x037f;
 	soft->swd = 0;
 	soft->ftop = 0;	/* We don't keep top in the status word internally. */
@@ -52,7 +52,7 @@ void finit_task(struct task_struct *tsk)
 
 void finit(void)
 {
-	finit_task(current);
+	finit_task(&current->thread.fpu);
 }
 
 /*
-- 
1.7.0.4

