Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab2G2TrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 15:47:22 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:7066 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753489Ab2G2Tq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 15:46:28 -0400
X-IronPort-AV: E=Sophos;i="4.77,675,1336341600"; 
   d="scan'208";a="168487767"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] drivers/usb/host/ehci-msm.c: use devm_ functions
Date: Sun, 29 Jul 2012 21:46:11 +0200
Message-Id: <1343591173-2819-8-git-send-email-Julia.Lawall@lip6.fr>
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

The original code was also missing a call to iounmap(hcd->regs); in the
remove function, so this patch also implicitly fixes a bug.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not compiled.

 drivers/usb/host/ehci-msm.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/ehci-msm.c b/drivers/usb/host/ehci-msm.c
index 17dd9e9..4af4dc5 100644
--- a/drivers/usb/host/ehci-msm.c
+++ b/drivers/usb/host/ehci-msm.c
@@ -133,7 +133,7 @@ static int ehci_msm_probe(struct platform_device *pdev)
 
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
+	hcd->regs = devm_ioremap(&pdev->dev, hcd->rsrc_start, hcd->rsrc_len);
 	if (!hcd->regs) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		ret = -ENOMEM;
@@ -145,17 +145,17 @@ static int ehci_msm_probe(struct platform_device *pdev)
 	 * powering up VBUS, mapping of registers address space and power
 	 * management.
 	 */
-	phy = usb_get_phy(USB_PHY_TYPE_USB2);
+	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
 	if (IS_ERR_OR_NULL(phy)) {
 		dev_err(&pdev->dev, "unable to find transceiver\n");
 		ret = -ENODEV;
-		goto unmap;
+		goto put_hcd;
 	}
 
 	ret = otg_set_host(phy->otg, &hcd->self);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "unable to register with transceiver\n");
-		goto put_transceiver;
+		goto put_hcd;
 	}
 
 	device_init_wakeup(&pdev->dev, 1);
@@ -168,10 +168,6 @@ static int ehci_msm_probe(struct platform_device *pdev)
 
 	return 0;
 
-put_transceiver:
-	usb_put_phy(phy);
-unmap:
-	iounmap(hcd->regs);
 put_hcd:
 	usb_put_hcd(hcd);
 
@@ -187,7 +183,6 @@ static int __devexit ehci_msm_remove(struct platform_device *pdev)
 	pm_runtime_set_suspended(&pdev->dev);
 
 	otg_set_host(phy->otg, NULL);
-	usb_put_phy(phy);
 
 	usb_put_hcd(hcd);
 
