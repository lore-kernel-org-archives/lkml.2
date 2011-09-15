Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934147Ab1IOPu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:50:58 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43910
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934067Ab1IOPu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:50:56 -0400
Date: Thu, 15 Sep 2011 11:50:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: axboe@kernel.dk, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] virtio_blk: use blk_rq_map_kern
Message-ID: <20110915155051.GA29694@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use blk_rq_map_kern instead of opencoding it for the serial sysfs attribute.

[Rusty, any chance to get this in through the block tree? I have some
 other bits in that area pending for it]

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c	2011-09-14 10:49:32.571738374 -0400
+++ linux-2.6/drivers/block/virtio_blk.c	2011-09-14 10:53:54.483239920 -0400
@@ -203,24 +203,20 @@ static int virtblk_get_id(struct gendisk
 {
 	struct virtio_blk *vblk = disk->private_data;
 	struct request *req;
-	struct bio *bio;
 	int err;
 
-	bio = bio_map_kern(vblk->disk->queue, id_str, VIRTIO_BLK_ID_BYTES,
-			   GFP_KERNEL);
-	if (IS_ERR(bio))
-		return PTR_ERR(bio);
+	req = blk_get_request(vblk->disk->queue, READ, GFP_KERNEL);
 
-	req = blk_make_request(vblk->disk->queue, bio, GFP_KERNEL);
-	if (IS_ERR(req)) {
-		bio_put(bio);
-		return PTR_ERR(req);
-	}
+	err = blk_rq_map_kern(vblk->disk->queue, req, id_str,
+			      VIRTIO_BLK_ID_BYTES, GFP_KERNEL);
+	if (err)
+		goto put_request;
 
 	req->cmd_type = REQ_TYPE_SPECIAL;
 	err = blk_execute_rq(vblk->disk->queue, vblk->disk, req, false);
-	blk_put_request(req);
 
+put_request:
+	blk_put_request(req);
 	return err;
 }
 
