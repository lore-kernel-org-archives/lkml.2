Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab2BBBnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:43:31 -0500
Received: from mail-gy0-f202.google.com ([209.85.160.202]:51746 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab2BBBnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:43:22 -0500
Subject: [RFC PATCH 06/14] sched: aggregate total task_group load
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 01 Feb 2012 17:38:26 -0800
Message-ID: <20120202013826.20844.94427.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
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
 kernel/sched/fair.c  |   17 +++++++++++++++++
 kernel/sched/sched.h |    2 ++
 3 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index a638d9d..f6227c0 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -228,6 +228,10 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
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
index c9a8f6d..7771003 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1111,6 +1111,21 @@ static long __update_entity_load_avg_contrib(struct sched_entity *se)
 	return se->avg.load_avg_contrib - old_contrib;
 }
 
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
+
 static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
 						 long load_contrib)
 {
@@ -1166,6 +1181,8 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 		atomic64_add(decays, &cfs_rq->decay_counter);
 		cfs_rq->last_decay = now;
 	}
+
+	__update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
 }
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 9f45b49..17f99e7 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -116,6 +116,7 @@ struct task_group {
 	unsigned long shares;
 
 	atomic_t load_weight;
+	atomic64_t load_avg;
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -272,6 +273,7 @@ struct cfs_rq {
 	unsigned long load_contribution;
 
 	u64 runnable_load_avg, blocked_load_avg;
+	u64 tg_load_contrib;
 	atomic64_t decay_counter, removed_load;
 	u64 last_decay;
 #endif /* CONFIG_SMP */


