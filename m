Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab0FVUBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 16:01:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38914 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab0FVUBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 16:01:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [update] Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Date: Tue, 22 Jun 2010 21:59:27 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Florian Mickler <florian@mickler.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
References: <Pine.LNX.4.44L0.1006220952290.1631-100000@iolanthe.rowland.org> <201006221735.10467.rjw@sisk.pl>
In-Reply-To: <201006221735.10467.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006222159.28081.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 22, 2010, Rafael J. Wysocki wrote:
> On Tuesday, June 22, 2010, Alan Stern wrote:
> > On Tue, 22 Jun 2010, Rafael J. Wysocki wrote:
... 
> > > So, even if we can say when the kernel has finished processing the event
> > > (although that would be complicated in the PCIe case above), I don't think
> > > it's generally possible to ensure that the entire processing of a wakeup event
> > > has been completed.  This leads to the question whether or not it is worth
> > > trying to detect the ending of the processing of a wakeup event.
> > 
> > As Arve pointed out, in some cases it definitely is worthwhile (the
> > gpio keypad matrix example).  In other cases there may be no reasonable
> > way to tell.  That doesn't mean we have to give up entirely.
> 
> Well, I'm not sure, because that really depends on the hardware and bus in
> question.  The necessary condition seems to be that the event be detected
> and handled entirely by the same functional unit (eg. a device driver) within
> the kernel and such that it is able to detect whether or not user space has
> acquired the event information.  That doesn't seem to be a common case to me.

Anyway, below's an update that addresses this particular case.

It adds two more functions, pm_wakeup_begin() and pm_wakeup_end()
that play similar roles to suspend_block() and suspend_unblock(), but they
don't operate on suspend blocker objects.  Instead, the first of them increases
a counter of events in progress and the other one decreases this counter.
Together they have the same effect as pm_wakeup_event(), but the counter
of wakeup events in progress they operate on is also checked by
pm_check_wakeup_events().

Thus there are two ways kernel subsystems can signal wakeup events.  First,
if the event is not explicitly handed over to user space and "instantaneous",
they can simply call pm_wakeup_event() and be done with it.  Second, if the
event is going to be delivered to user space, the subsystem that processes
the event can call pm_wakeup_begin() right when the event is detected and
pm_wakeup_end() when it's been handed over to user space.

Please tell me what you think.

Rafael

---
 drivers/base/power/Makefile     |    2 
 drivers/base/power/main.c       |    1 
 drivers/base/power/power.h      |    3 +
 drivers/base/power/sysfs.c      |    9 +++
 drivers/base/power/wakeup.c     |  113 ++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci-acpi.c          |    2 
 drivers/pci/pcie/pme/pcie_pme.c |    2 
 include/linux/pm.h              |   10 +++
 kernel/power/hibernate.c        |   14 +++-
 kernel/power/main.c             |   24 ++++++++
 kernel/power/power.h            |    7 ++
 kernel/power/suspend.c          |    2 
 12 files changed, 182 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -204,6 +204,28 @@ static ssize_t state_store(struct kobjec
 
 power_attr(state);
 
+static ssize_t wakeup_count_show(struct kobject *kobj,
+				struct kobj_attribute *attr,
+				char *buf)
+{
+	return sprintf(buf, "%lu\n", pm_get_wakeup_count());
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
 
@@ -236,6 +258,7 @@ static struct attribute * g[] = {
 #endif
 #ifdef CONFIG_PM_SLEEP
 	&pm_async_attr.attr,
+	&wakeup_count_attr.attr,
 #ifdef CONFIG_PM_DEBUG
 	&pm_test_attr.attr,
 #endif
@@ -266,6 +289,7 @@ static int __init pm_init(void)
 	int error = pm_start_workqueue();
 	if (error)
 		return error;
+	pm_wakeup_events_init();
 	power_kobj = kobject_create_and_add("power", NULL);
 	if (!power_kobj)
 		return -ENOMEM;
Index: linux-2.6/drivers/base/power/wakeup.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/base/power/wakeup.c
@@ -0,0 +1,113 @@
+
+#include <linux/device.h>
+#include <linux/pm.h>
+
+static unsigned long event_count;
+static unsigned long saved_event_count;
+static unsigned long events_in_progress;
+static bool events_check_enabled;
+static spinlock_t events_lock;
+
+void pm_wakeup_events_init(void)
+{
+	spin_lock_init(&events_lock);
+}
+
+void pm_wakeup_event(struct device *dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&events_lock, flags);
+	event_count++;
+	if (dev)
+		dev->power.wakeup_count++;
+	spin_unlock_irqrestore(&events_lock, flags);
+}
+
+void pm_wakeup_begin(struct device *dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&events_lock, flags);
+	events_in_progress++;
+	if (dev)
+		dev->power.wakeup_count++;
+	spin_unlock_irqrestore(&events_lock, flags);
+}
+
+void pm_wakeup_end(void)
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
+static bool check_wakeup_events(void)
+{
+	return !events_check_enabled
+		|| ((event_count == saved_event_count) && !events_in_progress);
+}
+
+bool pm_check_wakeup_events(void)
+{
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&events_lock, flags);
+	ret = check_wakeup_events();
+	events_check_enabled = ret;
+	spin_unlock_irqrestore(&events_lock, flags);
+	return ret;
+}
+
+bool pm_check_wakeup_events_final(void)
+{
+	bool ret;
+
+	ret = check_wakeup_events();
+	events_check_enabled = false;
+	return ret;
+}
+
+unsigned long pm_get_wakeup_count(void)
+{
+	unsigned long flags;
+	unsigned long count;
+
+	spin_lock_irqsave(&events_lock, flags);
+	events_check_enabled = false;
+	count = event_count;
+	spin_unlock_irqrestore(&events_lock, flags);
+	return count;
+}
+
+bool pm_save_wakeup_count(unsigned long count)
+{
+	unsigned long flags;
+	bool ret = false;
+
+	spin_lock_irqsave(&events_lock, flags);
+	if (count == event_count) {
+		saved_event_count = count;
+		events_check_enabled = true;
+		ret = true;
+	}
+	spin_unlock_irqrestore(&events_lock, flags);
+	return ret;
+}
+
+unsigned long pm_dev_wakeup_count(struct device *dev)
+{
+	unsigned long flags;
+	unsigned long count;
+
+	spin_lock_irqsave(&events_lock, flags);
+	count = dev->power.wakeup_count;
+	spin_unlock_irqrestore(&events_lock, flags);
+	return count;
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
+extern void pm_wakeup_event(struct device *dev);
+extern void pm_wakeup_begin(struct device *dev);
+extern void pm_wakeup_end(void);
 #else /* !CONFIG_PM_SLEEP */
 
 #define device_pm_lock() do {} while (0)
@@ -565,6 +571,10 @@ static inline int dpm_suspend_start(pm_m
 #define suspend_report_result(fn, ret)		do {} while (0)
 
 static inline void device_pm_wait_for_dev(struct device *a, struct device *b) {}
+
+static inline void pm_wakeup_event(struct device *dev) {}
+static inline void pm_wakeup_begin(struct device *dev) {}
+static inline void pm_wakeup_end(void) {}
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
 
Index: linux-2.6/kernel/power/power.h
===================================================================
--- linux-2.6.orig/kernel/power/power.h
+++ linux-2.6/kernel/power/power.h
@@ -184,6 +184,13 @@ static inline void suspend_test_finish(c
 #ifdef CONFIG_PM_SLEEP
 /* kernel/power/main.c */
 extern int pm_notifier_call_chain(unsigned long val);
+
+/* drivers/base/power/wakeup.c */
+extern void pm_wakeup_events_init(void);
+extern bool pm_check_wakeup_events(void);
+extern bool pm_check_wakeup_events_final(void);
+extern unsigned long pm_get_wakeup_count(void);
+extern bool pm_save_wakeup_count(unsigned long count);
 #endif
 
 #ifdef CONFIG_HIGHMEM
Index: linux-2.6/kernel/power/suspend.c
===================================================================
--- linux-2.6.orig/kernel/power/suspend.c
+++ linux-2.6/kernel/power/suspend.c
@@ -172,7 +172,7 @@ static int suspend_enter(suspend_state_t
 
 	error = sysdev_suspend(PMSG_SUSPEND);
 	if (!error) {
-		if (!suspend_test(TEST_CORE))
+		if (!suspend_test(TEST_CORE) && pm_check_wakeup_events_final())
 			error = suspend_ops->enter(state);
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
@@ -511,14 +511,18 @@ int hibernation_platform_enter(void)
 
 	local_irq_disable();
 	sysdev_suspend(PMSG_HIBERNATE);
+	if (!pm_check_wakeup_events_final())
+		goto Power_up;
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
@@ -48,6 +48,8 @@ static void pci_acpi_wake_dev(acpi_handl
 	if (event == ACPI_NOTIFY_DEVICE_WAKE && pci_dev) {
 		pci_check_pme_status(pci_dev);
 		pm_runtime_resume(&pci_dev->dev);
+		if (device_may_wakeup(&pci_dev->dev))
+			pm_wakeup_event(&pci_dev->dev);
 		if (pci_dev->subordinate)
 			pci_pme_wakeup_bus(pci_dev->subordinate);
 	}
Index: linux-2.6/drivers/pci/pcie/pme/pcie_pme.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/pme/pcie_pme.c
+++ linux-2.6/drivers/pci/pcie/pme/pcie_pme.c
@@ -154,6 +154,8 @@ static bool pcie_pme_walk_bus(struct pci
 		/* Skip PCIe devices in case we started from a root port. */
 		if (!pci_is_pcie(dev) && pci_check_pme_status(dev)) {
 			pm_request_resume(&dev->dev);
+			if (device_may_wakeup(&dev->dev))
+				pm_wakeup_event(&dev->dev);
 			ret = true;
 		}
 
Index: linux-2.6/drivers/base/power/power.h
===================================================================
--- linux-2.6.orig/drivers/base/power/power.h
+++ linux-2.6/drivers/base/power/power.h
@@ -30,6 +30,9 @@ extern void device_pm_move_before(struct
 extern void device_pm_move_after(struct device *, struct device *);
 extern void device_pm_move_last(struct device *);
 
+/* drivers/base/power/wakeup.c */
+extern unsigned long pm_dev_wakeup_count(struct device *dev);
+
 #else /* !CONFIG_PM_SLEEP */
 
 static inline void device_pm_init(struct device *dev)
Index: linux-2.6/drivers/base/power/sysfs.c
===================================================================
--- linux-2.6.orig/drivers/base/power/sysfs.c
+++ linux-2.6/drivers/base/power/sysfs.c
@@ -144,6 +144,14 @@ wake_store(struct device * dev, struct d
 
 static DEVICE_ATTR(wakeup, 0644, wake_show, wake_store);
 
+static ssize_t wakeup_count_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%lu\n", pm_dev_wakeup_count(dev));
+}
+
+static DEVICE_ATTR(wakeup_count, 0444, wakeup_count_show, NULL);
+
 #ifdef CONFIG_PM_ADVANCED_DEBUG
 #ifdef CONFIG_PM_RUNTIME
 
@@ -230,6 +238,7 @@ static struct attribute * power_attrs[] 
 	&dev_attr_control.attr,
 #endif
 	&dev_attr_wakeup.attr,
+	&dev_attr_wakeup_count.attr,
 #ifdef CONFIG_PM_ADVANCED_DEBUG
 	&dev_attr_async.attr,
 #ifdef CONFIG_PM_RUNTIME
