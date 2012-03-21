Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab2CUA3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 20:29:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39110 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753485Ab2CUA3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 20:29:44 -0400
Date: Wed, 21 Mar 2012 00:29:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com
Subject: Re: [PATCH] REGULATOR: core add 3 new modes/statuses
Message-ID: <20120321002939.GA8567@opensource.wolfsonmicro.com>
References: <1332280258-5044-1-git-send-email-gg@slimlogic.co.uk>
 <1332280258-5044-2-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <1332280258-5044-2-git-send-email-gg@slimlogic.co.uk>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 20, 2012 at 09:50:58PM +0000, Graeme Gregory wrote:
> This patch adds three new modes to the regulator core these are present
> in many TI PMICs and I expect ones by other manufecturers.

I'm not sure these are really modes, the framework essentially thinks as
modes as regulation quality but except in the case of bypass that's not
really what's going on here.

> USBBOOST this effectively turns the regulator around instead of using
> the USB 5v and converting this down to power USB hardware the regulator
> instead takes the internal voltage and boosts it to 5v for USB. Most
> commonly used when a device goes into OTG host mode.

In theory this could be done by other things so we should probably have
a better name, though in practice I'd be surprised to see many others.
It does totally break the idea of a mode, though - it's a massive change
in what the regulator does.

> BYPASS the input voltage on the regulator is transferred directly to the
> output.

This one I've actually been thinking about myself - we do want it for
low power states but I think we should consider splitting it since while
it does kind of look like a mode if you look at it funny (really it's
just very, very low quality regulation) it seems like we should be able
to do interesting things with it in the framework like turning off
regulation if the parent regulator can directly satisfy the children.
As a mode it's relatively limited if drivers won't select the mode
explicitly since if regulation weren't required some of the time it's
unlikely that the regulator would be in the picture at all.

This is all rather like the mode selection stuff so it might well be
that that's the best way of delivering the feature but I'm a bit nervous
of just doing that partly because it's a bit of a jump for a consumer to
go from "I want low current" to "I don't care so much what my input
voltage is" (though often a valid one) and partly because we're not
actually using the automatic mode selection logic since nobody is
providing the current numbers since that's a bit sensitive.  This second
issue with getting the information to deploy the feature is what's
swaying me, at the minute nobody's providing the information needed
except for some of the out of tree Qualcomm drivers.

What I'd envisage for a feature specific API would be something like a
call consumers could make to indicate that they're OK with bypass mode
paired with a constraint flag that lets the core pay attention - if all
the consumers vote for bypass it can get turned on.  Probably this could
be tied in with disable too so that a consumer that wasn't enabled would
automatically get set as voting for bypass, relying on the constraints
to disable the feature when not appropriate.

A further extension would be to allow boards to also automatically
enable bypass if the voltages requested by the consumers can be
satisfied directly from the parent regulator, though that's got some
rather obvious pitfalls.

Like I say I'm not entirely clear here, I keep meaning to try coding up
the custom API and see how it feels using it in a system - any thoughts?
Probably won't take me that long...

> TRACKING the regulator tracks another resource and produces the same
> voltage. This is commonly used where an switching power supply produces
> a voltage but a quality smoothed version of the same voltage produced
> by an LDO is required as well.

You also get this for ganging multiple regulators together to give a
higher power output, though normally you want variability so this has to
be handled at the hardware level.  This one also has an impact on how we
handle voltage changes, it'd be good if we could arrange things so that
get_voltage() and set_voltage() work through/with a regulator that's
tracking.

>  #define REGULATOR_MODE_NORMAL                  0x2
>  #define REGULATOR_MODE_IDLE                    0x4
>  #define REGULATOR_MODE_STANDBY                 0x8
> +#define REGULATOR_MODE_USBBOOST                        0x10
> +#define REGULATOR_MODE_BYPASS                  0x20
> +#define REGULATOR_MODE_TRACKING                        0x40

Note that the existing modes are all sorted in order of quality and the
framework does use that...

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPaSDsAAoJEBus8iNuMP3db2MP/Rq9FVK14IAKIAJ1bx6BYbWF
Md0yVPPifPYm87gVogpgtVtXnYi2H+SF7Vav5MZI+H/eJdTfnrXkSfOSXYeGs1zG
ZdPB4y4/3UxVBB9vqZnSqr/zGuMEALBgBFpZi0ltp0FqksA9jexTC9AtZFl6sgkg
zVT9d3IBfSRtcnnw613SgpbNKbznHff3ISCmYaR1JgGIvuszaWFS92erND6jt19z
n+p7rwmH0U3vE3wE8YUq6tx6xMbFYvokd3jGaiViLQACxGuuMeWDXLK0vdI1937g
y1O4qbw0laTGwTUVt9mrkaILUOpUPZDkFnYp26ZC00qdgvmu9d9cuvoRceX4Zm2d
56EXcAf2ozBHbzjiJwxZ8PKe8MUe4nGpcUIrdMPNFcLX0DYyAMvQhDjcQgK8Cugk
0gkrWIdAf7fGvZGVPHjiwajXVDjIojw9H6llAHRg4I/JkNyOBsIzkx5WRaxh8czM
YvelWYTkKthixh0zU5OpmSslwGt5QFOhl/7aUqcZ4nTyd99C+aDc2gRdjoxeUwRq
R617/fFuw+AvFyOMhcgnkSWevV8UG5jcgXEWVzJIgyXFTY9mY76HFazci/R4pHqY
SZYZuK1VzaaaZnrXN0HISw4tIn6eVba1hdx/YKxYi0bz7gnV9wI3w3D9hQGMuRLN
CJ6Squq4aCqBM8B9FOoj
=dBK9
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
