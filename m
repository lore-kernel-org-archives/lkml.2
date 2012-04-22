Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab2DVMSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 08:18:46 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:39862 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2DVMSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 08:18:44 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AllUAPT1k09V5qnhPGdsb2JhbABEiiqnFRkBAQEBHhkNJ4IKAQUnLxMBDxAIETghGAoUBhOIAQMPqVKGKw2JUxOJZ4c5BJt9hTqHbA
X-IronPort-AV: E=Sophos;i="4.75,462,1330902000"; 
   d="scan'208";a="23075320"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>
Subject: [PATCH 2/3] hid-logitech: Collect report descriptors before sending
Date: Sun, 22 Apr 2012 14:21:39 +0200
Message-Id: <1335097300-11881-3-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335097300-11881-1-git-send-email-rydberg@euromail.se>
References: <1335097300-11881-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code allows several consecutive calls to hid_parse_report(),
which may have happened to work before, but would cause a memory leak
and generally be incorrect. This patch collects all the reports
before sending them once.

Compiled, not tested.

Cc: Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-logitech-dj.c |   71 +++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 42 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 2b56efc..e1c38bb 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -155,6 +155,14 @@ static const char media_descriptor[] = {
 /* Maximum size of all defined hid reports in bytes (including report id) */
 #define MAX_REPORT_SIZE 8
 
+/* Make sure all descriptors are present here */
+#define MAX_RDESC_SIZE				\
+	(sizeof(kbd_descriptor) +		\
+	 sizeof(mse_descriptor) +		\
+	 sizeof(consumer_descriptor) +		\
+	 sizeof(syscontrol_descriptor) +	\
+	 sizeof(media_descriptor))
+
 /* Number of possible hid report types that can be created by this driver.
  *
  * Right now, RF report types have the same report types (or report id's)
@@ -473,9 +481,17 @@ static int logi_dj_output_hidraw_report(struct hid_device *hid, u8 * buf,
 	return 0;
 }
 
+static void rdcat(char **rdesc, unsigned int *rsize, const char *data, unsigned int size)
+{
+	memcpy(*rdesc + *rsize, data, size);
+	*rsize += size;
+}
+
 static int logi_dj_ll_parse(struct hid_device *hid)
 {
 	struct dj_device *djdev = hid->driver_data;
+	unsigned int rsize = 0;
+	char *rdesc;
 	int retval;
 
 	dbg_hid("%s\n", __func__);
@@ -483,70 +499,38 @@ static int logi_dj_ll_parse(struct hid_device *hid)
 	djdev->hdev->version = 0x0111;
 	djdev->hdev->country = 0x00;
 
+	rdesc = kmalloc(MAX_RDESC_SIZE, GFP_KERNEL);
+	if (!rdesc)
+		return -ENOMEM;
+
 	if (djdev->reports_supported & STD_KEYBOARD) {
 		dbg_hid("%s: sending a kbd descriptor, reports_supported: %x\n",
 			__func__, djdev->reports_supported);
-		retval = hid_parse_report(hid,
-					  (u8 *) kbd_descriptor,
-					  sizeof(kbd_descriptor));
-		if (retval) {
-			dbg_hid("%s: sending a kbd descriptor, hid_parse failed"
-				" error: %d\n", __func__, retval);
-			return retval;
-		}
+		rdcat(&rdesc, &rsize, kbd_descriptor, sizeof(kbd_descriptor));
 	}
 
 	if (djdev->reports_supported & STD_MOUSE) {
 		dbg_hid("%s: sending a mouse descriptor, reports_supported: "
 			"%x\n", __func__, djdev->reports_supported);
-		retval = hid_parse_report(hid,
-					  (u8 *) mse_descriptor,
-					  sizeof(mse_descriptor));
-		if (retval) {
-			dbg_hid("%s: sending a mouse descriptor, hid_parse "
-				"failed error: %d\n", __func__, retval);
-			return retval;
-		}
+		rdcat(&rdesc, &rsize, mse_descriptor, sizeof(mse_descriptor));
 	}
 
 	if (djdev->reports_supported & MULTIMEDIA) {
 		dbg_hid("%s: sending a multimedia report descriptor: %x\n",
 			__func__, djdev->reports_supported);
-		retval = hid_parse_report(hid,
-					  (u8 *) consumer_descriptor,
-					  sizeof(consumer_descriptor));
-		if (retval) {
-			dbg_hid("%s: sending a consumer_descriptor, hid_parse "
-				"failed error: %d\n", __func__, retval);
-			return retval;
-		}
+		rdcat(&rdesc, &rsize, consumer_descriptor, sizeof(consumer_descriptor));
 	}
 
 	if (djdev->reports_supported & POWER_KEYS) {
 		dbg_hid("%s: sending a power keys report descriptor: %x\n",
 			__func__, djdev->reports_supported);
-		retval = hid_parse_report(hid,
-					  (u8 *) syscontrol_descriptor,
-					  sizeof(syscontrol_descriptor));
-		if (retval) {
-			dbg_hid("%s: sending a syscontrol_descriptor, "
-				"hid_parse failed error: %d\n",
-				__func__, retval);
-			return retval;
-		}
+		rdcat(&rdesc, &rsize, syscontrol_descriptor, sizeof(syscontrol_descriptor));
 	}
 
 	if (djdev->reports_supported & MEDIA_CENTER) {
 		dbg_hid("%s: sending a media center report descriptor: %x\n",
 			__func__, djdev->reports_supported);
-		retval = hid_parse_report(hid,
-					  (u8 *) media_descriptor,
-					  sizeof(media_descriptor));
-		if (retval) {
-			dbg_hid("%s: sending a media_descriptor, hid_parse "
-				"failed error: %d\n", __func__, retval);
-			return retval;
-		}
+		rdcat(&rdesc, &rsize, media_descriptor, sizeof(media_descriptor));
 	}
 
 	if (djdev->reports_supported & KBD_LEDS) {
@@ -554,7 +538,10 @@ static int logi_dj_ll_parse(struct hid_device *hid)
 			__func__, djdev->reports_supported);
 	}
 
-	return 0;
+	retval = hid_parse_report(hid, rdesc, rsize);
+	kfree(rdesc);
+
+	return retval;
 }
 
 static int logi_dj_ll_input_event(struct input_dev *dev, unsigned int type,
-- 
1.7.10

