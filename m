Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab2EHLdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 07:33:41 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:36346 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754180Ab2EHLdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 07:33:38 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        peter.ujfalusi@ti.com
Subject: [PATCH v2 3/3] MFD: twl6040: Support for DT
Date: Tue,  8 May 2012 14:33:30 +0300
Message-Id: <1336476810-26945-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1336476810-26945-1-git-send-email-peter.ujfalusi@ti.com>
References: <1336476810-26945-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for DT based probing of twl6040 core.

Example of dts section for twl6040:
twl6040: twl6040@4b {
	compatible = "ti,twl6040";
	reg = <0x4b>;
	interrupts = <0 119 4>; /* IRQ_SYS_2N cascaded to gic */
	interrupt-parent = <&gic>;
	twl6040,audpwron_gpio = <&gpio4 31 0>;  /* gpio line 127 */
	enable-active-high;

	interrupt-controller;
	#interrupt-cells = <1>;

	vio-supply = <&v1v8>;
	v2v1-supply = <&v2v1>;

	twl6040_codec: twl6040@0 {
		compatible = "ti,twl6040-codec";
		interrupts = <1>;
	};
};

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 Documentation/devicetree/bindings/mfd/twl6040.txt |   51 +++++++++++++++++++++
 drivers/mfd/twl6040-core.c                        |   23 +++++++---
 drivers/mfd/twl6040-irq.c                         |    6 +++
 3 files changed, 74 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/twl6040.txt

diff --git a/Documentation/devicetree/bindings/mfd/twl6040.txt b/Documentation/devicetree/bindings/mfd/twl6040.txt
new file mode 100644
index 0000000..6d2399c7
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/twl6040.txt
@@ -0,0 +1,51 @@
+Texas Instruments TWL6040 family
+
+The TWL6040s are 8-channel high quality low-power audio codecs providing audio
+and vibra functionality on OMAP4+ platforms.
+They are connected ot the host processor via i2c for commands, McPDM for audio
+data and commands.
+
+Required properties:
+- compatible : Must be "ti,twl6040";
+- reg: must be 0x4b for i2c address
+- interrupts: twl6040 has one interrupt line connecteded to the main SoC
+- interrupt-parent: The parent interrupt controller
+- interrupt-controller: twl6040 support several interrupts internally, it is
+  considered as an interupt controller cascaded to the SoC core.
+#interrupt-cells = <1>;
+- twl6040,audpwron_gpio: Power on GPIO line for the twl6040
+
+- vio-supply: Regulator for the twl6040 VIO supply
+- v2v1-supply: Regulator for the twl6040 V2V1 supply
+
+Optional properties, nodes:
+- enable-active-high: To power on the twl6040 during boot.
+- Child nodes for audio functionality and for the vibra driver
+  For details on the child nodes see:
+  Documentation/devicetree/bindings/input/twl6040-vibra.txt - Vibra driver
+  Documentation/devicetree/bindings/sound/twl6040.txt - ASoC codec driver
+
+Example:
+/*
+ * 8-channel high quality low-power audio codec
+ * http://www.ti.com/lit/ds/symlink/twl6040.pdf
+ */
+twl6040: twl6040@4b {
+	compatible = "ti,twl6040";
+	reg = <0x4b>;
+	interrupts = <0 119 4>; /* IRQ_SYS_2N cascaded to gic */
+	interrupt-parent = <&gic>;
+	twl6040,audpwron_gpio = <&gpio4 31 0>;  /* gpio line 127 */
+	enable-active-high;
+
+	interrupt-controller;
+	#interrupt-cells = <1>;
+
+	vio-supply = <&v1v8>;
+	v2v1-supply = <&v2v1>;
+
+	twl6040_codec: twl6040@0 {
+		compatible = "ti,twl6040-codec";
+		interrupts = <1>;
+	};
+};
diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index c50fba7..23b9771 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -29,6 +29,10 @@
 #include <linux/kernel.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_gpio.h>
+#include <linux/of_platform.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
@@ -505,11 +509,12 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 				     const struct i2c_device_id *id)
 {
 	struct twl6040_platform_data *pdata = client->dev.platform_data;
+	struct device_node *node = client->dev.of_node;
 	struct twl6040 *twl6040;
 	struct mfd_cell *cell = NULL;
 	int ret, children = 0;
 
-	if (!pdata) {
+	if (!pdata && !node) {
 		dev_err(&client->dev, "Platform data is missing\n");
 		return -EINVAL;
 	}
@@ -560,9 +565,13 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 	twl6040->rev = twl6040_reg_read(twl6040, TWL6040_REG_ASICREV);
 
 	/* ERRATA: Automatic power-up is not possible in ES1.0 */
-	if (twl6040_get_revid(twl6040) > TWL6040_REV_ES1_0)
-		twl6040->audpwron = pdata->audpwron_gpio;
-	else
+	if (twl6040_get_revid(twl6040) > TWL6040_REV_ES1_0) {
+		if (pdata)
+			twl6040->audpwron = pdata->audpwron_gpio;
+		else
+			twl6040->audpwron = of_get_named_gpio(node,
+						"twl6040,audpwron_gpio", 0);
+	} else
 		twl6040->audpwron = -EINVAL;
 
 	if (gpio_is_valid(twl6040->audpwron)) {
@@ -589,7 +598,7 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 	/* dual-access registers controlled by I2C only */
 	twl6040_set_bits(twl6040, TWL6040_REG_ACCCTL, TWL6040_I2CSEL);
 
-	if (pdata->codec) {
+	if (pdata && pdata->codec) {
 		int irq = twl6040->irq_base + TWL6040_IRQ_PLUG;
 
 		cell = &twl6040->cells[children];
@@ -603,7 +612,7 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 		children++;
 	}
 
-	if (pdata->vibra) {
+	if (pdata && pdata->vibra) {
 		int irq = twl6040->irq_base + TWL6040_IRQ_VIB;
 
 		cell = &twl6040->cells[children];
@@ -623,6 +632,8 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 				      children, NULL, 0);
 		if (ret)
 			goto mfd_err;
+	} else if (node) {
+		ret = of_platform_populate(node, NULL, NULL, &client->dev);
 	} else {
 		dev_err(&client->dev, "No platform data found for children\n");
 		ret = -ENODEV;
diff --git a/drivers/mfd/twl6040-irq.c b/drivers/mfd/twl6040-irq.c
index 914978e..4b42543 100644
--- a/drivers/mfd/twl6040-irq.c
+++ b/drivers/mfd/twl6040-irq.c
@@ -25,6 +25,8 @@
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/irqdomain.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/twl6040.h>
@@ -139,6 +141,7 @@ static irqreturn_t twl6040_irq_thread(int irq, void *data)
 
 int twl6040_irq_init(struct twl6040 *twl6040)
 {
+	struct device_node *node = twl6040->dev->of_node;
 	int i, nr_irqs, irq_base, ret;
 	u8 val;
 
@@ -158,6 +161,9 @@ int twl6040_irq_init(struct twl6040 *twl6040)
 	}
 	twl6040->irq_base = irq_base;
 
+	irq_domain_add_legacy(node, ARRAY_SIZE(twl6040_irqs), irq_base, 0,
+			      &irq_domain_simple_ops, NULL);
+
 	/* Register them with genirq */
 	for (i = irq_base; i < irq_base + nr_irqs; i++) {
 		irq_set_chip_data(i, twl6040);
-- 
1.7.8.6

