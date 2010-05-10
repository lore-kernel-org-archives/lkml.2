Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab0EJKhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 06:37:00 -0400
Received: from smtp.nokia.com ([192.100.105.134]:57442 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab0EJKg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 06:36:56 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
       Linux-OMAP <linux-omap@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       ext Tony Lindgren <tony@atomide.com>,
       ext Kevin Hilman <khilman@deeprootsystems.com>,
       Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
       santosh.shilimkar@ti.com, Ambresh <a0393775@ti.com>,
       felipe.balbi@nokia.com, Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv4 2/4] mach-omap2: export omap2 info under /proc/socinfo
Date: Mon, 10 May 2010 13:37:35 +0300
Message-Id: <1273487857-32281-3-git-send-email-eduardo.valentin@nokia.com>
X-Mailer: git-send-email 1.7.0.4.361.g8b5fe.dirty
In-Reply-To: <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com>
References: <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com>
X-OriginalArrivalTime: 10 May 2010 10:35:39.0759 (UTC) FILETIME=[88C91FF0:01CAF02C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Valentin <eduardo.valentin@nokia.com>

Report OMAP name and rev under /proc/socinfo node.

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 arch/arm/Kconfig         |    1 +
 arch/arm/mach-omap2/id.c |   48 ++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c5408bf..7456967 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -798,6 +798,7 @@ config ARCH_OMAP
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_HAS_HOLES_MEMORYMODEL
+	select PROC_SOC_INFO
 	help
 	  Support for TI's OMAP platform (OMAP1 and OMAP2).
 
diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 37b8a1a..8ecd8e2 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/seq_file.h>
 
 #include <asm/cputype.h>
 
@@ -101,10 +102,12 @@ static struct omap_id omap_ids[] __initdata = {
 
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
@@ -152,10 +155,11 @@ void __init omap24xx_check_revision(void)
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
@@ -286,7 +290,9 @@ void __init omap4_check_revision(void)
 	if ((hawkeye == 0xb852) && (rev == 0x0)) {
 		omap_revision = OMAP4430_REV_ES1_0;
 		omap_chip.oc |= CHIP_IS_OMAP4430ES1;
-		pr_info("OMAP%04x %s\n", omap_rev() >> 16, rev_name);
+		snprintf(socinfo, SOCINFO_SZ, "OMAP%04x %s\n",
+				omap_rev() >> 16, rev_name);
+		pr_info("%s\n", socinfo);
 		return;
 	}
 
@@ -356,7 +362,8 @@ void __init omap3_cpuinfo(void)
 	}
 
 	/* Print verbose information */
-	pr_info("%s ES%s (", cpu_name, cpu_rev);
+	snprintf(socinfo, SOCINFO_SZ, "%s ES%s", cpu_name, cpu_rev);
+	pr_info("%s (", socinfo);
 
 	OMAP3_SHOW_FEATURE(l2cache);
 	OMAP3_SHOW_FEATURE(iva);
@@ -425,3 +432,32 @@ void __init omap2_set_globals_tap(struct omap_globals *omap2_globals)
 	else
 		tap_prod_id = 0x0208;
 }
+
+static int c_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "SoC\t: %s\n", socinfo);
+
+	return 0;
+}
+
+static void *c_start(struct seq_file *m, loff_t *pos)
+{
+	return *pos < 1 ? (void *)1 : NULL;
+}
+
+static void *c_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	++*pos;
+	return NULL;
+}
+
+static void c_stop(struct seq_file *m, void *v)
+{
+}
+
+const struct seq_operations socinfo_op = {
+	.start	= c_start,
+	.next	= c_next,
+	.stop	= c_stop,
+	.show	= c_show
+};
-- 
1.7.0.4.361.g8b5fe.dirty

