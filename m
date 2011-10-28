Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab1J1MgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:36:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:24307 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932850Ab1J1MgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:36:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,418,1315206000"; 
   d="scan'208";a="68013686"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCHv6 19/19] usb: otg: Convert all users to pass struct usb_otg for OTG functions
Date: Fri, 28 Oct 2011 15:35:25 +0300
Message-Id: <1319805325-24689-20-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the otg functions so that they receive struct
otg instead of struct usb_phy as parameter and
converts all users of these functions to pass the otg member
of their usb_phy.

Includes fixes to IMX code from Sascha Hauer.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/mach-pxa/pxa3xx-ulpi.c   |    8 ++++----
 drivers/usb/gadget/ci13xxx_udc.c  |    7 ++++---
 drivers/usb/gadget/fsl_udc_core.c |    5 +++--
 drivers/usb/gadget/langwell_udc.c |    2 +-
 drivers/usb/gadget/omap_udc.c     |    7 ++++---
 drivers/usb/gadget/pxa25x_udc.c   |    5 +++--
 drivers/usb/gadget/pxa27x_udc.c   |    5 +++--
 drivers/usb/host/ehci-fsl.c       |    4 ++--
 drivers/usb/host/ehci-hub.c       |    2 +-
 drivers/usb/host/ehci-msm.c       |    4 ++--
 drivers/usb/host/ehci-mxc.c       |    2 +-
 drivers/usb/host/ehci-tegra.c     |    6 +++---
 drivers/usb/host/ohci-omap.c      |    6 +++---
 drivers/usb/musb/musb_core.c      |    2 +-
 drivers/usb/musb/musb_gadget.c    |   11 ++++++-----
 drivers/usb/musb/omap2430.c       |    8 ++++----
 include/linux/usb/otg.h           |   30 +++++++++++++++---------------
 17 files changed, 60 insertions(+), 54 deletions(-)

diff --git a/arch/arm/mach-pxa/pxa3xx-ulpi.c b/arch/arm/mach-pxa/pxa3xx-ulpi.c
index a299e11..e385dde 100644
--- a/arch/arm/mach-pxa/pxa3xx-ulpi.c
+++ b/arch/arm/mach-pxa/pxa3xx-ulpi.c
@@ -145,13 +145,13 @@ static int pxa310_start_otg_host_transcvr(struct usb_bus *host)
 		return err;
 	}
 
-	err = otg_set_vbus(u2d->otg, 1);
+	err = otg_set_vbus(u2d->otg->otg, 1);
 	if (err) {
 		pr_err("OTG transceiver VBUS set failed");
 		return err;
 	}
 
-	err = otg_set_host(u2d->otg, host);
+	err = otg_set_host(u2d->otg->otg, host);
 	if (err)
 		pr_err("OTG transceiver Host mode set failed");
 
@@ -189,8 +189,8 @@ static void pxa310_stop_otg_hc(void)
 {
 	pxa310_otg_transceiver_rtsm();
 
-	otg_set_host(u2d->otg, NULL);
-	otg_set_vbus(u2d->otg, 0);
+	otg_set_host(u2d->otg->otg, NULL);
+	otg_set_vbus(u2d->otg->otg, 0);
 	usb_phy_shutdown(u2d->otg);
 }
 
diff --git a/drivers/usb/gadget/ci13xxx_udc.c b/drivers/usb/gadget/ci13xxx_udc.c
index 8361c9d..9b8ea7b 100644
--- a/drivers/usb/gadget/ci13xxx_udc.c
+++ b/drivers/usb/gadget/ci13xxx_udc.c
@@ -2911,7 +2911,8 @@ static int udc_probe(struct ci13xxx_udc_driver *driver, struct device *dev,
 		goto unreg_device;
 
 	if (udc->transceiver) {
-		retval = otg_set_peripheral(udc->transceiver, &udc->gadget);
+		retval = otg_set_peripheral(udc->transceiver->otg,
+						&udc->gadget);
 		if (retval)
 			goto remove_dbg;
 	}
@@ -2928,7 +2929,7 @@ static int udc_probe(struct ci13xxx_udc_driver *driver, struct device *dev,
 
 remove_trans:
 	if (udc->transceiver) {
-		otg_set_peripheral(udc->transceiver, &udc->gadget);
+		otg_set_peripheral(udc->transceiver->otg, &udc->gadget);
 		usb_put_transceiver(udc->transceiver);
 	}
 
@@ -2964,7 +2965,7 @@ static void udc_remove(void)
 	usb_del_gadget_udc(&udc->gadget);
 
 	if (udc->transceiver) {
-		otg_set_peripheral(udc->transceiver, &udc->gadget);
+		otg_set_peripheral(udc->transceiver->otg, &udc->gadget);
 		usb_put_transceiver(udc->transceiver);
 	}
 #ifdef CONFIG_USB_GADGET_DEBUG_FILES
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index e58484c..bb50502 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -1971,7 +1971,8 @@ static int fsl_start(struct usb_gadget_driver *driver,
 
 		/* connect to bus through transceiver */
 		if (udc_controller->transceiver) {
-			retval = otg_set_peripheral(udc_controller->transceiver,
+			retval = otg_set_peripheral(
+					udc_controller->transceiver->otg,
 						    &udc_controller->gadget);
 			if (retval < 0) {
 				ERR("can't bind to transceiver\n");
@@ -2011,7 +2012,7 @@ static int fsl_stop(struct usb_gadget_driver *driver)
 		return -EINVAL;
 
 	if (udc_controller->transceiver)
-		otg_set_peripheral(udc_controller->transceiver, NULL);
+		otg_set_peripheral(udc_controller->transceiver->otg, NULL);
 
 	/* stop DR, disable intr */
 	dr_controller_stop(udc_controller);
diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index a0bbf56..30496c2 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -1912,7 +1912,7 @@ static int langwell_stop(struct usb_gadget *g,
 
 	/* unbind OTG transceiver */
 	if (dev->transceiver)
-		(void)otg_set_peripheral(dev->transceiver, 0);
+		(void)otg_set_peripheral(dev->transceiver->otg, 0);
 
 	/* disable interrupt and set controller to stop state */
 	langwell_udc_stop(dev);
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index 5b5c355..115b741 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -1213,7 +1213,7 @@ static int omap_wakeup(struct usb_gadget *gadget)
 	/* NOTE:  non-OTG systems may use SRP TOO... */
 	} else if (!(udc->devstat & UDC_ATT)) {
 		if (udc->transceiver)
-			retval = otg_start_srp(udc->transceiver);
+			retval = otg_start_srp(udc->transceiver->otg);
 	}
 	spin_unlock_irqrestore(&udc->lock, flags);
 
@@ -2156,7 +2156,8 @@ static int omap_udc_start(struct usb_gadget_driver *driver,
 
 	/* connect to bus through transceiver */
 	if (udc->transceiver) {
-		status = otg_set_peripheral(udc->transceiver, &udc->gadget);
+		status = otg_set_peripheral(udc->transceiver->otg,
+						&udc->gadget);
 		if (status < 0) {
 			ERR("can't bind to transceiver\n");
 			if (driver->unbind) {
@@ -2202,7 +2203,7 @@ static int omap_udc_stop(struct usb_gadget_driver *driver)
 		omap_vbus_session(&udc->gadget, 0);
 
 	if (udc->transceiver)
-		(void) otg_set_peripheral(udc->transceiver, NULL);
+		(void) otg_set_peripheral(udc->transceiver->otg, NULL);
 	else
 		pullup_disable(udc);
 
diff --git a/drivers/usb/gadget/pxa25x_udc.c b/drivers/usb/gadget/pxa25x_udc.c
index 162c2cc..d6b2986 100644
--- a/drivers/usb/gadget/pxa25x_udc.c
+++ b/drivers/usb/gadget/pxa25x_udc.c
@@ -1301,7 +1301,8 @@ fail:
 
 	/* connect to bus through transceiver */
 	if (dev->transceiver) {
-		retval = otg_set_peripheral(dev->transceiver, &dev->gadget);
+		retval = otg_set_peripheral(dev->transceiver->otg,
+						&dev->gadget);
 		if (retval) {
 			DMSG("can't bind to transceiver\n");
 			if (driver->unbind)
@@ -1360,7 +1361,7 @@ static int pxa25x_stop(struct usb_gadget_driver *driver)
 	local_irq_enable();
 
 	if (dev->transceiver)
-		(void) otg_set_peripheral(dev->transceiver, NULL);
+		(void) otg_set_peripheral(dev->transceiver->otg, NULL);
 
 	driver->unbind(&dev->gadget);
 	dev->gadget.dev.driver = NULL;
diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index da8c6b8..d62366b 100644
--- a/drivers/usb/gadget/pxa27x_udc.c
+++ b/drivers/usb/gadget/pxa27x_udc.c
@@ -1835,7 +1835,8 @@ static int pxa27x_udc_start(struct usb_gadget_driver *driver,
 		driver->driver.name);
 
 	if (udc->transceiver) {
-		retval = otg_set_peripheral(udc->transceiver, &udc->gadget);
+		retval = otg_set_peripheral(udc->transceiver->otg,
+						&udc->gadget);
 		if (retval) {
 			dev_err(udc->dev, "can't bind to transceiver\n");
 			goto transceiver_fail;
@@ -1908,7 +1909,7 @@ static int pxa27x_udc_stop(struct usb_gadget_driver *driver)
 		 driver->driver.name);
 
 	if (udc->transceiver)
-		return otg_set_peripheral(udc->transceiver, NULL);
+		return otg_set_peripheral(udc->transceiver->otg, NULL);
 	return 0;
 }
 
diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index 72edcd2..7c138a6 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -147,7 +147,7 @@ static int usb_hcd_fsl_probe(const struct hc_driver *driver,
 			hcd, ehci, ehci->transceiver);
 
 		if (ehci->transceiver) {
-			retval = otg_set_host(ehci->transceiver,
+			retval = otg_set_host(ehci->transceiver->otg,
 					      &ehci_to_hcd(ehci)->self);
 			if (retval) {
 				if (ehci->transceiver)
@@ -194,7 +194,7 @@ static void usb_hcd_fsl_remove(struct usb_hcd *hcd,
 	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
 
 	if (ehci->transceiver) {
-		otg_set_host(ehci->transceiver, NULL);
+		otg_set_host(ehci->transceiver->otg, NULL);
 		put_device(ehci->transceiver->dev);
 	}
 
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 77bbb23..75a2b30 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -727,7 +727,7 @@ static int ehci_hub_control (
 #ifdef CONFIG_USB_OTG
 			if ((hcd->self.otg_port == (wIndex + 1))
 			    && hcd->self.b_hnp_enable) {
-				otg_start_hnp(ehci->transceiver);
+				otg_start_hnp(ehci->transceiver->otg);
 				break;
 			}
 #endif
diff --git a/drivers/usb/host/ehci-msm.c b/drivers/usb/host/ehci-msm.c
index bb97dc3..b909430 100644
--- a/drivers/usb/host/ehci-msm.c
+++ b/drivers/usb/host/ehci-msm.c
@@ -152,7 +152,7 @@ static int ehci_msm_probe(struct platform_device *pdev)
 		goto unmap;
 	}
 
-	ret = otg_set_host(xceiv, &hcd->self);
+	ret = otg_set_host(xceiv->otg, &hcd->self);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "unable to register with transceiver\n");
 		goto put_transceiver;
@@ -186,7 +186,7 @@ static int __devexit ehci_msm_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 
-	otg_set_host(xceiv, NULL);
+	otg_set_host(xceiv->otg, NULL);
 	usb_put_transceiver(xceiv);
 
 	usb_put_hcd(hcd);
diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
index b762fe0..a797d51 100644
--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -226,7 +226,7 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
 			ret = -ENODEV;
 			goto err_add;
 		}
-		ret = otg_set_vbus(pdata->otg, 1);
+		ret = otg_set_vbus(pdata->otg->otg, 1);
 		if (ret) {
 			dev_err(dev, "unable to enable vbus on transceiver\n");
 			goto err_add;
diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 896f0f8..f58698a 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -670,7 +670,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	if (pdata->operating_mode == TEGRA_USB_OTG) {
 		tegra->transceiver = usb_get_transceiver();
 		if (tegra->transceiver)
-			otg_set_host(tegra->transceiver, &hcd->self);
+			otg_set_host(tegra->transceiver->otg, &hcd->self);
 	}
 #endif
 
@@ -685,7 +685,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 fail:
 #ifdef CONFIG_USB_OTG_UTILS
 	if (tegra->transceiver) {
-		otg_set_host(tegra->transceiver, NULL);
+		otg_set_host(tegra->transceiver->otg, NULL);
 		usb_put_transceiver(tegra->transceiver);
 	}
 #endif
@@ -743,7 +743,7 @@ static int tegra_ehci_remove(struct platform_device *pdev)
 
 #ifdef CONFIG_USB_OTG_UTILS
 	if (tegra->transceiver) {
-		otg_set_host(tegra->transceiver, NULL);
+		otg_set_host(tegra->transceiver->otg, NULL);
 		usb_put_transceiver(tegra->transceiver);
 	}
 #endif
diff --git a/drivers/usb/host/ohci-omap.c b/drivers/usb/host/ohci-omap.c
index 1e4aa2a..cc63e46 100644
--- a/drivers/usb/host/ohci-omap.c
+++ b/drivers/usb/host/ohci-omap.c
@@ -171,7 +171,7 @@ static void start_hnp(struct ohci_hcd *ohci)
 	unsigned long	flags;
 	u32 l;
 
-	otg_start_hnp(ohci->transceiver);
+	otg_start_hnp(ohci->transceiver->otg);
 
 	local_irq_save(flags);
 	ohci->transceiver->state = USB_PHY_STATE_A_SUSPEND;
@@ -212,7 +212,7 @@ static int ohci_omap_init(struct usb_hcd *hcd)
 	if (need_transceiver) {
 		ohci->transceiver = usb_get_transceiver();
 		if (ohci->transceiver) {
-			int	status = otg_set_host(ohci->transceiver,
+			int	status = otg_set_host(ohci->transceiver->otg,
 						&ohci_to_hcd(ohci)->self);
 			dev_dbg(hcd->self.controller, "init %s transceiver, status %d\n",
 					ohci->transceiver->label, status);
@@ -404,7 +404,7 @@ usb_hcd_omap_remove (struct usb_hcd *hcd, struct platform_device *pdev)
 
 	usb_remove_hcd(hcd);
 	if (ohci->transceiver) {
-		(void) otg_set_host(ohci->transceiver, 0);
+		(void) otg_set_host(ohci->transceiver->otg, 0);
 		put_device(ohci->transceiver->dev);
 	}
 	if (machine_is_omap_osk())
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index dd918f0..3278efa 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1971,7 +1971,7 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 	if (is_host_enabled(musb)) {
 		struct usb_hcd	*hcd = musb_to_hcd(musb);
 
-		otg_set_host(musb->xceiv, &hcd->self);
+		otg_set_host(musb->xceiv->otg, &hcd->self);
 
 		if (is_otg_enabled(musb))
 			hcd->self.otg_port = 1;
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 3a95c6b..2962773 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1626,7 +1626,7 @@ static int musb_gadget_wakeup(struct usb_gadget *gadget)
 		}
 
 		spin_unlock_irqrestore(&musb->lock, flags);
-		otg_start_srp(musb->xceiv);
+		otg_start_srp(musb->xceiv->otg);
 		spin_lock_irqsave(&musb->lock, flags);
 
 		/* Block idling for at least 1s */
@@ -1900,6 +1900,7 @@ static int musb_gadget_start(struct usb_gadget *g,
 		struct usb_gadget_driver *driver)
 {
 	struct musb		*musb = gadget_to_musb(g);
+	struct usb_otg		*otg = musb->xceiv->otg;
 	unsigned long		flags;
 	int			retval = -EINVAL;
 
@@ -1916,7 +1917,7 @@ static int musb_gadget_start(struct usb_gadget *g,
 	spin_lock_irqsave(&musb->lock, flags);
 	musb->is_active = 1;
 
-	otg_set_peripheral(musb->xceiv, &musb->g);
+	otg_set_peripheral(otg, &musb->g);
 	musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 
 	/*
@@ -1947,8 +1948,8 @@ static int musb_gadget_start(struct usb_gadget *g,
 		}
 
 		if ((musb->xceiv->last_event == USB_EVENT_ID)
-					&& musb->xceiv->set_vbus)
-			otg_set_vbus(musb->xceiv, 1);
+					&& otg->set_vbus)
+			otg_set_vbus(otg, 1);
 
 		hcd->self.uses_pio_for_control = 1;
 	}
@@ -2034,7 +2035,7 @@ static int musb_gadget_stop(struct usb_gadget *g,
 
 	musb->xceiv->state = USB_PHY_STATE_UNDEFINED;
 	stop_activity(musb, driver);
-	otg_set_peripheral(musb->xceiv, NULL);
+	otg_set_peripheral(musb->xceiv->otg, NULL);
 
 	dev_dbg(musb->controller, "unregistering driver %s\n", driver->function);
 
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index f61afc9..fc9377c 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -165,8 +165,8 @@ static void omap2430_musb_set_vbus(struct musb *musb, int is_on)
 				}
 			}
 
-			if (ret && musb->xceiv->set_vbus)
-				otg_set_vbus(musb->xceiv, 1);
+			if (ret && otg->set_vbus)
+				otg_set_vbus(otg, 1);
 		} else {
 			musb->is_active = 1;
 			otg->default_a = 1;
@@ -268,8 +268,8 @@ static int musb_otg_notifications(struct notifier_block *nb,
 			}
 
 		if (data->interface_type == MUSB_INTERFACE_UTMI) {
-			if (musb->xceiv->set_vbus)
-				otg_set_vbus(musb->xceiv, 0);
+			if (musb->xceiv->otg->set_vbus)
+				otg_set_vbus(musb->xceiv->otg, 0);
 		}
 		usb_phy_shutdown(musb->xceiv);
 		break;
diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
index ff47067..1f7661f 100644
--- a/include/linux/usb/otg.h
+++ b/include/linux/usb/otg.h
@@ -192,30 +192,30 @@ static inline const char *usb_phy_state_string(enum usb_phy_state state)
 
 /* Context: can sleep */
 static inline int
-otg_start_hnp(struct usb_phy *x)
+otg_start_hnp(struct usb_otg *otg)
 {
-	if (x->otg && x->otg->start_hnp)
-		return x->otg->start_hnp(x->otg);
+	if (otg && otg->start_hnp)
+		return otg->start_hnp(otg);
 
 	return -ENOTSUPP;
 }
 
 /* Context: can sleep */
 static inline int
-otg_set_vbus(struct usb_phy *x, bool enabled)
+otg_set_vbus(struct usb_otg *otg, bool enabled)
 {
-	if (x->otg && x->otg->set_vbus)
-		return x->otg->set_vbus(x->otg, enabled);
+	if (otg && otg->set_vbus)
+		return otg->set_vbus(otg, enabled);
 
 	return -ENOTSUPP;
 }
 
 /* for HCDs */
 static inline int
-otg_set_host(struct usb_phy *x, struct usb_bus *host)
+otg_set_host(struct usb_otg *otg, struct usb_bus *host)
 {
-	if (x->otg && x->otg->set_host)
-		return x->otg->set_host(x->otg, host);
+	if (otg && otg->set_host)
+		return otg->set_host(otg, host);
 
 	return -ENOTSUPP;
 }
@@ -224,10 +224,10 @@ otg_set_host(struct usb_phy *x, struct usb_bus *host)
 
 /* Context: can sleep */
 static inline int
-otg_set_peripheral(struct usb_phy *x, struct usb_gadget *periph)
+otg_set_peripheral(struct usb_otg *otg, struct usb_gadget *periph)
 {
-	if (x->otg && x->otg->set_peripheral)
-		return x->otg->set_peripheral(x->otg, periph);
+	if (otg && otg->set_peripheral)
+		return otg->set_peripheral(otg, periph);
 
 	return -ENOTSUPP;
 }
@@ -251,10 +251,10 @@ usb_phy_set_suspend(struct usb_phy *x, int suspend)
 }
 
 static inline int
-otg_start_srp(struct usb_phy *x)
+otg_start_srp(struct usb_otg *otg)
 {
-	if (x->otg && x->otg->start_srp)
-		return x->otg->start_srp(x->otg);
+	if (otg && otg->start_srp)
+		return otg->start_srp(otg);
 
 	return -ENOTSUPP;
 }
-- 
1.7.4.1

