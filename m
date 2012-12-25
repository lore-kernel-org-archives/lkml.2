Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2LYPG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 10:06:28 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2079 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab2LYPGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 10:06:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 25 Dec 2012 07:06:08 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <lrg@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 2/2] regulator: tps51632: add DT support
Date: Tue, 25 Dec 2012 20:36:00 +0530
Message-ID: <1356447960-6084-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1356447960-6084-1-git-send-email-ldewangan@nvidia.com>
References: <1356447960-6084-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT support for the TI TPS51632. Add device binding document also.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Fix compilation error which was not cought in earlier patch.
- Rebased to linux-next 20121224

 .../bindings/regulator/tps51632-regulator.txt      |   27 +++++++++
 drivers/regulator/tps51632-regulator.c             |   59 ++++++++++++++++++++
 2 files changed, 86 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/tps51632-regulator.txt

diff --git a/Documentation/devicetree/bindings/regulator/tps51632-regulator.txt b/Documentation/devicetree/bindings/regulator/tps51632-regulator.txt
new file mode 100644
index 0000000..2f7e44a
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/tps51632-regulator.txt
@@ -0,0 +1,27 @@
+TPS51632 Voltage regulators
+
+Required properties:
+- compatible: Must be "ti,tps51632"
+- reg: I2C slave address
+
+Optional properties:
+- ti,enable-pwm-dvfs: Enable the DVFS voltage control through the PWM interface.
+- ti,dvfs-step-20mV: The 20mV step voltage when PWM DVFS enabled. Missing this
+	will set 10mV step voltage in PWM DVFS mode. In normal mode, the voltage
+	step is 10mV as per datasheet.
+
+Any property defined as part of the core regulator binding, defined in
+regulator.txt, can also be used.
+
+Example:
+
+	tps51632 {
+		compatible = "ti,tps51632";
+		reg =  <0x43>;
+		regulator-name = "tps51632-vout";
+		regulator-min-microvolt = <500000>;
+		regulator-max-microvolt = <1500000>;
+		regulator-boot-on;
+		ti,enable-pwm-dvfs;
+		ti,dvfs-step-20mV;
+	};
diff --git a/drivers/regulator/tps51632-regulator.c b/drivers/regulator/tps51632-regulator.c
index b96fb0e..7560d07 100644
--- a/drivers/regulator/tps51632-regulator.c
+++ b/drivers/regulator/tps51632-regulator.c
@@ -28,10 +28,13 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/regulator/tps51632-regulator.h>
 #include <linux/slab.h>
 
@@ -252,6 +255,49 @@ static const struct regmap_config tps51632_regmap_config = {
 	.cache_type		= REGCACHE_RBTREE,
 };
 
+#if defined(CONFIG_OF)
+static const struct of_device_id tps51632_of_match[] = {
+	{ .compatible = "ti,tps51632",},
+	{},
+};
+MODULE_DEVICE_TABLE(of, tps51632_of_match);
+
+static struct tps51632_regulator_platform_data *
+	of_get_tps51632_platform_data(struct device *dev)
+{
+	struct tps51632_regulator_platform_data *pdata;
+	struct device_node *np = dev->of_node;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		dev_err(dev, "Memory alloc failed for platform data\n");
+		return NULL;
+	}
+
+	pdata->reg_init_data = of_get_regulator_init_data(dev, dev->of_node);
+	if (!pdata->reg_init_data) {
+		dev_err(dev, "Not able to get OF regulator init data\n");
+		return NULL;
+	}
+
+	pdata->enable_pwm_dvfs =
+			of_property_read_bool(np, "ti,enable-pwm-dvfs");
+	pdata->dvfs_step_20mV = of_property_read_bool(np, "ti,dvfs-step-20mV");
+
+	pdata->base_voltage_uV = pdata->reg_init_data->constraints.min_uV ? :
+					TPS51632_MIN_VOLATGE;
+	pdata->max_voltage_uV = pdata->reg_init_data->constraints.max_uV ? :
+					TPS51632_MAX_VOLATGE;
+	return pdata;
+}
+#else
+static struct tps51632_regulator_platform_data *
+	of_get_tps51632_platform_data(struct device *dev)
+{
+	return NULL;
+}
+#endif
+
 static int tps51632_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
@@ -261,7 +307,19 @@ static int tps51632_probe(struct i2c_client *client,
 	int ret;
 	struct regulator_config config = { };
 
+	if (client->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_device(of_match_ptr(tps51632_of_match),
+				&client->dev);
+		if (!match) {
+			dev_err(&client->dev, "Error: No device match found\n");
+			return -ENODEV;
+		}
+	}
+
 	pdata = client->dev.platform_data;
+	if (!pdata && client->dev.of_node)
+		pdata = of_get_tps51632_platform_data(&client->dev);
 	if (!pdata) {
 		dev_err(&client->dev, "No Platform data\n");
 		return -EINVAL;
@@ -350,6 +408,7 @@ static struct i2c_driver tps51632_i2c_driver = {
 	.driver = {
 		.name = "tps51632",
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(tps51632_of_match),
 	},
 	.probe = tps51632_probe,
 	.remove = tps51632_remove,
-- 
1.7.1.1

