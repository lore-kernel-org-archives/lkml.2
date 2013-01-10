Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3AJQyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:54:03 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54088 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab3AJQwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:52:05 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH 10/14] usb: ehci-omap: Remove PHY regulator handling code
Date: Thu, 10 Jan 2013 18:51:30 +0200
Message-ID: <1357836694-30788-11-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357836694-30788-1-git-send-email-rogerq@ti.com>
References: <1357836694-30788-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PHY regulator handling must be done in the PHY driver

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/ehci-omap.c |   31 +------------------------------
 1 files changed, 1 insertions(+), 30 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 46b28d6..02475c7 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -39,7 +39,6 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/usb/ulpi.h>
-#include <linux/regulator/consumer.h>
 #include <linux/pm_runtime.h>
 #include <linux/gpio.h>
 #include <linux/clk.h>
@@ -105,19 +104,6 @@ static int omap_ehci_init(struct usb_hcd *hcd)
 	return rc;
 }
 
-static void disable_put_regulator(
-		struct usbhs_omap_platform_data *pdata)
-{
-	int i;
-
-	for (i = 0 ; i < OMAP3_HS_USB_PORTS ; i++) {
-		if (pdata->regulator[i]) {
-			regulator_disable(pdata->regulator[i]);
-			regulator_put(pdata->regulator[i]);
-		}
-	}
-}
-
 /* configure so an HC device and id are always provided */
 /* always called with process context; sleeping is OK */
 
@@ -140,7 +126,6 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	int					ret = -ENODEV;
 	int					irq;
 	int					i;
-	char					supply[7];
 
 	if (usb_disabled())
 		return -ENODEV;
@@ -203,24 +188,12 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, omap_hcd);
 
-	/* get ehci regulator and enable */
 	for (i = 0 ; i < omap_hcd->nports ; i++) {
 		struct platform_device *phy_pdev;
 		struct usbhs_phy_config *phy_config;
 
-		if (pdata->port_mode[i] != OMAP_EHCI_PORT_MODE_PHY) {
-			pdata->regulator[i] = NULL;
+		if (pdata->port_mode[i] != OMAP_EHCI_PORT_MODE_PHY)
 			continue;
-		}
-		snprintf(supply, sizeof(supply), "hsusb%d", i);
-		pdata->regulator[i] = regulator_get(dev, supply);
-		if (IS_ERR(pdata->regulator[i])) {
-			pdata->regulator[i] = NULL;
-			dev_dbg(dev,
-			"failed to get ehci port%d regulator\n", i);
-		} else {
-			regulator_enable(pdata->regulator[i]);
-		}
 
 		/* instantiate PHY */
 		if (!pdata->phy_config[i]) {
@@ -275,7 +248,6 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	return 0;
 
 err_pm_runtime:
-	disable_put_regulator(pdata);
 	pm_runtime_put_sync(dev);
 	usb_put_hcd(hcd);
 	for (i = 0 ; i < omap_hcd->nports ; i++) {
@@ -307,7 +279,6 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
 	int i;
 
 	usb_remove_hcd(hcd);
-	disable_put_regulator(dev->platform_data);
 	iounmap(hcd->regs);
 	usb_put_hcd(hcd);
 
-- 
1.7.4.1

