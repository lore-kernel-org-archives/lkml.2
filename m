Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab1E0Ex0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 00:53:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16786 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab1E0ExY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 00:53:24 -0400
X-AuditID: cbfee61a-b7ce2ae000001a8f-8c-4ddf2e3cb53e
Date: Fri, 27 May 2011 13:53:15 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v3 3/3] PM / DEVFREQ: add sysfs interface (including user
 tickling)
In-reply-to: <1306471995-4048-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jiejing Zhang <kzjeef@gmail.com>, Colin Cross <ccross@google.com>,
        Nishanth Menon <nm@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
        myungjoo.ham@gmail.com
Message-id: <1306471995-4048-3-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1306471995-4048-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 27 May 2011 04:53:15.0021 (UTC)
 FILETIME=[FCF763D0:01CC1C29]
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

--
Changed from v2
- add ABI entries for devfreq sysfs interface
---
 Documentation/ABI/testing/sysfs-devices-devfreq |   21 ++++
 Documentation/ABI/testing/sysfs-power           |   43 ++++++++
 drivers/base/power/devfreq.c                    |  133 ++++++++++++++++++++++-
 include/linux/devfreq.h                         |    3 +
 4 files changed, 199 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-devfreq

diff --git a/Documentation/ABI/testing/sysfs-devices-devfreq b/Documentation/ABI/testing/sysfs-devices-devfreq
new file mode 100644
index 0000000..7f35a64
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-devfreq
@@ -0,0 +1,21 @@
+What:		/sys/devices/.../devfreq/
+Date:		May 2011
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		The /sys/device/.../devfreq directory will contain files
+		that provide interfaces to DEVFREQ for a specific device.
+
+What:		/sys/devices/.../devfreq/tickle
+Date:		May 2011
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		The /sys/devices/.../devfreq/tickle file allows user space
+		to force the corresponding device to operate at its maximum
+		operable frequency instaneously and temporarily. After a
+		designated duration has passed, the operating frequency returns
+		to normal. When a user reads the tickle entry, it returns
+		the number of tickle executions for the device. When a user
+		writes to the tickle entry with the tickle duration in ms,
+		the effect of device tickling is held for the designated
+		duration. Note that the duration is rounded-up by
+		the value DEVFREQ_INTERVAL defined in devfreq.c
diff --git a/Documentation/ABI/testing/sysfs-power b/Documentation/ABI/testing/sysfs-power
index b464d12..4d8434b 100644
--- a/Documentation/ABI/testing/sysfs-power
+++ b/Documentation/ABI/testing/sysfs-power
@@ -172,3 +172,46 @@ Description:
 
 		Reading from this file will display the current value, which is
 		set to 1 MB by default.
+
+What:		/sys/power/devfreq/
+Date:		May 2011
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		The /sys/power/devfreq directory will contain files that will
+		provide a unified interface to the DEVFREQ, a generic DVFS
+		(dynamic voltage and frequency scaling) framework.
+
+What:		/sys/power/devfreq/tickle_all
+Date:		May 2011
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		The /sys/power/devfreq/tickle_all file allows user space to
+		force every device with DEVFREQ to operate at the maximum
+		frequency of the device instaneously and temporarily. After
+		a designated delay has passed, the operating frequency returns
+		to normal. If a user reads the tickle_all entry, it returns
+		the number of tickle_all executions. When writing to the
+		tickle_all entry, the user should supply with the duration of
+		tickle in ms (the "designated delay" mentioned before). Then,
+		the effect of tickle_all will hold for the denoted duration.
+		Note that the duration is rounded by the monitoring period
+		defined by DEVFREQ_INTERVAL in /drivers/base/power/devfreq.c.
+
+What:		/sys/power/devfreq/min_interval
+Date:		May 2011
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		The /sys/power/devfreq/min_interval file shows the monitoring
+		period defined by DEVFREQ_INTERVAL in
+		/drivers/base/power/devfreq.c. The duration of device tickling
+		is rounded-up by DEVFREQ_INTERVAL.
+
+What:		/sys/power/devfreq/monitoring
+Date:		May 2011
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		The /sys/power/devfreq/monitoring file shows whether DEVFREQ
+		is periodically monitoring. Periodic monitoring is activated
+		if there is a device that wants periodic monitoring for DVFS or
+		there is a device that is tickled (and the tickling duration is
+		not yet expired).
diff --git a/drivers/base/power/devfreq.c b/drivers/base/power/devfreq.c
index 7648a94..709c138 100644
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
@@ -237,6 +240,8 @@ int devfreq_add_device(struct device *dev, struct devfreq_dev_profile *profile,
 		queue_delayed_work(devfreq_wq, &devfreq_work,
 				   msecs_to_jiffies(DEVFREQ_INTERVAL));
 	}
+
+	sysfs_update_group(&dev->kobj, &dev_attr_group);
 out:
 	mutex_unlock(&devfreq_list_lock);
 
@@ -263,6 +268,8 @@ int devfreq_remove_device(struct device *dev)
 		return -EINVAL;
 	}
 
+	sysfs_remove_group(&dev->kobj, &dev_attr_group);
+
 	list_del(&devfreq->node);
 
 	kfree(devfreq);
@@ -344,7 +351,7 @@ static int _devfreq_tickle_device(struct devfreq *df, unsigned long delay)
 	if (devfreq_wq && !polling) {
 		polling = true;
 		queue_delayed_work(devfreq_wq, &devfreq_work,
-				msecs_to_jiffies(DEVFREQ_INTERVAL));
+				   msecs_to_jiffies(DEVFREQ_INTERVAL));
 	}
 
 	return err;
@@ -382,6 +389,116 @@ int devfreq_tickle_device(struct device *dev, unsigned long duration_ms)
 	return err;
 }
 
+static int num_tickle_all;
+static ssize_t tickle_all(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t count)
+{
+	int duration = 0;
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
+	}
+
+	delay = DIV_ROUND_UP(duration, DEVFREQ_INTERVAL);
+
+	mutex_lock(&devfreq_list_lock);
+	list_for_each_entry(tmp, &devfreq_list, node) {
+		_devfreq_tickle_device(tmp, delay);
+	}
+	mutex_unlock(&devfreq_list_lock);
+
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
+	.name	= NULL,
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
+	}
+
+	delay = DIV_ROUND_UP(duration, DEVFREQ_INTERVAL);
+
+	mutex_lock(&devfreq_list_lock);
+	df = find_device_devfreq(dev);
+	_devfreq_tickle_device(df, delay);
+	mutex_unlock(&devfreq_list_lock);
+
+	return count;
+}
+
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
+	.name	= "devfreq",
+	.attrs	= dev_entries,
+};
+
 static int __init devfreq_init(void)
 {
 	mutex_lock(&devfreq_list_lock);
@@ -389,6 +506,20 @@ static int __init devfreq_init(void)
 	polling = false;
 	devfreq_wq = create_freezable_workqueue("devfreq_wq");
 	INIT_DELAYED_WORK_DEFERRABLE(&devfreq_work, devfreq_monitor);
+
+#ifdef CONFIG_PM
+	/* Create sysfs */
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
index 1ec9a40..69334e7 100644
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

