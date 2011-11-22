Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab1KVBLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:11:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab1KVBLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:11:07 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        stable <stable@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/7] pch_phub: Support new device LAPIS Semiconductor ML7831 IOH
Date: Mon, 21 Nov 2011 17:10:30 -0800
Message-Id: <1321924234-26258-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1321924234-26258-1-git-send-email-gregkh@suse.de>
References: <20111122005836.GA25420@kroah.com>
 <1321924234-26258-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>

ML7831 is companion chip for Intel Atom E6xx series.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/Kconfig    |   15 ++++++++-------
 drivers/misc/pch_phub.c |   20 ++++++++++++++++++++
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index d593878..5664696 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -472,7 +472,7 @@ config BMP085
 	  module will be called bmp085.
 
 config PCH_PHUB
-	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR IOH(ML7213/ML7223) PHUB"
+	tristate "Intel EG20T PCH/LAPIS Semicon IOH(ML7213/ML7223/ML7831) PHUB"
 	depends on PCI
 	help
 	  This driver is for PCH(Platform controller Hub) PHUB(Packet Hub) of
@@ -480,12 +480,13 @@ config PCH_PHUB
 	  processor. The Topcliff has MAC address and Option ROM data in SROM.
 	  This driver can access MAC address and Option ROM data in SROM.
 
-	  This driver also can be used for OKI SEMICONDUCTOR IOH(Input/
-	  Output Hub), ML7213 and ML7223.
-	  ML7213 IOH is for IVI(In-Vehicle Infotainment) use and ML7223 IOH is
-	  for MP(Media Phone) use.
-	  ML7213/ML7223 is companion chip for Intel Atom E6xx series.
-	  ML7213/ML7223 is completely compatible for Intel EG20T PCH.
+	  This driver also can be used for LAPIS Semiconductor's IOH,
+	  ML7213/ML7223/ML7831.
+	  ML7213 which is for IVI(In-Vehicle Infotainment) use.
+	  ML7223 IOH is for MP(Media Phone) use.
+	  ML7831 IOH is for general purpose use.
+	  ML7213/ML7223/ML7831 is companion chip for Intel Atom E6xx series.
+	  ML7213/ML7223/ML7831 is completely compatible for Intel EG20T PCH.
 
 	  To compile this driver as a module, choose M here: the module will
 	  be called pch_phub.
diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index dee33ad..b50f48a 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -73,6 +73,9 @@
 #define PCI_DEVICE_ID_ROHM_ML7223_mPHUB	0x8012 /* for Bus-m */
 #define PCI_DEVICE_ID_ROHM_ML7223_nPHUB	0x8002 /* for Bus-n */
 
+/* Macros for ML7831 */
+#define PCI_DEVICE_ID_ROHM_ML7831_PHUB 0x8801
+
 /* SROM ACCESS Macro */
 #define PCH_WORD_ADDR_MASK (~((1 << 2) - 1))
 
@@ -763,6 +766,22 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 		chip->pch_opt_rom_start_address =\
 						 PCH_PHUB_ROM_START_ADDR_ML7223;
 		chip->pch_mac_start_address = PCH_PHUB_MAC_START_ADDR_ML7223;
+	} else if (id->driver_data == 5) { /* ML7831 */
+		retval = sysfs_create_file(&pdev->dev.kobj,
+					   &dev_attr_pch_mac.attr);
+		if (retval)
+			goto err_sysfs_create;
+
+		retval = sysfs_create_bin_file(&pdev->dev.kobj, &pch_bin_attr);
+		if (retval)
+			goto exit_bin_attr;
+
+		/* set the prefech value */
+		iowrite32(0x000affaa, chip->pch_phub_base_address + 0x14);
+		/* set the interrupt delay value */
+		iowrite32(0x25, chip->pch_phub_base_address + 0x44);
+		chip->pch_opt_rom_start_address = PCH_PHUB_ROM_START_ADDR_EG20T;
+		chip->pch_mac_start_address = PCH_PHUB_MAC_START_ADDR_EG20T;
 	}
 
 	chip->ioh_type = id->driver_data;
@@ -847,6 +866,7 @@ static struct pci_device_id pch_phub_pcidev_id[] = {
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ROHM_ML7213_PHUB), 2,  },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ROHM_ML7223_mPHUB), 3,  },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ROHM_ML7223_nPHUB), 4,  },
+	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ROHM_ML7831_PHUB), 5,  },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, pch_phub_pcidev_id);
-- 
1.7.7.3

