Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab0LMW4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 17:56:17 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:43507 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231Ab0LMW4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 17:56:15 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Takashi Iwai <tiwai@suse.de>,
        Chase Douglas <chase.douglas@canonical.com>,
        Chris Bagwell <chris@cnpbagwell.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 2/2] Input: synaptics - emit multitouch data
Date: Mon, 13 Dec 2010 23:55:48 +0100
Message-Id: <1292280948-1933-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292280948-1933-1-git-send-email-rydberg@euromail.se>
References: <1292280948-1933-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PSHJM-000813-8A.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PSHJM-000813-8A fd1c06fa5a8b1f68e67066f19be765ae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In multitouch mode, two data packets are sent from the device.  Due to
limitations in the hardware detection mechanism, individual contacts
cannot be reliably extracted. However, the bounding rectangle of the
individual contacts can be accurately reproduced. This patch emits the
MT data as envelope coordinates, allowing userspace to track the
bounding rectangle and produce appropriate gestures.

Acked-by: Chris Bagwell <chris@cnpbagwell.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/synaptics.c |   46 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index de08d77..95d0670 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -25,7 +25,7 @@
 
 #include <linux/module.h>
 #include <linux/dmi.h>
-#include <linux/input.h>
+#include <linux/input/mt.h>
 #include <linux/serio.h>
 #include <linux/libps2.h>
 #include <linux/slab.h>
@@ -489,6 +489,36 @@ static int synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data *
 	return 0;
 }
 
+static void set_slot(struct input_dev *dev, int slot, bool active,
+		     int x, int y, int z)
+{
+	input_mt_slot(dev, slot);
+	input_mt_report_slot_state(dev, MT_TOOL_ENVELOPE, active);
+	if (active) {
+		input_report_abs(dev, ABS_MT_POSITION_X, x);
+		input_report_abs(dev, ABS_MT_POSITION_Y,
+				 YMAX_NOMINAL + YMIN_NOMINAL - y);
+		input_report_abs(dev, ABS_MT_PRESSURE, z);
+	}
+}
+
+static void synaptics_report_mt_data(struct input_dev *dev,
+				     const struct synaptics_hw_state *a,
+				     const struct synaptics_hw_state *b,
+				     int num_fingers)
+{
+	if (num_fingers >= 2) {
+		set_slot(dev, 0, true, min(a->x, b->x), min(a->y, b->y), a->z);
+		set_slot(dev, 1, true, max(a->x, b->x), max(a->y, b->y), a->z);
+	} else if (num_fingers == 1) {
+		set_slot(dev, 0, true, a->x, a->y, a->z);
+		set_slot(dev, 1, false, 0, 0, 0);
+	} else {
+		set_slot(dev, 0, false, 0, 0, 0);
+		set_slot(dev, 1, false, 0, 0, 0);
+	}
+}
+
 /*
  *  called for each full received packet from the touchpad
  */
@@ -551,6 +581,9 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 		finger_width = 0;
 	}
 
+	if (priv->multitouch)
+		synaptics_report_mt_data(dev, &hw, &priv->mt, num_fingers);
+
 	/* Post events
 	 * BTN_TOUCH has to be first as mousedev relies on it when doing
 	 * absolute -> relative conversion
@@ -668,6 +701,17 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 			     YMIN_NOMINAL, priv->y_max ?: YMAX_NOMINAL, 0, 0);
 	input_set_abs_params(dev, ABS_PRESSURE, 0, 255, 0, 0);
 
+	if (priv->multitouch) {
+		input_mt_init_slots(dev, 2);
+		input_set_abs_params(dev, ABS_MT_POSITION_X, XMIN_NOMINAL,
+				     priv->x_max ?: XMAX_NOMINAL, 0, 0);
+		input_set_abs_params(dev, ABS_MT_POSITION_Y, YMIN_NOMINAL,
+				     priv->y_max ?: YMAX_NOMINAL, 0, 0);
+		input_set_abs_params(dev, ABS_MT_PRESSURE, 0, 255, 0, 0);
+		input_set_abs_params(dev, ABS_MT_TOOL_TYPE, 0, MT_TOOL_MAX,
+				     0, 0);
+	}
+
 	if (SYN_CAP_PALMDETECT(priv->capabilities))
 		input_set_abs_params(dev, ABS_TOOL_WIDTH, 0, 15, 0, 0);
 
-- 
1.7.1

