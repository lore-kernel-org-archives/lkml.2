Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab2GQKtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:49:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33149 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab2GQKtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:49:05 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-35-500543208431
From: Vivek Gautam <gautam.vivek@samsung.com>
To: greg@kroah.com, stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, olofj@google.com,
        thomas.abraham@linaro.org, sshtylyov@mvista.com,
        jy0922.shim@samsung.com, jg1.han@samsung.com
Subject: [PATCH RESEND v4] USB: ehci-s5p: Add vbus setup function to the s5p
 ehci glue layer
Date: Tue, 17 Jul 2012 16:33:26 +0530
Message-id: <1342523006-8379-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1342523006-8379-1-git-send-email-gautam.vivek@samsung.com>
References: <1342523006-8379-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t9jAV0FZ9YAg3ctmhaXd81hs1i0rJXZ
	gcnj8ya5AMYoLpuU1JzMstQifbsErowp02ewFTzkrVh/1bOB8SR3FyMnh4SAicTPZx8ZIWwx
	iQv31rN1MXJxCAksYpTY1HaJFcJpZ5K4+GMNK0gVm4CuRNPbXWAdIgK9jBInur1BipgFXjFK
	zPvYA1YkLBAncerpfxYQm0VAVeLc3XfsIDavgLvEw9YOFoh1ChKtyw6BxTkFPCR2XLkNZHMA
	bXOX+POQcQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwb5/JrWDcWWDxSFGAQ5G
	JR7eBeasAUKsiWXFlbmHGCU4mJVEeFebAIV4UxIrq1KL8uOLSnNSiw8xSnOwKInzGnt/9RcS
	SE8sSc1OTS1ILYLJMnFwSjUwHtMwkpDZx/LH8u3qZLml15Yu0nX/ZeY9SZch3exYROy651d5
	75wxW68a37NoUqlQu0IIK8NN52W7J4Ss8LopKLgk/YjIzT/Ljqs3yLxW/MDcPNdQlzVq1UOp
	BM8wpu7np+riebsuZxl1LRB8pfVC/MhiF8mXm6dPmx1g+Tpmt1vGlB3qF1JKlViKMxINtZiL
	ihMBaMvNSfkBAAA=
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

