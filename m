Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab2HOTlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:41:06 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26030 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab2HOTki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:40:38 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-0d-502bfb3584d8
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH v2 4/4] ARM: EXYNOS: skip wakeup interrupt setup if pinctrl
 driver is used
Date: Thu, 16 Aug 2012 01:27:36 +0530
Message-id: <1345060656-32201-5-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1345060656-32201-1-git-send-email-thomas.abraham@linaro.org>
References: <1345060656-32201-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t9jAV3T39oBBk3rVS0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJ6j3WyFNzmq7j50b+BsZeni5GTQ0LARGLenefMELaY
	xIV769lAbCGBRYwS6w5zdjFyAdltTBI7PuxiAUmwCRhIPFr4jh3EFhFQkNjc+4wVpIhZ4ASj
	xO2+k2AJYYEYifeHGsBsFgFVibm921lBbF4BT4lL0zuZILYpSWzoPQpmcwp4SXye2ckKsdlT
	oq39HOsERt4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYJ9/0xqB+PKBotDjAIcjEo8
	vAwHtQKEWBPLiitzDzFKcDArifD+OKUdIMSbklhZlVqUH19UmpNafIhRmoNFSZzX2Purv5BA
	emJJanZqakFqEUyWiYNTqoGRk3mC+SOBs5c22vb9Ofd53Vaxs2uPxTootaiH9YRF/mNi6PTw
	djQ9Nvlx1itn23dfb86w23Zpcn+Ea8zvRsVtIb+ucCoym+WcOhxp1r23h/XWw6NuHAoikosV
	c/W2LdvHzCq0/KRjgn+o8qYq16m3yiZVPGOb/8k8O6PvdcaMaJ9Ny86ErNRRYinOSDTUYi4q
	TgQAiG4b6vkBAAA=
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
index 4eb39cd..ea3a85a 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -980,6 +980,32 @@ static int __init exynos_init_irq_eint(void)
 {
 	int irq;
 
+#ifdef CONFIG_OF
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

