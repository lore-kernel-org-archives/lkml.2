Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab1EFA0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:26:20 -0400
Received: from kroah.org ([198.145.64.141]:37379 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab1EFA0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:26:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:18 2011
Message-Id: <20110506002218.546802788@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:22:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bart Hartgers <bart.hartgers@gmail.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [135/143] sata_via: Delay on vt6420 when starting ATAPI DMA write
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Bart Hartgers <bart.hartgers@gmail.com>

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
 1 file changed, 15 insertions(+)

--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -40,6 +40,8 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 
@@ -80,6 +82,7 @@ static int vt8251_scr_write(struct ata_l
 static void svia_tf_load(struct ata_port *ap, const struct ata_taskfile *tf);
 static void svia_noop_freeze(struct ata_port *ap);
 static int vt6420_prereset(struct ata_link *link, unsigned long deadline);
+static void vt6420_bmdma_start(struct ata_queued_cmd *qc);
 static int vt6421_pata_cable_detect(struct ata_port *ap);
 static void vt6421_set_pio_mode(struct ata_port *ap, struct ata_device *adev);
 static void vt6421_set_dma_mode(struct ata_port *ap, struct ata_device *adev);
@@ -121,6 +124,7 @@ static struct ata_port_operations vt6420
 	.inherits		= &svia_base_ops,
 	.freeze			= svia_noop_freeze,
 	.prereset		= vt6420_prereset,
+	.bmdma_start		= vt6420_bmdma_start,
 };
 
 static struct ata_port_operations vt6421_pata_ops = {
@@ -377,6 +381,17 @@ static int vt6420_prereset(struct ata_li
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


