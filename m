Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab2KTOF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:05:26 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:52759 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753485Ab2KTOFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:05:24 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 7/7] pinctrl/u300/coh901: stop spawning pinctrl from GPIO
Date: Tue, 20 Nov 2012 15:05:07 +0100
Message-ID: <1353420307-18204-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Let's stop spawning the pinctrl driver from the GPIO driver,
we have these two mechanisms broken apart now, and they can
each probe in isolation. If the GPIO driver cannot find its
pin controller (pinctrl-u300), the pin controller core will
tell it to defer probing.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-u300/core.c                    | 2 +-
 drivers/pinctrl/pinctrl-coh901.c             | 6 ------
 include/linux/platform_data/pinctrl-coh901.h | 2 --
 3 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index ce2de0d..ece8a2d 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -1445,7 +1445,6 @@ static struct platform_device pinctrl_device = {
 static struct u300_gpio_platform u300_gpio_plat = {
 	.ports = 7,
 	.gpio_base = 0,
-	.pinctrl_device = &pinctrl_device,
 };
 
 static struct platform_device gpio_device = {
@@ -1589,6 +1588,7 @@ static struct platform_device *platform_devs[] __initdata = {
 	&i2c1_device,
 	&keypad_device,
 	&rtc_device,
+	&pinctrl_device,
 	&gpio_device,
 	&nand_device,
 	&wdog_device,
diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index 0457430..fbb3715 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -816,11 +816,6 @@ static int __init u300_gpio_probe(struct platform_device *pdev)
 		goto err_no_chip;
 	}
 
-	/* Spawn pin controller device as child of the GPIO */
-	err = platform_device_register(plat->pinctrl_device);
-	if (err)
-		goto err_no_pinctrl;
-
 	/*
 	 * Add pinctrl pin ranges, the pin controller must be registered
 	 * at this point
@@ -839,7 +834,6 @@ static int __init u300_gpio_probe(struct platform_device *pdev)
 	return 0;
 
 err_no_range:
-err_no_pinctrl:
 	err = gpiochip_remove(&gpio->chip);
 err_no_chip:
 err_no_domain:
diff --git a/include/linux/platform_data/pinctrl-coh901.h b/include/linux/platform_data/pinctrl-coh901.h
index 27a23b3..dfbc65d 100644
--- a/include/linux/platform_data/pinctrl-coh901.h
+++ b/include/linux/platform_data/pinctrl-coh901.h
@@ -13,12 +13,10 @@
  * struct u300_gpio_platform - U300 GPIO platform data
  * @ports: number of GPIO block ports
  * @gpio_base: first GPIO number for this block (use a free range)
- * @pinctrl_device: pin control device to spawn as child
  */
 struct u300_gpio_platform {
 	u8 ports;
 	int gpio_base;
-	struct platform_device *pinctrl_device;
 };
 
 #endif /* __MACH_U300_GPIO_U300_H */
-- 
1.7.11.3

