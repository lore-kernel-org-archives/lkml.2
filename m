Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab2GXN6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:58:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40851 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab2GXN6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:58:53 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tobias Klauser <tklauser@distanz.ch>, David Jander <david@protonic.nl>,
        JJ Ding <dgdunix@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH v3] input: gpio_keys_polled: convert to dt
Date: Tue, 24 Jul 2012 10:59:06 -0300
Message-Id: <1343138346-11942-1-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
Dmitry, I've made a few adjustments from your patch.

Applies to linux-next next-20120723

Changes since v2:
* Use modification suggestion from Dmitry and avoid pdata copy

Changes since v1:
* Add biding documentation
* Fix sizeof in memset
* Cleanup dt properties extraction
* Use for_each macro
* Fix memleak on buttons

 .../devicetree/bindings/input/gpio-keys-polled.txt |   38 ++++++
 drivers/input/keyboard/gpio_keys_polled.c          |  140 +++++++++++++++++++-
 2 files changed, 173 insertions(+), 5 deletions(-)
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
index 20c8ab1..c728aba 100644
--- a/drivers/input/keyboard/gpio_keys_polled.c
+++ b/drivers/input/keyboard/gpio_keys_polled.c
@@ -25,6 +25,8 @@
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/gpio_keys.h>
+#include <linux/of_platform.h>
+#include <linux/of_gpio.h>
 
 #define DRV_NAME	"gpio-keys-polled"
 
@@ -100,6 +102,108 @@ static void gpio_keys_polled_close(struct input_polled_dev *dev)
 		pdata->disable(bdev->dev);
 }
 
+#ifdef CONFIG_OF
+static struct gpio_keys_platform_data * __devinit
+gpio_keys_polled_get_devtree_pdata(struct device *dev)
+{
+	struct device_node *node, *pp;
+	struct gpio_keys_platform_data *pdata;
+	struct gpio_keys_button *buttons;
+	int error;
+	int nbuttons;
+	int i;
+
+	node = dev->of_node;
+	if (!node) {
+		error = -ENODEV;
+		goto err_out;
+	}
+
+	nbuttons = of_get_child_count(node);
+	if (nbuttons == 0) {
+		error = -ENODEV;
+		goto err_out;
+	}
+
+	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		error = -ENOMEM;
+		goto err_out;
+	}
+
+	buttons = kzalloc(nbuttons * sizeof(*buttons), GFP_KERNEL);
+	if (!buttons) {
+		error = -ENOMEM;
+		goto err_free_pdata;
+	}
+
+	pdata->nbuttons = nbuttons;
+	pdata->buttons = buttons;
+
+	pdata->rep = !!of_get_property(node, "autorepeat", NULL);
+	of_property_read_u32(node, "poll-interval", &pdata->poll_interval);
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
+
+		buttons[i].gpio = of_get_gpio_flags(pp, 0, &flags);
+		buttons[i].active_low = flags & OF_GPIO_ACTIVE_LOW;
+
+		if (of_property_read_u32(pp, "linux,code", &buttons[i].code)) {
+			dev_err(dev, "Button without keycode: 0x%x\n",
+				buttons[i].gpio);
+			error = -EINVAL;
+			goto err_free_buttons;
+		}
+
+		buttons[i].desc = of_get_property(pp, "label", NULL);
+
+		if (of_property_read_u32(pp, "linux,input-type",
+				&buttons[i].type))
+			buttons[i].type = EV_KEY;
+
+		buttons[i].wakeup = !!of_get_property(pp, "gpio-key,wakeup",
+			NULL);
+
+		if (of_property_read_u32(pp, "debounce-interval",
+					 &buttons[i].debounce_interval))
+			buttons[i].debounce_interval = 5;
+
+		i++;
+	}
+
+	return pdata;
+
+err_free_buttons:
+	kfree(buttons);
+err_free_pdata:
+	kfree(pdata);
+err_out:
+	return ERR_PTR(error);
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
+static inline struct gpio_keys_platform_data *
+gpio_keys_polled_get_devtree_pdata(struct device *dev)
+{
+	return ERR_PTR(-ENODEV);
+}
+#endif
+
 static int __devinit gpio_keys_polled_probe(struct platform_device *pdev)
 {
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
@@ -110,15 +214,24 @@ static int __devinit gpio_keys_polled_probe(struct platform_device *pdev)
 	int error;
 	int i;
 
-	if (!pdata || !pdata->poll_interval)
-		return -EINVAL;
+	if (!pdata) {
+		pdata = gpio_keys_polled_get_devtree_pdata(dev);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
+	}
+
+	if (!pdata->poll_interval) {
+		error = -EINVAL;
+		goto err_free_pdata;
+	}
 
 	bdev = kzalloc(sizeof(struct gpio_keys_polled_dev) +
 		       pdata->nbuttons * sizeof(struct gpio_keys_button_data),
 		       GFP_KERNEL);
 	if (!bdev) {
 		dev_err(dev, "no memory for private data\n");
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto err_free_pdata;
 	}
 
 	poll_dev = input_allocate_polled_device();
@@ -197,7 +310,7 @@ static int __devinit gpio_keys_polled_probe(struct platform_device *pdev)
 	/* report initial state of the buttons */
 	for (i = 0; i < pdata->nbuttons; i++)
 		gpio_keys_polled_check_state(input, &pdata->buttons[i],
-					 &bdev->data[i]);
+					     &bdev->data[i]);
 
 	return 0;
 
@@ -209,8 +322,15 @@ err_free_gpio:
 
 err_free_bdev:
 	kfree(bdev);
-
 	platform_set_drvdata(pdev, NULL);
+
+err_free_pdata:
+	/* If we have no platform_data, we allocated pdata dynamically.  */
+	if (!dev_get_platdata(&pdev->dev)) {
+		kfree(pdata->buttons);
+		kfree(pdata);
+	}
+
 	return error;
 }
 
@@ -227,6 +347,15 @@ static int __devexit gpio_keys_polled_remove(struct platform_device *pdev)
 
 	input_free_polled_device(bdev->poll_dev);
 
+	/*
+	 * If we had no platform_data, we allocated pdata dynamically and
+	 * must free it here.
+	 */
+	if (!dev_get_platdata(&pdev->dev)) {
+		kfree(pdata->buttons);
+		kfree(pdata);
+	}
+
 	kfree(bdev);
 	platform_set_drvdata(pdev, NULL);
 
@@ -239,6 +368,7 @@ static struct platform_driver gpio_keys_polled_driver = {
 	.driver	= {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(gpio_keys_polled_of_match),
 	},
 };
 module_platform_driver(gpio_keys_polled_driver);
-- 
1.7.10

