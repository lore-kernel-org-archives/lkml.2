Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab1KRKKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:10:10 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:26452 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757534Ab1KRKKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:10:08 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bh8275dhz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
From: <michael.hennerich@analog.com>
To: <greg@kroah.com>, <arnd@arndb.de>
CC: <device-drivers-devel@blackfin.uclinux.org>, <drivers@analog.com>,
        <linux-kernel@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 2/2] misc: ad525x_dpot: Add support for SPI module device table matching
Date: Fri, 18 Nov 2011 11:05:11 +0100
Message-ID: <1321610711-12507-2-git-send-email-michael.hennerich@analog.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321610711-12507-1-git-send-email-michael.hennerich@analog.com>
References: <1321610711-12507-1-git-send-email-michael.hennerich@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Passing device name via platform data, is a leftover from times where
SPI module device table matching was not existent.

* Add id_table and remove old mechanism.
(To my knowledge no intree boards affected)
* Miscellaneous other cleanup.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
---
 drivers/misc/ad525x_dpot-i2c.c |   10 +---
 drivers/misc/ad525x_dpot-spi.c |   97 ++++++++++++++++------------------------
 drivers/misc/ad525x_dpot.c     |   24 +++++-----
 drivers/misc/ad525x_dpot.h     |    8 +---
 4 files changed, 53 insertions(+), 86 deletions(-)

diff --git a/drivers/misc/ad525x_dpot-i2c.c b/drivers/misc/ad525x_dpot-i2c.c
index a39e055..83adab6 100644
--- a/drivers/misc/ad525x_dpot-i2c.c
+++ b/drivers/misc/ad525x_dpot-i2c.c
@@ -1,7 +1,7 @@
 /*
  * Driver for the Analog Devices digital potentiometers (I2C bus)
  *
- * Copyright (C) 2010 Michael Hennerich, Analog Devices Inc.
+ * Copyright (C) 2010-2011 Michael Hennerich, Analog Devices Inc.
  *
  * Licensed under the GPL-2 or later.
  */
@@ -11,7 +11,6 @@
 
 #include "ad525x_dpot.h"
 
-/* ------------------------------------------------------------------------- */
 /* I2C bus functions */
 static int write_d8(void *client, u8 val)
 {
@@ -60,18 +59,13 @@ static int __devinit ad_dpot_i2c_probe(struct i2c_client *client,
 		.bops = &bops,
 	};
 
-	struct ad_dpot_id dpot_id = {
-		.name = (char *) &id->name,
-		.devid = id->driver_data,
-	};
-
 	if (!i2c_check_functionality(client->adapter,
 				     I2C_FUNC_SMBUS_WORD_DATA)) {
 		dev_err(&client->dev, "SMBUS Word Data not Supported\n");
 		return -EIO;
 	}
 
-	return ad_dpot_probe(&client->dev, &bdata, &dpot_id);
+	return ad_dpot_probe(&client->dev, &bdata, id->driver_data, id->name);
 }
 
 static int __devexit ad_dpot_i2c_remove(struct i2c_client *client)
diff --git a/drivers/misc/ad525x_dpot-spi.c b/drivers/misc/ad525x_dpot-spi.c
index 7f9a55a..822749e 100644
--- a/drivers/misc/ad525x_dpot-spi.c
+++ b/drivers/misc/ad525x_dpot-spi.c
@@ -1,7 +1,7 @@
 /*
  * Driver for the Analog Devices digital potentiometers (SPI bus)
  *
- * Copyright (C) 2010 Michael Hennerich, Analog Devices Inc.
+ * Copyright (C) 2010-2011 Michael Hennerich, Analog Devices Inc.
  *
  * Licensed under the GPL-2 or later.
  */
@@ -11,40 +11,6 @@
 
 #include "ad525x_dpot.h"
 
-static const struct ad_dpot_id ad_dpot_spi_devlist[] = {
-	{.name = "ad5160", .devid = AD5160_ID},
-	{.name = "ad5161", .devid = AD5161_ID},
-	{.name = "ad5162", .devid = AD5162_ID},
-	{.name = "ad5165", .devid = AD5165_ID},
-	{.name = "ad5200", .devid = AD5200_ID},
-	{.name = "ad5201", .devid = AD5201_ID},
-	{.name = "ad5203", .devid = AD5203_ID},
-	{.name = "ad5204", .devid = AD5204_ID},
-	{.name = "ad5206", .devid = AD5206_ID},
-	{.name = "ad5207", .devid = AD5207_ID},
-	{.name = "ad5231", .devid = AD5231_ID},
-	{.name = "ad5232", .devid = AD5232_ID},
-	{.name = "ad5233", .devid = AD5233_ID},
-	{.name = "ad5235", .devid = AD5235_ID},
-	{.name = "ad5260", .devid = AD5260_ID},
-	{.name = "ad5262", .devid = AD5262_ID},
-	{.name = "ad5263", .devid = AD5263_ID},
-	{.name = "ad5290", .devid = AD5290_ID},
-	{.name = "ad5291", .devid = AD5291_ID},
-	{.name = "ad5292", .devid = AD5292_ID},
-	{.name = "ad5293", .devid = AD5293_ID},
-	{.name = "ad7376", .devid = AD7376_ID},
-	{.name = "ad8400", .devid = AD8400_ID},
-	{.name = "ad8402", .devid = AD8402_ID},
-	{.name = "ad8403", .devid = AD8403_ID},
-	{.name = "adn2850", .devid = ADN2850_ID},
-	{.name = "ad5270", .devid = AD5270_ID},
-	{.name = "ad5271", .devid = AD5271_ID},
-	{}
-};
-
-/* ------------------------------------------------------------------------- */
-
 /* SPI bus functions */
 static int write8(void *client, u8 val)
 {
@@ -109,36 +75,16 @@ static const struct ad_dpot_bus_ops bops = {
 	.write_r8d8	= write16,
 	.write_r8d16	= write24,
 };
-
-static const struct ad_dpot_id *dpot_match_id(const struct ad_dpot_id *id,
-						char *name)
-{
-	while (id->name && id->name[0]) {
-		if (strcmp(name, id->name) == 0)
-			return id;
-		id++;
-	}
-	return NULL;
-}
-
 static int __devinit ad_dpot_spi_probe(struct spi_device *spi)
 {
-	char *name = spi->dev.platform_data;
-	const struct ad_dpot_id *dpot_id;
-
 	struct ad_dpot_bus_data bdata = {
 		.client = spi,
 		.bops = &bops,
 	};
 
-	dpot_id = dpot_match_id(ad_dpot_spi_devlist, name);
-
-	if (dpot_id == NULL) {
-		dev_err(&spi->dev, "%s not in supported device list", name);
-		return -ENODEV;
-	}
-
-	return ad_dpot_probe(&spi->dev, &bdata, dpot_id);
+	return ad_dpot_probe(&spi->dev, &bdata,
+			     spi_get_device_id(spi)->driver_data,
+			     spi_get_device_id(spi)->name);
 }
 
 static int __devexit ad_dpot_spi_remove(struct spi_device *spi)
@@ -146,14 +92,47 @@ static int __devexit ad_dpot_spi_remove(struct spi_device *spi)
 	return ad_dpot_remove(&spi->dev);
 }
 
+static const struct spi_device_id ad_dpot_spi_id[] = {
+	{"ad5160", AD5160_ID},
+	{"ad5161", AD5161_ID},
+	{"ad5162", AD5162_ID},
+	{"ad5165", AD5165_ID},
+	{"ad5200", AD5200_ID},
+	{"ad5201", AD5201_ID},
+	{"ad5203", AD5203_ID},
+	{"ad5204", AD5204_ID},
+	{"ad5206", AD5206_ID},
+	{"ad5207", AD5207_ID},
+	{"ad5231", AD5231_ID},
+	{"ad5232", AD5232_ID},
+	{"ad5233", AD5233_ID},
+	{"ad5235", AD5235_ID},
+	{"ad5260", AD5260_ID},
+	{"ad5262", AD5262_ID},
+	{"ad5263", AD5263_ID},
+	{"ad5290", AD5290_ID},
+	{"ad5291", AD5291_ID},
+	{"ad5292", AD5292_ID},
+	{"ad5293", AD5293_ID},
+	{"ad7376", AD7376_ID},
+	{"ad8400", AD8400_ID},
+	{"ad8402", AD8402_ID},
+	{"ad8403", AD8403_ID},
+	{"adn2850", ADN2850_ID},
+	{"ad5270", AD5270_ID},
+	{"ad5271", AD5271_ID},
+	{}
+};
+MODULE_DEVICE_TABLE(spi, ad_dpot_spi_id);
+
 static struct spi_driver ad_dpot_spi_driver = {
 	.driver = {
 		.name	= "ad_dpot",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= ad_dpot_spi_probe,
 	.remove		= __devexit_p(ad_dpot_spi_remove),
+	.id_table	= ad_dpot_spi_id,
 };
 
 static int __init ad_dpot_spi_init(void)
diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index 7cb9110..1d1d426 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -64,7 +64,7 @@
  * Author: Chris Verges <chrisv@cyberswitching.com>
  *
  * derived from ad5252.c
- * Copyright (c) 2006 Michael Hennerich <hennerich@blackfin.uclinux.org>
+ * Copyright (c) 2006-2011 Michael Hennerich <hennerich@blackfin.uclinux.org>
  *
  * Licensed under the GPL-2 or later.
  */
@@ -76,8 +76,6 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 
-#define DRIVER_VERSION			"0.2"
-
 #include "ad525x_dpot.h"
 
 /*
@@ -687,8 +685,9 @@ inline void ad_dpot_remove_files(struct device *dev,
 	}
 }
 
-__devinit int ad_dpot_probe(struct device *dev,
-		struct ad_dpot_bus_data *bdata, const struct ad_dpot_id *id)
+int __devinit ad_dpot_probe(struct device *dev,
+		struct ad_dpot_bus_data *bdata, unsigned long devid,
+			    const char *name)
 {
 
 	struct dpot_data *data;
@@ -704,13 +703,13 @@ __devinit int ad_dpot_probe(struct device *dev,
 	mutex_init(&data->update_lock);
 
 	data->bdata = *bdata;
-	data->devid = id->devid;
+	data->devid = devid;
 
-	data->max_pos = 1 << DPOT_MAX_POS(data->devid);
+	data->max_pos = 1 << DPOT_MAX_POS(devid);
 	data->rdac_mask = data->max_pos - 1;
-	data->feat = DPOT_FEAT(data->devid);
-	data->uid = DPOT_UID(data->devid);
-	data->wipers = DPOT_WIPERS(data->devid);
+	data->feat = DPOT_FEAT(devid);
+	data->uid = DPOT_UID(devid);
+	data->wipers = DPOT_WIPERS(devid);
 
 	for (i = DPOT_RDAC0; i < MAX_RDACS; i++)
 		if (data->wipers & (1 << i)) {
@@ -731,7 +730,7 @@ __devinit int ad_dpot_probe(struct device *dev,
 	}
 
 	dev_info(dev, "%s %d-Position Digital Potentiometer registered\n",
-		 id->name, data->max_pos);
+		 name, data->max_pos);
 
 	return 0;
 
@@ -745,7 +744,7 @@ exit_free:
 	dev_set_drvdata(dev, NULL);
 exit:
 	dev_err(dev, "failed to create client for %s ID 0x%lX\n",
-			id->name, id->devid);
+		name, devid);
 	return err;
 }
 EXPORT_SYMBOL(ad_dpot_probe);
@@ -770,4 +769,3 @@ MODULE_AUTHOR("Chris Verges <chrisv@cyberswitching.com>, "
 	      "Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("Digital potentiometer driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRIVER_VERSION);
diff --git a/drivers/misc/ad525x_dpot.h b/drivers/misc/ad525x_dpot.h
index 82b2cb7..6bd1eba 100644
--- a/drivers/misc/ad525x_dpot.h
+++ b/drivers/misc/ad525x_dpot.h
@@ -208,12 +208,8 @@ struct ad_dpot_bus_data {
 	const struct ad_dpot_bus_ops *bops;
 };
 
-struct ad_dpot_id {
-	char *name;
-	unsigned long devid;
-};
-
-int ad_dpot_probe(struct device *dev, struct ad_dpot_bus_data *bdata, const struct ad_dpot_id *id);
+int ad_dpot_probe(struct device *dev, struct ad_dpot_bus_data *bdata,
+		  unsigned long devid, const char *name);
 int ad_dpot_remove(struct device *dev);
 
 #endif
-- 
1.7.0.4


