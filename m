Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab2IMOn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:43:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35307 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051Ab2IMOnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:43:23 -0400
Date: Thu, 13 Sep 2012 16:43:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20120913144305.GA17831@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: 9450d57eab5cad36774c297da123062744472588 sched: Fix kernel-doc warnings in kernel/sched/fair.c

Smaller fixlets.

 Thanks,

	Ingo

------------------>
Charles Wang (1):
      sched: Add missing call to calc_load_exit_idle()

Peter Boonstoppel (1):
      sched: Unthrottle rt runqueues in __disable_runtime()

Peter Zijlstra (1):
      sched: Fix load avg vs cpu-hotplug

Randy Dunlap (1):
      sched: Fix kernel-doc warnings in kernel/sched/fair.c


 kernel/sched/core.c      | 34 ++++++++++------------------------
 kernel/sched/fair.c      |  9 +++++----
 kernel/sched/rt.c        |  1 +
 kernel/sched/sched.h     |  1 -
 kernel/time/tick-sched.c |  1 +
 5 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fbf1fd0..a4ea245 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5304,27 +5304,17 @@ void idle_task_exit(void)
 }
 
 /*
- * While a dead CPU has no uninterruptible tasks queued at this point,
- * it might still have a nonzero ->nr_uninterruptible counter, because
- * for performance reasons the counter is not stricly tracking tasks to
- * their home CPUs. So we just add the counter to another CPU's counter,
- * to keep the global sum constant after CPU-down:
- */
-static void migrate_nr_uninterruptible(struct rq *rq_src)
-{
-	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
-
-	rq_dest->nr_uninterruptible += rq_src->nr_uninterruptible;
-	rq_src->nr_uninterruptible = 0;
-}
-
-/*
- * remove the tasks which were accounted by rq from calc_load_tasks.
+ * Since this CPU is going 'away' for a while, fold any nr_active delta
+ * we might have. Assumes we're called after migrate_tasks() so that the
+ * nr_active count is stable.
+ *
+ * Also see the comment "Global load-average calculations".
  */
-static void calc_global_load_remove(struct rq *rq)
+static void calc_load_migrate(struct rq *rq)
 {
-	atomic_long_sub(rq->calc_load_active, &calc_load_tasks);
-	rq->calc_load_active = 0;
+	long delta = calc_load_fold_active(rq);
+	if (delta)
+		atomic_long_add(delta, &calc_load_tasks);
 }
 
 /*
@@ -5352,9 +5342,6 @@ static void migrate_tasks(unsigned int dead_cpu)
 	 */
 	rq->stop = NULL;
 
-	/* Ensure any throttled groups are reachable by pick_next_task */
-	unthrottle_offline_cfs_rqs(rq);
-
 	for ( ; ; ) {
 		/*
 		 * There's this thread running, bail when that's the only
@@ -5618,8 +5605,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		BUG_ON(rq->nr_running != 1); /* the migration thread */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
 
-		migrate_nr_uninterruptible(rq);
-		calc_global_load_remove(rq);
+		calc_load_migrate(rq);
 		break;
 #endif
 	}
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c219bf8..42d9df6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2052,7 +2052,7 @@ static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	hrtimer_cancel(&cfs_b->slack_timer);
 }
 
-void unthrottle_offline_cfs_rqs(struct rq *rq)
+static void unthrottle_offline_cfs_rqs(struct rq *rq)
 {
 	struct cfs_rq *cfs_rq;
 
@@ -2106,7 +2106,7 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
 	return NULL;
 }
 static inline void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
-void unthrottle_offline_cfs_rqs(struct rq *rq) {}
+static inline void unthrottle_offline_cfs_rqs(struct rq *rq) {}
 
 #endif /* CONFIG_CFS_BANDWIDTH */
 
@@ -3658,7 +3658,6 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
  * @group: sched_group whose statistics are to be updated.
  * @load_idx: Load index of sched_domain of this_cpu for load calc.
  * @local_group: Does group contain this_cpu.
- * @cpus: Set of cpus considered for load balancing.
  * @balance: Should we balance.
  * @sgs: variable to hold the statistics for this group.
  */
@@ -3805,7 +3804,6 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 /**
  * update_sd_lb_stats - Update sched_domain's statistics for load balancing.
  * @env: The load balancing environment.
- * @cpus: Set of cpus considered for load balancing.
  * @balance: Should we balance.
  * @sds: variable to hold the statistics for this sched_domain.
  */
@@ -4956,6 +4954,9 @@ static void rq_online_fair(struct rq *rq)
 static void rq_offline_fair(struct rq *rq)
 {
 	update_sysctl();
+
+	/* Ensure any throttled groups are reachable by pick_next_task */
+	unthrottle_offline_cfs_rqs(rq);
 }
 
 #endif /* CONFIG_SMP */
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 944cb68..e0b7ba9 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -691,6 +691,7 @@ balanced:
 		 * runtime - in which case borrowing doesn't make sense.
 		 */
 		rt_rq->rt_runtime = RUNTIME_INF;
+		rt_rq->rt_throttled = 0;
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 		raw_spin_unlock(&rt_b->rt_runtime_lock);
 	}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f6714d0..0848fa3 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1144,7 +1144,6 @@ extern void print_rt_stats(struct seq_file *m, int cpu);
 
 extern void init_cfs_rq(struct cfs_rq *cfs_rq);
 extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
-extern void unthrottle_offline_cfs_rqs(struct rq *rq);
 
 extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 024540f..3a9e5d5 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -573,6 +573,7 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 	tick_do_update_jiffies64(now);
 	update_cpu_load_nohz();
 
+	calc_load_exit_idle();
 	touch_softlockup_watchdog();
 	/*
 	 * Cancel the scheduled timer and restore the tick
