Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1JKSZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:25:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab1JKSZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:25:19 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] pata_artop: unify ->prereset methods
Date: Tue, 11 Oct 2011 19:45:52 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201110111945.52701.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_artop: unify ->prereset methods

* Unify ->prereset methods for ATP850 and ATP86x[R] chipsets.

* Fix ->prereset documentation while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2009/11/25/315

 drivers/ata/pata_artop.c |   26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

Index: b/drivers/ata/pata_artop.c
===================================================================
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -39,31 +39,15 @@
 
 static int clock = 0;
 
-static int artop6210_pre_reset(struct ata_link *link, unsigned long deadline)
-{
-	struct ata_port *ap = link->ap;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	const struct pci_bits artop_enable_bits[] = {
-		{ 0x4AU, 1U, 0x02UL, 0x02UL },	/* port 0 */
-		{ 0x4AU, 1U, 0x04UL, 0x04UL },	/* port 1 */
-	};
-
-	if (!pci_test_config_bits(pdev, &artop_enable_bits[ap->port_no]))
-		return -ENOENT;
-
-	return ata_sff_prereset(link, deadline);
-}
-
 /**
- *	artop6260_pre_reset	-	check for 40/80 pin
+ *	artop62x0_pre_reset	-	probe begin
  *	@link: link
  *	@deadline: deadline jiffies for the operation
  *
- *	The ARTOP hardware reports the cable detect bits in register 0x49.
  *	Nothing complicated needed here.
  */
 
-static int artop6260_pre_reset(struct ata_link *link, unsigned long deadline)
+static int artop62x0_pre_reset(struct ata_link *link, unsigned long deadline)
 {
 	static const struct pci_bits artop_enable_bits[] = {
 		{ 0x4AU, 1U, 0x02UL, 0x02UL },	/* port 0 */
@@ -73,7 +57,7 @@ static int artop6260_pre_reset(struct at
 	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
-	/* Odd numbered device ids are the units with enable bits (the -R cards) */
+	/* Odd numbered device ids are the units with enable bits. */
 	if ((pdev->device & 1) &&
 	    !pci_test_config_bits(pdev, &artop_enable_bits[ap->port_no]))
 		return -ENOENT;
@@ -317,7 +301,7 @@ static struct ata_port_operations artop6
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= artop6210_set_piomode,
 	.set_dmamode		= artop6210_set_dmamode,
-	.prereset		= artop6210_pre_reset,
+	.prereset		= artop62x0_pre_reset,
 	.qc_defer		= artop6210_qc_defer,
 };
 
@@ -326,7 +310,7 @@ static struct ata_port_operations artop6
 	.cable_detect		= artop6260_cable_detect,
 	.set_piomode		= artop6260_set_piomode,
 	.set_dmamode		= artop6260_set_dmamode,
-	.prereset		= artop6260_pre_reset,
+	.prereset		= artop62x0_pre_reset,
 };
 
 
