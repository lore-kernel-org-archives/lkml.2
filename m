Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030212Ab2CMAZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:25:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:49195 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965257Ab2CMAZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:25:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Tejun Heo <htejun@gmail.com>,
        Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 166/196] libata: set queue DMA alignment to sector size for ATAPI too
Date: Mon, 12 Mar 2012 20:21:19 -0400
Message-Id: <1331598109-31424-121-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 729a6a300e628a48cf12bac93a964a535e83cd1d upstream.

ata_pio_sectors() expects buffer for each sector to be contained in a
single page; otherwise, it ends up overrunning the first page.  This
is achieved by setting queue DMA alignment.  If sector_size is smaller
than PAGE_SIZE and all buffers are sector_size aligned, buffer for
each sector is always contained in a single page.

This wasn't applied to ATAPI devices but IDENTIFY_PACKET is executed
as ATA_PROT_PIO and thus uses ata_pio_sectors().  Newer versions of
udev issue IDENTIFY_PACKET with unaligned buffer triggering the
problem and causing oops.

This patch fixes the problem by setting sdev->sector_size to
ATA_SECT_SIZE on ATATPI devices and always setting DMA alignment to
sector_size.  While at it, add a warning for the unlikely but still
possible scenario where sector_size is larger than PAGE_SIZE, in which
case the alignment wouldn't be enough.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: John Stanley <jpsinthemix@verizon.net>
Tested-by: John Stanley <jpsinthemix@verizon.net>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/ata/libata-scsi.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1d266e2..0dfa468 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1104,9 +1104,9 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 		struct request_queue *q = sdev->request_queue;
 		void *buf;
 
-		/* set the min alignment and padding */
-		blk_queue_update_dma_alignment(sdev->request_queue,
-					       ATA_DMA_PAD_SZ - 1);
+		sdev->sector_size = ATA_SECT_SIZE;
+
+		/* set DMA padding */
 		blk_queue_update_dma_pad(sdev->request_queue,
 					 ATA_DMA_PAD_SZ - 1);
 
@@ -1120,12 +1120,24 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 
 		blk_queue_dma_drain(q, atapi_drain_needed, buf, ATAPI_MAX_DRAIN);
 	} else {
-		/* ATA devices must be sector aligned */
-		blk_queue_update_dma_alignment(sdev->request_queue,
-					       ATA_SECT_SIZE - 1);
 		sdev->manage_start_stop = 1;
 	}
 
+	/*
+	 * ata_pio_sectors() expects buffer for each sector to not cross
+	 * page boundary.  Enforce it by requiring buffers to be sector
+	 * aligned, which works iff sector_size is not larger than
+	 * PAGE_SIZE.  ATAPI devices also need the alignment as
+	 * IDENTIFY_PACKET is executed as ATA_PROT_PIO.
+	 */
+	if (sdev->sector_size > PAGE_SIZE)
+		ata_dev_printk(dev, KERN_WARNING,
+			"sector_size=%u > PAGE_SIZE, PIO may malfunction\n",
+			sdev->sector_size);
+
+	blk_queue_update_dma_alignment(sdev->request_queue,
+				       ATA_SECT_SIZE - 1);
+
 	if (dev->flags & ATA_DFLAG_AN)
 		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
 
-- 
1.7.9.3

