Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0KZKuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:50:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:42294 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab0KZKuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:50:05 -0500
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/14] ptrace: clean transitions between TASK_STOPPED and TRACED
Date: Fri, 26 Nov 2010 11:49:24 +0100
Message-Id: <1290768569-16224-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290768569-16224-1-git-send-email-tj@kernel.org>
References: <1290768569-16224-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 10:49:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if the task is STOPPED on ptrace attach, it's left alone
and the state is silently changed to TRACED on the next ptrace call.
The behavior breaks the assumption that arch_ptrace_stop() is called
before any task is poked by ptrace operations and is ugly in that a
task manipulates the state of another task directly.

With GROUP_STOP_PENDING, the transitions between TASK_STOPPED and
TRACED can be made clean.  The tracer can use the flag to tell the
tracee to retry stop on attach and detach.  On retry, the tracee will
enter the desired state the correct way.  The lower 16bits of
task->group_stop is used to remember the signal number which caused
the last group stop.  This is used while retrying for ptrace attach as
the original group_exit_code could have been consumed with wait(2) by
then.

As the real parent may wait(2) and consume the group_exit_code
anytime, the group_exit_code needs to be saved separately so that it
can be used when switching from regular sleep to ptrace_stop().  This
is recorded in the lower 16bits of task->group_stop.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 include/linux/sched.h |    1 +
 kernel/ptrace.c       |   27 +++++++++++++++++++--------
 kernel/signal.c       |   23 +++++++++++++++++------
 3 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1261993..e78b1e5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1760,6 +1760,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 /*
  * task->group_stop flags
  */
+#define GROUP_STOP_SIGMASK	0xffff    /* signr of the last group stop */
 #define GROUP_STOP_PENDING	(1 << 16) /* task should stop for group stop */
 #define GROUP_STOP_CONSUME	(1 << 17) /* consume group stop count */
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 99bbaa3..08b18f2 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -49,14 +49,14 @@ static void ptrace_untrace(struct task_struct *child)
 	spin_lock(&child->sighand->siglock);
 	if (task_is_traced(child)) {
 		/*
-		 * If the group stop is completed or in progress,
-		 * this thread was already counted as stopped.
+		 * If group stop is completed or in progress, the task
+		 * should enter group stop.  Set GROUP_STOP_PENDING
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
@@ -101,9 +101,7 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 		 * does ptrace_unlink() before __exit_signal().
 		 */
 		spin_lock_irq(&child->sighand->siglock);
-		if (task_is_stopped(child))
-			child->state = TASK_TRACED;
-		else if (!task_is_traced(child) && !kill)
+		if (!task_is_traced(child) && !kill)
 			ret = -ESRCH;
 		spin_unlock_irq(&child->sighand->siglock);
 	}
@@ -204,6 +202,19 @@ int ptrace_attach(struct task_struct *task)
 	__ptrace_link(task, current);
 	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
 
+	/*
+	 * If the task is already STOPPED, set GROUP_STOP_PENDING and
+	 * kick it so that it transits to TRACED.  This is safe as
+	 * both transitions in and out of STOPPED are protected by
+	 * siglock.
+	 */
+	spin_lock(&task->sighand->siglock);
+	if (task_is_stopped(task)) {
+		task->group_stop |= GROUP_STOP_PENDING;
+		signal_wake_up(task, 1);
+	}
+	spin_unlock(&task->sighand->siglock);
+
 	retval = 0;
 unlock_tasklist:
 	write_unlock_irq(&tasklist_lock);
diff --git a/kernel/signal.c b/kernel/signal.c
index 6d78da6..8341667 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -733,7 +733,8 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 		do {
 			unsigned int state;
 
-			t->group_stop = 0;
+			/* clear all group_stop flags, only keep the signr */
+			t->group_stop &= GROUP_STOP_SIGMASK;
 
 			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
 			/*
@@ -1749,6 +1750,9 @@ static int do_signal_stop(int signr)
 		unsigned int gstop = GROUP_STOP_PENDING | GROUP_STOP_CONSUME;
 		struct task_struct *t;
 
+		/* signr will be recorded in task->group_stop for retries */
+		WARN_ON_ONCE(signr & ~GROUP_STOP_SIGMASK);
+
 		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
 		    unlikely(signal_group_exit(sig)))
 			return 0;
@@ -1758,7 +1762,7 @@ static int do_signal_stop(int signr)
 		 */
 		sig->group_exit_code = signr;
 
-		current->group_stop = gstop;
+		current->group_stop = signr | gstop;
 		sig->group_stop_count = 1;
 		for (t = next_thread(current); t != current; t = next_thread(t))
 			/*
@@ -1768,11 +1772,11 @@ static int do_signal_stop(int signr)
 			 */
 			if (!(t->flags & PF_EXITING) &&
 			    !task_is_stopped_or_traced(t)) {
-				t->group_stop = gstop;
+				t->group_stop = signr | gstop;
 				sig->group_stop_count++;
 				signal_wake_up(t, 0);
 			} else
-				t->group_stop = 0;
+				t->group_stop = signr;
 	}
 	/*
 	 * If there are no other threads in the group, or if there is
@@ -1793,7 +1797,7 @@ static int do_signal_stop(int signr)
 
 	if (consume_group_stop())
 		sig->flags = SIGNAL_STOP_STOPPED;
-
+retry:
 	current->exit_code = sig->group_exit_code;
 	current->group_stop &= ~GROUP_STOP_PENDING;
 	__set_current_state(TASK_STOPPED);
@@ -1805,6 +1809,7 @@ static int do_signal_stop(int signr)
 			read_lock(&tasklist_lock);
 			do_notify_parent_cldstop(current, notify);
 			read_unlock(&tasklist_lock);
+			notify = 0;
 		}
 
 		/* Now we don't run again until woken by SIGCONT or SIGKILL */
@@ -1812,7 +1817,13 @@ static int do_signal_stop(int signr)
 
 		spin_lock_irq(&current->sighand->siglock);
 	} else
-		ptrace_stop(current->exit_code, CLD_STOPPED, 0, NULL);
+		ptrace_stop(current->group_stop & GROUP_STOP_SIGMASK,
+			    CLD_STOPPED, 0, NULL);
+
+	if (current->group_stop & GROUP_STOP_PENDING) {
+		WARN_ON_ONCE(!(current->group_stop & GROUP_STOP_SIGMASK));
+		goto retry;
+	}
 out_unlock:
 	spin_unlock_irq(&current->sighand->siglock);
 
-- 
1.7.1

