Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab1C2OqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:46:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41155 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab1C2OqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ZTmEUb3NvQKWRHi2D8fgqu8DvFgyQyqvDJyv52jkLveiQmgKgP2PVUY8NBPwkpKD+L
         m1YAS0SbXsqbrDI1UjSgGmyIKQiOUci7j/cYMb1XRvfalkniB3oZ/t3QmY0284grCigs
         /91W1L+VRs/PLU2pRdVMmnH4NLz0FZa63+Yso=
Date: Tue, 29 Mar 2011 16:46:03 +0200
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: [PATCH 1/3] signal: Make signal_wake_up() take @sig_type instead
 of @resume
Message-ID: <20110329144603.GA29865@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

signal_wake_up() currently takes boolean @resume which indicates that
the target task should be woken up with %TASK_WAKEKILL.  Replace the
argument with @sig_type and use %SIGKILL to indicate %TASK_WAKEKILL
wakeups.

This is to prepare for adding more signal wake up types.  All users
are converted to use %SIGKILL instead of 1 and this patch doesn't
cause any behavior difference.

While at it, convert to docbook function comment.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Hello, guys.

These three patches implement fix for the SIGCONT notification corner
case Oleg pointed out in the following thread.

 http://thread.gmane.org/gmane.linux.kernel/1116692/focus=1117000

In the process, signal_wake_up() is beefed up to handle most of child
wake up paths in signal and ptrace and I think the resulting code is
easier to comprehend and slightly less error-prone.

It may call in child into signal delivery path where it doesn't need
to but such cases are by no means common and I don't think there's any
performance implication.  Please read the patch description on the
third patch for details.

Oleg, what do you think?

Thanks.

 fs/exec.c             |    2 +-
 include/linux/sched.h |    2 +-
 kernel/ptrace.c       |    8 +++---
 kernel/signal.c       |   66 ++++++++++++++++++++++++++++++++-----------------
 4 files changed, 49 insertions(+), 29 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 8328beb..63e726d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1662,7 +1662,7 @@ static int zap_process(struct task_struct *start, int exit_code)
 		task_clear_group_stop_pending(t);
 		if (t != current && t->mm) {
 			sigaddset(&t->pending.signal, SIGKILL);
-			signal_wake_up(t, 1);
+			signal_wake_up(t, SIGKILL);
 			nr++;
 		}
 	} while_each_thread(start, t);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 456d80e..4c30c00 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2488,7 +2488,7 @@ static inline void thread_group_cputime_init(struct signal_struct *sig)
 extern void recalc_sigpending_and_wake(struct task_struct *t);
 extern void recalc_sigpending(void);
 
-extern void signal_wake_up(struct task_struct *t, int resume_stopped);
+extern void signal_wake_up(struct task_struct *t, int sig_type);
 
 /*
  * Wrappers for p->thread_info->cpu access. No-op on UP.
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 4348586..ec8cce6 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -86,12 +86,12 @@ void __ptrace_unlink(struct task_struct *child)
 
 	/*
 	 * If transition to TASK_STOPPED is pending or in TASK_TRACED, kick
-	 * @child in the butt.  Note that @resume should be used iff @child
-	 * is in TASK_TRACED; otherwise, we might unduly disrupt
+	 * @child in the butt.  Note that %SIGKILL wake up should be used
+	 * iff @child is in TASK_TRACED; otherwise, we might unduly disrupt
 	 * TASK_KILLABLE sleeps.
 	 */
 	if (child->group_stop & GROUP_STOP_PENDING || task_is_traced(child))
-		signal_wake_up(child, task_is_traced(child));
+		signal_wake_up(child, task_is_traced(child) ? SIGKILL : 0);
 
 	spin_unlock(&child->sighand->siglock);
 }
@@ -243,7 +243,7 @@ static int ptrace_attach(struct task_struct *task)
 	 */
 	if (task_is_stopped(task)) {
 		task->group_stop |= GROUP_STOP_PENDING | GROUP_STOP_TRAPPING;
-		signal_wake_up(task, 1);
+		signal_wake_up(task, SIGKILL);
 		wait_trap = true;
 	}
 
diff --git a/kernel/signal.c b/kernel/signal.c
index f799a05..837070c 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -618,33 +618,53 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 	return signr;
 }
 
-/*
- * Tell a process that it has a new active signal..
+/**
+ * signal_wake_up - tell a task that it has a new active signal
+ * @t: the target task
+ * @sig_type: the type of the new signal (0 or SIGKILL)
+ *
+ * This function makes sure that @t is woken up and/or brought into signal
+ * delivery path as necessary accodring to @sig_type.  @sig_type can be one
+ * of the followings.
+ *
+ * 0		Normal signal delivery.  If @t is executing in userland it
+ *		should be brought in to deliver the signal.  When @t is in
+ *		kernel, wake it up iff it's in interruptible sleep.
  *
- * NOTE! we rely on the previous spin_lock to
- * lock interrupts for us! We can only be called with
- * "siglock" held, and the local interrupt must
- * have been disabled when that got acquired!
+ * %SIGKILL	@t is being killed.  In addition to the usual kicking,
+ *		interrupt KILLABLE, STOPPED and TRACED sleeps using
+ *		%TASK_WAKEKILL.
  *
- * No need to set need_resched since signal event passing
- * goes through ->blocked
+ * CONTEXT:
+ * Must be called with @t->sighand->siglock held.
  */
-void signal_wake_up(struct task_struct *t, int resume)
+void signal_wake_up(struct task_struct *t, int sig_type)
 {
-	unsigned int mask;
+	unsigned int uninitialized_var(mask);
 
 	set_tsk_thread_flag(t, TIF_SIGPENDING);
 
-	/*
-	 * For SIGKILL, we want to wake it up in the stopped/traced/killable
-	 * case. We don't check t->state here because there is a race with it
-	 * executing another processor and just now entering stopped state.
-	 * By using wake_up_state, we ensure the process will wake up and
-	 * handle its death signal.
-	 */
-	mask = TASK_INTERRUPTIBLE;
-	if (resume)
-		mask |= TASK_WAKEKILL;
+	switch (sig_type) {
+	case 0:
+		mask = TASK_INTERRUPTIBLE;
+		break;
+
+	case SIGKILL:
+		/*
+		 * For SIGKILL, we want to wake it up in the stopped /
+		 * traced / killable case.  We don't check t->state here
+		 * because there is a race with it executing another
+		 * processor and just now entering stopped state.  By using
+		 * wake_up_state, we ensure the process will wake up and
+		 * handle its death signal.
+		 */
+		mask |= TASK_INTERRUPTIBLE | TASK_WAKEKILL;
+		break;
+
+	default:
+		BUG();
+	}
+
 	if (!wake_up_state(t, mask))
 		kick_process(t);
 }
@@ -941,7 +961,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 			do {
 				task_clear_group_stop_pending(t);
 				sigaddset(&t->pending.signal, SIGKILL);
-				signal_wake_up(t, 1);
+				signal_wake_up(t, SIGKILL);
 			} while_each_thread(p, t);
 			return;
 		}
@@ -951,7 +971,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 	 * The signal is already in the shared-pending queue.
 	 * Tell the chosen thread to wake up and dequeue it.
 	 */
-	signal_wake_up(t, sig == SIGKILL);
+	signal_wake_up(t, sig == SIGKILL ? SIGKILL : 0);
 	return;
 }
 
@@ -1180,7 +1200,7 @@ int zap_other_threads(struct task_struct *p)
 		if (t->exit_state)
 			continue;
 		sigaddset(&t->pending.signal, SIGKILL);
-		signal_wake_up(t, 1);
+		signal_wake_up(t, SIGKILL);
 	}
 
 	return count;
-- 
1.7.1

