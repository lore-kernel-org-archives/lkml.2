Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab1HOXhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 19:37:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52799 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751101Ab1HOXhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 19:37:50 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] power_supply: Only register WM831x battery charger if enabled
Date: Tue, 16 Aug 2011 08:37:42 +0900
Message-Id: <1313451462-15672-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't tell the system about the battery charger if it's not enabled, we
can reasonably assume that if the charger is not enabled then no battery
will ever be connected so reporting state is at best going to waste time
and at worst going to cause confusing information in the UI.

For simplicity and robustness we continue to register and handle interrupts
from the charger.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/power/power_supply_sysfs.c |    4 +-
 drivers/power/wm831x_power.c       |   44 ++++++++++++++++++++++-------------
 2 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index e15d4c9..166927b 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -78,8 +78,8 @@ static ssize_t power_supply_show_property(struct device *dev,
 			dev_dbg(dev, "driver has no data for `%s' property\n",
 				attr->attr.name);
 		else if (ret != -ENODEV)
-			dev_err(dev, "driver failed to report `%s' property\n",
-				attr->attr.name);
+			dev_err(dev, "driver failed to report `%s' property: %d\n",
+				attr->attr.name, ret);
 		return ret;
 	}
 
diff --git a/drivers/power/wm831x_power.c b/drivers/power/wm831x_power.c
index 6cc2ca6..c32e6f8 100644
--- a/drivers/power/wm831x_power.c
+++ b/drivers/power/wm831x_power.c
@@ -27,6 +27,7 @@ struct wm831x_power {
 	char wall_name[20];
 	char usb_name[20];
 	char battery_name[20];
+	bool have_battery;
 };
 
 static int wm831x_power_check_online(struct wm831x *wm831x, int supply,
@@ -449,7 +450,8 @@ static irqreturn_t wm831x_bat_irq(int irq, void *data)
 
 	/* The battery charger is autonomous so we don't need to do
 	 * anything except kick user space */
-	power_supply_changed(&wm831x_power->battery);
+	if (wm831x_power->have_battery)
+		power_supply_changed(&wm831x_power->battery);
 
 	return IRQ_HANDLED;
 }
@@ -479,7 +481,8 @@ static irqreturn_t wm831x_pwr_src_irq(int irq, void *data)
 	dev_dbg(wm831x->dev, "Power source changed\n");
 
 	/* Just notify for everything - little harm in overnotifying. */
-	power_supply_changed(&wm831x_power->battery);
+	if (wm831x_power->have_battery)
+		power_supply_changed(&wm831x_power->battery);
 	power_supply_changed(&wm831x_power->usb);
 	power_supply_changed(&wm831x_power->wall);
 
@@ -537,15 +540,6 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_kmalloc;
 
-	battery->name = power->battery_name;
-	battery->properties = wm831x_bat_props;
-	battery->num_properties = ARRAY_SIZE(wm831x_bat_props);
-	battery->get_property = wm831x_bat_get_prop;
-	battery->use_for_apm = 1;
-	ret = power_supply_register(&pdev->dev, battery);
-	if (ret)
-		goto err_wall;
-
 	usb->name = power->usb_name,
 	usb->type = POWER_SUPPLY_TYPE_USB;
 	usb->properties = wm831x_usb_props;
@@ -553,7 +547,23 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 	usb->get_property = wm831x_usb_get_prop;
 	ret = power_supply_register(&pdev->dev, usb);
 	if (ret)
-		goto err_battery;
+		goto err_wall;
+
+	ret = wm831x_reg_read(wm831x, WM831X_CHARGER_CONTROL_1);
+	if (ret < 0)
+		goto err_wall;
+	power->have_battery = ret & WM831X_CHG_ENA;
+
+	if (power->have_battery) {
+		    battery->name = power->battery_name;
+		    battery->properties = wm831x_bat_props;
+		    battery->num_properties = ARRAY_SIZE(wm831x_bat_props);
+		    battery->get_property = wm831x_bat_get_prop;
+		    battery->use_for_apm = 1;
+		    ret = power_supply_register(&pdev->dev, battery);
+		    if (ret)
+			    goto err_usb;
+	}
 
 	irq = platform_get_irq_byname(pdev, "SYSLO");
 	ret = request_threaded_irq(irq, NULL, wm831x_syslo_irq,
@@ -562,7 +572,7 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request SYSLO IRQ %d: %d\n",
 			irq, ret);
-		goto err_usb;
+		goto err_battery;
 	}
 
 	irq = platform_get_irq_byname(pdev, "PWR SRC");
@@ -601,10 +611,11 @@ err_bat_irq:
 err_syslo:
 	irq = platform_get_irq_byname(pdev, "SYSLO");
 	free_irq(irq, power);
+err_battery:
+	if (power->have_battery)
+		power_supply_unregister(battery);
 err_usb:
 	power_supply_unregister(usb);
-err_battery:
-	power_supply_unregister(battery);
 err_wall:
 	power_supply_unregister(wall);
 err_kmalloc:
@@ -628,7 +639,8 @@ static __devexit int wm831x_power_remove(struct platform_device *pdev)
 	irq = platform_get_irq_byname(pdev, "SYSLO");
 	free_irq(irq, wm831x_power);
 
-	power_supply_unregister(&wm831x_power->battery);
+	if (wm831x_power->have_battery)
+		power_supply_unregister(&wm831x_power->battery);
 	power_supply_unregister(&wm831x_power->wall);
 	power_supply_unregister(&wm831x_power->usb);
 	kfree(wm831x_power);
-- 
1.7.5.4

