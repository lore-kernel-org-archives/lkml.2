Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab1EPSRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:17:53 -0400
Received: from mail-bw0-f52.google.com ([209.85.214.52]:37249 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab1EPSRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:17:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Dxe+s6ROWYSir90T8G1WC4M7GK2MrfV5SvL6xz6LD/dWj1iKqjZDATq4pWTuxsq7Zm
         MFY64ycmxIMvwgpeF3HoOKsenHriWF4UeIwqmaveA626CP5ztcpbHSzeDBrbZ+kXASHY
         ulrgk0EiFf/eAfEo+kbVevYl0h0EqwLB0ZUys=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/10] ptrace: implement group stop notification for ptracer
Date: Mon, 16 May 2011 20:17:29 +0200
Message-Id: <1305569849-10448-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1305569849-10448-1-git-send-email-tj@kernel.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there's no way for ptracer to find out whether group stop
that tracee was in finished other than polling with PTRACE_GETSIGINFO.
Also, tracer can't detect new group stop started by an untraced thread
if tracee is already trapped.  This patch implements group stop
notification for ptracer using STOP traps.

When group stop state of a seized tracee changes, JOBCTL_TRAP_NOTIFY
is set, which triggers STOP trap but is sticky until the next
PTRACE_GETSIGINFO.  As GETSIGINFO exports the current group stop
state, this guarantees that tracer checks the current group stop state
at least once after group stop state change.  Stickiness is necessary
because notification trap may race with PTRACE_CONT for other traps
and get lost.

Note that simply scheduling such trap isn't enough.  If tracee is
running (PTRACE_CONT'd from group stop trap), the usual trapping -
setting NOTIFY followed by the usual signal_wake_up() - is enough;
however, if tracee is trapped, the scheduled trap won't happen until
the trap is continued.

This is solved by re-trapping if tracee is in STOP trap.  Along with
JOBCTL_TRAP_NOTIFY, JOBCTL_TRAPPING is set and tracee is woken up from
TASK_TRACED.  Tracee then (re-)enters INTERRUPT trap generating
notification for tracer.  TRAPPING hides the TRACED -> RUNNING ->
TRACED transition from tracer.

Many ptrace requests expect tracee to remain trapped until they
finish.  Such conditions are marked with JOBCTL_BLOCK_NOTIFY and if
notification happens while BLOCK_NOTIFY is set, JOBCTL_TRAPPING is set
but the actual wake up and re-trapping takes place when the ptrace
request finishes.  This is safe as the only task which can wait for
TRAPPING is the ptracer.

Re-trapping is used only for STOP trap.  If tracer wants to get
notified about group stop, it either leaves tracee in the initial STOP
trap or puts it into STOP trap using PTRACE_INTERRUPT.  If STOP trap
is scheduled while tracee is already in a trap, it's guaranteed that
tracee will enter a trap without returning to userland, so tracer
doesn't lose any control over tracee execution for group stop
notification.

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

		  ptrace(PTRACE_GETSIGINFO, tracee, NULL, &si);
		  if (!si.si_code) {
			  printf("tracer: SIG %d\n", si.si_signo);
			  ptrace(PTRACE_CONT, tracee, NULL,
				 (void *)(unsigned long)si.si_signo);
			  goto repeat;
		  }
		  stopped = !!si.si_status;

		  if (stopped != last_stopped)
			  printf("tracer: stopped=%d signo=%d\n",
				 stopped, si.si_signo);
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
  tracer: stopped=1 signo=19
  mother: SIGCONT
  tracer: stopped=0 signo=5
  tracer: SIG 18
  mother: SIGSTOP
  tracer: SIG 19
  tracer: stopped=1 signo=19
  mother: SIGCONT
  tracer: stopped=0 signo=5
  tracer: SIG 18
  mother: SIGSTOP
  tracer: SIG 19
  tracer: stopped=1 signo=19
  mother: SIGCONT
  tracer: stopped=0 signo=5
  tracer: SIG 18

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/sched.h |    3 +-
 kernel/ptrace.c       |   11 +++++++-
 kernel/signal.c       |   68 ++++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 76 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1f082d9..5573930 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1785,10 +1785,11 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define JOBCTL_STOP_PENDING	(1 << 17) /* task should stop for group stop */
 #define JOBCTL_STOP_CONSUME	(1 << 18) /* consume group stop count */
 #define JOBCTL_TRAP_STOP	(1 << 19) /* trap for STOP */
+#define JOBCTL_TRAP_NOTIFY	(1 << 20) /* sticky trap for notifications */
 #define JOBCTL_TRAPPING		(1 << 21) /* switching to TRACED */
 #define JOBCTL_BLOCK_NOTIFY	(1 << 22) /* block NOTIFY re-traps */
 
-#define JOBCTL_TRAP_MASK	JOBCTL_TRAP_STOP
+#define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY)
 #define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK)
 
 extern void task_clear_jobctl_pending(struct task_struct *task,
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index d382f81..2640761 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -130,6 +130,7 @@ void __ptrace_unlink(struct task_struct *child)
 	 * Clear jobctl bits owned by this tracer along with STOP_PENDING,
 	 * which is reinstated below if necessary.
 	 */
+	child->jobctl &= ~JOBCTL_BLOCK_NOTIFY;
 	task_clear_jobctl_pending(child, JOBCTL_PENDING_MASK);
 
 	/*
@@ -617,6 +618,9 @@ static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
 			info->si_signo = child->jobctl & JOBCTL_STOP_SIGMASK;
 			WARN_ON_ONCE(!info->si_signo);
 		}
+
+		/* tracer got siginfo, clear the sticky trap */
+		child->jobctl &= ~JOBCTL_TRAP_NOTIFY;
 	}
 out_unlock:
 	unlock_task_sighand(child, &flags);
@@ -923,9 +927,14 @@ static void ptrace_put_task_struct(struct task_struct *child)
 
 	/*
 	 * Make sure @chlid is still ptraced by us and clear BLOCK_NOTIFY.
+	 * If TRAPPING is set, it means NOTIFY occurred in-between and
+	 * re-trap was blocked.  Trigger re-trap.
 	 */
-	if (likely((child->ptrace & PT_PTRACED) && child->parent == current))
+	if (likely((child->ptrace & PT_PTRACED) && child->parent == current)) {
 		child->jobctl &= ~JOBCTL_BLOCK_NOTIFY;
+		if (child->jobctl & JOBCTL_TRAPPING)
+			signal_wake_up(child, task_is_traced(child));
+	}
 
 	unlock_task_sighand(child, &flags);
 out_put:
diff --git a/kernel/signal.c b/kernel/signal.c
index c05f4d1..b794363 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -784,6 +784,60 @@ static int check_kill_permission(int sig, struct siginfo *info,
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
+ * If @t is running, STOP trap will be taken.  If already trapped for STOP,
+ * it will re-trap.  If trapped for other traps, STOP trap will be
+ * eventually taken without returning to userland after the existing traps
+ * are finished by PTRACE_CONT.
+ *
+ * CONTEXT:
+ * Must be called with @task->sighand->siglock held.
+ */
+static void ptrace_trap_notify(struct task_struct *t)
+{
+	siginfo_t *si = t->last_siginfo;
+
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
+	 * If @t is currently trapped for STOP, it should re-trap with new
+	 * exit_code indicating continuation so that the ptracer can notice
+	 * the event; otherwise, use normal signal delivery wake up.
+	 *
+	 * The re-trapping sets JOBCTL_TRAPPING such that the transition is
+	 * hidden from the ptracer.
+	 *
+	 * This means that if @t is trapped for other reasons than STOP,
+	 * the notification trap won't be delievered until the current one
+	 * is complete.  This is the intended behavior.
+	 *
+	 * Note that if JOBCTL_BLOCK_NOTIFY, TRAPPING is set but actual
+	 * re-trap doesn't happen.  This is used to avoid waking up while
+	 * ptrace request is in progress.  The ptracer will notice TRAPPING
+	 * is set on request completion and trigger re-trap.
+	 */
+	if (task_is_traced(t) && si && si->si_code == PTRACE_STOP_SI_CODE) {
+		t->jobctl |= JOBCTL_TRAPPING;
+		if (!(t->jobctl & JOBCTL_BLOCK_NOTIFY))
+			signal_wake_up(t, true);
+	} else
+		signal_wake_up(t, false);
+}
+
 /*
  * Handle magic process-wide effects of stop/continue signals. Unlike
  * the signal actions, these happen immediately at signal-generation
@@ -822,7 +876,10 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 		do {
 			task_clear_jobctl_pending(t, JOBCTL_STOP_PENDING);
 			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
-			wake_up_state(t, __TASK_STOPPED);
+			if (likely(!(t->ptrace & PT_SEIZED)))
+				wake_up_state(t, __TASK_STOPPED);
+			else
+				ptrace_trap_notify(t);
 		} while_each_thread(p, t);
 
 		/*
@@ -1938,7 +1995,10 @@ static bool do_signal_stop(int signr)
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
@@ -1976,10 +2036,10 @@ static bool do_signal_stop(int signr)
 		schedule();
 	} else {
 		/*
-		 * While ptraced, group stop is handled by STOP trap.
+		 * While ptraced, group stop is handled by NOTIFY trap.
 		 * Schedule it and let the caller deal with it.
 		 */
-		current->jobctl |= JOBCTL_TRAP_STOP;
+		current->jobctl |= JOBCTL_TRAP_NOTIFY;
 		spin_unlock_irq(&current->sighand->siglock);
 	}
 
-- 
1.7.1

