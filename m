Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab2IDSqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 14:46:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47832 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab2IDSqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 14:46:03 -0400
Date: Tue, 4 Sep 2012 11:45:45 -0700
From: tip-bot for Peter Boonstoppel <pboonstoppel@nvidia.com>
Message-ID: <tip-a4c96ae319b8047f62dedbe1eac79e321c185749@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, pboonstoppel@nvidia.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, pboonstoppel@nvidia.com,
        tglx@linutronix.de
In-Reply-To: <5FBF8E85CA34454794F0F7ECBA79798F379D3648B7@HQMAIL04.nvidia.com>
References: <5FBF8E85CA34454794F0F7ECBA79798F379D3648B7@HQMAIL04.nvidia.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Unthrottle rt runqueues in __disable_runtime()
Git-Commit-ID: a4c96ae319b8047f62dedbe1eac79e321c185749
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 04 Sep 2012 11:45:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4c96ae319b8047f62dedbe1eac79e321c185749
Gitweb:     http://git.kernel.org/tip/a4c96ae319b8047f62dedbe1eac79e321c185749
Author:     Peter Boonstoppel <pboonstoppel@nvidia.com>
AuthorDate: Thu, 9 Aug 2012 15:34:47 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Sep 2012 14:30:30 +0200

sched: Unthrottle rt runqueues in __disable_runtime()

migrate_tasks() uses _pick_next_task_rt() to get tasks from the
real-time runqueues to be migrated. When rt_rq is throttled
_pick_next_task_rt() won't return anything, in which case
migrate_tasks() can't move all threads over and gets stuck in an
infinite loop.

Instead unthrottle rt runqueues before migrating tasks.

Additionally: move unthrottle_offline_cfs_rqs() to rq_offline_fair()

Signed-off-by: Peter Boonstoppel <pboonstoppel@nvidia.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Link: http://lkml.kernel.org/r/5FBF8E85CA34454794F0F7ECBA79798F379D3648B7@HQMAIL04.nvidia.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  |    3 ---
 kernel/sched/fair.c  |    7 +++++--
 kernel/sched/rt.c    |    1 +
 kernel/sched/sched.h |    1 -
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 207a81c..a4ea245 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5342,9 +5342,6 @@ static void migrate_tasks(unsigned int dead_cpu)
 	 */
 	rq->stop = NULL;
 
-	/* Ensure any throttled groups are reachable by pick_next_task */
-	unthrottle_offline_cfs_rqs(rq);
-
 	for ( ; ; ) {
 		/*
 		 * There's this thread running, bail when that's the only
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c219bf8..86ad83c 100644
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
 
@@ -4956,6 +4956,9 @@ static void rq_online_fair(struct rq *rq)
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
 
