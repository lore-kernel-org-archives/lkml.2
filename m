Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab0LFQ6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:58:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:59726 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab0LFQ6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:58:41 -0500
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/16] signal: prepare for CLD_* notification changes
Date: Mon,  6 Dec 2010 17:56:59 +0100
Message-Id: <1291654624-6230-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291654624-6230-1-git-send-email-tj@kernel.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 16:57:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add docbook comment for do_notify_parent_cldstop(), fix a comment typo
and add boilerplat code to prepare for moving notification
determination logic into do_notify_parent_cldstop().

This patch doesn't cause any visible behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 6d93a3f..7dfbba9 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1597,13 +1597,57 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 	return ret;
 }
 
+/**
+ * do_notify_parent_cldstop - notify parent of CLD_CONTINUED, STOPPED or TRAPPED
+ * @tsk: task which has been continued or is about to stop
+ * @why: CLD_{CONTINUED|STOPPED|TRAPPED}
+ *
+ * Notifies the parent that @tsk has been continued or is about to stop.
+ *
+ * The notify target changes depending on whether @tsk is being ptraced or
+ * not.  If @tsk is being ptraced, it's always the ptracer; otherwise, it's
+ * the task group's real parent.
+ *
+ * CONTEXT:
+ * Must be called with tasklist_lock held.  Grabs and releases the siglocks
+ * of @tsk and the notify target.
+ */
 static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 {
 	struct siginfo info;
 	unsigned long flags;
 	struct task_struct *parent;
 	struct sighand_struct *sighand;
+	struct signal_struct *sig;
+	int notify = 0;
+
+	/*
+	 * Determine whether and what to notify.  This should be done under
+	 * @tsk's siglock.  As tasklist_lock is already held,
+	 * task_ptrace(@tsk) won't change beneath us.
+	 */
+	sighand = tsk->sighand;
+	sig = tsk->signal;
+	spin_lock_irqsave(&sighand->siglock, flags);
 
+	switch (why) {
+	case CLD_CONTINUED:
+	case CLD_STOPPED:
+	case CLD_TRAPPED:
+		notify = why;
+		break;
+	}
+
+	spin_unlock_irqrestore(&sighand->siglock, flags);
+
+	if (!notify)
+		return;
+
+	/*
+	 * Determine notify target and who should be notifying.  If being
+	 * ptraced, @tsk notifies to its current parent; otherwise, the
+	 * group leader reports to its real parent.
+	 */
 	if (task_ptrace(tsk))
 		parent = tsk->parent;
 	else {
@@ -1614,7 +1658,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 	info.si_signo = SIGCHLD;
 	info.si_errno = 0;
 	/*
-	 * see comment in do_notify_parent() abot the following 3 lines
+	 * see comment in do_notify_parent() about the following 3 lines
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
@@ -1624,13 +1668,13 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 	info.si_utime = cputime_to_clock_t(tsk->utime);
 	info.si_stime = cputime_to_clock_t(tsk->stime);
 
- 	info.si_code = why;
- 	switch (why) {
+	info.si_code = notify;
+	switch (notify) {
  	case CLD_CONTINUED:
  		info.si_status = SIGCONT;
  		break;
  	case CLD_STOPPED:
- 		info.si_status = tsk->signal->group_exit_code & 0x7f;
+		info.si_status = sig->group_exit_code & 0x7f;
  		break;
  	case CLD_TRAPPED:
  		info.si_status = tsk->exit_code & 0x7f;
@@ -1640,6 +1684,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
  	}
 
 	sighand = parent->sighand;
+	sig = parent->signal;
 	spin_lock_irqsave(&sighand->siglock, flags);
 	if (sighand->action[SIGCHLD-1].sa.sa_handler != SIG_IGN &&
 	    !(sighand->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDSTOP))
-- 
1.7.1

