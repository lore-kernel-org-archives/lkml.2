Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab1I2OKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:10:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59134 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab1I2OJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:09:01 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>, <khilman@ti.com>,
        <b-cousson@ti.com>, <paul@pwsan.com>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: [PATCH 5/5] mfd: omap: usb: Runtime PM support
Date: Thu, 29 Sep 2011 19:37:21 +0530
Message-ID: <1317305241-611-6-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1317305241-611-5-git-send-email-keshava_mgowda@ti.com>
References: <1317305241-611-1-git-send-email-keshava_mgowda@ti.com>
 <1317305241-611-2-git-send-email-keshava_mgowda@ti.com>
 <1317305241-611-3-git-send-email-keshava_mgowda@ti.com>
 <1317305241-611-4-git-send-email-keshava_mgowda@ti.com>
 <1317305241-611-5-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keshava Munegowda <Keshava_mgowda@ti.com>

The usbhs core driver does not enable/disable the interface and
functional clocks directly, These clocks are handled by runtime pm,
hence instead of the clock enable/disable, the runtime pm APIS are
used. however,the optional clocks and port clocks are handled by
the usbhs core.

Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
Reviewed-by: Kevin Hilman <khilman@ti.com>
Reviewed-by: Partha Basak <parthab@india.ti.com>
---
 arch/arm/plat-omap/include/plat/usb.h |    3 -
 drivers/mfd/omap-usb-host.c           |  746 +++++++++++++--------------------
 drivers/usb/host/ehci-omap.c          |   17 +-
 drivers/usb/host/ohci-omap3.c         |   18 +-
 4 files changed, 310 insertions(+), 474 deletions(-)

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
diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 9c2da29..a1d1843 100644
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
@@ -158,8 +156,7 @@ struct usbhs_hcd_omap {
 	struct clk			*usbhost_p2_fck;
 	struct clk			*usbtll_p2_fck;
 	struct clk			*init_60m_fclk;
-	struct clk			*usbtll_fck;
-	struct clk			*usbtll_ick;
+	struct clk			*opt_clk;
 
 	void __iomem			*uhh_base;
 	void __iomem			*tll_base;
@@ -168,7 +165,6 @@ struct usbhs_hcd_omap {
 
 	u32				usbhs_rev;
 	spinlock_t			lock;
-	int				count;
 };
 /*-------------------------------------------------------------------------*/
 
@@ -318,269 +314,6 @@ err_end:
 	return ret;
 }
 
-/**
- * usbhs_omap_probe - initialize TI-based HCDs
- *
- * Allocates basic resources for this USB host controller.
- */
-static int __devinit usbhs_omap_probe(struct platform_device *pdev)
-{
-	struct device			*dev =  &pdev->dev;
-	struct usbhs_omap_platform_data	*pdata = dev->platform_data;
-	struct usbhs_hcd_omap		*omap;
-	struct resource			*res;
-	int				ret = 0;
-	int				i;
-
-	if (!pdata) {
-		dev_err(dev, "Missing platform data\n");
-		ret = -ENOMEM;
-		goto end_probe;
-	}
-
-	omap = kzalloc(sizeof(*omap), GFP_KERNEL);
-	if (!omap) {
-		dev_err(dev, "Memory allocation failed\n");
-		ret = -ENOMEM;
-		goto end_probe;
-	}
-
-	spin_lock_init(&omap->lock);
-
-	for (i = 0; i < OMAP3_HS_USB_PORTS; i++)
-		omap->platdata.port_mode[i] = pdata->port_mode[i];
-
-	omap->platdata.ehci_data = pdata->ehci_data;
-	omap->platdata.ohci_data = pdata->ohci_data;
-
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
-
-	omap->utmi_p1_fck = clk_get(dev, "utmi_p1_gfclk");
-	if (IS_ERR(omap->utmi_p1_fck)) {
-		ret = PTR_ERR(omap->utmi_p1_fck);
-		dev_err(dev, "utmi_p1_gfclk failed error:%d\n",	ret);
-		goto err_usbtll_ick;
-	}
-
-	omap->xclk60mhsp1_ck = clk_get(dev, "xclk60mhsp1_ck");
-	if (IS_ERR(omap->xclk60mhsp1_ck)) {
-		ret = PTR_ERR(omap->xclk60mhsp1_ck);
-		dev_err(dev, "xclk60mhsp1_ck failed error:%d\n", ret);
-		goto err_utmi_p1_fck;
-	}
-
-	omap->utmi_p2_fck = clk_get(dev, "utmi_p2_gfclk");
-	if (IS_ERR(omap->utmi_p2_fck)) {
-		ret = PTR_ERR(omap->utmi_p2_fck);
-		dev_err(dev, "utmi_p2_gfclk failed error:%d\n", ret);
-		goto err_xclk60mhsp1_ck;
-	}
-
-	omap->xclk60mhsp2_ck = clk_get(dev, "xclk60mhsp2_ck");
-	if (IS_ERR(omap->xclk60mhsp2_ck)) {
-		ret = PTR_ERR(omap->xclk60mhsp2_ck);
-		dev_err(dev, "xclk60mhsp2_ck failed error:%d\n", ret);
-		goto err_utmi_p2_fck;
-	}
-
-	omap->usbhost_p1_fck = clk_get(dev, "usb_host_hs_utmi_p1_clk");
-	if (IS_ERR(omap->usbhost_p1_fck)) {
-		ret = PTR_ERR(omap->usbhost_p1_fck);
-		dev_err(dev, "usbhost_p1_fck failed error:%d\n", ret);
-		goto err_xclk60mhsp2_ck;
-	}
-
-	omap->usbtll_p1_fck = clk_get(dev, "usb_tll_hs_usb_ch0_clk");
-	if (IS_ERR(omap->usbtll_p1_fck)) {
-		ret = PTR_ERR(omap->usbtll_p1_fck);
-		dev_err(dev, "usbtll_p1_fck failed error:%d\n", ret);
-		goto err_usbhost_p1_fck;
-	}
-
-	omap->usbhost_p2_fck = clk_get(dev, "usb_host_hs_utmi_p2_clk");
-	if (IS_ERR(omap->usbhost_p2_fck)) {
-		ret = PTR_ERR(omap->usbhost_p2_fck);
-		dev_err(dev, "usbhost_p2_fck failed error:%d\n", ret);
-		goto err_usbtll_p1_fck;
-	}
-
-	omap->usbtll_p2_fck = clk_get(dev, "usb_tll_hs_usb_ch1_clk");
-	if (IS_ERR(omap->usbtll_p2_fck)) {
-		ret = PTR_ERR(omap->usbtll_p2_fck);
-		dev_err(dev, "usbtll_p2_fck failed error:%d\n", ret);
-		goto err_usbhost_p2_fck;
-	}
-
-	omap->init_60m_fclk = clk_get(dev, "init_60m_fclk");
-	if (IS_ERR(omap->init_60m_fclk)) {
-		ret = PTR_ERR(omap->init_60m_fclk);
-		dev_err(dev, "init_60m_fclk failed error:%d\n", ret);
-		goto err_usbtll_p2_fck;
-	}
-
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "uhh");
-	if (!res) {
-		dev_err(dev, "UHH EHCI get resource failed\n");
-		ret = -ENODEV;
-		goto err_init_60m_fclk;
-	}
-
-	omap->uhh_base = ioremap(res->start, resource_size(res));
-	if (!omap->uhh_base) {
-		dev_err(dev, "UHH ioremap failed\n");
-		ret = -ENOMEM;
-		goto err_init_60m_fclk;
-	}
-
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "tll");
-	if (!res) {
-		dev_err(dev, "UHH EHCI get resource failed\n");
-		ret = -ENODEV;
-		goto err_tll;
-	}
-
-	omap->tll_base = ioremap(res->start, resource_size(res));
-	if (!omap->tll_base) {
-		dev_err(dev, "TLL ioremap failed\n");
-		ret = -ENOMEM;
-		goto err_tll;
-	}
-
-	platform_set_drvdata(pdev, omap);
-
-	ret = omap_usbhs_alloc_children(pdev);
-	if (ret) {
-		dev_err(dev, "omap_usbhs_alloc_children failed\n");
-		goto err_alloc;
-	}
-
-	goto end_probe;
-
-err_alloc:
-	iounmap(omap->tll_base);
-
-err_tll:
-	iounmap(omap->uhh_base);
-
-err_init_60m_fclk:
-	clk_put(omap->init_60m_fclk);
-
-err_usbtll_p2_fck:
-	clk_put(omap->usbtll_p2_fck);
-
-err_usbhost_p2_fck:
-	clk_put(omap->usbhost_p2_fck);
-
-err_usbtll_p1_fck:
-	clk_put(omap->usbtll_p1_fck);
-
-err_usbhost_p1_fck:
-	clk_put(omap->usbhost_p1_fck);
-
-err_xclk60mhsp2_ck:
-	clk_put(omap->xclk60mhsp2_ck);
-
-err_utmi_p2_fck:
-	clk_put(omap->utmi_p2_fck);
-
-err_xclk60mhsp1_ck:
-	clk_put(omap->xclk60mhsp1_ck);
-
-err_utmi_p1_fck:
-	clk_put(omap->utmi_p1_fck);
-
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
-err_end:
-	kfree(omap);
-
-end_probe:
-	return ret;
-}
-
-/**
- * usbhs_omap_remove - shutdown processing for UHH & TLL HCDs
- * @pdev: USB Host Controller being removed
- *
- * Reverses the effect of usbhs_omap_probe().
- */
-static int __devexit usbhs_omap_remove(struct platform_device *pdev)
-{
-	struct usbhs_hcd_omap *omap = platform_get_drvdata(pdev);
-
-	if (omap->count != 0) {
-		dev_err(&pdev->dev,
-			"Either EHCI or OHCI is still using usbhs core\n");
-		return -EBUSY;
-	}
-
-	iounmap(omap->tll_base);
-	iounmap(omap->uhh_base);
-	clk_put(omap->init_60m_fclk);
-	clk_put(omap->usbtll_p2_fck);
-	clk_put(omap->usbhost_p2_fck);
-	clk_put(omap->usbtll_p1_fck);
-	clk_put(omap->usbhost_p1_fck);
-	clk_put(omap->xclk60mhsp2_ck);
-	clk_put(omap->utmi_p2_fck);
-	clk_put(omap->xclk60mhsp1_ck);
-	clk_put(omap->utmi_p1_fck);
-	clk_put(omap->usbtll_ick);
-	clk_put(omap->usbtll_fck);
-	clk_put(omap->usbhost_fs_fck);
-	clk_put(omap->usbhost_hs_fck);
-	clk_put(omap->usbhost_ick);
-	kfree(omap);
-
-	return 0;
-}
-
 static bool is_ohci_port(enum usbhs_omap_port_mode pmode)
 {
 	switch (pmode) {
@@ -687,30 +420,85 @@ static void usbhs_omap_tll_init(struct device *dev, u8 tll_channel_count)
 	}
 }
 
-static int usbhs_enable(struct device *dev)
+static int usbhs_runtime_resume(struct device *dev)
 {
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
 	struct usbhs_omap_platform_data	*pdata = &omap->platdata;
-	unsigned long			flags = 0;
-	int				ret = 0;
-	unsigned long			timeout;
-	unsigned			reg;
+	unsigned long			flags;
+
+	dev_dbg(dev, "usbhs_runtime_resume\n");
+
+	if (!pdata) {
+		dev_dbg(dev, "missing platform_data\n");
+		return  -ENODEV;
+	}
+
+	spin_lock_irqsave(&omap->lock, flags);
+
+	if (!IS_ERR(omap->opt_clk))
+		clk_enable(omap->opt_clk);
+
+	if (is_ehci_tll_mode(pdata->port_mode[0])) {
+		clk_enable(omap->usbhost_p1_fck);
+		clk_enable(omap->usbtll_p1_fck);
+	}
+	if (is_ehci_tll_mode(pdata->port_mode[1])) {
+		clk_enable(omap->usbhost_p2_fck);
+		clk_enable(omap->usbtll_p2_fck);
+	}
+	clk_enable(omap->utmi_p1_fck);
+	clk_enable(omap->utmi_p2_fck);
+
+	spin_unlock_irqrestore(&omap->lock, flags);
+
+	return 0;
+}
+
+static int usbhs_runtime_suspend(struct device *dev)
+{
+	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
+	struct usbhs_omap_platform_data	*pdata = &omap->platdata;
+	unsigned long			flags;
+
+	dev_dbg(dev, "usbhs_runtime_suspend\n");
 
-	dev_dbg(dev, "starting TI HSUSB Controller\n");
 	if (!pdata) {
 		dev_dbg(dev, "missing platform_data\n");
 		return  -ENODEV;
 	}
 
 	spin_lock_irqsave(&omap->lock, flags);
-	if (omap->count > 0)
-		goto end_count;
 
-	clk_enable(omap->usbhost_ick);
-	clk_enable(omap->usbhost_hs_fck);
-	clk_enable(omap->usbhost_fs_fck);
-	clk_enable(omap->usbtll_fck);
-	clk_enable(omap->usbtll_ick);
+	if (is_ehci_tll_mode(pdata->port_mode[0])) {
+		clk_disable(omap->usbhost_p1_fck);
+		clk_disable(omap->usbtll_p1_fck);
+	}
+	if (is_ehci_tll_mode(pdata->port_mode[1])) {
+		clk_disable(omap->usbhost_p2_fck);
+		clk_disable(omap->usbtll_p2_fck);
+	}
+	clk_disable(omap->utmi_p2_fck);
+	clk_disable(omap->utmi_p1_fck);
+
+	if (!IS_ERR(omap->opt_clk))
+		clk_disable(omap->opt_clk);
+
+	spin_unlock_irqrestore(&omap->lock, flags);
+
+	return 0;
+}
+
+static void omap_usbhs_init(struct device *dev)
+{
+	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
+	struct usbhs_omap_platform_data	*pdata = &omap->platdata;
+	unsigned long			flags;
+	unsigned			reg;
+
+	dev_dbg(dev, "starting TI HSUSB Controller\n");
+
+	pm_runtime_get_sync(dev);
+	spin_lock_irqsave(&omap->lock, flags);
 
 	if (pdata->ehci_data->phy_reset) {
 		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0])) {
@@ -734,50 +522,6 @@ static int usbhs_enable(struct device *dev)
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
@@ -823,49 +567,6 @@ static int usbhs_enable(struct device *dev)
 		reg &= ~OMAP4_P1_MODE_CLEAR;
 		reg &= ~OMAP4_P2_MODE_CLEAR;
 
-		if (is_ehci_phy_mode(pdata->port_mode[0])) {
-			ret = clk_set_parent(omap->utmi_p1_fck,
-						omap->xclk60mhsp1_ck);
-			if (ret != 0) {
-				dev_err(dev, "xclk60mhsp1_ck set parent"
-				"failed error:%d\n", ret);
-				goto err_tll;
-			}
-		} else if (is_ehci_tll_mode(pdata->port_mode[0])) {
-			ret = clk_set_parent(omap->utmi_p1_fck,
-						omap->init_60m_fclk);
-			if (ret != 0) {
-				dev_err(dev, "init_60m_fclk set parent"
-				"failed error:%d\n", ret);
-				goto err_tll;
-			}
-			clk_enable(omap->usbhost_p1_fck);
-			clk_enable(omap->usbtll_p1_fck);
-		}
-
-		if (is_ehci_phy_mode(pdata->port_mode[1])) {
-			ret = clk_set_parent(omap->utmi_p2_fck,
-						omap->xclk60mhsp2_ck);
-			if (ret != 0) {
-				dev_err(dev, "xclk60mhsp1_ck set parent"
-					"failed error:%d\n", ret);
-				goto err_tll;
-			}
-		} else if (is_ehci_tll_mode(pdata->port_mode[1])) {
-			ret = clk_set_parent(omap->utmi_p2_fck,
-						omap->init_60m_fclk);
-			if (ret != 0) {
-				dev_err(dev, "init_60m_fclk set parent"
-				"failed error:%d\n", ret);
-				goto err_tll;
-			}
-			clk_enable(omap->usbhost_p2_fck);
-			clk_enable(omap->usbtll_p2_fck);
-		}
-
-		clk_enable(omap->utmi_p1_fck);
-		clk_enable(omap->utmi_p2_fck);
-
 		if (is_ehci_tll_mode(pdata->port_mode[0]) ||
 			(is_ohci_port(pdata->port_mode[0])))
 			reg |= OMAP4_P1_MODE_TLL;
@@ -911,12 +612,15 @@ static int usbhs_enable(struct device *dev)
 				(pdata->ehci_data->reset_gpio_port[1], 1);
 	}
 
-end_count:
-	omap->count++;
 	spin_unlock_irqrestore(&omap->lock, flags);
-	return 0;
+	pm_runtime_put_sync(dev);
+}
+
+static void omap_usbhs_deinit(struct device *dev)
+{
+	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
+	struct usbhs_omap_platform_data	*pdata = &omap->platdata;
 
-err_tll:
 	if (pdata->ehci_data->phy_reset) {
 		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0]))
 			gpio_free(pdata->ehci_data->reset_gpio_port[0]);
@@ -924,123 +628,265 @@ err_tll:
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
-	return ret;
 }
 
-static void usbhs_disable(struct device *dev)
+
+/**
+ * usbhs_omap_probe - initialize TI-based HCDs
+ *
+ * Allocates basic resources for this USB host controller.
+ */
+static int __devinit usbhs_omap_probe(struct platform_device *pdev)
 {
-	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
-	struct usbhs_omap_platform_data	*pdata = &omap->platdata;
-	unsigned long			flags = 0;
-	unsigned long			timeout;
+	struct device			*dev =  &pdev->dev;
+	struct usbhs_omap_platform_data	*pdata = dev->platform_data;
+	struct usbhs_hcd_omap		*omap;
+	struct resource			*res;
+	int				ret = 0;
+	int				i;
 
-	dev_dbg(dev, "stopping TI HSUSB Controller\n");
+	if (!pdata) {
+		dev_err(dev, "Missing platform data\n");
+		ret = -ENOMEM;
+		goto end_probe;
+	}
 
-	spin_lock_irqsave(&omap->lock, flags);
+	omap = kzalloc(sizeof(*omap), GFP_KERNEL);
+	if (!omap) {
+		dev_err(dev, "Memory allocation failed\n");
+		ret = -ENOMEM;
+		goto end_probe;
+	}
 
-	if (omap->count == 0)
-		goto end_disble;
+	spin_lock_init(&omap->lock);
 
-	omap->count--;
+	for (i = 0; i < OMAP3_HS_USB_PORTS; i++)
+		omap->platdata.port_mode[i] = pdata->port_mode[i];
 
-	if (omap->count != 0)
-		goto end_disble;
+	omap->platdata.ehci_data = pdata->ehci_data;
+	omap->platdata.ohci_data = pdata->ohci_data;
 
-	/* Reset OMAP modules for insmod/rmmod to work */
-	usbhs_write(omap->uhh_base, OMAP_UHH_SYSCONFIG,
-			is_omap_usbhs_rev2(omap) ?
-			OMAP4_UHH_SYSCONFIG_SOFTRESET :
-			OMAP_UHH_SYSCONFIG_SOFTRESET);
+	pm_runtime_enable(dev);
 
-	timeout = jiffies + msecs_to_jiffies(100);
-	while (!(usbhs_read(omap->uhh_base, OMAP_UHH_SYSSTATUS)
-				& (1 << 0))) {
-		cpu_relax();
+	omap->opt_clk = clk_get(dev, "usbhost_fck2");
+	if (IS_ERR(omap->opt_clk)) {
+		ret = PTR_ERR(omap->opt_clk);
+		dev_warn(dev, "usbhost_fck2 failed:%d\n", ret);
+	}
 
-		if (time_after(jiffies, timeout))
-			dev_dbg(dev, "operation timed out\n");
+	omap->utmi_p1_fck = clk_get(dev, "utmi_p1_gfclk");
+	if (IS_ERR(omap->utmi_p1_fck)) {
+		ret = PTR_ERR(omap->utmi_p1_fck);
+		dev_err(dev, "utmi_p1_gfclk failed error:%d\n",	ret);
+		goto err_end;
 	}
 
-	while (!(usbhs_read(omap->uhh_base, OMAP_UHH_SYSSTATUS)
-				& (1 << 1))) {
-		cpu_relax();
+	omap->xclk60mhsp1_ck = clk_get(dev, "xclk60mhsp1_ck");
+	if (IS_ERR(omap->xclk60mhsp1_ck)) {
+		ret = PTR_ERR(omap->xclk60mhsp1_ck);
+		dev_err(dev, "xclk60mhsp1_ck failed error:%d\n", ret);
+		goto err_utmi_p1_fck;
+	}
+
+	omap->utmi_p2_fck = clk_get(dev, "utmi_p2_gfclk");
+	if (IS_ERR(omap->utmi_p2_fck)) {
+		ret = PTR_ERR(omap->utmi_p2_fck);
+		dev_err(dev, "utmi_p2_gfclk failed error:%d\n", ret);
+		goto err_xclk60mhsp1_ck;
+	}
+
+	omap->xclk60mhsp2_ck = clk_get(dev, "xclk60mhsp2_ck");
+	if (IS_ERR(omap->xclk60mhsp2_ck)) {
+		ret = PTR_ERR(omap->xclk60mhsp2_ck);
+		dev_err(dev, "xclk60mhsp2_ck failed error:%d\n", ret);
+		goto err_utmi_p2_fck;
+	}
 
-		if (time_after(jiffies, timeout))
-			dev_dbg(dev, "operation timed out\n");
+	omap->usbhost_p1_fck = clk_get(dev, "usb_host_hs_utmi_p1_clk");
+	if (IS_ERR(omap->usbhost_p1_fck)) {
+		ret = PTR_ERR(omap->usbhost_p1_fck);
+		dev_err(dev, "usbhost_p1_fck failed error:%d\n", ret);
+		goto err_xclk60mhsp2_ck;
+	}
+
+	omap->usbtll_p1_fck = clk_get(dev, "usb_tll_hs_usb_ch0_clk");
+	if (IS_ERR(omap->usbtll_p1_fck)) {
+		ret = PTR_ERR(omap->usbtll_p1_fck);
+		dev_err(dev, "usbtll_p1_fck failed error:%d\n", ret);
+		goto err_usbhost_p1_fck;
+	}
+
+	omap->usbhost_p2_fck = clk_get(dev, "usb_host_hs_utmi_p2_clk");
+	if (IS_ERR(omap->usbhost_p2_fck)) {
+		ret = PTR_ERR(omap->usbhost_p2_fck);
+		dev_err(dev, "usbhost_p2_fck failed error:%d\n", ret);
+		goto err_usbtll_p1_fck;
 	}
 
-	while (!(usbhs_read(omap->uhh_base, OMAP_UHH_SYSSTATUS)
-				& (1 << 2))) {
-		cpu_relax();
+	omap->usbtll_p2_fck = clk_get(dev, "usb_tll_hs_usb_ch1_clk");
+	if (IS_ERR(omap->usbtll_p2_fck)) {
+		ret = PTR_ERR(omap->usbtll_p2_fck);
+		dev_err(dev, "usbtll_p2_fck failed error:%d\n", ret);
+		goto err_usbhost_p2_fck;
+	}
 
-		if (time_after(jiffies, timeout))
-			dev_dbg(dev, "operation timed out\n");
+	omap->init_60m_fclk = clk_get(dev, "init_60m_fclk");
+	if (IS_ERR(omap->init_60m_fclk)) {
+		ret = PTR_ERR(omap->init_60m_fclk);
+		dev_err(dev, "init_60m_fclk failed error:%d\n", ret);
+		goto err_usbtll_p2_fck;
 	}
 
-	usbhs_write(omap->tll_base, OMAP_USBTLL_SYSCONFIG, (1 << 1));
+	if (is_ehci_phy_mode(pdata->port_mode[0])) {
+		/* for OMAP3 , the clk set paretn fails */
+		ret = clk_set_parent(omap->utmi_p1_fck,
+					omap->xclk60mhsp1_ck);
+		if (ret != 0)
+			dev_err(dev, "xclk60mhsp1_ck set parent"
+				"failed error:%d\n", ret);
+	} else if (is_ehci_tll_mode(pdata->port_mode[0])) {
+		ret = clk_set_parent(omap->utmi_p1_fck,
+					omap->init_60m_fclk);
+		if (ret != 0)
+			dev_err(dev, "init_60m_fclk set parent"
+				"failed error:%d\n", ret);
+	}
 
-	while (!(usbhs_read(omap->tll_base, OMAP_USBTLL_SYSSTATUS)
-				& (1 << 0))) {
-		cpu_relax();
+	if (is_ehci_phy_mode(pdata->port_mode[1])) {
+		ret = clk_set_parent(omap->utmi_p2_fck,
+					omap->xclk60mhsp2_ck);
+		if (ret != 0)
+			dev_err(dev, "xclk60mhsp2_ck set parent"
+					"failed error:%d\n", ret);
+	} else if (is_ehci_tll_mode(pdata->port_mode[1])) {
+		ret = clk_set_parent(omap->utmi_p2_fck,
+						omap->init_60m_fclk);
+		if (ret != 0)
+			dev_err(dev, "init_60m_fclk set parent"
+				"failed error:%d\n", ret);
+	}
 
-		if (time_after(jiffies, timeout))
-			dev_dbg(dev, "operation timed out\n");
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "uhh");
+	if (!res) {
+		dev_err(dev, "UHH EHCI get resource failed\n");
+		ret = -ENODEV;
+		goto err_init_60m_fclk;
 	}
 
-	if (is_omap_usbhs_rev2(omap)) {
-		if (is_ehci_tll_mode(pdata->port_mode[0]))
-			clk_disable(omap->usbtll_p1_fck);
-		if (is_ehci_tll_mode(pdata->port_mode[1]))
-			clk_disable(omap->usbtll_p2_fck);
-		clk_disable(omap->utmi_p2_fck);
-		clk_disable(omap->utmi_p1_fck);
+	omap->uhh_base = ioremap(res->start, resource_size(res));
+	if (!omap->uhh_base) {
+		dev_err(dev, "UHH ioremap failed\n");
+		ret = -ENOMEM;
+		goto err_init_60m_fclk;
 	}
 
-	clk_disable(omap->usbtll_ick);
-	clk_disable(omap->usbtll_fck);
-	clk_disable(omap->usbhost_fs_fck);
-	clk_disable(omap->usbhost_hs_fck);
-	clk_disable(omap->usbhost_ick);
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "tll");
+	if (!res) {
+		dev_err(dev, "UHH EHCI get resource failed\n");
+		ret = -ENODEV;
+		goto err_tll;
+	}
 
-	/* The gpio_free migh sleep; so unlock the spinlock */
-	spin_unlock_irqrestore(&omap->lock, flags);
+	omap->tll_base = ioremap(res->start, resource_size(res));
+	if (!omap->tll_base) {
+		dev_err(dev, "TLL ioremap failed\n");
+		ret = -ENOMEM;
+		goto err_tll;
+	}
 
-	if (pdata->ehci_data->phy_reset) {
-		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0]))
-			gpio_free(pdata->ehci_data->reset_gpio_port[0]);
+	platform_set_drvdata(pdev, omap);
 
-		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1]))
-			gpio_free(pdata->ehci_data->reset_gpio_port[1]);
+	ret = omap_usbhs_alloc_children(pdev);
+	if (ret) {
+		dev_err(dev, "omap_usbhs_alloc_children failed\n");
+		goto err_alloc;
 	}
-	return;
 
-end_disble:
-	spin_unlock_irqrestore(&omap->lock, flags);
-}
+	omap_usbhs_init(dev);
 
-int omap_usbhs_enable(struct device *dev)
-{
-	return  usbhs_enable(dev->parent);
+	goto end_probe;
+
+err_alloc:
+	iounmap(omap->tll_base);
+
+err_tll:
+	iounmap(omap->uhh_base);
+
+err_init_60m_fclk:
+	clk_put(omap->init_60m_fclk);
+
+err_usbtll_p2_fck:
+	clk_put(omap->usbtll_p2_fck);
+
+err_usbhost_p2_fck:
+	clk_put(omap->usbhost_p2_fck);
+
+err_usbtll_p1_fck:
+	clk_put(omap->usbtll_p1_fck);
+
+err_usbhost_p1_fck:
+	clk_put(omap->usbhost_p1_fck);
+
+err_xclk60mhsp2_ck:
+	clk_put(omap->xclk60mhsp2_ck);
+
+err_utmi_p2_fck:
+	clk_put(omap->utmi_p2_fck);
+
+err_xclk60mhsp1_ck:
+	clk_put(omap->xclk60mhsp1_ck);
+
+err_utmi_p1_fck:
+	clk_put(omap->utmi_p1_fck);
+
+err_end:
+	clk_put(omap->opt_clk);
+	pm_runtime_disable(dev);
+	kfree(omap);
+
+end_probe:
+	return ret;
 }
-EXPORT_SYMBOL_GPL(omap_usbhs_enable);
 
-void omap_usbhs_disable(struct device *dev)
+/**
+ * usbhs_omap_remove - shutdown processing for UHH & TLL HCDs
+ * @pdev: USB Host Controller being removed
+ *
+ * Reverses the effect of usbhs_omap_probe().
+ */
+static int __devexit usbhs_omap_remove(struct platform_device *pdev)
 {
-	usbhs_disable(dev->parent);
+	struct usbhs_hcd_omap *omap = platform_get_drvdata(pdev);
+
+	omap_usbhs_deinit(&pdev->dev);
+	iounmap(omap->tll_base);
+	iounmap(omap->uhh_base);
+	clk_put(omap->init_60m_fclk);
+	clk_put(omap->usbtll_p2_fck);
+	clk_put(omap->usbhost_p2_fck);
+	clk_put(omap->usbtll_p1_fck);
+	clk_put(omap->usbhost_p1_fck);
+	clk_put(omap->xclk60mhsp2_ck);
+	clk_put(omap->utmi_p2_fck);
+	clk_put(omap->xclk60mhsp1_ck);
+	clk_put(omap->utmi_p1_fck);
+	clk_put(omap->opt_clk);
+	pm_runtime_disable(&pdev->dev);
+	kfree(omap);
+
+	return 0;
 }
-EXPORT_SYMBOL_GPL(omap_usbhs_disable);
+
+static const struct dev_pm_ops usbhsomap_dev_pm_ops = {
+	.runtime_suspend	= usbhs_runtime_suspend,
+	.runtime_resume		= usbhs_runtime_resume,
+};
 
 static struct platform_driver usbhs_omap_driver = {
 	.driver = {
 		.name		= (char *)usbhs_driver_name,
 		.owner		= THIS_MODULE,
+		.pm		= &usbhsomap_dev_pm_ops,
 	},
 	.remove		= __exit_p(usbhs_omap_remove),
 };
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

