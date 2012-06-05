Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371Ab2FEBuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 21:50:11 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:56034 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761309Ab2FEBt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 21:49:29 -0400
From: Andrew Armenia <andrew@asquaredlabs.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Armenia <andrew@asquaredlabs.com>
Subject: [PATCH 1/3] i2c-piix4: eliminate global I/O base address
Date: Mon,  4 Jun 2012 21:49:22 -0400
Message-Id: <1338860964-10803-2-git-send-email-andrew@asquaredlabs.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1338860964-10803-1-git-send-email-andrew@asquaredlabs.com>
References: <20120604091643.208956fe@endymion.delvare>
 <1338860964-10803-1-git-send-email-andrew@asquaredlabs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c-piix4 driver used a global variable to store the base address
of the piix4 i2c registers. Some chipsets contain multiple sets of
i2c registers; thus it is desirable to eliminate global state.

i2c_get_adapdata()/i2c_set_adapdata() are used to keep track
of the IO base address; this is passed into piix4_transaction() as
an argument, eliminating the global variable.

Signed-off-by: Andrew Armenia <andrew@asquaredlabs.com>
---
 drivers/i2c/busses/i2c-piix4.c |   61 ++++++++++++++++++++++++++++++----------
 1 file changed, 46 insertions(+), 15 deletions(-)

diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index c14d48d..7a5889c 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -94,7 +94,6 @@ MODULE_PARM_DESC(force_addr,
 		 "Forcibly enable the PIIX4 at the given address. "
 		 "EXTREMELY DANGEROUS!");
 
-static unsigned short piix4_smba;
 static int srvrworks_csb5_delay;
 static struct pci_driver piix4_driver;
 static struct i2c_adapter piix4_adapter;
@@ -127,10 +126,16 @@ static struct dmi_system_id __devinitdata piix4_dmi_ibm[] = {
 	{ },
 };
 
+struct i2c_piix4_adapdata {
+	unsigned short smba;
+};
+
 static int __devinit piix4_setup(struct pci_dev *PIIX4_dev,
-				const struct pci_device_id *id)
+				const struct pci_device_id *id,
+				unsigned short *smba)
 {
 	unsigned char temp;
+	unsigned short piix4_smba;
 
 	if ((PIIX4_dev->vendor == PCI_VENDOR_ID_SERVERWORKS) &&
 	    (PIIX4_dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5))
@@ -224,12 +229,15 @@ static int __devinit piix4_setup(struct pci_dev *PIIX4_dev,
 		 "SMBus Host Controller at 0x%x, revision %d\n",
 		 piix4_smba, temp);
 
+	*smba = piix4_smba;
 	return 0;
 }
 
 static int __devinit piix4_setup_sb800(struct pci_dev *PIIX4_dev,
-				const struct pci_device_id *id)
+				const struct pci_device_id *id,
+				unsigned short *smba)
 {
+	unsigned short piix4_smba;
 	unsigned short smba_idx = 0xcd6;
 	u8 smba_en_lo, smba_en_hi, i2ccfg, i2ccfg_offset = 0x10, smb_en = 0x2c;
 
@@ -288,10 +296,11 @@ static int __devinit piix4_setup_sb800(struct pci_dev *PIIX4_dev,
 		 "SMBus Host Controller at 0x%x, revision %d\n",
 		 piix4_smba, i2ccfg >> 4);
 
+	*smba = piix4_smba;
 	return 0;
 }
 
-static int piix4_transaction(void)
+static int piix4_transaction(unsigned short piix4_smba)
 {
 	int temp;
 	int result = 0;
@@ -372,6 +381,11 @@ static s32 piix4_access(struct i2c_adapter * adap, u16 addr,
 {
 	int i, len;
 	int status;
+	unsigned short piix4_smba;
+	struct i2c_piix4_adapdata *adapdata;
+
+	adapdata = (struct i2c_piix4_adapdata *)i2c_get_adapdata(adap);
+	piix4_smba = adapdata->smba;
 
 	switch (size) {
 	case I2C_SMBUS_QUICK:
@@ -426,7 +440,7 @@ static s32 piix4_access(struct i2c_adapter * adap, u16 addr,
 
 	outb_p((size & 0x1C) + (ENABLE_INT9 & 1), SMBHSTCNT);
 
-	status = piix4_transaction();
+	status = piix4_transaction(piix4_smba);
 	if (status)
 		return status;
 
@@ -472,6 +486,10 @@ static struct i2c_adapter piix4_adapter = {
 	.algo		= &smbus_algorithm,
 };
 
+static struct i2c_piix4_adapdata piix4_adapter_data = {
+	.smba		= 0,
+};
+
 static DEFINE_PCI_DEVICE_TABLE(piix4_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371AB_3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443MX_3) },
@@ -500,15 +518,16 @@ static int __devinit piix4_probe(struct pci_dev *dev,
 				const struct pci_device_id *id)
 {
 	int retval;
+	unsigned short smba;
 
 	if ((dev->vendor == PCI_VENDOR_ID_ATI &&
 	     dev->device == PCI_DEVICE_ID_ATI_SBX00_SMBUS &&
 	     dev->revision >= 0x40) ||
 	    dev->vendor == PCI_VENDOR_ID_AMD)
 		/* base address location etc changed in SB800 */
-		retval = piix4_setup_sb800(dev, id);
+		retval = piix4_setup_sb800(dev, id, &smba);
 	else
-		retval = piix4_setup(dev, id);
+		retval = piix4_setup(dev, id, &smba);
 
 	if (retval)
 		return retval;
@@ -517,26 +536,38 @@ static int __devinit piix4_probe(struct pci_dev *dev,
 	piix4_adapter.dev.parent = &dev->dev;
 
 	snprintf(piix4_adapter.name, sizeof(piix4_adapter.name),
-		"SMBus PIIX4 adapter at %04x", piix4_smba);
+		"SMBus PIIX4 adapter at %04x", smba);
+
+	piix4_adapter_data.smba = smba;
+
+	i2c_set_adapdata(&piix4_adapter, &piix4_adapter_data);
 
 	if ((retval = i2c_add_adapter(&piix4_adapter))) {
 		dev_err(&dev->dev, "Couldn't register adapter!\n");
-		release_region(piix4_smba, SMBIOSIZE);
-		piix4_smba = 0;
+		release_region(smba, SMBIOSIZE);
+		piix4_adapter_data.smba = 0;
 	}
 
 	return retval;
 }
 
-static void __devexit piix4_remove(struct pci_dev *dev)
+static void piix4_adap_remove(struct i2c_adapter *adap)
 {
-	if (piix4_smba) {
-		i2c_del_adapter(&piix4_adapter);
-		release_region(piix4_smba, SMBIOSIZE);
-		piix4_smba = 0;
+	struct i2c_piix4_adapdata *adapdata;
+
+	adapdata = (struct i2c_piix4_adapdata *)i2c_get_adapdata(adap);
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

