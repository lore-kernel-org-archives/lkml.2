Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab2GLFmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 01:42:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:37136 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab2GLFlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 01:41:15 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-e5-4ffe637a9365
From: Vivek Gautam <gautam.vivek@samsung.com>
To: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, jg1.han@samsung.com,
        jy0922.shim@samsung.com, sshtylyov@mvista.com, olofj@google.com
Subject: [PATCH 1/3 v2] USB: ohci-exynos: Add support for device tree
Date: Thu, 12 Jul 2012 11:25:10 +0530
Message-id: <1342072512-29945-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1342072512-29945-1-git-send-email-gautam.vivek@samsung.com>
References: <1342072512-29945-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t9jQd2q5H/+Bt1rJC0u75rDZrFoWSuz
	A5PH501yAYxRXDYpqTmZZalF+nYJXBldXz0KlgtWXN65n6mBcRVfFyMnh4SAicSBnT8YIWwx
	iQv31rN1MXJxCAlMZ5S4+P8UE4TTziRx8vsiNpAqNgFdiaa3u8A6RARqJaZcncoOUsQscJZR
	omXuJBaQhLCAq0TbrzdgNouAqkT3o8VgzbwCHhIPJu1hg1inING67BA7iM0p4Cmx6uYssKFC
	QDVTt59nnMDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGsPefSe1gXNlgcYhRgINR
	iYf3YuQ/fyHWxLLiytxDjBIczEoivI4gId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzG3l/9hQTS
	E0tSs1NTC1KLYLJMHJxSDYwMzwUFjjhE2yYvnnj13V6pWX/8f8keS07Xiu64+XhVqcyD3foz
	WM+cv8KhVMT2rrtsctJOhYsB2+7MmLusKG2Zb2v0SeOlL9kkLYI3Fbbqh21d4cX+VnXlPd9i
	vc13Z86Rd/Y2Wd1levy8ywbBxKCFWbVCS1nXJiWtlOWVtHOdlfTRZVm+loYSS3FGoqEWc1Fx
	IgDwKelv+gEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to parse probe data for
ohci driver for exynos using device tree.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index 2909621..c4ad60f 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <mach/ohci.h>
 #include <plat/usb-phy.h>
@@ -71,6 +72,8 @@ static const struct hc_driver exynos_ohci_hc_driver = {
 	.start_port_reset	= ohci_start_port_reset,
 };
 
+static u64 ohci_exynos_dma_mask = DMA_BIT_MASK(32);
+
 static int __devinit exynos_ohci_probe(struct platform_device *pdev)
 {
 	struct exynos4_ohci_platdata *pdata;
@@ -87,6 +90,16 @@ static int __devinit exynos_ohci_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	/*
+	 * Right now device-tree probed devices don't get dma_mask set.
+	 * Since shared usb code relies on it, set it here for now.
+	 * Once we move to full device tree support this will vanish off.
+	 */
+	if (!pdev->dev.dma_mask)
+		pdev->dev.dma_mask = &ohci_exynos_dma_mask;
+	if (!pdev->dev.coherent_dma_mask)
+		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+
 	exynos_ohci = kzalloc(sizeof(struct exynos_ohci_hcd), GFP_KERNEL);
 	if (!exynos_ohci)
 		return -ENOMEM;
@@ -258,6 +271,14 @@ static const struct dev_pm_ops exynos_ohci_pm_ops = {
 	.resume		= exynos_ohci_resume,
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id exynos_ohci_match[] = {
+	{ .compatible = "samsung,exynos-ohci" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_ohci_match);
+#endif
+
 static struct platform_driver exynos_ohci_driver = {
 	.probe		= exynos_ohci_probe,
 	.remove		= __devexit_p(exynos_ohci_remove),
@@ -266,6 +287,7 @@ static struct platform_driver exynos_ohci_driver = {
 		.name	= "exynos-ohci",
 		.owner	= THIS_MODULE,
 		.pm	= &exynos_ohci_pm_ops,
+		.of_match_table	= of_match_ptr(exynos_ohci_match),
 	}
 };
 
-- 
1.7.0.4

