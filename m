Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0KBQV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:21:58 -0400
Received: from claw.goop.org ([74.207.240.146]:49562 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab0KBQVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:21:36 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Stodden <daniel.stodden@citrix.com>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 3/4] xen/blkfront: Implement FUA with BLKIF_OP_WRITE_BARRIER
Date: Tue,  2 Nov 2010 12:20:46 -0400
Message-Id: <be2f8373c188ed1f5d36003c9928e4d695213080.1288714384.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1288714384.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288714384.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1288714384.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288714384.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

The BLKIF_OP_WRITE_BARRIER is a full ordered barrier, so we can use it
to implement FUA as well as a plain FLUSH.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Acked-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/xen-blkfront.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 31c8a64..76b874a 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -286,8 +286,18 @@ static int blkif_queue_request(struct request *req)
 
 	ring_req->operation = rq_data_dir(req) ?
 		BLKIF_OP_WRITE : BLKIF_OP_READ;
-	if (req->cmd_flags & REQ_FLUSH)
+
+	if (req->cmd_flags & (REQ_FLUSH | REQ_FUA)) {
+		/*
+		 * Ideally we could just do an unordered
+		 * flush-to-disk, but all we have is a full write
+		 * barrier at the moment.  However, a barrier write is
+		 * a superset of FUA, so we can implement it the same
+		 * way.  (It's also a FLUSH+FUA, since it is
+		 * guaranteed ordered WRT previous writes.)
+		 */
 		ring_req->operation = BLKIF_OP_WRITE_BARRIER;
+	}
 
 	ring_req->nr_segments = blk_rq_map_sg(req->q, req, info->sg);
 	BUG_ON(ring_req->nr_segments > BLKIF_MAX_SEGMENTS_PER_REQUEST);
@@ -1065,7 +1075,7 @@ static void blkfront_connect(struct blkfront_info *info)
 	info->feature_flush = 0;
 
 	if (!err && barrier)
-		info->feature_flush = REQ_FLUSH;
+		info->feature_flush = REQ_FLUSH | REQ_FUA;
 
 	err = xlvbd_alloc_gendisk(sectors, info, binfo, sector_size);
 	if (err) {
-- 
1.7.2.3

