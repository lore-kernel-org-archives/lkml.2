Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab1F2FIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 01:08:53 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60260 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1F2FIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 01:08:02 -0400
From: djkurtz@chromium.org
To: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        chase.douglas@canonical.com, rubini@cvml.unipv.it
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org, Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 10/12] Input: synaptics - decode AGM packet types
Date: Wed, 29 Jun 2011 13:07:20 +0800
Message-Id: <1309324042-22943-11-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Kurtz <djkurtz@chromium.org>

A Synaptics image sensor tracks 5 fingers, but can only report 2.
This behavior is called "T5R2" = Track 5 Report 2

Algorithm for choosing which 2 fingers to report in which packet:
  Touchpad maintains 5 slots, numbered 0 to 4.
  Initially all slots are empty.
  As new fingers are detected, they are assigned the lowest available
  slot.
  Touchpad always reports:
    SGM: lowest numbered non-empty slot
    AGM: highest numbered non-empty slot, if there is one.

In addition, T5R2 touchpads have a special AGM packet type which reports
the number of fingers currently being tracked, and which finger is in
each of the two slots.  Unfortunately, these "TYPE=2" packets are only used
when more than 3 fingers are being tracked.  When less than 4 fingers
are present, the 'w' value must be used to track how many fingers are
present, and knowing which fingers are being reported is much more
difficult, if not impossible.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/mouse/synaptics.c |   39 ++++++++++++++++++++++++++++++++++-----
 drivers/input/mouse/synaptics.h |    7 ++++++-
 include/linux/input.h           |    1 +
 3 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 2d7ac0a..19a9b7f 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -401,6 +401,14 @@ static void synaptics_pt_create(struct psmouse *psmouse)
 /*****************************************************************************
  *	Functions to interpret the absolute mode packets
  ****************************************************************************/
+/* Set AGM-CONTACT finger state */
+static void synaptics_agm_finger_update(struct synaptics_data *priv, int count,
+					int sgm, int agm)
+{
+	priv->agm.finger_count = count;
+	priv->agm.finger_sgm = sgm;
+	priv->agm.finger_agm = agm;
+}
 
 static int synaptics_parse_hw_state(const unsigned char buf[],
 				    struct synaptics_data *priv,
@@ -438,11 +446,31 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
 		if ((SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)
 				|| SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c))
 				&& hw->w == 2) {
-			/* Gesture packet: (x, y, z) at half resolution */
-			priv->agm.x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
-			priv->agm.y = INVERT_Y((((buf[4] & 0xf0) << 4)
-					      | buf[2]) << 1);
-			priv->agm.z = ((buf[3] & 0x30) | (buf[5] & 0x0f)) << 1;
+			int type; /* Packet type */
+
+			type = (buf[5] & 0x30) >> 4;
+
+			switch (type) {
+			case 1:
+				/* Gesture packet: (x, y, z) half resolution */
+				priv->agm.w = hw->w;
+				priv->agm.x = (((buf[4] & 0x0f) << 8)
+						| buf[1]) << 1;
+				priv->agm.y = INVERT_Y((((buf[4] & 0xf0) << 4)
+						       | buf[2]) << 1);
+				priv->agm.z = ((buf[3] & 0x30)
+						| (buf[5] & 0x0f)) << 1;
+				break;
+
+			case 2:
+				/* Finger slot update */
+				synaptics_agm_finger_update(priv, buf[1],
+							    buf[2], buf[4]);
+				break;
+
+			default:
+				break;
+			}
 			return 1;
 		} else {
 			hw->x = (((buf[3] & 0x10) << 8) |
@@ -804,6 +832,7 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 	input_set_abs_params(dev, ABS_PRESSURE, 0, 255, 0, 0);
 
 	if (SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) {
+		__set_bit(INPUT_PROP_SYNAPTICS_T5R2, dev->propbit);
 		input_mt_init_slots(dev, SYN_TRACK_SLOT_COUNT);
 		input_set_abs_params(dev, ABS_MT_POSITION_X, XMIN_NOMINAL,
 				     priv->x_max ?: XMAX_NOMINAL, fuzz, 0);
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index 1de2256..2214af6 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -122,7 +122,7 @@
 #define SYN_SLOT_AGM			2
 
 /* number of tracking slots for Image Sensor firmware */
-#define SYN_TRACK_SLOT_COUNT		2
+#define SYN_TRACK_SLOT_COUNT		5
 
 /*
  * A structure to describe the state of the touchpad hardware (buttons and pad)
@@ -140,6 +140,11 @@ struct synaptics_hw_state {
 	unsigned int down:1;
 	unsigned char ext_buttons;
 	signed char scroll;
+
+	/* Reported in AGM-CONTACT packets */
+	unsigned int finger_count;		/* num fingers being tracked */
+	unsigned int finger_sgm;		/* finger described by sgm */
+	unsigned int finger_agm;		/* finger described by agm */
 };
 
 struct synaptics_data {
diff --git a/include/linux/input.h b/include/linux/input.h
index 771d6d8..732c14e 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -137,6 +137,7 @@ struct input_keymap_entry {
 #define INPUT_PROP_DIRECT		0x01	/* direct input devices */
 #define INPUT_PROP_BUTTONPAD		0x02	/* has button(s) under pad */
 #define INPUT_PROP_SEMI_MT		0x03	/* touch rectangle only */
+#define INPUT_PROP_SYNAPTICS_T5R2	0x04	/* synaptics track 5 report 2 */
 
 #define INPUT_PROP_MAX			0x1f
 #define INPUT_PROP_CNT			(INPUT_PROP_MAX + 1)
-- 
1.7.3.1

