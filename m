Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab0KJMsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 07:48:51 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19080 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab0KJMsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 07:48:46 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6162"; a="61428857"
From: Trilok Soni <tsoni@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-arm-msm@vger.kernel.org, Anirudh Ghayal <aghayal@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [RFC v1 PATCH 5/6] input: pmic8058-othc: Add support for PM8058 based OTHC
Date: Wed, 10 Nov 2010 18:18:00 +0530
Message-Id: <1289393281-4459-6-git-send-email-tsoni@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org>
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anirudh Ghayal <aghayal@codeaurora.org>

One-touch headset controller is a hardware module in Qualcomm's PMIC8058.
It supports headset insert/remove and switch press/release detection events
over 3 MIC BIAS lines. The MIC BIAS lines can be configured to support
headset detection or act as regular BIAS lines.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Anirudh Ghayal <aghayal@codeaurora.org>
---
 drivers/input/misc/Kconfig          |   10 +
 drivers/input/misc/Makefile         |    1 +
 drivers/input/misc/pmic8058-othc.c  |  544 +++++++++++++++++++++++++++++++++++
 include/linux/input/pmic8058-othc.h |  117 ++++++++
 4 files changed, 672 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/pmic8058-othc.c
 create mode 100644 include/linux/input/pmic8058-othc.h

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index aeb9165..df6097c 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -359,6 +359,16 @@ config INPUT_PMIC8058_PWRKEY
 	  To compile this driver as a module, choose M here: the
 	  module will be called pmic8058-pwrkey.
 
+config INPUT_PMIC8058_OTHC
+	tristate "Qualcomm PMIC8058 OTHC support"
+	depends on PMIC8058
+	help
+	  Say Y here if you want support PMIC8058 One-touch Headset Controller
+	  (OTHC)
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called pmic8058-othc.
+
 config INPUT_GPIO_ROTARY_ENCODER
 	tristate "Rotary encoders connected to GPIO pins"
 	depends on GPIOLIB && GENERIC_GPIO
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index c4357a0..a713370 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_INPUT_PCAP)		+= pcap_keys.o
 obj-$(CONFIG_INPUT_PCF50633_PMU)	+= pcf50633-input.o
 obj-$(CONFIG_INPUT_PCF8574)		+= pcf8574_keypad.o
 obj-$(CONFIG_INPUT_PCSPKR)		+= pcspkr.o
+obj-$(CONFIG_INPUT_PMIC8058_OTHC)	+= pmic8058-othc.o
 obj-$(CONFIG_INPUT_POWERMATE)		+= powermate.o
 obj-$(CONFIG_INPUT_PWM_BEEPER)		+= pwm-beeper.o
 obj-$(CONFIG_INPUT_PMIC8058_PWRKEY)	+= pmic8058-pwrkey.o
diff --git a/drivers/input/misc/pmic8058-othc.c b/drivers/input/misc/pmic8058-othc.c
new file mode 100644
index 0000000..78f157a
--- /dev/null
+++ b/drivers/input/misc/pmic8058-othc.c
@@ -0,0 +1,544 @@
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#define pr_fmt(fmt) "%s:" fmt, __func__
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/input.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+
+#include <linux/mfd/pmic8058.h>
+#include <linux/input/pmic8058-othc.h>
+
+#define PM8058_OTHC_LOW_CURR_MASK	0xF0
+#define PM8058_OTHC_HIGH_CURR_MASK	0x0F
+#define PM8058_OTHC_EN_SIG_MASK		0x3F
+#define PM8058_OTHC_HYST_PREDIV_MASK	0xC7
+#define PM8058_OTHC_CLK_PREDIV_MASK	0xF8
+#define PM8058_OTHC_HYST_CLK_MASK	0x0F
+#define PM8058_OTHC_PERIOD_CLK_MASK	0xF0
+
+#define PM8058_OTHC_LOW_CURR_SHIFT	0x4
+#define PM8058_OTHC_EN_SIG_SHIFT	0x6
+#define PM8058_OTHC_HYST_PREDIV_SHIFT	0x3
+#define PM8058_OTHC_HYST_CLK_SHIFT	0x4
+
+#define PM8058_OTHC_LOW_CURR_MIRROR	10
+#define PM8058_OTHC_HIGH_CURR_MIRROR	100
+#define PM8058_OTHC_CLK_SRC_SHIFT	10
+
+/**
+ * struct pm8058_othc - othc driver data structure
+ * @othc_ipd: input device for othc
+ * @othc_pdata:	a pointer to the platform data
+ * @othc_base: base address of the OTHC controller
+ * @othc_irq_sw: switch detect irq number
+ * @othc_irq_ir: headset jack detect irq number
+ * @othc_sw_state: current state of the switch
+ * @othc_ir_state: current state of the headset
+ * @switch_reject: indicates if valid switch press
+ * @switch_debounce_ms: the debounce time for the switch
+ * @lock: spin lock variable
+ * @timer: timer for switch debounce time
+ * @pm_chip: pointer to the pm8058 parent chip
+ */
+struct pm8058_othc {
+	struct input_dev *othc_ipd;
+	struct pmic8058_othc_config_pdata *othc_pdata;
+	int othc_base;
+	int othc_irq_sw;
+	int othc_irq_ir;
+	bool othc_sw_state;
+	bool othc_ir_state;
+	bool switch_reject;
+	unsigned long switch_debounce_ms;
+	spinlock_t lock;
+	struct timer_list timer;
+	struct pm8058_chip *pm_chip;
+};
+
+static struct pm8058_othc *config[OTHC_MICBIAS_MAX];
+
+/**
+ * pm8058_micbias_enable() - Enables/Disables the MIC_BIAS
+ * @micbias:	MIC BIAS line which needs to be enabled
+ * @enable:	operational state for the MIC BIAS line
+ *
+ * The API pm8058_micbias_enable()  configures the MIC_BIAS. Only the lines
+ * which are not used for headset detection can be configured using this API.
+ * The API returns an error code if it fails to configure, else it returns 0.
+ */
+int pm8058_micbias_enable(enum othc_micbias micbias,
+		enum othc_micbias_enable enable)
+{
+	int rc;
+	u8 reg;
+	struct pm8058_othc *dd = config[micbias];
+
+	if (dd == NULL) {
+		pr_err("MIC_BIAS not registered, cannot enable\n");
+		return -ENODEV;
+	}
+
+	if (dd->othc_pdata->micbias_capability != OTHC_MICBIAS) {
+		pr_err("MIC_BIAS enable capability not supported\n");
+		return -EINVAL;
+	}
+
+	rc = pm8058_read(dd->pm_chip, dd->othc_base + 1, &reg, 1);
+	if (rc < 0) {
+		pr_err("PM8058 read failed\n");
+		return rc;
+	}
+
+	reg &= PM8058_OTHC_EN_SIG_MASK;
+	reg |= (enable << PM8058_OTHC_EN_SIG_SHIFT);
+
+	rc = pm8058_write(dd->pm_chip, dd->othc_base + 1, &reg, 1);
+	if (rc < 0) {
+		pr_err("PM8058 write failed\n");
+		return rc;
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL(pm8058_micbias_enable);
+
+#ifdef CONFIG_PM
+static int pm8058_othc_suspend(struct device *dev)
+{
+	struct pm8058_othc *dd = dev_get_drvdata(dev);
+
+	if (dd->othc_pdata->micbias_capability == OTHC_MICBIAS_HSED) {
+		if (device_may_wakeup(dev)) {
+			enable_irq_wake(dd->othc_irq_sw);
+			enable_irq_wake(dd->othc_irq_ir);
+		}
+	}
+
+	return 0;
+}
+
+static int pm8058_othc_resume(struct device *dev)
+{
+	struct pm8058_othc *dd = dev_get_drvdata(dev);
+
+	if (dd->othc_pdata->micbias_capability == OTHC_MICBIAS_HSED) {
+		if (device_may_wakeup(dev)) {
+			disable_irq_wake(dd->othc_irq_sw);
+			disable_irq_wake(dd->othc_irq_ir);
+		}
+	}
+
+	return 0;
+}
+
+static const struct dev_pm_ops pm8058_othc_pm_ops = {
+	.suspend = pm8058_othc_suspend,
+	.resume = pm8058_othc_resume,
+};
+#endif
+
+static int __devexit pm8058_othc_remove(struct platform_device *pd)
+{
+	struct pm8058_othc *dd = platform_get_drvdata(pd);
+
+	if (dd->othc_pdata->micbias_capability == OTHC_MICBIAS_HSED) {
+		device_init_wakeup(&pd->dev, 0);
+		free_irq(dd->othc_irq_sw, dd);
+		free_irq(dd->othc_irq_ir, dd);
+		del_timer_sync(&dd->timer);
+		input_unregister_device(dd->othc_ipd);
+	}
+
+	kfree(dd);
+
+	return 0;
+}
+
+static void pm8058_othc_timer(unsigned long handle)
+{
+	unsigned long flags;
+	struct pm8058_othc *dd = (struct pm8058_othc *)handle;
+
+	spin_lock_irqsave(&dd->lock, flags);
+	dd->switch_reject = false;
+	spin_unlock_irqrestore(&dd->lock, flags);
+}
+
+static irqreturn_t pm8058_no_sw(int irq, void *dev_id)
+{
+	struct pm8058_othc *dd = dev_id;
+	unsigned long flags;
+
+	/*
+	 * Due to a hardware bug, spurious switch interrutps are seen while
+	 * inserting the headset slowly. A timer based logic rejects these
+	 * switch interrutps.
+	 */
+	spin_lock_irqsave(&dd->lock, flags);
+	if (dd->switch_reject == true) {
+		spin_unlock_irqrestore(&dd->lock, flags);
+		return IRQ_HANDLED;
+	}
+	spin_unlock_irqrestore(&dd->lock, flags);
+
+	if (dd->othc_sw_state == false) {
+		dd->othc_sw_state = true;
+		input_report_key(dd->othc_ipd, KEY_MEDIA, 1);
+	} else if (dd->othc_sw_state == true) {
+		dd->othc_sw_state = false;
+		input_report_key(dd->othc_ipd, KEY_MEDIA, 0);
+	}
+	input_sync(dd->othc_ipd);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t pm8058_nc_ir(int irq, void *dev_id)
+{
+	unsigned long flags;
+	struct pm8058_othc *dd = dev_id;
+
+	spin_lock_irqsave(&dd->lock, flags);
+	dd->switch_reject = true;
+	spin_unlock_irqrestore(&dd->lock, flags);
+
+	mod_timer(&dd->timer, jiffies +
+		msecs_to_jiffies(dd->switch_debounce_ms));
+
+	if (dd->othc_ir_state == false) {
+		dd->othc_ir_state = true;
+		input_report_key(dd->othc_ipd, SW_HEADPHONE_INSERT, 1);
+	} else {
+		dd->othc_ir_state = false;
+		input_report_key(dd->othc_ipd, SW_HEADPHONE_INSERT, 0);
+	}
+
+	input_sync(dd->othc_ipd);
+
+	return IRQ_HANDLED;
+}
+
+static int pm8058_configure_othc(struct pm8058_othc *dd)
+{
+	int rc;
+	u8 reg, value;
+	u32 value1;
+	u16 base_addr = dd->othc_base;
+	struct othc_hsed_config *hsed_config = dd->othc_pdata->hsed_config;
+
+	/* Control Register 1*/
+	rc = pm8058_read(dd->pm_chip, base_addr, &reg, 1);
+	if (rc < 0) {
+		pr_err("PM8058 read failed\n");
+		return rc;
+	}
+
+	if (hsed_config->othc_headset == OTHC_HEADSET_NO) {
+		/* set iDAC high current threshold */
+		value = (hsed_config->othc_highcurr_thresh_uA /
+					PM8058_OTHC_HIGH_CURR_MIRROR) - 2;
+		reg =  (reg & PM8058_OTHC_HIGH_CURR_MASK) | value;
+	} else {
+		/* set iDAC low current threshold */
+		value = (hsed_config->othc_lowcurr_thresh_uA /
+					PM8058_OTHC_LOW_CURR_MIRROR) - 1;
+		reg &= PM8058_OTHC_LOW_CURR_MASK;
+		reg |= (value << PM8058_OTHC_LOW_CURR_SHIFT);
+	}
+
+	rc = pm8058_write(dd->pm_chip, base_addr, &reg, 1);
+	if (rc < 0) {
+		pr_err("PM8058 read failed\n");
+		return rc;
+	}
+
+	/* Control register 2*/
+	rc = pm8058_read(dd->pm_chip, base_addr + 1, &reg, 1);
+	if (rc < 0) {
+		pr_err("PM8058 read failed\n");
+		return rc;
+	}
+
+	value = dd->othc_pdata->micbias_enable;
+	reg &= PM8058_OTHC_EN_SIG_MASK;
+	reg |= (value << PM8058_OTHC_EN_SIG_SHIFT);
+
+	value = 0;
+	value1 = (hsed_config->othc_hyst_prediv_us <<
+				PM8058_OTHC_CLK_SRC_SHIFT) / USEC_PER_SEC;
+	while (value1 != 0) {
+		value1 = value1 >> 1;
+		value++;
+	}
+	if (value > 7) {
+		pr_err("Invalid input argument - othc_hyst_prediv_us\n");
+		return -EINVAL;
+	}
+	reg &= PM8058_OTHC_HYST_PREDIV_MASK;
+	reg |= (value << PM8058_OTHC_HYST_PREDIV_SHIFT);
+
+	value = 0;
+	value1 = (hsed_config->othc_period_clkdiv_us <<
+				PM8058_OTHC_CLK_SRC_SHIFT) / USEC_PER_SEC;
+	while (value1 != 1) {
+		value1 = value1 >> 1;
+		value++;
+	}
+	if (value > 8) {
+		pr_err("Invalid input argument - othc_period_clkdiv_us\n");
+		return -EINVAL;
+	}
+	reg = (reg &  PM8058_OTHC_CLK_PREDIV_MASK) | (value - 1);
+
+	rc = pm8058_write(dd->pm_chip, base_addr + 1, &reg, 1);
+	if (rc < 0) {
+		pr_err("PM8058 read failed\n");
+		return rc;
+	}
+
+	/* Control register 3 */
+	rc = pm8058_read(dd->pm_chip, base_addr + 2 , &reg, 1);
+	if (rc < 0) {
+		pr_err("PM8058 read failed\n");
+		return rc;
+	}
+
+	value = hsed_config->othc_hyst_clk_us /
+					hsed_config->othc_hyst_prediv_us;
+	if (value > 15) {
+		pr_err("Invalid input argument - othc_hyst_prediv_us\n");
+		return -EINVAL;
+	}
+	reg &= PM8058_OTHC_HYST_CLK_MASK;
+	reg |= value << PM8058_OTHC_HYST_CLK_SHIFT;
+
+	value = hsed_config->othc_period_clk_us /
+					hsed_config->othc_period_clkdiv_us;
+	if (value > 15) {
+		pr_err("Invalid input argument - othc_hyst_prediv_us\n");
+		return -EINVAL;
+	}
+	reg = (reg & PM8058_OTHC_PERIOD_CLK_MASK) | value;
+
+	rc = pm8058_write(dd->pm_chip, base_addr + 2, &reg, 1);
+	if (rc < 0) {
+		pr_err("PM8058 read failed\n");
+		return rc;
+	}
+
+	return 0;
+}
+
+static int
+pm8058_othc_configure_hsed(struct pm8058_othc *dd, struct platform_device *pd)
+{
+	int rc;
+	struct input_dev *ipd;
+	struct pmic8058_othc_config_pdata *pdata = pd->dev.platform_data;
+	struct othc_hsed_config *hsed_config = pdata->hsed_config;
+
+	ipd = input_allocate_device();
+	if (ipd == NULL) {
+		dev_err(&pd->dev, "Memory allocate to input device failed!\n");
+		rc = -ENOMEM;
+		goto fail_input_alloc;
+	}
+
+	dd->othc_irq_sw = platform_get_irq(pd, 0);
+	dd->othc_irq_ir = platform_get_irq(pd, 1);
+	if (dd->othc_irq_ir < 0 || dd->othc_irq_sw < 0) {
+		dev_err(&pd->dev, "othc resource:IRQ_IR absent!\n");
+		rc = -ENXIO;
+		goto fail_othc_config;
+	}
+
+	ipd->name = "pmic8058_othc";
+	ipd->phys = "pmic8058_othc/input0";
+	ipd->dev.parent = &pd->dev;
+
+	input_set_capability(ipd, EV_SW, SW_HEADPHONE_INSERT);
+	input_set_capability(ipd, EV_KEY, KEY_MEDIA);
+
+	input_set_drvdata(ipd, dd);
+
+	dd->othc_ipd = ipd;
+	dd->othc_sw_state = false;
+	dd->othc_ir_state = false;
+	spin_lock_init(&dd->lock);
+	dd->switch_debounce_ms = hsed_config->switch_debounce_ms;
+	setup_timer(&dd->timer, pm8058_othc_timer, (unsigned long) dd);
+
+	rc = pm8058_configure_othc(dd);
+	if (rc < 0)
+		goto fail_othc_config;
+
+	rc = input_register_device(ipd);
+	if (rc) {
+		dev_err(&pd->dev, "Register OTHC device failed!\n");
+		goto fail_othc_config;
+	}
+
+	/* Check if the headset is already inserted during boot up */
+	rc = pm8058_irq_get_rt_status(dd->pm_chip, dd->othc_irq_ir);
+	if (rc < 0) {
+		dev_err(&pd->dev, "Unable to get headset status at boot!\n");
+		goto fail_ir_irq;
+	}
+	if (rc) {
+		dev_dbg(&pd->dev, "Headset inserted during boot up!\n");
+		dd->othc_ir_state = true;
+		input_report_switch(dd->othc_ipd, SW_HEADPHONE_INSERT, 1);
+		input_sync(dd->othc_ipd);
+	}
+
+	rc = request_any_context_irq(dd->othc_irq_ir, pm8058_nc_ir,
+		IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+					"pm8058_othc_ir", dd);
+	if (rc < 0) {
+		dev_err(&pd->dev, "Request pm8058_othc_ir IRQ failed!\n");
+		goto fail_ir_irq;
+	}
+
+	rc = request_any_context_irq(dd->othc_irq_sw, pm8058_no_sw,
+		IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+					"pm8058_othc_sw", dd);
+	if (rc < 0) {
+		dev_err(&pd->dev, "Request pm8058_othc_sw IRQ failed!\n");
+		goto fail_sw_irq;
+	}
+
+	device_init_wakeup(&pd->dev, hsed_config->othc_wakeup);
+
+	return 0;
+
+fail_sw_irq:
+	free_irq(dd->othc_irq_ir, dd);
+fail_ir_irq:
+	input_unregister_device(ipd);
+	dd->othc_ipd = NULL;
+fail_othc_config:
+	input_free_device(ipd);
+fail_input_alloc:
+	return rc;
+}
+
+static int __devinit pm8058_othc_probe(struct platform_device *pd)
+{
+	int rc;
+	struct pm8058_othc *dd;
+	struct pm8058_chip *chip;
+	struct resource *res;
+	struct pmic8058_othc_config_pdata *pdata = pd->dev.platform_data;
+
+	chip = platform_get_drvdata(pd);
+	if (chip == NULL) {
+		dev_err(&pd->dev, "Invalid driver information!\n");
+		return  -EINVAL;
+	}
+
+	/* PMIC8058 version A0 not supported */
+	if (pm8058_rev(chip) == PM_8058_REV_1p0) {
+		dev_err(&pd->dev, "PMIC8058 version not supported!\n");
+		return -ENODEV;
+	}
+
+	if (pdata == NULL) {
+		dev_err(&pd->dev, "Platform data not present!\n");
+		return -EINVAL;
+	}
+
+	dd = kzalloc(sizeof(*dd), GFP_KERNEL);
+	if (dd == NULL) {
+		dev_err(&pd->dev, "Unable to allocate memory!\n");
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource_byname(pd, IORESOURCE_IO, "othc_base");
+	if (res == NULL) {
+		dev_err(&pd->dev, "OTHC Base address, resource absent!\n");
+		rc = -ENXIO;
+		goto fail_get_res;
+	}
+
+	dd->othc_pdata = pdata;
+	dd->pm_chip = chip;
+	dd->othc_base = res->start;
+
+	platform_set_drvdata(pd, dd);
+
+	if (pdata->micbias_capability == OTHC_MICBIAS_HSED) {
+		/* HSED to be supported on this MICBIAS line */
+		if (pdata->hsed_config != NULL) {
+			rc = pm8058_othc_configure_hsed(dd, pd);
+			if (rc < 0)
+				goto fail_get_res;
+		} else {
+			dev_err(&pd->dev, "HSED config data absent!\n");
+			rc = -EINVAL;
+			goto fail_get_res;
+		}
+	}
+
+	/* Store the local driver data structure */
+	if (dd->othc_pdata->micbias_select < OTHC_MICBIAS_MAX)
+		config[dd->othc_pdata->micbias_select] = dd;
+
+	dev_dbg(&pd->dev, "Device %s:%d successfully registered\n",
+						pd->name, pd->id);
+	return 0;
+
+fail_get_res:
+	kfree(dd);
+	return rc;
+}
+
+static struct platform_driver pm8058_othc_driver = {
+	.driver = {
+		.name = "pm8058-othc",
+		.owner = THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm = &pm8058_othc_pm_ops,
+#endif
+	},
+	.probe = pm8058_othc_probe,
+	.remove = __devexit_p(pm8058_othc_remove),
+};
+
+static int __init pm8058_othc_init(void)
+{
+	return platform_driver_register(&pm8058_othc_driver);
+}
+
+static void __exit pm8058_othc_exit(void)
+{
+	platform_driver_unregister(&pm8058_othc_driver);
+}
+
+module_init(pm8058_othc_init);
+module_exit(pm8058_othc_exit);
+
+MODULE_ALIAS("platform:pmic8058_othc");
+MODULE_DESCRIPTION("PMIC8058 OTHC");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Anirudh Ghayal <aghayal@codeaurora.org>");
diff --git a/include/linux/input/pmic8058-othc.h b/include/linux/input/pmic8058-othc.h
new file mode 100644
index 0000000..341ac7c
--- /dev/null
+++ b/include/linux/input/pmic8058-othc.h
@@ -0,0 +1,117 @@
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef __PMIC8058_OTHC_H__
+#define __PMIC8058_OTHC_H__
+
+/**
+ * enum othc_micbias_enable - MIC BIAS operational states
+ *
+ * This enum describes the different configurations of the BIAS line.
+ */
+enum othc_micbias_enable {
+	/* Turn off BIAS */
+	OTHC_SIGNAL_OFF,
+	/* Turn on BIAS if TCXO_EN is high */
+	OTHC_SIGNAL_TCXO,
+	/* Turn on BIAS if TCXO_EN or PWN is high */
+	OTHC_SIGNAL_PWM_TCXO,
+	/* Turn on BIAS always */
+	OTHC_SIGNAL_ALWAYS_ON,
+};
+
+/**
+ * enum othc_headset_type - Different type of supported headset
+ *
+ * This enum describes the different types of supported headsets.
+ */
+enum othc_headset_type {
+	OTHC_HEADSET_NO,
+	OTHC_HEADSET_NC,
+};
+
+/**
+ * enum othc_micbias -  Lists the number of MIC BIAS lines.
+ *
+ * This enum lists all the total number of BIAS lines.
+ */
+enum othc_micbias {
+	OTHC_MICBIAS_0,
+	OTHC_MICBIAS_1,
+	OTHC_MICBIAS_2,
+	OTHC_MICBIAS_MAX,
+};
+
+/**
+ * enum othc_micbias_capability - Capability of the MIC BIAS line
+ *
+ * This enum describes the capability of the MIC BIAS line, it can either be
+ * used for headset or a regular speaker MIC BIAS.
+ */
+enum othc_micbias_capability {
+	OTHC_MICBIAS,
+	OTHC_MICBIAS_HSED,
+};
+
+/**
+ * struct othc_hsed_config - headset specific configuration structure
+ * @othc_headset: type of headset
+ * @othc_lowcurr_thresh_uA: low current threshold for the headset
+ * @othc_highcurr_thresh_uA: high  current threshold for the headset
+ * @othc_hyst_prediv_us: hysterisis time pre-divider
+ * @othc_period_clkdiv_us: pwm period pre-divider
+ * @othc_hyst_clk_us: hysterisis clock period
+ * @othc_hyst_clk_us: hysterisis clock period
+ * @othc_period_clk_us: pwm clock period
+ * @othc_wakeup: wakeup capability
+ * @switch_debounce_ms: specifies the switch debounce time
+ *
+ * This structure provides the configurable parameters for headset. This is a
+ * part of the platform data.
+ */
+struct othc_hsed_config {
+	enum othc_headset_type othc_headset;
+	u16 othc_lowcurr_thresh_uA;
+	u16 othc_highcurr_thresh_uA;
+	u32 othc_hyst_prediv_us;
+	u32 othc_period_clkdiv_us;
+	u32 othc_hyst_clk_us;
+	u32 othc_period_clk_us;
+	int othc_wakeup;
+	unsigned long switch_debounce_ms;
+};
+
+/**
+ * struct pmic8058_othc_config_pdata - platform data for OTHC
+ * @micbias_select: selects the MIC BIAS
+ * @micbias_enable: default operational configuration of the MIC BIAS
+ * @micbias_capability: capability supported by the MIC BIAS
+ * @hsed_config: pointer to headset configuration
+ *
+ * This structure is the platform data provided to the OTHC driver
+ */
+struct pmic8058_othc_config_pdata {
+	enum othc_micbias micbias_select;
+	enum othc_micbias_enable micbias_enable;
+	enum othc_micbias_capability micbias_capability;
+	struct othc_hsed_config *hsed_config;
+};
+
+int pm8058_micbias_enable(enum othc_micbias micbias,
+				enum othc_micbias_enable enable);
+
+#endif /* __PMIC8058_OTHC_H__ */
-- 
1.7.0.2

