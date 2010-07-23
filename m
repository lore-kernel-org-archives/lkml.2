Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab0GWJgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 05:36:14 -0400
Received: from adelie.canonical.com ([91.189.90.139]:42288 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab0GWJgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 05:36:12 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: felipe.balbi@nokia.com, linux-usb@vger.kernel.org
Cc: kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org,
        ricardo.salveti@canonical.com
Subject: [PATCH] musb: move usb_add_hcd to the core init code from gadget code
Date: Fri, 23 Jul 2010 17:36:09 +0800
Message-Id: <1279877769-5210-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/608312

usb_add_hcd was only called when we insmod the gadget class module or built-in
that gadget class driver. If musb is configured as OTG controller, we need to
insmod or built-in gadget class driver to make our Host mode fucntion works.

In our Ubuntu system, normally we compiled all the gadget class drivers as
modules. Then users can insmod the gadget modules as they want. But without the
gadget class driver running, we needs host function to support common USB
devices.

This patch fix this issue and tested on omap3 beagle boards.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/usb/musb/musb_core.c   |   15 +++++++--------
 drivers/usb/musb/musb_gadget.c |   18 ------------------
 2 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 5eb9318..6b30a6d 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1521,14 +1521,6 @@ irqreturn_t musb_interrupt(struct musb *musb)
 		(devctl & MUSB_DEVCTL_HM) ? "host" : "peripheral",
 		musb->int_usb, musb->int_tx, musb->int_rx);
 
-#ifdef CONFIG_USB_GADGET_MUSB_HDRC
-	if (is_otg_enabled(musb) || is_peripheral_enabled(musb))
-		if (!musb->gadget_driver) {
-			DBG(5, "No gadget driver loaded\n");
-			return IRQ_HANDLED;
-		}
-#endif
-
 	/* the core can interrupt us for multiple reasons; docs have
 	 * a generic interrupt flowchart to follow
 	 */
@@ -2071,6 +2063,13 @@ bad_config:
 		if (status)
 			goto fail;
 
+		if (is_otg_enabled(musb)) {
+			status = usb_add_hcd(musb_to_hcd(musb), -1, 0);
+			if (status)
+				goto fail;
+			musb_start(musb);
+		}
+
 		DBG(1, "%s mode, status %d, dev%02x\n",
 			is_otg_enabled(musb) ? "OTG" : "PERIPHERAL",
 			status,
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index cbcf14a..ddeb9d8 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1748,24 +1748,6 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 		otg_set_peripheral(musb->xceiv, &musb->g);
 
 		spin_unlock_irqrestore(&musb->lock, flags);
-
-		if (is_otg_enabled(musb)) {
-			DBG(3, "OTG startup...\n");
-
-			/* REVISIT:  funcall to other code, which also
-			 * handles power budgeting ... this way also
-			 * ensures HdrcStart is indirectly called.
-			 */
-			retval = usb_add_hcd(musb_to_hcd(musb), -1, 0);
-			if (retval < 0) {
-				DBG(1, "add_hcd failed, %d\n", retval);
-				spin_lock_irqsave(&musb->lock, flags);
-				otg_set_peripheral(musb->xceiv, NULL);
-				musb->gadget_driver = NULL;
-				musb->g.dev.driver = NULL;
-				spin_unlock_irqrestore(&musb->lock, flags);
-			}
-		}
 	}
 
 	return retval;
-- 
1.7.0.4

