Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab2AIFLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 00:11:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab2AIFLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 00:11:23 -0500
Date: Mon, 9 Jan 2012 16:10:58 +1100
From: NeilBrown <neilb@suse.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
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
Message-ID: <20120109161058.6834da0d@notabene.brown>
In-Reply-To: <20120109040802.GG29065@opensource.wolfsonmicro.com>
References: <20120109112113.07882ed9@notabene.brown>
	<20120109040802.GG29065@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/i=gx6/WZXZZw7Hjma3tTFn3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/i=gx6/WZXZZw7Hjma3tTFn3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 8 Jan 2012 20:08:02 -0800 Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> On Mon, Jan 09, 2012 at 11:21:13AM +1100, NeilBrown wrote:
>=20
> >   The solution I am proposing is to:
> >    1/ allow the 'request' functions which find and provide a resource t=
o block
> >       until the resource is available
> >    2/ run the init calls in multiple threads so that when one blocks wa=
iting
> >       for a resource, another starts up to run subsequent initcalls unt=
il
> >       the blocking call gets its resource and can complete.
>=20
> It seems like the end result of this is very similar to the idea of
> retrying.  What are the advantages and disadvantages of the two
> approaches?  My first thought is that retrying is going to give more
> consistent results between boots but is probably going to take more work
> (depending on how much context switches end up costing).

Yes, I think there would be a lot of similarities between this approach and
some sort of re-try approach.  Both good points and bad points would be
shared.

The way I look at the difference is to look at the state that has been
assembled in the probe function at the point where the needed resource is
found to be unavailable.

In my threaded approach, this state is stored in a thread until it is neede=
d.
In a retry approach it would be unwound, and then recreated at some later
time.

That and the fact that code can run in parallel are the only real differenc=
es
I think.

>=20
> Looking at what you've done to the regulators code wise this all looks
> rather more complicated than I'm entirely happy with - I'm having to
> think far too much about locking and concurrency - and this work is
> going to need to be duplicated in every subsystem that is affected.  I
> think if we're going to do this we'd need some common infrastructure to
> manage the actual waiting and waking to simplify implementation.

Completely agree.  I think the key simplification would be for each resource
to have a simple textual name.  Then you could write more common
infrastructure.

>=20
> It also seems like there's no control given to drivers, everything is
> done in the frameworks.  This means that drivers can't take decisions
> about what to do which seems like something that ought to be possible.

Maybe a non-blocking form of the 'request' function so a driver can choose
whether a not-available-yet-but-still-expected resource should be waited for
or should return -EAGAIN?    There is certainly precedent for that sort of
control.
Or is there something else you think might be needed?


>=20
> I'd like to see some way of enumerating what's waiting for what to help
> people figure out what's going wrong when things fail.

Yes, I sprinkled a few printk's around when developing this.  Some proper
tracing could certainly be useful.


>=20
> >      In this sample code I have added a call
> >           regulator_has_full_constraints_listed()
> >      which not only assures that all constraints are known, but list
> >      them (array of pointers to regulator_init_data) so when a supply is
> >      requested the regulator code can see if it expected.
>=20
> This seems pretty restrictive to be honest.  It isn't going to work if
> we don't know which regulators are in the system before we start
> enumerating which isn't going to be possible when dealing with modular
> systems that we can enumerate at runtime.  It seems like we're taking
> most of the cost of fully ordering everything in data but still doing
> some things dynamically here.

If you want a resource and it isn't available there are a few thing you can
do:

 A/ assume it will never be available and continue as best we can, which
    might mean failure.
 B/ wait indefinitely until it available.
 C/ find out if it could ever become available and then go to either A or B.
 D/ wait a while and then go to either A or B
 E/ set up a callback so we can notified if/when the resource is available
    at which point we integrate it and improve functionality.=20

Are there others?
Current code does 'A'.
I first tried B but found that devices often ask for regulators that will
never appear, so that didn't work.
I then tried D but that easily resulted in failures.  One device waiting for
something that will never appear, a second waiting for the first.
If the first times out it works OK.  If the second times out you get a
failure.  So not good.

So I went for C which I agree is a little inelegant and I now see doesn't
handle cases where some dependencies may or may exist depending on the
current hardware.

'E' would be ideal in some sense, but could result in some rather complex
code that never gets tested.  Maybe with good design and infrastructure it
could be made to work. 'C' might be a useful step towards that.

(I have exactly this problem with in md/raid.  e.g. if 3 drives of a 4-drive
RAID5 array appear, do I start the array in degraded mode, or wait for the
4th drive.  If the latter, when do I give up waiting?).


>=20
> It also seems inelegant in that we're having to pass all the constraints
> both via this and via the normal probe mechanism.  If we were going to
> do this we'd be better off changing the way that regulators find their
> constraints so they aren't passed in through the driver as it probes.
>=20
> > +static void regulator_wake_waiters(const char *devname, const char *id,
> > +	const char *reg)
>=20
> I've no idea what "const char *reg" is...

It is the name of a regulator...

>=20
> > +{
> > +	struct regulator_waiter *map;
> > +
> > +	list_for_each_entry(map, &waiters, list) {
> > +		if (map->reg) {
> > +			if (!reg)
> > +				continue;
> > +			if (strcmp(map->reg, reg) =3D=3D 0)
> > +				wake_up(&map->queue);
> > +			continue;
> > +		}
> > +		if (reg)
> > +			continue;
>=20
> ...as a result I don't really know what this is intended to do.  It does
> seem like this and the second half of the function are two separate
> functions that have been joined together.

Very perceptive!

There are two ways that you can ask for a regulator.
You can ask for it by device+supply (which is what normal devices ask for) =
or
you can ask for it by regulator-name (which is what a regulator asks for wh=
en
it is being supplied by some upstream regulator).

So there really are two separate lookup functions here - one to look up by
device+supply (aka devname+id) and one to look up by regulator name.


>=20
> > +	if (regulator_supply_expected(devname, id)) {
> > +		/* wait for it to appear */
> > +		struct regulator_waiter w;
> > +		int status =3D 0;
> > +		DEFINE_WAIT(wait);
> > +		init_waitqueue_head(&w.queue);
>=20
> I rather suspect this is going be able to deadlock if a PMIC supplies
> itself (which is not unknown - use a high efficiency convertor to drop
> down the system supply to a lower voltage and then lower efficiency
> convertors to give a series of lower voltages, giving greater overall
> efficiency).  If the PMIC registers things in the wrong order then it'll
> never get as far as trying to register the parent regulator as the child
> regulator will block.  We'd need to create a thread per regulator being
> registered.  A similar issue applies with the retry based approach of
> course.

Is this just a case of "Doctor, it hurts when I do this"?
i.e. if a PMIC could supply itself, it must register the possible-upstream
regulator before requesting supply for the possible-downstream regulator.
You would need that for current code to work anyway.



>=20
> > +		if (!found && regulator_expected(init_data->supply_regulator)) {
> > +			struct regulator_waiter w;
> > +			int status =3D 0;
> > +			DEFINE_WAIT(wait);
> > +			init_waitqueue_head(&w.queue);
>=20
> Seems like there's some code needs to be shared.
>=20
> > +static int regulator_expected(const char *reg)
> > +{
> > +	int i;
> > +
> > +	if (!init_data_list)
> > +		return 0;
>=20
> It looks like these tests for init_data_list are the wrong way around,
> if we don't know if we can fail then surely we always have to block on
> the off chance that the resource will appear?

My reasoning was that if the init_data_list hadn't been provided, then the
board still worked the "old" way by depending on the order of initcall
listing.
Remember that threading will only be used by new boards that request it
(implicitly) by declaring devices with difficult dependencies.


>=20
> > +	for (i =3D 0; init_data_list[i]; i++) {
> > +		struct regulator_init_data *d =3D init_data_list[i];
> > +		if (d->constraints.name &&
> > +		    strcmp(d->constraints.name, reg) =3D=3D 0)
> > +			return 1;
>=20
> This is really bad, the names in the constraints are optional and we
> should never rely on having them.  Note that we never look directly at
> the name in the bulk of the code.

Understood ... though not sure why we have the name if it is optional...

Anyway it just an easy way to get a list of names of expected regulators.

If "expected" isn't really a well defined concept, then we will need
something else.

Thanks a lot for the review,

NeilBrown


--Sig_/i=gx6/WZXZZw7Hjma3tTFn3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwp24jnsnt1WYoG5AQKLzw/7BM+tFE/V3hpOndQUGjNoxl21MGcfeKqo
mNDd9mxigM+lRQZ//Ay0UxpjdaCrqYHTkkLEL4qiBeQ6on8OngtNqs6bqKkAOSbi
hnzbyjndLPIJXf1kNBDQLcq0CG80/yG0YwZ9N/2GRKnHXxc1QG+FWK7rxyebV8pD
jQJr5zC6F1q1iglP7ApvMIPa7uEDksrIFS4mnY0ZeG+Qs5D9rErVOS9ooPGTxBdO
9Hy3EtV61RkDARNnub6cPoB87T2h6gpeJ7hGYbhXf6mABx8n/NN4sXK/lHwdlkL2
6Cyl3ockUpbFh8hVfAXQX9jA5m6cAdI2F9h2qpkJxDAgLLP6va95dn7js4YmxeV3
UDmAd7V+3Ho0bZivKdY88/xev3RXtRRfbZW1lR8ehgElkIvKdjAaSX5nAyEtJo6o
AH/VThEF6e6oUfgoZCejQXTkHftW4t2SuowIJsfU9sfSZ657XXCTYGohd9aklNCj
r5rJnVn1Y4KpDrhkVDY7CY8OYnViQKbEunCccN6UxOmQn6k6ojYSGTdI9NuzyTz0
4RbehsjYBK4nSYcdyLZpQTLGHb635L9cP8KnAVucAXmO39gMpbMZp9WAFxJ2cKQ8
mYIEbr16b7WEw/5aGUBenWuheqCZnUBNE2AauPFNMs0OnzwisMVEOpDH1+zh7jl/
JVz0HT22YSc=
=ol21
-----END PGP SIGNATURE-----

--Sig_/i=gx6/WZXZZw7Hjma3tTFn3--
