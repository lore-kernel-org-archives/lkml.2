Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1JWGEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:04:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61130 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab1JWGEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:04:47 -0400
From: Paul Schilling <paul.s.schilling@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>, "David S. Miller" <davem@davemloft.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: Paul Schilling <Paul.S.Schilling@gmail.com>,
        Paul Schilling <paul.s.schilling@gmail.com>
Subject: [PATCH 02/15] ATA : vortex86 : fix vortex86dx/sx hardware CRC bug.
Date: Sun, 23 Oct 2011 00:05:00 -0500
Message-Id: <1319346300-18151-1-git-send-email-paul.s.schilling@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <fix vortex86>
References: <fix vortex86>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a DMA issue related to a CRC bug on
the RDC pata peripherial found on the vortex86sx and vortex86dx.

Signed-off-by: Paul Schilling <paul.s.schilling@gmail.com>
---
 drivers/ata/pata_it821x.c |   22 ++++++++++++++++++----
 drivers/ata/pata_rdc.c    |   29 ++++++++++++++++++++++++-----
 drivers/ide/it821x.c      |    9 +++++++--
 include/linux/pci_ids.h   |    2 ++
 4 files changed, 51 insertions(+), 11 deletions(-)

diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index c5532b9..5f8a54a 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -897,7 +897,16 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	static const struct ata_port_info info_rdc_11 = {
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = ATA_PIO4,
-		.mwdma_mask = ATA_MWDMA2,
+		.mwdma_mask = 0,
+		.udma_mask = 0,
+		/* No UDMA */
+		.port_ops = &it821x_rdc_port_ops
+	};
+	static const struct ata_port_info info_rdc_01 = {
+		.flags = ATA_FLAG_SLAVE_POSS,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = 0,
+		.udma_mask = 0,
 		/* No UDMA */
 		.port_ops = &it821x_rdc_port_ops
 	};
@@ -911,11 +920,16 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		return rc;
 
 	if (pdev->vendor == PCI_VENDOR_ID_RDC) {
-		/* Deal with Vortex86SX */
-		if (pdev->revision == 0x11)
+		if (((pdev->revision == 0x11) || (pdev->revision == 0x13)) &&
+		    (pdev->device == PCI_DEVICE_ID_RDC_D1010)) {
+			/* Deal with Vortex86SX */
 			ppi[0] = &info_rdc_11;
-		else
+			printk(KERN_INFO DRV_NAME
+			       ": Detected Vortex86SX/DX Bug.\n");
+			printk(KERN_INFO DRV_NAME ": Disabling UDMA.\n");
+		} else {
 			ppi[0] = &info_rdc;
+		}
 	} else {
 		/* Force the card into bypass mode if so requested */
 		if (it8212_noraid) {
diff --git a/drivers/ata/pata_rdc.c b/drivers/ata/pata_rdc.c
index 2b38127..441521c 100644
--- a/drivers/ata/pata_rdc.c
+++ b/drivers/ata/pata_rdc.c
@@ -290,6 +290,16 @@ static struct ata_port_info rdc_port_info = {
 	.port_ops	= &rdc_pata_ops,
 };
 
+static struct ata_port_info vortex_port_info = {
+	.flags = ATA_FLAG_SLAVE_POSS,
+	.pio_mask = ATA_PIO4,
+	.mwdma_mask = 0,
+	.udma_mask = 0,
+	/* No UDMA */
+	.port_ops	= &rdc_pata_ops,
+};
+
+
 static struct scsi_host_template rdc_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
@@ -322,16 +332,25 @@ static int __devinit rdc_init_one(struct pci_dev *pdev,
 
 	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
-	port_info[0] = rdc_port_info;
-	port_info[1] = rdc_port_info;
-
-	port_flags = port_info[0].flags;
-
 	/* enable device and prepare host */
 	rc = pcim_enable_device(pdev);
 	if (rc)
 		return rc;
 
+	if ((pdev->revision == 0x01) &&
+			(pdev->device ==  PCI_DEVICE_ID_RDC_D1011)) {
+		/* Deal with Vortex86DX */
+		port_info[0] = vortex_port_info;
+		port_info[1] = vortex_port_info;
+		printk(KERN_INFO DRV_NAME ": Detected Vortex86DX Bug.\n");
+		printk(KERN_INFO DRV_NAME ": Disabling UDMA.\n");
+	} else {
+		port_info[0] = rdc_port_info;
+		port_info[1] = rdc_port_info;
+	}
+
+	port_flags = port_info[0].flags;
+
 	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
 	if (!hpriv)
 		return -ENOMEM;
diff --git a/drivers/ide/it821x.c b/drivers/ide/it821x.c
index 2e3169f..82c6bc7 100644
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -581,10 +581,14 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 	hwif->ultra_mask = ATA_UDMA6;
 	hwif->mwdma_mask = ATA_MWDMA2;
 
-	/* Vortex86SX quirk: prevent Ultra-DMA mode to fix BadCRC issue */
+	/* Vortex86SX and Vortex86DX quirk: prevent
+	 * Ultra-DMA mode to fix BadCRC issue when
+	 * using DMA mode */
 	if (idev->quirks & QUIRK_VORTEX86) {
-		if (dev->revision == 0x11)
+		if (((dev->revision == 0x11) || (dev->revision == 0x13))
+				|| (dev->revision == 0x01)) {
 			hwif->ultra_mask = 0;
+		}
 	}
 }
 
@@ -680,6 +684,7 @@ static const struct pci_device_id it821x_pci_tbl[] = {
 	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8211), 0 },
 	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8212), 0 },
 	{ PCI_VDEVICE(RDC, PCI_DEVICE_ID_RDC_D1010), QUIRK_VORTEX86 },
+	{ PCI_VDEVICE(RDC, PCI_DEVICE_ID_RDC_D1011), QUIRK_VORTEX86 },
 	{ 0, },
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index ae96bbe..237da92 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2259,6 +2259,8 @@
 #define PCI_DEVICE_ID_RDC_R6060		0x6060
 #define PCI_DEVICE_ID_RDC_R6061		0x6061
 #define PCI_DEVICE_ID_RDC_D1010		0x1010
+#define PCI_DEVICE_ID_RDC_D1011		0x1011
+#define PCI_DEVICE_ID_RDC_D1012		0x1012
 
 #define PCI_VENDOR_ID_LENOVO		0x17aa
 
-- 
1.7.6.4

