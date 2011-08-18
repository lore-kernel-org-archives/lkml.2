Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab1HRL2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 07:28:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28263 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab1HRL2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 07:28:17 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: chase.douglas@canonical.com, dmitry.torokhov@gmail.com,
        rydberg@euromail.se
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 3/9 v4] Input: synaptics - refactor initialization of abs position axes
Date: Thu, 18 Aug 2011 19:28:02 +0800
Message-Id: <1313666888-18939-4-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313666888-18939-1-git-send-email-djkurtz@chromium.org>
References: <1313666888-18939-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Acked-by: Chase Douglas <chase.douglas@canonical.com>
---
 drivers/input/mouse/synaptics.c |   44 +++++++++++++++++---------------------
 1 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index e966894..30d05fd 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -712,39 +712,38 @@ static psmouse_ret_t synaptics_process_byte(struct psmouse *psmouse)
 /*****************************************************************************
  *	Driver initialization/cleanup functions
  ****************************************************************************/
+static void set_abs_position_params(struct input_dev *dev,
+				    struct synaptics_data *priv, int x_code,
+				    int y_code)
+{
+	int x_min = priv->x_min ?: XMIN_NOMINAL;
+	int x_max = priv->x_max ?: XMAX_NOMINAL;
+	int y_min = priv->y_min ?: YMIN_NOMINAL;
+	int y_max = priv->y_max ?: YMAX_NOMINAL;
+	int fuzz = SYN_CAP_REDUCED_FILTERING(priv->ext_cap_0c) ?
+			SYN_REDUCED_FILTER_FUZZ : 0;
+
+	input_set_abs_params(dev, x_code, x_min, x_max, fuzz, 0);
+	input_set_abs_params(dev, y_code, y_min, y_max, fuzz, 0);
+	input_abs_set_res(dev, x_code, priv->x_res);
+	input_abs_set_res(dev, y_code, priv->y_res);
+}
+
 static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 {
 	int i;
-	int fuzz = SYN_CAP_REDUCED_FILTERING(priv->ext_cap_0c) ?
-			SYN_REDUCED_FILTER_FUZZ : 0;
 
 	__set_bit(INPUT_PROP_POINTER, dev->propbit);
 
 	__set_bit(EV_ABS, dev->evbit);
-	input_set_abs_params(dev, ABS_X,
-			     priv->x_min ?: XMIN_NOMINAL,
-			     priv->x_max ?: XMAX_NOMINAL,
-			     fuzz, 0);
-	input_set_abs_params(dev, ABS_Y,
-			     priv->y_min ?: YMIN_NOMINAL,
-			     priv->y_max ?: YMAX_NOMINAL,
-			     fuzz, 0);
+	set_abs_position_params(dev, priv, ABS_X, ABS_Y);
 	input_set_abs_params(dev, ABS_PRESSURE, 0, 255, 0, 0);
 
 	if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)) {
 		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
 		input_mt_init_slots(dev, 2);
-		input_set_abs_params(dev, ABS_MT_POSITION_X,
-				     priv->x_min ?: XMIN_NOMINAL,
-				     priv->x_max ?: XMAX_NOMINAL,
-				     fuzz, 0);
-		input_set_abs_params(dev, ABS_MT_POSITION_Y,
-				     priv->y_min ?: YMIN_NOMINAL,
-				     priv->y_max ?: YMAX_NOMINAL,
-				     fuzz, 0);
-
-		input_abs_set_res(dev, ABS_MT_POSITION_X, priv->x_res);
-		input_abs_set_res(dev, ABS_MT_POSITION_Y, priv->y_res);
+		set_abs_position_params(dev, priv, ABS_MT_POSITION_X,
+					ABS_MT_POSITION_Y);
 	}
 
 	if (SYN_CAP_PALMDETECT(priv->capabilities))
@@ -777,9 +776,6 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 	__clear_bit(REL_X, dev->relbit);
 	__clear_bit(REL_Y, dev->relbit);
 
-	input_abs_set_res(dev, ABS_X, priv->x_res);
-	input_abs_set_res(dev, ABS_Y, priv->y_res);
-
 	if (SYN_CAP_CLICKPAD(priv->ext_cap_0c)) {
 		__set_bit(INPUT_PROP_BUTTONPAD, dev->propbit);
 		/* Clickpads report only left button */
-- 
1.7.3.1

