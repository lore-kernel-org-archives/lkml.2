Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab1JSWNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:13:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51301 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676Ab1JSWNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:13:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [PATCH 2/3] ARM: mach-shmobile: sh7372 A3SP support (v4)
Date: Thu, 20 Oct 2011 00:14:33 +0200
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
Message-Id: <201110200014.33248.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This change adds support for the sh7372 A3SP power domain.

The sh7372 A3SP hardware power domain contains a
wide range of I/O devices. The list of I/O devices
include SCIF serial ports, DMA Engine hardware,
SD and MMC controller hardware, USB controllers
and I2C master controllers.

This patch adds the A3SP low level code which 
powers the hardware power domain on and off. It
also ties in platform devices to the pm domain
support code.

It is worth noting that the serial console is
hooked up to SCIFA0 on most sh7372 boards, and
the SCIFA0 port is included in the A3SP hardware
power domain. For this reason we cannot output
debug messages from the low level power control
code in the case of A3SP.

QoS support is needed in drivers before we can
enable the A3SP power control on the fly.

Signed-off-by: Magnus Damm <damm@opensource.se>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/board-ap4evb.c        |    4 +++
 arch/arm/mach-shmobile/board-mackerel.c      |    8 +++++++
 arch/arm/mach-shmobile/include/mach/sh7372.h |    3 ++
 arch/arm/mach-shmobile/pm-sh7372.c           |   30 ++++++++++++++++++++++-----
 arch/arm/mach-shmobile/setup-sh7372.c        |   14 ++++++++++++
 5 files changed, 54 insertions(+), 5 deletions(-)

Index: linux/arch/arm/mach-shmobile/board-ap4evb.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/board-ap4evb.c
+++ linux/arch/arm/mach-shmobile/board-ap4evb.c
@@ -1409,6 +1409,10 @@ static void __init ap4evb_init(void)
 	sh7372_add_device_to_domain(&sh7372_a4lc, &lcdc_device);
 	sh7372_add_device_to_domain(&sh7372_a4mp, &fsi_device);
 
+	sh7372_add_device_to_domain(&sh7372_a3sp, &sh_mmcif_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &sdhi0_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &sdhi1_device);
+
 	hdmi_init_pm_clock();
 	fsi_init_pm_clock();
 	sh7372_pm_init();
Index: linux/arch/arm/mach-shmobile/board-mackerel.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/board-mackerel.c
+++ linux/arch/arm/mach-shmobile/board-mackerel.c
@@ -1588,6 +1588,14 @@ static void __init mackerel_init(void)
 	sh7372_add_device_to_domain(&sh7372_a4lc, &lcdc_device);
 	sh7372_add_device_to_domain(&sh7372_a4lc, &hdmi_lcdc_device);
 	sh7372_add_device_to_domain(&sh7372_a4mp, &fsi_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &usbhs0_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &usbhs1_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &sh_mmcif_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &sdhi0_device);
+#if !defined(CONFIG_MMC_SH_MMCIF) && !defined(CONFIG_MMC_SH_MMCIF_MODULE)
+	sh7372_add_device_to_domain(&sh7372_a3sp, &sdhi1_device);
+#endif
+	sh7372_add_device_to_domain(&sh7372_a3sp, &sdhi2_device);
 
 	hdmi_init_pm_clock();
 	sh7372_pm_init();
Index: linux/arch/arm/mach-shmobile/include/mach/sh7372.h
===================================================================
--- linux.orig/arch/arm/mach-shmobile/include/mach/sh7372.h
+++ linux/arch/arm/mach-shmobile/include/mach/sh7372.h
@@ -479,7 +479,9 @@ struct platform_device;
 
 struct sh7372_pm_domain {
 	struct generic_pm_domain genpd;
+	struct dev_power_governor *gov;
 	unsigned int bit_shift;
+	bool no_debug;
 };
 
 static inline struct sh7372_pm_domain *to_sh7372_pd(struct generic_pm_domain *d)
@@ -493,6 +495,7 @@ extern struct sh7372_pm_domain sh7372_a4
 extern struct sh7372_pm_domain sh7372_d4;
 extern struct sh7372_pm_domain sh7372_a3rv;
 extern struct sh7372_pm_domain sh7372_a3ri;
+extern struct sh7372_pm_domain sh7372_a3sp;
 extern struct sh7372_pm_domain sh7372_a3sg;
 
 extern void sh7372_init_pm_domain(struct sh7372_pm_domain *sh7372_pd);
Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux/arch/arm/mach-shmobile/pm-sh7372.c
@@ -92,8 +92,9 @@ static int pd_power_down(struct generic_
 		}
 	}
 
-	pr_debug("sh7372 power domain down 0x%08x -> PSTR = 0x%08x\n",
-		 mask, __raw_readl(PSTR));
+	if (!sh7372_pd->no_debug)
+		pr_debug("sh7372 power domain down 0x%08x -> PSTR = 0x%08x\n",
+			 mask, __raw_readl(PSTR));
 
 	return 0;
 }
@@ -122,8 +123,9 @@ static int pd_power_up(struct generic_pm
 		ret = -EIO;
 
  out:
-	pr_debug("sh7372 power domain up 0x%08x -> PSTR = 0x%08x\n",
-		 mask, __raw_readl(PSTR));
+	if (!sh7372_pd->no_debug)
+		pr_debug("sh7372 power domain up 0x%08x -> PSTR = 0x%08x\n",
+			 mask, __raw_readl(PSTR));
 
 	return ret;
 }
@@ -133,11 +135,20 @@ static bool pd_active_wakeup(struct devi
 	return true;
 }
 
+static bool sh7372_power_down_forbidden(struct dev_pm_domain *domain)
+{
+	return false;
+}
+
+struct dev_power_governor sh7372_always_on_gov = {
+	.power_down_ok = sh7372_power_down_forbidden,
+};
+
 void sh7372_init_pm_domain(struct sh7372_pm_domain *sh7372_pd)
 {
 	struct generic_pm_domain *genpd = &sh7372_pd->genpd;
 
-	pm_genpd_init(genpd, NULL, false);
+	pm_genpd_init(genpd, sh7372_pd->gov, false);
 	genpd->stop_device = pm_clk_suspend;
 	genpd->start_device = pm_clk_resume;
 	genpd->dev_irq_safe = true;
@@ -183,6 +194,12 @@ struct sh7372_pm_domain sh7372_a3ri = {
 	.bit_shift = 8,
 };
 
+struct sh7372_pm_domain sh7372_a3sp = {
+	.bit_shift = 11,
+	.gov = &sh7372_always_on_gov,
+	.no_debug = true,
+};
+
 struct sh7372_pm_domain sh7372_a3sg = {
 	.bit_shift = 13,
 };
@@ -422,6 +439,9 @@ void __init sh7372_pm_init(void)
 	__raw_writel(0x0000a501, DBGREG9);
 	__raw_writel(0x00000000, DBGREG1);
 
+	/* do not convert A3SM, A3SP, A3SG, A4R power down into A4S */
+	__raw_writel(0, PDNSEL);
+
 	sh7372_suspend_init();
 	sh7372_cpuidle_init();
 }
Index: linux/arch/arm/mach-shmobile/setup-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/setup-sh7372.c
+++ linux/arch/arm/mach-shmobile/setup-sh7372.c
@@ -994,6 +994,7 @@ void __init sh7372_add_standard_devices(
 	sh7372_init_pm_domain(&sh7372_a3rv);
 	sh7372_init_pm_domain(&sh7372_a3ri);
 	sh7372_init_pm_domain(&sh7372_a3sg);
+	sh7372_init_pm_domain(&sh7372_a3sp);
 
 	sh7372_pm_add_subdomain(&sh7372_a4lc, &sh7372_a3rv);
 
@@ -1006,6 +1007,19 @@ void __init sh7372_add_standard_devices(
 	sh7372_add_device_to_domain(&sh7372_a3rv, &vpu_device);
 	sh7372_add_device_to_domain(&sh7372_a4mp, &spu0_device);
 	sh7372_add_device_to_domain(&sh7372_a4mp, &spu1_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &scif0_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &scif1_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &scif2_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &scif3_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &scif4_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &scif5_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &scif6_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &iic1_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &dma0_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &dma1_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &dma2_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &usb_dma0_device);
+	sh7372_add_device_to_domain(&sh7372_a3sp, &usb_dma1_device);
 }
 
 void __init sh7372_add_early_devices(void)

