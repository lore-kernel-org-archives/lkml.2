Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab2GLFqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 01:46:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38597 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab2GLFqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 01:46:00 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-d1-4ffe64979b45
From: Vivek Gautam <gautam.vivek@samsung.com>
To: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, jg1.han@samsung.com,
        jy0922.shim@samsung.com, sshtylyov@mvista.com, olofj@google.com
Subject: [PATCH 2/2 v2] USB: dwc3-exynos: Add vbus setup function to the exynos
 dwc3 glue layer
Date: Thu, 12 Jul 2012 11:30:03 +0530
Message-id: <1342072803-15939-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1342072803-15939-1-git-send-email-gautam.vivek@samsung.com>
References: <1342072803-15939-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsVy+t9jAd3pKf/8DRYvs7K4vGsOm8WiZa3M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXceHyVveAKT0X3ruWMDYwHuLoYOTkkBEwkWg4vZIGw
	xSQu3FvP1sXIxSEksIhRYu29qUwQTjuTxLaTM8Gq2AR0JZre7mIEsUUEaiWmXJ3KDlLELHCW
	UaJl7iSwImGBRIlrZz6B2SwCqhLPTj1mA7F5BTwkJu5bBrVOQaJ12SF2EJtTwFPixPkOMFsI
	qGZX/w2mCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIE+/+Z9A7GVQ0WhxgFOBiV
	eHgvRP7zF2JNLCuuzD3EKMHBrCTC6wgS4k1JrKxKLcqPLyrNSS0+xCjNwaIkzmvi/dVfSCA9
	sSQ1OzW1ILUIJsvEwSnVwNj4Vl59bvX8S5vsL0ruYF+r+06b3WyuzqfifS88eZtki33TT69Q
	uMibsWr1d95jVQ0/Sg4FWuT8TC4MzV2nJXjWcfNtjuNnl+nV7ZJkrPB6w1tc2R3XIaGw72H8
	lsjKlgnX0248Vvh/S1n8dd2tL3Zu11dfOcw6ufNUnnt7SxW/V7/ctb1yh5RYijMSDbWYi4oT
	AQJ3z+j7AQAA
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

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index 9ae91b7..5dd87c1 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/clk.h>
 #include <linux/of.h>
+#include <linux/of_gpio.h>
 
 #include "core.h"
 
@@ -31,6 +32,28 @@ struct dwc3_exynos {
 	struct clk		*clk;
 };
 
+static int dwc3_setup_vbus_gpio(struct platform_device *pdev)
+{
+	int err;
+	int gpio;
+
+	if (!pdev->dev.of_node)
+		return 0;
+
+	gpio = of_get_named_gpio(pdev->dev.of_node,
+				"samsung,vbus-gpio", 0);
+	if (!gpio_is_valid(gpio))
+		return 0;
+
+	err = gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "dwc3_vbus_gpio");
+	if (err) {
+		dev_err(&pdev->dev, "can't request dwc3 vbus gpio %d", gpio);
+		return err;
+	}
+
+	return err;
+}
+
 static u64 dwc3_exynos_dma_mask = DMA_BIT_MASK(32);
 
 static int __devinit dwc3_exynos_probe(struct platform_device *pdev)
@@ -59,6 +82,8 @@ static int __devinit dwc3_exynos_probe(struct platform_device *pdev)
 	if (!pdev->dev.coherent_dma_mask)
 		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 
+	dwc3_setup_vbus_gpio(pdev);
+
 	platform_set_drvdata(pdev, exynos);
 
 	devid = dwc3_get_device_id();
-- 
1.7.0.4

