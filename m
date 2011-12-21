Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1LUBBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:01:52 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44470 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab1LUBBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:01:22 -0500
From: Minchan Kim <minchan@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan@redhat.com>
Subject: [PATCH 3/6] virtio-blk: remove the unused list of pending requests
Date: Wed, 21 Dec 2011 10:00:51 +0900
Message-Id: <1324429254-28383-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1324429254-28383-1-git-send-email-minchan@kernel.org>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Minchan Kim <minchan@redhat.com>
---
 drivers/block/virtio_blk.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 4d0b70a..26d4443 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -28,9 +28,6 @@ struct virtio_blk
 	/* The disk structure for the kernel. */
 	struct gendisk *disk;
 
-	/* Request tracking. */
-	struct list_head reqs;
-
 	mempool_t *pool;
 
 	/* Process context for config space updates */
@@ -48,7 +45,6 @@ struct virtio_blk
 
 struct virtblk_req
 {
-	struct list_head list;
 	struct request *req;
 	struct virtio_blk_outhdr out_hdr;
 	struct virtio_scsi_inhdr in_hdr;
@@ -92,7 +88,6 @@ static void blk_done(struct virtqueue *vq)
 		}
 
 		__blk_end_request_all(vbr->req, error);
-		list_del(&vbr->list);
 		mempool_free(vbr, vblk->pool);
 	}
 	/* In case queue is stopped waiting for more buffers. */
@@ -177,7 +172,6 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 		return false;
 	}
 
-	list_add_tail(&vbr->list, &vblk->reqs);
 	return true;
 }
 
@@ -383,7 +377,6 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 		goto out_free_index;
 	}
 
-	INIT_LIST_HEAD(&vblk->reqs);
 	spin_lock_init(&vblk->lock);
 	vblk->vdev = vdev;
 	vblk->sg_elems = sg_elems;
@@ -544,9 +537,6 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
 
 	flush_work(&vblk->config_work);
 
-	/* Nothing should be pending. */
-	BUG_ON(!list_empty(&vblk->reqs));
-
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
 
-- 
1.7.6.4

