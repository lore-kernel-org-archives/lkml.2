Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab1DZPEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 11:04:16 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:13092 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab1DZPEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 11:04:14 -0400
Date: Tue, 26 Apr 2011 17:04:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Len Brown <len.brown@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rene Herman <rene.herman@gmail.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v2 3/3] thermal: Make THERMAL_HWMON implementation fully
 internal
Message-ID: <20110426170407.3694e430@endymion.delvare>
In-Reply-To: <20110426165600.1d9ac91b@endymion.delvare>
References: <20110426165600.1d9ac91b@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

THERMAL_HWMON is implemented inside the thermal_sys driver and has no
effect on drivers implementing thermal zones, so they shouldn't see
anything related to it in <linux/thermal.h>. Making the THERMAL_HWMON
implementation fully internal has two advantages beyond the cleaner
design:
* This avoids rebuilding all thermal drivers if the THERMAL_HWMON
  implementation changes, or if CONFIG_THERMAL_HWMON gets enabled or
  disabled.
* This avoids breaking the thermal kABI in these cases too, which
  should make distributions happy.

The only drawback I can see is slightly higher memory fragmentation,
as the number of kzalloc() calls will increase by one per thermal zone.
But I doubt it will be a problem in practice, as I've never seen a
system with more than two thermal zones.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Rene Herman <rene.herman@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
---
* If memory fragmentation is really a concern to anyone, it would be
  possible to save one kalloc for the first temperature input of each
  zone type, as the price of slightly more complex code.

* Removal code path is untested, as I have never been able to unload
the thermal_sys module on any of my systems. Something is pinning it
and I have no idea what it is.

 drivers/thermal/thermal_sys.c |  116 ++++++++++++++++++++++++++++++++---------
 include/linux/thermal.h       |   22 -------
 2 files changed, 91 insertions(+), 47 deletions(-)

--- linux-2.6.39-rc4.orig/drivers/thermal/thermal_sys.c	2011-04-26 10:30:29.000000000 +0200
+++ linux-2.6.39-rc4/drivers/thermal/thermal_sys.c	2011-04-26 11:05:38.000000000 +0200
@@ -420,6 +420,29 @@ thermal_cooling_device_trip_point_show(s
 
 /* hwmon sys I/F */
 #include <linux/hwmon.h>
+
+/* thermal zone devices with the same type share one hwmon device */
+struct thermal_hwmon_device {
+	char type[THERMAL_NAME_LENGTH];
+	struct device *device;
+	int count;
+	struct list_head tz_list;
+	struct list_head node;
+};
+
+struct thermal_hwmon_attr {
+	struct device_attribute attr;
+	char name[16];
+};
+
+/* one temperature input for each thermal zone */
+struct thermal_hwmon_temp {
+	struct list_head hwmon_node;
+	struct thermal_zone_device *tz;
+	struct thermal_hwmon_attr temp_input;	/* hwmon sys attr */
+	struct thermal_hwmon_attr temp_crit;	/* hwmon sys attr */
+};
+
 static LIST_HEAD(thermal_hwmon_list);
 
 static ssize_t
@@ -437,9 +460,10 @@ temp_input_show(struct device *dev, stru
 	int ret;
 	struct thermal_hwmon_attr *hwmon_attr
 			= container_of(attr, struct thermal_hwmon_attr, attr);
-	struct thermal_zone_device *tz
-			= container_of(hwmon_attr, struct thermal_zone_device,
+	struct thermal_hwmon_temp *temp
+			= container_of(hwmon_attr, struct thermal_hwmon_temp,
 				       temp_input);
+	struct thermal_zone_device *tz = temp->tz;
 
 	ret = tz->ops->get_temp(tz, &temperature);
 
@@ -455,9 +479,10 @@ temp_crit_show(struct device *dev, struc
 {
 	struct thermal_hwmon_attr *hwmon_attr
 			= container_of(attr, struct thermal_hwmon_attr, attr);
-	struct thermal_zone_device *tz
-			= container_of(hwmon_attr, struct thermal_zone_device,
+	struct thermal_hwmon_temp *temp
+			= container_of(hwmon_attr, struct thermal_hwmon_temp,
 				       temp_crit);
+	struct thermal_zone_device *tz = temp->tz;
 	long temperature;
 	int ret;
 
@@ -485,10 +510,29 @@ thermal_hwmon_lookup_by_type(const struc
 	return NULL;
 }
 
+/* Find the temperature input matching a given thermal zone */
+static struct thermal_hwmon_temp *
+thermal_hwmon_lookup_temp(const struct thermal_hwmon_device *hwmon,
+			  const struct thermal_zone_device *tz)
+{
+	struct thermal_hwmon_temp *temp;
+
+	mutex_lock(&thermal_list_lock);
+	list_for_each_entry(temp, &hwmon->tz_list, hwmon_node)
+		if (temp->tz == tz) {
+			mutex_unlock(&thermal_list_lock);
+			return temp;
+		}
+	mutex_unlock(&thermal_list_lock);
+
+	return NULL;
+}
+
 static int
 thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 {
 	struct thermal_hwmon_device *hwmon;
+	struct thermal_hwmon_temp *temp = NULL;
 	int new_hwmon_device = 1;
 	int result;
 
@@ -515,30 +559,36 @@ thermal_add_hwmon_sysfs(struct thermal_z
 		goto unregister_hwmon_device;
 
  register_sys_interface:
-	tz->hwmon = hwmon;
+	temp = kzalloc(sizeof(struct thermal_hwmon_temp), GFP_KERNEL);
+	if (!temp) {
+		result = -ENOMEM;
+		goto unregister_hwmon_device;
+	}
+
+	temp->tz = tz;
 	hwmon->count++;
 
-	snprintf(tz->temp_input.name, THERMAL_NAME_LENGTH,
+	snprintf(temp->temp_input.name, THERMAL_NAME_LENGTH,
 		 "temp%d_input", hwmon->count);
-	tz->temp_input.attr.attr.name = tz->temp_input.name;
-	tz->temp_input.attr.attr.mode = 0444;
-	tz->temp_input.attr.show = temp_input_show;
-	sysfs_attr_init(&tz->temp_input.attr.attr);
-	result = device_create_file(hwmon->device, &tz->temp_input.attr);
+	temp->temp_input.attr.attr.name = temp->temp_input.name;
+	temp->temp_input.attr.attr.mode = 0444;
+	temp->temp_input.attr.show = temp_input_show;
+	sysfs_attr_init(&temp->temp_input.attr.attr);
+	result = device_create_file(hwmon->device, &temp->temp_input.attr);
 	if (result)
 		goto unregister_hwmon_device;
 
 	if (tz->ops->get_crit_temp) {
 		unsigned long temperature;
 		if (!tz->ops->get_crit_temp(tz, &temperature)) {
-			snprintf(tz->temp_crit.name, THERMAL_NAME_LENGTH,
+			snprintf(temp->temp_crit.name, THERMAL_NAME_LENGTH,
 				"temp%d_crit", hwmon->count);
-			tz->temp_crit.attr.attr.name = tz->temp_crit.name;
-			tz->temp_crit.attr.attr.mode = 0444;
-			tz->temp_crit.attr.show = temp_crit_show;
-			sysfs_attr_init(&tz->temp_crit.attr.attr);
+			temp->temp_crit.attr.attr.name = temp->temp_crit.name;
+			temp->temp_crit.attr.attr.mode = 0444;
+			temp->temp_crit.attr.show = temp_crit_show;
+			sysfs_attr_init(&temp->temp_crit.attr.attr);
 			result = device_create_file(hwmon->device,
-						    &tz->temp_crit.attr);
+						    &temp->temp_crit.attr);
 			if (result)
 				goto unregister_hwmon_device;
 		}
@@ -547,14 +597,15 @@ thermal_add_hwmon_sysfs(struct thermal_z
 	mutex_lock(&thermal_list_lock);
 	if (new_hwmon_device)
 		list_add_tail(&hwmon->node, &thermal_hwmon_list);
-	list_add_tail(&tz->hwmon_node, &hwmon->tz_list);
+	list_add_tail(&temp->hwmon_node, &hwmon->tz_list);
 	mutex_unlock(&thermal_list_lock);
 
 	return 0;
 
  unregister_hwmon_device:
-	device_remove_file(hwmon->device, &tz->temp_crit.attr);
-	device_remove_file(hwmon->device, &tz->temp_input.attr);
+	device_remove_file(hwmon->device, &temp->temp_crit.attr);
+	device_remove_file(hwmon->device, &temp->temp_input.attr);
+	kfree(temp);
 	if (new_hwmon_device) {
 		device_remove_file(hwmon->device, &dev_attr_name);
 		hwmon_device_unregister(hwmon->device);
@@ -569,15 +620,30 @@ thermal_add_hwmon_sysfs(struct thermal_z
 static void
 thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
 {
-	struct thermal_hwmon_device *hwmon = tz->hwmon;
+	struct thermal_hwmon_device *hwmon;
+	struct thermal_hwmon_temp *temp;
 
-	tz->hwmon = NULL;
-	device_remove_file(hwmon->device, &tz->temp_input.attr);
+	hwmon = thermal_hwmon_lookup_by_type(tz);
+	if (unlikely(!hwmon)) {
+		/* Should never happen... */
+		dev_dbg(&tz->device, "hwmon device lookup failed!\n");
+		return;
+	}
+
+	temp = thermal_hwmon_lookup_temp(hwmon, tz);
+	if (unlikely(!temp)) {
+		/* Should never happen... */
+		dev_dbg(&tz->device, "temperature input lookup failed!\n");
+		return;
+	}
+
+	device_remove_file(hwmon->device, &temp->temp_input.attr);
 	if (tz->ops->get_crit_temp)
-		device_remove_file(hwmon->device, &tz->temp_crit.attr);
+		device_remove_file(hwmon->device, &temp->temp_crit.attr);
 
 	mutex_lock(&thermal_list_lock);
-	list_del(&tz->hwmon_node);
+	list_del(&temp->hwmon_node);
+	kfree(temp);
 	if (!list_empty(&hwmon->tz_list)) {
 		mutex_unlock(&thermal_list_lock);
 		return;
--- linux-2.6.39-rc4.orig/include/linux/thermal.h	2011-04-25 16:16:10.000000000 +0200
+++ linux-2.6.39-rc4/include/linux/thermal.h	2011-04-26 10:40:46.000000000 +0200
@@ -85,22 +85,6 @@ struct thermal_cooling_device {
 				((long)t-2732+5)/10 : ((long)t-2732-5)/10)
 #define CELSIUS_TO_KELVIN(t)	((t)*10+2732)
 
-#if defined(CONFIG_THERMAL_HWMON)
-/* thermal zone devices with the same type share one hwmon device */
-struct thermal_hwmon_device {
-	char type[THERMAL_NAME_LENGTH];
-	struct device *device;
-	int count;
-	struct list_head tz_list;
-	struct list_head node;
-};
-
-struct thermal_hwmon_attr {
-	struct device_attribute attr;
-	char name[16];
-};
-#endif
-
 struct thermal_zone_device {
 	int id;
 	char type[THERMAL_NAME_LENGTH];
@@ -120,12 +104,6 @@ struct thermal_zone_device {
 	struct mutex lock;	/* protect cooling devices list */
 	struct list_head node;
 	struct delayed_work poll_queue;
-#if defined(CONFIG_THERMAL_HWMON)
-	struct list_head hwmon_node;
-	struct thermal_hwmon_device *hwmon;
-	struct thermal_hwmon_attr temp_input;	/* hwmon sys attr */
-	struct thermal_hwmon_attr temp_crit;	/* hwmon sys attr */
-#endif
 };
 /* Adding event notification support elements */
 #define THERMAL_GENL_FAMILY_NAME                "thermal_event"

-- 
Jean Delvare
