Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab1HLRRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:17:04 -0400
Received: from smtp-out.google.com ([74.125.121.67]:52333 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab1HLRRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:17:00 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: chase.douglas@canonical.com, dmitry.torokhov@gmail.com,
        rydberg@euromail.se
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 5/8 v3] Input: synaptics - decode AGM packet types
Date: Sat, 13 Aug 2011 01:16:44 +0800
Message-Id: <1313169407-4358-6-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313169407-4358-1-git-send-email-djkurtz@chromium.org>
References: <1313169407-4358-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Synaptics image sensor tracks 5 fingers, but can only report 2.

The algorithm for choosing which 2 fingers to report and in which packet:
  Touchpad maintains 5 slots, numbered 0 to 4
  Initially all slots are empty
  As new fingers are detected, assign them to the lowest available slots
  The touchpad always reports:
    SGM: lowest numbered non-empty slot
    AGM: highest numbered non-empty slot, if there is one

In addition, these touchpads have a special AGM packet type which reports
the number of fingers currently being tracked, and which finger is in
each of the two slots.  Unfortunately, these "TYPE=2" packets are only used
when more than 3 fingers are being tracked.  When less than 4 fingers
are present, the 'w' value must be used to track how many fingers are
present, and knowing which fingers are being reported is much more
difficult, if not impossible.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/mouse/synaptics.c |   38 +++++++++++++++++++++++++++++++-------
 drivers/input/mouse/synaptics.h |   14 +++++++++++++-
 2 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index a9960d2..ff8c839 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -420,15 +420,39 @@ static void synaptics_pt_create(struct psmouse *psmouse)
  *	Functions to interpret the absolute mode packets
  ****************************************************************************/
 
+static void synaptics_mt_state_set(struct synaptics_mt_state *state, int count,
+				   int sgm, int agm)
+{
+	state->count = count;
+	state->sgm = sgm;
+	state->agm = agm;
+}
+
 static void synaptics_parse_agm(const unsigned char buf[],
-				struct synaptics_data *priv)
+				struct synaptics_data *priv,
+				struct synaptics_hw_state *hw)
 {
 	struct synaptics_hw_state *agm = &priv->agm;
+	int agm_packet_type;
+
+	agm_packet_type = (buf[5] & 0x30) >> 4;
+	switch (agm_packet_type) {
+	case 1:
+		/* Gesture packet: (x, y, z) half resolution */
+		agm->w = hw->w;
+		agm->x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
+		agm->y = (((buf[4] & 0xf0) << 4) | buf[2]) << 1;
+		agm->z = ((buf[3] & 0x30) | (buf[5] & 0x0f)) << 1;
+		break;
 
-	/* Gesture packet: (x, y, z) at half resolution */
-	agm->x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
-	agm->y = (((buf[4] & 0xf0) << 4) | buf[2]) << 1;
-	agm->z = ((buf[3] & 0x30) | (buf[5] & 0x0f)) << 1;
+	case 2:
+		/* AGM-CONTACT packet: (count, sgm, agm) */
+		synaptics_mt_state_set(&agm->mt_state, buf[1], buf[2], buf[4]);
+		break;
+
+	default:
+		break;
+	}
 }
 
 static int synaptics_parse_hw_state(const unsigned char buf[],
@@ -467,7 +491,7 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
 		if ((SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)
 				|| SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c))
 				&& hw->w == 2) {
-			synaptics_parse_agm(buf, priv);
+			synaptics_parse_agm(buf, priv, hw);
 			return 1;
 		}
 
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index 0ea7616..20f57df 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -115,9 +115,18 @@
 #define SYN_REDUCED_FILTER_FUZZ		8
 
 /*
- * A structure to describe the state of the touchpad hardware (buttons and pad)
+ * A structure to describe which internal touchpad finger slots are being
+ * reported in raw packets.
  */
+struct synaptics_mt_state {
+	int count;			/* num fingers being tracked */
+	int sgm;			/* which slot is reported by sgm pkt */
+	int agm;			/* which slot is reported by agm pkt*/
+};
 
+/*
+ * A structure to describe the state of the touchpad hardware (buttons and pad)
+ */
 struct synaptics_hw_state {
 	int x;
 	int y;
@@ -130,6 +139,9 @@ struct synaptics_hw_state {
 	unsigned int down:1;
 	unsigned char ext_buttons;
 	signed char scroll;
+
+	/* As reported in last AGM-CONTACT packets */
+	struct synaptics_mt_state mt_state;
 };
 
 struct synaptics_data {
-- 
1.7.3.1

