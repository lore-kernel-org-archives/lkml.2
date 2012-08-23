Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab2HWOQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:16:31 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:53881 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783Ab2HWOPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:15:32 -0400
Message-Id: <20120823141507.422162369@google.com>
User-Agent: quilt/0.48-1
Date: Thu, 23 Aug 2012 07:14:38 -0700
From: pjt@google.com
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ben Segall <bsegall@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [patch 16/16] sched: introduce temporary FAIR_GROUP_SCHED dependency for load-tracking
References: <20120823141422.444396696@google.com>
Content-Disposition: inline; filename=sched-depend_on_fair.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Turner <pjt@google.com>

While per-entity load-tracking is generally useful, beyond computing shares
distribution, e.g.
  runnable based load-balance (in progress), governors, power-management, etc

These facilities are not yet consumers of this data.  This may be trivially
reverted when the information is required; but avoid paying the overhead for
calculations we will not use until then.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Ben Segall <bsegall@google.com>
---
 include/linux/sched.h |    8 +++++++-
 kernel/sched/core.c   |    7 ++++++-
 kernel/sched/fair.c   |   13 +++++++++++--
 kernel/sched/sched.h  |    9 ++++++++-
 4 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2a4be1f..da37380 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1213,7 +1213,13 @@ struct sched_entity {
 	/* rq "owned" by this entity/group: */
 	struct cfs_rq		*my_q;
 #endif
-#ifdef CONFIG_SMP
+/*
+ * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
+ * removed when useful for applications beyond shares distribution (e.g.
+ * load-balance).
+ */
+#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+	/* Per-entity load-tracking */
 	struct sched_avg	avg;
 #endif
 };
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b3e2442..e497f59 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1558,7 +1558,12 @@ static void __sched_fork(struct task_struct *p)
 	p->se.vruntime			= 0;
 	INIT_LIST_HEAD(&p->se.group_node);
 
-#ifdef CONFIG_SMP
+/*
+ * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
+ * removed when useful for applications beyond shares distribution (e.g.
+ * load-balance).
+ */
+#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
 	p->se.avg.runnable_avg_period = 0;
 	p->se.avg.runnable_avg_sum = 0;
 #endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 44a9a11..c46fd45 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -877,7 +877,8 @@ static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-#ifdef CONFIG_SMP
+/* Only depends on SMP, FAIR_GROUP_SCHED may be removed when useful in lb */
+#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
 /*
  * We choose a half-life close to 1 scheduling period.
  * Note: The tables below are dependent on this value.
@@ -3175,6 +3176,12 @@ unlock:
 }
 
 /*
+ * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
+ * removed when useful for applications beyond shares distribution (e.g.
+ * load-balance).
+ */
+#ifdef CONFIG_FAIR_GROUP_SCHED
+/*
  * Called immediately before a task is migrated to a new cpu; task_cpu(p) and
  * cfs_rq_of(p) references at time of call are still valid and identify the
  * previous cpu.  However, the caller only guarantees p->pi_lock is held; no
@@ -3197,6 +3204,7 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 		atomic64_add(se->avg.load_avg_contrib, &cfs_rq->removed_load);
 	}
 }
+#endif
 #endif /* CONFIG_SMP */
 
 static unsigned long
@@ -5775,8 +5783,9 @@ const struct sched_class fair_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_fair,
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	.migrate_task_rq	= migrate_task_rq_fair,
-
+#endif
 	.rq_online		= rq_online_fair,
 	.rq_offline		= rq_offline_fair,
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e14601e..b3e84f6 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -225,6 +225,12 @@ struct cfs_rq {
 #endif
 
 #ifdef CONFIG_SMP
+/*
+ * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
+ * removed when useful for applications beyond shares distribution (e.g.
+ * load-balance).
+ */
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	/*
 	 * CFS Load tracking
 	 * Under CFS, load is tracked on a per-entity basis and aggregated up.
@@ -234,7 +240,8 @@ struct cfs_rq {
 	u64 runnable_load_avg, blocked_load_avg;
 	atomic64_t decay_counter, removed_load;
 	u64 last_decay;
-
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+/* These always depend on CONFIG_FAIR_GROUP_SCHED */
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	u32 tg_runnable_contrib, tg_usage_contrib;
 	u64 tg_load_contrib;


