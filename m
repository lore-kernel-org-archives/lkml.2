Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1BHMX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:23:58 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48060 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1BHMX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:23:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=RCNNWIGD9YSAEFs+LMLlbRjGZNHvSv9UOJTBBlrmhWkkybYBIDADhdIbluwrxdZPXE
         lijGqiIrywNbd3znCJIpp487DpsqwhNznRyrYclLtcP7GhAROq1aLWrVD8QDU8x38gTv
         5i77xu3TwtqcVeZ0PO7t0djF9pwbvvcYiALHw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Feb 2011 13:23:46 +0100
Message-Id: <20110208122346.19110.8441.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
Subject: [PATCH 02/20] ata_piix: unify code for programming PIO and MWDMA timings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ca6c1fbc7d853829524b87a3bcbbb1f67796281c Mon Sep 17 00:00:00 2001
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 8 Feb 2011 12:39:24 +0100
Subject: [PATCH 02/20] ata_piix: unify code for programming PIO and MWDMA timings

Besides making things noticably simpler it results in ~2% decrease in
the driver LOC count and also ~2% decrease in the driver binary size
(as measured on x86-32).

Fix piix_set_piomode() documentation while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/ata_piix.c |  112 ++++++++++++++++--------------------------------
 1 files changed, 37 insertions(+), 75 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 0f4856d..c954f91 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -696,22 +696,11 @@ static int piix_pata_prereset(struct ata_link *link, unsigned long deadline)
 
 static DEFINE_SPINLOCK(piix_lock);
 
-/**
- *	piix_set_piomode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: um
- *
- *	Set PIO mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
+static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
+			     u8 pio, bool use_mwdma)
 {
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
 	unsigned long flags;
-	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	unsigned int is_slave	= (adev->devno != 0);
 	unsigned int master_port= ap->port_no ? 0x42 : 0x40;
 	unsigned int slave_port	= 0x44;
@@ -732,14 +721,18 @@ static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
 			    { 2, 1 },
 			    { 2, 3 }, };
 
-	if (pio >= 2)
+	if (pio >= 2 || use_mwdma)
 		control |= 1;	/* TIME1 enable */
-	if (ata_pio_need_iordy(adev))
+	if (ata_pio_need_iordy(adev) || use_mwdma)
 		control |= 2;	/* IE enable */
-
 	/* Intel specifies that the PPE functionality is for disk only */
 	if (adev->class == ATA_DEV_ATA)
 		control |= 4;	/* PPE enable */
+	/* If the drive MWDMA is faster than it can do PIO then
+	   we must force PIO into PIO0 */
+	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))
+		/* Enable DMA timing only */
+		control |= 8;	/* PIO cycles in PIO0 */
 
 	spin_lock_irqsave(&piix_lock, flags);
 
@@ -788,6 +781,22 @@ static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
 }
 
 /**
+ *	piix_set_piomode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Drive in question
+ *
+ *	Set PIO mode for device, in host controller PCI config space.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	piix_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);
+}
+
+/**
  *	do_pata_set_dmamode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Drive in question
@@ -803,31 +812,20 @@ static void do_pata_set_dmamode(struct ata_port *ap, struct ata_device *adev, in
 {
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
 	unsigned long flags;
-	u8 master_port		= ap->port_no ? 0x42 : 0x40;
-	u16 master_data;
 	u8 speed		= adev->dma_mode;
 	int devid		= adev->devno + 2 * ap->port_no;
 	u8 udma_enable		= 0;
 
-	static const	 /* ISP  RTC */
-	u8 timings[][2]	= { { 0, 0 },
-			    { 0, 0 },
-			    { 1, 0 },
-			    { 2, 1 },
-			    { 2, 3 }, };
-
-	spin_lock_irqsave(&piix_lock, flags);
-
-	pci_read_config_word(dev, master_port, &master_data);
-	if (ap->udma_mask)
-		pci_read_config_byte(dev, 0x48, &udma_enable);
-
 	if (speed >= XFER_UDMA_0) {
-		unsigned int udma = adev->dma_mode - XFER_UDMA_0;
+		unsigned int udma = speed - XFER_UDMA_0;
 		u16 udma_timing;
 		u16 ideconf;
 		int u_clock, u_speed;
 
+		spin_lock_irqsave(&piix_lock, flags);
+
+		pci_read_config_byte(dev, 0x48, &udma_enable);
+
 		/*
 		 * UDMA is handled by a combination of clock switching and
 		 * selection of dividers
@@ -860,56 +858,20 @@ static void do_pata_set_dmamode(struct ata_port *ap, struct ata_device *adev, in
 			   performance (WR_PingPong_En) */
 			pci_write_config_word(dev, 0x54, ideconf);
 		}
+
+		pci_write_config_byte(dev, 0x48, udma_enable);
+
+		spin_unlock_irqrestore(&piix_lock, flags);
 	} else {
-		/*
-		 * MWDMA is driven by the PIO timings. We must also enable
-		 * IORDY unconditionally along with TIME1. PPE has already
-		 * been set when the PIO timing was set.
-		 */
-		unsigned int mwdma	= adev->dma_mode - XFER_MW_DMA_0;
-		unsigned int control;
-		u8 slave_data;
+		/* MWDMA is driven by the PIO timings. */
+		unsigned int mwdma = speed - XFER_MW_DMA_0;
 		const unsigned int needed_pio[3] = {
 			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
 		};
 		int pio = needed_pio[mwdma] - XFER_PIO_0;
 
-		control = 3;	/* IORDY|TIME1 */
-
-		/* If the drive MWDMA is faster than it can do PIO then
-		   we must force PIO into PIO0 */
-
-		if (adev->pio_mode < needed_pio[mwdma])
-			/* Enable DMA timing only */
-			control |= 8;	/* PIO cycles in PIO0 */
-
-		if (adev->devno) {	/* Slave */
-			master_data &= 0xFF4F;  /* Mask out IORDY|TIME1|DMAONLY */
-			master_data |= control << 4;
-			pci_read_config_byte(dev, 0x44, &slave_data);
-			slave_data &= (ap->port_no ? 0x0f : 0xf0);
-			/* Load the matching timing */
-			slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << (ap->port_no ? 4 : 0);
-			pci_write_config_byte(dev, 0x44, slave_data);
-		} else { 	/* Master */
-			master_data &= 0xCCF4;	/* Mask out IORDY|TIME1|DMAONLY
-						   and master timing bits */
-			master_data |= control;
-			master_data |=
-				(timings[pio][0] << 12) |
-				(timings[pio][1] << 8);
-		}
-
-		if (ap->udma_mask)
-			udma_enable &= ~(1 << devid);
-
-		pci_write_config_word(dev, master_port, master_data);
+		piix_set_timings(ap, adev, pio, 1);
 	}
-	/* Don't scribble on 0x48 if the controller does not support UDMA */
-	if (ap->udma_mask)
-		pci_write_config_byte(dev, 0x48, udma_enable);
-
-	spin_unlock_irqrestore(&piix_lock, flags);
 }
 
 /**
-- 
1.7.1

