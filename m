Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab1G0SYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 14:24:21 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:29574 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752993Ab1G0SYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 14:24:19 -0400
From: Daniel Drake <dsd@laptop.org>
To: cbou@mail.ru
To: dwmw2@infradead.org
Cc: dilinger@queued.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] olpc_battery: bind to device tree
Message-Id: <20110727182414.4FA1C9D401C@zog.reactivated.net>
Date: Wed, 27 Jul 2011 19:24:14 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=QSoOSHhkoXYA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=JfrnYn6hAAAA:8 a=n_1kXKBb8GsEM_GdpjgA:9 a=ReiVs1o2FC8GtIfw4bUA:7 a=d4CUUju0HPYA:10 a=3Rfx1nUSh_UA:10 a=gutugl0X3WDAje4Y:21 a=C0rSbRZ15VPE_Wi5:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is cleaner, and allows suspend/resume (wakeup) handlers to be
added in an upcoming patch.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 .../bindings/power_supply/olpc_battery.txt         |    5 ++
 drivers/power/olpc_battery.c                       |   55 ++++++++++++--------
 2 files changed, 39 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/olpc_battery.txt

All previous review comments incorporated.
The fix to ensure the battery device exists (even on old firmware) is now
present in linus master.

diff --git a/Documentation/devicetree/bindings/power_supply/olpc_battery.txt b/Documentation/devicetree/bindings/power_supply/olpc_battery.txt
new file mode 100644
index 0000000..c8901b3
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/olpc_battery.txt
@@ -0,0 +1,5 @@
+OLPC battery
+~~~~~~~~~~~~
+
+Required properties:
+  - compatible : "olpc,xo1-battery"
diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index 0b0ff3a..9972268 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -519,9 +519,8 @@ static struct device_attribute olpc_bat_error = {
  *		Initialisation
  *********************************************************************/
 
-static struct platform_device *bat_pdev;
-
 static struct power_supply olpc_bat = {
+	.name = "olpc-battery",
 	.get_property = olpc_bat_get_property,
 	.use_for_apm = 1,
 };
@@ -534,14 +533,11 @@ void olpc_battery_trigger_uevent(unsigned long cause)
 		kobject_uevent(&olpc_bat.dev->kobj, KOBJ_CHANGE);
 }
 
-static int __init olpc_bat_init(void)
+static int __devinit olpc_battery_probe(struct platform_device *pdev)
 {
-	int ret = 0;
+	int ret;
 	uint8_t status;
 
-	if (!olpc_platform_info.ecver)
-		return -ENXIO;
-
 	/*
 	 * We've seen a number of EC protocol changes; this driver requires
 	 * the latest EC protocol, supported by 0x44 and above.
@@ -558,15 +554,10 @@ static int __init olpc_bat_init(void)
 
 	/* Ignore the status. It doesn't actually matter */
 
-	bat_pdev = platform_device_register_simple("olpc-battery", 0, NULL, 0);
-	if (IS_ERR(bat_pdev))
-		return PTR_ERR(bat_pdev);
-
-	ret = power_supply_register(&bat_pdev->dev, &olpc_ac);
+	ret = power_supply_register(&pdev->dev, &olpc_ac);
 	if (ret)
-		goto ac_failed;
+		return ret;
 
-	olpc_bat.name = bat_pdev->name;
 	if (olpc_board_at_least(olpc_board_pre(0xd0))) { /* XO-1.5 */
 		olpc_bat.properties = olpc_xo15_bat_props;
 		olpc_bat.num_properties = ARRAY_SIZE(olpc_xo15_bat_props);
@@ -575,7 +566,7 @@ static int __init olpc_bat_init(void)
 		olpc_bat.num_properties = ARRAY_SIZE(olpc_xo1_bat_props);
 	}
 
-	ret = power_supply_register(&bat_pdev->dev, &olpc_bat);
+	ret = power_supply_register(&pdev->dev, &olpc_bat);
 	if (ret)
 		goto battery_failed;
 
@@ -587,7 +578,7 @@ static int __init olpc_bat_init(void)
 	if (ret)
 		goto error_failed;
 
-	goto success;
+	return 0;
 
 error_failed:
 	device_remove_bin_file(olpc_bat.dev, &olpc_bat_eeprom);
@@ -595,22 +586,44 @@ eeprom_failed:
 	power_supply_unregister(&olpc_bat);
 battery_failed:
 	power_supply_unregister(&olpc_ac);
-ac_failed:
-	platform_device_unregister(bat_pdev);
-success:
 	return ret;
 }
 
-static void __exit olpc_bat_exit(void)
+static int __devexit olpc_battery_remove(struct platform_device *pdev)
 {
 	device_remove_file(olpc_bat.dev, &olpc_bat_error);
 	device_remove_bin_file(olpc_bat.dev, &olpc_bat_eeprom);
 	power_supply_unregister(&olpc_bat);
 	power_supply_unregister(&olpc_ac);
-	platform_device_unregister(bat_pdev);
+	return 0;
 }
 
+static const struct of_device_id olpc_battery_ids[] __devinitconst = {
+	{ .compatible = "olpc,xo1-battery" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, olpc_battery_ids);
+
+static struct platform_driver olpc_battery_drv = {
+	.driver = {
+		.name = "olpc-battery",
+		.owner = THIS_MODULE,
+		.of_match_table = olpc_battery_ids,
+	},
+	.probe = olpc_battery_probe,
+	.remove = __devexit_p(olpc_battery_remove),
+};
+
+static int __init olpc_bat_init(void)
+{
+	return platform_driver_register(&olpc_battery_drv);
+}
 module_init(olpc_bat_init);
+
+static void __exit olpc_bat_exit(void)
+{
+	platform_driver_unregister(&olpc_battery_drv);
+}
 module_exit(olpc_bat_exit);
 
 MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
-- 
1.7.6

