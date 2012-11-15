Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768534Ab2KOQyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:54:53 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:33795 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768509Ab2KOQyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:54:52 -0500
Subject: [RFC v2 PATCH 1/2] sched: Revert temporary FAIR_GROUP_SCHED
 dependency for load-tracking
To: paulmck@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        a.p.zijlstra@chello.nl, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, amit.kucheria@linaro.org,
        Morten.Rasmussen@arm.com, paul.mckenney@linaro.org,
        akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org, pjt@google.com
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: venki@google.com, robin.randhawa@arm.com, linaro-dev@lists.linaro.org,
        suresh.b.siddha@intel.com, mjg59@srcf.ucam.org,
        deepthi@linux.vnet.ibm.com, srivatsa.bhat@linux.vnet.ibm.com,
        Arvind.Chauhan@arm.com, linux-arm-kernel@lists.infradead.org
Date: Thu, 15 Nov 2012 22:24:06 +0530
Message-ID: <20121115165406.17426.44039.stgit@preeti.in.ibm.com>
In-Reply-To: <20121115164730.17426.36051.stgit@preeti.in.ibm.com>
References: <20121115164730.17426.36051.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12111516-1618-0000-0000-000002D97805
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we need the per-entity load tracking for load balancing,
trivially revert the patch which introduced the FAIR_GROUP_SCHED
dependence for load tracking.

Signed-off-by: Preeti U Murthy<preeti@linux.vnet.ibm.com>
---
 include/linux/sched.h |    7 +------
 kernel/sched/core.c   |    7 +------
 kernel/sched/fair.c   |   12 +-----------
 kernel/sched/sched.h  |    7 -------
 4 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 03be150..087dd20 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1169,12 +1169,7 @@ struct sched_entity {
 	/* rq "owned" by this entity/group: */
 	struct cfs_rq		*my_q;
 #endif
-/*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+#if defined(CONFIG_SMP)
 	/* Per-entity load-tracking */
 	struct sched_avg	avg;
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c2e077c..24d8b9b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1526,12 +1526,7 @@ static void __sched_fork(struct task_struct *p)
 	p->se.vruntime			= 0;
 	INIT_LIST_HEAD(&p->se.group_node);
 
-/*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+#if defined(CONFIG_SMP)
 	p->se.avg.runnable_avg_period = 0;
 	p->se.avg.runnable_avg_sum = 0;
 #endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2cebc81..a9cdc8f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1149,8 +1149,7 @@ static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-/* Only depends on SMP, FAIR_GROUP_SCHED may be removed when useful in lb */
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+#if defined(CONFIG_SMP)
 /*
  * We choose a half-life close to 1 scheduling period.
  * Note: The tables below are dependent on this value.
@@ -3503,12 +3502,6 @@ unlock:
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
@@ -3531,7 +3524,6 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 		atomic64_add(se->avg.load_avg_contrib, &cfs_rq->removed_load);
 	}
 }
-#endif
 #endif /* CONFIG_SMP */
 
 static unsigned long
@@ -6416,9 +6408,7 @@ const struct sched_class fair_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_fair,
-#ifdef CONFIG_FAIR_GROUP_SCHED
 	.migrate_task_rq	= migrate_task_rq_fair,
-#endif
 	.rq_online		= rq_online_fair,
 	.rq_offline		= rq_offline_fair,
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 508e77e..bfd004a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -226,12 +226,6 @@ struct cfs_rq {
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
@@ -241,7 +235,6 @@ struct cfs_rq {
 	u64 runnable_load_avg, blocked_load_avg;
 	atomic64_t decay_counter, removed_load;
 	u64 last_decay;
-#endif /* CONFIG_FAIR_GROUP_SCHED */
 /* These always depend on CONFIG_FAIR_GROUP_SCHED */
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	u32 tg_runnable_contrib;

