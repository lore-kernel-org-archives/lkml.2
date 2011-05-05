Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab1EETMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 15:12:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62704 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1EETMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 15:12:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        xen-devel@lists.xensource.com
Cc: daniel.stodden@citrix.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@citrix.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/3] xen-blkfront: Introduce BLKIF_OP_FLUSH_DISKCACHE support.
Date: Thu,  5 May 2011 14:55:21 -0400
Message-Id: <1304621721-22608-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304621721-22608-1-git-send-email-konrad.wilk@oracle.com>
References: <1304621721-22608-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090207.4DC2F616.0068:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the backend supports the 'feature-flush-cache' mode, use that
instead of the 'feature-barrier' support.

Currently there are three backends that support the 'feature-flush-cache'
mode: NetBSD, Solaris and Linux kernel. The 'flush' option is much
light-weight version than the 'barrier' support so lets try to use as
there are no filesystems in the kernel that use full barriers anymore.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkfront.c |   49 ++++++++++++++++++++++++++++++-----------
 1 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 2075981..b536a9c 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -97,6 +97,7 @@ struct blkfront_info
 	struct blk_shadow shadow[BLK_RING_SIZE];
 	unsigned long shadow_free;
 	unsigned int feature_flush;
+	unsigned int flush_op;
 	int is_ready;
 };
 
@@ -250,8 +251,7 @@ static int blkif_ioctl(struct block_device *bdev, fmode_t mode,
 
 /*
  * Generate a Xen blkfront IO request from a blk layer request.  Reads
- * and writes are handled as expected.  Since we lack a loose flush
- * request, we map flushes into a full ordered barrier.
+ * and writes are handled as expected.
  *
  * @req: a request struct
  */
@@ -293,14 +293,13 @@ static int blkif_queue_request(struct request *req)
 
 	if (req->cmd_flags & (REQ_FLUSH | REQ_FUA)) {
 		/*
-		 * Ideally we could just do an unordered
-		 * flush-to-disk, but all we have is a full write
-		 * barrier at the moment.  However, a barrier write is
+		 * Ideally we can do an unordered flush-to-disk. In case the
+		 * backend onlysupports barriers, use that. A barrier request
 		 * a superset of FUA, so we can implement it the same
 		 * way.  (It's also a FLUSH+FUA, since it is
 		 * guaranteed ordered WRT previous writes.)
 		 */
-		ring_req->operation = BLKIF_OP_WRITE_BARRIER;
+		ring_req->operation = info->flush_op;
 	}
 
 	ring_req->nr_segments = blk_rq_map_sg(req->q, req, info->sg);
@@ -433,8 +432,11 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size)
 static void xlvbd_flush(struct blkfront_info *info)
 {
 	blk_queue_flush(info->rq, info->feature_flush);
-	printk(KERN_INFO "blkfront: %s: barriers %s\n",
+	printk(KERN_INFO "blkfront: %s: %s: %s\n",
 	       info->gd->disk_name,
+	       info->flush_op == BLKIF_OP_WRITE_BARRIER ?
+		"barrier" : (info->flush_op == BLKIF_OP_FLUSH_DISKCACHE ?
+		"flush diskcache" : "barrier or flush"),
 	       info->feature_flush ? "enabled" : "disabled");
 }
 
@@ -720,15 +722,20 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 
 		error = (bret->status == BLKIF_RSP_OKAY) ? 0 : -EIO;
 		switch (bret->operation) {
+		case BLKIF_OP_FLUSH_DISKCACHE:
 		case BLKIF_OP_WRITE_BARRIER:
 			if (unlikely(bret->status == BLKIF_RSP_EOPNOTSUPP)) {
-				printk(KERN_WARNING "blkfront: %s: write barrier op failed\n",
+				printk(KERN_WARNING "blkfront: %s: write %s op failed\n",
+				       info->flush_op == BLKIF_OP_WRITE_BARRIER ?
+				       "barrier" :  "flush disk cache",
 				       info->gd->disk_name);
 				error = -EOPNOTSUPP;
 			}
 			if (unlikely(bret->status == BLKIF_RSP_ERROR &&
 				     info->shadow[id].req.nr_segments == 0)) {
-				printk(KERN_WARNING "blkfront: %s: empty write barrier op failed\n",
+				printk(KERN_WARNING "blkfront: %s: empty write %s op failed\n",
+				       info->flush_op == BLKIF_OP_WRITE_BARRIER ?
+				       "barrier" :  "flush disk cache",
 				       info->gd->disk_name);
 				error = -EOPNOTSUPP;
 			}
@@ -736,6 +743,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 				if (error == -EOPNOTSUPP)
 					error = 0;
 				info->feature_flush = 0;
+				info->flush_op = 0;
 				xlvbd_flush(info);
 			}
 			/* fall through */
@@ -1100,7 +1108,7 @@ static void blkfront_connect(struct blkfront_info *info)
 	unsigned long sector_size;
 	unsigned int binfo;
 	int err;
-	int barrier;
+	int barrier, flush;
 
 	switch (info->connected) {
 	case BLKIF_STATE_CONNECTED:
@@ -1140,6 +1148,9 @@ static void blkfront_connect(struct blkfront_info *info)
 		return;
 	}
 
+	info->feature_flush = 0;
+	info->flush_op = 0;
+
 	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
 			    "feature-barrier", "%d", &barrier,
 			    NULL);
@@ -1151,11 +1162,23 @@ static void blkfront_connect(struct blkfront_info *info)
 	 *
 	 * If there are barriers, then we use flush.
 	 */
-	info->feature_flush = 0;
-
-	if (!err && barrier)
+	if (!err && barrier) {
 		info->feature_flush = REQ_FLUSH | REQ_FUA;
+		info->flush_op = BLKIF_OP_WRITE_BARRIER;
+	}
+	/*
+	 * And if there is "feature-flush-cache" use that above
+	 * barriers.
+	 */
+	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
+			    "feature-flush-cache", "%d", &flush,
+			    NULL);
 
+	if (!err && flush) {
+		info->feature_flush = REQ_FLUSH;
+		info->flush_op = BLKIF_OP_FLUSH_DISKCACHE;
+	}
+		
 	err = xlvbd_alloc_gendisk(sectors, info, binfo, sector_size);
 	if (err) {
 		xenbus_dev_fatal(info->xbdev, err, "xlvbd_add at %s",
-- 
1.7.4.1

