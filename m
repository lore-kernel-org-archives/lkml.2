Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab2GPFla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 01:41:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64189 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab2GPFlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 01:41:17 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-27-5003a97c142c
From: Vivek Gautam <gautam.vivek@samsung.com>
To: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, olofj@google.com,
        jg1.han@samsung.com, jy0922.shim@samsung.com,
        thomas.abraham@linaro.org, sshtylyov@mvista.com
Subject: [PATCH 1/3 v3] USB: ohci-exynos: Add support for device tree
Date: Mon, 16 Jul 2012 11:25:36 +0530
Message-id: <1342418138-6192-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1342418138-6192-1-git-send-email-gautam.vivek@samsung.com>
References: <1342418138-6192-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t9jAd2alcwBBhfmi1hc3jWHzWLRslZm
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDL2/9vKVLBasOJ2y2emBsY1fF2MnBwSAiYSp5vPMkLY
	YhIX7q1n62Lk4hASWMQocf/CEbCEkEA7k8Tueb4gNpuArkTT211gcRGBWokpV6eyg9jMAq8Y
	JTovq4LYwgKuErN7u1lAbBYBVYkvjd+YQGxeAXeJdfNOMUEsU5BoXXYIrJdTwENi+cSZzBC7
	3CWWzmtnm8DIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGsO+fSe1gXNlgcYhRgINR
	iYfXABgSQqyJZcWVuYcYJTiYlUR4OzuBQrwpiZVVqUX58UWlOanFhxilOViUxHmNvb/6Cwmk
	J5akZqemFqQWwWSZODilGhjPeP9Wu1WZ8nVl04uMWQdLON7w37nvWr7o2yWpR49+TDtYprD4
	3r5QF94atavCUuX/50RcnBE+cfaClWkvfta7z/e/sJDD/MyX39d8ApVWZAT5up6Jvz4jaPFN
	5p+pnB7sEhEPtI6zTBYTbVrQeVXsTf0cU+OTxSlNr9zeyW6c13dgS96y6w96lFiKMxINtZiL
	ihMB3odAgfkBAAA=
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
index 8bcbdb5..fc3091b 100644
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
 	exynos_ohci = devm_kzalloc(&pdev->dev, sizeof(struct exynos_ohci_hcd),
 					GFP_KERNEL);
 	if (!exynos_ohci)
@@ -256,6 +269,14 @@ static const struct dev_pm_ops exynos_ohci_pm_ops = {
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
@@ -264,6 +285,7 @@ static struct platform_driver exynos_ohci_driver = {
 		.name	= "exynos-ohci",
 		.owner	= THIS_MODULE,
 		.pm	= &exynos_ohci_pm_ops,
+		.of_match_table	= of_match_ptr(exynos_ohci_match),
 	}
 };
 
-- 
1.7.0.4

