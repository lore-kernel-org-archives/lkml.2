Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1F2FJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 01:09:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60290 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1F2FIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 01:08:05 -0400
From: djkurtz@chromium.org
To: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        chase.douglas@canonical.com, rubini@cvml.unipv.it
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org, Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 11/12] Input: synaptics - process finger (<=3) transitions
Date: Wed, 29 Jun 2011 13:07:21 +0800
Message-Id: <1309324042-22943-12-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Kurtz <djkurtz@chromium.org>

Synaptics T5R2 touchpads track 5 fingers, but only report 2.

This patch attempts to deal with some idiosyncrasies of the T5R2
protocol:

 * When there are 3 fingers, one finger is 'hidden', meaning its position is
   never sent to the host.
 * The number of fingers can change at any time, but is only reported in
   SGM packets, thus at a number-of-fingers change, it is not possible
   to tell whether the AGM finger is for the original or new number of
   fingers.
 * When the number of fingers changes from 2->3 it is not
   possible to tell which of the 2 fingers are now reported.
 * When number of fingers changes from 3->2 it is often not possible to
   tell which finger was removed, and which are now being reported.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/mouse/synaptics.c |  197 +++++++++++++++++++++++++++++++++++++-
 drivers/input/mouse/synaptics.h |    2 +
 2 files changed, 193 insertions(+), 6 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 19a9b7f..8b38e08 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -448,6 +448,8 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
 				&& hw->w == 2) {
 			int type; /* Packet type */
 
+			priv->agm_pending = true;
+
 			type = (buf[5] & 0x30) >> 4;
 
 			switch (type) {
@@ -573,13 +575,20 @@ static void synaptics_report_mt_slot(struct input_dev *dev, int slot, int state,
 		input_report_abs(dev, ABS_MT_POSITION_Y, agm->y);
 		input_report_abs(dev, ABS_MT_PRESSURE, agm->z);
 		break;
+	case SYN_SLOT_HIDDEN:
+		input_mt_report_slot_state(dev, MT_TOOL_FINGER, true);
+		break;
 	}
 }
 
+/*
+ * Invariant: hidden_count = (count - 2);  hidden_count < (agm - sgm)
+ */
 static void synaptics_update_slots(struct synaptics_data *priv, int count,
 				   int sgm, int agm)
 {
 	int i;
+	int hidden_count;
 
 	/* First, clear previous slots. */
 	for (i = 0; i < SYN_TRACK_SLOT_COUNT; i++)
@@ -592,12 +601,45 @@ static void synaptics_update_slots(struct synaptics_data *priv, int count,
 	if (count < 2)
 		return;
 	priv->slot[agm] = SYN_SLOT_AGM;
+
+	/* Assign hidden slots between sgm and agm */
+	hidden_count = count - 2;
+	if (hidden_count < 1)
+		return;
+	if (hidden_count >= (agm-sgm))
+		hidden_count = agm-sgm-1;
+	for (i = 0; i < hidden_count; i++)
+		priv->slot[sgm + 1 + i] = SYN_SLOT_HIDDEN;
+}
+
+static int synaptics_find_sgm(struct synaptics_data *priv)
+{
+	int i;
+
+	for (i = 0; i < SYN_TRACK_SLOT_COUNT; i++)
+		if (priv->slot[i] == SYN_SLOT_SGM)
+			return i;
+	return -ENOENT;
+}
+
+static int synaptics_find_agm(struct synaptics_data *priv)
+{
+	int i;
+
+	for (i = 1; i < SYN_TRACK_SLOT_COUNT; i++)
+		if (priv->slot[i] == SYN_SLOT_AGM)
+			return i;
+	return -ENOENT;
 }
 
 static void synaptics_process_hw_state(struct synaptics_data *priv,
 				       struct synaptics_hw_state *sgm)
 {
+	struct synaptics_hw_state *agm = &priv->agm;
+	int slot_sgm;
+	int slot_agm;
 	int new_num_fingers;
+	int old_num_fingers = priv->num_fingers;
 
 	if (sgm->z == 0)
 		new_num_fingers = 0;
@@ -608,20 +650,163 @@ static void synaptics_process_hw_state(struct synaptics_data *priv,
 	else if (sgm->w == 1)
 		new_num_fingers = 3;
 
-	switch (new_num_fingers) {
-	case 0:
+	if (new_num_fingers == 0) {
 		synaptics_update_slots(priv, 0, 0, 0);
-		break;
-	case 1:
+		goto process_mt_data_done;
+	}
+
+	/*
+	 * If the last agm was (0,0,0), then SGM is in slot[0], and all other
+	 * fingers have been removed.
+	 */
+	if (priv->agm_pending && agm->z == 0) {
 		synaptics_update_slots(priv, 1, 0, 0);
+		goto process_mt_data_done;
+	}
+
+	/*
+	 * Update slots to in response to number of fingers changing from
+	 * old_num_fingers to new_num_fingers.
+	 */
+	switch (new_num_fingers) {
+	case 1:
+		switch (old_num_fingers) {
+		case 0:
+			synaptics_update_slots(priv, 1, 0, 0);
+			break;
+		case 1:
+			/*
+			 * If received AGM and previous SGM slot was 0, or
+			 * there was no SGM slot, then switch SGM slot to 1.
+			 *
+			 * The "SGM slot = 0" case happens with very rapid
+			 * "drum roll" gestures, where slot 0 finger is lifted
+			 * and a new slot 1 finger touches within one reporting
+			 * interval.
+			 * The "no SGM slot" case happens if initially two
+			 * or more fingers tap briefly, and all but one lift
+			 * before the end of the first reporting interval.
+			 * (In these cases, slot 0 becomes empty, only
+			 * slot 1, is reported with the SGM)
+			 *
+			 * Else if there was no previous SGM, use slot 0.
+			 *
+			 * Else, reuse the current SGM slot.
+			 */
+
+			/* Determine previous SGM slot, if there was one. */
+			slot_sgm = synaptics_find_sgm(priv);
+
+			if (priv->agm_pending && slot_sgm <= 0)
+				slot_sgm = 1;
+			else if (slot_sgm < 0)
+				slot_sgm = 0;
+
+			synaptics_update_slots(priv, 1, slot_sgm, 0);
+			break;
+		case 2:
+			/*
+			 * Since last AGM was not (0,0,0),
+			 * previous AGM is now the SGM.
+			 */
+			slot_agm = synaptics_find_agm(priv);
+			synaptics_update_slots(priv, 1, slot_agm, 0);
+			break;
+		case 3:
+			/*
+			 * Since last AGM was not (0,0,0), we don't know what
+			 * finger is left. So empty all slots.
+			 * The slot gets filled on a subsequent 1->1
+			 */
+			synaptics_update_slots(priv, 0, 0, 0);
+			break;
+		}
 		break;
+
 	case 2:
-	case 3: /* Fall-through case */
-		synaptics_update_slots(priv, 2, 0, 1);
+		switch (old_num_fingers) {
+		case 0:
+			synaptics_update_slots(priv, 2, 0, 1);
+			break;
+		case 1:
+			/*
+			 * If previous slot 0 had SGM,
+			 * the new finger, slot 1, is in AGM.
+			 * Otherwise, new finger, slot 0, is in SGM.
+			 */
+			slot_sgm = synaptics_find_sgm(priv);
+			if (slot_sgm < 1)
+				slot_sgm = 1;
+			synaptics_update_slots(priv, 2, 0, slot_sgm);
+			break;
+		case 2:
+			/* Assuming no change in fingers... */
+			slot_sgm = synaptics_find_sgm(priv);
+			slot_agm = synaptics_find_agm(priv);
+			if (slot_sgm < 0)
+				slot_sgm = 0;
+			if (slot_agm < slot_sgm + 1)
+				slot_agm = slot_sgm + 1;
+			synaptics_update_slots(priv, 2, slot_sgm, slot_agm);
+			break;
+		case 3:
+			/*
+			 * 3->2 transitions have two unsolvable problems:
+			 *  1) no indication is given which finger was removed
+			 *  2) no way to tell if agm packet was for finger 3
+			 *     before 3->2, or finger 2 after 3->2.
+			 *
+			 * So, empty all slots.
+			 * The slots get filled on a subsequent 2->2
+			 */
+			synaptics_update_slots(priv, 0, 0, 0);
+			break;
+		}
+		break;
+
+	case 3:
+		switch (old_num_fingers) {
+		case 0:
+			synaptics_update_slots(priv, 3, 0, 2);
+			break;
+		case 1:
+			/*
+			 * If old SGM was slot 2 or higher, that slot is now
+			 * AGM, with one of the new fingers in slot 0 as SGM.
+			 * Otherwise, the 3 used slots are 0,1,2.
+			 */
+			slot_sgm = synaptics_find_sgm(priv);
+			if (slot_sgm < 2)
+				slot_sgm = 2;
+			synaptics_update_slots(priv, 3, 0, slot_sgm);
+			break;
+		case 2:
+			/* On 2->3 transitions, we are given no indication
+			 * which finger was added.
+			 * We don't even know what finger the current AGM packet
+			 * contained.
+			 * So, empty all slots.
+			 * The slots get filled on a subsequent 3->3
+			 */
+			synaptics_update_slots(priv, 0, 0, 0);
+			break;
+		case 3:
+			/* Assuming no change in fingers... */
+			slot_sgm = synaptics_find_sgm(priv);
+			slot_agm = synaptics_find_agm(priv);
+			if (slot_sgm < 0)
+				slot_sgm = 0;
+			if (slot_agm < slot_sgm + 2)
+				slot_agm = slot_sgm + 2;
+			synaptics_update_slots(priv, 3, slot_sgm, slot_agm);
+			break;
+		}
 		break;
 	}
 
+process_mt_data_done:
 	priv->num_fingers = new_num_fingers;
+	priv->agm_pending = false;
 }
 
 static void synaptics_report_mt_data(struct psmouse *psmouse,
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index 2214af6..cc193b6 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -120,6 +120,7 @@
 #define SYN_SLOT_EMPTY			0
 #define SYN_SLOT_SGM			1
 #define SYN_SLOT_AGM			2
+#define SYN_SLOT_HIDDEN			3
 
 /* number of tracking slots for Image Sensor firmware */
 #define SYN_TRACK_SLOT_COUNT		5
@@ -166,6 +167,7 @@ struct synaptics_data {
 	struct synaptics_hw_state agm;		/* last AGM packet */
 	int num_fingers;			/* current finger count */
 	int slot[SYN_TRACK_SLOT_COUNT];		/* finger slot state */
+	bool agm_pending;			/* new AGM packet received */
 };
 
 void synaptics_module_init(void);
-- 
1.7.3.1

