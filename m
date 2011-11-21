Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab1KUTtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:49:17 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:50860 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755342Ab1KUTtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:49:15 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 8/8] pinctrl: support pinconfig on the U300
Date: Mon, 21 Nov 2011 20:49:04 +0100
Message-ID: <1321904944-32510-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This adds pin configuration support for the U300 driver pair,
we can now read out the biasing and drive mode in debugfs and
configure it using the new configuration API.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/Kconfig             |    1 +
 drivers/pinctrl/pinctrl-coh901xxx.c |   40 +++++++++++++--
 drivers/pinctrl/pinctrl-coh901xxx.h |    7 ++-
 drivers/pinctrl/pinmux-u300.c       |   93 ++++++++++++++++++++++++++++++-----
 4 files changed, 121 insertions(+), 20 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 74576bb..9d7dd32 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -32,6 +32,7 @@ config PINMUX_U300
 	bool "U300 pinmux driver"
 	depends on ARCH_U300
 	select PINMUX
+	select PINCONF
 
 config PINCTRL_COH901XXX
 	bool "ST-Ericsson U300 COH 901 335/571 GPIO"
diff --git a/drivers/pinctrl/pinctrl-coh901xxx.c b/drivers/pinctrl/pinctrl-coh901xxx.c
index d36b989..a2a1287 100644
--- a/drivers/pinctrl/pinctrl-coh901xxx.c
+++ b/drivers/pinctrl/pinctrl-coh901xxx.c
@@ -420,8 +420,37 @@ static int u300_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	return retirq;
 }
 
-static int u300_gpio_config(struct gpio_chip *chip, unsigned offset,
-			    enum pin_config_param param, unsigned long data)
+int u300_gpio_get_initial_config(struct gpio_chip *chip,
+				 struct pin_config *conf,
+				 unsigned offset)
+{
+	struct u300_gpio *gpio = to_u300_gpio(chip);
+	u32 val;
+
+	val = readl(U300_PIN_REG(offset, per));
+	if (val & U300_PIN_BIT(offset))
+		conf->bias.param = PIN_CONFIG_BIAS_HIGH_IMPEDANCE;
+	else
+		conf->bias.param = PIN_CONFIG_BIAS_PULL_UP;
+	switch (val &
+		(U300_GPIO_PXPCR_PIN_MODE_MASK << ((offset & 0x07) << 1))) {
+	case U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL:
+		conf->drive.param =  PIN_CONFIG_DRIVE_PUSH_PULL;
+		break;
+	case U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_DRAIN:
+		conf->drive.param =  PIN_CONFIG_DRIVE_OPEN_DRAIN;
+		break;
+	case U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_SOURCE:
+		conf->drive.param =  PIN_CONFIG_DRIVE_OPEN_SOURCE;
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+int u300_gpio_config(struct gpio_chip *chip, unsigned offset,
+		     enum pin_config_param param)
 {
 	struct u300_gpio *gpio = to_u300_gpio(chip);
 	unsigned long flags;
@@ -623,12 +652,11 @@ static void __init u300_gpio_init_pin(struct u300_gpio *gpio,
 
 		/* Deactivate bias mode for output */
 		u300_gpio_config(&gpio->chip, offset,
-				 PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
-				 0);
+				 PIN_CONFIG_BIAS_HIGH_IMPEDANCE);
 
 		/* Set drive mode for output */
 		u300_gpio_config(&gpio->chip, offset,
-				 PIN_CONFIG_DRIVE_PUSH_PULL, 0);
+				 PIN_CONFIG_DRIVE_PUSH_PULL);
 
 		dev_dbg(gpio->dev, "set up pin %d as output, value: %d\n",
 			offset, conf->outval);
@@ -639,7 +667,7 @@ static void __init u300_gpio_init_pin(struct u300_gpio *gpio,
 		u300_gpio_set(&gpio->chip, offset, 0);
 
 		/* Set bias mode for input */
-		u300_gpio_config(&gpio->chip, offset, conf->bias_mode, 0);
+		u300_gpio_config(&gpio->chip, offset, conf->bias_mode);
 
 		dev_dbg(gpio->dev, "set up pin %d as input, bias: %04x\n",
 			offset, conf->bias_mode);
diff --git a/drivers/pinctrl/pinctrl-coh901xxx.h b/drivers/pinctrl/pinctrl-coh901xxx.h
index 20390ec..c1e3745 100644
--- a/drivers/pinctrl/pinctrl-coh901xxx.h
+++ b/drivers/pinctrl/pinctrl-coh901xxx.h
@@ -1,3 +1,8 @@
+int u300_gpio_get_initial_config(struct gpio_chip *chip,
+		struct pin_config *conf,
+		unsigned offset);
+int u300_gpio_config(struct gpio_chip *chip,
+		unsigned offset, enum pin_config_param param);
 int u300_gpio_probe(struct platform_device *pdev,
-		    struct gpio_chip **chip);
+		struct gpio_chip **chip);
 int u300_gpio_remove(struct platform_device *pdev);
diff --git a/drivers/pinctrl/pinmux-u300.c b/drivers/pinctrl/pinmux-u300.c
index 1232857..941b82b 100644
--- a/drivers/pinctrl/pinmux-u300.c
+++ b/drivers/pinctrl/pinmux-u300.c
@@ -19,6 +19,7 @@
 #include <linux/err.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinmux.h>
+#include <linux/pinctrl/pinconf.h>
 #include "pinctrl-coh901xxx.h"
 
 /*
@@ -1046,6 +1047,66 @@ static struct pinctrl_gpio_range u300_gpio_ranges[] = {
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
+int u300_pin_get_initial_config(struct pinctrl_dev *pctldev,
+				struct pin_config *conf,
+				unsigned pin)
+{
+	struct pinctrl_gpio_range *range = u300_match_gpio_range(pin);
+
+	/* We get config for those pins we CAN get it for and that's it */
+	if (!range)
+		return 0;
+
+	return u300_gpio_get_initial_config(range->gc, conf,
+				(pin - range->pin_base + range->base));
+}
+
+int u300_pin_config(struct pinctrl_dev *pctldev,
+		    const struct pin_config *conf,
+		    unsigned pin,
+		    const struct pin_config_tuple *configs,
+		    unsigned num_configs)
+{
+	struct pinctrl_gpio_range *range = u300_match_gpio_range(pin);
+	int ret;
+	int i;
+
+	if (!range)
+		return -EINVAL;
+
+	for (i = 0; i < num_configs; i++) {
+		const struct pin_config_tuple *config = &configs[i];
+
+		ret = u300_gpio_config(range->gc,
+				(pin - range->pin_base + range->base),
+				config->param);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static struct pinconf_ops u300_pconf_ops = {
+	.pin_get_initial_config = u300_pin_get_initial_config,
+	.pin_config = u300_pin_config,
+};
+
 static struct pinctrl_desc u300_pmx_desc = {
 	.name = DRIVER_NAME,
 	.pins = u300_pads,
@@ -1053,6 +1114,7 @@ static struct pinctrl_desc u300_pmx_desc = {
 	.maxpin = U300_NUM_PADS-1,
 	.pctlops = &u300_pctrl_ops,
 	.pmxops = &u300_pmx_ops,
+	.confops = &u300_pconf_ops,
 	.owner = THIS_MODULE,
 };
 
@@ -1092,25 +1154,30 @@ static int __init u300_pmx_probe(struct platform_device *pdev)
 		goto out_no_remap;
 	}
 
-	upmx->pctl = pinctrl_register(&u300_pmx_desc, &pdev->dev, upmx);
-	if (!upmx->pctl) {
-		dev_err(&pdev->dev, "could not register U300 pinmux driver\n");
-		ret = -EINVAL;
-		goto out_no_pmx;
-	}
-
 	/* Now probe the sibling GPIO driver */
 	ret = u300_gpio_probe(upmx->gpio_pdev, &chip);
 	if (ret) {
 		dev_err(&pdev->dev, "could not probe sibling GPIO device\n");
 		goto out_no_gpio;
 	}
+	/*
+	 * These ranges will be used during pin configuration registration
+	 * to call back into the GPIO driver and read out default pin
+	 * configuration so set it up here.
+	 */
+	for (i = 0; i < ARRAY_SIZE(u300_gpio_ranges); i++)
+		u300_gpio_ranges[i].gc = chip;
+
+	upmx->pctl = pinctrl_register(&u300_pmx_desc, &pdev->dev, upmx);
+	if (!upmx->pctl) {
+		dev_err(&pdev->dev, "could not register U300 pinmux driver\n");
+		ret = -EINVAL;
+		goto out_no_pmx;
+	}
 
 	/* We will handle a range of GPIO pins */
-	for (i = 0; i < ARRAY_SIZE(u300_gpio_ranges); i++) {
-		u300_gpio_ranges[i].gc = chip;
+	for (i = 0; i < ARRAY_SIZE(u300_gpio_ranges); i++)
 		pinctrl_add_gpio_range(upmx->pctl, &u300_gpio_ranges[i]);
-	}
 
 	platform_set_drvdata(pdev, upmx);
 
@@ -1118,9 +1185,9 @@ static int __init u300_pmx_probe(struct platform_device *pdev)
 
 	return 0;
 
-out_no_gpio:
-	pinctrl_unregister(upmx->pctl);
 out_no_pmx:
+	u300_gpio_remove(upmx->gpio_pdev);
+out_no_gpio:
 	iounmap(upmx->virtbase);
 out_no_remap:
 	platform_set_drvdata(pdev, NULL);
@@ -1136,10 +1203,10 @@ static int __exit u300_pmx_remove(struct platform_device *pdev)
 	struct u300_pmx *upmx = platform_get_drvdata(pdev);
 	int i;
 
+	pinctrl_unregister(upmx->pctl);
 	for (i = 0; i < ARRAY_SIZE(u300_gpio_ranges); i++)
 		pinctrl_remove_gpio_range(upmx->pctl, &u300_gpio_ranges[i]);
 	u300_gpio_remove(upmx->gpio_pdev);
-	pinctrl_unregister(upmx->pctl);
 	iounmap(upmx->virtbase);
 	release_mem_region(upmx->phybase, upmx->physize);
 	platform_set_drvdata(pdev, NULL);
-- 
1.7.3.2

