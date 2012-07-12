Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab2GLFmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 01:42:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36327 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab2GLFlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 01:41:20 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-05-4ffe637f27cc
From: Vivek Gautam <gautam.vivek@samsung.com>
To: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, jg1.han@samsung.com,
        jy0922.shim@samsung.com, sshtylyov@mvista.com, olofj@google.com
Subject: [PATCH 3/3 v2] USB: ehci-s5p: Add vbus setup function to the s5p ehci
 glue layer
Date: Thu, 12 Jul 2012 11:25:12 +0530
Message-id: <1342072512-29945-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1342072512-29945-1-git-send-email-gautam.vivek@samsung.com>
References: <1342072512-29945-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsVy+t9jQd365H/+Bu0bZCwu75rDZrFoWSuz
	A5PH501yAYxRXDYpqTmZZalF+nYJXBnX7z5kKzjBWzFr+RvmBsY13F2MnBwSAiYSvQ93M0LY
	YhIX7q1n62Lk4hASmM4ocXrLCXYIp51JYsOWJjaQKjYBXYmmt7vAOkQEaiWmXJ0KVsQscJZR
	omXuJBaQhLBAtMT+3fOZQGwWAVWJOQsfgTXzCnhInD17hhlinYJE67JD7CA2p4CnxKqbs8CG
	CgHVTN1+nnECI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMH+fya9g3FVg8UhRgEO
	RiUe3guR//yFWBPLiitzDzFKcDArifA6goR4UxIrq1KL8uOLSnNSiw8xSnOwKInzmnh/9RcS
	SE8sSc1OTS1ILYLJMnFwSjUwakxkyi043X+wS5w9KD1MPKjz0tl1wp8OXUya3DF3wzG1x62T
	5i/7d2ZbtYlouZzYqYzdKy9duCWxcKVEWOQb/rzD0royB079u8/HvCQpL0JEcY9A4bEwds5j
	LQ6LfoUVCBZ/CIpQFVufHyTu23lD6wLDzOTzBvzvNW5yy9d/ZI1IWfkvIqRCiaU4I9FQi7mo
	OBEAZFeNDfsBAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhilash Kesavan <a.kesavan@samsung.com>

This patch retrieves and configures the vbus control gpio via
the device tree. The suspend/resume callbacks will be later
modified for vbus control.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 52d0049..9f9870c 100644
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
 	s5p_ehci = kzalloc(sizeof(struct s5p_ehci_hcd), GFP_KERNEL);
 	if (!s5p_ehci)
 		return -ENOMEM;
-- 
1.7.0.4

