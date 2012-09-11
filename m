Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab2IKJLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 05:11:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48921 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756967Ab2IKJLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 05:11:48 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <kishon@ti.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: [PATCH v2 2/3] usb: musb: omap: write directly to mailbox instead of using phy
Date: Tue, 11 Sep 2012 14:39:39 +0530
Message-ID: <1347354580-5895-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347354580-5895-1-git-send-email-kishon@ti.com>
References: <1347354580-5895-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The glue layer should directly write to mailbox register (present in
control module) instead of calling phy layer to write to mailbox
register. Writing to mailbox register notifies the core of events like
device connect/disconnect.

Currently writing to control module register is taken care in this
driver which will be removed once the control module driver is in place.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/musb/omap2430.c |   52 +++++++++++++++++++++++++++++++++++++------
 drivers/usb/musb/omap2430.h |    9 ++++++++
 2 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 02c39a7..f4d9503 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -45,6 +45,7 @@ struct omap2430_glue {
 	struct platform_device	*musb;
 	enum omap_musb_vbus_id_status status;
 	struct work_struct	omap_musb_mailbox_work;
+	u32 __iomem		*control_otghs;
 };
 #define glue_to_musb(g)		platform_get_drvdata(g->musb)
 
@@ -52,6 +53,26 @@ struct omap2430_glue		*_glue;
 
 static struct timer_list musb_idle_timer;
 
+/**
+ * omap4_usb_phy_mailbox - write to usb otg mailbox
+ * @glue: struct omap2430_glue *
+ * @val: the value to be written to the mailbox
+ *
+ * On detection of a device (ID pin is grounded), this API should be called
+ * to set AVALID, VBUSVALID and ID pin is grounded.
+ *
+ * When OMAP is connected to a host (OMAP in device mode), this API
+ * is called to set AVALID, VBUSVALID and ID pin in high impedance.
+ *
+ * XXX: This function will be removed once we have a seperate driver for
+ * control module
+ */
+static void omap4_usb_phy_mailbox(struct omap2430_glue *glue, u32 val)
+{
+	if (glue->control_otghs)
+		writel(val, glue->control_otghs);
+}
+
 static void musb_do_idle(unsigned long _musb)
 {
 	struct musb	*musb = (void *)_musb;
@@ -247,6 +268,7 @@ EXPORT_SYMBOL_GPL(omap_musb_mailbox);
 
 static void omap_musb_set_mailbox(struct omap2430_glue *glue)
 {
+	u32 val;
 	struct musb *musb = glue_to_musb(glue);
 	struct device *dev = musb->controller;
 	struct musb_hdrc_platform_data *pdata = dev->platform_data;
@@ -262,7 +284,8 @@ static void omap_musb_set_mailbox(struct omap2430_glue *glue)
 		musb->xceiv->last_event = USB_EVENT_ID;
 		if (musb->gadget_driver) {
 			pm_runtime_get_sync(dev);
-			usb_phy_init(musb->xceiv);
+			val = AVALID | VBUSVALID;
+			omap4_usb_phy_mailbox(glue, val);
 			omap2430_musb_set_vbus(musb, 1);
 		}
 		break;
@@ -275,7 +298,8 @@ static void omap_musb_set_mailbox(struct omap2430_glue *glue)
 		musb->xceiv->last_event = USB_EVENT_VBUS;
 		if (musb->gadget_driver)
 			pm_runtime_get_sync(dev);
-		usb_phy_init(musb->xceiv);
+		val = IDDIG | AVALID | VBUSVALID;
+		omap4_usb_phy_mailbox(glue, val);
 		break;
 
 	case OMAP_MUSB_ID_FLOAT:
@@ -292,7 +316,8 @@ static void omap_musb_set_mailbox(struct omap2430_glue *glue)
 			if (musb->xceiv->otg->set_vbus)
 				otg_set_vbus(musb->xceiv->otg, 0);
 		}
-		usb_phy_shutdown(musb->xceiv);
+		val = SESSEND | IDDIG;
+		omap4_usb_phy_mailbox(glue, val);
 		break;
 	default:
 		dev_dbg(dev, "ID float\n");
@@ -367,6 +392,7 @@ err1:
 static void omap2430_musb_enable(struct musb *musb)
 {
 	u8		devctl;
+	u32		val;
 	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
 	struct device *dev = musb->controller;
 	struct omap2430_glue *glue = dev_get_drvdata(dev->parent);
@@ -376,7 +402,8 @@ static void omap2430_musb_enable(struct musb *musb)
 	switch (glue->status) {
 
 	case OMAP_MUSB_ID_GROUND:
-		usb_phy_init(musb->xceiv);
+		val = AVALID | VBUSVALID;
+		omap4_usb_phy_mailbox(glue, val);
 		if (data->interface_type != MUSB_INTERFACE_UTMI)
 			break;
 		devctl = musb_readb(musb->mregs, MUSB_DEVCTL);
@@ -395,7 +422,8 @@ static void omap2430_musb_enable(struct musb *musb)
 		break;
 
 	case OMAP_MUSB_VBUS_VALID:
-		usb_phy_init(musb->xceiv);
+		val = IDDIG | AVALID | VBUSVALID;
+		omap4_usb_phy_mailbox(glue, val);
 		break;
 
 	default:
@@ -405,11 +433,14 @@ static void omap2430_musb_enable(struct musb *musb)
 
 static void omap2430_musb_disable(struct musb *musb)
 {
+	u32 val;
 	struct device *dev = musb->controller;
 	struct omap2430_glue *glue = dev_get_drvdata(dev->parent);
 
-	if (glue->status != OMAP_MUSB_UNKNOWN)
-		usb_phy_shutdown(musb->xceiv);
+	if (glue->status != OMAP_MUSB_UNKNOWN) {
+		val = SESSEND | IDDIG;
+		omap4_usb_phy_mailbox(glue, val);
+	}
 }
 
 static int omap2430_musb_exit(struct musb *musb)
@@ -441,6 +472,7 @@ static int __devinit omap2430_probe(struct platform_device *pdev)
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
 	struct platform_device		*musb;
 	struct omap2430_glue		*glue;
+	struct resource			*res;
 	int				ret = -ENOMEM;
 
 	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
@@ -463,6 +495,12 @@ static int __devinit omap2430_probe(struct platform_device *pdev)
 	glue->musb			= musb;
 	glue->status			= OMAP_MUSB_UNKNOWN;
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+
+	glue->control_otghs = devm_request_and_ioremap(&pdev->dev, res);
+	if (glue->control_otghs == NULL)
+		dev_dbg(&pdev->dev, "Failed to obtain control memory\n");
+
 	pdata->platform_ops		= &omap2430_ops;
 
 	platform_set_drvdata(pdev, glue);
diff --git a/drivers/usb/musb/omap2430.h b/drivers/usb/musb/omap2430.h
index 40b3c02..b85f397 100644
--- a/drivers/usb/musb/omap2430.h
+++ b/drivers/usb/musb/omap2430.h
@@ -49,4 +49,13 @@
 #define OTG_FORCESTDBY		0x414
 #	define	ENABLEFORCE		(1 << 0)
 
+/*
+ * Control Module bit definitions
+ * XXX: Will be removed once we have a driver for control module.
+ */
+#define	AVALID				BIT(0)
+#define	BVALID				BIT(1)
+#define	VBUSVALID			BIT(2)
+#define	SESSEND				BIT(3)
+#define	IDDIG				BIT(4)
 #endif	/* __MUSB_OMAP243X_H__ */
-- 
1.7.9.5

