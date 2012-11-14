Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab2KNBOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:14:43 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:64542 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab2KNBOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:14:41 -0500
MIME-Version: 1.0
In-Reply-To: <1352731270-27534-2-git-send-email-peter.ujfalusi@ti.com>
References: <1352731270-27534-1-git-send-email-peter.ujfalusi@ti.com> <1352731270-27534-2-git-send-email-peter.ujfalusi@ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 13 Nov 2012 17:14:20 -0800
Message-ID: <CAK5ve-JDCSSOKHQG-F1RoDii62=-DiPevaD6SafndYVvOgB6Fw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] leds: leds-pwm: Convert to use devm_get_pwm
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 6:41 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Update the driver to use the new API for requesting pwm so we can take
> advantage of the pwm_lookup table to find the correct pwm to be used for the
> LED functionality.
> If the devm_get_pwm fails we fall back to legacy mode to try to get the pwm.
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/leds/leds-pwm.c  | 19 ++++++-------------
>  include/linux/leds_pwm.h |  2 +-
>  2 files changed, 7 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
> index f2e44c7..c953c75 100644
> --- a/drivers/leds/leds-pwm.c
> +++ b/drivers/leds/leds-pwm.c
> @@ -67,12 +67,11 @@ static int led_pwm_probe(struct platform_device *pdev)
>                 cur_led = &pdata->leds[i];
>                 led_dat = &leds_data[i];
>
> -               led_dat->pwm = pwm_request(cur_led->pwm_id,
> -                               cur_led->name);
> +               led_dat->pwm = devm_pwm_get(&pdev->dev, cur_led->name);
>                 if (IS_ERR(led_dat->pwm)) {
>                         ret = PTR_ERR(led_dat->pwm);
> -                       dev_err(&pdev->dev, "unable to request PWM %d\n",
> -                                       cur_led->pwm_id);
> +                       dev_err(&pdev->dev, "unable to request PWM for %s\n",
> +                               cur_led->name);
>                         goto err;
>                 }
>
> @@ -86,10 +85,8 @@ static int led_pwm_probe(struct platform_device *pdev)
>                 led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
>
>                 ret = led_classdev_register(&pdev->dev, &led_dat->cdev);
> -               if (ret < 0) {
> -                       pwm_free(led_dat->pwm);
> +               if (ret < 0)
>                         goto err;
> -               }
>         }
>
>         platform_set_drvdata(pdev, leds_data);
> @@ -98,10 +95,8 @@ static int led_pwm_probe(struct platform_device *pdev)
>
>  err:
>         if (i > 0) {
> -               for (i = i - 1; i >= 0; i--) {
> +               for (i = i - 1; i >= 0; i--)
>                         led_classdev_unregister(&leds_data[i].cdev);
> -                       pwm_free(leds_data[i].pwm);
> -               }
>         }
>
>         return ret;
> @@ -115,10 +110,8 @@ static int __devexit led_pwm_remove(struct platform_device *pdev)
>
>         leds_data = platform_get_drvdata(pdev);
>
> -       for (i = 0; i < pdata->num_leds; i++) {
> +       for (i = 0; i < pdata->num_leds; i++)
>                 led_classdev_unregister(&leds_data[i].cdev);
> -               pwm_free(leds_data[i].pwm);
> -       }
>
>         return 0;
>  }
> diff --git a/include/linux/leds_pwm.h b/include/linux/leds_pwm.h
> index 33a0711..a65e964 100644
> --- a/include/linux/leds_pwm.h
> +++ b/include/linux/leds_pwm.h
> @@ -7,7 +7,7 @@
>  struct led_pwm {
>         const char      *name;
>         const char      *default_trigger;
> -       unsigned        pwm_id;
> +       unsigned        pwm_id __deprecated;

I suggest we remove this later, we can provide patches from this from
platform data of board file. And I think this patch is good for me to
merge, will do it soon.

Thanks,
-Bryan

>         u8              active_low;
>         unsigned        max_brightness;
>         unsigned        pwm_period_ns;
> --
> 1.8.0
>
