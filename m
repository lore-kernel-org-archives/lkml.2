Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463Ab2CMTWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 15:22:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54163 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758289Ab2CMTWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 15:22:38 -0400
Date: Tue, 13 Mar 2012 23:22:33 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] max17042_battery: Make it possible to instantiate
 driver from DT
Message-ID: <20120313192233.GC2187@oksana.dev.rtsoft.ru>
References: <1329933982-2529-1-git-send-email-k.lewandowsk@samsung.com>
 <1329933982-2529-4-git-send-email-k.lewandowsk@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1329933982-2529-4-git-send-email-k.lewandowsk@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 07:06:22PM +0100, Karol Lewandowski wrote:
> Allow both device tree (preferred) and platform data-based driver
> instantiation.
> 
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---

Thanks for the patch!

I applied the following version:

commit 651bfc379546af756dc6abbc9ce678e4607220be
Author: Karol Lewandowski <k.lewandowsk@samsung.com>
Date:   Wed Feb 22 19:06:22 2012 +0100

    max17042_battery: Make it possible to instantiate driver from DT
    
    Allow both device tree (preferred) and platform data-based driver
    instantiation.
    
    Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
    Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
    Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

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
index 872e9b4..e36763a 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -31,6 +31,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/power_supply.h>
 #include <linux/power/max17042_battery.h>
+#include <linux/of.h>
 
 /* Status register bits */
 #define STATUS_POR_BIT         (1 << 1)
@@ -608,6 +609,40 @@ static void max17042_init_worker(struct work_struct *work)
 	chip->init_complete = 1;
 }
 
+#ifdef CONFIG_OF
+static struct max17042_platform_data *
+max17042_get_pdata(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	u32 prop;
+	struct max17042_platform_data *pdata;
+
+	if (!np)
+		return dev->platform_data;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	/*
+	 * Require current sense resistor value to be specified for
+	 * current-sense functionality to be enabled at all.
+	 */
+	if (of_property_read_u32(np, "maxim,rsns-microohm", &prop) == 0) {
+		pdata->r_sns = prop;
+		pdata->enable_current_sense = true;
+	}
+
+	return pdata;
+}
+#else
+static struct max17042_platform_data *
+max17042_get_pdata(struct device *dev)
+{
+	return dev->platform_data;
+}
+#endif
+
 static int __devinit max17042_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -624,7 +659,11 @@ static int __devinit max17042_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	chip->client = client;
-	chip->pdata = client->dev.platform_data;
+	chip->pdata = max17042_get_pdata(&client->dev);
+	if (!chip->pdata) {
+		dev_err(&client->dev, "no platform data provided\n");
+		return -EINVAL;
+	}
 
 	i2c_set_clientdata(client, chip);
 
@@ -689,6 +728,14 @@ static int __devexit max17042_remove(struct i2c_client *client)
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
@@ -698,6 +745,7 @@ MODULE_DEVICE_TABLE(i2c, max17042_id);
 static struct i2c_driver max17042_i2c_driver = {
 	.driver	= {
 		.name	= "max17042",
+		.of_match_table = of_match_ptr(max17042_dt_match),
 	},
 	.probe		= max17042_probe,
 	.remove		= __devexit_p(max17042_remove),
