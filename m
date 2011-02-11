Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab1BKX3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 18:29:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37810 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756879Ab1BKX3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 18:29:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] PM: Drop pm_flags that is not necessary
Date: Sat, 12 Feb 2011 00:28:34 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102120028.34666.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The variable pm_flags is used to prevent APM from being enabled
along with ACPI, which would lead to problems.  However, acpi_init()
is always called before apm_init() and after acpi_init() has
returned, it is known whether or not ACPI will be used.  Namely, if
acpi_disabled is not set after acpi_init() has returned, this means
that ACPI is enabled.  Thus, it is sufficient to check acpi_disabled
in apm_init() to prevent APM from being enabled in parallel with
ACPI.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Hi,

This patch is on top of suspend-2.6/linux-next .

Thanks,
Rafael

---
 arch/x86/kernel/apm_32.c |    5 ++---
 drivers/acpi/bus.c       |   22 +++++-----------------
 include/linux/pm.h       |    9 ---------
 include/linux/suspend.h  |    6 ------
 kernel/power/main.c      |   13 -------------
 5 files changed, 7 insertions(+), 48 deletions(-)

Index: linux-2.6/arch/x86/kernel/apm_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apm_32.c
+++ linux-2.6/arch/x86/kernel/apm_32.c
@@ -227,6 +227,7 @@
 #include <linux/suspend.h>
 #include <linux/kthread.h>
 #include <linux/jiffies.h>
+#include <linux/acpi.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -2331,12 +2332,11 @@ static int __init apm_init(void)
 		apm_info.disabled = 1;
 		return -ENODEV;
 	}
-	if (pm_flags & PM_ACPI) {
+	if (!acpi_disabled) {
 		printk(KERN_NOTICE "apm: overridden by ACPI.\n");
 		apm_info.disabled = 1;
 		return -ENODEV;
 	}
-	pm_flags |= PM_APM;
 
 	/*
 	 * Set up the long jump entry point to the APM BIOS, which is called
@@ -2428,7 +2428,6 @@ static void __exit apm_exit(void)
 		kthread_stop(kapmd_task);
 		kapmd_task = NULL;
 	}
-	pm_flags &= ~PM_APM;
 }
 
 module_init(apm_init);
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -563,15 +563,6 @@ enum dpm_order {
 	DPM_ORDER_DEV_LAST,
 };
 
-/*
- * Global Power Management flags
- * Used to keep APM and ACPI from both being active
- */
-extern unsigned int	pm_flags;
-
-#define PM_APM	1
-#define PM_ACPI	2
-
 extern int pm_generic_suspend(struct device *dev);
 extern int pm_generic_resume(struct device *dev);
 extern int pm_generic_freeze(struct device *dev);
Index: linux-2.6/include/linux/suspend.h
===================================================================
--- linux-2.6.orig/include/linux/suspend.h
+++ linux-2.6/include/linux/suspend.h
@@ -272,9 +272,6 @@ extern int unregister_pm_notifier(struct
 	register_pm_notifier(&fn##_nb);			\
 }
 
-extern bool pm_apm_enabled(void);
-extern void pm_set_acpi_flag(void);
-
 /* drivers/base/power/wakeup.c */
 extern bool events_check_enabled;
 
@@ -295,9 +292,6 @@ static inline int unregister_pm_notifier
 
 #define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
 
-static inline bool pm_apm_enabled(void) { return false; }
-static inline void pm_set_acpi_flag(void) {}
-
 static inline bool pm_wakeup_pending(void) { return false; }
 #endif /* !CONFIG_PM_SLEEP */
 
Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -19,19 +19,6 @@ DEFINE_MUTEX(pm_mutex);
 
 #ifdef CONFIG_PM_SLEEP
 
-unsigned int pm_flags;
-EXPORT_SYMBOL(pm_flags);
-
-bool pm_apm_enabled(void)
-{
-	return !!(pm_flags & PM_APM);
-}
-
-void pm_set_acpi_flag(void)
-{
-	pm_flags |= PM_ACPI;
-}
-
 /* Routines for PM-transition notifications */
 
 static BLOCKING_NOTIFIER_HEAD(pm_chain_head);
Index: linux-2.6/drivers/acpi/bus.c
===================================================================
--- linux-2.6.orig/drivers/acpi/bus.c
+++ linux-2.6/drivers/acpi/bus.c
@@ -1007,8 +1007,7 @@ struct kobject *acpi_kobj;
 
 static int __init acpi_init(void)
 {
-	int result = 0;
-
+	int result;
 
 	if (acpi_disabled) {
 		printk(KERN_INFO PREFIX "Interpreter disabled.\n");
@@ -1023,29 +1022,18 @@ static int __init acpi_init(void)
 
 	init_acpi_device_notify();
 	result = acpi_bus_init();
-
-	if (!result) {
-		pci_mmcfg_late_init();
-		if (pm_apm_enabled()) {
-			printk(KERN_INFO PREFIX
-			       "APM is already active, exiting\n");
-			disable_acpi();
-			result = -ENODEV;
-		} else {
-			pm_set_acpi_flag();
-		}
-	} else
+	if (result) {
 		disable_acpi();
-
-	if (acpi_disabled)
 		return result;
+	}
 
+	pci_mmcfg_late_init();
 	acpi_scan_init();
 	acpi_ec_init();
 	acpi_debugfs_init();
 	acpi_sleep_proc_init();
 	acpi_wakeup_device_init();
-	return result;
+	return 0;
 }
 
 subsys_initcall(acpi_init);
