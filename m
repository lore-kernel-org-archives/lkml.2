Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab1GGFez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 01:34:55 -0400
Received: from smtp-out.google.com ([74.125.121.67]:3609 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab1GGFdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 01:33:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=hE93jGjKcde138wkJuJrP8BDnyqt16fDC0f6YaSAVeIZuLmA9f1lhC8BKEOc43ubZ
	AAWKtL7Q+f6Z2S58Ze+Ow==
Message-Id: <20110707053101.021543562@google.com>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jul 2011 22:30:50 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Hu Tao <hutao@cn.fujitsu.com>
Subject: [patch 14/17] sched: throttle entities exceeding their allowed bandwidth
References: <20110707053036.173186930@google.com>
Content-Disposition: inline; filename=sched-bwc-enable-throttling.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

---
 kernel/sched_fair.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -989,6 +989,8 @@ place_entity(struct cfs_rq *cfs_rq, stru
 	se->vruntime = vruntime;
 }
 
+static void check_enqueue_throttle(struct cfs_rq *cfs_rq);
+
 static void
 enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
@@ -1018,8 +1020,10 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 		__enqueue_entity(cfs_rq, se);
 	se->on_rq = 1;
 
-	if (cfs_rq->nr_running == 1)
+	if (cfs_rq->nr_running == 1) {
 		list_add_leaf_cfs_rq(cfs_rq);
+		check_enqueue_throttle(cfs_rq);
+	}
 }
 
 static void __clear_buddies_last(struct sched_entity *se)
@@ -1224,6 +1228,8 @@ static struct sched_entity *pick_next_en
 	return se;
 }
 
+static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq);
+
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
 	/*
@@ -1233,6 +1239,9 @@ static void put_prev_entity(struct cfs_r
 	if (prev->on_rq)
 		update_curr(cfs_rq);
 
+	/* throttle cfs_rqs exceeding runtime */
+	check_cfs_rq_runtime(cfs_rq);
+
 	check_spread(cfs_rq, prev);
 	if (prev->on_rq) {
 		update_stats_wait_start(cfs_rq, prev);
@@ -1518,6 +1527,43 @@ static void throttle_cfs_rq(struct cfs_r
 	raw_spin_unlock(&cfs_b->lock);
 }
 
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
+
 static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	struct rq *rq = rq_of(cfs_rq);
@@ -1656,6 +1702,8 @@ static int do_sched_cfs_period_timer(str
 #else
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec) {}
+static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
 
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 {


