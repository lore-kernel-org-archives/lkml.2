Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab1F2FJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 01:09:11 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60274 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1F2FID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 01:08:03 -0400
From: djkurtz@chromium.org
To: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        chase.douglas@canonical.com, rubini@cvml.unipv.it
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org, Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 09/12] Input: synaptics - add image sensor support
Date: Wed, 29 Jun 2011 13:07:19 +0800
Message-Id: <1309324042-22943-10-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Kurtz <djkurtz@chromium.org>

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
 drivers/input/mouse/synaptics.c |  116 ++++++++++++++++++++++++++++++++++++++-
 drivers/input/mouse/synaptics.h |   13 ++++
 2 files changed, 126 insertions(+), 3 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 0a51b0ba..2d7ac0a 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -286,7 +286,8 @@ static int synaptics_set_advanced_gesture_mode(struct psmouse *psmouse)
 	static unsigned char param = 0xc8;
 	struct synaptics_data *priv = psmouse->private;
 
-	if (!SYN_CAP_ADV_GESTURE(priv->ext_cap_0c))
+	if (!(SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) ||
+			SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)))
 		return 0;
 
 	if (psmouse_sliced_command(psmouse, SYN_QUE_MODEL))
@@ -434,7 +435,9 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
 			hw->down = ((buf[0] ^ buf[3]) & 0x02) ? 1 : 0;
 		}
 
-		if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) && hw->w == 2) {
+		if ((SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)
+				|| SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c))
+				&& hw->w == 2) {
 			/* Gesture packet: (x, y, z) at half resolution */
 			priv->agm.x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
 			priv->agm.y = INVERT_Y((((buf[4] & 0xf0) << 4)
@@ -519,6 +522,92 @@ static void synaptics_report_semi_mt_data(struct input_dev *dev,
 	}
 }
 
+static void synaptics_report_mt_slot(struct input_dev *dev, int slot, int state,
+				     const struct synaptics_hw_state *sgm,
+				     const struct synaptics_hw_state *agm)
+{
+	input_mt_slot(dev, slot);
+	switch (state) {
+	case SYN_SLOT_EMPTY:
+		input_mt_report_slot_state(dev, MT_TOOL_FINGER, false);
+		break;
+	case SYN_SLOT_SGM:
+		input_mt_report_slot_state(dev, MT_TOOL_FINGER, true);
+		input_report_abs(dev, ABS_MT_POSITION_X, sgm->x);
+		input_report_abs(dev, ABS_MT_POSITION_Y, sgm->y);
+		input_report_abs(dev, ABS_MT_PRESSURE, sgm->z);
+		if (sgm->w >= 4)
+			input_report_abs(dev, ABS_MT_TOUCH_MAJOR, sgm->w);
+		break;
+	case SYN_SLOT_AGM:
+		input_mt_report_slot_state(dev, MT_TOOL_FINGER, true);
+		input_report_abs(dev, ABS_MT_POSITION_X, agm->x);
+		input_report_abs(dev, ABS_MT_POSITION_Y, agm->y);
+		input_report_abs(dev, ABS_MT_PRESSURE, agm->z);
+		break;
+	}
+}
+
+static void synaptics_update_slots(struct synaptics_data *priv, int count,
+				   int sgm, int agm)
+{
+	int i;
+
+	/* First, clear previous slots. */
+	for (i = 0; i < SYN_TRACK_SLOT_COUNT; i++)
+		priv->slot[i] = SYN_SLOT_EMPTY;
+
+	if (count < 1)
+		return;
+	priv->slot[sgm] = SYN_SLOT_SGM;
+
+	if (count < 2)
+		return;
+	priv->slot[agm] = SYN_SLOT_AGM;
+}
+
+static void synaptics_process_hw_state(struct synaptics_data *priv,
+				       struct synaptics_hw_state *sgm)
+{
+	int new_num_fingers;
+
+	if (sgm->z == 0)
+		new_num_fingers = 0;
+	else if (sgm->w >= 4)
+		new_num_fingers = 1;
+	else if (sgm->w == 0)
+		new_num_fingers = 2;
+	else if (sgm->w == 1)
+		new_num_fingers = 3;
+
+	switch (new_num_fingers) {
+	case 0:
+		synaptics_update_slots(priv, 0, 0, 0);
+		break;
+	case 1:
+		synaptics_update_slots(priv, 1, 0, 0);
+		break;
+	case 2:
+	case 3: /* Fall-through case */
+		synaptics_update_slots(priv, 2, 0, 1);
+		break;
+	}
+
+	priv->num_fingers = new_num_fingers;
+}
+
+static void synaptics_report_mt_data(struct psmouse *psmouse,
+				     struct synaptics_hw_state *sgm)
+{
+	struct input_dev *dev = psmouse->dev;
+	struct synaptics_data *priv = psmouse->private;
+	struct synaptics_hw_state *agm = &priv->agm;
+	int i;
+
+	for (i = 0; i < SYN_TRACK_SLOT_COUNT; i++)
+		synaptics_report_mt_slot(dev, i, priv->slot[i], sgm, agm);
+}
+
 /*
  *  called for each full received packet from the touchpad
  */
@@ -534,6 +623,15 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	if (synaptics_parse_hw_state(psmouse->packet, priv, &hw))
 		return;
 
+	if (SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) {
+		synaptics_process_hw_state(priv, &hw);
+		synaptics_report_mt_data(psmouse, &hw);
+		input_mt_report_pointer_emulation(dev, true);
+		input_report_key(dev, BTN_LEFT, hw.left);
+		input_sync(dev);
+		return;
+	}
+
 	if (hw.scroll) {
 		priv->scroll += hw.scroll;
 
@@ -705,7 +803,19 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 			     priv->y_max ?: YMAX_NOMINAL, fuzz, 0);
 	input_set_abs_params(dev, ABS_PRESSURE, 0, 255, 0, 0);
 
-	if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)) {
+	if (SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) {
+		input_mt_init_slots(dev, SYN_TRACK_SLOT_COUNT);
+		input_set_abs_params(dev, ABS_MT_POSITION_X, XMIN_NOMINAL,
+				     priv->x_max ?: XMAX_NOMINAL, fuzz, 0);
+		input_set_abs_params(dev, ABS_MT_POSITION_Y, YMIN_NOMINAL,
+				     priv->y_max ?: YMAX_NOMINAL, fuzz, 0);
+		input_set_abs_params(dev, ABS_MT_PRESSURE, 0, 255, 0, 0);
+		input_set_abs_params(dev, ABS_MT_TOUCH_MAJOR, 4, 15, 0, 0);
+
+		input_abs_set_res(dev, ABS_MT_POSITION_X, priv->x_res);
+		input_abs_set_res(dev, ABS_MT_POSITION_Y, priv->y_res);
+
+	} else if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)) {
 		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
 		input_mt_init_slots(dev, 2);
 		input_set_abs_params(dev, ABS_MT_POSITION_X, XMIN_NOMINAL,
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index e367239..1de2256 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -73,6 +73,8 @@
  * 2	0x04	reduced filtering	firmware does less filtering on
  *					position data, driver should watch
  *					for noise.
+ * 2	0x08	image sensor		image sensor tracks 5 fingers, but only
+ *					reports 2.
  */
 #define SYN_CAP_ADJ_THRESHOLD(ex0c)	((ex0c) & 0x010000)
 #define SYN_CAP_MAX_DIMENSIONS(ex0c)	((ex0c) & 0x020000)
@@ -84,6 +86,7 @@
 #define SYN_CAP_CLICKPAD2BTN(ex0c)	((ex0c) & 0x000100) /* 2-button ClickPad */
 #define SYN_CAP_DELUXE_LED(ex0c)	((ex0c) & 0x000200)
 #define SYN_CAP_REDUCED_FILTERING(ex0c)	((ex0c) & 0x000400)
+#define SYN_CAP_IMAGE_SENSOR(ex0c)	((ex0c) & 0x000800)
 
 /* synaptics modes query bits */
 #define SYN_MODE_ABSOLUTE(m)		((m) & (1 << 7))
@@ -113,6 +116,14 @@
 /* amount to fuzz position data when touchpad reports reduced filtering */
 #define SYN_REDUCED_FILTER_FUZZ		8
 
+/* synaptics tracking slot states */
+#define SYN_SLOT_EMPTY			0
+#define SYN_SLOT_SGM			1
+#define SYN_SLOT_AGM			2
+
+/* number of tracking slots for Image Sensor firmware */
+#define SYN_TRACK_SLOT_COUNT		2
+
 /*
  * A structure to describe the state of the touchpad hardware (buttons and pad)
  */
@@ -148,6 +159,8 @@ struct synaptics_data {
 	struct serio *pt_port;			/* Pass-through serio port */
 
 	struct synaptics_hw_state agm;		/* last AGM packet */
+	int num_fingers;			/* current finger count */
+	int slot[SYN_TRACK_SLOT_COUNT];		/* finger slot state */
 };
 
 void synaptics_module_init(void);
-- 
1.7.3.1

