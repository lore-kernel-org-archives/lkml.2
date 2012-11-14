Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423075Ab2KNQCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:02:50 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38389 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422773Ab2KNP7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:59:46 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 04/14] HID: hid-input: add usage_index in struct hid_usage.
Date: Wed, 14 Nov 2012 16:59:16 +0100
Message-Id: <1352908766-4492-5-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there is no way to know the index of the current field
in the .input_mapping and .event callbacks  when this field is inside
an array of HID fields.
This patch adds this index to the struct hid_usage so that this
information is available to input_mapping and event callbacks.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Acked-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-core.c | 4 ++++
 include/linux/hid.h    | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 9da3007..8f82c4c 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -92,6 +92,7 @@ EXPORT_SYMBOL_GPL(hid_register_report);
 static struct hid_field *hid_register_field(struct hid_report *report, unsigned usages, unsigned values)
 {
 	struct hid_field *field;
+	int i;
 
 	if (report->maxfield == HID_MAX_FIELDS) {
 		hid_err(report->device, "too many fields in report\n");
@@ -110,6 +111,9 @@ static struct hid_field *hid_register_field(struct hid_report *report, unsigned
 	field->value = (s32 *)(field->usage + usages);
 	field->report = report;
 
+	for (i = 0; i < usages; i++)
+		field->usage[i].usage_index = i;
+
 	return field;
 }
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index a110a3e..ce14c32 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -379,6 +379,7 @@ struct hid_collection {
 struct hid_usage {
 	unsigned  hid;			/* hid usage code */
 	unsigned  collection_index;	/* index into collection array */
+	unsigned  usage_index;		/* index into usage array */
 	/* hidinput data */
 	__u16     code;			/* input driver code */
 	__u8      type;			/* input driver type */
-- 
1.8.0

