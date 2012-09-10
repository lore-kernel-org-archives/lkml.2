Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab2IJPEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:04:22 -0400
Received: from svenfoo.org ([82.94.215.22]:59487 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab2IJPEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:04:20 -0400
From: Daniel Mack <zonque@gmail.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>
Subject: [PATCH v2] regulator: gpio-regulator: add DT bindings
Date: Mon, 10 Sep 2012 17:03:49 +0200
Message-Id: <1347289429-18713-1-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT bindings for the gpio-regulator driver and some documentation on
how to use it.

Signed-off-by: Daniel Mack <zonque@gmail.com>
---
v1 -> v2
  Fixed wrong kzalloc() size.

 .../bindings/regulator/gpio-regulator.txt          |  58 ++++++++++
 drivers/regulator/gpio-regulator.c                 | 118 ++++++++++++++++++++-
 2 files changed, 175 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/gpio-regulator.txt

diff --git a/Documentation/devicetree/bindings/regulator/gpio-regulator.txt b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
new file mode 100644
index 0000000..ea3eb09
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
@@ -0,0 +1,58 @@
+Device tree bindings for GPIO controlled voltages
+
+Voltage or current regulators on boards that are controlled by GPIOs can
+be used by the gpio-regulator driver.
+
+Required properties:
+
+ - "compatible":	must be set to "gpio-regulator"
+ - "regulator-name": 	must be set to a string describing the name of this
+			regulator.
+
+Optional properties:
+
+ - "startup-delay":		Start-up time in microseconds
+ - "enable-high":		Polarity of enable GPIO. Active high if
+				defined, otherwise active low
+ - "enabled-at-boot":		If set, the regulator has been enabled at boot
+				time
+ - "regulator-type-voltage":	The regulator controls a voltage
+ - "regulator-type-current":	The regulator controls a current
+ - "states":			An array of possible states, describing the
+				GPIO states to reach a given value
+	- "value":		The value of the state, in microvolts or
+				microamperes
+	- "gpios":		bitfield of gpio target-states for the value
+				The n-th bit in the bitfield describes the
+				state of the n-th GPIO from the gpios-array
+
+Also, all properties described in
+Documentation/devicetree/bindings/regulator/regulator.txt are supported as
+well.
+
+Example:
+
+	reg_gpio {
+		compatible = "gpio-regulator";
+		regulator-name = "voltage";
+		regulator-enable-high;
+		regulator-type-voltage;
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-always-on;
+
+		gpios = <&gpio 23 0>;
+
+		states {
+			state-on {
+				value = <3300000>;
+				gpios = <0x1>;
+			};
+
+			state-off {
+				value = <0>;
+				gpios = <0x0>;
+			};
+		};
+	};
+
diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 8b5944f..d34ec68 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -25,10 +25,14 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
+#include <linux/string.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/gpio-regulator.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
 
@@ -134,13 +138,124 @@ static struct regulator_ops gpio_regulator_current_ops = {
 	.set_current_limit = gpio_regulator_set_current_limit,
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id gpio_regulator_dt_ids[] = {
+	{ .compatible = "gpio-regulator", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, gpio_regulator_dt_ids);
+
+static int gpio_regulator_probe_dt(struct platform_device *pdev)
+{
+	struct device_node *states, *np = pdev->dev.of_node;
+	struct gpio_regulator_config *config;
+	int ret, i;
+
+	if (!np)
+		return 0;
+
+	config = kzalloc(sizeof(*config), GFP_KERNEL);
+	if (!config) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	config->nr_gpios = of_gpio_named_count(np, "gpios");
+	config->gpios = kcalloc(config->nr_gpios, sizeof(struct gpio),
+				GFP_KERNEL);
+	if (!config->gpios) {
+		ret = -ENOMEM;
+		goto exit_free_config;
+	}
+
+	for (i = 0; i < config->nr_gpios; i++) {
+		int gpio = of_get_named_gpio(np, "gpios", i);
+
+		config->gpios[i].gpio = gpio;
+		config->gpios[i].flags = GPIOF_DIR_OUT;
+	}
+
+	config->supply_name =
+		kstrdup(of_get_property(np, "regulator-name", NULL),
+			GFP_KERNEL);
+	of_property_read_u32(np, "startup-delay", &config->startup_delay);
+
+	if (of_get_property(np, "enable-high", NULL))
+		config->enable_high = 1;
+	if (of_get_property(np, "enabled-at-boot", NULL))
+		config->enabled_at_boot = 1;
+	if (of_get_property(np, "regulator-type-current", NULL))
+		config->type = REGULATOR_CURRENT;
+	if (of_get_property(np, "regulator-type-voltage", NULL))
+		config->type = REGULATOR_VOLTAGE;
+
+	states = of_find_node_by_name(np, "states");
+
+	if (states) {
+		struct device_node *child = NULL;
+		while ((child = of_get_next_child(states, child)))
+			config->nr_states++;
+
+		config->states = kcalloc(config->nr_states,
+					 sizeof(struct regulator_state),
+					 GFP_KERNEL);
+		if (!config->states) {
+			ret = -ENOMEM;
+			goto exit_free_gpios;
+		}
+
+		i = 0;
+		child = NULL;
+		while ((child = of_get_next_child(states, child))) {
+			u32 value, gpios;
+
+			of_property_read_u32(child, "value", &value);
+			of_property_read_u32(child, "gpios", &gpios);
+
+			config->states[i].value = value;
+			config->states[i].gpios = gpios;
+
+			i++;
+		}
+	}
+
+	config->init_data = of_get_regulator_init_data(&pdev->dev, np);
+
+	pdev->dev.platform_data = config;
+
+	return 0;
+
+exit_free_gpios:
+	kfree(config->gpios);
+exit_free_config:
+	kfree(config);
+exit:
+	return ret;
+}
+#else
+static int gpio_regulator_probe_dt(struct platform_device *dev)
+{
+	return 0;
+}
+#endif
+
 static int __devinit gpio_regulator_probe(struct platform_device *pdev)
 {
-	struct gpio_regulator_config *config = pdev->dev.platform_data;
+	struct gpio_regulator_config *config;
 	struct gpio_regulator_data *drvdata;
 	struct regulator_config cfg = { };
 	int ptr, ret, state;
 
+	ret = gpio_regulator_probe_dt(pdev);
+	if (ret < 0)
+		return ret;
+
+	config = pdev->dev.platform_data;
+	if (!config) {
+		dev_err(&pdev->dev, "Platform data missing\n");
+		return -EINVAL;
+	}
+
 	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct gpio_regulator_data),
 			       GFP_KERNEL);
 	if (drvdata == NULL) {
@@ -276,6 +391,7 @@ static struct platform_driver gpio_regulator_driver = {
 	.driver		= {
 		.name		= "gpio-regulator",
 		.owner		= THIS_MODULE,
+		.of_match_table	= of_match_ptr(gpio_regulator_dt_ids),
 	},
 };
 
-- 
1.7.11.4

