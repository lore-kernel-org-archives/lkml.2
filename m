Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab2KWPcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:32:55 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44951 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab2KWPby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:31:54 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] HID: hid-multitouch: append " Pen" to the name of the stylus input
Date: Fri, 23 Nov 2012 16:31:29 +0100
Message-Id: <1353684694-5723-7-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not just cosmetics, it can help to write udev and X.org
rules.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 0a4c062..f10105f 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/input/mt.h>
+#include <linux/string.h>
 #include "usbhid/usbhid.h"
 
 
@@ -341,6 +342,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	struct mt_class *cls = &td->mtclass;
 	int code;
 	struct hid_usage *prev_usage = NULL;
+	char *name;
 
 	/* Only map fields from TouchScreen or TouchPad collections.
 	* We need to ignore fields that belong to other collections
@@ -370,6 +372,13 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			hi = hidinput_allocate(hdev);
 		td->application = field->application;
 		td->physical = field->physical;
+		if (field->physical == HID_DG_STYLUS) {
+			name = kzalloc(sizeof(hdev->name) + 4, GFP_KERNEL);
+			if (name) {
+				sprintf(name, "%s Pen", hdev->name);
+				hi->input->name = name;
+			}
+		}
 	}
 
 	if (field->physical == HID_DG_STYLUS) {
@@ -791,6 +800,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	int ret, i;
 	struct mt_device *td;
 	struct mt_class *mtclass = mt_classes; /* MT_CLS_DEFAULT */
+	struct hid_input *hi;
 
 	for (i = 0; mt_classes[i].name ; i++) {
 		if (id->driver_data == mt_classes[i].name) {
@@ -830,7 +840,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret)
-		goto fail;
+		goto hid_fail;
 
 	ret = sysfs_create_group(&hdev->dev.kobj, &mt_attribute_group);
 
@@ -842,6 +852,10 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	return 0;
 
+hid_fail:
+	list_for_each_entry(hi, &hdev->inputs, list)
+		if (hi->input->name != hdev->name)
+			kfree(hi->input->name);
 fail:
 	kfree(td->fields);
 	kfree(td);
@@ -886,8 +900,15 @@ static int mt_resume(struct hid_device *hdev)
 static void mt_remove(struct hid_device *hdev)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
+	struct hid_input *hi;
+
 	sysfs_remove_group(&hdev->dev.kobj, &mt_attribute_group);
 	hid_hw_stop(hdev);
+
+	list_for_each_entry(hi, &hdev->inputs, list)
+		if (hi->input->name != hdev->name)
+			kfree(hi->input->name);
+
 	kfree(td);
 	hid_set_drvdata(hdev, NULL);
 }
-- 
1.8.0

