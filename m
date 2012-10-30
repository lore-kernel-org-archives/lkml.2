Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357Ab2J3OHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 10:07:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46155 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922Ab2J3OHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 10:07:18 -0400
Date: Tue, 30 Oct 2012 14:07:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121030140714.GO4511@opensource.wolfsonmicro.com>
References: <20121024161429.GA16350@core.coreip.homeip.net>
 <CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
 <4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
 <20121024185818.GB772@arwen.pp.htv.fi>
 <20121025205901.GA3827@sirena.org.uk>
 <20121026062008.GA21734@arwen.pp.htv.fi>
 <20121026160316.GY18814@opensource.wolfsonmicro.com>
 <20121029194901.GA30152@arwen.pp.htv.fi>
 <20121030112410.GM4511@opensource.wolfsonmicro.com>
 <20121030114949.GC28722@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nG9yj4eE4W6Oba0"
Content-Disposition: inline
In-Reply-To: <20121030114949.GC28722@arwen.pp.htv.fi>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+nG9yj4eE4W6Oba0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 30, 2012 at 01:49:49PM +0200, Felipe Balbi wrote:
> On Tue, Oct 30, 2012 at 11:24:10AM +0000, Mark Brown wrote:

> > We need some place to put the SoC integration; power domains seem like
> > the obvious place to me but YMMV.  Nothing about having this out of the

> except that pin muxing has nothing to do with power domain. To me that
> sounds like an abuse of the API.

Well, we can call the API Archibald if we like...  what I mean is
something that sits in the system below the device in pretty much
exactly the way that power domains do.

> > drivers requires that this be done by individual subsystems in isolation
> > from each other.  Half the point here is that for the reusable IPs this
> > stuff often isn't driver specific at all, it's often more about the SoC
> > integration than it is about the driver and so you'll get a consistent
> > pattern for most IPs on the SoC.

> and all of that SoC-specific detail is already hidden behind power
> domains, runtime PM, pinctrl, clk API, regulator framework, etc.

That's all getting rather open coded, especially if you're going to get
down to a situation where you have varying ordering constraints between
the different APIs on different SoCs.

> > > How can you make sure that this will work for at least 50% of the
> > > drivers ? You just can't. We don't know the implementation details of
> > > every arch/soc/platform supported by Linux today to make that decisio=
n.

> > Well, we've managed to get along for rather a long time with essentially
> > all architectures implementing this stuff by doing static setup for the
> > pins on boot.  That does suggest we can get a reasonably long way with

> and this is one of the issues we're all trying to solve today so we have
> single zImage approach for the ARM port.

I don't see the relevance of single zImage here; device tree is supposed
to solve that one.

> > something simple, and it does seem to match up with how things usually
> > look at an electrical level too.

> simple ? I really doubt it. Just look at the amount of code duplication
> the ARM port had (still has in some places) to handle platform-specific
> details.

What I'm saying here is that I'm concerned about us ending up with more
code duplication...

> It turned out that drivers weren't very portable when they had to do
> platform-specific initialization, we were all abusing platform_data to
> pass strings and/or function pointers down to drivers and so on.

> I'm concerned if we hide pinctrl under e.g. power domains (as said
> above, it sounds like an abuse of the API to me) we will end up with a
> situation like above. Maybe not as bad, but still weird-looking.

Well, nothing's going to stop that happening if people are determined
enough - one could equally see that there'll be flags getting passed to
control the ordering of calls if things are open coded.  I would expect
that with a power domain style approach any data would be being passed
directly and bypassing the driver completely.

> > It seems fairly obvious that if we need to add identical bolier plate
> > code to lots of drivers we're doing something wrong, it's just churn for
> > little practical gain and a problem if we ever decide to change how this
> > stuff works in the future.

> I wouldn't consider it boilerplate if you remember that each driver
> might have different requirements regarding how all of those details
> need to be handled.

Essentially all the patches I'm seeing adding pinctrl are totally
mindless, most of them are just doing the initial setup on boot and not
doing any active management at runtime at all.

> We have to consider power consumption, ordering of calls, proper IP
> setup, IP reuse on multiple platforms (even multiple ARCHes), etc etc,
> and to get that right outside of the driver - who's the only class that
> actually knows what it needs to do with its resources - will just be too
> complex and error-prone.

A big part of my point here is that it's not at all clear to me that it
is the driver which knows what's going on.  For SoC-specific IPs you can
be confident about how the SoC integration looks but for IPs that get
reused widely this becomes less true. =20

> I would strongly suggest starting with explicit calls to pinctrl, clk
> API, etc and if we can really prove later that 95% of the users are
> "standard", then we can factor code out, but making that assumption now
> is quite risky IMHO.

Like I say I think we're already seeing a pattern here, the code going
into most drivers looks *very* similar with lots of the drivers simply
calling get_select_default().

--+nG9yj4eE4W6Oba0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQj98GAAoJELSic+t+oim9ssMP/1IPne6WZsPrZYbiLkBB6FhG
OOd8yadjWm4g7BW73VEOL0Nj24tMm6DTcxd+C+qIVu1/DhSXb2U85k8Gw1C+J+7f
BVjz69OB4GhYAW1o3GHDyISp03ewdRt8Nm8MZL1WL1KeQTLTpeTaFfDPen/XtAka
sRp86RbagH/9ejvBKO3YWjaNqaqUhrwB1XWdrfvzGETBF9ac6UZjlWDXMpyw782V
m8X8dvEr4Z1mn7uQw75HBB4IRjO/C8A068b6zby4rqAKdGOCOCaYFeiXwnRN1/Xf
t4wnVelQDbohxULTieyXg4PmiXJPnkrlvT9c1kcgGBgACrAEXtbS/g1HuuGgsLbn
H3eHrIDef01+CA9suDnkZQQ+2f2zUnZ0TQgj6fNkCc1DpH2WX05ZAFoPxD56Dnsc
rvbwFeZczL476FkEj2yateCG0JIgUQ4IKoA0M6HUSQRVhOcoZoML2O9OwF3vqmT6
h86PYOUQknAB3EeYM7SBVMMevY1c3gGK8kszqByQwpdDD+TJD7esii+RKrPambde
stxq3YB0OktzHKIpexCZf5fiP9T9285wxr3CVxJ86VhM955CQgw3zkopG5hjomdM
HfnlA+xYbH//ZJGEc+gCAJNIbPiHzCqIfXNboJXYQ5GGPC6BGBzMLA2QDefIqHG7
fn63m5AQNjiD5UNWlX0+
=Q8qK
-----END PGP SIGNATURE-----

--+nG9yj4eE4W6Oba0--
