Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1JWKU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 06:20:26 -0400
Received: from mail.southpole.se ([193.12.106.18]:34912 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1JWKUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 06:20:23 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>, uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH RFC 2/8] blackfin: implement syscall restart generically
Date: Sun, 23 Oct 2011 12:19:56 +0200
Message-Id: <f33d604e18508d766a224f66f0bc9340af00ee89.1319364492.git.jonas@southpole.se>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1319364492.git.jonas@southpole.se>
References: <cover.1319364492.git.jonas@southpole.se>
In-Reply-To: <cover.1319364492.git.jonas@southpole.se>
References: <cover.1319364492.git.jonas@southpole.se>
X-Assp-Version: 2.1.1(11278) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 65221-13050
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Manipulating task state to effect re-execution of an interrupted syscall
used to be purely architecture specific code.  However, as most arch's
were essentially just making minor adjustments to almost identical logic,
this code could be moved to a common implementation.

The generic variant introduces the function handle_syscall_restart() to be
called after get_signal_to_deliver().  The architecture specific register
manipulations required to effect the actual restart are now implemented
in the generic syscall interface found in asm/syscall.h

This patch transitions this architecture's signal handling code over to
using the generic syscall restart code by:

i)  Implementing the register manipulations in asm/syscall.h
ii) Replacing the restart logic with a call to handle_syscall_restart

Cc: uclinux-dist-devel@blackfin.uclinux.org
Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/blackfin/include/asm/syscall.h |   26 ++++++++++++++++++-
 arch/blackfin/kernel/signal.c       |   47 ++--------------------------------
 2 files changed, 27 insertions(+), 46 deletions(-)

diff --git a/arch/blackfin/include/asm/syscall.h b/arch/blackfin/include/asm/syscall.h
index 4921a48..87005c4 100644
--- a/arch/blackfin/include/asm/syscall.h
+++ b/arch/blackfin/include/asm/syscall.h
@@ -21,17 +21,39 @@
 #include <linux/err.h>
 #include <linux/sched.h>
 #include <asm/ptrace.h>
+#include <asm/unistd.h>
 
 static inline long
 syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
 {
-	return regs->p0;
+	return regs->orig_p0;
 }
 
 static inline void
 syscall_rollback(struct task_struct *task, struct pt_regs *regs)
 {
 	regs->p0 = regs->orig_p0;
+	regs->r0 = regs->orig_r0;
+}
+
+static inline void
+syscall_clear(struct task_struct *task, struct pt_regs *regs)
+{
+	regs->orig_p0 = -1;
+}
+
+static inline void
+syscall_restart(struct task_struct *task, struct pt_regs *regs)
+{
+	syscall_rollback(task, regs);
+	regs->pc -= 2;
+}
+
+static inline void
+syscall_do_restartblock(struct task_struct *task, struct pt_regs *regs)
+{
+	regs->p0 = __NR_restart_syscall;
+	regs->pc -= 2;
 }
 
 static inline long
@@ -50,7 +72,7 @@ static inline void
 syscall_set_return_value(struct task_struct *task, struct pt_regs *regs,
                          int error, long val)
 {
-	regs->r0 = error ? -error : val;
+	regs->r0 = error ? error : val;
 }
 
 /**
diff --git a/arch/blackfin/kernel/signal.c b/arch/blackfin/kernel/signal.c
index d536f35..7fc176a 100644
--- a/arch/blackfin/kernel/signal.c
+++ b/arch/blackfin/kernel/signal.c
@@ -219,36 +219,6 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t * info,
 	return -EFAULT;
 }
 
-static inline void
-handle_restart(struct pt_regs *regs, struct k_sigaction *ka, int has_handler)
-{
-	switch (regs->r0) {
-	case -ERESTARTNOHAND:
-		if (!has_handler)
-			goto do_restart;
-		regs->r0 = -EINTR;
-		break;
-
-	case -ERESTARTSYS:
-		if (has_handler && !(ka->sa.sa_flags & SA_RESTART)) {
-			regs->r0 = -EINTR;
-			break;
-		}
-		/* fallthrough */
-	case -ERESTARTNOINTR:
- do_restart:
-		regs->p0 = regs->orig_p0;
-		regs->r0 = regs->orig_r0;
-		regs->pc -= 2;
-		break;
-
-	case -ERESTART_RESTARTBLOCK:
-		regs->p0 = __NR_restart_syscall;
-		regs->pc -= 2;
-		break;
-	}
-}
-
 /*
  * OK, we're invoking a handler
  */
@@ -258,11 +228,6 @@ handle_signal(int sig, siginfo_t *info, struct k_sigaction *ka,
 {
 	int ret;
 
-	/* are we from a system call? to see pt_regs->orig_p0 */
-	if (regs->orig_p0 >= 0)
-		/* If so, check system call restarting.. */
-		handle_restart(regs, ka, 1);
-
 	/* set up the stack frame */
 	ret = setup_rt_frame(sig, ka, info, oldset, regs);
 
@@ -296,15 +261,15 @@ asmlinkage void do_signal(struct pt_regs *regs)
 
 	current->thread.esp0 = (unsigned long)regs;
 
-	if (try_to_freeze())
-		goto no_signal;
-
 	if (test_thread_flag(TIF_RESTORE_SIGMASK))
 		oldset = &current->saved_sigmask;
 	else
 		oldset = &current->blocked;
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
+
+	handle_syscall_restart(regs, &ka, (signr > 0));
+
 	if (signr > 0) {
 		/* Whee!  Actually deliver the signal.  */
 		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
@@ -322,12 +287,6 @@ asmlinkage void do_signal(struct pt_regs *regs)
 		return;
 	}
 
- no_signal:
-	/* Did we come from a system call? */
-	if (regs->orig_p0 >= 0)
-		/* Restart the system call - no handlers present */
-		handle_restart(regs, NULL, 0);
-
 	/* if there's no signal to deliver, we just put the saved sigmask
 	 * back */
 	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
-- 
1.7.5.4

