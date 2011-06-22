Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1FVGCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 02:02:30 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:53391 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1FVGBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 02:01:48 -0400
From: Sangbeom Kim <sbkim73@samsung.com>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>
Subject: [PATCH 2/3] mfd: Add initial S5M8751 support
Date: Wed, 22 Jun 2011 14:53:56 +0900
Message-Id: <1308722037-6966-3-git-send-email-sbkim73@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1308722037-6966-1-git-send-email-sbkim73@samsung.com>
References: <1308722037-6966-1-git-send-email-sbkim73@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8994 is a advanced PMIC with AUdio DAC
Since it includes regulators, Battery charger, audio dac,
it is represented as a multi-function device,
though the functionality will be provided by the each driver.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/mfd/Kconfig        |    3 +
 drivers/mfd/Makefile       |    2 +
 drivers/mfd/s5m8751-core.c |  358 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 363 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/s5m8751-core.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 0f09c05..85c91ac 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -385,6 +385,9 @@ config MFD_WM831X_SPI
 	  for accessing the device, additional drivers must be enabled in
 	  order to use the functionality of the device.
 
+config MFD_S5M8751
+	tristate
+
 config MFD_WM8350
 	bool
 	depends on GENERIC_HARDIRQS
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index efe3cc3..27f99bb 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -94,3 +94,5 @@ obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o
 obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o
 obj-$(CONFIG_MFD_PM8XXX_IRQ) 	+= pm8xxx-irq.o
 obj-$(CONFIG_MFD_TPS65910)	+= tps65910.o tps65910-irq.o
+s5m8751-objs			+= s5m8751-core.o
+obj-$(CONFIG_MFD_S5M8751)	+= s5m8751.o
diff --git a/drivers/mfd/s5m8751-core.c b/drivers/mfd/s5m8751-core.c
new file mode 100644
index 0000000..3f15d08
--- /dev/null
+++ b/drivers/mfd/s5m8751-core.c
@@ -0,0 +1,358 @@
+/* linux/drivers/mfd/s5m8751-core.c
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * S5M8751 core driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/platform_device.h>
+
+#include <linux/mfd/s5m8751.h>
+
+#define SLEEPB_ENABLE		1
+#define SLEEPB_DISABLE		0
+
+static DEFINE_MUTEX(io_mutex);
+
+int s5m8751_clear_bits(struct s5m8751 *s5m8751, uint8_t reg, uint8_t mask)
+{
+	uint8_t reg_val;
+	int ret = 0;
+
+	ret = s5m8751_reg_read(s5m8751, reg, &reg_val);
+	if (ret)
+		return ret;
+
+	reg_val &= ~mask;
+	ret = s5m8751_reg_write(s5m8751, reg, reg_val);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(s5m8751_clear_bits);
+
+int s5m8751_set_bits(struct s5m8751 *s5m8751, uint8_t reg, uint8_t mask)
+{
+	uint8_t reg_val;
+	int ret = 0;
+
+	ret = s5m8751_reg_read(s5m8751, reg, &reg_val);
+	if (ret)
+		return ret;
+
+	reg_val |= mask;
+	ret = s5m8751_reg_write(s5m8751, reg, reg_val);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(s5m8751_set_bits);
+
+int s5m8751_reg_read(struct s5m8751 *s5m8751, uint8_t reg, uint8_t *val)
+{
+	int ret = 0;
+
+	mutex_lock(&io_mutex);
+	ret = s5m8751->read_dev(s5m8751, reg, val);
+	if (ret < 0)
+		dev_err(s5m8751->dev, "failed reading from 0x%02x\n", reg);
+
+	mutex_unlock(&io_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(s5m8751_reg_read);
+
+int s5m8751_reg_write(struct s5m8751 *s5m8751, uint8_t reg, uint8_t val)
+{
+	int ret = 0;
+
+	mutex_lock(&io_mutex);
+	ret = s5m8751->write_dev(s5m8751, reg, val);
+	if (ret < 0)
+		dev_err(s5m8751->dev, "failed writing 0x%02x\n", reg);
+
+	mutex_unlock(&io_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(s5m8751_reg_write);
+
+int s5m8751_block_read(struct s5m8751 *s5m8751, uint8_t reg, int len,
+			uint8_t *val)
+{
+	int ret = 0;
+
+	mutex_lock(&io_mutex);
+	ret = s5m8751->read_block_dev(s5m8751, reg, len, val);
+	if (ret < 0)
+		dev_err(s5m8751->dev, "failed reading from 0x%02x\n", reg);
+
+	mutex_unlock(&io_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(s5m8751_block_read);
+
+int s5m8751_block_write(struct s5m8751 *s5m8751, uint8_t reg, int len,
+			uint8_t *val)
+{
+	int ret = 0;
+
+	mutex_lock(&io_mutex);
+	ret = s5m8751->write_block_dev(s5m8751, reg, len, val);
+	if (ret < 0)
+		dev_err(s5m8751->dev, "failed writings to 0x%02x\n", reg);
+
+	mutex_unlock(&io_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(s5m8751_block_write);
+
+static void s5m8751_irq_call_handler(struct s5m8751 *s5m8751, int irq)
+{
+	mutex_lock(&s5m8751->irq_mutex);
+
+	if (s5m8751->irq[irq].handler)
+		s5m8751->irq[irq].handler(s5m8751, irq, s5m8751->irq[irq].data);
+	else {
+		dev_err(s5m8751->dev, "irq %d nobody cared. now masked.\n",
+			irq);
+		s5m8751_mask_irq(s5m8751, irq);
+	}
+
+	mutex_unlock(&s5m8751->irq_mutex);
+}
+
+/*
+ * s5m8751_irq_worker actually handles the interrupts.
+ * All interrupts must be clear after reading the event registers.
+ */
+static void s5m8751_irq_worker(struct work_struct *work)
+{
+	struct s5m8751 *s5m8751 = container_of(work, struct s5m8751, irq_work);
+	uint8_t event1, event2, mask1, mask2;
+
+	s5m8751_reg_read(s5m8751, S5M8751_IRQB_EVENT1, &event1);
+	s5m8751_reg_read(s5m8751, S5M8751_IRQB_EVENT2, &event2);
+	s5m8751_reg_read(s5m8751, S5M8751_IRQB_MASK1, &mask1);
+	s5m8751_reg_read(s5m8751, S5M8751_IRQB_MASK2, &mask2);
+
+	event1 &= ~mask1;
+	event2 &= ~mask2;
+
+	if (event1 & S5M8751_MASK_PWRKEY1B)
+		s5m8751_irq_call_handler(s5m8751, S5M8751_IRQ_PWRKEY1B);
+
+	if (event1 & S5M8751_MASK_PWRKEY2B)
+		s5m8751_irq_call_handler(s5m8751, S5M8751_IRQ_PWRKEY2B);
+
+	if (event1 & S5M8751_MASK_PWRKEY3)
+		s5m8751_irq_call_handler(s5m8751, S5M8751_IRQ_PWRKEY3);
+
+	if (event2 & S5M8751_MASK_VCHG_DET)
+		s5m8751_irq_call_handler(s5m8751, S5M8751_IRQ_VCHG_DETECTION);
+
+	if (event2 & S5M8751_MASK_VCHG_REM)
+		s5m8751_irq_call_handler(s5m8751,
+					S5M8751_IRQ_VCHG_REMOVAL);
+
+	if (event2 & S5M8751_MASK_CHG_T_OUT)
+		s5m8751_irq_call_handler(s5m8751, S5M8751_IRQ_CHARGER_TIMEOUT);
+
+	enable_irq(s5m8751->chip_irq);
+	s5m8751_clear_irq(s5m8751);
+}
+
+static irqreturn_t s5m8751_irq(int irq, void *data)
+{
+	struct s5m8751 *s5m8751 = data;
+
+	disable_irq_nosync(irq);
+	schedule_work(&s5m8751->irq_work);
+
+	return IRQ_HANDLED;
+}
+
+int s5m8751_register_irq(struct s5m8751 *s5m8751, int irq,
+			void (*handler) (struct s5m8751 *, int, void *),
+			void *data)
+
+{
+	if (irq < 0 || irq > S5M8751_NUM_IRQ || !handler)
+		return -EINVAL;
+
+	if (s5m8751->irq[irq].handler)
+		return -EBUSY;
+
+	mutex_lock(&s5m8751->irq_mutex);
+	s5m8751->irq[irq].handler = handler;
+	s5m8751->irq[irq].data = data;
+	mutex_unlock(&s5m8751->irq_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(s5m8751_register_irq);
+
+int s5m8751_free_irq(struct s5m8751 *s5m8751, int irq)
+{
+	if (irq < 0 || irq > S5M8751_NUM_IRQ)
+		return -EINVAL;
+
+	mutex_lock(&s5m8751->irq_mutex);
+	s5m8751->irq[irq].handler = NULL;
+	mutex_unlock(&s5m8751->irq_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(s5m8751_free_irq);
+
+int s5m8751_mask_irq(struct s5m8751 *s5m8751, int irq)
+{
+	switch (irq) {
+	case S5M8751_IRQ_PWRKEY1B:
+		return s5m8751_set_bits(s5m8751, S5M8751_IRQB_MASK1,
+					 S5M8751_MASK_PWRKEY1B);
+	case S5M8751_IRQ_PWRKEY2B:
+		return s5m8751_set_bits(s5m8751, S5M8751_IRQB_MASK1,
+					 S5M8751_MASK_PWRKEY2B);
+	case S5M8751_IRQ_PWRKEY3:
+		return s5m8751_set_bits(s5m8751, S5M8751_IRQB_MASK1,
+					 S5M8751_MASK_PWRKEY3);
+	case S5M8751_IRQ_VCHG_DETECTION:
+		return s5m8751_set_bits(s5m8751, S5M8751_IRQB_MASK2,
+					 S5M8751_MASK_VCHG_DET);
+	case S5M8751_IRQ_VCHG_REMOVAL:
+		return s5m8751_set_bits(s5m8751, S5M8751_IRQB_MASK2,
+					 S5M8751_MASK_VCHG_REM);
+	case S5M8751_IRQ_CHARGER_TIMEOUT:
+		return s5m8751_set_bits(s5m8751, S5M8751_IRQB_MASK2,
+					 S5M8751_MASK_CHG_T_OUT);
+	default:
+		dev_warn(s5m8751->dev, "Attempting to unmask unknown IRQ %d\n",
+			irq);
+			return -EINVAL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(s5m8751_mask_irq);
+
+int s5m8751_unmask_irq(struct s5m8751 *s5m8751, int irq)
+{
+	switch (irq) {
+	case S5M8751_IRQ_PWRKEY1B:
+		return s5m8751_clear_bits(s5m8751, S5M8751_IRQB_MASK1,
+					 S5M8751_MASK_PWRKEY1B);
+	case S5M8751_IRQ_PWRKEY2B:
+		return s5m8751_clear_bits(s5m8751, S5M8751_IRQB_MASK1,
+					 S5M8751_MASK_PWRKEY2B);
+	case S5M8751_IRQ_PWRKEY3:
+		return s5m8751_clear_bits(s5m8751, S5M8751_IRQB_MASK1,
+					 S5M8751_MASK_PWRKEY3);
+	case S5M8751_IRQ_VCHG_DETECTION:
+		return s5m8751_clear_bits(s5m8751, S5M8751_IRQB_MASK2,
+					 S5M8751_MASK_VCHG_DET);
+	case S5M8751_IRQ_VCHG_REMOVAL:
+		return s5m8751_clear_bits(s5m8751, S5M8751_IRQB_MASK2,
+					 S5M8751_MASK_VCHG_REM);
+	case S5M8751_IRQ_CHARGER_TIMEOUT:
+		return s5m8751_clear_bits(s5m8751, S5M8751_IRQB_MASK2,
+					 S5M8751_MASK_CHG_T_OUT);
+	default:
+		dev_warn(s5m8751->dev, "Attempting to unmask unknown IRQ %d\n",
+			irq);
+		return -EINVAL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(s5m8751_unmask_irq);
+
+int s5m8751_clear_irq(struct s5m8751 *s5m8751)
+{
+	uint8_t event = 0x00;
+
+	s5m8751_reg_write(s5m8751, S5M8751_IRQB_EVENT1, event);
+	s5m8751_reg_write(s5m8751, S5M8751_IRQB_EVENT2, event);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(s5m8751_clear_irq);
+
+static int s5m8751_sleepb_set(struct s5m8751 *s5m8751, int enable)
+{
+	if (enable)
+		s5m8751_set_bits(s5m8751, S5M8751_ONOFF1,
+				S5M8751_SLEEPB_PIN_ENABLE);
+	else
+		s5m8751_clear_bits(s5m8751, S5M8751_ONOFF1,
+				S5M8751_SLEEPB_PIN_ENABLE);
+	return 0;
+}
+
+int s5m8751_device_init(struct s5m8751 *s5m8751, int irq,
+			struct s5m8751_platform_data *pdata)
+{
+	int ret = -EINVAL;
+	u8 chip_id;
+
+	if (pdata->init) {
+		ret = pdata->init(s5m8751);
+		if (ret != 0) {
+			dev_err(s5m8751->dev,
+			 "Platform init() failed: %d\n", ret);
+			goto err;
+		}
+	}
+
+	s5m8751_reg_read(s5m8751, S5M8751_CHIP_ID, &chip_id);
+	if (!chip_id)
+		dev_info(s5m8751->dev, "Found S5M8751 device\n");
+	else {
+		dev_info(s5m8751->dev, "Didn't Find S5M8751 device\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	s5m8751_clear_irq(s5m8751);
+	s5m8751_sleepb_set(s5m8751, SLEEPB_ENABLE);
+
+	mutex_init(&s5m8751->irq_mutex);
+	INIT_WORK(&s5m8751->irq_work, s5m8751_irq_worker);
+	if (irq) {
+		ret = request_irq(irq, s5m8751_irq, 0,
+				  "s5m8751", s5m8751);
+		if (ret != 0) {
+			dev_err(s5m8751->dev, "Failed to request IRQ: %d\n",
+				ret);
+			goto err;
+		}
+	} else {
+		dev_err(s5m8751->dev, "No IRQ configured\n");
+		goto err;
+	}
+	s5m8751->chip_irq = irq;
+
+	return 0;
+
+err:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(s5m8751_device_init);
+
+void s5m8751_device_exit(struct s5m8751 *s5m8751)
+{
+	dev_info(s5m8751->dev, "Unloaded S5M8751 device\n");
+
+	free_irq(s5m8751->chip_irq, s5m8751);
+	flush_work(&s5m8751->irq_work);
+}
+EXPORT_SYMBOL_GPL(s5m8751_device_exit);
+
+MODULE_DESCRIPTION("Core driver for Samsung S5M8751");
+MODULE_AUTHOR("Sangbeom Kim <sbkim73@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.1

