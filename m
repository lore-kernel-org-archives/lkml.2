Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab2BGXB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 18:01:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64079 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab2BGXB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 18:01:58 -0500
Date: Tue, 7 Feb 2012 15:01:53 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH block/for-linus 1/2] block: separate out blk_rq_merge_ok()
 and blk_try_merge() from elevator functions
Message-ID: <20120207230153.GK21292@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_rq_merge_ok() is the elevator-neutral part of merge eligibility
test.  blk_try_merge() determines merge direction and expects the
caller to have tested elv_rq_merge_ok() previously.

elv_rq_merge_ok() now wraps blk_rq_merge_ok() and then calls
elv_iosched_allow_merge().  elv_try_merge() is removed and the two
callers are updated to call elv_rq_merge_ok() explicitly followed by
blk_try_merge().  While at it, make rq_merge_ok() functions return
bool.

This is to prepare for plug merge update and doesn't introduce any
behavior change.

This is based on Jens' patch to skip elevator_allow_merge_fn() from
plug merge.

Signed-off-by: Tejun Heo <tj@kernel.org>
LKML-Reference: <4F16F3CA.90904@kernel.dk>
Original-patch-by: Jens Axboe <axboe@kernel.dk>
---
Jens, these two patches fix the easy-to-trigger oops on elevator
switch bug.  These are based on your previous patch.

Thanks.

 block/blk-core.c         |    4 +--
 block/blk-merge.c        |   37 +++++++++++++++++++++++++++++++
 block/blk.h              |    2 +
 block/elevator.c         |   55 +++--------------------------------------------
 include/linux/elevator.h |    3 --
 5 files changed, 46 insertions(+), 55 deletions(-)

Index: work/block/blk-merge.c
===================================================================
--- work.orig/block/blk-merge.c
+++ work/block/blk-merge.c
@@ -471,3 +471,40 @@ int blk_attempt_req_merge(struct request
 {
 	return attempt_merge(q, rq, next);
 }
+
+bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
+{
+	if (!rq_mergeable(rq))
+		return false;
+
+	/* don't merge file system requests and discard requests */
+	if ((bio->bi_rw & REQ_DISCARD) != (rq->bio->bi_rw & REQ_DISCARD))
+		return false;
+
+	/* don't merge discard requests and secure discard requests */
+	if ((bio->bi_rw & REQ_SECURE) != (rq->bio->bi_rw & REQ_SECURE))
+		return false;
+
+	/* different data direction or already started, don't merge */
+	if (bio_data_dir(bio) != rq_data_dir(rq))
+		return false;
+
+	/* must be same device and not a special request */
+	if (rq->rq_disk != bio->bi_bdev->bd_disk || rq->special)
+		return false;
+
+	/* only merge integrity protected bio into ditto rq */
+	if (bio_integrity(bio) != blk_integrity_rq(rq))
+		return false;
+
+	return true;
+}
+
+int blk_try_merge(struct request *rq, struct bio *bio)
+{
+	if (blk_rq_pos(rq) + blk_rq_sectors(rq) == bio->bi_sector)
+		return ELEVATOR_BACK_MERGE;
+	else if (blk_rq_pos(rq) - bio_sectors(bio) == bio->bi_sector)
+		return ELEVATOR_FRONT_MERGE;
+	return ELEVATOR_NO_MERGE;
+}
Index: work/block/blk.h
===================================================================
--- work.orig/block/blk.h
+++ work/block/blk.h
@@ -137,6 +137,8 @@ int blk_attempt_req_merge(struct request
 				struct request *next);
 void blk_recalc_rq_segments(struct request *rq);
 void blk_rq_set_mixed_merge(struct request *rq);
+bool blk_rq_merge_ok(struct request *rq, struct bio *bio);
+int blk_try_merge(struct request *rq, struct bio *bio);
 
 void blk_queue_congestion_threshold(struct request_queue *q);
 
Index: work/block/elevator.c
===================================================================
--- work.orig/block/elevator.c
+++ work/block/elevator.c
@@ -70,39 +70,9 @@ static int elv_iosched_allow_merge(struc
 /*
  * can we safely merge with this request?
  */
-int elv_rq_merge_ok(struct request *rq, struct bio *bio)
+bool elv_rq_merge_ok(struct request *rq, struct bio *bio)
 {
-	if (!rq_mergeable(rq))
-		return 0;
-
-	/*
-	 * Don't merge file system requests and discard requests
-	 */
-	if ((bio->bi_rw & REQ_DISCARD) != (rq->bio->bi_rw & REQ_DISCARD))
-		return 0;
-
-	/*
-	 * Don't merge discard requests and secure discard requests
-	 */
-	if ((bio->bi_rw & REQ_SECURE) != (rq->bio->bi_rw & REQ_SECURE))
-		return 0;
-
-	/*
-	 * different data direction or already started, don't merge
-	 */
-	if (bio_data_dir(bio) != rq_data_dir(rq))
-		return 0;
-
-	/*
-	 * must be same device and not a special request
-	 */
-	if (rq->rq_disk != bio->bi_bdev->bd_disk || rq->special)
-		return 0;
-
-	/*
-	 * only merge integrity protected bio into ditto rq
-	 */
-	if (bio_integrity(bio) != blk_integrity_rq(rq))
+	if (!blk_rq_merge_ok(rq, bio))
 		return 0;
 
 	if (!elv_iosched_allow_merge(rq, bio))
@@ -112,23 +82,6 @@ int elv_rq_merge_ok(struct request *rq, 
 }
 EXPORT_SYMBOL(elv_rq_merge_ok);
 
-int elv_try_merge(struct request *__rq, struct bio *bio)
-{
-	int ret = ELEVATOR_NO_MERGE;
-
-	/*
-	 * we can merge and sequence is ok, check if it's possible
-	 */
-	if (elv_rq_merge_ok(__rq, bio)) {
-		if (blk_rq_pos(__rq) + blk_rq_sectors(__rq) == bio->bi_sector)
-			ret = ELEVATOR_BACK_MERGE;
-		else if (blk_rq_pos(__rq) - bio_sectors(bio) == bio->bi_sector)
-			ret = ELEVATOR_FRONT_MERGE;
-	}
-
-	return ret;
-}
-
 static struct elevator_type *elevator_find(const char *name)
 {
 	struct elevator_type *e;
@@ -478,8 +431,8 @@ int elv_merge(struct request_queue *q, s
 	/*
 	 * First try one-hit cache.
 	 */
-	if (q->last_merge) {
-		ret = elv_try_merge(q->last_merge, bio);
+	if (q->last_merge && elv_rq_merge_ok(q->last_merge, bio)) {
+		ret = blk_try_merge(q->last_merge, bio);
 		if (ret != ELEVATOR_NO_MERGE) {
 			*req = q->last_merge;
 			return ret;
Index: work/include/linux/elevator.h
===================================================================
--- work.orig/include/linux/elevator.h
+++ work/include/linux/elevator.h
@@ -122,7 +122,6 @@ extern void elv_dispatch_add_tail(struct
 extern void elv_add_request(struct request_queue *, struct request *, int);
 extern void __elv_add_request(struct request_queue *, struct request *, int);
 extern int elv_merge(struct request_queue *, struct request **, struct bio *);
-extern int elv_try_merge(struct request *, struct bio *);
 extern void elv_merge_requests(struct request_queue *, struct request *,
 			       struct request *);
 extern void elv_merged_request(struct request_queue *, struct request *, int);
@@ -155,7 +154,7 @@ extern ssize_t elv_iosched_store(struct 
 extern int elevator_init(struct request_queue *, char *);
 extern void elevator_exit(struct elevator_queue *);
 extern int elevator_change(struct request_queue *, const char *);
-extern int elv_rq_merge_ok(struct request *, struct bio *);
+extern bool elv_rq_merge_ok(struct request *, struct bio *);
 
 /*
  * Helper functions.
Index: work/block/blk-core.c
===================================================================
--- work.orig/block/blk-core.c
+++ work/block/blk-core.c
@@ -1282,10 +1282,10 @@ static bool attempt_plug_merge(struct re
 
 		(*request_count)++;
 
-		if (rq->q != q)
+		if (rq->q != q || !elv_rq_merge_ok(rq, bio))
 			continue;
 
-		el_ret = elv_try_merge(rq, bio);
+		el_ret = blk_try_merge(rq, bio);
 		if (el_ret == ELEVATOR_BACK_MERGE) {
 			ret = bio_attempt_back_merge(q, rq, bio);
 			if (ret)
