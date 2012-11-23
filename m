Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab2KWPip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:38:45 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64373 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab2KWPin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:38:43 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] HID: hid-multitouch: add support for Nexio 42" panel
Date: Fri, 23 Nov 2012 16:31:31 +0100
Message-Id: <1353684694-5723-9-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This device is the worst device I saw. It keeps TipSwitch and InRange
at 1 for fingers that are not touching the panel.
The solution is to rely on the field ContactCount, which is accurate
as the correct information are packed at the begining of the frame.

Unfortunately, CountactCount is most of the time at the end of the report.
The solution is to pick it when we have the whole report in raw_event.

Fortunately, it occurs that this behavior is pretty well compliant
with all the devices I saw so far. We can make this class the default then.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-ids.h        |  3 ++
 drivers/hid/hid-multitouch.c | 82 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 78 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index b84790a..9dfc465 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -599,6 +599,9 @@
 #define USB_VENDOR_ID_NEC		0x073e
 #define USB_DEVICE_ID_NEC_USB_GAME_PAD	0x0301
 
+#define USB_VENDOR_ID_NEXIO		0x1870
+#define USB_DEVICE_ID_NEXIO_MULTITOUCH_420	0x0100
+
 #define USB_VENDOR_ID_NEXTWINDOW	0x1926
 #define USB_DEVICE_ID_NEXTWINDOW_TOUCHSCREEN	0x0003
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 50fb79f..36cf346 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -33,6 +33,8 @@
 #include <linux/usb.h>
 #include <linux/input/mt.h>
 #include <linux/string.h>
+#include <asm/unaligned.h>
+#include <asm/byteorder.h>
 #include "usbhid/usbhid.h"
 
 
@@ -55,6 +57,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_NO_AREA		(1 << 9)
 #define MT_QUIRK_IGNORE_DUPLICATES	(1 << 10)
 #define MT_QUIRK_HOVERING		(1 << 11)
+#define MT_QUIRK_CONTACT_COUNT_ACCURATE	(1 << 12)
 
 struct mt_slot {
 	__s32 x, y, cx, cy, p, w, h;
@@ -84,6 +87,8 @@ struct mt_device {
 	struct mt_class mtclass;	/* our mt device class */
 	struct mt_fields *fields;	/* temporary placeholder for storing the
 					   multitouch fields */
+	struct hid_field *contactcount;	/* the hid_field contact count that
+					   will be picked in mt_raw_event */
 	unsigned last_field_index;	/* last field index of the report */
 	unsigned last_pen_field_index;	/* last field index of the pen report */
 	unsigned last_slot_field;	/* the last field of a slot */
@@ -148,7 +153,9 @@ static int cypress_compute_slot(struct mt_device *td)
 }
 
 static struct mt_class mt_classes[] = {
-	{ .name = MT_CLS_DEFAULT},
+	{ .name = MT_CLS_DEFAULT,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_CONTACT_COUNT_ACCURATE },
 	{ .name = MT_CLS_NSMU,
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP },
 	{ .name = MT_CLS_SERIAL,
@@ -487,6 +494,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTCOUNT:
+			td->contactcount = field;
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTMAX:
@@ -554,6 +562,10 @@ static int mt_compute_slot(struct mt_device *td, struct input_dev *input)
  */
 static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
 {
+	if ((td->mtclass.quirks & MT_QUIRK_CONTACT_COUNT_ACCURATE) &&
+	    td->num_received >= td->num_expected)
+		return;
+
 	if (td->curvalid || (td->mtclass.quirks & MT_QUIRK_ALWAYS_VALID)) {
 		int slotnum = mt_compute_slot(td, input);
 		struct mt_slot *s = &td->curdata;
@@ -665,12 +677,6 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 			td->curdata.h = value;
 			break;
 		case HID_DG_CONTACTCOUNT:
-			/*
-			 * Includes multi-packet support where subsequent
-			 * packets are sent with zero contactcount.
-			 */
-			if (value)
-				td->num_expected = value;
 			break;
 		case HID_DG_TOUCH:
 			/* do nothing */
@@ -700,6 +706,62 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 	return 1;
 }
 
+/*
+ * Extract/implement a data field from/to a little endian report (bit array).
+ * Copied from hid-core.c.
+ *
+ * Code sort-of follows HID spec:
+ *     http://www.usb.org/developers/devclass_docs/HID1_11.pdf
+ *
+ * While the USB HID spec allows unlimited length bit fields in "report
+ * descriptors", most devices never use more than 16 bits.
+ * One model of UPS is claimed to report "LINEV" as a 32-bit field.
+ * Search linux-kernel and linux-usb-devel archives for "hid-core extract".
+ */
+
+static __u32 extract(const struct hid_device *hid, __u8 *report,
+		     unsigned offset, unsigned n)
+{
+	u64 x;
+
+	if (n > 32)
+		hid_warn(hid, "extract() called with n (%d) > 32! (%s)\n",
+			 n, current->comm);
+
+	report += offset >> 3;  /* adjust byte index */
+	offset &= 7;            /* now only need bit offset into one byte */
+	x = get_unaligned_le64(report);
+	x = (x >> offset) & ((1ULL << n) - 1);  /* extract bit field */
+	return (u32) x;
+}
+
+
+static int mt_raw_event(struct hid_device *hid, struct hid_report *report,
+			u8 *data, int size)
+{
+	struct mt_device *td = hid_get_drvdata(hid);
+	struct hid_field *field = td->contactcount;
+	unsigned value;
+
+	if (field && report->id == field->report->id) {
+		/*
+		 * Pick in advance the field HID_DG_CONTACTCOUNT as it is
+		 * often placed at the end of the report.
+		 */
+		if (report->id)
+			data++;
+		value = extract(hid, data, field->report_offset,
+				field->report_size);
+		/*
+		 * Includes multi-packet support where subsequent
+		 * packets are sent with zero contactcount.
+		 */
+		if (value)
+			td->num_expected = value;
+	}
+	return 0;
+}
+
 static void mt_set_input_mode(struct hid_device *hdev)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
@@ -1110,6 +1172,11 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_TURBOX,
 			USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART) },
 
+	/* Nexio panels */
+	{ .driver_data = MT_CLS_DEFAULT,
+		MT_USB_DEVICE(USB_VENDOR_ID_NEXIO,
+			USB_DEVICE_ID_NEXIO_MULTITOUCH_420)},
+
 	/* Panasonic panels */
 	{ .driver_data = MT_CLS_PANASONIC,
 		MT_USB_DEVICE(USB_VENDOR_ID_PANASONIC,
@@ -1247,6 +1314,7 @@ static struct hid_driver mt_driver = {
 	.feature_mapping = mt_feature_mapping,
 	.usage_table = mt_grabbed_usages,
 	.event = mt_event,
+	.raw_event = mt_raw_event,
 #ifdef CONFIG_PM
 	.reset_resume = mt_reset_resume,
 	.resume = mt_resume,
-- 
1.8.0

