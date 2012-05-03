Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2ECQg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 12:36:28 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35475 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab2ECQgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 12:36:22 -0400
Date: Thu, 3 May 2012 18:36:17 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 2/4] iio: add LM3533 ambient light sensor driver
Message-ID: <20120503163617.GD15752@localhost>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-3-git-send-email-jhovold@gmail.com>
 <4FA26E9A.8080209@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA26E9A.8080209@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 12:40:10PM +0100, Jonathan Cameron wrote:
> On 5/3/2012 11:26 AM, Johan Hovold wrote:
> > Add sub-driver for the ambient light sensor interface on National
> > Semiconductor / TI LM3533 lighting power chips.
> >
> > The sensor interface can be used to control the LEDs and backlights of
> > the chip through defining five light zones and three sets of
> > corresponding brightness target levels.
> >
> > The driver provides raw and mean adc readings along with the current
> > light zone through sysfs. A threshold event can be generated on zone
> > changes.
> Code is fine.  Pretty much all my comments are to do with the interface.

[...]

> > diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light-lm3533-als b/drivers/staging/iio/Documentation/sysfs-bus-iio-light-lm3533-als
> > new file mode 100644
> > index 0000000..9849d14
> > --- /dev/null
> > +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light-lm3533-als
> > @@ -0,0 +1,62 @@
> > +What:		/sys/bus/iio/devices/iio:deviceX/gain
> > +Date:		April 2012
> > +KernelVersion:	3.5
> > +Contact:	Johan Hovold<jhovold@gmail.com>
> > +Description:
> > +		Set the ALS gain-resistor setting (0..127) for analog input
> > +		mode, where
> > +
> > +		0000000 - ALS input is high impedance
> > +		0000001 - 200kOhm (10uA at 2V full-scale)
> > +		0000010 - 100kOhm (20uA at 2V full-scale)
> > +		...
> > +		1111110 - 1.587kOhm (1.26mA at 2V full-scale)
> > +		1111111 - 1.575kOhm (1.27mA at 2V full-scale)
> > +
> > +		R_als = 2V / (10uA * gain)	(gain>  0)
> Firstly, no magic numbers.  These are definitely magic.

Not that magic as they're clearly documented (in code and public
datasheets), right? What would you prefer instead?

> Secondly see
> in_illuminance0_scale for a suitable existing attribute.

I didn't consider scale to be appropriate given the following
documentation (e.g, for in_voltageY_scale):

"If known for a device, scale to be applied to <type>Y[_name]_raw post
addition of <type>[Y][_name]_offset in order to obtain the measured
value in <type> units as specified in <type>[Y][_name]_raw
documentation."

That is, the gain setting has nothing to do with scaling the raw adc
reading to SI-units or such, it's simply a setup dependent gain setting
(which affects the raw readings as well). [And as such, should probably
go into to the platform data eventually as well.]

> > +
> > +What:		/sys/bus/iio/devices/iio:deviceX/illuminance_zone
> > +Date:		April 2012
> > +KernelVersion:	3.5
> > +Contact:	Johan Hovold<jhovold@gmail.com>
> > +Description:
> > +		Get the current light zone (0..4) as defined by the
> > +		in_illuminance_thresh[n]_{falling,rising} thresholds.
> Hmm.. definitely have an in prefix, beyond that I'm not sure what the 
> cleanest

Thanks for catching this, it's a typo in the sysfs document -- the in_
prefix is in the code.

> interface will be for this.   Could extend the event codes to deal with the
> zone index.  Slightly tricky as the channel could already be modified so
> chan2 isn't necesarily available.
>
> > +
> > +What:		/sys/.../events/in_illuminance_thresh_either_en
> > +Date:		April 2012
> > +KernelVersion:	3.5
> > +Contact:	Johan Hovold<jhovold@gmail.com>
> > +Description:
> > +		Event generated when channel passes one of the four threshold
> > +		in either direction (rising|falling) and a zone change occurs.
> > +		The corresponding light zone can be read from
> > +		illuminance_zone.
> > +
> > +What:		/sys/.../events/illuminance_thresh0_falling_value
> hmm.. every time you think you are making progress a new and exciting 
> device comes
> along requiring the abi to be extended.

Exciting isn't it. :)

> in_illuminanceX_threshY_rising_value
> in_illuminanceX_threshY_falling_value
> should do with appropriate description.

Ok.

> > +What:		/sys/.../events/illuminance_thresh0_raising_value
> > +What:		/sys/.../events/illuminance_thresh1_falling_value
> > +What:		/sys/.../events/illuminance_thresh1_raising_value
> > +What:		/sys/.../events/illuminance_thresh2_falling_value
> > +What:		/sys/.../events/illuminance_thresh2_raising_value
> > +What:		/sys/.../events/illuminance_thresh3_falling_value
> > +What:		/sys/.../events/illuminance_thresh3_raising_value
> > +Date:		April 2012
> > +KernelVersion:	3.5
> > +Contact:	Johan Hovold<jhovold@gmail.com>
> > +Description:
> > +		Specifies the value of threshold that the device is comparing
> > +		against for the events enabled by
> > +		in_illuminance_thresh_either_en, and defines the
> > +		the five light zones.
> > +
> > +		These thresholds correspond to the eight zone-boundary
> > +		registers (boundary[n]_{low,high}).
> > +
> This interface is going to take some thought.  We have 
> in_illuminance0_target at the
> moment, so I guess we can add a zoning concept to that...

But target isn't really related, as far as I understand. That's another
calibration setting right? While zone is derived from the average adc
readings. (More below.)

> > +What:		/sys/bus/iio/devices/iio:deviceX/target[m]_[n]
> > +Date:		April 2012
> > +KernelVersion:	3.5
> > +Contact:	Johan Hovold<jhovold@gmail.com>
> > +Description:
> > +		Set the target brightness for ALS-mapper m in light zone n
> > +		(0..255), where m in 1..3 and n in 0..4.
> Don't suppose you could do a quick summary of what these zones are and 
> why there
> are 3 ALS-mappers?  I'm not getting terribly far on a quick look at the 
> datasheet!

Of course. The average adc readings are mapped to five light zones using
eight zone boundary registers (4 boundaries with hysteresis) and a set
of rules.

To simplify somewhat (by ignoring some of the rules): If the average
adc input drops below boundary0_low, the zone register reads 0; if it
drops below boundary1_low, it reads 1, and so on. If the input it
increases over boundary3_high, the zone register return 4; if it
increases passed boundary2_high, it returns zone 3, etc.

That is, roughly something like (we get 8-bits of input from the ADC): 

	zone 0

boundary0_low	51
boundary0_high	53

	zone 1

boundary1_low	102
boundary1_high	106

	zone 2

boundary2_low	153
boundary2_high	161

	zone 3

boundary3_low	204
boundary3_high	220

	zone 4

[ Figure 6 on page 20 in the datasheets should make it clear. ]

The ALS interface and it's zone concept can then be used to control the
LEDs and backlights of the chip, by determining the target brightness for
each zone, e.g., set brightness to 52 when in zone 0.

To complicate things further (and it is complicated), there are three
such sets of target brightness values: ALSM1, ALSM2, ALSM3.

So for each LED or backlight you can set ALS-input control mode, by
saying that the device should get it's brightness levels from target set
1, 2, or 3.

[ And it gets even more complicated, as ALSM1 can only control
  backlight0, where as ALSM2 and ALSM3 can control any of the remaining
  devices, but that's irrelevant here. ]

Initially, I thought this interface to be too esoteric to be worth 
generalising, but it sort of fits with event thresholds so I gave it a
try. The biggest conceptual problem, I think, is that the zone
boundaries can be used to control the other devices, even when the event
is not enabled (or even an irq line not configured). That is, I find it
a bit awkward that the event thresholds also defines the zones (a sort of
discrete scaling factor). 

Perhaps simply keeping the attributes outside of events (e.g. named
boundary[n]_{low,high}) and having a custom event enabled (e.g.
in_illuminance_zone_change_en) is the best solution?

[...]

> > diff --git a/drivers/staging/iio/light/lm3533-als.c b/drivers/staging/iio/light/lm3533-als.c
> > new file mode 100644
> > index 0000000..e2c9be6
> > --- /dev/null
> > +++ b/drivers/staging/iio/light/lm3533-als.c
> > @@ -0,0 +1,617 @@
> > +/*
> > + * lm3533-als.c -- LM3533 Ambient Light Sensor driver
> > + *
> > + * Copyright (C) 2011-2012 Texas Instruments
> > + *
> > + * Author: Johan Hovold<jhovold@gmail.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under  the terms of the GNU General  Public License as published by the
> > + * Free Software Foundation;  either version 2 of the License, or (at your
> > + * option) any later version.
> > + */
> > +
> > +#include<linux/atomic.h>
> > +#include<linux/fs.h>
> > +#include<linux/interrupt.h>
> > +#include<linux/io.h>
> > +#include<linux/module.h>
> > +#include<linux/mfd/core.h>
> > +#include<linux/platform_device.h>
> > +#include<linux/slab.h>
> > +#include<linux/uaccess.h>
> > +
> > +#include<linux/mfd/lm3533.h>
> > +
> > +#include "../events.h"
> > +#include "../iio.h"
> This will need to go through the staging-next tree.  In there these
> headers have moved.

I'm aware of the move. Should the different sub-drivers go in through
each tree respectively? Right now the four patches are all against rc5.

[...]

> > +static const struct iio_chan_spec lm3533_als_channels[] = {
> > +	{
> > +		.type = IIO_LIGHT,
> > +		.info_mask = IIO_CHAN_INFO_AVERAGE_RAW_SEPARATE_BIT,
> > +		.channel = 0,
> channel doesn't get used unless you also set indexed = 1.

So, you mean I could drop channel as well? Or should I add indexed, as I
use channel 0 when reporting the event?

[...]

> > +static int lm3533_als_set_int_mode(struct iio_dev *indio_dev, int enable)
> > +{
> > +	struct lm3533_als *als = iio_priv(indio_dev);
> > +	u8 mask = LM3533_ALS_INT_ENABLE_MASK;
> > +	u8 val;
> > +	int ret;
> > +
> > +	if (enable)
> > +		val = mask;
> > +	else
> > +		val = 0;
> > +
> > +	ret = lm3533_update(als->lm3533, LM3533_REG_ALS_ZONE_INFO, val, mask);
> > +	if (ret) {
> > +		dev_err(&indio_dev->dev, "failed to set int mode %d\n",
> > +								enable);
> extra brackets.

I prefer the brackets for multi-line (single) statements even though
they are not required. (Especially if the single statement spans
several lines -- but I try to be consistent.) If you have a strong
opinion about this, I'll drop them.

> > +	}
> > +
> > +	return ret;
> > +}
> > +

Thanks,
Johan
