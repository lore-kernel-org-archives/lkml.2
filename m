Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab2FSPoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:44:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62077 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab2FSPoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:44:12 -0400
Date: Tue, 19 Jun 2012 17:43:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: [PATCH 1/2 v3] regulator: support multiple dummy fixed regulators
In-Reply-To: <20120618172808.GX3974@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1206191742030.6204@axis700.grange>
References: <20120618094145.GC3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181145520.23884@axis700.grange>
 <20120618100657.GG3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181212180.23884@axis700.grange>
 <20120618115738.GI3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181755370.23884@axis700.grange>
 <20120618162058.GT3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181826210.23884@axis700.grange>
 <20120618163758.GU3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181850280.23884@axis700.grange>
 <20120618172808.GX3974@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:K8EhOXckxN9sCd2XRrZ33L+8L25/8PpxfPVb1tAVouP
 6lcpdDcbWx1Um5tBvT8QX77/hp3dD5pQMEjYSTcHuH9VtTMvxf
 EJHDyhjsf/VSfOGNKnCQ6MXyDI8crDxaFpw2FUsK+tj1SLSIm8
 uxBu+V13ebzowsk1Zk7R1EsszakOpA1vbxXjl21zwrCE9vrZY9
 ejIe5um8AoZLaAqkpt7urQNyaMZEmpC6M62lCRWwklMoOJwN/3
 +7l8ScNHcybJA/APlm49NRq2CE/jp4/psHNHAkNcc6rbxLQI3O
 X6yD+17x0iSxu25C9vhi6TCfmKxN+y7dEck/HulHxGYdKPZ2do
 /lIwtizHW1lQiadQ20mwr8bU42of+FjqDvK7NqbNkBqa3dTTFQ
 JVYhDxZYX024g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently regulator_register_fixed() uses a constant name to register a
fixed dummy regulator. This is sufficient in principle, since there is no
reason to register multiple such regulators. The user can simply supply all
consumers in one array and use it to initialise such a regulator. However,
in some cases it can be convenient to register multiple such regulators.
This is also a prerequisite for the upcoming patch, that will add a voltage
parameter to this function. The original function is provided as a wrapper
macro.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

v3: Let user provide a name. Thanks to Mark for comments.

 drivers/regulator/fixed-helper.c |   14 +++++++++++---
 include/linux/regulator/fixed.h  |    7 +++++--
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/fixed-helper.c b/drivers/regulator/fixed-helper.c
index cacd33c..3aa268d 100644
--- a/drivers/regulator/fixed-helper.c
+++ b/drivers/regulator/fixed-helper.c
@@ -1,4 +1,5 @@
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
@@ -13,16 +14,18 @@ static void regulator_fixed_release(struct device *dev)
 {
 	struct fixed_regulator_data *data = container_of(dev,
 			struct fixed_regulator_data, pdev.dev);
+	kfree(data->cfg.supply_name);
 	kfree(data);
 }
 
 /**
- * regulator_register_fixed - register a no-op fixed regulator
+ * regulator_register_fixed_name - register a no-op fixed regulator
  * @id: platform device id
+ * @name: name to be used for the regulator
  * @supplies: consumers for this regulator
  * @num_supplies: number of consumers
  */
-struct platform_device *regulator_register_fixed(int id,
+struct platform_device *regulator_register_always_on(int id, const char *name,
 		struct regulator_consumer_supply *supplies, int num_supplies)
 {
 	struct fixed_regulator_data *data;
@@ -31,7 +34,12 @@ struct platform_device *regulator_register_fixed(int id,
 	if (!data)
 		return NULL;
 
-	data->cfg.supply_name = "fixed-dummy";
+	data->cfg.supply_name = kstrdup(name, GFP_KERNEL);
+	if (!data->cfg.supply_name) {
+		kfree(data);
+		return NULL;
+	}
+
 	data->cfg.microvolts = 0;
 	data->cfg.gpio = -EINVAL;
 	data->cfg.enabled_at_boot = 1;
diff --git a/include/linux/regulator/fixed.h b/include/linux/regulator/fixed.h
index f83f744..6b9325b 100644
--- a/include/linux/regulator/fixed.h
+++ b/include/linux/regulator/fixed.h
@@ -58,14 +58,17 @@ struct fixed_voltage_config {
 struct regulator_consumer_supply;
 
 #if IS_ENABLED(CONFIG_REGULATOR)
-struct platform_device *regulator_register_fixed(int id,
+struct platform_device *regulator_register_always_on(int id, const char *name,
 		struct regulator_consumer_supply *supplies, int num_supplies);
 #else
-static inline struct platform_device *regulator_register_fixed(int id,
+static inline struct platform_device *regulator_register_always_on(int id, const char *name,
 		struct regulator_consumer_supply *supplies, int num_supplies)
 {
 	return NULL;
 }
 #endif
 
+#define regulator_register_fixed(id, s, ns) regulator_register_always_on(id, \
+						"fixed-dummy", s, ns)
+
 #endif
-- 
1.7.2.5

