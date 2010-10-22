Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373Ab0JVTMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:12:44 -0400
Received: from kroah.org ([198.145.64.141]:34137 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759340Ab0JVS40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:26 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:31 2010
Message-Id: <20101022185231.392088564@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Snitzer <snitzer@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [045/103] virtio-blk: fix request leak.
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit e4c4776dea9fd0295ebb3b215599d52938d6d7a3 upstream.

Must drop reference taken by blk_make_request().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/virtio_blk.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -203,6 +203,7 @@ static int virtblk_get_id(struct gendisk
 	struct virtio_blk *vblk = disk->private_data;
 	struct request *req;
 	struct bio *bio;
+	int err;
 
 	bio = bio_map_kern(vblk->disk->queue, id_str, VIRTIO_BLK_ID_BYTES,
 			   GFP_KERNEL);
@@ -216,7 +217,10 @@ static int virtblk_get_id(struct gendisk
 	}
 
 	req->cmd_type = REQ_TYPE_SPECIAL;
-	return blk_execute_rq(vblk->disk->queue, vblk->disk, req, false);
+	err = blk_execute_rq(vblk->disk->queue, vblk->disk, req, false);
+	blk_put_request(req);
+
+	return err;
 }
 
 static int virtblk_ioctl(struct block_device *bdev, fmode_t mode,


