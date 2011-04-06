Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab1DFWFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:05:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:50680 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082Ab1DFWFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:05:01 -0400
Date: Wed, 6 Apr 2011 22:04:45 GMT
From: tip-bot for Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel@vger.kernel.org, hans.rosenfeld@amd.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, hans.rosenfeld@amd.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: 1302018656-586370-4-git-send-email-hans.rosenfeld@amd.com
References: 1302018656-586370-4-git-send-email-hans.rosenfeld@amd.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86, xsave: cleanup fpu/xsave signal frame setup
Message-ID: <tip-0c11e6f1aed142f9c08782ad08cd920541afd4d2@git.kernel.org>
Git-Commit-ID: 0c11e6f1aed142f9c08782ad08cd920541afd4d2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 06 Apr 2011 22:04:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c11e6f1aed142f9c08782ad08cd920541afd4d2
Gitweb:     http://git.kernel.org/tip/0c11e6f1aed142f9c08782ad08cd920541afd4d2
Author:     Hans Rosenfeld <hans.rosenfeld@amd.com>
AuthorDate: Tue, 5 Apr 2011 17:50:51 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 6 Apr 2011 14:15:18 -0700

x86, xsave: cleanup fpu/xsave signal frame setup

There are currently two code paths that handle the fpu/xsave context in
a signal frame for 32bit and 64bit tasks. These two code paths differ
only in that they have or lack certain micro-optimizations or do some
additional work (fsave compatibility for 32bit). The code is complex,
mostly duplicate and hard to understand and maintain.

This patch creates a set of two new, unified and cleaned up functions to
replace them. Besides avoiding the duplicate code, it is now obvious
what is done in which situations. The micro-optimization w.r.t xsave
(saving and restoring directly from the user buffer) is gone, and with
it the headaches caused by it about validating the buffer alignment and
contents and catching possible xsave/xrstor faults.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
Link: http://lkml.kernel.org/r/1302018656-586370-4-git-send-email-hans.rosenfeld@amd.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/ia32/ia32_signal.c  |    4 +-
 arch/x86/include/asm/i387.h  |   20 ++++
 arch/x86/include/asm/xsave.h |    4 +-
 arch/x86/kernel/i387.c       |   32 ++------
 arch/x86/kernel/signal.c     |    4 +-
 arch/x86/kernel/xsave.c      |  197 ++++++++++++++++++++++++++++++++++++++++--
 6 files changed, 225 insertions(+), 36 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 588a7aa..2605fae 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -255,7 +255,7 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 
 		get_user_ex(tmp, &sc->fpstate);
 		buf = compat_ptr(tmp);
-		err |= restore_i387_xstate_ia32(buf);
+		err |= restore_xstates_sigframe(buf, sig_xstate_ia32_size);
 
 		get_user_ex(*pax, &sc->ax);
 	} get_user_catch(err);
@@ -396,7 +396,7 @@ static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 	if (used_math()) {
 		sp = sp - sig_xstate_ia32_size;
 		*fpstate = (struct _fpstate_ia32 *) sp;
-		if (save_i387_xstate_ia32(*fpstate) < 0)
+		if (save_xstates_sigframe(*fpstate, sig_xstate_ia32_size) < 0)
 			return (void __user *) -1L;
 	}
 
diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 6622ed2..fc716bc 100644
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
index 6052a84..200c56d 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -41,12 +41,14 @@ extern void xsave(struct fpu *, u64);
 extern void xrstor(struct fpu *, u64);
 extern void save_xstates(struct task_struct *);
 extern void restore_xstates(struct task_struct *, u64);
+extern int save_xstates_sigframe(void __user *, unsigned int);
+extern int restore_xstates_sigframe(void __user *, unsigned int);
 
 extern void xsave_init(void);
 extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
 extern int init_fpu(struct task_struct *child);
 extern int check_for_xstate(struct i387_fxsave_struct __user *buf,
-			    void __user *fpstate,
+			    unsigned int size,
 			    struct _fpx_sw_bytes *sw);
 
 static inline int xrstor_checking(struct xsave_struct *fx, u64 mask)
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 1088ac5..69625a8 100644
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
@@ -375,7 +355,7 @@ static inline u32 twd_fxsr_to_i387(struct i387_fxsave_struct *fxsave)
  * FXSR floating point environment conversions.
  */
 
-static void
+void
 convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 {
 	struct i387_fxsave_struct *fxsave = &tsk->thread.fpu.state->fxsave;
@@ -412,8 +392,8 @@ convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 		memcpy(&to[i], &from[i], sizeof(to[0]));
 }
 
-static void convert_to_fxsr(struct task_struct *tsk,
-			    const struct user_i387_ia32_struct *env)
+void convert_to_fxsr(struct task_struct *tsk,
+		     const struct user_i387_ia32_struct *env)
 
 {
 	struct i387_fxsave_struct *fxsave = &tsk->thread.fpu.state->fxsave;
@@ -653,7 +633,9 @@ static int restore_i387_xsave(void __user *buf)
 	u64 mask;
 	int err;
 
-	if (check_for_xstate(fx, buf, &fx_sw_user))
+	if (check_for_xstate(fx, sig_xstate_ia32_size -
+			     offsetof(struct _fpstate_ia32, _fxsr_env),
+			     &fx_sw_user))
 		goto fx_only;
 
 	mask = fx_sw_user.xstate_bv;
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 4fd173c..f6705ff 100644
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
index d9fa41f..08b2fe8 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -103,8 +103,7 @@ void __sanitize_i387_state(struct task_struct *tsk)
  * Check for the presence of extended state information in the
  * user fpstate pointer in the sigcontext.
  */
-int check_for_xstate(struct i387_fxsave_struct __user *buf,
-		     void __user *fpstate,
+int check_for_xstate(struct i387_fxsave_struct __user *buf, unsigned int size,
 		     struct _fpx_sw_bytes *fx_sw_user)
 {
 	int min_xstate_size = sizeof(struct i387_fxsave_struct) +
@@ -131,11 +130,11 @@ int check_for_xstate(struct i387_fxsave_struct __user *buf,
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
@@ -148,11 +147,109 @@ int check_for_xstate(struct i387_fxsave_struct __user *buf,
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
+	save_xstates(tsk);
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
@@ -240,7 +337,7 @@ static int restore_user_xstate(void __user *buf)
 	int err;
 
 	if (((unsigned long)buf % 64) ||
-	     check_for_xstate(buf, buf, &fx_sw_user))
+	     check_for_xstate(buf, sig_xstate_size, &fx_sw_user))
 		goto fx_only;
 
 	mask = fx_sw_user.xstate_bv;
@@ -315,6 +412,94 @@ clear:
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
+	u64 xstate_mask = 0;
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
+	xsave = &tsk->thread.fpu.state->xsave;
+	task_thread_info(tsk)->xstate_mask = 0;
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
+		xstate_mask |= *xstate_bv;
+
+		xsave->xsave_hdr.reserved1[0] =
+			xsave->xsave_hdr.reserved1[1] = 0;
+	} else {
+		xstate_mask |= XCNTXT_LAZY;
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
+	set_used_math();
+	restore_xstates(tsk, xstate_mask);
+
+	return 0;
+}
+
 /*
  * Prepare the SW reserved portion of the fxsave memory layout, indicating
  * the presence of the extended state information in the memory layout
