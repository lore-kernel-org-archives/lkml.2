Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab2JEILs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:11:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55641 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab2JEILl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:11:41 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/28] leds-lp55xx: cleanup init device function
Thread-Topic: [PATCH 04/28] leds-lp55xx: cleanup init device function
Thread-Index: Ac2i0QeHZWMEa64NTDC28gDTQIZaew==
Date: Fri, 5 Oct 2012 08:11:32 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64176720@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 LP5521 and LP5523 devices have same sequence of initializing device.
 (1) Call setup_resources() of platform data
 (2) Call enable()
 (3) Reset the device
 (4) Detect the device using ENABLE register access

 Those are merged into one function, lp55xx_init_device().
 The setup_resources(), enable() are moved to this function.
 Reset and detection are handled in this function with chip configuration data.
 The lp55xx_device_config is used for this purpose.
 Two pairs of register address and value are defined in each driver.
 To reset the device  : reset register  (address, value)
 To detect the device : enable register (address, value)

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c        |   65 +++++++++-------------------
 drivers/leds/leds-lp5523.c        |   54 ++++++++---------------
 drivers/leds/leds-lp55xx-common.c |   85 +++++++++++++++++++++++++++++++++++++
 drivers/leds/leds-lp55xx-common.h |    2 +
 4 files changed, 124 insertions(+), 82 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 3735038..5beba13 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -98,6 +98,9 @@
 /* Pattern Mode */
 #define PATTERN_OFF	0
 
+/* Reset register value */
+#define LP5521_RESET			0xFF
+
 struct lp5521_engine {
 	int		id;
 	u8		mode;
@@ -306,26 +309,6 @@ static void lp5521_led_brightness_work(struct work_struct *work)
 	mutex_unlock(&chip->lock);
 }
 
-/* Detect the chip by setting its ENABLE register and reading it back. */
-static int lp5521_detect(struct i2c_client *client)
-{
-	int ret;
-	u8 buf;
-
-	ret = lp5521_write(client, LP5521_REG_ENABLE, LP5521_ENABLE_DEFAULT);
-	if (ret)
-		return ret;
-	/* enable takes 500us. 1 - 2 ms leaves some margin */
-	usleep_range(1000, 2000);
-	ret = lp5521_read(client, LP5521_REG_ENABLE, &buf);
-	if (ret)
-		return ret;
-	if (buf != LP5521_ENABLE_DEFAULT)
-		return -ENODEV;
-
-	return 0;
-}
-
 /* Set engine mode and create appropriate sysfs attributes, if required. */
 static int lp5521_set_mode(struct lp5521_engine *engine, u8 mode)
 {
@@ -739,6 +722,18 @@ static int __devinit lp5521_init_led(struct lp5521_led *led,
 	return 0;
 }
 
+/* Chip specific configurations */
+static struct lp55xx_device_config lp5521_cfg = {
+	.reset = {
+		.addr = LP5521_REG_RESET,
+		.val  = LP5521_RESET,
+	},
+	.enable = {
+		.addr = LP5521_REG_ENABLE,
+		.val  = LP5521_ENABLE_DEFAULT,
+	},
+};
+
 static int __devinit lp5521_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -766,29 +761,15 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 
 	chip->cl = client;
 	chip->pdata = pdata;
+	chip->cfg = &lp5521_cfg;
 
 	mutex_init(&chip->lock);
 
 	i2c_set_clientdata(client, led);
 
-	if (old_pdata->setup_resources) {
-		ret = old_pdata->setup_resources();
-		if (ret < 0)
-			return ret;
-	}
-
-	if (old_pdata->enable) {
-		old_pdata->enable(0);
-		usleep_range(1000, 2000); /* Keep enable down at least 1ms */
-		old_pdata->enable(1);
-		usleep_range(1000, 2000); /* 500us abs min. */
-	}
-
-	lp5521_write(client, LP5521_REG_RESET, 0xff);
-	usleep_range(10000, 20000); /*
-				     * Exact value is not available. 10 - 20ms
-				     * appears to be enough for reset.
-				     */
+	ret = lp55xx_init_device(chip);
+	if (ret)
+		goto err_init;
 
 	/*
 	 * Make sure that the chip is reset by reading back the r channel
@@ -803,13 +784,6 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	}
 	usleep_range(10000, 20000);
 
-	ret = lp5521_detect(client);
-
-	if (ret) {
-		dev_err(&client->dev, "Chip not found\n");
-		goto fail2;
-	}
-
 	dev_info(&client->dev, "%s programmable led chip found\n", id->name);
 
 	ret = lp5521_configure(client);
@@ -861,6 +835,7 @@ fail1:
 		old_pdata->enable(0);
 	if (old_pdata->release_resources)
 		old_pdata->release_resources();
+err_init:
 	return ret;
 }
 
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 91f42fc..a602888 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -87,6 +87,7 @@
 #define LP5523_AUTO_CLK			0x02
 #define LP5523_EN_LEDTEST		0x80
 #define LP5523_LEDTEST_DONE		0x80
+#define LP5523_RESET			0xFF
 
 #define LP5523_DEFAULT_CURRENT		50 /* microAmps */
 #define LP5523_PROGRAM_LENGTH		32 /* in bytes */
@@ -180,23 +181,6 @@ static int lp5523_read(struct i2c_client *client, u8 reg, u8 *buf)
 	return 0;
 }
 
-static int lp5523_detect(struct i2c_client *client)
-{
-	int ret;
-	u8 buf;
-
-	ret = lp5523_write(client, LP5523_REG_ENABLE, LP5523_ENABLE);
-	if (ret)
-		return ret;
-	ret = lp5523_read(client, LP5523_REG_ENABLE, &buf);
-	if (ret)
-		return ret;
-	if (buf == 0x40)
-		return 0;
-	else
-		return -ENODEV;
-}
-
 static int lp5523_configure(struct i2c_client *client)
 {
 	struct lp5523_chip *chip = i2c_get_clientdata(client);
@@ -885,6 +869,18 @@ static int __devinit lp5523_init_led(struct lp5523_led *led, struct device *dev,
 	return 0;
 }
 
+/* Chip specific configurations */
+static struct lp55xx_device_config lp5523_cfg = {
+	.reset = {
+		.addr = LP5523_REG_RESET,
+		.val  = LP5523_RESET,
+	},
+	.enable = {
+		.addr = LP5523_REG_ENABLE,
+		.val  = LP5523_ENABLE,
+	},
+};
+
 static int __devinit lp5523_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -911,32 +907,15 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 
 	chip->cl = client;
 	chip->pdata = pdata;
+	chip->cfg = &lp5523_cfg;
 
 	mutex_init(&chip->lock);
 
 	i2c_set_clientdata(client, led);
 
-	if (old_pdata->setup_resources) {
-		ret = old_pdata->setup_resources();
-		if (ret < 0)
-			return ret;
-	}
-
-	if (old_pdata->enable) {
-		old_pdata->enable(0);
-		usleep_range(1000, 2000); /* Keep enable down at least 1ms */
-		old_pdata->enable(1);
-		usleep_range(1000, 2000); /* 500us abs min. */
-	}
-
-	lp5523_write(client, LP5523_REG_RESET, 0xff);
-	usleep_range(10000, 20000); /*
-				     * Exact value is not available. 10 - 20ms
-				     * appears to be enough for reset.
-				     */
-	ret = lp5523_detect(client);
+	ret = lp55xx_init_device(chip);
 	if (ret)
-		goto fail1;
+		goto err_init;
 
 	dev_info(&client->dev, "%s Programmable led chip found\n", id->name);
 
@@ -999,6 +978,7 @@ fail1:
 		old_pdata->enable(0);
 	if (old_pdata->release_resources)
 		old_pdata->release_resources();
+err_init:
 	return ret;
 }
 
diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index 58c5fb8..22a9643 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -10,6 +10,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/leds.h>
 #include <linux/module.h>
@@ -17,6 +18,39 @@
 
 #include "leds-lp55xx-common.h"
 
+static void lp55xx_reset_device(struct lp55xx_chip *chip)
+{
+	struct lp55xx_device_config *cfg = chip->cfg;
+	u8 addr = cfg->reset.addr;
+	u8 val  = cfg->reset.val;
+
+	/* no error checking here because no ACK from the device after reset */
+	lp55xx_write(chip, addr, val);
+}
+
+static int lp55xx_detect_device(struct lp55xx_chip *chip)
+{
+	struct lp55xx_device_config *cfg = chip->cfg;
+	u8 addr = cfg->enable.addr;
+	u8 val  = cfg->enable.val;
+	int ret;
+
+	ret = lp55xx_write(chip, addr, val);
+	if (ret)
+		return ret;
+
+	usleep_range(1000, 2000);
+
+	ret = lp55xx_read(chip, addr, &val);
+	if (ret)
+		return ret;
+
+	if (val != cfg->enable.val)
+		return -ENODEV;
+
+	return 0;
+}
+
 int lp55xx_write(struct lp55xx_chip *chip, u8 reg, u8 val)
 {
 	return i2c_smbus_write_byte_data(chip->cl, reg, val);
@@ -63,3 +97,54 @@ struct lp55xx_led *dev_to_lp55xx_led(struct device *dev)
 	return cdev_to_lp55xx_led(dev_get_drvdata(dev));
 }
 EXPORT_SYMBOL_GPL(dev_to_lp55xx_led);
+
+int lp55xx_init_device(struct lp55xx_chip *chip)
+{
+	struct lp55xx_platform_data *pdata;
+	struct lp55xx_device_config *cfg;
+	struct device *dev = &chip->cl->dev;
+	int ret;
+
+	WARN_ON(!chip);
+
+	pdata = chip->pdata;
+	cfg = chip->cfg;
+
+	if (!pdata || !cfg)
+		return -EINVAL;
+
+	if (pdata->setup_resources) {
+		ret = pdata->setup_resources();
+		if (ret < 0) {
+			dev_err(dev, "setup resoure err: %d\n", ret);
+			goto err;
+		}
+	}
+
+	if (pdata->enable) {
+		pdata->enable(0);
+		usleep_range(1000, 2000); /* Keep enable down at least 1ms */
+		pdata->enable(1);
+		usleep_range(1000, 2000); /* 500us abs min. */
+	}
+
+	lp55xx_reset_device(chip);
+
+	/*
+	 * Exact value is not available. 10 - 20ms
+	 * appears to be enough for reset.
+	 */
+	usleep_range(10000, 20000);
+
+	ret = lp55xx_detect_device(chip);
+	if (ret) {
+		dev_err(dev, "device detection err: %d\n", ret);
+		goto err;
+	}
+
+	return 0;
+
+err:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lp55xx_init_device);
diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
index 91a6afc..0ecc79b 100644
--- a/drivers/leds/leds-lp55xx-common.h
+++ b/drivers/leds/leds-lp55xx-common.h
@@ -121,4 +121,6 @@ extern int lp55xx_update_bits(struct lp55xx_chip *chip, u8 reg,
 extern struct lp55xx_led *cdev_to_lp55xx_led(struct led_classdev *cdev);
 extern struct lp55xx_led *dev_to_lp55xx_led(struct device *dev);
 
+extern int lp55xx_init_device(struct lp55xx_chip *chip);
+
 #endif /* __LINUX_LP55XX_COMMON_H */
-- 
1.7.9.5


Best Regards,
Milo


