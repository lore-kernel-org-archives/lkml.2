Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164Ab2J2UCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:02:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57002 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758781Ab2J2UB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:01:59 -0400
From: Nishanth Menon <nm@ti.com>
To: linux-pm <linux-pm@vger.kernel.org>
CC: Nishanth Menon <nm@ti.com>, Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [linux-next PATCH 4/7] PM / devfreq: map devfreq drivers to governor using name
Date: Mon, 29 Oct 2012 15:01:45 -0500
Message-ID: <1351540908-12195-5-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351540908-12195-1-git-send-email-nm@ti.com>
References: <1351540908-12195-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow devfreq drivers to register a preferred governor name
and when the devfreq governor loads itself at a later point
required drivers are managed appropriately, at the time of
unload of a devfreq governor, stop managing those drivers
as well.

Since the governor structures do not need to be exposed
anymore, remove the definitions and make them static

NOTE: devfreq_list_lock is now used to protect governor
start and stop - as this allows us to protect governors and
devfreq with the proper dependencies as needed.

As part of this change, change the registration of exynos
bus driver to request for ondemand using the governor name.

Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@ti.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/devfreq/devfreq.c                 |   95 ++++++++++++++++++++++++++---
 drivers/devfreq/exynos4_bus.c             |    2 +-
 drivers/devfreq/governor_performance.c    |    2 +-
 drivers/devfreq/governor_powersave.c      |    2 +-
 drivers/devfreq/governor_simpleondemand.c |    2 +-
 drivers/devfreq/governor_userspace.c      |    2 +-
 include/linux/devfreq.h                   |   21 ++-----
 7 files changed, 96 insertions(+), 30 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 9c079d2..bd96e32 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -114,6 +114,9 @@ int update_devfreq(struct devfreq *devfreq)
 		return -EINVAL;
 	}
 
+	if (!devfreq->governor)
+		return -EINVAL;
+
 	/* Reevaluate the proper frequency */
 	err = devfreq->governor->get_target_freq(devfreq, &freq);
 	if (err)
@@ -329,7 +332,9 @@ static void _remove_devfreq(struct devfreq *devfreq, bool skip)
 	list_del(&devfreq->node);
 	mutex_unlock(&devfreq_list_lock);
 
-	devfreq->governor->event_handler(devfreq, DEVFREQ_GOV_STOP, NULL);
+	if (devfreq->governor)
+		devfreq->governor->event_handler(devfreq,
+						 DEVFREQ_GOV_STOP, NULL);
 
 	if (devfreq->profile->exit)
 		devfreq->profile->exit(devfreq->dev.parent);
@@ -362,19 +367,20 @@ static void devfreq_dev_release(struct device *dev)
  * devfreq_add_device() - Add devfreq feature to the device
  * @dev:	the device to add devfreq feature.
  * @profile:	device-specific profile to run devfreq.
- * @governor:	the policy to choose frequency.
+ * @governor_name:	name of the policy to choose frequency.
  * @data:	private data for the governor. The devfreq framework does not
  *		touch this value.
  */
 struct devfreq *devfreq_add_device(struct device *dev,
 				   struct devfreq_dev_profile *profile,
-				   const struct devfreq_governor *governor,
+				   const char *governor_name,
 				   void *data)
 {
 	struct devfreq *devfreq;
+	struct devfreq_governor *governor;
 	int err = 0;
 
-	if (!dev || !profile || !governor) {
+	if (!dev || !profile || !governor_name) {
 		dev_err(dev, "%s: Invalid parameters.\n", __func__);
 		return ERR_PTR(-EINVAL);
 	}
@@ -402,7 +408,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
 	devfreq->dev.class = devfreq_class;
 	devfreq->dev.release = devfreq_dev_release;
 	devfreq->profile = profile;
-	devfreq->governor = governor;
+	strncpy(devfreq->governor_name, governor_name, DEVFREQ_NAME_LEN);
 	devfreq->previous_freq = profile->initial_freq;
 	devfreq->data = data;
 	devfreq->nb.notifier_call = devfreq_notifier_call;
@@ -419,10 +425,14 @@ struct devfreq *devfreq_add_device(struct device *dev,
 
 	mutex_lock(&devfreq_list_lock);
 	list_add(&devfreq->node, &devfreq_list);
-	mutex_unlock(&devfreq_list_lock);
 
-	err = devfreq->governor->event_handler(devfreq,
-				DEVFREQ_GOV_START, NULL);
+	governor = find_devfreq_governor(devfreq->governor_name);
+	if (!IS_ERR(governor))
+		devfreq->governor = governor;
+	if (devfreq->governor)
+		err = devfreq->governor->event_handler(devfreq,
+					DEVFREQ_GOV_START, NULL);
+	mutex_unlock(&devfreq_list_lock);
 	if (err) {
 		dev_err(dev, "%s: Unable to start governor for the device\n",
 			__func__);
@@ -465,6 +475,9 @@ int devfreq_suspend_device(struct devfreq *devfreq)
 	if (!devfreq)
 		return -EINVAL;
 
+	if (!devfreq->governor)
+		return 0;
+
 	return devfreq->governor->event_handler(devfreq,
 				DEVFREQ_GOV_SUSPEND, NULL);
 }
@@ -479,6 +492,9 @@ int devfreq_resume_device(struct devfreq *devfreq)
 	if (!devfreq)
 		return -EINVAL;
 
+	if (!devfreq->governor)
+		return 0;
+
 	return devfreq->governor->event_handler(devfreq,
 				DEVFREQ_GOV_RESUME, NULL);
 }
@@ -491,6 +507,7 @@ EXPORT_SYMBOL(devfreq_resume_device);
 int devfreq_add_governor(struct devfreq_governor *governor)
 {
 	struct devfreq_governor *g;
+	struct devfreq *devfreq;
 	int err = 0;
 
 	if (!governor) {
@@ -509,6 +526,38 @@ int devfreq_add_governor(struct devfreq_governor *governor)
 
 	list_add(&governor->node, &devfreq_governor_list);
 
+	list_for_each_entry(devfreq, &devfreq_list, node) {
+		int ret = 0;
+		struct device *dev = devfreq->dev.parent;
+
+		if (!strncmp(devfreq->governor_name, governor->name,
+			     DEVFREQ_NAME_LEN)) {
+			/* The following should never occur */
+			if (devfreq->governor) {
+				dev_warn(dev,
+					 "%s: Governor %s already present\n",
+					 __func__, devfreq->governor->name);
+				ret = devfreq->governor->event_handler(devfreq,
+							DEVFREQ_GOV_STOP, NULL);
+				if (ret) {
+					dev_warn(dev,
+						 "%s: Governor %s stop = %d\n",
+						 __func__,
+						 devfreq->governor->name, ret);
+				}
+				/* Fall through */
+			}
+			devfreq->governor = governor;
+			ret = devfreq->governor->event_handler(devfreq,
+						DEVFREQ_GOV_START, NULL);
+			if (ret) {
+				dev_warn(dev, "%s: Governor %s start=%d\n",
+					 __func__, devfreq->governor->name,
+					 ret);
+			}
+		}
+	}
+
 err_out:
 	mutex_unlock(&devfreq_list_lock);
 
@@ -523,6 +572,7 @@ EXPORT_SYMBOL(devfreq_add_governor);
 int devfreq_remove_governor(struct devfreq_governor *governor)
 {
 	struct devfreq_governor *g;
+	struct devfreq *devfreq;
 	int err = 0;
 
 	if (!governor) {
@@ -538,6 +588,29 @@ int devfreq_remove_governor(struct devfreq_governor *governor)
 		err = -EINVAL;
 		goto err_out;
 	}
+	list_for_each_entry(devfreq, &devfreq_list, node) {
+		int ret;
+		struct device *dev = devfreq->dev.parent;
+
+		if (!strncmp(devfreq->governor_name, governor->name,
+			     DEVFREQ_NAME_LEN)) {
+			/* we should have a devfreq governor! */
+			if (!devfreq->governor) {
+				dev_warn(dev, "%s: Governor %s NOT present\n",
+					 __func__, governor->name);
+				continue;
+				/* Fall through */
+			}
+			ret = devfreq->governor->event_handler(devfreq,
+						DEVFREQ_GOV_STOP, NULL);
+			if (ret) {
+				dev_warn(dev, "%s: Governor %s stop=%d\n",
+					 __func__, devfreq->governor->name,
+					 ret);
+			}
+			devfreq->governor = NULL;
+		}
+	}
 
 	list_del(&governor->node);
 err_out:
@@ -550,6 +623,9 @@ EXPORT_SYMBOL(devfreq_remove_governor);
 static ssize_t show_governor(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
+	if (!to_devfreq(dev)->governor)
+		return -EINVAL;
+
 	return sprintf(buf, "%s\n", to_devfreq(dev)->governor->name);
 }
 
@@ -586,6 +662,9 @@ static ssize_t store_polling_interval(struct device *dev,
 	unsigned int value;
 	int ret;
 
+	if (!df->governor)
+		return -EINVAL;
+
 	ret = sscanf(buf, "%u", &value);
 	if (ret != 1)
 		return -EINVAL;
diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
index 88ddc77..b8b1a00 100644
--- a/drivers/devfreq/exynos4_bus.c
+++ b/drivers/devfreq/exynos4_bus.c
@@ -1045,7 +1045,7 @@ static __devinit int exynos4_busfreq_probe(struct platform_device *pdev)
 	busfreq_mon_reset(data);
 
 	data->devfreq = devfreq_add_device(dev, &exynos4_devfreq_profile,
-					   &devfreq_simple_ondemand, NULL);
+					   "simple_ondemand", NULL);
 	if (IS_ERR(data->devfreq)) {
 		err = PTR_ERR(data->devfreq);
 		goto err_opp_add;
diff --git a/drivers/devfreq/governor_performance.c b/drivers/devfreq/governor_performance.c
index db8ff77..865a369 100644
--- a/drivers/devfreq/governor_performance.c
+++ b/drivers/devfreq/governor_performance.c
@@ -40,7 +40,7 @@ static int devfreq_performance_handler(struct devfreq *devfreq,
 	return ret;
 }
 
-const struct devfreq_governor devfreq_performance = {
+static struct devfreq_governor devfreq_performance = {
 	.name = "performance",
 	.get_target_freq = devfreq_performance_func,
 	.event_handler = devfreq_performance_handler,
diff --git a/drivers/devfreq/governor_powersave.c b/drivers/devfreq/governor_powersave.c
index 30f0fca..8612c0f 100644
--- a/drivers/devfreq/governor_powersave.c
+++ b/drivers/devfreq/governor_powersave.c
@@ -37,7 +37,7 @@ static int devfreq_powersave_handler(struct devfreq *devfreq,
 	return ret;
 }
 
-const struct devfreq_governor devfreq_powersave = {
+static struct devfreq_governor devfreq_powersave = {
 	.name = "powersave",
 	.get_target_freq = devfreq_powersave_func,
 	.event_handler = devfreq_powersave_handler,
diff --git a/drivers/devfreq/governor_simpleondemand.c b/drivers/devfreq/governor_simpleondemand.c
index 85f9ed5..a870a24 100644
--- a/drivers/devfreq/governor_simpleondemand.c
+++ b/drivers/devfreq/governor_simpleondemand.c
@@ -120,7 +120,7 @@ static int devfreq_simple_ondemand_handler(struct devfreq *devfreq,
 	return 0;
 }
 
-const struct devfreq_governor devfreq_simple_ondemand = {
+static struct devfreq_governor devfreq_simple_ondemand = {
 	.name = "simple_ondemand",
 	.get_target_freq = devfreq_simple_ondemand_func,
 	.event_handler = devfreq_simple_ondemand_handler,
diff --git a/drivers/devfreq/governor_userspace.c b/drivers/devfreq/governor_userspace.c
index 110f178..34fb80f 100644
--- a/drivers/devfreq/governor_userspace.c
+++ b/drivers/devfreq/governor_userspace.c
@@ -135,7 +135,7 @@ static int devfreq_userspace_handler(struct devfreq *devfreq,
 	return ret;
 }
 
-const struct devfreq_governor devfreq_userspace = {
+static struct devfreq_governor devfreq_userspace = {
 	.name = "userspace",
 	.get_target_freq = devfreq_userspace_func,
 	.event_handler = devfreq_userspace_handler,
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index a28d935..092fe72 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -120,6 +120,7 @@ struct devfreq_governor {
  *		using devfreq.
  * @profile:	device-specific devfreq profile
  * @governor:	method how to choose frequency based on the usage.
+ * @governor_name:	devfreq governor name for use with this devfreq
  * @nb:		notifier block used to notify devfreq object that it should
  *		reevaluate operable frequencies. Devfreq users may use
  *		devfreq.nb to the corresponding register notifier call chain.
@@ -146,6 +147,7 @@ struct devfreq {
 	struct device dev;
 	struct devfreq_dev_profile *profile;
 	const struct devfreq_governor *governor;
+	char governor_name[DEVFREQ_NAME_LEN];
 	struct notifier_block nb;
 	struct delayed_work work;
 
@@ -161,7 +163,7 @@ struct devfreq {
 #if defined(CONFIG_PM_DEVFREQ)
 extern struct devfreq *devfreq_add_device(struct device *dev,
 				  struct devfreq_dev_profile *profile,
-				  const struct devfreq_governor *governor,
+				  const char *governor_name,
 				  void *data);
 extern int devfreq_remove_device(struct devfreq *devfreq);
 extern int devfreq_suspend_device(struct devfreq *devfreq);
@@ -175,17 +177,7 @@ extern int devfreq_register_opp_notifier(struct device *dev,
 extern int devfreq_unregister_opp_notifier(struct device *dev,
 					   struct devfreq *devfreq);
 
-#ifdef CONFIG_DEVFREQ_GOV_POWERSAVE
-extern const struct devfreq_governor devfreq_powersave;
-#endif
-#ifdef CONFIG_DEVFREQ_GOV_PERFORMANCE
-extern const struct devfreq_governor devfreq_performance;
-#endif
-#ifdef CONFIG_DEVFREQ_GOV_USERSPACE
-extern const struct devfreq_governor devfreq_userspace;
-#endif
 #ifdef CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND
-extern const struct devfreq_governor devfreq_simple_ondemand;
 /**
  * struct devfreq_simple_ondemand_data - void *data fed to struct devfreq
  *	and devfreq_add_device
@@ -208,7 +200,7 @@ struct devfreq_simple_ondemand_data {
 #else /* !CONFIG_PM_DEVFREQ */
 static struct devfreq *devfreq_add_device(struct device *dev,
 					  struct devfreq_dev_profile *profile,
-					  struct devfreq_governor *governor,
+					  const char *governor_name,
 					  void *data)
 {
 	return NULL;
@@ -247,11 +239,6 @@ static int devfreq_unregister_opp_notifier(struct device *dev,
 	return -EINVAL;
 }
 
-#define devfreq_powersave	NULL
-#define devfreq_performance	NULL
-#define devfreq_userspace	NULL
-#define devfreq_simple_ondemand	NULL
-
 #endif /* CONFIG_PM_DEVFREQ */
 
 #endif /* __LINUX_DEVFREQ_H__ */
-- 
1.7.9.5

