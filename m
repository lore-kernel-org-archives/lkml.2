Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab1DQVTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 17:19:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57701 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab1DQVQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 17:16:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/14] ARM / Samsung: Use struct syscore_ops for "core" power management
Date: Sun, 17 Apr 2011 23:11:16 +0200
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
Message-Id: <201104172311.17082.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Replace sysdev classes and struct sys_device objects used for "core"
power management by Samsung platforms with struct syscore_ops objects
that are simpler.

This generally reduces the code size and the kernel memory footprint.
It also is necessary for removing sysdevs entirely from the kernel in
the future.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-exynos4/pm.c               |   45 ++++++++++++--------
 arch/arm/mach-s3c2410/irq.c              |   30 -------------
 arch/arm/mach-s3c2410/mach-bast.c        |   17 ++-----
 arch/arm/mach-s3c2410/pm.c               |   13 ++---
 arch/arm/mach-s3c2410/s3c2410.c          |    5 ++
 arch/arm/mach-s3c2412/irq.c              |    2 
 arch/arm/mach-s3c2412/mach-jive.c        |   19 ++------
 arch/arm/mach-s3c2412/pm.c               |   27 ++++++------
 arch/arm/mach-s3c2412/s3c2412.c          |    4 +
 arch/arm/mach-s3c2416/irq.c              |    2 
 arch/arm/mach-s3c2416/pm.c               |   27 +++++-------
 arch/arm/mach-s3c2416/s3c2416.c          |    5 ++
 arch/arm/mach-s3c2440/mach-osiris.c      |   18 ++------
 arch/arm/mach-s3c2440/s3c2440.c          |    8 +++
 arch/arm/mach-s3c2440/s3c2442.c          |    6 ++
 arch/arm/mach-s3c2440/s3c244x-irq.c      |    4 -
 arch/arm/mach-s3c2440/s3c244x.c          |   62 ++++++++++++++--------------
 arch/arm/mach-s3c64xx/irq-pm.c           |   18 ++++----
 arch/arm/mach-s5pv210/pm.c               |   25 +++++++----
 arch/arm/plat-s3c24xx/dma.c              |   68 +++++++++++--------------------
 arch/arm/plat-s3c24xx/irq-pm.c           |    7 ---
 arch/arm/plat-s5p/irq-pm.c               |    7 ---
 arch/arm/plat-samsung/include/plat/cpu.h |    6 ++
 arch/arm/plat-samsung/include/plat/pm.h  |    6 +-
 24 files changed, 203 insertions(+), 228 deletions(-)

Index: linux-2.6/arch/arm/plat-samsung/include/plat/pm.h
===================================================================
--- linux-2.6.orig/arch/arm/plat-samsung/include/plat/pm.h
+++ linux-2.6/arch/arm/plat-samsung/include/plat/pm.h
@@ -103,14 +103,16 @@ extern void s3c_pm_do_restore_core(struc
 
 #ifdef CONFIG_PM
 extern int s3c_irqext_wake(struct irq_data *data, unsigned int state);
-extern int s3c24xx_irq_suspend(struct sys_device *dev, pm_message_t state);
-extern int s3c24xx_irq_resume(struct sys_device *dev);
+extern int s3c24xx_irq_suspend(void);
+extern void s3c24xx_irq_resume(void);
 #else
 #define s3c_irqext_wake NULL
 #define s3c24xx_irq_suspend NULL
 #define s3c24xx_irq_resume  NULL
 #endif
 
+extern struct syscore_ops s3c24xx_irq_syscore_ops;
+
 /* PM debug functions */
 
 #ifdef CONFIG_SAMSUNG_PM_DEBUG
Index: linux-2.6/arch/arm/plat-s5p/irq-pm.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s5p/irq-pm.c
+++ linux-2.6/arch/arm/plat-s5p/irq-pm.c
@@ -16,7 +16,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
-#include <linux/sysdev.h>
 
 #include <plat/cpu.h>
 #include <plat/irqs.h>
@@ -77,17 +76,15 @@ static struct sleep_save eint_save[] = {
 	SAVE_ITEM(S5P_EINT_MASK(3)),
 };
 
-int s3c24xx_irq_suspend(struct sys_device *dev, pm_message_t state)
+int s3c24xx_irq_suspend(void)
 {
 	s3c_pm_do_save(eint_save, ARRAY_SIZE(eint_save));
 
 	return 0;
 }
 
-int s3c24xx_irq_resume(struct sys_device *dev)
+void s3c24xx_irq_resume(void)
 {
 	s3c_pm_do_restore(eint_save, ARRAY_SIZE(eint_save));
-
-	return 0;
 }
 
Index: linux-2.6/arch/arm/plat-s3c24xx/irq-pm.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s3c24xx/irq-pm.c
+++ linux-2.6/arch/arm/plat-s3c24xx/irq-pm.c
@@ -14,7 +14,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
-#include <linux/sysdev.h>
 #include <linux/irq.h>
 
 #include <plat/cpu.h>
@@ -65,7 +64,7 @@ static unsigned long save_extint[3];
 static unsigned long save_eintflt[4];
 static unsigned long save_eintmask;
 
-int s3c24xx_irq_suspend(struct sys_device *dev, pm_message_t state)
+int s3c24xx_irq_suspend(void)
 {
 	unsigned int i;
 
@@ -81,7 +80,7 @@ int s3c24xx_irq_suspend(struct sys_devic
 	return 0;
 }
 
-int s3c24xx_irq_resume(struct sys_device *dev)
+void s3c24xx_irq_resume(void)
 {
 	unsigned int i;
 
@@ -93,6 +92,4 @@ int s3c24xx_irq_resume(struct sys_device
 
 	s3c_pm_do_restore(irq_save, ARRAY_SIZE(irq_save));
 	__raw_writel(save_eintmask, S3C24XX_EINTMASK);
-
-	return 0;
 }
Index: linux-2.6/arch/arm/mach-s3c2410/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2410/irq.c
+++ linux-2.6/arch/arm/mach-s3c2410/irq.c
@@ -23,38 +23,12 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 
 #include <plat/cpu.h>
 #include <plat/pm.h>
 
-static int s3c2410_irq_add(struct sys_device *sysdev)
-{
-	return 0;
-}
-
-static struct sysdev_driver s3c2410_irq_driver = {
-	.add		= s3c2410_irq_add,
+struct syscore_ops s3c24xx_irq_syscore_ops = {
 	.suspend	= s3c24xx_irq_suspend,
 	.resume		= s3c24xx_irq_resume,
 };
-
-static int __init s3c2410_irq_init(void)
-{
-	return sysdev_driver_register(&s3c2410_sysclass, &s3c2410_irq_driver);
-}
-
-arch_initcall(s3c2410_irq_init);
-
-static struct sysdev_driver s3c2410a_irq_driver = {
-	.add		= s3c2410_irq_add,
-	.suspend	= s3c24xx_irq_suspend,
-	.resume		= s3c24xx_irq_resume,
-};
-
-static int __init s3c2410a_irq_init(void)
-{
-	return sysdev_driver_register(&s3c2410a_sysclass, &s3c2410a_irq_driver);
-}
-
-arch_initcall(s3c2410a_irq_init);
Index: linux-2.6/arch/arm/mach-s3c2410/pm.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2410/pm.c
+++ linux-2.6/arch/arm/mach-s3c2410/pm.c
@@ -25,6 +25,7 @@
 #include <linux/errno.h>
 #include <linux/time.h>
 #include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/gpio.h>
 #include <linux/io.h>
 
@@ -92,7 +93,7 @@ static void s3c2410_pm_prepare(void)
 	}
 }
 
-static int s3c2410_pm_resume(struct sys_device *dev)
+static void s3c2410_pm_resume(void)
 {
 	unsigned long tmp;
 
@@ -104,10 +105,12 @@ static int s3c2410_pm_resume(struct sys_
 
 	if ( machine_is_aml_m5900() )
 		s3c2410_gpio_setpin(S3C2410_GPF(2), 0);
-
-	return 0;
 }
 
+struct syscore_ops s3c2410_pm_syscore_ops = {
+	.resume		= s3c2410_pm_resume,
+};
+
 static int s3c2410_pm_add(struct sys_device *dev)
 {
 	pm_cpu_prep = s3c2410_pm_prepare;
@@ -119,7 +122,6 @@ static int s3c2410_pm_add(struct sys_dev
 #if defined(CONFIG_CPU_S3C2410)
 static struct sysdev_driver s3c2410_pm_driver = {
 	.add		= s3c2410_pm_add,
-	.resume		= s3c2410_pm_resume,
 };
 
 /* register ourselves */
@@ -133,7 +135,6 @@ arch_initcall(s3c2410_pm_drvinit);
 
 static struct sysdev_driver s3c2410a_pm_driver = {
 	.add		= s3c2410_pm_add,
-	.resume		= s3c2410_pm_resume,
 };
 
 static int __init s3c2410a_pm_drvinit(void)
@@ -147,7 +148,6 @@ arch_initcall(s3c2410a_pm_drvinit);
 #if defined(CONFIG_CPU_S3C2440)
 static struct sysdev_driver s3c2440_pm_driver = {
 	.add		= s3c2410_pm_add,
-	.resume		= s3c2410_pm_resume,
 };
 
 static int __init s3c2440_pm_drvinit(void)
@@ -161,7 +161,6 @@ arch_initcall(s3c2440_pm_drvinit);
 #if defined(CONFIG_CPU_S3C2442)
 static struct sysdev_driver s3c2442_pm_driver = {
 	.add		= s3c2410_pm_add,
-	.resume		= s3c2410_pm_resume,
 };
 
 static int __init s3c2442_pm_drvinit(void)
Index: linux-2.6/arch/arm/plat-samsung/include/plat/cpu.h
===================================================================
--- linux-2.6.orig/arch/arm/plat-samsung/include/plat/cpu.h
+++ linux-2.6/arch/arm/plat-samsung/include/plat/cpu.h
@@ -68,6 +68,12 @@ extern void s3c24xx_init_uartdevs(char *
 struct sys_timer;
 extern struct sys_timer s3c24xx_timer;
 
+extern struct syscore_ops s3c2410_pm_syscore_ops;
+extern struct syscore_ops s3c2412_pm_syscore_ops;
+extern struct syscore_ops s3c2416_pm_syscore_ops;
+extern struct syscore_ops s3c244x_pm_syscore_ops;
+extern struct syscore_ops s3c64xx_irq_syscore_ops;
+
 /* system device classes */
 
 extern struct sysdev_class s3c2410_sysclass;
Index: linux-2.6/arch/arm/mach-s3c2410/s3c2410.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2410/s3c2410.c
+++ linux-2.6/arch/arm/mach-s3c2410/s3c2410.c
@@ -19,6 +19,7 @@
 #include <linux/gpio.h>
 #include <linux/clk.h>
 #include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
@@ -40,6 +41,7 @@
 #include <plat/devs.h>
 #include <plat/clock.h>
 #include <plat/pll.h>
+#include <plat/pm.h>
 
 #include <plat/gpio-core.h>
 #include <plat/gpio-cfg.h>
@@ -168,6 +170,9 @@ int __init s3c2410_init(void)
 {
 	printk("S3C2410: Initialising architecture\n");
 
+	register_syscore_ops(&s3c2410_pm_syscore_ops);
+	register_syscore_ops(&s3c24xx_irq_syscore_ops);
+
 	return sysdev_register(&s3c2410_sysdev);
 }
 
Index: linux-2.6/arch/arm/mach-s3c2412/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2412/irq.c
+++ linux-2.6/arch/arm/mach-s3c2412/irq.c
@@ -202,8 +202,6 @@ static int s3c2412_irq_add(struct sys_de
 
 static struct sysdev_driver s3c2412_irq_driver = {
 	.add		= s3c2412_irq_add,
-	.suspend	= s3c24xx_irq_suspend,
-	.resume		= s3c24xx_irq_resume,
 };
 
 static int s3c2412_irq_init(void)
Index: linux-2.6/arch/arm/mach-s3c2412/pm.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2412/pm.c
+++ linux-2.6/arch/arm/mach-s3c2412/pm.c
@@ -17,6 +17,7 @@
 #include <linux/timer.h>
 #include <linux/init.h>
 #include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 
@@ -86,13 +87,24 @@ static struct sleep_save s3c2412_sleep[]
 	SAVE_ITEM(S3C2413_GPJSLPCON),
 };
 
-static int s3c2412_pm_suspend(struct sys_device *dev, pm_message_t state)
+static struct sysdev_driver s3c2412_pm_driver = {
+	.add		= s3c2412_pm_add,
+};
+
+static __init int s3c2412_pm_init(void)
+{
+	return sysdev_driver_register(&s3c2412_sysclass, &s3c2412_pm_driver);
+}
+
+arch_initcall(s3c2412_pm_init);
+
+static int s3c2412_pm_suspend(void)
 {
 	s3c_pm_do_save(s3c2412_sleep, ARRAY_SIZE(s3c2412_sleep));
 	return 0;
 }
 
-static int s3c2412_pm_resume(struct sys_device *dev)
+static void s3c2412_pm_resume(void)
 {
 	unsigned long tmp;
 
@@ -102,18 +114,9 @@ static int s3c2412_pm_resume(struct sys_
 	__raw_writel(tmp, S3C2412_PWRCFG);
 
 	s3c_pm_do_restore(s3c2412_sleep, ARRAY_SIZE(s3c2412_sleep));
-	return 0;
 }
 
-static struct sysdev_driver s3c2412_pm_driver = {
-	.add		= s3c2412_pm_add,
+struct syscore_ops s3c2412_pm_syscore_ops = {
 	.suspend	= s3c2412_pm_suspend,
 	.resume		= s3c2412_pm_resume,
 };
-
-static __init int s3c2412_pm_init(void)
-{
-	return sysdev_driver_register(&s3c2412_sysclass, &s3c2412_pm_driver);
-}
-
-arch_initcall(s3c2412_pm_init);
Index: linux-2.6/arch/arm/mach-s3c2412/s3c2412.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2412/s3c2412.c
+++ linux-2.6/arch/arm/mach-s3c2412/s3c2412.c
@@ -19,6 +19,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
@@ -244,5 +245,8 @@ int __init s3c2412_init(void)
 {
 	printk("S3C2412: Initialising architecture\n");
 
+	register_syscore_ops(&s3c2412_pm_syscore_ops);
+	register_syscore_ops(&s3c24xx_irq_syscore_ops);
+
 	return sysdev_register(&s3c2412_sysdev);
 }
Index: linux-2.6/arch/arm/mach-s3c2416/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2416/irq.c
+++ linux-2.6/arch/arm/mach-s3c2416/irq.c
@@ -236,8 +236,6 @@ static int __init s3c2416_irq_add(struct
 
 static struct sysdev_driver s3c2416_irq_driver = {
 	.add		= s3c2416_irq_add,
-	.suspend	= s3c24xx_irq_suspend,
-	.resume		= s3c24xx_irq_resume,
 };
 
 static int __init s3c2416_irq_init(void)
Index: linux-2.6/arch/arm/mach-s3c2416/pm.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2416/pm.c
+++ linux-2.6/arch/arm/mach-s3c2416/pm.c
@@ -11,6 +11,7 @@
 */
 
 #include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/io.h>
 
 #include <asm/cacheflush.h>
@@ -55,30 +56,26 @@ static int s3c2416_pm_add(struct sys_dev
 	return 0;
 }
 
-static int s3c2416_pm_suspend(struct sys_device *dev, pm_message_t state)
+static struct sysdev_driver s3c2416_pm_driver = {
+	.add		= s3c2416_pm_add,
+};
+
+static __init int s3c2416_pm_init(void)
 {
-	return 0;
+	return sysdev_driver_register(&s3c2416_sysclass, &s3c2416_pm_driver);
 }
 
-static int s3c2416_pm_resume(struct sys_device *dev)
+arch_initcall(s3c2416_pm_init);
+
+
+static void s3c2416_pm_resume(void)
 {
 	/* unset the return-from-sleep amd inform flags */
 	__raw_writel(0x0, S3C2443_PWRMODE);
 	__raw_writel(0x0, S3C2412_INFORM0);
 	__raw_writel(0x0, S3C2412_INFORM1);
-
-	return 0;
 }
 
-static struct sysdev_driver s3c2416_pm_driver = {
-	.add		= s3c2416_pm_add,
-	.suspend	= s3c2416_pm_suspend,
+struct syscore_ops s3c2416_pm_syscore_ops = {
 	.resume		= s3c2416_pm_resume,
 };
-
-static __init int s3c2416_pm_init(void)
-{
-	return sysdev_driver_register(&s3c2416_sysclass, &s3c2416_pm_driver);
-}
-
-arch_initcall(s3c2416_pm_init);
Index: linux-2.6/arch/arm/mach-s3c2416/s3c2416.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2416/s3c2416.c
+++ linux-2.6/arch/arm/mach-s3c2416/s3c2416.c
@@ -32,6 +32,7 @@
 #include <linux/platform_device.h>
 #include <linux/serial_core.h>
 #include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/clk.h>
 #include <linux/io.h>
 
@@ -54,6 +55,7 @@
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/sdhci.h>
+#include <plat/pm.h>
 
 #include <plat/iic-core.h>
 #include <plat/fb-core.h>
@@ -95,6 +97,9 @@ int __init s3c2416_init(void)
 
 	s3c_fb_setname("s3c2443-fb");
 
+	register_syscore_ops(&s3c2416_pm_syscore_ops);
+	register_syscore_ops(&s3c24xx_irq_syscore_ops);
+
 	return sysdev_register(&s3c2416_sysdev);
 }
 
Index: linux-2.6/arch/arm/mach-s3c2440/s3c244x-irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2440/s3c244x-irq.c
+++ linux-2.6/arch/arm/mach-s3c2440/s3c244x-irq.c
@@ -116,8 +116,6 @@ static int s3c244x_irq_add(struct sys_de
 
 static struct sysdev_driver s3c2440_irq_driver = {
 	.add		= s3c244x_irq_add,
-	.suspend	= s3c24xx_irq_suspend,
-	.resume		= s3c24xx_irq_resume,
 };
 
 static int s3c2440_irq_init(void)
@@ -129,8 +127,6 @@ arch_initcall(s3c2440_irq_init);
 
 static struct sysdev_driver s3c2442_irq_driver = {
 	.add		= s3c244x_irq_add,
-	.suspend	= s3c24xx_irq_suspend,
-	.resume		= s3c24xx_irq_resume,
 };
 
 
Index: linux-2.6/arch/arm/mach-s3c2440/s3c244x.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2440/s3c244x.c
+++ linux-2.6/arch/arm/mach-s3c2440/s3c244x.c
@@ -19,6 +19,7 @@
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
 #include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/clk.h>
 #include <linux/io.h>
 
@@ -134,45 +135,14 @@ void __init s3c244x_init_clocks(int xtal
 	s3c2410_baseclk_add();
 }
 
-#ifdef CONFIG_PM
-
-static struct sleep_save s3c244x_sleep[] = {
-	SAVE_ITEM(S3C2440_DSC0),
-	SAVE_ITEM(S3C2440_DSC1),
-	SAVE_ITEM(S3C2440_GPJDAT),
-	SAVE_ITEM(S3C2440_GPJCON),
-	SAVE_ITEM(S3C2440_GPJUP)
-};
-
-static int s3c244x_suspend(struct sys_device *dev, pm_message_t state)
-{
-	s3c_pm_do_save(s3c244x_sleep, ARRAY_SIZE(s3c244x_sleep));
-	return 0;
-}
-
-static int s3c244x_resume(struct sys_device *dev)
-{
-	s3c_pm_do_restore(s3c244x_sleep, ARRAY_SIZE(s3c244x_sleep));
-	return 0;
-}
-
-#else
-#define s3c244x_suspend NULL
-#define s3c244x_resume  NULL
-#endif
-
 /* Since the S3C2442 and S3C2440 share  items, put both sysclasses here */
 
 struct sysdev_class s3c2440_sysclass = {
 	.name		= "s3c2440-core",
-	.suspend	= s3c244x_suspend,
-	.resume		= s3c244x_resume
 };
 
 struct sysdev_class s3c2442_sysclass = {
 	.name		= "s3c2442-core",
-	.suspend	= s3c244x_suspend,
-	.resume		= s3c244x_resume
 };
 
 /* need to register class before we actually register the device, and
@@ -194,3 +164,33 @@ static int __init s3c2442_core_init(void
 }
 
 core_initcall(s3c2442_core_init);
+
+
+#ifdef CONFIG_PM
+static struct sleep_save s3c244x_sleep[] = {
+	SAVE_ITEM(S3C2440_DSC0),
+	SAVE_ITEM(S3C2440_DSC1),
+	SAVE_ITEM(S3C2440_GPJDAT),
+	SAVE_ITEM(S3C2440_GPJCON),
+	SAVE_ITEM(S3C2440_GPJUP)
+};
+
+static int s3c244x_suspend(void)
+{
+	s3c_pm_do_save(s3c244x_sleep, ARRAY_SIZE(s3c244x_sleep));
+	return 0;
+}
+
+static void s3c244x_resume(void)
+{
+	s3c_pm_do_restore(s3c244x_sleep, ARRAY_SIZE(s3c244x_sleep));
+}
+#else
+#define s3c244x_suspend NULL
+#define s3c244x_resume  NULL
+#endif
+
+struct syscore_ops s3c244x_pm_syscore_ops = {
+	.suspend	= s3c244x_suspend,
+	.resume		= s3c244x_resume,
+};
Index: linux-2.6/arch/arm/mach-s3c2440/s3c2440.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2440/s3c2440.c
+++ linux-2.6/arch/arm/mach-s3c2440/s3c2440.c
@@ -19,6 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/serial_core.h>
 #include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/gpio.h>
 #include <linux/clk.h>
 #include <linux/io.h>
@@ -33,6 +34,7 @@
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/s3c244x.h>
+#include <plat/pm.h>
 
 #include <plat/gpio-core.h>
 #include <plat/gpio-cfg.h>
@@ -51,6 +53,12 @@ int __init s3c2440_init(void)
 	s3c_device_wdt.resource[1].start = IRQ_S3C2440_WDT;
 	s3c_device_wdt.resource[1].end   = IRQ_S3C2440_WDT;
 
+	/* register suspend/resume handlers */
+
+	register_syscore_ops(&s3c2410_pm_syscore_ops);
+	register_syscore_ops(&s3c244x_pm_syscore_ops);
+	register_syscore_ops(&s3c24xx_irq_syscore_ops);
+
 	/* register our system device for everything else */
 
 	return sysdev_register(&s3c2440_sysdev);
Index: linux-2.6/arch/arm/mach-s3c2440/s3c2442.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2440/s3c2442.c
+++ linux-2.6/arch/arm/mach-s3c2440/s3c2442.c
@@ -29,6 +29,7 @@
 #include <linux/err.h>
 #include <linux/device.h>
 #include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/mutex.h>
@@ -45,6 +46,7 @@
 #include <plat/clock.h>
 #include <plat/cpu.h>
 #include <plat/s3c244x.h>
+#include <plat/pm.h>
 
 #include <plat/gpio-core.h>
 #include <plat/gpio-cfg.h>
@@ -167,6 +169,10 @@ int __init s3c2442_init(void)
 {
 	printk("S3C2442: Initialising architecture\n");
 
+	register_syscore_ops(&s3c2410_pm_syscore_ops);
+	register_syscore_ops(&s3c244x_pm_syscore_ops);
+	register_syscore_ops(&s3c24xx_irq_syscore_ops);
+
 	return sysdev_register(&s3c2442_sysdev);
 }
 
Index: linux-2.6/arch/arm/mach-s3c64xx/irq-pm.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c64xx/irq-pm.c
+++ linux-2.6/arch/arm/mach-s3c64xx/irq-pm.c
@@ -13,7 +13,7 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/interrupt.h>
 #include <linux/serial_core.h>
 #include <linux/irq.h>
@@ -54,7 +54,7 @@ static struct irq_grp_save {
 
 static u32 irq_uart_mask[CONFIG_SERIAL_SAMSUNG_UARTS];
 
-static int s3c64xx_irq_pm_suspend(struct sys_device *dev, pm_message_t state)
+static int s3c64xx_irq_pm_suspend(void)
 {
 	struct irq_grp_save *grp = eint_grp_save;
 	int i;
@@ -75,7 +75,7 @@ static int s3c64xx_irq_pm_suspend(struct
 	return 0;
 }
 
-static int s3c64xx_irq_pm_resume(struct sys_device *dev)
+static void s3c64xx_irq_pm_resume(void)
 {
 	struct irq_grp_save *grp = eint_grp_save;
 	int i;
@@ -94,18 +94,18 @@ static int s3c64xx_irq_pm_resume(struct
 	}
 
 	S3C_PMDBG("%s: IRQ configuration restored\n", __func__);
-	return 0;
 }
 
-static struct sysdev_driver s3c64xx_irq_driver = {
+struct syscore_ops s3c64xx_irq_syscore_ops = {
 	.suspend = s3c64xx_irq_pm_suspend,
 	.resume	 = s3c64xx_irq_pm_resume,
 };
 
-static int __init s3c64xx_irq_pm_init(void)
+static __init int s3c64xx_syscore_init(void)
 {
-	return sysdev_driver_register(&s3c64xx_sysclass, &s3c64xx_irq_driver);
-}
+	register_syscore_ops(&s3c64xx_irq_syscore_ops);
 
-arch_initcall(s3c64xx_irq_pm_init);
+	return 0;
+}
 
+core_initcall(s3c64xx_syscore_init);
Index: linux-2.6/arch/arm/mach-s5pv210/pm.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s5pv210/pm.c
+++ linux-2.6/arch/arm/mach-s5pv210/pm.c
@@ -16,6 +16,7 @@
 
 #include <linux/init.h>
 #include <linux/suspend.h>
+#include <linux/syscore_ops.h>
 #include <linux/io.h>
 
 #include <plat/cpu.h>
@@ -140,7 +141,17 @@ static int s5pv210_pm_add(struct sys_dev
 	return 0;
 }
 
-static int s5pv210_pm_resume(struct sys_device *dev)
+static struct sysdev_driver s5pv210_pm_driver = {
+	.add		= s5pv210_pm_add,
+};
+
+static __init int s5pv210_pm_drvinit(void)
+{
+	return sysdev_driver_register(&s5pv210_sysclass, &s5pv210_pm_driver);
+}
+arch_initcall(s5pv210_pm_drvinit);
+
+static void s5pv210_pm_resume(void)
 {
 	u32 tmp;
 
@@ -150,17 +161,15 @@ static int s5pv210_pm_resume(struct sys_
 	__raw_writel(tmp , S5P_OTHERS);
 
 	s3c_pm_do_restore_core(s5pv210_core_save, ARRAY_SIZE(s5pv210_core_save));
-
-	return 0;
 }
 
-static struct sysdev_driver s5pv210_pm_driver = {
-	.add		= s5pv210_pm_add,
+static struct syscore_ops s5pv210_pm_syscore_ops = {
 	.resume		= s5pv210_pm_resume,
 };
 
-static __init int s5pv210_pm_drvinit(void)
+static __init int s5pv210_pm_syscore_init(void)
 {
-	return sysdev_driver_register(&s5pv210_sysclass, &s5pv210_pm_driver);
+	register_syscore_ops(&s5pv210_pm_syscore_ops);
+	return 0;
 }
-arch_initcall(s5pv210_pm_drvinit);
+arch_initcall(s5pv210_pm_syscore_init);
Index: linux-2.6/arch/arm/mach-exynos4/pm.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-exynos4/pm.c
+++ linux-2.6/arch/arm/mach-exynos4/pm.c
@@ -16,6 +16,7 @@
 
 #include <linux/init.h>
 #include <linux/suspend.h>
+#include <linux/syscore_ops.h>
 #include <linux/io.h>
 
 #include <asm/cacheflush.h>
@@ -372,7 +373,27 @@ void exynos4_scu_enable(void __iomem *sc
 	flush_cache_all();
 }
 
-static int exynos4_pm_resume(struct sys_device *dev)
+static struct sysdev_driver exynos4_pm_driver = {
+	.add		= exynos4_pm_add,
+};
+
+static __init int exynos4_pm_drvinit(void)
+{
+	unsigned int tmp;
+
+	s3c_pm_init();
+
+	/* All wakeup disable */
+
+	tmp = __raw_readl(S5P_WAKEUP_MASK);
+	tmp |= ((0xFF << 8) | (0x1F << 1));
+	__raw_writel(tmp, S5P_WAKEUP_MASK);
+
+	return sysdev_driver_register(&exynos4_sysclass, &exynos4_pm_driver);
+}
+arch_initcall(exynos4_pm_drvinit);
+
+static void exynos4_pm_resume(void)
 {
 	/* For release retention */
 
@@ -394,27 +415,15 @@ static int exynos4_pm_resume(struct sys_
 	/* enable L2X0*/
 	writel_relaxed(1, S5P_VA_L2CC + L2X0_CTRL);
 #endif
-
-	return 0;
 }
 
-static struct sysdev_driver exynos4_pm_driver = {
-	.add		= exynos4_pm_add,
+static struct syscore_ops exynos4_pm_syscore_ops = {
 	.resume		= exynos4_pm_resume,
 };
 
-static __init int exynos4_pm_drvinit(void)
+static __init int exynos4_pm_syscore_init(void)
 {
-	unsigned int tmp;
-
-	s3c_pm_init();
-
-	/* All wakeup disable */
-
-	tmp = __raw_readl(S5P_WAKEUP_MASK);
-	tmp |= ((0xFF << 8) | (0x1F << 1));
-	__raw_writel(tmp, S5P_WAKEUP_MASK);
-
-	return sysdev_driver_register(&exynos4_sysclass, &exynos4_pm_driver);
+	register_syscore_ops(&exynos4_pm_syscore_ops);
+	return 0;
 }
-arch_initcall(exynos4_pm_drvinit);
+arch_initcall(exynos4_pm_syscore_init);
Index: linux-2.6/arch/arm/mach-s3c2410/mach-bast.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2410/mach-bast.c
+++ linux-2.6/arch/arm/mach-s3c2410/mach-bast.c
@@ -17,7 +17,7 @@
 #include <linux/timer.h>
 #include <linux/init.h>
 #include <linux/gpio.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
 #include <linux/dm9000.h>
@@ -214,17 +214,16 @@ static struct s3c2410_uartcfg bast_uartc
 /* NAND Flash on BAST board */
 
 #ifdef CONFIG_PM
-static int bast_pm_suspend(struct sys_device *sd, pm_message_t state)
+static int bast_pm_suspend(void)
 {
 	/* ensure that an nRESET is not generated on resume. */
 	gpio_direction_output(S3C2410_GPA(21), 1);
 	return 0;
 }
 
-static int bast_pm_resume(struct sys_device *sd)
+static void bast_pm_resume(void)
 {
 	s3c_gpio_cfgpin(S3C2410_GPA(21), S3C2410_GPA21_nRSTOUT);
-	return 0;
 }
 
 #else
@@ -232,16 +231,11 @@ static int bast_pm_resume(struct sys_dev
 #define bast_pm_resume NULL
 #endif
 
-static struct sysdev_class bast_pm_sysclass = {
-	.name		= "mach-bast",
+static struct syscore_ops bast_pm_syscore_ops = {
 	.suspend	= bast_pm_suspend,
 	.resume		= bast_pm_resume,
 };
 
-static struct sys_device bast_pm_sysdev = {
-	.cls		= &bast_pm_sysclass,
-};
-
 static int smartmedia_map[] = { 0 };
 static int chip0_map[] = { 1 };
 static int chip1_map[] = { 2 };
@@ -642,8 +636,7 @@ static void __init bast_map_io(void)
 
 static void __init bast_init(void)
 {
-	sysdev_class_register(&bast_pm_sysclass);
-	sysdev_register(&bast_pm_sysdev);
+	register_syscore_ops(&bast_pm_syscore_ops);
 
 	s3c_i2c0_set_platdata(&bast_i2c_info);
 	s3c_nand_set_platdata(&bast_nand_info);
Index: linux-2.6/arch/arm/plat-s3c24xx/dma.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s3c24xx/dma.c
+++ linux-2.6/arch/arm/plat-s3c24xx/dma.c
@@ -22,7 +22,7 @@
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/io.h>
@@ -1195,19 +1195,12 @@ int s3c2410_dma_getposition(unsigned int
 
 EXPORT_SYMBOL(s3c2410_dma_getposition);
 
-static inline struct s3c2410_dma_chan *to_dma_chan(struct sys_device *dev)
-{
-	return container_of(dev, struct s3c2410_dma_chan, dev);
-}
-
-/* system device class */
+/* system core operations */
 
 #ifdef CONFIG_PM
 
-static int s3c2410_dma_suspend(struct sys_device *dev, pm_message_t state)
+static void s3c2410_dma_suspend_chan(s3c2410_dma_chan *cp)
 {
-	struct s3c2410_dma_chan *cp = to_dma_chan(dev);
-
 	printk(KERN_DEBUG "suspending dma channel %d\n", cp->number);
 
 	if (dma_rdreg(cp, S3C2410_DMA_DMASKTRIG) & S3C2410_DMASKTRIG_ON) {
@@ -1222,13 +1215,21 @@ static int s3c2410_dma_suspend(struct sy
 
 		s3c2410_dma_dostop(cp);
 	}
+}
+
+static int s3c2410_dma_suspend(void)
+{
+	struct s3c2410_dma_chan *cp = s3c2410_chans;
+	int channel;
+
+	for (channel = 0; channel < dma_channels; cp++, channel++)
+		s3c2410_dma_suspend_chan(cp);
 
 	return 0;
 }
 
-static int s3c2410_dma_resume(struct sys_device *dev)
+static void s3c2410_dma_resume_chan(struct s3c2410_dma_chan *cp)
 {
-	struct s3c2410_dma_chan *cp = to_dma_chan(dev);
 	unsigned int no = cp->number | DMACH_LOW_LEVEL;
 
 	/* restore channel's hardware configuration */
@@ -1249,13 +1250,21 @@ static int s3c2410_dma_resume(struct sys
 	return 0;
 }
 
+static void s3c2410_dma_resume(void)
+{
+	struct s3c2410_dma_chan *cp = s3c2410_chans + dma_channels - 1;
+	int channel;
+
+	for (channel = dma_channels - 1; channel >= 0; cp++, channel--)
+		s3c2410_dma_resume_chan(cp);
+}
+
 #else
 #define s3c2410_dma_suspend NULL
 #define s3c2410_dma_resume  NULL
 #endif /* CONFIG_PM */
 
-struct sysdev_class dma_sysclass = {
-	.name		= "s3c24xx-dma",
+struct syscore_ops dma_syscore_ops = {
 	.suspend	= s3c2410_dma_suspend,
 	.resume		= s3c2410_dma_resume,
 };
@@ -1269,39 +1278,14 @@ static void s3c2410_dma_cache_ctor(void
 
 /* initialisation code */
 
-static int __init s3c24xx_dma_sysclass_init(void)
+static int __init s3c24xx_dma_syscore_init(void)
 {
-	int ret = sysdev_class_register(&dma_sysclass);
-
-	if (ret != 0)
-		printk(KERN_ERR "dma sysclass registration failed\n");
-
-	return ret;
-}
-
-core_initcall(s3c24xx_dma_sysclass_init);
-
-static int __init s3c24xx_dma_sysdev_register(void)
-{
-	struct s3c2410_dma_chan *cp = s3c2410_chans;
-	int channel, ret;
-
-	for (channel = 0; channel < dma_channels; cp++, channel++) {
-		cp->dev.cls = &dma_sysclass;
-		cp->dev.id  = channel;
-		ret = sysdev_register(&cp->dev);
-
-		if (ret) {
-			printk(KERN_ERR "error registering dev for dma %d\n",
-			       channel);
- 			return ret;
-		}
-	}
+	register_syscore_ops(&dma_syscore_ops);
 
 	return 0;
 }
 
-late_initcall(s3c24xx_dma_sysdev_register);
+late_initcall(s3c24xx_dma_syscore_init);
 
 int __init s3c24xx_dma_init(unsigned int channels, unsigned int irq,
 			    unsigned int stride)
Index: linux-2.6/arch/arm/mach-s3c2440/mach-osiris.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2440/mach-osiris.c
+++ linux-2.6/arch/arm/mach-s3c2440/mach-osiris.c
@@ -17,7 +17,7 @@
 #include <linux/init.h>
 #include <linux/gpio.h>
 #include <linux/device.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/serial_core.h>
 #include <linux/clk.h>
 #include <linux/i2c.h>
@@ -284,7 +284,7 @@ static struct platform_device osiris_pcm
 #ifdef CONFIG_PM
 static unsigned char pm_osiris_ctrl0;
 
-static int osiris_pm_suspend(struct sys_device *sd, pm_message_t state)
+static int osiris_pm_suspend(void)
 {
 	unsigned int tmp;
 
@@ -304,7 +304,7 @@ static int osiris_pm_suspend(struct sys_
 	return 0;
 }
 
-static int osiris_pm_resume(struct sys_device *sd)
+static void osiris_pm_resume(void)
 {
 	if (pm_osiris_ctrl0 & OSIRIS_CTRL0_FIX8)
 		__raw_writeb(OSIRIS_CTRL1_FIX8, OSIRIS_VA_CTRL1);
@@ -312,8 +312,6 @@ static int osiris_pm_resume(struct sys_d
 	__raw_writeb(pm_osiris_ctrl0, OSIRIS_VA_CTRL0);
 
 	s3c_gpio_cfgpin(S3C2410_GPA(21), S3C2410_GPA21_nRSTOUT);
-
-	return 0;
 }
 
 #else
@@ -321,16 +319,11 @@ static int osiris_pm_resume(struct sys_d
 #define osiris_pm_resume NULL
 #endif
 
-static struct sysdev_class osiris_pm_sysclass = {
-	.name		= "mach-osiris",
+static struct syscore_ops osiris_pm_syscore_ops = {
 	.suspend	= osiris_pm_suspend,
 	.resume		= osiris_pm_resume,
 };
 
-static struct sys_device osiris_pm_sysdev = {
-	.cls		= &osiris_pm_sysclass,
-};
-
 /* Link for DVS driver to TPS65011 */
 
 static void osiris_tps_release(struct device *dev)
@@ -439,8 +432,7 @@ static void __init osiris_map_io(void)
 
 static void __init osiris_init(void)
 {
-	sysdev_class_register(&osiris_pm_sysclass);
-	sysdev_register(&osiris_pm_sysdev);
+	register_syscore_ops(&osiris_pm_syscore_ops);
 
 	s3c_i2c0_set_platdata(NULL);
 	s3c_nand_set_platdata(&osiris_nand_info);
Index: linux-2.6/arch/arm/mach-s3c2412/mach-jive.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2412/mach-jive.c
+++ linux-2.6/arch/arm/mach-s3c2412/mach-jive.c
@@ -17,7 +17,7 @@
 #include <linux/timer.h>
 #include <linux/init.h>
 #include <linux/gpio.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
@@ -486,7 +486,7 @@ static struct s3c2410_udc_mach_info jive
 /* Jive power management device */
 
 #ifdef CONFIG_PM
-static int jive_pm_suspend(struct sys_device *sd, pm_message_t state)
+static int jive_pm_suspend(void)
 {
 	/* Write the magic value u-boot uses to check for resume into
 	 * the INFORM0 register, and ensure INFORM1 is set to the
@@ -498,10 +498,9 @@ static int jive_pm_suspend(struct sys_de
 	return 0;
 }
 
-static int jive_pm_resume(struct sys_device *sd)
+static void jive_pm_resume(void)
 {
 	__raw_writel(0x0, S3C2412_INFORM0);
-	return 0;
 }
 
 #else
@@ -509,16 +508,11 @@ static int jive_pm_resume(struct sys_dev
 #define jive_pm_resume NULL
 #endif
 
-static struct sysdev_class jive_pm_sysclass = {
-	.name		= "jive-pm",
+static struct syscore_ops jive_pm_syscore_ops = {
 	.suspend	= jive_pm_suspend,
 	.resume		= jive_pm_resume,
 };
 
-static struct sys_device jive_pm_sysdev = {
-	.cls		= &jive_pm_sysclass,
-};
-
 static void __init jive_map_io(void)
 {
 	s3c24xx_init_io(jive_iodesc, ARRAY_SIZE(jive_iodesc));
@@ -536,10 +530,9 @@ static void jive_power_off(void)
 
 static void __init jive_machine_init(void)
 {
-	/* register system devices for managing low level suspend */
+	/* register system core operations for managing low level suspend */
 
-	sysdev_class_register(&jive_pm_sysclass);
-	sysdev_register(&jive_pm_sysdev);
+	register_syscore_ops(&jive_pm_syscore_ops);
 
 	/* write our sleep configurations for the IO. Pull down all unused
 	 * IO, ensure that we have turned off all peripherals we do not

