Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab1AXNH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 08:07:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53114 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab1AXNH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 08:07:58 -0500
Date: Mon, 24 Jan 2011 14:07:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fix
Message-ID: <20110124130745.GA26948@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Yong Zhang (1):
      sched: Fix poor interactivity on UP systems due to group scheduler nice tune bug


 kernel/sched_fair.c |   78 ++++++++++++++++++++++++++++++++++----------------
 1 files changed, 53 insertions(+), 25 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 77e9166..3547699 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -699,7 +699,8 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	cfs_rq->nr_running--;
 }
 
-#if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_FAIR_GROUP_SCHED
+# ifdef CONFIG_SMP
 static void update_cfs_rq_load_contribution(struct cfs_rq *cfs_rq,
 					    int global_update)
 {
@@ -762,6 +763,51 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 		list_del_leaf_cfs_rq(cfs_rq);
 }
 
+static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg,
+				long weight_delta)
+{
+	long load_weight, load, shares;
+
+	load = cfs_rq->load.weight + weight_delta;
+
+	load_weight = atomic_read(&tg->load_weight);
+	load_weight -= cfs_rq->load_contribution;
+	load_weight += load;
+
+	shares = (tg->shares * load);
+	if (load_weight)
+		shares /= load_weight;
+
+	if (shares < MIN_SHARES)
+		shares = MIN_SHARES;
+	if (shares > tg->shares)
+		shares = tg->shares;
+
+	return shares;
+}
+
+static void update_entity_shares_tick(struct cfs_rq *cfs_rq)
+{
+	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
+		update_cfs_load(cfs_rq, 0);
+		update_cfs_shares(cfs_rq, 0);
+	}
+}
+# else /* CONFIG_SMP */
+static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
+{
+}
+
+static inline long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg,
+				long weight_delta)
+{
+	return tg->shares;
+}
+
+static inline void update_entity_shares_tick(struct cfs_rq *cfs_rq)
+{
+}
+# endif /* CONFIG_SMP */
 static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 			    unsigned long weight)
 {
@@ -782,7 +828,7 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
 {
 	struct task_group *tg;
 	struct sched_entity *se;
-	long load_weight, load, shares;
+	long shares;
 
 	if (!cfs_rq)
 		return;
@@ -791,32 +837,14 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
 	se = tg->se[cpu_of(rq_of(cfs_rq))];
 	if (!se)
 		return;
-
-	load = cfs_rq->load.weight + weight_delta;
-
-	load_weight = atomic_read(&tg->load_weight);
-	load_weight -= cfs_rq->load_contribution;
-	load_weight += load;
-
-	shares = (tg->shares * load);
-	if (load_weight)
-		shares /= load_weight;
-
-	if (shares < MIN_SHARES)
-		shares = MIN_SHARES;
-	if (shares > tg->shares)
-		shares = tg->shares;
+#ifndef CONFIG_SMP
+	if (likely(se->load.weight == tg->shares))
+		return;
+#endif
+	shares = calc_cfs_shares(cfs_rq, tg, weight_delta);
 
 	reweight_entity(cfs_rq_of(se), se, shares);
 }
-
-static void update_entity_shares_tick(struct cfs_rq *cfs_rq)
-{
-	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
-		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq, 0);
-	}
-}
 #else /* CONFIG_FAIR_GROUP_SCHED */
 static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 {
