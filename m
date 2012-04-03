Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab2DCMZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 08:25:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46322 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415Ab2DCMZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 08:25:42 -0400
Date: Tue, 3 Apr 2012 13:25:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Michael Bohan <mbohan@codeaurora.org>
Cc: rnayak@ti.com, lrg@ti.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: Regulator supplies when using Device Tree
Message-ID: <20120403122539.GC3192@opensource.wolfsonmicro.com>
References: <20120328100957.GD3232@opensource.wolfsonmicro.com>
 <4F736451.8020900@codeaurora.org>
 <20120328193341.GD3232@opensource.wolfsonmicro.com>
 <4F73A798.6030607@codeaurora.org>
 <20120329111159.GJ3668@opensource.wolfsonmicro.com>
 <4F7509F4.6010303@codeaurora.org>
 <20120330103602.GE21950@opensource.wolfsonmicro.com>
 <4F79E35A.5040908@codeaurora.org>
 <20120402212232.GA3160@opensource.wolfsonmicro.com>
 <4F7A581D.2020303@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3RTKUHj+75w1tg5"
Content-Disposition: inline
In-Reply-To: <4F7A581D.2020303@codeaurora.org>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O3RTKUHj+75w1tg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 02, 2012 at 06:53:33PM -0700, Michael Bohan wrote:
> On 4/2/2012 2:22 PM, Mark Brown wrote:

> >Oh, if that's all it is that's totally normal and unsurprising.  Just
> >tell the regulator API about the battery supply, typically people use
> >a fixed regulator for this.  You don't have to specify a voltage when
> >you use them.

> One problem here is the added run-time overhead. This includes the
> callbacks for the battery device which serve no functional purpose.
> And then there's the contention for a single mutex on the battery
> regulator, which all regulators using it as a supply would have to
> contend for. That is actually a sizable number of devices in our
> configuration; And these operations are frequent and time sensitive.

None of this is particularly related to telling the system the regulator
has a parent, it's all to do with the fact that there's room for
improvement in the handling of simple regulators.  Right now we're just
doing the simplest thing possible most of the time, generally the CPU
overhead is trivial compared to the amount of time it takes to actually
do anything to the hardware so it's not much of a problem.

> Plus, then there's other complexities that arise here by introducing
> yet another regulator driver into the configuration. The 'fixed'
> regulator driver initializes at subsys_initcall, but our other

All the init ordering stuff should be dealt with using the probe
deferral stuff.  The main trick is making sure that cpufreq (and any
other deviceless consumers) are registered after all the regulators come
up, though obviously what we really want there is to make sure we don't
have any consumers (or drivers generally) that don't have a struct
device associated with them so we can actually do things like this.

> And generally speaking, why incur a larger memory footprint by
> linking another driver when there's no technical need to?

I'm finding it hard to worry, frankly - the overhead is small enough in
the grand scheme of things and there's nothing magic or especially
resource intensive about regulator-regulator supplies which means that
they're the only place where it's worth saving memory.

> Thus it seems like there are use cases to have a single driver that
> can support regulators with or without supplies specified. I see
> adding a few lines of ugly code in the driver more ideal than
> accepting the problems above. But it would be nice if the regulator
> Device Tree support could handle it natively.

To repeat, open coding anything like this in every single driver (which
is what you're suggesting) is obviously an abstraction failure.  Please
stop suggesting this.

In general a lack of thought for abstraction seems to be your issue here
- you've thought of one particular optimisation for a very specific case
and you're focusing too much on how to deploy that rather than thinking
more generally.  We've not even tried to improve the speed yet so we
shouldn't be looking at microoptimisations yet, they'll just add
complicaton.  This has to work well on other people's systems too and
things have to be maintainable going forward.

The most obvious thing (which I keep meaning to do anyway for
diagnostics) is to reintroduce the per consumer and per regulator
reference counts then use those to avoid going up the tree when we can.
If always on and other stub regulators are a bottleneck there's plenty
of optimisation we can do there too - for example, we can use the fact
that the parent is always on to avoid propagating things up the tree (or
avoid doing so expensively), or if we notice that the regulator is just
a stub when it's being registered we could replace it with a null
pointer and then handle that.

These are just the things I thought of within a few moments and will
bring benefits to any supply that fits, not just those where one
regulator happens to supply another.  I'm sure that if we thought a bit
more we could come up with plenty more optimisations.

In short, just describe your hardware accurately in the device tree and
then optimise the software to deal with it better.  There's plenty of
low hanging fruit that haven't been touched yet, don't microoptimise.

--O3RTKUHj+75w1tg5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPeuw2AAoJEBus8iNuMP3dI/8P/3Pv52xIkQga2ofut3IcltHR
5/viKaXjfGFaNJpGxsbLcpyKsPFWAgiku+bZmMDurTo6pdoZqruygtaZjMn0MnOS
99cIcsu46d2ysxBP9K3sEFwgL/oG7OaljHvyuBql8tLZyEVmT4YmFIS+J1J6I6Yc
e2AGvPcMfmA6YrmAzfxdnWHPaFCwOd4sHxyDMbqHdRK5mHyvl9aBkIKeqaw/4/iY
+U58E48phMjF9LI5O1No3JjhPvMXivGCQ61CqVXh4eOEaMAqhVyD40Dk8TdodAp6
SkGLzCvggKPBsfVhf7lKt/fUrBbIGszIOHlwVjn9zx0O0PlpE+raUt2MSmGtRtA9
6VSl8zH+DSt1HbHBsIrMhpGNbmSy2vEOpsk7/3ihWDPVlFybVBE/NoFfE2SIUZkg
KcZIpkE3ZgXQvxJ5CvuM3Dm8hjyrWcNju1IOAKYXu8mnbRVPrSqwXfm41BR8U0nI
gKxcoIf3n05izihkCqAmxgAghyo4dgelMy2D0VxzWvPswZFUpIEUgw80aHZ9sMRn
6A7nXe/odPR2iz1kq5POnzGTCZO21w417BKFEaPwFmIjfq99dkGhyV7F98irY5NH
imY4c+WvsFl6VvpvHWX0uCxJE2ycWL8uIzgzKwzkpjfcRlYn0k7L0ijmPvwZxBpf
FEhpJHk22HRkpRjJtyhi
=3g3z
-----END PGP SIGNATURE-----

--O3RTKUHj+75w1tg5--
