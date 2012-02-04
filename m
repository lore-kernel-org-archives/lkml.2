Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab2BDQJN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 11:09:13 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60100 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab2BDQJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 11:09:09 -0500
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] HID: multitouch: support Perixx PERIPAD 701
Date: Sat,  4 Feb 2012 17:08:50 +0100
Message-Id: <1328371730-10944-4-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1328371730-10944-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1328371730-10944-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

Perixx Peripad 701 is an hybrid device which presents a touchpad and
a keyboard on the same surface. The switch between the two is controlled
by a physical switch, and the firmware sends the events on the right
interface (mouse, keyboard or multitouch).
This patch enables the multitouch interface of this device to work.

We need to manually set the device as a trackpad (we cannot infer it
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
index fb9e61f..de89df5 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -660,6 +660,7 @@
 
 #define USB_VENDOR_ID_TOPSEED2		0x1784
 #define USB_DEVICE_ID_TOPSEED2_RF_COMBO	0x0004
+#define USB_DEVICE_ID_TOPSEED2_PERIPAD_701	0x0016
 
 #define USB_VENDOR_ID_TOPMAX		0x0663
 #define USB_DEVICE_ID_TOPMAX_COBRAPAD	0x0103
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 825759e..443e0a9 100644
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
@@ -897,6 +903,11 @@ static const struct hid_device_id mt_devices[] = {
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
1.7.7.6

