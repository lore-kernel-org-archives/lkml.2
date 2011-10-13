Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab1JMOGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:06:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43215 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab1JMOGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:06:44 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] pata_rdc: parallel scanning needs an extra locking
Date: Thu, 13 Oct 2011 16:06:04 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131606.04496.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_rdc: parallel scanning needs an extra locking

This is similar change as commit 60c3be3 ("ata_piix: parallel scanning
on PATA needs an extra locking") for ata_piix host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_rdc.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: b/drivers/ata/pata_rdc.c
===================================================================
--- a/drivers/ata/pata_rdc.c
+++ b/drivers/ata/pata_rdc.c
@@ -86,6 +86,8 @@ static int rdc_pata_prereset(struct ata_
 	return ata_sff_prereset(link, deadline);
 }
 
+static DEFINE_SPINLOCK(rdc_lock);
+
 /**
  *	rdc_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
@@ -101,6 +103,7 @@ static void rdc_set_piomode(struct ata_p
 {
 	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned long flags;
 	unsigned int is_slave	= (adev->devno != 0);
 	unsigned int master_port= ap->port_no ? 0x42 : 0x40;
 	unsigned int slave_port	= 0x44;
@@ -124,6 +127,8 @@ static void rdc_set_piomode(struct ata_p
 	if (adev->class == ATA_DEV_ATA)
 		control |= 4;	/* PPE enable */
 
+	spin_lock_irqsave(&rdc_lock, flags);
+
 	/* PIO configuration clears DTE unconditionally.  It will be
 	 * programmed in set_dmamode which is guaranteed to be called
 	 * after set_piomode if any DMA mode is available.
@@ -161,6 +166,8 @@ static void rdc_set_piomode(struct ata_p
 	pci_read_config_byte(dev, 0x48, &udma_enable);
 	udma_enable &= ~(1 << (2 * ap->port_no + adev->devno));
 	pci_write_config_byte(dev, 0x48, udma_enable);
+
+	spin_unlock_irqrestore(&rdc_lock, flags);
 }
 
 /**
@@ -177,6 +184,7 @@ static void rdc_set_piomode(struct ata_p
 static void rdc_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned long flags;
 	u8 master_port		= ap->port_no ? 0x42 : 0x40;
 	u16 master_data;
 	u8 speed		= adev->dma_mode;
@@ -190,6 +198,8 @@ static void rdc_set_dmamode(struct ata_p
 			    { 2, 1 },
 			    { 2, 3 }, };
 
+	spin_lock_irqsave(&rdc_lock, flags);
+
 	pci_read_config_word(dev, master_port, &master_data);
 	pci_read_config_byte(dev, 0x48, &udma_enable);
 
@@ -271,6 +281,8 @@ static void rdc_set_dmamode(struct ata_p
 		pci_write_config_word(dev, master_port, master_data);
 	}
 	pci_write_config_byte(dev, 0x48, udma_enable);
+
+	spin_unlock_irqrestore(&rdc_lock, flags);
 }
 
 static struct ata_port_operations rdc_pata_ops = {
