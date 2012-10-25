Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965415Ab2JYIEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:04:00 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51952 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934104Ab2JYID4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 04:03:56 -0400
Date: Thu, 25 Oct 2012 16:03:49 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Thierry Reding <thierry.reding@avionic-design.de>, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH] RFC: leds-pwm: don't disable pwm when setting brightness
 to 0
Message-ID: <20121025080346.GB9921@S2101-09.ap.freescale.net>
References: <20121024095603.GH639@pengutronix.de>
 <1351086766-5837-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1351086766-5837-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 03:52:46PM +0200, Uwe Kleine-König wrote:
> This fixes disabling the LED on i.MX28. The PWM hardware delays using
> the newly set pwm-config until the beginning of a new period.  It's very
> likely that pwm_disable is called before the current period ends. In
> case the LED was on brightness=max before the LED stays on because in
> the disabled PWM block the period never ends.
> 
> It's unclear if the mxs-pwm driver doesn't implement the API as expected
> (i.e. it should block until the newly set config is effective) or if the
> leds-pwm driver makes wrong assumptions. This patch assumes the latter.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> I'm not sure this is correct, but this is the workaround I'm using until
> I get some feed back.

I'm fine with it, since it fixes a real problem.  Let's see what
Thierry says.

Shawn

> 
> Best regards
> Uwe
> 
>  drivers/leds/leds-pwm.c |    9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
> index f2e44c7..a909f4f 100644
> --- a/drivers/leds/leds-pwm.c
> +++ b/drivers/leds/leds-pwm.c
> @@ -38,13 +38,8 @@ static void led_pwm_set(struct led_classdev *led_cdev,
>  	unsigned int max = led_dat->cdev.max_brightness;
>  	unsigned int period =  led_dat->period;
>  
> -	if (brightness == 0) {
> -		pwm_config(led_dat->pwm, 0, period);
> -		pwm_disable(led_dat->pwm);
> -	} else {
> -		pwm_config(led_dat->pwm, brightness * period / max, period);
> -		pwm_enable(led_dat->pwm);
> -	}
> +	pwm_config(led_dat->pwm, brightness * period / max, period);
> +	pwm_enable(led_dat->pwm);
>  }
>  
>  static int led_pwm_probe(struct platform_device *pdev)
> -- 
> 1.7.10.4
> 
