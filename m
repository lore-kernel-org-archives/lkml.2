Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0GCIqw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 04:46:52 -0400
Received: from sh.osrg.net ([192.16.179.4]:47317 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756Ab0GCIqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 04:46:48 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: axboe@kernel.dk
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 7/9] virtio_blk: stop using q->prepare_flush_fn
Date: Sat,  3 Jul 2010 17:45:38 +0900
Message-Id: <1278146740-8731-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 03 Jul 2010 17:46:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use REQ_FLUSH flag instead.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/block/virtio_blk.c |   50 ++++++++++++++++++-------------------------
 1 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index b5ebcd3..b277f9e 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -99,33 +99,32 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 		return false;
 
 	vbr->req = req;
-	switch (req->cmd_type) {
-	case REQ_TYPE_FS:
-		vbr->out_hdr.type = 0;
-		vbr->out_hdr.sector = blk_rq_pos(vbr->req);
-		vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
-		break;
-	case REQ_TYPE_BLOCK_PC:
-		vbr->out_hdr.type = VIRTIO_BLK_T_SCSI_CMD;
-		vbr->out_hdr.sector = 0;
-		vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
-		break;
-	case REQ_TYPE_SPECIAL:
-		vbr->out_hdr.type = VIRTIO_BLK_T_GET_ID;
+
+	if (req->cmd_flags & REQ_FLUSH) {
+		vbr->out_hdr.type = VIRTIO_BLK_T_FLUSH;
 		vbr->out_hdr.sector = 0;
 		vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
-		break;
-	case REQ_TYPE_LINUX_BLOCK:
-		if (req->cmd[0] == REQ_LB_OP_FLUSH) {
-			vbr->out_hdr.type = VIRTIO_BLK_T_FLUSH;
+	} else {
+		switch (req->cmd_type) {
+		case REQ_TYPE_FS:
+			vbr->out_hdr.type = 0;
+			vbr->out_hdr.sector = blk_rq_pos(vbr->req);
+			vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
+			break;
+		case REQ_TYPE_BLOCK_PC:
+			vbr->out_hdr.type = VIRTIO_BLK_T_SCSI_CMD;
 			vbr->out_hdr.sector = 0;
 			vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
 			break;
+		case REQ_TYPE_SPECIAL:
+			vbr->out_hdr.type = VIRTIO_BLK_T_GET_ID;
+			vbr->out_hdr.sector = 0;
+			vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
+			break;
+		default:
+			/* We don't put anything else in the queue. */
+			BUG();
 		}
-		/*FALLTHRU*/
-	default:
-		/* We don't put anything else in the queue. */
-		BUG();
 	}
 
 	if (vbr->req->cmd_flags & REQ_HARDBARRIER)
@@ -195,12 +194,6 @@ static void do_virtblk_request(struct request_queue *q)
 		virtqueue_kick(vblk->vq);
 }
 
-static void virtblk_prepare_flush(struct request_queue *q, struct request *req)
-{
-	req->cmd_type = REQ_TYPE_LINUX_BLOCK;
-	req->cmd[0] = REQ_LB_OP_FLUSH;
-}
-
 /* return id (s/n) string for *disk to *id_str
  */
 static int virtblk_get_id(struct gendisk *disk, char *id_str)
@@ -373,8 +366,7 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 
 	/* If barriers are supported, tell block layer that queue is ordered */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
-		blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH,
-				  virtblk_prepare_flush);
+		blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH, NULL);
 	else if (virtio_has_feature(vdev, VIRTIO_BLK_F_BARRIER))
 		blk_queue_ordered(q, QUEUE_ORDERED_TAG, NULL);
 
-- 
1.6.5

