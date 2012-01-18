Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab2ARLvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:51:41 -0500
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:58458 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab2ARLvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:51:39 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] HID: multitouch: support Perixx PERIPAD 701
Date: Wed, 18 Jan 2012 12:51:08 +0100
Message-Id: <1326887468-5148-4-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1326887468-5148-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1326887468-5148-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perixx Peripad 701 is an hybrid device which presents a touchpad and
a keyboard on the same surface. The switch between the two is controlled
by a physical switch, and the firmware sends the events on the right
interface (mouse, keyboard or multitouch).
This patch enables the multitouch interface of this device to work.

We need to manually declare the device as a trackpad (we cannot infer it
from the reports descriptors as the device works under Windows, a system
that does not allow multitouch touchpad).
We also need to set the hid feature MAX CONTACT NUMBER to 2 or the device
stops sending events once it has been pressed by two touches.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/Kconfig          |    1 +
 drivers/hid/hid-ids.h        |    1 +
 drivers/hid/hid-multitouch.c |   11 +++++++++++
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index a421abd..f7c43b6 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -355,6 +355,7 @@ config HID_MULTITOUCH
 	  - Lumio CrystalTouch panels
 	  - MosArt dual-touch panels
 	  - PenMount dual touch panels
+	  - Perixx Peripad 701 touchpad
 	  - PixArt optical touch screen
 	  - Pixcir dual touch panels
 	  - Quanta panels
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index b8574cd..662a0b6 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -659,6 +659,7 @@
 
 #define USB_VENDOR_ID_TOPSEED2		0x1784
 #define USB_DEVICE_ID_TOPSEED2_RF_COMBO	0x0004
+#define USB_DEVICE_ID_TOPSEED2_PERIPAD_701	0x0016
 
 #define USB_VENDOR_ID_TOPMAX		0x0663
 #define USB_DEVICE_ID_TOPMAX_COBRAPAD	0x0103
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index fd978c9..8a6b823 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -103,6 +103,7 @@ struct mt_device {
 #define MT_CLS_CYPRESS				0x0102
 #define MT_CLS_EGALAX				0x0103
 #define MT_CLS_EGALAX_SERIAL			0x0104
+#define MT_CLS_TOPSEED				0x0105
 
 #define MT_DEFAULT_MAXCONTACT	10
 
@@ -192,6 +193,11 @@ static struct mt_class mt_classes[] = {
 		.sn_move = 4096,
 		.sn_pressure = 32,
 	},
+	{ .name = MT_CLS_TOPSEED,
+		.quirks = MT_QUIRK_ALWAYS_VALID,
+		.is_indirect = true,
+		.maxcontacts = 2,
+	},
 
 	{ }
 };
@@ -904,6 +910,11 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_STANTUM_SITRONIX,
 			USB_DEVICE_ID_MTP_SITRONIX)},
 
+	/* TopSeed panels */
+	{ .driver_data = MT_CLS_TOPSEED,
+		HID_USB_DEVICE(USB_VENDOR_ID_TOPSEED2,
+			USB_DEVICE_ID_TOPSEED2_PERIPAD_701) },
+
 	/* Touch International panels */
 	{ .driver_data = MT_CLS_DEFAULT,
 		HID_USB_DEVICE(USB_VENDOR_ID_TOUCH_INTL,
-- 
1.7.4.4

