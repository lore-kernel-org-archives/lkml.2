Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab0EJKhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 06:37:14 -0400
Received: from smtp.nokia.com ([192.100.105.134]:57445 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab0EJKg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 06:36:58 -0400
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
Subject: [PATCHv4 4/4] OMAP3: export chip IDCODE, Production ID and Die ID
Date: Mon, 10 May 2010 13:37:37 +0300
Message-Id: <1273487857-32281-5-git-send-email-eduardo.valentin@nokia.com>
X-Mailer: git-send-email 1.7.0.4.361.g8b5fe.dirty
In-Reply-To: <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com>
References: <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com>
X-OriginalArrivalTime: 10 May 2010 10:35:47.0603 (UTC) FILETIME=[8D760630:01CAF02C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Valentin <eduardo.valentin@nokia.com>

This patch exports the OMAP3 IDCODE and Production ID to userspace
via /proc/socinfo.

Die ID is also exported depending on what users pass as kernel
parameter. It is same protection mechanism made for x86 product
number. So, if user passes "omap3_die_id" parameter, it will append
die id code into /proc/socinfo as well. A Kconfig option has been
added as well, so it can be configurable during compilation time.

This can be used to track down silicon specific issues. The info is
exported via /proc/socinfo because then it can be possible to include this
in corematic dumps.

This is based on Peter De Schrijver patch, which export same info via sysfs.

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 Documentation/kernel-parameters.txt |    2 ++
 arch/arm/mach-omap2/Kconfig         |   10 ++++++++++
 arch/arm/mach-omap2/id.c            |   35 ++++++++++++++++++++++++++++++++++-
 3 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 839b21b..8010cfb 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1809,6 +1809,8 @@ and is between 256 and 4096 characters. It is defined in the file
 			waiting for the ACK, so if this is set too high
 			interrupts *may* be lost!
 
+	omap3_die_id	[OMAP] Append DIE ID info under /proc/socinfo
+
 	omap_mux=	[OMAP] Override bootloader pin multiplexing.
 			Format: <mux_mode0.mode_name=value>...
 			For example, to override I2C bus2:
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 2455dcc..fb8abed 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -169,3 +169,13 @@ config OMAP3_SDRC_AC_TIMING
 	  wish to say no.  Selecting yes without understanding what is
 	  going on could result in system crashes;
 
+config OMAP3_EXPORT_DIE_ID
+	bool "Export DIE ID code under /proc/socinfo"
+	depends on ARCH_OMAP3
+	default n
+	help
+	  Say Y here if you need DIE ID code to be exported via /proc/socinfo
+	  in production systems. You will need also to explicitly flag it by
+	  appending the "omap3_die_id" parameter to your boot command line.
+
+
diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 8ecd8e2..9663066 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -77,6 +77,10 @@ EXPORT_SYMBOL(omap_type);
 /*----------------------------------------------------------------------------*/
 
 #define OMAP_TAP_IDCODE		0x0204
+#define OMAP_TAP_PROD_ID_0      0x0208
+#define OMAP_TAP_PROD_ID_1      0x020c
+#define OMAP_TAP_PROD_ID_2      0x0210
+#define OMAP_TAP_PROD_ID_3      0x0214
 #define OMAP_TAP_DIE_ID_0	0x0218
 #define OMAP_TAP_DIE_ID_1	0x021C
 #define OMAP_TAP_DIE_ID_2	0x0220
@@ -305,6 +309,7 @@ void __init omap4_check_revision(void)
 
 void __init omap3_cpuinfo(void)
 {
+	int sz;
 	u8 rev = GET_OMAP_REVISION();
 	char cpu_name[16], cpu_rev[16];
 
@@ -362,7 +367,7 @@ void __init omap3_cpuinfo(void)
 	}
 
 	/* Print verbose information */
-	snprintf(socinfo, SOCINFO_SZ, "%s ES%s", cpu_name, cpu_rev);
+	sz = snprintf(socinfo, SOCINFO_SZ, "%s ES%s", cpu_name, cpu_rev);
 	pr_info("%s (", socinfo);
 
 	OMAP3_SHOW_FEATURE(l2cache);
@@ -373,7 +378,35 @@ void __init omap3_cpuinfo(void)
 	OMAP3_SHOW_FEATURE(192mhz_clk);
 
 	printk(")\n");
+
+	/* Append OMAP3 IDCODE and Production ID to system_soc_info */
+	snprintf(socinfo + sz, SOCINFO_SZ - sz,
+			"\nIDCODE\t: %08x\nPr. ID\t: %08x %08x %08x %08x",
+			read_tap_reg(OMAP_TAP_IDCODE),
+			read_tap_reg(OMAP_TAP_PROD_ID_0),
+			read_tap_reg(OMAP_TAP_PROD_ID_1),
+			read_tap_reg(OMAP_TAP_PROD_ID_2),
+			read_tap_reg(OMAP_TAP_PROD_ID_3));
+
+}
+
+#ifdef CONFIG_OMAP3_EXPORT_DIE_ID
+static int __init omap3_die_id_setup(char *s)
+{
+	int sz;
+
+	sz = strlen(socinfo);
+	snprintf(socinfo + sz, SOCINFO_SZ - sz,
+			"\nDie ID\t: %08x %08x %08x %08x",
+			read_tap_reg(OMAP_TAP_DIE_ID_0),
+			read_tap_reg(OMAP_TAP_DIE_ID_1),
+			read_tap_reg(OMAP_TAP_DIE_ID_2),
+			read_tap_reg(OMAP_TAP_DIE_ID_3));
+
+	return 1;
 }
+__setup("omap3_die_id", omap3_die_id_setup);
+#endif
 
 /*
  * Try to detect the exact revision of the omap we're running on
-- 
1.7.0.4.361.g8b5fe.dirty

