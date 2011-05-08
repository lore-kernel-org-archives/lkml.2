Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab1EHPtb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:49:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42994 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab1EHPtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:49:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=yGMFF0/lBykKBy+dN7MNhUbEmHGmJnAjxqrhCdyqe87jFveDRnXs5fFNW3rGDLZT8h
         H3WQk32jgoK79ZLq0IMwFqaPCvLRkx+BCopQVuxTKuSp/ZOsi595YSeeK9KnWCc5py7B
         9e8Cu5GoGrCqJGm2YOmC6J47YmUpf61ICS2T8=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/11] ptrace: implement PTRACE_INTERRUPT
Date: Sun,  8 May 2011 17:48:58 +0200
Message-Id: <1304869745-1073-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304869745-1073-1-git-send-email-tj@kernel.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there's no way to trap a running ptracee short of sending a
signal which has various side effects.  This patch implements
PTRACE_INTERRUPT which traps ptracee without any signal or job control
related side effect.

The implementation is almost trivial.  It uses the same trap site and
event as PTRACE_SEIZE.  A new trap flag JOBCTL_TRAP_INTERRUPT is
added, which is set on PTRACE_INTERRUPT and cleared when tracee
commits to INTERRUPT trap.  As INTERRUPT should be useable regardless
of the current state of tracee, task_is_traced() test in
ptrace_check_attach() is skipped for INTERRUPT.

PTRACE_INTERRUPT is available iff tracee is attached with
PTRACE_SEIZE.

Test program follows.

  #define PTRACE_SEIZE		0x4206
  #define PTRACE_INTERRUPT	0x4207

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
			  printf("tracee: alive pid=%d\n", getpid());
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

	  printf("tracer: INTERRUPT and DETACH\n");
	  ptrace(PTRACE_INTERRUPT, tracee, NULL, NULL);
	  waitid(P_PID, tracee, NULL, WSTOPPED);
	  ptrace(PTRACE_DETACH, tracee, NULL, NULL);
	  nanosleep(&ts3s, NULL);

	  printf("tracer: exiting\n");
	  kill(tracee, SIGKILL);
	  return 0;
  }

When called without argument, tracee is seized from running state,
continued, interrupted and then detached back to running state.

  # ./test-interrupt
  tracee: alive pid=4546
  tracee: alive pid=4546
  tracee: alive pid=4546
  tracer: INTERRUPT and DETACH
  tracee: alive pid=4546
  tracee: alive pid=4546
  tracee: alive pid=4546
  tracer: exiting

When called with argument, it's the same but tracee is detached back
to stopped state.

  # ./test-interrupt  1
  tracee: alive pid=4548
  tracee: alive pid=4548
  tracee: alive pid=4548
  tracer: INTERRUPT and DETACH
  tracer: exiting

Before PTRACE_INTERRUPT, once the tracee was continued, there was no
easy way to do PTRACE_DETACH without causing side effect as tracee
couldn't be trapped without side effect.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/ptrace.h |    1 +
 include/linux/sched.h  |    3 ++-
 kernel/ptrace.c        |   23 +++++++++++++++++++++--
 kernel/signal.c        |    4 ++++
 4 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 8de301a..5b6128b 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -48,6 +48,7 @@
 #define PTRACE_SETREGSET	0x4205
 
 #define PTRACE_SEIZE		0x4206
+#define PTRACE_INTERRUPT	0x4207
 
 /* flags in @data for PTRACE_SEIZE */
 #define PTRACE_SEIZE_DEVEL	0x80000000 /* temp flag for development */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2f383eb..221ab51 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1785,9 +1785,10 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define JOBCTL_STOP_PENDING	(1 << 17) /* task should stop for group stop */
 #define JOBCTL_STOP_CONSUME	(1 << 18) /* consume group stop count */
 #define JOBCTL_TRAP_SEIZE	(1 << 19) /* trap for seize */
+#define JOBCTL_TRAP_INTERRUPT	(1 << 20) /* trap for interrupt */
 #define JOBCTL_TRAPPING		(1 << 22) /* switching to TRACED */
 
-#define JOBCTL_TRAP_MASK	JOBCTL_TRAP_SEIZE
+#define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_SEIZE | JOBCTL_TRAP_INTERRUPT)
 #define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK)
 
 extern void task_clear_jobctl_stop_pending(struct task_struct *task);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 0f0121a..1262a36 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -693,6 +693,23 @@ int ptrace_request(struct task_struct *child, long request,
 			ret = ptrace_setsiginfo(child, &siginfo);
 		break;
 
+	case PTRACE_INTERRUPT:
+		if (!likely(child->ptrace & PT_SEIZED))
+			break;
+		/*
+		 * Stop tracee without any side-effect on signal or job
+		 * control.  If @child is already trapped, the current trap
+		 * is not disturbed and INTERRUPT trap will happen after
+		 * the current trap is ended with PTRACE_CONT.  Note that
+		 * other traps may happen before the scheduled INTERRUPT.
+		 */
+		spin_lock(&child->sighand->siglock);
+		child->jobctl |= JOBCTL_TRAP_INTERRUPT;
+		signal_wake_up(child, 0);
+		spin_unlock(&child->sighand->siglock);
+		ret = 0;
+		break;
+
 	case PTRACE_DETACH:	 /* detach a process that was attached. */
 		ret = ptrace_detach(child, data);
 		break;
@@ -818,7 +835,8 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
 		goto out_put_task_struct;
 	}
 
-	ret = ptrace_check_attach(child, request == PTRACE_KILL);
+	ret = ptrace_check_attach(child, request == PTRACE_KILL ||
+				  request == PTRACE_INTERRUPT);
 	if (ret < 0)
 		goto out_put_task_struct;
 
@@ -960,7 +978,8 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 		goto out_put_task_struct;
 	}
 
-	ret = ptrace_check_attach(child, request == PTRACE_KILL);
+	ret = ptrace_check_attach(child, request == PTRACE_KILL ||
+				  request == PTRACE_INTERRUPT);
 	if (!ret)
 		ret = compat_arch_ptrace(child, request, addr, data);
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 9249230..7add912 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1711,6 +1711,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	__releases(&current->sighand->siglock)
 	__acquires(&current->sighand->siglock)
 {
+	bool is_intr = exit_code == (SIGTRAP | (PTRACE_EVENT_INTERRUPT << 8));
 	bool gstop_done = false;
 
 	if (arch_ptrace_stop_needed(exit_code, info)) {
@@ -1760,6 +1761,9 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	task_clear_jobctl_trapping(current);
 	current->jobctl &= ~JOBCTL_TRAP_SEIZE;
 
+	if (is_intr)
+		current->jobctl &= ~JOBCTL_TRAP_INTERRUPT;
+
 	spin_unlock_irq(&current->sighand->siglock);
 	read_lock(&tasklist_lock);
 	if (may_ptrace_stop()) {
-- 
1.7.1

