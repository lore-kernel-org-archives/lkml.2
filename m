Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2DCPGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 11:06:04 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:41728 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab2DCPGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 11:06:02 -0400
Message-ID: <1333465560.2369.5.camel@lorien2>
Subject: Re: [PATCH RESEND] LEDS-One-Shot-Timer-Trigger-implementation
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: akpm@linux-foundation.org
Cc: shuahkhan@gmail.com, neilb@suse.de, rpurdie@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 03 Apr 2012 09:06:00 -0600
In-Reply-To: <1333310039.2879.4.camel@lorien2>
References: <1333310039.2879.4.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

How about this patch?

-- Shuah

On Sun, 2012-04-01 at 13:53 -0600, Shuah Khan wrote:
> LED infrastructure lacks support for one shot timer trigger and activation.
> The current support allows for setting two timers, one for specifying how
> long a state to be on, and the second for how long the state to be off. For
> example, delay_on value specifies the time period an LED should stay in on
> state, followed by a delay_off value that specifies how long the LED should
> stay in off state. The on and off cycle repeats until the trigger gets
> deactivated. There is no provision for one time activation to implement
> features that require an on or off state to be held just once and then stay
> in the original state forever.
> 
> This feature will help implement vibrate functionality which requires one
> time activation of vibrate mode without a continuous vibrate on/off cycles.
> 
> From 1ebe0fd67580da833f8f06fc3119445e9991100f Mon Sep 17 00:00:00 2001
> From: Shuah Khan <shuahkhan@gmail.com>
> Date: Sat, 31 Mar 2012 21:56:07 -0600
> Subject: [PATCH] LEDS-One-Shot-Timer-Trigger-implementation
> 
> Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
> Reviewed-by: NeilBrown <neilb@suse.de>
> Cc: Richard Purdie <rpurdie@linux.intel.com>
> ---
>  Documentation/leds/leds-one-shot-timer.txt |   79 +++++++++++++++++++++
>  drivers/leds/led-class.c                   |    4 +-
>  drivers/leds/led-core.c                    |   26 ++++++-
>  drivers/leds/leds.h                        |    2 +
>  drivers/leds/ledtrig-timer.c               |  104 ++++++++++++++++++++--------
>  5 files changed, 180 insertions(+), 35 deletions(-)
>  create mode 100644 Documentation/leds/leds-one-shot-timer.txt
> 
> diff --git a/Documentation/leds/leds-one-shot-timer.txt b/Documentation/leds/leds-one-shot-timer.txt
> new file mode 100644
> index 0000000..a5429dd
> --- /dev/null
> +++ b/Documentation/leds/leds-one-shot-timer.txt
> @@ -0,0 +1,79 @@
> +
> +LED one shot timer feature
> +===========================
> +
> +LED infrastructure lacks support for one shot timer trigger and activation.
> +The current support allows for setting two timers, one for specifying how
> +long a state to be on, and the second for how long the state to be off. For
> +example, delay_on value specifies the time period an LED should stay in on
> +state, followed by a delay_off value that specifies how long the LED should
> +stay in off state. The on and off cycle repeats until the trigger gets
> +deactivated. There is no provision for one time activation to implement
> +features that require an on or off state to be held just once and then stay
> +in the original state forever.
> +
> +This feature will help implement vibrate functionality which requires one
> +time activation of vibrate mode without a continuous vibrate on/off cycles.
> +
> +This patch implements the timer-no-default trigger support by enhancing the
> +current led-class, led-core, and ledtrig-timer drivers to:
> +
> +- Add support for forever timer case. forever tag can be written to delay_on
> +  or delay_off files. Internally forever is mapped to ULONG_MAX with no timer
> +  associated with it.
> +
> +- The led_blink_set() which takes two pointers to times one each for delay_on
> +  and delay_off has been extended so that a NULL instead of a pointer means
> +  "forever".
> +
> +- Add a new timer-no-default trigger to ledtrig-timer
> +
> +The above enhancements support the following use-cases:
> +
> +use-case 1:
> +echo timer-no-default > /sys/class/leds/SOMELED/trigger
> +echo forever > /sys/class/leds/SOMELED/delay_off
> +echo 2000 > /sys/class/leds/SOMELED/delay_on
> +
> +When timer-no-default is activated in step1, unlike the timer trigger case,
> +timer-no-default activate routine activates the trigger without starting
> +any timers. The default 1 HZ delay_on and delay_off timers won't be started
> +like in the case of timer trigger activation. Not starting timers ensures
> +that the one time state isn't stuck if some error occurs before actual timer
> +periods are specified. delay_on and delay_off files get created with 0
> +values. Please note that it is important to set delay_off to forever prior
> +to setting delay_on value. If the order is reversed, the LED will be turned
> +on, with no timer set to turn it off.
> +
> +When delay_off value is specified in step 2, delay_off_store recognizes the
> +special forever tag and records it and returns without starting any timer.
> +Internally forever maps to ULONG_MAX. The led_blink_set() which takes
> +two pointers to times one each for delay_on and delay_off has been extended
> +so that a NULL instead of a pointer means "forever".
> +
> +When delay_on value is specified in step 3, a timer gets started for
> +delay_on period, and delay_off stays at ULONG_MAX with no timer associated
> +with it.
> +
> +use-case 2:
> +echo timer-no-default > /sys/class/leds/SOMELED/trigger
> +echo forever > /sys/class/leds/SOMELED/delay_on
> +echo 2000 > /sys/class/leds/SOMELED/delay_off
> +
> +When timer-no-default is activated in step1, unlike the timer trigger case,
> +timer-no-default activate routine activates the trigger without starting
> +any timers. The default 1 HZ delay_on and delay_off timers won't be started
> +like in the case of timer trigger activation. Not starting timers ensures
> +that the one time state isn't stuck if some error occurs before actual timer
> +periods are specified. delay_on and delay_off files get created with 0
> +values. Please note that it is important to set delay_on to forever prior
> +to setting delay_off value. If the order is reversed, the LED will be turned
> +off, with no timer set to turn it back on.
> +
> +When delay_on value is specified in step 2, delay_on_store recognizes the
> +special forever tag and records it and returns without starting any timer.
> +Internally forever maps to ULONG_MAX.
> +
> +When delay_off value is specified in step 3, a timer gets started for
> +delay_off period, and delay_on stays at ULONG_MAX with no timer associated
> +with it.
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index 5bff843..ed123ba 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -107,7 +107,9 @@ static void led_timer_function(unsigned long data)
>  
>  	led_set_brightness(led_cdev, brightness);
>  
> -	mod_timer(&led_cdev->blink_timer, jiffies + msecs_to_jiffies(delay));
> +	if (delay != LED_TIMER_FOREVER)
> +		mod_timer(&led_cdev->blink_timer,
> +			jiffies + msecs_to_jiffies(delay));
>  }
>  
>  /**
> diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
> index d686004..419b0bc 100644
> --- a/drivers/leds/led-core.c
> +++ b/drivers/leds/led-core.c
> @@ -72,17 +72,35 @@ void led_blink_set(struct led_classdev *led_cdev,
>  		   unsigned long *delay_on,
>  		   unsigned long *delay_off)
>  {
> +	unsigned long val_on;
> +	unsigned long val_off;
> +
>  	del_timer_sync(&led_cdev->blink_timer);
>  
> -	if (led_cdev->blink_set &&
> +	if (delay_on && delay_off && led_cdev->blink_set &&
>  	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
>  		return;
>  
> +	/* if delay_on is null, leave it on forever after delay_off period
> +	   if delay_off is null, leave it off forever after delay on period */
> +	if (!delay_on)
> +		val_on = LED_TIMER_FOREVER;
> +	else
> +		val_on = *delay_on;
> +
> +	if (!delay_off)
> +		val_off = LED_TIMER_FOREVER;
> +	else
> +		val_off = *delay_off;
> +
>  	/* blink with 1 Hz as default if nothing specified */
> -	if (!*delay_on && !*delay_off)
> -		*delay_on = *delay_off = 500;
> +	if (!val_on && !val_off) {
> +		val_on = val_off = 500;
> +		*delay_on = 500;
> +		*delay_off = 500;
> +	}
>  
> -	led_set_software_blink(led_cdev, *delay_on, *delay_off);
> +	led_set_software_blink(led_cdev, val_on, val_off);
>  }
>  EXPORT_SYMBOL(led_blink_set);
>  
> diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
> index e77c7f8..b2cda9f 100644
> --- a/drivers/leds/leds.h
> +++ b/drivers/leds/leds.h
> @@ -17,6 +17,8 @@
>  #include <linux/rwsem.h>
>  #include <linux/leds.h>
>  
> +#define LED_TIMER_FOREVER ULONG_MAX
> +
>  static inline void led_set_brightness(struct led_classdev *led_cdev,
>  					enum led_brightness value)
>  {
> diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
> index 328c64c..e323cf2 100644
> --- a/drivers/leds/ledtrig-timer.c
> +++ b/drivers/leds/ledtrig-timer.c
> @@ -24,6 +24,9 @@ static ssize_t led_delay_on_show(struct device *dev,
>  {
>  	struct led_classdev *led_cdev = dev_get_drvdata(dev);
>  
> +	if (led_cdev->blink_delay_on == LED_TIMER_FOREVER)
> +		return sprintf(buf, "forever\n");
> +
>  	return sprintf(buf, "%lu\n", led_cdev->blink_delay_on);
>  }
>  
> @@ -32,17 +35,25 @@ static ssize_t led_delay_on_store(struct device *dev,
>  {
>  	struct led_classdev *led_cdev = dev_get_drvdata(dev);
>  	int ret = -EINVAL;
> -	char *after;
> -	unsigned long state = simple_strtoul(buf, &after, 10);
> -	size_t count = after - buf;
> -
> -	if (isspace(*after))
> -		count++;
>  
> -	if (count == size) {
> -		led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
> -		led_cdev->blink_delay_on = state;
> -		ret = count;
> +	if (strncmp(buf, "forever", 7) == 0) {
> +		led_blink_set(led_cdev, NULL, &led_cdev->blink_delay_off);
> +		led_cdev->blink_delay_on = LED_TIMER_FOREVER;
> +		ret = size;
> +	} else {
> +		char *after;
> +		unsigned long state = simple_strtoul(buf, &after, 10);
> +		size_t count = after - buf;
> +
> +		if (isspace(*after))
> +			count++;
> +
> +		if (count == size) {
> +			led_blink_set(led_cdev, &state,
> +				&led_cdev->blink_delay_off);
> +			led_cdev->blink_delay_on = state;
> +			ret = count;
> +		}
>  	}
>  
>  	return ret;
> @@ -53,6 +64,9 @@ static ssize_t led_delay_off_show(struct device *dev,
>  {
>  	struct led_classdev *led_cdev = dev_get_drvdata(dev);
>  
> +	if (led_cdev->blink_delay_off == LED_TIMER_FOREVER)
> +		return sprintf(buf, "forever\n");
> +
>  	return sprintf(buf, "%lu\n", led_cdev->blink_delay_off);
>  }
>  
> @@ -61,17 +75,24 @@ static ssize_t led_delay_off_store(struct device *dev,
>  {
>  	struct led_classdev *led_cdev = dev_get_drvdata(dev);
>  	int ret = -EINVAL;
> -	char *after;
> -	unsigned long state = simple_strtoul(buf, &after, 10);
> -	size_t count = after - buf;
>  
> -	if (isspace(*after))
> -		count++;
> -
> -	if (count == size) {
> -		led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
> -		led_cdev->blink_delay_off = state;
> -		ret = count;
> +	if (strncmp(buf, "forever", 7) == 0) {
> +		led_blink_set(led_cdev, &led_cdev->blink_delay_on, NULL);
> +		led_cdev->blink_delay_off = LED_TIMER_FOREVER;
> +	} else {
> +		char *after;
> +		unsigned long state = simple_strtoul(buf, &after, 10);
> +		size_t count = after - buf;
> +
> +		if (isspace(*after))
> +			count++;
> +
> +		if (count == size) {
> +			led_blink_set(led_cdev, &led_cdev->blink_delay_on,
> +				&state);
> +			led_cdev->blink_delay_off = state;
> +			ret = count;
> +		}
>  	}
>  
>  	return ret;
> @@ -80,7 +101,7 @@ static ssize_t led_delay_off_store(struct device *dev,
>  static DEVICE_ATTR(delay_on, 0644, led_delay_on_show, led_delay_on_store);
>  static DEVICE_ATTR(delay_off, 0644, led_delay_off_show, led_delay_off_store);
>  
> -static void timer_trig_activate(struct led_classdev *led_cdev)
> +static void timer_trig_activate_common(struct led_classdev *led_cdev)
>  {
>  	int rc;
>  
> @@ -91,17 +112,24 @@ static void timer_trig_activate(struct led_classdev *led_cdev)
>  		return;
>  	rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
>  	if (rc)
> -		goto err_out_delayon;
> -
> -	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
> -		      &led_cdev->blink_delay_off);
> +		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
>  
> -	led_cdev->trigger_data = (void *)1;
> +	else
> +		led_cdev->trigger_data = (void *)1;
> +}
>  
> -	return;
> +static void timer_trig_activate_timer_no_default(struct led_classdev *led_cdev)
> +{
> +	timer_trig_activate_common(led_cdev);
> +}
>  
> -err_out_delayon:
> -	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
> +static void timer_trig_activate(struct led_classdev *led_cdev)
> +{
> +	timer_trig_activate_common(led_cdev);
> +	if (led_cdev->trigger_data) {
> +		led_blink_set(led_cdev, &led_cdev->blink_delay_on,
> +		      &led_cdev->blink_delay_off);
> +	}
>  }
>  
>  static void timer_trig_deactivate(struct led_classdev *led_cdev)
> @@ -121,14 +149,30 @@ static struct led_trigger timer_led_trigger = {
>  	.deactivate = timer_trig_deactivate,
>  };
>  
> +static struct led_trigger timer_no_default_led_trigger = {
> +	.name     = "timer-no-default",
> +	.activate = timer_trig_activate_timer_no_default,
> +	.deactivate = timer_trig_deactivate,
> +};
> +
>  static int __init timer_trig_init(void)
>  {
> -	return led_trigger_register(&timer_led_trigger);
> +	int rc = 0;
> +
> +	rc = led_trigger_register(&timer_led_trigger);
> +	if (!rc) {
> +		rc = led_trigger_register(&timer_no_default_led_trigger);
> +		if (rc)
> +			led_trigger_unregister(&timer_led_trigger);
> +	}
> +
> +	return rc;
>  }
>  
>  static void __exit timer_trig_exit(void)
>  {
>  	led_trigger_unregister(&timer_led_trigger);
> +	led_trigger_unregister(&timer_no_default_led_trigger);
>  }
>  
>  module_init(timer_trig_init);


