Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab2G2TrZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 15:47:25 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:44777 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753492Ab2G2Tq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 15:46:28 -0400
X-IronPort-AV: E=Sophos;i="4.77,675,1336341600"; 
   d="scan'208";a="168487769"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] drivers/usb/host/ehci-mxc.c: use devm_ functions
Date: Sun, 29 Jul 2012 21:46:13 +0200
Message-Id: <1343591173-2819-10-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1343591173-2819-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1343591173-2819-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not compiled.

 drivers/usb/host/ehci-mxc.c |   45 +++++++++-----------------------------------
 1 file changed, 10 insertions(+), 35 deletions(-)

diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
index 3420137..959e1a4 100644
--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -121,7 +121,7 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
 	if (!hcd)
 		return -ENOMEM;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
 		ret = -ENOMEM;
 		goto err_alloc;
@@ -131,34 +131,28 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
 	if (!res) {
 		dev_err(dev, "Found HC with no register addr. Check setup!\n");
 		ret = -ENODEV;
-		goto err_get_resource;
+		goto err_alloc;
 	}
 
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		dev_dbg(dev, "controller already in use\n");
-		ret = -EBUSY;
-		goto err_request_mem;
-	}
-
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
+	hcd->regs = devm_request_and_ioremap(&pdev->dev, res);
 	if (!hcd->regs) {
 		dev_err(dev, "error mapping memory\n");
 		ret = -EFAULT;
-		goto err_ioremap;
+		goto err_alloc;
 	}
 
 	/* enable clocks */
-	priv->usbclk = clk_get(dev, "ipg");
+	priv->usbclk = devm_clk_get(&pdev->dev, "ipg");
 	if (IS_ERR(priv->usbclk)) {
 		ret = PTR_ERR(priv->usbclk);
-		goto err_clk;
+		goto err_alloc;
 	}
 	clk_prepare_enable(priv->usbclk);
 
-	priv->ahbclk = clk_get(dev, "ahb");
+	priv->ahbclk = devm_clk_get(&pdev->dev, "ahb");
 	if (IS_ERR(priv->ahbclk)) {
 		ret = PTR_ERR(priv->ahbclk);
 		goto err_clk_ahb;
@@ -166,7 +160,7 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
 	clk_prepare_enable(priv->ahbclk);
 
 	/* "dr" device has its own clock on i.MX51 */
-	priv->phyclk = clk_get(dev, "phy");
+	priv->phyclk = devm_clk_get(&pdev->dev, "phy");
 	if (IS_ERR(priv->phyclk))
 		priv->phyclk = NULL;
 	if (priv->phyclk)
@@ -245,23 +239,12 @@ err_add:
 	if (pdata && pdata->exit)
 		pdata->exit(pdev);
 err_init:
-	if (priv->phyclk) {
+	if (priv->phyclk)
 		clk_disable_unprepare(priv->phyclk);
-		clk_put(priv->phyclk);
-	}
 
 	clk_disable_unprepare(priv->ahbclk);
-	clk_put(priv->ahbclk);
 err_clk_ahb:
 	clk_disable_unprepare(priv->usbclk);
-	clk_put(priv->usbclk);
-err_clk:
-	iounmap(hcd->regs);
-err_ioremap:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-err_request_mem:
-err_get_resource:
-	kfree(priv);
 err_alloc:
 	usb_put_hcd(hcd);
 	return ret;
@@ -280,22 +263,14 @@ static int __exit ehci_mxc_drv_remove(struct platform_device *pdev)
 		usb_phy_shutdown(pdata->otg);
 
 	usb_remove_hcd(hcd);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 	platform_set_drvdata(pdev, NULL);
 
 	clk_disable_unprepare(priv->usbclk);
-	clk_put(priv->usbclk);
 	clk_disable_unprepare(priv->ahbclk);
-	clk_put(priv->ahbclk);
 
-	if (priv->phyclk) {
+	if (priv->phyclk)
 		clk_disable_unprepare(priv->phyclk);
-		clk_put(priv->phyclk);
-	}
-
-	kfree(priv);
 
 	return 0;
 }

