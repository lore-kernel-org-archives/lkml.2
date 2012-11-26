Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab2KZNro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:47:44 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64113 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab2KZNrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:47:41 -0500
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org, Zhang Rui <rui.zhang@intel.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@linaro.org, jonghwa3.lee@samsung.com
Subject: [PATCH V2 1/3] Thermal: exynos: Add support for temperature falling interrupt.
Date: Mon, 26 Nov 2012 19:17:18 +0530
Message-Id: <1353937640-9939-2-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1353937640-9939-1-git-send-email-amit.kachhap@linaro.org>
References: <1353937640-9939-1-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwa Lee <jonghwa3.lee@samsung.com>

This patch introduces using temperature falling interrupt in exynos
thermal driver. Former patch, it only use polling way to check
whether if system themperature is fallen. However, exynos SOC also
provides temperature falling interrupt way to do same things by hw.
This feature is not supported in exynos4210.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/exynos_thermal.c             |   81 +++++++++++++++-----------
 include/linux/platform_data/exynos_thermal.h |    3 +
 2 files changed, 49 insertions(+), 35 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index e2ef8a3..3b6c387 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -94,6 +94,7 @@
 #define SENSOR_NAME_LEN	16
 #define MAX_TRIP_COUNT	8
 #define MAX_COOLING_DEVICE 4
+#define MAX_THRESHOLD_LEVS 4
 
 #define ACTIVE_INTERVAL 500
 #define IDLE_INTERVAL 10000
@@ -133,6 +134,7 @@ struct exynos_tmu_data {
 struct	thermal_trip_point_conf {
 	int trip_val[MAX_TRIP_COUNT];
 	int trip_count;
+	u8 trigger_falling;
 };
 
 struct	thermal_cooling_conf {
@@ -182,7 +184,8 @@ static int exynos_set_mode(struct thermal_zone_device *thermal,
 
 	mutex_lock(&th_zone->therm_dev->lock);
 
-	if (mode == THERMAL_DEVICE_ENABLED)
+	if (mode == THERMAL_DEVICE_ENABLED &&
+		!th_zone->sensor_conf->trip_data.trigger_falling)
 		th_zone->therm_dev->polling_delay = IDLE_INTERVAL;
 	else
 		th_zone->therm_dev->polling_delay = 0;
@@ -421,7 +424,8 @@ static void exynos_report_trigger(void)
 			break;
 	}
 
-	if (th_zone->mode == THERMAL_DEVICE_ENABLED) {
+	if (th_zone->mode == THERMAL_DEVICE_ENABLED &&
+		!th_zone->sensor_conf->trip_data.trigger_falling) {
 		if (i > 0)
 			th_zone->therm_dev->polling_delay = ACTIVE_INTERVAL;
 		else
@@ -460,7 +464,8 @@ static int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
 
 	th_zone->therm_dev = thermal_zone_device_register(sensor_conf->name,
 			EXYNOS_ZONE_COUNT, 0, NULL, &exynos_dev_ops, NULL, 0,
-			IDLE_INTERVAL);
+			sensor_conf->trip_data.trigger_falling ?
+			0 : IDLE_INTERVAL);
 
 	if (IS_ERR(th_zone->therm_dev)) {
 		pr_err("Failed to register thermal zone device\n");
@@ -567,8 +572,9 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
 	struct exynos_tmu_platform_data *pdata = data->pdata;
-	unsigned int status, trim_info, rising_threshold;
-	int ret = 0, threshold_code;
+	unsigned int status, trim_info;
+	unsigned int rising_threshold = 0, falling_threshold = 0;
+	int ret = 0, threshold_code, i, trigger_levs = 0;
 
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
@@ -593,6 +599,11 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 			(data->temp_error2 != 0))
 		data->temp_error1 = pdata->efuse_value;
 
+	/* Count trigger levels to be enabled */
+	for (i = 0; i < MAX_THRESHOLD_LEVS; i++)
+		if (pdata->trigger_levels[i])
+			trigger_levs++;
+
 	if (data->soc == SOC_ARCH_EXYNOS4210) {
 		/* Write temperature code for threshold */
 		threshold_code = temp_to_code(data, pdata->threshold);
@@ -602,44 +613,38 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		}
 		writeb(threshold_code,
 			data->base + EXYNOS4210_TMU_REG_THRESHOLD_TEMP);
-
-		writeb(pdata->trigger_levels[0],
-			data->base + EXYNOS4210_TMU_REG_TRIG_LEVEL0);
-		writeb(pdata->trigger_levels[1],
-			data->base + EXYNOS4210_TMU_REG_TRIG_LEVEL1);
-		writeb(pdata->trigger_levels[2],
-			data->base + EXYNOS4210_TMU_REG_TRIG_LEVEL2);
-		writeb(pdata->trigger_levels[3],
-			data->base + EXYNOS4210_TMU_REG_TRIG_LEVEL3);
+		for (i = 0; i < trigger_levs; i++)
+			writeb(pdata->trigger_levels[i],
+			data->base + EXYNOS4210_TMU_REG_TRIG_LEVEL0 + i * 4);
 
 		writel(EXYNOS4210_TMU_INTCLEAR_VAL,
 			data->base + EXYNOS_TMU_REG_INTCLEAR);
 	} else if (data->soc == SOC_ARCH_EXYNOS) {
-		/* Write temperature code for threshold */
-		threshold_code = temp_to_code(data, pdata->trigger_levels[0]);
-		if (threshold_code < 0) {
-			ret = threshold_code;
-			goto out;
-		}
-		rising_threshold = threshold_code;
-		threshold_code = temp_to_code(data, pdata->trigger_levels[1]);
-		if (threshold_code < 0) {
-			ret = threshold_code;
-			goto out;
-		}
-		rising_threshold |= (threshold_code << 8);
-		threshold_code = temp_to_code(data, pdata->trigger_levels[2]);
-		if (threshold_code < 0) {
-			ret = threshold_code;
-			goto out;
+		/* Write temperature code for rising and falling threshold */
+		for (i = 0; i < trigger_levs; i++) {
+			threshold_code = temp_to_code(data,
+						pdata->trigger_levels[i]);
+			if (threshold_code < 0) {
+				ret = threshold_code;
+				goto out;
+			}
+			rising_threshold |= threshold_code << 8 * i;
+			if (pdata->threshold_falling) {
+				threshold_code = temp_to_code(data,
+						pdata->trigger_levels[i] -
+						pdata->threshold_falling);
+				if (threshold_code > 0)
+					falling_threshold |=
+						threshold_code << 8 * i;
+			}
 		}
-		rising_threshold |= (threshold_code << 16);
 
 		writel(rising_threshold,
 				data->base + EXYNOS_THD_TEMP_RISE);
-		writel(0, data->base + EXYNOS_THD_TEMP_FALL);
+		writel(falling_threshold,
+				data->base + EXYNOS_THD_TEMP_FALL);
 
-		writel(EXYNOS_TMU_CLEAR_RISE_INT|EXYNOS_TMU_CLEAR_FALL_INT,
+		writel(EXYNOS_TMU_CLEAR_RISE_INT | EXYNOS_TMU_CLEAR_FALL_INT,
 				data->base + EXYNOS_TMU_REG_INTCLEAR);
 	}
 out:
@@ -672,6 +677,8 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 			pdata->trigger_level2_en << 8 |
 			pdata->trigger_level1_en << 4 |
 			pdata->trigger_level0_en;
+		if (pdata->threshold_falling)
+			interrupt_en |= interrupt_en << 16;
 	} else {
 		con |= EXYNOS_TMU_CORE_OFF;
 		interrupt_en = 0; /* Disable all interrupts */
@@ -710,7 +717,8 @@ static void exynos_tmu_work(struct work_struct *work)
 
 
 	if (data->soc == SOC_ARCH_EXYNOS)
-		writel(EXYNOS_TMU_CLEAR_RISE_INT,
+		writel(EXYNOS_TMU_CLEAR_RISE_INT |
+				EXYNOS_TMU_CLEAR_FALL_INT,
 				data->base + EXYNOS_TMU_REG_INTCLEAR);
 	else
 		writel(EXYNOS4210_TMU_INTCLEAR_VAL,
@@ -767,6 +775,7 @@ static struct exynos_tmu_platform_data const exynos4210_default_tmu_data = {
 
 #if defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412)
 static struct exynos_tmu_platform_data const exynos_default_tmu_data = {
+	.threshold_falling = 10,
 	.trigger_levels[0] = 85,
 	.trigger_levels[1] = 103,
 	.trigger_levels[2] = 110,
@@ -1012,6 +1021,8 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 		exynos_sensor_conf.trip_data.trip_val[i] =
 			pdata->threshold + pdata->trigger_levels[i];
 
+	exynos_sensor_conf.trip_data.trigger_falling = pdata->threshold_falling;
+
 	exynos_sensor_conf.cooling_data.freq_clip_count =
 						pdata->freq_tab_count;
 	for (i = 0; i < pdata->freq_tab_count; i++) {
diff --git a/include/linux/platform_data/exynos_thermal.h b/include/linux/platform_data/exynos_thermal.h
index a7bdb2f..da7e627 100644
--- a/include/linux/platform_data/exynos_thermal.h
+++ b/include/linux/platform_data/exynos_thermal.h
@@ -53,6 +53,8 @@ struct freq_clip_table {
  * struct exynos_tmu_platform_data
  * @threshold: basic temperature for generating interrupt
  *	       25 <= threshold <= 125 [unit: degree Celsius]
+ * @threshold_falling: differntial value for setting threshold
+ *		       of temperature falling interrupt.
  * @trigger_levels: array for each interrupt levels
  *	[unit: degree Celsius]
  *	0: temperature for trigger_level0 interrupt
@@ -97,6 +99,7 @@ struct freq_clip_table {
  */
 struct exynos_tmu_platform_data {
 	u8 threshold;
+	u8 threshold_falling;
 	u8 trigger_levels[4];
 	bool trigger_level0_en;
 	bool trigger_level1_en;
-- 
1.7.1

