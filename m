Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab1JMLSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 07:18:54 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39208 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1JMLRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 07:17:07 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] pata_pdc2027x: add Power Management support
Date: Thu, 13 Oct 2011 12:57:51 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201110131257.51837.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_pdc2027x: add Power Management support

Fixes IDE -> libata regression.

There shouldn't be any problems with it as corresponding IDE's host
driver (pdc202xx_new) has been supporting PCI Power Management since
Oct 10 2008 (commit feb22b7f "ide: add proper PCI PM support (v2)")
and IDE PM since Jun 14 2003 (patch v2.5.73 "ide: Power Management").

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2009/11/25/369

 drivers/ata/pata_pdc2027x.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

Index: b/drivers/ata/pata_pdc2027x.c
===================================================================
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -63,6 +63,7 @@ enum {
 };
 
 static int pdc2027x_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
+static int pdc2027x_reinit_one(struct pci_dev *pdev);
 static int pdc2027x_prereset(struct ata_link *link, unsigned long deadline);
 static void pdc2027x_set_piomode(struct ata_port *ap, struct ata_device *adev);
 static void pdc2027x_set_dmamode(struct ata_port *ap, struct ata_device *adev);
@@ -126,6 +127,10 @@ static struct pci_driver pdc2027x_pci_dr
 	.id_table		= pdc2027x_pci_tbl,
 	.probe			= pdc2027x_init_one,
 	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend		= ata_pci_device_suspend,
+	.resume			= pdc2027x_reinit_one,
+#endif
 };
 
 static struct scsi_host_template pdc2027x_sht = {
@@ -758,6 +763,31 @@ static int __devinit pdc2027x_init_one(s
 				 IRQF_SHARED, &pdc2027x_sht);
 }
 
+#ifdef CONFIG_PM
+static int pdc2027x_reinit_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	unsigned int board_idx;
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	if (pdev->device == PCI_DEVICE_ID_PROMISE_20268 ||
+	    pdev->device == PCI_DEVICE_ID_PROMISE_20270)
+		board_idx = PDC_UDMA_100;
+	else
+		board_idx = PDC_UDMA_133;
+
+	if (pdc_hardware_init(host, board_idx))
+		return -EIO;
+
+	ata_host_resume(host);
+	return 0;
+}
+#endif
+
 /**
  * pdc2027x_init - Called after this module is loaded into the kernel.
  */
