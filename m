Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab2JIGLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:11:42 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38957 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab2JIGCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:02:34 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 03/30] Thermal: set upper and lower limits
Date: Tue,  9 Oct 2012 01:53:53 -0400
Message-Id: <9d99842f99d847191ebd0c28469d2c70fcc5bf9e.1349761836.git.len.brown@intel.com>
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

set upper and lower limits when binding
a thermal cooling device to a thermal zone device.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 Documentation/thermal/sysfs-api.txt |  9 ++++++-
 drivers/acpi/thermal.c              | 53 ++++++++++++++++++++++++-------------
 drivers/platform/x86/acerhdf.c      |  3 ++-
 drivers/thermal/thermal_sys.c       | 23 +++++++++++-----
 include/linux/thermal.h             |  5 +++-
 5 files changed, 65 insertions(+), 28 deletions(-)

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index c087dbc..ca1a1a3 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -84,7 +84,8 @@ temperature) and throttle appropriate devices.
 
 1.3 interface for binding a thermal zone device with a thermal cooling device
 1.3.1 int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
-		int trip, struct thermal_cooling_device *cdev);
+	int trip, struct thermal_cooling_device *cdev,
+	unsigned long upper, unsigned long lower);
 
     This interface function bind a thermal cooling device to the certain trip
     point of a thermal zone device.
@@ -93,6 +94,12 @@ temperature) and throttle appropriate devices.
     cdev: thermal cooling device
     trip: indicates which trip point the cooling devices is associated with
 	  in this thermal zone.
+    upper:the Maximum cooling state for this trip point.
+          THERMAL_NO_LIMIT means no upper limit,
+	  and the cooling device can be in max_state.
+    lower:the Minimum cooling state can be used for this trip point.
+          THERMAL_NO_LIMIT means no lower limit,
+	  and the cooling device can be in cooling state 0.
 
 1.3.2 int thermal_zone_unbind_cooling_device(struct thermal_zone_device *tz,
 		int trip, struct thermal_cooling_device *cdev);
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 9fe90e9..d7ef69d 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -729,11 +729,9 @@ static int thermal_notify(struct thermal_zone_device *thermal, int trip,
 	return 0;
 }
 
-typedef int (*cb)(struct thermal_zone_device *, int,
-		  struct thermal_cooling_device *);
 static int acpi_thermal_cooling_device_cb(struct thermal_zone_device *thermal,
 					struct thermal_cooling_device *cdev,
-					cb action)
+					bool bind)
 {
 	struct acpi_device *device = cdev->devdata;
 	struct acpi_thermal *tz = thermal->devdata;
@@ -757,11 +755,19 @@ static int acpi_thermal_cooling_device_cb(struct thermal_zone_device *thermal,
 		    i++) {
 			handle = tz->trips.passive.devices.handles[i];
 			status = acpi_bus_get_device(handle, &dev);
-			if (ACPI_SUCCESS(status) && (dev == device)) {
-				result = action(thermal, trip, cdev);
-				if (result)
-					goto failed;
-			}
+			if (ACPI_FAILURE(status) || dev != device)
+				continue;
+			if (bind)
+				result =
+					thermal_zone_bind_cooling_device
+					(thermal, trip, cdev,
+					 THERMAL_NO_LIMIT, THERMAL_NO_LIMIT);
+			else
+				result =
+					thermal_zone_unbind_cooling_device
+					(thermal, trip, cdev);
+			if (result)
+				goto failed;
 		}
 	}
 
@@ -774,11 +780,17 @@ static int acpi_thermal_cooling_device_cb(struct thermal_zone_device *thermal,
 		    j++) {
 			handle = tz->trips.active[i].devices.handles[j];
 			status = acpi_bus_get_device(handle, &dev);
-			if (ACPI_SUCCESS(status) && (dev == device)) {
-				result = action(thermal, trip, cdev);
-				if (result)
-					goto failed;
-			}
+			if (ACPI_FAILURE(status) || dev != device)
+				continue;
+			if (bind)
+				result = thermal_zone_bind_cooling_device
+					(thermal, trip, cdev,
+					 THERMAL_NO_LIMIT, THERMAL_NO_LIMIT);
+			else
+				result = thermal_zone_unbind_cooling_device
+					(thermal, trip, cdev);
+			if (result)
+				goto failed;
 		}
 	}
 
@@ -786,7 +798,14 @@ static int acpi_thermal_cooling_device_cb(struct thermal_zone_device *thermal,
 		handle = tz->devices.handles[i];
 		status = acpi_bus_get_device(handle, &dev);
 		if (ACPI_SUCCESS(status) && (dev == device)) {
-			result = action(thermal, -1, cdev);
+			if (bind)
+				result = thermal_zone_bind_cooling_device
+						(thermal, -1, cdev,
+						 THERMAL_NO_LIMIT,
+						 THERMAL_NO_LIMIT);
+			else
+				result = thermal_zone_unbind_cooling_device
+						(thermal, -1, cdev);
 			if (result)
 				goto failed;
 		}
@@ -800,16 +819,14 @@ static int
 acpi_thermal_bind_cooling_device(struct thermal_zone_device *thermal,
 					struct thermal_cooling_device *cdev)
 {
-	return acpi_thermal_cooling_device_cb(thermal, cdev,
-				thermal_zone_bind_cooling_device);
+	return acpi_thermal_cooling_device_cb(thermal, cdev, true);
 }
 
 static int
 acpi_thermal_unbind_cooling_device(struct thermal_zone_device *thermal,
 					struct thermal_cooling_device *cdev)
 {
-	return acpi_thermal_cooling_device_cb(thermal, cdev,
-				thermal_zone_unbind_cooling_device);
+	return acpi_thermal_cooling_device_cb(thermal, cdev, false);
 }
 
 static const struct thermal_zone_device_ops acpi_thermal_zone_ops = {
diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 39abb15..a207466 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -329,7 +329,8 @@ static int acerhdf_bind(struct thermal_zone_device *thermal,
 	if (cdev != cl_dev)
 		return 0;
 
-	if (thermal_zone_bind_cooling_device(thermal, 0, cdev)) {
+	if (thermal_zone_bind_cooling_device(thermal, 0, cdev,
+			THERMAL_NO_LIMIT, THERMAL_NO_LIMIT)) {
 		pr_err("error binding cooling dev\n");
 		return -EINVAL;
 	}
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index d78c6dc..b04fe2c 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -315,8 +315,9 @@ passive_store(struct device *dev, struct device_attribute *attr,
 			if (!strncmp("Processor", cdev->type,
 				     sizeof("Processor")))
 				thermal_zone_bind_cooling_device(tz,
-								 THERMAL_TRIPS_NONE,
-								 cdev);
+						THERMAL_TRIPS_NONE, cdev,
+						THERMAL_NO_LIMIT,
+						THERMAL_NO_LIMIT);
 		}
 		mutex_unlock(&thermal_list_lock);
 		if (!tz->passive_delay)
@@ -801,7 +802,8 @@ static void thermal_zone_device_check(struct work_struct *work)
  */
 int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 				     int trip,
-				     struct thermal_cooling_device *cdev)
+				     struct thermal_cooling_device *cdev,
+				     unsigned long upper, unsigned long lower)
 {
 	struct thermal_cooling_device_instance *dev;
 	struct thermal_cooling_device_instance *pos;
@@ -825,6 +827,15 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	if (tz != pos1 || cdev != pos2)
 		return -EINVAL;
 
+	cdev->ops->get_max_state(cdev, &max_state);
+
+	/* lower default 0, upper default max_state */
+	lower = lower == THERMAL_NO_LIMIT ? 0 : lower;
+	upper = upper == THERMAL_NO_LIMIT ? max_state : upper;
+
+	if (lower > upper || upper > max_state)
+		return -EINVAL;
+
 	dev =
 	    kzalloc(sizeof(struct thermal_cooling_device_instance), GFP_KERNEL);
 	if (!dev)
@@ -832,10 +843,8 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	dev->tz = tz;
 	dev->cdev = cdev;
 	dev->trip = trip;
-
-	cdev->ops->get_max_state(cdev, &max_state);
-	dev->upper = max_state;
-	dev->lower = 0;
+	dev->upper = upper;
+	dev->lower = lower;
 
 	result = get_idr(&tz->idr, &tz->lock, &dev->id);
 	if (result)
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 4b94a61..5946a3b 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -75,6 +75,8 @@ struct thermal_cooling_device_ops {
 	int (*set_cur_state) (struct thermal_cooling_device *, unsigned long);
 };
 
+#define THERMAL_NO_LIMIT -1UL /* no upper/lower limit requirement */
+
 #define THERMAL_TRIPS_NONE -1
 #define THERMAL_MAX_TRIPS 12
 #define THERMAL_NAME_LENGTH 20
@@ -157,7 +159,8 @@ struct thermal_zone_device *thermal_zone_device_register(const char *, int, int,
 void thermal_zone_device_unregister(struct thermal_zone_device *);
 
 int thermal_zone_bind_cooling_device(struct thermal_zone_device *, int,
-				     struct thermal_cooling_device *);
+				     struct thermal_cooling_device *,
+				     unsigned long, unsigned long);
 int thermal_zone_unbind_cooling_device(struct thermal_zone_device *, int,
 				       struct thermal_cooling_device *);
 void thermal_zone_device_update(struct thermal_zone_device *);
-- 
1.8.0.rc1

