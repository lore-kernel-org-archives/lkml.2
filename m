Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395Ab2GEQrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:47:23 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:4792 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab2GEQrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:47:21 -0400
Message-ID: <1341506839.2605.11.camel@lorien2>
Subject: Re: [PATCH 25/25] leds: convert One-shot LED trigger driver to
 devm_kzalloc() and cleanup error exit path
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Bryan Wu <bryan.wu@canonical.com>
Cc: shuahkhan@gmail.com, linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Date: Thu, 05 Jul 2012 10:47:19 -0600
In-Reply-To: <1341378617-10386-26-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
	 <1341378617-10386-26-git-send-email-bryan.wu@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 13:10 +0800, Bryan Wu wrote:
> Cc: Fabio Baltieri <fabio.baltieri@gmail.com>
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> ---
>  drivers/leds/ledtrig-oneshot.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/leds/ledtrig-oneshot.c b/drivers/leds/ledtrig-oneshot.c
> index 2c029aa..6395a38 100644
> --- a/drivers/leds/ledtrig-oneshot.c
> +++ b/drivers/leds/ledtrig-oneshot.c
> @@ -127,7 +127,8 @@ static void oneshot_trig_activate(struct led_classdev *led_cdev)
>  	struct oneshot_trig_data *oneshot_data;
>  	int rc;
>  
> -	oneshot_data = kzalloc(sizeof(*oneshot_data), GFP_KERNEL);
> +	oneshot_data = devm_kzalloc(led_cdev->dev, sizeof(*oneshot_data),
> +				GFP_KERNEL);
>  	if (!oneshot_data)
>  		return;
>  
> @@ -135,7 +136,7 @@ static void oneshot_trig_activate(struct led_classdev *led_cdev)
>  
>  	rc = device_create_file(led_cdev->dev, &dev_attr_delay_on);
>  	if (rc)
> -		goto err_out_trig_data;
> +		return;
>  	rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
>  	if (rc)
>  		goto err_out_delayon;
> @@ -159,8 +160,6 @@ err_out_delayoff:
>  	device_remove_file(led_cdev->dev, &dev_attr_delay_off);
>  err_out_delayon:
>  	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
> -err_out_trig_data:
> -	kfree(led_cdev->trigger_data);
>  }
>  
>  static void oneshot_trig_deactivate(struct led_classdev *led_cdev)
> @@ -172,7 +171,6 @@ static void oneshot_trig_deactivate(struct led_classdev *led_cdev)
>  		device_remove_file(led_cdev->dev, &dev_attr_delay_off);
>  		device_remove_file(led_cdev->dev, &dev_attr_invert);
>  		device_remove_file(led_cdev->dev, &dev_attr_shot);
> -		kfree(oneshot_data);
>  		led_cdev->activated = false;
>  	}
>  
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

