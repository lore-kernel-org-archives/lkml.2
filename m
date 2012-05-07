Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab2EGSNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 14:13:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:63821 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab2EGSNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 14:13:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163036494"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH] charger_manager: update charge profile upon temperature zone change
Date: Mon,  7 May 2012 22:16:12 +0530
Message-Id: <1336409172-4058-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Battery vendors like UER suggest to program Low Charge Voltage in case
of high or low temperatures. So a battery can have different charge profile
with in the battery operating temperature limits.

Next, there could be events like drop or rise in VBUS voltage in that case
we might have to adjust the charge current to stabilize VBUS voltage.

This patch allows the Charger-Manager to adjust the charging parameters
upon events like VBUS rise or drop and allows batteries to have multiple
charge profiles for different temperature zones.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 drivers/power/charger-manager.c       |    6 +++++-
 include/linux/power/charger-manager.h |    5 +++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 86935ec..9f46353 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -424,13 +424,17 @@ static void fullbatt_vchk(struct work_struct *work)
 static bool _cm_monitor(struct charger_manager *cm)
 {
 	struct charger_desc *desc = cm->desc;
+	bool update_charger = false;
 	int temp = desc->temperature_out_of_range(&cm->last_temp_mC);
 
 	dev_dbg(cm->dev, "monitoring (%2.2d.%3.3dC)\n",
 		cm->last_temp_mC / 1000, cm->last_temp_mC % 1000);
 
+	if (desc->charging_zone_changed)
+		update_charger = desc->charging_zone_changed(cm->last_temp_mC);
+
 	/* It has been stopped or charging already */
-	if (!!temp == !!cm->emergency_stop)
+	if ((!!temp == !!cm->emergency_stop) && !update_charger)
 		return false;
 
 	if (temp) {
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index 241065c..302107d 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -90,6 +90,10 @@ struct charger_global_desc {
  *	return_value > 0: overheat
  *	return_value == 0: normal
  *	return_value < 0: cold
+ * @charging_zone_changed:
+ *	Determine whether charge profile need an update
+ *	return_value true if charge profile update required
+ *	return_value false if charge profile update is not required
  * @measure_battery_temp:
  *	true: measure battery temperature
  *	false: measure ambient temperature
@@ -114,6 +118,7 @@ struct charger_desc {
 	char *psy_fuel_gauge;
 
 	int (*temperature_out_of_range)(int *mC);
+	bool (*charging_zone_changed)(int mC);
 	bool measure_battery_temp;
 };
 
-- 
1.7.0.4

