Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476Ab2JYOLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:11:06 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46385 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759038Ab2JYOLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:11:01 -0400
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] HID: core: fix unit exponent parsing
Date: Thu, 25 Oct 2012 16:09:40 +0200
Message-Id: <1351174189-24719-2-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351174189-24719-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1351174189-24719-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HID spec details special values for the HID field unit exponent.
Basically, the range [0x8..0xf] correspond to [-8..-1].

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-core.c  | 10 +++++++++-
 drivers/hid/hid-input.c | 19 +++++++++++++------
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 5de3bb3..b2533f1 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -315,6 +315,7 @@ static s32 item_sdata(struct hid_item *item)
 
 static int hid_parser_global(struct hid_parser *parser, struct hid_item *item)
 {
+	__u32 raw_value;
 	switch (item->tag) {
 	case HID_GLOBAL_ITEM_TAG_PUSH:
 
@@ -365,7 +366,14 @@ static int hid_parser_global(struct hid_parser *parser, struct hid_item *item)
 		return 0;
 
 	case HID_GLOBAL_ITEM_TAG_UNIT_EXPONENT:
-		parser->global.unit_exponent = item_sdata(item);
+		/* Units exponent negative numbers are given through a special
+		 * table.
+		 * See "6.2.2.7 Global Items" for more information. */
+		raw_value = item_udata(item);
+		if ((raw_value >> 3) == 1)
+			parser->global.unit_exponent = raw_value - 16;
+		else
+			parser->global.unit_exponent = raw_value;
 		return 0;
 
 	case HID_GLOBAL_ITEM_TAG_UNIT:
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 1b0adc3..fc9f2b5 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -215,7 +215,7 @@ __s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code)
 					field->logical_minimum;
 	__s32 physical_extents = field->physical_maximum -
 					field->physical_minimum;
-	__s32 prev;
+	__s32 prev, tmp_exponent;
 
 	/* Check if the extents are sane */
 	if (logical_extents <= 0 || physical_extents <= 0)
@@ -235,17 +235,24 @@ __s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code)
 	case ABS_MT_TOOL_Y:
 	case ABS_MT_TOUCH_MAJOR:
 	case ABS_MT_TOUCH_MINOR:
-		if (field->unit == 0x11) {		/* If centimeters */
+		if (field->unit & 0xffffff00)		/* Not a length */
+			return 0;
+		tmp_exponent = field->unit >> 4;
+		if ((tmp_exponent >> 3) == 1)
+			tmp_exponent -= 16;
+		switch (field->unit & 0xf) {
+		case 0x1:				/* If centimeters */
 			/* Convert to millimeters */
-			unit_exponent += 1;
-		} else if (field->unit == 0x13) {	/* If inches */
+			unit_exponent += tmp_exponent;
+			break;
+		case 0x3:				/* If inches */
 			/* Convert to millimeters */
 			prev = physical_extents;
 			physical_extents *= 254;
 			if (physical_extents < prev)
 				return 0;
-			unit_exponent -= 1;
-		} else {
+			unit_exponent += tmp_exponent - 2;
+		default:
 			return 0;
 		}
 		break;
-- 
1.7.11.7

