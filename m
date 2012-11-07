Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2KGQlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:41:13 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33927 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab2KGQh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:37:58 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 03/13] HID: core: fix unit exponent parsing
Date: Wed,  7 Nov 2012 17:37:26 +0100
Message-Id: <1352306256-12180-4-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HID spec details special values for the HID field unit exponent.
Basically, the range [0x8..0xf] correspond to [-8..-1], so this is
a standard two's complement on a half-byte.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-core.c  | 16 +++++++++++++++-
 drivers/hid/hid-input.c | 13 +++++++++----
 include/linux/hid.h     |  1 +
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 3d0da29..9da3007 100644
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
+		/* Units exponent negative numbers are given through a
+		 * two's complement.
+		 * See "6.2.2.7 Global Items" for more information. */
+		raw_value = item_udata(item);
+		if (!(raw_value & 0xfffffff0))
+			parser->global.unit_exponent = hid_snto32(raw_value, 4);
+		else
+			parser->global.unit_exponent = raw_value;
 		return 0;
 
 	case HID_GLOBAL_ITEM_TAG_UNIT:
@@ -865,6 +873,12 @@ static s32 snto32(__u32 value, unsigned n)
 	return value & (1 << (n - 1)) ? value | (-1 << n) : value;
 }
 
+s32 hid_snto32(__u32 value, unsigned n)
+{
+	return snto32(value, n);
+}
+EXPORT_SYMBOL_GPL(hid_snto32);
+
 /*
  * Convert a signed 32-bit integer to a signed n-bit integer.
  */
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 67044f3..7015080 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -192,7 +192,6 @@ static int hidinput_setkeycode(struct input_dev *dev,
 	return -EINVAL;
 }
 
-
 /**
  * hidinput_calc_abs_res - calculate an absolute axis resolution
  * @field: the HID report field to calculate resolution for
@@ -235,17 +234,23 @@ __s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code)
 	case ABS_MT_TOOL_Y:
 	case ABS_MT_TOUCH_MAJOR:
 	case ABS_MT_TOUCH_MINOR:
-		if (field->unit == 0x11) {		/* If centimeters */
+		if (field->unit & 0xffffff00)		/* Not a length */
+			return 0;
+		unit_exponent += hid_snto32(field->unit >> 4, 4) - 1;
+		switch (field->unit & 0xf) {
+		case 0x1:				/* If centimeters */
 			/* Convert to millimeters */
 			unit_exponent += 1;
-		} else if (field->unit == 0x13) {	/* If inches */
+			break;
+		case 0x3:				/* If inches */
 			/* Convert to millimeters */
 			prev = physical_extents;
 			physical_extents *= 254;
 			if (physical_extents < prev)
 				return 0;
 			unit_exponent -= 1;
-		} else {
+			break;
+		default:
 			return 0;
 		}
 		break;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 9edb06c..a110a3e 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -754,6 +754,7 @@ int hid_connect(struct hid_device *hid, unsigned int connect_mask);
 void hid_disconnect(struct hid_device *hid);
 const struct hid_device_id *hid_match_id(struct hid_device *hdev,
 					 const struct hid_device_id *id);
+s32 hid_snto32(__u32 value, unsigned n);
 
 /**
  * hid_map_usage - map usage input bits
-- 
1.7.11.7

