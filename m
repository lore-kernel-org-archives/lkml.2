Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555Ab0JHO6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:58:11 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60445 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758355Ab0JHO6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:58:08 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: linux-input@vger.kernel.org, xorg-devel@lists.x.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Andy Whitcroft <apw@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Duncan McGreggor <duncan.mcgreggor@canonical.com>
Subject: [PATCH 2/3] Input: synaptics - add multitouch multifinger support
Date: Fri,  8 Oct 2010 10:57:59 -0400
Message-Id: <1286549880-32580-3-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286549880-32580-2-git-send-email-chase.douglas@canonical.com>
References: <1286549880-32580-1-git-send-email-chase.douglas@canonical.com>
 <1286549880-32580-2-git-send-email-chase.douglas@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer multitouch Synaptics trackpads do not advertise multifinger
support. Now that we have multitouch support, we can use the number of
touches to report multifinger functionality.

In conjunction with the X synaptics input module, this enables
functionality such as two finger scrolling.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 drivers/input/mouse/synaptics.c |   24 +++++++++++++-----------
 drivers/input/mouse/synaptics.h |    1 +
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 990598f..7289d88 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -471,7 +471,6 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	struct input_dev *dev = psmouse->dev;
 	struct synaptics_data *priv = psmouse->private;
 	struct synaptics_hw_state hw;
-	int num_fingers;
 	int finger_width;
 	int i;
 
@@ -483,6 +482,7 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 			input_report_abs(dev, ABS_MT_POSITION_Y,
 					 YMAX_NOMINAL + YMIN_NOMINAL - hw.y);
 			input_report_abs(dev, ABS_MT_PRESSURE, hw.z);
+			priv->num_fingers++;
 		}
 
 		input_mt_sync(dev);
@@ -510,13 +510,13 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	}
 
 	if (hw.z > 0) {
-		num_fingers = 1;
+		priv->num_fingers++;
 		finger_width = 5;
 		if (SYN_CAP_EXTENDED(priv->capabilities)) {
 			switch (hw.w) {
 			case 0 ... 1:
 				if (SYN_CAP_MULTIFINGER(priv->capabilities))
-					num_fingers = hw.w + 2;
+					priv->num_fingers = hw.w + 2;
 				break;
 			case 2:
 				if (SYN_MODEL_PEN(priv->model_id))
@@ -528,10 +528,8 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 				break;
 			}
 		}
-	} else {
-		num_fingers = 0;
+	} else
 		finger_width = 0;
-	}
 
 	/* Post events
 	 * BTN_TOUCH has to be first as mousedev relies on it when doing
@@ -555,15 +553,19 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	if (SYN_CAP_PALMDETECT(priv->capabilities))
 		input_report_abs(dev, ABS_TOOL_WIDTH, finger_width);
 
-	input_report_key(dev, BTN_TOOL_FINGER, num_fingers == 1);
+	input_report_key(dev, BTN_TOOL_FINGER, priv->num_fingers == 1);
 	input_report_key(dev, BTN_LEFT, hw.left);
 	input_report_key(dev, BTN_RIGHT, hw.right);
 
-	if (SYN_CAP_MULTIFINGER(priv->capabilities)) {
-		input_report_key(dev, BTN_TOOL_DOUBLETAP, num_fingers == 2);
-		input_report_key(dev, BTN_TOOL_TRIPLETAP, num_fingers == 3);
+	if (SYN_CAP_MULTIFINGER(priv->capabilities) || priv->multitouch) {
+		input_report_key(dev, BTN_TOOL_DOUBLETAP,
+				 priv->num_fingers == 2);
+		input_report_key(dev, BTN_TOOL_TRIPLETAP,
+				 priv->num_fingers == 3);
 	}
 
+	priv->num_fingers = 0;
+
 	if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities))
 		input_report_key(dev, BTN_MIDDLE, hw.middle);
 
@@ -674,7 +676,7 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 	__set_bit(BTN_LEFT, dev->keybit);
 	__set_bit(BTN_RIGHT, dev->keybit);
 
-	if (SYN_CAP_MULTIFINGER(priv->capabilities)) {
+	if (SYN_CAP_MULTIFINGER(priv->capabilities) || priv->multitouch) {
 		__set_bit(BTN_TOOL_DOUBLETAP, dev->keybit);
 		__set_bit(BTN_TOOL_TRIPLETAP, dev->keybit);
 	}
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index 5126c9c..0989b8d 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -113,6 +113,7 @@ struct synaptics_data {
 	unsigned char mode;			/* current mode byte */
 	int scroll;
 	int multitouch;				/* Whether device provides MT */
+	unsigned int num_fingers;		/* Number of fingers touching */
 };
 
 void synaptics_module_init(void);
-- 
1.7.1

