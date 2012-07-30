Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab2G3On4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:43:56 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:21080
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754741Ab2G3Ony (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:43:54 -0400
X-IronPort-AV: E=Sophos;i="4.77,679,1336341600"; 
   d="scan'208";a="152028600"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] drivers/usb/host/ehci-tegra.c: use devm_ functions
Date: Mon, 30 Jul 2012 16:43:41 +0200
Message-Id: <1343659425-24563-3-git-send-email-Julia.Lawall@lip6.fr>
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

 drivers/usb/host/ehci-tegra.c |   40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 950e95e..ba5039f 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -634,7 +634,8 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 
 	setup_vbus_gpio(pdev, pdata);
 
-	tegra = kzalloc(sizeof(struct tegra_ehci_hcd), GFP_KERNEL);
+	tegra = devm_kzalloc(&pdev->dev, sizeof(struct tegra_ehci_hcd),
+			     GFP_KERNEL);
 	if (!tegra)
 		return -ENOMEM;
 
@@ -642,13 +643,12 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 					dev_name(&pdev->dev));
 	if (!hcd) {
 		dev_err(&pdev->dev, "Unable to create HCD\n");
-		err = -ENOMEM;
-		goto fail_hcd;
+		return -ENOMEM;
 	}
 
 	platform_set_drvdata(pdev, tegra);
 
-	tegra->clk = clk_get(&pdev->dev, NULL);
+	tegra->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(tegra->clk)) {
 		dev_err(&pdev->dev, "Can't get ehci clock\n");
 		err = PTR_ERR(tegra->clk);
@@ -657,9 +657,9 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 
 	err = clk_prepare_enable(tegra->clk);
 	if (err)
-		goto fail_clken;
+		goto fail_clk;
 
-	tegra->emc_clk = clk_get(&pdev->dev, "emc");
+	tegra->emc_clk = devm_clk_get(&pdev->dev, "emc");
 	if (IS_ERR(tegra->emc_clk)) {
 		dev_err(&pdev->dev, "Can't get emc clock\n");
 		err = PTR_ERR(tegra->emc_clk);
@@ -677,7 +677,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	}
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
-	hcd->regs = ioremap(res->start, resource_size(res));
+	hcd->regs = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (!hcd->regs) {
 		dev_err(&pdev->dev, "Failed to remap I/O memory\n");
 		err = -ENOMEM;
@@ -702,7 +702,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 		default:
 			err = -ENODEV;
 			dev_err(&pdev->dev, "unknown usb instance\n");
-			goto fail_phy;
+			goto fail_io;
 		}
 	}
 
@@ -712,7 +712,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	if (IS_ERR(tegra->phy)) {
 		dev_err(&pdev->dev, "Failed to open USB phy\n");
 		err = -ENXIO;
-		goto fail_phy;
+		goto fail_io;
 	}
 
 	err = tegra_usb_phy_power_on(tegra->phy);
@@ -733,7 +733,8 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_USB_OTG_UTILS
 	if (pdata->operating_mode == TEGRA_USB_OTG) {
-		tegra->transceiver = usb_get_phy(USB_PHY_TYPE_USB2);
+		tegra->transceiver =
+			devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
 		if (!IS_ERR_OR_NULL(tegra->transceiver))
 			otg_set_host(tegra->transceiver->otg, &hcd->self);
 	}
@@ -757,25 +758,16 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 
 fail:
 #ifdef CONFIG_USB_OTG_UTILS
-	if (!IS_ERR_OR_NULL(tegra->transceiver)) {
+	if (!IS_ERR_OR_NULL(tegra->transceiver))
 		otg_set_host(tegra->transceiver->otg, NULL);
-		usb_put_phy(tegra->transceiver);
-	}
 #endif
 	tegra_usb_phy_close(tegra->phy);
-fail_phy:
-	iounmap(hcd->regs);
 fail_io:
 	clk_disable_unprepare(tegra->emc_clk);
-	clk_put(tegra->emc_clk);
 fail_emc_clk:
 	clk_disable_unprepare(tegra->clk);
-fail_clken:
-	clk_put(tegra->clk);
 fail_clk:
 	usb_put_hcd(hcd);
-fail_hcd:
-	kfree(tegra);
 	return err;
 }
 
@@ -792,25 +784,19 @@ static int tegra_ehci_remove(struct platform_device *pdev)
 	pm_runtime_put_noidle(&pdev->dev);
 
 #ifdef CONFIG_USB_OTG_UTILS
-	if (!IS_ERR_OR_NULL(tegra->transceiver)) {
+	if (!IS_ERR_OR_NULL(tegra->transceiver))
 		otg_set_host(tegra->transceiver->otg, NULL);
-		usb_put_phy(tegra->transceiver);
-	}
 #endif
 
 	usb_remove_hcd(hcd);
 	usb_put_hcd(hcd);
 
 	tegra_usb_phy_close(tegra->phy);
-	iounmap(hcd->regs);
 
 	clk_disable_unprepare(tegra->clk);
-	clk_put(tegra->clk);
 
 	clk_disable_unprepare(tegra->emc_clk);
-	clk_put(tegra->emc_clk);
 
-	kfree(tegra);
 	return 0;
 }
 

