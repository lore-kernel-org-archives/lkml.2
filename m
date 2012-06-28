Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab2F1C5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:57:08 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:42932 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168Ab2F1C40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:56:26 -0400
Subject: [PATCH 16/16] sched: introduce temporary FAIR_GROUP_SCHED dependency
	for load-tracking
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 27 Jun 2012 19:24:15 -0700
Message-ID: <20120628022415.30496.18884.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While per-entity load-tracking is generally useful, beyond computing shares
distribution, e.g.
  runnable based load-balance (in progress), governors, power-management, etc

These facilities are not yet consumers of this data.  This may be trivially
reverted when the information is required; but avoid paying the overhead for
calculations we will not use until then.

Signed-off-by: Paul Turner <pjt@google.com>
---
 include/linux/sched.h |    8 +++++++-
 kernel/sched/fair.c   |   14 +++++++++++---
 kernel/sched/sched.h  |    9 ++++++++-
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a65c097..7c0c72d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1205,7 +1205,13 @@ struct sched_entity {
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
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3d1aaa8..0b6e2df 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -882,7 +882,8 @@ static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-#ifdef CONFIG_SMP
+/* Only depends on SMP, FAIR_GROUP_SCHED may be removed when useful in lb */
+#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
 /*
  * We choose a half-life close to 1 scheduling period.
  * Note: The tables below are dependent on this value.
@@ -3214,6 +3215,12 @@ unlock:
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
@@ -3235,7 +3242,7 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu) {
 		atomic64_add(se->avg.load_avg_contrib, &cfs_rq->removed_load);
 	}
 }
-
+#endif
 
 #endif /* CONFIG_SMP */
 
@@ -5927,8 +5934,9 @@ const struct sched_class fair_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_fair,
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	.migrate_task_rq	= migrate_task_rq_fair,
-
+#endif
 	.rq_online		= rq_online_fair,
 	.rq_offline		= rq_offline_fair,
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index bb76895..d920943 100644
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


