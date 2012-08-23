Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030500Ab2HWK67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:58:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13174 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030431Ab2HWK6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:58:08 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-e8-50360cbc3321
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com,
        dong.aisheng@linaro.org, swarren@wwwdotorg.org, patches@linaro.org
Subject: [PATCH v3 4/4] ARM: EXYNOS: skip wakeup interrupt setup if pinctrl
 driver is used
Date: Thu, 23 Aug 2012 16:45:29 +0530
Message-id: <1345720529-32315-5-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1345720529-32315-1-git-send-email-thomas.abraham@linaro.org>
References: <1345720529-32315-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsVy+t9jQd09PGYBBtNXKFhc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGUcPrKUseAFX8XpH0+ZGhhn8XQxcnJICJhIbLq9lxHC
	FpO4cG89WxcjF4eQwHRGifmHm9ghnDYmiYmnt7KBVLEJGEg8WviOHcQWEXCVOP7iLCNIEbPA
	L0aJ11s2MYEkhAViJPbMegk2lkVAVWLV0m/MIDavgKfEwq5nzBDrlCQ29B4Fq+cU8JLY9XUV
	WFwIqGb11nMsExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQI9v8zqR2MKxssDjEK
	cDAq8fBmxJoGCLEmlhVX5h5ilOBgVhLh9eI0CxDiTUmsrEotyo8vKs1JLT7EKM3BoiTOy99n
	GCAkkJ5YkpqdmlqQWgSTZeLglGpg1Fs+/bPHnFt71sz/Gfvy/EpHT8udprwTcz491Yrvu9Y0
	ZfLuCxKagcsn+/JpxaYy2LwSCd6+XmltZcaKREaDDtnp+/dz9ootrls2iXNH+RyDVq5Ph7a2
	/9x8iGXyp/p5da4Jl7l3KOZc1tif13y6+4Smx1mGFJP+10ckjFZb1gfFta3fsy/mmBJLcUai
	oRZzUXEiAButdYL7AQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pinctrl driver includes support for configuring the external wakeup
interrupts. On exynos platforms that use pinctrl driver, the setup
of wakeup interrupts in the exynos platform code can be skipped.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 arch/arm/mach-exynos/common.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index 4eb39cd..715b690 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -980,6 +980,32 @@ static int __init exynos_init_irq_eint(void)
 {
 	int irq;
 
+#ifdef CONFIG_PINCTRL_SAMSUNG
+	/*
+	 * The Samsung pinctrl driver provides an integrated gpio/pinmux/pinconf
+	 * functionality along with support for external gpio and wakeup
+	 * interrupts. If the samsung pinctrl driver is enabled and includes
+	 * the wakeup interrupt support, then the setting up external wakeup
+	 * interrupts here can be skipped. This check here is temporary to
+	 * allow exynos4 platforms that do not use Samsung pinctrl driver to
+	 * co-exist with platforms that do. When all of the Samsung Exynos4
+	 * platforms switch over to using the pinctrl driver, the wakeup
+	 * interrupt support code here can be completely removed.
+	 */
+	struct device_node *pctrl_np, *wkup_np;
+	const char *pctrl_compat = "samsung,pinctrl-exynos4210";
+	const char *wkup_compat = "samsung,exynos4210-wakeup-eint";
+
+	for_each_compatible_node(pctrl_np, NULL, pctrl_compat) {
+		if (of_device_is_available(pctrl_np)) {
+			wkup_np = of_find_compatible_node(pctrl_np, NULL,
+							wkup_compat);
+			if (wkup_np)
+				return -ENODEV;
+		}
+	}
+#endif
+
 	if (soc_is_exynos5250())
 		exynos_eint_base = ioremap(EXYNOS5_PA_GPIO1, SZ_4K);
 	else
-- 
1.6.6.rc2

