Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab2JEQYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:24:20 -0400
Received: from zmc.proxad.net ([212.27.53.206]:56556 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917Ab2JEQXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:23:47 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 32/32] USB: OHCI: make ohci-platform use devm_{ioremap,request_mem_region} helpers
Date: Fri,  5 Oct 2012 18:21:04 +0200
Message-Id: <1349454064-11606-33-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349454064-11606-1-git-send-email-florian@openwrt.org>
References: <1349454064-11606-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the ohci-platform driver to use the device managed helper
functions for requesting memory region and ioremapping memory resources.
As a result the error path in the probe function is simplified, and the
platform driver remove callback does not longer need to release and iounmap
memory resources.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/usb/host/ohci-platform.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/host/ohci-platform.c b/drivers/usb/host/ohci-platform.c
index 1344426..2f8c5d5 100644
--- a/drivers/usb/host/ohci-platform.c
+++ b/drivers/usb/host/ohci-platform.c
@@ -127,29 +127,27 @@ static int __devinit ohci_platform_probe(struct platform_device *dev)
 	hcd->rsrc_start = res_mem->start;
 	hcd->rsrc_len = resource_size(res_mem);
 
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
+	if (!devm_request_mem_region(&dev->dev, hcd->rsrc_start,
+					hcd->rsrc_len, hcd_name)) {
 		dev_err(&dev->dev, "controller already in use");
 		err = -EBUSY;
 		goto err_put_hcd;
 	}
 
-	hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
+	hcd->regs = devm_ioremap_nocache(&dev->dev, hcd->rsrc_start,
+						hcd->rsrc_len);
 	if (!hcd->regs) {
 		err = -ENOMEM;
-		goto err_release_region;
+		goto err_put_hcd;
 	}
 	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (err)
-		goto err_iounmap;
+		goto err_put_hcd;
 
 	platform_set_drvdata(dev, hcd);
 
 	return err;
 
-err_iounmap:
-	iounmap(hcd->regs);
-err_release_region:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 err_put_hcd:
 	usb_put_hcd(hcd);
 err_power:
@@ -165,8 +163,6 @@ static int __devexit ohci_platform_remove(struct platform_device *dev)
 	struct usb_ohci_pdata *pdata = dev->dev.platform_data;
 
 	usb_remove_hcd(hcd);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 	platform_set_drvdata(dev, NULL);
 
-- 
1.7.9.5

