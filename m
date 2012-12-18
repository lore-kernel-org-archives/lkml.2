Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab2LRHMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:12:54 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12834 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2LRHMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:12:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 17 Dec 2012 23:12:52 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <swarren@wwwdotorg.org>, <stern@rowland.harvard.edu>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] usb: host: tegra: make use of PHY pointer of HCD
Date: Tue, 18 Dec 2012 12:25:36 +0530
Message-ID: <1355813736-2487-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointer to PHY structure can be stored in struct usb_hcd
making use of it, to call PHY APIs.

Call to usb_phy_shutdown() is moved up in tegra_ehci_remove(),
so that to avoid dereferencing of hcd after its freed up.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
This patch depends on patch http://marc.info/?l=linux-kernel&m=135581274019690&w=2.
Without above patch applied, phy->notify_connect & phy->notify_disconnect are
set to some unknown values, which need not be NULL.
This creates problem when hcd->phy pointer is initialized hub_port_init() in hub.c
calls usb_phy_notify_connect().

Stephen,
Can you plz take this patch through tegra tree, so as to take care of the dependencies?

 drivers/usb/host/ehci-tegra.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index aca6606..5b2c48d 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -53,7 +53,7 @@ static void tegra_ehci_power_up(struct usb_hcd *hcd)
 
 	clk_prepare_enable(tegra->emc_clk);
 	clk_prepare_enable(tegra->clk);
-	usb_phy_set_suspend(&tegra->phy->u_phy, 0);
+	usb_phy_set_suspend(hcd->phy, 0);
 	tegra->host_resumed = 1;
 }
 
@@ -62,7 +62,7 @@ static void tegra_ehci_power_down(struct usb_hcd *hcd)
 	struct tegra_ehci_hcd *tegra = dev_get_drvdata(hcd->self.controller);
 
 	tegra->host_resumed = 0;
-	usb_phy_set_suspend(&tegra->phy->u_phy, 1);
+	usb_phy_set_suspend(hcd->phy, 1);
 	clk_disable_unprepare(tegra->clk);
 	clk_disable_unprepare(tegra->emc_clk);
 }
@@ -716,9 +716,14 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 		goto fail_io;
 	}
 
-	usb_phy_init(&tegra->phy->u_phy);
+	hcd->phy = &tegra->phy->u_phy;
+	err = usb_phy_init(hcd->phy);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to initialize phy\n");
+		goto fail;
+	}
 
-	err = usb_phy_set_suspend(&tegra->phy->u_phy, 0);
+	err = usb_phy_set_suspend(hcd->phy, 0);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to power on the phy\n");
 		goto fail;
@@ -764,7 +769,7 @@ fail:
 	if (!IS_ERR_OR_NULL(tegra->transceiver))
 		otg_set_host(tegra->transceiver->otg, NULL);
 #endif
-	usb_phy_shutdown(&tegra->phy->u_phy);
+	usb_phy_shutdown(hcd->phy);
 fail_io:
 	clk_disable_unprepare(tegra->emc_clk);
 fail_emc_clk:
@@ -787,12 +792,10 @@ static int tegra_ehci_remove(struct platform_device *pdev)
 	if (!IS_ERR_OR_NULL(tegra->transceiver))
 		otg_set_host(tegra->transceiver->otg, NULL);
 #endif
-
+	usb_phy_shutdown(hcd->phy);
 	usb_remove_hcd(hcd);
 	usb_put_hcd(hcd);
 
-	usb_phy_shutdown(&tegra->phy->u_phy);
-
 	clk_disable_unprepare(tegra->clk);
 
 	clk_disable_unprepare(tegra->emc_clk);
-- 
1.7.0.4

