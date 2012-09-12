Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab2ILHSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 03:18:18 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8430 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab2ILHSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 03:18:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 12 Sep 2012 00:18:16 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <balbi@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] usb: host: tegra: code clean up
Date: Wed, 12 Sep 2012 12:32:42 +0530
Message-ID: <1347433362-4669-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of code clean up, used devm counterparts for the APIs
possible.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/usb/host/ehci-tegra.c |   46 ++++++++++++++--------------------------
 1 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index c0d4732..532db04 100644
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
@@ -701,8 +701,8 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 			break;
 		default:
 			err = -ENODEV;
-			dev_err(&pdev->dev, "unknown usb instance\n");
-			goto fail_phy;
+			dev_err(&pdev->dev, "unknown usb inst:%d\n", instance);
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
 
 	usb_phy_init(&tegra->phy->u_phy);
@@ -735,7 +735,8 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_USB_OTG_UTILS
 	if (pdata->operating_mode == TEGRA_USB_OTG) {
-		tegra->transceiver = usb_get_phy(USB_PHY_TYPE_USB2);
+		tegra->transceiver =
+			devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
 		if (!IS_ERR_OR_NULL(tegra->transceiver))
 			otg_set_host(tegra->transceiver->otg, &hcd->self);
 	}
@@ -743,7 +744,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 
 	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to add USB HCD\n");
+		dev_err(&pdev->dev, "usb_add_hcd failed with err 0x%x\n", err);
 		goto fail;
 	}
 
@@ -752,32 +753,23 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 
 	/* Don't skip the pm_runtime_forbid call if wakeup isn't working */
 	/* if (!pdata->power_down_on_bus_suspend) */
-		pm_runtime_forbid(&pdev->dev);
+	pm_runtime_forbid(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
 	return err;
 
 fail:
 #ifdef CONFIG_USB_OTG_UTILS
-	if (!IS_ERR_OR_NULL(tegra->transceiver)) {
+	if (!IS_ERR_OR_NULL(tegra->transceiver))
 		otg_set_host(tegra->transceiver->otg, NULL);
-		usb_put_phy(tegra->transceiver);
-	}
 #endif
 	usb_phy_shutdown(&tegra->phy->u_phy);
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
 
@@ -794,26 +786,20 @@ static int tegra_ehci_remove(struct platform_device *pdev)
 	pm_runtime_put_noidle(&pdev->dev);
 
 #ifdef CONFIG_USB_OTG_UTILS
-	if (!IS_ERR_OR_NULL(tegra->transceiver)) {
+	if (!IS_ERR_OR_NULL(tegra->transceiver))
 		otg_set_host(tegra->transceiver->otg, NULL);
-		usb_put_phy(tegra->transceiver);
-	}
 #endif
 
 	usb_remove_hcd(hcd);
 
 	usb_phy_shutdown(&tegra->phy->u_phy);
-	iounmap(hcd->regs);
 
 	usb_put_hcd(hcd);
 
 	clk_disable_unprepare(tegra->clk);
-	clk_put(tegra->clk);
 
 	clk_disable_unprepare(tegra->emc_clk);
-	clk_put(tegra->emc_clk);
 
-	kfree(tegra);
 	return 0;
 }
 
-- 
1.7.1.1

