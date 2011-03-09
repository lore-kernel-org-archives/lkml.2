Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab1CITQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 14:16:10 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:26966 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1CITPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 14:15:20 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LHT1H8-02-10L-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>, <brgerst@gmail.com>,
        <robert.richter@amd.com>, <Andreas.Herrmann3@amd.com>,
        <eranian@google.com>, <suresh.b.siddha@intel.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [RFC 5/8] x86, xsave: more cleanups
Date: Wed, 9 Mar 2011 20:14:59 +0100
Message-ID: <1299698102-972771-6-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299698102-972771-1-git-send-email-hans.rosenfeld@amd.com>
References: <1299698102-972771-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/x86/include/asm/i387.h        |   48 ++++++++++++------------------------
 arch/x86/include/asm/thread_info.h |    2 -
 arch/x86/include/asm/xsave.h       |    9 ++----
 arch/x86/kernel/i387.c             |   12 ++++++---
 arch/x86/kernel/xsave.c            |   32 +++++++++++------------
 arch/x86/kvm/vmx.c                 |    2 +-
 arch/x86/kvm/x86.c                 |    4 +-
 7 files changed, 45 insertions(+), 64 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 97867ea..c81b63e 100644
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
@@ -217,12 +202,11 @@ static inline void fpu_clean(struct fpu *fpu)
 
 static inline void __clear_fpu(struct task_struct *tsk)
 {
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {
+	if (task_thread_info(tsk)->xstate_mask & XCNTXT_LAZY) {
 		/* Ignore delayed exceptions from user space */
 		asm volatile("1: fwait\n"
 			     "2:\n"
 			     _ASM_EXTABLE(1b, 2b));
-		task_thread_info(tsk)->status &= ~TS_USEDFPU;
 		task_thread_info(tsk)->xstate_mask &= ~XCNTXT_LAZY;
 		stts();
 	}
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 5c92d21..13de316 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -238,8 +238,6 @@ static inline struct thread_info *current_thread_info(void)
  * ever touches our thread-synchronous status, so we don't
  * have to worry about atomic accesses.
  */
-#define TS_USEDFPU		0x0001	/* FPU was used by this task
-					   this quantum (SMP) */
 #define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
 #define TS_POLLING		0x0004	/* idle task polling need_resched,
 					   skip sending interrupt */
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 742da4a..fbbc7db 100644
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
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index d2d2b69..88fefba 100644
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
index a10c13e..b6d6f38 100644
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
@@ -500,17 +501,17 @@ void __cpuinit xsave_init(void)
 	this_func();
 }
 
-void xsave(struct fpu *fpu, u64 mask)
+void xsave(struct xsave_struct *x, u64 mask)
 {
 	clts();
 
 	if (use_xsave())
-		fpu_xsave(&fpu->state->xsave, mask);
+		fpu_xsave(x, mask);
 	else if (mask & XCNTXT_LAZY)
-		fpu_save(fpu);
+		fpu_save(&x->i387);
 
 	if (mask & XCNTXT_LAZY)
-		fpu_clean(fpu);
+		fpu_clean(&x->i387);
 
 	stts();
 }
@@ -523,7 +524,7 @@ void save_xstates(struct task_struct *tsk)
 	if (!fpu_allocated(&tsk->thread.fpu))
 		return;
 
-	xsave(&tsk->thread.fpu, ti->xstate_mask);
+	xsave(&tsk->thread.fpu.state->xsave, ti->xstate_mask);
 
 	if (!(ti->xstate_mask & XCNTXT_LAZY))
 		tsk->fpu_counter = 0;
@@ -535,19 +536,17 @@ void save_xstates(struct task_struct *tsk)
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
@@ -561,10 +560,9 @@ void restore_xstates(struct task_struct *tsk, u64 mask)
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
index bf89ec2..d79bf2f 100644
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
index 8fb21ea..10aeb04 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5795,7 +5795,7 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 	kvm_put_guest_xcr0(vcpu);
 	vcpu->guest_fpu_loaded = 1;
 	save_xstates(current);
-	xrstor(&vcpu->arch.guest_fpu, -1);
+	xrstor(&vcpu->arch.guest_fpu.state->xsave, -1);
 	trace_kvm_fpu(1);
 }
 
@@ -5807,7 +5807,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 		return;
 
 	vcpu->guest_fpu_loaded = 0;
-	xsave(&vcpu->arch.guest_fpu, -1);
+	xsave(&vcpu->arch.guest_fpu.state->xsave, -1);
 	++vcpu->stat.fpu_reload;
 	kvm_make_request(KVM_REQ_DEACTIVATE_FPU, vcpu);
 	trace_kvm_fpu(0);
-- 
1.5.6.5


