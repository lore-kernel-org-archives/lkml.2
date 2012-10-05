Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab2JERJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 13:09:11 -0400
Received: from zmc.proxad.net ([212.27.53.206]:60497 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916Ab2JERJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 13:09:08 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 31/32 v2] USB: EHCI: make ehci-platform use devm_request_and_ioremap helper
Date: Fri,  5 Oct 2012 19:07:56 +0200
Message-Id: <1349456876-14764-1-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349454064-11606-32-git-send-email-florian@openwrt.org>
References: <1349454064-11606-32-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the ehci-platform driver to use the device managed helper
function for requesting memory region and ioremapping memory resources.
As a result the error path in the probe function is simplified, and the
platform driver remove callback does not longer need to release and iounmap
memory resources. devm_request_and_ioremap() will use either the ioremap()
or ioremap_nocache() handler depending on the resource's CACHEABLE flag, so
we are good with this change.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
Changes in v2
- use devm_request_and_ioremap instead of two calls

 drivers/usb/host/ehci-platform.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index 3cb0b1b..272728c 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -123,29 +123,19 @@ static int __devinit ehci_platform_probe(struct platform_device *dev)
 	hcd->rsrc_start = res_mem->start;
 	hcd->rsrc_len = resource_size(res_mem);
 
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		dev_err(&dev->dev, "controller already in use");
-		err = -EBUSY;
-		goto err_put_hcd;
-	}
-
-	hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
+	hcd->regs = devm_request_and_ioremap(&dev->dev, res_mem);
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
@@ -161,8 +151,6 @@ static int __devexit ehci_platform_remove(struct platform_device *dev)
 	struct usb_ehci_pdata *pdata = dev->dev.platform_data;
 
 	usb_remove_hcd(hcd);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 	platform_set_drvdata(dev, NULL);
 
-- 
1.7.9.5

