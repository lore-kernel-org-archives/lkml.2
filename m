Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2JIGCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:02:50 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49201 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab2JIGCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:02:38 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 05/30] Thermal: Remove tc1/tc2 in generic thermal layer.
Date: Tue,  9 Oct 2012 01:53:55 -0400
Message-Id: <1b7ddb840c3908464b19d4aa4f6dc4c463302442.1349761836.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc1
In-Reply-To: <1349762060-25334-1-git-send-email-lenb@kernel.org>
References: <1349762060-25334-1-git-send-email-lenb@kernel.org>
In-Reply-To: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
References: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

Remove tc1/tc2 in generic thermal layer.
.get_trend() callback starts to take effect from this patch.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Valentin, Eduardo <eduardo.valentin@ti.com>
---
 drivers/acpi/thermal.c                             |  5 +----
 drivers/platform/x86/acerhdf.c                     |  2 +-
 drivers/platform/x86/intel_mid_thermal.c           |  2 +-
 drivers/power/power_supply_core.c                  |  2 +-
 drivers/staging/omap-thermal/omap-thermal-common.c |  2 +-
 drivers/thermal/spear_thermal.c                    |  2 +-
 drivers/thermal/thermal_sys.c                      | 24 ++++++----------------
 include/linux/thermal.h                            |  5 +----
 8 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index bb95709..07cb217 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -897,15 +897,12 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
 		tz->thermal_zone =
 			thermal_zone_device_register("acpitz", trips, 0, tz,
 						     &acpi_thermal_zone_ops,
-						     tz->trips.passive.tc1,
-						     tz->trips.passive.tc2,
 						     tz->trips.passive.tsp*100,
 						     tz->polling_frequency*100);
 	else
 		tz->thermal_zone =
 			thermal_zone_device_register("acpitz", trips, 0, tz,
-						     &acpi_thermal_zone_ops,
-						     0, 0, 0,
+						     &acpi_thermal_zone_ops, 0,
 						     tz->polling_frequency*100);
 	if (IS_ERR(tz->thermal_zone))
 		return -ENODEV;
diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index a207466..84c5688 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -662,7 +662,7 @@ static int acerhdf_register_thermal(void)
 		return -EINVAL;
 
 	thz_dev = thermal_zone_device_register("acerhdf", 1, 0, NULL,
-					      &acerhdf_dev_ops, 0, 0, 0,
+					      &acerhdf_dev_ops, 0,
 					      (kernelmode) ? interval*1000 : 0);
 	if (IS_ERR(thz_dev))
 		return -EINVAL;
diff --git a/drivers/platform/x86/intel_mid_thermal.c b/drivers/platform/x86/intel_mid_thermal.c
index 3a27113..c809761 100644
--- a/drivers/platform/x86/intel_mid_thermal.c
+++ b/drivers/platform/x86/intel_mid_thermal.c
@@ -502,7 +502,7 @@ static int mid_thermal_probe(struct platform_device *pdev)
 			goto err;
 		}
 		pinfo->tzd[i] = thermal_zone_device_register(name[i],
-				0, 0, td_info, &tzd_ops, 0, 0, 0, 0);
+				0, 0, td_info, &tzd_ops, 0, 0);
 		if (IS_ERR(pinfo->tzd[i])) {
 			kfree(td_info);
 			ret = PTR_ERR(pinfo->tzd[i]);
diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 08cc8a3..2436f13 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -201,7 +201,7 @@ static int psy_register_thermal(struct power_supply *psy)
 	for (i = 0; i < psy->num_properties; i++) {
 		if (psy->properties[i] == POWER_SUPPLY_PROP_TEMP) {
 			psy->tzd = thermal_zone_device_register(psy->name, 0, 0,
-					psy, &psy_tzd_ops, 0, 0, 0, 0);
+					psy, &psy_tzd_ops, 0, 0);
 			if (IS_ERR(psy->tzd))
 				return PTR_ERR(psy->tzd);
 			break;
diff --git a/drivers/staging/omap-thermal/omap-thermal-common.c b/drivers/staging/omap-thermal/omap-thermal-common.c
index 0675a5e..d543d5c 100644
--- a/drivers/staging/omap-thermal/omap-thermal-common.c
+++ b/drivers/staging/omap-thermal/omap-thermal-common.c
@@ -246,7 +246,7 @@ int omap_thermal_expose_sensor(struct omap_bandgap *bg_ptr, int id,
 	/* Create thermal zone */
 	data->omap_thermal = thermal_zone_device_register(domain,
 				OMAP_TRIP_NUMBER, 0, data, &omap_thermal_ops,
-				0, FAST_TEMP_MONITORING_RATE, 0, 0);
+				0, FAST_TEMP_MONITORING_RATE);
 	if (IS_ERR_OR_NULL(data->omap_thermal)) {
 		dev_err(bg_ptr->dev, "thermal zone device is NULL\n");
 		return PTR_ERR(data->omap_thermal);
diff --git a/drivers/thermal/spear_thermal.c b/drivers/thermal/spear_thermal.c
index 5f8ee39..9bc9692 100644
--- a/drivers/thermal/spear_thermal.c
+++ b/drivers/thermal/spear_thermal.c
@@ -147,7 +147,7 @@ static int spear_thermal_probe(struct platform_device *pdev)
 	writel_relaxed(stdev->flags, stdev->thermal_base);
 
 	spear_thermal = thermal_zone_device_register("spear_thermal", 0, 0,
-				stdev, &ops, 0, 0, 0, 0);
+				stdev, &ops, 0, 0);
 	if (IS_ERR(spear_thermal)) {
 		dev_err(&pdev->dev, "thermal zone device is NULL\n");
 		ret = PTR_ERR(spear_thermal);
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 146aa04..0cf3dce 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -335,9 +335,6 @@ passive_store(struct device *dev, struct device_attribute *attr,
 		tz->passive_delay = 0;
 	}
 
-	tz->tc1 = 1;
-	tz->tc2 = 1;
-
 	tz->forced_passive = state;
 
 	thermal_zone_device_update(tz);
@@ -718,13 +715,12 @@ static void thermal_zone_device_set_polling(struct thermal_zone_device *tz,
 static void thermal_zone_device_passive(struct thermal_zone_device *tz,
 					int temp, int trip_temp, int trip)
 {
-	int trend = 0;
+	enum thermal_trend trend;
 	struct thermal_cooling_device_instance *instance;
 	struct thermal_cooling_device *cdev;
 	long state, max_state;
 
-	if (!tz->ops->get_trend ||
-	    tz->ops->get_trend(tz, trip, (enum thermal_trend *)&trend)) {
+	if (!tz->ops->get_trend || tz->ops->get_trend(tz, trip, &trend)) {
 		/*
 		 * compare the current temperature and previous temperature
 		 * to get the thermal trend, if no special requirement
@@ -747,11 +743,8 @@ static void thermal_zone_device_passive(struct thermal_zone_device *tz,
 	if (temp >= trip_temp) {
 		tz->passive = true;
 
-		trend = (tz->tc1 * (temp - tz->last_temperature)) +
-			(tz->tc2 * (temp - trip_temp));
-
 		/* Heating up? */
-		if (trend > 0) {
+		if (trend == THERMAL_TREND_RAISING) {
 			list_for_each_entry(instance, &tz->cooling_devices,
 					    node) {
 				if (instance->trip != trip)
@@ -762,7 +755,7 @@ static void thermal_zone_device_passive(struct thermal_zone_device *tz,
 				if (state++ < max_state)
 					cdev->ops->set_cur_state(cdev, state);
 			}
-		} else if (trend < 0) { /* Cooling off? */
+		} else if (trend == THERMAL_TREND_DROPPING) { /* Cooling off? */
 			list_for_each_entry(instance, &tz->cooling_devices,
 					    node) {
 				if (instance->trip != trip)
@@ -1288,8 +1281,6 @@ static void remove_trip_attrs(struct thermal_zone_device *tz)
  * @mask:	a bit string indicating the writeablility of trip points
  * @devdata:	private device data
  * @ops:	standard thermal zone device callbacks
- * @tc1:	thermal coefficient 1 for passive calculations
- * @tc2:	thermal coefficient 2 for passive calculations
  * @passive_delay: number of milliseconds to wait between polls when
  *		   performing passive cooling
  * @polling_delay: number of milliseconds to wait between polls when checking
@@ -1297,13 +1288,12 @@ static void remove_trip_attrs(struct thermal_zone_device *tz)
  *		   driven systems)
  *
  * thermal_zone_device_unregister() must be called when the device is no
- * longer needed. The passive cooling formula uses tc1 and tc2 as described in
- * section 11.1.5.1 of the ACPI specification 3.0.
+ * longer needed. The passive cooling depends on the .get_trend() return value.
  */
 struct thermal_zone_device *thermal_zone_device_register(const char *type,
 	int trips, int mask, void *devdata,
 	const struct thermal_zone_device_ops *ops,
-	int tc1, int tc2, int passive_delay, int polling_delay)
+	int passive_delay, int polling_delay)
 {
 	struct thermal_zone_device *tz;
 	struct thermal_cooling_device *pos;
@@ -1339,8 +1329,6 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 	tz->device.class = &thermal_class;
 	tz->devdata = devdata;
 	tz->trips = trips;
-	tz->tc1 = tc1;
-	tz->tc2 = tc2;
 	tz->passive_delay = passive_delay;
 	tz->polling_delay = polling_delay;
 
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 6a1d43d..38267a5 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -115,8 +115,6 @@ struct thermal_zone_device {
 	struct thermal_attr *trip_hyst_attrs;
 	void *devdata;
 	int trips;
-	int tc1;
-	int tc2;
 	int passive_delay;
 	int polling_delay;
 	int temperature;
@@ -163,8 +161,7 @@ enum {
 #define THERMAL_GENL_CMD_MAX (__THERMAL_GENL_CMD_MAX - 1)
 
 struct thermal_zone_device *thermal_zone_device_register(const char *, int, int,
-		void *, const struct thermal_zone_device_ops *, int tc1,
-		int tc2, int passive_freq, int polling_freq);
+		void *, const struct thermal_zone_device_ops *, int, int);
 void thermal_zone_device_unregister(struct thermal_zone_device *);
 
 int thermal_zone_bind_cooling_device(struct thermal_zone_device *, int,
-- 
1.8.0.rc1

