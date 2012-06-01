Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035Ab2FASQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:16:47 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51926 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348Ab2FASQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:16:45 -0400
From: Andrew Armenia <andrew@asquaredlabs.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Armenia <andrew@asquaredlabs.com>
Subject: [PATCH] i2c-piix4: support multiple PIIX4 SMBus hosts
Date: Fri,  1 Jun 2012 14:16:12 -0400
Message-Id: <1338574572-10668-1-git-send-email-andrew@asquaredlabs.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some AMD chipsets have a second PIIX4-compatible host adapter accessible
through a second set of registers (e.g. SP5100). Moved the global base
address variable to an extension of struct i2c_adapter; added logic
to detect chipset known to have this feature. Tested on ASUS KCMA-D8 board.

Signed-off-by: Andrew Armenia <andrew@asquaredlabs.com>
---
 drivers/i2c/busses/i2c-piix4.c |  242 ++++++++++++++++++++++++++++------------
 1 file changed, 170 insertions(+), 72 deletions(-)

diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index c14d48d..a029a47 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -43,24 +43,25 @@
 
 
 /* PIIX4 SMBus address offsets */
-#define SMBHSTSTS	(0 + piix4_smba)
-#define SMBHSLVSTS	(1 + piix4_smba)
-#define SMBHSTCNT	(2 + piix4_smba)
-#define SMBHSTCMD	(3 + piix4_smba)
-#define SMBHSTADD	(4 + piix4_smba)
-#define SMBHSTDAT0	(5 + piix4_smba)
-#define SMBHSTDAT1	(6 + piix4_smba)
-#define SMBBLKDAT	(7 + piix4_smba)
-#define SMBSLVCNT	(8 + piix4_smba)
-#define SMBSHDWCMD	(9 + piix4_smba)
-#define SMBSLVEVT	(0xA + piix4_smba)
-#define SMBSLVDAT	(0xC + piix4_smba)
+#define SMBHSTSTS	(0 + piix4_adap->smba)
+#define SMBHSLVSTS	(1 + piix4_adap->smba)
+#define SMBHSTCNT	(2 + piix4_adap->smba)
+#define SMBHSTCMD	(3 + piix4_adap->smba)
+#define SMBHSTADD	(4 + piix4_adap->smba)
+#define SMBHSTDAT0	(5 + piix4_adap->smba)
+#define SMBHSTDAT1	(6 + piix4_adap->smba)
+#define SMBBLKDAT	(7 + piix4_adap->smba)
+#define SMBSLVCNT	(8 + piix4_adap->smba)
+#define SMBSHDWCMD	(9 + piix4_adap->smba)
+#define SMBSLVEVT	(0xA + piix4_adap->smba)
+#define SMBSLVDAT	(0xC + piix4_adap->smba)
 
 /* count for request_region */
 #define SMBIOSIZE	8
 
 /* PCI Address Constants */
 #define SMBBA		0x090
+#define SMBAUXBA        0x058
 #define SMBHSTCFG	0x0D2
 #define SMBSLVC		0x0D3
 #define SMBSHDW1	0x0D4
@@ -94,10 +95,16 @@ MODULE_PARM_DESC(force_addr,
 		 "Forcibly enable the PIIX4 at the given address. "
 		 "EXTREMELY DANGEROUS!");
 
-static unsigned short piix4_smba;
 static int srvrworks_csb5_delay;
 static struct pci_driver piix4_driver;
-static struct i2c_adapter piix4_adapter;
+
+struct piix4_adapter {
+	struct i2c_adapter i2c_adapter;
+	unsigned short smba;
+};
+
+static struct piix4_adapter piix4_main_adapter;
+static struct piix4_adapter piix4_aux_adapter;
 
 static struct dmi_system_id __devinitdata piix4_dmi_blacklist[] = {
 	{
@@ -128,7 +135,9 @@ static struct dmi_system_id __devinitdata piix4_dmi_ibm[] = {
 };
 
 static int __devinit piix4_setup(struct pci_dev *PIIX4_dev,
-				const struct pci_device_id *id)
+				const struct pci_device_id *id,
+				struct piix4_adapter *adp)
+
 {
 	unsigned char temp;
 
@@ -155,12 +164,12 @@ static int __devinit piix4_setup(struct pci_dev *PIIX4_dev,
 
 	/* Determine the address of the SMBus areas */
 	if (force_addr) {
-		piix4_smba = force_addr & 0xfff0;
+		adp->smba = force_addr & 0xfff0;
 		force = 0;
 	} else {
-		pci_read_config_word(PIIX4_dev, SMBBA, &piix4_smba);
-		piix4_smba &= 0xfff0;
-		if(piix4_smba == 0) {
+		pci_read_config_word(PIIX4_dev, SMBBA, &adp->smba);
+		adp->smba &= 0xfff0;
+		if (adp->smba == 0) {
 			dev_err(&PIIX4_dev->dev, "SMBus base address "
 				"uninitialized - upgrade BIOS or use "
 				"force_addr=0xaddr\n");
@@ -168,12 +177,12 @@ static int __devinit piix4_setup(struct pci_dev *PIIX4_dev,
 		}
 	}
 
-	if (acpi_check_region(piix4_smba, SMBIOSIZE, piix4_driver.name))
+	if (acpi_check_region(adp->smba, SMBIOSIZE, piix4_driver.name))
 		return -ENODEV;
 
-	if (!request_region(piix4_smba, SMBIOSIZE, piix4_driver.name)) {
+	if (!request_region(adp->smba, SMBIOSIZE, piix4_driver.name)) {
 		dev_err(&PIIX4_dev->dev, "SMBus region 0x%x already in use!\n",
-			piix4_smba);
+			adp->smba);
 		return -EBUSY;
 	}
 
@@ -183,10 +192,10 @@ static int __devinit piix4_setup(struct pci_dev *PIIX4_dev,
 	   sure, we disable the PIIX4 first. */
 	if (force_addr) {
 		pci_write_config_byte(PIIX4_dev, SMBHSTCFG, temp & 0xfe);
-		pci_write_config_word(PIIX4_dev, SMBBA, piix4_smba);
+		pci_write_config_word(PIIX4_dev, SMBBA, adp->smba);
 		pci_write_config_byte(PIIX4_dev, SMBHSTCFG, temp | 0x01);
 		dev_info(&PIIX4_dev->dev, "WARNING: SMBus interface set to "
-			"new address %04x!\n", piix4_smba);
+			"new address %04x!\n", adp->smba);
 	} else if ((temp & 1) == 0) {
 		if (force) {
 			/* This should never need to be done, but has been
@@ -205,8 +214,8 @@ static int __devinit piix4_setup(struct pci_dev *PIIX4_dev,
 		} else {
 			dev_err(&PIIX4_dev->dev,
 				"Host SMBus controller not enabled!\n");
-			release_region(piix4_smba, SMBIOSIZE);
-			piix4_smba = 0;
+			release_region(adp->smba, SMBIOSIZE);
+			adp->smba = 0;
 			return -ENODEV;
 		}
 	}
@@ -222,13 +231,46 @@ static int __devinit piix4_setup(struct pci_dev *PIIX4_dev,
 	pci_read_config_byte(PIIX4_dev, SMBREV, &temp);
 	dev_info(&PIIX4_dev->dev,
 		 "SMBus Host Controller at 0x%x, revision %d\n",
-		 piix4_smba, temp);
+		 adp->smba, temp);
+
+	return 0;
+}
+
+static int __devinit piix4_setup_aux(struct pci_dev *PIIX4_dev,
+				const struct pci_device_id *id,
+				struct piix4_adapter *adp,
+				unsigned short base_reg_addr)
+{
+	/* Read address of auxiliary SMBus controller */
+	pci_read_config_word(PIIX4_dev, base_reg_addr, &adp->smba);
+	adp->smba &= 0xffe0;
+
+	if (adp->smba == 0) {
+		dev_err(&PIIX4_dev->dev, "Aux SMBus base address "
+			"uninitialized - upgrade BIOS\n");
+		return -ENODEV;
+	}
+
+	if (acpi_check_region(adp->smba, SMBIOSIZE, piix4_driver.name))
+		return -ENODEV;
+
+	if (!request_region(adp->smba, SMBIOSIZE, piix4_driver.name)) {
+		dev_err(&PIIX4_dev->dev, "Aux SMBus region 0x%x already"
+			" in use!\n", adp->smba);
+		return -EBUSY;
+	}
+
+	dev_info(&PIIX4_dev->dev,
+		"Auxiliary SMBus Host Controller at 0x%x\n",
+		adp->smba
+	);
 
 	return 0;
 }
 
 static int __devinit piix4_setup_sb800(struct pci_dev *PIIX4_dev,
-				const struct pci_device_id *id)
+				const struct pci_device_id *id,
+				struct piix4_adapter *adp)
 {
 	unsigned short smba_idx = 0xcd6;
 	u8 smba_en_lo, smba_en_hi, i2ccfg, i2ccfg_offset = 0x10, smb_en = 0x2c;
@@ -258,26 +300,26 @@ static int __devinit piix4_setup_sb800(struct pci_dev *PIIX4_dev,
 		return -ENODEV;
 	}
 
-	piix4_smba = ((smba_en_hi << 8) | smba_en_lo) & 0xffe0;
-	if (acpi_check_region(piix4_smba, SMBIOSIZE, piix4_driver.name))
+	adp->smba = ((smba_en_hi << 8) | smba_en_lo) & 0xffe0;
+	if (acpi_check_region(adp->smba, SMBIOSIZE, piix4_driver.name))
 		return -ENODEV;
 
-	if (!request_region(piix4_smba, SMBIOSIZE, piix4_driver.name)) {
+	if (!request_region(adp->smba, SMBIOSIZE, piix4_driver.name)) {
 		dev_err(&PIIX4_dev->dev, "SMBus region 0x%x already in use!\n",
-			piix4_smba);
+			adp->smba);
 		return -EBUSY;
 	}
 
 	/* Request the SMBus I2C bus config region */
-	if (!request_region(piix4_smba + i2ccfg_offset, 1, "i2ccfg")) {
+	if (!request_region(adp->smba + i2ccfg_offset, 1, "i2ccfg")) {
 		dev_err(&PIIX4_dev->dev, "SMBus I2C bus config region "
-			"0x%x already in use!\n", piix4_smba + i2ccfg_offset);
-		release_region(piix4_smba, SMBIOSIZE);
-		piix4_smba = 0;
+			"0x%x already in use!\n", adp->smba + i2ccfg_offset);
+		release_region(adp->smba, SMBIOSIZE);
+		adp->smba = 0;
 		return -EBUSY;
 	}
-	i2ccfg = inb_p(piix4_smba + i2ccfg_offset);
-	release_region(piix4_smba + i2ccfg_offset, 1);
+	i2ccfg = inb_p(adp->smba + i2ccfg_offset);
+	release_region(adp->smba + i2ccfg_offset, 1);
 
 	if (i2ccfg & 1)
 		dev_dbg(&PIIX4_dev->dev, "Using IRQ for SMBus.\n");
@@ -286,32 +328,35 @@ static int __devinit piix4_setup_sb800(struct pci_dev *PIIX4_dev,
 
 	dev_info(&PIIX4_dev->dev,
 		 "SMBus Host Controller at 0x%x, revision %d\n",
-		 piix4_smba, i2ccfg >> 4);
+		 adp->smba, i2ccfg >> 4);
 
 	return 0;
 }
 
-static int piix4_transaction(void)
+static int piix4_transaction(struct piix4_adapter *piix4_adap)
 {
 	int temp;
 	int result = 0;
 	int timeout = 0;
 
-	dev_dbg(&piix4_adapter.dev, "Transaction (pre): CNT=%02x, CMD=%02x, "
+	dev_dbg(&piix4_adap->i2c_adapter.dev,
+		"Transaction (pre): CNT=%02x, CMD=%02x, "
 		"ADD=%02x, DAT0=%02x, DAT1=%02x\n", inb_p(SMBHSTCNT),
 		inb_p(SMBHSTCMD), inb_p(SMBHSTADD), inb_p(SMBHSTDAT0),
 		inb_p(SMBHSTDAT1));
 
 	/* Make sure the SMBus host is ready to start transmitting */
 	if ((temp = inb_p(SMBHSTSTS)) != 0x00) {
-		dev_dbg(&piix4_adapter.dev, "SMBus busy (%02x). "
+		dev_dbg(&piix4_adap->i2c_adapter.dev, "SMBus busy (%02x). "
 			"Resetting...\n", temp);
 		outb_p(temp, SMBHSTSTS);
 		if ((temp = inb_p(SMBHSTSTS)) != 0x00) {
-			dev_err(&piix4_adapter.dev, "Failed! (%02x)\n", temp);
+			dev_err(&piix4_adap->i2c_adapter.dev,
+				"Failed! (%02x)\n", temp);
 			return -EBUSY;
 		} else {
-			dev_dbg(&piix4_adapter.dev, "Successful!\n");
+			dev_dbg(&piix4_adap->i2c_adapter.dev,
+				"Successful!\n");
 		}
 	}
 
@@ -330,35 +375,39 @@ static int piix4_transaction(void)
 
 	/* If the SMBus is still busy, we give up */
 	if (timeout == MAX_TIMEOUT) {
-		dev_err(&piix4_adapter.dev, "SMBus Timeout!\n");
+		dev_err(&piix4_adap->i2c_adapter.dev, "SMBus Timeout!\n");
 		result = -ETIMEDOUT;
 	}
 
 	if (temp & 0x10) {
 		result = -EIO;
-		dev_err(&piix4_adapter.dev, "Error: Failed bus transaction\n");
+		dev_err(&piix4_adap->i2c_adapter.dev,
+			"Error: Failed bus transaction\n");
 	}
 
 	if (temp & 0x08) {
 		result = -EIO;
-		dev_dbg(&piix4_adapter.dev, "Bus collision! SMBus may be "
+		dev_dbg(&piix4_adap->i2c_adapter.dev,
+			"Bus collision! SMBus may be "
 			"locked until next hard reset. (sorry!)\n");
 		/* Clock stops and slave is stuck in mid-transmission */
 	}
 
 	if (temp & 0x04) {
 		result = -ENXIO;
-		dev_dbg(&piix4_adapter.dev, "Error: no response!\n");
+		dev_dbg(&piix4_adap->i2c_adapter.dev,
+			"Error: no response!\n");
 	}
 
 	if (inb_p(SMBHSTSTS) != 0x00)
 		outb_p(inb(SMBHSTSTS), SMBHSTSTS);
 
 	if ((temp = inb_p(SMBHSTSTS)) != 0x00) {
-		dev_err(&piix4_adapter.dev, "Failed reset at end of "
-			"transaction (%02x)\n", temp);
+		dev_err(&piix4_adap->i2c_adapter.dev,
+			"Failed reset at end of transaction (%02x)\n", temp);
 	}
-	dev_dbg(&piix4_adapter.dev, "Transaction (post): CNT=%02x, CMD=%02x, "
+	dev_dbg(&piix4_adap->i2c_adapter.dev,
+		"Transaction (post): CNT=%02x, CMD=%02x, "
 		"ADD=%02x, DAT0=%02x, DAT1=%02x\n", inb_p(SMBHSTCNT),
 		inb_p(SMBHSTCMD), inb_p(SMBHSTADD), inb_p(SMBHSTDAT0),
 		inb_p(SMBHSTDAT1));
@@ -373,6 +422,9 @@ static s32 piix4_access(struct i2c_adapter * adap, u16 addr,
 	int i, len;
 	int status;
 
+	struct piix4_adapter *piix4_adap = container_of(adap,
+		struct piix4_adapter, i2c_adapter);
+
 	switch (size) {
 	case I2C_SMBUS_QUICK:
 		outb_p((addr << 1) | read_write,
@@ -426,7 +478,7 @@ static s32 piix4_access(struct i2c_adapter * adap, u16 addr,
 
 	outb_p((size & 0x1C) + (ENABLE_INT9 & 1), SMBHSTCNT);
 
-	status = piix4_transaction();
+	status = piix4_transaction(piix4_adap);
 	if (status)
 		return status;
 
@@ -466,12 +518,6 @@ static const struct i2c_algorithm smbus_algorithm = {
 	.functionality	= piix4_func,
 };
 
-static struct i2c_adapter piix4_adapter = {
-	.owner		= THIS_MODULE,
-	.class		= I2C_CLASS_HWMON | I2C_CLASS_SPD,
-	.algo		= &smbus_algorithm,
-};
-
 static DEFINE_PCI_DEVICE_TABLE(piix4_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371AB_3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443MX_3) },
@@ -496,45 +542,97 @@ static DEFINE_PCI_DEVICE_TABLE(piix4_ids) = {
 
 MODULE_DEVICE_TABLE (pci, piix4_ids);
 
+static void piix4_adapter_init(struct piix4_adapter *adap)
+{
+	memset(adap, 0, sizeof(struct piix4_adapter));
+
+	adap->i2c_adapter.owner = THIS_MODULE;
+	adap->i2c_adapter.class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
+	adap->i2c_adapter.algo = &smbus_algorithm;
+}
+
 static int __devinit piix4_probe(struct pci_dev *dev,
 				const struct pci_device_id *id)
 {
 	int retval;
 
+	piix4_adapter_init(&piix4_main_adapter);
+	piix4_adapter_init(&piix4_aux_adapter);
+
 	if ((dev->vendor == PCI_VENDOR_ID_ATI &&
 	     dev->device == PCI_DEVICE_ID_ATI_SBX00_SMBUS &&
 	     dev->revision >= 0x40) ||
 	    dev->vendor == PCI_VENDOR_ID_AMD)
 		/* base address location etc changed in SB800 */
-		retval = piix4_setup_sb800(dev, id);
+		retval = piix4_setup_sb800(dev, id, &piix4_main_adapter);
 	else
-		retval = piix4_setup(dev, id);
+		retval = piix4_setup(dev, id, &piix4_main_adapter);
 
 	if (retval)
 		return retval;
 
 	/* set up the sysfs linkage to our parent device */
-	piix4_adapter.dev.parent = &dev->dev;
+	piix4_main_adapter.i2c_adapter.dev.parent = &dev->dev;
 
-	snprintf(piix4_adapter.name, sizeof(piix4_adapter.name),
-		"SMBus PIIX4 adapter at %04x", piix4_smba);
+	snprintf(piix4_main_adapter.i2c_adapter.name,
+		sizeof(piix4_main_adapter.i2c_adapter.name),
+		"SMBus PIIX4 adapter at %04x", piix4_main_adapter.smba);
 
-	if ((retval = i2c_add_adapter(&piix4_adapter))) {
+	retval = i2c_add_adapter(&piix4_main_adapter.i2c_adapter);
+	if (retval) {
 		dev_err(&dev->dev, "Couldn't register adapter!\n");
-		release_region(piix4_smba, SMBIOSIZE);
-		piix4_smba = 0;
+		release_region(piix4_main_adapter.smba, SMBIOSIZE);
+		piix4_main_adapter.smba = 0;
+		return retval;
+	}
+
+	if (dev->vendor == PCI_VENDOR_ID_ATI &&
+	    dev->device == PCI_DEVICE_ID_ATI_SBX00_SMBUS &&
+	    dev->revision == 0x3d) {
+		/* Setup aux SMBus port on certain AMD chipsets e.g. SP5100 */
+		retval = piix4_setup_aux(dev, id,
+			&piix4_aux_adapter, SMBAUXBA);
+
+		if (retval) {
+			dev_err(&dev->dev, "Aux SMBus setup failed!\n");
+			release_region(piix4_main_adapter.smba, SMBIOSIZE);
+			piix4_aux_adapter.smba = 0;
+			goto aux_fail;
+		}
+
+		piix4_aux_adapter.i2c_adapter.dev.parent = &dev->dev;
+		snprintf(piix4_aux_adapter.i2c_adapter.name,
+			sizeof(piix4_aux_adapter.i2c_adapter.name),
+			"SMBus PIIX4 adapter (aux) at %04x",
+			piix4_aux_adapter.smba);
+
+		retval = i2c_add_adapter(&piix4_aux_adapter.i2c_adapter);
+		if (retval) {
+			dev_err(&dev->dev,
+				"Couldn't register aux adapter!\n");
+			release_region(piix4_aux_adapter.smba, SMBIOSIZE);
+			piix4_aux_adapter.smba = 0;
+			goto aux_fail;
+		}
 	}
 
-	return retval;
+aux_fail:
+	return 0;
+}
+
+static void piix4_adapter_remove(struct piix4_adapter *adp)
+{
+	if (adp->smba) {
+		i2c_del_adapter(&adp->i2c_adapter);
+		release_region(adp->smba, SMBIOSIZE);
+		adp->smba = 0;
+	}
 }
 
 static void __devexit piix4_remove(struct pci_dev *dev)
 {
-	if (piix4_smba) {
-		i2c_del_adapter(&piix4_adapter);
-		release_region(piix4_smba, SMBIOSIZE);
-		piix4_smba = 0;
-	}
+	piix4_adapter_remove(&piix4_main_adapter);
+	piix4_adapter_remove(&piix4_aux_adapter);
 }
 
 static struct pci_driver piix4_driver = {
-- 
1.7.10

