Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab2KAHsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 03:48:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59358 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab2KAHsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 03:48:02 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-e8-509229308225
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Durgadoss R <durgadoss.r@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH] Thermal: exynos: Add support for temperature falling interrupt.
Date: Thu, 01 Nov 2012 16:47:55 +0900
Message-id: <1351756075-1467-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAJMWRmVeSWpSXmKPExsVy+t9jQV0DzUkBBr2T1Swu75rDZvG59wij
	A5PH501yAYxRXDYpqTmZZalF+nYJXBlb2+6zFPy0rVg35TRzA+Nvoy5GTg4JAROJppnzGCFs
	MYkL99azdTFycQgJTGeU+DtxMyuE08IksWbafbAqNgEdif/7brKD2CICMhJTr+wHK2IW2Msk
	MfvlZmaQhLBAgMTpg5PAbBYBVYlzWxvAGngF3CUmrL7HCrFOQWLBvbdsExi5FzAyrGIUTS1I
	LihOSs811CtOzC0uzUvXS87P3cQI9uczqR2MKxssDjEKcDAq8fAalk4MEGJNLCuuzD3EKMHB
	rCTC+7gbKMSbklhZlVqUH19UmpNafIhRmoNFSZy32SMlQEggPbEkNTs1tSC1CCbLxMEp1cDY
	Jnk6U3Rf6Lue3yFeJdLcyfdYggTK+HJ5qpe//PBqh/TcfZ3BZb6rxdjfHDsUvCdi2Q2eZzea
	Z/hxTGr1nRi+zOXUtx7lFdkTF/7c6D4nYu6C2fwr5576c2q+786lVWfyz204cjOV0WWDX0hS
	u/EyPakokTVT4lmObF7L59625onq5ny26UvfK7EUZyQaajEXFScCADhI0HDjAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces using temperature falling interrupt in exynos
thermal driver. Former patch, it only use polling way to check
whether if system themperature is fallen. However, exynos SOC also
provides temperature falling interrupt way to do same things by hw.
This feature is not supported in exynos4210.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/thermal/exynos_thermal.c             |   81 +++++++++++++++-----------
 include/linux/platform_data/exynos_thermal.h |    3 +
 2 files changed, 49 insertions(+), 35 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index 4bdd1eb..f91a699 100644
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
 			EXYNOS_ZONE_COUNT, 0, NULL, &exynos_dev_ops, 0,
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
+			rising_threshold |= threshold_code;
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
@@ -1002,6 +1011,8 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
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
1.7.4.1

