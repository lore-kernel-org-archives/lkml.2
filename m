Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab1JMNpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 09:45:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59496 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab1JMNpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 09:45:52 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH v2 2/4] ata_piix: unify code for programming PIO and MWDMA timings
Date: Thu, 13 Oct 2011 15:39:10 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131539.11190.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH v2] ata_piix: unify code for programming PIO and MWDMA timings

Besides making things noticably simpler it results in ~2% decrease in
the driver LOC count and also ~2% decrease in the driver binary size
(as measured on x86-32).

Fix piix_set_piomode() documentation while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
v2: remove use_mwdma variable and fix comment style

earlier references:
https://lkml.org/lkml/2011/2/8/99

 drivers/ata/ata_piix.c |  111 ++++++++++++++++---------------------------------
 1 file changed, 38 insertions(+), 73 deletions(-)

Index: b/drivers/ata/ata_piix.c
===================================================================
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -704,22 +704,11 @@ static int piix_pata_prereset(struct ata
 
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
+			     u8 pio)
 {
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
 	unsigned long flags;
-	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	unsigned int is_slave	= (adev->devno != 0);
 	unsigned int master_port= ap->port_no ? 0x42 : 0x40;
 	unsigned int slave_port	= 0x44;
@@ -744,10 +733,16 @@ static void piix_set_piomode(struct ata_
 		control |= 1;	/* TIME1 enable */
 	if (ata_pio_need_iordy(adev))
 		control |= 2;	/* IE enable */
-
 	/* Intel specifies that the PPE functionality is for disk only */
 	if (adev->class == ATA_DEV_ATA)
 		control |= 4;	/* PPE enable */
+	/*
+	 * If the drive MWDMA is faster than it can do PIO then
+	 * we must force PIO into PIO0
+	 */
+	if (adev->pio_mode < XFER_PIO_0 + pio)
+		/* Enable DMA timing only */
+		control |= 8;	/* PIO cycles in PIO0 */
 
 	spin_lock_irqsave(&piix_lock, flags);
 
@@ -796,6 +791,22 @@ static void piix_set_piomode(struct ata_
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
+	piix_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0);
+}
+
+/**
  *	do_pata_set_dmamode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Drive in question
@@ -811,31 +822,20 @@ static void do_pata_set_dmamode(struct a
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
@@ -868,56 +868,21 @@ static void do_pata_set_dmamode(struct a
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
+		/* XFER_PIO_0 is never used currently */
+		piix_set_timings(ap, adev, pio);
 	}
-	/* Don't scribble on 0x48 if the controller does not support UDMA */
-	if (ap->udma_mask)
-		pci_write_config_byte(dev, 0x48, udma_enable);
-
-	spin_unlock_irqrestore(&piix_lock, flags);
 }
 
 /**
