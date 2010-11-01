Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab0KASiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:38:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55969 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752092Ab0KASiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:38:05 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Add initial WM8958 support
Date: Mon,  1 Nov 2010 14:20:11 -0400
Message-Id: <1288635611-25560-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8958 is a derivative of the WM8994 which is register compatible
with the addition of some extra features, mostly in the CODEC side.
The major change visible at the MFD level is that rather than a single
DBVDD supply we now have three separate DBVDDs so we must request and
enable a different set of supplies.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Since subsequent CODEC patches will depend on this I'd like to merge via
ASoC if possible.

 drivers/mfd/wm8994-core.c       |   93 +++++++++++++++++++++++++++++++--------
 include/linux/mfd/wm8994/core.h |    8 +++
 2 files changed, 82 insertions(+), 19 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index b3b2aaf..8d221ba 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -218,6 +218,18 @@ static const char *wm8994_main_supplies[] = {
 	"SPKVDD2",
 };
 
+static const char *wm8958_main_supplies[] = {
+	"DBVDD1",
+	"DBVDD2",
+	"DBVDD3",
+	"DCVDD",
+	"AVDD1",
+	"AVDD2",
+	"CPVDD",
+	"SPKVDD1",
+	"SPKVDD2",
+};
+
 #ifdef CONFIG_PM
 static int wm8994_device_suspend(struct device *dev)
 {
@@ -239,7 +251,7 @@ static int wm8994_device_suspend(struct device *dev)
 	if (ret < 0)
 		dev_err(dev, "Failed to save LDO registers: %d\n", ret);
 
-	ret = regulator_bulk_disable(ARRAY_SIZE(wm8994_main_supplies),
+	ret = regulator_bulk_disable(wm8994->num_supplies,
 				     wm8994->supplies);
 	if (ret != 0) {
 		dev_err(dev, "Failed to disable supplies: %d\n", ret);
@@ -254,7 +266,7 @@ static int wm8994_device_resume(struct device *dev)
 	struct wm8994 *wm8994 = dev_get_drvdata(dev);
 	int ret;
 
-	ret = regulator_bulk_enable(ARRAY_SIZE(wm8994_main_supplies),
+	ret = regulator_bulk_enable(wm8994->num_supplies,
 				    wm8994->supplies);
 	if (ret != 0) {
 		dev_err(dev, "Failed to enable supplies: %d\n", ret);
@@ -305,9 +317,10 @@ static int wm8994_ldo_in_use(struct wm8994_pdata *pdata, int ldo)
 /*
  * Instantiate the generic non-control parts of the device.
  */
-static int wm8994_device_init(struct wm8994 *wm8994, unsigned long id, int irq)
+static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 {
 	struct wm8994_pdata *pdata = wm8994->dev->platform_data;
+	const char *devname;
 	int ret, i;
 
 	mutex_init(&wm8994->io_lock);
@@ -323,25 +336,48 @@ static int wm8994_device_init(struct wm8994 *wm8994, unsigned long id, int irq)
 		goto err;
 	}
 
+	switch (wm8994->type) {
+	case WM8994:
+		wm8994->num_supplies = ARRAY_SIZE(wm8994_main_supplies);
+		break;
+	case WM8958:
+		wm8994->num_supplies = ARRAY_SIZE(wm8958_main_supplies);
+		break;
+	default:
+		BUG();
+		return -EINVAL;
+	}
+
 	wm8994->supplies = kzalloc(sizeof(struct regulator_bulk_data) *
-				   ARRAY_SIZE(wm8994_main_supplies),
+				   wm8994->num_supplies,
 				   GFP_KERNEL);
 	if (!wm8994->supplies) {
 		ret = -ENOMEM;
 		goto err;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(wm8994_main_supplies); i++)
-		wm8994->supplies[i].supply = wm8994_main_supplies[i];
-
-	ret = regulator_bulk_get(wm8994->dev, ARRAY_SIZE(wm8994_main_supplies),
+	switch (wm8994->type) {
+	case WM8994:
+		for (i = 0; i < ARRAY_SIZE(wm8994_main_supplies); i++)
+			wm8994->supplies[i].supply = wm8994_main_supplies[i];
+		break;
+	case WM8958:
+		for (i = 0; i < ARRAY_SIZE(wm8958_main_supplies); i++)
+			wm8994->supplies[i].supply = wm8958_main_supplies[i];
+		break;
+	default:
+		BUG();
+		return -EINVAL;
+	}
+		
+	ret = regulator_bulk_get(wm8994->dev, wm8994->num_supplies,
 				 wm8994->supplies);
 	if (ret != 0) {
 		dev_err(wm8994->dev, "Failed to get supplies: %d\n", ret);
 		goto err_supplies;
 	}
 
-	ret = regulator_bulk_enable(ARRAY_SIZE(wm8994_main_supplies),
+	ret = regulator_bulk_enable(wm8994->num_supplies,
 				    wm8994->supplies);
 	if (ret != 0) {
 		dev_err(wm8994->dev, "Failed to enable supplies: %d\n", ret);
@@ -353,7 +389,22 @@ static int wm8994_device_init(struct wm8994 *wm8994, unsigned long id, int irq)
 		dev_err(wm8994->dev, "Failed to read ID register\n");
 		goto err_enable;
 	}
-	if (ret != 0x8994) {
+	switch (ret) {
+	case 0x8994:
+		devname = "WM8994";
+		if (wm8994->type != WM8994)
+			dev_warn(wm8994->dev, "Device registered as type %d\n",
+				 wm8994->type);
+		wm8994->type = WM8994;
+		break;
+	case 0x8958:
+		devname = "WM8958";
+		if (wm8994->type != WM8958)
+			dev_warn(wm8994->dev, "Device registered as type %d\n",
+				 wm8994->type);
+		wm8994->type = WM8958;
+		break;
+	default:
 		dev_err(wm8994->dev, "Device is not a WM8994, ID is %x\n",
 			ret);
 		ret = -EINVAL;
@@ -370,14 +421,16 @@ static int wm8994_device_init(struct wm8994 *wm8994, unsigned long id, int irq)
 	switch (ret) {
 	case 0:
 	case 1:
-		dev_warn(wm8994->dev, "revision %c not fully supported\n",
-			'A' + ret);
+		if (wm8994->type == WM8994)
+			dev_warn(wm8994->dev,
+				 "revision %c not fully supported\n",
+				 'A' + ret);
 		break;
 	default:
-		dev_info(wm8994->dev, "revision %c\n", 'A' + ret);
 		break;
 	}
 
+	dev_info(wm8994->dev, "%s revision %c\n", devname, 'A' + ret);
 
 	if (pdata) {
 		wm8994->irq_base = pdata->irq_base;
@@ -423,10 +476,10 @@ static int wm8994_device_init(struct wm8994 *wm8994, unsigned long id, int irq)
 err_irq:
 	wm8994_irq_exit(wm8994);
 err_enable:
-	regulator_bulk_disable(ARRAY_SIZE(wm8994_main_supplies),
+	regulator_bulk_disable(wm8994->num_supplies,
 			       wm8994->supplies);
 err_get:
-	regulator_bulk_free(ARRAY_SIZE(wm8994_main_supplies), wm8994->supplies);
+	regulator_bulk_free(wm8994->num_supplies, wm8994->supplies);
 err_supplies:
 	kfree(wm8994->supplies);
 err:
@@ -439,9 +492,9 @@ static void wm8994_device_exit(struct wm8994 *wm8994)
 {
 	mfd_remove_devices(wm8994->dev);
 	wm8994_irq_exit(wm8994);
-	regulator_bulk_disable(ARRAY_SIZE(wm8994_main_supplies),
+	regulator_bulk_disable(wm8994->num_supplies,
 			       wm8994->supplies);
-	regulator_bulk_free(ARRAY_SIZE(wm8994_main_supplies), wm8994->supplies);
+	regulator_bulk_free(wm8994->num_supplies, wm8994->supplies);
 	kfree(wm8994->supplies);
 	kfree(wm8994);
 }
@@ -506,8 +559,9 @@ static int wm8994_i2c_probe(struct i2c_client *i2c,
 	wm8994->read_dev = wm8994_i2c_read_device;
 	wm8994->write_dev = wm8994_i2c_write_device;
 	wm8994->irq = i2c->irq;
+	wm8994->type = id->driver_data;
 
-	return wm8994_device_init(wm8994, id->driver_data, i2c->irq);
+	return wm8994_device_init(wm8994, i2c->irq);
 }
 
 static int wm8994_i2c_remove(struct i2c_client *i2c)
@@ -535,7 +589,8 @@ static int wm8994_i2c_resume(struct i2c_client *i2c)
 #endif
 
 static const struct i2c_device_id wm8994_i2c_id[] = {
-	{ "wm8994", 0 },
+	{ "wm8994", WM8994 },
+	{ "wm8958", WM8958 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, wm8994_i2c_id);
diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
index de79bae..3fd3684 100644
--- a/include/linux/mfd/wm8994/core.h
+++ b/include/linux/mfd/wm8994/core.h
@@ -17,6 +17,11 @@
 
 #include <linux/interrupt.h>
 
+enum wm8994_type {
+	WM8994 = 0,
+	WM8958 = 1,
+};
+
 struct regulator_dev;
 struct regulator_bulk_data;
 
@@ -48,6 +53,8 @@ struct wm8994 {
 	struct mutex io_lock;
 	struct mutex irq_lock;
 
+	enum wm8994_type type;
+
 	struct device *dev;
 	int (*read_dev)(struct wm8994 *wm8994, unsigned short reg,
 			int bytes, void *dest);
@@ -68,6 +75,7 @@ struct wm8994 {
 	u16 gpio_regs[WM8994_NUM_GPIO_REGS];
 
 	struct regulator_dev *dbvdd;
+	int num_supplies;
 	struct regulator_bulk_data *supplies;
 };
 
-- 
1.7.1

