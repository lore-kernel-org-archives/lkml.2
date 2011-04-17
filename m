Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab1DQVQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 17:16:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57601 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab1DQVQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 17:16:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/14] ARM: Use struct syscore_ops instead of sysdevs for PM in common code
Date: Sun, 17 Apr 2011 23:07:34 +0200
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
Message-Id: <201104172307.35013.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Convert some ARM architecture's common code to using
struct syscore_ops objects for power management instead of sysdev
classes and sysdevs.

This simplifies the code and reduces the kernel's memory footprint.
It also is necessary for removing sysdevs from the kernel entirely in
the future.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/common/vic.c            |   69 ++++++++++++++-------------------------
 arch/arm/include/asm/mach/time.h |    1 
 arch/arm/kernel/leds.c           |   28 +++++++++------
 arch/arm/kernel/time.c           |   35 ++++++-------------
 arch/arm/vfp/vfpmodule.c         |   19 ++--------
 5 files changed, 58 insertions(+), 94 deletions(-)

Index: linux-2.6/arch/arm/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/time.c
+++ linux-2.6/arch/arm/kernel/time.c
@@ -21,7 +21,7 @@
 #include <linux/timex.h>
 #include <linux/errno.h>
 #include <linux/profile.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/timer.h>
 #include <linux/irq.h>
 
@@ -115,48 +115,37 @@ void timer_tick(void)
 #endif
 
 #if defined(CONFIG_PM) && !defined(CONFIG_GENERIC_CLOCKEVENTS)
-static int timer_suspend(struct sys_device *dev, pm_message_t state)
+static int timer_suspend(void)
 {
-	struct sys_timer *timer = container_of(dev, struct sys_timer, dev);
-
-	if (timer->suspend != NULL)
-		timer->suspend();
+	if (system_timer->suspend)
+		system_timer->suspend();
 
 	return 0;
 }
 
-static int timer_resume(struct sys_device *dev)
+static void timer_resume(void)
 {
-	struct sys_timer *timer = container_of(dev, struct sys_timer, dev);
-
-	if (timer->resume != NULL)
-		timer->resume();
-
-	return 0;
+	if (system_timer->resume)
+		system_timer->resume();
 }
 #else
 #define timer_suspend NULL
 #define timer_resume NULL
 #endif
 
-static struct sysdev_class timer_sysclass = {
-	.name		= "timer",
+static struct syscore_ops timer_syscore_ops = {
 	.suspend	= timer_suspend,
 	.resume		= timer_resume,
 };
 
-static int __init timer_init_sysfs(void)
+static int __init timer_init_syscore_ops(void)
 {
-	int ret = sysdev_class_register(&timer_sysclass);
-	if (ret == 0) {
-		system_timer->dev.cls = &timer_sysclass;
-		ret = sysdev_register(&system_timer->dev);
-	}
+	register_syscore_ops(&timer_syscore_ops);
 
-	return ret;
+	return 0;
 }
 
-device_initcall(timer_init_sysfs);
+device_initcall(timer_init_syscore_ops);
 
 void __init time_init(void)
 {
Index: linux-2.6/arch/arm/include/asm/mach/time.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/mach/time.h
+++ linux-2.6/arch/arm/include/asm/mach/time.h
@@ -34,7 +34,6 @@
  *   timer interrupt which may be pending.
  */
 struct sys_timer {
-	struct sys_device	dev;
 	void			(*init)(void);
 	void			(*suspend)(void);
 	void			(*resume)(void);
Index: linux-2.6/arch/arm/kernel/leds.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/leds.c
+++ linux-2.6/arch/arm/kernel/leds.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/leds.h>
 
@@ -69,36 +70,37 @@ static ssize_t leds_store(struct sys_dev
 
 static SYSDEV_ATTR(event, 0200, NULL, leds_store);
 
-static int leds_suspend(struct sys_device *dev, pm_message_t state)
+static struct sysdev_class leds_sysclass = {
+	.name		= "leds",
+};
+
+static struct sys_device leds_device = {
+	.id		= 0,
+	.cls		= &leds_sysclass,
+};
+
+static int leds_suspend(void)
 {
 	leds_event(led_stop);
 	return 0;
 }
 
-static int leds_resume(struct sys_device *dev)
+static void leds_resume(void)
 {
 	leds_event(led_start);
-	return 0;
 }
 
-static int leds_shutdown(struct sys_device *dev)
+static void leds_shutdown(void)
 {
 	leds_event(led_halted);
-	return 0;
 }
 
-static struct sysdev_class leds_sysclass = {
-	.name		= "leds",
+static struct syscore_ops leds_syscore_ops = {
 	.shutdown	= leds_shutdown,
 	.suspend	= leds_suspend,
 	.resume		= leds_resume,
 };
 
-static struct sys_device leds_device = {
-	.id		= 0,
-	.cls		= &leds_sysclass,
-};
-
 static int __init leds_init(void)
 {
 	int ret;
@@ -107,6 +109,8 @@ static int __init leds_init(void)
 		ret = sysdev_register(&leds_device);
 	if (ret == 0)
 		ret = sysdev_create_file(&leds_device, &attr_event);
+	if (ret == 0)
+		register_syscore_ops(&leds_syscore_ops);
 	return ret;
 }
 
Index: linux-2.6/arch/arm/common/vic.c
===================================================================
--- linux-2.6.orig/arch/arm/common/vic.c
+++ linux-2.6/arch/arm/common/vic.c
@@ -22,17 +22,16 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/io.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/device.h>
 #include <linux/amba/bus.h>
 
 #include <asm/mach/irq.h>
 #include <asm/hardware/vic.h>
 
-#if defined(CONFIG_PM)
+#ifdef CONFIG_PM
 /**
  * struct vic_device - VIC PM device
- * @sysdev: The system device which is registered.
  * @irq: The IRQ number for the base of the VIC.
  * @base: The register base for the VIC.
  * @resume_sources: A bitmask of interrupts for resume.
@@ -43,8 +42,6 @@
  * @protect: Save for VIC_PROTECT.
  */
 struct vic_device {
-	struct sys_device sysdev;
-
 	void __iomem	*base;
 	int		irq;
 	u32		resume_sources;
@@ -59,11 +56,6 @@ struct vic_device {
 static struct vic_device vic_devices[CONFIG_ARM_VIC_NR];
 
 static int vic_id;
-
-static inline struct vic_device *to_vic(struct sys_device *sys)
-{
-	return container_of(sys, struct vic_device, sysdev);
-}
 #endif /* CONFIG_PM */
 
 /**
@@ -85,10 +77,9 @@ static void vic_init2(void __iomem *base
 	writel(32, base + VIC_PL190_DEF_VECT_ADDR);
 }
 
-#if defined(CONFIG_PM)
-static int vic_class_resume(struct sys_device *dev)
+#ifdef CONFIG_PM
+static void resume_one_vic(struct vic_device *vic)
 {
-	struct vic_device *vic = to_vic(dev);
 	void __iomem *base = vic->base;
 
 	printk(KERN_DEBUG "%s: resuming vic at %p\n", __func__, base);
@@ -107,13 +98,18 @@ static int vic_class_resume(struct sys_d
 
 	writel(vic->soft_int, base + VIC_INT_SOFT);
 	writel(~vic->soft_int, base + VIC_INT_SOFT_CLEAR);
+}
 
-	return 0;
+static void vic_resume(void)
+{
+	int id;
+
+	for (id = vic_id - 1; id >= 0; id--)
+		resume_one_vic(vic_devices + id);
 }
 
-static int vic_class_suspend(struct sys_device *dev, pm_message_t state)
+static void suspend_one_vic(struct vic_device *vic)
 {
-	struct vic_device *vic = to_vic(dev);
 	void __iomem *base = vic->base;
 
 	printk(KERN_DEBUG "%s: suspending vic at %p\n", __func__, base);
@@ -128,14 +124,21 @@ static int vic_class_suspend(struct sys_
 
 	writel(vic->resume_irqs, base + VIC_INT_ENABLE);
 	writel(~vic->resume_irqs, base + VIC_INT_ENABLE_CLEAR);
+}
+
+static int vic_suspend(void)
+{
+	int id;
+
+	for (id = 0; id < vic_id; id++)
+		suspend_one_vic(vic_devices + id);
 
 	return 0;
 }
 
-struct sysdev_class vic_class = {
-	.name		= "vic",
-	.suspend	= vic_class_suspend,
-	.resume		= vic_class_resume,
+struct syscore_ops vic_syscore_ops = {
+	.suspend	= vic_suspend,
+	.resume		= vic_resume,
 };
 
 /**
@@ -147,30 +150,8 @@ struct sysdev_class vic_class = {
 */
 static int __init vic_pm_init(void)
 {
-	struct vic_device *dev = vic_devices;
-	int err;
-	int id;
-
-	if (vic_id == 0)
-		return 0;
-
-	err = sysdev_class_register(&vic_class);
-	if (err) {
-		printk(KERN_ERR "%s: cannot register class\n", __func__);
-		return err;
-	}
-
-	for (id = 0; id < vic_id; id++, dev++) {
-		dev->sysdev.id = id;
-		dev->sysdev.cls = &vic_class;
-
-		err = sysdev_register(&dev->sysdev);
-		if (err) {
-			printk(KERN_ERR "%s: failed to register device\n",
-			       __func__);
-			return err;
-		}
-	}
+	if (vic_id > 0)
+		register_syscore_ops(&vic_syscore_ops);
 
 	return 0;
 }
Index: linux-2.6/arch/arm/vfp/vfpmodule.c
===================================================================
--- linux-2.6.orig/arch/arm/vfp/vfpmodule.c
+++ linux-2.6/arch/arm/vfp/vfpmodule.c
@@ -398,9 +398,9 @@ static void vfp_enable(void *unused)
 }
 
 #ifdef CONFIG_PM
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 
-static int vfp_pm_suspend(struct sys_device *dev, pm_message_t state)
+static int vfp_pm_suspend(void)
 {
 	struct thread_info *ti = current_thread_info();
 	u32 fpexc = fmrx(FPEXC);
@@ -420,34 +420,25 @@ static int vfp_pm_suspend(struct sys_dev
 	return 0;
 }
 
-static int vfp_pm_resume(struct sys_device *dev)
+static void vfp_pm_resume(void)
 {
 	/* ensure we have access to the vfp */
 	vfp_enable(NULL);
 
 	/* and disable it to ensure the next usage restores the state */
 	fmxr(FPEXC, fmrx(FPEXC) & ~FPEXC_EN);
-
-	return 0;
 }
 
-static struct sysdev_class vfp_pm_sysclass = {
-	.name		= "vfp",
+static struct syscore_ops vfp_pm_syscore_ops = {
 	.suspend	= vfp_pm_suspend,
 	.resume		= vfp_pm_resume,
 };
 
-static struct sys_device vfp_pm_sysdev = {
-	.cls	= &vfp_pm_sysclass,
-};
-
 static void vfp_pm_init(void)
 {
-	sysdev_class_register(&vfp_pm_sysclass);
-	sysdev_register(&vfp_pm_sysdev);
+	register_syscore_ops(&vfp_pm_syscore_ops);
 }
 
-
 #else
 static inline void vfp_pm_init(void) { }
 #endif /* CONFIG_PM */

