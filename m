Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355Ab0KSB4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 20:56:09 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55589 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab0KSB4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 20:56:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qcp4KzMVYJiL6msjSmC/adiv8J8nsyAyB/i96piIxH6viwX1ip5W86j+H6/y6pAlbh
         2aAWmfoNZZI8jcAZWas3rHl8cvvUiNrYND6c63JvKFV2lQIqSge6ETdYyRM5HUFBGaLo
         kUHWNpOE92b5ssE5f5d+kRNckpUlUDre+A1ro=
From: Ping Cheng <pinglinux@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, Ping Cheng <pinglinux@gmail.com>,
        Ping Cheng <pingc@wacom.com>
Subject: [PATCH] input: wacom - Bring Bamboo in sync with other models
Date: Thu, 18 Nov 2010 17:56:09 -0800
Message-Id: <1290131769-18380-1-git-send-email-pinglinux@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tablet buttons are considered as a separate tool in the user land.
All existing tablet models, wacom and hanwang, send PAD_DEVICE_ID
and MSC_SERIAL events. Add them to Bamboo so clients can process
them consistently accross models.

Signed-off-by: Ping Cheng <pingc@wacom.com>
---
 drivers/input/tablet/wacom_wac.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 360ce4a..e4da526 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -901,11 +901,15 @@ static int wacom_bpt_touch(struct wacom_wac *wacom)
 	input_report_abs(input, ABS_PRESSURE, sp);
 	input_report_abs(input, ABS_X, sx);
 	input_report_abs(input, ABS_Y, sy);
+	input_sync(input);
 
 	input_report_key(input, BTN_LEFT, (data[1] & 0x08) != 0);
 	input_report_key(input, BTN_FORWARD, (data[1] & 0x04) != 0);
 	input_report_key(input, BTN_BACK, (data[1] & 0x02) != 0);
 	input_report_key(input, BTN_RIGHT, (data[1] & 0x01) != 0);
+	input_report_key(input, BTN_TOOL_BUTTONS, 0xf0);
+	input_report_abs(input, ABS_MISC, PAD_DEVICE_ID);
+	input_event(input, EV_MSC, MSC_SERIAL, 0xf0);
 
 	input_sync(input);
 
@@ -1261,9 +1265,8 @@ void wacom_setup_input_capabilities(struct input_dev *input_dev,
 		break;
 
 	case BAMBOO_PT:
-		__clear_bit(ABS_MISC, input_dev->absbit);
-
 		if (features->device_type == BTN_TOOL_TRIPLETAP) {
+			__set_bit(BTN_TOOL_BUTTONS, input_dev->keybit);
 			__set_bit(BTN_LEFT, input_dev->keybit);
 			__set_bit(BTN_FORWARD, input_dev->keybit);
 			__set_bit(BTN_BACK, input_dev->keybit);
@@ -1284,7 +1287,9 @@ void wacom_setup_input_capabilities(struct input_dev *input_dev,
 					     features->pressure_fuzz, 0);
 			input_set_abs_params(input_dev, ABS_MT_TRACKING_ID, 0,
 					     MAX_TRACKING_ID, 0, 0);
-		} else if (features->device_type == BTN_TOOL_PEN) {
+		} 
+
+		if (features->device_type == BTN_TOOL_PEN) {
 			__set_bit(BTN_TOOL_RUBBER, input_dev->keybit);
 			__set_bit(BTN_TOOL_PEN, input_dev->keybit);
 			__set_bit(BTN_STYLUS, input_dev->keybit);
-- 
1.7.2.3

