Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab0LFQ6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:58:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:59765 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab0LFQ6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:58:49 -0500
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/16] ptrace: make SIGCONT notification reliable against ptrace
Date: Mon,  6 Dec 2010 17:57:02 +0100
Message-Id: <1291654624-6230-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291654624-6230-1-git-send-email-tj@kernel.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 16:57:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, SIGCONT notifications which are pending on ptrace attach or
occur while ptraced are reported to the tracer and never make it to
the real parent.

This patch adds a new signal flag SIGNAL_NOTIFY_CONT which is set when
a task is woken up by SIGCONT and cleared once the event is notified
to the parent.  SIGNAL_CLD_MASK bits are no longer cleared after
notification.  Combined with clearing SIGNAL_CLD_MASK if
!SIGNAL_NOTIFY_CONT on ptrace attach, these bits are set on ptrace
detach iff the tracee owes a notification to the real parent.
__ptrace_unlink() is updated to check these bits and reschedule
SIGCONT notification if necessary.

As notification delivery should consider both the child's signal flags
and ptraced state, it should be done while holding both siglock and
tasklist_lock.  The delivery logic is moved into
do_notify_parent_cldstop() and performed while holding both
tasklist_lock and siglock.

This change puts the initial SIGNAL_NOTIFY_CONT test out of siglock.
This is safe as the bit set by the waker are guaranteed to be visible
to the woken up task.

Oleg spotted the above race condition caused by ptrace state and
signal state protected by different locks.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 include/linux/sched.h |    1 +
 kernel/ptrace.c       |   36 ++++++++++++++++++++++++++++++++++++
 kernel/signal.c       |   49 ++++++++++++++++++++++++++++---------------------
 3 files changed, 65 insertions(+), 21 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7a26e7d..ed7725b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -654,6 +654,7 @@ struct signal_struct {
 #define SIGNAL_UNKILLABLE	0x00000040 /* for init: ignore fatal signals */
 
 #define SIGNAL_NOTIFY_STOP	0x00000100 /* notify parent of group stop */
+#define SIGNAL_NOTIFY_CONT	0x00000200 /* notify parent of continuation */
 
 /* If true, all threads except ->group_exit_task have pending SIGKILL */
 static inline int signal_group_exit(const struct signal_struct *sig)
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 6ac12f4..dba6aeb 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -52,6 +52,7 @@ void __ptrace_link(struct task_struct *child, struct task_struct *new_parent)
 void __ptrace_unlink(struct task_struct *child)
 {
 	struct signal_struct *sig = child->signal;
+	bool woken_up = false;
 
 	BUG_ON(!child->ptrace);
 
@@ -66,6 +67,33 @@ void __ptrace_unlink(struct task_struct *child)
 		if (sig->flags & SIGNAL_STOP_STOPPED || sig->group_stop_count)
 			child->group_stop |= GROUP_STOP_PENDING;
 		signal_wake_up(child, 1);
+		woken_up = true;
+	}
+
+	/*
+	 * SIGNAL_CLD_MASK is cleared only on a stop signal or, if
+	 * notification isn't pending, ptrace attach.  If any bit is
+	 * set,
+	 *
+	 * - SIGCONT notification was pending before attach or there
+	 *   was one or more SIGCONT notifications while tracing.
+	 *
+	 * - And, there hasn't been any stop signal since the last
+	 *   pending SIGCONT notification.
+	 *
+	 * Combined, it means that the tracee owes a SIGCONT
+	 * notification to the real parent.
+	 */
+	if (sig->flags & SIGNAL_CLD_MASK) {
+		sig->flags |= SIGNAL_NOTIFY_CONT;
+		/*
+		 * Force the tracee into signal delivery path so that
+		 * the notification is delievered ASAP.  This wakeup
+		 * is unintrusive as SIGCONT delivery would have
+		 * caused the same effect.
+		 */
+		if (!woken_up)
+			signal_wake_up(child, 0);
 	}
 
 	child->ptrace = 0;
@@ -245,6 +273,14 @@ int ptrace_attach(struct task_struct *task)
 		signal_wake_up(task, 1);
 	}
 
+	/*
+	 * Clear SIGNAL_CLD_MASK if NOTIFY_CONT is not set.  This is
+	 * used to preserve SIGCONT notification across ptrace
+	 * attach/detach.  Read the comment in __ptrace_unlink().
+	 */
+	if (!(task->signal->flags & SIGNAL_NOTIFY_CONT))
+		task->signal->flags &= ~SIGNAL_CLD_MASK;
+
 	spin_unlock(&task->sighand->siglock);
 
 	retval = 0;
diff --git a/kernel/signal.c b/kernel/signal.c
index 3196367..7b6f972 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -832,7 +832,8 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 			 * will take ->siglock, notice SIGNAL_CLD_MASK, and
 			 * notify its parent. See get_signal_to_deliver().
 			 */
-			signal->flags = why | SIGNAL_STOP_CONTINUED;
+			why |= SIGNAL_STOP_CONTINUED | SIGNAL_NOTIFY_CONT;
+			signal->flags = why;
 			signal->group_stop_count = 0;
 			signal->group_exit_code = 0;
 		} else {
@@ -1603,6 +1604,8 @@ int do_notify_parent(struct task_struct *tsk, int sig)
  * Depending on @why and other conditions, the notification might be
  * skipped.
  *
+ * CLD_CONTINUED	: Notify once if SIGNAL_NOTIFY_CONT is set.
+ *
  * CLD_STOPPED		: If ptraced, always notify; otherwise, notify
  *			  once if SIGNAL_NOTIFY_STOP is set.
  *
@@ -1639,7 +1642,24 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 
 	switch (why) {
 	case CLD_CONTINUED:
-		notify = why;
+		/*
+		 * Notify once if NOTIFY_CONT is set regardless of ptrace.
+		 * NOTIFY_CONT will be reinstated on detach if necessary.
+		 */
+		if (!(sig->flags & SIGNAL_NOTIFY_CONT))
+			break;
+
+		/*
+		 * If ptraced, always report CLD_CONTINUED; otherwise,
+		 * prepare_signal(SIGCONT) encodes the CLD_ si_code into
+		 * SIGNAL_CLD_MASK bits.
+		 */
+		if (task_ptrace(tsk) || (sig->flags & SIGNAL_CLD_CONTINUED))
+			notify = CLD_CONTINUED;
+		else
+			notify = CLD_STOPPED;
+
+		sig->flags &= ~SIGNAL_NOTIFY_CONT;
 		break;
 
 	case CLD_STOPPED:
@@ -2015,31 +2035,18 @@ relock:
 	 */
 	try_to_freeze();
 
-	spin_lock_irq(&sighand->siglock);
 	/*
-	 * Every stopped thread goes here after wakeup. Check to see if
-	 * we should notify the parent, prepare_signal(SIGCONT) encodes
-	 * the CLD_ si_code into SIGNAL_CLD_MASK bits.
+	 * Every stopped thread should go through this function after
+	 * waking up.  Check to see if we should notify the parent.
 	 */
-	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
-		int why;
-
-		if (task_ptrace(current) ||
-		    (signal->flags & SIGNAL_CLD_CONTINUED))
-			why = CLD_CONTINUED;
-		else
-			why = CLD_STOPPED;
-
-		signal->flags &= ~SIGNAL_CLD_MASK;
-
-		spin_unlock_irq(&sighand->siglock);
-
+	if (unlikely(current->signal->flags & SIGNAL_NOTIFY_CONT)) {
 		read_lock(&tasklist_lock);
-		do_notify_parent_cldstop(current, why);
+		do_notify_parent_cldstop(current, CLD_CONTINUED);
 		read_unlock(&tasklist_lock);
-		goto relock;
 	}
 
+	spin_lock_irq(&sighand->siglock);
+
 	for (;;) {
 		struct k_sigaction *ka;
 		/*
-- 
1.7.1

