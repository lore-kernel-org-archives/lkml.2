Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181Ab1L1H7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 02:59:51 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:45556 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1L1H7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 02:59:49 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-4c-4efacc6ce1ec
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Denis Kuzmenko'" <linux@solonet.org.ua>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>
References: <4EE7BE5F.8020108@solonet.org.ua>
In-reply-to: <4EE7BE5F.8020108@solonet.org.ua>
Subject: RE: [PATCHv2 resend] Fix compilation error when
 CONFIG_CPU_FREQ_S3C24XX_DEBUGFS selected.
Date: Wed, 28 Dec 2011 16:59:40 +0900
Message-id: <01e501ccc536$a6e58fb0$f4b0af10$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: Acy521dEOjX22gjRRwSi3vHZcMnpvQLQKdLQ
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Kuzmenko wrote:
> 
> Fix compilation error when CONFIG_CPU_FREQ_S3C24XX_DEBUGFS selected.
> 
> Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>
> ---
> 
> Patch is against 3.2-rc4.
> CONFIG_S3C2410_IOTIMING is not selected for MACH_MINI2440. Because of this
> the
> file s3c2410-iotiming.c is not ever compiled and enabling
> CONFIG_CPU_FREQ_S3C24XX_DEBUGFS option caused undefined reference to
> function
> s3c2410_iotiming_debugfs defined in that file. s3c2410_iotiming_debugfs
> defined
> as NULL for this case.
> 
> Changelog:
> v1 -> v2
> New CONFIG_ symbols S3C241{0,2}_IOTIMING were removed as It was observed
> that
> they already present but hidden from user.
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index e084b7e..133d005 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -2118,7 +2118,7 @@ config CPU_FREQ_S3C24XX_DEBUG
> 
>  config CPU_FREQ_S3C24XX_IODEBUG
>  	bool "Debug CPUfreq Samsung driver IO timing"
> -	depends on CPU_FREQ_S3C24XX
> +	depends on CPU_FREQ_S3C24XX && (S3C2410_IOTIMING ||
> S3C2412_IOTIMING)

As you know, CONFIG_CPU_FREQ_S3C24XX_IODEBUG is for enabling of
s3c_freq_iodbg() and there is no problem when CONFIG_S3C241{0,2}_IOTIMING is
not selected, even though s3c_freq_iodbg() is used only at
s3c2410-iotiming.c now. So this is not necessary to fix the problem you
said.

>  	help
>  	  Enable s3c_freq_iodbg for the Samsung S3C CPUfreq core
> 
> diff --git a/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
> b/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
> index dac4760..c465252 100644
> --- a/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
> +++ b/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
> @@ -202,13 +202,23 @@ extern int s3c_plltab_register(struct
> cpufreq_frequency_table *plls,
>  extern struct s3c_cpufreq_config *s3c_cpufreq_getconfig(void);
>  extern struct s3c_iotimings *s3c_cpufreq_getiotimings(void);
> 
> -extern void s3c2410_iotiming_debugfs(struct seq_file *seq,
> -				     struct s3c_cpufreq_config *cfg,
> -				     union s3c_iobank *iob);
> -
> -extern void s3c2412_iotiming_debugfs(struct seq_file *seq,
> -				     struct s3c_cpufreq_config *cfg,
> -				     union s3c_iobank *iob);
> +#ifdef CONFIG_CPU_FREQ_S3C24XX_DEBUGFS
> +	#ifdef CONFIG_S3C2410_IOTIMING
> +	extern void s3c2410_iotiming_debugfs(struct seq_file *seq,
> +					     struct s3c_cpufreq_config *cfg,
> +					     union s3c_iobank *iob);
> +	#else
> +	#define s3c2410_iotiming_debugfs	NULL
> +	#endif
> +
> +	#ifdef CONFIG_S3C2412_IOTIMING
> +	extern void s3c2412_iotiming_debugfs(struct seq_file *seq,
> +					     struct s3c_cpufreq_config *cfg,
> +					     union s3c_iobank *iob);
> +	#else
> +	#define s3c2412_iotiming_debugfs	NULL
> +	#endif
> +#endif

Well, do we really need to have '#ifdef CONFIG_CPU_FREQ_S3C24XX_DEBUGFS'
here?
I think, just having dependency with CONFIG_S3C241{1,2}_IOTIMING can avoid
the build error.

> 
>  #ifdef CONFIG_CPU_FREQ_S3C24XX_DEBUGFS
>  #define s3c_cpufreq_debugfs_call(x) x
> @@ -241,10 +251,7 @@ extern void s3c2410_iotiming_set(struct
> s3c_cpufreq_config *cfg,
>  #endif /* CONFIG_S3C2410_IOTIMING */
> 
>  /* S3C2412 compatible routines */
> -
> -extern int s3c2412_iotiming_get(struct s3c_cpufreq_config *cfg,
> -				struct s3c_iotimings *timings);
> -

Yes, why is this duplicated :(

> +#ifdef CONFIG_S3C2412_IOTIMING
>  extern int s3c2412_iotiming_get(struct s3c_cpufreq_config *cfg,
>  				struct s3c_iotimings *timings);
> 
> @@ -253,6 +260,11 @@ extern int s3c2412_iotiming_calc(struct
> s3c_cpufreq_config *cfg,
> 
>  extern void s3c2412_iotiming_set(struct s3c_cpufreq_config *cfg,
>  				 struct s3c_iotimings *iot);
> +#else
> +#define s3c2412_iotiming_calc NULL
> +#define s3c2412_iotiming_get NULL
> +#define s3c2412_iotiming_set NULL
> +#endif
> 
>  #ifdef CONFIG_CPU_FREQ_S3C24XX_DEBUG
>  #define s3c_freq_dbg(x...) printk(KERN_INFO x)

So how about at below?
If you're ok, will send before v3.2.

---
>From 41bb50bd22cdc6d3aa7fb75efab78d341f932ae5 Mon Sep 17 00:00:00 2001
From: Denis Kuzmenko <linux@solonet.org.ua>
Date: Wed, 28 Dec 2011 14:04:51 +0900
Subject: [PATCH] ARM: SAMSUNG: Fix build error when selecting
CPU_FREQ_S3C24XX_DEBUGFS on S3C2440

Following is happened when CONFIG_CPU_FREQ_S3C24XX_DEBUGFS
is selected without building of s3c2410-iotiming.c file:

arch/arm/mach-s3c2440/built-in.o:(.data+0x38c): undefined reference to
`s3c2410_iotiming_debugfs

Basically, the CONFIG_S3C2410_IOTIMING is not selected for
MACH_MINI2440. Because the s3c2410-iotiming.c is not ever
compiled and enabling CONFIG_CPU_FREQ_S3C24XX_DEBUGFS option
caused undefined reference to s3c2410_iotiming_debugfs()
defined in that file.  The s3c2410_iotiming_debugfs defined
as NULL for this case.

Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>
[kgene.kim@samsung.com: removed useless changes]
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/plat-samsung/include/plat/cpu-freq-core.h |   25
++++++++++++--------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
b/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
index dac4760..95509d8 100644
--- a/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
+++ b/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
@@ -202,14 +202,6 @@ extern int s3c_plltab_register(struct
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
-
 #ifdef CONFIG_CPU_FREQ_S3C24XX_DEBUGFS
 #define s3c_cpufreq_debugfs_call(x) x
 #else
@@ -226,6 +218,10 @@ extern void s3c2410_cpufreq_setrefresh(struct
s3c_cpufreq_config *cfg);
 extern void s3c2410_set_fvco(struct s3c_cpufreq_config *cfg);
 
 #ifdef CONFIG_S3C2410_IOTIMING
+extern void s3c2410_iotiming_debugfs(struct seq_file *seq,
+				     struct s3c_cpufreq_config *cfg,
+				     union s3c_iobank *iob);
+
 extern int s3c2410_iotiming_calc(struct s3c_cpufreq_config *cfg,
 				 struct s3c_iotimings *iot);
 
@@ -235,6 +231,7 @@ extern int s3c2410_iotiming_get(struct
s3c_cpufreq_config *cfg,
 extern void s3c2410_iotiming_set(struct s3c_cpufreq_config *cfg,
 				 struct s3c_iotimings *iot);
 #else
+#define s3c2410_iotiming_debugfs NULL
 #define s3c2410_iotiming_calc NULL
 #define s3c2410_iotiming_get NULL
 #define s3c2410_iotiming_set NULL
@@ -242,8 +239,10 @@ extern void s3c2410_iotiming_set(struct
s3c_cpufreq_config *cfg,
 
 /* S3C2412 compatible routines */
 
-extern int s3c2412_iotiming_get(struct s3c_cpufreq_config *cfg,
-				struct s3c_iotimings *timings);
+#ifdef CONFIG_S3C2412_IOTIMING
+extern void s3c2412_iotiming_debugfs(struct seq_file *seq,
+				     struct s3c_cpufreq_config *cfg,
+				     union s3c_iobank *iob);
 
 extern int s3c2412_iotiming_get(struct s3c_cpufreq_config *cfg,
 				struct s3c_iotimings *timings);
@@ -253,6 +252,12 @@ extern int s3c2412_iotiming_calc(struct
s3c_cpufreq_config *cfg,
 
 extern void s3c2412_iotiming_set(struct s3c_cpufreq_config *cfg,
 				 struct s3c_iotimings *iot);
+#else
+#define s3c2412_iotiming_debugfs NULL
+#define s3c2412_iotiming_calc NULL
+#define s3c2412_iotiming_get NULL
+#define s3c2412_iotiming_set NULL
+#endif /* CONFIG_S3C2412_IOTIMING */
 
 #ifdef CONFIG_CPU_FREQ_S3C24XX_DEBUG
 #define s3c_freq_dbg(x...) printk(KERN_INFO x)
-- 

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

