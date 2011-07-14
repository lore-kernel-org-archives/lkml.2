Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab1GNLwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 07:52:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33334 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab1GNLwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 07:52:02 -0400
From: Viliam Mateicka <viliam.mateicka@gmail.com>
To: "David S . Miller " <davem@davemloft.net>, mirq-linux@rere.qmqm.pl,
        Steve Glendinning <steve.glendinning@smsc.com>,
        Rabin Vincent <rabin@rab.in>, David Decotigny <decot@google.com>,
        linux-kernel@vger.kernel.org
Cc: Viliam Mateicka <viliam.mateicka@gmail.com>
Subject: [PATCH] smsc95xx: add missing .reset_resume hook and reset card
Date: Thu, 14 Jul 2011 13:51:46 +0200
Message-Id: <1310644306-16180-1-git-send-email-viliam.mateicka@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the undefined behaviour (random MAC, interface goes down) of smsc95xx driver after resume from suspend.
Calling smsc95xx_reset() is needed to properly set hw registers of card and bring interface up to defined state.

Signed-off-by: Viliam Mateicka <viliam.mateicka@gmail.com>
---
 drivers/net/usb/smsc95xx.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index f74f3ce..5c33be8 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1181,6 +1181,17 @@ static struct sk_buff *smsc95xx_tx_fixup(struct usbnet *dev,
 	return skb;
 }
 
+static int smsc95xx_reset_resume(struct usb_interface *intf)
+{
+	struct usbnet	*dev = usb_get_intfdata(intf);
+
+	smsc95xx_reset(dev);
+
+	usbnet_resume(intf);
+
+	return 0;
+}
+
 static const struct driver_info smsc95xx_info = {
 	.description	= "smsc95xx USB 2.0 Ethernet",
 	.bind		= smsc95xx_bind,
@@ -1295,6 +1306,7 @@ static struct usb_driver smsc95xx_driver = {
 	.suspend	= usbnet_suspend,
 	.resume		= usbnet_resume,
 	.disconnect	= usbnet_disconnect,
+	.reset_resume	= smsc95xx_reset_resume,
 };
 
 static int __init smsc95xx_init(void)
-- 
1.7.4.1

