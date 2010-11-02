Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0KBQVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:21:39 -0400
Received: from claw.goop.org ([74.207.240.146]:49551 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab0KBQVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:21:34 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Stodden <daniel.stodden@citrix.com>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 1/4] xen/blkfront: map REQ_FLUSH into a full barrier
Date: Tue,  2 Nov 2010 12:20:44 -0400
Message-Id: <c64e38ea17a81721da0393584fd807f8434050fa.1288714384.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1288714384.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288714384.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1288714384.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288714384.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Implement a flush as a full barrier, since we have nothing weaker.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Acked-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/xen-blkfront.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 06e2812..3a318d8 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -245,14 +245,11 @@ static int blkif_ioctl(struct block_device *bdev, fmode_t mode,
 }
 
 /*
- * blkif_queue_request
+ * Generate a Xen blkfront IO request from a blk layer request.  Reads
+ * and writes are handled as expected.  Since we lack a loose flush
+ * request, we map flushes into a full ordered barrier.
  *
- * request block io
- *
- * id: for guest use only.
- * operation: BLKIF_OP_{READ,WRITE,PROBE}
- * buffer: buffer to read/write into. this should be a
- *   virtual address in the guest os.
+ * @req: a request struct
  */
 static int blkif_queue_request(struct request *req)
 {
@@ -289,7 +286,7 @@ static int blkif_queue_request(struct request *req)
 
 	ring_req->operation = rq_data_dir(req) ?
 		BLKIF_OP_WRITE : BLKIF_OP_READ;
-	if (req->cmd_flags & REQ_HARDBARRIER)
+	if (req->cmd_flags & REQ_FLUSH)
 		ring_req->operation = BLKIF_OP_WRITE_BARRIER;
 
 	ring_req->nr_segments = blk_rq_map_sg(req->q, req, info->sg);
@@ -1069,14 +1066,8 @@ static void blkfront_connect(struct blkfront_info *info)
 	 */
 	info->feature_flush = 0;
 
-	/*
-	 * The driver doesn't properly handled empty flushes, so
-	 * lets disable barrier support for now.
-	 */
-#if 0
 	if (!err && barrier)
 		info->feature_flush = REQ_FLUSH;
-#endif
 
 	err = xlvbd_alloc_gendisk(sectors, info, binfo, sector_size);
 	if (err) {
-- 
1.7.2.3

