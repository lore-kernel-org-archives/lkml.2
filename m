Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab2GEQmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:42:55 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:30328 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab2GEQmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:42:53 -0400
Message-ID: <1341506570.2605.6.camel@lorien2>
Subject: Re: [PATCH 21/25] leds: convert transient LED trigger driver to
 devm_kzalloc()
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Bryan Wu <bryan.wu@canonical.com>
Cc: shuahkhan@gmail.com, linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Date: Thu, 05 Jul 2012 10:42:50 -0600
In-Reply-To: <1341378617-10386-22-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
	 <1341378617-10386-22-git-send-email-bryan.wu@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 13:10 +0800, Bryan Wu wrote:
> Cc: Shuah Khan <shuahkhan@gmail.com>
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> ---
>  drivers/leds/ledtrig-transient.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/leds/ledtrig-transient.c b/drivers/leds/ledtrig-transient.c
> index 398f104..8e30b0df 100644
> --- a/drivers/leds/ledtrig-transient.c
> +++ b/drivers/leds/ledtrig-transient.c
> @@ -161,7 +161,8 @@ static void transient_trig_activate(struct led_classdev *led_cdev)
>  	int rc;
>  	struct transient_trig_data *tdata;
>  
> -	tdata = kzalloc(sizeof(struct transient_trig_data), GFP_KERNEL);
> +	tdata = devm_kzalloc(led_cdev->dev,
> +		sizeof(struct transient_trig_data), GFP_KERNEL);
>  	if (!tdata) {
>  		dev_err(led_cdev->dev,
>  			"unable to allocate transient trigger\n");
> @@ -194,7 +195,6 @@ err_out_duration:
>  err_out:
>  	dev_err(led_cdev->dev, "unable to register transient trigger\n");
>  	led_cdev->trigger_data = NULL;
> -	kfree(tdata);
>  }
>  
>  static void transient_trig_deactivate(struct led_classdev *led_cdev)
> @@ -209,7 +209,6 @@ static void transient_trig_deactivate(struct led_classdev *led_cdev)
>  		device_remove_file(led_cdev->dev, &dev_attr_state);
>  		led_cdev->trigger_data = NULL;
>  		led_cdev->activated = false;
> -		kfree(transient_data);
>  	}
>  }
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
appicable to all led triggers, not just this one.

Thanks,
-- Shuah




