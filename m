Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab1DUOWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:22:15 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:60676 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab1DUOWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:22:13 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        John Sung <penmount.touch@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] HID: add support for PenMount dual-touch panel
Date: Thu, 21 Apr 2011 16:21:52 +0200
Message-Id: <1303395712-4572-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1303388160-2814-3-git-send-email-benjamin.tissoires@enac.fr>
References: <1303388160-2814-3-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Sung <penmount.touch@gmail.com>

This patch adds PenMount support to hid-multitouch.
A new class MT_CLS_CONFIDENCE is defined for PenMount,
since it uses HID_DG_CONFIDENCE as the valid flag.

Signed-off-by: John Sung <penmount.touch@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Acked-by: Henrik Rydberg <rydberg@euromail.se>

---

Hi Guys,

this is the final version (I hope so).
I changed the from, restored back the Kconfig part and reintroduced the commit message.
John, I hope it's good for you.

Cheers,
Benjamin

 drivers/hid/Kconfig          |    1 +
 drivers/hid/hid-core.c       |    1 +
 drivers/hid/hid-ids.h        |    3 +++
 drivers/hid/hid-multitouch.c |    8 ++++++++
 4 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 996ae3a..8058cf1 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -313,6 +313,7 @@ config HID_MULTITOUCH
 	  - Cypress TrueTouch panels
 	  - Hanvon dual touch panels
 	  - IrTouch Infrared USB panels
+	  - PenMount dual touch panels
 	  - Pixcir dual touch panels
 	  - 'Sensing Win7-TwoFinger' panel by GeneralTouch
           - eGalax dual-touch panels, including the
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index c3d6626..6e31b9f 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1438,6 +1438,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_18) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_PKB1700) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PENMOUNT, USB_DEVICE_ID_PENMOUNT_PCI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index d485894..252aeba 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -484,6 +484,9 @@
 #define USB_VENDOR_ID_PANTHERLORD	0x0810
 #define USB_DEVICE_ID_PANTHERLORD_TWIN_USB_JOYSTICK	0x0001
 
+#define USB_VENDOR_ID_PENMOUNT		0x14e1
+#define USB_DEVICE_ID_PENMOUNT_PCI	0x3500
+
 #define USB_VENDOR_ID_PETALYNX		0x18b1
 #define USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE	0x0037
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 6005e78..51b5d27 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -89,6 +89,7 @@ struct mt_class {
 #define MT_CLS_EGALAX				5
 #define MT_CLS_STANTUM				6
 #define MT_CLS_3M				7
+#define MT_CLS_CONFIDENCE			8
 
 #define MT_DEFAULT_MAXCONTACT	10
 
@@ -156,6 +157,8 @@ struct mt_class mt_classes[] = {
 		.sn_move = 2048,
 		.sn_width = 128,
 		.sn_height = 128 },
+	{ .name = MT_CLS_CONFIDENCE,
+		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE },
 
 	{ }
 };
@@ -584,6 +587,11 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS,
 			USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },
 
+	/* PenMount panels */
+	{ .driver_data = MT_CLS_CONFIDENCE,
+		HID_USB_DEVICE(USB_VENDOR_ID_PENMOUNT,
+			USB_DEVICE_ID_PENMOUNT_PCI) },
+
 	/* PixCir-based panels */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
 		HID_USB_DEVICE(USB_VENDOR_ID_HANVON,
-- 
1.7.4.2

