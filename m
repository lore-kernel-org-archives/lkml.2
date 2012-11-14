Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161239Ab2KNQDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:03:25 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38882 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932912Ab2KNP7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:59:41 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 01/14] HID: hid-input: export hidinput_calc_abs_res
Date: Wed, 14 Nov 2012 16:59:13 +0100
Message-Id: <1352908766-4492-2-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exporting the function allows us to calculate the resolution in third
party drivers like hid-multitouch.
This patch also complete the function with additional valid axes.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Acked-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-input.c      | 9 ++++++++-
 drivers/hid/hid-multitouch.c | 1 +
 include/linux/hid.h          | 1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 10248cf..f5b1d57 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -208,7 +208,7 @@ static int hidinput_setkeycode(struct input_dev *dev,
  * Only exponent 1 length units are processed. Centimeters and inches are
  * converted to millimeters. Degrees are converted to radians.
  */
-static __s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code)
+__s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code)
 {
 	__s32 unit_exponent = field->unit_exponent;
 	__s32 logical_extents = field->logical_maximum -
@@ -229,6 +229,12 @@ static __s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code)
 	case ABS_X:
 	case ABS_Y:
 	case ABS_Z:
+	case ABS_MT_POSITION_X:
+	case ABS_MT_POSITION_Y:
+	case ABS_MT_TOOL_X:
+	case ABS_MT_TOOL_Y:
+	case ABS_MT_TOUCH_MAJOR:
+	case ABS_MT_TOUCH_MINOR:
 		if (field->unit == 0x11) {		/* If centimeters */
 			/* Convert to millimeters */
 			unit_exponent += 1;
@@ -283,6 +289,7 @@ static __s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code)
 	/* Calculate resolution */
 	return logical_extents / physical_extents;
 }
+EXPORT_SYMBOL_GPL(hidinput_calc_abs_res);
 
 #ifdef CONFIG_HID_BATTERY_STRENGTH
 static enum power_supply_property hidinput_battery_props[] = {
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 3eb02b9..9f64e36 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -298,6 +298,7 @@ static void set_abs(struct input_dev *input, unsigned int code,
 	int fmax = field->logical_maximum;
 	int fuzz = snratio ? (fmax - fmin) / snratio : 0;
 	input_set_abs_params(input, code, fmin, fmax, fuzz, 0);
+	input_abs_set_res(input, code, hidinput_calc_abs_res(field, code));
 }
 
 static void mt_store_field(struct hid_usage *usage, struct mt_device *td,
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 7e1f37d..9edb06c 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -743,6 +743,7 @@ int hid_input_report(struct hid_device *, int type, u8 *, int, int);
 int hidinput_find_field(struct hid_device *hid, unsigned int type, unsigned int code, struct hid_field **field);
 struct hid_field *hidinput_get_led_field(struct hid_device *hid);
 unsigned int hidinput_count_leds(struct hid_device *hid);
+__s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code);
 void hid_output_report(struct hid_report *report, __u8 *data);
 struct hid_device *hid_allocate_device(void);
 struct hid_report *hid_register_report(struct hid_device *device, unsigned type, unsigned id);
-- 
1.8.0

