Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2IRX7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 19:59:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44629 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab2IRX72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 19:59:28 -0400
Date: Tue, 18 Sep 2012 16:59:12 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-050902c011712ad4703038fa4489ec4edd87d396@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1344544736.8326.17.camel@sbsiddha-desk.sc.intel.com>
References: <1343171129-2747-2-git-send-email-suresh.b.siddha@intel.com>
	<1344544736.8326.17.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, signal: Cleanup ifdefs and is_ia32, is_x32
Git-Commit-ID: 050902c011712ad4703038fa4489ec4edd87d396
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 18 Sep 2012 16:59:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  050902c011712ad4703038fa4489ec4edd87d396
Gitweb:     http://git.kernel.org/tip/050902c011712ad4703038fa4489ec4edd87d396
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 24 Jul 2012 16:05:27 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 18 Sep 2012 15:51:26 -0700

x86, signal: Cleanup ifdefs and is_ia32, is_x32

Use config_enabled() to cleanup the definitions of is_ia32/is_x32. Move
the function prototypes to the header file to cleanup ifdefs,
and move the x32_setup_rt_frame() code around.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1343171129-2747-2-git-send-email-suresh.b.siddha@intel.com
Merged in compilation fix from,
Link: http://lkml.kernel.org/r/1344544736.8326.17.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/fpu-internal.h |   26 +++++-
 arch/x86/include/asm/signal.h       |    4 +
 arch/x86/kernel/signal.c            |  196 ++++++++++++++--------------------
 3 files changed, 110 insertions(+), 116 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 75f4c6d..6f59543 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -12,6 +12,7 @@
 
 #include <linux/kernel_stat.h>
 #include <linux/regset.h>
+#include <linux/compat.h>
 #include <linux/slab.h>
 #include <asm/asm.h>
 #include <asm/cpufeature.h>
@@ -32,7 +33,6 @@ extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get,
 extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set,
 				 xstateregs_set;
 
-
 /*
  * xstateregs_active == fpregs_active. Please refer to the comment
  * at the definition of fpregs_active.
@@ -55,6 +55,22 @@ extern void finit_soft_fpu(struct i387_soft_struct *soft);
 static inline void finit_soft_fpu(struct i387_soft_struct *soft) {}
 #endif
 
+static inline int is_ia32_compat_frame(void)
+{
+	return config_enabled(CONFIG_IA32_EMULATION) &&
+	       test_thread_flag(TIF_IA32);
+}
+
+static inline int is_ia32_frame(void)
+{
+	return config_enabled(CONFIG_X86_32) || is_ia32_compat_frame();
+}
+
+static inline int is_x32_frame(void)
+{
+	return config_enabled(CONFIG_X86_X32_ABI) && test_thread_flag(TIF_X32);
+}
+
 #define X87_FSW_ES (1 << 7)	/* Exception Summary */
 
 static __always_inline __pure bool use_xsaveopt(void)
@@ -180,6 +196,11 @@ static inline void fpu_fxsave(struct fpu *fpu)
 #endif
 }
 
+int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+			compat_sigset_t *set, struct pt_regs *regs);
+int ia32_setup_frame(int sig, struct k_sigaction *ka,
+		     compat_sigset_t *set, struct pt_regs *regs);
+
 #else  /* CONFIG_X86_32 */
 
 /* perform fxrstor iff the processor has extended states, otherwise frstor */
@@ -204,6 +225,9 @@ static inline void fpu_fxsave(struct fpu *fpu)
 		     : [fx] "=m" (fpu->state->fxsave));
 }
 
+#define ia32_setup_frame	__setup_frame
+#define ia32_setup_rt_frame	__setup_rt_frame
+
 #endif	/* CONFIG_X86_64 */
 
 /*
diff --git a/arch/x86/include/asm/signal.h b/arch/x86/include/asm/signal.h
index 598457c..323973f 100644
--- a/arch/x86/include/asm/signal.h
+++ b/arch/x86/include/asm/signal.h
@@ -31,6 +31,10 @@ typedef struct {
 	unsigned long sig[_NSIG_WORDS];
 } sigset_t;
 
+#ifndef CONFIG_COMPAT
+typedef sigset_t compat_sigset_t;
+#endif
+
 #else
 /* Here we must cater to libcs that poke about in kernel headers.  */
 
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index b280908..bed431a 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -209,24 +209,21 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 	unsigned long sp = regs->sp;
 	int onsigstack = on_sig_stack(sp);
 
-#ifdef CONFIG_X86_64
 	/* redzone */
-	sp -= 128;
-#endif /* CONFIG_X86_64 */
+	if (config_enabled(CONFIG_X86_64))
+		sp -= 128;
 
 	if (!onsigstack) {
 		/* This is the X/Open sanctioned signal stack switching.  */
 		if (ka->sa.sa_flags & SA_ONSTACK) {
 			if (current->sas_ss_size)
 				sp = current->sas_ss_sp + current->sas_ss_size;
-		} else {
-#ifdef CONFIG_X86_32
-			/* This is the legacy signal stack switching. */
-			if ((regs->ss & 0xffff) != __USER_DS &&
-				!(ka->sa.sa_flags & SA_RESTORER) &&
-					ka->sa.sa_restorer)
+		} else if (config_enabled(CONFIG_X86_32) &&
+			   (regs->ss & 0xffff) != __USER_DS &&
+			   !(ka->sa.sa_flags & SA_RESTORER) &&
+			   ka->sa.sa_restorer) {
+				/* This is the legacy signal stack switching. */
 				sp = (unsigned long) ka->sa.sa_restorer;
-#endif /* CONFIG_X86_32 */
 		}
 	}
 
@@ -474,6 +471,74 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 }
 #endif /* CONFIG_X86_32 */
 
+static int x32_setup_rt_frame(int sig, struct k_sigaction *ka,
+			      siginfo_t *info, compat_sigset_t *set,
+			      struct pt_regs *regs)
+{
+#ifdef CONFIG_X86_X32_ABI
+	struct rt_sigframe_x32 __user *frame;
+	void __user *restorer;
+	int err = 0;
+	void __user *fpstate = NULL;
+
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
+
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+		return -EFAULT;
+
+	if (ka->sa.sa_flags & SA_SIGINFO) {
+		if (copy_siginfo_to_user32(&frame->info, info))
+			return -EFAULT;
+	}
+
+	put_user_try {
+		/* Create the ucontext.  */
+		if (cpu_has_xsave)
+			put_user_ex(UC_FP_XSTATE, &frame->uc.uc_flags);
+		else
+			put_user_ex(0, &frame->uc.uc_flags);
+		put_user_ex(0, &frame->uc.uc_link);
+		put_user_ex(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
+		put_user_ex(sas_ss_flags(regs->sp),
+			    &frame->uc.uc_stack.ss_flags);
+		put_user_ex(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
+		put_user_ex(0, &frame->uc.uc__pad0);
+		err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
+					regs, set->sig[0]);
+		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
+		if (ka->sa.sa_flags & SA_RESTORER) {
+			restorer = ka->sa.sa_restorer;
+		} else {
+			/* could use a vstub here */
+			restorer = NULL;
+			err |= -EFAULT;
+		}
+		put_user_ex(restorer, &frame->pretcode);
+	} put_user_catch(err);
+
+	if (err)
+		return -EFAULT;
+
+	/* Set up registers for signal handler */
+	regs->sp = (unsigned long) frame;
+	regs->ip = (unsigned long) ka->sa.sa_handler;
+
+	/* We use the x32 calling convention here... */
+	regs->di = sig;
+	regs->si = (unsigned long) &frame->info;
+	regs->dx = (unsigned long) &frame->uc;
+
+	loadsegment(ds, __USER_DS);
+	loadsegment(es, __USER_DS);
+
+	regs->cs = __USER_CS;
+	regs->ss = __USER_DS;
+#endif	/* CONFIG_X86_X32_ABI */
+
+	return 0;
+}
+
 #ifdef CONFIG_X86_32
 /*
  * Atomically swap in the new signal mask, and wait for a signal.
@@ -612,55 +677,22 @@ static int signr_convert(int sig)
 	return sig;
 }
 
-#ifdef CONFIG_X86_32
-
-#define is_ia32	1
-#define ia32_setup_frame	__setup_frame
-#define ia32_setup_rt_frame	__setup_rt_frame
-
-#else /* !CONFIG_X86_32 */
-
-#ifdef CONFIG_IA32_EMULATION
-#define is_ia32	test_thread_flag(TIF_IA32)
-#else /* !CONFIG_IA32_EMULATION */
-#define is_ia32	0
-#endif /* CONFIG_IA32_EMULATION */
-
-#ifdef CONFIG_X86_X32_ABI
-#define is_x32	test_thread_flag(TIF_X32)
-
-static int x32_setup_rt_frame(int sig, struct k_sigaction *ka,
-			      siginfo_t *info, compat_sigset_t *set,
-			      struct pt_regs *regs);
-#else /* !CONFIG_X86_X32_ABI */
-#define is_x32	0
-#endif /* CONFIG_X86_X32_ABI */
-
-int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-		sigset_t *set, struct pt_regs *regs);
-int ia32_setup_frame(int sig, struct k_sigaction *ka,
-		sigset_t *set, struct pt_regs *regs);
-
-#endif /* CONFIG_X86_32 */
-
 static int
 setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		struct pt_regs *regs)
 {
 	int usig = signr_convert(sig);
 	sigset_t *set = sigmask_to_save();
+	compat_sigset_t *cset = (compat_sigset_t *) set;
 
 	/* Set up the stack frame */
-	if (is_ia32) {
+	if (is_ia32_frame()) {
 		if (ka->sa.sa_flags & SA_SIGINFO)
-			return ia32_setup_rt_frame(usig, ka, info, set, regs);
+			return ia32_setup_rt_frame(usig, ka, info, cset, regs);
 		else
-			return ia32_setup_frame(usig, ka, set, regs);
-#ifdef CONFIG_X86_X32_ABI
-	} else if (is_x32) {
-		return x32_setup_rt_frame(usig, ka, info,
-					 (compat_sigset_t *)set, regs);
-#endif
+			return ia32_setup_frame(usig, ka, cset, regs);
+	} else if (is_x32_frame()) {
+		return x32_setup_rt_frame(usig, ka, info, cset, regs);
 	} else {
 		return __setup_rt_frame(sig, ka, info, set, regs);
 	}
@@ -824,72 +856,6 @@ void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
 }
 
 #ifdef CONFIG_X86_X32_ABI
-static int x32_setup_rt_frame(int sig, struct k_sigaction *ka,
-			      siginfo_t *info, compat_sigset_t *set,
-			      struct pt_regs *regs)
-{
-	struct rt_sigframe_x32 __user *frame;
-	void __user *restorer;
-	int err = 0;
-	void __user *fpstate = NULL;
-
-	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
-
-	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		return -EFAULT;
-
-	if (ka->sa.sa_flags & SA_SIGINFO) {
-		if (copy_siginfo_to_user32(&frame->info, info))
-			return -EFAULT;
-	}
-
-	put_user_try {
-		/* Create the ucontext.  */
-		if (cpu_has_xsave)
-			put_user_ex(UC_FP_XSTATE, &frame->uc.uc_flags);
-		else
-			put_user_ex(0, &frame->uc.uc_flags);
-		put_user_ex(0, &frame->uc.uc_link);
-		put_user_ex(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
-		put_user_ex(sas_ss_flags(regs->sp),
-			    &frame->uc.uc_stack.ss_flags);
-		put_user_ex(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
-		put_user_ex(0, &frame->uc.uc__pad0);
-		err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
-					regs, set->sig[0]);
-		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
-
-		if (ka->sa.sa_flags & SA_RESTORER) {
-			restorer = ka->sa.sa_restorer;
-		} else {
-			/* could use a vstub here */
-			restorer = NULL;
-			err |= -EFAULT;
-		}
-		put_user_ex(restorer, &frame->pretcode);
-	} put_user_catch(err);
-
-	if (err)
-		return -EFAULT;
-
-	/* Set up registers for signal handler */
-	regs->sp = (unsigned long) frame;
-	regs->ip = (unsigned long) ka->sa.sa_handler;
-
-	/* We use the x32 calling convention here... */
-	regs->di = sig;
-	regs->si = (unsigned long) &frame->info;
-	regs->dx = (unsigned long) &frame->uc;
-
-	loadsegment(ds, __USER_DS);
-	loadsegment(es, __USER_DS);
-
-	regs->cs = __USER_CS;
-	regs->ss = __USER_DS;
-
-	return 0;
-}
-
 asmlinkage long sys32_x32_rt_sigreturn(struct pt_regs *regs)
 {
 	struct rt_sigframe_x32 __user *frame;
