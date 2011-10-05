Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935340Ab1JET4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:56:54 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55662
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935244Ab1JETzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:55:41 -0400
Message-Id: <20111005195529.760114992@bombadil.infradead.org>
User-Agent: quilt/0.48-1
Date: Wed, 05 Oct 2011 15:54:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] block: add bio_map_sg
References: <20111005195403.407628164@bombadil.infradead.org>
Content-Disposition: inline; filename=block-add-bio_map_sg
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a helper to map a bio to a scatterlist, modelled after blk_rq_map_sg.
This helper is useful for any driver that wants to create a scatterlist
from its ->make_request method.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/block/blk-merge.c
===================================================================
--- linux-2.6.orig/block/blk-merge.c	2011-10-04 11:49:32.857014742 -0400
+++ linux-2.6/block/blk-merge.c	2011-10-04 13:37:51.305630951 -0400
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
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2011-10-04 13:37:13.216148915 -0400
+++ linux-2.6/include/linux/blkdev.h	2011-10-04 13:37:51.317613617 -0400
@@ -854,6 +854,8 @@ extern void blk_queue_flush_queueable(st
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 
 extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
+extern int bio_map_sg(struct request_queue *q, struct bio *bio,
+		struct scatterlist *sglist);
 extern void blk_dump_rq_flags(struct request *, char *);
 extern long nr_blockdev_pages(void);
 

