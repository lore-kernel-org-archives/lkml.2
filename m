Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab1F0EHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 00:07:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48750 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab1F0EHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 00:07:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Mv67CIBrYUJh8gtrA3duDwd2p2Y/YsXu3cfa2n/oyHeVc8cUdCk6FvXHaMxa2gl8Sd
         Uc9efiiV5HTLd+u51UJTxnBh8rdHbehdP5xx2YCqSvsdYMRKSrg8qVmJieVOZ67oqP0S
         CKLwh8hRpanbtnATr2AgMXd8XTbpA4KIkITo8=
MIME-Version: 1.0
In-Reply-To: <201106252331.43354.rjw@sisk.pl>
References: <201106112223.04972.rjw@sisk.pl>
	<201106252324.13454.rjw@sisk.pl>
	<201106252331.43354.rjw@sisk.pl>
Date: Mon, 27 Jun 2011 13:07:13 +0900
Message-ID: <BANLkTi=2kiNh4YgiCxVUV+32XXL9_ya59g@mail.gmail.com>
Subject: Re: [PATCH 10/10 v6] ARM / shmobile: Support for I/O power domains
 for SH7372 (v8)
From: Magnus Damm <magnus.damm@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 26, 2011 at 6:31 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Use the generic power domains support introduced by the previous
> patch to implement support for power domains on SH7372.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Acked-by: Paul Mundt <lethal@linux-sh.org>
> ---

Hi Rafael,

Thanks for your work on this. I've been working on up-porting my A3RV
prototype, and I came across these minor details:

> --- linux-2.6.orig/arch/arm/mach-shmobile/board-mackerel.c
> +++ linux-2.6/arch/arm/mach-shmobile/board-mackerel.c
> @@ -1582,6 +1582,10 @@ static void __init mackerel_init(void)
>
>        platform_add_devices(mackerel_devices, ARRAY_SIZE(mackerel_devices));
>
> +       sh7372_init_pm_domain(SH7372_A4LC);
> +       sh7372_add_device_to_domain(SH7372_A4LC, &lcdc_device);
> +       sh7372_add_device_to_domain(SH7372_A4LC, &hdmi_lcdc_device);
> +
>        hdmi_init_pm_clock();
>        sh7372_pm_init();
>  }
> Index: linux-2.6/arch/arm/mach-shmobile/include/mach/sh7372.h
> ===================================================================
> --- linux-2.6.orig/arch/arm/mach-shmobile/include/mach/sh7372.h
> +++ linux-2.6/arch/arm/mach-shmobile/include/mach/sh7372.h
> @@ -12,6 +12,7 @@
>  #define __ASM_SH7372_H__
>
>  #include <linux/sh_clk.h>
> +#include <linux/pm_domain.h>
>
>  /*
>  * Pin Function Controller:
> @@ -470,4 +471,31 @@ extern struct clk sh7372_fsibck_clk;
>  extern struct clk sh7372_fsidiva_clk;
>  extern struct clk sh7372_fsidivb_clk;
>
> +struct platform_device;
> +
> +struct sh7372_pm_domain {
> +       struct generic_pm_domain genpd;
> +       unsigned int bit_shift;
> +};
> +
> +static inline struct sh7372_pm_domain *to_sh7372_pd(struct generic_pm_domain *d)
> +{
> +       return container_of(d, struct sh7372_pm_domain, genpd);
> +}
> +
> +#ifdef CONFIG_PM
> +extern struct sh7372_pm_domain sh7372_a4lc_domain;
> +#define SH7372_A4LC    (&sh7372_a4lc_domain)
> +
> +extern void sh7372_init_pm_domain(struct sh7372_pm_domain *sh7372_pd);
> +extern void sh7372_add_device_to_domain(struct sh7372_pm_domain *sh7372_pd,
> +                                       struct platform_device *pdev);
> +#else
> +#define SH7372_A4LC    NULL
> +
> +static inline void sh7372_init_pm_domain(struct sh7372_pm_domain *sh7372_pd) {}
> +static inline void sh7372_add_device_to_domain(struct sh7372_pm_domain *pd,
> +                                              struct platform_device *pdev) {}
> +#endif /* CONFIG_PM */
> +
>  #endif /* __ASM_SH7372_H__ */

Wouldn't it be easier to simply get rid of SH7372_A4LC? Perhaps you
have some special intention behind your #define, but for me the
following change is working just fine:

--- 0001/arch/arm/mach-shmobile/board-mackerel.c
+++ work/arch/arm/mach-shmobile/board-mackerel.c	2011-06-27
13:04:22.000000000 +0900
@@ -1582,9 +1582,9 @@ static void __init mackerel_init(void)

 	platform_add_devices(mackerel_devices, ARRAY_SIZE(mackerel_devices));

-	sh7372_init_pm_domain(SH7372_A4LC);
-	sh7372_add_device_to_domain(SH7372_A4LC, &lcdc_device);
-	sh7372_add_device_to_domain(SH7372_A4LC, &hdmi_lcdc_device);
+	sh7372_init_pm_domain(&sh7372_a4lc);
+	sh7372_add_device_to_domain(&sh7372_a4lc, &lcdc_device);
+	sh7372_add_device_to_domain(&sh7372_a4lc, &hdmi_lcdc_device);

 	hdmi_init_pm_clock();
 	sh7372_pm_init();
--- 0001/arch/arm/mach-shmobile/include/mach/sh7372.h
+++ work/arch/arm/mach-shmobile/include/mach/sh7372.h	2011-06-27
13:03:46.000000000 +0900
@@ -484,15 +484,12 @@ static inline struct sh7372_pm_domain *t
 }

 #ifdef CONFIG_PM
-extern struct sh7372_pm_domain sh7372_a4lc_domain;
-#define SH7372_A4LC	(&sh7372_a4lc_domain)
+extern struct sh7372_pm_domain sh7372_a4lc;

 extern void sh7372_init_pm_domain(struct sh7372_pm_domain *sh7372_pd);
 extern void sh7372_add_device_to_domain(struct sh7372_pm_domain *sh7372_pd,
 					struct platform_device *pdev);
 #else
-#define SH7372_A4LC	NULL
-
 static inline void sh7372_init_pm_domain(struct sh7372_pm_domain *sh7372_pd) {}
 static inline void sh7372_add_device_to_domain(struct sh7372_pm_domain *pd,
 					       struct platform_device *pdev) {}
--- 0001/arch/arm/mach-shmobile/pm-sh7372.c
+++ work/arch/arm/mach-shmobile/pm-sh7372.c	2011-06-27 13:04:02.000000000 +0900
@@ -115,7 +115,7 @@ void sh7372_add_device_to_domain(struct
 	pm_genpd_add_device(&sh7372_pd->genpd, dev);
 }

-struct sh7372_pm_domain sh7372_a4lc_domain = {
+struct sh7372_pm_domain sh7372_a4lc = {
 	.bit_shift = 1,
 };

Also, one more thing:

> --- linux-2.6.orig/arch/arm/mach-shmobile/Makefile
> +++ linux-2.6/arch/arm/mach-shmobile/Makefile
> @@ -42,6 +42,10 @@ obj-$(CONFIG_MACH_AP4EVB)    += board-ap4ev
>  obj-$(CONFIG_MACH_AG5EVM)      += board-ag5evm.o
>  obj-$(CONFIG_MACH_MACKEREL)    += board-mackerel.o
>
> +# PM objects
> +pm-$(CONFIG_ARCH_SH7372)       += pm-sh7372.o
> +
>  # Framework support
>  obj-$(CONFIG_SMP)              += $(smp-y)
>  obj-$(CONFIG_GENERIC_GPIO)     += $(pfc-y)
> +obj-$(CONFIG_PM)               += $(pm-y)

I don't think this hunk is needed. It must be a left over from some
older version of the patch when pm-sh7372.c didn't exist.

Would you like me to submit incremental patches, or do you prefer to
fix up your current patch?

Thanks!

/ magnus
