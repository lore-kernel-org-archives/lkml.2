Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab0FNKdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 06:33:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53073 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003Ab0FNKdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 06:33:05 -0400
From: Luotao Fu <l.fu@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH 1/3 V2] mfd: add STMPE811 core support
Date: Mon, 14 Jun 2010 12:32:36 +0200
Message-Id: <1276511558-27121-2-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de>
References: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

STMPE811 is a multifunction device, which contains a GPIO controller, a
Touchscreen controller, an ADC and a temperature sensor. This patch adds a core
driver for this device. The driver provides core functionalities like accessing
the registers and management of subdevices. The device supports communication
through SPI and I2C interface. Currently we only support I2C.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
Acked-by: Jonathan Cameron<jic23@cam.ac.uk>
---
V2 Changes:
* remove inculding subsysstem headers from the device header file
* use genirq for irq management:
  * use request_threaded_irq for the main isr
  * register own irq chip and use nested irq callback for subdevice irqs.
* drop i2c client data cleaning up to let the i2c framework do the job.
* fix bogus usage of driver data in i2c device id table
* some formating fixes

 drivers/mfd/Kconfig          |    8 +
 drivers/mfd/Makefile         |    1 +
 drivers/mfd/stmpe811-core.c  |  393 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/stmpe811.h |  119 +++++++++++++
 4 files changed, 521 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/stmpe811-core.c
 create mode 100644 include/linux/mfd/stmpe811.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9da0e50..2c5388b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -482,6 +482,14 @@ config MFD_JANZ_CMODIO
 	  host many different types of MODULbus daughterboards, including
 	  CAN and GPIO controllers.
 
+config MFD_STMPE811
+	tristate "STMicroelectronics STMPE811"
+	depends on I2C
+	select MFD_CORE
+	help
+	  This is the core driver for the stmpe811 GPIO expander with touchscreen
+	  controller, ADC and temperature sensor.
+
 endif # MFD_SUPPORT
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index fb503e7..6a7ad83 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -71,3 +71,4 @@ obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
 obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
 obj-$(CONFIG_MFD_RDC321X)	+= rdc321x-southbridge.o
 obj-$(CONFIG_MFD_JANZ_CMODIO)	+= janz-cmodio.o
+obj-$(CONFIG_MFD_STMPE811)	+= stmpe811-core.o
diff --git a/drivers/mfd/stmpe811-core.c b/drivers/mfd/stmpe811-core.c
new file mode 100644
index 0000000..73840ae
--- /dev/null
+++ b/drivers/mfd/stmpe811-core.c
@@ -0,0 +1,393 @@
+/*
+ * stmpe811-core.c  --  core support for STMicroelectronics STMPE811 chip.
+ *
+ * based on pcf50633-core.c by Harald Welte <laforge@openmoko.org> and
+ * Balaji Rao <balajirrao@openmoko.org>
+ *
+ * (c)2010 Luotao Fu <l.fu@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+#include <linux/workqueue.h>
+#include <linux/irq.h>
+
+#include <linux/mfd/core.h>
+#include <linux/mfd/stmpe811.h>
+
+static struct mfd_cell stmpe811_ts_dev = {
+	.name = "stmpe811-ts",
+};
+
+static struct mfd_cell stmpe811_gpio_dev = {
+	.name = "stmpe811-gpio",
+};
+
+static void stmpe811_mask_work(struct work_struct *work)
+{
+	struct stmpe811 *stm = container_of(work, struct stmpe811, mask_work);
+
+	stmpe811_reg_write(stm, STMPE811_REG_INT_EN, stm->int_en_mask);
+
+	mutex_unlock(&stm->irq_mask_lock);
+}
+
+static void stmpe811_irq_mask(unsigned int irq)
+{
+	struct stmpe811 *stm = get_irq_chip_data(irq);
+	irq -= stm->irq_base;
+
+	mutex_lock(&stm->irq_mask_lock);
+
+	clear_bit(irq, &stm->int_en_mask);
+	schedule_work(&stm->mask_work);
+}
+
+static void stmpe811_irq_unmask(unsigned int irq)
+{
+	struct stmpe811 *stm = get_irq_chip_data(irq);
+	irq -= stm->irq_base;
+
+	mutex_lock(&stm->irq_mask_lock);
+
+	set_bit(irq, &stm->int_en_mask);
+	schedule_work(&stm->mask_work);
+}
+
+static struct irq_chip stmpe811_irq_chip = {
+	.name	= "stmpe811",
+	.mask	= stmpe811_irq_mask,
+	.unmask	= stmpe811_irq_unmask,
+};
+
+static int stmpe811_irq_init(struct stmpe811 *stm)
+{
+	struct stmpe811_platform_data *pdata = stm->pdata;
+	int base = stm->irq_base;
+	int irq;
+
+	for (irq = base; irq < base + STMPE811_NUM_IRQ; irq++) {
+		set_irq_chip_data(irq, stm);
+		set_irq_chip_and_handler(irq, &stmpe811_irq_chip,
+					 handle_edge_irq);
+		set_irq_nested_thread(irq, 1);
+#ifdef CONFIG_ARM
+		set_irq_flags(irq, IRQF_VALID);
+#else
+		set_irq_noprobe(irq);
+#endif
+	}
+
+	/* setup platform specific interrupt control flags and enable global
+	 * interrupt */
+	stmpe811_reg_write(stm, STMPE811_REG_INT_CTRL,
+			   STMPE811_INT_CTRL_GLOBAL_INT | pdata->int_conf);
+
+	return 0;
+}
+
+static void stmpe811_irq_remove(struct stmpe811 *stm)
+{
+	int base = stm->irq_base;
+	int irq;
+
+	for (irq = base; irq < base + STMPE811_NUM_IRQ; irq++) {
+#ifdef CONFIG_ARM
+		set_irq_flags(irq, 0);
+#endif
+		set_irq_chip_and_handler(irq, NULL, NULL);
+		set_irq_chip_data(irq, NULL);
+	}
+}
+
+static irqreturn_t stmpe811_irq(int irq, void *data)
+{
+	struct stmpe811 *stm = data;
+	int ret, bit;
+	u8 int_stat;
+
+	ret = stmpe811_reg_read(stm, STMPE811_REG_INT_STA, &int_stat);
+	if (ret) {
+		dev_err(stm->dev, "Error reading INT registers\n");
+		return IRQ_NONE;
+	}
+
+	dev_dbg(stm->dev, "%s int_stat 0x%02x\n", __func__, int_stat);
+
+	for_each_set_bit(bit, (unsigned long *)&int_stat, STMPE811_NUM_IRQ) {
+		/* mask the interrupt while calling handler */
+		stmpe811_reg_clear_bits(stm, STMPE811_REG_INT_EN, 1 << bit);
+
+		handle_nested_irq(stm->irq_base + bit);
+
+		/* acknowledge the interrupt */
+		stmpe811_reg_set_bits(stm, STMPE811_REG_INT_STA, 1 << bit);
+		/* demask the interrupt */
+		stmpe811_reg_set_bits(stm, STMPE811_REG_INT_EN, 1 << bit);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static inline int __stmpe811_i2c_reads(struct i2c_client *client, int reg,
+				       int len, u8 *val)
+{
+	int ret;
+
+	ret = i2c_smbus_read_i2c_block_data(client, reg, len, val);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed reading from 0x%02x\n", reg);
+		return ret;
+	}
+	return 0;
+}
+
+static inline int __stmpe811_i2c_read(struct i2c_client *client,
+				      int reg, u8 *val)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(client, reg);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed reading at 0x%02x\n", reg);
+		return ret;
+	}
+	dev_dbg(&client->dev, "%s: value 0x%x from 0x%x\n", __func__, ret, reg);
+
+	*val = (u8) ret;
+	return 0;
+}
+
+static inline int __stmpe811_i2c_write(struct i2c_client *client,
+				       int reg, u8 val)
+{
+	int ret;
+
+	ret = i2c_smbus_write_byte_data(client, reg, val);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed writing 0x%02x to 0x%02x\n",
+			val, reg);
+		return ret;
+	}
+	return 0;
+}
+
+int stmpe811_block_read(struct stmpe811 *stm, u8 reg, uint len, u8 *val)
+{
+	int ret;
+
+	mutex_lock(&stm->io_lock);
+	ret = __stmpe811_i2c_reads(stm->i2c_client, reg, len, val);
+	mutex_unlock(&stm->io_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(stmpe811_block_read);
+
+int stmpe811_reg_read(struct stmpe811 *stm, u8 reg, u8 *val)
+{
+	int ret;
+
+	mutex_lock(&stm->io_lock);
+	ret = __stmpe811_i2c_read(stm->i2c_client, reg, val);
+	mutex_unlock(&stm->io_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(stmpe811_reg_read);
+
+int stmpe811_reg_write(struct stmpe811 *stm, u8 reg, u8 val)
+{
+	int ret;
+
+	mutex_lock(&stm->io_lock);
+	ret = __stmpe811_i2c_write(stm->i2c_client, reg, val);
+	mutex_unlock(&stm->io_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(stmpe811_reg_write);
+
+int stmpe811_reg_set_bits(struct stmpe811 *stm, u8 reg, u8 val)
+{
+	int ret;
+	u8 tmp;
+
+	mutex_lock(&stm->io_lock);
+	ret = __stmpe811_i2c_read(stm->i2c_client, reg, &tmp);
+	if (ret < 0)
+		goto out;
+
+	tmp |= val;
+	ret = __stmpe811_i2c_write(stm->i2c_client, reg, tmp);
+
+out:
+	mutex_unlock(&stm->io_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(stmpe811_reg_set_bits);
+
+int stmpe811_reg_clear_bits(struct stmpe811 *stm, u8 reg, u8 val)
+{
+	int ret;
+	u8 tmp;
+
+	mutex_lock(&stm->io_lock);
+	ret = __stmpe811_i2c_read(stm->i2c_client, reg, &tmp);
+	if (ret < 0)
+		goto out;
+
+	tmp &= ~val;
+	ret = __stmpe811_i2c_write(stm->i2c_client, reg, tmp);
+
+out:
+	mutex_unlock(&stm->io_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(stmpe811_reg_clear_bits);
+
+static int __devinit stmpe811_probe(struct i2c_client *client,
+				    const struct i2c_device_id *ids)
+{
+	struct stmpe811 *stm;
+	struct stmpe811_platform_data *pdata = client->dev.platform_data;
+	int ret = 0;
+	u8 chip_id[2], chip_ver = 0;
+
+	if (!client->irq) {
+		dev_err(&client->dev, "Missing IRQ\n");
+		return -ENOENT;
+	}
+
+	stm = kzalloc(sizeof(*stm), GFP_KERNEL);
+	if (!stm)
+		return -ENOMEM;
+
+	stm->pdata = pdata;
+
+	mutex_init(&stm->io_lock);
+	mutex_init(&stm->irq_mask_lock);
+
+	i2c_set_clientdata(client, stm);
+	stm->dev = &client->dev;
+	stm->i2c_client = client;
+	stm->irq = client->irq;
+	stm->irq_base = pdata->irq_base;
+
+	INIT_WORK(&stm->mask_work, stmpe811_mask_work);
+
+	ret = stmpe811_block_read(stm, STMPE811_REG_CHIP_ID, 2, chip_id);
+	if ((ret < 0) || (((chip_id[0] << 8) | chip_id[1]) != 0x811)) {
+		dev_err(&client->dev, "could not verify  stmpe811 chip id\n");
+		ret = -ENODEV;
+		goto err_free;
+	}
+
+	stmpe811_reg_read(stm, STMPE811_REG_ID_VER, &chip_ver);
+	dev_info(&client->dev, "found stmpe811 chip id 0x%x version 0x%x\n",
+		 (chip_id[0] << 8) | chip_id[1], chip_ver);
+
+	/* reset the device */
+	stmpe811_reg_write(stm, STMPE811_REG_SYS_CTRL1,
+			   STMPE811_SYS_CTRL1_SOFT_RESET);
+
+	stmpe811_irq_init(stm);
+
+	ret = request_threaded_irq(client->irq, NULL, stmpe811_irq,
+				   pdata->irq_flags, "stmpe811", stm);
+	if (ret) {
+		dev_err(&client->dev, "failed to request IRQ: %d\n", ret);
+		goto err_free;
+	}
+
+	if (pdata->flags & STMPE811_USE_TS)
+		ret =
+		    mfd_add_devices(&client->dev, -1, &stmpe811_ts_dev, 1, NULL,
+				    0);
+	if (ret != 0)
+		goto err_release_irq;
+
+	if (pdata->flags & STMPE811_USE_GPIO)
+		ret =
+		    mfd_add_devices(&client->dev, -1, &stmpe811_gpio_dev, 1,
+				    NULL, 0);
+	if (ret != 0)
+		dev_err(&client->dev, "Unable to add mfd subdevices\n");
+
+	return ret;
+
+err_release_irq:
+	free_irq(client->irq, stm);
+err_free:
+	mutex_destroy(&stm->io_lock);
+	mutex_destroy(&stm->irq_mask_lock);
+
+	kfree(stm);
+
+	return ret;
+}
+
+static int __devexit stmpe811_remove(struct i2c_client *client)
+{
+	struct stmpe811 *stm = i2c_get_clientdata(client);
+
+	flush_work(&stm->mask_work);
+	stmpe811_reg_write(stm, STMPE811_REG_SYS_CTRL1,
+			   STMPE811_SYS_CTRL1_HIBERNATE);
+
+	stmpe811_irq_remove(stm);
+	free_irq(stm->irq, stm);
+
+	mutex_destroy(&stm->io_lock);
+	mutex_destroy(&stm->irq_mask_lock);
+
+	mfd_remove_devices(&client->dev);
+
+	kfree(stm);
+
+	return 0;
+}
+
+static struct i2c_device_id stmpe811_id_table[] = {
+	{"stmpe811", 0},
+	{ /* end of list */ }
+};
+
+static struct i2c_driver stmpe811_driver = {
+	.driver = {
+		   .name = "stmpe811",
+		   .owner = THIS_MODULE,
+		   },
+	.probe = stmpe811_probe,
+	.remove = __devexit_p(stmpe811_remove),
+	.id_table = stmpe811_id_table,
+};
+
+static int __init stmpe811_init(void)
+{
+	return i2c_add_driver(&stmpe811_driver);
+}
+
+subsys_initcall(stmpe811_init);
+
+static void __exit stmpe811_exit(void)
+{
+	i2c_del_driver(&stmpe811_driver);
+}
+
+module_exit(stmpe811_exit);
+
+MODULE_DESCRIPTION
+    ("CORE Driver for STMPE811 Touch screen controller with GPIO expander");
+MODULE_AUTHOR("Luotao Fu <l.fu@pengutronix.de>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/stmpe811.h b/include/linux/mfd/stmpe811.h
new file mode 100644
index 0000000..acd5aaf
--- /dev/null
+++ b/include/linux/mfd/stmpe811.h
@@ -0,0 +1,119 @@
+#ifndef __LINUX_MFD_STMPE811_H
+#define __LINUX_MFD_STMPE811_H
+
+#define STMPE811_REG_CHIP_ID		0x00
+#define STMPE811_REG_ID_VER		0x02
+#define STMPE811_REG_SYS_CTRL1		0x03
+#define STMPE811_REG_SYS_CTRL2		0x04
+#define STMPE811_REG_SPI_CFG		0x08
+#define STMPE811_REG_INT_CTRL		0x09
+#define STMPE811_REG_INT_EN		0x0A
+#define STMPE811_REG_INT_STA		0x0B
+#define STMPE811_REG_GPIO_EN		0x0C
+#define STMPE811_REG_GPIO_INT_STA	0x0D
+#define STMPE811_REG_ADC_INT_EN		0x0E
+#define STMPE811_REG_ADC_INT_STA	0x0F
+#define STMPE811_REG_GPIO_SET_PIN	0x10
+#define STMPE811_REG_GPIO_CLR_PIN	0x11
+#define STMPE811_REG_GPIO_MP_STA	0x12
+#define STMPE811_REG_GPIO_DIR		0x13
+#define STMPE811_REG_GPIO_ED		0x14
+#define STMPE811_REG_GPIO_RE		0x15
+#define STMPE811_REG_GPIO_FE		0x16
+#define STMPE811_REG_GPIO_AF		0x17
+#define STMPE811_REG_ADC_CTRL1		0x20
+#define STMPE811_REG_ADC_CTRL2		0x21
+#define STMPE811_REG_ADC_CAPT		0x22
+#define STMPE811_REG_ADC_DATA_CH0	0x30
+#define STMPE811_REG_ADC_DATA_CH1	0x32
+#define STMPE811_REG_ADC_DATA_CH2	0x34
+#define STMPE811_REG_ADC_DATA_CH3	0x36
+#define STMPE811_REG_ADC_DATA_CH4	0x38
+#define STMPE811_REG_ADC_DATA_CH5	0x3A
+#define STMPE811_REG_ADC_DATA_CH6	0x3C
+#define STMPE811_REG_ADC_DATA_CH7	0x3E
+#define STMPE811_REG_TSC_CTRL		0x40
+#define STMPE811_REG_TSC_CFG		0x41
+#define STMPE811_REG_WDW_TR_X		0x42
+#define STMPE811_REG_WDW_TR_Y		0x44
+#define STMPE811_REG_WDW_BL_X		0x46
+#define STMPE811_REG_WDW_BL_Y		0x48
+#define STMPE811_REG_FIFO_TH		0x4A
+#define STMPE811_REG_FIFO_STA		0x4B
+#define STMPE811_REG_FIFO_SIZE		0x4C
+#define STMPE811_REG_TSC_DATA_X		0x4D
+#define STMPE811_REG_TSC_DATA_Y		0x4F
+#define STMPE811_REG_TSC_DATA_Z		0x51
+#define STMPE811_REG_TSC_DATA_XYZ	0x52
+#define STMPE811_REG_TSC_FRACTION_Z	0x56
+#define STMPE811_REG_TSC_DATA		0x57
+#define STMPE811_REG_TSC_DATA_SINGLE	0xD7
+#define STMPE811_REG_TSC_I_DRIVE	0x58
+#define STMPE811_REG_TSC_SHIELD		0x59
+#define STMPE811_REG_TEMP_CTRL		0x60
+
+#define STMPE811_SYS_CTRL1_HIBERNATE	(1<<0)
+#define STMPE811_SYS_CTRL1_SOFT_RESET	(1<<1)
+
+#define STMPE811_SYS_CTRL2_ADC_OFF	(1<<0)
+#define STMPE811_SYS_CTRL2_TSC_OFF	(1<<1)
+#define STMPE811_SYS_CTRL2_GPIO_OFF	(1<<2)
+#define STMPE811_SYS_CTRL2_TS_OFF	(1<<3)
+
+#define STMPE811_INT_CTRL_GLOBAL_INT	(1<<0)
+#define STMPE811_INT_CTRL_INT_TYPE	(1<<1)
+#define STMPE811_INT_CTRL_INT_POLARITY	(1<<2)
+
+#define STMPE811_FIFO_STA_OFLOW		(1<<7)
+#define STMPE811_FIFO_STA_FULL		(1<<6)
+#define STMPE811_FIFO_STA_EMPTY		(1<<5)
+#define STMPE811_FIFO_STA_TH_TRIG	(1<<4)
+#define STMPE811_FIFO_STA_RESET		(1<<0)
+
+#define STMPE811_USE_TS			(1<<0)
+#define STMPE811_USE_GPIO		(1<<1)
+
+#define STMPE811_IRQ_TOUCH_DET		0
+#define STMPE811_IRQ_FIFO_TH		1
+#define STMPE811_IRQ_FIFO_OFLOW		2
+#define STMPE811_IRQ_FIFO_FULL		3
+#define STMPE811_IRQ_FIFO_EMPTY		4
+#define STMPE811_IRQ_TEMP_SENS		5
+#define STMPE811_IRQ_ADC		6
+#define STMPE811_IRQ_GPIO		7
+#define STMPE811_NUM_IRQ		8
+
+struct stmpe811 {
+	struct device *dev;
+	struct i2c_client *i2c_client;
+	struct work_struct mask_work;
+	struct stmpe811_platform_data *pdata;
+	struct mutex io_lock;
+	struct mutex irq_mask_lock;
+	unsigned int irq;
+	int irq_base;
+	unsigned long int_en_mask;
+	u8 active_flag;
+};
+
+struct stmpe811_gpio_platform_data {
+	unsigned int gpio_base;
+	int (*setup) (struct stmpe811 *stm);
+	void (*remove) (struct stmpe811 *stm);
+};
+
+struct stmpe811_platform_data {
+	unsigned int flags;
+	unsigned int irq_flags;
+	unsigned int int_conf;
+	int irq_base;
+	struct stmpe811_gpio_platform_data *gpio_pdata;
+};
+
+int stmpe811_block_read(struct stmpe811 *stm, u8 reg, uint len, u8 *val);
+int stmpe811_reg_read(struct stmpe811 *pcf, u8 reg, u8 *val);
+int stmpe811_reg_write(struct stmpe811 *stm, u8 reg, u8 val);
+int stmpe811_reg_set_bits(struct stmpe811 *stm, u8 reg, u8 val);
+int stmpe811_reg_clear_bits(struct stmpe811 *stm, u8 reg, u8 val);
+
+#endif
-- 
1.7.1

