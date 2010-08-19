Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0HSPSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:18:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:49760 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab0HSPSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:18:41 -0400
Message-ID: <4C6D4A4D.7090501@kernel.org>
Date: Thu, 19 Aug 2010 17:14:21 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        Tejun Heo <tj@kernle.org>
Subject: [PATCH 2/5 UPDATED] virtio_blk: drop REQ_HARDBARRIER support
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <1281977523-19335-3-git-send-email-tj@kernel.org>
In-Reply-To: <1281977523-19335-3-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 19 Aug 2010 15:18:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove now unused REQ_HARDBARRIER support.  virtio_blk already
supports REQ_FLUSH and the usefulness of REQ_FUA for virtio_blk is
questionable at this point, so there's nothing else to do to support
new REQ_FLUSH/FUA interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
---
REQ_FUA support dropped as suggested by Christoph.

 drivers/block/virtio_blk.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

Index: block/drivers/block/virtio_blk.c
===================================================================
--- block.orig/drivers/block/virtio_blk.c
+++ block/drivers/block/virtio_blk.c
@@ -128,9 +128,6 @@ static bool do_req(struct request_queue
 		}
 	}

-	if (vbr->req->cmd_flags & REQ_HARDBARRIER)
-		vbr->out_hdr.type |= VIRTIO_BLK_T_BARRIER;
-
 	sg_set_buf(&vblk->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));

 	/*
@@ -388,13 +385,7 @@ static int __devinit virtblk_probe(struc
 	vblk->disk->driverfs_dev = &vdev->dev;
 	index++;

-	/*
-	 * If the FLUSH feature is supported we do have support for
-	 * flushing a volatile write cache on the host.  Use that to
-	 * implement write barrier support; otherwise, we must assume
-	 * that the host does not perform any kind of volatile write
-	 * caching.
-	 */
+	/* configure queue flush support */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
 		blk_queue_flush(q, REQ_FLUSH);

@@ -515,9 +506,9 @@ static const struct virtio_device_id id_
 };

 static unsigned int features[] = {
-	VIRTIO_BLK_F_BARRIER, VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX,
-	VIRTIO_BLK_F_GEOMETRY, VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
-	VIRTIO_BLK_F_SCSI, VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY
+	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
+	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE, VIRTIO_BLK_F_SCSI,
+	VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY
 };

 /*
