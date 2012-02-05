Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab2BEW0Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:25 -0500
Received: from 1wt.eu ([62.212.114.60]:61828 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366Ab2BEW0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:11 -0500
Message-Id: <20120205220950.131533625@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:05 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bart Hartgers <bart.hartgers@gmail.com>, Jeff Garzik <jgarzik@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 16/91] sata_via: Delay on vt6420 when starting ATAPI DMA write
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit a55ab496ea9c820b7192c15ef1fbf3291edfe638 upstream.

When writing a disc on certain lite-on dvd-writers (also rebadged
as optiarc/LG/...) connected to a vt6420, the ATAPI CDB ends
up in the datastream and on the disc, causing silent corruption.
Delaying between sending the CDB and starting DMA seems to
prevent this.

I do not know if there are burners that do not suffer from
this, but the patch should be safe for those as well.

There are many reports of this issue, but AFAICT no solution was
found before. For example:
http://lkml.indiana.edu/hypermail/linux/kernel/0802.3/0561.html

Signed-off-by: Bart Hartgers <bart.hartgers@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
[bwh: Remove version bump for 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ata/sata_via.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/drivers/ata/sata_via.c
===================================================================
--- longterm-2.6.27.orig/drivers/ata/sata_via.c	2012-02-05 22:34:34.531916020 +0100
+++ longterm-2.6.27/drivers/ata/sata_via.c	2012-02-05 22:34:37.173915226 +0100
@@ -40,6 +40,8 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 
@@ -72,6 +74,7 @@
 static int svia_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
 static void svia_noop_freeze(struct ata_port *ap);
 static int vt6420_prereset(struct ata_link *link, unsigned long deadline);
+static void vt6420_bmdma_start(struct ata_queued_cmd *qc);
 static int vt6421_pata_cable_detect(struct ata_port *ap);
 static void vt6421_set_pio_mode(struct ata_port *ap, struct ata_device *adev);
 static void vt6421_set_dma_mode(struct ata_port *ap, struct ata_device *adev);
@@ -107,6 +110,7 @@
 	.inherits		= &ata_bmdma_port_ops,
 	.freeze			= svia_noop_freeze,
 	.prereset		= vt6420_prereset,
+	.bmdma_start		= vt6420_bmdma_start,
 };
 
 static struct ata_port_operations vt6421_pata_ops = {
@@ -247,6 +251,17 @@
 	return 0;
 }
 
+static void vt6420_bmdma_start(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	if ((qc->tf.command == ATA_CMD_PACKET) &&
+	    (qc->scsicmd->sc_data_direction == DMA_TO_DEVICE)) {
+		/* Prevents corruption on some ATAPI burners */
+		ata_sff_pause(ap);
+	}
+	ata_bmdma_start(qc);
+}
+
 static int vt6421_pata_cable_detect(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);


