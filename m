Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab0GHMK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 08:10:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50877 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739Ab0GHMKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 08:10:53 -0400
Message-ID: <56025.10.24.255.17.1278591051.squirrel@dbdmail.itg.ti.com>
Date: Thu, 8 Jul 2010 17:40:51 +0530 (IST)
Subject: [RFC] [PATCH] mfd: Support  for TWL6030 PWM
From: "Hemanth V" <hemanthv@ti.com>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2c6efcebf2790a4c968309360cfc3559b6d9c110 Mon Sep 17 00:00:00 2001
From: Hemanth V <hemanthv@ti.com>
Date: Thu, 8 Jul 2010 17:04:06 +0530
Subject: [PATCH] Add support for TWL6030 PWM

TWL6030 supports PWM (Pulse Width Modulator) which is used
to control charging LED. PWM allows for controlling brightness.
This patch implements the APIs required by leds-pwm driver.

Signed-off-by: Hemanth V <hemanthv@ti.com>
---
 drivers/mfd/Kconfig       |    9 +++
 drivers/mfd/Makefile      |    3 +-
 drivers/mfd/twl6030-pwm.c |  163 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 174 insertions(+), 1 deletions(-)
 create mode 100644 drivers/mfd/twl6030-pwm.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index c7c11ef..4459fe5 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -162,6 +162,15 @@ config TWL6030_GPADC
 	  Say yes here if you want support for the TWL6030 General Purpose
 	  A/D Convertor.

+config TWL6030_PWM
+	tristate "TWL6030 PWM (Pulse Width Modulator) Support"
+	depends on TWL4030_CORE
+	select HAVE_PWM
+	default n
+	help
+	  Say yes here if you want support for TWL6030 PWM.
+	  This is used to control charging LED brightness.
+
 config MFD_TMIO
 	bool
 	default n
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 204a974..e697101 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_TWL4030_CORE)	+= twl-core.o twl4030-irq.o twl6030-irq.o
 obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
 obj-$(CONFIG_TWL4030_CODEC)	+= twl4030-codec.o
 obj-$(CONFIG_TWL6030_GPADC)	+= twl6030-gpadc.o
+obj-$(CONFIG_TWL6030_PWM)	+= twl6030-pwm.o

 obj-$(CONFIG_MFD_MC13783)	+= mc13783-core.o

@@ -63,4 +64,4 @@ obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
 obj-$(CONFIG_AB4500_CORE)	+= ab4500-core.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
-obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
\ No newline at end of file
+obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
diff --git a/drivers/mfd/twl6030-pwm.c b/drivers/mfd/twl6030-pwm.c
new file mode 100644
index 0000000..5d25bdc
--- /dev/null
+++ b/drivers/mfd/twl6030-pwm.c
@@ -0,0 +1,163 @@
+/*
+ * twl6030_pwm.c
+ * Driver for PHOENIX (TWL6030) Pulse Width Modulator
+ *
+ * Copyright (C) 2010 Texas Instruments
+ * Author: Hemanth V <hemanthv@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/i2c/twl.h>
+#include <linux/slab.h>
+
+#define LED_PWM_CTRL1	0xF4
+#define LED_PWM_CTRL2	0xF5
+
+/* Max value for CTRL1 register */
+#define PWM_CTRL1_MAX	255
+
+/* Pull down disable */
+#define PWM_CTRL2_DIS_PD	(1 << 6)
+
+/* Current control 2.5 milli Amps */
+#define PWM_CTRL2_CURR_02	(2 << 4)
+
+/* LED supply source */
+#define PWM_CTRL2_SRC_VAC	(1 << 2)
+
+/* LED modes */
+#define PWM_CTRL2_MODE_HW	(0 << 0)
+#define PWM_CTRL2_MODE_SW	(1 << 0)
+#define PWM_CTRL2_MODE_DIS	(2 << 0)
+
+#define PWM_CTRL2_MODE_MASK	0x3
+
+struct pwm_device {
+	const char *label;
+	unsigned int pwm_id;
+};
+
+int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
+{
+	u8 duty_cycle;
+	int ret;
+
+	if (pwm == NULL || period_ns == 0 || duty_ns > period_ns)
+		return -EINVAL;
+
+	duty_cycle = (duty_ns * PWM_CTRL1_MAX) / period_ns;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, duty_cycle, LED_PWM_CTRL1);
+
+	if (ret < 0) {
+		pr_err("%s: Failed to configure PWM, Error %d\n",
+			pwm->label, ret);
+		return ret;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(pwm_config);
+
+int pwm_enable(struct pwm_device *pwm)
+{
+	u8 val;
+	int ret;
+
+	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
+	if (ret < 0) {
+		pr_err("%s: Failed to enable PWM, Error %d\n", pwm->label, ret);
+		return ret;
+	}
+
+	/* Change mode to software control */
+	val &= ~PWM_CTRL2_MODE_MASK;
+	val |= PWM_CTRL2_MODE_SW;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
+	if (ret < 0) {
+		pr_err("%s: Failed to enable PWM, Error %d\n", pwm->label, ret);
+		return ret;
+	}
+
+	twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
+	return 0;
+}
+EXPORT_SYMBOL(pwm_enable);
+
+void pwm_disable(struct pwm_device *pwm)
+{
+	u8 val;
+	int ret;
+
+	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
+	if (ret < 0) {
+		pr_err("%s: Failed to disable PWM, Error %d\n",
+			pwm->label, ret);
+		return;
+	}
+
+	val &= ~PWM_CTRL2_MODE_MASK;
+	val |= PWM_CTRL2_MODE_HW;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
+	if (ret < 0) {
+		pr_err("%s: Failed to disable PWM, Error %d\n",
+			pwm->label, ret);
+		return;
+	}
+	return;
+}
+EXPORT_SYMBOL(pwm_disable);
+
+struct pwm_device *pwm_request(int pwm_id, const char *label)
+{
+	u8 val;
+	int ret;
+	struct pwm_device *pwm;
+
+	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
+	if (pwm == NULL) {
+		pr_err("%s: failed to allocate memory\n", label);
+		return NULL;
+	}
+
+	pwm->label = label;
+	pwm->pwm_id = pwm_id;
+
+	/* Configure PWM */
+	val = PWM_CTRL2_DIS_PD | PWM_CTRL2_CURR_02 | PWM_CTRL2_SRC_VAC |
+		PWM_CTRL2_MODE_HW;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
+
+	if (ret < 0) {
+		pr_err("%s: Failed to configure PWM, Error %d\n",
+			 pwm->label, ret);
+
+		kfree(pwm);
+		return NULL;
+	}
+
+	return pwm;
+}
+EXPORT_SYMBOL(pwm_request);
+
+void pwm_free(struct pwm_device *pwm)
+{
+	pwm_disable(pwm);
+	kfree(pwm);
+}
+EXPORT_SYMBOL(pwm_free);
-- 
1.5.4.3


