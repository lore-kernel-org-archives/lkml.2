Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab1HVLGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 07:06:36 -0400
Received: from smtp-out.google.com ([74.125.121.67]:11299 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab1HVLGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 07:06:13 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: chase.douglas@canonical.com, dmitry.torokhov@gmail.com,
        rydberg@euromail.se
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 2/9 v5] Input: synaptics - refactor agm packet parsing
Date: Mon, 22 Aug 2011 19:05:56 +0800
Message-Id: <1314011163-19098-3-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1314011163-19098-1-git-send-email-djkurtz@chromium.org>
References: <1314011163-19098-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a Synaptics touchpad is in "AGM" mode, and multiple fingers are
detected, the touchpad sends alternating "Advanced Gesture Mode" (AGM) and
"Simple Gesture Mode" (SGM) packets.
  The AGM packets have w=2, and contain reduced resolution finger data.
  The SGM packets have w={0,1} and contain full resolution finger data.

Refactor the parsing of agm packets to its own function, and rename the
synaptics_data.mt field to .agm to indicate that it contains the contents of
the last agm packet.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Acked-by: Chase Douglas <chase.douglas@canonical.com>
---
 drivers/input/mouse/synaptics.c |   19 ++++++++++++++-----
 drivers/input/mouse/synaptics.h |    6 +++++-
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 297e88f..e966894 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -419,6 +419,17 @@ static void synaptics_pt_create(struct psmouse *psmouse)
  *	Functions to interpret the absolute mode packets
  ****************************************************************************/
 
+static void synaptics_parse_agm(const unsigned char buf[],
+				struct synaptics_data *priv)
+{
+	struct synaptics_hw_state *agm = &priv->agm;
+
+	/* Gesture packet: (x, y, z) at half resolution */
+	agm->x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
+	agm->y = (((buf[4] & 0xf0) << 4) | buf[2]) << 1;
+	agm->z = ((buf[3] & 0x30) | (buf[5] & 0x0f)) << 1;
+}
+
 static int synaptics_parse_hw_state(const unsigned char buf[],
 				    struct synaptics_data *priv,
 				    struct synaptics_hw_state *hw)
@@ -453,10 +464,7 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
 		}
 
 		if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) && hw->w == 2) {
-			/* Gesture packet: (x, y, z) at half resolution */
-			priv->mt.x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
-			priv->mt.y = (((buf[4] & 0xf0) << 4) | buf[2]) << 1;
-			priv->mt.z = ((buf[3] & 0x30) | (buf[5] & 0x0f)) << 1;
+			synaptics_parse_agm(buf, priv);
 			return 1;
 		}
 
@@ -595,7 +603,8 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	}
 
 	if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c))
-		synaptics_report_semi_mt_data(dev, &hw, &priv->mt, num_fingers);
+		synaptics_report_semi_mt_data(dev, &hw, &priv->agm,
+					      num_fingers);
 
 	/* Post events
 	 * BTN_TOUCH has to be first as mousedev relies on it when doing
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index ca040aa..a9efbf3 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -146,7 +146,11 @@ struct synaptics_data {
 
 	struct serio *pt_port;			/* Pass-through serio port */
 
-	struct synaptics_hw_state mt;		/* current gesture packet */
+	/*
+	 * Last received Advanced Gesture Mode (AGM) packet. An AGM packet
+	 * contains position data for a second contact, at half resolution.
+	 */
+	struct synaptics_hw_state agm;
 };
 
 void synaptics_module_init(void);
-- 
1.7.3.1

