Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab2DPP2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:28:47 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:43884 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab2DPP2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:28:46 -0400
Message-ID: <1334590122.2218.4.camel@lorien2>
Subject: Re: [PATCH 1/1] leds: add "kickable" LED trigger
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Jonas Bonn <jonas.bonn@gmail.com>
Cc: shuahkhan@gmail.com, Jonas Bonn <jonas@southpole.se>,
        akpm@linux-foundation.org, neilb@suse.de, linux-kernel@vger.kernel.org,
        richard.purdie@linuxfoundation.org
Date: Mon, 16 Apr 2012 09:28:42 -0600
In-Reply-To: <CACM3HyFjgLPNmFwJKObuPkjQMT5u3b=4kRC+b9yqeNoTdhgHAA@mail.gmail.com>
References: <1334507752.2723.3.camel@lorien2>
	 <1334529245-14385-1-git-send-email-jonas@southpole.se>
	 <CACM3HyFjgLPNmFwJKObuPkjQMT5u3b=4kRC+b9yqeNoTdhgHAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 00:37 +0200, Jonas Bonn wrote:
> Hmm... I think I messed up the --in-reply-to parameter to git
> send-email.  This is in reply to the
> "LEDS-One-Shot-Timer-Trigger-implementation" thread.
> 
> Sorry about that.
> 
> /Jonas

Jonas,

Cool. I got a patch ready yesterday which is very close to yours, except it 
also keeps the state. Thanks for sharing the patch with me. Here is what I 
have. Please take a look and see. I haven't gone through testing yet though.

Thanks,
-- Shuah

>From 3ded425401e5c72dfa161fb4533443bebe287398 Mon Sep 17 00:00:00 2001
From: Shuah Khan <shuahkhan@gmail.com>
Date: Mon, 16 Apr 2012 09:23:03 -0600
Subject: [PATCH] leds: add ledtrig-vibrate


Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 drivers/leds/ledtrig-vibrate.c |  133 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 133 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/ledtrig-vibrate.c

diff --git a/drivers/leds/ledtrig-vibrate.c b/drivers/leds/ledtrig-vibrate.c
new file mode 100644
index 0000000..9354003
--- /dev/null
+++ b/drivers/leds/ledtrig-vibrate.c
@@ -0,0 +1,133 @@
+/*
+ * LED Kernel Vibrate Trigger
+ *
+ * Copyright (C) 2012 Shuah Khan <shuahkhan@gmail.com>
+ *
+ * Based on Richard Purdie's ledtrig-timer.c and Atsushi Nemoto's
+ * ledtrig-heartbeat.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/ctype.h>
+#include <linux/leds.h>
+#include "leds.h"
+
+static struct vibrate_trig_data {
+	unsigned long vbrate_time;
+	bool vibrate_on;
+	struct timer_list timer;
+};
+
+static void vibrate_timer_function(unsigned long data)
+{
+	struct led_classdev *led_cdev = (struct led_classdev *) data;
+	struct vibrate_trig_data *vibrate_data = led_cdev->trigger_data;
+
+	if (vibrate_data->vibrate_on) {
+		del_timer(vibrate_date->timer);
+		vibrate_data->vibrate_on = false;
+		vibrate_data->vibrate_time = 0;
+	}
+}
+
+static ssize_t led_vibrate_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct vibrate_trig_data *vibrate_data = led_cdev->trigger_data;
+
+	return sprintf(buf, "%lu\n", vibrate_data->vibrate_time);
+}
+
+static ssize_t led_vibrate_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct vibrate_trig_data *vibrate_data = led_cdev->trigger_data;
+	unsigned long state;
+	ssize_t ret = -EINVAL;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	/* should there be a default max. cap on the time? */
+	if (!vibrate_data->vibrate_on && !state)
+		vibrate_data->vibrate_time = state;
+		if (!led_cdev->brightness_set)
+			led_cdev->brightness_set(led_cdev, LED_ON);
+		vibrate_data->vibrate_on = true;
+		mod_timer(&vibrate_data->timer, jiffies + state);
+	}
+	/* if vibrate_on is true - then ignore this new request? */
+
+	return size;
+}
+
+static DEVICE_ATTR(vibrate, 0644, led_vibrate_show, led_vibrate_store);
+
+static void vibrate_trig_activate(struct led_classdev *led_cdev)
+{
+	int rc;
+	struct vibrate_trig_data *vibrate_data;
+
+	vibrate_data = kzalloc(sizeof(struct vibrate_trig_data), GFP_KERNEL);
+	if (!vibrate_data) {
+		dev_err(led->dev, "unable to allocate vibrate trigger\n");
+		return;
+	}
+	led_cdev->trigger_data = vibrate_data;
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_vibrate);
+	if (rc) {
+		dev_err(led->dev, "unable to register vibrate trigger\n");
+		led_cdev->trigger_data = NULL;
+		kfree(vibrate_data);
+	}
+	setup_timer(&vibrate_data->timer, vibrate_timer_function,
+		    (unsigned long) led_cdev);
+	/* vibrate_timer_function(vibrate_data); */
+}
+
+static void vibrate_trig_deactivate(struct led_classdev *led_cdev)
+{
+	struct vibrate_trig_data *vibrate_data = led_cdev->trigger_data;
+
+	if (vibrate_data) {
+		device_remove_file(led_cdev->dev, &dev_attr_vibrate);
+		del_timer_sync(&vibrate_data->timer);
+		led_cdev->trigger_data = NULL;
+		kfree(vibrate_data);
+	}
+}
+
+static struct led_trigger vibrate_trigger = {
+	.name     = "vibrate",
+	.activate = vibrate_trig_activate,
+	.deactivate = vibrate_trig_deactivate,
+};
+
+static int __init vibrate_trig_init(void)
+{
+	return led_trigger_register(&vibrate_led_trigger);
+}
+
+static void __exit vibrate_trig_exit(void)
+{
+	led_trigger_unregister(&vibrate_led_trigger);
+}
+
+module_init(vibrate_trig_init);
+module_exit(vibrate_trig_exit);
+
+MODULE_AUTHOR("Shuah Khan <shuahkhan@gmail.com>");
+MODULE_DESCRIPTION("vibrate LED trigger");
+MODULE_LICENSE("GPL");
-- 
1.7.5.4



> 
> On 16 April 2012 00:34, Jonas Bonn <jonas@southpole.se> wrote:
> >
> > This LED trigger allows userspace to "kick" the LED so that it illuminates
> > for a short period of time.  That period is currently hard-coded to
> > 200 ms, but that can be easily fixed by adding a sysfs attribute for
> > the illumination time.
> >
> > The original motivation for this trigger was to provide a way for
> > userspace to provide an activity indicator for data sent/received on a
> > serial bus, along the lines of a network activity indicator on a NIC.
> >
> > Signed-off-by: Jonas Bonn <jonas@southpole.se>
> > ---
> >
> > Hi,
> >
> > I just stumbled across this mail thread today.  I've got this trigger
> > that we've been using in another project that seems to fit the bill
> > here.  It should just be a matter of adding a sysfs attribute to set
> > the "illumination" duration to get what you need for the vibrator interface.
> >
> > The interface is simple enough.  You set the LED (vibrator) trigger to
> > "kickable" and then you get a file "kick" in the sysfs directory for
> > the led.  Any time you write to that file, the illumination timer is
> > reset so that the LED shines for the next 200ms.  If the LED is not
> > kicked within 200 ms, the LED is extinguished.
> >
> > Feel free to modify this to fit your needs.
> >
> > Caveat:  I haven't even compile tested this on a recent kernel... we've
> > been using this on a 2.6.32 kernel.  As far as I know, though, the LED
> > interfaces haven't changed recently, so this is probably usable as it.
> >
> > Best regards,
> > Jonas
> >
> >  drivers/leds/ledtrig-kickable.c |  111 +++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 111 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/leds/ledtrig-kickable.c
> >
> > diff --git a/drivers/leds/ledtrig-kickable.c b/drivers/leds/ledtrig-kickable.c
> > new file mode 100644
> > index 0000000..50699b1
> > --- /dev/null
> > +++ b/drivers/leds/ledtrig-kickable.c
> > @@ -0,0 +1,111 @@
> > +/*
> > + * LED Kernel "Kickable" Trigger
> > + *
> > + * Copyright 2012 Jonas Bonn <jonas@southpole.se>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This is a simple trigger that provides a file 'kick' for the LED's
> > + * userspace interface.  Writing anything to the 'kick' file causes the
> > + * LED to illuminate for 200 ms.  Everytime the LED is 'kicked', its
> > + * timer is reset to a full 200 ms.
> > + *
> > + * This can be used as an activity indicator for userspace processes.
> > + *
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> > +#include <linux/init.h>
> > +#include <linux/device.h>
> > +#include <linux/ctype.h>
> > +#include <linux/leds.h>
> > +#include "leds.h"
> > +
> > +struct kickable_trig_data {
> > +       struct timer_list timer;
> > +};
> > +
> > +static void led_kickable_function(unsigned long data)
> > +{
> > +       struct led_classdev *led_cdev = (struct led_classdev *) data;
> > +
> > +       led_set_brightness(led_cdev, LED_OFF);
> > +}
> > +
> > +static ssize_t kick_store(struct device *dev,
> > +               struct device_attribute *attr, const char *buf, size_t size)
> > +{
> > +       struct led_classdev *led_cdev = dev_get_drvdata(dev);
> > +       struct kickable_trig_data *kdata = led_cdev->trigger_data;
> > +       unsigned long delay = 0;
> > +
> > +       delay = msecs_to_jiffies(200);
> > +
> > +       mod_timer(&kdata->timer, jiffies + delay);
> > +
> > +       led_set_brightness(led_cdev, LED_FULL);
> > +
> > +       return size;
> > +}
> > +
> > +static DEVICE_ATTR(kick, 0200, NULL, kick_store);
> > +
> > +static void kickable_trig_activate(struct led_classdev *led_cdev)
> > +{
> > +       struct kickable_trig_data *kickable_data;
> > +       int rc;
> > +
> > +       kickable_data = kzalloc(sizeof(*kickable_data), GFP_KERNEL);
> > +       if (!kickable_data)
> > +               return;
> > +
> > +       led_cdev->trigger_data = kickable_data;
> > +       setup_timer(&kickable_data->timer,
> > +                   led_kickable_function, (unsigned long) led_cdev);
> > +
> > +
> > +       rc = device_create_file(led_cdev->dev, &dev_attr_kick);
> > +       if (rc)
> > +               return;
> > +
> > +       led_set_brightness(led_cdev, LED_OFF);
> > +}
> > +
> > +static void kickable_trig_deactivate(struct led_classdev *led_cdev)
> > +{
> > +       struct kickable_trig_data *kdata = led_cdev->trigger_data;
> > +
> > +       if (kdata) {
> > +               del_timer_sync(&kdata->timer);
> > +               kfree(kdata);
> > +               device_remove_file(led_cdev->dev, &dev_attr_kick);
> > +       }
> > +
> > +       led_set_brightness(led_cdev, LED_OFF);
> > +}
> > +
> > +static struct led_trigger kickable_led_trigger = {
> > +       .name     = "kickable",
> > +       .activate = kickable_trig_activate,
> > +       .deactivate = kickable_trig_deactivate,
> > +};
> > +
> > +static int __init kickable_trig_init(void)
> > +{
> > +       return led_trigger_register(&kickable_led_trigger);
> > +}
> > +
> > +static void __exit kickable_trig_exit(void)
> > +{
> > +       led_trigger_unregister(&kickable_led_trigger);
> > +}
> > +
> > +module_init(kickable_trig_init);
> > +module_exit(kickable_trig_exit);
> > +
> > +MODULE_AUTHOR("Jonas Bonn <jonas@southpole.se>");
> > +MODULE_DESCRIPTION("Kickable LED trigger");
> > +MODULE_LICENSE("GPL");
> > --
> > 1.7.0.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 


