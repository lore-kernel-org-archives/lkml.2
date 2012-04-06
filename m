Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402Ab2DFXxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 19:53:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab2DFXxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 19:53:54 -0400
Date: Fri, 6 Apr 2012 16:53:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shuahkhan@gmail.com
Cc: neilb@suse.de, rpurdie@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] LEDS-One-Shot-Timer-Trigger-implementation
Message-Id: <20120406165353.ab667eb0.akpm@linux-foundation.org>
In-Reply-To: <1333310039.2879.4.camel@lorien2>
References: <1333310039.2879.4.camel@lorien2>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Apr 2012 13:53:59 -0600
Shuah Khan <shuahkhan@gmail.com> wrote:

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
> >From 1ebe0fd67580da833f8f06fc3119445e9991100f Mon Sep 17 00:00:00 2001
> From: Shuah Khan <shuahkhan@gmail.com>
> Date: Sat, 31 Mar 2012 21:56:07 -0600
> Subject: [PATCH] LEDS-One-Shot-Timer-Trigger-implementation

Should be "leds: one shot timer trigger implementation", please.

>
> ...
>
> +This feature will help implement vibrate functionality which requires one
> +time activation of vibrate mode without a continuous vibrate on/off cycles.

They make vibrating LED? ;)

What's going on here?  You're proposing to repurpose the LEDs code to
drive vibration devices?  Or some devices couple a LED with a vibration
device?

> +This patch implements the timer-no-default trigger support by enhancing the
> +current led-class, led-core, and ledtrig-timer drivers to:

Well, the documentation shouldn't refer to a "patch", as patches are
short-term transient things.  It is describing a kernel interface.  You
could call it "this feature" or, better "the one shot trigger feature".

> +- Add support for forever timer case. forever tag can be written to delay_on
> +  or delay_off files. Internally forever is mapped to ULONG_MAX with no timer
> +  associated with it.
> +
> +- The led_blink_set() which takes two pointers to times one each for delay_on
> +  and delay_off has been extended so that a NULL instead of a pointer means
> +  "forever".
> +
> +- Add a new timer-no-default trigger to ledtrig-timer

Similarly, it's odd to refer to "adding" things when describing an
already-existing kernel feature!

>
> ...
>
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -107,7 +107,9 @@ static void led_timer_function(unsigned long data)
>  
>  	led_set_brightness(led_cdev, brightness);
>  
> -	mod_timer(&led_cdev->blink_timer, jiffies + msecs_to_jiffies(delay));
> +	if (delay != LED_TIMER_FOREVER)

So LED_TIMER_FOREVER really is forever?  My LED doesn't turn itself back on
after 2^32 jiffies?

> +		mod_timer(&led_cdev->blink_timer,
> +			jiffies + msecs_to_jiffies(delay));
>  }

Is seems so...

> ...
>
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

This is a somewhat risky kernel interface change.  Previously the
output was always a decimal string.  With this change it is either a
decimal string or "forever".  Applications which were coded to the old
interface will probably misinterpret the "forever" as a zero.  Or they
will crash and burn.

A safer approach would be to just print the value.  So it comes out as
4294967295 or 18446744073709551615.  That's pretty nasty, and invites
people to write programs which are busted on 32-bit userspace (or on
64-bit).

Maybe it was just a mistake to overload ->blink_delay_on in this
fashion.  Perhaps the code will be cleaner if we add a couple of new
booleans to the led_cdev.

Anyway, please have a think about this.

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

You ignored the checkpatch warning.  Please don't.  Take the
opportunity to fix things up when altering existing code!

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

Now, *writing* the "forever" is OK - it doesn't break compatibility. 
But we shouldn't permit bogus input such as "forever42".  Could perhaps
use sysfs_streq() here.  Or strcmp()?

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

Dittoes here.

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

More dittoes here.

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

yikes.  What is the led core code doing fiddling around with an
open-coded (void *)1?

> +}
>  
>
> ...
>

