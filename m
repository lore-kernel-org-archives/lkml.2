Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2DTVTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:19:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2DTVTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:19:16 -0400
Date: Fri, 20 Apr 2012 14:19:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shuahkhan@gmail.com
Cc: neilb@suse.de, LKML <linux-kernel@vger.kernel.org>,
        Jonas Bonn <jonas@southpole.se>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: Re: [PATCH ] leds: add new transient trigger for one shot timer
 support
Message-Id: <20120420141914.a3235c61.akpm@linux-foundation.org>
In-Reply-To: <1334894674.3051.18.camel@lorien2>
References: <1333310039.2879.4.camel@lorien2>
	<1334064283.10826.6.camel@ted>
	<1334507752.2723.3.camel@lorien2>
	<1334894674.3051.18.camel@lorien2>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2012 22:04:34 -0600
Shuah Khan <shuahkhan@gmail.com> wrote:

> This patch adds a new transient trigger for one shot timer support and is
> to be used for the following example use cases:
> 
> - Control of vibrate (phones, tablets etc.) hardware by userspace app.
> - Use of LED by userspace app as activity indicator.
> - Use of LED by userspace app as a kind of watchdog indicator -- as
>        long as the app is alive, it can keep the LED illuminated, if it dies
>        the LED will be extinguished automatically.
> - Use by any userspace app that needs a transient GPIO output
> 
> Transient trigger exports two attributes:
>        transient_enabled -     one shot timer enable mechanism.
>                                1 when enabled, 0 when disabled.
>                                enabled state indicates a timer
>                                with a value of transient_time running.
>                                disabled state indicates no active timer
>                                running.
>        transient_time -        one shot timer value. When transient_enabled
>                                is set, transient_time value is used to start
>                                a timer that runs once.
>        When timer expires transient_enabled goes back to disabled state,
>        transient_time is left at the set value to be used when transient
>        is enabled at a future time. This will allow user app to set the
>        time once and enable it to run it once for the specified value as
>        needed.

Are there no comments from anyone on this?

>
> ...
>
> config LEDS_TRIGGER_TRANSIENT
> +	tristate "LED Transient Trigger"
> +	depends on LEDS_TRIGGERS
> +	help
> +	  This allows one time enable of a transient state on GPIO/PWM based
> +	  hadrware.

Make it "This allows one time enabling of a transient state on GPIO/PWM
based hardware."

> +	  If unsure, say Y.
> +
>
> ...
>
> +static void transient_timer_function(unsigned long data)
> +{
> +	struct led_classdev *led_cdev = (struct led_classdev *) data;
> +	struct transient_trig_data *transient_data = led_cdev->trigger_data;
> +
> +	if (transient_data->transient_enabled) {
> +		transient_data->transient_enabled = 0;
> +		led_cdev->brightness_set(led_cdev, LED_OFF);
> +		del_timer(&transient_data->timer);

Deleting the timer from within its handler is ...  odd.  Also it is a
bit racy against a concurrent add_timer() on a different CPU.

> +	}
> +}
> +
>
> ...
>
> +static ssize_t led_transient_enabled_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +	struct transient_trig_data *transient_data = led_cdev->trigger_data;
> +	unsigned long state;
> +	ssize_t ret = -EINVAL;
> +
> +	ret = kstrtoul(buf, 10, &state);
> +	if (ret)
> +		return ret;
> +
> +	if (state != 1 && state != 0)
> +		return ret;

Bug - we'll return 0 here.  Use "return -EINVAL" and remove the above
initialisation of `ret'.


> +	/* cancel the running timer */
> +	if (state == 0) {
> +		transient_timer_function((unsigned long) led_cdev);

And this is perhaps why transient_timer_function() does del_timer().

I suggest it would be cleaner and simpler to do

	transient_data->transient_enabled = 0;
	del_timer(...);

right here.

This is all rather racy in its handling of ->transient_enabled (at
least), but afacit the races are harmless.


> +		return size;
> +	}
> +
> +	transient_data->transient_enabled = (int) state;

The typecast is unneeded.

> +	/* start timer with transient_time value */
> +	if (state == 1 && transient_data->transient_time != 0) {
> +		led_cdev->brightness_set(led_cdev, LED_FULL);
> +		mod_timer(&transient_data->timer,
> +			  jiffies + transient_data->transient_time);
> +	}
> +
> +	return size;
> +}
> +
>
> ...
>
> +static ssize_t led_transient_time_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +	struct transient_trig_data *transient_data = led_cdev->trigger_data;
> +	unsigned long state;
> +	ssize_t ret = -EINVAL;

Unneeded initialisation.

> +	ret = kstrtoul(buf, 10, &state);
> +	if (ret)
> +		return ret;
> +
> +	transient_data->transient_time = state;
> +
> +	return size;
> +}
> +
>
> ...
>
> +static void transient_trig_deactivate(struct led_classdev *led_cdev)
> +{
> +	struct transient_trig_data *transient_data = led_cdev->trigger_data;
> +
> +	if (led_cdev->activated) {
> +		device_remove_file(led_cdev->dev, &dev_attr_transient_enabled);
> +		device_remove_file(led_cdev->dev, &dev_attr_transient_time);
> +		del_timer_sync(&transient_data->timer);
> +		led_cdev->trigger_data = NULL;
> +		led_cdev->activated = false;
> +		kfree(transient_data);

OK.  But it might be nicer to kill off the timer before doing anything else.

> +	}
> +	printk(KERN_DEBUG "Deativated led transient trigger %s\n",
> +		led_cdev->name);
> +}
> +
>
> ...
>

