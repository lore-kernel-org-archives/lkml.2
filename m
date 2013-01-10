Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab3AJQzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:55:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50208 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab3AJQwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:52:00 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH 08/14] mfd: omap-usb-host: Remove PHY reset handling code
Date: Thu, 10 Jan 2013 18:51:28 +0200
Message-ID: <1357836694-30788-9-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357836694-30788-1-git-send-email-rogerq@ti.com>
References: <1357836694-30788-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PHY reset GPIO handling will be done in the PHY driver

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c |   47 -------------------------------------------
 1 files changed, 0 insertions(+), 47 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 5c1c3ae..7547448 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -430,24 +430,10 @@ static unsigned omap_usbhs_rev2_hostconfig(struct usbhs_hcd_omap *omap,
 static void omap_usbhs_init(struct device *dev)
 {
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
-	struct usbhs_omap_platform_data	*pdata = omap->pdata;
 	unsigned			reg;
 
 	dev_dbg(dev, "starting TI HSUSB Controller\n");
 
-	if (pdata->phy_reset) {
-		if (gpio_is_valid(pdata->reset_gpio_port[0]))
-			gpio_request_one(pdata->reset_gpio_port[0],
-					 GPIOF_OUT_INIT_LOW, "USB1 PHY reset");
-
-		if (gpio_is_valid(pdata->reset_gpio_port[1]))
-			gpio_request_one(pdata->reset_gpio_port[1],
-					 GPIOF_OUT_INIT_LOW, "USB2 PHY reset");
-
-		/* Hold the PHY in RESET for enough time till DIR is high */
-		udelay(10);
-	}
-
 	pm_runtime_get_sync(dev);
 
 	reg = usbhs_read(omap->uhh_base, OMAP_UHH_HOSTCONFIG);
@@ -467,37 +453,8 @@ static void omap_usbhs_init(struct device *dev)
 	dev_dbg(dev, "UHH setup done, uhh_hostconfig=%x\n", reg);
 
 	pm_runtime_put_sync(dev);
-	if (pdata->phy_reset) {
-		/* Hold the PHY in RESET for enough time till
-		 * PHY is settled and ready
-		 */
-		udelay(10);
-
-		if (gpio_is_valid(pdata->reset_gpio_port[0]))
-			gpio_set_value_cansleep
-				(pdata->reset_gpio_port[0], 1);
-
-		if (gpio_is_valid(pdata->reset_gpio_port[1]))
-			gpio_set_value_cansleep
-				(pdata->reset_gpio_port[1], 1);
-	}
-}
-
-static void omap_usbhs_deinit(struct device *dev)
-{
-	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
-	struct usbhs_omap_platform_data	*pdata = omap->pdata;
-
-	if (pdata->phy_reset) {
-		if (gpio_is_valid(pdata->reset_gpio_port[0]))
-			gpio_free(pdata->reset_gpio_port[0]);
-
-		if (gpio_is_valid(pdata->reset_gpio_port[1]))
-			gpio_free(pdata->reset_gpio_port[1]);
-	}
 }
 
-
 /**
  * usbhs_omap_probe - initialize TI-based HCDs
  *
@@ -705,8 +662,6 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 	return 0;
 
 err_alloc:
-	omap_usbhs_deinit(&pdev->dev);
-
 	for (i = 0; i < omap->nports; i++) {
 		clk_put(omap->utmi_clk[i]);
 		clk_put(omap->hsic60m_clk[i]);
@@ -747,8 +702,6 @@ static int usbhs_omap_remove(struct platform_device *pdev)
 	struct usbhs_hcd_omap *omap = platform_get_drvdata(pdev);
 	int i;
 
-	omap_usbhs_deinit(&pdev->dev);
-
 	for (i = 0; i < omap->nports; i++) {
 		clk_put(omap->utmi_clk[i]);
 		clk_put(omap->hsic60m_clk[i]);
-- 
1.7.4.1

