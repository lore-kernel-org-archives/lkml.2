Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab1KUTsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:48:52 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:43556 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756583Ab1KUTst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:48:49 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/8] pinctrl: u300-pinmux: register proper GPIO ranges
Date: Mon, 21 Nov 2011 20:48:27 +0100
Message-ID: <1321904907-32377-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This register the actual GPIO ranges used by the COH901XXX GPIO
driver.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinmux-u300.c |   40 +++++++++++++++++++++++++++++-----------
 1 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/pinmux-u300.c b/drivers/pinctrl/pinmux-u300.c
index bcf61be..7e89b36 100644
--- a/drivers/pinctrl/pinmux-u300.c
+++ b/drivers/pinctrl/pinmux-u300.c
@@ -1019,15 +1019,29 @@ static struct pinmux_ops u300_pmx_ops = {
 };
 
 /*
- * FIXME: this will be set to sane values as this driver engulfs
- * drivers/gpio/gpio-u300.c and we really know this stuff.
+ * GPIO ranges handled by the application-side COH901XXX GPIO controller
+ * Very many pins can be converted into GPIO pins, but we only list those
+ * that are useful in practice to cut down on tables.
  */
-static struct pinctrl_gpio_range u300_gpio_range = {
-	.name = "COH901*",
-	.id = 0,
-	.base = 0,
-	.pin_base = 0,
-	.npins = 64,
+#define U300_GPIO_RANGE(a, b, c) { .name = "COH901XXX", .id = a, .base= a, \
+			.pin_base = b, .npins = c }
+
+static struct pinctrl_gpio_range u300_gpio_ranges[] = {
+	U300_GPIO_RANGE(10, 426, 1),
+	U300_GPIO_RANGE(11, 180, 1),
+	U300_GPIO_RANGE(12, 165, 1), /* MS/MMC card insertion */
+	U300_GPIO_RANGE(13, 179, 1),
+	U300_GPIO_RANGE(14, 178, 1),
+	U300_GPIO_RANGE(16, 194, 1),
+	U300_GPIO_RANGE(17, 193, 1),
+	U300_GPIO_RANGE(18, 192, 1),
+	U300_GPIO_RANGE(19, 191, 1),
+	U300_GPIO_RANGE(20, 186, 1),
+	U300_GPIO_RANGE(21, 185, 1),
+	U300_GPIO_RANGE(22, 184, 1),
+	U300_GPIO_RANGE(23, 183, 1),
+	U300_GPIO_RANGE(24, 182, 1),
+	U300_GPIO_RANGE(25, 181, 1),
 };
 
 static struct pinctrl_desc u300_pmx_desc = {
@@ -1042,9 +1056,10 @@ static struct pinctrl_desc u300_pmx_desc = {
 
 static int __init u300_pmx_probe(struct platform_device *pdev)
 {
-	int ret;
 	struct u300_pmx *upmx;
 	struct resource *res;
+	int ret;
+	int i;
 
 	/* Create state holders etc for this driver */
 	upmx = devm_kzalloc(&pdev->dev, sizeof(*upmx), GFP_KERNEL);
@@ -1081,7 +1096,8 @@ static int __init u300_pmx_probe(struct platform_device *pdev)
 	}
 
 	/* We will handle a range of GPIO pins */
-	pinctrl_add_gpio_range(upmx->pctl, &u300_gpio_range);
+	for (i = 0; i < ARRAY_SIZE(u300_gpio_ranges); i++)
+		pinctrl_add_gpio_range(upmx->pctl, &u300_gpio_ranges[i]);
 
 	platform_set_drvdata(pdev, upmx);
 
@@ -1103,8 +1119,10 @@ out_no_resource:
 static int __exit u300_pmx_remove(struct platform_device *pdev)
 {
 	struct u300_pmx *upmx = platform_get_drvdata(pdev);
+	int i;
 
-	pinctrl_remove_gpio_range(upmx->pctl, &u300_gpio_range);
+	for (i = 0; i < ARRAY_SIZE(u300_gpio_ranges); i++)
+		pinctrl_remove_gpio_range(upmx->pctl, &u300_gpio_ranges[i]);
 	pinctrl_unregister(upmx->pctl);
 	iounmap(upmx->virtbase);
 	release_mem_region(upmx->phybase, upmx->physize);
-- 
1.7.3.2

