Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab1GTNjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:39:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37557 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab1GTNjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:39:23 -0400
From: djkurtz@chromium.org
To: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        chase.douglas@canonical.com, rubini@cvml.unipv.it
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org, Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 6/9 v2] Input: synaptics - process finger (<=3) transitions
Date: Wed, 20 Jul 2011 21:39:03 +0800
Message-Id: <1311169146-20066-7-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1311169146-20066-1-git-send-email-djkurtz@chromium.org>
References: <1311169146-20066-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Kurtz <djkurtz@chromium.org>

Synaptics image sensor touchpads track 5 fingers, but only report 2.

This patch attempts to deal with some idiosyncrasies of these touchpads:

 * When there are 3 or more fingers, only two are reported.
 * The number of fingers can change at any time, but is only reported in
   SGM packets, thus at a number-of-fingers change, it is not possible
   to tell whether the AGM finger is for the original or new number of
   fingers.
 * When the number of fingers changes from 2->3 it is not
   possible to tell which of the 2 fingers are now reported.
 * When number of fingers changes from 3->2 it is often not possible to
   tell which finger was removed, and which are now being reported.

When 2 or more packets are present on the touchpad, the kernel reports
exactly two MT-B slots containing the position data for the two fingers
reported by the touchpad.
In addition, it reports the total number of fingers using one of the
EV_KEY/BTN_TOOL_*TAP events.  Thus, this is a hybrid singletouch/MT-B scheme.

Userspace can detect this condition by noting that the driver supports
more EV_KEY/BTN_TOOL_*TAP events than its maximum EV_ABS/ABS_MT_SLOT.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/mouse/synaptics.c |  229 ++++++++++++++++++++++++++++++++++++---
 drivers/input/mouse/synaptics.h |    3 +
 2 files changed, 216 insertions(+), 16 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index ff8c839..b626b98 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -453,6 +453,9 @@ static void synaptics_parse_agm(const unsigned char buf[],
 	default:
 		break;
 	}
+
+	/* Record that at least one AGM has been received since last SGM */
+	priv->agm_pending = true;
 }
 
 static int synaptics_parse_hw_state(const unsigned char buf[],
@@ -600,26 +603,44 @@ static void synaptics_report_slot_agm(struct input_dev *dev, int slot,
 }
 
 static void synaptics_report_mt(struct psmouse *psmouse,
-				int count,
+				struct synaptics_mt_state *mt_state,
 				const struct synaptics_hw_state *sgm)
 {
 	struct input_dev *dev = psmouse->dev;
 	struct synaptics_data *priv = psmouse->private;
 	struct synaptics_hw_state *agm = &priv->agm;
+	struct synaptics_mt_state *old = &priv->mt_state;
 
-	switch (count) {
+	switch (mt_state->count) {
 	case 0:
 		synaptics_report_slot_empty(dev, 0);
 		synaptics_report_slot_empty(dev, 1);
 		break;
 	case 1:
-		synaptics_report_slot_sgm(dev, 0, sgm);
-		synaptics_report_slot_empty(dev, 1);
+		if (mt_state->sgm == 0) {
+			synaptics_report_slot_sgm(dev, 0, sgm);
+			synaptics_report_slot_empty(dev, 1);
+		} else {
+			synaptics_report_slot_empty(dev, 0);
+			synaptics_report_slot_sgm(dev, 1, sgm);
+		}
 		break;
-	case 2:
-	case 3: /* Fall-through case */
-		synaptics_report_slot_sgm(dev, 0, sgm);
-		synaptics_report_slot_agm(dev, 1, agm);
+	default:
+		/*
+		 * For all other finger counts, report sgm in 0 and agm in 1,
+		 * but only if the sgm/agm is reporting the same finger.
+		 * If either reported finger has changed, invalidate its slot's
+		 * old tracking id, instead.
+		 */
+		if ((old->sgm == -1) || (old->sgm == mt_state->sgm))
+			synaptics_report_slot_sgm(dev, 0, sgm);
+		else
+			synaptics_report_slot_empty(dev, 0);
+
+		if ((old->agm == -1) || (old->agm == mt_state->agm))
+			synaptics_report_slot_agm(dev, 1, agm);
+		else
+			synaptics_report_slot_empty(dev, 1);
 		break;
 	}
 
@@ -627,28 +648,204 @@ static void synaptics_report_mt(struct psmouse *psmouse,
 	input_mt_report_pointer_emulation(dev, false);
 
 	/* Send the number of fingers reported by touchpad itself. */
-	input_mt_report_finger_count(dev, count);
+	input_mt_report_finger_count(dev, mt_state->count);
 
 	input_report_key(dev, BTN_LEFT, sgm->left);
 	input_sync(dev);
 }
 
+/* Handle case where mt_state->count = 0 */
+static void synaptics_image_sensor_0f(struct synaptics_data *priv,
+				      struct synaptics_mt_state *mt_state)
+{
+	synaptics_mt_state_set(mt_state, 0, -1, -1);
+}
+
+/* Handle case where mt_state->count = 1 */
+static void synaptics_image_sensor_1f(struct synaptics_data *priv,
+				      struct synaptics_mt_state *mt_state)
+{
+	struct synaptics_hw_state *agm = &priv->agm;
+	struct synaptics_mt_state *old = &priv->mt_state;
+
+	/*
+	 * If the last AGM was (0,0,0), and there is only one finger left,
+	 * then SGM contains slot 0, and all other fingers have been removed.
+	 */
+	if (priv->agm_pending && agm->z == 0) {
+		synaptics_mt_state_set(mt_state, 1, 0, -1);
+		return;
+	}
+
+	switch (old->count) {
+	case 0:
+		synaptics_mt_state_set(mt_state, 1, 0, -1);
+		break;
+	case 1:
+		/*
+		 * If pending AGM and either:
+		 *   (a) the previous SGM slot contains slot 0, or
+		 *   (b) there was no SGM slot
+		 * then SGM now contains slot 1
+		 *
+		 *  (a) The "SGM contains slot 0" case happens with very rapid
+		 * "drum roll" gestures, where slot 0 finger is lifted and a
+		 * new slot 1 finger touches within one reporting interval.
+		 *
+		 *  (b) The "no SGM slot" case happens if initially two or more
+		 * fingers tap briefly, and all but one lift before the end of
+		 * the first reporting interval.
+		 *
+		 * (In both these cases, slot 0 will become empty, and SGM
+		 * contains a new finger in slot 1)
+		 *
+		 * Else, if there was no previous SGM, it now contains slot 0.
+		 *
+		 * Otherwise, SGM still contains the same slot.
+		 */
+
+		if (priv->agm_pending && old->sgm <= 0)
+			synaptics_mt_state_set(mt_state, 1, 1, -1);
+		else if (old->sgm == -1)
+			synaptics_mt_state_set(mt_state, 1, 0, -1);
+		break;
+	case 2:
+		/*
+		 * Since the last AGM was NOT (0,0,0), it was the finger in
+		 * slot 0 that has been removed.
+		 * So, SGM now contains previous AGM's slot, and AGM is now
+		 * empty.
+		 */
+		synaptics_mt_state_set(mt_state, 1, old->agm, -1);
+		break;
+	case 3:
+		/*
+		 * Since last AGM was not (0,0,0), we don't know which finger
+		 * is left.
+		 *
+		 * So, empty all slots. We will guess slot 0 on subsequent 1->1
+		 */
+		synaptics_mt_state_set(mt_state, 0, -1, -1);
+		break;
+	}
+}
+
+/* Handle case where mt_state->count = 2 */
+static void synaptics_image_sensor_2f(struct synaptics_data *priv,
+				      struct synaptics_mt_state *mt_state)
+{
+	struct synaptics_mt_state *old = &priv->mt_state;
+
+	switch (old->count) {
+	case 0:
+		synaptics_mt_state_set(mt_state, 2, 0, 1);
+		break;
+	case 1:
+		/*
+		 * If previous SGM contained slot 1 or higher, SGM now contains
+		 * slot 0 (the newly touching finger) and AGM contains SGM's
+		 * previous slot.
+		 *
+		 * Otherwise, SGM still contains slot 0 and AGM now contains
+		 * slot 1.
+		 */
+		if (old->sgm >= 1)
+			synaptics_mt_state_set(mt_state, 2, 0, old->sgm);
+		else
+			synaptics_mt_state_set(mt_state, 2, 0, 1);
+		break;
+	case 2:
+		/*
+		 * mt_state either hasn't changed, or was updated by a recently
+		 * received AGM-CONTACT packet.
+		 */
+		break;
+	case 3:
+		/*
+		 * 3->2 transitions have two unsolvable problems:
+		 *  1) no indication is given which finger was removed
+		 *  2) no way to tell if agm packet was for finger 3
+		 *     before 3->2, or finger 2 after 3->2.
+		 *
+		 * So, empty all slots. We will guess slots [0,1] on
+		 * subsequent 2->2
+		 */
+		synaptics_mt_state_set(mt_state, 0, -1, -1);
+		break;
+	}
+}
+
+/* Handle case where mt_state->count = 3 */
+static void synaptics_image_sensor_3f(struct synaptics_data *priv,
+				      struct synaptics_mt_state *mt_state)
+{
+	struct synaptics_mt_state *old = &priv->mt_state;
+
+	switch (old->count) {
+	case 0:
+		synaptics_mt_state_set(mt_state, 3, 0, 2);
+		break;
+	case 1:
+		/*
+		 * If previous SGM contained slot 2 or higher, SGM now contains
+		 * slot 0 (one of the newly touching fingers) and AGM contains
+		 * SGM's previous slot.
+		 *
+		 * Otherwise, SGM now contains slot 0 and AGM contains slot 2.
+		 */
+		if (old->sgm >= 2)
+			synaptics_mt_state_set(mt_state, 3, 0, old->sgm);
+		else
+			synaptics_mt_state_set(mt_state, 3, 0, 2);
+		break;
+	case 2:
+		/*
+		 * On 2->3 transitions, we are given no indication which finger
+		 * was added.
+		 * We don't even know what finger the current AGM packet
+		 * contained.
+		 *
+		 * So, empty all slots. They get filled on a subsequent 3->3
+		 */
+		synaptics_mt_state_set(mt_state, 0, -1, -1);
+		break;
+	case 3:
+		/*
+		 * mt_state either hasn't changed, or was updated by a recently
+		 * received AGM-CONTACT packet.
+		 */
+		break;
+	}
+}
+
 static void synaptics_image_sensor_process(struct psmouse *psmouse,
 					   struct synaptics_hw_state *sgm)
 {
-	int count;
+	struct synaptics_data *priv = psmouse->private;
+	struct synaptics_hw_state *agm = &priv->agm;
+	struct synaptics_mt_state mt_state;
+
+	/* Initialize using current mt_state (as updated by last agm) */
+	mt_state = agm->mt_state;
 
+	/*
+	 * Update mt_state using the new finger count and current mt_state.
+	 */
 	if (sgm->z == 0)
-		count = 0;
+		synaptics_image_sensor_0f(priv, &mt_state);
 	else if (sgm->w >= 4)
-		count = 1;
+		synaptics_image_sensor_1f(priv, &mt_state);
 	else if (sgm->w == 0)
-		count = 2;
-	else
-		count = 3;
+		synaptics_image_sensor_2f(priv, &mt_state);
+	else if (sgm->w == 1)
+		synaptics_image_sensor_3f(priv, &mt_state);
 
 	/* Send resulting input events to user space */
-	synaptics_report_mt(psmouse, count, sgm);
+	synaptics_report_mt(psmouse, &mt_state, sgm);
+
+	/* Store updated mt_state */
+	priv->mt_state = agm->mt_state = mt_state;
+	priv->agm_pending = false;
 }
 
 /*
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index 0c63357..87be1fe 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -161,11 +161,14 @@ struct synaptics_data {
 
 	struct serio *pt_port;			/* Pass-through serio port */
 
+	struct synaptics_mt_state mt_state;	/* Current mt finger state */
+
 	/*
 	 * Last received Advanced Gesture Mode (AGM) packet. An AGM packet
 	 * contains position data for a second contact, at half resolution.
 	 */
 	struct synaptics_hw_state agm;
+	bool agm_pending;			/* new AGM packet received */
 };
 
 void synaptics_module_init(void);
-- 
1.7.3.1

