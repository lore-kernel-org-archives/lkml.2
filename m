Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab2FRL3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:29:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44088 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab2FRL3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:29:43 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-20-4fdf11268d0f
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] regualtor: Add samsung s2mps11 regulator driver
Date: Mon, 18 Jun 2012 20:29:41 +0900
Message-id: <067801cd4d45$a743e820$f5cbb860$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1NRacdBFcZvfa+Ra2jpBa8mokVJA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jQV01wfv+BpN28Fpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MvpvvGQu23WKseL5oElMD46NNjF2MHBwSAiYSJ+cVdjFyApli
	EhfurWfrYuTiEBKYziixevNHVghnLpPEkyXHWUGq2AQ0JFbufssGYosI+EpcevkfLM4sYCcx
	90ALE4gtLOAi8af5ICOIzSKgKnGqYxUbyDJeAUOJ6+/VQMK8AoISPybfY4Fo1ZJYv/M4E4Qt
	L7F5zVtmiNvUJR791YXYpCex6/JlqHIRiX0v3jFOYBSYhWTSLCSTZiGZNAtJywJGllWMoqkF
	yQXFSem5hnrFibnFpXnpesn5uZsYwYH5TGoH48oGi0OMAhyMSjy8D/ju+wuxJpYVV+YeYpTg
	YFYS4f3BBRTiTUmsrEotyo8vKs1JLT7EKM3BoiTO22R9wV9IID2xJDU7NbUgtQgmy8TBKdXA
	OME6g9em6fGqeRl/n62pVBI5ERr+vdzEndvYvFFUc91s0f8W96vi+DY9coowzNSdM6vae/7v
	ysexwfbLOfaKR+wMLOiS4nGPPpnGmZfasCcv97AxV3Wj8qplH76cmrE5IGvGho+G887m3Hty
	29iil00xqrYrYt6JGIbVgX8rLG/+Np5x8buaEktxRqKhFnNRcSIA1Ulw60gCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add Samsung S2MPS11 regulator driver.
The S2MPS11 can support 10 Bucks and 38 LDOs and RTC.
Especially, S2MPS11 is designed for high performance
Samsung application processor.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/regulator/Kconfig           |    8 +
 drivers/regulator/Makefile          |    1 +
 drivers/regulator/s2mps11.c         |  767 +++++++++++++++++++++++++++++++++++
 drivers/regulator/s5m8767.c         |    6 -
 include/linux/mfd/samsung/core.h    |   15 +
 include/linux/mfd/samsung/s2mps11.h |  179 ++++++++
 6 files changed, 970 insertions(+), 6 deletions(-)
 create mode 100644 drivers/regulator/s2mps11.c
 create mode 100644 include/linux/mfd/samsung/s2mps11.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 196aaae..afa1e11 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -241,6 +241,14 @@ config REGULATOR_RC5T583
 	  through regulator interface. The device supports multiple DCDC/LDO
 	  outputs which can be controlled by i2c communication.
 
+config REGULATOR_S2MPS11
+	tristate "Samsung S2MPS11 voltage regulator"
+	depends on MFD_SEC_CORE
+	help
+	 This driver supports a Samsung S2MPS11 voltage output regulator
+	 via I2C bus. S2MPS11 is comprised of high efficient Buck converters
+	 including Dual-Phase Buck converter, Buck-Boost converter, various LDOs.
+
 config REGULATOR_S5M8767
 	tristate "Samsung S5M8767A voltage regulator"
 	depends on MFD_SEC_CORE
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index d854453..3935514 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_REGULATOR_PALMAS) += palmas-regulator.o
 obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
 obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
 obj-$(CONFIG_REGULATOR_RC5T583)  += rc5t583-regulator.o
+obj-$(CONFIG_REGULATOR_S2MPS11) += s2mps11.o
 obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
 obj-$(CONFIG_REGULATOR_TPS6105X) += tps6105x-regulator.o
 obj-$(CONFIG_REGULATOR_TPS62360) += tps62360-regulator.o
diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
new file mode 100644
index 0000000..05cb727
--- /dev/null
+++ b/drivers/regulator/s2mps11.c
@@ -0,0 +1,767 @@
+/*
+ * s2mps11.c
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd
+ *              http://www.samsung.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/bug.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/mfd/samsung/core.h>
+#include <linux/mfd/samsung/s2mps11.h>
+
+struct s2mps11_info {
+	struct device *dev;
+	struct sec_pmic_dev *iodev;
+	int num_regulators;
+	struct regulator_dev **rdev;
+	struct sec_opmode_data *opmode;
+
+	int ramp_delay2;
+	int ramp_delay34;
+	int ramp_delay5;
+	int ramp_delay16;
+	int ramp_delay7810;
+	int ramp_delay9;
+
+	bool buck6_ramp;
+	bool buck2_ramp;
+	bool buck3_ramp;
+	bool buck4_ramp;
+};
+
+static const struct sec_voltage_desc buck_voltage_val1 = {
+	.max = 2000000,
+	.min =  600000,
+	.step =   6250,
+};
+
+static const struct sec_voltage_desc buck_voltage_val2 = {
+	.max = 3550000,
+	.min =  750000,
+	.step =  12500,
+};
+
+static const struct sec_voltage_desc buck_voltage_val3 = {
+	.max = 3775000,
+	.min = 3000000,
+	.step =  25000,
+};
+
+static const struct sec_voltage_desc ldo_voltage_val1 = {
+	.max = 3950000,
+	.min =  800000,
+	.step =  50000,
+};
+
+static const struct sec_voltage_desc ldo_voltage_val2 = {
+	.max = 2375000,
+	.min =  800000,
+	.step =  25000,
+};
+
+static const struct sec_voltage_desc *reg_voltage_map[] = {
+	[S2MPS11_LDO1] = &ldo_voltage_val2,
+	[S2MPS11_LDO2] = &ldo_voltage_val1,
+	[S2MPS11_LDO3] = &ldo_voltage_val1,
+	[S2MPS11_LDO4] = &ldo_voltage_val1,
+	[S2MPS11_LDO5] = &ldo_voltage_val1,
+	[S2MPS11_LDO6] = &ldo_voltage_val2,
+	[S2MPS11_LDO7] = &ldo_voltage_val1,
+	[S2MPS11_LDO8] = &ldo_voltage_val1,
+	[S2MPS11_LDO9] = &ldo_voltage_val1,
+	[S2MPS11_LDO10] = &ldo_voltage_val1,
+	[S2MPS11_LDO11] = &ldo_voltage_val2,
+	[S2MPS11_LDO12] = &ldo_voltage_val1,
+	[S2MPS11_LDO13] = &ldo_voltage_val1,
+	[S2MPS11_LDO14] = &ldo_voltage_val1,
+	[S2MPS11_LDO15] = &ldo_voltage_val1,
+	[S2MPS11_LDO16] = &ldo_voltage_val1,
+	[S2MPS11_LDO17] = &ldo_voltage_val1,
+	[S2MPS11_LDO18] = &ldo_voltage_val1,
+	[S2MPS11_LDO19] = &ldo_voltage_val1,
+	[S2MPS11_LDO20] = &ldo_voltage_val1,
+	[S2MPS11_LDO21] = &ldo_voltage_val1,
+	[S2MPS11_LDO22] = &ldo_voltage_val2,
+	[S2MPS11_LDO23] = &ldo_voltage_val2,
+	[S2MPS11_LDO24] = &ldo_voltage_val1,
+	[S2MPS11_LDO25] = &ldo_voltage_val1,
+	[S2MPS11_LDO26] = &ldo_voltage_val1,
+	[S2MPS11_LDO27] = &ldo_voltage_val2,
+	[S2MPS11_LDO28] = &ldo_voltage_val1,
+	[S2MPS11_LDO29] = &ldo_voltage_val1,
+	[S2MPS11_LDO30] = &ldo_voltage_val1,
+	[S2MPS11_LDO31] = &ldo_voltage_val1,
+	[S2MPS11_LDO32] = &ldo_voltage_val1,
+	[S2MPS11_LDO33] = &ldo_voltage_val1,
+	[S2MPS11_LDO34] = &ldo_voltage_val1,
+	[S2MPS11_LDO35] = &ldo_voltage_val1,
+	[S2MPS11_LDO36] = &ldo_voltage_val1,
+	[S2MPS11_LDO37] = &ldo_voltage_val1,
+	[S2MPS11_LDO38] = &ldo_voltage_val1,
+	[S2MPS11_BUCK1] = &buck_voltage_val1,
+	[S2MPS11_BUCK2] = &buck_voltage_val1,
+	[S2MPS11_BUCK3] = &buck_voltage_val1,
+	[S2MPS11_BUCK4] = &buck_voltage_val1,
+	[S2MPS11_BUCK5] = &buck_voltage_val1,
+	[S2MPS11_BUCK6] = &buck_voltage_val1,
+	[S2MPS11_BUCK7] = NULL,
+	[S2MPS11_BUCK8] = NULL,
+	[S2MPS11_BUCK9] = &buck_voltage_val3,
+	[S2MPS11_BUCK10] = &buck_voltage_val2,
+};
+
+static int s2mps11_list_voltage(struct regulator_dev *rdev,
+				unsigned int selector)
+{
+	const struct sec_voltage_desc *desc;
+	int reg_id = rdev_get_id(rdev);
+	int val;
+
+	if (reg_id >= ARRAY_SIZE(reg_voltage_map) || reg_id < 0)
+		return -EINVAL;
+
+	desc = reg_voltage_map[reg_id];
+	if (desc == NULL)
+		return -EINVAL;
+
+	val = desc->min + desc->step * selector;
+	if (val > desc->max)
+		return -EINVAL;
+
+	return val;
+}
+
+unsigned int s2mps11_opmode_reg[][3] = {
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x0, 0x0, 0x0},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x0, 0x0, 0x0},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x0, 0x0, 0x0},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x0, 0x0, 0x0},
+	{0x0, 0x0, 0x0, 0x0},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x1, 0x1},
+	{0x0, 0x3, 0x1, 0x1},
+	{0x0, 0x3, 0x1, 0x1},
+	{0x0, 0x3, 0x1, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x1, 0x1},
+	{0x0, 0x3, 0x1, 0x1},
+	{0x0, 0x3, 0x1, 0x1},
+	{0x0, 0x3, 0x1, 0x1},
+	{0x0, 0x3, 0x1, 0x1},
+	{0x0, 0x1, 0x0, 0x0},
+	{0x0, 0x1, 0x0, 0x0},
+	{0x0, 0x1, 0x0, 0x0},
+};
+
+static int s2mps11_get_register(struct regulator_dev *rdev,
+	int *reg, int *pmic_en)
+{
+	int reg_id = rdev_get_id(rdev);
+	unsigned int mode;
+	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
+
+	switch (reg_id) {
+	case S2MPS11_LDO1 ... S2MPS11_LDO38:
+		*reg = S2MPS11_REG_L1CTRL + (reg_id - S2MPS11_LDO1);
+		break;
+	case S2MPS11_BUCK1 ... S2MPS11_BUCK4:
+		*reg = S2MPS11_REG_B10CTRL1 + (reg_id - S2MPS11_BUCK1) * 2;
+		break;
+	case S2MPS11_BUCK5:
+		*reg = S2MPS11_REG_B5CTRL1;
+		break;
+	case S2MPS11_BUCK6 ... S2MPS11_BUCK8:
+		*reg = S2MPS11_REG_B6CTRL1 + (reg_id - S2MPS11_BUCK6) * 2;
+		break;
+	case S2MPS11_BUCK9 ... S2MPS11_BUCK10:
+		*reg = S2MPS11_REG_B9CTRL1 + (reg_id - S2MPS11_BUCK9) * 2;
+		break;
+	case S2MPS11_AP_EN32KHZ ... S2MPS11_BT_EN32KHZ:
+		*reg = S2MPS11_REG_CTRL1;
+		*pmic_en = 0x01 << (reg_id - S2MPS11_AP_EN32KHZ);
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	mode = s2mps11->opmode[reg_id].mode;
+	*pmic_en = s2mps11_opmode_reg[reg_id][mode] << S2MPS11_PMIC_EN_SHIFT;
+
+	return 0;
+}
+
+static int s2mps11_reg_is_enabled(struct regulator_dev *rdev)
+{
+	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
+	int reg_id = rdev_get_id(rdev);
+	int ret, reg;
+	int mask = 0xc0, pmic_en;
+	u8 val;
+
+	ret = s2mps11_get_register(rdev, &reg, &pmic_en);
+	if (ret == -EINVAL)
+		return 1;
+	else if (ret)
+		return ret;
+
+	ret = sec_reg_read(s2mps11->iodev, reg, &val);
+	if (ret)
+		return ret;
+
+	switch (reg_id) {
+	case S2MPS11_LDO1 ... S2MPS11_BUCK10:
+		mask = 0xc0;
+		break;
+	case S2MPS11_AP_EN32KHZ:
+		mask = 0x01;
+		break;
+	case S2MPS11_CP_EN32KHZ:
+		mask = 0x02;
+		break;
+	case S2MPS11_BT_EN32KHZ:
+		mask = 0x04;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return (val & mask) == pmic_en;
+}
+
+static int s2mps11_reg_enable(struct regulator_dev *rdev)
+{
+	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
+	int reg_id = rdev_get_id(rdev);
+	int ret, reg;
+	int mask, pmic_en;
+
+	ret = s2mps11_get_register(rdev, &reg, &pmic_en);
+	if (ret)
+		return ret;
+
+	switch (reg_id) {
+	case S2MPS11_LDO1 ... S2MPS11_BUCK10:
+		mask = 0xc0;
+		break;
+	case S2MPS11_AP_EN32KHZ:
+		mask = 0x01;
+		break;
+	case S2MPS11_CP_EN32KHZ:
+		mask = 0x02;
+		break;
+	case S2MPS11_BT_EN32KHZ:
+		mask = 0x04;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return sec_reg_update(s2mps11->iodev, reg, pmic_en, mask);
+}
+
+static int s2mps11_reg_disable(struct regulator_dev *rdev)
+{
+	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
+	int reg_id = rdev_get_id(rdev);
+	int ret, reg;
+	int  mask, pmic_en;
+
+	ret = s2mps11_get_register(rdev, &reg, &pmic_en);
+	if (ret)
+		return ret;
+
+	switch (reg_id) {
+	case S2MPS11_LDO1 ... S2MPS11_BUCK10:
+		mask = 0xc0;
+		break;
+	case S2MPS11_AP_EN32KHZ:
+		mask = 0x01;
+		break;
+	case S2MPS11_CP_EN32KHZ:
+		mask = 0x02;
+		break;
+	case S2MPS11_BT_EN32KHZ:
+		mask = 0x04;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return sec_reg_update(s2mps11->iodev, reg, ~mask, mask);
+}
+
+static int s2mps11_get_voltage_register(struct regulator_dev *rdev, int *_reg)
+{
+	int reg_id = rdev_get_id(rdev);
+	int reg;
+
+	switch (reg_id) {
+	case S2MPS11_LDO1 ... S2MPS11_LDO38:
+		reg = S2MPS11_REG_L1CTRL + (reg_id - S2MPS11_LDO1);
+		break;
+	case S2MPS11_BUCK1 ... S2MPS11_BUCK4:
+		reg = S2MPS11_REG_B1CTRL2 + (reg_id - S2MPS11_BUCK1) * 2;
+		break;
+	case S2MPS11_BUCK5:
+		reg = S2MPS11_REG_B5CTRL2;
+		break;
+	case S2MPS11_BUCK6 ... S2MPS11_BUCK8:
+		reg = S2MPS11_REG_B6CTRL2 + (reg_id - S2MPS11_BUCK6) * 2;
+		break;
+	case S2MPS11_BUCK9 ... S2MPS11_BUCK10:
+		reg = S2MPS11_REG_B9CTRL2 + (reg_id - S2MPS11_BUCK9) * 2;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*_reg = reg;
+
+	return 0;
+}
+
+static int s2mps11_get_voltage_sel(struct regulator_dev *rdev)
+{
+	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
+	int reg, mask = 0xff, ret;
+	int reg_id = rdev_get_id(rdev);
+	u8 val;
+
+	ret = s2mps11_get_voltage_register(rdev, &reg);
+	if (ret)
+		return ret;
+
+	switch (reg_id) {
+	case S2MPS11_BUCK1 ... S2MPS11_BUCK8:
+	case S2MPS11_BUCK10:
+		break;
+	case S2MPS11_LDO1 ... S2MPS11_LDO38:
+		mask = 0x3f;
+		break;
+	case S2MPS11_BUCK9:
+		mask = 0x1f;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = sec_reg_read(s2mps11->iodev, reg, &val);
+	if (ret)
+		return ret;
+
+	val &= mask;
+
+	return val;
+}
+
+static inline int s2mps11_convert_voltage_to_sel(
+		const struct sec_voltage_desc *desc,
+		int min_vol, int max_vol)
+{
+	int selector = 0;
+
+	if (desc == NULL)
+		return -EINVAL;
+
+	if (max_vol < desc->min || min_vol > desc->max)
+		return -EINVAL;
+
+	selector = (min_vol - desc->min) / desc->step;
+
+	if (desc->min + desc->step * selector > max_vol)
+		return -EINVAL;
+
+	return selector;
+}
+
+static int s2mps11_set_voltage(struct regulator_dev *rdev,
+				int min_uV, int max_uV, unsigned *selector)
+{
+	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
+	int min_vol = min_uV, max_vol = max_uV;
+	const struct sec_voltage_desc *desc;
+	int reg_id = rdev_get_id(rdev);
+	int sel, reg, ret, mask;
+	u8 val;
+
+	mask = (reg_id < S2MPS11_BUCK1) ? 0x3f : 0xff;
+
+	desc = reg_voltage_map[reg_id];
+
+	sel = s2mps11_convert_voltage_to_sel(desc, min_vol, max_vol);
+	if (sel < 0)
+		return sel;
+
+	ret = s2mps11_get_voltage_register(rdev, &reg);
+	if (ret)
+		return ret;
+
+	sec_reg_read(s2mps11->iodev, reg, &val);
+	val &= ~mask;
+	val |= sel;
+
+	ret = sec_reg_write(s2mps11->iodev, reg, val);
+	*selector = sel;
+
+	return ret;
+}
+
+static int s2mps11_set_voltage_time_sel(struct regulator_dev *rdev,
+					     unsigned int old_sel,
+					     unsigned int new_sel)
+{
+	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
+	const struct sec_voltage_desc *desc;
+	int reg_id = rdev_get_id(rdev);
+	int ramp_delay = 0;
+
+	switch (reg_id) {
+	case S2MPS11_BUCK1:
+	case S2MPS11_BUCK6:
+		ramp_delay = s2mps11->ramp_delay16;
+		break;
+	case S2MPS11_BUCK2:
+		ramp_delay = s2mps11->ramp_delay2;
+		break;
+	case S2MPS11_BUCK3 ... S2MPS11_BUCK4:
+		ramp_delay = s2mps11->ramp_delay34;
+		break;
+	case S2MPS11_BUCK5:
+		ramp_delay = s2mps11->ramp_delay5;
+		break;
+	case S2MPS11_BUCK7 ... S2MPS11_BUCK8:
+	case S2MPS11_BUCK10:
+		ramp_delay = s2mps11->ramp_delay7810;
+		break;
+	case S2MPS11_BUCK9:
+		ramp_delay = s2mps11->ramp_delay9;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	desc = reg_voltage_map[reg_id];
+
+	if (((old_sel < new_sel) && (reg_id > S2MPS11_LDO38)) && ramp_delay) {
+		return DIV_ROUND_UP(desc->step * (new_sel - old_sel),
+			ramp_delay * 1000);
+	}
+
+	return 0;
+}
+
+static int s2mps11_set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
+{
+	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
+	int reg, mask = 0xff, ret;
+	int reg_id = rdev_get_id(rdev);
+
+	ret = s2mps11_get_voltage_register(rdev, &reg);
+	if (ret)
+		return ret;
+
+	switch (reg_id) {
+	case S2MPS11_BUCK1 ... S2MPS11_BUCK8:
+	case S2MPS11_BUCK10:
+		break;
+	case S2MPS11_LDO1 ... S2MPS11_LDO38:
+		mask = 0x3f;
+		break;
+	case S2MPS11_BUCK9:
+		mask = 0x1f;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return sec_reg_update(s2mps11->iodev, reg, selector, mask);
+}
+
+static int get_ramp_delay(int ramp_delay)
+{
+	unsigned char cnt = 0;
+
+	ramp_delay /= 6;
+
+	while (true) {
+		ramp_delay = ramp_delay >> 1;
+		if (ramp_delay == 0)
+			break;
+		cnt++;
+	}
+	return cnt;
+}
+
+static struct regulator_ops s2mps11_ldo_ops = {
+	.list_voltage		= s2mps11_list_voltage,
+	.is_enabled		= s2mps11_reg_is_enabled,
+	.enable			= s2mps11_reg_enable,
+	.disable		= s2mps11_reg_disable,
+	.get_voltage_sel	= s2mps11_get_voltage_sel,
+	.set_voltage		= s2mps11_set_voltage,
+	.set_voltage_time_sel	= s2mps11_set_voltage_time_sel,
+};
+
+static struct regulator_ops s2mps11_buck_ops = {
+	.list_voltage		= s2mps11_list_voltage,
+	.is_enabled		= s2mps11_reg_is_enabled,
+	.enable			= s2mps11_reg_enable,
+	.disable		= s2mps11_reg_disable,
+	.get_voltage_sel	= s2mps11_get_voltage_sel,
+	.set_voltage_sel	= s2mps11_set_voltage_sel,
+	.set_voltage_time_sel	= s2mps11_set_voltage_time_sel,
+};
+
+#define regulator_desc_ldo(num)		{	\
+	.name		= "LDO"#num,		\
+	.id		= S2MPS11_LDO##num,	\
+	.ops		= &s2mps11_ldo_ops,	\
+	.type		= REGULATOR_VOLTAGE,	\
+	.owner		= THIS_MODULE,		\
+}
+#define regulator_desc_buck(num)	{	\
+	.name		= "BUCK"#num,		\
+	.id		= S2MPS11_BUCK##num,	\
+	.ops		= &s2mps11_buck_ops,	\
+	.type		= REGULATOR_VOLTAGE,	\
+	.owner		= THIS_MODULE,		\
+}
+
+static struct regulator_desc regulators[] = {
+	regulator_desc_ldo(1),
+	regulator_desc_ldo(2),
+	regulator_desc_ldo(3),
+	regulator_desc_ldo(4),
+	regulator_desc_ldo(5),
+	regulator_desc_ldo(6),
+	regulator_desc_ldo(7),
+	regulator_desc_ldo(8),
+	regulator_desc_ldo(9),
+	regulator_desc_ldo(10),
+	regulator_desc_ldo(11),
+	regulator_desc_ldo(12),
+	regulator_desc_ldo(13),
+	regulator_desc_ldo(14),
+	regulator_desc_ldo(15),
+	regulator_desc_ldo(16),
+	regulator_desc_ldo(17),
+	regulator_desc_ldo(18),
+	regulator_desc_ldo(19),
+	regulator_desc_ldo(20),
+	regulator_desc_ldo(21),
+	regulator_desc_ldo(22),
+	regulator_desc_ldo(23),
+	regulator_desc_ldo(24),
+	regulator_desc_ldo(25),
+	regulator_desc_ldo(26),
+	regulator_desc_ldo(27),
+	regulator_desc_ldo(28),
+	regulator_desc_ldo(29),
+	regulator_desc_ldo(30),
+	regulator_desc_ldo(31),
+	regulator_desc_ldo(32),
+	regulator_desc_ldo(33),
+	regulator_desc_ldo(34),
+	regulator_desc_ldo(35),
+	regulator_desc_ldo(36),
+	regulator_desc_ldo(37),
+	regulator_desc_ldo(38),
+	regulator_desc_buck(1),
+	regulator_desc_buck(2),
+	regulator_desc_buck(3),
+	regulator_desc_buck(4),
+	regulator_desc_buck(5),
+	regulator_desc_buck(6),
+	regulator_desc_buck(7),
+	regulator_desc_buck(8),
+	regulator_desc_buck(9),
+	regulator_desc_buck(10),
+};
+
+static __devinit int s2mps11_pmic_probe(struct platform_device *pdev)
+{
+	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct sec_pmic_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct regulator_config config = { };
+	struct regulator_dev **rdev;
+	struct s2mps11_info *s2mps11;
+	int i, ret, size;
+	unsigned char ramp_enable, ramp_reg = 0;
+
+	if (!pdata) {
+		dev_err(pdev->dev.parent, "Platform data not supplied\n");
+		return -ENODEV;
+	}
+
+	s2mps11 = devm_kzalloc(&pdev->dev, sizeof(struct s2mps11_info),
+				GFP_KERNEL);
+	if (!s2mps11)
+		return -ENOMEM;
+
+	size = sizeof(struct regulator_dev *) * pdata->num_regulators;
+	s2mps11->rdev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	if (!s2mps11->rdev) {
+		return -ENOMEM;
+	}
+
+	rdev = s2mps11->rdev;
+	s2mps11->dev = &pdev->dev;
+	s2mps11->iodev = iodev;
+	s2mps11->num_regulators = pdata->num_regulators;
+	platform_set_drvdata(pdev, s2mps11);
+
+	s2mps11->ramp_delay2 = pdata->buck2_ramp_delay;
+	s2mps11->ramp_delay34 = pdata->buck34_ramp_delay;
+	s2mps11->ramp_delay5 = pdata->buck5_ramp_delay;
+	s2mps11->ramp_delay16 = pdata->buck16_ramp_delay;
+	s2mps11->ramp_delay7810 = pdata->buck7810_ramp_delay;
+	s2mps11->ramp_delay9 = pdata->buck9_ramp_delay;
+
+	s2mps11->buck6_ramp = pdata->buck6_ramp_enable;
+	s2mps11->buck2_ramp = pdata->buck2_ramp_enable;
+	s2mps11->buck3_ramp = pdata->buck3_ramp_enable;
+	s2mps11->buck4_ramp = pdata->buck4_ramp_enable;
+	s2mps11->opmode = pdata->opmode;
+
+	ramp_enable = (s2mps11->buck2_ramp << 3) | (s2mps11->buck3_ramp << 2) |
+		(s2mps11->buck4_ramp << 1) | s2mps11->buck6_ramp ;
+
+	if (ramp_enable) {
+		if (s2mps11->buck2_ramp)
+			ramp_reg |= get_ramp_delay(s2mps11->ramp_delay2) >> 6;
+		if (s2mps11->buck3_ramp || s2mps11->buck4_ramp)
+			ramp_reg |= get_ramp_delay(s2mps11->ramp_delay34) >> 4;
+		sec_reg_update(s2mps11->iodev, S2MPS11_REG_RAMP,
+			ramp_reg | ramp_enable, 0xff);
+	}
+
+	ramp_reg &= 0x00;
+	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay5) >> 6;
+	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay16) >> 4;
+	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay7810) >> 2;
+	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay9);
+	sec_reg_update(s2mps11->iodev, S2MPS11_REG_RAMP_BUCK, ramp_reg, 0xff);
+
+	for (i = 0; i < pdata->num_regulators; i++) {
+		const struct sec_voltage_desc *desc;
+		int id = pdata->regulators[i].id;
+
+		desc = reg_voltage_map[id];
+		if (desc)
+			regulators[id].n_voltages =
+				(desc->max - desc->min) / desc->step + 1;
+
+		config.dev = s2mps11->dev;
+		config.init_data = pdata->regulators[i].initdata;
+		config.driver_data = s2mps11;
+
+		rdev[i] = regulator_register(&regulators[id], &config);
+		if (IS_ERR(rdev[i])) {
+			ret = PTR_ERR(rdev[i]);
+			dev_err(s2mps11->dev, "regulator init failed for %d\n",
+					id);
+			rdev[i] = NULL;
+			goto err;
+		}
+	}
+
+	return 0;
+err:
+	for (i = 0; i < s2mps11->num_regulators; i++)
+		if (rdev[i])
+			regulator_unregister(rdev[i]);
+
+	return ret;
+}
+
+static int __devexit s2mps11_pmic_remove(struct platform_device *pdev)
+{
+	struct s2mps11_info *s2mps11 = platform_get_drvdata(pdev);
+	struct regulator_dev **rdev = s2mps11->rdev;
+	int i;
+
+	for (i = 0; i < s2mps11->num_regulators; i++)
+		if (rdev[i])
+			regulator_unregister(rdev[i]);
+
+	return 0;
+}
+
+static const struct platform_device_id s2mps11_pmic_id[] = {
+	{ "s2mps11-pmic", 0},
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, s2mps11_pmic_id);
+
+static struct platform_driver s2mps11_pmic_driver = {
+	.driver = {
+		.name = "s2mps11-pmic",
+		.owner = THIS_MODULE,
+	},
+	.probe = s2mps11_pmic_probe,
+	.remove = __devexit_p(s2mps11_pmic_remove),
+	.id_table = s2mps11_pmic_id,
+};
+
+static int __init s2mps11_pmic_init(void)
+{
+	return platform_driver_register(&s2mps11_pmic_driver);
+}
+subsys_initcall(s2mps11_pmic_init);
+
+static void __exit s2mps11_pmic_exit(void)
+{
+	platform_driver_unregister(&s2mps11_pmic_driver);
+}
+module_exit(s2mps11_pmic_exit);
+
+/* Module information */
+MODULE_AUTHOR("Sangbeom Kim <sbkim73@samsung.com>");
+MODULE_DESCRIPTION("SAMSUNG S2MPS11 Regulator Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index b98cad1..5c40b2e 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -45,12 +45,6 @@ struct s5m8767_info {
 	int buck_gpioindex;
 };
 
-struct sec_voltage_desc {
-	int max;
-	int min;
-	int step;
-};
-
 static const struct sec_voltage_desc buck_voltage_val1 = {
 	.max = 2225000,
 	.min =  650000,
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index be6277a..d888f66 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -20,6 +20,7 @@ enum sec_device_type {
 	S5M8751X,
 	S5M8763X,
 	S5M8767X,
+	S2MPS11X,
 };
 
 /**
@@ -98,9 +99,17 @@ struct sec_pmic_platform_data {
 	int				buck4_default_idx;
 
 	int                             buck_ramp_delay;
+
+	int				buck2_ramp_delay;
+	int				buck34_ramp_delay;
+	int				buck5_ramp_delay;
+	int				buck16_ramp_delay;
+	int				buck7810_ramp_delay;
+	int				buck9_ramp_delay;
 	bool                            buck2_ramp_enable;
 	bool                            buck3_ramp_enable;
 	bool                            buck4_ramp_enable;
+	bool				buck6_ramp_enable;
 
 	int				buck2_init;
 	int				buck3_init;
@@ -144,4 +153,10 @@ enum sec_opmode {
 	SEC_OPMODE_SUSPEND,
 };
 
+struct sec_voltage_desc {
+	int max;
+	int min;
+	int step;
+};
+
 #endif /*  __LINUX_MFD_SEC_CORE_H */
diff --git a/include/linux/mfd/samsung/s2mps11.h b/include/linux/mfd/samsung/s2mps11.h
new file mode 100644
index 0000000..44027e9
--- /dev/null
+++ b/include/linux/mfd/samsung/s2mps11.h
@@ -0,0 +1,179 @@
+/*
+ * s2mps11.h
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd
+ *              http://www.samsung.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __LINUX_MFD_S2MPS11_H
+#define __LINUX_MFD_S2MPS11_H
+
+/* S2MPS11 registers */
+enum s2mps11_reg {
+	S2MPS11_REG_ID,
+	S2MPS11_REG_INT1,
+	S2MPS11_REG_INT2,
+	S2MPS11_REG_INT3,
+	S2MPS11_REG_INT1M,
+	S2MPS11_REG_INT2M,
+	S2MPS11_REG_INT3M,
+	S2MPS11_REG_ST1,
+	S2MPS11_REG_ST2,
+	S2MPS11_REG_OFFSRC,
+	S2MPS11_REG_PWRONSRC,
+	S2MPS11_REG_RTC_CTRL,
+	S2MPS11_REG_CTRL1,
+	S2MPS11_REG_ETC_TEST,
+	S2MPS11_REG_RSVD3,
+	S2MPS11_REG_BU_CHG,
+	S2MPS11_REG_RAMP,
+	S2MPS11_REG_RAMP_BUCK,
+	S2MPS11_REG_LDO1_8,
+	S2MPS11_REG_LDO9_16,
+	S2MPS11_REG_LDO17_24,
+	S2MPS11_REG_LDO25_32,
+	S2MPS11_REG_LDO33_38,
+	S2MPS11_REG_LDO1_8_1,
+	S2MPS11_REG_LDO9_16_1,
+	S2MPS11_REG_LDO17_24_1,
+	S2MPS11_REG_LDO25_32_1,
+	S2MPS11_REG_LDO33_38_1,
+	S2MPS11_REG_OTP_ADRL,
+	S2MPS11_REG_OTP_ADRH,
+	S2MPS11_REG_OTP_DATA,
+	S2MPS11_REG_MON1SEL,
+	S2MPS11_REG_MON2SEL,
+	S2MPS11_REG_LEE,
+	S2MPS11_REG_RSVD_NO,
+	S2MPS11_REG_UVLO,
+	S2MPS11_REG_LEE_NO,
+	S2MPS11_REG_B1CTRL1,
+	S2MPS11_REG_B1CTRL2,
+	S2MPS11_REG_B2CTRL1,
+	S2MPS11_REG_B2CTRL2,
+	S2MPS11_REG_B3CTRL1,
+	S2MPS11_REG_B3CTRL2,
+	S2MPS11_REG_B4CTRL1,
+	S2MPS11_REG_B4CTRL2,
+	S2MPS11_REG_B5CTRL1,
+	S2MPS11_REG_BUCK5_SW,
+	S2MPS11_REG_B5CTRL2,
+	S2MPS11_REG_B5CTRL3,
+	S2MPS11_REG_B5CTRL4,
+	S2MPS11_REG_B5CTRL5,
+	S2MPS11_REG_B6CTRL1,
+	S2MPS11_REG_B6CTRL2,
+	S2MPS11_REG_B7CTRL1,
+	S2MPS11_REG_B7CTRL2,
+	S2MPS11_REG_B8CTRL1,
+	S2MPS11_REG_B8CTRL2,
+	S2MPS11_REG_B9CTRL1,
+	S2MPS11_REG_B9CTRL2,
+	S2MPS11_REG_B10CTRL1,
+	S2MPS11_REG_B10CTRL2,
+	S2MPS11_REG_L1CTRL,
+	S2MPS11_REG_L2CTRL,
+	S2MPS11_REG_L3CTRL,
+	S2MPS11_REG_L4CTRL,
+	S2MPS11_REG_L5CTRL,
+	S2MPS11_REG_L6CTRL,
+	S2MPS11_REG_L7CTRL,
+	S2MPS11_REG_L8CTRL,
+	S2MPS11_REG_L9CTRL,
+	S2MPS11_REG_L10CTRL,
+	S2MPS11_REG_L11CTRL,
+	S2MPS11_REG_L12CTRL,
+	S2MPS11_REG_L13CTRL,
+	S2MPS11_REG_L14CTRL,
+	S2MPS11_REG_L15CTRL,
+	S2MPS11_REG_L16CTRL,
+	S2MPS11_REG_L17CTRL,
+	S2MPS11_REG_L18CTRL,
+	S2MPS11_REG_L19CTRL,
+	S2MPS11_REG_L20CTRL,
+	S2MPS11_REG_L21CTRL,
+	S2MPS11_REG_L22CTRL,
+	S2MPS11_REG_L23CTRL,
+	S2MPS11_REG_L24CTRL,
+	S2MPS11_REG_L25CTRL,
+	S2MPS11_REG_L26CTRL,
+	S2MPS11_REG_L27CTRL,
+	S2MPS11_REG_L28CTRL,
+	S2MPS11_REG_L29CTRL,
+	S2MPS11_REG_L30CTRL,
+	S2MPS11_REG_L31CTRL,
+	S2MPS11_REG_L32CTRL,
+	S2MPS11_REG_L33CTRL,
+	S2MPS11_REG_L34CTRL,
+	S2MPS11_REG_L35CTRL,
+	S2MPS11_REG_L36CTRL,
+	S2MPS11_REG_L37CTRL,
+	S2MPS11_REG_L38CTRL,
+};
+
+/* S2MPS11 regulator ids */
+enum s2mps11_regulators {
+	S2MPS11_LDO1,
+	S2MPS11_LDO2,
+	S2MPS11_LDO3,
+	S2MPS11_LDO4,
+	S2MPS11_LDO5,
+	S2MPS11_LDO6,
+	S2MPS11_LDO7,
+	S2MPS11_LDO8,
+	S2MPS11_LDO9,
+	S2MPS11_LDO10,
+	S2MPS11_LDO11,
+	S2MPS11_LDO12,
+	S2MPS11_LDO13,
+	S2MPS11_LDO14,
+	S2MPS11_LDO15,
+	S2MPS11_LDO16,
+	S2MPS11_LDO17,
+	S2MPS11_LDO18,
+	S2MPS11_LDO19,
+	S2MPS11_LDO20,
+	S2MPS11_LDO21,
+	S2MPS11_LDO22,
+	S2MPS11_LDO23,
+	S2MPS11_LDO24,
+	S2MPS11_LDO25,
+	S2MPS11_LDO26,
+	S2MPS11_LDO27,
+	S2MPS11_LDO28,
+	S2MPS11_LDO29,
+	S2MPS11_LDO30,
+	S2MPS11_LDO31,
+	S2MPS11_LDO32,
+	S2MPS11_LDO33,
+	S2MPS11_LDO34,
+	S2MPS11_LDO35,
+	S2MPS11_LDO36,
+	S2MPS11_LDO37,
+	S2MPS11_LDO38,
+	S2MPS11_BUCK1,
+	S2MPS11_BUCK2,
+	S2MPS11_BUCK3,
+	S2MPS11_BUCK4,
+	S2MPS11_BUCK5,
+	S2MPS11_BUCK6,
+	S2MPS11_BUCK7,
+	S2MPS11_BUCK8,
+	S2MPS11_BUCK9,
+	S2MPS11_BUCK10,
+	S2MPS11_AP_EN32KHZ,
+	S2MPS11_CP_EN32KHZ,
+	S2MPS11_BT_EN32KHZ,
+
+	S2MPS11_REG_MAX,
+};
+
+#define S2MPS11_PMIC_EN_SHIFT	6
+
+#endif /*  __LINUX_MFD_S2MPS11_H */
-- 
1.7.1


