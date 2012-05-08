Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab2EHQSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:18:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56888 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136Ab2EHQSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:18:40 -0400
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: akpm@linux-foundation.org, linux-pm@lists.linux-foundation.org
Cc: durgadoss.r@intel.com, linux-acpi@vger.kernel.org, lenb@kernel.org,
        rui.zhang@intel.com, amit.kachhap@linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org
Subject: [PATCH v3 1/6] thermal: Add a new trip type to use cooling device instance number
Date: Tue,  8 May 2012 21:48:13 +0530
Message-Id: <1336493898-7039-2-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1336493898-7039-1-git-send-email-amit.kachhap@linaro.org>
References: <1336493898-7039-1-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new trip type THERMAL_TRIP_STATE_INSTANCE. This
trip behaves same as THERMAL_TRIP_ACTIVE but also passes the cooling
device instance number. This helps the cooling device registered as
different instances to perform appropriate cooling action decision in
the set_cur_state call back function.

Also since the trip temperature's are in ascending order so some logic
is put in place to skip the un-necessary checks during thermal zone
update and return error when failing the ascending order trip point check
during thermal zone registration.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 Documentation/thermal/sysfs-api.txt |    4 +-
 drivers/thermal/thermal_sys.c       |   62 +++++++++++++++++++++++++++++++++--
 include/linux/thermal.h             |    1 +
 3 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index 1733ab9..9a7c69c 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -184,8 +184,8 @@ trip_point_[0-*]_temp
 
 trip_point_[0-*]_type
 	Strings which indicate the type of the trip point.
-	E.g. it can be one of critical, hot, passive, active[0-*] for ACPI
-	thermal zone.
+	E.g. it can be one of critical, hot, passive, active[0-1],
+	state-instance[0-*] for ACPI thermal zone.
 	RO, Optional
 
 cdev[0-*]
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 022bacb..4ae93fb 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -190,6 +190,8 @@ trip_point_type_show(struct device *dev, struct device_attribute *attr,
 		return sprintf(buf, "passive\n");
 	case THERMAL_TRIP_ACTIVE:
 		return sprintf(buf, "active\n");
+	case THERMAL_TRIP_STATE_INSTANCE:
+		return sprintf(buf, "state-instance\n");
 	default:
 		return sprintf(buf, "unknown\n");
 	}
@@ -1013,10 +1015,10 @@ EXPORT_SYMBOL(thermal_cooling_device_unregister);
 
 void thermal_zone_device_update(struct thermal_zone_device *tz)
 {
-	int count, ret = 0;
-	long temp, trip_temp;
+	int count, ret = 0, inst_id;
+	long temp, trip_temp, max_state, last_trip_change = 0;
 	enum thermal_trip_type trip_type;
-	struct thermal_cooling_device_instance *instance;
+	struct thermal_cooling_device_instance *instance, *state_instance;
 	struct thermal_cooling_device *cdev;
 
 	mutex_lock(&tz->lock);
@@ -1063,6 +1065,43 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 					cdev->ops->set_cur_state(cdev, 0);
 			}
 			break;
+		case THERMAL_TRIP_STATE_INSTANCE:
+			list_for_each_entry(instance, &tz->cooling_devices,
+					    node) {
+				if (instance->trip != count)
+					continue;
+
+				if (temp <= last_trip_change)
+					continue;
+
+				inst_id = 0;
+				/*
+				*For this instance how many instance of same
+				*cooling device occured before
+				*/
+
+				list_for_each_entry(state_instance,
+						&tz->cooling_devices, node) {
+					if (instance->cdev ==
+							state_instance->cdev)
+						inst_id++;
+					if (state_instance->trip == count)
+						break;
+				}
+
+				cdev = instance->cdev;
+				cdev->ops->get_max_state(cdev, &max_state);
+
+				if ((temp >= trip_temp) &&
+						(inst_id <= max_state))
+					cdev->ops->set_cur_state(cdev, inst_id);
+				else if ((temp < trip_temp) &&
+						(--inst_id <= max_state))
+					cdev->ops->set_cur_state(cdev, inst_id);
+
+				last_trip_change = trip_temp;
+			}
+			break;
 		case THERMAL_TRIP_PASSIVE:
 			if (temp >= trip_temp || tz->passive)
 				thermal_zone_device_passive(tz, temp,
@@ -1117,6 +1156,7 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
 	int result;
 	int count;
 	int passive = 0;
+	long first_trip_temp, trip_temp;
 
 	if (strlen(type) >= THERMAL_NAME_LENGTH)
 		return ERR_PTR(-EINVAL);
@@ -1175,6 +1215,7 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
 			goto unregister;
 	}
 
+	first_trip_temp = 0;
 	for (count = 0; count < trips; count++) {
 		result = device_create_file(&tz->device,
 					    &trip_point_attrs[count * 2]);
@@ -1187,6 +1228,21 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
 		tz->ops->get_trip_type(tz, count, &trip_type);
 		if (trip_type == THERMAL_TRIP_PASSIVE)
 			passive = 1;
+		/*
+		 * For THERMAL_TRIP_STATE_INSTANCE trips, thermal zone should
+		 * be in ascending order.
+		*/
+		if (trip_type == THERMAL_TRIP_STATE_INSTANCE) {
+			tz->ops->get_trip_temp(tz, count, &trip_temp);
+			if (first_trip_temp == 0)
+				first_trip_temp = trip_temp;
+			else if (first_trip_temp < trip_temp)
+				first_trip_temp = trip_temp;
+			else if (first_trip_temp > trip_temp) {
+				pr_warn("Zone trip points should be in ascending order\n");
+				goto unregister;
+			}
+		}
 	}
 
 	if (!passive)
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 796f1ff..583fbda 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -42,6 +42,7 @@ enum thermal_trip_type {
 	THERMAL_TRIP_PASSIVE,
 	THERMAL_TRIP_HOT,
 	THERMAL_TRIP_CRITICAL,
+	THERMAL_TRIP_STATE_INSTANCE,
 };
 
 struct thermal_zone_device_ops {
-- 
1.7.1

