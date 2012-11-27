Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab2K0KLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:11:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33159 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933396Ab2K0KKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 05:10:22 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Tero Kristo <t-kristo@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        <linux-doc@vger.kernel.org>
Subject: [PATCH v4 2/3] pwm: New driver to support PWM driven LEDs on TWL4030/6030 series of PMICs
Date: Tue, 27 Nov 2012 11:09:58 +0100
Message-ID: <1354010999-31371-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354010999-31371-1-git-send-email-peter.ujfalusi@ti.com>
References: <1354010999-31371-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver supports the following LED outputs as generic PWM driver:
TWL4030 LEDA and LEDB (PWMA and PWMB)
TWL6030 Charging indicator LED (PWM LED)

On TWL6030 when the PWM requested LED is configured to be controlled by SW.
In this case the user can enable/disable and set the duty period freely.
When the PWM has been freed, the LED driver is put back to HW control.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 .../devicetree/bindings/pwm/ti,twl-pwmled.txt      |  17 +
 drivers/pwm/Kconfig                                |   9 +
 drivers/pwm/Makefile                               |   1 +
 drivers/pwm/pwm-twl-led.c                          | 342 +++++++++++++++++++++
 4 files changed, 369 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/ti,twl-pwmled.txt
 create mode 100644 drivers/pwm/pwm-twl-led.c

diff --git a/Documentation/devicetree/bindings/pwm/ti,twl-pwmled.txt b/Documentation/devicetree/bindings/pwm/ti,twl-pwmled.txt
new file mode 100644
index 0000000..cb64f3a
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/ti,twl-pwmled.txt
@@ -0,0 +1,17 @@
+Texas Instruments TWL series PWM drivers connected to LED terminals
+
+Supported PWMs:
+On TWL4030 series: PWMA and PWMB (connected to LEDA and LEDB terminals)
+On TWL6030 series: LED PWM (mainly used as charging indicator LED)
+
+Required properties:
+- compatible: "ti,twl4030-pwmled" or "ti,twl6030-pwmled"
+- #pwm-cells: should be 2.  The first cell specifies the per-chip index
+  of the PWM to use and the second cell is the period in nanoseconds.
+
+Example:
+
+twl_pwmled: pwmled {
+	compatible = "ti,twl6030-pwmled";
+	#pwm-cells = <2>;
+};
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 8ed64dd..aa89354 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -160,6 +160,15 @@ config PWM_TWL
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-twl.
 
+config PWM_TWL_LED
+	tristate "TWL4030/6030 PWM support for LED drivers"
+	depends on TWL4030_CORE
+	help
+	  Generic PWM framework driver for TWL4030/6030 LED terminals.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-twl-led.
+
 config PWM_VT8500
 	tristate "vt8500 pwm support"
 	depends on ARCH_VT8500
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 49fabfa..82a92c7 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -13,4 +13,5 @@ obj-$(CONFIG_PWM_TIECAP)	+= pwm-tiecap.o
 obj-$(CONFIG_PWM_TIEHRPWM)	+= pwm-tiehrpwm.o
 obj-$(CONFIG_PWM_TWL6030)	+= pwm-twl6030.o
 obj-$(CONFIG_PWM_TWL)		+= pwm-twl.o
+obj-$(CONFIG_PWM_TWL_LED)	+= pwm-twl-led.o
 obj-$(CONFIG_PWM_VT8500)	+= pwm-vt8500.o
diff --git a/drivers/pwm/pwm-twl-led.c b/drivers/pwm/pwm-twl-led.c
new file mode 100644
index 0000000..c8fb47f
--- /dev/null
+++ b/drivers/pwm/pwm-twl-led.c
@@ -0,0 +1,342 @@
+/*
+ * Driver for TWL4030/6030 Pulse Width Modulator used as LED driver
+ *
+ * Copyright (C) 2012 Texas Instruments
+ * Author: Peter Ujfalusi <peter.ujfalusi@ti.com>
+ *
+ * This driver is a complete rewrite of the former pwm-twl6030.c authorded by:
+ * Hemanth V <hemanthv@ti.com>
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
+#include <linux/pwm.h>
+#include <linux/i2c/twl.h>
+#include <linux/slab.h>
+
+/*
+ * This driver handles the PWM driven LED terminals of TWL4030 and TWL6030.
+ * To generate the signal on TWL4030:
+ *  - LEDA uses PWMA
+ *  - LEDB uses PWMB
+ * TWL6030 has one LED pin with dedicated LEDPWM
+ */
+
+#define TWL4030_LED_MAX		0x7f
+#define TWL6030_LED_MAX		0xff
+
+/* Registers, bits and macro for TWL4030 */
+#define TWL4030_LEDEN_REG	0x00
+#define TWL4030_PWMA_REG	0x01
+
+#define TWL4030_LEDXON		(1 << 0)
+#define TWL4030_LEDXPWM		(1 << 4)
+#define TWL4030_LED_PINS	(TWL4030_LEDXON | TWL4030_LEDXPWM)
+#define TWL4030_LED_TOGGLE(led, x)	((x) << (led))
+
+/* Register, bits and macro for TWL6030 */
+#define TWL6030_LED_PWM_CTRL1	0xf4
+#define TWL6030_LED_PWM_CTRL2	0xf5
+
+#define TWL6040_LED_MODE_HW	0x00
+#define TWL6040_LED_MODE_ON	0x01
+#define TWL6040_LED_MODE_OFF	0x02
+#define TWL6040_LED_MODE_MASK	0x03
+
+struct twl_pwmled_chip {
+	struct pwm_chip chip;
+	struct mutex mutex;
+};
+
+static inline struct twl_pwmled_chip *to_twl(struct pwm_chip *chip)
+{
+	return container_of(chip, struct twl_pwmled_chip, chip);
+}
+
+static int twl4030_pwmled_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			      int duty_ns, int period_ns)
+{
+	int duty_cycle = DIV_ROUND_UP(duty_ns * TWL4030_LED_MAX, period_ns) + 1;
+	u8 pwm_config[2] = {1, 0};
+	int base, ret;
+
+	/*
+	 * To configure the duty period:
+	 * On-cycle is set to 1 (the minimum allowed value)
+	 * The off time of 0 is not configurable, so the mapping is:
+	 * 0 -> off cycle = 2,
+	 * 1 -> off cycle = 2,
+	 * 2 -> off cycle = 3,
+	 * 126 - > off cycle 127,
+	 * 127 - > off cycle 1
+	 * When on cycle == off cycle the PWM will be always on
+	 */
+	if (duty_cycle == 1)
+		duty_cycle = 2;
+	else if (duty_cycle > TWL4030_LED_MAX)
+		duty_cycle = 1;
+
+	base = pwm->hwpwm * 2 + TWL4030_PWMA_REG;
+
+	pwm_config[1] = duty_cycle;
+
+	ret = twl_i2c_write(TWL4030_MODULE_LED, pwm_config, base, 2);
+	if (ret < 0)
+		dev_err(chip->dev, "%s: Failed to configure PWM\n", pwm->label);
+
+	return ret;
+}
+
+static int twl4030_pwmled_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct twl_pwmled_chip *twl = to_twl(chip);
+	int ret;
+	u8 val;
+
+	mutex_lock(&twl->mutex);
+	ret = twl_i2c_read_u8(TWL4030_MODULE_LED, &val, TWL4030_LEDEN_REG);
+	if (ret < 0) {
+		dev_err(chip->dev, "%s: Failed to read LEDEN\n", pwm->label);
+		goto out;
+	}
+
+	val |= TWL4030_LED_TOGGLE(pwm->hwpwm, TWL4030_LED_PINS);
+
+	ret = twl_i2c_write_u8(TWL4030_MODULE_LED, val, TWL4030_LEDEN_REG);
+	if (ret < 0)
+		dev_err(chip->dev, "%s: Failed to enable PWM\n", pwm->label);
+
+out:
+	mutex_unlock(&twl->mutex);
+	return ret;
+}
+
+static void twl4030_pwmled_disable(struct pwm_chip *chip,
+				   struct pwm_device *pwm)
+{
+	struct twl_pwmled_chip *twl = to_twl(chip);
+	int ret;
+	u8 val;
+
+	mutex_lock(&twl->mutex);
+	ret = twl_i2c_read_u8(TWL4030_MODULE_LED, &val, TWL4030_LEDEN_REG);
+	if (ret < 0) {
+		dev_err(chip->dev, "%s: Failed to read LEDEN\n", pwm->label);
+		goto out;
+	}
+
+	val &= ~TWL4030_LED_TOGGLE(pwm->hwpwm, TWL4030_LED_PINS);
+
+	ret = twl_i2c_write_u8(TWL4030_MODULE_LED, val, TWL4030_LEDEN_REG);
+	if (ret < 0)
+		dev_err(chip->dev, "%s: Failed to disable PWM\n", pwm->label);
+
+out:
+	mutex_unlock(&twl->mutex);
+}
+
+static int twl6030_pwmled_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			      int duty_ns, int period_ns)
+{
+	int duty_cycle = (duty_ns * TWL6030_LED_MAX) / period_ns;
+	u8 on_time;
+	int ret;
+
+	on_time = duty_cycle & 0xff;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, on_time,
+			       TWL6030_LED_PWM_CTRL1);
+	if (ret < 0)
+		dev_err(chip->dev, "%s: Failed to configure PWM\n", pwm->label);
+
+	return ret;
+}
+
+static int twl6030_pwmled_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct twl_pwmled_chip *twl = to_twl(chip);
+	int ret;
+	u8 val;
+
+	mutex_lock(&twl->mutex);
+	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, TWL6030_LED_PWM_CTRL2);
+	if (ret < 0) {
+		dev_err(chip->dev, "%s: Failed to read PWM_CTRL2\n",
+			pwm->label);
+		goto out;
+	}
+
+	val &= ~TWL6040_LED_MODE_MASK;
+	val |= TWL6040_LED_MODE_ON;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, TWL6030_LED_PWM_CTRL2);
+	if (ret < 0)
+		dev_err(chip->dev, "%s: Failed to enable PWM\n", pwm->label);
+
+out:
+	mutex_unlock(&twl->mutex);
+	return ret;
+}
+
+static void twl6030_pwmled_disable(struct pwm_chip *chip,
+				   struct pwm_device *pwm)
+{
+	struct twl_pwmled_chip *twl = to_twl(chip);
+	int ret;
+	u8 val;
+
+	mutex_lock(&twl->mutex);
+	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, TWL6030_LED_PWM_CTRL2);
+	if (ret < 0) {
+		dev_err(chip->dev, "%s: Failed to read PWM_CTRL2\n",
+			pwm->label);
+		goto out;
+	}
+
+	val &= ~TWL6040_LED_MODE_MASK;
+	val |= TWL6040_LED_MODE_OFF;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, TWL6030_LED_PWM_CTRL2);
+	if (ret < 0)
+		dev_err(chip->dev, "%s: Failed to disable PWM\n", pwm->label);
+
+out:
+	mutex_unlock(&twl->mutex);
+}
+
+static int twl6030_pwmled_request(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct twl_pwmled_chip *twl = to_twl(chip);
+	int ret;
+	u8 val;
+
+	mutex_lock(&twl->mutex);
+	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, TWL6030_LED_PWM_CTRL2);
+	if (ret < 0) {
+		dev_err(chip->dev, "%s: Failed to read PWM_CTRL2\n",
+			pwm->label);
+		goto out;
+	}
+
+	val &= ~TWL6040_LED_MODE_MASK;
+	val |= TWL6040_LED_MODE_OFF;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, TWL6030_LED_PWM_CTRL2);
+	if (ret < 0)
+		dev_err(chip->dev, "%s: Failed to request PWM\n", pwm->label);
+
+out:
+	mutex_unlock(&twl->mutex);
+	return ret;
+}
+
+static void twl6030_pwmled_free(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct twl_pwmled_chip *twl = to_twl(chip);
+	int ret;
+	u8 val;
+
+	mutex_lock(&twl->mutex);
+	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, TWL6030_LED_PWM_CTRL2);
+	if (ret < 0) {
+		dev_err(chip->dev, "%s: Failed to read PWM_CTRL2\n",
+			pwm->label);
+		goto out;
+	}
+
+	val &= ~TWL6040_LED_MODE_MASK;
+	val |= TWL6040_LED_MODE_HW;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, TWL6030_LED_PWM_CTRL2);
+	if (ret < 0)
+		dev_err(chip->dev, "%s: Failed to free PWM\n", pwm->label);
+
+out:
+	mutex_unlock(&twl->mutex);
+}
+
+static const struct pwm_ops twl4030_pwmled_ops = {
+	.enable = twl4030_pwmled_enable,
+	.disable = twl4030_pwmled_disable,
+	.config = twl4030_pwmled_config,
+};
+
+static const struct pwm_ops twl6030_pwmled_ops = {
+	.enable = twl6030_pwmled_enable,
+	.disable = twl6030_pwmled_disable,
+	.config = twl6030_pwmled_config,
+	.request = twl6030_pwmled_request,
+	.free = twl6030_pwmled_free,
+};
+
+static int twl_pwmled_probe(struct platform_device *pdev)
+{
+	struct twl_pwmled_chip *twl;
+	int ret;
+
+	twl = devm_kzalloc(&pdev->dev, sizeof(*twl), GFP_KERNEL);
+	if (!twl)
+		return -ENOMEM;
+
+	if (twl_class_is_4030()) {
+		twl->chip.ops = &twl4030_pwmled_ops;
+		twl->chip.npwm = 2;
+	} else {
+		twl->chip.ops = &twl6030_pwmled_ops;
+		twl->chip.npwm = 1;
+	}
+
+	twl->chip.dev = &pdev->dev;
+	twl->chip.base = -1;
+
+	mutex_init(&twl->mutex);
+
+	ret = pwmchip_add(&twl->chip);
+	if (ret < 0)
+		return ret;
+
+	platform_set_drvdata(pdev, twl);
+
+	return 0;
+}
+
+static int twl_pwmled_remove(struct platform_device *pdev)
+{
+	struct twl_pwmled_chip *twl = platform_get_drvdata(pdev);
+
+	return pwmchip_remove(&twl->chip);
+}
+
+static struct of_device_id twl_pwmled_of_match[] = {
+	{ .compatible = "ti,twl4030-pwmled" },
+	{ .compatible = "ti,twl6030-pwmled" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, twl_pwmled_of_match);
+
+static struct platform_driver twl_pwmled_driver = {
+	.driver = {
+		.name = "twl-pwmled",
+		.of_match_table = of_match_ptr(twl_pwmled_of_match),
+	},
+	.probe = twl_pwmled_probe,
+	.remove = twl_pwmled_remove,
+};
+module_platform_driver(twl_pwmled_driver);
+
+MODULE_AUTHOR("Peter Ujfalusi <peter.ujfalusi@ti.com>");
+MODULE_DESCRIPTION("PWM driver for TWL4030 and TWL6030 LED outputs");
+MODULE_ALIAS("platform:twl-pwmled");
+MODULE_LICENSE("GPL");
-- 
1.8.0

