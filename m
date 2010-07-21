Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab0GUNPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:15:35 -0400
Received: from smarthost01.mail.zen.net.uk ([212.23.3.140]:36249 "EHLO
	smarthost01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751381Ab0GUNPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:15:33 -0400
From: Andrew Bird <ajb@spheresystems.co.uk>
To: linux-kernel@vger.kernel.org
Cc: ajb@spheresystems.co.uk
Subject: [PATCH 1/2] USB - Option.c obey reserved interface flag
Date: Wed, 21 Jul 2010 14:15:28 +0100
Message-Id: <1279718128-2367-1-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: git-send-email 1.6.2.5
X-Originating-Smarthost01-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/usb/serial/option.c |   43 ++++++++++++++++++++++++++-----------------
 1 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index e280ad8..8a1008c 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -997,10 +997,29 @@ static void __exit option_exit(void)
 module_init(option_init);
 module_exit(option_exit);
 
+static enum option_blacklist_reason is_blacklisted(const u8 ifnum,
+				const struct option_blacklist_info *blacklist)
+{
+	const u8  *info;
+	int i;
+
+	if (blacklist) {
+		info = blacklist->ifaceinfo;
+
+		for (i = 0; i < blacklist->infolen; i++) {
+			if (info[i] == ifnum)
+				return blacklist->reason;
+		}
+	}
+	return OPTION_BLACKLIST_NONE;
+}
+
 static int option_probe(struct usb_serial *serial,
 			const struct usb_device_id *id)
 {
 	struct usb_wwan_intf_private *data;
+	int ifNum = serial->interface->cur_altsetting->desc.bInterfaceNumber;
+
 	/* D-Link DWM 652 still exposes CD-Rom emulation interface in modem mode */
 	if (serial->dev->descriptor.idVendor == DLINK_VENDOR_ID &&
 		serial->dev->descriptor.idProduct == DLINK_PRODUCT_DWM_652 &&
@@ -1013,6 +1032,13 @@ static int option_probe(struct usb_serial *serial,
 		serial->interface->cur_altsetting->desc.bInterfaceClass != 0xff)
 		return -ENODEV;
 
+	/* Don't bind reserved interfaces */
+	if (is_blacklisted(ifNum, (void *)id->driver_info) ==
+			OPTION_BLACKLIST_RESERVED_IF) {
+		dbg("No bind on blacklisted interface #%d\n", ifNum);
+		return -ENODEV;
+	}
+
 	data = serial->private = kzalloc(sizeof(struct usb_wwan_intf_private), GFP_KERNEL);
 
 	if (!data)
@@ -1023,23 +1049,6 @@ static int option_probe(struct usb_serial *serial,
 	return 0;
 }
 
-static enum option_blacklist_reason is_blacklisted(const u8 ifnum,
-				const struct option_blacklist_info *blacklist)
-{
-	const u8  *info;
-	int i;
-
-	if (blacklist) {
-		info = blacklist->ifaceinfo;
-
-		for (i = 0; i < blacklist->infolen; i++) {
-			if (info[i] == ifnum)
-				return blacklist->reason;
-		}
-	}
-	return OPTION_BLACKLIST_NONE;
-}
-
 static void option_instat_callback(struct urb *urb)
 {
 	int err;
-- 
1.6.2.5

