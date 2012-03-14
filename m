Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab2CNTzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 15:55:53 -0400
Received: from stats.peacock.arvixe.com ([174.122.104.67]:58574 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932475Ab2CNTzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 15:55:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=firszt.eu;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
	b=so1bLZ5lirIQoI2jNU299aJVFhGqeTsOXowvwB7WctYYTtPbBYk/OOH0Uc5S7H6TDOoWKUxj+GrHIitbYNZGyX4leBENNWcm74agymnSJSCSqDwaShi2PyEnCybxayAj;
From: Przemo Firszt <przemo@firszt.eu>
To: jkosina@suse.cz, pinglinux@gmail.com, chris@cnpbagwell.com,
        killertofu@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net,
        Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 2/2] HID: wacom: Add reporting of wheel for Intuos4 WL
Date: Wed, 14 Mar 2012 19:55:04 +0000
Message-Id: <1331754904-8927-2-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1331754904-8927-1-git-send-email-przemo@firszt.eu>
References: <1331754904-8927-1-git-send-email-przemo@firszt.eu>
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
Reviewed-by: Jason Gerecke <killertofu@gmail.com>
---
 drivers/hid/hid-wacom.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index d04e2aa..067e296 100644
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
@@ -322,6 +323,23 @@ static void wacom_i4_parse_button_report(struct wacom_data *wdata,
 			struct input_dev *input, unsigned char *data)
 {
 	__u16 new_butstate;
+	__u8 new_whlstate;
+	__u8 sync = 0;
+
+	new_whlstate = data[1];
+	if (new_whlstate != wdata->whlstate) {
+		wdata->whlstate = new_whlstate;
+		if (new_whlstate & 0x80) {
+			input_report_key(input, BTN_TOUCH, 1);
+			input_report_abs(input, ABS_WHEEL, (new_whlstate & 0x7f));
+			input_report_key(input, BTN_TOOL_FINGER, 1);
+		} else {
+			input_report_key(input, BTN_TOUCH, 0);
+			input_report_abs(input, ABS_WHEEL, 0);
+			input_report_key(input, BTN_TOOL_FINGER, 0);
+		}
+		sync = 1;
+	}
 
 	new_butstate = (data[3] << 1) | (data[2] & 0x01);
 	if (new_butstate != wdata->butstate) {
@@ -336,6 +354,10 @@ static void wacom_i4_parse_button_report(struct wacom_data *wdata,
 		input_report_key(input, BTN_7, new_butstate & 0x080);
 		input_report_key(input, BTN_8, new_butstate & 0x100);
 		input_report_key(input, BTN_TOOL_FINGER, 1);
+		sync = 1;
+	}
+
+	if (sync) {
 		input_report_abs(input, ABS_MISC, PAD_DEVICE_ID);
 		input_event(input, EV_MSC, MSC_SERIAL, 0xffffffff);
 		input_sync(input);
@@ -510,6 +532,7 @@ static int wacom_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		input_set_abs_params(input, ABS_DISTANCE, 0, 32, 0, 0);
 		break;
 	case USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH:
+		__set_bit(ABS_WHEEL, input->absbit);
 		__set_bit(ABS_MISC, input->absbit);
 		__set_bit(BTN_2, input->keybit);
 		__set_bit(BTN_3, input->keybit);
@@ -518,6 +541,7 @@ static int wacom_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		__set_bit(BTN_6, input->keybit);
 		__set_bit(BTN_7, input->keybit);
 		__set_bit(BTN_8, input->keybit);
+		input_set_abs_params(input, ABS_WHEEL, 0, 71, 0, 0);
 		input_set_abs_params(input, ABS_X, 0, 40640, 4, 0);
 		input_set_abs_params(input, ABS_Y, 0, 25400, 4, 0);
 		input_set_abs_params(input, ABS_PRESSURE, 0, 2047, 0, 0);
-- 
1.7.6.4

