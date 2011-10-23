Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab1JWKWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 06:22:09 -0400
Received: from mail.southpole.se ([193.12.106.18]:34913 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab1JWKUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 06:20:23 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>, David Howells <dhowells@redhat.com>
Subject: [PATCH RFC 3/8] frv: implement syscall restart generically
Date: Sun, 23 Oct 2011 12:19:57 +0200
Message-Id: <3abe1f77b13a218d52f43275b7b8269442f27dcb.1319364492.git.jonas@southpole.se>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1319364492.git.jonas@southpole.se>
References: <cover.1319364492.git.jonas@southpole.se>
In-Reply-To: <cover.1319364492.git.jonas@southpole.se>
References: <cover.1319364492.git.jonas@southpole.se>
X-Assp-Version: 2.1.1(11278) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 65222-13134
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

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/frv/include/asm/syscall.h |   23 ++++++++++++++++++-
 arch/frv/kernel/signal.c       |   48 ++-------------------------------------
 2 files changed, 25 insertions(+), 46 deletions(-)

diff --git a/arch/frv/include/asm/syscall.h b/arch/frv/include/asm/syscall.h
index 70689eb..a0493da 100644
--- a/arch/frv/include/asm/syscall.h
+++ b/arch/frv/include/asm/syscall.h
@@ -14,6 +14,7 @@
 
 #include <linux/err.h>
 #include <asm/ptrace.h>
+#include <asm/unistd.h>
 
 /*
  * Get the system call number or -1
@@ -34,6 +35,26 @@ static inline void syscall_rollback(struct task_struct *task,
 	regs->gr8 = regs->orig_gr8;
 }
 
+static inline void
+syscall_clear(struct task_struct *task, struct pt_regs *regs)
+{
+	regs->syscallno = -1;
+}
+
+static inline void
+syscall_restart(struct task_struct *task, struct pt_regs *regs)
+{
+	syscall_rollback(task, regs);
+	regs->pc -= 4;
+}
+
+static inline void
+syscall_do_restartblock(struct task_struct *task, struct pt_regs *regs)
+{
+	regs->gr7 = __NR_restart_syscall;
+	regs->pc -= 4;
+}
+
 /*
  * See if the syscall return value is an error, returning it if it is and 0 if
  * not
@@ -61,7 +82,7 @@ static inline void syscall_set_return_value(struct task_struct *task,
 					    int error, long val)
 {
 	if (error)
-		regs->gr8 = -error;
+		regs->gr8 = error;
 	else
 		regs->gr8 = val;
 }
diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index bab0129..a8bacdd 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -445,29 +445,6 @@ static int handle_signal(unsigned long sig, siginfo_t *info,
 {
 	int ret;
 
-	/* Are we from a system call? */
-	if (__frame->syscallno != -1) {
-		/* If so, check system call restarting.. */
-		switch (__frame->gr8) {
-		case -ERESTART_RESTARTBLOCK:
-		case -ERESTARTNOHAND:
-			__frame->gr8 = -EINTR;
-			break;
-
-		case -ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
-				__frame->gr8 = -EINTR;
-				break;
-			}
-
-			/* fallthrough */
-		case -ERESTARTNOINTR:
-			__frame->gr8 = __frame->orig_gr8;
-			__frame->pc -= 4;
-		}
-		__frame->syscallno = -1;
-	}
-
 	/* Set up the stack frame */
 	if (ka->sa.sa_flags & SA_SIGINFO)
 		ret = setup_rt_frame(sig, ka, info, oldset);
@@ -510,15 +487,15 @@ static void do_signal(void)
 	if (!user_mode(__frame))
 		return;
 
-	if (try_to_freeze())
-		goto no_signal;
-
 	if (test_thread_flag(TIF_RESTORE_SIGMASK))
 		oldset = &current->saved_sigmask;
 	else
 		oldset = &current->blocked;
 
 	signr = get_signal_to_deliver(&info, &ka, __frame, NULL);
+
+	handle_syscall_restart(__frame, &ka, (signr > 0));
+
 	if (signr > 0) {
 		if (handle_signal(signr, &info, &ka, oldset) == 0) {
 			/* a signal was successfully delivered; the saved
@@ -536,25 +513,6 @@ static void do_signal(void)
 	}
 
 no_signal:
-	/* Did we come from a system call? */
-	if (__frame->syscallno != -1) {
-		/* Restart the system call - no handlers present */
-		switch (__frame->gr8) {
-		case -ERESTARTNOHAND:
-		case -ERESTARTSYS:
-		case -ERESTARTNOINTR:
-			__frame->gr8 = __frame->orig_gr8;
-			__frame->pc -= 4;
-			break;
-
-		case -ERESTART_RESTARTBLOCK:
-			__frame->gr7 = __NR_restart_syscall;
-			__frame->pc -= 4;
-			break;
-		}
-		__frame->syscallno = -1;
-	}
-
 	/* if there's no signal to deliver, we just put the saved sigmask
 	 * back */
 	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
-- 
1.7.5.4

