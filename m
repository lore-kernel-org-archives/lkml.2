Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab2FMADy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 20:03:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:25182 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab2FMADo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 20:03:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="155511191"
Subject: [RFC] x86, fpu: unify signal handling code paths for x86 and x86_64
 kernels
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Date: Tue, 12 Jun 2012 17:03:34 -0700
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1339545814.28766.148.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can split the patch if needed. And I need to do little bit more
validation (already tested on 64-bit IVB  and 32-bit NHM) before
removing the 'RFC' tag.

I tried starting with the old version of Hans patch. But there were lot
more changes in this area since then and also his patch had few
user-visible compatibility issues.

Appended is the version that I came up with. Please review.

thanks.
---
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, fpu: unify signal handling code paths for x86 and x86_64 kernels

Currently for x86 and x86_32 binaries, fpstate in the user sigframe is copied
to/from the fpstate in the task struct.

And in the case of signal delivery for x86_64 binaries, if the fpstate is live
in the CPU registers, then the live state is copied directly to the user
sigframe. Otherwise  fpstate in the task struct is copied to the user sigframe.
During restore, fpstate in the user sigframe is restored directly to the live
CPU registers.

Historically, different code paths led to different bugs. For example,
64-bit code path was not preemption safe till recently. Also there is lot
of code duplication for support of new features like xsave etc.
With xsave support, there is some software state that need to be saved during
signal delivery and double check what is present in the sigframe during
signal return paths. All these issues are diminishing the returns that we get
by saving/restoring the live fpstate directly to/from the sigframe.

Unify signal handling code paths for x86 and x86_64 kernels by
following the x86 convention of copying/restoring the sigframe state from/to
the fpstate in the task struct.

During signal delivery, make sure that the fpstate memory layout in the task
structure contains the latest fp register state (including the sanitized xstate
and the extra software state) and copy everything to the user sigframe in
minimal steps.

And during signal return, copy everything back from the user sigframe to
the fpstate in the task structure and ensure (using the extra software
state) that the restored state has sane xstate etc. At the next fpstate
usage, everything will be restored to the live CPU registers.

"lat_sig catch" microbenchmark numbers (for x86, x86_64, x86_32 binaries) are
with in the noise range with this change.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/ia32/ia32_signal.c         |    4 +-
 arch/x86/include/asm/fpu-internal.h |   64 ++++++-
 arch/x86/include/asm/xsave.h        |    3 -
 arch/x86/kernel/i387.c              |  245 +-------------------------
 arch/x86/kernel/process.c           |   10 -
 arch/x86/kernel/signal.c            |    4 +-
 arch/x86/kernel/xsave.c             |  328 +++++++++++++++++++++--------------
 7 files changed, 256 insertions(+), 402 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index daeca56..ecee57a 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -250,7 +250,7 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 
 		get_user_ex(tmp, &sc->fpstate);
 		buf = compat_ptr(tmp);
-		err |= restore_i387_xstate_ia32(buf);
+		err |= restore_xstate_sigframe(buf);
 
 		get_user_ex(*pax, &sc->ax);
 	} get_user_catch(err);
@@ -383,7 +383,7 @@ static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 	if (used_math()) {
 		sp = sp - sig_xstate_ia32_size;
 		*fpstate = (struct _fpstate_ia32 *) sp;
-		if (save_i387_xstate_ia32(*fpstate) < 0)
+		if (save_xstate_sigframe(*fpstate) < 0)
 			return (void __user *) -1L;
 	}
 
diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 75f4c6d..3482952 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -21,11 +21,28 @@
 #include <asm/uaccess.h>
 #include <asm/xsave.h>
 
+#ifdef CONFIG_X86_64
+# include <asm/sigcontext32.h>
+# include <asm/user32.h>
+#else
+# define _fpstate_ia32         _fpstate
+# define _xstate_ia32          _xstate
+# define sig_xstate_ia32_size   sig_xstate_size
+# define fx_sw_reserved_ia32   fx_sw_reserved
+# define user_i387_ia32_struct user_i387_struct
+# define user32_fxsr_struct    user_fxsr_struct
+#endif
+
 extern unsigned int sig_xstate_size;
 extern void fpu_init(void);
 
 DECLARE_PER_CPU(struct task_struct *, fpu_owner_task);
 
+extern void convert_from_fxsr(struct user_i387_ia32_struct *env,
+			      struct task_struct *tsk);
+extern void convert_to_fxsr(struct task_struct *tsk,
+			    const struct user_i387_ia32_struct *env);
+
 extern user_regset_active_fn fpregs_active, xfpregs_active;
 extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get,
 				xstateregs_get;
@@ -40,18 +57,19 @@ extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set,
 #define xstateregs_active	fpregs_active
 
 extern struct _fpx_sw_bytes fx_sw_reserved;
+extern unsigned int mxcsr_feature_mask;
 #ifdef CONFIG_IA32_EMULATION
 extern unsigned int sig_xstate_ia32_size;
 extern struct _fpx_sw_bytes fx_sw_reserved_ia32;
 struct _fpstate_ia32;
 struct _xstate_ia32;
-extern int save_i387_xstate_ia32(void __user *buf);
-extern int restore_i387_xstate_ia32(void __user *buf);
 #endif
 
 #ifdef CONFIG_MATH_EMULATION
+# define HAVE_HWFP		(boot_cpu_data.hard_math)
 extern void finit_soft_fpu(struct i387_soft_struct *soft);
 #else
+# define HAVE_HWFP		1
 static inline void finit_soft_fpu(struct i387_soft_struct *soft) {}
 #endif
 
@@ -72,13 +90,34 @@ static __always_inline __pure bool use_fxsr(void)
         return static_cpu_has(X86_FEATURE_FXSR);
 }
 
-extern void __sanitize_i387_state(struct task_struct *);
+extern void __sanitize_i387_state(struct i387_fxsave_struct *, u64);
 
 static inline void sanitize_i387_state(struct task_struct *tsk)
 {
-	if (!use_xsaveopt())
+	struct xsave_struct *xsave = &tsk->thread.fpu.state->xsave;
+	struct i387_fxsave_struct *fx = &tsk->thread.fpu.state->fxsave;
+
+	if (!use_xsave())
 		return;
-	__sanitize_i387_state(tsk);
+
+	if (use_xsaveopt())
+		__sanitize_i387_state(fx, xsave->xsave_hdr.xstate_bv);
+
+	/*
+	 * For legacy compatible, we always set FP/SSE bits in the bit
+	 * vector while saving the state to the user context. This will
+	 * enable us capturing any changes(during sigreturn) to
+	 * the FP/SSE bits by the legacy applications which don't touch
+	 * xstate_bv in the xsave header.
+	 *
+	 * xsave aware apps can change the xstate_bv in the xsave
+	 * header as well as change any contents in the memory layout.
+	 * xrestore as part of sigreturn will capture all the changes.
+	 */
+	xsave->xsave_hdr.xstate_bv |= XSTATE_FPSSE;
+	memcpy(&fx->sw_reserved,
+	       is_ia32_task() ? &fx_sw_reserved_ia32 : &fx_sw_reserved,
+	       sizeof(struct _fpx_sw_bytes));
 }
 
 #ifdef CONFIG_X86_64
@@ -398,10 +437,10 @@ static inline void switch_fpu_finish(struct task_struct *new, fpu_switch_t fpu)
 /*
  * Signal frame handlers...
  */
-extern int save_i387_xstate(void __user *buf);
-extern int restore_i387_xstate(void __user *buf);
+extern int save_xstate_sigframe(void __user *buf);
+extern int restore_xstate_sigframe(void __user *buf);
 
-static inline void __clear_fpu(struct task_struct *tsk)
+static inline void __drop_fpu(struct task_struct *tsk)
 {
 	if (__thread_has_fpu(tsk)) {
 		/* Ignore delayed exceptions from user space */
@@ -449,11 +488,16 @@ static inline void save_init_fpu(struct task_struct *tsk)
 	preempt_enable();
 }
 
-static inline void clear_fpu(struct task_struct *tsk)
+static inline void drop_fpu(struct task_struct *tsk)
 {
+	/*
+	 * Forget coprocessor state..
+	 */
+	tsk->fpu_counter = 0;
 	preempt_disable();
-	__clear_fpu(tsk);
+	__drop_fpu(tsk);
 	preempt_enable();
+	clear_used_math();
 }
 
 /*
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 8a1b6f9..1b59fd5 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -38,9 +38,6 @@ extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
 extern void xsave_init(void);
 extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
 extern int init_fpu(struct task_struct *child);
-extern int check_for_xstate(struct i387_fxsave_struct __user *buf,
-			    void __user *fpstate,
-			    struct _fpx_sw_bytes *sw);
 
 static inline int fpu_xrstor_checking(struct fpu *fpu)
 {
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index f250431..d097ce6 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -19,20 +19,6 @@
 #include <asm/fpu-internal.h>
 #include <asm/user.h>
 
-#ifdef CONFIG_X86_64
-# include <asm/sigcontext32.h>
-# include <asm/user32.h>
-#else
-# define save_i387_xstate_ia32		save_i387_xstate
-# define restore_i387_xstate_ia32	restore_i387_xstate
-# define _fpstate_ia32		_fpstate
-# define _xstate_ia32		_xstate
-# define sig_xstate_ia32_size   sig_xstate_size
-# define fx_sw_reserved_ia32	fx_sw_reserved
-# define user_i387_ia32_struct	user_i387_struct
-# define user32_fxsr_struct	user_fxsr_struct
-#endif
-
 /*
  * Were we in an interrupt that interrupted kernel mode?
  *
@@ -113,13 +99,7 @@ void unlazy_fpu(struct task_struct *tsk)
 }
 EXPORT_SYMBOL(unlazy_fpu);
 
-#ifdef CONFIG_MATH_EMULATION
-# define HAVE_HWFP		(boot_cpu_data.hard_math)
-#else
-# define HAVE_HWFP		1
-#endif
-
-static unsigned int		mxcsr_feature_mask __read_mostly = 0xffffffffu;
+unsigned int mxcsr_feature_mask __read_mostly = 0xffffffffu;
 unsigned int xstate_size;
 EXPORT_SYMBOL_GPL(xstate_size);
 unsigned int sig_xstate_ia32_size = sizeof(struct _fpstate_ia32);
@@ -454,7 +434,7 @@ static inline u32 twd_fxsr_to_i387(struct i387_fxsave_struct *fxsave)
  * FXSR floating point environment conversions.
  */
 
-static void
+void
 convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 {
 	struct i387_fxsave_struct *fxsave = &tsk->thread.fpu.state->fxsave;
@@ -491,8 +471,8 @@ convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 		memcpy(&to[i], &from[i], sizeof(to[0]));
 }
 
-static void convert_to_fxsr(struct task_struct *tsk,
-			    const struct user_i387_ia32_struct *env)
+void convert_to_fxsr(struct task_struct *tsk,
+		     const struct user_i387_ia32_struct *env)
 
 {
 	struct i387_fxsave_struct *fxsave = &tsk->thread.fpu.state->fxsave;
@@ -589,223 +569,6 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
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
-	unlazy_fpu(tsk);
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
-	if (check_for_xstate(fx, buf, &fx_sw_user))
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
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ef6a845..30069d1 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -97,16 +97,6 @@ void arch_task_cache_init(void)
 				  SLAB_PANIC | SLAB_NOTRACK, NULL);
 }
 
-static inline void drop_fpu(struct task_struct *tsk)
-{
-	/*
-	 * Forget coprocessor state..
-	 */
-	tsk->fpu_counter = 0;
-	clear_fpu(tsk);
-	clear_used_math();
-}
-
 /*
  * Free current thread data structures etc..
  */
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index b280908..102f478 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -114,7 +114,7 @@ int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 		regs->orig_ax = -1;		/* disable syscall checks */
 
 		get_user_ex(buf, &sc->fpstate);
-		err |= restore_i387_xstate(buf);
+		err |= restore_xstate_sigframe(buf);
 
 		get_user_ex(*pax, &sc->ax);
 	} get_user_catch(err);
@@ -248,7 +248,7 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 		return (void __user *)-1L;
 
 	/* save i387 state */
-	if (used_math() && save_i387_xstate(*fpstate) < 0)
+	if (used_math() && save_xstate_sigframe(*fpstate) < 0)
 		return (void __user *)-1L;
 
 	return (void __user *)sp;
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 3d3e207..538320a 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -42,17 +42,14 @@ static unsigned int *xstate_offsets, *xstate_sizes, xstate_features;
  * that the user doesn't see some stale state in the memory layout during
  * signal handling, debugging etc.
  */
-void __sanitize_i387_state(struct task_struct *tsk)
+void
+__sanitize_i387_state(struct i387_fxsave_struct *fx, u64 xstate_bv)
 {
-	u64 xstate_bv;
 	int feature_bit = 0x2;
-	struct i387_fxsave_struct *fx = &tsk->thread.fpu.state->fxsave;
 
 	if (!fx)
 		return;
 
-	xstate_bv = tsk->thread.fpu.state->xsave.xsave_hdr.xstate_bv;
-
 	/*
 	 * None of the feature bits are in init state. So nothing else
 	 * to do for us, as the memory layout is up to date.
@@ -102,27 +99,24 @@ void __sanitize_i387_state(struct task_struct *tsk)
 
 /*
  * Check for the presence of extended state information in the
- * user fpstate pointer in the sigcontext.
+ * user fpstate pointer in the sigcontext and update the xstate_bv
+ * in the kernel state accordingly.
  */
-int check_for_xstate(struct i387_fxsave_struct __user *buf,
-		     void __user *fpstate,
-		     struct _fpx_sw_bytes *fx_sw_user)
+static inline
+int check_update_xstatebv(struct xsave_struct *xsave, void __user *fpstate,
+			  unsigned int *state_size)
 {
+	struct _fpx_sw_bytes *fx_sw_user =
+		(struct _fpx_sw_bytes *) (xsave->i387.sw_reserved);
 	int min_xstate_size = sizeof(struct i387_fxsave_struct) +
 			      sizeof(struct xsave_hdr_struct);
 	unsigned int magic2;
-	int err;
-
-	err = __copy_from_user(fx_sw_user, &buf->sw_reserved[0],
-			       sizeof(struct _fpx_sw_bytes));
-	if (err)
-		return -EFAULT;
 
 	/*
 	 * First Magic check failed.
 	 */
 	if (fx_sw_user->magic1 != FP_XSTATE_MAGIC1)
-		return -EINVAL;
+		goto fx_only;
 
 	/*
 	 * Check for error scenarios.
@@ -130,13 +124,12 @@ int check_for_xstate(struct i387_fxsave_struct __user *buf,
 	if (fx_sw_user->xstate_size < min_xstate_size ||
 	    fx_sw_user->xstate_size > xstate_size ||
 	    fx_sw_user->xstate_size > fx_sw_user->extended_size)
-		return -EINVAL;
+		goto fx_only;
 
-	err = __get_user(magic2, (__u32 *) (((void *)fpstate) +
-					    fx_sw_user->extended_size -
-					    FP_XSTATE_MAGIC2_SIZE));
-	if (err)
-		return err;
+	if (__get_user(magic2, (__u32 *) (((void *)fpstate) +
+					   fx_sw_user->extended_size -
+					   FP_XSTATE_MAGIC2_SIZE)))
+		goto fx_only;
 	/*
 	 * Check for the presence of second magic word at the end of memory
 	 * layout. This detects the case where the user just copied the legacy
@@ -144,173 +137,240 @@ int check_for_xstate(struct i387_fxsave_struct __user *buf,
 	 * in the memory layout.
 	 */
 	if (magic2 != FP_XSTATE_MAGIC2)
-		return -EFAULT;
+		goto fx_only;
 
+
+	/*
+	 * For valid xstate, clear any illegal bits and any bits
+	 * that have been cleared in fx_sw_user.xstate_bv.
+	 */
+	xsave->xsave_hdr.xstate_bv &= fx_sw_user->xstate_bv;
+	if (state_size)
+		*state_size = fx_sw_user->xstate_size;
 	return 0;
+
+fx_only:
+	xsave->xsave_hdr.xstate_bv &= XSTATE_FPSSE;
+	return -1;
 }
 
-#ifdef CONFIG_X86_64
 /*
  * Signal frame handlers.
  */
-
-int save_i387_xstate(void __user *buf)
+static inline int
+save_fsave_prolog(struct task_struct *tsk, void __user *buf, void **buf_fx)
 {
-	struct task_struct *tsk = current;
-	int err = 0;
+	if (use_fxsr()) {
+		struct xsave_struct *xsave = &tsk->thread.fpu.state->xsave;
+		struct user_i387_ia32_struct env;
+		struct _fpstate_ia32 __user *fp = buf;
 
-	if (!access_ok(VERIFY_WRITE, buf, sig_xstate_size))
-		return -EACCES;
+		convert_from_fxsr(&env, tsk);
+
+		if (__copy_to_user(buf, &env, sizeof(env)) ||
+		    __put_user(xsave->i387.swd, &fp->status) ||
+		    __put_user(X86_FXSR_MAGIC, &fp->magic))
+			return -EACCES;
+
+		*buf_fx = &fp->_fxsr_env;
+	} else {
+		struct i387_fsave_struct *fsave = &tsk->thread.fpu.state->fsave;
+		fsave->status = fsave->swd;
+	}
+
+	return 0;
+}
 
-	BUG_ON(sig_xstate_size < xstate_size);
+static inline int save_xsave_epilog(void __user *buf, unsigned int size)
+{
+	return __put_user(FP_XSTATE_MAGIC2,
+			  (__u32 __user *)
+				(buf + size - FP_XSTATE_MAGIC2_SIZE));
+}
 
-	if ((unsigned long)buf % 64)
-		pr_err("%s: bad fpstate %p\n", __func__, buf);
+int save_xstate_sigframe(void __user *buf)
+{
+	unsigned int size = sig_xstate_size;
+	struct task_struct *tsk = current;
+	struct xsave_struct *xsave = &tsk->thread.fpu.state->xsave;
+	void __user *buf_fxsave = buf;
+	int ia32;
 
 	if (!used_math())
 		return 0;
 
-	if (user_has_fpu()) {
-		if (use_xsave())
-			err = xsave_user(buf);
-		else
-			err = fxsave_user(buf);
+	ia32 = is_ia32_task();
+	if (ia32)
+		size = sig_xstate_ia32_size;
 
-		if (err)
-			return err;
-		user_fpu_end();
-	} else {
-		sanitize_i387_state(tsk);
-		if (__copy_to_user(buf, &tsk->thread.fpu.state->fxsave,
-				   xstate_size))
-			return -1;
-	}
+	if (!access_ok(VERIFY_WRITE, buf, size))
+		return -EACCES;
 
 	clear_used_math(); /* trigger finit */
 
-	if (use_xsave()) {
-		struct _fpstate __user *fx = buf;
-		struct _xstate __user *x = buf;
-		u64 xstate_bv;
+	if (!HAVE_HWFP)
+		return fpregs_soft_get(current, NULL, 0,
+			sizeof(struct user_i387_ia32_struct), NULL,
+			(struct _fpstate_ia32 __user *) buf) ? -1 : 1;
 
-		err = __copy_to_user(&fx->sw_reserved, &fx_sw_reserved,
-				     sizeof(struct _fpx_sw_bytes));
+	unlazy_fpu(tsk);
+	sanitize_i387_state(tsk);
 
-		err |= __put_user(FP_XSTATE_MAGIC2,
-				  (__u32 __user *) (buf + sig_xstate_size
-						    - FP_XSTATE_MAGIC2_SIZE));
+	if (ia32 && save_fsave_prolog(tsk, buf, &buf_fxsave))
+		return -1;
 
-		/*
-		 * Read the xstate_bv which we copied (directly from the cpu or
-		 * from the state in task struct) to the user buffers and
-		 * set the FP/SSE bits.
-		 */
-		err |= __get_user(xstate_bv, &x->xstate_hdr.xstate_bv);
+	if (__copy_to_user(buf_fxsave, xsave, xstate_size))
+		return -1;
 
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
+	if (use_xsave() && save_xsave_epilog(buf, size))
+		return -1;
+
+	return 0;
+}
 
-		err |= __put_user(xstate_bv, &x->xstate_hdr.xstate_bv);
+static inline int
+restore_state_prolog(void __user *buf, struct user_i387_ia32_struct *env,
+		     void **buf_fxsave)
+{
+	if (use_fxsr()) {
+		struct _fpstate_ia32 __user *fp = buf;
 
-		if (err)
-			return err;
+		if (__copy_from_user(env, buf, sizeof(*env)))
+			return -1;
+
+		*buf_fxsave = &fp->_fxsr_env;
 	}
+	return 0;
+}
+
+static inline void
+restore_state_epilog(struct task_struct *tsk,
+		     struct user_i387_ia32_struct *ia32_env)
+{
+	struct xsave_struct *xsave = &tsk->thread.fpu.state->xsave;
+	struct xsave_hdr_struct *xsave_hdr = &xsave->xsave_hdr;
 
-	return 1;
+	/*
+	 *  These bits must be zero
+	 */
+	if (use_xsave())
+		xsave_hdr->reserved1[0] = xsave_hdr->reserved1[1] = 0;
+
+	if (use_fxsr()) {
+		/*
+		 * mxcsr reserved bits must be masked to zero for security
+		 * reasons
+		 */
+		xsave->i387.mxcsr &= mxcsr_feature_mask;
+
+		if (ia32_env)
+			convert_to_fxsr(tsk, ia32_env);
+	}
 }
 
 /*
- * Restore the extended state if present. Otherwise, restore the FP/SSE
- * state.
+ * User passed memory layout is smaller than the kernel expected size.
+ * Copy the memory layout in multiple steps. Copy the legacy fxsave
+ * state first. Analyze the software reserved bits to get the rest
+ * of the memory layout size and copy the rest.
  */
-static int restore_user_xstate(void __user *buf)
+static inline int
+restore_xstate_slow(struct xsave_struct *xsave, void __user *buf_fx,
+		    void __user *buf)
 {
-	struct _fpx_sw_bytes fx_sw_user;
-	u64 mask;
-	int err;
-
-	if (((unsigned long)buf % 64) ||
-	     check_for_xstate(buf, buf, &fx_sw_user))
-		goto fx_only;
-
-	mask = fx_sw_user.xstate_bv;
+	unsigned int size = 0;
 
 	/*
-	 * restore the state passed by the user.
+	 * Restore legacy fx state.
 	 */
-	err = xrestore_user(buf, mask);
-	if (err)
-		return err;
+	if (__copy_from_user(xsave, buf_fx, sizeof(struct i387_fxsave_struct)))
+		return -1;
 
 	/*
-	 * init the state skipped by the user.
+	 * If this is not valid xstate, we are done.
 	 */
-	mask = pcntxt_mask & ~mask;
-	if (unlikely(mask))
-		xrstor_state(init_xstate_buf, mask);
+	if (check_update_xstatebv(xsave, buf, &size))
+		return 0;
 
-	return 0;
+	buf_fx += sizeof(struct i387_fxsave_struct);
+	size -= sizeof(struct i387_fxsave_struct);
 
-fx_only:
 	/*
-	 * couldn't find the extended state information in the
-	 * memory layout. Restore just the FP/SSE and init all
-	 * the other extended state.
-	 */
-	xrstor_state(init_xstate_buf, pcntxt_mask & ~XSTATE_FPSSE);
-	return fxrstor_checking((__force struct i387_fxsave_struct *)buf);
+ 	 * Copy the rest of the xstate passed by the user.
+ 	 */
+	if (__copy_from_user(&xsave->xsave_hdr, buf_fx, size))
+		return -1;
+
+	return 0;
 }
 
-/*
- * This restores directly out of user space. Exceptions are handled.
- */
-int restore_i387_xstate(void __user *buf)
+int restore_xstate_sigframe(void __user *buf)
 {
 	struct task_struct *tsk = current;
-	int err = 0;
+	struct user_i387_ia32_struct env;
+	void __user *buf_fxsave = buf;
+	struct xsave_struct *xsave;
+	int ia32 = is_ia32_task();
 
 	if (!buf) {
 		if (used_math())
-			goto clear;
+			drop_fpu(tsk);
 		return 0;
-	} else
-		if (!access_ok(VERIFY_READ, buf, sig_xstate_size))
-			return -EACCES;
+	}
+
+	if (!access_ok(VERIFY_READ, buf,
+		       ia32 ? sig_xstate_ia32_size : sig_xstate_size))
+		return -EACCES;
+
+	if (!used_math() && init_fpu(tsk))
+		return -1;
 
-	if (!used_math()) {
-		err = init_fpu(tsk);
-		if (err)
-			return err;
+	if (!HAVE_HWFP) {
+		return fpregs_soft_set(current, NULL,
+				       0, sizeof(struct user_i387_ia32_struct),
+				       NULL, buf) != 0;
 	}
 
-	user_fpu_begin();
-	if (use_xsave())
-		err = restore_user_xstate(buf);
-	else
-		err = fxrstor_checking((__force struct i387_fxsave_struct *)
-				       buf);
-	if (unlikely(err)) {
+	/*
+	 * Drop the current fpu state, we are about to restore new
+	 * state from the user sigframe.
+	 */
+	drop_fpu(tsk);
+
+	if (ia32 && restore_state_prolog(buf, &env, &buf_fxsave))
+		return -1;
+
+	xsave = &tsk->thread.fpu.state->xsave;
+
+	/*
+	 * Most likley sigreturn just passed us back the pointer that the
+	 * signal delivery path created. Maximum size of that memory
+	 * layout is 'xstate_size'. Try to copy that much.
+	 */
+	if (__copy_from_user(xsave, buf_fxsave, xstate_size)) {
 		/*
-		 * Encountered an error while doing the restore from the
-		 * user buffer, clear the fpu state.
+		 * We had problems guessing the user passed memory
+		 * layout size, go through the slow process to get it
+		 * right.
 		 */
-clear:
-		clear_fpu(tsk);
-		clear_used_math();
-	}
-	return err;
+		if (use_xsave()) {
+			if (restore_xstate_slow(xsave, buf_fxsave, buf))
+				return -1;
+		} else
+			return -1;
+	} else if (use_xsave())
+		/*
+ 		 * User passed memory layout might be smaller than what
+ 		 * we copied above. Check the software reserved bits
+ 		 * and update the xstate_bv accordingly.
+ 		 */
+		check_update_xstatebv(xsave, buf, NULL);
+
+	restore_state_epilog(tsk, ia32 ? &env : NULL);
+
+	set_used_math();
+	return 0;
 }
-#endif
 
 /*
  * Prepare the SW reserved portion of the fxsave memory layout, indicating


