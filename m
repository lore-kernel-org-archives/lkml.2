Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab1HRL2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 07:28:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28262 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab1HRL2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 07:28:17 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: chase.douglas@canonical.com, dmitry.torokhov@gmail.com,
        rydberg@euromail.se
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 1/9 v4] Input: synaptics - refactor y inversion
Date: Thu, 18 Aug 2011 19:28:00 +0800
Message-Id: <1313666888-18939-2-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313666888-18939-1-git-send-email-djkurtz@chromium.org>
References: <1313666888-18939-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Synaptics touchpads report increasing y from bottom to top.
This is inverted from normal userspace "top of screen is 0" coordinates.
Thus, the kernel driver reports inverted y coordinates to userspace.

This patch refactors this inversion.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Acked-by: Chase Douglas <chase.douglas@canonical.com>
---
 drivers/input/mouse/synaptics.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 5538fc6..297e88f 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -44,6 +44,16 @@
 #define YMIN_NOMINAL 1408
 #define YMAX_NOMINAL 4448
 
+/*
+ * Synaptics touchpads report the y coordinate from bottom to top, which is
+ * opposite from what userspace expects.
+ * This function is used to invert y before reporting.
+ */
+static int invert_y(int y)
+{
+	return YMAX_NOMINAL + YMIN_NOMINAL - y;
+}
+
 
 /*****************************************************************************
  *	Stuff we need even when we do not want native Synaptics support
@@ -502,8 +512,7 @@ static void synaptics_report_semi_mt_slot(struct input_dev *dev, int slot,
 	input_mt_report_slot_state(dev, MT_TOOL_FINGER, active);
 	if (active) {
 		input_report_abs(dev, ABS_MT_POSITION_X, x);
-		input_report_abs(dev, ABS_MT_POSITION_Y,
-				 YMAX_NOMINAL + YMIN_NOMINAL - y);
+		input_report_abs(dev, ABS_MT_POSITION_Y, invert_y(y));
 	}
 }
 
@@ -597,7 +606,7 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 
 	if (num_fingers > 0) {
 		input_report_abs(dev, ABS_X, hw.x);
-		input_report_abs(dev, ABS_Y, YMAX_NOMINAL + YMIN_NOMINAL - hw.y);
+		input_report_abs(dev, ABS_Y, invert_y(hw.y));
 	}
 	input_report_abs(dev, ABS_PRESSURE, hw.z);
 
-- 
1.7.3.1

