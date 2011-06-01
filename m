Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162199Ab1FAIST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:18:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:44129 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162101Ab1FAISB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:18:01 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:08 2011
Message-Id: <20110601081108.446306107@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:03 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shaohua Li <shaohua.li@intel.com>, Tejun Heo <tj@kernel.org>,
        Jeff Garzik <jgarzik@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [033/165] SATA: enable non-queueable flush flag
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1988
Lines: 66

From: "shaohua.li@intel.com" <shaohua.li@intel.com>

commit 900e599eb0c16390ff671652a44e0ea90532220e upstream.

Enable non-queueable flush flag for SATA.

Stable: 2.6.39 only

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-scsi.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1089,21 +1089,21 @@ static int atapi_drain_needed(struct req
 static int ata_scsi_dev_config(struct scsi_device *sdev,
 			       struct ata_device *dev)
 {
+	struct request_queue *q = sdev->request_queue;
+
 	if (!ata_id_has_unload(dev->id))
 		dev->flags |= ATA_DFLAG_NO_UNLOAD;
 
 	/* configure max sectors */
-	blk_queue_max_hw_sectors(sdev->request_queue, dev->max_sectors);
+	blk_queue_max_hw_sectors(q, dev->max_sectors);
 
 	if (dev->class == ATA_DEV_ATAPI) {
-		struct request_queue *q = sdev->request_queue;
 		void *buf;
 
 		sdev->sector_size = ATA_SECT_SIZE;
 
 		/* set DMA padding */
-		blk_queue_update_dma_pad(sdev->request_queue,
-					 ATA_DMA_PAD_SZ - 1);
+		blk_queue_update_dma_pad(q, ATA_DMA_PAD_SZ - 1);
 
 		/* configure draining */
 		buf = kmalloc(ATAPI_MAX_DRAIN, q->bounce_gfp | GFP_KERNEL);
@@ -1131,8 +1131,7 @@ static int ata_scsi_dev_config(struct sc
 			"sector_size=%u > PAGE_SIZE, PIO may malfunction\n",
 			sdev->sector_size);
 
-	blk_queue_update_dma_alignment(sdev->request_queue,
-				       sdev->sector_size - 1);
+	blk_queue_update_dma_alignment(q, sdev->sector_size - 1);
 
 	if (dev->flags & ATA_DFLAG_AN)
 		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
@@ -1145,6 +1144,8 @@ static int ata_scsi_dev_config(struct sc
 		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, depth);
 	}
 
+	blk_queue_flush_queueable(q, false);
+
 	dev->sdev = sdev;
 	return 0;
 }


