Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339Ab2HJCS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 22:18:28 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36213 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab2HJCS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 22:18:26 -0400
MIME-Version: 1.0
In-Reply-To: <1344564512.2996.12.camel@phoenix>
References: <1344564512.2996.12.camel@phoenix>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Fri, 10 Aug 2012 10:18:04 +0800
X-Google-Sender-Auth: qaXrE8lfZPRrYi4_0MdFE-yvlWM
Message-ID: <CAK5ve-Lrkng-8jfZ5oggqKyu9Dd3GGJQWr3xQ28qm-A8kjjqBg@mail.gmail.com>
Subject: Re: [PATCH] leds: wm8350: Convert to devm_regulator_get()
To: Axel Lin <axel.lin@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, it's a good change. I've applied it to my for-next branch.

-Bryan

On Fri, Aug 10, 2012 at 10:08 AM, Axel Lin <axel.lin@gmail.com> wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/leds/leds-wm8350.c |   29 +++++++----------------------
>  1 file changed, 7 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/leds/leds-wm8350.c b/drivers/leds/leds-wm8350.c
> index 918d4ba..f5d9ac3 100644
> --- a/drivers/leds/leds-wm8350.c
> +++ b/drivers/leds/leds-wm8350.c
> @@ -201,7 +201,7 @@ static int wm8350_led_probe(struct platform_device *pdev)
>         struct regulator *isink, *dcdc;
>         struct wm8350_led *led;
>         struct wm8350_led_platform_data *pdata = pdev->dev.platform_data;
> -       int ret, i;
> +       int i;
>
>         if (pdata == NULL) {
>                 dev_err(&pdev->dev, "no platform data\n");
> @@ -214,24 +214,21 @@ static int wm8350_led_probe(struct platform_device *pdev)
>                 return -EINVAL;
>         }
>
> -       isink = regulator_get(&pdev->dev, "led_isink");
> +       isink = devm_regulator_get(&pdev->dev, "led_isink");
>         if (IS_ERR(isink)) {
>                 printk(KERN_ERR "%s: can't get ISINK\n", __func__);
>                 return PTR_ERR(isink);
>         }
>
> -       dcdc = regulator_get(&pdev->dev, "led_vcc");
> +       dcdc = devm_regulator_get(&pdev->dev, "led_vcc");
>         if (IS_ERR(dcdc)) {
>                 printk(KERN_ERR "%s: can't get DCDC\n", __func__);
> -               ret = PTR_ERR(dcdc);
> -               goto err_isink;
> +               return PTR_ERR(dcdc);
>         }
>
>         led = devm_kzalloc(&pdev->dev, sizeof(*led), GFP_KERNEL);
> -       if (led == NULL) {
> -               ret = -ENOMEM;
> -               goto err_dcdc;
> -       }
> +       if (led == NULL)
> +               return -ENOMEM;
>
>         led->cdev.brightness_set = wm8350_led_set;
>         led->cdev.default_trigger = pdata->default_trigger;
> @@ -257,17 +254,7 @@ static int wm8350_led_probe(struct platform_device *pdev)
>         led->value = LED_OFF;
>         platform_set_drvdata(pdev, led);
>
> -       ret = led_classdev_register(&pdev->dev, &led->cdev);
> -       if (ret < 0)
> -               goto err_dcdc;
> -
> -       return 0;
> -
> - err_dcdc:
> -       regulator_put(dcdc);
> - err_isink:
> -       regulator_put(isink);
> -       return ret;
> +       return led_classdev_register(&pdev->dev, &led->cdev);
>  }
>
>  static int wm8350_led_remove(struct platform_device *pdev)
> @@ -277,8 +264,6 @@ static int wm8350_led_remove(struct platform_device *pdev)
>         led_classdev_unregister(&led->cdev);
>         flush_work_sync(&led->work);
>         wm8350_led_disable(led);
> -       regulator_put(led->dcdc);
> -       regulator_put(led->isink);
>         return 0;
>  }
>
> --
> 1.7.9.5
>
>
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
