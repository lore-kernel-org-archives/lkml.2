Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab2GPFn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 01:43:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:65167 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab2GPFnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 01:43:17 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-e2-5003a9f42987
From: Vivek Gautam <gautam.vivek@samsung.com>
To: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, olofj@google.com,
        thomas.abraham@linaro.org, sshtylyov@mvista.com,
        av.tikhomirov@samsung.com
Subject: [PATCH 1/2 v3] USB: dwc3-exynos: Add support for device tree
Date: Mon, 16 Jul 2012 11:27:38 +0530
Message-id: <1342418259-23802-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1342418259-23802-1-git-send-email-gautam.vivek@samsung.com>
References: <1342418259-23802-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t9jAd0vK5kDDA4e0rW4vGsOm8WiZa3M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW0rm5gLlggUNH3q7aBcSNvFyMnh4SAicTCa9eZIGwx
	iQv31rN1MXJxCAksYpT4/ugtM0hCSKCdSWLCYWUQm01AV6Lp7S5GEFtEoFZiytWp7CA2s8BV
	Rolvr0pBbGEBV4lvb36A1bAIqEocn94IVsMr4CHR+eEoM8QyBYnWZYfA4pwCnhJHD94BOoId
	aJeHxNOwCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEe/2Z9A7GVQ0WhxgFOBiV
	eHhvLGMOEGJNLCuuzD3EKMHBrCTC29kJFOJNSaysSi3Kjy8qzUktPsQozcGiJM5r4v3VX0gg
	PbEkNTs1tSC1CCbLxMEp1cCYLBQl5vn4c6ZjpWbDUo8b76fJHvB5VeyyzmfFWoULq3N4c08e
	PGCRsay7aZl+BJ8wS+FGt779V37J/K9xEjpavIZpQ2ytQgLXEXUl/R3KprwmwgucVG2KH29p
	jP0lI6U8W26fmunuXd8673Nzln1uaAvtF/D6r7Nur+an5KU8yzwNPE89FlViKc5INNRiLipO
	BAA0/oXE9gEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to parse probe data for
dwc3 driver for exynos using device tree

Signed-off-by: Praveen Paneri <p.paneri@samsung.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/dwc3/dwc3-exynos.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index b8f0038..a293c69 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -19,6 +19,7 @@
 #include <linux/platform_data/dwc3-exynos.h>
 #include <linux/dma-mapping.h>
 #include <linux/clk.h>
+#include <linux/of.h>
 
 #include "core.h"
 
@@ -29,6 +30,8 @@ struct dwc3_exynos {
 	struct clk		*clk;
 };
 
+static u64 dwc3_exynos_dma_mask = DMA_BIT_MASK(32);
+
 static int __devinit dwc3_exynos_probe(struct platform_device *pdev)
 {
 	struct dwc3_exynos_data	*pdata = pdev->dev.platform_data;
@@ -45,6 +48,16 @@ static int __devinit dwc3_exynos_probe(struct platform_device *pdev)
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
@@ -134,11 +147,20 @@ static int __devexit dwc3_exynos_remove(struct platform_device *pdev)
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

