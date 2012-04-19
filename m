Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab2DSMfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:35:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:62560 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab2DSMfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:35:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="143603829"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>
Subject: [PATCH v2] smb347_charger: Cleanup power supply registration code in probe
Date: Thu, 19 Apr 2012 10:00:18 +0530
Message-Id: <1334809818-5958-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch checks if the usb or mains charging is enabled by the
platform before registering with the power supply class.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 drivers/power/smb347-charger.c |   70 +++++++++++++++++++++++-----------------
 1 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
index ce1694d..3e9df6e 100644
--- a/drivers/power/smb347-charger.c
+++ b/drivers/power/smb347-charger.c
@@ -816,8 +816,10 @@ static irqreturn_t smb347_interrupt(int irq, void *data)
 	if (irqstat_e & (IRQSTAT_E_USBIN_UV_IRQ | IRQSTAT_E_DCIN_UV_IRQ)) {
 		if (smb347_update_status(smb) > 0) {
 			smb347_update_online(smb);
-			power_supply_changed(&smb->mains);
-			power_supply_changed(&smb->usb);
+			if (smb->pdata->use_mains)
+				power_supply_changed(&smb->mains);
+			if (smb->pdata->use_usb)
+				power_supply_changed(&smb->usb);
 		}
 		ret = IRQ_HANDLED;
 	}
@@ -1185,21 +1187,34 @@ static int smb347_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
-	smb->mains.name = "smb347-mains";
-	smb->mains.type = POWER_SUPPLY_TYPE_MAINS;
-	smb->mains.get_property = smb347_mains_get_property;
-	smb->mains.properties = smb347_mains_properties;
-	smb->mains.num_properties = ARRAY_SIZE(smb347_mains_properties);
-	smb->mains.supplied_to = battery;
-	smb->mains.num_supplicants = ARRAY_SIZE(battery);
-
-	smb->usb.name = "smb347-usb";
-	smb->usb.type = POWER_SUPPLY_TYPE_USB;
-	smb->usb.get_property = smb347_usb_get_property;
-	smb->usb.properties = smb347_usb_properties;
-	smb->usb.num_properties = ARRAY_SIZE(smb347_usb_properties);
-	smb->usb.supplied_to = battery;
-	smb->usb.num_supplicants = ARRAY_SIZE(battery);
+	if (smb->pdata->use_mains) {
+		smb->mains.name = "smb347-mains";
+		smb->mains.type = POWER_SUPPLY_TYPE_MAINS;
+		smb->mains.get_property = smb347_mains_get_property;
+		smb->mains.properties = smb347_mains_properties;
+		smb->mains.num_properties = ARRAY_SIZE(smb347_mains_properties);
+		smb->mains.supplied_to = battery;
+		smb->mains.num_supplicants = ARRAY_SIZE(battery);
+		ret = power_supply_register(dev, &smb->mains);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (smb->pdata->use_usb) {
+		smb->usb.name = "smb347-usb";
+		smb->usb.type = POWER_SUPPLY_TYPE_USB;
+		smb->usb.get_property = smb347_usb_get_property;
+		smb->usb.properties = smb347_usb_properties;
+		smb->usb.num_properties = ARRAY_SIZE(smb347_usb_properties);
+		smb->usb.supplied_to = battery;
+		smb->usb.num_supplicants = ARRAY_SIZE(battery);
+		ret = power_supply_register(dev, &smb->usb);
+		if (ret < 0) {
+			if (smb->pdata->use_mains)
+				power_supply_unregister(&smb->mains);
+			return ret;
+		}
+	}
 
 	smb->battery.name = "smb347-battery";
 	smb->battery.type = POWER_SUPPLY_TYPE_BATTERY;
@@ -1207,20 +1222,13 @@ static int smb347_probe(struct i2c_client *client,
 	smb->battery.properties = smb347_battery_properties;
 	smb->battery.num_properties = ARRAY_SIZE(smb347_battery_properties);
 
-	ret = power_supply_register(dev, &smb->mains);
-	if (ret < 0)
-		return ret;
-
-	ret = power_supply_register(dev, &smb->usb);
-	if (ret < 0) {
-		power_supply_unregister(&smb->mains);
-		return ret;
-	}
 
 	ret = power_supply_register(dev, &smb->battery);
 	if (ret < 0) {
-		power_supply_unregister(&smb->usb);
-		power_supply_unregister(&smb->mains);
+		if (smb->pdata->use_usb)
+			power_supply_unregister(&smb->usb);
+		if (smb->pdata->use_mains)
+			power_supply_unregister(&smb->mains);
 		return ret;
 	}
 
@@ -1255,8 +1263,10 @@ static int smb347_remove(struct i2c_client *client)
 	}
 
 	power_supply_unregister(&smb->battery);
-	power_supply_unregister(&smb->usb);
-	power_supply_unregister(&smb->mains);
+	if (smb->pdata->use_usb)
+		power_supply_unregister(&smb->usb);
+	if (smb->pdata->use_mains)
+		power_supply_unregister(&smb->mains);
 	return 0;
 }
 
-- 
1.7.0.4

