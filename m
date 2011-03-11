Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab1CKCfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 21:35:16 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46357 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1CKCet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 21:34:49 -0500
Date: Fri, 11 Mar 2011 11:34:43 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v5 1/4] MAX8997/8966 MFD Driver Initial Release
 (PMIC+RTC+MUIC+Haptic+...)
In-reply-to: <1299810886-19684-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Ortiz <sameo@linux.intel.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Message-id: <1299810886-19684-2-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
References: <1299810886-19684-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 11 Mar 2011 02:34:46.0508 (UTC)
 FILETIME=[E2E62AC0:01CBDF94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX8997/MAX8966 chip is a multi-function device with I2C bussses. The
chip includes PMIC, RTC, Fuel Gauge, MUIC, Haptic, Flash control, and
Battery (charging) control.

This patch is an initial release of a MAX8997/8966 driver that supports
to enable the chip with its primary I2C bus that connects every device
mentioned above except for Fuel Gauge, which uses another I2C bus. The
fuel gauge is not supported by this mfd driver and is supported by a
seperated driver of MAX17042 Fuel Gauge (yes, the fuel gauge part is
compatible with MAX17042).

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig                 |   12 +
 drivers/mfd/Makefile                |    1 +
 drivers/mfd/max8997.c               |  427 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8997-private.h |  347 ++++++++++++++++++++++++++++
 include/linux/mfd/max8997.h         |   88 +++++++
 5 files changed, 875 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/max8997.c
 create mode 100644 include/linux/mfd/max8997-private.h
 create mode 100644 include/linux/mfd/max8997.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index fd01836..c255b3f 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -293,6 +293,18 @@ config MFD_MAX8925
 	  accessing the device, additional drivers must be enabled in order
 	  to use the functionality of the device.
 
+config MFD_MAX8997
+	bool "Maxim Semiconductor MAX8997/8966 PMIC Support"
+	depends on I2C=y && GENERIC_HARDIRQS
+	select MFD_CORE
+	help
+	  Say yes here to support for Maxim Semiconductor MAX8998/8966.
+	  This is a Power Management IC with RTC, Flash, Fuel Gauge, Haptic,
+	  MUIC controls on chip.
+	  This driver provides common support for accessing the device; thus,
+	  additional drivers must be enabled in order to use the functionality
+	  of the device.
+
 config MFD_MAX8998
 	bool "Maxim Semiconductor MAX8998/National LP3974 PMIC Support"
 	depends on I2C=y && GENERIC_HARDIRQS
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index a54e2c7..f6662e3 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_UCB1400_CORE)	+= ucb1400_core.o
 obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
 max8925-objs			:= max8925-core.o max8925-i2c.o
 obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
+obj-$(CONFIG_MFD_MAX8997)	+= max8997.o
 obj-$(CONFIG_MFD_MAX8998)	+= max8998.o max8998-irq.o
 
 pcf50633-objs			:= pcf50633-core.o pcf50633-irq.o
diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
new file mode 100644
index 0000000..5d1fca0
--- /dev/null
+++ b/drivers/mfd/max8997.c
@@ -0,0 +1,427 @@
+/*
+ * max8997.c - mfd core driver for the Maxim 8966 and 8997
+ *
+ * Copyright (C) 2011 Samsung Electronics
+ * MyungJoo Ham <myungjoo.ham@smasung.com>
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
+ *
+ * This driver is based on max8998.c
+ */
+
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/pm_runtime.h>
+#include <linux/mutex.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/max8997.h>
+#include <linux/mfd/max8997-private.h>
+
+#define I2C_ADDR_PMIC	(0xCC >> 1)
+#define I2C_ADDR_MUIC	(0x4A >> 1)
+#define I2C_ADDR_BATTERY	(0x6C >> 1)
+#define I2C_ADDR_RTC	(0x0C >> 1)
+#define I2C_ADDR_HAPTIC	(0x90 >> 1)
+
+static struct mfd_cell max8997_devs[] = {
+	{ .name = "max8997-pmic", },
+	{ .name = "max8997-rtc", },
+	{ .name = "max8997-battery", },
+	{ .name = "max8997-haptic", },
+	{ .name = "max8997-muic", },
+	{ .name = "max8997-flash", },
+};
+
+int max8997_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
+{
+	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
+	int ret;
+
+	mutex_lock(&max8997->iolock);
+	ret = i2c_smbus_read_byte_data(i2c, reg);
+	mutex_unlock(&max8997->iolock);
+	if (ret < 0)
+		return ret;
+
+	ret &= 0xff;
+	*dest = ret;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(max8997_read_reg);
+
+int max8997_bulk_read(struct i2c_client *i2c, u8 reg, int count, u8 *buf)
+{
+	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
+	int ret;
+
+	mutex_lock(&max8997->iolock);
+	ret = i2c_smbus_read_i2c_block_data(i2c, reg, count, buf);
+	mutex_unlock(&max8997->iolock);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(max8997_bulk_read);
+
+int max8997_write_reg(struct i2c_client *i2c, u8 reg, u8 value)
+{
+	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
+	int ret;
+
+	mutex_lock(&max8997->iolock);
+	ret = i2c_smbus_write_byte_data(i2c, reg, value);
+	mutex_unlock(&max8997->iolock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(max8997_write_reg);
+
+int max8997_bulk_write(struct i2c_client *i2c, u8 reg, int count, u8 *buf)
+{
+	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
+	int ret;
+
+	mutex_lock(&max8997->iolock);
+	ret = i2c_smbus_write_i2c_block_data(i2c, reg, count, buf);
+	mutex_unlock(&max8997->iolock);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(max8997_bulk_write);
+
+int max8997_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask)
+{
+	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
+	int ret;
+
+	mutex_lock(&max8997->iolock);
+	ret = i2c_smbus_read_byte_data(i2c, reg);
+	if (ret >= 0) {
+		u8 old_val = ret & 0xff;
+		u8 new_val = (val & mask) | (old_val & (~mask));
+		ret = i2c_smbus_write_byte_data(i2c, reg, new_val);
+	}
+	mutex_unlock(&max8997->iolock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(max8997_update_reg);
+
+static int max8997_i2c_probe(struct i2c_client *i2c,
+			    const struct i2c_device_id *id)
+{
+	struct max8997_dev *max8997;
+	struct max8997_platform_data *pdata = i2c->dev.platform_data;
+	int ret = 0;
+
+	max8997 = kzalloc(sizeof(struct max8997_dev), GFP_KERNEL);
+	if (max8997 == NULL)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, max8997);
+	max8997->dev = &i2c->dev;
+	max8997->i2c = i2c;
+	max8997->type = id->driver_data;
+
+	if (!pdata)
+		goto err;
+
+	max8997->wakeup = pdata->wakeup;
+
+	mutex_init(&max8997->iolock);
+
+	max8997->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
+	i2c_set_clientdata(max8997->rtc, max8997);
+	max8997->haptic = i2c_new_dummy(i2c->adapter, I2C_ADDR_HAPTIC);
+	i2c_set_clientdata(max8997->haptic, max8997);
+	max8997->muic = i2c_new_dummy(i2c->adapter, I2C_ADDR_MUIC);
+	i2c_set_clientdata(max8997->muic, max8997);
+
+	pm_runtime_set_active(max8997->dev);
+
+	mfd_add_devices(max8997->dev, -1, max8997_devs,
+			ARRAY_SIZE(max8997_devs),
+			NULL, 0);
+
+	/*
+	 * TODO: enable others (flash, muic, rtc, battery, ...) and
+	 * check the return value
+	 */
+
+	if (ret < 0)
+		goto err_mfd;
+
+	return ret;
+
+err_mfd:
+	mfd_remove_devices(max8997->dev);
+	i2c_unregister_device(max8997->muic);
+	i2c_unregister_device(max8997->haptic);
+	i2c_unregister_device(max8997->rtc);
+err:
+	kfree(max8997);
+	return ret;
+}
+
+static int max8997_i2c_remove(struct i2c_client *i2c)
+{
+	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
+
+	mfd_remove_devices(max8997->dev);
+	i2c_unregister_device(max8997->muic);
+	i2c_unregister_device(max8997->haptic);
+	i2c_unregister_device(max8997->rtc);
+	kfree(max8997);
+
+	return 0;
+}
+
+static const struct i2c_device_id max8997_i2c_id[] = {
+	{ "max8997", TYPE_MAX8997 },
+	{ "max8966", TYPE_MAX8966 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, max8998_i2c_id);
+
+u8 max8997_dumpaddr_pmic[] = {
+	MAX8997_REG_INT1MSK,
+	MAX8997_REG_INT2MSK,
+	MAX8997_REG_INT3MSK,
+	MAX8997_REG_INT4MSK,
+	MAX8997_REG_MAINCON1,
+	MAX8997_REG_MAINCON2,
+	MAX8997_REG_BUCKRAMP,
+	MAX8997_REG_BUCK1CTRL,
+	MAX8997_REG_BUCK1DVS1,
+	MAX8997_REG_BUCK1DVS2,
+	MAX8997_REG_BUCK1DVS3,
+	MAX8997_REG_BUCK1DVS4,
+	MAX8997_REG_BUCK1DVS5,
+	MAX8997_REG_BUCK1DVS6,
+	MAX8997_REG_BUCK1DVS7,
+	MAX8997_REG_BUCK1DVS8,
+	MAX8997_REG_BUCK2CTRL,
+	MAX8997_REG_BUCK2DVS1,
+	MAX8997_REG_BUCK2DVS2,
+	MAX8997_REG_BUCK2DVS3,
+	MAX8997_REG_BUCK2DVS4,
+	MAX8997_REG_BUCK2DVS5,
+	MAX8997_REG_BUCK2DVS6,
+	MAX8997_REG_BUCK2DVS7,
+	MAX8997_REG_BUCK2DVS8,
+	MAX8997_REG_BUCK3CTRL,
+	MAX8997_REG_BUCK3DVS,
+	MAX8997_REG_BUCK4CTRL,
+	MAX8997_REG_BUCK4DVS,
+	MAX8997_REG_BUCK5CTRL,
+	MAX8997_REG_BUCK5DVS1,
+	MAX8997_REG_BUCK5DVS2,
+	MAX8997_REG_BUCK5DVS3,
+	MAX8997_REG_BUCK5DVS4,
+	MAX8997_REG_BUCK5DVS5,
+	MAX8997_REG_BUCK5DVS6,
+	MAX8997_REG_BUCK5DVS7,
+	MAX8997_REG_BUCK5DVS8,
+	MAX8997_REG_BUCK6CTRL,
+	MAX8997_REG_BUCK6BPSKIPCTRL,
+	MAX8997_REG_BUCK7CTRL,
+	MAX8997_REG_BUCK7DVS,
+	MAX8997_REG_LDO1CTRL,
+	MAX8997_REG_LDO2CTRL,
+	MAX8997_REG_LDO3CTRL,
+	MAX8997_REG_LDO4CTRL,
+	MAX8997_REG_LDO5CTRL,
+	MAX8997_REG_LDO6CTRL,
+	MAX8997_REG_LDO7CTRL,
+	MAX8997_REG_LDO8CTRL,
+	MAX8997_REG_LDO9CTRL,
+	MAX8997_REG_LDO10CTRL,
+	MAX8997_REG_LDO11CTRL,
+	MAX8997_REG_LDO12CTRL,
+	MAX8997_REG_LDO13CTRL,
+	MAX8997_REG_LDO14CTRL,
+	MAX8997_REG_LDO15CTRL,
+	MAX8997_REG_LDO16CTRL,
+	MAX8997_REG_LDO17CTRL,
+	MAX8997_REG_LDO18CTRL,
+	MAX8997_REG_LDO21CTRL,
+	MAX8997_REG_MBCCTRL1,
+	MAX8997_REG_MBCCTRL2,
+	MAX8997_REG_MBCCTRL3,
+	MAX8997_REG_MBCCTRL4,
+	MAX8997_REG_MBCCTRL5,
+	MAX8997_REG_MBCCTRL6,
+	MAX8997_REG_OTPCGHCVS,
+	MAX8997_REG_SAFEOUTCTRL,
+	MAX8997_REG_LBCNFG1,
+	MAX8997_REG_LBCNFG2,
+	MAX8997_REG_BBCCTRL,
+
+	MAX8997_REG_FLASH1_CUR,
+	MAX8997_REG_FLASH2_CUR,
+	MAX8997_REG_MOVIE_CUR,
+	MAX8997_REG_GSMB_CUR,
+	MAX8997_REG_BOOST_CNTL,
+	MAX8997_REG_LEN_CNTL,
+	MAX8997_REG_FLASH_CNTL,
+	MAX8997_REG_WDT_CNTL,
+	MAX8997_REG_MAXFLASH1,
+	MAX8997_REG_MAXFLASH2,
+	MAX8997_REG_FLASHSTATUSMASK,
+
+	MAX8997_REG_GPIOCNTL1,
+	MAX8997_REG_GPIOCNTL2,
+	MAX8997_REG_GPIOCNTL3,
+	MAX8997_REG_GPIOCNTL4,
+	MAX8997_REG_GPIOCNTL5,
+	MAX8997_REG_GPIOCNTL6,
+	MAX8997_REG_GPIOCNTL7,
+	MAX8997_REG_GPIOCNTL8,
+	MAX8997_REG_GPIOCNTL9,
+	MAX8997_REG_GPIOCNTL10,
+	MAX8997_REG_GPIOCNTL11,
+	MAX8997_REG_GPIOCNTL12,
+
+	MAX8997_REG_LDO1CONFIG,
+	MAX8997_REG_LDO2CONFIG,
+	MAX8997_REG_LDO3CONFIG,
+	MAX8997_REG_LDO4CONFIG,
+	MAX8997_REG_LDO5CONFIG,
+	MAX8997_REG_LDO6CONFIG,
+	MAX8997_REG_LDO7CONFIG,
+	MAX8997_REG_LDO8CONFIG,
+	MAX8997_REG_LDO9CONFIG,
+	MAX8997_REG_LDO10CONFIG,
+	MAX8997_REG_LDO11CONFIG,
+	MAX8997_REG_LDO12CONFIG,
+	MAX8997_REG_LDO13CONFIG,
+	MAX8997_REG_LDO14CONFIG,
+	MAX8997_REG_LDO15CONFIG,
+	MAX8997_REG_LDO16CONFIG,
+	MAX8997_REG_LDO17CONFIG,
+	MAX8997_REG_LDO18CONFIG,
+	MAX8997_REG_LDO21CONFIG,
+
+	MAX8997_REG_DVSOKTIMER1,
+	MAX8997_REG_DVSOKTIMER2,
+	MAX8997_REG_DVSOKTIMER4,
+	MAX8997_REG_DVSOKTIMER5,
+};
+
+u8 max8997_dumpaddr_muic[] = {
+	MAX8997_MUIC_REG_INTMASK1,
+	MAX8997_MUIC_REG_INTMASK2,
+	MAX8997_MUIC_REG_INTMASK3,
+	MAX8997_MUIC_REG_CDETCTRL,
+	MAX8997_MUIC_REG_CONTROL1,
+	MAX8997_MUIC_REG_CONTROL2,
+	MAX8997_MUIC_REG_CONTROL3,
+};
+
+u8 max8997_dumpaddr_haptic[] = {
+	MAX8997_HAPTIC_REG_CONF1,
+	MAX8997_HAPTIC_REG_CONF2,
+	MAX8997_HAPTIC_REG_DRVCONF,
+	MAX8997_HAPTIC_REG_CYCLECONF1,
+	MAX8997_HAPTIC_REG_CYCLECONF2,
+	MAX8997_HAPTIC_REG_SIGCONF1,
+	MAX8997_HAPTIC_REG_SIGCONF2,
+	MAX8997_HAPTIC_REG_SIGCONF3,
+	MAX8997_HAPTIC_REG_SIGCONF4,
+	MAX8997_HAPTIC_REG_SIGDC1,
+	MAX8997_HAPTIC_REG_SIGDC2,
+	MAX8997_HAPTIC_REG_SIGPWMDC1,
+	MAX8997_HAPTIC_REG_SIGPWMDC2,
+	MAX8997_HAPTIC_REG_SIGPWMDC3,
+	MAX8997_HAPTIC_REG_SIGPWMDC4,
+};
+
+static int max8997_freeze(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_pmic); i++)
+		max8997_read_reg(i2c, max8997_dumpaddr_pmic[i],
+				&max8997->reg_dump[i]);
+
+	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_muic); i++)
+		max8997_read_reg(i2c, max8997_dumpaddr_muic[i],
+				&max8997->reg_dump[i + MAX8997_REG_PMIC_END]);
+
+	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_haptic); i++)
+		max8997_read_reg(i2c, max8997_dumpaddr_haptic[i],
+				&max8997->reg_dump[i + MAX8997_REG_PMIC_END +
+				MAX8997_MUIC_REG_END]);
+
+	return 0;
+}
+
+static int max8997_restore(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_pmic); i++)
+		max8997_write_reg(i2c, max8997_dumpaddr_pmic[i],
+				max8997->reg_dump[i]);
+
+	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_muic); i++)
+		max8997_write_reg(i2c, max8997_dumpaddr_muic[i],
+				max8997->reg_dump[i + MAX8997_REG_PMIC_END]);
+
+	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_haptic); i++)
+		max8997_write_reg(i2c, max8997_dumpaddr_haptic[i],
+				max8997->reg_dump[i + MAX8997_REG_PMIC_END +
+				MAX8997_MUIC_REG_END]);
+
+	return 0;
+}
+
+const struct dev_pm_ops max8997_pm = {
+	.freeze = max8997_freeze,
+	.restore = max8997_restore,
+};
+
+static struct i2c_driver max8997_i2c_driver = {
+	.driver = {
+		   .name = "max8997",
+		   .owner = THIS_MODULE,
+		   .pm = &max8997_pm,
+	},
+	.probe = max8997_i2c_probe,
+	.remove = max8997_i2c_remove,
+	.id_table = max8997_i2c_id,
+};
+
+static int __init max8997_i2c_init(void)
+{
+	return i2c_add_driver(&max8997_i2c_driver);
+}
+/* init early so consumer devices can complete system boot */
+subsys_initcall(max8997_i2c_init);
+
+static void __exit max8997_i2c_exit(void)
+{
+	i2c_del_driver(&max8997_i2c_driver);
+}
+module_exit(max8997_i2c_exit);
+
+MODULE_DESCRIPTION("MAXIM 8997 multi-function core driver");
+MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
new file mode 100644
index 0000000..93a9477
--- /dev/null
+++ b/include/linux/mfd/max8997-private.h
@@ -0,0 +1,347 @@
+/*
+ * max8997.h - Voltage regulator driver for the Maxim 8997
+ *
+ *  Copyright (C) 2010 Samsung Electrnoics
+ *  MyungJoo Ham <myungjoo.ham@samsung.com>
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
+#ifndef __LINUX_MFD_MAX8997_PRIV_H
+#define __LINUX_MFD_MAX8997_PRIV_H
+
+#include <linux/i2c.h>
+
+enum max8997_pmic_reg {
+	MAX8997_REG_PMIC_ID0	= 0x00,
+	MAX8997_REG_PMIC_ID1	= 0x01,
+	MAX8997_REG_INTSRC	= 0x02,
+	MAX8997_REG_INT1	= 0x03,
+	MAX8997_REG_INT2	= 0x04,
+	MAX8997_REG_INT3	= 0x05,
+	MAX8997_REG_INT4	= 0x06,
+
+	MAX8997_REG_INT1MSK	= 0x08,
+	MAX8997_REG_INT2MSK	= 0x09,
+	MAX8997_REG_INT3MSK	= 0x0a,
+	MAX8997_REG_INT4MSK	= 0x0b,
+
+	MAX8997_REG_STATUS1	= 0x0d,
+	MAX8997_REG_STATUS2	= 0x0e,
+	MAX8997_REG_STATUS3	= 0x0f,
+	MAX8997_REG_STATUS4	= 0x10,
+
+	MAX8997_REG_MAINCON1	= 0x13,
+	MAX8997_REG_MAINCON2	= 0x14,
+	MAX8997_REG_BUCKRAMP	= 0x15,
+
+	MAX8997_REG_BUCK1CTRL	= 0x18,
+	MAX8997_REG_BUCK1DVS1	= 0x19,
+	MAX8997_REG_BUCK1DVS2	= 0x1a,
+	MAX8997_REG_BUCK1DVS3	= 0x1b,
+	MAX8997_REG_BUCK1DVS4	= 0x1c,
+	MAX8997_REG_BUCK1DVS5	= 0x1d,
+	MAX8997_REG_BUCK1DVS6	= 0x1e,
+	MAX8997_REG_BUCK1DVS7	= 0x1f,
+	MAX8997_REG_BUCK1DVS8	= 0x20,
+	MAX8997_REG_BUCK2CTRL	= 0x21,
+	MAX8997_REG_BUCK2DVS1	= 0x22,
+	MAX8997_REG_BUCK2DVS2	= 0x23,
+	MAX8997_REG_BUCK2DVS3	= 0x24,
+	MAX8997_REG_BUCK2DVS4	= 0x25,
+	MAX8997_REG_BUCK2DVS5	= 0x26,
+	MAX8997_REG_BUCK2DVS6	= 0x27,
+	MAX8997_REG_BUCK2DVS7	= 0x28,
+	MAX8997_REG_BUCK2DVS8	= 0x29,
+	MAX8997_REG_BUCK3CTRL	= 0x2a,
+	MAX8997_REG_BUCK3DVS	= 0x2b,
+	MAX8997_REG_BUCK4CTRL	= 0x2c,
+	MAX8997_REG_BUCK4DVS	= 0x2d,
+	MAX8997_REG_BUCK5CTRL	= 0x2e,
+	MAX8997_REG_BUCK5DVS1	= 0x2f,
+	MAX8997_REG_BUCK5DVS2	= 0x30,
+	MAX8997_REG_BUCK5DVS3	= 0x31,
+	MAX8997_REG_BUCK5DVS4	= 0x32,
+	MAX8997_REG_BUCK5DVS5	= 0x33,
+	MAX8997_REG_BUCK5DVS6	= 0x34,
+	MAX8997_REG_BUCK5DVS7	= 0x35,
+	MAX8997_REG_BUCK5DVS8	= 0x36,
+	MAX8997_REG_BUCK6CTRL	= 0x37,
+	MAX8997_REG_BUCK6BPSKIPCTRL	= 0x38,
+	MAX8997_REG_BUCK7CTRL	= 0x39,
+	MAX8997_REG_BUCK7DVS	= 0x3a,
+	MAX8997_REG_LDO1CTRL	= 0x3b,
+	MAX8997_REG_LDO2CTRL	= 0x3c,
+	MAX8997_REG_LDO3CTRL	= 0x3d,
+	MAX8997_REG_LDO4CTRL	= 0x3e,
+	MAX8997_REG_LDO5CTRL	= 0x3f,
+	MAX8997_REG_LDO6CTRL	= 0x40,
+	MAX8997_REG_LDO7CTRL	= 0x41,
+	MAX8997_REG_LDO8CTRL	= 0x42,
+	MAX8997_REG_LDO9CTRL	= 0x43,
+	MAX8997_REG_LDO10CTRL	= 0x44,
+	MAX8997_REG_LDO11CTRL	= 0x45,
+	MAX8997_REG_LDO12CTRL	= 0x46,
+	MAX8997_REG_LDO13CTRL	= 0x47,
+	MAX8997_REG_LDO14CTRL	= 0x48,
+	MAX8997_REG_LDO15CTRL	= 0x49,
+	MAX8997_REG_LDO16CTRL	= 0x4a,
+	MAX8997_REG_LDO17CTRL	= 0x4b,
+	MAX8997_REG_LDO18CTRL	= 0x4c,
+	MAX8997_REG_LDO21CTRL	= 0x4d,
+
+	MAX8997_REG_MBCCTRL1	= 0x50,
+	MAX8997_REG_MBCCTRL2	= 0x51,
+	MAX8997_REG_MBCCTRL3	= 0x52,
+	MAX8997_REG_MBCCTRL4	= 0x53,
+	MAX8997_REG_MBCCTRL5	= 0x54,
+	MAX8997_REG_MBCCTRL6	= 0x55,
+	MAX8997_REG_OTPCGHCVS	= 0x56,
+
+	MAX8997_REG_SAFEOUTCTRL	= 0x5a,
+
+	MAX8997_REG_LBCNFG1	= 0x5e,
+	MAX8997_REG_LBCNFG2	= 0x5f,
+	MAX8997_REG_BBCCTRL	= 0x60,
+
+	MAX8997_REG_FLASH1_CUR	= 0x63, /* 0x63 ~ 0x6e for FLASH */
+	MAX8997_REG_FLASH2_CUR	= 0x64,
+	MAX8997_REG_MOVIE_CUR	= 0x65,
+	MAX8997_REG_GSMB_CUR	= 0x66,
+	MAX8997_REG_BOOST_CNTL	= 0x67,
+	MAX8997_REG_LEN_CNTL	= 0x68,
+	MAX8997_REG_FLASH_CNTL	= 0x69,
+	MAX8997_REG_WDT_CNTL	= 0x6a,
+	MAX8997_REG_MAXFLASH1	= 0x6b,
+	MAX8997_REG_MAXFLASH2	= 0x6c,
+	MAX8997_REG_FLASHSTATUS	= 0x6d,
+	MAX8997_REG_FLASHSTATUSMASK	= 0x6e,
+
+	MAX8997_REG_GPIOCNTL1	= 0x70,
+	MAX8997_REG_GPIOCNTL2	= 0x71,
+	MAX8997_REG_GPIOCNTL3	= 0x72,
+	MAX8997_REG_GPIOCNTL4	= 0x73,
+	MAX8997_REG_GPIOCNTL5	= 0x74,
+	MAX8997_REG_GPIOCNTL6	= 0x75,
+	MAX8997_REG_GPIOCNTL7	= 0x76,
+	MAX8997_REG_GPIOCNTL8	= 0x77,
+	MAX8997_REG_GPIOCNTL9	= 0x78,
+	MAX8997_REG_GPIOCNTL10	= 0x79,
+	MAX8997_REG_GPIOCNTL11	= 0x7a,
+	MAX8997_REG_GPIOCNTL12	= 0x7b,
+
+	MAX8997_REG_LDO1CONFIG	= 0x80,
+	MAX8997_REG_LDO2CONFIG	= 0x81,
+	MAX8997_REG_LDO3CONFIG	= 0x82,
+	MAX8997_REG_LDO4CONFIG	= 0x83,
+	MAX8997_REG_LDO5CONFIG	= 0x84,
+	MAX8997_REG_LDO6CONFIG	= 0x85,
+	MAX8997_REG_LDO7CONFIG	= 0x86,
+	MAX8997_REG_LDO8CONFIG	= 0x87,
+	MAX8997_REG_LDO9CONFIG	= 0x88,
+	MAX8997_REG_LDO10CONFIG	= 0x89,
+	MAX8997_REG_LDO11CONFIG	= 0x8a,
+	MAX8997_REG_LDO12CONFIG	= 0x8b,
+	MAX8997_REG_LDO13CONFIG	= 0x8c,
+	MAX8997_REG_LDO14CONFIG	= 0x8d,
+	MAX8997_REG_LDO15CONFIG	= 0x8e,
+	MAX8997_REG_LDO16CONFIG	= 0x8f,
+	MAX8997_REG_LDO17CONFIG	= 0x90,
+	MAX8997_REG_LDO18CONFIG	= 0x91,
+	MAX8997_REG_LDO21CONFIG	= 0x92,
+
+	MAX8997_REG_DVSOKTIMER1	= 0x97,
+	MAX8997_REG_DVSOKTIMER2	= 0x98,
+	MAX8997_REG_DVSOKTIMER4	= 0x99,
+	MAX8997_REG_DVSOKTIMER5	= 0x9a,
+
+	MAX8997_REG_PMIC_END	= 0x9b,
+};
+
+enum max8997_muic_reg {
+	MAX8997_MUIC_REG_ID		= 0x0,
+	MAX8997_MUIC_REG_INT1		= 0x1,
+	MAX8997_MUIC_REG_INT2		= 0x2,
+	MAX8997_MUIC_REG_INT3		= 0x3,
+	MAX8997_MUIC_REG_STATUS1	= 0x4,
+	MAX8997_MUIC_REG_STATUS2	= 0x5,
+	MAX8997_MUIC_REG_STATUS3	= 0x6,
+	MAX8997_MUIC_REG_INTMASK1	= 0x7,
+	MAX8997_MUIC_REG_INTMASK2	= 0x8,
+	MAX8997_MUIC_REG_INTMASK3	= 0x9,
+	MAX8997_MUIC_REG_CDETCTRL	= 0xa,
+
+	MAX8997_MUIC_REG_CONTROL1	= 0xc,
+	MAX8997_MUIC_REG_CONTROL2	= 0xd,
+	MAX8997_MUIC_REG_CONTROL3	= 0xe,
+
+	MAX8997_MUIC_REG_END		= 0xf,
+};
+
+enum max8997_haptic_reg {
+	MAX8997_HAPTIC_REG_GENERAL	= 0x00,
+	MAX8997_HAPTIC_REG_CONF1	= 0x01,
+	MAX8997_HAPTIC_REG_CONF2	= 0x02,
+	MAX8997_HAPTIC_REG_DRVCONF	= 0x03,
+	MAX8997_HAPTIC_REG_CYCLECONF1	= 0x04,
+	MAX8997_HAPTIC_REG_CYCLECONF2	= 0x05,
+	MAX8997_HAPTIC_REG_SIGCONF1	= 0x06,
+	MAX8997_HAPTIC_REG_SIGCONF2	= 0x07,
+	MAX8997_HAPTIC_REG_SIGCONF3	= 0x08,
+	MAX8997_HAPTIC_REG_SIGCONF4	= 0x09,
+	MAX8997_HAPTIC_REG_SIGDC1	= 0x0a,
+	MAX8997_HAPTIC_REG_SIGDC2	= 0x0b,
+	MAX8997_HAPTIC_REG_SIGPWMDC1	= 0x0c,
+	MAX8997_HAPTIC_REG_SIGPWMDC2	= 0x0d,
+	MAX8997_HAPTIC_REG_SIGPWMDC3	= 0x0e,
+	MAX8997_HAPTIC_REG_SIGPWMDC4	= 0x0f,
+	MAX8997_HAPTIC_REG_MTR_REV	= 0x10,
+
+	MAX8997_HAPTIC_REG_END		= 0x11,
+};
+
+/* slave addr = 0x0c: using "2nd part" of rev4 datasheet */
+enum max8997_rtc_reg {
+	MAX8997_RTC_CTRLMASK		= 0x02,
+	MAX8997_RTC_CTRL		= 0x03,
+	MAX8997_RTC_UPDATE1		= 0x04,
+	MAX8997_RTC_UPDATE2		= 0x05,
+	MAX8997_RTC_WTSR_SMPL		= 0x06,
+
+	MAX8997_RTC_SEC			= 0x10,
+	MAX8997_RTC_MIN			= 0x11,
+	MAX8997_RTC_HOUR		= 0x12,
+	MAX8997_RTC_DAY_OF_WEEK		= 0x13,
+	MAX8997_RTC_MONTH		= 0x14,
+	MAX8997_RTC_YEAR		= 0x15,
+	MAX8997_RTC_DAY_OF_MONTH	= 0x16,
+	MAX8997_RTC_ALARM1_SEC		= 0x17,
+	MAX8997_RTC_ALARM1_MIN		= 0x18,
+	MAX8997_RTC_ALARM1_HOUR		= 0x19,
+	MAX8997_RTC_ALARM1_DAY_OF_WEEK	= 0x1a,
+	MAX8997_RTC_ALARM1_MONTH	= 0x1b,
+	MAX8997_RTC_ALARM1_YEAR		= 0x1c,
+	MAX8997_RTC_ALARM1_DAY_OF_MONTH	= 0x1d,
+	MAX8997_RTC_ALARM2_SEC		= 0x1e,
+	MAX8997_RTC_ALARM2_MIN		= 0x1f,
+	MAX8997_RTC_ALARM2_HOUR		= 0x20,
+	MAX8997_RTC_ALARM2_DAY_OF_WEEK	= 0x21,
+	MAX8997_RTC_ALARM2_MONTH	= 0x22,
+	MAX8997_RTC_ALARM2_YEAR		= 0x23,
+	MAX8997_RTC_ALARM2_DAY_OF_MONTH	= 0x24,
+};
+
+enum max8997_irq_source {
+	PMIC_INT1 = 0,
+	PMIC_INT2,
+	PMIC_INT3,
+	PMIC_INT4,
+
+	FUEL_GAUGE, /* Ignored (MAX17042 driver handles) */
+
+	MUIC_INT1,
+	MUIC_INT2,
+	MUIC_INT3,
+
+	GPIO_LOW, /* Not implemented */
+	GPIO_HI, /* Not implemented */
+
+	FLASH_STATUS, /* Not implemented */
+
+	MAX8997_IRQ_GROUP_NR,
+};
+
+enum max8997_irq {
+	MAX8997_PMICIRQ_PWRONR,
+	MAX8997_PMICIRQ_PWRONF,
+	MAX8997_PMICIRQ_PWRON1SEC,
+	MAX8997_PMICIRQ_JIGONR,
+	MAX8997_PMICIRQ_JIGONF,
+	MAX8997_PMICIRQ_LOWBAT2,
+	MAX8997_PMICIRQ_LOWBAT1,
+
+	MAX8997_PMICIRQ_JIGR,
+	MAX8997_PMICIRQ_JIGF,
+	MAX8997_PMICIRQ_MR,
+	MAX8997_PMICIRQ_DVS1OK,
+	MAX8997_PMICIRQ_DVS2OK,
+	MAX8997_PMICIRQ_DVS3OK,
+	MAX8997_PMICIRQ_DVS4OK,
+
+	MAX8997_PMICIRQ_CHGINS,
+	MAX8997_PMICIRQ_CHGRM,
+	MAX8997_PMICIRQ_DCINOVP,
+	MAX8997_PMICIRQ_TOPOFFR,
+	MAX8997_PMICIRQ_CHGRSTF,
+	MAX8997_PMICIRQ_MBCHGTMEXPD,
+
+	MAX8997_PMICIRQ_RTC60S,
+	MAX8997_PMICIRQ_RTCA1,
+	MAX8997_PMICIRQ_RTCA2,
+	MAX8997_PMICIRQ_SMPL_INT,
+	MAX8997_PMICIRQ_RTC1S,
+	MAX8997_PMICIRQ_WTSR,
+
+	MAX8997_MUICIRQ_ADCError,
+	MAX8997_MUICIRQ_ADCLow,
+	MAX8997_MUICIRQ_ADC,
+
+	MAX8997_MUICIRQ_VBVolt,
+	MAX8997_MUICIRQ_DBChg,
+	MAX8997_MUICIRQ_DCDTmr,
+	MAX8997_MUICIRQ_ChgDetRun,
+	MAX8997_MUICIRQ_ChgTyp,
+
+	MAX8997_MUICIRQ_OVP,
+
+	MAX8997_IRQ_NR,
+};
+
+#define MAX8997_REG_BUCK1DVS(x)	(MAX8997_REG_BUCK1DVS1 + (x) - 1)
+#define MAX8997_REG_BUCK2DVS(x)	(MAX8997_REG_BUCK2DVS1 + (x) - 1)
+#define MAX8997_REG_BUCK5DVS(x)	(MAX8997_REG_BUCK5DVS1 + (x) - 1)
+
+struct max8997_dev {
+	struct device *dev;
+	struct i2c_client *i2c; /* 0xcc / PMIC, Battery Control, and FLASH */
+	struct i2c_client *rtc; /* slave addr 0x0c */
+	struct i2c_client *haptic; /* slave addr 0x90 */
+	struct i2c_client *muic; /* slave addr 0x4a */
+	struct mutex iolock;
+
+	int type;
+	struct platform_device *battery; /* battery control (not fuel gauge) */
+
+	bool wakeup;
+
+	/* For hibernation */
+	u8 reg_dump[MAX8997_REG_PMIC_END + MAX8997_MUIC_REG_END +
+		MAX8997_HAPTIC_REG_END];
+};
+
+enum max8997_types {
+	TYPE_MAX8997,
+	TYPE_MAX8966,
+};
+
+extern int max8997_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest);
+extern int max8997_bulk_read(struct i2c_client *i2c, u8 reg, int count,
+				u8 *buf);
+extern int max8997_write_reg(struct i2c_client *i2c, u8 reg, u8 value);
+extern int max8997_bulk_write(struct i2c_client *i2c, u8 reg, int count,
+				u8 *buf);
+extern int max8997_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask);
+
+#endif /*  __LINUX_MFD_MAX8997_PRIV_H */
diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
new file mode 100644
index 0000000..d0d9136
--- /dev/null
+++ b/include/linux/mfd/max8997.h
@@ -0,0 +1,88 @@
+/*
+ * max8997.h - Driver for the Maxim 8997/8966
+ *
+ *  Copyright (C) 2009-2010 Samsung Electrnoics
+ *  MyungJoo Ham <myungjoo.ham@samsung.com>
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
+ *
+ * This driver is based on max8998.h
+ *
+ * MAX8997 has PMIC, MUIC, HAPTIC, RTC, FLASH, and Fuel Gauge devices.
+ * Except Fuel Gauge, every device shares the same I2C bus and included in
+ * this mfd driver. Although the fuel gauge is included in the chip, it is
+ * excluded from the driver because a) it has a different I2C bus from
+ * others and b) it can be enabled simply by using MAX17042 driver.
+ */
+
+#ifndef __LINUX_MFD_MAX8998_H
+#define __LINUX_MFD_MAX8998_H
+
+#include <linux/regulator/consumer.h>
+
+/* MAX8997/8966 regulator IDs */
+enum max8998_regulators {
+	MAX8997_LDO1 = 0,
+	MAX8997_LDO2,
+	MAX8997_LDO3,
+	MAX8997_LDO4,
+	MAX8997_LDO5,
+	MAX8997_LDO6,
+	MAX8997_LDO7,
+	MAX8997_LDO8,
+	MAX8997_LDO9,
+	MAX8997_LDO10,
+	MAX8997_LDO11,
+	MAX8997_LDO12,
+	MAX8997_LDO13,
+	MAX8997_LDO14,
+	MAX8997_LDO15,
+	MAX8997_LDO16,
+	MAX8997_LDO17,
+	MAX8997_LDO18,
+	MAX8997_LDO21,
+	MAX8997_BUCK1,
+	MAX8997_BUCK2,
+	MAX8997_BUCK3,
+	MAX8997_BUCK4,
+	MAX8997_BUCK5,
+	MAX8997_BUCK6,
+	MAX8997_BUCK7,
+	MAX8997_EN32KHZ_AP,
+	MAX8997_EN32KHZ_CP,
+	MAX8997_ENVICHG,
+	MAX8997_ESAFEOUT1,
+	MAX8997_ESAFEOUT2,
+	MAX8997_CHARGER_CV, /* control MBCCV of MBCCTRL3 */
+	MAX8997_CHARGER, /* charger current, MBCCTRL4 */
+	MAX8997_CHARGER_TOPOFF, /* MBCCTRL5 */
+};
+
+struct max8997_regulator_data {
+	int id;
+	struct regulator_init_data *initdata;
+};
+
+struct max8997_platform_data {
+	bool wakeup;
+	/* PMIC: Not implemented */
+	/* MUIC: Not implemented */
+	/* HAPTIC: Not implemented */
+	/* RTC: Not implemented */
+	/* Flash: Not implemented */
+	/* Charger control: Not implemented */
+};
+
+#endif /* __LINUX_MFD_MAX8998_H */
-- 
1.7.1

