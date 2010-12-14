Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207Ab0LNVWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:22:36 -0500
Received: from adelie.canonical.com ([91.189.90.139]:32873 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760165Ab0LNVWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:22:33 -0500
From: Chase Douglas <chase.douglas@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Input: synaptics - Add support for ABS_RECT_*
Date: Tue, 14 Dec 2010 13:21:12 -0800
Message-Id: <1292361672-2581-5-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292361672-2581-1-git-send-email-chase.douglas@canonical.com>
References: <1292361672-2581-1-git-send-email-chase.douglas@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for partial multitouch support through the ABS_RECT_* evdev
codes.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 drivers/input/mouse/synaptics.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 2e300a4..7cebdce 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -525,6 +525,13 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	}
 	input_report_abs(dev, ABS_PRESSURE, hw.z);
 
+	if (priv->multitouch && num_fingers >= 2) {
+		input_report_abs(dev, ABS_RECT_MIN_X, min(hw.x, priv->mt.x));
+		input_report_abs(dev, ABS_RECT_MAX_X, max(hw.x, priv->mt.x));
+		input_report_abs(dev, ABS_RECT_MIN_Y, min(hw.y, priv->mt.y));
+		input_report_abs(dev, ABS_RECT_MAX_Y, max(hw.y, priv->mt.y));
+	}
+
 	if (SYN_CAP_PALMDETECT(priv->capabilities))
 		input_report_abs(dev, ABS_TOOL_WIDTH, finger_width);
 
@@ -667,6 +674,17 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 		__clear_bit(BTN_RIGHT, dev->keybit);
 		__clear_bit(BTN_MIDDLE, dev->keybit);
 	}
+
+	if (priv->multitouch) {
+		input_set_abs_params(dev, ABS_RECT_MIN_X, XMIN_NOMINAL,
+				     priv->x_max ?: XMAX_NOMINAL, 0, 0);
+		input_set_abs_params(dev, ABS_RECT_MAX_X, XMIN_NOMINAL,
+				     priv->x_max ?: XMAX_NOMINAL, 0, 0);
+		input_set_abs_params(dev, ABS_RECT_MIN_Y, YMIN_NOMINAL,
+				     priv->y_max ?: YMAX_NOMINAL, 0, 0);
+		input_set_abs_params(dev, ABS_RECT_MAX_Y, YMIN_NOMINAL,
+				     priv->y_max ?: YMAX_NOMINAL, 0, 0);
+	}
 }
 
 static void synaptics_disconnect(struct psmouse *psmouse)
-- 
1.7.1

