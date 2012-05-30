Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab2E3Oew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:34:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47403 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2E3Oes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:34:48 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <tony@atomide.com>, <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <balbi@ti.com>
Subject: [RFC PATCH 2/3] usb: musb: omap glue: use omap-usb2 as the phy driver
Date: Wed, 30 May 2012 20:04:25 +0530
Message-ID: <1338388466-3565-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1338388466-3565-1-git-send-email-kishon@ti.com>
References: <1338388466-3565-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The twl6030 which was the phy driver (phy + comparator) is now
made only as comparator driver used for detecting VBUS and ID events
and reporting it to the glue using an export API created in omap musb
glue.

The MUSB should now use omap-usb2 as the phy driver.

Both twl6030 and twl4030 are made to use the export API from omap musb glue.

Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/mach-omap2/usb-musb.c |    3 -
 drivers/usb/musb/musb_core.h   |    1 -
 drivers/usb/musb/omap2430.c    |  150 +++++++++++++++++++++++++----------
 drivers/usb/otg/twl4030-usb.c  |   40 +++------
 drivers/usb/otg/twl6030-usb.c  |  172 ++++++++--------------------------------
 include/linux/usb/musb-omap.h  |   31 +++++++
 6 files changed, 187 insertions(+), 210 deletions(-)
 create mode 100644 include/linux/usb/musb-omap.h

diff --git a/arch/arm/mach-omap2/usb-musb.c b/arch/arm/mach-omap2/usb-musb.c
index 8d5ed77..8ada8cc 100644
--- a/arch/arm/mach-omap2/usb-musb.c
+++ b/arch/arm/mach-omap2/usb-musb.c
@@ -119,7 +119,4 @@ void __init usb_musb_init(struct omap_musb_board_data *musb_board_data)
 	dev->dma_mask = &musb_dmamask;
 	dev->coherent_dma_mask = musb_dmamask;
 	put_device(dev);
-
-	if (cpu_is_omap44xx())
-		omap4430_phy_init(dev);
 }
diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index f4a40f0..0b0174b 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -327,7 +327,6 @@ struct musb {
 
 	irqreturn_t		(*isr)(int, void *);
 	struct work_struct	irq_work;
-	struct work_struct	otg_notifier_work;
 	u16			hwvers;
 
 /* this hub status bit is reserved by USB 2.0 and not seen by usbcore */
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index e279cf3..a94e13e 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -34,6 +34,9 @@
 #include <linux/dma-mapping.h>
 #include <linux/pm_runtime.h>
 #include <linux/err.h>
+#include <linux/usb/musb-omap.h>
+#include <linux/usb/omap4_usb_phy.h>
+#include <linux/mfd/omap_control.h>
 
 #include "musb_core.h"
 #include "omap2430.h"
@@ -41,9 +44,14 @@
 struct omap2430_glue {
 	struct device		*dev;
 	struct platform_device	*musb;
+	struct work_struct	omap_musb_mailbox_work;
+	struct device		*control_dev;
+	enum omap_musb_vbus_id_status status;
 };
 #define glue_to_musb(g)		platform_get_drvdata(g->musb)
 
+struct omap2430_glue		*_glue;
+
 static struct timer_list musb_idle_timer;
 
 static void musb_do_idle(unsigned long _musb)
@@ -223,68 +231,104 @@ static inline void omap2430_low_level_init(struct musb *musb)
 	musb_writel(musb->mregs, OTG_FORCESTDBY, l);
 }
 
-static int musb_otg_notifications(struct notifier_block *nb,
-		unsigned long event, void *unused)
+int omap_musb_mailbox(enum omap_musb_vbus_id_status status)
 {
-	struct musb	*musb = container_of(nb, struct musb, nb);
+	struct omap2430_glue	*glue = _glue;
+	struct musb		*musb = glue_to_musb(glue);
+
+	glue->status = status;
+	if (!musb) {
+		dev_err(glue->dev, "musb core is not yet ready\n");
+		return -ENODEV;
+	}
 
-	musb->xceiv_event = event;
-	schedule_work(&musb->otg_notifier_work);
+	schedule_work(&glue->omap_musb_mailbox_work);
 
-	return NOTIFY_OK;
+	return 0;
 }
 
-static void musb_otg_notifier_work(struct work_struct *data_notifier_work)
+static void omap_musb_set_mailbox(struct omap2430_glue *glue)
 {
-	struct musb *musb = container_of(data_notifier_work, struct musb, otg_notifier_work);
+	struct musb *musb = glue_to_musb(glue);
 	struct device *dev = musb->controller;
 	struct musb_hdrc_platform_data *pdata = dev->platform_data;
 	struct omap_musb_board_data *data = pdata->board_data;
+	struct usb_otg *otg = musb->xceiv->otg;
+	u32 val;
 
-	switch (musb->xceiv_event) {
-	case USB_EVENT_ID:
-		dev_dbg(musb->controller, "ID GND\n");
+	switch (glue->status) {
+	case OMAP_MUSB_ID_GROUND:
+		dev_dbg(dev, "ID GND\n");
 
+		otg->default_a = true;
+		musb->xceiv->state = OTG_STATE_A_IDLE;
+		musb->xceiv->last_event = USB_EVENT_ID;
 		if (!is_otg_enabled(musb) || musb->gadget_driver) {
-			pm_runtime_get_sync(musb->controller);
-			usb_phy_init(musb->xceiv);
+			pm_runtime_get_sync(dev);
+			if (glue->control_dev) {
+				val = AVALID | VBUSVALID;
+				omap4_usb_phy_mailbox(glue->control_dev, val);
+			}
 			omap2430_musb_set_vbus(musb, 1);
 		}
 		break;
 
-	case USB_EVENT_VBUS:
-		dev_dbg(musb->controller, "VBUS Connect\n");
+	case OMAP_MUSB_VBUS_VALID:
+		dev_dbg(dev, "VBUS Connect\n");
 
+		otg->default_a = false;
+		musb->xceiv->state = OTG_STATE_B_IDLE;
+		musb->xceiv->last_event = USB_EVENT_VBUS;
 		if (musb->gadget_driver)
-			pm_runtime_get_sync(musb->controller);
-		usb_phy_init(musb->xceiv);
+			pm_runtime_get_sync(dev);
+
+		if (glue->control_dev) {
+			val = IDDIG | AVALID | VBUSVALID;
+			omap4_usb_phy_mailbox(glue->control_dev, val);
+		}
 		break;
 
-	case USB_EVENT_NONE:
-		dev_dbg(musb->controller, "VBUS Disconnect\n");
+	case OMAP_MUSB_ID_FLOAT:
+	case OMAP_MUSB_VBUS_OFF:
+		dev_dbg(dev, "VBUS Disconnect\n");
+
+		musb->xceiv->last_event = USB_EVENT_NONE;
 
 		if (is_otg_enabled(musb) || is_peripheral_enabled(musb))
 			if (musb->gadget_driver) {
-				pm_runtime_mark_last_busy(musb->controller);
-				pm_runtime_put_autosuspend(musb->controller);
+				pm_runtime_mark_last_busy(dev);
+				pm_runtime_put_autosuspend(dev);
 			}
 
 		if (data->interface_type == MUSB_INTERFACE_UTMI) {
 			if (musb->xceiv->otg->set_vbus)
 				otg_set_vbus(musb->xceiv->otg, 0);
 		}
-		usb_phy_shutdown(musb->xceiv);
+
+		if (glue->control_dev) {
+			val = SESSEND | IDDIG;
+			omap4_usb_phy_mailbox(glue->control_dev, val);
+		}
 		break;
 	default:
-		dev_dbg(musb->controller, "ID float\n");
+		dev_dbg(dev, "ID float\n");
 	}
 }
 
+
+static void omap_musb_mailbox_work(struct work_struct *mailbox_work)
+{
+	struct omap2430_glue *glue = container_of(mailbox_work,
+				struct omap2430_glue, omap_musb_mailbox_work);
+	omap_musb_set_mailbox(glue);
+}
+
 static int omap2430_musb_init(struct musb *musb)
 {
 	u32 l;
 	int status = 0;
 	struct device *dev = musb->controller;
+	struct omap2430_glue *glue = dev_get_drvdata(dev->parent);
 	struct musb_hdrc_platform_data *plat = dev->platform_data;
 	struct omap_musb_board_data *data = plat->board_data;
 
@@ -292,14 +336,12 @@ static int omap2430_musb_init(struct musb *musb)
 	 * up through ULPI.  TWL4030-family PMICs include one,
 	 * which needs a driver, drivers aren't always needed.
 	 */
-	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
+	musb->xceiv = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
 	if (!musb->xceiv) {
 		pr_err("HS USB OTG: no transceiver configured\n");
 		return -ENODEV;
 	}
 
-	INIT_WORK(&musb->otg_notifier_work, musb_otg_notifier_work);
-
 	status = pm_runtime_get_sync(dev);
 	if (status < 0) {
 		dev_err(dev, "pm_runtime_get_sync FAILED %d\n", status);
@@ -326,15 +368,14 @@ static int omap2430_musb_init(struct musb *musb)
 			musb_readl(musb->mregs, OTG_INTERFSEL),
 			musb_readl(musb->mregs, OTG_SIMENABLE));
 
-	musb->nb.notifier_call = musb_otg_notifications;
-	status = usb_register_notifier(musb->xceiv, &musb->nb);
-
-	if (status)
-		dev_dbg(musb->controller, "notification register failed\n");
+	usb_phy_init(musb->xceiv);
 
 	setup_timer(&musb_idle_timer, musb_do_idle, (unsigned long) musb);
 
-	pm_runtime_put_noidle(musb->controller);
+	if (glue->status != OMAP_MUSB_UNKNOWN)
+		omap_musb_set_mailbox(glue);
+
+	pm_runtime_put_sync(musb->controller);
 	return 0;
 
 err1:
@@ -343,16 +384,22 @@ err1:
 
 static void omap2430_musb_enable(struct musb *musb)
 {
+	u32		val;
 	u8		devctl;
 	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
 	struct device *dev = musb->controller;
+	struct omap2430_glue *glue = dev_get_drvdata(dev->parent);
 	struct musb_hdrc_platform_data *pdata = dev->platform_data;
 	struct omap_musb_board_data *data = pdata->board_data;
 
-	switch (musb->xceiv->last_event) {
+	switch (glue->status) {
+
+	case OMAP_MUSB_ID_GROUND:
+		if (glue->control_dev) {
+			val = AVALID | VBUSVALID;
+			omap4_usb_phy_mailbox(glue->control_dev, val);
+		}
 
-	case USB_EVENT_ID:
-		usb_phy_init(musb->xceiv);
 		if (data->interface_type != MUSB_INTERFACE_UTMI)
 			break;
 		devctl = musb_readb(musb->mregs, MUSB_DEVCTL);
@@ -370,8 +417,11 @@ static void omap2430_musb_enable(struct musb *musb)
 		}
 		break;
 
-	case USB_EVENT_VBUS:
-		usb_phy_init(musb->xceiv);
+	case OMAP_MUSB_VBUS_VALID:
+		if (glue->control_dev) {
+			val = IDDIG | AVALID | VBUSVALID;
+			omap4_usb_phy_mailbox(glue->control_dev, val);
+		}
 		break;
 
 	default:
@@ -381,17 +431,21 @@ static void omap2430_musb_enable(struct musb *musb)
 
 static void omap2430_musb_disable(struct musb *musb)
 {
-	if (musb->xceiv->last_event)
-		usb_phy_shutdown(musb->xceiv);
+	u32 val;
+	struct device *dev = musb->controller;
+	struct omap2430_glue *glue = dev_get_drvdata(dev->parent);
+
+	if (musb->xceiv->last_event && glue->control_dev) {
+		val = SESSEND | IDDIG;
+		omap4_usb_phy_mailbox(glue->control_dev, val);
+	}
 }
 
 static int omap2430_musb_exit(struct musb *musb)
 {
 	del_timer_sync(&musb_idle_timer);
-	cancel_work_sync(&musb->otg_notifier_work);
 
 	omap2430_low_level_exit(musb);
-	usb_put_phy(musb->xceiv);
 
 	return 0;
 }
@@ -436,11 +490,21 @@ static int __devinit omap2430_probe(struct platform_device *pdev)
 
 	glue->dev			= &pdev->dev;
 	glue->musb			= musb;
+	glue->status			= OMAP_MUSB_UNKNOWN;
+	glue->control_dev		= omap_control_get();
 
 	pdata->platform_ops		= &omap2430_ops;
 
 	platform_set_drvdata(pdev, glue);
 
+	/*
+	 * REVISIT if we ever have two instances of the wrapper, we will be
+	 * in big trouble
+	 */
+	_glue	= glue;
+
+	INIT_WORK(&glue->omap_musb_mailbox_work, omap_musb_mailbox_work);
+
 	ret = platform_device_add_resources(musb, pdev->resource,
 			pdev->num_resources);
 	if (ret) {
@@ -478,6 +542,8 @@ static int __devexit omap2430_remove(struct platform_device *pdev)
 {
 	struct omap2430_glue		*glue = platform_get_drvdata(pdev);
 
+	cancel_work_sync(&glue->omap_musb_mailbox_work);
+
 	platform_device_del(glue->musb);
 	platform_device_put(glue->musb);
 	kfree(glue);
@@ -546,7 +612,7 @@ static int __init omap2430_init(void)
 {
 	return platform_driver_register(&omap2430_driver);
 }
-module_init(omap2430_init);
+subsys_initcall(omap2430_init);
 
 static void __exit omap2430_exit(void)
 {
diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index f8139b3..d9357d4 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -32,6 +32,7 @@
 #include <linux/workqueue.h>
 #include <linux/io.h>
 #include <linux/delay.h>
+#include <linux/usb/musb-omap.h>
 #include <linux/usb/otg.h>
 #include <linux/usb/ulpi.h>
 #include <linux/i2c/twl.h>
@@ -159,10 +160,11 @@ struct twl4030_usb {
 	enum twl4030_usb_mode	usb_mode;
 
 	int			irq;
-	u8			linkstat;
 	bool			vbus_supplied;
 	u8			asleep;
 	bool			irq_enabled;
+
+	enum omap_musb_vbus_id_status prev_status;
 };
 
 /* internal define on top of container_of */
@@ -250,7 +252,6 @@ static enum usb_phy_events twl4030_usb_linkstat(struct twl4030_usb *twl)
 {
 	int	status;
 	int	linkstat = USB_EVENT_NONE;
-	struct usb_otg *otg = twl->phy.otg;
 
 	twl->vbus_supplied = false;
 
@@ -272,33 +273,21 @@ static enum usb_phy_events twl4030_usb_linkstat(struct twl4030_usb *twl)
 		if (status & (BIT(7)))
                         twl->vbus_supplied = true;
 
-		if (status & BIT(2))
+		if (status & BIT(2)) {
+			twl->prev_status = OMAP_MUSB_ID_GROUND;
 			linkstat = USB_EVENT_ID;
-		else
+		} else {
+			twl->prev_status = OMAP_MUSB_VBUS_VALID;
 			linkstat = USB_EVENT_VBUS;
-	} else
+		}
+	} else {
+		twl->prev_status = OMAP_MUSB_VBUS_OFF;
 		linkstat = USB_EVENT_NONE;
+	}
 
 	dev_dbg(twl->dev, "HW_CONDITIONS 0x%02x/%d; link %d\n",
 			status, status, linkstat);
 
-	twl->phy.last_event = linkstat;
-
-	/* REVISIT this assumes host and peripheral controllers
-	 * are registered, and that both are active...
-	 */
-
-	spin_lock_irq(&twl->lock);
-	twl->linkstat = linkstat;
-	if (linkstat == USB_EVENT_ID) {
-		otg->default_a = true;
-		twl->phy.state = OTG_STATE_A_IDLE;
-	} else {
-		otg->default_a = false;
-		twl->phy.state = OTG_STATE_B_IDLE;
-	}
-	spin_unlock_irq(&twl->lock);
-
 	return linkstat;
 }
 
@@ -521,8 +510,7 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
 		else
 			twl4030_phy_resume(twl);
 
-		atomic_notifier_call_chain(&twl->phy.notifier, status,
-				twl->phy.otg->gadget);
+		omap_musb_mailbox(twl->prev_status);
 	}
 	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
 
@@ -543,8 +531,7 @@ static void twl4030_usb_phy_init(struct twl4030_usb *twl)
 			twl->asleep = 0;
 		}
 
-		atomic_notifier_call_chain(&twl->phy.notifier, status,
-				twl->phy.otg->gadget);
+		omap_musb_mailbox(twl->prev_status);
 	}
 	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
 }
@@ -613,6 +600,7 @@ static int __devinit twl4030_usb_probe(struct platform_device *pdev)
 	twl->usb_mode		= pdata->usb_mode;
 	twl->vbus_supplied	= false;
 	twl->asleep		= 1;
+	twl->prev_status	= OMAP_MUSB_UNKNOWN;
 
 	twl->phy.dev		= twl->dev;
 	twl->phy.label		= "twl4030";
diff --git a/drivers/usb/otg/twl6030-usb.c b/drivers/usb/otg/twl6030-usb.c
index dbee00a..e3ac51f 100644
--- a/drivers/usb/otg/twl6030-usb.c
+++ b/drivers/usb/otg/twl6030-usb.c
@@ -26,10 +26,12 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/usb/otg.h>
+#include <linux/usb/phy_companion.h>
+#include <linux/usb/omap_usb.h>
+#include <linux/usb/musb-omap.h>
 #include <linux/i2c/twl.h>
 #include <linux/regulator/consumer.h>
 #include <linux/err.h>
-#include <linux/notifier.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 
@@ -87,7 +89,7 @@
 #define	VBUS_DET			BIT(2)
 
 struct twl6030_usb {
-	struct usb_phy		phy;
+	struct phy_companion	comparator;
 	struct device		*dev;
 
 	/* for vbus reporting with irqs disabled */
@@ -100,15 +102,16 @@ struct twl6030_usb {
 
 	int			irq1;
 	int			irq2;
-	u8			linkstat;
 	u8			asleep;
 	bool			irq_enabled;
 	bool			vbus_enable;
 	unsigned long		features;
-};
 
-#define phy_to_twl(x)		container_of((x), struct twl6030_usb, phy)
+	enum omap_musb_vbus_id_status prev_status;
+
+};
 
+#define	comparator_to_twl(x) container_of((x), struct twl6030_usb, comparator)
 /*-------------------------------------------------------------------------*/
 
 static inline int twl6030_writeb(struct twl6030_usb *twl, u8 module,
@@ -137,50 +140,9 @@ static inline u8 twl6030_readb(struct twl6030_usb *twl, u8 module, u8 address)
 	return ret;
 }
 
-static int twl6030_phy_init(struct usb_phy *x)
-{
-	struct twl6030_usb *twl;
-	struct device *dev;
-	struct twl4030_usb_data *pdata;
-
-	twl = phy_to_twl(x);
-	dev  = twl->dev;
-	pdata = dev->platform_data;
-
-	if (twl->linkstat == USB_EVENT_ID)
-		pdata->phy_power(twl->dev, 1, 1);
-	else
-		pdata->phy_power(twl->dev, 0, 1);
-
-	return 0;
-}
-
-static void twl6030_phy_shutdown(struct usb_phy *x)
-{
-	struct twl6030_usb *twl;
-	struct device *dev;
-	struct twl4030_usb_data *pdata;
-
-	twl = phy_to_twl(x);
-	dev  = twl->dev;
-	pdata = dev->platform_data;
-	pdata->phy_power(twl->dev, 0, 0);
-}
-
-static int twl6030_phy_suspend(struct usb_phy *x, int suspend)
-{
-	struct twl6030_usb *twl = phy_to_twl(x);
-	struct device *dev = twl->dev;
-	struct twl4030_usb_data *pdata = dev->platform_data;
-
-	pdata->phy_suspend(dev, suspend);
-
-	return 0;
-}
-
-static int twl6030_start_srp(struct usb_otg *otg)
+static int twl6030_start_srp(struct phy_companion *comparator)
 {
-	struct twl6030_usb *twl = phy_to_twl(otg->phy);
+	struct twl6030_usb *twl = comparator_to_twl(comparator);
 
 	twl6030_writeb(twl, TWL_MODULE_USB, 0x24, USB_VBUS_CTRL_SET);
 	twl6030_writeb(twl, TWL_MODULE_USB, 0x84, USB_VBUS_CTRL_SET);
@@ -234,14 +196,14 @@ static ssize_t twl6030_usb_vbus_show(struct device *dev,
 
 	spin_lock_irqsave(&twl->lock, flags);
 
-	switch (twl->linkstat) {
-	case USB_EVENT_VBUS:
+	switch (twl->prev_status) {
+	case OMAP_MUSB_VBUS_VALID:
 	       ret = snprintf(buf, PAGE_SIZE, "vbus\n");
 	       break;
-	case USB_EVENT_ID:
+	case OMAP_MUSB_ID_GROUND:
 	       ret = snprintf(buf, PAGE_SIZE, "id\n");
 	       break;
-	case USB_EVENT_NONE:
+	case OMAP_MUSB_VBUS_OFF:
 	       ret = snprintf(buf, PAGE_SIZE, "none\n");
 	       break;
 	default:
@@ -256,8 +218,7 @@ static DEVICE_ATTR(vbus, 0444, twl6030_usb_vbus_show, NULL);
 static irqreturn_t twl6030_usb_irq(int irq, void *_twl)
 {
 	struct twl6030_usb *twl = _twl;
-	struct usb_otg *otg = twl->phy.otg;
-	int status;
+	int status = OMAP_MUSB_UNKNOWN;
 	u8 vbus_state, hw_state;
 
 	hw_state = twl6030_readb(twl, TWL6030_MODULE_ID0, STS_HW_CONDITIONS);
@@ -268,25 +229,20 @@ static irqreturn_t twl6030_usb_irq(int irq, void *_twl)
 		if (vbus_state & VBUS_DET) {
 			regulator_enable(twl->usb3v3);
 			twl->asleep = 1;
-			status = USB_EVENT_VBUS;
-			otg->default_a = false;
-			twl->phy.state = OTG_STATE_B_IDLE;
-			twl->linkstat = status;
-			twl->phy.last_event = status;
-			atomic_notifier_call_chain(&twl->phy.notifier,
-						status, otg->gadget);
+			status = OMAP_MUSB_VBUS_VALID;
+			omap_musb_mailbox(status);
 		} else {
-			status = USB_EVENT_NONE;
-			twl->linkstat = status;
-			twl->phy.last_event = status;
-			atomic_notifier_call_chain(&twl->phy.notifier,
-						status, otg->gadget);
-			if (twl->asleep) {
-				regulator_disable(twl->usb3v3);
-				twl->asleep = 0;
+			if (twl->prev_status != OMAP_MUSB_UNKNOWN) {
+				status = OMAP_MUSB_VBUS_OFF;
+				omap_musb_mailbox(status);
+				if (twl->asleep) {
+					regulator_disable(twl->usb3v3);
+					twl->asleep = 0;
+				}
 			}
 		}
 	}
+	twl->prev_status = status;
 	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
 
 	return IRQ_HANDLED;
@@ -295,7 +251,6 @@ static irqreturn_t twl6030_usb_irq(int irq, void *_twl)
 static irqreturn_t twl6030_usbotg_irq(int irq, void *_twl)
 {
 	struct twl6030_usb *twl = _twl;
-	struct usb_otg *otg = twl->phy.otg;
 	int status = USB_EVENT_NONE;
 	u8 hw_state;
 
@@ -309,12 +264,7 @@ static irqreturn_t twl6030_usbotg_irq(int irq, void *_twl)
 		twl6030_writeb(twl, TWL_MODULE_USB, USB_ID_INT_EN_HI_SET,
 								0x10);
 		status = USB_EVENT_ID;
-		otg->default_a = true;
-		twl->phy.state = OTG_STATE_A_IDLE;
-		twl->linkstat = status;
-		twl->phy.last_event = status;
-		atomic_notifier_call_chain(&twl->phy.notifier, status,
-							otg->gadget);
+		omap_musb_mailbox(OMAP_MUSB_ID_GROUND);
 	} else  {
 		twl6030_writeb(twl, TWL_MODULE_USB, USB_ID_INT_EN_HI_CLR,
 								0x10);
@@ -326,23 +276,8 @@ static irqreturn_t twl6030_usbotg_irq(int irq, void *_twl)
 	return IRQ_HANDLED;
 }
 
-static int twl6030_set_peripheral(struct usb_otg *otg,
-		struct usb_gadget *gadget)
-{
-	if (!otg)
-		return -ENODEV;
-
-	otg->gadget = gadget;
-	if (!gadget)
-		otg->phy->state = OTG_STATE_UNDEFINED;
-
-	return 0;
-}
-
-static int twl6030_enable_irq(struct usb_phy *x)
+static int twl6030_enable_irq(struct twl6030_usb *twl)
 {
-	struct twl6030_usb *twl = phy_to_twl(x);
-
 	twl6030_writeb(twl, TWL_MODULE_USB, USB_ID_INT_EN_HI_SET, 0x1);
 	twl6030_interrupt_unmask(0x05, REG_INT_MSK_LINE_C);
 	twl6030_interrupt_unmask(0x05, REG_INT_MSK_STS_C);
@@ -375,9 +310,9 @@ static void otg_set_vbus_work(struct work_struct *data)
 							CHARGERUSB_CTRL1);
 }
 
-static int twl6030_set_vbus(struct usb_otg *otg, bool enabled)
+static int twl6030_set_vbus(struct phy_companion *comparator, bool enabled)
 {
-	struct twl6030_usb *twl = phy_to_twl(otg->phy);
+	struct twl6030_usb *twl = comparator_to_twl(comparator);
 
 	twl->vbus_enable = enabled;
 	schedule_work(&twl->set_vbus_work);
@@ -385,23 +320,11 @@ static int twl6030_set_vbus(struct usb_otg *otg, bool enabled)
 	return 0;
 }
 
-static int twl6030_set_host(struct usb_otg *otg, struct usb_bus *host)
-{
-	if (!otg)
-		return -ENODEV;
-
-	otg->host = host;
-	if (!host)
-		otg->phy->state = OTG_STATE_UNDEFINED;
-	return 0;
-}
-
 static int __devinit twl6030_usb_probe(struct platform_device *pdev)
 {
 	struct twl6030_usb	*twl;
 	int			status, err;
 	struct twl4030_usb_data *pdata;
-	struct usb_otg		*otg;
 	struct device *dev = &pdev->dev;
 	pdata = dev->platform_data;
 
@@ -409,29 +332,16 @@ static int __devinit twl6030_usb_probe(struct platform_device *pdev)
 	if (!twl)
 		return -ENOMEM;
 
-	otg = kzalloc(sizeof *otg, GFP_KERNEL);
-	if (!otg) {
-		kfree(twl);
-		return -ENOMEM;
-	}
-
 	twl->dev		= &pdev->dev;
 	twl->irq1		= platform_get_irq(pdev, 0);
 	twl->irq2		= platform_get_irq(pdev, 1);
 	twl->features		= pdata->features;
+	twl->prev_status	= OMAP_MUSB_UNKNOWN;
 
-	twl->phy.dev		= twl->dev;
-	twl->phy.label		= "twl6030";
-	twl->phy.otg		= otg;
-	twl->phy.init		= twl6030_phy_init;
-	twl->phy.shutdown	= twl6030_phy_shutdown;
-	twl->phy.set_suspend	= twl6030_phy_suspend;
+	twl->comparator.set_vbus	= twl6030_set_vbus;
+	twl->comparator.start_srp	= twl6030_start_srp;
 
-	otg->phy		= &twl->phy;
-	otg->set_host		= twl6030_set_host;
-	otg->set_peripheral	= twl6030_set_peripheral;
-	otg->set_vbus		= twl6030_set_vbus;
-	otg->start_srp		= twl6030_start_srp;
+	omap_usb2_set_comparator(&twl->comparator);
 
 	/* init spinlock for workqueue */
 	spin_lock_init(&twl->lock);
@@ -439,18 +349,14 @@ static int __devinit twl6030_usb_probe(struct platform_device *pdev)
 	err = twl6030_usb_ldo_init(twl);
 	if (err) {
 		dev_err(&pdev->dev, "ldo init failed\n");
-		kfree(otg);
 		kfree(twl);
 		return err;
 	}
-	usb_add_phy(&twl->phy, USB_PHY_TYPE_USB2);
 
 	platform_set_drvdata(pdev, twl);
 	if (device_create_file(&pdev->dev, &dev_attr_vbus))
 		dev_warn(&pdev->dev, "could not create sysfs file\n");
 
-	ATOMIC_INIT_NOTIFIER_HEAD(&twl->phy.notifier);
-
 	INIT_WORK(&twl->set_vbus_work, otg_set_vbus_work);
 
 	twl->irq_enabled = true;
@@ -461,7 +367,6 @@ static int __devinit twl6030_usb_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
 			twl->irq1, status);
 		device_remove_file(twl->dev, &dev_attr_vbus);
-		kfree(otg);
 		kfree(twl);
 		return status;
 	}
@@ -474,15 +379,12 @@ static int __devinit twl6030_usb_probe(struct platform_device *pdev)
 			twl->irq2, status);
 		free_irq(twl->irq1, twl);
 		device_remove_file(twl->dev, &dev_attr_vbus);
-		kfree(otg);
 		kfree(twl);
 		return status;
 	}
 
 	twl->asleep = 0;
-	pdata->phy_init(dev);
-	twl6030_phy_suspend(&twl->phy, 0);
-	twl6030_enable_irq(&twl->phy);
+	twl6030_enable_irq(twl);
 	dev_info(&pdev->dev, "Initialized TWL6030 USB module\n");
 
 	return 0;
@@ -492,10 +394,6 @@ static int __exit twl6030_usb_remove(struct platform_device *pdev)
 {
 	struct twl6030_usb *twl = platform_get_drvdata(pdev);
 
-	struct twl4030_usb_data *pdata;
-	struct device *dev = &pdev->dev;
-	pdata = dev->platform_data;
-
 	twl6030_interrupt_mask(TWL6030_USBOTG_INT_MASK,
 		REG_INT_MSK_LINE_C);
 	twl6030_interrupt_mask(TWL6030_USBOTG_INT_MASK,
@@ -503,10 +401,8 @@ static int __exit twl6030_usb_remove(struct platform_device *pdev)
 	free_irq(twl->irq1, twl);
 	free_irq(twl->irq2, twl);
 	regulator_put(twl->usb3v3);
-	pdata->phy_exit(twl->dev);
 	device_remove_file(twl->dev, &dev_attr_vbus);
 	cancel_work_sync(&twl->set_vbus_work);
-	kfree(twl->phy.otg);
 	kfree(twl);
 
 	return 0;
diff --git a/include/linux/usb/musb-omap.h b/include/linux/usb/musb-omap.h
new file mode 100644
index 0000000..c84224c
--- /dev/null
+++ b/include/linux/usb/musb-omap.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (C) 2011-2012 by Texas Instruments
+ *
+ * The Inventra Controller Driver for Linux is free software; you
+ * can redistribute it and/or modify it under the terms of the GNU
+ * General Public License version 2 as published by the Free Software
+ * Foundation.
+ */
+
+#ifndef __MUSB_OMAP_H__
+#define __MUSB_OMAP_H__
+
+enum omap_musb_vbus_id_status {
+	OMAP_MUSB_UNKNOWN = 0,
+	OMAP_MUSB_ID_GROUND,
+	OMAP_MUSB_ID_FLOAT,
+	OMAP_MUSB_VBUS_VALID,
+	OMAP_MUSB_VBUS_OFF,
+};
+
+#if (defined(CONFIG_USB_MUSB_OMAP2PLUS) || \
+				defined(CONFIG_USB_MUSB_OMAP2PLUS_MODULE))
+int omap_musb_mailbox(enum omap_musb_vbus_id_status status);
+#else
+static inline int omap_musb_mailbox(enum omap_musb_vbus_id_status status)
+{
+	return -EINVAL;
+}
+#endif
+
+#endif	/* __MUSB_OMAP_H__ */
-- 
1.7.5.4

