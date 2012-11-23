Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab2KWPd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:33:27 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60142 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab2KWPbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:31:46 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] HID: hid-input: simplify hid_input allocation and registration
Date: Fri, 23 Nov 2012 16:31:25 +0100
Message-Id: <1353684694-5723-3-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to provide fine control for the creation of different
input devices in probe function of third party drivers, this patch
split the allocations, the registrations and the free of input
devices.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-input.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 47f98a3..eea02b0 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1206,6 +1206,7 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
 	struct hid_driver *drv = hid->driver;
 	struct hid_report *report;
 	struct hid_input *hidinput = NULL;
+	struct hid_input *next;
 	int i, j, k;
 
 	INIT_LIST_HEAD(&hid->inputs);
@@ -1238,7 +1239,7 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
 			if (!hidinput) {
 				hidinput = hidinput_allocate(hid);
 				if (!hidinput)
-					goto out_unwind;
+					goto out_cleanup;
 			}
 
 			for (i = 0; i < report->maxfield; i++)
@@ -1253,29 +1254,36 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
 				 * UGCI) cram a lot of unrelated inputs into the
 				 * same interface. */
 				hidinput->report = report;
-				if (drv->input_configured)
-					drv->input_configured(hid, hidinput);
-				if (input_register_device(hidinput->input))
-					goto out_cleanup;
 				hidinput = NULL;
 			}
 		}
 	}
 
-	if (hidinput) {
+	list_for_each_entry(hidinput, &hid->inputs, list) {
 		if (drv->input_configured)
 			drv->input_configured(hid, hidinput);
 		if (input_register_device(hidinput->input))
-			goto out_cleanup;
+			goto out_unwind;
 	}
 
 	return 0;
 
 out_cleanup:
-	list_del(&hidinput->list);
-	input_free_device(hidinput->input);
-	kfree(hidinput);
+	list_for_each_entry_safe(hidinput, next, &hid->inputs, list) {
+		list_del(&hidinput->list);
+		input_free_device(hidinput->input);
+		kfree(hidinput);
+	}
+	return -1;
+
 out_unwind:
+	/* free the non-registered hidinput, starting from the faulty one */
+	list_for_each_entry_safe_from(hidinput, next, &hid->inputs, list) {
+		list_del(&hidinput->list);
+		input_free_device(hidinput->input);
+		kfree(hidinput);
+	}
+
 	/* unwind the ones we already registered */
 	hidinput_disconnect(hid);
 
-- 
1.8.0

