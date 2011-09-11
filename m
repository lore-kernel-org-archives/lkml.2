Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221Ab1IKOu4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 10:50:56 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44228
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754499Ab1IKOuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 10:50:55 -0400
Date: Sun, 11 Sep 2011 10:50:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] block: export __make_request
Message-ID: <20110911145053.GA28996@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid the hacks need for request based device mappers currently by simply
exporting the symbol instead of trying to get it through the back door.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2011-09-08 12:02:11.575274440 +0200
+++ linux-2.6/block/blk-core.c	2011-09-08 12:03:25.422774199 +0200
@@ -38,8 +38,6 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_r
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
 
-static int __make_request(struct request_queue *q, struct bio *bio);
-
 /*
  * For the allocated request tables
  */
@@ -1213,7 +1211,7 @@ void init_request_from_bio(struct reques
 	blk_rq_bio_prep(req->q, req, bio);
 }
 
-static int __make_request(struct request_queue *q, struct bio *bio)
+int __make_request(struct request_queue *q, struct bio *bio)
 {
 	const bool sync = !!(bio->bi_rw & REQ_SYNC);
 	struct blk_plug *plug;
@@ -1317,6 +1315,7 @@ out_unlock:
 out:
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__make_request);	/* for device mapper only */
 
 /*
  * If bio->bi_dev is a partition, remap the location
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2011-09-08 12:03:31.587273831 +0200
+++ linux-2.6/drivers/md/dm.c	2011-09-08 12:05:02.306774593 +0200
@@ -180,9 +180,6 @@ struct mapped_device {
 	/* forced geometry settings */
 	struct hd_geometry geometry;
 
-	/* For saving the address of __make_request for request based dm */
-	make_request_fn *saved_make_request_fn;
-
 	/* sysfs handle */
 	struct kobject kobj;
 
@@ -1420,13 +1417,6 @@ static int _dm_request(struct request_qu
 	return 0;
 }
 
-static int dm_make_request(struct request_queue *q, struct bio *bio)
-{
-	struct mapped_device *md = q->queuedata;
-
-	return md->saved_make_request_fn(q, bio); /* call __make_request() */
-}
-
 static int dm_request_based(struct mapped_device *md)
 {
 	return blk_queue_stackable(md->queue);
@@ -1437,7 +1427,7 @@ static int dm_request(struct request_que
 	struct mapped_device *md = q->queuedata;
 
 	if (dm_request_based(md))
-		return dm_make_request(q, bio);
+		return __make_request(q, bio);
 
 	return _dm_request(q, bio);
 }
@@ -2172,7 +2162,6 @@ static int dm_init_request_based_queue(s
 		return 0;
 
 	md->queue = q;
-	md->saved_make_request_fn = md->queue->make_request_fn;
 	dm_init_md_queue(md);
 	blk_queue_softirq_done(md->queue, dm_softirq_done);
 	blk_queue_prep_rq(md->queue, dm_prep_fn);
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2011-09-08 12:02:11.595273510 +0200
+++ linux-2.6/include/linux/blkdev.h	2011-09-08 12:02:33.038774679 +0200
@@ -680,6 +680,8 @@ extern int scsi_cmd_ioctl(struct request
 extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 			 struct scsi_ioctl_command __user *);
 
+extern int __make_request(struct request_queue *q, struct bio *bio);
+
 /*
  * A queue has just exitted congestion.  Note this in the global counter of
  * congested queues, and wake up anyone who was waiting for requests to be
