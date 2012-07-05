Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280Ab2GEQqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:46:24 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:32670 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab2GEQqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:46:22 -0400
Message-ID: <1341506780.2605.9.camel@lorien2>
Subject: Re: [PATCH 23/25] leds: convert Backlight emulation LED trigger
 driver to devm_kzalloc() and cleanup error exit path
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Bryan Wu <bryan.wu@canonical.com>
Cc: shuahkhan@gmail.com, linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Date: Thu, 05 Jul 2012 10:46:20 -0600
In-Reply-To: <1341378617-10386-24-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
	 <1341378617-10386-24-git-send-email-bryan.wu@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 13:10 +0800, Bryan Wu wrote:
> Cc: Rodolfo Giometti <giometti@linux.it>
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> ---
>  drivers/leds/ledtrig-backlight.c |   10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/leds/ledtrig-backlight.c b/drivers/leds/ledtrig-backlight.c
> index b941685..3fa20a9 100644
> --- a/drivers/leds/ledtrig-backlight.c
> +++ b/drivers/leds/ledtrig-backlight.c
> @@ -101,7 +101,8 @@ static void bl_trig_activate(struct led_classdev *led)
>  
>  	struct bl_trig_notifier *n;
>  
> -	n = kzalloc(sizeof(struct bl_trig_notifier), GFP_KERNEL);
> +	n = devm_kzalloc(led->dev, sizeof(struct bl_trig_notifier),
> +			GFP_KERNEL);
>  	led->trigger_data = n;
>  	if (!n) {
>  		dev_err(led->dev, "unable to allocate backlight trigger\n");
> @@ -110,7 +111,7 @@ static void bl_trig_activate(struct led_classdev *led)
>  
>  	ret = device_create_file(led->dev, &dev_attr_inverted);
>  	if (ret)
> -		goto err_invert;
> +		led->trigger_data = NULL;
>  
>  	n->led = led;
>  	n->brightness = led->brightness;
> @@ -123,10 +124,6 @@ static void bl_trig_activate(struct led_classdev *led)
>  	led->activated = true;
>  
>  	return;
> -
> -err_invert:
> -	led->trigger_data = NULL;
> -	kfree(n);
>  }
>  
>  static void bl_trig_deactivate(struct led_classdev *led)
> @@ -137,7 +134,6 @@ static void bl_trig_deactivate(struct led_classdev *led)
>  	if (led->activated) {
>  		device_remove_file(led->dev, &dev_attr_inverted);
>  		fb_unregister_client(&n->notifier);
> -		kfree(n);
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

