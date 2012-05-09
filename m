Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159Ab2EIQNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:13:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57549 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab2EIQNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:13:10 -0400
X-AuditID: cbfee61b-b7c60ae000000c58-f4-4faa97959d91
From: Yadwinder Singh <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 1/2] mfd: Add support for MAX77686.
Date: Wed, 09 May 2012 21:54:54 +0530
Message-id: <1336580695-1184-2-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1336580695-1184-1-git-send-email-yadi.brar@samsung.com>
References: <1336580695-1184-1-git-send-email-yadi.brar@samsung.com>
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yadwinder Singh Brar <yadi.brar@samsung.com>

MAX77686 is a mulitifunction device with PMIC, RTC and Charger on chip. This
driver provides common support for accessing the device. This is initial
version of this driver that supports to enable the chip with its primary I2C
bus.It also includes IRQ and device tree support for MAX77686 chip.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/mfd/Kconfig                  |   19 ++
 drivers/mfd/Makefile                 |    1 +
 drivers/mfd/max77686-irq.c           |  258 +++++++++++++++++++++++++++++
 drivers/mfd/max77686.c               |  299 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/max77686-private.h |  279 +++++++++++++++++++++++++++++++
 include/linux/mfd/max77686.h         |  104 ++++++++++++
 6 files changed, 960 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/max77686-irq.c
 create mode 100644 drivers/mfd/max77686.c
 create mode 100644 include/linux/mfd/max77686-private.h
 create mode 100644 include/linux/mfd/max77686.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 11e4438..618bc42 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -441,6 +441,25 @@ config MFD_MAX8998
 	  additional drivers must be enabled in order to use the functionality
 	  of the device.
 
+config MFD_MAX77686
+	bool "Maxim Semiconductor MAX77686 PMIC Support"
+	depends on I2C=y && GENERIC_HARDIRQS
+	select MFD_CORE
+	help
+	  Say yes here to support for Maxim Semiconductor MAX77686.
+	  This is a Power Management IC with RTC on chip.
+	  This driver provides common support for accessing the device;
+	  additional drivers must be enabled in order to use the functionality
+	  of the device.
+
+config DEBUG_MAX77686
+	bool "MAX77686 PMIC debugging"
+	depends on MFD_MAX77686
+	help
+	  Say yes, if you need enable debug messages in MFD_MAX77686 driver.
+	  Further for enabling/disabling particular type of debug messages set
+	  max77686_debug_mask accordingly.
+
 config MFD_S5M_CORE
 	bool "SAMSUNG S5M Series Support"
 	depends on I2C=y && GENERIC_HARDIRQS
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 05fa538..19ecca9 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -79,6 +79,7 @@ max8925-objs			:= max8925-core.o max8925-i2c.o
 obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
 obj-$(CONFIG_MFD_MAX8997)	+= max8997.o max8997-irq.o
 obj-$(CONFIG_MFD_MAX8998)	+= max8998.o max8998-irq.o
+obj-$(CONFIG_MFD_MAX77686)	+= max77686.o max77686-irq.o
 
 pcf50633-objs			:= pcf50633-core.o pcf50633-irq.o
 obj-$(CONFIG_MFD_PCF50633)	+= pcf50633.o
diff --git a/drivers/mfd/max77686-irq.c b/drivers/mfd/max77686-irq.c
new file mode 100644
index 0000000..b40a46d
--- /dev/null
+++ b/drivers/mfd/max77686-irq.c
@@ -0,0 +1,258 @@
+/*
+ * max77686-irq.c - Interrupt controller support for MAX77686
+ *
+ * Copyright (C) 2012 Samsung Electronics Co.Ltd
+ * Chiwoong Byun <woong.byun@samsung.com>
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
+ * This driver is based on max8997-irq.c
+ */
+
+#include <linux/err.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/max77686.h>
+#include <linux/mfd/max77686-private.h>
+#include <linux/irqdomain.h>
+
+#define IRQ_GRP (data->hwirq >> 3)
+#define IRQ_MASK (1 << (data->hwirq & 7))
+
+int max77686_debug_mask = MAX77686_DEBUG_INFO; /* enable debug prints */
+
+static const u8 max77686_mask_reg[] = {
+	[PMIC_INT1]	= MAX77686_REG_INT1MSK,
+	[PMIC_INT2]	= MAX77686_REG_INT2MSK,
+	[RTC_INT]	= MAX77686_RTC_INTM,
+};
+
+static struct i2c_client *max77686_get_i2c(struct max77686_dev *max77686,
+					   enum max77686_irq_source src)
+{
+	switch (src) {
+	case PMIC_INT1...PMIC_INT2:
+		return max77686->i2c;
+	case RTC_INT:
+		return max77686->rtc;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+}
+
+static void max77686_irq_lock(struct irq_data *data)
+{
+	struct max77686_dev *max77686 = irq_get_chip_data(data->irq);
+
+	mutex_lock(&max77686->irqlock);
+}
+
+static void max77686_irq_sync_unlock(struct irq_data *data)
+{
+	struct max77686_dev *max77686 = irq_get_chip_data(data->irq);
+	int i;
+
+	for (i = 0; i < MAX77686_IRQ_GROUP_NR; i++) {
+		u8 mask_reg = max77686_mask_reg[i];
+		struct i2c_client *i2c = max77686_get_i2c(max77686, i);
+
+		dbg_mask("%s: mask_reg[%d]=0x%x, cur=0x%x\n",
+			__func__, i, mask_reg, max77686->irq_masks_cur[i]);
+
+		if (mask_reg == MAX77686_REG_INVALID || IS_ERR_OR_NULL(i2c))
+			continue;
+
+		max77686->irq_masks_cache[i] = max77686->irq_masks_cur[i];
+
+		max77686_write_reg(i2c, max77686_mask_reg[i],
+				   max77686->irq_masks_cur[i]);
+	}
+
+	mutex_unlock(&max77686->irqlock);
+}
+
+static void max77686_irq_mask(struct irq_data *data)
+{
+	struct max77686_dev *max77686 = irq_get_chip_data(data->irq);
+
+	max77686->irq_masks_cur[IRQ_GRP] |= IRQ_MASK;
+	dbg_mask("%s: group=%d, cur=0x%x\n",
+		__func__, IRQ_GRP,
+		max77686->irq_masks_cur[IRQ_GRP]);
+
+}
+
+static void max77686_irq_unmask(struct irq_data *data)
+{
+	struct max77686_dev *max77686 = irq_get_chip_data(data->irq);
+
+	max77686->irq_masks_cur[IRQ_GRP] &= ~IRQ_MASK;
+	dbg_mask("%s: group=%d, cur=0x%x\n",
+		__func__, IRQ_GRP,
+		max77686->irq_masks_cur[IRQ_GRP]);
+
+}
+
+static struct irq_chip max77686_irq_chip = {
+	.name = "max77686",
+	.irq_bus_lock = max77686_irq_lock,
+	.irq_bus_sync_unlock = max77686_irq_sync_unlock,
+	.irq_mask = max77686_irq_mask,
+	.irq_unmask = max77686_irq_unmask,
+};
+
+static irqreturn_t max77686_irq_thread(int irq, void *data)
+{
+	struct max77686_dev *max77686 = data;
+	u8 irq_reg[MAX77686_IRQ_GROUP_NR] = { };
+	u8 irq_src;
+	int ret, grp, i, cur_irq;
+
+	ret = max77686_read_reg(max77686->i2c, MAX77686_REG_INTSRC, &irq_src);
+	if (ret < 0) {
+		dev_err(max77686->dev, "Failed to read interrupt source: %d\n",
+			ret);
+		return IRQ_NONE;
+	}
+
+	if (irq_src == MAX77686_IRQSRC_PMIC) {
+		ret = max77686_bulk_read(max77686->i2c, MAX77686_REG_INT1,
+					 2, irq_reg);
+		if (ret < 0) {
+			dev_err(max77686->dev,
+				"Failed to read pmic interrupt: %d\n", ret);
+			return IRQ_NONE;
+		}
+
+		dbg_int("%s: int1=0x%x, int2=0x%x\n", __func__,
+			irq_reg[PMIC_INT1], irq_reg[PMIC_INT2]);
+	}
+
+	if (irq_src & MAX77686_IRQSRC_RTC) {
+		ret = max77686_read_reg(max77686->rtc, MAX77686_RTC_INT,
+					&irq_reg[RTC_INT]);
+		if (ret < 0) {
+			dev_err(max77686->dev,
+				"Failed to read rtc interrupt: %d\n", ret);
+			return IRQ_NONE;
+		}
+		dbg_int("%s: rtc int=0x%x\n", __func__,
+			irq_reg[RTC_INT]);
+
+	}
+
+	for (grp = 0; grp < MAX77686_IRQ_GROUP_NR; grp++) {
+		irq_reg[grp] &= ~max77686->irq_masks_cur[grp];
+		i = 0;
+		while (irq_reg[grp]) {
+			if (irq_reg[grp] & (1 << i)) {
+				cur_irq = irq_find_mapping(max77686->irq_domain,
+						grp*8 + i);
+				if (cur_irq)
+					handle_nested_irq(cur_irq);
+
+				irq_reg[grp] &= ~(1 << i);
+				dbg_int("%s: Handled irq:%x from group:%x\n",
+					__func__, i, grp);
+			}
+			i++;
+		}
+	}
+
+	dbg_info("%s returning\n", __func__);
+
+	return IRQ_HANDLED;
+}
+
+int max77686_irq_resume(struct max77686_dev *max77686)
+{
+	if (max77686->irq && max77686->irq_domain)
+		max77686_irq_thread(0, max77686);
+
+	return 0;
+}
+
+static int max77686_irq_domain_map(struct irq_domain *d, unsigned int irq,
+					irq_hw_number_t hw)
+{
+	struct max77686_dev *max77686 = d->host_data;
+
+	irq_set_chip_data(irq, max77686);
+	irq_set_chip_and_handler(irq, &max77686_irq_chip, handle_edge_irq);
+	irq_set_nested_thread(irq, 1);
+	set_irq_flags(irq, IRQF_VALID);
+	return 0;
+}
+
+static struct irq_domain_ops max77686_irq_domain_ops = {
+	.map = max77686_irq_domain_map,
+};
+
+int max77686_irq_init(struct max77686_dev *max77686)
+{
+	int i, ret;
+	struct irq_domain *domain;
+
+	if (!max77686->irq) {
+			dev_warn(max77686->dev,
+				 "No interrupt specified.\n");
+			return -ENODEV;
+	}
+
+	mutex_init(&max77686->irqlock);
+
+	/* Mask individual interrupt sources */
+	for (i = 0; i < MAX77686_IRQ_GROUP_NR; i++) {
+		struct i2c_client *i2c;
+
+		max77686->irq_masks_cur[i] = 0xff;
+		max77686->irq_masks_cache[i] = 0xff;
+		i2c = max77686_get_i2c(max77686, i);
+
+		if (IS_ERR_OR_NULL(i2c))
+			continue;
+		if (max77686_mask_reg[i] == MAX77686_REG_INVALID)
+			continue;
+
+		max77686_write_reg(i2c, max77686_mask_reg[i], 0xff);
+	}
+
+	domain = irq_domain_add_linear(NULL, MAX77686_IRQ_NR,
+					&max77686_irq_domain_ops, &max77686);
+	if (!domain) {
+		dev_err(max77686->dev, "could not create irq domain\n");
+		return -ENODEV;
+	}
+
+	ret = request_threaded_irq(max77686->irq, NULL, max77686_irq_thread,
+				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				   "max77686-irq", max77686);
+
+	if (ret) {
+		dev_err(max77686->dev, "Failed to request IRQ %d: %d\n",
+			max77686->irq, ret);
+		return ret;
+	}
+
+	dbg_info("%s : returning\n", __func__);
+
+	return 0;
+}
+
+void max77686_irq_exit(struct max77686_dev *max77686)
+{
+	if (max77686->irq)
+		free_irq(max77686->irq, max77686);
+}
diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
new file mode 100644
index 0000000..8bee7e8
--- /dev/null
+++ b/drivers/mfd/max77686.c
@@ -0,0 +1,299 @@
+/*
+ * max77686.c - mfd core driver for the Maxim 77686
+ *
+ * Copyright (C) 2012 Samsung Electronics
+ * Chiwoong Byun <woong.byun@samsung.com>
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
+ * This driver is based on max8997.c
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/err.h>
+#include <linux/pm_runtime.h>
+#include <linux/mutex.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/max77686.h>
+#include <linux/mfd/max77686-private.h>
+
+#define I2C_ADDR_RTC    (0x0C >> 1)
+
+#ifdef CONFIG_OF
+static struct of_device_id __devinitdata max77686_pmic_dt_match[] = {
+	{.compatible = "maxim,max77686-pmic",	.data = 0},
+	{},
+};
+#endif
+
+static struct mfd_cell max77686_devs[] = {
+	{.name = "max77686-pmic",},
+	{.name = "max77686-rtc",},
+};
+
+int max77686_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(i2c, reg);
+	if (ret < 0)
+		return ret;
+
+	*dest = ret & 0xff;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(max77686_read_reg);
+
+int max77686_bulk_read(struct i2c_client *i2c, u8 reg, int count, u8 *buf)
+{
+	int ret;
+
+	ret = i2c_smbus_read_i2c_block_data(i2c, reg, count, buf);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(max77686_bulk_read);
+
+int max77686_write_reg(struct i2c_client *i2c, u8 reg, u8 value)
+{
+	int ret;
+
+	ret = i2c_smbus_write_byte_data(i2c, reg, value);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(max77686_write_reg);
+
+int max77686_bulk_write(struct i2c_client *i2c, u8 reg, int count, u8 *buf)
+{
+	int ret;
+
+	ret = i2c_smbus_write_i2c_block_data(i2c, reg, count, buf);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(max77686_bulk_write);
+
+int max77686_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(i2c, reg);
+	if (ret >= 0) {
+		u8 old_val = ret & 0xff;
+		u8 new_val = (val & mask) | (old_val & (~mask));
+		ret = i2c_smbus_write_byte_data(i2c, reg, new_val);
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(max77686_update_reg);
+
+#ifdef CONFIG_OF
+static struct max77686_platform_data *max77686_i2c_parse_dt_pdata(struct device
+								  *dev)
+{
+	struct max77686_platform_data *pd;
+
+	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
+	if (!pd) {
+		dev_err(dev, "could not allocate memory for pdata\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	if (of_get_property(dev->of_node, "max77686,wakeup", NULL))
+		pd->wakeup = true;
+
+	return pd;
+}
+#else
+static struct max77686_platform_data *max77686_i2c_parse_dt_pdata(struct device
+								  *dev)
+{
+	return 0;
+}
+#endif
+
+static inline int max77686_i2c_get_driver_data(struct i2c_client *i2c,
+					       const struct i2c_device_id *id)
+{
+#ifdef CONFIG_OF
+	if (i2c->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(max77686_pmic_dt_match,
+				i2c->dev.of_node);
+		return (int)match->data;
+	}
+#endif
+	return (int)id->driver_data;
+}
+
+static int max77686_i2c_probe(struct i2c_client *i2c,
+			      const struct i2c_device_id *id)
+{
+	struct max77686_dev *max77686;
+	struct max77686_platform_data *pdata = i2c->dev.platform_data;
+	int ret = 0;
+	u8 data;
+
+	max77686 = kzalloc(sizeof(struct max77686_dev), GFP_KERNEL);
+	if (max77686 == NULL) {
+		dev_err(max77686->dev, "could not allocate memory\n");
+		return -ENOMEM;
+	}
+
+	max77686->dev = &i2c->dev;
+
+	if (max77686->dev->of_node) {
+		pdata = max77686_i2c_parse_dt_pdata(max77686->dev);
+		if (IS_ERR(pdata)) {
+			ret = PTR_ERR(pdata);
+			goto err;
+		}
+	}
+	if (!pdata) {
+		ret = -ENODEV;
+		dbg_info("%s : No platform data found\n", __func__);
+		goto err;
+	}
+
+	i2c_set_clientdata(i2c, max77686);
+	max77686->i2c = i2c;
+	max77686->irq = i2c->irq;
+	max77686->type = max77686_i2c_get_driver_data(i2c, id);
+
+	max77686->pdata = pdata;
+	max77686->wakeup = pdata->wakeup;
+
+	max77686->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
+	i2c_set_clientdata(max77686->rtc, max77686);
+	ret = max77686_irq_init(max77686);
+	if (ret < 0) {
+		dbg_info("%s : max77686_irq_init failed\n", __func__);
+		goto err;
+	}
+
+	ret = mfd_add_devices(max77686->dev, -1, max77686_devs,
+			      ARRAY_SIZE(max77686_devs), NULL, 0);
+
+	if (ret < 0) {
+		dbg_info("%s : mfd_add_devices failed\n", __func__);
+		goto err_mfd;
+	}
+
+	pm_runtime_set_active(max77686->dev);
+	device_init_wakeup(max77686->dev, max77686->wakeup);
+
+	if (max77686_read_reg(i2c, MAX77686_REG_DEVICE_ID, &data) < 0) {
+		ret = -EIO;
+		dbg_info("%s : device not found on this channel\n", __func__);
+		goto err_mfd;
+	} else
+		dev_info(max77686->dev, "device found\n");
+
+	return ret;
+
+ err_mfd:
+	mfd_remove_devices(max77686->dev);
+	max77686_irq_exit(max77686);
+	i2c_unregister_device(max77686->rtc);
+ err:
+	kfree(max77686);
+	dev_err(max77686->dev, "device probe failed : %d\n", ret);
+	return ret;
+}
+
+static int max77686_i2c_remove(struct i2c_client *i2c)
+{
+	struct max77686_dev *max77686 = i2c_get_clientdata(i2c);
+
+	device_init_wakeup(max77686->dev, 0);
+	pm_runtime_set_suspended(max77686->dev);
+	mfd_remove_devices(max77686->dev);
+	max77686_irq_exit(max77686);
+	i2c_unregister_device(max77686->rtc);
+	kfree(max77686);
+	return 0;
+}
+
+static const struct i2c_device_id max77686_i2c_id[] = {
+	{"max77686", 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, max77686_i2c_id);
+
+static int max77686_suspend(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max77686_dev *max77686 = i2c_get_clientdata(i2c);
+
+	if (device_may_wakeup(dev))
+		enable_irq_wake(max77686->irq);
+
+	return 0;
+}
+
+static int max77686_resume(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max77686_dev *max77686 = i2c_get_clientdata(i2c);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(max77686->irq);
+
+	max77686_irq_resume(max77686);
+	return 0;
+}
+
+const struct dev_pm_ops max77686_pm = {
+	.suspend = max77686_suspend,
+	.resume = max77686_resume,
+};
+
+static struct i2c_driver max77686_i2c_driver = {
+	.driver = {
+		   .name = "max77686",
+		   .owner = THIS_MODULE,
+		   .pm = &max77686_pm,
+		   .of_match_table = of_match_ptr(max77686_pmic_dt_match),
+		   },
+	.probe = max77686_i2c_probe,
+	.remove = max77686_i2c_remove,
+	.id_table = max77686_i2c_id,
+};
+
+static int __init max77686_i2c_init(void)
+{
+	return i2c_add_driver(&max77686_i2c_driver);
+}
+
+subsys_initcall(max77686_i2c_init);
+
+static void __exit max77686_i2c_exit(void)
+{
+	i2c_del_driver(&max77686_i2c_driver);
+}
+
+module_exit(max77686_i2c_exit);
+
+MODULE_DESCRIPTION("MAXIM 77686 multi-function core driver");
+MODULE_AUTHOR("Chiwoong Byun <woong.byun@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/max77686-private.h b/include/linux/mfd/max77686-private.h
new file mode 100644
index 0000000..a5b5cd4
--- /dev/null
+++ b/include/linux/mfd/max77686-private.h
@@ -0,0 +1,279 @@
+/*
+ * max77686.h - Voltage regulator driver for the Maxim 77686
+ *
+ *  Copyright (C) 2011 Samsung Electrnoics
+ *  Chiwoong Byun <woong.byun@samsung.com>
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
+#ifndef __LINUX_MFD_MAX77686_PRIV_H
+#define __LINUX_MFD_MAX77686_PRIV_H
+
+#include <linux/i2c.h>
+
+#define MAX77686_REG_INVALID		(0xff)
+#define RAMP_MASK			0xC0
+
+enum max77686_pmic_reg {
+	MAX77686_REG_DEVICE_ID		= 0x00,
+	MAX77686_REG_INTSRC		= 0x01,
+	MAX77686_REG_INT1		= 0x02,
+	MAX77686_REG_INT2		= 0x03,
+
+	MAX77686_REG_INT1MSK		= 0x04,
+	MAX77686_REG_INT2MSK		= 0x05,
+
+	MAX77686_REG_STATUS1		= 0x06,
+	MAX77686_REG_STATUS2		= 0x07,
+
+	MAX77686_REG_PWRON		= 0x08,
+	MAX77686_REG_ONOFF_DELAY	= 0x09,
+	MAX77686_REG_MRSTB		= 0x0A,
+	/* Reserved: 0x0B-0x0F */
+
+	MAX77686_REG_BUCK1CTRL		= 0x10,
+	MAX77686_REG_BUCK1OUT		= 0x11,
+	MAX77686_REG_BUCK2CTRL1		= 0x12,
+	MAX77686_REG_BUCK234FREQ	= 0x13,
+	MAX77686_REG_BUCK2DVS1		= 0x14,
+	MAX77686_REG_BUCK2DVS2		= 0x15,
+	MAX77686_REG_BUCK2DVS3		= 0x16,
+	MAX77686_REG_BUCK2DVS4		= 0x17,
+	MAX77686_REG_BUCK2DVS5		= 0x18,
+	MAX77686_REG_BUCK2DVS6		= 0x19,
+	MAX77686_REG_BUCK2DVS7		= 0x1A,
+	MAX77686_REG_BUCK2DVS8		= 0x1B,
+	MAX77686_REG_BUCK3CTRL1		= 0x1C,
+	/* Reserved: 0x1D */
+	MAX77686_REG_BUCK3DVS1		= 0x1E,
+	MAX77686_REG_BUCK3DVS2		= 0x1F,
+	MAX77686_REG_BUCK3DVS3		= 0x20,
+	MAX77686_REG_BUCK3DVS4		= 0x21,
+	MAX77686_REG_BUCK3DVS5		= 0x22,
+	MAX77686_REG_BUCK3DVS6		= 0x23,
+	MAX77686_REG_BUCK3DVS7		= 0x24,
+	MAX77686_REG_BUCK3DVS8		= 0x25,
+	MAX77686_REG_BUCK4CTRL1		= 0x26,
+	/* Reserved: 0x27 */
+	MAX77686_REG_BUCK4DVS1		= 0x28,
+	MAX77686_REG_BUCK4DVS2		= 0x29,
+	MAX77686_REG_BUCK4DVS3		= 0x2A,
+	MAX77686_REG_BUCK4DVS4		= 0x2B,
+	MAX77686_REG_BUCK4DVS5		= 0x2C,
+	MAX77686_REG_BUCK4DVS6		= 0x2D,
+	MAX77686_REG_BUCK4DVS7		= 0x2E,
+	MAX77686_REG_BUCK4DVS8		= 0x2F,
+	MAX77686_REG_BUCK5CTRL		= 0x30,
+	MAX77686_REG_BUCK5OUT		= 0x31,
+	MAX77686_REG_BUCK6CTRL		= 0x32,
+	MAX77686_REG_BUCK6OUT		= 0x33,
+	MAX77686_REG_BUCK7CTRL		= 0x34,
+	MAX77686_REG_BUCK7OUT		= 0x35,
+	MAX77686_REG_BUCK8CTRL		= 0x36,
+	MAX77686_REG_BUCK8OUT		= 0x37,
+	MAX77686_REG_BUCK9CTRL		= 0x38,
+	MAX77686_REG_BUCK9OUT		= 0x39,
+	/* Reserved: 0x3A-0x3F */
+
+	MAX77686_REG_LDO1CTRL1		= 0x40,
+	MAX77686_REG_LDO2CTRL1		= 0x41,
+	MAX77686_REG_LDO3CTRL1		= 0x42,
+	MAX77686_REG_LDO4CTRL1		= 0x43,
+	MAX77686_REG_LDO5CTRL1		= 0x44,
+	MAX77686_REG_LDO6CTRL1		= 0x45,
+	MAX77686_REG_LDO7CTRL1		= 0x46,
+	MAX77686_REG_LDO8CTRL1		= 0x47,
+	MAX77686_REG_LDO9CTRL1		= 0x48,
+	MAX77686_REG_LDO10CTRL1		= 0x49,
+	MAX77686_REG_LDO11CTRL1		= 0x4A,
+	MAX77686_REG_LDO12CTRL1		= 0x4B,
+	MAX77686_REG_LDO13CTRL1		= 0x4C,
+	MAX77686_REG_LDO14CTRL1		= 0x4D,
+	MAX77686_REG_LDO15CTRL1		= 0x4E,
+	MAX77686_REG_LDO16CTRL1		= 0x4F,
+	MAX77686_REG_LDO17CTRL1		= 0x50,
+	MAX77686_REG_LDO18CTRL1		= 0x51,
+	MAX77686_REG_LDO19CTRL1		= 0x52,
+	MAX77686_REG_LDO20CTRL1		= 0x53,
+	MAX77686_REG_LDO21CTRL1		= 0x54,
+	MAX77686_REG_LDO22CTRL1		= 0x55,
+	MAX77686_REG_LDO23CTRL1		= 0x56,
+	MAX77686_REG_LDO24CTRL1		= 0x57,
+	MAX77686_REG_LDO25CTRL1		= 0x58,
+	MAX77686_REG_LDO26CTRL1		= 0x59,
+	/* Reserved: 0x5A-0x5F */
+	MAX77686_REG_LDO1CTRL2		= 0x60,
+	MAX77686_REG_LDO2CTRL2		= 0x61,
+	MAX77686_REG_LDO3CTRL2		= 0x62,
+	MAX77686_REG_LDO4CTRL2		= 0x63,
+	MAX77686_REG_LDO5CTRL2		= 0x64,
+	MAX77686_REG_LDO6CTRL2		= 0x65,
+	MAX77686_REG_LDO7CTRL2		= 0x66,
+	MAX77686_REG_LDO8CTRL2		= 0x67,
+	MAX77686_REG_LDO9CTRL2		= 0x68,
+	MAX77686_REG_LDO10CTRL2		= 0x69,
+	MAX77686_REG_LDO11CTRL2		= 0x6A,
+	MAX77686_REG_LDO12CTRL2		= 0x6B,
+	MAX77686_REG_LDO13CTRL2		= 0x6C,
+	MAX77686_REG_LDO14CTRL2		= 0x6D,
+	MAX77686_REG_LDO15CTRL2		= 0x6E,
+	MAX77686_REG_LDO16CTRL2		= 0x6F,
+	MAX77686_REG_LDO17CTRL2		= 0x70,
+	MAX77686_REG_LDO18CTRL2		= 0x71,
+	MAX77686_REG_LDO19CTRL2		= 0x72,
+	MAX77686_REG_LDO20CTRL2		= 0x73,
+	MAX77686_REG_LDO21CTRL2		= 0x74,
+	MAX77686_REG_LDO22CTRL2		= 0x75,
+	MAX77686_REG_LDO23CTRL2		= 0x76,
+	MAX77686_REG_LDO24CTRL2		= 0x77,
+	MAX77686_REG_LDO25CTRL2		= 0x78,
+	MAX77686_REG_LDO26CTRL2		= 0x79,
+	/* Reserved: 0x7A-0x7D */
+
+	MAX77686_REG_BBAT_CHG		= 0x7E,
+	MAX77686_REG_32KHZ_		= 0x7F,
+
+	MAX77686_REG_PMIC_END		= 0x80,
+};
+
+enum max77686_rtc_reg {
+	MAX77686_RTC_INT		= 0x00,
+	MAX77686_RTC_INTM		= 0x01,
+	MAX77686_RTC_CONTROLM		= 0x02,
+	MAX77686_RTC_CONTROL		= 0x03,
+	MAX77686_RTC_UPDATE0		= 0x04,
+	/* Reserved: 0x5 */
+	MAX77686_WTSR_SMPL_CNTL		= 0x06,
+	MAX77686_RTC_SEC		= 0x07,
+	MAX77686_RTC_MIN		= 0x08,
+	MAX77686_RTC_HOUR		= 0x09,
+	MAX77686_RTC_WEEKDAY		= 0x0A,
+	MAX77686_RTC_MONTH		= 0x0B,
+	MAX77686_RTC_YEAR		= 0x0C,
+	MAX77686_RTC_DATE		= 0x0D,
+	MAX77686_ALARM1_SEC		= 0x0E,
+	MAX77686_ALARM1_MIN		= 0x0F,
+	MAX77686_ALARM1_HOUR		= 0x10,
+	MAX77686_ALARM1_WEEKDAY		= 0x11,
+	MAX77686_ALARM1_MONTH		= 0x12,
+	MAX77686_ALARM1_YEAR		= 0x13,
+	MAX77686_ALARM1_DATE		= 0x14,
+	MAX77686_ALARM2_SEC		= 0x15,
+	MAX77686_ALARM2_MIN		= 0x16,
+	MAX77686_ALARM2_HOUR		= 0x17,
+	MAX77686_ALARM2_WEEKDAY		= 0x18,
+	MAX77686_ALARM2_MONTH		= 0x19,
+	MAX77686_ALARM2_YEAR		= 0x1A,
+	MAX77686_ALARM2_DATE		= 0x1B,
+};
+
+#define MAX77686_IRQSRC_PMIC		(0)
+#define MAX77686_IRQSRC_RTC		(1 << 0)
+
+enum max77686_irq_source {
+	PMIC_INT1 = 0,
+	PMIC_INT2,
+	RTC_INT,
+
+	MAX77686_IRQ_GROUP_NR,
+};
+
+enum max77686_irq {
+	MAX77686_PMICIRQ_PWRONF = 0,
+	MAX77686_PMICIRQ_PWRONR,
+	MAX77686_PMICIRQ_JIGONBF,
+	MAX77686_PMICIRQ_JIGONBR,
+	MAX77686_PMICIRQ_ACOKBF,
+	MAX77686_PMICIRQ_ACOKBR,
+	MAX77686_PMICIRQ_ONKEY1S,
+	MAX77686_PMICIRQ_MRSTB,
+
+	MAX77686_PMICIRQ_140C,
+	MAX77686_PMICIRQ_120C,
+
+	MAX77686_RTCIRQ_RTC60S = 16,
+	MAX77686_RTCIRQ_RTCA1,
+	MAX77686_RTCIRQ_RTCA2,
+	MAX77686_RTCIRQ_SMPL,
+	MAX77686_RTCIRQ_RTC1S,
+	MAX77686_RTCIRQ_WTSR,
+
+	MAX77686_IRQ_NR,
+};
+
+struct max77686_dev {
+	struct device *dev;
+	struct i2c_client *i2c; /* 0xcc / PMIC, Battery Control, and FLASH */
+	struct i2c_client *rtc; /* slave addr 0x0c */
+	struct mutex iolock;
+	int type;
+	int irq;
+	bool wakeup;
+	struct mutex irqlock;
+	int irq_masks_cur[MAX77686_IRQ_GROUP_NR];
+	int irq_masks_cache[MAX77686_IRQ_GROUP_NR];
+	struct irq_domain *irq_domain;
+	struct max77686_platform_data *pdata;
+};
+
+extern int max77686_irq_init(struct max77686_dev *max77686);
+extern void max77686_irq_exit(struct max77686_dev *max77686);
+extern int max77686_irq_resume(struct max77686_dev *max77686);
+
+extern int max77686_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest);
+extern int max77686_bulk_read(struct i2c_client *i2c, u8 reg, int count,
+				u8 *buf);
+extern int max77686_write_reg(struct i2c_client *i2c, u8 reg, u8 value);
+extern int max77686_bulk_write(struct i2c_client *i2c, u8 reg, int count,
+				u8 *buf);
+extern int max77686_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask);
+
+extern int max77686_debug_mask;		/* enables debug prints */
+
+enum {
+	MAX77686_DEBUG_INFO = 1 << 0,
+	MAX77686_DEBUG_MASK = 1 << 1,
+	MAX77686_DEBUG_INT = 1 << 2,
+};
+
+#ifndef CONFIG_DEBUG_MAX77686
+
+#define dbg_mask(fmt, ...) do { } while (0)
+#define dbg_info(fmt, ...) do { } while (0)
+#define dbg_int(fmt, ...) do { } while (0)
+
+#else
+
+#define dbg_mask(fmt, ...)					\
+do {								\
+	if (max77686_debug_mask & MAX77686_DEBUG_MASK)		\
+		printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__);	\
+} while (0)
+
+#define dbg_info(fmt, ...)					\
+do {								\
+	if (max77686_debug_mask & MAX77686_DEBUG_INFO)		\
+		printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__);	\
+} while (0)
+
+#define dbg_int(fmt, ...)					\
+do {								\
+	if (max77686_debug_mask & MAX77686_DEBUG_INT)		\
+		printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__);	\
+} while (0)
+#endif /* DEBUG_MAX77686 */
+
+#endif /*  __LINUX_MFD_MAX77686_PRIV_H */
diff --git a/include/linux/mfd/max77686.h b/include/linux/mfd/max77686.h
new file mode 100644
index 0000000..92baa07
--- /dev/null
+++ b/include/linux/mfd/max77686.h
@@ -0,0 +1,104 @@
+/*
+ * max77686.h - Driver for the Maxim 77686
+ *
+ *  Copyright (C) 2011 Samsung Electrnoics
+ *  Chiwoong Byun <woong.byun@samsung.com>
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
+ * This driver is based on max8997.h
+ *
+ * MAX77686 has PMIC, RTC devices.
+ * The devices share the same I2C bus and included in
+ * this mfd driver.
+ */
+
+#ifndef __LINUX_MFD_MAX77686_H
+#define __LINUX_MFD_MAX77686_H
+
+#include <linux/regulator/consumer.h>
+
+/* MAX77686 regulator IDs */
+enum max77686_regulators {
+	MAX77686_LDO1 = 0,
+	MAX77686_LDO2,
+	MAX77686_LDO3,
+	MAX77686_LDO4,
+	MAX77686_LDO5,
+	MAX77686_LDO6,
+	MAX77686_LDO7,
+	MAX77686_LDO8,
+	MAX77686_LDO9,
+	MAX77686_LDO10,
+	MAX77686_LDO11,
+	MAX77686_LDO12,
+	MAX77686_LDO13,
+	MAX77686_LDO14,
+	MAX77686_LDO15,
+	MAX77686_LDO16,
+	MAX77686_LDO17,
+	MAX77686_LDO18,
+	MAX77686_LDO19,
+	MAX77686_LDO20,
+	MAX77686_LDO21,
+	MAX77686_LDO22,
+	MAX77686_LDO23,
+	MAX77686_LDO24,
+	MAX77686_LDO25,
+	MAX77686_LDO26,
+	MAX77686_BUCK1,
+	MAX77686_BUCK2,
+	MAX77686_BUCK3,
+	MAX77686_BUCK4,
+	MAX77686_BUCK5,
+	MAX77686_BUCK6,
+	MAX77686_BUCK7,
+	MAX77686_BUCK8,
+	MAX77686_BUCK9,
+	MAX77686_EN32KHZ_AP,
+	MAX77686_EN32KHZ_CP,
+	MAX77686_P32KH,
+
+	MAX77686_REG_MAX,
+};
+
+enum max77686_ramp_rate {
+	MAX77686_RAMP_RATE_13MV = 0,
+	MAX77686_RAMP_RATE_27MV,	/* default */
+	MAX77686_RAMP_RATE_55MV,
+	MAX77686_RAMP_RATE_100MV,
+};
+
+struct max77686_regulator_data {
+	int id;
+	struct regulator_init_data *initdata;
+	struct device_node *reg_node;
+};
+
+struct max77686_platform_data {
+	bool wakeup;
+	u8 ramp_delay;
+	struct max77686_regulator_data *regulators;
+	int num_regulators;
+	struct max77686_opmode_data *opmode_data;
+
+	/*
+	 * GPIO-DVS feature is not enabled with the current version of
+	 * MAX77686 driver. Buck2/3/4_voltages[0] is used as the default
+	 * voltage at probe.
+	 */
+};
+
+#endif /* __LINUX_MFD_MAX77686_H */
-- 
1.7.0.4

