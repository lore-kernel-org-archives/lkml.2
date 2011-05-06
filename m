Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab1EFAkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:40:21 -0400
Received: from kroah.org ([198.145.64.141]:37309 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab1EFAZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:57 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:17 2011
Message-Id: <20110506002217.480143875@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Edgar (gimli) Hucek" <gimli@dark-green.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [124/143] HID: add MacBookAir 3,1 and 3,2 support
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Edgar (gimli) Hucek <gimli@dark-green.com>

commit 99b9f758bbc904f22faffcf4d83205f4a5e7bc0c upstream.

This patch add support for the MacBookAir3,1 and MacBookAir3,2 to the hid
driver.

Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/hid/hid-apple.c |   46 ++++++++++++++++++++++++++++++++++++++++++----
 drivers/hid/hid-core.c  |   12 ++++++++++++
 drivers/hid/hid-ids.h   |    6 ++++++
 3 files changed, 60 insertions(+), 4 deletions(-)

--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -53,6 +53,27 @@ struct apple_key_translation {
 	u8 flags;
 };
 
+static const struct apple_key_translation macbookair_fn_keys[] = {
+	{ KEY_BACKSPACE, KEY_DELETE },
+	{ KEY_ENTER,	KEY_INSERT },
+	{ KEY_F1,	KEY_BRIGHTNESSDOWN, APPLE_FLAG_FKEY },
+	{ KEY_F2,	KEY_BRIGHTNESSUP,   APPLE_FLAG_FKEY },
+	{ KEY_F3,	KEY_SCALE,          APPLE_FLAG_FKEY },
+	{ KEY_F4,	KEY_DASHBOARD,      APPLE_FLAG_FKEY },
+	{ KEY_F6,	KEY_PREVIOUSSONG,   APPLE_FLAG_FKEY },
+	{ KEY_F7,	KEY_PLAYPAUSE,      APPLE_FLAG_FKEY },
+	{ KEY_F8,	KEY_NEXTSONG,       APPLE_FLAG_FKEY },
+	{ KEY_F9,	KEY_MUTE,           APPLE_FLAG_FKEY },
+	{ KEY_F10,	KEY_VOLUMEDOWN,     APPLE_FLAG_FKEY },
+	{ KEY_F11,	KEY_VOLUMEUP,       APPLE_FLAG_FKEY },
+	{ KEY_F12,	KEY_EJECTCD,        APPLE_FLAG_FKEY },
+	{ KEY_UP,	KEY_PAGEUP },
+	{ KEY_DOWN,	KEY_PAGEDOWN },
+	{ KEY_LEFT,	KEY_HOME },
+	{ KEY_RIGHT,	KEY_END },
+	{ }
+};
+
 static const struct apple_key_translation apple_fn_keys[] = {
 	{ KEY_BACKSPACE, KEY_DELETE },
 	{ KEY_ENTER,	KEY_INSERT },
@@ -151,10 +172,15 @@ static int hidinput_apple_event(struct h
 	if (fnmode) {
 		int do_translate;
 
-		trans = apple_find_translation((hid->product < 0x21d ||
-					hid->product >= 0x300) ?
-					powerbook_fn_keys : apple_fn_keys,
-					usage->code);
+		if(hid->product >= USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI &&
+				hid->product <= USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS) {
+			trans = apple_find_translation(macbookair_fn_keys, usage->code);
+		} else if (hid->product < 0x21d || hid->product >= 0x300) {
+			trans = apple_find_translation(powerbook_fn_keys, usage->code);
+		} else {
+			trans = apple_find_translation(apple_fn_keys, usage->code);
+		}
+
 		if (trans) {
 			if (test_bit(usage->code, asc->pressed_fn))
 				do_translate = 1;
@@ -431,6 +457,18 @@ static const struct hid_device_id apple_
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_JIS),
 		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI),
+		.driver_data = APPLE_HAS_FN },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING4_ISO),
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING4_JIS),
+		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING4A_ANSI),
+		.driver_data = APPLE_HAS_FN },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING4A_ISO),
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS),
+		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1287,6 +1287,12 @@ static const struct hid_device_id hid_bl
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING4_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING4_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING4A_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING4A_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS) },
@@ -1705,6 +1711,12 @@ static const struct hid_device_id hid_mo
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING4_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING4_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING4A_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING4A_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ }
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -88,6 +88,12 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI	0x0236
 #define USB_DEVICE_ID_APPLE_WELLSPRING3_ISO	0x0237
 #define USB_DEVICE_ID_APPLE_WELLSPRING3_JIS	0x0238
+#define USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI	0x023f
+#define USB_DEVICE_ID_APPLE_WELLSPRING4_ISO	0x0240
+#define USB_DEVICE_ID_APPLE_WELLSPRING4_JIS	0x0241
+#define USB_DEVICE_ID_APPLE_WELLSPRING4A_ANSI	0x0242
+#define USB_DEVICE_ID_APPLE_WELLSPRING4A_ISO	0x0243
+#define USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS	0x0244
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI  0x0239
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO   0x023a
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS   0x023b


