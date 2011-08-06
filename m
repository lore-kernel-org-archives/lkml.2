Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab1HFD7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 23:59:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50516 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754774Ab1HFD7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 23:59:07 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] mfd: Convert WM8994 to use new register map API
Date: Sat,  6 Aug 2011 12:58:55 +0900
Message-Id: <1312603135-21590-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1312603135-21590-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110806035806.GA21557@opensource.wolfsonmicro.com>
 <1312603135-21590-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig             |    1 +
 drivers/mfd/wm8994-core.c       |  178 +++++++-------------------------------
 include/linux/mfd/wm8994/core.h |    9 +--
 3 files changed, 36 insertions(+), 152 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index cfae5c5..a67adcb 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -490,6 +490,7 @@ config MFD_WM8350_I2C
 config MFD_WM8994
 	bool "Support Wolfson Microelectronics WM8994"
 	select MFD_CORE
+	select REGMAP_I2C
 	depends on I2C=y && GENERIC_HARDIRQS
 	help
 	  The WM8994 is a highly integrated hi-fi CODEC designed for
diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 96479c9..bfde4e8 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -16,9 +16,11 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/err.h>
 #include <linux/delay.h>
 #include <linux/mfd/core.h>
 #include <linux/pm_runtime.h>
+#include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
 #include <linux/regulator/machine.h>
 
@@ -29,22 +31,7 @@
 static int wm8994_read(struct wm8994 *wm8994, unsigned short reg,
 		       int bytes, void *dest)
 {
-	int ret, i;
-	u16 *buf = dest;
-
-	BUG_ON(bytes % 2);
-	BUG_ON(bytes <= 0);
-
-	ret = wm8994->read_dev(wm8994, reg, bytes, dest);
-	if (ret < 0)
-		return ret;
-
-	for (i = 0; i < bytes / 2; i++) {
-		dev_vdbg(wm8994->dev, "Read %04x from R%d(0x%x)\n",
-			 be16_to_cpu(buf[i]), reg + i, reg + i);
-	}
-
-	return 0;
+	return regmap_raw_read(wm8994->regmap, reg, dest, bytes);
 }
 
 /**
@@ -55,19 +42,15 @@ static int wm8994_read(struct wm8994 *wm8994, unsigned short reg,
  */
 int wm8994_reg_read(struct wm8994 *wm8994, unsigned short reg)
 {
-	unsigned short val;
+	unsigned int val;
 	int ret;
 
-	mutex_lock(&wm8994->io_lock);
-
-	ret = wm8994_read(wm8994, reg, 2, &val);
-
-	mutex_unlock(&wm8994->io_lock);
+	ret = regmap_read(wm8994->regmap, reg, &val);
 
 	if (ret < 0)
 		return ret;
 	else
-		return be16_to_cpu(val);
+		return val;
 }
 EXPORT_SYMBOL_GPL(wm8994_reg_read);
 
@@ -82,33 +65,13 @@ EXPORT_SYMBOL_GPL(wm8994_reg_read);
 int wm8994_bulk_read(struct wm8994 *wm8994, unsigned short reg,
 		     int count, u16 *buf)
 {
-	int ret;
-
-	mutex_lock(&wm8994->io_lock);
-
-	ret = wm8994_read(wm8994, reg, count * 2, buf);
-
-	mutex_unlock(&wm8994->io_lock);
-
-	return ret;
+	return regmap_bulk_read(wm8994->regmap, reg, buf, count);
 }
-EXPORT_SYMBOL_GPL(wm8994_bulk_read);
 
 static int wm8994_write(struct wm8994 *wm8994, unsigned short reg,
 			int bytes, const void *src)
 {
-	const u16 *buf = src;
-	int i;
-
-	BUG_ON(bytes % 2);
-	BUG_ON(bytes <= 0);
-
-	for (i = 0; i < bytes / 2; i++) {
-		dev_vdbg(wm8994->dev, "Write %04x to R%d(0x%x)\n",
-			 be16_to_cpu(buf[i]), reg + i, reg + i);
-	}
-
-	return wm8994->write_dev(wm8994, reg, bytes, src);
+	return regmap_raw_write(wm8994->regmap, reg, src, bytes);
 }
 
 /**
@@ -121,17 +84,7 @@ static int wm8994_write(struct wm8994 *wm8994, unsigned short reg,
 int wm8994_reg_write(struct wm8994 *wm8994, unsigned short reg,
 		     unsigned short val)
 {
-	int ret;
-
-	val = cpu_to_be16(val);
-
-	mutex_lock(&wm8994->io_lock);
-
-	ret = wm8994_write(wm8994, reg, 2, &val);
-
-	mutex_unlock(&wm8994->io_lock);
-
-	return ret;
+	return regmap_write(wm8994->regmap, reg, val);
 }
 EXPORT_SYMBOL_GPL(wm8994_reg_write);
 
@@ -146,15 +99,7 @@ EXPORT_SYMBOL_GPL(wm8994_reg_write);
 int wm8994_bulk_write(struct wm8994 *wm8994, unsigned short reg,
 		      int count, const u16 *buf)
 {
-	int ret;
-
-	mutex_lock(&wm8994->io_lock);
-
-	ret = wm8994_write(wm8994, reg, count * 2, buf);
-
-	mutex_unlock(&wm8994->io_lock);
-
-	return ret;
+	return regmap_raw_write(wm8994->regmap, reg, buf, count * sizeof(u16));
 }
 EXPORT_SYMBOL_GPL(wm8994_bulk_write);
 
@@ -169,28 +114,7 @@ EXPORT_SYMBOL_GPL(wm8994_bulk_write);
 int wm8994_set_bits(struct wm8994 *wm8994, unsigned short reg,
 		    unsigned short mask, unsigned short val)
 {
-	int ret;
-	u16 r;
-
-	mutex_lock(&wm8994->io_lock);
-
-	ret = wm8994_read(wm8994, reg, 2, &r);
-	if (ret < 0)
-		goto out;
-
-	r = be16_to_cpu(r);
-
-	r &= ~mask;
-	r |= val;
-
-	r = cpu_to_be16(r);
-
-	ret = wm8994_write(wm8994, reg, 2, &r);
-
-out:
-	mutex_unlock(&wm8994->io_lock);
-
-	return ret;
+	return regmap_update_bits(wm8994->regmap, reg, mask, val);
 }
 EXPORT_SYMBOL_GPL(wm8994_set_bits);
 
@@ -378,6 +302,11 @@ static int wm8994_ldo_in_use(struct wm8994_pdata *pdata, int ldo)
 }
 #endif
 
+static struct regmap_config wm8994_regmap_config = {
+	.reg_bits = 16,
+	.val_bits = 16,
+};
+
 /*
  * Instantiate the generic non-control parts of the device.
  */
@@ -387,7 +316,6 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 	const char *devname;
 	int ret, i;
 
-	mutex_init(&wm8994->io_lock);
 	dev_set_drvdata(wm8994->dev, wm8994);
 
 	/* Add the on-chip regulators first for bootstrapping */
@@ -397,7 +325,7 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 			      NULL, 0);
 	if (ret != 0) {
 		dev_err(wm8994->dev, "Failed to add children: %d\n", ret);
-		goto err;
+		goto err_regmap;
 	}
 
 	switch (wm8994->type) {
@@ -409,7 +337,7 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		break;
 	default:
 		BUG();
-		goto err;
+		goto err_regmap;
 	}
 
 	wm8994->supplies = kzalloc(sizeof(struct regulator_bulk_data) *
@@ -417,7 +345,7 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 				   GFP_KERNEL);
 	if (!wm8994->supplies) {
 		ret = -ENOMEM;
-		goto err;
+		goto err_regmap;
 	}
 
 	switch (wm8994->type) {
@@ -431,7 +359,7 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		break;
 	default:
 		BUG();
-		goto err;
+		goto err_regmap;
 	}
 		
 	ret = regulator_bulk_get(wm8994->dev, wm8994->num_supplies,
@@ -554,7 +482,8 @@ err_get:
 	regulator_bulk_free(wm8994->num_supplies, wm8994->supplies);
 err_supplies:
 	kfree(wm8994->supplies);
-err:
+err_regmap:
+	regmap_exit(wm8994->regmap);
 	mfd_remove_devices(wm8994->dev);
 	kfree(wm8994);
 	return ret;
@@ -569,62 +498,15 @@ static void wm8994_device_exit(struct wm8994 *wm8994)
 			       wm8994->supplies);
 	regulator_bulk_free(wm8994->num_supplies, wm8994->supplies);
 	kfree(wm8994->supplies);
+	regmap_exit(wm8994->regmap);
 	kfree(wm8994);
 }
 
-static int wm8994_i2c_read_device(struct wm8994 *wm8994, unsigned short reg,
-				  int bytes, void *dest)
-{
-	struct i2c_client *i2c = wm8994->control_data;
-	int ret;
-	u16 r = cpu_to_be16(reg);
-
-	ret = i2c_master_send(i2c, (unsigned char *)&r, 2);
-	if (ret < 0)
-		return ret;
-	if (ret != 2)
-		return -EIO;
-
-	ret = i2c_master_recv(i2c, dest, bytes);
-	if (ret < 0)
-		return ret;
-	if (ret != bytes)
-		return -EIO;
-	return 0;
-}
-
-static int wm8994_i2c_write_device(struct wm8994 *wm8994, unsigned short reg,
-				   int bytes, const void *src)
-{
-	struct i2c_client *i2c = wm8994->control_data;
-	struct i2c_msg xfer[2];
-	int ret;
-
-	reg = cpu_to_be16(reg);
-
-	xfer[0].addr = i2c->addr;
-	xfer[0].flags = 0;
-	xfer[0].len = 2;
-	xfer[0].buf = (char *)&reg;
-
-	xfer[1].addr = i2c->addr;
-	xfer[1].flags = I2C_M_NOSTART;
-	xfer[1].len = bytes;
-	xfer[1].buf = (char *)src;
-
-	ret = i2c_transfer(i2c->adapter, xfer, 2);
-	if (ret < 0)
-		return ret;
-	if (ret != 2)
-		return -EIO;
-
-	return 0;
-}
-
 static int wm8994_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct wm8994 *wm8994;
+	int ret;
 
 	wm8994 = kzalloc(sizeof(struct wm8994), GFP_KERNEL);
 	if (wm8994 == NULL)
@@ -632,12 +514,18 @@ static int wm8994_i2c_probe(struct i2c_client *i2c,
 
 	i2c_set_clientdata(i2c, wm8994);
 	wm8994->dev = &i2c->dev;
-	wm8994->control_data = i2c;
-	wm8994->read_dev = wm8994_i2c_read_device;
-	wm8994->write_dev = wm8994_i2c_write_device;
 	wm8994->irq = i2c->irq;
 	wm8994->type = id->driver_data;
 
+	wm8994->regmap = regmap_init_i2c(i2c, &wm8994_regmap_config);
+	if (IS_ERR(wm8994->regmap)) {
+		ret = PTR_ERR(wm8994->regmap);
+		dev_err(wm8994->dev, "Failed to allocate register map: %d\n",
+			ret);
+		kfree(wm8994);
+		return ret;
+	}
+
 	return wm8994_device_init(wm8994, i2c->irq);
 }
 
diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
index f0b69cd..45df450 100644
--- a/include/linux/mfd/wm8994/core.h
+++ b/include/linux/mfd/wm8994/core.h
@@ -24,6 +24,7 @@ enum wm8994_type {
 
 struct regulator_dev;
 struct regulator_bulk_data;
+struct regmap;
 
 #define WM8994_NUM_GPIO_REGS 11
 #define WM8994_NUM_LDO_REGS   2
@@ -50,18 +51,12 @@ struct regulator_bulk_data;
 #define WM8994_IRQ_GPIO(x) (x + WM8994_IRQ_TEMP_WARN)
 
 struct wm8994 {
-	struct mutex io_lock;
 	struct mutex irq_lock;
 
 	enum wm8994_type type;
 
 	struct device *dev;
-	int (*read_dev)(struct wm8994 *wm8994, unsigned short reg,
-			int bytes, void *dest);
-	int (*write_dev)(struct wm8994 *wm8994, unsigned short reg,
-			 int bytes, const void *src);
-
-	void *control_data;
+	struct regmap *regmap;
 
 	int gpio_base;
 	int irq_base;
-- 
1.7.5.4

