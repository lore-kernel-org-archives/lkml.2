Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1LAO3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:29:39 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51595 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab1LAO3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:29:38 -0500
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, amit.kachhap@linaro.org,
        patches@linaro.org
Subject: [PATCH] thermal: Add a new trip type to use cooling device instance number
Date: Thu,  1 Dec 2011 19:59:23 +0530
Message-Id: <1322749763-11140-1-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new trip type THERMAL_TRIP_STATE_ACTIVE. This
trip behaves same as THERMAL_TRIP_ACTIVE but also passes the cooling
device instance number. This helps the cooling device registered as
different instances to perform appropriate cooling action decision in
the set_cur_state call back function.

Also since the trip temperature's are in ascending order so some logic
is put in place to skip the un-necessary checks.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 Documentation/thermal/sysfs-api.txt |    4 ++--
 drivers/thermal/thermal_sys.c       |   27 ++++++++++++++++++++++++++-
 include/linux/thermal.h             |    1 +
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index b61e46f..5c1d44e 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -184,8 +184,8 @@ trip_point_[0-*]_temp
 
 trip_point_[0-*]_type
 	Strings which indicate the type of the trip point.
-	E.g. it can be one of critical, hot, passive, active[0-*] for ACPI
-	thermal zone.
+	E.g. it can be one of critical, hot, passive, active[0-1],
+	state-active[0-*] for ACPI thermal zone.
 	RO, Optional
 
 cdev[0-*]
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index dd9a574..72b1ab3 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -192,6 +192,8 @@ trip_point_type_show(struct device *dev, struct device_attribute *attr,
 		return sprintf(buf, "passive\n");
 	case THERMAL_TRIP_ACTIVE:
 		return sprintf(buf, "active\n");
+	case THERMAL_TRIP_STATE_ACTIVE:
+		return sprintf(buf, "state-active\n");
 	default:
 		return sprintf(buf, "unknown\n");
 	}
@@ -1035,7 +1037,7 @@ EXPORT_SYMBOL(thermal_cooling_device_unregister);
 void thermal_zone_device_update(struct thermal_zone_device *tz)
 {
 	int count, ret = 0;
-	long temp, trip_temp;
+	long temp, trip_temp, max_state, last_trip_change = 0;
 	enum thermal_trip_type trip_type;
 	struct thermal_cooling_device_instance *instance;
 	struct thermal_cooling_device *cdev;
@@ -1086,6 +1088,29 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 					cdev->ops->set_cur_state(cdev, 0);
 			}
 			break;
+		case THERMAL_TRIP_STATE_ACTIVE:
+			list_for_each_entry(instance, &tz->cooling_devices,
+					    node) {
+				if (instance->trip != count)
+					continue;
+
+				if (temp <= last_trip_change)
+					continue;
+
+				cdev = instance->cdev;
+				cdev->ops->get_max_state(cdev, &max_state);
+
+				if ((temp >= trip_temp) &&
+						((count + 1) <= max_state))
+					cdev->ops->set_cur_state(cdev,
+								count + 1);
+				else if ((temp < trip_temp) &&
+							(count <= max_state))
+					cdev->ops->set_cur_state(cdev, count);
+
+				last_trip_change = trip_temp;
+			}
+			break;
 		case THERMAL_TRIP_PASSIVE:
 			if (temp >= trip_temp || tz->passive)
 				thermal_zone_device_passive(tz, temp,
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 47b4a27..d7d0a27 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -42,6 +42,7 @@ enum thermal_trip_type {
 	THERMAL_TRIP_PASSIVE,
 	THERMAL_TRIP_HOT,
 	THERMAL_TRIP_CRITICAL,
+	THERMAL_TRIP_STATE_ACTIVE,
 };
 
 struct thermal_zone_device_ops {
-- 
1.7.1

