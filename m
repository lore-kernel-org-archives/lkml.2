Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2HLVlD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 17:41:03 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:37412 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2HLVkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 17:40:18 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap5OADciKFBV5qoUPGdsb2JhbABEhRiFI68/GQEBAQE3NIIhAQUnLxMBDQIQCEk5ChQGARKIEbY6FJEvA5s2jQaBVCI
X-IronPort-AV: E=Sophos;i="4.77,756,1336341600"; 
   d="scan'208";a="389105791"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 18/19] HID: Add an input configured notification callback
Date: Sun, 12 Aug 2012 23:42:36 +0200
Message-Id: <1344807757-2217-19-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A hid device may create several input devices, and a driver may need
to prepare or finalize the configuration per input device. Currently,
there is no sane way for a driver to know when a device has been
configured. This patch adds a callback providing that information.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-input.c | 11 +++++++++--
 include/linux/hid.h     |  3 +++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index ad5cbcf..49141db 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1150,6 +1150,7 @@ static void report_features(struct hid_device *hid)
 
 int hidinput_connect(struct hid_device *hid, unsigned int force)
 {
+	struct hid_driver *drv = hid->driver;
 	struct hid_report *report;
 	struct hid_input *hidinput = NULL;
 	struct input_dev *input_dev;
@@ -1224,6 +1225,8 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
 				 * UGCI) cram a lot of unrelated inputs into the
 				 * same interface. */
 				hidinput->report = report;
+				if (drv->input_configured)
+					drv->input_configured(hid, hidinput);
 				if (input_register_device(hidinput->input))
 					goto out_cleanup;
 				hidinput = NULL;
@@ -1231,8 +1234,12 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
 		}
 	}
 
-	if (hidinput && input_register_device(hidinput->input))
-		goto out_cleanup;
+	if (hidinput) {
+		if (drv->input_configured)
+			drv->input_configured(hid, hidinput);
+		if (input_register_device(hidinput->input))
+			goto out_cleanup;
+	}
 
 	return 0;
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 42970de..f37da28 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -626,6 +626,7 @@ struct hid_usage_id {
  * @report_fixup: called before report descriptor parsing (NULL means nop)
  * @input_mapping: invoked on input registering before mapping an usage
  * @input_mapped: invoked on input registering after mapping an usage
+ * @input_configured: invoked just before the device is registered
  * @feature_mapping: invoked on feature registering
  * @suspend: invoked on suspend (NULL means nop)
  * @resume: invoked on resume if device was not reset (NULL means nop)
@@ -670,6 +671,8 @@ struct hid_driver {
 	int (*input_mapped)(struct hid_device *hdev,
 			struct hid_input *hidinput, struct hid_field *field,
 			struct hid_usage *usage, unsigned long **bit, int *max);
+	void (*input_configured)(struct hid_device *hdev,
+				 struct hid_input *hidinput);
 	void (*feature_mapping)(struct hid_device *hdev,
 			struct hid_field *field,
 			struct hid_usage *usage);
-- 
1.7.11.4

