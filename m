Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab2IATmz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 15:42:55 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:51555 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab2IATmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 15:42:51 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnxPAG1kQlBV5qoUPGdsb2JhbABEhRyFI7BfGQEBAQEeGQ0ngiEBBScvEwEPEAhJOQoUBgESiBG6NxSSHAObR40R
X-IronPort-AV: E=Sophos;i="4.80,353,1344204000"; 
   d="scan'208";a="401145403"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH v3 12/20] Input: bcm5974 - Preparatory renames
Date: Sat,  1 Sep 2012 21:47:07 +0200
Message-Id: <1346528835-363-13-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346528835-363-1-git-send-email-rydberg@euromail.se>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename touch properties to match established nomenclature, and define
the maximum number of fingers.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/bcm5974.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 39ac9ff..2de974c 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -183,18 +183,19 @@ struct tp_finger {
 	__le16 abs_y;		/* absolute y coodinate */
 	__le16 rel_x;		/* relative x coodinate */
 	__le16 rel_y;		/* relative y coodinate */
-	__le16 size_major;	/* finger size, major axis? */
-	__le16 size_minor;	/* finger size, minor axis? */
+	__le16 tool_major;	/* tool area, major axis */
+	__le16 tool_minor;	/* tool area, minor axis */
 	__le16 orientation;	/* 16384 when point, else 15 bit angle */
-	__le16 force_major;	/* trackpad force, major axis? */
-	__le16 force_minor;	/* trackpad force, minor axis? */
+	__le16 touch_major;	/* touch area, major axis */
+	__le16 touch_minor;	/* touch area, minor axis */
 	__le16 unused[3];	/* zeros */
 	__le16 multi;		/* one finger: varies, more fingers: constant */
 } __attribute__((packed,aligned(2)));
 
 /* trackpad finger data size, empirically at least ten fingers */
+#define MAX_FINGERS		16
 #define SIZEOF_FINGER		sizeof(struct tp_finger)
-#define SIZEOF_ALL_FINGERS	(16 * SIZEOF_FINGER)
+#define SIZEOF_ALL_FINGERS	(MAX_FINGERS * SIZEOF_FINGER)
 #define MAX_FINGER_ORIENTATION	16384
 
 /* device-specific parameters */
@@ -482,13 +483,13 @@ static void report_finger_data(struct input_dev *input,
 			       const struct tp_finger *f)
 {
 	input_report_abs(input, ABS_MT_TOUCH_MAJOR,
-			 raw2int(f->force_major) << 1);
+			 raw2int(f->touch_major) << 1);
 	input_report_abs(input, ABS_MT_TOUCH_MINOR,
-			 raw2int(f->force_minor) << 1);
+			 raw2int(f->touch_minor) << 1);
 	input_report_abs(input, ABS_MT_WIDTH_MAJOR,
-			 raw2int(f->size_major) << 1);
+			 raw2int(f->tool_major) << 1);
 	input_report_abs(input, ABS_MT_WIDTH_MINOR,
-			 raw2int(f->size_minor) << 1);
+			 raw2int(f->tool_minor) << 1);
 	input_report_abs(input, ABS_MT_ORIENTATION,
 			 MAX_FINGER_ORIENTATION - raw2int(f->orientation));
 	input_report_abs(input, ABS_MT_POSITION_X, raw2int(f->abs_x));
@@ -521,8 +522,8 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 		for (i = 0; i < raw_n; i++)
 			report_finger_data(input, c, &f[i]);
 
-		raw_p = raw2int(f->force_major);
-		raw_w = raw2int(f->size_major);
+		raw_p = raw2int(f->touch_major);
+		raw_w = raw2int(f->tool_major);
 		raw_x = raw2int(f->abs_x);
 		raw_y = raw2int(f->abs_y);
 
@@ -542,7 +543,7 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 			abs_y = int2bound(&c->y, c->y.devmax - raw_y);
 			while (raw_n--) {
 				ptest = int2bound(&c->p,
-						  raw2int(f->force_major));
+						  raw2int(f->touch_major));
 				if (ptest > PRESSURE_LOW)
 					nmax++;
 				if (ptest > PRESSURE_HIGH)
-- 
1.7.12

