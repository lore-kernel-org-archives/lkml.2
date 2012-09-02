Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab2IBJwm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 05:52:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54393 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab2IBJwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 05:52:40 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Antony Pavlov <antonynpavlov@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: [PATCH 3/3] pwm: Add Ingenic JZ4740 support
Date: Sun,  2 Sep 2012 11:52:30 +0200
Message-Id: <1346579550-5990-4-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346579550-5990-1-git-send-email-thierry.reding@avionic-design.de>
References: <1346579550-5990-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:O7bbH0d1TwMcIYzGjRDKZ0FYrCcqa7qpanbgUXKjkSM
 KCtQ+LPjkVVzTEdCL3vMrnx801ZTpDwguOkRrYDs62anNd7oM2
 vQg2QPEHnAyiphQPqCc2rXgaiRCFVyQLi//QledAvTQva+dhtp
 vQDyYwIAxH2L90RX2CLUbavdRIRBMxxaz3Kjq/YPZl3Iqv6J6h
 +v0Y0FMxQPy1yXbZlqzuL76kdg0TUu7miAsMiC+Nbv7mQZ7O9L
 Fncu3LnevUmXvZtBFBj3HWEdkDrPYDilKtbEEcJQCK3PGlmmuH
 aHt5SgnZkY+exbyV7uUd83Cs09I57wIzLQHJPUOKNw/dxYR/78
 3a4tT/eAQdhZsDh+VB7Kb2gBYmtWPbTldojvEX+is1+LI8KRdz
 wgxqDsPYdbfUbJvbUKr22LFx7ayo4LboF288AQQlnzQdcmszti
 6pL4S
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit moves the driver to drivers/pwm and converts it to the new
PWM framework.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/mips/include/asm/mach-jz4740/platform.h |   1 +
 arch/mips/jz4740/Kconfig                     |   3 -
 arch/mips/jz4740/Makefile                    |   2 +-
 arch/mips/jz4740/board-qi_lb60.c             |   3 +-
 arch/mips/jz4740/platform.c                  |   6 +
 arch/mips/jz4740/pwm.c                       | 177 -----------------------
 drivers/pwm/Kconfig                          |  12 +-
 drivers/pwm/Makefile                         |   1 +
 drivers/pwm/core.c                           |   2 +-
 drivers/pwm/pwm-jz4740.c                     | 205 +++++++++++++++++++++++++++
 10 files changed, 228 insertions(+), 184 deletions(-)
 delete mode 100644 arch/mips/jz4740/pwm.c
 create mode 100644 drivers/pwm/pwm-jz4740.c

diff --git a/arch/mips/include/asm/mach-jz4740/platform.h b/arch/mips/include/asm/mach-jz4740/platform.h
index 564ab81..163e81d 100644
--- a/arch/mips/include/asm/mach-jz4740/platform.h
+++ b/arch/mips/include/asm/mach-jz4740/platform.h
@@ -31,6 +31,7 @@ extern struct platform_device jz4740_pcm_device;
 extern struct platform_device jz4740_codec_device;
 extern struct platform_device jz4740_adc_device;
 extern struct platform_device jz4740_wdt_device;
+extern struct platform_device jz4740_pwm_device;
 
 void jz4740_serial_device_register(void);
 
diff --git a/arch/mips/jz4740/Kconfig b/arch/mips/jz4740/Kconfig
index 3e7141f..4689030 100644
--- a/arch/mips/jz4740/Kconfig
+++ b/arch/mips/jz4740/Kconfig
@@ -7,6 +7,3 @@ config JZ4740_QI_LB60
 	bool "Qi Hardware Ben NanoNote"
 
 endchoice
-
-config HAVE_PWM
-	bool
diff --git a/arch/mips/jz4740/Makefile b/arch/mips/jz4740/Makefile
index e44abea..63bad0e 100644
--- a/arch/mips/jz4740/Makefile
+++ b/arch/mips/jz4740/Makefile
@@ -5,7 +5,7 @@
 # Object file lists.
 
 obj-y += prom.o irq.o time.o reset.o setup.o dma.o \
-	gpio.o clock.o platform.o timer.o pwm.o serial.o
+	gpio.o clock.o platform.o timer.o serial.o
 
 obj-$(CONFIG_DEBUG_FS) += clock-debugfs.o
 
diff --git a/arch/mips/jz4740/board-qi_lb60.c b/arch/mips/jz4740/board-qi_lb60.c
index 9a3d9de..405382c 100644
--- a/arch/mips/jz4740/board-qi_lb60.c
+++ b/arch/mips/jz4740/board-qi_lb60.c
@@ -394,7 +394,7 @@ static struct platform_device qi_lb60_pwm_beeper = {
 	.name = "pwm-beeper",
 	.id = -1,
 	.dev = {
-		.platform_data = (void *)4,
+		.platform_data = (void *)2,
 	},
 };
 
@@ -437,6 +437,7 @@ static struct platform_device *jz_platform_devices[] __initdata = {
 	&jz4740_codec_device,
 	&jz4740_rtc_device,
 	&jz4740_adc_device,
+	&jz4740_pwm_device,
 	&qi_lb60_gpio_keys,
 	&qi_lb60_pwm_beeper,
 	&qi_lb60_charger_device,
diff --git a/arch/mips/jz4740/platform.c b/arch/mips/jz4740/platform.c
index e342ed4..6d14dcd 100644
--- a/arch/mips/jz4740/platform.c
+++ b/arch/mips/jz4740/platform.c
@@ -323,3 +323,9 @@ struct platform_device jz4740_wdt_device = {
 	.num_resources = ARRAY_SIZE(jz4740_wdt_resources),
 	.resource      = jz4740_wdt_resources,
 };
+
+/* PWM */
+struct platform_device jz4740_pwm_device = {
+	.name = "jz4740-pwm",
+	.id   = -1,
+};
diff --git a/arch/mips/jz4740/pwm.c b/arch/mips/jz4740/pwm.c
deleted file mode 100644
index a26a6fa..0000000
--- a/arch/mips/jz4740/pwm.c
+++ /dev/null
@@ -1,177 +0,0 @@
-/*
- *  Copyright (C) 2010, Lars-Peter Clausen <lars@metafoo.de>
- *  JZ4740 platform PWM support
- *
- *  This program is free software; you can redistribute it and/or modify it
- *  under  the terms of the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the License, or (at your
- *  option) any later version.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- *
- */
-
-#include <linux/kernel.h>
-
-#include <linux/clk.h>
-#include <linux/err.h>
-#include <linux/pwm.h>
-#include <linux/gpio.h>
-
-#include <asm/mach-jz4740/gpio.h>
-#include "timer.h"
-
-static struct clk *jz4740_pwm_clk;
-
-DEFINE_MUTEX(jz4740_pwm_mutex);
-
-struct pwm_device {
-	unsigned int id;
-	unsigned int gpio;
-	bool used;
-};
-
-static struct pwm_device jz4740_pwm_list[] = {
-	{ 2, JZ_GPIO_PWM2, false },
-	{ 3, JZ_GPIO_PWM3, false },
-	{ 4, JZ_GPIO_PWM4, false },
-	{ 5, JZ_GPIO_PWM5, false },
-	{ 6, JZ_GPIO_PWM6, false },
-	{ 7, JZ_GPIO_PWM7, false },
-};
-
-struct pwm_device *pwm_request(int id, const char *label)
-{
-	int ret = 0;
-	struct pwm_device *pwm;
-
-	if (id < 2 || id > 7 || !jz4740_pwm_clk)
-		return ERR_PTR(-ENODEV);
-
-	mutex_lock(&jz4740_pwm_mutex);
-
-	pwm = &jz4740_pwm_list[id - 2];
-	if (pwm->used)
-		ret = -EBUSY;
-	else
-		pwm->used = true;
-
-	mutex_unlock(&jz4740_pwm_mutex);
-
-	if (ret)
-		return ERR_PTR(ret);
-
-	ret = gpio_request(pwm->gpio, label);
-
-	if (ret) {
-		printk(KERN_ERR "Failed to request pwm gpio: %d\n", ret);
-		pwm->used = false;
-		return ERR_PTR(ret);
-	}
-
-	jz_gpio_set_function(pwm->gpio, JZ_GPIO_FUNC_PWM);
-
-	jz4740_timer_start(id);
-
-	return pwm;
-}
-
-void pwm_free(struct pwm_device *pwm)
-{
-	pwm_disable(pwm);
-	jz4740_timer_set_ctrl(pwm->id, 0);
-
-	jz_gpio_set_function(pwm->gpio, JZ_GPIO_FUNC_NONE);
-	gpio_free(pwm->gpio);
-
-	jz4740_timer_stop(pwm->id);
-
-	pwm->used = false;
-}
-
-int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
-{
-	unsigned long long tmp;
-	unsigned long period, duty;
-	unsigned int prescaler = 0;
-	unsigned int id = pwm->id;
-	uint16_t ctrl;
-	bool is_enabled;
-
-	if (duty_ns < 0 || duty_ns > period_ns)
-		return -EINVAL;
-
-	tmp = (unsigned long long)clk_get_rate(jz4740_pwm_clk) * period_ns;
-	do_div(tmp, 1000000000);
-	period = tmp;
-
-	while (period > 0xffff && prescaler < 6) {
-		period >>= 2;
-		++prescaler;
-	}
-
-	if (prescaler == 6)
-		return -EINVAL;
-
-	tmp = (unsigned long long)period * duty_ns;
-	do_div(tmp, period_ns);
-	duty = period - tmp;
-
-	if (duty >= period)
-		duty = period - 1;
-
-	is_enabled = jz4740_timer_is_enabled(id);
-	if (is_enabled)
-		pwm_disable(pwm);
-
-	jz4740_timer_set_count(id, 0);
-	jz4740_timer_set_duty(id, duty);
-	jz4740_timer_set_period(id, period);
-
-	ctrl = JZ_TIMER_CTRL_PRESCALER(prescaler) | JZ_TIMER_CTRL_SRC_EXT |
-		JZ_TIMER_CTRL_PWM_ABBRUPT_SHUTDOWN;
-
-	jz4740_timer_set_ctrl(id, ctrl);
-
-	if (is_enabled)
-		pwm_enable(pwm);
-
-	return 0;
-}
-
-int pwm_enable(struct pwm_device *pwm)
-{
-	uint32_t ctrl = jz4740_timer_get_ctrl(pwm->id);
-
-	ctrl |= JZ_TIMER_CTRL_PWM_ENABLE;
-	jz4740_timer_set_ctrl(pwm->id, ctrl);
-	jz4740_timer_enable(pwm->id);
-
-	return 0;
-}
-
-void pwm_disable(struct pwm_device *pwm)
-{
-	uint32_t ctrl = jz4740_timer_get_ctrl(pwm->id);
-
-	ctrl &= ~JZ_TIMER_CTRL_PWM_ENABLE;
-	jz4740_timer_disable(pwm->id);
-	jz4740_timer_set_ctrl(pwm->id, ctrl);
-}
-
-static int __init jz4740_pwm_init(void)
-{
-	int ret = 0;
-
-	jz4740_pwm_clk = clk_get(NULL, "ext");
-
-	if (IS_ERR(jz4740_pwm_clk)) {
-		ret = PTR_ERR(jz4740_pwm_clk);
-		jz4740_pwm_clk = NULL;
-	}
-
-	return ret;
-}
-subsys_initcall(jz4740_pwm_init);
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 90c5c73..5c663df 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -1,6 +1,6 @@
 menuconfig PWM
 	bool "Pulse-Width Modulation (PWM) Support"
-	depends on !MACH_JZ4740 && !PUV3_PWM
+	depends on !PUV3_PWM
 	help
 	  Generic Pulse-Width Modulation (PWM) support.
 
@@ -47,6 +47,16 @@ config PWM_IMX
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-imx.
 
+config PWM_JZ4740
+	tristate "Ingenic JZ4740 PWM support"
+	depends on MACH_JZ4740
+	help
+	  Generic PWM framework driver for Ingenic JZ4740 based
+	  machines.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-jz4740.
+
 config PWM_LPC32XX
 	tristate "LPC32XX PWM support"
 	depends on ARCH_LPC32XX
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index e4b2c89..a1d6169 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_PWM)		+= core.o
 obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
 obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
+obj-$(CONFIG_PWM_JZ4740)	+= pwm-jz4740.o
 obj-$(CONFIG_PWM_LPC32XX)	+= pwm-lpc32xx.o
 obj-$(CONFIG_PWM_MXS)		+= pwm-mxs.o
 obj-$(CONFIG_PWM_PXA)		+= pwm-pxa.o
diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 92b1782..f5acdaa 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -371,7 +371,7 @@ EXPORT_SYMBOL_GPL(pwm_free);
  */
 int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 {
-	if (!pwm || period_ns == 0 || duty_ns > period_ns)
+	if (!pwm || duty_ns < 0 || period_ns <= 0 || duty_ns > period_ns)
 		return -EINVAL;
 
 	return pwm->chip->ops->config(pwm->chip, pwm, duty_ns, period_ns);
diff --git a/drivers/pwm/pwm-jz4740.c b/drivers/pwm/pwm-jz4740.c
new file mode 100644
index 0000000..db29b37
--- /dev/null
+++ b/drivers/pwm/pwm-jz4740.c
@@ -0,0 +1,205 @@
+/*
+ *  Copyright (C) 2010, Lars-Peter Clausen <lars@metafoo.de>
+ *  JZ4740 platform PWM support
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under  the terms of the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+
+#include <asm/mach-jz4740/gpio.h>
+#include <timer.h>
+
+#define NUM_PWM 6
+
+static const unsigned int jz4740_pwm_gpio_list[NUM_PWM] = {
+	JZ_GPIO_PWM2,
+	JZ_GPIO_PWM3,
+	JZ_GPIO_PWM4,
+	JZ_GPIO_PWM5,
+	JZ_GPIO_PWM6,
+	JZ_GPIO_PWM7,
+};
+
+struct jz4740_pwm_chip {
+	struct pwm_chip chip;
+	struct clk *clk;
+};
+
+static inline struct jz4740_pwm_chip *to_jz4740(struct pwm_chip *chip)
+{
+	return container_of(chip, struct jz4740_pwm_chip, chip);
+}
+
+static int jz4740_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	unsigned int gpio = jz4740_pwm_gpio_list[pwm->hwpwm];
+	int ret;
+
+	ret = gpio_request(gpio, pwm->label);
+
+	if (ret) {
+		printk(KERN_ERR "Failed to request pwm gpio: %d\n", ret);
+		return ret;
+	}
+
+	jz_gpio_set_function(gpio, JZ_GPIO_FUNC_PWM);
+
+	jz4740_timer_start(pwm->hwpwm);
+
+	return 0;
+}
+
+static void jz4740_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	unsigned int gpio = jz4740_pwm_gpio_list[pwm->hwpwm];
+
+	jz4740_timer_set_ctrl(pwm->hwpwm, 0);
+
+	jz_gpio_set_function(gpio, JZ_GPIO_FUNC_NONE);
+	gpio_free(gpio);
+
+	jz4740_timer_stop(pwm->hwpwm);
+}
+
+static int jz4740_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			     int duty_ns, int period_ns)
+{
+	struct jz4740_pwm_chip *jz4740 = to_jz4740(pwm->chip);
+	unsigned long long tmp;
+	unsigned long period, duty;
+	unsigned int prescaler = 0;
+	uint16_t ctrl;
+	bool is_enabled;
+
+	tmp = (unsigned long long)clk_get_rate(jz4740->clk) * period_ns;
+	do_div(tmp, 1000000000);
+	period = tmp;
+
+	while (period > 0xffff && prescaler < 6) {
+		period >>= 2;
+		++prescaler;
+	}
+
+	if (prescaler == 6)
+		return -EINVAL;
+
+	tmp = (unsigned long long)period * duty_ns;
+	do_div(tmp, period_ns);
+	duty = period - tmp;
+
+	if (duty >= period)
+		duty = period - 1;
+
+	is_enabled = jz4740_timer_is_enabled(pwm->hwpwm);
+	if (is_enabled)
+		pwm_disable(pwm);
+
+	jz4740_timer_set_count(pwm->hwpwm, 0);
+	jz4740_timer_set_duty(pwm->hwpwm, duty);
+	jz4740_timer_set_period(pwm->hwpwm, period);
+
+	ctrl = JZ_TIMER_CTRL_PRESCALER(prescaler) | JZ_TIMER_CTRL_SRC_EXT |
+		JZ_TIMER_CTRL_PWM_ABBRUPT_SHUTDOWN;
+
+	jz4740_timer_set_ctrl(pwm->hwpwm, ctrl);
+
+	if (is_enabled)
+		pwm_enable(pwm);
+
+	return 0;
+}
+
+static int jz4740_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	uint32_t ctrl = jz4740_timer_get_ctrl(pwm->pwm);
+
+	ctrl |= JZ_TIMER_CTRL_PWM_ENABLE;
+	jz4740_timer_set_ctrl(pwm->hwpwm, ctrl);
+	jz4740_timer_enable(pwm->hwpwm);
+
+	return 0;
+}
+
+static void jz4740_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	uint32_t ctrl = jz4740_timer_get_ctrl(pwm->hwpwm);
+
+	ctrl &= ~JZ_TIMER_CTRL_PWM_ENABLE;
+	jz4740_timer_disable(pwm->hwpwm);
+	jz4740_timer_set_ctrl(pwm->hwpwm, ctrl);
+}
+
+static const struct pwm_ops jz4740_pwm_ops = {
+	.request = jz4740_pwm_request,
+	.free = jz4740_pwm_free,
+	.config = jz4740_pwm_config,
+	.enable = jz4740_pwm_enable,
+	.disable = jz4740_pwm_disable,
+};
+
+static int jz4740_pwm_probe(struct platform_device *pdev)
+{
+	struct jz4740_pwm_chip *jz4740;
+	int ret = 0;
+
+	jz4740 = devm_kzalloc(&pdev->dev, sizeof(*jz4740), GFP_KERNEL);
+	if (!jz4740)
+		return -ENOMEM;
+
+	jz4740->clk = clk_get(NULL, "ext");
+	if (IS_ERR(jz4740->clk))
+		return PTR_ERR(jz4740->clk);
+
+	jz4740->chip.dev = &pdev->dev;
+	jz4740->chip.ops = &jz4740_pwm_ops;
+	jz4740->chip.npwm = NUM_PWM;
+	jz4740->chip.base = -1;
+
+	ret = pwmchip_add(&jz4740->chip);
+	if (ret < 0) {
+		clk_put(jz4740->clk);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, jz4740);
+
+	return 0;
+}
+
+static int jz4740_pwm_remove(struct platform_device *pdev)
+{
+	struct jz4740_pwm_chip *jz4740 = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = pwmchip_remove(&jz4740->chip);
+	if (ret < 0)
+		return ret;
+
+	clk_put(jz4740->clk);
+
+	return 0;
+}
+
+static struct platform_driver jz4740_pwm_driver = {
+	.driver = {
+		.name = "jz4740-pwm",
+	},
+	.probe = jz4740_pwm_probe,
+	.remove = jz4740_pwm_remove,
+};
+module_platform_driver(jz4740_pwm_driver);
-- 
1.7.12

