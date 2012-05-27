Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab2E0QNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 12:13:50 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:43114 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab2E0QNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 12:13:48 -0400
Message-ID: <1338135226.2968.22.camel@lorien2>
Subject: Re: [PATCH v2 1/3] leds: add oneshot blink functions
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Fabio Baltieri <fabio.baltieri@gmail.com>,
        Bryan Wu <bryan.wu@canonical.com>
Cc: shuahkhan@gmail.com, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Date: Sun, 27 May 2012 10:13:46 -0600
In-Reply-To: <1338074364-1829-1-git-send-email-fabio.baltieri@gmail.com>
References: <1338074364-1829-1-git-send-email-fabio.baltieri@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-27 at 01:19 +0200, Fabio Baltieri wrote:
> Add two new functions, led_blink_set_oneshot and
> led_trigger_blink_oneshot, to be used by triggers for one-shot blink of
> led devices.
> 
> This is implemented extending the existing software-blink code, and uses
> the same timer and handler function.
> 
> The behavior of the code is to do a blink-on, blink-off sequence when
> the function is called, ignoring other calls until the sequence is
> completed so that the leds keep blinking at constant rate if the
> functions are called repeatedly.
> 
> This is meant to be used by drivers which needs to trigger on sporadic
> event, but doesn't have clear busy/idle trigger points.
> 
> After the blink sequence the led remains off. This behavior can be
> inverted setting the "invert" argument, which blink the led off, than on
> and leave the led on after the sequence.
> 
> Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
> Cc: Bryan Wu <bryan.wu@canonical.com>
> ---
> 
> Same patch as v1 but rebased on Bryan's linux-leds tree.

Fabio/Bryan,

Please take a look at linux-next. I am concerned that this work
conflicts with LEDS_TRIGGER_TIMER implementation. Anyways using
linux-next is more appropriate here, as there were a few patches that
went in while Andrew Morton was acting as a maintainer for leds
sub-system.

-- Shuah
> 
> More info in original thread:
> http://marc.info/?l=linux-kernel&m=133763247601381&w=2
> 
> Tested on an x86 system with a custom usb-led device (http://wp.me/p1M1k7-fZ
> for the curious).
> 
> Fabio
> 
>  drivers/leds/led-class.c    | 19 +++++++++++++++++
>  drivers/leds/led-core.c     | 50 ++++++++++++++++++++++++++++++++++-----------
>  drivers/leds/led-triggers.c | 30 +++++++++++++++++++++++----
>  include/linux/leds.h        | 25 +++++++++++++++++++++++
>  4 files changed, 108 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index 5bff843..42d9359 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -91,6 +91,11 @@ static void led_timer_function(unsigned long data)
>  		return;
>  	}
>  
> +	if (led_cdev->flags & LED_BLINK_ONESHOT_STOP) {
> +		led_cdev->flags &= ~LED_BLINK_ONESHOT_STOP;
> +		return;
> +	}
> +
>  	brightness = led_get_brightness(led_cdev);
>  	if (!brightness) {
>  		/* Time to switch the LED on. */
> @@ -107,6 +112,20 @@ static void led_timer_function(unsigned long data)
>  
>  	led_set_brightness(led_cdev, brightness);
>  
> +	/* Return in next iteration if led is in one-shot mode and we are in
> +	 * the final blink state so that the led is toggled each delay_on +
> +	 * delay_off milliseconds in worst case.
> +	 */
> +	if (led_cdev->flags & LED_BLINK_ONESHOT) {
> +		if (led_cdev->flags & LED_BLINK_INVERT) {
> +			if (brightness)
> +				led_cdev->flags |= LED_BLINK_ONESHOT_STOP;
> +		} else {
> +			if (!brightness)
> +				led_cdev->flags |= LED_BLINK_ONESHOT_STOP;
> +		}
> +	}
> +
>  	mod_timer(&led_cdev->blink_timer, jiffies + msecs_to_jiffies(delay));
>  }
>  
> diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
> index d686004..579eb78 100644
> --- a/drivers/leds/led-core.c
> +++ b/drivers/leds/led-core.c
> @@ -27,7 +27,6 @@ EXPORT_SYMBOL_GPL(leds_list);
>  static void led_stop_software_blink(struct led_classdev *led_cdev)
>  {
>  	/* deactivate previous settings */
> -	del_timer_sync(&led_cdev->blink_timer);
>  	led_cdev->blink_delay_on = 0;
>  	led_cdev->blink_delay_off = 0;
>  }
> @@ -44,11 +43,6 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
>  	if (!led_cdev->blink_brightness)
>  		led_cdev->blink_brightness = led_cdev->max_brightness;
>  
> -	if (led_get_trigger_data(led_cdev) &&
> -	    delay_on == led_cdev->blink_delay_on &&
> -	    delay_off == led_cdev->blink_delay_off)
> -		return;
> -
>  	led_stop_software_blink(led_cdev);
>  
>  	led_cdev->blink_delay_on = delay_on;
> @@ -68,13 +62,12 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
>  }
>  
> 
> -void led_blink_set(struct led_classdev *led_cdev,
> -		   unsigned long *delay_on,
> -		   unsigned long *delay_off)
> +void led_blink_setup(struct led_classdev *led_cdev,
> +		     unsigned long *delay_on,
> +		     unsigned long *delay_off)
>  {
> -	del_timer_sync(&led_cdev->blink_timer);
> -
> -	if (led_cdev->blink_set &&
> +	if (!(led_cdev->flags & LED_BLINK_ONESHOT) &&
> +	    led_cdev->blink_set &&
>  	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
>  		return;
>  
> @@ -84,8 +77,41 @@ void led_blink_set(struct led_classdev *led_cdev,
>  
>  	led_set_software_blink(led_cdev, *delay_on, *delay_off);
>  }
> +
> +void led_blink_set(struct led_classdev *led_cdev,
> +		   unsigned long *delay_on,
> +		   unsigned long *delay_off)
> +{
> +	del_timer_sync(&led_cdev->blink_timer);
> +
> +	led_cdev->flags &= ~LED_BLINK_ONESHOT;
> +	led_cdev->flags &= ~LED_BLINK_ONESHOT_STOP;
> +
> +	led_blink_setup(led_cdev, delay_on, delay_off);
> +}
>  EXPORT_SYMBOL(led_blink_set);
>  
> +void led_blink_set_oneshot(struct led_classdev *led_cdev,
> +			   unsigned long *delay_on,
> +			   unsigned long *delay_off,
> +			   int invert)
> +{
> +	if ((led_cdev->flags & LED_BLINK_ONESHOT) &&
> +	     timer_pending(&led_cdev->blink_timer))
> +		return;
> +
> +	led_cdev->flags |= LED_BLINK_ONESHOT;
> +	led_cdev->flags &= ~LED_BLINK_ONESHOT_STOP;
> +
> +	if (invert)
> +		led_cdev->flags |= LED_BLINK_INVERT;
> +	else
> +		led_cdev->flags &= ~LED_BLINK_INVERT;
> +
> +	led_blink_setup(led_cdev, delay_on, delay_off);
> +}
> +EXPORT_SYMBOL(led_blink_set_oneshot);
> +
>  void led_brightness_set(struct led_classdev *led_cdev,
>  			enum led_brightness brightness)
>  {
> diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
> index b449ed8..fa0b9be 100644
> --- a/drivers/leds/led-triggers.c
> +++ b/drivers/leds/led-triggers.c
> @@ -230,9 +230,11 @@ void led_trigger_event(struct led_trigger *trig,
>  }
>  EXPORT_SYMBOL_GPL(led_trigger_event);
>  
> -void led_trigger_blink(struct led_trigger *trig,
> -		       unsigned long *delay_on,
> -		       unsigned long *delay_off)
> +void led_trigger_blink_setup(struct led_trigger *trig,
> +			     unsigned long *delay_on,
> +			     unsigned long *delay_off,
> +			     int oneshot,
> +			     int invert)
>  {
>  	struct list_head *entry;
>  
> @@ -244,12 +246,32 @@ void led_trigger_blink(struct led_trigger *trig,
>  		struct led_classdev *led_cdev;
>  
>  		led_cdev = list_entry(entry, struct led_classdev, trig_list);
> -		led_blink_set(led_cdev, delay_on, delay_off);
> +		if (oneshot)
> +			led_blink_set_oneshot(led_cdev, delay_on, delay_off,
> +					      invert);
> +		else
> +			led_blink_set(led_cdev, delay_on, delay_off);
>  	}
>  	read_unlock(&trig->leddev_list_lock);
>  }
> +
> +void led_trigger_blink(struct led_trigger *trig,
> +		       unsigned long *delay_on,
> +		       unsigned long *delay_off)
> +{
> +	led_trigger_blink_setup(trig, delay_on, delay_off, 0, 0);
> +}
>  EXPORT_SYMBOL_GPL(led_trigger_blink);
>  
> +void led_trigger_blink_oneshot(struct led_trigger *trig,
> +			       unsigned long *delay_on,
> +			       unsigned long *delay_off,
> +			       int invert)
> +{
> +	led_trigger_blink_setup(trig, delay_on, delay_off, 1, invert);
> +}
> +EXPORT_SYMBOL_GPL(led_trigger_blink_oneshot);
> +
>  void led_trigger_register_simple(const char *name, struct led_trigger **tp)
>  {
>  	struct led_trigger *trig;
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 5884def..f252438 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -38,6 +38,9 @@ struct led_classdev {
>  #define LED_SUSPENDED		(1 << 0)
>  	/* Upper 16 bits reflect control information */
>  #define LED_CORE_SUSPENDRESUME	(1 << 16)
> +#define LED_BLINK_ONESHOT	(1 << 17)
> +#define LED_BLINK_ONESHOT_STOP	(1 << 18)
> +#define LED_BLINK_INVERT	(1 << 19)
>  
>  	/* Set LED brightness level */
>  	/* Must not sleep, use a workqueue if needed */
> @@ -101,6 +104,24 @@ extern void led_blink_set(struct led_classdev *led_cdev,
>  			  unsigned long *delay_on,
>  			  unsigned long *delay_off);
>  /**
> + * led_blink_set_oneshot - do a oneshot software blink
> + * @led_cdev: the LED to start blinking
> + * @delay_on: the time it should be on (in ms)
> + * @delay_off: the time it should ble off (in ms)
> + * @invert: blink off, then on, leaving the led on
> + *
> + * This function makes the LED blink one time for delay_on +
> + * delay_off time, ignoring the request if another one-shot
> + * blink is already in progress.
> + *
> + * If invert is set, led blinks for delay_off first, then for
> + * delay_on and leave the led on after the on-off cycle.
> + */
> +extern void led_blink_set_oneshot(struct led_classdev *led_cdev,
> +				  unsigned long *delay_on,
> +				  unsigned long *delay_off,
> +				  int invert);
> +/**
>   * led_brightness_set - set LED brightness
>   * @led_cdev: the LED to set
>   * @brightness: the brightness to set it to
> @@ -148,6 +169,10 @@ extern void led_trigger_event(struct led_trigger *trigger,
>  extern void led_trigger_blink(struct led_trigger *trigger,
>  			      unsigned long *delay_on,
>  			      unsigned long *delay_off);
> +extern void led_trigger_blink_oneshot(struct led_trigger *trigger,
> +				      unsigned long *delay_on,
> +				      unsigned long *delay_off,
> +				      int invert);
>  
>  #else
>  


