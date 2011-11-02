Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab1KBOtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 10:49:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64630 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab1KBOt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 10:49:26 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com, rdunlap@xenotime.net,
        dmitry.torokhov@gmail.com, jic23@cam.ac.uk, aghayal@codeaurora.org,
        sameo@linux.intel.com, peter.ujfalusi@ti.com, saaguirre@ti.com,
        hemanthv@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCHv5 1/5] input/cma3000_d0x: Support devices without pdata
Date: Wed,  2 Nov 2011 15:49:09 +0100
Message-Id: <1320245353-32125-2-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1320245353-32125-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1320245353-32125-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures based on device-tree does not have platform data
associated to the spi/i2c devices. Instead they can have some of
the options embedded in the device tree.

This patch allows the cma3000  driver to get the configuration
from the platform_data, the device tree, or in the wort case,
just use a default configuration.

v5: Fixes suggested by Grant Likely
    -Device tree binding doc
    -Use of_device_id table

v3: Fixes suggested by Jonathan Cameron
    -Code style
    -Add support for the device tree

v2: Fixes suggested by Jonathan Cameron
    -Spelling
    -Simplify pdata!=NULL check

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 .../devicetree/bindings/input/cma3000_d0x.txt      |   71 ++++++++++++++++
 drivers/input/misc/cma3000_d0x.c                   |   86 +++++++++++++++++---
 drivers/input/misc/cma3000_d0x_i2c.c               |    7 ++
 3 files changed, 153 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/cma3000_d0x.txt

diff --git a/Documentation/devicetree/bindings/input/cma3000_d0x.txt b/Documentation/devicetree/bindings/input/cma3000_d0x.txt
new file mode 100644
index 0000000..41becc1
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/cma3000_d0x.txt
@@ -0,0 +1,71 @@
+* VTI CMA3000-D0x Accelerometer
+
+Required properties:
+
+- compatible : "vti,cma3000_d01"
+
+- reg : Offset and length of the register set for this device
+
+- interrupts : <a> where a is the interrupt number for the port.
+
+- interrupt-parent : the phandle for the interrupt controller
+that services interrupts for this device.
+
+
+Optional properties:
+
+- vti,fuzz_x: <a> where a is the noise on X Axis in mili g.
+	* Value per default is 18;
+
+- vti,fuzz_y: <a> where a is the noise on Y Axis in mili g
+	* Value per default is 18;
+
+- vti,fuzz_z: <a> where a is the noise on Z Axis in mili g
+	* Value per default is 18;
+
+- g_range: <a> where a is G range in milli g. Value can be:
+		- 2000: for 2G
+		- 8000: for 8G
+	* Value per default is 2000;
+
+- mode: <a> where a is the default Operating mode. Value can be:
+		- 0: power down mode
+		- 1: 100 Hz Measurement mode
+		- 2: 400 Hz Measurement mode
+		- 3: 40 Hz Measurement mode
+		- 4: Motion Detect mode (default)
+		- 5: 100 Hz Free fall mode
+		- 6: 40 Hz Free fall mode
+		- 7: Power off mode
+	* Value per default is 2;
+
+- mdthr: <a> where a is the Motion detect g range threshold value.
+Value X means:
+		- X: X * 71mg (8G Range)
+		- X: X * 18mg (2G Range)
+	* Value per default is 8;
+
+- mdfftmr: <a> where a is the Motion detect and free fall time threshold value.
+Value X memans:
+		- X: (X & 0x70) * 100 ms (MDTMR)
+		- (X & 0x0F) * 2.5 ms (FFTMR 400 Hz)
+	   	- (X & 0x0F) * 10 ms  (FFTMR 100 Hz)
+	* Value per default is 51;
+
+- ffthr: <a> where a is the Free fall g range threshold value. Value X means:
+		- X: (X >> 2) * 18mg (2G Range)
+		- X: (X & 0x0F) * 71 mg (8G Range)
+	* Value per default is 8;
+
+
+Example:
+
+cma3000 {
+	compatible = "vti,cma3000_d01";
+	reg = < 1 1 >;
+	interrupt-parent = <&xps_intc_0>;
+	interrupts = < 7 2 >;
+	spi-max-frequency = <500000>;
+	vti,mode = <2>;
+} ;
+
diff --git a/drivers/input/misc/cma3000_d0x.c b/drivers/input/misc/cma3000_d0x.c
index 1633b63..e66036d 100644
--- a/drivers/input/misc/cma3000_d0x.c
+++ b/drivers/input/misc/cma3000_d0x.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/input/cma3000.h>
+#include <linux/of.h>
 
 #include "cma3000_d0x.h"
 
@@ -62,9 +63,21 @@
 #define BIT_TO_2G  18
 #define BIT_TO_8G  71
 
+static struct cma3000_platform_data cma3000_default_pdata = {
+	.mdthr = 0x8,
+	.mdfftmr = 0x33,
+	.ffthr = 0x8,
+	.mode = CMAMODE_MEAS400,
+	.g_range = CMARANGE_2G,
+	.fuzz_x = BIT_TO_2G,
+	.fuzz_y = BIT_TO_2G,
+	.fuzz_z = BIT_TO_2G,
+	.irqflags = 0,
+};
+
 struct cma3000_accl_data {
 	const struct cma3000_bus_ops *bus_ops;
-	const struct cma3000_platform_data *pdata;
+	struct cma3000_platform_data pdata;
 
 	struct device *dev;
 	struct input_dev *input_dev;
@@ -182,7 +195,7 @@ static int cma3000_reset(struct cma3000_accl_data *data)
 
 static int cma3000_poweron(struct cma3000_accl_data *data)
 {
-	const struct cma3000_platform_data *pdata = data->pdata;
+	struct cma3000_platform_data *pdata = &data->pdata;
 	u8 ctrl = 0;
 	int ret;
 
@@ -280,22 +293,57 @@ void cma3000_resume(struct cma3000_accl_data *data)
 }
 EXPORT_SYMBOL(cma3000_resume);
 
+#ifdef CONFIG_OF
+void cma3000_get_pdata_of(struct device *dev, struct cma3000_accl_data *data)
+{
+	const __be32 *property;
+	int len;
+
+	property = of_get_property(dev->of_node, "vti,mdthr", &len);
+	if (property && len == sizeof(int))
+		data->pdata.mdthr = be32_to_cpup(property);
+
+	property = of_get_property(dev->of_node, "vti,mdfftmr", &len);
+	if (property && len == sizeof(int))
+		data->pdata.mdfftmr = be32_to_cpup(property);
+
+	property = of_get_property(dev->of_node, "vti,mode", &len);
+	if (property && len == sizeof(int))
+		data->pdata.mode = be32_to_cpup(property);
+
+	property = of_get_property(dev->of_node, "vti,g_range", &len);
+	if (property && len == sizeof(int))
+		data->pdata.g_range = be32_to_cpup(property);
+
+	property = of_get_property(dev->of_node, "vti,fuzz_x", &len);
+	if (property && len == sizeof(int))
+		data->pdata.fuzz_x = be32_to_cpup(property);
+
+	property = of_get_property(dev->of_node, "vti,fuzz_y", &len);
+	if (property && len == sizeof(int))
+		data->pdata.fuzz_y = be32_to_cpup(property);
+
+	property = of_get_property(dev->of_node, "vti,fuzz_z", &len);
+	if (property && len == sizeof(int))
+		data->pdata.fuzz_z = be32_to_cpup(property);
+
+	property = of_get_property(dev->of_node, "vti,irqflags", &len);
+	if (property && len == sizeof(int))
+		data->pdata.irqflags = be32_to_cpup(property);
+
+	return;
+}
+#endif
+
 struct cma3000_accl_data *cma3000_init(struct device *dev, int irq,
 				       const struct cma3000_bus_ops *bops)
 {
-	const struct cma3000_platform_data *pdata = dev->platform_data;
+	struct cma3000_platform_data *pdata;
 	struct cma3000_accl_data *data;
 	struct input_dev *input_dev;
 	int rev;
 	int error;
 
-	if (!pdata) {
-		dev_err(dev, "platform data not found\n");
-		error = -EINVAL;
-		goto err_out;
-	}
-
-
 	/* if no IRQ return error */
 	if (irq == 0) {
 		error = -EINVAL;
@@ -309,10 +357,26 @@ struct cma3000_accl_data *cma3000_init(struct device *dev, int irq,
 		goto err_free_mem;
 	}
 
+	/*Init platform data*/
+	if (dev->platform_data != NULL) {
+		memcpy(&data->pdata, dev->platform_data, sizeof(data->pdata));
+	} else {
+		memcpy(&data->pdata, &cma3000_default_pdata,
+				sizeof(data->pdata));
+		#ifdef CONFIG_OF
+		if (dev->of_node != NULL)
+			cma3000_get_pdata_of(dev, data);
+		 else
+			dev_info(dev, "platform data not found, using default\n");
+		#else
+		dev_info(dev, "platform data not found, using default\n");
+		#endif
+	}
+	pdata = &data->pdata;
+
 	data->dev = dev;
 	data->input_dev = input_dev;
 	data->bus_ops = bops;
-	data->pdata = pdata;
 	data->irq = irq;
 	mutex_init(&data->mutex);
 
diff --git a/drivers/input/misc/cma3000_d0x_i2c.c b/drivers/input/misc/cma3000_d0x_i2c.c
index d100cc5..922f8c2 100644
--- a/drivers/input/misc/cma3000_d0x_i2c.c
+++ b/drivers/input/misc/cma3000_d0x_i2c.c
@@ -112,6 +112,12 @@ static const struct i2c_device_id cma3000_i2c_id[] = {
 
 MODULE_DEVICE_TABLE(i2c, cma3000_i2c_id);
 
+static const struct of_device_id cma3000_i2c_dt_ids[] = {
+	{ .compatible = "vti,cma3000_d01", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, cma3000_i2c_dt_ids);
+
 static struct i2c_driver cma3000_i2c_driver = {
 	.probe		= cma3000_i2c_probe,
 	.remove		= __devexit_p(cma3000_i2c_remove),
@@ -119,6 +125,7 @@ static struct i2c_driver cma3000_i2c_driver = {
 	.driver = {
 		.name	= "cma3000_i2c_accl",
 		.owner	= THIS_MODULE,
+		.of_match_table = cma3000_i2c_dt_ids,
 #ifdef CONFIG_PM
 		.pm	= &cma3000_i2c_pm_ops,
 #endif
-- 
1.7.7.1

