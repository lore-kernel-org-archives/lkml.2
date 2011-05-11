Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab1EKQJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:09:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15713 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab1EKQJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:09:02 -0400
X-AuditID: cbfee61b-b7bb4ae000002c54-b8-4dca41b4eb83
Date: Wed, 11 May 2011 16:58:43 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 3/3] PM / DEVFREQ: add sysfs interface (including user
 tickling)
In-reply-to: <1305100723-29161-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mark Brown <broonie@sirena.org.uk>, Jiejing Zhang <kzjeef@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Colin Cross <ccross@google.com>,
        Nishanth Menon <nm@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, myungjoo.ham@gmail.com
Message-id: <1305100723-29161-3-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1305100723-29161-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 11 May 2011 07:58:43.0692 (UTC)
 FILETIME=[3F8FD2C0:01CC0FB1]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. System-wide sysfs interface
- tickle_all	R: number of tickle_all execution
		W: tickle all devfreq devices
- min_interval	R: devfreq monitoring base interval in ms
- monitoring	R: shows whether devfreq monitoring is active or
  not.

2. Device specific sysfs interface
- tickle	R: number of tickle execution for the device
		W: tickle the device

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/base/power/devfreq.c |  191 ++++++++++++++++++++++++++++++++++++-----
 include/linux/devfreq.h      |    3 +
 2 files changed, 170 insertions(+), 24 deletions(-)

diff --git a/drivers/base/power/devfreq.c b/drivers/base/power/devfreq.c
index 251d761..ba1b606 100644
--- a/drivers/base/power/devfreq.c
+++ b/drivers/base/power/devfreq.c
@@ -40,6 +40,9 @@ static LIST_HEAD(devfreq_list);
 /* Exclusive access to devfreq_list and its elements */
 static DEFINE_MUTEX(devfreq_list_lock);
 
+static struct kobject *devfreq_kobj;
+static struct attribute_group dev_attr_group;
+
 /**
  * find_device_devfreq() - find devfreq struct using device pointer
  * @dev:	device pointer used to lookup device DEVFREQ.
@@ -211,6 +214,8 @@ int devfreq_add_device(struct device *dev, struct devfreq_dev_profile *profile,
 		queue_delayed_work(devfreq_wq, &devfreq_work,
 				   msecs_to_jiffies(DEVFREQ_INTERVAL));
 	}
+
+	sysfs_update_group(&dev->kobj, &dev_attr_group);
 out:
 	mutex_unlock(&devfreq_list_lock);
 
@@ -237,6 +242,8 @@ int devfreq_remove_device(struct device *dev)
 		return -EINVAL;
 	}
 
+	sysfs_remove_group(&dev->kobj, &dev_attr_group);
+
 	list_del(&devfreq->node);
 
 	kfree(devfreq);
@@ -286,6 +293,38 @@ out:
 	return err;
 }
 
+int _devfreq_tickle_device(struct devfreq *df, unsigned long delay)
+{
+	int err = 0;
+	unsigned long freq;
+	struct opp *opp;
+
+	freq = df->profile->max_freq;
+	opp = opp_find_freq_floor(df->dev, &freq);
+	if (IS_ERR(opp))
+		return PTR_ERR(opp);
+
+	freq = opp_get_freq(opp);
+	if (df->previous_freq != freq) {
+		err = df->profile->target(df->dev, opp);
+		if (!err)
+			df->previous_freq = freq;
+	}
+	if (err) {
+		dev_err(df->dev, "%s: Cannot set frequency.\n", __func__);
+	} else {
+		df->tickle = delay;
+		df->num_tickle++;
+	}
+
+	if (devfreq_wq && !monitoring) {
+		monitoring = true;
+		queue_delayed_work(devfreq_wq, &devfreq_work,
+				   msecs_to_jiffies(DEVFREQ_INTERVAL));
+	}
+
+	return err;
+}
 /**
  * devfreq_tickle_device() - Guarantee maximum operation speed for a while
  *			instaneously.
@@ -301,43 +340,133 @@ out:
 int devfreq_tickle_device(struct device *dev, unsigned long duration_ms)
 {
 	struct devfreq *devfreq;
-	struct opp *opp;
-	unsigned long freq;
 	int err = 0;
+	unsigned long delay; /* in num DEVFREQ_INTERVAL */
 
 	mutex_lock(&devfreq_list_lock);
 	devfreq = find_device_devfreq(dev);
-	if (!IS_ERR(devfreq)) {
-		freq = devfreq->profile->max_freq;
-		opp = opp_find_freq_floor(devfreq->dev, &freq);
-		freq = opp_get_freq(opp);
-		if (devfreq->previous_freq != freq) {
-			err = devfreq->profile->target(devfreq->dev, opp);
-			if (!err)
-				devfreq->previous_freq = freq;
-		}
-		if (err)
-			dev_err(dev, "%s: Cannot set frequency.\n", __func__);
-		else
-			devfreq->tickle = DIV_ROUND_UP(duration_ms,
-						       DEVFREQ_INTERVAL);
+	delay = DIV_ROUND_UP(duration_ms, DEVFREQ_INTERVAL);
+
+	if (IS_ERR(devfreq))
+		err = PTR_ERR(devfreq);
+	else
+		err = _devfreq_tickle_device(devfreq, delay);
+
+	mutex_unlock(&devfreq_list_lock);
+
+	return err;
+}
+
+static int num_tickle_all;
+static ssize_t tickle_all(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t count)
+{
+	int duration;
+	struct devfreq *tmp;
+	unsigned long delay;
+
+	sscanf(buf, "%d", &duration);
+	if (duration < DEVFREQ_INTERVAL)
+		duration = DEVFREQ_INTERVAL;
+
+	if (unlikely(IS_ERR_OR_NULL(dev))) {
+		pr_err("%s: Invalid parameters\n", __func__);
+		return -EINVAL;
 	}
 
-	if (devfreq_wq && !monitoring) {
-		monitoring = true;
-		queue_delayed_work(devfreq_wq, &devfreq_work,
-				   msecs_to_jiffies(DEVFREQ_INTERVAL));
+	delay = DIV_ROUND_UP(duration, DEVFREQ_INTERVAL);
+
+	mutex_lock(&devfreq_list_lock);
+	list_for_each_entry(tmp, &devfreq_list, node) {
+		_devfreq_tickle_device(tmp, delay);
 	}
 	mutex_unlock(&devfreq_list_lock);
 
-	if (IS_ERR(devfreq)) {
-		dev_err(dev, "%s: Cannot find devfreq.\n", __func__);
-		err = PTR_ERR(devfreq);
+	num_tickle_all++;
+	return count;
+}
+
+static ssize_t show_num_tickle_all(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", num_tickle_all);
+}
+
+static ssize_t show_min_interval(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", DEVFREQ_INTERVAL);
+}
+
+static ssize_t show_monitoring(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", monitoring ? 1 : 0);
+}
+
+static DEVICE_ATTR(tickle_all, 0644, show_num_tickle_all, tickle_all);
+static DEVICE_ATTR(min_interval, 0444, show_min_interval, NULL);
+static DEVICE_ATTR(monitoring, 0444, show_monitoring, NULL);
+static struct attribute *devfreq_entries[] = {
+	&dev_attr_tickle_all.attr,
+	&dev_attr_min_interval.attr,
+	&dev_attr_monitoring.attr,
+	NULL,
+};
+static struct attribute_group devfreq_attr_group = {
+	.name	= "devfreq",
+	.attrs	= devfreq_entries,
+};
+
+static ssize_t tickle(struct device *dev, struct device_attribute *attr,
+		      const char *buf, size_t count)
+{
+	int duration;
+	struct devfreq *df;
+	unsigned long delay;
+
+	sscanf(buf, "%d", &duration);
+	if (duration < DEVFREQ_INTERVAL)
+		duration = DEVFREQ_INTERVAL;
+
+	if (unlikely(IS_ERR_OR_NULL(dev))) {
+		pr_err("%s: Invalid parameters\n", __func__);
+		return -EINVAL;
 	}
 
-	return err;
+	delay = DIV_ROUND_UP(duration, DEVFREQ_INTERVAL);
+
+	mutex_lock(&devfreq_list_lock);
+	df = find_device_devfreq(dev);
+	_devfreq_tickle_device(df, delay);
+	mutex_unlock(&devfreq_list_lock);
+
+	return count;
 }
 
+static ssize_t show_num_tickle(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct devfreq *df;
+
+	df = find_device_devfreq(dev);
+
+	if (!IS_ERR(df))
+		return sprintf(buf, "%d\n", df->num_tickle);
+
+	return PTR_ERR(df);
+}
+
+static DEVICE_ATTR(tickle, 0644, show_num_tickle, tickle);
+static struct attribute *dev_entries[] = {
+	&dev_attr_tickle.attr,
+	NULL,
+};
+static struct attribute_group dev_attr_group = {
+	.name	= NULL,
+	.attrs	= dev_entries,
+};
+
 static int __init devfreq_init(void)
 {
 	mutex_lock(&devfreq_list_lock);
@@ -345,6 +474,20 @@ static int __init devfreq_init(void)
 	monitoring = false;
 	devfreq_wq = create_freezable_workqueue("devfreq_wq");
 	INIT_DELAYED_WORK_DEFERRABLE(&devfreq_work, devfreq_monitor);
+
+	/* Create sysfs */
+#ifdef CONFIG_PM
+	devfreq_kobj = kobject_create_and_add("devfreq", power_kobj);
+	if (!devfreq_kobj) {
+		pr_err("Unable to create DEVFREQ kobject.\n");
+		goto out;
+	}
+	if (sysfs_create_group(devfreq_kobj, &devfreq_attr_group)) {
+		pr_err("Unable to create DEVFREQ sysfs entries.\n");
+		goto out;
+	}
+#endif
+out:
 	mutex_unlock(&devfreq_list_lock);
 
 	devfreq_monitor(&devfreq_work.work);
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index ec41ba6..f6e38ee 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -59,6 +59,7 @@ struct devfreq_governor {
  *		at each executino of devfreq_monitor, tickle is decremented.
  *		User may tickle a device-devfreq in order to set maximum
  *		frequency instaneously with some guaranteed duration.
+ * @num_tickle	number of tickle calls.
  *
  * This structure stores the DEVFREQ information for a give device.
  */
@@ -72,6 +73,8 @@ struct devfreq {
 	unsigned long previous_freq;
 	unsigned int next_polling;
 	unsigned int tickle;
+
+	unsigned int num_tickle;
 };
 
 #if defined(CONFIG_PM_DEVFREQ)
-- 
1.7.4.1

