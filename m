Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab2HEWNb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 18:13:31 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42366 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab2HEWM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 18:12:58 -0400
From: =?UTF-8?q?Amaury=20Decr=C3=AAme?= <amaury.decreme@gmail.com>
To: khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        rob@landley.net
Cc: amalysh@web.de, mhoffman@lightlink.com, ralf@linux-mips.org,
        manuel.lauss@googlemail.com, axel.lin@gmail.com, olof@lixom.net,
        rusty@rustcorp.com.au, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Amaury=20Decr=C3=AAme?= <amaury.decreme@gmail.com>
Subject: [PATCH 1/2] I2C: SIS630: Add SiS964 support
Date: Mon,  6 Aug 2012 00:11:53 +0200
Message-Id: <1344204714-16513-2-git-send-email-amaury.decreme@gmail.com>
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

This patch add SiS964 support to i2c-sis630.

Signed-off-by: Amaury Decrême <amaury.decreme@gmail.com>
---
 Documentation/i2c/busses/i2c-sis630 |   17 +++-
 drivers/i2c/busses/Kconfig          |    4 +-
 drivers/i2c/busses/i2c-sis630.c     |  148 ++++++++++++++++++++++-------------
 3 files changed, 107 insertions(+), 62 deletions(-)

diff --git a/Documentation/i2c/busses/i2c-sis630 b/Documentation/i2c/busses/i2c-sis630
index 0b96973..46b62e7 100644
--- a/Documentation/i2c/busses/i2c-sis630
+++ b/Documentation/i2c/busses/i2c-sis630
@@ -4,20 +4,23 @@ Supported adapters:
   * Silicon Integrated Systems Corp (SiS)
 	630 chipset (Datasheet: available at http://www.sfr-fresh.com/linux)
 	730 chipset
+	964 chipset
   * Possible other SiS chipsets ?
 
 Author: Alexander Malysh <amalysh@web.de>
+	Amaury Decrême <amaury.decreme@gmail.com> - SiS964 patch
 
 Module Parameters
 -----------------
 
-* force = [1|0] Forcibly enable the SIS630. DANGEROUS!
+* force = [1|0] Forcibly enable the driver. DANGEROUS!
 		This can be interesting for chipsets not named
 		above to check if it works for you chipset, but DANGEROUS!
 
-* high_clock = [1|0] Forcibly set Host Master Clock to 56KHz (default,
-			what your BIOS use). DANGEROUS! This should be a bit
-			faster, but freeze some systems (i.e. my Laptop).
+* clock_sel = [1|0] Forcibly set Host Master Clock.
+			SiS630/730	56kHz instead of 14kHz
+			SiS964		27.78kHz instead of 55.56 kHz
+			DANGEROUS! It can freeze some systems.
 
 
 Description
@@ -36,6 +39,12 @@ or like this:
 00:00.0 Host bridge: Silicon Integrated Systems [SiS] 730 Host (rev 02)
 00:01.0 ISA bridge: Silicon Integrated Systems [SiS] 85C503/5513
 
+or like this:
+
+00:00.0 Host bridge: Silicon Integrated Systems [SiS] 760/M760 Host (rev 02)
+00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS964 [MuTIOL Media IO]
+							LPC Controller (rev 36)
+
 in your 'lspci' output , then this driver is for your chipset.
 
 Thank You
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index b4aaa1b..ee9ca06 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -184,11 +184,11 @@ config I2C_SIS5595
 	  will be called i2c-sis5595.
 
 config I2C_SIS630
-	tristate "SiS 630/730"
+	tristate "SiS 630/730/964"
 	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the
-	  SiS630 and SiS730 SMBus (a subset of I2C) interface.
+	  SiS630, SiS730 and SiS964 SMBus (a subset of I2C) interface.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-sis630.
diff --git a/drivers/i2c/busses/i2c-sis630.c b/drivers/i2c/busses/i2c-sis630.c
index 5d6723b..c950397 100644
--- a/drivers/i2c/busses/i2c-sis630.c
+++ b/drivers/i2c/busses/i2c-sis630.c
@@ -24,7 +24,7 @@
    18.09.2002
 	Added SIS730 as supported.
    21.09.2002
-	Added high_clock module option.If this option is set
+	Added clock_sel module option.If this option is set
 	used Host Master Clock 56KHz (default 14KHz).For now we save old Host
 	Master Clock and after transaction completed restore (otherwise
 	it's confuse BIOS and hung Machine).
@@ -32,7 +32,9 @@
 	Fixed typo in sis630_access
 	Fixed logical error by restoring of Host Master Clock
    31.07.2003
-   	Added block data read/write support.
+	Added block data read/write support.
+   03.08.2012
+	Added support of SiS964 - Amaury Decrême <amaury.decreme@gmail.com>
 */
 
 /*
@@ -41,6 +43,18 @@
    Supports:
 	SIS 630
 	SIS 730
+	SIS 964
+
+   Notable differences between chips:
+	+------------------------+--------------------+-------------------+
+	|                        |     SIS630/730     |      SIS964       |
+	+------------------------+--------------------+-------------------+
+	| Clock                  | 14kHz/56kHz        | 55.56kHz/27.78kHz |
+	| SMBus registers offset | 0x80               | 0xE0              |
+	| SMB_CNT                | Bit 1 = Slave Busy | Bit 1 = Bus probe |
+	| SMB_COUNT              | 4:0 bits           | 5:0 bits          |
+	+------------------------+--------------------+-------------------+
+	(Other differences doesn't affect the functions provided by the driver)
 
    Note: we assume there can only be one device, with one SMBus interface.
 */
@@ -55,22 +69,22 @@
 #include <linux/acpi.h>
 #include <linux/io.h>
 
-/* SIS630 SMBus registers */
-#define SMB_STS			0x80	/* status */
-#define SMB_EN			0x81	/* status enable */
-#define SMB_CNT			0x82
-#define SMBHOST_CNT		0x83
-#define SMB_ADDR		0x84
-#define SMB_CMD			0x85
-#define SMB_PCOUNT		0x86	/* processed count */
-#define SMB_COUNT		0x87
-#define SMB_BYTE		0x88	/* ~0x8F data byte field */
-#define SMBDEV_ADDR		0x90
-#define SMB_DB0			0x91
-#define SMB_DB1			0x92
-#define SMB_SAA			0x93
-
-/* register count for request_region */
+/* SIS964 id, defined here as we are the only file using it */
+#define PCI_DEVICE_ID_SI_964	0x0964
+
+/* SIS630/730/964 SMBus registers */
+#define SMB_STS			0x00	/* status */
+#define SMB_CNT			0x02	/* control */
+#define SMBHOST_CNT		0x03	/* host control */
+#define SMB_ADDR		0x04	/* address */
+#define SMB_CMD			0x05	/* command */
+#define SMB_COUNT		0x07	/* byte count */
+#define SMB_BYTE		0x08	/* ~0x8F data byte field */
+#define SMB_SAA			0x13	/* host slave alias address */
+
+/* register count for request_region
+ * As we don't use SMB_PCOUNT, 20 is ok for SiS630 and SiS964
+ */
 #define SIS630_SMB_IOREGION	20
 
 /* PCI address constants */
@@ -93,31 +107,33 @@
 static struct pci_driver sis630_driver;
 
 /* insmod parameters */
-static bool high_clock;
+static bool clock_sel;
 static bool force;
-module_param(high_clock, bool, 0);
-MODULE_PARM_DESC(high_clock, "Set Host Master Clock to 56KHz (default 14KHz).");
+module_param(clock_sel, bool, 0);
+MODULE_PARM_DESC(clock_sel,
+"Set Host Master Clock to 56kHz for SIS630/730 and to 27.78kHz for SIS964.");
 module_param(force, bool, 0);
-MODULE_PARM_DESC(force, "Forcibly enable the SIS630. DANGEROUS!");
+MODULE_PARM_DESC(force, "Forcibly enable the driver. DANGEROUS!");
 
-/* acpi base address */
-static unsigned short acpi_base;
+/* SMBus base adress */
+static unsigned short smbus_base;
 
 /* supported chips */
 static int supported[] = {
 	PCI_DEVICE_ID_SI_630,
 	PCI_DEVICE_ID_SI_730,
+	PCI_DEVICE_ID_SI_964,
 	0 /* terminates the list */
 };
 
 static inline u8 sis630_read(u8 reg)
 {
-	return inb(acpi_base + reg);
+	return inb(smbus_base + reg);
 }
 
 static inline void sis630_write(u8 reg, u8 data)
 {
-	outb(data, acpi_base + reg);
+	outb(data, smbus_base + reg);
 }
 
 static int sis630_transaction_start(struct i2c_adapter *adap, int size, u8 *oldclock)
@@ -143,8 +159,7 @@ static int sis630_transaction_start(struct i2c_adapter *adap, int size, u8 *oldc
 
 	dev_dbg(&adap->dev, "saved clock 0x%02x\n", *oldclock);
 
-	/* disable timeout interrupt , set Host Master Clock to 56KHz if requested */
-	if (high_clock)
+	if (clock_sel)
 		sis630_write(SMB_CNT, 0x20);
 	else
 		sis630_write(SMB_CNT, (*oldclock & ~0x40));
@@ -185,12 +200,14 @@ static int sis630_transaction_wait(struct i2c_adapter *adap, int size)
 
 	if (temp & 0x04) {
 		dev_err(&adap->dev, "Bus collision!\n");
-		result = -EIO;
-		/*
-		  TBD: Datasheet say:
-		  the software should clear this bit and restart SMBUS operation.
-		  Should we do it or user start request again?
-		*/
+		/* Datasheet:
+		 * SMBus Collision (SMBCOL_STS)
+		 * This bit is set when a SMBus Collision condition occurs and
+		 * SMBus Host loses in the bus arbitration. The software should
+		 * clear this bit and re-start SMBus operation.
+		 */
+		sis630_write(SMB_STS, temp & ~0x04);
+		return -EAGAIN;
 	}
 
 	return result;
@@ -198,18 +215,17 @@ static int sis630_transaction_wait(struct i2c_adapter *adap, int size)
 
 static void sis630_transaction_end(struct i2c_adapter *adap, u8 oldclock)
 {
-	int temp = 0;
-
-	/* clear all status "sticky" bits */
-	sis630_write(SMB_STS, temp);
+	/* clear all status "sticky" bits
+	 * Datasheet:
+	 * SMBus Status (SMB_STS)
+	 * The following registers are all sticky bits and only can be
+	 * cleared by writing a one to their corresponding fields.
+	 */
+	sis630_write(SMB_STS, 0xFF);
 
 	dev_dbg(&adap->dev, "SMB_CNT before clock restore 0x%02x\n", sis630_read(SMB_CNT));
 
-	/*
-	 * restore old Host Master Clock if high_clock is set
-	 * and oldclock was not 56KHz
-	 */
-	if (high_clock && !(oldclock & 0x20))
+	if (clock_sel && !(oldclock & 0x20))
 		sis630_write(SMB_CNT,(sis630_read(SMB_CNT) & ~0x20));
 
 	dev_dbg(&adap->dev, "SMB_CNT after clock restore 0x%02x\n", sis630_read(SMB_CNT));
@@ -218,12 +234,21 @@ static void sis630_transaction_end(struct i2c_adapter *adap, u8 oldclock)
 static int sis630_transaction(struct i2c_adapter *adap, int size)
 {
 	int result = 0;
+	int timeout = 0;
 	u8 oldclock = 0;
 
-	result = sis630_transaction_start(adap, size, &oldclock);
-	if (!result) {
-		result = sis630_transaction_wait(adap, size);
-		sis630_transaction_end(adap, oldclock);
+	/* We loop in case of collisions */
+	do {
+		result = sis630_transaction_start(adap, size, &oldclock);
+		if (!result) {
+			result = sis630_transaction_wait(adap, size);
+			sis630_transaction_end(adap, oldclock);
+		}
+	} while (result == -EAGAIN && timeout++ < MAX_TIMEOUT);
+
+	if (timeout > MAX_TIMEOUT) {
+		dev_dbg(&adap->dev, "Too many collisions !\n");
+		return -ETIMEDOUT;
 	}
 
 	return result;
@@ -394,6 +419,8 @@ static int __devinit sis630_setup(struct pci_dev *sis630_dev)
 	unsigned char b;
 	struct pci_dev *dummy = NULL;
 	int retval, i;
+	/* acpi base address */
+	static unsigned short acpi_base;
 
 	/* check for supported SiS devices */
 	for (i=0; supported[i] > 0 ; i++) {
@@ -438,16 +465,24 @@ static int __devinit sis630_setup(struct pci_dev *sis630_dev)
 
 	dev_dbg(&sis630_dev->dev, "ACPI base at 0x%04x\n", acpi_base);
 
-	retval = acpi_check_region(acpi_base + SMB_STS, SIS630_SMB_IOREGION,
+	if (supported[i] == PCI_DEVICE_ID_SI_964)
+		smbus_base = acpi_base + 0xE0;
+	else
+		smbus_base = acpi_base + 0x80;
+
+	dev_dbg(&sis630_dev->dev, "SMBus base at 0x%04x\n", smbus_base);
+
+	retval = acpi_check_region(smbus_base + SMB_STS, SIS630_SMB_IOREGION,
 				   sis630_driver.name);
 	if (retval)
 		goto exit;
 
 	/* Everything is happy, let's grab the memory and set things up. */
-	if (!request_region(acpi_base + SMB_STS, SIS630_SMB_IOREGION,
+	if (!request_region(smbus_base + SMB_STS, SIS630_SMB_IOREGION,
 			    sis630_driver.name)) {
-		dev_err(&sis630_dev->dev, "SMBus registers 0x%04x-0x%04x already "
-			"in use!\n", acpi_base + SMB_STS, acpi_base + SMB_SAA);
+		dev_err(&sis630_dev->dev,
+			"SMBus registers 0x%04x-0x%04x already in use!\n",
+			smbus_base + SMB_STS, smbus_base + SMB_SAA);
 		retval = -EBUSY;
 		goto exit;
 	}
@@ -456,7 +491,7 @@ static int __devinit sis630_setup(struct pci_dev *sis630_dev)
 
 exit:
 	if (retval)
-		acpi_base = 0;
+		smbus_base = 0;
 	return retval;
 }
 
@@ -474,6 +509,7 @@ static struct i2c_adapter sis630_adapter = {
 
 static DEFINE_PCI_DEVICE_TABLE(sis630_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_503) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_964) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_LPC) },
 	{ 0, }
 };
@@ -491,17 +527,17 @@ static int __devinit sis630_probe(struct pci_dev *dev, const struct pci_device_i
 	sis630_adapter.dev.parent = &dev->dev;
 
 	snprintf(sis630_adapter.name, sizeof(sis630_adapter.name),
-		 "SMBus SIS630 adapter at %04x", acpi_base + SMB_STS);
+		 "SMBus SIS630 adapter at %04x", smbus_base + SMB_STS);
 
 	return i2c_add_adapter(&sis630_adapter);
 }
 
 static void __devexit sis630_remove(struct pci_dev *dev)
 {
-	if (acpi_base) {
+	if (smbus_base) {
 		i2c_del_adapter(&sis630_adapter);
-		release_region(acpi_base + SMB_STS, SIS630_SMB_IOREGION);
-		acpi_base = 0;
+		release_region(smbus_base + SMB_STS, SIS630_SMB_IOREGION);
+		smbus_base = 0;
 	}
 }
 
-- 
1.7.8.6

