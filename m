Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2KUJEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:04:51 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43811 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab2KUJEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:04:25 -0500
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: myungjoo.ham@samsung.com, rjw@sisk.pl, nm@ti.com, mturquette@linaro.org,
        kyungmin.park@samsung.com
Cc: patches@linaro.org, linaro-dev@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>
Subject: [RFC PATCH] PM / devfreq: Add runtime-pm support
Date: Wed, 21 Nov 2012 14:31:14 +0530
Message-Id: <1353488474-24420-1-git-send-email-rajagopal.venkat@linaro.org>
X-Mailer: git-send-email 1.7.11.3
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
 drivers/devfreq/devfreq.c | 145 ++++++++++++++++++++++++++++++++--------------
 include/linux/devfreq.h   |  12 ----
 2 files changed, 102 insertions(+), 55 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 45e053e..190e414 100644
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
@@ -414,6 +413,93 @@ static void devfreq_dev_release(struct device *dev)
 }
 
 /**
+ * devfreq_suspend_device() - Suspend devfreq of a device.
+ * @devfreq: the devfreq instance to be suspended
+ */
+static int devfreq_suspend_device(struct devfreq *devfreq)
+{
+	if (!devfreq)
+		return -EINVAL;
+
+	if (!devfreq->governor)
+		return 0;
+
+	return devfreq->governor->event_handler(devfreq,
+				DEVFREQ_GOV_SUSPEND, NULL);
+}
+
+/**
+ * devfreq_resume_device() - Resume devfreq of a device.
+ * @devfreq: the devfreq instance to be resumed
+ */
+static int devfreq_resume_device(struct devfreq *devfreq)
+{
+	if (!devfreq)
+		return -EINVAL;
+
+	if (!devfreq->governor)
+		return 0;
+
+	return devfreq->governor->event_handler(devfreq,
+				DEVFREQ_GOV_RESUME, NULL);
+}
+
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
+/**
  * devfreq_add_device() - Add devfreq feature to the device
  * @dev:	the device to add devfreq feature.
  * @profile:	device-specific profile to run devfreq.
@@ -454,8 +540,9 @@ struct devfreq *devfreq_add_device(struct device *dev,
 
 	mutex_init(&devfreq->lock);
 	mutex_lock(&devfreq->lock);
+	dev->class = &devfreq_class;
 	devfreq->dev.parent = dev;
-	devfreq->dev.class = devfreq_class;
+	devfreq->dev.class = &devfreq_class;
 	devfreq->dev.release = devfreq_dev_release;
 	devfreq->profile = profile;
 	strncpy(devfreq->governor_name, governor_name, DEVFREQ_NAME_LEN);
@@ -498,6 +585,9 @@ struct devfreq *devfreq_add_device(struct device *dev,
 		goto err_init;
 	}
 
+	pm_runtime_get_noresume(dev);
+	pm_runtime_set_active(dev);
+
 	return devfreq;
 
 err_init:
@@ -526,40 +616,6 @@ int devfreq_remove_device(struct devfreq *devfreq)
 EXPORT_SYMBOL(devfreq_remove_device);
 
 /**
- * devfreq_suspend_device() - Suspend devfreq of a device.
- * @devfreq: the devfreq instance to be suspended
- */
-int devfreq_suspend_device(struct devfreq *devfreq)
-{
-	if (!devfreq)
-		return -EINVAL;
-
-	if (!devfreq->governor)
-		return 0;
-
-	return devfreq->governor->event_handler(devfreq,
-				DEVFREQ_GOV_SUSPEND, NULL);
-}
-EXPORT_SYMBOL(devfreq_suspend_device);
-
-/**
- * devfreq_resume_device() - Resume devfreq of a device.
- * @devfreq: the devfreq instance to be resumed
- */
-int devfreq_resume_device(struct devfreq *devfreq)
-{
-	if (!devfreq)
-		return -EINVAL;
-
-	if (!devfreq->governor)
-		return 0;
-
-	return devfreq->governor->event_handler(devfreq,
-				DEVFREQ_GOV_RESUME, NULL);
-}
-EXPORT_SYMBOL(devfreq_resume_device);
-
-/**
  * devfreq_add_governor() - Add devfreq governor
  * @governor:	the devfreq governor to be added
  */
@@ -730,6 +786,7 @@ out:
 		ret = count;
 	return ret;
 }
+
 static ssize_t show_available_governors(struct device *d,
 				    struct device_attribute *attr,
 				    char *buf)
@@ -952,19 +1009,21 @@ static struct device_attribute devfreq_attrs[] = {
 
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
@@ -972,7 +1031,7 @@ subsys_initcall(devfreq_init);
 
 static void __exit devfreq_exit(void)
 {
-	class_destroy(devfreq_class);
+	class_unregister(&devfreq_class);
 	destroy_workqueue(devfreq_wq);
 }
 module_exit(devfreq_exit);
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index 235248c..4fd920f 100644
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
1.7.11.3

