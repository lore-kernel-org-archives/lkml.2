Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab2I0OEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:04:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47775 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab2I0OEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:04:35 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH v2 2/2] usb: phy: omap-usb2: enable 960Mhz clock for omap5
Date: Thu, 27 Sep 2012 19:34:08 +0530
Message-ID: <1348754648-8315-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348754648-8315-1-git-send-email-kishon@ti.com>
References: <1348754648-8315-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"usb_otg_ss_refclk960m" is needed for usb2 phy present in omap5. For
omap4, the clk_get of this clock will fail since it does not have this
clock.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/phy/omap-usb2.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/phy/omap-usb2.c b/drivers/usb/phy/omap-usb2.c
index d36c282..5512207 100644
--- a/drivers/usb/phy/omap-usb2.c
+++ b/drivers/usb/phy/omap-usb2.c
@@ -190,6 +190,12 @@ static int __devinit omap_usb2_probe(struct platform_device *pdev)
 	}
 	clk_prepare(phy->wkupclk);
 
+	phy->optclk = devm_clk_get(phy->dev, "usb_otg_ss_refclk960m");
+	if (IS_ERR(phy->optclk))
+		dev_vdbg(&pdev->dev, "unable to get refclk960m\n");
+	else
+		clk_prepare(phy->optclk);
+
 	usb_add_phy(&phy->phy, USB_PHY_TYPE_USB2);
 
 	platform_set_drvdata(pdev, phy);
@@ -204,6 +210,7 @@ static int __devexit omap_usb2_remove(struct platform_device *pdev)
 	struct omap_usb	*phy = platform_get_drvdata(pdev);
 
 	clk_unprepare(phy->wkupclk);
+	clk_unprepare(phy->optclk);
 	usb_remove_phy(&phy->phy);
 
 	return 0;
@@ -217,6 +224,7 @@ static int omap_usb2_runtime_suspend(struct device *dev)
 	struct omap_usb	*phy = platform_get_drvdata(pdev);
 
 	clk_disable(phy->wkupclk);
+	clk_disable(phy->optclk);
 
 	return 0;
 }
@@ -228,10 +236,16 @@ static int omap_usb2_runtime_resume(struct device *dev)
 	struct omap_usb	*phy = platform_get_drvdata(pdev);
 
 	ret = clk_enable(phy->wkupclk);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(phy->dev, "Failed to enable wkupclk %d\n", ret);
+		return ret;
+	}
 
-	return ret;
+	ret = clk_enable(phy->optclk);
+	if (ret < 0)
+		dev_vdbg(phy->dev, "Failed to enable optclk %d\n", ret);
+
+	return 0;
 }
 
 static const struct dev_pm_ops omap_usb2_pm_ops = {
-- 
1.7.9.5

