Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab0IOVHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 17:07:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab0IOVHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 17:07:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: nauman@google.com, dpshah@google.com, guijianfeng@cn.fujitsu.com,
        vgoyal@redhat.com
Subject: [PATCH 6/7] blkio: Implementation of IOPS limit logic
Date: Wed, 15 Sep 2010 17:06:37 -0400
Message-Id: <1284584798-10264-7-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1284584798-10264-1-git-send-email-vgoyal@redhat.com>
References: <1284584798-10264-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o core logic of implementing IOPS throttling.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |  164 ++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 127 insertions(+), 37 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 966afc7..af53f37 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -59,8 +59,13 @@ struct throtl_grp {
 	/* bytes per second rate limits */
 	uint64_t bps[2];
 
+	/* IOPS limits */
+	unsigned int iops[2];
+
 	/* Number of bytes disptached in current slice */
 	uint64_t bytes_disp[2];
+	/* Number of bio's dispatched in current slice */
+	unsigned int io_disp[2];
 
 	/* When did we start a new slice */
 	unsigned long slice_start[2];
@@ -194,6 +199,8 @@ static struct throtl_grp * throtl_find_alloc_tg(struct throtl_data *td,
 
 	tg->bps[READ] = blkcg_get_read_bps(blkcg, tg->blkg.dev);
 	tg->bps[WRITE] = blkcg_get_write_bps(blkcg, tg->blkg.dev);
+	tg->iops[READ] = blkcg_get_read_iops(blkcg, tg->blkg.dev);
+	tg->iops[WRITE] = blkcg_get_write_iops(blkcg, tg->blkg.dev);
 
 	hlist_add_head(&tg->tg_node, &td->tg_list);
 	td->nr_undestroyed_grps++;
@@ -335,6 +342,7 @@ static inline void
 throtl_start_new_slice(struct throtl_data *td, struct throtl_grp *tg, bool rw)
 {
 	tg->bytes_disp[rw] = 0;
+	tg->io_disp[rw] = 0;
 	tg->slice_start[rw] = jiffies;
 	tg->slice_end[rw] = jiffies + throtl_slice;
 	throtl_log_tg(td, tg, "[%c] new slice start=%lu end=%lu jiffies=%lu",
@@ -365,7 +373,7 @@ throtl_slice_used(struct throtl_data *td, struct throtl_grp *tg, bool rw)
 static inline void
 throtl_trim_slice(struct throtl_data *td, struct throtl_grp *tg, bool rw)
 {
-	unsigned long nr_slices, bytes_trim, time_elapsed;
+	unsigned long nr_slices, bytes_trim, time_elapsed, io_trim;
 
 	BUG_ON(time_before(tg->slice_end[rw], tg->slice_start[rw]));
 
@@ -385,8 +393,9 @@ throtl_trim_slice(struct throtl_data *td, struct throtl_grp *tg, bool rw)
 		return;
 
 	bytes_trim = (tg->bps[rw] * throtl_slice * nr_slices)/HZ;
+	io_trim = (tg->iops[rw] * throtl_slice * nr_slices)/HZ;
 
-	if (!bytes_trim)
+	if (!bytes_trim && !io_trim)
 		return;
 
 	if (tg->bytes_disp[rw] >= bytes_trim)
@@ -394,51 +403,62 @@ throtl_trim_slice(struct throtl_data *td, struct throtl_grp *tg, bool rw)
 	else
 		tg->bytes_disp[rw] = 0;
 
+	if (tg->io_disp[rw] >= io_trim)
+		tg->io_disp[rw] -= io_trim;
+	else
+		tg->io_disp[rw] = 0;
+
 	tg->slice_start[rw] += nr_slices * throtl_slice;
 
-	throtl_log_tg(td, tg, "[%c] trim slice nr=%lu bytes=%lu"
+	throtl_log_tg(td, tg, "[%c] trim slice nr=%lu bytes=%lu io=%lu"
 			" start=%lu end=%lu jiffies=%lu",
-			rw == READ ? 'R' : 'W', nr_slices, bytes_trim,
+			rw == READ ? 'R' : 'W', nr_slices, bytes_trim, io_trim,
 			tg->slice_start[rw], tg->slice_end[rw], jiffies);
 }
 
-/*
- * Returns whether one can dispatch a bio or not. Also returns approx number
- * of jiffies to wait before this bio is with-in IO rate and can be dispatched
- */
-static bool tg_may_dispatch(struct throtl_data *td, struct throtl_grp *tg,
-				struct bio *bio, unsigned long *wait)
+static bool tg_with_in_iops_limit(struct throtl_data *td, struct throtl_grp *tg,
+		struct bio *bio, unsigned long *wait)
 {
 	bool rw = bio_data_dir(bio);
-	u64 bytes_allowed, extra_bytes;
+	unsigned int io_allowed;
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 
-	/*
- 	 * Currently whole state machine of group depends on first bio
-	 * queued in the group bio list. So one should not be calling
-	 * this function with a different bio if there are other bios
-	 * queued.
-	 */
-	BUG_ON(tg->nr_queued[rw] && bio != bio_list_peek(&tg->bio_lists[rw]));
+	jiffy_elapsed = jiffy_elapsed_rnd = jiffies - tg->slice_start[rw];
 
-	/* If tg->bps = -1, then BW is unlimited */
-	if (tg->bps[rw] == -1) {
+	/* Slice has just started. Consider one slice interval */
+	if (!jiffy_elapsed)
+		jiffy_elapsed_rnd = throtl_slice;
+
+	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, throtl_slice);
+
+	io_allowed = (tg->iops[rw] * jiffies_to_msecs(jiffy_elapsed_rnd))
+				/ MSEC_PER_SEC;
+
+	if (tg->io_disp[rw] + 1 <= io_allowed) {
 		if (wait)
 			*wait = 0;
 		return 1;
 	}
 
-	/*
-	 * If previous slice expired, start a new one otherwise renew/extend
-	 * existing slice to make sure it is at least throtl_slice interval
-	 * long since now.
-	 */
-	if (throtl_slice_used(td, tg, rw))
-		throtl_start_new_slice(td, tg, rw);
-	else {
-		if (time_before(tg->slice_end[rw], jiffies + throtl_slice))
-			throtl_extend_slice(td, tg, rw, jiffies + throtl_slice);
-	}
+	/* Calc approx time to dispatch */
+	jiffy_wait = ((tg->io_disp[rw] + 1) * HZ)/tg->iops[rw] + 1;
+
+	if (jiffy_wait > jiffy_elapsed)
+		jiffy_wait = jiffy_wait - jiffy_elapsed;
+	else
+		jiffy_wait = 1;
+
+	if (wait)
+		*wait = jiffy_wait;
+	return 0;
+}
+
+static bool tg_with_in_bps_limit(struct throtl_data *td, struct throtl_grp *tg,
+		struct bio *bio, unsigned long *wait)
+{
+	bool rw = bio_data_dir(bio);
+	u64 bytes_allowed, extra_bytes;
+	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 
 	jiffy_elapsed = jiffy_elapsed_rnd = jiffies - tg->slice_start[rw];
 
@@ -469,12 +489,62 @@ static bool tg_may_dispatch(struct throtl_data *td, struct throtl_grp *tg,
 	 * up we did. Add that time also.
 	 */
 	jiffy_wait = jiffy_wait + (jiffy_elapsed_rnd - jiffy_elapsed);
-
 	if (wait)
 		*wait = jiffy_wait;
+	return 0;
+}
+
+/*
+ * Returns whether one can dispatch a bio or not. Also returns approx number
+ * of jiffies to wait before this bio is with-in IO rate and can be dispatched
+ */
+static bool tg_may_dispatch(struct throtl_data *td, struct throtl_grp *tg,
+				struct bio *bio, unsigned long *wait)
+{
+	bool rw = bio_data_dir(bio);
+	unsigned long bps_wait = 0, iops_wait = 0, max_wait = 0;
+
+	/*
+ 	 * Currently whole state machine of group depends on first bio
+	 * queued in the group bio list. So one should not be calling
+	 * this function with a different bio if there are other bios
+	 * queued.
+	 */
+	BUG_ON(tg->nr_queued[rw] && bio != bio_list_peek(&tg->bio_lists[rw]));
+
+	/* If tg->bps = -1, then BW is unlimited */
+	if (tg->bps[rw] == -1 && tg->iops[rw] == -1) {
+		if (wait)
+			*wait = 0;
+		return 1;
+	}
+
+	/*
+	 * If previous slice expired, start a new one otherwise renew/extend
+	 * existing slice to make sure it is at least throtl_slice interval
+	 * long since now.
+	 */
+	if (throtl_slice_used(td, tg, rw))
+		throtl_start_new_slice(td, tg, rw);
+	else {
+		if (time_before(tg->slice_end[rw], jiffies + throtl_slice))
+			throtl_extend_slice(td, tg, rw, jiffies + throtl_slice);
+	}
+
+	if (tg_with_in_bps_limit(td, tg, bio, &bps_wait)
+	    && tg_with_in_iops_limit(td, tg, bio, &iops_wait)) {
+		if (wait)
+			*wait = 0;
+		return 1;
+	}
 
-	if (time_before(tg->slice_end[rw], jiffies + jiffy_wait))
-		throtl_extend_slice(td, tg, rw, jiffies + jiffy_wait);
+	max_wait = max(bps_wait, iops_wait);
+
+	if (wait)
+		*wait = max_wait;
+
+	if (time_before(tg->slice_end[rw], jiffies + max_wait))
+		throtl_extend_slice(td, tg, rw, jiffies + max_wait);
 
 	return 0;
 }
@@ -486,13 +556,13 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 
 	/* Charge the bio to the group */
 	tg->bytes_disp[rw] += bio->bi_size;
+	tg->io_disp[rw]++;
 
 	/*
 	 * TODO: This will take blkg->stats_lock. Figure out a way
 	 * to avoid this cost.
 	 */
 	blkiocg_update_dispatch_stats(&tg->blkg, bio->bi_size, rw, sync);
-
 }
 
 static void throtl_add_bio_tg(struct throtl_data *td, struct throtl_grp *tg,
@@ -763,6 +833,18 @@ static void throtl_update_blkio_group_write_bps (struct blkio_group *blkg,
 	tg_of_blkg(blkg)->bps[WRITE] = write_bps;
 }
 
+static void throtl_update_blkio_group_read_iops (struct blkio_group *blkg,
+			unsigned int read_iops)
+{
+	tg_of_blkg(blkg)->iops[READ] = read_iops;
+}
+
+static void throtl_update_blkio_group_write_iops (struct blkio_group *blkg,
+			unsigned int write_iops)
+{
+	tg_of_blkg(blkg)->iops[WRITE] = write_iops;
+}
+
 void throtl_shutdown_timer_wq(struct request_queue *q)
 {
 	struct throtl_data *td = q->td;
@@ -777,7 +859,12 @@ static struct blkio_policy_type blkio_policy_throtl = {
 					throtl_update_blkio_group_read_bps,
 		.blkio_update_group_write_bps_fn =
 					throtl_update_blkio_group_write_bps,
+		.blkio_update_group_read_iops_fn =
+					throtl_update_blkio_group_read_iops,
+		.blkio_update_group_write_iops_fn =
+					throtl_update_blkio_group_write_iops,
 	},
+	.plid = BLKIO_POLICY_THROTL,
 };
 
 int blk_throtl_bio(struct request_queue *q, struct bio **biop)
@@ -811,9 +898,11 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 	}
 
 queue_bio:
-	throtl_log_tg(td, tg, "[%c] bio. disp=%u sz=%u bps=%llu"
-			" queued=%d/%d", rw == READ ? 'R' : 'W',
+	throtl_log_tg(td, tg, "[%c] bio. bdisp=%u sz=%u bps=%llu"
+			" iodisp=%u iops=%u queued=%d/%d",
+			rw == READ ? 'R' : 'W',
 			tg->bytes_disp[rw], bio->bi_size, tg->bps[rw],
+			tg->io_disp[rw], tg->iops[rw],
 			tg->nr_queued[READ], tg->nr_queued[WRITE]);
 
 	throtl_add_bio_tg(q->td, tg, bio);
@@ -850,6 +939,7 @@ int blk_throtl_init(struct request_queue *q)
 
 	/* Practically unlimited BW */
 	tg->bps[0] = tg->bps[1] = -1;
+	tg->iops[0] = tg->iops[1] = -1;
 	atomic_set(&tg->ref, 1);
 
 	INIT_DELAYED_WORK(&td->throtl_work, blk_throtl_work);
-- 
1.7.2.3

