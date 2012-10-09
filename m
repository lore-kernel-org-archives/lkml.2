Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab2JIGCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:02:47 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50042 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2JIGCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:02:38 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 06/30] Thermal: Introduce thermal_zone_trip_update()
Date: Tue,  9 Oct 2012 01:53:56 -0400
Message-Id: <4ae46befb49d4173122e0afa995c4e93d01948a2.1349761836.git.len.brown@intel.com>
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

This function is used to update the cooling state of
all the cooling devices that are bound to an active trip point.

This will be used for passive cooling as well, in the future patches.
as both active and passive cooling can share the same algorithm,
which is

1. if the temperature is higher than a trip point,
   a. if the trend is THERMAL_TREND_RAISING, use higher cooling
      state for this trip point
   b. if the trend is THERMAL_TREND_DROPPING, use lower cooling
      state for this trip point

2. if the temperature is lower than a trip point, use lower
   cooling state for this trip point.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/acpi/thermal.c        |   8 ++--
 drivers/thermal/thermal_sys.c | 102 +++++++++++++++++++++++++++++++-----------
 2 files changed, 81 insertions(+), 29 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 07cb217..bd66bd2 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -716,9 +716,11 @@ static int thermal_get_trend(struct thermal_zone_device *thermal,
 	if (thermal_get_trip_type(thermal, trip, &type))
 		return -EINVAL;
 
-	/* Only PASSIVE trip points need TREND */
-	if (type != THERMAL_TRIP_PASSIVE)
-		return -EINVAL;
+	if (type == THERMAL_TRIP_ACTIVE) {
+		/* aggressive active cooling */
+		*trend = THERMAL_TREND_RAISING;
+		return 0;
+	}
 
 	/*
 	 * tz->temperature has already been updated by generic thermal layer,
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 0cf3dce..735e6e6 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -1076,6 +1076,81 @@ void thermal_cooling_device_unregister(struct
 }
 EXPORT_SYMBOL(thermal_cooling_device_unregister);
 
+/*
+ * Cooling algorithm for active trip points
+ *
+ * 1. if the temperature is higher than a trip point,
+ *    a. if the trend is THERMAL_TREND_RAISING, use higher cooling
+ *       state for this trip point
+ *    b. if the trend is THERMAL_TREND_DROPPING, use lower cooling
+ *       state for this trip point
+ *
+ * 2. if the temperature is lower than a trip point, use lower
+ *    cooling state for this trip point
+ *
+ * Note that this behaves the same as the previous passive cooling
+ * algorithm.
+ */
+
+static void thermal_zone_trip_update(struct thermal_zone_device *tz,
+				     int trip, long temp)
+{
+	struct thermal_cooling_device_instance *instance;
+	struct thermal_cooling_device *cdev = NULL;
+	unsigned long cur_state, max_state;
+	long trip_temp;
+	enum thermal_trend trend;
+
+	tz->ops->get_trip_temp(tz, trip, &trip_temp);
+
+	if (!tz->ops->get_trend || tz->ops->get_trend(tz, trip, &trend)) {
+		/*
+		 * compare the current temperature and previous temperature
+		 * to get the thermal trend, if no special requirement
+		 */
+		if (tz->temperature > tz->last_temperature)
+			trend = THERMAL_TREND_RAISING;
+		else if (tz->temperature < tz->last_temperature)
+			trend = THERMAL_TREND_DROPPING;
+		else
+			trend = THERMAL_TREND_STABLE;
+	}
+
+	if (temp >= trip_temp) {
+		list_for_each_entry(instance, &tz->cooling_devices, node) {
+			if (instance->trip != trip)
+				continue;
+
+			cdev = instance->cdev;
+
+			cdev->ops->get_cur_state(cdev, &cur_state);
+			cdev->ops->get_max_state(cdev, &max_state);
+
+			if (trend == THERMAL_TREND_RAISING) {
+				cur_state = cur_state < instance->upper ?
+					    (cur_state + 1) : instance->upper;
+			} else if (trend == THERMAL_TREND_DROPPING) {
+				cur_state = cur_state > instance->lower ?
+				    (cur_state - 1) : instance->lower;
+			}
+			cdev->ops->set_cur_state(cdev, cur_state);
+		}
+	} else {	/* below trip */
+		list_for_each_entry(instance, &tz->cooling_devices, node) {
+			if (instance->trip != trip)
+				continue;
+
+			cdev = instance->cdev;
+			cdev->ops->get_cur_state(cdev, &cur_state);
+
+			cur_state = cur_state > instance->lower ?
+				    (cur_state - 1) : instance->lower;
+			cdev->ops->set_cur_state(cdev, cur_state);
+		}
+	}
+
+	return;
+}
 /**
  * thermal_zone_device_update - force an update of a thermal zone's state
  * @ttz:	the thermal zone to update
@@ -1086,9 +1161,6 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 	int count, ret = 0;
 	long temp, trip_temp;
 	enum thermal_trip_type trip_type;
-	struct thermal_cooling_device_instance *instance;
-	struct thermal_cooling_device *cdev;
-	unsigned long cur_state, max_state;
 
 	mutex_lock(&tz->lock);
 
@@ -1124,29 +1196,7 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 					tz->ops->notify(tz, count, trip_type);
 			break;
 		case THERMAL_TRIP_ACTIVE:
-			list_for_each_entry(instance, &tz->cooling_devices,
-					    node) {
-				if (instance->trip != count)
-					continue;
-
-				cdev = instance->cdev;
-
-				cdev->ops->get_cur_state(cdev, &cur_state);
-				cdev->ops->get_max_state(cdev, &max_state);
-
-				if (temp >= trip_temp)
-					cur_state =
-						cur_state < instance->upper ?
-						(cur_state + 1) :
-						instance->upper;
-				else
-					cur_state =
-						cur_state > instance->lower ?
-						(cur_state - 1) :
-						instance->lower;
-
-				cdev->ops->set_cur_state(cdev, cur_state);
-			}
+			thermal_zone_trip_update(tz, count, temp);
 			break;
 		case THERMAL_TRIP_PASSIVE:
 			if (temp >= trip_temp || tz->passive)
-- 
1.8.0.rc1

