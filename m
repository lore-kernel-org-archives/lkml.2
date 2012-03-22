Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030608Ab2CVCTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:19:12 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34144 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397Ab2CVCTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:19:09 -0400
To: Shaohua Li <shli@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk,
        martin.petersen@oracle.com
Subject: Re: [patch v2 2/6] blk: dont allow discard request merge temporarily
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20120316073213.656519005@fusionio.com>
	<20120316073512.485027511@fusionio.com>
	<20120320162157.GE17071@redhat.com>
	<CANejiEWecb58G--=mwez+A4Ra6nJ0qOHGMcJA-nOGH=jmGA3qQ@mail.gmail.com>
Date: Wed, 21 Mar 2012 22:18:54 -0400
In-Reply-To: <CANejiEWecb58G--=mwez+A4Ra6nJ0qOHGMcJA-nOGH=jmGA3qQ@mail.gmail.com>
	(Shaohua Li's message of "Wed, 21 Mar 2012 09:22:46 +0800")
Message-ID: <yq1d385wf75.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F6A8C14.0008,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Shaohua" == Shaohua Li <shli@kernel.org> writes:

Shaohua> Enabling discard merge is required for device with slow discard
Shaohua> (and very helpful for raid),

Before RAID support there really wasn't much point. That's one of the
reasons the current discard merge code has survived despite being
completely broken.

As for how I'd like to handle contiguous discard merges going forward
here's a proof of concept. It's on top of my write same tree so you may
have to noodle a bit.

It is crucially important that we never merge a command that can't be
processed by the device. So I'd like to do something like this:


block: Consolidate command flag and queue limit checks for merges

 - blk_check_merge_flags() verifies that cmd_flags / bi_rw are
   compatible. This function is called for both req-req and req-bio
   merging.

 - blk_rq_get_max_sectors() and blk_queue_get_max_sectors() can be used
   to query the maximum sector count for a given request or queue. The
   calls will return the right value from the queue limits given the
   type of command (RW, discard, write same, etc.)

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/block/blk-core.c b/block/blk-core.c
index 1cd55be..6619a6d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1757,8 +1757,7 @@ int blk_rq_check_limits(struct request_queue *q, struct request *rq)
 	if (!rq_mergeable(rq))
 		return 0;
 
-	if (blk_rq_sectors(rq) > queue_max_sectors(q) ||
-	    blk_rq_bytes(rq) > queue_max_hw_sectors(q) << 9) {
+	if (blk_rq_sectors(rq) > blk_queue_get_max_sectors(q, rq->cmd_flags)) {
 		printk(KERN_ERR "%s: over max size limit.\n", __func__);
 		return -EIO;
 	}
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 9172606..8bd91d2 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -228,14 +228,8 @@ no_merge:
 int ll_back_merge_fn(struct request_queue *q, struct request *req,
 		     struct bio *bio)
 {
-	unsigned short max_sectors;
-
-	if (unlikely(req->cmd_type == REQ_TYPE_BLOCK_PC))
-		max_sectors = queue_max_hw_sectors(q);
-	else
-		max_sectors = queue_max_sectors(q);
-
-	if (blk_rq_sectors(req) + bio_sectors(bio) > max_sectors) {
+	if (blk_rq_sectors(req) + bio_sectors(bio) >
+	    blk_rq_get_max_sectors(req)) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
@@ -252,15 +246,8 @@ int ll_back_merge_fn(struct request_queue *q, struct request *req,
 int ll_front_merge_fn(struct request_queue *q, struct request *req,
 		      struct bio *bio)
 {
-	unsigned short max_sectors;
-
-	if (unlikely(req->cmd_type == REQ_TYPE_BLOCK_PC))
-		max_sectors = queue_max_hw_sectors(q);
-	else
-		max_sectors = queue_max_sectors(q);
-
-
-	if (blk_rq_sectors(req) + bio_sectors(bio) > max_sectors) {
+	if (blk_rq_sectors(req) + bio_sectors(bio) >
+	    blk_rq_get_max_sectors(req)) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
@@ -291,7 +278,8 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 	/*
 	 * Will it become too large?
 	 */
-	if ((blk_rq_sectors(req) + blk_rq_sectors(next)) > queue_max_sectors(q))
+	if ((blk_rq_sectors(req) + blk_rq_sectors(next)) >
+	    blk_rq_get_max_sectors(req))
 		return 0;
 
 	total_phys_segments = req->nr_phys_segments + next->nr_phys_segments;
@@ -370,6 +358,9 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	if (!rq_mergeable(req) || !rq_mergeable(next))
 		return 0;
 
+	if (!blk_check_merge_flags(req->cmd_flags, next->cmd_flags))
+		return 0;
+
 	/*
 	 * not contiguous
 	 */
@@ -465,6 +456,9 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (!rq_mergeable(rq) || !bio_mergeable(bio))
 		return false;
 
+	if (!blk_check_merge_flags(rq->cmd_flags, bio->bi_rw))
+		return false;
+
 	/* different data direction or already started, don't merge */
 	if (bio_data_dir(bio) != rq_data_dir(rq))
 		return false;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 7718e69..b7994eb 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -175,8 +175,7 @@ enum rq_flag_bits {
 
 /* This mask is used for both bio and request merge checking */
 #define REQ_NOMERGE_FLAGS \
-	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA | \
-	 REQ_DISCARD | REQ_WRITE_SAME)
+	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
 
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
 #define REQ_THROTTLED		(1 << __REQ_THROTTLED)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 92956b7..cf11980 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -580,6 +580,20 @@ static inline bool rq_mergeable(struct request *rq)
 	return true;
 }
 
+static inline bool blk_check_merge_flags(unsigned int flags1,
+					 unsigned int flags2)
+{
+	if ((flags1 & REQ_DISCARD) != (flags2 & REQ_DISCARD))
+		return false;
+
+	if ((flags1 & REQ_SECURE) != (flags2 & REQ_SECURE))
+		return false;
+
+	if ((flags1 & REQ_WRITE_SAME) != (flags2 & REQ_WRITE_SAME))
+		return false;
+
+	return true;
+}
 
 /*
  * q->prep_rq_fn return values
@@ -776,6 +790,28 @@ static inline unsigned int blk_rq_cur_sectors(const struct request *rq)
 	return blk_rq_cur_bytes(rq) >> 9;
 }
 
+static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
+						     unsigned int cmd_flags)
+{
+	if (unlikely(cmd_flags & REQ_DISCARD))
+		return q->limits.max_discard_sectors;
+
+	if (unlikely(cmd_flags & REQ_WRITE_SAME))
+		return q->limits.max_write_same_sectors;
+
+	return q->limits.max_sectors;
+}
+
+static inline unsigned int blk_rq_get_max_sectors(struct request *rq)
+{
+	struct request_queue *q = rq->q;
+
+	if (unlikely(rq->cmd_type == REQ_TYPE_BLOCK_PC))
+		return q->limits.max_hw_sectors;
+
+	return blk_queue_get_max_sectors(q, rq->cmd_flags);
+}
+
 /*
  * Request issue related functions.
  */
