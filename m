Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab2JIGDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:03:14 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49201 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab2JIGDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:03:02 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 13/30] Thermal: Introduce locking for cdev.thermal_instances list.
Date: Tue,  9 Oct 2012 01:54:03 -0400
Message-Id: <f4a821ce6ed41970d0155f55067fb07009974fbe.1349761836.git.len.brown@intel.com>
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

we need to go over all the thermal_instance list of a cooling device
to decide which cooling state to put the cooling device to.

But at this time, as a cooling device may be referenced in multiple
thermal zones, we need to lock the list first in case
another thermal zone is updating this cooling device.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/thermal_sys.c | 8 ++++++++
 include/linux/thermal.h       | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 6e9d3dc..5be8728 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -799,6 +799,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 		goto remove_symbol_link;
 
 	mutex_lock(&tz->lock);
+	mutex_lock(&cdev->lock);
 	list_for_each_entry(pos, &tz->thermal_instances, tz_node)
 	    if (pos->tz == tz && pos->trip == trip && pos->cdev == cdev) {
 		result = -EEXIST;
@@ -808,6 +809,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 		list_add_tail(&dev->tz_node, &tz->thermal_instances);
 		list_add_tail(&dev->cdev_node, &cdev->thermal_instances);
 	}
+	mutex_unlock(&cdev->lock);
 	mutex_unlock(&tz->lock);
 
 	if (!result)
@@ -840,14 +842,17 @@ int thermal_zone_unbind_cooling_device(struct thermal_zone_device *tz,
 	struct thermal_instance *pos, *next;
 
 	mutex_lock(&tz->lock);
+	mutex_lock(&cdev->lock);
 	list_for_each_entry_safe(pos, next, &tz->thermal_instances, tz_node) {
 		if (pos->tz == tz && pos->trip == trip && pos->cdev == cdev) {
 			list_del(&pos->tz_node);
 			list_del(&pos->cdev_node);
+			mutex_unlock(&cdev->lock);
 			mutex_unlock(&tz->lock);
 			goto unbind;
 		}
 	}
+	mutex_unlock(&cdev->lock);
 	mutex_unlock(&tz->lock);
 
 	return -ENODEV;
@@ -913,6 +918,7 @@ thermal_cooling_device_register(char *type, void *devdata,
 	}
 
 	strcpy(cdev->type, type);
+	mutex_init(&cdev->lock);
 	INIT_LIST_HEAD(&cdev->thermal_instances);
 	cdev->ops = ops;
 	cdev->updated = true;
@@ -1016,6 +1022,7 @@ static void thermal_cdev_do_update(struct thermal_cooling_device *cdev)
 	if (cdev->updated)
 		return;
 
+	mutex_lock(&cdev->lock);
 	/* Make sure cdev enters the deepest cooling state */
 	list_for_each_entry(instance, &cdev->thermal_instances, cdev_node) {
 		if (instance->target == THERMAL_NO_TARGET)
@@ -1023,6 +1030,7 @@ static void thermal_cdev_do_update(struct thermal_cooling_device *cdev)
 		if (instance->target > target)
 			target = instance->target;
 	}
+	mutex_unlock(&cdev->lock);
 	cdev->ops->set_cur_state(cdev, target);
 	cdev->updated = true;
 }
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 76d0fe8..91b3481 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -95,6 +95,7 @@ struct thermal_cooling_device {
 	void *devdata;
 	const struct thermal_cooling_device_ops *ops;
 	bool updated; /* true if the cooling device does not need update */
+	struct mutex lock; /* protect thermal_instances list */
 	struct list_head thermal_instances;
 	struct list_head node;
 };
-- 
1.8.0.rc1

