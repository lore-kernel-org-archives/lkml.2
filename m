Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab2KNFvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:51:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55228 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756418Ab2KNFvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:51:00 -0500
Message-Id: <20121114053939.552799152@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:14 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>
Subject: [ 41/82] HID: microsoft: fix invalid rdesc for 3k kbd
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 3ccc60f9d8c39180c205dba1a020735bda1b2491 upstream.

Microsoft Digital Media Keyboard 3000 has two interfaces, and the
second one has a report descriptor with a bug. The second collection
says:
05 01 -- global; usage page -- 01 -- Generic Desktop Controls
09 80 -- local; usage -- 80 -- System Control
a1 01 -- main; collection -- 01 -- application

85 03 -- global; report ID -- 03
19 00 -- local; Usage Minimum -- 00
29 ff -- local; Usage Maximum -- ff
15 00 -- global; Logical Minimum -- 0
26 ff 00 -- global; Logical Maximum -- ff
81 00 -- main; input

c0 -- main; End Collection

I.e. it makes us think that there are all kinds of usages of system
control. That the keyboard is a not only a keyboard, but also a
joystick, mouse, gamepad, keypad, etc. The same as for the Wireless
Desktop Receiver, this should be Physical Min/Max. So fix that
appropriately.

References: https://bugzilla.novell.com/show_bug.cgi?id=776834
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-microsoft.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index 3acdcfc..f676c01 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -28,22 +28,30 @@
 #define MS_RDESC		0x08
 #define MS_NOGET		0x10
 #define MS_DUPLICATE_USAGES	0x20
+#define MS_RDESC_3K		0x40
 
-/*
- * Microsoft Wireless Desktop Receiver (Model 1028) has
- * 'Usage Min/Max' where it ought to have 'Physical Min/Max'
- */
 static __u8 *ms_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
 
+	/*
+	 * Microsoft Wireless Desktop Receiver (Model 1028) has
+	 * 'Usage Min/Max' where it ought to have 'Physical Min/Max'
+	 */
 	if ((quirks & MS_RDESC) && *rsize == 571 && rdesc[557] == 0x19 &&
 			rdesc[559] == 0x29) {
 		hid_info(hdev, "fixing up Microsoft Wireless Receiver Model 1028 report descriptor\n");
 		rdesc[557] = 0x35;
 		rdesc[559] = 0x45;
 	}
+	/* the same as above (s/usage/physical/) */
+	if ((quirks & MS_RDESC_3K) && *rsize == 106 &&
+			!memcmp((char []){ 0x19, 0x00, 0x29, 0xff },
+				&rdesc[94], 4)) {
+		rdesc[94] = 0x35;
+		rdesc[96] = 0x45;
+	}
 	return rdesc;
 }
 
@@ -192,7 +200,7 @@ static const struct hid_device_id ms_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_USB),
 		.driver_data = MS_PRESENTER },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_DIGITAL_MEDIA_3K),
-		.driver_data = MS_ERGONOMY },
+		.driver_data = MS_ERGONOMY | MS_RDESC_3K },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_WIRELESS_OPTICAL_DESKTOP_3_0),
 		.driver_data = MS_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_COMFORT_MOUSE_4500),


