Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2G2TqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 15:46:25 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:7066 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359Ab2G2TqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 15:46:23 -0400
X-IronPort-AV: E=Sophos;i="4.77,675,1336341600"; 
   d="scan'208";a="168487761"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] drivers/usb/host/ehci-atmel.c: use devm_ functions
Date: Sun, 29 Jul 2012 21:46:05 +0200
Message-Id: <1343591173-2819-2-git-send-email-Julia.Lawall@lip6.fr>
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

 drivers/usb/host/ehci-atmel.c |   30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
index a47e2cf..411bb74 100644
--- a/drivers/usb/host/ehci-atmel.c
+++ b/drivers/usb/host/ehci-atmel.c
@@ -150,31 +150,24 @@ static int __devinit ehci_atmel_drv_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
-				driver->description)) {
-		dev_dbg(&pdev->dev, "controller already in use\n");
-		retval = -EBUSY;
-		goto fail_request_resource;
-	}
-
-	hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
+	hcd->regs = devm_request_and_ioremap(&pdev->dev, res);
 	if (hcd->regs == NULL) {
 		dev_dbg(&pdev->dev, "error mapping memory\n");
 		retval = -EFAULT;
-		goto fail_ioremap;
+		goto fail_request_resource;
 	}
 
-	iclk = clk_get(&pdev->dev, "ehci_clk");
+	iclk = devm_clk_get(&pdev->dev, "ehci_clk");
 	if (IS_ERR(iclk)) {
 		dev_err(&pdev->dev, "Error getting interface clock\n");
 		retval = -ENOENT;
-		goto fail_get_iclk;
+		goto fail_request_resource;
 	}
-	fclk = clk_get(&pdev->dev, "uhpck");
+	fclk = devm_clk_get(&pdev->dev, "uhpck");
 	if (IS_ERR(fclk)) {
 		dev_err(&pdev->dev, "Error getting function clock\n");
 		retval = -ENOENT;
-		goto fail_get_fclk;
+		goto fail_request_resource;
 	}
 
 	atmel_start_ehci(pdev);
@@ -187,13 +180,6 @@ static int __devinit ehci_atmel_drv_probe(struct platform_device *pdev)
 
 fail_add_hcd:
 	atmel_stop_ehci(pdev);
-	clk_put(fclk);
-fail_get_fclk:
-	clk_put(iclk);
-fail_get_iclk:
-	iounmap(hcd->regs);
-fail_ioremap:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 fail_request_resource:
 	usb_put_hcd(hcd);
 fail_create_hcd:
@@ -209,13 +195,9 @@ static int __devexit ehci_atmel_drv_remove(struct platform_device *pdev)
 
 	ehci_shutdown(hcd);
 	usb_remove_hcd(hcd);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 
 	atmel_stop_ehci(pdev);
-	clk_put(fclk);
-	clk_put(iclk);
 	fclk = iclk = NULL;
 
 	return 0;
