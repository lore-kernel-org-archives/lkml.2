Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab2JIGDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:03:04 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38957 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab2JIGC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:02:58 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 10/30] Thermal: List thermal_instance in thermal_cooling_device.
Date: Tue,  9 Oct 2012 01:54:00 -0400
Message-Id: <b5e4ae620b06274981781aeadc2aea50b507f7fb.1349761836.git.len.brown@intel.com>
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

List thermal_instance in thermal_cooling_device so that
cooling device can know the cooling state requirement
of all the thermal instances.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/thermal_sys.c | 7 ++++++-
 include/linux/thermal.h       | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 2884376..70045c1 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -57,6 +57,7 @@ struct thermal_instance {
 	char attr_name[THERMAL_NAME_LENGTH];
 	struct device_attribute attr;
 	struct list_head tz_node; /* node in tz->thermal_instances */
+	struct list_head cdev_node; /* node in cdev->thermal_instances */
 };
 
 static DEFINE_IDR(thermal_tz_idr);
@@ -878,8 +879,10 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 		result = -EEXIST;
 		break;
 	}
-	if (!result)
+	if (!result) {
 		list_add_tail(&dev->tz_node, &tz->thermal_instances);
+		list_add_tail(&dev->cdev_node, &cdev->thermal_instances);
+	}
 	mutex_unlock(&tz->lock);
 
 	if (!result)
@@ -915,6 +918,7 @@ int thermal_zone_unbind_cooling_device(struct thermal_zone_device *tz,
 	list_for_each_entry_safe(pos, next, &tz->thermal_instances, tz_node) {
 		if (pos->tz == tz && pos->trip == trip && pos->cdev == cdev) {
 			list_del(&pos->tz_node);
+			list_del(&pos->cdev_node);
 			mutex_unlock(&tz->lock);
 			goto unbind;
 		}
@@ -984,6 +988,7 @@ thermal_cooling_device_register(char *type, void *devdata,
 	}
 
 	strcpy(cdev->type, type);
+	INIT_LIST_HEAD(&cdev->thermal_instances);
 	cdev->ops = ops;
 	cdev->device.class = &thermal_class;
 	cdev->devdata = devdata;
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index cb0b0e3..9ae378a 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -94,6 +94,7 @@ struct thermal_cooling_device {
 	struct device device;
 	void *devdata;
 	const struct thermal_cooling_device_ops *ops;
+	struct list_head thermal_instances;
 	struct list_head node;
 };
 
-- 
1.8.0.rc1

