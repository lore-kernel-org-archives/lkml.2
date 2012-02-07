Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab2BGWpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 17:45:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41866 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800Ab2BGWpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 17:45:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [Update][RFC][PATCH 6/8] PM / Sleep: Implement opportunistic sleep
Date: Tue, 7 Feb 2012 23:49:38 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        markgross@thegnar.org, Matthew Garrett <mjg@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201202070200.55505.rjw@sisk.pl> <201202070206.01541.rjw@sisk.pl>
In-Reply-To: <201202070206.01541.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202072349.39157.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 07, 2012, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Introduce a mechanism by which the kernel can trigger global
> transitions to a sleep state chosen by user space if there are no
> active wakeup sources.
> 
> It consists of a new sysfs attribute, /sys/power/autosleep, that
> can be written one of the strings returned by reads from
> /sys/power/state, a freezable ordered workqueue and a work item
> carrying out the "suspend" operations.  If a string representing
> the system's sleep state is written to /sys/power/autosleep, the
> work item triggering transitions to that state is queued up and
> it requeues it self after every execution until user space writes
> "off" to /sys/power/autosleep.  That work item enables the detection
> of wakeup events using the functions already defined in
> drivers/base/power/wakeup.c (with one small modification) and calls
> either pm_suspend(), or hibernate() to put the system into a sleep
> state.  If a wakeup event is reported while the transition is in
> progress, it will abort the transition and the "system suspend" work
> item will be queued up again.

OK, so before somebody points that out to me, the completion was redundant
(it was a leftover from one of the previous versions of the patch, sorry
about that).

Moreover, try_to_suspend() is racy with respect to wakeup_count_store()
(in theory, an automatic suspend without checking wakeup sources may happen
if the latter is used carelessly when autosleep is enabled).

Thus below is an updated patch (it requires [8/8] to be updated too because
of the changes in pm_autosleep_set_state(), but that's rather trivial).

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Sleep: Implement opportunistic sleep

Introduce a mechanism by which the kernel can trigger global
transitions to a sleep state chosen by user space if there are no
active wakeup sources.

It consists of a new sysfs attribute, /sys/power/autosleep, that
can be written one of the strings returned by reads from
/sys/power/state, an ordered workqueue and a work item carrying out
the "suspend" operations.  If a string representing the system's
sleep state is written to /sys/power/autosleep, the work item
triggering transitions to that state is queued up and it requeues
itself after every execution until user space writes "off" to
/sys/power/autosleep.

That work item enables the detection of wakeup events using the
functions already defined in drivers/base/power/wakeup.c (with one
small modification) and calls either pm_suspend(), or hibernate() to
put the system into a sleep state.  If a wakeup event is reported
while the transition is in progress, it will abort the transition and
the "system suspend" work item will be queued up again.

---
 drivers/base/power/wakeup.c |   38 ++++++++------
 include/linux/suspend.h     |   13 ++++-
 kernel/power/Kconfig        |    8 +++
 kernel/power/Makefile       |    1 
 kernel/power/autosleep.c    |  112 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/power/main.c         |  105 ++++++++++++++++++++++++++++++++++-------
 kernel/power/power.h        |   18 +++++++
 7 files changed, 262 insertions(+), 33 deletions(-)

Index: linux/kernel/power/Makefile
===================================================================
--- linux.orig/kernel/power/Makefile
+++ linux/kernel/power/Makefile
@@ -8,5 +8,6 @@ obj-$(CONFIG_SUSPEND)		+= suspend.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o \
 				   block_io.o
+obj-$(CONFIG_PM_AUTOSLEEP)	+= autosleep.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
Index: linux/kernel/power/Kconfig
===================================================================
--- linux.orig/kernel/power/Kconfig
+++ linux/kernel/power/Kconfig
@@ -103,6 +103,14 @@ config PM_SLEEP_SMP
 	select HOTPLUG
 	select HOTPLUG_CPU
 
+config PM_AUTOSLEEP
+	bool "Opportunistic sleep"
+	depends on PM_SLEEP
+	default n
+	---help---
+	Allow the kernel to trigger a system transition into a global sleep
+	state automatically whenever there are no active wakeup sources.
+
 config PM_RUNTIME
 	bool "Run-time PM core functionality"
 	depends on !IA64_HP_SIM
Index: linux/kernel/power/power.h
===================================================================
--- linux.orig/kernel/power/power.h
+++ linux/kernel/power/power.h
@@ -269,3 +269,21 @@ static inline void suspend_thaw_processe
 {
 }
 #endif
+
+#ifdef CONFIG_PM_AUTOSLEEP
+
+/* kernel/power/autosleep.c */
+extern int pm_autosleep_init(void);
+extern void pm_autosleep_lock(void);
+extern void pm_autosleep_unlock(void);
+extern suspend_state_t pm_autosleep_state(void);
+extern int pm_autosleep_set_state(suspend_state_t state);
+
+#else /* !CONFIG_PM_AUTOSLEEP */
+
+static inline int pm_autosleep_init(void) { return 0; }
+static inline void pm_autosleep_lock(void) {}
+static inline void pm_autosleep_unlock(void) {}
+static inline suspend_state_t pm_autosleep_state(void) { return PM_SUSPEND_ON; }
+
+#endif /* !CONFIG_PM_AUTOSLEEP */
Index: linux/include/linux/suspend.h
===================================================================
--- linux.orig/include/linux/suspend.h
+++ linux/include/linux/suspend.h
@@ -372,7 +372,7 @@ extern int unregister_pm_notifier(struct
 extern bool events_check_enabled;
 
 extern bool pm_wakeup_pending(void);
-extern bool pm_get_wakeup_count(unsigned int *count);
+extern bool pm_get_wakeup_count(unsigned int *count, bool block);
 extern bool pm_save_wakeup_count(unsigned int count);
 
 static inline void lock_system_sleep(void)
@@ -423,6 +423,17 @@ static inline void unlock_system_sleep(v
 
 #endif /* !CONFIG_PM_SLEEP */
 
+#ifdef CONFIG_PM_AUTOSLEEP
+
+/* kernel/power/autosleep.c */
+void queue_up_suspend_work(void);
+
+#else /* !CONFIG_PM_AUTOSLEEP */
+
+static inline void queue_up_suspend_work(void) {}
+
+#endif /* !CONFIG_PM_AUTOSLEEP */
+
 #ifdef CONFIG_ARCH_SAVE_PAGE_KEYS
 /*
  * The ARCH_SAVE_PAGE_KEYS functions can be used by an architecture
Index: linux/kernel/power/autosleep.c
===================================================================
--- /dev/null
+++ linux/kernel/power/autosleep.c
@@ -0,0 +1,112 @@
+/*
+ * kernel/power/autosleep.c
+ *
+ * Opportunistic sleep support.
+ *
+ * Copyright (C) 2012 Rafael J. Wysocki <rjw@sisk.pl>
+ */
+
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/pm_wakeup.h>
+
+#include "power.h"
+
+static struct workqueue_struct *autosleep_wq;
+static struct wakeup_source *autosleep_ws;
+
+static DEFINE_MUTEX(autosleep_lock);
+
+static suspend_state_t autosleep_state;
+
+static void try_to_suspend(struct work_struct *work)
+{
+	unsigned int initial_count, final_count;
+
+	if (!pm_get_wakeup_count(&initial_count, true))
+		goto out;
+
+	mutex_lock(&autosleep_lock);
+
+	if (!pm_save_wakeup_count(initial_count)) {
+		mutex_unlock(&autosleep_lock);
+		goto out;
+	}
+
+	if (autosleep_state == PM_SUSPEND_ON) {
+		mutex_unlock(&autosleep_lock);
+		return;
+	}
+	if (autosleep_state >= PM_SUSPEND_MAX)
+		hibernate();
+	else
+		pm_suspend(autosleep_state);
+
+	mutex_unlock(&autosleep_lock);
+
+	if (!pm_get_wakeup_count(&final_count, false))
+		goto out;
+
+	if (final_count == initial_count)
+		schedule_timeout(HZ / 2);
+
+ out:
+	queue_up_suspend_work();
+}
+
+static DECLARE_WORK(suspend_work, try_to_suspend);
+
+void queue_up_suspend_work(void)
+{
+	if (!work_pending(&suspend_work) && autosleep_state > PM_SUSPEND_ON)
+		queue_work(autosleep_wq, &suspend_work);
+}
+
+suspend_state_t pm_autosleep_state(void)
+{
+	return autosleep_state;
+}
+
+int pm_autosleep_set_state(suspend_state_t state)
+{
+#ifndef CONFIG_HIBERNATION
+	if (state >= PM_SUSPEND_MAX)
+		return -EINVAL;
+#endif
+	mutex_lock(&autosleep_lock);
+	__pm_stay_awake(autosleep_ws);
+	if (state == PM_SUSPEND_ON && autosleep_state != PM_SUSPEND_ON) {
+		autosleep_state = PM_SUSPEND_ON;
+		__pm_relax(autosleep_ws);
+	} else if (state > PM_SUSPEND_ON) {
+		autosleep_state = state;
+		__pm_relax(autosleep_ws);
+		queue_up_suspend_work();
+	}
+	mutex_unlock(&autosleep_lock);
+	return 0;
+}
+
+void pm_autosleep_lock(void)
+{
+	mutex_lock(&autosleep_lock);
+}
+
+void pm_autosleep_unlock(void)
+{
+	mutex_unlock(&autosleep_lock);
+}
+
+int __init pm_autosleep_init(void)
+{
+	autosleep_ws = wakeup_source_register("main");
+	if (!autosleep_ws)
+		return -ENOMEM;
+
+	autosleep_wq = alloc_ordered_workqueue("autosleep", 0);
+	if (autosleep_wq)
+		return 0;
+
+	wakeup_source_unregister(autosleep_ws);
+	return -ENOMEM;
+}
Index: linux/kernel/power/main.c
===================================================================
--- linux.orig/kernel/power/main.c
+++ linux/kernel/power/main.c
@@ -269,8 +269,7 @@ static ssize_t state_show(struct kobject
 	return (s - buf);
 }
 
-static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
-			   const char *buf, size_t n)
+static suspend_state_t decode_state(const char *buf, size_t n)
 {
 #ifdef CONFIG_SUSPEND
 	suspend_state_t state = PM_SUSPEND_STANDBY;
@@ -278,29 +277,46 @@ static ssize_t state_store(struct kobjec
 #endif
 	char *p;
 	int len;
-	int error = -EINVAL;
 
 	p = memchr(buf, '\n', n);
 	len = p ? p - buf : n;
 
-	/* First, check if we are requested to hibernate */
-	if (len == 4 && !strncmp(buf, "disk", len)) {
-		error = hibernate();
-		goto Exit;
-	}
+	/* Check hibernation first. */
+	if (len == 4 && !strncmp(buf, "disk", len))
+		return PM_SUSPEND_MAX;
 
 #ifdef CONFIG_SUSPEND
 	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++) {
 		if (*s && len == strlen(*s) && !strncmp(buf, *s, len))
 			break;
 	}
-	if (state < PM_SUSPEND_MAX && *s) {
-		error = enter_state(state);
-		suspend_stats_update(error);
-	}
+	if (state < PM_SUSPEND_MAX && *s)
+		return state;
 #endif
 
- Exit:
+	return PM_SUSPEND_ON;
+}
+
+static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
+			   const char *buf, size_t n)
+{
+	suspend_state_t state;
+	int error = -EINVAL;
+
+	pm_autosleep_lock();
+	if (pm_autosleep_state() > PM_SUSPEND_ON) {
+		error = -EBUSY;
+		goto out;
+	}
+
+	state = decode_state(buf, n);
+	if (state < PM_SUSPEND_MAX)
+		error = pm_suspend(state);
+	else if (state > PM_SUSPEND_ON)
+		error = hibernate();
+
+ out:
+	pm_autosleep_unlock();
 	return error ? error : n;
 }
 
@@ -341,7 +357,8 @@ static ssize_t wakeup_count_show(struct
 {
 	unsigned int val;
 
-	return pm_get_wakeup_count(&val) ? sprintf(buf, "%u\n", val) : -EINTR;
+	return pm_get_wakeup_count(&val, true) ?
+		sprintf(buf, "%u\n", val) : -EINTR;
 }
 
 static ssize_t wakeup_count_store(struct kobject *kobj,
@@ -349,15 +366,65 @@ static ssize_t wakeup_count_store(struct
 				const char *buf, size_t n)
 {
 	unsigned int val;
+	int error = -EINVAL;
+
+	pm_autosleep_lock();
+	if (pm_autosleep_state() > PM_SUSPEND_ON) {
+		error = -EBUSY;
+		goto out;
+	}
 
 	if (sscanf(buf, "%u", &val) == 1) {
 		if (pm_save_wakeup_count(val))
 			return n;
 	}
-	return -EINVAL;
+
+ out:
+	pm_autosleep_unlock();
+	return error;
 }
 
 power_attr(wakeup_count);
+
+#ifdef CONFIG_PM_AUTOSLEEP
+static ssize_t autosleep_show(struct kobject *kobj,
+			      struct kobj_attribute *attr,
+			      char *buf)
+{
+	suspend_state_t state = pm_autosleep_state();
+
+	if (state == PM_SUSPEND_ON)
+		return sprintf(buf, "off\n");
+
+#ifdef CONFIG_SUSPEND
+	if (state < PM_SUSPEND_MAX)
+		return sprintf(buf, "%s\n", valid_state(state) ?
+						pm_states[state] : "error");
+#endif
+#ifdef CONFIG_HIBERNATION
+	return sprintf(buf, "disk\n");
+#else
+	return sprintf(buf, "error");
+#endif
+}
+
+static ssize_t autosleep_store(struct kobject *kobj,
+			       struct kobj_attribute *attr,
+			       const char *buf, size_t n)
+{
+	suspend_state_t state = decode_state(buf, n);
+	int error;
+
+	if (state == PM_SUSPEND_ON && strncmp(buf, "off", 3)
+	    && strncmp(buf, "off\n", 4))
+		return -EINVAL;
+
+	error = pm_autosleep_set_state(state);
+	return error ? error : n;
+}
+
+power_attr(autosleep);
+#endif /* CONFIG_PM_AUTOSLEEP */
 #endif /* CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_PM_TRACE
@@ -411,6 +478,9 @@ static struct attribute * g[] = {
 #ifdef CONFIG_PM_SLEEP
 	&pm_async_attr.attr,
 	&wakeup_count_attr.attr,
+#ifdef CONFIG_PM_AUTOSLEEP
+	&autosleep_attr.attr,
+#endif
 #ifdef CONFIG_PM_DEBUG
 	&pm_test_attr.attr,
 #endif
@@ -446,7 +516,10 @@ static int __init pm_init(void)
 	power_kobj = kobject_create_and_add("power", NULL);
 	if (!power_kobj)
 		return -ENOMEM;
-	return sysfs_create_group(power_kobj, &attr_group);
+	error = sysfs_create_group(power_kobj, &attr_group);
+	if (error)
+		return error;
+	return pm_autosleep_init();
 }
 
 core_initcall(pm_init);
Index: linux/drivers/base/power/wakeup.c
===================================================================
--- linux.orig/drivers/base/power/wakeup.c
+++ linux/drivers/base/power/wakeup.c
@@ -458,8 +458,10 @@ static void wakeup_source_deactivate(str
 	atomic_add(MAX_IN_PROGRESS, &combined_event_count);
 
 	split_counters(&cnt, &inpr);
-	if (!inpr)
+	if (!inpr) {
 		wake_up_all(&wakeup_count_wait_queue);
+		queue_up_suspend_work();
+	}
 }
 
 /**
@@ -610,29 +612,33 @@ bool pm_wakeup_pending(void)
 /**
  * pm_get_wakeup_count - Read the number of registered wakeup events.
  * @count: Address to store the value at.
+ * @block: Whether or not to block.
  *
- * Store the number of registered wakeup events at the address in @count.  Block
- * if the current number of wakeup events being processed is nonzero.
+ * Store the number of registered wakeup events at the address in @count.  If
+ * @block is set, block until the current number of wakeup events being
+ * processed is zero.
  *
- * Return 'false' if the wait for the number of wakeup events being processed to
- * drop down to zero has been interrupted by a signal (and the current number
- * of wakeup events being processed is still nonzero).  Otherwise return 'true'.
+ * Return 'false' if the current number of wakeup events being processed is
+ * nonzero.  Otherwise return 'true'.
  */
-bool pm_get_wakeup_count(unsigned int *count)
+bool pm_get_wakeup_count(unsigned int *count, bool block)
 {
 	unsigned int cnt, inpr;
-	DEFINE_WAIT(wait);
 
-	for (;;) {
-		prepare_to_wait(&wakeup_count_wait_queue, &wait,
-				TASK_INTERRUPTIBLE);
-		split_counters(&cnt, &inpr);
-		if (inpr == 0 || signal_pending(current))
-			break;
+	if (block) {
+		DEFINE_WAIT(wait);
 
-		schedule();
+		for (;;) {
+			prepare_to_wait(&wakeup_count_wait_queue, &wait,
+					TASK_INTERRUPTIBLE);
+			split_counters(&cnt, &inpr);
+			if (inpr == 0 || signal_pending(current))
+				break;
+
+			schedule();
+		}
+		finish_wait(&wakeup_count_wait_queue, &wait);
 	}
-	finish_wait(&wakeup_count_wait_queue, &wait);
 
 	split_counters(&cnt, &inpr);
 	*count = cnt;
