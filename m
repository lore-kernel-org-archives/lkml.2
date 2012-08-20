Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab2HTBIf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 21:08:35 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5160 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab2HTBI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 21:08:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 19 Aug 2012 18:08:25 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: <sameo@linux.intel.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>
CC: <broonie@opensource.wolfsonmicro.com>, <ldewangan@nvidia.com>,
        <thierry.reding@avionic-design.de>, <swarren@wwwdotorg.org>,
        <xxie@nvidia.com>, <lrg@slimlogic.co.uk>, <jhovold@gmail.com>,
        <kyle.manna@fuel7.com>, <rklein@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Bill Huang <bilhuang@nvidia.com>
Subject: [PATCH v2 1/2] mfd: dt: tps6586x: Add power off control
Date: Sun, 19 Aug 2012 18:07:55 -0700
Message-ID: <1345424876-4365-2-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1345424876-4365-1-git-send-email-bilhuang@nvidia.com>
References: <1345424876-4365-1-git-send-email-bilhuang@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT property "ti,system-power-controller" telling whether or not this
pmic is in charge of controlling the system power, so the power off
routine can be hooked up to system call "pm_power_off".

Based on the work by:
Dan Willemsen <dwillemsen@nvidia.com>

Signed-off-by: Bill Huang <bilhuang@nvidia.com>
Tested-by: Stephen Warren <swarren@wwwdotorg.org>
---
 .../devicetree/bindings/regulator/tps6586x.txt     |    6 ++++++
 drivers/mfd/tps6586x.c                             |   19 +++++++++++++++++++
 include/linux/mfd/tps6586x.h                       |    1 +
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/tps6586x.txt b/Documentation/devicetree/bindings/regulator/tps6586x.txt
index d156e1b..03dfa4e 100644
--- a/Documentation/devicetree/bindings/regulator/tps6586x.txt
+++ b/Documentation/devicetree/bindings/regulator/tps6586x.txt
@@ -18,6 +18,10 @@ Required properties:
 - vinldo678-supply: The input supply for the LDO6, LDO7 and LDO8
 - vinldo9-supply: The input supply for the LDO9
 
+Optional properties:
+- ti,system-power-controller: Telling whether or not this pmic is controlling
+  the system power.
+
 Each regulator is defined using the standard binding for regulators.
 
 Example:
@@ -30,6 +34,8 @@ Example:
 		#gpio-cells = <2>;
 		gpio-controller;
 
+		ti,system-power-controller;
+
 		sm0-supply = <&some_reg>;
 		sm1-supply = <&some_reg>;
 		sm2-supply = <&some_reg>;
diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 353c348..d08f59c 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -29,6 +29,10 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps6586x.h>
 
+#define TPS6586X_SUPPLYENE	0x14
+#define EXITSLREQ_BIT		BIT(1)
+#define SLEEP_MODE_BIT		BIT(3)
+
 /* interrupt control registers */
 #define TPS6586X_INT_ACK1	0xb5
 #define TPS6586X_INT_ACK2	0xb6
@@ -409,6 +413,7 @@ static struct tps6586x_platform_data *tps6586x_parse_dt(struct i2c_client *clien
 	pdata->subdevs = devs;
 	pdata->gpio_base = -1;
 	pdata->irq_base = -1;
+	pdata->pm_off = of_property_read_bool(np, "ti,system-power-controller");
 
 	return pdata;
 }
@@ -441,6 +446,15 @@ static const struct regmap_config tps6586x_regmap_config = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
+static struct device *tps6586x_dev;
+static void tps6586x_power_off(void)
+{
+	if (tps6586x_clr_bits(tps6586x_dev, TPS6586X_SUPPLYENE, EXITSLREQ_BIT))
+		return;
+
+	tps6586x_set_bits(tps6586x_dev, TPS6586X_SUPPLYENE, SLEEP_MODE_BIT);
+}
+
 static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
@@ -505,6 +519,11 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 		goto err_add_devs;
 	}
 
+	if (pdata->pm_off && !pm_power_off) {
+		tps6586x_dev = &client->dev;
+		pm_power_off = tps6586x_power_off;
+	}
+
 	return 0;
 
 err_add_devs:
diff --git a/include/linux/mfd/tps6586x.h b/include/linux/mfd/tps6586x.h
index f350fd0..08f109f 100644
--- a/include/linux/mfd/tps6586x.h
+++ b/include/linux/mfd/tps6586x.h
@@ -77,6 +77,7 @@ struct tps6586x_platform_data {
 
 	int gpio_base;
 	int irq_base;
+	bool pm_off;
 };
 
 /*
-- 
1.7.4.1

