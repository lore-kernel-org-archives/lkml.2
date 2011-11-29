Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1K2MnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:43:01 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:55896
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755193Ab1K2Mmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:42:53 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVF9ZA-01-CSI-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, <suresh.b.siddha@intel.com>,
        <eranian@google.com>, <brgerst@gmail.com>, <robert.richter@amd.com>,
        <Andreas.Herrmann3@amd.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 3/9] x86, xsave: cleanup fpu/xsave signal frame setup
Date: Tue, 29 Nov 2011 13:41:22 +0100
Message-ID: <1322570488-21798-4-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322570488-21798-1-git-send-email-hans.rosenfeld@amd.com>
References: <1322570488-21798-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are currently two code paths that handle the fpu/xsave context in
a signal frame for 32bit and 64bit tasks. These two code paths differ
only in that they have or lack certain micro-optimizations or do some
additional work (fsave compatibility for 32bit). The code is complex,
mostly duplicate and hard to understand and maintain.

This patch creates a set of two new, unified and cleaned up functions to
replace them. Besides avoiding the duplicate code, it is now obvious
what is done in which situations. The micro-optimization w.r.t xsave
(saving and restoring directly from the user buffer) is gone, and with
it the headaches it caused about validating the buffer alignment and
contents and catching possible xsave/xrstor faults.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/ia32/ia32_signal.c  |    4 +-
 arch/x86/include/asm/i387.h  |   20 ++++
 arch/x86/include/asm/xsave.h |    5 +-
 arch/x86/kernel/i387.c       |   32 ++-----
 arch/x86/kernel/signal.c     |    4 +-
 arch/x86/kernel/xsave.c      |  198 ++++++++++++++++++++++++++++++++++++++++--
 6 files changed, 227 insertions(+), 36 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 6557769..e641379 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -257,7 +257,7 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 
 		get_user_ex(tmp, &sc->fpstate);
 		buf = compat_ptr(tmp);
-		err |= restore_i387_xstate_ia32(buf);
+		err |= restore_xstates_sigframe(buf, sig_xstate_ia32_size);
 
 		get_user_ex(*pax, &sc->ax);
 	} get_user_catch(err);
@@ -392,7 +392,7 @@ static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 	if (used_math()) {
 		sp = sp - sig_xstate_ia32_size;
 		*fpstate = (struct _fpstate_ia32 *) sp;
-		if (save_i387_xstate_ia32(*fpstate) < 0)
+		if (save_xstates_sigframe(*fpstate, sig_xstate_ia32_size) < 0)
 			return (void __user *) -1L;
 	}
 
diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index a1c0d38..f0c605d 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -25,6 +25,20 @@
 #include <asm/uaccess.h>
 #include <asm/xsave.h>
 
+#ifdef CONFIG_X86_64
+# include <asm/sigcontext32.h>
+# include <asm/user32.h>
+#else
+# define save_i387_xstate_ia32		save_i387_xstate
+# define restore_i387_xstate_ia32	restore_i387_xstate
+# define _fpstate_ia32		_fpstate
+# define _xstate_ia32		_xstate
+# define sig_xstate_ia32_size   sig_xstate_size
+# define fx_sw_reserved_ia32	fx_sw_reserved
+# define user_i387_ia32_struct	user_i387_struct
+# define user32_fxsr_struct	user_fxsr_struct
+#endif
+
 extern unsigned int sig_xstate_size;
 extern void fpu_init(void);
 extern void mxcsr_feature_mask_init(void);
@@ -33,6 +47,9 @@ extern asmlinkage void math_state_restore(void);
 extern void __math_state_restore(void);
 extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 
+extern void convert_from_fxsr(struct user_i387_ia32_struct *, struct task_struct *);
+extern void convert_to_fxsr(struct task_struct *, const struct user_i387_ia32_struct *);
+
 extern user_regset_active_fn fpregs_active, xfpregs_active;
 extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get,
 				xstateregs_get;
@@ -46,6 +63,7 @@ extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set,
 #define xstateregs_active	fpregs_active
 
 extern struct _fpx_sw_bytes fx_sw_reserved;
+extern unsigned int mxcsr_feature_mask;
 #ifdef CONFIG_IA32_EMULATION
 extern unsigned int sig_xstate_ia32_size;
 extern struct _fpx_sw_bytes fx_sw_reserved_ia32;
@@ -56,8 +74,10 @@ extern int restore_i387_xstate_ia32(void __user *buf);
 #endif
 
 #ifdef CONFIG_MATH_EMULATION
+# define HAVE_HWFP		(boot_cpu_data.hard_math)
 extern void finit_soft_fpu(struct i387_soft_struct *soft);
 #else
+# define HAVE_HWFP		1
 static inline void finit_soft_fpu(struct i387_soft_struct *soft) {}
 #endif
 
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 8bcbbce..8632ddb 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -35,11 +35,14 @@ extern unsigned int xstate_size;
 extern u64 pcntxt_mask;
 extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
 
+extern int save_xstates_sigframe(void __user *, unsigned int);
+extern int restore_xstates_sigframe(void __user *, unsigned int);
+
 extern void xsave_init(void);
 extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
 extern int init_fpu(struct task_struct *child);
 extern int check_for_xstate(struct i387_fxsave_struct __user *buf,
-			    void __user *fpstate,
+			    unsigned int size,
 			    struct _fpx_sw_bytes *sw);
 
 static inline int xrstor_checking(struct xsave_struct *fx, u64 mask)
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 739d859..ae799e2 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -18,27 +18,7 @@
 #include <asm/i387.h>
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
@@ -372,7 +352,7 @@ static inline u32 twd_fxsr_to_i387(struct i387_fxsave_struct *fxsave)
  * FXSR floating point environment conversions.
  */
 
-static void
+void
 convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 {
 	struct i387_fxsave_struct *fxsave = &tsk->thread.fpu.state->fxsave;
@@ -409,8 +389,8 @@ convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 		memcpy(&to[i], &from[i], sizeof(to[0]));
 }
 
-static void convert_to_fxsr(struct task_struct *tsk,
-			    const struct user_i387_ia32_struct *env)
+void convert_to_fxsr(struct task_struct *tsk,
+		     const struct user_i387_ia32_struct *env)
 
 {
 	struct i387_fxsave_struct *fxsave = &tsk->thread.fpu.state->fxsave;
@@ -648,7 +628,9 @@ static int restore_i387_xsave(void __user *buf)
 	u64 mask;
 	int err;
 
-	if (check_for_xstate(fx, buf, &fx_sw_user))
+	if (check_for_xstate(fx, sig_xstate_ia32_size -
+			     offsetof(struct _fpstate_ia32, _fxsr_env),
+			     &fx_sw_user))
 		goto fx_only;
 
 	mask = fx_sw_user.xstate_bv;
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 54ddaeb2..3798fbb 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -117,7 +117,7 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 		regs->orig_ax = -1;		/* disable syscall checks */
 
 		get_user_ex(buf, &sc->fpstate);
-		err |= restore_i387_xstate(buf);
+		err |= restore_xstates_sigframe(buf, sig_xstate_size);
 
 		get_user_ex(*pax, &sc->ax);
 	} get_user_catch(err);
@@ -252,7 +252,7 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 		return (void __user *)-1L;
 
 	/* save i387 state */
-	if (used_math() && save_i387_xstate(*fpstate) < 0)
+	if (used_math() && save_xstates_sigframe(*fpstate, sig_xstate_size) < 0)
 		return (void __user *)-1L;
 
 	return (void __user *)sp;
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 6b063d7..349e835 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -102,8 +102,7 @@ void __sanitize_i387_state(struct task_struct *tsk)
  * Check for the presence of extended state information in the
  * user fpstate pointer in the sigcontext.
  */
-int check_for_xstate(struct i387_fxsave_struct __user *buf,
-		     void __user *fpstate,
+int check_for_xstate(struct i387_fxsave_struct __user *buf, unsigned int size,
 		     struct _fpx_sw_bytes *fx_sw_user)
 {
 	int min_xstate_size = sizeof(struct i387_fxsave_struct) +
@@ -130,11 +129,11 @@ int check_for_xstate(struct i387_fxsave_struct __user *buf,
 	    fx_sw_user->xstate_size > fx_sw_user->extended_size)
 		return -EINVAL;
 
-	err = __get_user(magic2, (__u32 *) (((void *)fpstate) +
-					    fx_sw_user->extended_size -
+	err = __get_user(magic2, (__u32 *) (((void *)buf) + size -
 					    FP_XSTATE_MAGIC2_SIZE));
 	if (err)
 		return err;
+
 	/*
 	 * Check for the presence of second magic word at the end of memory
 	 * layout. This detects the case where the user just copied the legacy
@@ -147,11 +146,109 @@ int check_for_xstate(struct i387_fxsave_struct __user *buf,
 	return 0;
 }
 
-#ifdef CONFIG_X86_64
 /*
  * Signal frame handlers.
  */
+int save_xstates_sigframe(void __user *buf, unsigned int size)
+{
+	void __user *buf_fxsave = buf;
+	struct task_struct *tsk = current;
+	struct xsave_struct *xsave = &tsk->thread.fpu.state->xsave;
+#if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
+	int ia32 = size == sig_xstate_ia32_size;
+#endif
+	int err;
+
+	if (!access_ok(VERIFY_WRITE, buf, size))
+		return -EACCES;
+
+	BUG_ON(size < xstate_size);
+
+	if (!used_math())
+		return 0;
+
+	clear_used_math(); /* trigger finit */
+
+	if (!HAVE_HWFP)
+		return fpregs_soft_get(current, NULL, 0,
+			sizeof(struct user_i387_ia32_struct), NULL,
+			(struct _fpstate_ia32 __user *) buf) ? -1 : 1;
+
+	unlazy_fpu(tsk);
+	sanitize_i387_state(tsk);
+
+#if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
+	if (ia32) {
+		if (use_xsave() || use_fxsr()) {
+			struct user_i387_ia32_struct env;
+			struct _fpstate_ia32 __user *fp = buf;
+
+			convert_from_fxsr(&env, tsk);
+			if (__copy_to_user(buf, &env, sizeof(env)))
+				return -1;
+
+			err  = __put_user(xsave->i387.swd, &fp->status);
+			err |= __put_user(X86_FXSR_MAGIC, &fp->magic);
+
+			if (err)
+				return -1;
+
+			buf_fxsave = fp->_fxsr_env;
+			size -= offsetof(struct _fpstate_ia32, _fxsr_env);
+#if defined(CONFIG_X86_64)
+			buf = buf_fxsave;
+#endif
+		} else {
+			struct i387_fsave_struct *fsave =
+				&tsk->thread.fpu.state->fsave;
+
+			fsave->status = fsave->swd;
+		}
+	}
+#endif
 
+	if (__copy_to_user(buf_fxsave, xsave, size))
+		return -1;
+
+	if (use_xsave()) {
+		struct _fpstate __user *fp = buf;
+		struct _xstate __user *x = buf;
+		u64 xstate_bv = xsave->xsave_hdr.xstate_bv;
+
+		err = __copy_to_user(&fp->sw_reserved,
+#if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
+				     ia32 ? &fx_sw_reserved_ia32 :
+#endif
+				     &fx_sw_reserved,
+				     sizeof (struct _fpx_sw_bytes));
+
+		err |= __put_user(FP_XSTATE_MAGIC2,
+				  (__u32 __user *) (buf_fxsave + size
+						    - FP_XSTATE_MAGIC2_SIZE));
+
+		/*
+		 * For legacy compatible, we always set FP/SSE bits in the bit
+		 * vector while saving the state to the user context. This will
+		 * enable us capturing any changes(during sigreturn) to
+		 * the FP/SSE bits by the legacy applications which don't touch
+		 * xstate_bv in the xsave header.
+		 *
+		 * xsave aware apps can change the xstate_bv in the xsave
+		 * header as well as change any contents in the memory layout.
+		 * xrestore as part of sigreturn will capture all the changes.
+		 */
+		xstate_bv |= XSTATE_FPSSE;
+
+		err |= __put_user(xstate_bv, &x->xstate_hdr.xstate_bv);
+
+		if (err)
+			return err;
+	}
+
+	return 1;
+}
+
+#ifdef CONFIG_X86_64
 int save_i387_xstate(void __user *buf)
 {
 	struct task_struct *tsk = current;
@@ -239,7 +336,7 @@ static int restore_user_xstate(void __user *buf)
 	int err;
 
 	if (((unsigned long)buf % 64) ||
-	     check_for_xstate(buf, buf, &fx_sw_user))
+	     check_for_xstate(buf, sig_xstate_size, &fx_sw_user))
 		goto fx_only;
 
 	mask = fx_sw_user.xstate_bv;
@@ -314,6 +411,95 @@ clear:
 }
 #endif
 
+int restore_xstates_sigframe(void __user *buf, unsigned int size)
+{
+#if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
+	struct user_i387_ia32_struct env;
+	int ia32 = size == sig_xstate_ia32_size;
+#endif
+	struct _fpx_sw_bytes fx_sw_user;
+	struct task_struct *tsk = current;
+	struct _fpstate_ia32 __user *fp = buf;
+	struct xsave_struct *xsave;
+	int err;
+
+	if (!buf) {
+		if (used_math()) {
+			clear_fpu(tsk);
+			clear_used_math();
+		}
+		return 0;
+	}
+
+	if (!access_ok(VERIFY_READ, buf, size))
+		return -EACCES;
+
+	if (!used_math()) {
+		err = init_fpu(tsk);
+		if (err)
+			return err;
+	}
+
+	if (!HAVE_HWFP) {
+		set_used_math();
+		return fpregs_soft_set(current, NULL,
+				       0, sizeof(struct user_i387_ia32_struct),
+				       NULL, fp) != 0;
+	}
+
+#if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
+	if (ia32 && (use_xsave() || use_fxsr())) {
+		if (__copy_from_user(&env, buf, sizeof(env)))
+			return -1;
+		buf = fp->_fxsr_env;
+		size -= offsetof(struct _fpstate_ia32, _fxsr_env);
+	}
+#endif
+
+	preempt_disable();
+	stts();
+	task_thread_info(tsk)->status &= ~TS_USEDFPU;
+	preempt_enable();
+
+	xsave = &tsk->thread.fpu.state->xsave;
+	if (__copy_from_user(xsave, buf, xstate_size))
+		return -1;
+
+	if (use_xsave()) {
+		u64 *xstate_bv = &xsave->xsave_hdr.xstate_bv;
+
+		/*
+		 * If this is no valid xstate, disable all extended states.
+		 *
+		 * For valid xstates, clear any illegal bits and any bits
+		 * that have been cleared in fx_sw_user.xstate_bv.
+		 */
+		if (check_for_xstate(buf, size, &fx_sw_user))
+			*xstate_bv = XSTATE_FPSSE;
+		else
+			*xstate_bv &= pcntxt_mask & fx_sw_user.xstate_bv;
+
+		xsave->xsave_hdr.reserved1[0] =
+			xsave->xsave_hdr.reserved1[1] = 0;
+	}
+
+	if (use_xsave() || use_fxsr()) {
+		xsave->i387.mxcsr &= mxcsr_feature_mask;
+
+#if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
+		if (ia32)
+			convert_to_fxsr(tsk, &env);
+#endif
+	}
+
+	preempt_disable();
+	set_used_math();
+	math_state_restore();
+	preempt_enable();
+
+	return 0;
+}
+
 /*
  * Prepare the SW reserved portion of the fxsave memory layout, indicating
  * the presence of the extended state information in the memory layout
-- 
1.7.5.4


