Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab2GEQpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:45:20 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:32179 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2GEQpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:45:19 -0400
Message-ID: <1341506716.2605.8.camel@lorien2>
Subject: Re: [PATCH 22/25] leds: convert GPIO LED trigger driver to
 devm_kzalloc() and cleanup error exit path
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Bryan Wu <bryan.wu@canonical.com>
Cc: shuahkhan@gmail.com, linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Date: Thu, 05 Jul 2012 10:45:16 -0600
In-Reply-To: <1341378617-10386-23-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
	 <1341378617-10386-23-git-send-email-bryan.wu@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 13:10 +0800, Bryan Wu wrote:
> Cc: Felipe Balbi <me@felipebalbi.com>
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> ---
>  drivers/leds/ledtrig-gpio.c |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/leds/ledtrig-gpio.c b/drivers/leds/ledtrig-gpio.c
> index ba215dc..39bd8e4 100644
> --- a/drivers/leds/ledtrig-gpio.c
> +++ b/drivers/leds/ledtrig-gpio.c
> @@ -181,13 +181,13 @@ static void gpio_trig_activate(struct led_classdev *led)
>  	struct gpio_trig_data *gpio_data;
>  	int ret;
>  
> -	gpio_data = kzalloc(sizeof(*gpio_data), GFP_KERNEL);
> +	gpio_data = devm_kzalloc(led->dev, sizeof(*gpio_data), GFP_KERNEL);
>  	if (!gpio_data)
>  		return;
>  
>  	ret = device_create_file(led->dev, &dev_attr_gpio);
>  	if (ret)
> -		goto err_gpio;
> +		return;
>  
>  	ret = device_create_file(led->dev, &dev_attr_inverted);
>  	if (ret)
> @@ -209,9 +209,6 @@ err_brightness:
>  
>  err_inverted:
>  	device_remove_file(led->dev, &dev_attr_gpio);
> -
> -err_gpio:
> -	kfree(gpio_data);
>  }
>  
>  static void gpio_trig_deactivate(struct led_classdev *led)
> @@ -225,7 +222,6 @@ static void gpio_trig_deactivate(struct led_classdev *led)
>  		flush_work(&gpio_data->work);
>  		if (gpio_data->gpio != 0)
>  			free_irq(gpio_to_irq(gpio_data->gpio), led);
> -		kfree(gpio_data);
>  		led->activated = false;
>  	}
>  }

Bryan,

I don't believe memory triggers allocate in their activate routine
should be converted to devm_kzalloc(). Based on my understanding, the
memory allocated using devm_kzalloc() us free'ed when driver is
detached. In the case of led triggers, driver stays registered while the
triggers it supports can be activated and deactivated many times. By
converting these allocations into devm_kzalloc()s could lead to memory
leaks. Please correct me if my understanding is incorrect.

If what I am saying makes sense, please take this as comment that is
applicable to all led triggers, not just this one.

Thanks,
-- Shuah



