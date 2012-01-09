Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2AIIJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 03:09:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56585 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457Ab2AIIJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 03:09:26 -0500
Date: Mon, 9 Jan 2012 00:08:07 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: NeilBrown <neilb@suse.de>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, MyungJoo Ham <myungjoo.ham@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] Multithread initcalls to auto-resolve ordering
 issues.
Message-ID: <20120109080806.GH22134@opensource.wolfsonmicro.com>
References: <20120109112113.07882ed9@notabene.brown>
 <20120109040802.GG29065@opensource.wolfsonmicro.com>
 <20120109161058.6834da0d@notabene.brown>
 <20120109062231.GM29065@opensource.wolfsonmicro.com>
 <20120109182800.3086fd84@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109182800.3086fd84@notabene.brown>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 06:28:00PM +1100, NeilBrown wrote:
> On Sun, 8 Jan 2012 22:22:31 -0800 Mark Brown
> > On Mon, Jan 09, 2012 at 04:10:58PM +1100, NeilBrown wrote:

> > So, my general inclination is that given the choice between parallel and
> > serial solutions I'll prefer the serial solution on the basis that it's
> > most likely going to be easier to think about and less prone to getting
> > messed up.

> Surely anyone doing kernel work needs to be able to understand parallel
> solutions at least enough to place locks in appropriate places ???

You'd expect people to be able to work it out but there's no sense in
doing something hard if something easy works just as well - concurrency
can bring problems with things like reproducibility which make life
harder than it might otherwise be.

> I thought about doing a serial retry solution the error from the ->probe
> function doesn't percolate all the way up the the initcall.
> In particular, when a driver is registered driver_attach is called for each
> unattached device on the bus.  This is done in __driver_attach which discard
> the error return from driver_probe_device().

There's code for doing the retries floating around, Grant Likely was
working on it initially then someone from Linaro picked it up and I'm
not sure what happened.

> > > Completely agree.  I think the key simplification would be for each resource
> > > to have a simple textual name.  Then you could write more common
> > > infrastructure.

> > That's pretty much the case already for most things - the cannonical
> > thing is to look up by (struct device, string).  Squashing everything
> > into a single flat namespace is painful as completely unrelated bits of
> > the system easily collide with each other.  GPIO and IRQ are the only
> > holdouts I can think of in this area.

> I don't see (struct device, string) being used at all.

> Regulator used (devicename, string).  It seems that it used to use (struct
> device, string) but that is deprecated.

The things doing the requesting use the struct device.  The things doing
the mapping use the device name.  The two are equivalent, it's just that
it's hard to write a struct device for many buses prior to probe().

> So strings seem simple.  Each different resource type would be a different
> name space of course.

It's really not that helpful, it's got the same issues as numbers do as
soon as you get two devices of the same type or just two devices using a
common name (lots of devices have clock inputs called CLK or whatever).

> If a particular resource wanted to encourage "devicename-usagetype" that
> would be fine, but requiring "devicename" to be present would be a problem for
> resources (like some IRQs) which are shared between devices...  though I
> guess regulators are shared between devices....  Do we really need the extra
> level of indirection provided by regulator_consumer_supply?  I presume there
> is a good reason.

If we don't do this we have to go through every single driver that wants
to use the API adding platform data where there might've been none
before.  This winds up being a lot more code all round (same as for the
clock API and so on).

> > > or should return -EAGAIN?    There is certainly precedent for that sort of
> > > control.
> > > Or is there something else you think might be needed?

> > I can see a driver wanting something like "either A or B".

> I think you agree with me.  'A' is non-blocking lookup that can fail.
> 'B' is blocking lookup.  That is what I suggested above.

No...

> But when would it ever be safe for a driver to ask for A?  How would it know
> if it isn't available yet it never will be?

...due to this you want the driver to block on (A || B) and not try A
then prefer B as you suggest.

> > > I first tried B but found that devices often ask for regulators that will
> > > never appear, so that didn't work.

> > That should be extremely rare, you're probably working with broken
> > drivers.  The only case I'm aware of is MMC and frankly the way it uses
> > of regulators is more than a little dodgy.

> Yes, MMC is exactly the case I am aware of.  If this usage is "wrong" then I
> guess it needs to be "fixed" before we can proceed.

The general idea is to use regulators unconditionally, and there's also
some issues with the use of regulator_get_exclusive() which isn't
actually what's required.

> > > So I went for C which I agree is a little inelegant and I now see doesn't
> > > handle cases where some dependencies may or may exist depending on the
> > > current hardware.

> > The latter bit is the real killer - you need to know right at the start
> > of boot what you're going to find when you start the system.  An
> > approach that relies on that but does require us to do work to set it up
> > doesn't seem especially useful.

> I must admit that I find this possibility perplexing.
> I can certainly imagine individual independent devices that may or may not
> exists (USB things etc) but there are no dependencies there to worry about.

That's not the case for USB, you often get soldered down USB devices
that have GPIOs and things.

> But if we find a device, and we know that it depends on some resource, and
> that resource is never going to be available - then is there really anything
> useful that can be done?
> Wouldn't it be correct to fail the boot ??

You're missing the point.  If we're enumerating the system at runtime
(for example, by reading ID information from the hardware) then there
may be substantial parts of the system that we don't know the expected
layout and connections of until some point during the boot.  This means
that we can't construct a list of the resources we know are going to
appear early in init and give it to the core as we're going to discover
resources during the boot.

> > > 'E' would be ideal in some sense, but could result in some rather complex
> > > code that never gets tested.  Maybe with good design and infrastructure it
> > > could be made to work. 'C' might be a useful step towards that.

> > To a good approximation that's what both the retry based approach and
> > threading approaches do.

> I disagree.  My "E" was "provide partial functionality until the resource
> becomes available, then provide more full functionality".  The retry and
> threading are "provide no functionality until the resource is available" and
> I would say that is a difference of kind, not just of degree.

Oh, that seems a bit silly and for many resources would be no different
to just providing no functionality anyway as things like powering the
device on tend to be fairly fundamental.

> > > It is the name of a regulator...

> > This is not guaranteed to be unique.

> Well, it is whatever is expected in .supply_regulator in 'struct
> regulator_init_data'.  That's not a name??

It might just be empty, and the overwhelming majority of regulators will
not supply other regulators and can be called anything that amuses the
system integrator for all the API cares.  The string might also be
satisfied from somewhere else, there's a fallback tree.

> Do we really need uniform resource naming so we can use common code, or can
> we proceed with multiple ad-hoc source lookup schemes (like I provided) and
> then encourage subsystems to move towards a standard?  The former would risk
> never making progress.

We only have two schemes that exist right now in the APIs you've looked
at (plus at least ASoC and whatever V4L does), we certainly shouldn't be
open coding this in individual subsystems.

> Is single-threading really worth all the churn deep inside the drivers/base
> code that is would probably require?

I don't see why it'd require much churn to be honest - the patches that
I looked at weren't that invasive, basically just shove devices that
fail with a particular code into a retry list and iterate through it
whenever it seems useful to do so.

> Is mmc's use of regulators a problem that can be fixed, or a reasonable if
> baroque use of available interfaces and something we should just live with?

There are fixes needed, it's already caused problems for some systems I
believe and there's certainly breakage with things like the OMAP hsmmc
driver abuse of the API.
