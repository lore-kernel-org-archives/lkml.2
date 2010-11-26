Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab0KZKuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:50:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:42298 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab0KZKuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:50:13 -0500
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/14] ptrace: make group stop notification reliable against ptrace
Date: Fri, 26 Nov 2010 11:49:26 +0100
Message-Id: <1290768569-16224-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290768569-16224-1-git-send-email-tj@kernel.org>
References: <1290768569-16224-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 10:49:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group stop notifications are unreliable if one or more tasks of the
task group are being ptraced.  If a ptraced task ends up finishing a
group stop, the notification is sent to the ptracer and the real
parent never gets notified.

This patch adds a new signal flag SIGNAL_NOTIFY_STOP which is set on
group stop completion and cleared after notification to the real
parent or together with other stopped flags on SIGCONT/KILL.  This
guarantees that the real parent is notified correctly regardless of
ptrace.  If a ptraced task is the last task to stop, the notification
is postponed till ptrace detach or canceled if SIGCONT/KILL is
received inbetween.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 include/linux/sched.h |    2 ++
 kernel/signal.c       |   20 +++++++++++++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e78b1e5..3e40761 100644
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
index c084ea8..f2da456 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1739,7 +1739,6 @@ void ptrace_notify(int exit_code)
 static int do_signal_stop(int signr)
 {
 	struct signal_struct *sig = current->signal;
-	int notify = 0;
 
 	if (!(current->group_stop & GROUP_STOP_PENDING)) {
 		unsigned int gstop = GROUP_STOP_PENDING | GROUP_STOP_CONSUME;
@@ -1780,8 +1779,9 @@ static int do_signal_stop(int signr)
 	 */
 	if (sig->group_stop_count == 1 &&
 	    (current->group_stop & GROUP_STOP_CONSUME))
-		notify = CLD_STOPPED;
-	notify = tracehook_notify_jctl(notify, CLD_STOPPED);
+		tracehook_notify_jctl(CLD_STOPPED, CLD_STOPPED);
+	else
+		tracehook_notify_jctl(0, CLD_STOPPED);
 	/*
 	 * tracehook_notify_jctl() can drop and reacquire siglock, so
 	 * we test GROUP_STOP_PENDING again.  If SIGCONT or SIGKILL
@@ -1791,20 +1791,26 @@ static int do_signal_stop(int signr)
 		goto out_unlock;
 
 	if (consume_group_stop())
-		sig->flags = SIGNAL_STOP_STOPPED;
+		sig->flags = SIGNAL_STOP_STOPPED | SIGNAL_NOTIFY_STOP;
 retry:
 	current->exit_code = sig->group_exit_code;
 	current->group_stop &= ~GROUP_STOP_PENDING;
 	__set_current_state(TASK_STOPPED);
 
 	if (likely(!task_ptrace(current))) {
+		bool do_notify = false;
+
+		if (sig->flags & SIGNAL_NOTIFY_STOP) {
+			sig->flags &= ~SIGNAL_NOTIFY_STOP;
+			do_notify = true;
+		}
+
 		spin_unlock_irq(&current->sighand->siglock);
 
-		if (notify) {
+		if (do_notify) {
 			read_lock(&tasklist_lock);
-			do_notify_parent_cldstop(current, notify);
+			do_notify_parent_cldstop(current, CLD_STOPPED);
 			read_unlock(&tasklist_lock);
-			notify = 0;
 		}
 
 		/* Now we don't run again until woken by SIGCONT or SIGKILL */
-- 
1.7.1

