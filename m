Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab3AIHIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 02:08:01 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60275 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142Ab3AIHH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 02:07:58 -0500
Date: Wed, 9 Jan 2013 08:07:45 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH v2 2/4] input: keyboard: tegra: use devm_* for resource
 allocation
Message-ID: <20130109070745.GA12782@avionic-0098.adnet.avionic-design.de>
References: <1357371910-3164-1-git-send-email-ldewangan@nvidia.com>
 <1357371910-3164-3-git-send-email-ldewangan@nvidia.com>
 <20130105080658.GA1315@core.coreip.homeip.net>
 <20130106192739.GA11566@avionic-0098.adnet.avionic-design.de>
 <20130106195748.GA28212@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <20130106195748.GA28212@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:GZyxYw5SNFEhbPpM3Jech6tJlH4xsqyFkjnaSSpsbiN
 QkL8I4+WBs58YK7yljj9SjdaJPVvwFXfdvFsoBbGuI4VbdfpFU
 /lNpjCKsk4ZjNFcwtAYAx4de/dbFH5a/ohE1ut3QCeHxF9rQdx
 EQflw+pGJTfa3mrV3HxkS8J+KSMiCb2mSKZYMJ170zRA00hqPJ
 nSvBAIJ5QPVjh9BZy4YutSsH4QjKKPgVxnAollchxSUdzDEulW
 AXarbuUdc5jvPmsDhKbEZkMMcHgI7HmNSjf75tgZWPXY1Y6Cyr
 l8CXIh/oBMM3KHoHf/7nFz1X+Ur/mtBa0Mmc33gRBBg/4KNJmv
 Fj1mSg54ouW+ZTwGVMgwA8Q3uFTJ14xa8t+J+9XekXlTCryCjT
 t3xcrEU+UzivVUw6XFfZcpmmAgUoRQ9tbkWkPewyqZkBlWMzYS
 CP7xq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 06, 2013 at 11:57:48AM -0800, Dmitry Torokhov wrote:
> On Sun, Jan 06, 2013 at 08:27:39PM +0100, Thierry Reding wrote:
> > On Sat, Jan 05, 2013 at 12:06:58AM -0800, Dmitry Torokhov wrote:
> > > On Sat, Jan 05, 2013 at 01:15:08PM +0530, Laxman Dewangan wrote:
> > [...]
> > > > @@ -735,25 +738,16 @@ static int tegra_kbc_probe(struct platform_de=
vice *pdev)
> > > >  	spin_lock_init(&kbc->lock);
> > > >  	setup_timer(&kbc->timer, tegra_kbc_keypress_timer, (unsigned long=
)kbc);
> > > > =20
> > > > -	res =3D request_mem_region(res->start, resource_size(res), pdev->=
name);
> > > > -	if (!res) {
> > > > -		dev_err(&pdev->dev, "failed to request I/O memory\n");
> > > > -		err =3D -EBUSY;
> > > > -		goto err_free_mem;
> > > > -	}
> > > > -
> > > > -	kbc->mmio =3D ioremap(res->start, resource_size(res));
> > > > +	kbc->mmio =3D devm_request_and_ioremap(&pdev->dev, res);
> > > >  	if (!kbc->mmio) {
> > > > -		dev_err(&pdev->dev, "failed to remap I/O memory\n");
> > > > -		err =3D -ENXIO;
> > > > -		goto err_free_mem_region;
> > > > +		dev_err(&pdev->dev, "Cannot request memregion/iomap address\n");
> > > > +		return -EADDRNOTAVAIL;
> > >=20
> > > Erm, no, -EBUSY please.
> >=20
> > EADDRNOTAVAIL is the canonical error for devm_request_and_ioremap()
> > failure. The kerneldoc comment in lib/devres.c even gives a short
> > example that uses this error code.
>=20
> I am sorry, but I do not consider a function that was added a little
> over a year ago as a canon. If you look at the uses of EADDRNOTAVAIL it
> is used predominantly in networking code to indicate that attempted
> _network_ address is not available.

EBUSY might be misleading, though. devm_request_and_ioremap() can fail
in both the request_mem_region() and ioremap() calls. Furthermore it'd
be good to settle on a consistent error-code instead of doing it
differently depending on subsystem and/or driver. Currently the various
error codes used are:

	EBUSY, EADDRNOTAVAIL, ENXIO, ENOMEM, ENODEV, ENOENT, EINVAL,
	EIO, EFAULT, EADDRINUSE

Also if we can settle on one error code we should follow up with a patch
to make it consistent across the tree and also update that kerneldoc
comment. I volunteer to do that if nobody else steps up. I'm also Cc'ing
Wolfram (the original author), maybe he has some thoughts on this.

Thierry

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7RdBAAoJEN0jrNd/PrOh0KEP/0IHiXOk8Csr1OOXsTv8Rs8g
SdJ9H7y/a/Qc+O1pSA29uTBFVFl7y0fhpzvFAGWXJOl/AAbeBMW+as9gsW0hcO5I
mfNl6j+99egfm2yxf6EDXLXIKylH92Zr+bHGZyqj4So2vpUODmxvFs3WPcuCXqiL
EGQKOpt89EzxWIRCMViEc+cZ4hphmm0kqZ6fFc0iGI2zUa/Syao8lTsmmHomqD1p
1mgH3SCSSolS6X/NY1DXkoMU8V3l94SXcuTGUxY8w/c0UlV0wNhh+KLIVTh8feq9
TwRkhSRZIHz7MTCRW34JWf/KUr55fuWDEOm+Ndyf7H1A1X17G8YJY+PnfZR2V0P8
hfT07HvpPLjNE6MCl8Ve3qFuWkCnVxWhiE8P6bzSPBRQ3yBjbK4T5kDaeTS8ehiH
3siBNi1evqjSI0kx2vFbaOhDqup5QVNreiBCWnG6euazuGXIoASgK7ya5Vatj9gy
x943j9SDZAft3TvWCmJ1PkLiUyDQKNOLqJbM6VA8xj10/KpSjwz+XQ62X+sAZJp6
kDUxsW3jsonvXwTCfjRy5PvQJ6rxgQ1Zyr/f7Ajc+7UFGnC2YFH71Gm1835nsNC0
f0Hx9GbIK5gwXTe+9oAxhh2oLc5YV4ap11pifeVd4fYIdG6WGty1K+t/8QdcB8Mu
ux4f6Vtt0sKs9N5kstMd
=ljO5
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
