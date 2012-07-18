Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab2GRGEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 02:04:20 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:51243 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab2GRGEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 02:04:14 -0400
From: Chung-yih Wang <cywang@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        JJ Ding <dgdunix@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chung-yih Wang <cywang@chromium.org>
Subject: [PATCH] CHROMIUM: Input: synaptics - use firmware data for Cr-48
Date: Wed, 18 Jul 2012 14:03:45 +0800
Message-Id: <1342591425-17730-1-git-send-email-cywang@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The profile sensor clickpad in a Cr-48 Chromebook does a reasonable job of
tracking individual fingers. This tracking isn't perfect, but, experiments
show that it works better than just passing "semi-mt" data to userspace,
and making userspace try to deduce where the fingers are given a bounding box.

This patch tries to report correct two-finger positions instead of the
{(min_x, min_y), (max_x, max_y)} for profile sensor clickpads on Cr-48
chromebooks. Note that this device's firmware always reports the higher
(smaller y) finger in the "sgm" packet, and the lower (larger y) finger in the
"agm" packet. Thus, when a new finger arrives on the pad, the kernel driver
uses a simple Euclidean distance measure to deduce which of the two new fingers
should keep the tracking ID of the previous single finger. Similarly, when one
finger is removed, the same measure is used to determine which finger remained
on the pad.

Signed-off-by: Chung-yih Wang <cywang@chromium.org>
---
 drivers/input/mouse/synaptics.c |   93 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 93 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index c703d53..6575be5 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -45,6 +45,7 @@
 #define YMIN_NOMINAL 1408
 #define YMAX_NOMINAL 4448
 
+static bool cr48_profile_sensor;
 
 /*****************************************************************************
  *	Stuff we need even when we do not want native Synaptics support
@@ -970,6 +971,75 @@ static void synaptics_image_sensor_process(struct psmouse *psmouse,
 	priv->agm_pending = false;
 }
 
+static int synaptics_distsq(const struct input_mt_slot *slot,
+			    const struct synaptics_hw_state *hw)
+{
+	int slot_x = input_mt_get_value(slot, ABS_MT_POSITION_X);
+	int slot_y = input_mt_get_value(slot, ABS_MT_POSITION_Y);
+	int dx = hw->x - slot_x;
+	int dy = synaptics_invert_y(hw->y) - slot_y;
+	return dx * dx + dy * dy;
+}
+
+static bool synaptics_is_sgm_slot(const struct input_mt_slot *slot,
+				  const struct synaptics_hw_state *sgm,
+				  const struct synaptics_hw_state *agm)
+{
+	return (synaptics_distsq(slot, sgm) < synaptics_distsq(slot, agm));
+}
+
+static int synaptics_get_sgm_slot(const struct input_mt_slot *slots,
+				  const struct synaptics_hw_state *sgm)
+{
+	int distsq_slot0 = synaptics_distsq(&slots[0], sgm);
+	int distsq_slot1 = synaptics_distsq(&slots[1], sgm);
+	return (distsq_slot0 < distsq_slot1 ? 0 : 1);
+}
+
+static void synaptics_profile_sensor_process(struct psmouse *psmouse,
+					     struct synaptics_hw_state *sgm,
+					     int num_fingers)
+{
+	struct input_dev *dev = psmouse->dev;
+	struct synaptics_data *priv = psmouse->private;
+	struct synaptics_hw_state *agm = &priv->agm;
+	struct synaptics_mt_state mt_state;
+
+	/* Initialize using current mt_state (as updated by last agm) */
+	mt_state = agm->mt_state;
+
+	if (num_fingers >= 2) {
+		/* Get previous sgm slot if exists */
+		int sgm_slot = (mt_state.count != 0) ? mt_state.sgm : 0;
+		if (mt_state.count == 1) {
+			const struct input_mt_slot *mt = &dev->mt[sgm_slot];
+			if (!synaptics_is_sgm_slot(mt, sgm, agm))
+				sgm_slot = 1 - sgm_slot;
+		}
+		synaptics_report_slot(dev, sgm_slot, sgm);
+		synaptics_report_slot(dev, 1 - sgm_slot, agm);
+		synaptics_mt_state_set(&mt_state, num_fingers,
+				       sgm_slot, 1 - sgm_slot);
+	} else if (num_fingers == 1) {
+		int sgm_slot = (mt_state.count != 0) ? mt_state.sgm : 0;
+		if (mt_state.count >= 2)
+			sgm_slot = synaptics_get_sgm_slot(dev->mt, sgm);
+		synaptics_report_slot(dev, sgm_slot, sgm);
+		synaptics_report_slot(dev, 1 - sgm_slot, NULL);
+		synaptics_mt_state_set(&mt_state, 1, sgm_slot, -1);
+	} else {
+		synaptics_report_slot(dev, 0, NULL);
+		synaptics_report_slot(dev, 1, NULL);
+		synaptics_mt_state_set(&mt_state, 0, -1, -1);
+	}
+	/* Store updated mt_state */
+	priv->mt_state = agm->mt_state = mt_state;
+	/* Send the number of fingers reported by touchpad itself. */
+	input_mt_report_finger_count(dev, mt_state.count);
+	synaptics_report_buttons(psmouse, sgm);
+	input_sync(dev);
+}
+
 /*
  *  called for each full received packet from the touchpad
  */
@@ -1033,6 +1103,12 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 		finger_width = 0;
 	}
 
+	if (cr48_profile_sensor) {
+		synaptics_profile_sensor_process(psmouse, &hw, num_fingers);
+		return;
+	}
+
+
 	if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c))
 		synaptics_report_semi_mt_data(dev, &hw, &priv->agm,
 					      num_fingers);
@@ -1194,6 +1270,9 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 					ABS_MT_POSITION_Y);
 	}
 
+	if (cr48_profile_sensor)
+		input_set_abs_params(dev, ABS_MT_PRESSURE, 0, 255, 0, 0);
+
 	if (SYN_CAP_PALMDETECT(priv->capabilities))
 		input_set_abs_params(dev, ABS_TOOL_WIDTH, 0, 15, 0, 0);
 
@@ -1389,10 +1468,24 @@ static const struct dmi_system_id __initconst olpc_dmi_table[] = {
 	{ }
 };
 
+static const struct dmi_system_id __initconst cr48_dmi_table[] = {
+#if defined(CONFIG_DMI) && defined(CONFIG_X86)
+	{
+		/* Cr-48 Chromebook (Codename Mario) */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IEC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Mario"),
+		},
+	},
+#endif
+	{ }
+};
+
 void __init synaptics_module_init(void)
 {
 	impaired_toshiba_kbc = dmi_check_system(toshiba_dmi_table);
 	broken_olpc_ec = dmi_check_system(olpc_dmi_table);
+	cr48_profile_sensor = dmi_check_system(cr48_dmi_table);
 }
 
 static int __synaptics_init(struct psmouse *psmouse, bool absolute_mode)
-- 
1.7.7.3

