Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab2DSMmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:42:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59697 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726Ab2DSMmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:42:08 -0400
Date: Thu, 19 Apr 2012 13:42:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com
Subject: Re: [PATCH] regulator: Provide a check for dummy regulator
Message-ID: <20120419124204.GE3046@opensource.wolfsonmicro.com>
References: <1334829097-32084-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="brEuL7wsLY8+TuWz"
Content-Disposition: inline
In-Reply-To: <1334829097-32084-1-git-send-email-jaswinder.singh@linaro.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--brEuL7wsLY8+TuWz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 19, 2012 at 03:21:37PM +0530, Jassi Brar wrote:
> Usually changing the regulator output involves delays before/after the
> operation.
> There are consumer drivers shared by platforms, where some may
> not really have a regulator in the path. Which causes the consumer
> to unnecessarily (sometimes disruptively) incur delays for the
> "dummy" regulator.

This analysis doesn't sound quite right - if it's the dummy regulator
then obviously these delays don't happen so presumably the cost is
actually coming from the rdev mutex and recursion up the regulator tree
- the basic overheads of calling into the regulator API.

> Since the 'struct regulator' is opaque outside of the core,
> provide a function to check if the given regulator is a dummy one.

No, this isn't great from a usability and abstraction point of view. =20

In usability terms this sort of performance optimisation is going to be
desired by a wide range of drivers (and wouldn't hurt those that don't
urgently need it) so we shouldn't force every user to open code the use
of this information.  Worse, the whole point of the dummy regulator is
that it allows users to not worry about this sort of stuff so it'd mean
that the dummy regulator was failing to perform its only function.

In abstraction terms it's not the fact that it's a dummy regulator
that's interesting here but rather the fact that the regulator doesn't
have control the consumer can use and there's a whole raft of other
reasons why that might be the case.  The constraints may not permit
status changes, or a real regulator may not physically support enable
and disable operations (eg, if there's a GPIO for enable and it's tied
on all the time).  If there's a useful performance win for dummy
regulators it'll apply equally well to all these other cases so we
should't be special casing dummy regulators.

I've just sent out an untested patch (you're CCed) which should give a
substantial win for the enable/disable case which will hopefully address
the issue for you.  If you're concerned about voltage change rather than
enable/disable I'd like to understand better exactly where the
performance is going but we can certainly do a similar fast path for
fixed voltage regulators.  I'd be surprised if consumers that need to
change voltages played nicely with the fixed voltage regulator while
using it often enough for anyone to care about performance.

I really don't understand why people are so keen to special case things
like this in individual consumers, not sure what we can do to encourage
more generic fixes.  There was a guy from Qualcomm the other week who
was absolutely insistent that we had to do some fragile special case
stuff with supplies for similar reasons :(

--brEuL7wsLY8+TuWz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPkAgVAAoJEBus8iNuMP3ddDcP/izrmp9/G6xuKWYw5RDUbDE+
QpTnfBcCOGTyhdmztlJmc2OHm+Ey6AstFW+PoRM6khbDNaEUJ41pMXrWXkhR3eor
UetWte1AD1Hkh2M++4yPrI/IuAGyNSwej/whdEXLOrJuUnh0hj1snNEK1hrTSQvn
pXj+yUbz/KS91CfsVllvuVcGhkqi861v5UdwjcEntEQzBUQu0JTGBdmUkY8ctTIJ
UMH8R9tMEmNtnpwvrBei+X3IV2dz2OU8zEtYcJu6zqj4Tf2jVH8x3telVvxgHsD8
icBp4s42VkiMU89E4o8fgahBag+l3UN2LYA8Cw7ezyQnGoGdGhAo9TlUp9ywCQdi
fC1G0jyIaMI9KFLXcTsnzoXUdEy0OCvHZQU7m2WNgr3t+T/HMsfH/s7BlvZmq9re
vrxH2slmgaTPa4kj4uTKi9dYkKywe3HZpltq8P+7ZTtx5FbzsK2ok5kVctiBmFi7
+/wjc55ogJxZXs8NFMi3Ae5SuYTa3o+Cw0BA0E2a4DZaq/z/sDrOxWkH1JQOoNKN
Z9bg5krbMa2sR812pCgP6K70CsFMnrTyGwLaH7aOdnro2Ez0XiXASuTkPXOGrd9+
oovKiWF91P2Xsk7fquOjyBq8d2oLyjXxT1J2Qnxi/MHyWffyZOXo1dO1hkA7nF6f
bVI9IoCCRZtVVSk6chLY
=D9Xv
-----END PGP SIGNATURE-----

--brEuL7wsLY8+TuWz--
