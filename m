Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890Ab2HIWev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 18:34:51 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3495 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab2HIWet convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 18:34:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 09 Aug 2012 15:34:49 -0700
From: Peter Boonstoppel <pboonstoppel@nvidia.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Date: Thu, 9 Aug 2012 15:34:47 -0700
Subject: [PATCH 1/1] sched: unthrottle rt runqueues in __disable_runtime()
Thread-Topic: [PATCH 1/1] sched: unthrottle rt runqueues in
 __disable_runtime()
Thread-Index: AQHNdnxkmK9n7MnoZU6UiybaJm1h9Q==
Message-ID: <5FBF8E85CA34454794F0F7ECBA79798F379D3648B7@HQMAIL04.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

migrate_tasks() uses _pick_next_task_rt() to get tasks from the
real-time runqueues to be migrated. When rt_rq is throttled
_pick_next_task_rt() won't return anything, in which case
migrate_tasks() can't move all threads over and gets stuck in an
infinite loop.

Instead unthrottle rt runqueues before migrating tasks.

Additionally: move unthrottle_offline_cfs_rqs() to rq_offline_fair()

Signed-off-by: Peter Boonstoppel <pboonstoppel@nvidia.com>
---
 kernel/sched/core.c  |    3 ---
 kernel/sched/fair.c  |    7 +++++--
 kernel/sched/rt.c    |    1 +
 kernel/sched/sched.h |    1 -
 4 files changed, 6 insertions(+), 6 deletions(-)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2df035a..2e7ecff 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5221,9 +5221,6 @@ static void migrate_tasks(unsigned int dead_cpu)
 	 */
 	rq->stop = NULL;
 
-	/* Ensure any throttled groups are reachable by pick_next_task */
-	unthrottle_offline_cfs_rqs(rq);
-
 	for ( ; ; ) {
 		/*
 		 * There's this thread running, bail when that's the only
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3704ad3..dc8341b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2057,7 +2057,7 @@ static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	hrtimer_cancel(&cfs_b->slack_timer);
 }
 
-void unthrottle_offline_cfs_rqs(struct rq *rq)
+static void unthrottle_offline_cfs_rqs(struct rq *rq)
 {
 	struct cfs_rq *cfs_rq;
 
@@ -2111,7 +2111,7 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
 	return NULL;
 }
 static inline void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
-void unthrottle_offline_cfs_rqs(struct rq *rq) {}
+static inline void unthrottle_offline_cfs_rqs(struct rq *rq) {}
 
 #endif /* CONFIG_CFS_BANDWIDTH */
 
@@ -5086,6 +5086,9 @@ static void rq_online_fair(struct rq *rq)
 static void rq_offline_fair(struct rq *rq)
 {
 	update_sysctl();
+
+	/* Ensure any throttled groups are reachable by pick_next_task */
+	unthrottle_offline_cfs_rqs(rq);
 }
 
 #endif /* CONFIG_SMP */
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 573e1ca..b9a94fb 100644
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
index 4134d37..5d9aabe 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1167,7 +1167,6 @@ extern void print_rt_stats(struct seq_file *m, int cpu);
 
 extern void init_cfs_rq(struct cfs_rq *cfs_rq);
 extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
-extern void unthrottle_offline_cfs_rqs(struct rq *rq);
 
 extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
 
-- 
1.7.0.4