Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab0K0LkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 06:40:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:42129 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab0K0LkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 06:40:20 -0500
Message-ID: <4CF0EE11.6000206@kernel.org>
Date: Sat, 27 Nov 2010 12:40:01 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: roland@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: [PATCH UPDATED 06/14] signal: use GROUP_STOP_PENDING to avoid stopping
 multiple times for a single group stop
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-7-git-send-email-tj@kernel.org>
In-Reply-To: <1290768569-16224-7-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Nov 2010 11:40:03 +0000 (UTC)
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

Oleg spotted that a task might skip signal check even when its
GROUP_STOP_PENDING is set.  Fixed by updating recalc_sigpending_tsk()
to check GROUP_STOP_PENDING instead of group_stop_count.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
recalc_sigpending_tsk() updated to test GROUP_STOP_PENDING too.  This
makes sure a ptracee always checks it after woken up.  Whether a task
already in TASK_STOPPED should have GROUP_STOP_PENDING set or not is a
different issue.  I think it probably would be better to do so so that
the ptracer is notified that the tracee is participating in group
stop.  The necessary change is simple, we just need to replace
task_is_stopped_or_traced() in group stop init path to
task_is_stopped().

With later patches, CLD_STOPPED/CONTINUED notifications are made
reliable w.r.t. ptrace by delaying them until ptrace detach if
necessary, so letting ptracees participate in group stop doesn't cost
anything.  Anyways, that's a separate issue.

The git tree is updated accordingly.

Thanks.

 include/linux/sched.h |    1 +
 kernel/signal.c       |   23 ++++++++++++++---------
 2 files changed, 15 insertions(+), 9 deletions(-)

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
index 7e2da0d..273ee35 100644
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

