Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab1BNSFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:05:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35820 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1BNSFC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:05:02 -0500
MIME-Version: 1.0
In-Reply-To: <1297705520.965.5657.camel@petert>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
 <1297698493.965.5475.camel@petert> <20110214170812.6f54a4bb@lxorguk.ukuu.org.uk>
 <AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com> <1297705520.965.5657.camel@petert>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 14 Feb 2011 11:04:41 -0700
X-Google-Sender-Auth: tzWNh1Oj5CXV4RR4Yqp_oJvUE40
Message-ID: <AANLkTin7gBNBXKCuwL6Az+-+KQEw8Hsq-DYYr1RTXhFm@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpiolib: Add ability to get GPIO pin direction
To: Peter Tyser <ptyser@xes-inc.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        "Uwe Kleine-K?nig" <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 10:45 AM, Peter Tyser <ptyser@xes-inc.com> wrote:
>> > We need four states for a gpio pin direction though. A pin can be
>> >
>> > - input
>> > - output
>>
>> There are actually multiple output modes that a specific gpio
>> controller could implement, but the gpio api only has a boolean
>> understanding of output.  I don't know if it is really worthwhile to
>> try and encode all the possible configurations in this API.
>>
>> > - unknown (hardware lacks get functionality and it has not been set by
>> >  software yet)
>
> I'm not sure how we could handle unknown directions in a better way.  We
> really should know the direction by this point for most (all?) GPIO
> chips.  I'd think the proper fix would be to make sure we can detect a
> direction for all chips - either by reading hardware bits or by having
> the platform code let us know (eg pdata->n_latch in pcf857x.c).  If you
> have a suggestion about how unknown pins should be used, I can look into
> it and submit a follow up patch.

Does it really matter?  Sure it's *nice* to have the current status
information if the driver can easily get it, but it probably isn't
critical.  Any user of the pin should be putting the pin in the mode
it needs regardless of the initial state.

>
>> > - alt_func (pin is in use for some other purpose)
>>
>> What is the use-case for alt_func?  From the point of view of a GPIO
>> driver, I don't think it cares if the pin has been dedicated to
>> something else.  It can twiddle all it wants, but if the pin is routed
>> to something else then it won't have any external effects (pin mux is
>> often a separate logic block from the gpio controller).  Also with
>> GPIOs, the engineers fiddling with them *really* needs to know what
>> the gpios are routed to.  It is highly unlikely to have any kind of
>> automatic configuration of gpios; ie. if it isn't wired as a gpio,
>> then don't go twiddling it.
>
> Additionally, for this case I thought the low level GPIO driver should
> implement a request() function to prevent a non-GPIO pin from being used
> in the first place.  Eg like chip_gpio_request() in cs5535-gpio.c, or
> ichx_gpio_request() in patch 3 of this series.

Yes, *if* a driver has the knowledge that a pin is unusable, then it
should not allow the pin to be requested.

g.
