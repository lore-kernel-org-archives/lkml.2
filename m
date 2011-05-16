Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab1EPSTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:19:09 -0400
Received: from mail-bw0-f52.google.com ([209.85.214.52]:60031 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab1EPSRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:17:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=xF1fButubzQ+jz9FKGsfrcyeq3oCCB8Fd8/h9tQ5xy4Ht4YSLRUogY+nXz37KbM8QS
         GU+N2vyPSxb9JLHcuul/OImGjO9q+2w9TB8PSFgf1rx2rNq+td3Yqd5RluMrnbbT/jV+
         AcuzvNjf0eHQVU4jRcnLfBbPJddZdJjoPk6+Y=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Date: Mon, 16 May 2011 20:17:22 +0200
Message-Id: <1305569849-10448-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1305569849-10448-1-git-send-email-tj@kernel.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PTRACE_ATTACH implicitly issues SIGSTOP on attach which has side
effects on tracee signal and job control states.  This patch
implements a new ptrace request PTRACE_SEIZE which attaches and traps
tracee without affecting its signal and job control states.

The usage is the same with PTRACE_ATTACH but it takes PTRACE_SEIZE_*
flags in @data.  Currently, the only defined flag is
PTRACE_SEIZE_DEVEL which is a temporary flag to enable PTRACE_SEIZE.
PTRACE_SEIZE will change ptrace behaviors outside of attach itself.
The changes will be implemented gradually and the DEVEL flag is to
prevent programs which expect full SEIZE behavior from using it before
all the behavior modifications are complete while allowing unit
testing.  The flag will be removed once SEIZE behaviors are completely
implemented.

After PTRACE_SEIZE, tracee will trap.  Which trap will happen isn't
fixed.  If other trap conditions exist (e.g. signal delivery), they
might be taken; otherwise, a trap with exit_code == (SIGTRAP |
PTRACE_EVENT_STOP << 8) is taken.  If seized, this trap is also used
for group stop traps instead of exit_code == 0 with NULL GETSIGINFO.

* PTRACE_SEIZE doesn't affect signal or group stop state.

* After PTRACE_SEIZE, one trap will happen which might be a
  PTRACE_EVENT_STOP trap.

* If PTRACE_SEIZE'd, group stop also uses PTRACE_EVENT_STOP trap which
  uses exit_code of (SIGTRAP | PTRACE_EVENT_STOP << 8) instead of the
  stopping signal number and returns usual trap siginfo on
  PTRACE_GETSIGINFO instead of NULL.

Note that there currently is no way to find out the stopping signal
number while seized.  This will be improved by future patches.

Seizing sets PT_SEIZED in ->ptrace of the tracee.  This flag will be
used to determine whether new SEIZE behaviors should be enabled.

Test program follows.

  #define PTRACE_SEIZE		0x4206
  #define PTRACE_SEIZE_DEVEL	0x80000000

  static const struct timespec ts100ms = { .tv_nsec = 100000000 };
  static const struct timespec ts1s = { .tv_sec = 1 };
  static const struct timespec ts3s = { .tv_sec = 3 };

  int main(int argc, char **argv)
  {
	  pid_t tracee;

	  tracee = fork();
	  if (tracee == 0) {
		  nanosleep(&ts100ms, NULL);
		  while (1) {
			  printf("tracee: alive\n");
			  nanosleep(&ts1s, NULL);
		  }
	  }

	  if (argc > 1)
		  kill(tracee, SIGSTOP);

	  nanosleep(&ts100ms, NULL);

	  ptrace(PTRACE_SEIZE, tracee, NULL,
		 (void *)(unsigned long)PTRACE_SEIZE_DEVEL);
	  waitid(P_PID, tracee, NULL, WSTOPPED);
	  ptrace(PTRACE_CONT, tracee, NULL, NULL);
	  nanosleep(&ts3s, NULL);
	  printf("tracer: exiting\n");
	  return 0;
  }

When the above program is called w/o argument, tracee is seized from
running state and continued.  When tracer exits, tracee is returned to
running state and keeps printing out.

  # ./test-seize
  tracee: alive
  tracee: alive
  tracee: alive
  tracer: exiting
  # tracee: alive
  tracee: alive
  tracee: alive

When called with an argument, tracee is seized from stopped state and
continued, and returns to stopped state when tracer exits.

  # ./test-seize
  tracee: alive
  tracee: alive
  tracee: alive
  tracer: exiting
  # ps -el|grep test-seize
  1 T     0  4720     1  0  80   0 -   941 signal ttyS0    00:00:00 test-seize

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/ptrace.h |    7 +++++++
 kernel/ptrace.c        |   38 ++++++++++++++++++++++++++++++++------
 kernel/signal.c        |   32 ++++++++++++++++++++++++--------
 3 files changed, 63 insertions(+), 14 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 6b359cd..3fd389d 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -47,6 +47,11 @@
 #define PTRACE_GETREGSET	0x4204
 #define PTRACE_SETREGSET	0x4205
 
+#define PTRACE_SEIZE		0x4206
+
+/* flags in @data for PTRACE_SEIZE */
+#define PTRACE_SEIZE_DEVEL	0x80000000 /* temp flag for development */
+
 /* options set using PTRACE_SETOPTIONS */
 #define PTRACE_O_TRACESYSGOOD	0x00000001
 #define PTRACE_O_TRACEFORK	0x00000002
@@ -65,6 +70,7 @@
 #define PTRACE_EVENT_EXEC	4
 #define PTRACE_EVENT_VFORK_DONE	5
 #define PTRACE_EVENT_EXIT	6
+#define PTRACE_EVENT_STOP	7
 
 #include <asm/ptrace.h>
 
@@ -77,6 +83,7 @@
  * flags.  When the a task is stopped the ptracer owns task->ptrace.
  */
 
+#define PT_SEIZED	0x00010000	/* SEIZE used, enable new behavior */
 #define PT_PTRACED	0x00000001
 #define PT_DTRACE	0x00000002	/* delayed trace (used on m68k, i386) */
 #define PT_TRACESYSGOOD	0x00000004
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 7f02129..7aefd43 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -254,10 +254,28 @@ bool ptrace_may_access(struct task_struct *task, unsigned int mode)
 	return !err;
 }
 
-static int ptrace_attach(struct task_struct *task)
+static int ptrace_attach(struct task_struct *task, long request,
+			 unsigned long flags)
 {
+	bool seize = (request == PTRACE_SEIZE);
 	int retval;
 
+	/*
+	 * SEIZE will enable new ptrace behaviors which will be implemented
+	 * gradually.  SEIZE_DEVEL is used to prevent applications
+	 * expecting full SEIZE behaviors trapping on kernel commits which
+	 * are still in the process of implementing them.
+	 *
+	 * Only test programs for new ptrace behaviors being implemented
+	 * should set SEIZE_DEVEL.  If unset, SEIZE will fail with -EIO.
+	 *
+	 * Once SEIZE behaviors are completely implemented, this flag and
+	 * the following test will be removed.
+	 */
+	retval = -EIO;
+	if (seize && !(flags & PTRACE_SEIZE_DEVEL))
+		goto out;
+
 	audit_ptrace(task);
 
 	retval = -EPERM;
@@ -289,11 +307,16 @@ static int ptrace_attach(struct task_struct *task)
 		goto unlock_tasklist;
 
 	task->ptrace = PT_PTRACED;
+	if (seize)
+		task->ptrace |= PT_SEIZED;
 	if (task_ns_capable(task, CAP_SYS_PTRACE))
 		task->ptrace |= PT_PTRACE_CAP;
 
 	__ptrace_link(task, current);
-	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
+
+	/* SEIZE uses TRAP_STOP instead of SIGSTOP for initial trap */
+	if (!seize)
+		send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
 
 	spin_lock(&task->sighand->siglock);
 
@@ -315,6 +338,9 @@ static int ptrace_attach(struct task_struct *task)
 	if (task_is_stopped(task)) {
 		task->jobctl |= JOBCTL_TRAP_STOP | JOBCTL_TRAPPING;
 		signal_wake_up(task, 1);
+	} else if (seize) {
+		task->jobctl |= JOBCTL_TRAP_STOP;
+		signal_wake_up(task, 0);
 	}
 
 	spin_unlock(&task->sighand->siglock);
@@ -826,8 +852,8 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
 		goto out;
 	}
 
-	if (request == PTRACE_ATTACH) {
-		ret = ptrace_attach(child);
+	if (request == PTRACE_ATTACH || request == PTRACE_SEIZE) {
+		ret = ptrace_attach(child, request, data);
 		/*
 		 * Some architectures need to do book-keeping after
 		 * a ptrace attach.
@@ -968,8 +994,8 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 		goto out;
 	}
 
-	if (request == PTRACE_ATTACH) {
-		ret = ptrace_attach(child);
+	if (request == PTRACE_ATTACH || request == PTRACE_SEIZE) {
+		ret = ptrace_attach(child, request, data);
 		/*
 		 * Some architectures need to do book-keeping after
 		 * a ptrace attach.
diff --git a/kernel/signal.c b/kernel/signal.c
index 50a4e8a..84e75db 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1840,7 +1840,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	recalc_sigpending_tsk(current);
 }
 
-void ptrace_notify(int exit_code)
+static void ptrace_do_notify(int exit_code, int why)
 {
 	siginfo_t info;
 
@@ -1853,8 +1853,13 @@ void ptrace_notify(int exit_code)
 	info.si_uid = current_uid();
 
 	/* Let the debugger run.  */
+	ptrace_stop(exit_code, why, 1, &info);
+}
+
+void ptrace_notify(int exit_code)
+{
 	spin_lock_irq(&current->sighand->siglock);
-	ptrace_stop(exit_code, CLD_TRAPPED, 1, &info);
+	ptrace_do_notify(exit_code, CLD_TRAPPED);
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
@@ -2079,14 +2084,25 @@ relock:
 	}
 
 	/*
-	 * Take care of ptrace jobctl traps.  It currently is only used to
-	 * trap for group stop while ptraced.
+	 * Take care of ptrace jobctl traps.
+	 *
+	 * When PT_SEIZED, it's used for both group stop and explicit
+	 * SEIZE/INTERRUPT traps.  Both generate PTRACE_EVENT_STOP trap
+	 * with accompanying siginfo.
+	 *
+	 * When !PT_SEIZED, it's used only for group stop trap with
+	 * CLD_STOPPED as exit_code and no siginfo.
 	 */
 	if (unlikely(current->jobctl & JOBCTL_TRAP_MASK)) {
-		signr = current->jobctl & JOBCTL_STOP_SIGMASK;
-		WARN_ON_ONCE(!signr);
-		ptrace_stop(signr, CLD_STOPPED, 0, NULL);
-		current->exit_code = 0;
+		if (current->ptrace & PT_SEIZED) {
+			ptrace_do_notify(SIGTRAP | PTRACE_EVENT_STOP << 8,
+					 CLD_STOPPED);
+		} else {
+			signr = current->jobctl & JOBCTL_STOP_SIGMASK;
+			WARN_ON_ONCE(!signr);
+			ptrace_stop(signr, CLD_STOPPED, 0, NULL);
+			current->exit_code = 0;
+		}
 		spin_unlock_irq(&sighand->siglock);
 		goto relock;
 	}
-- 
1.7.1

