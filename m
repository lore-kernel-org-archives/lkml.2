Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab2EWHvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 03:51:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60964 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756642Ab2EWHvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 03:51:09 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>
Subject: [PATCH] regulator: add new regulator driver for lp872x
Thread-Topic: [PATCH] regulator: add new regulator driver for lp872x
Thread-Index: Ac04uMpPvW/+MWybQq22BmeDiSvaKA==
Date: Wed, 23 May 2012 07:50:59 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FA17F@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.173.226]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver supports TI/National Semiconductor LP8720 and LP8725 PMU.
LP8720 : 5 LDOs and 1 BUCK
LP8725 : 7 LDOs and 2 BUCKS
These ICs have similar register map for controlling regulators.

Datasheet
---------
LP8720 : http://www.ti.com/litv/pdf/snvs575a
LP8725 : http://www.ti.com/lit/gpn/lp8725

I2C compatible interface
------------------------
The regmap APIs are used for accessing the registers

Supported regulator operations
------------------------------
* list_voltage/set_voltage_sel/get_voltage_sel
  : voltage tables are used for selecting specific voltage
* enable/disable/is_enabled/enable_time
* set_mode/get_mode
  : BUCK specific operations. Forced pwm and normal mode are selective
* set_current_limit/get_current_limit
  : current limit operations for lp8725 BUCKs

Platform data
-------------
3 mandatory and 1 optional data are defined.
* general_config : value of GENERAL_CFG register is platform specific data
* regulator_data : regulator init data with id in platform side
* num_regulators : numbers of regulator_data
* get_dvs_pin_state : used for selecting buck output register
    DVS input is platform specific pin for choosing buck register address

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/Kconfig        |    7 +
 drivers/regulator/Makefile       |    1 +
 drivers/regulator/lp872x.c       |  890 ++++++++++++++++++++++++++++++++++++++
 include/linux/regulator/lp872x.h |   73 +++
 4 files changed, 971 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/lp872x.c
 create mode 100644 include/linux/regulator/lp872x.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 36db5a4..213aff9 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -216,6 +216,13 @@ config REGULATOR_LP3972
 	 Say Y here to support the voltage regulators and convertors
 	 on National Semiconductors LP3972 PMIC
 
+config REGULATOR_LP872X
+	tristate "TI/National Semiconductor LP872x voltage regulators"
+	depends on I2C
+	select REGMAP_I2C
+	help
+	  This driver supports LP8720/LP8725 PMIC
+
 config REGULATOR_PCF50633
 	tristate "NXP PCF50633 regulator driver"
         depends on MFD_PCF50633
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 94b5274..0aa3397 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
 obj-$(CONFIG_REGULATOR_ISL6271A) += isl6271a-regulator.o
 obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
 obj-$(CONFIG_REGULATOR_LP3972) += lp3972.o
+obj-$(CONFIG_REGULATOR_LP872X) += lp872x.o
 obj-$(CONFIG_REGULATOR_MAX1586) += max1586.o
 obj-$(CONFIG_REGULATOR_MAX8649)	+= max8649.o
 obj-$(CONFIG_REGULATOR_MAX8660) += max8660.o
diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
new file mode 100644
index 0000000..6edd345
--- /dev/null
+++ b/drivers/regulator/lp872x.c
@@ -0,0 +1,890 @@
+/*
+ * Copyright 2012 Texas Instruments
+ *
+ * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/regmap.h>
+#include <linux/err.h>
+#include <linux/regulator/lp872x.h>
+#include <linux/regulator/driver.h>
+#include <linux/platform_device.h>
+
+/* Registers */
+#define LP872X_GENERAL_CFG		0x00
+#define LP872X_LDO1			0x01
+#define LP8720_BUCK_V1			0x06
+#define LP8720_BUCK_V2			0x07
+#define LP8720_ENABLE			0x08
+#define LP8720_INT			0x0B
+#define LP8725_LILO1			0x06
+#define LP8725_BUCK1_V1			0x08
+#define LP8725_BUCK1_V2			0x09
+#define LP8725_BUCK2_V1			0x0A
+#define LP8725_BUCK2_V2			0x0B
+#define LP8725_BUCK_CTRL		0x0C
+#define LP8725_LDO_CTRL			0x0D
+
+/* LP8720/LP8725 mask/shift */
+#define LP872X_VOLTAGE_M		0x1F
+#define LP872X_START_DELAY_M		0xE0
+#define LP872X_START_DELAY_S		5
+
+/* LP8720 mask/shift */
+#define LP8720_TIMESTEP_M		0x01	/* Addr 00h */
+#define LP8720_TIMESTEP_S		0
+#define LP8720_EXT_DVS_M		0x04
+#define LP8720_BUCK_FPWM_M		0x20	/* Addr 07h */
+#define LP8720_BUCK_FPWM_S		5
+#define LP8720_DVS_SEL_M		0x80
+#define LP8720_TSD_INT_M		0x02	/* Addr 0Bh */
+#define LP8720_TSD_EW_M			0x01
+
+/* LP8725 mask/shift */
+#define LP8725_TIMESTEP_M		0xC0	/* Addr 00h */
+#define LP8725_TIMESTEP_S		6
+#define LP8725_BUCK1_EN_M		0x01
+#define LP8725_BUCK2_EN_M		0x10
+#define LP8725_DVS1_M			0x04
+#define LP8725_DVS2_M			0x08
+#define LP8725_BUCK_CL_M		0xC0	/* Addr 09h,0Bh */
+#define LP8725_BUCK_CL_S		6
+#define LP8725_BUCK1_FPWM_M		0x02	/* Addr 0Ch */
+#define LP8725_BUCK1_FPWM_S		1
+#define LP8725_BUCK2_FPWM_M		0x20
+#define LP8725_BUCK2_FPWM_S		5
+
+/* PWM mode */
+#define LP872X_FORCE_PWM		1
+#define LP872X_AUTO_PWM			0
+
+#define ENABLE				1
+#define DISABLE				0
+#define MAX_DELAY			6
+#define LP8720_NUM_REGULATORS		6
+#define LP8725_NUM_REGULATORS		9
+
+enum lp872x_id {
+	LP8720,
+	LP8725,
+};
+
+struct lp872x {
+	struct regmap *regmap;
+	struct mutex xfer_lock;
+	struct device *dev;
+	enum lp872x_id chipid;
+	struct lp872x_platform_data *pdata;
+	struct regulator_dev **regulators;
+};
+
+/* LP8720/LP8725 shared voltage table for LDOs */
+static const int lp872x_ldo_vtbl[] = {
+	1200, 1250, 1300, 1350, 1400, 1450, 1500, 1550,	1600, 1650, 1700, 1750,
+	1800, 1850, 1900, 2000, 2100, 2200, 2300, 2400, 2500, 2600, 2650, 2700,
+	2750, 2800, 2850, 2900, 2950, 3000, 3100, 3300,
+};
+
+/* LP8720 LDO4 voltage table */
+static const int lp8720_ldo4_vtbl[] = {
+	 800,  850,  900, 1000, 1100, 1200, 1250, 1300,	1350, 1400, 1450, 1500,
+	1550, 1600, 1650, 1700, 1750, 1800, 1850, 1900, 2000, 2100, 2200, 2300,
+	2400, 2500, 2600, 2650, 2700, 2750, 2800, 2850,
+};
+
+/* LP8725 LILO(Low Input Low Output) voltage table */
+static const int lp8725_lilo_vtbl[] = {
+	 800,  850,  900,  950, 1000, 1050, 1100, 1150,	1200, 1250, 1300, 1350,
+	1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300, 2400, 2500,
+	2600, 2700, 2800, 2850, 2900, 3000, 3100, 3300,
+};
+
+/* LP8720 BUCK voltage table */
+#define EXT_R		0	/* external resistor divider */
+static const int lp8720_buck_vtbl[] = {
+	EXT_R, 800,  850,  900,  950, 1000, 1050, 1100,	1150, 1200, 1250, 1300,
+	1350, 1400, 1450, 1500, 1550, 1600, 1650, 1700, 1750, 1800, 1850, 1900,
+	1950, 2000, 2050, 2100, 2150, 2200, 2250, 2300,
+};
+
+/* LP8725 BUCK voltage table */
+static const int lp8725_buck_vtbl[] = {
+	 800,  850,  900,  950, 1000, 1050, 1100, 1150,	1200, 1250, 1300, 1350,
+	1400, 1500, 1600, 1700, 1750, 1800, 1850, 1900, 2000, 2100, 2200, 2300,
+	2400, 2500, 2600, 2700, 2800, 2850, 2900, 3000,
+};
+
+/* LP8725 BUCK current limit */
+static const int lp8725_buck_uA[] = { 460000, 780000, 1050000, 1370000 };
+
+static const int lp872x_max_regulators[] = {
+	[LP8720] = LP8720_NUM_REGULATORS,
+	[LP8725] = LP8725_NUM_REGULATORS,
+};
+
+static int lp872x_read_byte(struct lp872x *lp, u8 addr, u8 *data)
+{
+	int ret;
+	unsigned int val;
+
+	mutex_lock(&lp->xfer_lock);
+	ret = regmap_read(lp->regmap, addr, &val);
+	if (ret < 0) {
+		mutex_unlock(&lp->xfer_lock);
+		dev_err(lp->dev, "failed to read 0x%.2x\n", addr);
+		return ret;
+	}
+	mutex_unlock(&lp->xfer_lock);
+
+	*data = (u8)val;
+	return 0;
+}
+
+static int lp872x_write_byte(struct lp872x *lp, u8 addr, u8 data)
+{
+	int ret;
+
+	mutex_lock(&lp->xfer_lock);
+	ret = regmap_write(lp->regmap, addr, data);
+	mutex_unlock(&lp->xfer_lock);
+
+	return ret;
+}
+
+static inline int lp872x_update_bits(struct lp872x *lp, u8 addr,
+				unsigned int mask, u8 data)
+{
+	return regmap_update_bits(lp->regmap, addr, mask, data);
+}
+
+static inline int _mv_to_uv(int mV)
+{
+	return mV * 1000;
+}
+
+static int _rdev_to_offset(struct regulator_dev *rdev)
+{
+	enum lp872x_regulator_id id = rdev_get_id(rdev);
+
+	switch (id) {
+	case LP8720_ID_LDO1 ... LP8720_ID_BUCK:
+		return id;
+	case LP8725_ID_LDO1 ... LP8725_ID_BUCK2:
+		return id - LP8725_ID_BASE;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int lp872x_ldo_list_voltage(struct regulator_dev *rdev,
+				unsigned selector)
+{
+	enum lp872x_regulator_id ldo = rdev_get_id(rdev);
+	int mv;
+
+	switch (ldo) {
+	case LP8720_ID_LDO1 ... LP8720_ID_LDO3:
+	case LP8720_ID_LDO5:
+	case LP8725_ID_LDO1 ... LP8725_ID_LDO5:
+		mv = lp872x_ldo_vtbl[selector];
+		break;
+	case LP8720_ID_LDO4:
+		mv = lp8720_ldo4_vtbl[selector];
+		break;
+	case LP8725_ID_LILO1 ... LP8725_ID_LILO2:
+		mv = lp8725_lilo_vtbl[selector];
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return _mv_to_uv(mv);
+}
+
+static int lp872x_ldo_set_voltage_sel(struct regulator_dev *rdev,
+				unsigned selector)
+{
+	struct lp872x *lp = rdev_get_drvdata(rdev);
+	int offset = _rdev_to_offset(rdev);
+	u8 addr, mask;
+
+	if (offset < 0)
+		return -EINVAL;
+
+	addr = LP872X_LDO1 + offset;
+	mask = LP872X_VOLTAGE_M;
+
+	return lp872x_update_bits(lp, addr, mask, selector);
+}
+
+static int lp872x_ldo_get_voltage_sel(struct regulator_dev *rdev)
+{
+	struct lp872x *lp = rdev_get_drvdata(rdev);
+	int ret, offset = _rdev_to_offset(rdev);
+	u8 val;
+
+	if (offset < 0)
+		return -EINVAL;
+
+	ret = lp872x_read_byte(lp, LP872X_LDO1 + offset, &val);
+	if (ret)
+		return ret;
+
+	return val & LP872X_VOLTAGE_M;
+}
+
+static int lp872x_ldo_ctrl(struct lp872x *lp, int offset, int is_enable)
+{
+	enum lp872x_id chip = lp->chipid;
+	u8 addr, val, mask;
+
+	if (offset < 0)
+		return -EINVAL;
+
+	if (chip == LP8720)
+		addr = LP8720_ENABLE;
+	else if (chip == LP8725)
+		addr = LP8725_LDO_CTRL;
+	else
+		return -EINVAL;
+
+	mask = ENABLE << offset;
+	val = is_enable << offset;
+
+	return lp872x_update_bits(lp, addr, mask, val);
+}
+
+static int lp872x_regulator_enable(struct regulator_dev *rdev)
+{
+	struct lp872x *lp = rdev_get_drvdata(rdev);
+	int offset = _rdev_to_offset(rdev);
+
+	return lp872x_ldo_ctrl(lp, offset, ENABLE);
+}
+
+static int lp872x_regualtor_disable(struct regulator_dev *rdev)
+{
+	struct lp872x *lp = rdev_get_drvdata(rdev);
+	int offset = _rdev_to_offset(rdev);
+
+	return lp872x_ldo_ctrl(lp, offset, DISABLE);
+}
+
+static int lp872x_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	struct lp872x *lp = rdev_get_drvdata(rdev);
+	enum lp872x_id chip = lp->chipid;
+	int ret, offset = _rdev_to_offset(rdev);
+	u8 addr, val;
+
+	if (offset < 0)
+		return -EINVAL;
+
+	if (chip == LP8720)
+		addr = LP8720_ENABLE;
+	else if (chip == LP8725)
+		addr = LP8725_LDO_CTRL;
+	else
+		return -EINVAL;
+
+	ret = lp872x_read_byte(lp, addr, &val);
+	if (ret)
+		return ret;
+
+	return (val >> offset) & ENABLE;
+}
+
+static int lp872x_get_timestep_usec(struct lp872x *lp)
+{
+	enum lp872x_id chip = lp->chipid;
+	u8 val, mask, shift;
+	int *time_usec, size, ret;
+	int lp8720_time_usec[] = { 25, 50 };
+	int lp8725_time_usec[] = { 32, 64, 128, 256 };
+
+	if (chip == LP8720) {
+		mask = LP8720_TIMESTEP_M;
+		shift = LP8720_TIMESTEP_S;
+		time_usec = &lp8720_time_usec[0];
+		size = ARRAY_SIZE(lp8720_time_usec);
+	} else if (chip == LP8725) {
+		mask = LP8725_TIMESTEP_M;
+		shift = LP8725_TIMESTEP_S;
+		time_usec = &lp8725_time_usec[0];
+		size = ARRAY_SIZE(lp8725_time_usec);
+	} else {
+		return -EINVAL;
+	}
+
+	ret = lp872x_read_byte(lp, LP872X_GENERAL_CFG, &val);
+	if (ret)
+		return -EINVAL;
+
+	val = (val & mask) >> shift;
+	if (val >= size)
+		return -EINVAL;
+
+	return *(time_usec + val);
+}
+
+static int lp872x_regulator_enable_time(struct regulator_dev *rdev)
+{
+	struct lp872x *lp = rdev_get_drvdata(rdev);
+	enum lp872x_regulator_id regulator = rdev_get_id(rdev);
+	int time_step_us = lp872x_get_timestep_usec(lp);
+	int ret, offset;
+	u8 addr, val;
+
+	if (time_step_us < 0)
+		return -EINVAL;
+
+	switch (regulator) {
+	case LP8720_ID_LDO1 ... LP8720_ID_LDO5:
+	case LP8725_ID_LDO1 ... LP8725_ID_LILO2:
+		offset = _rdev_to_offset(rdev);
+		if (offset < 0)
+			return -EINVAL;
+
+		addr = LP872X_LDO1 + offset;
+		break;
+	case LP8720_ID_BUCK:
+		addr = LP8720_BUCK_V1;
+		break;
+	case LP8725_ID_BUCK1:
+		addr = LP8725_BUCK1_V1;
+		break;
+	case LP8725_ID_BUCK2:
+		addr = LP8725_BUCK2_V1;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = lp872x_read_byte(lp, addr, &val);
+	if (ret)
+		return ret;
+
+	val = (val & LP872X_START_DELAY_M) >> LP872X_START_DELAY_S;
+
+	return val > MAX_DELAY ? 0 : val * time_step_us;
+}
+
+static struct regulator_ops lp872x_ldo_ops = {
+	.list_voltage = lp872x_ldo_list_voltage,
+	.set_voltage_sel = lp872x_ldo_set_voltage_sel,
+	.get_voltage_sel = lp872x_ldo_get_voltage_sel,
+	.enable = lp872x_regulator_enable,
+	.disable = lp872x_regualtor_disable,
+	.is_enabled = lp872x_regulator_is_enabled,
+	.enable_time = lp872x_regulator_enable_time,
+};
+
+static int lp872x_buck_list_voltage(struct regulator_dev *rdev,
+				unsigned selector)
+{
+	enum lp872x_regulator_id buck = rdev_get_id(rdev);
+	int mv;
+
+	switch (buck) {
+	case LP8720_ID_BUCK:
+		mv = lp8720_buck_vtbl[selector];
+		break;
+	case LP8725_ID_BUCK1:
+	case LP8725_ID_BUCK2:
+		mv = lp8725_buck_vtbl[selector];
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return _mv_to_uv(mv);
+}
+
+static u8 lp872x_select_buck_vout_addr(struct lp872x *lp,
+				enum lp872x_regulator_id buck)
+{
+	struct lp872x_platform_data *pdata = lp->pdata;
+	u8 val, addr;
+	enum lp872x_dvs_state pinstate;
+
+	if (lp872x_read_byte(lp, LP872X_GENERAL_CFG, &val))
+		return 0;
+
+	switch (buck) {
+	case LP8720_ID_BUCK:
+		if (val & LP8720_EXT_DVS_M) {
+			pinstate = pdata->get_dvs_pin_state ?
+				pdata->get_dvs_pin_state() : DVS_LOW;
+
+			addr = (pinstate == DVS_HIGH) ?
+				LP8720_BUCK_V1 : LP8720_BUCK_V2;
+		} else {
+			if (lp872x_read_byte(lp, LP8720_ENABLE, &val))
+				return 0;
+
+			addr = val & LP8720_DVS_SEL_M ?
+				LP8720_BUCK_V1 : LP8720_BUCK_V2;
+		}
+		break;
+	case LP8725_ID_BUCK1:
+		if (val & LP8725_DVS1_M) {
+			addr = LP8725_BUCK1_V1;
+		} else {
+			pinstate = pdata->get_dvs_pin_state ?
+				pdata->get_dvs_pin_state() : DVS_LOW;
+
+			addr = (pinstate == DVS_HIGH) ?
+				LP8725_BUCK1_V1 : LP8725_BUCK1_V2;
+		}
+		break;
+	case LP8725_ID_BUCK2:
+		addr =  val & LP8725_DVS2_M ?
+			LP8725_BUCK2_V1 : LP8725_BUCK2_V2;
+		break;
+	default:
+		return 0;
+	}
+
+	return addr;
+}
+
+static bool lp872x_is_valid_buck_addr(u8 addr)
+{
+	switch (addr) {
+	case LP8720_BUCK_V1:
+	case LP8720_BUCK_V2:
+	case LP8725_BUCK1_V1:
+	case LP8725_BUCK1_V2:
+	case LP8725_BUCK2_V1:
+	case LP8725_BUCK2_V2:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static int lp872x_buck_set_voltage_sel(struct regulator_dev *rdev,
+					unsigned selector)
+{
+	struct lp872x *lp = rdev_get_drvdata(rdev);
+	enum lp872x_regulator_id buck = rdev_get_id(rdev);
+	u8 addr, mask = LP872X_VOLTAGE_M;
+
+	addr = lp872x_select_buck_vout_addr(lp, buck);
+	if (!lp872x_is_valid_buck_addr(addr))
+		return -EINVAL;
+
+	return lp872x_update_bits(lp, addr, mask, selector);
+}
+
+static int lp872x_buck_get_voltage_sel(struct regulator_dev *rdev)
+{
+	struct lp872x *lp = rdev_get_drvdata(rdev);
+	enum lp872x_regulator_id buck = rdev_get_id(rdev);
+	u8 addr, val;
+	int ret;
+
+	addr = lp872x_select_buck_vout_addr(lp, buck);
+	if (!lp872x_is_valid_buck_addr(addr))
+		return -EINVAL;
+
+	ret = lp872x_read_byte(lp, addr, &val);
+	if (ret)
+		return ret;
+
+	return val & LP872X_VOLTAGE_M;
+}
+
+static int lp8725_buck_set_current_limit(struct regulator_dev *rdev,
+					 int min_uA, int max_uA)
+{
+	struct lp872x *lp = rdev_get_drvdata(rdev);
+	enum lp872x_regulator_id buck = rdev_get_id(rdev);
+	int i, max = ARRAY_SIZE(lp8725_buck_uA);
+	u8 addr, val;
+
+	if (buck == LP8725_ID_BUCK1)
+		addr = LP8725_BUCK1_V2;
+	else if (buck == LP8725_ID_BUCK2)
+		addr = LP8725_BUCK2_V2;
+	else
+		return -EINVAL;
+
+	for (i = 0 ; i < max ; i++)
+		if (lp8725_buck_uA[i] >= min_uA &&
+			lp8725_buck_uA[i] <= max_uA)
+			break;
+
+	if (i == max)
+		return -EINVAL;
+
+	val = i << LP8725_BUCK_CL_S;
+
+	return lp872x_update_bits(lp, addr, LP8725_BUCK_CL_M, val);
+}
+
+static int lp8725_buck_get_current_limit(struct regulator_dev *rdev)
+{
+	struct lp872x *lp = rdev_get_drvdata(rdev);
+	enum lp872x_regulator_id buck = rdev_get_id(rdev);
+	u8 addr, val;
+	int ret;
+
+	if (buck == LP8725_ID_BUCK1)
+		addr = LP8725_BUCK1_V2;
+	else if (buck == LP8725_ID_BUCK2)
+		addr = LP8725_BUCK2_V2;
+	else
+		return -EINVAL;
+
+	ret = lp872x_read_byte(lp, addr, &val);
+	if (ret)
+		return ret;
+
+	val = (val & LP8725_BUCK_CL_M) >> LP8725_BUCK_CL_S;
+
+	return (val < ARRAY_SIZE(lp8725_buck_uA)) ?
+			lp8725_buck_uA[val] : -EINVAL;
+}
+
+static int lp8725_buck_ctrl(struct lp872x *lp,
+			enum lp872x_regulator_id buck,
+			int is_enable)
+{
+	u8 mask, val;
+	int ret;
+
+	if (buck == LP8725_ID_BUCK1)
+		mask = LP8725_BUCK1_EN_M;
+	else if (buck == LP8725_ID_BUCK2)
+		mask = LP8725_BUCK2_EN_M;
+	else
+		return -EINVAL;
+
+	ret = lp872x_read_byte(lp, LP872X_GENERAL_CFG, &val);
+	if (ret)
+		return ret;
+
+	val = is_enable ? (val | mask) : (val & ~mask);
+
+	return lp872x_write_byte(lp, LP872X_GENERAL_CFG, val);
+}
+
+static int lp8725_buck_enable(struct regulator_dev *rdev)
+{
+	struct lp872x *lp = rdev_get_drvdata(rdev);
+	enum lp872x_regulator_id buck = rdev_get_id(rdev);
+
+	return lp8725_buck_ctrl(lp, buck, ENABLE);
+}
+
+static int lp8725_buck_disable(struct regulator_dev *rdev)
+{
+	struct lp872x *lp = rdev_get_drvdata(rdev);
+	enum lp872x_regulator_id buck = rdev_get_id(rdev);
+
+	return lp8725_buck_ctrl(lp, buck, DISABLE);
+}
+
+static int lp8725_buck_is_enabled(struct regulator_dev *rdev)
+{
+	struct lp872x *lp = rdev_get_drvdata(rdev);
+	enum lp872x_regulator_id buck = rdev_get_id(rdev);
+	u8 val, mask;
+	int ret;
+
+	if (buck == LP8725_ID_BUCK1)
+		mask = LP8725_BUCK1_EN_M;
+	else if (buck == LP8725_ID_BUCK2)
+		mask = LP8725_BUCK2_EN_M;
+	else
+		return -EINVAL;
+
+	ret = lp872x_read_byte(lp, LP872X_GENERAL_CFG, &val);
+	if (ret)
+		return ret;
+
+	return val & mask;
+}
+
+static int lp872x_buck_set_mode(struct regulator_dev *rdev, unsigned int mode)
+{
+	struct lp872x *lp = rdev_get_drvdata(rdev);
+	enum lp872x_regulator_id buck = rdev_get_id(rdev);
+	u8 addr, mask, shift, val;
+
+	switch (buck) {
+	case LP8720_ID_BUCK:
+		addr = LP8720_BUCK_V2;
+		mask = LP8720_BUCK_FPWM_M;
+		shift = LP8720_BUCK_FPWM_S;
+		break;
+	case LP8725_ID_BUCK1:
+		addr = LP8725_BUCK_CTRL;
+		mask = LP8725_BUCK1_FPWM_M;
+		shift = LP8725_BUCK1_FPWM_S;
+		break;
+	case LP8725_ID_BUCK2:
+		addr = LP8725_BUCK_CTRL;
+		mask = LP8725_BUCK2_FPWM_M;
+		shift = LP8725_BUCK2_FPWM_S;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (mode == REGULATOR_MODE_FAST)
+		val = LP872X_FORCE_PWM << shift;
+	else if (mode == REGULATOR_MODE_NORMAL)
+		val = LP872X_AUTO_PWM << shift;
+	else
+		return -EINVAL;
+
+	return lp872x_update_bits(lp, addr, mask, val);
+}
+
+static unsigned int lp872x_buck_get_mode(struct regulator_dev *rdev)
+{
+	struct lp872x *lp = rdev_get_drvdata(rdev);
+	enum lp872x_regulator_id buck = rdev_get_id(rdev);
+	u8 addr, mask, val;
+	int ret;
+
+	switch (buck) {
+	case LP8720_ID_BUCK:
+		addr = LP8720_BUCK_V2;
+		mask = LP8720_BUCK_FPWM_M;
+		break;
+	case LP8725_ID_BUCK1:
+		addr = LP8725_BUCK_CTRL;
+		mask = LP8725_BUCK1_FPWM_M;
+		break;
+	case LP8725_ID_BUCK2:
+		addr = LP8725_BUCK_CTRL;
+		mask = LP8725_BUCK2_FPWM_M;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = lp872x_read_byte(lp, addr, &val);
+	if (ret)
+		return ret;
+
+	return val & mask ? REGULATOR_MODE_FAST : REGULATOR_MODE_NORMAL;
+}
+
+static struct regulator_ops lp8720_buck_ops = {
+	.list_voltage = lp872x_buck_list_voltage,
+	.set_voltage_sel = lp872x_buck_set_voltage_sel,
+	.get_voltage_sel = lp872x_buck_get_voltage_sel,
+	.set_mode = lp872x_buck_set_mode,
+	.get_mode = lp872x_buck_get_mode,
+	.enable_time = lp872x_regulator_enable_time,
+	.enable = lp872x_regulator_enable,
+	.disable = lp872x_regualtor_disable,
+	.is_enabled = lp872x_regulator_is_enabled,
+};
+
+static struct regulator_ops lp8725_buck_ops = {
+	.list_voltage = lp872x_buck_list_voltage,
+	.set_voltage_sel = lp872x_buck_set_voltage_sel,
+	.get_voltage_sel = lp872x_buck_get_voltage_sel,
+	.set_mode = lp872x_buck_set_mode,
+	.get_mode = lp872x_buck_get_mode,
+	.enable_time = lp872x_regulator_enable_time,
+	.enable = lp8725_buck_enable,
+	.disable = lp8725_buck_disable,
+	.is_enabled = lp8725_buck_is_enabled,
+	.set_current_limit = lp8725_buck_set_current_limit,
+	.get_current_limit = lp8725_buck_get_current_limit,
+};
+
+#define REG_DESC(_name, _id, _ops, _table)	\
+{							\
+	.name = _name,					\
+	.id = _id,					\
+	.ops = _ops,					\
+	.type = REGULATOR_VOLTAGE,			\
+	.owner = THIS_MODULE,				\
+	.n_voltages = ARRAY_SIZE(_table),		\
+}
+
+static struct regulator_desc lp872x_regulator_desc[LP872X_ID_MAX] = {
+	/* lp8720 regulator description */
+	REG_DESC("ldo1", LP8720_ID_LDO1, &lp872x_ldo_ops, lp872x_ldo_vtbl),
+	REG_DESC("ldo2", LP8720_ID_LDO2, &lp872x_ldo_ops, lp872x_ldo_vtbl),
+	REG_DESC("ldo3", LP8720_ID_LDO3, &lp872x_ldo_ops, lp872x_ldo_vtbl),
+	REG_DESC("ldo4", LP8720_ID_LDO4, &lp872x_ldo_ops, lp8720_ldo4_vtbl),
+	REG_DESC("ldo5", LP8720_ID_LDO5, &lp872x_ldo_ops, lp872x_ldo_vtbl),
+	REG_DESC("buck", LP8720_ID_BUCK, &lp8720_buck_ops, lp8720_buck_vtbl),
+
+	/* lp8725 regulator description */
+	REG_DESC("ldo1", LP8725_ID_LDO1, &lp872x_ldo_ops, lp872x_ldo_vtbl),
+	REG_DESC("ldo2", LP8725_ID_LDO2, &lp872x_ldo_ops, lp872x_ldo_vtbl),
+	REG_DESC("ldo3", LP8725_ID_LDO3, &lp872x_ldo_ops, lp872x_ldo_vtbl),
+	REG_DESC("ldo4", LP8725_ID_LDO4, &lp872x_ldo_ops, lp872x_ldo_vtbl),
+	REG_DESC("ldo5", LP8725_ID_LDO5, &lp872x_ldo_ops, lp872x_ldo_vtbl),
+	REG_DESC("lilo1", LP8725_ID_LILO1, &lp872x_ldo_ops, lp8725_lilo_vtbl),
+	REG_DESC("lilo2", LP8725_ID_LILO2, &lp872x_ldo_ops, lp8725_lilo_vtbl),
+	REG_DESC("buck1", LP8725_ID_BUCK1, &lp8725_buck_ops, lp8725_buck_vtbl),
+	REG_DESC("buck2", LP8725_ID_BUCK2, &lp8725_buck_ops, lp8725_buck_vtbl),
+};
+
+static int lp872x_config(struct lp872x *lp)
+{
+	int ret;
+	u8 val = lp->pdata->general_config;
+
+	ret = lp872x_write_byte(lp, LP872X_GENERAL_CFG, val);
+	if (ret)
+		dev_err(lp->dev, "i2c communication err: %d", ret);
+
+	return ret;
+}
+
+static int lp872x_regulator_register(struct lp872x *lp)
+{
+	struct lp872x_regulator_data *regulator_data;
+	struct regulator_init_data *init_data;
+	struct regulator_desc *desc;
+	struct regulator_dev *rdev;
+	int num = lp->pdata->num_regulators;
+	int max = lp872x_max_regulators[lp->chipid];
+	int i, ret;
+
+	if (num > max || num <= 0) {
+		dev_err(lp->dev, "invalid numbers of regulators  = %d/%d",
+				num, max);
+		return -EINVAL;
+	}
+
+	for (i = 0 ; i < num ; i++) {
+		regulator_data = lp->pdata->regulator_data + i;
+		desc = &lp872x_regulator_desc[regulator_data->id];
+		init_data = regulator_data->init_data;
+
+		rdev = regulator_register(desc, lp->dev, init_data, lp, NULL);
+		if (IS_ERR(rdev)) {
+			dev_err(lp->dev, "regulator register err");
+			ret =  PTR_ERR(rdev);
+			goto err;
+		}
+
+		*(lp->regulators + i) = rdev;
+	}
+
+	return 0;
+
+err:
+	while (--i >= 0) {
+		rdev = *(lp->regulators + i);
+		regulator_unregister(rdev);
+	}
+	return ret;
+}
+
+static void lp872x_regulator_unregister(struct lp872x *lp)
+{
+	struct lp872x_platform_data *pdata = lp->pdata;
+	struct regulator_dev *rdev;
+	int i;
+
+	for (i = 0 ; i < pdata->num_regulators ; i++) {
+		rdev = *(lp->regulators + i);
+		regulator_unregister(rdev);
+	}
+}
+
+static const struct regmap_config lp872x_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static int lp872x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
+{
+	struct lp872x *lp;
+	struct lp872x_platform_data *pdata = cl->dev.platform_data;
+	int num_regulators = pdata->num_regulators;
+	int ret, size;
+
+	lp = devm_kzalloc(&cl->dev, sizeof(struct lp872x), GFP_KERNEL);
+	if (!lp)
+		goto err_mem;
+
+	size = sizeof(struct regulator_dev *) * num_regulators;
+	lp->regulators = devm_kzalloc(&cl->dev, size, GFP_KERNEL);
+	if (!lp->regulators)
+		goto err_mem;
+
+	lp->regmap = regmap_init_i2c(cl, &lp872x_regmap_config);
+	if (IS_ERR(lp->regmap)) {
+		ret = PTR_ERR(lp->regmap);
+		dev_err(&cl->dev, "regmap init i2c err: %d\n", ret);
+		goto err_regmap;
+	}
+
+	lp->dev = &cl->dev;
+	lp->pdata = pdata;
+	lp->chipid = id->driver_data;
+	i2c_set_clientdata(cl, lp);
+
+	mutex_init(&lp->xfer_lock);
+
+	ret = lp872x_config(lp);
+	if (ret)
+		goto err_dev;
+
+	ret = lp872x_regulator_register(lp);
+	if (ret)
+		goto err_dev;
+
+	return 0;
+
+err_mem:
+	return -ENOMEM;
+err_dev:
+	regmap_exit(lp->regmap);
+err_regmap:
+	return ret;
+}
+
+static int __devexit lp872x_remove(struct i2c_client *cl)
+{
+	struct lp872x *lp = i2c_get_clientdata(cl);
+
+	lp872x_regulator_unregister(lp);
+	regmap_exit(lp->regmap);
+	return 0;
+}
+
+static const struct i2c_device_id lp872x_ids[] = {
+	{"lp8720", LP8720},
+	{"lp8725", LP8725},
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, lp872x_ids);
+
+static struct i2c_driver lp872x_driver = {
+	.driver = {
+		.name = "lp872x",
+		.owner = THIS_MODULE,
+	},
+	.probe = lp872x_probe,
+	.remove = __devexit_p(lp872x_remove),
+	.id_table = lp872x_ids,
+};
+
+module_i2c_driver(lp872x_driver);
+
+MODULE_DESCRIPTION("TI/National Semiconductor LP872x PMU Regulator Driver");
+MODULE_AUTHOR("Milo Kim");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/regulator/lp872x.h b/include/linux/regulator/lp872x.h
new file mode 100644
index 0000000..c7fe3ff
--- /dev/null
+++ b/include/linux/regulator/lp872x.h
@@ -0,0 +1,73 @@
+/*
+ * Copyright 2012 Texas Instruments
+ *
+ * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __LP872X_REGULATOR_H__
+#define __LP872X_REGULATOR_H__
+
+#include <linux/regulator/machine.h>
+#include <linux/platform_device.h>
+
+enum lp872x_regulator_id {
+	LP8720_ID_LDO1,
+	LP8720_ID_LDO2,
+	LP8720_ID_LDO3,
+	LP8720_ID_LDO4,
+	LP8720_ID_LDO5,
+	LP8720_ID_BUCK,
+
+	LP8725_ID_BASE,
+	LP8725_ID_LDO1 = LP8725_ID_BASE,
+	LP8725_ID_LDO2,
+	LP8725_ID_LDO3,
+	LP8725_ID_LDO4,
+	LP8725_ID_LDO5,
+	LP8725_ID_LILO1,
+	LP8725_ID_LILO2,
+	LP8725_ID_BUCK1,
+	LP8725_ID_BUCK2,
+
+	LP872X_ID_MAX,
+};
+
+enum lp872x_dvs_state {
+	DVS_LOW,
+	DVS_HIGH,
+};
+
+/**
+ * lp872x_regulator_data
+ * @id        : regulator id
+ * @init_data : init data for each regulator
+ */
+struct lp872x_regulator_data {
+	enum lp872x_regulator_id id;
+	struct regulator_init_data *init_data;
+};
+
+/**
+ * lp872x_platform_data
+ * @general_config    (mandatory) : the value of LP872X_GENERAL_CFG register
+ * @regulator_data    (mandatory) : platform regulator id and init data
+ * @num_regulators    (mandatory) : total number of platform regulators
+ * @get_dvs_pin_state  (optional) : DVS input pin state
+ *				    (used for selecting buck address)
+ *	LP8720 : should be defined if LP8720_EXT_DVS_M bit is 1
+ *	LP8725 : should be defined if LP8725_DVS1_M bit is 0
+ *	LP8720_EXT_DVS_M and LP8725_DVS1_M are in LP872X_GENERAL_CFG register
+ */
+struct lp872x_platform_data {
+	u8 general_config;
+	struct lp872x_regulator_data *regulator_data;
+	int num_regulators;
+	enum lp872x_dvs_state (*get_dvs_pin_state)(void);
+};
+
+#endif
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments
