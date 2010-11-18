Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab0KROMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:12:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:52081 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644Ab0KROMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:12:07 -0500
Date: Thu, 18 Nov 2010 14:11:35 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20101115234937.933428187@google.com>
References: <20101115234937.933428187@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix update_cfs_load() synchronization
Message-ID: <tip-e33078baa4d30ad1d0e46d1f62b9e5a63a3e6ee3@git.kernel.org>
Git-Commit-ID: e33078baa4d30ad1d0e46d1f62b9e5a63a3e6ee3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:11:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e33078baa4d30ad1d0e46d1f62b9e5a63a3e6ee3
Gitweb:     http://git.kernel.org/tip/e33078baa4d30ad1d0e46d1f62b9e5a63a3e6ee3
Author:     Paul Turner <pjt@google.com>
AuthorDate: Mon, 15 Nov 2010 15:47:04 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 13:27:48 +0100

sched: Fix update_cfs_load() synchronization

Using cfs_rq->nr_running is not sufficient to synchronize update_cfs_load with
the put path since nr_running accounting occurs at deactivation.

It's also not safe to make the removal decision based on load_avg as this fails
with both high periods and low shares.  Resolve this by clipping history after
4 periods without activity.

Note: the above will always occur from update_shares() since in the
last-task-sleep-case that task will still be cfs_rq->curr when update_cfs_load
is called.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101115234937.933428187@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |    2 +-
 kernel/sched_fair.c |   33 +++++++++++++++++++++------------
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6268d2d..dadab4d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -355,7 +355,7 @@ struct cfs_rq {
 
 	u64 load_avg;
 	u64 load_period;
-	u64 load_stamp;
+	u64 load_stamp, load_last;
 
 	unsigned long load_contribution;
 #endif
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index d52b97a..a543a5b 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -674,10 +674,11 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 #if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
-static void update_cfs_load(struct cfs_rq *cfs_rq, int lb)
+static void update_cfs_load(struct cfs_rq *cfs_rq)
 {
 	u64 period = sched_avg_period();
 	u64 now, delta;
+	unsigned long load = cfs_rq->load.weight;
 
 	if (!cfs_rq)
 		return;
@@ -685,9 +686,19 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int lb)
 	now = rq_of(cfs_rq)->clock;
 	delta = now - cfs_rq->load_stamp;
 
+	/* truncate load history at 4 idle periods */
+	if (cfs_rq->load_stamp > cfs_rq->load_last &&
+	    now - cfs_rq->load_last > 4 * period) {
+		cfs_rq->load_period = 0;
+		cfs_rq->load_avg = 0;
+	}
+
 	cfs_rq->load_stamp = now;
 	cfs_rq->load_period += delta;
-	cfs_rq->load_avg += delta * cfs_rq->load.weight;
+	if (load) {
+		cfs_rq->load_last = now;
+		cfs_rq->load_avg += delta * load;
+	}
 
 	while (cfs_rq->load_period > period) {
 		/*
@@ -700,10 +711,8 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int lb)
 		cfs_rq->load_avg /= 2;
 	}
 
-	if (lb && !cfs_rq->nr_running) {
-		if (cfs_rq->load_avg < (period / 8))
-			list_del_leaf_cfs_rq(cfs_rq);
-	}
+	if (!cfs_rq->curr && !cfs_rq->nr_running && !cfs_rq->load_avg)
+		list_del_leaf_cfs_rq(cfs_rq);
 }
 
 static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
@@ -750,7 +759,7 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
 	reweight_entity(cfs_rq_of(se), se, shares);
 }
 #else /* CONFIG_FAIR_GROUP_SCHED */
-static inline void update_cfs_load(struct cfs_rq *cfs_rq, int lb)
+static inline void update_cfs_load(struct cfs_rq *cfs_rq)
 {
 }
 
@@ -880,7 +889,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	update_cfs_load(cfs_rq, 0);
+	update_cfs_load(cfs_rq);
 	update_cfs_shares(cfs_rq, se->load.weight);
 	account_entity_enqueue(cfs_rq, se);
 
@@ -941,7 +950,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	se->on_rq = 0;
-	update_cfs_load(cfs_rq, 0);
+	update_cfs_load(cfs_rq);
 	account_entity_dequeue(cfs_rq, se);
 	update_min_vruntime(cfs_rq);
 	update_cfs_shares(cfs_rq, 0);
@@ -1176,7 +1185,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
-		update_cfs_load(cfs_rq, 0);
+		update_cfs_load(cfs_rq);
 		update_cfs_shares(cfs_rq, 0);
 	}
 
@@ -1206,7 +1215,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
-		update_cfs_load(cfs_rq, 0);
+		update_cfs_load(cfs_rq);
 		update_cfs_shares(cfs_rq, 0);
 	}
 
@@ -2023,7 +2032,7 @@ static int tg_shares_up(struct task_group *tg, int cpu)
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	update_rq_clock(rq);
-	update_cfs_load(cfs_rq, 1);
+	update_cfs_load(cfs_rq);
 
 	load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
 	load_avg -= cfs_rq->load_contribution;
