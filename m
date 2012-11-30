Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab2K3L6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:58:00 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:51656 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab2K3L5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:57:52 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, cbou@mail.ru,
        dwmw2@infradead.org, rajanikanth.hv@linaro.org,
        Johan Bjornstedt <johan.bjornstedt@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/12] ab8500_charger: Charger current step-up/down
Date: Fri, 30 Nov 2012 11:57:23 +0000
Message-Id: <1354276654-590-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
References: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Bjornstedt <johan.bjornstedt@stericsson.com>

There is no state machine in the AB to step up/down the charger
current to avoid dips and spikes on VBUS and VBAT when charging
is started. Instead this is implemented in SW.

Signed-off-by: Johan Bjornstedt <johan.bjornstedt@stericsson.com>
Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
---
 drivers/power/ab8500_charger.c |  175 +++++++++++++++++++++++++++++++---------
 1 file changed, 135 insertions(+), 40 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index dddc947..d27dd7f 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -79,6 +79,9 @@
 /* Lowest charger voltage is 3.39V -> 0x4E */
 #define LOW_VOLT_REG			0x4E
 
+/* Step up/down delay in us */
+#define STEP_UDELAY			1000
+
 /* UsbLineStatus register - usb types */
 enum ab8500_charger_link_status {
 	USB_STAT_NOT_CONFIGURED,
@@ -936,6 +939,88 @@ static int ab8500_charger_get_usb_cur(struct ab8500_charger *di)
 }
 
 /**
+ * ab8500_charger_set_current() - set charger current
+ * @di:		pointer to the ab8500_charger structure
+ * @ich:	charger current, in mA
+ * @reg:	select what charger register to set
+ *
+ * Set charger current.
+ * There is no state machine in the AB to step up/down the charger
+ * current to avoid dips and spikes on MAIN, VBUS and VBAT when
+ * charging is started. Instead we need to implement
+ * this charger current step-up/down here.
+ * Returns error code in case of failure else 0(on success)
+ */
+static int ab8500_charger_set_current(struct ab8500_charger *di,
+	int ich, int reg)
+{
+	int ret, i;
+	int curr_index, prev_curr_index, shift_value;
+	u8 reg_value;
+
+	switch (reg) {
+	case AB8500_MCH_IPT_CURLVL_REG:
+		shift_value = MAIN_CH_INPUT_CURR_SHIFT;
+		curr_index = ab8500_current_to_regval(ich);
+		break;
+	case AB8500_USBCH_IPT_CRNTLVL_REG:
+		shift_value = VBUS_IN_CURR_LIM_SHIFT;
+		curr_index = ab8500_vbus_in_curr_to_regval(ich);
+		break;
+	case AB8500_CH_OPT_CRNTLVL_REG:
+		shift_value = 0;
+		curr_index = ab8500_current_to_regval(ich);
+		break;
+	default:
+		dev_err(di->dev, "%s current register not valid\n", __func__);
+		return -ENXIO;
+	}
+
+	if (curr_index < 0) {
+		dev_err(di->dev, "requested current limit out-of-range\n");
+		return -ENXIO;
+	}
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
+		reg, &reg_value);
+	if (ret < 0) {
+		dev_err(di->dev, "%s read failed\n", __func__);
+		return ret;
+	}
+	prev_curr_index = (reg_value >> shift_value);
+
+	/* only update current if it's been changed */
+	if (prev_curr_index == curr_index)
+		return 0;
+
+	dev_dbg(di->dev, "%s set charger current: %d mA for reg: 0x%02x\n",
+		__func__, ich, reg);
+
+	if (prev_curr_index > curr_index) {
+		for (i = prev_curr_index - 1; i >= curr_index; i--) {
+			ret = abx500_set_register_interruptible(di->dev,
+				AB8500_CHARGER, reg, (u8) i << shift_value);
+			if (ret) {
+				dev_err(di->dev, "%s write failed\n", __func__);
+				return ret;
+			}
+			usleep_range(STEP_UDELAY, STEP_UDELAY * 2);
+		}
+	} else {
+		for (i = prev_curr_index + 1; i <= curr_index; i++) {
+			ret = abx500_set_register_interruptible(di->dev,
+				AB8500_CHARGER, reg, (u8) i << shift_value);
+			if (ret) {
+				dev_err(di->dev, "%s write failed\n", __func__);
+				return ret;
+			}
+			usleep_range(STEP_UDELAY, STEP_UDELAY * 2);
+		}
+	}
+	return ret;
+}
+
+/**
  * ab8500_charger_set_vbus_in_curr() - set VBUS input current limit
  * @di:		pointer to the ab8500_charger structure
  * @ich_in:	charger input current limit
@@ -946,8 +1031,6 @@ static int ab8500_charger_get_usb_cur(struct ab8500_charger *di)
 static int ab8500_charger_set_vbus_in_curr(struct ab8500_charger *di,
 		int ich_in)
 {
-	int ret;
-	int input_curr_index;
 	int min_value;
 
 	/* We should always use to lowest current limit */
@@ -966,19 +1049,38 @@ static int ab8500_charger_set_vbus_in_curr(struct ab8500_charger *di,
 		break;
 	}
 
-	input_curr_index = ab8500_vbus_in_curr_to_regval(min_value);
-	if (input_curr_index < 0) {
-		dev_err(di->dev, "VBUS input current limit too high\n");
-		return -ENXIO;
-	}
+	return ab8500_charger_set_current(di, min_value,
+		AB8500_USBCH_IPT_CRNTLVL_REG);
+}
 
-	ret = abx500_set_register_interruptible(di->dev, AB8500_CHARGER,
-		AB8500_USBCH_IPT_CRNTLVL_REG,
-		input_curr_index << VBUS_IN_CURR_LIM_SHIFT);
-	if (ret)
-		dev_err(di->dev, "%s write failed\n", __func__);
+/**
+ * ab8500_charger_set_main_in_curr() - set main charger input current
+ * @di:		pointer to the ab8500_charger structure
+ * @ich_in:	input charger current, in mA
+ *
+ * Set main charger input current.
+ * Returns error code in case of failure else 0(on success)
+ */
+static int ab8500_charger_set_main_in_curr(struct ab8500_charger *di,
+	int ich_in)
+{
+	return ab8500_charger_set_current(di, ich_in,
+		AB8500_MCH_IPT_CURLVL_REG);
+}
 
-	return ret;
+/**
+ * ab8500_charger_set_output_curr() - set charger output current
+ * @di:		pointer to the ab8500_charger structure
+ * @ich_out:	output charger current, in mA
+ *
+ * Set charger output current.
+ * Returns error code in case of failure else 0(on success)
+ */
+static int ab8500_charger_set_output_curr(struct ab8500_charger *di,
+	int ich_out)
+{
+	return ab8500_charger_set_current(di, ich_out,
+		AB8500_CH_OPT_CRNTLVL_REG);
 }
 
 /**
@@ -1090,18 +1192,19 @@ static int ab8500_charger_ac_en(struct ux500_charger *charger,
 			return ret;
 		}
 		/* MainChInputCurr: current that can be drawn from the charger*/
-		ret = abx500_set_register_interruptible(di->dev, AB8500_CHARGER,
-			AB8500_MCH_IPT_CURLVL_REG,
-			input_curr_index << MAIN_CH_INPUT_CURR_SHIFT);
+		ret = ab8500_charger_set_main_in_curr(di,
+			di->bat->chg_params->ac_curr_max);
 		if (ret) {
-			dev_err(di->dev, "%s write failed\n", __func__);
+			dev_err(di->dev, "%s Failed to set MainChInputCurr\n",
+				__func__);
 			return ret;
 		}
 		/* ChOutputCurentLevel: protected output current */
-		ret = abx500_set_register_interruptible(di->dev, AB8500_CHARGER,
-			AB8500_CH_OPT_CRNTLVL_REG, (u8) curr_index);
+		ret = ab8500_charger_set_output_curr(di, iset);
 		if (ret) {
-			dev_err(di->dev, "%s write failed\n", __func__);
+			dev_err(di->dev, "%s "
+				"Failed to set ChOutputCurentLevel\n",
+				__func__);
 			return ret;
 		}
 
@@ -1158,12 +1261,11 @@ static int ab8500_charger_ac_en(struct ux500_charger *charger,
 				return ret;
 			}
 
-			ret = abx500_set_register_interruptible(di->dev,
-				AB8500_CHARGER,
-				AB8500_CH_OPT_CRNTLVL_REG, CH_OP_CUR_LVL_0P1);
+			ret = ab8500_charger_set_output_curr(di, 0);
 			if (ret) {
-				dev_err(di->dev,
-					"%s write failed\n", __func__);
+				dev_err(di->dev, "%s "
+					"Failed to set ChOutputCurentLevel\n",
+					__func__);
 				return ret;
 			}
 		} else {
@@ -1266,10 +1368,11 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
 			return ret;
 		}
 		/* ChOutputCurentLevel: protected output current */
-		ret = abx500_set_register_interruptible(di->dev, AB8500_CHARGER,
-			AB8500_CH_OPT_CRNTLVL_REG, (u8) curr_index);
+		ret = ab8500_charger_set_output_curr(di, ich_out);
 		if (ret) {
-			dev_err(di->dev, "%s write failed\n", __func__);
+			dev_err(di->dev, "%s "
+				"Failed to set ChOutputCurentLevel\n",
+				__func__);
 			return ret;
 		}
 		/* Check if VBAT overshoot control should be enabled */
@@ -1366,7 +1469,6 @@ static int ab8500_charger_update_charger_current(struct ux500_charger *charger,
 		int ich_out)
 {
 	int ret;
-	int curr_index;
 	struct ab8500_charger *di;
 
 	if (charger->psy.type == POWER_SUPPLY_TYPE_MAINS)
@@ -1376,18 +1478,11 @@ static int ab8500_charger_update_charger_current(struct ux500_charger *charger,
 	else
 		return -ENXIO;
 
-	curr_index = ab8500_current_to_regval(ich_out);
-	if (curr_index < 0) {
-		dev_err(di->dev,
-			"Charger current too high, "
-			"charging not started\n");
-		return -ENXIO;
-	}
-
-	ret = abx500_set_register_interruptible(di->dev, AB8500_CHARGER,
-		AB8500_CH_OPT_CRNTLVL_REG, (u8) curr_index);
+	ret = ab8500_charger_set_output_curr(di, ich_out);
 	if (ret) {
-		dev_err(di->dev, "%s write failed\n", __func__);
+		dev_err(di->dev, "%s "
+			"Failed to set ChOutputCurentLevel\n",
+			__func__);
 		return ret;
 	}
 
-- 
1.7.9.5

