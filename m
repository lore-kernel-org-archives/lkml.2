Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1F2FIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 01:08:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32789 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1F2FIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 01:08:04 -0400
From: djkurtz@chromium.org
To: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        chase.douglas@canonical.com, rubini@cvml.unipv.it
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org, Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 07/12] Input: synaptics - rename synaptics_data.mt to agm
Date: Wed, 29 Jun 2011 13:07:17 +0800
Message-Id: <1309324042-22943-8-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Kurtz <djkurtz@chromium.org>

Rename the synaptics_data.mt field to priv->agm to indicate it is the
hardware state reported in a synaptics AGM packet.

When a Synaptics touchpad is in "AGM" mode, and multiple fingers are
detected, the touchpad sends alternating "Advanced Gesture Mode" (AGM) and
"Simple Gesture Mode" (SGM) packets.
  The AGM packets have w=2, and contain reduced resolution finger data.
  The SGM packets have w={0,1} and contain full resolution finger data.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/mouse/synaptics.c |    9 +++++----
 drivers/input/mouse/synaptics.h |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index dc54675..4e5e454 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -436,10 +436,10 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
 
 		if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) && hw->w == 2) {
 			/* Gesture packet: (x, y, z) at half resolution */
-			priv->mt.x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
-			priv->mt.y = INVERT_Y((((buf[4] & 0xf0) << 4)
+			priv->agm.x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
+			priv->agm.y = INVERT_Y((((buf[4] & 0xf0) << 4)
 					      | buf[2]) << 1);
-			priv->mt.z = ((buf[3] & 0x30) | (buf[5] & 0x0f)) << 1;
+			priv->agm.z = ((buf[3] & 0x30) | (buf[5] & 0x0f)) << 1;
 			return 1;
 		} else {
 			hw->x = (((buf[3] & 0x10) << 8) |
@@ -576,7 +576,8 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	}
 
 	if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c))
-		synaptics_report_semi_mt_data(dev, &hw, &priv->mt, num_fingers);
+		synaptics_report_semi_mt_data(dev, &hw, &priv->agm,
+					      num_fingers);
 
 	/* Post events
 	 * BTN_TOUCH has to be first as mousedev relies on it when doing
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index 8a68e66..e367239 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -147,7 +147,7 @@ struct synaptics_data {
 
 	struct serio *pt_port;			/* Pass-through serio port */
 
-	struct synaptics_hw_state mt;		/* current gesture packet */
+	struct synaptics_hw_state agm;		/* last AGM packet */
 };
 
 void synaptics_module_init(void);
-- 
1.7.3.1

