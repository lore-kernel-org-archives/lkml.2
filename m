Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab0HRFHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 01:07:23 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59451 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0HRFHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 01:07:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=A8exT49r2DP8x85nBgM2UFID3Eoxkqp3bBdm7hc/de+sJsApZ37O3gpbrMsBvM0Fvt
         Nyv50FFb4uiFZ3yfjdFizzglEJpT+Qbi0MnnqZTqWOqZkJOrSpObk0Eb4Z5ljaryvLXP
         4XGb6Q+0WaJUqWVllbbTzgGLydNG53jWlTtNA=
From: Namhyung Kim <namhyung@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/ia32: mark address space properly
Date: Wed, 18 Aug 2010 14:07:13 +0900
Message-Id: <1282108033-8278-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of address space conversion code lack proper __user/__force markups.
This results in a lot of annoying sparse warnings. Fix it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/x86/ia32/ia32_signal.c |   19 +++++++++++--------
 arch/x86/ia32/sys_ia32.c    |   12 ++++++------
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 588a7aa..348928a 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -167,7 +167,8 @@ asmlinkage long sys32_sigaltstack(const stack_ia32_t __user *uss_ptr,
 	}
 	seg = get_fs();
 	set_fs(KERNEL_DS);
-	ret = do_sigaltstack(uss_ptr ? &uss : NULL, &uoss, regs->sp);
+	ret = do_sigaltstack(uss_ptr ? (stack_t __user __force *)&uss : NULL,
+			     (stack_t __user __force *)&uoss, regs->sp);
 	set_fs(seg);
 	if (ret >= 0 && uoss_ptr)  {
 		if (!access_ok(VERIFY_WRITE, uoss_ptr, sizeof(stack_ia32_t)))
@@ -374,7 +375,7 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
  */
 static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 				 size_t frame_size,
-				 void **fpstate)
+				 void __user **fpstate)
 {
 	unsigned long sp;
 
@@ -395,9 +396,9 @@ static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 
 	if (used_math()) {
 		sp = sp - sig_xstate_ia32_size;
-		*fpstate = (struct _fpstate_ia32 *) sp;
+		*fpstate = (struct _fpstate_ia32 __user *) sp;
 		if (save_i387_xstate_ia32(*fpstate) < 0)
-			return (void __user *) -1L;
+			return (void __user __force *) -1L;
 	}
 
 	sp -= frame_size;
@@ -448,7 +449,8 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	} else {
 		/* Return stub is in 32bit vsyscall page */
 		if (current->mm->context.vdso)
-			restorer = VDSO32_SYMBOL(current->mm->context.vdso,
+			restorer = (void __user __force *)
+				   VDSO32_SYMBOL(current->mm->context.vdso,
 						 sigreturn);
 		else
 			restorer = &frame->retcode;
@@ -461,7 +463,7 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 		 * These are actually not used anymore, but left because some
 		 * gdb versions depend on them as a marker.
 		 */
-		put_user_ex(*((u64 *)&code), (u64 *)frame->retcode);
+		put_user_ex(*((u64 *)&code), (u64 __user *)frame->retcode);
 	} put_user_catch(err);
 
 	if (err)
@@ -534,7 +536,8 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		if (ka->sa.sa_flags & SA_RESTORER)
 			restorer = ka->sa.sa_restorer;
 		else
-			restorer = VDSO32_SYMBOL(current->mm->context.vdso,
+			restorer = (void __user __force *)
+				   VDSO32_SYMBOL(current->mm->context.vdso,
 						 rt_sigreturn);
 		put_user_ex(ptr_to_compat(restorer), &frame->pretcode);
 
@@ -542,7 +545,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		 * Not actually used anymore, but left because some gdb
 		 * versions need it.
 		 */
-		put_user_ex(*((u64 *)&code), (u64 *)frame->retcode);
+		put_user_ex(*((u64 *)&code), (u64 __user *)frame->retcode);
 	} put_user_catch(err);
 
 	if (err)
diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 9677f8e..769a16a 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -309,8 +309,8 @@ asmlinkage long sys32_rt_sigprocmask(int how, compat_sigset_t __user *set,
 	}
 	set_fs(KERNEL_DS);
 	ret = sys_rt_sigprocmask(how,
-				 set ? (sigset_t __user *)&s : NULL,
-				 oset ? (sigset_t __user *)&s : NULL,
+				 set ? (sigset_t __user __force *)&s : NULL,
+				 oset ? (sigset_t __user __force *)&s : NULL,
 				 sigsetsize);
 	set_fs(old_fs);
 	if (ret)
@@ -354,7 +354,7 @@ asmlinkage long sys32_sched_rr_get_interval(compat_pid_t pid,
 	mm_segment_t old_fs = get_fs();
 
 	set_fs(KERNEL_DS);
-	ret = sys_sched_rr_get_interval(pid, (struct timespec __user *)&t);
+	ret = sys_sched_rr_get_interval(pid, (struct timespec __user __force *)&t);
 	set_fs(old_fs);
 	if (put_compat_timespec(&t, interval))
 		return -EFAULT;
@@ -370,7 +370,7 @@ asmlinkage long sys32_rt_sigpending(compat_sigset_t __user *set,
 	mm_segment_t old_fs = get_fs();
 
 	set_fs(KERNEL_DS);
-	ret = sys_rt_sigpending((sigset_t __user *)&s, sigsetsize);
+	ret = sys_rt_sigpending((sigset_t __user __force *)&s, sigsetsize);
 	set_fs(old_fs);
 	if (!ret) {
 		switch (_NSIG_WORDS) {
@@ -395,7 +395,7 @@ asmlinkage long sys32_rt_sigqueueinfo(int pid, int sig,
 	if (copy_siginfo_from_user32(&info, uinfo))
 		return -EFAULT;
 	set_fs(KERNEL_DS);
-	ret = sys_rt_sigqueueinfo(pid, sig, (siginfo_t __user *)&info);
+	ret = sys_rt_sigqueueinfo(pid, sig, (siginfo_t __user __force *)&info);
 	set_fs(old_fs);
 	return ret;
 }
@@ -440,7 +440,7 @@ asmlinkage long sys32_sendfile(int out_fd, int in_fd,
 		return -EFAULT;
 
 	set_fs(KERNEL_DS);
-	ret = sys_sendfile(out_fd, in_fd, offset ? (off_t __user *)&of : NULL,
+	ret = sys_sendfile(out_fd, in_fd, offset ? (off_t __user __force *)&of : NULL,
 			   count);
 	set_fs(old_fs);
 
-- 
1.7.0.4

