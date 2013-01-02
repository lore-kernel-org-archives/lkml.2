Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab3ABPFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:05:19 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56552 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab3ABPB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:01:29 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <keshava_mgowda@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <rogerq@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 12/22] mfd: omap-usb-host: know about number of ports from revision register
Date: Wed, 2 Jan 2013 17:00:32 +0200
Message-ID: <1357138842-28964-13-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357138842-28964-1-git-send-email-rogerq@ti.com>
References: <1357138842-28964-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The revision register should tell us how many ports are present.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c |   32 +++++++++++++++++++++++++++-----
 1 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index b24a3ab..5edb828 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -91,6 +91,8 @@
 
 
 struct usbhs_hcd_omap {
+	int				nports;
+
 	struct clk			*xclk60mhsp1_ck;
 	struct clk			*xclk60mhsp2_ck;
 	struct clk			*utmi_p1_fck;
@@ -353,8 +355,6 @@ static void omap_usbhs_init(struct device *dev)
 
 	pm_runtime_get_sync(dev);
 	spin_lock_irqsave(&omap->lock, flags);
-	omap->usbhs_rev = usbhs_read(omap->uhh_base, OMAP_UHH_REVISION);
-	dev_dbg(dev, "OMAP UHH_REVISION 0x%x\n", omap->usbhs_rev);
 
 	reg = usbhs_read(omap->uhh_base, OMAP_UHH_HOSTCONFIG);
 	/* setup ULPI bypass and burst configurations */
@@ -487,8 +487,32 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 
+	platform_set_drvdata(pdev, omap);
+	pm_runtime_get_sync(dev);
 
-	for (i = 0; i < OMAP3_HS_USB_PORTS; i++)
+	omap->usbhs_rev = usbhs_read(omap->uhh_base, OMAP_UHH_REVISION);
+
+	/* we need to call runtime suspend before we update omap->nports
+	 * to prevent unbalanced clk_disable()
+	 */
+	pm_runtime_put_sync(dev);
+
+	switch (omap->usbhs_rev) {
+	case OMAP_USBHS_REV1:
+		omap->nports = 3;
+		break;
+	case OMAP_USBHS_REV2:
+		omap->nports = 2;
+		break;
+	default:
+		omap->nports = OMAP3_HS_USB_PORTS;
+		dev_dbg(dev,
+		  "USB HOST Rev : 0x%d not recognized, assuming %d ports\n",
+		   omap->usbhs_rev, omap->nports);
+		break;
+	}
+
+	for (i = 0; i < omap->nports; i++)
 		if (is_ehci_phy_mode(i) || is_ehci_tll_mode(i) ||
 			is_ehci_hsic_mode(i)) {
 			omap->ehci_logic_fck = clk_get(dev, "ehci_logic_fck");
@@ -578,8 +602,6 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 				"failed error:%d\n", ret);
 	}
 
-	platform_set_drvdata(pdev, omap);
-
 	omap_usbhs_init(dev);
 	ret = omap_usbhs_alloc_children(pdev);
 	if (ret) {
-- 
1.7.4.1

