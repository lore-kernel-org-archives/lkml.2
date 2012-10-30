Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab2J3Lzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 07:55:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43029 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab2J3Lzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 07:55:52 -0400
Date: Tue, 30 Oct 2012 13:49:49 +0200
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Felipe Balbi <balbi@ti.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-input@vger.kernel.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121030114949.GC28722@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121024161429.GA16350@core.coreip.homeip.net>
 <CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
 <4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
 <20121024185818.GB772@arwen.pp.htv.fi>
 <20121025205901.GA3827@sirena.org.uk>
 <20121026062008.GA21734@arwen.pp.htv.fi>
 <20121026160316.GY18814@opensource.wolfsonmicro.com>
 <20121029194901.GA30152@arwen.pp.htv.fi>
 <20121030112410.GM4511@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZwgA9U+XZDXt4+m+"
Content-Disposition: inline
In-Reply-To: <20121030112410.GM4511@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 30, 2012 at 11:24:10AM +0000, Mark Brown wrote:
> > This is why I think hiding things from drivers makes no sense. Also
> > consider the situations Linus W exposed on another subthread. If you
> > change ordering of certain calls, you will really break the
> > functionality of the IP. Because we can't make sure this won't work
> > automagically in all cases (just like we can't make sure $size memory
> > allocation is enough for all drivers) we don't hide that from the
> > driver. We require driver to manage its resources properly.
>=20
> We need some place to put the SoC integration; power domains seem like
> the obvious place to me but YMMV.  Nothing about having this out of the

except that pin muxing has nothing to do with power domain. To me that
sounds like an abuse of the API.

> drivers requires that this be done by individual subsystems in isolation
> from each other.  Half the point here is that for the reusable IPs this
> stuff often isn't driver specific at all, it's often more about the SoC
> integration than it is about the driver and so you'll get a consistent
> pattern for most IPs on the SoC.

and all of that SoC-specific detail is already hidden behind power
domains, runtime PM, pinctrl, clk API, regulator framework, etc.

> > How can you make sure that this will work for at least 50% of the
> > drivers ? You just can't. We don't know the implementation details of
> > every arch/soc/platform supported by Linux today to make that decision.
>=20
> Well, we've managed to get along for rather a long time with essentially
> all architectures implementing this stuff by doing static setup for the
> pins on boot.  That does suggest we can get a reasonably long way with

and this is one of the issues we're all trying to solve today so we have
single zImage approach for the ARM port.

> something simple, and it does seem to match up with how things usually
> look at an electrical level too.

simple ? I really doubt it. Just look at the amount of code duplication
the ARM port had (still has in some places) to handle platform-specific
details.

It turned out that drivers weren't very portable when they had to do
platform-specific initialization, we were all abusing platform_data to
pass strings and/or function pointers down to drivers and so on.

I'm concerned if we hide pinctrl under e.g. power domains (as said
above, it sounds like an abuse of the API to me) we will end up with a
situation like above. Maybe not as bad, but still weird-looking.

> It seems fairly obvious that if we need to add identical bolier plate
> code to lots of drivers we're doing something wrong, it's just churn for
> little practical gain and a problem if we ever decide to change how this
> stuff works in the future.

I wouldn't consider it boilerplate if you remember that each driver
might have different requirements regarding how all of those details
need to be handled.

We have to consider power consumption, ordering of calls, proper IP
setup, IP reuse on multiple platforms (even multiple ARCHes), etc etc,
and to get that right outside of the driver - who's the only class that
actually knows what it needs to do with its resources - will just be too
complex and error-prone.

I would strongly suggest starting with explicit calls to pinctrl, clk
API, etc and if we can really prove later that 95% of the users are
"standard", then we can factor code out, but making that assumption now
is quite risky IMHO.

--=20
balbi

--ZwgA9U+XZDXt4+m+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQj77dAAoJEIaOsuA1yqREx6sQAIKveh2DOtMG8mQIgn4YYtZ9
oI6AYq9JLF9xnXUn/JpuXH5jDBsYL2DVvDltGMgs1VY0FysmEFqLE0VFvXu5X2hn
DnH9+MZdSYXg4UaP/aPLPD/TCsFUjZP73Ue46z/jyo7Rs8VdfKcptruuLsdn0h+M
DoNZFPw1NVdEqwcrkcKGQhzmyWVhJvxMwHqOXpigNDJRiCC0seOvPbYfUI5Y5Zgh
C+PrylltsakwbxptG7uI8f9wUJpaapHO4qdRLNrsL1rZkLwnOXUSe9+9XTrx9MXD
9rqOy0UjmeGhuRNDvUx5caA9Jv7HTUrFv9LcrdTX84ESslpmk9sRJW7GYC02ryUw
Y4qM545SUKvG/4poDOCoiHJ0KkrQ/uZWkfaYqTqKwEpCSVrUgvGkUCKKm7Ar2I1m
H6GZh30Nk3rRvATxYRqQDfeyagA/vt/NCQ/Ftw/KXzoKEoULYbbNFH0ElQ43T3nz
xH9J9R7HsIazEKntsW0hcw29Tzxe0dlJHsRr0G5w91nO7Xqs4aYjvIIEnxcD1Laj
3/1bHKEJpAe17C0QEAkacVaP4yF6Yt3IW6cVnBeEoqKSrNGgkgHL/NfaaJ7RBLK2
tQg9L13lCiIzWSqtUtA4oiDucVJjBETqWo7Zauw+amY7/DyCY9B8BrbQeEUEw9EO
F2KQZQRWQKrG3mns9zrC
=THTM
-----END PGP SIGNATURE-----

--ZwgA9U+XZDXt4+m+--
