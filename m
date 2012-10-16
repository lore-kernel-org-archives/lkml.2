Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab2JPLqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 07:46:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40059 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab2JPLqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 07:46:23 -0400
From: "hongbo.zhang" <hongbo.zhang@linaro.org>
To: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>
Subject: [PATCH 1/5] Thermal: do bind operation after thermal zone or cooling device register returns.
Date: Tue, 16 Oct 2012 19:44:45 +0800
Message-Id: <1350387889-15324-2-git-send-email-hongbo.zhang@linaro.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "hongbo.zhang" <hongbo.zhang@linaro.com>

In the previous bind function, cdev->get_max_state(cdev, &max_state) is called
before the registration function finishes, but at this moment, the parameter
cdev at thermal driver layer isn't ready--it will get ready only after its
registration, so the the get_max_state callback cannot tell the max_state
according to the cdev input.
This problem can be fixed by separating the bind operation out of registration
and doing it when registration completely finished.

Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
---
 drivers/thermal/thermal_sys.c | 86 +++++++++++++++++++++++++++++--------------
 1 file changed, 58 insertions(+), 28 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 9ee42ca..dd3d024 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -70,6 +70,8 @@ static LIST_HEAD(thermal_tz_list);
 static LIST_HEAD(thermal_cdev_list);
 static DEFINE_MUTEX(thermal_list_lock);
 
+static struct work_struct thermal_bind;
+
 static int get_idr(struct idr *idr, struct mutex *lock, int *id)
 {
 	int err;
@@ -777,7 +779,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	dev->lower = lower;
 	dev->target = THERMAL_NO_TARGET;
 
-	result = get_idr(&tz->idr, &tz->lock, &dev->id);
+	result = get_idr(&tz->idr, NULL, &dev->id);
 	if (result)
 		goto free_mem;
 
@@ -796,7 +798,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	if (result)
 		goto remove_symbol_link;
 
-	mutex_lock(&tz->lock);
+	/* tz->lock should have been locked outside this function */
 	mutex_lock(&cdev->lock);
 	list_for_each_entry(pos, &tz->thermal_instances, tz_node)
 	    if (pos->tz == tz && pos->trip == trip && pos->cdev == cdev) {
@@ -808,7 +810,6 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 		list_add_tail(&dev->cdev_node, &cdev->thermal_instances);
 	}
 	mutex_unlock(&cdev->lock);
-	mutex_unlock(&tz->lock);
 
 	if (!result)
 		return 0;
@@ -895,7 +896,6 @@ thermal_cooling_device_register(char *type, void *devdata,
 				const struct thermal_cooling_device_ops *ops)
 {
 	struct thermal_cooling_device *cdev;
-	struct thermal_zone_device *pos;
 	int result;
 
 	if (type && strlen(type) >= THERMAL_NAME_LENGTH)
@@ -947,16 +947,10 @@ thermal_cooling_device_register(char *type, void *devdata,
 
 	mutex_lock(&thermal_list_lock);
 	list_add(&cdev->node, &thermal_cdev_list);
-	list_for_each_entry(pos, &thermal_tz_list, node) {
-		if (!pos->ops->bind)
-			continue;
-		result = pos->ops->bind(pos, cdev);
-		if (result)
-			break;
-
-	}
 	mutex_unlock(&thermal_list_lock);
 
+	schedule_work(&thermal_bind);
+
 	if (!result)
 		return cdev;
 
@@ -1141,19 +1135,13 @@ static void thermal_zone_trip_update(struct thermal_zone_device *tz,
 
 	return;
 }
-/**
- * thermal_zone_device_update - force an update of a thermal zone's state
- * @ttz:	the thermal zone to update
- */
 
-void thermal_zone_device_update(struct thermal_zone_device *tz)
+void __thermal_zone_device_update(struct thermal_zone_device *tz)
 {
 	int count, ret = 0;
 	long temp, trip_temp;
 	enum thermal_trip_type trip_type;
 
-	mutex_lock(&tz->lock);
-
 	if (tz->ops->get_temp(tz, &temp)) {
 		/* get_temp failed - retry it later */
 		pr_warn("failed to read out thermal zone %d\n", tz->id);
@@ -1206,10 +1194,56 @@ leave:
 		thermal_zone_device_set_polling(tz, tz->polling_delay);
 	else
 		thermal_zone_device_set_polling(tz, 0);
+}
+
+/**
+ * thermal_zone_device_update - force an update of a thermal zone's state
+ * @tz:	the thermal zone to update
+ */
+void thermal_zone_device_update(struct thermal_zone_device *tz)
+{
+	mutex_lock(&tz->lock);
+
+	__thermal_zone_device_update(tz);
+
 	mutex_unlock(&tz->lock);
 }
 EXPORT_SYMBOL(thermal_zone_device_update);
 
+static void thermal_zone_do_bind_work(struct work_struct *work)
+{
+	struct thermal_instance *instance;
+	struct thermal_zone_device *tz;
+	struct thermal_cooling_device *cdev;
+
+	mutex_lock(&thermal_list_lock);
+
+	list_for_each_entry(tz, &thermal_tz_list, node)
+		list_for_each_entry(cdev, &thermal_cdev_list, node) {
+
+			mutex_lock(&tz->lock);
+
+			if (list_empty(&tz->thermal_instances)
+				&& tz->ops->bind) {
+				tz->ops->bind(tz, cdev);
+				__thermal_zone_device_update(tz);
+				mutex_unlock(&tz->lock);
+				break;
+			}
+
+			list_for_each_entry(instance, &tz->thermal_instances,
+				tz_node)
+				if (instance->cdev != cdev && tz->ops->bind) {
+					tz->ops->bind(tz, cdev);
+					__thermal_zone_device_update(tz);
+				}
+
+			mutex_unlock(&tz->lock);
+		}
+
+	mutex_unlock(&thermal_list_lock);
+}
+
 /**
  * create_trip_attrs - create attributes for trip points
  * @tz:		the thermal zone device
@@ -1335,7 +1369,6 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 	int passive_delay, int polling_delay)
 {
 	struct thermal_zone_device *tz;
-	struct thermal_cooling_device *pos;
 	enum thermal_trip_type trip_type;
 	int result;
 	int count;
@@ -1419,17 +1452,12 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 
 	mutex_lock(&thermal_list_lock);
 	list_add_tail(&tz->node, &thermal_tz_list);
-	if (ops->bind)
-		list_for_each_entry(pos, &thermal_cdev_list, node) {
-		result = ops->bind(tz, pos);
-		if (result)
-			break;
-		}
 	mutex_unlock(&thermal_list_lock);
 
-	INIT_DELAYED_WORK(&(tz->poll_queue), thermal_zone_device_check);
+	if (ops->bind)
+		schedule_work(&thermal_bind);
 
-	thermal_zone_device_update(tz);
+	INIT_DELAYED_WORK(&(tz->poll_queue), thermal_zone_device_check);
 
 	if (!result)
 		return tz;
@@ -1588,6 +1616,7 @@ static int __init thermal_init(void)
 {
 	int result = 0;
 
+	INIT_WORK(&thermal_bind, thermal_zone_do_bind_work);
 	result = class_register(&thermal_class);
 	if (result) {
 		idr_destroy(&thermal_tz_idr);
@@ -1601,6 +1630,7 @@ static int __init thermal_init(void)
 
 static void __exit thermal_exit(void)
 {
+	cancel_work_sync(&thermal_bind);
 	class_unregister(&thermal_class);
 	idr_destroy(&thermal_tz_idr);
 	idr_destroy(&thermal_cdev_idr);
-- 
1.7.11.3

