Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab1LBN5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 08:57:14 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:50848 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756596Ab1LBN5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 08:57:13 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Richard Purdie <rpurdie@rpsys.net>, <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] leds: driver for ab5500 high voltage leds
Date: Fri, 2 Dec 2011 14:56:22 +0100
Message-ID: <1322834182-26168-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>

Simple HV LED controller driver for AB5500v1.0 MFD chips

Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Tested-by: Naga Radesh Y <naga.radheshy@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
This depends on the other movement patch since it handily puts the
platform data header in <linux/mfd/abx500/ab5500-leds.h>.
---
 Documentation/ABI/testing/sysfs-class-led-ab5500 |   27 +
 drivers/leds/Kconfig                             |    9 +
 drivers/leds/Makefile                            |    1 +
 drivers/leds/leds-ab5500.c                       |  830 ++++++++++++++++++++++
 include/linux/mfd/abx500/ab5500-leds.h           |   54 ++
 5 files changed, 921 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-led-ab5500
 create mode 100644 drivers/leds/leds-ab5500.c
 create mode 100644 include/linux/mfd/abx500/ab5500-leds.h

diff --git a/Documentation/ABI/testing/sysfs-class-led-ab5500 b/Documentation/ABI/testing/sysfs-class-led-ab5500
new file mode 100644
index 0000000..556b9c3
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-led-ab5500
@@ -0,0 +1,27 @@
+What:		/sys/class/leds/<led>/fade_auto
+Date:		December 2011
+KernelVersion:	3.3
+Contact:	Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
+Description:
+		Set the auto fadeout mode for the LED.
+		0 = no auto fadeout
+		1 = auto fadeout
+
+What:		/sys/class/leds/<led>/fade_delay
+Date:		December 2011
+KernelVersion:	3.3
+Contact:	Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
+Description:
+		Set the auto fadeout delay for the LED.
+		0 = no delay
+		1 = 1/2 second
+		2 = 1 second
+		3 = 2 seconds
+
+What:		/sys/class/leds/<led>/led_current
+Date:		December 2011
+KernelVersion:	3.3
+Contact:	Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
+Description:
+		Read and set the current limit for the LED. Value in
+		milliampere.
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index ff203a4..0114c68 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -50,6 +50,15 @@ config LEDS_LM3530
 	  controlled manually or using PWM input or using ambient
 	  light automatically.
 
+config LEDS_AB5500
+	tristate "HVLED driver for AB5500"
+	depends on AB5500_CORE
+	default n
+	help
+	  This option enables support for the HVLED in AB5500
+	  multi function device. Currently Ab5500 v1.0 chip leds
+	  are supported.
+
 config LEDS_LOCOMO
 	tristate "LED Support for Locomo device"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index e4f6bf5..614bad4 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_LEDS_ATMEL_PWM)		+= leds-atmel-pwm.o
 obj-$(CONFIG_LEDS_BD2802)		+= leds-bd2802.o
 obj-$(CONFIG_LEDS_LOCOMO)		+= leds-locomo.o
 obj-$(CONFIG_LEDS_LM3530)		+= leds-lm3530.o
+obj-$(CONFIG_LEDS_AB5500)              += leds-ab5500.o
 obj-$(CONFIG_LEDS_MIKROTIK_RB532)	+= leds-rb532.o
 obj-$(CONFIG_LEDS_S3C24XX)		+= leds-s3c24xx.o
 obj-$(CONFIG_LEDS_AMS_DELTA)		+= leds-ams-delta.o
diff --git a/drivers/leds/leds-ab5500.c b/drivers/leds/leds-ab5500.c
new file mode 100644
index 0000000..31c1e8c
--- /dev/null
+++ b/drivers/leds/leds-ab5500.c
@@ -0,0 +1,830 @@
+/*
+ * leds-ab5500.c - driver for High Voltage (HV) LED in ST-Ericsson AB5500 chip
+ *
+ * Copyright (C) 2011 ST-Ericsson SA.
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Author: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
+ */
+
+/*
+ * Driver for HVLED in ST-Ericsson AB5500 analog baseband controller
+ *
+ * This chip can drive upto 3 leds, of upto 40mA of led sink current.
+ * These leds can be programmed to blink between two intensities with
+ * fading delay of half, one or two seconds.
+ *
+ * Leds can be controlled via sysfs entries in
+ *	"/sys/class/leds/< red | green | blue >"
+ *
+ * For each led,
+ *
+ * Modes of operation:
+ *  - manual:	echo 0 > fade_auto (default, no auto blinking)
+ *  - auto:	echo 1 > fade_auto
+ *
+ * Soft scaling delay between two intensities:
+ *  - 1/2 sec:	echo 1 > fade_delay
+ *  - 1 sec:	echo 2 > fade_delay
+ *  - 2 sec:	echo 3 > fade_delay
+ *
+ * Possible sequence of operation:
+ *  - continuous glow: set brightness (brt)
+ *  - blink between LED_OFF and LED_FULL:
+ *	set fade delay -> set fade auto
+ *  - blink between previous two brightness (only for LED-1):
+ *	set brt1 -> set brt2 -> set fade auto
+ *
+ * Delay can be set in any step, its affect will be seen on switching mode.
+ *
+ * Note: Blink/Fade feature is supported in AB5500 v2 onwards
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/leds.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab5500.h>
+#include <linux/mfd/abx500/ab5500-leds.h>
+#include <linux/types.h>
+
+#define AB5500LED_NAME		"ab5500-leds"
+#define AB5500_LED_MAX		0x03
+
+/* Register offsets */
+#define AB5500_LED_REG_ENABLE	0x03
+#define AB5500_LED_FADE_CTRL	0x0D
+
+/* LED-0 Register Addr. Offsets */
+#define AB5500_LED0_PWM_DUTY	0x01
+#define AB5500_LED0_PWMFREQ	0x02
+#define AB5500_LED0_SINKCTL	0x0A
+#define AB5500_LED0_FADE_HI	0x11
+#define AB5500_LED0_FADE_LO	0x17
+
+/* LED-1 Register Addr. Offsets */
+#define AB5500_LED1_PWM_DUTY	0x05
+#define AB5500_LED1_PWMFREQ	0x06
+#define AB5500_LED1_SINKCTL	0x0B
+#define AB5500_LED1_FADE_HI	0x13
+#define AB5500_LED1_FADE_LO	0x19
+
+/* LED-2 Register Addr. Offsets */
+#define AB5500_LED2_PWM_DUTY	0x08
+#define AB5500_LED2_PWMFREQ	0x09
+#define AB5500_LED2_SINKCTL	0x0C
+#define AB5500_LED2_FADE_HI	0x15
+#define AB5500_LED2_FADE_LO	0x1B
+
+/* led-0/1/2 enable bit */
+#define AB5500_LED_ENABLE_MASK	0x04
+
+/* led intensity */
+#define AB5500_LED_INTENSITY_OFF	0x0
+#define AB5500_LED_INTENSITY_MAX	0x3FF
+#define AB5500_LED_INTENSITY_STEP	(AB5500_LED_INTENSITY_MAX/LED_FULL)
+
+/* pwm frequency */
+#define AB5500_LED_PWMFREQ_MAX		0x0F	/* 373.39 @sysclk=26MHz */
+#define AB5500_LED_PWMFREQ_SHIFT	4
+
+/* LED sink current control */
+#define AB5500_LED_SINKCURR_MAX		0x0F	/* 40mA MAX */
+#define AB5500_LED_SINKCURR_SHIFT	4
+
+/* fade Control shift and masks */
+#define AB5500_FADE_DELAY_SHIFT		0x00
+#define AB5500_FADE_MODE_MASK		0x80
+#define AB5500_FADE_DELAY_MASK		0x03
+#define AB5500_FADE_START_MASK		0x04
+#define AB5500_FADE_ON_MASK		0x70
+#define AB5500_LED_FADE_ENABLE(ledid)	(0x40 >> (ledid))
+
+/**
+ * struct ab5500_led
+ * @id: hvled index
+ * @max_current: max current permitted for hvled instance
+ * @brt_val: brightness value set for hvled
+ * @fade_hi: fadeout time high bits
+ * @fade_lo: fadeout time low bits
+ * @led_on: led is on
+ * @led_cdev: hvled class device
+ * @led_work: work to set the brightness of hvled
+ */
+struct ab5500_led {
+	u8 id;
+	u8 max_current;
+	u16 brt_val;
+	u16 fade_hi;
+	u16 fade_lo;
+	bool led_on;
+	struct led_classdev led_cdev;
+	struct work_struct led_work;
+};
+
+/**
+ * struct ab5500_hvleds
+ * @lock: lock to serialize access to hvleds
+ * @dev: device
+ * @pdata: platform data from board
+ * @leds: hvleds instances
+ * @hw_fade: this chip supports hardware fade
+ * @fade_auto: fade out leds automatically on this chip
+ * @fade_delay: fade out automatically after this delay time
+ */
+struct ab5500_hvleds {
+	struct mutex lock;
+	struct device *dev;
+	struct ab5500_hvleds_platform_data *pdata;
+	struct ab5500_led leds[AB5500_HVLEDS_MAX];
+	bool hw_fade;
+	bool fade_auto;
+	enum ab5500_fade_delay fade_delay;
+};
+
+static u8 ab5500_led_pwmduty_reg[AB5500_LED_MAX] = {
+			AB5500_LED0_PWM_DUTY,
+			AB5500_LED1_PWM_DUTY,
+			AB5500_LED2_PWM_DUTY,
+};
+
+static u8 ab5500_led_pwmfreq_reg[AB5500_LED_MAX] = {
+			AB5500_LED0_PWMFREQ,
+			AB5500_LED1_PWMFREQ,
+			AB5500_LED2_PWMFREQ,
+};
+
+static u8 ab5500_led_sinkctl_reg[AB5500_LED_MAX] = {
+			AB5500_LED0_SINKCTL,
+			AB5500_LED1_SINKCTL,
+			AB5500_LED2_SINKCTL
+};
+
+static u8 ab5500_led_fade_hi_reg[AB5500_LED_MAX] = {
+			AB5500_LED0_FADE_HI,
+			AB5500_LED1_FADE_HI,
+			AB5500_LED2_FADE_HI,
+};
+
+static u8 ab5500_led_fade_lo_reg[AB5500_LED_MAX] = {
+			AB5500_LED0_FADE_LO,
+			AB5500_LED1_FADE_LO,
+			AB5500_LED2_FADE_LO,
+};
+
+#define to_led(_x)	container_of(_x, struct ab5500_led, _x)
+
+static inline struct ab5500_hvleds *led_to_hvleds(struct ab5500_led *led)
+{
+	return container_of(led, struct ab5500_hvleds, leds[led->id]);
+}
+
+static int ab5500_led_enable(struct ab5500_hvleds *hvleds,
+		unsigned int led_id)
+{
+	int ret;
+
+	ret = abx500_mask_and_set_register_interruptible(
+			hvleds->dev, AB5500_BANK_LED,
+			ab5500_led_pwmduty_reg[led_id],
+			AB5500_LED_ENABLE_MASK,
+			AB5500_LED_ENABLE_MASK);
+	if (ret < 0)
+		dev_err(hvleds->dev, "reg[%d] w failed: %d\n",
+				ab5500_led_pwmduty_reg[led_id], ret);
+
+	return ret;
+
+}
+
+static int ab5500_led_start_manual(struct ab5500_hvleds *hvleds)
+{
+	int ret;
+
+	mutex_lock(&hvleds->lock);
+
+	ret = abx500_mask_and_set_register_interruptible(
+			hvleds->dev, AB5500_BANK_LED,
+			AB5500_LED_FADE_CTRL, AB5500_FADE_START_MASK,
+			AB5500_FADE_START_MASK);
+	if (ret < 0)
+		dev_err(hvleds->dev, "update reg 0x%x failed - %d\n",
+				AB5500_LED_FADE_CTRL, ret);
+
+	mutex_unlock(&hvleds->lock);
+
+	return ret;
+}
+
+static int ab5500_led_disable(struct ab5500_hvleds *hvleds,
+		unsigned int led_id)
+{
+	int ret;
+
+	ret = abx500_set_register_interruptible(
+			hvleds->dev, AB5500_BANK_LED,
+			ab5500_led_pwmduty_reg[led_id] - 1, 0);
+	ret |= abx500_set_register_interruptible(
+			hvleds->dev, AB5500_BANK_LED,
+			ab5500_led_pwmduty_reg[led_id], 0);
+	if (ret < 0)
+		dev_err(hvleds->dev, "reg[%d] w failed: %d\n",
+			ab5500_led_pwmduty_reg[led_id], ret);
+
+	return ret;
+}
+
+static int ab5500_led_pwmduty_write(struct ab5500_hvleds *hvleds,
+			unsigned int led_id, u16 val)
+{
+	int ret;
+	u8 val_lsb = val & 0xFF;
+	u8 val_msb = (val & 0x300) >> 8;
+
+	mutex_lock(&hvleds->lock);
+
+	dev_dbg(hvleds->dev, "ab5500-leds: reg[%d] w val = %d\n"
+		"reg[%d] w val = %d\n",
+		ab5500_led_pwmduty_reg[led_id] - 1, val_lsb,
+		ab5500_led_pwmduty_reg[led_id], val_msb);
+
+	ret = abx500_set_register_interruptible(
+			hvleds->dev, AB5500_BANK_LED,
+			ab5500_led_pwmduty_reg[led_id] - 1, val_lsb);
+	ret |= abx500_set_register_interruptible(
+			hvleds->dev, AB5500_BANK_LED,
+			ab5500_led_pwmduty_reg[led_id], val_msb);
+	if (ret < 0)
+		dev_err(hvleds->dev, "reg[%d] w failed: %d\n",
+			ab5500_led_pwmduty_reg[led_id], ret);
+
+	mutex_unlock(&hvleds->lock);
+
+	return ret;
+}
+
+static int ab5500_led_pwmfreq_write(struct ab5500_hvleds *hvleds,
+			unsigned int led_id, u8 val)
+{
+	int ret;
+
+	val = (val & 0x0F) << AB5500_LED_PWMFREQ_SHIFT;
+
+	mutex_lock(&hvleds->lock);
+
+	dev_dbg(hvleds->dev, "ab5500-leds: reg[%d] w val=%d\n",
+			ab5500_led_pwmfreq_reg[led_id], val);
+
+	ret = abx500_set_register_interruptible(
+			hvleds->dev, AB5500_BANK_LED,
+			ab5500_led_pwmfreq_reg[led_id], val);
+	if (ret < 0)
+		dev_err(hvleds->dev, "reg[%d] w failed: %d\n",
+			ab5500_led_pwmfreq_reg[led_id], ret);
+
+	mutex_unlock(&hvleds->lock);
+
+	return ret;
+}
+
+static int ab5500_led_sinkctl_write(struct ab5500_hvleds *hvleds,
+			unsigned int led_id, u8 val)
+{
+	int ret;
+
+	if (val > AB5500_LED_SINKCURR_MAX)
+		val = AB5500_LED_SINKCURR_MAX;
+
+	val = (val << AB5500_LED_SINKCURR_SHIFT);
+
+	dev_dbg(hvleds->dev, "ab5500-leds: reg[%d] w val=%d\n",
+			ab5500_led_sinkctl_reg[led_id], val);
+
+	mutex_lock(&hvleds->lock);
+
+	ret = abx500_set_register_interruptible(
+			hvleds->dev, AB5500_BANK_LED,
+			ab5500_led_sinkctl_reg[led_id], val);
+	if (ret < 0)
+		dev_err(hvleds->dev, "reg[%d] w failed: %d\n",
+			ab5500_led_sinkctl_reg[led_id], ret);
+
+	mutex_unlock(&hvleds->lock);
+
+	return ret;
+}
+
+static int ab5500_led_fade_write(struct ab5500_hvleds *hvleds,
+			unsigned int led_id, bool on, u16 val)
+{
+	int ret;
+	int val_lsb = val & 0xFF;
+	int val_msb = (val & 0x300) >> 8;
+	u8 *fade_reg;
+
+	if (on)
+		fade_reg = ab5500_led_fade_hi_reg;
+	else
+		fade_reg = ab5500_led_fade_lo_reg;
+
+	dev_dbg(hvleds->dev, "ab5500-leds: reg[%d] w val = %d\n"
+		"reg[%d] w val = %d\n",
+		fade_reg[led_id] - 1, val_lsb,
+		fade_reg[led_id], val_msb);
+
+	mutex_lock(&hvleds->lock);
+
+	ret = abx500_set_register_interruptible(
+			hvleds->dev, AB5500_BANK_LED,
+			fade_reg[led_id] - 1, val_lsb);
+	ret |= abx500_set_register_interruptible(
+			hvleds->dev, AB5500_BANK_LED,
+			fade_reg[led_id], val_msb);
+	if (ret < 0)
+		dev_err(hvleds->dev, "reg[%d] w failed: %d\n",
+			fade_reg[led_id], ret);
+
+	mutex_unlock(&hvleds->lock);
+
+	return ret;
+}
+
+static int ab5500_led_sinkctl_read(struct ab5500_hvleds *hvleds,
+			unsigned int led_id)
+{
+	int ret;
+	u8 val;
+
+	mutex_lock(&hvleds->lock);
+
+	ret = abx500_get_register_interruptible(
+			hvleds->dev, AB5500_BANK_LED,
+			ab5500_led_sinkctl_reg[led_id], &val);
+	if (ret < 0) {
+		dev_err(hvleds->dev, "reg[%d] r failed: %d\n",
+			ab5500_led_sinkctl_reg[led_id], ret);
+		mutex_unlock(&hvleds->lock);
+		return ret;
+	}
+
+	val = (val & 0xF0) >> AB5500_LED_SINKCURR_SHIFT;
+
+	mutex_unlock(&hvleds->lock);
+
+	return val;
+}
+
+static void ab5500_led_brightness_set(struct led_classdev *led_cdev,
+			enum led_brightness brt_val)
+{
+	struct ab5500_led *led = to_led(led_cdev);
+
+	/* adjust LED_FULL to 10bit range */
+	brt_val &= LED_FULL;
+	led->brt_val = brt_val * AB5500_LED_INTENSITY_STEP;
+
+	schedule_work(&led->led_work);
+}
+
+static void ab5500_led_work(struct work_struct *led_work)
+{
+	struct ab5500_led *led = to_led(led_work);
+	struct ab5500_hvleds *hvleds = led_to_hvleds(led);
+
+	if (led->led_on == true) {
+		ab5500_led_pwmduty_write(hvleds, led->id, led->brt_val);
+		if (hvleds->hw_fade && led->brt_val) {
+			ab5500_led_enable(hvleds, led->id);
+			ab5500_led_start_manual(hvleds);
+		}
+	}
+}
+
+static ssize_t ab5500_led_show_current(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	int led_curr = 0;
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct ab5500_led *led = to_led(led_cdev);
+	struct ab5500_hvleds *hvleds = led_to_hvleds(led);
+
+	led_curr = ab5500_led_sinkctl_read(hvleds, led->id);
+
+	if (led_curr < 0)
+		return led_curr;
+
+	return sprintf(buf, "%d\n", led_curr);
+}
+
+static ssize_t ab5500_led_store_current(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t len)
+{
+	int ret;
+	unsigned long led_curr;
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct ab5500_led *led = to_led(led_cdev);
+	struct ab5500_hvleds *hvleds = led_to_hvleds(led);
+
+	if (strict_strtoul(buf, 0, &led_curr))
+		return -EINVAL;
+
+	if (led_curr > led->max_current)
+		led_curr = led->max_current;
+
+	ret = ab5500_led_sinkctl_write(hvleds, led->id, led_curr);
+	if (ret < 0)
+		return ret;
+
+	return len;
+}
+
+static ssize_t ab5500_led_store_fade_auto(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t len)
+{
+	int ret;
+	u8 fade_ctrl = 0;
+	unsigned long fade_auto;
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct ab5500_led *led = to_led(led_cdev);
+	struct ab5500_hvleds *hvleds = led_to_hvleds(led);
+
+	if (strict_strtoul(buf, 0, &fade_auto))
+		return -EINVAL;
+
+	if (fade_auto > 1) {
+		dev_err(hvleds->dev, "invalid mode\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&hvleds->lock);
+
+	ret = abx500_get_register_interruptible(
+			hvleds->dev, AB5500_BANK_LED,
+			AB5500_LED_FADE_CTRL, &fade_ctrl);
+	if (ret < 0) {
+		dev_err(hvleds->dev, "reg[%d] w failed: %d\n",
+				AB5500_LED_FADE_CTRL, ret);
+		goto unlock_and_return;
+	}
+
+	/* manual mode */
+	if (fade_auto == false) {
+		fade_ctrl &= ~(AB5500_LED_FADE_ENABLE(led->id));
+		if (!(fade_ctrl & AB5500_FADE_ON_MASK))
+			fade_ctrl = 0;
+
+		ret = ab5500_led_disable(hvleds, led->id);
+		if (ret < 0)
+			goto unlock_and_return;
+	} else {
+		/* set led auto enable bit */
+		fade_ctrl |= AB5500_FADE_MODE_MASK;
+		fade_ctrl |= AB5500_LED_FADE_ENABLE(led->id);
+
+		/* set fade delay */
+		fade_ctrl &= ~AB5500_FADE_DELAY_MASK;
+		fade_ctrl |= hvleds->fade_delay << AB5500_FADE_DELAY_SHIFT;
+
+		/* set fade start manual */
+		fade_ctrl |= AB5500_FADE_START_MASK;
+
+		/* enble corresponding led */
+		ret = ab5500_led_enable(hvleds, led->id);
+		if (ret < 0)
+			goto unlock_and_return;
+
+	}
+
+	ret = abx500_set_register_interruptible(
+				hvleds->dev, AB5500_BANK_LED,
+				AB5500_LED_FADE_CTRL, fade_ctrl);
+	if (ret < 0) {
+		dev_err(hvleds->dev, "reg[%d] w failed: %d\n",
+			       AB5500_LED_FADE_CTRL, ret);
+		goto unlock_and_return;
+	}
+
+	hvleds->fade_auto = fade_auto;
+
+	ret = len;
+
+unlock_and_return:
+	mutex_unlock(&hvleds->lock);
+
+	return ret;
+}
+
+static ssize_t ab5500_led_show_fade_auto(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct ab5500_led *led = to_led(led_cdev);
+	struct ab5500_hvleds *hvleds = led_to_hvleds(led);
+
+	return sprintf(buf, "%d\n", hvleds->fade_auto);
+}
+
+static ssize_t ab5500_led_store_fade_delay(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t len)
+{
+	unsigned long fade_delay;
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct ab5500_led *led = to_led(led_cdev);
+	struct ab5500_hvleds *hvleds = led_to_hvleds(led);
+
+	if (strict_strtoul(buf, 0, &fade_delay))
+		return -EINVAL;
+
+	if (fade_delay > AB5500_FADE_DELAY_TWOSEC) {
+		dev_err(hvleds->dev, "invalid mode\n");
+		return -EINVAL;
+	}
+
+	hvleds->fade_delay = fade_delay;
+
+	return len;
+}
+
+/* led class device attributes */
+static DEVICE_ATTR(led_current, S_IRUGO | S_IWUGO,
+	       ab5500_led_show_current, ab5500_led_store_current);
+static DEVICE_ATTR(fade_auto, S_IRUGO | S_IWUGO,
+	       ab5500_led_show_fade_auto, ab5500_led_store_fade_auto);
+static DEVICE_ATTR(fade_delay, S_IRUGO | S_IWUGO,
+	       NULL, ab5500_led_store_fade_delay);
+
+static int ab5500_led_init_registers(struct ab5500_hvleds *hvleds)
+{
+	int ret = 0;
+	unsigned int led_id;
+
+	/*  fade - manual : dur mid : pwm duty mid */
+	if (!hvleds->hw_fade) {
+		ret = abx500_set_register_interruptible(
+				hvleds->dev, AB5500_BANK_LED,
+				AB5500_LED_REG_ENABLE, true);
+		if (ret < 0) {
+			dev_err(hvleds->dev, "reg[%d] w failed: %d\n",
+					AB5500_LED_REG_ENABLE, ret);
+			return ret;
+		}
+	}
+
+	for (led_id = 0; led_id < AB5500_HVLEDS_MAX; led_id++) {
+		if (hvleds->leds[led_id].led_on == false)
+			continue;
+
+		ret = ab5500_led_sinkctl_write(
+				hvleds, led_id,
+				hvleds->leds[led_id].max_current);
+		if (ret < 0)
+			return ret;
+
+		if (hvleds->hw_fade) {
+			ret = ab5500_led_pwmfreq_write(
+					hvleds, led_id,
+					AB5500_LED_PWMFREQ_MAX / 2);
+			if (ret < 0)
+				return ret;
+
+			/* fade high intensity */
+			ret = ab5500_led_fade_write(
+					hvleds, led_id, true,
+					hvleds->leds[led_id].fade_hi);
+			if (ret < 0)
+				return ret;
+
+			/* fade low intensity */
+			ret = ab5500_led_fade_write(
+					hvleds, led_id, false,
+					hvleds->leds[led_id].fade_lo);
+			if (ret < 0)
+				return ret;
+		}
+
+		/* init led off */
+		ret |= ab5500_led_pwmduty_write(
+				hvleds, led_id, AB5500_LED_INTENSITY_OFF);
+		if (ret < 0)
+			return ret;
+	}
+
+	return ret;
+}
+
+static int ab5500_led_register_leds(struct device *dev,
+			struct ab5500_hvleds_platform_data *pdata,
+			struct ab5500_hvleds *hvleds)
+{
+	int i_led;
+	int ret = 0;
+	struct ab5500_led_conf *pled;
+	struct ab5500_led *led;
+
+	hvleds->dev = dev;
+	hvleds->pdata = pdata;
+
+	if (abx500_get_chip_id(dev) == AB5500_2_0)
+		hvleds->hw_fade = true;
+	else
+		hvleds->hw_fade = false;
+
+	for (i_led = 0; i_led < AB5500_HVLEDS_MAX; i_led++) {
+		pled = &pdata->leds[i_led];
+		led = &hvleds->leds[i_led];
+
+		INIT_WORK(&led->led_work, ab5500_led_work);
+
+		led->id = pled->led_id;
+		led->max_current = pled->max_current;
+		led->led_on = pled->led_on;
+		led->led_cdev.name = pled->name;
+		led->led_cdev.brightness_set = ab5500_led_brightness_set;
+
+		/* Provide interface only for enabled LEDs */
+		if (led->led_on == false)
+			continue;
+
+		if (hvleds->hw_fade) {
+			led->fade_hi = (pled->fade_hi & LED_FULL);
+			led->fade_hi *= AB5500_LED_INTENSITY_STEP;
+			led->fade_lo = (pled->fade_lo & LED_FULL);
+			led->fade_lo *= AB5500_LED_INTENSITY_STEP;
+		}
+
+		ret = led_classdev_register(dev, &led->led_cdev);
+		if (ret < 0) {
+			dev_err(dev, "Register led class failed: %d\n", ret);
+			goto bailout1;
+		}
+
+		ret = device_create_file(led->led_cdev.dev,
+						&dev_attr_led_current);
+		if (ret < 0) {
+			dev_err(dev, "sysfs device creation failed: %d\n", ret);
+			goto bailout2;
+		}
+
+		if (hvleds->hw_fade) {
+			ret = device_create_file(led->led_cdev.dev,
+					&dev_attr_fade_auto);
+			if (ret < 0) {
+				dev_err(dev, "sysfs device "
+					"creation failed: %d\n", ret);
+				goto bailout3;
+			}
+
+			ret = device_create_file(led->led_cdev.dev,
+					&dev_attr_fade_delay);
+			if (ret < 0) {
+				dev_err(dev, "sysfs device "
+					"creation failed: %d\n", ret);
+				goto bailout4;
+			}
+		}
+	}
+
+	return ret;
+	for (; i_led >= 0; i_led--) {
+		if (hvleds->leds[i_led].led_on == false)
+			continue;
+
+		if (hvleds->hw_fade) {
+			device_remove_file(hvleds->leds[i_led].led_cdev.dev,
+					&dev_attr_fade_delay);
+bailout4:
+			device_remove_file(hvleds->leds[i_led].led_cdev.dev,
+					&dev_attr_fade_auto);
+		}
+bailout3:
+		device_remove_file(hvleds->leds[i_led].led_cdev.dev,
+				&dev_attr_led_current);
+bailout2:
+		led_classdev_unregister(&hvleds->leds[i_led].led_cdev);
+bailout1:
+		cancel_work_sync(&hvleds->leds[i_led].led_work);
+	}
+	return ret;
+}
+
+static int __devinit ab5500_hvleds_probe(struct platform_device *pdev)
+{
+	struct ab5500_hvleds_platform_data *pdata = pdev->dev.platform_data;
+	struct ab5500_hvleds *hvleds = NULL;
+	int ret = 0, i;
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "platform data required\n");
+		ret = -ENODEV;
+		goto err_out;
+	}
+
+	hvleds = kzalloc(sizeof(struct ab5500_hvleds), GFP_KERNEL);
+	if (hvleds == NULL) {
+		ret = -ENOMEM;
+		goto err_out;
+	}
+
+	mutex_init(&hvleds->lock);
+
+	/* init leds data and register led_classdev */
+	ret = ab5500_led_register_leds(&pdev->dev, pdata, hvleds);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "leds registration failed\n");
+		goto err_out;
+	}
+
+	/* init device registers and set initial led current */
+	ret = ab5500_led_init_registers(hvleds);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "reg init failed: %d\n", ret);
+		goto err_reg_init;
+	}
+
+	if (hvleds->hw_fade)
+		dev_info(&pdev->dev, "v2 enabled\n");
+	else
+		dev_info(&pdev->dev, "v1 enabled\n");
+
+	return ret;
+
+err_reg_init:
+	for (i = 0; i < AB5500_HVLEDS_MAX; i++) {
+		struct ab5500_led *led = &hvleds->leds[i];
+
+		if (led->led_on == false)
+			continue;
+
+		device_remove_file(led->led_cdev.dev, &dev_attr_led_current);
+		if (hvleds->hw_fade) {
+			device_remove_file(led->led_cdev.dev,
+					&dev_attr_fade_auto);
+			device_remove_file(led->led_cdev.dev,
+					&dev_attr_fade_delay);
+		}
+		led_classdev_unregister(&led->led_cdev);
+		cancel_work_sync(&led->led_work);
+	}
+err_out:
+	kfree(hvleds);
+	return ret;
+}
+
+static int __devexit ab5500_hvleds_remove(struct platform_device *pdev)
+{
+	struct ab5500_hvleds *hvleds = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < AB5500_HVLEDS_MAX; i++) {
+		struct ab5500_led *led = &hvleds->leds[i];
+
+		if (led->led_on == false)
+			continue;
+
+		device_remove_file(led->led_cdev.dev, &dev_attr_led_current);
+		if (hvleds->hw_fade) {
+			device_remove_file(led->led_cdev.dev,
+					&dev_attr_fade_auto);
+			device_remove_file(led->led_cdev.dev,
+					&dev_attr_fade_delay);
+		}
+		led_classdev_unregister(&led->led_cdev);
+		cancel_work_sync(&led->led_work);
+	}
+	kfree(hvleds);
+	return 0;
+}
+
+static struct platform_driver ab5500_hvleds_driver = {
+	.driver   = {
+		   .name = AB5500LED_NAME,
+		   .owner = THIS_MODULE,
+	},
+	.probe    = ab5500_hvleds_probe,
+	.remove   = __devexit_p(ab5500_hvleds_remove),
+};
+
+static int __init ab5500_hvleds_module_init(void)
+{
+	return platform_driver_register(&ab5500_hvleds_driver);
+}
+
+static void __exit ab5500_hvleds_module_exit(void)
+{
+	platform_driver_unregister(&ab5500_hvleds_driver);
+}
+
+module_init(ab5500_hvleds_module_init);
+module_exit(ab5500_hvleds_module_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>");
+MODULE_DESCRIPTION("Driver for AB5500 HVLED");
diff --git a/include/linux/mfd/abx500/ab5500-leds.h b/include/linux/mfd/abx500/ab5500-leds.h
new file mode 100644
index 0000000..54ba53a
--- /dev/null
+++ b/include/linux/mfd/abx500/ab5500-leds.h
@@ -0,0 +1,54 @@
+/*
+ * Copyright (C) 2011 ST-Ericsson SA.
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Simple driver for HVLED in ST-Ericsson AB5500 Analog baseband Controller
+ *
+ * Author: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
+ */
+
+#ifndef _LINUX_LEDS_AB5500_H__
+#define _LINUX_LEDS_AB5500_H__
+
+#define AB5500_HVLED0		0
+#define AB5500_HVLED1		1
+#define AB5500_HVLED2		2
+#define AB5500_HVLEDS_MAX	3
+
+enum ab5500_fade_delay {
+	AB5500_FADE_DELAY_BYPASS = 0,
+	AB5500_FADE_DELAY_HALFSEC,
+	AB5500_FADE_DELAY_ONESEC,
+	AB5500_FADE_DELAY_TWOSEC
+};
+
+/**
+ * struct ab5500_led_conf
+ * @name: hvled instance name
+ * @led_id: hvled index
+ * @max_current: max current permitted for hvled instance
+ * @fade_hi: fadeout time high bits
+ * @fade_lo: fadeout time low bits
+ * @led_on: led is on by default
+ */
+struct ab5500_led_conf {
+	char *name;
+	u8 led_id;
+	u8 max_current;
+	u8 fade_hi;
+	u8 fade_lo;
+	bool led_on;
+};
+
+/**
+ * struct ab5500_hvleds_platform_data
+ * @hw_fade: fadeout feature present in hardware
+ * @leds: hvleds instances
+ */
+struct ab5500_hvleds_platform_data {
+	bool hw_fade;
+	struct ab5500_led_conf leds[AB5500_HVLEDS_MAX];
+};
+
+#endif /* _LINUX_LEDS_AB5500_H__ */
-- 
1.7.3.2

