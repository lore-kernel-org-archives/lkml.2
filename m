Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab3AHGos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 01:44:48 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:57989 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3AHGor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 01:44:47 -0500
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, mturquette@linaro.org,
        rjw@sisk.pl
Cc: patches@linaro.org, linaro-dev@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>
Subject: [RFC PATCH] PM / devfreq: Add runtime-pm support
Date: Tue,  8 Jan 2013 12:10:36 +0530
Message-Id: <1357627236-16485-1-git-send-email-rajagopal.venkat@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of devfreq device driver explicitly calling devfreq suspend
and resume apis perhaps from runtime-pm suspend and resume callbacks,
let devfreq core handle it automatically.

Attach devfreq core to runtime-pm framework so that, devfreq device
driver pm_runtime_suspend() will automatically suspend the devfreq
and pm_runtime_resume() will resume the devfreq.

Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
---
 drivers/devfreq/devfreq.c |   89 ++++++++++++++++++++++++++++++++++++++-------
 include/linux/devfreq.h   |   12 ------
 2 files changed, 76 insertions(+), 25 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 4c50235..781ea47 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -25,10 +25,9 @@
 #include <linux/list.h>
 #include <linux/printk.h>
 #include <linux/hrtimer.h>
+#include <linux/pm_runtime.h>
 #include "governor.h"
 
-static struct class *devfreq_class;
-
 /*
  * devfreq core provides delayed work based load monitoring helper
  * functions. Governors can use these or can implement their own
@@ -42,6 +41,9 @@ static LIST_HEAD(devfreq_governor_list);
 static LIST_HEAD(devfreq_list);
 static DEFINE_MUTEX(devfreq_list_lock);
 
+static int devfreq_suspend_device(struct devfreq *devfreq);
+static int devfreq_resume_device(struct devfreq *devfreq);
+
 /**
  * find_device_devfreq() - find devfreq struct using device pointer
  * @dev:	device pointer used to lookup device devfreq.
@@ -453,6 +455,61 @@ static void devfreq_dev_release(struct device *dev)
 	_remove_devfreq(devfreq, true);
 }
 
+static int devfreq_runtime_suspend(struct device *dev)
+{
+	int ret;
+	struct devfreq *devfreq;
+
+	mutex_lock(&devfreq_list_lock);
+	devfreq = find_device_devfreq(dev);
+	mutex_unlock(&devfreq_list_lock);
+
+	ret = devfreq_suspend_device(devfreq);
+	if (ret < 0)
+		goto out;
+
+	ret = pm_generic_runtime_suspend(dev);
+out:
+	return ret;
+}
+
+static int devfreq_runtime_resume(struct device *dev)
+{
+	int ret;
+	struct devfreq *devfreq;
+
+	mutex_lock(&devfreq_list_lock);
+	devfreq = find_device_devfreq(dev);
+	mutex_unlock(&devfreq_list_lock);
+
+	ret = devfreq_resume_device(devfreq);
+	if (ret < 0)
+		goto out;
+
+	ret = pm_generic_runtime_resume(dev);
+out:
+	return ret;
+}
+
+static int devfreq_runtime_idle(struct device *dev)
+{
+	return pm_generic_runtime_idle(dev);
+}
+
+static const struct dev_pm_ops devfreq_pm_ops = {
+	SET_RUNTIME_PM_OPS(
+		devfreq_runtime_suspend,
+		devfreq_runtime_resume,
+		devfreq_runtime_idle
+	)
+};
+
+static struct class devfreq_class = {
+	.name = "devfreq",
+	.owner = THIS_MODULE,
+	.pm = &devfreq_pm_ops,
+};
+
 /**
  * devfreq_add_device() - Add devfreq feature to the device
  * @dev:	the device to add devfreq feature.
@@ -494,8 +551,9 @@ struct devfreq *devfreq_add_device(struct device *dev,
 
 	mutex_init(&devfreq->lock);
 	mutex_lock(&devfreq->lock);
+	dev->class = &devfreq_class;
 	devfreq->dev.parent = dev;
-	devfreq->dev.class = devfreq_class;
+	devfreq->dev.class = &devfreq_class;
 	devfreq->dev.release = devfreq_dev_release;
 	devfreq->profile = profile;
 	strncpy(devfreq->governor_name, governor_name, DEVFREQ_NAME_LEN);
@@ -538,6 +596,9 @@ struct devfreq *devfreq_add_device(struct device *dev,
 		goto err_init;
 	}
 
+	pm_runtime_get_noresume(dev);
+	pm_runtime_set_active(dev);
+
 	return devfreq;
 
 err_init:
@@ -569,7 +630,7 @@ EXPORT_SYMBOL(devfreq_remove_device);
  * devfreq_suspend_device() - Suspend devfreq of a device.
  * @devfreq: the devfreq instance to be suspended
  */
-int devfreq_suspend_device(struct devfreq *devfreq)
+static int devfreq_suspend_device(struct devfreq *devfreq)
 {
 	if (!devfreq)
 		return -EINVAL;
@@ -580,13 +641,12 @@ int devfreq_suspend_device(struct devfreq *devfreq)
 	return devfreq->governor->event_handler(devfreq,
 				DEVFREQ_GOV_SUSPEND, NULL);
 }
-EXPORT_SYMBOL(devfreq_suspend_device);
 
 /**
  * devfreq_resume_device() - Resume devfreq of a device.
  * @devfreq: the devfreq instance to be resumed
  */
-int devfreq_resume_device(struct devfreq *devfreq)
+static int devfreq_resume_device(struct devfreq *devfreq)
 {
 	if (!devfreq)
 		return -EINVAL;
@@ -597,12 +657,12 @@ int devfreq_resume_device(struct devfreq *devfreq)
 	return devfreq->governor->event_handler(devfreq,
 				DEVFREQ_GOV_RESUME, NULL);
 }
-EXPORT_SYMBOL(devfreq_resume_device);
 
 /**
  * devfreq_add_governor() - Add devfreq governor
  * @governor:	the devfreq governor to be added
  */
+
 int devfreq_add_governor(struct devfreq_governor *governor)
 {
 	struct devfreq_governor *g;
@@ -770,6 +830,7 @@ out:
 		ret = count;
 	return ret;
 }
+
 static ssize_t show_available_governors(struct device *d,
 				    struct device_attribute *attr,
 				    char *buf)
@@ -992,19 +1053,21 @@ static struct device_attribute devfreq_attrs[] = {
 
 static int __init devfreq_init(void)
 {
-	devfreq_class = class_create(THIS_MODULE, "devfreq");
-	if (IS_ERR(devfreq_class)) {
+	int err;
+
+	err = class_register(&devfreq_class);
+	if (err < 0) {
 		pr_err("%s: couldn't create class\n", __FILE__);
-		return PTR_ERR(devfreq_class);
+		return err;
 	}
 
 	devfreq_wq = create_freezable_workqueue("devfreq_wq");
 	if (IS_ERR(devfreq_wq)) {
-		class_destroy(devfreq_class);
+		class_unregister(&devfreq_class);
 		pr_err("%s: couldn't create workqueue\n", __FILE__);
 		return PTR_ERR(devfreq_wq);
 	}
-	devfreq_class->dev_attrs = devfreq_attrs;
+	devfreq_class.dev_attrs = devfreq_attrs;
 
 	return 0;
 }
@@ -1012,7 +1075,7 @@ subsys_initcall(devfreq_init);
 
 static void __exit devfreq_exit(void)
 {
-	class_destroy(devfreq_class);
+	class_unregister(&devfreq_class);
 	destroy_workqueue(devfreq_wq);
 }
 module_exit(devfreq_exit);
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index e83ef39..b84840c 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -181,8 +181,6 @@ extern struct devfreq *devfreq_add_device(struct device *dev,
 				  const char *governor_name,
 				  void *data);
 extern int devfreq_remove_device(struct devfreq *devfreq);
-extern int devfreq_suspend_device(struct devfreq *devfreq);
-extern int devfreq_resume_device(struct devfreq *devfreq);
 
 /* Helper functions for devfreq user device driver with OPP. */
 extern struct opp *devfreq_recommended_opp(struct device *dev,
@@ -226,16 +224,6 @@ static int devfreq_remove_device(struct devfreq *devfreq)
 	return 0;
 }
 
-static int devfreq_suspend_device(struct devfreq *devfreq)
-{
-	return 0;
-}
-
-static int devfreq_resume_device(struct devfreq *devfreq)
-{
-	return 0;
-}
-
 static struct opp *devfreq_recommended_opp(struct device *dev,
 					   unsigned long *freq, u32 flags)
 {
-- 
1.7.10.4

