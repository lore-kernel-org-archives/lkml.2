Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030261Ab2K3L7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:59:12 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:56512 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab2K3L6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:58:02 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, cbou@mail.ru,
        dwmw2@infradead.org, rajanikanth.hv@linaro.org,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 07/12] ab8500_bm: Always send platform specific battery information via pdata
Date: Fri, 30 Nov 2012 11:57:29 +0000
Message-Id: <1354276654-590-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
References: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the AB8500 battery management subsystem receives platform
specific information via two different means depending on how the
platform is booted. If DT is not enabled, a reference to a *_bm_data
data structure containing each platform specific attribute is passed
though platform_data. However, if DT is enabled, then platform_data
is empty and the reference is gained though a DT specific probe
function. There are two issues here 1) the same reference is
being collected each time and 2) the DT way doesn't allow any
provisions to select different platform specific attributes, which
kind of defeats the object.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-core.c       |    8 --------
 drivers/power/ab8500_bmdata.c   |   33 ++++++++++++++-------------------
 drivers/power/ab8500_btemp.c    |    2 +-
 drivers/power/ab8500_charger.c  |    2 +-
 drivers/power/ab8500_fg.c       |    2 +-
 drivers/power/abx500_chargalg.c |    2 +-
 include/linux/mfd/abx500.h      |    2 +-
 7 files changed, 19 insertions(+), 32 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 7745c96..757fec8 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1012,40 +1012,32 @@ static struct mfd_cell __devinitdata ab8500_bm_devs[] = {
 		.of_compatible = "stericsson,ab8500-charger",
 		.num_resources = ARRAY_SIZE(ab8500_charger_resources),
 		.resources = ab8500_charger_resources,
-#ifndef CONFIG_OF
 		.platform_data = &ab8500_bm_data,
 		.pdata_size = sizeof(ab8500_bm_data),
-#endif
 	},
 	{
 		.name = "ab8500-btemp",
 		.of_compatible = "stericsson,ab8500-btemp",
 		.num_resources = ARRAY_SIZE(ab8500_btemp_resources),
 		.resources = ab8500_btemp_resources,
-#ifndef CONFIG_OF
 		.platform_data = &ab8500_bm_data,
 		.pdata_size = sizeof(ab8500_bm_data),
-#endif
 	},
 	{
 		.name = "ab8500-fg",
 		.of_compatible = "stericsson,ab8500-fg",
 		.num_resources = ARRAY_SIZE(ab8500_fg_resources),
 		.resources = ab8500_fg_resources,
-#ifndef CONFIG_OF
 		.platform_data = &ab8500_bm_data,
 		.pdata_size = sizeof(ab8500_bm_data),
-#endif
 	},
 	{
 		.name = "ab8500-chargalg",
 		.of_compatible = "stericsson,ab8500-chargalg",
 		.num_resources = ARRAY_SIZE(ab8500_chargalg_resources),
 		.resources = ab8500_chargalg_resources,
-#ifndef CONFIG_OF
 		.platform_data = &ab8500_bm_data,
 		.pdata_size = sizeof(ab8500_bm_data),
-#endif
 	},
 };
 
diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
index c2fb2c5..6b772e5 100644
--- a/drivers/power/ab8500_bmdata.c
+++ b/drivers/power/ab8500_bmdata.c
@@ -454,16 +454,13 @@ struct abx500_bm_data ab8500_bm_data = {
 
 int __devinit ab8500_bm_of_probe(struct device *dev,
 				 struct device_node *np,
-				 struct abx500_bm_data **battery)
+				 struct abx500_bm_data *bm)
 {
 	struct batres_vs_temp *tmp_batres_tbl;
 	struct device_node *np_bat_supply;
-	struct abx500_bm_data *bat;
 	const char *btech;
 	int i;
 
-	*battery = &ab8500_bm_data;
-
 	/* get phandle to 'battery-info' node */
 	np_bat_supply = of_parse_phandle(np, "battery", 0);
 	if (!np_bat_supply) {
@@ -477,16 +474,14 @@ int __devinit ab8500_bm_of_probe(struct device *dev,
 		return -EINVAL;
 	}
 
-	bat = *battery;
-
 	if (strncmp(btech, "LION", 4) == 0) {
-		bat->no_maintenance  = true;
-		bat->chg_unknown_bat = true;
-		bat->bat_type[BATTERY_UNKNOWN].charge_full_design = 2600;
-		bat->bat_type[BATTERY_UNKNOWN].termination_vol    = 4150;
-		bat->bat_type[BATTERY_UNKNOWN].recharge_vol	  = 4130;
-		bat->bat_type[BATTERY_UNKNOWN].normal_cur_lvl	  = 520;
-		bat->bat_type[BATTERY_UNKNOWN].normal_vol_lvl	  = 4200;
+		bm->no_maintenance  = true;
+		bm->chg_unknown_bat = true;
+		bm->bat_type[BATTERY_UNKNOWN].charge_full_design = 2600;
+		bm->bat_type[BATTERY_UNKNOWN].termination_vol    = 4150;
+		bm->bat_type[BATTERY_UNKNOWN].recharge_vol       = 4130;
+		bm->bat_type[BATTERY_UNKNOWN].normal_cur_lvl     = 520;
+		bm->bat_type[BATTERY_UNKNOWN].normal_vol_lvl     = 4200;
 	}
 
 	if (of_property_read_bool(np_bat_supply, "thermistor-on-batctrl")) {
@@ -495,15 +490,15 @@ int __devinit ab8500_bm_of_probe(struct device *dev,
 		else
 			tmp_batres_tbl = temp_to_batres_tbl_thermistor;
 	} else {
-		bat->n_btypes   = 4;
-		bat->bat_type   = bat_type_ext_thermistor;
-		bat->adc_therm  = ABx500_ADC_THERM_BATTEMP;
-		tmp_batres_tbl  = temp_to_batres_tbl_ext_thermistor;
+		bm->n_btypes   = 4;
+		bm->bat_type   = bat_type_ext_thermistor;
+		bm->adc_therm  = ABx500_ADC_THERM_BATTEMP;
+		tmp_batres_tbl = temp_to_batres_tbl_ext_thermistor;
 	}
 
 	/* select the battery resolution table */
-	for (i = 0; i < bat->n_btypes; ++i)
-		bat->bat_type[i]->batres_tbl = tmp_batres_tbl;
+	for (i = 0; i < bm->n_btypes; ++i)
+		bm->bat_type[i].batres_tbl = tmp_batres_tbl;
 
 	of_node_put(np_bat_supply);
 
diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 33ed0fc..c0f7dcc 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -988,7 +988,7 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 	di->bm = pdev->mfd_cell->platform_data;
 	if (!di->bm) {
 		if (np) {
-			ret = ab8500_bm_of_probe(&pdev->dev, np, &di->bm);
+			ret = ab8500_bm_of_probe(&pdev->dev, np, di->bm);
 			if (ret) {
 				dev_err(&pdev->dev,
 					"failed to get battery information\n");
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 21dc842..c1077df 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -2647,7 +2647,7 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	di->bm = pdev->mfd_cell->platform_data;
 	if (!di->bm) {
 		if (np) {
-			ret = ab8500_bm_of_probe(&pdev->dev, np, &di->bm);
+			ret = ab8500_bm_of_probe(&pdev->dev, np, di->bm);
 			if (ret) {
 				dev_err(&pdev->dev,
 					"failed to get battery information\n");
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 4cf2313..8bb9df9 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2460,7 +2460,7 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 	di->bm = pdev->mfd_cell->platform_data;
 	if (!di->bm) {
 		if (np) {
-			ret = ab8500_bm_of_probe(&pdev->dev, np, &di->bm);
+			ret = ab8500_bm_of_probe(&pdev->dev, np, di->bm);
 			if (ret) {
 				dev_err(&pdev->dev,
 					"failed to get battery information\n");
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index ea2e2eb..22a511c 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -1817,7 +1817,7 @@ static int __devinit abx500_chargalg_probe(struct platform_device *pdev)
 	di->bm = pdev->mfd_cell->platform_data;
 	if (!di->bm) {
 		if (np) {
-			ret = ab8500_bm_of_probe(&pdev->dev, np, &di->bm);
+			ret = ab8500_bm_of_probe(&pdev->dev, np, di->bm);
 			if (ret) {
 				dev_err(&pdev->dev,
 					"failed to get battery information\n");
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index e10662a..68e5759 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -292,7 +292,7 @@ enum {
 
 int ab8500_bm_of_probe(struct device *dev,
 		       struct device_node *np,
-		       struct abx500_bm_data **battery);
+		       struct abx500_bm_data *bm);
 
 int abx500_set_register_interruptible(struct device *dev, u8 bank, u8 reg,
 	u8 value);
-- 
1.7.9.5

