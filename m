Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013Ab1EXSiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:38:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45008 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958Ab1EXSiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=cigz5ZFYHHSw07gThN0JS91yFQ9SC2JiCOZkQC8wfaPJN4uUMsCQx0EE//6ZMaC5us
         CTw0Lq1zpKRd3Rh+sJwW8hLSH/aPNAUjuH82TJ+goTPXUM+hpWwaaVPmO7vABZoTU5yP
         UbERe4cEk74IXkpQ+kBqsQ0kq4gCGlhZG7p1Y=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/19] job control: introduce JOBCTL_TRAP_STOP and use it for group stop trap
Date: Tue, 24 May 2011 20:37:31 +0200
Message-Id: <1306262259-7285-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1306262259-7285-1-git-send-email-tj@kernel.org>
References: <1306262259-7285-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_signal_stop() implemented both normal group stop and trap for group
stop while ptraced.  This approach has been enough but scheduled
changes require trap mechanism which can be used in more generic
manner and using group stop trap for generic trap site simplifies both
userland visible interface and implementation.

This patch adds a new jobctl flag - JOBCTL_TRAP_STOP.  When set, it
triggers a trap site, which behaves like group stop trap, in
get_signal_to_deliver() before checking for pending signals.  While
ptraced, do_signal_stop() doesn't stop itself.  It initiates group
stop if requested and schedules JOBCTL_TRAP_STOP and returns, which
makes its caller - get_signal_to_deliver() - to relock, check and
enter the trap.

Although this adds an unlock-relocking between checking of
JOBCTL_STOP_PENDING and actually trapping for STOP, this doesn't
affect correctness.  ptrace_stop() already had conditional
unlock-relocking depending on arch and, if SIGCONT is generated
inbetween, it's ignored as if it were received after the task entered
TASK_TRACED.  The extra unlock-relocking follows the same rule and the
race window will be properly handled by notification mechanism which
will be added later.

ptrace_attach() is updated to use JOBCTL_TRAP_STOP instead of
JOBCTL_STOP_PENDING and __ptrace_unlink() to clear all pending trap
bits and TRAPPING so that TRAP_STOP and future trap bits don't linger
after detach.

While at it, add proper function comment to do_signal_stop() and make
it return bool.

-v2: __ptrace_unlink() updated to clear JOBCTL_TRAP_MASK and TRAPPING
     instead of JOBCTL_PENDING_MASK.  This avoids accidentally
     clearing JOBCTL_STOP_CONSUME.  Spotted by Oleg.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h |    5 ++-
 kernel/ptrace.c       |   12 +++++--
 kernel/signal.c       |   82 +++++++++++++++++++++++++++++++------------------
 3 files changed, 65 insertions(+), 34 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8519614..9a0e1bc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1799,12 +1799,15 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define JOBCTL_STOP_DEQUEUED	(1 << 16) /* stop signal dequeued */
 #define JOBCTL_STOP_PENDING	(1 << 17) /* task should stop for group stop */
 #define JOBCTL_STOP_CONSUME	(1 << 18) /* consume group stop count */
+#define JOBCTL_TRAP_STOP	(1 << 19) /* trap for STOP */
 #define JOBCTL_TRAPPING		(1 << 21) /* switching to TRACED */
 
-#define JOBCTL_PENDING_MASK	JOBCTL_STOP_PENDING
+#define JOBCTL_TRAP_MASK	JOBCTL_TRAP_STOP
+#define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK)
 
 extern bool task_set_jobctl_pending(struct task_struct *task,
 				    unsigned int mask);
+extern void task_clear_jobctl_trapping(struct task_struct *task);
 extern void task_clear_jobctl_pending(struct task_struct *task,
 				      unsigned int mask);
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 71e1034..e75d335 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -128,6 +128,13 @@ void __ptrace_unlink(struct task_struct *child)
 	spin_lock(&child->sighand->siglock);
 
 	/*
+	 * Clear all pending traps and TRAPPING.  TRAPPING should be
+	 * cleared regardless of JOBCTL_STOP_PENDING.  Do it explicitly.
+	 */
+	task_clear_jobctl_pending(child, JOBCTL_TRAP_MASK);
+	task_clear_jobctl_trapping(child);
+
+	/*
 	 * Reinstate JOBCTL_STOP_PENDING if group stop is in effect and
 	 * @child isn't dead.
 	 */
@@ -293,7 +300,7 @@ static int ptrace_attach(struct task_struct *task)
 	spin_lock(&task->sighand->siglock);
 
 	/*
-	 * If the task is already STOPPED, set JOBCTL_STOP_PENDING and
+	 * If the task is already STOPPED, set JOBCTL_TRAP_STOP and
 	 * TRAPPING, and kick it so that it transits to TRACED.  TRAPPING
 	 * will be cleared if the child completes the transition or any
 	 * event which clears the group stop states happens.
@@ -308,8 +315,7 @@ static int ptrace_attach(struct task_struct *task)
 	 * in and out of STOPPED are protected by siglock.
 	 */
 	if (task_is_stopped(task) &&
-	    task_set_jobctl_pending(task,
-				    JOBCTL_STOP_PENDING | JOBCTL_TRAPPING))
+	    task_set_jobctl_pending(task, JOBCTL_TRAP_STOP | JOBCTL_TRAPPING))
 		signal_wake_up(task, 1);
 
 	spin_unlock(&task->sighand->siglock);
diff --git a/kernel/signal.c b/kernel/signal.c
index 85df25e..38e7d2f 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -266,7 +266,7 @@ bool task_set_jobctl_pending(struct task_struct *task, unsigned int mask)
  * CONTEXT:
  * Must be called with @task->sighand->siglock held.
  */
-static void task_clear_jobctl_trapping(struct task_struct *task)
+void task_clear_jobctl_trapping(struct task_struct *task)
 {
 	if (unlikely(task->jobctl & JOBCTL_TRAPPING)) {
 		task->jobctl &= ~JOBCTL_TRAPPING;
@@ -1790,13 +1790,16 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	/*
 	 * If @why is CLD_STOPPED, we're trapping to participate in a group
 	 * stop.  Do the bookkeeping.  Note that if SIGCONT was delievered
-	 * while siglock was released for the arch hook, PENDING could be
-	 * clear now.  We act as if SIGCONT is received after TASK_TRACED
-	 * is entered - ignore it.
+	 * across siglock relocks since INTERRUPT was scheduled, PENDING
+	 * could be clear now.  We act as if SIGCONT is received after
+	 * TASK_TRACED is entered - ignore it.
 	 */
 	if (why == CLD_STOPPED && (current->jobctl & JOBCTL_STOP_PENDING))
 		gstop_done = task_participate_group_stop(current);
 
+	/* any trap clears pending STOP trap */
+	task_clear_jobctl_pending(current, JOBCTL_TRAP_STOP);
+
 	/* entering a trap, clear TRAPPING */
 	task_clear_jobctl_trapping(current);
 
@@ -1888,13 +1891,30 @@ void ptrace_notify(int exit_code)
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
-/*
- * This performs the stopping for SIGSTOP and other stop signals.
- * We have to stop all threads in the thread group.
- * Returns non-zero if we've actually stopped and released the siglock.
- * Returns zero if we didn't stop and still hold the siglock.
+/**
+ * do_signal_stop - handle group stop for SIGSTOP and other stop signals
+ * @signr: signr causing group stop if initiating
+ *
+ * If %JOBCTL_STOP_PENDING is not set yet, initiate group stop with @signr
+ * and participate in it.  If already set, participate in the existing
+ * group stop.  If participated in a group stop (and thus slept), %true is
+ * returned with siglock released.
+ *
+ * If ptraced, this function doesn't handle stop itself.  Instead,
+ * %JOBCTL_TRAP_STOP is scheduled and %true is returned with siglock
+ * released.  The caller must ensure that INTERRUPT trap handling takes
+ * places afterwards.
+ *
+ * CONTEXT:
+ * Must be called with @current->sighand->siglock held, which is released
+ * on %true return.
+ *
+ * RETURNS:
+ * %false if group stop is already cancelled and nothing happened.  %true
+ * if participated in group stop.
  */
-static int do_signal_stop(int signr)
+static bool do_signal_stop(int signr)
+	__releases(&current->sighand->siglock)
 {
 	struct signal_struct *sig = current->signal;
 
@@ -1907,7 +1927,7 @@ static int do_signal_stop(int signr)
 
 		if (!likely(current->jobctl & JOBCTL_STOP_DEQUEUED) ||
 		    unlikely(signal_group_exit(sig)))
-			return 0;
+			return false;
 		/*
 		 * There is no group stop already in progress.  We must
 		 * initiate one now.
@@ -1951,7 +1971,7 @@ static int do_signal_stop(int signr)
 			}
 		}
 	}
-retry:
+
 	if (likely(!task_ptrace(current))) {
 		int notify = 0;
 
@@ -1983,27 +2003,16 @@ retry:
 
 		/* Now we don't run again until woken by SIGCONT or SIGKILL */
 		schedule();
-
-		spin_lock_irq(&current->sighand->siglock);
 	} else {
-		ptrace_stop(current->jobctl & JOBCTL_STOP_SIGMASK,
-			    CLD_STOPPED, 0, NULL);
-		current->exit_code = 0;
-	}
-
-	/*
-	 * JOBCTL_STOP_PENDING could be set if another group stop has
-	 * started since being woken up or ptrace wants us to transit
-	 * between TASK_STOPPED and TRACED.  Retry group stop.
-	 */
-	if (current->jobctl & JOBCTL_STOP_PENDING) {
-		WARN_ON_ONCE(!(current->jobctl & JOBCTL_STOP_SIGMASK));
-		goto retry;
+		/*
+		 * While ptraced, group stop is handled by STOP trap.
+		 * Schedule it and let the caller deal with it.
+		 */
+		task_set_jobctl_pending(current, JOBCTL_TRAP_STOP);
+		spin_unlock_irq(&current->sighand->siglock);
 	}
 
-	spin_unlock_irq(&current->sighand->siglock);
-
-	return 1;
+	return true;
 }
 
 static int ptrace_signal(int signr, siginfo_t *info,
@@ -2103,6 +2112,19 @@ relock:
 		goto relock;
 	}
 
+	/*
+	 * Take care of ptrace jobctl traps.  It currently is only used to
+	 * trap for group stop while ptraced.
+	 */
+	if (unlikely(current->jobctl & JOBCTL_TRAP_MASK)) {
+		signr = current->jobctl & JOBCTL_STOP_SIGMASK;
+		WARN_ON_ONCE(!signr);
+		ptrace_stop(signr, CLD_STOPPED, 0, NULL);
+		current->exit_code = 0;
+		spin_unlock_irq(&sighand->siglock);
+		goto relock;
+	}
+
 	for (;;) {
 		struct k_sigaction *ka;
 
-- 
1.7.1

