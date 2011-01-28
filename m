Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab1A1PJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:09:21 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36770 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab1A1PJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:09:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=o96Ir+l1d7CRkcraNTb5fWk1nLJSOFc5S4y4r43uYaNEMjEidHiuxamb4WuexBeYzs
         mNewq9ZQXP6RoBAtvVOTRihp+73nuUhIEXiPA4SklDtIVabfjVR3pxZfzpbxVlpDPTDy
         Hkzc2jJD0mVxENttCBap99FPDvjg+oH5SlFIs=
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/10] ptrace: kill tracehook_notify_jctl()
Date: Fri, 28 Jan 2011 16:08:38 +0100
Message-Id: <1296227324-25295-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296227324-25295-1-git-send-email-tj@kernel.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
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

= Oleg spotted incorrect CLD_CONTINUED/STOPPED selection when ptraced.
  Fixed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 include/linux/tracehook.h |   27 ---------------------------
 kernel/signal.c           |   34 ++++++++++++++--------------------
 2 files changed, 14 insertions(+), 47 deletions(-)

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
index 0a6816a..7dc0ca2 100644
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
@@ -1860,14 +1857,11 @@ relock:
 
 		signal->flags &= ~SIGNAL_CLD_MASK;
 
-		why = tracehook_notify_jctl(why, CLD_CONTINUED);
 		spin_unlock_irq(&sighand->siglock);
 
-		if (why) {
-			read_lock(&tasklist_lock);
-			do_notify_parent_cldstop(current->group_leader, why);
-			read_unlock(&tasklist_lock);
-		}
+		read_lock(&tasklist_lock);
+		do_notify_parent_cldstop(current->group_leader, why);
+		read_unlock(&tasklist_lock);
 		goto relock;
 	}
 
@@ -2034,7 +2028,7 @@ void exit_signals(struct task_struct *tsk)
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

