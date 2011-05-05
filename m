Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab1EECEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 22:04:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:48250 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab1EECEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 22:04:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,318,1301900400"; 
   d="scan'208";a="742563709"
Message-Id: <20110505020417.986492128@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 05 May 2011 09:59:35 +0800
From: shaohua.li@intel.com
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: jaxboe@fusionio.com, htejun@gmail.com, hch@infradead.org,
        jgarzik@pobox.com, djwong@us.ibm.com, sshtylyov@mvista.com,
        Shaohua Li <shaohua.li@intel.com>
Subject: [patch v3 3/3] SATA: enable non-queueable flush flag
References: <20110505015932.306763905@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=sata-add-nonqueueable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable non-queueable flush flag for SATA.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/ata/libata-scsi.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux/drivers/ata/libata-scsi.c
===================================================================
--- linux.orig/drivers/ata/libata-scsi.c	2011-05-05 09:09:58.000000000 +0800
+++ linux/drivers/ata/libata-scsi.c	2011-05-05 09:46:07.000000000 +0800
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

