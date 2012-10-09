Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab2JIGCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:02:43 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38957 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab2JIGCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:02:36 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 04/30] Thermal: Introduce .get_trend() callback.
Date: Tue,  9 Oct 2012 01:53:54 -0400
Message-Id: <601f3d4242be6ed6f72a2aadabc91e8255dad811.1349761836.git.len.brown@intel.com>
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

According to ACPI spec, tc1 and tc2 are used by OSPM
to anticipate the temperature trends.
We introduced the same concept to the generic thermal layer
for passive cooling, but now it seems that these values
are hard to be used on other platforms.

So We introduce .get_trend() as a more general solution.

For the platform thermal drivers that have their own way to
anticipate the temperature trends, they should provide
their own .get_trend() callback.
Or else, we will calculate the temperature trends by simply
comparing the current temperature and the cached previous
temperature reading.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Valentin, Eduardo <eduardo.valentin@ti.com>
---
 drivers/acpi/thermal.c        | 33 +++++++++++++++++++++++++++++++++
 drivers/thermal/thermal_sys.c | 19 +++++++++++++++++--
 include/linux/thermal.h       |  9 +++++++++
 3 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index d7ef69d..bb95709 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -706,6 +706,38 @@ static int thermal_get_crit_temp(struct thermal_zone_device *thermal,
 		return -EINVAL;
 }
 
+static int thermal_get_trend(struct thermal_zone_device *thermal,
+				int trip, enum thermal_trend *trend)
+{
+	struct acpi_thermal *tz = thermal->devdata;
+	enum thermal_trip_type type;
+	int i;
+
+	if (thermal_get_trip_type(thermal, trip, &type))
+		return -EINVAL;
+
+	/* Only PASSIVE trip points need TREND */
+	if (type != THERMAL_TRIP_PASSIVE)
+		return -EINVAL;
+
+	/*
+	 * tz->temperature has already been updated by generic thermal layer,
+	 * before this callback being invoked
+	 */
+	i = (tz->trips.passive.tc1 * (tz->temperature - tz->last_temperature))
+		+ (tz->trips.passive.tc2
+		* (tz->temperature - tz->trips.passive.temperature));
+
+	if (i > 0)
+		*trend = THERMAL_TREND_RAISING;
+	else if (i < 0)
+		*trend = THERMAL_TREND_DROPPING;
+	else
+		*trend = THERMAL_TREND_STABLE;
+	return 0;
+}
+
+
 static int thermal_notify(struct thermal_zone_device *thermal, int trip,
 			   enum thermal_trip_type trip_type)
 {
@@ -838,6 +870,7 @@ static const struct thermal_zone_device_ops acpi_thermal_zone_ops = {
 	.get_trip_type = thermal_get_trip_type,
 	.get_trip_temp = thermal_get_trip_temp,
 	.get_crit_temp = thermal_get_crit_temp,
+	.get_trend = thermal_get_trend,
 	.notify = thermal_notify,
 };
 
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index b04fe2c..146aa04 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -723,6 +723,20 @@ static void thermal_zone_device_passive(struct thermal_zone_device *tz,
 	struct thermal_cooling_device *cdev;
 	long state, max_state;
 
+	if (!tz->ops->get_trend ||
+	    tz->ops->get_trend(tz, trip, (enum thermal_trend *)&trend)) {
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
 	/*
 	 * Above Trip?
 	 * -----------
@@ -1091,6 +1105,9 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 		goto leave;
 	}
 
+	tz->last_temperature = tz->temperature;
+	tz->temperature = temp;
+
 	for (count = 0; count < tz->trips; count++) {
 		tz->ops->get_trip_type(tz, count, &trip_type);
 		tz->ops->get_trip_temp(tz, count, &trip_temp);
@@ -1150,8 +1167,6 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 		thermal_zone_device_passive(tz, temp, tz->forced_passive,
 					    THERMAL_TRIPS_NONE);
 
-	tz->last_temperature = temp;
-
 leave:
 	if (tz->passive)
 		thermal_zone_device_set_polling(tz, tz->passive_delay);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 5946a3b..6a1d43d 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -44,6 +44,12 @@ enum thermal_trip_type {
 	THERMAL_TRIP_CRITICAL,
 };
 
+enum thermal_trend {
+	THERMAL_TREND_STABLE, /* temperature is stable */
+	THERMAL_TREND_RAISING, /* temperature is raising */
+	THERMAL_TREND_DROPPING, /* temperature is dropping */
+};
+
 struct thermal_zone_device_ops {
 	int (*bind) (struct thermal_zone_device *,
 		     struct thermal_cooling_device *);
@@ -65,6 +71,8 @@ struct thermal_zone_device_ops {
 	int (*set_trip_hyst) (struct thermal_zone_device *, int,
 			      unsigned long);
 	int (*get_crit_temp) (struct thermal_zone_device *, unsigned long *);
+	int (*get_trend) (struct thermal_zone_device *, int,
+			  enum thermal_trend *);
 	int (*notify) (struct thermal_zone_device *, int,
 		       enum thermal_trip_type);
 };
@@ -111,6 +119,7 @@ struct thermal_zone_device {
 	int tc2;
 	int passive_delay;
 	int polling_delay;
+	int temperature;
 	int last_temperature;
 	bool passive;
 	unsigned int forced_passive;
-- 
1.8.0.rc1

