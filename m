Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507Ab1EMPrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:47:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52886 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605Ab1EMPqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:46:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=jFswo8cTxT6/RwJi1ofjdD1EOJwy6rLbOBErvUU4aGWlGHlXLUDVrAhKPyZXIlAdGd
         L72p2IRwpkeWfUOr3QpzekcusWlm7Xjp/+CN/T9h3ZDRgijawUcXldBOvu1WZdcheXJZ
         9z5mM960LBWjRQnEQUh9vIT50h6YMwF77Gvp8=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/9] job control: introduce JOBCTL_PENDING_MASK and task_clear_jobctl_pending()
Date: Fri, 13 May 2011 17:46:16 +0200
Message-Id: <1305301580-9924-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1305301580-9924-1-git-send-email-tj@kernel.org>
References: <1305301580-9924-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces JOBCTL_PENDING_MASK and replaces
task_clear_jobctl_stop_pending() with task_clear_jobctl_pending()
which takes an extra @mask argument.

JOBCTL_PENDING_MASK is currently equal to JOBCTL_STOP_PENDING but
future patches will add more bits.  recalc_sigpending_tsk() is updated
to use JOBCTL_PENDING_MASK instead.

task_clear_jobctl_pending() takes @mask which in subset of
JOBCTL_PENDING_MASK and clears the relevant jobctl bits.  If
JOBCTL_STOP_PENDING is set, other STOP bits are cleared together.  All
task_clear_jobctl_stop_pending() users are updated to call
task_clear_jobctl_pending() with JOBCTL_STOP_PENDING which is
functionally identical to task_clear_jobctl_stop_pending().

This patch doesn't cause any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/exec.c             |    2 +-
 include/linux/sched.h |    5 ++++-
 kernel/signal.c       |   27 +++++++++++++++++----------
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index fd6a4fb..c654664 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1659,7 +1659,7 @@ static int zap_process(struct task_struct *start, int exit_code)
 
 	t = start;
 	do {
-		task_clear_jobctl_stop_pending(t);
+		task_clear_jobctl_pending(t, JOBCTL_STOP_PENDING);
 		if (t != current && t->mm) {
 			sigaddset(&t->pending.signal, SIGKILL);
 			signal_wake_up(t, 1);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 408f2b9..86f21e7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1786,7 +1786,10 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define JOBCTL_STOP_CONSUME	(1 << 18) /* consume group stop count */
 #define JOBCTL_TRAPPING		(1 << 21) /* switching to TRACED */
 
-extern void task_clear_jobctl_stop_pending(struct task_struct *task);
+#define JOBCTL_PENDING_MASK	JOBCTL_STOP_PENDING
+
+extern void task_clear_jobctl_pending(struct task_struct *task,
+				      unsigned int mask);
 
 #ifdef CONFIG_PREEMPT_RCU
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 26a30b8..e67eaa0 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -124,7 +124,7 @@ static inline int has_pending_signals(sigset_t *signal, sigset_t *blocked)
 
 static int recalc_sigpending_tsk(struct task_struct *t)
 {
-	if ((t->jobctl & JOBCTL_STOP_PENDING) ||
+	if ((t->jobctl & JOBCTL_PENDING_MASK) ||
 	    PENDING(&t->pending, &t->blocked) ||
 	    PENDING(&t->signal->shared_pending, &t->blocked)) {
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
@@ -245,18 +245,25 @@ static void task_clear_jobctl_trapping(struct task_struct *task)
 }
 
 /**
- * task_clear_jobctl_stop_pending - clear pending group stop
+ * task_clear_jobctl_pending - clear jobctl pending bits
  * @task: target task
+ * @mask: pending bits to clear
  *
- * Clear group stop states for @task.
+ * Clear @mask from @task->jobctl.  @mask must be subset of
+ * %JOBCTL_PENDING_MASK.  If %JOBCTL_STOP_PENDING is being cleared, other
+ * STOP bits are cleared together.
  *
  * CONTEXT:
  * Must be called with @task->sighand->siglock held.
  */
-void task_clear_jobctl_stop_pending(struct task_struct *task)
+void task_clear_jobctl_pending(struct task_struct *task, unsigned int mask)
 {
-	task->jobctl &= ~(JOBCTL_STOP_PENDING | JOBCTL_STOP_CONSUME |
-			  JOBCTL_STOP_DEQUEUED);
+	BUG_ON(mask & ~JOBCTL_PENDING_MASK);
+
+	if (mask & JOBCTL_STOP_PENDING)
+		mask |= JOBCTL_STOP_CONSUME | JOBCTL_STOP_DEQUEUED;
+
+	task->jobctl &= ~mask;
 }
 
 /**
@@ -282,7 +289,7 @@ static bool task_participate_group_stop(struct task_struct *task)
 
 	WARN_ON_ONCE(!(task->jobctl & JOBCTL_STOP_PENDING));
 
-	task_clear_jobctl_stop_pending(task);
+	task_clear_jobctl_pending(task, JOBCTL_STOP_PENDING);
 
 	if (!consume)
 		return false;
@@ -810,7 +817,7 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &signal->shared_pending);
 		t = p;
 		do {
-			task_clear_jobctl_stop_pending(t);
+			task_clear_jobctl_pending(t, JOBCTL_STOP_PENDING);
 			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
 			wake_up_state(t, __TASK_STOPPED);
 		} while_each_thread(p, t);
@@ -926,7 +933,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 			signal->group_stop_count = 0;
 			t = p;
 			do {
-				task_clear_jobctl_stop_pending(t);
+				task_clear_jobctl_pending(t, JOBCTL_STOP_PENDING);
 				sigaddset(&t->pending.signal, SIGKILL);
 				signal_wake_up(t, 1);
 			} while_each_thread(p, t);
@@ -1161,7 +1168,7 @@ int zap_other_threads(struct task_struct *p)
 	p->signal->group_stop_count = 0;
 
 	while_each_thread(p, t) {
-		task_clear_jobctl_stop_pending(t);
+		task_clear_jobctl_pending(t, JOBCTL_STOP_PENDING);
 		count++;
 
 		/* Don't bother with already dead threads */
-- 
1.7.1

