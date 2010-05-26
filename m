Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab0EZIDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:03:42 -0400
Received: from ozlabs.org ([203.10.76.45]:41975 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab0EZIDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:03:38 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio-blk: fix minimum number of S/G elements
Date: Wed, 26 May 2010 17:33:28 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20100525121754.GA8456@lst.de>
In-Reply-To: <20100525121754.GA8456@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005261733.29460.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 09:47:54 pm Christoph Hellwig wrote:
> 
> We need at least one S/G element to operate properly, as does the block
> layer which increments it to one anyway.  We hit this due to a qemu
> bug which advertises a sg_elements of 0 under some circumstances.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems reasonable: we might as well ignore it if device is obviously talking
crap.

However, the result is awkward (we assign err then don't use it), and assumes
that sg_elems isn't touched on error (true at the moment).

Prefer this:

Subject: virtio-blk: fix minimum number of S/G elements
Date: Tue, 25 May 2010 14:17:54 +0200
From: Christoph Hellwig <hch@lst.de>

We need at least one S/G element to operate properly, as does the block
layer which increments it to one anyway.  We hit this due to a qemu
bug which advertises a sg_elements of 0 under some circumstances.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (tweaked logic)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -298,7 +298,9 @@ static int __devinit virtblk_probe(struc
 	err = virtio_config_val(vdev, VIRTIO_BLK_F_SEG_MAX,
 				offsetof(struct virtio_blk_config, seg_max),
 				&sg_elems);
-	if (err)
+
+	/* We need at least one SG element, whatever they say. */
+	if (err || !sg_elems)
 		sg_elems = 1;
 
 	/* We need an extra sg elements at head and tail. */
