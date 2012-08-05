Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab2HEWNd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 18:13:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59761 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab2HEWNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 18:13:01 -0400
From: =?UTF-8?q?Amaury=20Decr=C3=AAme?= <amaury.decreme@gmail.com>
To: khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        rob@landley.net
Cc: amalysh@web.de, mhoffman@lightlink.com, ralf@linux-mips.org,
        manuel.lauss@googlemail.com, axel.lin@gmail.com, olof@lixom.net,
        rusty@rustcorp.com.au, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Amaury=20Decr=C3=AAme?= <amaury.decreme@gmail.com>
Subject: [PATCH 2/2] I2C: SIS630: Cosmetics
Date: Mon,  6 Aug 2012 00:11:54 +0200
Message-Id: <1344204714-16513-3-git-send-email-amaury.decreme@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1344204714-16513-1-git-send-email-amaury.decreme@gmail.com>
References: <20120805140454.3e7a9606@endymion.delvare>
 <1344204714-16513-1-git-send-email-amaury.decreme@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces SMBus hex values by human readable constants and
correct some checkpatch -f errors.

Signed-off-by: Amaury Decrême <amaury.decreme@gmail.com>
---
 drivers/i2c/busses/i2c-sis630.c |  311 ++++++++++++++++++++++-----------------
 1 files changed, 178 insertions(+), 133 deletions(-)

diff --git a/drivers/i2c/busses/i2c-sis630.c b/drivers/i2c/busses/i2c-sis630.c
index c950397..8dff4b9 100644
--- a/drivers/i2c/busses/i2c-sis630.c
+++ b/drivers/i2c/busses/i2c-sis630.c
@@ -19,7 +19,7 @@
 /*
    Changes:
    24.08.2002
-   	Fixed the typo in sis630_access (Thanks to Mark M. Hoffman)
+	Fixed the typo in sis630_access (Thanks to Mark M. Hoffman)
 	Changed sis630_transaction.(Thanks to Mark M. Hoffman)
    18.09.2002
 	Added SIS730 as supported.
@@ -82,6 +82,32 @@
 #define SMB_BYTE		0x08	/* ~0x8F data byte field */
 #define SMB_SAA			0x13	/* host slave alias address */
 
+/* SMB_STS register */
+#define SMBALT_STS		0x80	/* Slave alert */
+#define BYTE_DONE_STS		0x10	/* Byte Done Status / Block Array */
+#define SMBMAS_STS		0x08	/* Host Master */
+#define SMBCOL_STS		0x04	/* Collision */
+#define SMBERR_STS		0x02	/* Device error */
+
+/* SMB_CNT register */
+#define MSTO_EN			0x40	/* Host Master Timeout Enable */
+#define SMBCLK_SEL		0x20	/* Host master clock selection */
+#define SMB_PROBE		0x02	/* Bus Probe */
+#define SMB_HOSTBUSY		0x01	/* Host Busy */
+
+/* SMBHOST_CNT register */
+#define SMB_KILL		0x20	/* Kill */
+#define SMB_START		0x10	/* Start */
+#define SMB_PTL			0x07	/* Command Protocol */
+
+/* SMB_ADDR register */
+#define SMB_ADDRESS		0xFE	/* Adress */
+#define SMB_RW			0x01	/* Read/Write */
+
+/* SMB_BYTE register */
+#define SMB_BYTE0		0xFF	/* Byte 0 */
+#define SMB_BYTE1		0xFF00	/* Byte 1 */
+
 /* register count for request_region
  * As we don't use SMB_PCOUNT, 20 is ok for SiS630 and SiS964
  */
@@ -136,23 +162,26 @@ static inline void sis630_write(u8 reg, u8 data)
 	outb(data, smbus_base + reg);
 }
 
-static int sis630_transaction_start(struct i2c_adapter *adap, int size, u8 *oldclock)
+static int sis630_transaction_start(struct i2c_adapter *adap, int size,
+					u8 *oldclock)
 {
-        int temp;
+	int tmp;
 
 	/* Make sure the SMBus host is ready to start transmitting. */
-	if ((temp = sis630_read(SMB_CNT) & 0x03) != 0x00) {
-		dev_dbg(&adap->dev, "SMBus busy (%02x).Resetting...\n",temp);
+	tmp = sis630_read(SMB_CNT);
+	if ((tmp & (SMB_PROBE | SMB_HOSTBUSY)) != 0x00) {
+		dev_dbg(&adap->dev, "SMBus busy (%02x). Resetting...\n", tmp);
 		/* kill smbus transaction */
-		sis630_write(SMBHOST_CNT, 0x20);
+		sis630_write(SMBHOST_CNT, SMB_KILL);
 
-		if ((temp = sis630_read(SMB_CNT) & 0x03) != 0x00) {
-			dev_dbg(&adap->dev, "Failed! (%02x)\n", temp);
+		tmp = sis630_read(SMB_CNT);
+		if (tmp & (SMB_PROBE | SMB_HOSTBUSY)) {
+			dev_dbg(&adap->dev, "Failed! (%02x)\n", tmp);
 			return -EBUSY;
-                } else {
+		} else {
 			dev_dbg(&adap->dev, "Successful!\n");
 		}
-        }
+	}
 
 	/* save old clock, so we can prevent machine for hung */
 	*oldclock = sis630_read(SMB_CNT);
@@ -160,45 +189,46 @@ static int sis630_transaction_start(struct i2c_adapter *adap, int size, u8 *oldc
 	dev_dbg(&adap->dev, "saved clock 0x%02x\n", *oldclock);
 
 	if (clock_sel)
-		sis630_write(SMB_CNT, 0x20);
+		sis630_write(SMB_CNT, SMBCLK_SEL);
 	else
-		sis630_write(SMB_CNT, (*oldclock & ~0x40));
+		sis630_write(SMB_CNT, (*oldclock & ~MSTO_EN));
 
 	/* clear all sticky bits */
-	temp = sis630_read(SMB_STS);
-	sis630_write(SMB_STS, temp & 0x1e);
+	tmp = sis630_read(SMB_STS);
+	sis630_write(SMB_STS, tmp & (BYTE_DONE_STS | SMBMAS_STS
+					| SMBCOL_STS | SMBERR_STS));
 
 	/* start the transaction by setting bit 4 and size */
-	sis630_write(SMBHOST_CNT,0x10 | (size & 0x07));
+	sis630_write(SMBHOST_CNT, SMB_START | (size & SMB_PTL));
 
 	return 0;
 }
 
 static int sis630_transaction_wait(struct i2c_adapter *adap, int size)
 {
-	int temp, result = 0, timeout = 0;
+	int tmp, timeout = 0;
 
 	/* We will always wait for a fraction of a second! */
 	do {
 		msleep(1);
-		temp = sis630_read(SMB_STS);
+		tmp = sis630_read(SMB_STS);
 		/* check if block transmitted */
-		if (size == SIS630_BLOCK_DATA && (temp & 0x10))
-			break;
-	} while (!(temp & 0x0e) && (timeout++ < MAX_TIMEOUT));
+	} while (!(size == SIS630_BLOCK_DATA && (tmp & BYTE_DONE_STS))
+		&& !(tmp & (SMBMAS_STS | SMBCOL_STS | SMBERR_STS))
+		&& (timeout++ < MAX_TIMEOUT));
 
 	/* If the SMBus is still busy, we give up */
 	if (timeout > MAX_TIMEOUT) {
 		dev_dbg(&adap->dev, "SMBus Timeout!\n");
-		result = -ETIMEDOUT;
+		return -ETIMEDOUT;
 	}
 
-	if (temp & 0x02) {
+	if (tmp & SMBERR_STS) {
 		dev_dbg(&adap->dev, "Error: Failed bus transaction\n");
-		result = -ENXIO;
+		return -ENXIO;
 	}
 
-	if (temp & 0x04) {
+	if (tmp & SMBCOL_STS) {
 		dev_err(&adap->dev, "Bus collision!\n");
 		/* Datasheet:
 		 * SMBus Collision (SMBCOL_STS)
@@ -206,11 +236,11 @@ static int sis630_transaction_wait(struct i2c_adapter *adap, int size)
 		 * SMBus Host loses in the bus arbitration. The software should
 		 * clear this bit and re-start SMBus operation.
 		 */
-		sis630_write(SMB_STS, temp & ~0x04);
+		sis630_write(SMB_STS, tmp & ~SMBCOL_STS);
 		return -EAGAIN;
 	}
 
-	return result;
+	return 0;
 }
 
 static void sis630_transaction_end(struct i2c_adapter *adap, u8 oldclock)
@@ -223,38 +253,41 @@ static void sis630_transaction_end(struct i2c_adapter *adap, u8 oldclock)
 	 */
 	sis630_write(SMB_STS, 0xFF);
 
-	dev_dbg(&adap->dev, "SMB_CNT before clock restore 0x%02x\n", sis630_read(SMB_CNT));
+	dev_dbg(&adap->dev, "SMB_CNT before clock restore 0x%02x\n",
+		sis630_read(SMB_CNT));
 
-	if (clock_sel && !(oldclock & 0x20))
-		sis630_write(SMB_CNT,(sis630_read(SMB_CNT) & ~0x20));
+	if (clock_sel && !(oldclock & SMBCLK_SEL))
+		sis630_write(SMB_CNT, sis630_read(SMB_CNT) & ~SMBCLK_SEL);
 
-	dev_dbg(&adap->dev, "SMB_CNT after clock restore 0x%02x\n", sis630_read(SMB_CNT));
+	dev_dbg(&adap->dev, "SMB_CNT after clock restore 0x%02x\n",
+		sis630_read(SMB_CNT));
 }
 
 static int sis630_transaction(struct i2c_adapter *adap, int size)
 {
-	int result = 0;
+	int tmp;
 	int timeout = 0;
 	u8 oldclock = 0;
 
 	/* We loop in case of collisions */
 	do {
-		result = sis630_transaction_start(adap, size, &oldclock);
-		if (!result) {
-			result = sis630_transaction_wait(adap, size);
+		tmp = sis630_transaction_start(adap, size, &oldclock);
+		if (!tmp) {
+			tmp = sis630_transaction_wait(adap, size);
 			sis630_transaction_end(adap, oldclock);
 		}
-	} while (result == -EAGAIN && timeout++ < MAX_TIMEOUT);
+	} while (tmp == -EAGAIN && timeout++ < MAX_TIMEOUT);
 
 	if (timeout > MAX_TIMEOUT) {
 		dev_dbg(&adap->dev, "Too many collisions !\n");
 		return -ETIMEDOUT;
 	}
 
-	return result;
+	return 0;
 }
 
-static int sis630_block_data(struct i2c_adapter *adap, union i2c_smbus_data *data, int read_write)
+static int sis630_block_data(struct i2c_adapter *adap,
+				union i2c_smbus_data *data, int read_write)
 {
 	int i, len = 0, rc = 0;
 	u8 oldclock = 0;
@@ -266,39 +299,43 @@ static int sis630_block_data(struct i2c_adapter *adap, union i2c_smbus_data *dat
 		else if (len > 32)
 			len = 32;
 		sis630_write(SMB_COUNT, len);
-		for (i=1; i <= len; i++) {
-			dev_dbg(&adap->dev, "set data 0x%02x\n", data->block[i]);
+		for (i = 1; i <= len; i++) {
+			dev_dbg(&adap->dev, "set data 0x%02x\n",
+				data->block[i]);
 			/* set data */
 			sis630_write(SMB_BYTE+(i-1)%8, data->block[i]);
-			if (i==8 || (len<8 && i==len)) {
-				dev_dbg(&adap->dev, "start trans len=%d i=%d\n",len ,i);
+			if (i == 8 || (len < 8 && i == len)) {
+				dev_dbg(&adap->dev, "start trans len=%d i=%d\n",
+					len, i);
 				/* first transaction */
 				rc = sis630_transaction_start(adap,
 						SIS630_BLOCK_DATA, &oldclock);
 				if (rc)
 					return rc;
-			}
-			else if ((i-1)%8 == 7 || i==len) {
-				dev_dbg(&adap->dev, "trans_wait len=%d i=%d\n",len,i);
-				if (i>8) {
-					dev_dbg(&adap->dev, "clear smbary_sts len=%d i=%d\n",len,i);
+			} else if ((i-1)%8 == 7 || i == len) {
+				dev_dbg(&adap->dev, "trans_wait len=%d i=%d\n",
+					len, i);
+				if (i > 8) {
+					dev_dbg(&adap->dev,
+						"clr smbary_sts len=%d i=%d\n",
+						len, i);
 					/*
 					   If this is not first transaction,
 					   we must clear sticky bit.
 					   clear SMBARY_STS
 					*/
-					sis630_write(SMB_STS,0x10);
+					sis630_write(SMB_STS, BYTE_DONE_STS);
 				}
 				rc = sis630_transaction_wait(adap,
 						SIS630_BLOCK_DATA);
 				if (rc) {
-					dev_dbg(&adap->dev, "trans_wait failed\n");
+					dev_dbg(&adap->dev,
+						"trans_wait failed\n");
 					break;
 				}
 			}
 		}
-	}
-	else {
+	} else {
 		/* read request */
 		data->block[0] = len = 0;
 		rc = sis630_transaction_start(adap,
@@ -319,18 +356,21 @@ static int sis630_block_data(struct i2c_adapter *adap, union i2c_smbus_data *dat
 			if (data->block[0] > 32)
 				data->block[0] = 32;
 
-			dev_dbg(&adap->dev, "block data read len=0x%x\n", data->block[0]);
+			dev_dbg(&adap->dev, "block data read len=0x%x\n",
+				data->block[0]);
 
-			for (i=0; i < 8 && len < data->block[0]; i++,len++) {
-				dev_dbg(&adap->dev, "read i=%d len=%d\n", i, len);
+			for (i = 0; i < 8 && len < data->block[0]; i++, len++) {
+				dev_dbg(&adap->dev, "read i=%d len=%d\n", i,
+					len);
 				data->block[len+1] = sis630_read(SMB_BYTE+i);
 			}
 
-			dev_dbg(&adap->dev, "clear smbary_sts len=%d i=%d\n",len,i);
+			dev_dbg(&adap->dev, "clear smbary_sts len=%d i=%d\n",
+				len, i);
 
 			/* clear SMBARY_STS */
-			sis630_write(SMB_STS,0x10);
-		} while(len < data->block[0]);
+			sis630_write(SMB_STS, BYTE_DONE_STS);
+		} while (len < data->block[0]);
 	}
 
 	sis630_transaction_end(adap, oldclock);
@@ -346,42 +386,48 @@ static s32 sis630_access(struct i2c_adapter *adap, u16 addr,
 	int status;
 
 	switch (size) {
-		case I2C_SMBUS_QUICK:
-			sis630_write(SMB_ADDR, ((addr & 0x7f) << 1) | (read_write & 0x01));
-			size = SIS630_QUICK;
-			break;
-		case I2C_SMBUS_BYTE:
-			sis630_write(SMB_ADDR, ((addr & 0x7f) << 1) | (read_write & 0x01));
-			if (read_write == I2C_SMBUS_WRITE)
-				sis630_write(SMB_CMD, command);
-			size = SIS630_BYTE;
-			break;
-		case I2C_SMBUS_BYTE_DATA:
-			sis630_write(SMB_ADDR, ((addr & 0x7f) << 1) | (read_write & 0x01));
-			sis630_write(SMB_CMD, command);
-			if (read_write == I2C_SMBUS_WRITE)
-				sis630_write(SMB_BYTE, data->byte);
-			size = SIS630_BYTE_DATA;
-			break;
-		case I2C_SMBUS_PROC_CALL:
-		case I2C_SMBUS_WORD_DATA:
-			sis630_write(SMB_ADDR,((addr & 0x7f) << 1) | (read_write & 0x01));
-			sis630_write(SMB_CMD, command);
-			if (read_write == I2C_SMBUS_WRITE) {
-				sis630_write(SMB_BYTE, data->word & 0xff);
-				sis630_write(SMB_BYTE + 1,(data->word & 0xff00) >> 8);
-			}
-			size = (size == I2C_SMBUS_PROC_CALL ? SIS630_PCALL : SIS630_WORD_DATA);
-			break;
-		case I2C_SMBUS_BLOCK_DATA:
-			sis630_write(SMB_ADDR,((addr & 0x7f) << 1) | (read_write & 0x01));
+	case I2C_SMBUS_QUICK:
+		sis630_write(SMB_ADDR, ((addr << 1) & SMB_ADDRESS) |
+							(read_write & SMB_RW));
+		size = SIS630_QUICK;
+		break;
+	case I2C_SMBUS_BYTE:
+		sis630_write(SMB_ADDR, ((addr << 1) & SMB_ADDRESS) |
+							(read_write & SMB_RW));
+		if (read_write == I2C_SMBUS_WRITE)
 			sis630_write(SMB_CMD, command);
-			size = SIS630_BLOCK_DATA;
-			return sis630_block_data(adap, data, read_write);
-		default:
-			dev_warn(&adap->dev, "Unsupported transaction %d\n",
-				 size);
-			return -EOPNOTSUPP;
+		size = SIS630_BYTE;
+		break;
+	case I2C_SMBUS_BYTE_DATA:
+		sis630_write(SMB_ADDR, ((addr << 1) & SMB_ADDRESS) |
+							(read_write & SMB_RW));
+		sis630_write(SMB_CMD, command);
+		if (read_write == I2C_SMBUS_WRITE)
+			sis630_write(SMB_BYTE, data->byte);
+		size = SIS630_BYTE_DATA;
+		break;
+	case I2C_SMBUS_PROC_CALL:
+	case I2C_SMBUS_WORD_DATA:
+		sis630_write(SMB_ADDR, ((addr << 1) & SMB_ADDRESS) |
+							(read_write & SMB_RW));
+		sis630_write(SMB_CMD, command);
+		if (read_write == I2C_SMBUS_WRITE) {
+			sis630_write(SMB_BYTE, data->word & SMB_BYTE0);
+			sis630_write(SMB_BYTE + 1,
+						(data->word & SMB_BYTE1) >> 8);
+		}
+		size = (size == I2C_SMBUS_PROC_CALL ?
+				SIS630_PCALL : SIS630_WORD_DATA);
+		break;
+	case I2C_SMBUS_BLOCK_DATA:
+		sis630_write(SMB_ADDR, ((addr << 1) & SMB_ADDRESS) |
+							(read_write & SMB_RW));
+		sis630_write(SMB_CMD, command);
+		size = SIS630_BLOCK_DATA;
+		return sis630_block_data(adap, data, read_write);
+	default:
+		dev_warn(&adap->dev, "Unsupported transaction %d\n", size);
+		return -EOPNOTSUPP;
 	}
 
 	status = sis630_transaction(adap, size);
@@ -393,15 +439,16 @@ static s32 sis630_access(struct i2c_adapter *adap, u16 addr,
 		return 0;
 	}
 
-	switch(size) {
-		case SIS630_BYTE:
-		case SIS630_BYTE_DATA:
-			data->byte = sis630_read(SMB_BYTE);
-			break;
-		case SIS630_PCALL:
-		case SIS630_WORD_DATA:
-			data->word = sis630_read(SMB_BYTE) + (sis630_read(SMB_BYTE + 1) << 8);
-			break;
+	switch (size) {
+	case SIS630_BYTE:
+	case SIS630_BYTE_DATA:
+		data->byte = sis630_read(SMB_BYTE);
+		break;
+	case SIS630_PCALL:
+	case SIS630_WORD_DATA:
+		data->word = sis630_read(SMB_BYTE) +
+				(sis630_read(SMB_BYTE + 1) << 8);
+		break;
 	}
 
 	return 0;
@@ -409,9 +456,9 @@ static s32 sis630_access(struct i2c_adapter *adap, u16 addr,
 
 static u32 sis630_func(struct i2c_adapter *adapter)
 {
-	return I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE | I2C_FUNC_SMBUS_BYTE_DATA |
-		I2C_FUNC_SMBUS_WORD_DATA | I2C_FUNC_SMBUS_PROC_CALL |
-		I2C_FUNC_SMBUS_BLOCK_DATA;
+	return I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE |
+		I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA |
+		I2C_FUNC_SMBUS_PROC_CALL | I2C_FUNC_SMBUS_BLOCK_DATA;
 }
 
 static int __devinit sis630_setup(struct pci_dev *sis630_dev)
@@ -423,19 +470,19 @@ static int __devinit sis630_setup(struct pci_dev *sis630_dev)
 	static unsigned short acpi_base;
 
 	/* check for supported SiS devices */
-	for (i=0; supported[i] > 0 ; i++) {
-		if ((dummy = pci_get_device(PCI_VENDOR_ID_SI, supported[i], dummy)))
+	for (i = 0; supported[i] > 0; i++) {
+		dummy = pci_get_device(PCI_VENDOR_ID_SI, supported[i], dummy);
+		if (dummy)
 			break; /* found */
 	}
 
 	if (dummy) {
 		pci_dev_put(dummy);
-	}
-        else if (force) {
-		dev_err(&sis630_dev->dev, "WARNING: Can't detect SIS630 compatible device, but "
+	} else if (force) {
+		dev_err(&sis630_dev->dev,
+			"WARNING: Can't detect SIS630 compatible device, but "
 			"loading because of force option enabled\n");
- 	}
-	else {
+	} else {
 		return -ENODEV;
 	}
 
@@ -443,24 +490,23 @@ static int __devinit sis630_setup(struct pci_dev *sis630_dev)
 	   Enable ACPI first , so we can accsess reg 74-75
 	   in acpi io space and read acpi base addr
 	*/
-	if (pci_read_config_byte(sis630_dev, SIS630_BIOS_CTL_REG,&b)) {
+	if (pci_read_config_byte(sis630_dev, SIS630_BIOS_CTL_REG, &b)) {
 		dev_err(&sis630_dev->dev, "Error: Can't read bios ctl reg\n");
-		retval = -ENODEV;
-		goto exit;
+		return -ENODEV;
 	}
 	/* if ACPI already enabled , do nothing */
 	if (!(b & 0x80) &&
 	    pci_write_config_byte(sis630_dev, SIS630_BIOS_CTL_REG, b | 0x80)) {
 		dev_err(&sis630_dev->dev, "Error: Can't enable ACPI\n");
-		retval = -ENODEV;
-		goto exit;
+		return -ENODEV;
 	}
 
 	/* Determine the ACPI base address */
-	if (pci_read_config_word(sis630_dev,SIS630_ACPI_BASE_REG,&acpi_base)) {
-		dev_err(&sis630_dev->dev, "Error: Can't determine ACPI base address\n");
-		retval = -ENODEV;
-		goto exit;
+	if (pci_read_config_word(sis630_dev, SIS630_ACPI_BASE_REG,
+								&acpi_base)) {
+		dev_err(&sis630_dev->dev,
+				"Error: Can't determine ACPI base address\n");
+		return -ENODEV;
 	}
 
 	dev_dbg(&sis630_dev->dev, "ACPI base at 0x%04x\n", acpi_base);
@@ -474,8 +520,10 @@ static int __devinit sis630_setup(struct pci_dev *sis630_dev)
 
 	retval = acpi_check_region(smbus_base + SMB_STS, SIS630_SMB_IOREGION,
 				   sis630_driver.name);
-	if (retval)
-		goto exit;
+	if (retval) {
+		smbus_base = 0;
+		return retval;
+	}
 
 	/* Everything is happy, let's grab the memory and set things up. */
 	if (!request_region(smbus_base + SMB_STS, SIS630_SMB_IOREGION,
@@ -483,16 +531,10 @@ static int __devinit sis630_setup(struct pci_dev *sis630_dev)
 		dev_err(&sis630_dev->dev,
 			"SMBus registers 0x%04x-0x%04x already in use!\n",
 			smbus_base + SMB_STS, smbus_base + SMB_SAA);
-		retval = -EBUSY;
-		goto exit;
+		return -EBUSY;
 	}
 
-	retval = 0;
-
-exit:
-	if (retval)
-		smbus_base = 0;
-	return retval;
+	return 0;
 }
 
 
@@ -511,15 +553,18 @@ static DEFINE_PCI_DEVICE_TABLE(sis630_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_503) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_964) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_LPC) },
-	{ 0, }
+	{ 0 }
 };
 
-MODULE_DEVICE_TABLE (pci, sis630_ids);
+MODULE_DEVICE_TABLE(pci, sis630_ids);
 
-static int __devinit sis630_probe(struct pci_dev *dev, const struct pci_device_id *id)
+static int __devinit sis630_probe(struct pci_dev *dev,
+					const struct pci_device_id *id)
 {
 	if (sis630_setup(dev)) {
-		dev_err(&dev->dev, "SIS630 comp. bus not detected, module not inserted.\n");
+		dev_err(&dev->dev,
+			"SIS630 compatible bus not detected, "
+			"module not inserted.\n");
 		return -ENODEV;
 	}
 
-- 
1.7.8.6

