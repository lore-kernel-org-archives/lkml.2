Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab3AHKZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:25:59 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:46069 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab3AHKZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:25:57 -0500
MIME-Version: 1.0
In-Reply-To: <1357353529-20901-8-git-send-email-wenyou.yang@atmel.com>
References: <1357353529-20901-1-git-send-email-wenyou.yang@atmel.com> <1357353529-20901-8-git-send-email-wenyou.yang@atmel.com>
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Tue, 8 Jan 2013 11:17:43 +0100
Message-ID: <CAHkwnC8CTFxrJ8F=u=MqKW=cZ88SeoT+rA_hzW38jL8ffT9D2Q@mail.gmail.com>
Subject: Re: [v3 PATCH 7/9] watchdog/at91sam9_wdt: Use module_platform_driver()
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        JM.Lin@atmel.com, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 5, 2013 at 3:38 AM, Wenyou Yang <wenyou.yang@atmel.com> wrote:
> Using module_platform_driver() replaces module_init() and module_exit()
> and makes the code simpler.
>
> Remove '__init' annotation from the function 'at91wdt_probe'
> since the driver becomes hot-plug aware now.
>
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> Cc: wim@iguana.be
> Cc: linux-watchdog@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/watchdog/at91sam9_wdt.c |   16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
> index 94be9d6..7c13dda 100644
> --- a/drivers/watchdog/at91sam9_wdt.c
> +++ b/drivers/watchdog/at91sam9_wdt.c
> @@ -204,7 +204,7 @@ static struct watchdog_device at91wdt_wdd = {
>         .ops = &at91wdt_ops,
>  };
>
> -static int __init at91wdt_probe(struct platform_device *pdev)
> +static int at91wdt_probe(struct platform_device *pdev)
>  {
>         struct at91wdt_drvdata *driver_data;
>         struct resource *r;
> @@ -273,6 +273,7 @@ MODULE_DEVICE_TABLE(of, at91_wdt_dt_ids);
>  #endif
>
>  static struct platform_driver at91wdt_driver = {
> +       .probe          = at91wdt_probe,
>         .remove         = __exit_p(at91wdt_remove),
>         .driver         = {
>                 .name   = "at91_wdt",
> @@ -281,18 +282,7 @@ static struct platform_driver at91wdt_driver = {
>         },
>  };
>
> -static int __init at91sam_wdt_init(void)
> -{
> -       return platform_driver_probe(&at91wdt_driver, at91wdt_probe);
> -}
> -
> -static void __exit at91sam_wdt_exit(void)
> -{
> -       platform_driver_unregister(&at91wdt_driver);
> -}
> -
> -module_init(at91sam_wdt_init);
> -module_exit(at91sam_wdt_exit);
> +module_platform_driver(at91wdt_driver);
>
>  MODULE_AUTHOR("Renaud CERRATO <r.cerrato@til-technologies.fr>");
>  MODULE_DESCRIPTION("Watchdog driver for Atmel AT91SAM9x processors");
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

The module_platform_driver isn't a substitute of platform_driver_probe,
because module_platform_driver  use platform_driver_register/unregister.
Using that macro we lose the advantage of platform_driver_probe,
as stated in:

https://lkml.org/lkml/2012/1/10/335
On Tue, Jan 10, 2012 at 21:47, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> [...]
>Still, setting up platform_driver.probe and removing __init from all probe
>functions is not the right thing to do, as this make (non-__init) kernel code
>size bigger, while none of these devices are hotpluggable and thus cannot
>appear after bootup. That's why we have platform_driver_probe() in the
>first place. So I think all of this should be reverted for non-hotpluggable
>drivers.
> [...]

Best regards

--
Fabio Porcedda
