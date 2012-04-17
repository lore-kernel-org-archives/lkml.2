Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab2DQIus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 04:50:48 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4307 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab2DQIuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 04:50:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 17 Apr 2012 01:50:45 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: jic23@cam.ac.uk, gregkh@linuxfoundation.org, max@stro.at,
        jbrenner@taosinc.com, bfreed@chromium.org, lars@metafoo.de,
        grundler@chromium.org
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] staging: iio: light: isl29018: use regmap for register access
Date: Tue, 17 Apr 2012 14:20:31 +0530
Message-Id: <1334652631-21032-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using regmap for accessing register through i2c bus. This will
remove the code for caching registers, read-modify-write logics.
Also it will provide the debugfs feature to dump register
through regmap debugfs.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/staging/iio/light/Kconfig    |   19 ++--
 drivers/staging/iio/light/isl29018.c |  176 +++++++++++++++++-----------------
 2 files changed, 99 insertions(+), 96 deletions(-)

diff --git a/drivers/staging/iio/light/Kconfig b/drivers/staging/iio/light/Kconfig
index 53b49f7..fd39f72 100644
--- a/drivers/staging/iio/light/Kconfig
+++ b/drivers/staging/iio/light/Kconfig
@@ -4,15 +4,16 @@
 menu "Light sensors"
 
 config SENSORS_ISL29018
-        tristate "ISL 29018 light and proximity sensor"
-        depends on I2C
-        default n
-        help
-         If you say yes here you get support for ambient light sensing and
-         proximity infrared sensing from Intersil ISL29018.
-         This driver will provide the measurements of ambient light intensity
-         in lux, proximity infrared sensing and normal infrared sensing.
-         Data from sensor is accessible via sysfs.
+	tristate "ISL 29018 light and proximity sensor"
+	depends on I2C
+	select REGMAP_I2C
+	default n
+	help
+	 If you say yes here you get support for ambient light sensing and
+	 proximity infrared sensing from Intersil ISL29018.
+	 This driver will provide the measurements of ambient light intensity
+	 in lux, proximity infrared sensing and normal infrared sensing.
+	 Data from sensor is accessible via sysfs.
 
 config SENSORS_ISL29028
 	tristate "Intersil ISL29028 Concurrent Light and Proximity Sensor"
diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
index 38ec52b..6682e84 100644
--- a/drivers/staging/iio/light/isl29018.c
+++ b/drivers/staging/iio/light/isl29018.c
@@ -26,9 +26,11 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/delay.h>
+#include <linux/regmap.h>
 #include <linux/slab.h>
 #include "../iio.h"
 #include "../sysfs.h"
+
 #define CONVERSION_TIME_MS		100
 
 #define ISL29018_REG_ADD_COMMAND1	0x00
@@ -51,49 +53,22 @@
 
 #define ISL29018_REG_ADD_DATA_LSB	0x02
 #define ISL29018_REG_ADD_DATA_MSB	0x03
-#define ISL29018_MAX_REGS		(ISL29018_REG_ADD_DATA_MSB+1)
 
 #define ISL29018_REG_TEST		0x08
 #define ISL29018_TEST_SHIFT		0
 #define ISL29018_TEST_MASK		(0xFF << ISL29018_TEST_SHIFT)
 
 struct isl29018_chip {
-	struct i2c_client	*client;
+	struct device		*dev;
+	struct regmap		*regmap;
 	struct mutex		lock;
 	unsigned int		lux_scale;
 	unsigned int		range;
 	unsigned int		adc_bit;
 	int			prox_scheme;
-	u8			reg_cache[ISL29018_MAX_REGS];
 };
 
-static int isl29018_write_data(struct i2c_client *client, u8 reg,
-			u8 val, u8 mask, u8 shift)
-{
-	u8 regval = val;
-	int ret;
-	struct isl29018_chip *chip = iio_priv(i2c_get_clientdata(client));
-
-	/* don't cache or mask REG_TEST */
-	if (reg < ISL29018_MAX_REGS) {
-		regval = chip->reg_cache[reg];
-		regval &= ~mask;
-		regval |= val << shift;
-	}
-
-	ret = i2c_smbus_write_byte_data(client, reg, regval);
-	if (ret) {
-		dev_err(&client->dev, "Write to device fails status %x\n", ret);
-	} else {
-		/* don't update cache on err */
-		if (reg < ISL29018_MAX_REGS)
-			chip->reg_cache[reg] = regval;
-	}
-
-	return ret;
-}
-
-static int isl29018_set_range(struct i2c_client *client, unsigned long range,
+static int isl29018_set_range(struct isl29018_chip *chip, unsigned long range,
 		unsigned int *new_range)
 {
 	static const unsigned long supp_ranges[] = {1000, 4000, 16000, 64000};
@@ -109,11 +84,11 @@ static int isl29018_set_range(struct i2c_client *client, unsigned long range,
 	if (i >= ARRAY_SIZE(supp_ranges))
 		return -EINVAL;
 
-	return isl29018_write_data(client, ISL29018_REG_ADD_COMMANDII,
-			i, COMMANDII_RANGE_MASK, COMMANDII_RANGE_SHIFT);
+	return regmap_update_bits(chip->regmap, ISL29018_REG_ADD_COMMANDII,
+			COMMANDII_RANGE_MASK, i << COMMANDII_RANGE_SHIFT);
 }
 
-static int isl29018_set_resolution(struct i2c_client *client,
+static int isl29018_set_resolution(struct isl29018_chip *chip,
 			unsigned long adcbit, unsigned int *conf_adc_bit)
 {
 	static const unsigned long supp_adcbit[] = {16, 12, 8, 4};
@@ -129,48 +104,49 @@ static int isl29018_set_resolution(struct i2c_client *client,
 	if (i >= ARRAY_SIZE(supp_adcbit))
 		return -EINVAL;
 
-	return isl29018_write_data(client, ISL29018_REG_ADD_COMMANDII,
-			i, COMMANDII_RESOLUTION_MASK,
-			COMMANDII_RESOLUTION_SHIFT);
+	return regmap_update_bits(chip->regmap, ISL29018_REG_ADD_COMMANDII,
+			COMMANDII_RESOLUTION_MASK,
+			i << COMMANDII_RESOLUTION_SHIFT);
 }
 
-static int isl29018_read_sensor_input(struct i2c_client *client, int mode)
+static int isl29018_read_sensor_input(struct isl29018_chip *chip, int mode)
 {
 	int status;
-	int lsb;
-	int msb;
+	unsigned int lsb;
+	unsigned int msb;
 
 	/* Set mode */
-	status = isl29018_write_data(client, ISL29018_REG_ADD_COMMAND1,
-			mode, COMMMAND1_OPMODE_MASK, COMMMAND1_OPMODE_SHIFT);
+	status = regmap_update_bits(chip->regmap, ISL29018_REG_ADD_COMMAND1,
+			COMMMAND1_OPMODE_MASK, mode << COMMMAND1_OPMODE_SHIFT);
 	if (status) {
-		dev_err(&client->dev, "Error in setting operating mode\n");
+		dev_err(chip->dev,
+			"Error in setting operating mode err %d\n", status);
 		return status;
 	}
 	msleep(CONVERSION_TIME_MS);
-	lsb = i2c_smbus_read_byte_data(client, ISL29018_REG_ADD_DATA_LSB);
-	if (lsb < 0) {
-		dev_err(&client->dev, "Error in reading LSB DATA\n");
-		return lsb;
+	status = regmap_read(chip->regmap, ISL29018_REG_ADD_DATA_LSB, &lsb);
+	if (status < 0) {
+		dev_err(chip->dev,
+			"Error in reading LSB DATA with err %d\n", status);
+		return status;
 	}
 
-	msb = i2c_smbus_read_byte_data(client, ISL29018_REG_ADD_DATA_MSB);
-	if (msb < 0) {
-		dev_err(&client->dev, "Error in reading MSB DATA\n");
+	status = regmap_read(chip->regmap, ISL29018_REG_ADD_DATA_MSB, &msb);
+	if (status < 0) {
+		dev_err(chip->dev,
+			"Error in reading MSB DATA with error %d\n", status);
 		return msb;
 	}
-	dev_vdbg(&client->dev, "MSB 0x%x and LSB 0x%x\n", msb, lsb);
+	dev_vdbg(chip->dev, "MSB 0x%x and LSB 0x%x\n", msb, lsb);
 
 	return (msb << 8) | lsb;
 }
 
-static int isl29018_read_lux(struct i2c_client *client, int *lux)
+static int isl29018_read_lux(struct isl29018_chip *chip, int *lux)
 {
 	int lux_data;
-	struct isl29018_chip *chip = iio_priv(i2c_get_clientdata(client));
 
-	lux_data = isl29018_read_sensor_input(client,
-				COMMMAND1_OPMODE_ALS_ONCE);
+	lux_data = isl29018_read_sensor_input(chip, COMMMAND1_OPMODE_ALS_ONCE);
 
 	if (lux_data < 0)
 		return lux_data;
@@ -180,11 +156,11 @@ static int isl29018_read_lux(struct i2c_client *client, int *lux)
 	return 0;
 }
 
-static int isl29018_read_ir(struct i2c_client *client, int *ir)
+static int isl29018_read_ir(struct isl29018_chip *chip, int *ir)
 {
 	int ir_data;
 
-	ir_data = isl29018_read_sensor_input(client, COMMMAND1_OPMODE_IR_ONCE);
+	ir_data = isl29018_read_sensor_input(chip, COMMMAND1_OPMODE_IR_ONCE);
 
 	if (ir_data < 0)
 		return ir_data;
@@ -194,7 +170,7 @@ static int isl29018_read_ir(struct i2c_client *client, int *ir)
 	return 0;
 }
 
-static int isl29018_read_proximity_ir(struct i2c_client *client, int scheme,
+static int isl29018_read_proximity_ir(struct isl29018_chip *chip, int scheme,
 		int *near_ir)
 {
 	int status;
@@ -202,14 +178,15 @@ static int isl29018_read_proximity_ir(struct i2c_client *client, int scheme,
 	int ir_data = -1;
 
 	/* Do proximity sensing with required scheme */
-	status = isl29018_write_data(client, ISL29018_REG_ADD_COMMANDII,
-			scheme, COMMANDII_SCHEME_MASK, COMMANDII_SCHEME_SHIFT);
+	status = regmap_update_bits(chip->regmap, ISL29018_REG_ADD_COMMANDII,
+			COMMANDII_SCHEME_MASK,
+			scheme << COMMANDII_SCHEME_SHIFT);
 	if (status) {
-		dev_err(&client->dev, "Error in setting operating mode\n");
+		dev_err(chip->dev, "Error in setting operating mode\n");
 		return status;
 	}
 
-	prox_data = isl29018_read_sensor_input(client,
+	prox_data = isl29018_read_sensor_input(chip,
 					COMMMAND1_OPMODE_PROX_ONCE);
 	if (prox_data < 0)
 		return prox_data;
@@ -219,8 +196,7 @@ static int isl29018_read_proximity_ir(struct i2c_client *client, int scheme,
 		return 0;
 	}
 
-	ir_data = isl29018_read_sensor_input(client,
-				COMMMAND1_OPMODE_IR_ONCE);
+	ir_data = isl29018_read_sensor_input(chip, COMMMAND1_OPMODE_IR_ONCE);
 
 	if (ir_data < 0)
 		return ir_data;
@@ -249,7 +225,6 @@ static ssize_t store_range(struct device *dev,
 {
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 	struct isl29018_chip *chip = iio_priv(indio_dev);
-	struct i2c_client *client = chip->client;
 	int status;
 	unsigned long lval;
 	unsigned int new_range;
@@ -264,10 +239,11 @@ static ssize_t store_range(struct device *dev,
 	}
 
 	mutex_lock(&chip->lock);
-	status = isl29018_set_range(client, lval, &new_range);
+	status = isl29018_set_range(chip, lval, &new_range);
 	if (status < 0) {
 		mutex_unlock(&chip->lock);
-		dev_err(dev, "Error in setting max range\n");
+		dev_err(dev,
+			"Error in setting max range with err %d\n", status);
 		return status;
 	}
 	chip->range = new_range;
@@ -291,7 +267,6 @@ static ssize_t store_resolution(struct device *dev,
 {
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 	struct isl29018_chip *chip = iio_priv(indio_dev);
-	struct i2c_client *client = chip->client;
 	int status;
 	unsigned long lval;
 	unsigned int new_adc_bit;
@@ -304,7 +279,7 @@ static ssize_t store_resolution(struct device *dev,
 	}
 
 	mutex_lock(&chip->lock);
-	status = isl29018_set_resolution(client, lval, &new_adc_bit);
+	status = isl29018_set_resolution(chip, lval, &new_adc_bit);
 	if (status < 0) {
 		mutex_unlock(&chip->lock);
 		dev_err(dev, "Error in setting resolution\n");
@@ -379,20 +354,19 @@ static int isl29018_read_raw(struct iio_dev *indio_dev,
 {
 	int ret = -EINVAL;
 	struct isl29018_chip *chip = iio_priv(indio_dev);
-	struct i2c_client *client = chip->client;
 
 	mutex_lock(&chip->lock);
 	switch (mask) {
 	case 0:
 		switch (chan->type) {
 		case IIO_LIGHT:
-			ret = isl29018_read_lux(client, val);
+			ret = isl29018_read_lux(chip, val);
 			break;
 		case IIO_INTENSITY:
-			ret = isl29018_read_ir(client, val);
+			ret = isl29018_read_ir(chip, val);
 			break;
 		case IIO_PROXIMITY:
-			ret = isl29018_read_proximity_ir(client,
+			ret = isl29018_read_proximity_ir(chip,
 					chip->prox_scheme, val);
 			break;
 		default:
@@ -456,15 +430,12 @@ static const struct attribute_group isl29108_group = {
 	.attrs = isl29018_attributes,
 };
 
-static int isl29018_chip_init(struct i2c_client *client)
+static int isl29018_chip_init(struct isl29018_chip *chip)
 {
-	struct isl29018_chip *chip = iio_priv(i2c_get_clientdata(client));
 	int status;
 	int new_adc_bit;
 	unsigned int new_range;
 
-	memset(chip->reg_cache, 0, sizeof(chip->reg_cache));
-
 	/* Code added per Intersil Application Note 1534:
 	 *     When VDD sinks to approximately 1.8V or below, some of
 	 * the part's registers may change their state. When VDD
@@ -485,10 +456,9 @@ static int isl29018_chip_init(struct i2c_client *client)
 	 * the same thing EXCEPT the data sheet asks for a 1ms delay after
 	 * writing the CMD1 register.
 	 */
-	status = isl29018_write_data(client, ISL29018_REG_TEST, 0,
-				ISL29018_TEST_MASK, ISL29018_TEST_SHIFT);
+	status = regmap_write(chip->regmap, ISL29018_REG_TEST, 0x0);
 	if (status < 0) {
-		dev_err(&client->dev, "Failed to clear isl29018 TEST reg."
+		dev_err(chip->dev, "Failed to clear isl29018 TEST reg."
 					"(%d)\n", status);
 		return status;
 	}
@@ -497,10 +467,9 @@ static int isl29018_chip_init(struct i2c_client *client)
 	 * "Operating Mode" (COMMAND1) register is reprogrammed when
 	 * data is read from the device.
 	 */
-	status = isl29018_write_data(client, ISL29018_REG_ADD_COMMAND1, 0,
-				0xff, 0);
+	status = regmap_write(chip->regmap, ISL29018_REG_ADD_COMMAND1, 0);
 	if (status < 0) {
-		dev_err(&client->dev, "Failed to clear isl29018 CMD1 reg."
+		dev_err(chip->dev, "Failed to clear isl29018 CMD1 reg."
 					"(%d)\n", status);
 		return status;
 	}
@@ -508,13 +477,13 @@ static int isl29018_chip_init(struct i2c_client *client)
 	msleep(1);	/* per data sheet, page 10 */
 
 	/* set defaults */
-	status = isl29018_set_range(client, chip->range, &new_range);
+	status = isl29018_set_range(chip, chip->range, &new_range);
 	if (status < 0) {
-		dev_err(&client->dev, "Init of isl29018 fails\n");
+		dev_err(chip->dev, "Init of isl29018 fails\n");
 		return status;
 	}
 
-	status = isl29018_set_resolution(client, chip->adc_bit,
+	status = isl29018_set_resolution(chip, chip->adc_bit,
 						&new_adc_bit);
 
 	return 0;
@@ -527,6 +496,32 @@ static const struct iio_info isl29108_info = {
 	.write_raw = &isl29018_write_raw,
 };
 
+static bool is_volatile_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case ISL29018_REG_ADD_DATA_LSB:
+	case ISL29018_REG_ADD_DATA_MSB:
+	case ISL29018_REG_ADD_COMMAND1:
+	case ISL29018_REG_TEST:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/*
+ * isl29018_regmap_config: regmap configuration.
+ * Use RBTREE mechanism for caching.
+ */
+static const struct regmap_config isl29018_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.volatile_reg = is_volatile_reg,
+	.max_register = ISL29018_REG_TEST,
+	.num_reg_defaults_raw = ISL29018_REG_TEST + 1,
+	.cache_type = REGCACHE_RBTREE,
+};
+
 static int __devinit isl29018_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
@@ -543,7 +538,7 @@ static int __devinit isl29018_probe(struct i2c_client *client,
 	chip = iio_priv(indio_dev);
 
 	i2c_set_clientdata(client, indio_dev);
-	chip->client = client;
+	chip->dev = &client->dev;
 
 	mutex_init(&chip->lock);
 
@@ -551,7 +546,14 @@ static int __devinit isl29018_probe(struct i2c_client *client,
 	chip->range = 1000;
 	chip->adc_bit = 16;
 
-	err = isl29018_chip_init(client);
+	chip->regmap = devm_regmap_init_i2c(client, &isl29018_regmap_config);
+	if (IS_ERR(chip->regmap)) {
+		err = PTR_ERR(chip->regmap);
+		dev_err(chip->dev, "regmap initialization failed: %d\n", err);
+		goto exit;
+	}
+
+	err = isl29018_chip_init(chip);
 	if (err)
 		goto exit_iio_free;
 
-- 
1.7.1.1

