Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab2KWG36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 01:29:58 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47771 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab2KWG35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 01:29:57 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        lee.jones@linaro.org, Vipul Kumar Samar <vipulkumar.samar@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] input: stmpe-ts: Add DT support for stmpe touchscreen
Date: Fri, 23 Nov 2012 11:59:46 +0530
Message-Id: <f56ddb18f4e9c92f6a94c6d3ae3f5fe30e0bd892.1353652106.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vipul Kumar Samar <vipulkumar.samar@st.com>

This patch allows the STMPE Touchscreen driver to be successfully probed and
initialised when Device Tree support is enabled. Bindings are mentioned in
Documentation too.

Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 .../bindings/input/touchscreen/stmpe.txt           | 43 ++++++++++++++
 drivers/input/touchscreen/stmpe-ts.c               | 65 ++++++++++++++++------
 drivers/mfd/stmpe.c                                |  1 +
 3 files changed, 91 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/stmpe.txt

diff --git a/Documentation/devicetree/bindings/input/touchscreen/stmpe.txt b/Documentation/devicetree/bindings/input/touchscreen/stmpe.txt
new file mode 100644
index 0000000..127baa3
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/touchscreen/stmpe.txt
@@ -0,0 +1,43 @@
+STMPE Touchscreen
+----------------
+
+Required properties:
+ - compatible: "st,stmpe-ts"
+
+Optional properties:
+- st,sample-time: ADC converstion time in number of clock.  (0 -> 36 clocks, 1 ->
+  44 clocks, 2 -> 56 clocks, 3 -> 64 clocks, 4 -> 80 clocks, 5 -> 96 clocks, 6
+  -> 144 clocks), recommended is 4.
+- st,mod-12b: ADC Bit mode (0 -> 10bit ADC, 1 -> 12bit ADC)
+- st,ref-sel: ADC reference source (0 -> internal reference, 1 -> external
+  reference)
+- st,adc-freq: ADC Clock speed (0 -> 1.625 MHz, 1 -> 3.25 MHz, 2 || 3 -> 6.5 MHz)
+- st,ave-ctrl: Sample average control (0 -> 1 sample, 1 -> 2 samples, 2 -> 4
+  samples, 3 -> 8 samples)
+- st,touch-det-delay: Touch detect interrupt delay (0 -> 10 us, 1 -> 50 us, 2 ->
+  100 us, 3 -> 500 us, 4-> 1 ms, 5 -> 5 ms, 6 -> 10 ms, 7 -> 50 ms) recommended
+  is 3
+- st,settling: Panel driver settling time (0 -> 10 us, 1 -> 100 us, 2 -> 500 us, 3
+  -> 1 ms, 4 -> 5 ms, 5 -> 10 ms, 6 for 50 ms, 7 -> 100 ms) recommended is 2
+- st,fraction-z: Length of the fractional part in z (fraction-z ([0..7]) = Count of
+  the fractional part) recommended is 7
+- st,i-drive: current limit value of the touchscreen drivers (0 -> 20 mA typical 35
+  mA max, 1 -> 50 mA typical 80 mA max)
+
+Node name must be stmpe_touchscreen and should be child node of stmpe node to
+which it belongs.
+
+Example:
+
+	stmpe_touchscreen {
+		compatible = "st,stmpe-ts";
+		st,sample-time = <4>;
+		st,mod-12b = <1>;
+		st,ref-sel = <0>;
+		st,adc-freq = <1>;
+		st,ave-ctrl = <1>;
+		st,touch-det-delay = <2>;
+		st,settling = <2>;
+		st,fraction-z = <7>;
+		st,i-drive = <1>;
+	};
diff --git a/drivers/input/touchscreen/stmpe-ts.c b/drivers/input/touchscreen/stmpe-ts.c
index b3f7503..8f4985a 100644
--- a/drivers/input/touchscreen/stmpe-ts.c
+++ b/drivers/input/touchscreen/stmpe-ts.c
@@ -17,6 +17,7 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/device.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
 #include <linux/slab.h>
@@ -262,11 +263,53 @@ static void stmpe_ts_close(struct input_dev *dev)
 			STMPE_TSC_CTRL_TSC_EN, 0);
 }
 
-static int __devinit stmpe_input_probe(struct platform_device *pdev)
+static void stmpe_ts_get_info(struct platform_device *pdev,
+		struct stmpe_touch *ts)
 {
 	struct stmpe *stmpe = dev_get_drvdata(pdev->dev.parent);
-	const struct stmpe_platform_data *pdata = stmpe->pdata;
-	const struct stmpe_ts_platform_data *ts_pdata = NULL;
+	struct device_node *np = pdev->dev.of_node;
+	struct stmpe_ts_platform_data *ts_pdata = NULL;
+
+	ts->stmpe = stmpe;
+
+	if (stmpe->pdata && stmpe->pdata->ts) {
+		ts_pdata = stmpe->pdata->ts;
+
+		ts->sample_time = ts_pdata->sample_time;
+		ts->mod_12b = ts_pdata->mod_12b;
+		ts->ref_sel = ts_pdata->ref_sel;
+		ts->adc_freq = ts_pdata->adc_freq;
+		ts->ave_ctrl = ts_pdata->ave_ctrl;
+		ts->touch_det_delay = ts_pdata->touch_det_delay;
+		ts->settling = ts_pdata->settling;
+		ts->fraction_z = ts_pdata->fraction_z;
+		ts->i_drive = ts_pdata->i_drive;
+	} else if (np) {
+		u32 val;
+
+		if (!of_property_read_u32(np, "st,sample-time", &val))
+			ts->sample_time = val;
+		if (!of_property_read_u32(np, "st,mod-12b", &val))
+			ts->mod_12b = val;
+		if (!of_property_read_u32(np, "st,ref-sel", &val))
+			ts->ref_sel = val;
+		if (!of_property_read_u32(np, "st,adc-freq", &val))
+			ts->adc_freq = val;
+		if (!of_property_read_u32(np, "st,ave-ctrl", &val))
+			ts->ave_ctrl = val;
+		if (!of_property_read_u32(np, "st,touch-det-delay", &val))
+			ts->touch_det_delay = val;
+		if (!of_property_read_u32(np, "st,settling", &val))
+			ts->settling = val;
+		if (!of_property_read_u32(np, "st,fraction-z", &val))
+			ts->fraction_z = val;
+		if (!of_property_read_u32(np, "st,i-drive", &val))
+			ts->i_drive = val;
+	}
+}
+
+static int __devinit stmpe_input_probe(struct platform_device *pdev)
+{
 	struct stmpe_touch *ts;
 	struct input_dev *idev;
 	int error;
@@ -285,24 +328,10 @@ static int __devinit stmpe_input_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, ts);
-	ts->stmpe = stmpe;
 	ts->idev = idev;
 	ts->dev = &pdev->dev;
 
-	if (pdata)
-		ts_pdata = pdata->ts;
-
-	if (ts_pdata) {
-		ts->sample_time = ts_pdata->sample_time;
-		ts->mod_12b = ts_pdata->mod_12b;
-		ts->ref_sel = ts_pdata->ref_sel;
-		ts->adc_freq = ts_pdata->adc_freq;
-		ts->ave_ctrl = ts_pdata->ave_ctrl;
-		ts->touch_det_delay = ts_pdata->touch_det_delay;
-		ts->settling = ts_pdata->settling;
-		ts->fraction_z = ts_pdata->fraction_z;
-		ts->i_drive = ts_pdata->i_drive;
-	}
+	stmpe_ts_get_info(pdev, ts);
 
 	INIT_DELAYED_WORK(&ts->work, stmpe_work);
 
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index c757ac3..3e3ca9c 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -410,6 +410,7 @@ static struct resource stmpe_ts_resources[] = {
 
 static struct mfd_cell stmpe_ts_cell = {
 	.name		= "stmpe-ts",
+	.of_compatible	= "st,stmpe-ts",
 	.resources	= stmpe_ts_resources,
 	.num_resources	= ARRAY_SIZE(stmpe_ts_resources),
 };
-- 
1.7.12.rc2.18.g61b472e

