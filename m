Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab2FKVi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 17:38:29 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:14821 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab2FKVi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 17:38:27 -0400
Message-ID: <1339450705.23857.16.camel@lorien2>
Subject: Re: [PATCH] leds: use led_brightness_set in led_trigger_event
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: shuahkhan@gmail.com, Bryan Wu <bryan.wu@canonical.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Date: Mon, 11 Jun 2012 15:38:25 -0600
In-Reply-To: <1339448260-1733-1-git-send-email-fabio.baltieri@gmail.com>
References: <1339448260-1733-1-git-send-email-fabio.baltieri@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 22:57 +0200, Fabio Baltieri wrote:
> Fix led_trigger_event() to use led_brightness_set() instead of
> led_set_brightness(), so that any pending blink timer is stopped before
> setting the new brightness value.  Without this fix LED status may be
> overridden by a pending timer.
> 
> This allows a trigger to use a mix of led_trigger_event(),
> led_trigger_blink() and led_trigger_blink_oneshot() without races.
> 
> Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
> Cc: Bryan Wu <bryan.wu@canonical.com>
> ---
> Hi Bryan,
> 
> I found this one while working on another patch but I think it's also needed by
> other drivers which mixes led_trigger_blink() and led_trigger_event(), such as
> power_supply_leds.
> 
> Without this a led don't stop blinking as it should when calling
> led_trigger_event().

Good find. This is very subtle race though because both timer and
oneshot triggers call led_brightness_set() from their deactivate
routines. Is this when these events triggered using oneshot trigger? 

> 
> Should not cause any harm on other drivers.
> 
> (I'm starting to find the whole led_set_brightness/led_brightness_set thing a
> bit confusing BTW...)

I agree with the names are confusing. :) It found it confusing as well.
Probably why we have this bug hiding until led_trigger_blink() came
along.

led_brightness_set() calls led_set_brightness(). led_set_brightness()
takes cares about whether the driver is in suspend state and invokes
driver's brightness_set interface. Maybe led_clear_blink_timer() would
be a better name for this led_brightness_set() routine.

I can volunteer to make this change if we agree that this will be a good
one to clear this naming confusion.

-- Shuah

> 
> Fabio
> 
>  drivers/leds/led-triggers.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
> index fa0b9be..b88d3b9 100644
> --- a/drivers/leds/led-triggers.c
> +++ b/drivers/leds/led-triggers.c
> @@ -224,7 +224,7 @@ void led_trigger_event(struct led_trigger *trig,
>  		struct led_classdev *led_cdev;
>  
>  		led_cdev = list_entry(entry, struct led_classdev, trig_list);
> -		led_set_brightness(led_cdev, brightness);
> +		led_brightness_set(led_cdev, brightness);

This is in-line with led_trigger_set() which is calling
led_bightness_set() correctly. Also led_classdev_unregister() calls it I
think for the same reason so the blink timer can be stopped.

>  	}
>  	read_unlock(&trig->leddev_list_lock);
>  }


