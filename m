Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab2DASyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 14:54:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54140 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820Ab2DASyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 14:54:07 -0400
Date: Sun, 1 Apr 2012 19:54:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] ARM: amba: Remove AMBA level regulator support
Message-ID: <20120401185404.GD8971@opensource.wolfsonmicro.com>
References: <1333294181-27653-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACRpkdb6+2SLm1Ojw2jNkK9ejW66fw2Pcit-b3AL67wP4Hr_ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Km1U/tdNT/EmXiR1"
Content-Disposition: inline
In-Reply-To: <CACRpkdb6+2SLm1Ojw2jNkK9ejW66fw2Pcit-b3AL67wP4Hr_ow@mail.gmail.com>
X-Cookie: You will have a long and boring life.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Km1U/tdNT/EmXiR1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 01, 2012 at 07:22:46PM +0200, Linus Walleij wrote:
> On Sun, Apr 1, 2012 at 5:29 PM, Mark Brown

> > The AMBA bus regulator support is being used to model on/off switches
> > for power domains which isn't terribly idiomatic for modern kernels with

> I don't see how this solves the problem of AMBA PrimeCell probing.

I think you're misunderstanding what this fixes.  The main problem it
addresses is that as things stand platforms which have no intention of
using regulators to model power domains really ought to be providing
dummy vcores for their AMBA devices (or the AMBA bus should be doing
that).  Removing regulator usage from the AMBA core code obviously
accomplishes this, avoiding disruption to these platforms.

It does also remove the dodgy ignore the error idiom, but that's pretty
much secondary.

> We need the current code replaced with something that
> enables a power domain before probe instead, then implement
> these power domains for the in-kernel AMBA devices that need it.

> Is the default behaviour of power domains such that they will
> be enabled as soon as devices are registered but before
> any buses probe()? Because that is what is needed in this case.

Yes, this should be the case (TBH I can't actually remember if you have
to do the default in your power domain code or you just get to pick the
default state and the power domain figures it out).  If you think about
it power domains would be pretty useless if they didn't do something
sensible here - it's not like the need to power things on before
interacting with them is specific to AMBA.  As I keep saying they're
*really* simple to use and very idiomatic, drivers don't ever need to
interact with them directly at all.  They just do system and runtime
power management.

> (AMBA devices are special in this way: no other ARM things
> support auto-detection of devices using magic numbers,
> basically the DT stuff came about because noone was using
> a thing like this.)

There's at least PCI and USB as well, with more to come very soon, and
on-SoC platform devices behave in very much the same way really.

> > The impact should be minimal since currently there are no mainline
> > systems which actually provide a vcore regulator so none need updating.

> Oh yes there are:
> drivers/mfd/db8500-prcmu.c

Oh, ick.  As you say this stuff would obviously be expected to be in
arch/arm along with the rest of the platform code and quite frankly I'm
surprised that AMBA is producing textual dev_names - it's rather unusual
for a bus not to use the numeric IDs which it enumerates with which is
why I missed the code when I grepped.  The names aren't a problem, just
surprising.

> IIRC the machine will not boot (i.e. these drivers cannot even
> probe) without these regulators in place, so they get enabled by
> the AMBA bus code.

> So we need something that not just removes stuff from the
> AMBA bus, but also adds a better power domain mechanism
> and fixes up taking the above regulators.

> That said I'm all for replacing it - but I'd need to figure out the
> details on how to do that.

> We do have code for ux500 power domains. If it will will be
> enough to handle this I can try to hack it up and submit it.

This should be totally trivial, just shift your existing regulator stuff
into the power domain and out of AMBA.

Though actually given the fact that only the pl022 driver supports
turning the domain on and off at runtime and that's not one of the
drivers bound to the switchable supply in this system you'll probably
see zero impact on actual systems if you just constrain vape to be
always_on in the first instance, then work to optimise later.  With the
current mainline code I'd expect there to be at least one AMBA device
which forces the power on anyway.

--Km1U/tdNT/EmXiR1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPeKQvAAoJEBus8iNuMP3d83IP/i54EpaepTOCYOucdS9kOkgj
9aki1PUOj4WDOjl1KtSpR73YarlnZvJ2LMJE3rTYGslmpxFSpRdIKWYuniyv8QzB
jE/oFgLrUPM4ZsosCGCUYbX6bkRH53Tz7PQdxcTLWdIbNkXvl//OWwyjAg5OMH1J
DVBeSlY7ttQe4mhix2EtxE+CnpfEVCnRAvqlZK0adZavFc9/G7vM5AfTAmuqYNZn
BpytOL2N55bhanJnXs6x8dLXBP8FpW2sUpUMH5Xlv+OZ3g5Fa7OIm18a1tAIlYG3
1atLdd1Rd5dZ9rzG91C5+WqdeErZQRWS8u2XHbcY4cv1obdu2JKAyWnRHnmTe2bK
QngR4LL4etce8aS23IiKNKTt1e74XjSwEyiZcKWcY1CwMx0OkEOz4yZDXWP722pw
AomyXVk//v5kyQHe+j2imyuWyc2l3Vx5IyxSgtpIqmDnqm98C9eT2e4bOBGMK5pS
pKs0sHGr7RxjSFftQIaHyAPvKPuuew+IjKpZFzIUsf1xIAJLE113TYgsK2lx3Aea
z4h0/NxU1MBK9Or1nvBvchlDj6KdlgA1gSNqV6z0mnpIlUG9b9Xc5Ven3KBXJNA1
rRUXBKX+nXpFIEjZSNWrL5C5wqgo/Jsl6gbU71K96WiX4jXY01oyz1aUR0zaCy7w
GOwLgEHkA/kb06+XJIAL
=df/p
-----END PGP SIGNATURE-----

--Km1U/tdNT/EmXiR1--
