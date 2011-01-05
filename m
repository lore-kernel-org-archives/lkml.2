Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab1AERgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:36:17 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:38910 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab1AEReg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:34:36 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Stephane Chatty <chatty@enac.fr>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Subject: [RFC v2 01/10] hid: add feature_mapping callback
Date: Wed,  5 Jan 2011 18:27:39 +0100
Message-Id: <1294248468-19979-2-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently hid doesn't export the features it knows to the specific modules.
Some information can be really important in such features: MosArt and
Cypress devices are by default not in a multitouch mode.
We have to send the value 2 on the right feature.

This patch exports to the module the features report so they can find the
right feature to set up the correct mode.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-input.c |   10 +++++++++-
 include/linux/hid.h     |    4 ++++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index bb0b365..07d8cb2 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -287,6 +287,14 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		goto ignore;
 	}
 
+	if (field->report_type == HID_FEATURE_REPORT) {
+		if (device->driver->feature_mapping) {
+			device->driver->feature_mapping(device, hidinput, field,
+                                usage);
+		}
+		goto ignore;
+	}
+
 	if (device->driver->input_mapping) {
 		int ret = device->driver->input_mapping(device, hidinput, field,
 				usage, &bit, &max);
@@ -836,7 +844,7 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
 	struct hid_input *hidinput = NULL;
 	struct input_dev *input_dev;
 	int i, j, k;
-	int max_report_type = HID_OUTPUT_REPORT;
+	int max_report_type = HID_FEATURE_REPORT;
 
 	INIT_LIST_HEAD(&hid->inputs);
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index bb0f56f..75303b0 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -593,6 +593,7 @@ struct hid_usage_id {
  * @report_fixup: called before report descriptor parsing (NULL means nop)
  * @input_mapping: invoked on input registering before mapping an usage
  * @input_mapped: invoked on input registering after mapping an usage
+ * @feature_mapping: invoked on feature registering
  * @suspend: invoked on suspend (NULL means nop)
  * @resume: invoked on resume if device was not reset (NULL means nop)
  * @reset_resume: invoked on resume if device was reset (NULL means nop)
@@ -636,6 +637,9 @@ struct hid_driver {
 	int (*input_mapped)(struct hid_device *hdev,
 			struct hid_input *hidinput, struct hid_field *field,
 			struct hid_usage *usage, unsigned long **bit, int *max);
+	void (*feature_mapping)(struct hid_device *hdev,
+ 			struct hid_input *hidinput, struct hid_field *field,
+ 			struct hid_usage *usage);
 #ifdef CONFIG_PM
 	int (*suspend)(struct hid_device *hdev, pm_message_t message);
 	int (*resume)(struct hid_device *hdev);
-- 
1.7.3.4

