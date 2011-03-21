Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab1CUXjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:39:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51892 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242Ab1CUXjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:39:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 6/6] Introduce ARCH_NO_SYSDEV_OPS config option (v2)
Date: Tue, 22 Mar 2011 00:38:49 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        cpufreq@vger.kernel.org
References: <201103100131.58206.rjw@sisk.pl> <201103122212.40828.rjw@sisk.pl> <201103220031.22729.rjw@sisk.pl>
In-Reply-To: <201103220031.22729.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103220038.49425.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce Kconfig option allowing architectures where sysdev
operations used during system suspend, resume and shutdown have been
completely replaced with struct sycore_ops operations to avoid
building sysdev code that will never be used.

Make callbacks in struct sys_device and struct sysdev_driver depend
on ARCH_NO_SYSDEV_OPS to allows us to verify if all of the references
have been actually removed from the code the given architecture
depends on.

Make x86 select ARCH_NO_SYSDEV_OPS.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/Kconfig       |    1 +
 drivers/base/Kconfig   |    7 +++++++
 drivers/base/sys.c     |    3 ++-
 include/linux/device.h |    4 ++++
 include/linux/pm.h     |   10 ++++++++--
 include/linux/sysdev.h |    7 +++++--
 6 files changed, 27 insertions(+), 5 deletions(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -529,13 +529,19 @@ struct dev_power_domain {
  */
 
 #ifdef CONFIG_PM_SLEEP
-extern void device_pm_lock(void);
+#ifndef CONFIG_ARCH_NO_SYSDEV_OPS
+extern int sysdev_suspend(pm_message_t state);
 extern int sysdev_resume(void);
+#else
+static inline int sysdev_suspend(pm_message_t state) { return 0; }
+static inline int sysdev_resume(void) { return 0; }
+#endif
+
+extern void device_pm_lock(void);
 extern void dpm_resume_noirq(pm_message_t state);
 extern void dpm_resume_end(pm_message_t state);
 
 extern void device_pm_unlock(void);
-extern int sysdev_suspend(pm_message_t state);
 extern int dpm_suspend_noirq(pm_message_t state);
 extern int dpm_suspend_start(pm_message_t state);
 
Index: linux-2.6/include/linux/sysdev.h
===================================================================
--- linux-2.6.orig/include/linux/sysdev.h
+++ linux-2.6/include/linux/sysdev.h
@@ -33,12 +33,13 @@ struct sysdev_class {
 	const char *name;
 	struct list_head	drivers;
 	struct sysdev_class_attribute **attrs;
-
+	struct kset		kset;
+#ifndef CONFIG_ARCH_NO_SYSDEV_OPS
 	/* Default operations for these types of devices */
 	int	(*shutdown)(struct sys_device *);
 	int	(*suspend)(struct sys_device *, pm_message_t state);
 	int	(*resume)(struct sys_device *);
-	struct kset		kset;
+#endif
 };
 
 struct sysdev_class_attribute {
@@ -76,9 +77,11 @@ struct sysdev_driver {
 	struct list_head	entry;
 	int	(*add)(struct sys_device *);
 	int	(*remove)(struct sys_device *);
+#ifndef CONFIG_ARCH_NO_SYSDEV_OPS
 	int	(*shutdown)(struct sys_device *);
 	int	(*suspend)(struct sys_device *, pm_message_t state);
 	int	(*resume)(struct sys_device *);
+#endif
 };
 
 
Index: linux-2.6/include/linux/device.h
===================================================================
--- linux-2.6.orig/include/linux/device.h
+++ linux-2.6/include/linux/device.h
@@ -633,8 +633,12 @@ static inline int devtmpfs_mount(const c
 /* drivers/base/power/shutdown.c */
 extern void device_shutdown(void);
 
+#ifndef CONFIG_ARCH_NO_SYSDEV_OPS
 /* drivers/base/sys.c */
 extern void sysdev_shutdown(void);
+#else
+static inline void sysdev_shutdown(void) { }
+#endif
 
 /* debugging and troubleshooting/diagnostic helpers. */
 extern const char *dev_driver_string(const struct device *dev);
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -71,6 +71,7 @@ config X86
 	select GENERIC_IRQ_SHOW
 	select IRQ_FORCED_THREADING
 	select USE_GENERIC_SMP_HELPERS if SMP
+	select ARCH_NO_SYSDEV_OPS
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
Index: linux-2.6/drivers/base/sys.c
===================================================================
--- linux-2.6.orig/drivers/base/sys.c
+++ linux-2.6/drivers/base/sys.c
@@ -329,7 +329,7 @@ void sysdev_unregister(struct sys_device
 }
 
 
-
+#ifndef CONFIG_ARCH_NO_SYSDEV_OPS
 /**
  *	sysdev_shutdown - Shut down all system devices.
  *
@@ -524,6 +524,7 @@ int sysdev_resume(void)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(sysdev_resume);
+#endif /* CONFIG_ARCH_NO_SYSDEV_OPS */
 
 int __init system_bus_init(void)
 {
Index: linux-2.6/drivers/base/Kconfig
===================================================================
--- linux-2.6.orig/drivers/base/Kconfig
+++ linux-2.6/drivers/base/Kconfig
@@ -168,4 +168,11 @@ config SYS_HYPERVISOR
 	bool
 	default n
 
+config ARCH_NO_SYSDEV_OPS
+	bool
+	---help---
+	  To be selected by architectures that don't use sysdev class or
+	  sysdev driver power management (suspend/resume) and shutdown
+	  operations.
+
 endmenu

