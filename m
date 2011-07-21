Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1GUXB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 19:01:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:53694 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab1GUXBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 19:01:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=U04ZBCpc4OfSP+jiGDIY+aqpbItW2ewATJx9fXF7Lwn2nonKd+WHdTh+hmgUxvmdP
	rT7Pxp2+VmAApZsKjDr7g==
Message-Id: <20110721184758.091415417@google.com>
User-Agent: quilt/0.48-1
Date: Thu, 21 Jul 2011 09:43:39 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Jason Baron <jbaron@redhat.com>
Subject: [patch 14/18] sched: throttle entities exceeding their allowed bandwidth
References: <20110721164325.231521704@google.com>
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
 kernel/sched_fair.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

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
@@ -1486,7 +1495,7 @@ static int tg_throttle_down(struct task_
 	return 0;
 }
 
-static __used void throttle_cfs_rq(struct cfs_rq *cfs_rq)
+static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	struct rq *rq = rq_of(cfs_rq);
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
@@ -1679,9 +1688,48 @@ out_unlock:
 
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


