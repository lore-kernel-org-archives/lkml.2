Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab1BPASJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:18:09 -0500
Received: from kroah.org ([198.145.64.141]:38582 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404Ab1BPASE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:18:04 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:25 2011
Message-Id: <20110216001425.866046326@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [008/272] libata: set queue DMA alignment to sector size for ATAPI too
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <htejun@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-scsi.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1102,9 +1102,9 @@ static int ata_scsi_dev_config(struct sc
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
 
@@ -1118,13 +1118,25 @@ static int ata_scsi_dev_config(struct sc
 
 		blk_queue_dma_drain(q, atapi_drain_needed, buf, ATAPI_MAX_DRAIN);
 	} else {
-		/* ATA devices must be sector aligned */
 		sdev->sector_size = ata_id_logical_sector_size(dev->id);
-		blk_queue_update_dma_alignment(sdev->request_queue,
-					       sdev->sector_size - 1);
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
+				       sdev->sector_size - 1);
+
 	if (dev->flags & ATA_DFLAG_AN)
 		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
 


