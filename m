Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030183Ab2GEQq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:46:58 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:2181 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab2GEQq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:46:57 -0400
Message-ID: <1341506814.2605.10.camel@lorien2>
Subject: Re: [PATCH 24/25] leds: convert Heartbeat LED trigger driver to
 devm_kzalloc()
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Bryan Wu <bryan.wu@canonical.com>
Cc: shuahkhan@gmail.com, linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Date: Thu, 05 Jul 2012 10:46:54 -0600
In-Reply-To: <1341378617-10386-25-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
	 <1341378617-10386-25-git-send-email-bryan.wu@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 13:10 +0800, Bryan Wu wrote:
> Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> ---
>  drivers/leds/ledtrig-heartbeat.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/leds/ledtrig-heartbeat.c b/drivers/leds/ledtrig-heartbeat.c
> index d3039f2..5caa01b 100644
> --- a/drivers/leds/ledtrig-heartbeat.c
> +++ b/drivers/leds/ledtrig-heartbeat.c
> @@ -75,7 +75,8 @@ static void heartbeat_trig_activate(struct led_classdev *led_cdev)
>  {
>  	struct heartbeat_trig_data *heartbeat_data;
>  
> -	heartbeat_data = kzalloc(sizeof(*heartbeat_data), GFP_KERNEL);
> +	heartbeat_data = devm_kzalloc(led_cdev->dev, sizeof(*heartbeat_data),
> +				GFP_KERNEL);
>  	if (!heartbeat_data)
>  		return;
>  
> @@ -93,7 +94,6 @@ static void heartbeat_trig_deactivate(struct led_classdev *led_cdev)
>  
>  	if (led_cdev->activated) {
>  		del_timer_sync(&heartbeat_data->timer);
> -		kfree(heartbeat_data);
>  		led_cdev->activated = false;
>  	}
>  }
Bryan,
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

