Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab0FXXCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 19:02:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47107 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab0FXXCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 19:02:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [update 3] Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Date: Fri, 25 Jun 2010 01:00:13 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Florian Mickler <florian@mickler.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
References: <Pine.LNX.4.44L0.1006241132410.1654-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006241132410.1654-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006250100.14166.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 24, 2010, Alan Stern wrote:
> On Thu, 24 Jun 2010, Rafael J. Wysocki wrote:
> 
> > Ah, one piece is missing.  Namely, the waiting /sys/power/wakeup_count reader
> > needs to be woken up when events_in_progress goes down to zero.
> 
> It also needs to abort immediately if a signal is received.

Right.

So, there it goes.

I decided not to play with memory allocations at this point, because I really
don't expect pm_wakeup_event() to be heavily used initially.  If there are more
users and it's called more frequently, we can always switch to using a separate
slab cache.

Hopefully, I haven't overlooked anything vitally important this time.

Please tell me what you think.

Rafael

---
 drivers/base/power/Makefile     |    2 
 drivers/base/power/main.c       |    1 
 drivers/base/power/power.h      |    3 
 drivers/base/power/sysfs.c      |    9 ++
 drivers/base/power/wakeup.c     |  143 ++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci-acpi.c          |    1 
 drivers/pci/pci.c               |   10 ++
 drivers/pci/pci.h               |    3 
 drivers/pci/pcie/pme/pcie_pme.c |    5 +
 include/linux/pm.h              |   10 ++
 kernel/power/hibernate.c        |   22 ++++--
 kernel/power/main.c             |   26 +++++++
 kernel/power/power.h            |    9 ++
 kernel/power/suspend.c          |    4 -
 14 files changed, 237 insertions(+), 11 deletions(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -204,6 +204,30 @@ static ssize_t state_store(struct kobjec
 
 power_attr(state);
 
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
 
@@ -236,6 +260,7 @@ static struct attribute * g[] = {
 #endif
 #ifdef CONFIG_PM_SLEEP
 	&pm_async_attr.attr,
+	&wakeup_count_attr.attr,
 #ifdef CONFIG_PM_DEBUG
 	&pm_test_attr.attr,
 #endif
@@ -266,6 +291,7 @@ static int __init pm_init(void)
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
@@ -0,0 +1,143 @@
+
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/capability.h>
+#include <linux/pm.h>
+
+bool events_check_enabled;
+
+static unsigned long event_count;
+static unsigned long saved_event_count;
+static unsigned long events_in_progress;
+static spinlock_t events_lock;
+static DECLARE_WAIT_QUEUE_HEAD(events_wait_queue);
+
+void pm_wakeup_events_init(void)
+{
+	spin_lock_init(&events_lock);
+}
+
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
+void pm_relax(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&events_lock, flags);
+	if (events_in_progress) {
+		event_count++;
+		if (!--events_in_progress)
+			wake_up_all(&events_wait_queue);
+	}
+	spin_unlock_irqrestore(&events_lock, flags);
+}
+
+static void pm_wakeup_work_fn(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+
+	pm_relax();
+	kfree(dwork);
+}
+
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
+
+bool pm_get_wakeup_count(unsigned long *count)
+{
+	bool ret;
+
+	spin_lock_irq(&events_lock);
+	if (capable(CAP_SYS_ADMIN))
+		events_check_enabled = false;
+
+	if (events_in_progress) {
+		DEFINE_WAIT(wait);
+
+		do {
+			prepare_to_wait(&events_wait_queue, &wait,
+					TASK_INTERRUPTIBLE);
+			if (!events_in_progress)
+				break;
+			spin_unlock_irq(&events_lock);
+
+			schedule();
+
+			spin_lock_irq(&events_lock);
+		} while (!signal_pending(current));
+		finish_wait(&events_wait_queue, &wait);
+	}
+	*count = event_count;
+	ret = !events_in_progress;
+	spin_unlock_irq(&events_lock);
+	return ret;
+}
+
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
 
Index: linux-2.6/kernel/power/power.h
===================================================================
--- linux-2.6.orig/kernel/power/power.h
+++ linux-2.6/kernel/power/power.h
@@ -184,6 +184,15 @@ static inline void suspend_test_finish(c
 #ifdef CONFIG_PM_SLEEP
 /* kernel/power/main.c */
 extern int pm_notifier_call_chain(unsigned long val);
+
+/* drivers/base/power/wakeup.c */
+extern bool events_check_enabled;
+
+extern void pm_wakeup_events_init(void);
+extern bool pm_check_wakeup_events(void);
+extern bool pm_check_wakeup_events_final(void);
+extern bool pm_get_wakeup_count(unsigned long *count);
+extern bool pm_save_wakeup_count(unsigned long count);
 #endif
 
 #ifdef CONFIG_HIGHMEM
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
@@ -511,18 +513,24 @@ int hibernation_platform_enter(void)
 
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
 
-	dpm_suspend_noirq(PMSG_RESTORE);
+	dpm_resume_noirq(PMSG_RESTORE);
 
  Resume_devices:
 	entering_platform_hibernation = false;
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
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -6,6 +6,8 @@
 #define PCI_CFG_SPACE_SIZE	256
 #define PCI_CFG_SPACE_EXP_SIZE	4096
 
+#define PCI_WAKEUP_COOLDOWN	100
+
 /* Functions internal to the PCI core code */
 
 extern int pci_uevent(struct device *dev, struct kobj_uevent_env *env);
@@ -56,6 +58,7 @@ extern void pci_update_current_state(str
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
@@ -1275,6 +1275,12 @@ bool pci_check_pme_status(struct pci_dev
 	return ret;
 }
 
+void pci_wakeup_event(struct pci_dev *dev)
+{
+	if (device_may_wakeup(&dev->dev))
+		pm_wakeup_event(&dev->dev, PCI_WAKEUP_COOLDOWN);
+}
+
 /**
  * pci_pme_wakeup - Wake up a PCI device if its PME Status bit is set.
  * @dev: Device to handle.
@@ -1285,8 +1291,10 @@ bool pci_check_pme_status(struct pci_dev
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
 
