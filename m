Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab2HBGYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:24:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab2HBGYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:24:34 -0400
From: Asias He <asias@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>,
        Shaohua Li <shli@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH V5 2/4] block: Add blk_bio_map_sg() helper
Date: Thu,  2 Aug 2012 14:25:54 +0800
Message-Id: <1343888757-25723-3-git-send-email-asias@redhat.com>
In-Reply-To: <1343888757-25723-1-git-send-email-asias@redhat.com>
References: <1343888757-25723-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a helper to map a bio to a scatterlist, modelled after
blk_rq_map_sg.

This helper is useful for any driver that wants to create
a scatterlist from its ->make_request_fn method.

Changes in v2:
 - Use __blk_segment_map_sg to avoid duplicated code
 - Add cocbook style function comment

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Shaohua Li <shli@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Asias He <asias@redhat.com>
---
 block/blk-merge.c      | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |  2 ++
 2 files changed, 39 insertions(+)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 576b68e..e76279e 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -209,6 +209,43 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 }
 EXPORT_SYMBOL(blk_rq_map_sg);
 
+/**
+ * blk_bio_map_sg - map a bio to a scatterlist
+ * @q: request_queue in question
+ * @bio: bio being mapped
+ * @sglist: scatterlist being mapped
+ *
+ * Note:
+ *    Caller must make sure sg can hold bio->bi_phys_segments entries
+ *
+ * Will return the number of sg entries setup
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
+		__blk_segment_map_sg(q, bvec, sglist, &bvprv, &sg,
+				     &nsegs, &cluster);
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
index 4e72a9d..d261cbb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -894,6 +894,8 @@ extern void blk_queue_flush_queueable(struct request_queue *q, bool queueable);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 
 extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
+extern int blk_bio_map_sg(struct request_queue *q, struct bio *bio,
+			  struct scatterlist *sglist);
 extern void blk_dump_rq_flags(struct request *, char *);
 extern long nr_blockdev_pages(void);
 
-- 
1.7.11.2

