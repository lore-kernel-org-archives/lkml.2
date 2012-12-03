Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab2LCSQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:16:24 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42556 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2LCSQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:16:23 -0500
From: "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
To: anton.vorontsov@linaro.org
Cc: francescolavra.fl@gmail.com, rob.herring@calxeda.com, lee.jones@linaro.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        STEricsson_nomadik_linux@list.st.com, rajanikanth.hv@stericsson.com
Subject: [PATCH 1/2] ab8500: remove explicit handling of battery type
Date: Mon,  3 Dec 2012 23:42:54 +0530
Message-Id: <1354558375-15110-1-git-send-email-rajanikanth.hv@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>

dt property, 'battery-type' shall be one of supported technology type
instead blank.
refer:Documentation/devicetree/bindings/power_supply/ab8500/fg.txt
      for the list of supported types

thanks to Francesco Lavra for highlighting missing of_node_put(...)

for '3.7-rc5': of git://git.infradead.org/battery-2.6.git

Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Rajanikanth H.V <rajanikanth.hv@stericsson.com>
---
 drivers/power/ab8500_bmdata.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
index 03cc528..2230b2c 100644
--- a/drivers/power/ab8500_bmdata.c
+++ b/drivers/power/ab8500_bmdata.c
@@ -461,7 +461,6 @@ bmdevs_of_probe(struct device *dev,
 	struct  device_node *np_bat_supply;
 	struct	abx500_bm_data *bat;
 	const char *btech;
-	char bat_tech[8];
 	int i, thermistor;
 
 	*battery = &ab8500_bm_data;
@@ -488,12 +487,10 @@ bmdevs_of_probe(struct device *dev,
 		"stericsson,battery-type", NULL);
 	if (!btech) {
 		dev_warn(dev, "missing property battery-name/type\n");
-		strcpy(bat_tech, "UNKNOWN");
-	} else {
-		strcpy(bat_tech, btech);
+		of_node_put(np_bat_supply);
+		return -EINVAL;
 	}
-
-	if (strncmp(bat_tech, "LION", 4) == 0) {
+	if (strncmp(btech, "LION", 4) == 0) {
 		bat->no_maintenance  = true;
 		bat->chg_unknown_bat = true;
 		bat->bat_type[BATTERY_UNKNOWN].charge_full_design = 2600;
@@ -508,7 +505,7 @@ bmdevs_of_probe(struct device *dev,
 		if (thermistor == NTC_EXTERNAL) {
 			btype->batres_tbl =
 				temp_to_batres_tbl_ext_thermistor;
-		} else if (strncmp(bat_tech, "LION", 4) == 0) {
+		} else if (strncmp(btech, "LION", 4) == 0) {
 			btype->batres_tbl =
 				temp_to_batres_tbl_9100;
 		} else {
-- 
1.7.10.4

