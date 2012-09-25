Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab2IYQOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:14:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758040Ab2IYQOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:14:11 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 46/57] power: chargealg: Realign with upstream version
Date: Tue, 25 Sep 2012 10:12:43 -0600
Message-Id: <1348589574-25655-47-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Loic Pallardy <loic.pallardy@stericsson.com>

Upstream version of AB charge algo has been reverted
during kernel 3.4 port.
This patch restore state by:
- renaming ab8500_chargal.c in abx500_chargal.c
- renaming function from ab8500 to abx500
- moving generic structure in "include/mfd/abx500.h"

Goal is to ease next code reversion and realignment
with mainline

Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/power/ab8500_charger.c       |  166 +++++++++++-----------------------
 include/linux/mfd/abx500.h           |   10 ++-
 include/linux/mfd/abx500/ab8500-bm.h |    5 +-
 3 files changed, 65 insertions(+), 116 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index d90fe9f..68a4128 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -79,6 +79,7 @@
 #define AB8500_USB_LINK_STATUS		0x78
 #define AB8505_USB_LINK_STATUS		0xF8
 #define AB8500_STD_HOST_SUSP		0x18
+#define USB_LINK_STATUS_SHIFT		3
 
 /* Watchdog timeout constant */
 #define WD_TIMER			0x30 /* 4min */
@@ -743,8 +744,7 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 			dev_err(di->dev, "VBUS has collapsed\n");
 			ret = -ENXIO;
 			break;
-		}
-		if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+		} else {
 			dev_dbg(di->dev, "USB Type - Charging not allowed\n");
 			di->max_usb_in_curr.usb_type_max =
 						USB_CH_IP_CUR_LVL_0P05;
@@ -799,30 +799,22 @@ static int ab8500_charger_read_usb_type(struct ab8500_charger *di)
 		dev_err(di->dev, "%s ab8500 read failed\n", __func__);
 		return ret;
 	}
-	if (is_ab8500(di->parent)) {
+	if (is_ab8500(di->parent))
 		ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
-				AB8500_USB_LINE_STAT_REG, &val);
-	} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
-			ret = abx500_get_register_interruptible(di->dev,
-				AB8500_USB, AB8500_USB_LINK1_STAT_REG, &val);
-	} else {
-		dev_err(di->dev, "%s unsupported analog baseband\n", __func__);
-		return -ENXIO;
-	}
+			AB8500_USB_LINE_STAT_REG, &val);
+	else
+		ret = abx500_get_register_interruptible(di->dev,
+			AB8500_USB, AB8500_USB_LINK1_STAT_REG, &val);
 	if (ret < 0) {
 		dev_err(di->dev, "%s ab8500 read failed\n", __func__);
 		return ret;
 	}
 
 	/* get the USB type */
-	if (is_ab8500(di->parent)) {
-		val = (val & AB8500_USB_LINK_STATUS) >> 3;
-	} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
-		val = (val & AB8505_USB_LINK_STATUS) >> 3;
-	} else {
-		dev_err(di->dev, "%s unsupported analog baseband\n", __func__);
-		return -ENXIO;
-	}
+	if (is_ab8500(di->parent))
+		val = (val & AB8500_USB_LINK_STATUS) >> USB_LINK_STATUS_SHIFT;
+	else
+		val = (val & AB8505_USB_LINK_STATUS) >> USB_LINK_STATUS_SHIFT;
 	ret = ab8500_charger_max_usb_curr(di,
 		(enum ab8500_charger_link_status) val);
 
@@ -858,17 +850,12 @@ static int ab8500_charger_detect_usb_type(struct ab8500_charger *di)
 			return ret;
 		}
 
-		if (is_ab8500(di->parent)) {
+		if (is_ab8500(di->parent))
 			ret = abx500_get_register_interruptible(di->dev,
 				AB8500_USB, AB8500_USB_LINE_STAT_REG, &val);
-		} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+		else
 			ret = abx500_get_register_interruptible(di->dev,
 				AB8500_USB, AB8500_USB_LINK1_STAT_REG, &val);
-		} else {
-			dev_err(di->dev,
-				 "%s unsupported analog baseband\n", __func__);
-			return -ENXIO;
-		}
 		if (ret < 0) {
 			dev_err(di->dev, "%s ab8500 read failed\n", __func__);
 			return ret;
@@ -882,15 +869,12 @@ static int ab8500_charger_detect_usb_type(struct ab8500_charger *di)
 		 */
 
 		/* get the USB type */
-		if (is_ab8500(di->parent)) {
-			val = (val & AB8500_USB_LINK_STATUS) >> 3;
-		} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
-			val = (val & AB8505_USB_LINK_STATUS) >> 3;
-		} else {
-			dev_err(di->dev,
-				 "%s unsupported analog baseband\n", __func__);
-			return -ENXIO;
-		}
+		if (is_ab8500(di->parent))
+			val = (val & AB8500_USB_LINK_STATUS) >>
+						USB_LINK_STATUS_SHIFT;
+		else
+			val = (val & AB8505_USB_LINK_STATUS) >>
+						USB_LINK_STATUS_SHIFT;
 		if (val)
 			break;
 	}
@@ -985,51 +969,6 @@ static int ab8500_charger_voltage_map[] = {
 	4600 ,
 };
 
-/*
- * This array maps the raw hex value to charger current used by the AB8500
- * Values taken from the UM0836
- */
-static int ab8500_charger_current_map[] = {
-	100 ,
-	200 ,
-	300 ,
-	400 ,
-	500 ,
-	600 ,
-	700 ,
-	800 ,
-	900 ,
-	1000 ,
-	1100 ,
-	1200 ,
-	1300 ,
-	1400 ,
-	1500 ,
-};
-
-/*
- * This array maps the raw hex value to VBUS input current used by the AB8500
- * Values taken from the UM0836
- */
-static int ab8500_charger_vbus_in_curr_map[] = {
-	USB_CH_IP_CUR_LVL_0P05,
-	USB_CH_IP_CUR_LVL_0P09,
-	USB_CH_IP_CUR_LVL_0P19,
-	USB_CH_IP_CUR_LVL_0P29,
-	USB_CH_IP_CUR_LVL_0P38,
-	USB_CH_IP_CUR_LVL_0P45,
-	USB_CH_IP_CUR_LVL_0P5,
-	USB_CH_IP_CUR_LVL_0P6,
-	USB_CH_IP_CUR_LVL_0P7,
-	USB_CH_IP_CUR_LVL_0P8,
-	USB_CH_IP_CUR_LVL_0P9,
-	USB_CH_IP_CUR_LVL_1P0,
-	USB_CH_IP_CUR_LVL_1P1,
-	USB_CH_IP_CUR_LVL_1P3,
-	USB_CH_IP_CUR_LVL_1P4,
-	USB_CH_IP_CUR_LVL_1P5,
-};
-
 static int ab8500_voltage_to_regval(int voltage)
 {
 	int i;
@@ -1051,41 +990,41 @@ static int ab8500_voltage_to_regval(int voltage)
 		return -1;
 }
 
-static int ab8500_current_to_regval(int curr)
+static int ab8500_current_to_regval(struct ab8500_charger *di, int curr)
 {
 	int i;
 
-	if (curr < ab8500_charger_current_map[0])
+	if (curr < di->bat->chg_output_curr[0])
 		return 0;
 
-	for (i = 0; i < ARRAY_SIZE(ab8500_charger_current_map); i++) {
-		if (curr < ab8500_charger_current_map[i])
+	for (i = 0; i < di->bat->n_chg_out_curr; i++) {
+		if (curr < di->bat->chg_output_curr[i])
 			return i - 1;
 	}
 
 	/* If not last element, return error */
-	i = ARRAY_SIZE(ab8500_charger_current_map) - 1;
-	if (curr == ab8500_charger_current_map[i])
+	i = di->bat->n_chg_out_curr - 1;
+	if (curr == di->bat->chg_output_curr[i])
 		return i;
 	else
 		return -1;
 }
 
-static int ab8500_vbus_in_curr_to_regval(int curr)
+static int ab8500_vbus_in_curr_to_regval(struct ab8500_charger *di, int curr)
 {
 	int i;
 
-	if (curr < ab8500_charger_vbus_in_curr_map[0])
+	if (curr < di->bat->chg_input_curr[0])
 		return 0;
 
-	for (i = 0; i < ARRAY_SIZE(ab8500_charger_vbus_in_curr_map); i++) {
-		if (curr < ab8500_charger_vbus_in_curr_map[i])
+	for (i = 0; i < di->bat->n_chg_in_curr; i++) {
+		if (curr < di->bat->chg_input_curr[i])
 			return i - 1;
 	}
 
 	/* If not last element, return error */
-	i = ARRAY_SIZE(ab8500_charger_vbus_in_curr_map) - 1;
-	if (curr == ab8500_charger_vbus_in_curr_map[i])
+	i = di->bat->n_chg_in_curr - 1;
+	if (curr == di->bat->chg_input_curr[i])
 		return i;
 	else
 		return -1;
@@ -1181,7 +1120,7 @@ static int ab8500_charger_set_current(struct ab8500_charger *di,
 	case AB8500_MCH_IPT_CURLVL_REG:
 		shift_value = MAIN_CH_INPUT_CURR_SHIFT;
 		prev_curr_index = (reg_value >> shift_value);
-		curr_index = ab8500_current_to_regval(ich);
+		curr_index = ab8500_current_to_regval(di, ich);
 		step_udelay = STEP_UDELAY;
 		if (!di->ac.charger_connected)
 			no_stepping = true;
@@ -1189,7 +1128,7 @@ static int ab8500_charger_set_current(struct ab8500_charger *di,
 	case AB8500_USBCH_IPT_CRNTLVL_REG:
 		shift_value = VBUS_IN_CURR_LIM_SHIFT;
 		prev_curr_index = (reg_value >> shift_value);
-		curr_index = ab8500_vbus_in_curr_to_regval(ich);
+		curr_index = ab8500_vbus_in_curr_to_regval(di, ich);
 		step_udelay = STEP_UDELAY * 100;
 
 		ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
@@ -1203,8 +1142,7 @@ static int ab8500_charger_set_current(struct ab8500_charger *di,
 			reg_value >> AUTO_VBUS_IN_CURR_LIM_SHIFT;
 
 		dev_dbg(di->dev, "%s Auto VBUS curr is %d mA\n",
-			__func__,
-			ab8500_charger_vbus_in_curr_map[auto_curr_index]);
+			__func__, di->bat->chg_input_curr[auto_curr_index]);
 
 		prev_curr_index = min(prev_curr_index, auto_curr_index);
 
@@ -1214,7 +1152,7 @@ static int ab8500_charger_set_current(struct ab8500_charger *di,
 	case AB8500_CH_OPT_CRNTLVL_REG:
 		shift_value = 0;
 		prev_curr_index = (reg_value >> shift_value);
-		curr_index = ab8500_current_to_regval(ich);
+		curr_index = ab8500_current_to_regval(di, ich);
 		if (curr_index == 0)
 			step_udelay = STEP_UDELAY;
 		else if ((curr_index - prev_curr_index) > 1)
@@ -1453,8 +1391,8 @@ static int ab8500_charger_ac_en(struct ux500_charger *charger,
 
 		/* Check if the requested voltage or current is valid */
 		volt_index = ab8500_voltage_to_regval(vset);
-		curr_index = ab8500_current_to_regval(iset);
-		input_curr_index = ab8500_current_to_regval(
+		curr_index = ab8500_current_to_regval(di, iset);
+		input_curr_index = ab8500_current_to_regval(di,
 			di->bat->chg_params->ac_curr_max);
 		if (volt_index < 0 || curr_index < 0 || input_curr_index < 0) {
 			dev_err(di->dev,
@@ -1624,7 +1562,7 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
 
 		/* Check if the requested voltage or current is valid */
 		volt_index = ab8500_voltage_to_regval(vset);
-		curr_index = ab8500_current_to_regval(ich_out);
+		curr_index = ab8500_current_to_regval(di, ich_out);
 		if (volt_index < 0 || curr_index < 0) {
 			dev_err(di->dev,
 				"Charger voltage or current too high, "
@@ -2327,21 +2265,21 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 	else
 		dev_dbg(di->dev, "Error reading USB link status\n");
 
-	if (is_ab9540(di->parent) || is_ab8505(di->parent))
-		link_status = AB8505_USB_LINK_STATUS;
-	else
+	if (is_ab8500(di->parent))
 		link_status = AB8500_USB_LINK_STATUS;
+	else
+		link_status = AB8505_USB_LINK_STATUS;
 
 	if (detected_chargers & USB_PW_CONN) {
-		if (((val & link_status) >> 3) == USB_STAT_NOT_VALID_LINK &&
+		if (((val & link_status) >> USB_LINK_STATUS_SHIFT) ==
+				USB_STAT_NOT_VALID_LINK &&
 				di->invalid_charger_detect_state == 0) {
 			dev_dbg(di->dev,
 				 "Invalid charger detected, state= 0\n");
 			/*Enable charger*/
 			abx500_mask_and_set_register_interruptible(di->dev,
-						AB8500_CHARGER,
-						AB8500_USBCH_CTRL1_REG,
-						0x01, 0x01);
+					AB8500_CHARGER, AB8500_USBCH_CTRL1_REG,
+					USB_CH_ENA, USB_CH_ENA);
 			/*Enable charger detection*/
 			abx500_mask_and_set_register_interruptible(di->dev,
 						AB8500_USB,
@@ -2366,7 +2304,7 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 						AB8500_USB_LINE_STAT_REG,
 						&val);
 			dev_dbg(di->dev, "USB link status= 0x%02x\n",
-					(val & link_status) >> 3);
+				(val & link_status) >> USB_LINK_STATUS_SHIFT);
 			di->invalid_charger_detect_state = 2;
 		}
 	} else {
@@ -2678,7 +2616,7 @@ static void ab8500_charger_vbus_drop_end_work(struct work_struct *work)
 {
 	struct ab8500_charger *di = container_of(work,
 		struct ab8500_charger, vbus_drop_end_work.work);
-	int ret;
+	int ret, curr;
 	u8 reg_value;
 
 	di->flags.vbus_drop_end = false;
@@ -2692,7 +2630,7 @@ static void ab8500_charger_vbus_drop_end_work(struct work_struct *work)
 	if (ret < 0) {
 		dev_err(di->dev, "%s ab8500 read failed\n", __func__);
 	} else {
-		int curr = ab8500_charger_vbus_in_curr_map[
+		curr = di->bat->chg_input_curr[
 			reg_value >> AUTO_VBUS_IN_CURR_LIM_SHIFT];
 		if (di->max_usb_in_curr.calculated_max != curr) {
 			/* USB source is collapsing */
@@ -3434,8 +3372,8 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	di->ac_chg.ops.update_curr = &ab8500_charger_update_charger_current;
 	di->ac_chg.max_out_volt = ab8500_charger_voltage_map[
 		ARRAY_SIZE(ab8500_charger_voltage_map) - 1];
-	di->ac_chg.max_out_curr = ab8500_charger_current_map[
-		ARRAY_SIZE(ab8500_charger_current_map) - 1];
+	di->ac_chg.max_out_curr =
+		di->bat->chg_output_curr[di->bat->n_chg_out_curr - 1];
 	di->ac_chg.wdt_refresh = CHG_WD_INTERVAL;
 	di->ac_chg.enabled = di->pdata->ac_enabled;
 	di->ac_chg.external = false;
@@ -3461,8 +3399,8 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	di->usb_chg.ops.update_curr = &ab8500_charger_update_charger_current;
 	di->usb_chg.max_out_volt = ab8500_charger_voltage_map[
 		ARRAY_SIZE(ab8500_charger_voltage_map) - 1];
-	di->usb_chg.max_out_curr = ab8500_charger_current_map[
-		ARRAY_SIZE(ab8500_charger_current_map) - 1];
+	di->usb_chg.max_out_curr =
+		di->bat->chg_output_curr[di->bat->n_chg_out_curr - 1];
 	di->usb_chg.wdt_refresh = CHG_WD_INTERVAL;
 	di->usb_chg.enabled = di->pdata->usb_enabled;
 	di->usb_chg.external = false;
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index cb2b82a..a3bb93e 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -363,7 +363,11 @@ struct abx500_bm_charger_parameters {
  * @interval_not_charging charge alg cycle period time when not charging (sec)
  * @temp_hysteresis	temperature hysteresis
  * @gnd_lift_resistance	Battery ground to phone ground resistance (mOhm)
- * @maxi:		maximization parameters
+ * @n_chg_out_curr	number of elements in array chg_output_curr
+ * @n_chg_in_curr	number of elements in array chg_input_curr
+ * @chg_output_curr	charger output current level map
+ * @chg_input_curr	charger input current level map
+ * @maxi		maximization parameters
  * @cap_levels		capacity in percent for the different capacity levels
  * @bat_type		table of supported battery types
  * @chg_params		charger parameters
@@ -394,6 +398,10 @@ struct abx500_bm_data {
 	int interval_not_charging;
 	int temp_hysteresis;
 	int gnd_lift_resistance;
+	int n_chg_out_curr;
+	int n_chg_in_curr;
+	int *chg_output_curr;
+	int *chg_input_curr;
 	const struct abx500_maxim_parameters *maxi;
 	const struct abx500_bm_capacity_levels *cap_levels;
 	const struct abx500_battery_type *bat_type;
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index 5ae8a6f..721bd6d 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -33,7 +33,7 @@
 #define AB8500_CH_STATUS2_REG		0x01
 #define AB8500_CH_USBCH_STAT1_REG	0x02
 #define AB8500_CH_USBCH_STAT2_REG	0x03
-#define AB8500_CH_FSM_STAT_REG		0x04
+#define AB8540_CH_USBCH_STAT3_REG	0x04
 #define AB8500_CH_STAT_REG		0x05
 
 /*
@@ -155,6 +155,7 @@
 #define CH_OP_CUR_LVL_1P4		0x0D
 #define CH_OP_CUR_LVL_1P5		0x0E
 #define CH_OP_CUR_LVL_1P6		0x0F
+#define CH_OP_CUR_LVL_2P		0x3F
 
 /* BTEMP High thermal limits */
 #define BTEMP_HIGH_TH_57_0		0x00
@@ -244,6 +245,8 @@ enum bup_vch_sel {
 #define BAT_CTRL_20U_ENA		0x02
 #define BAT_CTRL_18U_ENA		0x01
 #define BAT_CTRL_16U_ENA		0x02
+#define BAT_CTRL_60U_ENA		0x01
+#define BAT_CTRL_120U_ENA		0x02
 #define BAT_CTRL_CMP_ENA		0x04
 #define FORCE_BAT_CTRL_CMP_HIGH		0x08
 #define BAT_CTRL_PULL_UP_ENA		0x10
-- 
1.7.5.4

