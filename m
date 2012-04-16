Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab2DPIr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 04:47:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:41642 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab2DPIr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 04:47:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="154066863"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: anton.vorontsov@linaro.org, alan@linux.intel.com,
        bruce.e.robertson@intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 2/4] power-supply: smb347-charger: rename few functions to match better what they are doing
Date: Mon, 16 Apr 2012 11:48:39 +0300
Message-Id: <1334566121-8243-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334566121-8243-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1334566121-8243-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The naming used in the driver for some functions is not very clear what the
functions are really doing. To make this a bit easier to understand we rename
few functions which were badly named.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/power/smb347-charger.c |   42 ++++++++++++++++++++--------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
index 066794d..d774fd3 100644
--- a/drivers/power/smb347-charger.c
+++ b/drivers/power/smb347-charger.c
@@ -235,14 +235,14 @@ static int smb347_write(struct smb347_charger *smb, u8 reg, u8 val)
 }
 
 /**
- * smb347_update_status - updates the charging status
+ * smb347_update_ps_status - refreshes the power source status
  * @smb: pointer to smb347 charger instance
  *
- * Function checks status of the charging and updates internal state
- * accordingly. Returns %0 if there is no change in status, %1 if the
- * status has changed and negative errno in case of failure.
+ * Function checks whether any power source is connected to the charger and
+ * updates internal state accordingly. If there is a change to previous state
+ * function returns %1, otherwise %0 and negative errno in case of errror.
  */
-static int smb347_update_status(struct smb347_charger *smb)
+static int smb347_update_ps_status(struct smb347_charger *smb)
 {
 	bool usb = false;
 	bool dc = false;
@@ -271,15 +271,15 @@ static int smb347_update_status(struct smb347_charger *smb)
 }
 
 /*
- * smb347_is_online - returns whether input power source is connected
+ * smb347_is_ps_online - returns whether input power source is connected
  * @smb: pointer to smb347 charger instance
  *
  * Returns %true if input power source is connected. Note that this is
  * dependent on what platform has configured for usable power sources. For
- * example if USB is disabled, this will return %false even if the USB
- * cable is connected.
+ * example if USB is disabled, this will return %false even if the USB cable
+ * is connected.
  */
-static bool smb347_is_online(struct smb347_charger *smb)
+static bool smb347_is_ps_online(struct smb347_charger *smb)
 {
 	bool ret;
 
@@ -301,7 +301,7 @@ static int smb347_charging_status(struct smb347_charger *smb)
 {
 	int ret;
 
-	if (!smb347_is_online(smb))
+	if (!smb347_is_ps_online(smb))
 		return 0;
 
 	ret = smb347_read(smb, STAT_C);
@@ -351,7 +351,7 @@ static inline int smb347_charging_disable(struct smb347_charger *smb)
 	return smb347_charging_set(smb, false);
 }
 
-static int smb347_update_online(struct smb347_charger *smb)
+static int smb347_start_stop_charging(struct smb347_charger *smb)
 {
 	int ret;
 
@@ -360,7 +360,7 @@ static int smb347_update_online(struct smb347_charger *smb)
 	 * disable or enable the charging. We do it manually because it
 	 * depends on how the platform has configured the valid inputs.
 	 */
-	if (smb347_is_online(smb)) {
+	if (smb347_is_ps_online(smb)) {
 		ret = smb347_charging_enable(smb);
 		if (ret < 0)
 			dev_err(&smb->client->dev,
@@ -749,11 +749,11 @@ static int smb347_hw_init(struct smb347_charger *smb)
 	if (ret < 0)
 		goto fail;
 
-	ret = smb347_update_status(smb);
+	ret = smb347_update_ps_status(smb);
 	if (ret < 0)
 		goto fail;
 
-	ret = smb347_update_online(smb);
+	ret = smb347_start_stop_charging(smb);
 
 fail:
 	smb347_set_writable(smb, false);
@@ -814,8 +814,8 @@ static irqreturn_t smb347_interrupt(int irq, void *data)
 	 * was connected or disconnected.
 	 */
 	if (irqstat_e & (IRQSTAT_E_USBIN_UV_IRQ | IRQSTAT_E_DCIN_UV_IRQ)) {
-		if (smb347_update_status(smb) > 0) {
-			smb347_update_online(smb);
+		if (smb347_update_ps_status(smb) > 0) {
+			smb347_start_stop_charging(smb);
 			power_supply_changed(&smb->mains);
 			power_supply_changed(&smb->usb);
 		}
@@ -987,13 +987,13 @@ static int smb347_battery_get_property(struct power_supply *psy,
 	const struct smb347_charger_platform_data *pdata = smb->pdata;
 	int ret;
 
-	ret = smb347_update_status(smb);
+	ret = smb347_update_ps_status(smb);
 	if (ret < 0)
 		return ret;
 
 	switch (prop) {
 	case POWER_SUPPLY_PROP_STATUS:
-		if (!smb347_is_online(smb)) {
+		if (!smb347_is_ps_online(smb)) {
 			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
 			break;
 		}
@@ -1004,7 +1004,7 @@ static int smb347_battery_get_property(struct power_supply *psy,
 		break;
 
 	case POWER_SUPPLY_PROP_CHARGE_TYPE:
-		if (!smb347_is_online(smb))
+		if (!smb347_is_ps_online(smb))
 			return -ENODATA;
 
 		/*
@@ -1037,7 +1037,7 @@ static int smb347_battery_get_property(struct power_supply *psy,
 		break;
 
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		if (!smb347_is_online(smb))
+		if (!smb347_is_ps_online(smb))
 			return -ENODATA;
 		ret = smb347_read(smb, STAT_A);
 		if (ret < 0)
@@ -1051,7 +1051,7 @@ static int smb347_battery_get_property(struct power_supply *psy,
 		break;
 
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
-		if (!smb347_is_online(smb))
+		if (!smb347_is_ps_online(smb))
 			return -ENODATA;
 
 		ret = smb347_read(smb, STAT_B);
-- 
1.7.9.1

