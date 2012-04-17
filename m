Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab2DQXAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 19:00:22 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:65247 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2DQXAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 19:00:20 -0400
From: George Pantalos <gpantalos@gmail.com>
Cc: dmitry.torokhov@gmail.com, rubini@cvml.unipv.it,
        Seth Forshee <seth.forshee@canonical.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Input: ALPS - Add semi-MT support for v4 protocol
Date: Wed, 18 Apr 2012 02:02:14 +0300
Message-ID: <1753794.1syzYofK8B@vaio>
User-Agent: KMail/4.8.2 (Linux/3.3.2-1-ARCH; KDE/4.8.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds semi-MT support for ALPS v4 protocol touchpads.
It is based on the work by Seth Forshee for ALPS v3 and v4 protocol
support. Three packets are required to assemble and process the MT
data. ST events are reported at once to avoid latency. If there
were two contacts or more, report MT data instead of ST events.

Thanks to Seth Forshee for providing most of the code, guidance
and insight for producing this patch.

Signed-off-by: George Pantalos <gpantalos@gmail.com>
---
 drivers/input/mouse/alps.c |   79 +++++++++++++++++++++++++++++++---
 drivers/input/mouse/alps.h |    2 +
 2 files changed, 75 insertions(+), 6 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 4c6a72d..6028e02 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -604,10 +604,54 @@ static void alps_process_packet_v3(struct 
psmouse *psmouse)
 
 static void alps_process_packet_v4(struct psmouse *psmouse)
 {
+	struct alps_data *priv = psmouse->private;
 	unsigned char *packet = psmouse->packet;
 	struct input_dev *dev = psmouse->dev;
+	int offset;
 	int x, y, z;
 	int left, right;
+	int x1, y1, x2, y2;
+	int fingers = 0;
+	unsigned int x_bitmap, y_bitmap;
+
+	/*
+	 * v4 has a 6-byte encoding for bitmap data, but this data is
+	 * broken up between 3 normal packets. Use priv->multi_packet to
+	 * track our position in the bitmap packet.
+	 */
+	if (packet[6] & 0x40) {
+		/* sync, reset position */
+		priv->multi_packet = 0;
+	}
+
+	if (WARN_ON_ONCE(priv->multi_packet > 2))
+		return;
+
+	offset = 2 * priv->multi_packet;
+	priv->multi_data[offset] = packet[6];
+	priv->multi_data[offset + 1] = packet[7];
+
+	if (++priv->multi_packet > 2) {
+		priv->multi_packet = 0;
+
+		x_bitmap = ((priv->multi_data[2] & 0x1f) << 10) |
+			   ((priv->multi_data[3] & 0x60) << 3) |
+			   ((priv->multi_data[0] & 0x3f) << 2) |
+			   ((priv->multi_data[1] & 0x60) >> 5);
+		y_bitmap = ((priv->multi_data[5] & 0x01) << 10) |
+			   ((priv->multi_data[3] & 0x1f) << 5) |
+			   (priv->multi_data[1] & 0x1f);
+
+		fingers = alps_process_bitmap(x_bitmap, y_bitmap,
+					      &x1, &y1, &x2, &y2);
+
+		/* Store MT data.*/
+		priv->fingers = fingers;
+		priv->x1 = x1;
+		priv->x2 = x2;
+		priv->y1 = y1;
+		priv->y2 = y2;
+	}
 
 	left = packet[4] & 0x01;
 	right = packet[4] & 0x02;
@@ -617,21 +661,44 @@ static void alps_process_packet_v4(struct psmouse 
*psmouse)
 	y = ((packet[2] & 0x7f) << 4) | (packet[3] & 0x0f);
 	z = packet[5] & 0x7f;
 
+	/*
+	 * If there were no contacts in the bitmap, use ST
+	 * points in MT reports.
+	 * If there were two contacts or more, report MT data.
+	 */
+	if (priv->fingers < 2) {
+		x1 = x;
+		y1 = y;
+		fingers = z > 0 ? 1 : 0;
+	} else {
+		fingers = priv->fingers;
+		x1 = priv->x1;
+		x2 = priv->x2;
+		y1 = priv->y1;
+		y2 = priv->y2;
+	}
+
 	if (z >= 64)
 		input_report_key(dev, BTN_TOUCH, 1);
 	else
 		input_report_key(dev, BTN_TOUCH, 0);
 
+	alps_report_semi_mt_data(dev, fingers, x1, y1, x2, y2);
+
+	input_report_key(dev, BTN_TOOL_FINGER, fingers == 1);
+	input_report_key(dev, BTN_TOOL_DOUBLETAP, fingers == 2);
+	input_report_key(dev, BTN_TOOL_TRIPLETAP, fingers == 3);
+	input_report_key(dev, BTN_TOOL_QUADTAP, fingers == 4);
+
+	input_report_key(dev, BTN_LEFT, left);
+	input_report_key(dev, BTN_RIGHT, right);
+
 	if (z > 0) {
 		input_report_abs(dev, ABS_X, x);
 		input_report_abs(dev, ABS_Y, y);
 	}
 	input_report_abs(dev, ABS_PRESSURE, z);
 
-	input_report_key(dev, BTN_TOOL_FINGER, z > 0);
-	input_report_key(dev, BTN_LEFT, left);
-	input_report_key(dev, BTN_RIGHT, right);
-
 	input_sync(dev);
 }
 
@@ -1557,6 +1624,7 @@ int alps_init(struct psmouse *psmouse)
 		input_set_abs_params(dev1, ABS_Y, 0, 767, 0, 0);
 		break;
 	case ALPS_PROTO_V3:
+	case ALPS_PROTO_V4:
 		set_bit(INPUT_PROP_SEMI_MT, dev1->propbit);
 		input_mt_init_slots(dev1, 2);
 		input_set_abs_params(dev1, ABS_MT_POSITION_X, 0, 
ALPS_V3_X_MAX, 0, 0);
@@ -1565,8 +1633,7 @@ int alps_init(struct psmouse *psmouse)
 		set_bit(BTN_TOOL_DOUBLETAP, dev1->keybit);
 		set_bit(BTN_TOOL_TRIPLETAP, dev1->keybit);
 		set_bit(BTN_TOOL_QUADTAP, dev1->keybit);
-		/* fall through */
-	case ALPS_PROTO_V4:
+
 		input_set_abs_params(dev1, ABS_X, 0, ALPS_V3_X_MAX, 0, 0);
 		input_set_abs_params(dev1, ABS_Y, 0, ALPS_V3_Y_MAX, 0, 0);
 		break;
diff --git a/drivers/input/mouse/alps.h b/drivers/input/mouse/alps.h
index a00a4ab..ae1ac35 100644
--- a/drivers/input/mouse/alps.h
+++ b/drivers/input/mouse/alps.h
@@ -39,6 +39,8 @@ struct alps_data {
 	int prev_fin;			/* Finger bit from previous packet */
 	int multi_packet;		/* Multi-packet data in progress */
 	unsigned char multi_data[6];	/* Saved multi-packet data */
+	int x1, x2, y1, y2;		/* Coordinates from last MT report */
+	int fingers;			/* Number of fingers from MT report */
 	u8 quirks;
 	struct timer_list timer;
 };
--
1.7.10


