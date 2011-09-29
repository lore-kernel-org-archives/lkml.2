Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab1I2MSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 08:18:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18135 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab1I2MSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 08:18:48 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-88-4e846224c38c
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@suse.de>, Kevin Hilman <khilman@ti.com>,
        Nishanth Menon <nm@ti.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Colin Cross <ccross@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@ti.com>, myungjoo.ham@gmail.com
Subject: [PATCH v13 2/4] PM: Introduce devfreq: generic DVFS framework with
 device-specific OPPs
Date: Thu, 29 Sep 2011 21:18:48 +0900
Message-id: <1317298730-10442-3-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1317298730-10442-1-git-send-email-myungjoo.ham@samsung.com>
References: <1317298730-10442-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 29 Sep 2011 12:18:42.0821 (UTC)
 FILETIME=[ED9CC350:01CC7EA1]
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

The generic DVFS for devices, devfreq, may appear quite similar with
/drivers/cpufreq.  However, cpufreq does not allow to have multiple
devices registered and is not suitable to have multiple heterogenous
devices with different (but simple) governors.

Normally, DVFS mechanism controls frequency based on the demand for
the device, and then, chooses voltage based on the chosen frequency.
devfreq also controls the frequency based on the governor's frequency
recommendation and let OPP pick up the pair of frequency and voltage
based on the recommended frequency. Then, the chosen OPP is passed to
device driver's "target" callback.

When PM QoS is going to be used with the devfreq device, the device
driver should enable OPPs that are appropriate with the current PM QoS
requests. In order to do so, the device driver may call opp_enable and
opp_disable at the notifier callback of PM QoS so that PM QoS's
update_target() call enables the appropriate OPPs. Note that at least
one of OPPs should be enabled at any time; be careful when there is a
transition.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Mike Turquette <mturquette@ti.com>

---
The test code with board support for Exynos4-NURI is at
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/devfreq

---
Thank you for your valuable comments, Rafael, Greg, Pavel, Colin, Mike,
and Kevin.

Changes from v12
- Fixed up kerneldoc comments
- Bugfix of _remove_devfreq() and devfreq_dev_release()

Changes from v11
- Governor name is const.
- Consolidated do_devfreq() and update_devfreq()
- Renamed devfreq_update() -> devfreq_notifier_call()
- Revised devfreq_monitor() loop.

Changes from v10
- Dependency on OPP is removed. For devfreq users with OPP support,
  helper functions are added.
- Bugfix on locking in devfreq_add_device()

Changes from v9
- Devfreq is now a class "devfreq".
- A governor may poll itself (not using devfreq's central polling
  mechanism).
- Some data are set const in order to prevent modification.
- Revised list management
- Removed the need for get_devfreq() and put_devfreq().
- Reduced locking

Changes from v8
- Merged patch 4/5 of v8 (internal interfaces for governors)
- Added lock (mutex) to struct devfreq
- Uses devfreq->lock to access elements in devfreq.
- Added kerneldoc entries for init/exit callbacks of governors.
- The caller of update_devfreq() in governor.h should lock
devfreq->lock before calling it.
- Added comment on the usage of lock in struct devfreq.
- Revised devfreq_add_device error handling

At v8, there is no changes since v7

Changes from v6
- Type revised for timing variables
- Removed unnecessary code and variable

Changes at v6-resubmit from v6
- Use jiffy directly instead of ktime
- Be prepared for profile->polling_ms changes (not supported fully at
  this stage)

Changes from v5
- Uses OPP availability change notifier
- Removed devfreq_interval. Uses one jiffy instead. DEVFREQ adjusts
  polling interval based on the interval requirement of DEVFREQ
  devices.
- Moved devfreq to /drivers/devfreq to accomodate devfreq-related files
  including governors and devfreq drivers.
- Coding style revised.
- Updated devfreq_add_device interface to get tunable values.

Changed from v4
- Removed tickle, which is a duplicated feature; PM QoS can do the same.
- Allow to extend polling interval if devices have longer polling intervals.
- Relocated private data of governors.
- Removed system-wide sysfs

Changed from v3
- In kerneldoc comments, DEVFREQ has ben replaced by devfreq
- Revised removing devfreq entries with error mechanism
- Added and revised comments
- Removed unnecessary codes
- Allow to give a name to a governor
- Bugfix: a tickle call may cancel an older tickle call that is still in
  effect.

Changed from v2
- Code style revised and cleaned up.
- Remove DEVFREQ entries that incur errors except for EAGAIN
- Bug fixed: tickle for devices without polling governors

Changes from v1(RFC)
- Rename: DVFS --> DEVFREQ
- Revised governor design
	. Governor receives the whole struct devfreq
	. Governor should gather usage information (thru get_dev_status) itself
- Periodic monitoring runs only when needed.
- DEVFREQ no more deals with voltage information directly
- Removed some printks.
- Some cosmetics update
- Use freezable_wq.
---
 drivers/Kconfig            |    2 +
 drivers/Makefile           |    2 +
 drivers/devfreq/Kconfig    |   39 ++++
 drivers/devfreq/Makefile   |    1 +
 drivers/devfreq/devfreq.c  |  532 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/devfreq/governor.h |   24 ++
 include/linux/devfreq.h    |  203 +++++++++++++++++
 7 files changed, 803 insertions(+), 0 deletions(-)
 create mode 100644 drivers/devfreq/Kconfig
 create mode 100644 drivers/devfreq/Makefile
 create mode 100644 drivers/devfreq/devfreq.c
 create mode 100644 drivers/devfreq/governor.h
 create mode 100644 include/linux/devfreq.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 95b9e7e..a1efd75 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -130,4 +130,6 @@ source "drivers/iommu/Kconfig"
 
 source "drivers/virt/Kconfig"
 
+source "drivers/devfreq/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 7fa433a..97c957b 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -127,3 +127,5 @@ obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/
 
 # Virtualization drivers
 obj-$(CONFIG_VIRT_DRIVERS)	+= virt/
+
+obj-$(CONFIG_PM_DEVFREQ)	+= devfreq/
diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
new file mode 100644
index 0000000..1fb42de
--- /dev/null
+++ b/drivers/devfreq/Kconfig
@@ -0,0 +1,39 @@
+config ARCH_HAS_DEVFREQ
+	bool
+	depends on ARCH_HAS_OPP
+	help
+	  Denotes that the architecture supports DEVFREQ. If the architecture
+	  supports multiple OPP entries per device and the frequency of the
+	  devices with OPPs may be altered dynamically, the architecture
+	  supports DEVFREQ.
+
+menuconfig PM_DEVFREQ
+	bool "Generic Dynamic Voltage and Frequency Scaling (DVFS) support"
+	depends on PM_OPP && ARCH_HAS_DEVFREQ
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
+
+if PM_DEVFREQ
+
+comment "DEVFREQ Drivers"
+
+endif # PM_DEVFREQ
diff --git a/drivers/devfreq/Makefile b/drivers/devfreq/Makefile
new file mode 100644
index 0000000..168934a
--- /dev/null
+++ b/drivers/devfreq/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_PM_DEVFREQ)	+= devfreq.o
diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
new file mode 100644
index 0000000..8ecab66
--- /dev/null
+++ b/drivers/devfreq/devfreq.c
@@ -0,0 +1,532 @@
+/*
+ * devfreq: Generic Dynamic Voltage and Frequency Scaling (DVFS) Framework
+ *	    for Non-CPU Devices.
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
+#include <linux/sched.h>
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
+#include <linux/hrtimer.h>
+#include "governor.h"
+
+struct class *devfreq_class;
+
+/*
+ * devfreq_work periodically monitors every registered device.
+ * The minimum polling interval is one jiffy. The polling interval is
+ * determined by the minimum polling period among all polling devfreq
+ * devices. The resolution of polling interval is one jiffy.
+ */
+static bool polling;
+static struct workqueue_struct *devfreq_wq;
+static struct delayed_work devfreq_work;
+
+/* wait removing if this is to be removed */
+static struct devfreq *wait_remove_device;
+
+/* The list of all device-devfreq */
+static LIST_HEAD(devfreq_list);
+static DEFINE_MUTEX(devfreq_list_lock);
+
+/**
+ * find_device_devfreq() - find devfreq struct using device pointer
+ * @dev:	device pointer used to lookup device devfreq.
+ *
+ * Search the list of device devfreqs and return the matched device's
+ * devfreq info. devfreq_list_lock should be held by the caller.
+ */
+static struct devfreq *find_device_devfreq(struct device *dev)
+{
+	struct devfreq *tmp_devfreq;
+
+	if (unlikely(IS_ERR_OR_NULL(dev))) {
+		pr_err("DEVFREQ: %s: Invalid parameters\n", __func__);
+		return ERR_PTR(-EINVAL);
+	}
+	WARN(!mutex_is_locked(&devfreq_list_lock),
+	     "devfreq_list_lock must be loced.");
+
+	list_for_each_entry(tmp_devfreq, &devfreq_list, node) {
+		if (tmp_devfreq->dev.parent == dev)
+			return tmp_devfreq;
+	}
+
+	return ERR_PTR(-ENODEV);
+}
+
+/**
+ * update_devfreq() - Reevaluate the device and configure frequency.
+ * @devfreq:	the devfreq instance.
+ *
+ * Note: Lock devfreq->lock before calling update_devfreq
+ *	 This function is exported for governors.
+ */
+int update_devfreq(struct devfreq *devfreq)
+{
+	unsigned long freq;
+	int err = 0;
+
+	if (!mutex_is_locked(&devfreq->lock)) {
+		WARN(true, "devfreq->lock must be locked by the caller.\n");
+		return -EINVAL;
+	}
+
+	/* Reevaluate the proper frequency */
+	err = devfreq->governor->get_target_freq(devfreq, &freq);
+	if (err)
+		return err;
+
+	err = devfreq->profile->target(devfreq->dev.parent, &freq);
+	if (err)
+		return err;
+
+	devfreq->previous_freq = freq;
+	return err;
+}
+
+/**
+ * devfreq_notifier_call() - Notify that the device frequency requirements
+ *			   has been changed out of devfreq framework.
+ * @nb		the notifier_block (supposed to be devfreq->nb)
+ * @type	not used
+ * @devp	not used
+ *
+ * Called by a notifier that uses devfreq->nb.
+ */
+static int devfreq_notifier_call(struct notifier_block *nb, unsigned long type,
+				 void *devp)
+{
+	struct devfreq *devfreq = container_of(nb, struct devfreq, nb);
+	int ret;
+
+	mutex_lock(&devfreq->lock);
+	ret = update_devfreq(devfreq);
+	mutex_unlock(&devfreq->lock);
+
+	return ret;
+}
+
+/**
+ * _remove_devfreq() - Remove devfreq from the device.
+ * @devfreq:	the devfreq struct
+ * @skip:	skip calling device_unregister().
+ *
+ * Note that the caller should lock devfreq->lock before calling
+ * this. _remove_devfreq() will unlock it and free devfreq
+ * internally. devfreq_list_lock should be locked by the caller
+ * as well (not relased at return)
+ *
+ * Lock usage:
+ * devfreq->lock: locked before call.
+ *		  unlocked at return (and freed)
+ * devfreq_list_lock: locked before call.
+ *		      kept locked at return.
+ *		      if devfreq is centrally polled.
+ *
+ * Freed memory:
+ * devfreq
+ */
+static void _remove_devfreq(struct devfreq *devfreq, bool skip)
+{
+	if (!mutex_is_locked(&devfreq->lock)) {
+		WARN(true, "devfreq->lock must be locked by the caller.\n");
+		return;
+	}
+	if (!devfreq->governor->no_central_polling &&
+	    !mutex_is_locked(&devfreq_list_lock)) {
+		WARN(true, "devfreq_list_lock must be locked by the caller.\n");
+		return;
+	}
+
+	if (devfreq->being_removed)
+		return;
+
+	devfreq->being_removed = true;
+
+	if (devfreq->profile->exit)
+		devfreq->profile->exit(devfreq->dev.parent);
+
+	if (devfreq->governor->exit)
+		devfreq->governor->exit(devfreq);
+
+	if (!skip && get_device(&devfreq->dev)) {
+		device_unregister(&devfreq->dev);
+		put_device(&devfreq->dev);
+	}
+
+	if (!devfreq->governor->no_central_polling)
+		list_del(&devfreq->node);
+
+	mutex_unlock(&devfreq->lock);
+	mutex_destroy(&devfreq->lock);
+
+	kfree(devfreq);
+}
+
+/**
+ * devfreq_dev_release() - Callback for struct device to release the device.
+ * @dev:	the devfreq device
+ *
+ * This calls _remove_devfreq() if _remove_devfreq() is not called.
+ * Note that devfreq_dev_release() could be called by _remove_devfreq() as
+ * well as by others unregistering the device.
+ */
+static void devfreq_dev_release(struct device *dev)
+{
+	struct devfreq *devfreq = to_devfreq(dev);
+	bool central_polling = !devfreq->governor->no_central_polling;
+
+	/*
+	 * If devfreq_dev_release() was called by device_unregister() of
+	 * _remove_devfreq(), we cannot mutex_lock(&devfreq->lock) and
+	 * being_removed is already set. This also partially checks the case
+	 * where devfreq_dev_release() is called from a thread other than
+	 * the one called _remove_devfreq(); however, this case is
+	 * dealt completely with another following being_removed check.
+	 *
+	 * Because being_removed is never being
+	 * unset, we do not need to worry about race conditions on
+	 * being_removed.
+	 */
+	if (devfreq->being_removed)
+		return;
+
+	if (central_polling)
+		mutex_lock(&devfreq_list_lock);
+
+	mutex_lock(&devfreq->lock);
+
+	/*
+	 * Check being_removed flag again for the case where
+	 * devfreq_dev_release() was called in a thread other than the one
+	 * possibly called _remove_devfreq().
+	 */
+	if (devfreq->being_removed) {
+		mutex_unlock(&devfreq->lock);
+		goto out;
+	}
+
+	/* devfreq->lock is unlocked and removed in _removed_devfreq() */
+	_remove_devfreq(devfreq, true);
+
+out:
+	if (central_polling)
+		mutex_unlock(&devfreq_list_lock);
+}
+
+/**
+ * devfreq_monitor() - Periodically poll devfreq objects.
+ * @work: the work struct used to run devfreq_monitor periodically.
+ *
+ */
+static void devfreq_monitor(struct work_struct *work)
+{
+	static unsigned long last_polled_at;
+	struct devfreq *devfreq, *tmp;
+	int error;
+	unsigned long jiffies_passed;
+	unsigned long next_jiffies = ULONG_MAX, now = jiffies;
+	struct device *dev;
+
+	/* Initially last_polled_at = 0, polling every device at bootup */
+	jiffies_passed = now - last_polled_at;
+	last_polled_at = now;
+	if (jiffies_passed == 0)
+		jiffies_passed = 1;
+
+	mutex_lock(&devfreq_list_lock);
+	list_for_each_entry_safe(devfreq, tmp, &devfreq_list, node) {
+		mutex_lock(&devfreq->lock);
+		dev = devfreq->dev.parent;
+
+		/* Do not remove tmp for a while */
+		wait_remove_device = tmp;
+
+		if (devfreq->governor->no_central_polling ||
+		    devfreq->next_polling == 0) {
+			mutex_unlock(&devfreq->lock);
+			continue;
+		}
+		mutex_unlock(&devfreq_list_lock);
+
+		/*
+		 * Reduce more next_polling if devfreq_wq took an extra
+		 * delay. (i.e., CPU has been idled.)
+		 */
+		if (devfreq->next_polling <= jiffies_passed) {
+			error = update_devfreq(devfreq);
+
+			/* Remove a devfreq with an error. */
+			if (error && error != -EAGAIN) {
+
+				dev_err(dev, "Due to update_devfreq error(%d), devfreq(%s) is removed from the device\n",
+					error, devfreq->governor->name);
+
+				/*
+				 * Unlock devfreq before locking the list
+				 * in order to avoid deadlock with
+				 * find_device_devfreq or others
+				 */
+				mutex_unlock(&devfreq->lock);
+				mutex_lock(&devfreq_list_lock);
+				/* Check if devfreq is already removed */
+				if (IS_ERR(find_device_devfreq(dev)))
+					continue;
+				mutex_lock(&devfreq->lock);
+				/* This unlocks devfreq->lock and free it */
+				_remove_devfreq(devfreq, false);
+				continue;
+			}
+			devfreq->next_polling = devfreq->polling_jiffies;
+		} else {
+			devfreq->next_polling -= jiffies_passed;
+		}
+
+		if (devfreq->next_polling)
+			next_jiffies = (next_jiffies > devfreq->next_polling) ?
+					devfreq->next_polling : next_jiffies;
+
+		mutex_unlock(&devfreq->lock);
+		mutex_lock(&devfreq_list_lock);
+	}
+	wait_remove_device = NULL;
+	mutex_unlock(&devfreq_list_lock);
+
+	if (next_jiffies > 0 && next_jiffies < ULONG_MAX) {
+		polling = true;
+		queue_delayed_work(devfreq_wq, &devfreq_work, next_jiffies);
+	} else {
+		polling = false;
+	}
+}
+
+/**
+ * devfreq_add_device() - Add devfreq feature to the device
+ * @dev:	the device to add devfreq feature.
+ * @profile:	device-specific profile to run devfreq.
+ * @governor:	the policy to choose frequency.
+ * @data:	private data for the governor. The devfreq framework does not
+ *		touch this value.
+ */
+struct devfreq *devfreq_add_device(struct device *dev,
+				   struct devfreq_dev_profile *profile,
+				   const struct devfreq_governor *governor,
+				   void *data)
+{
+	struct devfreq *devfreq;
+	int err = 0;
+
+	if (!dev || !profile || !governor) {
+		dev_err(dev, "%s: Invalid parameters.\n", __func__);
+		return ERR_PTR(-EINVAL);
+	}
+
+
+	if (!governor->no_central_polling) {
+		mutex_lock(&devfreq_list_lock);
+		devfreq = find_device_devfreq(dev);
+		mutex_unlock(&devfreq_list_lock);
+		if (!IS_ERR(devfreq)) {
+			dev_err(dev, "%s: Unable to create devfreq for the device. It already has one.\n", __func__);
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+	devfreq = kzalloc(sizeof(struct devfreq), GFP_KERNEL);
+	if (!devfreq) {
+		dev_err(dev, "%s: Unable to create devfreq for the device\n",
+			__func__);
+		err = -ENOMEM;
+		goto out;
+	}
+
+	mutex_init(&devfreq->lock);
+	mutex_lock(&devfreq->lock);
+	devfreq->dev.parent = dev;
+	devfreq->dev.class = devfreq_class;
+	devfreq->dev.release = devfreq_dev_release;
+	devfreq->profile = profile;
+	devfreq->governor = governor;
+	devfreq->previous_freq = profile->initial_freq;
+	devfreq->data = data;
+	devfreq->next_polling = devfreq->polling_jiffies
+			      = msecs_to_jiffies(devfreq->profile->polling_ms);
+	devfreq->nb.notifier_call = devfreq_notifier_call;
+
+	dev_set_name(&devfreq->dev, dev_name(dev));
+	err = device_register(&devfreq->dev);
+	if (err) {
+		put_device(&devfreq->dev);
+		goto err_dev;
+	}
+
+	if (governor->init)
+		err = governor->init(devfreq);
+	if (err)
+		goto err_init;
+
+	mutex_unlock(&devfreq->lock);
+
+	if (governor->no_central_polling)
+		goto out;
+
+	mutex_lock(&devfreq_list_lock);
+
+	list_add(&devfreq->node, &devfreq_list);
+
+	if (devfreq_wq && devfreq->next_polling && !polling) {
+		polling = true;
+		queue_delayed_work(devfreq_wq, &devfreq_work,
+				   devfreq->next_polling);
+	}
+	mutex_unlock(&devfreq_list_lock);
+	goto out;
+err_init:
+	device_unregister(&devfreq->dev);
+err_dev:
+	mutex_unlock(&devfreq->lock);
+	kfree(devfreq);
+out:
+	if (err)
+		return ERR_PTR(err);
+	else
+		return devfreq;
+}
+
+/**
+ * devfreq_remove_device() - Remove devfreq feature from a device.
+ * @devfreq	the devfreq instance to be removed
+ */
+int devfreq_remove_device(struct devfreq *devfreq)
+{
+	if (!devfreq)
+		return -EINVAL;
+
+	if (!devfreq->governor->no_central_polling) {
+		mutex_lock(&devfreq_list_lock);
+		while (wait_remove_device == devfreq) {
+			mutex_unlock(&devfreq_list_lock);
+			schedule();
+			mutex_lock(&devfreq_list_lock);
+		}
+	}
+
+	mutex_lock(&devfreq->lock);
+	_remove_devfreq(devfreq, false); /* it unlocks devfreq->lock */
+
+	if (!devfreq->governor->no_central_polling)
+		mutex_unlock(&devfreq_list_lock);
+
+	return 0;
+}
+
+/**
+ * devfreq_start_polling() - Initialize data structure for devfreq framework and
+ *			   start polling registered devfreq devices.
+ */
+static int __init devfreq_start_polling(void)
+{
+	mutex_lock(&devfreq_list_lock);
+	polling = false;
+	devfreq_wq = create_freezable_workqueue("devfreq_wq");
+	INIT_DELAYED_WORK_DEFERRABLE(&devfreq_work, devfreq_monitor);
+	mutex_unlock(&devfreq_list_lock);
+
+	devfreq_monitor(&devfreq_work.work);
+	return 0;
+}
+late_initcall(devfreq_start_polling);
+
+static int __init devfreq_init(void)
+{
+	devfreq_class = class_create(THIS_MODULE, "devfreq");
+	if (IS_ERR(devfreq_class)) {
+		pr_err("%s: couldn't create class\n", __FILE__);
+		return PTR_ERR(devfreq_class);
+	}
+	return 0;
+}
+subsys_initcall(devfreq_init);
+
+static void __exit devfreq_exit(void)
+{
+	class_destroy(devfreq_class);
+}
+module_exit(devfreq_exit);
+
+/*
+ * The followings are helper functions for devfreq user device drivers with
+ * OPP framework.
+ */
+
+/**
+ * devfreq_recommended_opp() - Helper function to get proper OPP for the
+ *			     freq value given to target callback.
+ * @dev		The devfreq user device. (parent of devfreq)
+ * @freq	The frequency given to target function
+ *
+ */
+struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq)
+{
+	struct opp *opp = opp_find_freq_ceil(dev, freq);
+
+	if (opp == ERR_PTR(-ENODEV))
+		opp = opp_find_freq_floor(dev, freq);
+	return opp;
+}
+
+/**
+ * devfreq_register_opp_notifier() - Helper function to get devfreq notified
+ *				   for any changes in the OPP availability
+ *				   changes
+ * @dev		The devfreq user device. (parent of devfreq)
+ * @devfreq	The devfreq object.
+ */
+int devfreq_register_opp_notifier(struct device *dev, struct devfreq *devfreq)
+{
+	struct srcu_notifier_head *nh = opp_get_notifier(dev);
+
+	if (IS_ERR(nh))
+		return PTR_ERR(nh);
+	return srcu_notifier_chain_register(nh, &devfreq->nb);
+}
+
+/**
+ * devfreq_unregister_opp_notifier() - Helper function to stop getting devfreq
+ *				     notified for any changes in the OPP
+ *				     availability changes anymore.
+ * @dev		The devfreq user device. (parent of devfreq)
+ * @devfreq	The devfreq object.
+ *
+ * At exit() callback of devfreq_dev_profile, this must be included if
+ * devfreq_recommended_opp is used.
+ */
+int devfreq_unregister_opp_notifier(struct device *dev, struct devfreq *devfreq)
+{
+	struct srcu_notifier_head *nh = opp_get_notifier(dev);
+
+	if (IS_ERR(nh))
+		return PTR_ERR(nh);
+	return srcu_notifier_chain_unregister(nh, &devfreq->nb);
+}
+
+MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
+MODULE_DESCRIPTION("devfreq class support");
+MODULE_LICENSE("GPL");
diff --git a/drivers/devfreq/governor.h b/drivers/devfreq/governor.h
new file mode 100644
index 0000000..ea7f13c
--- /dev/null
+++ b/drivers/devfreq/governor.h
@@ -0,0 +1,24 @@
+/*
+ * governor.h - internal header for devfreq governors.
+ *
+ * Copyright (C) 2011 Samsung Electronics
+ *	MyungJoo Ham <myungjoo.ham@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This header is for devfreq governors in drivers/devfreq/
+ */
+
+#ifndef _GOVERNOR_H
+#define _GOVERNOR_H
+
+#include <linux/devfreq.h>
+
+#define to_devfreq(DEV)	container_of((DEV), struct devfreq, dev)
+
+/* Caution: devfreq->lock must be locked before calling update_devfreq */
+extern int update_devfreq(struct devfreq *devfreq);
+
+#endif /* _GOVERNOR_H */
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
new file mode 100644
index 0000000..b3be3d3
--- /dev/null
+++ b/include/linux/devfreq.h
@@ -0,0 +1,203 @@
+/*
+ * devfreq: Generic Dynamic Voltage and Frequency Scaling (DVFS) Framework
+ *	    for Non-CPU Devices.
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
+#include <linux/device.h>
+#include <linux/notifier.h>
+#include <linux/opp.h>
+
+#define DEVFREQ_NAME_LEN 16
+
+struct devfreq;
+
+/**
+ * struct devfreq_dev_status - Data given from devfreq user device to
+ *			     governors. Represents the performance
+ *			     statistics.
+ * @total_time		The total time represented by this instance of
+ *			devfreq_dev_status
+ * @busy_time		The time that the device was working among the
+ *			total_time.
+ * @current_frequency	The operating frequency.
+ * @private_data	An entry not specified by the devfreq framework.
+ *			A device and a specific governor may have their
+ *			own protocol with private_data. However, because
+ *			this is governor-specific, a governor using this
+ *			will be only compatible with devices aware of it.
+ */
+struct devfreq_dev_status {
+	/* both since the last measure */
+	unsigned long total_time;
+	unsigned long busy_time;
+	unsigned long current_frequency;
+	void *private_date;
+};
+
+/**
+ * struct devfreq_dev_profile - Devfreq's user device profile
+ * @initial_freq	The operating frequency when devfreq_add_device() is
+ *			called.
+ * @polling_ms		The polling interval in ms. 0 disables polling.
+ * @target		The device should set its operating frequency at
+ *			freq or lowest-upper-than-freq value. If freq is
+ *			higher than any operable frequency, set maximum.
+ *			Before returning, target function should set
+ *			freq at the current frequency.
+ * @get_dev_status	The device should provide the current performance
+ *			status to devfreq, which is used by governors.
+ * @exit		An optional callback that is called when devfreq
+ *			is removing the devfreq object due to error or
+ *			from devfreq_remove_device() call. If the user
+ *			has registered devfreq->nb at a notifier-head,
+ *			this is the time to unregister it.
+ */
+struct devfreq_dev_profile {
+	unsigned long initial_freq;
+	unsigned int polling_ms;
+
+	int (*target)(struct device *dev, unsigned long *freq);
+	int (*get_dev_status)(struct device *dev,
+			      struct devfreq_dev_status *stat);
+	void (*exit)(struct device *dev);
+};
+
+/**
+ * struct devfreq_governor - Devfreq policy governor
+ * @name		Governor's name
+ * @get_target_freq	Returns desired operating frequency for the device.
+ *			Basically, get_target_freq will run
+ *			devfreq_dev_profile.get_dev_status() to get the
+ *			status of the device (load = busy_time / total_time).
+ *			If no_central_polling is set, this callback is called
+ *			only with update_devfreq() notified by OPP.
+ * @init		Called when the devfreq is being attached to a device
+ * @exit		Called when the devfreq is being removed from a
+ *			device. Governor should stop any internal routines
+ *			before return because related data may be
+ *			freed after exit().
+ * @no_central_polling	Do not use devfreq's central polling mechanism.
+ *			When this is set, devfreq will not call
+ *			get_target_freq with devfreq_monitor(). However,
+ *			devfreq will call get_target_freq with
+ *			devfreq_update() notified by OPP framework.
+ *
+ * Note that the callbacks are called with devfreq->lock locked by devfreq.
+ */
+struct devfreq_governor {
+	const char name[DEVFREQ_NAME_LEN];
+	int (*get_target_freq)(struct devfreq *this, unsigned long *freq);
+	int (*init)(struct devfreq *this);
+	void (*exit)(struct devfreq *this);
+	const bool no_central_polling;
+};
+
+/**
+ * struct devfreq - Device devfreq structure
+ * @node	list node - contains the devices with devfreq that have been
+ *		registered.
+ * @lock	a mutex to protect accessing devfreq.
+ * @dev		device registered by devfreq class. dev.parent is the device
+ *		using devfreq.
+ * @profile	device-specific devfreq profile
+ * @governor	method how to choose frequency based on the usage.
+ * @nb		notifier block used to notify devfreq object that it should
+ *		reevaluate operable frequencies. Devfreq users may use
+ *		devfreq.nb to the corresponding register notifier call chain.
+ * @polling_jiffies	interval in jiffies.
+ * @previous_freq	previously configured frequency value.
+ * @next_polling	the number of remaining jiffies to poll with
+ *			"devfreq_monitor" executions to reevaluate
+ *			frequency/voltage of the device. Set by
+ *			profile's polling_ms interval.
+ * @data	Private data of the governor. The devfreq framework does not
+ *		touch this.
+ * @being_removed	a flag to mark that this object is being removed in
+ *			order to prevent trying to remove the object multiple times.
+ *
+ * This structure stores the devfreq information for a give device.
+ *
+ * Note that when a governor accesses entries in struct devfreq in its
+ * functions except for the context of callbacks defined in struct
+ * devfreq_governor, the governor should protect its access with the
+ * struct mutex lock in struct devfreq. A governor may use this mutex
+ * to protect its own private data in void *data as well.
+ */
+struct devfreq {
+	struct list_head node;
+
+	struct mutex lock;
+	struct device dev;
+	struct devfreq_dev_profile *profile;
+	const struct devfreq_governor *governor;
+	struct notifier_block nb;
+
+	unsigned long polling_jiffies;
+	unsigned long previous_freq;
+	unsigned int next_polling;
+
+	void *data; /* private data for governors */
+
+	bool being_removed;
+};
+
+#if defined(CONFIG_PM_DEVFREQ)
+extern struct devfreq *devfreq_add_device(struct device *dev,
+				  struct devfreq_dev_profile *profile,
+				  const struct devfreq_governor *governor,
+				  void *data);
+extern int devfreq_remove_device(struct devfreq *devfreq);
+
+/* Helper functions for devfreq user device driver with OPP. */
+extern struct opp *devfreq_recommended_opp(struct device *dev,
+					   unsigned long *freq);
+extern int devfreq_register_opp_notifier(struct device *dev,
+					 struct devfreq *devfreq);
+extern int devfreq_unregister_opp_notifier(struct device *dev,
+					   struct devfreq *devfreq);
+
+#else /* !CONFIG_PM_DEVFREQ */
+static struct devfreq *devfreq_add_device(struct device *dev,
+					  struct devfreq_dev_profile *profile,
+					  struct devfreq_governor *governor,
+					  void *data);
+{
+	return NULL;
+}
+
+static int devfreq_remove_device(struct devfreq *devfreq);
+{
+	return 0;
+}
+
+static struct opp *devfreq_recommended_opp(struct device *dev,
+					   unsigned long *freq)
+{
+	return -EINVAL;
+}
+
+static int devfreq_register_opp_notifier(struct device *dev,
+					 struct devfreq *devfreq)
+{
+	return -EINVAL;
+}
+
+static int devfreq_unregister_opp_notifier(struct device *dev,
+					   struct devfreq *devfreq)
+{
+	return -EINVAL;
+}
+
+#endif /* CONFIG_PM_DEVFREQ */
+
+#endif /* __LINUX_DEVFREQ_H__ */
-- 
1.7.4.1

