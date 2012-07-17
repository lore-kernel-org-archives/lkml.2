Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab2GQE0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 00:26:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42467 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab2GQE01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 00:26:27 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-64-5004e9712012
From: Vivek Gautam <gautam.vivek@samsung.com>
To: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, olofj@google.com,
        thomas.abraham@linaro.org, sshtylyov@mvista.com,
        av.tikhomirov@samsung.com
Subject: [PATCH v4] USB: ehci-s5p: Add vbus setup function to the s5p ehci glue
 layer
Date: Tue, 17 Jul 2012 10:10:50 +0530
Message-id: <1342500050-27470-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1342500050-27470-1-git-send-email-gautam.vivek@samsung.com>
References: <1342500050-27470-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJMWRmVeSWpSXmKPExsVy+t9jQd3ClywBBudmaltc3jWHzWLRslZm
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKmTJ/BVvCQt2L9Vc8GxpPcXYycHBICJhKrD75kgrDF
	JC7cW8/WxcjFISQwnVGic8EzJginnUni9pN5LCBVbAK6Ek1vdzGC2CICtRJTrk5lB7GZBa4y
	Snx7VQpiCwuES9z6dBGsnkVAVeLxzFlgG3gFPCROnfjBCrFNQaJ12SGgXg4OTgFPiU3/jEBM
	IaCSv6eCJzDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kR7PdnUjsYVzZYHGIU4GBU
	4uGd8ZQlQIg1say4MvcQowQHs5IIr8hRoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFeY++v/kIC
	6YklqdmpqQWpRTBZJg5OqQbG0sO3e079EtO0FnSMeix85mWExr2Sldbrw28reWoJ2Apm8z46
	9PtUYG2oj1KkGqfBrPXruafPDeq4zWj/5Y8Tq22ky95Pc2S7nm7+/7DmLm/h6dhV5bEVcmkL
	LOanBr5lm1iexTK9vGg976Hbaidj+ZesUrufPuX4+iO770pyRqhNmiOfLaWsxFKckWioxVxU
	nAgAYjC5R/cBAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch retrieves and configures the vbus control gpio via
the device tree. The suspend/resume callbacks will be later
modified for vbus control.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/host/ehci-s5p.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 37d84cf..9d8f1dd 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -15,6 +15,7 @@
 #include <linux/clk.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/of_gpio.h>
 #include <plat/ehci.h>
 #include <plat/usb-phy.h>
 
@@ -64,6 +65,24 @@ static const struct hc_driver s5p_ehci_hc_driver = {
 	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
 };
 
+static void s5p_setup_vbus_gpio(struct platform_device *pdev)
+{
+	int err;
+	int gpio;
+
+	if (!pdev->dev.of_node)
+		return;
+
+	gpio = of_get_named_gpio(pdev->dev.of_node,
+			"samsung,vbus-gpio", 0);
+	if (!gpio_is_valid(gpio))
+		return;
+
+	err = gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "ehci_vbus_gpio");
+	if (err)
+		dev_err(&pdev->dev, "can't request ehci vbus gpio %d", gpio);
+}
+
 static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);
 
 static int __devinit s5p_ehci_probe(struct platform_device *pdev)
@@ -92,6 +111,8 @@ static int __devinit s5p_ehci_probe(struct platform_device *pdev)
 	if (!pdev->dev.coherent_dma_mask)
 		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 
+	s5p_setup_vbus_gpio(pdev);
+
 	s5p_ehci = devm_kzalloc(&pdev->dev, sizeof(struct s5p_ehci_hcd),
 				GFP_KERNEL);
 	if (!s5p_ehci)
-- 
1.7.0.4

