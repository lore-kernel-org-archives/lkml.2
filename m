Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab1AGSmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 13:42:07 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:54652 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab1AGSmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 13:42:02 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Stephane Chatty <chatty@enac.fr>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Subject: [RFC v3 5/5] hid-mulitouch: added support for the 'Sensing Win7-TwoFinger'
Date: Fri,  7 Jan 2011 19:42:42 +0100
Message-Id: <1294425762-29730-6-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294425762-29730-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1294425762-29730-1-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added support for the 'Sensing Win7-TwoFinger' panel by GeneralTouch found on some tablets.

Because of conflicting VID/PID, this conflicts with previous support for some single-touch panels by GeneralTouch

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Signed-off-by: Stéphane Chatty <chatty@enac.fr>
---
 drivers/hid/Kconfig          |    1 +
 drivers/hid/hid-core.c       |    2 +-
 drivers/hid/hid-ids.h        |    1 +
 drivers/hid/hid-multitouch.c |   18 +++++++++++++++++-
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index de31d75..9bd2148 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -294,6 +294,7 @@ config HID_MULTITOUCH
 	  Say Y here if you have one of the following devices:
 	  - PixCir touchscreen
 	  - Cypress TrueTouch
+	  - 'Sensing Win7-TwoFinger' panel by GeneralTouch
 
 config HID_NTRIG
 	tristate "N-Trig touch screen"
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index e6a86bf..a41290d 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1309,6 +1309,7 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_EZKEY, USB_DEVICE_ID_BTC_8193) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GAMERON, USB_DEVICE_ID_GAMERON_DUAL_PSX_ADAPTOR) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GAMERON, USB_DEVICE_ID_GAMERON_DUAL_PCS_ADAPTOR) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH, USB_DEVICE_ID_GENERAL_TOUCH_WIN7_TWOFINGERS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, 0x0003) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, 0x0012) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE) },
@@ -1612,7 +1613,6 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ESSENTIAL_REALITY, USB_DEVICE_ID_ESSENTIAL_REALITY_P5) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ETT, USB_DEVICE_ID_TC5UH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ETT, USB_DEVICE_ID_TC4UM) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH, 0x0001) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH, 0x0002) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH, 0x0003) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH, 0x0004) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index c258c42..a97983e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -226,6 +226,7 @@
 #define USB_DEVICE_ID_GAMERON_DUAL_PCS_ADAPTOR	0x0002
 
 #define USB_VENDOR_ID_GENERAL_TOUCH	0x0dfc
+#define USB_DEVICE_ID_GENERAL_TOUCH_WIN7_TWOFINGERS 0x0001
 
 #define USB_VENDOR_ID_GLAB		0x06c2
 #define USB_DEVICE_ID_4_PHIDGETSERVO_30	0x0038
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 7af9f71..3442ed5 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -33,6 +33,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_NOT_SEEN_MEANS_UP	(1 << 0)
 #define MT_QUIRK_SLOT_IS_CONTACTID	(1 << 1)
 #define MT_QUIRK_CYPRESS	(1 << 2)
+#define MT_QUIRK_SLOT_IS_CONTACTNUMBER	(1 << 3)
 
 struct mt_slot {
 	__s32 x, y, p, w, h;
@@ -63,7 +64,8 @@ struct mt_class {
 /* classes of device behavior */
 #define MT_CLS_DEFAULT 0
 #define MT_CLS_DUAL1 1
-#define MT_CLS_CYPRESS 2
+#define MT_CLS_DUAL2 2
+#define MT_CLS_CYPRESS 3
 
 /*
  * these device-dependent functions determine what slot corresponds
@@ -75,6 +77,11 @@ static int slot_is_contactid(struct mt_device *td)
 	return td->curdata.contactid;
 }
 
+static int slot_is_contactnumber(struct mt_device *td)
+{
+	return td->num_received;
+}
+
 static int cypress_compute_slot(struct mt_device *td)
 {
 	if (td->curdata.contactid != 0 || td->num_received == 0)
@@ -105,6 +112,7 @@ static int find_slot_from_contactid(struct mt_device *td)
 struct mt_class mt_classes[] = {
 	{ 0, 0, 0, 10 },                             /* MT_CLS_DEFAULT */
 	{ MT_QUIRK_SLOT_IS_CONTACTID, 0, 0, 2 },     /* MT_CLS_DUAL1 */
+	{ MT_QUIRK_SLOT_IS_CONTACTNUMBER, 0, 0, 10 },    /* MT_CLS_DUAL2 */
 	{ MT_QUIRK_CYPRESS | MT_QUIRK_NOT_SEEN_MEANS_UP, 0, 0, 10 }, /* MT_CLS_CYPRESS */
 };
 
@@ -237,6 +245,9 @@ static int mt_compute_slot(struct mt_device *td)
 	if (cls->quirks & MT_QUIRK_CYPRESS)
 		return cypress_compute_slot(td);
 
+	if (cls->quirks & MT_QUIRK_SLOT_IS_CONTACTNUMBER)
+		return slot_is_contactnumber(td);
+
 	return find_slot_from_contactid(td);
 }
 
@@ -441,6 +452,11 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS,
 			USB_DEVICE_ID_CYPRESS_TRUETOUCH) },
 
+	/* GeneralTouch panel */
+	{ .driver_data = MT_CLS_DUAL2,
+		HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
+			USB_DEVICE_ID_GENERAL_TOUCH_WIN7_TWOFINGERS) },
+
 	/* PixCir-based panels */
 	{ .driver_data = MT_CLS_DUAL1,
 		HID_USB_DEVICE(USB_VENDOR_ID_HANVON,
-- 
1.7.3.4

