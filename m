Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab2JIGJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:09:42 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34159 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab2JIGDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:03:01 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 12/30] Thermal: Unify the code for both active and passive cooling
Date: Tue,  9 Oct 2012 01:54:02 -0400
Message-Id: <908b9fb792b77663a007af240e7ee89460de2025.1349761836.git.len.brown@intel.com>
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

Remove thermal_zone_device_passive(). And use
thermal_zone_trip_update() and thermal_zone_do_update()
for both active and passive cooling.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/thermal_sys.c | 110 ++++++++++--------------------------------
 include/linux/thermal.h       |   2 +-
 2 files changed, 26 insertions(+), 86 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 36ae2f4..6e9d3dc 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -715,84 +715,6 @@ static void thermal_zone_device_set_polling(struct thermal_zone_device *tz,
 				      msecs_to_jiffies(delay));
 }
 
-static void thermal_zone_device_passive(struct thermal_zone_device *tz,
-					int temp, int trip_temp, int trip)
-{
-	enum thermal_trend trend;
-	struct thermal_instance *instance;
-	struct thermal_cooling_device *cdev;
-	long state, max_state;
-
-	if (!tz->ops->get_trend || tz->ops->get_trend(tz, trip, &trend)) {
-		/*
-		 * compare the current temperature and previous temperature
-		 * to get the thermal trend, if no special requirement
-		 */
-		if (tz->temperature > tz->last_temperature)
-			trend = THERMAL_TREND_RAISING;
-		else if (tz->temperature < tz->last_temperature)
-			trend = THERMAL_TREND_DROPPING;
-		else
-			trend = THERMAL_TREND_STABLE;
-	}
-
-	/*
-	 * Above Trip?
-	 * -----------
-	 * Calculate the thermal trend (using the passive cooling equation)
-	 * and modify the performance limit for all passive cooling devices
-	 * accordingly.  Note that we assume symmetry.
-	 */
-	if (temp >= trip_temp) {
-		tz->passive = true;
-
-		/* Heating up? */
-		if (trend == THERMAL_TREND_RAISING) {
-			list_for_each_entry(instance, &tz->thermal_instances,
-					    tz_node) {
-				if (instance->trip != trip)
-					continue;
-				cdev = instance->cdev;
-				cdev->ops->get_cur_state(cdev, &state);
-				cdev->ops->get_max_state(cdev, &max_state);
-				if (state++ < max_state)
-					cdev->ops->set_cur_state(cdev, state);
-			}
-		} else if (trend == THERMAL_TREND_DROPPING) { /* Cooling off? */
-			list_for_each_entry(instance, &tz->thermal_instances,
-					    tz_node) {
-				if (instance->trip != trip)
-					continue;
-				cdev = instance->cdev;
-				cdev->ops->get_cur_state(cdev, &state);
-				cdev->ops->get_max_state(cdev, &max_state);
-				if (state > 0)
-					cdev->ops->set_cur_state(cdev, --state);
-			}
-		}
-		return;
-	}
-
-	/*
-	 * Below Trip?
-	 * -----------
-	 * Implement passive cooling hysteresis to slowly increase performance
-	 * and avoid thrashing around the passive trip point.  Note that we
-	 * assume symmetry.
-	 */
-	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
-		if (instance->trip != trip)
-			continue;
-		cdev = instance->cdev;
-		cdev->ops->get_cur_state(cdev, &state);
-		cdev->ops->get_max_state(cdev, &max_state);
-		if (state > 0)
-			cdev->ops->set_cur_state(cdev, --state);
-		if (state == 0)
-			tz->passive = false;
-	}
-}
-
 static void thermal_zone_device_check(struct work_struct *work)
 {
 	struct thermal_zone_device *tz = container_of(work, struct
@@ -1114,7 +1036,7 @@ static void thermal_zone_do_update(struct thermal_zone_device *tz)
 }
 
 /*
- * Cooling algorithm for active trip points
+ * Cooling algorithm for both active and passive cooling
  *
  * 1. if the temperature is higher than a trip point,
  *    a. if the trend is THERMAL_TREND_RAISING, use higher cooling
@@ -1136,9 +1058,16 @@ static void thermal_zone_trip_update(struct thermal_zone_device *tz,
 	struct thermal_cooling_device *cdev = NULL;
 	unsigned long cur_state, max_state;
 	long trip_temp;
+	enum thermal_trip_type trip_type;
 	enum thermal_trend trend;
 
-	tz->ops->get_trip_temp(tz, trip, &trip_temp);
+	if (trip == THERMAL_TRIPS_NONE) {
+		trip_temp = tz->forced_passive;
+		trip_type = THERMAL_TRIPS_NONE;
+	} else {
+		tz->ops->get_trip_temp(tz, trip, &trip_temp);
+		tz->ops->get_trip_type(tz, trip, &trip_type);
+	}
 
 	if (!tz->ops->get_trend || tz->ops->get_trend(tz, trip, &trend)) {
 		/*
@@ -1170,6 +1099,13 @@ static void thermal_zone_trip_update(struct thermal_zone_device *tz,
 				cur_state = cur_state > instance->lower ?
 				    (cur_state - 1) : instance->lower;
 			}
+
+			/* activate a passive thermal instance */
+			if ((trip_type == THERMAL_TRIP_PASSIVE ||
+			     trip_type == THERMAL_TRIPS_NONE) &&
+			     instance->target == THERMAL_NO_TARGET)
+				tz->passive++;
+
 			instance->target = cur_state;
 			cdev->updated = false; /* cooling device needs update */
 		}
@@ -1186,6 +1122,12 @@ static void thermal_zone_trip_update(struct thermal_zone_device *tz,
 
 			cur_state = cur_state > instance->lower ?
 				    (cur_state - 1) : THERMAL_NO_TARGET;
+
+			/* deactivate a passive thermal instance */
+			if ((trip_type == THERMAL_TRIP_PASSIVE ||
+			     trip_type == THERMAL_TRIPS_NONE) &&
+			     cur_state == THERMAL_NO_TARGET)
+				tz->passive--;
 			instance->target = cur_state;
 			cdev->updated = false; /* cooling device needs update */
 		}
@@ -1242,16 +1184,14 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 			break;
 		case THERMAL_TRIP_PASSIVE:
 			if (temp >= trip_temp || tz->passive)
-				thermal_zone_device_passive(tz, temp,
-							    trip_temp, count);
+				thermal_zone_trip_update(tz, count, temp);
 			break;
 		}
 	}
 
-	thermal_zone_do_update(tz);
 	if (tz->forced_passive)
-		thermal_zone_device_passive(tz, temp, tz->forced_passive,
-					    THERMAL_TRIPS_NONE);
+		thermal_zone_trip_update(tz, THERMAL_TRIPS_NONE, temp);
+	thermal_zone_do_update(tz);
 
 leave:
 	if (tz->passive)
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index de0515a..76d0fe8 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -121,7 +121,7 @@ struct thermal_zone_device {
 	int polling_delay;
 	int temperature;
 	int last_temperature;
-	bool passive;
+	int passive;
 	unsigned int forced_passive;
 	const struct thermal_zone_device_ops *ops;
 	struct list_head thermal_instances;
-- 
1.8.0.rc1

