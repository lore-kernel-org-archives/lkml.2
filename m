Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab1LUHEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 02:04:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:54526 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1LUHEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 02:04:43 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-70-4ef1850a9ce1
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
Date: Wed, 21 Dec 2011 16:04:40 +0900
Message-id: <064501ccbfae$cf1e5cb0$6d5b1610$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acy521dEOjX22gjRRwSi3vHZcMnpvQF0reYQ
Content-language: ko
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
Hi Denis,

Well, there is no error when CONFIG_CPU_FREQ_S3C24XX_DEBUGFS selected in my
case and s3c2410-iotiming.c is built...when is it happened? I just selected
every regarding configuration in kernel menuconfig...

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


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

