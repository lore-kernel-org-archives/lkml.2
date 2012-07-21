Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab2GUHhO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 03:37:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49211 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2GUHhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 03:37:11 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: otg: twl4030-usb: spin_unlock_irq in interrupt handler
Date: Sat, 21 Jul 2012 11:40:18 +0400
Message-Id: <1342856418-1451-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The replacement of spin_lock_irq/spin_unlock_irq pair in
twl4030_usb_linkstat function by
spin_lock_irqsave/spin_lock_irqrestore pair.
The twl4030_usb_linkstat function is called from twl4030_usb_irq
interrupt handler. Therefore reenabling of handler interrupt line
should be avoided.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 drivers/usb/otg/twl4030-usb.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index c4a86da..c89a2f5 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -251,6 +251,7 @@ static enum usb_phy_events twl4030_usb_linkstat(struct twl4030_usb *twl)
 	int	status;
 	int	linkstat = USB_EVENT_NONE;
 	struct usb_otg *otg = twl->phy.otg;
+	unsigned long flags;
 
 	twl->vbus_supplied = false;
 
@@ -288,7 +289,7 @@ static enum usb_phy_events twl4030_usb_linkstat(struct twl4030_usb *twl)
 	 * are registered, and that both are active...
 	 */
 
-	spin_lock_irq(&twl->lock);
+	spin_lock_irqsave(&twl->lock, flags);
 	twl->linkstat = linkstat;
 	if (linkstat == USB_EVENT_ID) {
 		otg->default_a = true;
@@ -297,7 +298,7 @@ static enum usb_phy_events twl4030_usb_linkstat(struct twl4030_usb *twl)
 		otg->default_a = false;
 		twl->phy.state = OTG_STATE_B_IDLE;
 	}
-	spin_unlock_irq(&twl->lock);
+	spin_unlock_irqrestore(&twl->lock, flags);
 
 	return linkstat;
 }
-- 
1.7.7

