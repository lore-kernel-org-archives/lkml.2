Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab1AXFmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 00:42:04 -0500
Received: from mail.windriver.com ([147.11.1.11]:55490 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab1AXFmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 00:42:03 -0500
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mfwitten@gmail.com, christian@nerdbynature.de, penberg@kernel.org,
        a.p.zijlstra@chello.nl, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH V2] sched: fix autogroup nice tune on UP
Date: Mon, 24 Jan 2011 13:40:26 +0800
Message-Id: <1295847626-2396-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20110123150341.GA2643@zhy>
References: <20110123150341.GA2643@zhy>
X-OriginalArrivalTime: 24 Jan 2011 05:40:30.0317 (UTC) FILETIME=[361FF9D0:01CBBB89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 kernel/sched_fair.c |   61 ++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 44 insertions(+), 17 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 77e9166..166892f 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -699,7 +699,24 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	cfs_rq->nr_running--;
 }
 
-#if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
+			    unsigned long weight)
+{
+	if (se->on_rq) {
+		/* commit outstanding execution time */
+		if (cfs_rq->curr == se)
+			update_curr(cfs_rq);
+		account_entity_dequeue(cfs_rq, se);
+	}
+
+	update_load_set(&se->load, weight);
+
+	if (se->on_rq)
+		account_entity_enqueue(cfs_rq, se);
+}
+
+# ifdef CONFIG_SMP
 static void update_cfs_rq_load_contribution(struct cfs_rq *cfs_rq,
 					    int global_update)
 {
@@ -762,22 +779,6 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 		list_del_leaf_cfs_rq(cfs_rq);
 }
 
-static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
-			    unsigned long weight)
-{
-	if (se->on_rq) {
-		/* commit outstanding execution time */
-		if (cfs_rq->curr == se)
-			update_curr(cfs_rq);
-		account_entity_dequeue(cfs_rq, se);
-	}
-
-	update_load_set(&se->load, weight);
-
-	if (se->on_rq)
-		account_entity_enqueue(cfs_rq, se);
-}
-
 static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
 {
 	struct task_group *tg;
@@ -817,6 +818,32 @@ static void update_entity_shares_tick(struct cfs_rq *cfs_rq)
 		update_cfs_shares(cfs_rq, 0);
 	}
 }
+# else /* CONFIG_SMP */
+static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
+{
+}
+
+static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
+{
+	struct task_group *tg;
+	struct sched_entity *se;
+
+	if (!cfs_rq)
+		return;
+
+	tg = cfs_rq->tg;
+	se = tg->se[0];
+	if (!se)
+		return;
+	if (likely(se->load.weight == tg->shares))
+		return;
+	reweight_entity(cfs_rq_of(se), se, tg->shares);
+}
+
+static inline void update_entity_shares_tick(struct cfs_rq *cfs_rq)
+{
+}
+# endif /* CONFIG_SMP */
 #else /* CONFIG_FAIR_GROUP_SCHED */
 static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 {
-- 
1.7.0.4

