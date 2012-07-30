Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab2G3Ooj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:44:39 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:21080
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754810Ab2G3Onz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:43:55 -0400
X-IronPort-AV: E=Sophos;i="4.77,679,1336341600"; 
   d="scan'208";a="152028604"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] drivers/usb/host/ehci-s5p.c: use devm_ functions
Date: Mon, 30 Jul 2012 16:43:44 +0200
Message-Id: <1343659425-24563-6-git-send-email-Julia.Lawall@lip6.fr>
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

 drivers/usb/host/ehci-s5p.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 9d8f1dd..d055503 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -128,7 +128,7 @@ static int __devinit s5p_ehci_probe(struct platform_device *pdev)
 	}
 
 	s5p_ehci->hcd = hcd;
-	s5p_ehci->clk = clk_get(&pdev->dev, "usbhost");
+	s5p_ehci->clk = devm_clk_get(&pdev->dev, "usbhost");
 
 	if (IS_ERR(s5p_ehci->clk)) {
 		dev_err(&pdev->dev, "Failed to get usbhost clock\n");
@@ -138,7 +138,7 @@ static int __devinit s5p_ehci_probe(struct platform_device *pdev)
 
 	err = clk_enable(s5p_ehci->clk);
 	if (err)
-		goto fail_clken;
+		goto fail_clk;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
@@ -184,8 +184,6 @@ static int __devinit s5p_ehci_probe(struct platform_device *pdev)
 
 fail_io:
 	clk_disable(s5p_ehci->clk);
-fail_clken:
-	clk_put(s5p_ehci->clk);
 fail_clk:
 	usb_put_hcd(hcd);
 	return err;
@@ -203,7 +201,6 @@ static int __devexit s5p_ehci_remove(struct platform_device *pdev)
 		pdata->phy_exit(pdev, S5P_USB_PHY_HOST);
 
 	clk_disable(s5p_ehci->clk);
-	clk_put(s5p_ehci->clk);
 
 	usb_put_hcd(hcd);
 

