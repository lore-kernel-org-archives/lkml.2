Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab2HOTkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:40:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26012 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab2HOTkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:40:36 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-09-502bfb337520
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH v2 3/4] gpio: exynos4: skip gpiolib registration if pinctrl
 driver is used
Date: Thu, 16 Aug 2012 01:27:35 +0530
Message-id: <1345060656-32201-4-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1345060656-32201-1-git-send-email-thomas.abraham@linaro.org>
References: <1345060656-32201-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t9jAV2T39oBBsvXMFpc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGV8f/uOreAGb8XMFfeZGxh7ubsYOTkkBEwknnzZxQJh
	i0lcuLeerYuRi0NIYBGjRPO+16wQThuTxO65rewgVWwCBhKPFr4Ds0UEFCQ29z4DK2IWOMEo
	cbvvJFhCWCBG4vrLWUA2BweLgKrE7RkZIGFeAU+J91//MkJsU5LY0HuUCcTmFPCS+DyzkxXE
	FgKqaWs/xzqBkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjGDvP5PawbiyweIQowAH
	oxIPL8NBrQAh1sSy4srcQ4wSHMxKIrw/TmkHCPGmJFZWpRblxxeV5qQWH2KU5mBREuc19v7q
	LySQnliSmp2aWpBaBJNl4uCUamAUf9gy5ULAnC9pSTOaZslujrR/nM9dYpb834L3B8/FzdZp
	Bs9EwtIUK2//P7bseuzPonUT2BSYnN4W3Zk8KU7hobLOrEApttDWbxzCu2dlCuZN+HxlWdO6
	wzWF1yymzNzRdDh+msbdX3Iz5aIDyi72xm84aP3Kf+JaH1VftsSypkX+yksffbJQYinOSDTU
	Yi4qTgQAvQMUCvoBAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pinctrl driver, when enabled, registers all the gpio pins and hence the
registration of gpio pins by this driver can be skipped.

Acked-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/gpio/gpio-samsung.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index 92f7b2b..8e61053 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -2734,6 +2734,27 @@ static __init void exynos4_gpiolib_init(void)
 	int group = 0;
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

