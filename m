Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab0EYMSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 08:18:04 -0400
Received: from verein.lst.de ([213.95.11.210]:45880 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab0EYMSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 08:18:01 -0400
Date: Tue, 25 May 2010 14:17:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] virtio-blk: fix minimum number of S/G elements
Message-ID: <20100525121754.GA8456@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We need at least one S/G element to operate properly, as does the block
layer which increments it to one anyway.  We hit this due to a qemu
bug which advertises a sg_elements of 0 under some circumstances.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c	2010-05-25 13:21:44.136254435 +0200
+++ linux-2.6/drivers/block/virtio_blk.c	2010-05-25 13:59:04.334005727 +0200
@@ -287,7 +287,7 @@ static int __devinit virtblk_probe(struc
 	struct request_queue *q;
 	int err;
 	u64 cap;
-	u32 v, blk_size, sg_elems, opt_io_size;
+	u32 v, blk_size, sg_elems = 0, opt_io_size;
 	u16 min_io_size;
 	u8 physical_block_exp, alignment_offset;
 
@@ -298,7 +298,9 @@ static int __devinit virtblk_probe(struc
 	err = virtio_config_val(vdev, VIRTIO_BLK_F_SEG_MAX,
 				offsetof(struct virtio_blk_config, seg_max),
 				&sg_elems);
-	if (err)
+
+	/* We need at least one SG element */
+	if (!sg_elems)
 		sg_elems = 1;
 
 	/* We need an extra sg elements at head and tail. */
