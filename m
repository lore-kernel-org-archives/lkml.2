Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688Ab2GDHf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:35:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49250 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2GDHfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:35:55 -0400
MIME-Version: 1.0
In-Reply-To: <1341378617-10386-7-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com> <1341378617-10386-7-git-send-email-bryan.wu@canonical.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 4 Jul 2012 15:35:34 +0800
X-Google-Sender-Auth: 8Ou-pSmADn3WZGZvaZed4ln_J84
Message-ID: <CAK5ve-+nuv4_GsUhxCV3r+OLJV4nhAgUpGthhVYRxsircXLpxg@mail.gmail.com>
Subject: Re: [PATCH 06/25] leds: convert LP5521 LED driver to devm_kzalloc()
 and cleanup error exit path
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 1:09 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> ---
>  drivers/leds/leds-lp5521.c |   18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
> index 2381562..760d743 100644
> --- a/drivers/leds/leds-lp5521.c
> +++ b/drivers/leds/leds-lp5521.c
> @@ -744,7 +744,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
>         int ret, i, led;
>         u8 buf;
>
> -       chip = kzalloc(sizeof(*chip), GFP_KERNEL);
> +       chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
>         if (!chip)
>                 return -ENOMEM;
>
> @@ -755,8 +755,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
>
>         if (!pdata) {
>                 dev_err(&client->dev, "no platform data\n");
> -               ret = -EINVAL;
> -               goto fail1;
> +               return -EINVAL;
>         }
>
>         mutex_init(&chip->lock);
> @@ -766,7 +765,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
>         if (pdata->setup_resources) {
>                 ret = pdata->setup_resources();
>                 if (ret < 0)
> -                       goto fail1;
> +                       return ret;
>         }
>
>         if (pdata->enable) {
> @@ -807,7 +806,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
>         ret = lp5521_configure(client);
>         if (ret < 0) {
>                 dev_err(&client->dev, "error configuring chip\n");
> -               goto fail2;
> +               goto fail1;
>         }
>
>         /* Initialize leds */
> @@ -840,21 +839,19 @@ static int __devinit lp5521_probe(struct i2c_client *client,
>         ret = lp5521_register_sysfs(client);
>         if (ret) {
>                 dev_err(&client->dev, "registering sysfs failed\n");
> -               goto fail3;
> +               goto fail2;
>         }
>         return ret;
> -fail3:
> +fail2:

Missed to change one 'fail3' to 'fail2', I've put the right version in
my devel branch.

Thanks,
-Bryan

>         for (i = 0; i < chip->num_leds; i++) {
>                 led_classdev_unregister(&chip->leds[i].cdev);
>                 cancel_work_sync(&chip->leds[i].brightness_work);
>         }
> -fail2:
> +fail1:
>         if (pdata->enable)
>                 pdata->enable(0);
>         if (pdata->release_resources)
>                 pdata->release_resources();
> -fail1:
> -       kfree(chip);
>         return ret;
>  }
>
> @@ -875,7 +872,6 @@ static int __devexit lp5521_remove(struct i2c_client *client)
>                 chip->pdata->enable(0);
>         if (chip->pdata->release_resources)
>                 chip->pdata->release_resources();
> -       kfree(chip);
>         return 0;
>  }
>
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-leds" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
