Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab1C3Vzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:55:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58577 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933358Ab1C3Vzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:55:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Power management Kconfig modification for 2.6.39
Date: Wed, 30 Mar 2011 23:55:37 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Shriram Rajagopalan <rshriram@cs.ubc.ca>
References: <201103292143.12777.rjw@sisk.pl> <201103302247.16339.rjw@sisk.pl> <AANLkTikoBbbq223q7+2kS_nLDi7XUtgT2hczu9P6nQCx@mail.gmail.com>
In-Reply-To: <AANLkTikoBbbq223q7+2kS_nLDi7XUtgT2hczu9P6nQCx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103302355.38136.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 30, 2011, Linus Torvalds wrote:
> On Wed, Mar 30, 2011 at 1:47 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > Well, otherwise I'd have to change CONFIG_HIBERNATION to something else
> > throughout the tree and then add CONFIG_HIBERNATION as a user-visible option.
> > Perhaps that would be better from the user's viewpoint, but the confusion would
> > be still there.
> 
> Umm. It would be *less* confusing than the thing you sent me.
> 
> I would heartily support just renaming them all. Who cares about patch
> size? What matters is the end result not being confusing.

That, in fact, is not necessary.  Moreover, it turns out that the patch size
is not much different, because only a few subsystems use CONFIG_HIBERNATION
directly.

The patch below has only been slightly tested, in particular I'd like the Xen
people to check if it works for them.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Hibernate: Introduce CONFIG_HIBERNATE_CALLBACKS

Xen save/restore is going to use hibernate device callbacks for
quiescing devices and putting them back to normal operations and it
would need to select CONFIG_HIBERNATION for this purpose.  However,
that also would cause the hibernate interfaces for user space to be
enabled, which might confuse user space, because the Xen kernels
don't support hibernation.  Moreover, it would be wasteful, as it
would make the Xen kernels include a substantial amount of code that
they would never use.

To address this issue introduce new power management Kconfig option
CONFIG_HIBERNATE_CALLBACKS, such that it will only select the code
that is necessary for the hibernate device callbacks to work and make
CONFIG_HIBERNATION select it.  Then, Xen save/restore will be able to
select CONFIG_HIBERNATE_CALLBACKS without dragging the entire
hibernate code along with it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/powerpc/kernel/ibmebus.c |    6 +++---
 drivers/amba/bus.c            |    6 +++---
 drivers/base/platform.c       |    6 +++---
 drivers/base/power/main.c     |    8 ++++----
 drivers/pci/pci-driver.c      |    6 +++---
 drivers/xen/manage.c          |    6 +++---
 include/linux/suspend.h       |   11 +++--------
 kernel/power/Kconfig          |    6 +++++-
 8 files changed, 27 insertions(+), 28 deletions(-)

Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig
+++ linux-2.6/kernel/power/Kconfig
@@ -18,9 +18,13 @@ config SUSPEND_FREEZER
 
 	  Turning OFF this setting is NOT recommended! If in doubt, say Y.
 
+config HIBERNATE_CALLBACKS
+	bool
+
 config HIBERNATION
 	bool "Hibernation (aka 'suspend to disk')"
 	depends on SWAP && ARCH_HIBERNATION_POSSIBLE
+	select HIBERNATE_CALLBACKS
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	---help---
@@ -85,7 +89,7 @@ config PM_STD_PARTITION
 
 config PM_SLEEP
 	def_bool y
-	depends on SUSPEND || HIBERNATION || XEN_SAVE_RESTORE
+	depends on SUSPEND || HIBERNATE_CALLBACKS || XEN_SAVE_RESTORE
 
 config PM_SLEEP_SMP
 	def_bool y
Index: linux-2.6/include/linux/suspend.h
===================================================================
--- linux-2.6.orig/include/linux/suspend.h
+++ linux-2.6/include/linux/suspend.h
@@ -249,6 +249,8 @@ extern void hibernation_set_ops(const st
 extern int hibernate(void);
 extern bool system_entering_hibernation(void);
 #else /* CONFIG_HIBERNATION */
+static inline void register_nosave_region(unsigned long b, unsigned long e) {}
+static inline void register_nosave_region_late(unsigned long b, unsigned long e) {}
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
 static inline void swsusp_unset_page_free(struct page *p) {}
@@ -297,14 +299,7 @@ static inline bool pm_wakeup_pending(voi
 
 extern struct mutex pm_mutex;
 
-#ifndef CONFIG_HIBERNATION
-static inline void register_nosave_region(unsigned long b, unsigned long e)
-{
-}
-static inline void register_nosave_region_late(unsigned long b, unsigned long e)
-{
-}
-
+#ifndef CONFIG_HIBERNATE_CALLBACKS
 static inline void lock_system_sleep(void) {}
 static inline void unlock_system_sleep(void) {}
 
Index: linux-2.6/arch/powerpc/kernel/ibmebus.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/ibmebus.c
+++ linux-2.6/arch/powerpc/kernel/ibmebus.c
@@ -527,7 +527,7 @@ static int ibmebus_bus_pm_resume_noirq(s
 
 #endif /* !CONFIG_SUSPEND */
 
-#ifdef CONFIG_HIBERNATION
+#ifdef CONFIG_HIBERNATE_CALLBACKS
 
 static int ibmebus_bus_pm_freeze(struct device *dev)
 {
@@ -665,7 +665,7 @@ static int ibmebus_bus_pm_restore_noirq(
 	return ret;
 }
 
-#else /* !CONFIG_HIBERNATION */
+#else /* !CONFIG_HIBERNATE_CALLBACKS */
 
 #define ibmebus_bus_pm_freeze		NULL
 #define ibmebus_bus_pm_thaw		NULL
@@ -676,7 +676,7 @@ static int ibmebus_bus_pm_restore_noirq(
 #define ibmebus_bus_pm_poweroff_noirq	NULL
 #define ibmebus_bus_pm_restore_noirq	NULL
 
-#endif /* !CONFIG_HIBERNATION */
+#endif /* !CONFIG_HIBERNATE_CALLBACKS */
 
 static struct dev_pm_ops ibmebus_bus_dev_pm_ops = {
 	.prepare = ibmebus_bus_pm_prepare,
Index: linux-2.6/drivers/amba/bus.c
===================================================================
--- linux-2.6.orig/drivers/amba/bus.c
+++ linux-2.6/drivers/amba/bus.c
@@ -214,7 +214,7 @@ static int amba_pm_resume_noirq(struct d
 
 #endif /* !CONFIG_SUSPEND */
 
-#ifdef CONFIG_HIBERNATION
+#ifdef CONFIG_HIBERNATE_CALLBACKS
 
 static int amba_pm_freeze(struct device *dev)
 {
@@ -352,7 +352,7 @@ static int amba_pm_restore_noirq(struct
 	return ret;
 }
 
-#else /* !CONFIG_HIBERNATION */
+#else /* !CONFIG_HIBERNATE_CALLBACKS */
 
 #define amba_pm_freeze		NULL
 #define amba_pm_thaw		NULL
@@ -363,7 +363,7 @@ static int amba_pm_restore_noirq(struct
 #define amba_pm_poweroff_noirq	NULL
 #define amba_pm_restore_noirq	NULL
 
-#endif /* !CONFIG_HIBERNATION */
+#endif /* !CONFIG_HIBERNATE_CALLBACKS */
 
 #ifdef CONFIG_PM
 
Index: linux-2.6/drivers/base/platform.c
===================================================================
--- linux-2.6.orig/drivers/base/platform.c
+++ linux-2.6/drivers/base/platform.c
@@ -771,7 +771,7 @@ int __weak platform_pm_resume_noirq(stru
 
 #endif /* !CONFIG_SUSPEND */
 
-#ifdef CONFIG_HIBERNATION
+#ifdef CONFIG_HIBERNATE_CALLBACKS
 
 static int platform_pm_freeze(struct device *dev)
 {
@@ -909,7 +909,7 @@ static int platform_pm_restore_noirq(str
 	return ret;
 }
 
-#else /* !CONFIG_HIBERNATION */
+#else /* !CONFIG_HIBERNATE_CALLBACKS */
 
 #define platform_pm_freeze		NULL
 #define platform_pm_thaw		NULL
@@ -920,7 +920,7 @@ static int platform_pm_restore_noirq(str
 #define platform_pm_poweroff_noirq	NULL
 #define platform_pm_restore_noirq	NULL
 
-#endif /* !CONFIG_HIBERNATION */
+#endif /* !CONFIG_HIBERNATE_CALLBACKS */
 
 #ifdef CONFIG_PM_RUNTIME
 
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -233,7 +233,7 @@ static int pm_op(struct device *dev,
 		}
 		break;
 #endif /* CONFIG_SUSPEND */
-#ifdef CONFIG_HIBERNATION
+#ifdef CONFIG_HIBERNATE_CALLBACKS
 	case PM_EVENT_FREEZE:
 	case PM_EVENT_QUIESCE:
 		if (ops->freeze) {
@@ -260,7 +260,7 @@ static int pm_op(struct device *dev,
 			suspend_report_result(ops->restore, error);
 		}
 		break;
-#endif /* CONFIG_HIBERNATION */
+#endif /* CONFIG_HIBERNATE_CALLBACKS */
 	default:
 		error = -EINVAL;
 	}
@@ -308,7 +308,7 @@ static int pm_noirq_op(struct device *de
 		}
 		break;
 #endif /* CONFIG_SUSPEND */
-#ifdef CONFIG_HIBERNATION
+#ifdef CONFIG_HIBERNATE_CALLBACKS
 	case PM_EVENT_FREEZE:
 	case PM_EVENT_QUIESCE:
 		if (ops->freeze_noirq) {
@@ -335,7 +335,7 @@ static int pm_noirq_op(struct device *de
 			suspend_report_result(ops->restore_noirq, error);
 		}
 		break;
-#endif /* CONFIG_HIBERNATION */
+#endif /* CONFIG_HIBERNATE_CALLBACKS */
 	default:
 		error = -EINVAL;
 	}
Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -781,7 +781,7 @@ static int pci_pm_resume(struct device *
 
 #endif /* !CONFIG_SUSPEND */
 
-#ifdef CONFIG_HIBERNATION
+#ifdef CONFIG_HIBERNATE_CALLBACKS
 
 static int pci_pm_freeze(struct device *dev)
 {
@@ -970,7 +970,7 @@ static int pci_pm_restore(struct device
 	return error;
 }
 
-#else /* !CONFIG_HIBERNATION */
+#else /* !CONFIG_HIBERNATE_CALLBACKS */
 
 #define pci_pm_freeze		NULL
 #define pci_pm_freeze_noirq	NULL
@@ -981,7 +981,7 @@ static int pci_pm_restore(struct device
 #define pci_pm_restore		NULL
 #define pci_pm_restore_noirq	NULL
 
-#endif /* !CONFIG_HIBERNATION */
+#endif /* !CONFIG_HIBERNATE_CALLBACKS */
 
 #ifdef CONFIG_PM_RUNTIME
 
Index: linux-2.6/drivers/xen/manage.c
===================================================================
--- linux-2.6.orig/drivers/xen/manage.c
+++ linux-2.6/drivers/xen/manage.c
@@ -61,7 +61,7 @@ static void xen_post_suspend(int cancell
 	xen_mm_unpin_all();
 }
 
-#ifdef CONFIG_HIBERNATION
+#ifdef CONFIG_HIBERNATE_CALLBACKS
 static int xen_suspend(void *data)
 {
 	struct suspend_info *si = data;
@@ -173,7 +173,7 @@ out:
 #endif
 	shutting_down = SHUTDOWN_INVALID;
 }
-#endif	/* CONFIG_HIBERNATION */
+#endif	/* CONFIG_HIBERNATE_CALLBACKS */
 
 struct shutdown_handler {
 	const char *command;
@@ -202,7 +202,7 @@ static void shutdown_handler(struct xenb
 		{ "poweroff",	do_poweroff },
 		{ "halt",	do_poweroff },
 		{ "reboot",	do_reboot   },
-#ifdef CONFIG_HIBERNATION
+#ifdef CONFIG_HIBERNATE_CALLBACKS
 		{ "suspend",	do_suspend  },
 #endif
 		{NULL, NULL},
