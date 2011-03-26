Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1CZX66 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 19:58:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44671 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab1CZX65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 19:58:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH] PM / Platform: Remove __weak definitions of runtime PM callbacks
Date: Sun, 27 Mar 2011 00:58:41 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103270058.41632.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Remove the __weak definitions of platform bus type runtime PM
callbacks, make platform_dev_pm_ops point to the generic routines
as appropriate and allow architectures using platform_dev_pm_ops to
replace the runtime PM callbacks in that structure with their own
set.

Convert architectures providing its own definitions of the platform
runtime PM callbacks to use the new mechanism.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm_runtime.c      |    3 ++
 arch/sh/kernel/cpu/shmobile/pm_runtime.c |    3 ++
 drivers/base/platform.c                  |   43 ++++++++++---------------------
 include/linux/platform_device.h          |    4 ++
 4 files changed, 24 insertions(+), 29 deletions(-)

Index: linux-2.6/drivers/base/platform.c
===================================================================
--- linux-2.6.orig/drivers/base/platform.c
+++ linux-2.6/drivers/base/platform.c
@@ -922,32 +922,7 @@ static int platform_pm_restore_noirq(str
 
 #endif /* !CONFIG_HIBERNATION */
 
-#ifdef CONFIG_PM_RUNTIME
-
-int __weak platform_pm_runtime_suspend(struct device *dev)
-{
-	return pm_generic_runtime_suspend(dev);
-};
-
-int __weak platform_pm_runtime_resume(struct device *dev)
-{
-	return pm_generic_runtime_resume(dev);
-};
-
-int __weak platform_pm_runtime_idle(struct device *dev)
-{
-	return pm_generic_runtime_idle(dev);
-};
-
-#else /* !CONFIG_PM_RUNTIME */
-
-#define platform_pm_runtime_suspend NULL
-#define platform_pm_runtime_resume NULL
-#define platform_pm_runtime_idle NULL
-
-#endif /* !CONFIG_PM_RUNTIME */
-
-static const struct dev_pm_ops platform_dev_pm_ops = {
+static struct dev_pm_ops platform_dev_pm_ops = {
 	.prepare = platform_pm_prepare,
 	.complete = platform_pm_complete,
 	.suspend = platform_pm_suspend,
@@ -962,9 +937,9 @@ static const struct dev_pm_ops platform_
 	.thaw_noirq = platform_pm_thaw_noirq,
 	.poweroff_noirq = platform_pm_poweroff_noirq,
 	.restore_noirq = platform_pm_restore_noirq,
-	.runtime_suspend = platform_pm_runtime_suspend,
-	.runtime_resume = platform_pm_runtime_resume,
-	.runtime_idle = platform_pm_runtime_idle,
+	SET_RUNTIME_PM_OPS(pm_generic_runtime_suspend,
+			   pm_generic_runtime_resume,
+			   pm_generic_runtime_idle)
 };
 
 struct bus_type platform_bus_type = {
@@ -976,6 +951,16 @@ struct bus_type platform_bus_type = {
 };
 EXPORT_SYMBOL_GPL(platform_bus_type);
 
+void platform_set_runtime_pm_ops(int (*suspend)(struct device *dev),
+				 int (*resume)(struct device *dev),
+				 int (*idle)(struct device *dev))
+{
+	platform_dev_pm_ops.runtime_suspend = suspend;
+	platform_dev_pm_ops.runtime_resume = resume;
+	platform_dev_pm_ops.runtime_idle = idle;
+}
+EXPORT_SYMBOL_GPL(platform_set_runtime_pm_ops);
+
 /**
  * platform_bus_get_pm_ops() - return pointer to busses dev_pm_ops
  *
Index: linux-2.6/include/linux/platform_device.h
===================================================================
--- linux-2.6.orig/include/linux/platform_device.h
+++ linux-2.6/include/linux/platform_device.h
@@ -200,4 +200,8 @@ static inline char *early_platform_drive
 }
 #endif /* MODULE */
 
+extern void platform_set_runtime_pm_ops(int (*suspend)(struct device *dev),
+					int (*resume)(struct device *dev),
+					int (*idle)(struct device *dev));
+
 #endif /* _PLATFORM_DEVICE_H_ */
Index: linux-2.6/arch/arm/mach-shmobile/pm_runtime.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/pm_runtime.c
+++ linux-2.6/arch/arm/mach-shmobile/pm_runtime.c
@@ -163,6 +163,9 @@ static struct notifier_block platform_bu
 
 static int __init sh_pm_runtime_init(void)
 {
+	platform_set_runtime_pm_ops(platform_pm_runtime_suspend,
+				    platform_pm_runtime_resume,
+				    platform_pm_runtime_idle);
 	bus_register_notifier(&platform_bus_type, &platform_bus_notifier);
 	return 0;
 }
Index: linux-2.6/arch/sh/kernel/cpu/shmobile/pm_runtime.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/cpu/shmobile/pm_runtime.c
+++ linux-2.6/arch/sh/kernel/cpu/shmobile/pm_runtime.c
@@ -302,6 +302,9 @@ static int __init sh_pm_runtime_init(voi
 {
 	INIT_WORK(&hwblk_work, platform_pm_runtime_work);
 
+	platform_set_runtime_pm_ops(platform_pm_runtime_suspend,
+				    platform_pm_runtime_resume,
+				    platform_pm_runtime_idle);
 	bus_register_notifier(&platform_bus_type, &platform_bus_notifier);
 	return 0;
 }
