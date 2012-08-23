Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030452Ab2HWK6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:58:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47842 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030276Ab2HWK6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:58:03 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-c6-50360cbad24a
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com,
        dong.aisheng@linaro.org, swarren@wwwdotorg.org, patches@linaro.org
Subject: [PATCH v3 3/4] gpio: exynos4: skip gpiolib registration if pinctrl
 driver is used
Date: Thu, 23 Aug 2012 16:45:28 +0530
Message-id: <1345720529-32315-4-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1345720529-32315-1-git-send-email-thomas.abraham@linaro.org>
References: <1345720529-32315-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t9jQd1dPGYBBjvmsltc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGV867zFWnCXt6Ll5AfmBsbJ3F2MnBwSAiYSWx9PY4Gw
	xSQu3FvP1sXIxSEkMJ1RomVhOxNIQkigjUli3d1YEJtNwEDi0cJ37CC2iICrxPEXZxlBGpgF
	fjFKvN6yCaxBWCBGomPTItYuRg4OFgFViTl3TUDCvAKeEldeXGCHWKYksaH3KFg5p4CXxK6v
	q5ghdnlKrN56jmUCI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMG+fya9g3FVg8Uh
	RgEORiUe3oB7pgFCrIllxZW5hxglOJiVRHi9OM0ChHhTEiurUovy44tKc1KLDzFKc7AoifPy
	9xkGCAmkJ5akZqemFqQWwWSZODilGhgXWJs632+7VpepsGh2ydqJufNvW4S6TVj1nXGy/CLh
	1yJakrGl528F7tD6/e5OZE3U0ot/17KU3Sm/VTtl3XeLjpfCq7NSDvTe2XJviamB7I56nh0Z
	6ufPv3jINV8t5//2/NrpPteSAzl9LzHs5WcUn+3ypyclnvtcwueQ+XqGE+ub+PTWdKxTYinO
	SDTUYi4qTgQAAAxw+PkBAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pinctrl driver, when enabled, registers all the gpio pins and hence the
registration of gpio pins by this driver can be skipped.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-samsung.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index ba126cc..41ab7f6 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -2734,6 +2734,27 @@ static __init void exynos4_gpiolib_init(void)
 	int group = 0;
 	void __iomem *gpx_base;
 
+#ifdef CONFIG_PINCTRL_SAMSUNG
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
+				return;
+#endif
+
 	/* gpio part1 */
 	gpio_base1 = ioremap(EXYNOS4_PA_GPIO1, SZ_4K);
 	if (gpio_base1 == NULL) {
-- 
1.6.6.rc2

