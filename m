Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab1EHPt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:49:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab1EHPtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:49:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=AVqOCYbcYo/f+tFOFV8bfE4DYf3un0JhGYL3Z1fXdx4/Yg5gxC+TGaqF+qpZKoq4nx
         /ab4NQFBP9eXQhLfKy2JKfy1S41jIAYU0Rma89N74qgXQE4RqW9jGJWODtAppmQO29ZY
         4G6u1IKqA7JEJs/XsJ5rjSWQc91ueUDURBbu8=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/11] ptrace: implement group stop notification for ptracer
Date: Sun,  8 May 2011 17:49:05 +0200
Message-Id: <1304869745-1073-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304869745-1073-1-git-send-email-tj@kernel.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there's no way for ptracer to find out whether group stop
that tracee was in finished other than polling with PTRACE_GETSIGINFO.
Also, tracer can't detect new group stop started by an untraced thread
if tracee is already trapped.  This patch implements group stop
notification for ptracer using INTERRUPT traps.

When group stop state of a seized tracee changes, JOBCTL_TRAP_NOTIFY
is set, which triggers INTERRUPT trap but is sticky until the next
PTRACE_GETSIGINFO.  As GETSIGINFO exports the current group stop
state, this guarantees that tracer checks the current group stop state
at least once after group stop state change.  Stickiness is necessary
because notification trap may race with PTRACE_CONT for other traps
and get lost.

-EINVAL return from GETSIGINFO also clears the sticky trap.  This is
because -EINVAL clearly indicates that tracee is in group stop.  To
avoid unnecessarily taking INTERRUPT trap on the way to group stop, if
JOBCTL_STOP_PENDING is set, INTERRUPT trap is not taken.

Note that simply scheduling such trap isn't enough.  If tracee is
running (PTRACE_CONT'd from group stop trap), the usual trapping -
setting NOTIFY followed by the usual signal_wake_up() - is enough;
however, if tracee is trapped, the scheduled trap won't happen until
the trap is continued.

This is solved by re-trapping if tracee is in group stop or INTERRUPT
trap.  Along with JOBCTL_TRAP_NOTIFY, JOBCTL_TRAPPING is set and
tracee is woken up from TASK_TRACED.  Tracee then (re-)enters
INTERRUPT trap generating notification for tracer.  TRAPPING hides the
TRACED -> RUNNING -> TRACED transition from tracer.

Re-trapping is used only for group stop and INTERRUPT traps.  If
tracer wants to get notified about group stop, it either leaves tracee
in the initial group stop trap or puts it into INTERRUPT trap.  When
INTERRUPT trap is scheduled while tracee is already in a trap, it's
guaranteed that tracee will enter INTERRUPT trap without returning to
userland, so tracer doesn't lose any control over tracee execution for
group stop notification.

This exclusion is intentional as enabling re-trapping on all traps may
make using ptrace(2) more confusing than necessary and confining
re-trapping to group stop and INTERRUPT doesn't lose any
functionality.  It also simplifies implementation.

An example program follows.

  #define PTRACE_SEIZE		0x4206
  #define PTRACE_INTERRUPT	0x4207

  #define PTRACE_SEIZE_DEVEL	0x80000000

  static const struct timespec ts1s = { .tv_sec = 1 };

  int main(int argc, char **argv)
  {
	  pid_t tracee, tracer;
	  int i;

	  tracee = fork();
	  if (!tracee)
		  while (1)
			  pause();

	  tracer = fork();
	  if (!tracer) {
		  int last_stopped = 0, stopped;
		  siginfo_t si;

		  ptrace(PTRACE_SEIZE, tracee, NULL,
			 (void *)(unsigned long)PTRACE_SEIZE_DEVEL);
	  repeat:
		  waitid(P_PID, tracee, NULL, WSTOPPED);

		  if (!ptrace(PTRACE_GETSIGINFO, tracee, NULL, &si)) {
			  if (!si.si_code) {
				  printf("tracer: SIG %d\n", si.si_signo);
				  ptrace(PTRACE_CONT, tracee, NULL,
					 (void *)(unsigned long)si.si_signo);
				  goto repeat;
			  }
			  stopped = !!si.si_status;
		  } else
			  stopped = 1;

		  if (stopped != last_stopped)
			  printf("tracer: stopped=%d\n", stopped);
		  last_stopped = stopped;

		  if (!stopped)
			  ptrace(PTRACE_CONT, tracee, NULL, NULL);
		  goto repeat;
	  }

	  for (i = 0; i < 3; i++) {
		  nanosleep(&ts1s, NULL);
		  printf("mother: SIGSTOP\n");
		  kill(tracee, SIGSTOP);
		  nanosleep(&ts1s, NULL);
		  printf("mother: SIGCONT\n");
		  kill(tracee, SIGCONT);
	  }
	  nanosleep(&ts1s, NULL);

	  kill(tracer, SIGKILL);
	  kill(tracee, SIGKILL);
	  return 0;
  }

In the above program, tracer gets notification of group stop state
changes and can track stopped state without polling PTRACE_GETSIGINFO.

  # ./test-gstop-notify
  mother: SIGSTOP
  tracer: SIG 19
  tracer: stopped=1
  mother: SIGCONT
  tracer: stopped=0
  tracer: SIG 18
  mother: SIGSTOP
  tracer: SIG 19
  tracer: stopped=1
  mother: SIGCONT
  tracer: stopped=0
  tracer: SIG 18
  mother: SIGSTOP
  tracer: SIG 19
  tracer: stopped=1
  mother: SIGCONT
  tracer: stopped=0
  tracer: SIG 18

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/sched.h |    4 ++-
 kernel/ptrace.c       |   13 +++++++++-
 kernel/signal.c       |   66 ++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 78 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 972f1db..e3d4e3d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1786,10 +1786,12 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define JOBCTL_STOP_CONSUME	(1 << 18) /* consume group stop count */
 #define JOBCTL_TRAP_SEIZE	(1 << 19) /* trap for seize */
 #define JOBCTL_TRAP_INTERRUPT	(1 << 20) /* trap for interrupt */
+#define JOBCTL_TRAP_NOTIFY	(1 << 21) /* sticky trap for notifications */
 #define JOBCTL_TRAPPING		(1 << 22) /* switching to TRACED/STOPPED */
 #define JOBCTL_TRAPPED		(1 << 23) /* trapped for group stop */
 
-#define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_SEIZE | JOBCTL_TRAP_INTERRUPT)
+#define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_SEIZE | JOBCTL_TRAP_INTERRUPT | \
+				 JOBCTL_TRAP_NOTIFY)
 #define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK)
 
 extern void task_clear_jobctl_stop_pending(struct task_struct *task);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 7411eb2..4e9473b 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -570,6 +570,7 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
 
 static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
 {
+	bool clear_notify = false;
 	struct signal_struct *sig;
 	unsigned long flags;
 	int error;
@@ -579,8 +580,14 @@ static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
 	sig = child->signal;
 
 	error = -EINVAL;
-	if (!child->last_siginfo)
+	if (!child->last_siginfo) {
+		/*
+		 * Clear notification trap on NULL siginfo too.  It clearly
+		 * indicates group stop trap.
+		 */
+		clear_notify = true;
 		goto out_unlock;
+	}
 
 	error = 0;
 	*info = *child->last_siginfo;
@@ -594,8 +601,12 @@ static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
 		/* report whether group stop is in effect w/ SI_STOPPED */
 		if (sig->group_stop_count || (sig->flags & SIGNAL_STOP_STOPPED))
 			info->si_pt_flags |= PTRACE_SI_STOPPED;
+		/* tracer got siginfo, clear the sticky trap */
+		clear_notify = true;
 	}
 out_unlock:
+	if (clear_notify)
+		child->jobctl &= ~JOBCTL_TRAP_NOTIFY;
 	unlock_task_sighand(child, &flags);
 	return error;
 }
diff --git a/kernel/signal.c b/kernel/signal.c
index dce2961..271788d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -778,6 +778,54 @@ static int check_kill_permission(int sig, struct siginfo *info,
 	return security_task_kill(t, info, sig, 0);
 }
 
+/**
+ * ptrace_trap_notify - schedule trap to notify ptracer
+ * @t: tracee wanting to notify tracer
+ *
+ * This function schedules sticky ptrace trap which is cleared on
+ * PTRACE_GETSIGINFO to notify ptracer of an event.  @t must have been
+ * seized by ptracer.
+ *
+ * If @t is running, INTERRUPT trap will be taken.  If trapped for group
+ * stop or INTERRUPT, it will re-trap into INTERRUPT.  If trapped for other
+ * traps, INTERRUPT trap will be eventually taken without returning to
+ * userland after the existing traps are finished by PTRACE_CONT.
+ *
+ * CONTEXT:
+ * Must be called with @task->sighand->siglock held.
+ */
+static void ptrace_trap_notify(struct task_struct *t)
+{
+	WARN_ON_ONCE(!(t->ptrace & PT_SEIZED));
+	assert_spin_locked(&t->sighand->siglock);
+
+	/*
+	 * @t is being ptraced and new SEIZE behavior is in effect.
+	 * Schedule sticky trap which will clear on the next GETSIGINFO.
+	 */
+	t->jobctl |= JOBCTL_TRAP_NOTIFY;
+
+	/*
+	 * If @t is currently trapped for group stop or INTERRUPT
+	 * (JOBCTL_TRAPPED set), it should re-trap with new exit_code
+	 * indicating continuation so that the ptracer can notice the
+	 * event; otherwise, use normal signal delivery wake up.
+	 *
+	 * The re-trapping sets JOBCTL_TRAPPING such that the transition is
+	 * hidden from the ptracer.
+	 *
+	 * This means that if @t is trapped for other reasons than group
+	 * stop or INTERRUPT, the notification trap won't be delievered
+	 * until the current one is complete.  This is the intended
+	 * behavior.
+	 */
+	if (task_is_traced(t) && (t->jobctl & JOBCTL_TRAPPED)) {
+		t->jobctl |= JOBCTL_TRAPPING;
+		signal_wake_up(t, true);
+	} else
+		signal_wake_up(t, false);
+}
+
 /*
  * Handle magic process-wide effects of stop/continue signals. Unlike
  * the signal actions, these happen immediately at signal-generation
@@ -816,7 +864,10 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 		do {
 			task_clear_jobctl_stop_pending(t);
 			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
-			wake_up_state(t, __TASK_STOPPED);
+			if (likely(!(t->ptrace & PT_SEIZED)))
+				wake_up_state(t, __TASK_STOPPED);
+			else
+				ptrace_trap_notify(t);
 		} while_each_thread(p, t);
 
 		/*
@@ -1928,7 +1979,10 @@ static int do_signal_stop(int signr)
 			if (!(t->flags & PF_EXITING) && !task_is_stopped(t)) {
 				t->jobctl |= signr | gstop;
 				sig->group_stop_count++;
-				signal_wake_up(t, 0);
+				if (likely(!(t->ptrace & PT_SEIZED)))
+					signal_wake_up(t, 0);
+				else
+					ptrace_trap_notify(t);
 			}
 		}
 	}
@@ -2093,8 +2147,14 @@ relock:
 		 * Check for ptrace trap conditions.  Jobctl traps are used
 		 * to trap ptracee while staying transparent regarding
 		 * signal and job control.
+		 *
+		 * If group stop is pending, give it priority.  INTERRUPT
+		 * is used for job control notifications and giving the
+		 * actual group stop trap higher priority gives prettier
+		 * stream of traps.
 		 */
-		if (unlikely(current->jobctl & JOBCTL_TRAP_MASK)) {
+		if (unlikely(current->jobctl & JOBCTL_TRAP_MASK) &&
+		    !(current->jobctl & JOBCTL_STOP_PENDING)) {
 			ptrace_notify_locked(SIGTRAP |
 					     (PTRACE_EVENT_INTERRUPT << 8));
 			continue;
-- 
1.7.1

