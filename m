Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2AIGW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 01:22:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48337 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752949Ab2AIGW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 01:22:57 -0500
Date: Sun, 8 Jan 2012 22:22:31 -0800
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
Message-ID: <20120109062231.GM29065@opensource.wolfsonmicro.com>
References: <20120109112113.07882ed9@notabene.brown>
 <20120109040802.GG29065@opensource.wolfsonmicro.com>
 <20120109161058.6834da0d@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109161058.6834da0d@notabene.brown>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 04:10:58PM +1100, NeilBrown wrote:
> On Sun, 8 Jan 2012 20:08:02 -0800 Mark Brown

> That and the fact that code can run in parallel are the only real differences
> I think.

So, my general inclination is that given the choice between parallel and
serial solutions I'll prefer the serial solution on the basis that it's
most likely going to be easier to think about and less prone to getting
messed up.

> > Looking at what you've done to the regulators code wise this all looks
> > rather more complicated than I'm entirely happy with - I'm having to
> > think far too much about locking and concurrency - and this work is
> > going to need to be duplicated in every subsystem that is affected.  I
> > think if we're going to do this we'd need some common infrastructure to
> > manage the actual waiting and waking to simplify implementation.

> Completely agree.  I think the key simplification would be for each resource
> to have a simple textual name.  Then you could write more common
> infrastructure.

That's pretty much the case already for most things - the cannonical
thing is to look up by (struct device, string).  Squashing everything
into a single flat namespace is painful as completely unrelated bits of
the system easily collide with each other.  GPIO and IRQ are the only
holdouts I can think of in this area.

> > It also seems like there's no control given to drivers, everything is
> > done in the frameworks.  This means that drivers can't take decisions
> > about what to do which seems like something that ought to be possible.

> Maybe a non-blocking form of the 'request' function so a driver can choose
> whether a not-available-yet-but-still-expected resource should be waited for
> or should return -EAGAIN?    There is certainly precedent for that sort of
> control.
> Or is there something else you think might be needed?

I can see a driver wanting something like "either A or B".

>  A/ assume it will never be available and continue as best we can, which
>     might mean failure.
>  B/ wait indefinitely until it available.
>  C/ find out if it could ever become available and then go to either A or B.
>  D/ wait a while and then go to either A or B
>  E/ set up a callback so we can notified if/when the resource is available
>     at which point we integrate it and improve functionality. 

> Are there others?
> Current code does 'A'.

Hrm?

> I first tried B but found that devices often ask for regulators that will
> never appear, so that didn't work.

That should be extremely rare, you're probably working with broken
drivers.  The only case I'm aware of is MMC and frankly the way it uses
of regulators is more than a little dodgy.

> So I went for C which I agree is a little inelegant and I now see doesn't
> handle cases where some dependencies may or may exist depending on the
> current hardware.

The latter bit is the real killer - you need to know right at the start
of boot what you're going to find when you start the system.  An
approach that relies on that but does require us to do work to set it up
doesn't seem especially useful.

> 'E' would be ideal in some sense, but could result in some rather complex
> code that never gets tested.  Maybe with good design and infrastructure it
> could be made to work. 'C' might be a useful step towards that.

To a good approximation that's what both the retry based approach and
threading approaches do.

> > It also seems inelegant in that we're having to pass all the constraints
> > both via this and via the normal probe mechanism.  If we were going to
> > do this we'd be better off changing the way that regulators find their
> > constraints so they aren't passed in through the driver as it probes.

> > > +static void regulator_wake_waiters(const char *devname, const char *id,
> > > +	const char *reg)

> > I've no idea what "const char *reg" is...

> It is the name of a regulator...

This is not guaranteed to be unique.

> There are two ways that you can ask for a regulator.
> You can ask for it by device+supply (which is what normal devices ask for) or
> you can ask for it by regulator-name (which is what a regulator asks for when
> it is being supplied by some upstream regulator).

> So there really are two separate lookup functions here - one to look up by
> device+supply (aka devname+id) and one to look up by regulator name.

Not really, you're always asking for a supply by name.

> > > +	if (regulator_supply_expected(devname, id)) {
> > > +		/* wait for it to appear */
> > > +		struct regulator_waiter w;
> > > +		int status = 0;
> > > +		DEFINE_WAIT(wait);
> > > +		init_waitqueue_head(&w.queue);

> > I rather suspect this is going be able to deadlock if a PMIC supplies
> > itself (which is not unknown - use a high efficiency convertor to drop
> > down the system supply to a lower voltage and then lower efficiency
> > convertors to give a series of lower voltages, giving greater overall
> > efficiency).  If the PMIC registers things in the wrong order then it'll
> > never get as far as trying to register the parent regulator as the child
> > regulator will block.  We'd need to create a thread per regulator being
> > registered.  A similar issue applies with the retry based approach of
> > course.

> Is this just a case of "Doctor, it hurts when I do this"?
> i.e. if a PMIC could supply itself, it must register the possible-upstream
> regulator before requesting supply for the possible-downstream regulator.

No, the driver has no idea how the system integrator chose to design
their board and different system integrators may make different
decisions.

> You would need that for current code to work anyway.

Sort of.  The data is OK as-is, we could handle this entirely in core.

> > > +static int regulator_expected(const char *reg)
> > > +{
> > > +	int i;
> > > +
> > > +	if (!init_data_list)
> > > +		return 0;

> > It looks like these tests for init_data_list are the wrong way around,
> > if we don't know if we can fail then surely we always have to block on
> > the off chance that the resource will appear?

> My reasoning was that if the init_data_list hadn't been provided, then the
> board still worked the "old" way by depending on the order of initcall
> listing.

That's not going to work for anyone making new boards and increases
fragility.

> Remember that threading will only be used by new boards that request it
> (implicitly) by declaring devices with difficult dependencies.

I'd rather expect that as soon as we can we're going to back out all the
bodges we use currently.

> > > +	for (i = 0; init_data_list[i]; i++) {
> > > +		struct regulator_init_data *d = init_data_list[i];
> > > +		if (d->constraints.name &&
> > > +		    strcmp(d->constraints.name, reg) == 0)
> > > +			return 1;

> > This is really bad, the names in the constraints are optional and we
> > should never rely on having them.  Note that we never look directly at
> > the name in the bulk of the code.

> Understood ... though not sure why we have the name if it is optional...

The primary purpose is so that we can provide a meaningful name for the
supply when talking about it.  Usually this would be filled in with the
names the rails have in the schematic but there's no reason to require
that.
