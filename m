Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab2DPWdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:33:46 -0400
Received: from mail.southpole.se ([193.12.106.18]:46743 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab2DPWdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:33:45 -0400
Message-ID: <1334615623.25933.29.camel@jerome.southpole.se>
Subject: Re: [PATCH 1/1] leds: add "kickable" LED trigger
From: Jonas Bonn <jonas@southpole.se>
To: shuahkhan@gmail.com
Cc: akpm@linux-foundation.org, neilb@suse.de, linux-kernel@vger.kernel.org,
        richard.purdie@linuxfoundation.org
Date: Tue, 17 Apr 2012 00:33:43 +0200
In-Reply-To: <1334590122.2218.4.camel@lorien2>
References: <1334507752.2723.3.camel@lorien2>
	 <1334529245-14385-1-git-send-email-jonas@southpole.se>
	 <CACM3HyFjgLPNmFwJKObuPkjQMT5u3b=4kRC+b9yqeNoTdhgHAA@mail.gmail.com>
	 <1334590122.2218.4.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 15622-07350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Shuah,

Nice work!  If I may comment on this briefly:

i)  The semantics of this patch make me cringe.  It's bad enough that
this is a "LED" trigger; having a "vibrating LED" is even worse.
Really, this is a GPIO trigger (which is reasonably logical); secondly,
this trigger is about maintaining a transient state given some criteria.

ii)  Why force the trigger to a fixed duration?  The point, if I
understand correctly, is to return to the "rest state" after a given
time in case the triggering entity dies; but if the triggering entity
(userspace application) is still alive, why not let it prolong the
"active state" by triggering again.  This is along the lines of the
'kickable' trigger patch I posted earlier.

iii)  I don't see the point of maintaining the state.  The state is
maintained by the fact that you have running timer; if the timer is not
running, the state is the "rest state".

I'd suggest:

i)  Calling this ledtrig-transient
ii)  Having a property 'duration' that determines how long the
GPIO/LED/signal is 'active'
iii) Having a property 'activate' (or 'tickle'!) that just sets the
'active' state if it isn't already active; writing to this properly
while active just resets the timer to 0 so that another full 'duration'
can pass before the LED deactivates.
iv)  Maybe having a property 'active-state' to decide whether the LED is
on or off when active; this isn't strictly necessary as the LED class
already has the active-low property to invert the meaning of the ON
state.

This would allow this trigger to be used for a bunch of different use
cases:

i)   Control of vibrator by userspace app.
ii)  Use of LED by userspace app as activity indicator.
iii) Use of LED by userspace app as a kind of watchdog indicator -- as
long as the app is alive, it can keep the LED illuminated, if it dies
the LED will be extinguished automatically.
iv)  Use by any userspace app that needs a transient GPIO output.

I hope that makes sense.  It mostly comes down to semantics... the
implementation is mostly fine, with the exception of maintaining the
illumination state that I don't see the need for.

/Jonas

On Mon, 2012-04-16 at 09:28 -0600, Shuah Khan wrote:
> On Mon, 2012-04-16 at 00:37 +0200, Jonas Bonn wrote:
> > Hmm... I think I messed up the --in-reply-to parameter to git
> > send-email.  This is in reply to the
> > "LEDS-One-Shot-Timer-Trigger-implementation" thread.
> > 
> > Sorry about that.
> > 
> > /Jonas
> 
> Jonas,
> 
> Cool. I got a patch ready yesterday which is very close to yours, except it 
> also keeps the state. Thanks for sharing the patch with me. Here is what I 
> have. Please take a look and see. I haven't gone through testing yet though.
> 
> Thanks,
> -- Shuah
> 
> From 3ded425401e5c72dfa161fb4533443bebe287398 Mon Sep 17 00:00:00 2001
> From: Shuah Khan <shuahkhan@gmail.com>
> Date: Mon, 16 Apr 2012 09:23:03 -0600
> Subject: [PATCH] leds: add ledtrig-vibrate
> 
> 
> Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
> ---
>  drivers/leds/ledtrig-vibrate.c |  133 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 133 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/leds/ledtrig-vibrate.c
> 
> diff --git a/drivers/leds/ledtrig-vibrate.c b/drivers/leds/ledtrig-vibrate.c
> new file mode 100644
> index 0000000..9354003
> --- /dev/null
> +++ b/drivers/leds/ledtrig-vibrate.c
> @@ -0,0 +1,133 @@
> +/*
> + * LED Kernel Vibrate Trigger
> + *
> + * Copyright (C) 2012 Shuah Khan <shuahkhan@gmail.com>
> + *
> + * Based on Richard Purdie's ledtrig-timer.c and Atsushi Nemoto's
> + * ledtrig-heartbeat.c
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/device.h>
> +#include <linux/ctype.h>
> +#include <linux/leds.h>
> +#include "leds.h"
> +
> +static struct vibrate_trig_data {
> +	unsigned long vbrate_time;
> +	bool vibrate_on;
> +	struct timer_list timer;
> +};
> +
> +static void vibrate_timer_function(unsigned long data)
> +{
> +	struct led_classdev *led_cdev = (struct led_classdev *) data;
> +	struct vibrate_trig_data *vibrate_data = led_cdev->trigger_data;
> +
> +	if (vibrate_data->vibrate_on) {
> +		del_timer(vibrate_date->timer);
> +		vibrate_data->vibrate_on = false;
> +		vibrate_data->vibrate_time = 0;
> +	}
> +}
> +
> +static ssize_t led_vibrate_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +	struct vibrate_trig_data *vibrate_data = led_cdev->trigger_data;
> +
> +	return sprintf(buf, "%lu\n", vibrate_data->vibrate_time);
> +}
> +
> +static ssize_t led_vibrate_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +	struct vibrate_trig_data *vibrate_data = led_cdev->trigger_data;
> +	unsigned long state;
> +	ssize_t ret = -EINVAL;
> +
> +	ret = kstrtoul(buf, 10, &state);
> +	if (ret)
> +		return ret;
> +
> +	/* should there be a default max. cap on the time? */
> +	if (!vibrate_data->vibrate_on && !state)
> +		vibrate_data->vibrate_time = state;
> +		if (!led_cdev->brightness_set)
> +			led_cdev->brightness_set(led_cdev, LED_ON);
> +		vibrate_data->vibrate_on = true;
> +		mod_timer(&vibrate_data->timer, jiffies + state);
> +	}
> +	/* if vibrate_on is true - then ignore this new request? */
> +
> +	return size;
> +}
> +
> +static DEVICE_ATTR(vibrate, 0644, led_vibrate_show, led_vibrate_store);
> +
> +static void vibrate_trig_activate(struct led_classdev *led_cdev)
> +{
> +	int rc;
> +	struct vibrate_trig_data *vibrate_data;
> +
> +	vibrate_data = kzalloc(sizeof(struct vibrate_trig_data), GFP_KERNEL);
> +	if (!vibrate_data) {
> +		dev_err(led->dev, "unable to allocate vibrate trigger\n");
> +		return;
> +	}
> +	led_cdev->trigger_data = vibrate_data;
> +
> +	rc = device_create_file(led_cdev->dev, &dev_attr_vibrate);
> +	if (rc) {
> +		dev_err(led->dev, "unable to register vibrate trigger\n");
> +		led_cdev->trigger_data = NULL;
> +		kfree(vibrate_data);
> +	}
> +	setup_timer(&vibrate_data->timer, vibrate_timer_function,
> +		    (unsigned long) led_cdev);
> +	/* vibrate_timer_function(vibrate_data); */
> +}
> +
> +static void vibrate_trig_deactivate(struct led_classdev *led_cdev)
> +{
> +	struct vibrate_trig_data *vibrate_data = led_cdev->trigger_data;
> +
> +	if (vibrate_data) {
> +		device_remove_file(led_cdev->dev, &dev_attr_vibrate);
> +		del_timer_sync(&vibrate_data->timer);
> +		led_cdev->trigger_data = NULL;
> +		kfree(vibrate_data);
> +	}
> +}
> +
> +static struct led_trigger vibrate_trigger = {
> +	.name     = "vibrate",
> +	.activate = vibrate_trig_activate,
> +	.deactivate = vibrate_trig_deactivate,
> +};
> +
> +static int __init vibrate_trig_init(void)
> +{
> +	return led_trigger_register(&vibrate_led_trigger);
> +}
> +
> +static void __exit vibrate_trig_exit(void)
> +{
> +	led_trigger_unregister(&vibrate_led_trigger);
> +}
> +
> +module_init(vibrate_trig_init);
> +module_exit(vibrate_trig_exit);
> +
> +MODULE_AUTHOR("Shuah Khan <shuahkhan@gmail.com>");
> +MODULE_DESCRIPTION("vibrate LED trigger");
> +MODULE_LICENSE("GPL");


