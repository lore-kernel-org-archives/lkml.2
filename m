Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282Ab0JFRQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 13:16:09 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58882 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab0JFRQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 13:16:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=upqYLXpmZoltOJW5XdfKLTjzLhgdSzjai/yreOwplGlTjLPyrw6DT6yrXdBYQfLpNm
         xNT791Qf8wVxOYH6ucyO5jrBDPRYmKPP1jHCPpXcRoS8LPRAhb1jSr3l059shP5NHBz5
         4vYH9tmd26FyM3fpfdWol/yOk9UyCMvVSvuwY=
MIME-Version: 1.0
In-Reply-To: <1280555108-27994-1-git-send-email-marek.vasut@gmail.com>
References: <1280555108-27994-1-git-send-email-marek.vasut@gmail.com>
Date: Wed, 6 Oct 2010 19:16:05 +0200
Message-ID: <AANLkTindRMOmo8CrFuUsWqNRn6CZVKOMQZS2LXJ63=YC@mail.gmail.com>
Subject: Re: [PATCH] Input: Make ADS7846 independent on regulator
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, dmitry.torokhov@gmail.com,
        vapier@gentoo.org, pavel@ucw.cz, akpm@linux-foundation.org,
        khilman@deeprootsystems.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.y.miao@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/31 Marek Vasut <marek.vasut@gmail.com>:

> This fixes a problem on some Sharp Zaurus devices, where there is no regulator
> present and yet the touchscreen is used.
>
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> ---
>  drivers/input/touchscreen/ads7846.c |   50 +++++++++++++++++++++++------------
>  1 files changed, 33 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
> index a9fdf55..dafaef6 100644
> --- a/drivers/input/touchscreen/ads7846.c
> +++ b/drivers/input/touchscreen/ads7846.c
> @@ -791,7 +791,10 @@ static void ads7846_disable(struct ads7846 *ts)
>                }
>        }
>
> -       regulator_disable(ts->reg);
> +#ifdef CONFIG_REGULATOR

Skip the #ifdef, if the regulators are configured out, there will be
a stub providing NULL for all get_regulator() calls anyway.

> +       if (ts->reg)
> +               regulator_disable(ts->reg);
> +#endif
>
>        /* we know the chip's in lowpower mode since we always
>         * leave it that way after every request
> @@ -804,7 +807,10 @@ static void ads7846_enable(struct ads7846 *ts)
>        if (!ts->disabled)
>                return;
>
> -       regulator_enable(ts->reg);
> +#ifdef CONFIG_REGULATOR

Skip the #ifdef.

> +       if (ts->reg)
> +               regulator_enable(ts->reg);
> +#endif
>
>        ts->disabled = 0;
>        ts->irq_disabled = 0;
> @@ -1161,18 +1167,21 @@ static int __devinit ads7846_probe(struct spi_device *spi)
>
>        ts->last_msg = m;
>
> +#ifdef CONFIG_REGULATOR

Skip the #ifdef.

>        ts->reg = regulator_get(&spi->dev, "vcc");
> -       if (IS_ERR(ts->reg)) {
> -               err = PTR_ERR(ts->reg);
> -               dev_err(&spi->dev, "unable to get regulator: %d\n", err);
> -               goto err_free_gpio;
> -       }
> -
> -       err = regulator_enable(ts->reg);
> -       if (err) {
> -               dev_err(&spi->dev, "unable to enable regulator: %d\n", err);
> -               goto err_put_regulator;
> +       if (IS_ERR(ts->reg))
> +               ts->reg = NULL;
> +       else {
> +               err = regulator_enable(ts->reg);
> +               if (err) {
> +                       dev_err(&spi->dev, "unable to enable regulator: %d\n",
> +                               err);
> +                       goto err_put_regulator;
> +               }
>        }
> +#else
> +       ts->reg = NULL;
> +#endif

Delete the #else/#endif clause entirely.

>
>        if (request_irq(spi->irq, ads7846_irq, IRQF_TRIGGER_FALLING,
>                        spi->dev.driver->name, ts)) {
> @@ -1218,10 +1227,13 @@ static int __devinit ads7846_probe(struct spi_device *spi)
>  err_free_irq:
>        free_irq(spi->irq, ts);
>  err_disable_regulator:
> -       regulator_disable(ts->reg);
> +#ifdef CONFIG_REGULATOR

Skip the #ifdef.

> +       if (ts->reg)
> +               regulator_disable(ts->reg);
>  err_put_regulator:
> -       regulator_put(ts->reg);
> - err_free_gpio:
> +       if (ts->reg)
> +               regulator_put(ts->reg);
> +#endif
>        if (ts->gpio_pendown != -1)
>                gpio_free(ts->gpio_pendown);
>  err_cleanup_filter:
> @@ -1251,8 +1263,12 @@ static int __devexit ads7846_remove(struct spi_device *spi)
>        /* suspend left the IRQ disabled */
>        enable_irq(ts->spi->irq);
>
> -       regulator_disable(ts->reg);
> -       regulator_put(ts->reg);
> +#ifdef CONFIG_REGULATOR

Skip the #ifdef.

> +       if (ts->reg) {
> +               regulator_disable(ts->reg);
> +               regulator_put(ts->reg);
> +       }
> +#endif
>
>        if (ts->gpio_pendown != -1)
>                gpio_free(ts->gpio_pendown);
> --
> 1.7.1

Yours,
Linus Walleij
