Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1DQVRM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 17:17:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57737 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab1DQVQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 17:16:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/14] ARM / PXA: Use struct syscore_ops for "core" power management
Date: Sun, 17 Apr 2011 23:10:41 +0200
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
Message-Id: <201104172310.41839.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Replace sysdev classes and struct sys_device objects used for "core"
power management by the PXA platform code with struct syscore_ops
objects that are simpler.

This reduces the code size and the kernel memory footprint.  It also
is necessary for removing sysdevs entirely from the kernel in the
future.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-pxa/balloon3.c              |    1 
 arch/arm/mach-pxa/clock-pxa2xx.c          |   18 ++----------
 arch/arm/mach-pxa/clock-pxa3xx.c          |   17 ++---------
 arch/arm/mach-pxa/clock.h                 |    7 ++--
 arch/arm/mach-pxa/cm-x270.c               |    1 
 arch/arm/mach-pxa/cm-x2xx.c               |   23 ++++------------
 arch/arm/mach-pxa/colibri-evalboard.c     |    1 
 arch/arm/mach-pxa/colibri-pxa270-income.c |    1 
 arch/arm/mach-pxa/colibri-pxa270.c        |    1 
 arch/arm/mach-pxa/generic.h               |    8 ++---
 arch/arm/mach-pxa/irq.c                   |   17 ++---------
 arch/arm/mach-pxa/lpd270.c                |   20 ++++---------
 arch/arm/mach-pxa/lubbock.c               |   21 ++++----------
 arch/arm/mach-pxa/mainstone.c             |   22 ++++-----------
 arch/arm/mach-pxa/mfp-pxa2xx.c            |   12 +++-----
 arch/arm/mach-pxa/mfp-pxa3xx.c            |   21 +++-----------
 arch/arm/mach-pxa/mioa701.c               |   43 +++++-------------------------
 arch/arm/mach-pxa/palmld.c                |    1 
 arch/arm/mach-pxa/palmtreo.c              |    1 
 arch/arm/mach-pxa/palmz72.c               |   24 +++++-----------
 arch/arm/mach-pxa/pxa25x.c                |   25 ++++-------------
 arch/arm/mach-pxa/pxa27x.c                |   25 ++++-------------
 arch/arm/mach-pxa/pxa3xx.c                |   25 ++++-------------
 arch/arm/mach-pxa/pxa95x.c                |   20 ++-----------
 arch/arm/mach-pxa/raumfeld.c              |    1 
 arch/arm/mach-pxa/smemc.c                 |   29 ++++----------------
 arch/arm/mach-pxa/trizeps4.c              |    1 
 arch/arm/mach-pxa/viper.c                 |   12 ++++----
 arch/arm/mach-pxa/vpac270.c               |    1 
 arch/arm/plat-pxa/gpio.c                  |   17 ++---------
 arch/arm/plat-pxa/mfp.c                   |    1 
 31 files changed, 110 insertions(+), 307 deletions(-)

Index: linux-2.6/arch/arm/plat-pxa/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-pxa/gpio.c
+++ linux-2.6/arch/arm/plat-pxa/gpio.c
@@ -15,7 +15,7 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/io.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/slab.h>
 
 #include <mach/gpio.h>
@@ -295,7 +295,7 @@ void __init pxa_init_gpio(int mux_irq, i
 }
 
 #ifdef CONFIG_PM
-static int pxa_gpio_suspend(struct sys_device *dev, pm_message_t state)
+static int pxa_gpio_suspend(void)
 {
 	struct pxa_gpio_chip *c;
 	int gpio;
@@ -312,7 +312,7 @@ static int pxa_gpio_suspend(struct sys_d
 	return 0;
 }
 
-static int pxa_gpio_resume(struct sys_device *dev)
+static void pxa_gpio_resume(void)
 {
 	struct pxa_gpio_chip *c;
 	int gpio;
@@ -326,22 +326,13 @@ static int pxa_gpio_resume(struct sys_de
 		__raw_writel(c->saved_gfer, c->regbase + GFER_OFFSET);
 		__raw_writel(c->saved_gpdr, c->regbase + GPDR_OFFSET);
 	}
-	return 0;
 }
 #else
 #define pxa_gpio_suspend	NULL
 #define pxa_gpio_resume		NULL
 #endif
 
-struct sysdev_class pxa_gpio_sysclass = {
-	.name		= "gpio",
+struct syscore_ops pxa_gpio_syscore_ops = {
 	.suspend	= pxa_gpio_suspend,
 	.resume		= pxa_gpio_resume,
 };
-
-static int __init pxa_gpio_init(void)
-{
-	return sysdev_class_register(&pxa_gpio_sysclass);
-}
-
-core_initcall(pxa_gpio_init);
Index: linux-2.6/arch/arm/mach-pxa/generic.h
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/generic.h
+++ linux-2.6/arch/arm/mach-pxa/generic.h
@@ -61,10 +61,10 @@ extern unsigned pxa3xx_get_clk_frequency
 #define pxa3xx_get_clk_frequency_khz(x)		(0)
 #endif
 
-extern struct sysdev_class pxa_irq_sysclass;
-extern struct sysdev_class pxa_gpio_sysclass;
-extern struct sysdev_class pxa2xx_mfp_sysclass;
-extern struct sysdev_class pxa3xx_mfp_sysclass;
+extern struct syscore_ops pxa_irq_syscore_ops;
+extern struct syscore_ops pxa_gpio_syscore_ops;
+extern struct syscore_ops pxa2xx_mfp_syscore_ops;
+extern struct syscore_ops pxa3xx_mfp_syscore_ops;
 
 void __init pxa_set_ffuart_info(void *info);
 void __init pxa_set_btuart_info(void *info);
Index: linux-2.6/arch/arm/mach-pxa/pxa95x.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/pxa95x.c
+++ linux-2.6/arch/arm/mach-pxa/pxa95x.c
@@ -18,7 +18,7 @@
 #include <linux/i2c/pxa-i2c.h>
 #include <linux/irq.h>
 #include <linux/io.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 
 #include <mach/hardware.h>
 #include <mach/gpio.h>
@@ -260,16 +260,6 @@ static struct platform_device *devices[]
 	&pxa27x_device_pwm1,
 };
 
-static struct sys_device pxa95x_sysdev[] = {
-	{
-		.cls	= &pxa_irq_sysclass,
-	}, {
-		.cls	= &pxa_gpio_sysclass,
-	}, {
-		.cls	= &pxa3xx_clock_sysclass,
-	}
-};
-
 static int __init pxa95x_init(void)
 {
 	int ret = 0, i;
@@ -293,11 +283,9 @@ static int __init pxa95x_init(void)
 		if ((ret = pxa_init_dma(IRQ_DMA, 32)))
 			return ret;
 
-		for (i = 0; i < ARRAY_SIZE(pxa95x_sysdev); i++) {
-			ret = sysdev_register(&pxa95x_sysdev[i]);
-			if (ret)
-				pr_err("failed to register sysdev[%d]\n", i);
-		}
+		register_syscore_ops(&pxa_irq_syscore_ops);
+		register_syscore_ops(&pxa_gpio_syscore_ops);
+		register_syscore_ops(&pxa3xx_clock_syscore_ops);
 
 		ret = platform_add_devices(devices, ARRAY_SIZE(devices));
 	}
Index: linux-2.6/arch/arm/mach-pxa/clock-pxa3xx.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/clock-pxa3xx.c
+++ linux-2.6/arch/arm/mach-pxa/clock-pxa3xx.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/syscore_ops.h>
 
 #include <mach/smemc.h>
 #include <mach/pxa3xx-regs.h>
@@ -182,7 +183,7 @@ const struct clkops clk_pxa3xx_pout_ops
 static uint32_t cken[2];
 static uint32_t accr;
 
-static int pxa3xx_clock_suspend(struct sys_device *d, pm_message_t state)
+static int pxa3xx_clock_suspend(void)
 {
 	cken[0] = CKENA;
 	cken[1] = CKENB;
@@ -190,28 +191,18 @@ static int pxa3xx_clock_suspend(struct s
 	return 0;
 }
 
-static int pxa3xx_clock_resume(struct sys_device *d)
+static void pxa3xx_clock_resume(void)
 {
 	ACCR = accr;
 	CKENA = cken[0];
 	CKENB = cken[1];
-	return 0;
 }
 #else
 #define pxa3xx_clock_suspend	NULL
 #define pxa3xx_clock_resume	NULL
 #endif
 
-struct sysdev_class pxa3xx_clock_sysclass = {
-	.name		= "pxa3xx-clock",
+struct syscore_ops pxa3xx_clock_syscore_ops = {
 	.suspend	= pxa3xx_clock_suspend,
 	.resume		= pxa3xx_clock_resume,
 };
-
-static int __init pxa3xx_clock_init(void)
-{
-	if (cpu_is_pxa3xx() || cpu_is_pxa95x())
-		return sysdev_class_register(&pxa3xx_clock_sysclass);
-	return 0;
-}
-postcore_initcall(pxa3xx_clock_init);
Index: linux-2.6/arch/arm/mach-pxa/clock.h
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/clock.h
+++ linux-2.6/arch/arm/mach-pxa/clock.h
@@ -1,5 +1,5 @@
 #include <linux/clkdev.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 
 struct clkops {
 	void			(*enable)(struct clk *);
@@ -54,7 +54,7 @@ extern const struct clkops clk_pxa2xx_ck
 void clk_pxa2xx_cken_enable(struct clk *clk);
 void clk_pxa2xx_cken_disable(struct clk *clk);
 
-extern struct sysdev_class pxa2xx_clock_sysclass;
+extern struct syscore_ops pxa2xx_clock_syscore_ops;
 
 #if defined(CONFIG_PXA3xx) || defined(CONFIG_PXA95x)
 #define DEFINE_PXA3_CKEN(_name, _cken, _rate, _delay)	\
@@ -74,5 +74,6 @@ extern const struct clkops clk_pxa3xx_sm
 extern void clk_pxa3xx_cken_enable(struct clk *);
 extern void clk_pxa3xx_cken_disable(struct clk *);
 
-extern struct sysdev_class pxa3xx_clock_sysclass;
+extern struct syscore_ops pxa3xx_clock_syscore_ops;
+
 #endif
Index: linux-2.6/arch/arm/mach-pxa/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/irq.c
+++ linux-2.6/arch/arm/mach-pxa/irq.c
@@ -15,7 +15,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/io.h>
 #include <linux/irq.h>
 
@@ -183,7 +183,7 @@ void __init pxa_init_irq(int irq_nr, set
 static unsigned long saved_icmr[MAX_INTERNAL_IRQS/32];
 static unsigned long saved_ipr[MAX_INTERNAL_IRQS];
 
-static int pxa_irq_suspend(struct sys_device *dev, pm_message_t state)
+static int pxa_irq_suspend(void)
 {
 	int i;
 
@@ -202,7 +202,7 @@ static int pxa_irq_suspend(struct sys_de
 	return 0;
 }
 
-static int pxa_irq_resume(struct sys_device *dev)
+static void pxa_irq_resume(void)
 {
 	int i;
 
@@ -218,22 +218,13 @@ static int pxa_irq_resume(struct sys_dev
 			__raw_writel(saved_ipr[i], IRQ_BASE + IPR(i));
 
 	__raw_writel(1, IRQ_BASE + ICCR);
-	return 0;
 }
 #else
 #define pxa_irq_suspend		NULL
 #define pxa_irq_resume		NULL
 #endif
 
-struct sysdev_class pxa_irq_sysclass = {
-	.name		= "irq",
+struct syscore_ops pxa_irq_syscore_ops = {
 	.suspend	= pxa_irq_suspend,
 	.resume		= pxa_irq_resume,
 };
-
-static int __init pxa_irq_init(void)
-{
-	return sysdev_class_register(&pxa_irq_sysclass);
-}
-
-core_initcall(pxa_irq_init);
Index: linux-2.6/arch/arm/mach-pxa/clock-pxa2xx.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/clock-pxa2xx.c
+++ linux-2.6/arch/arm/mach-pxa/clock-pxa2xx.c
@@ -9,7 +9,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 
 #include <mach/pxa2xx-regs.h>
 
@@ -33,32 +33,22 @@ const struct clkops clk_pxa2xx_cken_ops
 #ifdef CONFIG_PM
 static uint32_t saved_cken;
 
-static int pxa2xx_clock_suspend(struct sys_device *d, pm_message_t state)
+static int pxa2xx_clock_suspend(void)
 {
 	saved_cken = CKEN;
 	return 0;
 }
 
-static int pxa2xx_clock_resume(struct sys_device *d)
+static void pxa2xx_clock_resume(void)
 {
 	CKEN = saved_cken;
-	return 0;
 }
 #else
 #define pxa2xx_clock_suspend	NULL
 #define pxa2xx_clock_resume	NULL
 #endif
 
-struct sysdev_class pxa2xx_clock_sysclass = {
-	.name		= "pxa2xx-clock",
+struct syscore_ops pxa2xx_clock_syscore_ops = {
 	.suspend	= pxa2xx_clock_suspend,
 	.resume		= pxa2xx_clock_resume,
 };
-
-static int __init pxa2xx_clock_init(void)
-{
-	if (cpu_is_pxa2xx())
-		return sysdev_class_register(&pxa2xx_clock_sysclass);
-	return 0;
-}
-postcore_initcall(pxa2xx_clock_init);
Index: linux-2.6/arch/arm/mach-pxa/mfp-pxa3xx.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/mfp-pxa3xx.c
+++ linux-2.6/arch/arm/mach-pxa/mfp-pxa3xx.c
@@ -17,7 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/io.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 
 #include <mach/hardware.h>
 #include <mach/mfp-pxa3xx.h>
@@ -31,13 +31,13 @@
  * a pull-down mode if they're an active low chip select, and we're
  * just entering standby.
  */
-static int pxa3xx_mfp_suspend(struct sys_device *d, pm_message_t state)
+static int pxa3xx_mfp_suspend(void)
 {
 	mfp_config_lpm();
 	return 0;
 }
 
-static int pxa3xx_mfp_resume(struct sys_device *d)
+static void pxa3xx_mfp_resume(void)
 {
 	mfp_config_run();
 
@@ -47,24 +47,13 @@ static int pxa3xx_mfp_resume(struct sys_
 	 * preserve them here in case they will be referenced later
 	 */
 	ASCR &= ~(ASCR_RDH | ASCR_D1S | ASCR_D2S | ASCR_D3S);
-	return 0;
 }
 #else
 #define pxa3xx_mfp_suspend	NULL
 #define pxa3xx_mfp_resume	NULL
 #endif
 
-struct sysdev_class pxa3xx_mfp_sysclass = {
-	.name		= "mfp",
+struct syscore_ops pxa3xx_mfp_syscore_ops = {
 	.suspend	= pxa3xx_mfp_suspend,
-	.resume 	= pxa3xx_mfp_resume,
+	.resume		= pxa3xx_mfp_resume,
 };
-
-static int __init mfp_init_devicefs(void)
-{
-	if (cpu_is_pxa3xx())
-		return sysdev_class_register(&pxa3xx_mfp_sysclass);
-
-	return 0;
-}
-postcore_initcall(mfp_init_devicefs);
Index: linux-2.6/arch/arm/mach-pxa/pxa3xx.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/pxa3xx.c
+++ linux-2.6/arch/arm/mach-pxa/pxa3xx.c
@@ -20,7 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/irq.h>
 #include <linux/io.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/i2c/pxa-i2c.h>
 
 #include <asm/mach/map.h>
@@ -427,21 +427,9 @@ static struct platform_device *devices[]
 	&pxa27x_device_pwm1,
 };
 
-static struct sys_device pxa3xx_sysdev[] = {
-	{
-		.cls	= &pxa_irq_sysclass,
-	}, {
-		.cls	= &pxa3xx_mfp_sysclass,
-	}, {
-		.cls	= &pxa_gpio_sysclass,
-	}, {
-		.cls	= &pxa3xx_clock_sysclass,
-	}
-};
-
 static int __init pxa3xx_init(void)
 {
-	int i, ret = 0;
+	int ret = 0;
 
 	if (cpu_is_pxa3xx()) {
 
@@ -462,11 +450,10 @@ static int __init pxa3xx_init(void)
 
 		pxa3xx_init_pm();
 
-		for (i = 0; i < ARRAY_SIZE(pxa3xx_sysdev); i++) {
-			ret = sysdev_register(&pxa3xx_sysdev[i]);
-			if (ret)
-				pr_err("failed to register sysdev[%d]\n", i);
-		}
+		register_syscore_ops(&pxa_irq_syscore_ops);
+		register_syscore_ops(&pxa3xx_mfp_syscore_ops);
+		register_syscore_ops(&pxa_gpio_syscore_ops);
+		register_syscore_ops(&pxa3xx_clock_syscore_ops);
 
 		ret = platform_add_devices(devices, ARRAY_SIZE(devices));
 	}
Index: linux-2.6/arch/arm/mach-pxa/mfp-pxa2xx.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/mfp-pxa2xx.c
+++ linux-2.6/arch/arm/mach-pxa/mfp-pxa2xx.c
@@ -16,7 +16,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 
 #include <mach/gpio.h>
 #include <mach/pxa2xx-regs.h>
@@ -338,7 +338,7 @@ static unsigned long saved_gafr[2][4];
 static unsigned long saved_gpdr[4];
 static unsigned long saved_pgsr[4];
 
-static int pxa2xx_mfp_suspend(struct sys_device *d, pm_message_t state)
+static int pxa2xx_mfp_suspend(void)
 {
 	int i;
 
@@ -365,7 +365,7 @@ static int pxa2xx_mfp_suspend(struct sys
 	return 0;
 }
 
-static int pxa2xx_mfp_resume(struct sys_device *d)
+static void pxa2xx_mfp_resume(void)
 {
 	int i;
 
@@ -376,15 +376,13 @@ static int pxa2xx_mfp_resume(struct sys_
 		PGSR(i) = saved_pgsr[i];
 	}
 	PSSR = PSSR_RDH | PSSR_PH;
-	return 0;
 }
 #else
 #define pxa2xx_mfp_suspend	NULL
 #define pxa2xx_mfp_resume	NULL
 #endif
 
-struct sysdev_class pxa2xx_mfp_sysclass = {
-	.name		= "mfp",
+struct syscore_ops pxa2xx_mfp_syscore_ops = {
 	.suspend	= pxa2xx_mfp_suspend,
 	.resume		= pxa2xx_mfp_resume,
 };
@@ -409,6 +407,6 @@ static int __init pxa2xx_mfp_init(void)
 	for (i = 0; i <= gpio_to_bank(pxa_last_gpio); i++)
 		gpdr_lpm[i] = GPDR(i * 32);
 
-	return sysdev_class_register(&pxa2xx_mfp_sysclass);
+	return 0;
 }
 postcore_initcall(pxa2xx_mfp_init);
Index: linux-2.6/arch/arm/mach-pxa/pxa25x.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/pxa25x.c
+++ linux-2.6/arch/arm/mach-pxa/pxa25x.c
@@ -21,7 +21,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/suspend.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/irq.h>
 
 #include <asm/mach/map.h>
@@ -350,21 +350,9 @@ static struct platform_device *pxa25x_de
 	&pxa_device_asoc_platform,
 };
 
-static struct sys_device pxa25x_sysdev[] = {
-	{
-		.cls	= &pxa_irq_sysclass,
-	}, {
-		.cls	= &pxa2xx_mfp_sysclass,
-	}, {
-		.cls	= &pxa_gpio_sysclass,
-	}, {
-		.cls	= &pxa2xx_clock_sysclass,
-	}
-};
-
 static int __init pxa25x_init(void)
 {
-	int i, ret = 0;
+	int ret = 0;
 
 	if (cpu_is_pxa25x()) {
 
@@ -377,11 +365,10 @@ static int __init pxa25x_init(void)
 
 		pxa25x_init_pm();
 
-		for (i = 0; i < ARRAY_SIZE(pxa25x_sysdev); i++) {
-			ret = sysdev_register(&pxa25x_sysdev[i]);
-			if (ret)
-				pr_err("failed to register sysdev[%d]\n", i);
-		}
+		register_syscore_ops(&pxa_irq_syscore_ops);
+		register_syscore_ops(&pxa2xx_mfp_syscore_ops);
+		register_syscore_ops(&pxa_gpio_syscore_ops);
+		register_syscore_ops(&pxa2xx_clock_syscore_ops);
 
 		ret = platform_add_devices(pxa25x_devices,
 					   ARRAY_SIZE(pxa25x_devices));
Index: linux-2.6/arch/arm/mach-pxa/pxa27x.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/pxa27x.c
+++ linux-2.6/arch/arm/mach-pxa/pxa27x.c
@@ -16,7 +16,7 @@
 #include <linux/init.h>
 #include <linux/suspend.h>
 #include <linux/platform_device.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/i2c/pxa-i2c.h>
@@ -428,21 +428,9 @@ static struct platform_device *devices[]
 	&pxa27x_device_pwm1,
 };
 
-static struct sys_device pxa27x_sysdev[] = {
-	{
-		.cls	= &pxa_irq_sysclass,
-	}, {
-		.cls	= &pxa2xx_mfp_sysclass,
-	}, {
-		.cls	= &pxa_gpio_sysclass,
-	}, {
-		.cls	= &pxa2xx_clock_sysclass,
-	}
-};
-
 static int __init pxa27x_init(void)
 {
-	int i, ret = 0;
+	int ret = 0;
 
 	if (cpu_is_pxa27x()) {
 
@@ -455,11 +443,10 @@ static int __init pxa27x_init(void)
 
 		pxa27x_init_pm();
 
-		for (i = 0; i < ARRAY_SIZE(pxa27x_sysdev); i++) {
-			ret = sysdev_register(&pxa27x_sysdev[i]);
-			if (ret)
-				pr_err("failed to register sysdev[%d]\n", i);
-		}
+		register_syscore_ops(&pxa_irq_syscore_ops);
+		register_syscore_ops(&pxa2xx_mfp_syscore_ops);
+		register_syscore_ops(&pxa_gpio_syscore_ops);
+		register_syscore_ops(&pxa2xx_clock_syscore_ops);
 
 		ret = platform_add_devices(devices, ARRAY_SIZE(devices));
 	}
Index: linux-2.6/arch/arm/mach-pxa/mioa701.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/mioa701.c
+++ linux-2.6/arch/arm/mach-pxa/mioa701.c
@@ -22,7 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/input.h>
 #include <linux/delay.h>
 #include <linux/gpio_keys.h>
@@ -488,7 +488,7 @@ static void install_bootstrap(void)
 }
 
 
-static int mioa701_sys_suspend(struct sys_device *sysdev, pm_message_t state)
+static int mioa701_sys_suspend(void)
 {
 	int i = 0, is_bt_on;
 	u32 *mem_resume_vector	= phys_to_virt(RESUME_VECTOR_ADDR);
@@ -514,7 +514,7 @@ static int mioa701_sys_suspend(struct sy
 	return 0;
 }
 
-static int mioa701_sys_resume(struct sys_device *sysdev)
+static void mioa701_sys_resume(void)
 {
 	int i = 0;
 	u32 *mem_resume_vector	= phys_to_virt(RESUME_VECTOR_ADDR);
@@ -527,43 +527,18 @@ static int mioa701_sys_resume(struct sys
 	*mem_resume_enabler = save_buffer[i++];
 	*mem_resume_bt	    = save_buffer[i++];
 	*mem_resume_unknown = save_buffer[i++];
-
-	return 0;
 }
 
-static struct sysdev_class mioa701_sysclass = {
-	.name = "mioa701",
-};
-
-static struct sys_device sysdev_bootstrap = {
-	.cls		= &mioa701_sysclass,
-};
-
-static struct sysdev_driver driver_bootstrap = {
-	.suspend	= &mioa701_sys_suspend,
-	.resume		= &mioa701_sys_resume,
+static struct syscore_ops mioa701_syscore_ops = {
+	.suspend	= mioa701_sys_suspend,
+	.resume		= mioa701_sys_resume,
 };
 
 static int __init bootstrap_init(void)
 {
-	int rc;
 	int save_size = mioa701_bootstrap_lg + (sizeof(u32) * 3);
 
-	rc = sysdev_class_register(&mioa701_sysclass);
-	if (rc) {
-		printk(KERN_ERR "Failed registering mioa701 sys class\n");
-		return -ENODEV;
-	}
-	rc = sysdev_register(&sysdev_bootstrap);
-	if (rc) {
-		printk(KERN_ERR "Failed registering mioa701 sys device\n");
-		return -ENODEV;
-	}
-	rc = sysdev_driver_register(&mioa701_sysclass, &driver_bootstrap);
-	if (rc) {
-		printk(KERN_ERR "Failed registering PMU sys driver\n");
-		return -ENODEV;
-	}
+	register_syscore_ops(&mioa701_syscore_ops);
 
 	save_buffer = kmalloc(save_size, GFP_KERNEL);
 	if (!save_buffer)
@@ -576,9 +551,7 @@ static int __init bootstrap_init(void)
 static void bootstrap_exit(void)
 {
 	kfree(save_buffer);
-	sysdev_driver_unregister(&mioa701_sysclass, &driver_bootstrap);
-	sysdev_unregister(&sysdev_bootstrap);
-	sysdev_class_unregister(&mioa701_sysclass);
+	unregister_syscore_ops(&mioa701_syscore_ops);
 
 	printk(KERN_CRIT "Unregistering mioa701 suspend will hang next"
 	       "resume !!!\n");
Index: linux-2.6/arch/arm/mach-pxa/mainstone.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/mainstone.c
+++ linux-2.6/arch/arm/mach-pxa/mainstone.c
@@ -15,7 +15,7 @@
 
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/bitops.h>
@@ -185,31 +185,21 @@ static void __init mainstone_init_irq(vo
 
 #ifdef CONFIG_PM
 
-static int mainstone_irq_resume(struct sys_device *dev)
+static void mainstone_irq_resume(void)
 {
 	MST_INTMSKENA = mainstone_irq_enabled;
-	return 0;
 }
 
-static struct sysdev_class mainstone_irq_sysclass = {
-	.name = "cpld_irq",
+static struct syscore_ops mainstone_irq_syscore_ops = {
 	.resume = mainstone_irq_resume,
 };
 
-static struct sys_device mainstone_irq_device = {
-	.cls = &mainstone_irq_sysclass,
-};
-
 static int __init mainstone_irq_device_init(void)
 {
-	int ret = -ENODEV;
+	if (machine_is_mainstone())
+		register_syscore_ops(&mainstone_irq_syscore_ops);
 
-	if (machine_is_mainstone()) {
-		ret = sysdev_class_register(&mainstone_irq_sysclass);
-		if (ret == 0)
-			ret = sysdev_register(&mainstone_irq_device);
-	}
-	return ret;
+	return 0;
 }
 
 device_initcall(mainstone_irq_device_init);
Index: linux-2.6/arch/arm/mach-pxa/cm-x2xx.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/cm-x2xx.c
+++ linux-2.6/arch/arm/mach-pxa/cm-x2xx.c
@@ -10,7 +10,7 @@
  */
 
 #include <linux/platform_device.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
 
@@ -388,7 +388,7 @@ static inline void cmx2xx_init_display(v
 #ifdef CONFIG_PM
 static unsigned long sleep_save_msc[10];
 
-static int cmx2xx_suspend(struct sys_device *dev, pm_message_t state)
+static int cmx2xx_suspend(void)
 {
 	cmx2xx_pci_suspend();
 
@@ -412,7 +412,7 @@ static int cmx2xx_suspend(struct sys_dev
 	return 0;
 }
 
-static int cmx2xx_resume(struct sys_device *dev)
+static void cmx2xx_resume(void)
 {
 	cmx2xx_pci_resume();
 
@@ -420,27 +420,18 @@ static int cmx2xx_resume(struct sys_devi
 	__raw_writel(sleep_save_msc[0], MSC0);
 	__raw_writel(sleep_save_msc[1], MSC1);
 	__raw_writel(sleep_save_msc[2], MSC2);
-
-	return 0;
 }
 
-static struct sysdev_class cmx2xx_pm_sysclass = {
-	.name = "pm",
+static struct syscore_ops cmx2xx_pm_syscore_ops = {
 	.resume = cmx2xx_resume,
 	.suspend = cmx2xx_suspend,
 };
 
-static struct sys_device cmx2xx_pm_device = {
-	.cls = &cmx2xx_pm_sysclass,
-};
-
 static int __init cmx2xx_pm_init(void)
 {
-	int error;
-	error = sysdev_class_register(&cmx2xx_pm_sysclass);
-	if (error == 0)
-		error = sysdev_register(&cmx2xx_pm_device);
-	return error;
+	register_syscore_ops(&cmx2xx_pm_syscore_ops);
+
+	return 0;
 }
 #else
 static int __init cmx2xx_pm_init(void) { return 0; }
Index: linux-2.6/arch/arm/mach-pxa/lpd270.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/lpd270.c
+++ linux-2.6/arch/arm/mach-pxa/lpd270.c
@@ -15,7 +15,7 @@
 
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/bitops.h>
@@ -159,30 +159,22 @@ static void __init lpd270_init_irq(void)
 
 
 #ifdef CONFIG_PM
-static int lpd270_irq_resume(struct sys_device *dev)
+static void lpd270_irq_resume(void)
 {
 	__raw_writew(lpd270_irq_enabled, LPD270_INT_MASK);
-	return 0;
 }
 
-static struct sysdev_class lpd270_irq_sysclass = {
-	.name = "cpld_irq",
+static struct syscore_ops lpd270_irq_syscore_ops = {
 	.resume = lpd270_irq_resume,
 };
 
-static struct sys_device lpd270_irq_device = {
-	.cls = &lpd270_irq_sysclass,
-};
-
 static int __init lpd270_irq_device_init(void)
 {
-	int ret = -ENODEV;
 	if (machine_is_logicpd_pxa270()) {
-		ret = sysdev_class_register(&lpd270_irq_sysclass);
-		if (ret == 0)
-			ret = sysdev_register(&lpd270_irq_device);
+		register_syscore_ops(&lpd270_irq_syscore_ops);
+		return 0;
 	}
-	return ret;
+	return -ENODEV;
 }
 
 device_initcall(lpd270_irq_device_init);
Index: linux-2.6/arch/arm/mach-pxa/lubbock.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/lubbock.c
+++ linux-2.6/arch/arm/mach-pxa/lubbock.c
@@ -15,7 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/major.h>
 #include <linux/fb.h>
 #include <linux/interrupt.h>
@@ -176,31 +176,22 @@ static void __init lubbock_init_irq(void
 
 #ifdef CONFIG_PM
 
-static int lubbock_irq_resume(struct sys_device *dev)
+static void lubbock_irq_resume(void)
 {
 	LUB_IRQ_MASK_EN = lubbock_irq_enabled;
-	return 0;
 }
 
-static struct sysdev_class lubbock_irq_sysclass = {
-	.name = "cpld_irq",
+static struct syscore_ops lubbock_irq_syscore_ops = {
 	.resume = lubbock_irq_resume,
 };
 
-static struct sys_device lubbock_irq_device = {
-	.cls = &lubbock_irq_sysclass,
-};
-
 static int __init lubbock_irq_device_init(void)
 {
-	int ret = -ENODEV;
-
 	if (machine_is_lubbock()) {
-		ret = sysdev_class_register(&lubbock_irq_sysclass);
-		if (ret == 0)
-			ret = sysdev_register(&lubbock_irq_device);
+		register_syscore_ops(&lubbock_irq_syscore_ops);
+		return 0;
 	}
-	return ret;
+	return -ENODEV;
 }
 
 device_initcall(lubbock_irq_device_init);
Index: linux-2.6/arch/arm/mach-pxa/viper.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/viper.c
+++ linux-2.6/arch/arm/mach-pxa/viper.c
@@ -44,6 +44,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/physmap.h>
+#include <linux/syscore_ops.h>
 
 #include <mach/pxa25x.h>
 #include <mach/audio.h>
@@ -130,20 +131,19 @@ static u8 viper_hw_version(void)
 	return v1;
 }
 
-/* CPU sysdev */
-static int viper_cpu_suspend(struct sys_device *sysdev, pm_message_t state)
+/* CPU system core operations. */
+static int viper_cpu_suspend(void)
 {
 	viper_icr_set_bit(VIPER_ICR_R_DIS);
 	return 0;
 }
 
-static int viper_cpu_resume(struct sys_device *sysdev)
+static void viper_cpu_resume(void)
 {
 	viper_icr_clear_bit(VIPER_ICR_R_DIS);
-	return 0;
 }
 
-static struct sysdev_driver viper_cpu_sysdev_driver = {
+static struct syscore_ops viper_cpu_syscore_ops = {
 	.suspend	= viper_cpu_suspend,
 	.resume		= viper_cpu_resume,
 };
@@ -945,7 +945,7 @@ static void __init viper_init(void)
 	viper_init_vcore_gpios();
 	viper_init_cpufreq();
 
-	sysdev_driver_register(&cpu_sysdev_class, &viper_cpu_sysdev_driver);
+	register_syscore_ops(&viper_cpu_syscore_ops);
 
 	if (version) {
 		pr_info("viper: hardware v%di%d detected. "
Index: linux-2.6/arch/arm/mach-pxa/palmz72.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/palmz72.c
+++ linux-2.6/arch/arm/mach-pxa/palmz72.c
@@ -19,7 +19,7 @@
  */
 
 #include <linux/platform_device.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
 #include <linux/gpio_keys.h>
@@ -233,9 +233,9 @@ static struct palmz72_resume_info palmz7
 
 static unsigned long store_ptr;
 
-/* sys_device for Palm Zire 72 PM */
+/* syscore_ops for Palm Zire 72 PM */
 
-static int palmz72_pm_suspend(struct sys_device *dev, pm_message_t msg)
+static int palmz72_pm_suspend(void)
 {
 	/* setup the resume_info struct for the original bootloader */
 	palmz72_resume_info.resume_addr = (u32) cpu_resume;
@@ -249,31 +249,23 @@ static int palmz72_pm_suspend(struct sys
 	return 0;
 }
 
-static int palmz72_pm_resume(struct sys_device *dev)
+static void palmz72_pm_resume(void)
 {
 	*PALMZ72_SAVE_DWORD = store_ptr;
-	return 0;
 }
 
-static struct sysdev_class palmz72_pm_sysclass = {
-	.name = "palmz72_pm",
+static struct syscore_ops palmz72_pm_syscore_ops = {
 	.suspend = palmz72_pm_suspend,
 	.resume = palmz72_pm_resume,
 };
 
-static struct sys_device palmz72_pm_device = {
-	.cls = &palmz72_pm_sysclass,
-};
-
 static int __init palmz72_pm_init(void)
 {
-	int ret = -ENODEV;
 	if (machine_is_palmz72()) {
-		ret = sysdev_class_register(&palmz72_pm_sysclass);
-		if (ret == 0)
-			ret = sysdev_register(&palmz72_pm_device);
+		register_syscore_ops(&palmz72_pm_syscore_ops);
+		return 0;
 	}
-	return ret;
+	return -ENODEV;
 }
 
 device_initcall(palmz72_pm_init);
Index: linux-2.6/arch/arm/mach-pxa/smemc.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/smemc.c
+++ linux-2.6/arch/arm/mach-pxa/smemc.c
@@ -6,7 +6,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/io.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 
 #include <mach/hardware.h>
 #include <mach/smemc.h>
@@ -16,7 +16,7 @@ static unsigned long msc[2];
 static unsigned long sxcnfg, memclkcfg;
 static unsigned long csadrcfg[4];
 
-static int pxa3xx_smemc_suspend(struct sys_device *dev, pm_message_t state)
+static int pxa3xx_smemc_suspend(void)
 {
 	msc[0] = __raw_readl(MSC0);
 	msc[1] = __raw_readl(MSC1);
@@ -30,7 +30,7 @@ static int pxa3xx_smemc_suspend(struct s
 	return 0;
 }
 
-static int pxa3xx_smemc_resume(struct sys_device *dev)
+static void pxa3xx_smemc_resume(void)
 {
 	__raw_writel(msc[0], MSC0);
 	__raw_writel(msc[1], MSC1);
@@ -40,34 +40,19 @@ static int pxa3xx_smemc_resume(struct sy
 	__raw_writel(csadrcfg[1], CSADRCFG1);
 	__raw_writel(csadrcfg[2], CSADRCFG2);
 	__raw_writel(csadrcfg[3], CSADRCFG3);
-
-	return 0;
 }
 
-static struct sysdev_class smemc_sysclass = {
-	.name		= "smemc",
+static struct syscore_ops smemc_syscore_ops = {
 	.suspend	= pxa3xx_smemc_suspend,
 	.resume		= pxa3xx_smemc_resume,
 };
 
-static struct sys_device smemc_sysdev = {
-	.id		= 0,
-	.cls		= &smemc_sysclass,
-};
-
 static int __init smemc_init(void)
 {
-	int ret = 0;
+	if (cpu_is_pxa3xx())
+		register_syscore_ops(&smemc_syscore_ops);
 
-	if (cpu_is_pxa3xx()) {
-		ret = sysdev_class_register(&smemc_sysclass);
-		if (ret)
-			return ret;
-
-		ret = sysdev_register(&smemc_sysdev);
-	}
-
-	return ret;
+	return 0;
 }
 subsys_initcall(smemc_init);
 #endif
Index: linux-2.6/arch/arm/mach-pxa/palmtreo.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/palmtreo.c
+++ linux-2.6/arch/arm/mach-pxa/palmtreo.c
@@ -25,7 +25,6 @@
 #include <linux/pwm_backlight.h>
 #include <linux/gpio.h>
 #include <linux/power_supply.h>
-#include <linux/sysdev.h>
 #include <linux/w1-gpio.h>
 
 #include <asm/mach-types.h>
Index: linux-2.6/arch/arm/mach-pxa/palmld.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/palmld.c
+++ linux-2.6/arch/arm/mach-pxa/palmld.c
@@ -24,7 +24,6 @@
 #include <linux/gpio.h>
 #include <linux/wm97xx.h>
 #include <linux/power_supply.h>
-#include <linux/sysdev.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/physmap.h>
Index: linux-2.6/arch/arm/mach-pxa/colibri-pxa270.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/colibri-pxa270.c
+++ linux-2.6/arch/arm/mach-pxa/colibri-pxa270.c
@@ -17,7 +17,6 @@
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/physmap.h>
 #include <linux/platform_device.h>
-#include <linux/sysdev.h>
 #include <linux/ucb1400.h>
 
 #include <asm/mach/arch.h>
Index: linux-2.6/arch/arm/mach-pxa/raumfeld.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/raumfeld.c
+++ linux-2.6/arch/arm/mach-pxa/raumfeld.c
@@ -18,7 +18,6 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sysdev.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
Index: linux-2.6/arch/arm/mach-pxa/cm-x270.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/cm-x270.c
+++ linux-2.6/arch/arm/mach-pxa/cm-x270.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/platform_device.h>
-#include <linux/sysdev.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
Index: linux-2.6/arch/arm/mach-pxa/trizeps4.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/trizeps4.c
+++ linux-2.6/arch/arm/mach-pxa/trizeps4.c
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
-#include <linux/sysdev.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/bitops.h>
Index: linux-2.6/arch/arm/mach-pxa/colibri-evalboard.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/colibri-evalboard.c
+++ linux-2.6/arch/arm/mach-pxa/colibri-evalboard.c
@@ -13,7 +13,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
-#include <linux/sysdev.h>
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
 #include <asm/mach-types.h>
Index: linux-2.6/arch/arm/mach-pxa/vpac270.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/vpac270.c
+++ linux-2.6/arch/arm/mach-pxa/vpac270.c
@@ -16,7 +16,6 @@
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/gpio.h>
-#include <linux/sysdev.h>
 #include <linux/usb/gpio_vbus.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
Index: linux-2.6/arch/arm/mach-pxa/colibri-pxa270-income.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/colibri-pxa270-income.c
+++ linux-2.6/arch/arm/mach-pxa/colibri-pxa270-income.c
@@ -22,7 +22,6 @@
 #include <linux/platform_device.h>
 #include <linux/pwm_backlight.h>
 #include <linux/i2c/pxa-i2c.h>
-#include <linux/sysdev.h>
 
 #include <asm/irq.h>
 #include <asm/mach-types.h>
Index: linux-2.6/arch/arm/mach-pxa/balloon3.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/balloon3.c
+++ linux-2.6/arch/arm/mach-pxa/balloon3.c
@@ -15,7 +15,6 @@
 
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/sysdev.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/bitops.h>
Index: linux-2.6/arch/arm/plat-pxa/mfp.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-pxa/mfp.c
+++ linux-2.6/arch/arm/plat-pxa/mfp.c
@@ -17,7 +17,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/io.h>
-#include <linux/sysdev.h>
 
 #include <plat/mfp.h>
 

