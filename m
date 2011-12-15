Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab1LOWor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:44:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60375 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523Ab1LOWop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:44:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [Update][PATCH 5/5] PM: Drop generic_subsys_pm_ops
Date: Thu, 15 Dec 2011 23:47:43 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Namhyung Kim <namhyung@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <201112100018.38536.rjw@sisk.pl> <201112152334.16527.rjw@sisk.pl> <201112152339.15825.rjw@sisk.pl>
In-Reply-To: <201112152339.15825.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112152347.43785.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 15, 2011, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Since the PM core is now going to execute driver callbacks directly
> if the corresponding subsystem callbacks are not present,
> forward-only subsystem callbacks (i.e. such that only execute the
> corresponding driver callbacks) are not necessary any more.  Thus
> it is possible to remove generic_subsys_pm_ops, because the only
> callback in there that is not forward-only, .runtime_idle, is not
> really used by the only user of generic_subsys_pm_ops, which is
> vio_bus_type.
> 
> However, the generic callback routines themselves cannot be removed
> from generic_ops.c, because they are used individually by a number
> of subsystems.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Well, Ben should have a look at this one too.  Now CCed.

Thanks,
Rafael


> ---
>  arch/powerpc/kernel/vio.c        |    1 -
>  drivers/base/power/generic_ops.c |   25 -------------------------
>  include/linux/pm.h               |   13 -------------
>  3 files changed, 39 deletions(-)
> 
> Index: linux/drivers/base/power/generic_ops.c
> ===================================================================
> --- linux.orig/drivers/base/power/generic_ops.c
> +++ linux/drivers/base/power/generic_ops.c
> @@ -302,28 +302,3 @@ void pm_generic_complete(struct device *
>  	pm_runtime_idle(dev);
>  }
>  #endif /* CONFIG_PM_SLEEP */
> -
> -struct dev_pm_ops generic_subsys_pm_ops = {
> -#ifdef CONFIG_PM_SLEEP
> -	.prepare = pm_generic_prepare,
> -	.suspend = pm_generic_suspend,
> -	.suspend_noirq = pm_generic_suspend_noirq,
> -	.resume = pm_generic_resume,
> -	.resume_noirq = pm_generic_resume_noirq,
> -	.freeze = pm_generic_freeze,
> -	.freeze_noirq = pm_generic_freeze_noirq,
> -	.thaw = pm_generic_thaw,
> -	.thaw_noirq = pm_generic_thaw_noirq,
> -	.poweroff = pm_generic_poweroff,
> -	.poweroff_noirq = pm_generic_poweroff_noirq,
> -	.restore = pm_generic_restore,
> -	.restore_noirq = pm_generic_restore_noirq,
> -	.complete = pm_generic_complete,
> -#endif
> -#ifdef CONFIG_PM_RUNTIME
> -	.runtime_suspend = pm_generic_runtime_suspend,
> -	.runtime_resume = pm_generic_runtime_resume,
> -	.runtime_idle = pm_generic_runtime_idle,
> -#endif
> -};
> -EXPORT_SYMBOL_GPL(generic_subsys_pm_ops);
> Index: linux/include/linux/pm.h
> ===================================================================
> --- linux.orig/include/linux/pm.h
> +++ linux/include/linux/pm.h
> @@ -300,19 +300,6 @@ const struct dev_pm_ops name = { \
>  	SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
>  }
>  
> -/*
> - * Use this for subsystems (bus types, device types, device classes) that don't
> - * need any special suspend/resume handling in addition to invoking the PM
> - * callbacks provided by device drivers supporting both the system sleep PM and
> - * runtime PM, make the pm member point to generic_subsys_pm_ops.
> - */
> -#ifdef CONFIG_PM
> -extern struct dev_pm_ops generic_subsys_pm_ops;
> -#define GENERIC_SUBSYS_PM_OPS	(&generic_subsys_pm_ops)
> -#else
> -#define GENERIC_SUBSYS_PM_OPS	NULL
> -#endif
> -
>  /**
>   * PM_EVENT_ messages
>   *
> Index: linux/arch/powerpc/kernel/vio.c
> ===================================================================
> --- linux.orig/arch/powerpc/kernel/vio.c
> +++ linux/arch/powerpc/kernel/vio.c
> @@ -1406,7 +1406,6 @@ static struct bus_type vio_bus_type = {
>  	.match = vio_bus_match,
>  	.probe = vio_bus_probe,
>  	.remove = vio_bus_remove,
> -	.pm = GENERIC_SUBSYS_PM_OPS,
>  };
>  
>  /**
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

