Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab3ABPD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:03:56 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56828 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab3ABPBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:01:40 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <keshava_mgowda@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <rogerq@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 16/22] mfd: omap-usb-host: Get rid of unnecessary spinlock
Date: Wed, 2 Jan 2013 17:00:36 +0200
Message-ID: <1357138842-28964-17-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357138842-28964-1-git-send-email-rogerq@ti.com>
References: <1357138842-28964-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver does not have an interrupt handler and
we don't really need a spinlock, so get rid of it.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index a58da22..bef7249 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -23,7 +23,6 @@
 #include <linux/delay.h>
 #include <linux/clk.h>
 #include <linux/dma-mapping.h>
-#include <linux/spinlock.h>
 #include <linux/gpio.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/usb-omap.h>
@@ -108,7 +107,6 @@ struct usbhs_hcd_omap {
 	struct usbhs_omap_platform_data	*pdata;
 
 	u32				usbhs_rev;
-	spinlock_t			lock;
 };
 /*-------------------------------------------------------------------------*/
 
@@ -281,14 +279,12 @@ static bool is_ohci_port(enum usbhs_omap_port_mode pmode)
 static int usbhs_runtime_resume(struct device *dev)
 {
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
-	unsigned long			flags;
 	struct usbhs_omap_platform_data *pdata = omap->pdata;
 	int i, r;
 
 	dev_dbg(dev, "usbhs_runtime_resume\n");
 
 	omap_tll_enable();
-	spin_lock_irqsave(&omap->lock, flags);
 
 	if (omap->ehci_logic_fck && !IS_ERR(omap->ehci_logic_fck))
 		clk_enable(omap->ehci_logic_fck);
@@ -330,22 +326,17 @@ static int usbhs_runtime_resume(struct device *dev)
 		}
 	}
 
-	spin_unlock_irqrestore(&omap->lock, flags);
-
 	return 0;
 }
 
 static int usbhs_runtime_suspend(struct device *dev)
 {
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
-	unsigned long			flags;
 	struct usbhs_omap_platform_data *pdata = omap->pdata;
 	int i;
 
 	dev_dbg(dev, "usbhs_runtime_suspend\n");
 
-	spin_lock_irqsave(&omap->lock, flags);
-
 	for (i = 0; i < omap->nports; i++) {
 		switch (pdata->port_mode[i]) {
 		case OMAP_EHCI_PORT_MODE_HSIC:
@@ -368,7 +359,6 @@ static int usbhs_runtime_suspend(struct device *dev)
 	if (omap->ehci_logic_fck && !IS_ERR(omap->ehci_logic_fck))
 		clk_disable(omap->ehci_logic_fck);
 
-	spin_unlock_irqrestore(&omap->lock, flags);
 	omap_tll_disable();
 
 	return 0;
@@ -378,7 +368,6 @@ static void omap_usbhs_init(struct device *dev)
 {
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
 	struct usbhs_omap_platform_data	*pdata = omap->pdata;
-	unsigned long			flags;
 	unsigned			reg;
 
 	dev_dbg(dev, "starting TI HSUSB Controller\n");
@@ -397,7 +386,6 @@ static void omap_usbhs_init(struct device *dev)
 	}
 
 	pm_runtime_get_sync(dev);
-	spin_lock_irqsave(&omap->lock, flags);
 
 	reg = usbhs_read(omap->uhh_base, OMAP_UHH_HOSTCONFIG);
 	/* setup ULPI bypass and burst configurations */
@@ -460,8 +448,6 @@ static void omap_usbhs_init(struct device *dev)
 	usbhs_write(omap->uhh_base, OMAP_UHH_HOSTCONFIG, reg);
 	dev_dbg(dev, "UHH setup done, uhh_hostconfig=%x\n", reg);
 
-	spin_unlock_irqrestore(&omap->lock, flags);
-
 	pm_runtime_put_sync(dev);
 	if (pdata->ehci_data->phy_reset) {
 		/* Hold the PHY in RESET for enough time till
@@ -525,8 +511,6 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 	if (!omap->uhh_base)
 		return -EADDRNOTAVAIL;
 
-	spin_lock_init(&omap->lock);
-
 	omap->pdata = pdata;
 
 	pm_runtime_enable(dev);
-- 
1.7.4.1

