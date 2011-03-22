Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab1CVXK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:10:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6669 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab1CVXJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:09:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=PHXINXXkbit6Yi0GRVBkGhWUTnY+McarCk9+u1MhQm4mqc1D5Eg2Z383gvyj2dQ0p
	DYpL1QnehoGu9zsFqtzIg==
From: Justin TerAvest <teravest@google.com>
To: vgoyal@redhat.com, jaxboe@fusionio.com
Cc: m-ikeda@ds.jp.nec.com, ryov@valinux.co.jp, taka@valinux.co.jp,
        kamezawa.hiroyu@jp.fujitsu.com, righi.andrea@gmail.com,
        guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
        ctalbott@google.com, linux-kernel@vger.kernel.org,
        Justin TerAvest <teravest@google.com>
Subject: [PATCH v2 6/8] cfq: add per cgroup writeout done by flusher stat
Date: Tue, 22 Mar 2011 16:08:53 -0700
Message-Id: <1300835335-2777-7-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1300835335-2777-1-git-send-email-teravest@google.com>
References: <1300835335-2777-1-git-send-email-teravest@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tracking for buffered writes can detect when traffic comes from a
flusher thread, as opposed to directly from an application. This adds a
statistic to track I/O traffic from flusher threads.

This helps determine whether a flusher thread is being unfair to a
particular cgroup, and if cgroup-based isolation of writeback behavior
is useful.

Signed-off-by: Justin TerAvest <teravest@google.com>
---
 block/blk-cgroup.c        |   18 ++++++++++++++++-
 block/blk-cgroup.h        |    9 ++++++-
 block/cfq-iosched.c       |   47 ++++++++++++++++++++++++++------------------
 block/cfq.h               |    6 +++-
 include/linux/blk_types.h |    2 +
 5 files changed, 58 insertions(+), 24 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 9732cfd..7b63030 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -412,7 +412,8 @@ void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 EXPORT_SYMBOL_GPL(blkiocg_update_dispatch_stats);
 
 void blkiocg_update_completion_stats(struct blkio_group *blkg,
-	uint64_t start_time, uint64_t io_start_time, bool direction, bool sync)
+	uint64_t start_time, uint64_t io_start_time, bool direction, bool sync,
+	bool out_of_ctx)
 {
 	struct blkio_group_stats *stats;
 	unsigned long flags;
@@ -426,6 +427,8 @@ void blkiocg_update_completion_stats(struct blkio_group *blkg,
 	if (time_after64(io_start_time, start_time))
 		blkio_add_stat(stats->stat_arr[BLKIO_STAT_WAIT_TIME],
 				io_start_time - start_time, direction, sync);
+	if (out_of_ctx)
+		blkg->stats.oo_ctx_io_count++;
 	spin_unlock_irqrestore(&blkg->stats_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_completion_stats);
@@ -620,6 +623,9 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg,
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
 					blkg->stats.unaccounted_time, cb, dev);
 #ifdef CONFIG_DEBUG_BLK_CGROUP
+	if (type == BLKIO_STAT_OO_CTX_IO_COUNT)
+		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
+					blkg->stats.oo_ctx_io_count, cb, dev);
 	if (type == BLKIO_STAT_AVG_QUEUE_SIZE) {
 		uint64_t sum = blkg->stats.avg_queue_size_sum;
 		uint64_t samples = blkg->stats.avg_queue_size_samples;
@@ -1159,6 +1165,10 @@ static int blkiocg_file_read_map(struct cgroup *cgrp, struct cftype *cft,
 		case BLKIO_PROP_empty_time:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
 						BLKIO_STAT_EMPTY_TIME, 0);
+		case BLKIO_PROP_oo_ctx_io_count:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_OO_CTX_IO_COUNT, 0);
+
 #endif
 		default:
 			BUG();
@@ -1419,6 +1429,12 @@ struct cftype blkio_files[] = {
 				BLKIO_PROP_dequeue),
 		.read_map = blkiocg_file_read_map,
 	},
+	{
+		.name = "oo_ctx_io_count",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_oo_ctx_io_count),
+		.read_map = blkiocg_file_read_map,
+	},
 #endif
 };
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 10919fa..9556f2b 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -52,6 +52,7 @@ enum stat_type {
 	/* Time not charged to this cgroup */
 	BLKIO_STAT_UNACCOUNTED_TIME,
 #ifdef CONFIG_DEBUG_BLK_CGROUP
+	BLKIO_STAT_OO_CTX_IO_COUNT,
 	BLKIO_STAT_AVG_QUEUE_SIZE,
 	BLKIO_STAT_IDLE_TIME,
 	BLKIO_STAT_EMPTY_TIME,
@@ -93,6 +94,7 @@ enum blkcg_file_name_prop {
 	BLKIO_PROP_idle_time,
 	BLKIO_PROP_empty_time,
 	BLKIO_PROP_dequeue,
+	BLKIO_PROP_oo_ctx_io_count,
 };
 
 /* cgroup files owned by throttle policy */
@@ -119,6 +121,8 @@ struct blkio_group_stats {
 	uint64_t sectors;
 	/* Time not charged to this cgroup */
 	uint64_t unaccounted_time;
+	/* Number of IOs sumbitted out of process context */
+	uint64_t oo_ctx_io_count;
 	uint64_t stat_arr[BLKIO_STAT_QUEUED + 1][BLKIO_STAT_TOTAL];
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	/* Sum of number of IOs queued across all samples */
@@ -303,7 +307,8 @@ void blkiocg_update_timeslice_used(struct blkio_group *blkg,
 void blkiocg_update_dispatch_stats(struct blkio_group *blkg, uint64_t bytes,
 						bool direction, bool sync);
 void blkiocg_update_completion_stats(struct blkio_group *blkg,
-	uint64_t start_time, uint64_t io_start_time, bool direction, bool sync);
+	uint64_t start_time, uint64_t io_start_time, bool direction, bool sync,
+	bool out_of_ctx);
 void blkiocg_update_io_merged_stats(struct blkio_group *blkg, bool direction,
 					bool sync);
 void blkiocg_update_io_add_stats(struct blkio_group *blkg,
@@ -332,7 +337,7 @@ static inline void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 				uint64_t bytes, bool direction, bool sync) {}
 static inline void blkiocg_update_completion_stats(struct blkio_group *blkg,
 		uint64_t start_time, uint64_t io_start_time, bool direction,
-		bool sync) {}
+						bool sync, bool out_of_ctx) {}
 static inline void blkiocg_update_io_merged_stats(struct blkio_group *blkg,
 						bool direction, bool sync) {}
 static inline void blkiocg_update_io_add_stats(struct blkio_group *blkg,
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1b315c3..c885493 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -311,7 +311,7 @@ static void cfq_put_queue_ref(struct cfq_queue *cfqq);
 
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
 static struct cfq_group *cfq_get_cfqg_bio(struct cfq_data *cfqd,
-				   struct bio *bio, int create);
+			struct bio *bio, int *is_oo_ctx, int create);
 static struct cfq_queue **
 cfq_async_queue_prio(struct cfq_group *cfqg, int ioprio_class, int ioprio);
 
@@ -449,8 +449,8 @@ static inline int cfq_group_busy_queues_wl(enum wl_prio_t wl,
 }
 
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
-static struct cfq_queue *cfq_get_queue(struct cfq_data *, struct bio*, bool,
-				       struct io_context *, gfp_t);
+static struct cfq_queue *cfq_get_queue(struct cfq_data *, struct bio*,
+		int *is_oo_ctx, bool, struct io_context *, gfp_t);
 static struct cfq_io_context *cfq_cic_lookup(struct cfq_data *,
 						struct io_context *);
 static void cfq_put_async_queues(struct cfq_group *cfqg);
@@ -484,7 +484,7 @@ static struct cfq_queue *cic_bio_to_cfqq(struct cfq_data *cfqd,
 		 * async bio tracking is enabled and we are not caching
 		 * async queue pointer in cic.
 		 */
-		cfqg = cfq_get_cfqg_bio(cfqd, bio, 0);
+		cfqg = cfq_get_cfqg_bio(cfqd, bio, NULL, 0);
 		if (!cfqg) {
 			/*
 			 * May be this is first rq/bio and io group has not
@@ -1150,17 +1150,21 @@ done:
  * create the cfq group if it does not exist. request_queue lock must be held.
  */
 static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, struct page *page,
-				      int create)
+				      int *is_oo_ctx, int create)
 {
-	struct cgroup *cgroup;
+	struct cgroup *cgroup, *tracked_cgroup;
 	struct cfq_group *cfqg = NULL;
 
 	rcu_read_lock();
 
-	if (!page)
-		cgroup = task_cgroup(current, blkio_subsys_id);
-	else
-		cgroup = get_cgroup_from_page(page);
+	cgroup = task_cgroup(current, blkio_subsys_id);
+	if (page) {
+		tracked_cgroup = get_cgroup_from_page(page);
+		if (is_oo_ctx)
+			*is_oo_ctx = cgroup && tracked_cgroup &&
+				tracked_cgroup != cgroup;
+		cgroup = tracked_cgroup;
+	}
 
 	if (!cgroup) {
 		cfqg = &cfqd->root_group;
@@ -1175,8 +1179,8 @@ out:
 	return cfqg;
 }
 
-struct cfq_group *cfq_get_cfqg_bio(struct cfq_data *cfqd,
-					struct bio *bio, int create)
+struct cfq_group *cfq_get_cfqg_bio(struct cfq_data *cfqd, struct bio *bio,
+					int *is_oo_ctx, int create)
 {
 	struct page *page = NULL;
 
@@ -1201,7 +1205,7 @@ struct cfq_group *cfq_get_cfqg_bio(struct cfq_data *cfqd,
 #endif
 
 sync:
-	return cfq_get_cfqg(cfqd, page, create);
+	return cfq_get_cfqg(cfqd, page, is_oo_ctx, create);
 }
 
 static void cfq_get_group_ref(struct cfq_group *cfqg)
@@ -1288,7 +1292,7 @@ void cfq_unlink_blkio_group(void *key, struct blkio_group *blkg)
 #else /* GROUP_IOSCHED */
 
 static struct cfq_group *cfq_get_cfqg_bio(struct cfq_data *cfqd,
-					  struct bio *bio, int create)
+			struct bio *bio, int *is_oo_ctx, int create)
 {
 }
 
@@ -3134,14 +3138,14 @@ cfq_async_queue_prio(struct cfq_group *cfqg, int ioprio_class, int ioprio)
 }
 
 static struct cfq_queue *
-cfq_get_queue(struct cfq_data *cfqd, struct bio *bio, bool is_sync,
-	      struct io_context *ioc, gfp_t gfp_mask)
+cfq_get_queue(struct cfq_data *cfqd, struct bio *bio, int *is_oo_ctx,
+	      bool is_sync, struct io_context *ioc, gfp_t gfp_mask)
 {
 	const int ioprio = task_ioprio(ioc);
 	const int ioprio_class = task_ioprio_class(ioc);
 	struct cfq_queue **async_cfqq = NULL;
 	struct cfq_queue *cfqq = NULL;
-	struct cfq_group *cfqg = cfq_get_cfqg_bio(cfqd, bio, 1);
+	struct cfq_group *cfqg = cfq_get_cfqg_bio(cfqd, bio, is_oo_ctx, 1);
 
 	if (!is_sync) {
 		async_cfqq = cfq_async_queue_prio(cfqg, ioprio_class,
@@ -3667,7 +3671,8 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	(RQ_CFQG(rq))->dispatched--;
 	cfq_blkiocg_update_completion_stats(&cfqq->cfqg->blkg,
 			rq_start_time_ns(rq), rq_io_start_time_ns(rq),
-			rq_data_dir(rq), rq_is_sync(rq));
+			rq_data_dir(rq), rq_is_sync(rq),
+			rq->cmd_flags & REQ_OUT_OF_CTX);
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
 
@@ -3855,6 +3860,7 @@ cfq_set_request(struct request_queue *q, struct request *rq, struct bio *bio,
 	const bool is_sync = rq_is_sync(rq);
 	struct cfq_queue *cfqq;
 	unsigned long flags;
+	int is_oo_ctx = 0;
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
@@ -3868,8 +3874,11 @@ cfq_set_request(struct request_queue *q, struct request *rq, struct bio *bio,
 new_queue:
 	cfqq = cic_to_cfqq(cic, is_sync);
 	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
-		cfqq = cfq_get_queue(cfqd, bio, is_sync, cic->ioc, gfp_mask);
+		cfqq = cfq_get_queue(cfqd, bio, &is_oo_ctx, is_sync, cic->ioc,
+					gfp_mask);
 		cic_set_cfqq(cic, cfqq, is_sync);
+		if (is_oo_ctx)
+			rq->cmd_flags |= REQ_OUT_OF_CTX;
 	} else {
 		/*
 		 * If the queue was seeky for too long, break it apart.
diff --git a/block/cfq.h b/block/cfq.h
index 2a15592..6afc10a 100644
--- a/block/cfq.h
+++ b/block/cfq.h
@@ -61,10 +61,12 @@ static inline void cfq_blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 	blkiocg_update_dispatch_stats(blkg, bytes, direction, sync);
 }
 
-static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg, uint64_t start_time, uint64_t io_start_time, bool direction, bool sync)
+static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg,
+				uint64_t start_time, uint64_t io_start_time,
+				bool direction, bool sync, bool out_of_ctx)
 {
 	blkiocg_update_completion_stats(blkg, start_time, io_start_time,
-				direction, sync);
+				direction, sync, out_of_ctx);
 }
 
 static inline void cfq_blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index be50d9e..d859395 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -152,6 +152,7 @@ enum rq_flag_bits {
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
 	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
 	__REQ_ON_PLUG,		/* on plug list */
+	__REQ_OUT_OF_CTX,	/* request submitted out of process context */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -193,5 +194,6 @@ enum rq_flag_bits {
 #define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
 #define REQ_SECURE		(1 << __REQ_SECURE)
 #define REQ_ON_PLUG		(1 << __REQ_ON_PLUG)
+#define REQ_OUT_OF_CTX		(1 << __REQ_OUT_OF_CTX)
 
 #endif /* __LINUX_BLK_TYPES_H */
-- 
1.7.3.1

