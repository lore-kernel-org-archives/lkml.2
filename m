Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151Ab2EZGnK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 02:43:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44856 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2EZGnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 02:43:08 -0400
MIME-Version: 1.0
In-Reply-To: <001701cd3a1e$69c59a00$3d50ce00$%han@samsung.com>
References: <001701cd3a1e$69c59a00$3d50ce00$%han@samsung.com>
Date: Sat, 26 May 2012 10:43:07 +0400
Message-ID: <CALT56yMro+2KPHPNdT4F+DdAjiK2e3QRUrx3CV8dVaoLhXa1Rw@mail.gmail.com>
Subject: Re: [PATCH 12/13] backlight: tosa_bl: use devm_ functions
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 6:30 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> The devm_ functions allocate memory that is released when a driver
> detaches. This patch uses devm_kzalloc of these functions.

Strictly speaking I see no point in this changes. There are no
'missing free' problems
in these drivers, the code path is clean enough. Is devm_kzalloc usage some kind
of policy, or it is just a future-proof change?

>
> Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/tosa_bl.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/video/backlight/tosa_bl.c b/drivers/video/backlight/tosa_bl.c
> index 2b241ab..0d54e60 100644
> --- a/drivers/video/backlight/tosa_bl.c
> +++ b/drivers/video/backlight/tosa_bl.c
> @@ -82,8 +82,11 @@ static int __devinit tosa_bl_probe(struct i2c_client *client,
>                const struct i2c_device_id *id)
>  {
>        struct backlight_properties props;
> -       struct tosa_bl_data *data = kzalloc(sizeof(struct tosa_bl_data), GFP_KERNEL);
> +       struct tosa_bl_data *data;
>        int ret = 0;
> +
> +       data = devm_kzalloc(&client->dev, sizeof(struct tosa_bl_data),
> +                               GFP_KERNEL);
>        if (!data)
>                return -ENOMEM;
>
> @@ -92,7 +95,7 @@ static int __devinit tosa_bl_probe(struct i2c_client *client,
>        ret = gpio_request(TOSA_GPIO_BL_C20MA, "backlight");
>        if (ret) {
>                dev_dbg(&data->bl->dev, "Unable to request gpio!\n");
> -               goto err_gpio_bl;
> +               return ret;
>        }
>        ret = gpio_direction_output(TOSA_GPIO_BL_C20MA, 0);
>        if (ret)
> @@ -122,8 +125,6 @@ err_reg:
>        data->bl = NULL;
>  err_gpio_dir:
>        gpio_free(TOSA_GPIO_BL_C20MA);
> -err_gpio_bl:
> -       kfree(data);
>        return ret;
>  }
>
> @@ -136,8 +137,6 @@ static int __devexit tosa_bl_remove(struct i2c_client *client)
>
>        gpio_free(TOSA_GPIO_BL_C20MA);
>
> -       kfree(data);
> -
>        return 0;
>  }
>
> --
> 1.7.1
>
>



-- 
With best wishes
Dmitry
