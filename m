Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1EHPt3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:49:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab1EHPtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:49:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=jNWOSpmoqKwxBE/LohHtvbzNJwms44B1Gc6LNTWiCKprwkYohWAOjlBIW02uxYN4pc
         cX68TCxL9QpYxKjD/wr4JZTLiwdYgxL9uYDAyhaAsKFp3tuMxNUsYQu7TJ4pU8z6IAfg
         uCIBUdhi0UP6ShnXn/BTjtS76QSxBp/kxyWEc=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/11] ptrace: implement PTRACE_SEIZE
Date: Sun,  8 May 2011 17:48:56 +0200
Message-Id: <1304869745-1073-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304869745-1073-1-git-send-email-tj@kernel.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
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
fixed.  If other trap conditions exist (signal delivery or group
stop), they might be taken; otherwise, a trap with exit_code SIGTRAP |
(PTRACE_EVENT_INTERRUPT << 8) is taken.  The followings are
guaranteed.

* A trap will happen in finite amount of userland time.

* The trap can be PTRACE_EVENT_INTERRUPT which doesn't have any side
  effect.  If a different trap is taken, no INTERRUPT trap is pending.

IOW, no matter what, one trap will happen, which might be INTERRUPT.

INTERRUPT trapping is implemented by adding a new trap site in
get_signal_to_deliver() before the actual signal dispatch which is
activated by any flag in JOBCTL_TRAP_MASK.  It currently includes only
JOBCTL_TRAP_SEIZE which is cleared whenever ptrace_stop() commits to
trapping.

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
 include/linux/sched.h  |    4 ++++
 kernel/ptrace.c        |   45 +++++++++++++++++++++++++++++++++++++++------
 kernel/signal.c        |   32 +++++++++++++++++++++++++-------
 4 files changed, 75 insertions(+), 13 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index a1147e5..705a47b 100644
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
+#define PTRACE_EVENT_INTERRUPT	7
 
 #include <asm/ptrace.h>
 
@@ -77,6 +83,7 @@
  * flags.  When the a task is stopped the ptracer owns task->ptrace.
  */
 
+#define PT_SEIZED	0x00010000	/* SEIZE used, enable new behavior */
 #define PT_PTRACED	0x00000001
 #define PT_DTRACE	0x00000002	/* delayed trace (used on m68k, i386) */
 #define PT_TRACESYSGOOD	0x00000004
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1197573..2f383eb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1784,8 +1784,12 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define JOBCTL_STOP_DEQUEUED	(1 << 16) /* stop signal dequeued */
 #define JOBCTL_STOP_PENDING	(1 << 17) /* task should stop for group stop */
 #define JOBCTL_STOP_CONSUME	(1 << 18) /* consume group stop count */
+#define JOBCTL_TRAP_SEIZE	(1 << 19) /* trap for seize */
 #define JOBCTL_TRAPPING		(1 << 22) /* switching to TRACED */
 
+#define JOBCTL_TRAP_MASK	JOBCTL_TRAP_SEIZE
+#define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK)
+
 extern void task_clear_jobctl_stop_pending(struct task_struct *task);
 
 #ifdef CONFIG_PREEMPT_RCU
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 3c56f54..d1e3740 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -75,6 +75,9 @@ void __ptrace_unlink(struct task_struct *child)
 
 	spin_lock(&child->sighand->siglock);
 
+	/* clear pending jobctl traps */
+	child->jobctl &= ~JOBCTL_TRAP_MASK;
+
 	/*
 	 * Reinstate JOBCTL_STOP_PENDING if group stop is in effect and
 	 * @child isn't dead.  This will trigger TRACED -> RUNNING ->
@@ -184,10 +187,28 @@ bool ptrace_may_access(struct task_struct *task, unsigned int mode)
 	return !err;
 }
 
-static int ptrace_attach(struct task_struct *task)
+static int ptrace_attach(struct task_struct *task, long request,
+			 unsigned long flags)
 {
+	bool seize = request == PTRACE_SEIZE;
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
@@ -219,11 +240,15 @@ static int ptrace_attach(struct task_struct *task)
 		goto unlock_tasklist;
 
 	task->ptrace = PT_PTRACED;
+	if (seize)
+		task->ptrace |= PT_SEIZED;
 	if (task_ns_capable(task, CAP_SYS_PTRACE))
 		task->ptrace |= PT_PTRACE_CAP;
 
 	__ptrace_link(task, current);
-	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
+
+	if (!seize)
+		send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
 
 	spin_lock(&task->sighand->siglock);
 
@@ -247,6 +272,14 @@ static int ptrace_attach(struct task_struct *task)
 	if (task_is_stopped(task)) {
 		task->jobctl |= JOBCTL_STOP_PENDING | JOBCTL_TRAPPING;
 		signal_wake_up(task, 1);
+	} else if (seize) {
+		/*
+		 * Otherwise, SEIZE uses jobctl trap to put tracee into
+		 * TASK_TRACED, which doesn't have the nasty side effects
+		 * of sending SIGSTOP.
+		 */
+		task->jobctl |= JOBCTL_TRAP_SEIZE;
+		signal_wake_up(task, 0);
 	}
 
 	spin_unlock(&task->sighand->siglock);
@@ -760,8 +793,8 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
 		goto out;
 	}
 
-	if (request == PTRACE_ATTACH) {
-		ret = ptrace_attach(child);
+	if (request == PTRACE_ATTACH || request == PTRACE_SEIZE) {
+		ret = ptrace_attach(child, request, data);
 		/*
 		 * Some architectures need to do book-keeping after
 		 * a ptrace attach.
@@ -902,8 +935,8 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
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
index 2b0d719..9249230 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -124,7 +124,7 @@ static inline int has_pending_signals(sigset_t *signal, sigset_t *blocked)
 
 static int recalc_sigpending_tsk(struct task_struct *t)
 {
-	if ((t->jobctl & JOBCTL_STOP_PENDING) ||
+	if ((t->jobctl & JOBCTL_PENDING_MASK) ||
 	    PENDING(&t->pending, &t->blocked) ||
 	    PENDING(&t->signal->shared_pending, &t->blocked)) {
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
@@ -1752,12 +1752,13 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	set_current_state(TASK_TRACED);
 
 	/*
-	 * We're committing to trapping.  Clearing JOBCTL_TRAPPING and
-	 * transition to TASK_TRACED should be atomic with respect to
-	 * siglock.  This should be done after the arch hook as siglock is
-	 * released and regrabbed across it.
+	 * We're committing to trapping.  Adjust ->jobctl.  Updates to
+	 * these flags and transition to TASK_TRACED should be atomic with
+	 * respect to siglock.  This should be done after the arch hook as
+	 * siglock may be released and regrabbed across it.
 	 */
 	task_clear_jobctl_trapping(current);
+	current->jobctl &= ~JOBCTL_TRAP_SEIZE;
 
 	spin_unlock_irq(&current->sighand->siglock);
 	read_lock(&tasklist_lock);
@@ -1829,7 +1830,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	recalc_sigpending_tsk(current);
 }
 
-void ptrace_notify(int exit_code)
+static void ptrace_notify_locked(int exit_code)
 {
 	siginfo_t info;
 
@@ -1842,8 +1843,13 @@ void ptrace_notify(int exit_code)
 	info.si_uid = current_uid();
 
 	/* Let the debugger run.  */
-	spin_lock_irq(&current->sighand->siglock);
 	ptrace_stop(exit_code, CLD_TRAPPED, 1, &info);
+}
+
+void ptrace_notify(int exit_code)
+{
+	spin_lock_irq(&current->sighand->siglock);
+	ptrace_notify_locked(exit_code);
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
@@ -2068,6 +2074,18 @@ relock:
 
 	for (;;) {
 		struct k_sigaction *ka;
+
+		/*
+		 * Check for ptrace trap conditions.  Jobctl traps are used
+		 * to trap ptracee while staying transparent regarding
+		 * signal and job control.
+		 */
+		if (unlikely(current->jobctl & JOBCTL_TRAP_MASK)) {
+			ptrace_notify_locked(SIGTRAP |
+					     (PTRACE_EVENT_INTERRUPT << 8));
+			continue;
+		}
+
 		/*
 		 * Tracing can induce an artifical signal and choose sigaction.
 		 * The return value in @signr determines the default action,
-- 
1.7.1

