Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab2EDSEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 14:04:08 -0400
Received: from stats.peacock.arvixe.com ([174.122.104.67]:59879 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752517Ab2EDSEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 14:04:07 -0400
X-Greylist: delayed 3820 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2012 14:04:06 EDT
From: Przemo Firszt <przemo@firszt.eu>
To: pinglinux@gmail.com, jkosina@suse.cz, linux-kernel@vger.kernel.org
Cc: linuxwacom-devel@lists.sourceforge.net, linux-input@vger.kernel.org,
        Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH] HID: wacom: Add tilt reporting for Intuos4 WL
Date: Fri,  4 May 2012 18:00:10 +0100
Message-Id: <1336150810-17390-1-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.7.10
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tile is reported to input subsystem as reported by the device without
any modifications. It means that tilt X/Y range is 0 to 127 and it's
not centered on zero.

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/hid/hid-wacom.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index fb0fe16..a66e1aa 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -363,6 +363,7 @@ static void wacom_i4_parse_pen_report(struct wacom_data *wdata,
 {
 	__u16 x, y, pressure;
 	__u8 distance;
+	__u8 tilt_x, tilt_y;
 
 	switch (data[1]) {
 	case 0x80: /* Out of proximity report */
@@ -399,6 +400,8 @@ static void wacom_i4_parse_pen_report(struct wacom_data *wdata,
 		pressure = (data[6] << 3) | ((data[7] & 0xC0) >> 5)
 			| (data[1] & 0x01);
 		distance = (data[9] >> 2) & 0x3f;
+		tilt_x = ((data[7] << 1) & 0x7e) | (data[8] >> 7);
+		tilt_y = data[8] & 0x7f;
 
 		input_report_key(input, BTN_TOUCH, pressure > 1);
 
@@ -409,6 +412,8 @@ static void wacom_i4_parse_pen_report(struct wacom_data *wdata,
 		input_report_abs(input, ABS_Y, y);
 		input_report_abs(input, ABS_PRESSURE, pressure);
 		input_report_abs(input, ABS_DISTANCE, distance);
+		input_report_abs(input, ABS_TILT_X, tilt_x);
+		input_report_abs(input, ABS_TILT_Y, tilt_y);
 		input_report_abs(input, ABS_MISC, wdata->id);
 		input_event(input, EV_MSC, MSC_SERIAL, wdata->serial);
 		input_report_key(input, wdata->tool, 1);
@@ -548,6 +553,8 @@ static int wacom_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		input_set_abs_params(input, ABS_Y, 0, 25400, 4, 0);
 		input_set_abs_params(input, ABS_PRESSURE, 0, 2047, 0, 0);
 		input_set_abs_params(input, ABS_DISTANCE, 0, 63, 0, 0);
+		input_set_abs_params(input, ABS_TILT_X, 0, 127, 0, 0);
+		input_set_abs_params(input, ABS_TILT_Y, 0, 127, 0, 0);
 		break;
 	}
 
-- 
1.7.10

