Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab2GLFqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 01:46:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38597 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab2GLFp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 01:45:59 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-b9-4ffe64959786
From: Vivek Gautam <gautam.vivek@samsung.com>
To: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, jg1.han@samsung.com,
        jy0922.shim@samsung.com, sshtylyov@mvista.com, olofj@google.com
Subject: [PATCH 1/2 v2] USB: dwc3-exynos: Add support for device tree
Date: Thu, 12 Jul 2012 11:30:02 +0530
Message-id: <1342072803-15939-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1342072803-15939-1-git-send-email-gautam.vivek@samsung.com>
References: <1342072803-15939-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t9jAd2pKf/8DVaflrK4vGsOm8WiZa3M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXsXbycqWAqf8WaswsYGxh38nQxcnBICJhIbD/s0MXI
	CWSKSVy4t56ti5GLQ0hgEaPEkRnXWSCcdiaJBas2sIJUsQnoSjS93cUIYosI1EpMuTqVHaSI
	WeAso0TL3EksIFOFBVwlFt8XBKlhEVCVuHX5OTtImFfAQ+L+AQGIZQoSrcsOsYPYnAKeEifO
	d4DZQkAlu/pvME1g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTI9jzz6R3MK5qsDjE
	KMDBqMTDeyHyn78Qa2JZcWXuIUYJDmYlEV5HkBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFeE++v
	/kIC6YklqdmpqQWpRTBZJg5OqQZGz8pTuwRzzCeyu96a7SX6fILyna58/2WHr8uzGHip6O+e
	yT1L+0mcUttL4Wyn2JNSXsZB1xezvir5JXjDUPtH80m5dPWNMwWU2Ob0lc+b3Pj65Yk50YKH
	3j3cG3P1XNm+OPXEJQxVG8oiGxtiC/rWrU+PrHbcsaxx13L51k9feWcbGtvcsUhQYinOSDTU
	Yi4qTgQAx3RHofgBAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to parse probe data for
dwc3 driver for exynos using device tree

Signed-off-by: Praveen Paneri <p.paneri@samsung.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index d190301..9ae91b7 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -20,6 +20,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/clk.h>
+#include <linux/of.h>
 
 #include "core.h"
 
@@ -30,6 +31,8 @@ struct dwc3_exynos {
 	struct clk		*clk;
 };
 
+static u64 dwc3_exynos_dma_mask = DMA_BIT_MASK(32);
+
 static int __devinit dwc3_exynos_probe(struct platform_device *pdev)
 {
 	struct dwc3_exynos_data	*pdata = pdev->dev.platform_data;
@@ -46,6 +49,16 @@ static int __devinit dwc3_exynos_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
+	/*
+	 * Right now device-tree probed devices don't get dma_mask set.
+	 * Since shared usb code relies on it, set it here for now.
+	 * Once we move to full device tree support this will vanish off.
+	 */
+	if (!pdev->dev.dma_mask)
+		pdev->dev.dma_mask = &dwc3_exynos_dma_mask;
+	if (!pdev->dev.coherent_dma_mask)
+		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+
 	platform_set_drvdata(pdev, exynos);
 
 	devid = dwc3_get_device_id();
@@ -135,11 +148,20 @@ static int __devexit dwc3_exynos_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id exynos_xhci_match[] = {
+	{ .compatible = "samsung,exynos-xhci" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_xhci_match);
+#endif
+
 static struct platform_driver dwc3_exynos_driver = {
 	.probe		= dwc3_exynos_probe,
 	.remove		= __devexit_p(dwc3_exynos_remove),
 	.driver		= {
 		.name	= "exynos-dwc3",
+		.of_match_table = of_match_ptr(exynos_xhci_match),
 	},
 };
 
-- 
1.7.0.4

