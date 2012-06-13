Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab2FMQ7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 12:59:09 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:39372 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2FMQ7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 12:59:03 -0400
From: Andrew Armenia <andrew@asquaredlabs.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Armenia <andrew@asquaredlabs.com>
Subject: [PATCH 1/3] i2c-piix4: eliminate piix4_smba global variable
Date: Wed, 13 Jun 2012 12:59:07 -0400
Message-Id: <1339606749-4578-2-git-send-email-andrew@asquaredlabs.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339606749-4578-1-git-send-email-andrew@asquaredlabs.com>
References: <20120613094739.360967aa@endymion.delvare>
 <1339606749-4578-1-git-send-email-andrew@asquaredlabs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some chipsets have multiple sets of piix4-compatible SMBus registers.
Eliminating the global variable will allow these chipsets to be fully
supported.

Return value from piix4_setup and piix4_sb800_setup now returns the smba
value detected. This is stored in a struct i2c_piix4_adapdata. Thus
the global variable is eliminated.

Signed-off-by: Andrew Armenia <andrew@asquaredlabs.com>
---
 drivers/i2c/busses/i2c-piix4.c |   54 ++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index c14d48d..61a85c9 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -94,7 +94,6 @@ MODULE_PARM_DESC(force_addr,
 		 "Forcibly enable the PIIX4 at the given address. "
 		 "EXTREMELY DANGEROUS!");
 
-static unsigned short piix4_smba;
 static int srvrworks_csb5_delay;
 static struct pci_driver piix4_driver;
 static struct i2c_adapter piix4_adapter;
@@ -127,10 +126,15 @@ static struct dmi_system_id __devinitdata piix4_dmi_ibm[] = {
 	{ },
 };
 
+struct i2c_piix4_adapdata {
+	unsigned short smba;
+};
+
 static int __devinit piix4_setup(struct pci_dev *PIIX4_dev,
 				const struct pci_device_id *id)
 {
 	unsigned char temp;
+	unsigned short piix4_smba;
 
 	if ((PIIX4_dev->vendor == PCI_VENDOR_ID_SERVERWORKS) &&
 	    (PIIX4_dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5))
@@ -206,7 +210,6 @@ static int __devinit piix4_setup(struct pci_dev *PIIX4_dev,
 			dev_err(&PIIX4_dev->dev,
 				"Host SMBus controller not enabled!\n");
 			release_region(piix4_smba, SMBIOSIZE);
-			piix4_smba = 0;
 			return -ENODEV;
 		}
 	}
@@ -224,12 +227,13 @@ static int __devinit piix4_setup(struct pci_dev *PIIX4_dev,
 		 "SMBus Host Controller at 0x%x, revision %d\n",
 		 piix4_smba, temp);
 
-	return 0;
+	return piix4_smba;
 }
 
 static int __devinit piix4_setup_sb800(struct pci_dev *PIIX4_dev,
 				const struct pci_device_id *id)
 {
+	unsigned short piix4_smba;
 	unsigned short smba_idx = 0xcd6;
 	u8 smba_en_lo, smba_en_hi, i2ccfg, i2ccfg_offset = 0x10, smb_en = 0x2c;
 
@@ -273,7 +277,6 @@ static int __devinit piix4_setup_sb800(struct pci_dev *PIIX4_dev,
 		dev_err(&PIIX4_dev->dev, "SMBus I2C bus config region "
 			"0x%x already in use!\n", piix4_smba + i2ccfg_offset);
 		release_region(piix4_smba, SMBIOSIZE);
-		piix4_smba = 0;
 		return -EBUSY;
 	}
 	i2ccfg = inb_p(piix4_smba + i2ccfg_offset);
@@ -288,10 +291,10 @@ static int __devinit piix4_setup_sb800(struct pci_dev *PIIX4_dev,
 		 "SMBus Host Controller at 0x%x, revision %d\n",
 		 piix4_smba, i2ccfg >> 4);
 
-	return 0;
+	return piix4_smba;
 }
 
-static int piix4_transaction(void)
+static int piix4_transaction(unsigned short piix4_smba)
 {
 	int temp;
 	int result = 0;
@@ -372,6 +375,11 @@ static s32 piix4_access(struct i2c_adapter * adap, u16 addr,
 {
 	int i, len;
 	int status;
+	unsigned short piix4_smba;
+	struct i2c_piix4_adapdata *adapdata;
+
+	adapdata = i2c_get_adapdata(adap);
+	piix4_smba = adapdata->smba;
 
 	switch (size) {
 	case I2C_SMBUS_QUICK:
@@ -426,7 +434,7 @@ static s32 piix4_access(struct i2c_adapter * adap, u16 addr,
 
 	outb_p((size & 0x1C) + (ENABLE_INT9 & 1), SMBHSTCNT);
 
-	status = piix4_transaction();
+	status = piix4_transaction(piix4_smba);
 	if (status)
 		return status;
 
@@ -472,6 +480,8 @@ static struct i2c_adapter piix4_adapter = {
 	.algo		= &smbus_algorithm,
 };
 
+static struct i2c_piix4_adapdata piix4_adapter_data;
+
 static DEFINE_PCI_DEVICE_TABLE(piix4_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371AB_3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443MX_3) },
@@ -510,33 +520,45 @@ static int __devinit piix4_probe(struct pci_dev *dev,
 	else
 		retval = piix4_setup(dev, id);
 
-	if (retval)
+	if (retval < 0)
 		return retval;
 
 	/* set up the sysfs linkage to our parent device */
 	piix4_adapter.dev.parent = &dev->dev;
 
+	piix4_adapter_data.smba = retval;
+
 	snprintf(piix4_adapter.name, sizeof(piix4_adapter.name),
-		"SMBus PIIX4 adapter at %04x", piix4_smba);
+		"SMBus PIIX4 adapter at %04x", piix4_adapter_data.smba);
+
+	i2c_set_adapdata(&piix4_adapter, &piix4_adapter_data);
 
 	if ((retval = i2c_add_adapter(&piix4_adapter))) {
 		dev_err(&dev->dev, "Couldn't register adapter!\n");
-		release_region(piix4_smba, SMBIOSIZE);
-		piix4_smba = 0;
+		release_region(piix4_adapter_data.smba, SMBIOSIZE);
+		piix4_adapter_data.smba = 0;
 	}
 
 	return retval;
 }
 
-static void __devexit piix4_remove(struct pci_dev *dev)
+static void __devinit piix4_adap_remove(struct i2c_adapter *adap)
 {
-	if (piix4_smba) {
-		i2c_del_adapter(&piix4_adapter);
-		release_region(piix4_smba, SMBIOSIZE);
-		piix4_smba = 0;
+	struct i2c_piix4_adapdata *adapdata;
+
+	adapdata = i2c_get_adapdata(adap);
+	if (adapdata->smba) {
+		i2c_del_adapter(adap);
+		release_region(adapdata->smba, SMBIOSIZE);
+		adapdata->smba = 0;
 	}
 }
 
+static void __devexit piix4_remove(struct pci_dev *dev)
+{
+	piix4_adap_remove(&piix4_adapter);
+}
+
 static struct pci_driver piix4_driver = {
 	.name		= "piix4_smbus",
 	.id_table	= piix4_ids,
-- 
1.7.10

