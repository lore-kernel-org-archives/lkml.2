Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab2G2Tr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 15:47:27 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:44777 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359Ab2G2Tq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 15:46:26 -0400
X-IronPort-AV: E=Sophos;i="4.77,675,1336341600"; 
   d="scan'208";a="168487763"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] drivers/usb/host/ehci-cns3xxx.c: use devm_ functions
Date: Sun, 29 Jul 2012 21:46:07 +0200
Message-Id: <1343591173-2819-4-git-send-email-Julia.Lawall@lip6.fr>
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

 drivers/usb/host/ehci-cns3xxx.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/host/ehci-cns3xxx.c b/drivers/usb/host/ehci-cns3xxx.c
index caaa3e5..d91708d 100644
--- a/drivers/usb/host/ehci-cns3xxx.c
+++ b/drivers/usb/host/ehci-cns3xxx.c
@@ -105,27 +105,17 @@ static int cns3xxx_ehci_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
-				driver->description)) {
-		dev_dbg(dev, "controller already in use\n");
-		retval = -EBUSY;
-		goto err1;
-	}
-
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
+	hcd->regs = devm_request_and_ioremap(&pdev->dev, res);
 	if (hcd->regs == NULL) {
 		dev_dbg(dev, "error mapping memory\n");
 		retval = -EFAULT;
-		goto err2;
+		goto err1;
 	}
 
 	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (retval == 0)
 		return retval;
 
-	iounmap(hcd->regs);
-err2:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 err1:
 	usb_put_hcd(hcd);
 
@@ -137,8 +127,6 @@ static int cns3xxx_ehci_remove(struct platform_device *pdev)
 	struct usb_hcd *hcd = platform_get_drvdata(pdev);
 
 	usb_remove_hcd(hcd);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 
 	/*
 	 * EHCI and OHCI share the same clock and power,
