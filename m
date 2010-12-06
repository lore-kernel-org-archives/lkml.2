Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab0LFQ6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:58:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:59702 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab0LFQ6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:58:15 -0500
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/16] ptrace: make group stop notification reliable against ptrace
Date: Mon,  6 Dec 2010 17:57:00 +0100
Message-Id: <1291654624-6230-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291654624-6230-1-git-send-email-tj@kernel.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 16:57:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group stop notifications are unreliable if one or more tasks of the
task group are being ptraced.  If a ptraced task ends up finishing a
group stop, the notification is sent to the ptracer and the real
parent never gets notified.

This patch adds a new signal flag SIGNAL_NOTIFY_STOP which is set on
group stop completion and cleared on notification to the real parent
or together with other stopped flags on SIGCONT/KILL.  This guarantees
that the real parent is notified correctly regardless of ptrace.  If a
ptraced task is the last task to stop, the notification is postponed
till ptrace detach or canceled if SIGCONT/KILL is received inbetween.

Oleg spotted race against ptrace attach/detach in the initial
implementation.  This is fixed by moving notification determiniation
into do_notify_parent_cldstop() and performing it while holding both
tasklist_lock and siglock.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 include/linux/sched.h |    2 +
 kernel/signal.c       |   65 +++++++++++++++++++++++++++++-------------------
 2 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7045c34..7a26e7d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -653,6 +653,8 @@ struct signal_struct {
 
 #define SIGNAL_UNKILLABLE	0x00000040 /* for init: ignore fatal signals */
 
+#define SIGNAL_NOTIFY_STOP	0x00000100 /* notify parent of group stop */
+
 /* If true, all threads except ->group_exit_task have pending SIGKILL */
 static inline int signal_group_exit(const struct signal_struct *sig)
 {
diff --git a/kernel/signal.c b/kernel/signal.c
index 7dfbba9..3196367 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -269,7 +269,7 @@ void task_clear_group_stop(struct task_struct *task)
  * CONTEXT:
  * Must be called with @task->sighand->siglock held.
  */
-static bool task_participate_group_stop(struct task_struct *task)
+static void task_participate_group_stop(struct task_struct *task)
 {
 	struct signal_struct *sig = task->signal;
 	bool consume = task->group_stop & GROUP_STOP_CONSUME;
@@ -279,18 +279,15 @@ static bool task_participate_group_stop(struct task_struct *task)
 	task_clear_group_stop(task);
 
 	if (!consume)
-		return false;
+		return;
 
 	task->group_stop &= ~GROUP_STOP_CONSUME;
 
 	if (!WARN_ON_ONCE(sig->group_stop_count == 0))
 		sig->group_stop_count--;
 
-	if (!sig->group_stop_count) {
-		sig->flags = SIGNAL_STOP_STOPPED;
-		return true;
-	}
-	return false;
+	if (!sig->group_stop_count)
+		sig->flags = SIGNAL_STOP_STOPPED | SIGNAL_NOTIFY_STOP;
 }
 
 /*
@@ -1603,6 +1600,16 @@ int do_notify_parent(struct task_struct *tsk, int sig)
  * @why: CLD_{CONTINUED|STOPPED|TRAPPED}
  *
  * Notifies the parent that @tsk has been continued or is about to stop.
+ * Depending on @why and other conditions, the notification might be
+ * skipped.
+ *
+ * CLD_STOPPED		: If ptraced, always notify; otherwise, notify
+ *			  once if SIGNAL_NOTIFY_STOP is set.
+ *
+ * CLD_TRAPPED		: Always notify.
+ *
+ * For notify once cases, the respective NOTIFY flag is consumed and
+ * cleared.
  *
  * The notify target changes depending on whether @tsk is being ptraced or
  * not.  If @tsk is being ptraced, it's always the ptracer; otherwise, it's
@@ -1632,9 +1639,26 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 
 	switch (why) {
 	case CLD_CONTINUED:
+		notify = why;
+		break;
+
 	case CLD_STOPPED:
+		/*
+		 * If ptraced, always notify; otherwise, notify once if
+		 * NOTIFY_STOP is set.
+		 */
+		if (task_ptrace(tsk))
+			notify = CLD_STOPPED;
+		else if (sig->flags & SIGNAL_NOTIFY_STOP) {
+			notify = CLD_STOPPED;
+			sig->flags &= ~SIGNAL_NOTIFY_STOP;
+		}
+		break;
+
 	case CLD_TRAPPED:
-		notify = why;
+		/* TRAPPED is possible only while ptraced and always notified */
+		WARN_ON_ONCE(!task_ptrace(tsk));
+		notify = CLD_TRAPPED;
 		break;
 	}
 
@@ -1901,21 +1925,12 @@ retry:
 	__set_current_state(TASK_STOPPED);
 
 	if (likely(!task_ptrace(current))) {
-		int notify = 0;
-
-		/*
-		 * If there are no other threads in the group, or if there
-		 * is a group stop in progress and we are the last to stop,
-		 * report to the parent.
-		 */
-		if (task_participate_group_stop(current))
-			notify = CLD_STOPPED;
-
+		task_participate_group_stop(current);
 		spin_unlock_irq(&current->sighand->siglock);
 
-		if (notify) {
+		if (sig->flags & SIGNAL_NOTIFY_STOP) {
 			read_lock(&tasklist_lock);
-			do_notify_parent_cldstop(current, notify);
+			do_notify_parent_cldstop(current, CLD_STOPPED);
 			read_unlock(&tasklist_lock);
 		}
 
@@ -2160,7 +2175,6 @@ relock:
 
 void exit_signals(struct task_struct *tsk)
 {
-	int group_stop = 0;
 	struct task_struct *t;
 
 	if (thread_group_empty(tsk) || signal_group_exit(tsk->signal)) {
@@ -2185,15 +2199,14 @@ void exit_signals(struct task_struct *tsk)
 		if (!signal_pending(t) && !(t->flags & PF_EXITING))
 			recalc_sigpending_and_wake(t);
 
-	if (unlikely(tsk->group_stop & GROUP_STOP_PENDING) &&
-	    task_participate_group_stop(tsk))
-		group_stop = CLD_STOPPED;
+	if (unlikely(tsk->group_stop & GROUP_STOP_PENDING))
+		task_participate_group_stop(tsk);
 out:
 	spin_unlock_irq(&tsk->sighand->siglock);
 
-	if (unlikely(group_stop)) {
+	if (unlikely(tsk->signal->flags & SIGNAL_NOTIFY_STOP)) {
 		read_lock(&tasklist_lock);
-		do_notify_parent_cldstop(tsk, group_stop);
+		do_notify_parent_cldstop(tsk, CLD_STOPPED);
 		read_unlock(&tasklist_lock);
 	}
 }
-- 
1.7.1

