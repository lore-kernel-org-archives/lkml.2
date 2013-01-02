Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab3ABPBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:01:43 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56826 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab3ABPBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:01:39 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <keshava_mgowda@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <rogerq@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 15/22] mfd: omap-usb-host: Manage HSIC clocks for HSIC mode
Date: Wed, 2 Jan 2013 17:00:35 +0200
Message-ID: <1357138842-28964-16-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357138842-28964-1-git-send-email-rogerq@ti.com>
References: <1357138842-28964-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the optional HSIC clocks (60MHz and 480MHz) for the ports
that are configured in HSIC mode.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c |   77 +++++++++++++++++++++++++++++++++++++++---
 1 files changed, 71 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 1c8e480..a58da22 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -93,6 +93,8 @@
 struct usbhs_hcd_omap {
 	int				nports;
 	struct clk			**utmi_clk;
+	struct clk			**hsic60m_clk;
+	struct clk			**hsic480m_clk;
 
 	struct clk			*xclk60mhsp1_ck;
 	struct clk			*xclk60mhsp2_ck;
@@ -292,7 +294,28 @@ static int usbhs_runtime_resume(struct device *dev)
 		clk_enable(omap->ehci_logic_fck);
 
 	for (i = 0; i < omap->nports; i++) {
-		if (is_ehci_tll_mode(pdata->port_mode[i])) {
+		switch (pdata->port_mode[i]) {
+		case OMAP_EHCI_PORT_MODE_HSIC:
+			if (omap->hsic60m_clk[i]) {
+				r = clk_enable(omap->hsic60m_clk[i]);
+				if (r) {
+					dev_err(dev,
+					 "Can't enable port %d hsic60m clk:%d\n",
+					 i, r);
+				}
+			}
+
+			if (omap->hsic480m_clk[i]) {
+				r = clk_enable(omap->hsic480m_clk[i]);
+				if (r) {
+					dev_err(dev,
+					 "Can't enable port %d hsic480m clk:%d\n",
+					 i, r);
+				}
+			}
+		/* Fall through as HSIC mode needs utmi_clk */
+
+		case OMAP_EHCI_PORT_MODE_TLL:
 			if (omap->utmi_clk[i]) {
 				r = clk_enable(omap->utmi_clk[i]);
 				if (r) {
@@ -301,6 +324,9 @@ static int usbhs_runtime_resume(struct device *dev)
 					 i, r);
 				}
 			}
+			break;
+		default:
+			break;
 		}
 	}
 
@@ -321,9 +347,21 @@ static int usbhs_runtime_suspend(struct device *dev)
 	spin_lock_irqsave(&omap->lock, flags);
 
 	for (i = 0; i < omap->nports; i++) {
-		if (is_ehci_tll_mode(pdata->port_mode[i])) {
+		switch (pdata->port_mode[i]) {
+		case OMAP_EHCI_PORT_MODE_HSIC:
+			if (omap->hsic60m_clk[i])
+				clk_disable(omap->hsic60m_clk[i]);
+
+			if (omap->hsic480m_clk[i])
+				clk_disable(omap->hsic480m_clk[i]);
+		/* Fall through as utmi_clks were used in HSIC mode */
+
+		case OMAP_EHCI_PORT_MODE_TLL:
 			if (omap->utmi_clk[i])
 				clk_disable(omap->utmi_clk[i]);
+			break;
+		default:
+			break;
 		}
 	}
 
@@ -528,7 +566,10 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 
 	i = sizeof(struct clk *) * omap->nports;
 	omap->utmi_clk = devm_kzalloc(dev, i, GFP_KERNEL);
-	if (!omap->utmi_clk) {
+	omap->hsic480m_clk = devm_kzalloc(dev, i, GFP_KERNEL);
+	omap->hsic60m_clk = devm_kzalloc(dev, i, GFP_KERNEL);
+
+	if (!omap->utmi_clk || !omap->hsic480m_clk || !omap->hsic60m_clk) {
 		dev_err(dev, "Memory allocation failed\n");
 		ret = -ENOMEM;
 		goto err_mem;
@@ -586,7 +627,7 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 
 	for (i = 0; i < omap->nports; i++) {
 		struct clk *pclk;
-		char clkname[] = "usb_host_hs_utmi_px_clk";
+		char clkname[] = "usb_host_hs_hsic480m_px_clk";
 
 		/* clock names are indexed from 1*/
 		snprintf(clkname, sizeof(clkname),
@@ -602,6 +643,24 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 				clkname, PTR_ERR(pclk));
 		else
 			omap->utmi_clk[i] = pclk;
+
+		snprintf(clkname, sizeof(clkname),
+				"usb_host_hs_hsic480m_p%d_clk", i + 1);
+		pclk = clk_get(dev, clkname);
+		if (IS_ERR(pclk))
+			dev_dbg(dev, "Failed to get clock : %s : %ld\n",
+				clkname, PTR_ERR(pclk));
+		else
+			omap->hsic480m_clk[i] = pclk;
+
+		snprintf(clkname, sizeof(clkname),
+				"usb_host_hs_hsic60m_p%d_clk", i + 1);
+		pclk = clk_get(dev, clkname);
+		if (IS_ERR(pclk))
+			dev_dbg(dev, "Failed to get clock : %s : %ld\n",
+				clkname, PTR_ERR(pclk));
+		else
+			omap->hsic60m_clk[i] = pclk;
 	}
 
 	if (is_ehci_phy_mode(pdata->port_mode[0])) {
@@ -645,8 +704,11 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 err_alloc:
 	omap_usbhs_deinit(&pdev->dev);
 
-	for (i = 0; i < omap->nports; i++)
+	for (i = 0; i < omap->nports; i++) {
 		clk_put(omap->utmi_clk[i]);
+		clk_put(omap->hsic60m_clk[i]);
+		clk_put(omap->hsic480m_clk[i]);
+	}
 
 	clk_put(omap->init_60m_fclk);
 
@@ -684,8 +746,11 @@ static int usbhs_omap_remove(struct platform_device *pdev)
 
 	omap_usbhs_deinit(&pdev->dev);
 
-	for (i = 0; i < omap->nports; i++)
+	for (i = 0; i < omap->nports; i++) {
 		clk_put(omap->utmi_clk[i]);
+		clk_put(omap->hsic60m_clk[i]);
+		clk_put(omap->hsic480m_clk[i]);
+	}
 
 	clk_put(omap->init_60m_fclk);
 	clk_put(omap->utmi_p1_gfclk);
-- 
1.7.4.1

