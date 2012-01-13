Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab2AMPxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:53:37 -0500
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:34574 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab2AMPxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:53:31 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Subject: [PATCH 2/2] HID: multitouch: support Perixx PERIPAD 701
Date: Fri, 13 Jan 2012 16:45:31 +0100
Message-Id: <1326469531-26808-2-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1326469531-26808-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1326469531-26808-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@gmail.com>

Perrix Peripad 701 is an hybrid device which presents a touchpad and
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
 drivers/hid/hid-multitouch.c |   47 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 0 deletions(-)

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
index 1ba60d3..a3fa874 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -77,6 +77,8 @@ struct mt_device {
 	unsigned last_slot_field;	/* the last field of a slot */
 	int last_mt_collection;	/* last known mt-related collection */
 	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
+	__s8 maxcontactnumber;		/* Maximum Contact Number HID feature,
+				   -1 if non-existent */
 	__u8 num_received;	/* how many contacts we received */
 	__u8 num_expected;	/* expected last contact index */
 	__u8 maxcontacts;
@@ -101,6 +103,7 @@ struct mt_device {
 #define MT_CLS_CYPRESS				0x0102
 #define MT_CLS_EGALAX				0x0103
 #define MT_CLS_EGALAX_SERIAL			0x0104
+#define MT_CLS_TOPSEED				0x0105
 
 #define MT_DEFAULT_MAXCONTACT	10
 
@@ -190,6 +193,11 @@ static struct mt_class mt_classes[] = {
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
@@ -242,6 +250,7 @@ static void mt_feature_mapping(struct hid_device *hdev,
 		td->inputmode = field->report->id;
 		break;
 	case HID_DG_CONTACTMAX:
+		td->maxcontactnumber = field->report->id;
 		td->maxcontacts = field->value[0];
 		if (td->mtclass.maxcontacts)
 			/* check if the maxcontacts is given by the class */
@@ -610,6 +619,36 @@ static void mt_set_input_mode(struct hid_device *hdev)
 	}
 }
 
+static void mt_set_maxcontacts(struct hid_device *hdev)
+{
+	struct mt_device *td = hid_get_drvdata(hdev);
+	struct hid_report *r;
+	struct hid_report_enum *re;
+	int fieldmax, max;
+
+	if (td->maxcontactnumber < 0)
+		return;
+
+	if (!td->mtclass.maxcontacts)
+		return;
+
+	re = &(hdev->report_enum[HID_FEATURE_REPORT]);
+	r = re->report_id_hash[td->maxcontactnumber];
+	if (r) {
+		max = td->mtclass.maxcontacts;
+		fieldmax = r->field[0]->logical_maximum;
+		hid_info(hdev, "%s: value = %d / %d / %d\n", __func__,
+			r->field[0]->value[0],
+			td->mtclass.maxcontacts,
+			fieldmax);
+		max = fieldmax < max ? fieldmax : max;
+		if (r->field[0]->value[0] != max) {
+			r->field[0]->value[0] = max;
+			usbhid_submit_report(hdev, r, USB_DIR_OUT);
+		}
+	}
+}
+
 static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	int ret, i;
@@ -635,6 +674,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	}
 	td->mtclass = *mtclass;
 	td->inputmode = -1;
+	td->maxcontactnumber = -1;
 	td->last_mt_collection = -1;
 	hid_set_drvdata(hdev, td);
 
@@ -657,6 +697,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = sysfs_create_group(&hdev->dev.kobj, &mt_attribute_group);
 
+	mt_set_maxcontacts(hdev);
 	mt_set_input_mode(hdev);
 
 	return 0;
@@ -669,6 +710,7 @@ fail:
 #ifdef CONFIG_PM
 static int mt_reset_resume(struct hid_device *hdev)
 {
+	mt_set_maxcontacts(hdev);
 	mt_set_input_mode(hdev);
 	return 0;
 }
@@ -869,6 +911,11 @@ static const struct hid_device_id mt_devices[] = {
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

