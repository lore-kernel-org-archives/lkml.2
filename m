Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1HDMpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 08:45:17 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:11420
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449Ab1HDMpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 08:45:11 -0400
X-SpamScore: 7
X-BigFish: VPS7(zzzz1202h10d2nzz8275bhz32i2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [Patch 01/11] MFD: DA9052 Code refactored to use regmap
From: ashishj3 <ashish.jangam@kpitcummins.com>
Reply-To: <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <sameo@openedhand.com>, <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>, <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset="cp1252"
Date: Thu, 4 Aug 2011 18:15:02 +0530
Message-ID: <1312461902.4384.0.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.22]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DA9052 MFD Code is refactored to add remap support in the DA9052. 
Recent changes to DA9052 battery module also required certain components
to be added in this patch. Also set bits and clear bits are removed
and instead da9052_reg_update() will be used in future. 

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 drivers/mfd/Kconfig               |    2 +
 drivers/mfd/da9052-core.c         |  243 ++++++++----------------------------
 drivers/mfd/da9052-i2c.c          |   73 +++--------
 drivers/mfd/da9052-spi.c          |   55 +++------
 include/linux/mfd/da9052/da9052.h |   13 +--
 include/linux/mfd/da9052/pdata.h  |    3 +-
 include/linux/mfd/da9052/reg.h    |    2 +
 7 files changed, 98 insertions(+), 293 deletions(-)
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index e0de26a..9a77294 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -350,6 +350,7 @@ config MFD_DA9052_SPI
 	bool "Support Dialog Semiconductor DA9052 PMIC with SPI"
 	select MFD_CORE
 	select PMIC_DA9052
+	select REGMAP_SPI
 	depends on SPI_MASTER=y
 	help
 	  Support for the Dialog Semiconductor DA9052 PMIC
@@ -361,6 +362,7 @@ config MFD_DA9052_I2C
 	bool "Support Dialog Semiconductor DA9052 PMIC with I2C"
 	select MFD_CORE
 	select PMIC_DA9052
+	select REGMAP_I2C
 	depends on I2C=y
 	help
 	  Support for the Dialog Semiconductor DA9052 PMIC
diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index f572ad0..271fe5b 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -23,6 +23,10 @@
 #include <linux/mfd/da9052/pdata.h>
 #include <linux/mfd/da9052/reg.h>
 
+#define DA9052_IRQ_DCIN	0
+#define DA9052_IRQ_VBUS	1
+#define DA9052_IRQ_DCINREM	2
+#define DA9052_IRQ_VBUSREM	3
 #define DA9052_IRQ_ALARM	5
 #define DA9052_IRQ_NONKEY	8
 #define DA9052_IRQ_CHGEND	11
@@ -176,243 +180,80 @@ EXPORT_SYMBOL_GPL(da9052_adc_temperature_read);
 
 int da9052_reg_read(struct da9052 *da9052, unsigned char reg)
 {
-	unsigned char val;
-	int ret;
+	int val, ret;
 
 	if (reg > DA9052_MAX_REG_CNT) {
 		dev_err(da9052->dev, "invalid reg %x\n", reg);
 		return -EINVAL;
 	}
 
-	mutex_lock(&da9052->io_lock);
-
-	if (da9052->read_dev == NULL) {
-		ret = -ENODEV;
-		goto err;
-	}
-
-	ret = da9052->read_dev(da9052, reg, 1, &val);
-	if (ret)
-		goto err;
+	#ifdef CONFIG_MFD_DA9052_SPI
+		reg = (reg << 1) | 1;
+	#endif
 
-	mutex_unlock(&da9052->io_lock);
+	ret = regmap_read(da9052->regmap, reg, &val);
+	if (ret < 0)
+		return ret;
 
 	return val;
-
-err:
-	mutex_unlock(&da9052->io_lock);
-	return ret;
 }
 EXPORT_SYMBOL_GPL(da9052_reg_read);
 
 int da9052_reg_write(struct da9052 *da9052, unsigned char reg,
 		      unsigned char val)
 {
-	int ret;
-
 	if (reg > DA9052_MAX_REG_CNT) {
 		dev_err(da9052->dev, "invalid reg %x\n", reg);
 		return -EINVAL;
 	}
 
-	mutex_lock(&da9052->io_lock);
+	#ifdef CONFIG_MFD_DA9052_SPI
+		reg <<= 1;
+	#endif
 
-	if (da9052->write_dev == NULL) {
-		ret = -ENODEV;
-		goto err;
-	}
-
-	ret = da9052->write_dev(da9052, reg, 1, &val);
-	if (ret < 0)
-		goto err;
-
-	mutex_unlock(&da9052->io_lock);
-
-	return 0;
-
-err:
-	mutex_unlock(&da9052->io_lock);
-	return ret;
+	return regmap_write(da9052->regmap, reg, val);
 }
 EXPORT_SYMBOL_GPL(da9052_reg_write);
 
 int da9052_group_read(struct da9052 *da9052, unsigned char reg,
 		       unsigned reg_cnt, unsigned char *val)
 {
-	int ret;
-
 	if (reg > DA9052_MAX_REG_CNT) {
 		dev_err(da9052->dev, "invalid reg %x\n", reg);
 		return -EINVAL;
 	}
 
-	mutex_lock(&da9052->io_lock);
-
-	if (da9052->read_dev == NULL) {
-		ret = -ENODEV;
-		goto err;
-	}
-
-	ret = da9052->read_dev(da9052, reg, reg_cnt, val);
-	if (ret < 0)
-		goto err;
+	#ifdef CONFIG_MFD_DA9052_SPI
+		reg = (reg << 1) | 1;
+	#endif
 
-	mutex_unlock(&da9052->io_lock);
-
-	return 0;
-
-err:
-	mutex_unlock(&da9052->io_lock);
-	return ret;
+	return regmap_bulk_read(da9052->regmap, reg, val, reg_cnt);
 }
 EXPORT_SYMBOL_GPL(da9052_group_read);
 
 int da9052_group_write(struct da9052 *da9052, unsigned char reg,
 		        unsigned reg_cnt, unsigned char *val)
 {
-	int ret;
-
-	if (reg > DA9052_MAX_REG_CNT) {
-		dev_err(da9052->dev, "invalid reg %x\n", reg);
-		return -EINVAL;
-	}
-
-	mutex_lock(&da9052->io_lock);
-
-	if (da9052->write_dev == NULL) {
-		ret = -ENODEV;
-		goto err;
-	}
-
-	ret = da9052->write_dev(da9052, reg, reg_cnt, val);
-	if (ret < 0)
-		goto err;
+	#ifdef CONFIG_MFD_DA9052_SPI
+		reg <<= 1;
+	#endif
 
-	mutex_unlock(&da9052->io_lock);
-
-	return 0;
-
-err:
-	mutex_unlock(&da9052->io_lock);
-	return ret;
+	return regmap_raw_write(da9052->regmap, reg, val, reg_cnt);
 }
 EXPORT_SYMBOL_GPL(da9052_group_write);
 
 int da9052_reg_update(struct da9052 *da9052, unsigned char reg,
 		       unsigned char bit_mask, unsigned char reg_val)
 {
-	int ret;
-	unsigned char val;
-
 	if (reg > DA9052_MAX_REG_CNT) {
 		dev_err(da9052->dev, "invalid reg %x\n", reg);
 		return -EINVAL;
 	}
 
-	mutex_lock_interruptible(&da9052->io_lock);
-
-	if (da9052->read_dev == NULL || da9052->write_dev == NULL) {
-		ret = -ENODEV;
-		goto err;
-	}
-
-	ret = da9052->read_dev(da9052, reg, 1, &val);
-	if (ret < 0)
-		goto err;
-
-	val &= ~bit_mask;
-	val |= reg_val;
-
-	ret = da9052->write_dev(da9052, reg, 1, &val);
-	if (ret < 0)
-		goto err;
-
-	mutex_unlock(&da9052->io_lock);
-
-	return 0;
-
-err:
-	mutex_unlock(&da9052->io_lock);
-	return ret;
+	return regmap_update_bits(da9052->regmap, reg, bit_mask, reg_val);
 }
 EXPORT_SYMBOL_GPL(da9052_reg_update);
 
-int da9052_set_bits(struct da9052 *da9052, unsigned char reg,
-		     unsigned char bit_mask)
-{
-	unsigned char val;
-	int ret;
-
-	if (reg > DA9052_MAX_REG_CNT) {
-		dev_err(da9052->dev, "invalid reg %x\n", reg);
-		return -EINVAL;
-	}
-
-	mutex_lock_interruptible(&da9052->io_lock);
-
-	if (da9052->read_dev == NULL || da9052->write_dev == NULL) {
-		ret = -ENODEV;
-		goto err;
-	}
-
-	ret = da9052->read_dev(da9052, reg, 1, &val);
-	if (ret < 0)
-		goto err;
-
-	val |= bit_mask;
-
-	ret = da9052->write_dev(da9052, reg, 1, &val);
-	if (ret < 0)
-		goto err;
-
-	mutex_unlock(&da9052->io_lock);
-
-	return 0;
-
-err:
-	mutex_unlock(&da9052->io_lock);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(da9052_set_bits);
-
-int da9052_clear_bits(struct da9052 *da9052, unsigned char reg,
-		       unsigned char bit_mask)
-{
-	unsigned char val;
-	int ret;
-
-	if (reg > DA9052_MAX_REG_CNT) {
-		dev_err(da9052->dev, "invalid reg %x\n", reg);
-		return -EINVAL;
-	}
-
-	mutex_lock_interruptible(&da9052->io_lock);
-
-	if (da9052->read_dev == NULL || da9052->write_dev == NULL) {
-		ret = -ENODEV;
-		goto err;
-	}
-
-	ret = da9052->read_dev(da9052, reg, 1, &val);
-	if (ret < 0)
-		goto err;
-
-	val &= ~bit_mask;
-
-	ret = da9052->write_dev(da9052, reg, 1, &val);
-	if (ret < 0)
-		goto err;
-
-	mutex_unlock(&da9052->io_lock);
-
-	return 0;
-
-err:
-	mutex_unlock(&da9052->io_lock);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(da9052_clear_bits);
-
 static struct resource da9052_rtc_resource = {
 	.name = "ALM",
 	.start = DA9052_IRQ_ALARM,
@@ -429,15 +270,39 @@ static struct resource da9052_onkey_resource = {
 
 static struct resource da9052_power_resources[] = {
 	{
-		.name = "CHGEND",
-		.start = DA9052_IRQ_CHGEND,
-		.end   = DA9052_IRQ_CHGEND,
+		.name = "BATT TEMP",
+		.start = DA9052_IRQ_TBAT,
+		.end   = DA9052_IRQ_TBAT,
 		.flags = IORESOURCE_IRQ,
 	},
 	{
-		.name = "TBAT",
-		.start = DA9052_IRQ_TBAT,
-		.end   = DA9052_IRQ_TBAT,
+		.name = "DCIN DET",
+		.start = DA9052_IRQ_DCIN,
+		.end   = DA9052_IRQ_DCIN,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "DCIN REM",
+		.start = DA9052_IRQ_DCINREM,
+		.end   = DA9052_IRQ_DCINREM,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "VBUS DET",
+		.start = DA9052_IRQ_VBUS,
+		.end   = DA9052_IRQ_VBUS,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "VBUS REM",
+		.start = DA9052_IRQ_VBUSREM,
+		.end   = DA9052_IRQ_VBUSREM,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "CHG END",
+		.start = DA9052_IRQ_CHGEND,
+		.end   = DA9052_IRQ_CHGEND,
 		.flags = IORESOURCE_IRQ,
 	},
 };
diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
index c56793b..e6f8d87 100644
--- a/drivers/mfd/da9052-i2c.c
+++ b/drivers/mfd/da9052-i2c.c
@@ -1,5 +1,5 @@
 /*
- * I2C access for Da9052 PMICs.
+ * I2C access for DA9052 PMICs.
  *
  * Copyright(c) 2011 Dialog Semiconductor Ltd.
  *
@@ -13,62 +13,25 @@
  */
 
 #include <linux/device.h>
+#include <linux/err.h>
 #include <linux/mfd/core.h>
 #include <linux/i2c.h>
 
 #include <linux/mfd/da9052/da9052.h>
 #include <linux/mfd/da9052/reg.h>
 
-int da9052_i2c_write_device(struct da9052 *da9052, unsigned char reg,
-			     unsigned count, unsigned char *val)
-{
-	unsigned char msg[count+1];
-	int ret;
-
-	msg[0] = reg;
-	memcpy(&msg[1], val, count);
-
-	ret = i2c_master_send(da9052->i2c_client, msg, count + 1);
-	if (ret < 0)
-		return ret;
-	if (ret != count + 1)
-		return -EIO;
-
-	return 0;
-}
-
-int da9052_i2c_read_device(struct da9052 *da9052, unsigned char reg,
-			    unsigned count, unsigned char *val)
-{
-	int ret;
-
-	ret = i2c_master_send(da9052->i2c_client, &reg, 1);
-	if (ret < 0)
-		return ret;
-
-	ret = i2c_master_recv(da9052->i2c_client, val, count);
-	if (ret < 0)
-		return ret;
-	if (ret != count)
-		return -EIO;
-
-	return 0;
-
-}
-
 static int da9052_i2c_enable_multiwrite(struct da9052 *da9052)
 {
-	u8 reg_val;
-	int ret;
+	int reg_val, ret;
 
-	ret = da9052_i2c_read_device(da9052, DA9052_CONTROL_B_REG, 1, &reg_val);
+	ret = regmap_read(da9052->regmap, DA9052_CONTROL_B_REG, &reg_val);
 	if (ret < 0)
 		return ret;
 
 	if (reg_val & DA9052_CONTROL_B_WRITEMODE) {
 		reg_val = ~DA9052_CONTROL_B_WRITEMODE;
-		ret = da9052_i2c_write_device(da9052, DA9052_CONTROL_B_REG, 1,
-					      &reg_val);
+		ret = regmap_write(da9052->regmap,
+				   DA9052_CONTROL_B_REG, reg_val);
 		if (ret < 0)
 			return ret;
 	}
@@ -76,10 +39,14 @@ static int da9052_i2c_enable_multiwrite(struct da9052 *da9052)
 	return 0;
 }
 
+static struct regmap_config da9052_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
 static int __devinit da9052_i2c_probe(struct i2c_client *client,
 				       const struct i2c_device_id *id)
 {
-	struct i2c_adapter *adapter;
 	struct da9052 *da9052_i2c;
 	int ret;
 
@@ -87,27 +54,29 @@ static int __devinit da9052_i2c_probe(struct i2c_client *client,
 	if (!da9052_i2c)
 		return -ENOMEM;
 
-	adapter = to_i2c_adapter(client->dev.parent);
-
-	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
+	if (!i2c_check_functionality(client->adapter,
+				     I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_info(&client->dev, "Error in %s:i2c_check_functionality\n",
 			 __func__);
 		return -ENODEV;
 	}
 
-	da9052_i2c->i2c_client = client;
 	da9052_i2c->dev = &client->dev;
-
 	i2c_set_clientdata(client, da9052_i2c);
 
-	da9052_i2c->write_dev = da9052_i2c_write_device;
-	da9052_i2c->read_dev = da9052_i2c_read_device;
+	da9052_i2c->regmap = regmap_init_i2c(client, &da9052_regmap_config);
+	if (IS_ERR(da9052_i2c->regmap)) {
+		ret = PTR_ERR(da9052_i2c->regmap);
+		dev_err(&client->dev, "Failed to allocate register map: %d\n",
+			ret);
+		goto err;
+	}
 
 	ret = da9052_i2c_enable_multiwrite(da9052_i2c);
 	if (ret < 0)
 		goto err;
 
-	ret = da9052_device_init(da9052_i2c)
+	ret = da9052_device_init(da9052_i2c);
 	if (ret != 0)
 		goto err;
 
diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
index d787aa7..48ca027 100644
--- a/drivers/mfd/da9052-spi.c
+++ b/drivers/mfd/da9052-spi.c
@@ -13,46 +13,17 @@
  */
 
 #include <linux/device.h>
+#include <linux/err.h>
 #include <linux/mfd/core.h>
 #include <linux/spi/spi.h>
 
 #include <linux/mfd/da9052/da9052.h>
 #include <linux/mfd/da9052/reg.h>
 
-int da9052_spi_write_device(struct da9052 *da9052, unsigned char reg,
-			     unsigned bytes, unsigned char *val)
-{
-	int raddr, ret;
-	unsigned char data[2];
-
-	for (raddr = reg; raddr < reg + bytes; raddr++) {
-		raddr = (raddr << 1);
-		data[0] = raddr;
-		data[1] = *val++;
-
-		ret = spi_write(da9052->spi_dev, data, 2);
-		if (ret != 0)
-			return ret;
-	}
-
-	return 0;
-}
-
-int da9052_spi_read_device(struct da9052 *da9052, unsigned char reg,
-			    unsigned bytes, unsigned char *val)
-{
-	int ret, raddr;
-
-	for (raddr = reg; raddr < reg + bytes; raddr++) {
-		reg = ((raddr << 1) | da9052->rw_pol);
-		ret = spi_write_then_read(da9052->spi_dev, (u8 *)&reg, 2,
-					  val, 2);
-		if (ret != 0)
-			return ret;
-	}
-
-	return ret;
-}
+static struct regmap_config da9052_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
 
 static int da9052_spi_probe(struct spi_device *spi)
 {
@@ -69,19 +40,23 @@ static int da9052_spi_probe(struct spi_device *spi)
 	da9052_spi->dev = &spi->dev;
 	da9052_spi->spi_dev = spi;
 
-	da9052_spi->rw_pol = 1;
 	dev_set_drvdata(&spi->dev, da9052_spi);
 
-	da9052_spi->write_dev = da9052_spi_write_device;
-	da9052_spi->read_dev = da9052_spi_read_device;
+	da9052_spi->regmap = regmap_init_spi(spi, &da9052_regmap_config);
+	if (IS_ERR(da9052_spi->regmap)) {
+		ret = PTR_ERR(da9052_spi->regmap);
+		dev_err(&spi->dev, "Failed to allocate register map: %d\n",
+			ret);
+		goto err;
+	}
 
-	ret = da9052_device_init(da9052_i2c)
+	ret = da9052_device_init(da9052_spi);
 	if (ret != 0)
-		goto err_mem;
+		goto err;
 
 	return 0;
 
-err_mem:
+err:
 	kfree(da9052_spi);
 	return ret;
 }
diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
index 558f73b..3578e28 100644
--- a/include/linux/mfd/da9052/da9052.h
+++ b/include/linux/mfd/da9052/da9052.h
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/core.h>
+#include <linux/regmap.h>
 
 /* HWMON Channel Definations */
 #define DA9052_ADC_VDDOUT	0
@@ -50,16 +51,12 @@ struct da9052 {
 	struct device *dev;
 	struct spi_device *spi_dev;
 	struct i2c_client *i2c_client;
+	struct regmap *regmap;
 
 	int irq_base;
-	u8	rw_pol;
-	u32	events_mask;
+	u32 events_mask;
 
 	int chip_irq;
-	int (*read_dev) (struct da9052 *da9052, unsigned char reg,
-			 unsigned bytes, unsigned char *val);
-	int (*write_dev) (struct da9052 *da9052, unsigned char reg,
-			  unsigned bytes, unsigned char *val);
 };
 
 /* ADC API */
@@ -77,10 +74,6 @@ int da9052_group_write(struct da9052 *da9052, unsigned char reg,
 		        unsigned bytes, unsigned char *val);
 int da9052_reg_update(struct da9052 *da9052, unsigned char reg,
 		       unsigned char bit_mask, unsigned char reg_val);
-int da9052_set_bits(struct da9052 *da9052, unsigned char reg,
-		     unsigned char bit_mask);
-int da9052_clear_bits(struct da9052 *da9052, unsigned char reg,
-		       unsigned char bit_mask);
 
 int da9052_device_init(struct da9052 *da9052);
 void da9052_device_exit(struct da9052 *da9052);
diff --git a/include/linux/mfd/da9052/pdata.h b/include/linux/mfd/da9052/pdata.h
index 75d82a3..b56aa7a 100644
--- a/include/linux/mfd/da9052/pdata.h
+++ b/include/linux/mfd/da9052/pdata.h
@@ -30,13 +30,12 @@ struct da9052;
 
 struct da9052_pdata {
 	struct led_platform_data *pled;
-	struct da9052_wdt_platform_data *pwdt;
-	struct da9052_tsi_platform_data *ptsi;
 	int (*init) (struct da9052 *da9052);
 	int irq;
 	int irq_base;
 	int num_regulators;
 	int gpio_base;
+	int use_for_apm;
 	struct regulator_init_data *regulators[DA9052_MAX_REGULATORS];
 };
 
diff --git a/include/linux/mfd/da9052/reg.h b/include/linux/mfd/da9052/reg.h
index ac391b3..f521b7d 100644
--- a/include/linux/mfd/da9052/reg.h
+++ b/include/linux/mfd/da9052/reg.h
@@ -58,6 +58,8 @@
 /*GPIO REGISTERS*/
 #define DA9052_GPIO_0_1_REG		21
 #define DA9052_GPIO_2_3_REG		22
+#define DA9052_GPIO_4_5_REG		23
+#define DA9052_GPIO_6_7_REG		24
 #define DA9052_GPIO_14_15_REG		28
 
 /*LDO AND BUCK REGISTERS*/


