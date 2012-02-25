Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab2BYU5Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 15:57:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42255 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab2BYU5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 15:57:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 0/7] PM: Implement autosleep and "wake locks", take2
Date: Sat, 25 Feb 2012 22:01:13 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: John Stultz <john.stultz@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <201202070200.55505.rjw@sisk.pl> <201202250021.36738.rjw@sisk.pl> <4F493486.9020202@linux.vnet.ibm.com>
In-Reply-To: <4F493486.9020202@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202252201.13537.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 25, 2012, Srivatsa S. Bhat wrote:
> On 02/25/2012 04:51 AM, Rafael J. Wysocki wrote:
> 
> > On Friday, February 24, 2012, Srivatsa S. Bhat wrote:
> >> On 02/24/2012 03:02 AM, Rafael J. Wysocki wrote:
> >>
> >>> On Thursday, February 23, 2012, Rafael J. Wysocki wrote:
> >>>> On Thursday, February 23, 2012, Srivatsa S. Bhat wrote:
> >>>>> On 02/23/2012 03:40 AM, Rafael J. Wysocki wrote:
> > [...]
> >>>>>
> >>>>> By the way, I am just curious.. how difficult will this make it for userspace
> >>>>> to disable autosleep? I mean, would a trylock mean that the user has to keep
> >>>>> fighting until he finally gets a chance to disable autosleep?
> >>>>
> >>>> That's a good point, so I think it may be a good idea to do
> >>>> mutex_lock_interruptible() in pm_autosleep_set_state() instead.
> >>>
> >>> Now that I think of it, perhaps it's a good idea to just make
> >>> pm_autosleep_lock() do mutex_lock_interruptible() _and_ make
> >>> pm_autosleep_set_state() use pm_autosleep_lock().
> >>>
> >>> What do you think?
> >>>
> >>
> >>
> >> Well, I don't think mutex_lock_interruptible() would help us much..
> >> Consider what would happen, if we use it:
> >>
> >> * pm-suspend got initiated as part of autosleep. Acquired autosleep lock.
> >> * Userspace is about to get frozen.
> >> * Now, the user tries to write "off" to autosleep. And hence, he is waiting
> >>   for autosleep lock, interruptibly.
> >> * The freezer sent a fake signal to all userspace processes and hence
> >>   this process also got interrupted.. it is no longer waiting on autosleep
> >>   lock - it got the signal and returned, and got frozen.
> >>   (And when the userspace gets thawed later, this process won't have the
> >>    autosleep lock - which is a different (but yet another) problem).
> >>
> >> So ultimately the only thing we achieved is to ensure that freezing of
> >> userspace goes smoothly. But the user process could not succeed in
> >> disabling autosleep. Of course we can work around that by having the
> >> mutex_lock_interruptible() in a loop and so on, but that gets very
> >> ugly pretty soon.
> >>
> >> So, I would suggest the following solution:
> >>
> >> We want to achieve 2 things here:
> >>  a. A user process trying to write to /sys/power/state or
> >>     /sys/power/autosleep should not cause freezing failures.
> >>  b. When a user process writes "off" to autosleep, the suspend/hibernate
> >>     attempt that is on-going, if any, must be immediately aborted, to give
> >>     the user the feeling that his preference has been noticed and respected.
> >>
> >> And to achieve this, we note that a user process can write "off" to autosleep
> >> only until the userspace gets frozen. No chance after that.
> >>
> >> So, let's do this:
> >> 1. Drop the autosleep lock before entering pm-suspend/hibernate.
> >> 2. This means, a user process can get hold of this lock and successfully
> >>    disable autosleep a moment after we initiated suspend, but before userspace
> >>    got frozen fully.
> >> 3. So, to respect the user's wish, we add a check immediately after the
> >>    freezing of userspace is complete - we check if the user disabled autosleep
> >>    and bail out, if he did. Otherwise, we continue and suspend the machine.
> >>
> >> IOW, this is like hitting 2 birds with one stone ;-)
> >> We don't hold autosleep lock throughout suspend/hibernate, but still react
> >> instantly when the user disables autosleep. And of course, freezing of tasks
> >> won't fail, ever! :-)
> > 
> > Well, you essentially are postulating to restore the "interface" wakeup source
> > that was present in the previous version of this patch and that I dropped in
> > order to simplify the code.
> > 
> 
> 
> Oh is it? I guess I haven't followed this thread very closely...
> 
> > I guess I can do that ...
> > 
> 
> 
> Oh by the way, this scheme doesn't solve all problems. It might be effective
> in reacting "instantly" to a request by the user to *switch off* autosleep.
> But say, when the user wants to switch to suspend instead of hibernate as the
> autosleep preference, for example, I don't think it would be as quick in
> responding... (I mean, it might do the old operation one more time before
> switching to the new one..)
> 
> But I guess at this point it might be wiser to say "sigh.. we can do only so
> much..." instead of complicating the code too much in an attempt to meet
> everybody's expectations :-)

I think we can do something like in the updated patch [5/7] below.

It uses a special wakeup source object called "autosleep" to bump up the
number of wakeup events in progress before acquiring autosleep_lock in
pm_autosleep_set_state().  This way, either pm_autosleep_set_state() will
acquire autosleep_lock before try_to_suspend(), in which case the latter
will see the change of autosleep_state immediately (after autosleep_lock has
been passed to it), or try_to_suspend() will get it first, but then
pm_save_wakeup_count() or pm_suspend()/hibernate() will see the nonzero counter
of wakeup events in progress and return error code (sooner or later).

The drawback is that writes to /sys/power/autosleep may interfere with
the /sys/power/wakeup_count + /sys/power/state interface by interrupting
transitions started by writing to /sys/power/state, for example (although
I think that's highly unlikely).

Additionally, I made pm_autosleep_lock() use mutex_trylock_interruptible()
to prevent operations on /sys/power/wakeup_count and/or /sys/power/state
from failing the freezing of tasks started by try_to_suspend().

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

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/ABI/testing/sysfs-power |   17 ++++
 drivers/base/power/wakeup.c           |   38 ++++++-----
 include/linux/suspend.h               |   13 +++
 kernel/power/Kconfig                  |    8 ++
 kernel/power/Makefile                 |    1 
 kernel/power/autosleep.c              |  113 ++++++++++++++++++++++++++++++++
 kernel/power/main.c                   |  117 ++++++++++++++++++++++++++++------
 kernel/power/power.h                  |   18 +++++
 8 files changed, 290 insertions(+), 35 deletions(-)

Index: linux/kernel/power/Makefile
===================================================================
--- linux.orig/kernel/power/Makefile
+++ linux/kernel/power/Makefile
@@ -9,5 +9,6 @@ obj-$(CONFIG_SUSPEND)		+= suspend.o
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
@@ -264,3 +264,21 @@ static inline void suspend_thaw_processe
 {
 }
 #endif
+
+#ifdef CONFIG_PM_AUTOSLEEP
+
+/* kernel/power/autosleep.c */
+extern int pm_autosleep_init(void);
+extern int pm_autosleep_lock(void);
+extern void pm_autosleep_unlock(void);
+extern suspend_state_t pm_autosleep_state(void);
+extern int pm_autosleep_set_state(suspend_state_t state);
+
+#else /* !CONFIG_PM_AUTOSLEEP */
+
+static inline int pm_autosleep_init(void) { return 0; }
+static inline int pm_autosleep_lock(void) { return 0; }
+static inline void pm_autosleep_unlock(void) {}
+static inline suspend_state_t pm_autosleep_state(void) { return PM_SUSPEND_ON; }
+
+#endif /* !CONFIG_PM_AUTOSLEEP */
Index: linux/include/linux/suspend.h
===================================================================
--- linux.orig/include/linux/suspend.h
+++ linux/include/linux/suspend.h
@@ -356,7 +356,7 @@ extern int unregister_pm_notifier(struct
 extern bool events_check_enabled;
 
 extern bool pm_wakeup_pending(void);
-extern bool pm_get_wakeup_count(unsigned int *count);
+extern bool pm_get_wakeup_count(unsigned int *count, bool block);
 extern bool pm_save_wakeup_count(unsigned int count);
 
 static inline void lock_system_sleep(void)
@@ -407,6 +407,17 @@ static inline void unlock_system_sleep(v
 
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
@@ -0,0 +1,113 @@
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
+static suspend_state_t autosleep_state;
+static struct workqueue_struct *autosleep_wq;
+static DEFINE_MUTEX(autosleep_lock);
+static struct wakeup_source *autosleep_ws;
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
+int pm_autosleep_lock(void)
+{
+	return mutex_lock_interruptible(&autosleep_lock);
+}
+
+void pm_autosleep_unlock(void)
+{
+	mutex_unlock(&autosleep_lock);
+}
+
+int pm_autosleep_set_state(suspend_state_t state)
+{
+
+#ifndef CONFIG_HIBERNATION
+	if (state >= PM_SUSPEND_MAX)
+		return -EINVAL;
+#endif
+
+	__pm_stay_awake(autosleep_ws);
+
+	mutex_lock(&autosleep_lock);
+
+	autosleep_state = state;
+
+	__pm_relax(autosleep_ws);
+
+	if (state > PM_SUSPEND_ON)
+		queue_up_suspend_work();
+
+	mutex_unlock(&autosleep_lock);
+	return 0;
+}
+
+int __init pm_autosleep_init(void)
+{
+	autosleep_ws = wakeup_source_register("autosleep");
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
@@ -278,27 +277,48 @@ static ssize_t state_store(struct kobjec
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
-	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++) {
-		if (*s && len == strlen(*s) && !strncmp(buf, *s, len)) {
-			error = pm_suspend(state);
-			break;
-		}
-	}
+	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++)
+		if (*s && len == strlen(*s) && !strncmp(buf, *s, len))
+			return state;
 #endif
 
- Exit:
+	return PM_SUSPEND_ON;
+}
+
+static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
+			   const char *buf, size_t n)
+{
+	suspend_state_t state;
+	int error;
+
+	error = pm_autosleep_lock();
+	if (error)
+		return error;
+
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
+	else
+		error = -EINVAL;
+
+ out:
+	pm_autosleep_unlock();
 	return error ? error : n;
 }
 
@@ -339,7 +359,8 @@ static ssize_t wakeup_count_show(struct
 {
 	unsigned int val;
 
-	return pm_get_wakeup_count(&val) ? sprintf(buf, "%u\n", val) : -EINTR;
+	return pm_get_wakeup_count(&val, true) ?
+		sprintf(buf, "%u\n", val) : -EINTR;
 }
 
 static ssize_t wakeup_count_store(struct kobject *kobj,
@@ -347,15 +368,69 @@ static ssize_t wakeup_count_store(struct
 				const char *buf, size_t n)
 {
 	unsigned int val;
+	int error;
+
+	error = pm_autosleep_lock();
+	if (error)
+		return error;
+
+	if (pm_autosleep_state() > PM_SUSPEND_ON) {
+		error = -EBUSY;
+		goto out;
+	}
 
 	if (sscanf(buf, "%u", &val) == 1) {
 		if (pm_save_wakeup_count(val))
 			return n;
 	}
-	return -EINVAL;
+	error = -EINVAL;
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
@@ -409,6 +484,9 @@ static struct attribute * g[] = {
 #ifdef CONFIG_PM_SLEEP
 	&pm_async_attr.attr,
 	&wakeup_count_attr.attr,
+#ifdef CONFIG_PM_AUTOSLEEP
+	&autosleep_attr.attr,
+#endif
 #ifdef CONFIG_PM_DEBUG
 	&pm_test_attr.attr,
 #endif
@@ -444,7 +522,10 @@ static int __init pm_init(void)
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
@@ -492,8 +492,10 @@ static void wakeup_source_deactivate(str
 	atomic_add(MAX_IN_PROGRESS, &combined_event_count);
 
 	split_counters(&cnt, &inpr);
-	if (!inpr && waitqueue_active(&wakeup_count_wait_queue))
+	if (!inpr && waitqueue_active(&wakeup_count_wait_queue)) {
 		wake_up(&wakeup_count_wait_queue);
+		queue_up_suspend_work();
+	}
 }
 
 /**
@@ -654,29 +656,33 @@ bool pm_wakeup_pending(void)
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
Index: linux/Documentation/ABI/testing/sysfs-power
===================================================================
--- linux.orig/Documentation/ABI/testing/sysfs-power
+++ linux/Documentation/ABI/testing/sysfs-power
@@ -172,3 +172,20 @@ Description:
 
 		Reading from this file will display the current value, which is
 		set to 1 MB by default.
+
+What:		/sys/power/autosleep
+Date:		February 2012
+Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Description:
+		The /sys/power/autosleep file can be written one of the strings
+		returned by reads from /sys/power/state.  If that happens, a
+		work item attempting to trigger a transition of the system to
+		the sleep state represented by that string is queued up.  This
+		attempt will only succeed if there are no active wakeup sources
+		in the system at that time.  After evey execution, regardless
+		of whether or not the attempt to put the system to sleep has
+		succeeded, the work item requeues itself until user space
+		writes "off" to /sys/power/autosleep.
+
+		Reading from this file causes the last string successfully
+		written to it to be displayed.
