Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762155Ab2FVNdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:33:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41192 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932990Ab2FVNdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:33:02 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <kishon@ti.com>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <balbi@ti.com>,
        <hvaibhav@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: [RFC PATCH 03/10] drivers: usb: otg: make twl6030_usb as a comparator driver to omap_usb2
Date: Fri, 22 Jun 2012 19:02:12 +0530
Message-ID: <1340371939-23572-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340371939-23572-1-git-send-email-kishon@ti.com>
References: <1340371939-23572-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the PHY configuration other than VBUS, ID GND and OTG SRP are removed
from twl6030. The phy configurations are taken care by the dedicated
usb2 phy driver. So twl6030 is made as comparator driver for VBUS and
ID detection.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/musb/omap2430.c   |   38 +++++++++++---
 drivers/usb/otg/twl6030-usb.c |  114 +++++------------------------------------
 2 files changed, 44 insertions(+), 108 deletions(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 2813490..9a836e8 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -35,6 +35,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/err.h>
 #include <linux/usb/musb-omap.h>
+#include <linux/usb/omap4_usb_phy.h>
+#include <linux/mfd/omap_control.h>
 
 #include "musb_core.h"
 #include "omap2430.h"
@@ -44,6 +46,7 @@ struct omap2430_glue {
 	struct platform_device	*musb;
 	enum omap_musb_vbus_id_status status;
 	struct work_struct	omap_musb_mailbox_work;
+	struct device		*control_dev;
 };
 #define glue_to_musb(g)		platform_get_drvdata(g->musb)
 
@@ -245,6 +248,7 @@ EXPORT_SYMBOL_GPL(omap_musb_mailbox);
 
 static void omap_musb_set_mailbox(struct omap2430_glue *glue)
 {
+	u32 val;
 	struct musb *musb = glue_to_musb(glue);
 	struct device *dev = musb->controller;
 	struct musb_hdrc_platform_data *pdata = dev->platform_data;
@@ -260,7 +264,10 @@ static void omap_musb_set_mailbox(struct omap2430_glue *glue)
 		musb->xceiv->last_event = USB_EVENT_ID;
 		if (!is_otg_enabled(musb) || musb->gadget_driver) {
 			pm_runtime_get_sync(dev);
-			usb_phy_init(musb->xceiv);
+			if (!IS_ERR(glue->control_dev)) {
+				val = AVALID | VBUSVALID;
+				omap4_usb_phy_mailbox(glue->control_dev, val);
+			}
 			omap2430_musb_set_vbus(musb, 1);
 		}
 		break;
@@ -273,7 +280,10 @@ static void omap_musb_set_mailbox(struct omap2430_glue *glue)
 		musb->xceiv->last_event = USB_EVENT_VBUS;
 		if (musb->gadget_driver)
 			pm_runtime_get_sync(dev);
-		usb_phy_init(musb->xceiv);
+		if (!IS_ERR(glue->control_dev)) {
+			val = IDDIG | AVALID | VBUSVALID;
+			omap4_usb_phy_mailbox(glue->control_dev, val);
+		}
 		break;
 
 	case OMAP_MUSB_ID_FLOAT:
@@ -291,7 +301,10 @@ static void omap_musb_set_mailbox(struct omap2430_glue *glue)
 			if (musb->xceiv->otg->set_vbus)
 				otg_set_vbus(musb->xceiv->otg, 0);
 		}
-		usb_phy_shutdown(musb->xceiv);
+		if (!IS_ERR(glue->control_dev)) {
+			val = SESSEND | IDDIG;
+			omap4_usb_phy_mailbox(glue->control_dev, val);
+		}
 		break;
 	default:
 		dev_dbg(dev, "ID float\n");
@@ -366,6 +379,7 @@ err1:
 static void omap2430_musb_enable(struct musb *musb)
 {
 	u8		devctl;
+	u32		val;
 	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
 	struct device *dev = musb->controller;
 	struct omap2430_glue *glue = dev_get_drvdata(dev->parent);
@@ -375,7 +389,10 @@ static void omap2430_musb_enable(struct musb *musb)
 	switch (glue->status) {
 
 	case OMAP_MUSB_ID_GROUND:
-		usb_phy_init(musb->xceiv);
+		if (!IS_ERR(glue->control_dev)) {
+			val = AVALID | VBUSVALID;
+			omap4_usb_phy_mailbox(glue->control_dev, val);
+		}
 		if (data->interface_type != MUSB_INTERFACE_UTMI)
 			break;
 		devctl = musb_readb(musb->mregs, MUSB_DEVCTL);
@@ -394,7 +411,10 @@ static void omap2430_musb_enable(struct musb *musb)
 		break;
 
 	case OMAP_MUSB_VBUS_VALID:
-		usb_phy_init(musb->xceiv);
+		if (!IS_ERR(glue->control_dev)) {
+			val = IDDIG | AVALID | VBUSVALID;
+			omap4_usb_phy_mailbox(glue->control_dev, val);
+		}
 		break;
 
 	default:
@@ -404,11 +424,14 @@ static void omap2430_musb_enable(struct musb *musb)
 
 static void omap2430_musb_disable(struct musb *musb)
 {
+	u32 val;
 	struct device *dev = musb->controller;
 	struct omap2430_glue *glue = dev_get_drvdata(dev->parent);
 
-	if (glue->status != OMAP_MUSB_UNKNOWN)
-		usb_phy_shutdown(musb->xceiv);
+	if (glue->status != OMAP_MUSB_UNKNOWN && !IS_ERR(glue->control_dev)) {
+		val = SESSEND | IDDIG;
+		omap4_usb_phy_mailbox(glue->control_dev, val);
+	}
 }
 
 static int omap2430_musb_exit(struct musb *musb)
@@ -461,6 +484,7 @@ static int __devinit omap2430_probe(struct platform_device *pdev)
 	glue->dev			= &pdev->dev;
 	glue->musb			= musb;
 	glue->status			= OMAP_MUSB_UNKNOWN;
+	glue->control_dev		= omap_control_get();
 
 	pdata->platform_ops		= &omap2430_ops;
 
diff --git a/drivers/usb/otg/twl6030-usb.c b/drivers/usb/otg/twl6030-usb.c
index 600c27a..6a361d2 100644
--- a/drivers/usb/otg/twl6030-usb.c
+++ b/drivers/usb/otg/twl6030-usb.c
@@ -25,8 +25,9 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
-#include <linux/usb/otg.h>
 #include <linux/usb/musb-omap.h>
+#include <linux/usb/phy_companion.h>
+#include <linux/usb/omap_usb.h>
 #include <linux/i2c/twl.h>
 #include <linux/regulator/consumer.h>
 #include <linux/err.h>
@@ -87,7 +88,7 @@
 #define	VBUS_DET			BIT(2)
 
 struct twl6030_usb {
-	struct usb_phy		phy;
+	struct phy_companion	comparator;
 	struct device		*dev;
 
 	/* for vbus reporting with irqs disabled */
@@ -107,7 +108,7 @@ struct twl6030_usb {
 	unsigned long		features;
 };
 
-#define phy_to_twl(x)		container_of((x), struct twl6030_usb, phy)
+#define	comparator_to_twl(x) container_of((x), struct twl6030_usb, comparator)
 
 /*-------------------------------------------------------------------------*/
 
@@ -137,50 +138,9 @@ static inline u8 twl6030_readb(struct twl6030_usb *twl, u8 module, u8 address)
 	return ret;
 }
 
-static int twl6030_phy_init(struct usb_phy *x)
+static int twl6030_start_srp(struct phy_companion *comparator)
 {
-	struct twl6030_usb *twl;
-	struct device *dev;
-	struct twl4030_usb_data *pdata;
-
-	twl = phy_to_twl(x);
-	dev  = twl->dev;
-	pdata = dev->platform_data;
-
-	if (twl->linkstat == OMAP_MUSB_ID_GROUND)
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
-{
-	struct twl6030_usb *twl = phy_to_twl(otg->phy);
+	struct twl6030_usb *twl = comparator_to_twl(comparator);
 
 	twl6030_writeb(twl, TWL_MODULE_USB, 0x24, USB_VBUS_CTRL_SET);
 	twl6030_writeb(twl, TWL_MODULE_USB, 0x84, USB_VBUS_CTRL_SET);
@@ -316,23 +276,8 @@ static irqreturn_t twl6030_usbotg_irq(int irq, void *_twl)
 	return IRQ_HANDLED;
 }
 
-static int twl6030_set_peripheral(struct usb_otg *otg,
-		struct usb_gadget *gadget)
+static int twl6030_enable_irq(struct twl6030_usb *twl)
 {
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
-{
-	struct twl6030_usb *twl = phy_to_twl(x);
-
 	twl6030_writeb(twl, TWL_MODULE_USB, USB_ID_INT_EN_HI_SET, 0x1);
 	twl6030_interrupt_unmask(0x05, REG_INT_MSK_LINE_C);
 	twl6030_interrupt_unmask(0x05, REG_INT_MSK_STS_C);
@@ -365,9 +310,9 @@ static void otg_set_vbus_work(struct work_struct *data)
 							CHARGERUSB_CTRL1);
 }
 
-static int twl6030_set_vbus(struct usb_otg *otg, bool enabled)
+static int twl6030_set_vbus(struct phy_companion *comparator, bool enabled)
 {
-	struct twl6030_usb *twl = phy_to_twl(otg->phy);
+	struct twl6030_usb *twl = comparator_to_twl(comparator);
 
 	twl->vbus_enable = enabled;
 	schedule_work(&twl->set_vbus_work);
@@ -375,23 +320,11 @@ static int twl6030_set_vbus(struct usb_otg *otg, bool enabled)
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
 
@@ -399,28 +332,15 @@ static int __devinit twl6030_usb_probe(struct platform_device *pdev)
 	if (!twl)
 		return -ENOMEM;
 
-	otg = devm_kzalloc(dev, sizeof *otg, GFP_KERNEL);
-	if (!otg)
-		return -ENOMEM;
-
 	twl->dev		= &pdev->dev;
 	twl->irq1		= platform_get_irq(pdev, 0);
 	twl->irq2		= platform_get_irq(pdev, 1);
 	twl->features		= pdata->features;
 	twl->linkstat		= OMAP_MUSB_UNKNOWN;
 
-	twl->phy.dev		= twl->dev;
-	twl->phy.label		= "twl6030";
-	twl->phy.otg		= otg;
-	twl->phy.init		= twl6030_phy_init;
-	twl->phy.shutdown	= twl6030_phy_shutdown;
-	twl->phy.set_suspend	= twl6030_phy_suspend;
-
-	otg->phy		= &twl->phy;
-	otg->set_host		= twl6030_set_host;
-	otg->set_peripheral	= twl6030_set_peripheral;
-	otg->set_vbus		= twl6030_set_vbus;
-	otg->start_srp		= twl6030_start_srp;
+	twl->comparator.set_vbus	= twl6030_set_vbus;
+	twl->comparator.start_srp	= twl6030_start_srp;
+	omap_usb2_set_comparator(&twl->comparator);
 
 	/* init spinlock for workqueue */
 	spin_lock_init(&twl->lock);
@@ -430,7 +350,6 @@ static int __devinit twl6030_usb_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "ldo init failed\n");
 		return err;
 	}
-	usb_add_phy(&twl->phy, USB_PHY_TYPE_USB2);
 
 	platform_set_drvdata(pdev, twl);
 	if (device_create_file(&pdev->dev, &dev_attr_vbus))
@@ -461,9 +380,7 @@ static int __devinit twl6030_usb_probe(struct platform_device *pdev)
 	}
 
 	twl->asleep = 0;
-	pdata->phy_init(dev);
-	twl6030_phy_suspend(&twl->phy, 0);
-	twl6030_enable_irq(&twl->phy);
+	twl6030_enable_irq(twl);
 	dev_info(&pdev->dev, "Initialized TWL6030 USB module\n");
 
 	return 0;
@@ -473,10 +390,6 @@ static int __exit twl6030_usb_remove(struct platform_device *pdev)
 {
 	struct twl6030_usb *twl = platform_get_drvdata(pdev);
 
-	struct twl4030_usb_data *pdata;
-	struct device *dev = &pdev->dev;
-	pdata = dev->platform_data;
-
 	twl6030_interrupt_mask(TWL6030_USBOTG_INT_MASK,
 		REG_INT_MSK_LINE_C);
 	twl6030_interrupt_mask(TWL6030_USBOTG_INT_MASK,
@@ -484,7 +397,6 @@ static int __exit twl6030_usb_remove(struct platform_device *pdev)
 	free_irq(twl->irq1, twl);
 	free_irq(twl->irq2, twl);
 	regulator_put(twl->usb3v3);
-	pdata->phy_exit(twl->dev);
 	device_remove_file(twl->dev, &dev_attr_vbus);
 	cancel_work_sync(&twl->set_vbus_work);
 
-- 
1.7.5.4

