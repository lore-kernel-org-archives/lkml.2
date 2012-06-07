Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab2FGM7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 08:59:14 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:43564 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2FGM7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 08:59:12 -0400
MIME-Version: 1.0
In-Reply-To: <1339020665-9652-1-git-send-email-fabio.baltieri@gmail.com>
References: <CAK5ve-K0m0h-9vNj4DTk2P=isQPU7tuxWWaX5mcWTXpO-FU2Dg@mail.gmail.com>
 <1339020665-9652-1-git-send-email-fabio.baltieri@gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Thu, 7 Jun 2012 20:58:50 +0800
X-Google-Sender-Auth: pKq5KjbPQ1EikVjkVSlIYtEjyX8
Message-ID: <CAK5ve-Jot1dPEHQdKg0oJkhvGRYC7cHGMU=d4WkYWT80enNEyA@mail.gmail.com>
Subject: Re: [PATCH v3] led: add oneshot trigger
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>, Shuah Khan <shuahkhan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 6:11 AM, Fabio Baltieri <fabio.baltieri@gmail.com> wrote:
> Add oneshot trigger to blink a led with configurale parameters via
> sysfs.
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
> Cc: Shuah Khan <shuahkhan@gmail.com>
> Cc: Bryan Wu <bryan.wu@canonical.com>
> ---
>
> Here is the v3, with added documentation file with short description, sysfs
> description, use case example (the one I developed ths for, actually) and
> default values.
>
> Also, while trying the use case, I added instantaneous setting of led state when
> setting the "invert" attribute.
>
> Let me know what you think of this!
>

I'm fine this patch now, and added to my for-next and devel branches.

-Bryan


> Fabio
>
>  Documentation/leds/ledtrig-oneshot.txt |  59 ++++++++++
>  drivers/leds/Kconfig                   |  14 +++
>  drivers/leds/Makefile                  |   1 +
>  drivers/leds/ledtrig-oneshot.c         | 204 +++++++++++++++++++++++++++++++++
>  4 files changed, 278 insertions(+)
>  create mode 100644 Documentation/leds/ledtrig-oneshot.txt
>  create mode 100644 drivers/leds/ledtrig-oneshot.c
>
> diff --git a/Documentation/leds/ledtrig-oneshot.txt b/Documentation/leds/ledtrig-oneshot.txt
> new file mode 100644
> index 0000000..07cd1fa
> --- /dev/null
> +++ b/Documentation/leds/ledtrig-oneshot.txt
> @@ -0,0 +1,59 @@
> +One-shot LED Trigger
> +====================
> +
> +This is a LED trigger useful for signaling the user of an event where there are
> +no clear trap points to put standard led-on and led-off settings.  Using this
> +trigger, the application needs only to signal the trigger when an event has
> +happened, than the trigger turns the LED on and than keeps it off for a
> +specified amount of time.
> +
> +This trigger is meant to be usable both for sporadic and dense events.  In the
> +first case, the trigger produces a clear single controlled blink for each
> +event, while in the latter it keeps blinking at constant rate, as to signal
> +that the events are arriving continuously.
> +
> +A one-shot LED only stays in a constant state when there are no events.  An
> +additional "invert" property specifies if the LED has to stay off (normal) or
> +on (inverted) when not rearmed.
> +
> +The trigger can be activated from user space on led class devices as shown
> +below:
> +
> +  echo oneshot > trigger
> +
> +This adds the following sysfs attributes to the LED:
> +
> +  delay_on - specifies for how many milliseconds the LED has to stay at
> +             LED_FULL brightness after it has been armed.
> +             Default to 100 ms.
> +
> +  delay_off - specifies for how many milliseconds the LED has to stay at
> +              LED_OFF brightness after it has been armed.
> +              Default to 100 ms.
> +
> +  invert - reverse the blink logic.  If set to 0 (default) blink on for delay_on
> +           ms, then blink off for delay_off ms, leaving the LED normally off.  If
> +           set to 1, blink off for delay_off ms, then blink on for delay_on ms,
> +           leaving the LED normally on.
> +           Setting this value also immediately change the LED state.
> +
> +  shot - write any non-empty string to signal an events, this starts a blink
> +         sequence if not already running.
> +
> +Example use-case: network devices, initialization:
> +
> +  echo oneshot > trigger # set trigger for this led
> +  echo 33 > delay_on     # blink at 1 / (33 + 33) Hz on continuous traffic
> +  echo 33 > delay_off
> +
> +interface goes up:
> +
> +  echo 1 > invert # set led as normally-on, turn the led on
> +
> +packet received/transmitted:
> +
> +  echo 1 > shot # led starts blinking, ignored if already blinking
> +
> +interface goes down
> +
> +  echo 0 > invert # set led as normally-off, turn the led off
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 04cb8c8..1f151fb 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -443,6 +443,20 @@ config LEDS_TRIGGER_TIMER
>
>          If unsure, say Y.
>
> +config LEDS_TRIGGER_ONESHOT
> +       tristate "LED One-shot Trigger"
> +       depends on LEDS_TRIGGERS
> +       help
> +         This allows LEDs to blink in one-shot pulses with parameters
> +         controlled via sysfs.  It's useful to notify the user on
> +         sporadic events, when there are no clear begin and end trap points,
> +         or on dense events, where this blinks the LED at constant rate if
> +         rearmed continuously.
> +
> +         It also shows how to use the led_blink_set_oneshot() function.
> +
> +         If unsure, say Y.
> +
>  config LEDS_TRIGGER_IDE_DISK
>        bool "LED IDE Disk Trigger"
>        depends on IDE_GD_ATA
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index f8958cd..9112d51 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -53,6 +53,7 @@ obj-$(CONFIG_LEDS_DAC124S085)         += leds-dac124s085.o
>
>  # LED Triggers
>  obj-$(CONFIG_LEDS_TRIGGER_TIMER)       += ledtrig-timer.o
> +obj-$(CONFIG_LEDS_TRIGGER_ONESHOT)     += ledtrig-oneshot.o
>  obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)    += ledtrig-ide-disk.o
>  obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)   += ledtrig-heartbeat.o
>  obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)   += ledtrig-backlight.o
> diff --git a/drivers/leds/ledtrig-oneshot.c b/drivers/leds/ledtrig-oneshot.c
> new file mode 100644
> index 0000000..5c9edf7
> --- /dev/null
> +++ b/drivers/leds/ledtrig-oneshot.c
> @@ -0,0 +1,204 @@
> +/*
> + * One-shot LED Trigger
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
> +#include "leds.h"
> +
> +#define DEFAULT_DELAY 100
> +
> +struct oneshot_trig_data {
> +       unsigned int invert;
> +};
> +
> +static ssize_t led_shot(struct device *dev,
> +               struct device_attribute *attr, const char *buf, size_t size)
> +{
> +       struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +       struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
> +
> +       led_blink_set_oneshot(led_cdev,
> +                       &led_cdev->blink_delay_on, &led_cdev->blink_delay_off,
> +                       oneshot_data->invert);
> +
> +       /* content is ignored */
> +       return size;
> +}
> +static ssize_t led_invert_show(struct device *dev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +       struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
> +
> +       return sprintf(buf, "%u\n", oneshot_data->invert);
> +}
> +
> +static ssize_t led_invert_store(struct device *dev,
> +               struct device_attribute *attr, const char *buf, size_t size)
> +{
> +       struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +       struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
> +       unsigned long state;
> +       int ret;
> +
> +       ret = kstrtoul(buf, 0, &state);
> +       if (ret)
> +               return ret;
> +
> +       oneshot_data->invert = !!state;
> +
> +       if (oneshot_data->invert)
> +               led_set_brightness(led_cdev, LED_FULL);
> +       else
> +               led_set_brightness(led_cdev, LED_OFF);
> +
> +       return size;
> +}
> +
> +static ssize_t led_delay_on_show(struct device *dev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +
> +       return sprintf(buf, "%lu\n", led_cdev->blink_delay_on);
> +}
> +
> +static ssize_t led_delay_on_store(struct device *dev,
> +               struct device_attribute *attr, const char *buf, size_t size)
> +{
> +       struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +       unsigned long state;
> +       int ret;
> +
> +       ret = kstrtoul(buf, 0, &state);
> +       if (ret)
> +               return ret;
> +
> +       led_cdev->blink_delay_on = state;
> +
> +       return size;
> +}
> +static ssize_t led_delay_off_show(struct device *dev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +
> +       return sprintf(buf, "%lu\n", led_cdev->blink_delay_off);
> +}
> +
> +static ssize_t led_delay_off_store(struct device *dev,
> +               struct device_attribute *attr, const char *buf, size_t size)
> +{
> +       struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +       unsigned long state;
> +       int ret;
> +
> +       ret = kstrtoul(buf, 0, &state);
> +       if (ret)
> +               return ret;
> +
> +       led_cdev->blink_delay_off = state;
> +
> +       return size;
> +}
> +
> +static DEVICE_ATTR(delay_on, 0644, led_delay_on_show, led_delay_on_store);
> +static DEVICE_ATTR(delay_off, 0644, led_delay_off_show, led_delay_off_store);
> +static DEVICE_ATTR(invert, 0644, led_invert_show, led_invert_store);
> +static DEVICE_ATTR(shot, 0200, NULL, led_shot);
> +
> +static void oneshot_trig_activate(struct led_classdev *led_cdev)
> +{
> +       struct oneshot_trig_data *oneshot_data;
> +       int rc;
> +
> +       oneshot_data = kzalloc(sizeof(*oneshot_data), GFP_KERNEL);
> +       if (!oneshot_data)
> +               return;
> +
> +       led_cdev->trigger_data = oneshot_data;
> +
> +       rc = device_create_file(led_cdev->dev, &dev_attr_delay_on);
> +       if (rc)
> +               goto err_out_trig_data;
> +       rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
> +       if (rc)
> +               goto err_out_delayon;
> +       rc = device_create_file(led_cdev->dev, &dev_attr_invert);
> +       if (rc)
> +               goto err_out_delayoff;
> +       rc = device_create_file(led_cdev->dev, &dev_attr_shot);
> +       if (rc)
> +               goto err_out_invert;
> +
> +       led_cdev->blink_delay_on = DEFAULT_DELAY;
> +       led_cdev->blink_delay_off = DEFAULT_DELAY;
> +
> +       led_cdev->activated = true;
> +
> +       return;
> +
> +err_out_invert:
> +       device_remove_file(led_cdev->dev, &dev_attr_invert);
> +err_out_delayoff:
> +       device_remove_file(led_cdev->dev, &dev_attr_delay_off);
> +err_out_delayon:
> +       device_remove_file(led_cdev->dev, &dev_attr_delay_on);
> +err_out_trig_data:
> +       kfree(led_cdev->trigger_data);
> +}
> +
> +static void oneshot_trig_deactivate(struct led_classdev *led_cdev)
> +{
> +       struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
> +
> +       if (led_cdev->activated) {
> +               device_remove_file(led_cdev->dev, &dev_attr_delay_on);
> +               device_remove_file(led_cdev->dev, &dev_attr_delay_off);
> +               device_remove_file(led_cdev->dev, &dev_attr_invert);
> +               device_remove_file(led_cdev->dev, &dev_attr_shot);
> +               kfree(oneshot_data);
> +               led_cdev->activated = false;
> +       }
> +
> +       /* Stop blinking */
> +       led_brightness_set(led_cdev, LED_OFF);
> +}
> +
> +static struct led_trigger oneshot_led_trigger = {
> +       .name     = "oneshot",
> +       .activate = oneshot_trig_activate,
> +       .deactivate = oneshot_trig_deactivate,
> +};
> +
> +static int __init oneshot_trig_init(void)
> +{
> +       return led_trigger_register(&oneshot_led_trigger);
> +}
> +
> +static void __exit oneshot_trig_exit(void)
> +{
> +       led_trigger_unregister(&oneshot_led_trigger);
> +}
> +
> +module_init(oneshot_trig_init);
> +module_exit(oneshot_trig_exit);
> +
> +MODULE_AUTHOR("Fabio Baltieri <fabio.baltieri@gmail.com>");
> +MODULE_DESCRIPTION("One-shot LED trigger");
> +MODULE_LICENSE("GPL");
> --
> 1.7.11.rc1.9.gf623ca1.dirty
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
