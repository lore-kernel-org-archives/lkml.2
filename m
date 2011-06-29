Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab1F2FIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 01:08:18 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60240 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1F2FH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 01:07:58 -0400
From: djkurtz@chromium.org
To: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        chase.douglas@canonical.com, rubini@cvml.unipv.it
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org, Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 02/12] Input: synaptics - do not invert y if 0
Date: Wed, 29 Jun 2011 13:07:12 +0800
Message-Id: <1309324042-22943-3-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Kurtz <djkurtz@chromium.org>

Synaptics touchpads report increasing y from bottom to top.
This is inverted from normal userspace "top of screen is 0" coordinates.
Thus, the kernel driver reports inverted y coordinates to userspace.

In some cases, however, y = 0 is sent by the touchpad.
In these cases, the kernel driver should not invert, and just report 0.

This patch also refactors the inversion into a macro, and moves it
into packet processing instead of during position reporting.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/mouse/synaptics.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index e06e045..f6d0c04 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -44,6 +44,8 @@
 #define YMIN_NOMINAL 1408
 #define YMAX_NOMINAL 4448
 
+#define INVERT_Y(y) (((y) != 0) ? (YMAX_NOMINAL + YMIN_NOMINAL - (y)) : 0)
+
 
 /*****************************************************************************
  *	Stuff we need even when we do not want native Synaptics support
@@ -409,9 +411,9 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
 		hw->x = (((buf[3] & 0x10) << 8) |
 			 ((buf[1] & 0x0f) << 8) |
 			 buf[4]);
-		hw->y = (((buf[3] & 0x20) << 7) |
+		hw->y = INVERT_Y((((buf[3] & 0x20) << 7) |
 			 ((buf[1] & 0xf0) << 4) |
-			 buf[5]);
+			 buf[5]));
 
 		hw->z = buf[2];
 		hw->w = (((buf[0] & 0x30) >> 2) |
@@ -421,7 +423,8 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
 		if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) && hw->w == 2) {
 			/* Gesture packet: (x, y, z) at half resolution */
 			priv->mt.x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
-			priv->mt.y = (((buf[4] & 0xf0) << 4) | buf[2]) << 1;
+			priv->mt.y = INVERT_Y((((buf[4] & 0xf0) << 4)
+					      | buf[2]) << 1);
 			priv->mt.z = ((buf[3] & 0x30) | (buf[5] & 0x0f)) << 1;
 			return 1;
 		}
@@ -473,7 +476,7 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
 		}
 	} else {
 		hw->x = (((buf[1] & 0x1f) << 8) | buf[2]);
-		hw->y = (((buf[4] & 0x1f) << 8) | buf[5]);
+		hw->y = INVERT_Y(((buf[4] & 0x1f) << 8) | buf[5]);
 
 		hw->z = (((buf[0] & 0x30) << 2) | (buf[3] & 0x3F));
 		hw->w = (((buf[1] & 0x80) >> 4) | ((buf[0] & 0x04) >> 1));
@@ -491,8 +494,7 @@ static void set_slot(struct input_dev *dev, int slot, bool active, int x, int y)
 	input_mt_report_slot_state(dev, MT_TOOL_FINGER, active);
 	if (active) {
 		input_report_abs(dev, ABS_MT_POSITION_X, x);
-		input_report_abs(dev, ABS_MT_POSITION_Y,
-				 YMAX_NOMINAL + YMIN_NOMINAL - y);
+		input_report_abs(dev, ABS_MT_POSITION_Y, y);
 	}
 }
 
@@ -584,7 +586,7 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 
 	if (num_fingers > 0) {
 		input_report_abs(dev, ABS_X, hw.x);
-		input_report_abs(dev, ABS_Y, YMAX_NOMINAL + YMIN_NOMINAL - hw.y);
+		input_report_abs(dev, ABS_Y, hw.y);
 	}
 	input_report_abs(dev, ABS_PRESSURE, hw.z);
 
-- 
1.7.3.1

