Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab2FRP6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:58:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65140 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab2FRP5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:57:30 -0400
Date: Mon, 18 Jun 2012 17:57:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: [PATCH 2/2 v2] regulator: extend the fixed dummy voltage regulator
 to accept voltage
In-Reply-To: <Pine.LNX.4.64.1206181755370.23884@axis700.grange>
Message-ID: <Pine.LNX.4.64.1206181756190.23884@axis700.grange>
References: <Pine.LNX.4.64.1206181017360.23884@axis700.grange>
 <20120618094145.GC3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181145520.23884@axis700.grange>
 <20120618100657.GG3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181212180.23884@axis700.grange>
 <20120618115738.GI3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181755370.23884@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:+nrylLLtBAMB9HJdOLdHxTRCCUZ/q1lnSDDs1VdTG9v
 ZXWCpoFQebrF+XY+I6fnukPwbTK7gLYSTkVRsAU4yZZlQMKr7F
 +GKBwh1HZ6bYRMkkInyKsZVYETb0j/giIhogxEnG1d6FOjkBlL
 rprDbufCU4s+73ilzU1PVd8c9068B+6OynJYP9UxH2e0v0NtXW
 il3BXjyt9h6SAECSdrx8Zu99DU63sOjuww9pLxeWcX9LbntEYP
 mXH7toIIUbmn8lHVFhGXVTOhjaP/L2E96cnPIMauMNzj1AGTCc
 I+tmVjEIeneJUp8B7h9I9XLxG7uY5uj7aa/6ZAj5NRnAOTBeSw
 88RH8+R0l/fGhKWeQrCvcDW2kgFdLk4h5TkweE66FbbIrhiIf+
 Q43w388u8bQqQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivially extend the regulator_register_fixed() helper function to be even
more useful by letting it accept a voltage parameter. The original function
is provided as a wrapper macro.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/regulator/fixed-helper.c |    9 +++++----
 include/linux/regulator/fixed.h  |   10 ++++++----
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/fixed-helper.c b/drivers/regulator/fixed-helper.c
index f66d9e8..d979ff0 100644
--- a/drivers/regulator/fixed-helper.c
+++ b/drivers/regulator/fixed-helper.c
@@ -22,13 +22,14 @@ static void regulator_fixed_release(struct device *dev)
 }
 
 /**
- * regulator_register_fixed - register a no-op fixed regulator
+ * regulator_register_fixed_volt - register a no-op fixed regulator
  * @id: platform device id
  * @supplies: consumers for this regulator
  * @num_supplies: number of consumers
+ * @uv: voltage in microvolts
  */
-struct platform_device *regulator_register_fixed(int id,
-		struct regulator_consumer_supply *supplies, int num_supplies)
+struct platform_device *regulator_register_fixed_volt(int id,
+	struct regulator_consumer_supply *supplies, int num_supplies, int uv)
 {
 	struct fixed_regulator_data *data;
 
@@ -42,7 +43,7 @@ struct platform_device *regulator_register_fixed(int id,
 		snprintf(data->name, sizeof(FIXED_NAME), FIXED_BASE "-%d", id);
 
 	data->cfg.supply_name = data->name;
-	data->cfg.microvolts = 0;
+	data->cfg.microvolts = uv;
 	data->cfg.gpio = -EINVAL;
 	data->cfg.enabled_at_boot = 1;
 	data->cfg.init_data = &data->init_data;
diff --git a/include/linux/regulator/fixed.h b/include/linux/regulator/fixed.h
index f83f744..1735f0a 100644
--- a/include/linux/regulator/fixed.h
+++ b/include/linux/regulator/fixed.h
@@ -58,14 +58,16 @@ struct fixed_voltage_config {
 struct regulator_consumer_supply;
 
 #if IS_ENABLED(CONFIG_REGULATOR)
-struct platform_device *regulator_register_fixed(int id,
-		struct regulator_consumer_supply *supplies, int num_supplies);
+struct platform_device *regulator_register_fixed_volt(int id,
+	struct regulator_consumer_supply *supplies, int num_supplies, int uv);
 #else
-static inline struct platform_device *regulator_register_fixed(int id,
-		struct regulator_consumer_supply *supplies, int num_supplies)
+static inline struct platform_device *regulator_register_fixed_volt(int id,
+	struct regulator_consumer_supply *supplies, int num_supplies, int uv)
 {
 	return NULL;
 }
 #endif
 
+#define regulator_register_fixed(id, s, ns) regulator_register_fixed_volt(id, s, ns, 0)
+
 #endif
-- 
1.7.2.5

