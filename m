Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab2EVIK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:10:58 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:56146 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752988Ab2EVIKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:10:55 -0400
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC] block/throttle: Add IO throttled information in blkcg.
Date: Tue, 22 May 2012 16:10:36 +0800
Message-Id: <1337674236-2896-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Currently, if the IO is throttled by io-throttle, the SA has no idea of
the situation and can't report it to the real application user about
that he/she has to do something. So this patch adds a new interface
named blkio.throttle.io_throttled which indicates how many IOs are
currently throttled.

I am not sure whether it is OK to add this information to the generic
blkcg since it is only io-throttle related, but I don't find a way to
only store it into the blkcg io-throttle. And that's the reason this
is only a RFC. Any suggestions? Thanks.

Cc: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 block/blk-cgroup.c   |   39 +++++++++++++++++++++++++++++++++++++++
 block/blk-cgroup.h   |   13 +++++++++++++
 block/blk-throttle.c |    7 ++++++-
 3 files changed, 58 insertions(+), 1 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index ea84a23..bf4d11b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -348,6 +348,31 @@ static inline void blkio_set_start_group_wait_time(struct blkio_group *blkg,
 static inline void blkio_end_empty_time(struct blkio_group_stats *stats) {}
 #endif
 
+void blkiocg_update_io_throttled_stats(struct blkio_group *blkg,
+			struct blkio_group *curr_blkg, bool direction,
+			bool sync)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&blkg->stats_lock, flags);
+	blkio_add_stat(blkg->stats.stat_arr[BLKIO_STAT_THROTTLED], 1, direction,
+			sync);
+	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+}
+EXPORT_SYMBOL_GPL(blkiocg_update_io_throttled_stats);
+
+void blkiocg_update_io_throttled_remove_stats(struct blkio_group *blkg,
+						bool direction, bool sync)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&blkg->stats_lock, flags);
+	blkio_check_and_dec_stat(blkg->stats.stat_arr[BLKIO_STAT_THROTTLED],
+					direction, sync);
+	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+}
+EXPORT_SYMBOL_GPL(blkiocg_update_io_throttled_remove_stats);
+
 void blkiocg_update_io_add_stats(struct blkio_group *blkg,
 			struct blkio_group *curr_blkg, bool direction,
 			bool sync)
@@ -578,6 +603,7 @@ blkiocg_reset_stats(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 	struct blkio_group_stats *stats;
 	struct hlist_node *n;
 	uint64_t queued[BLKIO_STAT_TOTAL];
+	uint64_t throttled[BLKIO_STAT_TOTAL];
 	int i;
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	bool idling, waiting, empty;
@@ -596,9 +622,13 @@ blkiocg_reset_stats(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 #endif
 		for (i = 0; i < BLKIO_STAT_TOTAL; i++)
 			queued[i] = stats->stat_arr[BLKIO_STAT_QUEUED][i];
+		for (i = 0; i < BLKIO_STAT_TOTAL; i++)
+			throttled[i] = stats->stat_arr[BLKIO_STAT_THROTTLED][i];
 		memset(stats, 0, sizeof(struct blkio_group_stats));
 		for (i = 0; i < BLKIO_STAT_TOTAL; i++)
 			stats->stat_arr[BLKIO_STAT_QUEUED][i] = queued[i];
+		for (i = 0; i < BLKIO_STAT_TOTAL; i++)
+			stats->stat_arr[BLKIO_STAT_THROTTLED][i] = throttled[i];
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 		if (idling) {
 			blkio_mark_blkg_idling(stats);
@@ -1301,6 +1331,9 @@ static int blkiocg_file_read_map(struct cgroup *cgrp, struct cftype *cft,
 		case BLKIO_THROTL_io_serviced:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
 						BLKIO_STAT_CPU_SERVICED, 1, 1);
+		case BLKIO_THROTL_io_throttled:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_THROTTLED, 1, 0);
 		default:
 			BUG();
 		}
@@ -1497,6 +1530,12 @@ struct cftype blkio_files[] = {
 				BLKIO_THROTL_io_serviced),
 		.read_map = blkiocg_file_read_map,
 	},
+	{
+		.name = "throttle.io_throttled",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
+				BLKIO_THROTL_io_throttled),
+		.read_map = blkiocg_file_read_map,
+	},
 #endif /* CONFIG_BLK_DEV_THROTTLING */
 
 #ifdef CONFIG_DEBUG_BLK_CGROUP
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 6f3ace7..5b97eb7 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -39,6 +39,8 @@ enum stat_type {
 	BLKIO_STAT_SERVICE_TIME = 0,
 	/* Total time spent waiting in scheduler queue in ns */
 	BLKIO_STAT_WAIT_TIME,
+	/* Number of IOs throttled */
+	BLKIO_STAT_THROTTLED,
 	/* Number of IOs queued up */
 	BLKIO_STAT_QUEUED,
 	/* All the single valued stats go below this */
@@ -109,6 +111,7 @@ enum blkcg_file_name_throtl {
 	BLKIO_THROTL_write_iops_device,
 	BLKIO_THROTL_io_service_bytes,
 	BLKIO_THROTL_io_serviced,
+	BLKIO_THROTL_io_throttled,
 };
 
 struct blkio_cgroup {
@@ -327,6 +330,11 @@ void blkiocg_update_io_add_stats(struct blkio_group *blkg,
 		struct blkio_group *curr_blkg, bool direction, bool sync);
 void blkiocg_update_io_remove_stats(struct blkio_group *blkg,
 					bool direction, bool sync);
+void blkiocg_update_io_throttled_stats(struct blkio_group *blkg,
+		struct blkio_group *curr_blkg, bool direction, bool sync);
+void blkiocg_update_io_throttled_remove_stats(struct blkio_group *blkg,
+					      bool direction, bool sync);
+
 #else
 struct cgroup;
 static inline struct blkio_cgroup *
@@ -360,5 +368,10 @@ static inline void blkiocg_update_io_add_stats(struct blkio_group *blkg,
 		struct blkio_group *curr_blkg, bool direction, bool sync) {}
 static inline void blkiocg_update_io_remove_stats(struct blkio_group *blkg,
 						bool direction, bool sync) {}
+static inline void blkiocg_update_io_throttled_stats(struct blkio_group *blkg,
+		struct blkio_group *curr_blkg, bool direction, bool sync) {}
+static inline void
+blkiocg_update_io_throttled_remove_stats(struct blkio_group *blkg,
+		struct blkio_group *curr_blkg, bool direction, bool sync) {}
 #endif
 #endif /* _BLK_CGROUP_H */
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index f2ddb94..1a39305 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -749,13 +749,15 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 static void throtl_add_bio_tg(struct throtl_data *td, struct throtl_grp *tg,
 			struct bio *bio)
 {
-	bool rw = bio_data_dir(bio);
+	int rw = bio_data_dir(bio);
+	int sync = !(bio->bi_rw & REQ_WRITE) || (bio->bi_rw & REQ_SYNC);
 
 	bio_list_add(&tg->bio_lists[rw], bio);
 	/* Take a bio reference on tg */
 	throtl_ref_get_tg(tg);
 	tg->nr_queued[rw]++;
 	td->nr_queued[rw]++;
+	blkiocg_update_io_throttled_stats(&tg->blkg, NULL, rw, sync);
 	throtl_enqueue_tg(td, tg);
 }
 
@@ -783,9 +785,12 @@ static void tg_dispatch_one_bio(struct throtl_data *td, struct throtl_grp *tg,
 				bool rw, struct bio_list *bl)
 {
 	struct bio *bio;
+	bool sync;
 
 	bio = bio_list_pop(&tg->bio_lists[rw]);
+	sync = !(bio->bi_rw & REQ_WRITE) || (bio->bi_rw & REQ_SYNC);
 	tg->nr_queued[rw]--;
+	blkiocg_update_io_throttled_remove_stats(&tg->blkg, rw, sync);
 	/* Drop bio reference on tg */
 	throtl_put_tg(tg);
 
-- 
1.7.1

