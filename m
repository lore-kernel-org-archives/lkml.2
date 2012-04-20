Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab2DTWsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:48:43 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:21597 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab2DTWsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:48:42 -0400
Message-ID: <1334962118.3255.40.camel@lorien2>
Subject: Re: [PATCH ] leds: add new transient trigger for one shot timer
 support
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shuahkhan@gmail.com, neilb@suse.de, LKML <linux-kernel@vger.kernel.org>,
        Jonas Bonn <jonas@southpole.se>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Date: Fri, 20 Apr 2012 16:48:38 -0600
In-Reply-To: <20120420141914.a3235c61.akpm@linux-foundation.org>
References: <1333310039.2879.4.camel@lorien2> <1334064283.10826.6.camel@ted>
	 <1334507752.2723.3.camel@lorien2> <1334894674.3051.18.camel@lorien2>
	 <20120420141914.a3235c61.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Are there no comments from anyone on this?
Thanks for the comments.
> 
> >
> > ...
> >
> > config LEDS_TRIGGER_TRANSIENT
> > +	tristate "LED Transient Trigger"
> > +	depends on LEDS_TRIGGERS
> > +	help
> > +	  This allows one time enable of a transient state on GPIO/PWM based
> > +	  hadrware.
> 
> Make it "This allows one time enabling of a transient state on GPIO/PWM
> based hardware."
Will do.
> 
> > +	  If unsure, say Y.
> > +
> >
> > ...
> >
> > +static void transient_timer_function(unsigned long data)
> > +{
> > +	struct led_classdev *led_cdev = (struct led_classdev *) data;
> > +	struct transient_trig_data *transient_data = led_cdev->trigger_data;
> > +
> > +	if (transient_data->transient_enabled) {
> > +		transient_data->transient_enabled = 0;
> > +		led_cdev->brightness_set(led_cdev, LED_OFF);
> > +		del_timer(&transient_data->timer);
> 
> Deleting the timer from within its handler is ...  odd.  Also it is a
> bit racy against a concurrent add_timer() on a different CPU.
Good point. Will fix.
> 
> > +	}
> > +}
> > +
> >
> > ...
> >
> > +static ssize_t led_transient_enabled_store(struct device *dev,
> > +		struct device_attribute *attr, const char *buf, size_t size)
> > +{
> > +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> > +	struct transient_trig_data *transient_data = led_cdev->trigger_data;
> > +	unsigned long state;
> > +	ssize_t ret = -EINVAL;
> > +
> > +	ret = kstrtoul(buf, 10, &state);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (state != 1 && state != 0)
> > +		return ret;
> 
> Bug - we'll return 0 here.  Use "return -EINVAL" and remove the above
> initialisation of `ret'.

Good point. Will fix.
> 
> 
> > +	/* cancel the running timer */
> > +	if (state == 0) {
> > +		transient_timer_function((unsigned long) led_cdev);
> 
> And this is perhaps why transient_timer_function() does del_timer().
> 
> I suggest it would be cleaner and simpler to do
> 
> 	transient_data->transient_enabled = 0;
> 	del_timer(...);
> 
> right here.

Will fix it.
> 
> This is all rather racy in its handling of ->transient_enabled (at
> least), but afacit the races are harmless.

I am a bit concerned about it as well. Does adding a mutex to
trigger_data a good way to go to protect transient_enabled? I will give
that a try.

> The typecast is unneeded.
ok
> 
> > +	/* start timer with transient_time value */
> > +	if (state == 1 && transient_data->transient_time != 0) {
> > +		led_cdev->brightness_set(led_cdev, LED_FULL);
> > +		mod_timer(&transient_data->timer,
> > +			  jiffies + transient_data->transient_time);
> > +	}
> > +
> > +	return size;
> > +}
> > +
> >
> > ...
> >
> > +static ssize_t led_transient_time_store(struct device *dev,
> > +		struct device_attribute *attr, const char *buf, size_t size)
> > +{
> > +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> > +	struct transient_trig_data *transient_data = led_cdev->trigger_data;
> > +	unsigned long state;
> > +	ssize_t ret = -EINVAL;
> 
> Unneeded initialisation.
Yup
> 
> > +	ret = kstrtoul(buf, 10, &state);
> > +	if (ret)
> > +		return ret;
> > +
> > +	transient_data->transient_time = state;
> > +
> > +	return size;
> > +}
> > +
> >
> > ...
> >
> > +static void transient_trig_deactivate(struct led_classdev *led_cdev)
> > +{
> > +	struct transient_trig_data *transient_data = led_cdev->trigger_data;
> > +
> > +	if (led_cdev->activated) {
> > +		device_remove_file(led_cdev->dev, &dev_attr_transient_enabled);
> > +		device_remove_file(led_cdev->dev, &dev_attr_transient_time);
> > +		del_timer_sync(&transient_data->timer);
> > +		led_cdev->trigger_data = NULL;
> > +		led_cdev->activated = false;
> > +		kfree(transient_data);
> 
> OK.  But it might be nicer to kill off the timer before doing anything else.
Yes that is correct - will fix it.
> 
> > +	}
> > +	printk(KERN_DEBUG "Deativated led transient trigger %s\n",
> > +		led_cdev->name);
> > +}
> > +
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


