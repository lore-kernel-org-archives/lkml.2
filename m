Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425Ab2IYQVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:21:31 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57024 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809Ab2IYQNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:43 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 26/57] power: charge: update watchdog for pm2xxx support
Date: Tue, 25 Sep 2012 10:12:23 -0600
Message-Id: <1348589574-25655-27-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Loic Pallardy <loic.pallardy@stericsson.com>

AB and PMxxx doesn't have same watchdog refresh period
Add watchdog to refresh period parameters in x500 charger structure,
this should kick watchdog every 30sec.
The AC charging should also kick both pm2xxx
and the AB charger watchdog.

Signed-off-by: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_charger.c            |    6 ++++++
 drivers/power/abx500_chargalg.c           |   23 +++++++++++++++++++++--
 include/linux/mfd/abx500/ux500_chargalg.h |    3 +++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 3100f11..4129599 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -90,6 +90,8 @@
 
 #define CHARGER_STATUS_POLL 10 /* in ms */
 
+#define CHG_WD_INTERVAL			(60 * HZ)
+
 /* UsbLineStatus register - usb types */
 enum ab8500_charger_link_status {
 	USB_STAT_NOT_CONFIGURED,
@@ -2945,7 +2947,9 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 		ARRAY_SIZE(ab8500_charger_voltage_map) - 1];
 	di->ac_chg.max_out_curr = ab8500_charger_current_map[
 		ARRAY_SIZE(ab8500_charger_current_map) - 1];
+	di->ac_chg.wdt_refresh = CHG_WD_INTERVAL;
 	di->ac_chg.enabled = di->pdata->ac_enabled;
+	di->ac_chg.external = false;
 
 	/* USB supply */
 	/* power_supply base class */
@@ -2964,7 +2968,9 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 		ARRAY_SIZE(ab8500_charger_voltage_map) - 1];
 	di->usb_chg.max_out_curr = ab8500_charger_current_map[
 		ARRAY_SIZE(ab8500_charger_current_map) - 1];
+	di->usb_chg.wdt_refresh = CHG_WD_INTERVAL;
 	di->usb_chg.enabled = di->pdata->usb_enabled;
+	di->usb_chg.external = false;
 
 	/* Create a work queue for the charger */
 	di->charger_wq =
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index ca87cb2..d3efc2a 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -453,8 +453,18 @@ static int abx500_chargalg_kick_watchdog(struct abx500_chargalg *di)
 {
 	/* Check if charger exists and kick watchdog if charging */
 	if (di->ac_chg && di->ac_chg->ops.kick_wd &&
-			di->chg_info.online_chg & AC_CHG)
+			di->chg_info.online_chg & AC_CHG) {
+		/*
+		 * If AB charger watchdog expired, pm2xxx charging
+		 * gets disabled. To be safe, kick both AB charger watchdog
+		 * and pm2xxx watchdog.
+		 */
+		if (di->ac_chg->external &&
+				di->usb_chg && di->usb_chg->ops.kick_wd)
+			di->usb_chg->ops.kick_wd(di->usb_chg);
+
 		return di->ac_chg->ops.kick_wd(di->ac_chg);
+	}
 	else if (di->usb_chg && di->usb_chg->ops.kick_wd &&
 			di->chg_info.online_chg & USB_CHG)
 		return di->usb_chg->ops.kick_wd(di->usb_chg);
@@ -1591,6 +1601,8 @@ static void abx500_chargalg_periodic_work(struct work_struct *work)
 static void abx500_chargalg_wd_work(struct work_struct *work)
 {
 	int ret;
+	int refresh_time;
+
 	struct abx500_chargalg *di = container_of(work,
 		struct abx500_chargalg, chargalg_wd_work.work);
 
@@ -1600,8 +1612,15 @@ static void abx500_chargalg_wd_work(struct work_struct *work)
 	if (ret < 0)
 		dev_err(di->dev, "failed to kick watchdog\n");
 
+	if (di->chg_info.online_chg & AC_CHG)
+		refresh_time = di->ac_chg->wdt_refresh;
+	else if (di->chg_info.online_chg & USB_CHG)
+		refresh_time = di->usb_chg->wdt_refresh;
+	else
+		refresh_time = CHG_WD_INTERVAL;
+
 	queue_delayed_work(di->chargalg_wq,
-		&di->chargalg_wd_work, CHG_WD_INTERVAL);
+		&di->chargalg_wd_work, refresh_time);
 }
 
 /**
diff --git a/include/linux/mfd/abx500/ux500_chargalg.h b/include/linux/mfd/abx500/ux500_chargalg.h
index 5b77a61..d43ac0f 100644
--- a/include/linux/mfd/abx500/ux500_chargalg.h
+++ b/include/linux/mfd/abx500/ux500_chargalg.h
@@ -28,13 +28,16 @@ struct ux500_charger_ops {
  * @max_out_volt	maximum output charger voltage in mV
  * @max_out_curr	maximum output charger current in mA
  * @enabled		indicates if this charger is used or not
+ * @external		external charger unit (pm2xxx)
  */
 struct ux500_charger {
 	struct power_supply psy;
 	struct ux500_charger_ops ops;
 	int max_out_volt;
 	int max_out_curr;
+	int wdt_refresh;
 	bool enabled;
+	bool external;
 };
 
 #endif
-- 
1.7.5.4

