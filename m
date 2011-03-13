Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab1CMPai (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 11:30:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54836 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab1CMPaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 11:30:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: [Update] Re: [PATCH 8/8] Introduce ARCH_NO_SYSDEV_OPS config option
Date: Sun, 13 Mar 2011 16:30:29 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc8+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>
References: <201103100131.58206.rjw@sisk.pl> <201103122221.37295.rjw@sisk.pl> <alpine.LFD.2.00.1103131453360.2787@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103131453360.2787@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103131630.29846.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 13, 2011, Thomas Gleixner wrote:
> On Sat, 12 Mar 2011, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/Kconfig
> > +++ linux-2.6/arch/x86/Kconfig
> > @@ -184,6 +184,9 @@ config ARCH_HIBERNATION_POSSIBLE
> >  config ARCH_SUSPEND_POSSIBLE
> >  	def_bool y
> >  
> > +config ARCH_NO_SYSDEV_OPS
> > +	def_bool y
> > +
> 
> Can we please put that in drivers/base/Kconfig and let the arch
> Kconfig select it?

Sure.  Updated patch follows.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: Introduce ARCH_NO_SYSDEV_OPS config option (v2)

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
 drivers/base/Kconfig   |    6 ++++++
 drivers/base/sys.c     |    3 ++-
 include/linux/device.h |    4 ++++
 include/linux/pm.h     |   10 ++++++++--
 include/linux/sysdev.h |    7 +++++--
 6 files changed, 26 insertions(+), 5 deletions(-)

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
@@ -67,6 +67,7 @@ config X86
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select USE_GENERIC_SMP_HELPERS if SMP
+	select ARCH_NO_SYSDEV_OPS
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
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
Index: linux-2.6/drivers/base/Kconfig
===================================================================
--- linux-2.6.orig/drivers/base/Kconfig
+++ linux-2.6/drivers/base/Kconfig
@@ -168,4 +168,10 @@ config SYS_HYPERVISOR
 	bool
 	default n
 
+config ARCH_NO_SYSDEV_OPS
+	bool
+	---help---
+	  To be set by architectures that don't use sysdev or sysdev driver
+	  power management (suspend/resume) and shutdown operations.
+
 endmenu
