Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783Ab2CMMId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:08:33 -0400
Received: from mail-yx0-f202.google.com ([209.85.213.202]:48916 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab2CMMEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:04:31 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 13/20] Input: atmel_mxt_ts - parse vector field of data packets
Date: Tue, 13 Mar 2012 20:04:16 +0800
Message-Id: <1331640263-18935-14-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atmel_mxt_ts T9 data contains information orientation in its 'vector'
field. Parse and debug print its contents, although its value isn't
actually used yet.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index fa692e5..e05540d 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -528,6 +528,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	int y;
 	int area;
 	int amplitude;
+	int vector1, vector2;
 
 	status = message->message[0];
 	x = (message->message[1] << 4) | ((message->message[3] >> 4) & 0xf);
@@ -540,8 +541,12 @@ static void mxt_input_touchevent(struct mxt_data *data,
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
@@ -551,7 +556,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 		(status & MXT_AMP) ? 'A' : '.',
 		(status & MXT_SUPPRESS) ? 'S' : '.',
 		(status & MXT_UNGRIP) ? 'U' : '.',
-		x, y, area, amplitude);
+		x, y, area, amplitude, vector1, vector2);
 
 	input_mt_slot(input_dev, id);
 	input_mt_report_slot_state(input_dev, MT_TOOL_FINGER,
@@ -563,6 +568,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 		input_report_abs(input_dev, ABS_MT_PRESSURE, amplitude);
 		/* TODO: This should really be sqrt(area) */
 		input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR, area);
+		/* TODO: Use vector to report ORIENTATION & TOUCH_MINOR */
 	}
 
 	input_mt_report_pointer_emulation(input_dev, false);
-- 
1.7.7.3

