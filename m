Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab0IHC4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 22:56:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44820 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303Ab0IHC4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 22:56:39 -0400
Date: Wed, 08 Sep 2010 11:56:36 +0900
From: Kyungmin Park <kyungmin.park@samsung.com>
Subject: RE: [PATCH v3] regulators: add support max8952 regulator
In-reply-to: <1283901976-32588-1-git-send-email-kgene.kim@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: lrg@slimlogic.co.uk, "'Changhwan Youn'" <chaos.youn@samsung.com>,
        "'MyungJoo Ham'" <myungjoo.ham@samsung.com>
Reply-to: kyungmin.park@samsung.com
Message-id: <01a401cb4f01$73d60ac0$5b822040$%park@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: ActO5kLH59RwdkyyRB6bO2YWhCCsKgAGvnQQ
References: <1283901976-32588-1-git-send-email-kgene.kim@samsung.com>
X-OriginalArrivalTime: 08 Sep 2010 02:56:37.0461 (UTC)
 FILETIME=[7447B850:01CB4F01]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do you check the DVS feature?
It can support the DVS by GPIOs and platform can set the each voltages at
each mode.

As quick review of max8649. It can't support it.

Thank you,
Kyungmin Park

-----Original Message-----
From: Kukjin Kim [mailto:kgene.kim@samsung.com] 
Sent: Wednesday, September 08, 2010 8:26 AM
To: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
linux-samsung-soc@vger.kernel.org
Cc: lrg@slimlogic.co.uk; Changhwan Youn; Kukjin Kim; MyungJoo Ham; Kyungmin
Park
Subject: [PATCH v3] regulators: add support max8952 regulator

From: Changhwan Youn <chaos.youn@samsung.com>

The operation of max8952 is almost similar to max8649 except the output
voltage range. This patch adds support the max8952 regulator using
current max8649 implementation. And removes separate max8952.[ch] files
since the functionality is now merged into this driver.

Signed-off-by: Changhwan Youn <chaos.youn@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
Following is as per Mark Brown's suggestion.
Changes since v2:
- Removed separate max8952.[ch] files

Changes since v1:
- Added returning fail when detected wrong ID
- Added matching the ID from the chip in case the user got things wrong
- Added enum chip ID instead of 0, 1

 drivers/regulator/Kconfig         |   12 +-
 drivers/regulator/Makefile        |    1 -
 drivers/regulator/max8649.c       |   55 +++++-
 drivers/regulator/max8952.c       |  360
-------------------------------------
 include/linux/regulator/max8952.h |  135 --------------
 5 files changed, 50 insertions(+), 513 deletions(-)
 delete mode 100644 drivers/regulator/max8952.c
 delete mode 100644 include/linux/regulator/max8952.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 4889caa..fab9a90 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -81,10 +81,10 @@ config REGULATOR_MAX1586
 	  for PXA27x chips to control VCC_CORE and VCC_USIM voltages.
 
 config REGULATOR_MAX8649
-	tristate "Maxim 8649 voltage regulator"
+	tristate "Maxim 8649/8952 voltage regulator"
 	depends on I2C
 	help
-	  This driver controls a Maxim 8649 voltage output regulator via
+	  This driver controls a Maxim 8649/8952 voltage output regulator
via
 	  I2C bus.
 
 config REGULATOR_MAX8660
@@ -100,14 +100,6 @@ config REGULATOR_MAX8925
 	help
 	  Say y here to support the voltage regulaltor of Maxim MAX8925
PMIC.
 
-config REGULATOR_MAX8952
-	tristate "Maxim MAX8952 Power Management IC"
-	depends on I2C
-	help
-	  This driver controls a Maxim 8952 voltage output regulator
-	  via I2C bus. Maxim 8952 has one voltage output and supports 4 DVS
-	  modes ranging from 0.77V to 1.40V by 0.01V steps.
-
 config REGULATOR_MAX8998
 	tristate "Maxim 8998 voltage regulator"
 	depends on MFD_MAX8998
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index beff6da..8285fd8 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -17,7 +17,6 @@ obj-$(CONFIG_REGULATOR_TWL4030) += twl-regulator.o
 obj-$(CONFIG_REGULATOR_MAX8649)	+= max8649.o
 obj-$(CONFIG_REGULATOR_MAX8660) += max8660.o
 obj-$(CONFIG_REGULATOR_MAX8925) += max8925-regulator.o
-obj-$(CONFIG_REGULATOR_MAX8952) += max8952.o
 obj-$(CONFIG_REGULATOR_MAX8998) += max8998.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-dcdc.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-isink.o
diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 4520ace..7f61a3a 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -22,6 +22,9 @@
 #define MAX8649_DCDC_STEP	10000		/* uV */
 #define MAX8649_VOL_MASK	0x3f
 
+/* difference between voltages of max8649 and max8952 */
+#define DIFF_MAX8952_DCDC_VOL	20000		/* uV */
+
 /* Registers */
 #define MAX8649_MODE0		0x00
 #define MAX8649_MODE1		0x01
@@ -47,6 +50,11 @@
 #define MAX8649_RAMP_MASK	(7 << 5)
 #define MAX8649_RAMP_DOWN	(1 << 1)
 
+enum chips {
+	MAX8649 = 0x200a,
+	MAX8952 = 0x201a,
+};
+
 struct max8649_regulator_info {
 	struct regulator_dev	*regulator;
 	struct i2c_client	*i2c;
@@ -54,6 +62,7 @@ struct max8649_regulator_info {
 	struct mutex		io_lock;
 
 	int		vol_reg;
+	int		type;
 	unsigned	mode:2;	/* bit[1:0] = VID1, VID0 */
 	unsigned	extclk_freq:2;
 	unsigned	extclk:1;
@@ -138,7 +147,12 @@ static inline int check_range(int min_uV, int max_uV)
 
 static int max8649_list_voltage(struct regulator_dev *rdev, unsigned index)
 {
-	return (MAX8649_DCDC_VMIN + index * MAX8649_DCDC_STEP);
+	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
+	int ret = MAX8649_DCDC_VMIN + index * MAX8649_DCDC_STEP;
+
+	if (info->type == MAX8952)
+		ret += DIFF_MAX8952_DCDC_VOL;
+	return ret;
 }
 
 static int max8649_get_voltage(struct regulator_dev *rdev)
@@ -160,6 +174,11 @@ static int max8649_set_voltage(struct regulator_dev
*rdev,
 	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
 	unsigned char data, mask;
 
+	if (info->type == MAX8952) {
+		min_uV -= DIFF_MAX8952_DCDC_VOL;
+		max_uV -= DIFF_MAX8952_DCDC_VOL;
+	}
+
 	if (check_range(min_uV, max_uV)) {
 		dev_err(info->dev, "invalid voltage range (%d, %d) uV\n",
 			min_uV, max_uV);
@@ -263,7 +282,6 @@ static struct regulator_ops max8649_dcdc_ops = {
 	.enable_time	= max8649_enable_time,
 	.set_mode	= max8649_set_mode,
 	.get_mode	= max8649_get_mode,
-
 };
 
 static struct regulator_desc dcdc_desc = {
@@ -281,6 +299,7 @@ static int __devinit max8649_regulator_probe(struct
i2c_client *client,
 	struct max8649_regulator_info *info = NULL;
 	unsigned char data;
 	int ret;
+	int chip_id;
 
 	info = kzalloc(sizeof(struct max8649_regulator_info), GFP_KERNEL);
 	if (!info) {
@@ -313,11 +332,32 @@ static int __devinit max8649_regulator_probe(struct
i2c_client *client,
 
 	ret = max8649_reg_read(info->i2c, MAX8649_CHIP_ID1);
 	if (ret < 0) {
-		dev_err(info->dev, "Failed to detect ID of MAX8649:%d\n",
-			ret);
+		dev_err(info->dev, "Failed to detect ID1 of %s:%d\n",
+			id->name, ret);
 		goto out;
 	}
-	dev_info(info->dev, "Detected MAX8649 (ID:%x)\n", ret);
+	chip_id = ret;
+
+	ret = max8649_reg_read(info->i2c, MAX8649_CHIP_ID2);
+	if (ret < 0) {
+		dev_err(info->dev, "Failed to detect ID2 of %s:%d\n",
+			id->name, ret);
+		goto out;
+	}
+
+	chip_id = (chip_id << 8) | ret;
+
+	if (id->driver_data != chip_id) {
+		dev_err(info->dev, "Failed to detect the device\n"
+				   "requested : 0x%x, detected 0x%x\n",
+				   id->driver_data, chip_id);
+		ret = -ENODEV;
+		goto out;
+	}
+
+	dev_info(info->dev, "Detected %s (ID: 0x%x)\n", id->name, chip_id);
+
+	info->type = id->driver_data;
 
 	/* enable VID0 & VID1 */
 	max8649_set_bits(info->i2c, MAX8649_CONTROL, MAX8649_VID_MASK, 0);
@@ -354,7 +394,7 @@ static int __devinit max8649_regulator_probe(struct
i2c_client *client,
 		goto out;
 	}
 
-	dev_info(info->dev, "Max8649 regulator device is detected.\n");
+	dev_info(info->dev, "%s regulator device is detected.\n", id->name);
 	return 0;
 out:
 	kfree(info);
@@ -375,7 +415,8 @@ static int __devexit max8649_regulator_remove(struct
i2c_client *client)
 }
 
 static const struct i2c_device_id max8649_id[] = {
-	{ "max8649", 0 },
+	{ "max8649", MAX8649 },
+	{ "max8952", MAX8952 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max8649_id);
diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
deleted file mode 100644
index f2af0b1..0000000
--- a/drivers/regulator/max8952.c
+++ /dev/null
@@ -1,360 +0,0 @@
-/*
- * max8952.c - Voltage and current regulation for the Maxim 8952
- *
- * Copyright (C) 2010 Samsung Electronics
- * MyungJoo Ham <myungjoo.ham@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
USA
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/i2c.h>
-#include <linux/err.h>
-#include <linux/platform_device.h>
-#include <linux/regulator/driver.h>
-#include <linux/regulator/max8952.h>
-#include <linux/mutex.h>
-#include <linux/gpio.h>
-#include <linux/io.h>
-#include <linux/slab.h>
-
-/* Registers */
-enum {
-	MAX8952_REG_MODE0,
-	MAX8952_REG_MODE1,
-	MAX8952_REG_MODE2,
-	MAX8952_REG_MODE3,
-	MAX8952_REG_CONTROL,
-	MAX8952_REG_SYNC,
-	MAX8952_REG_RAMP,
-	MAX8952_REG_CHIP_ID1,
-	MAX8952_REG_CHIP_ID2,
-};
-
-struct max8952_data {
-	struct i2c_client	*client;
-	struct device		*dev;
-	struct mutex		mutex;
-	struct max8952_platform_data *pdata;
-	struct regulator_dev	*rdev;
-
-	bool vid0;
-	bool vid1;
-	bool en;
-};
-
-static int max8952_read_reg(struct max8952_data *max8952, u8 reg)
-{
-	int ret = i2c_smbus_read_byte_data(max8952->client, reg);
-	if (ret > 0)
-		ret &= 0xff;
-
-	return ret;
-}
-
-static int max8952_write_reg(struct max8952_data *max8952,
-		u8 reg, u8 value)
-{
-	return i2c_smbus_write_byte_data(max8952->client, reg, value);
-}
-
-static int max8952_voltage(struct max8952_data *max8952, u8 mode)
-{
-	return (max8952->pdata->dvs_mode[mode] * 10 + 770) * 1000;
-}
-
-static int max8952_list_voltage(struct regulator_dev *rdev,
-		unsigned int selector)
-{
-	struct max8952_data *max8952 = rdev_get_drvdata(rdev);
-
-	if (rdev_get_id(rdev) != 0)
-		return -EINVAL;
-
-	return max8952_voltage(max8952, selector);
-}
-
-static int max8952_is_enabled(struct regulator_dev *rdev)
-{
-	struct max8952_data *max8952 = rdev_get_drvdata(rdev);
-	return max8952->en;
-}
-
-static int max8952_enable(struct regulator_dev *rdev)
-{
-	struct max8952_data *max8952 = rdev_get_drvdata(rdev);
-
-	/* If not valid, assume "ALWAYS_HIGH" */
-	if (gpio_is_valid(max8952->pdata->gpio_en))
-		gpio_set_value(max8952->pdata->gpio_en, 1);
-
-	max8952->en = true;
-	return 0;
-}
-
-static int max8952_disable(struct regulator_dev *rdev)
-{
-	struct max8952_data *max8952 = rdev_get_drvdata(rdev);
-
-	/* If not valid, assume "ALWAYS_HIGH" -> not permitted */
-	if (gpio_is_valid(max8952->pdata->gpio_en))
-		gpio_set_value(max8952->pdata->gpio_en, 0);
-	else
-		return -EPERM;
-
-	max8952->en = false;
-	return 0;
-}
-
-static int max8952_get_voltage(struct regulator_dev *rdev)
-{
-	struct max8952_data *max8952 = rdev_get_drvdata(rdev);
-	u8 vid = 0;
-
-	if (max8952->vid0)
-		vid += 1;
-	if (max8952->vid1)
-		vid += 2;
-
-	return max8952_voltage(max8952, vid);
-}
-
-static int max8952_set_voltage(struct regulator_dev *rdev,
-				int min_uV, int max_uV)
-{
-	struct max8952_data *max8952 = rdev_get_drvdata(rdev);
-	u8 vid = -1, i;
-
-	if (!gpio_is_valid(max8952->pdata->gpio_vid0) ||
-			!gpio_is_valid(max8952->pdata->gpio_vid0)) {
-		/* DVS not supported */
-		return -EPERM;
-	}
-
-	for (i = 0; i < MAX8952_NUM_DVS_MODE; i++) {
-		int volt = max8952_voltage(max8952, i);
-
-		/* Set the voltage as low as possible within the range */
-		if (volt <= max_uV && volt >= min_uV)
-			if (vid == -1 || max8952_voltage(max8952, vid) >
volt)
-				vid = i;
-	}
-
-	if (vid >= 0 && vid < MAX8952_NUM_DVS_MODE) {
-		max8952->vid0 = (vid % 2 == 1);
-		max8952->vid1 = (((vid >> 1) % 2) == 1);
-		gpio_set_value(max8952->pdata->gpio_vid0, max8952->vid0);
-		gpio_set_value(max8952->pdata->gpio_vid1, max8952->vid1);
-	} else
-		return -EINVAL;
-
-	return 0;
-}
-
-static struct regulator_ops max8952_ops = {
-	.list_voltage		= max8952_list_voltage,
-	.is_enabled		= max8952_is_enabled,
-	.enable			= max8952_enable,
-	.disable		= max8952_disable,
-	.get_voltage		= max8952_get_voltage,
-	.set_voltage		= max8952_set_voltage,
-	.set_suspend_disable	= max8952_disable,
-};
-
-static struct regulator_desc regulator = {
-	.name		= "MAX8952_VOUT",
-	.id		= 0,
-	.n_voltages	= MAX8952_NUM_DVS_MODE,
-	.ops		= &max8952_ops,
-	.type		= REGULATOR_VOLTAGE,
-	.owner		= THIS_MODULE,
-};
-
-static int __devinit max8952_pmic_probe(struct i2c_client *client,
-		const struct i2c_device_id *i2c_id)
-{
-	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
-	struct max8952_platform_data *pdata = client->dev.platform_data;
-	struct max8952_data *max8952;
-
-	int ret = 0, err = 0;
-
-	if (!pdata) {
-		dev_err(&client->dev, "Require the platform data\n");
-		return -EINVAL;
-	}
-
-	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE))
-		return -EIO;
-
-	max8952 = kzalloc(sizeof(struct max8952_data), GFP_KERNEL);
-	if (!max8952)
-		return -ENOMEM;
-
-	max8952->client = client;
-	max8952->dev = &client->dev;
-	max8952->pdata = pdata;
-	mutex_init(&max8952->mutex);
-
-	max8952->rdev = regulator_register(&regulator, max8952->dev,
-			&pdata->reg_data, max8952);
-
-	ret = IS_ERR(max8952->rdev);
-	if (ret)
-		dev_err(max8952->dev, "regulator init failed (%d)\n", ret);
-
-	max8952->en = !!(pdata->reg_data.constraints.boot_on);
-	max8952->vid0 = (pdata->default_mode % 2) == 1;
-	max8952->vid1 = ((pdata->default_mode >> 1) % 2) == 1;
-
-	if (gpio_is_valid(pdata->gpio_en)) {
-		if (!gpio_request(pdata->gpio_en, "MAX8952 EN"))
-			gpio_direction_output(pdata->gpio_en, max8952->en);
-		else
-			err = 1;
-	} else
-		err = 2;
-
-	if (err) {
-		dev_info(max8952->dev, "EN gpio invalid: assume that EN"
-				"is always High\n");
-		max8952->en = 1;
-		pdata->gpio_en = -1; /* Mark invalid */
-	}
-
-	err = 0;
-
-	if (gpio_is_valid(pdata->gpio_vid0) &&
-			gpio_is_valid(pdata->gpio_vid1)) {
-		if (!gpio_request(pdata->gpio_vid0, "MAX8952 VID0"))
-			gpio_direction_output(pdata->gpio_vid0,
-					(pdata->default_mode) % 2);
-		else
-			err = 1;
-
-		if (!gpio_request(pdata->gpio_vid1, "MAX8952 VID1"))
-			gpio_direction_output(pdata->gpio_vid1,
-				(pdata->default_mode >> 1) % 2);
-		else {
-			if (!err)
-				gpio_free(pdata->gpio_vid0);
-			err = 2;
-		}
-
-	} else
-		err = 3;
-
-	if (err) {
-		dev_warn(max8952->dev, "VID0/1 gpio invalid: "
-				"DVS not avilable.\n");
-		max8952->vid0 = 0;
-		max8952->vid1 = 0;
-		/* Mark invalid */
-		pdata->gpio_vid0 = -1;
-		pdata->gpio_vid1 = -1;
-
-		/* Disable Pulldown of EN only */
-		max8952_write_reg(max8952, MAX8952_REG_CONTROL, 0x60);
-
-		dev_err(max8952->dev, "DVS modes disabled because VID0 and
VID1"
-				" do not have proper controls.\n");
-	} else {
-		/*
-		 * Disable Pulldown on EN, VID0, VID1 to reduce
-		 * leakage current of MAX8952 assuming that MAX8952
-		 * is turned on (EN==1). Note that without having VID0/1
-		 * properly connected, turning pulldown off can be
-		 * problematic. Thus, turn this off only when they are
-		 * controllable by GPIO.
-		 */
-		max8952_write_reg(max8952, MAX8952_REG_CONTROL, 0x0);
-	}
-
-	max8952_write_reg(max8952, MAX8952_REG_MODE0,
-			(max8952_read_reg(max8952,
-					  MAX8952_REG_MODE0) & 0xC0) |
-			(pdata->dvs_mode[0] & 0x3F));
-	max8952_write_reg(max8952, MAX8952_REG_MODE1,
-			(max8952_read_reg(max8952,
-					  MAX8952_REG_MODE1) & 0xC0) |
-			(pdata->dvs_mode[1] & 0x3F));
-	max8952_write_reg(max8952, MAX8952_REG_MODE2,
-			(max8952_read_reg(max8952,
-					  MAX8952_REG_MODE2) & 0xC0) |
-			(pdata->dvs_mode[2] & 0x3F));
-	max8952_write_reg(max8952, MAX8952_REG_MODE3,
-			(max8952_read_reg(max8952,
-					  MAX8952_REG_MODE3) & 0xC0) |
-			(pdata->dvs_mode[3] & 0x3F));
-
-	max8952_write_reg(max8952, MAX8952_REG_SYNC,
-			(max8952_read_reg(max8952, MAX8952_REG_SYNC) & 0x3F)
|
-			((pdata->sync_freq & 0x3) << 6));
-	max8952_write_reg(max8952, MAX8952_REG_RAMP,
-			(max8952_read_reg(max8952, MAX8952_REG_RAMP) & 0x1F)
|
-			((pdata->ramp_speed & 0x7) << 5));
-
-	i2c_set_clientdata(client, max8952);
-
-	return ret;
-}
-
-static int __devexit max8952_pmic_remove(struct i2c_client *client)
-{
-	struct max8952_data *max8952 = i2c_get_clientdata(client);
-	struct max8952_platform_data *pdata = max8952->pdata;
-	struct regulator_dev *rdev = max8952->rdev;
-
-	regulator_unregister(rdev);
-
-	gpio_free(pdata->gpio_vid0);
-	gpio_free(pdata->gpio_vid1);
-	gpio_free(pdata->gpio_en);
-
-	kfree(max8952);
-	return 0;
-}
-
-static const struct i2c_device_id max8952_ids[] = {
-	{ "max8952", 0 },
-	{ },
-};
-MODULE_DEVICE_TABLE(i2c, max8952_ids);
-
-static struct i2c_driver max8952_pmic_driver = {
-	.probe		= max8952_pmic_probe,
-	.remove		= __devexit_p(max8952_pmic_remove),
-	.driver		= {
-		.name	= "max8952",
-	},
-	.id_table	= max8952_ids,
-};
-
-static int __init max8952_pmic_init(void)
-{
-	return i2c_add_driver(&max8952_pmic_driver);
-}
-subsys_initcall(max8952_pmic_init);
-
-static void __exit max8952_pmic_exit(void)
-{
-	i2c_del_driver(&max8952_pmic_driver);
-}
-module_exit(max8952_pmic_exit);
-
-MODULE_DESCRIPTION("MAXIM 8952 voltage regulator driver");
-MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
-MODULE_LICENSE("GPL");
diff --git a/include/linux/regulator/max8952.h
b/include/linux/regulator/max8952.h
deleted file mode 100644
index 45e4285..0000000
--- a/include/linux/regulator/max8952.h
+++ /dev/null
@@ -1,135 +0,0 @@
-/*
- * max8952.h - Voltage regulation for the Maxim 8952
- *
- *  Copyright (C) 2010 Samsung Electrnoics
- *  MyungJoo Ham <myungjoo.ham@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
USA
- */
-
-#ifndef REGULATOR_MAX8952
-#define REGULATOR_MAX8952
-
-#include <linux/regulator/machine.h>
-
-enum {
-	MAX8952_DVS_MODE0,
-	MAX8952_DVS_MODE1,
-	MAX8952_DVS_MODE2,
-	MAX8952_DVS_MODE3,
-};
-
-enum {
-	MAX8952_DVS_770mV = 0,
-	MAX8952_DVS_780mV,
-	MAX8952_DVS_790mV,
-	MAX8952_DVS_800mV,
-	MAX8952_DVS_810mV,
-	MAX8952_DVS_820mV,
-	MAX8952_DVS_830mV,
-	MAX8952_DVS_840mV,
-	MAX8952_DVS_850mV,
-	MAX8952_DVS_860mV,
-	MAX8952_DVS_870mV,
-	MAX8952_DVS_880mV,
-	MAX8952_DVS_890mV,
-	MAX8952_DVS_900mV,
-	MAX8952_DVS_910mV,
-	MAX8952_DVS_920mV,
-	MAX8952_DVS_930mV,
-	MAX8952_DVS_940mV,
-	MAX8952_DVS_950mV,
-	MAX8952_DVS_960mV,
-	MAX8952_DVS_970mV,
-	MAX8952_DVS_980mV,
-	MAX8952_DVS_990mV,
-	MAX8952_DVS_1000mV,
-	MAX8952_DVS_1010mV,
-	MAX8952_DVS_1020mV,
-	MAX8952_DVS_1030mV,
-	MAX8952_DVS_1040mV,
-	MAX8952_DVS_1050mV,
-	MAX8952_DVS_1060mV,
-	MAX8952_DVS_1070mV,
-	MAX8952_DVS_1080mV,
-	MAX8952_DVS_1090mV,
-	MAX8952_DVS_1100mV,
-	MAX8952_DVS_1110mV,
-	MAX8952_DVS_1120mV,
-	MAX8952_DVS_1130mV,
-	MAX8952_DVS_1140mV,
-	MAX8952_DVS_1150mV,
-	MAX8952_DVS_1160mV,
-	MAX8952_DVS_1170mV,
-	MAX8952_DVS_1180mV,
-	MAX8952_DVS_1190mV,
-	MAX8952_DVS_1200mV,
-	MAX8952_DVS_1210mV,
-	MAX8952_DVS_1220mV,
-	MAX8952_DVS_1230mV,
-	MAX8952_DVS_1240mV,
-	MAX8952_DVS_1250mV,
-	MAX8952_DVS_1260mV,
-	MAX8952_DVS_1270mV,
-	MAX8952_DVS_1280mV,
-	MAX8952_DVS_1290mV,
-	MAX8952_DVS_1300mV,
-	MAX8952_DVS_1310mV,
-	MAX8952_DVS_1320mV,
-	MAX8952_DVS_1330mV,
-	MAX8952_DVS_1340mV,
-	MAX8952_DVS_1350mV,
-	MAX8952_DVS_1360mV,
-	MAX8952_DVS_1370mV,
-	MAX8952_DVS_1380mV,
-	MAX8952_DVS_1390mV,
-	MAX8952_DVS_1400mV,
-};
-
-enum {
-	MAX8952_SYNC_FREQ_26MHZ, /* Default */
-	MAX8952_SYNC_FREQ_13MHZ,
-	MAX8952_SYNC_FREQ_19_2MHZ,
-};
-
-enum {
-	MAX8952_RAMP_32mV_us = 0, /* Default */
-	MAX8952_RAMP_16mV_us,
-	MAX8952_RAMP_8mV_us,
-	MAX8952_RAMP_4mV_us,
-	MAX8952_RAMP_2mV_us,
-	MAX8952_RAMP_1mV_us,
-	MAX8952_RAMP_0_5mV_us,
-	MAX8952_RAMP_0_25mV_us,
-};
-
-#define MAX8952_NUM_DVS_MODE	4
-
-struct max8952_platform_data {
-	int gpio_vid0;
-	int gpio_vid1;
-	int gpio_en;
-
-	u8 default_mode;
-	u8 dvs_mode[MAX8952_NUM_DVS_MODE]; /* MAX8952_DVS_MODEx_XXXXmV */
-
-	u8 sync_freq;
-	u8 ramp_speed;
-
-	struct regulator_init_data reg_data;
-};
-
-
-#endif /* REGULATOR_MAX8952 */
-- 
1.6.2.5

