Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab2ARQbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 11:31:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50304 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab2ARQbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 11:31:13 -0500
Message-ID: <4F16F3CA.90904@kernel.dk>
Date: Wed, 18 Jan 2012 17:31:06 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Kernel crash in icq_free_icq_rcu
References: <20120117214834.GD26207@google.com> <20120117220715.GB23527@redhat.com> <CANejiEUfAxR-DFH+eRQUbmc1jKHSkcBP1RxuRQ-9JKLU=1Ds0w@mail.gmail.com> <20120118010323.GA32160@htj.dyndns.org> <CANejiEUopG3MgUsvGMbkdHKrgBT_c+bir1bApt8p86kQn42huQ@mail.gmail.com> <20120118011112.GB32160@htj.dyndns.org> <1326850253.22361.619.camel@sli10-conroe> <1326866602.22361.624.camel@sli10-conroe> <20120118135126.GB30204@redhat.com> <20120118142005.GC30204@redhat.com> <20120118160957.GB30664@google.com> <4F16F245.9000708@kernel.dk>
In-Reply-To: <4F16F245.9000708@kernel.dk>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-18 17:24, Jens Axboe wrote:
> On 2012-01-18 17:09, Tejun Heo wrote:
>> On Wed, Jan 18, 2012 at 09:20:05AM -0500, Vivek Goyal wrote:
>>>> Not allocating icq if request is never going to go to elevator as elevator
>>>> switch was happening makes sense to me.
>>>>
>>>> I tried this patch. It went little further and crashed at a different
>>>> place. I think this seems to be separate merging issue Tejun is trying
>>>> to track down.
>>>
>>> Applied Tejun's debug patch to return early and not call into elevator
>>> for checking whether merge is allowed or not. Things seems to be stable
>>> now for me.
>>
>> Yeah, plug merge is calling into elevator code without any
>> synchronization, so it's bound to be broken.  Given plugging is
>> per-task, I don't think we really need to query elevator about merging
>> bio's.  The request is not on elevator and plugging is part of issuing
>> mechanism, not scheduling, after all.  Jens, what do you think?
> 
> Hmmm. We can bypass asking the elevator, as long as we query the
> restrictions. Does the below, by itself, resolve the crash? If yes, let
> me cook up a patch splitting the elv and blk rq merging logic.

Something like the below, completely untested.

But thinking about this a bit while doing it, why is the IO scheduler
going away while we have plugged requests that are elvpriv?

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

