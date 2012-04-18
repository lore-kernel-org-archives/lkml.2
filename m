Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab2DRJZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 05:25:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45900 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425Ab2DRJZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 05:25:53 -0400
Date: Wed, 18 Apr 2012 10:25:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Liam Girdwood <lrg@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/4] regulator: tps65910: update type for regmap
Message-ID: <20120418092547.GE3021@opensource.wolfsonmicro.com>
References: <1334710829-22777-1-git-send-email-rklein@nvidia.com>
 <1334710829-22777-2-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lteA1dqeVaWQ9QQl"
Content-Disposition: inline
In-Reply-To: <1334710829-22777-2-git-send-email-rklein@nvidia.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lteA1dqeVaWQ9QQl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 17, 2012 at 06:00:26PM -0700, Rhyland Klein wrote:
> When accessing the regmap via the read/write functions, we need to use a
> unsigned int * instead of a u8 * otherwise corruption will occur.
>=20
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>

>  static inline int tps65910_read(struct tps65910_reg *pmic, u8 reg)
>  {
> -	u8 val;
> +	unsigned int val;
>  	int err;
> =20
>  	err =3D pmic->mfd->read(pmic->mfd, reg, 1, &val);

Ugh, this interface is just broken all round - there's absolutely no
type safety here and all users of these functions will be broken (a
similar issue applies on write).  It's much better to fix this for 3.4
by converting the core code to use regmap_raw_ functions which take
native formatted data for the device like the function driver API
actually expects.

Looking at the MFD code the fix for 3.5 should at the very least involve
making the functions take typed pointers, though given the way they're
implemented right now with direct references in the subdevices I'd also
consider just having the subdevices uses regmap directly as the wrappers
are just adding an opportunity for error (the bit operations could be
converted into static inlines in the header too).

--lteA1dqeVaWQ9QQl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjoiQAAoJEBus8iNuMP3dzL0P+wapSIPLH+WiqGgIaz+rlYy0
VyYehC9reAXxN18fshUgnIBFFmz0FOAvD9pry6SF7nJjyMhjkzuQ4AYv3YnhXcZH
uoyhNcd/kca7GMi76fDA8oXN0YSAzEAh2AkC86uU9PkdoQ07cuqsulhUX5qTTXg9
g1as0LqQnSXtgQ6RB0QKvyd3cdhcmMbuJFR8cXzI+4YQPb8xkZYA73+jpzeOz6go
Z+6pkpN2GFgx+U43BpEbil90y8tG12jcVtd+NywatlXZFrXQUID47MCSsY4ysrwn
2y/yqojE1yzTRPWIVoxgKsHWNpPXMqC8Q5aSU3uKJdMSzvA/K/qrN8gkc3JNWj+7
7oV1brT0adBXCboRf3Bhb9eLnUyPnBHybyny7nr7IQscbDHdFn5qVaYgKqtUwJkO
y6Ca3f5vx6uknv6hZMGrenR3aNl5TbEMTH6RlY3FaxGS8UtHQ8tuElWNN7xOP84W
JoGJRjO4uS3k0bmyqvlu67wsRvrPfCCj8QDzegj0tHW7fDx/2nmCvQnuy0/mA2yE
2kDZgM0rzbttKJcw/w++YmyVz1IT6EhVUU5eC+DRnsbBqOiEAuZ00SkIRju2cAg0
4JLj/m7Pd5OkX31eNUjDxwiV7xMrDY0orR35Vwjywlxop8ytP62YqOvV9k31X3di
SX318zS8of2cj/rCDGVu
=sCwd
-----END PGP SIGNATURE-----

--lteA1dqeVaWQ9QQl--
