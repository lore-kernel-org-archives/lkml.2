Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773Ab1ESRmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:42:51 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11886 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933628Ab1ESRmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:42:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 19 May 2011 10:42:38 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 19 May 2011 10:42:36 -0700
Subject: RE: [PATCH] drivers: create a pinmux subsystem v2
Thread-Topic: [PATCH] drivers: create a pinmux subsystem v2
Thread-Index: AcwVHwzP8HfSiB5yThGjIBB2wvBs+wBKztdA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF0498A47C0C@HQMAIL01.nvidia.com>
References: <1305070783-23193-1-git-send-email-linus.walleij@linaro.org>
	<74CDBE0F657A3D45AFBB94109FB122FF04986AA6A2@HQMAIL01.nvidia.com>
	<BANLkTi=wTB6R8vjHVAWM3T0e5HjOq77tdA@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04986AAB5F@HQMAIL01.nvidia.com>
 <BANLkTi=0OTUsCvj2fJTKnGiCjqVx=bOHrA@mail.gmail.com>
In-Reply-To: <BANLkTi=0OTUsCvj2fJTKnGiCjqVx=bOHrA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Tuesday, May 17, 2011 11:47 PM:
> 2011/5/17 Stephen Warren <swarren@nvidia.com>:
> > The one remaining thing I don't understand:
> >
> > The board provides a mapping from driver name to pinmux selections.
> > The example documentation includes:
> >
> > +static struct pinmux_map pmx_mapping[] = {
> > +       {
> > +               .function = "spi0-1",
> > +               .dev_name = "foo-spi.0",
> > +       },
> > +       {
> > +               .function = "i2c0",
> > +               .dev_name = "foo-i2c.0",
> > +       },
> > +};
> >
> > I don't think this fits the model of a driver needing to pinmux_get
> > e.g. 1, 2, or 3 pinmux functions. Rather, I think the .function field
> > should be an array of functions needed by the driver:
> >
> > +static struct pinmux_map pmx_mapping[] = {
> > +       {
> > +               .functions = "spi0-1",
> > +               .dev_name = "foo-spi.0",
> > +       },
> > +       {
> > +               .function = "i2c0",
> > +               .dev_name = "foo-i2c.0",
> > +       },
> > +       {
> > +               .function = {"bus0-7:4", "bus0-3:2", "bus0-1:0"},
> > +               .dev_name = "foo-bus.0",
> > +       },
> > +};
> >
> > (obviously that syntax is bogus, but you get the idea)
> >
> > The intent being that the driver could perform single pinmux_get call
> > for "foo-bus.0" and then the subsequent pinmux_enable would enable all 3
> > entries in that device's .function array.
> 
> I think the above usage scenario falls under the category of pinmux
> groups that I detailed in the mail reply to Sascha Hauer earlier in the
> thread, yes I think it makes sense for some scenarios to have
> groups of functions being activated at once, especially on
> system boot/suspend/resume/shutdown actually.

For reference, that is:
https://lkml.org/lkml/2011/5/12/193

> I'm thinking that we can model this on top of the existing functions,
> so that we add new functions like
> 
> pinmux_group_get()
> pinmux_group_enable()
> pinmux_group_disable()
> pinmux_group_put()
> 
> that will invoke all the necessary calls to individual functions
> and also provide an optional hook down to the driver for
> drivers that can mux large groups at once.
> 
> However I think this can be a separate patch on top of the
> current system, so we can start out with what we have.

OK, looking at that email and the above, that API does make general
sense to me.

However, I don't really see the point of exposing separate APIs for
controlling a single pinmux function vs. a whole group of them. When
writing a driver, I just want to pinmux_get_something(),
pinmux_enable_something(), and have _something be the same in all
cases without having to think about it.

So, while drivers for systems with simple pinmuxes can simply pinmux_get
one function, and drivers for more complex systems could pinmux_get N
functions, and then later be converted to pinmux_get_group one group, I
think it'd be a lot better if the pinmux API just hid this all from the
very start, and allowed the SoC's/board's pinmux data definitions to
just expose one thing, and drivers to just get/enable one thing, right
from the start.

To enable simple cases to be simple, perhaps implement it this way:

Initially, pinmux_get/enable/... all operate just on the raw functions
exposed by the SoC-supplied data.

Later, we augment pinmux_get/enable (i.e. not new names) to also work
on groups, if the SoC/board has defined any.

That way, the API that drivers use will not change, but the actual
implementation behind it will go from:

pinmux_get:
  scan function table
  if match, return match
  return NULL

to:

pinmux_get:
  scan function table
  if match, return match
  scan group table
  if match, return match
  return NULL

and similarly, the SoC's pinmux driver's enable/... functions would either
need to accept an entry from either table type, or the core API could grow new
functions for this with the pinmux core performing the appropriate dispatch
based on the type of object passed to pinmux_enable, or the pinmux core
could just loop and call the existing APIs N times when processing a group
rather than a function.

That approach would allow your current changes to be accepted unmodified,
followed by a later driver-transparent change to add support for groups on
top of functions.

Hopefully that functionality would show up pretty quick, since it seems
like a variety of people foresee requiring it.

As an aside, I didn't really follow your discussion about the difference
between describing muxing at the die vs. package level, given I was
talking specifically about slightly different dies where the logic cores
are identical with just pinmux logic changes, not just bound-out changes.
Still, I think if something like the above goes in, any issues I have are
taken care of.

-- 
nvpublic

