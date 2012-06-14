Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab2FNNAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:00:20 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47543 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab2FNNAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:00:16 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Chris Wright <chrisw@sous-sol.org>,
        Ivo Sieben <meltedpianoman@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roland Stigge <stigge@antcom.de>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: [PATCH] SPI: at25: Parse dt settings
Date: Thu, 14 Jun 2012 09:59:23 -0300
Message-Id: <1339678763-14509-1-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds dt support to the at25 eeprom driver.

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Tested-by: Roland Stigge <stigge@antcom.de>
---
 Documentation/devicetree/bindings/misc/at25.txt |   21 ++++++++
 drivers/misc/eeprom/at25.c                      |   61 +++++++++++++++++------
 2 files changed, 66 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/misc/at25.txt

diff --git a/Documentation/devicetree/bindings/misc/at25.txt b/Documentation/devicetree/bindings/misc/at25.txt
new file mode 100644
index 0000000..ab3c327
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/at25.txt
@@ -0,0 +1,21 @@
+Atmel AT25 eeprom
+
+Required properties:
+- compatible : "atmel,at25".
+- reg : chip select number
+- spi-max-frequency : max spi frequency to use
+
+- at25,byte-len : total eeprom size in bytes
+- at25,addr-mode : addr-mode flags, as defined in include/linux/spi/eeprom.h
+- at25,page-size : size of the eeprom page
+
+Examples:
+at25@0 {
+	compatible = "atmel,at25";
+	reg = <0>
+	spi-max-frequency = <5000000>;
+
+	at25,byte-len = <0x8000>;
+	at25,addr-mode = <2>;
+	at25,page-size = <64>;
+};
diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index 0842c29..25003d6 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -19,7 +19,7 @@
 
 #include <linux/spi/spi.h>
 #include <linux/spi/eeprom.h>
-
+#include <linux/of.h>
 
 /*
  * NOTE: this is an *EEPROM* driver.  The vagaries of product naming
@@ -305,25 +305,54 @@ static ssize_t at25_mem_write(struct memory_accessor *mem, const char *buf,
 static int at25_probe(struct spi_device *spi)
 {
 	struct at25_data	*at25 = NULL;
-	const struct spi_eeprom *chip;
+	struct spi_eeprom	chip;
+	struct device_node	*np = spi->dev.of_node;
 	int			err;
 	int			sr;
 	int			addrlen;
 
 	/* Chip description */
-	chip = spi->dev.platform_data;
-	if (!chip) {
-		dev_dbg(&spi->dev, "no chip description\n");
-		err = -ENODEV;
-		goto fail;
-	}
+	if (!spi->dev.platform_data) {
+		if (np) {
+			u32 val;
+
+			memset(&chip, 0, sizeof(chip));
+			strncpy(chip.name, np->name, 10);
+
+			err = of_property_read_u32(np, "at25,byte-len", &val);
+			if (err) {
+				dev_dbg(&spi->dev, "invalid chip dt description\n");
+				goto fail;
+			}
+			chip.byte_len = val;
+
+			err = of_property_read_u32(np, "at25,addr-mode", &val);
+			if (err) {
+				dev_dbg(&spi->dev, "invalid chip dt description\n");
+				goto fail;
+			}
+			chip.flags = (u16)val;
+
+			err = of_property_read_u32(np, "at25,page-size", &val);
+			if (err) {
+				dev_dbg(&spi->dev, "invalid chip dt description\n");
+				goto fail;
+			}
+			chip.page_size = (u16)val;
+		} else {
+			dev_dbg(&spi->dev, "no chip description\n");
+			err = -ENODEV;
+			goto fail;
+		}
+	} else
+		chip = *(struct spi_eeprom *)spi->dev.platform_data;
 
 	/* For now we only support 8/16/24 bit addressing */
-	if (chip->flags & EE_ADDR1)
+	if (chip.flags & EE_ADDR1)
 		addrlen = 1;
-	else if (chip->flags & EE_ADDR2)
+	else if (chip.flags & EE_ADDR2)
 		addrlen = 2;
-	else if (chip->flags & EE_ADDR3)
+	else if (chip.flags & EE_ADDR3)
 		addrlen = 3;
 	else {
 		dev_dbg(&spi->dev, "unsupported address type\n");
@@ -348,7 +377,7 @@ static int at25_probe(struct spi_device *spi)
 	}
 
 	mutex_init(&at25->lock);
-	at25->chip = *chip;
+	at25->chip = chip;
 	at25->spi = spi_dev_get(spi);
 	dev_set_drvdata(&spi->dev, at25);
 	at25->addrlen = addrlen;
@@ -369,7 +398,7 @@ static int at25_probe(struct spi_device *spi)
 	at25->mem.read = at25_mem_read;
 
 	at25->bin.size = at25->chip.byte_len;
-	if (!(chip->flags & EE_READONLY)) {
+	if (!(chip.flags & EE_READONLY)) {
 		at25->bin.write = at25_bin_write;
 		at25->bin.attr.mode |= S_IWUSR;
 		at25->mem.write = at25_mem_write;
@@ -379,8 +408,8 @@ static int at25_probe(struct spi_device *spi)
 	if (err)
 		goto fail;
 
-	if (chip->setup)
-		chip->setup(&at25->mem, chip->context);
+	if (chip.setup)
+		chip.setup(&at25->mem, chip.context);
 
 	dev_info(&spi->dev, "%Zd %s %s eeprom%s, pagesize %u\n",
 		(at25->bin.size < 1024)
@@ -388,7 +417,7 @@ static int at25_probe(struct spi_device *spi)
 			: (at25->bin.size / 1024),
 		(at25->bin.size < 1024) ? "Byte" : "KByte",
 		at25->chip.name,
-		(chip->flags & EE_READONLY) ? " (readonly)" : "",
+		(chip.flags & EE_READONLY) ? " (readonly)" : "",
 		at25->chip.page_size);
 	return 0;
 fail:
-- 
1.7.10

