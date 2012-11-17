Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab2KQNGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 08:06:06 -0500
Received: from mga14.intel.com ([143.182.124.37]:25469 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab2KQNFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 08:05:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,270,1352102400"; 
   d="scan'208";a="219067125"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, pjt@google.com,
        preeti@linux.vnet.ibm.com, vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 5/5] sched: revert 'Introduce temporary FAIR_GROUP_SCHED dependency ...'
Date: Sat, 17 Nov 2012 21:04:17 +0800
Message-Id: <1353157457-3649-6-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353157457-3649-1-git-send-email-alex.shi@intel.com>
References: <1353157457-3649-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

revert commit f4e26b120b9de84cb627b for load-tracking patchset using in
kernel.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/sched.h |    8 +-------
 kernel/sched/core.c   |    7 +------
 kernel/sched/fair.c   |   12 +-----------
 kernel/sched/sched.h  |    9 +--------
 4 files changed, 4 insertions(+), 32 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8f65323..4ce885a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1169,13 +1169,7 @@ struct sched_entity {
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
index ee6d765..9f9615d 100644
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
+#ifdef CONFIG_SMP
 	p->se.avg.runnable_avg_period = 0;
 	p->se.avg.runnable_avg_sum = 0;
 #endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7064a13..3f7f732 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1149,8 +1149,7 @@ static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-/* Only depends on SMP, FAIR_GROUP_SCHED may be removed when useful in lb */
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+#ifdef CONFIG_SMP
 /*
  * We choose a half-life close to 1 scheduling period.
  * Note: The tables below are dependent on this value.
@@ -3457,7 +3456,6 @@ unlock:
 	return new_cpu;
 }
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
 static void migrate_task_rq_entity(struct task_struct *p, int next_cpu)
 {
 	struct sched_entity *se = &p->se;
@@ -3474,16 +3472,8 @@ static void migrate_task_rq_entity(struct task_struct *p, int next_cpu)
 		atomic64_add(se->avg.load_avg_contrib, &cfs_rq->removed_load);
 	}
 }
-#else
-static void migrate_task_rq_entity(struct task_struct *p, int next_cpu) { }
-#endif
 
 /*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-/*
  * Called immediately before a task is migrated to a new cpu; task_cpu(p) and
  * cfs_rq_of(p) references at time of call are still valid and identify the
  * previous cpu.  However, the caller only guarantees p->pi_lock is held; no
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index bb9475c..3a4a8d6 100644
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
@@ -241,8 +235,7 @@ struct cfs_rq {
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
1.7.5.4

