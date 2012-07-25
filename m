Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab2GYUyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 16:54:38 -0400
Received: from svenfoo.org ([82.94.215.22]:46466 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab2GYUyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 16:54:36 -0400
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <zonque@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
        Ville Syrjala <syrjala@sci.fi>
Subject: [PATCH 2/2] onewire: w1-gpio: add DT bindings
Date: Wed, 25 Jul 2012 22:54:30 +0200
Message-Id: <1343249670-14985-2-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1343249670-14985-1-git-send-email-zonque@gmail.com>
References: <1343249670-14985-1-git-send-email-zonque@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add DT bindings to the w1-gpio driver, along with some
documentation on how to use them.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Ville Syrjala <syrjala@sci.fi>
---
 Documentation/devicetree/bindings/w1/w1-gpio.txt |   22 +++++++++++
 drivers/w1/masters/w1-gpio.c                     |   46 ++++++++++++++++++++++
 2 files changed, 68 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/w1/w1-gpio.txt

diff --git a/Documentation/devicetree/bindings/w1/w1-gpio.txt b/Documentation/devicetree/bindings/w1/w1-gpio.txt
new file mode 100644
index 0000000..6e09c35
--- /dev/null
+++ b/Documentation/devicetree/bindings/w1/w1-gpio.txt
@@ -0,0 +1,22 @@
+w1-gpio devicetree bindings
+
+Required properties:
+
+ - compatible: "w1-gpio"
+ - gpios: one or two GPIO specs:
+		- the first one is used as data I/O pin
+		- the second one is optional. If specified, it is used as
+		  enable pin for an external pin pullup.
+
+Optional properties:
+
+ - linux,open-drain: if specified, the data pin is considered in
+		     open-drain mode.
+
+Examples:
+
+	onewire@0 {
+		compatible = "w1-gpio";
+		gpios = <&gpio 126 0>, <&gpio 105 0>;
+	};
+
diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index dac88ff..c4644b4 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -14,6 +14,8 @@
 #include <linux/slab.h>
 #include <linux/w1-gpio.h>
 #include <linux/gpio.h>
+#include <linux/of_platform.h>
+#include <linux/of_gpio.h>
 
 #include "../w1.h"
 #include "../w1_int.h"
@@ -42,12 +44,55 @@ static u8 w1_gpio_read_bit(void *data)
 	return gpio_get_value(pdata->pin) ? 1 : 0;
 }
 
+#ifdef CONFIG_OF
+static struct of_device_id w1_gpio_dt_ids[] = {
+	{ .compatible = "w1-gpio" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, w1_gpio_dt_ids);
+
+static int w1_gpio_probe_dt(struct platform_device *pdev)
+{
+	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
+	const struct of_device_id *of_id =
+			of_match_device(w1_gpio_dt_ids, &pdev->dev);
+
+	if (!of_id)
+		return 0;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	if (of_get_property(np, "linux,open-drain", NULL))
+		pdata->is_open_drain = 1;
+
+	pdata->pin = of_get_gpio(np, 0);
+	pdata->ext_pullup_enable_pin = of_get_gpio(np, 1);
+	pdev->dev.platform_data = pdata;
+
+	return 0;
+}
+#else
+static int w1_gpio_probe_dt(struct platform_device *pdev)
+{
+	return 0;
+}
+#endif
+
 static int __init w1_gpio_probe(struct platform_device *pdev)
 {
 	struct w1_bus_master *master;
 	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
 	int err;
 
+	err = w1_gpio_probe_dt(pdev);
+	if (err < 0)
+		return err;
+
+	pdata = pdev->dev.platform_data;
+
 	if (!pdata)
 		return -ENXIO;
 
@@ -151,6 +196,7 @@ static struct platform_driver w1_gpio_driver = {
 	.driver = {
 		.name	= "w1-gpio",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(w1_gpio_dt_ids),
 	},
 	.remove	= __exit_p(w1_gpio_remove),
 	.suspend = w1_gpio_suspend,
-- 
1.7.10.4

