Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1EIPRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:17:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54643 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750879Ab1EIPRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:17:10 -0400
Date: Mon, 9 May 2011 17:17:14 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Liam Girdwood <lrg@kernel.org>, Graeme Gregory <gg@slimlogic.co.uk>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Subject: Re: [PATCH 4/4] USB: TWL6025 allow different regulator name
Message-ID: <20110509151714.GH3225@opensource.wolfsonmicro.com>
References: <1303897191-14792-5-git-send-email-gg@slimlogic.co.uk>
 <20110427104542.GZ13227@legolas.emea.dhcp.ti.com>
 <1304867317.3246.10.camel@odin>
 <20110509090335.GC1254@legolas.emea.dhcp.ti.com>
 <1304941430.3192.4.camel@odin>
 <20110509121600.GK1254@legolas.emea.dhcp.ti.com>
 <20110509122941.GA3225@opensource.wolfsonmicro.com>
 <20110509130703.GM1254@legolas.emea.dhcp.ti.com>
 <20110509133542.GF3225@opensource.wolfsonmicro.com>
 <20110509135122.GQ1254@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110509135122.GQ1254@legolas.emea.dhcp.ti.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 04:51:26PM +0300, Felipe Balbi wrote:
> On Mon, May 09, 2011 at 03:35:43PM +0200, Mark Brown wrote:

> > -	twl->usb3v3 = regulator_get(twl->dev, "vusb");
> > +	twl->usb3v3 = regulator_get(twl->dev, regulator_name);
> >  	if (IS_ERR(twl->usb3v3))
> >  		return -ENODEV;

> then, imagine 5 years from now how that branch will look. How long do
> you think it'll take until someone decides to pass that name via
> platform_data to avoid growing that conditional ?

Probably way more than five years; frankly someone needs to yell at
whoever wrote the documentation and point out to them that VBUS is a
well known name that came from the spec.

In this particular case we actually shouldn't be worry about this at all
as it turns out that the consumer and supply are both internal to the
chip and hard wired together with no external users (the
regulator_init_data is part of the twl core not the board) so we
shouldn't be making this visible outside the drivers in the first place,
the name is totally irrelevant to anything except the twl drivers.  The
name is much more important if someone mapping out the regulators on a
board has to worry about it.

> > > We pass in the data of how regulators are wired at the board level and
> > > drivers would regulator_get(my_dev->dev, "whatever fancy name I want as
> > > it doesn't matter at all");

> > No, not at all.  Consumer drivers should be hard coding the strings they
> > request and the strings used should correspond to the pin names used on
> > the device.

> but that's the thing. Why do they need to depend on that string ?

They have to depend on *something* textual.  Even if you change it into
program code it's still going to have to be written down somewhere.

> > As Liam said this will just make the situation worse.  Users will have
> > to figure out what the names the driver authors assigned to the various
> > device supplies map onto in the physical system via an additional layer
> > of indirection which will at best be written down in comments in the
> > driver.

> My point is that the "name" shouldn't matter. Instead of matching a
> "name" match a "reference". Have something earlier in the boot assing
> regulators to devices, or something like that, so that drivers don't
> need to care about "names".

Unfortunately we write computer programs using text and that does rather
mean that things need names eventually, and that's going to have to
include the driver since whatever else does the mapping is going to need
to figure out what the driver is using to refer to a given regulator.

At some point these magic references are going to have to come from a
human in some form the human has a hope of comprehending.  The names
aren't really for the benefit of the driver, they're there so that a
human reading a schematic can work out which regulator to attach to
which supply and produce a mapping which other people can read and
understand.

> > Here you're apparently talking about something different - you're
> > talking about how we pass in the regulator init data for the regulators
> > supplied by the chip.  The patch being discussed changes the consumer
> > side for USB, not the regulator driver side.  The naming on the driver

> see above, how long do you think it'll take for someone to try and pass
> that name via pdata ? On the next name change, this is already likely to
> happen to prevent that conditional from growing.

People try to pass things as platform data all the time, usually as the
first thing they think of because they are having a hard time
distinguishing between the label the rail was given on the board and the
label the chip uses for the supply.  This isn't a problem, we just tell
them not to do that so that people can use the driver on other boards.

> > side is a particular problem for TWL devices since unlike most PMICs the
> > regulators aren't simply numbered but are instead assigned individual
> > names so you can't just use a big array indexed by number.

> why not ? The name shouldn't matter. In anycase, if you look into
> /sys/class/regulator/ all directories are regulator.<index>:

> 	dev_set_name(&rdev->dev, "regulator.%d",
> 		     atomic_inc_return(&regulator_no) - 1);

That's not terribly useful for describing the relationships between
devices as the names come on a first come first served basis and are
therefore not at all stable.  We could try assiging base numbers to the
various regulator drivers but then you end up with a massive legibility
problem as nobody numbers the supplies on devices.

> > > What I was expecting to see, was a mechanism where we define how those
> shouldn't depend on strings at all in order to fetch the correct
> regulator. How many:

> if (xxx_features() & XXX_CLASS_IS_YYYY)
> 	regulator_name = "my_first_name";
> else
> 	regulator_name = "my_second_name";

> will have to pop in drivers until we figure that it won't scale ?

Note that the combination of _features and _CLASS tests here is already
fairly unusual for chips, even before you add on the random name
changes.  I really think you're generalising too much from a rare case
here, and that it's more likely that for most cases where you get a name
change it'll be but one of many changes that need to be accounted for or
you'll just be able to do something fairly straightforward and table
based.

The upshot is that I'm not terribly concerned about this for the chips
we're actually seeing (this is the first time I've seen a device which
just randomly renames one supply at all).  Besides, it's also not like
there's any alternatives on offer here.

Having said all that I do have a patch in the works which should mean
that noddy consumers (not this one) don't need any code or data at all
and can just key off device lifetime and PM events transparently 
