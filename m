Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab2KVS3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:29:00 -0500
Received: from service88.mimecast.com ([195.130.217.12]:49337 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab2KVS25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:28:57 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: sameo@linux.intel.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, lee.jones@linaro.org,
        Vipul Kumar Samar <vipulkumar.samar@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 2/2] mfd: stmpe: Extend DT support in stmpe driver
Date: Thu, 22 Nov 2012 10:40:30 +0530
Message-Id: <b81641051dad9660b72b0028d001e5620d901160.1353560936.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
References: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
In-Reply-To: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
References: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 22 Nov 2012 05:10:34.0517 (UTC) FILETIME=[B3AFA450:01CDC86F]
X-MC-Unique: 112112205103503301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qAMITM9X004057

From: Vipul Kumar Samar <vipulkumar.samar@st.com>

This patch extends existing DT support for stmpe devices. Bindings are mentioned
in binding document.

Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V1->V2:
------
- Partial DT support was already there, which i missed earlier.
- Now, this patch is an enhancement of existing DT support.

 Documentation/devicetree/bindings/mfd/stmpe.txt | 127 ++++++++++--
 drivers/mfd/stmpe-i2c.c                         |  23 ++-
 drivers/mfd/stmpe-spi.c                         |  15 ++
 drivers/mfd/stmpe.c                             | 264 +++++++++++++++++++++---
 4 files changed, 384 insertions(+), 45 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/stmpe.txt b/Documentation/devicetree/bindings/mfd/stmpe.txt
index 8f0aeda..44aebf3 100644
--- a/Documentation/devicetree/bindings/mfd/stmpe.txt
+++ b/Documentation/devicetree/bindings/mfd/stmpe.txt
@@ -1,25 +1,124 @@
-* STMPE Multi-Functional Device
+ST Microelectronics STMPE Multi-Functional Device
+-------------------------------------------------
 
+STMPE is an MFD device which may expose following inbuilt devices: gpio, keypad,
+touchscreen, adc, pwm, rotator.
+
+stmpe:
+-----
 Required properties:
- - compatible                   : "st,stmpe[811|1601|2401|2403]"
- - reg                          : I2C address of the device
+- compatible: Must be one of: "st,stmpe610", "st,stmpe801", "st,stmpe811",
+  "st,stmpe1601", "st,stmpe2401", "st,stmpe2403",
+- id: device id to distinguish between multiple STMPEs on the same board
+- reg: I2C/SPI address of the device
+
+Optional properties:
+- irq-trigger: IRQ trigger to use for the interrupt to the host
+- irq-invert-polarity: bool, IRQ line is connected with reversed polarity
+- autosleep-timeout: inactivity timeout in milliseconds for autosleep. Valid
+  entries (ms); 4, 16, 32, 64, 128, 256, 512 and 1024
+- interrupts: interrupt number of the device, if interrupt is not via gpio
+- interrupt-parent: Specifies which IRQ controller we're connected to
+- irq-over-gpio: bool, true if gpio is used to get irq
+- irq-gpios: gpio number over which irq will be requested (significant only if
+  irq-over-gpio is true)
+- i2c-client-wake: Marks the input device as wakable
+
+stmpe-keypad:
+--------------
+Required properties in addition to those specified by the shared matrix-keyboard
+bindings:
+- compatible: Must be "stmpe,keypad"
 
 Optional properties:
- - interrupts                   : The interrupt outputs from the controller
- - interrupt-controller         : Marks the device node as an interrupt controller
- - interrupt-parent             : Specifies which IRQ controller we're connected to
- - i2c-client-wake              : Marks the input device as wakable
- - st,autosleep-timeout         : Valid entries (ms); 4, 16, 32, 64, 128, 256, 512 and 1024
+- keypad,scan-count: number of key scanning cycles to confirm key data. Maximum
+  is STMPE_KEYPAD_MAX_SCAN_COUNT.
+- keypad,debounce-ms: debounce interval, in ms. Maximum is
+  STMPE_KEYPAD_MAX_DEBOUNCE.
+- keypad,no-autorepeat: bool, disable key autorepeat
+
+stmpe-gpio:
+-----------
+Required properties:
+- compatible: Must be "stmpe,gpio"
+
+Optional properties:
+- norequest-mask: bitmask specifying which GPIOs should _not_ be requestable due
+  to different usage (e.g. touch, keypad) STMPE_GPIO_NOREQ_* macros can be used
+  here.
+
+stmpe-ts:
+-----------
+Required properties:
+- compatible: Must be "stmpe,ts"
+
+Optional properties:
+- sample-time: ADC converstion time in number of clock.  (0 -> 36 clocks, 1 ->
+  44 clocks, 2 -> 56 clocks, 3 -> 64 clocks, 4 -> 80 clocks, 5 -> 96 clocks, 6
+  -> 144 clocks), recommended is 4.
+- mod-12b: ADC Bit mode (0 -> 10bit ADC, 1 -> 12bit ADC)
+- ref-sel: ADC reference source (0 -> internal reference, 1 -> external
+  reference)
+- adc-freq: ADC Clock speed (0 -> 1.625 MHz, 1 -> 3.25 MHz, 2 || 3 -> 6.5 MHz)
+- ave-ctrl: Sample average control (0 -> 1 sample, 1 -> 2 samples, 2 -> 4
+  samples, 3 -> 8 samples)
+- touch-det-delay: Touch detect interrupt delay (0 -> 10 us, 1 -> 50 us, 2 ->
+  100 us, 3 -> 500 us, 4-> 1 ms, 5 -> 5 ms, 6 -> 10 ms, 7 -> 50 ms) recommended
+  is 3
+- settling: Panel driver settling time (0 -> 10 us, 1 -> 100 us, 2 -> 500 us, 3
+  -> 1 ms, 4 -> 5 ms, 5 -> 10 ms, 6 for 50 ms, 7 -> 100 ms) recommended is 2
+- fraction-z: Length of the fractional part in z (fraction-z ([0..7]) = Count of
+  the fractional part) recommended is 7
+- i-drive: current limit value of the touchscreen drivers (0 -> 20 mA typical 35
+  mA max, 1 -> 50 mA typical 80 mA max)
+
+stmpe-adc:
+-----------
+Required properties:
+- compatible: Must be "stmpe,adc"
+
+stmpe-pwm:
+-----------
+Required properties:
+- compatible: Must be "stmpe,pwm"
+
+stmpe-rotator:
+-----------
+Required properties:
+- compatible: Must be "stmpe,rotator"
 
 Example:
+-------
+stmpe can be present over i2c or spi bus, so its node would be added as child
+node of either of spi or i2c device.
+
+stmpe-devices should be added as child nodes of parent stmpe node.
 
+spi@e0100000 {
+	<...>
 	stmpe1601: stmpe1601@40 {
+		status = "okay";
 		compatible = "st,stmpe1601";
-		reg = <0x40>;
-		interrupts = <26 0x4>;
-		interrupt-parent = <&gpio6>;
-		interrupt-controller;
+		reg = <0>;
+
+		<.. spi controller specific data ..>
+
+		id = <0>;
+		irq-over-gpio;
+		irq-gpios = <&gpio1 6 0x4>;
+		irq-trigger = <0x2>;
 
-		i2c-client-wake;
-		st,autosleep-timeout = <1024>;
+		stmpe610-ts {
+			compatible = "stmpe,ts";
+			ts,sample-time = <4>;
+			ts,mod-12b = <1>;
+			ts,ref-sel = <0>;
+			ts,adc-freq = <1>;
+			ts,ave-ctrl = <1>;
+			ts,touch-det-delay = <2>;
+			ts,settling = <2>;
+			ts,fraction-z = <7>;
+			ts,i-drive = <1>;
+		};
 	};
+};
diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index 947a06a..aaa2da7 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/types.h>
 #include "stmpe.h"
 
@@ -81,12 +82,28 @@ static const struct i2c_device_id stmpe_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, stmpe_id);
 
+#ifdef CONFIG_OF
+static const struct of_device_id stmpe_dt_ids[] = {
+	{ .compatible = "st,stmpe610", .data = &stmpe_i2c_id[0], },
+	{ .compatible = "st,stmpe801", .data = &stmpe_i2c_id[1], },
+	{ .compatible = "st,stmpe811", .data = &stmpe_i2c_id[2], },
+	{ .compatible = "st,stmpe1601", .data = &stmpe_i2c_id[3], },
+	{ .compatible = "st,stmpe2401", .data = &stmpe_i2c_id[4], },
+	{ .compatible = "st,stmpe2403", .data = &stmpe_i2c_id[5], },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, stmpe_dt_ids);
+#endif
+
 static struct i2c_driver stmpe_i2c_driver = {
-	.driver.name	= "stmpe-i2c",
-	.driver.owner	= THIS_MODULE,
+	.driver = {
+		.name	= "stmpe-i2c",
+		.owner	= THIS_MODULE,
 #ifdef CONFIG_PM
-	.driver.pm	= &stmpe_dev_pm_ops,
+		.pm	= &stmpe_dev_pm_ops,
 #endif
+		.of_match_table = of_match_ptr(stmpe_dt_ids),
+	},
 	.probe		= stmpe_i2c_probe,
 	.remove		= __devexit_p(stmpe_i2c_remove),
 	.id_table	= stmpe_i2c_id,
diff --git a/drivers/mfd/stmpe-spi.c b/drivers/mfd/stmpe-spi.c
index 9edfe86..1e2bff0 100644
--- a/drivers/mfd/stmpe-spi.c
+++ b/drivers/mfd/stmpe-spi.c
@@ -11,6 +11,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/types.h>
 #include "stmpe.h"
 
@@ -119,6 +120,19 @@ static const struct spi_device_id stmpe_spi_id[] = {
 };
 MODULE_DEVICE_TABLE(spi, stmpe_id);
 
+#ifdef CONFIG_OF
+static const struct of_device_id stmpe_dt_ids[] = {
+	{ .compatible = "st,stmpe610", .data = (void *)STMPE610, },
+	{ .compatible = "st,stmpe801", .data = (void *)STMPE801, },
+	{ .compatible = "st,stmpe811", .data = (void *)STMPE811, },
+	{ .compatible = "st,stmpe1601", .data = (void *)STMPE1601, },
+	{ .compatible = "st,stmpe2401", .data = (void *)STMPE2401, },
+	{ .compatible = "st,stmpe2403", .data = (void *)STMPE2403, },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, stmpe_dt_ids);
+#endif
+
 static struct spi_driver stmpe_spi_driver = {
 	.driver = {
 		.name	= "stmpe-spi",
@@ -126,6 +140,7 @@ static struct spi_driver stmpe_spi_driver = {
 #ifdef CONFIG_PM
 		.pm	= &stmpe_dev_pm_ops,
 #endif
+		.of_match_table = of_match_ptr(stmpe_dt_ids),
 	},
 	.probe		= stmpe_spi_probe,
 	.remove		= __devexit_p(stmpe_spi_remove),
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index c0df4b9..d69f24b 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -8,11 +8,14 @@
  */
 
 #include <linux/gpio.h>
+#include <linux/err.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
 #include <linux/mfd/core.h>
@@ -981,6 +984,230 @@ static int __devinit stmpe_add_device(struct stmpe *stmpe,
 			       NULL, stmpe->irq_base, stmpe->domain);
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id stmpe_keypad_ids[] = {
+	{ .compatible = "stmpe,keypad" },
+	{},
+};
+
+static const struct of_device_id stmpe_gpio_ids[] = {
+	{ .compatible = "stmpe,gpio" },
+	{},
+};
+
+static const struct of_device_id stmpe_ts_ids[] = {
+	{ .compatible = "stmpe,ts" },
+	{},
+};
+
+static const struct of_device_id stmpe_adc_ids[] = {
+	{ .compatible = "stmpe,adc" },
+	{},
+};
+
+static const struct of_device_id stmpe_pwm_ids[] = {
+	{ .compatible = "stmpe,pwm" },
+	{},
+};
+
+static const struct of_device_id stmpe_rotator_ids[] = {
+	{ .compatible = "stmpe,rotator" },
+	{},
+};
+
+static struct stmpe_keypad_platform_data *
+get_keyboard_pdata_dt(struct device *dev, struct device_node *np)
+{
+	struct stmpe_keypad_platform_data *pdata;
+	u32 val;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		dev_warn(dev, "stmpe keypad kzalloc fail\n");
+		return NULL;
+	}
+
+	if (!of_property_read_u32(np, "keypad,scan-count", &val))
+		pdata->scan_count = val;
+	if (!of_property_read_u32(np, "keypad,debounce-ms", &val))
+		pdata->debounce_ms = val;
+	if (of_property_read_bool(np, "keypad,no-autorepeat"))
+		pdata->no_autorepeat = true;
+
+	return pdata;
+}
+
+static struct stmpe_gpio_platform_data *get_gpio_pdata_dt(struct device *dev,
+		struct device_node *np)
+{
+	struct stmpe_gpio_platform_data *pdata;
+	u32 val;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		dev_warn(dev, "stmpe gpio kzalloc fail\n");
+		return NULL;
+	}
+
+	if (!of_property_read_u32(np, "gpio,norequest-mask", &val))
+		pdata->norequest_mask = val;
+
+	/* assign gpio numbers dynamically */
+	pdata->gpio_base = -1;
+
+	return pdata;
+}
+
+static struct stmpe_ts_platform_data *get_ts_pdata_dt(struct device *dev,
+		struct device_node *np)
+{
+	struct stmpe_ts_platform_data *pdata;
+	u32 val;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		dev_warn(dev, "stmpe ts kzalloc fail\n");
+		return NULL;
+	}
+
+	if (!of_property_read_u32(np, "ts,sample-time", &val))
+		pdata->sample_time = val;
+	if (!of_property_read_u32(np, "ts,mod-12b", &val))
+		pdata->mod_12b = val;
+	if (!of_property_read_u32(np, "ts,ref-sel", &val))
+		pdata->ref_sel = val;
+	if (!of_property_read_u32(np, "ts,adc-freq", &val))
+		pdata->adc_freq = val;
+	if (!of_property_read_u32(np, "ts,ave-ctrl", &val))
+		pdata->ave_ctrl = val;
+	if (!of_property_read_u32(np, "ts,touch-det-delay", &val))
+		pdata->touch_det_delay = val;
+	if (!of_property_read_u32(np, "ts,settling", &val))
+		pdata->settling = val;
+	if (!of_property_read_u32(np, "ts,fraction-z", &val))
+		pdata->fraction_z = val;
+	if (!of_property_read_u32(np, "ts,i-drive", &val))
+		pdata->i_drive = val;
+
+	return pdata;
+}
+
+static struct stmpe_variant_block *
+match_variant_block(struct stmpe_variant_info *variant,
+		enum stmpe_block blocks)
+{
+	int i;
+
+	for (i = 0; i < variant->num_blocks; i++) {
+		struct stmpe_variant_block *block = &variant->blocks[i];
+
+		if (blocks & block->block)
+			return block;
+	}
+	return NULL;
+}
+
+static int stmpe_probe_config_dt(struct device *dev,
+		struct stmpe_platform_data *pdata, struct device_node *np)
+{
+	enum of_gpio_flags flags;
+
+	pdata->irq_base = irq_alloc_descs(-1, 0, STMPE_NR_IRQS, 0);
+	if (IS_ERR_VALUE(pdata->irq_base)) {
+		dev_err(dev, "%s: irq desc alloc failed\n", __func__);
+		return -ENXIO;
+	}
+
+	if (of_property_read_bool(np, "irq_over_gpio")) {
+		pdata->irq_over_gpio = true;
+
+		pdata->irq_gpio = of_get_named_gpio_flags(np, "irq-gpios", 0,
+				&flags);
+		if (!pdata->irq_gpio)
+			dev_dbg(dev, "unable to get irq_gpio from %s.",
+					__func__);
+	}
+
+	if (of_property_read_u32(np, "irq-trigger", &pdata->irq_trigger))
+		dev_dbg(dev, "unable to get irq_trigger\n");
+
+	if (of_property_read_bool(np, "irq-invert-polarity"))
+		pdata->irq_invert_polarity = true;
+
+	if (!of_property_read_u32(np, "autosleep-timeout",
+				&pdata->autosleep_timeout))
+		pdata->autosleep = true;
+
+	if (of_property_read_u32(np, "id", &pdata->id))
+		dev_dbg(dev, "unable to get id\n");
+
+	return 0;
+}
+
+static int stmpe_of_devices_init(struct stmpe *stmpe)
+{
+	struct stmpe_variant_info *variant = stmpe->variant;
+	struct device_node *nc, *np = stmpe->dev->of_node;
+	struct stmpe_variant_block *block;
+	enum stmpe_block blockid;
+	int ret = -EINVAL;
+
+	for_each_child_of_node(np, nc) {
+		if (of_match_node(stmpe_keypad_ids, nc)) {
+			blockid = STMPE_BLOCK_KEYPAD;
+			stmpe->pdata->keypad = get_keyboard_pdata_dt(stmpe->dev,
+					nc);
+			if (!stmpe->pdata->keypad)
+				return -ENOMEM;
+		} else if (of_match_node(stmpe_gpio_ids, nc)) {
+			blockid = STMPE_BLOCK_GPIO;
+			stmpe->pdata->gpio = get_gpio_pdata_dt(stmpe->dev, nc);
+			if (!stmpe->pdata->gpio)
+				return -ENOMEM;
+		} else if (of_match_node(stmpe_ts_ids, nc)) {
+			blockid = STMPE_BLOCK_TOUCHSCREEN;
+			stmpe->pdata->ts = get_ts_pdata_dt(stmpe->dev, nc);
+			if (!stmpe->pdata->ts)
+				return -ENOMEM;
+		} else if (of_match_node(stmpe_adc_ids, nc)) {
+			blockid = STMPE_BLOCK_ADC;
+		} else if (of_match_node(stmpe_pwm_ids, nc)) {
+			blockid = STMPE_BLOCK_PWM;
+		} else if (of_match_node(stmpe_rotator_ids, nc)) {
+			blockid = STMPE_BLOCK_ROTATOR;
+		} else {
+			dev_warn(stmpe->dev, "no matching device node found\n");
+			return -EINVAL;
+		}
+
+		block = match_variant_block(variant, blockid);
+		if (!block) {
+			dev_err(stmpe->dev, "variant doesn't support blockid: %d\n",
+					blockid);
+			continue;
+		}
+
+		ret = stmpe_add_device(stmpe, block->cell);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
+#else
+static inline int stmpe_probe_config_dt(struct stmpe_platform_data *pdata,
+		struct device_node *np)
+{
+	return -ENODEV;
+}
+
+static inline int stmpe_of_devices_init(struct stmpe *stmpe)
+{
+	return -ENODEV;
+}
+#endif
+
 static int __devinit stmpe_devices_init(struct stmpe *stmpe)
 {
 	struct stmpe_variant_info *variant = stmpe->variant;
@@ -1017,32 +1244,6 @@ static int __devinit stmpe_devices_init(struct stmpe *stmpe)
 	return ret;
 }
 
-void __devinit stmpe_of_probe(struct stmpe_platform_data *pdata,
-			struct device_node *np)
-{
-	struct device_node *child;
-
-	of_property_read_u32(np, "st,autosleep-timeout",
-			&pdata->autosleep_timeout);
-
-	pdata->autosleep = (pdata->autosleep_timeout) ? true : false;
-
-	for_each_child_of_node(np, child) {
-		if (!strcmp(child->name, "stmpe_gpio")) {
-			pdata->blocks |= STMPE_BLOCK_GPIO;
-		}
-		if (!strcmp(child->name, "stmpe_keypad")) {
-			pdata->blocks |= STMPE_BLOCK_KEYPAD;
-		}
-		if (!strcmp(child->name, "stmpe_touchscreen")) {
-			pdata->blocks |= STMPE_BLOCK_TOUCHSCREEN;
-		}
-		if (!strcmp(child->name, "stmpe_adc")) {
-			pdata->blocks |= STMPE_BLOCK_ADC;
-		}
-	}
-}
-
 /* Called from client specific probe routines */
 int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
 {
@@ -1059,7 +1260,11 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
 		if (!pdata)
 			return -ENOMEM;
 
-		stmpe_of_probe(pdata, np);
+		ret = stmpe_probe_config_dt(ci->dev, pdata, np);
+		if (ret) {
+			dev_err(ci->dev, "probe_config_dt failed\n");
+			return ret;
+		}
 	}
 
 	stmpe = devm_kzalloc(ci->dev, sizeof(struct stmpe), GFP_KERNEL);
@@ -1130,7 +1335,10 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
 		}
 	}
 
-	ret = stmpe_devices_init(stmpe);
+	if (np)
+		ret = stmpe_of_devices_init(stmpe);
+	else
+		ret = stmpe_devices_init(stmpe);
 	if (!ret)
 		return 0;
 
-- 
1.7.12.rc2.18.g61b472e


