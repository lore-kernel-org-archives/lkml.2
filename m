Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab1EPJJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:09:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51434 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab1EPJJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:09:05 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <balbi@ti.com>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: [RESEND][PATCH 3/5] arm: omap: usb: device name change for the clk names of usbhs
Date: Mon, 16 May 2011 14:34:56 +0530
Message-ID: <1305536697-20147-5-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1305536697-20147-4-git-send-email-keshava_mgowda@ti.com>
References: <1305536697-20147-1-git-send-email-keshava_mgowda@ti.com>
 <1305536697-20147-2-git-send-email-keshava_mgowda@ti.com>
 <1305536697-20147-3-git-send-email-keshava_mgowda@ti.com>
 <1305536697-20147-4-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keshava Munegowda <Keshava_mgowda@ti.com>

The usbhs core driver does not enable/disable the intefrace and
fucntional clocks; These clocks are handled by hwmod and runtime pm,
hence insted of the clock enable/disable, the runtime pm APIS are
used. however,the port clocks and tll clocks are handled
by the usbhs core.

Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
---
 drivers/mfd/omap-usb-host.c |  131 +++----------------------------------------
 1 files changed, 9 insertions(+), 122 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 48ada2d..bd63429 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -26,6 +26,7 @@
 #include <linux/spinlock.h>
 #include <linux/gpio.h>
 #include <plat/usb.h>
+#include <linux/pm_runtime.h>
 
 #define USBHS_DRIVER_NAME	"usbhs_omap"
 #define OMAP_EHCI_DEVICE	"ehci-omap"
@@ -146,9 +147,6 @@
 
 
 struct usbhs_hcd_omap {
-	struct clk			*usbhost_ick;
-	struct clk			*usbhost_hs_fck;
-	struct clk			*usbhost_fs_fck;
 	struct clk			*xclk60mhsp1_ck;
 	struct clk			*xclk60mhsp2_ck;
 	struct clk			*utmi_p1_fck;
@@ -158,8 +156,6 @@ struct usbhs_hcd_omap {
 	struct clk			*usbhost_p2_fck;
 	struct clk			*usbtll_p2_fck;
 	struct clk			*init_60m_fclk;
-	struct clk			*usbtll_fck;
-	struct clk			*usbtll_ick;
 
 	void __iomem			*uhh_base;
 	void __iomem			*tll_base;
@@ -351,46 +347,13 @@ static int __devinit usbhs_omap_probe(struct platform_device *pdev)
 	omap->platdata.ehci_data = pdata->ehci_data;
 	omap->platdata.ohci_data = pdata->ohci_data;
 
-	omap->usbhost_ick = clk_get(dev, "usbhost_ick");
-	if (IS_ERR(omap->usbhost_ick)) {
-		ret =  PTR_ERR(omap->usbhost_ick);
-		dev_err(dev, "usbhost_ick failed error:%d\n", ret);
-		goto err_end;
-	}
-
-	omap->usbhost_hs_fck = clk_get(dev, "hs_fck");
-	if (IS_ERR(omap->usbhost_hs_fck)) {
-		ret = PTR_ERR(omap->usbhost_hs_fck);
-		dev_err(dev, "usbhost_hs_fck failed error:%d\n", ret);
-		goto err_usbhost_ick;
-	}
-
-	omap->usbhost_fs_fck = clk_get(dev, "fs_fck");
-	if (IS_ERR(omap->usbhost_fs_fck)) {
-		ret = PTR_ERR(omap->usbhost_fs_fck);
-		dev_err(dev, "usbhost_fs_fck failed error:%d\n", ret);
-		goto err_usbhost_hs_fck;
-	}
-
-	omap->usbtll_fck = clk_get(dev, "usbtll_fck");
-	if (IS_ERR(omap->usbtll_fck)) {
-		ret = PTR_ERR(omap->usbtll_fck);
-		dev_err(dev, "usbtll_fck failed error:%d\n", ret);
-		goto err_usbhost_fs_fck;
-	}
-
-	omap->usbtll_ick = clk_get(dev, "usbtll_ick");
-	if (IS_ERR(omap->usbtll_ick)) {
-		ret = PTR_ERR(omap->usbtll_ick);
-		dev_err(dev, "usbtll_ick failed error:%d\n", ret);
-		goto err_usbtll_fck;
-	}
+	pm_runtime_enable(&pdev->dev);
 
 	omap->utmi_p1_fck = clk_get(dev, "utmi_p1_gfclk");
 	if (IS_ERR(omap->utmi_p1_fck)) {
 		ret = PTR_ERR(omap->utmi_p1_fck);
 		dev_err(dev, "utmi_p1_gfclk failed error:%d\n",	ret);
-		goto err_usbtll_ick;
+		goto err_end;
 	}
 
 	omap->xclk60mhsp1_ck = clk_get(dev, "xclk60mhsp1_ck");
@@ -520,22 +483,8 @@ err_xclk60mhsp1_ck:
 err_utmi_p1_fck:
 	clk_put(omap->utmi_p1_fck);
 
-err_usbtll_ick:
-	clk_put(omap->usbtll_ick);
-
-err_usbtll_fck:
-	clk_put(omap->usbtll_fck);
-
-err_usbhost_fs_fck:
-	clk_put(omap->usbhost_fs_fck);
-
-err_usbhost_hs_fck:
-	clk_put(omap->usbhost_hs_fck);
-
-err_usbhost_ick:
-	clk_put(omap->usbhost_ick);
-
 err_end:
+	pm_runtime_disable(&pdev->dev);
 	kfree(omap);
 
 end_probe:
@@ -569,11 +518,7 @@ static int __devexit usbhs_omap_remove(struct platform_device *pdev)
 	clk_put(omap->utmi_p2_fck);
 	clk_put(omap->xclk60mhsp1_ck);
 	clk_put(omap->utmi_p1_fck);
-	clk_put(omap->usbtll_ick);
-	clk_put(omap->usbtll_fck);
-	clk_put(omap->usbhost_fs_fck);
-	clk_put(omap->usbhost_hs_fck);
-	clk_put(omap->usbhost_ick);
+	pm_runtime_disable(&pdev->dev);
 	kfree(omap);
 
 	return 0;
@@ -693,7 +638,6 @@ static int usbhs_enable(struct device *dev)
 	struct usbhs_omap_platform_data	*pdata = &omap->platdata;
 	unsigned long			flags = 0;
 	int				ret = 0;
-	unsigned long			timeout;
 	unsigned			reg;
 
 	dev_dbg(dev, "starting TI HSUSB Controller\n");
@@ -706,11 +650,7 @@ static int usbhs_enable(struct device *dev)
 	if (omap->count > 0)
 		goto end_count;
 
-	clk_enable(omap->usbhost_ick);
-	clk_enable(omap->usbhost_hs_fck);
-	clk_enable(omap->usbhost_fs_fck);
-	clk_enable(omap->usbtll_fck);
-	clk_enable(omap->usbtll_ick);
+	pm_runtime_get_sync(dev);
 
 	if (pdata->ehci_data->phy_reset) {
 		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0])) {
@@ -734,50 +674,6 @@ static int usbhs_enable(struct device *dev)
 	omap->usbhs_rev = usbhs_read(omap->uhh_base, OMAP_UHH_REVISION);
 	dev_dbg(dev, "OMAP UHH_REVISION 0x%x\n", omap->usbhs_rev);
 
-	/* perform TLL soft reset, and wait until reset is complete */
-	usbhs_write(omap->tll_base, OMAP_USBTLL_SYSCONFIG,
-			OMAP_USBTLL_SYSCONFIG_SOFTRESET);
-
-	/* Wait for TLL reset to complete */
-	timeout = jiffies + msecs_to_jiffies(1000);
-	while (!(usbhs_read(omap->tll_base, OMAP_USBTLL_SYSSTATUS)
-			& OMAP_USBTLL_SYSSTATUS_RESETDONE)) {
-		cpu_relax();
-
-		if (time_after(jiffies, timeout)) {
-			dev_dbg(dev, "operation timed out\n");
-			ret = -EINVAL;
-			goto err_tll;
-		}
-	}
-
-	dev_dbg(dev, "TLL RESET DONE\n");
-
-	/* (1<<3) = no idle mode only for initial debugging */
-	usbhs_write(omap->tll_base, OMAP_USBTLL_SYSCONFIG,
-			OMAP_USBTLL_SYSCONFIG_ENAWAKEUP |
-			OMAP_USBTLL_SYSCONFIG_SIDLEMODE |
-			OMAP_USBTLL_SYSCONFIG_AUTOIDLE);
-
-	/* Put UHH in NoIdle/NoStandby mode */
-	reg = usbhs_read(omap->uhh_base, OMAP_UHH_SYSCONFIG);
-	if (is_omap_usbhs_rev1(omap)) {
-		reg |= (OMAP_UHH_SYSCONFIG_ENAWAKEUP
-				| OMAP_UHH_SYSCONFIG_SIDLEMODE
-				| OMAP_UHH_SYSCONFIG_CACTIVITY
-				| OMAP_UHH_SYSCONFIG_MIDLEMODE);
-		reg &= ~OMAP_UHH_SYSCONFIG_AUTOIDLE;
-
-
-	} else if (is_omap_usbhs_rev2(omap)) {
-		reg &= ~OMAP4_UHH_SYSCONFIG_IDLEMODE_CLEAR;
-		reg |= OMAP4_UHH_SYSCONFIG_NOIDLE;
-		reg &= ~OMAP4_UHH_SYSCONFIG_STDBYMODE_CLEAR;
-		reg |= OMAP4_UHH_SYSCONFIG_NOSTDBY;
-	}
-
-	usbhs_write(omap->uhh_base, OMAP_UHH_SYSCONFIG, reg);
-
 	reg = usbhs_read(omap->uhh_base, OMAP_UHH_HOSTCONFIG);
 	/* setup ULPI bypass and burst configurations */
 	reg |= (OMAP_UHH_HOSTCONFIG_INCR4_BURST_EN
@@ -917,6 +813,8 @@ end_count:
 	return 0;
 
 err_tll:
+	pm_runtime_put_sync(dev);
+	spin_unlock_irqrestore(&omap->lock, flags);
 	if (pdata->ehci_data->phy_reset) {
 		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0]))
 			gpio_free(pdata->ehci_data->reset_gpio_port[0]);
@@ -924,13 +822,6 @@ err_tll:
 		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1]))
 			gpio_free(pdata->ehci_data->reset_gpio_port[1]);
 	}
-
-	clk_disable(omap->usbtll_ick);
-	clk_disable(omap->usbtll_fck);
-	clk_disable(omap->usbhost_fs_fck);
-	clk_disable(omap->usbhost_hs_fck);
-	clk_disable(omap->usbhost_ick);
-	spin_unlock_irqrestore(&omap->lock, flags);
 	return ret;
 }
 
@@ -1003,11 +894,7 @@ static void usbhs_disable(struct device *dev)
 		clk_disable(omap->utmi_p1_fck);
 	}
 
-	clk_disable(omap->usbtll_ick);
-	clk_disable(omap->usbtll_fck);
-	clk_disable(omap->usbhost_fs_fck);
-	clk_disable(omap->usbhost_hs_fck);
-	clk_disable(omap->usbhost_ick);
+	pm_runtime_put_sync(dev);
 
 	/* The gpio_free migh sleep; so unlock the spinlock */
 	spin_unlock_irqrestore(&omap->lock, flags);
-- 
1.6.0.4

