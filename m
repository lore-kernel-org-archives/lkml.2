Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2AIH2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:28:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495Ab2AIH2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:28:22 -0500
Date: Mon, 9 Jan 2012 18:28:00 +1100
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
Message-ID: <20120109182800.3086fd84@notabene.brown>
In-Reply-To: <20120109062231.GM29065@opensource.wolfsonmicro.com>
References: <20120109112113.07882ed9@notabene.brown>
	<20120109040802.GG29065@opensource.wolfsonmicro.com>
	<20120109161058.6834da0d@notabene.brown>
	<20120109062231.GM29065@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1m/J6n68ZIR8fIk/Mxtsneg"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1m/J6n68ZIR8fIk/Mxtsneg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 8 Jan 2012 22:22:31 -0800 Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> On Mon, Jan 09, 2012 at 04:10:58PM +1100, NeilBrown wrote:
> > On Sun, 8 Jan 2012 20:08:02 -0800 Mark Brown =20
>=20
> > That and the fact that code can run in parallel are the only real diffe=
rences
> > I think. =20
>=20
> So, my general inclination is that given the choice between parallel and
> serial solutions I'll prefer the serial solution on the basis that it's
> most likely going to be easier to think about and less prone to getting
> messed up.

Surely anyone doing kernel work needs to be able to understand parallel
solutions at least enough to place locks in appropriate places ???

I thought about doing a serial retry solution the error from the ->probe
function doesn't percolate all the way up the the initcall.
In particular, when a driver is registered driver_attach is called for each
unattached device on the bus.  This is done in __driver_attach which discard
the error return from driver_probe_device().

Now maybe we could catch the error and arrange to call driver_attach again,
but then we have to be careful of drives that call platform_driver_probe
which is explicitly designed to only try to find devices once - they don't
work first time, they don't get attached.

Presumably all this could be sorted out but it felt like the changes would =
be
very intrusive and easy to get wrong.

Be comparison I find a bit of parallelism which some simple locking quite
easy to follow :-)


> > Completely agree.  I think the key simplification would be for each res=
ource
> > to have a simple textual name.  Then you could write more common
> > infrastructure.
>=20
> That's pretty much the case already for most things - the cannonical
> thing is to look up by (struct device, string).  Squashing everything
> into a single flat namespace is painful as completely unrelated bits of
> the system easily collide with each other.  GPIO and IRQ are the only
> holdouts I can think of in this area.

I don't see (struct device, string) being used at all.

Regulator used (devicename, string).  It seems that it used to use (struct
device, string) but that is deprecated.

GPIO and  IRQ use (number).

pwm_request() also used (number).

I don't much care what is used as long as everyone uses the same so we can
write shared code.
If everyone used number we would keep running into namespace allocation
problems.
So strings seem simple.  Each different resource type would be a different
name space of course.

If a particular resource wanted to encourage "devicename-usagetype" that
would be fine, but requiring "devicename" to be present would be a problem =
for
resources (like some IRQs) which are shared between devices...  though I
guess regulators are shared between devices....  Do we really need the extra
level of indirection provided by regulator_consumer_supply?  I presume there
is a good reason.

>=20
> > > It also seems like there's no control given to drivers, everything is
> > > done in the frameworks.  This means that drivers can't take decisions
> > > about what to do which seems like something that ought to be possible.
>=20
> > Maybe a non-blocking form of the 'request' function so a driver can cho=
ose
> > whether a not-available-yet-but-still-expected resource should be waite=
d for
> > or should return -EAGAIN?    There is certainly precedent for that sort=
 of
> > control.
> > Or is there something else you think might be needed?
>=20
> I can see a driver wanting something like "either A or B".

I think you agree with me.  'A' is non-blocking lookup that can fail.
'B' is blocking lookup.  That is what I suggested above.

But when would it ever be safe for a driver to ask for A?  How would it know
if it isn't available yet it never will be?


>=20
> >  A/ assume it will never be available and continue as best we can, which
> >     might mean failure.
> >  B/ wait indefinitely until it available.
> >  C/ find out if it could ever become available and then go to either A =
or B.
> >  D/ wait a while and then go to either A or B
> >  E/ set up a callback so we can notified if/when the resource is availa=
ble
> >     at which point we integrate it and improve functionality.=20
>=20
> > Are there others?
> > Current code does 'A'.
>=20
> Hrm?
>=20
> > I first tried B but found that devices often ask for regulators that wi=
ll
> > never appear, so that didn't work.
>=20
> That should be extremely rare, you're probably working with broken
> drivers.  The only case I'm aware of is MMC and frankly the way it uses
> of regulators is more than a little dodgy.

Yes, MMC is exactly the case I am aware of.  If this usage is "wrong" then I
guess it needs to be "fixed" before we can proceed.


>=20
> > So I went for C which I agree is a little inelegant and I now see doesn=
't
> > handle cases where some dependencies may or may exist depending on the
> > current hardware.
>=20
> The latter bit is the real killer - you need to know right at the start
> of boot what you're going to find when you start the system.  An
> approach that relies on that but does require us to do work to set it up
> doesn't seem especially useful.

I must admit that I find this possibility perplexing.
I can certainly imagine individual independent devices that may or may not
exists (USB things etc) but there are no dependencies there to worry about.

But if we find a device, and we know that it depends on some resource, and
that resource is never going to be available - then is there really anything
useful that can be done?
Wouldn't it be correct to fail the boot ??

Or at worst, leave a thread waiting for the never-to-appear resource and let
the rest of the system boot.  Is there are scenario where there is a
dependency that we know about, that might not become available, but we want
to continue with normal boot anyway??


>=20
> > 'E' would be ideal in some sense, but could result in some rather compl=
ex
> > code that never gets tested.  Maybe with good design and infrastructure=
 it
> > could be made to work. 'C' might be a useful step towards that.
>=20
> To a good approximation that's what both the retry based approach and
> threading approaches do.

I disagree.  My "E" was "provide partial functionality until the resource
becomes available, then provide more full functionality".  The retry and
threading are "provide no functionality until the resource is available" and
I would say that is a difference of kind, not just of degree.


>=20
> > > It also seems inelegant in that we're having to pass all the constrai=
nts
> > > both via this and via the normal probe mechanism.  If we were going to
> > > do this we'd be better off changing the way that regulators find their
> > > constraints so they aren't passed in through the driver as it probes.
>=20
> > > > +static void regulator_wake_waiters(const char *devname, const char=
 *id,
> > > > +	const char *reg)
>=20
> > > I've no idea what "const char *reg" is...
>=20
> > It is the name of a regulator...
>=20
> This is not guaranteed to be unique.

Well, it is whatever is expected in .supply_regulator in 'struct
regulator_init_data'.  That's not a name??

>=20
> > There are two ways that you can ask for a regulator.
> > You can ask for it by device+supply (which is what normal devices ask f=
or) or
> > you can ask for it by regulator-name (which is what a regulator asks fo=
r when
> > it is being supplied by some upstream regulator).
>=20
> > So there really are two separate lookup functions here - one to look up=
 by
> > device+supply (aka devname+id) and one to look up by regulator name.
>=20
> Not really, you're always asking for a supply by name.

When I look in the=20
	if (init_data->supply_regulator) {
branch of regulator_register(), I don't see that.


So: what are the options for a way forward?

Do we really need uniform resource naming so we can use common code, or can
we proceed with multiple ad-hoc source lookup schemes (like I provided) and
then encourage subsystems to move towards a standard?  The former would risk
never making progress.

Is single-threading really worth all the churn deep inside the drivers/base
code that is would probably require?

Is mmc's use of regulators a problem that can be fixed, or a reasonable if
baroque use of available interfaces and something we should just live with?


--Sig_/1m/J6n68ZIR8fIk/Mxtsneg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwqXATnsnt1WYoG5AQI6khAAtNW9VpfUnVxLtrFyJKc9ODwpMBzVpFEp
WNv9ryoFl88APLAHuvxM3e2xJjw38HZax8iWqAr8TwVcXQryBB9lsD6y03ekKF1O
MbKMRiE/GVHa5WPGMf94zbYWNPBI8SdXztByqHomj+CsC9JsjMA5xkyie1rmE4Kv
Llhq9V5wOZWTH5PtG1JYR1cDce55fnBC6cSM6oSkTV62YxNtiTMdaqROfzLvlM1S
zTy5pWMZaQ+011dVYf0K/qFCoOhm8lDOORp+cr+QWGB8hzOV7TJWJXowWeybTbPF
E5otmbS0NF/1Prr5NEnAHTtFLNd0Iiba5ce6ncJ7Jr3Lc+uKJaS7AMbKTk92IkNU
h51dDt1XBC0EZYuuhMrKGyttAh0DAUqKWRxfc0HuNCXfYAXEFgAWXUjqNGZ319yC
TZF/EOUAXhLYyb7ZnJn0RmbTTNfsqmWVukYP/VR8AtlqcEPrLyGp3+L+RoceMM6h
QkzMZNGiOUX8nw2l0zpjJiRRqLV/uyPLALiSrbSXrosvVPeTuXHtKFxePgRKkj4B
axhilvAQXPTpr4pqmsgJx57Fe1+0UDBk3iC95Shxv3/zHl1npldmvev42vk9zUJ2
Gxrxez1INhrTufX43b4yhXbAdepFobIwWsuIaquB+UL0btH1UunKqaydQ9wXgo6Q
wMIS8FkPxdI=
=xgqd
-----END PGP SIGNATURE-----

--Sig_/1m/J6n68ZIR8fIk/Mxtsneg--
