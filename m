Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab1F2FJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 01:09:24 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60271 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1F2FID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 01:08:03 -0400
From: djkurtz@chromium.org
To: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        chase.douglas@canonical.com, rubini@cvml.unipv.it
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org, Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 12/12] Input: synaptics - process finger (<=5) transitions
Date: Wed, 29 Jun 2011 13:07:22 +0800
Message-Id: <1309324042-22943-13-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Kurtz <djkurtz@chromium.org>

T5R2 touchpads track up to 5 fingers, but only report 2.
They introduce a special "TYPE=2" (AGM-CONTACT) packet type that reports
the number of tracked fingers and which finger is reported in the SGM
and AGM packets.

With this new packet type, it is possible to send up to 5 MTB slots to
userspace.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/mouse/synaptics.c |   33 +++++++++++++++++++++++++++++++--
 1 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 8b38e08..5f227be 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -647,11 +647,16 @@ static void synaptics_process_hw_state(struct synaptics_data *priv,
 		new_num_fingers = 1;
 	else if (sgm->w == 0)
 		new_num_fingers = 2;
-	else if (sgm->w == 1)
-		new_num_fingers = 3;
+	else if (sgm->w == 1) {
+		if (agm->finger_count > 3)
+			new_num_fingers = agm->finger_count;
+		else
+			new_num_fingers = 3;
+	}
 
 	if (new_num_fingers == 0) {
 		synaptics_update_slots(priv, 0, 0, 0);
+		synaptics_agm_finger_update(priv, 0, 0, 0);
 		goto process_mt_data_done;
 	}
 
@@ -661,6 +666,7 @@ static void synaptics_process_hw_state(struct synaptics_data *priv,
 	 */
 	if (priv->agm_pending && agm->z == 0) {
 		synaptics_update_slots(priv, 1, 0, 0);
+		synaptics_agm_finger_update(priv, 0, 0, 0);
 		goto process_mt_data_done;
 	}
 
@@ -720,6 +726,11 @@ static void synaptics_process_hw_state(struct synaptics_data *priv,
 			 */
 			synaptics_update_slots(priv, 0, 0, 0);
 			break;
+
+		case 4:
+		case 5:
+			synaptics_update_slots(priv, 1, agm->finger_sgm, 0);
+			break;
 		}
 		break;
 
@@ -761,6 +772,12 @@ static void synaptics_process_hw_state(struct synaptics_data *priv,
 			 */
 			synaptics_update_slots(priv, 0, 0, 0);
 			break;
+
+		case 4:
+		case 5:
+			synaptics_update_slots(priv, 2, agm->finger_sgm,
+					       agm->finger_agm);
+			break;
 		}
 		break;
 
@@ -800,8 +817,20 @@ static void synaptics_process_hw_state(struct synaptics_data *priv,
 				slot_agm = slot_sgm + 2;
 			synaptics_update_slots(priv, 3, slot_sgm, slot_agm);
 			break;
+
+		case 4:
+		case 5:
+			synaptics_update_slots(priv, 3, agm->finger_sgm,
+					       agm->finger_agm);
+			break;
 		}
 		break;
+
+	case 4:
+	case 5:
+		synaptics_update_slots(priv, agm->finger_count, agm->finger_sgm,
+				       agm->finger_agm);
+		break;
 	}
 
 process_mt_data_done:
-- 
1.7.3.1

