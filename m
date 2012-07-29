Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2G2TrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 15:47:18 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:44777 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753437Ab2G2TqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 15:46:25 -0400
X-IronPort-AV: E=Sophos;i="4.77,675,1336341600"; 
   d="scan'208";a="168487762"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] drivers/usb/host/ehci-au1xxx.c: use devm_ functions
Date: Sun, 29 Jul 2012 21:46:06 +0200
Message-Id: <1343591173-2819-3-git-send-email-Julia.Lawall@lip6.fr>
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

 drivers/usb/host/ehci-au1xxx.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/host/ehci-au1xxx.c b/drivers/usb/host/ehci-au1xxx.c
index cba10d6..65c945e 100644
--- a/drivers/usb/host/ehci-au1xxx.c
+++ b/drivers/usb/host/ehci-au1xxx.c
@@ -98,23 +98,17 @@ static int ehci_hcd_au1xxx_drv_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		pr_debug("request_mem_region failed");
-		ret = -EBUSY;
-		goto err1;
-	}
-
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
+	hcd->regs = devm_request_and_ioremap(&pdev->dev, res);
 	if (!hcd->regs) {
-		pr_debug("ioremap failed");
+		pr_debug("devm_request_and_ioremap failed");
 		ret = -ENOMEM;
-		goto err2;
+		goto err1;
 	}
 
 	if (alchemy_usb_control(ALCHEMY_USB_EHCI0, 1)) {
 		printk(KERN_INFO "%s: controller init failed!\n", pdev->name);
 		ret = -ENODEV;
-		goto err3;
+		goto err1;
 	}
 
 	ret = usb_add_hcd(hcd, pdev->resource[1].start,
@@ -125,10 +119,6 @@ static int ehci_hcd_au1xxx_drv_probe(struct platform_device *pdev)
 	}
 
 	alchemy_usb_control(ALCHEMY_USB_EHCI0, 0);
-err3:
-	iounmap(hcd->regs);
-err2:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 err1:
 	usb_put_hcd(hcd);
 	return ret;
@@ -140,8 +130,6 @@ static int ehci_hcd_au1xxx_drv_remove(struct platform_device *pdev)
 
 	usb_remove_hcd(hcd);
 	alchemy_usb_control(ALCHEMY_USB_EHCI0, 0);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 	platform_set_drvdata(pdev, NULL);
 
