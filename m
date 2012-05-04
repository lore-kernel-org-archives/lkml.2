Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab2EDUpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:45:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54049 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759906Ab2EDUpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:45:01 -0400
Date: Fri, 4 May 2012 21:44:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@ardb.de>,
        Olof Johansson <olof@lixom.net>,
        Igor Grinberg <grinberg@compulab.co.il>,
        linux-arm-kernel@lists.infradead.org, linux-embedded@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Handling of modular boards
Message-ID: <20120504204455.GR14230@opensource.wolfsonmicro.com>
References: <20120504185850.GO14230@opensource.wolfsonmicro.com>
 <4FA432E9.9050606@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s3R87C3fwYeCSZ0b"
Content-Disposition: inline
In-Reply-To: <4FA432E9.9050606@wwwdotorg.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s3R87C3fwYeCSZ0b
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 04, 2012 at 01:50:01PM -0600, Stephen Warren wrote:
> On 05/04/2012 12:58 PM, Mark Brown wrote:
> > Quite a few reference platforms (including Wolfson ones, which is why
> > I'm particularly interested) use replaceable modules to allow
> > configuration changes.  Since we can often identify the configuration at
> > runtime we should ideally do that but currently there's no infrastructu=
re=20
> > to help with that...

> So, I'll respond within the context of device tree, although perhaps you
> were looking for something more general?

Like I just said in reply to Arnd I think that anything that relies on
the device tree is rather optimistic.  Device tree isn't even universal
for ARM and there's a huge raft of architectures that have no current
intention to adopt DT at all.  For example I understand that a lot of
the Blackfin boards are modular, though I don't know to what extent they=20
can usefully be enumerated from software.

I know DT is a shiny new toy and all that but when developing generic
infrastructure there needs to be an awareness that we can't rely on it.

> I was just asked basically the same question internally to NVIDIA. One
> option that was floated was to store the device tree in chunks and have
> the bootloader piece them together. You'd start with the DT for the
> basic CPU board, probe what HW was available, and then graft in the
> content of additional DT chunks and pass the final result to the kernel.
> The advantages here are:

> a) The DT is stored in chunks for each plugin board, so there's no bloat
> in the DT that gets passed to the kernel; it contains exactly what's on
> the board.

> a) Relies on the bootloader, so is somewhat out of our control.

Yes, this is a crippling issue for my personal usecases.

> b) Doesn't integrate well with hotplug; the DT for the board
> configuration is static at boot. What if a board can be unplugged and
> another plugged in; a reboot or similar would be needed to adjust the
> kernel to this.

This is another issue - a similar set of problems does apply to some PCI
type cards where the PCI device is essentially a bridge to a typical
embedded system - though practically speaking it's much less severe.

> Another approach would be to put everything in a single DT, with some
> representation of how to identify the child boards, and then have the
> kernel only use/parse certain chunks of the DT based on the ID results.
> I=E2=80=99m not sure how complex that would be. Perhaps something like:

This does also have the disadvantage of requiring the device tree for
each CPU to be updated for every single plugin module which could get a
bit tedious (this does also apply to the approach of having the
bootloader create the DT - it scales fine if the CPU is a part of the
base board but if the CPU is one of the swappable modules it's less
clear).  Plus...

> The complexity here is that all the devices on the daughter board would
> end up being on different buses (e.g. 2 different I2C busses, an SPI
> bus, even an MMIO bus) so representing this in the daughter board nodes
> would be complex. Do we insert a "daughter board mux" onto every single
> bus that's routed to the daughter board connectors, or add the ability
> to dynamically add nodes into pre-existing busses, e.g. add
> /daughter-board/board-a/i2c-0 into /tegra-i2c@xxx/?

=2E..there's this, I'm not sure the daughterboard mux is going to fly.
It's requiring each and every bus to understand this concept which seems
like a bit of an imposition to me, especially given that it exists
purely to service the needs of DT.  The idea of having DT blobs injected
for the modules seems easier than this.

I do think we want to be able to write drivers for modules; if we can go
with injecting DT blobs then from a kernel point of view everything is
already sorted so there's nothing to do but this doesn't feel like it
actually resolves the issue, at least for me.  For example, with my
current systems it'd require a DT port for s3c6410 plus the addition of
both DT support and hardware module identification to our current
bootloader and then the ongoing maintainance of the device trees for all
the CPU and board combinations that might exist.  This seems like a lot
of work.

--s3R87C3fwYeCSZ0b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPpD/AAAoJEBus8iNuMP3dN7wP/RJxWKdLpquJogS14ue2OoUG
SKcCm9pTGkk06Fl6kj5/PZNmuHBmTW9yRhwO9AgAr/mqGQvxO3QhG03behZDFinA
XrFwhfD8myu28rhyOFeTJvLyhH6Fc5ArqoEaJknkFltRL9t8fHIHn8g2Mvh7cdeM
EsSp1HM/4CcER/3/gU27jNAN08CY5SJFtefVlrND2Gv3tvZ+G8H6vz51SiP81jQZ
ik9Jto0H0rCRYHltGpaesCgAeIY50aFyYIKKylSUgQYCUMZ/32wILtm2coUhq8wr
ljC5aBGGdm7oJWYAAIwY4Fd0jX3S/3ZYlSOf0VFoZYHM0woh3V1w9PRIUv+STQ6W
YxZPwGvanI8GHribdbNav3KqUrOtFQvekOk1+wC5fCBOcOnxscSOxuOgsAtA0pwT
E+FC15iWVvmf06nWzfGSEG4tUsmddVDzQEyV44ID4bKDzxd25k4RFPV9KPemEhvL
lv2a75G+TtxYoD6PPfo61ccYzgmSkbdDsUldWQlk26ua+ZDOmoL26iP8QZ0TMGHw
988RcWGFegCnW0UOzj1fPzja3o5E31gsqXspQ4Y0+THIW4c3c5ea+RkJ394qEse2
pJ8x/bMjzaLHkEIKa8h1y0MoCt3LJ5XmtyQ8jbLsMi9XFXUzKdq8p6d1t+u/a3BK
zRPuzelbvnFkpU6AHthU
=f6IT
-----END PGP SIGNATURE-----

--s3R87C3fwYeCSZ0b--
