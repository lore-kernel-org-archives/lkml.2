Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab2HEXwl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 19:52:41 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43034 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463Ab2HEXta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 19:49:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 15/15] PM: Do not use the syscore flag for runtime PM
Date: Mon, 6 Aug 2012 01:53:11 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <201207291612.43138.rjw@sisk.pl> <201208060138.03950.rjw@sisk.pl>
In-Reply-To: <201208060138.03950.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208060153.11582.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The syscore device PM flag used to mark the devices (belonging to
PM domains) that should never be turned off, except for the system
core (syscore) suspend/hibernation and resume stages, need not be
accessed by the runtime PM core functions, because all of the devices
it is set for need to be marked as "irq safe" anyway and are
protected from being turned off by runtime PM by ensuring that their
usage counters are always set.

For this reason, make the syscore flag system-wide PM-specific
and simplify the code used for manipulating it, because it need not
acquire the device's power.lock any more.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/common.c  |   15 ---------------
 drivers/base/power/domain.c  |    2 +-
 drivers/base/power/runtime.c |    2 +-
 include/linux/device.h       |    7 +++++++
 include/linux/pm.h           |    6 +-----
 5 files changed, 10 insertions(+), 22 deletions(-)

Index: linux/include/linux/pm.h
===================================================================
--- linux.orig/include/linux/pm.h
+++ linux/include/linux/pm.h
@@ -43,12 +43,8 @@ struct device;
 
 #ifdef CONFIG_PM
 extern const char power_group_name[];		/* = "power" */
-
-extern void dev_pm_syscore_device(struct device *dev, bool val);
 #else
 #define power_group_name	NULL
-
-static inline void dev_pm_syscore_device(struct device *dev, bool val) {}
 #endif
 
 typedef struct pm_message {
@@ -515,13 +511,13 @@ struct dev_pm_info {
 	bool			is_suspended:1;	/* Ditto */
 	bool			ignore_children:1;
 	bool			early_init:1;	/* Owned by the PM core */
-	bool			syscore:1;
 	spinlock_t		lock;
 #ifdef CONFIG_PM_SLEEP
 	struct list_head	entry;
 	struct completion	completion;
 	struct wakeup_source	*wakeup;
 	bool			wakeup_path:1;
+	bool			syscore:1;
 #else
 	unsigned int		should_wakeup:1;
 #endif
Index: linux/drivers/base/power/common.c
===================================================================
--- linux.orig/drivers/base/power/common.c
+++ linux/drivers/base/power/common.c
@@ -85,18 +85,3 @@ int dev_pm_put_subsys_data(struct device
 	return ret;
 }
 EXPORT_SYMBOL_GPL(dev_pm_put_subsys_data);
-
-/**
- * dev_pm_syscore_device - Set/unset the given device's power.syscore flag.
- * @dev: Device whose flag is to be modified.
- * @val: New value of the flag.
- */
-void dev_pm_syscore_device(struct device *dev, bool val)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->power.lock, flags);
-	dev->power.syscore = val;
-	spin_unlock_irqrestore(&dev->power.lock, flags);
-}
-EXPORT_SYMBOL_GPL(dev_pm_syscore_device);
Index: linux/drivers/base/power/runtime.c
===================================================================
--- linux.orig/drivers/base/power/runtime.c
+++ linux/drivers/base/power/runtime.c
@@ -134,7 +134,7 @@ static int rpm_check_suspend_allowed(str
 
 	if (dev->power.runtime_error)
 		retval = -EINVAL;
-	else if (dev->power.disable_depth > 0 || dev->power.syscore)
+	else if (dev->power.disable_depth > 0)
 		retval = -EACCES;
 	else if (atomic_read(&dev->power.usage_count) > 0)
 		retval = -EAGAIN;
Index: linux/include/linux/device.h
===================================================================
--- linux.orig/include/linux/device.h
+++ linux/include/linux/device.h
@@ -772,6 +772,13 @@ static inline void pm_suspend_ignore_chi
 	dev->power.ignore_children = enable;
 }
 
+static inline void dev_pm_syscore_device(struct device *dev, bool val)
+{
+#ifdef CONFIG_PM_SLEEP
+	dev->power.syscore = val;
+#endif
+}
+
 static inline void device_lock(struct device *dev)
 {
 	mutex_lock(&dev->mutex);
Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -442,7 +442,7 @@ static int pm_genpd_poweroff(struct gene
 	not_suspended = 0;
 	list_for_each_entry(pdd, &genpd->dev_list, list_node)
 		if (pdd->dev->driver && (!pm_runtime_suspended(pdd->dev)
-		    || pdd->dev->power.irq_safe || pdd->dev->power.syscore))
+		    || pdd->dev->power.irq_safe))
 			not_suspended++;
 
 	if (not_suspended > genpd->in_progress)
