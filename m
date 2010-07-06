Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab0GFE0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 00:26:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53225 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab0GFEZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 00:25:55 -0400
Date: Tue, 6 Jul 2010 14:25:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Rusty Russell <rusty@rustcorp.com.au>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: linux-next: manual merge of the block tree with the rr tree
Message-Id: <20100706142553.e1bdd94f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
drivers/block/virtio_blk.c between commit
0e41b2d3ea0f5bf472a2b163c54305f62ab7b776 ("virtio_blk: support barriers
without FLUSH feature") from the rr tree and commits
3789fdefa13bcaa7ad06d952ac6010f0a81bf04e ("virtio_blk: stop using
q->prepare_flush_fn") and 5e27e27e73b5bff903b3c30ffd5a0e17eb95c087
("block: remove q->prepare_flush_fn completely") from the block tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/block/virtio_blk.c
index 23b7c48,0a3222f..0000000
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@@ -377,32 -364,11 +375,31 @@@ static int __devinit virtblk_probe(stru
  	vblk->disk->driverfs_dev = &vdev->dev;
  	index++;
  
 -	/* If barriers are supported, tell block layer that queue is ordered */
 -	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
 +	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH)) {
 +		/*
 +		 * If the FLUSH feature is supported we do have support for
 +		 * flushing a volatile write cache on the host.  Use that
 +		 * to implement write barrier support.
 +		 */
- 		blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH,
- 				  virtblk_prepare_flush);
+ 		blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH);
 -	else if (virtio_has_feature(vdev, VIRTIO_BLK_F_BARRIER))
 +	} else if (virtio_has_feature(vdev, VIRTIO_BLK_F_BARRIER)) {
 +		/*
 +		 * If the BARRIER feature is supported the host expects us
 +		 * to order request by tags.  This implies there is not
 +		 * volatile write cache on the host, and that the host
 +		 * never re-orders outstanding I/O.  This feature is not
 +		 * useful for real life scenarious and deprecated.
 +		 */
- 		blk_queue_ordered(q, QUEUE_ORDERED_TAG, NULL);
+ 		blk_queue_ordered(q, QUEUE_ORDERED_TAG);
 +	} else {
 +		/*
 +		 * If the FLUSH feature is not supported we must assume that
 +		 * the host does not perform any kind of volatile write
 +		 * caching. We still need to drain the queue to provider
 +		 * proper barrier semantics.
 +		 */
- 		blk_queue_ordered(q, QUEUE_ORDERED_DRAIN, NULL);
++		blk_queue_ordered(q, QUEUE_ORDERED_DRAIN);
 +	}
  
  	/* If disk is read-only in the host, the guest should obey */
  	if (virtio_has_feature(vdev, VIRTIO_BLK_F_RO))
