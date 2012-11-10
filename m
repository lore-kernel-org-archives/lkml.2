Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab2KJBs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:48:59 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38093 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab2KJBsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:48:55 -0500
MIME-Version: 1.0
In-Reply-To: <1352288570-32565-1-git-send-email-peter.ujfalusi@ti.com>
References: <1352288570-32565-1-git-send-email-peter.ujfalusi@ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Fri, 9 Nov 2012 17:48:33 -0800
Message-ID: <CAK5ve-LdyKk-5-J+Fn67CXVoox8rw+=UH0Wbq443rmN-yEyv4w@mail.gmail.com>
Subject: Re: [PATCH] leds: leds-pwm: Convert to use devm_get_pwm
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Luotao Fu <l.fu@pengutronix.de>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 3:42 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Update the driver to use the new API for requesting pwm so we can take
> advantage of the pwm_lookup table to find the correct pwm to be used for the
> LED functionality.
> If the devm_get_pwm fails we fall back to legacy mode to try to get the pwm.
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/leds/leds-pwm.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
> index f2e44c7..6bf9445 100644
> --- a/drivers/leds/leds-pwm.c
> +++ b/drivers/leds/leds-pwm.c
> @@ -47,6 +47,19 @@ static void led_pwm_set(struct led_classdev *led_cdev,
>         }
>  }
>
> +static struct pwm_device *led_pwm_request_pwm(struct platform_device *pdev,
> +                                             struct led_pwm *cur_led)
> +{
> +       struct pwm_device *pwm;
> +
> +       pwm = devm_pwm_get(&pdev->dev, cur_led->name);
> +       if (IS_ERR(pwm)) {
> +               dev_err(&pdev->dev, "unable to request PWM, trying legacy API\n");
> +               pwm = pwm_request(cur_led->pwm_id, cur_led->name);

Looks good, but why we still need to keep the old API pwm_request(),
if devm_pwm_get() is the right replacement. AFAIK, devm_***() API will
help to clean up if device probing fails.

So if it is good enough, we can just replace pwm_request() to the devm_pwm_get()

Thanks,
-Bryan

> +       }
> +       return pwm;
> +}
> +
>  static int led_pwm_probe(struct platform_device *pdev)
>  {
>         struct led_pwm_platform_data *pdata = pdev->dev.platform_data;
> @@ -67,8 +80,7 @@ static int led_pwm_probe(struct platform_device *pdev)
>                 cur_led = &pdata->leds[i];
>                 led_dat = &leds_data[i];
>
> -               led_dat->pwm = pwm_request(cur_led->pwm_id,
> -                               cur_led->name);
> +               led_dat->pwm = led_pwm_request_pwm(pdev, cur_led);
>                 if (IS_ERR(led_dat->pwm)) {
>                         ret = PTR_ERR(led_dat->pwm);
>                         dev_err(&pdev->dev, "unable to request PWM %d\n",
> --
> 1.8.0
>
