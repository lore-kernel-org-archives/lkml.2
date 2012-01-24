Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2AXXgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:36:24 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39081 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753762Ab2AXXgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:36:22 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] thermal_sys: Remove obfuscating used-once macros
Date: Tue, 24 Jan 2012 15:35:36 -0800
Message-Id: <af64842337355cb336a98563bba79007709a6d00.1327447797.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1327447797.git.joe@perches.com>
References: <cover.1327447797.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These don't add any value as they are used
only once and the surrounding code uses similar
variable.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/thermal/thermal_sys.c |   32 ++++++++++++--------------------
 1 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 7326baa..1c87167 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -312,22 +312,6 @@ static struct device_attribute trip_point_attrs[] = {
 	__ATTR(trip_point_11_temp, 0444, trip_point_temp_show, NULL),
 };
 
-#define TRIP_POINT_ATTR_ADD(_dev, _index, result)     \
-do {    \
-	result = device_create_file(_dev,	\
-				&trip_point_attrs[_index * 2]);	\
-	if (result)	\
-		break;	\
-	result = device_create_file(_dev,	\
-			&trip_point_attrs[_index * 2 + 1]);	\
-} while (0)
-
-#define TRIP_POINT_ATTR_REMOVE(_dev, _index)	\
-do {	\
-	device_remove_file(_dev, &trip_point_attrs[_index * 2]);	\
-	device_remove_file(_dev, &trip_point_attrs[_index * 2 + 1]);	\
-} while (0)
-
 /* sys I/F for cooling device */
 #define to_cooling_device(_dev)	\
 	container_of(_dev, struct thermal_cooling_device, device)
@@ -1198,7 +1182,12 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
 	}
 
 	for (count = 0; count < trips; count++) {
-		TRIP_POINT_ATTR_ADD(&tz->device, count, result);
+		result = device_create_file(&tz->device,
+					    &trip_point_attrs[count * 2]);
+		if (result)
+			break;
+		result = device_create_file(&tz->device,
+					    &trip_point_attrs[count * 2 + 1]);
 		if (result)
 			goto unregister;
 		tz->ops->get_trip_type(tz, count, &trip_type);
@@ -1278,9 +1267,12 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
 	if (tz->ops->get_mode)
 		device_remove_file(&tz->device, &dev_attr_mode);
 
-	for (count = 0; count < tz->trips; count++)
-		TRIP_POINT_ATTR_REMOVE(&tz->device, count);
-
+	for (count = 0; count < tz->trips; count++) {
+		device_remove_file(&tz->device,
+				   &trip_point_attrs[count * 2]);
+		device_remove_file(&tz->device,
+				   &trip_point_attrs[count * 2 + 1]);
+	}
 	thermal_remove_hwmon_sysfs(tz);
 	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
 	idr_destroy(&tz->idr);
-- 
1.7.8.111.gad25c.dirty

