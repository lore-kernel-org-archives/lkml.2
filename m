Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab2AYL5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 06:57:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50520 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204Ab2AYL5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 06:57:08 -0500
Date: Wed, 25 Jan 2012 11:57:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Steve Glendinning <steve.glendinning@smsc.com>,
        Richard Purdie <rpurdie@rpsys.net>, Timur Tabi <timur@freescale.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH/RFC] regulator: Reverse the disable sequence in
 regulator_bulk_disable()
Message-ID: <20120125115705.GF3687@opensource.wolfsonmicro.com>
References: <1327491338-18817-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0rSojgWGcpz+ezC3"
Content-Disposition: inline
In-Reply-To: <1327491338-18817-1-git-send-email-s.nawrocki@samsung.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0rSojgWGcpz+ezC3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 25, 2012 at 12:35:38PM +0100, Sylwester Nawrocki wrote:

> Often there is a need for disabling a set of regulators in order opposite
> to the enable order. Currently the function regulator_bulk_disable() walks
> list of regulators in same order as regulator_bulk_enable(). This may cause
> trouble, especially for devices with mixed analogue and digital circuits.
> So reverse the disabling sequence of regulator_bulk_disable().
> While at it, also correct the comment.

So, I've applied this since it shouldn't do any harm and probably is
more what we meant to do but note that the bulk APIs don't make any
guarantees about ordering - in particular when we do the enable we fire
off a bunch of threads to bring the regulators up in parallel so the
ordering really is going to be unreliable as it depends on the scheduler
and the rates at which the various regulators ramp.  This is done so
that we can enable faster as we don't have to wait for each regulator to
ramp in series.

Whatever driver inspired you to submit this change is therefore probably
buggy or fragile at the minute - is it something that's in mainline or
next right now?

At some point I'd like to enhance things further so we can coalesce
register writes where multiple regulators have their enable bits in the
same register but that's a relatively large amount of work for a small
benefit unless we do something cute with regmap (and that is likely to
be too cute).

> The alternatives to directly modifying regulator_bulk_disable() could be:

>  - re-implement it in modules that need the order reversed; it is not
>    really helpful in practice since such code would have to be repeated
>    in multiple modules;

>  - create new function, e.g. regulator_bulk_disable_reversed() with the
>    order reversed - not sure if it is not an overkill though;

The third option is that where devices really care about the power
sequencing they should explicitly write that in code and only use the
bulk APIs where they don't care.  Typically this will mean either a few
sets of bulk supplies or a single set of bulk supplies and then some
number of individual supplies.  An awful lot of devices don't have any
sequencing constraints at all, apparently including most of those using
the API at present.

BTW, your CC list here is *really* random - please think more about who
you're CCing, it looks like you've done something with get_maintainer.

--0rSojgWGcpz+ezC3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPH+4JAAoJEBus8iNuMP3dUjcP/RRZ22p48aPHYs2AjstRC/f6
koFBqFCvUBItQURtUOOtzhX2M6SNKrMygGxHA4iikjiLKaW6/V841BYXPPQFM9vC
9Mh4W/fkJraRrvWPjwVkdde4IhL14NJ6S99OK9dKHeewY29wJ1dePMJR38rQz6Ul
WTxXozCZVopKH8F3gEKE/xbaQqzk5U0NvGpb91XUT8K7smtc1cDuOH22l+k/LKC6
ryynrJ1QLJqQzJn3D1ldqR+GZ7UA6y6lfdycgks9MqV6ugQUX5ORWJtqPJhyC6Ti
dWss+nyEJiz7iH0I9u6O6qd+y0ceUDiNbPpD/HxPFxLVYJ0PID0mc5YpnTZBrNrG
S02mgtotLAuRmKuWSiWEnBcyjykwPpZx2E90+WGYUeyF9xdlDa1IBnxJJ4r8JZsZ
TdciM0gs6oWaLzv6z5CzYA6KnwCnMs12vDgOLM3qDNBk4udztUl12anzymrRFY7U
7z0ZEmRsx5lgqB3OYKn/0FrNAABueoFBqmtvPFTJIe2yqyCly5Af34/Elf0p6e3i
BY/vD8hCtvDJqzEZIxrFQs64FdgcPbFkY3KkpP1XTGZS8VwrNMcnvE1ERlsteBpe
dsZPVzCI8/fJ7NUKDJl3jAsMdjpeuNlOV5OP0/TMc5sGS6l6uDMitlGenwLMh+pT
wYW4pVOw35oHQI6BbOfI
=BOmJ
-----END PGP SIGNATURE-----

--0rSojgWGcpz+ezC3--
