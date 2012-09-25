Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab2IYQS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:18:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab2IYQOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:14:03 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 41/57] power: ab8500_btemp: Filter btemp readings
Date: Tue, 25 Sep 2012 10:12:38 -0600
Message-Id: <1348589574-25655-42-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Berg <hakan.berg@stericsson.com>

Battery tempreature readings sometimes fails and results in
a value far from recent values. This patch adds a software
filter that disposes such readings, by allowing direct
updates on temperature only if two samples result in the
same temperature. Else only allow 1 degree change from previous
reported value in the direction of the new measurement.

Signed-off-by: Hakan Berg <hakan.berg@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Martin SJOBLOM <martin.w.sjoblom@stericsson.com>
Reviewed-by: Rabin VINCENT <rabin.vincent@stericsson.com>
---
 drivers/power/ab8500_btemp.c |   27 +++++++++++++++++++++------
 1 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 56a3bb9..b24835f 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -74,8 +74,8 @@ struct ab8500_btemp_ranges {
  * @dev:		Pointer to the structure device
  * @node:		List of AB8500 BTEMPs, hence prepared for reentrance
  * @curr_source:	What current source we use, in uA
- * @bat_temp:		Battery temperature in degree Celcius
- * @prev_bat_temp	Last dispatched battery temperature
+ * @bat_temp:		Dispatched battery temperature in degree Celcius
+ * @prev_bat_temp	Last measured battery temperature in degree Celcius
  * @parent:		Pointer to the struct ab8500
  * @gpadc:		Pointer to the struct gpadc
  * @fg:			Pointer to the struct fg
@@ -608,6 +608,7 @@ static int ab8500_btemp_id(struct ab8500_btemp *di)
 static void ab8500_btemp_periodic_work(struct work_struct *work)
 {
 	int interval;
+	int bat_temp;
 	struct ab8500_btemp *di = container_of(work,
 		struct ab8500_btemp, btemp_periodic_work.work);
 
@@ -618,12 +619,26 @@ static void ab8500_btemp_periodic_work(struct work_struct *work)
 			dev_warn(di->dev, "failed to identify the battery\n");
 	}
 
-	di->bat_temp = ab8500_btemp_measure_temp(di);
-
-	if (di->bat_temp != di->prev_bat_temp) {
-		di->prev_bat_temp = di->bat_temp;
+	bat_temp = ab8500_btemp_measure_temp(di);
+	/*
+	 * Filter battery temperature.
+	 * Allow direct updates on temperature only if two samples result in
+	 * same temperature. Else only allow 1 degree change from previous
+	 * reported value in the direction of the new measurement.
+	 */
+	if (bat_temp == di->prev_bat_temp || !di->initialized) {
+		if (di->bat_temp != di->prev_bat_temp || !di->initialized) {
+			di->bat_temp = bat_temp;
+			power_supply_changed(&di->btemp_psy);
+		}
+	} else if (bat_temp < di->prev_bat_temp) {
+		di->bat_temp--;
+		power_supply_changed(&di->btemp_psy);
+	} else if (bat_temp > di->prev_bat_temp) {
+		di->bat_temp++;
 		power_supply_changed(&di->btemp_psy);
 	}
+	di->prev_bat_temp = bat_temp;
 
 	if (di->events.ac_conn || di->events.usb_conn)
 		interval = di->bat->temp_interval_chg;
-- 
1.7.5.4

