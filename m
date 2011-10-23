Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab1JWKUq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 06:20:46 -0400
Received: from mail.southpole.se ([193.12.106.18]:34923 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab1JWKU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 06:20:26 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>, Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH RFC 8/8] tile: implement syscall restart generically
Date: Sun, 23 Oct 2011 12:20:02 +0200
Message-Id: <e790f266cc75b291d44726cf6bf8641d1bf7af5d.1319364492.git.jonas@southpole.se>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1319364492.git.jonas@southpole.se>
References: <cover.1319364492.git.jonas@southpole.se>
In-Reply-To: <cover.1319364492.git.jonas@southpole.se>
References: <cover.1319364492.git.jonas@southpole.se>
X-Assp-Version: 2.1.1(11278) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 65224-07159
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

Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/tile/include/asm/syscall.h |   28 ++++++++++++++++++++-
 arch/tile/kernel/signal.c       |   52 +++------------------------------------
 2 files changed, 31 insertions(+), 49 deletions(-)

diff --git a/arch/tile/include/asm/syscall.h b/arch/tile/include/asm/syscall.h
index d35e0dc..428e28c 100644
--- a/arch/tile/include/asm/syscall.h
+++ b/arch/tile/include/asm/syscall.h
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 #include <arch/abi.h>
+#include <asm/unistd.h>
 
 /*
  * Only the low 32 bits of orig_r0 are meaningful, so we return int.
@@ -29,15 +30,40 @@
  */
 static inline int syscall_get_nr(struct task_struct *t, struct pt_regs *regs)
 {
-	return regs->regs[TREG_SYSCALL_NR];
+	if (regs->faultnum == INT_SWINT_1)
+		return regs->regs[TREG_SYSCALL_NR];
+	else
+		return -1;
 }
 
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
+	regs->flags |= PT_FLAGS_CALLER_SAVES;
 	regs->regs[0] = regs->orig_r0;
 }
 
+static inline void
+syscall_clear(struct task_struct *task, struct pt_regs *regs)
+{
+	regs->faultnum = INT_SWINT_1_SIGRETURN;
+}
+
+static inline void
+syscall_restart(struct task_struct *task, struct pt_regs *regs)
+{
+	syscall_rollback(task, regs);
+	regs->pc -= 8;
+}
+
+static inline void
+syscall_do_restartblock(struct task_struct *task, struct pt_regs *regs)
+{
+	regs->flags |= PT_FLAGS_CALLER_SAVES;
+	regs->gpr[TREG_SYSCALL_NR] = __NR_restart_syscall;
+	regs->pc -= 8;
+}
+
 static inline long syscall_get_error(struct task_struct *task,
 				     struct pt_regs *regs)
 {
diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index bedaf4e..ab1f4e7 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -251,29 +251,6 @@ static int handle_signal(unsigned long sig, siginfo_t *info,
 {
 	int ret;
 
-	/* Are we from a system call? */
-	if (regs->faultnum == INT_SWINT_1) {
-		/* If so, check system call restarting.. */
-		switch (regs->regs[0]) {
-		case -ERESTART_RESTARTBLOCK:
-		case -ERESTARTNOHAND:
-			regs->regs[0] = -EINTR;
-			break;
-
-		case -ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
-				regs->regs[0] = -EINTR;
-				break;
-			}
-			/* fallthrough */
-		case -ERESTARTNOINTR:
-			/* Reload caller-saves to restore r0..r5 and r10. */
-			regs->flags |= PT_FLAGS_CALLER_SAVES;
-			regs->regs[0] = regs->orig_r0;
-			regs->pc -= 8;
-		}
-	}
-
 	/* Set up the stack frame */
 #ifdef CONFIG_COMPAT
 	if (is_compat_task())
@@ -323,6 +300,9 @@ void do_signal(struct pt_regs *regs)
 		oldset = &current->blocked;
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
+
+	handle_syscall_restart(regs, &ka, (signr > 0));
+
 	if (signr > 0) {
 		/* Whee! Actually deliver the signal.  */
 		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
@@ -335,27 +315,7 @@ void do_signal(struct pt_regs *regs)
 			current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
 		}
 
-		goto done;
-	}
-
-	/* Did we come from a system call? */
-	if (regs->faultnum == INT_SWINT_1) {
-		/* Restart the system call - no handlers present */
-		switch (regs->regs[0]) {
-		case -ERESTARTNOHAND:
-		case -ERESTARTSYS:
-		case -ERESTARTNOINTR:
-			regs->flags |= PT_FLAGS_CALLER_SAVES;
-			regs->regs[0] = regs->orig_r0;
-			regs->pc -= 8;
-			break;
-
-		case -ERESTART_RESTARTBLOCK:
-			regs->flags |= PT_FLAGS_CALLER_SAVES;
-			regs->regs[TREG_SYSCALL_NR] = __NR_restart_syscall;
-			regs->pc -= 8;
-			break;
-		}
+		return;
 	}
 
 	/* If there's no signal to deliver, just put the saved sigmask back. */
@@ -363,10 +323,6 @@ void do_signal(struct pt_regs *regs)
 		current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
 		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
 	}
-
-done:
-	/* Avoid double syscall restart if there are nested signals. */
-	regs->faultnum = INT_SWINT_1_SIGRETURN;
 }
 
 int show_unhandled_signals = 1;
-- 
1.7.5.4

