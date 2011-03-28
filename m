Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab1C1QSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:18:35 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:36713 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051Ab1C1QSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:18:34 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 2/7] ARM / OMAP: Use struct syscore_ops for "core" power management
Organization: Texas Instruments, Inc.
References: <201103280125.11750.rjw@sisk.pl> <201103280127.09110.rjw@sisk.pl>
Date: Mon, 28 Mar 2011 09:18:28 -0700
In-Reply-To: <201103280127.09110.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Mon, 28 Mar 2011 01:27:08 +0200")
Message-ID: <87ipv3kyln.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Replace the sysdev class and struct sys_device used for power
> management in the OMAP's GPIO code with a struct syscore_ops object
> which is simpler.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Kevin Hilman <khilman@ti.com>

Looks fine to me.  We're in the process of converting this driver to
runtime PM.  When that happens the syscore ops will be removed as well,
but I'm fine with this patch until we finish the runtime PM conversion.

Kevin

> ---
>  arch/arm/plat-omap/gpio.c |   35 +++++++++--------------------------
>  1 file changed, 9 insertions(+), 26 deletions(-)
>
> Index: linux-2.6/arch/arm/plat-omap/gpio.c
> ===================================================================
> --- linux-2.6.orig/arch/arm/plat-omap/gpio.c
> +++ linux-2.6/arch/arm/plat-omap/gpio.c
> @@ -17,7 +17,7 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/interrupt.h>
> -#include <linux/sysdev.h>
> +#include <linux/syscore_ops.h>
>  #include <linux/err.h>
>  #include <linux/clk.h>
>  #include <linux/io.h>
> @@ -1379,9 +1379,7 @@ static const struct dev_pm_ops omap_mpui
>  	.resume_noirq = omap_mpuio_resume_noirq,
>  };
>  
> -/* use platform_driver for this, now that there's no longer any
> - * point to sys_device (other than not disturbing old code).
> - */
> +/* use platform_driver for this. */
>  static struct platform_driver omap_mpuio_driver = {
>  	.driver		= {
>  		.name	= "mpuio",
> @@ -1754,7 +1752,7 @@ static int __devinit omap_gpio_probe(str
>  }
>  
>  #if defined(CONFIG_ARCH_OMAP16XX) || defined(CONFIG_ARCH_OMAP2PLUS)
> -static int omap_gpio_suspend(struct sys_device *dev, pm_message_t mesg)
> +static int omap_gpio_suspend(void)
>  {
>  	int i;
>  
> @@ -1804,12 +1802,12 @@ static int omap_gpio_suspend(struct sys_
>  	return 0;
>  }
>  
> -static int omap_gpio_resume(struct sys_device *dev)
> +static void omap_gpio_resume(void)
>  {
>  	int i;
>  
>  	if (!cpu_class_is_omap2() && !cpu_is_omap16xx())
> -		return 0;
> +		return;
>  
>  	for (i = 0; i < gpio_bank_count; i++) {
>  		struct gpio_bank *bank = &gpio_bank[i];
> @@ -1845,21 +1843,13 @@ static int omap_gpio_resume(struct sys_d
>  		__raw_writel(bank->saved_wakeup, wake_set);
>  		spin_unlock_irqrestore(&bank->lock, flags);
>  	}
> -
> -	return 0;
>  }
>  
> -static struct sysdev_class omap_gpio_sysclass = {
> -	.name		= "gpio",
> +static struct syscore_ops omap_gpio_syscore_ops = {
>  	.suspend	= omap_gpio_suspend,
>  	.resume		= omap_gpio_resume,
>  };
>  
> -static struct sys_device omap_gpio_device = {
> -	.id		= 0,
> -	.cls		= &omap_gpio_sysclass,
> -};
> -
>  #endif
>  
>  #ifdef CONFIG_ARCH_OMAP2PLUS
> @@ -2117,21 +2107,14 @@ postcore_initcall(omap_gpio_drv_reg);
>  
>  static int __init omap_gpio_sysinit(void)
>  {
> -	int ret = 0;
> -
>  	mpuio_init();
>  
>  #if defined(CONFIG_ARCH_OMAP16XX) || defined(CONFIG_ARCH_OMAP2PLUS)
> -	if (cpu_is_omap16xx() || cpu_class_is_omap2()) {
> -		if (ret == 0) {
> -			ret = sysdev_class_register(&omap_gpio_sysclass);
> -			if (ret == 0)
> -				ret = sysdev_register(&omap_gpio_device);
> -		}
> -	}
> +	if (cpu_is_omap16xx() || cpu_class_is_omap2())
> +		register_syscore_ops(&omap_gpio_syscore_ops);
>  #endif
>  
> -	return ret;
> +	return 0;
>  }
>  
>  arch_initcall(omap_gpio_sysinit);
