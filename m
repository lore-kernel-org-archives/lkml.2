Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0F1TDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 15:03:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57314 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896Ab0F1TDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 15:03:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [update] Re: [PATCH] PM: Make it possible to avoid wakeup events from being lost
Date: Mon, 28 Jun 2010 21:01:53 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <640e9920@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Mickler <florian@mickler.org>, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <Pine.LNX.4.44L0.1006281006360.1977-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006281006360.1977-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006282101.54041.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 28, 2010, Alan Stern wrote:
> On Mon, 28 Jun 2010, Rafael J. Wysocki wrote:
> 
> > > > +bool pm_get_wakeup_count(unsigned long *count)
> > > > +{
> > > > +	bool ret;
> > > > +
> > > > +	spin_lock_irq(&events_lock);
> > > > +	if (capable(CAP_SYS_ADMIN))
> > > > +		events_check_enabled = false;
> > > > +
> > > > +	if (events_in_progress) {
> > > > +		DEFINE_WAIT(wait);
> > > > +
> > > > +		do {
> > > > +			prepare_to_wait(&events_wait_queue, &wait,
> > > > +					TASK_INTERRUPTIBLE);
> > > > +			if (!events_in_progress)
> > > > +				break;
> > > > +			spin_unlock_irq(&events_lock);
> > > > +
> > > > +			schedule();
> > > > +
> > > > +			spin_lock_irq(&events_lock);
> > > > +		} while (!signal_pending(current));
> > > > +		finish_wait(&events_wait_queue, &wait);
> > > > +	}
> > > > +	*count = event_count;
> > > > +	ret = !events_in_progress;
> > > > +	spin_unlock_irq(&events_lock);
> > > > +	return ret;
> > > > +}
> > > 
> > > Here's a thought.  Presumably pm_relax() will end up getting called a 
> > > lot more often than pm_get_wakeup_count().  Instead of using a wait 
> > > queue, you could make pm_get_wakeup_count() poll at 100-ms intervals.  
> > > The total overhead would be smaller.
> > 
> > For that I'd need a separate kernel thread or a work item that would reschedule
> > itself periodically, because pm_get_wakeup_count() is only called via
> > /sys/power/wakeup_count.  It would complicate things quite a bit which I'm not
> > sure is worth it at this point.
> 
> What?  All I'm saying is that the do-while loop above should be
> replaced by a loop that sleeps for 100 ms instead of waiting on a
> wait_queue.

Ah, OK.  I didn't understand what you were trying to say.

Below is the patch I'd like to add to suspend-2.6/linux-next.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Make it possible to avoid wakeup events from being lost

One of the arguments during the suspend blockers discussion was that
the mainline kernel didn't contain any mechanisms making it possible
to avoid losing wakeup events during system suspend.

Generally, there are two problems in that area.  First, if a wakeup
event occurs exactly when /sys/power/state is being written to, it
may be delivered to user space right before the freezer kicks in, so
the user space consumer of the event may not be able to process it
before the system is suspended.  Second, if a wakeup event occurs
after user space has been frozen, it is not generally guaranteed that
the ongoing transition of the system into a sleep state will be
aborted.

To address these issues introduce a new global sysfs attribute,
/sys/power/wakeup_count, associated with a running counter of wakeup
events and three helper functions, pm_stay_awake(), pm_relax(), and
pm_wakeup_event(), that may be used by kernel subsystems to control
the behavior of this attribute and to request the PM core to abort
system transitions into a sleep state already in progress.

The /sys/power/wakeup_count file may be read from or written to by
user space.  Reads will always succeed (unless interrupted by a
signal) and return the current value of the wakeup events counter.
Writes, however, will only succeed if the written number is equal to
the current value of the wakeup events counter.  If a write is
successful, it will cause the kernel to save the current value of the
wakeup events counter and to abort the subsequent system transition
into a sleep state if any wakeup events are reported after the write
has returned.

[The assumption is that before writing to /sys/power/state user space
will first read from /sys/power/wakeup_count.  Next, user space
consumers of wakeup events will have a chance to acknowledge or
veto the upcoming system transition to a sleep state.  Finally, if
the transition is allowed to proceed, /sys/power/wakeup_count will
be written to and if that succeeds, /sys/power/state will be written
to as well.  Still, if any wakeup events are reported to the PM core
by kernel subsystems after that point, the transition will be
aborted.]

Additionally, put a wakeup events counter into struct dev_pm_info and
make these per-device wakeup event counters available via sysfs,
so that it's possible to check the activity of various wakeup event
sources within the kernel.

To illustrate how subsystems can use pm_wakeup_event(), make the
low-level PCI runtime PM wakeup-handling code use it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/ABI/testing/sysfs-power |   15 ++
 drivers/base/power/Makefile           |    2 
 drivers/base/power/main.c             |    1 
 drivers/base/power/sysfs.c            |   11 +
 drivers/base/power/wakeup.c           |  229 ++++++++++++++++++++++++++++++++++
 drivers/pci/pci-acpi.c                |    1 
 drivers/pci/pci.c                     |   20 ++
 drivers/pci/pci.h                     |    1 
 drivers/pci/pcie/pme/pcie_pme.c       |    5 
 include/linux/pm.h                    |   10 +
 include/linux/suspend.h               |    7 +
 kernel/power/hibernate.c              |   20 ++
 kernel/power/main.c                   |   53 +++++++
 kernel/power/suspend.c                |    4 
 14 files changed, 369 insertions(+), 10 deletions(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -204,6 +204,58 @@ static ssize_t state_store(struct kobjec
 
 power_attr(state);
 
+/*
+ * The 'wakeup_count' attribute, along with the functions defined in
+ * drivers/base/power/wakeup.c, provides a means by which wakeup events can be
+ * handled in a non-racy way.
+ *
+ * If a wakeup event occurs when the system is in a sleep state, it simply is
+ * woken up.  In turn, if an event that would wake the system up from a sleep
+ * state occurs when it is undergoing a transition to that sleep state, the
+ * transition should be aborted.  Moreover, if such an event occurs when the
+ * system is in the working state, an attempt to start a transition to the
+ * given sleep state should fail during certain period after the detection of
+ * the event.  Using the 'state' attribute alone is not sufficient to satisfy
+ * these requirements, because a wakeup event may occur exactly when 'state'
+ * is being written to and may be delivered to user space right before it is
+ * frozen, so the event will remain only partially processed until the system is
+ * woken up by another event.  In particular, it won't cause the transition to
+ * a sleep state to be aborted.
+ *
+ * This difficulty may be overcome if user space uses 'wakeup_count' before
+ * writing to 'state'.  It first should read from 'wakeup_count' and store
+ * the read value.  Then, after carrying out its own preparations for the system
+ * transition to a sleep state, it should write the stored value to
+ * 'wakeup_count'.  If that fails, at least one wakeup event has occured since
+ * 'wakeup_count' was read and 'state' should not be written to.  Otherwise, it
+ * is allowed to write to 'state', but the transition will be aborted if there
+ * are any wakeup events detected after 'wakeup_count' was written to.
+ */
+
+static ssize_t wakeup_count_show(struct kobject *kobj,
+				struct kobj_attribute *attr,
+				char *buf)
+{
+	unsigned long val;
+
+	return pm_get_wakeup_count(&val) ? sprintf(buf, "%lu\n", val) : -EINTR;
+}
+
+static ssize_t wakeup_count_store(struct kobject *kobj,
+				struct kobj_attribute *attr,
+				const char *buf, size_t n)
+{
+	unsigned long val;
+
+	if (sscanf(buf, "%lu", &val) == 1) {
+		if (pm_save_wakeup_count(val))
+			return n;
+	}
+	return -EINVAL;
+}
+
+power_attr(wakeup_count);
+
 #ifdef CONFIG_PM_TRACE
 int pm_trace_enabled;
 
@@ -236,6 +288,7 @@ static struct attribute * g[] = {
 #endif
 #ifdef CONFIG_PM_SLEEP
 	&pm_async_attr.attr,
+	&wakeup_count_attr.attr,
 #ifdef CONFIG_PM_DEBUG
 	&pm_test_attr.attr,
 #endif
Index: linux-2.6/drivers/base/power/wakeup.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/base/power/wakeup.c
@@ -0,0 +1,229 @@
+/*
+ * drivers/base/power/wakeup.c - System wakeup events framework
+ *
+ * Copyright (c) 2010 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/capability.h>
+#include <linux/suspend.h>
+#include <linux/pm.h>
+
+/*
+ * If set, the suspend/hibernate code will abort transitions to a sleep state
+ * if wakeup events are registered during or immediately before the transition.
+ */
+bool events_check_enabled;
+
+/* The counter of registered wakeup events. */
+static unsigned long event_count;
+/* A preserved old value of event_count. */
+static unsigned long saved_event_count;
+/* The counter of wakeup events being processed. */
+static unsigned long events_in_progress;
+
+static DEFINE_SPINLOCK(events_lock);
+
+/*
+ * The functions below use the observation that each wakeup event starts a
+ * period in which the system should not be suspended.  The moment this period
+ * will end depends on how the wakeup event is going to be processed after being
+ * detected and all of the possible cases can be divided into two distinct
+ * groups.
+ *
+ * First, a wakeup event may be detected by the same functional unit that will
+ * carry out the entire processing of it and possibly will pass it to user space
+ * for further processing.  In that case the functional unit that has detected
+ * the event may later "close" the "no suspend" period associated with it
+ * directly as soon as it has been dealt with.  The pair of pm_stay_awake() and
+ * pm_relax(), balanced with each other, is supposed to be used in such
+ * situations.
+ *
+ * Second, a wakeup event may be detected by one functional unit and processed
+ * by another one.  In that case the unit that has detected it cannot really
+ * "close" the "no suspend" period associated with it, unless it knows in
+ * advance what's going to happen to the event during processing.  This
+ * knowledge, however, may not be available to it, so it can simply specify time
+ * to wait before the system can be suspended and pass it as the second
+ * argument of pm_wakeup_event().
+ */
+
+/**
+ * pm_stay_awake - Notify the PM core that a wakeup event is being processed.
+ * @dev: Device the wakeup event is related to.
+ *
+ * Notify the PM core of a wakeup event (signaled by @dev) by incrementing the
+ * counter of wakeup events being processed.  If @dev is not NULL, the counter
+ * of wakeup events related to @dev is incremented too.
+ *
+ * Call this function after detecting of a wakeup event if pm_relax() is going
+ * to be called directly after processing the event (and possibly passing it to
+ * user space for further processing).
+ *
+ * It is safe to call this function from interrupt context.
+ */
+void pm_stay_awake(struct device *dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&events_lock, flags);
+	if (dev)
+		dev->power.wakeup_count++;
+
+	events_in_progress++;
+	spin_unlock_irqrestore(&events_lock, flags);
+}
+
+/**
+ * pm_relax - Notify the PM core that processing of a wakeup event has ended.
+ *
+ * Notify the PM core that a wakeup event has been processed by decrementing
+ * the counter of wakeup events being processed and incrementing the counter
+ * of registered wakeup events.
+ *
+ * Call this function for wakeup events whose processing started with calling
+ * pm_stay_awake().
+ *
+ * It is safe to call it from interrupt context.
+ */
+void pm_relax(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&events_lock, flags);
+	if (events_in_progress) {
+		events_in_progress--;
+		event_count++;
+	}
+	spin_unlock_irqrestore(&events_lock, flags);
+}
+
+/**
+ * pm_wakeup_work_fn - Deferred closing of a wakeup event.
+ *
+ * Execute pm_relax() for a wakeup event detected in the past and free the
+ * work item object used for queuing up the work.
+ */
+static void pm_wakeup_work_fn(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+
+	pm_relax();
+	kfree(dwork);
+}
+
+/**
+ * pm_wakeup_event - Notify the PM core of a wakeup event.
+ * @dev: Device the wakeup event is related to.
+ * @msec: Anticipated event processing time (in milliseconds).
+ *
+ * Notify the PM core of a wakeup event (signaled by @dev) that will take
+ * approximately @msec milliseconds to be processed by the kernel.  Increment
+ * the counter of wakeup events being processed and queue up a work item
+ * that will execute pm_relax() for the event after @msec milliseconds.  If @dev
+ * is not NULL, the counter of wakeup events related to @dev is incremented too.
+ *
+ * It is safe to call this function from interrupt context.
+ */
+void pm_wakeup_event(struct device *dev, unsigned int msec)
+{
+	unsigned long flags;
+	struct delayed_work *dwork;
+
+	dwork = msec ? kzalloc(sizeof(*dwork), GFP_ATOMIC) : NULL;
+
+	spin_lock_irqsave(&events_lock, flags);
+	if (dev)
+		dev->power.wakeup_count++;
+
+	if (dwork) {
+		INIT_DELAYED_WORK(dwork, pm_wakeup_work_fn);
+		schedule_delayed_work(dwork, msecs_to_jiffies(msec));
+
+		events_in_progress++;
+	} else {
+		event_count++;
+	}
+	spin_unlock_irqrestore(&events_lock, flags);
+}
+
+/**
+ * pm_check_wakeup_events - Check for new wakeup events.
+ *
+ * Compare the current number of registered wakeup events with its preserved
+ * value from the past to check if new wakeup events have been registered since
+ * the old value was stored.  Check if the current number of wakeup events being
+ * processed is zero.
+ */
+bool pm_check_wakeup_events(void)
+{
+	unsigned long flags;
+	bool ret = true;
+
+	spin_lock_irqsave(&events_lock, flags);
+	if (events_check_enabled) {
+		ret = (event_count == saved_event_count) && !events_in_progress;
+		events_check_enabled = ret;
+	}
+	spin_unlock_irqrestore(&events_lock, flags);
+	return ret;
+}
+
+/**
+ * pm_get_wakeup_count - Read the number of registered wakeup events.
+ * @count: Address to store the value at.
+ *
+ * Store the number of registered wakeup events at the address in @count.  Block
+ * if the current number of wakeup events being processed is nonzero.
+ *
+ * Return false if the wait for the number of wakeup events being processed to
+ * drop down to zero has been interrupted by a signal (and the current number
+ * of wakeup events being processed is still nonzero).  Otherwise return true.
+ */
+bool pm_get_wakeup_count(unsigned long *count)
+{
+	bool ret;
+
+	spin_lock_irq(&events_lock);
+	if (capable(CAP_SYS_ADMIN))
+		events_check_enabled = false;
+
+	while (events_in_progress && !signal_pending(current)) {
+		spin_unlock_irq(&events_lock);
+
+		schedule_timeout_interruptible(msecs_to_jiffies(100));
+
+		spin_lock_irq(&events_lock);
+	}
+	*count = event_count;
+	ret = !events_in_progress;
+	spin_unlock_irq(&events_lock);
+	return ret;
+}
+
+/**
+ * pm_save_wakeup_count - Save the current number of registered wakeup events.
+ * @count: Value to compare with the current number of registered wakeup events.
+ *
+ * If @count is equal to the current number of registered wakeup events and the
+ * current number of wakeup events being processed is zero, store @count as the
+ * old number of registered wakeup events to be used by pm_check_wakeup_events()
+ * and return true.  Otherwise return false.
+ */
+bool pm_save_wakeup_count(unsigned long count)
+{
+	bool ret = false;
+
+	spin_lock_irq(&events_lock);
+	if (count == event_count && !events_in_progress) {
+		saved_event_count = count;
+		events_check_enabled = true;
+		ret = true;
+	}
+	spin_unlock_irq(&events_lock);
+	return ret;
+}
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -457,6 +457,7 @@ struct dev_pm_info {
 #ifdef CONFIG_PM_SLEEP
 	struct list_head	entry;
 	struct completion	completion;
+	unsigned long		wakeup_count;
 #endif
 #ifdef CONFIG_PM_RUNTIME
 	struct timer_list	suspend_timer;
@@ -552,6 +553,11 @@ extern void __suspend_report_result(cons
 	} while (0)
 
 extern void device_pm_wait_for_dev(struct device *sub, struct device *dev);
+
+/* drivers/base/power/wakeup.c */
+extern void pm_wakeup_event(struct device *dev, unsigned int msec);
+extern void pm_stay_awake(struct device *dev);
+extern void pm_relax(void);
 #else /* !CONFIG_PM_SLEEP */
 
 #define device_pm_lock() do {} while (0)
@@ -565,6 +571,10 @@ static inline int dpm_suspend_start(pm_m
 #define suspend_report_result(fn, ret)		do {} while (0)
 
 static inline void device_pm_wait_for_dev(struct device *a, struct device *b) {}
+
+static inline void pm_wakeup_event(struct device *dev, unsigned int msec) {}
+static inline void pm_stay_awake(struct device *dev) {}
+static inline void pm_relax(void) {}
 #endif /* !CONFIG_PM_SLEEP */
 
 /* How to reorder dpm_list after device_move() */
Index: linux-2.6/drivers/base/power/Makefile
===================================================================
--- linux-2.6.orig/drivers/base/power/Makefile
+++ linux-2.6/drivers/base/power/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_PM)	+= sysfs.o
-obj-$(CONFIG_PM_SLEEP)	+= main.o
+obj-$(CONFIG_PM_SLEEP)	+= main.o wakeup.o
 obj-$(CONFIG_PM_RUNTIME)	+= runtime.o
 obj-$(CONFIG_PM_OPS)	+= generic_ops.o
 obj-$(CONFIG_PM_TRACE_RTC)	+= trace.o
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -59,6 +59,7 @@ void device_pm_init(struct device *dev)
 {
 	dev->power.status = DPM_ON;
 	init_completion(&dev->power.completion);
+	dev->power.wakeup_count = 0;
 	pm_runtime_init(dev);
 }
 
Index: linux-2.6/kernel/power/suspend.c
===================================================================
--- linux-2.6.orig/kernel/power/suspend.c
+++ linux-2.6/kernel/power/suspend.c
@@ -172,8 +172,10 @@ static int suspend_enter(suspend_state_t
 
 	error = sysdev_suspend(PMSG_SUSPEND);
 	if (!error) {
-		if (!suspend_test(TEST_CORE))
+		if (!suspend_test(TEST_CORE) && pm_check_wakeup_events()) {
 			error = suspend_ops->enter(state);
+			events_check_enabled = false;
+		}
 		sysdev_resume();
 	}
 
Index: linux-2.6/kernel/power/hibernate.c
===================================================================
--- linux-2.6.orig/kernel/power/hibernate.c
+++ linux-2.6/kernel/power/hibernate.c
@@ -277,7 +277,7 @@ static int create_image(int platform_mod
 		goto Enable_irqs;
 	}
 
-	if (hibernation_test(TEST_CORE))
+	if (hibernation_test(TEST_CORE) || !pm_check_wakeup_events())
 		goto Power_up;
 
 	in_suspend = 1;
@@ -288,8 +288,10 @@ static int create_image(int platform_mod
 			error);
 	/* Restore control flow magically appears here */
 	restore_processor_state();
-	if (!in_suspend)
+	if (!in_suspend) {
+		events_check_enabled = false;
 		platform_leave(platform_mode);
+	}
 
  Power_up:
 	sysdev_resume();
@@ -511,14 +513,20 @@ int hibernation_platform_enter(void)
 
 	local_irq_disable();
 	sysdev_suspend(PMSG_HIBERNATE);
+	if (!pm_check_wakeup_events()) {
+		error = -EAGAIN;
+		goto Power_up;
+	}
+
 	hibernation_ops->enter();
 	/* We should never get here */
 	while (1);
 
-	/*
-	 * We don't need to reenable the nonboot CPUs or resume consoles, since
-	 * the system is going to be halted anyway.
-	 */
+ Power_up:
+	sysdev_resume();
+	local_irq_enable();
+	enable_nonboot_cpus();
+
  Platform_finish:
 	hibernation_ops->finish();
 
Index: linux-2.6/drivers/pci/pci-acpi.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-acpi.c
+++ linux-2.6/drivers/pci/pci-acpi.c
@@ -48,6 +48,7 @@ static void pci_acpi_wake_dev(acpi_handl
 	if (event == ACPI_NOTIFY_DEVICE_WAKE && pci_dev) {
 		pci_check_pme_status(pci_dev);
 		pm_runtime_resume(&pci_dev->dev);
+		pci_wakeup_event(pci_dev);
 		if (pci_dev->subordinate)
 			pci_pme_wakeup_bus(pci_dev->subordinate);
 	}
Index: linux-2.6/drivers/pci/pcie/pme/pcie_pme.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/pme/pcie_pme.c
+++ linux-2.6/drivers/pci/pcie/pme/pcie_pme.c
@@ -154,6 +154,7 @@ static bool pcie_pme_walk_bus(struct pci
 		/* Skip PCIe devices in case we started from a root port. */
 		if (!pci_is_pcie(dev) && pci_check_pme_status(dev)) {
 			pm_request_resume(&dev->dev);
+			pci_wakeup_event(dev);
 			ret = true;
 		}
 
@@ -254,8 +255,10 @@ static void pcie_pme_handle_request(stru
 	if (found) {
 		/* The device is there, but we have to check its PME status. */
 		found = pci_check_pme_status(dev);
-		if (found)
+		if (found) {
 			pm_request_resume(&dev->dev);
+			pci_wakeup_event(dev);
+		}
 		pci_dev_put(dev);
 	} else if (devfn) {
 		/*
Index: linux-2.6/drivers/base/power/sysfs.c
===================================================================
--- linux-2.6.orig/drivers/base/power/sysfs.c
+++ linux-2.6/drivers/base/power/sysfs.c
@@ -73,6 +73,8 @@
  *	device are known to the PM core.  However, for some devices this
  *	attribute is set to "enabled" by bus type code or device drivers and in
  *	that cases it should be safe to leave the default value.
+ *
+ *	wakeup_count - Report the number of wakeup events related to the device
  */
 
 static const char enabled[] = "enabled";
@@ -144,6 +146,14 @@ wake_store(struct device * dev, struct d
 
 static DEVICE_ATTR(wakeup, 0644, wake_show, wake_store);
 
+static ssize_t wakeup_count_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%lu\n", dev->power.wakeup_count);
+}
+
+static DEVICE_ATTR(wakeup_count, 0444, wakeup_count_show, NULL);
+
 #ifdef CONFIG_PM_ADVANCED_DEBUG
 #ifdef CONFIG_PM_RUNTIME
 
@@ -230,6 +240,7 @@ static struct attribute * power_attrs[] 
 	&dev_attr_control.attr,
 #endif
 	&dev_attr_wakeup.attr,
+	&dev_attr_wakeup_count.attr,
 #ifdef CONFIG_PM_ADVANCED_DEBUG
 	&dev_attr_async.attr,
 #ifdef CONFIG_PM_RUNTIME
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -56,6 +56,7 @@ extern void pci_update_current_state(str
 extern void pci_disable_enabled_device(struct pci_dev *dev);
 extern bool pci_check_pme_status(struct pci_dev *dev);
 extern int pci_finish_runtime_suspend(struct pci_dev *dev);
+extern void pci_wakeup_event(struct pci_dev *dev);
 extern int __pci_pme_wakeup(struct pci_dev *dev, void *ign);
 extern void pci_pme_wakeup_bus(struct pci_bus *bus);
 extern void pci_pm_init(struct pci_dev *dev);
Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1275,6 +1275,22 @@ bool pci_check_pme_status(struct pci_dev
 	return ret;
 }
 
+/*
+ * Time to wait before the system can be put into a sleep state after reporting
+ * a wakeup event signaled by a PCI device.
+ */
+#define PCI_WAKEUP_COOLDOWN	100
+
+/**
+ * pci_wakeup_event - Report a wakeup event related to a given PCI device.
+ * @dev: Device to report the wakeup event for.
+ */
+void pci_wakeup_event(struct pci_dev *dev)
+{
+	if (device_may_wakeup(&dev->dev))
+		pm_wakeup_event(&dev->dev, PCI_WAKEUP_COOLDOWN);
+}
+
 /**
  * pci_pme_wakeup - Wake up a PCI device if its PME Status bit is set.
  * @dev: Device to handle.
@@ -1285,8 +1301,10 @@ bool pci_check_pme_status(struct pci_dev
  */
 static int pci_pme_wakeup(struct pci_dev *dev, void *ign)
 {
-	if (pci_check_pme_status(dev))
+	if (pci_check_pme_status(dev)) {
 		pm_request_resume(&dev->dev);
+		pci_wakeup_event(dev);
+	}
 	return 0;
 }
 
Index: linux-2.6/include/linux/suspend.h
===================================================================
--- linux-2.6.orig/include/linux/suspend.h
+++ linux-2.6/include/linux/suspend.h
@@ -295,6 +295,13 @@ extern int unregister_pm_notifier(struct
 		{ .notifier_call = fn, .priority = pri };	\
 	register_pm_notifier(&fn##_nb);			\
 }
+
+/* drivers/base/power/wakeup.c */
+extern bool events_check_enabled;
+
+extern bool pm_check_wakeup_events(void);
+extern bool pm_get_wakeup_count(unsigned long *count);
+extern bool pm_save_wakeup_count(unsigned long count);
 #else /* !CONFIG_PM_SLEEP */
 
 static inline int register_pm_notifier(struct notifier_block *nb)
Index: linux-2.6/Documentation/ABI/testing/sysfs-power
===================================================================
--- linux-2.6.orig/Documentation/ABI/testing/sysfs-power
+++ linux-2.6/Documentation/ABI/testing/sysfs-power
@@ -114,3 +114,18 @@ Description:
 		if this file contains "1", which is the default.  It may be
 		disabled by writing "0" to this file, in which case all devices
 		will be suspended and resumed synchronously.
+
+What:		/sys/power/wakeup_count
+Date:		July 2010
+Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Description:
+		The /sys/power/wakeup_count file allows user space to put the
+		system into a sleep state while taking into account the
+		concurrent arrival of wakeup events.  Reading from it returns
+		the current number of registered wakeup events and it blocks if
+		some wakeup events are being processed at the time the file is
+		read from.  Writing to it will only succeed if the current
+		number of wakeup events is equal to the written value and, if
+		successful, will make the kernel abort a subsequent transition
+		to a sleep state if any wakeup events are reported after the
+		write has returned.
