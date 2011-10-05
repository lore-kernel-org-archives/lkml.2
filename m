Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935294Ab1JETzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:55:43 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55659
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934819Ab1JETzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:55:40 -0400
Message-Id: <20111005195530.167191887@bombadil.infradead.org>
User-Agent: quilt/0.48-1
Date: Wed, 05 Oct 2011 15:54:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] virtio-blk: remove the unused list of pending requests
References: <20111005195403.407628164@bombadil.infradead.org>
Content-Disposition: inline; filename=virtio-blk-remove-list
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c	2011-10-03 19:55:29.061215040 +0200
+++ linux-2.6/drivers/block/virtio_blk.c	2011-10-03 19:55:54.196412176 +0200
@@ -24,9 +24,6 @@ struct virtio_blk
 	/* The disk structure for the kernel. */
 	struct gendisk *disk;
 
-	/* Request tracking. */
-	struct list_head reqs;
-
 	mempool_t *pool;
 
 	/* Process context for config space updates */
@@ -41,7 +38,6 @@ struct virtio_blk
 
 struct virtblk_req
 {
-	struct list_head list;
 	struct request *req;
 	struct virtio_blk_outhdr out_hdr;
 	struct virtio_scsi_inhdr in_hdr;
@@ -85,7 +81,6 @@ static void blk_done(struct virtqueue *v
 		}
 
 		__blk_end_request_all(vbr->req, error);
-		list_del(&vbr->list);
 		mempool_free(vbr, vblk->pool);
 	}
 	/* In case queue is stopped waiting for more buffers. */
@@ -170,7 +165,6 @@ static bool do_req(struct request_queue
 		return false;
 	}
 
-	list_add_tail(&vbr->list, &vblk->reqs);
 	return true;
 }
 
@@ -368,7 +362,6 @@ static int __devinit virtblk_probe(struc
 		goto out;
 	}
 
-	INIT_LIST_HEAD(&vblk->reqs);
 	spin_lock_init(&vblk->lock);
 	vblk->vdev = vdev;
 	vblk->sg_elems = sg_elems;
@@ -526,9 +519,6 @@ static void __devexit virtblk_remove(str
 
 	flush_work(&vblk->config_work);
 
-	/* Nothing should be pending. */
-	BUG_ON(!list_empty(&vblk->reqs));
-
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
 

