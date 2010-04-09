Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab0DIEPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 00:15:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61285 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab0DIEPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 00:15:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=hGCoCedwDX/znasuD33mc3WCqpyyV4nNiP4UqYNPuuxbxHOxcSMccJR0TdTdy2wbo
	TBl2+l+W0B8qOuNlk9GhA==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH 2/3] blkio: Add io_queued and avg_queue_size stats
To: jens.axboe@oracle.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, ctalbott@google.com
Date: Thu, 08 Apr 2010 21:15:10 -0700
Message-ID: <20100409041428.23105.51779.stgit@austin.mtv.corp.google.com>
In-Reply-To: <20100409041210.23105.13623.stgit@austin.mtv.corp.google.com>
References: <20100409041210.23105.13623.stgit@austin.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These stats are useful for getting a feel for the queue depth of the cgroup,
i.e., how filled up its queues are at a given instant and over the existence of
the cgroup. This ability is useful when debugging problems in the wild as it
helps understand the application's IO pattern w/o having to read through the
userspace code (coz its tedious or just not available) or w/o the ability
to run blktrace (since you may not have root access and/or not want to disturb
performance).

Signed-off-by: Divyesh Shah<dpshah@google.com>
---

 Documentation/cgroups/blkio-controller.txt |   11 +++
 block/blk-cgroup.c                         |   98 +++++++++++++++++++++++++++-
 block/blk-cgroup.h                         |   20 +++++-
 block/cfq-iosched.c                        |   11 +++
 4 files changed, 134 insertions(+), 6 deletions(-)

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index 810e301..6e52e7c 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -139,6 +139,17 @@ Details of cgroup files
 	  cgroup. This is further divided by the type of operation - read or
 	  write, sync or async.
 
+- blkio.io_queued
+	- Total number of requests queued up at any given instant for this
+	  cgroup. This is further divided by the type of operation - read or
+	  write, sync or async.
+
+- blkio.avg_queue_size
+	- Debugging aid only enabled if CONFIG_DEBUG_CFQ_IOSCHED=y.
+	  The average queue size for this cgroup over the entire time of this
+	  cgroup's existence. Queue size samples are taken each time one of the
+	  queues of this cgroup gets a timeslice.
+
 - blkio.dequeue
 	- Debugging aid only enabled if CONFIG_DEBUG_CFQ_IOSCHED=y. This
 	  gives the statistics about how many a times a group was dequeued
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d23b538..1e0c497 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -81,6 +81,71 @@ static void blkio_add_stat(uint64_t *stat, uint64_t add, bool direction,
 		stat[BLKIO_STAT_ASYNC] += add;
 }
 
+/*
+ * Decrements the appropriate stat variable if non-zero depending on the
+ * request type. Panics on value being zero.
+ * This should be called with the blkg->stats_lock held.
+ */
+static void blkio_check_and_dec_stat(uint64_t *stat, bool direction, bool sync)
+{
+	if (direction) {
+		BUG_ON(stat[BLKIO_STAT_WRITE] == 0);
+		stat[BLKIO_STAT_WRITE]--;
+	} else {
+		BUG_ON(stat[BLKIO_STAT_READ] == 0);
+		stat[BLKIO_STAT_READ]--;
+	}
+	if (sync) {
+		BUG_ON(stat[BLKIO_STAT_SYNC] == 0);
+		stat[BLKIO_STAT_SYNC]--;
+	} else {
+		BUG_ON(stat[BLKIO_STAT_ASYNC] == 0);
+		stat[BLKIO_STAT_ASYNC]--;
+	}
+}
+
+#ifdef CONFIG_DEBUG_BLK_CGROUP
+void blkiocg_update_set_active_queue_stats(struct blkio_group *blkg)
+{
+	unsigned long flags;
+	struct blkio_group_stats *stats;
+
+	spin_lock_irqsave(&blkg->stats_lock, flags);
+	stats = &blkg->stats;
+	stats->avg_queue_size_sum +=
+			stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_READ] +
+			stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_WRITE];
+	stats->avg_queue_size_samples++;
+	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+}
+EXPORT_SYMBOL_GPL(blkiocg_update_set_active_queue_stats);
+#endif
+
+void blkiocg_update_request_add_stats(struct blkio_group *blkg,
+			struct blkio_group *curr_blkg, bool direction,
+			bool sync)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&blkg->stats_lock, flags);
+	blkio_add_stat(blkg->stats.stat_arr[BLKIO_STAT_QUEUED], 1, direction,
+			sync);
+	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+}
+EXPORT_SYMBOL_GPL(blkiocg_update_request_add_stats);
+
+void blkiocg_update_request_remove_stats(struct blkio_group *blkg,
+						bool direction, bool sync)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&blkg->stats_lock, flags);
+	blkio_check_and_dec_stat(blkg->stats.stat_arr[BLKIO_STAT_QUEUED],
+					direction, sync);
+	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+}
+EXPORT_SYMBOL_GPL(blkiocg_update_request_remove_stats);
+
 void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time)
 {
 	unsigned long flags;
@@ -253,14 +318,18 @@ blkiocg_reset_stats(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 	struct blkio_cgroup *blkcg;
 	struct blkio_group *blkg;
 	struct hlist_node *n;
-	struct blkio_group_stats *stats;
+	uint64_t queued[BLKIO_STAT_TOTAL];
+	int i;
 
 	blkcg = cgroup_to_blkio_cgroup(cgroup);
 	spin_lock_irq(&blkcg->lock);
 	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
 		spin_lock(&blkg->stats_lock);
-		stats = &blkg->stats;
-		memset(stats, 0, sizeof(struct blkio_group_stats));
+		for (i = 0; i < BLKIO_STAT_TOTAL; i++)
+			queued[i] = blkg->stats.stat_arr[BLKIO_STAT_QUEUED][i];
+		memset(&blkg->stats, 0, sizeof(struct blkio_group_stats));
+		for (i = 0; i < BLKIO_STAT_TOTAL; i++)
+			blkg->stats.stat_arr[BLKIO_STAT_QUEUED][i] = queued[i];
 		spin_unlock(&blkg->stats_lock);
 	}
 	spin_unlock_irq(&blkcg->lock);
@@ -323,6 +392,15 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg,
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
 					blkg->stats.sectors, cb, dev);
 #ifdef CONFIG_DEBUG_BLK_CGROUP
+	if (type == BLKIO_STAT_AVG_QUEUE_SIZE) {
+		uint64_t sum = blkg->stats.avg_queue_size_sum;
+		uint64_t samples = blkg->stats.avg_queue_size_samples;
+		if (samples)
+			do_div(sum, samples);
+		else
+			sum = 0;
+		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1, sum, cb, dev);
+	}
 	if (type == BLKIO_STAT_DEQUEUE)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
 					blkg->stats.dequeue, cb, dev);
@@ -376,8 +454,10 @@ SHOW_FUNCTION_PER_GROUP(io_serviced, BLKIO_STAT_SERVICED, 1);
 SHOW_FUNCTION_PER_GROUP(io_service_time, BLKIO_STAT_SERVICE_TIME, 1);
 SHOW_FUNCTION_PER_GROUP(io_wait_time, BLKIO_STAT_WAIT_TIME, 1);
 SHOW_FUNCTION_PER_GROUP(io_merged, BLKIO_STAT_MERGED, 1);
+SHOW_FUNCTION_PER_GROUP(io_queued, BLKIO_STAT_QUEUED, 1);
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 SHOW_FUNCTION_PER_GROUP(dequeue, BLKIO_STAT_DEQUEUE, 0);
+SHOW_FUNCTION_PER_GROUP(avg_queue_size, BLKIO_STAT_AVG_QUEUE_SIZE, 0);
 #endif
 #undef SHOW_FUNCTION_PER_GROUP
 
@@ -425,14 +505,22 @@ struct cftype blkio_files[] = {
 		.read_map = blkiocg_io_merged_read,
 	},
 	{
+		.name = "io_queued",
+		.read_map = blkiocg_io_queued_read,
+	},
+	{
 		.name = "reset_stats",
 		.write_u64 = blkiocg_reset_stats,
 	},
 #ifdef CONFIG_DEBUG_BLK_CGROUP
-       {
+	{
+		.name = "avg_queue_size",
+		.read_map = blkiocg_avg_queue_size_read,
+	},
+	{
 		.name = "dequeue",
 		.read_map = blkiocg_dequeue_read,
-       },
+	},
 #endif
 };
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 470a29d..bea7f3b 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -36,10 +36,13 @@ enum stat_type {
 	BLKIO_STAT_WAIT_TIME,
 	/* Number of IOs merged */
 	BLKIO_STAT_MERGED,
+	/* Number of IOs queued up */
+	BLKIO_STAT_QUEUED,
 	/* All the single valued stats go below this */
 	BLKIO_STAT_TIME,
 	BLKIO_STAT_SECTORS,
 #ifdef CONFIG_DEBUG_BLK_CGROUP
+	BLKIO_STAT_AVG_QUEUE_SIZE,
 	BLKIO_STAT_DEQUEUE
 #endif
 };
@@ -63,8 +66,12 @@ struct blkio_group_stats {
 	/* total disk time and nr sectors dispatched by this group */
 	uint64_t time;
 	uint64_t sectors;
-	uint64_t stat_arr[BLKIO_STAT_MERGED + 1][BLKIO_STAT_TOTAL];
+	uint64_t stat_arr[BLKIO_STAT_QUEUED + 1][BLKIO_STAT_TOTAL];
 #ifdef CONFIG_DEBUG_BLK_CGROUP
+	/* Sum of number of IOs queued across all samples */
+	uint64_t avg_queue_size_sum;
+	/* Count of samples taken for average */
+	uint64_t avg_queue_size_samples;
 	/* How many times this group has been removed from service tree */
 	unsigned long dequeue;
 #endif
@@ -127,10 +134,13 @@ static inline char *blkg_path(struct blkio_group *blkg)
 {
 	return blkg->path;
 }
+void blkiocg_update_set_active_queue_stats(struct blkio_group *blkg);
 void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
 				unsigned long dequeue);
 #else
 static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
+static inline void blkiocg_update_set_active_queue_stats(
+						struct blkio_group *blkg) {}
 static inline void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
 						unsigned long dequeue) {}
 #endif
@@ -152,6 +162,10 @@ void blkiocg_update_completion_stats(struct blkio_group *blkg,
 	uint64_t start_time, uint64_t io_start_time, bool direction, bool sync);
 void blkiocg_update_io_merged_stats(struct blkio_group *blkg, bool direction,
 					bool sync);
+void blkiocg_update_request_add_stats(struct blkio_group *blkg,
+		struct blkio_group *curr_blkg, bool direction, bool sync);
+void blkiocg_update_request_remove_stats(struct blkio_group *blkg,
+					bool direction, bool sync);
 #else
 struct cgroup;
 static inline struct blkio_cgroup *
@@ -175,5 +189,9 @@ static inline void blkiocg_update_completion_stats(struct blkio_group *blkg,
 		bool sync) {}
 static inline void blkiocg_update_io_merged_stats(struct blkio_group *blkg,
 						bool direction, bool sync) {}
+static inline void blkiocg_update_request_add_stats(struct blkio_group *blkg,
+		struct blkio_group *curr_blkg, bool direction, bool sync) {}
+static inline void blkiocg_update_request_remove_stats(struct blkio_group *blkg,
+						bool direction, bool sync) {}
 #endif
 #endif /* _BLK_CGROUP_H */
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4eb1906..8e0b86a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1380,7 +1380,12 @@ static void cfq_reposition_rq_rb(struct cfq_queue *cfqq, struct request *rq)
 {
 	elv_rb_del(&cfqq->sort_list, rq);
 	cfqq->queued[rq_is_sync(rq)]--;
+	blkiocg_update_request_remove_stats(&cfqq->cfqg->blkg, rq_data_dir(rq),
+						rq_is_sync(rq));
 	cfq_add_rq_rb(rq);
+	blkiocg_update_request_add_stats(
+			&cfqq->cfqg->blkg, &cfqq->cfqd->serving_group->blkg,
+			rq_data_dir(rq), rq_is_sync(rq));
 }
 
 static struct request *
@@ -1436,6 +1441,8 @@ static void cfq_remove_request(struct request *rq)
 	cfq_del_rq_rb(rq);
 
 	cfqq->cfqd->rq_queued--;
+	blkiocg_update_request_remove_stats(&cfqq->cfqg->blkg, rq_data_dir(rq),
+						rq_is_sync(rq));
 	if (rq_is_meta(rq)) {
 		WARN_ON(!cfqq->meta_pending);
 		cfqq->meta_pending--;
@@ -1527,6 +1534,7 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 	if (cfqq) {
 		cfq_log_cfqq(cfqd, cfqq, "set_active wl_prio:%d wl_type:%d",
 				cfqd->serving_prio, cfqd->serving_type);
+		blkiocg_update_set_active_queue_stats(&cfqq->cfqg->blkg);
 		cfqq->slice_start = 0;
 		cfqq->dispatch_start = jiffies;
 		cfqq->allocated_slice = 0;
@@ -3213,6 +3221,9 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
 	list_add_tail(&rq->queuelist, &cfqq->fifo);
 	cfq_add_rq_rb(rq);
 
+	blkiocg_update_request_add_stats(&cfqq->cfqg->blkg,
+			&cfqd->serving_group->blkg, rq_data_dir(rq),
+			rq_is_sync(rq));
 	cfq_rq_enqueued(cfqd, cfqq, rq);
 }
 

