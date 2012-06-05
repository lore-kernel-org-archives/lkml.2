Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761556Ab2FEJjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:39:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35641 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761546Ab2FEJir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:38:47 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <balbi@ti.com>
Subject: [PATCH 3/5] drivers: usb: musb: move otg specific initializations from twl to glue
Date: Tue, 5 Jun 2012 15:08:36 +0530
Message-ID: <1338889118-10032-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1338889118-10032-1-git-send-email-kishon@ti.com>
References: <1338889118-10032-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved otg specific state(OTG_STATE_B_IDLE, OTG_STATE_A_IDLE) initializations
from twl to glue. These initializations are removed from twl4030 and
twl6030 and moved to the mailbox API defined in glue.
This is part of the cleanup in preparation to make use of usb2 phy
driver.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/musb/omap2430.c   |    5 +++++
 drivers/usb/otg/twl4030-usb.c |    8 --------
 drivers/usb/otg/twl6030-usb.c |    6 ------
 3 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 7139e57..24d1cd5 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -249,11 +249,14 @@ static void omap_musb_set_mailbox(struct omap2430_glue *glue)
 	struct device *dev = musb->controller;
 	struct musb_hdrc_platform_data *pdata = dev->platform_data;
 	struct omap_musb_board_data *data = pdata->board_data;
+	struct usb_otg *otg = musb->xceiv->otg;
 
 	switch (glue->status) {
 	case OMAP_MUSB_ID_GROUND:
 		dev_dbg(dev, "ID GND\n");
 
+		otg->default_a = true;
+		musb->xceiv->state = OTG_STATE_A_IDLE;
 		musb->xceiv->last_event = USB_EVENT_ID;
 		if (!is_otg_enabled(musb) || musb->gadget_driver) {
 			pm_runtime_get_sync(dev);
@@ -265,6 +268,8 @@ static void omap_musb_set_mailbox(struct omap2430_glue *glue)
 	case OMAP_MUSB_VBUS_VALID:
 		dev_dbg(dev, "VBUS Connect\n");
 
+		otg->default_a = false;
+		musb->xceiv->state = OTG_STATE_B_IDLE;
 		musb->xceiv->last_event = USB_EVENT_VBUS;
 		if (musb->gadget_driver)
 			pm_runtime_get_sync(dev);
diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index 05dc659..03368c3 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -251,7 +251,6 @@ static enum omap_musb_vbus_id_status
 {
 	int	status;
 	enum omap_musb_vbus_id_status linkstat = OMAP_MUSB_UNKNOWN;
-	struct usb_otg *otg = twl->phy.otg;
 
 	twl->vbus_supplied = false;
 
@@ -289,13 +288,6 @@ static enum omap_musb_vbus_id_status
 
 	spin_lock_irq(&twl->lock);
 	twl->linkstat = linkstat;
-	if (linkstat == OMAP_MUSB_ID_GROUND) {
-		otg->default_a = true;
-		twl->phy.state = OTG_STATE_A_IDLE;
-	} else {
-		otg->default_a = false;
-		twl->phy.state = OTG_STATE_B_IDLE;
-	}
 	spin_unlock_irq(&twl->lock);
 
 	return linkstat;
diff --git a/drivers/usb/otg/twl6030-usb.c b/drivers/usb/otg/twl6030-usb.c
index 6c75883..66cfea7 100644
--- a/drivers/usb/otg/twl6030-usb.c
+++ b/drivers/usb/otg/twl6030-usb.c
@@ -256,7 +256,6 @@ static DEVICE_ATTR(vbus, 0444, twl6030_usb_vbus_show, NULL);
 static irqreturn_t twl6030_usb_irq(int irq, void *_twl)
 {
 	struct twl6030_usb *twl = _twl;
-	struct usb_otg *otg = twl->phy.otg;
 	enum omap_musb_vbus_id_status status = OMAP_MUSB_UNKNOWN;
 	u8 vbus_state, hw_state;
 
@@ -269,8 +268,6 @@ static irqreturn_t twl6030_usb_irq(int irq, void *_twl)
 			regulator_enable(twl->usb3v3);
 			twl->asleep = 1;
 			status = OMAP_MUSB_VBUS_VALID;
-			otg->default_a = false;
-			twl->phy.state = OTG_STATE_B_IDLE;
 			twl->linkstat = status;
 			omap_musb_mailbox(status);
 		} else {
@@ -293,7 +290,6 @@ static irqreturn_t twl6030_usb_irq(int irq, void *_twl)
 static irqreturn_t twl6030_usbotg_irq(int irq, void *_twl)
 {
 	struct twl6030_usb *twl = _twl;
-	struct usb_otg *otg = twl->phy.otg;
 	enum omap_musb_vbus_id_status status = OMAP_MUSB_UNKNOWN;
 	u8 hw_state;
 
@@ -307,8 +303,6 @@ static irqreturn_t twl6030_usbotg_irq(int irq, void *_twl)
 		twl6030_writeb(twl, TWL_MODULE_USB, USB_ID_INT_EN_HI_SET,
 								0x10);
 		status = OMAP_MUSB_ID_GROUND;
-		otg->default_a = true;
-		twl->phy.state = OTG_STATE_A_IDLE;
 		twl->linkstat = status;
 		omap_musb_mailbox(status);
 	} else  {
-- 
1.7.5.4

