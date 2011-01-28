Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab1A1PJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:09:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51211 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab1A1PJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:09:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=B1dTRk4iI4sgwhftwy46EfLoDLJCtSLgfQ32572RD5Ql446RZpZDoQ3kJ/EYFBkBSZ
         QFQZMOsJcGjiwDLw47yAKhTof4TvTLek9fNl+C2WEfvDCLhea+THt79C/awtmE7cbAMt
         7za/223TYuFnUgKLSOI2Emd6V8wCtI6KC4tSQ=
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/10] signal: use GROUP_STOP_PENDING to stop once for a single group stop
Date: Fri, 28 Jan 2011 16:08:41 +0100
Message-Id: <1296227324-25295-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296227324-25295-1-git-send-email-tj@kernel.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
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
index c62efcb..0928da8 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1653,6 +1653,7 @@ static int zap_process(struct task_struct *start, int exit_code)
 
 	t = start;
 	do {
+		task_clear_group_stop_pending(t);
 		if (t != current && t->mm) {
 			sigaddset(&t->pending.signal, SIGKILL);
 			signal_wake_up(t, 1);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 58df43d..0fc6c5e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1776,8 +1776,11 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 /*
  * task->group_stop flags
  */
+#define GROUP_STOP_PENDING	(1 << 16) /* task should stop for group stop */
 #define GROUP_STOP_CONSUME	(1 << 17) /* consume group stop count */
 
+extern void task_clear_group_stop_pending(struct task_struct *task);
+
 #ifdef CONFIG_PREEMPT_RCU
 
 #define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
diff --git a/kernel/signal.c b/kernel/signal.c
index 238eeba..7527778 100644
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
-static void task_clear_group_stop_pending(struct task_struct *task)
+void task_clear_group_stop_pending(struct task_struct *task)
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
 	task_clear_group_stop_pending(task);
 
 	if (!consume)
@@ -765,6 +767,9 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 		t = p;
 		do {
 			unsigned int state;
+
+			task_clear_group_stop_pending(t);
+
 			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
 			/*
 			 * If there is a handler for SIGCONT, we must make
@@ -906,6 +911,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 			signal->group_stop_count = 0;
 			t = p;
 			do {
+				task_clear_group_stop_pending(t);
 				sigaddset(&t->pending.signal, SIGKILL);
 				signal_wake_up(t, 1);
 			} while_each_thread(p, t);
@@ -1139,6 +1145,7 @@ int zap_other_threads(struct task_struct *p)
 	p->signal->group_stop_count = 0;
 
 	while_each_thread(p, t) {
+		task_clear_group_stop_pending(t);
 		count++;
 
 		/* Don't bother with already dead threads */
@@ -1690,7 +1697,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	 * If there is a group stop in progress,
 	 * we must participate in the bookkeeping.
 	 */
-	if (current->signal->group_stop_count > 0)
+	if (current->group_stop & GROUP_STOP_PENDING)
 		task_participate_group_stop(current);
 
 	current->last_siginfo = info;
@@ -1775,8 +1782,8 @@ static int do_signal_stop(int signr)
 	struct signal_struct *sig = current->signal;
 	int notify = 0;
 
-	if (!sig->group_stop_count) {
-		unsigned int gstop = GROUP_STOP_CONSUME;
+	if (!(current->group_stop & GROUP_STOP_PENDING)) {
+		unsigned int gstop = GROUP_STOP_PENDING | GROUP_STOP_CONSUME;
 		struct task_struct *t;
 
 		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
@@ -1796,8 +1803,7 @@ static int do_signal_stop(int signr)
 			 * stop is always done with the siglock held,
 			 * so this check has no races.
 			 */
-			if (!(t->flags & PF_EXITING) &&
-			    !task_is_stopped_or_traced(t)) {
+			if (!(t->flags & PF_EXITING) && !task_is_stopped(t)) {
 				t->group_stop = gstop;
 				sig->group_stop_count++;
 				signal_wake_up(t, 0);
@@ -1926,8 +1932,8 @@ relock:
 		if (unlikely(signr != 0))
 			ka = return_ka;
 		else {
-			if (unlikely(signal->group_stop_count > 0) &&
-			    do_signal_stop(0))
+			if (unlikely(current->group_stop &
+				     GROUP_STOP_PENDING) && do_signal_stop(0))
 				goto relock;
 
 			signr = dequeue_signal(current, &current->blocked,
@@ -2073,7 +2079,7 @@ void exit_signals(struct task_struct *tsk)
 		if (!signal_pending(t) && !(t->flags & PF_EXITING))
 			recalc_sigpending_and_wake(t);
 
-	if (unlikely(tsk->signal->group_stop_count) &&
+	if (unlikely(tsk->group_stop & GROUP_STOP_PENDING) &&
 	    task_participate_group_stop(tsk))
 		group_stop = CLD_STOPPED;
 out:
-- 
1.7.1

