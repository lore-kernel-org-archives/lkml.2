Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab2EKIa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:30:26 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:38308 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756067Ab2EKIaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:30:21 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 06/12 v2] pinctrl/nomadik: implement pin configuration
Date: Fri, 11 May 2012 10:29:42 +0200
Message-ID: <1336724982-25154-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This implements the pin configuration interface for the
Nomadik pin controller.

As part of the exercise we add a bit in the pin_cfg_t for
the Nomadik pinctrl driver that indicates if the pin should
be forced into GPIO mode. This is not done to go behind the
back of the GPIO subsystem, but to ensure that default modes
can be set by hogs on boot and system suspend/resume states.
It was used implicitly by the old code defining all config
settings and modes in a single config word but we now have
a split between pinmux and pinconf leading to the need to
have this.

We also add a bit for explicitly setting sleepmode of the
pin. This was previously handled by custom calls with the
_sleep() suffix, but we now have one single interface into
the configuration so we replace this with a bit indicating
that the pin shall be configured into sleep mode.

Some of the configuration can be refactored later to use
less custom fields on the pin_cfg_t but we are currently
leaving the old function calls in place so we stay
compatible.

ChangeLog v1->v2:
- Drop a hunk changing pinmuxing for GPIO and move it
  over to the preceding pinmux patch.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/plat-nomadik/include/plat/pincfg.h |   13 +++
 drivers/pinctrl/Kconfig                     |    1 +
 drivers/pinctrl/pinctrl-nomadik.c           |  113 +++++++++++++++++++++++++++
 3 files changed, 127 insertions(+)

diff --git a/arch/arm/plat-nomadik/include/plat/pincfg.h b/arch/arm/plat-nomadik/include/plat/pincfg.h
index c015133..9c949c7 100644
--- a/arch/arm/plat-nomadik/include/plat/pincfg.h
+++ b/arch/arm/plat-nomadik/include/plat/pincfg.h
@@ -124,6 +124,19 @@ typedef unsigned long pin_cfg_t;
 #define PIN_LOWEMI_DISABLED	(0 << PIN_LOWEMI_SHIFT)
 #define PIN_LOWEMI_ENABLED	(1 << PIN_LOWEMI_SHIFT)
 
+#define PIN_GPIOMODE_SHIFT	26
+#define PIN_GPIOMODE_MASK	(0x1 << PIN_GPIOMODE_SHIFT)
+#define PIN_GPIOMODE(x)		(((x) & PIN_GPIOMODE_MASK) >> PIN_GPIOMODE_SHIFT)
+#define PIN_GPIOMODE_DISABLED	(0 << PIN_GPIOMODE_SHIFT)
+#define PIN_GPIOMODE_ENABLED	(1 << PIN_GPIOMODE_SHIFT)
+
+#define PIN_SLEEPMODE_SHIFT	27
+#define PIN_SLEEPMODE_MASK	(0x1 << PIN_SLEEPMODE_SHIFT)
+#define PIN_SLEEPMODE(x)	(((x) & PIN_SLEEPMODE_MASK) >> PIN_SLEEPMODE_SHIFT)
+#define PIN_SLEEPMODE_DISABLED	(0 << PIN_SLEEPMODE_SHIFT)
+#define PIN_SLEEPMODE_ENABLED	(1 << PIN_SLEEPMODE_SHIFT)
+
+
 /* Shortcuts.  Use these instead of separate DIR, PULL, and VAL.  */
 #define PIN_INPUT_PULLDOWN	(PIN_DIR_INPUT | PIN_PULL_DOWN)
 #define PIN_INPUT_PULLUP	(PIN_DIR_INPUT | PIN_PULL_UP)
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index bbf14dc..81b1967 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -40,6 +40,7 @@ config PINCTRL_NOMADIK
 	bool "Nomadik pin controller driver"
 	depends on ARCH_U8500
 	select PINMUX
+	select PINCONF
 
 config PINCTRL_DB8500
 	bool "DB8500 pin controller driver"
diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 8c632e9..b8e01c3 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinmux.h>
+#include <linux/pinctrl/pinconf.h>
 /* Since we request GPIOs from ourself */
 #include <linux/pinctrl/consumer.h>
 
@@ -1568,10 +1569,122 @@ static struct pinmux_ops nmk_pinmux_ops = {
 	.gpio_disable_free = nmk_gpio_disable_free,
 };
 
+int nmk_pin_config_get(struct pinctrl_dev *pctldev,
+		       unsigned pin,
+		       unsigned long *config)
+{
+	/* Not implemented */
+	return -EINVAL;
+}
+
+int nmk_pin_config_set(struct pinctrl_dev *pctldev,
+		       unsigned pin,
+		       unsigned long config)
+{
+	static const char *pullnames[] = {
+		[NMK_GPIO_PULL_NONE]	= "none",
+		[NMK_GPIO_PULL_UP]	= "up",
+		[NMK_GPIO_PULL_DOWN]	= "down",
+		[3] /* illegal */	= "??"
+	};
+	static const char *slpmnames[] = {
+		[NMK_GPIO_SLPM_INPUT]		= "input/wakeup",
+		[NMK_GPIO_SLPM_NOCHANGE]	= "no-change/no-wakeup",
+	};
+	struct nmk_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
+	struct nmk_gpio_chip *nmk_chip;
+	struct pinctrl_gpio_range *range;
+	struct gpio_chip *chip;
+	unsigned bit;
+
+	/*
+	 * The pin config contains pin number and altfunction fields, here
+	 * we just ignore that part. It's being handled by the framework and
+	 * pinmux callback respectively.
+	 */
+	pin_cfg_t cfg = (pin_cfg_t) config;
+	int pull = PIN_PULL(cfg);
+	int slpm = PIN_SLPM(cfg);
+	int output = PIN_DIR(cfg);
+	int val = PIN_VAL(cfg);
+	bool lowemi = PIN_LOWEMI(cfg);
+	bool gpiomode = PIN_GPIOMODE(cfg);
+	bool sleep = PIN_SLEEPMODE(cfg);
+
+	range = nmk_match_gpio_range(pctldev, pin);
+	if (!range) {
+		dev_err(npct->dev, "invalid pin offset %d\n", pin);
+		return -EINVAL;
+	}
+	if (!range->gc) {
+		dev_err(npct->dev, "GPIO chip missing in range for pin %d\n",
+			pin);
+		return -EINVAL;
+	}
+	chip = range->gc;
+	nmk_chip = container_of(chip, struct nmk_gpio_chip, chip);
+
+	if (sleep) {
+		int slpm_pull = PIN_SLPM_PULL(cfg);
+		int slpm_output = PIN_SLPM_DIR(cfg);
+		int slpm_val = PIN_SLPM_VAL(cfg);
+
+		/* All pins go into GPIO mode at sleep */
+		gpiomode = true;
+
+		/*
+		 * The SLPM_* values are normal values + 1 to allow zero to
+		 * mean "same as normal".
+		 */
+		if (slpm_pull)
+			pull = slpm_pull - 1;
+		if (slpm_output)
+			output = slpm_output - 1;
+		if (slpm_val)
+			val = slpm_val - 1;
+
+		dev_dbg(nmk_chip->chip.dev, "pin %d: sleep pull %s, dir %s, val %s\n",
+			pin,
+			slpm_pull ? pullnames[pull] : "same",
+			slpm_output ? (output ? "output" : "input") : "same",
+			slpm_val ? (val ? "high" : "low") : "same");
+	}
+
+	dev_dbg(nmk_chip->chip.dev, "pin %d [%#lx]: pull %s, slpm %s (%s%s), lowemi %s\n",
+		pin, cfg, pullnames[pull], slpmnames[slpm],
+		output ? "output " : "input",
+		output ? (val ? "high" : "low") : "",
+		lowemi ? "on" : "off" );
+
+	clk_enable(nmk_chip->clk);
+	bit = pin % NMK_GPIO_PER_CHIP;
+	if (gpiomode)
+		/* No glitch when going to GPIO mode */
+		__nmk_gpio_set_mode(nmk_chip, bit, NMK_GPIO_ALT_GPIO);
+	if (output)
+		__nmk_gpio_make_output(nmk_chip, bit, val);
+	else {
+		__nmk_gpio_make_input(nmk_chip, bit);
+		__nmk_gpio_set_pull(nmk_chip, bit, pull);
+	}
+	/* TODO: isn't this only applicable on output pins? */
+	__nmk_gpio_set_lowemi(nmk_chip, bit, lowemi);
+
+	__nmk_gpio_set_slpm(nmk_chip, bit, slpm);
+	clk_disable(nmk_chip->clk);
+	return 0;
+}
+
+static struct pinconf_ops nmk_pinconf_ops = {
+	.pin_config_get = nmk_pin_config_get,
+	.pin_config_set = nmk_pin_config_set,
+};
+
 static struct pinctrl_desc nmk_pinctrl_desc = {
 	.name = "pinctrl-nomadik",
 	.pctlops = &nmk_pinctrl_ops,
 	.pmxops = &nmk_pinmux_ops,
+	.confops = &nmk_pinconf_ops,
 	.owner = THIS_MODULE,
 };
 
-- 
1.7.9.2

