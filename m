Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab2GPFlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 01:41:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64224 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab2GPFlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 01:41:20 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-0b-5003a97ee59d
From: Vivek Gautam <gautam.vivek@samsung.com>
To: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, olofj@google.com,
        jg1.han@samsung.com, jy0922.shim@samsung.com,
        thomas.abraham@linaro.org, sshtylyov@mvista.com
Subject: [PATCH 2/3 v3] USB: ehci-s5p: Add support for device tree
Date: Mon, 16 Jul 2012 11:25:37 +0530
Message-id: <1342418138-6192-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1342418138-6192-1-git-send-email-gautam.vivek@samsung.com>
References: <1342418138-6192-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t9jAd36lcwBBmeeMVpc3jWHzWLRslZm
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDImHJzHWPBToOL12d+MDYy/ebsYOTkkBEwkunY+Zoew
	xSQu3FvP1sXIxSEksIhRYsvWP+wQTjuTxMfln9hAqtgEdCWa3u5iBLFFBGolplydCtbNLPCK
	UaLzsiqILSzgJPFi3UfWLkYODhYBVYndHWogYV4Bd4m1lxqZIZYpSLQuOwTWyingIbF84kyw
	uBBQzdJ57WwTGHkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAj2/TPpHYyrGiwOMQpw
	MCrx8N5YxhwgxJpYVlyZe4hRgoNZSYS3sxMoxJuSWFmVWpQfX1Sak1p8iFGag0VJnNfE+6u/
	kEB6YklqdmpqQWoRTJaJg1OqgdFWyOP0nHtRDx98fvStyij4YOrVx+md4V6/dCufNExewMet
	tvCr1vyXuuqfZV5e7SpYf1g9R+1g/KG4Rofz0698NFt4yuLPM9fjsvuOdwQcezrHv1HF64Pi
	bUnzLe+yaqNEdhib+r1ddeSGfumiJR1nFAwY33gueTXxwoWb0lzMyvzCn70+zNijxFKckWio
	xVxUnAgAXgPn4fkBAAA=
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
index 13c179f..37d84cf 100644
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
 	s5p_ehci = devm_kzalloc(&pdev->dev, sizeof(struct s5p_ehci_hcd),
 				GFP_KERNEL);
 	if (!s5p_ehci)
@@ -233,6 +246,14 @@ static const struct dev_pm_ops s5p_ehci_pm_ops = {
 	.resume		= s5p_ehci_resume,
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id exynos_ehci_match[] = {
+	{ .compatible = "samsung,exynos-ehci" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_ehci_match);
+#endif
+
 static struct platform_driver s5p_ehci_driver = {
 	.probe		= s5p_ehci_probe,
 	.remove		= __devexit_p(s5p_ehci_remove),
@@ -241,6 +262,7 @@ static struct platform_driver s5p_ehci_driver = {
 		.name	= "s5p-ehci",
 		.owner	= THIS_MODULE,
 		.pm	= &s5p_ehci_pm_ops,
+		.of_match_table = of_match_ptr(exynos_ehci_match),
 	}
 };
 
-- 
1.7.0.4

