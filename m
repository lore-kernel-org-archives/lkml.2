Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab1FUMIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:08:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37767 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752189Ab1FUMIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:08:51 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] power_supply: Support multiple wm831x_power instances
Date: Tue, 21 Jun 2011 13:08:45 +0100
Message-Id: <1308658125-25013-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308658125-25013-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1308658125-25013-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there are multiple wm831x devices in the system we need to assign
different names to the power supply devices in order to ensure we can
create the sysfs entries for them.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/power/wm831x_power.c |   26 +++++++++++++++++++++++---
 1 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/power/wm831x_power.c b/drivers/power/wm831x_power.c
index ddf8cf5..6cc2ca6 100644
--- a/drivers/power/wm831x_power.c
+++ b/drivers/power/wm831x_power.c
@@ -24,6 +24,9 @@ struct wm831x_power {
 	struct power_supply wall;
 	struct power_supply usb;
 	struct power_supply battery;
+	char wall_name[20];
+	char usb_name[20];
+	char battery_name[20];
 };
 
 static int wm831x_power_check_online(struct wm831x *wm831x, int supply,
@@ -486,6 +489,7 @@ static irqreturn_t wm831x_pwr_src_irq(int irq, void *data)
 static __devinit int wm831x_power_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_pdata *wm831x_pdata = wm831x->dev->platform_data;
 	struct wm831x_power *power;
 	struct power_supply *usb;
 	struct power_supply *battery;
@@ -503,12 +507,28 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 	battery = &power->battery;
 	wall = &power->wall;
 
+	if (wm831x_pdata && wm831x_pdata->wm831x_num) {
+		snprintf(power->wall_name, sizeof(power->wall_name),
+			 "wm831x-wall.%d", wm831x_pdata->wm831x_num);
+		snprintf(power->battery_name, sizeof(power->wall_name),
+			 "wm831x-battery.%d", wm831x_pdata->wm831x_num);
+		snprintf(power->usb_name, sizeof(power->wall_name),
+			 "wm831x-usb.%d", wm831x_pdata->wm831x_num);
+	} else {
+		snprintf(power->wall_name, sizeof(power->wall_name),
+			 "wm831x-wall");
+		snprintf(power->battery_name, sizeof(power->wall_name),
+			 "wm831x-battery");
+		snprintf(power->usb_name, sizeof(power->wall_name),
+			 "wm831x-usb");
+	}
+
 	/* We ignore configuration failures since we can still read back
 	 * the status without enabling the charger.
 	 */
 	wm831x_config_battery(wm831x);
 
-	wall->name = "wm831x-wall";
+	wall->name = power->wall_name;
 	wall->type = POWER_SUPPLY_TYPE_MAINS;
 	wall->properties = wm831x_wall_props;
 	wall->num_properties = ARRAY_SIZE(wm831x_wall_props);
@@ -517,7 +537,7 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_kmalloc;
 
-	battery->name = "wm831x-battery";
+	battery->name = power->battery_name;
 	battery->properties = wm831x_bat_props;
 	battery->num_properties = ARRAY_SIZE(wm831x_bat_props);
 	battery->get_property = wm831x_bat_get_prop;
@@ -526,7 +546,7 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_wall;
 
-	usb->name = "wm831x-usb",
+	usb->name = power->usb_name,
 	usb->type = POWER_SUPPLY_TYPE_USB;
 	usb->properties = wm831x_usb_props;
 	usb->num_properties = ARRAY_SIZE(wm831x_usb_props);
-- 
1.7.5.4

