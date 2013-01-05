Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab3AEIky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 03:40:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:44979 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317Ab3AEIhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 03:37:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,415,1355126400"; 
   d="scan'208";a="270210119"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        alex.shi@intel.com
Subject: [PATCH v3 12/22] Revert "sched: Introduce temporary FAIR_GROUP_SCHED dependency for load-tracking"
Date: Sat,  5 Jan 2013 16:37:41 +0800
Message-Id: <1357375071-11793-13-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit f4e26b120b9de84cb627bc7361ba43cfdc51341f
and plus some other CONFIG_FAIR_GROUP_SCHED checking.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/sched.h |  8 +-------
 kernel/sched/core.c   | 11 +++--------
 kernel/sched/fair.c   | 13 ++-----------
 kernel/sched/sched.h  |  9 +--------
 4 files changed, 7 insertions(+), 34 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index fb7aab5..2b309c6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1195,13 +1195,7 @@ struct sched_entity {
 	/* rq "owned" by this entity/group: */
 	struct cfs_rq		*my_q;
 #endif
-/*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
-	/* Per-entity load-tracking */
+#ifdef CONFIG_SMP
 	struct sched_avg	avg;
 #endif
 };
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5feed5e..e8cc6b8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1550,12 +1550,7 @@ static void __sched_fork(struct task_struct *p)
 	p->se.vruntime			= 0;
 	INIT_LIST_HEAD(&p->se.group_node);
 
-/*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+#ifdef CONFIG_SMP
 	p->se.avg.runnable_avg_period = 0;
 	p->se.avg.runnable_avg_sum = 0;
 	p->se.avg.decay_count = 0;
@@ -2544,7 +2539,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 void update_idle_cpu_load(struct rq *this_rq)
 {
 	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+#ifdef CONFIG_SMP
 	unsigned long load = (unsigned long)this_rq->cfs.runnable_load_avg;
 #else
 	unsigned long load = this_rq->load.weight;
@@ -2598,7 +2593,7 @@ static void update_cpu_load_active(struct rq *this_rq)
 	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
 	 */
 	this_rq->last_load_update_tick = jiffies;
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+#ifdef CONFIG_SMP
 	__update_cpu_load(this_rq, this_rq->cfs.runnable_load_avg, 1);
 #else
 	__update_cpu_load(this_rq, this_rq->load.weight, 1);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 247d6a8..6fa10ac 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1109,8 +1109,7 @@ static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-/* Only depends on SMP, FAIR_GROUP_SCHED may be removed when useful in lb */
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+#ifdef CONFIG_SMP
 /*
  * We choose a half-life close to 1 scheduling period.
  * Note: The tables below are dependent on this value.
@@ -3396,12 +3395,6 @@ unlock:
 }
 
 /*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-#ifdef CONFIG_FAIR_GROUP_SCHED
-/*
  * Called immediately before a task is migrated to a new cpu; task_cpu(p) and
  * cfs_rq_of(p) references at time of call are still valid and identify the
  * previous cpu.  However, the caller only guarantees p->pi_lock is held; no
@@ -3424,7 +3417,6 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 		atomic64_add(se->avg.load_avg_contrib, &cfs_rq->removed_load);
 	}
 }
-#endif
 #endif /* CONFIG_SMP */
 
 static unsigned long
@@ -6125,9 +6117,8 @@ const struct sched_class fair_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_fair,
-#ifdef CONFIG_FAIR_GROUP_SCHED
 	.migrate_task_rq	= migrate_task_rq_fair,
-#endif
+
 	.rq_online		= rq_online_fair,
 	.rq_offline		= rq_offline_fair,
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fc88644..ae3511e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -225,12 +225,6 @@ struct cfs_rq {
 #endif
 
 #ifdef CONFIG_SMP
-/*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-#ifdef CONFIG_FAIR_GROUP_SCHED
 	/*
 	 * CFS Load tracking
 	 * Under CFS, load is tracked on a per-entity basis and aggregated up.
@@ -240,8 +234,7 @@ struct cfs_rq {
 	u64 runnable_load_avg, blocked_load_avg;
 	atomic64_t decay_counter, removed_load;
 	u64 last_decay;
-#endif /* CONFIG_FAIR_GROUP_SCHED */
-/* These always depend on CONFIG_FAIR_GROUP_SCHED */
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	u32 tg_runnable_contrib;
 	u64 tg_load_contrib;
-- 
1.7.12

