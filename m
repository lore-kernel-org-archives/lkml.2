Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab2DMRur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 13:50:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:51535 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab2DMRuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 13:50:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="132170955"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH] smb347_charger: Cleanup power supply registration code in probe
Date: Fri, 13 Apr 2012 15:14:52 +0530
Message-Id: <1334310292-22289-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch checks if the usb or mains charging is enabled by the
platform before registering with the power supply class.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 drivers/power/smb347-charger.c |   64 ++++++++++++++++++++++-----------------
 1 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
index ce1694d..1b5d2e2 100644
--- a/drivers/power/smb347-charger.c
+++ b/drivers/power/smb347-charger.c
@@ -1185,21 +1185,34 @@ static int smb347_probe(struct i2c_client *client,
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
@@ -1207,20 +1220,13 @@ static int smb347_probe(struct i2c_client *client,
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
 
@@ -1255,8 +1261,10 @@ static int smb347_remove(struct i2c_client *client)
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

