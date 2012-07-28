Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab2G1CUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 22:20:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab2G1CTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 22:19:32 -0400
From: Asias He <asias@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Shaohua Li <shli@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH V4 1/3] block: Introduce __blk_segment_map_sg() helper
Date: Sat, 28 Jul 2012 10:21:03 +0800
Message-Id: <1343442065-15646-2-git-send-email-asias@redhat.com>
In-Reply-To: <1343442065-15646-1-git-send-email-asias@redhat.com>
References: <1343442065-15646-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the mapping code in blk_rq_map_sg() to a helper
__blk_segment_map_sg(), so that other mapping function, e.g.
blk_bio_map_sg(), can share the code.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Shaohua Li <shli@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Suggested-by: Tejun Heo <tj@kernel.org>
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Asias He <asias@redhat.com>
---
 block/blk-merge.c |   80 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 35 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 160035f..576b68e 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -110,6 +110,49 @@ static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
 	return 0;
 }
 
+static void
+__blk_segment_map_sg(struct request_queue *q, struct bio_vec *bvec,
+		     struct scatterlist *sglist, struct bio_vec **bvprv,
+		     struct scatterlist **sg, int *nsegs, int *cluster)
+{
+
+	int nbytes = bvec->bv_len;
+
+	if (*bvprv && *cluster) {
+		if ((*sg)->length + nbytes > queue_max_segment_size(q))
+			goto new_segment;
+
+		if (!BIOVEC_PHYS_MERGEABLE(*bvprv, bvec))
+			goto new_segment;
+		if (!BIOVEC_SEG_BOUNDARY(q, *bvprv, bvec))
+			goto new_segment;
+
+		(*sg)->length += nbytes;
+	} else {
+new_segment:
+		if (!*sg)
+			*sg = sglist;
+		else {
+			/*
+			 * If the driver previously mapped a shorter
+			 * list, we could see a termination bit
+			 * prematurely unless it fully inits the sg
+			 * table on each mapping. We KNOW that there
+			 * must be more entries here or the driver
+			 * would be buggy, so force clear the
+			 * termination bit to avoid doing a full
+			 * sg_init_table() in drivers for each command.
+			 */
+			(*sg)->page_link &= ~0x02;
+			*sg = sg_next(*sg);
+		}
+
+		sg_set_page(*sg, bvec->bv_page, nbytes, bvec->bv_offset);
+		(*nsegs)++;
+	}
+	*bvprv = bvec;
+}
+
 /*
  * map a request to scatterlist, return number of sg entries setup. Caller
  * must make sure sg can hold rq->nr_phys_segments entries
@@ -131,41 +174,8 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 	bvprv = NULL;
 	sg = NULL;
 	rq_for_each_segment(bvec, rq, iter) {
-		int nbytes = bvec->bv_len;
-
-		if (bvprv && cluster) {
-			if (sg->length + nbytes > queue_max_segment_size(q))
-				goto new_segment;
-
-			if (!BIOVEC_PHYS_MERGEABLE(bvprv, bvec))
-				goto new_segment;
-			if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bvec))
-				goto new_segment;
-
-			sg->length += nbytes;
-		} else {
-new_segment:
-			if (!sg)
-				sg = sglist;
-			else {
-				/*
-				 * If the driver previously mapped a shorter
-				 * list, we could see a termination bit
-				 * prematurely unless it fully inits the sg
-				 * table on each mapping. We KNOW that there
-				 * must be more entries here or the driver
-				 * would be buggy, so force clear the
-				 * termination bit to avoid doing a full
-				 * sg_init_table() in drivers for each command.
-				 */
-				sg->page_link &= ~0x02;
-				sg = sg_next(sg);
-			}
-
-			sg_set_page(sg, bvec->bv_page, nbytes, bvec->bv_offset);
-			nsegs++;
-		}
-		bvprv = bvec;
+		__blk_segment_map_sg(q, bvec, sglist, &bvprv, &sg,
+				     &nsegs, &cluster);
 	} /* segments in rq */
 
 
-- 
1.7.10.4

