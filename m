Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab0LFQ6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:58:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:59701 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab0LFQ6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:58:15 -0500
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/16] signal: use GROUP_STOP_PENDING to stop once for a single group stop
Date: Mon,  6 Dec 2010 17:56:55 +0100
Message-Id: <1291654624-6230-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291654624-6230-1-git-send-email-tj@kernel.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 16:57:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently task->signal->group_stop_count is used to decide whether to
stop for group stop.  However, if there is a task in the group which
is taking a long time to stop, other tasks which are continued by
ptrace would repeatedly stop for the same group stop until the group
stop is complete.

Conversely, if a ptraced task is in TASK_TRACED state, the debugger
won't get notified of group stops which is inconsistent compared to
the ptraced task in any other state.

This patch introduces GROUP_STOP_PENDING which tracks whether a task
is yet to stop for the group stop in progress.  The flag is set when a
group stop starts and cleared when the task stops the first time for
the group stop, and consulted whenever whether the task should
participate in a group stop needs to be determined.  Note that now
tasks in TASK_TRACED also participate in group stop.

This results in the following behavior changes.

* For a single group stop, a ptracer would see at most one stop
  reported.

* A ptracee in TASK_TRACED now also participates in group stop and the
  tracer would get the notification.  However, as a ptraced task could
  be in TASK_STOPPED state or any ptrace trap could consume group
  stop, the notification may still be missing.  These will be
  addressed with further patches.

* A ptracee may start a group stop while one is still in progress if
  the tracer let it continue with stop signal delivery.  Group stop
  code handles this correctly.

Oleg:

* Spotted that a task might skip signal check even when its
  GROUP_STOP_PENDING is set.  Fixed by updating
  recalc_sigpending_tsk() to check GROUP_STOP_PENDING instead of
  group_stop_count.

* Pointed out that task->group_stop should be cleared whenever
  task->signal->group_stop_count is cleared.  Fixed accordingly.

* Pointed out the behavior inconsistency between TASK_TRACED and
  RUNNING and the last behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 fs/exec.c             |    1 +
 include/linux/sched.h |    3 +++
 kernel/signal.c       |   36 +++++++++++++++++++++---------------
 3 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index d68c378..8d4142c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1648,6 +1648,7 @@ static int zap_process(struct task_struct *start, int exit_code)
 
 	t = start;
 	do {
+		task_clear_group_stop(t);
 		if (t != current && t->mm) {
 			sigaddset(&t->pending.signal, SIGKILL);
 			signal_wake_up(t, 1);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 93157a4..c2538dd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1760,8 +1760,11 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 /*
  * task->group_stop flags
  */
+#define GROUP_STOP_PENDING	(1 << 16) /* task should stop for group stop */
 #define GROUP_STOP_CONSUME	(1 << 17) /* consume group stop count */
 
+extern void task_clear_group_stop(struct task_struct *task);
+
 #ifdef CONFIG_PREEMPT_RCU
 
 #define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
diff --git a/kernel/signal.c b/kernel/signal.c
index bac959e..bff46ed 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -124,7 +124,7 @@ static inline int has_pending_signals(sigset_t *signal, sigset_t *blocked)
 
 static int recalc_sigpending_tsk(struct task_struct *t)
 {
-	if (t->signal->group_stop_count > 0 ||
+	if ((t->group_stop & GROUP_STOP_PENDING) ||
 	    PENDING(&t->pending, &t->blocked) ||
 	    PENDING(&t->signal->shared_pending, &t->blocked)) {
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
@@ -232,19 +232,19 @@ static inline void print_dropped_signal(int sig)
  * CONTEXT:
  * Must be called with @task->sighand->siglock held.
  */
-static void task_clear_group_stop(struct task_struct *task)
+void task_clear_group_stop(struct task_struct *task)
 {
-	task->group_stop &= ~GROUP_STOP_CONSUME;
+	task->group_stop &= ~(GROUP_STOP_PENDING | GROUP_STOP_CONSUME);
 }
 
 /**
  * task_participate_group_stop - participate in a group stop
  * @task: task participating in a group stop
  *
- * @task is participating in a group stop.  Group stop states are cleared
- * and the group stop count is consumed if %GROUP_STOP_CONSUME was set.  If
- * the consumption completes the group stop, the appropriate %SIGNAL_*
- * flags are set.
+ * @task has GROUP_STOP_PENDING set and is participating in a group stop.
+ * Group stop states are cleared and the group stop count is consumed if
+ * %GROUP_STOP_CONSUME was set.  If the consumption completes the group
+ * stop, the appropriate %SIGNAL_* flags are set.
  *
  * CONTEXT:
  * Must be called with @task->sighand->siglock held.
@@ -254,6 +254,8 @@ static bool task_participate_group_stop(struct task_struct *task)
 	struct signal_struct *sig = task->signal;
 	bool consume = task->group_stop & GROUP_STOP_CONSUME;
 
+	WARN_ON_ONCE(!(task->group_stop & GROUP_STOP_PENDING));
+
 	task_clear_group_stop(task);
 
 	if (!consume)
@@ -767,6 +769,9 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 		t = p;
 		do {
 			unsigned int state;
+
+			task_clear_group_stop(t);
+
 			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
 			/*
 			 * If there is a handler for SIGCONT, we must make
@@ -908,6 +913,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 			signal->group_stop_count = 0;
 			t = p;
 			do {
+				task_clear_group_stop(t);
 				sigaddset(&t->pending.signal, SIGKILL);
 				signal_wake_up(t, 1);
 			} while_each_thread(p, t);
@@ -1141,6 +1147,7 @@ int zap_other_threads(struct task_struct *p)
 	p->signal->group_stop_count = 0;
 
 	while_each_thread(p, t) {
+		task_clear_group_stop(t);
 		count++;
 
 		/* Don't bother with already dead threads */
@@ -1692,7 +1699,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	 * If there is a group stop in progress,
 	 * we must participate in the bookkeeping.
 	 */
-	if (current->signal->group_stop_count > 0)
+	if (current->group_stop & GROUP_STOP_PENDING)
 		task_participate_group_stop(current);
 
 	current->last_siginfo = info;
@@ -1777,8 +1784,8 @@ static int do_signal_stop(int signr)
 	struct signal_struct *sig = current->signal;
 	int notify = 0;
 
-	if (!sig->group_stop_count) {
-		unsigned int gstop = GROUP_STOP_CONSUME;
+	if (!(current->group_stop & GROUP_STOP_PENDING)) {
+		unsigned int gstop = GROUP_STOP_PENDING | GROUP_STOP_CONSUME;
 		struct task_struct *t;
 
 		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
@@ -1798,8 +1805,7 @@ static int do_signal_stop(int signr)
 			 * stop is always done with the siglock held,
 			 * so this check has no races.
 			 */
-			if (!(t->flags & PF_EXITING) &&
-			    !task_is_stopped_or_traced(t)) {
+			if (!(t->flags & PF_EXITING) && !task_is_stopped(t)) {
 				t->group_stop = gstop;
 				sig->group_stop_count++;
 				signal_wake_up(t, 0);
@@ -1929,8 +1935,8 @@ relock:
 		if (unlikely(signr != 0))
 			ka = return_ka;
 		else {
-			if (unlikely(signal->group_stop_count > 0) &&
-			    do_signal_stop(0))
+			if (unlikely(current->group_stop &
+				     GROUP_STOP_PENDING) && do_signal_stop(0))
 				goto relock;
 
 			signr = dequeue_signal(current, &current->blocked,
@@ -2076,7 +2082,7 @@ void exit_signals(struct task_struct *tsk)
 		if (!signal_pending(t) && !(t->flags & PF_EXITING))
 			recalc_sigpending_and_wake(t);
 
-	if (unlikely(tsk->signal->group_stop_count) &&
+	if (unlikely(tsk->group_stop & GROUP_STOP_PENDING) &&
 	    task_participate_group_stop(tsk))
 		group_stop = CLD_STOPPED;
 out:
-- 
1.7.1

