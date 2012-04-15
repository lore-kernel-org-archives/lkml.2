Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab2DOWhj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 18:37:39 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50720 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab2DOWhi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 18:37:38 -0400
MIME-Version: 1.0
In-Reply-To: <1334529245-14385-1-git-send-email-jonas@southpole.se>
References: <1334507752.2723.3.camel@lorien2>
	<1334529245-14385-1-git-send-email-jonas@southpole.se>
Date: Mon, 16 Apr 2012 00:37:37 +0200
Message-ID: <CACM3HyFjgLPNmFwJKObuPkjQMT5u3b=4kRC+b9yqeNoTdhgHAA@mail.gmail.com>
Subject: Re: [PATCH 1/1] leds: add "kickable" LED trigger
From: Jonas Bonn <jonas.bonn@gmail.com>
To: Jonas Bonn <jonas@southpole.se>
Cc: shuahkhan@gmail.com, akpm@linux-foundation.org, neilb@suse.de,
        linux-kernel@vger.kernel.org, richard.purdie@linuxfoundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm... I think I messed up the --in-reply-to parameter to git
send-email.  This is in reply to the
"LEDS-One-Shot-Timer-Trigger-implementation" thread.

Sorry about that.

/Jonas

On 16 April 2012 00:34, Jonas Bonn <jonas@southpole.se> wrote:
>
> This LED trigger allows userspace to "kick" the LED so that it illuminates
> for a short period of time.  That period is currently hard-coded to
> 200 ms, but that can be easily fixed by adding a sysfs attribute for
> the illumination time.
>
> The original motivation for this trigger was to provide a way for
> userspace to provide an activity indicator for data sent/received on a
> serial bus, along the lines of a network activity indicator on a NIC.
>
> Signed-off-by: Jonas Bonn <jonas@southpole.se>
> ---
>
> Hi,
>
> I just stumbled across this mail thread today.  I've got this trigger
> that we've been using in another project that seems to fit the bill
> here.  It should just be a matter of adding a sysfs attribute to set
> the "illumination" duration to get what you need for the vibrator interface.
>
> The interface is simple enough.  You set the LED (vibrator) trigger to
> "kickable" and then you get a file "kick" in the sysfs directory for
> the led.  Any time you write to that file, the illumination timer is
> reset so that the LED shines for the next 200ms.  If the LED is not
> kicked within 200 ms, the LED is extinguished.
>
> Feel free to modify this to fit your needs.
>
> Caveat:  I haven't even compile tested this on a recent kernel... we've
> been using this on a 2.6.32 kernel.  As far as I know, though, the LED
> interfaces haven't changed recently, so this is probably usable as it.
>
> Best regards,
> Jonas
>
>  drivers/leds/ledtrig-kickable.c |  111 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 111 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/leds/ledtrig-kickable.c
>
> diff --git a/drivers/leds/ledtrig-kickable.c b/drivers/leds/ledtrig-kickable.c
> new file mode 100644
> index 0000000..50699b1
> --- /dev/null
> +++ b/drivers/leds/ledtrig-kickable.c
> @@ -0,0 +1,111 @@
> +/*
> + * LED Kernel "Kickable" Trigger
> + *
> + * Copyright 2012 Jonas Bonn <jonas@southpole.se>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This is a simple trigger that provides a file 'kick' for the LED's
> + * userspace interface.  Writing anything to the 'kick' file causes the
> + * LED to illuminate for 200 ms.  Everytime the LED is 'kicked', its
> + * timer is reset to a full 200 ms.
> + *
> + * This can be used as an activity indicator for userspace processes.
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
> +struct kickable_trig_data {
> +       struct timer_list timer;
> +};
> +
> +static void led_kickable_function(unsigned long data)
> +{
> +       struct led_classdev *led_cdev = (struct led_classdev *) data;
> +
> +       led_set_brightness(led_cdev, LED_OFF);
> +}
> +
> +static ssize_t kick_store(struct device *dev,
> +               struct device_attribute *attr, const char *buf, size_t size)
> +{
> +       struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +       struct kickable_trig_data *kdata = led_cdev->trigger_data;
> +       unsigned long delay = 0;
> +
> +       delay = msecs_to_jiffies(200);
> +
> +       mod_timer(&kdata->timer, jiffies + delay);
> +
> +       led_set_brightness(led_cdev, LED_FULL);
> +
> +       return size;
> +}
> +
> +static DEVICE_ATTR(kick, 0200, NULL, kick_store);
> +
> +static void kickable_trig_activate(struct led_classdev *led_cdev)
> +{
> +       struct kickable_trig_data *kickable_data;
> +       int rc;
> +
> +       kickable_data = kzalloc(sizeof(*kickable_data), GFP_KERNEL);
> +       if (!kickable_data)
> +               return;
> +
> +       led_cdev->trigger_data = kickable_data;
> +       setup_timer(&kickable_data->timer,
> +                   led_kickable_function, (unsigned long) led_cdev);
> +
> +
> +       rc = device_create_file(led_cdev->dev, &dev_attr_kick);
> +       if (rc)
> +               return;
> +
> +       led_set_brightness(led_cdev, LED_OFF);
> +}
> +
> +static void kickable_trig_deactivate(struct led_classdev *led_cdev)
> +{
> +       struct kickable_trig_data *kdata = led_cdev->trigger_data;
> +
> +       if (kdata) {
> +               del_timer_sync(&kdata->timer);
> +               kfree(kdata);
> +               device_remove_file(led_cdev->dev, &dev_attr_kick);
> +       }
> +
> +       led_set_brightness(led_cdev, LED_OFF);
> +}
> +
> +static struct led_trigger kickable_led_trigger = {
> +       .name     = "kickable",
> +       .activate = kickable_trig_activate,
> +       .deactivate = kickable_trig_deactivate,
> +};
> +
> +static int __init kickable_trig_init(void)
> +{
> +       return led_trigger_register(&kickable_led_trigger);
> +}
> +
> +static void __exit kickable_trig_exit(void)
> +{
> +       led_trigger_unregister(&kickable_led_trigger);
> +}
> +
> +module_init(kickable_trig_init);
> +module_exit(kickable_trig_exit);
> +
> +MODULE_AUTHOR("Jonas Bonn <jonas@southpole.se>");
> +MODULE_DESCRIPTION("Kickable LED trigger");
> +MODULE_LICENSE("GPL");
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Jonas Bonn
Stockholm, Sweden
