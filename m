Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab0LSVGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 16:06:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39391 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab0LSVGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 16:06:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH v3] rtc-cmos: fix suspend/resume
Date: Sun, 19 Dec 2010 22:05:09 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, pgf@laptop.org
References: <20101219190828.A6C189D401C@zog.reactivated.net>
In-Reply-To: <20101219190828.A6C189D401C@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201012192205.10192.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 19, 2010, Daniel Drake wrote:
> From: Paul Fox <pgf@laptop.org>
> 
> rtc-cmos was setting suspend/resume hooks at the device_driver level.
> However, the platform bus code (drivers/base/platform.c) only looks
> for resume hooks at the dev_pm_ops level, or within the platform_driver.
> 
> Switch rtc_cmos to use dev_pm_ops so that suspend/resume code is
> executed again.
> 
> Signed-off-by: Paul Fox <pgf@laptop.org>
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  drivers/rtc/rtc-cmos.c |   16 +++++++++-------
>  1 files changed, 9 insertions(+), 7 deletions(-)
> 
> v2: incorporate feedback from Rafael J. Wysocki, fix tabs, make a bit more
> consistent with typical SIMPLE_DEV_PM_OPS users.
> 
> v3: remove const keyword already set by macro, thanks to Rafael
> 
> diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
> index 5856167..dd8242d 100644
> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -36,6 +36,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/mod_devicetable.h>
>  #include <linux/log2.h>
> +#include <linux/pm.h>
>  
>  /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
>  #include <asm-generic/rtc.h>
> @@ -850,7 +851,7 @@ static void __exit cmos_do_remove(struct device *dev)
>  
>  #ifdef	CONFIG_PM
>  
> -static int cmos_suspend(struct device *dev, pm_message_t mesg)
> +static int cmos_suspend(struct device *dev)
>  {
>  	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
>  	unsigned char	tmp;
> @@ -898,7 +899,7 @@ static int cmos_suspend(struct device *dev, pm_message_t mesg)
>   */
>  static inline int cmos_poweroff(struct device *dev)
>  {
> -	return cmos_suspend(dev, PMSG_HIBERNATE);
> +	return cmos_suspend(dev);
>  }
>  
>  static int cmos_resume(struct device *dev)
> @@ -945,9 +946,9 @@ static int cmos_resume(struct device *dev)
>  	return 0;
>  }
>  
> +static SIMPLE_DEV_PM_OPS(cmos_pm_ops, cmos_suspend, cmos_resume);
> +
>  #else
> -#define	cmos_suspend	NULL
> -#define	cmos_resume	NULL
>  
>  static inline int cmos_poweroff(struct device *dev)
>  {
> @@ -1077,7 +1078,7 @@ static void __exit cmos_pnp_remove(struct pnp_dev *pnp)
>  
>  static int cmos_pnp_suspend(struct pnp_dev *pnp, pm_message_t mesg)
>  {
> -	return cmos_suspend(&pnp->dev, mesg);
> +	return cmos_suspend(&pnp->dev);
>  }
>  
>  static int cmos_pnp_resume(struct pnp_dev *pnp)
> @@ -1157,8 +1158,9 @@ static struct platform_driver cmos_platform_driver = {
>  	.shutdown	= cmos_platform_shutdown,
>  	.driver = {
>  		.name		= (char *) driver_name,
> -		.suspend	= cmos_suspend,
> -		.resume		= cmos_resume,
> +#ifdef CONFIG_PM
> +		.pm		= &cmos_pm_ops,
> +#endif
>  	}
>  };
>  
> 

