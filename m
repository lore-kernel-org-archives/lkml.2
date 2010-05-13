Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab0EMKtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:49:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:60621 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756757Ab0EMKtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:49:16 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 3/4] sched: refactor try_to_wake_up()
Date: Thu, 13 May 2010 12:48:24 +0200
Message-Id: <1273747705-7829-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273747705-7829-1-git-send-email-tj@kernel.org>
References: <1273747705-7829-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 10:48:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor ttwu_activate() and ttwu_woken_up() out of try_to_wake_up().
The factoring out doesn't affect try_to_wake_up() much
code-generation-wise.  Depending on configuration options, it ends up
generating the same object code as before or slightly different one
due to different register assignment.

This is to help future implementation of try_to_wake_up_local().

Mike Galbraith suggested rename to ttwu_post_activation() from
ttwu_woken_up() and comment update in try_to_wake_up().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   83 +++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 49 insertions(+), 34 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ecf024d..0b6da84 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2322,11 +2322,52 @@ static void update_avg(u64 *avg, u64 sample)
 }
 #endif
 
-/***
+static inline void ttwu_activate(struct task_struct *p, struct rq *rq,
+				 bool is_sync, bool is_migrate, bool is_local,
+				 unsigned long en_flags)
+{
+	schedstat_inc(p, se.statistics.nr_wakeups);
+	if (is_sync)
+		schedstat_inc(p, se.statistics.nr_wakeups_sync);
+	if (is_migrate)
+		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
+	if (is_local)
+		schedstat_inc(p, se.statistics.nr_wakeups_local);
+	else
+		schedstat_inc(p, se.statistics.nr_wakeups_remote);
+
+	activate_task(rq, p, en_flags);
+}
+
+static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
+					int wake_flags, bool success)
+{
+	trace_sched_wakeup(p, success);
+	check_preempt_curr(rq, p, wake_flags);
+
+	p->state = TASK_RUNNING;
+#ifdef CONFIG_SMP
+	if (p->sched_class->task_woken)
+		p->sched_class->task_woken(rq, p);
+
+	if (unlikely(rq->idle_stamp)) {
+		u64 delta = rq->clock - rq->idle_stamp;
+		u64 max = 2*sysctl_sched_migration_cost;
+
+		if (delta > max)
+			rq->avg_idle = max;
+		else
+			update_avg(&rq->avg_idle, delta);
+		rq->idle_stamp = 0;
+	}
+#endif
+}
+
+/**
  * try_to_wake_up - wake up a thread
- * @p: the to-be-woken-up thread
+ * @p: the thread to be awakened
  * @state: the mask of task states that can be woken
- * @sync: do a synchronous wakeup?
+ * @wake_flags: wake modifier flags (WF_*)
  *
  * Put it on the run-queue if it's not already there. The "current"
  * thread is always on the run-queue (except when the actual
@@ -2334,7 +2375,8 @@ static void update_avg(u64 *avg, u64 sample)
  * the simpler "current->state = TASK_RUNNING" to mark yourself
  * runnable without the overhead of this.
  *
- * returns failure only if the task is already active.
+ * Returns %true if @p was woken up, %false if it was already running
+ * or @state didn't match @p's state.
  */
 static int try_to_wake_up(struct task_struct *p, unsigned int state,
 			  int wake_flags)
@@ -2414,38 +2456,11 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 
 out_activate:
 #endif /* CONFIG_SMP */
-	schedstat_inc(p, se.statistics.nr_wakeups);
-	if (wake_flags & WF_SYNC)
-		schedstat_inc(p, se.statistics.nr_wakeups_sync);
-	if (orig_cpu != cpu)
-		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
-	if (cpu == this_cpu)
-		schedstat_inc(p, se.statistics.nr_wakeups_local);
-	else
-		schedstat_inc(p, se.statistics.nr_wakeups_remote);
-	activate_task(rq, p, en_flags);
+	ttwu_activate(p, rq, wake_flags & WF_SYNC, orig_cpu != cpu,
+		      cpu == this_cpu, en_flags);
 	success = 1;
-
 out_running:
-	trace_sched_wakeup(p, success);
-	check_preempt_curr(rq, p, wake_flags);
-
-	p->state = TASK_RUNNING;
-#ifdef CONFIG_SMP
-	if (p->sched_class->task_woken)
-		p->sched_class->task_woken(rq, p);
-
-	if (unlikely(rq->idle_stamp)) {
-		u64 delta = rq->clock - rq->idle_stamp;
-		u64 max = 2*sysctl_sched_migration_cost;
-
-		if (delta > max)
-			rq->avg_idle = max;
-		else
-			update_avg(&rq->avg_idle, delta);
-		rq->idle_stamp = 0;
-	}
-#endif
+	ttwu_post_activation(p, rq, wake_flags, success);
 out:
 	task_rq_unlock(rq, &flags);
 	put_cpu();
-- 
1.6.4.2

