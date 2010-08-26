Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab0HZHXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 03:23:00 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:53322 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752239Ab0HZHW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 03:22:58 -0400
From: Arun Murthy <arun.murthy@stericsson.com>
To: <sameo@linux.intel.com>, <riku.voipio@iki.fi>
Cc: <linux-kernel@vger.kernel.org>, <STEricsson_nomadik_linux@list.st.com>,
        <arun.murthy@stericsson.com>, <linus.walleij@stericsson.com>,
        <srinidhi.kasagar@stericsson.com>
Subject: [PATCH 1/3] mfd: ab8500-pwm: ab8500 pwm management
Date: Thu, 26 Aug 2010 12:20:30 +0530
Message-ID: <1282805432-28523-2-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1282805432-28523-1-git-send-email-arun.murthy@stericsson.com>
References: <1282805432-28523-1-git-send-email-arun.murthy@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exports functions to set and get ab8500 pwm intensity,
which in turn is used by backlight/led driver.

Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
Acked-by: Mattias Wallin <mattias.wallin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/Kconfig                   |    8 ++
 drivers/mfd/Makefile                  |    1 +
 drivers/mfd/ab8500-pwm.c              |  191 +++++++++++++++++++++++++++++++++
 include/linux/mfd/abx500/ab8500-pwm.h |   32 ++++++
 4 files changed, 232 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/ab8500-pwm.c
 create mode 100644 include/linux/mfd/abx500/ab8500-pwm.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 82d013f..6e73227 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -515,6 +515,14 @@ config AB3550_CORE
 	  LEDs, vibrator, system power and temperature, power management
 	  and ALSA sound.
 
+config AB8500_PWM
+	bool
+	depends on AB8500_CORE
+	help
+	  This driver exports function to set and get AB8500 Pulse
+	  Width Modulation pwm intensity in Analog Baseband chip AB8500.
+	  It is used to control the led and lcd backlight intensity.
+
 config MFD_TIMBERDALE
 	tristate "Support for the Timberdale FPGA"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 9aa8a2d..949c5bb 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -71,6 +71,7 @@ obj-$(CONFIG_AB3550_CORE)	+= ab3550-core.o
 obj-$(CONFIG_AB8500_CORE)	+= ab8500-core.o ab8500-spi.o
 obj-$(CONFIG_AB8500_I2C_CORE)	+= ab8500-i2c.o
 obj-$(CONFIG_AB8500_DEBUG)	+= ab8500-debugfs.o
+obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
 obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
diff --git a/drivers/mfd/ab8500-pwm.c b/drivers/mfd/ab8500-pwm.c
new file mode 100644
index 0000000..91eea95
--- /dev/null
+++ b/drivers/mfd/ab8500-pwm.c
@@ -0,0 +1,191 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Author: Arun R Murthy <arun.murthy@stericsson.com>
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#define KMSG_COMPONENT "ab8500-pwm"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
+#include <linux/err.h>
+#include <linux/mfd/ab8500.h>
+#include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500-pwm.h>
+
+/*
+ * PWM Out generators
+ * Bank: 0x10
+ */
+#define AB8500_PWM_OUT_CTRL1_REG	0x60
+#define AB8500_PWM_OUT_CTRL2_REG	0x61
+#define AB8500_PWM_OUT_CTRL3_REG	0x62
+#define AB8500_PWM_OUT_CTRL4_REG	0x63
+#define AB8500_PWM_OUT_CTRL5_REG	0x64
+#define AB8500_PWM_OUT_CTRL6_REG	0x65
+#define AB8500_PWM_OUT_CTRL7_REG	0x66
+
+/* backlight driver constants */
+#define DISABLE_PWM1			0
+#define DISABLE_PWM2			0
+#define DISABLE_PWM3			0
+#define ENABLE_PWM1			0x01
+#define ENABLE_PWM2			0x02
+#define ENABLE_PWM3			0x04
+
+/**
+ * ab8500_pwm_set_int() - set pwm intensity
+ * @dev:		pointer the struct device
+ * @max_brightness:	maximum brightness
+ * @intensity:		pwm intensity to be set
+ * @pwm:		pwm number for which intensity has to be set
+ */
+int ab8500_pwm_set_int(struct device *dev, unsigned int max_brightness,
+					unsigned int intensity, int pwm)
+{
+	int ret = 0;
+	unsigned int higher_val, lower_val, pwm_val;
+
+	/*
+	 * DutyPWMOut[9:0]: 0000000000 = 1/1024; 0000000001 = 2/1024;..
+	 * 1111111110 = 1023/1024; 1111111111 = 1024/1024.
+	 */
+	pwm_val = ((1023 * intensity) / max_brightness);
+	/*
+	 * get the first 8 bits that are be written to
+	 * AB8500_PWM_OUT_CTRL1_REG[0:7]
+	 */
+	lower_val = pwm_val & 0x00FF;
+	/*
+	 * get bits [9:10] that are to be written to
+	 * AB8500_PWM_OUT_CTRL2_REG[0:1]
+	 */
+	higher_val = ((pwm_val & 0x0300) >> 8);
+	switch (pwm) {
+	case 1:
+		/* pwm-1 */
+		ret = abx500_mask_and_set_register_interruptible(dev,
+					AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
+					ENABLE_PWM1, ENABLE_PWM1);
+		if (ret < 0)
+			return ret;
+		ret = abx500_set_register_interruptible(dev,
+					AB8500_MISC, AB8500_PWM_OUT_CTRL1_REG,
+					(u8)lower_val);
+		if (ret < 0)
+			return ret;
+		ret = abx500_set_register_interruptible(dev,
+					AB8500_MISC, AB8500_PWM_OUT_CTRL2_REG,
+					(u8)higher_val);
+		break;
+	case 2:
+		/* pwm-2 */
+		ret = abx500_mask_and_set_register_interruptible(dev,
+					AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
+					ENABLE_PWM2, ENABLE_PWM2);
+		if (ret < 0)
+			return ret;
+		ret = abx500_set_register_interruptible(dev,
+					AB8500_MISC, AB8500_PWM_OUT_CTRL3_REG,
+					(u8)lower_val);
+		if (ret < 0)
+			return ret;
+		ret = abx500_set_register_interruptible(dev,
+					AB8500_MISC, AB8500_PWM_OUT_CTRL4_REG,
+					(u8)higher_val);
+		break;
+	case 3:
+		/* pwm-3 */
+		ret = abx500_mask_and_set_register_interruptible(dev,
+					AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
+					ENABLE_PWM3, ENABLE_PWM3);
+		if (ret < 0)
+			return ret;
+		ret = abx500_set_register_interruptible(dev,
+					AB8500_MISC, AB8500_PWM_OUT_CTRL5_REG,
+					(u8)lower_val);
+		if (ret < 0)
+			return ret;
+		ret = abx500_set_register_interruptible(dev,
+					AB8500_MISC, AB8500_PWM_OUT_CTRL6_REG,
+					(u8)higher_val);
+		break;
+	default:
+		pr_err("%s: invalid pwm entry = %d\n", __func__, pwm);
+		return -EINVAL;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(ab8500_pwm_set_int);
+
+/**
+ * ab8500_pwm_get_int() - get pwm intensity
+ * @dev:		pointer to the struct device
+ * @max_brightness:	maximum brightness
+ * @pwm:		pwm number for which intensity has to be obtained
+ */
+int ab8500_pwm_get_int(struct device *dev, int max_brightness, int pwm)
+{
+	u8 lower_val, higher_val;
+	unsigned int pwm_val;
+	int ret;
+
+	switch (pwm) {
+	case 1:
+		/* pwm-1 */
+		ret = abx500_get_register_interruptible(dev,
+					AB8500_MISC, AB8500_PWM_OUT_CTRL1_REG,
+					&lower_val);
+		if (ret < 0)
+			return ret;
+		ret = abx500_get_register_interruptible(dev,
+					AB8500_MISC, AB8500_PWM_OUT_CTRL2_REG,
+					&higher_val);
+		if (ret < 0)
+			return ret;
+		break;
+	case 2:
+		/* pwm-2 */
+		ret = abx500_get_register_interruptible(dev,
+					AB8500_MISC, AB8500_PWM_OUT_CTRL3_REG,
+					&lower_val);
+		if (ret < 0)
+			return ret;
+		ret = abx500_get_register_interruptible(dev,
+					AB8500_MISC, AB8500_PWM_OUT_CTRL4_REG,
+					&higher_val);
+		if (ret < 0)
+			return ret;
+		break;
+	case 3:
+		/* pwm-3 */
+		ret = abx500_get_register_interruptible(dev,
+					AB8500_MISC, AB8500_PWM_OUT_CTRL5_REG,
+					&lower_val);
+		if (ret < 0)
+			return ret;
+		ret = abx500_get_register_interruptible(dev,
+					AB8500_MISC, AB8500_PWM_OUT_CTRL6_REG,
+					&higher_val);
+		if (ret < 0)
+			return ret;
+		break;
+	default:
+		pr_err("%s:invalid pwm entry = %d\n", __func__, pwm);
+		return -EINVAL;
+	};
+	/*
+	 * PWM value is of 10bit length bits, hence combining the
+	 * lower AB8500_PWM_OUT_CTRL1_REG and higher
+	 * AB8500_PWM_OUT_CTRL2_REG register.
+	 */
+	pwm_val = higher_val << 8 | lower_val;
+	/*
+	 * DutyPWMOut[9:0]: 0000000000 = 1/1024; 0000000001 = 2/1024;..
+	 * 1111111110 = 1023/1024; 1111111111 = 1024/1024.
+	 */
+	pwm_val = (max_brightness * pwm_val) / 1023;
+
+	return pwm_val;
+}
+EXPORT_SYMBOL(ab8500_pwm_get_int);
diff --git a/include/linux/mfd/abx500/ab8500-pwm.h b/include/linux/mfd/abx500/ab8500-pwm.h
new file mode 100644
index 0000000..f891c70
--- /dev/null
+++ b/include/linux/mfd/abx500/ab8500-pwm.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Author: Dushyanth S R <dushyanth.sr@stericsson.com>
+ * Author: Arun Murthy <arun.murthy@stericsson.com>
+ * License Terms: GNU General Public License v2
+ */
+#ifndef MFD_AB8500_PWM_H
+#define MFD_AB8500_PWM_H
+
+#define PWM1		1
+#define PWM2		2
+#define PWM3		3
+#define TOTAL_NO_PWM	3
+#define MAX_PWM_CTRL	2
+
+struct ab8500_pwm_pdata {
+	int pwm_no[MAX_PWM_CTRL];
+	int max_intensity;
+	char *name;
+};
+
+int ab8500_pwm_set_int(struct device *dev,
+		unsigned int max_brightness,
+		unsigned int intensity,
+		int pwm);
+
+int ab8500_pwm_get_int(struct device *dev,
+		int max_brightness,
+		int pwm);
+
+#endif /* MFD_AB8500_PWM_H */
-- 
1.6.3.3

