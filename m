Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab1IUPFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:05:16 -0400
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:53514 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab1IUPEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:04:47 -0400
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Subject: [PATCH 2/2] decide if hid-multitouch needs to handle mt devices
Date: Wed, 21 Sep 2011 16:56:55 +0200
Message-Id: <1316617015-11648-3-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316617015-11648-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1316617015-11648-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that hid-generic ignores all win7 compatible multitouch devices,
this patch allows hid-multitouch to catch them.
The idea is to rely on the quirk HID_QUIRK_MULTITOUCH to drop the
device if no ContactID is given.
There is the need for a blacklist here as other devices may need
a special driver (ntrig for instance).

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c |   47 ++++++++++++++++++++++++++++++++++++++---
 1 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index a2c4bda..b82b83d 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -291,6 +291,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			td->last_slot_field = usage->hid;
 			td->last_field_index = field->index;
 			td->last_mt_collection = usage->collection_index;
+			hdev->quirks &= ~HID_QUIRK_MULTITOUCH;
 			return 1;
 		case HID_DG_WIDTH:
 			hid_map_usage(hi, usage, bit, max,
@@ -529,12 +530,44 @@ static void mt_set_input_mode(struct hid_device *hdev)
 	}
 }
 
+/* a list of devices for which there is a specialized multitouch driver */
+static const struct hid_device_id mt_have_special_driver[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, 0x0001) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, 0x0006) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA,
+			USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA,
+			USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
+	{ }
+};
+
+static bool mt_match_one_id(struct hid_device *hdev,
+		const struct hid_device_id *id)
+{
+	return id->bus == hdev->bus &&
+		(id->vendor == HID_ANY_ID || id->vendor == hdev->vendor) &&
+		(id->product == HID_ANY_ID || id->product == hdev->product);
+}
+
+static const struct hid_device_id *mt_match_id(struct hid_device *hdev,
+		const struct hid_device_id *id)
+{
+	for (; id->bus; id++)
+		if (mt_match_one_id(hdev, id))
+			return id;
+
+	return NULL;
+}
+
 static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	int ret, i;
 	struct mt_device *td;
 	struct mt_class *mtclass = mt_classes; /* MT_CLS_DEFAULT */
 
+	if (mt_match_id(hdev, mt_have_special_driver))
+		return -ENODEV;
+
 	for (i = 0; mt_classes[i].name ; i++) {
 		if (id->driver_data == mt_classes[i].name) {
 			mtclass = &(mt_classes[i]);
@@ -542,10 +575,6 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		}
 	}
 
-	/* This allows the driver to correctly support devices
-	 * that emit events over several HID messages.
-	 */
-	hdev->quirks |= HID_QUIRK_NO_INPUT_SYNC;
 
 	td = kzalloc(sizeof(struct mt_device), GFP_KERNEL);
 	if (!td) {
@@ -561,10 +590,16 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (ret != 0)
 		goto fail;
 
+	hdev->quirks |= HID_QUIRK_MULTITOUCH;
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret)
 		goto fail;
 
+	/* This allows the driver to correctly support devices
+	 * that emit events over several HID messages.
+	 */
+	hdev->quirks |= HID_QUIRK_NO_INPUT_SYNC;
+
 	td->slots = kzalloc(td->maxcontacts * sizeof(struct mt_slot),
 				GFP_KERNEL);
 	if (!td->slots) {
@@ -749,6 +784,10 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_UNITEC,
 			USB_DEVICE_ID_UNITEC_USB_TOUCH_0A19) },
 
+	/* Rest of the world */
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(HID_ANY_ID, HID_ANY_ID) },
+
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, mt_devices);
-- 
1.7.4.4

