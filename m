Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab2BVSGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:06:39 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:63493 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab2BVSGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:06:23 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 22 Feb 2012 19:06:22 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 3/3] max17042_battery: Make it possible to instantiate driver
 from DT
In-reply-to: <1329933982-2529-1-git-send-email-k.lewandowsk@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        cbou@mail.ru, Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1329933982-2529-4-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.7.8.3
References: <1329933982-2529-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow both device tree (preferred) and platform data-based driver
instantiation.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../bindings/power_supply/max17042_battery.txt     |   18 ++++++++
 drivers/power/max17042_battery.c                   |   45 ++++++++++++++++++--
 2 files changed, 59 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/max17042_battery.txt

diff --git a/Documentation/devicetree/bindings/power_supply/max17042_battery.txt b/Documentation/devicetree/bindings/power_supply/max17042_battery.txt
new file mode 100644
index 0000000..5bc9b68
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/max17042_battery.txt
@@ -0,0 +1,18 @@
+max17042_battery
+~~~~~~~~~~~~~~~~
+
+Required properties :
+ - compatible : "maxim,max17042"
+
+Optional properties :
+ - maxim,rsns-microohm : Resistance of rsns resistor in micro Ohms
+                         (datasheet-recommended value is 10000).
+   Defining this property enables current-sense functionality.
+
+Example:
+
+	battery-charger@36 {
+		compatible = "maxim,max17042";
+		reg = <0x36>;
+		maxim,rsns-microohm = <10000>;
+	};
diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 49c1377..aec883b 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -29,6 +29,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/power_supply.h>
 #include <linux/power/max17042_battery.h>
+#include <linux/of.h>
 
 struct max17042_chip {
 	struct i2c_client *client;
@@ -211,6 +212,31 @@ static int max17042_get_property(struct power_supply *psy,
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static int max17042_dt_parse(struct max17042_chip *chip, struct device_node *np)
+{
+	u32 prop;
+
+	if (!np)
+		return -EINVAL;
+
+	/* require current sense resistor value to be specified for
+	   current-sense functionality to be enabled at all */
+	if (of_property_read_u32(np, "maxim,rsns-microohm", &prop) == 0) {
+		chip->r_sns = prop;
+		chip->enable_current_sense = true;
+	} else
+		chip->enable_current_sense = false;
+
+	return 0;
+}
+#else
+static int max17042_dt_parse(struct max17042_chip *chip, struct device_node *np)
+{
+	return -EINVAL;
+}
+#endif
+
 static int __devinit max17042_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -237,12 +263,14 @@ static int __devinit max17042_probe(struct i2c_client *client,
 	chip->battery.properties	= max17042_battery_props;
 	chip->battery.num_properties	= ARRAY_SIZE(max17042_battery_props);
 
-	if (pdata) {
+	ret = max17042_dt_parse(chip, client->dev.of_node);
+	if (ret < 0) {
+		if (!pdata) {
+			dev_warn(&client->dev, "no driver data provided\n");
+			return -ENODEV;
+		}
 		chip->r_sns = pdata->r_sns;
 		chip->enable_current_sense = pdata->enable_current_sense;
-	} else {
-		dev_warn(&client->dev, "no driver data provided\n");
-		return -ENODEV;
 	}
 
 	/* When current is not measured,
@@ -281,6 +309,14 @@ static int __devexit max17042_remove(struct i2c_client *client)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id max17042_dt_match[] = {
+	{ .compatible = "maxim,max17042" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, max17042_dt_match);
+#endif
+
 static const struct i2c_device_id max17042_id[] = {
 	{ "max17042", 0 },
 	{ }
@@ -290,6 +326,7 @@ MODULE_DEVICE_TABLE(i2c, max17042_id);
 static struct i2c_driver max17042_i2c_driver = {
 	.driver	= {
 		.name	= "max17042",
+		.of_match_table = of_match_ptr(max17042_dt_match),
 	},
 	.probe		= max17042_probe,
 	.remove		= __devexit_p(max17042_remove),
-- 
1.7.8.3

