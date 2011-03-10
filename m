Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1CJLas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 06:30:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45574 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab1CJLaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 06:30:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [RFC][Update][PATCH 1/2] Introduce struct syscore_ops and related functionality
Date: Thu, 10 Mar 2011 12:30:45 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, mingo@redhat.com,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        tglx@linutronix.de
References: <Pine.LNX.4.44L0.1103092224480.3620-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1103092224480.3620-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103101230.45569.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 10, 2011, Alan Stern wrote:
> On Thu, 10 Mar 2011, Rafael J. Wysocki wrote:
> 
> > Some subsystems need to carry out suspend/resume and shutdown
> > operations with one CPU on-line and interrupts disabled.  The only
> > way to register such operations is to define a sysdev class and
> > a sysdev specifically for this purpose which is cumbersome and
> > inefficient.  Moreover, the arguments taken by sysdev suspend,
> > resume and shutdown callbacks are practically never necessary.
> > 
> > For this reason, introduce a simpler interface allowing subsystems
> > to register operations to be executed very late during system suspend
> > and shutdown and very early during resume in the form of
> > strcut syscore_ops objects.
> 
> ...
> 
> > Index: linux-2.6/drivers/base/syscore.c
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6/drivers/base/syscore.c
> 
> It's true that the existing sys.c file lies in drivers/base; this is
> presumably because it handles a bunch of class-related registration
> stuff.  Now you're getting rid of all that, leaving just the
> power-related operations, so doesn't it make more sense to put this
> file in drivers/base/power?
> 
> > +/**
> > + * syscore_suspend - Execute all the registered system core suspend callbacks.
> > + *
> > + * This function is executed with one CPU on-line and disabled interrupts.
> > + */
> > +int syscore_suspend(void)
> > +{
> > +	struct syscore_ops *ops;
> > +
> > +	list_for_each_entry_reverse(ops, &syscore_ops_list, node)
> > +		if (ops->suspend) {
> > +			int ret = ops->suspend();
> > +			if (ret) {
> > +				pr_err("PM: System core suspend callback "
> > +					"%pF failed.\n", ops->suspend);
> > +				return ret;
> 
> If an error occurs, you need to go back and resume all the things that
> were suspended.  At least, that's what the code in sysdev_suspend does.
> 
> > +			}
> > +		}
> > +
> > +	return 0;
> > +}

Below is a new version of the patch.  I've taken your comment on the failing
suspend into account, fix the list traversal direction in syscore_shutdown()
and added some debug statements.

Thanks,
Rafael

---
Some subsystems need to carry out suspend/resume and shutdown
operations with one CPU on-line and interrupts disabled.  The only
way to register such operations is to define a sysdev class and
a sysdev specifically for this purpose which is cumbersome and
inefficient.  Moreover, the arguments taken by sysdev suspend,
resume and shutdown callbacks are practically never necessary.

For this reason, introduce a simpler interface allowing subsystems
to register operations to be executed very late during system suspend
and shutdown and very early during resume in the form of
strcut syscore_ops objects.

---
 drivers/base/Makefile       |    2 
 drivers/base/syscore.c      |  107 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/syscore_ops.h |   29 +++++++++++
 kernel/power/hibernate.c    |    9 +++
 kernel/power/suspend.c      |    4 +
 kernel/sys.c                |    4 +
 6 files changed, 154 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/syscore_ops.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/syscore_ops.h
@@ -0,0 +1,29 @@
+/*
+ *  syscore_ops.h - System core operations.
+ *
+ *  Copyright (C) 2011 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ *
+ *  This file is released under the GPLv2.
+ */
+
+#ifndef _LINUX_SYSCORE_OPS_H
+#define _LINUX_SYSCORE_OPS_H
+
+#include <linux/list.h>
+
+struct syscore_ops {
+	struct list_head node;
+	int (*suspend)(void);
+	void (*resume)(void);
+	void (*shutdown)(void);
+};
+
+extern void register_syscore_ops(struct syscore_ops *ops);
+extern void unregister_syscore_ops(struct syscore_ops *ops);
+#ifdef CONFIG_PM_SLEEP
+extern int syscore_suspend(void);
+extern void syscore_resume(void);
+#endif
+extern void syscore_shutdown(void);
+
+#endif
Index: linux-2.6/drivers/base/syscore.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/base/syscore.c
@@ -0,0 +1,107 @@
+/*
+ *  syscore.c - Execution of system core operations.
+ *
+ *  Copyright (C) 2011 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ *
+ *  This file is released under the GPLv2.
+ */
+
+#include <linux/syscore_ops.h>
+#include <linux/mutex.h>
+#include <linux/module.h>
+
+static LIST_HEAD(syscore_ops_list);
+static DEFINE_MUTEX(syscore_ops_lock);
+
+/**
+ * register_syscore_ops - Register a set of system core operations.
+ * @ops: System core operations to register.
+ */
+void register_syscore_ops(struct syscore_ops *ops)
+{
+	mutex_lock(&syscore_ops_lock);
+	list_add_tail(&ops->node, &syscore_ops_list);
+	mutex_unlock(&syscore_ops_lock);
+}
+EXPORT_SYMBOL_GPL(register_syscore_ops);
+
+/**
+ * unregister_syscore_ops - Unregister a set of system core operations.
+ * @ops: System core operations to unregister.
+ */
+void unregister_syscore_ops(struct syscore_ops *ops)
+{
+	mutex_lock(&syscore_ops_lock);
+	list_del(&ops->node);
+	mutex_unlock(&syscore_ops_lock);
+}
+EXPORT_SYMBOL_GPL(unregister_syscore_ops);
+
+#ifdef CONFIG_PM_SLEEP
+/**
+ * syscore_suspend - Execute all the registered system core suspend callbacks.
+ *
+ * This function is executed with one CPU on-line and disabled interrupts.
+ */
+int syscore_suspend(void)
+{
+	struct syscore_ops *ops;
+	int ret = 0;
+
+	list_for_each_entry_reverse(ops, &syscore_ops_list, node)
+		if (ops->suspend) {
+			if (initcall_debug)
+				pr_info("PM: Calling %pF\n", ops->suspend);
+			ret = ops->suspend();
+			if (ret)
+				goto err_out;
+		}
+
+	return 0;
+
+ err_out:
+	pr_err("PM: System core suspend callback %pF failed.\n", ops->suspend);
+
+	list_for_each_entry_continue(ops, &syscore_ops_list, node)
+		if (ops->resume)
+			ops->resume();
+
+	return ret;
+}
+
+/**
+ * syscore_resume - Execute all the registered system core resume callbacks.
+ *
+ * This function is executed with one CPU on-line and disabled interrupts.
+ */
+void syscore_resume(void)
+{
+	struct syscore_ops *ops;
+
+	list_for_each_entry(ops, &syscore_ops_list, node)
+		if (ops->resume) {
+			if (initcall_debug)
+				pr_info("PM: Calling %pF\n", ops->resume);
+			ops->resume();
+		}
+}
+#endif /* CONFIG_PM_SLEEP */
+
+/**
+ * syscore_shutdown - Execute all the registered system core shutdown callbacks.
+ */
+void syscore_shutdown(void)
+{
+	struct syscore_ops *ops;
+
+	mutex_lock(&syscore_ops_lock);
+
+	list_for_each_entry_reverse(ops, &syscore_ops_list, node)
+		if (ops->shutdown) {
+			if (initcall_debug)
+				pr_info("PM: Calling %pF\n", ops->shutdown);
+			ops->shutdown();
+		}
+
+	mutex_unlock(&syscore_ops_lock);
+}
Index: linux-2.6/kernel/power/suspend.c
===================================================================
--- linux-2.6.orig/kernel/power/suspend.c
+++ linux-2.6/kernel/power/suspend.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
+#include <linux/syscore_ops.h>
 #include <trace/events/power.h>
 
 #include "power.h"
@@ -163,11 +164,14 @@ static int suspend_enter(suspend_state_t
 	BUG_ON(!irqs_disabled());
 
 	error = sysdev_suspend(PMSG_SUSPEND);
+	if (!error)
+		error = syscore_suspend();
 	if (!error) {
 		if (!(suspend_test(TEST_CORE) || pm_wakeup_pending())) {
 			error = suspend_ops->enter(state);
 			events_check_enabled = false;
 		}
+		syscore_resume();
 		sysdev_resume();
 	}
 
Index: linux-2.6/kernel/power/hibernate.c
===================================================================
--- linux-2.6.orig/kernel/power/hibernate.c
+++ linux-2.6/kernel/power/hibernate.c
@@ -23,6 +23,7 @@
 #include <linux/cpu.h>
 #include <linux/freezer.h>
 #include <linux/gfp.h>
+#include <linux/syscore_ops.h>
 #include <scsi/scsi_scan.h>
 #include <asm/suspend.h>
 
@@ -272,6 +273,8 @@ static int create_image(int platform_mod
 	local_irq_disable();
 
 	error = sysdev_suspend(PMSG_FREEZE);
+	if (!error)
+		error = syscore_suspend();
 	if (error) {
 		printk(KERN_ERR "PM: Some system devices failed to power down, "
 			"aborting hibernation\n");
@@ -295,6 +298,7 @@ static int create_image(int platform_mod
 	}
 
  Power_up:
+	syscore_resume();
 	sysdev_resume();
 	/* NOTE:  dpm_resume_noirq() is just a resume() for devices
 	 * that suspended with irqs off ... no overall powerup.
@@ -403,6 +407,8 @@ static int resume_target_kernel(bool pla
 	local_irq_disable();
 
 	error = sysdev_suspend(PMSG_QUIESCE);
+	if (!error)
+		error = syscore_suspend();
 	if (error)
 		goto Enable_irqs;
 
@@ -429,6 +435,7 @@ static int resume_target_kernel(bool pla
 	restore_processor_state();
 	touch_softlockup_watchdog();
 
+	syscore_resume();
 	sysdev_resume();
 
  Enable_irqs:
@@ -516,6 +523,7 @@ int hibernation_platform_enter(void)
 
 	local_irq_disable();
 	sysdev_suspend(PMSG_HIBERNATE);
+	syscore_suspend();
 	if (pm_wakeup_pending()) {
 		error = -EAGAIN;
 		goto Power_up;
@@ -526,6 +534,7 @@ int hibernation_platform_enter(void)
 	while (1);
 
  Power_up:
+	syscore_resume();
 	sysdev_resume();
 	local_irq_enable();
 	enable_nonboot_cpus();
Index: linux-2.6/kernel/sys.c
===================================================================
--- linux-2.6.orig/kernel/sys.c
+++ linux-2.6/kernel/sys.c
@@ -37,6 +37,7 @@
 #include <linux/ptrace.h>
 #include <linux/fs_struct.h>
 #include <linux/gfp.h>
+#include <linux/syscore_ops.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -298,6 +299,7 @@ void kernel_restart_prepare(char *cmd)
 	system_state = SYSTEM_RESTART;
 	device_shutdown();
 	sysdev_shutdown();
+	syscore_shutdown();
 }
 
 /**
@@ -336,6 +338,7 @@ void kernel_halt(void)
 {
 	kernel_shutdown_prepare(SYSTEM_HALT);
 	sysdev_shutdown();
+	syscore_shutdown();
 	printk(KERN_EMERG "System halted.\n");
 	kmsg_dump(KMSG_DUMP_HALT);
 	machine_halt();
@@ -355,6 +358,7 @@ void kernel_power_off(void)
 		pm_power_off_prepare();
 	disable_nonboot_cpus();
 	sysdev_shutdown();
+	syscore_shutdown();
 	printk(KERN_EMERG "Power down.\n");
 	kmsg_dump(KMSG_DUMP_POWEROFF);
 	machine_power_off();
Index: linux-2.6/drivers/base/Makefile
===================================================================
--- linux-2.6.orig/drivers/base/Makefile
+++ linux-2.6/drivers/base/Makefile
@@ -1,6 +1,6 @@
 # Makefile for the Linux device tree
 
-obj-y			:= core.o sys.o bus.o dd.o \
+obj-y			:= core.o sys.o bus.o dd.o syscore.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
 			   attribute_container.o transport_class.o
