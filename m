Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab1BPW22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:28:28 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:26544 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752211Ab1BPW2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:28:25 -0500
From: Daniel Drake <dsd@laptop.org>
To: cbou@mail.ru
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: x86@kernel.org
Cc: tglx@linutronix.de
Cc: mingo@redhat.com
Cc: hpa@zytor.com
Cc: dilinger@queued.net
Cc: dmitry.torokhov@gmail.com
Subject: [PATCH v3] olpc_battery: convert to platform device
Message-Id: <20110216222820.487AE9D401C@zog.reactivated.net>
Date: Wed, 16 Feb 2011 22:28:20 +0000 (GMT)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=_H0bgwFmRgMA:10 a=Op-mwl0xAAAA:8 a=JfrnYn6hAAAA:8 a=n_1kXKBb8GsEM_GdpjgA:9 a=7jCSquUVMXD64rjiqo0A:7 a=RBXHgz_6ojXup-uuYft61OSvxu8A:4 a=d4CUUju0HPYA:10 a=3Rfx1nUSh_UA:10 a=-pFb9KuGqfB3pWXF:21 a=EnW_uFfgsYpGpyWC:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed so that suspend/resume (wakeup) support can be added.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/platform/olpc/olpc.c |   15 +++++++++++
 drivers/power/olpc_battery.c  |   53 +++++++++++++++++++++++-----------------
 2 files changed, 45 insertions(+), 23 deletions(-)

v2: add MODULE_ALIAS thanks to Dmitry Torokhov

v3: fix __devexit annotation thanks to Dmitry

diff --git a/arch/x86/platform/olpc/olpc.c b/arch/x86/platform/olpc/olpc.c
index edaf3fe..a5fb933 100644
--- a/arch/x86/platform/olpc/olpc.c
+++ b/arch/x86/platform/olpc/olpc.c
@@ -239,6 +239,17 @@ static int __init add_xo1_platform_devices(void)
 	return 0;
 }
 
+static int __init add_common_platform_devices(void)
+{
+	struct platform_device *pdev;
+
+	pdev = platform_device_register_simple("olpc-battery", -1, NULL, 0);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	return 0;
+}
+
 static int __init olpc_init(void)
 {
 	int r = 0;
@@ -269,6 +280,10 @@ static int __init olpc_init(void)
 			olpc_platform_info.boardrev >> 4,
 			olpc_platform_info.ecver);
 
+	r = add_common_platform_devices();
+	if (r)
+		return r;
+
 	if (olpc_platform_info.boardrev < olpc_board_pre(0xd0)) { /* XO-1 */
 		r = add_xo1_platform_devices();
 		if (r)
diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index 0b0ff3a..18580b4 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -519,8 +519,6 @@ static struct device_attribute olpc_bat_error = {
  *		Initialisation
  *********************************************************************/
 
-static struct platform_device *bat_pdev;
-
 static struct power_supply olpc_bat = {
 	.get_property = olpc_bat_get_property,
 	.use_for_apm = 1,
@@ -534,14 +532,11 @@ void olpc_battery_trigger_uevent(unsigned long cause)
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
@@ -552,21 +547,16 @@ static int __init olpc_bat_init(void)
 		return -ENXIO;
 	}
 
+	/* Ignore the status. It doesn't actually matter */
 	ret = olpc_ec_cmd(EC_BAT_STATUS, NULL, 0, &status, 1);
 	if (ret)
 		return ret;
 
-	/* Ignore the status. It doesn't actually matter */
-
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
+	olpc_bat.name = pdev->name;
 	if (olpc_board_at_least(olpc_board_pre(0xd0))) { /* XO-1.5 */
 		olpc_bat.properties = olpc_xo15_bat_props;
 		olpc_bat.num_properties = ARRAY_SIZE(olpc_xo15_bat_props);
@@ -575,7 +565,7 @@ static int __init olpc_bat_init(void)
 		olpc_bat.num_properties = ARRAY_SIZE(olpc_xo1_bat_props);
 	}
 
-	ret = power_supply_register(&bat_pdev->dev, &olpc_bat);
+	ret = power_supply_register(&pdev->dev, &olpc_bat);
 	if (ret)
 		goto battery_failed;
 
@@ -587,7 +577,7 @@ static int __init olpc_bat_init(void)
 	if (ret)
 		goto error_failed;
 
-	goto success;
+	return 0;
 
 error_failed:
 	device_remove_bin_file(olpc_bat.dev, &olpc_bat_eeprom);
@@ -595,19 +585,35 @@ eeprom_failed:
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
+}
+
+static struct platform_driver olpc_battery_drv = {
+	.driver = {
+		.name = "olpc-battery",
+		.owner = THIS_MODULE,
+	},
+	.probe = olpc_battery_probe,
+	.remove = __devexit_p(olpc_battery_remove),
+};
+
+static int __init olpc_bat_init(void)
+{
+	return platform_driver_register(&olpc_battery_drv);
+}
+
+static void __exit olpc_bat_exit(void)
+{
+	platform_driver_unregister(&olpc_battery_drv);
 }
 
 module_init(olpc_bat_init);
@@ -616,3 +622,4 @@ module_exit(olpc_bat_exit);
 MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Battery driver for One Laptop Per Child 'XO' machine");
+MODULE_ALIAS("platform:olpc-battery");
-- 
1.7.4

