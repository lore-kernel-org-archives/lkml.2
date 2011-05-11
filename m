Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab1EKQJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:09:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55100 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab1EKQJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:09:18 -0400
X-AuditID: cbfee61b-b7bb4ae000002c54-ab-4dca41b37048
Date: Wed, 11 May 2011 16:58:41 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 1/3] PM: Introduce DEVFREQ: generic DVFS framework with
 device-specific OPPs
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mark Brown <broonie@sirena.org.uk>, Jiejing Zhang <kzjeef@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Colin Cross <ccross@google.com>,
        Nishanth Menon <nm@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, myungjoo.ham@gmail.com
Message-id: <1305100723-29161-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 11 May 2011 07:58:43.0629 (UTC)
 FILETIME=[3F8635D0:01CC0FB1]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With OPPs, a device may have multiple operable frequency and voltage
sets. However, there can be multiple possible operable sets and a system
will need to choose one from them. In order to reduce the power
consumption (by reducing frequency and voltage) without affecting the
performance too much, a Dynamic Voltage and Frequency Scaling (DVFS)
scheme may be used.

This patch introduces the DVFS capability to non-CPU devices with OPPs.
DVFS is a techique whereby the frequency and supplied voltage of a
device is adjusted on-the-fly. DVFS usually sets the frequency as low
as possible with given conditions (such as QoS assurance) and adjusts
voltage according to the chosen frequency in order to reduce power
consumption and heat dissipation.

The generic DVFS for devices, DEVFREQ, may appear quite similar with
/drivers/cpufreq.  However, CPUFREQ does not allow to have multiple
devices registered and is not suitable to have multiple heterogenous
devices with different (but simple) governors.

Normally, DVFS mechanism controls frequency based on the demand for
the device, and then, chooses voltage based on the chosen frequency.
DEVFREQ also controls the frequency based on the governor's frequency
recommendation and let OPP pick up the pair of frequency and voltage
based on the recommended frequency. Then, the chosen OPP is passed to
device driver's "target" callback.

Tested with Exynos4-NURI board.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

--
Thank you for your valuable comments, Rafael, Greg, Pavel, and Colin.

Changes from v1(RFC)
- Rename: DVFS --> DEVFREQ
- Revised governor design
    . Governor receives the whole struct devfreq
    . Governor should gather usage information (thru get_dev_status)
itself
- Periodic monitoring runs only when needed.
- DEVFREQ no more deals with voltage information directly
- Removed some printks.
- Some cosmetics update
- Use freezable_wq.
---
 drivers/base/power/Makefile  |    1 +
 drivers/base/power/devfreq.c |  353 ++++++++++++++++++++++++++++++++++++++++++
 drivers/base/power/opp.c     |    6 +
 include/linux/devfreq.h      |  108 +++++++++++++
 kernel/power/Kconfig         |   25 +++
 5 files changed, 493 insertions(+), 0 deletions(-)
 create mode 100644 drivers/base/power/devfreq.c
 create mode 100644 include/linux/devfreq.h

diff --git a/drivers/base/power/Makefile b/drivers/base/power/Makefile
index 118c1b9..d7f0ad7 100644
--- a/drivers/base/power/Makefile
+++ b/drivers/base/power/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_PM_SLEEP)	+= main.o wakeup.o
 obj-$(CONFIG_PM_RUNTIME)	+= runtime.o
 obj-$(CONFIG_PM_TRACE_RTC)	+= trace.o
 obj-$(CONFIG_PM_OPP)	+= opp.o
+obj-$(CONFIG_PM_DEVFREQ)	+= devfreq.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
 ccflags-$(CONFIG_PM_VERBOSE)   += -DDEBUG
diff --git a/drivers/base/power/devfreq.c b/drivers/base/power/devfreq.c
new file mode 100644
index 0000000..8e2e45b
--- /dev/null
+++ b/drivers/base/power/devfreq.c
@@ -0,0 +1,353 @@
+/*
+ * DEVFREQ: Generic Dynamic Voltage and Frequency Scaling (DVFS) Framework
+ *	    for Non-CPU Devices Based on OPP.
+ *
+ * Copyright (C) 2011 Samsung Electronics
+ *	MyungJoo Ham <myungjoo.ham@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/opp.h>
+#include <linux/devfreq.h>
+#include <linux/workqueue.h>
+#include <linux/platform_device.h>
+#include <linux/list.h>
+#include <linux/printk.h>
+
+/*
+ * DEVFREQ Monitoring Interval in ms.
+ * It is recommended to be "jiffy_in_ms" * n, where n is an integer >= 1.
+ */
+#define DEVFREQ_INTERVAL	20
+
+/*
+ * devfreq_work periodically (given by DEVFREQ_INTERVAL) monitors every
+ * registered device.
+ */
+static bool monitoring;
+static struct workqueue_struct *devfreq_wq;
+static struct delayed_work devfreq_work;
+/* The list of all device-devfreq */
+static LIST_HEAD(devfreq_list);
+/* Exclusive access to devfreq_list and its elements */
+static DEFINE_MUTEX(devfreq_list_lock);
+
+/**
+ * find_device_devfreq() - find devfreq struct using device pointer
+ * @dev:	device pointer used to lookup device DEVFREQ.
+ *
+ * Search the list of device DEVFREQs and return the matched device's
+ * DEVFREQ info.
+ */
+static struct devfreq *find_device_devfreq(struct device *dev)
+{
+	struct devfreq *tmp_devfreq, *devfreq = ERR_PTR(-ENODEV);
+
+	if (unlikely(IS_ERR_OR_NULL(dev))) {
+		pr_err("%s: Invalid parameters\n", __func__);
+		return ERR_PTR(-EINVAL);
+	}
+
+	list_for_each_entry(tmp_devfreq, &devfreq_list, node) {
+		if (tmp_devfreq->dev == dev) {
+			devfreq = tmp_devfreq;
+			break;
+		}
+	}
+
+	return devfreq;
+}
+
+#define dev_dbg_once(dev, fmt, ...)				\
+	if (!once) {						\
+		once = 1;					\
+		dev_dbg(dev, pr_fmt(fmt), ##__VA_ARGS__);	\
+	}
+/**
+ * devfreq_do() - Check the usage profile of a given device and configure
+ *		frequency and voltage accordingly
+ * @devfreq:	DEVFREQ info of the given device
+ */
+static int devfreq_do(struct devfreq *devfreq)
+{
+	struct opp *opp;
+	unsigned long freq;
+	int err;
+	static int once;
+
+	err = devfreq->governor->get_target_freq(devfreq, &freq);
+	if (err) {
+		dev_dbg_once(devfreq->dev, "%s: get_target_freq error(%d)\n",
+			     __func__, err);
+		return err;
+	}
+
+	opp = opp_find_freq_ceil(devfreq->dev, &freq);
+	if (opp == ERR_PTR(-ENODEV))
+		opp = opp_find_freq_floor(devfreq->dev, &freq);
+
+	if (IS_ERR(opp)) {
+		dev_dbg_once(devfreq->dev, "%s: Cannot find opp with %luHz.\n",
+			     __func__, freq);
+		return PTR_ERR(opp);
+	}
+
+	freq = opp_get_freq(opp);
+	if (devfreq->previous_freq != freq) {
+		err = devfreq->profile->target(devfreq->dev, opp);
+		if (!err)
+			devfreq->previous_freq = freq;
+	}
+
+	if (err)
+		dev_dbg_once(devfreq->dev, "%s: Cannot set %luHz/%luuV\n",
+			     __func__, opp_get_freq(opp), opp_get_voltage(opp));
+	return err;
+}
+
+/**
+ * devfreq_monitor() - Regularly run devfreq_do() and support device DEVFREQ tickle.
+ * @work: the work struct used to run devfreq_monitor periodically.
+ */
+static void devfreq_monitor(struct work_struct *work)
+{
+	struct devfreq *devfreq;
+	int error;
+	int reserved = 0;
+	static int once;
+
+	mutex_lock(&devfreq_list_lock);
+
+	list_for_each_entry(devfreq, &devfreq_list, node) {
+		if (devfreq->next_polling == 0)
+			continue;
+
+		reserved++;
+
+		if (devfreq->tickle) {
+			devfreq->tickle--;
+			continue;
+		}
+		if (devfreq->next_polling == 1) {
+			error = devfreq_do(devfreq);
+			if (error && !once) {
+				once = 1;
+				dev_err(devfreq->dev, "devfreq_do error(%d)\n",
+					error);
+			}
+			devfreq->next_polling = DIV_ROUND_UP(
+						devfreq->profile->polling_ms,
+						DEVFREQ_INTERVAL);
+		} else {
+			devfreq->next_polling--;
+		}
+	}
+
+	if (reserved) {
+		monitoring = true;
+		queue_delayed_work(devfreq_wq, &devfreq_work,
+				   msecs_to_jiffies(DEVFREQ_INTERVAL));
+	} else {
+		monitoring = false;
+	}
+
+	mutex_unlock(&devfreq_list_lock);
+}
+
+/**
+ * devfreq_add_device() - Add devfreq feature to the device
+ * @dev:	the device to add devfreq feature.
+ * @profile:	device-specific profile to run devfreq.
+ * @governor:	the policy to choose frequency.
+ */
+int devfreq_add_device(struct device *dev, struct devfreq_dev_profile *profile,
+		       struct devfreq_governor *governor)
+{
+	struct devfreq *new_devfreq, *devfreq;
+	int err = 0;
+
+	if (!dev || !profile || !governor) {
+		dev_err(dev, "%s: Invalid parameters.\n", __func__);
+		return -EINVAL;
+	}
+
+	mutex_lock(&devfreq_list_lock);
+
+	devfreq = find_device_devfreq(dev);
+	if (!IS_ERR(devfreq)) {
+		dev_err(dev, "%s: Unable to create DEVFREQ for the device. "
+			"It already has one.\n", __func__);
+		err = -EINVAL;
+		goto out;
+	}
+
+	new_devfreq = kzalloc(sizeof(struct devfreq), GFP_KERNEL);
+	if (!new_devfreq) {
+		dev_err(dev, "%s: Unable to create DEVFREQ for the device\n",
+			__func__);
+		err = -ENOMEM;
+		goto out;
+	}
+
+	new_devfreq->dev = dev;
+	new_devfreq->profile = profile;
+	new_devfreq->governor = governor;
+	new_devfreq->next_polling = DIV_ROUND_UP(profile->polling_ms,
+						 DEVFREQ_INTERVAL);
+	new_devfreq->previous_freq = profile->initial_freq;
+
+	list_add(&new_devfreq->node, &devfreq_list);
+
+	if (devfreq_wq && new_devfreq->next_polling && !monitoring) {
+		monitoring = true;
+		queue_delayed_work(devfreq_wq, &devfreq_work,
+				   msecs_to_jiffies(DEVFREQ_INTERVAL));
+	}
+out:
+	mutex_unlock(&devfreq_list_lock);
+
+	return err;
+}
+
+/**
+ * devfreq_remove_device() - Remove DEVFREQ feature from a device.
+ * @device:	the device to remove devfreq feature.
+ */
+int devfreq_remove_device(struct device *dev)
+{
+	struct devfreq *devfreq;
+
+	if (!dev)
+		return -EINVAL;
+
+	mutex_lock(&devfreq_list_lock);
+	devfreq = find_device_devfreq(dev);
+	if (IS_ERR(devfreq)) {
+		dev_err(dev, "%s: Unable to find DEVFREQ entry for the device.\n",
+			__func__);
+		mutex_unlock(&devfreq_list_lock);
+		return -EINVAL;
+	}
+
+	list_del(&devfreq->node);
+
+	kfree(devfreq);
+
+	mutex_unlock(&devfreq_list_lock);
+
+	return 0;
+}
+
+/**
+ * devfreq_update() - Notify that the device OPP has been changed.
+ * @dev:	the device whose OPP has been changed.
+ * @may_not_exist:	do not print error message even if the device
+ *			does not have devfreq entry.
+ */
+int devfreq_update(struct device *dev, bool may_not_exist)
+{
+	struct devfreq *devfreq;
+	int err = 0;
+
+	mutex_lock(&devfreq_list_lock);
+
+	devfreq = find_device_devfreq(dev);
+	if (IS_ERR(devfreq)) {
+		if (may_not_exist && PTR_ERR(devfreq) == -EINVAL)
+			goto out;
+
+		err = PTR_ERR(devfreq);
+		goto out;
+	}
+
+	if (devfreq->tickle) {
+		unsigned long freq = devfreq->profile->max_freq;
+		struct opp *opp = opp_find_freq_floor(devfreq->dev, &freq);
+
+		if (!IS_ERR(opp) && devfreq->previous_freq != freq) {
+			err = devfreq->profile->target(devfreq->dev, opp);
+			if (!err)
+				devfreq->previous_freq = opp_get_freq(opp);
+		}
+	} else {
+		err = devfreq_do(devfreq);
+	}
+
+out:
+	mutex_unlock(&devfreq_list_lock);
+	return err;
+}
+
+/**
+ * devfreq_tickle_device() - Guarantee maximum operation speed for a while
+ *			instaneously.
+ * @dev:	the device to be tickled.
+ * @duration_ms:	the duration of tickle effect.
+ *
+ * Tickle sets the device at the maximum frequency instaneously and
+ * the maximum frequency is guaranteed to be used for the given duration.
+ * For faster user reponse time, an input event may tickle a related device
+ * so that the input event does not need to wait for the DEVFREQ to react with
+ * normal interval.
+ */
+int devfreq_tickle_device(struct device *dev, unsigned long duration_ms)
+{
+	struct devfreq *devfreq;
+	struct opp *opp;
+	unsigned long freq;
+	int err = 0;
+
+	mutex_lock(&devfreq_list_lock);
+	devfreq = find_device_devfreq(dev);
+	if (!IS_ERR(devfreq)) {
+		freq = devfreq->profile->max_freq;
+		opp = opp_find_freq_floor(devfreq->dev, &freq);
+		freq = opp_get_freq(opp);
+		if (devfreq->previous_freq != freq) {
+			err = devfreq->profile->target(devfreq->dev, opp);
+			if (!err)
+				devfreq->previous_freq = freq;
+		}
+		if (err)
+			dev_err(dev, "%s: Cannot set frequency.\n", __func__);
+		else
+			devfreq->tickle = DIV_ROUND_UP(duration_ms,
+						       DEVFREQ_INTERVAL);
+	}
+
+	if (devfreq_wq && !monitoring) {
+		monitoring = true;
+		queue_delayed_work(devfreq_wq, &devfreq_work,
+				   msecs_to_jiffies(DEVFREQ_INTERVAL));
+	}
+	mutex_unlock(&devfreq_list_lock);
+
+	if (IS_ERR(devfreq)) {
+		dev_err(dev, "%s: Cannot find devfreq.\n", __func__);
+		err = PTR_ERR(devfreq);
+	}
+
+	return err;
+}
+
+static int __init devfreq_init(void)
+{
+	mutex_lock(&devfreq_list_lock);
+
+	monitoring = false;
+	devfreq_wq = create_freezable_workqueue("devfreq_wq");
+	INIT_DELAYED_WORK_DEFERRABLE(&devfreq_work, devfreq_monitor);
+	mutex_unlock(&devfreq_list_lock);
+
+	devfreq_monitor(&devfreq_work.work);
+	return 0;
+}
+late_initcall(devfreq_init);
diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 56a6899..4b6b995 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -21,6 +21,7 @@
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
 #include <linux/opp.h>
+#include <linux/devfreq.h>
 
 /*
  * Internal data structure organization with the OPP layer library is as
@@ -428,6 +429,8 @@ int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
 	list_add_rcu(&new_opp->node, head);
 	mutex_unlock(&dev_opp_list_lock);
 
+	/* Notify generic dvfs for the change */
+	devfreq_update(dev, true);
 	return 0;
 }
 
@@ -512,6 +515,9 @@ unlock:
 	mutex_unlock(&dev_opp_list_lock);
 out:
 	kfree(new_opp);
+
+	/* Notify generic dvfs for the change */
+	devfreq_update(dev, true);
 	return r;
 }
 
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
new file mode 100644
index 0000000..d08e9f5
--- /dev/null
+++ b/include/linux/devfreq.h
@@ -0,0 +1,108 @@
+/*
+ * DEVFREQ: Generic Dynamic Voltage and Frequency Scaling (DVFS) Framework
+ *	    for Non-CPU Devices Based on OPP.
+ *
+ * Copyright (C) 2011 Samsung Electronics
+ *	MyungJoo Ham <myungjoo.ham@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __LINUX_DEVFREQ_H__
+#define __LINUX_DEVFREQ_H__
+
+struct devfreq;
+struct devfreq_dev_status {
+	/* both since the last measure */
+	unsigned long total_time;
+	unsigned long busy_time;
+	unsigned long current_frequency;
+};
+
+struct devfreq_dev_profile {
+	unsigned long max_freq; /* may be larger than the actual value */
+	unsigned long initial_freq;
+	int polling_ms;	/* 0 for at opp change only */
+
+	int (*target)(struct device *dev, struct opp *opp);
+	int (*get_dev_status)(struct device *dev,
+			      struct devfreq_dev_status *stat);
+};
+
+/**
+ * struct devfreq_governor - DEVFREQ Policy Governor
+ * @data	Governor's internal data. The framework does not care of it.
+ * @get_target_freq	Returns desired operating frequency for the device.
+ *			Basically, get_target_freq will run
+ *			devfreq_dev_profile.get_dev_status() to get the
+ *			status of the device (load = busy_time / total_time).
+ */
+struct devfreq_governor {
+	void *data; /* private data for get_target_freq */
+	int (*get_target_freq)(struct devfreq *this, unsigned long *freq);
+};
+
+/**
+ * struct devfreq - Device DEVFREQ structure
+ * @node	list node - contains the devices with DEVFREQ that have been
+ *		registered.
+ * @dev		device pointer
+ * @profile	device-specific devfreq profile
+ * @governor	method how to choose frequency based on the usage.
+ * @previous_freq	previously configured frequency value.
+ * @next_polling	the number of remaining "devfreq_monitor" executions to
+ *			reevaluate frequency/voltage of the device. Set by
+ *			profile's polling_ms interval.
+ * @tickle	positive if DEVFREQ-tickling is activated for the device.
+ *		at each executino of devfreq_monitor, tickle is decremented.
+ *		User may tickle a device-devfreq in order to set maximum
+ *		frequency instaneously with some guaranteed duration.
+ *
+ * This structure stores the DEVFREQ information for a give device.
+ */
+struct devfreq {
+	struct list_head node;
+
+	struct device *dev;
+	struct devfreq_dev_profile *profile;
+	struct devfreq_governor *governor;
+
+	unsigned long previous_freq;
+	unsigned int next_polling;
+	unsigned int tickle;
+};
+
+#if defined(CONFIG_PM_DEVFREQ)
+extern int devfreq_add_device(struct device *dev,
+			   struct devfreq_dev_profile *profile,
+			   struct devfreq_governor *governor);
+extern int devfreq_remove_device(struct device *dev);
+extern int devfreq_update(struct device *dev, bool may_not_exist);
+extern int devfreq_tickle_device(struct device *dev, unsigned long duration_ms);
+#else /* !CONFIG_PM_DEVFREQ */
+static int devfreq_add_device(struct device *dev,
+			   struct devfreq_dev_profile *profile,
+			   struct devfreq_governor *governor)
+{
+	return 0;
+}
+
+static int devfreq_remove_device(struct device *dev)
+{
+	return 0;
+}
+
+static int devfreq_update(struct device *dev, bool may_not_exist)
+{
+	return 0;
+}
+
+static int devfreq_tickle_device(struct device *dev, unsigned long duration_ms)
+{
+	return 0;
+}
+#endif /* CONFIG_PM_DEVFREQ */
+
+#endif /* __LINUX_DEVFREQ_H__ */
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 4603f08..e5d2e36 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -225,3 +225,28 @@ config PM_OPP
 	  representing individual voltage domains and provides SOC
 	  implementations a ready to use framework to manage OPPs.
 	  For more information, read <file:Documentation/power/opp.txt>
+
+config PM_DEVFREQ
+	bool "Generic Dynamic Voltage and Frequency Scaling (DVFS) Framework"
+	depends on PM_OPP
+	help
+	  With OPP support, a device may have a list of frequencies and
+	  voltages available. DEVFREQ, a generic DVFS framework can be
+	  registered for a device with OPP support in order to let the
+	  governor provided to DEVFREQ choose an operating frequency
+	  based on the OPP's list and the policy given with DEVFREQ.
+
+	  Each device may have its own governor and policy. DEVFREQ can
+	  reevaluate the device state periodically and/or based on the
+	  OPP list changes (each frequency/voltage pair in OPP may be
+	  disabled or enabled).
+
+	  Like some CPUs with CPUFREQ, a device may have multiple clocks.
+	  However, because the clock frequencies of a single device are
+	  determined by the single device's state, an instance of DEVFREQ
+	  is attached to a single device and returns a "representative"
+	  clock frequency from the OPP of the device, which is also attached
+	  to a device by 1-to-1. The device registering DEVFREQ takes the
+	  responsiblity to "interpret" the frequency listed in OPP and
+	  to set its every clock accordingly with the "target" callback
+	  given to DEVFREQ.
-- 
1.7.4.1

