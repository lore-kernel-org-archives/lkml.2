Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab0FOMDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 08:03:17 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45658 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab0FOMDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 08:03:15 -0400
Date: Tue, 15 Jun 2010 14:03:08 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v2] drivers: regulator: add Maxim 8998 driver
To: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com
Message-id: <1276603388-8022-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

This patch adds voltage regulator driver for Maxim 8998 chip. This chip
is used on Samsung Aquila and GONI boards and provides following
functionalities:
- 4 BUCK voltage converters, 17 LDO power regulators and 5 other power
  controllers
- battery charger
- RTC

This patch adds basic driver for voltage regulators and MAX 8998 MFD core.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

---

Changes since V1:
- converted to MFD framework (for future extensions with RTC and battery
  charger drivers)
- removed i2c register cache
- removed dummy irq support (gpio keys will be used for setting irq_wake)
- removed static voltage map tables
- introduced atomic register update io function
- other code cleanup suggested by Mark Brown

---
 drivers/mfd/Kconfig                 |   10 +
 drivers/mfd/Makefile                |    1 +
 drivers/mfd/max8998.c               |  154 +++++++++
 drivers/regulator/Kconfig           |    8 +
 drivers/regulator/Makefile          |    1 +
 drivers/regulator/max8998.c         |  628 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8998-private.h |   92 +++++
 include/linux/mfd/max8998.h         |   78 +++++
 8 files changed, 972 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/max8998.c
 create mode 100644 drivers/regulator/max8998.c
 create mode 100644 include/linux/mfd/max8998-private.h
 create mode 100644 include/linux/mfd/max8998.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9da0e50..ad61a9e 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -252,6 +252,16 @@ config MFD_MAX8925
 	  accessing the device, additional drivers must be enabled in order
 	  to use the functionality of the device.
 
+config MFD_MAX8998
+	bool "Maxim Semiconductor MAX8998 PMIC Support"
+	depends on I2C=y
+	select MFD_CORE
+	help
+	  Say yes here to support for Maxim Semiconductor MAX8998. This is
+	  a Power Management IC. This driver provies common support for
+	  accessing the device, additional drivers must be enabled in order
+	  to use the functionality of the device.
+
 config MFD_WM8400
 	tristate "Support Wolfson Microelectronics WM8400"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index fb503e7..a362ccf 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_UCB1400_CORE)	+= ucb1400_core.o
 obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
 max8925-objs			:= max8925-core.o max8925-i2c.o
 obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
+obj-$(CONFIG_MFD_MAX8998)	+= max8998.o
 
 pcf50633-objs			:= pcf50633-core.o pcf50633-irq.o
 obj-$(CONFIG_MFD_PCF50633)	+= pcf50633.o
diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
new file mode 100644
index 0000000..c1f4be5
--- /dev/null
+++ b/drivers/mfd/max8998.c
@@ -0,0 +1,154 @@
+/*
+ * max8998.c - mfd core driver for the Maxim 8998
+ *
+ *  Copyright (C) 2009-2010 Samsung Electronics
+ *  Kyungmin Park <kyungmin.park@samsung.com>
+ *  Marek Szyprowski <m.szyprowski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/max8998.h>
+#include <linux/mfd/max8998-private.h>
+
+static struct mfd_cell max8998_devs[] = {
+	{
+		.name = "max8998-pmic",
+	}, {
+		.name = "max8998-rtc",
+	},
+};
+
+static int max8998_i2c_device_read(struct max8998_dev *max8998, u8 reg, u8 *dest)
+{
+	struct i2c_client *client = max8998->i2c_client;
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(client, reg);
+	if (ret < 0)
+		return ret;
+
+	ret &= 0xff;
+	*dest = ret;
+	return 0;
+}
+
+static int max8998_i2c_device_write(struct max8998_dev *max8998, u8 reg, u8 value)
+{
+	struct i2c_client *client = max8998->i2c_client;
+	int ret;
+
+	ret = i2c_smbus_write_byte_data(client, reg, value);
+	return ret;
+}
+
+static int max8998_i2c_device_update(struct max8998_dev *max8998, u8 reg,
+				     u8 val, u8 mask)
+{
+	struct i2c_client *client = max8998->i2c_client;
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(client, reg);
+	if (ret >= 0) {
+		u8 old_val = ret & 0xff;
+		u8 new_val = (val & mask) | (old_val & (~mask));
+		ret = i2c_smbus_write_byte_data(client, reg, new_val);
+		if (ret >= 0)
+			ret = 0;
+	}
+	return ret;
+}
+
+static int max8998_i2c_probe(struct i2c_client *i2c,
+			    const struct i2c_device_id *id)
+{
+	struct max8998_dev *max8998;
+	int ret = 0;
+
+	max8998 = kzalloc(sizeof(struct max8998_dev), GFP_KERNEL);
+	if (max8998 == NULL) {
+		kfree(i2c);
+		return -ENOMEM;
+	}
+
+	i2c_set_clientdata(i2c, max8998);
+	max8998->dev = &i2c->dev;
+	max8998->i2c_client = i2c;
+	max8998->dev_read = max8998_i2c_device_read;
+	max8998->dev_write = max8998_i2c_device_write;
+	max8998->dev_update = max8998_i2c_device_update;
+
+	ret = mfd_add_devices(max8998->dev, -1,
+			      max8998_devs, ARRAY_SIZE(max8998_devs),
+			      NULL, 0);
+	if (ret < 0)
+		goto err;
+
+	return ret;
+
+err:
+	mfd_remove_devices(max8998->dev);
+	kfree(max8998);
+	return ret;
+}
+
+static int max8998_i2c_remove(struct i2c_client *i2c)
+{
+	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
+
+	mfd_remove_devices(max8998->dev);
+	kfree(max8998);
+
+	return 0;
+}
+
+static const struct i2c_device_id max8998_i2c_id[] = {
+       { "max8998", 0 },
+       { }
+};
+MODULE_DEVICE_TABLE(i2c, max8998_i2c_id);
+
+static struct i2c_driver max8998_i2c_driver = {
+	.driver = {
+		   .name = "max8998",
+		   .owner = THIS_MODULE,
+	},
+	.probe = max8998_i2c_probe,
+	.remove = max8998_i2c_remove,
+	.id_table = max8998_i2c_id,
+};
+
+static int __init max8998_i2c_init(void)
+{
+	return i2c_add_driver(&max8998_i2c_driver);
+}
+/* init early so consumer devices can complete system boot */
+subsys_initcall(max8998_i2c_init);
+
+static void __exit max8998_i2c_exit(void)
+{
+	i2c_del_driver(&max8998_i2c_driver);
+}
+module_exit(max8998_i2c_exit);
+
+MODULE_DESCRIPTION("MAXIM 8998 multi-function core driver");
+MODULE_AUTHOR("Kyungmin Park <kyungmin.park@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 679ea37..e041dce 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -100,6 +100,14 @@ config REGULATOR_MAX8925
 	help
 	  Say y here to support the voltage regulaltor of Maxim MAX8925 PMIC.
 
+config REGULATOR_MAX8998
+	tristate "Maxim 8998 voltage regulator"
+	depends on I2C
+	help
+	  This driver controls a Maxim 8998 voltage output regulator
+	  via I2C bus. The provided regulator is suitable for S3C6410
+	  and S5PC1XX chips to control VCC_CORE and VCC_USIM voltages.
+
 config REGULATOR_TWL4030
 	bool "TI TWL4030/TWL5030/TWL6030/TPS695x0 PMIC"
 	depends on TWL4030_CORE
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index c256668..eafaa68 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_REGULATOR_TWL4030) += twl-regulator.o
 obj-$(CONFIG_REGULATOR_MAX8649)	+= max8649.o
 obj-$(CONFIG_REGULATOR_MAX8660) += max8660.o
 obj-$(CONFIG_REGULATOR_MAX8925) += max8925-regulator.o
+obj-$(CONFIG_REGULATOR_MAX8998) += max8998.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-dcdc.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-isink.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-ldo.o
diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
new file mode 100644
index 0000000..6f44560
--- /dev/null
+++ b/drivers/regulator/max8998.c
@@ -0,0 +1,628 @@
+/*
+ * max8998.c - Voltage regulator driver for the Maxim 8998
+ *
+ *  Copyright (C) 2009-2010 Samsung Electronics
+ *  Kyungmin Park <kyungmin.park@samsung.com>
+ *  Marek Szyprowski <m.szyprowski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/mfd/max8998.h>
+#include <linux/mfd/max8998-private.h>
+
+struct max8998_data {
+	struct device		*dev;
+	struct max8998_dev	*iodev;
+	int			num_regulators;
+	struct regulator_dev	**rdev;
+};
+
+struct voltage_map_desc {
+	int min;
+	int max;
+	int step;
+};
+
+static inline int max8998_read_reg(struct max8998_data *max8998, u8 reg,
+				   u8 *value)
+{
+	return max8998->iodev->dev_read(max8998->iodev, reg, value);
+}
+
+static inline int max8998_write_reg(struct max8998_data *max8998, u8 reg,
+				    u8 value)
+{
+	return max8998->iodev->dev_write(max8998->iodev, reg, value);
+}
+
+static inline int max8998_update_reg(struct max8998_data *max8998, u8 reg,
+				     u8 value, u8 mask)
+{
+	return max8998->iodev->dev_update(max8998->iodev, reg, value, mask);
+}
+
+/* Voltage maps */
+static const struct voltage_map_desc ldo23_voltage_map_desc = {
+	.min = 800,	.step = 50,	.max = 1300,
+};
+static const struct voltage_map_desc ldo456711_voltage_map_desc = {
+	.min = 1600,	.step = 100,	.max = 3600,
+};
+static const struct voltage_map_desc ldo8_voltage_map_desc = {
+	.min = 3000,	.step = 100,	.max = 3600,
+};
+static const struct voltage_map_desc ldo9_voltage_map_desc = {
+	.min = 2800,	.step = 100,	.max = 3100,
+};
+static const struct voltage_map_desc ldo10_voltage_map_desc = {
+	.min = 950,	.step = 50,	.max = 1300,
+};
+static const struct voltage_map_desc ldo1213_voltage_map_desc = {
+	.min = 800,	.step = 100,	.max = 3300,
+};
+static const struct voltage_map_desc ldo1415_voltage_map_desc = {
+	.min = 1200,	.step = 100,	.max = 3300,
+};
+static const struct voltage_map_desc ldo1617_voltage_map_desc = {
+	.min = 1600,	.step = 100,	.max = 3600,
+};
+static const struct voltage_map_desc buck12_voltage_map_desc = {
+	.min = 750,	.step = 25,	.max = 1525,
+};
+static const struct voltage_map_desc buck3_voltage_map_desc = {
+	.min = 1600,	.step = 100,	.max = 3600,
+};
+static const struct voltage_map_desc buck4_voltage_map_desc = {
+	.min = 800,	.step = 100,	.max = 2300,
+};
+
+static const struct voltage_map_desc *ldo_voltage_map[] = {
+	NULL,
+	NULL,
+	&ldo23_voltage_map_desc,	/* LDO2 */
+	&ldo23_voltage_map_desc,	/* LDO3 */
+	&ldo456711_voltage_map_desc,	/* LDO4 */
+	&ldo456711_voltage_map_desc,	/* LDO5 */
+	&ldo456711_voltage_map_desc,	/* LDO6 */
+	&ldo456711_voltage_map_desc,	/* LDO7 */
+	&ldo8_voltage_map_desc,		/* LDO8 */
+	&ldo9_voltage_map_desc,		/* LDO9 */
+	&ldo10_voltage_map_desc,	/* LDO10 */
+	&ldo456711_voltage_map_desc,	/* LDO11 */
+	&ldo1213_voltage_map_desc,	/* LDO12 */
+	&ldo1213_voltage_map_desc,	/* LDO13 */
+	&ldo1415_voltage_map_desc,	/* LDO14 */
+	&ldo1415_voltage_map_desc,	/* LDO15 */
+	&ldo1617_voltage_map_desc,	/* LDO16 */
+	&ldo1617_voltage_map_desc,	/* LDO17 */
+	&buck12_voltage_map_desc,	/* BUCK1 */
+	&buck12_voltage_map_desc,	/* BUCK2 */
+	&buck3_voltage_map_desc,	/* BUCK3 */
+	&buck4_voltage_map_desc,	/* BUCK4 */
+};
+
+static inline int max8998_get_ldo(struct regulator_dev *rdev)
+{
+	return rdev_get_id(rdev);
+}
+
+static int max8998_list_voltage(struct regulator_dev *rdev,
+				unsigned int selector)
+{
+	const struct voltage_map_desc *desc;
+	int ldo = max8998_get_ldo(rdev);
+	int val;
+
+	if (ldo > ARRAY_SIZE(ldo_voltage_map))
+		return -EINVAL;
+
+	desc = ldo_voltage_map[ldo];
+	if (desc == NULL)
+		return -EINVAL;
+
+	val = desc->min + desc->step * selector;
+	if (val > desc->max)
+		return -EINVAL;
+
+	return val * 1000;
+}
+
+static int max8998_get_enable_register(struct regulator_dev *rdev,
+					int *reg, int *shift)
+{
+	int ldo = max8998_get_ldo(rdev);
+
+	switch (ldo) {
+	case MAX8998_LDO2 ... MAX8998_LDO5:
+		*reg = MAX8998_REG_ONOFF1;
+		*shift = 3 - (ldo - MAX8998_LDO2);
+		break;
+	case MAX8998_LDO6 ... MAX8998_LDO13:
+		*reg = MAX8998_REG_ONOFF2;
+		*shift = 7 - (ldo - MAX8998_LDO6);
+		break;
+	case MAX8998_LDO14 ... MAX8998_LDO17:
+		*reg = MAX8998_REG_ONOFF3;
+		*shift = 7 - (ldo - MAX8998_LDO14);
+		break;
+	case MAX8998_BUCK1 ... MAX8998_BUCK4:
+		*reg = MAX8998_REG_ONOFF1;
+		*shift = 7 - (ldo - MAX8998_BUCK1);
+		break;
+	case MAX8998_EN32KHZ_AP ... MAX8998_ENVICHG:
+		*reg = MAX8998_REG_ONOFF4;
+		*shift = 7 - (ldo - MAX8998_EN32KHZ_AP);
+		break;
+	case MAX8998_ESAFEOUT1 ... MAX8998_ESAFEOUT2:
+		*reg = MAX8998_REG_CHGR2;
+		*shift = 7 - (ldo - MAX8998_ESAFEOUT1);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int max8998_ldo_is_enabled(struct regulator_dev *rdev)
+{
+	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	int ret, reg, shift = 8;
+	u8 val;
+
+	ret = max8998_get_enable_register(rdev, &reg, &shift);
+	if (ret)
+		return ret;
+
+	ret = max8998_read_reg(max8998, reg, &val);
+	if (ret)
+		return ret;
+
+	return val & (1 << shift);
+}
+
+static int max8998_ldo_enable(struct regulator_dev *rdev)
+{
+	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	int reg, shift = 8, ret;
+
+	ret = max8998_get_enable_register(rdev, &reg, &shift);
+	if (ret)
+		return ret;
+
+	return max8998_update_reg(max8998, reg, 1<<shift, 1<<shift);
+}
+
+static int max8998_ldo_disable(struct regulator_dev *rdev)
+{
+	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	int reg, shift = 8, ret;
+
+	ret = max8998_get_enable_register(rdev, &reg, &shift);
+	if (ret)
+		return ret;
+
+	return max8998_update_reg(max8998, reg, 0, 1<<shift);
+}
+
+static int max8998_get_voltage_register(struct regulator_dev *rdev,
+				int *_reg, int *_shift, int *_mask)
+{
+	int ldo = max8998_get_ldo(rdev);
+	int reg, shift = 0, mask = 0xff;
+
+	switch (ldo) {
+	case MAX8998_LDO2 ... MAX8998_LDO3:
+		reg = MAX8998_REG_LDO2_LDO3;
+		mask = 0xf;
+		if (ldo == MAX8998_LDO2)
+			shift = 4;
+		else
+			shift = 0;
+		break;
+	case MAX8998_LDO4 ... MAX8998_LDO7:
+		reg = MAX8998_REG_LDO4 + (ldo - MAX8998_LDO4);
+		break;
+	case MAX8998_LDO8 ... MAX8998_LDO9:
+		reg = MAX8998_REG_LDO8_LDO9;
+		mask = 0xf;
+		if (ldo == MAX8998_LDO8)
+			shift = 4;
+		else
+			shift = 0;
+		break;
+	case MAX8998_LDO10 ... MAX8998_LDO11:
+		reg = MAX8998_REG_LDO10_LDO11;
+		if (ldo == MAX8998_LDO10) {
+			shift = 5;
+			mask = 0x7;
+		} else {
+			shift = 0;
+			mask = 0x1f;
+		}
+		break;
+	case MAX8998_LDO12 ... MAX8998_LDO17:
+		reg = MAX8998_REG_LDO12 + (ldo - MAX8998_LDO12);
+		break;
+	case MAX8998_BUCK1:
+		reg = MAX8998_REG_BUCK1_DVSARM1;
+		break;
+	case MAX8998_BUCK2:
+		reg = MAX8998_REG_BUCK2_DVSINT1;
+		break;
+	case MAX8998_BUCK3:
+		reg = MAX8998_REG_BUCK3;
+		break;
+	case MAX8998_BUCK4:
+		reg = MAX8998_REG_BUCK4;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*_reg = reg;
+	*_shift = shift;
+	*_mask = mask;
+
+	return 0;
+}
+
+static int max8998_get_voltage(struct regulator_dev *rdev)
+{
+	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	int reg, shift = 0, mask, ret;
+	u8 val;
+
+	ret = max8998_get_voltage_register(rdev, &reg, &shift, &mask);
+	if (ret)
+		return ret;
+
+	ret = max8998_read_reg(max8998, reg, &val);
+	if (ret)
+		return ret;
+
+	val >>= shift;
+	val &= mask;
+
+	return max8998_list_voltage(rdev, val);
+}
+
+static int max8998_set_voltage(struct regulator_dev *rdev,
+				int min_uV, int max_uV)
+{
+	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
+	const struct voltage_map_desc *desc;
+	int ldo = max8998_get_ldo(rdev);
+	int reg, shift = 0, mask, ret;
+	int i = 0;
+
+	if (ldo > ARRAY_SIZE(ldo_voltage_map))
+		return -EINVAL;
+
+	desc = ldo_voltage_map[ldo];
+	if (desc == NULL)
+		return -EINVAL;
+
+	if (max_vol < desc->min || min_vol > desc->max)
+		return -EINVAL;
+
+	while (desc->min + desc->step*i < max_vol &&
+	       desc->min + desc->step*i < desc->max)
+		i++;
+
+	ret = max8998_get_voltage_register(rdev, &reg, &shift, &mask);
+	if (ret)
+		return ret;
+
+	return max8998_update_reg(max8998, reg, i<<shift, mask<<shift);
+}
+
+static struct regulator_ops max8998_ldo_ops = {
+	.list_voltage		= max8998_list_voltage,
+	.is_enabled		= max8998_ldo_is_enabled,
+	.enable			= max8998_ldo_enable,
+	.disable		= max8998_ldo_disable,
+	.get_voltage		= max8998_get_voltage,
+	.set_voltage		= max8998_set_voltage,
+	.set_suspend_enable	= max8998_ldo_enable,
+	.set_suspend_disable	= max8998_ldo_disable,
+};
+
+static struct regulator_ops max8998_buck_ops = {
+	.list_voltage		= max8998_list_voltage,
+	.is_enabled		= max8998_ldo_is_enabled,
+	.enable			= max8998_ldo_enable,
+	.disable		= max8998_ldo_disable,
+	.get_voltage		= max8998_get_voltage,
+	.set_voltage		= max8998_set_voltage,
+	.set_suspend_enable	= max8998_ldo_enable,
+	.set_suspend_disable	= max8998_ldo_disable,
+};
+
+static struct regulator_ops max8998_others_ops = {
+	.is_enabled		= max8998_ldo_is_enabled,
+	.enable			= max8998_ldo_enable,
+	.disable		= max8998_ldo_disable,
+	.set_suspend_enable	= max8998_ldo_enable,
+	.set_suspend_disable	= max8998_ldo_disable,
+};
+
+static struct regulator_desc regulators[] = {
+	{
+		.name		= "LDO2",
+		.id		= MAX8998_LDO2,
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO3",
+		.id		= MAX8998_LDO3,
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO4",
+		.id		= MAX8998_LDO4,
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO5",
+		.id		= MAX8998_LDO5,
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO6",
+		.id		= MAX8998_LDO6,
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO7",
+		.id		= MAX8998_LDO7,
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO8",
+		.id		= MAX8998_LDO8,
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO9",
+		.id		= MAX8998_LDO9,
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO10",
+		.id		= MAX8998_LDO10,
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO11",
+		.id		= MAX8998_LDO11,
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO12",
+		.id		= MAX8998_LDO12,
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO13",
+		.id		= MAX8998_LDO13,
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO14",
+		.id		= MAX8998_LDO14,
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO15",
+		.id		= MAX8998_LDO15,
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO16",
+		.id		= MAX8998_LDO16,
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO17",
+		.id		= MAX8998_LDO17,
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "BUCK1",
+		.id		= MAX8998_BUCK1,
+		.ops		= &max8998_buck_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "BUCK2",
+		.id		= MAX8998_BUCK2,
+		.ops		= &max8998_buck_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "BUCK3",
+		.id		= MAX8998_BUCK3,
+		.ops		= &max8998_buck_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "BUCK4",
+		.id		= MAX8998_BUCK4,
+		.ops		= &max8998_buck_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "EN32KHz AP",
+		.id		= MAX8998_EN32KHZ_AP,
+		.ops		= &max8998_others_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "EN32KHz CP",
+		.id		= MAX8998_EN32KHZ_CP,
+		.ops		= &max8998_others_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "ENVICHG",
+		.id		= MAX8998_ENVICHG,
+		.ops		= &max8998_others_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "ESAFEOUT1",
+		.id		= MAX8998_ESAFEOUT1,
+		.ops		= &max8998_others_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "ESAFEOUT2",
+		.id		= MAX8998_ESAFEOUT2,
+		.ops		= &max8998_others_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}
+};
+
+static __devinit int max8998_pmic_probe(struct platform_device *pdev)
+{
+	struct max8998_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct max8998_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct regulator_dev **rdev;
+	struct max8998_data *max8998;
+	int i, ret, size;
+
+	if (!pdata) {
+		dev_err(pdev->dev.parent, "No platform init data supplied\n");
+		return -ENODEV;
+	}
+
+	max8998 = kzalloc(sizeof(struct max8998_data), GFP_KERNEL);
+	if (!max8998)
+		return -ENOMEM;
+
+	size = sizeof(struct regulator_dev *) * (pdata->num_regulators + 1);
+	max8998->rdev = kzalloc(size, GFP_KERNEL);
+	if (!max8998->rdev) {
+		kfree(max8998);
+		return -ENOMEM;
+	}
+
+	rdev = max8998->rdev;
+	max8998->iodev = iodev;
+	platform_set_drvdata(pdev, max8998);
+
+	for (i = 0; i < pdata->num_regulators; i++) {
+		const struct voltage_map_desc *desc;
+		int id = pdata->regulators[i].id;
+		int index = id - MAX8998_LDO2;
+
+		desc = ldo_voltage_map[id];
+		if (desc && regulators[index].ops != &max8998_others_ops) {
+			int count = (desc->max - desc->min) / desc->step + 1;
+			regulators[index].n_voltages = count;
+		}
+		rdev[i] = regulator_register(&regulators[index], max8998->dev,
+				pdata->regulators[i].initdata, max8998);
+		if (IS_ERR(rdev[i])) {
+			ret = PTR_ERR(rdev[i]);
+			dev_err(max8998->dev, "regulator init failed\n");
+			rdev[i] = NULL;
+			goto err;
+		}
+	}
+
+
+	return 0;
+err:
+	for (i = 0; i <= max8998->num_regulators; i++)
+		if (rdev[i])
+			regulator_unregister(rdev[i]);
+
+	kfree(max8998->rdev);
+	kfree(max8998);
+
+	return ret;
+}
+
+static int __devexit max8998_pmic_remove(struct platform_device *pdev)
+{
+	struct max8998_data *max8998 = platform_get_drvdata(pdev);
+	struct regulator_dev **rdev = max8998->rdev;
+	int i;
+
+	for (i = 0; i <= max8998->num_regulators; i++)
+		if (rdev[i])
+			regulator_unregister(rdev[i]);
+
+	kfree(max8998->rdev);
+	kfree(max8998);
+
+	return 0;
+}
+
+static struct platform_driver max8998_pmic_driver = {
+	.driver = {
+		.name = "max8998-pmic",
+		.owner = THIS_MODULE,
+	},
+	.probe = max8998_pmic_probe,
+	.remove = __devexit_p(max8998_pmic_remove),
+};
+
+static int __init max8998_pmic_init(void)
+{
+	return platform_driver_register(&max8998_pmic_driver);
+}
+subsys_initcall(max8998_pmic_init);
+
+static void __exit max8998_pmic_cleanup(void)
+{
+	platform_driver_unregister(&max8998_pmic_driver);
+}
+module_exit(max8998_pmic_cleanup);
+
+MODULE_DESCRIPTION("MAXIM 8998 voltage regulator driver");
+MODULE_AUTHOR("Kyungmin Park <kyungmin.park@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/max8998-private.h b/include/linux/mfd/max8998-private.h
new file mode 100644
index 0000000..84a7a13
--- /dev/null
+++ b/include/linux/mfd/max8998-private.h
@@ -0,0 +1,92 @@
+/*
+ * max8998.h - Voltage regulator driver for the Maxim 8998
+ *
+ *  Copyright (C) 2009-2010 Samsung Electrnoics
+ *  Kyungmin Park <kyungmin.park@samsung.com>
+ *  Marek Szyprowski <m.szyprowski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef __LINUX_MFD_MAX8998_PRIV_H
+#define __LINUX_MFD_MAX8998_PRIV_H
+
+/* MAX 8998 registers */
+enum {
+	MAX8998_REG_IRQ1,
+	MAX8998_REG_IRQ2,
+	MAX8998_REG_IRQ3,
+	MAX8998_REG_IRQ4,
+	MAX8998_REG_IRQM1,
+	MAX8998_REG_IRQM2,
+	MAX8998_REG_IRQM3,
+	MAX8998_REG_IRQM4,
+	MAX8998_REG_STATUS1,
+	MAX8998_REG_STATUS2,
+	MAX8998_REG_STATUSM1,
+	MAX8998_REG_STATUSM2,
+	MAX8998_REG_CHGR1,
+	MAX8998_REG_CHGR2,
+	MAX8998_REG_LDO_ACTIVE_DISCHARGE1,
+	MAX8998_REG_LDO_ACTIVE_DISCHARGE2,
+	MAX8998_REG_BUCK_ACTIVE_DISCHARGE3,
+	MAX8998_REG_ONOFF1,
+	MAX8998_REG_ONOFF2,
+	MAX8998_REG_ONOFF3,
+	MAX8998_REG_ONOFF4,
+	MAX8998_REG_BUCK1_DVSARM1,
+	MAX8998_REG_BUCK1_DVSARM2,
+	MAX8998_REG_BUCK1_DVSARM3,
+	MAX8998_REG_BUCK1_DVSARM4,
+	MAX8998_REG_BUCK2_DVSINT1,
+	MAX8998_REG_BUCK2_DVSINT2,
+	MAX8998_REG_BUCK3,
+	MAX8998_REG_BUCK4,
+	MAX8998_REG_LDO2_LDO3,
+	MAX8998_REG_LDO4,
+	MAX8998_REG_LDO5,
+	MAX8998_REG_LDO6,
+	MAX8998_REG_LDO7,
+	MAX8998_REG_LDO8_LDO9,
+	MAX8998_REG_LDO10_LDO11,
+	MAX8998_REG_LDO12,
+	MAX8998_REG_LDO13,
+	MAX8998_REG_LDO14,
+	MAX8998_REG_LDO15,
+	MAX8998_REG_LDO16,
+	MAX8998_REG_LDO17,
+	MAX8998_REG_BKCHR,
+	MAX8998_REG_LBCNFG1,
+	MAX8998_REG_LBCNFG2,
+};
+
+/**
+ * struct max8998_dev - max8998 master device for sub-drivers
+ * @dev: master device of the chip (can be used to access platform data)
+ * @i2c_client: i2c client private data
+ * @dev_read():	chip register read function
+ * @dev_write(): chip register write function
+ * @dev_update(): chip register update function
+ */
+
+struct max8998_dev {
+	struct device *dev;
+	struct i2c_client *i2c_client;
+	int (*dev_read)(struct max8998_dev *max8998, u8 reg, u8 *dest);
+	int (*dev_write)(struct max8998_dev *max8998, u8 reg, u8 val);
+	int (*dev_update)(struct max8998_dev *max8998, u8 reg, u8 val, u8 mask);
+};
+
+#endif /*  __LINUX_MFD_MAX8998_PRIV_H */
diff --git a/include/linux/mfd/max8998.h b/include/linux/mfd/max8998.h
new file mode 100644
index 0000000..1d3601a
--- /dev/null
+++ b/include/linux/mfd/max8998.h
@@ -0,0 +1,78 @@
+/*
+ * max8998.h - Voltage regulator driver for the Maxim 8998
+ *
+ *  Copyright (C) 2009-2010 Samsung Electrnoics
+ *  Kyungmin Park <kyungmin.park@samsung.com>
+ *  Marek Szyprowski <m.szyprowski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef __LINUX_MFD_MAX8998_H
+#define __LINUX_MFD_MAX8998_H
+
+#include <linux/regulator/machine.h>
+
+/* MAX 8998 regulator ids */
+enum {
+	MAX8998_LDO2 = 2,
+	MAX8998_LDO3,
+	MAX8998_LDO4,
+	MAX8998_LDO5,
+	MAX8998_LDO6,
+	MAX8998_LDO7,
+	MAX8998_LDO8,
+	MAX8998_LDO9,
+	MAX8998_LDO10,
+	MAX8998_LDO11,
+	MAX8998_LDO12,
+	MAX8998_LDO13,
+	MAX8998_LDO14,
+	MAX8998_LDO15,
+	MAX8998_LDO16,
+	MAX8998_LDO17,
+	MAX8998_BUCK1,
+	MAX8998_BUCK2,
+	MAX8998_BUCK3,
+	MAX8998_BUCK4,
+	MAX8998_EN32KHZ_AP,
+	MAX8998_EN32KHZ_CP,
+	MAX8998_ENVICHG,
+	MAX8998_ESAFEOUT1,
+	MAX8998_ESAFEOUT2,
+};
+
+/**
+ * max8998_regulator_data - regulator data
+ * @id: regulator id
+ * @initdata: regulator init data (contraints, supplies, ...)
+ */
+struct max8998_regulator_data {
+	int				id;
+	struct regulator_init_data	*initdata;
+};
+
+/**
+ * struct max8998_board - packages regulator init data
+ * @num_regulators: number of regultors used
+ * @regulators: array of defined regulators
+ */
+
+struct max8998_platform_data {
+	int				num_regulators;
+	struct max8998_regulator_data	*regulators;
+};
+
+#endif /*  __LINUX_MFD_MAX8998_H */
-- 
1.7.1.240.g225c

