Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab1FVSqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:46:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33999 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756602Ab1FVSp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:45:59 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/8] mfd: Convert WM831x to use regmap API
Date: Wed, 22 Jun 2011 19:45:50 +0100
Message-Id: <1308768353-19372-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308768353-19372-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110622184407.GC13847@sirena.org.uk>
 <1308768353-19372-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out the register read/write code to use the register map API.  We
still need some wm831x specific code and locking in place to check that
the user key is handled correctly but only on the write side, reads are
not affected by the key.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig             |    2 +
 drivers/mfd/wm831x-core.c       |   97 ++++++++++++++------------------------
 drivers/mfd/wm831x-i2c.c        |   56 ----------------------
 drivers/mfd/wm831x-spi.c        |   48 -------------------
 include/linux/mfd/wm831x/core.h |    7 +--
 5 files changed, 40 insertions(+), 170 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 6b0babc..9782296 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -389,6 +389,7 @@ config MFD_WM831X_I2C
 	bool "Support Wolfson Microelectronics WM831x/2x PMICs with I2C"
 	select MFD_CORE
 	select MFD_WM831X
+	select REGMAP
 	depends on I2C=y && GENERIC_HARDIRQS
 	help
 	  Support for the Wolfson Microelecronics WM831x and WM832x PMICs
@@ -400,6 +401,7 @@ config MFD_WM831X_SPI
 	bool "Support Wolfson Microelectronics WM831x/2x PMICs with SPI"
 	select MFD_CORE
 	select MFD_WM831X
+	select REGMAP
 	depends on SPI_MASTER && GENERIC_HARDIRQS
 	help
 	  Support for the Wolfson Microelecronics WM831x and WM832x PMICs
diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index baae9e4..9370b8c 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/mfd/core.h>
 #include <linux/slab.h>
+#include <linux/err.h>
 
 #include <linux/mfd/wm831x/core.h>
 #include <linux/mfd/wm831x/pdata.h>
@@ -160,29 +161,6 @@ int wm831x_reg_unlock(struct wm831x *wm831x)
 }
 EXPORT_SYMBOL_GPL(wm831x_reg_unlock);
 
-static int wm831x_read(struct wm831x *wm831x, unsigned short reg,
-		       int bytes, void *dest)
-{
-	int ret, i;
-	u16 *buf = dest;
-
-	BUG_ON(bytes % 2);
-	BUG_ON(bytes <= 0);
-
-	ret = wm831x->read_dev(wm831x, reg, bytes, dest);
-	if (ret < 0)
-		return ret;
-
-	for (i = 0; i < bytes / 2; i++) {
-		buf[i] = be16_to_cpu(buf[i]);
-
-		dev_vdbg(wm831x->dev, "Read %04x from R%d(0x%x)\n",
-			 buf[i], reg + i, reg + i);
-	}
-
-	return 0;
-}
-
 /**
  * wm831x_reg_read: Read a single WM831x register.
  *
@@ -191,14 +169,10 @@ static int wm831x_read(struct wm831x *wm831x, unsigned short reg,
  */
 int wm831x_reg_read(struct wm831x *wm831x, unsigned short reg)
 {
-	unsigned short val;
+	unsigned int val;
 	int ret;
 
-	mutex_lock(&wm831x->io_lock);
-
-	ret = wm831x_read(wm831x, reg, 2, &val);
-
-	mutex_unlock(&wm831x->io_lock);
+	ret = regmap_read(wm831x->regmap, reg, &val);
 
 	if (ret < 0)
 		return ret;
@@ -218,15 +192,7 @@ EXPORT_SYMBOL_GPL(wm831x_reg_read);
 int wm831x_bulk_read(struct wm831x *wm831x, unsigned short reg,
 		     int count, u16 *buf)
 {
-	int ret;
-
-	mutex_lock(&wm831x->io_lock);
-
-	ret = wm831x_read(wm831x, reg, count * 2, buf);
-
-	mutex_unlock(&wm831x->io_lock);
-
-	return ret;
+	return regmap_bulk_read(wm831x->regmap, reg, buf, count);
 }
 EXPORT_SYMBOL_GPL(wm831x_bulk_read);
 
@@ -234,7 +200,7 @@ static int wm831x_write(struct wm831x *wm831x, unsigned short reg,
 			int bytes, void *src)
 {
 	u16 *buf = src;
-	int i;
+	int i, ret;
 
 	BUG_ON(bytes % 2);
 	BUG_ON(bytes <= 0);
@@ -245,11 +211,10 @@ static int wm831x_write(struct wm831x *wm831x, unsigned short reg,
 
 		dev_vdbg(wm831x->dev, "Write %04x to R%d(0x%x)\n",
 			 buf[i], reg + i, reg + i);
-
-		buf[i] = cpu_to_be16(buf[i]);
+		ret = regmap_write(wm831x->regmap, reg + i, buf[i]);
 	}
 
-	return wm831x->write_dev(wm831x, reg, bytes, src);
+	return 0;
 }
 
 /**
@@ -286,20 +251,14 @@ int wm831x_set_bits(struct wm831x *wm831x, unsigned short reg,
 		    unsigned short mask, unsigned short val)
 {
 	int ret;
-	u16 r;
 
 	mutex_lock(&wm831x->io_lock);
 
-	ret = wm831x_read(wm831x, reg, 2, &r);
-	if (ret < 0)
-		goto out;
-
-	r &= ~mask;
-	r |= val & mask;
-
-	ret = wm831x_write(wm831x, reg, 2, &r);
+	if (!wm831x_reg_locked(wm831x, reg))
+		ret = regmap_update_bits(wm831x->regmap, reg, mask, val);
+	else
+		ret = -EPERM;
 
-out:
 	mutex_unlock(&wm831x->io_lock);
 
 	return ret;
@@ -1280,6 +1239,11 @@ static struct mfd_cell backlight_devs[] = {
 	},
 };
 
+static struct regmap_config wm831x_regmap_config = {
+	.reg_bits = 16,
+	.val_bits = 16,
+};
+
 /*
  * Instantiate the generic non-control parts of the device.
  */
@@ -1294,10 +1258,18 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	mutex_init(&wm831x->key_lock);
 	dev_set_drvdata(wm831x->dev, wm831x);
 
+	wm831x->regmap = regmap_init(wm831x->dev, &wm831x_regmap_config);
+	if (IS_ERR(wm831x->regmap)) {
+		ret = PTR_ERR(wm831x->regmap);
+		dev_err(wm831x->dev, "Failed to allocate register map: %d\n",
+			ret);
+		goto err;
+	}
+
 	ret = wm831x_reg_read(wm831x, WM831X_PARENT_ID);
 	if (ret < 0) {
 		dev_err(wm831x->dev, "Failed to read parent ID: %d\n", ret);
-		goto err;
+		goto err_regmap;
 	}
 	switch (ret) {
 	case 0x6204:
@@ -1306,20 +1278,20 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	default:
 		dev_err(wm831x->dev, "Device is not a WM831x: ID %x\n", ret);
 		ret = -EINVAL;
-		goto err;
+		goto err_regmap;
 	}
 
 	ret = wm831x_reg_read(wm831x, WM831X_REVISION);
 	if (ret < 0) {
 		dev_err(wm831x->dev, "Failed to read revision: %d\n", ret);
-		goto err;
+		goto err_regmap;
 	}
 	rev = (ret & WM831X_PARENT_REV_MASK) >> WM831X_PARENT_REV_SHIFT;
 
 	ret = wm831x_reg_read(wm831x, WM831X_RESET_ID);
 	if (ret < 0) {
 		dev_err(wm831x->dev, "Failed to read device ID: %d\n", ret);
-		goto err;
+		goto err_regmap;
 	}
 
 	/* Some engineering samples do not have the ID set, rely on
@@ -1394,7 +1366,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	default:
 		dev_err(wm831x->dev, "Unknown WM831x device %04x\n", ret);
 		ret = -EINVAL;
-		goto err;
+		goto err_regmap;
 	}
 
 	/* This will need revisiting in future but is OK for all
@@ -1408,7 +1380,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	ret = wm831x_reg_read(wm831x, WM831X_SECURITY_KEY);
 	if (ret < 0) {
 		dev_err(wm831x->dev, "Failed to read security key: %d\n", ret);
-		goto err;
+		goto err_regmap;
 	}
 	if (ret != 0) {
 		dev_warn(wm831x->dev, "Security key had non-zero value %x\n",
@@ -1421,7 +1393,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 		ret = pdata->pre_init(wm831x);
 		if (ret != 0) {
 			dev_err(wm831x->dev, "pre_init() failed: %d\n", ret);
-			goto err;
+			goto err_regmap;
 		}
 	}
 
@@ -1444,7 +1416,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 
 	ret = wm831x_irq_init(wm831x, irq);
 	if (ret != 0)
-		goto err;
+		goto err_regmap;
 
 	wm831x_auxadc_init(wm831x);
 
@@ -1540,8 +1512,10 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 
 err_irq:
 	wm831x_irq_exit(wm831x);
-err:
+err_regmap:
 	mfd_remove_devices(wm831x->dev);
+	regmap_exit(wm831x->regmap);
+err:
 	kfree(wm831x);
 	return ret;
 }
@@ -1553,6 +1527,7 @@ void wm831x_device_exit(struct wm831x *wm831x)
 	if (wm831x->irq_base)
 		free_irq(wm831x->irq_base + WM831X_IRQ_AUXADC_DATA, wm831x);
 	wm831x_irq_exit(wm831x);
+	regmap_exit(wm831x->regmap);
 	kfree(wm831x);
 }
 
diff --git a/drivers/mfd/wm831x-i2c.c b/drivers/mfd/wm831x-i2c.c
index a06cbc7..4e16462 100644
--- a/drivers/mfd/wm831x-i2c.c
+++ b/drivers/mfd/wm831x-i2c.c
@@ -22,59 +22,6 @@
 #include <linux/mfd/wm831x/core.h>
 #include <linux/mfd/wm831x/pdata.h>
 
-static int wm831x_i2c_read_device(struct wm831x *wm831x, unsigned short reg,
-				  int bytes, void *dest)
-{
-	struct i2c_client *i2c = wm831x->control_data;
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
-/* Currently we allocate the write buffer on the stack; this is OK for
- * small writes - if we need to do large writes this will need to be
- * revised.
- */
-static int wm831x_i2c_write_device(struct wm831x *wm831x, unsigned short reg,
-				   int bytes, void *src)
-{
-	struct i2c_client *i2c = wm831x->control_data;
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
 static int wm831x_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
@@ -86,9 +33,6 @@ static int wm831x_i2c_probe(struct i2c_client *i2c,
 
 	i2c_set_clientdata(i2c, wm831x);
 	wm831x->dev = &i2c->dev;
-	wm831x->control_data = i2c;
-	wm831x->read_dev = wm831x_i2c_read_device;
-	wm831x->write_dev = wm831x_i2c_write_device;
 
 	return wm831x_device_init(wm831x, id->driver_data, i2c->irq);
 }
diff --git a/drivers/mfd/wm831x-spi.c b/drivers/mfd/wm831x-spi.c
index eed8e4f..0b0730d 100644
--- a/drivers/mfd/wm831x-spi.c
+++ b/drivers/mfd/wm831x-spi.c
@@ -19,51 +19,6 @@
 
 #include <linux/mfd/wm831x/core.h>
 
-static int wm831x_spi_read_device(struct wm831x *wm831x, unsigned short reg,
-				  int bytes, void *dest)
-{
-	u16 tx_val;
-	u16 *d = dest;
-	int r, ret;
-
-	/* Go register at a time */
-	for (r = reg; r < reg + (bytes / 2); r++) {
-		tx_val = r | 0x8000;
-
-		ret = spi_write_then_read(wm831x->control_data,
-					  (u8 *)&tx_val, 2, (u8 *)d, 2);
-		if (ret != 0)
-			return ret;
-
-		*d = be16_to_cpu(*d);
-
-		d++;
-	}
-
-	return 0;
-}
-
-static int wm831x_spi_write_device(struct wm831x *wm831x, unsigned short reg,
-				   int bytes, void *src)
-{
-	struct spi_device *spi = wm831x->control_data;
-	u16 *s = src;
-	u16 data[2];
-	int ret, r;
-
-	/* Go register at a time */
-	for (r = reg; r < reg + (bytes / 2); r++) {
-		data[0] = r;
-		data[1] = *s++;
-
-		ret = spi_write(spi, (char *)&data, sizeof(data));
-		if (ret != 0)
-			return ret;
-	}
-
-	return 0;
-}
-
 static int __devinit wm831x_spi_probe(struct spi_device *spi)
 {
 	struct wm831x *wm831x;
@@ -98,9 +53,6 @@ static int __devinit wm831x_spi_probe(struct spi_device *spi)
 
 	dev_set_drvdata(&spi->dev, wm831x);
 	wm831x->dev = &spi->dev;
-	wm831x->control_data = spi;
-	wm831x->read_dev = wm831x_spi_read_device;
-	wm831x->write_dev = wm831x_spi_write_device;
 
 	return wm831x_device_init(wm831x, type, spi->irq);
 }
diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index 8dda8de..bd0615b 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -18,6 +18,7 @@
 #include <linux/completion.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
+#include <linux/regmap.h>
 
 /*
  * Register values.
@@ -361,12 +362,8 @@ struct wm831x {
 	struct mutex io_lock;
 
 	struct device *dev;
-	int (*read_dev)(struct wm831x *wm831x, unsigned short reg,
-			int bytes, void *dest);
-	int (*write_dev)(struct wm831x *wm831x, unsigned short reg,
-			 int bytes, void *src);
 
-	void *control_data;
+	struct regmap *regmap;
 
 	int irq;  /* Our chip IRQ */
 	struct mutex irq_lock;
-- 
1.7.5.4

