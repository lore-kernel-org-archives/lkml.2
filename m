Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab1F1Pht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:37:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758672Ab1F1PfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:35:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org
Cc: andrea@betterlinux.com, vgoyal@redhat.com
Subject: [PATCH 1/8] blk-throttle: convert wait routines to return jiffies to wait
Date: Tue, 28 Jun 2011 11:35:02 -0400
Message-Id: <1309275309-12889-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
References: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we return jiffies to wait for in a function parameter.
A cleaner way would be to return it as return value. Value 0 would mean
that there is no need to wait and anything > 0 means number of jiffies
to wait before bio can be dispatched.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |   72 +++++++++++++++++++++-----------------------------
 1 files changed, 30 insertions(+), 42 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index f6a7941..d76717a 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -590,8 +590,8 @@ throtl_trim_slice(struct throtl_data *td, struct throtl_grp *tg, bool rw)
 			tg->slice_start[rw], tg->slice_end[rw], jiffies);
 }
 
-static bool tg_with_in_iops_limit(struct throtl_data *td, struct throtl_grp *tg,
-		struct bio *bio, unsigned long *wait)
+static unsigned long tg_wait_iops_limit(struct throtl_data *td,
+			struct throtl_grp *tg, struct bio *bio)
 {
 	bool rw = bio_data_dir(bio);
 	unsigned int io_allowed;
@@ -621,11 +621,8 @@ static bool tg_with_in_iops_limit(struct throtl_data *td, struct throtl_grp *tg,
 	else
 		io_allowed = tmp;
 
-	if (tg->io_disp[rw] + 1 <= io_allowed) {
-		if (wait)
-			*wait = 0;
-		return 1;
-	}
+	if (tg->io_disp[rw] + 1 <= io_allowed)
+		return 0;
 
 	/* Calc approx time to dispatch */
 	jiffy_wait = ((tg->io_disp[rw] + 1) * HZ)/tg->iops[rw] + 1;
@@ -635,13 +632,15 @@ static bool tg_with_in_iops_limit(struct throtl_data *td, struct throtl_grp *tg,
 	else
 		jiffy_wait = 1;
 
-	if (wait)
-		*wait = jiffy_wait;
-	return 0;
+	return jiffy_wait;
 }
 
-static bool tg_with_in_bps_limit(struct throtl_data *td, struct throtl_grp *tg,
-		struct bio *bio, unsigned long *wait)
+/*
+ * Returns number of jiffies to wait to before IO can be dispatched according
+ * to bps limit.
+ */
+static unsigned long tg_wait_bps_limit(struct throtl_data *td,
+			struct throtl_grp *tg, struct bio *bio)
 {
 	bool rw = bio_data_dir(bio);
 	u64 bytes_allowed, extra_bytes, tmp;
@@ -659,11 +658,8 @@ static bool tg_with_in_bps_limit(struct throtl_data *td, struct throtl_grp *tg,
 	do_div(tmp, HZ);
 	bytes_allowed = tmp;
 
-	if (tg->bytes_disp[rw] + bio->bi_size <= bytes_allowed) {
-		if (wait)
-			*wait = 0;
-		return 1;
-	}
+	if (tg->bytes_disp[rw] + bio->bi_size <= bytes_allowed)
+		return 0;
 
 	/* Calc approx time to dispatch */
 	extra_bytes = tg->bytes_disp[rw] + bio->bi_size - bytes_allowed;
@@ -677,9 +673,8 @@ static bool tg_with_in_bps_limit(struct throtl_data *td, struct throtl_grp *tg,
 	 * up we did. Add that time also.
 	 */
 	jiffy_wait = jiffy_wait + (jiffy_elapsed_rnd - jiffy_elapsed);
-	if (wait)
-		*wait = jiffy_wait;
-	return 0;
+
+	return jiffy_wait;
 }
 
 static bool tg_no_rule_group(struct throtl_grp *tg, bool rw) {
@@ -691,9 +686,12 @@ static bool tg_no_rule_group(struct throtl_grp *tg, bool rw) {
 /*
  * Returns whether one can dispatch a bio or not. Also returns approx number
  * of jiffies to wait before this bio is with-in IO rate and can be dispatched
+ *
+ * Retruns the number of jiffies one needs to wait before IO can be dispatched.
+ * 0 means, IO can be dispatched now.
  */
-static bool tg_may_dispatch(struct throtl_data *td, struct throtl_grp *tg,
-				struct bio *bio, unsigned long *wait)
+static unsigned long
+tg_wait_dispatch(struct throtl_data *td, struct throtl_grp *tg, struct bio *bio)
 {
 	bool rw = bio_data_dir(bio);
 	unsigned long bps_wait = 0, iops_wait = 0, max_wait = 0;
@@ -707,11 +705,8 @@ static bool tg_may_dispatch(struct throtl_data *td, struct throtl_grp *tg,
 	BUG_ON(tg->nr_queued[rw] && bio != bio_list_peek(&tg->bio_lists[rw]));
 
 	/* If tg->bps = -1, then BW is unlimited */
-	if (tg->bps[rw] == -1 && tg->iops[rw] == -1) {
-		if (wait)
-			*wait = 0;
-		return 1;
-	}
+	if (tg->bps[rw] == -1 && tg->iops[rw] == -1)
+		return 0;
 
 	/*
 	 * If previous slice expired, start a new one otherwise renew/extend
@@ -725,22 +720,15 @@ static bool tg_may_dispatch(struct throtl_data *td, struct throtl_grp *tg,
 			throtl_extend_slice(td, tg, rw, jiffies + throtl_slice);
 	}
 
-	if (tg_with_in_bps_limit(td, tg, bio, &bps_wait)
-	    && tg_with_in_iops_limit(td, tg, bio, &iops_wait)) {
-		if (wait)
-			*wait = 0;
-		return 1;
-	}
+	bps_wait = tg_wait_bps_limit(td, tg, bio);
+	iops_wait = tg_wait_iops_limit(td, tg, bio);
 
 	max_wait = max(bps_wait, iops_wait);
 
-	if (wait)
-		*wait = max_wait;
-
 	if (time_before(tg->slice_end[rw], jiffies + max_wait))
 		throtl_extend_slice(td, tg, rw, jiffies + max_wait);
 
-	return 0;
+	return max_wait;
 }
 
 static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
@@ -774,10 +762,10 @@ static void tg_update_disptime(struct throtl_data *td, struct throtl_grp *tg)
 	struct bio *bio;
 
 	if ((bio = bio_list_peek(&tg->bio_lists[READ])))
-		tg_may_dispatch(td, tg, bio, &read_wait);
+		read_wait = tg_wait_dispatch(td, tg, bio);
 
 	if ((bio = bio_list_peek(&tg->bio_lists[WRITE])))
-		tg_may_dispatch(td, tg, bio, &write_wait);
+		write_wait = tg_wait_dispatch(td, tg, bio);
 
 	min_wait = min(read_wait, write_wait);
 	disptime = jiffies + min_wait;
@@ -819,7 +807,7 @@ static int throtl_dispatch_tg(struct throtl_data *td, struct throtl_grp *tg,
 	/* Try to dispatch 75% READS and 25% WRITES */
 
 	while ((bio = bio_list_peek(&tg->bio_lists[READ]))
-		&& tg_may_dispatch(td, tg, bio, NULL)) {
+		&& !tg_wait_dispatch(td, tg, bio)) {
 
 		tg_dispatch_one_bio(td, tg, bio_data_dir(bio), bl);
 		nr_reads++;
@@ -829,7 +817,7 @@ static int throtl_dispatch_tg(struct throtl_data *td, struct throtl_grp *tg,
 	}
 
 	while ((bio = bio_list_peek(&tg->bio_lists[WRITE]))
-		&& tg_may_dispatch(td, tg, bio, NULL)) {
+		&& !tg_wait_dispatch(td, tg, bio)) {
 
 		tg_dispatch_one_bio(td, tg, bio_data_dir(bio), bl);
 		nr_writes++;
@@ -1185,7 +1173,7 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 	}
 
 	/* Bio is with-in rate limit of group */
-	if (tg_may_dispatch(td, tg, bio, NULL)) {
+	if (!tg_wait_dispatch(td, tg, bio)) {
 		throtl_charge_bio(tg, bio);
 
 		/*
-- 
1.7.4.4

