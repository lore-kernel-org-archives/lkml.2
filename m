Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1DEVlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 17:41:47 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16520 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab1DEVlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 17:41:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6307"; a="83946094"
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
To: davidb@codeaurora.org, dwalker@fifo99.com
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-msm-owner@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@linaro.org>,
        Thomas Glexiner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andres Salomon <dilinger@queued.net>
Subject: [PM8921 MFD V5 3/6] gpio: pm8xxx-gpio: Add pm8xxx gpio driver
Date: Tue,  5 Apr 2011 14:40:54 -0700
Message-Id: <1302039657-19395-4-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302039657-19395-1-git-send-email-adharmap@codeaurora.org>
References: <1302039657-19395-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for GPIO on Qualcomm PM8xxx PMIC chips.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
---
 drivers/gpio/Kconfig              |    9 +
 drivers/gpio/Makefile             |    1 +
 drivers/gpio/pm8xxx-gpio.c        |  455 +++++++++++++++++++++++++++++++++++++
 drivers/mfd/pm8921-core.c         |   35 +++
 include/linux/mfd/pm8xxx/gpio.h   |  136 +++++++++++
 include/linux/mfd/pm8xxx/pm8921.h |   11 +
 6 files changed, 647 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/pm8xxx-gpio.c
 create mode 100644 include/linux/mfd/pm8xxx/gpio.h

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d3b2953..2035f90 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -419,4 +419,13 @@ config AB8500_GPIO
 	depends on AB8500_CORE && BROKEN
 	help
 	  Select this to enable the AB8500 IC GPIO driver
+
+config GPIO_PM8XXX
+	tristate "Qualcomm PM8xxx GPIO support"
+	depends on MFD_PM8XXX
+	default y if MFD_PM8XXX
+	help
+	  This option enables support for on-chip GPIO found on Qualcomm PM8xxx
+	  PMICs.
+
 endif
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index becef59..337aa34 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -43,3 +43,4 @@ obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
 obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
 obj-$(CONFIG_GPIO_ML_IOH)	+= ml_ioh_gpio.o
 obj-$(CONFIG_AB8500_GPIO)       += ab8500-gpio.o
+obj-$(CONFIG_GPIO_PM8XXX)	+= pm8xxx-gpio.o
diff --git a/drivers/gpio/pm8xxx-gpio.c b/drivers/gpio/pm8xxx-gpio.c
new file mode 100644
index 0000000..7731e94
--- /dev/null
+++ b/drivers/gpio/pm8xxx-gpio.c
@@ -0,0 +1,455 @@
+/*
+ * Qualcomm PMIC8XXX GPIO driver
+ *
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt)	"%s: " fmt, __func__
+
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/mfd/pm8xxx/core.h>
+#include <linux/mfd/pm8xxx/gpio.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+/* GPIO registers */
+#define SSBI_REG_ADDR_GPIO_BASE		0x150
+#define SSBI_REG_ADDR_GPIO(n)		(SSBI_REG_ADDR_GPIO_BASE + n)
+
+/* GPIO */
+#define PM_GPIO_BANK_MASK		0x70
+#define PM_GPIO_BANK_SHIFT		4
+#define PM_GPIO_WRITE			0x80
+
+/* Bank 0 */
+#define PM_GPIO_VIN_MASK		0x0E
+#define PM_GPIO_VIN_SHIFT		1
+#define PM_GPIO_MODE_ENABLE		0x01
+
+/* Bank 1 */
+#define PM_GPIO_MODE_MASK		0x0C
+#define PM_GPIO_MODE_SHIFT		2
+#define PM_GPIO_OUT_BUFFER		0x02
+#define PM_GPIO_OUT_INVERT		0x01
+
+#define PM_GPIO_MODE_OFF		3
+#define PM_GPIO_MODE_OUTPUT		2
+#define PM_GPIO_MODE_INPUT		0
+#define PM_GPIO_MODE_BOTH		1
+
+/* Bank 2 */
+#define PM_GPIO_PULL_MASK		0x0E
+#define PM_GPIO_PULL_SHIFT		1
+
+/* Bank 3 */
+#define PM_GPIO_OUT_STRENGTH_MASK	0x0C
+#define PM_GPIO_OUT_STRENGTH_SHIFT	2
+#define PM_GPIO_PIN_ENABLE		0x00
+#define PM_GPIO_PIN_DISABLE		0x01
+
+/* Bank 4 */
+#define PM_GPIO_FUNC_MASK		0x0E
+#define PM_GPIO_FUNC_SHIFT		1
+
+/* Bank 5 */
+#define PM_GPIO_NON_INT_POL_INV		0x08
+#define PM_GPIO_BANKS			6
+
+struct pm_gpio_chip {
+	struct list_head	link;
+	struct gpio_chip	gpio_chip;
+	spinlock_t		pm_lock;
+	u8			*bank1;
+	int			irq_base;
+};
+
+static LIST_HEAD(pm_gpio_chips);
+static DEFINE_MUTEX(pm_gpio_chips_lock);
+
+static int pm_gpio_get(struct pm_gpio_chip *pm_gpio_chip, unsigned gpio)
+{
+	int	mode;
+
+	if (gpio >= pm_gpio_chip->gpio_chip.ngpio || pm_gpio_chip == NULL)
+		return -EINVAL;
+
+	/* Get gpio value from config bank 1 if output gpio.
+	   Get gpio value from IRQ RT status register for all other gpio modes.
+	 */
+	mode = (pm_gpio_chip->bank1[gpio] & PM_GPIO_MODE_MASK) >>
+		PM_GPIO_MODE_SHIFT;
+	if (mode == PM_GPIO_MODE_OUTPUT)
+		return pm_gpio_chip->bank1[gpio] & PM_GPIO_OUT_INVERT;
+	else
+		return pm8xxx_read_irq_stat(pm_gpio_chip->gpio_chip.dev->parent,
+				pm_gpio_chip->irq_base + gpio);
+}
+
+static int pm_gpio_set(struct pm_gpio_chip *pm_gpio_chip,
+		unsigned gpio, int value)
+{
+	int	rc;
+	u8	bank1;
+	unsigned long flags;
+
+	if (gpio >= pm_gpio_chip->gpio_chip.ngpio || pm_gpio_chip == NULL)
+		return -EINVAL;
+
+	spin_lock_irqsave(&pm_gpio_chip->pm_lock, flags);
+	bank1 = PM_GPIO_WRITE
+			| (pm_gpio_chip->bank1[gpio] & ~PM_GPIO_OUT_INVERT);
+
+	if (value)
+		bank1 |= PM_GPIO_OUT_INVERT;
+
+	pm_gpio_chip->bank1[gpio] = bank1;
+	rc = pm8xxx_writeb(pm_gpio_chip->gpio_chip.dev->parent,
+				SSBI_REG_ADDR_GPIO(gpio), bank1);
+	spin_unlock_irqrestore(&pm_gpio_chip->pm_lock, flags);
+
+	if (rc)
+		pr_err("FAIL pm8xxx_writeb(): rc=%d. "
+		       "(gpio=%d, value=%d)\n",
+		       rc, gpio, value);
+
+	return rc;
+}
+
+static int dir_map[] = {
+	PM_GPIO_MODE_OFF,
+	PM_GPIO_MODE_OUTPUT,
+	PM_GPIO_MODE_INPUT,
+	PM_GPIO_MODE_BOTH,
+};
+
+static int pm_gpio_set_direction(struct pm_gpio_chip *pm_gpio_chip,
+			      unsigned gpio, int direction)
+{
+	int	rc;
+	u8	bank1;
+	unsigned long flags;
+
+	if (!direction || pm_gpio_chip == NULL)
+		return -EINVAL;
+
+	spin_lock_irqsave(&pm_gpio_chip->pm_lock, flags);
+	bank1 = PM_GPIO_WRITE
+			| (pm_gpio_chip->bank1[gpio] & ~PM_GPIO_MODE_MASK);
+
+	bank1 |= ((dir_map[direction] << PM_GPIO_MODE_SHIFT)
+		  & PM_GPIO_MODE_MASK);
+
+	pm_gpio_chip->bank1[gpio] = bank1;
+	rc = pm8xxx_writeb(pm_gpio_chip->gpio_chip.dev->parent,
+				SSBI_REG_ADDR_GPIO(gpio), bank1);
+	spin_unlock_irqrestore(&pm_gpio_chip->pm_lock, flags);
+
+	if (rc)
+		pr_err("Failed on pm8xxx_writeb(): rc=%d (GPIO config)\n",
+			rc);
+
+	return rc;
+}
+
+static int pm_gpio_init_bank1(struct pm_gpio_chip *pm_gpio_chip)
+{
+	int i, rc;
+	u8 bank;
+
+	for (i = 0; i < pm_gpio_chip->gpio_chip.ngpio; i++) {
+		bank = 1 << PM_GPIO_BANK_SHIFT;
+		rc = pm8xxx_writeb(pm_gpio_chip->gpio_chip.dev->parent,
+				SSBI_REG_ADDR_GPIO(i),
+				bank);
+		if (rc) {
+			pr_err("error setting bank rc=%d\n", rc);
+			return rc;
+		}
+
+		rc = pm8xxx_readb(pm_gpio_chip->gpio_chip.dev->parent,
+				SSBI_REG_ADDR_GPIO(i),
+				&pm_gpio_chip->bank1[i]);
+		if (rc) {
+			pr_err("error reading bank 1 rc=%d\n", rc);
+			return rc;
+		}
+	}
+	return 0;
+}
+
+static int pm_gpio_to_irq(struct gpio_chip *gpio_chip, unsigned offset)
+{
+	struct pm_gpio_chip *pm_gpio_chip = dev_get_drvdata(gpio_chip->dev);
+
+	return pm_gpio_chip->irq_base + offset;
+}
+
+static int pm_gpio_read(struct gpio_chip *gpio_chip, unsigned offset)
+{
+	struct pm_gpio_chip *pm_gpio_chip = dev_get_drvdata(gpio_chip->dev);
+
+	return pm_gpio_get(pm_gpio_chip, offset);
+}
+
+static void pm_gpio_write(struct gpio_chip *gpio_chip,
+		unsigned offset, int val)
+{
+	struct pm_gpio_chip *pm_gpio_chip = dev_get_drvdata(gpio_chip->dev);
+
+	pm_gpio_set(pm_gpio_chip, offset, val);
+}
+
+static int pm_gpio_direction_input(struct gpio_chip *gpio_chip,
+		unsigned offset)
+{
+	struct pm_gpio_chip *pm_gpio_chip = dev_get_drvdata(gpio_chip->dev);
+
+	return pm_gpio_set_direction(pm_gpio_chip, offset, PM_GPIO_DIR_IN);
+}
+
+static int pm_gpio_direction_output(struct gpio_chip *gpio_chip,
+		unsigned offset,
+		int val)
+{
+	int ret;
+	struct pm_gpio_chip *pm_gpio_chip = dev_get_drvdata(gpio_chip->dev);
+
+	ret = pm_gpio_set_direction(pm_gpio_chip, offset, PM_GPIO_DIR_OUT);
+	if (!ret)
+		ret = pm_gpio_set(pm_gpio_chip, offset, val);
+
+	return ret;
+}
+
+static void pm_gpio_dbg_show(struct seq_file *s, struct gpio_chip *gpio_chip)
+{
+	static const char * const cmode[] = { "in", "in/out", "out", "off" };
+	struct pm_gpio_chip *pm_gpio_chip = dev_get_drvdata(gpio_chip->dev);
+	u8 mode, state, bank;
+	const char *label;
+	int i, j;
+
+	for (i = 0; i < gpio_chip->ngpio; i++) {
+		label = gpiochip_is_requested(gpio_chip, i);
+		mode = (pm_gpio_chip->bank1[i] & PM_GPIO_MODE_MASK) >>
+			PM_GPIO_MODE_SHIFT;
+		state = pm_gpio_get(pm_gpio_chip, i);
+		seq_printf(s, "gpio-%-3d (%-12.12s) %-10.10s"
+				" %s",
+				gpio_chip->base + i,
+				label ? label : "--",
+				cmode[mode],
+				state ? "hi" : "lo");
+		for (j = 0; j < PM_GPIO_BANKS; j++) {
+			bank = j << PM_GPIO_BANK_SHIFT;
+			pm8xxx_writeb(gpio_chip->dev->parent,
+					SSBI_REG_ADDR_GPIO(i),
+					bank);
+			pm8xxx_readb(gpio_chip->dev->parent,
+					SSBI_REG_ADDR_GPIO(i),
+					&bank);
+			seq_printf(s, " 0x%02x", bank);
+		}
+		seq_printf(s, "\n");
+	}
+}
+
+static int __devinit pm_gpio_probe(struct platform_device *pdev)
+{
+	int ret;
+	const struct pm8xxx_gpio_platform_data *pdata = mfd_get_data(pdev);
+	struct pm_gpio_chip *pm_gpio_chip;
+
+	if (!pdata) {
+		pr_err("missing platform data\n");
+		return -EINVAL;
+	}
+
+	pm_gpio_chip = kzalloc(sizeof(struct pm_gpio_chip), GFP_KERNEL);
+	if (!pm_gpio_chip) {
+		pr_err("Cannot allocate pm_gpio_chip\n");
+		return -ENOMEM;
+	}
+
+	pm_gpio_chip->bank1 = kzalloc(sizeof(u8) * pdata->gpio_cdata.ngpios,
+					GFP_KERNEL);
+	if (!pm_gpio_chip->bank1) {
+		pr_err("Cannot allocate pm_gpio_chip->bank1\n");
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&pm_gpio_chip->pm_lock);
+	pm_gpio_chip->gpio_chip.label = "pm-gpio";
+	pm_gpio_chip->gpio_chip.direction_input	= pm_gpio_direction_input;
+	pm_gpio_chip->gpio_chip.direction_output = pm_gpio_direction_output;
+	pm_gpio_chip->gpio_chip.to_irq = pm_gpio_to_irq;
+	pm_gpio_chip->gpio_chip.get = pm_gpio_read;
+	pm_gpio_chip->gpio_chip.set = pm_gpio_write;
+	pm_gpio_chip->gpio_chip.dbg_show = pm_gpio_dbg_show;
+	pm_gpio_chip->gpio_chip.ngpio = pdata->gpio_cdata.ngpios;
+	pm_gpio_chip->gpio_chip.can_sleep = 1;
+	pm_gpio_chip->gpio_chip.dev = &pdev->dev;
+	pm_gpio_chip->gpio_chip.base = pdata->gpio_base;
+	pm_gpio_chip->irq_base = platform_get_irq(pdev, 0);
+	mutex_lock(&pm_gpio_chips_lock);
+	list_add(&pm_gpio_chip->link, &pm_gpio_chips);
+	mutex_unlock(&pm_gpio_chips_lock);
+	platform_set_drvdata(pdev, pm_gpio_chip);
+
+	ret = gpiochip_add(&pm_gpio_chip->gpio_chip);
+	if (ret) {
+		pr_err("gpiochip_add failed ret = %d\n", ret);
+		goto reset_drvdata;
+	}
+
+	ret = pm_gpio_init_bank1(pm_gpio_chip);
+	if (ret) {
+		pr_err("gpio init bank failed ret = %d\n", ret);
+		goto remove_chip;
+	}
+
+	return 0;
+
+remove_chip:
+	if (gpiochip_remove(&pm_gpio_chip->gpio_chip))
+		pr_err("failed to remove gpio chip\n");
+reset_drvdata:
+	platform_set_drvdata(pdev, NULL);
+	kfree(pm_gpio_chip);
+	return ret;
+}
+
+static int __devexit pm_gpio_remove(struct platform_device *pdev)
+{
+	struct pm_gpio_chip *pm_gpio_chip
+		= platform_get_drvdata(pdev);
+
+	mutex_lock(&pm_gpio_chips_lock);
+	list_del(&pm_gpio_chip->link);
+	mutex_unlock(&pm_gpio_chips_lock);
+	platform_set_drvdata(pdev, NULL);
+	if (gpiochip_remove(&pm_gpio_chip->gpio_chip))
+		pr_err("failed to remove gpio chip\n");
+	kfree(pm_gpio_chip->bank1);
+	kfree(pm_gpio_chip);
+	return 0;
+}
+
+int pm8xxx_gpio_config(int gpio, struct pm_gpio *param)
+{
+	int	rc, pm_gpio = 0;
+	u8	bank[8];
+	unsigned long flags;
+	struct pm_gpio_chip *pm_gpio_chip;
+	struct gpio_chip *gpio_chip;
+
+	if (param == NULL)
+		return -EINVAL;
+
+	mutex_lock(&pm_gpio_chips_lock);
+	list_for_each_entry(pm_gpio_chip, &pm_gpio_chips, link) {
+		gpio_chip = &pm_gpio_chip->gpio_chip;
+		if (gpio >= gpio_chip->base
+			&& gpio < gpio_chip->base + gpio_chip->ngpio) {
+			pm_gpio = gpio - gpio_chip->base;
+			break;
+		}
+	}
+	mutex_unlock(&pm_gpio_chips_lock);
+	if (!pm_gpio) {
+		pr_err("called on gpio %d not handled by any pmic\n", gpio);
+		return -EINVAL;
+	}
+
+	/* Select banks and configure the gpio */
+	bank[0] = PM_GPIO_WRITE |
+		((param->vin_sel << PM_GPIO_VIN_SHIFT) &
+			PM_GPIO_VIN_MASK) |
+		PM_GPIO_MODE_ENABLE;
+	bank[1] = PM_GPIO_WRITE |
+		((1 << PM_GPIO_BANK_SHIFT) &
+			PM_GPIO_BANK_MASK) |
+		((dir_map[param->direction] <<
+			PM_GPIO_MODE_SHIFT) &
+			PM_GPIO_MODE_MASK) |
+		((param->direction & PM_GPIO_DIR_OUT) ?
+			((param->output_buffer & 1) ?
+			 PM_GPIO_OUT_BUFFER : 0) : 0) |
+		((param->direction & PM_GPIO_DIR_OUT) ?
+			param->output_value & 0x01 : 0);
+	bank[2] = PM_GPIO_WRITE |
+		((2 << PM_GPIO_BANK_SHIFT) &
+			PM_GPIO_BANK_MASK) |
+		((param->pull << PM_GPIO_PULL_SHIFT) &
+			PM_GPIO_PULL_MASK);
+	bank[3] = PM_GPIO_WRITE |
+		((3 << PM_GPIO_BANK_SHIFT) &
+			PM_GPIO_BANK_MASK) |
+		((param->out_strength <<
+			PM_GPIO_OUT_STRENGTH_SHIFT) &
+			PM_GPIO_OUT_STRENGTH_MASK) |
+		(param->disable_pin ?
+			PM_GPIO_PIN_DISABLE : PM_GPIO_PIN_ENABLE);
+	bank[4] = PM_GPIO_WRITE |
+		((4 << PM_GPIO_BANK_SHIFT) &
+			PM_GPIO_BANK_MASK) |
+		((param->function << PM_GPIO_FUNC_SHIFT) &
+			PM_GPIO_FUNC_MASK);
+	bank[5] = PM_GPIO_WRITE |
+		((5 << PM_GPIO_BANK_SHIFT) & PM_GPIO_BANK_MASK) |
+		(param->inv_int_pol ? 0 : PM_GPIO_NON_INT_POL_INV);
+
+	spin_lock_irqsave(&pm_gpio_chip->pm_lock, flags);
+	/* Remember bank1 for later use */
+	pm_gpio_chip->bank1[pm_gpio] = bank[1];
+	rc = pm8xxx_write_buf(pm_gpio_chip->gpio_chip.dev->parent,
+			SSBI_REG_ADDR_GPIO(pm_gpio), bank, 6);
+	spin_unlock_irqrestore(&pm_gpio_chip->pm_lock, flags);
+
+	if (rc)
+		pr_err("Failed on pm8xxx_write_buf() rc=%d (GPIO config)\n",
+			rc);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(pm8xxx_gpio_config);
+
+static struct platform_driver pm_gpio_driver = {
+	.probe		= pm_gpio_probe,
+	.remove		= __devexit_p(pm_gpio_remove),
+	.driver		= {
+		.name	= PM8XXX_GPIO_DEV_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init pm_gpio_init(void)
+{
+	return platform_driver_register(&pm_gpio_driver);
+}
+subsys_initcall(pm_gpio_init);
+
+static void __exit pm_gpio_exit(void)
+{
+	platform_driver_unregister(&pm_gpio_driver);
+}
+module_exit(pm_gpio_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("PMIC GPIO driver");
+MODULE_VERSION("1.0");
+MODULE_ALIAS("platform:" PM8XXX_GPIO_DEV_NAME);
diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index e873b15..0f1691f 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -80,6 +80,22 @@ static struct pm8xxx_drvdata pm8921_drvdata = {
 	.pmic_read_irq_stat	= pm8921_read_irq_stat,
 };
 
+static const struct resource gpio_cell_resources[] __devinitconst = {
+	[0] = {
+		.start = PM8921_IRQ_BLOCK_BIT(PM8921_GPIO_BLOCK_START, 0),
+		.end   = PM8921_IRQ_BLOCK_BIT(PM8921_GPIO_BLOCK_START, 0)
+			+ PM8921_NR_GPIOS - 1,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct mfd_cell gpio_cell __devinitdata = {
+	.name		= PM8XXX_GPIO_DEV_NAME,
+	.id		= -1,
+	.resources	= gpio_cell_resources,
+	.num_resources	= ARRAY_SIZE(gpio_cell_resources),
+};
+
 static int __devinit pm8921_add_subdevices(const struct pm8921_platform_data
 					   *pdata,
 					   struct pm8921 *pmic,
@@ -101,6 +117,25 @@ static int __devinit pm8921_add_subdevices(const struct pm8921_platform_data
 		}
 		pmic->irq_chip = irq_chip;
 	}
+
+	if (pdata->gpio_pdata) {
+		pdata->gpio_pdata->gpio_cdata.ngpios = PM8921_NR_GPIOS;
+		pdata->gpio_pdata->gpio_cdata.rev = rev;
+		gpio_cell.mfd_data = pdata->gpio_pdata;
+		ret = mfd_add_devices(pmic->dev, 0, &gpio_cell, 1,
+					NULL, irq_base);
+		if (ret) {
+			pr_err("Failed to add  gpio subdevice ret=%d\n", ret);
+			goto bail;
+		}
+	}
+
+	return 0;
+bail:
+	if (pmic->irq_chip) {
+		pm8xxx_irq_exit(pmic->irq_chip);
+		pmic->irq_chip = NULL;
+	}
 	return ret;
 }
 
diff --git a/include/linux/mfd/pm8xxx/gpio.h b/include/linux/mfd/pm8xxx/gpio.h
new file mode 100644
index 0000000..fe1db2d
--- /dev/null
+++ b/include/linux/mfd/pm8xxx/gpio.h
@@ -0,0 +1,136 @@
+/*
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/*
+ * Qualcomm PMIC8XXX gpio driver header file
+ *
+ */
+
+#ifndef __PM8XXX_GPIO_H
+#define __PM8XXX_GPIO_H
+
+#include <linux/errno.h>
+
+#define PM8XXX_GPIO_DEV_NAME	"pm8xxx-gpio"
+
+struct pm8xxx_gpio_core_data {
+	u32	rev;
+	int	ngpios;
+};
+
+struct pm8xxx_gpio_platform_data {
+	struct pm8xxx_gpio_core_data	gpio_cdata;
+	int				gpio_base;
+};
+
+/* GPIO parameters */
+/* direction */
+#define	PM_GPIO_DIR_OUT			0x01
+#define	PM_GPIO_DIR_IN			0x02
+#define	PM_GPIO_DIR_BOTH		(PM_GPIO_DIR_OUT | PM_GPIO_DIR_IN)
+
+/* output_buffer */
+#define	PM_GPIO_OUT_BUF_OPEN_DRAIN	1
+#define	PM_GPIO_OUT_BUF_CMOS		0
+
+/* pull */
+#define	PM_GPIO_PULL_UP_30		0
+#define	PM_GPIO_PULL_UP_1P5		1
+#define	PM_GPIO_PULL_UP_31P5		2
+#define	PM_GPIO_PULL_UP_1P5_30		3
+#define	PM_GPIO_PULL_DN			4
+#define	PM_GPIO_PULL_NO			5
+
+/* vin_sel: Voltage Input Select */
+#define	PM_GPIO_VIN_VPH			0
+#define	PM_GPIO_VIN_BB			1
+#define	PM_GPIO_VIN_S3			2
+#define	PM_GPIO_VIN_L3			3
+#define	PM_GPIO_VIN_L7			4
+#define	PM_GPIO_VIN_L6			5
+#define	PM_GPIO_VIN_L5			6
+#define	PM_GPIO_VIN_L2			7
+
+/* out_strength */
+#define	PM_GPIO_STRENGTH_NO		0
+#define	PM_GPIO_STRENGTH_HIGH		1
+#define	PM_GPIO_STRENGTH_MED		2
+#define	PM_GPIO_STRENGTH_LOW		3
+
+/* function */
+#define	PM_GPIO_FUNC_NORMAL		0
+#define	PM_GPIO_FUNC_PAIRED		1
+#define	PM_GPIO_FUNC_1			2
+#define	PM_GPIO_FUNC_2			3
+#define	PM_GPIO_DTEST1			4
+#define	PM_GPIO_DTEST2			5
+#define	PM_GPIO_DTEST3			6
+#define	PM_GPIO_DTEST4			7
+
+/**
+ * struct pm_gpio - structure to specify gpio configurtion values
+ * @direction:		indicates whether the gpio should be input, output, or
+ *			both. Should be of the type PM_GPIO_DIR_*
+ * @output_buffer:	indicates gpio should be configured as CMOS or open
+ *			drain. Should be of the type PM_GPIO_OUT_BUF_*
+ * @output_value:	The gpio output value of the gpio line - 0 or 1
+ * @pull:		Indicates whether a pull up or pull down should be
+ *			applied. If a pullup is required the current strength
+ *			needs to be specified. Current values of 30uA, 1.5uA,
+ *			31.5uA, 1.5uA with 30uA boost are supported. This value
+ *			should be one of the PM_GPIO_PULL_*
+ * @vin_sel:		specifies the voltage level when the output is set to 1.
+ *			For an input gpio specifies the voltage level at which
+ *			the input is interpreted as a logical 1.
+ * @out_strength:	the amount of current supplied for an output gpio,
+ *			should be of the type PM_GPIO_STRENGTH_*
+ * @function:		choose alternate function for the gpio. Certain gpios
+ *			can be paired (shorted) with each other. Some gpio pin
+ *			can act as alternate functions. This parameter should
+ *			be of type PM_GPIO_FUNC_*
+ * @inv_int_pol:	Invert polarity before feeding the line to the interrupt
+ *			module in pmic. This feature will almost be never used
+ *			since the pm8xxx interrupt block can detect both edges
+ *			and both levels.
+ * @disable_pin:	Disable the gpio by configuring it as high impedence.
+ *
+ */
+struct pm_gpio {
+	int		direction;
+	int		output_buffer;
+	int		output_value;
+	int		pull;
+	int		vin_sel;
+	int		out_strength;
+	int		function;
+	int		inv_int_pol;
+	int		disable_pin;
+};
+
+#if defined(CONFIG_GPIO_PM8XXX) || defined(CONFIG_GPIO_PM8XXX_MODULE)
+/**
+ * pm8xxx_gpio_config - configure a gpio controlled by a pm8xxx chip
+ * @gpio: gpio number to configure
+ * @param: configuration values
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_gpio_config(int gpio, struct pm_gpio *param);
+#else
+static inline int pm8xxx_gpio_config(int gpio, struct pm_gpio *param)
+{
+	return -ENXIO;
+}
+#endif
+
+#endif
diff --git a/include/linux/mfd/pm8xxx/pm8921.h b/include/linux/mfd/pm8xxx/pm8921.h
index d5517fd..def8c31 100644
--- a/include/linux/mfd/pm8xxx/pm8921.h
+++ b/include/linux/mfd/pm8xxx/pm8921.h
@@ -20,12 +20,23 @@
 
 #include <linux/device.h>
 #include <linux/mfd/pm8xxx/irq.h>
+#include <linux/mfd/pm8xxx/gpio.h>
 
 #define PM8921_NR_IRQS		256
 
+#define PM8921_NR_GPIOS		44
+
+#define PM8921_GPIO_BLOCK_START	24
+#define PM8921_IRQ_BLOCK_BIT(block, bit) ((block) * 8 + (bit))
+
+/* GPIOs [1,N] */
+#define PM8921_GPIO_IRQ(base, gpio)	((base) + \
+		PM8921_IRQ_BLOCK_BIT(PM8921_GPIO_BLOCK_START, (gpio)-1))
+
 struct pm8921_platform_data {
 	int					irq_base;
 	struct pm8xxx_irq_platform_data		*irq_pdata;
+	struct pm8xxx_gpio_platform_data	*gpio_pdata;
 };
 
 #endif
-- 
1.7.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
