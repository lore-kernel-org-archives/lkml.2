Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab2KGQjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:39:22 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56378 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab2KGQiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:38:07 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 09/13] HID: hid-multitouch: add MT_QUIRK_IGNORE_DUPLICATES
Date: Wed,  7 Nov 2012 17:37:32 +0100
Message-Id: <1352306256-12180-10-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this prevents a device to reuse contact id 0 several time when
sending garbage values to complete the report.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 6 ++++++
 include/linux/input/mt.h     | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 2352770..351c814 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -52,6 +52,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_VALID_IS_CONFIDENCE	(1 << 6)
 #define MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE	(1 << 8)
 #define MT_QUIRK_NO_AREA		(1 << 9)
+#define MT_QUIRK_IGNORE_DUPLICATES	(1 << 10)
 
 struct mt_slot {
 	__s32 x, y, cx, cy, p, w, h;
@@ -510,6 +511,11 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
 		if (slotnum < 0 || slotnum >= td->maxcontacts)
 			return;
 
+		if (td->mtclass.quirks & MT_QUIRK_IGNORE_DUPLICATES &&
+		    input_mt_is_active(&input->mt->slots[slotnum]) &&
+		    input_mt_is_used(input->mt, &input->mt->slots[slotnum]))
+				return;
+
 		input_mt_slot(input, slotnum);
 		input_mt_report_slot_state(input, MT_TOOL_FINGER,
 			s->touch_state);
diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
index cc5cca7..2e86bd0 100644
--- a/include/linux/input/mt.h
+++ b/include/linux/input/mt.h
@@ -69,6 +69,12 @@ static inline bool input_mt_is_active(const struct input_mt_slot *slot)
 	return input_mt_get_value(slot, ABS_MT_TRACKING_ID) >= 0;
 }
 
+static inline bool input_mt_is_used(const struct input_mt *mt,
+				    const struct input_mt_slot *slot)
+{
+	return slot->frame == mt->frame;
+}
+
 int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots,
 			unsigned int flags);
 void input_mt_destroy_slots(struct input_dev *dev);
-- 
1.7.11.7

