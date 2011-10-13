Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab1JMLR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 07:17:28 -0400
Received: from mail-dy0-f46.google.com ([209.85.220.46]:63132 "EHLO
	mail-dy0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab1JMLRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 07:17:23 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] pata_sl82c105: add Power Management support
Date: Thu, 13 Oct 2011 13:16:24 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201110131316.24409.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_sl82c105: add Power Management support

Fixes IDE -> libata regression.

There shouldn't be any problems with it as corresponding IDE's host
driver (sl82c105) has been supporting PCI Power Management since
Oct 10 2008 (commit feb22b7f "ide: add proper PCI PM support (v2)")
and IDE PM since Jun 14 2003 (patch v2.5.73 "ide: Power Management").

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2009/11/25/385

 drivers/ata/pata_sl82c105.c |   37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

Index: b/drivers/ata/pata_sl82c105.c
===================================================================
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -1,6 +1,7 @@
 /*
  * pata_sl82c105.c 	- SL82C105 PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
+ *			  (C) 2011 Bartlomiej Zolnierkiewicz
  *
  * Based in part on linux/drivers/ide/pci/sl82c105.c
  * 		SL82C105/Winbond 553 IDE driver
@@ -278,6 +279,14 @@ static int sl82c105_bridge_revision(stru
 	return bridge->revision;
 }
 
+static void sl82c105_fixup(struct pci_dev *pdev)
+{
+	u32 val;
+
+	pci_read_config_dword(pdev, 0x40, &val);
+	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
+	pci_write_config_dword(pdev, 0x40, val);
+}
 
 static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
@@ -295,7 +304,6 @@ static int sl82c105_init_one(struct pci_
 	/* for now use only the first port */
 	const struct ata_port_info *ppi[] = { &info_early,
 					       NULL };
-	u32 val;
 	int rev;
 	int rc;
 
@@ -312,13 +320,28 @@ static int sl82c105_init_one(struct pci_
 	else
 		ppi[0] = &info_dma;
 
-	pci_read_config_dword(dev, 0x40, &val);
-	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
-	pci_write_config_dword(dev, 0x40, val);
+	sl82c105_fixup(dev);
 
 	return ata_pci_bmdma_init_one(dev, ppi, &sl82c105_sht, NULL, 0);
 }
 
+#ifdef CONFIG_PM
+static int sl82c105_reinit_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	sl82c105_fixup(pdev);
+
+	ata_host_resume(host);
+	return 0;
+}
+#endif
+
 static const struct pci_device_id sl82c105[] = {
 	{ PCI_VDEVICE(WINBOND, PCI_DEVICE_ID_WINBOND_82C105), },
 
@@ -329,7 +352,11 @@ static struct pci_driver sl82c105_pci_dr
 	.name 		= DRV_NAME,
 	.id_table	= sl82c105,
 	.probe 		= sl82c105_init_one,
-	.remove		= ata_pci_remove_one
+	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend	= ata_pci_device_suspend,
+	.resume		= sl82c105_reinit_one,
+#endif
 };
 
 static int __init sl82c105_init(void)
