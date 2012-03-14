Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760399Ab2CNBFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 21:05:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43959 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760323Ab2CNBFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 21:05:06 -0400
Date: Wed, 14 Mar 2012 05:05:04 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Arun Murthy <arun.murthy@stericsson.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        karl.komierowski@stericsson.com, johan.palsson@stericsson.com,
        linus.walleij@linaro.org
Subject: [PATCH 2/6] ab8500_btemp: Get rid of 'enum adc_therm'
Message-ID: <20120314010504.GB10798@oksana.dev.rtsoft.ru>
References: <20120314005901.GB1778@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120314005901.GB1778@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the same as abx500_adc_therm, but when the former is used,
the following warning flood pops up:

drivers/power/ab8500_btemp.c: In function 'ab8500_btemp_batctrl_volt_to_res':
ab8500_btemp.c:150:25: warning: comparison between 'enum abx500_adc_therm' and 'enum adc_therm' [-Wenum-compare]
ab8500_btemp.c: In function 'ab8500_btemp_curr_source_enable':
ab8500_btemp.c:212:25: warning: comparison between 'enum abx500_adc_therm' and 'enum adc_therm' [-Wenum-compare]
ab8500_btemp.c:244:32: warning: comparison between 'enum abx500_adc_therm' and 'enum adc_therm' [-Wenum-compare]
ab8500_btemp.c: In function 'ab8500_btemp_measure_temp':
ab8500_btemp.c:462:25: warning: comparison between 'enum abx500_adc_therm' and 'enum adc_therm' [-Wenum-compare]
ab8500_btemp.c: In function 'ab8500_btemp_id':
ab8500_btemp.c:528:121: warning: comparison between 'enum abx500_adc_therm' and 'enum adc_therm' [-Wenum-compare]
ab8500_btemp.c:551:25: warning: comparison between 'enum abx500_adc_therm' and 'enum adc_therm' [-Wenum-compare]

This patch fixes the issue by switching the driver to use more
namespace-friendly enum.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/power/ab8500_btemp.c         |   13 +++++++------
 include/linux/mfd/abx500/ab8500-bm.h |   15 ++-------------
 2 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 443bc7d..d8bb993 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -147,7 +147,7 @@ static int ab8500_btemp_batctrl_volt_to_res(struct ab8500_btemp *di,
 		return (450000 * (v_batctrl)) / (1800 - v_batctrl);
 	}
 
-	if (di->bat->adc_therm == ADC_THERM_BATCTRL) {
+	if (di->bat->adc_therm == ABx500_ADC_THERM_BATCTRL) {
 		/*
 		 * If the battery has internal NTC, we use the current
 		 * source to calculate the resistance, 7uA or 20uA
@@ -209,7 +209,7 @@ static int ab8500_btemp_curr_source_enable(struct ab8500_btemp *di,
 		return 0;
 
 	/* Only do this for batteries with internal NTC */
-	if (di->bat->adc_therm == ADC_THERM_BATCTRL && enable) {
+	if (di->bat->adc_therm == ABx500_ADC_THERM_BATCTRL && enable) {
 		if (di->curr_source == BTEMP_BATCTRL_CURR_SRC_7UA)
 			curr = BAT_CTRL_7U_ENA;
 		else
@@ -241,7 +241,7 @@ static int ab8500_btemp_curr_source_enable(struct ab8500_btemp *di,
 				__func__);
 			goto disable_curr_source;
 		}
-	} else if (di->bat->adc_therm == ADC_THERM_BATCTRL && !enable) {
+	} else if (di->bat->adc_therm == ABx500_ADC_THERM_BATCTRL && !enable) {
 		dev_dbg(di->dev, "Disable BATCTRL curr source\n");
 
 		/* Write 0 to the curr bits */
@@ -459,7 +459,7 @@ static int ab8500_btemp_measure_temp(struct ab8500_btemp *di)
 
 	id = di->bat->batt_id;
 
-	if (di->bat->adc_therm == ADC_THERM_BATCTRL &&
+	if (di->bat->adc_therm == ABx500_ADC_THERM_BATCTRL &&
 			id != BATTERY_UNKNOWN) {
 
 		rbat = ab8500_btemp_get_batctrl_res(di);
@@ -528,7 +528,7 @@ static int ab8500_btemp_id(struct ab8500_btemp *di)
 			dev_dbg(di->dev, "Battery detected on %s"
 				" low %d < res %d < high: %d"
 				" index: %d\n",
-				di->bat->adc_therm == ADC_THERM_BATCTRL ?
+				di->bat->adc_therm == ABx500_ADC_THERM_BATCTRL ?
 				"BATCTRL" : "BATTEMP",
 				di->bat->bat_type[i].resis_low, res,
 				di->bat->bat_type[i].resis_high, i);
@@ -548,7 +548,8 @@ static int ab8500_btemp_id(struct ab8500_btemp *di)
 	 * We only have to change current source if the
 	 * detected type is Type 1, else we use the 7uA source
 	 */
-	if (di->bat->adc_therm == ADC_THERM_BATCTRL && di->bat->batt_id == 1) {
+	if (di->bat->adc_therm == ABx500_ADC_THERM_BATCTRL &&
+			di->bat->batt_id == 1) {
 		dev_dbg(di->dev, "Set BATCTRL current source to 20uA\n");
 		di->curr_source = BTEMP_BATCTRL_CURR_SRC_20UA;
 	}
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index 4b7342c..f61b7b9 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -9,6 +9,7 @@
 #define _AB8500_BM_H
 
 #include <linux/kernel.h>
+#include <linux/mfd/abx500.h>
 
 /*
  * System control 2 register offsets.
@@ -231,18 +232,6 @@
 /* Battery type */
 #define BATTERY_UNKNOWN			00
 
-/*
- * ADC for the battery thermistor.
- * When using the ADC_THERM_BATCTRL the battery ID resistor is combined with
- * a NTC resistor to both identify the battery and to measure its temperature.
- * Different phone manufactures uses different techniques to both identify the
- * battery and to read its temperature.
- */
-enum adc_therm {
-	ADC_THERM_BATCTRL,
-	ADC_THERM_BATTEMP,
-};
-
 /**
  * struct res_to_temp - defines one point in a temp to res curve. To
  * be used in battery packs that combines the identification resistor with a
@@ -464,7 +453,7 @@ struct ab8500_bm_data {
 	bool no_maintenance;
 	bool chg_unknown_bat;
 	bool enable_overshoot;
-	enum adc_therm adc_therm;
+	enum abx500_adc_therm adc_therm;
 	int fg_res;
 	int n_btypes;
 	int batt_id;
-- 
1.7.9

