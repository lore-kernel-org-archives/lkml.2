Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab2JXJvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:51:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54947 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2JXJvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:51:31 -0400
Date: Wed, 24 Oct 2012 02:49:43 -0700
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-c566e8e9e44b72b53091da20e2dedefc730f2ee2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
In-Reply-To: <20120823141506.792901086@google.com>
References: <20120823141506.792901086@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Aggregate total task_group load
Git-Commit-ID: c566e8e9e44b72b53091da20e2dedefc730f2ee2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:49:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c566e8e9e44b72b53091da20e2dedefc730f2ee2
Gitweb:     http://git.kernel.org/tip/c566e8e9e44b72b53091da20e2dedefc730f2ee2
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 4 Oct 2012 13:18:30 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:27:24 +0200

sched: Aggregate total task_group load

Maintain a global running sum of the average load seen on each cfs_rq belonging
to each task group so that it may be used in calculating an appropriate
shares:weight distribution.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Ben Segall <bsegall@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120823141506.792901086@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/debug.c |    4 ++++
 kernel/sched/fair.c  |   22 ++++++++++++++++++++++
 kernel/sched/sched.h |    4 ++++
 3 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 2d2e2b3..2908923 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -230,6 +230,10 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
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
index 74dc29b..db78822 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1102,6 +1102,26 @@ static inline u64 __synchronize_entity_decay(struct sched_entity *se)
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
@@ -1172,6 +1192,8 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 		atomic64_add(decays, &cfs_rq->decay_counter);
 		cfs_rq->last_decay = now;
 	}
+
+	__update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
 }
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 30236ab..924a990 100644
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
