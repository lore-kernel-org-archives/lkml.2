Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab2KTOFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:05:53 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:56345 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752780Ab2KTOFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:05:18 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6/7] pinctrl/u300/coh901: let the gpio_chip register the range
Date: Tue, 20 Nov 2012 15:04:58 +0100
Message-ID: <1353420298-18139-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Instead of having the pinctrl driver register the GPIO range
for the gpio_chip, making it necessary to instantiate the
pin controller from the GPIO driver and pass the GPIO chip as
platform data, now let the GPIO chip driver register it's own
ranges and have the pinctrl driver look up the GPIO chip from
the pinctrl core as necessary.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-coh901.c | 47 ++++++++++++++++++++++++++++++++--
 drivers/pinctrl/pinctrl-u300.c   | 55 +++-------------------------------------
 2 files changed, 49 insertions(+), 53 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index 1144dcd..0457430 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -658,6 +658,36 @@ static inline void u300_gpio_free_ports(struct u300_gpio *gpio)
 	}
 }
 
+/*
+ * Here we map a GPIO in the local gpio_chip pin space to a pin in
+ * the local pinctrl pin space. The pin controller used is
+ * pinctrl-u300.
+ */
+struct coh901_pinpair {
+	unsigned int offset;
+	unsigned int pin_base;
+};
+
+#define COH901_PINRANGE(a, b) { .offset = a, .pin_base = b }
+
+static struct coh901_pinpair coh901_pintable[] = {
+	COH901_PINRANGE(10, 426),
+	COH901_PINRANGE(11, 180),
+	COH901_PINRANGE(12, 165), /* MS/MMC card insertion */
+	COH901_PINRANGE(13, 179),
+	COH901_PINRANGE(14, 178),
+	COH901_PINRANGE(16, 194),
+	COH901_PINRANGE(17, 193),
+	COH901_PINRANGE(18, 192),
+	COH901_PINRANGE(19, 191),
+	COH901_PINRANGE(20, 186),
+	COH901_PINRANGE(21, 185),
+	COH901_PINRANGE(22, 184),
+	COH901_PINRANGE(23, 183),
+	COH901_PINRANGE(24, 182),
+	COH901_PINRANGE(25, 181),
+};
+
 static int __init u300_gpio_probe(struct platform_device *pdev)
 {
 	struct u300_gpio_platform *plat = dev_get_platdata(&pdev->dev);
@@ -786,16 +816,29 @@ static int __init u300_gpio_probe(struct platform_device *pdev)
 		goto err_no_chip;
 	}
 
-	/* Spawn pin controller device as child of the GPIO, pass gpio chip */
-	plat->pinctrl_device->dev.platform_data = &gpio->chip;
+	/* Spawn pin controller device as child of the GPIO */
 	err = platform_device_register(plat->pinctrl_device);
 	if (err)
 		goto err_no_pinctrl;
 
+	/*
+	 * Add pinctrl pin ranges, the pin controller must be registered
+	 * at this point
+	 */
+	for (i = 0; i < ARRAY_SIZE(coh901_pintable); i++) {
+		struct coh901_pinpair *p = &coh901_pintable[i];
+
+		err = gpiochip_add_pin_range(&gpio->chip, "pinctrl-u300",
+					     p->offset, p->pin_base, 1);
+		if (err)
+			goto err_no_range;
+	}
+
 	platform_set_drvdata(pdev, gpio);
 
 	return 0;
 
+err_no_range:
 err_no_pinctrl:
 	err = gpiochip_remove(&gpio->chip);
 err_no_chip:
diff --git a/drivers/pinctrl/pinctrl-u300.c b/drivers/pinctrl/pinctrl-u300.c
index d756cce..b84de03 100644
--- a/drivers/pinctrl/pinctrl-u300.c
+++ b/drivers/pinctrl/pinctrl-u300.c
@@ -1011,51 +1011,11 @@ static struct pinmux_ops u300_pmx_ops = {
 	.disable = u300_pmx_disable,
 };
 
-/*
- * GPIO ranges handled by the application-side COH901XXX GPIO controller
- * Very many pins can be converted into GPIO pins, but we only list those
- * that are useful in practice to cut down on tables.
- */
-#define U300_GPIO_RANGE(a, b, c) { .name = "COH901XXX", .id = a, .base= a, \
-			.pin_base = b, .npins = c }
-
-static struct pinctrl_gpio_range u300_gpio_ranges[] = {
-	U300_GPIO_RANGE(10, 426, 1),
-	U300_GPIO_RANGE(11, 180, 1),
-	U300_GPIO_RANGE(12, 165, 1), /* MS/MMC card insertion */
-	U300_GPIO_RANGE(13, 179, 1),
-	U300_GPIO_RANGE(14, 178, 1),
-	U300_GPIO_RANGE(16, 194, 1),
-	U300_GPIO_RANGE(17, 193, 1),
-	U300_GPIO_RANGE(18, 192, 1),
-	U300_GPIO_RANGE(19, 191, 1),
-	U300_GPIO_RANGE(20, 186, 1),
-	U300_GPIO_RANGE(21, 185, 1),
-	U300_GPIO_RANGE(22, 184, 1),
-	U300_GPIO_RANGE(23, 183, 1),
-	U300_GPIO_RANGE(24, 182, 1),
-	U300_GPIO_RANGE(25, 181, 1),
-};
-
-static struct pinctrl_gpio_range *u300_match_gpio_range(unsigned pin)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(u300_gpio_ranges); i++) {
-		struct pinctrl_gpio_range *range;
-
-		range = &u300_gpio_ranges[i];
-		if (pin >= range->pin_base &&
-		    pin <= (range->pin_base + range->npins - 1))
-			return range;
-	}
-	return NULL;
-}
-
 static int u300_pin_config_get(struct pinctrl_dev *pctldev, unsigned pin,
 			       unsigned long *config)
 {
-	struct pinctrl_gpio_range *range = u300_match_gpio_range(pin);
+	struct pinctrl_gpio_range *range =
+		pinctrl_find_gpio_range_from_pin(pctldev, pin);
 
 	/* We get config for those pins we CAN get it for and that's it */
 	if (!range)
@@ -1069,7 +1029,8 @@ static int u300_pin_config_get(struct pinctrl_dev *pctldev, unsigned pin,
 static int u300_pin_config_set(struct pinctrl_dev *pctldev, unsigned pin,
 			       unsigned long config)
 {
-	struct pinctrl_gpio_range *range = u300_match_gpio_range(pin);
+	struct pinctrl_gpio_range *range =
+		pinctrl_find_gpio_range_from_pin(pctldev, pin);
 	int ret;
 
 	if (!range)
@@ -1105,8 +1066,6 @@ static int __devinit u300_pmx_probe(struct platform_device *pdev)
 {
 	struct u300_pmx *upmx;
 	struct resource *res;
-	struct gpio_chip *gpio_chip = dev_get_platdata(&pdev->dev);
-	int i;
 
 	/* Create state holders etc for this driver */
 	upmx = devm_kzalloc(&pdev->dev, sizeof(*upmx), GFP_KERNEL);
@@ -1129,12 +1088,6 @@ static int __devinit u300_pmx_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	/* We will handle a range of GPIO pins */
-	for (i = 0; i < ARRAY_SIZE(u300_gpio_ranges); i++) {
-		u300_gpio_ranges[i].gc = gpio_chip;
-		pinctrl_add_gpio_range(upmx->pctl, &u300_gpio_ranges[i]);
-	}
-
 	platform_set_drvdata(pdev, upmx);
 
 	dev_info(&pdev->dev, "initialized U300 pin control driver\n");
-- 
1.7.11.3

