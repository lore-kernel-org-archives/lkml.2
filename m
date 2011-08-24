Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab1HXFne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 01:43:34 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:33543 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab1HXFm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 01:42:26 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        =?UTF-8?q?=C3=89ric=20Piel?= <E.A.B.Piel@tudelft.nl>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>, JJ Ding <jj_ding@emc.com.tw>
Subject: [PATCH v2 3/7] Input: elantech - use firmware provided x, y ranges
Date: Wed, 24 Aug 2011 13:44:42 +0800
Message-Id: <1314164686-866-4-git-send-email-jj_ding@emc.com.tw>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314164686-866-1-git-send-email-jj_ding@emc.com.tw>
References: <1314164686-866-1-git-send-email-jj_ding@emc.com.tw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With newer hardware, the touchpad provides range info.
Let's use it.

Signed-off-by: JJ Ding <jj_ding@emc.com.tw>
---
 drivers/input/mouse/elantech.c |   71 +++++++++++++++++++++++++++++++--------
 drivers/input/mouse/elantech.h |    3 +-
 2 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index cd8e2e5..282b8b6 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -223,7 +223,7 @@ static void elantech_report_absolute_v1(struct psmouse *psmouse)
 		input_report_abs(dev, ABS_X,
 			((packet[1] & 0x0c) << 6) | packet[2]);
 		input_report_abs(dev, ABS_Y,
-			ETP_YMAX_V1 - (((packet[1] & 0x03) << 8) | packet[3]));
+			etd->y_max - (((packet[1] & 0x03) << 8) | packet[3]));
 	}
 
 	input_report_key(dev, BTN_TOOL_FINGER, fingers == 1);
@@ -233,7 +233,7 @@ static void elantech_report_absolute_v1(struct psmouse *psmouse)
 	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
 
 	if (etd->fw_version < 0x020000 &&
-	    (etd->capabilities & ETP_CAP_HAS_ROCKER)) {
+	    (etd->capabilities[0] & ETP_CAP_HAS_ROCKER)) {
 		/* rocker up */
 		input_report_key(dev, BTN_FORWARD, packet[0] & 0x40);
 		/* rocker down */
@@ -298,7 +298,7 @@ static void elantech_report_absolute_v2(struct psmouse *psmouse)
 		 * byte 4:  .   .   .   .  y11 y10 y9  y8
 		 * byte 5: y7  y6  y5  y4  y3  y2  y1  y0
 		 */
-		y1 = ETP_YMAX_V2 - (((packet[4] & 0x0f) << 8) | packet[5]);
+		y1 = etd->y_max - (((packet[4] & 0x0f) << 8) | packet[5]);
 
 		pres = (packet[1] & 0xf0) | ((packet[4] & 0xf0) >> 4);
 		width = ((packet[0] & 0x30) >> 2) | ((packet[3] & 0x30) >> 4);
@@ -313,7 +313,7 @@ static void elantech_report_absolute_v2(struct psmouse *psmouse)
 		 */
 		x1 = (((packet[0] & 0x10) << 4) | packet[1]) << 2;
 		/* byte 2: ay7 ay6 ay5 ay4 ay3 ay2 ay1 ay0 */
-		y1 = ETP_YMAX_V2 -
+		y1 = etd->y_max -
 			((((packet[0] & 0x20) << 3) | packet[2]) << 2);
 		/*
 		 * byte 3:  .   .  by8 bx8  .   .   .   .
@@ -321,7 +321,7 @@ static void elantech_report_absolute_v2(struct psmouse *psmouse)
 		 */
 		x2 = (((packet[3] & 0x10) << 4) | packet[4]) << 2;
 		/* byte 5: by7 by8 by5 by4 by3 by2 by1 by0 */
-		y2 = ETP_YMAX_V2 -
+		y2 = etd->y_max -
 			((((packet[3] & 0x20) << 3) | packet[5]) << 2);
 
 		/* Unknown so just report sensible values */
@@ -468,6 +468,41 @@ static int elantech_set_absolute_mode(struct psmouse *psmouse)
 	return rc;
 }
 
+static void set_range(struct psmouse *psmouse, unsigned int *x_min,
+		     unsigned int *y_min, unsigned int *x_max,
+		     unsigned int *y_max)
+{
+	struct elantech_data *etd = psmouse->private;
+	int i;
+
+	switch (etd->hw_version) {
+	case 1:
+		*x_min = ETP_XMIN_V1;
+		*y_min = ETP_YMIN_V1;
+		*x_max = ETP_XMAX_V1;
+		*y_max = ETP_YMAX_V1;
+		break;
+
+	case 2:
+		if (etd->fw_version == 0x020800 ||
+		    etd->fw_version == 0x020b00 ||
+		    etd->fw_version == 0x020030) {
+			*x_min = ETP_XMIN_V2;
+			*y_min = ETP_YMIN_V2;
+			*x_max = ETP_XMAX_V2;
+			*y_max = ETP_YMAX_V2;
+		} else {
+			i = (etd->fw_version > 0x020800 &&
+			     etd->fw_version < 0x020900) ? 1 : 2;
+			*x_min = 0;
+			*y_min = 0;
+			*x_max = (etd->capabilities[1] - i) * 64;
+			*y_max = (etd->capabilities[2] - i) * 64;
+		}
+		break;
+	}
+}
+
 /*
  * Set the appropriate event bits for the input subsystem
  */
@@ -475,6 +510,9 @@ static void elantech_set_input_params(struct psmouse *psmouse)
 {
 	struct input_dev *dev = psmouse->dev;
 	struct elantech_data *etd = psmouse->private;
+	unsigned int x_min = 0, y_min = 0, x_max = 0, y_max = 0;
+
+	set_range(psmouse, &x_min, &y_min, &x_max, &y_max);
 
 	__set_bit(EV_KEY, dev->evbit);
 	__set_bit(EV_ABS, dev->evbit);
@@ -492,18 +530,18 @@ static void elantech_set_input_params(struct psmouse *psmouse)
 	case 1:
 		/* Rocker button */
 		if (etd->fw_version < 0x020000 &&
-		    (etd->capabilities & ETP_CAP_HAS_ROCKER)) {
+		    (etd->capabilities[0] & ETP_CAP_HAS_ROCKER)) {
 			__set_bit(BTN_FORWARD, dev->keybit);
 			__set_bit(BTN_BACK, dev->keybit);
 		}
-		input_set_abs_params(dev, ABS_X, ETP_XMIN_V1, ETP_XMAX_V1, 0, 0);
-		input_set_abs_params(dev, ABS_Y, ETP_YMIN_V1, ETP_YMAX_V1, 0, 0);
+		input_set_abs_params(dev, ABS_X, x_min, x_max, 0, 0);
+		input_set_abs_params(dev, ABS_Y, y_min, y_max, 0, 0);
 		break;
 
 	case 2:
 		__set_bit(BTN_TOOL_QUADTAP, dev->keybit);
-		input_set_abs_params(dev, ABS_X, ETP_XMIN_V2, ETP_XMAX_V2, 0, 0);
-		input_set_abs_params(dev, ABS_Y, ETP_YMIN_V2, ETP_YMAX_V2, 0, 0);
+		input_set_abs_params(dev, ABS_X, x_min, x_max, 0, 0);
+		input_set_abs_params(dev, ABS_Y, y_min, y_max, 0, 0);
 		if (etd->reports_pressure) {
 			input_set_abs_params(dev, ABS_PRESSURE, ETP_PMIN_V2,
 					     ETP_PMAX_V2, 0, 0);
@@ -512,10 +550,12 @@ static void elantech_set_input_params(struct psmouse *psmouse)
 		}
 		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
 		input_mt_init_slots(dev, 2);
-		input_set_abs_params(dev, ABS_MT_POSITION_X, ETP_XMIN_V2, ETP_XMAX_V2, 0, 0);
-		input_set_abs_params(dev, ABS_MT_POSITION_Y, ETP_YMIN_V2, ETP_YMAX_V2, 0, 0);
+		input_set_abs_params(dev, ABS_MT_POSITION_X, x_min, x_max, 0, 0);
+		input_set_abs_params(dev, ABS_MT_POSITION_Y, y_min, y_max, 0, 0);
 		break;
 	}
+
+	etd->y_max = y_max;
 }
 
 struct elantech_attr_data {
@@ -769,13 +809,14 @@ int elantech_init(struct psmouse *psmouse)
 	pr_info("assuming hardware version %d, firmware version %d.%d.%d\n",
 		etd->hw_version, param[0], param[1], param[2]);
 
-	if (synaptics_send_cmd(psmouse, ETP_CAPABILITIES_QUERY, param)) {
+	if (synaptics_send_cmd(psmouse, ETP_CAPABILITIES_QUERY,
+	    etd->capabilities)) {
 		pr_err("failed to query capabilities.\n");
 		goto init_fail;
 	}
 	pr_info("Synaptics capabilities query result 0x%02x, 0x%02x, 0x%02x.\n",
-		param[0], param[1], param[2]);
-	etd->capabilities = param[0];
+		etd->capabilities[0], etd->capabilities[1],
+		etd->capabilities[2]);
 
 	/*
 	 * This firmware suffers from misreporting coordinates when
diff --git a/drivers/input/mouse/elantech.h b/drivers/input/mouse/elantech.h
index 1c5894e..b54ea27 100644
--- a/drivers/input/mouse/elantech.h
+++ b/drivers/input/mouse/elantech.h
@@ -93,13 +93,14 @@ struct elantech_data {
 	unsigned char reg_25;
 	unsigned char reg_26;
 	unsigned char debug;
-	unsigned char capabilities;
+	unsigned char capabilities[3];
 	bool paritycheck;
 	bool jumpy_cursor;
 	bool reports_pressure;
 	unsigned char hw_version;
 	unsigned int fw_version;
 	unsigned int single_finger_reports;
+	unsigned int y_max;
 	unsigned char parity[256];
 };
 
-- 
1.7.4.1

