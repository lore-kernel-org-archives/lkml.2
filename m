Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab0E1GEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 02:04:34 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:57342 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758495Ab0E1GDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 02:03:45 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 3/8] cpuidle: make cpuidle_curr_driver static
Date: Fri, 28 May 2010 02:01:56 -0400
Message-id: <752138df0dc2daaae09379c754caeb08c97905dc.1275026041.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
In-reply-to: <1275026521-30835-1-git-send-email-lenb@kernel.org>
References: <1275026521-30835-1-git-send-email-lenb@kernel.org>
In-reply-to: <6b2c676bf32be91f43215d5874c07c1becaba013.1275026041.git.len.brown@intel.com>
References: <6b2c676bf32be91f43215d5874c07c1becaba013.1275026041.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

cpuidle_register_driver() sets cpuidle_curr_driver
cpuidle_unregister_driver() clears cpuidle_curr_driver

We should't expose cpuidle_curr_driver to
potential modification except via these interfaces.
So make it static and create cpuidle_get_driver() to observe it.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/cpuidle/cpuidle.c |   12 +++++++-----
 drivers/cpuidle/cpuidle.h |    1 -
 drivers/cpuidle/driver.c  |   11 ++++++++++-
 drivers/cpuidle/sysfs.c   |    5 +++--
 include/linux/cpuidle.h   |    2 ++
 5 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 12fdd39..1994885 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -156,7 +156,7 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
 
 	if (dev->enabled)
 		return 0;
-	if (!cpuidle_curr_driver || !cpuidle_curr_governor)
+	if (!cpuidle_get_driver() || !cpuidle_curr_governor)
 		return -EIO;
 	if (!dev->state_count)
 		return -EINVAL;
@@ -207,7 +207,7 @@ void cpuidle_disable_device(struct cpuidle_device *dev)
 {
 	if (!dev->enabled)
 		return;
-	if (!cpuidle_curr_driver || !cpuidle_curr_governor)
+	if (!cpuidle_get_driver() || !cpuidle_curr_governor)
 		return;
 
 	dev->enabled = 0;
@@ -271,10 +271,11 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 {
 	int ret;
 	struct sys_device *sys_dev = get_cpu_sysdev((unsigned long)dev->cpu);
+	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
 
 	if (!sys_dev)
 		return -EINVAL;
-	if (!try_module_get(cpuidle_curr_driver->owner))
+	if (!try_module_get(cpuidle_driver->owner))
 		return -EINVAL;
 
 	init_completion(&dev->kobj_unregister);
@@ -284,7 +285,7 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 	per_cpu(cpuidle_devices, dev->cpu) = dev;
 	list_add(&dev->device_list, &cpuidle_detected_devices);
 	if ((ret = cpuidle_add_sysfs(sys_dev))) {
-		module_put(cpuidle_curr_driver->owner);
+		module_put(cpuidle_driver->owner);
 		return ret;
 	}
 
@@ -325,6 +326,7 @@ EXPORT_SYMBOL_GPL(cpuidle_register_device);
 void cpuidle_unregister_device(struct cpuidle_device *dev)
 {
 	struct sys_device *sys_dev = get_cpu_sysdev((unsigned long)dev->cpu);
+	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
 
 	if (dev->registered == 0)
 		return;
@@ -340,7 +342,7 @@ void cpuidle_unregister_device(struct cpuidle_device *dev)
 
 	cpuidle_resume_and_unlock();
 
-	module_put(cpuidle_curr_driver->owner);
+	module_put(cpuidle_driver->owner);
 }
 
 EXPORT_SYMBOL_GPL(cpuidle_unregister_device);
diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
index 9476ba3..33e50d5 100644
--- a/drivers/cpuidle/cpuidle.h
+++ b/drivers/cpuidle/cpuidle.h
@@ -9,7 +9,6 @@
 
 /* For internal use only */
 extern struct cpuidle_governor *cpuidle_curr_governor;
-extern struct cpuidle_driver *cpuidle_curr_driver;
 extern struct list_head cpuidle_governors;
 extern struct list_head cpuidle_detected_devices;
 extern struct mutex cpuidle_lock;
diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index 826b5c0..fd1601e 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -14,7 +14,7 @@
 
 #include "cpuidle.h"
 
-struct cpuidle_driver *cpuidle_curr_driver;
+static struct cpuidle_driver *cpuidle_curr_driver;
 DEFINE_SPINLOCK(cpuidle_driver_lock);
 
 /**
@@ -40,6 +40,15 @@ int cpuidle_register_driver(struct cpuidle_driver *drv)
 EXPORT_SYMBOL_GPL(cpuidle_register_driver);
 
 /**
+ * cpuidle_get_driver - return the current driver
+ */
+struct cpuidle_driver *cpuidle_get_driver(void)
+{
+	return cpuidle_curr_driver;
+}
+EXPORT_SYMBOL_GPL(cpuidle_get_driver);
+
+/**
  * cpuidle_unregister_driver - unregisters a driver
  * @drv: the driver
  */
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 0ba9c8b..0310ffa 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -47,10 +47,11 @@ static ssize_t show_current_driver(struct sysdev_class *class,
 				   char *buf)
 {
 	ssize_t ret;
+	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
 
 	spin_lock(&cpuidle_driver_lock);
-	if (cpuidle_curr_driver)
-		ret = sprintf(buf, "%s\n", cpuidle_curr_driver->name);
+	if (cpuidle_driver)
+		ret = sprintf(buf, "%s\n", cpuidle_driver->name);
 	else
 		ret = sprintf(buf, "none\n");
 	spin_unlock(&cpuidle_driver_lock);
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index f5e6480..55215cc 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -125,6 +125,7 @@ struct cpuidle_driver {
 #ifdef CONFIG_CPU_IDLE
 
 extern int cpuidle_register_driver(struct cpuidle_driver *drv);
+struct cpuidle_driver *cpuidle_get_driver(void);
 extern void cpuidle_unregister_driver(struct cpuidle_driver *drv);
 extern int cpuidle_register_device(struct cpuidle_device *dev);
 extern void cpuidle_unregister_device(struct cpuidle_device *dev);
@@ -138,6 +139,7 @@ extern void cpuidle_disable_device(struct cpuidle_device *dev);
 
 static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
 {return -ENODEV; }
+static inline struct cpuidle_driver *cpuidle_get_driver(void) {return NULL; }
 static inline void cpuidle_unregister_driver(struct cpuidle_driver *drv) { }
 static inline int cpuidle_register_device(struct cpuidle_device *dev)
 {return -ENODEV; }
-- 
1.6.0.6

