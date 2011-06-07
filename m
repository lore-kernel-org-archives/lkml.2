Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab1FGSBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:01:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55219 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab1FGSBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:01:49 -0400
Date: Tue, 7 Jun 2011 20:01:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20110607180141.GA27156@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-urgent-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (4):
      sched: Fix cross-cpu clock sync on remote wakeups
      sched: Fix schedstat.nr_wakeups_migrate
      lockdep: Fix lock_is_held() on recursion
      sched: Fix/clarify set_task_cpu() locking rules


 include/linux/sched.h |    1 +
 kernel/lockdep.c      |    2 +-
 kernel/sched.c        |   33 ++++++++++++++++++++++++---------
 3 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8da84b7..483c1ed 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1063,6 +1063,7 @@ struct sched_domain;
  */
 #define WF_SYNC		0x01		/* waker goes to sleep after wakup */
 #define WF_FORK		0x02		/* child wakeup after fork */
+#define WF_MIGRATED	0x04		/* internal use, task got migrated */
 
 #define ENQUEUE_WAKEUP		1
 #define ENQUEUE_HEAD		2
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 63437d0..298c927 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3426,7 +3426,7 @@ int lock_is_held(struct lockdep_map *lock)
 	int ret = 0;
 
 	if (unlikely(current->lockdep_recursion))
-		return ret;
+		return 1; /* avoid false negative lockdep_assert_held() */
 
 	raw_local_irq_save(flags);
 	check_flags(flags);
diff --git a/kernel/sched.c b/kernel/sched.c
index cbb3a0e..3f2e502 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -605,10 +605,10 @@ static inline int cpu_of(struct rq *rq)
 /*
  * Return the group to which this tasks belongs.
  *
- * We use task_subsys_state_check() and extend the RCU verification
- * with lockdep_is_held(&p->pi_lock) because cpu_cgroup_attach()
- * holds that lock for each task it moves into the cgroup. Therefore
- * by holding that lock, we pin the task to the current cgroup.
+ * We use task_subsys_state_check() and extend the RCU verification with
+ * pi->lock and rq->lock because cpu_cgroup_attach() holds those locks for each
+ * task it moves into the cgroup. Therefore by holding either of those locks,
+ * we pin the task to the current cgroup.
  */
 static inline struct task_group *task_group(struct task_struct *p)
 {
@@ -616,7 +616,8 @@ static inline struct task_group *task_group(struct task_struct *p)
 	struct cgroup_subsys_state *css;
 
 	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
-			lockdep_is_held(&p->pi_lock));
+			lockdep_is_held(&p->pi_lock) ||
+			lockdep_is_held(&task_rq(p)->lock));
 	tg = container_of(css, struct task_group, css);
 
 	return autogroup_task_group(p, tg);
@@ -2200,6 +2201,16 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
 
 #ifdef CONFIG_LOCKDEP
+	/*
+	 * The caller should hold either p->pi_lock or rq->lock, when changing
+	 * a task's CPU. ->pi_lock for waking tasks, rq->lock for runnable tasks.
+	 *
+	 * sched_move_task() holds both and thus holding either pins the cgroup,
+	 * see set_task_rq().
+	 *
+	 * Furthermore, all task_rq users should acquire both locks, see
+	 * task_rq_lock().
+	 */
 	WARN_ON_ONCE(debug_locks && !(lockdep_is_held(&p->pi_lock) ||
 				      lockdep_is_held(&task_rq(p)->lock)));
 #endif
@@ -2447,6 +2458,10 @@ ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
 		}
 		rcu_read_unlock();
 	}
+
+	if (wake_flags & WF_MIGRATED)
+		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
+
 #endif /* CONFIG_SMP */
 
 	schedstat_inc(rq, ttwu_count);
@@ -2455,9 +2470,6 @@ ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
 	if (wake_flags & WF_SYNC)
 		schedstat_inc(p, se.statistics.nr_wakeups_sync);
 
-	if (cpu != task_cpu(p))
-		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
-
 #endif /* CONFIG_SCHEDSTATS */
 }
 
@@ -2600,6 +2612,7 @@ static void ttwu_queue(struct task_struct *p, int cpu)
 
 #if defined(CONFIG_SMP)
 	if (sched_feat(TTWU_QUEUE) && cpu != smp_processor_id()) {
+		sched_clock_cpu(cpu); /* sync clocks x-cpu */
 		ttwu_queue_remote(p, cpu);
 		return;
 	}
@@ -2674,8 +2687,10 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 		p->sched_class->task_waking(p);
 
 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (task_cpu(p) != cpu)
+	if (task_cpu(p) != cpu) {
+		wake_flags |= WF_MIGRATED;
 		set_task_cpu(p, cpu);
+	}
 #endif /* CONFIG_SMP */
 
 	ttwu_queue(p, cpu);
