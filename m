Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab1IZLXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 07:23:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:22239 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab1IZLWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 07:22:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="56486157"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>,
        Li Yang <leoli@freescale.com>, Eric Miao <eric.y.miao@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCHv5 17/19] usb: Convert all users to new usb_phy
Date: Mon, 26 Sep 2011 14:21:30 +0300
Message-Id: <1317036092-3000-18-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new usb_phy_* functions with transceiver
operations instead of the old otg functions.

Includes fixes from Sascha Hauer.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pavankumar Kondeti <pkondeti@codeaurora.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/gadget/ci13xxx_msm.c  |    4 ++--
 drivers/usb/gadget/ci13xxx_udc.c  |   10 +++++-----
 drivers/usb/gadget/fsl_udc_core.c |    4 ++--
 drivers/usb/gadget/langwell_udc.c |    8 ++++----
 drivers/usb/gadget/omap_udc.c     |   14 ++++++++------
 drivers/usb/gadget/pxa25x_udc.c   |    8 ++++----
 drivers/usb/gadget/pxa27x_udc.c   |    6 +++---
 drivers/usb/host/ehci-fsl.c       |    2 +-
 drivers/usb/host/ehci-msm.c       |   14 +++++++-------
 drivers/usb/host/ehci-mxc.c       |   10 ++++++----
 drivers/usb/host/ehci-tegra.c     |    6 +++---
 drivers/usb/host/ohci-omap.c      |    2 +-
 drivers/usb/musb/am35x.c          |    4 ++--
 drivers/usb/musb/blackfin.c       |    4 ++--
 drivers/usb/musb/da8xx.c          |    4 ++--
 drivers/usb/musb/davinci.c        |    6 +++---
 drivers/usb/musb/musb_core.c      |   10 +++++-----
 drivers/usb/musb/musb_gadget.c    |    2 +-
 drivers/usb/musb/omap2430.c       |   24 ++++++++++++------------
 drivers/usb/musb/tusb6010.c       |    6 +++---
 drivers/usb/musb/ux500.c          |    8 ++++----
 21 files changed, 80 insertions(+), 76 deletions(-)

diff --git a/drivers/usb/gadget/ci13xxx_msm.c b/drivers/usb/gadget/ci13xxx_msm.c
index 470981a..737fe42 100644
--- a/drivers/usb/gadget/ci13xxx_msm.c
+++ b/drivers/usb/gadget/ci13xxx_msm.c
@@ -48,10 +48,10 @@ static void ci13xxx_msm_notify_event(struct ci13xxx *udc, unsigned event)
 		 * Put the transceiver in non-driving mode. Otherwise host
 		 * may not detect soft-disconnection.
 		 */
-		val = otg_io_read(udc->transceiver, ULPI_FUNC_CTRL);
+		val = usb_phy_io_read(udc->transceiver, ULPI_FUNC_CTRL);
 		val &= ~ULPI_FUNC_CTRL_OPMODE_MASK;
 		val |= ULPI_FUNC_CTRL_OPMODE_NONDRIVING;
-		otg_io_write(udc->transceiver, val, ULPI_FUNC_CTRL);
+		usb_phy_io_write(udc->transceiver, val, ULPI_FUNC_CTRL);
 		break;
 	default:
 		dev_dbg(dev, "unknown ci13xxx_udc event\n");
diff --git a/drivers/usb/gadget/ci13xxx_udc.c b/drivers/usb/gadget/ci13xxx_udc.c
index 1265a85..677e448 100644
--- a/drivers/usb/gadget/ci13xxx_udc.c
+++ b/drivers/usb/gadget/ci13xxx_udc.c
@@ -2519,7 +2519,7 @@ static int ci13xxx_vbus_draw(struct usb_gadget *_gadget, unsigned mA)
 	struct ci13xxx *udc = container_of(_gadget, struct ci13xxx, gadget);
 
 	if (udc->transceiver)
-		return otg_set_power(udc->transceiver, mA);
+		return usb_phy_set_power(udc->transceiver, mA);
 	return -ENOTSUPP;
 }
 
@@ -2883,7 +2883,7 @@ static int udc_probe(struct ci13xxx_udc_driver *driver, struct device *dev,
 	if (retval < 0)
 		goto free_udc;
 
-	udc->transceiver = otg_get_transceiver();
+	udc->transceiver = usb_get_transceiver();
 
 	if (udc->udc_driver->flags & CI13XXX_REQUIRE_TRANSCEIVER) {
 		if (udc->transceiver == NULL) {
@@ -2929,7 +2929,7 @@ static int udc_probe(struct ci13xxx_udc_driver *driver, struct device *dev,
 remove_trans:
 	if (udc->transceiver) {
 		otg_set_peripheral(udc->transceiver, &udc->gadget);
-		otg_put_transceiver(udc->transceiver);
+		usb_put_transceiver(udc->transceiver);
 	}
 
 	err("error = %i", retval);
@@ -2941,7 +2941,7 @@ unreg_device:
 	device_unregister(&udc->gadget.dev);
 put_transceiver:
 	if (udc->transceiver)
-		otg_put_transceiver(udc->transceiver);
+		usb_put_transceiver(udc->transceiver);
 free_udc:
 	kfree(udc);
 	_udc = NULL;
@@ -2965,7 +2965,7 @@ static void udc_remove(void)
 
 	if (udc->transceiver) {
 		otg_set_peripheral(udc->transceiver, &udc->gadget);
-		otg_put_transceiver(udc->transceiver);
+		usb_put_transceiver(udc->transceiver);
 	}
 #ifdef CONFIG_USB_GADGET_DEBUG_FILES
 	dbg_remove_files(&udc->gadget.dev);
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index de24a42..8775867 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -1221,7 +1221,7 @@ static int fsl_vbus_draw(struct usb_gadget *gadget, unsigned mA)
 
 	udc = container_of(gadget, struct fsl_udc, gadget);
 	if (udc->transceiver)
-		return otg_set_power(udc->transceiver, mA);
+		return usb_phy_set_power(udc->transceiver, mA);
 	return -ENOTSUPP;
 }
 
@@ -2450,7 +2450,7 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_USB_OTG
 	if (pdata->operating_mode == FSL_USB2_DR_OTG) {
-		udc_controller->transceiver = otg_get_transceiver();
+		udc_controller->transceiver = usb_get_transceiver();
 		if (!udc_controller->transceiver) {
 			ERR("Can't find OTG driver!\n");
 			ret = -ENODEV;
diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index 00ddf29..64f98ff 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -1279,9 +1279,9 @@ static int langwell_vbus_draw(struct usb_gadget *_gadget, unsigned mA)
 	dev_vdbg(&dev->pdev->dev, "---> %s()\n", __func__);
 
 	if (dev->transceiver) {
-		dev_vdbg(&dev->pdev->dev, "otg_set_power\n");
+		dev_vdbg(&dev->pdev->dev, "usb_phy_set_power\n");
 		dev_vdbg(&dev->pdev->dev, "<--- %s()\n", __func__);
-		return otg_set_power(dev->transceiver, mA);
+		return usb_phy_set_power(dev->transceiver, mA);
 	}
 
 	dev_vdbg(&dev->pdev->dev, "<--- %s()\n", __func__);
@@ -3103,7 +3103,7 @@ static void langwell_udc_remove(struct pci_dev *pdev)
 		pci_disable_device(pdev);
 #else
 	if (dev->transceiver) {
-		otg_put_transceiver(dev->transceiver);
+		usb_put_transceiver(dev->transceiver);
 		dev->transceiver = NULL;
 		dev->lotg = NULL;
 	}
@@ -3168,7 +3168,7 @@ static int langwell_udc_probe(struct pci_dev *pdev,
 
 	/* mem region and register base */
 	dev->region = 1;
-	dev->transceiver = otg_get_transceiver();
+	dev->transceiver = usb_get_transceiver();
 	dev->lotg = otg_to_langwell(dev->transceiver);
 	base = dev->lotg->regs;
 #else
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index 56d4f47..21828ab 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -1355,7 +1355,7 @@ static int omap_vbus_draw(struct usb_gadget *gadget, unsigned mA)
 
 	udc = container_of(gadget, struct omap_udc, gadget);
 	if (udc->transceiver)
-		return otg_set_power(udc->transceiver, mA);
+		return usb_phy_set_power(udc->transceiver, mA);
 	return -EOPNOTSUPP;
 }
 
@@ -1849,11 +1849,13 @@ static void devstate_irq(struct omap_udc *udc, u16 irq_src)
 					spin_lock(&udc->lock);
 				}
 				if (udc->transceiver)
-					otg_set_suspend(udc->transceiver, 1);
+					usb_phy_set_suspend(
+							udc->transceiver, 1);
 			} else {
 				VDBG("resume\n");
 				if (udc->transceiver)
-					otg_set_suspend(udc->transceiver, 0);
+					usb_phy_set_suspend(
+							udc->transceiver, 0);
 				if (udc->gadget.speed == USB_SPEED_FULL
 						&& udc->driver->resume) {
 					spin_unlock(&udc->lock);
@@ -2872,7 +2874,7 @@ static int __init omap_udc_probe(struct platform_device *pdev)
 		 * use it.  Except for OTG, we don't _need_ to talk to one;
 		 * but not having one probably means no VBUS detection.
 		 */
-		xceiv = otg_get_transceiver();
+		xceiv = usb_get_transceiver();
 		if (xceiv)
 			type = xceiv->label;
 		else if (config->otg) {
@@ -3018,7 +3020,7 @@ cleanup1:
 
 cleanup0:
 	if (xceiv)
-		otg_put_transceiver(xceiv);
+		usb_put_transceiver(xceiv);
 
 	if (cpu_is_omap16xx() || cpu_is_omap24xx() || cpu_is_omap7xx()) {
 		clk_disable(hhc_clk);
@@ -3048,7 +3050,7 @@ static int __exit omap_udc_remove(struct platform_device *pdev)
 
 	pullup_disable(udc);
 	if (udc->transceiver) {
-		otg_put_transceiver(udc->transceiver);
+		usb_put_transceiver(udc->transceiver);
 		udc->transceiver = NULL;
 	}
 	omap_writew(0, UDC_SYSCON1);
diff --git a/drivers/usb/gadget/pxa25x_udc.c b/drivers/usb/gadget/pxa25x_udc.c
index e4e59b4..57133a0 100644
--- a/drivers/usb/gadget/pxa25x_udc.c
+++ b/drivers/usb/gadget/pxa25x_udc.c
@@ -1007,7 +1007,7 @@ static int pxa25x_udc_vbus_draw(struct usb_gadget *_gadget, unsigned mA)
 	udc = container_of(_gadget, struct pxa25x_udc, gadget);
 
 	if (udc->transceiver)
-		return otg_set_power(udc->transceiver, mA);
+		return usb_phy_set_power(udc->transceiver, mA);
 	return -EOPNOTSUPP;
 }
 
@@ -2171,7 +2171,7 @@ static int __init pxa25x_udc_probe(struct platform_device *pdev)
 	dev->dev = &pdev->dev;
 	dev->mach = pdev->dev.platform_data;
 
-	dev->transceiver = otg_get_transceiver();
+	dev->transceiver = usb_get_transceiver();
 
 	if (gpio_is_valid(dev->mach->gpio_pullup)) {
 		if ((retval = gpio_request(dev->mach->gpio_pullup,
@@ -2250,7 +2250,7 @@ lubbock_fail0:
 		gpio_free(dev->mach->gpio_pullup);
  err_gpio_pullup:
 	if (dev->transceiver) {
-		otg_put_transceiver(dev->transceiver);
+		usb_put_transceiver(dev->transceiver);
 		dev->transceiver = NULL;
 	}
 	clk_put(dev->clk);
@@ -2292,7 +2292,7 @@ static int __exit pxa25x_udc_remove(struct platform_device *pdev)
 	clk_put(dev->clk);
 
 	if (dev->transceiver) {
-		otg_put_transceiver(dev->transceiver);
+		usb_put_transceiver(dev->transceiver);
 		dev->transceiver = NULL;
 	}
 
diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index 85b68c7..57ac8c5 100644
--- a/drivers/usb/gadget/pxa27x_udc.c
+++ b/drivers/usb/gadget/pxa27x_udc.c
@@ -1676,7 +1676,7 @@ static int pxa_udc_vbus_draw(struct usb_gadget *_gadget, unsigned mA)
 
 	udc = to_gadget_udc(_gadget);
 	if (udc->transceiver)
-		return otg_set_power(udc->transceiver, mA);
+		return usb_phy_set_power(udc->transceiver, mA);
 	return -EOPNOTSUPP;
 }
 
@@ -2473,7 +2473,7 @@ static int __init pxa_udc_probe(struct platform_device *pdev)
 
 	udc->dev = &pdev->dev;
 	udc->mach = pdev->dev.platform_data;
-	udc->transceiver = otg_get_transceiver();
+	udc->transceiver = usb_get_transceiver();
 
 	gpio = udc->mach->gpio_pullup;
 	if (gpio_is_valid(gpio)) {
@@ -2552,7 +2552,7 @@ static int __exit pxa_udc_remove(struct platform_device *_dev)
 	if (gpio_is_valid(gpio))
 		gpio_free(gpio);
 
-	otg_put_transceiver(udc->transceiver);
+	usb_put_transceiver(udc->transceiver);
 
 	udc->transceiver = NULL;
 	platform_set_drvdata(_dev, NULL);
diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index 34a3140..2026c0c 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -142,7 +142,7 @@ static int usb_hcd_fsl_probe(const struct hc_driver *driver,
 	if (pdata->operating_mode == FSL_USB2_DR_OTG) {
 		struct ehci_hcd *ehci = hcd_to_ehci(hcd);
 
-		ehci->transceiver = otg_get_transceiver();
+		ehci->transceiver = usb_get_transceiver();
 		dev_dbg(&pdev->dev, "hcd=0x%p  ehci=0x%p, transceiver=0x%p\n",
 			hcd, ehci, ehci->transceiver);
 
diff --git a/drivers/usb/host/ehci-msm.c b/drivers/usb/host/ehci-msm.c
index ef7c431..bb97dc3 100644
--- a/drivers/usb/host/ehci-msm.c
+++ b/drivers/usb/host/ehci-msm.c
@@ -32,7 +32,7 @@
 
 #define MSM_USB_BASE (hcd->regs)
 
-static struct usb_phy *otg;
+static struct usb_phy *xceiv;
 
 static int ehci_msm_reset(struct usb_hcd *hcd)
 {
@@ -145,14 +145,14 @@ static int ehci_msm_probe(struct platform_device *pdev)
 	 * powering up VBUS, mapping of registers address space and power
 	 * management.
 	 */
-	otg = otg_get_transceiver();
-	if (!otg) {
+	xceiv = usb_get_transceiver();
+	if (!xceiv) {
 		dev_err(&pdev->dev, "unable to find transceiver\n");
 		ret = -ENODEV;
 		goto unmap;
 	}
 
-	ret = otg_set_host(otg, &hcd->self);
+	ret = otg_set_host(xceiv, &hcd->self);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "unable to register with transceiver\n");
 		goto put_transceiver;
@@ -169,7 +169,7 @@ static int ehci_msm_probe(struct platform_device *pdev)
 	return 0;
 
 put_transceiver:
-	otg_put_transceiver(otg);
+	usb_put_transceiver(xceiv);
 unmap:
 	iounmap(hcd->regs);
 put_hcd:
@@ -186,8 +186,8 @@ static int __devexit ehci_msm_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 
-	otg_set_host(otg, NULL);
-	otg_put_transceiver(otg);
+	otg_set_host(xceiv, NULL);
+	usb_put_transceiver(xceiv);
 
 	usb_put_hcd(hcd);
 
diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
index 555a73c..eccf55c 100644
--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -220,7 +220,7 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
 	/* Initialize the transceiver */
 	if (pdata->otg) {
 		pdata->otg->io_priv = hcd->regs + ULPI_VIEWPORT_OFFSET;
-		ret = otg_init(pdata->otg);
+		ret = usb_phy_init(pdata->otg);
 		if (ret) {
 			dev_err(dev, "unable to init transceiver, probably missing\n");
 			ret = -ENODEV;
@@ -247,9 +247,11 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
 		 * It's in violation of USB specs
 		 */
 		if (machine_is_mx51_efikamx() || machine_is_mx51_efikasb()) {
-			flags = otg_io_read(pdata->otg, ULPI_OTG_CTRL);
+			flags = usb_phy_io_read(pdata->otg,
+							ULPI_OTG_CTRL);
 			flags |= ULPI_OTG_CTRL_CHRGVBUS;
-			ret = otg_io_write(pdata->otg, flags, ULPI_OTG_CTRL);
+			ret = usb_phy_io_write(pdata->otg, flags,
+							ULPI_OTG_CTRL);
 			if (ret) {
 				dev_err(dev, "unable to set CHRVBUS\n");
 				goto err_add;
@@ -297,7 +299,7 @@ static int __exit ehci_mxc_drv_remove(struct platform_device *pdev)
 		pdata->exit(pdev);
 
 	if (pdata->otg)
-		otg_shutdown(pdata->otg);
+		usb_phy_shutdown(pdata->otg);
 
 	usb_remove_hcd(hcd);
 	iounmap(hcd->regs);
diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 4637a29..8fc0214 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -668,7 +668,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_USB_OTG_UTILS
 	if (pdata->operating_mode == TEGRA_USB_OTG) {
-		tegra->transceiver = otg_get_transceiver();
+		tegra->transceiver = usb_get_transceiver();
 		if (tegra->transceiver)
 			otg_set_host(tegra->transceiver, &hcd->self);
 	}
@@ -686,7 +686,7 @@ fail:
 #ifdef CONFIG_USB_OTG_UTILS
 	if (tegra->transceiver) {
 		otg_set_host(tegra->transceiver, NULL);
-		otg_put_transceiver(tegra->transceiver);
+		usb_put_transceiver(tegra->transceiver);
 	}
 #endif
 	tegra_usb_phy_close(tegra->phy);
@@ -744,7 +744,7 @@ static int tegra_ehci_remove(struct platform_device *pdev)
 #ifdef CONFIG_USB_OTG_UTILS
 	if (tegra->transceiver) {
 		otg_set_host(tegra->transceiver, NULL);
-		otg_put_transceiver(tegra->transceiver);
+		usb_put_transceiver(tegra->transceiver);
 	}
 #endif
 
diff --git a/drivers/usb/host/ohci-omap.c b/drivers/usb/host/ohci-omap.c
index bc45648..b3ff4c3 100644
--- a/drivers/usb/host/ohci-omap.c
+++ b/drivers/usb/host/ohci-omap.c
@@ -210,7 +210,7 @@ static int ohci_omap_init(struct usb_hcd *hcd)
 
 #ifdef	CONFIG_USB_OTG
 	if (need_transceiver) {
-		ohci->transceiver = otg_get_transceiver();
+		ohci->transceiver = usb_get_transceiver();
 		if (ohci->transceiver) {
 			int	status = otg_set_host(ohci->transceiver,
 						&ohci_to_hcd(ohci)->self);
diff --git a/drivers/usb/musb/am35x.c b/drivers/usb/musb/am35x.c
index 8325ecf..37530f2 100644
--- a/drivers/usb/musb/am35x.c
+++ b/drivers/usb/musb/am35x.c
@@ -364,7 +364,7 @@ static int am35x_musb_init(struct musb *musb)
 		return -ENODEV;
 
 	usb_nop_xceiv_register();
-	musb->xceiv = otg_get_transceiver();
+	musb->xceiv = usb_get_transceiver();
 	if (!musb->xceiv)
 		return -ENODEV;
 
@@ -406,7 +406,7 @@ static int am35x_musb_exit(struct musb *musb)
 	if (data->set_phy_power)
 		data->set_phy_power(0);
 
-	otg_put_transceiver(musb->xceiv);
+	usb_put_transceiver(musb->xceiv);
 	usb_nop_xceiv_unregister();
 
 	return 0;
diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index 2f3e0b0..1ba9e0b 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -415,7 +415,7 @@ static int bfin_musb_init(struct musb *musb)
 	gpio_direction_output(musb->config->gpio_vrsel, 0);
 
 	usb_nop_xceiv_register();
-	musb->xceiv = otg_get_transceiver();
+	musb->xceiv = usb_get_transceiver();
 	if (!musb->xceiv) {
 		gpio_free(musb->config->gpio_vrsel);
 		return -ENODEV;
@@ -440,7 +440,7 @@ static int bfin_musb_exit(struct musb *musb)
 {
 	gpio_free(musb->config->gpio_vrsel);
 
-	otg_put_transceiver(musb->xceiv);
+	usb_put_transceiver(musb->xceiv);
 	usb_nop_xceiv_unregister();
 	return 0;
 }
diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
index 61813b5..92e093d 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -425,7 +425,7 @@ static int da8xx_musb_init(struct musb *musb)
 		goto fail;
 
 	usb_nop_xceiv_register();
-	musb->xceiv = otg_get_transceiver();
+	musb->xceiv = usb_get_transceiver();
 	if (!musb->xceiv)
 		goto fail;
 
@@ -458,7 +458,7 @@ static int da8xx_musb_exit(struct musb *musb)
 
 	phy_off();
 
-	otg_put_transceiver(musb->xceiv);
+	usb_put_transceiver(musb->xceiv);
 	usb_nop_xceiv_unregister();
 
 	return 0;
diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
index b2daf1c..e36af9a 100644
--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -387,7 +387,7 @@ static int davinci_musb_init(struct musb *musb)
 	u32		revision;
 
 	usb_nop_xceiv_register();
-	musb->xceiv = otg_get_transceiver();
+	musb->xceiv = usb_get_transceiver();
 	if (!musb->xceiv)
 		return -ENODEV;
 
@@ -446,7 +446,7 @@ static int davinci_musb_init(struct musb *musb)
 	return 0;
 
 fail:
-	otg_put_transceiver(musb->xceiv);
+	usb_put_transceiver(musb->xceiv);
 	usb_nop_xceiv_unregister();
 	return -ENODEV;
 }
@@ -495,7 +495,7 @@ static int davinci_musb_exit(struct musb *musb)
 
 	phy_off();
 
-	otg_put_transceiver(musb->xceiv);
+	usb_put_transceiver(musb->xceiv);
 	usb_nop_xceiv_unregister();
 
 	return 0;
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index f9edf2c..dd918f0 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -131,9 +131,9 @@ static inline struct musb *dev_to_musb(struct device *dev)
 /*-------------------------------------------------------------------------*/
 
 #ifndef CONFIG_BLACKFIN
-static int musb_ulpi_read(struct usb_phy *otg, u32 offset)
+static int musb_ulpi_read(struct usb_phy *phy, u32 offset)
 {
-	void __iomem *addr = otg->io_priv;
+	void __iomem *addr = phy->io_priv;
 	int	i = 0;
 	u8	r;
 	u8	power;
@@ -165,10 +165,10 @@ static int musb_ulpi_read(struct usb_phy *otg, u32 offset)
 	return musb_readb(addr, MUSB_ULPI_REG_DATA);
 }
 
-static int musb_ulpi_write(struct usb_phy *otg,
+static int musb_ulpi_write(struct usb_phy *phy,
 		u32 offset, u32 data)
 {
-	void __iomem *addr = otg->io_priv;
+	void __iomem *addr = phy->io_priv;
 	int	i = 0;
 	u8	r = 0;
 	u8	power;
@@ -200,7 +200,7 @@ static int musb_ulpi_write(struct usb_phy *otg,
 #define musb_ulpi_write		NULL
 #endif
 
-static struct otg_io_access_ops musb_ulpi_access = {
+static struct usb_phy_io_ops musb_ulpi_access = {
 	.read = musb_ulpi_read,
 	.write = musb_ulpi_write,
 };
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index d931058..a811fd8 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1688,7 +1688,7 @@ static int musb_gadget_vbus_draw(struct usb_gadget *gadget, unsigned mA)
 
 	if (!musb->xceiv->set_power)
 		return -EOPNOTSUPP;
-	return otg_set_power(musb->xceiv, mA);
+	return usb_phy_set_power(musb->xceiv, mA);
 }
 
 static int musb_gadget_pullup(struct usb_gadget *gadget, int is_on)
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 0879a2b..f61afc9 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -240,12 +240,12 @@ static int musb_otg_notifications(struct notifier_block *nb,
 		if (is_otg_enabled(musb)) {
 			if (musb->gadget_driver) {
 				pm_runtime_get_sync(musb->controller);
-				otg_init(musb->xceiv);
+				usb_phy_init(musb->xceiv);
 				omap2430_musb_set_vbus(musb, 1);
 			}
 		} else {
 			pm_runtime_get_sync(musb->controller);
-			otg_init(musb->xceiv);
+			usb_phy_init(musb->xceiv);
 			omap2430_musb_set_vbus(musb, 1);
 		}
 		break;
@@ -255,7 +255,7 @@ static int musb_otg_notifications(struct notifier_block *nb,
 
 		if (musb->gadget_driver)
 			pm_runtime_get_sync(musb->controller);
-		otg_init(musb->xceiv);
+		usb_phy_init(musb->xceiv);
 		break;
 
 	case USB_EVENT_NONE:
@@ -271,7 +271,7 @@ static int musb_otg_notifications(struct notifier_block *nb,
 			if (musb->xceiv->set_vbus)
 				otg_set_vbus(musb->xceiv, 0);
 		}
-		otg_shutdown(musb->xceiv);
+		usb_phy_shutdown(musb->xceiv);
 		break;
 	default:
 		dev_dbg(musb->controller, "ID float\n");
@@ -292,7 +292,7 @@ static int omap2430_musb_init(struct musb *musb)
 	 * up through ULPI.  TWL4030-family PMICs include one,
 	 * which needs a driver, drivers aren't always needed.
 	 */
-	musb->xceiv = otg_get_transceiver();
+	musb->xceiv = usb_get_transceiver();
 	if (!musb->xceiv) {
 		pr_err("HS USB OTG: no transceiver configured\n");
 		return -ENODEV;
@@ -325,7 +325,7 @@ static int omap2430_musb_init(struct musb *musb)
 			musb_readl(musb->mregs, OTG_SIMENABLE));
 
 	musb->nb.notifier_call = musb_otg_notifications;
-	status = otg_register_notifier(musb->xceiv, &musb->nb);
+	status = usb_register_notifier(musb->xceiv, &musb->nb);
 
 	if (status)
 		dev_dbg(musb->controller, "notification register failed\n");
@@ -350,7 +350,7 @@ static void omap2430_musb_enable(struct musb *musb)
 	switch (musb->xceiv->last_event) {
 
 	case USB_EVENT_ID:
-		otg_init(musb->xceiv);
+		usb_phy_init(musb->xceiv);
 		if (data->interface_type == MUSB_INTERFACE_UTMI) {
 			devctl = musb_readb(musb->mregs, MUSB_DEVCTL);
 			/* start the session */
@@ -370,7 +370,7 @@ static void omap2430_musb_enable(struct musb *musb)
 		break;
 
 	case USB_EVENT_VBUS:
-		otg_init(musb->xceiv);
+		usb_phy_init(musb->xceiv);
 		break;
 
 	default:
@@ -381,7 +381,7 @@ static void omap2430_musb_enable(struct musb *musb)
 static void omap2430_musb_disable(struct musb *musb)
 {
 	if (musb->xceiv->last_event)
-		otg_shutdown(musb->xceiv);
+		usb_phy_shutdown(musb->xceiv);
 }
 
 static int omap2430_musb_exit(struct musb *musb)
@@ -389,7 +389,7 @@ static int omap2430_musb_exit(struct musb *musb)
 	del_timer_sync(&musb_idle_timer);
 
 	omap2430_low_level_exit(musb);
-	otg_put_transceiver(musb->xceiv);
+	usb_put_transceiver(musb->xceiv);
 
 	return 0;
 }
@@ -493,7 +493,7 @@ static int omap2430_runtime_suspend(struct device *dev)
 	struct musb			*musb = glue_to_musb(glue);
 
 	omap2430_low_level_exit(musb);
-	otg_set_suspend(musb->xceiv, 1);
+	usb_phy_set_suspend(musb->xceiv, 1);
 
 	return 0;
 }
@@ -504,7 +504,7 @@ static int omap2430_runtime_resume(struct device *dev)
 	struct musb			*musb = glue_to_musb(glue);
 
 	omap2430_low_level_init(musb);
-	otg_set_suspend(musb->xceiv, 0);
+	usb_phy_set_suspend(musb->xceiv, 0);
 
 	return 0;
 }
diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index 3c7dd53..e5402d7 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -1081,7 +1081,7 @@ static int tusb_musb_init(struct musb *musb)
 	int			ret;
 
 	usb_nop_xceiv_register();
-	musb->xceiv = otg_get_transceiver();
+	musb->xceiv = usb_get_transceiver();
 	if (!musb->xceiv)
 		return -ENODEV;
 
@@ -1133,7 +1133,7 @@ done:
 		if (sync)
 			iounmap(sync);
 
-		otg_put_transceiver(musb->xceiv);
+		usb_put_transceiver(musb->xceiv);
 		usb_nop_xceiv_unregister();
 	}
 	return ret;
@@ -1149,7 +1149,7 @@ static int tusb_musb_exit(struct musb *musb)
 
 	iounmap(musb->sync_va);
 
-	otg_put_transceiver(musb->xceiv);
+	usb_put_transceiver(musb->xceiv);
 	usb_nop_xceiv_unregister();
 	return 0;
 }
diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index f7e04bf..0f56674 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -37,7 +37,7 @@ struct ux500_glue {
 
 static int ux500_musb_init(struct musb *musb)
 {
-	musb->xceiv = otg_get_transceiver();
+	musb->xceiv = usb_get_transceiver();
 	if (!musb->xceiv) {
 		pr_err("HS USB OTG: no transceiver configured\n");
 		return -ENODEV;
@@ -48,7 +48,7 @@ static int ux500_musb_init(struct musb *musb)
 
 static int ux500_musb_exit(struct musb *musb)
 {
-	otg_put_transceiver(musb->xceiv);
+	usb_put_transceiver(musb->xceiv);
 
 	return 0;
 }
@@ -160,7 +160,7 @@ static int ux500_suspend(struct device *dev)
 	struct ux500_glue	*glue = dev_get_drvdata(dev);
 	struct musb		*musb = glue_to_musb(glue);
 
-	otg_set_suspend(musb->xceiv, 1);
+	usb_phy_set_suspend(musb->xceiv, 1);
 	clk_disable(glue->clk);
 
 	return 0;
@@ -178,7 +178,7 @@ static int ux500_resume(struct device *dev)
 		return ret;
 	}
 
-	otg_set_suspend(musb->xceiv, 0);
+	usb_phy_set_suspend(musb->xceiv, 0);
 
 	return 0;
 }
-- 
1.7.4.1

