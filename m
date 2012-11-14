Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423108Ab2KNQBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:01:05 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38389 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422999Ab2KNP75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:59:57 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 11/14] HID: hid-multitouch: add MT_QUIRK_IGNORE_DUPLICATES
Date: Wed, 14 Nov 2012 16:59:23 +0100
Message-Id: <1352908766-4492-12-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This quirk allows a device to reuse a contact id when sending garbage
inactive contacts at the end of a report.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 2352770..c5b81a7 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -52,6 +52,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_VALID_IS_CONFIDENCE	(1 << 6)
 #define MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE	(1 << 8)
 #define MT_QUIRK_NO_AREA		(1 << 9)
+#define MT_QUIRK_IGNORE_DUPLICATES	(1 << 10)
 
 struct mt_slot {
 	__s32 x, y, cx, cy, p, w, h;
@@ -506,10 +507,18 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
 	if (td->curvalid || (td->mtclass.quirks & MT_QUIRK_ALWAYS_VALID)) {
 		int slotnum = mt_compute_slot(td, input);
 		struct mt_slot *s = &td->curdata;
+		struct input_mt *mt = input->mt;
 
 		if (slotnum < 0 || slotnum >= td->maxcontacts)
 			return;
 
+		if ((td->mtclass.quirks & MT_QUIRK_IGNORE_DUPLICATES) && mt) {
+			struct input_mt_slot *slot = &mt->slots[slotnum];
+			if (input_mt_is_active(slot) &&
+			    input_mt_is_used(mt, slot))
+				return;
+		}
+
 		input_mt_slot(input, slotnum);
 		input_mt_report_slot_state(input, MT_TOOL_FINGER,
 			s->touch_state);
-- 
1.8.0

