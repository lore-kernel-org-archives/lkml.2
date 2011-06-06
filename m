Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab1FFNnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:43:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36163 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168Ab1FFNni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:43:38 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <balbi@ti.com>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: [PATCH] mfd: omap: fix the crash during omap ehci or ohci driver initialization
Date: Mon, 6 Jun 2011 19:12:19 +0530
Message-ID: <1307367739-20110-1-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keshava Munegowda <Keshava_mgowda@ti.com>

Oops are produced during initialization of ehci and ohci
drivers. This is because the run time pm apis are used by
the driver but the corresponding hwmod structures and
initialization is not merged. hence revering  back the
commit id 7e6502d577106fb5b202bbaac64c5f1b065e6daa

Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
---
 drivers/mfd/omap-usb-host.c |  133 ++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 124 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 8552195..ab879e5 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -26,7 +26,6 @@
 #include <linux/spinlock.h>
 #include <linux/gpio.h>
 #include <plat/usb.h>
-#include <linux/pm_runtime.h>
 
 #define USBHS_DRIVER_NAME	"usbhs-omap"
 #define OMAP_EHCI_DEVICE	"ehci-omap"
@@ -147,6 +146,9 @@
 
 
 struct usbhs_hcd_omap {
+	struct clk			*usbhost_ick;
+	struct clk			*usbhost_hs_fck;
+	struct clk			*usbhost_fs_fck;
 	struct clk			*xclk60mhsp1_ck;
 	struct clk			*xclk60mhsp2_ck;
 	struct clk			*utmi_p1_fck;
@@ -156,6 +158,8 @@ struct usbhs_hcd_omap {
 	struct clk			*usbhost_p2_fck;
 	struct clk			*usbtll_p2_fck;
 	struct clk			*init_60m_fclk;
+	struct clk			*usbtll_fck;
+	struct clk			*usbtll_ick;
 
 	void __iomem			*uhh_base;
 	void __iomem			*tll_base;
@@ -349,13 +353,46 @@ static int __devinit usbhs_omap_probe(struct platform_device *pdev)
 	omap->platdata.ehci_data = pdata->ehci_data;
 	omap->platdata.ohci_data = pdata->ohci_data;
 
-	pm_runtime_enable(&pdev->dev);
+	omap->usbhost_ick = clk_get(dev, "usbhost_ick");
+	if (IS_ERR(omap->usbhost_ick)) {
+		ret =  PTR_ERR(omap->usbhost_ick);
+		dev_err(dev, "usbhost_ick failed error:%d\n", ret);
+		goto err_end;
+	}
+
+	omap->usbhost_hs_fck = clk_get(dev, "hs_fck");
+	if (IS_ERR(omap->usbhost_hs_fck)) {
+		ret = PTR_ERR(omap->usbhost_hs_fck);
+		dev_err(dev, "usbhost_hs_fck failed error:%d\n", ret);
+		goto err_usbhost_ick;
+	}
+
+	omap->usbhost_fs_fck = clk_get(dev, "fs_fck");
+	if (IS_ERR(omap->usbhost_fs_fck)) {
+		ret = PTR_ERR(omap->usbhost_fs_fck);
+		dev_err(dev, "usbhost_fs_fck failed error:%d\n", ret);
+		goto err_usbhost_hs_fck;
+	}
+
+	omap->usbtll_fck = clk_get(dev, "usbtll_fck");
+	if (IS_ERR(omap->usbtll_fck)) {
+		ret = PTR_ERR(omap->usbtll_fck);
+		dev_err(dev, "usbtll_fck failed error:%d\n", ret);
+		goto err_usbhost_fs_fck;
+	}
+
+	omap->usbtll_ick = clk_get(dev, "usbtll_ick");
+	if (IS_ERR(omap->usbtll_ick)) {
+		ret = PTR_ERR(omap->usbtll_ick);
+		dev_err(dev, "usbtll_ick failed error:%d\n", ret);
+		goto err_usbtll_fck;
+	}
 
 	omap->utmi_p1_fck = clk_get(dev, "utmi_p1_gfclk");
 	if (IS_ERR(omap->utmi_p1_fck)) {
 		ret = PTR_ERR(omap->utmi_p1_fck);
 		dev_err(dev, "utmi_p1_gfclk failed error:%d\n",	ret);
-		goto err_end;
+		goto err_usbtll_ick;
 	}
 
 	omap->xclk60mhsp1_ck = clk_get(dev, "xclk60mhsp1_ck");
@@ -485,8 +522,22 @@ err_xclk60mhsp1_ck:
 err_utmi_p1_fck:
 	clk_put(omap->utmi_p1_fck);
 
+err_usbtll_ick:
+	clk_put(omap->usbtll_ick);
+
+err_usbtll_fck:
+	clk_put(omap->usbtll_fck);
+
+err_usbhost_fs_fck:
+	clk_put(omap->usbhost_fs_fck);
+
+err_usbhost_hs_fck:
+	clk_put(omap->usbhost_hs_fck);
+
+err_usbhost_ick:
+	clk_put(omap->usbhost_ick);
+
 err_end:
-	pm_runtime_disable(&pdev->dev);
 	kfree(omap);
 
 end_probe:
@@ -520,7 +571,11 @@ static int __devexit usbhs_omap_remove(struct platform_device *pdev)
 	clk_put(omap->utmi_p2_fck);
 	clk_put(omap->xclk60mhsp1_ck);
 	clk_put(omap->utmi_p1_fck);
-	pm_runtime_disable(&pdev->dev);
+	clk_put(omap->usbtll_ick);
+	clk_put(omap->usbtll_fck);
+	clk_put(omap->usbhost_fs_fck);
+	clk_put(omap->usbhost_hs_fck);
+	clk_put(omap->usbhost_ick);
 	kfree(omap);
 
 	return 0;
@@ -640,6 +695,7 @@ static int usbhs_enable(struct device *dev)
 	struct usbhs_omap_platform_data	*pdata = &omap->platdata;
 	unsigned long			flags = 0;
 	int				ret = 0;
+	unsigned long			timeout;
 	unsigned			reg;
 
 	dev_dbg(dev, "starting TI HSUSB Controller\n");
@@ -652,7 +708,11 @@ static int usbhs_enable(struct device *dev)
 	if (omap->count > 0)
 		goto end_count;
 
-	pm_runtime_get_sync(dev);
+	clk_enable(omap->usbhost_ick);
+	clk_enable(omap->usbhost_hs_fck);
+	clk_enable(omap->usbhost_fs_fck);
+	clk_enable(omap->usbtll_fck);
+	clk_enable(omap->usbtll_ick);
 
 	if (pdata->ehci_data->phy_reset) {
 		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0])) {
@@ -676,6 +736,50 @@ static int usbhs_enable(struct device *dev)
 	omap->usbhs_rev = usbhs_read(omap->uhh_base, OMAP_UHH_REVISION);
 	dev_dbg(dev, "OMAP UHH_REVISION 0x%x\n", omap->usbhs_rev);
 
+	/* perform TLL soft reset, and wait until reset is complete */
+	usbhs_write(omap->tll_base, OMAP_USBTLL_SYSCONFIG,
+			OMAP_USBTLL_SYSCONFIG_SOFTRESET);
+
+	/* Wait for TLL reset to complete */
+	timeout = jiffies + msecs_to_jiffies(1000);
+	while (!(usbhs_read(omap->tll_base, OMAP_USBTLL_SYSSTATUS)
+			& OMAP_USBTLL_SYSSTATUS_RESETDONE)) {
+		cpu_relax();
+
+		if (time_after(jiffies, timeout)) {
+			dev_dbg(dev, "operation timed out\n");
+			ret = -EINVAL;
+			goto err_tll;
+		}
+	}
+
+	dev_dbg(dev, "TLL RESET DONE\n");
+
+	/* (1<<3) = no idle mode only for initial debugging */
+	usbhs_write(omap->tll_base, OMAP_USBTLL_SYSCONFIG,
+			OMAP_USBTLL_SYSCONFIG_ENAWAKEUP |
+			OMAP_USBTLL_SYSCONFIG_SIDLEMODE |
+			OMAP_USBTLL_SYSCONFIG_AUTOIDLE);
+
+	/* Put UHH in NoIdle/NoStandby mode */
+	reg = usbhs_read(omap->uhh_base, OMAP_UHH_SYSCONFIG);
+	if (is_omap_usbhs_rev1(omap)) {
+		reg |= (OMAP_UHH_SYSCONFIG_ENAWAKEUP
+				| OMAP_UHH_SYSCONFIG_SIDLEMODE
+				| OMAP_UHH_SYSCONFIG_CACTIVITY
+				| OMAP_UHH_SYSCONFIG_MIDLEMODE);
+		reg &= ~OMAP_UHH_SYSCONFIG_AUTOIDLE;
+
+
+	} else if (is_omap_usbhs_rev2(omap)) {
+		reg &= ~OMAP4_UHH_SYSCONFIG_IDLEMODE_CLEAR;
+		reg |= OMAP4_UHH_SYSCONFIG_NOIDLE;
+		reg &= ~OMAP4_UHH_SYSCONFIG_STDBYMODE_CLEAR;
+		reg |= OMAP4_UHH_SYSCONFIG_NOSTDBY;
+	}
+
+	usbhs_write(omap->uhh_base, OMAP_UHH_SYSCONFIG, reg);
+
 	reg = usbhs_read(omap->uhh_base, OMAP_UHH_HOSTCONFIG);
 	/* setup ULPI bypass and burst configurations */
 	reg |= (OMAP_UHH_HOSTCONFIG_INCR4_BURST_EN
@@ -815,7 +919,6 @@ end_count:
 	return 0;
 
 err_tll:
-	pm_runtime_put_sync(dev);
 	spin_unlock_irqrestore(&omap->lock, flags);
 	if (pdata->ehci_data->phy_reset) {
 		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0]))
@@ -824,6 +927,12 @@ err_tll:
 		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1]))
 			gpio_free(pdata->ehci_data->reset_gpio_port[1]);
 	}
+
+	clk_disable(omap->usbtll_ick);
+	clk_disable(omap->usbtll_fck);
+	clk_disable(omap->usbhost_fs_fck);
+	clk_disable(omap->usbhost_hs_fck);
+	clk_disable(omap->usbhost_ick);
 	return ret;
 }
 
@@ -896,8 +1005,6 @@ static void usbhs_disable(struct device *dev)
 		clk_disable(omap->utmi_p1_fck);
 	}
 
-	pm_runtime_put_sync(dev);
-
 	/* The gpio_free migh sleep; so unlock the spinlock */
 	spin_unlock_irqrestore(&omap->lock, flags);
 
@@ -908,6 +1015,14 @@ static void usbhs_disable(struct device *dev)
 		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1]))
 			gpio_free(pdata->ehci_data->reset_gpio_port[1]);
 	}
+
+	clk_disable(omap->utmi_p2_fck);
+	clk_disable(omap->utmi_p1_fck);
+	clk_disable(omap->usbtll_ick);
+	clk_disable(omap->usbtll_fck);
+	clk_disable(omap->usbhost_fs_fck);
+	clk_disable(omap->usbhost_hs_fck);
+	clk_disable(omap->usbhost_ick);
 	return;
 
 end_disble:
-- 
1.6.0.4

