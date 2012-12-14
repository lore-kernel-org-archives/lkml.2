Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab2LNHPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 02:15:42 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5826 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab2LNHPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 02:15:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 13 Dec 2012 23:15:16 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>,
        <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <sjg@chromium.org>, <olof@lixom.net>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH 2/2] usb: host: tegra: Resetting PORT0 based on information received via DT.
Date: Fri, 14 Dec 2012 12:29:08 +0530
Message-ID: <1355468348-8821-3-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1355468348-8821-1-git-send-email-vbyravarasu@nvidia.com>
References: <1355468348-8821-1-git-send-email-vbyravarasu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra USB host driver is using port instance number,
to handle some of the hardware issues on SOC e.g. reset PORT0
twice etc. As instance number based handling looks ugly,
making use of information passed through DT for achieving this.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/usb/host/ehci-tegra.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index acf1755..55a9cde 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -43,6 +43,7 @@ struct tegra_ehci_hcd {
 	struct usb_phy *transceiver;
 	int host_resumed;
 	int port_resuming;
+	bool needs_double_reset;
 	enum tegra_usb_phy_port_speed port_speed;
 };
 
@@ -184,7 +185,7 @@ static int tegra_ehci_hub_control(
 	}
 
 	/* For USB1 port we need to issue Port Reset twice internally */
-	if (tegra->phy->instance == 0 &&
+	if (tegra->needs_double_reset &&
 	   (typeReq == SetPortFeature && wValue == USB_PORT_FEAT_RESET)) {
 		spin_unlock_irqrestore(&ehci->lock, flags);
 		return tegra_ehci_internal_port_reset(ehci, status_reg);
@@ -666,6 +667,9 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	clk_prepare_enable(tegra->emc_clk);
 	clk_set_rate(tegra->emc_clk, 400000000);
 
+	tegra->needs_double_reset = of_property_read_bool(pdev->dev.of_node,
+		"nvidia,needs-double-reset");
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "Failed to get I/O memory\n");
-- 
1.7.0.4

