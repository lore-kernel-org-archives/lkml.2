Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab2FRITs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:19:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56932 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab2FRITr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:19:47 -0400
Date: Mon, 18 Jun 2012 10:19:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH] regulator: extend the fixed voltage regulator to accept
 voltage
Message-ID: <Pine.LNX.4.64.1206181017360.23884@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:iXcljTHxhHkN0AC0Qa/LvLqvnW+tpN3mtnZookl8T1Q
 g6PenN2tE8gyLS13mBJDGTqz3y8N4Pr1DbdO6zn0A/YXQh0lLw
 hib5Uqk7lkXrTt2L2SB7BG06aFmcS7nUYMjYR7vbQwqfrjDt/R
 VwdoPVaFy+/yL0wQrkqt9IrC/z2c//XECtKxO2X1GoSbsTuyJ7
 SypQ8u9JzGhKZfCqlwBNzATrK2TFKYbxn/MTCSAIqmNF1Vlgub
 yDmu+wcfo9wY5OWT6nhKZp6rsXJiTd8jExlMZWdv3suewOzg/g
 DXNrAA9uyQPXl/tTItEVE+kpXjmcGAMzbp6MtC19N1OROTrVft
 GHbylQgUg1UY5hRTH+pY6juyV3MaR850jN1YsgkZeJC8BK4v9S
 /SkK/0fRavcGA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivially extend the regulator_register_fixed() helper function to be even
more useful by letting it accept a voltage parameter. The original function
is provided as a wrapper macro.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/regulator/fixed-helper.c |   21 ++++++++++++++++-----
 include/linux/regulator/fixed.h  |   10 ++++++----
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/fixed-helper.c b/drivers/regulator/fixed-helper.c
index cacd33c..d979ff0 100644
--- a/drivers/regulator/fixed-helper.c
+++ b/drivers/regulator/fixed-helper.c
@@ -1,12 +1,17 @@
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
 
+#define FIXED_BASE "fixed-dummy"
+#define FIXED_NAME FIXED_BASE "-00"
+
 struct fixed_regulator_data {
 	struct fixed_voltage_config cfg;
 	struct regulator_init_data init_data;
 	struct platform_device pdev;
+	char name[sizeof(FIXED_NAME)];
 };
 
 static void regulator_fixed_release(struct device *dev)
@@ -17,13 +22,14 @@ static void regulator_fixed_release(struct device *dev)
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
 
@@ -31,8 +37,13 @@ struct platform_device *regulator_register_fixed(int id,
 	if (!data)
 		return NULL;
 
-	data->cfg.supply_name = "fixed-dummy";
-	data->cfg.microvolts = 0;
+	if (id < 0)
+		strcpy(data->name, FIXED_BASE);
+	else
+		snprintf(data->name, sizeof(FIXED_NAME), FIXED_BASE "-%d", id);
+
+	data->cfg.supply_name = data->name;
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

