Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab2JZItq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:49:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36011 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab2JZIoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:44:38 -0400
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/11] HID: hid-input: export hidinput_calc_abs_res
Date: Fri, 26 Oct 2012 10:44:17 +0200
Message-Id: <1351241067-9521-2-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exporting this function allows us to calculate the resolution in third
party drivers like hid-multitouch.
This patch also complete the function with additional valid axes.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-input.c      | 11 +++++++++--
 drivers/hid/hid-multitouch.c |  1 +
 include/linux/hid.h          |  1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index d917c0d..1b0adc3 100644
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
@@ -281,8 +287,9 @@ static __s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code)
 	}
 
 	/* Calculate resolution */
-	return logical_extents / physical_extents;
+	return DIV_ROUND_CLOSEST(logical_extents, physical_extents);
 }
+EXPORT_SYMBOL_GPL(hidinput_calc_abs_res);
 
 #ifdef CONFIG_HID_BATTERY_STRENGTH
 static enum power_supply_property hidinput_battery_props[] = {
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index c97011c..375a38d 100644
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
1.7.11.7

