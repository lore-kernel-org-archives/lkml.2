Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab1JXPSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 11:18:41 -0400
Received: from [213.95.27.120] ([213.95.27.120]:39617 "EHLO
	ganesha.gnumonks.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932869Ab1JXPQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 11:16:53 -0400
From: Sangbeom Kim <sbkim73@samsung.com>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        Sangbeom Kim <sbkim73@samsung.com>
Subject: [PATCH 1/3] mfd: Add S5M core driver
Date: Fri, 21 Oct 2011 19:28:12 +0900
Message-Id: <1319192894-19292-2-git-send-email-sbkim73@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1319192894-19292-1-git-send-email-sbkim73@samsung.com>
References: <1319192894-19292-1-git-send-email-sbkim73@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S5M series are pmic including mutiple functions.
It can support PMIC, RTC, Battery charger, codec.
This patch implement core driver for s5m series.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/mfd/s5m-core.c               |  235 +++++++++++++++++++++++++
 include/linux/mfd/s5m87xx/s5m-core.h |  313 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/s5m87xx/s5m-pmic.h |  141 +++++++++++++++
 include/linux/mfd/s5m87xx/s5m-rtc.h  |   69 ++++++++
 4 files changed, 758 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/s5m-core.c
 create mode 100644 include/linux/mfd/s5m87xx/s5m-core.h
 create mode 100644 include/linux/mfd/s5m87xx/s5m-pmic.h
 create mode 100644 include/linux/mfd/s5m87xx/s5m-rtc.h

diff --git a/drivers/mfd/s5m-core.c b/drivers/mfd/s5m-core.c
new file mode 100644
index 0000000..6dac3a1
--- /dev/null
+++ b/drivers/mfd/s5m-core.c
@@ -0,0 +1,235 @@
+/*
+ * s5m-core.c
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
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
+#include <linux/mutex.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/s5m87xx/s5m-core.h>
+#include <linux/mfd/s5m87xx/s5m-pmic.h>
+#include <linux/mfd/s5m87xx/s5m-rtc.h>
+#include <linux/regmap.h>
+
+int s5m_reg_read(struct s5m87xx_dev *s5m87xx, u8 reg, u8 *dest)
+{
+	int ret;
+	unsigned int val;
+
+	ret = regmap_read(s5m87xx->regmap, reg, &val);
+
+	if (ret < 0)
+		return ret;
+
+	ret &= 0xff;
+	*dest = ret;
+	return 0;
+}
+EXPORT_SYMBOL(s5m_reg_read);
+
+int s5m_bulk_read(struct s5m87xx_dev *s5m87xx, u8 reg, int count, u8 *buf)
+{
+	int ret;
+
+	ret = regmap_bulk_read(s5m87xx->regmap, reg, buf, count);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL(s5m_bulk_read);
+
+int s5m_reg_write(struct s5m87xx_dev *s5m87xx, u8 reg, u8 value)
+{
+	int ret;
+
+	ret = regmap_write(s5m87xx->regmap, reg, value);
+	return ret;
+}
+EXPORT_SYMBOL(s5m_reg_write);
+
+int s5m_bulk_write(struct s5m87xx_dev *s5m87xx, u8 reg, int count, u8 *buf)
+{
+	int ret;
+
+	ret = regmap_raw_write(s5m87xx->regmap, reg, buf, count * sizeof(u16));
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL(s5m_bulk_write);
+
+int s5m_reg_update(struct s5m87xx_dev *s5m87xx, u8 reg, u8 val, u8 mask)
+{
+	int ret;
+
+	ret = regmap_update_bits(s5m87xx->regmap, reg, mask, val);
+	if (ret < 0)
+		return ret;
+
+	return ret;
+}
+EXPORT_SYMBOL(s5m_reg_update);
+
+static struct mfd_cell s5m87xx_devs[] = {
+	{
+		.name = "s5m8763-pmic",
+	}, {
+		.name = "s5m8767-pmic",
+	}, {
+		.name = "s5m-rtc",
+	}, {
+		.name = "s5m8763-charger",
+	},
+};
+
+static struct regmap_config s5m_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static int s5m_i2c_probe(struct i2c_client *i2c,
+			    const struct i2c_device_id *id)
+{
+	struct s5m87xx_platform_data *pdata = i2c->dev.platform_data;
+	struct s5m87xx_dev *s5m87xx;
+	int ret = 0;
+	int error;
+
+	s5m87xx = kzalloc(sizeof(struct s5m87xx_dev), GFP_KERNEL);
+	if (s5m87xx == NULL)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, s5m87xx);
+	s5m87xx->dev = &i2c->dev;
+	s5m87xx->i2c = i2c;
+	s5m87xx->irq = i2c->irq;
+	s5m87xx->type = id->driver_data;
+
+	if (pdata) {
+		s5m87xx->device_type = pdata->device_type;
+		s5m87xx->ono = pdata->ono;
+		s5m87xx->irq_base = pdata->irq_base;
+		s5m87xx->wakeup = pdata->wakeup;
+	}
+
+	s5m87xx->regmap = regmap_init_i2c(i2c, &s5m_regmap_config);
+        if (IS_ERR(s5m87xx->regmap)) {
+                error = PTR_ERR(s5m87xx->regmap);
+                dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
+                        error);
+                goto err;
+        }
+
+	s5m87xx->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
+	i2c_set_clientdata(s5m87xx->rtc, s5m87xx);
+
+	s5m_irq_init(s5m87xx);
+
+	pm_runtime_set_active(s5m87xx->dev);
+
+	ret = mfd_add_devices(s5m87xx->dev, -1,
+				s5m87xx_devs, ARRAY_SIZE(s5m87xx_devs),
+				NULL, 0);
+	if (ret < 0)
+		goto err;
+
+	dev_info(s5m87xx->dev ,"SAMSUNG S5M MFD\n");
+	return ret;
+
+err:
+	mfd_remove_devices(s5m87xx->dev);
+	s5m_irq_exit(s5m87xx);
+	i2c_unregister_device(s5m87xx->rtc);
+	regmap_exit(s5m87xx->regmap);
+	kfree(s5m87xx);
+	return ret;
+}
+
+static int s5m_i2c_remove(struct i2c_client *i2c)
+{
+	struct s5m87xx_dev *s5m87xx = i2c_get_clientdata(i2c);
+
+	mfd_remove_devices(s5m87xx->dev);
+	s5m_irq_exit(s5m87xx);
+	i2c_unregister_device(s5m87xx->rtc);
+	regmap_exit(s5m87xx->regmap);
+	kfree(s5m87xx);
+
+	return 0;
+}
+
+static const struct i2c_device_id s5m87xx_i2c_id[] = {
+	{ "s5m87xx", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, s5m87xx_i2c_id);
+
+static int s5m_suspend(struct i2c_client *i2c, pm_message_t state)
+{
+	struct s5m87xx_dev *s5m87xx = i2c_get_clientdata(i2c);
+
+	if (s5m87xx->wakeup)
+		enable_irq_wake(s5m87xx->irq);
+
+	disable_irq(s5m87xx->irq);
+
+	return 0;
+}
+
+static int s5m_resume(struct i2c_client *i2c)
+{
+	struct s5m87xx_dev *s5m87xx = i2c_get_clientdata(i2c);
+
+	if (s5m87xx->wakeup)
+		disable_irq_wake(s5m87xx->irq);
+
+	enable_irq(s5m87xx->irq);
+
+	return 0;
+}
+
+static struct i2c_driver s5m87xx_i2c_driver = {
+	.driver = {
+		   .name = "s5m87xx",
+		   .owner = THIS_MODULE,
+	},
+	.probe = s5m_i2c_probe,
+	.remove = s5m_i2c_remove,
+	.id_table = s5m87xx_i2c_id,
+	.suspend = s5m_suspend,
+	.resume = s5m_resume,
+};
+
+static int __init s5m87xx_i2c_init(void)
+{
+	return i2c_add_driver(&s5m87xx_i2c_driver);
+}
+
+subsys_initcall(s5m87xx_i2c_init);
+
+static void __exit s5m87xx_i2c_exit(void)
+{
+	i2c_del_driver(&s5m87xx_i2c_driver);
+}
+module_exit(s5m87xx_i2c_exit);
+
+MODULE_AUTHOR("Sangbeom Kim <sbkim73@samsung.com>");
+MODULE_DESCRIPTION("Core support for the S5M87XX MFD");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/s5m87xx/s5m-core.h b/include/linux/mfd/s5m87xx/s5m-core.h
new file mode 100644
index 0000000..ddacd5b
--- /dev/null
+++ b/include/linux/mfd/s5m87xx/s5m-core.h
@@ -0,0 +1,313 @@
+/*
+ * s5m-core.h
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
+#ifndef __LINUX_MFD_S5M_CORE_H
+#define __LINUX_MFD_S5M_CORE_H
+
+#define NUM_IRQ_REGS	4
+
+enum s5m_device_type {
+	S5M8751X,
+	S5M8763X,
+	S5M8767X,
+};
+
+/* S5M8767 registers */
+enum s5m8767_reg {
+	S5M8767_REG_ID,
+	S5M8767_REG_INT1,
+	S5M8767_REG_INT2,
+	S5M8767_REG_INT3,
+	S5M8767_REG_INT1M,
+	S5M8767_REG_INT2M,
+	S5M8767_REG_INT3M,
+	S5M8767_REG_STATUS1,
+	S5M8767_REG_STATUS2,
+	S5M8767_REG_STATUS3,
+	S5M8767_REG_CTRL1,
+	S5M8767_REG_CTRL2,
+	S5M8767_REG_LOWBAT1,
+	S5M8767_REG_LOWBAT2,
+	S5M8767_REG_BUCHG,
+	S5M8767_REG_DVSRAMP,
+	S5M8767_REG_DVSTIMER1,
+	S5M8767_REG_DVSTIMER2,
+	S5M8767_REG_DVSTIMER3,
+	S5M8767_REG_DVSTIMER4,
+	S5M8767_REG_LDO1,
+	S5M8767_REG_LDO2,
+	S5M8767_REG_LDO3,
+	S5M8767_REG_LDO4,
+	S5M8767_REG_LDO5,
+	S5M8767_REG_LDO6,
+	S5M8767_REG_LDO7,
+	S5M8767_REG_LDO8,
+	S5M8767_REG_LDO9,
+	S5M8767_REG_LDO10,
+	S5M8767_REG_LDO11,
+	S5M8767_REG_LDO12,
+	S5M8767_REG_LDO13,
+	S5M8767_REG_LDO14,
+	S5M8767_REG_LDO15,
+	S5M8767_REG_LDO16,
+	S5M8767_REG_LDO17,
+	S5M8767_REG_LDO18,
+	S5M8767_REG_LDO19,
+	S5M8767_REG_LDO20,
+	S5M8767_REG_LDO21,
+	S5M8767_REG_LDO22,
+	S5M8767_REG_LDO23,
+	S5M8767_REG_LDO24,
+	S5M8767_REG_LDO25,
+	S5M8767_REG_LDO26,
+	S5M8767_REG_LDO27,
+	S5M8767_REG_BUCK1CTRL1 = 0x35,
+	S5M8767_REG_BUCK1CTRL2,
+	S5M8767_REG_BUCK2CTRL,
+	S5M8767_REG_BUCK2DVS1,
+	S5M8767_REG_BUCK2DVS2,
+	S5M8767_REG_BUCK2DVS3,
+	S5M8767_REG_BUCK2DVS4,
+	S5M8767_REG_BUCK2DVS5,
+	S5M8767_REG_BUCK2DVS6,
+	S5M8767_REG_BUCK2DVS7,
+	S5M8767_REG_BUCK2DVS8,
+	S5M8767_REG_BUCK3CTRL,
+	S5M8767_REG_BUCK3DVS1,
+	S5M8767_REG_BUCK3DVS2,
+	S5M8767_REG_BUCK3DVS3,
+	S5M8767_REG_BUCK3DVS4,
+	S5M8767_REG_BUCK3DVS5,
+	S5M8767_REG_BUCK3DVS6,
+	S5M8767_REG_BUCK3DVS7,
+	S5M8767_REG_BUCK3DVS8,
+	S5M8767_REG_BUCK4CTRL,
+	S5M8767_REG_BUCK4DVS1,
+	S5M8767_REG_BUCK4DVS2,
+	S5M8767_REG_BUCK4DVS3,
+	S5M8767_REG_BUCK4DVS4,
+	S5M8767_REG_BUCK4DVS5,
+	S5M8767_REG_BUCK4DVS6,
+	S5M8767_REG_BUCK4DVS7,
+	S5M8767_REG_BUCK4DVS8,
+	S5M8767_REG_BUCK5CTRL1,
+	S5M8767_REG_BUCK5CTRL2,
+	S5M8767_REG_BUCK6CTRL1,
+	S5M8767_REG_BUCK6CTRL2,
+	S5M8767_REG_BUCK7CTRL1,
+	S5M8767_REG_BUCK7CTRL2,
+	S5M8767_REG_BUCK8CTRL1,
+	S5M8767_REG_BUCK8CTRL2,
+	S5M8767_REG_LDO1CTRL,
+	S5M8767_REG_LDO2CTRL,
+	S5M8767_REG_LDO3CTRL,
+	S5M8767_REG_LDO4CTRL,
+	S5M8767_REG_LDO5CTRL,
+	S5M8767_REG_LDO6CTRL,
+	S5M8767_REG_LDO7CTRL,
+	S5M8767_REG_LDO8CTRL,
+	S5M8767_REG_LDO9CTRL,
+	S5M8767_REG_LDO10CTRL,
+	S5M8767_REG_LDO11CTRL,
+	S5M8767_REG_LDO12CTRL,
+	S5M8767_REG_LDO13CTRL,
+	S5M8767_REG_LDO14CTRL,
+	S5M8767_REG_LDO15CTRL,
+	S5M8767_REG_LDO16CTRL,
+	S5M8767_REG_LDO17CTRL,
+	S5M8767_REG_LDO18CTRL,
+	S5M8767_REG_LDO19CTRL,
+	S5M8767_REG_LDO20CTRL,
+	S5M8767_REG_LDO21CTRL,
+	S5M8767_REG_LDO22CTRL,
+	S5M8767_REG_LDO23CTRL,
+	S5M8767_REG_LDO24CTRL,
+	S5M8767_REG_LDO25CTRL,
+	S5M8767_REG_LDO26CTRL,
+	S5M8767_REG_LDO27CTRL,
+};
+
+/* S5M8763 registers */
+enum s5m8763_reg {
+	S5M8763_REG_IRQ1,
+	S5M8763_REG_IRQ2,
+	S5M8763_REG_IRQ3,
+	S5M8763_REG_IRQ4,
+	S5M8763_REG_IRQM1,
+	S5M8763_REG_IRQM2,
+	S5M8763_REG_IRQM3,
+	S5M8763_REG_IRQM4,
+	S5M8763_REG_STATUS1,
+	S5M8763_REG_STATUS2,
+	S5M8763_REG_STATUSM1,
+	S5M8763_REG_STATUSM2,
+	S5M8763_REG_CHGR1,
+	S5M8763_REG_CHGR2,
+	S5M8763_REG_LDO_ACTIVE_DISCHARGE1,
+	S5M8763_REG_LDO_ACTIVE_DISCHARGE2,
+	S5M8763_REG_BUCK_ACTIVE_DISCHARGE3,
+	S5M8763_REG_ONOFF1,
+	S5M8763_REG_ONOFF2,
+	S5M8763_REG_ONOFF3,
+	S5M8763_REG_ONOFF4,
+	S5M8763_REG_BUCK1_VOLTAGE1,
+	S5M8763_REG_BUCK1_VOLTAGE2,
+	S5M8763_REG_BUCK1_VOLTAGE3,
+	S5M8763_REG_BUCK1_VOLTAGE4,
+	S5M8763_REG_BUCK2_VOLTAGE1,
+	S5M8763_REG_BUCK2_VOLTAGE2,
+	S5M8763_REG_BUCK3,
+	S5M8763_REG_BUCK4,
+	S5M8763_REG_LDO1_LDO2,
+	S5M8763_REG_LDO3,
+	S5M8763_REG_LDO4,
+	S5M8763_REG_LDO5,
+	S5M8763_REG_LDO6,
+	S5M8763_REG_LDO7,
+	S5M8763_REG_LDO7_LDO8,
+	S5M8763_REG_LDO9_LDO10,
+	S5M8763_REG_LDO11,
+	S5M8763_REG_LDO12,
+	S5M8763_REG_LDO13,
+	S5M8763_REG_LDO14,
+	S5M8763_REG_LDO15,
+	S5M8763_REG_LDO16,
+	S5M8763_REG_BKCHR,
+	S5M8763_REG_LBCNFG1,
+	S5M8763_REG_LBCNFG2,
+};
+
+enum s5m8767_irq {
+	S5M8767_IRQ_PWRR,
+	S5M8767_IRQ_PWRF,
+	S5M8767_IRQ_PWR1S,
+	S5M8767_IRQ_JIGR,
+	S5M8767_IRQ_JIGF,
+	S5M8767_IRQ_LOWBAT2,
+	S5M8767_IRQ_LOWBAT1,
+
+	S5M8767_IRQ_MRB,
+	S5M8767_IRQ_DVSOK2,
+	S5M8767_IRQ_DVSOK3,
+	S5M8767_IRQ_DVSOK4,
+
+	S5M8767_IRQ_RTC60S,
+	S5M8767_IRQ_RTCA1,
+	S5M8767_IRQ_RTCA2,
+	S5M8767_IRQ_SMPL,
+	S5M8767_IRQ_RTC1S,
+	S5M8767_IRQ_WTSR,
+
+	S5M8767_IRQ_NR,
+};
+
+#define S5M8767_IRQ_PWRR_MASK		(1 << 0)
+#define S5M8767_IRQ_PWRF_MASK		(1 << 1)
+#define S5M8767_IRQ_PWR1S_MASK		(1 << 3)
+#define S5M8767_IRQ_JIGR_MASK		(1 << 4)
+#define S5M8767_IRQ_JIGF_MASK		(1 << 5)
+#define S5M8767_IRQ_LOWBAT2_MASK	(1 << 6)
+#define S5M8767_IRQ_LOWBAT1_MASK	(1 << 7)
+
+#define S5M8767_IRQ_MRB_MASK		(1 << 2)
+#define S5M8767_IRQ_DVSOK2_MASK		(1 << 3)
+#define S5M8767_IRQ_DVSOK3_MASK		(1 << 4)
+#define S5M8767_IRQ_DVSOK4_MASK		(1 << 5)
+
+#define S5M8767_IRQ_RTC60S_MASK		(1 << 0)
+#define S5M8767_IRQ_RTCA1_MASK		(1 << 1)
+#define S5M8767_IRQ_RTCA2_MASK		(1 << 2)
+#define S5M8767_IRQ_SMPL_MASK		(1 << 3)
+#define S5M8767_IRQ_RTC1S_MASK		(1 << 4)
+#define S5M8767_IRQ_WTSR_MASK		(1 << 5)
+
+enum s5m8763_irq {
+	S5M8763_IRQ_VDCINF,
+	S5M8763_IRQ_VDCINR,
+	S5M8763_IRQ_JIGF,
+	S5M8763_IRQ_JIGR,
+	S5M8763_IRQ_PWRONF,
+	S5M8763_IRQ_PWRONR,
+
+	S5M8763_IRQ_WTSREVNT,
+	S5M8763_IRQ_SMPLEVNT,
+	S5M8763_IRQ_ALARM1,
+	S5M8763_IRQ_ALARM0,
+
+	S5M8763_IRQ_ONKEY1S,
+	S5M8763_IRQ_TOPOFFR,
+	S5M8763_IRQ_VDCINOVPR,
+	S5M8763_IRQ_CHGRSTF,
+	S5M8763_IRQ_DONER,
+	S5M8763_IRQ_CHGFAULT,
+
+	S5M8763_IRQ_LOBAT1,
+	S5M8763_IRQ_LOBAT2,
+
+	S5M8763_IRQ_NR,
+};
+
+#define S5M8763_IRQ_VDCINF_MASK		(1 << 2)
+#define S5M8763_IRQ_VDCINR_MASK		(1 << 3)
+#define S5M8763_IRQ_JIGF_MASK		(1 << 4)
+#define S5M8763_IRQ_JIGR_MASK		(1 << 5)
+#define S5M8763_IRQ_PWRONF_MASK		(1 << 6)
+#define S5M8763_IRQ_PWRONR_MASK		(1 << 7)
+
+#define S5M8763_IRQ_WTSREVNT_MASK	(1 << 0)
+#define S5M8763_IRQ_SMPLEVNT_MASK	(1 << 1)
+#define S5M8763_IRQ_ALARM1_MASK		(1 << 2)
+#define S5M8763_IRQ_ALARM0_MASK		(1 << 3)
+
+#define S5M8763_IRQ_ONKEY1S_MASK	(1 << 0)
+#define S5M8763_IRQ_TOPOFFR_MASK	(1 << 2)
+#define S5M8763_IRQ_VDCINOVPR_MASK	(1 << 3)
+#define S5M8763_IRQ_CHGRSTF_MASK	(1 << 4)
+#define S5M8763_IRQ_DONER_MASK		(1 << 5)
+#define S5M8763_IRQ_CHGFAULT_MASK	(1 << 7)
+
+#define S5M8763_IRQ_LOBAT1_MASK		(1 << 0)
+#define S5M8763_IRQ_LOBAT2_MASK		(1 << 1)
+
+#define S5M8763_ENRAMP                  (1 << 4)
+
+struct s5m87xx_dev {
+	struct device *dev;
+	struct i2c_client *i2c;
+	struct i2c_client *rtc;
+	struct mutex irqlock;
+	struct mutex iolock;
+
+	int device_type;
+	int irq_base;
+	int irq;
+	int ono;
+	u8 irq_masks_cur[NUM_IRQ_REGS];
+	u8 irq_masks_cache[NUM_IRQ_REGS];
+	int type;
+	bool wakeup;
+
+	struct regmap *regmap;
+};
+
+int s5m_irq_init(struct s5m87xx_dev *s5m87xx);
+void s5m_irq_exit(struct s5m87xx_dev *s5m87xx);
+int s5m_irq_resume(struct s5m87xx_dev *s5m87xx);
+
+extern int s5m_reg_read(struct s5m87xx_dev *s5m87xx, u8 reg, u8 *dest);
+extern int s5m_bulk_read(struct s5m87xx_dev *s5m87xx, u8 reg, int count,u8 *buf);
+extern int s5m_reg_write(struct s5m87xx_dev *s5m87xx, u8 reg, u8 value);
+extern int s5m_bulk_write(struct s5m87xx_dev *s5m87xx, u8 reg, int count,u8 *buf);
+extern int s5m_reg_update(struct s5m87xx_dev *s5m87xx, u8 reg, u8 val, u8 mask);
+
+#endif /*  __LINUX_MFD_S5M_CORE_H */
diff --git a/include/linux/mfd/s5m87xx/s5m-pmic.h b/include/linux/mfd/s5m87xx/s5m-pmic.h
new file mode 100644
index 0000000..2bb57b3
--- /dev/null
+++ b/include/linux/mfd/s5m87xx/s5m-pmic.h
@@ -0,0 +1,141 @@
+/*
+ * s5m-pmic.h
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
+#ifndef __LINUX_MFD_S5M_PMIC_H
+#define __LINUX_MFD_S5M_PMIC_H
+
+#include <linux/regulator/machine.h>
+
+/* S5M8767 regulator ids */
+enum s5m8767_regulators {
+	S5M8767_LDO1,
+	S5M8767_LDO2,
+	S5M8767_LDO3,
+	S5M8767_LDO4,
+	S5M8767_LDO5,
+	S5M8767_LDO6,
+	S5M8767_LDO7,
+	S5M8767_LDO8,
+	S5M8767_LDO9,
+	S5M8767_LDO10,
+	S5M8767_LDO11,
+	S5M8767_LDO12,
+	S5M8767_LDO13,
+	S5M8767_LDO14,
+	S5M8767_LDO15,
+	S5M8767_LDO16,
+	S5M8767_LDO17,
+	S5M8767_LDO18,
+	S5M8767_LDO19,
+	S5M8767_LDO20,
+	S5M8767_LDO21,
+	S5M8767_LDO22,
+	S5M8767_LDO23,
+	S5M8767_LDO24,
+	S5M8767_LDO25,
+	S5M8767_LDO26,
+	S5M8767_LDO27,
+	S5M8767_BUCK1,
+	S5M8767_BUCK2,
+	S5M8767_BUCK3,
+	S5M8767_BUCK4,
+	S5M8767_BUCK5,
+	S5M8767_BUCK6,
+	S5M8767_BUCK7,
+	S5M8767_BUCK8,
+	S5M8767_32KHZAP_EN,
+	S5M8767_32KHZCP_EN,
+
+	S5M8767_REG_MAX,
+};
+
+/* S5M8763 regulator ids */
+enum s5m8763_regulators {
+	S5M8763_LDO1,
+	S5M8763_LDO2,
+	S5M8763_LDO3,
+	S5M8763_LDO4,
+	S5M8763_LDO5,
+	S5M8763_LDO6,
+	S5M8763_LDO7,
+	S5M8763_LDO8,
+	S5M8763_LDO9,
+	S5M8763_LDO10,
+	S5M8763_LDO11,
+	S5M8763_LDO12,
+	S5M8763_LDO13,
+	S5M8763_LDO14,
+	S5M8763_LDO15,
+	S5M8763_LDO16,
+	S5M8763_BUCK1,
+	S5M8763_BUCK2,
+	S5M8763_BUCK3,
+	S5M8763_BUCK4,
+	S5M8763_AP_EN32KHZ,
+	S5M8763_CP_EN32KHZ,
+	S5M8763_ENCHGVI,
+	S5M8763_ESAFEUSB1,
+	S5M8763_ESAFEUSB2,
+};
+
+/**
+ * s5m87xx_regulator_data - regulator data
+ * @id: regulator id
+ * @initdata: regulator init data (contraints, supplies, ...)
+ */
+struct s5m87xx_regulator_data {
+	int				id;
+	struct regulator_init_data	*initdata;
+};
+
+struct s5m87xx_platform_data {
+	struct s5m87xx_regulator_data	*regulators;
+	int				device_type;
+	int				num_regulators;
+	int				irq_base;
+	int				ono;
+	bool				wakeup;
+	bool				buck_voltage_lock;
+
+	int				buck_gpios[3];
+	int				buck_default_idx;
+	int				buck1_voltage[4];
+	int				buck2_voltage[8];
+	bool				buck2_gpiodvs;
+	int				buck3_voltage[8];
+	bool				buck3_gpiodvs;
+	int				buck4_voltage[8];
+	bool				buck4_gpiodvs;
+
+	int				buck1_set1;
+	int				buck1_set2;
+	int				buck2_set3;
+	int				buck_set1;
+	int				buck_set2;
+	int				buck_set3;
+	int				buck2_enable;
+	int				buck3_enable;
+	int				buck4_enable;
+	int				buck1_default_idx;
+	int				buck2_default_idx;
+	int				buck3_default_idx;
+	int				buck4_default_idx;
+	int				buck_ramp_delay;
+	bool				buck2_ramp_enable;
+	bool				buck3_ramp_enable;
+	bool				buck4_ramp_enable;
+
+
+};
+
+#endif /*  __LINUX_MFD_S5M_PMIC_H */
diff --git a/include/linux/mfd/s5m87xx/s5m-rtc.h b/include/linux/mfd/s5m87xx/s5m-rtc.h
new file mode 100644
index 0000000..6f52e3c
--- /dev/null
+++ b/include/linux/mfd/s5m87xx/s5m-rtc.h
@@ -0,0 +1,69 @@
+/*
+ * s5m-rtc.h
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
+#ifndef __LINUX_MFD_S5M_RTC_H
+#define __LINUX_MFD_S5M_RTC_H
+
+enum s5m_rtc_reg {
+	S5M_RTC_SEC,
+	S5M_RTC_MIN,
+	S5M_RTC_HOUR,
+	S5M_RTC_WEEKDAY,
+	S5M_RTC_DATE,
+	S5M_RTC_MONTH,
+	S5M_RTC_YEAR1,
+	S5M_RTC_YEAR2,
+	S5M_ALARM0_SEC,
+	S5M_ALARM0_MIN,
+	S5M_ALARM0_HOUR,
+	S5M_ALARM0_WEEKDAY,
+	S5M_ALARM0_DATE,
+	S5M_ALARM0_MONTH,
+	S5M_ALARM0_YEAR1,
+	S5M_ALARM0_YEAR2,
+	S5M_ALARM1_SEC,
+	S5M_ALARM1_MIN,
+	S5M_ALARM1_HOUR,
+	S5M_ALARM1_WEEKDAY,
+	S5M_ALARM1_DATE,
+	S5M_ALARM1_MONTH,
+	S5M_ALARM1_YEAR1,
+	S5M_ALARM1_YEAR2,
+	S5M_ALARM0_CONF,
+	S5M_ALARM1_CONF,
+	S5M_RTC_STATUS,
+	S5M_WTSR_SMPL_CNTL,
+	S5M_RTC_UDR_CON,
+};
+
+#define RTC_I2C_ADDR		(0x0C >> 1)
+
+#define HOUR_12			(1 << 7)
+#define HOUR_AMPM		(1 << 6)
+#define HOUR_PM			(1 << 5)
+#define ALARM0_STATUS		(1 << 1)
+#define ALARM1_STATUS		(1 << 2)
+#define UPDATE_AD		(1 << 0)
+
+enum {
+	RTC_SEC = 0,
+	RTC_MIN,
+	RTC_HOUR,
+	RTC_WEEKDAY,
+	RTC_DATE,
+	RTC_MONTH,
+	RTC_YEAR1,
+	RTC_YEAR2,
+};
+
+#endif /*  __LINUX_MFD_S5M_RTC_H */
-- 
1.7.1

