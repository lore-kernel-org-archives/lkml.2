Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab1AXKxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 05:53:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:56152 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab1AXKxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 05:53:23 -0500
Date: Mon, 24 Jan 2011 10:51:52 GMT
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, peterz@infradead.org, efault@gmx.de,
        penberg@kernel.org, christian@nerdbynature.de, mfwitten@gmail.com,
        tglx@linutronix.de, yong.zhang0@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, penberg@kernel.org, efault@gmx.de,
        peterz@infradead.org, christian@nerdbynature.de, mfwitten@gmail.com,
        tglx@linutronix.de, yong.zhang0@gmail.com, mingo@elte.hu
In-Reply-To: <20110124073352.GA24186@windriver.com>
References: <20110124073352.GA24186@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix poor interactivity on UP systems due to group scheduler nice tune bug
Message-ID: <tip-3ff6dcac735704824c1dff64dc6863c390d364cc@git.kernel.org>
Git-Commit-ID: 3ff6dcac735704824c1dff64dc6863c390d364cc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 24 Jan 2011 10:51:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ff6dcac735704824c1dff64dc6863c390d364cc
Gitweb:     http://git.kernel.org/tip/3ff6dcac735704824c1dff64dc6863c390d364cc
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Mon, 24 Jan 2011 15:33:52 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 24 Jan 2011 11:47:50 +0100

sched: Fix poor interactivity on UP systems due to group scheduler nice tune bug

Michael Witten and Christian Kujau reported that the autogroup
scheduling feature hurts interactivity on their UP systems.

It turns out that this is an older bug in the group scheduling code,
and the wider appeal provided by the autogroup feature exposed it
more prominently.

When on UP with FAIR_GROUP_SCHED enabled, tune shares
only affect tg->shares, but is not reflected in
tg->se->load. The reason is that update_cfs_shares()
does nothing on UP.

So introduce update_cfs_shares() for UP && FAIR_GROUP_SCHED.

This issue was found when enable autogroup scheduling was enabled,
but it is an older bug that also exists on cgroup.cpu on UP.

Reported-and-Tested-by: Michael Witten <mfwitten@gmail.com>
Reported-and-Tested-by: Christian Kujau <christian@nerdbynature.de>
Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20110124073352.GA24186@windriver.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
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
