Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1DWNHU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 09:07:20 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:34769 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab1DWNHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 09:07:17 -0400
Date: Sat, 23 Apr 2011 15:07:03 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Len Brown <len.brown@intel.com>
Cc: Rene Herman <rene.herman@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: [PATCH] thermal: Drop CONFIG_THERMAL_HWMON
Message-ID: <20110423150703.78ba86db@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's about time to revert 16d752397301b95abaa95cbaf9e785d221872311.
Anybody running a kernel >= 2.6.40 would also be running a recent
enough version of lm-sensors.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Rene Herman <rene.herman@gmail.com>
Cc: Len Brown <len.brown@intel.com>
---
Len, will you pick this in one of your trees? There doesn't seem to be
a maintainer for the thermal subsystem.

 Documentation/feature-removal-schedule.txt |    9 ---------
 drivers/thermal/Kconfig                    |   10 ----------
 drivers/thermal/thermal_sys.c              |    4 ++--
 include/linux/thermal.h                    |    6 ++++--
 4 files changed, 6 insertions(+), 23 deletions(-)

--- linux-2.6.39-rc4.orig/Documentation/feature-removal-schedule.txt	2011-04-23 10:38:10.000000000 +0200
+++ linux-2.6.39-rc4/Documentation/feature-removal-schedule.txt	2011-04-23 14:47:59.000000000 +0200
@@ -295,15 +295,6 @@ Who:	Ravikiran Thirumalai <kiran@scalex8
 
 ---------------------------
 
-What:	CONFIG_THERMAL_HWMON
-When:	January 2009
-Why:	This option was introduced just to allow older lm-sensors userspace
-	to keep working over the upgrade to 2.6.26. At the scheduled time of
-	removal fixed lm-sensors (2.x or 3.x) should be readily available.
-Who:	Rene Herman <rene.herman@gmail.com>
-
----------------------------
-
 What:	Code that is now under CONFIG_WIRELESS_EXT_SYSFS
 	(in net/core/net-sysfs.c)
 When:	After the only user (hal) has seen a release with the patches
--- linux-2.6.39-rc4.orig/drivers/thermal/Kconfig	2010-08-02 00:11:14.000000000 +0200
+++ linux-2.6.39-rc4/drivers/thermal/Kconfig	2011-04-23 14:48:54.000000000 +0200
@@ -12,13 +12,3 @@ menuconfig THERMAL
 	  cooling devices.
 	  All platforms with ACPI thermal support can use this driver.
 	  If you want this support, you should say Y or M here.
-
-config THERMAL_HWMON
-	bool "Hardware monitoring support"
-	depends on THERMAL
-	depends on HWMON=y || HWMON=THERMAL
-	help
-	  The generic thermal sysfs driver's hardware monitoring support
-	  requires a 2.10.7/3.0.2 or later lm-sensors userspace.
-
-	  Say Y if your user-space is new enough.
--- linux-2.6.39-rc4.orig/drivers/thermal/thermal_sys.c	2011-03-30 10:57:31.000000000 +0200
+++ linux-2.6.39-rc4/drivers/thermal/thermal_sys.c	2011-04-23 14:47:40.000000000 +0200
@@ -416,8 +416,8 @@ thermal_cooling_device_trip_point_show(s
 
 /* Device management */
 
-#if defined(CONFIG_THERMAL_HWMON)
-
+#if defined(CONFIG_HWMON) ||	\
+	(defined(CONFIG_HWMON_MODULE) && defined(CONFIG_THERMAL_MODULE))
 /* hwmon sys I/F */
 #include <linux/hwmon.h>
 static LIST_HEAD(thermal_hwmon_list);
--- linux-2.6.39-rc4.orig/include/linux/thermal.h	2011-03-15 22:53:23.000000000 +0100
+++ linux-2.6.39-rc4/include/linux/thermal.h	2011-04-23 14:50:05.000000000 +0200
@@ -85,7 +85,8 @@ struct thermal_cooling_device {
 				((long)t-2732+5)/10 : ((long)t-2732-5)/10)
 #define CELSIUS_TO_KELVIN(t)	((t)*10+2732)
 
-#if defined(CONFIG_THERMAL_HWMON)
+#if defined(CONFIG_HWMON) ||	\
+	(defined(CONFIG_HWMON_MODULE) && defined(CONFIG_THERMAL_MODULE))
 /* thermal zone devices with the same type share one hwmon device */
 struct thermal_hwmon_device {
 	char type[THERMAL_NAME_LENGTH];
@@ -120,7 +121,8 @@ struct thermal_zone_device {
 	struct mutex lock;	/* protect cooling devices list */
 	struct list_head node;
 	struct delayed_work poll_queue;
-#if defined(CONFIG_THERMAL_HWMON)
+#if defined(CONFIG_HWMON) ||	\
+	(defined(CONFIG_HWMON_MODULE) && defined(CONFIG_THERMAL_MODULE))
 	struct list_head hwmon_node;
 	struct thermal_hwmon_device *hwmon;
 	struct thermal_hwmon_attr temp_input;	/* hwmon sys attr */


-- 
Jean Delvare
