Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab0KRONu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:13:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:52216 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220Ab0KRONs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:13:48 -0500
Date: Thu, 18 Nov 2010 14:13:13 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20101115234938.377473595@google.com>
References: <20101115234938.377473595@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Allow update_cfs_load() to update global load
Message-ID: <tip-d6b5591829bd348a5fbe1c428d28dea00621cdba@git.kernel.org>
Git-Commit-ID: d6b5591829bd348a5fbe1c428d28dea00621cdba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:13:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d6b5591829bd348a5fbe1c428d28dea00621cdba
Gitweb:     http://git.kernel.org/tip/d6b5591829bd348a5fbe1c428d28dea00621cdba
Author:     Paul Turner <pjt@google.com>
AuthorDate: Mon, 15 Nov 2010 15:47:09 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 13:27:50 +0100

sched: Allow update_cfs_load() to update global load

Refactor the global load updates from update_shares_cpu() so that
update_cfs_load() can update global load when it is more than ~10%
out of sync.

The new global_load parameter allows us to force an update, regardless of
the error factor so that we can synchronize w/ update_shares().

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101115234938.377473595@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   44 +++++++++++++++++++++++++++++---------------
 1 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e7e2f08..390ce30 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -539,7 +539,7 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return calc_delta_fair(sched_slice(cfs_rq, se), se);
 }
 
-static void update_cfs_load(struct cfs_rq *cfs_rq);
+static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update);
 static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta);
 
 /*
@@ -565,7 +565,7 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	cfs_rq->load_unacc_exec_time += delta_exec;
 	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
-		update_cfs_load(cfs_rq);
+		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq, 0);
 	}
 #endif
@@ -704,7 +704,22 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 #if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
-static void update_cfs_load(struct cfs_rq *cfs_rq)
+static void update_cfs_rq_load_contribution(struct cfs_rq *cfs_rq,
+					    int global_update)
+{
+	struct task_group *tg = cfs_rq->tg;
+	long load_avg;
+
+	load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
+	load_avg -= cfs_rq->load_contribution;
+
+	if (global_update || abs(load_avg) > cfs_rq->load_contribution / 8) {
+		atomic_add(load_avg, &tg->load_weight);
+		cfs_rq->load_contribution += load_avg;
+	}
+}
+
+static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 {
 	u64 period = sysctl_sched_shares_window;
 	u64 now, delta;
@@ -731,6 +746,11 @@ static void update_cfs_load(struct cfs_rq *cfs_rq)
 		cfs_rq->load_avg += delta * load;
 	}
 
+	/* consider updating load contribution on each fold or truncate */
+	if (global_update || cfs_rq->load_period > period
+	    || !cfs_rq->load_period)
+		update_cfs_rq_load_contribution(cfs_rq, global_update);
+
 	while (cfs_rq->load_period > period) {
 		/*
 		 * Inline assembly required to prevent the compiler
@@ -790,7 +810,7 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
 	reweight_entity(cfs_rq_of(se), se, shares);
 }
 #else /* CONFIG_FAIR_GROUP_SCHED */
-static inline void update_cfs_load(struct cfs_rq *cfs_rq)
+static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 {
 }
 
@@ -920,7 +940,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	update_cfs_load(cfs_rq);
+	update_cfs_load(cfs_rq, 0);
 	update_cfs_shares(cfs_rq, se->load.weight);
 	account_entity_enqueue(cfs_rq, se);
 
@@ -981,7 +1001,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	se->on_rq = 0;
-	update_cfs_load(cfs_rq);
+	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
 	update_min_vruntime(cfs_rq);
 	update_cfs_shares(cfs_rq, 0);
@@ -1216,7 +1236,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
-		update_cfs_load(cfs_rq);
+		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq, 0);
 	}
 
@@ -1246,7 +1266,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
-		update_cfs_load(cfs_rq);
+		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq, 0);
 	}
 
@@ -2052,7 +2072,6 @@ static int update_shares_cpu(struct task_group *tg, int cpu)
 	struct cfs_rq *cfs_rq;
 	unsigned long flags;
 	struct rq *rq;
-	long load_avg;
 
 	if (!tg->se[cpu])
 		return 0;
@@ -2063,12 +2082,7 @@ static int update_shares_cpu(struct task_group *tg, int cpu)
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	update_rq_clock(rq);
-	update_cfs_load(cfs_rq);
-
-	load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
-	load_avg -= cfs_rq->load_contribution;
-	atomic_add(load_avg, &tg->load_weight);
-	cfs_rq->load_contribution += load_avg;
+	update_cfs_load(cfs_rq, 1);
 
 	/*
 	 * We need to update shares after updating tg->load_weight in
