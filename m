Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929Ab0GUTGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 15:06:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab0GUTGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 15:06:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: nauman@google.com, dpshah@google.com, guijianfeng@cn.fujitsu.com,
        jmoyer@redhat.com, czoccolo@gmail.com, vgoyal@redhat.com
Subject: [PATCH 1/3] cfq-iosched: Implment IOPS mode
Date: Wed, 21 Jul 2010 15:06:19 -0400
Message-Id: <1279739181-24482-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
References: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Implement another CFQ mode where we charge queue/group in terms of number
  of requests dispatched instead of measuring the time. Measuring in terms
  of time is not possible when we are driving deeper queue depths and there
  are requests from multiple cfq queues in the request queue.

o This mode currently gets activated if one sets slice_idle=0 and associated
  disk supports NCQ. Again the idea is that on an NCQ disk with idling disabled
  most of the queues will dispatch 1 or more requests and then cfq queue
  expiry happens and we don't have a way to measure time. So start providing
  fairness in terms of IOPS.

o Currently this primarily is beneficial with cfq group scheduling where one
  can disable slice idling so that we don't idle on queue and drive deeper
  request queue deptsh (achieving better throughput), at the same time group
  idle is enabled so one should get service differentiation among groups.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   37 ++++++++++++++++++++++++++++++-------
 1 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7982b83..4671c51 100644
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
@@ -905,7 +920,6 @@ static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
 			slice_used = cfqq->allocated_slice;
 	}
 
-	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u", slice_used);
 	return slice_used;
 }
 
@@ -913,19 +927,21 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
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
@@ -939,6 +955,8 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 
 	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
 					st->min_vdisktime);
+	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u disp=%u charge=%u iops=%u",
+			used_sl, cfqq->slice_dispatch, charge, iops_mode(cfqd));
 	cfq_blkiocg_update_timeslice_used(&cfqg->blkg, used_sl);
 	cfq_blkiocg_set_start_empty_time(&cfqg->blkg);
 }
@@ -1625,8 +1643,13 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	/*
 	 * store what was left of this slice, if the queue idled/timed out
+	 * Currently in IOPS mode I am not getting into the business of
+	 * saving remaining slice/number of requests because I think it does
+	 * not help much in most of the cases. We can fix it later, if that's
+	 * not the case. IOPS mode is primarily more useful for group
+	 * scheduling.
 	 */
-	if (timed_out && !cfq_cfqq_slice_new(cfqq)) {
+	if (timed_out && !cfq_cfqq_slice_new(cfqq) && !iops_mode(cfqd)) {
 		cfqq->slice_resid = cfqq->slice_end - jiffies;
 		cfq_log_cfqq(cfqd, cfqq, "resid=%ld", cfqq->slice_resid);
 	}
-- 
1.7.1.1

