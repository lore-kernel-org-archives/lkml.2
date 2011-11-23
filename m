Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab1KWKCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:02:38 -0500
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:41679 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab1KWKB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:01:27 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Subject: [PATCH 2/8] hid-multitouch: create sysfs attribute to control quirks from user-space
Date: Wed, 23 Nov 2011 10:54:28 +0100
Message-Id: <1322042074-3759-3-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@gmail.com>

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 .../ABI/testing/sysfs-driver-hid-multitouch        |    9 +++
 drivers/hid/hid-multitouch.c                       |   77 +++++++++++++++-----
 2 files changed, 68 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-multitouch

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-multitouch b/Documentation/ABI/testing/sysfs-driver-hid-multitouch
new file mode 100644
index 0000000..f79839d
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-multitouch
@@ -0,0 +1,9 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/quirks
+Date:		November 2011
+Contact:	Benjamin Tissoires <benjamin.tissoires@gmail.com>
+Description:	The integer value of this attribute corresponds to the
+		quirks actually in place to handle the device's protocol.
+		When read, this attribute returns the current settings (see
+		MT_QUIRKS_* in hid-multitouch.c).
+		When written this attribute change on the fly the quirks, then
+		the protocol to handle the device.
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 1bd918b..f41bcea 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -60,9 +60,19 @@ struct mt_slot {
 	bool seen_in_this_frame;/* has this slot been updated */
 };
 
+struct mt_class {
+	__s32 name;	/* MT_CLS */
+	__s32 quirks;
+	__s32 sn_move;	/* Signal/noise ratio for move events */
+	__s32 sn_width;	/* Signal/noise ratio for width events */
+	__s32 sn_height;	/* Signal/noise ratio for height events */
+	__s32 sn_pressure;	/* Signal/noise ratio for pressure events */
+	__u8 maxcontacts;
+};
+
 struct mt_device {
 	struct mt_slot curdata;	/* placeholder of incoming data */
-	struct mt_class *mtclass;	/* our mt device class */
+	struct mt_class mtclass;	/* our mt device class */
 	unsigned last_field_index;	/* last field index of the report */
 	unsigned last_slot_field;	/* the last field of a slot */
 	int last_mt_collection;	/* last known mt-related collection */
@@ -74,16 +84,6 @@ struct mt_device {
 	struct mt_slot *slots;
 };
 
-struct mt_class {
-	__s32 name;	/* MT_CLS */
-	__s32 quirks;
-	__s32 sn_move;	/* Signal/noise ratio for move events */
-	__s32 sn_width;	/* Signal/noise ratio for width events */
-	__s32 sn_height;	/* Signal/noise ratio for height events */
-	__s32 sn_pressure;	/* Signal/noise ratio for pressure events */
-	__u8 maxcontacts;
-};
-
 /* classes of device behavior */
 #define MT_CLS_DEFAULT				0x0001
 
@@ -181,6 +181,44 @@ static struct mt_class mt_classes[] = {
 	{ }
 };
 
+static ssize_t mt_show_quirks(struct device *dev,
+			   struct device_attribute *attr,
+			   char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct mt_device *td = hid_get_drvdata(hdev);
+
+	return sprintf(buf, "%u\n", td->mtclass.quirks);
+}
+
+static ssize_t mt_set_quirks(struct device *dev,
+			  struct device_attribute *attr,
+			  const char *buf, size_t count)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct mt_device *td = hid_get_drvdata(hdev);
+
+	unsigned long val;
+
+	if (kstrtoul(buf, 0, &val))
+		return -EINVAL;
+
+	td->mtclass.quirks = val;
+
+	return count;
+}
+
+static DEVICE_ATTR(quirks, S_IWUSR | S_IRUGO, mt_show_quirks, mt_set_quirks);
+
+static struct attribute *sysfs_attrs[] = {
+	&dev_attr_quirks.attr,
+	NULL
+};
+
+static struct attribute_group mt_attribute_group = {
+	.attrs = sysfs_attrs
+};
+
 static void mt_feature_mapping(struct hid_device *hdev,
 		struct hid_field *field, struct hid_usage *usage)
 {
@@ -192,9 +230,9 @@ static void mt_feature_mapping(struct hid_device *hdev,
 		break;
 	case HID_DG_CONTACTMAX:
 		td->maxcontacts = field->value[0];
-		if (td->mtclass->maxcontacts)
+		if (td->mtclass.maxcontacts)
 			/* check if the maxcontacts is given by the class */
-			td->maxcontacts = td->mtclass->maxcontacts;
+			td->maxcontacts = td->mtclass.maxcontacts;
 
 		break;
 	}
@@ -214,7 +252,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		unsigned long **bit, int *max)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
-	struct mt_class *cls = td->mtclass;
+	struct mt_class *cls = &td->mtclass;
 	__s32 quirks = cls->quirks;
 
 	/* Only map fields from TouchScreen or TouchPad collections.
@@ -363,7 +401,7 @@ static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 
 static int mt_compute_slot(struct mt_device *td)
 {
-	__s32 quirks = td->mtclass->quirks;
+	__s32 quirks = td->mtclass.quirks;
 
 	if (quirks & MT_QUIRK_SLOT_IS_CONTACTID)
 		return td->curdata.contactid;
@@ -407,7 +445,7 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
 
 	for (i = 0; i < td->maxcontacts; ++i) {
 		struct mt_slot *s = &(td->slots[i]);
-		if ((td->mtclass->quirks & MT_QUIRK_NOT_SEEN_MEANS_UP) &&
+		if ((td->mtclass.quirks & MT_QUIRK_NOT_SEEN_MEANS_UP) &&
 			!s->seen_in_this_frame) {
 			s->touch_state = false;
 		}
@@ -444,7 +482,7 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 				struct hid_usage *usage, __s32 value)
 {
 	struct mt_device *td = hid_get_drvdata(hid);
-	__s32 quirks = td->mtclass->quirks;
+	__s32 quirks = td->mtclass.quirks;
 
 	if (hid->claimed & HID_CLAIMED_INPUT && td->slots) {
 		switch (usage->hid) {
@@ -552,7 +590,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		dev_err(&hdev->dev, "cannot allocate multitouch data\n");
 		return -ENOMEM;
 	}
-	td->mtclass = mtclass;
+	td->mtclass = *mtclass;
 	td->inputmode = -1;
 	td->last_mt_collection = -1;
 	hid_set_drvdata(hdev, td);
@@ -574,6 +612,8 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		goto fail;
 	}
 
+	ret = sysfs_create_group(&hdev->dev.kobj, &mt_attribute_group);
+
 	mt_set_input_mode(hdev);
 
 	return 0;
@@ -594,6 +634,7 @@ static int mt_reset_resume(struct hid_device *hdev)
 static void mt_remove(struct hid_device *hdev)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
+	sysfs_remove_group(&hdev->dev.kobj, &mt_attribute_group);
 	hid_hw_stop(hdev);
 	kfree(td->slots);
 	kfree(td);
-- 
1.7.4.4

