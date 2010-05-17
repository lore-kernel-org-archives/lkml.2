Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab0EQJZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:25:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48778 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab0EQJZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:25:01 -0400
Date: Mon, 17 May 2010 11:24:57 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [PATCH] leds-lp3944: properly handle lp3944_configure fail in
	lp3944_probe
Message-ID: <20100517092457.GD22781@pengutronix.de>
References: <1274060042.17226.2.camel@mola> <20100517111513.f76c0bb9.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9UV9rz0O2dU/yYYn"
Content-Disposition: inline
In-Reply-To: <20100517111513.f76c0bb9.ospite@studenti.unina.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9UV9rz0O2dU/yYYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 17, 2010 at 11:15:13AM +0200, Antonio Ospite wrote:
> On Mon, 17 May 2010 09:34:02 +0800
> Axel Lin <axel.lin@gmail.com> wrote:
>=20
> > In current implementation, lp3944_probe return 0 even if lp3944_configu=
re fail.
> > Therefore, led_classdev_unregister will be executed twice ( in error ha=
ndling of lp3944_configure and lp3944_remove ).
> > This patch properly handles lp3944_configure fail in lp3944_probe.
> >
>=20
> Hi Axel, thanks for the fix, I agree it's needed.
> There are some minor comments inlined below.
>=20
> Plus, when possible, I prefer commit messages to be wrapped to 72/80
> characters per line. Please, consider this if you are sending a v2.
>=20
> Ah, may I ask where you are using this driver? Just curious.
>=20
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > ---
> >  drivers/leds/leds-lp3944.c |   10 +++++++++-
> >  1 files changed, 9 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/drivers/leds/leds-lp3944.c b/drivers/leds/leds-lp3944.c
> > index 8d5ecce..03a24d0 100644
> > --- a/drivers/leds/leds-lp3944.c
> > +++ b/drivers/leds/leds-lp3944.c
> > @@ -379,6 +379,7 @@ static int __devinit lp3944_probe(struct i2c_client=
 *client,
> >  {
> >  	struct lp3944_platform_data *lp3944_pdata =3D client->dev.platform_da=
ta;
> >  	struct lp3944_data *data;
> > +	int err;
> > =20
> >  	if (lp3944_pdata =3D=3D NULL) {
> >  		dev_err(&client->dev, "no platform data\n");
> > @@ -403,8 +404,15 @@ static int __devinit lp3944_probe(struct i2c_clien=
t *client,
> > =20
> >  	dev_info(&client->dev, "lp3944 enabled\n");
> > =20
> > -	lp3944_configure(client, data, lp3944_pdata);
> > +	err =3D lp3944_configure(client, data, lp3944_pdata);
> > +	if (err < 0)
> > +		goto err_configure;
> > +
>=20
> The dev_info(&client->dev, "lp3944 enabled\n"); could now go right
> here, before the return 0, so we don't report the driver as enabled
> even in the case its probe fails.
>=20
> >  	return 0;
> > +
> > +err_configure:
> > +	kfree(data);
>=20
> add i2c_set_clientdata(client, NULL) here just like in lp3944_remove()

Just to note:
This is not needed anymore, the i2c-core does this meanwhile for the driver=
s.
I am preparing a cleanup patch fixing this in all drivers for -rc1.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--9UV9rz0O2dU/yYYn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvxC2kACgkQD27XaX1/VRu+EACgiccWprdSdalYtXcYCfDGLg10
0fcAn3gLTc7G5sjsRW4+Z+QK0Pj4zW9q
=BXCx
-----END PGP SIGNATURE-----

--9UV9rz0O2dU/yYYn--
