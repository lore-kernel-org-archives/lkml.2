Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab2AVKbK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 05:31:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40450 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2AVKbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 05:31:08 -0500
Message-ID: <4F1BE548.3000800@kernel.dk>
Date: Sun, 22 Jan 2012 11:30:32 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: LKML <linux-kernel@vger.kernel.org>, peterz@infradead.org,
        dm-devel@redhat.com
Subject: Re: BUG: spinlock trylock failure on UP on CPU#0, vgchange/936
References: <alpine.DEB.2.01.1201180009520.2895@trent.utfs.org> <alpine.DEB.2.01.1201210341430.2895@trent.utfs.org> <4F1AB392.20604@kernel.dk> <alpine.DEB.2.01.1201211430340.2895@trent.utfs.org>
In-Reply-To: <alpine.DEB.2.01.1201211430340.2895@trent.utfs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2012 11:35 PM, Christian Kujau wrote:
> On Sat, 21 Jan 2012 at 13:46, Jens Axboe wrote:
>> Can you try and pull:
>>
>> git://git.kernel.dk/linux-block.git for-linus
>>
>> and see if it helps?
> 
> Pulled, compiled, bootet - but the BUG: stays. Please see .config and full 
> dmesg: http://nerdbynature.de/bits/3.2.0/   (the 3.3.0-rc1 files)
> 
> Note that I don't have an actual problem here: the machine (PowerBook G4) 
> is booting & running fine, I'm currently not using any LVM devices, so 
> it's merely the BUG: being printed during bootup I'm whining about.

What about with this on top?


diff --git a/block/blk-core.c b/block/blk-core.c
index e6c05a9..75eba5c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1283,7 +1283,7 @@ static bool attempt_plug_merge(struct request_queue *q, struct bio *bio,
 		if (rq->q != q)
 			continue;
 
-		el_ret = elv_try_merge(rq, bio);
+		el_ret = blk_try_merge(rq, bio);
 		if (el_ret == ELEVATOR_BACK_MERGE) {
 			ret = bio_attempt_back_merge(q, rq, bio);
 			if (ret)
diff --git a/block/blk-merge.c b/block/blk-merge.c
index cfcc37c..ee9ec90 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -471,3 +471,59 @@ int blk_attempt_req_merge(struct request_queue *q, struct request *rq,
 {
 	return attempt_merge(q, rq, next);
 }
+
+int blk_rq_merge_ok(struct request *rq, struct bio *bio)
+{
+	if (!rq_mergeable(rq))
+		return 0;
+
+	/*
+	 * Don't merge file system requests and discard requests
+	 */
+	if ((bio->bi_rw & REQ_DISCARD) != (rq->bio->bi_rw & REQ_DISCARD))
+		return 0;
+
+	/*
+	 * Don't merge discard requests and secure discard requests
+	 */
+	if ((bio->bi_rw & REQ_SECURE) != (rq->bio->bi_rw & REQ_SECURE))
+		return 0;
+
+	/*
+	 * different data direction or already started, don't merge
+	 */
+	if (bio_data_dir(bio) != rq_data_dir(rq))
+		return 0;
+
+	/*
+	 * must be same device and not a special request
+	 */
+	if (rq->rq_disk != bio->bi_bdev->bd_disk || rq->special)
+		return 0;
+
+	/*
+	 * only merge integrity protected bio into ditto rq
+	 */
+	if (bio_integrity(bio) != blk_integrity_rq(rq))
+		return 0;
+
+	return 1;
+}
+EXPORT_SYMBOL(blk_rq_merge_ok);
+
+int blk_try_merge(struct request *__rq, struct bio *bio)
+{
+	int ret = ELEVATOR_NO_MERGE;
+
+	/*
+	 * we can merge and sequence is ok, check if it's possible
+	 */
+	if (blk_rq_merge_ok(__rq, bio)) {
+		if (blk_rq_pos(__rq) + blk_rq_sectors(__rq) == bio->bi_sector)
+			ret = ELEVATOR_BACK_MERGE;
+		else if (blk_rq_pos(__rq) - bio_sectors(bio) == bio->bi_sector)
+			ret = ELEVATOR_FRONT_MERGE;
+	}
+
+	return ret;
+}
diff --git a/block/blk.h b/block/blk.h
index 7efd772..a117fa9 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -137,6 +137,8 @@ int blk_attempt_req_merge(struct request_queue *q, struct request *rq,
 				struct request *next);
 void blk_recalc_rq_segments(struct request *rq);
 void blk_rq_set_mixed_merge(struct request *rq);
+int blk_rq_merge_ok(struct request *rq, struct bio *bio);
+int blk_try_merge(struct request *rq, struct bio *bio);
 
 void blk_queue_congestion_threshold(struct request_queue *q);
 
diff --git a/block/elevator.c b/block/elevator.c
index 91e18f8..a1a75f7 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -72,39 +72,8 @@ static int elv_iosched_allow_merge(struct request *rq, struct bio *bio)
  */
 int elv_rq_merge_ok(struct request *rq, struct bio *bio)
 {
-	if (!rq_mergeable(rq))
+	if (!blk_rq_merge_ok(rq, bio))
 		return 0;
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
-		return 0;
-
 	if (!elv_iosched_allow_merge(rq, bio))
 		return 0;
 
@@ -114,19 +83,13 @@ EXPORT_SYMBOL(elv_rq_merge_ok);
 
 int elv_try_merge(struct request *__rq, struct bio *bio)
 {
-	int ret = ELEVATOR_NO_MERGE;
-
 	/*
 	 * we can merge and sequence is ok, check if it's possible
 	 */
-	if (elv_rq_merge_ok(__rq, bio)) {
-		if (blk_rq_pos(__rq) + blk_rq_sectors(__rq) == bio->bi_sector)
-			ret = ELEVATOR_BACK_MERGE;
-		else if (blk_rq_pos(__rq) - bio_sectors(bio) == bio->bi_sector)
-			ret = ELEVATOR_FRONT_MERGE;
-	}
+	if (elv_rq_merge_ok(__rq, bio))
+		return blk_try_merge(__rq, bio);
 
-	return ret;
+	return ELEVATOR_NO_MERGE;
 }
 
 static struct elevator_type *elevator_find(const char *name)


-- 
Jens Axboe

