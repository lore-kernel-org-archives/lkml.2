Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1JSWNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:13:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51297 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066Ab1JSWND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:13:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [PATCH 3/3] ARM: mach-shmobile: sh7372 A4R support (v4)
Date: Thu, 20 Oct 2011 00:15:06 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
References: <201110200012.43840.rjw@sisk.pl>
In-Reply-To: <201110200012.43840.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110200015.06277.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This change adds support for the sh7372 A4R power domain.

The sh7372 A4R hardware power domain contains the
SH CPU Core and a set of I/O devices including
multimedia accelerators and I2C controllers.

One special case about A4R is the INTCS interrupt
controller that needs to be saved and restored to
keep working as expected. Also the LCDC hardware
blocks are in a different hardware power domain
but have their IRQs routed only through INTCS. So
as long as LCDCs are active we cannot power down
INTCS because that would risk losing interrupts.

Signed-off-by: Magnus Damm <damm@opensource.se>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/board-ap4evb.c        |    1 
 arch/arm/mach-shmobile/board-mackerel.c      |    1 
 arch/arm/mach-shmobile/include/mach/sh7372.h |    7 +++
 arch/arm/mach-shmobile/intc-sh7372.c         |   52 ++++++++++++++++++++++++++-
 arch/arm/mach-shmobile/pm-sh7372.c           |   29 ++++++++++++++-
 arch/arm/mach-shmobile/setup-sh7372.c        |    8 ++++
 6 files changed, 96 insertions(+), 2 deletions(-)

Index: linux/arch/arm/mach-shmobile/board-ap4evb.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/board-ap4evb.c
+++ linux/arch/arm/mach-shmobile/board-ap4evb.c
@@ -1412,6 +1412,7 @@ static void __init ap4evb_init(void)
 	sh7372_add_device_to_domain(&sh7372_a3sp, &sh_mmcif_device);
 	sh7372_add_device_to_domain(&sh7372_a3sp, &sdhi0_device);
 	sh7372_add_device_to_domain(&sh7372_a3sp, &sdhi1_device);
+	sh7372_add_device_to_domain(&sh7372_a4r, &ceu_device);
 
 	hdmi_init_pm_clock();
 	fsi_init_pm_clock();
Index: linux/arch/arm/mach-shmobile/board-mackerel.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/board-mackerel.c
+++ linux/arch/arm/mach-shmobile/board-mackerel.c
@@ -1596,6 +1596,7 @@ static void __init mackerel_init(void)
 	sh7372_add_device_to_domain(&sh7372_a3sp, &sdhi1_device);
 #endif
 	sh7372_add_device_to_domain(&sh7372_a3sp, &sdhi2_device);
+	sh7372_add_device_to_domain(&sh7372_a4r, &ceu_device);
 
 	hdmi_init_pm_clock();
 	sh7372_pm_init();
Index: linux/arch/arm/mach-shmobile/include/mach/sh7372.h
===================================================================
--- linux.orig/arch/arm/mach-shmobile/include/mach/sh7372.h
+++ linux/arch/arm/mach-shmobile/include/mach/sh7372.h
@@ -480,8 +480,11 @@ struct platform_device;
 struct sh7372_pm_domain {
 	struct generic_pm_domain genpd;
 	struct dev_power_governor *gov;
+	void (*suspend)(void);
+	void (*resume)(void);
 	unsigned int bit_shift;
 	bool no_debug;
+	bool stay_on;
 };
 
 static inline struct sh7372_pm_domain *to_sh7372_pd(struct generic_pm_domain *d)
@@ -493,6 +496,7 @@ static inline struct sh7372_pm_domain *t
 extern struct sh7372_pm_domain sh7372_a4lc;
 extern struct sh7372_pm_domain sh7372_a4mp;
 extern struct sh7372_pm_domain sh7372_d4;
+extern struct sh7372_pm_domain sh7372_a4r;
 extern struct sh7372_pm_domain sh7372_a3rv;
 extern struct sh7372_pm_domain sh7372_a3ri;
 extern struct sh7372_pm_domain sh7372_a3sp;
@@ -509,4 +513,7 @@ extern void sh7372_pm_add_subdomain(stru
 #define sh7372_pm_add_subdomain(pd, sd) do { } while(0)
 #endif /* CONFIG_PM */
 
+extern void sh7372_intcs_suspend(void);
+extern void sh7372_intcs_resume(void);
+
 #endif /* __ASM_SH7372_H__ */
Index: linux/arch/arm/mach-shmobile/intc-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/intc-sh7372.c
+++ linux/arch/arm/mach-shmobile/intc-sh7372.c
@@ -606,9 +606,16 @@ static void intcs_demux(unsigned int irq
 	generic_handle_irq(intcs_evt2irq(evtcodeas));
 }
 
+static void __iomem *intcs_ffd2;
+static void __iomem *intcs_ffd5;
+
 void __init sh7372_init_irq(void)
 {
-	void __iomem *intevtsa = ioremap_nocache(0xffd20100, PAGE_SIZE);
+	void __iomem *intevtsa;
+
+	intcs_ffd2 = ioremap_nocache(0xffd20000, PAGE_SIZE);
+	intevtsa = intcs_ffd2 + 0x100;
+	intcs_ffd5 = ioremap_nocache(0xffd50000, PAGE_SIZE);
 
 	register_intc_controller(&intca_desc);
 	register_intc_controller(&intcs_desc);
@@ -617,3 +624,46 @@ void __init sh7372_init_irq(void)
 	irq_set_handler_data(evt2irq(0xf80), (void *)intevtsa);
 	irq_set_chained_handler(evt2irq(0xf80), intcs_demux);
 }
+
+static unsigned short ffd2[0x200];
+static unsigned short ffd5[0x100];
+
+void sh7372_intcs_suspend(void)
+{
+	int k;
+
+	for (k = 0x00; k <= 0x30; k += 4)
+		ffd2[k] = __raw_readw(intcs_ffd2 + k);
+
+	for (k = 0x80; k <= 0xb0; k += 4)
+		ffd2[k] = __raw_readb(intcs_ffd2 + k);
+
+	for (k = 0x180; k <= 0x188; k += 4)
+		ffd2[k] = __raw_readb(intcs_ffd2 + k);
+
+	for (k = 0x00; k <= 0x3c; k += 4)
+		ffd5[k] = __raw_readw(intcs_ffd5 + k);
+
+	for (k = 0x80; k <= 0x9c; k += 4)
+		ffd5[k] = __raw_readb(intcs_ffd5 + k);
+}
+
+void sh7372_intcs_resume(void)
+{
+	int k;
+
+	for (k = 0x00; k <= 0x30; k += 4)
+		__raw_writew(ffd2[k], intcs_ffd2 + k);
+
+	for (k = 0x80; k <= 0xb0; k += 4)
+		__raw_writeb(ffd2[k], intcs_ffd2 + k);
+
+	for (k = 0x180; k <= 0x188; k += 4)
+		__raw_writeb(ffd2[k], intcs_ffd2 + k);
+
+	for (k = 0x00; k <= 0x3c; k += 4)
+		__raw_writew(ffd5[k], intcs_ffd5 + k);
+
+	for (k = 0x80; k <= 0x9c; k += 4)
+		__raw_writeb(ffd5[k], intcs_ffd5 + k);
+}
Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux/arch/arm/mach-shmobile/pm-sh7372.c
@@ -44,6 +44,7 @@
 #define SPDCR 0xe6180008
 #define SWUCR 0xe6180014
 #define SBAR 0xe6180020
+#define WUPRMSK 0xe6180028
 #define WUPSMSK 0xe618002c
 #define WUPSMSK2 0xe6180048
 #define PSTR 0xe6180080
@@ -80,6 +81,12 @@ static int pd_power_down(struct generic_
 	struct sh7372_pm_domain *sh7372_pd = to_sh7372_pd(genpd);
 	unsigned int mask = 1 << sh7372_pd->bit_shift;
 
+	if (sh7372_pd->suspend)
+		sh7372_pd->suspend();
+
+	if (sh7372_pd->stay_on)
+		return 0;
+
 	if (__raw_readl(PSTR) & mask) {
 		unsigned int retry_count;
 
@@ -106,6 +113,9 @@ static int pd_power_up(struct generic_pm
 	unsigned int retry_count;
 	int ret = 0;
 
+	if (sh7372_pd->stay_on)
+		goto out;
+
 	if (__raw_readl(PSTR) & mask)
 		goto out;
 
@@ -122,14 +132,23 @@ static int pd_power_up(struct generic_pm
 	if (__raw_readl(SWUCR) & mask)
 		ret = -EIO;
 
- out:
 	if (!sh7372_pd->no_debug)
 		pr_debug("sh7372 power domain up 0x%08x -> PSTR = 0x%08x\n",
 			 mask, __raw_readl(PSTR));
 
+ out:
+	if (ret == 0 && sh7372_pd->resume)
+		sh7372_pd->resume();
+
 	return ret;
 }
 
+static void sh7372_a4r_suspend(void)
+{
+	sh7372_intcs_suspend();
+	__raw_writel(0x300fffff, WUPRMSK); /* avoid wakeup */
+}
+
 static bool pd_active_wakeup(struct device *dev)
 {
 	return true;
@@ -186,6 +205,14 @@ struct sh7372_pm_domain sh7372_d4 = {
 	.bit_shift = 3,
 };
 
+struct sh7372_pm_domain sh7372_a4r = {
+	.bit_shift = 5,
+	.gov = &sh7372_always_on_gov,
+	.suspend = sh7372_a4r_suspend,
+	.resume = sh7372_intcs_resume,
+	.stay_on = true,
+};
+
 struct sh7372_pm_domain sh7372_a3rv = {
 	.bit_shift = 6,
 };
Index: linux/arch/arm/mach-shmobile/setup-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/setup-sh7372.c
+++ linux/arch/arm/mach-shmobile/setup-sh7372.c
@@ -991,12 +991,14 @@ void __init sh7372_add_standard_devices(
 	sh7372_init_pm_domain(&sh7372_a4lc);
 	sh7372_init_pm_domain(&sh7372_a4mp);
 	sh7372_init_pm_domain(&sh7372_d4);
+	sh7372_init_pm_domain(&sh7372_a4r);
 	sh7372_init_pm_domain(&sh7372_a3rv);
 	sh7372_init_pm_domain(&sh7372_a3ri);
 	sh7372_init_pm_domain(&sh7372_a3sg);
 	sh7372_init_pm_domain(&sh7372_a3sp);
 
 	sh7372_pm_add_subdomain(&sh7372_a4lc, &sh7372_a3rv);
+	sh7372_pm_add_subdomain(&sh7372_a4r, &sh7372_a4lc);
 
 	platform_add_devices(sh7372_early_devices,
 			    ARRAY_SIZE(sh7372_early_devices));
@@ -1020,6 +1022,12 @@ void __init sh7372_add_standard_devices(
 	sh7372_add_device_to_domain(&sh7372_a3sp, &dma2_device);
 	sh7372_add_device_to_domain(&sh7372_a3sp, &usb_dma0_device);
 	sh7372_add_device_to_domain(&sh7372_a3sp, &usb_dma1_device);
+	sh7372_add_device_to_domain(&sh7372_a4r, &iic0_device);
+	sh7372_add_device_to_domain(&sh7372_a4r, &veu0_device);
+	sh7372_add_device_to_domain(&sh7372_a4r, &veu1_device);
+	sh7372_add_device_to_domain(&sh7372_a4r, &veu2_device);
+	sh7372_add_device_to_domain(&sh7372_a4r, &veu3_device);
+	sh7372_add_device_to_domain(&sh7372_a4r, &jpu_device);
 }
 
 void __init sh7372_add_early_devices(void)

