Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766Ab2C2QwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 12:52:00 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:50163 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757666Ab2C2Qtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 12:49:32 -0400
MIME-Version: 1.0
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Cc: Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 14/16 v2] Input: atmel_mxt_ts - parse vector field of data packets
Date: Fri, 30 Mar 2012 00:49:24 +0800
Message-Id: <1333039766-8617-15-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1333039766-8617-1-git-send-email-djkurtz@chromium.org>
References: <1333039766-8617-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atmel_mxt_ts T9 data contains orientation information in its 'vector'
field. Parse and debug print its contents, although its value isn't
actually used yet.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
Acked-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 40dd3e6..be1e2ec 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -489,6 +489,7 @@ static void mxt_input_touch(struct mxt_data *data, struct mxt_message *message)
 	int area;
 	int amplitude;
 	int id;
+	int vector1, vector2;
 
 	id = message->reportid - data->T9_reportid_min;
 
@@ -503,8 +504,12 @@ static void mxt_input_touch(struct mxt_data *data, struct mxt_message *message)
 	area = message->message[4];
 	amplitude = message->message[5];
 
+	/* The two vector components are 4-bit signed ints (2s complement) */
+	vector1 = (signed)((signed char)message->message[6]) >> 4;
+	vector2 = (signed)((signed char)(message->message[6] << 4)) >> 4;
+
 	dev_dbg(dev,
-		"[%d] %c%c%c%c%c%c%c%c x: %d y: %d area: %d amp: %d\n",
+		"[%d] %c%c%c%c%c%c%c%c x: %d y: %d area: %d amp: %d vector: [%d,%d]\n",
 		id,
 		(status & MXT_DETECT) ? 'D' : '.',
 		(status & MXT_PRESS) ? 'P' : '.',
@@ -514,7 +519,7 @@ static void mxt_input_touch(struct mxt_data *data, struct mxt_message *message)
 		(status & MXT_AMP) ? 'A' : '.',
 		(status & MXT_SUPPRESS) ? 'S' : '.',
 		(status & MXT_UNGRIP) ? 'U' : '.',
-		x, y, area, amplitude);
+		x, y, area, amplitude, vector1, vector2);
 
 	input_mt_slot(input_dev, id);
 	input_mt_report_slot_state(input_dev, MT_TOOL_FINGER,
@@ -525,6 +530,7 @@ static void mxt_input_touch(struct mxt_data *data, struct mxt_message *message)
 		input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
 		input_report_abs(input_dev, ABS_MT_PRESSURE, amplitude);
 		input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR, area);
+		/* TODO: Use vector to report ORIENTATION & TOUCH_MINOR */
 	}
 
 	input_mt_report_pointer_emulation(input_dev, false);
-- 
1.7.7.3

