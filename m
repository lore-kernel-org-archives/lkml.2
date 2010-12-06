Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0LFQ6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:58:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:59707 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab0LFQ61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:58:27 -0500
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/16] ptrace: kill tracehook_notify_jctl()
Date: Mon,  6 Dec 2010 17:56:52 +0100
Message-Id: <1291654624-6230-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291654624-6230-1-git-send-email-tj@kernel.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 16:57:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tracehook_notify_jctl() aids in determining whether and what to report
to the parent when a task is stopped or continued.  The function also
adds an extra requirement that siglock may be released across it,
which is currently unused and quite difficult to satisfy in
well-defined manner.

As job control and the notifications are about to receive major
overhaul, remove the tracehook and open code it.  If ever necessary,
let's factor it out after the overhaul.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 include/linux/tracehook.h |   27 ---------------------------
 kernel/signal.c           |   37 ++++++++++++++++---------------------
 2 files changed, 16 insertions(+), 48 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 3a2e66d..b073f3c 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -469,33 +469,6 @@ static inline int tracehook_get_signal(struct task_struct *task,
 }
 
 /**
- * tracehook_notify_jctl - report about job control stop/continue
- * @notify:		zero, %CLD_STOPPED or %CLD_CONTINUED
- * @why:		%CLD_STOPPED or %CLD_CONTINUED
- *
- * This is called when we might call do_notify_parent_cldstop().
- *
- * @notify is zero if we would not ordinarily send a %SIGCHLD,
- * or is the %CLD_STOPPED or %CLD_CONTINUED .si_code for %SIGCHLD.
- *
- * @why is %CLD_STOPPED when about to stop for job control;
- * we are already in %TASK_STOPPED state, about to call schedule().
- * It might also be that we have just exited (check %PF_EXITING),
- * but need to report that a group-wide stop is complete.
- *
- * @why is %CLD_CONTINUED when waking up after job control stop and
- * ready to make a delayed @notify report.
- *
- * Return the %CLD_* value for %SIGCHLD, or zero to generate no signal.
- *
- * Called with the siglock held.
- */
-static inline int tracehook_notify_jctl(int notify, int why)
-{
-	return notify ?: (current->ptrace & PT_PTRACED) ? why : 0;
-}
-
-/**
  * tracehook_finish_jctl - report about return from job control stop
  *
  * This is called by do_signal_stop() after wakeup.
diff --git a/kernel/signal.c b/kernel/signal.c
index 7211c9f..5c334ec 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1727,7 +1727,7 @@ void ptrace_notify(int exit_code)
 static int do_signal_stop(int signr)
 {
 	struct signal_struct *sig = current->signal;
-	int notify;
+	int notify = 0;
 
 	if (!sig->group_stop_count) {
 		struct task_struct *t;
@@ -1759,19 +1759,16 @@ static int do_signal_stop(int signr)
 	 * a group stop in progress and we are the last to stop, report
 	 * to the parent.  When ptraced, every thread reports itself.
 	 */
-	notify = sig->group_stop_count == 1 ? CLD_STOPPED : 0;
-	notify = tracehook_notify_jctl(notify, CLD_STOPPED);
-	/*
-	 * tracehook_notify_jctl() can drop and reacquire siglock, so
-	 * we keep ->group_stop_count != 0 before the call. If SIGCONT
-	 * or SIGKILL comes in between ->group_stop_count == 0.
-	 */
-	if (sig->group_stop_count) {
-		if (!--sig->group_stop_count)
-			sig->flags = SIGNAL_STOP_STOPPED;
-		current->exit_code = sig->group_exit_code;
-		__set_current_state(TASK_STOPPED);
+	if (!--sig->group_stop_count) {
+		sig->flags = SIGNAL_STOP_STOPPED;
+		notify = CLD_STOPPED;
 	}
+	if (task_ptrace(current))
+		notify = CLD_STOPPED;
+
+	current->exit_code = sig->group_exit_code;
+	__set_current_state(TASK_STOPPED);
+
 	spin_unlock_irq(&current->sighand->siglock);
 
 	if (notify) {
@@ -1853,21 +1850,19 @@ relock:
 	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
 		int why;
 
-		if (signal->flags & SIGNAL_CLD_CONTINUED)
+		if (task_ptrace(current) ||
+		    (signal->flags & SIGNAL_CLD_CONTINUED))
 			why = CLD_CONTINUED;
 		else
 			why = CLD_STOPPED;
 
 		signal->flags &= ~SIGNAL_CLD_MASK;
 
-		why = tracehook_notify_jctl(why, CLD_CONTINUED);
 		spin_unlock_irq(&sighand->siglock);
 
-		if (why) {
-			read_lock(&tasklist_lock);
-			do_notify_parent_cldstop(current, why);
-			read_unlock(&tasklist_lock);
-		}
+		read_lock(&tasklist_lock);
+		do_notify_parent_cldstop(current, why);
+		read_unlock(&tasklist_lock);
 		goto relock;
 	}
 
@@ -2034,7 +2029,7 @@ void exit_signals(struct task_struct *tsk)
 	if (unlikely(tsk->signal->group_stop_count) &&
 			!--tsk->signal->group_stop_count) {
 		tsk->signal->flags = SIGNAL_STOP_STOPPED;
-		group_stop = tracehook_notify_jctl(CLD_STOPPED, CLD_STOPPED);
+		group_stop = CLD_STOPPED;
 	}
 out:
 	spin_unlock_irq(&tsk->sighand->siglock);
-- 
1.7.1

