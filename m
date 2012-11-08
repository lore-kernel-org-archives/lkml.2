Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab2KHPIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:08:12 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37008 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab2KHPIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:08:10 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Amardeep Rai <amardeep.rai-ext@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] usb: spear-ehci/ohci: Do clk_get using dev-id
Date: Thu,  8 Nov 2012 20:37:58 +0530
Message-Id: <19a629d4f79bb0a5904588ee7f546c461e8be6c4.1352387166.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amardeep Rai <amardeep.rai-ext@st.com>

We used to get clk using con-id, but now we have device struct available for
these devices as they are probed using DT. And so must get clk using dev-id.

Signed-off-by: Amardeep Rai <amardeep.rai-ext@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/usb/host/ehci-spear.c | 13 +------------
 drivers/usb/host/ohci-spear.c | 13 +------------
 2 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/host/ehci-spear.c b/drivers/usb/host/ehci-spear.c
index 719ca48..d08506a 100644
--- a/drivers/usb/host/ehci-spear.c
+++ b/drivers/usb/host/ehci-spear.c
@@ -109,8 +109,6 @@ static int spear_ehci_hcd_drv_probe(struct platform_device *pdev)
 	struct clk *usbh_clk;
 	const struct hc_driver *driver = &ehci_spear_hc_driver;
 	int irq, retval;
-	char clk_name[20] = "usbh_clk";
-	static int instance = -1;
 
 	if (usb_disabled())
 		return -ENODEV;
@@ -129,16 +127,7 @@ static int spear_ehci_hcd_drv_probe(struct platform_device *pdev)
 	if (!pdev->dev.dma_mask)
 		pdev->dev.dma_mask = &spear_ehci_dma_mask;
 
-	/*
-	 * Increment the device instance, when probing via device-tree
-	 */
-	if (pdev->id < 0)
-		instance++;
-	else
-		instance = pdev->id;
-	sprintf(clk_name, "usbh.%01d_clk", instance);
-
-	usbh_clk = clk_get(NULL, clk_name);
+	usbh_clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(usbh_clk)) {
 		dev_err(&pdev->dev, "Error getting interface clock\n");
 		retval = PTR_ERR(usbh_clk);
diff --git a/drivers/usb/host/ohci-spear.c b/drivers/usb/host/ohci-spear.c
index d607be3..9747708 100644
--- a/drivers/usb/host/ohci-spear.c
+++ b/drivers/usb/host/ohci-spear.c
@@ -101,8 +101,6 @@ static int spear_ohci_hcd_drv_probe(struct platform_device *pdev)
 	struct spear_ohci *ohci_p;
 	struct resource *res;
 	int retval, irq;
-	char clk_name[20] = "usbh_clk";
-	static int instance = -1;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
@@ -118,16 +116,7 @@ static int spear_ohci_hcd_drv_probe(struct platform_device *pdev)
 	if (!pdev->dev.dma_mask)
 		pdev->dev.dma_mask = &spear_ohci_dma_mask;
 
-	/*
-	 * Increment the device instance, when probing via device-tree
-	 */
-	if (pdev->id < 0)
-		instance++;
-	else
-		instance = pdev->id;
-	sprintf(clk_name, "usbh.%01d_clk", instance);
-
-	usbh_clk = clk_get(NULL, clk_name);
+	usbh_clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(usbh_clk)) {
 		dev_err(&pdev->dev, "Error getting interface clock\n");
 		retval = PTR_ERR(usbh_clk);
-- 
1.7.12.rc2.18.g61b472e

