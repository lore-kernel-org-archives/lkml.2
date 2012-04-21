Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab2DUElP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 00:41:15 -0400
Received: from mail.southpole.se ([193.12.106.18]:60321 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2DUElO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 00:41:14 -0400
Message-ID: <1334983269.2435.90.camel@jerome.southpole.se>
Subject: Re: [PATCH ] leds: add new transient trigger for one shot timer
 support
From: Jonas Bonn <jonas@southpole.se>
To: shuahkhan@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, neilb@suse.de,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Date: Sat, 21 Apr 2012 06:41:09 +0200
In-Reply-To: <1334894674.3051.18.camel@lorien2>
References: <1333310039.2879.4.camel@lorien2> <1334064283.10826.6.camel@ted>
	 <1334507752.2723.3.camel@lorien2> <1334894674.3051.18.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 83270-13327
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Shuah,

A couple of questions:

i)  Why is it important for you to maintain the LED state?

ii)  Why do you need to be able to cancel the timer?

As I understand this trigger (and your use-case), this is about being
able to turn on a LED (signal) and forget about it, knowing that it will
be extinguished in due time without any intervention.  So I would leave
it at that; don't even present an option to intervene.

That said, there is already a way to intervene:  I can always write 0 to
'brightness' to extinguish the led immediately.

A couple more comments inline below.

/Jonas

On Thu, 2012-04-19 at 22:04 -0600, Shuah Khan wrote:
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

You can already read the state of the LED... it's in the 'brightness'
property.  You don't need to be able to read it here, too.

>        transient_time -        one shot timer value. When transient_enabled
>                                is set, transient_time value is used to start
>                                a timer that runs once.

'duration' might be a better name.  What are the units?  I like to see
the units explicity in the property name so that I don't need to think:
'duration_msec' might be appropriate.

>        When timer expires transient_enabled goes back to disabled state,
>        transient_time is left at the set value to be used when transient
>        is enabled at a future time. This will allow user app to set the
>        time once and enable it to run it once for the specified value as
>        needed.
> 
> From 80a15b18f6758d2890dfa6b266f2ea4e30338e3c Mon Sep 17 00:00:00 2001
> From: Shuah Khan <shuahkhan@gmail.com>
> Date: Thu, 19 Apr 2012 21:05:36 -0600
> Subject: [PATCH 2/2] leds: add new transient trigger for one shot timer
>  support
> 
> 
> Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
> ---
>  drivers/leds/Kconfig             |    8 ++
>  drivers/leds/Makefile            |    1 +
>  drivers/leds/ledtrig-transient.c |  246 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 255 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/leds/ledtrig-transient.c
> 
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 589ba02..c6d8006 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -478,4 +478,12 @@ config LEDS_TRIGGER_DEFAULT_ON
>  comment "iptables trigger is under Netfilter config (LED target)"
>  	depends on LEDS_TRIGGERS
>  
> +config LEDS_TRIGGER_TRANSIENT
> +	tristate "LED Transient Trigger"
> +	depends on LEDS_TRIGGERS
> +	help
> +	  This allows one time enable of a transient state on GPIO/PWM based
> +	  hadrware.
> +	  If unsure, say Y.
> +
>  endif # NEW_LEDS
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index fa0f428..48d5af7 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -57,3 +57,4 @@ obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
>  obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
>  obj-$(CONFIG_LEDS_TRIGGER_GPIO)		+= ledtrig-gpio.o
>  obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
> +obj-$(CONFIG_LEDS_TRIGGER_TRANSIENT)	+= ledtrig-transient.o
> diff --git a/drivers/leds/ledtrig-transient.c b/drivers/leds/ledtrig-transient.c
> new file mode 100644
> index 0000000..e829124
> --- /dev/null
> +++ b/drivers/leds/ledtrig-transient.c
> @@ -0,0 +1,246 @@
> +/*
> + * LED Kernel Transient Trigger
> + *
> + * Copyright (C) 2012 Shuah Khan <shuahkhan@gmail.com>
> + *
> + * Based on Richard Purdie's ledtrig-timer.c and Atsushi Nemoto's
> + * ledtrig-heartbeat.c
> + * Design and use-case input from Jonas Bonn <jonas@southpole.se>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +/*
> +* This trigger is intended to be used for the following example use cases:
> +
> +* - Control of vibrate (phones, tablets etc.) hardware by userspace app.
> +* - Use of LED by userspace app as activity indicator.
> +* - Use of LED by userspace app as a kind of watchdog indicator -- as
> +*	long as the app is alive, it can keep the LED illuminated, if it dies
> +*	the LED will be extinguished automatically.
> +* - Use by any userspace app that needs a transient GPIO output.
> +*
> +* Transient trigger exports two attributes:
> +*	transient_enabled -	one shot timer enable mechanism.
> +*				1 when enabled, 0 when disabled.
> +*				enabled state indicates a timer
> +*				with a value of transient_time running.
> +*				disabled state indicates no active timer
> +*				running.
> +*	transient_time -	one shot timer value. When transient_enabled
> +*				is set, transient_time value is used to start
> +*				a timer that runs once.
> +*	When timer expires transient_enabled goes back to disabled state,
> +*	transient_time is left at the set value to be used when transient
> +*	is enabled at a future time. This will allow user app to set the
> +*	time once and enable it to run it once for the specified value as
> +*	needed.
> +*
> +*	echo 1 > transient_enabled - starts timer = transient_time when
> +*				     transient_time is not 0.
> +*	echo 0 > transient_enabled - cancels currently running timer.
> +*	echo n > transient_time	   - stores timer value to be used upon next
> +*				     enable. Currently active timer if any,
> +*				     continues to run for the specified time.
> +*	echo 0 > transient_time	   - stores timer value to be used upon next
> +*				     enable. Currently active timer if any,
> +*				     continues to run for the specified time.
> +*
> +*	Future enhancements:
> +*	1. extending and shortening the timer could be supported either by
> +*	   simply modifying the running timer transient_timer is set when
> +*	   transient_enabled is in enabled state. For example:
> +*	   echo n > transient_time will extend/shorten timer, however this
> +*	   could lead race condtions with timer expiry.
> +*	2. The same could be done using a third attribute to control
> +*	   extending and shortening the timer.
> +*
> +*	Example use-cases:
> +*	echo transient > trigger
> +*	echo n > transient_time
> +*	repeat the following step as needed:
> +*	echo 1 > transient_enabled - start timer = transient_time to run once
> +*	echo 1 > transient_enabled - start timer = transient_time to run once
> +*	echo none > trigger
> +*/
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/timer.h>
> +#include <linux/leds.h>
> +#include "leds.h"
> +
> +struct transient_trig_data {
> +	int transient_enabled;

As mentioned earlier, I don't think you need to track this.

> +	unsigned long transient_time;
> +	struct timer_list timer;
> +};
> +
> +static void transient_timer_function(unsigned long data)
> +{
> +	struct led_classdev *led_cdev = (struct led_classdev *) data;
> +	struct transient_trig_data *transient_data = led_cdev->trigger_data;
> +
> +	if (transient_data->transient_enabled) {
> +		transient_data->transient_enabled = 0;
> +		led_cdev->brightness_set(led_cdev, LED_OFF);
> +		del_timer(&transient_data->timer);
> +	}
> +}
> +
> +static ssize_t led_transient_enabled_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +	struct transient_trig_data *transient_data = led_cdev->trigger_data;
> +
> +	return sprintf(buf, "%d\n", transient_data->transient_enabled);
> +}
> +
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
> +
> +	/* cancel the running timer */
> +	if (state == 0) {
> +		transient_timer_function((unsigned long) led_cdev);
> +		return size;
> +	}
> +
> +	transient_data->transient_enabled = (int) state;
> +
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
> +static ssize_t led_transient_time_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +	struct transient_trig_data *transient_data = led_cdev->trigger_data;
> +
> +	return sprintf(buf, "%lu\n", transient_data->transient_time);
> +}
> +
> +static ssize_t led_transient_time_store(struct device *dev,
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
> +	transient_data->transient_time = state;
> +
> +	return size;
> +}
> +
> +static DEVICE_ATTR(transient_enabled, 0644, led_transient_enabled_show,
> +		   led_transient_enabled_store);

I would make this a verb, 'enable', and make it 0200.  Even 'enable'
isn't a great choice; something along the lines of 'activate' seems more
appropriate. 

> +static DEVICE_ATTR(transient_time, 0644, led_transient_time_show,
> +		   led_transient_time_store);
> +
> +static void transient_trig_activate(struct led_classdev *led_cdev)
> +{
> +	int rc;
> +	struct transient_trig_data *tdata;
> +
> +	tdata = kzalloc(sizeof(struct transient_trig_data), GFP_KERNEL);
> +	if (!tdata) {
> +		dev_err(led_cdev->dev,
> +			"unable to allocate transient trigger\n");
> +		return;
> +	}
> +	led_cdev->trigger_data = tdata;
> +
> +	rc = device_create_file(led_cdev->dev, &dev_attr_transient_enabled);
> +	if (rc)
> +		goto err_out;
> +
> +	rc = device_create_file(led_cdev->dev, &dev_attr_transient_time);
> +	if (rc)
> +		goto err_out_time;
> +
> +	setup_timer(&tdata->timer, transient_timer_function,
> +		    (unsigned long) led_cdev);
> +	led_cdev->activated = true;
> +
> +	printk(KERN_DEBUG "Ativated led transient trigger %s\n",
> +		led_cdev->name);
> +
> +	return;
> +
> +err_out_time:
> +	device_remove_file(led_cdev->dev, &dev_attr_transient_enabled);
> +err_out:
> +	dev_err(led_cdev->dev, "unable to register transient trigger\n");
> +	led_cdev->trigger_data = NULL;
> +	kfree(tdata);
> +}
> +
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
> +	}
> +	printk(KERN_DEBUG "Deativated led transient trigger %s\n",
> +		led_cdev->name);
> +}
> +
> +static struct led_trigger transient_trigger = {
> +	.name     = "transient",
> +	.activate = transient_trig_activate,
> +	.deactivate = transient_trig_deactivate,
> +};
> +
> +static int __init transient_trig_init(void)
> +{
> +	printk(KERN_DEBUG "Registered led transient trigger\n");
> +	return led_trigger_register(&transient_trigger);
> +}
> +
> +static void __exit transient_trig_exit(void)
> +{
> +	led_trigger_unregister(&transient_trigger);
> +	printk(KERN_DEBUG "Unregistered led transient trigger\n");
> +}
> +
> +module_init(transient_trig_init);
> +module_exit(transient_trig_exit);
> +
> +MODULE_AUTHOR("Shuah Khan <shuahkhan@gmail.com>");
> +MODULE_DESCRIPTION("Transient LED trigger");
> +MODULE_LICENSE("GPL");


