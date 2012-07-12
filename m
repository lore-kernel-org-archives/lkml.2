Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab2GLFlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 01:41:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36308 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab2GLFlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 01:41:17 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-fc-4ffe637c6f00
From: Vivek Gautam <gautam.vivek@samsung.com>
To: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, jg1.han@samsung.com,
        jy0922.shim@samsung.com, sshtylyov@mvista.com, olofj@google.com
Subject: [PATCH 2/3 v2] USB: ehci-s5p: Add support for device tree
Date: Thu, 12 Jul 2012 11:25:11 +0530
Message-id: <1342072512-29945-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1342072512-29945-1-git-send-email-gautam.vivek@samsung.com>
References: <1342072512-29945-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsVy+t9jQd2a5H/+BrO7LS0u75rDZrFoWSuz
	A5PH501yAYxRXDYpqTmZZalF+nYJXBkn5v1gL3gnUPH1/BmWBsYvvF2MnBwSAiYS586uY4Ww
	xSQu3FvP1sXIxSEkMJ1RYsGt2VBOO5NE57QOdpAqNgFdiaa3uxhBbBGBWokpV6eygxQxC5xl
	lGiZO4kFJCEs4CSx5OsBsLEsAqoSd16cA4vzCnhIfP92jglinYJE67JDYEM5BTwlVt2cBTZU
	CKhm6vbzjBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECPb/M+kdjKsaLA4xCnAw
	KvHwXoj85y/EmlhWXJl7iFGCg1lJhNcRJMSbklhZlVqUH19UmpNafIhRmoNFSZzXxPurv5BA
	emJJanZqakFqEUyWiYNTqoFRUbOhYKWD2PPuW7sml/QvtQhf3PjrwpoO27x24fNqp8rjLonZ
	H53x8ZtTz7TpTHduFRYW8zzQSVJfXCruPINV9ux+JoMXP7ynt7xyuuC5KGXTnST1HOctIT71
	Vyfu1Ip69zGofbly0cz4J8eOzCsxDd9TvlWlbeUlB+WnvVIfUufsMmWyvW+ixFKckWioxVxU
	nAgAs7hiefsBAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to parse probe data for
ehci driver for exynos using device tree

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index c474cec..52d0049 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <plat/ehci.h>
 #include <plat/usb-phy.h>
@@ -63,6 +64,8 @@ static const struct hc_driver s5p_ehci_hc_driver = {
 	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
 };
 
+static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);
+
 static int __devinit s5p_ehci_probe(struct platform_device *pdev)
 {
 	struct s5p_ehci_platdata *pdata;
@@ -79,6 +82,16 @@ static int __devinit s5p_ehci_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	/*
+	 * Right now device-tree probed devices don't get dma_mask set.
+	 * Since shared usb code relies on it, set it here for now.
+	 * Once we move to full device tree support this will vanish off.
+	 */
+	if (!pdev->dev.dma_mask)
+		pdev->dev.dma_mask = &ehci_s5p_dma_mask;
+	if (!pdev->dev.coherent_dma_mask)
+		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+
 	s5p_ehci = kzalloc(sizeof(struct s5p_ehci_hcd), GFP_KERNEL);
 	if (!s5p_ehci)
 		return -ENOMEM;
@@ -298,6 +311,14 @@ static int s5p_ehci_resume(struct device *dev)
 #define s5p_ehci_resume		NULL
 #endif
 
+#ifdef CONFIG_OF
+static const struct of_device_id exynos_ehci_match[] = {
+	{ .compatible = "samsung,exynos-ehci" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_ehci_match);
+#endif
+
 static const struct dev_pm_ops s5p_ehci_pm_ops = {
 	.suspend	= s5p_ehci_suspend,
 	.resume		= s5p_ehci_resume,
@@ -311,6 +332,7 @@ static struct platform_driver s5p_ehci_driver = {
 		.name	= "s5p-ehci",
 		.owner	= THIS_MODULE,
 		.pm	= &s5p_ehci_pm_ops,
+		.of_match_table = of_match_ptr(exynos_ehci_match),
 	}
 };
 
-- 
1.7.0.4

