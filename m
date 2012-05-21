Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2EUI0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:26:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38054 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2EUI03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:26:29 -0400
Date: Mon, 21 May 2012 10:26:26 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [PATCH] ARM: leds: Add MAX6956 driver
Message-ID: <20120521082626.GG3710@pengutronix.de>
References: <1337355945-16421-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <CAK5ve-J8EfvgsO8_RYFub8R1fwBgzkjnq3czECRQzpnpvaXEQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK5ve-J8EfvgsO8_RYFub8R1fwBgzkjnq3czECRQzpnpvaXEQw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On Mon, May 21, 2012 at 12:50:12PM +0800, Bryan Wu wrote:
> This patch looks quite nice to me, just some comments as below.
\o/

> On Fri, May 18, 2012 at 11:45 PM, Uwe Kleine-König
> <u.kleine-koenig@pengutronix.de> wrote:
> > This adds a driver for Maxim's MAX6956 28-Port LED Display Driver and
> > I/O Expander.
>
> MAX6956 is a MFD for LED + GPIO. and most of this driver are adding an
> new gpiochip driver. Is that possible we split these 2 functions into
> 2 drivers?
IMHO this is only sensible if these functions are seperated in the
register space, too. So yes, it would be possible, but it would make the
led driver just a set of one-line-functions and increase the overall
code size (souce and binary). There are other examples in the tree that
combine LED and GPIO driver in one file. (I used leds-pca9532 as
reference, didn't check the others.)
 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> >  drivers/leds/Kconfig                       |   10 +
> >  drivers/leds/Makefile                      |    1 +
> >  drivers/leds/leds-max6956.c                |  359 ++++++++++++++++++++++++++++
> >  include/linux/platform_data/leds-max6956.h |   17 ++
> >  4 files changed, 387 insertions(+)
> >  create mode 100644 drivers/leds/leds-max6956.c
> >  create mode 100644 include/linux/platform_data/leds-max6956.h
> >
> > diff --git a/drivers/leds/leds-max6956.c b/drivers/leds/leds-max6956.c
> > new file mode 100644
> > index 0000000..976ed91
> > --- /dev/null
> > +++ b/drivers/leds/leds-max6956.c
> > @@ -0,0 +1,359 @@
> > +/*
> > + * Maxim 28-Port LED Display Driver and I/O Expander
> > + *
> > + * Copyright (C) 2012 Pengutronix
> > + * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it under
> > + * the terms of the GNU General Public License version 2 as published by the
> > + * Free Software Foundation.
> > + *
> > + * Datasheet: http://datasheets.maxim-ic.com/en/ds/MAX6956.pdf
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/i2c.h>
> > +#include <linux/slab.h>
> > +#include <linux/leds.h>
> > +#include <linux/input.h>
> > +#include <linux/mutex.h>
> > +#include <linux/leds-pca9532.h>
> 
> I think we need move all these platform data headers into
> include/linux/platform_data/ as you did below. Anyway, I will take
> care of this.
> Wait, why do you need this header file in your driver? I failed to see
> any usage of it here.
It seems I copy and pasted one #include line too much from the pca9532
driver. I'll remove it in v2.

> > +#include <linux/gpio.h>
> > +#include <linux/regmap.h>
> > +
> > +#include <linux/platform_data/leds-max6956.h>
> > +
> > +#define MAX6956_REG_GLOBAL_CURRENT             0x02
> > +#define MAX6956_REG_CONFIGURATION              0x04
> > +#define MAX6956_REG_CONFIGURATION_S                    0x01
> > +#define MAX6956_REG_CONFIGURATION_I                    0x40
> > +#define MAX6956_REG_CONFIGURATION_M                    0x80
> > +#define MAX6956_REG_TRANSITION_DETECT_MASK     0x06
> > +#define MAX6956_REG_DISPLAY_TEST               0x07
> > +/*
> > + * MAX6956_REG_PORT_CONFIGURATION(i) holds the configuration for ports
> > + * 4 * i, 4 * i + 1, ..., 4 * i + 3 for i in [1, ... 7].
> > + */
> > +#define MAX6956_REG_PORT_CONFIGURATION(i)      (0x08 + (i))
> > +#define MAX6956_REG_PORT_CONFIGURATION_LED             0x0
> > +#define MAX6956_REG_PORT_CONFIGURATION_GPIOOUT         0x1
> > +#define MAX6956_REG_PORT_CONFIGURATION_GPIOINPULLUP    0x2
> > +#define MAX6956_REG_PORT_CONFIGURATION_GPIOIN          0x3
> > +/*
> > + * MAX6956_REG_CURRENT(i) holds the current for segments 2 * i, 2 * i + 1 for i
> > + * in [2, .. 15].
> 
> Looks like it should be [2, ... 15].
right.

> > +static void max6956_led_work(struct work_struct *work)
> > +{
> > +       struct max6956_led_ddata *lddata = lddata_from_work(work);
> > +       struct led_classdev *led_cdev = &lddata->cdev;
> > +
> > +       struct max6956_ddata *ddata = ddata_from_led_cdev(led_cdev);
> > +
> > +       BUG_ON(&ddata->leds[lddata->offset] != lddata);
> > +
> > +       if (!lddata->brightness) {
> > +               regmap_write(ddata->regmap,
> > +                               MAX6956_REG_PORT(lddata->offset), 0);
> > +       } else {
> > +               max6956_set_sink_current(ddata, lddata->offset,
> > +                               lddata->brightness);
> > +               regmap_write(ddata->regmap,
> > +                               MAX6956_REG_PORT(lddata->offset), 1);
> > +       }
> > +       max6956_portconfig_set(ddata, lddata->offset, 0);
> > +}
> > +
> 
> I believe we might need some locking here to protect this critical
> region, like mutex_lock().
Right, I thought about that, too and intended to ask when submitting the
patch. As regmap_update_bits et al. doesn't do locking, I'll add that in
v2.
 
> > +       ddata = devm_kzalloc(&client->dev, sizeof(*ddata), GFP_KERNEL);
> > +       if (!ddata) {
> > +               dev_err(&client->dev, "Failed to allocate driver private data\n");
> > +               return -ENOMEM;
> > +       }
> > +
> > +       ddata->dev = &client->dev;
> > +       ddata->regmap = devm_regmap_init_i2c(client, &max6956_regmap_config);
> > +       if (IS_ERR(ddata->regmap)) {
> > +               ret = PTR_ERR(ddata->regmap);
> > +               dev_err(ddata->dev, "Failed to allocate register map: %d\n",
> > +                               ret);
> > +               return ret;
> 
> As Shuah said, no kfree(ddata) here
As Sascha said, it would be wrong to add one.
 
> > +       }

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
