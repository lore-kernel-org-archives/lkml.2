Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab0IAB4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 21:56:41 -0400
Received: from adelie.canonical.com ([91.189.90.139]:41760 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab0IAB4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 21:56:38 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Michael Poole <mdpoole@troilus.org>, Henrik Rydberg <rydberg@euromail.se>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7 v3] HID: magicmouse: simplify touch down logic
Date: Tue, 31 Aug 2010 21:56:21 -0400
Message-Id: <1283306184-28833-5-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283306184-28833-1-git-send-email-chase.douglas@canonical.com>
References: <1283306184-28833-1-git-send-email-chase.douglas@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chase Douglas <chase.douglas@ubuntu.com>

For the MT protocol, we need to properly keep track of each down touch.
This change simplifies the logic, and should make things easier when
support for the Magic Trackpad is added.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 drivers/hid/hid-magicmouse.c |   27 +++++++++------------------
 1 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 2ee59a8..0fbca59 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -98,7 +98,6 @@ struct magicmouse_sc {
 		short scroll_x;
 		short scroll_y;
 		u8 size;
-		u8 down;
 	} touches[16];
 	int tracking_ids[16];
 };
@@ -227,8 +226,6 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
 
 	/* Generate the input events for this touch. */
 	if (report_touches && down) {
-		msc->touches[id].down = 1;
-
 		input_report_abs(input, ABS_MT_TRACKING_ID, id);
 		input_report_abs(input, ABS_MT_TOUCH_MAJOR, touch_major);
 		input_report_abs(input, ABS_MT_TOUCH_MINOR, touch_minor);
@@ -241,6 +238,9 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
 
 		input_mt_sync(input);
 	}
+
+	if (down)
+		msc->ntouches++;
 }
 
 static int magicmouse_raw_event(struct hid_device *hdev,
@@ -248,7 +248,7 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 {
 	struct magicmouse_sc *msc = hid_get_drvdata(hdev);
 	struct input_dev *input = msc->input;
-	int x, y, ts, ii, clicks, last_up;
+	int x, y, ts, ii, clicks, npoints;
 
 	switch (data[0]) {
 	case 0x10:
@@ -265,22 +265,13 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 		ts = data[3] >> 6 | data[4] << 2 | data[5] << 10;
 		msc->delta_time = (ts - msc->last_timestamp) & 0x3ffff;
 		msc->last_timestamp = ts;
-		msc->ntouches = (size - 6) / 8;
-		for (ii = 0; ii < msc->ntouches; ii++)
+		npoints = (size - 6) / 8;
+		msc->ntouches = 0;
+		for (ii = 0; ii < npoints; ii++)
 			magicmouse_emit_touch(msc, ii, data + ii * 8 + 6);
 
-		if (report_touches) {
-			last_up = 1;
-			for (ii = 0; ii < ARRAY_SIZE(msc->touches); ii++) {
-				if (msc->touches[ii].down) {
-					last_up = 0;
-					msc->touches[ii].down = 0;
-				}
-			}
-			if (last_up) {
-				input_mt_sync(input);
-			}
-		}
+		if (report_touches && msc->ntouches == 0)
+			input_mt_sync(input);
 
 		/* When emulating three-button mode, it is important
 		 * to have the current touch information before
-- 
1.7.1

