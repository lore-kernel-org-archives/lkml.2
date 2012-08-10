Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab2HJD43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 23:56:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45928 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab2HJD41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 23:56:27 -0400
Date: Thu, 9 Aug 2012 20:56:14 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-b2104ba4a037e296901e73a0d396826c13625bb0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1344544736.8326.17.camel@sbsiddha-desk.sc.intel.com>
References: <1344544736.8326.17.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu:
  fix build issues with CONFIG_IA32_EMULATION, CONFIG_X86_X32_ABI
Git-Commit-ID: b2104ba4a037e296901e73a0d396826c13625bb0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 09 Aug 2012 20:56:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2104ba4a037e296901e73a0d396826c13625bb0
Gitweb:     http://git.kernel.org/tip/b2104ba4a037e296901e73a0d396826c13625bb0
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 9 Aug 2012 13:38:56 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 9 Aug 2012 17:13:57 -0700

x86, fpu: fix build issues with CONFIG_IA32_EMULATION, CONFIG_X86_X32_ABI

Fengguang's automated build reported some compilation failures:
> arch/x86/kernel/signal.c: In function 'setup_rt_frame':
> arch/x86/kernel/signal.c:626:4: error: implicit declaration of function '__setup_frame'
> ...

Code saving fsave prefix is applicable only for CONFIG_X86_32 or
CONFIG_IA32_EMULATION. Use config_enabled() checks to remove the unnecessary
code compile-time for x86_64 kernels build without CONFIG_IA32_EMULATION.

Peter reported some build failures with CONFIG_X86_X32_ABI:
> arch/x86/kernel/signal.c:792:12: error:
> static declaration of ‘x32_setup_rt_frame’ follows non-static declaration
> ...

Fix it by moving the x32_setup_rt_frame() code around and removing the
non-static declaration.

Also while we are at this, fix a spurious warning:
> arch/x86/kernel/xsave.c:209:15: warning: ignoring return value
> of ‘__clear_user’, declared with attribute warn_unused_result

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1344544736.8326.17.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/fpu-internal.h |    7 +--
 arch/x86/kernel/signal.c            |  134 ++++++++++++++++++-----------------
 arch/x86/kernel/xsave.c             |   10 ++-
 3 files changed, 77 insertions(+), 74 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 35ad161..ba83a08 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -22,7 +22,7 @@
 #include <asm/uaccess.h>
 #include <asm/xsave.h>
 
-#ifdef CONFIG_IA32_EMULATION
+#ifdef CONFIG_X86_64
 # include <asm/sigcontext32.h>
 # include <asm/user32.h>
 int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
@@ -52,17 +52,12 @@ extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get,
 extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set,
 				 xstateregs_set;
 
-
 /*
  * xstateregs_active == fpregs_active. Please refer to the comment
  * at the definition of fpregs_active.
  */
 #define xstateregs_active	fpregs_active
 
-int x32_setup_rt_frame(int sig, struct k_sigaction *ka,
-		       siginfo_t *info, compat_sigset_t *set,
-		       struct pt_regs *regs);
-
 #ifdef CONFIG_MATH_EMULATION
 # define HAVE_HWFP             (boot_cpu_data.hard_math)
 extern void finit_soft_fpu(struct i387_soft_struct *soft);
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 356e442..e10f96a 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -472,6 +472,74 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
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
@@ -789,72 +857,6 @@ void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
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
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 2917e34..a23d100 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -205,8 +205,8 @@ static inline int save_user_xstate(struct xsave_struct __user *buf)
 	else
 		err = fsave_user((struct i387_fsave_struct __user *) buf);
 
-	if (unlikely(err))
-		__clear_user(buf, xstate_size);
+	if (unlikely(err) && __clear_user(buf, xstate_size))
+		err = -EFAULT;
 	return err;
 }
 
@@ -236,6 +236,9 @@ int save_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 	struct task_struct *tsk = current;
 	int ia32_fxstate = (buf != buf_fx);
 
+	ia32_fxstate &= (config_enabled(CONFIG_X86_32) ||
+			 config_enabled(CONFIG_IA32_EMULATION));
+
 	if (!access_ok(VERIFY_WRITE, buf, size))
 		return -EACCES;
 
@@ -333,6 +336,9 @@ int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 	u64 xstate_bv = 0;
 	int fx_only = 0;
 
+	ia32_fxstate &= (config_enabled(CONFIG_X86_32) ||
+			 config_enabled(CONFIG_IA32_EMULATION));
+
 	if (!buf) {
 		drop_fpu(tsk);
 		return 0;
