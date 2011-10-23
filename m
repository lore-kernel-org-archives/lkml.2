Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab1JWKV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 06:21:29 -0400
Received: from mail.southpole.se ([193.12.106.18]:34919 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab1JWKUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 06:20:25 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>, linux-m68k@vger.kernel.org
Subject: [PATCH RFC 6/8] m68k: implement syscall restart generically
Date: Sun, 23 Oct 2011 12:20:00 +0200
Message-Id: <0162c73f2f917141d2210452188f8ed420730a53.1319364492.git.jonas@southpole.se>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1319364492.git.jonas@southpole.se>
References: <cover.1319364492.git.jonas@southpole.se>
In-Reply-To: <cover.1319364492.git.jonas@southpole.se>
References: <cover.1319364492.git.jonas@southpole.se>
X-Assp-Version: 2.1.1(11278) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 65223-06191
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

Cc: linux-m68k@lists.linux-m68k.org
Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/m68k/include/asm/syscall.h |   87 +++++++++++++++++++++++++++++++++++++++
 arch/m68k/kernel/signal_mm.c    |   45 +-------------------
 arch/m68k/kernel/signal_no.c    |   46 +-------------------
 3 files changed, 93 insertions(+), 85 deletions(-)
 create mode 100644 arch/m68k/include/asm/syscall.h

diff --git a/arch/m68k/include/asm/syscall.h b/arch/m68k/include/asm/syscall.h
new file mode 100644
index 0000000..a482b7b
--- /dev/null
+++ b/arch/m68k/include/asm/syscall.h
@@ -0,0 +1,87 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * Copyright (C) 2011 Jonas Bonn <jonas@southpole.se>
+ */
+
+#ifndef _M68K_SYSCALL_H
+#define _M68K_SYSCALL_H
+
+#include <linux/err.h>
+#include <linux/sched.h>
+#include <asm/unistd.h>
+
+static inline int
+syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
+{
+	if (regs->orig_d0 >= 0)
+		return regs->orig_d0;
+	else
+		return -1;
+}
+
+static inline void
+syscall_rollback(struct task_struct *task, struct pt_regs *regs)
+{
+	regs->d0 = regs->orig_d0;
+}
+
+static inline void
+syscall_clear(struct task_struct *task, struct pt_regs *regs)
+{
+	regs->orig_d0 = -1;
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
+	regs->d0 = __NR_restart_syscall;
+	regs->pc -= 2;
+}
+
+static inline long
+syscall_get_error(struct task_struct *task, struct pt_regs *regs)
+{
+	return IS_ERR_VALUE(regs->d0) ? regs->d0 : 0;
+}
+
+static inline long
+syscall_get_return_value(struct task_struct *task, struct pt_regs *regs)
+{
+	return regs->d0;
+}
+
+static inline void
+syscall_set_return_value(struct task_struct *task, struct pt_regs *regs,
+			 int error, long val)
+{
+	regs->d0 = (long) error ?: val;
+}
+
+#if 0
+static inline void
+syscall_get_arguments(struct task_struct *task, struct pt_regs *regs,
+		      unsigned int i, unsigned int n, unsigned long *args)
+{
+	/* TODO */
+}
+
+static inline void
+syscall_set_arguments(struct task_struct *task, struct pt_regs *regs,
+		      unsigned int i, unsigned int n, const unsigned long *args)
+{
+	/* TODO */
+}
+#endif
+
+#endif
diff --git a/arch/m68k/kernel/signal_mm.c b/arch/m68k/kernel/signal_mm.c
index a0afc23..a8fa041 100644
--- a/arch/m68k/kernel/signal_mm.c
+++ b/arch/m68k/kernel/signal_mm.c
@@ -895,39 +895,6 @@ give_sigsegv:
 	return err;
 }
 
-static inline void
-handle_restart(struct pt_regs *regs, struct k_sigaction *ka, int has_handler)
-{
-	switch (regs->d0) {
-	case -ERESTARTNOHAND:
-		if (!has_handler)
-			goto do_restart;
-		regs->d0 = -EINTR;
-		break;
-
-	case -ERESTART_RESTARTBLOCK:
-		if (!has_handler) {
-			regs->d0 = __NR_restart_syscall;
-			regs->pc -= 2;
-			break;
-		}
-		regs->d0 = -EINTR;
-		break;
-
-	case -ERESTARTSYS:
-		if (has_handler && !(ka->sa.sa_flags & SA_RESTART)) {
-			regs->d0 = -EINTR;
-			break;
-		}
-	/* fallthrough */
-	case -ERESTARTNOINTR:
-	do_restart:
-		regs->d0 = regs->orig_d0;
-		regs->pc -= 2;
-		break;
-	}
-}
-
 void ptrace_signal_deliver(struct pt_regs *regs, void *cookie)
 {
 	if (regs->orig_d0 < 0)
@@ -951,10 +918,6 @@ handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
 	      sigset_t *oldset, struct pt_regs *regs)
 {
 	int err;
-	/* are we from a system call? */
-	if (regs->orig_d0 >= 0)
-		/* If so, check system call restarting.. */
-		handle_restart(regs, ka, 1);
 
 	/* set up the stack frame */
 	if (ka->sa.sa_flags & SA_SIGINFO)
@@ -998,17 +961,15 @@ asmlinkage void do_signal(struct pt_regs *regs)
 		oldset = &current->blocked;
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
+
+	handle_syscall_restart(regs, &ka, (signr > 0));
+
 	if (signr > 0) {
 		/* Whee!  Actually deliver the signal.  */
 		handle_signal(signr, &ka, &info, oldset, regs);
 		return;
 	}
 
-	/* Did we come from a system call? */
-	if (regs->orig_d0 >= 0)
-		/* Restart the system call - no handlers present */
-		handle_restart(regs, NULL, 0);
-
 	/* If there's no signal to deliver, we just restore the saved mask.  */
 	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
 		clear_thread_flag(TIF_RESTORE_SIGMASK);
diff --git a/arch/m68k/kernel/signal_no.c b/arch/m68k/kernel/signal_no.c
index 36a81bb..2fad7c7 100644
--- a/arch/m68k/kernel/signal_no.c
+++ b/arch/m68k/kernel/signal_no.c
@@ -653,39 +653,6 @@ give_sigsegv:
 	goto adjust_stack;
 }
 
-static inline void
-handle_restart(struct pt_regs *regs, struct k_sigaction *ka, int has_handler)
-{
-	switch (regs->d0) {
-	case -ERESTARTNOHAND:
-		if (!has_handler)
-			goto do_restart;
-		regs->d0 = -EINTR;
-		break;
-
-	case -ERESTART_RESTARTBLOCK:
-		if (!has_handler) {
-			regs->d0 = __NR_restart_syscall;
-			regs->pc -= 2;
-			break;
-		}
-		regs->d0 = -EINTR;
-		break;
-
-	case -ERESTARTSYS:
-		if (has_handler && !(ka->sa.sa_flags & SA_RESTART)) {
-			regs->d0 = -EINTR;
-			break;
-		}
-	/* fallthrough */
-	case -ERESTARTNOINTR:
-	do_restart:
-		regs->d0 = regs->orig_d0;
-		regs->pc -= 2;
-		break;
-	}
-}
-
 /*
  * OK, we're invoking a handler
  */
@@ -694,10 +661,6 @@ handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
 	      sigset_t *oldset, struct pt_regs *regs)
 {
 	int err;
-	/* are we from a system call? */
-	if (regs->orig_d0 >= 0)
-		/* If so, check system call restarting.. */
-		handle_restart(regs, ka, 1);
 
 	/* set up the stack frame */
 	if (ka->sa.sa_flags & SA_SIGINFO)
@@ -745,18 +708,15 @@ asmlinkage void do_signal(struct pt_regs *regs)
 		oldset = &current->blocked;
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
+
+	handle_syscall_restart(regs, &ka, (signr > 0));
+
 	if (signr > 0) {
 		/* Whee!  Actually deliver the signal.  */
 		handle_signal(signr, &ka, &info, oldset, regs);
 		return;
 	}
 
-	/* Did we come from a system call? */
-	if (regs->orig_d0 >= 0) {
-		/* Restart the system call - no handlers present */
-		handle_restart(regs, NULL, 0);
-	}
-
 	/* If there's no signal to deliver, we just restore the saved mask.  */
 	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
 		clear_thread_flag(TIF_RESTORE_SIGMASK);
-- 
1.7.5.4

