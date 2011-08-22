Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab1HVLHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 07:07:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60658 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab1HVLGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 07:06:15 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: chase.douglas@canonical.com, dmitry.torokhov@gmail.com,
        rydberg@euromail.se
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 9/9 v5] Input: synaptics - process finger (<=5) transitions
Date: Mon, 22 Aug 2011 19:06:03 +0800
Message-Id: <1314011163-19098-10-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1314011163-19098-1-git-send-email-djkurtz@chromium.org>
References: <1314011163-19098-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Synaptics image sensor touchpads track up to 5 fingers, but only report 2.
They use a special "TYPE=2" (AGM-CONTACT) packet type that reports
the number of tracked fingers and which finger is reported in the SGM
and AGM packets.

With this new packet type, it is possible to tell userspace when 4 or 5
fingers are touching.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Acked-by: Chase Douglas <chase.douglas@canonical.com>
---
 drivers/input/mouse/synaptics.c |   45 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index a5bc469..01d7db3 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -762,6 +762,10 @@ static void synaptics_image_sensor_1f(struct synaptics_data *priv,
 		synaptics_mt_state_set(mt_state, 1, -1, -1);
 		priv->mt_state_lost = true;
 		break;
+	case 4:
+	case 5:
+		/* mt_state was updated by AGM-CONTACT packet */
+		break;
 	}
 }
 
@@ -816,6 +820,10 @@ static void synaptics_image_sensor_2f(struct synaptics_data *priv,
 		synaptics_mt_state_set(mt_state, 2, -1, -1);
 		priv->mt_state_lost = true;
 		break;
+	case 4:
+	case 5:
+		/* mt_state was updated by AGM-CONTACT packet */
+		break;
 	}
 }
 
@@ -844,6 +852,22 @@ static void synaptics_image_sensor_3f(struct synaptics_data *priv,
 		break;
 	case 2:
 		/*
+		 * If the AGM previously contained slot 3 or higher, then the
+		 * newly touching finger is in the lowest available slot.
+		 *
+		 * If SGM was previously 1 or higher, then the new SGM is
+		 * now slot 0 (with a new finger), otherwise, the new finger
+		 * is now in a hidden slot between 0 and AGM's slot.
+		 *
+		 * In all such cases, the SGM now contains slot 0, and the AGM
+		 * continues to contain the same slot as before.
+		 */
+		if (old->agm >= 3) {
+			synaptics_mt_state_set(mt_state, 3, 0, old->agm);
+			break;
+		}
+
+		/*
 		 * After some 3->1 and all 3->2 transitions, we lose track
 		 * of which slot is reported by SGM and AGM.
 		 *
@@ -883,9 +907,22 @@ static void synaptics_image_sensor_3f(struct synaptics_data *priv,
 		 * received AGM-CONTACT packet.
 		 */
 		break;
+
+	case 4:
+	case 5:
+		/* mt_state was updated by AGM-CONTACT packet */
+		break;
 	}
 }
 
+/* Handle case where mt_state->count = 4, or = 5 */
+static void synaptics_image_sensor_45f(struct synaptics_data *priv,
+				       struct synaptics_mt_state *mt_state)
+{
+	/* mt_state was updated correctly by AGM-CONTACT packet */
+	priv->mt_state_lost = false;
+}
+
 static void synaptics_image_sensor_process(struct psmouse *psmouse,
 					   struct synaptics_hw_state *sgm)
 {
@@ -905,8 +942,10 @@ static void synaptics_image_sensor_process(struct psmouse *psmouse,
 		synaptics_image_sensor_1f(priv, &mt_state);
 	else if (sgm->w == 0)
 		synaptics_image_sensor_2f(priv, &mt_state);
-	else if (sgm->w == 1)
+	else if (sgm->w == 1 && mt_state.count <= 3)
 		synaptics_image_sensor_3f(priv, &mt_state);
+	else
+		synaptics_image_sensor_45f(priv, &mt_state);
 
 	/* Send resulting input events to user space */
 	synaptics_report_mt_data(psmouse, &mt_state, sgm);
@@ -1110,6 +1149,10 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 					ABS_MT_POSITION_Y);
 		/* Image sensors can report per-contact pressure */
 		input_set_abs_params(dev, ABS_MT_PRESSURE, 0, 255, 0, 0);
+
+		/* Image sensors can signal 4 and 5 finger clicks */
+		__set_bit(BTN_TOOL_QUADTAP, dev->keybit);
+		__set_bit(BTN_TOOL_QUINTTAP, dev->keybit);
 	} else if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)) {
 		/* Non-image sensors with AGM use semi-mt */
 		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
-- 
1.7.3.1

