Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab1CREHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:07:33 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:52934 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab1CREHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:07:19 -0400
X-ASG-Debug-ID: 1300421238-082cb9230001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: grant.likely@secretlab.ca, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH] gpio: enable expander pca957x
Subject: [PATCH] gpio: enable expander pca957x
Date: Fri, 18 Mar 2011 12:04:58 +0800
X-ASG-Orig-Subj: [PATCH] gpio: enable expander pca957x
Message-Id: <1300421098-12758-1-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1300421238
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support both PCA9574(8-bit) and PCA9575(16-bit) gpio expander.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/gpio/Kconfig        |   14 ++
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/pca957x.c      |  491 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/pca957x.h |   28 +++
 4 files changed, 534 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/pca957x.c
 create mode 100644 include/linux/i2c/pca957x.h

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 7ef9108..28be09a 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -191,6 +191,20 @@ config GPIO_PCA953X_IRQ
 	  Say yes here to enable the pca953x to be used as an interrupt
 	  controller. It requires the driver to be built in the kernel.
 
+config GPIO_PCA957X
+	tristate "PCA957x I/O ports"
+	depends on I2C
+	help
+	  Say yes here to provide access several register-oriented
+	  SMBus I/O expanders. Compatible models include:
+
+	  8 bits:	pca9574
+
+	  16 bits:	pca9575
+
+	  This driver can also be built as a module. If so, the module
+	  will be called pca957x
+
 config GPIO_PCF857X
 	tristate "PCF857x, PCA{85,96}7x, and MAX732[89] I2C GPIO expanders"
 	depends on I2C
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 3351cf8..6d941bd 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_GPIO_74X164)	+= 74x164.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
+obj-$(CONFIG_GPIO_PCA957X)	+= pca957x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_GPIO_PCH)		+= pch_gpio.o
 obj-$(CONFIG_GPIO_PL061)	+= pl061.o
diff --git a/drivers/gpio/pca957x.c b/drivers/gpio/pca957x.c
new file mode 100644
index 0000000..9d8ceb1
--- /dev/null
+++ b/drivers/gpio/pca957x.c
@@ -0,0 +1,491 @@
+/*
+ *  pca957x.c - 8/16 bit I/O ports
+ *
+ *  Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
+ *  Copyright (C) 2007 Marvell International Ltd.
+ *
+ *  Derived from drivers/i2c/chips/pca9539.c
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/i2c/pca957x.h>
+
+#define PCA957X_IN	0
+#define PCA957X_INVRT	1
+#define PCA957X_BKEN	2
+#define PCA957X_PUPD	3
+#define PCA957X_CFG	4
+#define PCA957X_OUT	5
+#define PCA957X_MSK	6
+#define PCA957X_INTS	7
+
+static const struct i2c_device_id pca957x_id[] = {
+	{ "pca9574", 8, },
+	{ "pca9575", 16, },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, pca957x_id);
+
+struct pca957x_chip {
+	unsigned	gpio_start;
+	uint16_t	reg_output;
+	uint16_t	reg_direction;
+
+	struct		i2c_client *client;
+	struct		gpio_chip gpio_chip;
+	struct mutex	irq_lock;
+	uint16_t	irq_mask;
+	uint16_t	irq_stat;
+	uint16_t	irq_trig_raise;
+	uint16_t	irq_trig_fall;
+	int		irq_base;
+};
+
+static int pca957x_read_reg(struct pca957x_chip *chip, int reg, uint16_t *val)
+{
+	int ret;
+
+	if (chip->gpio_chip.ngpio <= 8)
+		ret = i2c_smbus_read_byte_data(chip->client, reg);
+	else
+		ret = i2c_smbus_read_word_data(chip->client, reg << 1);
+
+	if (ret < 0) {
+		dev_err(&chip->client->dev, "failed reading register\n");
+		return ret;
+	}
+
+	*val = (uint16_t)ret;
+	return 0;
+}
+
+static int pca957x_write_reg(struct pca957x_chip *chip, int reg, uint16_t val)
+{
+	int ret;
+
+	if (chip->gpio_chip.ngpio <= 8)
+		ret = i2c_smbus_write_byte_data(chip->client, reg, val);
+	else {
+		ret = i2c_smbus_write_byte_data(chip->client, reg << 1,
+						val & 0xff);
+		if (!ret) {
+			ret = i2c_smbus_write_byte_data(chip->client,
+							(reg << 1) + 1,
+							(val & 0xff00) >> 8);
+		}
+	}
+
+	if (ret < 0) {
+		dev_err(&chip->client->dev, "failed writing register\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int pca957x_gpio_direction_input(struct gpio_chip *gc, unsigned off)
+{
+	struct pca957x_chip *chip;
+	uint16_t reg_val;
+	int ret;
+
+	chip = container_of(gc, struct pca957x_chip, gpio_chip);
+
+	reg_val = chip->reg_direction | (1u << off);
+	ret = pca957x_write_reg(chip, PCA957X_CFG, reg_val);
+	if (ret)
+		return ret;
+
+	chip->reg_direction = reg_val;
+	return 0;
+}
+
+static int pca957x_gpio_direction_output(struct gpio_chip *gc,
+					 unsigned off, int val)
+{
+	struct pca957x_chip *chip;
+	uint16_t reg_val;
+	int ret;
+
+	chip = container_of(gc, struct pca957x_chip, gpio_chip);
+
+	/* set output level */
+	if (val)
+		reg_val = chip->reg_output | (1u << off);
+	else
+		reg_val = chip->reg_output & ~(1u << off);
+
+	ret = pca957x_write_reg(chip, PCA957X_OUT, reg_val);
+	if (ret)
+		return ret;
+
+	chip->reg_output = reg_val;
+
+	/* then direction */
+	reg_val = chip->reg_direction & ~(1u << off);
+	ret = pca957x_write_reg(chip, PCA957X_CFG, reg_val);
+	if (ret)
+		return ret;
+
+	chip->reg_direction = reg_val;
+	return 0;
+}
+
+static int pca957x_gpio_get_value(struct gpio_chip *gc, unsigned off)
+{
+	struct pca957x_chip *chip;
+	uint16_t reg_val;
+	int ret;
+
+	chip = container_of(gc, struct pca957x_chip, gpio_chip);
+
+	ret = pca957x_read_reg(chip, PCA957X_IN, &reg_val);
+	if (ret < 0) {
+		/*
+		 * NOTE:  diagnostic already emitted; that's all we should
+		 * do unless gpio_*_value_cansleep() calls become different
+		 * from their nonsleeping siblings (and report faults).
+		 */
+		return 0;
+	}
+
+	return (reg_val & (1u << off)) ? 1 : 0;
+}
+
+static void pca957x_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
+{
+	struct pca957x_chip *chip;
+	uint16_t reg_val;
+	int ret;
+
+	chip = container_of(gc, struct pca957x_chip, gpio_chip);
+
+	if (val)
+		reg_val = chip->reg_output | (1u << off);
+	else
+		reg_val = chip->reg_output & ~(1u << off);
+
+	ret = pca957x_write_reg(chip, PCA957X_OUT, reg_val);
+	if (ret)
+		return;
+
+	chip->reg_output = reg_val;
+}
+
+static void pca957x_setup_gpio(struct pca957x_chip *chip, int gpios)
+{
+	struct gpio_chip *gc;
+
+	gc = &chip->gpio_chip;
+
+	gc->direction_input  = pca957x_gpio_direction_input;
+	gc->direction_output = pca957x_gpio_direction_output;
+	gc->get = pca957x_gpio_get_value;
+	gc->set = pca957x_gpio_set_value;
+	gc->can_sleep = 1;
+
+	gc->base = chip->gpio_start;
+	gc->ngpio = gpios;
+	gc->label = chip->client->name;
+	gc->dev = &chip->client->dev;
+	gc->owner = THIS_MODULE;
+}
+
+static int pca957x_gpio_to_irq(struct gpio_chip *gc, unsigned off)
+{
+	struct pca957x_chip *chip;
+
+	chip = container_of(gc, struct pca957x_chip, gpio_chip);
+	return chip->irq_base + off;
+}
+
+static void pca957x_irq_mask(struct irq_data *d)
+{
+	struct pca957x_chip *chip = irq_data_get_irq_chip_data(d);
+
+	chip->irq_mask &= ~(1 << (d->irq - chip->irq_base));
+}
+
+static void pca957x_irq_unmask(struct irq_data *d)
+{
+	struct pca957x_chip *chip = irq_data_get_irq_chip_data(d);
+
+	chip->irq_mask |= 1 << (d->irq - chip->irq_base);
+}
+
+static void pca957x_irq_bus_lock(struct irq_data *d)
+{
+	struct pca957x_chip *chip = irq_data_get_irq_chip_data(d);
+
+	mutex_lock(&chip->irq_lock);
+}
+
+static void pca957x_irq_bus_sync_unlock(struct irq_data *d)
+{
+	struct pca957x_chip *chip = irq_data_get_irq_chip_data(d);
+
+	mutex_unlock(&chip->irq_lock);
+}
+
+static int pca957x_irq_set_type(struct irq_data *d, unsigned int type)
+{
+	struct pca957x_chip *chip = irq_data_get_irq_chip_data(d);
+	uint16_t mask = 1u << (d->irq - chip->irq_base);
+
+	if (!(type & IRQ_TYPE_EDGE_BOTH)) {
+		dev_err(&chip->client->dev, "irq %d: unsupported type %d\n",
+			d->irq, type);
+		return -EINVAL;
+	}
+
+	if (type & IRQ_TYPE_EDGE_RISING)
+		chip->irq_trig_raise |= mask;
+	else
+		chip->irq_trig_raise &= ~mask;
+
+	if (type & IRQ_TYPE_EDGE_FALLING)
+		chip->irq_trig_fall |= mask;
+	else
+		chip->irq_trig_fall &= ~mask;
+
+	return 0;
+}
+
+static struct irq_chip pca957x_irq_chip = {
+	.name			= "pca957x",
+	.irq_mask		= pca957x_irq_mask,
+	.irq_unmask		= pca957x_irq_unmask,
+	.irq_bus_lock		= pca957x_irq_bus_lock,
+	.irq_bus_sync_unlock	= pca957x_irq_bus_sync_unlock,
+	.irq_set_type		= pca957x_irq_set_type,
+};
+
+static irqreturn_t pca957x_irq_handler(int irq, void *devid)
+{
+	struct pca957x_chip *chip = devid;
+	uint16_t old_in, new_in, pending, level, trigger;
+	int ret;
+
+	ret = pca957x_read_reg(chip, PCA957X_IN, &new_in);
+	if (ret)
+		goto out;
+
+	new_in &= chip->reg_direction;
+	old_in = chip->irq_stat;
+	trigger = (new_in ^ old_in) & chip->irq_mask;
+	if (!trigger)
+		goto out;
+
+	chip->irq_stat = new_in;
+	pending = (old_in & chip->irq_trig_fall)
+		| (new_in & chip->irq_trig_raise);
+	pending &= trigger;
+
+	do {
+		level = __ffs(pending);
+		generic_handle_irq(level + chip->irq_base);
+
+		pending &= ~(1 << level);
+	} while (pending);
+out:
+	return IRQ_HANDLED;
+}
+
+static int pca957x_init_irq(struct pca957x_chip *chip)
+{
+	struct i2c_client *client = chip->client;
+	struct pca957x_platform_data *pdata = client->dev.platform_data;
+	unsigned long flags = IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING
+				| IRQF_ONESHOT;
+	int ret = -EINVAL, i, __irq;
+
+	if (pdata->irq_base != -1) {
+		ret = pca957x_read_reg(chip, PCA957X_IN, &chip->irq_stat);
+		if (ret)
+			goto out;
+
+		chip->irq_stat &= chip->reg_direction;
+		chip->irq_base = pdata->irq_base;
+		mutex_init(&chip->irq_lock);
+
+		for (i = 0; i < chip->gpio_chip.ngpio; i++) {
+			__irq = i + chip->irq_base;
+			set_irq_chip_data(__irq, chip);
+			set_irq_chip_and_handler(__irq, &pca957x_irq_chip,
+						 handle_edge_irq);
+			set_irq_nested_thread(__irq, 1);
+#ifdef CONFIG_ARM
+			set_irq_flags(__irq, IRQF_VALID);
+#else
+			set_irq_noprobe(irq);
+#endif
+		}
+		ret = request_threaded_irq(client->irq, NULL,
+					   pca957x_irq_handler, flags,
+					   dev_name(&client->dev), chip);
+		if (ret) {
+			dev_err(&client->dev, "failed to request irq %d\n",
+				client->irq);
+			goto out;
+		}
+		chip->gpio_chip.to_irq = pca957x_gpio_to_irq;
+	} else
+		goto out;
+
+	return 0;
+out:
+	chip->irq_base = -1;
+	return ret;
+}
+
+static void pca957x_irq_teardown(struct pca957x_chip *chip)
+{
+	if (chip->irq_base != -1)
+		free_irq(chip->client->irq, chip);
+}
+
+static int __devinit pca957x_probe(struct i2c_client *client,
+				   const struct i2c_device_id *id)
+{
+	struct pca957x_platform_data *pdata;
+	struct pca957x_chip *chip;
+	int ret, retval;
+	uint16_t val;
+
+	pdata = client->dev.platform_data;
+	if (pdata == NULL) {
+		dev_dbg(&client->dev, "no platform data\n");
+		return -EINVAL;
+	}
+
+	chip = kzalloc(sizeof(struct pca957x_chip), GFP_KERNEL);
+	if (chip == NULL)
+		return -ENOMEM;
+
+	chip->client = client;
+
+	chip->gpio_start = pdata->gpio_base;
+
+	/*
+	 * Initialize cached registers from their original values.
+	 * We can't share this chip with another i2c master.
+	 */
+	pca957x_setup_gpio(chip, id->driver_data);
+
+	/* Let every port in proper state , that could save power */
+	pca957x_write_reg(chip, PCA957X_PUPD, 0x0);
+	pca957x_write_reg(chip, PCA957X_CFG, 0xffff);
+	pca957x_write_reg(chip, PCA957X_OUT, 0x0);
+
+	ret = pca957x_read_reg(chip, PCA957X_IN, &val);
+	if (ret)
+		goto out;
+
+	ret = pca957x_read_reg(chip, PCA957X_OUT, &chip->reg_output);
+	if (ret)
+		goto out;
+
+	ret = pca957x_read_reg(chip, PCA957X_CFG, &chip->reg_direction);
+	if (ret)
+		goto out;
+
+	/* set platform specific polarity inversion */
+	ret = pca957x_write_reg(chip, PCA957X_INVRT, pdata->invert);
+	if (ret)
+		goto out;
+
+	/* To enable register 6, 7 to controll pull up and pull down */
+	pca957x_write_reg(chip, PCA957X_BKEN, 0x202);
+
+	ret = gpiochip_add(&chip->gpio_chip);
+	if (ret)
+		goto out;
+
+	if (pdata->setup) {
+		ret = pdata->setup(client, chip->gpio_chip.base,
+				   chip->gpio_chip.ngpio, pdata->context);
+		if (ret < 0)
+			dev_warn(&client->dev, "setup failed, %d\n", ret);
+	}
+
+	ret = pca957x_init_irq(chip);
+	if (ret)
+		goto out_irq;
+
+	i2c_set_clientdata(client, chip);
+	return 0;
+
+out_irq:
+	retval = gpiochip_remove(&chip->gpio_chip);
+out:
+	kfree(chip);
+	return ret;
+}
+
+static int __devexit pca957x_remove(struct i2c_client *client)
+{
+	struct pca957x_platform_data *pdata = client->dev.platform_data;
+	struct pca957x_chip *chip = i2c_get_clientdata(client);
+	int ret = 0;
+
+	if (pdata->teardown) {
+		ret = pdata->teardown(client, chip->gpio_chip.base,
+				      chip->gpio_chip.ngpio, pdata->context);
+		if (ret < 0) {
+			dev_err(&client->dev, "%s failed, ret:%d\n",
+				"teardown", ret);
+			return ret;
+		}
+	}
+
+	ret = gpiochip_remove(&chip->gpio_chip);
+	if (ret) {
+		dev_err(&client->dev, "%s failed, ret:%d\n",
+			"gpiochip_remove()", ret);
+		return ret;
+	}
+
+	pca957x_irq_teardown(chip);
+	kfree(chip);
+	return 0;
+}
+
+static struct i2c_driver pca957x_driver = {
+	.driver = {
+		.name	= "pca9575",
+	},
+	.probe		= pca957x_probe,
+	.remove		= __devexit_p(pca957x_remove),
+	.id_table	= pca957x_id,
+};
+
+static int __init pca957x_init(void)
+{
+	return i2c_add_driver(&pca957x_driver);
+}
+/*
+ * register after i2c postcore initcall and before
+ * subsys initcalls that may rely on these GPIOs
+ */
+subsys_initcall_sync(pca957x_init);
+
+static void __exit pca957x_exit(void)
+{
+	i2c_del_driver(&pca957x_driver);
+}
+module_exit(pca957x_exit);
+
+MODULE_AUTHOR("Jack Ren <jack.ren@marvell.com>");
+MODULE_DESCRIPTION("GPIO expander driver for PCA957x");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/i2c/pca957x.h b/include/linux/i2c/pca957x.h
new file mode 100644
index 0000000..dd78b63
--- /dev/null
+++ b/include/linux/i2c/pca957x.h
@@ -0,0 +1,28 @@
+#ifndef _LINUX_PCA957X_H
+#define _LINUX_PCA957X_H
+
+#include <linux/types.h>
+#include <linux/i2c.h>
+
+struct pca957x_platform_data {
+	/* number of the first GPIO */
+	unsigned	gpio_base;
+
+	/* initial polarity inversion setting */
+	uint16_t	invert;
+
+	/* interrupt base */
+	int		irq_base;
+
+	void		*context;	/* param to setup/teardown */
+
+	int		(*setup)(struct i2c_client *client,
+				unsigned gpio, unsigned ngpio,
+				void *context);
+	int		(*teardown)(struct i2c_client *client,
+				unsigned gpio, unsigned ngpio,
+				void *context);
+	const char	*const *names;
+};
+
+#endif /* _LINUX_PCA957X_H */
-- 
1.5.6.5

