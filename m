Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab2JWKpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:45:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39565 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab2JWKpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:45:40 -0400
From: "Patil, Rachna" <rachna@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-iio@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH 1/1] MFD: ti_tscadc: Add device tree binding for TI's TSC/ADC MFD driver
Date: Tue, 23 Oct 2012 15:59:15 +0530
Message-ID: <1350988155-3066-1-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT binding for TI's touchscreen / ADC
multifunctional driver. Usage details are added to device tree
documentation and the driver was tested on AM335x EVM.

This patch is based on top of [1].

[1] "Subject: [PATCH 0/3] input: ti_am335x_tsc: Remove hard coded values
and add variance filter logic"
(http://www.spinics.net/lists/linux-input/msg23060.html)

Signed-off-by: Patil, Rachna <rachna@ti.com>
---
 .../devicetree/bindings/mfd/ti_am335x_tscadc.txt   |   35 +++++++++++
 drivers/iio/adc/ti_am335x_adc.c                    |   25 +++++++-
 drivers/input/touchscreen/ti_am335x_tsc.c          |   62 ++++++++++++++++----
 drivers/mfd/ti_am335x_tscadc.c                     |   28 +++++++--
 4 files changed, 130 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt

diff --git a/Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt b/Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt
new file mode 100644
index 0000000..44f7e2e
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt
@@ -0,0 +1,35 @@
+Texas Instruments - TSC / ADC multi-functional device
+
+ti_tscadc is a multi-function device with touchscreen and ADC on chip.
+This document describes the binding for mfd device.
+
+Required properties:
+- compatible: "ti,ti-tscadc"
+- reg: Specifies the address of MFD block
+- interrupts: IRQ line connected to the main SoC
+- interrupt-parent: The parent interrupt controller
+
+Optional properties:
+- ti,hwmods: Hardware information related to TSC/ADC MFD device
+
+Example:
+
+	tscadc: tscadc@44e0d000 {
+		compatible = "ti,ti-tscadc";
+		reg = <0x44e0d000 0x1000>;
+
+		interrupt-parent = <&intc>;
+		interrupts = <16>;
+		ti,hwmods = "adc_tsc";
+
+		tsc {
+			wires = <4>;
+			x-plate-resistance = <200>;
+			steps-to-configure = <5>;
+			wire_config = <0x00 0x11 0x22 0x33>;
+		};
+
+		adc {
+			adc-channels = <4>;
+		};
+	};
diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 02a43c8..8e001b0 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -22,6 +22,8 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/iio/iio.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #include <linux/mfd/ti_am335x_tscadc.h>
 #include <linux/platform_data/ti_am335x_adc.h>
@@ -141,11 +143,18 @@ static int __devinit tiadc_probe(struct platform_device *pdev)
 	struct iio_dev		*indio_dev;
 	struct tiadc_device	*adc_dev;
 	struct ti_tscadc_dev	*tscadc_dev = pdev->dev.platform_data;
-	struct mfd_tscadc_board	*pdata;
+	struct mfd_tscadc_board	*pdata = NULL;
+	struct device_node	*node = NULL;
 	int			err;
+	u32			val32;
 
-	pdata = tscadc_dev->dev->platform_data;
-	if (!pdata || !pdata->adc_init) {
+	if (tscadc_dev->dev->of_node) {
+		node = tscadc_dev->dev->of_node;
+		node = of_find_node_by_name(node, "adc");
+	} else
+		pdata = tscadc_dev->dev->platform_data;
+
+	if (!pdata && !node) {
 		dev_err(&pdev->dev, "Could not find platform data\n");
 		return -EINVAL;
 	}
@@ -159,7 +168,15 @@ static int __devinit tiadc_probe(struct platform_device *pdev)
 	adc_dev = iio_priv(indio_dev);
 
 	adc_dev->mfd_tscadc = tscadc_dev;
-	adc_dev->channels = pdata->adc_init->adc_channels;
+
+	if (node) {
+		err = of_property_read_u32(node, "adc-channels", &val32);
+		if (err < 0)
+			goto err_free_device;
+		else
+			adc_dev->channels = val32;
+	} else
+		adc_dev->channels = pdata->adc_init->adc_channels;
 
 	indio_dev->dev.parent = &pdev->dev;
 	indio_dev->name = dev_name(&pdev->dev);
diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 7a26810..f122fd0 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -28,6 +28,8 @@
 #include <linux/delay.h>
 
 #include <linux/mfd/ti_am335x_tscadc.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #define ADCFSM_STEPID		0x10
 #define SEQ_SETTLE		275
@@ -398,12 +400,19 @@ static int __devinit titsc_probe(struct platform_device *pdev)
 	struct titsc *ts_dev;
 	struct input_dev *input_dev;
 	struct ti_tscadc_dev *tscadc_dev = pdev->dev.platform_data;
-	struct mfd_tscadc_board	*pdata;
-	int err;
-
-	pdata = tscadc_dev->dev->platform_data;
-
-	if (!pdata) {
+	int err, i;
+	struct mfd_tscadc_board	*pdata = NULL;
+	struct device_node *node = NULL;
+	u32 val32;
+	u32 wires_conf[4];
+
+	if (tscadc_dev->dev->of_node) {
+		node = tscadc_dev->dev->of_node;
+		node = of_find_node_by_name(node, "tsc");
+	} else
+		pdata = tscadc_dev->dev->platform_data;
+
+	if (!pdata && !node) {
 		dev_err(&pdev->dev, "Could not find platform data\n");
 		return -EINVAL;
 	}
@@ -421,11 +430,43 @@ static int __devinit titsc_probe(struct platform_device *pdev)
 	ts_dev->mfd_tscadc = tscadc_dev;
 	ts_dev->input = input_dev;
 	ts_dev->irq = tscadc_dev->irq;
-	ts_dev->wires = pdata->tsc_init->wires;
-	ts_dev->x_plate_resistance = pdata->tsc_init->x_plate_resistance;
-	ts_dev->steps_to_configure = pdata->tsc_init->steps_to_configure;
-	memcpy(ts_dev->config_inp, pdata->tsc_init->wire_config,
+
+	if (node) {
+		err = of_property_read_u32(node, "wires", &val32);
+		if (err < 0)
+			goto err_free_mem;
+		else
+			ts_dev->wires = val32;
+
+		err = of_property_read_u32(node, "x-plate-resistance", &val32);
+		if (err < 0)
+			goto err_free_mem;
+		else
+			ts_dev->x_plate_resistance = val32;
+
+		err = of_property_read_u32(node, "steps-to-configure", &val32);
+		if (err < 0)
+			goto err_free_mem;
+		else
+			ts_dev->steps_to_configure = val32;
+
+		err = of_property_read_u32_array(node, "wire_config",
+				wires_conf, ARRAY_SIZE(wires_conf));
+		if (err < 0)
+			goto err_free_mem;
+		else {
+			for (i = 0; i < ARRAY_SIZE(wires_conf); i++)
+				ts_dev->config_inp[i] = wires_conf[i];
+		}
+	} else {
+		ts_dev->wires = pdata->tsc_init->wires;
+		ts_dev->x_plate_resistance =
+			pdata->tsc_init->x_plate_resistance;
+		ts_dev->steps_to_configure =
+			pdata->tsc_init->steps_to_configure;
+		memcpy(ts_dev->config_inp, pdata->tsc_init->wire_config,
 			sizeof(pdata->tsc_init->wire_config));
+	}
 
 	err = request_irq(ts_dev->irq, titsc_irq,
 			  0, pdev->dev.driver->name, ts_dev);
@@ -445,7 +486,6 @@ static int __devinit titsc_probe(struct platform_device *pdev)
 
 	input_dev->name = "ti-tsc";
 	input_dev->dev.parent = &pdev->dev;
-
 	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 
diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index e947dd8..c9ae0d7 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -26,6 +26,8 @@
 #include <linux/mfd/ti_am335x_tscadc.h>
 #include <linux/input/ti_am335x_tsc.h>
 #include <linux/platform_data/ti_am335x_adc.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 static unsigned int tscadc_readl(struct ti_tscadc_dev *tsadc, unsigned int reg)
 {
@@ -64,21 +66,32 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
 	struct resource		*res;
 	struct clk		*clk;
 	struct mfd_tscadc_board	*pdata = pdev->dev.platform_data;
+	struct device_node	*node = pdev->dev.of_node;
 	struct mfd_cell		*cell;
 	int			irq;
 	int			err, ctrl;
 	int			clk_value, clock_rate;
-	int			tsc_wires, adc_channels = 0, total_channels;
+	int			tsc_wires = 0, adc_channels = 0, total_channels;
 
-	if (!pdata) {
+	if (!pdata && !pdev->dev.of_node) {
 		dev_err(&pdev->dev, "Could not find platform data\n");
 		return -EINVAL;
 	}
 
-	if (pdata->adc_init)
-		adc_channels = pdata->adc_init->adc_channels;
+	if (pdev->dev.of_node) {
+		node = of_find_node_by_name(pdev->dev.of_node, "tsc");
+		of_property_read_u32(node, "wires", &tsc_wires);
+
+		node = of_find_node_by_name(pdev->dev.of_node, "adc");
+		of_property_read_u32(node, "adc-channels", &adc_channels);
+	} else {
+		if (pdata->tsc_init)
+			tsc_wires = pdata->tsc_init->wires;
+
+		if (pdata->adc_init)
+			adc_channels = pdata->adc_init->adc_channels;
+	}
 
-	tsc_wires = pdata->tsc_init->wires;
 	total_channels = tsc_wires + adc_channels;
 
 	if (total_channels > 8) {
@@ -259,11 +272,16 @@ static const struct dev_pm_ops tscadc_pm_ops = {
 #define TSCADC_PM_OPS NULL
 #endif
 
+static const struct of_device_id ti_tscadc_dt_ids[] = {
+	{ .compatible = "ti,ti-tscadc", },
+};
+
 static struct platform_driver ti_tscadc_driver = {
 	.driver = {
 		.name   = "ti_tscadc",
 		.owner	= THIS_MODULE,
 		.pm	= TSCADC_PM_OPS,
+		.of_match_table = of_match_ptr(ti_tscadc_dt_ids),
 	},
 	.probe	= ti_tscadc_probe,
 	.remove	= __devexit_p(ti_tscadc_remove),
-- 
1.7.0.4

