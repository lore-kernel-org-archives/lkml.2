Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab0LVKSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 05:18:43 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:36683 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637Ab0LVKSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:18:41 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        Takashi Iwai <tiwai@suse.de>,
        Chase Douglas <chase.douglas@canonical.com>,
        Chris Bagwell <chris@cnpbagwell.com>
Subject: [PATCH v2 2/3] Input: synaptics - add multi-finger and semi-mt support
Date: Wed, 22 Dec 2010 11:18:01 +0100
Message-Id: <1293013081-30740-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.2.3
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PVLlp-0003ur-6z.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PVLlp-0003ur-6z da4b1092766294b81ddd41363640a3cb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Synaptics 2.7 series of touchpads support a mode for reporting two
sets of X/Y/Pressure data (advanced gesture mode). By default, these
devices report only single finger data, depriving userspace of the
nowadays ubiquitous two-finger scroll gesture.

Enabling advanced gesture mode also enables the multi-finger report,
although the device does not claim that capability. Up to three
fingers can be reported this way.

While two or three fingers are touching, the normal packet is
prepended by a reduced finger packet of lower resolution. From the two
packets (which do not represent the actual fingers), the bounding
rectangle of the individual contacts can be extracted.  This
information is sufficient to perform scaling gestures and a limited
form of rotation gesture. The behavior has been coined semi-mt
capability, and is signaled to userspace via the INPUT_PROP_SEMI_MT
device property.

Work to decode the advanced gesture packet: Takashi Iwai.
Cleanup and testing of the original patch: Chase Douglas.
Minor cleanup and testing: Chris Bagwell.
Finalization and semi-mt support: Henrik Rydberg.

Reported-by: Tobyn Bertram
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
Signed-off-by: Chris Bagwell <chris@cnpbagwell.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/synaptics.c |   88 +++++++++++++++++++++++++++++++++++++-
 drivers/input/mouse/synaptics.h |    3 +
 2 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 8997cbc..6514928 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -25,7 +25,7 @@
 
 #include <linux/module.h>
 #include <linux/dmi.h>
-#include <linux/input.h>
+#include <linux/input/mt.h>
 #include <linux/serio.h>
 #include <linux/libps2.h>
 #include <linux/slab.h>
@@ -279,6 +279,25 @@ static void synaptics_set_rate(struct psmouse *psmouse, unsigned int rate)
 	synaptics_mode_cmd(psmouse, priv->mode);
 }
 
+static int synaptics_set_advanced_gesture_mode(struct psmouse *psmouse)
+{
+	static unsigned char param = 0xc8;
+	struct synaptics_data *priv = psmouse->private;
+
+	if (!SYN_CAP_ADV_GESTURE(priv->ext_cap_0c))
+		return 0;
+
+	if (psmouse_sliced_command(psmouse, SYN_QUE_MODEL))
+		return -1;
+	if (ps2_command(&psmouse->ps2dev, &param, PSMOUSE_CMD_SETRATE))
+		return -1;
+
+	/* Advanced gesture mode also sends multi finger data */
+	priv->capabilities |= BIT(1);
+
+	return 0;
+}
+
 /*****************************************************************************
  *	Synaptics pass-through PS/2 port support
  ****************************************************************************/
@@ -380,7 +399,9 @@ static void synaptics_pt_create(struct psmouse *psmouse)
  *	Functions to interpret the absolute mode packets
  ****************************************************************************/
 
-static void synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data *priv, struct synaptics_hw_state *hw)
+static int synaptics_parse_hw_state(const unsigned char buf[],
+				    struct synaptics_data *priv,
+				    struct synaptics_hw_state *hw)
 {
 	memset(hw, 0, sizeof(struct synaptics_hw_state));
 
@@ -397,6 +418,14 @@ static void synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data
 			 ((buf[0] & 0x04) >> 1) |
 			 ((buf[3] & 0x04) >> 2));
 
+		if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) && hw->w == 2) {
+			/* Gesture packet: (x, y, z) at half resolution */
+			priv->mt.x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
+			priv->mt.y = (((buf[4] & 0xf0) << 4) | buf[2]) << 1;
+			priv->mt.z = ((buf[3] & 0x30) | (buf[5] & 0x0f)) << 1;
+			return 1;
+		}
+
 		hw->left  = (buf[0] & 0x01) ? 1 : 0;
 		hw->right = (buf[0] & 0x02) ? 1 : 0;
 
@@ -452,6 +481,36 @@ static void synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data
 		hw->left  = (buf[0] & 0x01) ? 1 : 0;
 		hw->right = (buf[0] & 0x02) ? 1 : 0;
 	}
+
+	return 0;
+}
+
+static void set_slot(struct input_dev *dev, int slot, bool active, int x, int y)
+{
+	input_mt_slot(dev, slot);
+	input_mt_report_slot_state(dev, MT_TOOL_FINGER, active);
+	if (active) {
+		input_report_abs(dev, ABS_MT_POSITION_X, x);
+		input_report_abs(dev, ABS_MT_POSITION_Y,
+				 YMAX_NOMINAL + YMIN_NOMINAL - y);
+	}
+}
+
+static void synaptics_report_semi_mt_data(struct input_dev *dev,
+					  const struct synaptics_hw_state *a,
+					  const struct synaptics_hw_state *b,
+					  int num_fingers)
+{
+	if (num_fingers >= 2) {
+		set_slot(dev, 0, true, min(a->x, b->x), min(a->y, b->y));
+		set_slot(dev, 1, true, max(a->x, b->x), max(a->y, b->y));
+	} else if (num_fingers == 1) {
+		set_slot(dev, 0, true, a->x, a->y);
+		set_slot(dev, 1, false, 0, 0);
+	} else {
+		set_slot(dev, 0, false, 0, 0);
+		set_slot(dev, 1, false, 0, 0);
+	}
 }
 
 /*
@@ -466,7 +525,8 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	int finger_width;
 	int i;
 
-	synaptics_parse_hw_state(psmouse->packet, priv, &hw);
+	if (synaptics_parse_hw_state(psmouse->packet, priv, &hw))
+		return;
 
 	if (hw.scroll) {
 		priv->scroll += hw.scroll;
@@ -512,6 +572,9 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 		finger_width = 0;
 	}
 
+	if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c))
+		synaptics_report_semi_mt_data(dev, &hw, &priv->mt, num_fingers);
+
 	/* Post events
 	 * BTN_TOUCH has to be first as mousedev relies on it when doing
 	 * absolute -> relative conversion
@@ -631,6 +694,15 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 			     YMIN_NOMINAL, priv->y_max ?: YMAX_NOMINAL, 0, 0);
 	input_set_abs_params(dev, ABS_PRESSURE, 0, 255, 0, 0);
 
+	if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)) {
+		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
+		input_mt_init_slots(dev, 2);
+		input_set_abs_params(dev, ABS_MT_POSITION_X, XMIN_NOMINAL,
+				     priv->x_max ?: XMAX_NOMINAL, 0, 0);
+		input_set_abs_params(dev, ABS_MT_POSITION_Y, YMIN_NOMINAL,
+				     priv->y_max ?: YMAX_NOMINAL, 0, 0);
+	}
+
 	if (SYN_CAP_PALMDETECT(priv->capabilities))
 		input_set_abs_params(dev, ABS_TOOL_WIDTH, 0, 15, 0, 0);
 
@@ -705,6 +777,11 @@ static int synaptics_reconnect(struct psmouse *psmouse)
 		return -1;
 	}
 
+	if (synaptics_set_advanced_gesture_mode(psmouse)) {
+		printk(KERN_ERR "Advanced gesture mode reconnect failed.\n");
+		return -1;
+	}
+
 	return 0;
 }
 
@@ -772,6 +849,11 @@ int synaptics_init(struct psmouse *psmouse)
 		goto init_fail;
 	}
 
+	if (synaptics_set_advanced_gesture_mode(psmouse)) {
+		printk(KERN_ERR "Advanced gesture mode init failed.\n");
+		goto init_fail;
+	}
+
 	priv->pkt_type = SYN_MODEL_NEWABS(priv->model_id) ? SYN_NEWABS : SYN_OLDABS;
 
 	printk(KERN_INFO "Synaptics Touchpad, model: %ld, fw: %ld.%ld, id: %#lx, caps: %#lx/%#lx/%#lx\n",
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index 613a365..50e20e9 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -53,6 +53,7 @@
 #define SYN_CAP_PRODUCT_ID(ec)		(((ec) & 0xff0000) >> 16)
 #define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100100)
 #define SYN_CAP_MAX_DIMENSIONS(ex0c)	((ex0c) & 0x020000)
+#define SYN_CAP_ADV_GESTURE(ex0c)	((ex0c) & 0x080000)
 
 /* synaptics modes query bits */
 #define SYN_MODE_ABSOLUTE(m)		((m) & (1 << 7))
@@ -112,6 +113,8 @@ struct synaptics_data {
 	int scroll;
 
 	struct serio *pt_port;			/* Pass-through serio port */
+
+	struct synaptics_hw_state mt;		/* current gesture packet */
 };
 
 void synaptics_module_init(void);
-- 
1.7.2.3

