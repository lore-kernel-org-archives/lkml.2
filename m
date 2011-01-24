Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab1AXHfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 02:35:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:38452 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab1AXHfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 02:35:30 -0500
Date: Mon, 24 Jan 2011 15:33:52 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, mfwitten@gmail.com,
        christian@nerdbynature.de, a.p.zijlstra@chello.nl,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH V3] sched: fix autogroup nice tune on UP
Message-ID: <20110124073352.GA24186@windriver.com>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110123150341.GA2643@zhy>
 <1295847626-2396-1-git-send-email-yong.zhang0@gmail.com>
 <AANLkTi=gRO0tCdEzmn3Ne6Wj6bXd1G8nhLw2E_-Yw3WA@mail.gmail.com>
 <AANLkTi=3f8nvEuFbHqjnTXtrK_sAC-A9+XAMjAHgjT3d@mail.gmail.com>
 <AANLkTikLnOXOAeBgMQCcOqgNP1WrVf9QeFEkgthTbU2N@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTikLnOXOAeBgMQCcOqgNP1WrVf9QeFEkgthTbU2N@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 24 Jan 2011 07:33:54.0104 (UTC) FILETIME=[0D7F7B80:01CBBB99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 08:18:11AM +0200, Pekka Enberg wrote:
> I proposed extracting the shares calculation logic in
> update_cfs_shares() to reduce code duplication for the SMP and UP
> patch. So something like this:

Thanks for your example.
So something like this?

---
From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH V3] sched: fix autogroup nice tune on UP

When on UP with FAIR_GROUP_SCHED enabled, tune shares
only affect tg->shares, but is not reflected on
tg->se->load, the reason is update_cfs_shares()
do nothing on UP.
So introduce update_cfs_shares() for UP && FAIR_GROUP_SCHED.

This issue is found when enable autogroup, but also
exists on cgroup.cpu on UP.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
---

Changelog from V2:
  Move share caculation to calc_cfs_shares(), thus save
  some duplicated code for update_cfs_shares().
  Idea from Pekka Enberg.

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
-- 
1.7.0.4

