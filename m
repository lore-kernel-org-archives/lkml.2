Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0LFQ7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:59:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:59732 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab0LFQ6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:58:44 -0500
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/16] ptrace: clean transitions between TASK_STOPPED and TRACED
Date: Mon,  6 Dec 2010 17:56:58 +0100
Message-Id: <1291654624-6230-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291654624-6230-1-git-send-email-tj@kernel.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 16:57:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if the task is STOPPED on ptrace attach, it's left alone
and the state is silently changed to TRACED on the next ptrace call.
The behavior breaks the assumption that arch_ptrace_stop() is called
before any task is poked by ptrace and is ugly in that a task
manipulates the state of another task directly.

With GROUP_STOP_PENDING, the transitions between TASK_STOPPED and
TRACED can be made clean.  The tracer can use the flag to tell the
tracee to retry stop on attach and detach.  On retry, the tracee will
enter the desired state in the correct way.  The lower 16bits of
task->group_stop is used to remember the signal number which caused
the last group stop.  This is used while retrying for ptrace attach as
the original group_exit_code could have been consumed with wait(2) by
then.

As the real parent may wait(2) and consume the group_exit_code
anytime, the group_exit_code needs to be saved separately so that it
can be used when switching from regular sleep to ptrace_stop().  This
is recorded in the lower 16bits of task->group_stop.

If a task is already stopped and there's no intervening SIGCONT, a
ptrace request immediately following a successful PTRACE_ATTACH should
always succeed even if the tracer doesn't wait(2) for attach
completion; however, with this change, the tracee might still be
TASK_RUNNING trying to enter TASK_TRACED which would cause the
following request to fail with -ESRCH.

This intermediate state is hidden from userland by setting
GROUP_STOP_TRAPPING on attach and making ptrace_check_attach() wait
for it to clear.  Completing the transition or any event which clears
the group stop states of the task clears the bit and wakes up the
ptracer if waiting.

Oleg:

* Spotted a race condition where a task may retry group stop without
  proper bookkeeping.  Fixed by redoing bookkeeping on retry.

* Pointed out the userland visible intermediate state.  Fixed with
  GROUP_STOP_TRAPPING.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
---
 include/linux/sched.h |    2 +
 kernel/ptrace.c       |   63 ++++++++++++++++++++++++++++++++++++++++++------
 kernel/signal.c       |   62 ++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 112 insertions(+), 15 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c2538dd..7045c34 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1760,8 +1760,10 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 /*
  * task->group_stop flags
  */
+#define GROUP_STOP_SIGMASK	0xffff    /* signr of the last group stop */
 #define GROUP_STOP_PENDING	(1 << 16) /* task should stop for group stop */
 #define GROUP_STOP_CONSUME	(1 << 17) /* consume group stop count */
+#define GROUP_STOP_TRAPPING	(1 << 18) /* switching from STOPPED to TRACED */
 
 extern void task_clear_group_stop(struct task_struct *task);
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 99bbaa3..5191301 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -49,14 +49,14 @@ static void ptrace_untrace(struct task_struct *child)
 	spin_lock(&child->sighand->siglock);
 	if (task_is_traced(child)) {
 		/*
-		 * If the group stop is completed or in progress,
-		 * this thread was already counted as stopped.
+		 * If group stop is completed or in progress, it should
+		 * participate in the group stop.  Set GROUP_STOP_PENDING
+		 * before kicking it.
 		 */
 		if (child->signal->flags & SIGNAL_STOP_STOPPED ||
 		    child->signal->group_stop_count)
-			__set_task_state(child, TASK_STOPPED);
-		else
-			signal_wake_up(child, 1);
+			child->group_stop |= GROUP_STOP_PENDING;
+		signal_wake_up(child, 1);
 	}
 	spin_unlock(&child->sighand->siglock);
 }
@@ -79,6 +79,12 @@ void __ptrace_unlink(struct task_struct *child)
 		ptrace_untrace(child);
 }
 
+static int ptrace_wait_trap(void *flags)
+{
+	schedule();
+	return 0;
+}
+
 /*
  * Check that we have indeed attached to the thing..
  */
@@ -93,6 +99,7 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 	 * we are sure that this is our traced child and that can only
 	 * be changed by us so it's not changing right after this.
 	 */
+relock:
 	read_lock(&tasklist_lock);
 	if ((child->ptrace & PT_PTRACED) && child->parent == current) {
 		ret = 0;
@@ -101,10 +108,30 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 		 * does ptrace_unlink() before __exit_signal().
 		 */
 		spin_lock_irq(&child->sighand->siglock);
-		if (task_is_stopped(child))
-			child->state = TASK_TRACED;
-		else if (!task_is_traced(child) && !kill)
+		if (!task_is_traced(child) && !kill) {
+			/*
+			 * If GROUP_STOP_TRAPPING is set, it is known that
+			 * the tracee will enter either TRACED or the bit
+			 * will be cleared in definite amount of (userland)
+			 * time.  Wait while the bit is set.
+			 *
+			 * This hides PTRACE_ATTACH initiated transition
+			 * from STOPPED to TRACED from userland.
+			 */
+			if (child->group_stop & GROUP_STOP_TRAPPING) {
+				const int bit = ilog2(GROUP_STOP_TRAPPING);
+				DEFINE_WAIT_BIT(wait, &child->group_stop, bit);
+
+				spin_unlock_irq(&child->sighand->siglock);
+				read_unlock(&tasklist_lock);
+
+				wait_on_bit(&child->group_stop, bit,
+					    ptrace_wait_trap,
+					    TASK_UNINTERRUPTIBLE);
+				goto relock;
+			}
 			ret = -ESRCH;
+		}
 		spin_unlock_irq(&child->sighand->siglock);
 	}
 	read_unlock(&tasklist_lock);
@@ -204,6 +231,26 @@ int ptrace_attach(struct task_struct *task)
 	__ptrace_link(task, current);
 	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
 
+	spin_lock(&task->sighand->siglock);
+
+	/*
+	 * If the task is already STOPPED, set GROUP_STOP_PENDING and
+	 * TRAPPING, and kick it so that it transits to TRACED.  TRAPPING
+	 * will be cleared if the child completes the transition or any
+	 * event which clears the group stop states happens.  The bit is
+	 * waited by ptrace_check_attach() to hide the transition from
+	 * userland.
+	 *
+	 * The following is safe as both transitions in and out of STOPPED
+	 * are protected by siglock.
+	 */
+	if (task_is_stopped(task)) {
+		task->group_stop |= GROUP_STOP_PENDING | GROUP_STOP_TRAPPING;
+		signal_wake_up(task, 1);
+	}
+
+	spin_unlock(&task->sighand->siglock);
+
 	retval = 0;
 unlock_tasklist:
 	write_unlock_irq(&tasklist_lock);
diff --git a/kernel/signal.c b/kernel/signal.c
index a6bc4cf..6d93a3f 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -224,10 +224,29 @@ static inline void print_dropped_signal(int sig)
 }
 
 /**
+ * task_clear_group_stop_trapping - clear group stop trapping bit
+ * @task: target task
+ *
+ * If GROUP_STOP_TRAPPING is set, it's cleared and wake_up_bit() is called
+ * on the bit.
+ *
+ * CONTEXT:
+ * Must be called with @task->sighand->siglock held.
+ */
+static void task_clear_group_stop_trapping(struct task_struct *task)
+{
+	if (unlikely(task->group_stop & GROUP_STOP_TRAPPING)) {
+		task->group_stop &= ~GROUP_STOP_TRAPPING;
+		wake_up_bit(&task->group_stop, ilog2(GROUP_STOP_TRAPPING));
+	}
+}
+
+/**
  * task_clear_group_stop - clear pending group stop
  * @task: target task
  *
- * Clear group stop states for @task.
+ * Clear group stop pending state for @task.  All group stop states except
+ * for the recorded last stop signal are cleared.
  *
  * CONTEXT:
  * Must be called with @task->sighand->siglock held.
@@ -235,6 +254,7 @@ static inline void print_dropped_signal(int sig)
 void task_clear_group_stop(struct task_struct *task)
 {
 	task->group_stop &= ~(GROUP_STOP_PENDING | GROUP_STOP_CONSUME);
+	task_clear_group_stop_trapping(task);
 }
 
 /**
@@ -1696,6 +1716,14 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	}
 
 	/*
+	 * We're committing to trapping.  Clearing GROUP_STOP_TRAPPING and
+	 * transition to TASK_TRACED should be atomic with respect to
+	 * siglock.  Do it after the arch hook as siglock is released and
+	 * regrabbed across it.
+	 */
+	task_clear_group_stop_trapping(current);
+
+	/*
 	 * If @why is CLD_STOPPED, we're trapping to participate in a group
 	 * stop.  Do the bookkeeping.  Note that if SIGCONT was delievered
 	 * while siglock was released for the arch hook, PENDING could be
@@ -1790,6 +1818,9 @@ static int do_signal_stop(int signr)
 		unsigned int gstop = GROUP_STOP_PENDING | GROUP_STOP_CONSUME;
 		struct task_struct *t;
 
+		/* signr will be recorded in task->group_stop for retries */
+		WARN_ON_ONCE(signr & ~GROUP_STOP_SIGMASK);
+
 		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
 		    unlikely(signal_group_exit(sig)))
 			return 0;
@@ -1799,22 +1830,28 @@ static int do_signal_stop(int signr)
 		 */
 		sig->group_exit_code = signr;
 
-		current->group_stop = gstop;
+		current->group_stop &= ~GROUP_STOP_SIGMASK;
+		current->group_stop |= signr | gstop;
 		sig->group_stop_count = 1;
-		for (t = next_thread(current); t != current; t = next_thread(t))
+		for (t = next_thread(current); t != current;
+		     t = next_thread(t)) {
+			t->group_stop &= ~GROUP_STOP_SIGMASK;
 			/*
 			 * Setting state to TASK_STOPPED for a group
 			 * stop is always done with the siglock held,
 			 * so this check has no races.
 			 */
 			if (!(t->flags & PF_EXITING) && !task_is_stopped(t)) {
-				t->group_stop = gstop;
+				t->group_stop |= signr | gstop;
 				sig->group_stop_count++;
 				signal_wake_up(t, 0);
-			} else
+			} else {
 				task_clear_group_stop(t);
+				t->group_stop |= signr;
+			}
+		}
 	}
-
+retry:
 	current->exit_code = sig->group_exit_code;
 	__set_current_state(TASK_STOPPED);
 
@@ -1842,7 +1879,18 @@ static int do_signal_stop(int signr)
 
 		spin_lock_irq(&current->sighand->siglock);
 	} else
-		ptrace_stop(current->exit_code, CLD_STOPPED, 0, NULL);
+		ptrace_stop(current->group_stop & GROUP_STOP_SIGMASK,
+			    CLD_STOPPED, 0, NULL);
+
+	/*
+	 * GROUP_STOP_PENDING could be set if another group stop has
+	 * started since being woken up or ptrace wants us to transit
+	 * between TASK_STOPPED and TRACED.  Retry group stop.
+	 */
+	if (current->group_stop & GROUP_STOP_PENDING) {
+		WARN_ON_ONCE(!(current->group_stop & GROUP_STOP_SIGMASK));
+		goto retry;
+	}
 
 	spin_unlock_irq(&current->sighand->siglock);
 
-- 
1.7.1

