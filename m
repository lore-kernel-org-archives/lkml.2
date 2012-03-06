Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346Ab2CFWGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:06:07 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:34325 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965203Ab2CFWFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:05:52 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/4] pinctrl: support pinconfig on the U300
Date: Tue, 6 Mar 2012 23:05:33 +0100
Message-ID: <1331071533-24789-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This adds pin configuration support for the U300 driver pair,
we can now read out the biasing and drive mode in debugfs and
configure it using the new configuration API.

ChangeLog v1->v2:
- Migrate to pin config and generic pin config changes.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/Kconfig          |    1 +
 drivers/pinctrl/pinctrl-coh901.c |   77 ++++++++++++++++++++++++++++++++++----
 drivers/pinctrl/pinctrl-coh901.h |    5 ++
 drivers/pinctrl/pinctrl-u300.c   |   60 +++++++++++++++++++++++++++++
 4 files changed, 135 insertions(+), 8 deletions(-)
 create mode 100644 drivers/pinctrl/pinctrl-coh901.h

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index ef197cc..d2412b1 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -58,6 +58,7 @@ config PINCTRL_U300
 	bool "U300 pin controller driver"
 	depends on ARCH_U300
 	select PINMUX
+	select GENERIC_PINCONF
 
 config PINCTRL_COH901
 	bool "ST-Ericsson U300 COH 901 335/571 GPIO"
diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index 724234c..0797eba 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -23,7 +23,9 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/pinctrl/pinconf-generic.h>
 #include <mach/gpio-u300.h>
+#include "pinctrl-coh901.h"
 
 /*
  * Register definitions for COH 901 335 variant
@@ -418,8 +420,68 @@ static int u300_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	return retirq;
 }
 
-static int u300_gpio_config(struct gpio_chip *chip, unsigned offset,
-			    enum pin_config_param param, unsigned long data)
+/* Returning -EINVAL means "supported but not available" */
+int u300_gpio_config_get(struct gpio_chip *chip,
+			 unsigned offset,
+			 unsigned long *config)
+{
+	struct u300_gpio *gpio = to_u300_gpio(chip);
+	enum pin_config_param param = (enum pin_config_param) *config;
+	bool biasmode;
+	u32 drmode;
+
+	/* One bit per pin, clamp to bool range */
+	biasmode = !!(readl(U300_PIN_REG(offset, per)) & U300_PIN_BIT(offset));
+
+	/* Mask out the two bits for this pin and shift to bits 0,1 */
+	drmode = readl(U300_PIN_REG(offset, pcr));
+	drmode &= (U300_GPIO_PXPCR_PIN_MODE_MASK << ((offset & 0x07) << 1));
+	drmode >>= ((offset & 0x07) << 1);
+
+	switch(param) {
+	case PIN_CONFIG_BIAS_HIGH_IMPEDANCE:
+		*config = 0;
+		if (biasmode)
+			return 0;
+		else
+			return -EINVAL;
+		break;
+	case PIN_CONFIG_BIAS_PULL_UP:
+		*config = 0;
+		if (!biasmode)
+			return 0;
+		else
+			return -EINVAL;
+		break;
+	case PIN_CONFIG_DRIVE_PUSH_PULL:
+		*config = 0;
+		if (drmode == U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL)
+			return 0;
+		else
+			return -EINVAL;
+		break;
+	case PIN_CONFIG_DRIVE_OPEN_DRAIN:
+		*config = 0;
+		if (drmode == U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_DRAIN)
+			return 0;
+		else
+			return -EINVAL;
+		break;
+	case PIN_CONFIG_DRIVE_OPEN_SOURCE:
+		*config = 0;
+		if (drmode == U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_SOURCE)
+			return 0;
+		else
+			return -EINVAL;
+		break;
+	default:
+		break;
+	}
+	return -ENOTSUPP;
+}
+
+int u300_gpio_config_set(struct gpio_chip *chip, unsigned offset,
+			 enum pin_config_param param)
 {
 	struct u300_gpio *gpio = to_u300_gpio(chip);
 	unsigned long flags;
@@ -620,13 +682,12 @@ static void __init u300_gpio_init_pin(struct u300_gpio *gpio,
 		u300_gpio_direction_output(&gpio->chip, offset, conf->outval);
 
 		/* Deactivate bias mode for output */
-		u300_gpio_config(&gpio->chip, offset,
-				 PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
-				 0);
+		u300_gpio_config_set(&gpio->chip, offset,
+				     PIN_CONFIG_BIAS_HIGH_IMPEDANCE);
 
 		/* Set drive mode for output */
-		u300_gpio_config(&gpio->chip, offset,
-				 PIN_CONFIG_DRIVE_PUSH_PULL, 0);
+		u300_gpio_config_set(&gpio->chip, offset,
+				     PIN_CONFIG_DRIVE_PUSH_PULL);
 
 		dev_dbg(gpio->dev, "set up pin %d as output, value: %d\n",
 			offset, conf->outval);
@@ -637,7 +698,7 @@ static void __init u300_gpio_init_pin(struct u300_gpio *gpio,
 		u300_gpio_set(&gpio->chip, offset, 0);
 
 		/* Set bias mode for input */
-		u300_gpio_config(&gpio->chip, offset, conf->bias_mode, 0);
+		u300_gpio_config_set(&gpio->chip, offset, conf->bias_mode);
 
 		dev_dbg(gpio->dev, "set up pin %d as input, bias: %04x\n",
 			offset, conf->bias_mode);
diff --git a/drivers/pinctrl/pinctrl-coh901.h b/drivers/pinctrl/pinctrl-coh901.h
new file mode 100644
index 0000000..8729422
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-coh901.h
@@ -0,0 +1,5 @@
+int u300_gpio_config_get(struct gpio_chip *chip,
+			 unsigned offset,
+			 unsigned long *config);
+int u300_gpio_config_set(struct gpio_chip *chip, unsigned offset,
+			 enum pin_config_param param);
diff --git a/drivers/pinctrl/pinctrl-u300.c b/drivers/pinctrl/pinctrl-u300.c
index fc4a281..b18101a 100644
--- a/drivers/pinctrl/pinctrl-u300.c
+++ b/drivers/pinctrl/pinctrl-u300.c
@@ -19,6 +19,9 @@
 #include <linux/err.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinmux.h>
+#include <linux/pinctrl/pinconf.h>
+#include <linux/pinctrl/pinconf-generic.h>
+#include "pinctrl-coh901.h"
 
 /*
  * Register definitions for the U300 Padmux control registers in the
@@ -1044,12 +1047,69 @@ static struct pinctrl_gpio_range u300_gpio_ranges[] = {
 	U300_GPIO_RANGE(25, 181, 1),
 };
 
+static struct pinctrl_gpio_range *u300_match_gpio_range(unsigned pin)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(u300_gpio_ranges); i++) {
+		struct pinctrl_gpio_range *range;
+
+		range = &u300_gpio_ranges[i];
+		if (pin >= range->pin_base &&
+		    pin <= (range->pin_base + range->npins - 1))
+			return range;
+	}
+	return NULL;
+}
+
+int u300_pin_config_get(struct pinctrl_dev *pctldev,
+			unsigned pin,
+			unsigned long *config)
+{
+	struct pinctrl_gpio_range *range = u300_match_gpio_range(pin);
+
+	/* We get config for those pins we CAN get it for and that's it */
+	if (!range)
+		return -ENOTSUPP;
+
+	return u300_gpio_config_get(range->gc,
+				    (pin - range->pin_base + range->base),
+				    config);
+}
+
+int u300_pin_config_set(struct pinctrl_dev *pctldev,
+			unsigned pin,
+			unsigned long config)
+{
+	struct pinctrl_gpio_range *range = u300_match_gpio_range(pin);
+	int ret;
+
+	if (!range)
+		return -EINVAL;
+
+	/* Note: none of these configurations take any argument */
+	ret = u300_gpio_config_set(range->gc,
+				   (pin - range->pin_base + range->base),
+				   to_config_param(config));
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static struct pinconf_ops u300_pconf_ops = {
+	.is_generic = true,
+	.pin_config_get = u300_pin_config_get,
+	.pin_config_set = u300_pin_config_set,
+};
+
 static struct pinctrl_desc u300_pmx_desc = {
 	.name = DRIVER_NAME,
 	.pins = u300_pads,
 	.npins = ARRAY_SIZE(u300_pads),
 	.pctlops = &u300_pctrl_ops,
 	.pmxops = &u300_pmx_ops,
+	.confops = &u300_pconf_ops,
 	.owner = THIS_MODULE,
 };
 
-- 
1.7.8

