Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab2GROdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 10:33:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38742 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab2GROdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 10:33:38 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>
Subject: [PATCH 2/6] regulator: add new lp8788 regulator driver
Thread-Topic: [PATCH 2/6] regulator: add new lp8788 regulator driver
Thread-Index: Ac1k8jgzZG10fAvrTx6ux6l4Ah0IBw==
Date: Wed, 18 Jul 2012 14:32:57 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FD7A3@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.177.86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI LP8788 PMU has 4 BUCKS and 22 LDOs.
The voltage of BUCK1 and BUCK2 can be controlled by external gpios.
And some LDOs also can be enabled by external gpios.
The regmap interface is used for regulator operations.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/Kconfig       |    6 +
 drivers/regulator/Makefile      |    2 +
 drivers/regulator/lp8788-buck.c |  629 +++++++++++++++++++++++++++++
 drivers/regulator/lp8788-ldo.c  |  842 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 1479 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/lp8788-buck.c
 create mode 100644 drivers/regulator/lp8788-ldo.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 1013501..4e932cc 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -239,6 +239,12 @@ config REGULATOR_LP872X
 	help
 	  This driver supports LP8720/LP8725 PMIC
 
+config REGULATOR_LP8788
+	bool "TI LP8788 Power Regulators"
+	depends on MFD_LP8788
+	help
+	  This driver supports LP8788 voltage regulator chip.
+
 config REGULATOR_PCF50633
 	tristate "NXP PCF50633 regulator driver"
         depends on MFD_PCF50633
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index a70c4f4..3342615 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -25,6 +25,8 @@ obj-$(CONFIG_REGULATOR_ISL6271A) += isl6271a-regulator.o
 obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
 obj-$(CONFIG_REGULATOR_LP3972) += lp3972.o
 obj-$(CONFIG_REGULATOR_LP872X) += lp872x.o
+obj-$(CONFIG_REGULATOR_LP8788) += lp8788-buck.o
+obj-$(CONFIG_REGULATOR_LP8788) += lp8788-ldo.o
 obj-$(CONFIG_REGULATOR_MAX1586) += max1586.o
 obj-$(CONFIG_REGULATOR_MAX8649)	+= max8649.o
 obj-$(CONFIG_REGULATOR_MAX8660) += max8660.o
diff --git a/drivers/regulator/lp8788-buck.c b/drivers/regulator/lp8788-buck.c
new file mode 100644
index 0000000..6356e82
--- /dev/null
+++ b/drivers/regulator/lp8788-buck.c
@@ -0,0 +1,629 @@
+/*
+ * TI LP8788 MFD - buck regulator driver
+ *
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
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/mfd/lp8788.h>
+#include <linux/gpio.h>
+
+/* register address */
+#define LP8788_EN_BUCK			0x0C
+#define LP8788_BUCK_DVS_SEL		0x1D
+#define LP8788_BUCK1_VOUT0		0x1E
+#define LP8788_BUCK1_VOUT1		0x1F
+#define LP8788_BUCK1_VOUT2		0x20
+#define LP8788_BUCK1_VOUT3		0x21
+#define LP8788_BUCK2_VOUT0		0x22
+#define LP8788_BUCK2_VOUT1		0x23
+#define LP8788_BUCK2_VOUT2		0x24
+#define LP8788_BUCK2_VOUT3		0x25
+#define LP8788_BUCK3_VOUT		0x26
+#define LP8788_BUCK4_VOUT		0x27
+#define LP8788_BUCK1_TIMESTEP		0x28
+#define LP8788_BUCK_PWM			0x2D
+
+/* mask/shift bits */
+#define LP8788_EN_BUCK1_M		BIT(0)	/* Addr 0Ch */
+#define LP8788_EN_BUCK2_M		BIT(1)
+#define LP8788_EN_BUCK3_M		BIT(2)
+#define LP8788_EN_BUCK4_M		BIT(3)
+#define LP8788_BUCK1_DVS_SEL_M		0x04	/* Addr 1Dh */
+#define LP8788_BUCK1_DVS_M		0x03
+#define LP8788_BUCK1_DVS_S		0
+#define LP8788_BUCK2_DVS_SEL_M		0x40
+#define LP8788_BUCK2_DVS_M		0x30
+#define LP8788_BUCK2_DVS_S		4
+#define LP8788_BUCK1_DVS_I2C		BIT(2)
+#define LP8788_BUCK2_DVS_I2C		BIT(6)
+#define LP8788_BUCK1_DVS_PIN		(0 << 2)
+#define LP8788_BUCK2_DVS_PIN		(0 << 6)
+#define LP8788_VOUT_M			0x1F	/* Addr 1Eh ~ 27h */
+#define LP8788_STARTUP_TIME_M		0xF8	/* Addr 28h ~ 2Bh */
+#define LP8788_STARTUP_TIME_S		3
+#define LP8788_FPWM_BUCK1_M		BIT(0)	/* Addr 2Dh */
+#define LP8788_FPWM_BUCK1_S		0
+#define LP8788_FPWM_BUCK2_M		BIT(1)
+#define LP8788_FPWM_BUCK2_S		1
+#define LP8788_FPWM_BUCK3_M		BIT(2)
+#define LP8788_FPWM_BUCK3_S		2
+#define LP8788_FPWM_BUCK4_M		BIT(3)
+#define LP8788_FPWM_BUCK4_S		3
+
+#define INVALID_ADDR			0xFF
+#define LP8788_FORCE_PWM		1
+#define LP8788_AUTO_PWM			0
+#define PIN_LOW				0
+#define PIN_HIGH			1
+#define ENABLE_TIME_USEC		32
+
+enum lp8788_dvs_state {
+	DVS_LOW  = GPIOF_OUT_INIT_LOW,
+	DVS_HIGH = GPIOF_OUT_INIT_HIGH,
+};
+
+enum lp8788_dvs_mode {
+	REGISTER,
+	EXTPIN,
+};
+
+enum lp8788_buck_id {
+	BUCK1,
+	BUCK2,
+	BUCK3,
+	BUCK4,
+};
+
+struct lp8788_pwm_map {
+	u8 mask;
+	u8 shift;
+};
+
+struct lp8788_buck {
+	struct lp8788 *lp;
+	struct regulator_dev *regulator;
+	struct lp8788_pwm_map *pmap;
+	void *dvs;
+};
+
+/* BUCK 1 ~ 4 voltage table */
+static const int lp8788_buck_vtbl[] = {
+	 500000,  800000,  850000,  900000,  950000, 1000000, 1050000, 1100000,
+	1150000, 1200000, 1250000, 1300000, 1350000, 1400000, 1450000, 1500000,
+	1550000, 1600000, 1650000, 1700000, 1750000, 1800000, 1850000, 1900000,
+	1950000, 2000000,
+};
+
+/* buck pwm mode selection : used for set/get_mode in regulator ops
+ * @forced pwm : fast mode
+ * @auto pwm   : normal mode
+ */
+static struct lp8788_pwm_map buck_pmap[] = {
+	[BUCK1] = {
+		.mask = LP8788_FPWM_BUCK1_M,
+		.shift = LP8788_FPWM_BUCK1_S,
+	},
+	[BUCK2] = {
+		.mask = LP8788_FPWM_BUCK2_M,
+		.shift = LP8788_FPWM_BUCK2_S,
+	},
+	[BUCK3] = {
+		.mask = LP8788_FPWM_BUCK3_M,
+		.shift = LP8788_FPWM_BUCK3_S,
+	},
+	[BUCK4] = {
+		.mask = LP8788_FPWM_BUCK4_M,
+		.shift = LP8788_FPWM_BUCK4_S,
+	},
+};
+
+static const u8 buck1_vout_addr[] = {
+	LP8788_BUCK1_VOUT0, LP8788_BUCK1_VOUT1,
+	LP8788_BUCK1_VOUT2, LP8788_BUCK1_VOUT3,
+};
+
+static const u8 buck2_vout_addr[] = {
+	LP8788_BUCK2_VOUT0, LP8788_BUCK2_VOUT1,
+	LP8788_BUCK2_VOUT2, LP8788_BUCK2_VOUT3,
+};
+
+static void lp8788_buck1_set_dvs(struct lp8788_buck *buck)
+{
+	struct lp8788_buck1_dvs *dvs = (struct lp8788_buck1_dvs *)buck->dvs;
+	enum lp8788_dvs_state pinstate;
+
+	if (!dvs)
+		return;
+
+	pinstate = dvs->vsel == DVS_SEL_V0 ? DVS_LOW : DVS_HIGH;
+	if (gpio_is_valid(dvs->gpio))
+		gpio_set_value(dvs->gpio, pinstate);
+}
+
+static void lp8788_buck2_set_dvs(struct lp8788_buck *buck)
+{
+	struct lp8788_buck2_dvs *dvs = (struct lp8788_buck2_dvs *)buck->dvs;
+	enum lp8788_dvs_state pin1, pin2;
+
+	if (!dvs)
+		return;
+
+	switch (dvs->vsel) {
+	case DVS_SEL_V0:
+		pin1 = DVS_LOW;
+		pin2 = DVS_LOW;
+		break;
+	case DVS_SEL_V1:
+		pin1 = DVS_HIGH;
+		pin2 = DVS_LOW;
+		break;
+	case DVS_SEL_V2:
+		pin1 = DVS_LOW;
+		pin2 = DVS_HIGH;
+		break;
+	case DVS_SEL_V3:
+		pin1 = DVS_HIGH;
+		pin2 = DVS_HIGH;
+		break;
+	default:
+		return;
+	}
+
+	if (gpio_is_valid(dvs->gpio[0]))
+		gpio_set_value(dvs->gpio[0], pin1);
+
+	if (gpio_is_valid(dvs->gpio[1]))
+		gpio_set_value(dvs->gpio[1], pin2);
+}
+
+static void lp8788_set_dvs(struct lp8788_buck *buck, enum lp8788_buck_id id)
+{
+	switch (id) {
+	case BUCK1:
+		lp8788_buck1_set_dvs(buck);
+		break;
+	case BUCK2:
+		lp8788_buck2_set_dvs(buck);
+		break;
+	default:
+		break;
+	}
+}
+
+static enum lp8788_dvs_mode
+lp8788_get_buck_dvs_ctrl_mode(struct lp8788_buck *buck, enum lp8788_buck_id id)
+{
+	u8 val, mask;
+
+	switch (id) {
+	case BUCK1:
+		mask = LP8788_BUCK1_DVS_SEL_M;
+		break;
+	case BUCK2:
+		mask = LP8788_BUCK2_DVS_SEL_M;
+		break;
+	default:
+		return REGISTER;
+	}
+
+	lp8788_read_byte(buck->lp, LP8788_BUCK_DVS_SEL, &val);
+
+	return val & mask ? REGISTER : EXTPIN;
+}
+
+static bool lp8788_is_valid_buck_addr(u8 addr)
+{
+	switch (addr) {
+	case LP8788_BUCK1_VOUT0:
+	case LP8788_BUCK1_VOUT1:
+	case LP8788_BUCK1_VOUT2:
+	case LP8788_BUCK1_VOUT3:
+	case LP8788_BUCK2_VOUT0:
+	case LP8788_BUCK2_VOUT1:
+	case LP8788_BUCK2_VOUT2:
+	case LP8788_BUCK2_VOUT3:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static u8 lp8788_select_buck_vout_addr(struct lp8788_buck *buck,
+					enum lp8788_buck_id id)
+{
+	enum lp8788_dvs_mode mode = lp8788_get_buck_dvs_ctrl_mode(buck, id);
+	struct lp8788_buck1_dvs *b1_dvs;
+	struct lp8788_buck2_dvs *b2_dvs;
+	u8 val, idx, addr;
+	int pin1, pin2;
+
+	switch (id) {
+	case BUCK1:
+		if (mode == EXTPIN) {
+			b1_dvs = (struct lp8788_buck1_dvs *)buck->dvs;
+			if (!b1_dvs)
+				goto err;
+
+			idx = gpio_get_value(b1_dvs->gpio) ? 1 : 0;
+		} else {
+			lp8788_read_byte(buck->lp, LP8788_BUCK_DVS_SEL, &val);
+			idx = (val & LP8788_BUCK1_DVS_M) >> LP8788_BUCK1_DVS_S;
+		}
+		addr = buck1_vout_addr[idx];
+		break;
+	case BUCK2:
+		if (mode == EXTPIN) {
+			b2_dvs = (struct lp8788_buck2_dvs *)buck->dvs;
+			if (!b2_dvs)
+				goto err;
+
+			pin1 = gpio_get_value(b2_dvs->gpio[0]);
+			pin2 = gpio_get_value(b2_dvs->gpio[1]);
+
+			if (pin1 == PIN_LOW && pin2 == PIN_LOW)
+				idx = 0;
+			else if (pin1 == PIN_LOW && pin2 == PIN_HIGH)
+				idx = 2;
+			else if (pin1 == PIN_HIGH && pin2 == PIN_LOW)
+				idx = 1;
+			else
+				idx = 3;
+		} else {
+			lp8788_read_byte(buck->lp, LP8788_BUCK_DVS_SEL, &val);
+			idx = (val & LP8788_BUCK2_DVS_M) >> LP8788_BUCK2_DVS_S;
+		}
+		addr = buck2_vout_addr[idx];
+		break;
+	default:
+		goto err;
+	}
+
+	return addr;
+err:
+	return INVALID_ADDR;
+}
+
+static int lp8788_buck12_set_voltage_sel(struct regulator_dev *rdev,
+					unsigned selector)
+{
+	struct lp8788_buck *buck = rdev_get_drvdata(rdev);
+	enum lp8788_buck_id id = rdev_get_id(rdev);
+	u8 addr;
+
+	if (buck->dvs)
+		lp8788_set_dvs(buck, id);
+
+	addr = lp8788_select_buck_vout_addr(buck, id);
+	if (!lp8788_is_valid_buck_addr(addr))
+		return -EINVAL;
+
+	return lp8788_update_bits(buck->lp, addr, LP8788_VOUT_M, selector);
+}
+
+static int lp8788_buck12_get_voltage_sel(struct regulator_dev *rdev)
+{
+	struct lp8788_buck *buck = rdev_get_drvdata(rdev);
+	enum lp8788_buck_id id = rdev_get_id(rdev);
+	int ret;
+	u8 val, addr;
+
+	addr = lp8788_select_buck_vout_addr(buck, id);
+	if (!lp8788_is_valid_buck_addr(addr))
+		return -EINVAL;
+
+	ret = lp8788_read_byte(buck->lp, addr, &val);
+	if (ret)
+		return ret;
+
+	return val & LP8788_VOUT_M;
+}
+
+static int lp8788_buck_enable_time(struct regulator_dev *rdev)
+{
+	struct lp8788_buck *buck = rdev_get_drvdata(rdev);
+	enum lp8788_buck_id id = rdev_get_id(rdev);
+	u8 val, addr = LP8788_BUCK1_TIMESTEP + id;
+
+	if (lp8788_read_byte(buck->lp, addr, &val))
+		return -EINVAL;
+
+	val = (val & LP8788_STARTUP_TIME_M) >> LP8788_STARTUP_TIME_S;
+
+	return ENABLE_TIME_USEC * val;
+}
+
+static int lp8788_buck_set_mode(struct regulator_dev *rdev, unsigned int mode)
+{
+	struct lp8788_buck *buck = rdev_get_drvdata(rdev);
+	struct lp8788_pwm_map *pmap = buck->pmap;
+	u8 val;
+
+	if (!pmap)
+		return -EINVAL;
+
+	switch (mode) {
+	case REGULATOR_MODE_FAST:
+		val = LP8788_FORCE_PWM << pmap->shift;
+		break;
+	case REGULATOR_MODE_NORMAL:
+		val = LP8788_AUTO_PWM << pmap->shift;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return lp8788_update_bits(buck->lp, LP8788_BUCK_PWM, pmap->mask, val);
+}
+
+static unsigned int lp8788_buck_get_mode(struct regulator_dev *rdev)
+{
+	struct lp8788_buck *buck = rdev_get_drvdata(rdev);
+	struct lp8788_pwm_map *pmap = buck->pmap;
+	u8 val;
+	int ret;
+
+	if (!pmap)
+		return -EINVAL;
+
+	ret = lp8788_read_byte(buck->lp, LP8788_BUCK_PWM, &val);
+	if (ret)
+		return ret;
+
+	return val & pmap->mask ? REGULATOR_MODE_FAST : REGULATOR_MODE_NORMAL;
+}
+
+static struct regulator_ops lp8788_buck12_ops = {
+	.list_voltage = regulator_list_voltage_table,
+	.set_voltage_sel = lp8788_buck12_set_voltage_sel,
+	.get_voltage_sel = lp8788_buck12_get_voltage_sel,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable_time = lp8788_buck_enable_time,
+	.set_mode = lp8788_buck_set_mode,
+	.get_mode = lp8788_buck_get_mode,
+};
+
+static struct regulator_ops lp8788_buck34_ops = {
+	.list_voltage = regulator_list_voltage_table,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable_time = lp8788_buck_enable_time,
+	.set_mode = lp8788_buck_set_mode,
+	.get_mode = lp8788_buck_get_mode,
+};
+
+static struct regulator_desc lp8788_buck_desc[] = {
+	{
+		.name = "buck1",
+		.id = BUCK1,
+		.ops = &lp8788_buck12_ops,
+		.n_voltages = ARRAY_SIZE(lp8788_buck_vtbl),
+		.volt_table = lp8788_buck_vtbl,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.enable_reg = LP8788_EN_BUCK,
+		.enable_mask = LP8788_EN_BUCK1_M,
+	},
+	{
+		.name = "buck2",
+		.id = BUCK2,
+		.ops = &lp8788_buck12_ops,
+		.n_voltages = ARRAY_SIZE(lp8788_buck_vtbl),
+		.volt_table = lp8788_buck_vtbl,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.enable_reg = LP8788_EN_BUCK,
+		.enable_mask = LP8788_EN_BUCK2_M,
+	},
+	{
+		.name = "buck3",
+		.id = BUCK3,
+		.ops = &lp8788_buck34_ops,
+		.n_voltages = ARRAY_SIZE(lp8788_buck_vtbl),
+		.volt_table = lp8788_buck_vtbl,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.vsel_reg = LP8788_BUCK3_VOUT,
+		.vsel_mask = LP8788_VOUT_M,
+		.enable_reg = LP8788_EN_BUCK,
+		.enable_mask = LP8788_EN_BUCK3_M,
+	},
+	{
+		.name = "buck4",
+		.id = BUCK4,
+		.ops = &lp8788_buck34_ops,
+		.n_voltages = ARRAY_SIZE(lp8788_buck_vtbl),
+		.volt_table = lp8788_buck_vtbl,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.vsel_reg = LP8788_BUCK4_VOUT,
+		.vsel_mask = LP8788_VOUT_M,
+		.enable_reg = LP8788_EN_BUCK,
+		.enable_mask = LP8788_EN_BUCK4_M,
+	},
+};
+
+static int lp8788_set_default_dvs_ctrl_mode(struct lp8788 *lp,
+					enum lp8788_buck_id id)
+{
+	u8 mask, val;
+
+	switch (id) {
+	case BUCK1:
+		mask = LP8788_BUCK1_DVS_SEL_M;
+		val  = LP8788_BUCK1_DVS_I2C;
+		break;
+	case BUCK2:
+		mask = LP8788_BUCK2_DVS_SEL_M;
+		val  = LP8788_BUCK2_DVS_I2C;
+		break;
+	default:
+		return 0;
+	}
+
+	return lp8788_update_bits(lp, LP8788_BUCK_DVS_SEL, mask, val);
+}
+
+static int _gpio_request(struct lp8788_buck *buck, int gpio, char *name)
+{
+	struct device *dev = buck->lp->dev;
+
+	if (!gpio_is_valid(gpio)) {
+		dev_err(dev, "invalid gpio: %d\n", gpio);
+		return -EINVAL;
+	}
+
+	return devm_gpio_request_one(dev, gpio, DVS_LOW, name);
+}
+
+static int lp8788_dvs_gpio_request(struct lp8788_buck *buck,
+				enum lp8788_buck_id id)
+{
+	struct lp8788_platform_data *pdata = buck->lp->pdata;
+	char *b1_name = "LP8788_B1_DVS";
+	char *b2_name[] = { "LP8788_B2_DVS1", "LP8788_B2_DVS2" };
+	int i, gpio, ret;
+
+	switch (id) {
+	case BUCK1:
+		gpio = pdata->buck1_dvs->gpio;
+		ret = _gpio_request(buck, gpio, b1_name);
+		if (ret)
+			return ret;
+
+		buck->dvs = pdata->buck1_dvs;
+		break;
+	case BUCK2:
+		for (i = 0 ; i < LP8788_NUM_BUCK2_DVS ; i++) {
+			gpio = pdata->buck2_dvs->gpio[i];
+			ret = _gpio_request(buck, gpio, b2_name[i]);
+			if (ret)
+				return ret;
+		}
+		buck->dvs = pdata->buck2_dvs;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int lp8788_init_dvs(struct lp8788_buck *buck, enum lp8788_buck_id id)
+{
+	struct lp8788_platform_data *pdata = buck->lp->pdata;
+	u8 mask[] = { LP8788_BUCK1_DVS_SEL_M, LP8788_BUCK2_DVS_SEL_M };
+	u8 val[]  = { LP8788_BUCK1_DVS_PIN, LP8788_BUCK2_DVS_PIN };
+
+	/* no dvs for buck3, 4 */
+	if (id == BUCK3 || id == BUCK4)
+		return 0;
+
+	/* no dvs platform data, then dvs will be selected by I2C registers */
+	if (!pdata)
+		goto set_default_dvs_mode;
+
+	if ((id == BUCK1 && !pdata->buck1_dvs) ||
+		(id == BUCK2 && !pdata->buck2_dvs))
+		goto set_default_dvs_mode;
+
+	if (lp8788_dvs_gpio_request(buck, id))
+		goto set_default_dvs_mode;
+
+	return lp8788_update_bits(buck->lp, LP8788_BUCK_DVS_SEL, mask[id],
+				val[id]);
+
+set_default_dvs_mode:
+	return lp8788_set_default_dvs_ctrl_mode(buck->lp, id);
+}
+
+static __devinit int lp8788_buck_probe(struct platform_device *pdev)
+{
+	struct lp8788 *lp = dev_get_drvdata(pdev->dev.parent);
+	int id = pdev->id;
+	struct lp8788_buck *buck;
+	struct regulator_config cfg = { };
+	struct regulator_dev *rdev;
+	int ret;
+
+	buck = devm_kzalloc(lp->dev, sizeof(struct lp8788_buck), GFP_KERNEL);
+	if (!buck)
+		return -ENOMEM;
+
+	buck->lp = lp;
+	buck->pmap = &buck_pmap[id];
+
+	ret = lp8788_init_dvs(buck, id);
+	if (ret)
+		return ret;
+
+	cfg.dev = lp->dev;
+	cfg.init_data = lp->pdata ? lp->pdata->buck_data[id] : NULL;
+	cfg.driver_data = buck;
+	cfg.regmap = lp->regmap;
+
+	rdev = regulator_register(&lp8788_buck_desc[id], &cfg);
+	if (IS_ERR(rdev)) {
+		ret = PTR_ERR(rdev);
+		dev_err(lp->dev, "BUCK%d regulator register err = %d\n",
+				id + 1, ret);
+		return ret;
+	}
+
+	buck->regulator = rdev;
+	platform_set_drvdata(pdev, buck);
+
+	return 0;
+}
+
+static int __devexit lp8788_buck_remove(struct platform_device *pdev)
+{
+	struct lp8788_buck *buck = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+	regulator_unregister(buck->regulator);
+
+	return 0;
+}
+
+static struct platform_driver lp8788_buck_driver = {
+	.probe = lp8788_buck_probe,
+	.remove = __devexit_p(lp8788_buck_remove),
+	.driver = {
+		.name = LP8788_DEV_BUCK,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init lp8788_buck_init(void)
+{
+	return platform_driver_register(&lp8788_buck_driver);
+}
+subsys_initcall(lp8788_buck_init);
+
+static void __exit lp8788_buck_exit(void)
+{
+	platform_driver_unregister(&lp8788_buck_driver);
+}
+module_exit(lp8788_buck_exit);
+
+MODULE_DESCRIPTION("TI LP8788 BUCK Driver");
+MODULE_AUTHOR("Milo Kim");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:lp8788-buck");
diff --git a/drivers/regulator/lp8788-ldo.c b/drivers/regulator/lp8788-ldo.c
new file mode 100644
index 0000000..d2122e4
--- /dev/null
+++ b/drivers/regulator/lp8788-ldo.c
@@ -0,0 +1,842 @@
+/*
+ * TI LP8788 MFD - ldo regulator driver
+ *
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
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/gpio.h>
+#include <linux/mfd/lp8788.h>
+
+/* register address */
+#define LP8788_EN_LDO_A			0x0D	/* DLDO 1 ~ 8 */
+#define LP8788_EN_LDO_B			0x0E	/* DLDO 9 ~ 12, ALDO 1 ~ 4 */
+#define LP8788_EN_LDO_C			0x0F	/* ALDO 5 ~ 10 */
+#define LP8788_EN_SEL			0x10
+#define LP8788_DLDO1_VOUT		0x2E
+#define LP8788_DLDO2_VOUT		0x2F
+#define LP8788_DLDO3_VOUT		0x30
+#define LP8788_DLDO4_VOUT		0x31
+#define LP8788_DLDO5_VOUT		0x32
+#define LP8788_DLDO6_VOUT		0x33
+#define LP8788_DLDO7_VOUT		0x34
+#define LP8788_DLDO8_VOUT		0x35
+#define LP8788_DLDO9_VOUT		0x36
+#define LP8788_DLDO10_VOUT		0x37
+#define LP8788_DLDO11_VOUT		0x38
+#define LP8788_DLDO12_VOUT		0x39
+#define LP8788_ALDO1_VOUT		0x3A
+#define LP8788_ALDO2_VOUT		0x3B
+#define LP8788_ALDO3_VOUT		0x3C
+#define LP8788_ALDO4_VOUT		0x3D
+#define LP8788_ALDO5_VOUT		0x3E
+#define LP8788_ALDO6_VOUT		0x3F
+#define LP8788_ALDO7_VOUT		0x40
+#define LP8788_ALDO8_VOUT		0x41
+#define LP8788_ALDO9_VOUT		0x42
+#define LP8788_ALDO10_VOUT		0x43
+#define LP8788_DLDO1_TIMESTEP		0x44
+
+/* mask/shift bits */
+#define LP8788_EN_DLDO1_M		BIT(0)	/* Addr 0Dh ~ 0Fh */
+#define LP8788_EN_DLDO2_M		BIT(1)
+#define LP8788_EN_DLDO3_M		BIT(2)
+#define LP8788_EN_DLDO4_M		BIT(3)
+#define LP8788_EN_DLDO5_M		BIT(4)
+#define LP8788_EN_DLDO6_M		BIT(5)
+#define LP8788_EN_DLDO7_M		BIT(6)
+#define LP8788_EN_DLDO8_M		BIT(7)
+#define LP8788_EN_DLDO9_M		BIT(0)
+#define LP8788_EN_DLDO10_M		BIT(1)
+#define LP8788_EN_DLDO11_M		BIT(2)
+#define LP8788_EN_DLDO12_M		BIT(3)
+#define LP8788_EN_ALDO1_M		BIT(4)
+#define LP8788_EN_ALDO2_M		BIT(5)
+#define LP8788_EN_ALDO3_M		BIT(6)
+#define LP8788_EN_ALDO4_M		BIT(7)
+#define LP8788_EN_ALDO5_M		BIT(0)
+#define LP8788_EN_ALDO6_M		BIT(1)
+#define LP8788_EN_ALDO7_M		BIT(2)
+#define LP8788_EN_ALDO8_M		BIT(3)
+#define LP8788_EN_ALDO9_M		BIT(4)
+#define LP8788_EN_ALDO10_M		BIT(5)
+#define LP8788_EN_SEL_DLDO911_M		BIT(0)	/* Addr 10h */
+#define LP8788_EN_SEL_DLDO7_M		BIT(1)
+#define LP8788_EN_SEL_ALDO7_M		BIT(2)
+#define LP8788_EN_SEL_ALDO5_M		BIT(3)
+#define LP8788_EN_SEL_ALDO234_M		BIT(4)
+#define LP8788_EN_SEL_ALDO1_M		BIT(5)
+#define LP8788_VOUT_5BIT_M		0x1F	/* Addr 2Eh ~ 43h */
+#define LP8788_VOUT_4BIT_M		0x0F
+#define LP8788_VOUT_3BIT_M		0x07
+#define LP8788_VOUT_1BIT_M		0x01
+#define LP8788_STARTUP_TIME_M		0xF8	/* Addr 44h ~ 59h */
+#define LP8788_STARTUP_TIME_S		3
+
+#define ENABLE_TIME_USEC		32
+#define ENABLE				GPIOF_OUT_INIT_HIGH
+#define DISABLE				GPIOF_OUT_INIT_LOW
+
+enum lp8788_enable_mode {
+	REGISTER,
+	EXTPIN,
+};
+
+enum lp8788_ldo_id {
+	DLDO1,
+	DLDO2,
+	DLDO3,
+	DLDO4,
+	DLDO5,
+	DLDO6,
+	DLDO7,
+	DLDO8,
+	DLDO9,
+	DLDO10,
+	DLDO11,
+	DLDO12,
+	ALDO1,
+	ALDO2,
+	ALDO3,
+	ALDO4,
+	ALDO5,
+	ALDO6,
+	ALDO7,
+	ALDO8,
+	ALDO9,
+	ALDO10,
+};
+
+struct lp8788_ldo {
+	struct lp8788 *lp;
+	struct regulator_desc *desc;
+	struct regulator_dev *regulator;
+	struct lp8788_ldo_enable_pin *en_pin;
+};
+
+/* DLDO 1, 2, 3, 9 voltage table */
+const int lp8788_dldo1239_vtbl[] = {
+	1800000, 1900000, 2000000, 2100000, 2200000, 2300000, 2400000, 2500000,
+	2600000, 2700000, 2800000, 2900000, 3000000, 2850000, 2850000, 2850000,
+	2850000, 2850000, 2850000, 2850000, 2850000, 2850000, 2850000, 2850000,
+	2850000, 2850000, 2850000, 2850000, 2850000, 2850000, 2850000, 2850000,
+};
+
+/* DLDO 4 voltage table */
+static const int lp8788_dldo4_vtbl[] = { 1800000, 3000000 };
+
+/* DLDO 5, 7, 8 and ALDO 6 voltage table */
+static const int lp8788_dldo578_aldo6_vtbl[] = {
+	1800000, 1900000, 2000000, 2100000, 2200000, 2300000, 2400000, 2500000,
+	2600000, 2700000, 2800000, 2900000, 3000000, 3000000, 3000000, 3000000,
+};
+
+/* DLDO 6 voltage table */
+static const int lp8788_dldo6_vtbl[] = {
+	3000000, 3100000, 3200000, 3300000, 3400000, 3500000, 3600000, 3600000,
+};
+
+/* DLDO 10, 11 voltage table */
+static const int lp8788_dldo1011_vtbl[] = {
+	1100000, 1150000, 1200000, 1250000, 1300000, 1350000, 1400000, 1450000,
+	1500000, 1500000, 1500000, 1500000, 1500000, 1500000, 1500000, 1500000,
+};
+
+/* ALDO 1 voltage table */
+static const int lp8788_aldo1_vtbl[] = { 1800000, 2850000 };
+
+/* ALDO 7 voltage table */
+static const int lp8788_aldo7_vtbl[] = {
+	1200000, 1300000, 1400000, 1500000, 1600000, 1700000, 1800000, 1800000,
+};
+
+static enum lp8788_ldo_id lp8788_dldo_id[] = {
+	DLDO1,
+	DLDO2,
+	DLDO3,
+	DLDO4,
+	DLDO5,
+	DLDO6,
+	DLDO7,
+	DLDO8,
+	DLDO9,
+	DLDO10,
+	DLDO11,
+	DLDO12,
+};
+
+static enum lp8788_ldo_id lp8788_aldo_id[] = {
+	ALDO1,
+	ALDO2,
+	ALDO3,
+	ALDO4,
+	ALDO5,
+	ALDO6,
+	ALDO7,
+	ALDO8,
+	ALDO9,
+	ALDO10,
+};
+
+/* DLDO 7, 9 and 11, ALDO 1 ~ 5 and 7
+   : can be enabled either by external pin or by i2c register */
+static enum lp8788_enable_mode
+lp8788_get_ldo_enable_mode(struct lp8788_ldo *ldo, enum lp8788_ldo_id id)
+{
+	int ret;
+	u8 val, mask;
+
+	ret = lp8788_read_byte(ldo->lp, LP8788_EN_SEL, &val);
+	if (ret)
+		return ret;
+
+	switch (id) {
+	case DLDO7:
+		mask =  LP8788_EN_SEL_DLDO7_M;
+		break;
+	case DLDO9:
+	case DLDO11:
+		mask =  LP8788_EN_SEL_DLDO911_M;
+		break;
+	case ALDO1:
+		mask =  LP8788_EN_SEL_ALDO1_M;
+		break;
+	case ALDO2 ... ALDO4:
+		mask =  LP8788_EN_SEL_ALDO234_M;
+		break;
+	case ALDO5:
+		mask =  LP8788_EN_SEL_ALDO5_M;
+		break;
+	case ALDO7:
+		mask =  LP8788_EN_SEL_ALDO7_M;
+		break;
+	default:
+		return REGISTER;
+	}
+
+	return val & mask ? EXTPIN : REGISTER;
+}
+
+static int lp8788_ldo_ctrl_by_extern_pin(struct lp8788_ldo *ldo, int pinstate)
+{
+	struct lp8788_ldo_enable_pin *pin = ldo->en_pin;
+
+	if (!pin)
+		return -EINVAL;
+
+	if (gpio_is_valid(pin->gpio))
+		gpio_set_value(pin->gpio, pinstate);
+
+	return 0;
+}
+
+static int lp8788_ldo_is_enabled_by_extern_pin(struct lp8788_ldo *ldo)
+{
+	struct lp8788_ldo_enable_pin *pin = ldo->en_pin;
+
+	if (!pin)
+		return -EINVAL;
+
+	return gpio_get_value(pin->gpio) ? 1 : 0;
+}
+
+static int lp8788_ldo_enable(struct regulator_dev *rdev)
+{
+	struct lp8788_ldo *ldo = rdev_get_drvdata(rdev);
+	enum lp8788_ldo_id id = rdev_get_id(rdev);
+	enum lp8788_enable_mode mode = lp8788_get_ldo_enable_mode(ldo, id);
+
+	switch (mode) {
+	case EXTPIN:
+		return lp8788_ldo_ctrl_by_extern_pin(ldo, ENABLE);
+	case REGISTER:
+		return regulator_enable_regmap(rdev);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int lp8788_ldo_disable(struct regulator_dev *rdev)
+{
+	struct lp8788_ldo *ldo = rdev_get_drvdata(rdev);
+	enum lp8788_ldo_id id = rdev_get_id(rdev);
+	enum lp8788_enable_mode mode = lp8788_get_ldo_enable_mode(ldo, id);
+
+	switch (mode) {
+	case EXTPIN:
+		return lp8788_ldo_ctrl_by_extern_pin(ldo, DISABLE);
+	case REGISTER:
+		return regulator_disable_regmap(rdev);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int lp8788_ldo_is_enabled(struct regulator_dev *rdev)
+{
+	struct lp8788_ldo *ldo = rdev_get_drvdata(rdev);
+	enum lp8788_ldo_id id = rdev_get_id(rdev);
+	enum lp8788_enable_mode mode = lp8788_get_ldo_enable_mode(ldo, id);
+
+	switch (mode) {
+	case EXTPIN:
+		return lp8788_ldo_is_enabled_by_extern_pin(ldo);
+	case REGISTER:
+		return regulator_is_enabled_regmap(rdev);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int lp8788_ldo_enable_time(struct regulator_dev *rdev)
+{
+	struct lp8788_ldo *ldo = rdev_get_drvdata(rdev);
+	enum lp8788_ldo_id id = rdev_get_id(rdev);
+	u8 val, addr = LP8788_DLDO1_TIMESTEP + id;
+
+	if (lp8788_read_byte(ldo->lp, addr, &val))
+		return -EINVAL;
+
+	val = (val & LP8788_STARTUP_TIME_M) >> LP8788_STARTUP_TIME_S;
+
+	return ENABLE_TIME_USEC * val;
+}
+
+static int lp8788_ldo_fixed_get_voltage(struct regulator_dev *rdev)
+{
+	enum lp8788_ldo_id id = rdev_get_id(rdev);
+
+	switch (id) {
+	case ALDO2 ... ALDO5:
+		return 2850000;
+	case DLDO12:
+	case ALDO8 ... ALDO9:
+		return 2500000;
+	case ALDO10:
+		return 1100000;
+	default:
+		return -EINVAL;
+	}
+}
+
+static struct regulator_ops lp8788_ldo_voltage_table_ops = {
+	.list_voltage = regulator_list_voltage_table,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.enable = lp8788_ldo_enable,
+	.disable = lp8788_ldo_disable,
+	.is_enabled = lp8788_ldo_is_enabled,
+	.enable_time = lp8788_ldo_enable_time,
+};
+
+static struct regulator_ops lp8788_ldo_voltage_fixed_ops = {
+	.get_voltage = lp8788_ldo_fixed_get_voltage,
+	.enable = lp8788_ldo_enable,
+	.disable = lp8788_ldo_disable,
+	.is_enabled = lp8788_ldo_is_enabled,
+	.enable_time = lp8788_ldo_enable_time,
+};
+
+static struct regulator_desc lp8788_dldo_desc[] = {
+	{
+		.name = "dldo1",
+		.id = DLDO1,
+		.ops = &lp8788_ldo_voltage_table_ops,
+		.n_voltages = ARRAY_SIZE(lp8788_dldo1239_vtbl),
+		.volt_table = lp8788_dldo1239_vtbl,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.vsel_reg = LP8788_DLDO1_VOUT,
+		.vsel_mask = LP8788_VOUT_5BIT_M,
+		.enable_reg = LP8788_EN_LDO_A,
+		.enable_mask = LP8788_EN_DLDO1_M,
+	},
+	{
+		.name = "dldo2",
+		.id = DLDO2,
+		.ops = &lp8788_ldo_voltage_table_ops,
+		.n_voltages = ARRAY_SIZE(lp8788_dldo1239_vtbl),
+		.volt_table = lp8788_dldo1239_vtbl,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.vsel_reg = LP8788_DLDO2_VOUT,
+		.vsel_mask = LP8788_VOUT_5BIT_M,
+		.enable_reg = LP8788_EN_LDO_A,
+		.enable_mask = LP8788_EN_DLDO2_M,
+	},
+	{
+		.name = "dldo3",
+		.id = DLDO3,
+		.ops = &lp8788_ldo_voltage_table_ops,
+		.n_voltages = ARRAY_SIZE(lp8788_dldo1239_vtbl),
+		.volt_table = lp8788_dldo1239_vtbl,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.vsel_reg = LP8788_DLDO3_VOUT,
+		.vsel_mask = LP8788_VOUT_5BIT_M,
+		.enable_reg = LP8788_EN_LDO_A,
+		.enable_mask = LP8788_EN_DLDO3_M,
+	},
+	{
+		.name = "dldo4",
+		.id = DLDO4,
+		.ops = &lp8788_ldo_voltage_table_ops,
+		.n_voltages = ARRAY_SIZE(lp8788_dldo4_vtbl),
+		.volt_table = lp8788_dldo4_vtbl,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.vsel_reg = LP8788_DLDO4_VOUT,
+		.vsel_mask = LP8788_VOUT_1BIT_M,
+		.enable_reg = LP8788_EN_LDO_A,
+		.enable_mask = LP8788_EN_DLDO4_M,
+	},
+	{
+		.name = "dldo5",
+		.id = DLDO5,
+		.ops = &lp8788_ldo_voltage_table_ops,
+		.n_voltages = ARRAY_SIZE(lp8788_dldo578_aldo6_vtbl),
+		.volt_table = lp8788_dldo578_aldo6_vtbl,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.vsel_reg = LP8788_DLDO5_VOUT,
+		.vsel_mask = LP8788_VOUT_4BIT_M,
+		.enable_reg = LP8788_EN_LDO_A,
+		.enable_mask = LP8788_EN_DLDO5_M,
+	},
+	{
+		.name = "dldo6",
+		.id = DLDO6,
+		.ops = &lp8788_ldo_voltage_table_ops,
+		.n_voltages = ARRAY_SIZE(lp8788_dldo6_vtbl),
+		.volt_table = lp8788_dldo6_vtbl,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.vsel_reg = LP8788_DLDO6_VOUT,
+		.vsel_mask = LP8788_VOUT_3BIT_M,
+		.enable_reg = LP8788_EN_LDO_A,
+		.enable_mask = LP8788_EN_DLDO6_M,
+	},
+	{
+		.name = "dldo7",
+		.id = DLDO7,
+		.ops = &lp8788_ldo_voltage_table_ops,
+		.n_voltages = ARRAY_SIZE(lp8788_dldo578_aldo6_vtbl),
+		.volt_table = lp8788_dldo578_aldo6_vtbl,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.vsel_reg = LP8788_DLDO7_VOUT,
+		.vsel_mask = LP8788_VOUT_4BIT_M,
+		.enable_reg = LP8788_EN_LDO_A,
+		.enable_mask = LP8788_EN_DLDO7_M,
+	},
+	{
+		.name = "dldo8",
+		.id = DLDO8,
+		.ops = &lp8788_ldo_voltage_table_ops,
+		.n_voltages = ARRAY_SIZE(lp8788_dldo578_aldo6_vtbl),
+		.volt_table = lp8788_dldo578_aldo6_vtbl,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.vsel_reg = LP8788_DLDO8_VOUT,
+		.vsel_mask = LP8788_VOUT_4BIT_M,
+		.enable_reg = LP8788_EN_LDO_A,
+		.enable_mask = LP8788_EN_DLDO8_M,
+	},
+	{
+		.name = "dldo9",
+		.id = DLDO9,
+		.ops = &lp8788_ldo_voltage_table_ops,
+		.n_voltages = ARRAY_SIZE(lp8788_dldo1239_vtbl),
+		.volt_table = lp8788_dldo1239_vtbl,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.vsel_reg = LP8788_DLDO9_VOUT,
+		.vsel_mask = LP8788_VOUT_5BIT_M,
+		.enable_reg = LP8788_EN_LDO_B,
+		.enable_mask = LP8788_EN_DLDO9_M,
+	},
+	{
+		.name = "dldo10",
+		.id = DLDO10,
+		.ops = &lp8788_ldo_voltage_table_ops,
+		.n_voltages = ARRAY_SIZE(lp8788_dldo1011_vtbl),
+		.volt_table = lp8788_dldo1011_vtbl,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.vsel_reg = LP8788_DLDO10_VOUT,
+		.vsel_mask = LP8788_VOUT_4BIT_M,
+		.enable_reg = LP8788_EN_LDO_B,
+		.enable_mask = LP8788_EN_DLDO10_M,
+	},
+	{
+		.name = "dldo11",
+		.id = DLDO11,
+		.ops = &lp8788_ldo_voltage_table_ops,
+		.n_voltages = ARRAY_SIZE(lp8788_dldo1011_vtbl),
+		.volt_table = lp8788_dldo1011_vtbl,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.vsel_reg = LP8788_DLDO11_VOUT,
+		.vsel_mask = LP8788_VOUT_4BIT_M,
+		.enable_reg = LP8788_EN_LDO_B,
+		.enable_mask = LP8788_EN_DLDO11_M,
+	},
+	{
+		.name = "dldo12",
+		.id = DLDO12,
+		.ops = &lp8788_ldo_voltage_fixed_ops,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.enable_reg = LP8788_EN_LDO_B,
+		.enable_mask = LP8788_EN_DLDO12_M,
+	},
+};
+
+static struct regulator_desc lp8788_aldo_desc[] = {
+	{
+		.name = "aldo1",
+		.id = ALDO1,
+		.ops = &lp8788_ldo_voltage_table_ops,
+		.n_voltages = ARRAY_SIZE(lp8788_aldo1_vtbl),
+		.volt_table = lp8788_aldo1_vtbl,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.vsel_reg = LP8788_ALDO1_VOUT,
+		.vsel_mask = LP8788_VOUT_1BIT_M,
+		.enable_reg = LP8788_EN_LDO_B,
+		.enable_mask = LP8788_EN_ALDO1_M,
+	},
+	{
+		.name = "aldo2",
+		.id = ALDO2,
+		.ops = &lp8788_ldo_voltage_fixed_ops,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.enable_reg = LP8788_EN_LDO_B,
+		.enable_mask = LP8788_EN_ALDO2_M,
+	},
+	{
+		.name = "aldo3",
+		.id = ALDO3,
+		.ops = &lp8788_ldo_voltage_fixed_ops,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.enable_reg = LP8788_EN_LDO_B,
+		.enable_mask = LP8788_EN_ALDO3_M,
+	},
+	{
+		.name = "aldo4",
+		.id = ALDO4,
+		.ops = &lp8788_ldo_voltage_fixed_ops,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.enable_reg = LP8788_EN_LDO_B,
+		.enable_mask = LP8788_EN_ALDO4_M,
+	},
+	{
+		.name = "aldo5",
+		.id = ALDO5,
+		.ops = &lp8788_ldo_voltage_fixed_ops,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.enable_reg = LP8788_EN_LDO_C,
+		.enable_mask = LP8788_EN_ALDO5_M,
+	},
+	{
+		.name = "aldo6",
+		.id = ALDO6,
+		.ops = &lp8788_ldo_voltage_table_ops,
+		.n_voltages = ARRAY_SIZE(lp8788_dldo578_aldo6_vtbl),
+		.volt_table = lp8788_dldo578_aldo6_vtbl,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.vsel_reg = LP8788_ALDO6_VOUT,
+		.vsel_mask = LP8788_VOUT_4BIT_M,
+		.enable_reg = LP8788_EN_LDO_C,
+		.enable_mask = LP8788_EN_ALDO6_M,
+	},
+	{
+		.name = "aldo7",
+		.id = ALDO7,
+		.ops = &lp8788_ldo_voltage_table_ops,
+		.n_voltages = ARRAY_SIZE(lp8788_aldo7_vtbl),
+		.volt_table = lp8788_aldo7_vtbl,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.vsel_reg = LP8788_ALDO7_VOUT,
+		.vsel_mask = LP8788_VOUT_3BIT_M,
+		.enable_reg = LP8788_EN_LDO_C,
+		.enable_mask = LP8788_EN_ALDO7_M,
+	},
+	{
+		.name = "aldo8",
+		.id = ALDO8,
+		.ops = &lp8788_ldo_voltage_fixed_ops,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.enable_reg = LP8788_EN_LDO_C,
+		.enable_mask = LP8788_EN_ALDO8_M,
+	},
+	{
+		.name = "aldo9",
+		.id = ALDO9,
+		.ops = &lp8788_ldo_voltage_fixed_ops,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.enable_reg = LP8788_EN_LDO_C,
+		.enable_mask = LP8788_EN_ALDO9_M,
+	},
+	{
+		.name = "aldo10",
+		.id = ALDO10,
+		.ops = &lp8788_ldo_voltage_fixed_ops,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+		.enable_reg = LP8788_EN_LDO_C,
+		.enable_mask = LP8788_EN_ALDO10_M,
+	},
+};
+
+static int lp8788_gpio_request_ldo_en(struct lp8788_ldo *ldo,
+				enum lp8788_ext_ldo_en_id id)
+{
+	struct device *dev = ldo->lp->dev;
+	struct lp8788_ldo_enable_pin *pin = ldo->en_pin;
+	int ret, gpio, pinstate;
+	char *name[] = {
+		[EN_ALDO1]   = "LP8788_EN_ALDO1",
+		[EN_ALDO234] = "LP8788_EN_ALDO234",
+		[EN_ALDO5]   = "LP8788_EN_ALDO5",
+		[EN_ALDO7]   = "LP8788_EN_ALDO7",
+		[EN_DLDO7]   = "LP8788_EN_DLDO7",
+		[EN_DLDO911] = "LP8788_EN_DLDO911",
+	};
+
+	gpio = pin->gpio;
+	if (!gpio_is_valid(gpio)) {
+		dev_err(dev, "invalid gpio: %d\n", gpio);
+		return -EINVAL;
+	}
+
+	pinstate = pin->init_state;
+	ret = devm_gpio_request_one(dev, gpio, pinstate, name[id]);
+	if (ret == -EBUSY) {
+		dev_warn(dev, "gpio%d already used\n", gpio);
+		return 0;
+	}
+
+	return ret;
+}
+
+static int lp8788_config_ldo_enable_mode(struct lp8788_ldo *ldo,
+					enum lp8788_ldo_id id)
+{
+	int ret;
+	struct lp8788 *lp = ldo->lp;
+	struct lp8788_platform_data *pdata = lp->pdata;
+	enum lp8788_ext_ldo_en_id enable_id;
+	u8 en_mask[] = {
+		[EN_ALDO1]   = LP8788_EN_SEL_ALDO1_M,
+		[EN_ALDO234] = LP8788_EN_SEL_ALDO234_M,
+		[EN_ALDO5]   = LP8788_EN_SEL_ALDO5_M,
+		[EN_ALDO7]   = LP8788_EN_SEL_ALDO7_M,
+		[EN_DLDO7]   = LP8788_EN_SEL_DLDO7_M,
+		[EN_DLDO911] = LP8788_EN_SEL_DLDO911_M,
+	};
+	u8 val[] = {
+		[EN_ALDO1]   = 0 << 5,
+		[EN_ALDO234] = 0 << 4,
+		[EN_ALDO5]   = 0 << 3,
+		[EN_ALDO7]   = 0 << 2,
+		[EN_DLDO7]   = 0 << 1,
+		[EN_DLDO911] = 0 << 0,
+	};
+
+	switch (id) {
+	case DLDO7:
+		enable_id = EN_DLDO7;
+		break;
+	case DLDO9:
+	case DLDO11:
+		enable_id = EN_DLDO911;
+		break;
+	case ALDO1:
+		enable_id = EN_ALDO1;
+		break;
+	case ALDO2 ... ALDO4:
+		enable_id = EN_ALDO234;
+		break;
+	case ALDO5:
+		enable_id = EN_ALDO5;
+		break;
+	case ALDO7:
+		enable_id = EN_ALDO7;
+		break;
+	default:
+		return 0;
+	}
+
+	/* if no platform data for ldo pin, then set default enable mode */
+	if (!pdata || !pdata->ldo_pin || !pdata->ldo_pin[enable_id])
+		goto set_default_ldo_enable_mode;
+
+	ldo->en_pin = pdata->ldo_pin[enable_id];
+
+	ret = lp8788_gpio_request_ldo_en(ldo, enable_id);
+	if (ret)
+		goto set_default_ldo_enable_mode;
+
+	return ret;
+
+set_default_ldo_enable_mode:
+	return lp8788_update_bits(lp, LP8788_EN_SEL, en_mask[enable_id],
+				val[enable_id]);
+}
+
+static __devinit int lp8788_dldo_probe(struct platform_device *pdev)
+{
+	struct lp8788 *lp = dev_get_drvdata(pdev->dev.parent);
+	int id = pdev->id;
+	struct lp8788_ldo *ldo;
+	struct regulator_config cfg = { };
+	struct regulator_dev *rdev;
+	int ret;
+
+	ldo = devm_kzalloc(lp->dev, sizeof(struct lp8788_ldo), GFP_KERNEL);
+	if (!ldo)
+		return -ENOMEM;
+
+	ldo->lp = lp;
+	ret = lp8788_config_ldo_enable_mode(ldo, lp8788_dldo_id[id]);
+	if (ret)
+		return ret;
+
+	cfg.dev = lp->dev;
+	cfg.init_data = lp->pdata ? lp->pdata->dldo_data[id] : NULL;
+	cfg.driver_data = ldo;
+	cfg.regmap = lp->regmap;
+
+	rdev = regulator_register(&lp8788_dldo_desc[id], &cfg);
+	if (IS_ERR(rdev)) {
+		ret = PTR_ERR(rdev);
+		dev_err(lp->dev, "DLDO%d regulator register err = %d\n",
+				id + 1, ret);
+		return ret;
+	}
+
+	ldo->regulator = rdev;
+	platform_set_drvdata(pdev, ldo);
+
+	return 0;
+}
+
+static int __devexit lp8788_dldo_remove(struct platform_device *pdev)
+{
+	struct lp8788_ldo *ldo = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+	regulator_unregister(ldo->regulator);
+
+	return 0;
+}
+
+static struct platform_driver lp8788_dldo_driver = {
+	.probe = lp8788_dldo_probe,
+	.remove = __devexit_p(lp8788_dldo_remove),
+	.driver = {
+		.name = LP8788_DEV_DLDO,
+		.owner = THIS_MODULE,
+	},
+};
+
+static __devinit int lp8788_aldo_probe(struct platform_device *pdev)
+{
+	struct lp8788 *lp = dev_get_drvdata(pdev->dev.parent);
+	int id = pdev->id;
+	struct lp8788_ldo *ldo;
+	struct regulator_config cfg = { };
+	struct regulator_dev *rdev;
+	int ret;
+
+	ldo = devm_kzalloc(lp->dev, sizeof(struct lp8788_ldo), GFP_KERNEL);
+	if (!ldo)
+		return -ENOMEM;
+
+	ldo->lp = lp;
+	ret = lp8788_config_ldo_enable_mode(ldo, lp8788_aldo_id[id]);
+	if (ret)
+		return ret;
+
+	cfg.dev = lp->dev;
+	cfg.init_data = lp->pdata ? lp->pdata->aldo_data[id] : NULL;
+	cfg.driver_data = ldo;
+	cfg.regmap = lp->regmap;
+
+	rdev = regulator_register(&lp8788_aldo_desc[id], &cfg);
+	if (IS_ERR(rdev)) {
+		ret = PTR_ERR(rdev);
+		dev_err(lp->dev, "ALDO%d regulator register err = %d\n",
+				id + 1, ret);
+		return ret;
+	}
+
+	ldo->regulator = rdev;
+	platform_set_drvdata(pdev, ldo);
+
+	return 0;
+}
+
+static int __devexit lp8788_aldo_remove(struct platform_device *pdev)
+{
+	struct lp8788_ldo *ldo = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+	regulator_unregister(ldo->regulator);
+
+	return 0;
+}
+
+static struct platform_driver lp8788_aldo_driver = {
+	.probe = lp8788_aldo_probe,
+	.remove = __devexit_p(lp8788_aldo_remove),
+	.driver = {
+		.name = LP8788_DEV_ALDO,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init lp8788_ldo_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&lp8788_dldo_driver);
+	if (ret)
+		return ret;
+
+	return platform_driver_register(&lp8788_aldo_driver);
+}
+subsys_initcall(lp8788_ldo_init);
+
+static void __exit lp8788_ldo_exit(void)
+{
+	platform_driver_unregister(&lp8788_aldo_driver);
+	platform_driver_unregister(&lp8788_dldo_driver);
+}
+module_exit(lp8788_ldo_exit);
+
+MODULE_DESCRIPTION("TI LP8788 LDO Driver");
+MODULE_AUTHOR("Milo Kim");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:lp8788-dldo");
+MODULE_ALIAS("platform:lp8788-aldo");
-- 
1.7.2.5


Best Regards,
Milo


