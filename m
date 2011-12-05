Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab1LETiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:38:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab1LETix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:38:53 -0500
Date: Tue, 6 Dec 2011 06:38:34 +1100
From: NeilBrown <neilb@suse.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        MyungJoo Ham <myungjoo.ham@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Mike Lockwood <lockwood@android.com>,
        Arve =?ISO-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Message-ID: <20111206063834.3f66b3e0@notabene.brown>
In-Reply-To: <20111205120608.GI11150@opensource.wolfsonmicro.com>
References: <201111281753.45287.arnd@arndb.de>
	<CAJ0PZbT8FcCq=6GzLxOhhpRvCbCaJJEhE9_2GXXT4P0XZp6H-w@mail.gmail.com>
	<20111130135847.68a6e4c6@notabene.brown>
	<CAJ0PZbRpoz+uK4QUAO4RG5bhsSpNvm5U-ROtbduXhnFTLMZ1VQ@mail.gmail.com>
	<20111201095633.700e2923@notabene.brown>
	<20111130231740.GA25340@opensource.wolfsonmicro.com>
	<20111130232529.GB3220@core.coreip.homeip.net>
	<20111201162144.187ecca3@notabene.brown>
	<20111201113449.GD2915@opensource.wolfsonmicro.com>
	<20111205140413.0d2c5382@notabene.brown>
	<20111205120608.GI11150@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/REEwUBvdWyHnIgqBWLjGROJ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/REEwUBvdWyHnIgqBWLjGROJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Dec 2011 12:06:08 +0000 Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> On Mon, Dec 05, 2011 at 02:04:13PM +1100, NeilBrown wrote:
> > On Thu, 1 Dec 2011 11:34:50 +0000 Mark Brown
>=20
> > > We really want something a bit more involved in the USB frameworks for
> > > the specific example of USB stuff (which is being worked on) - ideally
> > > we should be communicating information about how much current the host
> > > allows to be drawn throughout the system.
>=20
> > Sounds like a job for the 'regulator' framework - but that is a guess b=
ased
> > on not looking very deeply, so I'm probably wrong :-)
>=20
> The regulator framework might be used to implement the current limits
> but it understands nothing about the sematics of what it's doing, it
> just understands things at the level of setting values.  Something would
> need to sit above it to plug into USB.
>=20
> > > I think we do want something which lets us say "this is a cable of
> > > type X" so that we can report the difference between otherwise identi=
cal
> > > cables as in the car/desktop dock example I mentioned above.
>=20
> > I think you are saying that you might have two "cables" which connect u=
p the
> > same sets of signals but are "different" somehow.  One connects to a ca=
r,
> > the other to a desk-top dock.
> > How is that difference detected by the hardware?  Presumably some switc=
h?
> > So this is just one more binary switch to export to who-ever needs to k=
now
> > (presumably user-space) ???
>=20
> Implementations vary - it may involve something like reading an ID chip
> over some bus, for example.  It's definitely not a binary switch, it
> needs to have more values than that.

Ahh..
So to try to restate the requirements:

 A "cable-port" can detect when a "cable" in inserted (or removed) and can
 determine the "cable-type" which comprises:
   - a "cable-name" which is an arbitrary label interpreted in the context =
of
     the particular port
   - 1 or more "cable-function" flags which indicate what functions the=20
     cable support.  A given port has a fixed set of "cable-functions" and=
=20
     for any given cable it will report true/false (present/absent, on/off)
     for each cable-function.

 This full "cable-type" needs to be presented to user-space, and individual
 cable-functions may need to be communicated to specific drivers to trigger=
 a
 'probe' function.

Questions:
  1/ Do we need to communicate anything to drivers apart from "cable-detect=
"?
     i.e. are they quite cable of probing and identifying, or do they need =
to
     be told what to look for?
  2/ Does it hurt to simply wake up all drivers that might be listening on
     the cable or do we need individual wake-ups (notifiers) for each
     cable-function?
  3/ Does anything in the kernel care about the cable-name, or is that only
     interesting to user-space?

I think that the "cable-functions" might still be best represented by virtu=
al
GPIOs, but the cable-name is certainly more than that.

To me this does sound like it might want a 'cable-port' device and it should
generate 'change' uevents when a new cable appears.  The change from no-cab=
le
to cable-X does seem quite a significant change affecting possible multiple
subsystems so a uevent seems to me to be justified.


>=20
> > My GTA04 has a wifi chip connected to an mmc port.  The wifi chip has a
> > separate regulator that can be powered up/down independently of everyth=
ing
> > else.
> > So when I apply power I need a way to tell the mmc driver to scan the b=
us.
> > It expects this information to come via a GPIO which has an associated =
IRQ.
> > But I don't have a physical gpio to give it.
>=20
> > So this is a case where one driver (the rfkill driver) needs to signal
> > another driver (the mmc driver) to tell it that a new device has become
> > available.  It hasn't been plugged in via a cable, it has be turned-on =
via a
> > regulator, but it is conceptually very similar.
>=20
> This is a very common situation.  The solution we've mostly been going
> for for soldered down components is actually rather different, though -
> in general it's much nicer for userspace if the device is presented as
> always there rather than doing the hotplug thing and we just power it up
> as needed.
>=20
> Due to the existing rfkill implementations I guess the network stack is
> already happy with the probe/remove model but that's not universally
> true.  Even with userspace understanding things this would for example
> also mean that we'd be able to keep the WiFi powered down when we just
> happen not to be using it without having to use the rfkill switch.
>=20
> > I wrote a virtual gpio chip which I call gpio-inout because it provides=
 pairs
> > of gpios, an output paired with an input.  When the output is changed it
> > triggers an interrupt associated with the input, and the output is alwa=
ys
> > readable by the input.
>=20
> For the implementation I suggest above (which the core can't really cope
> with yet but anyway) I'd be using a regulator.

Brilliant!  That might solve another related problem I've been having.  Time
to learn even more about regulators.

Thanks,
NeilBrown

--Sig_/REEwUBvdWyHnIgqBWLjGROJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt0dujnsnt1WYoG5AQIGcg/8CrvseZrqEvXABBmAk8j1CswoTdMo0wy1
Oqa2ctc47KNHgj4KEfD0MA+ahzXNb/WrB38ebKno+eOb29dT+Fs2YMD/x0bbeTxb
c+FaD8KYTMvTb0wTqvLEeAyObojo/kMXVGx78ns0WTUpysW2ZCwzqqjBNVM0hNxO
J3wZScMZOmaozqZwkd6um5dXxoedaUD4Q81HjztbmCGzEHNLaH/JY49rpOaHda9v
XBC8KZ6EEtQ3AcMVZAOnVELa7q2qraRqW3uw7oDQYEawohJkAMk3OkYB4WFXCAgP
IZYl9kd7wM+qmeBWG+zkp9T+AEBZtz5XG5OFj8NwkslDFUHMyM0F7I1NJ3+qaSG/
NY3/hVEoBKo+RW+7s3+5tUg5xAPs9SJ6yO3FZLd+IiY+v6KRBRUaHQbZto558z0o
MhxMVC6wFEmrF7cazHcH2j6P7V70w3Ae5qNkDjywGjq0hQmDEdjnvr5KQ2jIFMmg
WzuiV1YY3K48YpmoTVonAI0K6Y0t4R2JDBM49XYpdI4z/H5uoR2jsTJmWNhbZz9g
LDqR/RYUI9LYgd3PGGKM7DIeaMoADped0p1jOksh4mO9qXn//d/G6Fjf0l9VaZuV
bc/rhgA6skt/H8cES1TORqILjYWd4gLIXsyM3SO/6I+9eaUX/wJyVzI281NQtD7d
/GCKoO5TT9k=
=LVMk
-----END PGP SIGNATURE-----

--Sig_/REEwUBvdWyHnIgqBWLjGROJ--
