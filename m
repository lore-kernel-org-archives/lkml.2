Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab0HKWpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 18:45:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756891Ab0HKWoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 18:44:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: vgoyal@redhat.com
Subject: [PATCH 2/5] cfq-iosched: Do group share accounting in IOPS when slice_idle=0
Date: Wed, 11 Aug 2010 18:44:24 -0400
Message-Id: <1281566667-7821-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1281566667-7821-1-git-send-email-vgoyal@redhat.com>
References: <1281566667-7821-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Implement another CFQ mode where we charge group in terms of number
  of requests dispatched instead of measuring the time. Measuring in terms
  of time is not possible when we are driving deeper queue depths and there
  are requests from multiple cfq queues in the request queue.

o This mode currently gets activated if one sets slice_idle=0 and associated
  disk supports NCQ. Again the idea is that on an NCQ disk with idling disabled
  most of the queues will dispatch 1 or more requests and then cfq queue
  expiry happens and we don't have a way to measure time. So start providing
  fairness in terms of IOPS.

o Currently IOPS mode works only with cfq group scheduling. CFQ is following
  different scheduling algorithms for queue and group scheduling. These IOPS
  stats are used only for group scheduling hence in non-croup mode nothing
  should change.

o For CFQ group scheduling one can disable slice idling so that we don't idle
  on queue and drive deeper request queue depths (achieving better throughput),
  at the same time group idle is enabled so one should get service
  differentiation among groups.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   30 ++++++++++++++++++++++++------
 1 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 8830569..3fc6be1 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -378,6 +378,21 @@ CFQ_CFQQ_FNS(wait_busy);
 			&cfqg->service_trees[i][j]: NULL) \
 
 
+static inline bool iops_mode(struct cfq_data *cfqd)
+{
+	/*
+	 * If we are not idling on queues and it is a NCQ drive, parallel
+	 * execution of requests is on and measuring time is not possible
+	 * in most of the cases until and unless we drive shallower queue
+	 * depths and that becomes a performance bottleneck. In such cases
+	 * switch to start providing fairness in terms of number of IOs.
+	 */
+	if (!cfqd->cfq_slice_idle && cfqd->hw_tag)
+		return true;
+	else
+		return false;
+}
+
 static inline enum wl_prio_t cfqq_prio(struct cfq_queue *cfqq)
 {
 	if (cfq_class_idle(cfqq))
@@ -906,7 +921,6 @@ static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
 			slice_used = cfqq->allocated_slice;
 	}
 
-	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u", slice_used);
 	return slice_used;
 }
 
@@ -914,19 +928,21 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 				struct cfq_queue *cfqq)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
-	unsigned int used_sl, charge_sl;
+	unsigned int used_sl, charge;
 	int nr_sync = cfqg->nr_cfqq - cfqg_busy_async_queues(cfqd, cfqg)
 			- cfqg->service_tree_idle.count;
 
 	BUG_ON(nr_sync < 0);
-	used_sl = charge_sl = cfq_cfqq_slice_usage(cfqq);
+	used_sl = charge = cfq_cfqq_slice_usage(cfqq);
 
-	if (!cfq_cfqq_sync(cfqq) && !nr_sync)
-		charge_sl = cfqq->allocated_slice;
+	if (iops_mode(cfqd))
+		charge = cfqq->slice_dispatch;
+	else if (!cfq_cfqq_sync(cfqq) && !nr_sync)
+		charge = cfqq->allocated_slice;
 
 	/* Can't update vdisktime while group is on service tree */
 	cfq_rb_erase(&cfqg->rb_node, st);
-	cfqg->vdisktime += cfq_scale_slice(charge_sl, cfqg);
+	cfqg->vdisktime += cfq_scale_slice(charge, cfqg);
 	__cfq_group_service_tree_add(st, cfqg);
 
 	/* This group is being expired. Save the context */
@@ -940,6 +956,8 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 
 	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
 					st->min_vdisktime);
+	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u disp=%u charge=%u iops=%u",
+			used_sl, cfqq->slice_dispatch, charge, iops_mode(cfqd));
 	cfq_blkiocg_update_timeslice_used(&cfqg->blkg, used_sl);
 	cfq_blkiocg_set_start_empty_time(&cfqg->blkg);
 }
-- 
1.7.1.1

