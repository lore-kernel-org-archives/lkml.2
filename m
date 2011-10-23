Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab1JWKVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 06:21:42 -0400
Received: from mail.southpole.se ([193.12.106.18]:34917 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab1JWKUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 06:20:24 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>, x86@kernel.org
Subject: [PATCH RFC 5/8] x86: implement syscall restart generically
Date: Sun, 23 Oct 2011 12:19:59 +0200
Message-Id: <02fb4cb0bff0b6225a8c6a004193c66f7de5650d.1319364492.git.jonas@southpole.se>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1319364492.git.jonas@southpole.se>
References: <cover.1319364492.git.jonas@southpole.se>
In-Reply-To: <cover.1319364492.git.jonas@southpole.se>
References: <cover.1319364492.git.jonas@southpole.se>
X-Assp-Version: 2.1.1(11278) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 65223-10387
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

Cc: x86@kernel.org
Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/x86/include/asm/syscall.h |   21 +++++++++++++++++++
 arch/x86/kernel/signal.c       |   43 ++-------------------------------------
 2 files changed, 24 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index c4a348f..bd7e0f6 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -15,6 +15,7 @@
 
 #include <linux/sched.h>
 #include <linux/err.h>
+#include <asm/unistd.h>
 
 extern const unsigned long sys_call_table[];
 
@@ -34,6 +35,26 @@ static inline void syscall_rollback(struct task_struct *task,
 	regs->ax = regs->orig_ax;
 }
 
+static inline void
+syscall_clear(struct task_struct *task, struct pt_regs *regs)
+{
+	regs->orig_ax = -1;
+}
+
+static inline void
+syscall_restart(struct task_struct *task, struct pt_regs *regs)
+{
+	syscall_rollback(task, regs);
+	regs->ip -= 2;
+}
+
+static inline void
+syscall_do_restartblock(struct task_struct *task, struct pt_regs *regs)
+{
+	regs->ax = __NR_restart_syscall;
+	regs->ip -= 2;
+}
+
 static inline long syscall_get_error(struct task_struct *task,
 				     struct pt_regs *regs)
 {
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 54ddaeb2..366d5f7 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -685,28 +685,6 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	sigset_t blocked;
 	int ret;
 
-	/* Are we from a system call? */
-	if (syscall_get_nr(current, regs) >= 0) {
-		/* If so, check system call restarting.. */
-		switch (syscall_get_error(current, regs)) {
-		case -ERESTART_RESTARTBLOCK:
-		case -ERESTARTNOHAND:
-			regs->ax = -EINTR;
-			break;
-
-		case -ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
-				regs->ax = -EINTR;
-				break;
-			}
-		/* fallthrough */
-		case -ERESTARTNOINTR:
-			regs->ax = regs->orig_ax;
-			regs->ip -= 2;
-			break;
-		}
-	}
-
 	/*
 	 * If TF is set due to a debugger (TIF_FORCED_TF), clear the TF
 	 * flag so that register information in the sigcontext is correct.
@@ -773,30 +751,15 @@ static void do_signal(struct pt_regs *regs)
 		return;
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
+
+	handle_syscall_restart(regs, &ka, (signr > 0));
+
 	if (signr > 0) {
 		/* Whee! Actually deliver the signal.  */
 		handle_signal(signr, &info, &ka, regs);
 		return;
 	}
 
-	/* Did we come from a system call? */
-	if (syscall_get_nr(current, regs) >= 0) {
-		/* Restart the system call - no handlers present */
-		switch (syscall_get_error(current, regs)) {
-		case -ERESTARTNOHAND:
-		case -ERESTARTSYS:
-		case -ERESTARTNOINTR:
-			regs->ax = regs->orig_ax;
-			regs->ip -= 2;
-			break;
-
-		case -ERESTART_RESTARTBLOCK:
-			regs->ax = NR_restart_syscall;
-			regs->ip -= 2;
-			break;
-		}
-	}
-
 	/*
 	 * If there's no signal to deliver, we just put the saved sigmask
 	 * back.
-- 
1.7.5.4

