Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab1CKVGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 16:06:34 -0500
Received: from smtp-out.google.com ([74.125.121.67]:16181 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab1CKVGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 16:06:33 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=MKeAAsGpy6YAy2ORB8HPYaZYGlYOihptmH+FbdUUKrFT0tocWSxSvLzm7vCyeU6Vl
	Nh+PlUXPT+odWQxqQrtuA==
From: Justin TerAvest <teravest@google.com>
To: jaxboe@fusionio.com, vgoyal@redhat.com
Cc: ctalbott@google.com, linux-kernel@vger.kernel.org,
        Justin TerAvest <teravest@google.com>
Subject: [PATCH] Add unaccounted time to timeslice_used.
Date: Fri, 11 Mar 2011 13:06:12 -0800
Message-Id: <1299877572-30353-1-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two kind of times that tasks are not charged for: the first
seek and the extra time slice used over the allocated timeslice. Both
of these exported as a new unaccounted_time stat.

I think it would be good to have this reported in 'time' as well, but
that is probably a separate discussion.

Signed-off-by: Justin TerAvest <teravest@google.com>
---
 block/blk-cgroup.c  |   16 +++++++++++++++-
 block/blk-cgroup.h  |   12 ++++++++++--
 block/cfq-iosched.c |   21 +++++++++++++--------
 block/cfq.h         |    6 +++---
 4 files changed, 41 insertions(+), 14 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 455768a..77ee3c1 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -371,12 +371,14 @@ void blkiocg_update_io_remove_stats(struct blkio_group *blkg,
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_io_remove_stats);
 
-void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time)
+void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time,
+				unsigned long unaccounted_time)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&blkg->stats_lock, flags);
 	blkg->stats.time += time;
+	blkg->stats.unaccounted_time += unaccounted_time;
 	spin_unlock_irqrestore(&blkg->stats_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_timeslice_used);
@@ -603,6 +605,9 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg,
 	if (type == BLKIO_STAT_SECTORS)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
 					blkg->stats.sectors, cb, dev);
+	if (type == BLKIO_STAT_UNACCOUNTED_TIME)
+		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
+					blkg->stats.unaccounted_time, cb, dev);
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	if (type == BLKIO_STAT_AVG_QUEUE_SIZE) {
 		uint64_t sum = blkg->stats.avg_queue_size_sum;
@@ -1106,6 +1111,9 @@ static int blkiocg_file_read_map(struct cgroup *cgrp, struct cftype *cft,
 		case BLKIO_PROP_sectors:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
 						BLKIO_STAT_SECTORS, 0);
+		case BLKIO_PROP_unaccounted_time:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_UNACCOUNTED_TIME, 0);
 		case BLKIO_PROP_io_service_bytes:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
 						BLKIO_STAT_SERVICE_BYTES, 1);
@@ -1262,6 +1270,12 @@ struct cftype blkio_files[] = {
 		.read_map = blkiocg_file_read_map,
 	},
 	{
+		.name = "unaccounted_time",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_unaccounted_time),
+		.read_map = blkiocg_file_read_map,
+	},
+	{
 		.name = "io_service_bytes",
 		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
 				BLKIO_PROP_io_service_bytes),
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index ea4861b..d71409e 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -49,6 +49,8 @@ enum stat_type {
 	/* All the single valued stats go below this */
 	BLKIO_STAT_TIME,
 	BLKIO_STAT_SECTORS,
+	/* Time not charged to this cgroup */
+	BLKIO_STAT_UNACCOUNTED_TIME,
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	BLKIO_STAT_AVG_QUEUE_SIZE,
 	BLKIO_STAT_IDLE_TIME,
@@ -81,6 +83,7 @@ enum blkcg_file_name_prop {
 	BLKIO_PROP_io_serviced,
 	BLKIO_PROP_time,
 	BLKIO_PROP_sectors,
+	BLKIO_PROP_unaccounted_time,
 	BLKIO_PROP_io_service_time,
 	BLKIO_PROP_io_wait_time,
 	BLKIO_PROP_io_merged,
@@ -114,6 +117,8 @@ struct blkio_group_stats {
 	/* total disk time and nr sectors dispatched by this group */
 	uint64_t time;
 	uint64_t sectors;
+	/* Time not charged to this cgroup */
+	uint64_t unaccounted_time;
 	uint64_t stat_arr[BLKIO_STAT_QUEUED + 1][BLKIO_STAT_TOTAL];
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	/* Sum of number of IOs queued across all samples */
@@ -293,7 +298,8 @@ extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
 extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
 						void *key);
 void blkiocg_update_timeslice_used(struct blkio_group *blkg,
-					unsigned long time);
+					unsigned long time,
+					unsigned long unaccounted_time);
 void blkiocg_update_dispatch_stats(struct blkio_group *blkg, uint64_t bytes,
 						bool direction, bool sync);
 void blkiocg_update_completion_stats(struct blkio_group *blkg,
@@ -319,7 +325,9 @@ blkiocg_del_blkio_group(struct blkio_group *blkg) { return 0; }
 static inline struct blkio_group *
 blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key) { return NULL; }
 static inline void blkiocg_update_timeslice_used(struct blkio_group *blkg,
-						unsigned long time) {}
+						unsigned long time,
+						unsigned long unaccounted_time)
+{}
 static inline void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 				uint64_t bytes, bool direction, bool sync) {}
 static inline void blkiocg_update_completion_stats(struct blkio_group *blkg,
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7be4c79..0ba1e5c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -909,7 +909,8 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	cfq_blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
 }
 
-static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
+static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq,
+						unsigned int *unaccounted_time)
 {
 	unsigned int slice_used;
 
@@ -928,8 +929,13 @@ static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
 					1);
 	} else {
 		slice_used = jiffies - cfqq->slice_start;
-		if (slice_used > cfqq->allocated_slice)
+		if (slice_used > cfqq->allocated_slice) {
+			*unaccounted_time = slice_used - cfqq->allocated_slice;
 			slice_used = cfqq->allocated_slice;
+		}
+		if (time_after(cfqq->slice_start, cfqq->dispatch_start))
+			*unaccounted_time += cfqq->slice_start -
+					cfqq->dispatch_start;
 	}
 
 	return slice_used;
@@ -939,12 +945,12 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 				struct cfq_queue *cfqq)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
-	unsigned int used_sl, charge;
+	unsigned int used_sl, charge, unaccounted_sl = 0;
 	int nr_sync = cfqg->nr_cfqq - cfqg_busy_async_queues(cfqd, cfqg)
 			- cfqg->service_tree_idle.count;
 
 	BUG_ON(nr_sync < 0);
-	used_sl = charge = cfq_cfqq_slice_usage(cfqq);
+	used_sl = charge = cfq_cfqq_slice_usage(cfqq, &unaccounted_sl);
 
 	if (iops_mode(cfqd))
 		charge = cfqq->slice_dispatch;
@@ -970,7 +976,8 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u disp=%u charge=%u iops=%u"
 			" sect=%u", used_sl, cfqq->slice_dispatch, charge,
 			iops_mode(cfqd), cfqq->nr_sectors);
-	cfq_blkiocg_update_timeslice_used(&cfqg->blkg, used_sl);
+	cfq_blkiocg_update_timeslice_used(&cfqg->blkg, used_sl,
+					  unaccounted_sl);
 	cfq_blkiocg_set_start_empty_time(&cfqg->blkg);
 }
 
@@ -3314,9 +3321,7 @@ static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	BUG_ON(!cfq_cfqq_on_rr(cfqq));
 
 	cfq_service_tree_add(cfqd, cfqq, 1);
-
-	cfqq->slice_end = 0;
-	cfq_mark_cfqq_slice_new(cfqq);
+	__cfq_set_active_queue(cfqd, cfqq);
 }
 
 /*
diff --git a/block/cfq.h b/block/cfq.h
index 54a6d90..2a15592 100644
--- a/block/cfq.h
+++ b/block/cfq.h
@@ -16,9 +16,9 @@ static inline void cfq_blkiocg_update_dequeue_stats(struct blkio_group *blkg,
 }
 
 static inline void cfq_blkiocg_update_timeslice_used(struct blkio_group *blkg,
-			unsigned long time)
+			unsigned long time, unsigned long unaccounted_time)
 {
-	blkiocg_update_timeslice_used(blkg, time);
+	blkiocg_update_timeslice_used(blkg, time, unaccounted_time);
 }
 
 static inline void cfq_blkiocg_set_start_empty_time(struct blkio_group *blkg)
@@ -85,7 +85,7 @@ static inline void cfq_blkiocg_update_dequeue_stats(struct blkio_group *blkg,
 			unsigned long dequeue) {}
 
 static inline void cfq_blkiocg_update_timeslice_used(struct blkio_group *blkg,
-			unsigned long time) {}
+			unsigned long time, unsigned long unaccounted_time) {}
 static inline void cfq_blkiocg_set_start_empty_time(struct blkio_group *blkg) {}
 static inline void cfq_blkiocg_update_io_remove_stats(struct blkio_group *blkg,
 				bool direction, bool sync) {}
-- 
1.7.3.1

