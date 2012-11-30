Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030275Ab2K3MAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 07:00:03 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60855 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2K3L56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:57:58 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, cbou@mail.ru,
        dwmw2@infradead.org, rajanikanth.hv@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/12] ab8500-bmdata: Re-jiggle bmdevs_of_probe to be more succinct
Date: Fri, 30 Nov 2012 11:57:27 +0000
Message-Id: <1354276654-590-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
References: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can actually write bmdevs_of_probe to be easier to follow, use
less lines of code and we can even render a variable unused so
that we can remove it completely.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_bmdata.c |   49 ++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
index 2623b16..df5a590 100644
--- a/drivers/power/ab8500_bmdata.c
+++ b/drivers/power/ab8500_bmdata.c
@@ -456,38 +456,29 @@ int __devinit bmdevs_of_probe(struct device *dev,
 			      struct device_node *np,
 			      struct abx500_bm_data **battery)
 {
-	struct abx500_battery_type *btype;
+	struct batres_vs_temp *tmp_batres_tbl;
 	struct device_node *np_bat_supply;
 	struct abx500_bm_data *bat;
 	const char *btech;
-	int i, thermistor;
+	int i;
 
 	*battery = &ab8500_bm_data;
 
 	/* get phandle to 'battery-info' node */
 	np_bat_supply = of_parse_phandle(np, "battery", 0);
 	if (!np_bat_supply) {
-		dev_err(dev, "missing property battery\n");
+		dev_err(dev, "battery node or reference missing\n");
 		return -EINVAL;
 	}
 
-	if (of_property_read_bool(np_bat_supply, "thermistor-on-batctrl"))
-		thermistor = NTC_INTERNAL;
-	else
-		thermistor = NTC_EXTERNAL;
-
-	bat = *battery;
-	if (thermistor == NTC_EXTERNAL) {
-		bat->n_btypes  = 4;
-		bat->bat_type  = bat_type_ext_thermistor;
-		bat->adc_therm = ABx500_ADC_THERM_BATTEMP;
-	}
-
 	btech = of_get_property(np_bat_supply, "stericsson,battery-type", NULL);
 	if (!btech) {
 		dev_warn(dev, "missing property battery-name/type\n");
 		return -EINVAL;
 	}
+
+	bat = *battery;
+
 	if (strncmp(btech, "LION", 4) == 0) {
 		bat->no_maintenance  = true;
 		bat->chg_unknown_bat = true;
@@ -498,20 +489,22 @@ int __devinit bmdevs_of_probe(struct device *dev,
 		bat->bat_type[BATTERY_UNKNOWN].normal_vol_lvl	  = 4200;
 	}
 
-	/* select the battery resolution table */
-	for (i = 0; i < bat->n_btypes; ++i) {
-		btype = (bat->bat_type + i);
-		if (thermistor == NTC_EXTERNAL) {
-			btype->batres_tbl =
-				temp_to_batres_tbl_ext_thermistor;
-		} else if (strncmp(btech, "LION", 4) == 0) {
-			btype->batres_tbl =
-				temp_to_batres_tbl_9100;
-		} else {
-			btype->batres_tbl =
-				temp_to_batres_tbl_thermistor;
-		}
+	if (of_property_read_bool(np_bat_supply, "thermistor-on-batctrl")) {
+		if (strncmp(btech, "LION", 4) == 0)
+			tmp_batres_tbl = temp_to_batres_tbl_9100;
+		else
+			tmp_batres_tbl = temp_to_batres_tbl_thermistor;
+	} else {
+		bat->n_btypes   = 4;
+		bat->bat_type   = bat_type_ext_thermistor;
+		bat->adc_therm  = ABx500_ADC_THERM_BATTEMP;
+		tmp_batres_tbl  = temp_to_batres_tbl_ext_thermistor;
 	}
+
+	/* select the battery resolution table */
+	for (i = 0; i < bat->n_btypes; ++i)
+		bat->bat_type[i]->batres_tbl = tmp_batres_tbl;
+
 	of_node_put(np_bat_supply);
 
 	return 0;
-- 
1.7.9.5

