Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab2JIGCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:02:34 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50042 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab2JIGC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:02:26 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 02/30] Thermal: Introduce cooling states range support
Date: Tue,  9 Oct 2012 01:53:52 -0400
Message-Id: <74051ba50583a5880d4536c1d9333e2493ddfd76.1349761836.git.len.brown@intel.com>
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

As the active cooling devices can have multiple cooling states,
we may want only several cooling states for a certain trip point,
and other cooling states for other active trip points.

To do this, we should be able to describe the cooling device
behavior for a certain trip point, rather than for the entire thermal zone.
And when updating thermal zone, we need to check the upper and lower limit
to make sure the cooling device is set to the proper cooling state.

Note that this patch will not bring any different behavior as
upper limit is set to max_state and lower limit is set to 0
in this patch, for now.

Next patch will set these to real values.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/thermal_sys.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index dc4044b..d78c6dc 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -41,12 +41,19 @@ MODULE_AUTHOR("Zhang Rui");
 MODULE_DESCRIPTION("Generic thermal management sysfs support");
 MODULE_LICENSE("GPL");
 
+/*
+ * This structure is used to describe the behavior of
+ * a certain cooling device on a certain trip point
+ * in a certain thermal zone
+ */
 struct thermal_cooling_device_instance {
 	int id;
 	char name[THERMAL_NAME_LENGTH];
 	struct thermal_zone_device *tz;
 	struct thermal_cooling_device *cdev;
 	int trip;
+	unsigned long upper;	/* Highest cooling state for this trip point */
+	unsigned long lower;	/* Lowest cooling state for this trip point */
 	char attr_name[THERMAL_NAME_LENGTH];
 	struct device_attribute attr;
 	struct list_head node;
@@ -800,6 +807,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	struct thermal_cooling_device_instance *pos;
 	struct thermal_zone_device *pos1;
 	struct thermal_cooling_device *pos2;
+	unsigned long max_state;
 	int result;
 
 	if (trip >= tz->trips || (trip < 0 && trip != THERMAL_TRIPS_NONE))
@@ -824,6 +832,11 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	dev->tz = tz;
 	dev->cdev = cdev;
 	dev->trip = trip;
+
+	cdev->ops->get_max_state(cdev, &max_state);
+	dev->upper = max_state;
+	dev->lower = 0;
+
 	result = get_idr(&tz->idr, &tz->lock, &dev->id);
 	if (result)
 		goto free_mem;
@@ -1103,11 +1116,15 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 				cdev->ops->get_max_state(cdev, &max_state);
 
 				if (temp >= trip_temp)
-					cur_state = cur_state < max_state ?
-						(cur_state + 1) : max_state;
+					cur_state =
+						cur_state < instance->upper ?
+						(cur_state + 1) :
+						instance->upper;
 				else
-					cur_state = cur_state > 0 ?
-						(cur_state - 1) : 0;
+					cur_state =
+						cur_state > instance->lower ?
+						(cur_state - 1) :
+						instance->lower;
 
 				cdev->ops->set_cur_state(cdev, cur_state);
 			}
-- 
1.8.0.rc1

