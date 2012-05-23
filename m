Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2EWXwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 19:52:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44118 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2EWXwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 19:52:21 -0400
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, kyungmin.park@samsung.com, patches@linaro.org
Subject: [PATCH 3/3] gpio: exynos4: skip gpiolib registration if pinctrl driver is used
Date: Thu, 24 May 2012 05:17:37 +0530
Message-Id: <1337816857-14694-4-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337816857-14694-1-git-send-email-thomas.abraham@linaro.org>
References: <1337816857-14694-1-git-send-email-thomas.abraham@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pinctrl driver, when enabled, registers all the gpio pins and hence the
registration of gpio pins by this driver can be skipped.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/gpio/gpio-samsung.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index 19d6fc0..34a9638 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -2788,6 +2788,27 @@ static __init int samsung_gpiolib_init(void)
 #ifdef CONFIG_CPU_EXYNOS4210
 		void __iomem *gpx_base;
 
+#ifdef CONFIG_OF
+		/*
+		 * This gpio driver includes support for device tree support and
+		 * there are platforms using it. In order to maintain
+		 * compatibility with those platforms, and to allow non-dt
+		 * Exynos4210 platforms to use this gpiolib support, a check
+		 * is added to find out if there is a active pin-controller
+		 * driver support available. If it is available, this gpiolib
+		 * support is ignored and the gpiolib support available in
+		 * pin-controller driver is used. This is a temporary check and
+		 * will go away when all of the Exynos4210 platforms have
+		 * switched to using device tree and the pin-ctrl driver.
+		 */
+		struct device_node *pctrl_np;
+		const char *pctrl_compat = "samsung,pinctrl-exynos4210";
+		pctrl_np = of_find_compatible_node(NULL, NULL, pctrl_compat);
+		if (pctrl_np)
+			if (of_device_is_available(pctrl_np))
+				return -ENODEV;
+#endif
+
 		/* gpio part1 */
 		gpio_base1 = ioremap(EXYNOS4_PA_GPIO1, SZ_4K);
 		if (gpio_base1 == NULL) {
-- 
1.6.6.rc2

