Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab1KRLSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:18:20 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51358 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab1KRLSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:18:16 -0500
From: Rajendra Nayak <rnayak@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <robherring2@gmail.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tony@atomide.com>,
        <lrg@ti.com>, <b-cousson@ti.com>, <patches@linaro.org>,
        <linux-kernel@vger.kernel.org>, <shawn.guo@freescale.com>,
        <linaro-dev@lists.linaro.org>, <olof@lixom.net>,
        Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH v5 2/4] regulator: adapt fixed regulator driver to dt
Date: Fri, 18 Nov 2011 16:47:18 +0530
Message-ID: <1321615040-13257-3-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1321615040-13257-1-git-send-email-rnayak@ti.com>
References: <1321615040-13257-1-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fixed regulator driver uses of_get_fixed_voltage_config()
to extract fixed_voltage_config structure contents from device tree.

Also add documenation for additional bindings for fixed
regulators that can be passed through dt.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
---
 .../bindings/regulator/fixed-regulator.txt         |   29 +++++++++
 drivers/regulator/fixed.c                          |   65 ++++++++++++++++++++
 2 files changed, 94 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/fixed-regulator.txt

diff --git a/Documentation/devicetree/bindings/regulator/fixed-regulator.txt b/Documentation/devicetree/bindings/regulator/fixed-regulator.txt
new file mode 100644
index 0000000..9cf57fd
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/fixed-regulator.txt
@@ -0,0 +1,29 @@
+Fixed Voltage regulators
+
+Required properties:
+- compatible: Must be "regulator-fixed";
+
+Optional properties:
+- gpio: gpio to use for enable control
+- startup-delay-us: startup time in microseconds
+- enable-active-high: Polarity of GPIO is Active high
+If this property is missing, the default assumed is Active low.
+
+Any property defined as part of the core regulator
+binding, defined in regulator.txt, can also be used.
+However a fixed voltage regulator is expected to have the
+regulator-min-microvolt and regulator-max-microvolt
+to be the same.
+
+Example:
+
+	abc: fixedregulator@0 {
+		compatible = "regulator-fixed";
+		regulator-name = "fixed-supply";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+		gpio = <&gpio1 16 0>;
+		startup-delay-us = <70000>;
+		enable-active-high;
+		regulator-boot-on
+	};
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 21ecf21..0650856 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -27,6 +27,10 @@
 #include <linux/gpio.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/regulator/machine.h>
 
 struct fixed_voltage_data {
 	struct regulator_desc desc;
@@ -38,6 +42,53 @@ struct fixed_voltage_data {
 	bool is_enabled;
 };
 
+
+/**
+ * of_get_fixed_voltage_config - extract fixed_voltage_config structure info
+ * @dev: device requesting for fixed_voltage_config
+ *
+ * Populates fixed_voltage_config structure by extracting data from device
+ * tree node, returns a pointer to the populated structure of NULL if memory
+ * alloc fails.
+ */
+struct fixed_voltage_config *of_get_fixed_voltage_config(struct device *dev)
+{
+	struct fixed_voltage_config *config;
+	struct device_node *np = dev->of_node;
+	const __be32 *delay;
+	struct regulator_init_data *init_data;
+
+	config = devm_kzalloc(dev, sizeof(struct fixed_voltage_config),
+								 GFP_KERNEL);
+	if (!config)
+		return NULL;
+
+	config->init_data = of_get_regulator_init_data(dev);
+	init_data = config->init_data;
+
+	config->supply_name = init_data->constraints.name;
+	if (init_data->constraints.min_uV == init_data->constraints.max_uV) {
+		config->microvolts = init_data->constraints.min_uV;
+	} else {
+		dev_err(dev,
+			 "Fixed regulator specified with variable voltages\n");
+		return NULL;
+	}
+
+	if (init_data->constraints.boot_on)
+		config->enabled_at_boot = true;
+
+	config->gpio = of_get_named_gpio(np, "gpio", 0);
+	delay = of_get_property(np, "startup-delay-us", NULL);
+	if (delay)
+		config->startup_delay = be32_to_cpu(*delay);
+
+	if (of_find_property(np, "enable-active-high", NULL))
+		config->enable_high = true;
+
+	return config;
+}
+
 static int fixed_voltage_is_enabled(struct regulator_dev *dev)
 {
 	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
@@ -109,6 +160,9 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	struct fixed_voltage_data *drvdata;
 	int ret;
 
+	if (pdev->dev.of_node)
+		config = of_get_fixed_voltage_config(&pdev->dev);
+
 	drvdata = kzalloc(sizeof(struct fixed_voltage_data), GFP_KERNEL);
 	if (drvdata == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate device data\n");
@@ -217,12 +271,23 @@ static int __devexit reg_fixed_voltage_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#if defined(CONFIG_OF)
+static const struct of_device_id fixed_of_match[] __devinitconst = {
+	{ .compatible = "regulator-fixed", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, fixed_of_match);
+#else
+#define fixed_of_match NULL
+#endif
+
 static struct platform_driver regulator_fixed_voltage_driver = {
 	.probe		= reg_fixed_voltage_probe,
 	.remove		= __devexit_p(reg_fixed_voltage_remove),
 	.driver		= {
 		.name		= "reg-fixed-voltage",
 		.owner		= THIS_MODULE,
+		.of_match_table = fixed_of_match,
 	},
 };
 
-- 
1.7.1

