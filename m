Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab0EKOMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:12:49 -0400
Received: from smtp.nokia.com ([192.100.122.233]:50760 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104Ab0EKOMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:12:41 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
       Linux-OMAP <linux-omap@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       ext Tony Lindgren <tony@atomide.com>,
       ext Kevin Hilman <khilman@deeprootsystems.com>,
       Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
       santosh.shilimkar@ti.com, Ambresh <a0393775@ti.com>,
       felipe.balbi@nokia.com, Jouni Hogander <jouni.hogander@nokia.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv5 2/3] OMAP: export OMAP info under /proc/socinfo
Date: Tue, 11 May 2010 17:15:30 +0300
Message-Id: <1273587331-24604-3-git-send-email-eduardo.valentin@nokia.com>
X-Mailer: git-send-email 1.7.0.4.361.g8b5fe.dirty
In-Reply-To: <1273587331-24604-1-git-send-email-eduardo.valentin@nokia.com>
References: <1273587331-24604-1-git-send-email-eduardo.valentin@nokia.com>
X-OriginalArrivalTime: 11 May 2010 14:12:08.0954 (UTC) FILETIME=[F15CBDA0:01CAF113]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Valentin <eduardo.valentin@nokia.com>

Export OMAP name and rev under /proc/socinfo node.

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 arch/arm/Kconfig         |    1 +
 arch/arm/mach-omap1/id.c |   31 ++++++++++++++++++++++++-------
 arch/arm/mach-omap2/id.c |   32 ++++++++++++++++++++++++++------
 3 files changed, 51 insertions(+), 13 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 92622eb..fbd3c50 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -326,6 +326,7 @@ config ARCH_EP93XX
 	select COMMON_CLKDEV
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_HAS_HOLES_MEMORYMODEL
+	select PROC_SOC_INFO
 	help
 	  This enables support for the Cirrus EP93xx series of CPUs.
 
diff --git a/arch/arm/mach-omap1/id.c b/arch/arm/mach-omap1/id.c
index a0e3560..ef3caf1 100644
--- a/arch/arm/mach-omap1/id.c
+++ b/arch/arm/mach-omap1/id.c
@@ -15,6 +15,8 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/socinfo.h>
+#include <linux/seq_file.h>
 #include <plat/cpu.h>
 
 #define OMAP_DIE_ID_0		0xfffe1800
@@ -118,9 +120,21 @@ static u8 __init omap_get_die_rev(void)
 	return die_rev;
 }
 
+#define SOCINFO_SZ		128
+
+static int omap1_socinfo_show(struct seq_file *m, void *v)
+{
+	char *socinfo = v;
+
+	seq_printf(m, "SoC\t: %s\n", socinfo);
+
+	return 0;
+}
+
 void __init omap_check_revision(void)
 {
-	int i;
+	int i, sz;
+	char socinfo[SOCINFO_SZ];
 	u16 jtag_id;
 	u8 die_rev;
 	u32 omap_id;
@@ -194,11 +208,14 @@ void __init omap_check_revision(void)
 		printk(KERN_INFO "Unknown OMAP cpu type: 0x%02x\n", cpu_type);
 	}
 
-	printk(KERN_INFO "OMAP%04x", omap_revision >> 16);
+	sz = snprintf(socinfo, SOCINFO_SZ, "OMAP%04x", omap_revision >> 16);
 	if ((omap_revision >> 8) & 0xff)
-		printk(KERN_INFO "%x", (omap_revision >> 8) & 0xff);
-	printk(KERN_INFO " revision %i handled as %02xxx id: %08x%08x\n",
-	       die_rev, omap_revision & 0xff, system_serial_low,
-	       system_serial_high);
+		snprintf(socinfo + sz, SOCINFO_SZ - sz, "%x",
+						(omap_revision >> 8) & 0xff);
+	pr_info("%s revision %i handled as %02xxx id: %08x%08x\n",
+		socinfo, die_rev, omap_revision & 0xff, system_serial_low,
+		system_serial_high);
+
+	/* register function to show SoC info under /proc/socinfo */
+	register_socinfo_show(omap1_socinfo_show, kstrdup(socinfo, GFP_KERNEL));
 }
-
diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 37b8a1a..b67486b 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -18,6 +18,8 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/socinfo.h>
+#include <linux/seq_file.h>
 
 #include <asm/cputype.h>
 
@@ -101,10 +103,12 @@ static struct omap_id omap_ids[] __initdata = {
 
 static void __iomem *tap_base;
 static u16 tap_prod_id;
+#define SOCINFO_SZ		128
+static char socinfo[SOCINFO_SZ];
 
 void __init omap24xx_check_revision(void)
 {
-	int i, j;
+	int i, j, sz;
 	u32 idcode, prod_id;
 	u16 hawkeye;
 	u8  dev_type, rev;
@@ -152,10 +156,11 @@ void __init omap24xx_check_revision(void)
 		j = i;
 	}
 
-	pr_info("OMAP%04x", omap_rev() >> 16);
+	sz = snprintf(socinfo, SOCINFO_SZ, "OMAP%04x", omap_rev() >> 16);
 	if ((omap_rev() >> 8) & 0x0f)
-		pr_info("ES%x", (omap_rev() >> 12) & 0xf);
-	pr_info("\n");
+		snprintf(socinfo + sz, SOCINFO_SZ - sz, "ES%x",
+						(omap_rev() >> 12) & 0xf);
+	pr_info("%s\n", socinfo);
 }
 
 #define OMAP3_CHECK_FEATURE(status,feat)				\
@@ -286,7 +291,9 @@ void __init omap4_check_revision(void)
 	if ((hawkeye == 0xb852) && (rev == 0x0)) {
 		omap_revision = OMAP4430_REV_ES1_0;
 		omap_chip.oc |= CHIP_IS_OMAP4430ES1;
-		pr_info("OMAP%04x %s\n", omap_rev() >> 16, rev_name);
+		snprintf(socinfo, SOCINFO_SZ, "OMAP%04x %s\n",
+				omap_rev() >> 16, rev_name);
+		pr_info("%s\n", socinfo);
 		return;
 	}
 
@@ -356,7 +363,8 @@ void __init omap3_cpuinfo(void)
 	}
 
 	/* Print verbose information */
-	pr_info("%s ES%s (", cpu_name, cpu_rev);
+	snprintf(socinfo, SOCINFO_SZ, "%s ES%s", cpu_name, cpu_rev);
+	pr_info("%s (", socinfo);
 
 	OMAP3_SHOW_FEATURE(l2cache);
 	OMAP3_SHOW_FEATURE(iva);
@@ -368,6 +376,15 @@ void __init omap3_cpuinfo(void)
 	printk(")\n");
 }
 
+static int omap_socinfo_show(struct seq_file *m, void *v)
+{
+	char *socinfop = v;
+
+	seq_printf(m, "SoC\t: %s\n", socinfop);
+
+	return 0;
+}
+
 /*
  * Try to detect the exact revision of the omap we're running on
  */
@@ -391,6 +408,9 @@ void __init omap2_check_revision(void)
 		pr_err("OMAP revision unknown, please fix!\n");
 	}
 
+	/* also register call back to report SoC data under /proc/socinfo */
+	register_socinfo_show(omap_socinfo_show, socinfo);
+
 	/*
 	 * OK, now we know the exact revision. Initialize omap_chip bits
 	 * for powerdowmain and clockdomain code.
-- 
1.7.0.4.361.g8b5fe.dirty

