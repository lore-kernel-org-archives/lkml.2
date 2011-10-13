Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab1JMTsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 15:48:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39265 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab1JMTse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 15:48:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 1/2] PM / Sleep: Add mechanism to disable suspend and hibernation
Date: Thu, 13 Oct 2011 21:49:12 +0200
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
Message-Id: <201110132149.12358.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

There are situations when it is necessary to disable suspend and
hibernation, so that it doesn't prevent some important operation
from completing.  For example, suspend or hibernation shouldn't
happen when the system's firmware is being updated, but it is
impossible to avoid race conditions with processes triggering suspend
or hibernation (e.g. a GUI power manager noticing that the GUI hasn't
been used for a sufficiently long time) entirely in user space.

For this reason, introduce a new sysfs attribute in /sys/power/,
called sleep_mode, allowing a root-owned process to set the mode
either to "direct", which means that it's possible to suspend or
hibernate normally and which is the default, or to "disabled", which
means that suspend and hibernation are impossible (this works by
adding a fake "wakeup event in progress" and enabling the wakeup
events detection mechanism defined in drivers/base/power/wakeup.c
unconditionally).

The name of the new attribute (sleep_mode) is chosen so that it
can be used for different purposes (e.g. adding a suspend mode
in which multiple processes have to agree on whether or not to
suspend) in the future.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/ABI/testing/sysfs-power |   28 +++++++++--
 drivers/base/power/wakeup.c           |   75 +++++++++++++++++++++++++------
 include/linux/suspend.h               |    2 
 kernel/power/hibernate.c              |    6 ++
 kernel/power/main.c                   |   82 ++++++++++++++++++++++++++++++++++
 kernel/power/suspend.c                |    5 ++
 kernel/power/user.c                   |    6 ++
 7 files changed, 187 insertions(+), 17 deletions(-)

Index: linux/kernel/power/main.c
===================================================================
--- linux.orig/kernel/power/main.c
+++ linux/kernel/power/main.c
@@ -70,6 +70,87 @@ static ssize_t pm_async_store(struct kob
 
 power_attr(pm_async);
 
+enum sleep_mode {
+	PM_SLEEP_DISABLED = 0,
+	PM_SLEEP_DIRECT,
+};
+
+#define PM_SLEEP_LAST	PM_SLEEP_DIRECT
+
+static const char * const pm_sleep_modes[__TEST_AFTER_LAST] = {
+	[PM_SLEEP_DISABLED] = "disabled",
+	[PM_SLEEP_DIRECT] = "direct",
+};
+
+static enum sleep_mode pm_sleep_mode = PM_SLEEP_DIRECT;
+
+static ssize_t sleep_mode_show(struct kobject *kobj,
+				  struct kobj_attribute *attr,
+				  char *buf)
+{
+	char *s = buf;
+	enum sleep_mode mode;
+
+	for (mode = PM_SLEEP_DISABLED; mode <= PM_SLEEP_LAST; mode++) {
+		if (mode == pm_sleep_mode)
+			s += sprintf(s, "[%s] ", pm_sleep_modes[mode]);
+		else
+			s += sprintf(s, "%s ", pm_sleep_modes[mode]);
+	}
+
+	if (s != buf)
+		/* convert the last space to a newline */
+		*(s-1) = '\n';
+
+	return (s - buf);
+}
+
+static ssize_t sleep_mode_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t n)
+{
+	const char * const *s;
+	enum sleep_mode mode;
+	char *p;
+	int len;
+	int error = -EINVAL;
+
+	p = memchr(buf, '\n', n);
+	len = p ? p - buf : n;
+
+	error = mutex_lock_interruptible(&pm_mutex);
+	if (error)
+		return error;
+
+	mode = PM_SLEEP_DISABLED;
+	for (s = &pm_sleep_modes[mode]; mode <= PM_SLEEP_LAST; s++, mode++)
+		if (*s && len == strlen(*s) && !strncmp(buf, *s, len)) {
+			if (pm_sleep_mode != mode)
+				goto set_mode;
+
+			error = 0;
+			break;
+		}
+
+	mutex_unlock(&pm_mutex);
+
+	return error;
+
+ set_mode:
+	if (mode == PM_SLEEP_DISABLED)
+		pm_wakeup_disable_suspend();
+	else
+		pm_wakeup_enable_suspend();
+
+	pm_sleep_mode = mode;
+
+	mutex_unlock(&pm_mutex);
+
+	return n;
+}
+
+power_attr(sleep_mode);
+
 #ifdef CONFIG_PM_DEBUG
 int pm_test_level = TEST_NONE;
 
@@ -407,6 +488,7 @@ static struct attribute * g[] = {
 	&pm_trace_dev_match_attr.attr,
 #endif
 #ifdef CONFIG_PM_SLEEP
+	&sleep_mode_attr.attr,
 	&pm_async_attr.attr,
 	&wakeup_count_attr.attr,
 #ifdef CONFIG_PM_DEBUG
Index: linux/drivers/base/power/wakeup.c
===================================================================
--- linux.orig/drivers/base/power/wakeup.c
+++ linux/drivers/base/power/wakeup.c
@@ -25,6 +25,13 @@
 bool events_check_enabled;
 
 /*
+ * If set, events_check_enabled will be reset to 'false' every time by
+ * pm_wakeup_pending() if there are wakeup events in progress or new registered
+ * wakeup events and will be modified by pm_save_wakeup_count().
+ */
+static bool reset_events_check = true;
+
+/*
  * Combined counters of registered wakeup events and wakeup events in progress.
  * They need to be modified together atomically, so it's better to use one
  * atomic variable to hold them both.
@@ -601,7 +608,8 @@ bool pm_wakeup_pending(void)
 
 		split_counters(&cnt, &inpr);
 		ret = (cnt != saved_count || inpr > 0);
-		events_check_enabled = !ret;
+		if (reset_events_check)
+			events_check_enabled = !ret;
 	}
 	spin_unlock_irqrestore(&events_lock, flags);
 	if (ret)
@@ -641,29 +649,70 @@ bool pm_get_wakeup_count(unsigned int *c
  * pm_save_wakeup_count - Save the current number of registered wakeup events.
  * @count: Value to compare with the current number of registered wakeup events.
  *
- * If @count is equal to the current number of registered wakeup events and the
- * current number of wakeup events being processed is zero, store @count as the
- * old number of registered wakeup events for pm_check_wakeup_events(), enable
- * wakeup events detection and return 'true'.  Otherwise disable wakeup events
- * detection and return 'false'.
+ * Save the current value of the registered wakeup events counter for future
+ * checking if new wakeup events have been registered.
+ *
+ * Additionally, check if @count is equal to the current number of registered
+ * wakeup events and if the number of wakeup events in progress is 0.  If both
+ * conditions are satisfied, return 'true' (otherwise, 'false' is returned).
+ *
+ * If reset_events_check is set, change the wakeup events detection setting to
+ * reflect the return value.
  */
 bool pm_save_wakeup_count(unsigned int count)
 {
 	unsigned int cnt, inpr;
+	bool ret;
 
-	events_check_enabled = false;
 	spin_lock_irq(&events_lock);
+
 	split_counters(&cnt, &inpr);
-	if (cnt == count && inpr == 0) {
-		saved_count = count;
-		events_check_enabled = true;
-	}
+	saved_count = cnt;
+	ret = cnt == count && inpr == 0;
+	if (reset_events_check)
+		events_check_enabled = ret;
+
 	spin_unlock_irq(&events_lock);
-	if (!events_check_enabled)
+
+	if (!ret)
 		pm_wakeup_update_hit_counts();
-	return events_check_enabled;
+
+	return ret;
+}
+
+/**
+ * pm_wakeup_disable_suspend - Prevent the system from going to sleep.
+ */
+void pm_wakeup_disable_suspend(void)
+{
+	spin_lock_irq(&events_lock);
+	events_check_enabled = true;
+	reset_events_check = false;
+	spin_unlock_irq(&events_lock);
+	/* Increment the counter of events in progress. */
+	atomic_inc(&combined_event_count);
+}
+
+/**
+ * pm_wakeup_enable_suspend - Allow the system to be put into a sleep state.
+ *
+ * Detection of wakeup events needs to be re-enabled if desirable after this
+ * function has returned.
+ */
+void pm_wakeup_enable_suspend(void)
+{
+	spin_lock_irq(&events_lock);
+	reset_events_check = true;
+	events_check_enabled = false;
+	spin_unlock_irq(&events_lock);
+	/*
+	 * Increment the counter of registered wakeup events and decrement the
+	 * couter of wakeup events in progress simultaneously.
+	 */
+	atomic_add(MAX_IN_PROGRESS, &combined_event_count);
 }
 
+
 static struct dentry *wakeup_sources_stats_dentry;
 
 /**
Index: linux/include/linux/suspend.h
===================================================================
--- linux.orig/include/linux/suspend.h
+++ linux/include/linux/suspend.h
@@ -351,6 +351,8 @@ extern bool events_check_enabled;
 extern bool pm_wakeup_pending(void);
 extern bool pm_get_wakeup_count(unsigned int *count);
 extern bool pm_save_wakeup_count(unsigned int count);
+extern void pm_wakeup_disable_suspend(void);
+extern void pm_wakeup_enable_suspend(void);
 #else /* !CONFIG_PM_SLEEP */
 
 static inline int register_pm_notifier(struct notifier_block *nb)
Index: linux/kernel/power/suspend.c
===================================================================
--- linux.orig/kernel/power/suspend.c
+++ linux/kernel/power/suspend.c
@@ -284,6 +284,11 @@ int enter_state(suspend_state_t state)
 	if (!mutex_trylock(&pm_mutex))
 		return -EBUSY;
 
+	if (pm_wakeup_pending()) {
+		error = -EAGAIN;
+		goto Unlock;
+	}
+
 	printk(KERN_INFO "PM: Syncing filesystems ... ");
 	sys_sync();
 	printk("done.\n");
Index: linux/kernel/power/hibernate.c
===================================================================
--- linux.orig/kernel/power/hibernate.c
+++ linux/kernel/power/hibernate.c
@@ -612,6 +612,12 @@ int hibernate(void)
 	int error;
 
 	mutex_lock(&pm_mutex);
+
+	if (pm_wakeup_pending()) {
+		error = -EAGAIN;
+		goto Unlock;
+	}
+
 	/* The snapshot device should not be opened while we're running */
 	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
 		error = -EBUSY;
Index: linux/kernel/power/user.c
===================================================================
--- linux.orig/kernel/power/user.c
+++ linux/kernel/power/user.c
@@ -239,6 +239,11 @@ static long snapshot_ioctl(struct file *
 	if (!mutex_trylock(&pm_mutex))
 		return -EBUSY;
 
+	if (pm_wakeup_pending()) {
+		error = -EAGAIN;
+		goto unlock;
+	}
+
 	data = filp->private_data;
 
 	switch (cmd) {
@@ -458,6 +463,7 @@ static long snapshot_ioctl(struct file *
 
 	}
 
+ unlock:
 	mutex_unlock(&pm_mutex);
 
 	return error;
Index: linux/Documentation/ABI/testing/sysfs-power
===================================================================
--- linux.orig/Documentation/ABI/testing/sysfs-power
+++ linux/Documentation/ABI/testing/sysfs-power
@@ -154,10 +154,14 @@ Description:
 		the current number of registered wakeup events and it blocks if
 		some wakeup events are being processed at the time the file is
 		read from.  Writing to it will only succeed if the current
-		number of wakeup events is equal to the written value and, if
-		successful, will make the kernel abort a subsequent transition
-		to a sleep state if any wakeup events are reported after the
-		write has returned.
+		number of registered wakeup events is equal to the written
+		value, but the way it works depends on the /sys/power/sleep_mode
+		setting.  Namely, in the "direct" mode, if the write has been
+		successful, it will make the kernel abort a subsequent
+		transition to a sleep state if any wakeup events are reported
+		after the write has returned.  In the "disabled" mode it only
+		saves the current value of registered wakeup events to be used
+		for future checking if new wakeup events have been registered.
 
 What:		/sys/power/reserved_size
 Date:		May 2011
@@ -172,3 +176,19 @@ Description:
 
 		Reading from this file will display the current value, which is
 		set to 1 MB by default.
+
+
+What:		/sys/power/sleep_mode
+Date:		October 2011
+Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Description:
+		The /sys/power/sleep_mode file allows user space to disable all
+		of the suspend/hibernation interfaces by writing "disabled" to
+		it and to enable them again by writing "direct" to it.  If the
+		string corresponding to the current setting is written to this
+		file, the write returns 0.  Otherwise, the number of characters
+		written is returned.
+
+		Reading from this file returns the list of available values
+		("disabled" and "direct") with the current one in square
+		brackets.

