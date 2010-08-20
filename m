Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab0HTFBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 01:01:11 -0400
Received: from leo.clearchain.com ([199.73.29.74]:53352 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab0HTFAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 01:00:50 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Aug 2010 01:00:49 EDT
From: Peter Hutterer <peter.hutterer@who-t.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pinglinux@gmail.com, rydberg@euromail.se
Cc: Peter Hutterer <peter.hutterer@who-t.net>
Subject: [PATCH 2/3] input: support (and ignore) touch tablets in the w8001.
Date: Fri, 20 Aug 2010 14:55:34 +1000
Message-Id: <1282280135-15942-3-git-send-email-peter.hutterer@who-t.net>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282280135-15942-1-git-send-email-peter.hutterer@who-t.net>
References: <1282280135-15942-1-git-send-email-peter.hutterer@who-t.net>
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Fri, 20 Aug 2010 14:25:03 +0930 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tablets that support touch input may report different sized packages,
depending on the touch sensor in the tablet. For now, discard the
packages until we report them as touch input proper.

Signed-off-by: Peter Hutterer <peter.hutterer@who-t.net>
---
 drivers/input/touchscreen/wacom_w8001.c |   88 ++++++++++++++++++++++++++++++-
 1 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/wacom_w8001.c b/drivers/input/touchscreen/wacom_w8001.c
index 0e14ae1..c302cc3 100644
--- a/drivers/input/touchscreen/wacom_w8001.c
+++ b/drivers/input/touchscreen/wacom_w8001.c
@@ -2,6 +2,7 @@
  * Wacom W8001 penabled serial touchscreen driver
  *
  * Copyright (c) 2008 Jaya Kumar
+ * Copyright (c) 2010 Red Hat, Inc.
  *
  * This file is subject to the terms and conditions of the GNU General Public
  * License. See the file COPYING in the main directory of this archive for
@@ -30,11 +31,22 @@ MODULE_LICENSE("GPL");
 #define W8001_LEAD_BYTE		0x80
 #define W8001_TAB_MASK		0x40
 #define W8001_TAB_BYTE		0x40
+/* set in first byte of touch data packets */
+#define W8001_TOUCH_MASK	(0x10 | W8001_LEAD_MASK)
+#define W8001_TOUCH_BYTE	(0x10 | W8001_LEAD_BYTE)
 
 #define W8001_QUERY_PACKET	0x20
 
 #define W8001_CMD_START		'1'
 #define W8001_CMD_QUERY		'*'
+#define W8001_CMD_TOUCHQUERY	'%'
+
+/* length of data packets in bytes, depends on device. */
+#define W8001_PKTLEN_TOUCH93	5
+#define W8001_PKTLEN_TOUCH9A	7
+#define W8001_PKTLEN_TPCPEN	9
+#define W8001_PKTLEN_TPCCTL	11	/* control packet */
+#define W8001_PKTLEN_TOUCH2FG	13
 
 struct w8001_coord {
 	u8 rdy;
@@ -48,6 +60,15 @@ struct w8001_coord {
 	u8 tilt_y;
 };
 
+/* touch query reply packet */
+struct w8001_touch_query {
+	u8 panel_res;
+	u8 capacity_res;
+	u8 sensor_id;
+	u16 x;
+	u16 y;
+};
+
 /*
  * Per-touchscreen data.
  */
@@ -63,6 +84,7 @@ struct w8001 {
 	unsigned char data[W8001_MAX_LENGTH];
 	char phys[32];
 	int type;
+	unsigned int pktlen;
 };
 
 static void parse_data(u8 *data, struct w8001_coord *coord)
@@ -89,6 +111,23 @@ static void parse_data(u8 *data, struct w8001_coord *coord)
 	coord->tilt_y = data[8] & 0x7F;
 }
 
+static void parse_touchquery(u8 *data, struct w8001_touch_query *query)
+{
+	memset(query, 0, sizeof(*query));
+
+	query->panel_res = data[1];
+	query->sensor_id = data[2] & 0x7;
+	query->capacity_res = data[7];
+
+	query->x = data[3] << 9;
+	query->x |= data[4] << 2;
+	query->x |= (data[2] >> 5) & 0x3;
+
+	query->y = data[5] << 9;
+	query->y |= data[6] << 2;
+	query->y |= (data[2] >> 3) & 0x3;
+}
+
 static void report_pen_events(struct w8001 *w8001, struct w8001_coord *coord)
 {
 	struct input_dev *dev = w8001->dev;
@@ -144,22 +183,45 @@ static irqreturn_t w8001_interrupt(struct serio *serio,
 		}
 		break;
 
-	case 8:
+	case W8001_PKTLEN_TOUCH93 - 1:
+	case W8001_PKTLEN_TOUCH9A - 1:
+		/* ignore one-finger touch packet. */
+		if (w8001->pktlen == w8001->idx)
+			w8001->idx = 0;
+		break;
+
+	/* Pen coordinates packet */
+	case W8001_PKTLEN_TPCPEN - 1:
 		tmp = w8001->data[0] & W8001_TAB_MASK;
 		if (unlikely(tmp == W8001_TAB_BYTE))
 			break;
 
+		tmp = (w8001->data[0] & W8001_TOUCH_BYTE);
+		if (tmp == W8001_TOUCH_BYTE)
+			break;
+
 		w8001->idx = 0;
 		parse_data(w8001->data, &coord);
 		report_pen_events(w8001, &coord);
 		break;
 
-	case 10:
+	/* control packet */
+	case W8001_PKTLEN_TPCCTL - 1:
+		tmp = (w8001->data[0] & W8001_TOUCH_MASK);
+		if (tmp == W8001_TOUCH_BYTE)
+			break;
+
 		w8001->idx = 0;
 		memcpy(w8001->response, w8001->data, W8001_MAX_LENGTH);
 		w8001->response_type = W8001_QUERY_PACKET;
 		complete(&w8001->cmd_done);
 		break;
+
+	case W8001_PKTLEN_TOUCH2FG - 1:
+		/* ignore two-finger touch packet. */
+		if (w8001->pktlen == w8001->idx)
+			w8001->idx = 0;
+		break;
 	}
 
 	return IRQ_HANDLED;
@@ -202,6 +264,28 @@ static int w8001_setup(struct w8001 *w8001)
 	input_set_abs_params(dev, ABS_TILT_X, 0, coord.tilt_x, 0, 0);
 	input_set_abs_params(dev, ABS_TILT_Y, 0, coord.tilt_y, 0, 0);
 
+	error = w8001_command(w8001, W8001_CMD_TOUCHQUERY, true);
+	if (!error) {
+		struct w8001_touch_query touch;
+
+		parse_touchquery(w8001->response, &touch);
+
+		switch (touch.sensor_id) {
+		case 0:
+		case 2:
+			w8001->pktlen = W8001_PKTLEN_TOUCH93;
+			break;
+		case 1:
+		case 3:
+		case 4:
+			w8001->pktlen = W8001_PKTLEN_TOUCH9A;
+			break;
+		case 5:
+			w8001->pktlen = W8001_PKTLEN_TOUCH2FG;
+			break;
+		}
+	}
+
 	return w8001_command(w8001, W8001_CMD_START, false);
 }
 
-- 
1.7.2.1

