Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab2DAHif (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 03:38:35 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:41533 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2DAHhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 03:37:51 -0400
From: Marc Reilly <marc@cpdesign.com.au>
To: sameo@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-i2c@vger.kernel.org,
        u.kleine-koenig@pengutronix.de, oskar@scara.com,
        linux-kernel@vger.kernel.org, alexg@meprolight.com,
        Marc Reilly <marc@cpdesign.com.au>
Subject: [PATCH v5 2/4] mfd: mc13xxx-core: use regmap for register access
Date: Sun,  1 Apr 2012 16:41:37 +1000
Message-Id: <1333262499-25871-3-git-send-email-marc@cpdesign.com.au>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1333262499-25871-1-git-send-email-marc@cpdesign.com.au>
References: <1333262499-25871-1-git-send-email-marc@cpdesign.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change converts the mc13xxx core to use regmap rather than direct
spi r/w.
The spidev member of mc13xxx struct becomes redundant and is removed.
Extra debugging aids are added to mc13xxx_reg_rmw.
Mutex init is moved to before regmap init.

Signed-off-by: Marc Reilly <marc@cpdesign.com.au>
---
 drivers/mfd/Kconfig        |    1 +
 drivers/mfd/mc13xxx-core.c |  113 +++++++++++++------------------------------
 2 files changed, 35 insertions(+), 79 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index cd13e9f..4e92513 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -576,6 +576,7 @@ config MFD_MC13XXX
 	depends on SPI_MASTER
 	select MFD_CORE
 	select MFD_MC13783
+	select REGMAP_SPI
 	help
 	  Support for the Freescale (Atlas) PMIC and audio CODECs
 	  MC13783 and MC13892.
diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 0753402..3223625 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -21,6 +21,8 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_gpio.h>
+#include <linux/regmap.h>
+#include <linux/err.h>
 
 enum mc13xxx_id {
 	MC13XXX_ID_MC13783,
@@ -29,7 +31,7 @@ enum mc13xxx_id {
 };
 
 struct mc13xxx {
-	struct spi_device *spidev;
+	struct regmap *regmap;
 
 	struct device *dev;
 	enum mc13xxx_id ictype;
@@ -172,67 +174,6 @@ void mc13xxx_unlock(struct mc13xxx *mc13xxx)
 }
 EXPORT_SYMBOL(mc13xxx_unlock);
 
-#define MC13XXX_REGOFFSET_SHIFT 25
-static int mc13xxx_spi_reg_read(struct mc13xxx *mc13xxx,
-				unsigned int offset, u32 *val)
-{
-	struct spi_transfer t;
-	struct spi_message m;
-	int ret;
-
-	*val = offset << MC13XXX_REGOFFSET_SHIFT;
-
-	memset(&t, 0, sizeof(t));
-
-	t.tx_buf = val;
-	t.rx_buf = val;
-	t.len = sizeof(u32);
-
-	spi_message_init(&m);
-	spi_message_add_tail(&t, &m);
-
-	ret = spi_sync(mc13xxx->spidev, &m);
-
-	/* error in message.status implies error return from spi_sync */
-	BUG_ON(!ret && m.status);
-
-	if (ret)
-		return ret;
-
-	*val &= 0xffffff;
-
-	return 0;
-}
-
-static int mc13xxx_spi_reg_write(struct mc13xxx *mc13xxx, unsigned int offset,
-		u32 val)
-{
-	u32 buf;
-	struct spi_transfer t;
-	struct spi_message m;
-	int ret;
-
-	buf = 1 << 31 | offset << MC13XXX_REGOFFSET_SHIFT | val;
-
-	memset(&t, 0, sizeof(t));
-
-	t.tx_buf = &buf;
-	t.rx_buf = &buf;
-	t.len = sizeof(u32);
-
-	spi_message_init(&m);
-	spi_message_add_tail(&t, &m);
-
-	ret = spi_sync(mc13xxx->spidev, &m);
-
-	BUG_ON(!ret && m.status);
-
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
 int mc13xxx_reg_read(struct mc13xxx *mc13xxx, unsigned int offset, u32 *val)
 {
 	int ret;
@@ -242,7 +183,7 @@ int mc13xxx_reg_read(struct mc13xxx *mc13xxx, unsigned int offset, u32 *val)
 	if (offset > MC13XXX_NUMREGS)
 		return -EINVAL;
 
-	ret = mc13xxx_spi_reg_read(mc13xxx, offset, val);
+	ret = regmap_read(mc13xxx->regmap, offset, val);
 	dev_vdbg(mc13xxx->dev, "[0x%02x] -> 0x%06x\n", offset, *val);
 
 	return ret;
@@ -258,25 +199,19 @@ int mc13xxx_reg_write(struct mc13xxx *mc13xxx, unsigned int offset, u32 val)
 	if (offset > MC13XXX_NUMREGS || val > 0xffffff)
 		return -EINVAL;
 
-	return mc13xxx_spi_reg_write(mc13xxx, offset, val);
+	return regmap_write(mc13xxx->regmap, offset, val);
 }
 EXPORT_SYMBOL(mc13xxx_reg_write);
 
 int mc13xxx_reg_rmw(struct mc13xxx *mc13xxx, unsigned int offset,
 		u32 mask, u32 val)
 {
-	int ret;
-	u32 valread;
-
+	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
 	BUG_ON(val & ~mask);
+	dev_vdbg(mc13xxx->dev, "[0x%02x] <- 0x%06x (mask: 0x%06x)\n",
+			offset, val, mask);
 
-	ret = mc13xxx_reg_read(mc13xxx, offset, &valread);
-	if (ret)
-		return ret;
-
-	valread = (valread & ~mask) | val;
-
-	return mc13xxx_reg_write(mc13xxx, offset, valread);
+	return regmap_update_bits(mc13xxx->regmap, offset, mask, val);
 }
 EXPORT_SYMBOL(mc13xxx_reg_rmw);
 
@@ -706,7 +641,7 @@ static int mc13xxx_add_subdevice(struct mc13xxx *mc13xxx, const char *format)
 #ifdef CONFIG_OF
 static int mc13xxx_probe_flags_dt(struct mc13xxx *mc13xxx)
 {
-	struct device_node *np = mc13xxx->dev.of_node;
+	struct device_node *np = mc13xxx->dev->of_node;
 
 	if (!np)
 		return -ENODEV;
@@ -752,6 +687,16 @@ static const struct of_device_id mc13xxx_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, mc13xxx_dt_ids);
 
+static struct regmap_config mc13xxx_regmap_spi_config = {
+	.reg_bits = 7,
+	.pad_bits = 1,
+	.val_bits = 24,
+
+	.max_register = MC13XXX_NUMREGS,
+
+	.cache_type = REGCACHE_NONE,
+};
+
 static int mc13xxx_common_init(struct mc13xxx *mc13xxx,
 		struct mc13xxx_platform_data *pdata, int irq);
 
@@ -776,10 +721,19 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
 	dev_set_drvdata(&spi->dev, mc13xxx);
 	spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
 	spi->bits_per_word = 32;
-	spi_setup(spi);
 
 	mc13xxx->dev = &spi->dev;
-	mc13xxx->spidev = spi;
+	mutex_init(&mc13xxx->lock);
+
+	mc13xxx->regmap = regmap_init_spi(spi, &mc13xxx_regmap_spi_config);
+	if (IS_ERR(mc13xxx->regmap)) {
+		ret = PTR_ERR(mc13xxx->regmap);
+		dev_err(mc13xxx->dev, "Failed to initialize register map: %d\n",
+				ret);
+		dev_set_drvdata(&spi->dev, NULL);
+		kfree(mc13xxx);
+		return ret;
+	}
 
 	ret = mc13xxx_common_init(mc13xxx, pdata, spi->irq);
 
@@ -787,7 +741,7 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
 		dev_set_drvdata(&spi->dev, NULL);
 	} else {
 		const struct spi_device_id *devid =
-			spi_get_device_id(mc13xxx->spidev);
+			spi_get_device_id(spi);
 		if (!devid || devid->driver_data != mc13xxx->ictype)
 			dev_warn(mc13xxx->dev,
 				"device id doesn't match auto detection!\n");
@@ -801,7 +755,6 @@ static int mc13xxx_common_init(struct mc13xxx *mc13xxx,
 {
 	int ret;
 
-	mutex_init(&mc13xxx->lock);
 	mc13xxx_lock(mc13xxx);
 
 	ret = mc13xxx_identify(mc13xxx);
@@ -878,6 +831,8 @@ static void mc13xxx_common_cleanup(struct mc13xxx *mc13xxx)
 
 	mfd_remove_devices(mc13xxx->dev);
 
+	regmap_exit(mc13xxx->regmap);
+
 	kfree(mc13xxx);
 }
 
-- 
1.7.3.4

