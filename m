Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1CPVMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:12:38 -0400
Received: from kroah.org ([198.145.64.141]:42575 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822Ab1CPVLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:40 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/50] pch_phub: add new device ML7213
Date: Wed, 16 Mar 2011 14:10:49 -0700
Message-Id: <1300309888-5028-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Add ML7213 device information.
ML7213 is companion chip of Intel Atom E6xx series for IVI(In-Vehicle Infotainment).
ML7213 is completely compatible for Intel EG20T PCH.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/Kconfig    |    7 ++++-
 drivers/misc/pch_phub.c |   69 ++++++++++++++++++++++++++++++++---------------
 2 files changed, 53 insertions(+), 23 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index cc8e49d..b7d5ef2 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -441,7 +441,7 @@ config BMP085
 	  module will be called bmp085.
 
 config PCH_PHUB
-	tristate "PCH Packet Hub of Intel Topcliff"
+	tristate "PCH Packet Hub of Intel Topcliff / OKI SEMICONDUCTOR ML7213"
 	depends on PCI
 	help
 	  This driver is for PCH(Platform controller Hub) PHUB(Packet Hub) of
@@ -449,6 +449,11 @@ config PCH_PHUB
 	  processor. The Topcliff has MAC address and Option ROM data in SROM.
 	  This driver can access MAC address and Option ROM data in SROM.
 
+	  This driver also can be used for OKI SEMICONDUCTOR's ML7213 which is
+	  for IVI(In-Vehicle Infotainment) use.
+	  ML7213 is companion chip for Intel Atom E6xx series.
+	  ML7213 is completely compatible for Intel EG20T PCH.
+
 	  To compile this driver as a module, choose M here: the module will
 	  be called pch_phub.
 
diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 744b804..98bffc4 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
+ * Copyright (C) 2010 OKI SEMICONDUCTOR CO., LTD.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -33,7 +33,12 @@
 #define PHUB_TIMEOUT 0x05		/* Time out value for Status Register */
 #define PCH_PHUB_ROM_WRITE_ENABLE 0x01	/* Enabling for writing ROM */
 #define PCH_PHUB_ROM_WRITE_DISABLE 0x00	/* Disabling for writing ROM */
-#define PCH_PHUB_ROM_START_ADDR 0x14	/* ROM data area start address offset */
+#define PCH_PHUB_MAC_START_ADDR 0x20C  /* MAC data area start address offset */
+#define PCH_PHUB_ROM_START_ADDR_EG20T 0x14 /* ROM data area start address offset
+					      (Intel EG20T PCH)*/
+#define PCH_PHUB_ROM_START_ADDR_ML7213 0x400 /* ROM data area start address
+						offset(OKI SEMICONDUCTOR ML7213)
+					      */
 
 /* MAX number of INT_REDUCE_CONTROL registers */
 #define MAX_NUM_INT_REDUCE_CONTROL_REG 128
@@ -42,6 +47,10 @@
 #define CLKCFG_CAN_50MHZ 0x12000000
 #define CLKCFG_CANCLK_MASK 0xFF000000
 
+/* Macros for ML7213 */
+#define PCI_VENDOR_ID_ROHM			0x10db
+#define PCI_DEVICE_ID_ROHM_ML7213_PHUB		0x801A
+
 /* SROM ACCESS Macro */
 #define PCH_WORD_ADDR_MASK (~((1 << 2) - 1))
 
@@ -298,7 +307,7 @@ static void pch_phub_read_serial_rom_val(struct pch_phub_reg *chip,
 {
 	unsigned int mem_addr;
 
-	mem_addr = PCH_PHUB_ROM_START_ADDR +
+	mem_addr = PCH_PHUB_ROM_START_ADDR_EG20T +
 			pch_phub_mac_offset[offset_address];
 
 	pch_phub_read_serial_rom(chip, mem_addr, data);
@@ -315,7 +324,7 @@ static int pch_phub_write_serial_rom_val(struct pch_phub_reg *chip,
 	int retval;
 	unsigned int mem_addr;
 
-	mem_addr = PCH_PHUB_ROM_START_ADDR +
+	mem_addr = PCH_PHUB_ROM_START_ADDR_EG20T +
 			pch_phub_mac_offset[offset_address];
 
 	retval = pch_phub_write_serial_rom(chip, mem_addr, data);
@@ -594,23 +603,38 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 		"pch_phub_extrom_base_address variable is %p\n", __func__,
 		chip->pch_phub_extrom_base_address);
 
-	pci_set_drvdata(pdev, chip);
-
-	retval = sysfs_create_file(&pdev->dev.kobj, &dev_attr_pch_mac.attr);
-	if (retval)
-		goto err_sysfs_create;
-
-	retval = sysfs_create_bin_file(&pdev->dev.kobj, &pch_bin_attr);
-	if (retval)
-		goto exit_bin_attr;
-
-	pch_phub_read_modify_write_reg(chip, (unsigned int)CLKCFG_REG_OFFSET,
-					CLKCFG_CAN_50MHZ, CLKCFG_CANCLK_MASK);
+	if (id->driver_data == 1) {
+		retval = sysfs_create_file(&pdev->dev.kobj,
+					   &dev_attr_pch_mac.attr);
+		if (retval)
+			goto err_sysfs_create;
 
-	/* set the prefech value */
-	iowrite32(0x000affaa, chip->pch_phub_base_address + 0x14);
-	/* set the interrupt delay value */
-	iowrite32(0x25, chip->pch_phub_base_address + 0x44);
+		retval = sysfs_create_bin_file(&pdev->dev.kobj, &pch_bin_attr);
+		if (retval)
+			goto exit_bin_attr;
+
+		pch_phub_read_modify_write_reg(chip,
+					       (unsigned int)CLKCFG_REG_OFFSET,
+					       CLKCFG_CAN_50MHZ,
+					       CLKCFG_CANCLK_MASK);
+
+		/* set the prefech value */
+		iowrite32(0x000affaa, chip->pch_phub_base_address + 0x14);
+		/* set the interrupt delay value */
+		iowrite32(0x25, chip->pch_phub_base_address + 0x44);
+	} else if (id->driver_data == 2) {
+		retval = sysfs_create_bin_file(&pdev->dev.kobj, &pch_bin_attr);
+		if (retval)
+			goto err_sysfs_create;
+		/* set the prefech value
+		 * Device2(USB OHCI #1/ USB EHCI #1/ USB Device):a
+		 * Device4(SDIO #0,1,2):f
+		 * Device6(SATA 2):f
+		 * Device8(USB OHCI #0/ USB EHCI #0):a
+		 */
+		iowrite32(0x000affa0, chip->pch_phub_base_address + 0x14);
+	}
+	pci_set_drvdata(pdev, chip);
 
 	return 0;
 exit_bin_attr:
@@ -687,8 +711,9 @@ static int pch_phub_resume(struct pci_dev *pdev)
 #endif /* CONFIG_PM */
 
 static struct pci_device_id pch_phub_pcidev_id[] = {
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_PCH1_PHUB)},
-	{0,}
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_PCH1_PHUB),       1,  },
+	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ROHM_ML7213_PHUB), 2,  },
+	{ }
 };
 
 static struct pci_driver pch_phub_driver = {
-- 
1.7.4.1

