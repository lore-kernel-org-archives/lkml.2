Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab2DGOOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 10:14:30 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:15605 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab2DGONs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 10:13:48 -0400
Message-ID: <1333808024.2728.39.camel@lorien2>
Subject: Re: [PATCH RESEND] LEDS-One-Shot-Timer-Trigger-implementation
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shuahkhan@gmail.com, neilb@suse.de, rpurdie@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 07 Apr 2012 08:13:44 -0600
In-Reply-To: <20120406165353.ab667eb0.akpm@linux-foundation.org>
References: <1333310039.2879.4.camel@lorien2>
	 <20120406165353.ab667eb0.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +This feature will help implement vibrate functionality which requires one
> > +time activation of vibrate mode without a continuous vibrate on/off cycles.
> 
> They make vibrating LED? ;)
> 
> What's going on here?  You're proposing to repurpose the LEDs code to
> drive vibration devices?  Or some devices couple a LED with a vibration
> device?

I owe you filling in the blanks type explanation. Let me describe the
use-case I am trying to address first. Vibrater function on phones is
implemented using PWM pins on SoC or PMIC. When there is no such
hardware present, a software solution is needed. Currently two drivers
timed-gpio and timed-output (under staging/android in Linux 3.3)
together implement the software vibrate feature. The main functionality
it implements is the one time enables of timer to prevent user space
crashes leaving the phone in vibrate mode causing the battery to drain.
leds as it is implemented currently, is not suitable to address this
use-case as it doesn't support one time enables.

I initiated a discussion on ce-android mainlining mailing list and after
some back and forth, the solution to enhance leds infrastructure to
support one shot timer emerged as the preferred one to address the need
in a generic way. Adding this feature to leds infrastructure allows
ledgpio as well as ledpwm drivers use it. This approach allows us to
extend the existing infrastructure as well as, avoid adding two new
drivers. Even though leds is kind of an odd place for vibrate feature in
that it is counter intuitive, looking at its infrastructure, it made
sense to leverage what it already does and enhance it.

If are interested in reading the discussion, here is the link that
starts the discussion:

http://lists.linuxfoundation.org/pipermail/ce-android-mainline/2012-February/000077.html

Hope this helps understand what I am trying to accomplish. Please let me
know after this explanation, if you think adding this feature is heading
in the right direction to address this need? Other ideas are welcome.

As per the specific comments on the code it self, here is what I will do
while we discuss this feature,

1. Cleanup simple_strtoul() in leds - in addition to the checkpatch
warnings this patch triggered, there is at least one other use of
simple_strtoul() that needs cleanup. I will send a patch to do that,
while we discuss the next steps with this feature.

Please see my responses on this patch in-line:
> 
> > +This patch implements the timer-no-default trigger support by enhancing the
> > +current led-class, led-core, and ledtrig-timer drivers to:
> 
> Well, the documentation shouldn't refer to a "patch", as patches are
> short-term transient things.  It is describing a kernel interface.  You
> could call it "this feature" or, better "the one shot trigger feature".
> 
> > +- Add support for forever timer case. forever tag can be written to delay_on
> > +  or delay_off files. Internally forever is mapped to ULONG_MAX with no timer
> > +  associated with it.
> > +
> > +- The led_blink_set() which takes two pointers to times one each for delay_on
> > +  and delay_off has been extended so that a NULL instead of a pointer means
> > +  "forever".
> > +
> > +- Add a new timer-no-default trigger to ledtrig-timer
> 
> Similarly, it's odd to refer to "adding" things when describing an
> already-existing kernel feature!
> 
> >
> > ...
> >
> > --- a/drivers/leds/led-class.c
> > +++ b/drivers/leds/led-class.c
> > @@ -107,7 +107,9 @@ static void led_timer_function(unsigned long data)
> >  
> >  	led_set_brightness(led_cdev, brightness);
> >  
> > -	mod_timer(&led_cdev->blink_timer, jiffies + msecs_to_jiffies(delay));
> > +	if (delay != LED_TIMER_FOREVER)
> 
> So LED_TIMER_FOREVER really is forever?  My LED doesn't turn itself back on
> after 2^32 jiffies?
> 
> > +		mod_timer(&led_cdev->blink_timer,
> > +			jiffies + msecs_to_jiffies(delay));
> >  }
> 
> Is seems so...
Let me see, the timer is not set when delay == LED_TIMER_FOREVER. Am I
missing something?

> 
> > ...
> >
> > --- a/drivers/leds/ledtrig-timer.c
> > +++ b/drivers/leds/ledtrig-timer.c
> > @@ -24,6 +24,9 @@ static ssize_t led_delay_on_show(struct device *dev,
> >  {
> >  	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> >  
> > +	if (led_cdev->blink_delay_on == LED_TIMER_FOREVER)
> > +		return sprintf(buf, "forever\n");
> > +
> >  	return sprintf(buf, "%lu\n", led_cdev->blink_delay_on);
> >  }
> 
> This is a somewhat risky kernel interface change.  Previously the
> output was always a decimal string.  With this change it is either a
> decimal string or "forever".  Applications which were coded to the old
> interface will probably misinterpret the "forever" as a zero.  Or they
> will crash and burn.
> 
> A safer approach would be to just print the value.  So it comes out as
> 4294967295 or 18446744073709551615.  That's pretty nasty, and invites
> people to write programs which are busted on 32-bit userspace (or on
> 64-bit).
> 
> Maybe it was just a mistake to overload ->blink_delay_on in this
> fashion.  Perhaps the code will be cleaner if we add a couple of new
> booleans to the led_cdev.
> 
> Anyway, please have a think about this.

I had some reservations with overloading and using a string, however
using forever would help hide the internal implementation details. That
said I can go either way.

> 
> > @@ -32,17 +35,25 @@ static ssize_t led_delay_on_store(struct device *dev,
> >  {
> >  	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> >  	int ret = -EINVAL;
> > -	char *after;
> > -	unsigned long state = simple_strtoul(buf, &after, 10);
> > -	size_t count = after - buf;
> > -
> > -	if (isspace(*after))
> > -		count++;
> >  
> > -	if (count == size) {
> > -		led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
> > -		led_cdev->blink_delay_on = state;
> > -		ret = count;
> > +	if (strncmp(buf, "forever", 7) == 0) {
> > +		led_blink_set(led_cdev, NULL, &led_cdev->blink_delay_off);
> > +		led_cdev->blink_delay_on = LED_TIMER_FOREVER;
> > +		ret = size;
> > +	} else {
> > +		char *after;
> > +		unsigned long state = simple_strtoul(buf, &after, 10);
> 
> You ignored the checkpatch warning.  Please don't.  Take the
> opportunity to fix things up when altering existing code!
> 
> > +		size_t count = after - buf;
> > +
> > +		if (isspace(*after))
> > +			count++;
> > +
> > +		if (count == size) {
> > +			led_blink_set(led_cdev, &state,
> > +				&led_cdev->blink_delay_off);
> > +			led_cdev->blink_delay_on = state;
> > +			ret = count;
> > +		}
> >  	}
> 
> Now, *writing* the "forever" is OK - it doesn't break compatibility. 
> But we shouldn't permit bogus input such as "forever42".  Could perhaps
> use sysfs_streq() here.  Or strcmp()?

Yes I can do that.
> 
> >  	return ret;
> > @@ -53,6 +64,9 @@ static ssize_t led_delay_off_show(struct device *dev,
> >  {
> >  	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> >  
> > +	if (led_cdev->blink_delay_off == LED_TIMER_FOREVER)
> > +		return sprintf(buf, "forever\n");
> > +
> >  	return sprintf(buf, "%lu\n", led_cdev->blink_delay_off);
> >  }
> 
> Dittoes here.
> 
> > @@ -61,17 +75,24 @@ static ssize_t led_delay_off_store(struct device *dev,
> >  {
> >  	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> >  	int ret = -EINVAL;
> > -	char *after;
> > -	unsigned long state = simple_strtoul(buf, &after, 10);
> > -	size_t count = after - buf;
> >  
> > -	if (isspace(*after))
> > -		count++;
> > -
> > -	if (count == size) {
> > -		led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
> > -		led_cdev->blink_delay_off = state;
> > -		ret = count;
> > +	if (strncmp(buf, "forever", 7) == 0) {
> > +		led_blink_set(led_cdev, &led_cdev->blink_delay_on, NULL);
> > +		led_cdev->blink_delay_off = LED_TIMER_FOREVER;
> > +	} else {
> > +		char *after;
> > +		unsigned long state = simple_strtoul(buf, &after, 10);
> > +		size_t count = after - buf;
> > +
> > +		if (isspace(*after))
> > +			count++;
> > +
> > +		if (count == size) {
> > +			led_blink_set(led_cdev, &led_cdev->blink_delay_on,
> > +				&state);
> > +			led_cdev->blink_delay_off = state;
> > +			ret = count;
> > +		}
> >  	}
> 
> More dittoes here.
> 
> >  	return ret;
> > @@ -80,7 +101,7 @@ static ssize_t led_delay_off_store(struct device *dev,
> >  static DEVICE_ATTR(delay_on, 0644, led_delay_on_show, led_delay_on_store);
> >  static DEVICE_ATTR(delay_off, 0644, led_delay_off_show, led_delay_off_store);
> >  
> > -static void timer_trig_activate(struct led_classdev *led_cdev)
> > +static void timer_trig_activate_common(struct led_classdev *led_cdev)
> >  {
> >  	int rc;
> >  
> > @@ -91,17 +112,24 @@ static void timer_trig_activate(struct led_classdev *led_cdev)
> >  		return;
> >  	rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
> >  	if (rc)
> > -		goto err_out_delayon;
> > -
> > -	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
> > -		      &led_cdev->blink_delay_off);
> > +		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
> >  
> > -	led_cdev->trigger_data = (void *)1;
> > +	else
> > +		led_cdev->trigger_data = (void *)1;
> 
> yikes.  What is the led core code doing fiddling around with an
> open-coded (void *)1?

It is being used to save state. Looked strange, however I decided to not
touch it as part of this feature. :)

> 
> > +}
> >  
> >
> > ...
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


