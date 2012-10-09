Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab2JIGC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:02:56 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38957 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab2JIGCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:02:50 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 09/30] Thermal: Rename thermal_instance.node to thermal_instance.tz_node.
Date: Tue,  9 Oct 2012 01:53:59 -0400
Message-Id: <cddf31b3b293fd20358ea506f22445611425811f.1349761836.git.len.brown@intel.com>
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

thermal_instance should be referenced by both thermal zone devices
and thermal cooling devices.

Rename thermal_instance.node to thermal_instance.tz_node in this patch
and thermal_instanace.cdev_node will be introduced in next patch.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/thermal_sys.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 797d148..2884376 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -56,7 +56,7 @@ struct thermal_instance {
 	unsigned long lower;	/* Lowest cooling state for this trip point */
 	char attr_name[THERMAL_NAME_LENGTH];
 	struct device_attribute attr;
-	struct list_head node;
+	struct list_head tz_node; /* node in tz->thermal_instances */
 };
 
 static DEFINE_IDR(thermal_tz_idr);
@@ -746,7 +746,7 @@ static void thermal_zone_device_passive(struct thermal_zone_device *tz,
 		/* Heating up? */
 		if (trend == THERMAL_TREND_RAISING) {
 			list_for_each_entry(instance, &tz->thermal_instances,
-					    node) {
+					    tz_node) {
 				if (instance->trip != trip)
 					continue;
 				cdev = instance->cdev;
@@ -757,7 +757,7 @@ static void thermal_zone_device_passive(struct thermal_zone_device *tz,
 			}
 		} else if (trend == THERMAL_TREND_DROPPING) { /* Cooling off? */
 			list_for_each_entry(instance, &tz->thermal_instances,
-					    node) {
+					    tz_node) {
 				if (instance->trip != trip)
 					continue;
 				cdev = instance->cdev;
@@ -777,7 +777,7 @@ static void thermal_zone_device_passive(struct thermal_zone_device *tz,
 	 * and avoid thrashing around the passive trip point.  Note that we
 	 * assume symmetry.
 	 */
-	list_for_each_entry(instance, &tz->thermal_instances, node) {
+	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
 		if (instance->trip != trip)
 			continue;
 		cdev = instance->cdev;
@@ -873,13 +873,13 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 		goto remove_symbol_link;
 
 	mutex_lock(&tz->lock);
-	list_for_each_entry(pos, &tz->thermal_instances, node)
+	list_for_each_entry(pos, &tz->thermal_instances, tz_node)
 	    if (pos->tz == tz && pos->trip == trip && pos->cdev == cdev) {
 		result = -EEXIST;
 		break;
 	}
 	if (!result)
-		list_add_tail(&dev->node, &tz->thermal_instances);
+		list_add_tail(&dev->tz_node, &tz->thermal_instances);
 	mutex_unlock(&tz->lock);
 
 	if (!result)
@@ -912,9 +912,9 @@ int thermal_zone_unbind_cooling_device(struct thermal_zone_device *tz,
 	struct thermal_instance *pos, *next;
 
 	mutex_lock(&tz->lock);
-	list_for_each_entry_safe(pos, next, &tz->thermal_instances, node) {
+	list_for_each_entry_safe(pos, next, &tz->thermal_instances, tz_node) {
 		if (pos->tz == tz && pos->trip == trip && pos->cdev == cdev) {
-			list_del(&pos->node);
+			list_del(&pos->tz_node);
 			mutex_unlock(&tz->lock);
 			goto unbind;
 		}
@@ -1117,7 +1117,7 @@ static void thermal_zone_trip_update(struct thermal_zone_device *tz,
 	}
 
 	if (temp >= trip_temp) {
-		list_for_each_entry(instance, &tz->thermal_instances, node) {
+		list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
 			if (instance->trip != trip)
 				continue;
 
@@ -1136,7 +1136,7 @@ static void thermal_zone_trip_update(struct thermal_zone_device *tz,
 			cdev->ops->set_cur_state(cdev, cur_state);
 		}
 	} else {	/* below trip */
-		list_for_each_entry(instance, &tz->thermal_instances, node) {
+		list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
 			if (instance->trip != trip)
 				continue;
 
-- 
1.8.0.rc1

