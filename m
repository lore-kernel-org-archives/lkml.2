Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab1I2MTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 08:19:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34538 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab1I2MSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 08:18:46 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-94-4e8462252d57
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@suse.de>, Kevin Hilman <khilman@ti.com>,
        Nishanth Menon <nm@ti.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Colin Cross <ccross@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@ti.com>, myungjoo.ham@gmail.com
Subject: [PATCH v13 4/4] PM / devfreq: add basic governors
Date: Thu, 29 Sep 2011 21:18:50 +0900
Message-id: <1317298730-10442-5-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1317298730-10442-1-git-send-email-myungjoo.ham@samsung.com>
References: <1317298730-10442-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 29 Sep 2011 12:18:42.0868 (UTC)
 FILETIME=[EDA3EF40:01CC7EA1]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Four cpufreq-like governors are provided as examples.

powersave: use the lowest frequency possible. The user (device) should
set the polling_ms as 0 because polling is useless for this governor.

performance: use the highest freqeuncy possible. The user (device)
should set the polling_ms as 0 because polling is useless for this
governor.

userspace: use the user specified frequency stored at
devfreq.user_set_freq. With sysfs support in the following patch, a user
may set the value with the sysfs interface.

simple_ondemand: simplified version of cpufreq's ondemand governor.

When a user updates OPP entries (enable/disable/add), OPP framework
automatically notifies devfreq to update operating frequency
accordingly. Thus, devfreq users (device drivers) do not need to update
devfreq manually with OPP entry updates or set polling_ms for powersave
, performance, userspace, or any other "static" governors.

Note that these are given only as basic examples for governors and any
devices with devfreq may implement their own governors with the drivers
and use them.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Mike Turquette <mturquette@ti.com>
Acked-by: Kevin Hilman <khilman@ti.com>

---
Changed from v10
- Reworded comments

Changed from v9
- Modified according to the changes in the devfreq core.

Changed from v8
- Removed unnecessary header entries

Changed from v7
- Userspace uses its own sysfs interface.

Changed from v5
- Seperated governor files from devfreq.c
- Allow simple ondemand to be tuned for each device
---
 Documentation/ABI/testing/sysfs-class-devfreq |    8 ++
 drivers/devfreq/Kconfig                       |   36 ++++++++
 drivers/devfreq/Makefile                      |    4 +
 drivers/devfreq/governor_performance.c        |   29 ++++++
 drivers/devfreq/governor_powersave.c          |   29 ++++++
 drivers/devfreq/governor_simpleondemand.c     |   88 +++++++++++++++++++
 drivers/devfreq/governor_userspace.c          |  116 +++++++++++++++++++++++++
 include/linux/devfreq.h                       |   35 ++++++++
 8 files changed, 345 insertions(+), 0 deletions(-)
 create mode 100644 drivers/devfreq/governor_performance.c
 create mode 100644 drivers/devfreq/governor_powersave.c
 create mode 100644 drivers/devfreq/governor_simpleondemand.c
 create mode 100644 drivers/devfreq/governor_userspace.c

diff --git a/Documentation/ABI/testing/sysfs-class-devfreq b/Documentation/ABI/testing/sysfs-class-devfreq
index 0ec855f..23d78b5 100644
--- a/Documentation/ABI/testing/sysfs-class-devfreq
+++ b/Documentation/ABI/testing/sysfs-class-devfreq
@@ -42,3 +42,11 @@ Description:
 		devfreq-provided central polling
 		(/sys/class/devfreq/.../central_polling is 0), this value
 		may be useless.
+
+What:		/sys/class/devfreq/.../userspace/set_freq
+Date:		September 2011
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		The /sys/class/devfreq/.../userspace/set_freq shows and
+		sets the requested frequency for the devfreq object if
+		userspace governor is in effect.
diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index 1fb42de..643b055 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -34,6 +34,42 @@ menuconfig PM_DEVFREQ
 
 if PM_DEVFREQ
 
+comment "DEVFREQ Governors"
+
+config DEVFREQ_GOV_SIMPLE_ONDEMAND
+	bool "Simple Ondemand"
+	help
+	  Chooses frequency based on the recent load on the device. Works
+	  similar as ONDEMAND governor of CPUFREQ does. A device with
+	  Simple-Ondemand should be able to provide busy/total counter
+	  values that imply the usage rate. A device may provide tuned
+	  values to the governor with data field at devfreq_add_device().
+
+config DEVFREQ_GOV_PERFORMANCE
+	bool "Performance"
+	help
+	  Sets the frequency at the maximum available frequency.
+	  This governor always returns UINT_MAX as frequency so that
+	  the DEVFREQ framework returns the highest frequency available
+	  at any time.
+
+config DEVFREQ_GOV_POWERSAVE
+	bool "Powersave"
+	help
+	  Sets the frequency at the minimum available frequency.
+	  This governor always returns 0 as frequency so that
+	  the DEVFREQ framework returns the lowest frequency available
+	  at any time.
+
+config DEVFREQ_GOV_USERSPACE
+	bool "Userspace"
+	help
+	  Sets the frequency at the user specified one.
+	  This governor returns the user configured frequency if there
+	  has been an input to /sys/devices/.../power/devfreq_set_freq.
+	  Otherwise, the governor does not change the frequnecy
+	  given at the initialization.
+
 comment "DEVFREQ Drivers"
 
 endif # PM_DEVFREQ
diff --git a/drivers/devfreq/Makefile b/drivers/devfreq/Makefile
index 168934a..4564a89 100644
--- a/drivers/devfreq/Makefile
+++ b/drivers/devfreq/Makefile
@@ -1 +1,5 @@
 obj-$(CONFIG_PM_DEVFREQ)	+= devfreq.o
+obj-$(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)	+= governor_simpleondemand.o
+obj-$(CONFIG_DEVFREQ_GOV_PERFORMANCE)	+= governor_performance.o
+obj-$(CONFIG_DEVFREQ_GOV_POWERSAVE)	+= governor_powersave.o
+obj-$(CONFIG_DEVFREQ_GOV_USERSPACE)	+= governor_userspace.o
diff --git a/drivers/devfreq/governor_performance.c b/drivers/devfreq/governor_performance.c
new file mode 100644
index 0000000..c0596b2
--- /dev/null
+++ b/drivers/devfreq/governor_performance.c
@@ -0,0 +1,29 @@
+/*
+ *  linux/drivers/devfreq/governor_performance.c
+ *
+ *  Copyright (C) 2011 Samsung Electronics
+ *	MyungJoo Ham <myungjoo.ham@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/devfreq.h>
+
+static int devfreq_performance_func(struct devfreq *df,
+				    unsigned long *freq)
+{
+	/*
+	 * target callback should be able to get floor value as
+	 * said in devfreq.h
+	 */
+	*freq = UINT_MAX;
+	return 0;
+}
+
+const struct devfreq_governor devfreq_performance = {
+	.name = "performance",
+	.get_target_freq = devfreq_performance_func,
+	.no_central_polling = true,
+};
diff --git a/drivers/devfreq/governor_powersave.c b/drivers/devfreq/governor_powersave.c
new file mode 100644
index 0000000..2483a85
--- /dev/null
+++ b/drivers/devfreq/governor_powersave.c
@@ -0,0 +1,29 @@
+/*
+ *  linux/drivers/devfreq/governor_powersave.c
+ *
+ *  Copyright (C) 2011 Samsung Electronics
+ *	MyungJoo Ham <myungjoo.ham@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/devfreq.h>
+
+static int devfreq_powersave_func(struct devfreq *df,
+				  unsigned long *freq)
+{
+	/*
+	 * target callback should be able to get ceiling value as
+	 * said in devfreq.h
+	 */
+	*freq = 0;
+	return 0;
+}
+
+const struct devfreq_governor devfreq_powersave = {
+	.name = "powersave",
+	.get_target_freq = devfreq_powersave_func,
+	.no_central_polling = true,
+};
diff --git a/drivers/devfreq/governor_simpleondemand.c b/drivers/devfreq/governor_simpleondemand.c
new file mode 100644
index 0000000..efad8dc
--- /dev/null
+++ b/drivers/devfreq/governor_simpleondemand.c
@@ -0,0 +1,88 @@
+/*
+ *  linux/drivers/devfreq/governor_simpleondemand.c
+ *
+ *  Copyright (C) 2011 Samsung Electronics
+ *	MyungJoo Ham <myungjoo.ham@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/errno.h>
+#include <linux/devfreq.h>
+#include <linux/math64.h>
+
+/* Default constants for DevFreq-Simple-Ondemand (DFSO) */
+#define DFSO_UPTHRESHOLD	(90)
+#define DFSO_DOWNDIFFERENCTIAL	(5)
+static int devfreq_simple_ondemand_func(struct devfreq *df,
+					unsigned long *freq)
+{
+	struct devfreq_dev_status stat;
+	int err = df->profile->get_dev_status(df->dev.parent, &stat);
+	unsigned long long a, b;
+	unsigned int dfso_upthreshold = DFSO_UPTHRESHOLD;
+	unsigned int dfso_downdifferential = DFSO_DOWNDIFFERENCTIAL;
+	struct devfreq_simple_ondemand_data *data = df->data;
+
+	if (err)
+		return err;
+
+	if (data) {
+		if (data->upthreshold)
+			dfso_upthreshold = data->upthreshold;
+		if (data->downdifferential)
+			dfso_downdifferential = data->downdifferential;
+	}
+	if (dfso_upthreshold > 100 ||
+	    dfso_upthreshold < dfso_downdifferential)
+		return -EINVAL;
+
+	/* Assume MAX if it is going to be divided by zero */
+	if (stat.total_time == 0) {
+		*freq = UINT_MAX;
+		return 0;
+	}
+
+	/* Prevent overflow */
+	if (stat.busy_time >= (1 << 24) || stat.total_time >= (1 << 24)) {
+		stat.busy_time >>= 7;
+		stat.total_time >>= 7;
+	}
+
+	/* Set MAX if it's busy enough */
+	if (stat.busy_time * 100 >
+	    stat.total_time * dfso_upthreshold) {
+		*freq = UINT_MAX;
+		return 0;
+	}
+
+	/* Set MAX if we do not know the initial frequency */
+	if (stat.current_frequency == 0) {
+		*freq = UINT_MAX;
+		return 0;
+	}
+
+	/* Keep the current frequency */
+	if (stat.busy_time * 100 >
+	    stat.total_time * (dfso_upthreshold - dfso_downdifferential)) {
+		*freq = stat.current_frequency;
+		return 0;
+	}
+
+	/* Set the desired frequency based on the load */
+	a = stat.busy_time;
+	a *= stat.current_frequency;
+	b = div_u64(a, stat.total_time);
+	b *= 100;
+	b = div_u64(b, (dfso_upthreshold - dfso_downdifferential / 2));
+	*freq = (unsigned long) b;
+
+	return 0;
+}
+
+const struct devfreq_governor devfreq_simple_ondemand = {
+	.name = "simple_ondemand",
+	.get_target_freq = devfreq_simple_ondemand_func,
+};
diff --git a/drivers/devfreq/governor_userspace.c b/drivers/devfreq/governor_userspace.c
new file mode 100644
index 0000000..4f8b563
--- /dev/null
+++ b/drivers/devfreq/governor_userspace.c
@@ -0,0 +1,116 @@
+/*
+ *  linux/drivers/devfreq/governor_simpleondemand.c
+ *
+ *  Copyright (C) 2011 Samsung Electronics
+ *	MyungJoo Ham <myungjoo.ham@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/devfreq.h>
+#include <linux/pm.h>
+#include <linux/mutex.h>
+#include "governor.h"
+
+struct userspace_data {
+	unsigned long user_frequency;
+	bool valid;
+};
+
+static int devfreq_userspace_func(struct devfreq *df, unsigned long *freq)
+{
+	struct userspace_data *data = df->data;
+
+	if (!data->valid)
+		*freq = df->previous_freq; /* No user freq specified yet */
+	else
+		*freq = data->user_frequency;
+	return 0;
+}
+
+static ssize_t store_freq(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t count)
+{
+	struct devfreq *devfreq = to_devfreq(dev);
+	struct userspace_data *data;
+	unsigned long wanted;
+	int err = 0;
+
+
+	mutex_lock(&devfreq->lock);
+	data = devfreq->data;
+
+	sscanf(buf, "%lu", &wanted);
+	data->user_frequency = wanted;
+	data->valid = true;
+	err = update_devfreq(devfreq);
+	if (err == 0)
+		err = count;
+	mutex_unlock(&devfreq->lock);
+	return err;
+}
+
+static ssize_t show_freq(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct devfreq *devfreq = to_devfreq(dev);
+	struct userspace_data *data;
+	int err = 0;
+
+	mutex_lock(&devfreq->lock);
+	data = devfreq->data;
+
+	if (data->valid)
+		err = sprintf(buf, "%lu\n", data->user_frequency);
+	else
+		err = sprintf(buf, "undefined\n");
+	mutex_unlock(&devfreq->lock);
+	return err;
+}
+
+static DEVICE_ATTR(set_freq, 0644, show_freq, store_freq);
+static struct attribute *dev_entries[] = {
+	&dev_attr_set_freq.attr,
+	NULL,
+};
+static struct attribute_group dev_attr_group = {
+	.name	= "userspace",
+	.attrs	= dev_entries,
+};
+
+static int userspace_init(struct devfreq *devfreq)
+{
+	int err = 0;
+	struct userspace_data *data = kzalloc(sizeof(struct userspace_data),
+					      GFP_KERNEL);
+
+	if (!data) {
+		err = -ENOMEM;
+		goto out;
+	}
+	data->valid = false;
+	devfreq->data = data;
+
+	err = sysfs_create_group(&devfreq->dev.kobj, &dev_attr_group);
+out:
+	return err;
+}
+
+static void userspace_exit(struct devfreq *devfreq)
+{
+	sysfs_remove_group(&devfreq->dev.kobj, &dev_attr_group);
+	kfree(devfreq->data);
+	devfreq->data = NULL;
+}
+
+const struct devfreq_governor devfreq_userspace = {
+	.name = "userspace",
+	.get_target_freq = devfreq_userspace_func,
+	.init = userspace_init,
+	.exit = userspace_exit,
+	.no_central_polling = true,
+};
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index b3be3d3..afb9458 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -166,6 +166,36 @@ extern int devfreq_register_opp_notifier(struct device *dev,
 extern int devfreq_unregister_opp_notifier(struct device *dev,
 					   struct devfreq *devfreq);
 
+#ifdef CONFIG_DEVFREQ_GOV_POWERSAVE
+extern const struct devfreq_governor devfreq_powersave;
+#endif
+#ifdef CONFIG_DEVFREQ_GOV_PERFORMANCE
+extern const struct devfreq_governor devfreq_performance;
+#endif
+#ifdef CONFIG_DEVFREQ_GOV_USERSPACE
+extern const struct devfreq_governor devfreq_userspace;
+#endif
+#ifdef CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND
+extern const struct devfreq_governor devfreq_simple_ondemand;
+/**
+ * struct devfreq_simple_ondemand_data - void *data fed to struct devfreq
+ *	and devfreq_add_device
+ * @ upthreshold	If the load is over this value, the frequency jumps.
+ *			Specify 0 to use the default. Valid value = 0 to 100.
+ * @ downdifferential	If the load is under upthreshold - downdifferential,
+ *			the governor may consider slowing the frequency down.
+ *			Specify 0 to use the default. Valid value = 0 to 100.
+ *			downdifferential < upthreshold must hold.
+ *
+ * If the fed devfreq_simple_ondemand_data pointer is NULL to the governor,
+ * the governor uses the default values.
+ */
+struct devfreq_simple_ondemand_data {
+	unsigned int upthreshold;
+	unsigned int downdifferential;
+};
+#endif
+
 #else /* !CONFIG_PM_DEVFREQ */
 static struct devfreq *devfreq_add_device(struct device *dev,
 					  struct devfreq_dev_profile *profile,
@@ -198,6 +228,11 @@ static int devfreq_unregister_opp_notifier(struct device *dev,
 	return -EINVAL;
 }
 
+#define devfreq_powersave	NULL
+#define devfreq_performance	NULL
+#define devfreq_userspace	NULL
+#define devfreq_simple_ondemand	NULL
+
 #endif /* CONFIG_PM_DEVFREQ */
 
 #endif /* __LINUX_DEVFREQ_H__ */
-- 
1.7.4.1

