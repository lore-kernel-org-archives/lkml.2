Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904Ab2C3NSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:18:50 -0400
Received: from vms173021pub.verizon.net ([206.46.173.21]:33467 "EHLO
	vms173021pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760860Ab2C3NSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:18:24 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Jesper Juhl <jj@chaosbits.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 15/76] thermal_sys: remove obfuscating used-once macros
Date: Fri, 30 Mar 2012 06:13:18 -0400
Message-id: <ec797685609da142588012d734e85d14cff9c7d2.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

These don't add any value as they are used only once and the surrounding
code uses similar variable.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/thermal/thermal_sys.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 71802ca..11237bc 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -310,22 +310,6 @@ static struct device_attribute trip_point_attrs[] = {
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
@@ -1196,7 +1180,12 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
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
@@ -1276,9 +1265,12 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
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
1.7.10.rc2.19.gfae9d

