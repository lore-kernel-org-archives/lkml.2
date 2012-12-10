Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab2LJK0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:26:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59185 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab2LJKVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:21:17 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <paul@pwsan.com>, <keshava_mgowda@ti.com>, <sshtylyov@mvista.com>,
        <bjorn@mork.no>, <rogerq@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 11/23] mfd: omap_usb_host: Avoid creating copy of platform_data
Date: Mon, 10 Dec 2012 12:20:21 +0200
Message-ID: <1355134833-5199-12-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1355134833-5199-1-git-send-email-rogerq@ti.com>
References: <1355134833-5199-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can just hold the pointer to the platform data instead
of creating a copy of it.

Also get rid of the unnecessary missing platform data checks
in runtime_suspend/resume. We are already checking for missing
platform data in probe.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/omap-usb-host.c |   30 ++++++++----------------------
 1 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index fe7906b..8b8f1da 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -103,7 +103,7 @@ struct usbhs_hcd_omap {
 
 	void __iomem			*uhh_base;
 
-	struct usbhs_omap_platform_data	platdata;
+	struct usbhs_omap_platform_data	*pdata;
 
 	u32				usbhs_rev;
 	spinlock_t			lock;
@@ -195,8 +195,8 @@ static int omap_usbhs_alloc_children(struct platform_device *pdev)
 	int					ret;
 
 	omap = platform_get_drvdata(pdev);
-	ehci_data = omap->platdata.ehci_data;
-	ohci_data = omap->platdata.ohci_data;
+	ehci_data = omap->pdata->ehci_data;
+	ohci_data = omap->pdata->ohci_data;
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ehci");
 	if (!res) {
@@ -279,16 +279,11 @@ static bool is_ohci_port(enum usbhs_omap_port_mode pmode)
 static int usbhs_runtime_resume(struct device *dev)
 {
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
-	struct usbhs_omap_platform_data	*pdata = &omap->platdata;
 	unsigned long			flags;
+	struct usbhs_omap_platform_data *pdata = omap->pdata;
 
 	dev_dbg(dev, "usbhs_runtime_resume\n");
 
-	if (!pdata) {
-		dev_dbg(dev, "missing platform_data\n");
-		return  -ENODEV;
-	}
-
 	omap_tll_enable();
 	spin_lock_irqsave(&omap->lock, flags);
 
@@ -311,16 +306,11 @@ static int usbhs_runtime_resume(struct device *dev)
 static int usbhs_runtime_suspend(struct device *dev)
 {
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
-	struct usbhs_omap_platform_data	*pdata = &omap->platdata;
 	unsigned long			flags;
+	struct usbhs_omap_platform_data *pdata = omap->pdata;
 
 	dev_dbg(dev, "usbhs_runtime_suspend\n");
 
-	if (!pdata) {
-		dev_dbg(dev, "missing platform_data\n");
-		return  -ENODEV;
-	}
-
 	spin_lock_irqsave(&omap->lock, flags);
 
 	if (is_ehci_tll_mode(pdata->port_mode[0]))
@@ -343,7 +333,7 @@ static int usbhs_runtime_suspend(struct device *dev)
 static void omap_usbhs_init(struct device *dev)
 {
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
-	struct usbhs_omap_platform_data	*pdata = &omap->platdata;
+	struct usbhs_omap_platform_data	*pdata = omap->pdata;
 	unsigned long			flags;
 	unsigned			reg;
 
@@ -450,7 +440,7 @@ static void omap_usbhs_init(struct device *dev)
 static void omap_usbhs_deinit(struct device *dev)
 {
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
-	struct usbhs_omap_platform_data	*pdata = &omap->platdata;
+	struct usbhs_omap_platform_data	*pdata = omap->pdata;
 
 	if (pdata->ehci_data->phy_reset) {
 		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0]))
@@ -491,11 +481,7 @@ static int __devinit usbhs_omap_probe(struct platform_device *pdev)
 
 	spin_lock_init(&omap->lock);
 
-	for (i = 0; i < OMAP3_HS_USB_PORTS; i++)
-		omap->platdata.port_mode[i] = pdata->port_mode[i];
-
-	omap->platdata.ehci_data = pdata->ehci_data;
-	omap->platdata.ohci_data = pdata->ohci_data;
+	omap->pdata = pdata;
 
 	pm_runtime_enable(dev);
 
-- 
1.7.4.1

