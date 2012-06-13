Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2FMQ7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 12:59:41 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63824 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab2FMQ7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 12:59:06 -0400
From: Andrew Armenia <andrew@asquaredlabs.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Armenia <andrew@asquaredlabs.com>
Subject: [PATCH 2/3] i2c-piix4: separate registration and probing code
Date: Wed, 13 Jun 2012 12:59:08 -0400
Message-Id: <1339606749-4578-3-git-send-email-andrew@asquaredlabs.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339606749-4578-1-git-send-email-andrew@asquaredlabs.com>
References: <20120613094739.360967aa@endymion.delvare>
 <1339606749-4578-1-git-send-email-andrew@asquaredlabs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some chipsets have multiple sets of SMBus registers each controlling a
separate SMBus. Supporting these chipsets properly will require registering
multiple I2C adapters for one piix4.

The code to initialize and register the i2c_adapter structure has been
separated from piix4_probe and allows registration of a piix4 adapter
given its base address. Note that the i2c_adapter and i2c_piix4_adapdata
structures are now dynamically allocated.

Signed-off-by: Andrew Armenia <andrew@asquaredlabs.com>
---
 drivers/i2c/busses/i2c-piix4.c |  113 ++++++++++++++++++++++++++--------------
 1 file changed, 73 insertions(+), 40 deletions(-)

diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index 61a85c9..8181963 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -96,7 +96,6 @@ MODULE_PARM_DESC(force_addr,
 
 static int srvrworks_csb5_delay;
 static struct pci_driver piix4_driver;
-static struct i2c_adapter piix4_adapter;
 
 static struct dmi_system_id __devinitdata piix4_dmi_blacklist[] = {
 	{
@@ -294,27 +293,33 @@ static int __devinit piix4_setup_sb800(struct pci_dev *PIIX4_dev,
 	return piix4_smba;
 }
 
-static int piix4_transaction(unsigned short piix4_smba)
+static int piix4_transaction(struct i2c_adapter *piix4_adapter)
 {
 	int temp;
 	int result = 0;
 	int timeout = 0;
 
-	dev_dbg(&piix4_adapter.dev, "Transaction (pre): CNT=%02x, CMD=%02x, "
+	struct i2c_piix4_adapdata *adapdata;
+	unsigned short piix4_smba;
+
+	adapdata = i2c_get_adapdata(piix4_adapter);
+	piix4_smba = adapdata->smba;
+
+	dev_dbg(&piix4_adapter->dev, "Transaction (pre): CNT=%02x, CMD=%02x, "
 		"ADD=%02x, DAT0=%02x, DAT1=%02x\n", inb_p(SMBHSTCNT),
 		inb_p(SMBHSTCMD), inb_p(SMBHSTADD), inb_p(SMBHSTDAT0),
 		inb_p(SMBHSTDAT1));
 
 	/* Make sure the SMBus host is ready to start transmitting */
 	if ((temp = inb_p(SMBHSTSTS)) != 0x00) {
-		dev_dbg(&piix4_adapter.dev, "SMBus busy (%02x). "
+		dev_dbg(&piix4_adapter->dev, "SMBus busy (%02x). "
 			"Resetting...\n", temp);
 		outb_p(temp, SMBHSTSTS);
 		if ((temp = inb_p(SMBHSTSTS)) != 0x00) {
-			dev_err(&piix4_adapter.dev, "Failed! (%02x)\n", temp);
+			dev_err(&piix4_adapter->dev, "Failed! (%02x)\n", temp);
 			return -EBUSY;
 		} else {
-			dev_dbg(&piix4_adapter.dev, "Successful!\n");
+			dev_dbg(&piix4_adapter->dev, "Successful!\n");
 		}
 	}
 
@@ -333,35 +338,35 @@ static int piix4_transaction(unsigned short piix4_smba)
 
 	/* If the SMBus is still busy, we give up */
 	if (timeout == MAX_TIMEOUT) {
-		dev_err(&piix4_adapter.dev, "SMBus Timeout!\n");
+		dev_err(&piix4_adapter->dev, "SMBus Timeout!\n");
 		result = -ETIMEDOUT;
 	}
 
 	if (temp & 0x10) {
 		result = -EIO;
-		dev_err(&piix4_adapter.dev, "Error: Failed bus transaction\n");
+		dev_err(&piix4_adapter->dev, "Error: Failed bus transaction\n");
 	}
 
 	if (temp & 0x08) {
 		result = -EIO;
-		dev_dbg(&piix4_adapter.dev, "Bus collision! SMBus may be "
+		dev_dbg(&piix4_adapter->dev, "Bus collision! SMBus may be "
 			"locked until next hard reset. (sorry!)\n");
 		/* Clock stops and slave is stuck in mid-transmission */
 	}
 
 	if (temp & 0x04) {
 		result = -ENXIO;
-		dev_dbg(&piix4_adapter.dev, "Error: no response!\n");
+		dev_dbg(&piix4_adapter->dev, "Error: no response!\n");
 	}
 
 	if (inb_p(SMBHSTSTS) != 0x00)
 		outb_p(inb(SMBHSTSTS), SMBHSTSTS);
 
 	if ((temp = inb_p(SMBHSTSTS)) != 0x00) {
-		dev_err(&piix4_adapter.dev, "Failed reset at end of "
+		dev_err(&piix4_adapter->dev, "Failed reset at end of "
 			"transaction (%02x)\n", temp);
 	}
-	dev_dbg(&piix4_adapter.dev, "Transaction (post): CNT=%02x, CMD=%02x, "
+	dev_dbg(&piix4_adapter->dev, "Transaction (post): CNT=%02x, CMD=%02x, "
 		"ADD=%02x, DAT0=%02x, DAT1=%02x\n", inb_p(SMBHSTCNT),
 		inb_p(SMBHSTCMD), inb_p(SMBHSTADD), inb_p(SMBHSTDAT0),
 		inb_p(SMBHSTDAT1));
@@ -434,7 +439,7 @@ static s32 piix4_access(struct i2c_adapter * adap, u16 addr,
 
 	outb_p((size & 0x1C) + (ENABLE_INT9 & 1), SMBHSTCNT);
 
-	status = piix4_transaction(piix4_smba);
+	status = piix4_transaction(adap);
 	if (status)
 		return status;
 
@@ -474,14 +479,6 @@ static const struct i2c_algorithm smbus_algorithm = {
 	.functionality	= piix4_func,
 };
 
-static struct i2c_adapter piix4_adapter = {
-	.owner		= THIS_MODULE,
-	.class		= I2C_CLASS_HWMON | I2C_CLASS_SPD,
-	.algo		= &smbus_algorithm,
-};
-
-static struct i2c_piix4_adapdata piix4_adapter_data;
-
 static DEFINE_PCI_DEVICE_TABLE(piix4_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371AB_3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443MX_3) },
@@ -506,6 +503,54 @@ static DEFINE_PCI_DEVICE_TABLE(piix4_ids) = {
 
 MODULE_DEVICE_TABLE (pci, piix4_ids);
 
+static struct i2c_adapter *piix4_main_adapter;
+
+static int __devinit piix4_add_adapter(struct pci_dev *dev,
+					unsigned short smba,
+					struct i2c_adapter **padap)
+{
+	struct i2c_adapter *adap;
+	struct i2c_piix4_adapdata *adapdata;
+
+	int retval;
+
+	adap = kzalloc(sizeof(*adap), GFP_KERNEL);
+	if (NULL == adap)
+		return -ENOMEM;
+
+	adap->owner = THIS_MODULE;
+	adap->class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
+	adap->algo = &smbus_algorithm;
+
+	adapdata = kzalloc(sizeof(*adapdata), GFP_KERNEL);
+	if (NULL == adapdata) {
+		kfree(adap);
+		return -ENOMEM;
+	}
+
+	adapdata->smba = smba;
+
+	/* set up the sysfs linkage to our parent device */
+	adap->dev.parent = &dev->dev;
+
+	snprintf(adap->name, sizeof(adap->name),
+		"SMBus PIIX4 adapter at %04x", smba);
+
+	i2c_set_adapdata(adap, adapdata);
+
+	retval = i2c_add_adapter(adap);
+	if (retval) {
+		dev_err(&dev->dev, "Couldn't register adapter!\n");
+		release_region(smba, SMBIOSIZE);
+		kfree(adapdata);
+		kfree(adap);
+		return retval;
+	}
+
+	*padap = adap;
+	return 0;
+}
+
 static int __devinit piix4_probe(struct pci_dev *dev,
 				const struct pci_device_id *id)
 {
@@ -523,23 +568,7 @@ static int __devinit piix4_probe(struct pci_dev *dev,
 	if (retval < 0)
 		return retval;
 
-	/* set up the sysfs linkage to our parent device */
-	piix4_adapter.dev.parent = &dev->dev;
-
-	piix4_adapter_data.smba = retval;
-
-	snprintf(piix4_adapter.name, sizeof(piix4_adapter.name),
-		"SMBus PIIX4 adapter at %04x", piix4_adapter_data.smba);
-
-	i2c_set_adapdata(&piix4_adapter, &piix4_adapter_data);
-
-	if ((retval = i2c_add_adapter(&piix4_adapter))) {
-		dev_err(&dev->dev, "Couldn't register adapter!\n");
-		release_region(piix4_adapter_data.smba, SMBIOSIZE);
-		piix4_adapter_data.smba = 0;
-	}
-
-	return retval;
+	return piix4_add_adapter(dev, retval, &piix4_main_adapter);
 }
 
 static void __devinit piix4_adap_remove(struct i2c_adapter *adap)
@@ -550,13 +579,17 @@ static void __devinit piix4_adap_remove(struct i2c_adapter *adap)
 	if (adapdata->smba) {
 		i2c_del_adapter(adap);
 		release_region(adapdata->smba, SMBIOSIZE);
-		adapdata->smba = 0;
+		kfree(adapdata);
+		kfree(adap);
 	}
 }
 
 static void __devexit piix4_remove(struct pci_dev *dev)
 {
-	piix4_adap_remove(&piix4_adapter);
+	if (piix4_main_adapter) {
+		piix4_adap_remove(piix4_main_adapter);
+		piix4_main_adapter = NULL;
+	}
 }
 
 static struct pci_driver piix4_driver = {
-- 
1.7.10

