Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1CLVWj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 16:22:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53713 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043Ab1CLVWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 16:22:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/8] Introduce ARCH_NO_SYSDEV_OPS config option
Date: Sat, 12 Mar 2011 22:21:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>
References: <201103100131.58206.rjw@sisk.pl> <201103122212.40828.rjw@sisk.pl>
In-Reply-To: <201103122212.40828.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103122221.37295.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce option allowing architectures where sysdev operations
used during system suspend, resume and shutdown have been completely
replaced with struct sycore_ops operations to avoid building sysdev
code that will never be used.  Making callbacks in struct sys_device
and struct sysdev_driver depend on ARCH_NO_SYSDEV_OPS allows us to
verify if all of the references have been actually removed from the
code the given architecture depends on.

Make x86 set ARCH_NO_SYSDEV_OPS.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/Kconfig       |    3 +++
 drivers/base/sys.c     |    3 ++-
 include/linux/device.h |    4 ++++
 include/linux/pm.h     |   10 ++++++++--
 include/linux/sysdev.h |    7 +++++--
 5 files changed, 22 insertions(+), 5 deletions(-)

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
@@ -635,8 +635,12 @@ static inline int devtmpfs_mount(const c
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
@@ -184,6 +184,9 @@ config ARCH_HIBERNATION_POSSIBLE
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
 
+config ARCH_NO_SYSDEV_OPS
+	def_bool y
+
 config ZONE_DMA32
 	bool
 	default X86_64
Index: linux-2.6/drivers/base/sys.c
===================================================================
--- linux-2.6.orig/drivers/base/sys.c
+++ linux-2.6/drivers/base/sys.c
@@ -302,7 +302,7 @@ void sysdev_unregister(struct sys_device
 }
 
 
-
+#ifndef CONFIG_ARCH_NO_SYSDEV_OPS
 /**
  *	sysdev_shutdown - Shut down all system devices.
  *
@@ -497,6 +497,7 @@ int sysdev_resume(void)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(sysdev_resume);
+#endif /* CONFIG_ARCH_NO_SYSDEV_OPS */
 
 int __init system_bus_init(void)
 {

