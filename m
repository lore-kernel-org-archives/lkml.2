Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab1CUXWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:22:10 -0400
Received: from kroah.org ([198.145.64.141]:52810 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932438Ab1CUXSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:34 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:28 2011
Message-Id: <20110321230328.877752001@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:02:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>
Subject: [70/78] HID: Do not create input devices for feature reports
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Henrik Rydberg <rydberg@euromail.se>

commit f635bd11c8d332d917fb9a4cad3071b2357d5b2a upstream.

When the multi input quirk is set, there is a new input device
created for every feature report. Since the idea is to present
features per hid device, not per input device, revert back to
the original report loop and change the feature_mapping() callback
to not take the input device as argument.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Tested-by: Benjamin Tissoires <benjmain.tissoires@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-input.c      |   30 +++++++++++++++++++++---------
 drivers/hid/hid-multitouch.c |    2 +-
 include/linux/hid.h          |    2 +-
 3 files changed, 23 insertions(+), 11 deletions(-)

--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -290,14 +290,6 @@ static void hidinput_configure_usage(str
 		goto ignore;
 	}
 
-	if (field->report_type == HID_FEATURE_REPORT) {
-		if (device->driver->feature_mapping) {
-			device->driver->feature_mapping(device, hidinput, field,
-				usage);
-		}
-		goto ignore;
-	}
-
 	if (device->driver->input_mapping) {
 		int ret = device->driver->input_mapping(device, hidinput, field,
 				usage, &bit, &max);
@@ -835,6 +827,24 @@ static void hidinput_close(struct input_
 	hid_hw_close(hid);
 }
 
+static void report_features(struct hid_device *hid)
+{
+	struct hid_driver *drv = hid->driver;
+	struct hid_report_enum *rep_enum;
+	struct hid_report *rep;
+	int i, j;
+
+	if (!drv->feature_mapping)
+		return;
+
+	rep_enum = &hid->report_enum[HID_FEATURE_REPORT];
+	list_for_each_entry(rep, &rep_enum->report_list, list)
+		for (i = 0; i < rep->maxfield; i++)
+			for (j = 0; j < rep->field[i]->maxusage; j++)
+				drv->feature_mapping(hid, rep->field[i],
+						     rep->field[i]->usage + j);
+}
+
 /*
  * Register the input device; print a message.
  * Configure the input layer interface
@@ -863,7 +873,9 @@ int hidinput_connect(struct hid_device *
 			return -1;
 	}
 
-	for (k = HID_INPUT_REPORT; k <= HID_FEATURE_REPORT; k++) {
+	report_features(hid);
+
+	for (k = HID_INPUT_REPORT; k <= HID_OUTPUT_REPORT; k++) {
 		if (k == HID_OUTPUT_REPORT &&
 			hid->quirks & HID_QUIRK_SKIP_OUTPUT_REPORTS)
 			continue;
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -122,7 +122,7 @@ struct mt_class mt_classes[] = {
 	{ }
 };
 
-static void mt_feature_mapping(struct hid_device *hdev, struct hid_input *hi,
+static void mt_feature_mapping(struct hid_device *hdev,
 		struct hid_field *field, struct hid_usage *usage)
 {
 	if (usage->hid == HID_DG_INPUTMODE) {
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -638,7 +638,7 @@ struct hid_driver {
 			struct hid_input *hidinput, struct hid_field *field,
 			struct hid_usage *usage, unsigned long **bit, int *max);
 	void (*feature_mapping)(struct hid_device *hdev,
-			struct hid_input *hidinput, struct hid_field *field,
+			struct hid_field *field,
 			struct hid_usage *usage);
 #ifdef CONFIG_PM
 	int (*suspend)(struct hid_device *hdev, pm_message_t message);


