Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab2JIGKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:10:15 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50042 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2JIGCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:02:48 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 08/30] Thermal: Rename thermal_zone_device.cooling_devices
Date: Tue,  9 Oct 2012 01:53:58 -0400
Message-Id: <2d374139d5b0b596cfbd892bf3ec7dacb3049904.1349761836.git.len.brown@intel.com>
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

Rename thermal_zone_device.cooling_devices
to thermal_zone_device.thermal_instances

thermal_zone_device.cooling_devices is not accurate
as this is a list for thermal instances, rather than cooling devices.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/thermal_sys.c | 18 +++++++++---------
 include/linux/thermal.h       |  4 ++--
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 3eba397..797d148 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -745,7 +745,7 @@ static void thermal_zone_device_passive(struct thermal_zone_device *tz,
 
 		/* Heating up? */
 		if (trend == THERMAL_TREND_RAISING) {
-			list_for_each_entry(instance, &tz->cooling_devices,
+			list_for_each_entry(instance, &tz->thermal_instances,
 					    node) {
 				if (instance->trip != trip)
 					continue;
@@ -756,7 +756,7 @@ static void thermal_zone_device_passive(struct thermal_zone_device *tz,
 					cdev->ops->set_cur_state(cdev, state);
 			}
 		} else if (trend == THERMAL_TREND_DROPPING) { /* Cooling off? */
-			list_for_each_entry(instance, &tz->cooling_devices,
+			list_for_each_entry(instance, &tz->thermal_instances,
 					    node) {
 				if (instance->trip != trip)
 					continue;
@@ -777,7 +777,7 @@ static void thermal_zone_device_passive(struct thermal_zone_device *tz,
 	 * and avoid thrashing around the passive trip point.  Note that we
 	 * assume symmetry.
 	 */
-	list_for_each_entry(instance, &tz->cooling_devices, node) {
+	list_for_each_entry(instance, &tz->thermal_instances, node) {
 		if (instance->trip != trip)
 			continue;
 		cdev = instance->cdev;
@@ -873,13 +873,13 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 		goto remove_symbol_link;
 
 	mutex_lock(&tz->lock);
-	list_for_each_entry(pos, &tz->cooling_devices, node)
+	list_for_each_entry(pos, &tz->thermal_instances, node)
 	    if (pos->tz == tz && pos->trip == trip && pos->cdev == cdev) {
 		result = -EEXIST;
 		break;
 	}
 	if (!result)
-		list_add_tail(&dev->node, &tz->cooling_devices);
+		list_add_tail(&dev->node, &tz->thermal_instances);
 	mutex_unlock(&tz->lock);
 
 	if (!result)
@@ -912,7 +912,7 @@ int thermal_zone_unbind_cooling_device(struct thermal_zone_device *tz,
 	struct thermal_instance *pos, *next;
 
 	mutex_lock(&tz->lock);
-	list_for_each_entry_safe(pos, next, &tz->cooling_devices, node) {
+	list_for_each_entry_safe(pos, next, &tz->thermal_instances, node) {
 		if (pos->tz == tz && pos->trip == trip && pos->cdev == cdev) {
 			list_del(&pos->node);
 			mutex_unlock(&tz->lock);
@@ -1117,7 +1117,7 @@ static void thermal_zone_trip_update(struct thermal_zone_device *tz,
 	}
 
 	if (temp >= trip_temp) {
-		list_for_each_entry(instance, &tz->cooling_devices, node) {
+		list_for_each_entry(instance, &tz->thermal_instances, node) {
 			if (instance->trip != trip)
 				continue;
 
@@ -1136,7 +1136,7 @@ static void thermal_zone_trip_update(struct thermal_zone_device *tz,
 			cdev->ops->set_cur_state(cdev, cur_state);
 		}
 	} else {	/* below trip */
-		list_for_each_entry(instance, &tz->cooling_devices, node) {
+		list_for_each_entry(instance, &tz->thermal_instances, node) {
 			if (instance->trip != trip)
 				continue;
 
@@ -1365,7 +1365,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 	if (!tz)
 		return ERR_PTR(-ENOMEM);
 
-	INIT_LIST_HEAD(&tz->cooling_devices);
+	INIT_LIST_HEAD(&tz->thermal_instances);
 	idr_init(&tz->idr);
 	mutex_init(&tz->lock);
 	result = get_idr(&thermal_tz_idr, &thermal_idr_lock, &tz->id);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 38267a5..cb0b0e3 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -122,9 +122,9 @@ struct thermal_zone_device {
 	bool passive;
 	unsigned int forced_passive;
 	const struct thermal_zone_device_ops *ops;
-	struct list_head cooling_devices;
+	struct list_head thermal_instances;
 	struct idr idr;
-	struct mutex lock;	/* protect cooling devices list */
+	struct mutex lock; /* protect thermal_instances list */
 	struct list_head node;
 	struct delayed_work poll_queue;
 };
-- 
1.8.0.rc1

