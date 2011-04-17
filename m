Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab1DQVRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 17:17:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57798 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab1DQVQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 17:16:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/14] PM: Remove sysdev suspend, resume and shutdown operations
Date: Sun, 17 Apr 2011 23:15:08 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, linux-arm-kernel@lists.infradead.org,
        Ben Dooks <ben-linux@fluff.org>, Mike Frysinger <vapier@gentoo.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, Jiri Kosina <jkosina@suse.cz>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
References: <201103280125.11750.rjw@sisk.pl> <201104172301.54115.rjw@sisk.pl>
In-Reply-To: <201104172301.54115.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104172315.08769.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since suspend, resume and shutdown operations in struct sysdev_class
and struct sysdev_driver are not used any more, remove them.  Also
drop sysdev_suspend(), sysdev_resume() and sysdev_shutdown() used
for executing those operations and modify all of their users
accordingly.  This reduces kernel code size quite a bit and reduces
its complexity.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/sh/Kconfig          |    1 
 arch/x86/Kconfig         |    1 
 arch/x86/kernel/apm_32.c |    4 
 drivers/base/Kconfig     |    7 -
 drivers/base/base.h      |    2 
 drivers/base/sys.c       |  202 -----------------------------------------------
 drivers/xen/manage.c     |    8 -
 include/linux/device.h   |    7 -
 include/linux/pm.h       |    8 -
 include/linux/sysdev.h   |   11 --
 kernel/kexec.c           |    9 --
 kernel/power/hibernate.c |   18 ----
 kernel/power/suspend.c   |    8 -
 kernel/sys.c             |    3 
 14 files changed, 7 insertions(+), 282 deletions(-)

Index: linux-2.6/drivers/base/sys.c
===================================================================
--- linux-2.6.orig/drivers/base/sys.c
+++ linux-2.6/drivers/base/sys.c
@@ -328,203 +328,8 @@ void sysdev_unregister(struct sys_device
 	kobject_put(&sysdev->kobj);
 }
 
-
-#ifndef CONFIG_ARCH_NO_SYSDEV_OPS
-/**
- *	sysdev_shutdown - Shut down all system devices.
- *
- *	Loop over each class of system devices, and the devices in each
- *	of those classes. For each device, we call the shutdown method for
- *	each driver registered for the device - the auxiliaries,
- *	and the class driver.
- *
- *	Note: The list is iterated in reverse order, so that we shut down
- *	child devices before we shut down their parents. The list ordering
- *	is guaranteed by virtue of the fact that child devices are registered
- *	after their parents.
- */
-void sysdev_shutdown(void)
-{
-	struct sysdev_class *cls;
-
-	pr_debug("Shutting Down System Devices\n");
-
-	mutex_lock(&sysdev_drivers_lock);
-	list_for_each_entry_reverse(cls, &system_kset->list, kset.kobj.entry) {
-		struct sys_device *sysdev;
-
-		pr_debug("Shutting down type '%s':\n",
-			 kobject_name(&cls->kset.kobj));
-
-		list_for_each_entry(sysdev, &cls->kset.list, kobj.entry) {
-			struct sysdev_driver *drv;
-			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
-
-			/* Call auxiliary drivers first */
-			list_for_each_entry(drv, &cls->drivers, entry) {
-				if (drv->shutdown)
-					drv->shutdown(sysdev);
-			}
-
-			/* Now call the generic one */
-			if (cls->shutdown)
-				cls->shutdown(sysdev);
-		}
-	}
-	mutex_unlock(&sysdev_drivers_lock);
-}
-
-static void __sysdev_resume(struct sys_device *dev)
-{
-	struct sysdev_class *cls = dev->cls;
-	struct sysdev_driver *drv;
-
-	/* First, call the class-specific one */
-	if (cls->resume)
-		cls->resume(dev);
-	WARN_ONCE(!irqs_disabled(),
-		"Interrupts enabled after %pF\n", cls->resume);
-
-	/* Call auxiliary drivers next. */
-	list_for_each_entry(drv, &cls->drivers, entry) {
-		if (drv->resume)
-			drv->resume(dev);
-		WARN_ONCE(!irqs_disabled(),
-			"Interrupts enabled after %pF\n", drv->resume);
-	}
-}
-
-/**
- *	sysdev_suspend - Suspend all system devices.
- *	@state:		Power state to enter.
- *
- *	We perform an almost identical operation as sysdev_shutdown()
- *	above, though calling ->suspend() instead. Interrupts are disabled
- *	when this called. Devices are responsible for both saving state and
- *	quiescing or powering down the device.
- *
- *	This is only called by the device PM core, so we let them handle
- *	all synchronization.
- */
-int sysdev_suspend(pm_message_t state)
-{
-	struct sysdev_class *cls;
-	struct sys_device *sysdev, *err_dev;
-	struct sysdev_driver *drv, *err_drv;
-	int ret;
-
-	pr_debug("Checking wake-up interrupts\n");
-
-	/* Return error code if there are any wake-up interrupts pending */
-	ret = check_wakeup_irqs();
-	if (ret)
-		return ret;
-
-	WARN_ONCE(!irqs_disabled(),
-		"Interrupts enabled while suspending system devices\n");
-
-	pr_debug("Suspending System Devices\n");
-
-	list_for_each_entry_reverse(cls, &system_kset->list, kset.kobj.entry) {
-		pr_debug("Suspending type '%s':\n",
-			 kobject_name(&cls->kset.kobj));
-
-		list_for_each_entry(sysdev, &cls->kset.list, kobj.entry) {
-			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
-
-			/* Call auxiliary drivers first */
-			list_for_each_entry(drv, &cls->drivers, entry) {
-				if (drv->suspend) {
-					ret = drv->suspend(sysdev, state);
-					if (ret)
-						goto aux_driver;
-				}
-				WARN_ONCE(!irqs_disabled(),
-					"Interrupts enabled after %pF\n",
-					drv->suspend);
-			}
-
-			/* Now call the generic one */
-			if (cls->suspend) {
-				ret = cls->suspend(sysdev, state);
-				if (ret)
-					goto cls_driver;
-				WARN_ONCE(!irqs_disabled(),
-					"Interrupts enabled after %pF\n",
-					cls->suspend);
-			}
-		}
-	}
-	return 0;
-	/* resume current sysdev */
-cls_driver:
-	drv = NULL;
-	printk(KERN_ERR "Class suspend failed for %s: %d\n",
-		kobject_name(&sysdev->kobj), ret);
-
-aux_driver:
-	if (drv)
-		printk(KERN_ERR "Class driver suspend failed for %s: %d\n",
-				kobject_name(&sysdev->kobj), ret);
-	list_for_each_entry(err_drv, &cls->drivers, entry) {
-		if (err_drv == drv)
-			break;
-		if (err_drv->resume)
-			err_drv->resume(sysdev);
-	}
-
-	/* resume other sysdevs in current class */
-	list_for_each_entry(err_dev, &cls->kset.list, kobj.entry) {
-		if (err_dev == sysdev)
-			break;
-		pr_debug(" %s\n", kobject_name(&err_dev->kobj));
-		__sysdev_resume(err_dev);
-	}
-
-	/* resume other classes */
-	list_for_each_entry_continue(cls, &system_kset->list, kset.kobj.entry) {
-		list_for_each_entry(err_dev, &cls->kset.list, kobj.entry) {
-			pr_debug(" %s\n", kobject_name(&err_dev->kobj));
-			__sysdev_resume(err_dev);
-		}
-	}
-	return ret;
-}
-EXPORT_SYMBOL_GPL(sysdev_suspend);
-
-/**
- *	sysdev_resume - Bring system devices back to life.
- *
- *	Similar to sysdev_suspend(), but we iterate the list forwards
- *	to guarantee that parent devices are resumed before their children.
- *
- *	Note: Interrupts are disabled when called.
- */
-int sysdev_resume(void)
-{
-	struct sysdev_class *cls;
-
-	WARN_ONCE(!irqs_disabled(),
-		"Interrupts enabled while resuming system devices\n");
-
-	pr_debug("Resuming System Devices\n");
-
-	list_for_each_entry(cls, &system_kset->list, kset.kobj.entry) {
-		struct sys_device *sysdev;
-
-		pr_debug("Resuming type '%s':\n",
-			 kobject_name(&cls->kset.kobj));
-
-		list_for_each_entry(sysdev, &cls->kset.list, kobj.entry) {
-			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
-
-			__sysdev_resume(sysdev);
-		}
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(sysdev_resume);
-#endif /* CONFIG_ARCH_NO_SYSDEV_OPS */
+EXPORT_SYMBOL_GPL(sysdev_register);
+EXPORT_SYMBOL_GPL(sysdev_unregister);
 
 int __init system_bus_init(void)
 {
@@ -534,9 +339,6 @@ int __init system_bus_init(void)
 	return 0;
 }
 
-EXPORT_SYMBOL_GPL(sysdev_register);
-EXPORT_SYMBOL_GPL(sysdev_unregister);
-
 #define to_ext_attr(x) container_of(x, struct sysdev_ext_attribute, attr)
 
 ssize_t sysdev_store_ulong(struct sys_device *sysdev,
Index: linux-2.6/kernel/power/suspend.c
===================================================================
--- linux-2.6.orig/kernel/power/suspend.c
+++ linux-2.6/kernel/power/suspend.c
@@ -163,19 +163,13 @@ static int suspend_enter(suspend_state_t
 	arch_suspend_disable_irqs();
 	BUG_ON(!irqs_disabled());
 
-	error = sysdev_suspend(PMSG_SUSPEND);
-	if (!error) {
-		error = syscore_suspend();
-		if (error)
-			sysdev_resume();
-	}
+	error = syscore_suspend();
 	if (!error) {
 		if (!(suspend_test(TEST_CORE) || pm_wakeup_pending())) {
 			error = suspend_ops->enter(state);
 			events_check_enabled = false;
 		}
 		syscore_resume();
-		sysdev_resume();
 	}
 
 	arch_suspend_enable_irqs();
Index: linux-2.6/kernel/power/hibernate.c
===================================================================
--- linux-2.6.orig/kernel/power/hibernate.c
+++ linux-2.6/kernel/power/hibernate.c
@@ -272,12 +272,7 @@ static int create_image(int platform_mod
 
 	local_irq_disable();
 
-	error = sysdev_suspend(PMSG_FREEZE);
-	if (!error) {
-		error = syscore_suspend();
-		if (error)
-			sysdev_resume();
-	}
+	error = syscore_suspend();
 	if (error) {
 		printk(KERN_ERR "PM: Some system devices failed to power down, "
 			"aborting hibernation\n");
@@ -302,7 +297,6 @@ static int create_image(int platform_mod
 
  Power_up:
 	syscore_resume();
-	sysdev_resume();
 	/* NOTE:  dpm_resume_noirq() is just a resume() for devices
 	 * that suspended with irqs off ... no overall powerup.
 	 */
@@ -409,12 +403,7 @@ static int resume_target_kernel(bool pla
 
 	local_irq_disable();
 
-	error = sysdev_suspend(PMSG_QUIESCE);
-	if (!error) {
-		error = syscore_suspend();
-		if (error)
-			sysdev_resume();
-	}
+	error = syscore_suspend();
 	if (error)
 		goto Enable_irqs;
 
@@ -442,7 +431,6 @@ static int resume_target_kernel(bool pla
 	touch_softlockup_watchdog();
 
 	syscore_resume();
-	sysdev_resume();
 
  Enable_irqs:
 	local_irq_enable();
@@ -528,7 +516,6 @@ int hibernation_platform_enter(void)
 		goto Platform_finish;
 
 	local_irq_disable();
-	sysdev_suspend(PMSG_HIBERNATE);
 	syscore_suspend();
 	if (pm_wakeup_pending()) {
 		error = -EAGAIN;
@@ -541,7 +528,6 @@ int hibernation_platform_enter(void)
 
  Power_up:
 	syscore_resume();
-	sysdev_resume();
 	local_irq_enable();
 	enable_nonboot_cpus();
 
Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c
+++ linux-2.6/kernel/kexec.c
@@ -1531,13 +1531,7 @@ int kernel_kexec(void)
 		if (error)
 			goto Enable_cpus;
 		local_irq_disable();
-		/* Suspend system devices */
-		error = sysdev_suspend(PMSG_FREEZE);
-		if (!error) {
-			error = syscore_suspend();
-			if (error)
-				sysdev_resume();
-		}
+		error = syscore_suspend();
 		if (error)
 			goto Enable_irqs;
 	} else
@@ -1553,7 +1547,6 @@ int kernel_kexec(void)
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
 		syscore_resume();
-		sysdev_resume();
  Enable_irqs:
 		local_irq_enable();
  Enable_cpus:
Index: linux-2.6/drivers/xen/manage.c
===================================================================
--- linux-2.6.orig/drivers/xen/manage.c
+++ linux-2.6/drivers/xen/manage.c
@@ -70,12 +70,7 @@ static int xen_suspend(void *data)
 
 	BUG_ON(!irqs_disabled());
 
-	err = sysdev_suspend(PMSG_FREEZE);
-	if (!err) {
-		err = syscore_suspend();
-		if (err)
-			sysdev_resume();
-	}
+	err = syscore_suspend();
 	if (err) {
 		printk(KERN_ERR "xen_suspend: system core suspend failed: %d\n",
 			err);
@@ -102,7 +97,6 @@ static int xen_suspend(void *data)
 	}
 
 	syscore_resume();
-	sysdev_resume();
 
 	return 0;
 }
Index: linux-2.6/kernel/sys.c
===================================================================
--- linux-2.6.orig/kernel/sys.c
+++ linux-2.6/kernel/sys.c
@@ -315,7 +315,6 @@ void kernel_restart_prepare(char *cmd)
 	blocking_notifier_call_chain(&reboot_notifier_list, SYS_RESTART, cmd);
 	system_state = SYSTEM_RESTART;
 	device_shutdown();
-	sysdev_shutdown();
 	syscore_shutdown();
 }
 
@@ -354,7 +353,6 @@ static void kernel_shutdown_prepare(enum
 void kernel_halt(void)
 {
 	kernel_shutdown_prepare(SYSTEM_HALT);
-	sysdev_shutdown();
 	syscore_shutdown();
 	printk(KERN_EMERG "System halted.\n");
 	kmsg_dump(KMSG_DUMP_HALT);
@@ -374,7 +372,6 @@ void kernel_power_off(void)
 	if (pm_power_off_prepare)
 		pm_power_off_prepare();
 	disable_nonboot_cpus();
-	sysdev_shutdown();
 	syscore_shutdown();
 	printk(KERN_EMERG "Power down.\n");
 	kmsg_dump(KMSG_DUMP_POWEROFF);
Index: linux-2.6/drivers/base/base.h
===================================================================
--- linux-2.6.orig/drivers/base/base.h
+++ linux-2.6/drivers/base/base.h
@@ -111,8 +111,6 @@ static inline int driver_match_device(st
 	return drv->bus->match ? drv->bus->match(dev, drv) : 1;
 }
 
-extern void sysdev_shutdown(void);
-
 extern char *make_class_name(const char *name, struct kobject *kobj);
 
 extern int devres_release_all(struct device *dev);
Index: linux-2.6/include/linux/device.h
===================================================================
--- linux-2.6.orig/include/linux/device.h
+++ linux-2.6/include/linux/device.h
@@ -633,13 +633,6 @@ static inline int devtmpfs_mount(const c
 /* drivers/base/power/shutdown.c */
 extern void device_shutdown(void);
 
-#ifndef CONFIG_ARCH_NO_SYSDEV_OPS
-/* drivers/base/sys.c */
-extern void sysdev_shutdown(void);
-#else
-static inline void sysdev_shutdown(void) { }
-#endif
-
 /* debugging and troubleshooting/diagnostic helpers. */
 extern const char *dev_driver_string(const struct device *dev);
 
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -530,14 +530,6 @@ struct dev_power_domain {
  */
 
 #ifdef CONFIG_PM_SLEEP
-#ifndef CONFIG_ARCH_NO_SYSDEV_OPS
-extern int sysdev_suspend(pm_message_t state);
-extern int sysdev_resume(void);
-#else
-static inline int sysdev_suspend(pm_message_t state) { return 0; }
-static inline int sysdev_resume(void) { return 0; }
-#endif
-
 extern void device_pm_lock(void);
 extern void dpm_resume_noirq(pm_message_t state);
 extern void dpm_resume_end(pm_message_t state);
Index: linux-2.6/arch/x86/kernel/apm_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apm_32.c
+++ linux-2.6/arch/x86/kernel/apm_32.c
@@ -1238,7 +1238,6 @@ static int suspend(int vetoable)
 	dpm_suspend_noirq(PMSG_SUSPEND);
 
 	local_irq_disable();
-	sysdev_suspend(PMSG_SUSPEND);
 	syscore_suspend();
 
 	local_irq_enable();
@@ -1258,7 +1257,6 @@ static int suspend(int vetoable)
 	err = (err == APM_SUCCESS) ? 0 : -EIO;
 
 	syscore_resume();
-	sysdev_resume();
 	local_irq_enable();
 
 	dpm_resume_noirq(PMSG_RESUME);
@@ -1282,7 +1280,6 @@ static void standby(void)
 	dpm_suspend_noirq(PMSG_SUSPEND);
 
 	local_irq_disable();
-	sysdev_suspend(PMSG_SUSPEND);
 	syscore_suspend();
 	local_irq_enable();
 
@@ -1292,7 +1289,6 @@ static void standby(void)
 
 	local_irq_disable();
 	syscore_resume();
-	sysdev_resume();
 	local_irq_enable();
 
 	dpm_resume_noirq(PMSG_RESUME);
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -71,7 +71,6 @@ config X86
 	select GENERIC_IRQ_SHOW
 	select IRQ_FORCED_THREADING
 	select USE_GENERIC_SMP_HELPERS if SMP
-	select ARCH_NO_SYSDEV_OPS
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
Index: linux-2.6/arch/sh/Kconfig
===================================================================
--- linux-2.6.orig/arch/sh/Kconfig
+++ linux-2.6/arch/sh/Kconfig
@@ -24,7 +24,6 @@ config SUPERH
 	select RTC_LIB
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_SHOW
-	select ARCH_NO_SYSDEV_OPS
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
Index: linux-2.6/drivers/base/Kconfig
===================================================================
--- linux-2.6.orig/drivers/base/Kconfig
+++ linux-2.6/drivers/base/Kconfig
@@ -168,11 +168,4 @@ config SYS_HYPERVISOR
 	bool
 	default n
 
-config ARCH_NO_SYSDEV_OPS
-	bool
-	---help---
-	  To be selected by architectures that don't use sysdev class or
-	  sysdev driver power management (suspend/resume) and shutdown
-	  operations.
-
 endmenu
Index: linux-2.6/include/linux/sysdev.h
===================================================================
--- linux-2.6.orig/include/linux/sysdev.h
+++ linux-2.6/include/linux/sysdev.h
@@ -34,12 +34,6 @@ struct sysdev_class {
 	struct list_head	drivers;
 	struct sysdev_class_attribute **attrs;
 	struct kset		kset;
-#ifndef CONFIG_ARCH_NO_SYSDEV_OPS
-	/* Default operations for these types of devices */
-	int	(*shutdown)(struct sys_device *);
-	int	(*suspend)(struct sys_device *, pm_message_t state);
-	int	(*resume)(struct sys_device *);
-#endif
 };
 
 struct sysdev_class_attribute {
@@ -77,11 +71,6 @@ struct sysdev_driver {
 	struct list_head	entry;
 	int	(*add)(struct sys_device *);
 	int	(*remove)(struct sys_device *);
-#ifndef CONFIG_ARCH_NO_SYSDEV_OPS
-	int	(*shutdown)(struct sys_device *);
-	int	(*suspend)(struct sys_device *, pm_message_t state);
-	int	(*resume)(struct sys_device *);
-#endif
 };
 
 

