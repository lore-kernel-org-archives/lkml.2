Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab1HVLGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 07:06:17 -0400
Received: from smtp-out.google.com ([74.125.121.67]:11292 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751Ab1HVLGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 07:06:12 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: chase.douglas@canonical.com, dmitry.torokhov@gmail.com,
        rydberg@euromail.se
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 4/9 v5] Input: synaptics - add image sensor support
Date: Mon, 22 Aug 2011 19:05:58 +0800
Message-Id: <1314011163-19098-5-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1314011163-19098-1-git-send-email-djkurtz@chromium.org>
References: <1314011163-19098-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Synaptics makes (at least) two kinds of touchpad sensors:
 * Older pads use a profile sensor that could only infer the location
   of individual fingers based on the projection of their profiles
   onto row and column sensors.
 * Newer pads use an image sensor that can track true finger position
   using a two-dimensional sensor grid.

Both sensor types support an "Advanced Gesture Mode":
 When multiple fingers are detected, the touchpad sends alternating
 "Advanced Gesture Mode" (AGM) and "Simple Gesture Mode" (SGM)
 packets.
 The AGM packets have w=2, and contain reduced resolution finger data
 The SGM packets have w={0,1} and contain full resolution finger data

Profile sensors try to report the "upper" (larger y value) finger in
the SGM packet, and the lower (smaller y value) in the AGM packet.
However, due to the nature of the profile sensor, they easily get
confused when fingers cross, and can start reporting the x-coordinate
of one with the y-coordinate of the other.  Thus, for profile
sensors, "semi-mt" was created, which reports a "bounding box"
created by pairing min and max coordinates of the two pairs of
reported fingers.

Image sensors can report the actual coordinates of two of the fingers
present.  This patch detects if the touchpad is an image sensor and
reports finger data using the MT-B protocol.

NOTE: This patch only adds partial support for 2-finger gestures.
      The proper interpretation of the slot contents when more than
      two fingers are present is left to later patches.  Also,
      handling of 'number of fingers' transitions is incomplete.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/mouse/synaptics.c |  124 +++++++++++++++++++++++++++++++++-----
 drivers/input/mouse/synaptics.h |    3 +
 2 files changed, 110 insertions(+), 17 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 30d05fd..232fa00 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -304,7 +304,8 @@ static int synaptics_set_advanced_gesture_mode(struct psmouse *psmouse)
 	static unsigned char param = 0xc8;
 	struct synaptics_data *priv = psmouse->private;
 
-	if (!SYN_CAP_ADV_GESTURE(priv->ext_cap_0c))
+	if (!(SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) ||
+			SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)))
 		return 0;
 
 	if (psmouse_sliced_command(psmouse, SYN_QUE_MODEL))
@@ -463,7 +464,9 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
 			hw->down = ((buf[0] ^ buf[3]) & 0x02) ? 1 : 0;
 		}
 
-		if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) && hw->w == 2) {
+		if ((SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)
+				|| SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c))
+				&& hw->w == 2) {
 			synaptics_parse_agm(buf, priv);
 			return 1;
 		}
@@ -543,6 +546,94 @@ static void synaptics_report_semi_mt_data(struct input_dev *dev,
 	}
 }
 
+static void synaptics_report_buttons(struct psmouse *psmouse,
+				     const struct synaptics_hw_state *hw)
+{
+	struct input_dev *dev = psmouse->dev;
+	struct synaptics_data *priv = psmouse->private;
+	int i;
+
+	input_report_key(dev, BTN_LEFT, hw->left);
+	input_report_key(dev, BTN_RIGHT, hw->right);
+
+	if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities))
+		input_report_key(dev, BTN_MIDDLE, hw->middle);
+
+	if (SYN_CAP_FOUR_BUTTON(priv->capabilities)) {
+		input_report_key(dev, BTN_FORWARD, hw->up);
+		input_report_key(dev, BTN_BACK, hw->down);
+	}
+
+	for (i = 0; i < SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap); i++)
+		input_report_key(dev, BTN_0 + i, hw->ext_buttons & (1 << i));
+}
+
+static void synaptics_report_slot(struct input_dev *dev, int slot,
+				  const struct synaptics_hw_state *hw)
+{
+	input_mt_slot(dev, slot);
+	input_mt_report_slot_state(dev, MT_TOOL_FINGER, (hw != NULL));
+	if (!hw)
+		return;
+
+	input_report_abs(dev, ABS_MT_POSITION_X, hw->x);
+	input_report_abs(dev, ABS_MT_POSITION_Y, invert_y(hw->y));
+	input_report_abs(dev, ABS_MT_PRESSURE, hw->z);
+}
+
+static void synaptics_report_mt_data(struct psmouse *psmouse,
+				     int count,
+				     const struct synaptics_hw_state *sgm)
+{
+	struct input_dev *dev = psmouse->dev;
+	struct synaptics_data *priv = psmouse->private;
+	struct synaptics_hw_state *agm = &priv->agm;
+
+	switch (count) {
+	case 0:
+		synaptics_report_slot(dev, 0, NULL);
+		synaptics_report_slot(dev, 1, NULL);
+		break;
+	case 1:
+		synaptics_report_slot(dev, 0, sgm);
+		synaptics_report_slot(dev, 1, NULL);
+		break;
+	case 2:
+	case 3: /* Fall-through case */
+		synaptics_report_slot(dev, 0, sgm);
+		synaptics_report_slot(dev, 1, agm);
+		break;
+	}
+
+	/* Don't use active slot count to generate BTN_TOOL events. */
+	input_mt_report_pointer_emulation(dev, false);
+
+	/* Send the number of fingers reported by touchpad itself. */
+	input_mt_report_finger_count(dev, count);
+
+	synaptics_report_buttons(psmouse, sgm);
+
+	input_sync(dev);
+}
+
+static void synaptics_image_sensor_process(struct psmouse *psmouse,
+					   struct synaptics_hw_state *sgm)
+{
+	int count;
+
+	if (sgm->z == 0)
+		count = 0;
+	else if (sgm->w >= 4)
+		count = 1;
+	else if (sgm->w == 0)
+		count = 2;
+	else
+		count = 3;
+
+	/* Send resulting input events to user space */
+	synaptics_report_mt_data(psmouse, count, sgm);
+}
+
 /*
  *  called for each full received packet from the touchpad
  */
@@ -553,11 +644,15 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	struct synaptics_hw_state hw;
 	int num_fingers;
 	int finger_width;
-	int i;
 
 	if (synaptics_parse_hw_state(psmouse->packet, priv, &hw))
 		return;
 
+	if (SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) {
+		synaptics_image_sensor_process(psmouse, &hw);
+		return;
+	}
+
 	if (hw.scroll) {
 		priv->scroll += hw.scroll;
 
@@ -623,24 +718,12 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 		input_report_abs(dev, ABS_TOOL_WIDTH, finger_width);
 
 	input_report_key(dev, BTN_TOOL_FINGER, num_fingers == 1);
-	input_report_key(dev, BTN_LEFT, hw.left);
-	input_report_key(dev, BTN_RIGHT, hw.right);
-
 	if (SYN_CAP_MULTIFINGER(priv->capabilities)) {
 		input_report_key(dev, BTN_TOOL_DOUBLETAP, num_fingers == 2);
 		input_report_key(dev, BTN_TOOL_TRIPLETAP, num_fingers == 3);
 	}
 
-	if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities))
-		input_report_key(dev, BTN_MIDDLE, hw.middle);
-
-	if (SYN_CAP_FOUR_BUTTON(priv->capabilities)) {
-		input_report_key(dev, BTN_FORWARD, hw.up);
-		input_report_key(dev, BTN_BACK, hw.down);
-	}
-
-	for (i = 0; i < SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap); i++)
-		input_report_key(dev, BTN_0 + i, hw.ext_buttons & (1 << i));
+	synaptics_report_buttons(dev, &hw);
 
 	input_sync(dev);
 }
@@ -739,7 +822,14 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 	set_abs_position_params(dev, priv, ABS_X, ABS_Y);
 	input_set_abs_params(dev, ABS_PRESSURE, 0, 255, 0, 0);
 
-	if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)) {
+	if (SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) {
+		input_mt_init_slots(dev, 2);
+		set_abs_position_params(dev, priv, ABS_MT_POSITION_X,
+					ABS_MT_POSITION_Y);
+		/* Image sensors can report per-contact pressure */
+		input_set_abs_params(dev, ABS_MT_PRESSURE, 0, 255, 0, 0);
+	} else if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)) {
+		/* Non-image sensors with AGM use semi-mt */
 		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
 		input_mt_init_slots(dev, 2);
 		set_abs_position_params(dev, priv, ABS_MT_POSITION_X,
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index a9efbf3..0ea7616 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -74,6 +74,8 @@
  * 2	0x04	reduced filtering	firmware does less filtering on
  *					position data, driver should watch
  *					for noise.
+ * 2	0x08	image sensor		image sensor tracks 5 fingers, but only
+ *					reports 2.
  * 2	0x20	report min		query 0x0f gives min coord reported
  */
 #define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100000) /* 1-button ClickPad */
@@ -82,6 +84,7 @@
 #define SYN_CAP_MIN_DIMENSIONS(ex0c)	((ex0c) & 0x002000)
 #define SYN_CAP_ADV_GESTURE(ex0c)	((ex0c) & 0x080000)
 #define SYN_CAP_REDUCED_FILTERING(ex0c)	((ex0c) & 0x000400)
+#define SYN_CAP_IMAGE_SENSOR(ex0c)	((ex0c) & 0x000800)
 
 /* synaptics modes query bits */
 #define SYN_MODE_ABSOLUTE(m)		((m) & (1 << 7))
-- 
1.7.3.1

