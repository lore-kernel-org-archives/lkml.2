Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762628Ab2FVRts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 13:49:48 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3830 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab2FVRtq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 13:49:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 22 Jun 2012 10:49:26 -0700
From: Peter Boonstoppel <pboonstoppel@nvidia.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "mingo@kernel.org" <mingo@kernel.org>, "pjt@google.com" <pjt@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "seto.hidetoshi@jp.fujitsu.com" <seto.hidetoshi@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Fri, 22 Jun 2012 10:49:26 -0700
Subject: [PATCH 1/1] sched: unthrottle rt runqueues in __disable_runtime()
Thread-Topic: [PATCH 1/1] sched: unthrottle rt runqueues in
 __disable_runtime()
Thread-Index: AQHNUJ7wp5PbwsElmEKldHs+t/RLiQ==
Message-ID: <5FBF8E85CA34454794F0F7ECBA79798F379D3647F0@HQMAIL04.nvidia.com>
References: <5FBF8E85CA34454794F0F7ECBA79798F379AD507F2@HQMAIL04.nvidia.com>,<1337957361.9783.213.camel@laptop>
In-Reply-To: <1337957361.9783.213.camel@laptop>
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