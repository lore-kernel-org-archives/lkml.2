Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab2G2Tr3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 15:47:29 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:7066 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753484Ab2G2Tq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 15:46:27 -0400
X-IronPort-AV: E=Sophos;i="4.77,675,1336341600"; 
   d="scan'208";a="168487765"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] drivers/usb/host/ehci-ixp4xx.c: use devm_ functions
Date: Sun, 29 Jul 2012 21:46:09 +0200
Message-Id: <1343591173-2819-6-git-send-email-Julia.Lawall@lip6.fr>
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

 drivers/usb/host/ehci-ixp4xx.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/host/ehci-ixp4xx.c b/drivers/usb/host/ehci-ixp4xx.c
index 488d401..f224c0a 100644
--- a/drivers/usb/host/ehci-ixp4xx.c
+++ b/drivers/usb/host/ehci-ixp4xx.c
@@ -98,30 +98,19 @@ static int ixp4xx_ehci_probe(struct platform_device *pdev)
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
 
 	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (retval)
-		goto fail_add_hcd;
+		goto fail_request_resource;
 
 	return retval;
 
-fail_add_hcd:
-	iounmap(hcd->regs);
-fail_ioremap:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 fail_request_resource:
 	usb_put_hcd(hcd);
 fail_create_hcd:
@@ -134,8 +123,6 @@ static int ixp4xx_ehci_remove(struct platform_device *pdev)
 	struct usb_hcd *hcd = platform_get_drvdata(pdev);
 
 	usb_remove_hcd(hcd);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 
 	return 0;
