Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab2G3OpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:45:23 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:12703
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809Ab2G3Onz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:43:55 -0400
X-IronPort-AV: E=Sophos;i="4.77,679,1336341600"; 
   d="scan'208";a="152028602"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] drivers/usb/host/ehci-sh.c: use devm_ functions
Date: Mon, 30 Jul 2012 16:43:42 +0200
Message-Id: <1343659425-24563-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
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
Not compiled

 drivers/usb/host/ehci-sh.c |   35 +++++++----------------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/usb/host/ehci-sh.c b/drivers/usb/host/ehci-sh.c
index b3f1e36..6081e1e 100644
--- a/drivers/usb/host/ehci-sh.c
+++ b/drivers/usb/host/ehci-sh.c
@@ -125,33 +125,27 @@ static int ehci_hcd_sh_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
-				driver->description)) {
-		dev_dbg(&pdev->dev, "controller already in use\n");
-		ret = -EBUSY;
-		goto fail_request_resource;
-	}
-
-	hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
+	hcd->regs = devm_request_and_ioremap(&pdev->dev, res);
 	if (hcd->regs == NULL) {
 		dev_dbg(&pdev->dev, "error mapping memory\n");
 		ret = -ENXIO;
-		goto fail_ioremap;
+		goto fail_request_resource;
 	}
 
-	priv = kmalloc(sizeof(struct ehci_sh_priv), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(struct ehci_sh_priv),
+			    GFP_KERNEL);
 	if (!priv) {
 		dev_dbg(&pdev->dev, "error allocating priv data\n");
 		ret = -ENOMEM;
-		goto fail_alloc;
+		goto fail_request_resource;
 	}
 
 	/* These are optional, we don't care if they fail */
-	priv->fclk = clk_get(&pdev->dev, "usb_fck");
+	priv->fclk = devm_clk_get(&pdev->dev, "usb_fck");
 	if (IS_ERR(priv->fclk))
 		priv->fclk = NULL;
 
-	priv->iclk = clk_get(&pdev->dev, "usb_ick");
+	priv->iclk = devm_clk_get(&pdev->dev, "usb_ick");
 	if (IS_ERR(priv->iclk))
 		priv->iclk = NULL;
 
@@ -176,14 +170,6 @@ fail_add_hcd:
 	clk_disable(priv->iclk);
 	clk_disable(priv->fclk);
 
-	clk_put(priv->iclk);
-	clk_put(priv->fclk);
-
-	kfree(priv);
-fail_alloc:
-	iounmap(hcd->regs);
-fail_ioremap:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 fail_request_resource:
 	usb_put_hcd(hcd);
 fail_create_hcd:
@@ -198,19 +184,12 @@ static int __exit ehci_hcd_sh_remove(struct platform_device *pdev)
 	struct usb_hcd *hcd = priv->hcd;
 
 	usb_remove_hcd(hcd);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 	platform_set_drvdata(pdev, NULL);
 
 	clk_disable(priv->fclk);
 	clk_disable(priv->iclk);
 
-	clk_put(priv->fclk);
-	clk_put(priv->iclk);
-
-	kfree(priv);
-
 	return 0;
 }
 

