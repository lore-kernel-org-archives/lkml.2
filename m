Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030269Ab2EPLS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:18:57 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:37529 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030229Ab2EPLS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:18:56 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        peter.ujfalusi@ti.com, Misael Lopez Cruz <misael.lopez@ti.com>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH v3 4/4] MFD: twl6040: Add support for Device Tree
Date: Wed, 16 May 2012 14:11:58 +0300
Message-Id: <1337166718-8458-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1337166718-8458-1-git-send-email-peter.ujfalusi@ti.com>
References: <1337166718-8458-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device tree based probing support for the core twl6040 driver. Child
devices will be created as MFD devices:
- ASoC codec is always created
- Vibra child is only created if the vibra section present in the DT blob.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 Documentation/devicetree/bindings/mfd/twl6040.txt |   62 +++++++++++++++++++++
 drivers/mfd/twl6040-core.c                        |   27 ++++++---
 drivers/mfd/twl6040-irq.c                         |    6 ++
 3 files changed, 87 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/twl6040.txt

diff --git a/Documentation/devicetree/bindings/mfd/twl6040.txt b/Documentation/devicetree/bindings/mfd/twl6040.txt
new file mode 100644
index 0000000..bc67c6f
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/twl6040.txt
@@ -0,0 +1,62 @@
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
+- twl6040,audpwron-gpio: Power on GPIO line for the twl6040
+
+- vio-supply: Regulator for the twl6040 VIO supply
+- v2v1-supply: Regulator for the twl6040 V2V1 supply
+
+Optional properties, nodes:
+- enable-active-high: To power on the twl6040 during boot.
+
+Vibra functionality
+Required properties:
+- vddvibl-supply: Regulator for the left vibra motor
+- vddvibr-supply: Regulator for the right vibra motor
+- vibra { }: Configuration section for vibra parameters containing the following
+	     properties:
+- ti,vibldrv-res: Resistance parameter for left driver
+- ti,vibrdrv-res: Resistance parameter for right driver
+- ti,viblmotor-res: Resistance parameter for left motor
+- ti,viblmotor-res: Resistance parameter for right motor
+
+Optional properties within vibra { } section:
+- vddvibl_uV: If the vddvibl default voltage need to be changed
+- vddvibr_uV: If the vddvibr default voltage need to be changed
+
+Example:
+&i2c1 {
+	twl6040: twl@4b {
+		compatible = "ti,twl6040";
+		reg = <0x4b>;
+
+		interrupts = <0 119 4>;
+		interrupt-parent = <&gic>;
+		twl6040,audpwron-gpio = <&gpio4 31 0>;
+
+		vio-supply = <&v1v8>;
+		v2v1-supply = <&v2v1>;
+		enable-active-high;
+
+		/* regulators for vibra motor */
+		vddvibl-supply = <&vbat>;
+		vddvibr-supply = <&vbat>;
+
+		vibra {
+			/* Vibra driver, motor resistance parameters */
+			ti,vibldrv-res = <8>;
+			ti,vibrdrv-res = <3>;
+			ti,viblmotor-res = <10>;
+			ti,vibrmotor-res = <10>;
+		};
+	};
+};
diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 9765dc2..450a28f 100644
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
 	int irq, ret, children = 0;
 
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
+						"ti,audpwron-gpio", 0);
+	} else
 		twl6040->audpwron = -EINVAL;
 
 	if (gpio_is_valid(twl6040->audpwron)) {
@@ -602,13 +611,13 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 	twl6040_codec_rsrc[0].end = irq;
 	cell->resources = twl6040_codec_rsrc;
 	cell->num_resources = ARRAY_SIZE(twl6040_codec_rsrc);
-	if (pdata->codec) {
+	if (pdata && pdata->codec) {
 		cell->platform_data = pdata->codec;
 		cell->pdata_size = sizeof(*pdata->codec);
 	}
 	children++;
 
-	if (pdata->vibra) {
+	if ((pdata && pdata->vibra) || of_find_node_by_name(node, "vibra")) {
 		irq = twl6040->irq_base + TWL6040_IRQ_VIB;
 
 		cell = &twl6040->cells[children];
@@ -618,8 +627,10 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 		cell->resources = twl6040_vibra_rsrc;
 		cell->num_resources = ARRAY_SIZE(twl6040_vibra_rsrc);
 
-		cell->platform_data = pdata->vibra;
-		cell->pdata_size = sizeof(*pdata->vibra);
+		if (pdata && pdata->vibra) {
+			cell->platform_data = pdata->vibra;
+			cell->pdata_size = sizeof(*pdata->vibra);
+		}
 		children++;
 	}
 
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

