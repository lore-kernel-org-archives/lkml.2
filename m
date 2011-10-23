Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab1JWKU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 06:20:27 -0400
Received: from mail.southpole.se ([193.12.106.18]:34911 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab1JWKUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 06:20:23 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH RFC 1/8] signal: introduce generic syscall restart logic
Date: Sun, 23 Oct 2011 12:19:55 +0200
Message-Id: <4aa1797d978fe2d45ececceee535257e19374df8.1319364492.git.jonas@southpole.se>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1319364492.git.jonas@southpole.se>
References: <cover.1319364492.git.jonas@southpole.se>
In-Reply-To: <cover.1319364492.git.jonas@southpole.se>
References: <cover.1319364492.git.jonas@southpole.se>
X-Assp-Version: 2.1.1(11278) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 65221-08137
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Manipulating the task state so that an interrupted syscall will be
re-executed after signal handling has historically been purely architecture
specific logic.  Most architectures, however, are implementing essentially
the same thing (some incorrectly) with the actual details of the registers
to be manipulated being the only relevant difference.

This patch introduces generic code for handling the syscall restart logic
by:

i)  introducing methods for doing the actual register manipulations to
the generic syscall interface in asm/syscall.h

ii) introducing the function handle_syscall_restart to determine the
actual restart requirements and invoke the required register manipulations;
this function is designed to be called immediately after invoking the
function get_signal_to_deliver

This generic variant is applicable for any architecture that maintains the
information necessary to effect a syscall restart in its pt_regs struct.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 include/asm-generic/syscall.h |   46 +++++++++++++++++++++++++-
 include/linux/signal.h        |    3 ++
 kernel/signal.c               |   72 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 119 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/syscall.h b/include/asm-generic/syscall.h
index 5c122ae..b7b489f 100644
--- a/include/asm-generic/syscall.h
+++ b/include/asm-generic/syscall.h
@@ -36,11 +36,55 @@ struct pt_regs;
  * system call number can be meaningful.  If the actual arch value
  * is 64 bits, this truncates to 32 bits so 0xffffffff means -1.
  *
- * It's only valid to call this when @task is known to be blocked.
+ * It's only valid to call this for the current task or when @task
+ * is known to be blocked.
  */
 int syscall_get_nr(struct task_struct *task, struct pt_regs *regs);
 
 /**
+ * syscall_clear - clear the syscall execution state
+ *
+ * Clear the syscall execution state of @task so that future invocations
+ * of syscall_get_nr for @task return -1.
+ *
+ * It's only valid to call this for the current task.  This function
+ * is primarily intended for use in the signal handling path; when
+ * signal handling takes over after a syscall then the syscall handling
+ * is effectively finished and the syscall state can be cleared.
+ */
+void syscall_clear(struct task_struct *task, struct pt_regs *regs);
+
+/**
+ * syscall_do_restart - roll back PC and argument regs for syscall restart
+ * @task:	must be current task
+ * @regs:	task_pt_regs() of @task
+ * 
+ * Rolls back the syscall number, arguments, and the instruction pointer
+ * so that the current syscall will be reexecuted upon return to userspace.
+ *
+ * This function is primarily intended for use in the signal handling
+ * code and shouldn't really be used elsewhere.
+ */
+void syscall_restart(struct task_struct *task, struct pt_regs *regs);
+
+/**
+ * syscall_do_restartblock - roll back PC and execute restart_syscall
+ * @task:	must be current task
+ * @regs:	task_pt_regs() of @task
+ * 
+ * Configure @task so that upon return to userspace the restart_syscall
+ * (or equivalent) function is executed to perform syscall restart via a
+ * restart_block.  Since restart_syscall normally doesn't take any arguments,
+ * restoring the syscall arguments can be skipped.  This normally boils
+ * down to rewinding the PC and setting the syscall register to 
+ * __NR_restart_syscall; however, some arch's may do this differently.
+ *
+ * This function is primarily intended for use in the signal handling
+ * code.
+ */
+void syscall_do_restartblock(struct task_struct * taks, struct pt_regs* regs);
+
+/**
  * syscall_rollback - roll back registers after an aborted system call
  * @task:	task of interest, must be in system call exit tracing
  * @regs:	task_pt_regs() of @task
diff --git a/include/linux/signal.h b/include/linux/signal.h
index a822300..7ede592 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -256,6 +256,9 @@ extern int show_unhandled_signals;
 extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
 extern void exit_signals(struct task_struct *tsk);
 
+void handle_syscall_restart(struct pt_regs *regs, struct k_sigaction *ka,
+			    int has_handler);
+
 extern struct kmem_cache *sighand_cachep;
 
 int unhandled_signal(struct task_struct *tsk, int sig);
diff --git a/kernel/signal.c b/kernel/signal.c
index 291c970..7b3d9a4 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -33,8 +33,8 @@
 
 #include <asm/param.h>
 #include <asm/uaccess.h>
-#include <asm/unistd.h>
 #include <asm/siginfo.h>
+#include <asm/syscall.h>
 #include "audit.h"	/* audit_signal_info() */
 
 /*
@@ -2396,6 +2396,76 @@ EXPORT_SYMBOL(sigprocmask);
 EXPORT_SYMBOL(block_all_signals);
 EXPORT_SYMBOL(unblock_all_signals);
 
+/**
+ * handle_syscall_restart();
+ * @regs: pt_regs for current process
+ * @ka:   k_sigaction struct for current signal handler 
+ * @has_handler: boolean indicating whether there is a handler waiting
+ *               to be invoked for a pending signal
+ *
+ * Prepare the currently executing task to restart an interrupted
+ * syscall.  After completion of this function, the task is effectively
+ * switched from syscall-execution mode to signal-processing mode and
+ * further attempts to manipulate the syscall state will fail.
+ *
+ * If has_handler != 0, then ka must point to a valid sigaction struct.
+ */
+
+void handle_syscall_restart(struct pt_regs *regs, struct k_sigaction *ka,
+			    int has_handler)
+{
+	/* Are we from a system call? */
+	if (syscall_get_nr(current, regs) >= 0) {
+		int restart = 1;
+		long error;
+
+		error = syscall_get_error(current, regs);
+
+		/* Check if syscall was interrupted. */
+		switch (error) {
+		case -ERESTART_RESTARTBLOCK:
+		case -ERESTARTNOHAND:
+			/* Restart if there is no handler */
+			restart = !has_handler;
+			break;
+
+		case -ERESTARTSYS:
+			/*
+			 * Restart if there is no handler or if the handler
+			 * was registered with SA_RESTART
+			 */
+			restart = !has_handler
+				  || (ka->sa.sa_flags & SA_RESTART);
+			break;
+
+		case -ERESTARTNOINTR:
+			/* Restart after signal handler returns */ 
+			restart = 1;
+			break;
+
+		default:
+			/* Syscall wasn't interrupted so we're done with it */
+			syscall_clear(current, regs);
+			return;
+		}
+
+		if (restart) {
+			if (error == -ERESTART_RESTARTBLOCK)
+				syscall_do_restartblock(current, regs);
+			else
+				syscall_restart(current, regs);
+		} else {
+			syscall_set_return_value(current, regs, -EINTR, 0);
+		}
+
+		/*
+		 * The syscall processing is effectively complete here so
+		 * the syscall state can be cleared to prevent this function
+		 * from triggering again for nested signals.
+		 */
+		syscall_clear(current, regs);
+	}
+}
 
 /*
  * System call entry points.
-- 
1.7.5.4

