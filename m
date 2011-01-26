Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab1AZMLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:11:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:39714 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab1AZMLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:11:31 -0500
Date: Wed, 26 Jan 2011 12:11:04 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110122044851.915214637@google.com>
References: <20110122044851.915214637@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Simplify update_cfs_shares parameters
Message-ID: <tip-6d5ab2932a21ea54406ab95c43ecff90a3eddfda@git.kernel.org>
Git-Commit-ID: 6d5ab2932a21ea54406ab95c43ecff90a3eddfda
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 12:11:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d5ab2932a21ea54406ab95c43ecff90a3eddfda
Gitweb:     http://git.kernel.org/tip/6d5ab2932a21ea54406ab95c43ecff90a3eddfda
Author:     Paul Turner <pjt@google.com>
AuthorDate: Fri, 21 Jan 2011 20:45:01 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 12:33:19 +0100

sched: Simplify update_cfs_shares parameters

Re-visiting this: Since update_cfs_shares will now only ever re-weight an
entity that is a relative parent of the current entity in enqueue_entity; we
can safely issue the account_entity_enqueue relative to that cfs_rq and avoid
the requirement for special handling of the enqueue case in update_cfs_shares.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110122044851.915214637@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |    2 +-
 kernel/sched_fair.c |   30 ++++++++++++++----------------
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 18d38e4..e0fa3ff 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8510,7 +8510,7 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 		/* Propagate contribution to hierarchy */
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		for_each_sched_entity(se)
-			update_cfs_shares(group_cfs_rq(se), 0);
+			update_cfs_shares(group_cfs_rq(se));
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
 	}
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0c26e2d..0c550c8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -540,7 +540,7 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update);
-static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta);
+static void update_cfs_shares(struct cfs_rq *cfs_rq);
 
 /*
  * Update the current task's runtime statistics. Skip current tasks that
@@ -763,16 +763,15 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 		list_del_leaf_cfs_rq(cfs_rq);
 }
 
-static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg,
-				long weight_delta)
+static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 {
 	long load_weight, load, shares;
 
-	load = cfs_rq->load.weight + weight_delta;
+	load = cfs_rq->load.weight;
 
 	load_weight = atomic_read(&tg->load_weight);
-	load_weight -= cfs_rq->load_contribution;
 	load_weight += load;
+	load_weight -= cfs_rq->load_contribution;
 
 	shares = (tg->shares * load);
 	if (load_weight)
@@ -790,7 +789,7 @@ static void update_entity_shares_tick(struct cfs_rq *cfs_rq)
 {
 	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
 		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq, 0);
+		update_cfs_shares(cfs_rq);
 	}
 }
 # else /* CONFIG_SMP */
@@ -798,8 +797,7 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 {
 }
 
-static inline long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg,
-				long weight_delta)
+static inline long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 {
 	return tg->shares;
 }
@@ -824,7 +822,7 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 		account_entity_enqueue(cfs_rq, se);
 }
 
-static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
+static void update_cfs_shares(struct cfs_rq *cfs_rq)
 {
 	struct task_group *tg;
 	struct sched_entity *se;
@@ -838,7 +836,7 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
 	if (likely(se->load.weight == tg->shares))
 		return;
 #endif
-	shares = calc_cfs_shares(cfs_rq, tg, weight_delta);
+	shares = calc_cfs_shares(cfs_rq, tg);
 
 	reweight_entity(cfs_rq_of(se), se, shares);
 }
@@ -847,7 +845,7 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 {
 }
 
-static inline void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
+static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
 {
 }
 
@@ -978,8 +976,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 */
 	update_curr(cfs_rq);
 	update_cfs_load(cfs_rq, 0);
-	update_cfs_shares(cfs_rq, se->load.weight);
 	account_entity_enqueue(cfs_rq, se);
+	update_cfs_shares(cfs_rq);
 
 	if (flags & ENQUEUE_WAKEUP) {
 		place_entity(cfs_rq, se, 0);
@@ -1041,7 +1039,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
 	update_min_vruntime(cfs_rq);
-	update_cfs_shares(cfs_rq, 0);
+	update_cfs_shares(cfs_rq);
 
 	/*
 	 * Normalize the entity after updating the min_vruntime because the
@@ -1282,7 +1280,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
 		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq, 0);
+		update_cfs_shares(cfs_rq);
 	}
 
 	hrtick_update(rq);
@@ -1312,7 +1310,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
 		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq, 0);
+		update_cfs_shares(cfs_rq);
 	}
 
 	hrtick_update(rq);
@@ -2123,7 +2121,7 @@ static int update_shares_cpu(struct task_group *tg, int cpu)
 	 * We need to update shares after updating tg->load_weight in
 	 * order to adjust the weight of groups with long running tasks.
 	 */
-	update_cfs_shares(cfs_rq, 0);
+	update_cfs_shares(cfs_rq);
 
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
