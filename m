Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2ISLa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:30:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34366 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab2ISLay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:30:54 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <kishon@ti.com>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 4/4] usb: phy: omap-usb2: enable 960Mhz clock for omap5
Date: Wed, 19 Sep 2012 17:00:29 +0530
Message-ID: <1348054229-27362-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348054229-27362-1-git-send-email-kishon@ti.com>
References: <1348054229-27362-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"usb_otg_ss_refclk960m" is needed by usb2 phy present in omap5. For
omap4, the clk_get of this clock will fail since it does not have this
clock.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/usb/usb-phy.txt |    3 +++
 drivers/usb/phy/omap-usb2.c                       |   28 ++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/usb/usb-phy.txt
index 7c5fd89..d5626de 100644
--- a/Documentation/devicetree/bindings/usb/usb-phy.txt
+++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
@@ -24,6 +24,9 @@ Required properties:
 add the address of control module phy power register until a driver for
 control module is added
 
+Optional properties:
+ - has960mhzclk: should be added if the phy needs 960mhz clock
+
 This is usually a subnode of ocp2scp to which it is connected.
 
 usb3phy@4a084400 {
diff --git a/drivers/usb/phy/omap-usb2.c b/drivers/usb/phy/omap-usb2.c
index d36c282..d6612ba 100644
--- a/drivers/usb/phy/omap-usb2.c
+++ b/drivers/usb/phy/omap-usb2.c
@@ -146,6 +146,7 @@ static int __devinit omap_usb2_probe(struct platform_device *pdev)
 	struct omap_usb			*phy;
 	struct usb_otg			*otg;
 	struct resource			*res;
+	struct device_node		*np = pdev->dev.of_node;
 
 	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
 	if (!phy) {
@@ -190,6 +191,15 @@ static int __devinit omap_usb2_probe(struct platform_device *pdev)
 	}
 	clk_prepare(phy->wkupclk);
 
+	if (of_property_read_bool(np, "has960mhzclk")) {
+		phy->optclk = devm_clk_get(phy->dev, "usb_otg_ss_refclk960m");
+		if (IS_ERR(phy->optclk)) {
+			dev_err(&pdev->dev, "unable to get refclk960m\n");
+			return PTR_ERR(phy->optclk);
+		}
+		clk_prepare(phy->optclk);
+	}
+
 	usb_add_phy(&phy->phy, USB_PHY_TYPE_USB2);
 
 	platform_set_drvdata(pdev, phy);
@@ -204,6 +214,7 @@ static int __devexit omap_usb2_remove(struct platform_device *pdev)
 	struct omap_usb	*phy = platform_get_drvdata(pdev);
 
 	clk_unprepare(phy->wkupclk);
+	clk_unprepare(phy->optclk);
 	usb_remove_phy(&phy->phy);
 
 	return 0;
@@ -217,6 +228,7 @@ static int omap_usb2_runtime_suspend(struct device *dev)
 	struct omap_usb	*phy = platform_get_drvdata(pdev);
 
 	clk_disable(phy->wkupclk);
+	clk_disable(phy->optclk);
 
 	return 0;
 }
@@ -228,8 +240,22 @@ static int omap_usb2_runtime_resume(struct device *dev)
 	struct omap_usb	*phy = platform_get_drvdata(pdev);
 
 	ret = clk_enable(phy->wkupclk);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(phy->dev, "Failed to enable wkupclk %d\n", ret);
+		return ret;
+	}
+
+	if (phy->optclk) {
+		ret = clk_enable(phy->optclk);
+		if (ret) {
+			dev_err(phy->dev, "Failed to enable optclk %d\n", ret);
+			goto err;
+		}
+	}
+
+	return 0;
+err:
+	clk_disable(phy->wkupclk);
 
 	return ret;
 }
-- 
1.7.9.5

