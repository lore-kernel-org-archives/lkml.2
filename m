Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab2BEWsz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:48:55 -0500
Received: from 1wt.eu ([62.212.114.60]:61845 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab2BEW0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:14 -0500
Message-Id: <20120205220950.173907665@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:06 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>,
        Jonathan Liu <net147@gmail.com>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 17/91] libata: set queue DMA alignment to sector size for ATAPI too
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Jonathan Liu <net147@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ata/libata-scsi.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

Index: longterm-2.6.27/drivers/ata/libata-scsi.c
===================================================================
--- longterm-2.6.27.orig/drivers/ata/libata-scsi.c	2012-02-05 22:34:34.505914937 +0100
+++ longterm-2.6.27/drivers/ata/libata-scsi.c	2012-02-05 22:34:37.312916183 +0100
@@ -957,13 +957,13 @@
 	/* configure max sectors */
 	blk_queue_max_sectors(sdev->request_queue, dev->max_sectors);
 
+	sdev->sector_size = ATA_SECT_SIZE;
+
 	if (dev->class == ATA_DEV_ATAPI) {
 		struct request_queue *q = sdev->request_queue;
 		void *buf;
 
-		/* set the min alignment and padding */
-		blk_queue_update_dma_alignment(sdev->request_queue,
-					       ATA_DMA_PAD_SZ - 1);
+		/* set DMA padding */
 		blk_queue_update_dma_pad(sdev->request_queue,
 					 ATA_DMA_PAD_SZ - 1);
 
@@ -977,12 +977,24 @@
 
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
+				       sdev->sector_size - 1);
+
 	if (dev->flags & ATA_DFLAG_AN)
 		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
 


