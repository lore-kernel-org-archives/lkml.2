Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab1DFWFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:05:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:50715 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252Ab1DFWFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:05:47 -0400
Date: Wed, 6 Apr 2011 22:05:35 GMT
From: tip-bot for Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel@vger.kernel.org, hans.rosenfeld@amd.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, hans.rosenfeld@amd.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: 1302018656-586370-6-git-send-email-hans.rosenfeld@amd.com
References: 1302018656-586370-6-git-send-email-hans.rosenfeld@amd.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86, xsave: more cleanups
Message-ID: <tip-324cbb83e215fd8abc73021ef9fd98b151225e01@git.kernel.org>
Git-Commit-ID: 324cbb83e215fd8abc73021ef9fd98b151225e01
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 06 Apr 2011 22:05:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  324cbb83e215fd8abc73021ef9fd98b151225e01
Gitweb:     http://git.kernel.org/tip/324cbb83e215fd8abc73021ef9fd98b151225e01
Author:     Hans Rosenfeld <hans.rosenfeld@amd.com>
AuthorDate: Tue, 5 Apr 2011 17:50:53 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 6 Apr 2011 14:15:19 -0700

x86, xsave: more cleanups

Removed some declarations from headers that weren't used.

Retired TS_USEDFPU, it has been replaced by the XCNTXT_* bits in
xstate_mask.

There is no reason functions like fpu_fxsave() etc. need to know or
handle anything else than a buffer to save/restore their stuff to/from.

Sanitize_i387_state() is extra work that is only needed when xsaveopt is
used. There is no point in hiding this in an inline function, adding
extra code lines just to save a single if() in the five places it is
used. Also, it is obscuring a fact that might well be interesting to
whoever is reading the code, but it is not gaining anything.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
Link: http://lkml.kernel.org/r/1302018656-586370-6-git-send-email-hans.rosenfeld@amd.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/i387.h        |   67 ++++++++++++-----------------------
 arch/x86/include/asm/thread_info.h |    2 -
 arch/x86/include/asm/xsave.h       |   14 +++----
 arch/x86/kernel/i387.c             |   12 ++++--
 arch/x86/kernel/xsave.c            |   32 ++++++++---------
 arch/x86/kvm/vmx.c                 |    2 +-
 arch/x86/kvm/x86.c                 |    4 +-
 7 files changed, 55 insertions(+), 78 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 75c0800..0381578 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -42,7 +42,6 @@ extern void fpu_init(void);
 extern void mxcsr_feature_mask_init(void);
 extern int init_fpu(struct task_struct *child);
 extern asmlinkage void math_state_restore(void);
-extern void __math_state_restore(void);
 extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 
 extern void convert_from_fxsr(struct user_i387_ia32_struct *, struct task_struct *);
@@ -60,15 +59,10 @@ extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set,
  */
 #define xstateregs_active	fpregs_active
 
-extern struct _fpx_sw_bytes fx_sw_reserved;
 extern unsigned int mxcsr_feature_mask;
+
 #ifdef CONFIG_IA32_EMULATION
 extern unsigned int sig_xstate_ia32_size;
-extern struct _fpx_sw_bytes fx_sw_reserved_ia32;
-struct _fpstate_ia32;
-struct _xstate_ia32;
-extern int save_i387_xstate_ia32(void __user *buf);
-extern int restore_i387_xstate_ia32(void __user *buf);
 #endif
 
 #ifdef CONFIG_MATH_EMULATION
@@ -76,7 +70,7 @@ extern int restore_i387_xstate_ia32(void __user *buf);
 extern void finit_soft_fpu(struct i387_soft_struct *soft);
 #else
 # define HAVE_HWFP		1
-static inline void finit_soft_fpu(struct i387_soft_struct *soft) {}
+# define finit_soft_fpu(x)
 #endif
 
 #define X87_FSW_ES (1 << 7)	/* Exception Summary */
@@ -96,15 +90,6 @@ static __always_inline __pure bool use_fxsr(void)
         return static_cpu_has(X86_FEATURE_FXSR);
 }
 
-extern void __sanitize_i387_state(struct task_struct *);
-
-static inline void sanitize_i387_state(struct task_struct *tsk)
-{
-	if (!use_xsaveopt())
-		return;
-	__sanitize_i387_state(tsk);
-}
-
 #ifdef CONFIG_X86_64
 static inline void fxrstor(struct i387_fxsave_struct *fx)
 {
@@ -118,7 +103,7 @@ static inline void fxrstor(struct i387_fxsave_struct *fx)
 #endif
 }
 
-static inline void fpu_fxsave(struct fpu *fpu)
+static inline void fpu_fxsave(struct i387_fxsave_struct *fx)
 {
 	/* Using "rex64; fxsave %0" is broken because, if the memory operand
 	   uses any extended registers for addressing, a second REX prefix
@@ -129,7 +114,7 @@ static inline void fpu_fxsave(struct fpu *fpu)
 	/* Using "fxsaveq %0" would be the ideal choice, but is only supported
 	   starting with gas 2.16. */
 	__asm__ __volatile__("fxsaveq %0"
-			     : "=m" (fpu->state->fxsave));
+			     : "=m" (*fx));
 #else
 	/* Using, as a workaround, the properly prefixed form below isn't
 	   accepted by any binutils version so far released, complaining that
@@ -140,8 +125,8 @@ static inline void fpu_fxsave(struct fpu *fpu)
 	   This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
 	asm volatile("rex64/fxsave (%[fx])"
-		     : "=m" (fpu->state->fxsave)
-		     : [fx] "R" (&fpu->state->fxsave));
+		     : "=m" (*fx)
+		     : [fx] "R" (fx));
 #endif
 }
 
@@ -161,10 +146,10 @@ static inline void fxrstor(struct i387_fxsave_struct *fx)
 		"m" (*fx));
 }
 
-static inline void fpu_fxsave(struct fpu *fpu)
+static inline void fpu_fxsave(struct i387_fxsave_struct *fx)
 {
 	asm volatile("fxsave %[fx]"
-		     : [fx] "=m" (fpu->state->fxsave));
+		     : [fx] "=m" (*fx));
 }
 
 #endif	/* CONFIG_X86_64 */
@@ -181,25 +166,25 @@ static inline void fpu_fxsave(struct fpu *fpu)
 /*
  * These must be called with preempt disabled
  */
-static inline void fpu_restore(struct fpu *fpu)
+static inline void fpu_restore(struct i387_fxsave_struct *fx)
 {
-	fxrstor(&fpu->state->fxsave);
+	fxrstor(fx);
 }
 
-static inline void fpu_save(struct fpu *fpu)
+static inline void fpu_save(struct i387_fxsave_struct *fx)
 {
 	if (use_fxsr()) {
-		fpu_fxsave(fpu);
+		fpu_fxsave(fx);
 	} else {
 		asm volatile("fsave %[fx]; fwait"
-			     : [fx] "=m" (fpu->state->fsave));
+			     : [fx] "=m" (*fx));
 	}
 }
 
-static inline void fpu_clean(struct fpu *fpu)
+static inline void fpu_clean(struct i387_fxsave_struct *fx)
 {
 	u32 swd = (use_fxsr() || use_xsave()) ?
-		fpu->state->fxsave.swd : fpu->state->fsave.swd;
+		fx->swd : ((struct i387_fsave_struct *)fx)->swd;
 
 	if (unlikely(swd & X87_FSW_ES))
 		asm volatile("fnclex");
@@ -215,19 +200,6 @@ static inline void fpu_clean(struct fpu *fpu)
 		[addr] "m" (safe_address));
 }
 
-static inline void __clear_fpu(struct task_struct *tsk)
-{
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		/* Ignore delayed exceptions from user space */
-		asm volatile("1: fwait\n"
-			     "2:\n"
-			     _ASM_EXTABLE(1b, 2b));
-		task_thread_info(tsk)->status &= ~TS_USEDFPU;
-		task_thread_info(tsk)->xstate_mask &= ~XCNTXT_LAZY;
-		stts();
-	}
-}
-
 static inline void kernel_fpu_begin(void)
 {
 	preempt_disable();
@@ -286,7 +258,14 @@ static inline void irq_ts_restore(int TS_state)
 static inline void clear_fpu(struct task_struct *tsk)
 {
 	preempt_disable();
-	__clear_fpu(tsk);
+	if (task_thread_info(tsk)->xstate_mask & XCNTXT_LAZY) {
+		/* Ignore delayed exceptions from user space */
+		asm volatile("1: fwait\n"
+			     "2:\n"
+			     _ASM_EXTABLE(1b, 2b));
+		task_thread_info(tsk)->xstate_mask &= ~XCNTXT_LAZY;
+		stts();
+	}
 	preempt_enable();
 }
 
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index ec12d62..0e691c6 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -244,8 +244,6 @@ static inline struct thread_info *current_thread_info(void)
  * ever touches our thread-synchronous status, so we don't
  * have to worry about atomic accesses.
  */
-#define TS_USEDFPU		0x0001	/* FPU was used by this task
-					   this quantum (SMP) */
 #define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
 #define TS_POLLING		0x0004	/* idle task polling need_resched,
 					   skip sending interrupt */
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 742da4a..b8861d4 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -37,8 +37,8 @@ extern unsigned int xstate_size;
 extern u64 pcntxt_mask;
 extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
 
-extern void xsave(struct fpu *, u64);
-extern void xrstor(struct fpu *, u64);
+extern void xsave(struct xsave_struct *, u64);
+extern void xrstor(struct xsave_struct *, u64);
 extern void save_xstates(struct task_struct *);
 extern void restore_xstates(struct task_struct *, u64);
 extern int save_xstates_sigframe(void __user *, unsigned int);
@@ -46,10 +46,7 @@ extern int restore_xstates_sigframe(void __user *, unsigned int);
 
 extern void xsave_init(void);
 extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
-extern int init_fpu(struct task_struct *child);
-extern int check_for_xstate(struct i387_fxsave_struct __user *buf,
-			    unsigned int size,
-			    struct _fpx_sw_bytes *sw);
+extern void sanitize_i387_state(struct task_struct *);
 
 static inline void xrstor_state(struct xsave_struct *fx, u64 mask)
 {
@@ -71,7 +68,7 @@ static inline void xsave_state(struct xsave_struct *fx, u64 mask)
 		     :   "memory");
 }
 
-static inline void fpu_xsave(struct xsave_struct *fx, u64 mask)
+static inline void xsaveopt_state(struct xsave_struct *fx, u64 mask)
 {
 	u32 lmask = mask;
 	u32 hmask = mask >> 32;
@@ -82,7 +79,8 @@ static inline void fpu_xsave(struct xsave_struct *fx, u64 mask)
 		".byte " REX_PREFIX "0x0f,0xae,0x27",
 		".byte " REX_PREFIX "0x0f,0xae,0x37",
 		X86_FEATURE_XSAVEOPT,
-		[fx] "D" (fx), "a" (lmask), "d" (hmask) :
+		"D" (fx), "a" (lmask), "d" (hmask) :
 		"memory");
 }
+
 #endif
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index ca33c0b..dd9644a 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -182,7 +182,8 @@ int xfpregs_get(struct task_struct *target, const struct user_regset *regset,
 	if (ret)
 		return ret;
 
-	sanitize_i387_state(target);
+	if (use_xsaveopt())
+		sanitize_i387_state(target);
 
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
 				   &target->thread.fpu.state->fxsave, 0, -1);
@@ -201,7 +202,8 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (ret)
 		return ret;
 
-	sanitize_i387_state(target);
+	if (use_xsaveopt())
+		sanitize_i387_state(target);
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				 &target->thread.fpu.state->fxsave, 0, -1);
@@ -440,7 +442,8 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
 					   -1);
 	}
 
-	sanitize_i387_state(target);
+	if (use_xsaveopt())
+		sanitize_i387_state(target);
 
 	if (kbuf && pos == 0 && count == sizeof(env)) {
 		convert_from_fxsr(kbuf, target);
@@ -463,7 +466,8 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (ret)
 		return ret;
 
-	sanitize_i387_state(target);
+	if (use_xsaveopt())
+		sanitize_i387_state(target);
 
 	if (!HAVE_HWFP)
 		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 9ecc791..d42810f 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -39,7 +39,7 @@ static unsigned int *xstate_offsets, *xstate_sizes, xstate_features;
  * that the user doesn't see some stale state in the memory layout during
  * signal handling, debugging etc.
  */
-void __sanitize_i387_state(struct task_struct *tsk)
+void sanitize_i387_state(struct task_struct *tsk)
 {
 	u64 xstate_bv;
 	int feature_bit = 0x2;
@@ -48,7 +48,7 @@ void __sanitize_i387_state(struct task_struct *tsk)
 	if (!fx)
 		return;
 
-	BUG_ON(task_thread_info(tsk)->status & TS_USEDFPU);
+	BUG_ON(task_thread_info(tsk)->xstate_mask & XCNTXT_LAZY);
 
 	xstate_bv = tsk->thread.fpu.state->xsave.xsave_hdr.xstate_bv;
 
@@ -103,8 +103,8 @@ void __sanitize_i387_state(struct task_struct *tsk)
  * Check for the presence of extended state information in the
  * user fpstate pointer in the sigcontext.
  */
-int check_for_xstate(struct i387_fxsave_struct __user *buf, unsigned int size,
-		     struct _fpx_sw_bytes *fx_sw_user)
+static int check_for_xstate(struct i387_fxsave_struct __user *buf, unsigned int size,
+			    struct _fpx_sw_bytes *fx_sw_user)
 {
 	int min_xstate_size = sizeof(struct i387_fxsave_struct) +
 			      sizeof(struct xsave_hdr_struct);
@@ -176,7 +176,8 @@ int save_xstates_sigframe(void __user *buf, unsigned int size)
 			(struct _fpstate_ia32 __user *) buf) ? -1 : 1;
 
 	save_xstates(tsk);
-	sanitize_i387_state(tsk);
+	if (use_xsaveopt())
+		sanitize_i387_state(tsk);
 
 #if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
 	if (ia32) {
@@ -498,17 +499,17 @@ void __cpuinit xsave_init(void)
 	this_func();
 }
 
-void xsave(struct fpu *fpu, u64 mask)
+void xsave(struct xsave_struct *x, u64 mask)
 {
 	clts();
 
 	if (use_xsave())
-		fpu_xsave(&fpu->state->xsave, mask);
+		xsaveopt_state(x, mask);
 	else if (mask & XCNTXT_LAZY)
-		fpu_save(fpu);
+		fpu_save(&x->i387);
 
 	if (mask & XCNTXT_LAZY)
-		fpu_clean(fpu);
+		fpu_clean(&x->i387);
 
 	stts();
 }
@@ -521,7 +522,7 @@ void save_xstates(struct task_struct *tsk)
 	if (!fpu_allocated(&tsk->thread.fpu))
 		return;
 
-	xsave(&tsk->thread.fpu, ti->xstate_mask);
+	xsave(&tsk->thread.fpu.state->xsave, ti->xstate_mask);
 
 	if (!(ti->xstate_mask & XCNTXT_LAZY))
 		tsk->fpu_counter = 0;
@@ -533,19 +534,17 @@ void save_xstates(struct task_struct *tsk)
 	 */
 	if (tsk->fpu_counter < 5)
 		ti->xstate_mask &= ~XCNTXT_LAZY;
-
-	ti->status &= ~TS_USEDFPU;
 }
 EXPORT_SYMBOL(save_xstates);
 
-void xrstor(struct fpu *fpu, u64 mask)
+void xrstor(struct xsave_struct *x, u64 mask)
 {
 	clts();
 
 	if (use_xsave())
-		xrstor_state(&fpu->state->xsave, mask);
+		xrstor_state(x, mask);
 	else if (mask & XCNTXT_LAZY)
-		fpu_restore(fpu);
+		fpu_restore(&x->i387);
 
 	if (!(mask & XCNTXT_LAZY))
 		stts();
@@ -559,10 +558,9 @@ void restore_xstates(struct task_struct *tsk, u64 mask)
 	if (!fpu_allocated(&tsk->thread.fpu))
 		return;
 
-	xrstor(&tsk->thread.fpu, mask);
+	xrstor(&tsk->thread.fpu.state->xsave, mask);
 
 	ti->xstate_mask |= mask;
-	ti->status |= TS_USEDFPU;
 	if (mask & XCNTXT_LAZY)
 		tsk->fpu_counter++;
 }
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 5b4cdcb..f756c95 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -876,7 +876,7 @@ static void __vmx_load_host_state(struct vcpu_vmx *vmx)
 #ifdef CONFIG_X86_64
 	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
 #endif
-	if (current_thread_info()->status & TS_USEDFPU)
+	if (current_thread_info()->xstate_mask & XCNTXT_LAZY)
 		clts();
 	load_gdt(&__get_cpu_var(host_gdt));
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aae9e8f..bc04e15 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5805,7 +5805,7 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 	kvm_put_guest_xcr0(vcpu);
 	vcpu->guest_fpu_loaded = 1;
 	save_xstates(current);
-	xrstor(&vcpu->arch.guest_fpu, -1);
+	xrstor(&vcpu->arch.guest_fpu.state->xsave, -1);
 	trace_kvm_fpu(1);
 }
 
@@ -5817,7 +5817,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 		return;
 
 	vcpu->guest_fpu_loaded = 0;
-	xsave(&vcpu->arch.guest_fpu, -1);
+	xsave(&vcpu->arch.guest_fpu.state->xsave, -1);
 	++vcpu->stat.fpu_reload;
 	kvm_make_request(KVM_REQ_DEACTIVATE_FPU, vcpu);
 	trace_kvm_fpu(0);
