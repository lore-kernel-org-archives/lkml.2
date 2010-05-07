Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab0EGMoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 08:44:01 -0400
Received: from poutre.nerim.net ([62.4.16.124]:56990 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab0EGMn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 08:43:59 -0400
Date: Fri, 7 May 2010 14:43:56 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Huaxu Wan <huaxu.wan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       huaxu.wan@intel.com
Subject: Re: [PATCH 1/2] hwmon: (coretemp) Detect the thermal sensors by
 CPUID
Message-ID: <20100507144356.4dae6046@hyperion.delvare>
In-Reply-To: <20100507095459.GA12190@owl>
References: <20100507095459.GA12190@owl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huawu,

On Fri, 7 May 2010 17:54:59 +0800, Huaxu Wan wrote:
> 
> The thermal sensors of Intel(R) CPUs can be detected by CPUID instruction,
> indicated by CPUID.06H.EAX[0].

I can see that you are sending these two patches for quite some time
and I understand you'd like them to get finally reviewed and merged.
Unfortunately I simply don't have the time for this. So please don't
wait for my ack, just send your patches to Andrew Morton and hopefully
he will take care.

> 
> Signed-off-by: Huaxu Wan <huaxu.wan@linux.intel.com>
> ---
>  drivers/hwmon/coretemp.c |   24 +++++++-----------------
>  1 files changed, 7 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index e9b7fbc..237c68d 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -440,6 +440,7 @@ static int __init coretemp_init(void)
>  {
>         int i, err = -ENODEV;
>         struct pdev_entry *p, *n;
> +       u32 eax;
> 
>         /* quick check if we run Intel */
>         if (cpu_data(0).x86_vendor != X86_VENDOR_INTEL)
> @@ -450,23 +451,12 @@ static int __init coretemp_init(void)
>                 goto exit;
> 
>         for_each_online_cpu(i) {
> -               struct cpuinfo_x86 *c = &cpu_data(i);
> -
> -               /* check if family 6, models 0xe (Pentium M DC),
> -                 0xf (Core 2 DC 65nm), 0x16 (Core 2 SC 65nm),
> -                 0x17 (Penryn 45nm), 0x1a (Nehalem), 0x1c (Atom),
> -                 0x1e (Lynnfield) */
> -               if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
> -                   !((c->x86_model == 0xe) || (c->x86_model == 0xf) ||
> -                       (c->x86_model == 0x16) || (c->x86_model == 0x17) ||
> -                       (c->x86_model == 0x1a) || (c->x86_model == 0x1c) ||
> -                       (c->x86_model == 0x1e))) {
> -
> -                       /* supported CPU not found, but report the unknown
> -                          family 6 CPU */
> -                       if ((c->x86 == 0x6) && (c->x86_model > 0xf))
> -                               printk(KERN_WARNING DRVNAME ": Unknown CPU "
> -                                       "model 0x%x\n", c->x86_model);
> +               /* check if the CPU has thermal sensor */
> +               eax = cpuid_eax(0x06);
> +               if (!(eax & 0x01)) {
> +                       struct cpuinfo_x86 *c = &cpu_data(i);
> +                       printk_once(KERN_WARNING DRVNAME ": CPU (model=0x%x)"
> +                               " has no thermal sensor!\n", c->x86_model);
>                         continue;
>                 }
> 
> --
> 1.6.3.3.363.g725cf7


-- 
Jean Delvare
