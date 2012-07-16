Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2GPFlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 01:41:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24970 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2GPFlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 01:41:22 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-20-5003a981fa4e
From: Vivek Gautam <gautam.vivek@samsung.com>
To: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, olofj@google.com,
        jg1.han@samsung.com, jy0922.shim@samsung.com,
        thomas.abraham@linaro.org, sshtylyov@mvista.com
Subject: [PATCH 3/3 v3] USB: ehci-s5p: Add vbus setup function to the s5p ehci
 glue layer
Date: Mon, 16 Jul 2012 11:25:38 +0530
Message-id: <1342418138-6192-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1342418138-6192-1-git-send-email-gautam.vivek@samsung.com>
References: <1342418138-6192-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t9jAd3GlcwBBseP6ltc3jWHzWLRslZm
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDIWX5/GXDCTt+Lxi4VsDYzN3F2MnBwSAiYSr6dPYYOw
	xSQu3FsPZHNxCAksYpRoW3mRGcJpZ5I4eGg3E0gVm4CuRNPbXYwgtohArcSUq1PZQWxmgVeM
	Ep2XVUFsYYFoiaVTjjCD2CwCqhJTL/8HmsrBwSvgLvFjcjXEMgWJ1mWHwFo5BTwklk+cCVYu
	BFSydF472wRG3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgn3/THoH46oGi0OMAhyM
	Sjy8N5YxBwixJpYVV+YeYpTgYFYS4e3sBArxpiRWVqUW5ccXleakFh9ilOZgURLnNfH+6i8k
	kJ5YkpqdmlqQWgSTZeLglGpgnLDIapLHQ75zjTy7grKubOT/a7/P6dnWE+qa5vtMjeRD1n5P
	NxXo7eO4LbdbUm5br2HxJHtfz9pp/xhtersTNOYU3/D6kNzpd11kbtXi6Yu3lt4obYhkv7c6
	5MQd2WXO8w+dUvB65HjusfM6xbbCG88uJ+2yE707W+ygQOd90f8N1yL+L6uqVGIpzkg01GIu
	Kk4EAByzu4z5AQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch retrieves and configures the vbus control gpio via
the device tree. The suspend/resume callbacks will be later
modified for vbus control.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 37d84cf..4037878 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -15,6 +15,7 @@
 #include <linux/clk.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/of_gpio.h>
 #include <plat/ehci.h>
 #include <plat/usb-phy.h>
 
@@ -64,6 +65,28 @@ static const struct hc_driver s5p_ehci_hc_driver = {
 	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
 };
 
+static int s5p_ehci_setup_gpio(struct platform_device *pdev)
+{
+	int err;
+	int gpio;
+
+	if (!pdev->dev.of_node)
+		return 0;
+
+	gpio = of_get_named_gpio(pdev->dev.of_node,
+			"samsung,vbus-gpio", 0);
+	if (!gpio_is_valid(gpio))
+		return 0;
+
+	err = gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "ehci_vbus_gpio");
+	if (err) {
+		dev_err(&pdev->dev, "can't request ehci vbus gpio %d", gpio);
+		return err;
+	}
+
+	return err;
+}
+
 static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);
 
 static int __devinit s5p_ehci_probe(struct platform_device *pdev)
@@ -92,6 +115,8 @@ static int __devinit s5p_ehci_probe(struct platform_device *pdev)
 	if (!pdev->dev.coherent_dma_mask)
 		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 
+	s5p_ehci_setup_gpio(pdev);
+
 	s5p_ehci = devm_kzalloc(&pdev->dev, sizeof(struct s5p_ehci_hcd),
 				GFP_KERNEL);
 	if (!s5p_ehci)
-- 
1.7.0.4

