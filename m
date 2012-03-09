Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2CINVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:21:30 -0500
Received: from stats.peacock.arvixe.com ([174.122.104.67]:50483 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755978Ab2CINV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:21:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=firszt.eu;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
	b=ugnCBHvTy5QZ7vkvAj5dynvbF5HOGzYpr9FdBvDVqxUOoBtXkuI05H/61N+9nckUFHvrWI2bwjSqlTI+jV7AuTCu6kuzbN1Uv5GjKA9IrU0gSODyK5E0sUFcw2Mafi2n;
From: Przemo Firszt <przemo@firszt.eu>
To: jkosina@suse.cz, pinglinux@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxwacom-devel@lists.sourceforge.net
Cc: Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 2/2] HID: wacom: Add reporting of wheel for Intuos4 WL
Date: Fri,  9 Mar 2012 13:20:52 +0000
Message-Id: <1331299252-23699-2-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1331299252-23699-1-git-send-email-przemo@firszt.eu>
References: <1331299252-23699-1-git-send-email-przemo@firszt.eu>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds reporting of ABS_WHEEL event. Raported walues are 0..71
and are related to absolute location of the finger on the wheel.

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/hid/hid-wacom.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 5c25036..6f65514 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -36,6 +36,7 @@
 struct wacom_data {
 	__u16 tool;
 	__u16 butstate;
+	__u8 whlstate;
 	__u8 features;
 	__u32 id;
 	__u32 serial;
@@ -322,6 +323,16 @@ static void wacom_i4_parse_button_report(struct wacom_data *wdata,
 			struct input_dev *input, unsigned char *data)
 {
 	__u16 new_butstate;
+	__u8 new_whlstate;
+	__u8 sync = 0;
+
+	new_whlstate = data[1] & 0x7f;
+	if (new_whlstate != wdata->whlstate) {
+		wdata->whlstate = new_whlstate;
+		input_report_key(input, BTN_TOUCH, 1);
+		input_report_abs(input, ABS_WHEEL, new_whlstate);
+		sync = 1;
+	}
 
 	new_butstate = (data[3] << 1) | (data[2] & 0x01);
 	if (new_butstate != wdata->butstate) {
@@ -335,6 +346,10 @@ static void wacom_i4_parse_button_report(struct wacom_data *wdata,
 		input_report_key(input, BTN_6, new_butstate & 0x040);
 		input_report_key(input, BTN_7, new_butstate & 0x080);
 		input_report_key(input, BTN_8, new_butstate & 0x100);
+		sync = 1;
+	}
+
+	if (sync) {
 		input_report_key(input, BTN_TOOL_FINGER, 1);
 		input_report_abs(input, ABS_MISC, PAD_DEVICE_ID);
 		input_event(input, EV_MSC, MSC_SERIAL, 0xffffffff);
@@ -354,6 +369,7 @@ static void wacom_i4_parse_pen_report(struct wacom_data *wdata,
 		input_report_abs(input, ABS_PRESSURE, 0);
 		input_report_key(input, BTN_STYLUS, 0);
 		input_report_key(input, BTN_STYLUS2, 0);
+		input_report_abs(input, ABS_WHEEL, 0);
 		input_report_key(input, wdata->tool, 0);
 		input_report_abs(input, ABS_MISC, 0);
 		input_event(input, EV_MSC, MSC_SERIAL, wdata->serial);
@@ -512,6 +528,9 @@ static int wacom_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		input_set_abs_params(input, ABS_DISTANCE, 0, 32, 0, 0);
 		break;
 	case USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH:
+		__set_bit(ABS_WHEEL, input->absbit);
+		input_set_abs_params(input, ABS_WHEEL, 0, 71, 0, 0);
+		input_set_capability(input, EV_MSC, MSC_SERIAL);
 		__set_bit(ABS_MISC, input->absbit);
 		__set_bit(BTN_2, input->keybit);
 		__set_bit(BTN_3, input->keybit);
-- 
1.7.6.4

