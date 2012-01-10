Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab2AJUro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 15:47:44 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64031 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab2AJUrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 15:47:41 -0500
MIME-Version: 1.0
In-Reply-To: <1321952446-7591-2-git-send-email-jj_ding@emc.com.tw>
References: <1321952446-7591-1-git-send-email-jj_ding@emc.com.tw>
	<1321952446-7591-2-git-send-email-jj_ding@emc.com.tw>
Date: Tue, 10 Jan 2012 21:47:40 +0100
X-Google-Sender-Auth: po7AH2G_aNHYqRkJH5n3i0utwuY
Message-ID: <CAMuHMdWVedppkaO5sF4WH78e8rdVJKXJknFVEZQo+VD2Rxmk=A@mail.gmail.com>
Subject: Re: [PATCH TRIVIAL 1/5] Input: keyboard: use macro module_platform_driver()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: JJ Ding <jj_ding@emc.com.tw>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, JJ Ding <dgdunix@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 10:00, JJ Ding <jj_ding@emc.com.tw> wrote:
> From: JJ Ding <dgdunix@gmail.com>
>
> Commit 940ab88962bc1aff3273a8356d64577a6e386736 introduced a new macro to
> save some platform_driver boilerplate code. Use it.

> diff --git a/drivers/input/keyboard/amikbd.c b/drivers/input/keyboard/amikbd.c
> index 79172af..6df5f6a 100644
> --- a/drivers/input/keyboard/amikbd.c
> +++ b/drivers/input/keyboard/amikbd.c
> @@ -259,19 +259,6 @@ static struct platform_driver amikbd_driver = {
>                .owner  = THIS_MODULE,
>        },
>  };
> -
> -static int __init amikbd_init(void)
> -{
> -       return platform_driver_probe(&amikbd_driver, amikbd_probe);
> -}
> -
> -module_init(amikbd_init);
> -
> -static void __exit amikbd_exit(void)
> -{
> -       platform_driver_unregister(&amikbd_driver);
> -}
> -
> -module_exit(amikbd_exit);
> +module_platform_driver(amikbd_driver);
>
>  MODULE_ALIAS("platform:amiga-keyboard");

Sorry for not noticing before, but this is not correct.
Drivers using platform_driver_probe() typically don't fill in the
platform_driver.probe
method, as it's passed explicitly to platform_driver_probe() instead.
Hence amikbd_probe() is now referenced nowhere, and thus never called
(doesn't the compiler warn about amikbd_probe() being defined but unused?).

> diff --git a/drivers/input/keyboard/davinci_keyscan.c b/drivers/input/keyboard/davinci_keyscan.c
> index 9d82b3a..4698252 100644
> --- a/drivers/input/keyboard/davinci_keyscan.c
> +++ b/drivers/input/keyboard/davinci_keyscan.c
> @@ -328,18 +328,7 @@ static struct platform_driver davinci_ks_driver = {
>        },
>        .remove = __devexit_p(davinci_ks_remove),
>  };
> -
> -static int __init davinci_ks_init(void)
> -{
> -       return platform_driver_probe(&davinci_ks_driver, davinci_ks_probe);
> -}
> -module_init(davinci_ks_init);
> -
> -static void __exit davinci_ks_exit(void)
> -{
> -       platform_driver_unregister(&davinci_ks_driver);
> -}
> -module_exit(davinci_ks_exit);
> +module_platform_driver(davinci_ks_driver);
>
>  MODULE_AUTHOR("Miguel Aguilar");
>  MODULE_DESCRIPTION("Texas Instruments DaVinci Key Scan Driver");

Same here, I think.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
