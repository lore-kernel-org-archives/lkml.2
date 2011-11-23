Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285Ab1KWAwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:52:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42803 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759204Ab1KWAkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:40:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:06 2011
Message-Id: <20111123002406.111025328@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [16/53] pch_phub: Support new device LAPIS Semiconductor ML7831 IOH
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>

commit 584ad00ce4bfe594e4c4a89944b3c635187a1ca1 upstream.

ML7831 is companion chip for Intel Atom E6xx series.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/Kconfig    |   15 ++++++++-------
 drivers/misc/pch_phub.c |   20 ++++++++++++++++++++
 2 files changed, 28 insertions(+), 7 deletions(-)

--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -471,7 +471,7 @@ config BMP085
 	  module will be called bmp085.
 
 config PCH_PHUB
-	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR IOH(ML7213/ML7223) PHUB"
+	tristate "Intel EG20T PCH/LAPIS Semicon IOH(ML7213/ML7223/ML7831) PHUB"
 	depends on PCI
 	help
 	  This driver is for PCH(Platform controller Hub) PHUB(Packet Hub) of
@@ -479,12 +479,13 @@ config PCH_PHUB
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
 
@@ -754,6 +757,22 @@ static int __devinit pch_phub_probe(stru
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
@@ -838,6 +857,7 @@ static struct pci_device_id pch_phub_pci
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ROHM_ML7213_PHUB), 2,  },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ROHM_ML7223_mPHUB), 3,  },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ROHM_ML7223_nPHUB), 4,  },
+	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ROHM_ML7831_PHUB), 5,  },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, pch_phub_pcidev_id);


