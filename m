Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab2FYUoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 16:44:23 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:52161 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab2FYUoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 16:44:20 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tobias Klauser <tklauser@distanz.ch>, David Jander <david@protonic.nl>,
        JJ Ding <dgdunix@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH v2] input: gpio_keys_polled: convert to dt
Date: Mon, 25 Jun 2012 17:44:03 -0300
Message-Id: <1340657047-8517-1-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---
Applies to v3.5-rc4

Changes since v1:
* Add biding documentation
* Fix sizeof in memset
* Cleanup dt properties extraction
* Use for_each macro
* Fix memleak on buttons

Thanks Rob Herring, Dmitry Torokhov and Roland Stiege for reviewing and 
improvements suggestions.

 .../devicetree/bindings/input/gpio-keys-polled.txt |   38 ++++++
 drivers/input/keyboard/gpio_keys_polled.c          |  131 ++++++++++++++++++--
 2 files changed, 158 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/gpio-keys-polled.txt

diff --git a/Documentation/devicetree/bindings/input/gpio-keys-polled.txt b/Documentation/devicetree/bindings/input/gpio-keys-polled.txt
new file mode 100644
index 0000000..313abef
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/gpio-keys-polled.txt
@@ -0,0 +1,38 @@
+Device-Tree bindings for input/gpio_keys_polled.c keyboard driver
+
+Required properties:
+	- compatible = "gpio-keys-polled";
+	- poll-interval: Poll interval time in milliseconds
+
+Optional properties:
+	- autorepeat: Boolean, Enable auto repeat feature of Linux input
+	  subsystem.
+
+Each button (key) is represented as a sub-node of "gpio-keys-polled":
+Subnode properties:
+
+	- gpios: OF device-tree gpio specification.
+	- label: Descriptive name of the key.
+	- linux,code: Keycode to emit.
+
+Optional subnode-properties:
+	- linux,input-type: Specify event type this button/key generates.
+	  If not specified defaults to <1> == EV_KEY.
+	- debounce-interval: Debouncing interval time in milliseconds.
+	  If not specified defaults to 5.
+	- gpio-key,wakeup: Boolean, button can wake-up the system.
+
+Example nodes:
+
+	gpio_keys_polled {
+			compatible = "gpio-keys-polled";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			poll-interval = <100>;
+			autorepeat;
+			button@21 {
+				label = "GPIO Key UP";
+				linux,code = <103>;
+				gpios = <&gpio1 0 1>;
+			};
+			...
diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
index 20c8ab1..e5cb3ef 100644
--- a/drivers/input/keyboard/gpio_keys_polled.c
+++ b/drivers/input/keyboard/gpio_keys_polled.c
@@ -25,6 +25,8 @@
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/gpio_keys.h>
+#include <linux/of_platform.h>
+#include <linux/of_gpio.h>
 
 #define DRV_NAME	"gpio-keys-polled"
 
@@ -38,7 +40,7 @@ struct gpio_keys_button_data {
 struct gpio_keys_polled_dev {
 	struct input_polled_dev *poll_dev;
 	struct device *dev;
-	struct gpio_keys_platform_data *pdata;
+	struct gpio_keys_platform_data pdata;
 	struct gpio_keys_button_data data[0];
 };
 
@@ -67,11 +69,11 @@ static void gpio_keys_polled_check_state(struct input_dev *input,
 static void gpio_keys_polled_poll(struct input_polled_dev *dev)
 {
 	struct gpio_keys_polled_dev *bdev = dev->private;
-	struct gpio_keys_platform_data *pdata = bdev->pdata;
+	struct gpio_keys_platform_data *pdata = &bdev->pdata;
 	struct input_dev *input = dev->input;
 	int i;
 
-	for (i = 0; i < bdev->pdata->nbuttons; i++) {
+	for (i = 0; i < pdata->nbuttons; i++) {
 		struct gpio_keys_button_data *bdata = &bdev->data[i];
 
 		if (bdata->count < bdata->threshold)
@@ -85,7 +87,7 @@ static void gpio_keys_polled_poll(struct input_polled_dev *dev)
 static void gpio_keys_polled_open(struct input_polled_dev *dev)
 {
 	struct gpio_keys_polled_dev *bdev = dev->private;
-	struct gpio_keys_platform_data *pdata = bdev->pdata;
+	struct gpio_keys_platform_data *pdata = &bdev->pdata;
 
 	if (pdata->enable)
 		pdata->enable(bdev->dev);
@@ -94,31 +96,125 @@ static void gpio_keys_polled_open(struct input_polled_dev *dev)
 static void gpio_keys_polled_close(struct input_polled_dev *dev)
 {
 	struct gpio_keys_polled_dev *bdev = dev->private;
-	struct gpio_keys_platform_data *pdata = bdev->pdata;
+	struct gpio_keys_platform_data *pdata = &bdev->pdata;
 
 	if (pdata->disable)
 		pdata->disable(bdev->dev);
 }
+#ifdef CONFIG_OF
+static int gpio_keys_polled_get_devtree_pdata(struct device *dev,
+			    struct gpio_keys_platform_data *pdata)
+{
+	struct device_node *node, *pp;
+	int i;
+	struct gpio_keys_button *buttons;
+
+	node = dev->of_node;
+	if (node == NULL)
+		return -ENODEV;
+
+	memset(pdata, 0, sizeof(*pdata));
+
+	pdata->rep = !!of_get_property(node, "autorepeat", NULL);
+
+	of_property_read_u32(node, "poll-interval", &pdata->poll_interval);
+
+	pdata->nbuttons = of_get_child_count(node);
+	if (pdata->nbuttons == 0)
+		return -ENODEV;
+
+	buttons = kzalloc(pdata->nbuttons * (sizeof *buttons), GFP_KERNEL);
+	if (!buttons)
+		return -ENOMEM;
+
+	i = 0;
+	for_each_child_of_node(node, pp) {
+		enum of_gpio_flags flags;
+
+		if (!of_find_property(pp, "gpios", NULL)) {
+			pdata->nbuttons--;
+			dev_warn(dev, "Found button without gpios\n");
+			continue;
+		}
+		buttons[i].gpio = of_get_gpio_flags(pp, 0, &flags);
+		buttons[i].active_low = flags & OF_GPIO_ACTIVE_LOW;
+
+		if (of_property_read_u32(pp, "linux,code", &buttons[i].code)) {
+			dev_err(dev, "Button without keycode: 0x%x\n",
+				buttons[i].gpio);
+			goto out_fail;
+		}
+
+		buttons[i].desc = of_get_property(pp, "label", NULL);
+
+		if (of_property_read_u32(pp, "linux,input-type",
+			&buttons[i].type))
+			buttons[i].type = EV_KEY;
+
+		buttons[i].wakeup = !!of_get_property(pp, "gpio-key,wakeup",
+			NULL);
+
+		if (of_property_read_u32(pp, "debounce-interval",
+			&buttons[i].debounce_interval))
+			buttons[i].debounce_interval = 5;
+
+		i++;
+	}
+
+	pdata->buttons = buttons;
+
+	return 0;
+
+out_fail:
+	kfree(buttons);
+	return -ENODEV;
+}
+
+static struct of_device_id gpio_keys_polled_of_match[] = {
+	{ .compatible = "gpio-keys-polled", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, gpio_keys_polled_of_match);
+
+#else
+
+static int gpio_keys_polled_get_devtree_pdata(struct device *dev,
+			    struct gpio_keys_platform_data *altp)
+{
+	return -ENODEV;
+}
+#endif
 
 static int __devinit gpio_keys_polled_probe(struct platform_device *pdev)
 {
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
 	struct device *dev = &pdev->dev;
+	struct gpio_keys_platform_data alt_pdata;
 	struct gpio_keys_polled_dev *bdev;
 	struct input_polled_dev *poll_dev;
 	struct input_dev *input;
 	int error;
 	int i;
 
-	if (!pdata || !pdata->poll_interval)
-		return -EINVAL;
+	if (!pdata) {
+		error = gpio_keys_polled_get_devtree_pdata(dev, &alt_pdata);
+		if (error)
+			return error;
+		pdata = &alt_pdata;
+	}
+
+	if (!pdata->poll_interval) {
+		error = -EINVAL;
+		goto err_free_buttons;
+	}
 
 	bdev = kzalloc(sizeof(struct gpio_keys_polled_dev) +
 		       pdata->nbuttons * sizeof(struct gpio_keys_button_data),
 		       GFP_KERNEL);
 	if (!bdev) {
 		dev_err(dev, "no memory for private data\n");
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto err_free_buttons;
 	}
 
 	poll_dev = input_allocate_polled_device();
@@ -184,7 +280,7 @@ static int __devinit gpio_keys_polled_probe(struct platform_device *pdev)
 
 	bdev->poll_dev = poll_dev;
 	bdev->dev = dev;
-	bdev->pdata = pdata;
+	bdev->pdata = *pdata;
 	platform_set_drvdata(pdev, bdev);
 
 	error = input_register_polled_device(poll_dev);
@@ -209,15 +305,19 @@ err_free_gpio:
 
 err_free_bdev:
 	kfree(bdev);
-
 	platform_set_drvdata(pdev, NULL);
+
+err_free_buttons:
+	/* If we have no platform_data, we allocated buttons dynamically. */
+	if (!pdev->dev.platform_data)
+		kfree(pdata->buttons);
 	return error;
 }
 
 static int __devexit gpio_keys_polled_remove(struct platform_device *pdev)
 {
 	struct gpio_keys_polled_dev *bdev = platform_get_drvdata(pdev);
-	struct gpio_keys_platform_data *pdata = bdev->pdata;
+	struct gpio_keys_platform_data *pdata = &bdev->pdata;
 	int i;
 
 	input_unregister_polled_device(bdev->poll_dev);
@@ -227,6 +327,14 @@ static int __devexit gpio_keys_polled_remove(struct platform_device *pdev)
 
 	input_free_polled_device(bdev->poll_dev);
 
+	/*
+	 * If we had no platform_data, we allocated buttons dynamically, and
+	 * must free them here. pdata->buttons is the pointer to the
+	 * beginning of the allocated array.
+	 */
+	if (!pdev->dev.platform_data)
+		kfree(pdata->buttons);
+
 	kfree(bdev);
 	platform_set_drvdata(pdev, NULL);
 
@@ -239,6 +347,7 @@ static struct platform_driver gpio_keys_polled_driver = {
 	.driver	= {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(gpio_keys_polled_of_match),
 	},
 };
 module_platform_driver(gpio_keys_polled_driver);
-- 
1.7.10

