Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab1FUHVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:21:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:43097 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab1FUHVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:21:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=UkVS5v0BGSQdznFm5H+bgs9nUDaLiAVpP7wAJ95uYtrRQgwAY28JCaeOTrJH4FU0W
	/I+imr89MzD2WScOjk+QA==
Message-Id: <20110621071700.700763369@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 21 Jun 2011 00:16:59 -0700
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
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: [patch 10/16] sched: throttle entities exceeding their allowed bandwidth
References: <20110621071649.862846205@google.com>
Content-Disposition: inline; filename=sched-bwc-enable-throttling.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add conditional checks time of put_prev_entity() and enqueue_entity() to detect
when an active entity has exceeded its allowed bandwidth and requires
throttling.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched_fair.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 2 deletions(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -987,6 +987,8 @@ place_entity(struct cfs_rq *cfs_rq, stru
 	se->vruntime = vruntime;
 }
 
+static void check_enqueue_throttle(struct cfs_rq *cfs_rq);
+
 static void
 enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
@@ -1016,8 +1018,10 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 		__enqueue_entity(cfs_rq, se);
 	se->on_rq = 1;
 
-	if (cfs_rq->nr_running == 1)
+	if (cfs_rq->nr_running == 1) {
 		list_add_leaf_cfs_rq(cfs_rq);
+		check_enqueue_throttle(cfs_rq);
+	}
 }
 
 static void __clear_buddies_last(struct sched_entity *se)
@@ -1222,6 +1226,8 @@ static struct sched_entity *pick_next_en
 	return se;
 }
 
+static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq);
+
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
 	/*
@@ -1231,6 +1237,9 @@ static void put_prev_entity(struct cfs_r
 	if (prev->on_rq)
 		update_curr(cfs_rq);
 
+	/* throttle cfs_rqs exceeding runtime */
+	check_cfs_rq_runtime(cfs_rq);
+
 	check_spread(cfs_rq, prev);
 	if (prev->on_rq) {
 		update_stats_wait_start(cfs_rq, prev);
@@ -1403,7 +1412,7 @@ static void account_cfs_rq_runtime(struc
 	 * if we're unable to extend our runtime we resched so that the active
 	 * hierarchy can be throttled
 	 */
-	if (!assign_cfs_rq_runtime(cfs_rq))
+	if (!assign_cfs_rq_runtime(cfs_rq) && likely(cfs_rq->curr))
 		resched_task(rq_of(cfs_rq)->curr);
 }
 
@@ -1448,6 +1457,46 @@ static void throttle_cfs_rq(struct cfs_r
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
+	if (!cfs_rq->runtime_enabled || cfs_rq->runtime_remaining > 0)
+		return;
+
+	/*
+	 * as the alignment of the last vestiges of per-cpu quota is not
+	 * controllable it's possible that active load-balance will force a
+	 * thread belonging to an unthrottled cfs_rq on cpu A to into a running
+	 * state on a throttled cfs_rq on cpu B.  In this case we're already
+	 * throttled.
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
@@ -1586,6 +1635,8 @@ out_unlock:
 #else
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec) {}
+static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
 
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 {


