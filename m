Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab2F1C7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:59:46 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:55192 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab2F1C4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:56:25 -0400
Subject: [PATCH 07/16] sched: aggregate total task_group load
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
Date: Wed, 27 Jun 2012 19:24:14 -0700
Message-ID: <20120628022414.30496.32293.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maintain a global running sum of the average load seen on each cfs_rq belonging
to each task group so that it may be used in calculating an appropriate
shares:weight distribution.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Ben Segall <bsegall@google.com>
---
 kernel/sched/debug.c |    4 ++++
 kernel/sched/fair.c  |   22 ++++++++++++++++++++++
 kernel/sched/sched.h |    4 ++++
 3 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 2aa60cf..9268fb7 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -233,6 +233,10 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			cfs_rq->runnable_load_avg);
 	SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
+	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
+			atomic64_read(&cfs_rq->tg->load_avg));
+	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_contrib",
+			cfs_rq->tg_load_contrib);
 #endif
 
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ea3d4f5..fbb9686 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1101,6 +1101,26 @@ static inline u64 __synchronize_entity_decay(struct sched_entity *se)
 	return decays;
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
+						 int force_update)
+{
+	struct task_group *tg = cfs_rq->tg;
+	s64 tg_contrib;
+
+	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
+	tg_contrib -= cfs_rq->tg_load_contrib;
+
+	if (force_update || abs64(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
+		atomic64_add(tg_contrib, &tg->load_avg);
+		cfs_rq->tg_load_contrib += tg_contrib;
+	}
+}
+#else
+static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
+						 int force_update) {}
+#endif
+
 /* Compute the current contribution to load_avg by se, return any delta */
 static long __update_entity_load_avg_contrib(struct sched_entity *se)
 {
@@ -1171,6 +1191,8 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 		atomic64_add(decays, &cfs_rq->decay_counter);
 		cfs_rq->last_decay = now;
 	}
+
+	__update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
 }
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ca1003d..4d3b3ad 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -112,6 +112,7 @@ struct task_group {
 	unsigned long shares;
 
 	atomic_t load_weight;
+	atomic64_t load_avg;
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -232,6 +233,9 @@ struct cfs_rq {
 	u64 runnable_load_avg, blocked_load_avg;
 	atomic64_t decay_counter, removed_load;
 	u64 last_decay;
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	u64 tg_load_contrib;
+#endif
 #endif
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */


