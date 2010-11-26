Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab0KZKvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:51:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:42320 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869Ab0KZKu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:50:26 -0500
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/14] signal: use GROUP_STOP_PENDING to avoid stopping multiple times for a single group stop
Date: Fri, 26 Nov 2010 11:49:21 +0100
Message-Id: <1290768569-16224-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290768569-16224-1-git-send-email-tj@kernel.org>
References: <1290768569-16224-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 10:49:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently task->signal->group_stop_count is used to decide whether to
stop for group stop.  However, if there is a task in the group which
is taking a long time to stop, other tasks which are continued by
ptrace would repeatedly stop for the same group stop until the group
stop is complete.

This patch introduces GROUP_STOP_PENDING which tracks whether a task
is yet to stop for the group stop in progress.  The flag is set when a
group stop starts and cleared when the task stops the first time for
the group stop, so the task won't stop multiple times for the same
group stop.

Note that currently GROUP_STOP_PENDING tracks the same state as
GROUP_STOP_CONSUME.  Both always get set and cleared together without
releasing siglock inbetween.  This will change with future patches.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 include/linux/sched.h |    1 +
 kernel/signal.c       |   21 +++++++++++++--------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 93157a4..1261993 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1760,6 +1760,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 /*
  * task->group_stop flags
  */
+#define GROUP_STOP_PENDING	(1 << 16) /* task should stop for group stop */
 #define GROUP_STOP_CONSUME	(1 << 17) /* consume group stop count */
 
 #ifdef CONFIG_PREEMPT_RCU
diff --git a/kernel/signal.c b/kernel/signal.c
index 7e2da0d..b859690 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -732,6 +732,9 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 		t = p;
 		do {
 			unsigned int state;
+
+			t->group_stop = 0;
+
 			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
 			/*
 			 * If there is a handler for SIGCONT, we must make
@@ -1742,8 +1745,8 @@ static int do_signal_stop(int signr)
 	struct signal_struct *sig = current->signal;
 	int notify = 0;
 
-	if (!sig->group_stop_count) {
-		unsigned int gstop = GROUP_STOP_CONSUME;
+	if (!(current->group_stop & GROUP_STOP_PENDING)) {
+		unsigned int gstop = GROUP_STOP_PENDING | GROUP_STOP_CONSUME;
 		struct task_struct *t;
 
 		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
@@ -1782,10 +1785,10 @@ static int do_signal_stop(int signr)
 	notify = tracehook_notify_jctl(notify, CLD_STOPPED);
 	/*
 	 * tracehook_notify_jctl() can drop and reacquire siglock, so
-	 * we test ->group_stop_count again.  If SIGCONT or SIGKILL
-	 * comes in between, ->group_stop_count == 0.
+	 * we test GROUP_STOP_PENDING again.  If SIGCONT or SIGKILL
+	 * comes in between, it would be clear.
 	 */
-	if (!sig->group_stop_count) {
+	if (!(current->group_stop & GROUP_STOP_PENDING)) {
 		spin_unlock_irq(&current->sighand->siglock);
 		goto out;
 	}
@@ -1794,6 +1797,7 @@ static int do_signal_stop(int signr)
 		sig->flags = SIGNAL_STOP_STOPPED;
 
 	current->exit_code = sig->group_exit_code;
+	current->group_stop &= ~GROUP_STOP_PENDING;
 	__set_current_state(TASK_STOPPED);
 
 	spin_unlock_irq(&current->sighand->siglock);
@@ -1908,8 +1912,8 @@ relock:
 		if (unlikely(signr != 0))
 			ka = return_ka;
 		else {
-			if (unlikely(signal->group_stop_count > 0) &&
-			    do_signal_stop(0))
+			if (unlikely(current->group_stop &
+				     GROUP_STOP_PENDING) && do_signal_stop(0))
 				goto relock;
 
 			signr = dequeue_signal(current, &current->blocked,
@@ -2055,7 +2059,8 @@ void exit_signals(struct task_struct *tsk)
 		if (!signal_pending(t) && !(t->flags & PF_EXITING))
 			recalc_sigpending_and_wake(t);
 
-	if (unlikely(tsk->signal->group_stop_count) && consume_group_stop()) {
+	if (unlikely(tsk->group_stop & GROUP_STOP_PENDING) &&
+	    consume_group_stop()) {
 		tsk->signal->flags = SIGNAL_STOP_STOPPED;
 		group_stop = tracehook_notify_jctl(CLD_STOPPED, CLD_STOPPED);
 	}
-- 
1.7.1

