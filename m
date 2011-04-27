Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab1D0GTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:19:04 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33671 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab1D0GTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:19:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6328"; a="88047828"
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
To: sameo@linux.intel.com, grant.likely@secretlab.ca
Cc: David Collins <collinsd@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        linux-kernel@vger.kernel.org, dwalker@fifo99.com,
        davidb@codeaurora.org, linux-arm-msm-owner@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andres Salomon <dilinger@queued.net>,
        =?UTF-8?q?Uwe=20Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
Subject: [PATCH 2/2] mfd: pm8xxx-mpp: Add pm8xxx MPP driver
Date: Tue, 26 Apr 2011 23:18:47 -0700
Message-Id: <1303885127-25220-3-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1303885127-25220-1-git-send-email-adharmap@codeaurora.org>
References: <1303885127-25220-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Collins <collinsd@codeaurora.org>

Add support for multi-purpose pins (MPPs) on Qualcomm PM8xxx
PMIC chips.

PM8xxx MPPs can be configured as digital or analog inputs or
outputs, current sinks, or buffers.

Note that mpp pins appear as gpio lines to the kernel. However they
are implemented separately from the pmic's gpio driver as
mpps have different configuration attributes and have different
register controls than the pmic's gpio controller. Basically they are
different set of pins.

Signed-off-by: David Collins <collinsd@codeaurora.org>
---
 drivers/gpio/Kconfig              |    8 +
 drivers/gpio/Makefile             |    1 +
 drivers/gpio/pm8xxx-mpp.c         |  325 +++++++++++++++++++++++++++++++++++++
 drivers/mfd/pm8921-core.c         |   30 ++++
 include/linux/mfd/pm8xxx/mpp.h    |  233 ++++++++++++++++++++++++++
 include/linux/mfd/pm8xxx/pm8921.h |    9 +-
 6 files changed, 605 insertions(+), 1 deletions(-)
 create mode 100644 drivers/gpio/pm8xxx-mpp.c
 create mode 100644 include/linux/mfd/pm8xxx/mpp.h

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 2035f90..e6efaca 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -428,4 +428,12 @@ config GPIO_PM8XXX
 	  This option enables support for on-chip GPIO found on Qualcomm PM8xxx
 	  PMICs.
 
+config GPIO_PM8XXX_MPP
+	tristate "Support for Qualcomm PM8xxx MPP features"
+	depends on MFD_PM8XXX
+	default y if MFD_PM8XXX
+	help
+	  This is the multi-purpose pin (MPP) driver for Qualcomm PM 8xxx PMIC
+	  chips.
+
 endif
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 337aa34..50ee44d 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -44,3 +44,4 @@ obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
 obj-$(CONFIG_GPIO_ML_IOH)	+= ml_ioh_gpio.o
 obj-$(CONFIG_AB8500_GPIO)       += ab8500-gpio.o
 obj-$(CONFIG_GPIO_PM8XXX)	+= pm8xxx-gpio.o
+obj-$(CONFIG_GPIO_PM8XXX_MPP) 	+= pm8xxx-mpp.o
diff --git a/drivers/gpio/pm8xxx-mpp.c b/drivers/gpio/pm8xxx-mpp.c
new file mode 100644
index 0000000..1607fbf
--- /dev/null
+++ b/drivers/gpio/pm8xxx-mpp.c
@@ -0,0 +1,325 @@
+/*
+ * Qualcomm PM8XXX Multi-Purpose Pin (MPP) driver
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
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/mfd/pm8xxx/core.h>
+#include <linux/mfd/pm8xxx/mpp.h>
+
+/* MPP Type */
+#define	PM8XXX_MPP_TYPE_MASK		0xE0
+#define	PM8XXX_MPP_TYPE_SHIFT		5
+
+/* MPP Config Level */
+#define	PM8XXX_MPP_CONFIG_LVL_MASK	0x1C
+#define	PM8XXX_MPP_CONFIG_LVL_SHIFT	2
+
+/* MPP Config Control */
+#define	PM8XXX_MPP_CONFIG_CTRL_MASK	0x03
+#define	PM8XXX_MPP_CONFIG_CTRL_SHIFT	0
+
+struct pm8xxx_mpp_chip {
+	struct list_head	link;
+	struct gpio_chip	gpio_chip;
+	spinlock_t		pm_lock;
+	u8			*ctrl_reg;
+	int			mpp_base;
+	int			irq_base;
+	int			nmpps;
+	u16			base_addr;
+};
+
+static LIST_HEAD(pm8xxx_mpp_chips);
+static DEFINE_MUTEX(pm8xxx_mpp_chips_lock);
+
+static int pm8xxx_mpp_write(struct pm8xxx_mpp_chip *mpp_chip, u16 offset,
+				u8 val, u8 mask)
+{
+	u8 reg;
+	int rc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mpp_chip->pm_lock, flags);
+
+	reg = (mpp_chip->ctrl_reg[offset] & ~mask) | (val & mask);
+	rc = pm8xxx_writeb(mpp_chip->gpio_chip.dev->parent,
+				mpp_chip->base_addr + offset, reg);
+	if (!rc)
+		mpp_chip->ctrl_reg[offset] = reg;
+
+	spin_unlock_irqrestore(&mpp_chip->pm_lock, flags);
+
+	return rc;
+}
+
+static int pm8xxx_mpp_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct pm8xxx_mpp_chip *mpp_chip = dev_get_drvdata(chip->dev);
+
+	return mpp_chip->irq_base + offset;
+}
+
+static int pm8xxx_mpp_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct pm8xxx_mpp_chip *mpp_chip = dev_get_drvdata(chip->dev);
+	int rc;
+
+	if ((mpp_chip->ctrl_reg[offset] & PM8XXX_MPP_TYPE_MASK) >>
+			PM8XXX_MPP_TYPE_SHIFT == PM8XXX_MPP_TYPE_D_OUTPUT)
+		rc = mpp_chip->ctrl_reg[offset] & PM8XXX_MPP_CONFIG_CTRL_MASK;
+	else
+		rc = pm8xxx_read_irq_stat(mpp_chip->gpio_chip.dev->parent,
+				mpp_chip->irq_base + offset);
+
+	return rc;
+}
+
+static void pm8xxx_mpp_set(struct gpio_chip *chip, unsigned offset, int val)
+{
+	struct pm8xxx_mpp_chip *mpp_chip = dev_get_drvdata(chip->dev);
+	u8 reg = val ? PM8XXX_MPP_DOUT_CTRL_HIGH : PM8XXX_MPP_DOUT_CTRL_LOW;
+	int rc;
+
+	rc = pm8xxx_mpp_write(mpp_chip, offset, reg,
+			PM8XXX_MPP_CONFIG_CTRL_MASK);
+	if (rc)
+		pr_err("pm8xxx_mpp_write(): rc=%d\n", rc);
+}
+
+static int pm8xxx_mpp_dir_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct pm8xxx_mpp_chip *mpp_chip = dev_get_drvdata(chip->dev);
+	int rc = pm8xxx_mpp_write(mpp_chip, offset,
+			PM8XXX_MPP_TYPE_D_INPUT << PM8XXX_MPP_TYPE_SHIFT,
+			PM8XXX_MPP_TYPE_MASK);
+
+	if (rc)
+		pr_err("pm8xxx_mpp_write(): rc=%d\n", rc);
+	return rc;
+}
+
+static int pm8xxx_mpp_dir_output(struct gpio_chip *chip,
+		unsigned offset, int val)
+{
+	struct pm8xxx_mpp_chip *mpp_chip = dev_get_drvdata(chip->dev);
+	u8 reg = (PM8XXX_MPP_TYPE_D_OUTPUT << PM8XXX_MPP_TYPE_SHIFT) |
+		(val & PM8XXX_MPP_CONFIG_CTRL_MASK);
+	u8 mask = PM8XXX_MPP_TYPE_MASK | PM8XXX_MPP_CONFIG_CTRL_MASK;
+	int rc = pm8xxx_mpp_write(mpp_chip, offset, reg, mask);
+
+	if (rc)
+		pr_err("pm8xxx_mpp_write(): rc=%d\n", rc);
+	return rc;
+}
+
+static void pm8xxx_mpp_dbg_show(struct seq_file *s, struct gpio_chip *chip)
+{
+	static const char * const ctype[] = {	"d_in", "d_out", "bi_dir",
+						"a_in", "a_out", "sink",
+						"dtest_sink", "dtest_out"
+	};
+	struct pm8xxx_mpp_chip *mpp_chip = dev_get_drvdata(chip->dev);
+	u8 type, state;
+	const char *label;
+	int i;
+
+	for (i = 0; i < mpp_chip->nmpps; i++) {
+		label = gpiochip_is_requested(chip, i);
+		type = (mpp_chip->ctrl_reg[i] & PM8XXX_MPP_TYPE_MASK) >>
+			PM8XXX_MPP_TYPE_SHIFT;
+		state = pm8xxx_mpp_get(chip, i);
+		seq_printf(s, "gpio-%-3d (%-12.12s) %-10.10s"
+				" %s 0x%02x\n",
+				chip->base + i,
+				label ? label : "--",
+				ctype[type],
+				state ? "hi" : "lo",
+				mpp_chip->ctrl_reg[i]);
+	}
+}
+
+int pm8xxx_mpp_config(unsigned mpp, unsigned type, unsigned level,
+		      unsigned control)
+{
+	struct pm8xxx_mpp_chip *mpp_chip;
+	int rc, found = 0;
+	u8 config, mask;
+
+	mutex_lock(&pm8xxx_mpp_chips_lock);
+	list_for_each_entry(mpp_chip, &pm8xxx_mpp_chips, link) {
+		if (mpp >= mpp_chip->mpp_base
+		    && mpp < mpp_chip->mpp_base + mpp_chip->nmpps) {
+			found = 1;
+			break;
+		}
+	}
+	mutex_unlock(&pm8xxx_mpp_chips_lock);
+	if (!found) {
+		pr_err("called on mpp %d not handled by any pmic\n", mpp);
+		return -EINVAL;
+	}
+
+	mask = PM8XXX_MPP_TYPE_MASK | PM8XXX_MPP_CONFIG_LVL_MASK |
+		PM8XXX_MPP_CONFIG_CTRL_MASK;
+	config = (type << PM8XXX_MPP_TYPE_SHIFT) & PM8XXX_MPP_TYPE_MASK;
+	config |= (level << PM8XXX_MPP_CONFIG_LVL_SHIFT) &
+			PM8XXX_MPP_CONFIG_LVL_MASK;
+	config |= control & PM8XXX_MPP_CONFIG_CTRL_MASK;
+
+	rc = pm8xxx_mpp_write(mpp_chip, mpp - mpp_chip->mpp_base, config, mask);
+
+	if (rc)
+		pr_err("pm8xxx_mpp_write(): rc=%d\n", rc);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(pm8xxx_mpp_config);
+
+static int __devinit pm8xxx_mpp_reg_init(struct pm8xxx_mpp_chip *mpp_chip)
+{
+	int rc, i;
+
+	for (i = 0; i < mpp_chip->nmpps; i++) {
+		rc = pm8xxx_readb(mpp_chip->gpio_chip.dev->parent,
+					mpp_chip->base_addr + i,
+					&mpp_chip->ctrl_reg[i]);
+		if (rc) {
+			pr_err("failed to read register 0x%x rc=%d\n",
+						mpp_chip->base_addr + i, rc);
+			return rc;
+		}
+	}
+	return 0;
+}
+
+static int __devinit pm8xxx_mpp_probe(struct platform_device *pdev)
+{
+	int rc;
+	const struct pm8xxx_mpp_platform_data *pdata = pdev->dev.platform_data;
+	struct pm8xxx_mpp_chip *mpp_chip;
+
+	if (!pdata) {
+		pr_err("missing platform data\n");
+		return -EINVAL;
+	}
+
+	mpp_chip = kzalloc(sizeof(struct pm8xxx_mpp_chip), GFP_KERNEL);
+	if (!mpp_chip) {
+		pr_err("Cannot allocate %d bytes\n",
+			sizeof(struct pm8xxx_mpp_chip));
+		return -ENOMEM;
+	}
+
+	mpp_chip->ctrl_reg = kzalloc(pdata->core_data.nmpps, GFP_KERNEL);
+	if (!mpp_chip->ctrl_reg) {
+		pr_err("Cannot allocate %d bytes\n", pdata->core_data.nmpps);
+		rc = -ENOMEM;
+		goto free_mpp_chip;
+	}
+
+	spin_lock_init(&mpp_chip->pm_lock);
+
+	mpp_chip->gpio_chip.label = PM8XXX_MPP_DEV_NAME;
+	mpp_chip->gpio_chip.direction_input = pm8xxx_mpp_dir_input;
+	mpp_chip->gpio_chip.direction_output = pm8xxx_mpp_dir_output;
+	mpp_chip->gpio_chip.to_irq = pm8xxx_mpp_to_irq;
+	mpp_chip->gpio_chip.get = pm8xxx_mpp_get;
+	mpp_chip->gpio_chip.set = pm8xxx_mpp_set;
+	mpp_chip->gpio_chip.dbg_show = pm8xxx_mpp_dbg_show;
+	mpp_chip->gpio_chip.ngpio = pdata->core_data.nmpps;
+	mpp_chip->gpio_chip.can_sleep = 1;
+	mpp_chip->gpio_chip.dev = &pdev->dev;
+	mpp_chip->gpio_chip.base = pdata->mpp_base;
+	mpp_chip->irq_base = platform_get_irq(pdev, 0);
+	mpp_chip->mpp_base = pdata->mpp_base;
+	mpp_chip->base_addr = pdata->core_data.base_addr;
+	mpp_chip->nmpps = pdata->core_data.nmpps;
+
+	mutex_lock(&pm8xxx_mpp_chips_lock);
+	list_add(&mpp_chip->link, &pm8xxx_mpp_chips);
+	mutex_unlock(&pm8xxx_mpp_chips_lock);
+
+	platform_set_drvdata(pdev, mpp_chip);
+
+	rc = gpiochip_add(&mpp_chip->gpio_chip);
+	if (rc) {
+		pr_err("gpiochip_add failed, rc=%d\n", rc);
+		goto reset_drvdata;
+	}
+
+	rc = pm8xxx_mpp_reg_init(mpp_chip);
+	if (rc) {
+		pr_err("failed to read MPP ctrl registers, rc=%d\n", rc);
+		goto remove_chip;
+	}
+
+	return 0;
+
+remove_chip:
+	if (gpiochip_remove(&mpp_chip->gpio_chip))
+		pr_err("failed to remove gpio chip\n");
+reset_drvdata:
+	platform_set_drvdata(pdev, NULL);
+free_mpp_chip:
+	kfree(mpp_chip);
+	return rc;
+}
+
+static int __devexit pm8xxx_mpp_remove(struct platform_device *pdev)
+{
+	struct pm8xxx_mpp_chip *mpp_chip = platform_get_drvdata(pdev);
+
+	mutex_lock(&pm8xxx_mpp_chips_lock);
+	list_del(&mpp_chip->link);
+	mutex_unlock(&pm8xxx_mpp_chips_lock);
+	platform_set_drvdata(pdev, NULL);
+	if (gpiochip_remove(&mpp_chip->gpio_chip))
+		pr_err("failed to remove gpio chip\n");
+	kfree(mpp_chip->ctrl_reg);
+	kfree(mpp_chip);
+
+	return 0;
+}
+
+static struct platform_driver pm8xxx_mpp_driver = {
+	.probe		= pm8xxx_mpp_probe,
+	.remove		= __devexit_p(pm8xxx_mpp_remove),
+	.driver		= {
+		.name	= PM8XXX_MPP_DEV_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init pm8xxx_mpp_init(void)
+{
+	return platform_driver_register(&pm8xxx_mpp_driver);
+}
+subsys_initcall(pm8xxx_mpp_init);
+
+static void __exit pm8xxx_mpp_exit(void)
+{
+	platform_driver_unregister(&pm8xxx_mpp_driver);
+}
+module_exit(pm8xxx_mpp_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("PM8XXX MPP driver");
+MODULE_VERSION("1.0");
+MODULE_ALIAS("platform:" PM8XXX_MPP_DEV_NAME);
diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index 0f1691f..2fbd42d 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -25,6 +25,8 @@
 #define REG_HWREV		0x002  /* PMIC4 revision */
 #define REG_HWREV_2		0x0E8  /* PMIC4 revision 2 */
 
+#define REG_MPP_BASE		0x050
+
 struct pm8921 {
 	struct device			*dev;
 	struct pm_irq_chip		*irq_chip;
@@ -96,6 +98,22 @@ static struct mfd_cell gpio_cell __devinitdata = {
 	.num_resources	= ARRAY_SIZE(gpio_cell_resources),
 };
 
+static const struct resource mpp_cell_resources[] __devinitconst = {
+	{
+		.start	= PM8921_IRQ_BLOCK_BIT(PM8921_MPP_BLOCK_START, 0),
+		.end	= PM8921_IRQ_BLOCK_BIT(PM8921_MPP_BLOCK_START, 0)
+			  + PM8921_NR_MPPS - 1,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct mfd_cell mpp_cell __devinitdata = {
+	.name		= PM8XXX_MPP_DEV_NAME,
+	.id		= -1,
+	.resources	= mpp_cell_resources,
+	.num_resources	= ARRAY_SIZE(mpp_cell_resources),
+};
+
 static int __devinit pm8921_add_subdevices(const struct pm8921_platform_data
 					   *pdata,
 					   struct pm8921 *pmic,
@@ -130,6 +148,18 @@ static int __devinit pm8921_add_subdevices(const struct pm8921_platform_data
 		}
 	}
 
+	if (pdata->mpp_pdata) {
+		pdata->mpp_pdata->core_data.nmpps = PM8921_NR_MPPS;
+		pdata->mpp_pdata->core_data.base_addr = REG_MPP_BASE;
+		mpp_cell.mfd_data = pdata->mpp_pdata;
+		ret = mfd_add_devices(pmic->dev, 0, &mpp_cell, 1, NULL,
+					irq_base);
+		if (ret) {
+			pr_err("Failed to add mpp subdevice ret=%d\n", ret);
+			goto bail;
+		}
+	}
+
 	return 0;
 bail:
 	if (pmic->irq_chip) {
diff --git a/include/linux/mfd/pm8xxx/mpp.h b/include/linux/mfd/pm8xxx/mpp.h
new file mode 100644
index 0000000..2d9884e
--- /dev/null
+++ b/include/linux/mfd/pm8xxx/mpp.h
@@ -0,0 +1,233 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
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
+#ifndef __PM8XXX_MPP_H
+#define __PM8XXX_MPP_H
+
+#include <linux/errno.h>
+
+#define PM8XXX_MPP_DEV_NAME	"pm8xxx-mpp"
+
+struct pm8xxx_mpp_core_data {
+	int	base_addr;
+	int	nmpps;
+};
+
+struct pm8xxx_mpp_platform_data {
+	struct pm8xxx_mpp_core_data	core_data;
+	int				mpp_base;
+};
+
+/* API */
+#if defined(CONFIG_GPIO_PM8XXX_MPP) || defined(CONFIG_GPIO_PM8XXX_MPP_MODULE)
+
+/**
+ * pm8xxx_mpp_config() - configure control options of a multi-purpose pin (MPP)
+ * @mpp:	global GPIO number corresponding to the MPP
+ * @type:	MPP type which determines the overall MPP function (i.e. digital
+ *		in/out/bi, analog in/out, current sink, or test).  It should be
+ *		set to the value of one of PM8XXX_MPP_TYPE_D_*.
+ * @level:	meaning depends upon MPP type specified
+ * @control:	meaning depends upon MPP type specified
+ * Context: can sleep
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ *
+ * Usage of level argument:
+ * 1. type = PM8XXX_MPP_TYPE_D_INPUT, PM8XXX_MPP_TYPE_D_OUTPUT,
+ *	     PM8XXX_MPP_TYPE_D_BI_DIR, or PM8XXX_MPP_TYPE_DTEST_OUTPUT -
+ *
+ *	level specifies that digital logic level to use for the MPP.  It should
+ *	be set to the value of one of PM8XXX_MPP_DIG_LEVEL_*.  Actual regulator
+ *	connections for these level choices are PMIC chip specific.
+ *
+ * 2. type = PM8XXX_MPP_TYPE_A_INPUT -
+ *
+ *	level specifies where in the PMIC chip the analog input value should
+ *	be routed to.  It should be set to the value of one of
+ *	PM8XXX_MPP_AIN_AMUX_*.
+ *
+ * 3. type = PM8XXX_MPP_TYPE_A_OUTPUT -
+ *
+ *	level specifies the output analog voltage reference level.  It should
+ *	be set to the value of one of PM8XXX_MPP_AOUT_LVL_*.
+ *
+ * 4. type = PM8XXX_MPP_TYPE_SINK or PM8XXX_MPP_TYPE_DTEST_SINK -
+ *
+ *	level specifies the output current level.  It should be set to the value
+ *	of one of PM8XXX_MPP_CS_OUT_*.
+ *
+ * Usage of control argument:
+ * 1. type = PM8XXX_MPP_TYPE_D_INPUT -
+ *
+ *	control specifies how the digital input should be routed in the chip.
+ *	It should be set to the value of one of PM8XXX_MPP_DIN_TO_*.
+ *
+ * 2. type = PM8XXX_MPP_TYPE_D_OUTPUT -
+ *
+ *	control specifies the digital output value.  It should be set to the
+ *	value of one of PM8XXX_MPP_DOUT_CTRL_*.
+ *
+ * 3. type = PM8XXX_MPP_TYPE_D_BI_DIR -
+ *
+ *	control specifies the pullup resistor value.  It should be set to the
+ *	value of one of PM8XXX_MPP_BI_PULLUP_*.
+ *
+ * 4. type = PM8XXX_MPP_TYPE_A_INPUT -
+ *
+ *	control is unused; a value of 0 is sufficient.
+ *
+ * 5. type = PM8XXX_MPP_TYPE_A_OUTPUT -
+ *
+ *	control specifies if analog output is enabled.  It should be set to the
+ *	value of one of PM8XXX_MPP_AOUT_CTRL_*.
+ *
+ * 6. type = PM8XXX_MPP_TYPE_SINK -
+ *
+ *	control specifies if current sinking is enabled.  It should be set to
+ *	the value of one of PM8XXX_MPP_CS_CTRL_*.
+ *
+ * 7. type = PM8XXX_MPP_TYPE_DTEST_SINK -
+ *
+ *	control specifies if current sinking is enabled.  It should be set to
+ *	the value of one of PM8XXX_MPP_DTEST_CS_CTRL_*.
+ *
+ * 8. type = PM8XXX_MPP_TYPE_DTEST_OUTPUT -
+ *
+ *	control specifies which DTEST bus value to output.  It should be set to
+ *	the value of one of PM8XXX_MPP_DTEST_*.
+ */
+int pm8xxx_mpp_config(unsigned mpp, unsigned type, unsigned level,
+		      unsigned control);
+
+#else
+
+static inline int pm8xxx_mpp_config(unsigned mpp, unsigned type, unsigned level,
+		      unsigned control)
+{
+	return -ENXIO;
+}
+
+#endif
+
+/* MPP Type: type */
+#define	PM8XXX_MPP_TYPE_D_INPUT		0
+#define	PM8XXX_MPP_TYPE_D_OUTPUT	1
+#define	PM8XXX_MPP_TYPE_D_BI_DIR	2
+#define	PM8XXX_MPP_TYPE_A_INPUT		3
+#define	PM8XXX_MPP_TYPE_A_OUTPUT	4
+#define	PM8XXX_MPP_TYPE_SINK		5
+#define	PM8XXX_MPP_TYPE_DTEST_SINK	6
+#define	PM8XXX_MPP_TYPE_DTEST_OUTPUT	7
+
+/* Digital Input/Output: level */
+#define	PM8XXX_MPP_DIG_LEVEL_VIO_0	0
+#define	PM8XXX_MPP_DIG_LEVEL_VIO_1	1
+#define	PM8XXX_MPP_DIG_LEVEL_VIO_2	2
+#define	PM8XXX_MPP_DIG_LEVEL_VIO_3	3
+#define	PM8XXX_MPP_DIG_LEVEL_VIO_4	4
+#define	PM8XXX_MPP_DIG_LEVEL_VIO_5	5
+#define	PM8XXX_MPP_DIG_LEVEL_VIO_6	6
+#define	PM8XXX_MPP_DIG_LEVEL_VIO_7	7
+
+/* Digital Input/Output: level [PM8058] */
+#define	PM8058_MPP_DIG_LEVEL_VPH	0
+#define	PM8058_MPP_DIG_LEVEL_S3		1
+#define	PM8058_MPP_DIG_LEVEL_L2		2
+#define	PM8058_MPP_DIG_LEVEL_L3		3
+
+/* Digital Input/Output: level [PM8901] */
+#define	PM8901_MPP_DIG_LEVEL_MSMIO	0
+#define	PM8901_MPP_DIG_LEVEL_DIG	1
+#define	PM8901_MPP_DIG_LEVEL_L5		2
+#define	PM8901_MPP_DIG_LEVEL_S4		3
+#define	PM8901_MPP_DIG_LEVEL_VPH	4
+
+/* Digital Input/Output: level [PM8921] */
+#define	PM8921_MPP_DIG_LEVEL_S4		1
+#define	PM8921_MPP_DIG_LEVEL_L15	3
+#define	PM8921_MPP_DIG_LEVEL_L17	4
+#define	PM8921_MPP_DIG_LEVEL_VPH	7
+
+/* Digital Input: control */
+#define	PM8XXX_MPP_DIN_TO_INT		0
+#define	PM8XXX_MPP_DIN_TO_DBUS1		1
+#define	PM8XXX_MPP_DIN_TO_DBUS2		2
+#define	PM8XXX_MPP_DIN_TO_DBUS3		3
+
+/* Digital Output: control */
+#define	PM8XXX_MPP_DOUT_CTRL_LOW	0
+#define	PM8XXX_MPP_DOUT_CTRL_HIGH	1
+#define	PM8XXX_MPP_DOUT_CTRL_MPP	2
+#define	PM8XXX_MPP_DOUT_CTRL_INV_MPP	3
+
+/* Bidirectional: control */
+#define	PM8XXX_MPP_BI_PULLUP_1KOHM	0
+#define	PM8XXX_MPP_BI_PULLUP_OPEN	1
+#define	PM8XXX_MPP_BI_PULLUP_10KOHM	2
+#define	PM8XXX_MPP_BI_PULLUP_30KOHM	3
+
+/* Analog Input: level */
+#define	PM8XXX_MPP_AIN_AMUX_CH5		0
+#define	PM8XXX_MPP_AIN_AMUX_CH6		1
+#define	PM8XXX_MPP_AIN_AMUX_CH7		2
+#define	PM8XXX_MPP_AIN_AMUX_CH8		3
+#define	PM8XXX_MPP_AIN_AMUX_CH9		4
+#define	PM8XXX_MPP_AIN_AMUX_ABUS1	5
+#define	PM8XXX_MPP_AIN_AMUX_ABUS2	6
+#define	PM8XXX_MPP_AIN_AMUX_ABUS3	7
+
+/* Analog Output: level */
+#define	PM8XXX_MPP_AOUT_LVL_1V25	0
+#define	PM8XXX_MPP_AOUT_LVL_1V25_2	1
+#define	PM8XXX_MPP_AOUT_LVL_0V625	2
+#define	PM8XXX_MPP_AOUT_LVL_0V3125	3
+#define	PM8XXX_MPP_AOUT_LVL_MPP		4
+#define	PM8XXX_MPP_AOUT_LVL_ABUS1	5
+#define	PM8XXX_MPP_AOUT_LVL_ABUS2	6
+#define	PM8XXX_MPP_AOUT_LVL_ABUS3	7
+
+/* Analog Output: control */
+#define	PM8XXX_MPP_AOUT_CTRL_DISABLE		0
+#define	PM8XXX_MPP_AOUT_CTRL_ENABLE		1
+#define	PM8XXX_MPP_AOUT_CTRL_MPP_HIGH_EN	2
+#define	PM8XXX_MPP_AOUT_CTRL_MPP_LOW_EN		3
+
+/* Current Sink: level */
+#define	PM8XXX_MPP_CS_OUT_5MA		0
+#define	PM8XXX_MPP_CS_OUT_10MA		1
+#define	PM8XXX_MPP_CS_OUT_15MA		2
+#define	PM8XXX_MPP_CS_OUT_20MA		3
+#define	PM8XXX_MPP_CS_OUT_25MA		4
+#define	PM8XXX_MPP_CS_OUT_30MA		5
+#define	PM8XXX_MPP_CS_OUT_35MA		6
+#define	PM8XXX_MPP_CS_OUT_40MA		7
+
+/* Current Sink: control */
+#define	PM8XXX_MPP_CS_CTRL_DISABLE	0
+#define	PM8XXX_MPP_CS_CTRL_ENABLE	1
+#define	PM8XXX_MPP_CS_CTRL_MPP_HIGH_EN	2
+#define	PM8XXX_MPP_CS_CTRL_MPP_LOW_EN	3
+
+/* DTEST Current Sink: control */
+#define	PM8XXX_MPP_DTEST_CS_CTRL_EN1	0
+#define	PM8XXX_MPP_DTEST_CS_CTRL_EN2	1
+#define	PM8XXX_MPP_DTEST_CS_CTRL_EN3	2
+#define	PM8XXX_MPP_DTEST_CS_CTRL_EN4	3
+
+/* DTEST Digital Output: control */
+#define	PM8XXX_MPP_DTEST_DBUS1		0
+#define	PM8XXX_MPP_DTEST_DBUS2		1
+#define	PM8XXX_MPP_DTEST_DBUS3		2
+#define	PM8XXX_MPP_DTEST_DBUS4		3
+
+#endif
diff --git a/include/linux/mfd/pm8xxx/pm8921.h b/include/linux/mfd/pm8xxx/pm8921.h
index def8c31..19cffb2 100644
--- a/include/linux/mfd/pm8xxx/pm8921.h
+++ b/include/linux/mfd/pm8xxx/pm8921.h
@@ -21,22 +21,29 @@
 #include <linux/device.h>
 #include <linux/mfd/pm8xxx/irq.h>
 #include <linux/mfd/pm8xxx/gpio.h>
+#include <linux/mfd/pm8xxx/mpp.h>
 
 #define PM8921_NR_IRQS		256
 
 #define PM8921_NR_GPIOS		44
 
+#define PM8921_NR_MPPS		12
+
 #define PM8921_GPIO_BLOCK_START	24
+#define PM8921_MPP_BLOCK_START	16
 #define PM8921_IRQ_BLOCK_BIT(block, bit) ((block) * 8 + (bit))
 
-/* GPIOs [1,N] */
+/* GPIOs and MPPs [1,N] */
 #define PM8921_GPIO_IRQ(base, gpio)	((base) + \
 		PM8921_IRQ_BLOCK_BIT(PM8921_GPIO_BLOCK_START, (gpio)-1))
+#define PM8921_MPP_IRQ(base, mpp)	((base) + \
+		PM8921_IRQ_BLOCK_BIT(PM8921_MPP_BLOCK_START, (mpp)-1))
 
 struct pm8921_platform_data {
 	int					irq_base;
 	struct pm8xxx_irq_platform_data		*irq_pdata;
 	struct pm8xxx_gpio_platform_data	*gpio_pdata;
+	struct pm8xxx_mpp_platform_data		*mpp_pdata;
 };
 
 #endif
-- 
1.7.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
