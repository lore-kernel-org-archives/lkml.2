Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab1F1PiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:38:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758636Ab1F1PfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:35:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org
Cc: andrea@betterlinux.com, vgoyal@redhat.com
Subject: [PATCH 3/8] blk-throttle: use io size and direction as parameters to wait routines
Date: Tue, 28 Jun 2011 11:35:04 -0400
Message-Id: <1309275309-12889-4-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
References: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I want to reuse wait routines for task wait also. Hence get rid of
dependency of bio being passed in. Instead pass in direction of IO
and size of IO.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |   52 +++++++++++++++++++++++--------------------------
 1 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 8facd17..885ee4a 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -591,9 +591,8 @@ throtl_trim_slice(struct throtl_data *td, struct throtl_grp *tg, bool rw)
 }
 
 static unsigned long tg_wait_iops_limit(struct throtl_data *td,
-			struct throtl_grp *tg, struct bio *bio)
+			struct throtl_grp *tg, bool rw, unsigned int nr_ios)
 {
-	bool rw = bio_data_dir(bio);
 	unsigned int io_allowed;
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 	u64 tmp;
@@ -621,11 +620,11 @@ static unsigned long tg_wait_iops_limit(struct throtl_data *td,
 	else
 		io_allowed = tmp;
 
-	if (tg->io_disp[rw] + 1 <= io_allowed)
+	if (tg->io_disp[rw] + nr_ios <= io_allowed)
 		return 0;
 
 	/* Calc approx time to dispatch */
-	jiffy_wait = ((tg->io_disp[rw] + 1) * HZ)/tg->iops[rw] + 1;
+	jiffy_wait = ((tg->io_disp[rw] + nr_ios) * HZ)/tg->iops[rw] + 1;
 
 	if (jiffy_wait > jiffy_elapsed)
 		jiffy_wait = jiffy_wait - jiffy_elapsed;
@@ -640,9 +639,8 @@ static unsigned long tg_wait_iops_limit(struct throtl_data *td,
  * to bps limit.
  */
 static unsigned long tg_wait_bps_limit(struct throtl_data *td,
-			struct throtl_grp *tg, struct bio *bio)
+			struct throtl_grp *tg, bool rw, unsigned int sz)
 {
-	bool rw = bio_data_dir(bio);
 	u64 bytes_allowed, extra_bytes, tmp;
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 
@@ -658,11 +656,11 @@ static unsigned long tg_wait_bps_limit(struct throtl_data *td,
 	do_div(tmp, HZ);
 	bytes_allowed = tmp;
 
-	if (tg->bytes_disp[rw] + bio->bi_size <= bytes_allowed)
+	if (tg->bytes_disp[rw] + sz <= bytes_allowed)
 		return 0;
 
 	/* Calc approx time to dispatch */
-	extra_bytes = tg->bytes_disp[rw] + bio->bi_size - bytes_allowed;
+	extra_bytes = tg->bytes_disp[rw] + sz - bytes_allowed;
 	jiffy_wait = div64_u64(extra_bytes * HZ, tg->bps[rw]);
 
 	if (!jiffy_wait)
@@ -690,10 +688,9 @@ static bool tg_no_rule_group(struct throtl_grp *tg, bool rw) {
  * Retruns the number of jiffies one needs to wait before IO can be dispatched.
  * 0 means, IO can be dispatched now.
  */
-static unsigned long
-tg_wait_dispatch(struct throtl_data *td, struct throtl_grp *tg, struct bio *bio)
+static unsigned long tg_wait_dispatch(struct throtl_data *td,
+	struct throtl_grp *tg, bool rw, unsigned int sz, unsigned int nr_ios)
 {
-	bool rw = bio_data_dir(bio);
 	unsigned long bps_wait = 0, iops_wait = 0, max_wait = 0;
 
 	/* If tg->bps = -1, then BW is unlimited */
@@ -712,8 +709,8 @@ tg_wait_dispatch(struct throtl_data *td, struct throtl_grp *tg, struct bio *bio)
 			throtl_extend_slice(td, tg, rw, jiffies + throtl_slice);
 	}
 
-	bps_wait = tg_wait_bps_limit(td, tg, bio);
-	iops_wait = tg_wait_iops_limit(td, tg, bio);
+	bps_wait = tg_wait_bps_limit(td, tg, rw, sz);
+	iops_wait = tg_wait_iops_limit(td, tg, rw, nr_ios);
 
 	max_wait = max(bps_wait, iops_wait);
 
@@ -723,16 +720,14 @@ tg_wait_dispatch(struct throtl_data *td, struct throtl_grp *tg, struct bio *bio)
 	return max_wait;
 }
 
-static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
+static void throtl_charge_io(struct throtl_grp *tg, bool rw, unsigned int sz,
+				unsigned int nr_ios, bool sync)
 {
-	bool rw = bio_data_dir(bio);
-	bool sync = bio->bi_rw & REQ_SYNC;
-
-	/* Charge the bio to the group */
-	tg->bytes_disp[rw] += bio->bi_size;
-	tg->io_disp[rw]++;
+	/* Charge the io to the group */
+	tg->bytes_disp[rw] += sz;
+	tg->io_disp[rw] += nr_ios;
 
-	blkiocg_update_dispatch_stats(&tg->blkg, bio->bi_size, rw, sync);
+	blkiocg_update_dispatch_stats(&tg->blkg, sz, rw, sync);
 }
 
 static void throtl_add_bio_tg(struct throtl_data *td, struct throtl_grp *tg,
@@ -754,10 +749,10 @@ static void tg_update_disptime(struct throtl_data *td, struct throtl_grp *tg)
 	struct bio *bio;
 
 	if ((bio = bio_list_peek(&tg->bio_lists[READ])))
-		read_wait = tg_wait_dispatch(td, tg, bio);
+		read_wait = tg_wait_dispatch(td, tg, READ, bio->bi_size, 1);
 
 	if ((bio = bio_list_peek(&tg->bio_lists[WRITE])))
-		write_wait = tg_wait_dispatch(td, tg, bio);
+		write_wait = tg_wait_dispatch(td, tg, WRITE, bio->bi_size, 1);
 
 	min_wait = min(read_wait, write_wait);
 	disptime = jiffies + min_wait;
@@ -781,7 +776,7 @@ static void tg_dispatch_one_bio(struct throtl_data *td, struct throtl_grp *tg,
 	BUG_ON(td->nr_queued[rw] <= 0);
 	td->nr_queued[rw]--;
 
-	throtl_charge_bio(tg, bio);
+	throtl_charge_io(tg, rw, bio->bi_size, 1, bio->bi_rw & REQ_SYNC);
 	bio_list_add(bl, bio);
 	bio->bi_rw |= REQ_THROTTLED;
 
@@ -799,7 +794,7 @@ static int throtl_dispatch_tg(struct throtl_data *td, struct throtl_grp *tg,
 	/* Try to dispatch 75% READS and 25% WRITES */
 
 	while ((bio = bio_list_peek(&tg->bio_lists[READ]))
-		&& !tg_wait_dispatch(td, tg, bio)) {
+		&& !tg_wait_dispatch(td, tg, READ, bio->bi_size, 1)) {
 
 		tg_dispatch_one_bio(td, tg, bio_data_dir(bio), bl);
 		nr_reads++;
@@ -809,7 +804,7 @@ static int throtl_dispatch_tg(struct throtl_data *td, struct throtl_grp *tg,
 	}
 
 	while ((bio = bio_list_peek(&tg->bio_lists[WRITE]))
-		&& !tg_wait_dispatch(td, tg, bio)) {
+		&& !tg_wait_dispatch(td, tg, WRITE, bio->bi_size, 1)) {
 
 		tg_dispatch_one_bio(td, tg, bio_data_dir(bio), bl);
 		nr_writes++;
@@ -1165,8 +1160,9 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 	}
 
 	/* Bio is with-in rate limit of group */
-	if (!tg_wait_dispatch(td, tg, bio)) {
-		throtl_charge_bio(tg, bio);
+	if (!tg_wait_dispatch(td, tg, rw, bio->bi_size, 1)) {
+		throtl_charge_io(tg, rw, bio->bi_size, 1,
+					bio->bi_rw & REQ_SYNC);
 
 		/*
 		 * We need to trim slice even when bios are not being queued
-- 
1.7.4.4

