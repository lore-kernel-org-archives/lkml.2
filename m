Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab1HNQgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:36:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:44219 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab1HNQgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:36:12 -0400
Date: Sun, 14 Aug 2011 16:35:50 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-d3d9dc3302368269acf94b7381663b93000fe2fe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110721184758.091415417@google.com>
References: <20110721184758.091415417@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Throttle entities exceeding their allowed bandwidth
Git-Commit-ID: d3d9dc3302368269acf94b7381663b93000fe2fe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:35:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3d9dc3302368269acf94b7381663b93000fe2fe
Gitweb:     http://git.kernel.org/tip/d3d9dc3302368269acf94b7381663b93000fe2fe
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 21 Jul 2011 09:43:39 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:03:47 +0200

sched: Throttle entities exceeding their allowed bandwidth

With the machinery in place to throttle and unthrottle entities, as well as
handle their participation (or lack there of) we can now enable throttling.

There are 2 points that we must check whether it's time to set throttled state:
 put_prev_entity() and enqueue_entity().

- put_prev_entity() is the typical throttle path, we reach it by exceeding our
  allocated run-time within update_curr()->account_cfs_rq_runtime() and going
  through a reschedule.

- enqueue_entity() covers the case of a wake-up into an already throttled
  group.  In this case we know the group cannot be on_rq and can throttle
  immediately.  Checks are added at time of put_prev_entity() and
  enqueue_entity()

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110721184758.091415417@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 1d4acbe..f9f671a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -970,6 +970,8 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	se->vruntime = vruntime;
 }
 
+static void check_enqueue_throttle(struct cfs_rq *cfs_rq);
+
 static void
 enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
@@ -999,8 +1001,10 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 		__enqueue_entity(cfs_rq, se);
 	se->on_rq = 1;
 
-	if (cfs_rq->nr_running == 1)
+	if (cfs_rq->nr_running == 1) {
 		list_add_leaf_cfs_rq(cfs_rq);
+		check_enqueue_throttle(cfs_rq);
+	}
 }
 
 static void __clear_buddies_last(struct sched_entity *se)
@@ -1202,6 +1206,8 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 	return se;
 }
 
+static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq);
+
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
 	/*
@@ -1211,6 +1217,9 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 	if (prev->on_rq)
 		update_curr(cfs_rq);
 
+	/* throttle cfs_rqs exceeding runtime */
+	check_cfs_rq_runtime(cfs_rq);
+
 	check_spread(cfs_rq, prev);
 	if (prev->on_rq) {
 		update_stats_wait_start(cfs_rq, prev);
@@ -1464,7 +1473,7 @@ static int tg_throttle_down(struct task_group *tg, void *data)
 	return 0;
 }
 
-static __used void throttle_cfs_rq(struct cfs_rq *cfs_rq)
+static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	struct rq *rq = rq_of(cfs_rq);
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
@@ -1657,9 +1666,48 @@ out_unlock:
 
 	return idle;
 }
+
+/*
+ * When a group wakes up we want to make sure that its quota is not already
+ * expired/exceeded, otherwise it may be allowed to steal additional ticks of
+ * runtime as update_curr() throttling can not not trigger until it's on-rq.
+ */
+static void check_enqueue_throttle(struct cfs_rq *cfs_rq)
+{
+	/* an active group must be handled by the update_curr()->put() path */
+	if (!cfs_rq->runtime_enabled || cfs_rq->curr)
+		return;
+
+	/* ensure the group is not already throttled */
+	if (cfs_rq_throttled(cfs_rq))
+		return;
+
+	/* update runtime allocation */
+	account_cfs_rq_runtime(cfs_rq, 0);
+	if (cfs_rq->runtime_remaining <= 0)
+		throttle_cfs_rq(cfs_rq);
+}
+
+/* conditionally throttle active cfs_rq's from put_prev_entity() */
+static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+{
+	if (likely(!cfs_rq->runtime_enabled || cfs_rq->runtime_remaining > 0))
+		return;
+
+	/*
+	 * it's possible for a throttled entity to be forced into a running
+	 * state (e.g. set_curr_task), in this case we're finished.
+	 */
+	if (cfs_rq_throttled(cfs_rq))
+		return;
+
+	throttle_cfs_rq(cfs_rq);
+}
 #else
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 				     unsigned long delta_exec) {}
+static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
 
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 {
