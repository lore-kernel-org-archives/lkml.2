Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab2FMQ7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 12:59:14 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:36076 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2FMQ7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 12:59:09 -0400
From: Andrew Armenia <andrew@asquaredlabs.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Armenia <andrew@asquaredlabs.com>
Subject: [PATCH 3/3] i2c-piix4: support AMD auxiliary SMBus controller
Date: Wed, 13 Jun 2012 12:59:09 -0400
Message-Id: <1339606749-4578-4-git-send-email-andrew@asquaredlabs.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339606749-4578-1-git-send-email-andrew@asquaredlabs.com>
References: <20120613094739.360967aa@endymion.delvare>
 <1339606749-4578-1-git-send-email-andrew@asquaredlabs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some AMD chipsets, such as the SP5100, have an auxiliary SMBus
controller with a second set of registers. This patch adds
support for this auxiliary controller.

Tested on ASUS KCMA-D8 motherboard.

Signed-off-by: Andrew Armenia <andrew@asquaredlabs.com>
---
 Documentation/i2c/busses/i2c-piix4 |   13 +++++--
 drivers/i2c/busses/Kconfig         |    6 +++-
 drivers/i2c/busses/i2c-piix4.c     |   69 ++++++++++++++++++++++++++++++++++--
 3 files changed, 82 insertions(+), 6 deletions(-)

diff --git a/Documentation/i2c/busses/i2c-piix4 b/Documentation/i2c/busses/i2c-piix4
index 475bb4a..474779e 100644
--- a/Documentation/i2c/busses/i2c-piix4
+++ b/Documentation/i2c/busses/i2c-piix4
@@ -8,12 +8,17 @@ Supported adapters:
     Datasheet: Only available via NDA from ServerWorks
   * ATI IXP200, IXP300, IXP400, SB600, SB700 and SB800 southbridges
     Datasheet: Not publicly available
+    SB700 register reference available at:
+    http://support.amd.com/us/Embedded_TechDocs/43009_sb7xx_rrg_pub_1.00.pdf
+  * AMD SP5100 (SB700 derivative found on some server mainboards)
+    Datasheet: Publicly available at the AMD website
+    http://support.amd.com/us/Embedded_TechDocs/44413.pdf
   * AMD Hudson-2
     Datasheet: Not publicly available
   * Standard Microsystems (SMSC) SLC90E66 (Victory66) southbridge
     Datasheet: Publicly available at the SMSC website http://www.smsc.com
 
-Authors: 
+Authors:
 	Frodo Looijaard <frodol@dds.nl>
 	Philip Edelbrock <phil@netroedge.com>
 
@@ -32,7 +37,7 @@ Description
 
 The PIIX4 (properly known as the 82371AB) is an Intel chip with a lot of
 functionality. Among other things, it implements the PCI bus. One of its
-minor functions is implementing a System Management Bus. This is a true 
+minor functions is implementing a System Management Bus. This is a true
 SMBus - you can not access it on I2C levels. The good news is that it
 natively understands SMBus commands and you do not have to worry about
 timing problems. The bad news is that non-SMBus devices connected to it can
@@ -68,6 +73,10 @@ this driver on those mainboards.
 The ServerWorks Southbridges, the Intel 440MX, and the Victory66 are
 identical to the PIIX4 in I2C/SMBus support.
 
+The AMD SB700 and SP5100 chipsets implement two PIIX4-compatible SMBus
+controllers. If your BIOS initializes the secondary controller, it will
+be detected by this driver as an "Auxiliary SMBus Host Controller".
+
 If you own Force CPCI735 motherboard or other OSB4 based systems you may need
 to change the SMBus Interrupt Select register so the SMBus controller uses
 the SMI mode.
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 7244c8b..2e7530a 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -133,7 +133,7 @@ config I2C_PIIX4
 	    ATI IXP300
 	    ATI IXP400
 	    ATI SB600
-	    ATI SB700
+	    ATI SB700/SP5100
 	    ATI SB800
 	    AMD Hudson-2
 	    Serverworks OSB4
@@ -143,6 +143,10 @@ config I2C_PIIX4
 	    Serverworks HT-1100
 	    SMSC Victory66
 
+	  Some AMD chipsets contain two PIIX4-compatible SMBus
+	  controllers. This driver will attempt to use both controllers
+	  on the SB700/SP5100, if they have been initialized by the BIOS.
+
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-piix4.
 
diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index 8181963..85d3db9 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -21,11 +21,12 @@
    Supports:
 	Intel PIIX4, 440MX
 	Serverworks OSB4, CSB5, CSB6, HT-1000, HT-1100
-	ATI IXP200, IXP300, IXP400, SB600, SB700, SB800
+	ATI IXP200, IXP300, IXP400, SB600, SB700/SP5100, SB800
 	AMD Hudson-2
 	SMSC Victory66
 
-   Note: we assume there can only be one device, with one SMBus interface.
+   Note: we assume there can only be one device, with one or more
+   SMBus interfaces.
 */
 
 #include <linux/module.h>
@@ -60,6 +61,7 @@
 #define SMBIOSIZE	8
 
 /* PCI Address Constants */
+#define SMBAUXBA	0x058
 #define SMBBA		0x090
 #define SMBHSTCFG	0x0D2
 #define SMBSLVC		0x0D3
@@ -293,6 +295,43 @@ static int __devinit piix4_setup_sb800(struct pci_dev *PIIX4_dev,
 	return piix4_smba;
 }
 
+static int __devinit piix4_setup_aux(struct pci_dev *PIIX4_dev,
+				const struct pci_device_id *id,
+				unsigned short base_reg_addr)
+{
+	/* Set up auxiliary SMBus controllers found on some
+	 * AMD chipsets e.g. SP5100 (SB700 derivative) */
+
+	unsigned short piix4_smba;
+
+	/* Read address of auxiliary SMBus controller */
+	pci_read_config_word(PIIX4_dev, base_reg_addr, &piix4_smba);
+	piix4_smba &= 0xffe0;
+
+	if (piix4_smba == 0) {
+		dev_dbg(&PIIX4_dev->dev,
+			"Auxiliary SMBus base address uninitialized");
+
+		return -ENODEV;
+	}
+
+	if (acpi_check_region(piix4_smba, SMBIOSIZE, piix4_driver.name))
+		return -ENODEV;
+
+	if (!request_region(piix4_smba, SMBIOSIZE, piix4_driver.name)) {
+		dev_err(&PIIX4_dev->dev, "Auxiliary SMBus region 0x%x "
+			"already in use!\n", piix4_smba);
+		return -EBUSY;
+	}
+
+	dev_info(&PIIX4_dev->dev,
+		"Auxiliary SMBus Host Controller at 0x%x\n",
+		piix4_smba
+	);
+
+	return piix4_smba;
+}
+
 static int piix4_transaction(struct i2c_adapter *piix4_adapter)
 {
 	int temp;
@@ -504,6 +543,7 @@ static DEFINE_PCI_DEVICE_TABLE(piix4_ids) = {
 MODULE_DEVICE_TABLE (pci, piix4_ids);
 
 static struct i2c_adapter *piix4_main_adapter;
+static struct i2c_adapter *piix4_aux_adapter;
 
 static int __devinit piix4_add_adapter(struct pci_dev *dev,
 					unsigned short smba,
@@ -565,10 +605,28 @@ static int __devinit piix4_probe(struct pci_dev *dev,
 	else
 		retval = piix4_setup(dev, id);
 
+	/* if no main SMBus found, give up */
 	if (retval < 0)
 		return retval;
 
-	return piix4_add_adapter(dev, retval, &piix4_main_adapter);
+	/* try to register main SMBus adapter, give up if we can't */
+	retval = piix4_add_adapter(dev, retval, &piix4_main_adapter);
+	if (retval < 0)
+		return retval;
+
+	/* check for auxiliary SMBus on some AMD chipsets */
+	if (dev->vendor == PCI_VENDOR_ID_ATI &&
+	    dev->device == PCI_DEVICE_ID_ATI_SBX00_SMBUS &&
+	    dev->revision < 0x40) {
+		retval = piix4_setup_aux(dev, id, SMBAUXBA);
+		if (retval > 0) {
+			/* try to add the aux adapter if it exists,
+			 * piix4_add_adapter will clean up if this fails */
+			piix4_add_adapter(dev, retval, &piix4_aux_adapter);
+		}
+	}
+
+	return 0;
 }
 
 static void __devinit piix4_adap_remove(struct i2c_adapter *adap)
@@ -590,6 +648,11 @@ static void __devexit piix4_remove(struct pci_dev *dev)
 		piix4_adap_remove(piix4_main_adapter);
 		piix4_main_adapter = NULL;
 	}
+
+	if (piix4_aux_adapter) {
+		piix4_adap_remove(piix4_aux_adapter);
+		piix4_aux_adapter = NULL;
+	}
 }
 
 static struct pci_driver piix4_driver = {
-- 
1.7.10

