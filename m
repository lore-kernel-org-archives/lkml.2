Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab2CTQvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:51:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63142 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab2CTQvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:51:15 -0400
From: Bernhard Walle <walle@corscience.de>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH] mfd: Add TWL4030 PWM driver
Date: Tue, 20 Mar 2012 17:48:03 +0100
Message-Id: <1332262083-9375-1-git-send-email-walle@corscience.de>
X-Mailer: git-send-email 1.7.9.4
X-Provags-ID: V02:K0:UIxlEkjMufcrAHI2pF5cMvenrTm6JK1o0UbyUDnkuln
 n98HQWqrHFjQ7b9GE6kw5w1reU5wUwfjnCR9RNMe8lBFETDLCY
 y8kKlScw/rF9I8ZSb7HDVy3WzWm6U/xFieG8h4isGGjaTX+EU1
 YbJj9ZQgTzJup3lzvk26e6jMEvmGwTes4yJCIuBLOysqZUhtsk
 o/mt3TEc1JqCuLSiVXOvbUk3nUXC79ndKABMfpheum3eWmc57c
 s3PjwYGdvFv+9XvmvHe+GF2pachcjC96tyVqjUPR1Ip9DY4jHe
 F8BFMLyYGkt+np0cUZwgQVwirO2yNTNmRiZPanedTad5XBAaUU
 /ssaw29FUaevTq7/sLc6M77gQhE9lwBC44ozteQU9d0L58QIwB
 BlmlaPiR4bKvw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This PWM driver uses the PWM of the TWL4030. The driver for the TWL6030
PWM has been used as mode, but the PWM registers are different.

The driver can be used and has been tested in conjunction with
pwm-backlight to control a backlight LED of a LCD touch screen.

Signed-off-by: Bernhard Walle <walle@corscience.de>
---
 drivers/mfd/Kconfig       |    9 ++
 drivers/mfd/Makefile      |    1 +
 drivers/mfd/twl4030-pwm.c |  235 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 245 insertions(+)
 create mode 100644 drivers/mfd/twl4030-pwm.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index f147395..4a7bee8 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -235,6 +235,15 @@ config TWL4030_POWER
 	  and load scripts controlling which resources are switched off/on
 	  or reset when a sleep, wakeup or warm reset event occurs.
 
+config TWL4030_PWM
+	tristate "TWL4030 PWM (Pulse Width Modulator) Support"
+	depends on TWL4030_CORE
+	select HAVE_PWM
+	default n
+	help
+	  Say yes here if you want support for TWL4030 PWM. This PWM
+	  can be used to control the brightness of an LCD backlight.
+
 config MFD_TWL4030_AUDIO
 	bool
 	depends on TWL4030_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b953bab..7b824eb 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_MENELAUS)		+= menelaus.o
 obj-$(CONFIG_TWL4030_CORE)	+= twl-core.o twl4030-irq.o twl6030-irq.o
 obj-$(CONFIG_TWL4030_MADC)      += twl4030-madc.o
 obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
+obj-$(CONFIG_TWL4030_PWM)	+= twl4030-pwm.o
 obj-$(CONFIG_MFD_TWL4030_AUDIO)	+= twl4030-audio.o
 obj-$(CONFIG_TWL6030_PWM)	+= twl6030-pwm.o
 obj-$(CONFIG_TWL6040_CORE)	+= twl6040-core.o twl6040-irq.o
diff --git a/drivers/mfd/twl4030-pwm.c b/drivers/mfd/twl4030-pwm.c
new file mode 100644
index 0000000..06a5dbf
--- /dev/null
+++ b/drivers/mfd/twl4030-pwm.c
@@ -0,0 +1,235 @@
+/*
+ * twl4030-pwm.c
+ * Copyright (C) 2012 Corscience GmbH & Co. KG
+ *               Bernhard Walle <bernhard@bwalle.de>
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
+#define TWL_INTBR_PMBR1		0xD
+#define TWL_INTBR_GPBR1		0xC
+#define TWL_LED_PWMON		0x0
+#define TWL_LED_PWMOFF		0x1
+
+/* GPBR1 */
+#define GPBR1_PWM1_ENABLE	(1<<3)
+#define GPBR1_PWM0_ENABLE	(1<<2)
+#define GPBR1_PWM1_CLK_ENABLE	(1<<1)
+#define GPBR1_PWM0_CLK_ENABLE	(1<<0)
+
+/* PMBR1 */
+#define PMBR1_GPIO7_MASK	((1<<5)|(1<<4))
+#define PMBR1_GPIO7_GPIO	(0x0<<4)
+#define PMBR1_GPIO7_VIBRASYNC	(0x1<<4)
+#define PMBR1_GPIO7_NOACTION	(0x2<<4)
+#define PMBR1_GPIO7_PWM1	(0x3<<4)
+
+#define PMBR1_GPIO6_MASK	((1<<3)|(1<<2))
+#define PMBR1_GPIO6_GPIO	(0x0<<2)
+#define PMBR1_GPIO6_PWM0	(0x1<<2)
+#define PMBR1_GPIO6_MUTE	(0x2<<2)
+
+/* TWL_LED_PWMON and TWL_LED_PWMOFF must be between 0 and PWM_COUNT_MAX. */
+#define PWM_COUNT_MAX		128
+
+/* Opaque data structure */
+struct pwm_device {
+	const char *label;
+	unsigned int pwm_id;
+};
+
+/*
+ * Converts the pwm_id to the I2C register of the TWL that is used to
+ * set the PWM on and off cycle.
+ */
+static const u8 twl_module_register[] = {
+	[0] = TWL4030_MODULE_PWM0,
+	[1] = TWL4030_MODULE_PWM1
+};
+
+int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
+{
+	u8 duty_cycle, addr;
+	int ret;
+
+	if (pwm == NULL || period_ns == 0 || duty_ns > period_ns)
+		return -EINVAL;
+
+	duty_cycle = (duty_ns * PWM_COUNT_MAX) / period_ns;
+	addr = twl_module_register[pwm->pwm_id];
+
+	ret = twl_i2c_write_u8(addr, 0, TWL_LED_PWMON);
+	if (ret) {
+		pr_err("%s: Failed to configure PWM, Error %d\n",
+		       pwm->label, ret);
+		return ret;
+	}
+
+	ret = twl_i2c_write_u8(addr, duty_cycle, TWL_LED_PWMOFF);
+	if (ret < 0) {
+		pr_err("%s: Failed to configure PWM, Error %d\n",
+		       pwm->label, ret);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(pwm_config);
+
+int pwm_enable(struct pwm_device *pwm)
+{
+	int ret;
+	u8 val;
+
+	ret = twl_i2c_read_u8(TWL4030_MODULE_INTBR, &val, TWL_INTBR_GPBR1);
+	if (ret < 0) {
+		pr_err("%s: failed to read TWL_INTBR_GPBR1 register\n",
+			pwm->label);
+		return ret;
+	}
+
+	if (pwm->pwm_id == 0)
+		val |= GPBR1_PWM0_ENABLE | GPBR1_PWM0_CLK_ENABLE;
+	else
+		val |= GPBR1_PWM1_ENABLE | GPBR1_PWM1_CLK_ENABLE;
+
+	ret = twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL_INTBR_GPBR1);
+	if (ret < 0) {
+		pr_err("%s: failed to write TWL_INTBR_GPBR1 register\n",
+			pwm->label);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(pwm_enable);
+
+void pwm_disable(struct pwm_device *pwm)
+{
+	int ret;
+	u8 val;
+
+	ret = twl_i2c_read_u8(TWL4030_MODULE_INTBR, &val, TWL_INTBR_GPBR1);
+	if (ret < 0) {
+		pr_err("%s: failed to read TWL_INTBR_GPBR1 register\n",
+			pwm->label);
+		return;
+	}
+
+	if (pwm->pwm_id == 0)
+		val &= ~(GPBR1_PWM0_ENABLE | GPBR1_PWM0_CLK_ENABLE);
+	else
+		val &= ~(GPBR1_PWM1_ENABLE | GPBR1_PWM1_CLK_ENABLE);
+
+	ret = twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL_INTBR_GPBR1);
+	if (ret < 0)
+		pr_err("%s: failed to write TWL_INTBR_GPBR1 register\n",
+			pwm->label);
+}
+EXPORT_SYMBOL(pwm_disable);
+
+struct pwm_device *pwm_request(int pwm_id, const char *label)
+{
+	int ret;
+	u8 val;
+	struct pwm_device *pwm;
+
+	if (!(pwm_id == 0 || pwm_id == 1)) {
+		pr_err("%s: Invalid pwm_id, only 0 or 1 allowed\n", label);
+		return NULL;
+	}
+
+	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
+	if (!pwm) {
+		pr_err("%s: failed to allocate memory\n", label);
+		return NULL;
+	}
+
+	pwm->label = label;
+	pwm->pwm_id = pwm_id;
+
+	/* change pin mux to use the PWM */
+
+	ret = twl_i2c_read_u8(TWL4030_MODULE_INTBR, &val, TWL_INTBR_PMBR1);
+	if (ret < 0) {
+		pr_err("%s: failed to read TWL_INTBR_PMBR1 register\n",
+			pwm->label);
+		goto err;
+	}
+
+	if (pwm->pwm_id == 0) {
+		val &= PMBR1_GPIO6_MASK;
+		val |= PMBR1_GPIO6_PWM0;
+	} else {
+		val &= PMBR1_GPIO7_MASK;
+		val |= PMBR1_GPIO7_PWM1;
+	}
+
+	ret = twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL_INTBR_PMBR1);
+	if (ret < 0) {
+		pr_err("%s: failed to write TWL_INTBR_PMBR1 register\n",
+			pwm->label);
+		goto err;
+	}
+
+	return pwm;
+
+err:
+	kfree(pwm);
+	return NULL;
+}
+EXPORT_SYMBOL(pwm_request);
+
+void pwm_free(struct pwm_device *pwm)
+{
+	int ret;
+	u8 val;
+
+	pwm_disable(pwm);
+
+	/* change pin mux to use the GPIOs */
+
+	ret = twl_i2c_read_u8(TWL4030_MODULE_INTBR, &val, TWL_INTBR_PMBR1);
+	if (ret < 0) {
+		pr_err("%s: failed to read TWL_INTBR_PMBR1 register\n",
+			pwm->label);
+		goto out;
+	}
+
+	if (pwm->pwm_id == 0) {
+		val &= PMBR1_GPIO6_MASK;
+		val |= PMBR1_GPIO6_GPIO;
+	} else {
+		val &= PMBR1_GPIO7_MASK;
+		val |= PMBR1_GPIO7_GPIO;
+	}
+
+	ret = twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL_INTBR_PMBR1);
+	if (ret < 0) {
+		pr_err("%s: failed to write TWL_INTBR_PMBR1 register\n",
+			pwm->label);
+	}
+
+out:
+	kfree(pwm);
+}
+EXPORT_SYMBOL(pwm_free);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("TWL4030 PWM driver");
+MODULE_AUTHOR("Bernhard Walle <bernhard@bwalle.de>");
-- 
1.7.9.4

