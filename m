Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab0LPRXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:23:13 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56248 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab0LPRXL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:23:11 -0500
MIME-Version: 1.0
In-Reply-To: <1292519639-21859-2-git-send-email-w.sang@pengutronix.de>
References: <1292519639-21859-1-git-send-email-w.sang@pengutronix.de> <1292519639-21859-2-git-send-email-w.sang@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 16 Dec 2010 10:22:51 -0700
X-Google-Sender-Auth: aKq2QkFgao2M8RWkRRP8Tw669DE
Message-ID: <AANLkTimxAGVkQF24YgDt+TxjbXvW+iCNJhqVLwXO6FXD@mail.gmail.com>
Subject: Re: [PATCH 1/3] of: platform: introduce of_probe_platform_driver()
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 10:13 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> Introduce a function equivalent to platform_driver_probe() for of. This is
> needed to keep some SoC devices in the __init section.
>
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>

Hi Wolfram

Nack for two reasons:
1- Anything needed at driver probe time should be in an __devinit
section.  What specifically are you wanting to keep in __init
2- of_platform_driver is deprecated.  Drivers should be converted to
use platform_driver directly.

g.

> ---
>  drivers/of/platform.c       |   30 +++++++++++++++++++++++++++---
>  include/linux/of_platform.h |    2 ++
>  2 files changed, 29 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 5b4a07f..511657b 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -72,7 +72,7 @@ static void platform_driver_shutdown_shim(struct platform_device *pdev)
>  /**
>  * of_register_platform_driver
>  */
> -int of_register_platform_driver(struct of_platform_driver *drv)
> +int __of_register_platform_driver(struct of_platform_driver *drv, bool do_probe)
>  {
>        char *of_name;
>
> @@ -90,18 +90,42 @@ int of_register_platform_driver(struct of_platform_driver *drv)
>        sprintf(of_name, "of:%s", drv->driver.name);
>        drv->platform_driver.driver.name = of_name;
>
> -       if (drv->probe)
> -               drv->platform_driver.probe = platform_driver_probe_shim;
>        drv->platform_driver.remove = drv->remove;
>        if (drv->shutdown)
>                drv->platform_driver.shutdown = platform_driver_shutdown_shim;
>        drv->platform_driver.suspend = drv->suspend;
>        drv->platform_driver.resume = drv->resume;
>
> +       if (do_probe)
> +               return platform_driver_probe(&drv->platform_driver,
> +                                       platform_driver_probe_shim);
> +
> +       if (drv->probe)
> +               drv->platform_driver.probe = platform_driver_probe_shim;
> +
>        return platform_driver_register(&drv->platform_driver);
>  }
> +
> +int of_register_platform_driver(struct of_platform_driver *drv)
> +{
> +       return __of_register_platform_driver(drv, false);
> +}
> +
>  EXPORT_SYMBOL(of_register_platform_driver);
>
> +int of_probe_platform_driver(struct of_platform_driver *drv,
> +               int (*probe)(struct platform_device *, const struct of_device_id *match))
> +{
> +       int ret;
> +
> +       drv->probe = probe;
> +       ret = __of_register_platform_driver(drv, true);
> +       drv->probe = NULL;
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL(of_probe_platform_driver);
> +
>  void of_unregister_platform_driver(struct of_platform_driver *drv)
>  {
>        platform_driver_unregister(&drv->platform_driver);
> diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
> index a68716a..c4082c7 100644
> --- a/include/linux/of_platform.h
> +++ b/include/linux/of_platform.h
> @@ -53,6 +53,8 @@ extern void of_unregister_driver(struct of_platform_driver *drv);
>
>  /* Platform drivers register/unregister */
>  extern int of_register_platform_driver(struct of_platform_driver *drv);
> +extern int of_probe_platform_driver(struct of_platform_driver *drv,
> +               int (*probe)(struct platform_device *, const struct of_device_id *match));
>  extern void of_unregister_platform_driver(struct of_platform_driver *drv);
>
>  extern struct platform_device *of_device_alloc(struct device_node *np,
> --
> 1.7.2.3
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
