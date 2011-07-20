Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab1GTNj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:39:58 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37566 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab1GTNjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:39:24 -0400
From: djkurtz@chromium.org
To: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        chase.douglas@canonical.com, rubini@cvml.unipv.it
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org, Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 7/9 v2] Input: synaptics - improved 2->3 finger transition handling
Date: Wed, 20 Jul 2011 21:39:04 +0800
Message-Id: <1311169146-20066-8-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1311169146-20066-1-git-send-email-djkurtz@chromium.org>
References: <1311169146-20066-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Kurtz <djkurtz@chromium.org>

As long as we know which slots are currently contained in SGM and AGM
packets, it is possible to track the slot 0 finger when transitioning from
2->3 fingers.  This is the case when fingers are being added one at a
time, 1->2->3.

However, when fingers are removed, we sometimes lose track of which slots
are contained in SGM and AGM. In particular, when transitioning from 3->2
and sometimes 3->1.  In both of these cases, we can no longer track slot 0
during 2->3 transitions.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/mouse/synaptics.c |   33 +++++++++++++++++++++++++++------
 drivers/input/mouse/synaptics.h |    1 +
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index b626b98..893e567 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -659,6 +659,7 @@ static void synaptics_image_sensor_0f(struct synaptics_data *priv,
 				      struct synaptics_mt_state *mt_state)
 {
 	synaptics_mt_state_set(mt_state, 0, -1, -1);
+	priv->mt_state_lost = false;
 }
 
 /* Handle case where mt_state->count = 1 */
@@ -726,6 +727,7 @@ static void synaptics_image_sensor_1f(struct synaptics_data *priv,
 		 * So, empty all slots. We will guess slot 0 on subsequent 1->1
 		 */
 		synaptics_mt_state_set(mt_state, 0, -1, -1);
+		priv->mt_state_lost = true;
 		break;
 	}
 }
@@ -771,6 +773,7 @@ static void synaptics_image_sensor_2f(struct synaptics_data *priv,
 		 * subsequent 2->2
 		 */
 		synaptics_mt_state_set(mt_state, 0, -1, -1);
+		priv->mt_state_lost = true;
 		break;
 	}
 }
@@ -800,14 +803,32 @@ static void synaptics_image_sensor_3f(struct synaptics_data *priv,
 		break;
 	case 2:
 		/*
-		 * On 2->3 transitions, we are given no indication which finger
-		 * was added.
-		 * We don't even know what finger the current AGM packet
-		 * contained.
+		 * After some 3->1 and all 3->2 transitions, we lose track
+		 * of which slot is reported by sgm and agm.
 		 *
-		 * So, empty all slots. They get filled on a subsequent 3->3
+		 * For 2->3 in this state, empty all slots, and we will guess
+		 * (0,1) on a subsequent 0->3.
+		 *
+		 * To userspace, the resulting transition will look like:
+		 *    2:[0,1] -> 0:[-1,-1] -> 3:[0,2]
 		 */
-		synaptics_mt_state_set(mt_state, 0, -1, -1);
+		if (priv->mt_state_lost) {
+			synaptics_mt_state_set(mt_state, 0, -1, -1);
+			break;
+		}
+
+		/*
+		 * If the (SGM,AGM) really previously contained slots (0, 1),
+		 * then we cannot know what slot was just reported by the AGM,
+		 * because the 2->3 transition can occur either before or after
+		 * the AGM packet. Thus, this most recent AGM could contain
+		 * either the same old slot 1 or the new slot 2.
+		 * Subsequent AGMs will be reporting slot 2.
+		 *
+		 * To userspace, the resulting transition will look like:
+		 *    2:[0,1] -> 1:[0,-1] -> 3:[0,2]
+		 */
+		synaptics_mt_state_set(mt_state, 1, 0, -1);
 		break;
 	case 3:
 		/*
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index 87be1fe..e3edfea 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -162,6 +162,7 @@ struct synaptics_data {
 	struct serio *pt_port;			/* Pass-through serio port */
 
 	struct synaptics_mt_state mt_state;	/* Current mt finger state */
+	bool mt_state_lost;			/* mt_state may be incorrect */
 
 	/*
 	 * Last received Advanced Gesture Mode (AGM) packet. An AGM packet
-- 
1.7.3.1

