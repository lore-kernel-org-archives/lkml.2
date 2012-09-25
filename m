Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab2IYQOC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:14:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab2IYQN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:58 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 37/57] power: ab8500_bm: Quick re-attach charging behaviour
Date: Tue, 25 Sep 2012 10:12:34 -0600
Message-Id: <1348589574-25655-38-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kalle Komierowski <karl.komierowski@stericsson.com>

Due to a bug in some AB8500 ASICs charger removal cannot always
be detected if the removal and reinsertion is done to close in time.
This patch detects above described case and handles the situation
so that charging will be kept turned on.

Signed-off-by: Kalle Komierowski <karl.komierowski@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/power/ab8500_charger.c            |  105 ++++++++++++++++++++++++++++-
 drivers/power/abx500_chargalg.c           |   31 ++++++++-
 include/linux/mfd/abx500/ux500_chargalg.h |    1 +
 3 files changed, 134 insertions(+), 3 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 8137ea5..70e7c5e 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -49,6 +49,7 @@
 #define VBUS_DET_DBNC100		0x02
 #define VBUS_DET_DBNC1			0x01
 #define OTP_ENABLE_WD			0x01
+#define DROP_COUNT_RESET		0x01
 
 #define MAIN_CH_INPUT_CURR_SHIFT	4
 #define VBUS_IN_CURR_LIM_SHIFT		4
@@ -1672,6 +1673,105 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
 }
 
 /**
+ * ab8500_charger_usb_check_enable() - enable usb charging
+ * @charger:	pointer to the ux500_charger structure
+ * @vset:	charging voltage
+ * @iset:	charger output current
+ *
+ * Check if the VBUS charger has been disconnected and reconnected without
+ * AB8500 rising an interrupt. Returns 0 on success.
+ */
+static int ab8500_charger_usb_check_enable(struct ux500_charger *charger,
+	int vset, int iset)
+{
+	u8 usbch_ctrl1 = 0;
+	int ret = 0;
+
+	struct ab8500_charger *di = to_ab8500_charger_usb_device_info(charger);
+
+	if (!di->usb.charger_connected)
+		return ret;
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
+				AB8500_USBCH_CTRL1_REG, &usbch_ctrl1);
+	if (ret < 0) {
+		dev_err(di->dev, "ab8500 read failed %d\n", __LINE__);
+		return ret;
+	}
+	dev_dbg(di->dev, "USB charger ctrl: 0x%02x\n", usbch_ctrl1);
+
+	if (!(usbch_ctrl1 & USB_CH_ENA)) {
+		dev_info(di->dev, "Charging has been disabled abnormally and will be re-enabled\n");
+
+		ret = abx500_mask_and_set_register_interruptible(di->dev,
+					AB8500_CHARGER, AB8500_CHARGER_CTRL,
+					DROP_COUNT_RESET, DROP_COUNT_RESET);
+		if (ret < 0) {
+			dev_err(di->dev, "ab8500 write failed %d\n", __LINE__);
+			return ret;
+		}
+
+		ret = ab8500_charger_usb_en(&di->usb_chg, true, vset, iset);
+		if (ret < 0) {
+			dev_err(di->dev, "Failed to enable VBUS charger %d\n",
+					__LINE__);
+			return ret;
+		}
+	}
+	return ret;
+}
+
+/**
+ * ab8500_charger_ac_check_enable() - enable usb charging
+ * @charger:	pointer to the ux500_charger structure
+ * @vset:	charging voltage
+ * @iset:	charger output current
+ *
+ * Check if the AC charger has been disconnected and reconnected without
+ * AB8500 rising an interrupt. Returns 0 on success.
+ */
+static int ab8500_charger_ac_check_enable(struct ux500_charger *charger,
+	int vset, int iset)
+{
+	u8 mainch_ctrl1 = 0;
+	int ret = 0;
+
+	struct ab8500_charger *di = to_ab8500_charger_ac_device_info(charger);
+
+	if (!di->ac.charger_connected)
+		return ret;
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
+				AB8500_MCH_CTRL1, &mainch_ctrl1);
+	if (ret < 0) {
+		dev_err(di->dev, "ab8500 read failed %d\n", __LINE__);
+		return ret;
+	}
+	dev_dbg(di->dev, "AC charger ctrl: 0x%02x\n", mainch_ctrl1);
+
+	if (!(mainch_ctrl1 & MAIN_CH_ENA)) {
+		dev_info(di->dev, "Charging has been disabled abnormally and will be re-enabled\n");
+
+		ret = abx500_mask_and_set_register_interruptible(di->dev,
+					AB8500_CHARGER, AB8500_CHARGER_CTRL,
+					DROP_COUNT_RESET, DROP_COUNT_RESET);
+
+		if (ret < 0) {
+			dev_err(di->dev, "ab8500 write failed %d\n", __LINE__);
+			return ret;
+		}
+
+		ret = ab8500_charger_ac_en(&di->usb_chg, true, vset, iset);
+		if (ret < 0) {
+			dev_err(di->dev, "failed to enable AC charger %d\n",
+				__LINE__);
+			return ret;
+		}
+	}
+	return ret;
+}
+
+/**
  * ab8500_charger_watchdog_kick() - kick charger watchdog
  * @di:		pointer to the ab8500_charger structure
  *
@@ -1728,8 +1828,7 @@ static int ab8500_charger_update_charger_current(struct ux500_charger *charger,
 
 	/* Reset the main and usb drop input current measurement counter */
 	ret = abx500_set_register_interruptible(di->dev, AB8500_CHARGER,
-				AB8500_CHARGER_CTRL,
-				0x1);
+					AB8500_CHARGER_CTRL, DROP_COUNT_RESET);
 	if (ret) {
 		dev_err(di->dev, "%s write failed\n", __func__);
 		return ret;
@@ -3197,6 +3296,7 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	di->ac_chg.psy.num_supplicants = di->pdata->num_supplicants;
 	/* ux500_charger sub-class */
 	di->ac_chg.ops.enable = &ab8500_charger_ac_en;
+	di->ac_chg.ops.check_enable = &ab8500_charger_ac_check_enable;
 	di->ac_chg.ops.kick_wd = &ab8500_charger_watchdog_kick;
 	di->ac_chg.ops.update_curr = &ab8500_charger_update_charger_current;
 	di->ac_chg.max_out_volt = ab8500_charger_voltage_map[
@@ -3218,6 +3318,7 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	di->usb_chg.psy.num_supplicants = di->pdata->num_supplicants;
 	/* ux500_charger sub-class */
 	di->usb_chg.ops.enable = &ab8500_charger_usb_en;
+	di->usb_chg.ops.check_enable = &ab8500_charger_usb_check_enable;
 	di->usb_chg.ops.kick_wd = &ab8500_charger_watchdog_kick;
 	di->usb_chg.ops.update_curr = &ab8500_charger_update_charger_current;
 	di->usb_chg.max_out_volt = ab8500_charger_voltage_map[
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 4e3d20f..9568f63 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -311,6 +311,29 @@ static void abx500_chargalg_state_to(struct abx500_chargalg *di,
 	di->charge_state = state;
 }
 
+static int abx500_chargalg_check_charger_enable(struct abx500_chargalg *di)
+{
+	switch (di->charge_state) {
+	case STATE_NORMAL:
+	case STATE_MAINTENANCE_A:
+	case STATE_MAINTENANCE_B:
+		break;
+	default:
+		return 0;
+	}
+
+	if (di->chg_info.charger_type & USB_CHG) {
+		return di->usb_chg->ops.check_enable(di->usb_chg,
+			di->bat->bat_type[di->bat->batt_id].normal_vol_lvl,
+			di->bat->bat_type[di->bat->batt_id].normal_cur_lvl);
+	} else if (di->chg_info.charger_type & AC_CHG) {
+		return di->ac_chg->ops.check_enable(di->ac_chg,
+			di->bat->bat_type[di->bat->batt_id].normal_vol_lvl,
+			di->bat->bat_type[di->bat->batt_id].normal_cur_lvl);
+	}
+	return -ENXIO;
+}
+
 /**
  * abx500_chargalg_check_charger_connection() - Check charger connection change
  * @di:		pointer to the abx500_chargalg structure
@@ -1220,6 +1243,7 @@ static void abx500_chargalg_external_power_changed(struct power_supply *psy)
 static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 {
 	int charger_status;
+	int ret;
 
 	/* Collect data from all power_supply class devices */
 	class_for_each_device(power_supply_class, NULL,
@@ -1228,8 +1252,13 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 	abx500_chargalg_end_of_charge(di);
 	abx500_chargalg_check_temp(di);
 	abx500_chargalg_check_charger_voltage(di);
-
 	charger_status = abx500_chargalg_check_charger_connection(di);
+
+	ret = abx500_chargalg_check_charger_enable(di);
+	if (ret < 0)
+		dev_err(di->dev, "Checking charger if enabled error: %d line: %d\n",
+				ret, __LINE__);
+
 	/*
 	 * First check if we have a charger connected.
 	 * Also we don't allow charging of unknown batteries if configured
diff --git a/include/linux/mfd/abx500/ux500_chargalg.h b/include/linux/mfd/abx500/ux500_chargalg.h
index d43ac0f..110d12f 100644
--- a/include/linux/mfd/abx500/ux500_chargalg.h
+++ b/include/linux/mfd/abx500/ux500_chargalg.h
@@ -17,6 +17,7 @@ struct ux500_charger;
 
 struct ux500_charger_ops {
 	int (*enable) (struct ux500_charger *, int, int, int);
+	int (*check_enable) (struct ux500_charger *, int, int);
 	int (*kick_wd) (struct ux500_charger *);
 	int (*update_curr) (struct ux500_charger *, int);
 };
-- 
1.7.5.4

