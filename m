Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab2FMHk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:40:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab2FMHk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:40:56 -0400
From: Asias He <asias@redhat.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Asias He <asias@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Shaohua Li <shli@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH RFC 1/2] block: Add blk_bio_map_sg() helper
Date: Wed, 13 Jun 2012 15:41:46 +0800
Message-Id: <1339573307-11537-2-git-send-email-asias@redhat.com>
In-Reply-To: <1339573307-11537-1-git-send-email-asias@redhat.com>
References: <1339573307-11537-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a helper to map a bio to a scatterlist, modelled after
blk_rq_map_sg.

This helper is useful for any driver that wants to create
a scatterlist from its ->make_request_fn method.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Asias He <asias@redhat.com>
---
 block/blk-merge.c      |   63 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    2 ++
 2 files changed, 65 insertions(+)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 160035f..27ba264 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -199,6 +199,69 @@ new_segment:
 }
 EXPORT_SYMBOL(blk_rq_map_sg);
 
+/*
+ * map a bio to a scatterlist, return number of sg entries setup. Caller
+ * must make sure sg can hold bio->bi_phys_segments entries
+ */
+int blk_bio_map_sg(struct request_queue *q, struct bio *bio,
+		   struct scatterlist *sglist)
+{
+	struct bio_vec *bvec, *bvprv;
+	struct scatterlist *sg;
+	int nsegs, cluster;
+	unsigned long i;
+
+	nsegs = 0;
+	cluster = blk_queue_cluster(q);
+
+	bvprv = NULL;
+	sg = NULL;
+	bio_for_each_segment(bvec, bio, i) {
+		int nbytes = bvec->bv_len;
+
+		if (bvprv && cluster) {
+			if (sg->length + nbytes > queue_max_segment_size(q))
+				goto new_segment;
+
+			if (!BIOVEC_PHYS_MERGEABLE(bvprv, bvec))
+				goto new_segment;
+			if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bvec))
+				goto new_segment;
+
+			sg->length += nbytes;
+		} else {
+new_segment:
+			if (!sg)
+				sg = sglist;
+			else {
+				/*
+				 * If the driver previously mapped a shorter
+				 * list, we could see a termination bit
+				 * prematurely unless it fully inits the sg
+				 * table on each mapping. We KNOW that there
+				 * must be more entries here or the driver
+				 * would be buggy, so force clear the
+				 * termination bit to avoid doing a full
+				 * sg_init_table() in drivers for each command.
+				 */
+				sg->page_link &= ~0x02;
+				sg = sg_next(sg);
+			}
+
+			sg_set_page(sg, bvec->bv_page, nbytes, bvec->bv_offset);
+			nsegs++;
+		}
+		bvprv = bvec;
+	} /* segments in bio */
+
+	if (sg)
+		sg_mark_end(sg);
+
+	BUG_ON(bio->bi_phys_segments && nsegs > bio->bi_phys_segments);
+	return nsegs;
+}
+EXPORT_SYMBOL(blk_bio_map_sg);
+
 static inline int ll_new_hw_segment(struct request_queue *q,
 				    struct request *req,
 				    struct bio *bio)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ba43f40..46916af 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -884,6 +884,8 @@ extern void blk_queue_flush_queueable(struct request_queue *q, bool queueable);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 
 extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
+extern int blk_bio_map_sg(struct request_queue *q, struct bio *bio,
+			  struct scatterlist *sglist);
 extern void blk_dump_rq_flags(struct request *, char *);
 extern long nr_blockdev_pages(void);
 
-- 
1.7.10.2

