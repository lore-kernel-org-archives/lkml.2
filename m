Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab1LUBBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:01:45 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:51566 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab1LUBBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:01:15 -0500
From: Minchan Kim <minchan@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan@redhat.com>
Subject: [PATCH 1/6] block: add bio_map_sg
Date: Wed, 21 Dec 2011 10:00:49 +0900
Message-Id: <1324429254-28383-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1324429254-28383-1-git-send-email-minchan@kernel.org>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Add a helper to map a bio to a scatterlist, modelled after blk_rq_map_sg.
This helper is useful for any driver that wants to create a scatterlist
from its ->make_request method.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Minchan Kim <minchan@redhat.com>
---
 block/blk-merge.c      |   63 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    2 +
 2 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index cfcc37c..a8ac944 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -199,6 +199,69 @@ new_segment:
 }
 EXPORT_SYMBOL(blk_rq_map_sg);
 
+/*
+ * map a bio to a scatterlist, return number of sg entries setup. Caller
+ * must make sure sg can hold bio->bi_phys_segments entries
+ */
+int bio_map_sg(struct request_queue *q, struct bio *bio,
+		  struct scatterlist *sglist)
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
+EXPORT_SYMBOL(bio_map_sg);
+
 static inline int ll_new_hw_segment(struct request_queue *q,
 				    struct request *req,
 				    struct bio *bio)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 94acd81..7ad8e89 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -853,6 +853,8 @@ extern void blk_queue_flush_queueable(struct request_queue *q, bool queueable);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 
 extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
+extern int bio_map_sg(struct request_queue *q, struct bio *bio,
+		struct scatterlist *sglist);
 extern void blk_dump_rq_flags(struct request *, char *);
 extern long nr_blockdev_pages(void);
 
-- 
1.7.6.4

