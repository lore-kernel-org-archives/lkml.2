Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab2DDN2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 09:28:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55900 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932214Ab2DDN2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 09:28:14 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, Sourav Poddar <sourav.poddar@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 2/2] drivers: input: keypad: Add device tree support
Date: Wed, 4 Apr 2012 19:00:21 +0530
Message-ID: <1333546221-19700-3-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1333546221-19700-1-git-send-email-sourav.poddar@ti.com>
References: <1333546221-19700-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree support for omap4 keypad driver.

Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 .../devicetree/bindings/input/omap-keypad.txt      |   52 +++++++++
 drivers/input/keyboard/omap4-keypad.c              |  114 ++++++++++++++++----
 2 files changed, 143 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/omap-keypad.txt

diff --git a/Documentation/devicetree/bindings/input/omap-keypad.txt b/Documentation/devicetree/bindings/input/omap-keypad.txt
new file mode 100644
index 0000000..21fb64a
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/omap-keypad.txt
@@ -0,0 +1,52 @@
+* TI's Keypad Controller device tree bindings
+
+TI's Keypad controller is used to interface a SoC with a matrix-type
+keypad device. The keypad controller supports multiple row and column lines.
+A key can be placed at each intersection of a unique row and a unique column.
+The keypad controller can sense a key-press and key-release and report the
+event using a interrupt to the cpu.
+
+Required SoC Specific Properties:
+- compatible: should be one of the following
+   - "ti,omap4-keypad": For controllers compatible with omap4 keypad
+      controller.
+
+Required Board Specific Properties:
+- keypad,num-rows: Number of row lines connected to the keypad
+  controller.
+
+- keypad,num-columns: Number of column lines connected to the
+  keypad controller.
+
+- Keys represented as child nodes: Each key connected to the keypad
+  controller is represented as a child node to the keypad controller
+  device node and should include the following properties.
+  - keypad,row: the row number to which the key is connected.
+  - keypad,column: the column number to which the key is connected.
+  - linux,code: the key-code to be reported when the key is pressed
+    and released.
+
+Example:
+        keypad@4ae1c000{
+                compatible = "ti,omap4-keypad";
+                keypad,num-rows = <2>;
+                keypad,num-columns = <8>;
+
+		key_1 {
+                        keypad,row = <0>;
+                        keypad,column = <3>;
+                        linux,code = <2>;
+                };
+
+                key_2 {
+                        keypad,row = <0>;
+                        keypad,column = <4>;
+                        linux,code = <3>;
+                };
+
+                key_3 {
+                        keypad,row = <0>;
+                        keypad,column = <5>;
+                        linux,code = <4>;
+                };
+        };
diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index e809ac0..52942bd 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -27,6 +27,7 @@
 #include <linux/platform_device.h>
 #include <linux/errno.h>
 #include <linux/io.h>
+#include <linux/of.h>
 #include <linux/input.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
@@ -70,6 +71,7 @@
 
 struct omap4_keypad {
 	struct input_dev *input;
+	struct matrix_keymap_data *keymap_data;
 
 	void __iomem *base;
 	int irq;
@@ -174,24 +176,103 @@ static void omap4_keypad_close(struct input_dev *input)
 	pm_runtime_put_sync(input->dev.parent);
 }
 
+static struct omap4_keypad *omap_keypad_parse_dt(struct device *dev,
+					uint32_t num_rows, uint32_t num_cols)
+{
+	struct matrix_keymap_data *keymap_data;
+	struct device_node *np = dev->of_node, *key_np;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct omap4_keypad *keypad_data = platform_get_drvdata(pdev);
+	uint32_t *keymap;
+	unsigned int key_count = 0;
+
+	keypad_data->rows = num_rows;
+	keypad_data->cols = num_cols;
+
+	keymap_data = devm_kzalloc(dev, sizeof(*keymap_data), GFP_KERNEL);
+	if (!keymap_data) {
+		dev_err(dev, "could not allocate memory for keymap data\n");
+		return NULL;
+	}
+	keypad_data->keymap_data = keymap_data;
+
+	for_each_child_of_node(np, key_np)
+		key_count++;
+
+	keymap_data->keymap_size = key_count;
+	keymap = devm_kzalloc(dev, sizeof(uint32_t) * key_count, GFP_KERNEL);
+	if (!keymap) {
+		dev_err(dev, "could not allocate memory for keymap\n");
+		return NULL;
+	}
+	keypad_data->keymap_data->keymap = keymap;
+
+	for_each_child_of_node(np, key_np) {
+		u32 row, col, key_code;
+		of_property_read_u32(key_np, "keypad,row", &row);
+		of_property_read_u32(key_np, "keypad,column", &col);
+		of_property_read_u32(key_np, "linux,code", &key_code);
+		*keymap++ = KEY(row, col, key_code);
+	}
+
+	return keypad_data;
+}
+
 static int __devinit omap4_keypad_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
 	const struct omap4_keypad_platform_data *pdata;
 	struct omap4_keypad *keypad_data;
 	struct input_dev *input_dev;
 	struct resource *res;
 	resource_size_t size;
-	unsigned int row_shift, max_keys;
+	unsigned int row_shift = 0, max_keys = 0;
+	uint32_t num_rows = 0, num_cols = 0;
 	int irq;
 	int error;
 
 	/* platform data */
 	pdata = pdev->dev.platform_data;
-	if (!pdata) {
+	if (np) {
+		of_property_read_u32(np, "keypad,num-rows", &num_rows);
+		of_property_read_u32(np, "keypad,num-columns", &num_cols);
+		if (!num_rows || !num_cols) {
+			dev_err(&pdev->dev, "number of keypad rows/columns not specified\n");
+			return -EINVAL;
+		}
+	} else if (pdata) {
+		num_rows = pdata->rows;
+		num_cols = pdata->cols;
+	} else {
 		dev_err(&pdev->dev, "no platform data defined\n");
 		return -EINVAL;
 	}
 
+	row_shift = get_count_order(num_cols);
+	max_keys = num_rows << row_shift;
+
+	keypad_data = devm_kzalloc(sizeof(struct omap4_keypad) +
+			max_keys * sizeof(keypad_data->keymap[0]),
+				GFP_KERNEL);
+
+	if (!keypad_data) {
+		dev_err(&pdev->dev, "keypad_data memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	platform_set_drvdata(pdev, keypad_data);
+
+	if (np) {
+		keypad_data = omap_keypad_parse_dt(&pdev->dev,
+						num_rows, num_cols);
+	} else {
+		keypad_data->rows = num_rows;
+		keypad_data->cols = num_cols;
+		keypad_data->keymap_data =
+				(struct matrix_keymap_data *)pdata->keymap_data;
+	}
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "no base address specified\n");
@@ -204,22 +285,6 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (!pdata->keymap_data) {
-		dev_err(&pdev->dev, "no keymap data defined\n");
-		return -EINVAL;
-	}
-
-	row_shift = get_count_order(pdata->cols);
-	max_keys = pdata->rows << row_shift;
-
-	keypad_data = kzalloc(sizeof(struct omap4_keypad) +
-				max_keys * sizeof(keypad_data->keymap[0]),
-			      GFP_KERNEL);
-	if (!keypad_data) {
-		dev_err(&pdev->dev, "keypad_data memory allocation failed\n");
-		return -ENOMEM;
-	}
-
 	size = resource_size(res);
 
 	res = request_mem_region(res->start, size, pdev->name);
@@ -237,9 +302,6 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
 	}
 
 	keypad_data->irq = irq;
-	keypad_data->row_shift = row_shift;
-	keypad_data->rows = pdata->rows;
-	keypad_data->cols = pdata->cols;
 
 	/* input device allocation */
 	keypad_data->input = input_dev = input_allocate_device();
@@ -269,7 +331,7 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
 
 	input_set_drvdata(input_dev, keypad_data);
 
-	matrix_keypad_build_keymap(pdata->keymap_data, row_shift,
+	matrix_keypad_build_keymap(keypad_data->keymap_data, row_shift,
 			input_dev->keycode, input_dev->keybit);
 
 	error = request_irq(keypad_data->irq, omap4_keypad_interrupt,
@@ -288,7 +350,6 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
 		goto err_pm_disable;
 	}
 
-	platform_set_drvdata(pdev, keypad_data);
 	return 0;
 
 err_pm_disable:
@@ -327,12 +388,19 @@ static int __devexit omap4_keypad_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id omap_keypad_dt_match[] = {
+	{ .compatible = "ti,omap4-keypad" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, omap_keypad_dt_match);
+
 static struct platform_driver omap4_keypad_driver = {
 	.probe		= omap4_keypad_probe,
 	.remove		= __devexit_p(omap4_keypad_remove),
 	.driver		= {
 		.name	= "omap4-keypad",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(omap_keypad_dt_match),
 	},
 };
 module_platform_driver(omap4_keypad_driver);
-- 
1.7.1

