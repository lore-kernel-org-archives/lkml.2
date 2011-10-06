Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868Ab1JFLk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 07:40:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38122 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964850Ab1JFLkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 07:40:21 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>, <khilman@ti.com>,
        <b-cousson@ti.com>, <paul@pwsan.com>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: [PATCH 5/5 v13] omap: usb: host: Replace usbhs core driver APIs by Runtime pm APIs
Date: Thu, 6 Oct 2011 17:09:32 +0530
Message-ID: <1317901172-2678-1-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keshava Munegowda <Keshava_mgowda@ti.com>

The ehci and ohci drivers does not use the APIs of the usbhs
core driver; the runtime pm APIs are used for clock
enable/disable. Since usbhs is parent platform device of the
ehci and ohci devices, the runtime apis indirectly uses the
usb hs core device as input parameter to for clock functions.

Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
Reviewed-by: Kevin Hilman <khilman@ti.com>
Reviewed-by: Partha Basak <parthab@india.ti.com>
---
 arch/arm/plat-omap/include/plat/usb.h |    3 ---
 drivers/usb/host/ehci-omap.c          |   17 +++++++----------
 drivers/usb/host/ohci-omap3.c         |   18 +++++++-----------
 3 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/usb.h b/arch/arm/plat-omap/include/plat/usb.h
index 17d3c93..2b66dc2 100644
--- a/arch/arm/plat-omap/include/plat/usb.h
+++ b/arch/arm/plat-omap/include/plat/usb.h
@@ -100,9 +100,6 @@ extern void usb_musb_init(struct omap_musb_board_data *board_data);
 
 extern void usbhs_init(const struct usbhs_omap_board_data *pdata);
 
-extern int omap_usbhs_enable(struct device *dev);
-extern void omap_usbhs_disable(struct device *dev);
-
 extern int omap4430_phy_power(struct device *dev, int ID, int on);
 extern int omap4430_phy_set_clk(struct device *dev, int on);
 extern int omap4430_phy_init(struct device *dev);
diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 4524032..82cd3ea 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -41,6 +41,7 @@
 #include <linux/usb/ulpi.h>
 #include <plat/usb.h>
 #include <linux/regulator/consumer.h>
+#include <linux/pm_runtime.h>
 
 /* EHCI Register Set */
 #define EHCI_INSNREG04					(0xA0)
@@ -190,11 +191,8 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 		}
 	}
 
-	ret = omap_usbhs_enable(dev);
-	if (ret) {
-		dev_err(dev, "failed to start usbhs with err %d\n", ret);
-		goto err_enable;
-	}
+	pm_runtime_enable(dev);
+	pm_runtime_get_sync(dev);
 
 	/*
 	 * An undocumented "feature" in the OMAP3 EHCI controller,
@@ -240,11 +238,8 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	return 0;
 
 err_add_hcd:
-	omap_usbhs_disable(dev);
-
-err_enable:
 	disable_put_regulator(pdata);
-	usb_put_hcd(hcd);
+	pm_runtime_put_sync(dev);
 
 err_io:
 	iounmap(regs);
@@ -266,10 +261,12 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
 	struct usb_hcd *hcd	= dev_get_drvdata(dev);
 
 	usb_remove_hcd(hcd);
-	omap_usbhs_disable(dev);
 	disable_put_regulator(dev->platform_data);
 	iounmap(hcd->regs);
 	usb_put_hcd(hcd);
+	pm_runtime_put_sync(dev);
+	pm_runtime_disable(dev);
+
 	return 0;
 }
 
diff --git a/drivers/usb/host/ohci-omap3.c b/drivers/usb/host/ohci-omap3.c
index 6048f2f..6cfedaf 100644
--- a/drivers/usb/host/ohci-omap3.c
+++ b/drivers/usb/host/ohci-omap3.c
@@ -31,6 +31,7 @@
 
 #include <linux/platform_device.h>
 #include <plat/usb.h>
+#include <linux/pm_runtime.h>
 
 /*-------------------------------------------------------------------------*/
 
@@ -134,7 +135,7 @@ static int __devinit ohci_hcd_omap3_probe(struct platform_device *pdev)
 	int			irq;
 
 	if (usb_disabled())
-		goto err_end;
+		return -ENODEV;
 
 	if (!dev->parent) {
 		dev_err(dev, "Missing parent device\n");
@@ -172,11 +173,8 @@ static int __devinit ohci_hcd_omap3_probe(struct platform_device *pdev)
 	hcd->rsrc_len = resource_size(res);
 	hcd->regs =  regs;
 
-	ret = omap_usbhs_enable(dev);
-	if (ret) {
-		dev_dbg(dev, "failed to start ohci\n");
-		goto err_end;
-	}
+	pm_runtime_enable(dev);
+	pm_runtime_get_sync(dev);
 
 	ohci_hcd_init(hcd_to_ohci(hcd));
 
@@ -189,9 +187,7 @@ static int __devinit ohci_hcd_omap3_probe(struct platform_device *pdev)
 	return 0;
 
 err_add_hcd:
-	omap_usbhs_disable(dev);
-
-err_end:
+	pm_runtime_put_sync(dev);
 	usb_put_hcd(hcd);
 
 err_io:
@@ -220,9 +216,9 @@ static int __devexit ohci_hcd_omap3_remove(struct platform_device *pdev)
 
 	iounmap(hcd->regs);
 	usb_remove_hcd(hcd);
-	omap_usbhs_disable(dev);
+	pm_runtime_put_sync(dev);
+	pm_runtime_disable(dev);
 	usb_put_hcd(hcd);
-
 	return 0;
 }
 
-- 
1.6.0.4

