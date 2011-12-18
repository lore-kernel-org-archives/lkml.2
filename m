Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab1LRSOR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 13:14:17 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51560 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab1LRSOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 13:14:15 -0500
From: Frederic LAMBERT <frdrc66@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Frederic Lambert <frdrc66@gmail.com>
Subject: [PATCH] at25: DeviceTree support added
Date: Sun, 18 Dec 2011 19:13:55 +0100
Message-Id: <1324232035-2717-1-git-send-email-frdrc66@gmail.com>
X-Mailer: git-send-email 1.7.4.1
X-Antivirus: avast! (VPS 111218-0, 18/12/2011), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Lambert <frdrc66@gmail.com>

Signed-off-by: Frederic Lambert <frdrc66@gmail.com>
Signed-off-by: Frederic LAMBERT <frdrc66@gmail.com>
---
 Documentation/devicetree/bindings/spi/spi-bus.txt |   19 ++++++
 drivers/misc/eeprom/at25.c                        |   62 ++++++++++++++++----
 2 files changed, 68 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/spi-bus.txt b/Documentation/devicetree/bindings/spi/spi-bus.txt
index e782add..168ac87 100644
--- a/Documentation/devicetree/bindings/spi/spi-bus.txt
+++ b/Documentation/devicetree/bindings/spi/spi-bus.txt
@@ -33,6 +33,16 @@ contain the following properties.
     		shifted clock phase (CPHA) mode
 - spi-cs-high     - (optional) Empty property indicating device requires
     		chip select active high
+For SPI eeprom using driver 'at25', slave nodes shall also contain the
+following properties.
+- byte_len        - device RAM size
+- dev_name        - device name
+- pagesize        - for writes (see at25.c)
+- flags           - adressing mode and R/O flag
+      - bit 0:  8 bits addrs (EE_ADDR1)
+      - bit 1: 16 bits addrs (EE_ADDR2)
+      - bit 2: 24 bits addrs (EE_ADDR3)
+      - bit 3: disallow writes (EE_READONLY)
 
 SPI example for an MPC5200 SPI bus:
 	spi@f00 {
@@ -54,4 +64,13 @@ SPI example for an MPC5200 SPI bus:
 			spi-max-frequency = <100000>;
 			reg = <1>;
 		};
+		at25@0 {
+			compatible = "eeprom,at25";
+			spi-max-frequency = <2500000>;
+			reg = <3>;
+			byte_len = <131072>;
+			dev_name = "CY14B101P";
+			pagesize = <128>;
+			flags = <4>; // EE_ADDR3
+		};
 	};
diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index c627e41..b4dd9f0 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -16,11 +16,11 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/sched.h>
+#include <linux/of.h>
 
 #include <linux/spi/spi.h>
 #include <linux/spi/eeprom.h>
 
-
 /*
  * NOTE: this is an *EEPROM* driver.  The vagaries of product naming
  * mean that some AT25 products are EEPROMs, and others are FLASH.
@@ -288,29 +288,65 @@ static ssize_t at25_mem_write(struct memory_accessor *mem, const char *buf,
 }
 
 /*-------------------------------------------------------------------------*/
-
 static int at25_probe(struct spi_device *spi)
 {
 	struct at25_data	*at25 = NULL;
-	const struct spi_eeprom *chip;
+	struct spi_eeprom	chip;
 	int			err;
 	int			sr;
 	int			addrlen;
 
 	/* Chip description */
-	chip = spi->dev.platform_data;
-	if (!chip) {
+	if (spi->dev.platform_data) {
+
+		chip = *(struct spi_eeprom *)spi->dev.platform_data;
+	} else {
+#ifdef CONFIG_OF
+		const char	*dev_name;
+		int		len;
+		u32		value;
+
+		/* get FLAGS property from device tree */
+		err = of_property_read_u32(spi->dev.of_node, "flags", &value);
+		if (err) {
+			dev_dbg(&spi->dev, "unsupported address type\n");
+			goto fail;
+		}
+		chip.flags = value;
+		err = of_property_read_u32(spi->dev.of_node, "byte_len",
+					   &chip.byte_len);
+		if (err) {
+			dev_dbg(&spi->dev, "byte_len missing from devtree\n");
+			goto fail;
+		}
+		err = of_property_read_u32(spi->dev.of_node, "pagesize",
+					   &value);
+		if (err) {
+			dev_dbg(&spi->dev, "pagesize missing from devtre\n");
+			goto fail;
+		}
+		chip.page_size = value;
+		dev_name = of_get_property(spi->dev.of_node, "dev_name", &len);
+		if (!dev_name || len > sizeof(chip.name)) {
+			err = -ENODEV;
+			dev_dbg(&spi->dev, "dev_name missing from devtree\n");
+			goto fail;
+		}
+		strcpy(chip.name, dev_name);
+		chip.setup = 0;
+#else
 		dev_dbg(&spi->dev, "no chip description\n");
 		err = -ENODEV;
 		goto fail;
+#endif
 	}
 
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
@@ -335,7 +371,7 @@ static int at25_probe(struct spi_device *spi)
 	}
 
 	mutex_init(&at25->lock);
-	at25->chip = *chip;
+	at25->chip = chip;
 	at25->spi = spi_dev_get(spi);
 	dev_set_drvdata(&spi->dev, at25);
 	at25->addrlen = addrlen;
@@ -356,7 +392,7 @@ static int at25_probe(struct spi_device *spi)
 	at25->mem.read = at25_mem_read;
 
 	at25->bin.size = at25->chip.byte_len;
-	if (!(chip->flags & EE_READONLY)) {
+	if (!(chip.flags & EE_READONLY)) {
 		at25->bin.write = at25_bin_write;
 		at25->bin.attr.mode |= S_IWUSR;
 		at25->mem.write = at25_mem_write;
@@ -366,8 +402,8 @@ static int at25_probe(struct spi_device *spi)
 	if (err)
 		goto fail;
 
-	if (chip->setup)
-		chip->setup(&at25->mem, chip->context);
+	if (chip.setup)
+		chip.setup(&at25->mem, chip.context);
 
 	dev_info(&spi->dev, "%Zd %s %s eeprom%s, pagesize %u\n",
 		(at25->bin.size < 1024)
@@ -375,7 +411,7 @@ static int at25_probe(struct spi_device *spi)
 			: (at25->bin.size / 1024),
 		(at25->bin.size < 1024) ? "Byte" : "KByte",
 		at25->chip.name,
-		(chip->flags & EE_READONLY) ? " (readonly)" : "",
+		(chip.flags & EE_READONLY) ? " (readonly)" : "",
 		at25->chip.page_size);
 	return 0;
 fail:
-- 
1.7.4.1

