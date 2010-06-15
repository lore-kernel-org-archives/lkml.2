Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab0FOMn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 08:43:56 -0400
Received: from verein.lst.de ([213.95.11.210]:43775 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0FOMnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 08:43:55 -0400
Date: Tue, 15 Jun 2010 14:43:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: rusty@rustcorp.com.au
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] virtio_blk: support barriers without FLUSH feature
Message-ID: <20100615124348.GA25804@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we want to support barriers with the cache=writethrough mode in qemu
we need to tell the block layer that we only need queue drains to
implement a barrier.  Follow the model set by SCSI and IDE and assume
that there is no volatile write cache if the host doesn't advertize it.
While this might imply working barriers on old qemu versions or other
hypervisors that actually have a volatile write cache this is only a
cosmetic issue - these hypervisors don't guarantee any data integrity
with or without this patch, but with the patch we at least provide
data ordering.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c	2010-06-08 12:01:09.625254254 +0200
+++ linux-2.6/drivers/block/virtio_blk.c	2010-06-15 14:38:18.518273290 +0200
@@ -366,12 +366,32 @@ static int __devinit virtblk_probe(struc
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
 		blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH,
 				  virtblk_prepare_flush);
-	else if (virtio_has_feature(vdev, VIRTIO_BLK_F_BARRIER))
+	} else if (virtio_has_feature(vdev, VIRTIO_BLK_F_BARRIER)) {
+		/*
+		 * If the BARRIER feature is supported the host expects us
+		 * to order request by tags.  This implies there is not
+		 * volatile write cache on the host, and that the host
+		 * never re-orders outstanding I/O.  This feature is not
+		 * useful for real life scenarious and deprecated.
+		 */
 		blk_queue_ordered(q, QUEUE_ORDERED_TAG, NULL);
+	} else {
+		/*
+		 * If the FLUSH feature is not supported we must assume that
+		 * the host does not perform any kind of volatile write
+		 * caching. We still need to drain the queue to provider
+		 * proper barrier semantics.
+		 */
+		blk_queue_ordered(q, QUEUE_ORDERED_DRAIN, NULL);
+	}
 
 	/* If disk is read-only in the host, the guest should obey */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_RO))
