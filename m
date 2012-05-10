Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab2EJUxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 16:53:45 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4858 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab2EJUxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 16:53:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 10 May 2012 13:52:54 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <linux@arm.linux.org.uk>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <swarren@nvidia.com>,
        <olof@lixom.net>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 2/4] regulator: tps62360: add dt support
Date: Fri, 11 May 2012 02:19:37 +0530
Message-ID: <1336682979-11810-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1336682979-11810-1-git-send-email-ldewangan@nvidia.com>
References: <1336682979-11810-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dt support for the pmu device tps62360 and
Add binding documentation with example.
With this patch driver will support both device-tree and
non-device tree registration.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
Fixed possible build error in non devicetree.

 .../bindings/regulator/tps62360-regulator.txt      |   45 ++++++++++++
 drivers/regulator/tps62360-regulator.c             |   74 +++++++++++++++++++-
 2 files changed, 118 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/tps62360-regulator.txt

diff --git a/Documentation/devicetree/bindings/regulator/tps62360-regulator.txt b/Documentation/devicetree/bindings/regulator/tps62360-regulator.txt
new file mode 100644
index 0000000..e337cd6
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/tps62360-regulator.txt
@@ -0,0 +1,45 @@
+TPS62360 Voltage regulators
+
+Required properties:
+- compatible: Must be one of the following.
+	"ti,tps62360"
+	"ti,tps62361",
+	"ti,tps62362",
+	"ti,tps62363",
+- reg: I2C slave address
+
+Optional properties:
+- ti,enable-force-pwm: Enable fore PWM mode. This is boolean value.
+- ti,enable-vout-discharge: Enable output discharge. This is boolean value.
+- ti,enable-pull-down: Enable pull down. This is boolean value.
+- ti,vsel0-gpio: GPIO for controlling VSEL0 line.
+  If this property is missing, then assume that there is no GPIO
+  for vsel0 control.
+- ti,vsel1-gpio: Gpio for controlling VSEL1 line.
+  If this property is missing, then assume that there is no GPIO
+  for vsel1 control.
+- ti,vsel0-state-high: Inital state of vsel0 input is high.
+  If this property is missing, then assume the state as low (0).
+- ti,vsel1-state-high: Inital state of vsel1 input is high.
+  If this property is missing, then assume the state as low (0).
+
+Any property defined as part of the core regulator binding, defined in
+regulator.txt, can also be used.
+
+Example:
+
+	abc: tps62360 {
+		compatible = "ti,tps62361";
+		reg =  <0x60>;
+		regulator-name = "tps62361-vout";
+		regulator-min-microvolt = <500000>;
+		regulator-max-microvolt = <1500000>;
+		regulator-boot-on
+		ti,vsel0-gpio = <&gpio1 16 0>;
+		ti,vsel1-gpio = <&gpio1 17 0>;
+		ti,vsel0-state-high;
+		ti,vsel1-state-high;
+		ti,enable-pull-down;
+		ti,enable-force-pwm;
+		ti,enable-vout-discharge;
+	};
diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index 3506900..9985303 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -26,6 +26,10 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/err.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
@@ -297,6 +301,58 @@ static const struct regmap_config tps62360_regmap_config = {
 	.cache_type		= REGCACHE_RBTREE,
 };
 
+static struct tps62360_regulator_platform_data *
+	of_get_tps62360_platform_data(struct device *dev)
+{
+	struct tps62360_regulator_platform_data *pdata;
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
+	pdata->vsel0_gpio = of_get_named_gpio(np, "vsel0-gpio", 0);
+	pdata->vsel1_gpio = of_get_named_gpio(np, "vsel1_gpio", 0);
+
+	if (of_find_property(np, "ti,vsel0-state-high", NULL))
+		pdata->vsel0_def_state = 1;
+
+	if (of_find_property(np, "ti,vsel1-state-high", NULL))
+		pdata->vsel1_def_state = 1;
+
+	if (of_find_property(np, "ti,enable-pull-down", NULL))
+		pdata->en_internal_pulldn = true;
+
+	if (of_find_property(np, "ti,enable-force-pwm", NULL))
+		pdata->en_force_pwm = true;
+
+	if (of_find_property(np, "ti,enable-vout-discharge", NULL))
+		pdata->en_discharge = true;
+
+	return pdata;
+}
+
+#if defined(CONFIG_OF)
+static const struct of_device_id tps62360_of_match[] = {
+	 { .compatible = "ti,tps62360", .data = (void *)TPS62360},
+	 { .compatible = "ti,tps62361", .data = (void *)TPS62361},
+	 { .compatible = "ti,tps62362", .data = (void *)TPS62362},
+	 { .compatible = "ti,tps62363", .data = (void *)TPS62363},
+	{},
+}
+MODULE_DEVICE_TABLE(of, tps62360_of_match);
+#else
+#define tps62360_of_match NULL
+#endif
+
 static int __devinit tps62360_probe(struct i2c_client *client,
 				     const struct i2c_device_id *id)
 {
@@ -306,8 +362,23 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 	struct tps62360_chip *tps;
 	int ret;
 	int i;
+	int chip_id;
 
 	pdata = client->dev.platform_data;
+	chip_id = id->driver_data;
+
+	if (client->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_device(tps62360_of_match, &client->dev);
+		if (!match) {
+			dev_err(&client->dev, "Error: No device match found\n");
+			return -ENODEV;
+		}
+		chip_id = (int)match->data;
+		if (!pdata)
+			pdata = of_get_tps62360_platform_data(&client->dev);
+	}
+
 	if (!pdata) {
 		dev_err(&client->dev, "%s(): Platform data not found\n",
 						__func__);
@@ -328,7 +399,7 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 	tps->vsel1_gpio = pdata->vsel1_gpio;
 	tps->dev = &client->dev;
 
-	switch (id->driver_data) {
+	switch (chip_id) {
 	case TPS62360:
 	case TPS62362:
 		tps->voltage_base = TPS62360_BASE_VOLTAGE;
@@ -484,6 +555,7 @@ static struct i2c_driver tps62360_i2c_driver = {
 	.driver = {
 		.name = "tps62360",
 		.owner = THIS_MODULE,
+		.of_match_table = tps62360_of_match,
 	},
 	.probe = tps62360_probe,
 	.remove = __devexit_p(tps62360_remove),
-- 
1.7.1.1

