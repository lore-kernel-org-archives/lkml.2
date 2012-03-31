Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245Ab2CaPbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 11:31:18 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:41830 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760111Ab2CaPbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 11:31:15 -0400
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH V2 1/2] block: Make cfq_target_latency tunable through sysfs.
Date: Sat, 31 Mar 2012 23:31:06 +0800
Message-Id: <1333207867-2957-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1332836213-5266-1-git-send-email-tm@tao.ma>
References: <1332836213-5266-1-git-send-email-tm@tao.ma>
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 69.198.183.141 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In cfq, when we calculate a time slice for a process(or a cfqq to
be precise), we have to consider the cfq_target_latency so that all the
sync request have an estimated latency(300ms) and it is controlled by
cfq_target_latency. But in some hadoop test, we have found that if
there are many processes doing sequential read(24 for example), the
throughput is bad because every process can only work for about 25ms
and the cfqq is switched. That leads to a higher disk seek. We can
achive the good throughput by setting low_latency=0, but then some
read's latency is too much for the application.

So this patch makes cfq_target_latency tunable through sysfs so that
we can tune it and find some magic number which is not bad for both
the throughput and the read latency.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 block/cfq-iosched.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4572952..3c38536 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -295,6 +295,7 @@ struct cfq_data {
 	unsigned int cfq_slice_idle;
 	unsigned int cfq_group_idle;
 	unsigned int cfq_latency;
+	unsigned int cfq_target_latency;
 
 	/*
 	 * Fallback dummy cfqq for extreme OOM conditions
@@ -604,7 +605,7 @@ cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 
-	return cfq_target_latency * cfqg->weight / st->total_weight;
+	return cfqd->cfq_target_latency * cfqg->weight / st->total_weight;
 }
 
 static inline unsigned
@@ -2271,7 +2272,8 @@ new_workload:
 		 * to have higher weight. A more accurate thing would be to
 		 * calculate system wide asnc/sync ratio.
 		 */
-		tmp = cfq_target_latency * cfqg_busy_async_queues(cfqd, cfqg);
+		tmp = cfqd->cfq_target_latency *
+			cfqg_busy_async_queues(cfqd, cfqg);
 		tmp = tmp/cfqd->busy_queues;
 		slice = min_t(unsigned, slice, tmp);
 
@@ -3737,6 +3739,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->cfq_back_penalty = cfq_back_penalty;
 	cfqd->cfq_slice[0] = cfq_slice_async;
 	cfqd->cfq_slice[1] = cfq_slice_sync;
+	cfqd->cfq_target_latency = cfq_target_latency;
 	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
 	cfqd->cfq_slice_idle = cfq_slice_idle;
 	cfqd->cfq_group_idle = cfq_group_idle;
@@ -3788,6 +3791,7 @@ SHOW_FUNCTION(cfq_slice_sync_show, cfqd->cfq_slice[1], 1);
 SHOW_FUNCTION(cfq_slice_async_show, cfqd->cfq_slice[0], 1);
 SHOW_FUNCTION(cfq_slice_async_rq_show, cfqd->cfq_slice_async_rq, 0);
 SHOW_FUNCTION(cfq_low_latency_show, cfqd->cfq_latency, 0);
+SHOW_FUNCTION(cfq_target_latency_show, cfqd->cfq_target_latency, 1);
 #undef SHOW_FUNCTION
 
 #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
@@ -3821,6 +3825,7 @@ STORE_FUNCTION(cfq_slice_async_store, &cfqd->cfq_slice[0], 1, UINT_MAX, 1);
 STORE_FUNCTION(cfq_slice_async_rq_store, &cfqd->cfq_slice_async_rq, 1,
 		UINT_MAX, 0);
 STORE_FUNCTION(cfq_low_latency_store, &cfqd->cfq_latency, 0, 1, 0);
+STORE_FUNCTION(cfq_target_latency_store, &cfqd->cfq_target_latency, 1, UINT_MAX, 1);
 #undef STORE_FUNCTION
 
 #define CFQ_ATTR(name) \
@@ -3838,6 +3843,7 @@ static struct elv_fs_entry cfq_attrs[] = {
 	CFQ_ATTR(slice_idle),
 	CFQ_ATTR(group_idle),
 	CFQ_ATTR(low_latency),
+	CFQ_ATTR(target_latency),
 	__ATTR_NULL
 };
 
-- 
1.7.0.4

