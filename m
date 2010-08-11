Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab0HKWpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 18:45:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285Ab0HKWoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 18:44:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: vgoyal@redhat.com
Subject: [PATCH 3/5] cfq-iosched: Implement tunable group_idle
Date: Wed, 11 Aug 2010 18:44:25 -0400
Message-Id: <1281566667-7821-4-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1281566667-7821-1-git-send-email-vgoyal@redhat.com>
References: <1281566667-7821-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Implement a new tunable group_idle, which allows idling on the group
  instead of a cfq queue. Hence one can set slice_idle = 0 and not idle
  on the individual queues but idle on the group. This way on fast storage
  we can get fairness between groups at the same time overall throughput
  improves.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   65 +++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 3fc6be1..85e4819 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -30,6 +30,7 @@ static const int cfq_slice_sync = HZ / 10;
 static int cfq_slice_async = HZ / 25;
 static const int cfq_slice_async_rq = 2;
 static int cfq_slice_idle = HZ / 125;
+static int cfq_group_idle = HZ / 125;
 static const int cfq_target_latency = HZ * 3/10; /* 300 ms */
 static const int cfq_hist_divisor = 4;
 
@@ -198,6 +199,8 @@ struct cfq_group {
 	struct hlist_node cfqd_node;
 	atomic_t ref;
 #endif
+	/* number of requests that are on the dispatch list or inside driver */
+	int dispatched;
 };
 
 /*
@@ -271,6 +274,7 @@ struct cfq_data {
 	unsigned int cfq_slice[2];
 	unsigned int cfq_slice_async_rq;
 	unsigned int cfq_slice_idle;
+	unsigned int cfq_group_idle;
 	unsigned int cfq_latency;
 	unsigned int cfq_group_isolation;
 
@@ -1884,7 +1888,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
 	struct cfq_io_context *cic;
-	unsigned long sl;
+	unsigned long sl, group_idle = 0;
 
 	/*
 	 * SSD device without seek penalty, disable idling. But only do so
@@ -1900,8 +1904,13 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	/*
 	 * idle is disabled, either manually or by past process history
 	 */
-	if (!cfq_should_idle(cfqd, cfqq))
-		return;
+	if (!cfq_should_idle(cfqd, cfqq)) {
+		/* no queue idling. Check for group idling */
+		if (cfqd->cfq_group_idle)
+			group_idle = cfqd->cfq_group_idle;
+		else
+			return;
+	}
 
 	/*
 	 * still active requests from this queue, don't idle
@@ -1928,13 +1937,21 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 		return;
 	}
 
+	/* There are other queues in the group, don't do group idle */
+	if (group_idle && cfqq->cfqg->nr_cfqq > 1)
+		return;
+
 	cfq_mark_cfqq_wait_request(cfqq);
 
-	sl = cfqd->cfq_slice_idle;
+	if (group_idle)
+		sl = cfqd->cfq_group_idle;
+	else
+		sl = cfqd->cfq_slice_idle;
 
 	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
 	cfq_blkiocg_update_set_idle_time_stats(&cfqq->cfqg->blkg);
-	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu", sl);
+	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu group_idle: %d", sl,
+			group_idle ? 1 : 0);
 }
 
 /*
@@ -1950,6 +1967,7 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 	cfqq->next_rq = cfq_find_next_rq(cfqd, cfqq, rq);
 	cfq_remove_request(rq);
 	cfqq->dispatched++;
+	(RQ_CFQG(rq))->dispatched++;
 	elv_dispatch_sort(q, rq);
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
@@ -2219,7 +2237,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 			cfqq = NULL;
 			goto keep_queue;
 		} else
-			goto expire;
+			goto check_group_idle;
 	}
 
 	/*
@@ -2247,8 +2265,23 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	 * flight or is idling for a new request, allow either of these
 	 * conditions to happen (or time out) before selecting a new queue.
 	 */
-	if (timer_pending(&cfqd->idle_slice_timer) ||
-	    (cfqq->dispatched && cfq_should_idle(cfqd, cfqq))) {
+	if (timer_pending(&cfqd->idle_slice_timer)) {
+		cfqq = NULL;
+		goto keep_queue;
+	}
+
+	if (cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
+		cfqq = NULL;
+		goto keep_queue;
+	}
+
+	/*
+	 * If group idle is enabled and there are requests dispatched from
+	 * this group, wait for requests to complete.
+	 */
+check_group_idle:
+	if (cfqd->cfq_group_idle && cfqq->cfqg->nr_cfqq == 1
+	    && cfqq->cfqg->dispatched) {
 		cfqq = NULL;
 		goto keep_queue;
 	}
@@ -3396,6 +3429,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	WARN_ON(!cfqq->dispatched);
 	cfqd->rq_in_driver--;
 	cfqq->dispatched--;
+	(RQ_CFQG(rq))->dispatched--;
 	cfq_blkiocg_update_completion_stats(&cfqq->cfqg->blkg,
 			rq_start_time_ns(rq), rq_io_start_time_ns(rq),
 			rq_data_dir(rq), rq_is_sync(rq));
@@ -3425,7 +3459,10 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		 * the queue.
 		 */
 		if (cfq_should_wait_busy(cfqd, cfqq)) {
-			cfqq->slice_end = jiffies + cfqd->cfq_slice_idle;
+			unsigned long extend_sl = cfqd->cfq_slice_idle;
+			if (!cfqd->cfq_slice_idle)
+				extend_sl = cfqd->cfq_group_idle;
+			cfqq->slice_end = jiffies + extend_sl;
 			cfq_mark_cfqq_wait_busy(cfqq);
 			cfq_log_cfqq(cfqd, cfqq, "will busy wait");
 		}
@@ -3871,6 +3908,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->cfq_slice[1] = cfq_slice_sync;
 	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
 	cfqd->cfq_slice_idle = cfq_slice_idle;
+	cfqd->cfq_group_idle = cfq_group_idle;
 	cfqd->cfq_latency = 1;
 	cfqd->cfq_group_isolation = 0;
 	cfqd->hw_tag = -1;
@@ -3943,6 +3981,7 @@ SHOW_FUNCTION(cfq_fifo_expire_async_show, cfqd->cfq_fifo_expire[0], 1);
 SHOW_FUNCTION(cfq_back_seek_max_show, cfqd->cfq_back_max, 0);
 SHOW_FUNCTION(cfq_back_seek_penalty_show, cfqd->cfq_back_penalty, 0);
 SHOW_FUNCTION(cfq_slice_idle_show, cfqd->cfq_slice_idle, 1);
+SHOW_FUNCTION(cfq_group_idle_show, cfqd->cfq_group_idle, 1);
 SHOW_FUNCTION(cfq_slice_sync_show, cfqd->cfq_slice[1], 1);
 SHOW_FUNCTION(cfq_slice_async_show, cfqd->cfq_slice[0], 1);
 SHOW_FUNCTION(cfq_slice_async_rq_show, cfqd->cfq_slice_async_rq, 0);
@@ -3975,6 +4014,7 @@ STORE_FUNCTION(cfq_back_seek_max_store, &cfqd->cfq_back_max, 0, UINT_MAX, 0);
 STORE_FUNCTION(cfq_back_seek_penalty_store, &cfqd->cfq_back_penalty, 1,
 		UINT_MAX, 0);
 STORE_FUNCTION(cfq_slice_idle_store, &cfqd->cfq_slice_idle, 0, UINT_MAX, 1);
+STORE_FUNCTION(cfq_group_idle_store, &cfqd->cfq_group_idle, 0, UINT_MAX, 1);
 STORE_FUNCTION(cfq_slice_sync_store, &cfqd->cfq_slice[1], 1, UINT_MAX, 1);
 STORE_FUNCTION(cfq_slice_async_store, &cfqd->cfq_slice[0], 1, UINT_MAX, 1);
 STORE_FUNCTION(cfq_slice_async_rq_store, &cfqd->cfq_slice_async_rq, 1,
@@ -3996,6 +4036,7 @@ static struct elv_fs_entry cfq_attrs[] = {
 	CFQ_ATTR(slice_async),
 	CFQ_ATTR(slice_async_rq),
 	CFQ_ATTR(slice_idle),
+	CFQ_ATTR(group_idle),
 	CFQ_ATTR(low_latency),
 	CFQ_ATTR(group_isolation),
 	__ATTR_NULL
@@ -4049,6 +4090,12 @@ static int __init cfq_init(void)
 	if (!cfq_slice_idle)
 		cfq_slice_idle = 1;
 
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	if (!cfq_group_idle)
+		cfq_group_idle = 1;
+#else
+		cfq_group_idle = 0;
+#endif
 	if (cfq_slab_setup())
 		return -ENOMEM;
 
-- 
1.7.1.1

