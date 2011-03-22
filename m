Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1CVXJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:09:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6646 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab1CVXJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:09:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=LBw8l7XOOcWiOjWvZXJ77KXuRPQCQbzacYu1xqrBZSWY3sUfWLrJwVbfnv/Tx7DHM
	A9fVF8qhkmA81wHcBGJvQ==
From: Justin TerAvest <teravest@google.com>
To: vgoyal@redhat.com, jaxboe@fusionio.com
Cc: m-ikeda@ds.jp.nec.com, ryov@valinux.co.jp, taka@valinux.co.jp,
        kamezawa.hiroyu@jp.fujitsu.com, righi.andrea@gmail.com,
        guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
        ctalbott@google.com, linux-kernel@vger.kernel.org,
        Justin TerAvest <teravest@google.com>
Subject: [PATCH v2 5/8] cfq: Fix up tracked async workload length.
Date: Tue, 22 Mar 2011 16:08:52 -0700
Message-Id: <1300835335-2777-6-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1300835335-2777-1-git-send-email-teravest@google.com>
References: <1300835335-2777-1-git-send-email-teravest@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts effectively reverts commit f26bd1f0a3a31bc5e16d285f5e1b00a56abf6238
"blkio: Determine async workload length based on total number of queues"
in the case when async IO tracking is enabled.

That commit was used to work around the fact that async
queues were part of root cgroup. That is no longer the case when we have
async write tracking enabed.

Signed-off-by: Justin TerAvest <teravest@google.com>
---
 block/cfq-iosched.c |   90 +++++++++++++++++++++++++++++++-------------------
 1 files changed, 56 insertions(+), 34 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index c75bbbf..1b315c3 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -448,13 +448,6 @@ static inline int cfq_group_busy_queues_wl(enum wl_prio_t wl,
 		+ cfqg->service_trees[wl][SYNC_WORKLOAD].count;
 }
 
-static inline int cfqg_busy_async_queues(struct cfq_data *cfqd,
-					struct cfq_group *cfqg)
-{
-	return cfqg->service_trees[RT_WORKLOAD][ASYNC_WORKLOAD].count
-		+ cfqg->service_trees[BE_WORKLOAD][ASYNC_WORKLOAD].count;
-}
-
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
 static struct cfq_queue *cfq_get_queue(struct cfq_data *, struct bio*, bool,
 				       struct io_context *, gfp_t);
@@ -1014,27 +1007,50 @@ static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq,
 	return slice_used;
 }
 
-static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
-				struct cfq_queue *cfqq)
+#ifndef CONFIG_CGROUP_BLKIOTRACK
+static inline int cfqg_busy_async_queues(struct cfq_group *cfqg)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
-	unsigned int used_sl, charge, unaccounted_sl = 0;
-	int nr_sync = cfqg->nr_cfqq - cfqg_busy_async_queues(cfqd, cfqg)
+	return cfqg->service_trees[RT_WORKLOAD][ASYNC_WORKLOAD].count
+		+ cfqg->service_trees[BE_WORKLOAD][ASYNC_WORKLOAD].count;
+}
+#endif
+
+static void cfq_charge_slice(struct cfq_rb_root *st, struct cfq_group *cfqg,
+				struct cfq_queue *cfqq, unsigned int used_sl)
+{
+	struct cfq_data *cfqd = cfqq->cfqd;
+	unsigned int charge = used_sl;
+#ifndef CONFIG_CGROUP_BLKIOTRACK
+	int nr_sync = cfqg->nr_cfqq - cfqg_busy_async_queues(cfqg)
 			- cfqg->service_tree_idle.count;
 
 	BUG_ON(nr_sync < 0);
-	used_sl = charge = cfq_cfqq_slice_usage(cfqq, &unaccounted_sl);
 
 	if (iops_mode(cfqd))
 		charge = cfqq->slice_dispatch;
 	else if (!cfq_cfqq_sync(cfqq) && !nr_sync)
 		charge = cfqq->allocated_slice;
+#endif
 
 	/* Can't update vdisktime while group is on service tree */
 	cfq_group_service_tree_del(st, cfqg);
 	cfqg->vdisktime += cfq_scale_slice(charge, cfqg);
 	/* If a new weight was requested, update now, off tree */
+	cfq_update_group_weight(cfqg);
 	cfq_group_service_tree_add(st, cfqg);
+	cfq_log_cfqq(cfqd, cfqq, "sl_used=%u disp=%u charge=%u iops=%u"
+			" sect=%u", used_sl, cfqq->slice_dispatch, charge,
+			iops_mode(cfqd), cfqq->nr_sectors);
+}
+
+static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
+				struct cfq_queue *cfqq)
+{
+	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	unsigned int used_sl, unaccounted_sl = 0;
+
+	used_sl = cfq_cfqq_slice_usage(cfqq, &unaccounted_sl);
+	cfq_charge_slice(st, cfqg, cfqq, used_sl);
 
 	/* This group is being expired. Save the context */
 	if (time_after(cfqd->workload_expires, jiffies)) {
@@ -1047,9 +1063,6 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 
 	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
 					st->min_vdisktime);
-	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u disp=%u charge=%u iops=%u"
-			" sect=%u", used_sl, cfqq->slice_dispatch, charge,
-			iops_mode(cfqd), cfqq->nr_sectors);
 	cfq_blkiocg_update_timeslice_used(&cfqg->blkg, used_sl,
 					  unaccounted_sl);
 	cfq_blkiocg_set_start_empty_time(&cfqg->blkg);
@@ -2215,6 +2228,30 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 	return cur_best;
 }
 
+static unsigned cfq_async_slice(struct cfq_data *cfqd, struct cfq_group *cfqg,
+				unsigned slice)
+{
+#ifndef CONFIG_CGROUP_BLKIOTRACK
+	unsigned tmp;
+	/*
+	 * Async queues are currently system wide. Just taking
+	 * proportion of queues with-in same group will lead to higher
+	 * async ratio system wide as generally root group is going
+	 * to have higher weight. A more accurate thing would be to
+	 * calculate system wide asnc/sync ratio.
+	 */
+	tmp = cfq_target_latency * cfqg_busy_async_queues(cfqg);
+	tmp = tmp/cfqd->busy_queues;
+	slice = min_t(unsigned, slice, tmp);
+#endif
+	/*
+	 * async workload slice is scaled down according to
+	 * the sync/async slice ratio.
+	 */
+	slice = slice * cfqd->cfq_slice[0] / cfqd->cfq_slice[1];
+	return slice;
+}
+
 static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	unsigned slice;
@@ -2269,24 +2306,9 @@ new_workload:
 		max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
 		      cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd, cfqg));
 
-	if (cfqd->serving_type == ASYNC_WORKLOAD) {
-		unsigned int tmp;
-
-		/*
-		 * Async queues are currently system wide. Just taking
-		 * proportion of queues with-in same group will lead to higher
-		 * async ratio system wide as generally root group is going
-		 * to have higher weight. A more accurate thing would be to
-		 * calculate system wide asnc/sync ratio.
-		 */
-		tmp = cfq_target_latency * cfqg_busy_async_queues(cfqd, cfqg);
-		tmp = tmp/cfqd->busy_queues;
-		slice = min_t(unsigned, slice, tmp);
-
-		/* async workload slice is scaled down according to
-		 * the sync/async slice ratio. */
-		slice = slice * cfqd->cfq_slice[0] / cfqd->cfq_slice[1];
-	} else
+	if (cfqd->serving_type == ASYNC_WORKLOAD)
+		slice = cfq_async_slice(cfqd, cfqg, slice);
+	else
 		/* sync workload slice is at least 2 * cfq_slice_idle */
 		slice = max(slice, 2 * cfqd->cfq_slice_idle);
 
-- 
1.7.3.1

