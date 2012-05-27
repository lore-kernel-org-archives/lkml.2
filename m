Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab2E0QJy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 12:09:54 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:31422 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab2E0QJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 12:09:51 -0400
Message-ID: <1338134989.2968.18.camel@lorien2>
Subject: Re: [PATCH 3/3] led: add oneshot trigger
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: shuahkhan@gmail.com, Bryan Wu <bryan.wu@canonical.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Date: Sun, 27 May 2012 10:09:49 -0600
In-Reply-To: <1338074364-1829-3-git-send-email-fabio.baltieri@gmail.com>
References: <1338074364-1829-1-git-send-email-fabio.baltieri@gmail.com>
	 <1338074364-1829-3-git-send-email-fabio.baltieri@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-27 at 01:19 +0200, Fabio Baltieri wrote:
> Add oneshot trigger to blink a led with configurable parameters via
> sysfs.
> 
> Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
> Cc: Bryan Wu <bryan.wu@canonical.com>
> Cc: Shuah Khan <shuahkhan@gmail.com>
> ---
> 
> That's (a cleaned up version of) what I used to test the first patch. Should
> we also consider this one for integration?  Shuah Khan was working on
> something similar, I'll add him in CC.

Fabio,

Thanks for including me in the review. If you haven't already looked at
the the LEDS_TRIGGER_TRANSIENT I implemented, please take a look. It is
in linux-next and is queued up for 3.5-rc1 inclusion. It is also a one
shot timer, howver it holds the LED in a transient state (could be on or
off depending on its permanent state) for a specified period of time and
then goes back to the original state. Your use-case is different in that
the trigger you are implementing it holds it in blink state. These two
are distinct use-cases that address different needs and we will need
both.

However, the in the interest of reducing confusion, I would recommend
changing the name of the trigger you are adding to something that
reflects that it holds the blink state. You could call it
LED_TRIGGER_PULSEONCE or LED_TRIGGER_BLINKONCE.

Also could you please outline the use-cases. Might be a good idea to add
a documentation file for this new trigger.

Did you look at LEDS_TRIGGER_TIMER to see if the name-space you are
using conflicts with that triggers name-space. I think it does unless I
am missing something.

Also you probably need to base your patch on linux-next so you can pick
up one other infrastructure change I made to add a new activated flag to
led_classdev structure. This new flag is used to keep track of trigger
activated state and free memory and do cleanup.

More comments in-line.


> 
> Fabio
> 
>  drivers/leds/Kconfig           |   9 ++
>  drivers/leds/Makefile          |   1 +
>  drivers/leds/ledtrig-oneshot.c | 190 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 200 insertions(+)
>  create mode 100644 drivers/leds/ledtrig-oneshot.c
> 
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index ff4b8cf..17c3cf2 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -422,6 +422,15 @@ config LEDS_TRIGGER_TIMER
>  
>  	  If unsure, say Y.
>  
> +config LEDS_TRIGGER_ONESHOT
> +	tristate "One-Shot Trigger"
> +	depends on LEDS_TRIGGERS
> +	help
> +	  This allows LEDs to blink in one-shot pulses with parameters
> +	  controlled via sysfs.
> +
> +	  If unsure, say Y.
> +
>  config LEDS_TRIGGER_IDE_DISK
>  	bool "LED IDE Disk Trigger"
>  	depends on IDE_GD_ATA
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index 890481c..ec8ff79 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -51,6 +51,7 @@ obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
>  
>  # LED Triggers
>  obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
> +obj-$(CONFIG_LEDS_TRIGGER_ONESHOT)	+= ledtrig-oneshot.o
>  obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
>  obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
>  obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
> diff --git a/drivers/leds/ledtrig-oneshot.c b/drivers/leds/ledtrig-oneshot.c
> new file mode 100644
> index 0000000..7d9a052
> --- /dev/null
> +++ b/drivers/leds/ledtrig-oneshot.c
> @@ -0,0 +1,190 @@
> +/*
> + * One-Shot LED Trigger
> + *
> + * Copyright 2012, Fabio Baltieri <fabio.baltieri@gmail.com>
> + *
> + * Based on ledtrig-timer.c by Richard Purdie <rpurdie@openedhand.com>
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
> +#include <linux/slab.h>
> +#include <linux/leds.h>
> +
> +struct oneshot_trig_data {
> +	unsigned int invert;
> +};
> +
> +static ssize_t led_shot(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +	struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
> +
> +	led_blink_set_oneshot(led_cdev,
> +			&led_cdev->blink_delay_on, &led_cdev->blink_delay_off,
> +			oneshot_data->invert);
> +
> +	/* content is ignored */
> +	return size;
> +}
> +static ssize_t led_invert_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +	struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
> +
> +	return sprintf(buf, "%u\n", oneshot_data->invert);
> +}
> +
> +static ssize_t led_invert_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +	struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
> +	unsigned long state;
> +	int ret = -EINVAL;
This initialization is not necessary.
> +
> +	ret = kstrtoul(buf, 0, &state);
> +	if (ret)
> +		return ret;
> +
> +	oneshot_data->invert = !!state;
> +
> +	return size;
> +}
> +
> +static ssize_t led_delay_on_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%lu\n", led_cdev->blink_delay_on);
> +}
> +
> +static ssize_t led_delay_on_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +	unsigned long state;
> +	int ret = -EINVAL;
This initialization is not necessary.
> +
> +	ret = kstrtoul(buf, 0, &state);
> +	if (ret)
> +		return ret;
> +
> +	led_cdev->blink_delay_on = state;
> +
> +	return size;
> +}
> +static ssize_t led_delay_off_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%lu\n", led_cdev->blink_delay_off);
> +}
> +
> +static ssize_t led_delay_off_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +	unsigned long state;
> +	int ret = -EINVAL;

This initialization is not necessary.
> +
> +	ret = kstrtoul(buf, 0, &state);
> +	if (ret)
> +		return ret;
> +
> +	led_cdev->blink_delay_off = state;
> +
> +	return size;
> +}
> +
> +static DEVICE_ATTR(delay_on, 0644, led_delay_on_show, led_delay_on_store);

Doesn't this conflict with LEDS_TRIGGER_TIMER namespace

> +static DEVICE_ATTR(delay_off, 0644, led_delay_off_show, led_delay_off_store);

Doesn't this conflict with LEDS_TRIGGER_TIMER namespace
> +static DEVICE_ATTR(invert, 0644, led_invert_show, led_invert_store);

This probably conflict with 
> +static DEVICE_ATTR(shot, 0200, NULL, led_shot);
> +
> +static void oneshot_trig_activate(struct led_classdev *led_cdev)
> +{
> +	struct oneshot_trig_data *oneshot_data;
> +	int rc;
> +
> +	oneshot_data = kzalloc(sizeof(*oneshot_data), GFP_KERNEL);
> +	if (!oneshot_data)
> +		return;
> +
> +	led_cdev->trigger_data = oneshot_data;
> +
> +	rc = device_create_file(led_cdev->dev, &dev_attr_delay_on);
> +	if (rc)
> +		goto err_out_trig_data;
> +	rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
> +	if (rc)
> +		goto err_out_delayon;
> +	rc = device_create_file(led_cdev->dev, &dev_attr_invert);
> +	if (rc)
> +		goto err_out_delayoff;
> +	rc = device_create_file(led_cdev->dev, &dev_attr_shot);
> +	if (rc)
> +		goto err_out_invert;
> +

This is where you can set activated flag to true and check the flag from
your deactivate routine. Please check linux-next leds code. I also
updated all led triggers to use this new flag.


> +	return;
> +
> +err_out_invert:
> +	device_remove_file(led_cdev->dev, &dev_attr_invert);
> +err_out_delayoff:
> +	device_remove_file(led_cdev->dev, &dev_attr_delay_off);
> +err_out_delayon:
> +	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
> +err_out_trig_data:
> +	kfree(led_cdev->trigger_data);
> +}
> +
> +static void oneshot_trig_deactivate(struct led_classdev *led_cdev)
> +{
> +	struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
> +
> +	if (oneshot_data) {

You can check activated flag instead of onshot_data like the rest of the
led triggers.

> +		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
> +		device_remove_file(led_cdev->dev, &dev_attr_delay_off);
> +		device_remove_file(led_cdev->dev, &dev_attr_invert);
> +		device_remove_file(led_cdev->dev, &dev_attr_shot);
> +		kfree(led_cdev->trigger_data);
> +	}
> +
> +	/* Stop blinking */
> +	led_brightness_set(led_cdev, LED_OFF);
> +}
> +
> +static struct led_trigger oneshot_led_trigger = {
> +	.name     = "oneshot",
> +	.activate = oneshot_trig_activate,
> +	.deactivate = oneshot_trig_deactivate,
> +};
> +
> +static int __init oneshot_trig_init(void)
> +{
> +	return led_trigger_register(&oneshot_led_trigger);
> +}
> +
> +static void __exit oneshot_trig_exit(void)
> +{
> +	led_trigger_unregister(&oneshot_led_trigger);
> +}
> +
> +module_init(oneshot_trig_init);
> +module_exit(oneshot_trig_exit);
> +
> +MODULE_AUTHOR("Fabio Baltieri <fabio.baltieri@gmail.com>");
> +MODULE_DESCRIPTION("One-Shot LED trigger");
> +MODULE_LICENSE("GPL");


