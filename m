Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab1JMTss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 15:48:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39271 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab1JMTsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 15:48:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 2/2] PM / Sleep: Introduce cooperative suspend/hibernate mode
Date: Thu, 13 Oct 2011 21:50:28 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: mark gross <markgross@thegnar.org>, LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, NeilBrown <neilb@suse.de>
References: <201110132145.42270.rjw@sisk.pl>
In-Reply-To: <201110132145.42270.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110132150.28915.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The currently available mechanism allowing the suspend process to
avoid racing with wakeup events registered by the kernel appears
to be difficult to use.  Moreover, it requires that the suspend
process communicate with other user space processes that may take
part in the handling of wakeup events to make sure that they have
done their job before suspend is started.  Therefore all of the
wakeup-handling applications are expected to use an IPC mechanism
allowing them to exchange information with the suspend process, but
this expectation turns out to be unrealistic in practice.  For this
reason, it seems reasonable to add a mechanism allowing the
wakeup-handling processes to communicate with the suspend process
to the kernel.

This change introduces a new sleep mode, called "cooperative" sleep
mode, which needs to be selected via the /sys/power/sleep_mode sysfs
attribute and causes detection of wakeup events to be always
enabled, among other things, and a mechanism allowing user space
processes to prevent the system from being put into a sleep state
while in this mode.

The mechanism introduced by this change is based on a new special
device file, /dev/sleepctl.  A process wanting to prevent the system
from being put into a sleep state is expected to open /dev/sleepctl
and execute the SLEEPCTL_STAY_AWAKE ioctl() with the help of it.
This will make all attempts to suspend or hibernate the system block
until (1) the process executes the SLEEPCTL_RELAX ioctl() or (2)
a predefined timeout expires.  The timeout is set to 500 ms by
default, but the process can change it by writing the new timeout
value (in milliseconds) to /dev/sleepctl, in binary (unsigned int)
format.  The current timeout value can be read from /dev/sleepctl.
Setting the timeout to 0 disables it, i.e. it makes the
SLEEPCTL_STAY_AWAKE ioctl() block attempts to suspend or hibernate
the system until the SLEEPCTL_RELAX ioctl() is executed.

In addition to that, when system is resuming from suspend or
hibernation, the kernel automatically carries out an operation
equivalent to the SLEEPCTL_STAY_AWAKE ioctl() for all processes
that have /dev/sleepctl open at that time and whose timeouts are
greater than 0 (i.e. enabled), to allows those processes to
complete the handling of wakeup events before the system can be
put to a sleep state again.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/ABI/testing/sysfs-power |   34 +++-
 drivers/base/power/wakeup.c           |   38 +++-
 include/linux/suspend.h               |    6 
 include/linux/suspend_ioctls.h        |    4 
 kernel/power/Makefile                 |    1 
 kernel/power/hibernate.c              |   11 -
 kernel/power/main.c                   |  112 +++++++++++++
 kernel/power/power.h                  |    5 
 kernel/power/sleepctl.c               |  275 ++++++++++++++++++++++++++++++++++
 kernel/power/suspend.c                |   12 -
 kernel/power/user.c                   |   12 -
 11 files changed, 460 insertions(+), 50 deletions(-)

Index: linux/drivers/base/power/wakeup.c
===================================================================
--- linux.orig/drivers/base/power/wakeup.c
+++ linux/drivers/base/power/wakeup.c
@@ -681,30 +681,49 @@ bool pm_save_wakeup_count(unsigned int c
 }
 
 /**
- * pm_wakeup_disable_suspend - Prevent the system from going to sleep.
+ * pm_wakeup_enable_events_checking - Turn on wakeup events detection.
  */
-void pm_wakeup_disable_suspend(void)
+void pm_wakeup_enable_events_checking(void)
 {
 	spin_lock_irq(&events_lock);
 	events_check_enabled = true;
 	reset_events_check = false;
 	spin_unlock_irq(&events_lock);
-	/* Increment the counter of events in progress. */
-	atomic_inc(&combined_event_count);
 }
 
 /**
- * pm_wakeup_enable_suspend - Allow the system to be put into a sleep state.
- *
- * Detection of wakeup events needs to be re-enabled if desirable after this
- * function has returned.
+ * pm_wakeup_disable_events_checking - Turn off wakeup events detection.
  */
-void pm_wakeup_enable_suspend(void)
+void pm_wakeup_disable_events_checking(void)
 {
 	spin_lock_irq(&events_lock);
 	reset_events_check = true;
 	events_check_enabled = false;
 	spin_unlock_irq(&events_lock);
+}
+
+/**
+ * pm_wakeup_disable_suspend - Prevent the system from going to sleep.
+ * @enable_events_check: Whether or not to turn on wakeup events detection.
+ */
+void pm_wakeup_disable_suspend(bool enable_events_check)
+{
+	if (enable_events_check)
+		pm_wakeup_enable_events_checking();
+
+	/* Increment the counter of events in progress. */
+	atomic_inc(&combined_event_count);
+}
+
+/**
+ * pm_wakeup_enable_suspend - Allow the system to be put into a sleep state.
+ * @disable_events_check: Whether or not to turn off wakeup events detection.
+ */
+void pm_wakeup_enable_suspend(bool disable_events_check)
+{
+	if (disable_events_check)
+		pm_wakeup_disable_events_checking();
+
 	/*
 	 * Increment the counter of registered wakeup events and decrement the
 	 * couter of wakeup events in progress simultaneously.
@@ -712,7 +731,6 @@ void pm_wakeup_enable_suspend(void)
 	atomic_add(MAX_IN_PROGRESS, &combined_event_count);
 }
 
-
 static struct dentry *wakeup_sources_stats_dentry;
 
 /**
Index: linux/include/linux/suspend.h
===================================================================
--- linux.orig/include/linux/suspend.h
+++ linux/include/linux/suspend.h
@@ -351,8 +351,10 @@ extern bool events_check_enabled;
 extern bool pm_wakeup_pending(void);
 extern bool pm_get_wakeup_count(unsigned int *count);
 extern bool pm_save_wakeup_count(unsigned int count);
-extern void pm_wakeup_disable_suspend(void);
-extern void pm_wakeup_enable_suspend(void);
+extern void pm_wakeup_enable_events_checking(void);
+extern void pm_wakeup_disable_events_checking(void);
+extern void pm_wakeup_disable_suspend(bool enable_events_check);
+extern void pm_wakeup_enable_suspend(bool disable_events_check);
 #else /* !CONFIG_PM_SLEEP */
 
 static inline int register_pm_notifier(struct notifier_block *nb)
Index: linux/kernel/power/main.c
===================================================================
--- linux.orig/kernel/power/main.c
+++ linux/kernel/power/main.c
@@ -70,16 +70,26 @@ static ssize_t pm_async_store(struct kob
 
 power_attr(pm_async);
 
+static void pm_update_saved_wakeup_count(void)
+{
+	unsigned int wakeup_count;
+
+	pm_get_wakeup_count(&wakeup_count);
+	pm_save_wakeup_count(wakeup_count);
+}
+
 enum sleep_mode {
 	PM_SLEEP_DISABLED = 0,
 	PM_SLEEP_DIRECT,
+	PM_SLEEP_COOPERATIVE,
 };
 
-#define PM_SLEEP_LAST	PM_SLEEP_DIRECT
+#define PM_SLEEP_LAST	PM_SLEEP_COOPERATIVE
 
 static const char * const pm_sleep_modes[__TEST_AFTER_LAST] = {
 	[PM_SLEEP_DISABLED] = "disabled",
 	[PM_SLEEP_DIRECT] = "direct",
+	[PM_SLEEP_COOPERATIVE] = "cooperative",
 };
 
 static enum sleep_mode pm_sleep_mode = PM_SLEEP_DIRECT;
@@ -137,11 +147,26 @@ static ssize_t sleep_mode_store(struct k
 	return error;
 
  set_mode:
-	if (mode == PM_SLEEP_DISABLED)
-		pm_wakeup_disable_suspend();
-	else
-		pm_wakeup_enable_suspend();
-
+	switch (mode) {
+	case PM_SLEEP_DISABLED:
+		pm_wakeup_disable_suspend(pm_sleep_mode == PM_SLEEP_DIRECT);
+		break;
+
+	case PM_SLEEP_COOPERATIVE:
+		if (pm_sleep_mode == PM_SLEEP_DISABLED)
+			pm_wakeup_enable_suspend(false);
+		else /* PM_SLEEP_DIRECT */
+			pm_wakeup_enable_events_checking();
+
+		pm_update_saved_wakeup_count();
+		break;
+
+	default: /* PM_SLEEP_DIRECT */
+		if (pm_sleep_mode == PM_SLEEP_DISABLED)
+			pm_wakeup_enable_suspend(false);
+		else /* PM_SLEEP_COOPERATIVE */
+			pm_wakeup_disable_events_checking();
+	}
 	pm_sleep_mode = mode;
 
 	mutex_unlock(&pm_mutex);
@@ -151,6 +176,81 @@ static ssize_t sleep_mode_store(struct k
 
 power_attr(sleep_mode);
 
+static DECLARE_WAIT_QUEUE_HEAD(pm_sleep_wait_queue);
+
+/**
+ * pm_sleep_begin - Prepare to start a transition into a sleep state.
+ *
+ * Acquire pm_mutex and if the current sleep mode is not "cooperative", return
+ * an error code if new wakeup events have been registered or 0 otherwise.
+ *
+ * If the current sleep mode is "cooperative", wait until all users of
+ * /dev/sleepctl allow us to continue or new wakeup events are registered.
+ */
+int pm_sleep_begin(void)
+{
+	DEFINE_WAIT(wait);
+	int error;
+
+	error = mutex_lock_interruptible(&pm_mutex);
+	if (error)
+		return error;
+
+	if (pm_sleep_mode != PM_SLEEP_COOPERATIVE) {
+		if (pm_wakeup_pending()) {
+			mutex_unlock(&pm_mutex);
+			return -EAGAIN;
+		}
+		return 0;
+	}
+
+	while (!error) {
+		prepare_to_wait(&pm_sleep_wait_queue, &wait,
+				TASK_INTERRUPTIBLE);
+		if (!sleepctl_active())
+			break;
+
+		mutex_unlock(&pm_mutex);
+
+		schedule();
+
+		error = mutex_lock_interruptible(&pm_mutex);
+	}
+	finish_wait(&pm_sleep_wait_queue, &wait);
+	if (error)
+		return error;
+
+	return pm_wakeup_pending() ? -EAGAIN : 0;
+}
+
+/**
+ * pm_sleep_continue - Wake up a waiting suspend/hibernate process.
+ */
+void pm_sleep_continue(void)
+{
+	wake_up_all(&pm_sleep_wait_queue);
+}
+
+/**
+ * pm_sleep_end - Finalize a transition from a sleep state to the working state.
+ *
+ * If the current sleep mode is "cooperative", save the current value of the
+ * registered wakeup events counter for future use and make all processes
+ * having /dev/sleepctl open whose sleep delay fields are different from 0
+ * block subsequent pm_sleep_begin() calls.
+ *
+ * Release pm_mutex.
+ */
+void pm_sleep_end(void)
+{
+	if (pm_sleep_mode == PM_SLEEP_COOPERATIVE) {
+		pm_update_saved_wakeup_count();
+		sleepctl_rearm();
+	}
+
+	mutex_unlock(&pm_mutex);
+}
+
 #ifdef CONFIG_PM_DEBUG
 int pm_test_level = TEST_NONE;
 
Index: linux/include/linux/suspend_ioctls.h
===================================================================
--- linux.orig/include/linux/suspend_ioctls.h
+++ linux/include/linux/suspend_ioctls.h
@@ -30,4 +30,8 @@ struct resume_swap_area {
 #define SNAPSHOT_ALLOC_SWAP_PAGE	_IOR(SNAPSHOT_IOC_MAGIC, 20, __kernel_loff_t)
 #define SNAPSHOT_IOC_MAXNR	20
 
+#define SLEEPCTL_STAY_AWAKE		_IO(SNAPSHOT_IOC_MAGIC, 31)
+#define SLEEPCTL_RELAX			_IO(SNAPSHOT_IOC_MAGIC, 32)
+#define SLEEPCTL_SET_DELAY	32
+
 #endif /* _LINUX_SUSPEND_IOCTLS_H */
Index: linux/kernel/power/Makefile
===================================================================
--- linux.orig/kernel/power/Makefile
+++ linux/kernel/power/Makefile
@@ -8,5 +8,6 @@ obj-$(CONFIG_SUSPEND)		+= suspend.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o \
 				   block_io.o
+obj-$(CONFIG_PM_SLEEP)		+= sleepctl.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
Index: linux/kernel/power/sleepctl.c
===================================================================
--- /dev/null
+++ linux/kernel/power/sleepctl.c
@@ -0,0 +1,275 @@
+/*
+ * kernel/power/sleepctl.c
+ *
+ * This file provides definitions of sleepctl special device file operations.
+ *
+ * Copyright (C) 2011 Rafael J. Wysocki <rjw@sisk.pl>, SUSE Labs
+ *
+ * This file is released under the GPLv2.
+ *
+ */
+
+#include <linux/suspend.h>
+#include <linux/syscalls.h>
+#include <linux/string.h>
+#include <linux/device.h>
+#include <linux/miscdevice.h>
+#include <linux/pm.h>
+#include <linux/slab.h>
+
+#include "power.h"
+
+#define DEFAULT_SUSPEND_DELAY_MS	500
+
+static LIST_HEAD(sleepctl_list);
+static LIST_HEAD(sleepctl_active_list);;
+
+static DEFINE_SPINLOCK(sleepctl_lock);
+
+struct sleepctl_data {
+	struct list_head	entry;
+	struct timer_list	timer;
+	unsigned int		delay_ms;
+	bool			active;
+};
+
+static bool __sleepctl_active(void)
+{
+	return !(list_empty(&sleepctl_active_list) || pm_wakeup_pending());
+}
+
+/**
+ * sleepctl_active - Check if the system is allowed to go into a sleep state.
+ *
+ * Check if there's any user space process preventing the system from being put
+ * into a sleep state and return 'true' in that case.
+ */
+bool sleepctl_active(void)
+{
+	bool ret;
+
+	spin_lock_irq(&sleepctl_lock);
+	ret = __sleepctl_active();
+	spin_unlock_irq(&sleepctl_lock);
+	return ret;
+}
+
+static void __sleepctl_relax(struct sleepctl_data *data)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sleepctl_lock, flags);
+
+	if (!data->active)
+		goto unlock;
+
+	data->active = false;
+	list_move_tail(&data->entry, &sleepctl_list);
+
+	if (!__sleepctl_active())
+		pm_sleep_continue();
+
+ unlock:
+	spin_unlock_irqrestore(&sleepctl_lock, flags);
+}
+
+static void sleepctl_timer_fn(unsigned long data)
+{
+	__sleepctl_relax((struct sleepctl_data *)data);
+}
+
+static void sleepctl_relax(struct sleepctl_data *data)
+{
+	del_timer_sync(&data->timer);
+	__sleepctl_relax(data);
+}
+
+static void sleepctl_stay_awake(struct sleepctl_data *data)
+{
+	spin_lock_irq(&sleepctl_lock);
+
+	if (data->active)
+		goto unlock;
+
+	data->active = true;
+	list_move_tail(&data->entry, &sleepctl_active_list);
+	if (data->delay_ms > 0)
+		mod_timer(&data->timer,
+			  jiffies + msecs_to_jiffies(data->delay_ms));
+
+ unlock:
+	spin_unlock_irq(&sleepctl_lock);
+}
+
+/**
+ * sleepctl_rearm - Make the users of /dev/sleepctl block sleep transitions.
+ *
+ * Make all processes having /dev/sleepctl open whose delay_ms fields are
+ * nonzero prevent the system from being put into sleep states.
+ */
+void sleepctl_rearm(void)
+{
+	struct sleepctl_data *data, *n;
+
+	list_for_each_entry_safe(data, n, &sleepctl_list, entry) {
+		if (data->delay_ms > 0)
+			sleepctl_stay_awake(data);
+	}
+}
+
+static int sleepctl_open(struct inode *inode, struct file *filp)
+{
+	struct sleepctl_data *data;
+	int error;
+
+	error = mutex_lock_interruptible(&pm_mutex);
+	if (error)
+		return error;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		error = -ENOMEM;
+		goto err_out;
+	}
+
+	spin_lock_irq(&sleepctl_lock);
+	list_add_tail(&data->entry, &sleepctl_list);
+	spin_unlock_irq(&sleepctl_lock);
+
+	data->delay_ms = DEFAULT_SUSPEND_DELAY_MS;
+	setup_timer(&data->timer, sleepctl_timer_fn, (unsigned long)data);
+
+	nonseekable_open(inode, filp);
+	filp->private_data = data;
+
+ err_out:
+	mutex_unlock(&pm_mutex);
+
+	return error;
+}
+
+static int sleepctl_release(struct inode *inode, struct file *filp)
+{
+	struct sleepctl_data *data;
+	int error;
+
+	error = mutex_lock_interruptible(&pm_mutex);
+	if (error)
+		return error;
+
+	data = filp->private_data;
+	if (data->active)
+		sleepctl_relax(data);
+
+	filp->private_data = NULL;
+
+	spin_lock_irq(&sleepctl_lock);
+	list_del(&data->entry);
+	spin_unlock_irq(&sleepctl_lock);
+
+	kfree(data);
+
+	mutex_unlock(&pm_mutex);
+
+	return 0;
+}
+
+static ssize_t sleepctl_read(struct file *filp, char __user *buf,
+			     size_t count, loff_t *offp)
+{
+	struct sleepctl_data *data;
+	ssize_t res;
+
+	res = mutex_lock_interruptible(&pm_mutex);
+	if (res)
+		return res;
+
+	data = filp->private_data;
+	res = sizeof(unsigned int);
+	if (copy_to_user(buf, &data->delay_ms, res))
+		res = -EFAULT;
+
+	mutex_unlock(&pm_mutex);
+
+	return res;
+}
+
+static ssize_t sleepctl_write(struct file *filp, const char __user *buf,
+			      size_t count, loff_t *offp)
+{
+	struct sleepctl_data *data;
+	ssize_t res;
+	unsigned int delay_ms;
+
+	res = mutex_lock_interruptible(&pm_mutex);
+	if (res)
+		return res;
+
+	res = sizeof(unsigned int);
+	if (copy_from_user(&delay_ms, buf, res)) {
+		res = -EFAULT;
+	} else {
+		data = filp->private_data;
+		sleepctl_relax(data);
+		data->delay_ms = delay_ms;
+	}
+
+	mutex_unlock(&pm_mutex);
+
+	return res;
+}
+
+static long sleepctl_ioctl(struct file *filp, unsigned int cmd,
+			   unsigned long arg)
+{
+	struct sleepctl_data *data;
+	int error;
+
+	error = mutex_lock_interruptible(&pm_mutex);
+	if (error)
+		return error;
+
+	data = filp->private_data;
+
+	switch (cmd) {
+
+	case SLEEPCTL_STAY_AWAKE:
+		del_timer_sync(&data->timer);
+		sleepctl_stay_awake(data);
+		break;
+
+	case SLEEPCTL_RELAX:
+		sleepctl_relax(data);
+		break;
+
+	default:
+		error = -ENOTTY;
+
+	}
+
+	mutex_unlock(&pm_mutex);
+
+	return error;
+}
+
+static const struct file_operations sleepctl_fops = {
+	.open = sleepctl_open,
+	.release = sleepctl_release,
+	.read = sleepctl_read,
+	.write = sleepctl_write,
+	.llseek = no_llseek,
+	.unlocked_ioctl = sleepctl_ioctl,
+};
+
+static struct miscdevice sleepctl_device = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "sleepctl",
+	.fops = &sleepctl_fops,
+};
+
+static int __init sleepctl_device_init(void)
+{
+	return misc_register(&sleepctl_device);
+};
+
+device_initcall(sleepctl_device_init);
Index: linux/kernel/power/suspend.c
===================================================================
--- linux.orig/kernel/power/suspend.c
+++ linux/kernel/power/suspend.c
@@ -281,13 +281,9 @@ int enter_state(suspend_state_t state)
 	if (!valid_state(state))
 		return -ENODEV;
 
-	if (!mutex_trylock(&pm_mutex))
-		return -EBUSY;
-
-	if (pm_wakeup_pending()) {
-		error = -EAGAIN;
-		goto Unlock;
-	}
+	error = pm_sleep_begin();
+	if (error)
+		return error;
 
 	printk(KERN_INFO "PM: Syncing filesystems ... ");
 	sys_sync();
@@ -310,7 +306,7 @@ int enter_state(suspend_state_t state)
 	pr_debug("PM: Finishing wakeup.\n");
 	suspend_finish();
  Unlock:
-	mutex_unlock(&pm_mutex);
+	pm_sleep_end();
 	return error;
 }
 
Index: linux/kernel/power/hibernate.c
===================================================================
--- linux.orig/kernel/power/hibernate.c
+++ linux/kernel/power/hibernate.c
@@ -611,12 +611,9 @@ int hibernate(void)
 {
 	int error;
 
-	mutex_lock(&pm_mutex);
-
-	if (pm_wakeup_pending()) {
-		error = -EAGAIN;
-		goto Unlock;
-	}
+	error = pm_sleep_begin();
+	if (error)
+		return error;
 
 	/* The snapshot device should not be opened while we're running */
 	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
@@ -684,7 +681,7 @@ int hibernate(void)
 	pm_restore_console();
 	atomic_inc(&snapshot_device_available);
  Unlock:
-	mutex_unlock(&pm_mutex);
+	pm_sleep_end();
 	return error;
 }
 
Index: linux/kernel/power/user.c
===================================================================
--- linux.orig/kernel/power/user.c
+++ linux/kernel/power/user.c
@@ -236,13 +236,9 @@ static long snapshot_ioctl(struct file *
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!mutex_trylock(&pm_mutex))
-		return -EBUSY;
-
-	if (pm_wakeup_pending()) {
-		error = -EAGAIN;
-		goto unlock;
-	}
+	error = pm_sleep_begin();
+	if (error)
+		return error;
 
 	data = filp->private_data;
 
@@ -464,7 +460,7 @@ static long snapshot_ioctl(struct file *
 	}
 
  unlock:
-	mutex_unlock(&pm_mutex);
+	pm_sleep_end();
 
 	return error;
 }
Index: linux/kernel/power/power.h
===================================================================
--- linux.orig/kernel/power/power.h
+++ linux/kernel/power/power.h
@@ -196,6 +196,11 @@ static inline void suspend_test_finish(c
 #ifdef CONFIG_PM_SLEEP
 /* kernel/power/main.c */
 extern int pm_notifier_call_chain(unsigned long val);
+extern int pm_sleep_begin(void);
+extern void pm_sleep_continue(void);
+extern void pm_sleep_end(void);
+extern bool sleepctl_active(void);
+extern void sleepctl_rearm(void);
 #endif
 
 #ifdef CONFIG_HIGHMEM
Index: linux/Documentation/ABI/testing/sysfs-power
===================================================================
--- linux.orig/Documentation/ABI/testing/sysfs-power
+++ linux/Documentation/ABI/testing/sysfs-power
@@ -159,7 +159,7 @@ Description:
 		setting.  Namely, in the "direct" mode, if the write has been
 		successful, it will make the kernel abort a subsequent
 		transition to a sleep state if any wakeup events are reported
-		after the write has returned.  In the "disabled" mode it only
+		after the write has returned.  In the other modes it only
 		saves the current value of registered wakeup events to be used
 		for future checking if new wakeup events have been registered.
 
@@ -182,13 +182,29 @@ What:		/sys/power/sleep_mode
 Date:		October 2011
 Contact:	Rafael J. Wysocki <rjw@sisk.pl>
 Description:
-		The /sys/power/sleep_mode file allows user space to disable all
-		of the suspend/hibernation interfaces by writing "disabled" to
-		it and to enable them again by writing "direct" to it.  If the
-		string corresponding to the current setting is written to this
-		file, the write returns 0.  Otherwise, the number of characters
-		written is returned.
+		The /sys/power/sleep_mode file allows user space to control the
+		way the system suspend and hibernation interfaces work.  The
+		available modes are:
+
+		'disabled':	All of the suspend and hibernation interfaces
+				are disabled and return error codes when used.
+
+		'direct':	Suspend and hibernation interfaces work in the
+				"traditional" way (i.e. a root-owned process can
+				suspend or hibernate the system by writing to
+				/sys/power/state or using /dev/snapshot and the
+				other user space processes can't prevent the
+				system from going into the sleep state).
+
+		'cooperative':	User space processes can cause all attempts to
+				suspend or hibernate the system to block by
+				using the /dev/sleepctl special device file's
+				ioctl()s.
+
+		If the string corresponding to the current setting is written to
+		this file, the write returns 0.  Otherwise, the number of
+		characters written is returned.
 
 		Reading from this file returns the list of available values
-		("disabled" and "direct") with the current one in square
-		brackets.
+		("disabled", "direct", "cooperative") with the current one in
+		square brackets.

