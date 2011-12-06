Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab1LFBlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:41:13 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40002 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab1LFBlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:41:09 -0500
Message-ID: <4EDD720B.5040607@solonet.org.ua>
Date: Tue, 06 Dec 2011 03:38:19 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH resend2] s3c24xx: cpufreq: Fix compilation error when CONFIG_CPU_FREQ_S3C24XX_DEBUGFS
 selected.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compilation error when CONFIG_CPU_FREQ_S3C24XX_DEBUGFS selected.

Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>
---

Patch is against 3.2-rc3.
CONFIG_S3C2410_IOTIMING wasn't present in Kconfig but was referenced by
Makefile. Because of this the file s3c2410-iotiming.c was not ever compiled
and enabling CONFIG_CPU_FREQ_S3C24XX_DEBUGFS option caused undefined
reference to function s3c2410_iotiming_debugfs defined in that file.

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 44789ef..81d7025 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2104,9 +2104,31 @@ config CPU_FREQ_S3C24XX_DEBUG
 	help
 	  Enable s3c_freq_dbg for the Samsung S3C CPUfreq core
 +config S3C2410_IOTIMING
+	bool "CPUfreq iotiming for Samsung S3C2410 series CPUs"
+	depends on ARCH_S3C2410 && CPU_FREQ && CPU_FREQ_S3C24XX && EXPERIMENTAL
+	help
+	  This enables the CPUfreq driver for the Samsung S3C24XX to change
+	  IO timing according to the CPU frequency.
+
+	  For details, take a look at <file:Documentation/cpu-freq>.
+
+	  If in doubt, say Y.
+
+config S3C2412_IOTIMING
+	bool "CPUfreq iotiming for Samsung S3C2412 series CPUs"
+	depends on ARCH_S3C2412 && CPU_FREQ && CPU_FREQ_S3C24XX && EXPERIMENTAL
+	help
+	  This enables the CPUfreq driver for the Samsung S3C2412 to change
+	  IO timing according to the CPU frequency.
+
+	  For details, take a look at <file:Documentation/cpu-freq>.
+
+	  If in doubt, say Y.
+
 config CPU_FREQ_S3C24XX_IODEBUG
 	bool "Debug CPUfreq Samsung driver IO timing"
-	depends on CPU_FREQ_S3C24XX
+	depends on CPU_FREQ_S3C24XX && (S3C2410_IOTIMING || S3C2412_IOTIMING)
 	help
 	  Enable s3c_freq_iodbg for the Samsung S3C CPUfreq core
 diff --git a/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
b/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
index dac4760..c465252 100644
--- a/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
+++ b/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
@@ -202,13 +202,23 @@ extern int s3c_plltab_register(struct
cpufreq_frequency_table *plls,
 extern struct s3c_cpufreq_config *s3c_cpufreq_getconfig(void);
 extern struct s3c_iotimings *s3c_cpufreq_getiotimings(void);
 -extern void s3c2410_iotiming_debugfs(struct seq_file *seq,
-				     struct s3c_cpufreq_config *cfg,
-				     union s3c_iobank *iob);
-
-extern void s3c2412_iotiming_debugfs(struct seq_file *seq,
-				     struct s3c_cpufreq_config *cfg,
-				     union s3c_iobank *iob);
+#ifdef CONFIG_CPU_FREQ_S3C24XX_DEBUGFS
+	#ifdef CONFIG_S3C2410_IOTIMING
+	extern void s3c2410_iotiming_debugfs(struct seq_file *seq,
+					     struct s3c_cpufreq_config *cfg,
+					     union s3c_iobank *iob);
+	#else
+	#define s3c2410_iotiming_debugfs	NULL
+	#endif
+
+	#ifdef CONFIG_S3C2412_IOTIMING
+	extern void s3c2412_iotiming_debugfs(struct seq_file *seq,
+					     struct s3c_cpufreq_config *cfg,
+					     union s3c_iobank *iob);
+	#else
+	#define s3c2412_iotiming_debugfs	NULL
+	#endif
+#endif
  #ifdef CONFIG_CPU_FREQ_S3C24XX_DEBUGFS
 #define s3c_cpufreq_debugfs_call(x) x
@@ -241,10 +251,7 @@ extern void s3c2410_iotiming_set(struct
s3c_cpufreq_config *cfg,
 #endif /* CONFIG_S3C2410_IOTIMING */
  /* S3C2412 compatible routines */
-
-extern int s3c2412_iotiming_get(struct s3c_cpufreq_config *cfg,
-				struct s3c_iotimings *timings);
-
+#ifdef CONFIG_S3C2412_IOTIMING
 extern int s3c2412_iotiming_get(struct s3c_cpufreq_config *cfg,
 				struct s3c_iotimings *timings);
 @@ -253,6 +260,11 @@ extern int s3c2412_iotiming_calc(struct
s3c_cpufreq_config *cfg,
  extern void s3c2412_iotiming_set(struct s3c_cpufreq_config *cfg,
 				 struct s3c_iotimings *iot);
+#else
+#define s3c2412_iotiming_calc NULL
+#define s3c2412_iotiming_get NULL
+#define s3c2412_iotiming_set NULL
+#endif
  #ifdef CONFIG_CPU_FREQ_S3C24XX_DEBUG
 #define s3c_freq_dbg(x...) printk(KERN_INFO x)
