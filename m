Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0KBQWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:22:06 -0400
Received: from claw.goop.org ([74.207.240.146]:49556 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab0KBQVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:21:35 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Stodden <daniel.stodden@citrix.com>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 2/4] xen/blkfront: change blk_shadow.request to proper pointer
Date: Tue,  2 Nov 2010 12:20:45 -0400
Message-Id: <a945b9801a9bfd4a98bcfd9f6656b5027b254e3f.1288714384.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1288714384.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288714384.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1288714384.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288714384.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 3a318d8..31c8a64 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -65,7 +65,7 @@ enum blkif_state {
 
 struct blk_shadow {
 	struct blkif_request req;
-	unsigned long request;
+	struct request *request;
 	unsigned long frame[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 };
 
@@ -136,7 +136,7 @@ static void add_id_to_freelist(struct blkfront_info *info,
 			       unsigned long id)
 {
 	info->shadow[id].req.id  = info->shadow_free;
-	info->shadow[id].request = 0;
+	info->shadow[id].request = NULL;
 	info->shadow_free = id;
 }
 
@@ -278,7 +278,7 @@ static int blkif_queue_request(struct request *req)
 	/* Fill out a communications ring structure. */
 	ring_req = RING_GET_REQUEST(&info->ring, info->ring.req_prod_pvt);
 	id = get_id_from_freelist(info);
-	info->shadow[id].request = (unsigned long)req;
+	info->shadow[id].request = req;
 
 	ring_req->id = id;
 	ring_req->sector_number = (blkif_sector_t)blk_rq_pos(req);
@@ -633,7 +633,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 
 		bret = RING_GET_RESPONSE(&info->ring, i);
 		id   = bret->id;
-		req  = (struct request *)info->shadow[id].request;
+		req  = info->shadow[id].request;
 
 		blkif_completion(&info->shadow[id]);
 
@@ -898,7 +898,7 @@ static int blkif_recover(struct blkfront_info *info)
 	/* Stage 3: Find pending requests and requeue them. */
 	for (i = 0; i < BLK_RING_SIZE; i++) {
 		/* Not in use? */
-		if (copy[i].request == 0)
+		if (!copy[i].request)
 			continue;
 
 		/* Grab a request slot and copy shadow state into it. */
@@ -915,9 +915,7 @@ static int blkif_recover(struct blkfront_info *info)
 				req->seg[j].gref,
 				info->xbdev->otherend_id,
 				pfn_to_mfn(info->shadow[req->id].frame[j]),
-				rq_data_dir(
-					(struct request *)
-					info->shadow[req->id].request));
+				rq_data_dir(info->shadow[req->id].request));
 		info->shadow[req->id].req = *req;
 
 		info->ring.req_prod_pvt++;
-- 
1.7.2.3

