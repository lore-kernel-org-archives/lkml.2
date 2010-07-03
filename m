Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0GCIsb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 04:48:31 -0400
Received: from sh.osrg.net ([192.16.179.4]:47308 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab0GCIqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 04:46:43 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: axboe@kernel.dk
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 5/9] ps3disk: stop using q->prepare_flush_fn
Date: Sat,  3 Jul 2010 17:45:36 +0900
Message-Id: <1278146740-8731-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 03 Jul 2010 17:46:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

REQ_FLUSH flag enables us to kill ps3disk_prepare_flush().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/block/ps3disk.c |   25 ++++++-------------------
 1 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index 5f208c0..ab528a4 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -196,13 +196,12 @@ static void ps3disk_do_request(struct ps3_storage_device *dev,
 	dev_dbg(&dev->sbd.core, "%s:%u\n", __func__, __LINE__);
 
 	while ((req = blk_fetch_request(q))) {
-		if (req->cmd_type == REQ_TYPE_FS) {
-			if (ps3disk_submit_request_sg(dev, req))
-				break;
-		} else if (req->cmd_type == REQ_TYPE_LINUX_BLOCK &&
-			   req->cmd[0] == REQ_LB_OP_FLUSH) {
+		if (req->cmd_flags & REQ_FLUSH) {
 			if (ps3disk_submit_flush_request(dev, req))
 				break;
+		} else if (req->cmd_type == REQ_TYPE_FS) {
+			if (ps3disk_submit_request_sg(dev, req))
+				break;
 		} else {
 			blk_dump_rq_flags(req, DEVICE_NAME " bad request");
 			__blk_end_request_all(req, -EIO);
@@ -257,8 +256,7 @@ static irqreturn_t ps3disk_interrupt(int irq, void *data)
 		return IRQ_HANDLED;
 	}
 
-	if (req->cmd_type == REQ_TYPE_LINUX_BLOCK &&
-	    req->cmd[0] == REQ_LB_OP_FLUSH) {
+	if (req->cmd_flags & REQ_FLUSH) {
 		read = 0;
 		op = "flush";
 	} else {
@@ -398,16 +396,6 @@ static int ps3disk_identify(struct ps3_storage_device *dev)
 	return 0;
 }
 
-static void ps3disk_prepare_flush(struct request_queue *q, struct request *req)
-{
-	struct ps3_storage_device *dev = q->queuedata;
-
-	dev_dbg(&dev->sbd.core, "%s:%u\n", __func__, __LINE__);
-
-	req->cmd_type = REQ_TYPE_LINUX_BLOCK;
-	req->cmd[0] = REQ_LB_OP_FLUSH;
-}
-
 static unsigned long ps3disk_mask;
 
 static DEFINE_MUTEX(ps3disk_mask_mutex);
@@ -480,8 +468,7 @@ static int __devinit ps3disk_probe(struct ps3_system_bus_device *_dev)
 	blk_queue_dma_alignment(queue, dev->blk_size-1);
 	blk_queue_logical_block_size(queue, dev->blk_size);
 
-	blk_queue_ordered(queue, QUEUE_ORDERED_DRAIN_FLUSH,
-			  ps3disk_prepare_flush);
+	blk_queue_ordered(queue, QUEUE_ORDERED_DRAIN_FLUSH, NULL);
 
 	blk_queue_max_segments(queue, -1);
 	blk_queue_max_segment_size(queue, dev->bounce_size);
-- 
1.6.5

