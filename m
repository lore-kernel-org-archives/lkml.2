Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab3AGAIa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 19:08:30 -0500
Received: from mail-ye0-f171.google.com ([209.85.213.171]:48323 "EHLO
	mail-ye0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab3AGAI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 19:08:26 -0500
X-Greylist: delayed 1035 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jan 2013 19:08:26 EST
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Cc: jonghwa3.lee@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] thermal: sysfs: Add a new sysfs node emul_temp
Date: Sun,  6 Jan 2013 16:08:15 -0800
Message-Id: <1357517296-31402-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to set the emulated temperature method in
thermal zone (sensor). After setting this feature thermal zone must
report this temperature and not the actual temperature. The actual
implementation of this emulated temperature is based on sensor
capability or platform specific. This is useful in debugging different
temperature threshold and its associated cooling action. Writing 0 on
this node should disable emulation.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 Documentation/thermal/sysfs-api.txt |   14 ++++++++++++++
 drivers/thermal/thermal_sys.c       |   26 ++++++++++++++++++++++++++
 include/linux/thermal.h             |    1 +
 3 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index 88c0233..e8f2ee4 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -55,6 +55,8 @@ temperature) and throttle appropriate devices.
 	.get_trip_type: get the type of certain trip point.
 	.get_trip_temp: get the temperature above which the certain trip point
 			will be fired.
+	.set_emul_temp: set the emulation temperature which helps in debugging
+			different threshold temperature points.
 
 1.1.2 void thermal_zone_device_unregister(struct thermal_zone_device *tz)
 
@@ -153,6 +155,7 @@ Thermal zone device sys I/F, created once it's registered:
     |---trip_point_[0-*]_temp:	Trip point temperature
     |---trip_point_[0-*]_type:	Trip point type
     |---trip_point_[0-*]_hyst:	Hysteresis value for this trip point
+    |---emul_temp:		Emulated temperature set node
 
 Thermal cooling device sys I/F, created once it's registered:
 /sys/class/thermal/cooling_device[0-*]:
@@ -252,6 +255,17 @@ passive
 	Valid values: 0 (disabled) or greater than 1000
 	RW, Optional
 
+emul_temp
+	Interface to set the emulated temperature method in thermal zone
+	(sensor). After setting this feature thermal zone must report
+	this temperature and not the actual temperature. The actual
+	implementation of this emulated	temperature is platform specific.
+	This is useful in debugging different temperature threshold and its
+	associated cooling action. Writing 0 on this node should disable
+	emulation.
+	Unit: millidegree Celsius
+	WO, Optional
+
 *****************************
 * Cooling device attributes *
 *****************************
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 8c8ce80..ecdfc7d 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -700,11 +700,31 @@ policy_show(struct device *dev, struct device_attribute *devattr, char *buf)
 	return sprintf(buf, "%s\n", tz->governor->name);
 }
 
+static ssize_t
+emul_temp_store(struct device *dev, struct device_attribute *attr,
+		     const char *buf, size_t count)
+{
+	struct thermal_zone_device *tz = to_thermal_zone(dev);
+	int ret;
+	unsigned long temperature;
+
+	if (!tz->ops->set_emul_temp)
+		return -EPERM;
+
+	if (kstrtoul(buf, 10, &temperature))
+		return -EINVAL;
+
+	ret = tz->ops->set_emul_temp(tz, temperature);
+
+	return ret ? ret : count;
+}
+
 static DEVICE_ATTR(type, 0444, type_show, NULL);
 static DEVICE_ATTR(temp, 0444, temp_show, NULL);
 static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
 static DEVICE_ATTR(passive, S_IRUGO | S_IWUSR, passive_show, passive_store);
 static DEVICE_ATTR(policy, S_IRUGO | S_IWUSR, policy_show, policy_store);
+static DEVICE_ATTR(emul_temp, S_IWUSR, NULL, emul_temp_store);
 
 /* sys I/F for cooling device */
 #define to_cooling_device(_dev)	\
@@ -1592,6 +1612,12 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 			goto unregister;
 	}
 
+	if (ops->set_emul_temp) {
+		result = device_create_file(&tz->device, &dev_attr_emul_temp);
+		if (result)
+			goto unregister;
+	}
+
 	/* Create policy attribute */
 	result = device_create_file(&tz->device, &dev_attr_policy);
 	if (result)
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 883bcda..fbb87d4 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -123,6 +123,7 @@ struct thermal_zone_device_ops {
 	int (*set_trip_hyst) (struct thermal_zone_device *, int,
 			      unsigned long);
 	int (*get_crit_temp) (struct thermal_zone_device *, unsigned long *);
+	int (*set_emul_temp) (struct thermal_zone_device *, unsigned long);
 	int (*get_trend) (struct thermal_zone_device *, int,
 			  enum thermal_trend *);
 	int (*notify) (struct thermal_zone_device *, int,
-- 
1.7.5.4

