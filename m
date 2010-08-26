Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab0HZCBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 22:01:03 -0400
Received: from leo.clearchain.com ([199.73.29.74]:37924 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab0HZCBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 22:01:00 -0400
Date: Thu, 26 Aug 2010 12:01:41 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pinglinux@gmail.com, rydberg@euromail.se
Subject: [PATCH v2] input: add multitouch slot support to w8001.
Message-ID: <20100826020141.GA24887@barra.bne.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282280135-15942-4-git-send-email-peter.hutterer@who-t.net>
User-Agent: Mutt/1.5.20 (2010-07-18)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Thu, 26 Aug 2010 11:30:55 +0930 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some serial wacom devices support two-finger touch. Test for this during
init and parse the touch packets accordingly. Touch packets are
processed using Protocol B (MT Slots).

Note: there are several wacom versions that do touch but not two-finger
touch. These are not catered for here, touch events for these are simply
discarded.

Signed-off-by: Peter Hutterer <peter.hutterer@who-t.net>
CC: Henrik Rydberg <rydberg@euromail.se>
---
Changes to v1:
- model MT slot approach after Henrik's bamboo patches
- add a comment about what the missing bytes are in the data packets

Henrik, I think this addresses all your comments? The patch is certainly
a bit simpler now.

 drivers/input/touchscreen/wacom_w8001.c |   49 +++++++++++++++++++++++++++++--
 1 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/wacom_w8001.c b/drivers/input/touchscreen/wacom_w8001.c
index 7feac22..297c79d 100644
--- a/drivers/input/touchscreen/wacom_w8001.c
+++ b/drivers/input/touchscreen/wacom_w8001.c
@@ -49,6 +49,8 @@ MODULE_LICENSE("GPL");
 #define W8001_PKTLEN_TPCCTL	11	/* control packet */
 #define W8001_PKTLEN_TOUCH2FG	13
 
+#define MAX_TRACKING_ID		0xFF	/* arbitrarily chosen */
+
 struct w8001_coord {
 	u8 rdy;
 	u8 tsw;
@@ -86,6 +88,7 @@ struct w8001 {
 	char phys[32];
 	int type;
 	unsigned int pktlen;
+	int trkid[2];
 };
 
 static void parse_data(u8 *data, struct w8001_coord *coord)
@@ -112,6 +115,35 @@ static void parse_data(u8 *data, struct w8001_coord *coord)
 	coord->tilt_y = data[8] & 0x7F;
 }
 
+static void parse_touch(struct w8001 *w8001)
+{
+	static int trkid;
+	struct input_dev *dev = w8001->dev;
+	unsigned char *data = w8001->data;
+	int i;
+
+	for (i = 0; i < 2; i++) {
+		input_mt_slot(dev, i);
+
+		if (data[0] & (1 << i)) {
+			int x = (data[6 * i + 1] << 7) | (data[6 * i + 2]);
+			int y = (data[6 * i + 3] << 7) | (data[6 * i + 4]);
+			/* data[5,6] and [11,12] is finger capacity */
+
+			input_report_abs(dev, ABS_MT_POSITION_X, x);
+			input_report_abs(dev, ABS_MT_POSITION_Y, y);
+			input_report_abs(dev, ABS_MT_TOOL_TYPE, MT_TOOL_FINGER);
+			if (w8001->trkid[i] < 0)
+				w8001->trkid[i] = trkid++ & MAX_TRACKING_ID;
+		} else {
+			w8001->trkid[i] = -1;
+		}
+		input_report_abs(dev, ABS_MT_TRACKING_ID, w8001->trkid[i]);
+	}
+
+	input_sync(dev);
+}
+
 static void parse_touchquery(u8 *data, struct w8001_touch_query *query)
 {
 	memset(query, 0, sizeof(*query));
@@ -218,10 +250,10 @@ static irqreturn_t w8001_interrupt(struct serio *serio,
 		complete(&w8001->cmd_done);
 		break;
 
+	/* 2 finger touch packet */
 	case W8001_PKTLEN_TOUCH2FG - 1:
-		/* ignore two-finger touch packet. */
-		if (w8001->pktlen == w8001->idx)
-			w8001->idx = 0;
+		w8001->idx = 0;
+		parse_touch(w8001);
 		break;
 	}
 
@@ -283,6 +315,16 @@ static int w8001_setup(struct w8001 *w8001)
 			break;
 		case 5:
 			w8001->pktlen = W8001_PKTLEN_TOUCH2FG;
+
+			input_mt_create_slots(dev, 2);
+			input_set_abs_params(dev, ABS_MT_TRACKING_ID,
+						0, MAX_TRACKING_ID, 0, 0);
+			input_set_abs_params(dev, ABS_MT_POSITION_X,
+						0, touch.x, 0, 0);
+			input_set_abs_params(dev, ABS_MT_POSITION_Y,
+						0, touch.y, 0, 0);
+			input_set_abs_params(dev, ABS_MT_TOOL_TYPE,
+						0, 0, 0, 0);
 			break;
 		}
 	}
@@ -328,6 +370,7 @@ static int w8001_connect(struct serio *serio, struct serio_driver *drv)
 	w8001->serio = serio;
 	w8001->id = serio->id.id;
 	w8001->dev = input_dev;
+	w8001->trkid[0] = w8001->trkid[1] = -1;
 	init_completion(&w8001->cmd_done);
 	snprintf(w8001->phys, sizeof(w8001->phys), "%s/input0", serio->phys);
 
-- 
1.7.2.2
