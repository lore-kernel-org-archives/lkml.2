Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab1JKSZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:25:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65369 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab1JKSZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:25:30 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 1/3] pata_cmd64x: add cmd64x_fixup()
Date: Tue, 11 Oct 2011 19:56:03 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201110111956.03480.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cmd64x: add cmd64x_fixup()

Factor out common code from cmd64x_[re]init_one() to cmd64x_fixup().

Remove stale comment and fix a minor CodingStyle issue while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2009/11/25/355

 drivers/ata/pata_cmd64x.c |   42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

Index: b/drivers/ata/pata_cmd64x.c
===================================================================
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -288,6 +288,22 @@ static struct ata_port_operations cmd648
 	.cable_detect	= cmd648_cable_detect,
 };
 
+static void cmd64x_fixup(struct pci_dev *pdev)
+{
+	u8 mrdmode;
+
+	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
+	pci_read_config_byte(pdev, MRDMODE, &mrdmode);
+	mrdmode &= ~0x30;	/* IRQ set up */
+	mrdmode |= 0x02;	/* Memory read line enable */
+	pci_write_config_byte(pdev, MRDMODE, mrdmode);
+
+	/* PPC specific fixup copied from old driver */
+#ifdef CONFIG_PPC
+	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
+#endif
+}
+
 static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info cmd_info[6] = {
@@ -336,7 +352,7 @@ static int cmd64x_init_one(struct pci_de
 		&cmd_info[id->driver_data],
 		NULL
 	};
-	u8 mrdmode, reg;
+	u8 reg;
 	int rc;
 	struct pci_dev *bridge = pdev->bus->self;
 	/* mobility split bridges don't report enabled ports correctly */
@@ -368,11 +384,7 @@ static int cmd64x_init_one(struct pci_de
 			cntrl_ch0_ok = 0;
 	}
 
-	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
-	pci_read_config_byte(pdev, MRDMODE, &mrdmode);
-	mrdmode &= ~ 0x30;	/* IRQ set up */
-	mrdmode |= 0x02;	/* Memory read line enable */
-	pci_write_config_byte(pdev, MRDMODE, mrdmode);
+	cmd64x_fixup(pdev);
 
 	/* check for enabled ports */
 	pci_read_config_byte(pdev, CNTRL, &reg);
@@ -388,13 +400,6 @@ static int cmd64x_init_one(struct pci_de
 		ppi[1] = &ata_dummy_port_info;
 	}
 
-	/* Force PIO 0 here.. */
-
-	/* PPC specific fixup copied from old driver */
-#ifdef CONFIG_PPC
-	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
-#endif
-
 	return ata_pci_bmdma_init_one(pdev, ppi, &cmd64x_sht, NULL, 0);
 }
 
@@ -402,21 +407,14 @@ static int cmd64x_init_one(struct pci_de
 static int cmd64x_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	u8 mrdmode;
 	int rc;
 
 	rc = ata_pci_device_do_resume(pdev);
 	if (rc)
 		return rc;
 
-	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
-	pci_read_config_byte(pdev, MRDMODE, &mrdmode);
-	mrdmode &= ~ 0x30;	/* IRQ set up */
-	mrdmode |= 0x02;	/* Memory read line enable */
-	pci_write_config_byte(pdev, MRDMODE, mrdmode);
-#ifdef CONFIG_PPC
-	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
-#endif
+	cmd64x_fixup(pdev);
+
 	ata_host_resume(host);
 	return 0;
 }
